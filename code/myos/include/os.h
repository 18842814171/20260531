#ifndef __OS_H__
#define __OS_H__

#include "types.h"
#include "riscv.h"
#include "platform.h"

#include <stddef.h>
#include <stdarg.h>

/* uart (Phase 2: IRQ + ring buffer; see boot/uart.c) */
extern int uart_putc(char ch);
extern void uart_puts(char *s);
extern void uart_rx_flush(void);
extern void uart_rx_flush_deep(void);
extern void uart_rx_drain_quiet(unsigned quiet_need, unsigned max_spin);
extern void uart_irq_enable(void);
extern void uart_irq_handler(void);
extern int uart_try_getc(void);
extern int uart_readc_wait(void);
extern int uart_getc(void);
extern int uart_read_line(char *buf, int maxlen);
extern int uart_prompt_and_read_line(const char *prompt, char *buf, int maxlen);
extern int uart_read_buf(char *buf, int maxlen);
extern void uart_hw_test(void);

/* printf */
extern int  printf(const char* s, ...);
extern int  snprintf(char *out, size_t n, const char *s, ...);
extern void panic(char *s);

/* memory management (5.1 pmm_manager 框架) */
extern void pmm_init(void);
extern void *page_alloc(int npages);
extern void page_free(void *p);

/* task management */
struct context {
	/* ignore x0 */
	reg_t ra;
	reg_t sp;
	reg_t gp;
	reg_t tp;
	reg_t t0;
	reg_t t1;
	reg_t t2;
	reg_t s0;
	reg_t s1;
	reg_t a0;
	reg_t a1;
	reg_t a2;
	reg_t a3;
	reg_t a4;
	reg_t a5;
	reg_t a6;
	reg_t a7;
	reg_t s2;
	reg_t s3;
	reg_t s4;
	reg_t s5;
	reg_t s6;
	reg_t s7;
	reg_t s8;
	reg_t s9;
	reg_t s10;
	reg_t s11;
	reg_t t3;
	reg_t t4;
	reg_t t5;
	reg_t t6;
	// upon is trap frame

	// save the pc to run in next schedule cycle
	reg_t pc; // offset: 31 * sizeof(reg_t)
};

extern int  task_create(void (*task)(void));
extern int  sched_task_count(void);
extern void task_delay(volatile int count);
extern void task_yield(void);
extern void task_exit_to_idle(struct context *cxt, int status);

/* plic */
extern void plic_init(void);
extern void plic_uart_enable(void);
extern int plic_claim(void);
extern void plic_complete(int irq);

/* lock */
extern int spin_lock(void);
extern int spin_unlock(void);

/* software timer */
struct timer {
	void (*func)(void *arg);
	void *arg;
	uint32_t timeout_tick;
};
extern struct timer *timer_create(void (*handler)(void *arg), void *arg, uint32_t timeout);
extern void timer_delete(struct timer *timer);

/* console / demo */
extern void console_run(void);
extern void demo_run_tasks(void);
extern int script_run(const char *path);
extern int script_run_bg(const char *path);
extern void script_bg_poll(void);
/* Fill buf with bg-script status; return 1 if pid is the active bg script job. */
extern int script_bg_describe(int pid, char *buf, int buflen);
extern int vi_edit(const char *path);
extern int proc_spawn_exec_wait(const char *path);
extern int proc_spawn_exec_bg(const char *path);
extern int prog_is_elf_path(const char *path);
extern void trap_use_kernel_cxt(void);
extern void proc_spawn_worker_demo(void);
extern void machine_poweroff(void) __attribute__((noreturn));

#endif /* __OS_H__ */
