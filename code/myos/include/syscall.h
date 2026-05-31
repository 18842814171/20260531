/* Private syscall ABI (task.md §2 + plan.md Phase D) */
#define SYS_open            1024
#define SYS_close           1025
#define SYS_gethid          1
#define SYS_read            63
#define SYS_write           64
#define SYS_exit            93
#define SYS_getpid          172
#define SYS_fork            214
#define SYS_waitpid         260
#define SYS_execve          221
#define SYS_osviz_event     1000
#define SYS_osviz_snap      1001

#define ENOSYS  (-38)
