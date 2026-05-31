#include "os.h"
#include "stats.h"
#include "trap_csr.h"
#ifdef CONFIG_OPENSBI
#include "sbi.h"
#endif

extern void schedule(void);

/* task.md §2: stable ~100 Hz timer interrupt */
#define TIMER_INTERVAL (CLINT_TIMEBASE_FREQ / 100)

static uint32_t _tick = 0;

#define MAX_TIMER 10
static struct timer timer_list[MAX_TIMER];

void timer_load(int interval)
{
#ifdef CONFIG_OPENSBI
	sbi_set_timer(r_time() + (uint64_t)interval);
#else
	int id = r_mhartid();

	*(uint64_t*)CLINT_MTIMECMP(id) = *(uint64_t*)CLINT_MTIME + interval;
#endif
}

void timer_init()
{
	struct timer *t = &(timer_list[0]);
	for (int i = 0; i < MAX_TIMER; i++) {
		t->func = NULL;
		t->arg = NULL;
		t++;
	}

	timer_load(TIMER_INTERVAL);
	trap_ie_enable(TRAP_IE_TIMER);
}

struct timer *timer_create(void (*handler)(void *arg), void *arg, uint32_t timeout)
{
	if (NULL == handler || 0 == timeout)
		return NULL;

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

static inline void timer_check()
{
	struct timer *t = &(timer_list[0]);
	for (int i = 0; i < MAX_TIMER; i++) {
		if (NULL != t->func) {
			if (_tick >= t->timeout_tick) {
				t->func(t->arg);
				t->func = NULL;
				t->arg = NULL;
				break;
			}
		}
		t++;
	}
}

void timer_handler()
{
	_tick++;
	stats_inc_timer();
	timer_check();
	timer_load(TIMER_INTERVAL);

	/* Avoid switch_to (CSR writes) while user programs may be active. */
	(void)sched_task_count;
}
