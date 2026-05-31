#ifndef __PROC_H__
#define __PROC_H__

#include "types.h"

#define PROC_NAME_LEN 16
#define PROC_MAX      16

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
int  proc_current_pid(void);
int  proc_count(void);
int  proc_list(struct proc_info *out, int max);

int  proc_spawn(const char *name, void (*entry)(void));
void proc_mark_zombie(int pid);
void proc_run_binary(const char *name, void *entry, void *stack_top);

#endif /* __PROC_H__ */
