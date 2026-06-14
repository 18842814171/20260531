#ifndef __PROC_SCHED_H__
#define __PROC_SCHED_H__

struct wait_queue {
	int head_slot;
};

void proc_sched_init(void);
void proc_sched(void);
void proc_block(void *chan);
void proc_wakeup(void *chan);
void proc_schedule(void);
void proc_sched_run_ready(void);
int  proc_sched_dispatch_one(int pid);
struct proc_kcontext *proc_sched_kctx(void);
void *proc_child_wait_chan(int child_pid);
void proc_sched_child_exit(int child_pid);

#endif /* __PROC_SCHED_H__ */
