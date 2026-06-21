#include "os.h"
#include "proc.h"
#include "proc_user.h"
#include "proc_sched.h"
#include "trap_csr.h"
#include "osviz_k.h"

static struct wait_queue child_wait_wq[PROC_MAX];
static int wq_slot_next[PROC_MAX];

#define SCHED_STACK_SIZE 4096

static uint8_t sched_stack[SCHED_STACK_SIZE] __attribute__((aligned(16)));
static struct proc_kcontext sched_kctx;
static int sched_ctx_ready;

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

static void sched_ctx_init_once(void)
{
	if (sched_ctx_ready)
		return;
	sched_kctx.sp = (reg_t)&sched_stack[SCHED_STACK_SIZE];
	sched_kctx.ra = (reg_t)0; /* set on first proc_scheduler_loop entry below */
	sched_ctx_ready = 1;
}

static int sched_dispatch_parent(int pid)
{
	int parent = proc_current_pid();

	if (parent > 0 && proc_user_in_uspace(parent) &&
	    proc_get_state(parent) == PROC_BLOCKED)
		parent = proc_run_sched_parent(parent);
	return parent;
}

/*
 * xv6 scheduler loop: runs on sched_stack, not on any blocked process frame.
 * Fresh READY procs: proc_kctx_bootstrap_fresh + proc_user_first_run via kctx.
 * Woken blockers resume via proc_kctx_switch into proc_sched().
 */
static void proc_scheduler_loop(void)
{
	for (;;) {
		int next;

		for (;;) {
			next = proc_pick_next_ready();
			if (next <= 0)
				break;
			(void)proc_sched_dispatch_one(next);
		}

		for (;;) {
			int pid = proc_pick_next_ready_resume();
			char buf[64];

			if (pid <= 0)
				break;
			snprintf(buf, sizeof(buf), "\"pid\":%d,\"via\":\"kctx\"", pid);
			LOG_SCHED("resume", buf);
			proc_set_state(pid, PROC_RUNNING);
			proc_set_current_pid(pid);
			proc_kctx_switch(&sched_kctx, proc_kctx(pid));
		}

		cpu_irq_enable();
		asm volatile("wfi");
		cpu_irq_disable();
	}
}

void proc_sched_init(void)
{
	int i;

	for (i = 0; i < PROC_MAX; i++) {
		wq_slot_next[i] = -1;
		child_wait_wq[i].head_slot = -1;
	}
	sched_ctx_init_once();
	sched_kctx.ra = (reg_t)proc_scheduler_loop;
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
	snprintf(buf, sizeof(buf), "\"pid\":%d,\"chan\":\"0x%lx\"", pid,
		 (unsigned long)chan);
	LOG_SCHED("wakeup", buf);
}

/*
 * Switch away to scheduler; returns when this process is picked for resume.
 * Caller must already be BLOCKED (proc_block sets state before calling).
 */
void proc_sched(void)
{
	int pid = proc_current_pid();
	struct proc_kcontext *k;

	if (pid <= 0)
		return;
	sched_ctx_init_once();
	k = proc_kctx(pid);
	if (!k)
		return;
	proc_kctx_set_asleep(pid, 1);
	proc_kctx_switch(k, &sched_kctx);
	proc_kctx_set_asleep(pid, 0);
}

void proc_block(void *chan)
{
	int pid = proc_current_pid();
	char buf[96];

	if (pid <= 0 || !chan)
		return;

	snprintf(buf, sizeof(buf), "\"pid\":%d,\"chan\":\"0x%lx\"", pid,
		 (unsigned long)chan);
	LOG_SCHED("block", buf);

	wq_enqueue((struct wait_queue *)chan, pid);
	proc_set_state(pid, PROC_BLOCKED);

	while (proc_get_state(pid) == PROC_BLOCKED)
		proc_sched();

	proc_set_state(pid, PROC_RUNNING);
	snprintf(buf, sizeof(buf), "\"pid\":%d", pid);
	LOG_SCHED("unblock", buf);
}

struct proc_kcontext *proc_sched_kctx(void)
{
	sched_ctx_init_once();
	return &sched_kctx;
}

int proc_sched_dispatch_one(int pid)
{
	int parent;
	char buf[64];
	struct proc_kcontext *k;
	struct proc_kcontext *sched;

	if (proc_slot_by_pid(pid) < 0)
		return -1;
	if (proc_get_state(pid) != PROC_READY)
		return -1;
	if (!proc_pagetable(pid))
		return -1;
	if (proc_kctx_asleep(pid))
		return -1;

	parent = sched_dispatch_parent(pid);
	proc_set_run_sched_parent(pid, parent);

	k = proc_kctx(pid);
	sched = proc_sched_kctx();
	if (!k || !sched)
		return -1;
	proc_kctx_bootstrap_fresh(pid);
	snprintf(buf, sizeof(buf), "\"pid\":%d,\"via\":\"kctx\"", pid);
	LOG_SCHED("run", buf);
	proc_set_state(pid, PROC_RUNNING);
	proc_set_current_pid(pid);
	proc_kctx_switch(sched, k);
	proc_set_current_pid(parent);
	return 0;
}

void proc_sched_run_ready(void)
{
	int next;

	for (;;) {
		next = proc_pick_next_ready();
		if (next <= 0)
			return;
		(void)proc_sched_dispatch_one(next);
	}
}

void proc_schedule(void)
{
	proc_sched_run_ready();
}
