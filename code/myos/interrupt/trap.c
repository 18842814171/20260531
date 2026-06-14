#include "os.h"
#include "stats.h"
#include "osviz_k.h"
#include "syscall.h"
#include "trap_csr.h"
#include "trap_diag.h"
#include "proc_user.h"
#include "proc.h"
#include "vm.h"

extern void trap_vector(void);
extern void timer_handler(void);
extern void schedule(void);
extern int sched_task_count(void);
extern void do_syscall(struct context *cxt);
extern void task_exit_to_idle(struct context *cxt, int status);
int trap_reenable_irq;
int trap_return_to_user;

struct context kernel_trap_cxt;
reg_t kernel_gp_value;

volatile int kernel_trap_depth;
volatile int kernel_trap_busy;

/* Must match proc/sched.c */
#define SCHED_MAX_TASKS  10
#define SCHED_STACK_SIZE 1024

extern uint8_t task_stack[][SCHED_STACK_SIZE];

extern ptr_t TEXT_START;
extern ptr_t TEXT_END;
extern ptr_t RODATA_START;
extern ptr_t RODATA_END;

static int epc_in_user(reg_t epc)
{
	return epc >= USER_MEM_BASE && epc < USER_MEM_END;
}

static int epc_in_kernel_text(reg_t epc)
{
	return epc >= (reg_t)TEXT_START && epc < (reg_t)TEXT_END;
}

static int pc_in_rodata(reg_t pc)
{
	return pc >= (reg_t)RODATA_START && pc < (reg_t)RODATA_END;
}

static reg_t task_stack_lo(void)
{
	return (reg_t)&task_stack[0][0];
}

static reg_t task_stack_hi(void)
{
	return task_stack_lo() + (reg_t)SCHED_MAX_TASKS * SCHED_STACK_SIZE;
}

static int pc_in_task_stack(reg_t pc)
{
	return pc >= task_stack_lo() && pc < task_stack_hi();
}

static void trap_log_first_return(reg_t return_pc, reg_t trap_epc)
{
	char d[128];
	reg_t cause;

	/*
	 * problemrecord check #1: log outer trap return (depth==1) before
	 * entry.S "csrw CSR_EPC, a0" — a0 == trap_handler return value.
	 */
	if (kernel_trap_depth != 1)
		return;

	cause = r_scause();
	if ((cause & CAUSE_MASK_INTERRUPT) &&
	    (cause & CAUSE_MASK_ECODE) == TRAP_IRQ_TIMER)
		return;

	snprintf(d, sizeof(d),
		 "\"depth\":1,\"return_pc\":\"0x%lx\",\"trap_epc\":\"0x%lx\","
		 "\"cause\":\"0x%lx\"",
		 (long)return_pc, (long)trap_epc, (long)cause);
	LOG_TRAP("leave", d);
}

static void trap_check_return_pc(reg_t return_pc, reg_t trap_epc)
{
	char *why;

	trap_log_first_return(return_pc, trap_epc);

	if (epc_in_kernel_text(return_pc) || epc_in_user(return_pc))
		return;

	if (pc_in_rodata(return_pc))
		why = "return_pc in rodata";
	else if (pc_in_task_stack(return_pc))
		why = "return_pc in task_stack";
	else
		why = "return_pc not in kernel .text or user";

	printf("%s: 0x%lx (trap epc=0x%lx)\n", why, (long)return_pc, (long)trap_epc);
	trap_diag_print_csrs("bad-return_pc");
	panic(why);
}

static int trap_from_user(void)
{
#ifdef CONFIG_OPENSBI
	return !(r_sstatus() & SSTATUS_SPP);
#else
	return (r_mstatus() & MSTATUS_MPP) == 0;
#endif
}

