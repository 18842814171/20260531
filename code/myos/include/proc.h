#ifndef __PROC_H__
#define __PROC_H__

#include "types.h"
#include "vm.h"

struct context;

#define PROC_NAME_LEN   16
#define PROC_MAX        16
#define PROC_KSTACK_SIZE 4096
/* user_ctx address = kstack top (exclusive) minus this (see procs[] in proc.c). */
#define PROC_KSTACK_TOP_TO_UCTX  0x11a0

enum proc_state {
	PROC_UNUSED = 0,
	PROC_READY,
	PROC_RUNNING,
	PROC_BLOCKED,
	PROC_ZOMBIE,
};

/*
 * xv6-style kernel thread context (swtch saves ra/sp + callee-saved only).
 * Stage 1: per-process storage; populated as shadow of run_saved_* writes.
 * Stage 2+: proc_block → proc_sched → switch_to uses this instead of C frames.
 */
struct proc_kcontext {
	reg_t ra;
	reg_t sp;
	reg_t s0;
	reg_t s1;
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
};

struct proc_info {
	int pid;
	int ppid;
	enum proc_state state;
	char name[PROC_NAME_LEN];
};

void proc_init(void);
int  proc_alloc(const char *name, int ppid);
void proc_set_name(int pid, const char *name);
void proc_set_state(int pid, enum proc_state st);
enum proc_state proc_get_state(int pid);
int  proc_slot_by_pid(int pid);
int  proc_pid_by_slot(int slot);
int  proc_pick_next_ready(void);
int  proc_count(void);
int  proc_list(struct proc_info *out, int max);

int  proc_spawn(const char *name, void (*entry)(void));
void proc_mark_zombie(int pid);
void proc_run_binary(const char *name, void *entry, void *stack_top);

struct context *proc_user_ctx(int pid);
struct context *proc_user_ctx_by_kstack_top(reg_t kstack_top);
reg_t proc_kstack_top(int pid);

struct proc_kcontext *proc_kctx(int pid);
void proc_kctx_clear(int pid);
void proc_kctx_bootstrap_fresh(int pid);
void proc_kctx_switch(struct proc_kcontext *old, struct proc_kcontext *new);
void proc_kctx_set_asleep(int pid, int asleep);
int  proc_kctx_asleep(int pid);

int proc_pick_next_ready_resume(void);

reg_t proc_run_saved_ra(int pid);
reg_t proc_run_saved_sp(int pid);
reg_t proc_run_saved_s0(int pid);
void proc_save_run_caller(int pid, reg_t ra, reg_t sp, reg_t s0);
void proc_set_run_sched_parent(int pid, int parent_pid);
int  proc_run_sched_parent(int pid);
void proc_prepare_kernel_return(struct context *cxt, int pid);

/* GDB: phase 0 = before sret to trap_ret; phase 1 = landed at proc_user_trap_return */
struct proc_gdb_snap {
	int phase;
	int pid;
	int state;
	int cur_pid;
	reg_t trap_ret_pc;
	reg_t saved_ra;
	reg_t cxt_pc;
	reg_t cxt_ra;
	reg_t cxt_sp;
};
extern struct proc_gdb_snap proc_gdb_last;
void proc_gdb_checkpoint(int phase, int pid, struct context *cxt);

pagetable_t proc_pagetable(int pid);
void        proc_set_pagetable(int pid, pagetable_t pt);

#endif /* __PROC_H__ */
