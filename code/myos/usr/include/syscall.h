#ifndef __USER_SYSCALL_H__
#define __USER_SYSCALL_H__

/* Must match include/syscall.h (kernel ABI). */
#define SYS_open            1024
#define SYS_close           1025
#define SYS_gethid          1
#define SYS_read            63
#define SYS_write           64
#define SYS_exit            93
#define SYS_getpid          172
#define SYS_fork            214
#define SYS_waitpid         260
#define SYS_yield           247
#define SYS_execve          221
#define SYS_sem_create      2001
#define SYS_sem_wait        2002
#define SYS_sem_post        2003
#define SYS_sem_getval      2004
#define SYS_ipc_shm_map     2005
#define SYS_osviz_event     1000
#define SYS_osviz_snap      1001

#define ENOSYS  (-38)

#endif /* __USER_SYSCALL_H__ */