static void handle_sync_exception(reg_t cause_code, reg_t epc, struct context *cxt,
				  reg_t *return_pc)
{
	char d[64];
	int pid;

	switch (cause_code) {
	case 8:
	case 9:
		stats_inc_ecall();
		if (cxt->a7 == SYS_exit) {
			pid = proc_current_pid();
			if (pid > 0) {
				*return_pc = proc_user_exit_trap(cxt);
#ifdef CONFIG_OPENSBI
				w_sstatus(r_sstatus() | SSTATUS_SPP);
#endif
				LOG_PROC("exit", "\"from\":\"user\"");
			} else {
				task_exit_to_idle(cxt, (int)cxt->a0);
				LOG_PROC("exit", NULL);
				*return_pc = cxt->pc;
			}
		} else if (cxt->a7 == SYS_yield && proc_current_pid() > 0) {
			*return_pc = proc_user_yield_trap(cxt);
#ifdef CONFIG_OPENSBI
			w_sstatus(r_sstatus() | SSTATUS_SPP);
#endif
		} else {
			int was_execve = (cxt->a7 == SYS_execve);

			do_syscall(cxt);
			if (was_execve && (long)cxt->a0 == 0) {
				int cpid = proc_current_pid();
				struct context *uc = proc_user_ctx(cpid);
				reg_t ktop = proc_kstack_top(cpid);

				if (uc && ktop) {
					proc_set_state(cpid, PROC_RUNNING);
					proc_activate_user(cpid);
					proc_enter_uspace(cpid, uc, ktop);
				}
			} else {
				*return_pc += 4;
			}
		}
		break;
	case 12:
	case 13:
	case 15:
		stats_inc_page_fault();
		pid = proc_current_pid();
		if (trap_from_user() && pid > 0 &&
		    vm_fault_handle(pid, (uint64_t)r_stval(), cause_code) == 0) {
			*return_pc = epc;
			break;
		}
		if (trap_from_user() && pid > 0) {
			snprintf(d, sizeof(d),
				 "\"pid\":%d,\"sepc\":\"0x%lx\",\"stval\":\"0x%lx\",\"cause\":%ld",
				 pid, (long)epc, (long)r_stval(), (long)cause_code);
			LOG_PROC("fault_kill", d);
			printf("user fault: killed pid=%d sepc=0x%lx stval=0x%lx cause=%ld\n",
			       pid, (long)epc, (long)r_stval(), (long)cause_code);
			*return_pc = proc_user_fault_trap(cxt);
#ifdef CONFIG_OPENSBI
			w_sstatus(r_sstatus() | SSTATUS_SPP);
#endif
			break;
		}
		snprintf(d, sizeof(d), "\"sepc\":\"0x%lx\",\"stval\":\"0x%lx\",\"cause\":%ld",
			 (long)epc, (long)r_stval(), (long)cause_code);
		LOG_IRQ("page_fault", d);
		printf("page fault pid=%d current=%d sepc=0x%lx stval=0x%lx cause=%ld (unhandled)\n",
		       pid, proc_current_pid(), (long)epc, (long)r_stval(), (long)cause_code);
		trap_diag_print_fault_frame(epc, cxt);
		trap_check_return_pc(epc, epc);
		panic("page fault");
		break;
	default:
		snprintf(d, sizeof(d), "\"code\":%ld", (long)cause_code);
		LOG_IRQ("sync_exception", d);
		printf("Sync exception code = %ld at 0x%lx\n",
		       (long)cause_code, (long)epc);
		trap_diag_print_fault_frame(epc, cxt);
		trap_check_return_pc(epc, epc);
		trap_diag_print_csrs("panic-sync");
		panic("OOPS! What can I do!");
	}
}

void trap_init(void)
{
	/*
	 * Save kernel global pointer for trap_handler (user ELF may use gp=0).
	 * Requires gp valid before this call — if start.S never sets gp,
	 * kernel_gp_value stays 0 and trap_handler will keep forcing gp=0.
	 */
	asm volatile("mv %0, gp" : "=r"(kernel_gp_value));
	printf("trap_init: kernel_gp=0x%lx\n", (unsigned long)kernel_gp_value);
	if (kernel_gp_value == 0)
		panic("kernel_gp_value is 0 (fix start.S la gp, __global_pointer$)");
	trap_vec_init((reg_t)trap_vector);
	trap_scratch_init(0);
#ifdef CONFIG_OPENSBI
	w_sstatus(r_sstatus() | SSTATUS_SUM);
#endif
}

void trap_use_kernel_cxt(void)
{
	trap_scratch_init(0);
}

/*
 * Nested timer while kernel_trap_busy: do not reg_save over kernel_trap_cxt.
 * Called from entry.S fast path only.
 */
void trap_nested_timer_ack(void)
{
	timer_handler();
}

void external_interrupt_handler()
{
	int irq = plic_claim();

	stats_inc_ext_irq();

	if (irq == UART0_IRQ) {
		uart_irq_handler();
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
#ifdef CONFIG_OPENSBI
	reg_t irq_was_on = r_sstatus() & SSTATUS_SIE;
#else
	reg_t irq_was_on = r_mstatus() & MSTATUS_MIE;
#endif

	/* User ELF may run with gp=0; restore kernel gp before touching globals. */
	asm volatile("mv gp, %0" :: "r"(kernel_gp_value) : "memory");
	cpu_irq_disable();

	kernel_trap_depth++;
	/* Experiment B: report nested kernel traps (depth > 1). */
	if (kernel_trap_depth > 1) {
		char d[96];

		snprintf(d, sizeof(d),
			 "\"depth\":%d,\"epc\":\"0x%lx\",\"cause\":\"0x%lx\"",
			 kernel_trap_depth, (long)epc, (long)cause);
		LOG_TRAP("enter_nested", d);
	}

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

	/*
	 * Defer IRQ until after reg_restore in trap_vector. Only re-enable SIE
	 * before sret when returning to user (or user-exit trampoline). Re-enabling
	 * on kernel return (e.g. uart_getc poll) lets timer IRQ nest during
	 * reg_restore and corrupt sepc (illegal insn in BSS).
	 */
	trap_reenable_irq = 0;
	trap_return_to_user = epc_in_user(return_pc);
	if (irq_was_on && trap_return_to_user)
		trap_reenable_irq = 1;

	/*
	 * Syscall paths leave the kernel page table active (proc_user_trap_return
	 * and proc_user_exit_trap both switch to it). sret back to user needs
	 * it). sret back to user needs the current process user mappings.
	 */
	if (trap_return_to_user) {
		int apid = proc_current_pid();
		enum proc_state st = proc_get_state(apid);

		if (apid > 0 && st != PROC_ZOMBIE && st != PROC_UNUSED &&
		    proc_pagetable(apid))
			proc_activate_user(apid);
		else
			proc_activate_kernel();
	}

	/* sscratch: 0 in kernel until entry.S sets kstack top right before sret to user. */
	trap_scratch_init(0);

	/* trap_diag_post_handler runs in entry.S after trap_handler returns. */
	trap_check_return_pc(return_pc, epc);

	kernel_trap_depth--;
	return return_pc;
}
