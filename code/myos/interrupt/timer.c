#include "os.h"
#include "stats.h"
#include "trap_csr.h"
#ifdef CONFIG_OPENSBI
#include "sbi.h"
#endif

extern void schedule(void);
extern struct context kernel_trap_cxt;

extern ptr_t TEXT_START;
extern ptr_t TEXT_END;

/* task.md §2: stable ~100 Hz timer interrupt */
#define TIMER_INTERVAL (CLINT_TIMEBASE_FREQ / 100)

static uint32_t _tick = 0;

#define MAX_TIMER 10
static struct timer timer_list[MAX_TIMER];
/* P3 (01.txt): guard against timer_list overrun into kernel_trap_cxt */
static char timer_guard[256];

static int timer_func_in_text(void (*func)(void *))
{
	reg_t pc = (reg_t)(void *)func;

	return pc >= (reg_t)TEXT_START && pc < (reg_t)TEXT_END;
}

static void timer_reject_bad_callback(int i, void (*func)(void *), void *arg)
{
	printf("timer[%d] func=%p arg=%p\n", i, (void *)func, arg);
	printf("bad timer callback: %p (not in .text)\n", (void *)func);
	panic("bad timer callback");
}

void timer_load(int interval)
{
#ifdef CONFIG_OPENSBI
	sbi_set_timer(r_time() + (uint64_t)interval);
#else
	int id = r_mhartid();

	*(uint64_t *)CLINT_MTIMECMP(id) = *(uint64_t *)CLINT_MTIME + interval;
#endif
}

void timer_init(void)
{
	struct timer *t = &(timer_list[0]);
	int i;

	for (i = 0; i < MAX_TIMER; i++) {
		t->func = NULL;
		t->arg = NULL;
		t++;
	}

	boot_printf("timer_list=%p size=%lu\n", (void *)timer_list,
		    (unsigned long)(MAX_TIMER * sizeof(struct timer)));
	boot_printf("timer_guard=%p..%p\n", (void *)timer_guard,
		    (void *)(timer_guard + sizeof(timer_guard)));
	boot_printf("kernel_trap_cxt=%p size=%lu\n", (void *)&kernel_trap_cxt,
		    (unsigned long)sizeof(struct context));

	timer_load(TIMER_INTERVAL);
	trap_ie_enable(TRAP_IE_TIMER);
}

struct timer *timer_create(void (*handler)(void *arg), void *arg, uint32_t timeout)
{
	if (NULL == handler || 0 == timeout)
		return NULL;

	if (!timer_func_in_text(handler))
		panic("timer_create: handler not in .text");

	spin_lock();

	struct timer *t = &(timer_list[0]);
	for (int i = 0; i < MAX_TIMER; i++) {
		if (NULL == t->func)
			break;
		t++;
	}
	if (NULL != t->func) {
		spin_unlock();
		return NULL;
	}

	t->func = handler;
	t->arg = arg;
	t->timeout_tick = _tick + timeout;

	spin_unlock();
	return t;
}

void timer_delete(struct timer *timer)
{
	spin_lock();

	struct timer *t = &(timer_list[0]);
	for (int i = 0; i < MAX_TIMER; i++) {
		if (t == timer) {
			t->func = NULL;
			t->arg = NULL;
			break;
		}
		t++;
	}

	spin_unlock();
}

static inline void timer_check(void)
{
	struct timer *t = &(timer_list[0]);

	for (int i = 0; i < MAX_TIMER; i++) {
		if (t->func != NULL) {
			printf("timer[%d] func=%p arg=%p\n", i,
			       (void *)t->func, t->arg);
			if (!timer_func_in_text(t->func))
				timer_reject_bad_callback(i, t->func, t->arg);
			if (_tick >= t->timeout_tick) {
				printf("calling %p\n", (void *)t->func);
				t->func(t->arg);
				t->func = NULL;
				t->arg = NULL;
				break;
			}
		}
		t++;
	}
}

void timer_handler(void)
{
	_tick++;
	stats_inc_timer();
	timer_check();
	script_bg_poll();
	timer_load(TIMER_INTERVAL);

	/* Avoid switch_to (CSR writes) while user programs may be active. */
	(void)sched_task_count;
}
