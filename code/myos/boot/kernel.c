#include "os.h"
#include "proc.h"
#include "proc_user.h"
#include "osviz_k.h"
#include "trap_csr.h"
#include "config.h"
#include "sem.h"

extern void uart_init(void);
extern void pmm_init(void);
extern void vm_init(void);
extern void sched_init(void);
extern void os_main(void);
extern void trap_init(void);
extern void plic_init(void);
extern void timer_init(void);
extern void fs_init(void);
extern void console_run(void);
#ifdef CONFIG_UART_LSR_DIAG
extern void uart_lsr_diag(void);
#endif

extern ptr_t BSS_START;
extern ptr_t BSS_END;

#ifdef CONFIG_OPENSBI
reg_t boot_hartid;
reg_t boot_dtb;
#endif

static void clear_bss(void)
{
	extern char _bss_start[];
	extern char _bss_end[];
	char *p;

	for (p = _bss_start; p < _bss_end; p++)
		*p = 0;
}

static void osviz_log_boot_progress(void)
{
	char buf[128];
	ptr_t bss_bytes = BSS_END - BSS_START;

#ifdef CONFIG_OPENSBI
	LOG_BOOT("entry",
		 "\"load\":\"0x80200000\",\"mode\":\"S\",\"firmware\":\"OpenSBI\"");
	snprintf(buf, sizeof(buf),
		 "\"hart\":%d,\"dtb\":\"0x%lx\"",
		 (int)boot_hartid, (unsigned long)boot_dtb);
	LOG_BOOT("opensbi_handoff", buf);
#else
	LOG_BOOT("entry", "\"pc\":\"0x80000000\",\"mode\":\"M\"");
#endif

	snprintf(buf, sizeof(buf),
		 "\"bss_start\":\"0x%lx\",\"bss_end\":\"0x%lx\",\"bss_bytes\":%d",
		 (unsigned long)BSS_START, (unsigned long)BSS_END, (int)bss_bytes);
	LOG_BOOT("bss_done", buf);
	LOG_BOOT("stack_ready", "\"sp_ready\":true");

#ifdef CONFIG_OPENSBI
	LOG_BOOT("priv_config",
		 "\"mode\":\"S\",\"note\":\"OpenSBI completed M→S\"");
#elif defined(CONFIG_SYSCALL)
	LOG_BOOT("priv_config",
		 "\"mpp\":\"U\",\"note\":\"PMP for user tasks\"");
#else
	LOG_BOOT("priv_config", "\"mpp\":\"M\",\"mpie\":true");
#endif
}

void start_kernel(void)
{
	char tbuf[64];

	/* OpenSBI: boot_hartid/boot_dtb and BSS cleared in boot/start.S */

	uart_init();
	trap_init();

	LOG_INIT();
	LOG_BOOT_BANNER();
	osviz_log_boot_progress();

	LOG_BOOT("uart_init", NULL);

	fs_init();
	proc_init();
	proc_user_init();
	sem_init();

	pmm_init();
	LOG_BOOT("pmm_init", NULL);
	vm_init();
	LOG_BOOT("vm_init", "\"mode\":\"Sv39\"");

	snprintf(tbuf, sizeof(tbuf), "\"tvec\":\"0x%lx\"", (unsigned long)trap_vec_read());
	LOG_BOOT("trap_init", tbuf);

	plic_init();
	LOG_BOOT("plic_init", NULL);
	uart_irq_enable();

	timer_init();
	LOG_BOOT("timer_init", "\"hz\":100");

	sched_init();
	LOG_BOOT("sched_init", NULL);

	os_main();
	LOG_BOOT("os_main_done", "\"console\":true");

	LOG_BOOT("kernel_ready", "\"status\":\"ok\"");

	cpu_irq_enable();

#ifndef CONFIG_AUTORUN
	console_puts("Hello, RVOS!\n");
#endif
#ifdef CONFIG_UART_LSR_DIAG
	uart_lsr_diag();
#elif defined(CONFIG_AUTORUN)
	debug_autorun_user_and_exit(CONFIG_AUTORUN);
#else
	console_puts("\nSystem ready. Log in at the prompt below.\n");
	uart_rx_flush_deep();
	console_run();
#endif
}
