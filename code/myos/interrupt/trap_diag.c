#include "os.h"
#include "trap_diag.h"
#include "trap_csr.h"
#include "proc_user.h"

extern struct context *user_trap_save_cxt;
extern struct context kernel_trap_cxt;
extern struct context kernel_user_exit_cxt;
extern int proc_user_exit_pending;

unsigned long trap_diag_user_exit_count;

#define USER_CODE_START 0x80380000UL
#define USER_CODE_END   0x80400000UL

static int epc_in_user(reg_t epc)
{
	return epc >= USER_CODE_START && epc < USER_CODE_END;
}

static const char *frame_name(struct context *cxt)
{
	unsigned long p = (unsigned long)cxt;

	if (user_trap_save_cxt && p == (unsigned long)user_trap_save_cxt)
		return "user_proc";
	if (p == (unsigned long)&kernel_trap_cxt)
		return "kernel_trap_cxt";
	if (p == (unsigned long)&kernel_user_exit_cxt)
		return "user_exit_cxt";
	return "other";
}

static int trap_diag_interesting(reg_t epc, reg_t cause, struct context *cxt)
{
	if (!(cause & CAUSE_MASK_INTERRUPT))
		return 1;
	if (epc_in_user(epc))
		return 1;
	if (user_trap_save_cxt && (unsigned long)cxt == (unsigned long)user_trap_save_cxt)
		return 1;
	if (proc_user_exit_pending)
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

void trap_diag_trap_enter(reg_t epc, reg_t cause, struct context *cxt)
{
	const char *kind;
	reg_t sscratch_now;

	if (!TRAP_DIAG_VERBOSE || !trap_diag_interesting(epc, cause, cxt))
		return;

	kind = (cause & CAUSE_MASK_INTERRUPT) ? "irq" : "sync";
	sscratch_now = r_sscratch();

	printf("[trap-diag] ENTER %s epc=0x%lx cause=0x%lx code=%ld "
	       "save_frame=%s user_epc=%d sscratch=0x%lx "
	       "user_exit=%d hits=%lu\n",
	       kind, (unsigned long)epc, (unsigned long)cause,
	       (long)(cause & CAUSE_MASK_ECODE),
	       frame_name(cxt), epc_in_user(epc) ? 1 : 0,
	       (unsigned long)sscratch_now,
	       proc_user_exit_pending,
	       trap_diag_user_exit_count);
}

void trap_diag_post_handler(reg_t ret_epc)
{
	if (!TRAP_DIAG_VERBOSE)
		return;

	if (!proc_user_exit_pending && !epc_in_user(ret_epc))
		return;

	printf("[trap-diag] LEAVE trap_handler ret_sepc=0x%lx "
	       "user_exit_flag=%d user_exit_hits=%lu "
	       "sscratch=0x%lx sstatus=0x%lx\n",
	       (unsigned long)ret_epc, proc_user_exit_pending,
	       trap_diag_user_exit_count,
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
	if (!epc_in_user(sepc) && !proc_user_exit_pending)
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
	uart_puts("[trap-diag] USER_EXIT branch #");
	trap_diag_put_hex((reg_t)trap_diag_user_exit_count);
	uart_puts("\n");
}
