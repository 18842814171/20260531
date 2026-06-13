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

/*
 * xv6 scheduler loop: runs on sched_stack, not on any blocked process frame.
 * Fresh READY (depth==0) still use proc_user_run_dispatch (Stage 3 replaces that).
 * Woken blockers (depth>0) resume via proc_kctx_switch into proc_sched().
 */
static void proc_scheduler_loop(void)
{
	for (;;) {
		proc_sched_run_ready();

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
	snprintf(buf, sizeof(buf), "\"pid\":%d,\"chan\":\"%p\"", pid, chan);
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

	snprintf(buf, sizeof(buf), "\"pid\":%d,\"chan\":\"%p\"", pid, chan);
	LOG_SCHED("block", buf);

	wq_enqueue((struct wait_queue *)chan, pid);
	proc_set_state(pid, PROC_BLOCKED);

	while (proc_get_state(pid) == PROC_BLOCKED)
		proc_sched();

	proc_set_state(pid, PROC_RUNNING);
	snprintf(buf, sizeof(buf), "\"pid\":%d", pid);
	LOG_SCHED("unblock", buf);
}

void proc_sched_run_ready(void)
{
	int next;
	char buf[64];

	/* Only depth==0 processes (no active continuation) reach dispatch. */
	for (;;) {
		next = proc_pick_next_ready();
		if (next <= 0)
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
