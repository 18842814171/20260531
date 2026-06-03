#include "os.h"
#include "trap_diag.h"
#include "trap_csr.h"
#include "proc_user.h"
#include "proc.h"

extern struct context kernel_trap_cxt;

unsigned long trap_diag_user_exit_count;

reg_t read_gp(void)
{
	reg_t g;

	asm volatile("mv %0, gp" : "=r"(g));
	return g;
}

#ifdef CONFIG_TRAP_GP_DIAG
void trap_diag_trap_vector_entry(reg_t sepc, reg_t gp)
{
	printf("[trap-diag] ENTRY sepc=0x%lx gp=0x%lx kernel_gp=0x%lx depth=%d\n",
	       (unsigned long)sepc, (unsigned long)gp,
	       (unsigned long)kernel_gp_value, kernel_trap_depth);
}
#endif

#define USER_CODE_START USER_MEM_BASE
#define USER_CODE_END   USER_MEM_END

static int epc_in_user(reg_t epc)
{
	return epc >= USER_CODE_START && epc < USER_CODE_END;
}

static const char *frame_name(struct context *cxt)
{
	unsigned long p = (unsigned long)cxt;
	struct context *uc = proc_user_ctx(proc_current_pid());

	if (uc && p == (unsigned long)uc)
		return "user_proc";
	if (p == (unsigned long)&kernel_trap_cxt)
		return "kernel_trap_cxt";
	return "other";
}

static int trap_diag_interesting(reg_t epc, reg_t cause, struct context *cxt)
{
	if (!(cause & CAUSE_MASK_INTERRUPT))
		return 1;
	if (epc_in_user(epc))
		return 1;
	if (proc_user_ctx(proc_current_pid()) &&
	    (unsigned long)cxt == (unsigned long)proc_user_ctx(proc_current_pid()))
		return 1;
	return 0;
}

void trap_diag_print_csrs(const char *tag)
{
#ifdef CONFIG_OPENSBI
	printf("[trap-diag] %s scause=0x%lx stval=0x%lx sepc=0x%lx "
	       "sstatus=0x%lx sscratch=0x%lx\n",
	       tag,
	       (unsigned long)r_scause(),
	       (unsigned long)r_stval(),
	       (unsigned long)r_sepc(),
	       (unsigned long)r_sstatus(),
	       (unsigned long)r_sscratch());
#else
	(void)tag;
	printf("[trap-diag] %s (CONFIG_OPENSBI only CSR dump)\n", tag);
#endif
}

extern ptr_t TEXT_START;
extern ptr_t TEXT_END;
extern ptr_t RODATA_START;
extern ptr_t RODATA_END;

static const char *pc_region(reg_t pc)
{
	if (pc >= (reg_t)TEXT_START && pc < (reg_t)TEXT_END)
		return ".text";
	if (pc >= (reg_t)RODATA_START && pc < (reg_t)RODATA_END)
		return ".rodata";
	if (pc >= USER_CODE_START && pc < USER_CODE_END)
		return "user";
	return "?";
}

void trap_diag_print_fault_frame(reg_t fault_epc, struct context *cxt)
{
	if (!cxt)
		return;

	printf("[trap-diag] fault frame (%s) fault_epc=0x%lx (%s)\n",
	       frame_name(cxt), (unsigned long)fault_epc, pc_region(fault_epc));
	printf("  ra=0x%lx (%s) sp=0x%lx gp=0x%lx\n",
	       (unsigned long)cxt->ra, pc_region(cxt->ra),
	       (unsigned long)cxt->sp, (unsigned long)cxt->gp);
	printf("  saved_pc(sepc slot)=0x%lx (%s) t6=0x%lx\n",
	       (unsigned long)cxt->pc, pc_region(cxt->pc),
	       (unsigned long)cxt->t6);
	if (cxt->ra == fault_epc)
		printf("[trap-diag] hint: ra == fault_epc (bad ret into fault site?)\n");
}

static int epc_in_kernel_text(reg_t epc)
{
	return epc >= (reg_t)TEXT_START && epc < (reg_t)TEXT_END;
}

