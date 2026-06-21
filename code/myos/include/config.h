#ifndef __CONFIG_H__
#define __CONFIG_H__

#ifndef CONFIG_LOG
#define CONFIG_LOG 1
#endif

#ifndef DEBUG
#define DEBUG CONFIG_LOG
#endif

/*
 * Human console verbosity (printf → UART), separate from LOG_* (Web events).
 *
 *   DEBUG=0        boot + proc traces off
 *   CONFIG_AUTORUN boot + proc traces off (batch / smoke)
 *   DEBUG=1 shell  boot + proc traces on (local bring-up)
 */
#if DEBUG == 0 || defined(CONFIG_AUTORUN)
#define CONSOLE_BOOT 0
#define CONSOLE_PROC 0
#else
#define CONSOLE_BOOT 1
#define CONSOLE_PROC 1
#endif

#if CONSOLE_BOOT
#define boot_printf(...) printf(__VA_ARGS__)
#else
#define boot_printf(...) ((void)0)
#endif

#if CONSOLE_PROC
#define proc_printf(...) proc_trace_printf(__VA_ARGS__)
#else
#define proc_printf(...) ((void)0)
#endif

/*
 * Non-interactive boot: run one user program from /home/root then poweroff.
 * Set at build time: make AUTORUN=test
 */
#ifdef CONFIG_AUTORUN
extern void debug_autorun_user_and_exit(const char *prog);
#endif

#endif /* __CONFIG_H__ */
