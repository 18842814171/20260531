#include "os.h"
#include "stats.h"
#include "osviz_k.h"
#include "syscall.h"
#include "trap_csr.h"
#include "trap_diag.h"

extern void trap_vector(void);
extern void uart_isr(void);
extern void timer_handler(void);
extern void schedule(void);
extern int sched_task_count(void);
extern void do_syscall(struct context *cxt);
extern void task_exit_to_idle(struct context *cxt, int status);
extern int prog_exec_active;
extern int prog_exec_restore_shell;
extern void prog_exec_done(void);
extern struct context shell_save_cxt;

struct context kernel_trap_cxt;
reg_t kernel_gp_value;

static void handle_sync_exception(reg_t cause_code, reg_t epc, struct context *cxt,
				  reg_t *return_pc)
{
	char d[64];

	switch (cause_code) {
	case 8:
	case 9:
		stats_inc_ecall();
		if (cxt->a7 == SYS_exit) {
			if (prog_exec_active) {
				shell_save_cxt.a0 = cxt->a0;
				prog_exec_restore_shell = 1;
				prog_exec_active = 0;
				*return_pc = (reg_t)prog_exec_done;
				osviz_event("proc", "exit", "\"from\":\"prog_exec\"");
			} else {
				task_exit_to_idle(cxt, (int)cxt->a0);
				osviz_event("proc", "exit", NULL);
				*return_pc = cxt->pc;
			}
		} else {
			do_syscall(cxt);
			*return_pc += 4;
		}
		break;
	case 12:
	case 13:
	case 15:
		stats_inc_page_fault();
		snprintf(d, sizeof(d), "\"sepc\":\"0x%lx\",\"cause\":%ld",
			 (long)epc, (long)cause_code);
		osviz_event("irq", "page_fault", d);
		printf("page fault at 0x%lx (cause %ld)\n", (long)epc, (long)cause_code);
		panic("page fault (stub: no VM handler yet)");
		break;
	default:
		snprintf(d, sizeof(d), "\"code\":%ld", (long)cause_code);
		osviz_event("irq", "sync_exception", d);
		printf("Sync exception code = %ld at 0x%lx\n",
		       (long)cause_code, (long)epc);
		trap_diag_print_csrs("panic-sync");
		panic("OOPS! What can I do!");
	}
}

void trap_init()
{
	asm volatile("mv %0, gp" : "=r"(kernel_gp_value));
	trap_vec_init((reg_t)trap_vector);
	trap_scratch_init((reg_t)&kernel_trap_cxt);
}

void trap_use_kernel_cxt(void)
{
	trap_scratch_init((reg_t)&kernel_trap_cxt);
}

void external_interrupt_handler()
{
	int irq = plic_claim();

	stats_inc_ext_irq();

	if (irq == UART0_IRQ) {
		uart_isr();
	} else if (irq) {
		printf("unexpected interrupt irq = %d\n", irq);
	}

	if (irq)
		plic_complete(irq);
}

reg_t trap_handler(reg_t epc, reg_t cause, struct context *cxt)
{
	reg_t return_pc = epc;
	reg_t cause_code = cause & CAUSE_MASK_ECODE;

	/* User ELF may run with gp=0; restore kernel gp before touching globals. */
	asm volatile("mv gp, %0" :: "r"(kernel_gp_value) : "memory");
#ifdef CONFIG_OPENSBI
	reg_t irq_was_on = r_sstatus() & SSTATUS_SIE;
#else
	reg_t irq_was_on = r_mstatus() & MSTATUS_MIE;
#endif

	cpu_irq_disable();

	trap_diag_trap_enter(epc, cause, cxt);

	if (cause & CAUSE_MASK_INTERRUPT) {
		switch (cause_code) {
		case TRAP_IRQ_SOFT:
			{
				stats_inc_sw_irq();
#ifdef CONFIG_OPENSBI
				w_sip(r_sip() & ~SIP_SSIP);
#else
				int id = r_mhartid();
				*(uint32_t *)CLINT_MSIP(id) = 0;
#endif
				/* Preemptive schedule disabled: switch_to csrw sepc
				 * faults on this OpenSBI build after user ELF. */
				(void)sched_task_count;
			}
			break;
		case TRAP_IRQ_TIMER:
			timer_handler();
			break;
		case TRAP_IRQ_EXTERNAL:
			external_interrupt_handler();
			break;
		default:
			printf("Unknown async trap! Code = %ld\n", (long)cause_code);
			break;
		}
	} else {
		handle_sync_exception(cause_code, epc, cxt, &return_pc);
	}

	if (irq_was_on)
		cpu_irq_enable();

	trap_diag_post_handler(return_pc);
	return return_pc;
}
