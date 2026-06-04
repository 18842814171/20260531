#include "os.h"
#include "osviz_k.h"
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
	char d[128];

	snprintf(d, sizeof(d),
		 "\"sepc\":\"0x%lx\",\"gp\":\"0x%lx\",\"kernel_gp\":\"0x%lx\",\"depth\":%d",
		 (unsigned long)sepc, (unsigned long)gp,
		 (unsigned long)kernel_gp_value, kernel_trap_depth);
	osviz_event("trap-diag", "vector_entry", d);
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
	char d[192];

#ifdef CONFIG_OPENSBI
	snprintf(d, sizeof(d),
		 "\"tag\":\"%s\",\"scause\":\"0x%lx\",\"stval\":\"0x%lx\","
		 "\"sepc\":\"0x%lx\",\"sstatus\":\"0x%lx\",\"sscratch\":\"0x%lx\"",
		 tag ? tag : "",
		 (unsigned long)r_scause(), (unsigned long)r_stval(),
		 (unsigned long)r_sepc(), (unsigned long)r_sstatus(),
		 (unsigned long)r_sscratch());
	osviz_event("trap-diag", "csr", d);
#else
	(void)tag;
	osviz_event("trap-diag", "csr", "\"note\":\"CONFIG_OPENSBI only\"");
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
	char d[256];

	if (!cxt)
		return;

	snprintf(d, sizeof(d),
		 "\"frame\":\"%s\",\"fault_epc\":\"0x%lx\",\"region\":\"%s\","
		 "\"ra\":\"0x%lx\",\"sp\":\"0x%lx\",\"gp\":\"0x%lx\","
		 "\"saved_pc\":\"0x%lx\",\"t6\":\"0x%lx\"",
		 frame_name(cxt), (unsigned long)fault_epc, pc_region(fault_epc),
		 (unsigned long)cxt->ra, (unsigned long)cxt->sp,
		 (unsigned long)cxt->gp, (unsigned long)cxt->pc,
		 (unsigned long)cxt->t6);
	osviz_event("trap-diag", "fault_frame", d);
	if (cxt->ra == fault_epc)
		osviz_event("trap-diag", "hint", "\"ra_eq_fault_epc\":true");
}

static int epc_in_kernel_text(reg_t epc)
{
	return epc >= (reg_t)TEXT_START && epc < (reg_t)TEXT_END;
}

void trap_diag_trap_pre(reg_t epc, reg_t sscratch)
{
#if TRAP_DIAG_VERBOSE
	const char *mode;
	char d[128];

	mode = epc_in_user(epc) ? "user" : "kernel";
	snprintf(d, sizeof(d),
		 "\"pid\":%d,\"mode\":\"%s\",\"epc\":\"0x%lx\",\"sscratch\":\"0x%lx\","
		 "\"phase\":\"pre_swap\"",
		 proc_current_pid(), mode, (unsigned long)epc,
		 (unsigned long)sscratch);
	osviz_event("trap", "enter", d);

	if (epc_in_kernel_text(epc) && sscratch != 0) {
		snprintf(d, sizeof(d),
			 "\"epc\":\"0x%lx\",\"sscratch\":\"0x%lx\",\"pid\":%d",
			 (unsigned long)epc, (unsigned long)sscratch,
			 proc_current_pid());
		osviz_event("trap", "invariant_fail", d);
		trap_diag_print_csrs("invariant-kernel-sscratch");
		panic("kernel trap with sscratch != 0");
	}
#endif
	(void)epc;
	(void)sscratch;
}

void trap_diag_trap_enter(reg_t epc, reg_t cause, struct context *cxt)
{
	const char *kind;
	reg_t sscratch_now;
	const char *mode;
	char d[192];

	if (!TRAP_DIAG_VERBOSE || !trap_diag_interesting(epc, cause, cxt))
		return;

	kind = (cause & CAUSE_MASK_INTERRUPT) ? "irq" : "sync";
	sscratch_now = r_sscratch();
	mode = epc_in_user(epc) ? "user" : "kernel";

	snprintf(d, sizeof(d),
		 "\"pid\":%d,\"mode\":\"%s\",\"epc\":\"0x%lx\",\"sscratch\":\"0x%lx\","
		 "\"frame\":\"%s\",\"kind\":\"%s\",\"code\":%ld",
		 proc_current_pid(), mode, (unsigned long)epc,
		 (unsigned long)sscratch_now, frame_name(cxt), kind,
		 (long)(cause & CAUSE_MASK_ECODE));
	osviz_event("trap", "enter", d);
}

void trap_diag_post_handler(reg_t ret_epc)
{
	char d[128];

	if (!TRAP_DIAG_VERBOSE)
		return;

	if (!epc_in_user(ret_epc))
		return;

	snprintf(d, sizeof(d),
		 "\"ret_sepc\":\"0x%lx\",\"sscratch\":\"0x%lx\",\"sstatus\":\"0x%lx\"",
		 (unsigned long)ret_epc, (unsigned long)r_sscratch(),
		 (unsigned long)r_sstatus());
	osviz_event("trap-diag", "leave_handler", d);
}

void trap_diag_trap_return(reg_t sepc, struct context *frame)
{
	char d[128];

	if (!TRAP_DIAG_VERBOSE)
		return;

	if (!epc_in_user(sepc) && sepc != proc_run_saved_ra(proc_current_pid())
	    && sepc != proc_run_saved_cont(proc_current_pid()))
		return;

	snprintf(d, sizeof(d),
		 "\"sepc\":\"0x%lx\",\"restore_frame\":\"%s\",\"sscratch\":\"0x%lx\"",
		 (unsigned long)sepc, frame_name(frame),
		 (unsigned long)r_sscratch());
	osviz_event("trap-diag", "return", d);
}

void trap_diag_user_exit_branch(void)
{
	trap_diag_user_exit_count++;
}