void trap_diag_trap_pre(reg_t epc, reg_t sscratch)
{
	const char *mode;
	struct context *uc;

	mode = epc_in_user(epc) ? "user" : "kernel";

	if (TRAP_DIAG_VERBOSE) {
		printf("trap: pid=%d mode=%s epc=0x%lx sscratch=0x%lx (pre-swap)\n",
		       proc_current_pid(), mode, (unsigned long)epc,
		       (unsigned long)sscratch);
	}

	if (epc_in_kernel_text(epc) && sscratch != 0) {
		printf("INVARIANT FAIL: kernel epc 0x%lx sscratch=0x%lx pid=%d\n",
		       (unsigned long)epc, (unsigned long)sscratch,
		       proc_current_pid());
		trap_diag_print_csrs("invariant-kernel-sscratch");
		panic("kernel trap with sscratch != 0");
	}

	if (sscratch != 0) {
		uc = proc_user_ctx_by_kstack_top(sscratch);
		if (!epc_in_user(epc)) {
			printf("INVARIANT FAIL: sscratch=0x%lx epc=0x%lx not user pid=%d\n",
			       (unsigned long)sscratch, (unsigned long)epc,
			       proc_current_pid());
			trap_diag_print_csrs("invariant-user-epc");
			panic("sscratch set but epc not in user");
		}
		if (!uc) {
			printf("INVARIANT FAIL: sscratch=0x%lx matches no proc kstack\n",
			       (unsigned long)sscratch);
			panic("sscratch kstack orphan");
		}
		if (uc->pc != 0 && !epc_in_user(uc->pc)) {
			printf("INVARIANT FAIL: sscratch=0x%lx saved pc=0x%lx not user\n",
			       (unsigned long)sscratch, (unsigned long)uc->pc);
			panic("sscratch with bad saved user pc");
		}
	}
}

void trap_diag_trap_enter(reg_t epc, reg_t cause, struct context *cxt)
{
	const char *kind;
	reg_t sscratch_now;
	const char *mode;

	if (!TRAP_DIAG_VERBOSE || !trap_diag_interesting(epc, cause, cxt))
		return;

	kind = (cause & CAUSE_MASK_INTERRUPT) ? "irq" : "sync";
	sscratch_now = r_sscratch();
	mode = epc_in_user(epc) ? "user" : "kernel";

	printf("trap: pid=%d mode=%s epc=0x%lx sscratch=0x%lx frame=%s "
	       "kind=%s code=%ld\n",
	       proc_current_pid(), mode, (unsigned long)epc,
	       (unsigned long)sscratch_now, frame_name(cxt), kind,
	       (long)(cause & CAUSE_MASK_ECODE));
}

void trap_diag_post_handler(reg_t ret_epc)
{
	if (!TRAP_DIAG_VERBOSE)
		return;

	if (epc_in_user(ret_epc))
		printf("[trap-diag] LEAVE trap_handler ret_sepc=0x%lx "
		       "sscratch=0x%lx sstatus=0x%lx\n",
		       (unsigned long)ret_epc,
		       (unsigned long)r_sscratch(),
		       (unsigned long)r_sstatus());
}

static void trap_diag_put_hex(reg_t v)
{
	char buf[20];
	int i = 0;

	if (v == 0) {
		uart_puts("0");
		return;
	}
	while (v > 0 && i < (int)sizeof(buf)) {
		buf[i++] = "0123456789abcdef"[v & 0xf];
		v >>= 4;
	}
	uart_puts("0x");
	while (i > 0)
		uart_putc(buf[--i]);
}

void trap_diag_trap_return(reg_t sepc, struct context *frame)
{
	if (!epc_in_user(sepc) && sepc != proc_run_saved_ra(proc_current_pid()))
		return;

	uart_puts("[trap-diag] RETURN sepc=");
	trap_diag_put_hex(sepc);
	uart_puts(" restore_frame=");
	uart_puts((char *)frame_name(frame));
	uart_puts(" sscratch=");
	trap_diag_put_hex(r_sscratch());
	uart_putc('\n');
}

void trap_diag_user_exit_branch(void)
{
	trap_diag_user_exit_count++;
}
