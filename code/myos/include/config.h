#ifndef __CONFIG_H__
#define __CONFIG_H__

#ifndef CONFIG_LOG
#define CONFIG_LOG 1
#endif

/* DEBUG mirrors CONFIG_LOG; Makefile sets both via make DEBUG=0|1. */

/*
 * Non-interactive boot: run one user program from /home/root then poweroff.
 * Set at build time: make AUTORUN=return0
 */
#ifdef CONFIG_AUTORUN
extern void debug_autorun_user_and_exit(const char *prog);
#endif

#endif /* __CONFIG_H__ */
