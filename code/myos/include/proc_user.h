#ifndef __PROC_USER_H__
#define __PROC_USER_H__

#include "types.h"

struct context;

#define PROC_SHELL_PID  1
#define PROC_FAULT_EXIT (-1)
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

void proc_activate_user(int pid);
void proc_activate_kernel(void);

int proc_load_elf(int pid, const char *path);

void proc_user_first_run(void);
void proc_user_trap_return(void);
int proc_user_first_run_enter_count_get(int pid);
void proc_user_diag_reset(int pid);
/* true while first_run session active (yield/exit trap not yet switch_back) */
int proc_user_in_uspace(int pid);
reg_t proc_user_yield_trap(struct context *cxt);
void proc_user_exit(int pid, int status);

/* Handle SYS_exit: mark zombie and return kernel trap_ret (never user). */
reg_t proc_user_exit_trap(struct context *cxt);

/* Unhandled user page fault: kill process, return to proc_user_trap_return. */
reg_t proc_user_fault_trap(struct context *cxt);

int proc_fork(int parent_pid);
int proc_wait(int parent_pid, int child_pid);
int proc_spawn_exec_wait(const char *path);
int proc_spawn_exec_bg(const char *path);
int prog_is_elf_path(const char *path);

#endif /* __PROC_USER_H__ */
