#include "os.h"
#include "trap_csr.h"
#ifdef CONFIG_OPENSBI
#include "riscv.h"
#endif

extern void switch_to(struct context *next);

static void task_idle_loop(void)
{
	for (;;)
		asm volatile("wfi");
}

#define MAX_TASKS 10
#define STACK_SIZE 1024

uint8_t __attribute__((aligned(16))) task_stack[MAX_TASKS][STACK_SIZE];
struct context ctx_tasks[MAX_TASKS];

static int _top = 0;
static int _current = -1;

int sched_task_count(void)
{
	return _top;
}

void sched_init()
{
	trap_ie_enable(TRAP_IE_SOFT);
}

void schedule()
{
	if (_top <= 0) {
		panic("Num of task should be greater than zero!");
		return;
	}

	_current = (_current + 1) % _top;
	struct context *next = &(ctx_tasks[_current]);
	switch_to(next);
}

int task_create(void (*start_routin)(void))
{
	if (_top < MAX_TASKS) {
		ctx_tasks[_top].sp = (reg_t) &task_stack[_top][STACK_SIZE];
		ctx_tasks[_top].pc = (reg_t) start_routin;
		_top++;
		return 0;
	}
	return -1;
}

void task_yield()
{
#ifdef CONFIG_OPENSBI
	w_sip(r_sip() | SIP_SSIP);
#else
	int id = r_mhartid();

	*(uint32_t *)CLINT_MSIP(id) = 1;
#endif
}

void task_exit_to_idle(struct context *cxt, int status)
{
	cxt->a0 = (reg_t)status;
	cxt->pc = (reg_t)task_idle_loop;
}

void task_delay(volatile int count)
{
	count *= 50000;
	while (count--)
		;
}
