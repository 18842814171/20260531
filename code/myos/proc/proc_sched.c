#include "os.h"
#include "proc.h"
#include "proc_user.h"
#include "proc_sched.h"
#include "trap_csr.h"
#include "osviz_k.h"

static struct wait_queue child_wait_wq[PROC_MAX];
static int wq_slot_next[PROC_MAX];

static void wq_enqueue(struct wait_queue *wq, int pid)
{
	int slot = proc_slot_by_pid(pid);

	if (slot < 0 || !wq)
		return;
	wq_slot_next[slot] = wq->head_slot;
	wq->head_slot = slot;
}

static int wq_dequeue(struct wait_queue *wq)
{
	int slot, pid;

	if (!wq || wq->head_slot < 0)
		return -1;
	slot = wq->head_slot;
	wq->head_slot = wq_slot_next[slot];
	wq_slot_next[slot] = -1;
	pid = proc_pid_by_slot(slot);
	return pid;
}

void proc_sched_init(void)
{
	int i;

	for (i = 0; i < PROC_MAX; i++) {
		wq_slot_next[i] = -1;
		child_wait_wq[i].head_slot = -1;
	}
}

void *proc_child_wait_chan(int child_pid)
{
	int slot = proc_slot_by_pid(child_pid);

	if (slot < 0)
		return NULL;
	return &child_wait_wq[slot];
}

void proc_sched_child_exit(int child_pid)
{
	void *chan = proc_child_wait_chan(child_pid);

	if (chan)
		proc_wakeup(chan);
}

void proc_wakeup(void *chan)
{
	int pid;
	char buf[96];

	pid = wq_dequeue((struct wait_queue *)chan);
	if (pid < 0)
		return;
	proc_set_state(pid, PROC_READY);
	snprintf(buf, sizeof(buf), "\"pid\":%d,\"chan\":\"%p\"", pid, chan);
	LOG_SCHED("wakeup", buf);
}

void proc_block(void *chan)
{
	int pid = proc_current_pid();
	char buf[96];

	if (pid <= 0 || !chan)
		return;

	snprintf(buf, sizeof(buf), "\"pid\":%d,\"chan\":\"%p\"", pid, chan);
	LOG_SCHED("block", buf);

	wq_enqueue((struct wait_queue *)chan, pid);
	proc_set_state(pid, PROC_BLOCKED);

	/*
	 * Single scheduler entry: do not nest proc_user_run here and do not
	 * jr→after_uspace (unwind). Run other READY processes, then wfi for IRQ.
	 */
	while (proc_get_state(pid) == PROC_BLOCKED) {
		proc_sched_run_ready();
		if (proc_get_state(pid) != PROC_BLOCKED)
			break;
		cpu_irq_enable();
		asm volatile("wfi");
		cpu_irq_disable();
	}

	proc_set_state(pid, PROC_RUNNING);
	snprintf(buf, sizeof(buf), "\"pid\":%d", pid);
	LOG_SCHED("resume", buf);
}

void proc_sched_run_ready(void)
{
	int next;
	char buf[64];

	for (;;) {
		next = proc_pick_next_ready();
		if (next <= 0)
			return;
		if (!proc_user_run_schedulable(next))
			return;
		snprintf(buf, sizeof(buf), "\"pid\":%d", next);
		LOG_SCHED("run", buf);
		(void)proc_user_run_dispatch(next);
	}
}

void proc_schedule(void)
{
	proc_sched_run_ready();
}
