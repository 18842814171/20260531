#ifndef __LOG_K_H__
#define __LOG_K_H__

#include "config.h"

/*
 * my_sim-style logging: DEBUG=1 (default) enables LOG_* macros; DEBUG=0 no-ops.
 * make DEBUG=0  →  -DDEBUG=0 -DCONFIG_LOG=0
 */
#ifndef DEBUG
#define DEBUG CONFIG_LOG
#endif

#define LOG_PREFIX_EVENT    "LOG "
#define LOG_PREFIX_SNAPSHOT "LOG_SNAPSHOT "

#define MYOS_NAME    "myos"
#define MYOS_VERSION "0.2.0-boot"

void osviz_init(void);
uint64_t osviz_millis(void);
int osviz_event(const char *module, const char *event, const char *json_data);
int osviz_snapshot(void);
void osviz_boot_banner(void);

#if DEBUG == 1

#define LOG_INIT()              osviz_init()
#define LOG_EVENT(mod, ev, data) osviz_event((mod), (ev), (data))
#define LOG_SNAPSHOT()          osviz_snapshot()
#define LOG_BOOT_BANNER()       osviz_boot_banner()

#define LOG_BOOT(ev, data)      LOG_EVENT("boot", (ev), (data))
#define LOG_TRAP(ev, data)      LOG_EVENT("trap", (ev), (data))
#define LOG_TRAP_DIAG(ev, data) LOG_EVENT("trap-diag", (ev), (data))
#define LOG_PMM(ev, data)       LOG_EVENT("pmm", (ev), (data))
#define LOG_PROC(ev, data)      LOG_EVENT("proc", (ev), (data))
#define LOG_SCHED(ev, data)     LOG_EVENT("sched", (ev), (data))
#define LOG_SEM(ev, data)       LOG_EVENT("sem", (ev), (data))
#define LOG_IRQ(ev, data)       LOG_EVENT("irq", (ev), (data))

#define LOGIF(cond, mod, ev, data) \
	do { if (cond) LOG_EVENT((mod), (ev), (data)); } while (0)

#else /* DEBUG != 1 */

#define LOG_INIT()               ((void)0)
#define LOG_EVENT(mod, ev, data) ((void)0)
#define LOG_SNAPSHOT()           ((void)0)
#define LOG_BOOT_BANNER()        ((void)0)

#define LOG_BOOT(ev, data)       ((void)0)
#define LOG_TRAP(ev, data)       ((void)0)
#define LOG_TRAP_DIAG(ev, data)  ((void)0)
#define LOG_PMM(ev, data)        ((void)0)
#define LOG_PROC(ev, data)       ((void)0)
#define LOG_SCHED(ev, data)      ((void)0)
#define LOG_SEM(ev, data)        ((void)0)
#define LOG_IRQ(ev, data)        ((void)0)

#define LOGIF(cond, mod, ev, data) ((void)0)

#endif /* DEBUG */

#endif /* __LOG_K_H__ */
