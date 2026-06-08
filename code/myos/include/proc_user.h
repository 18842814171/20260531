#ifndef __PROC_USER_H__
#define __PROC_USER_H__

#include "types.h"

struct context;

#define PROC_SHELL_PID  1
#define USER_MEM_BASE   0x80400000UL
#define USER_MEM_END    0x80480000UL
#define USER_MEM_SIZE   0x00080000UL
#define USER_STACK_TOP  0x80470000UL

void proc_user_init(void);
int  proc_current_pid(void);
reg_t proc_current_kstack_top(void);
void proc_set_current_pid(int pid);

reg_t trap_fixup_kstack_top(reg_t sp_after_swap);

struct context *proc_user_trap_frame(void);
struct context *trap_get_user_frame(reg_t kstack_top);
void proc_enter_uspace(int pid, struct context *uc, reg_t kstack_top);

int proc_load_elf(int pid, const char *path);
int proc_user_run(int pid);
void proc_user_exit(int pid, int status);

/* Handle SYS_exit: mark zombie and return kernel continuation (never user). */
reg_t proc_user_exit_trap(struct context *cxt);

int proc_fork(int parent_pid);
int proc_wait(int parent_pid, int child_pid);
int proc_spawn_exec_wait(const char *path);
int proc_spawn_exec_bg(const char *path);

#endif /* __PROC_USER_H__ */
