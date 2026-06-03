#ifndef __PROC_H__
#define __PROC_H__

#include "types.h"

struct context;

#define PROC_NAME_LEN   16
#define PROC_MAX        16
#define PROC_KSTACK_SIZE 4096

enum proc_state {
	PROC_UNUSED = 0,
	PROC_READY,
	PROC_RUNNING,
	PROC_ZOMBIE,
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
int  proc_slot_by_pid(int pid);
int  proc_count(void);
int  proc_list(struct proc_info *out, int max);

int  proc_spawn(const char *name, void (*entry)(void));
void proc_mark_zombie(int pid);
void proc_run_binary(const char *name, void *entry, void *stack_top);

struct context *proc_user_ctx(int pid);
struct context *proc_user_ctx_by_kstack_top(reg_t kstack_top);
reg_t proc_kstack_top(int pid);
reg_t proc_run_saved_ra(int pid);
reg_t proc_run_saved_sp(int pid);
void proc_save_run_caller(int pid, reg_t ra, reg_t sp);
void proc_prepare_kernel_return(struct context *cxt, int pid);

#endif /* __PROC_H__ */
