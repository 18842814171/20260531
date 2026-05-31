#ifndef __PROC_USER_H__
#define __PROC_USER_H__

#include "types.h"

struct context;

extern struct context *user_trap_save_cxt;
extern int proc_user_exit_pending;

#define PROC_SHELL_PID  1
#define USER_MEM_BASE   0x80380000UL
#define USER_MEM_SIZE   0x00080000UL

void proc_user_init(void);
int  proc_current_pid(void);
void proc_set_current_pid(int pid);

struct context *proc_user_trap_frame(void);

int proc_load_elf(int pid, const char *path);
int proc_user_run(int pid);
void proc_user_exit(int pid, int status);

int proc_fork(int parent_pid);
int proc_wait(int parent_pid, int child_pid);
int proc_spawn_exec_wait(const char *path);

#endif /* __PROC_USER_H__ */
