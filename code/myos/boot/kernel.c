#include "os.h"
#include "proc.h"
#include "proc_user.h"
#include "osviz_k.h"
#include "trap_csr.h"

extern void uart_init(void);
extern void page_init(void);
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
	osviz_event("boot", "entry",
		    "\"load\":\"0x80200000\",\"mode\":\"S\",\"firmware\":\"OpenSBI\"");
	snprintf(buf, sizeof(buf),
		 "\"hart\":%d,\"dtb\":\"0x%lx\"",
		 (int)boot_hartid, (unsigned long)boot_dtb);
	osviz_event("boot", "opensbi_handoff", buf);
#else
	osviz_event("boot", "entry", "\"pc\":\"0x80000000\",\"mode\":\"M\"");
#endif

	snprintf(buf, sizeof(buf),
		 "\"bss_start\":\"0x%lx\",\"bss_end\":\"0x%lx\",\"bss_bytes\":%d",
		 (unsigned long)BSS_START, (unsigned long)BSS_END, (int)bss_bytes);
	osviz_event("boot", "bss_done", buf);
	osviz_event("boot", "stack_ready", "\"sp_ready\":true");

#ifdef CONFIG_OPENSBI
	osviz_event("boot", "priv_config",
		    "\"mode\":\"S\",\"note\":\"OpenSBI completed M→S\"");
#elif defined(CONFIG_SYSCALL)
	osviz_event("boot", "priv_config",
		    "\"mpp\":\"U\",\"note\":\"PMP for user tasks\"");
#else
	osviz_event("boot", "priv_config", "\"mpp\":\"M\",\"mpie\":true");
#endif
}

void start_kernel(void)
{
	char tbuf[64];

	/* OpenSBI: boot_hartid/boot_dtb and BSS cleared in boot/start.S */

	uart_init();
	trap_init();

	osviz_init();
	osviz_boot_banner();
	osviz_log_boot_progress();

	osviz_event("boot", "uart_init", NULL);

	fs_init();
	proc_init();
	proc_user_init();

	page_init();
	osviz_event("boot", "page_init", NULL);

	snprintf(tbuf, sizeof(tbuf), "\"tvec\":\"0x%lx\"", (unsigned long)trap_vec_read());
	osviz_event("boot", "trap_init", tbuf);

	plic_init();
	osviz_event("boot", "plic_init", NULL);
	uart_irq_enable();

	timer_init();
	osviz_event("boot", "timer_init", "\"hz\":100");

	sched_init();
	osviz_event("boot", "sched_init", NULL);

	os_main();
	osviz_event("boot", "os_main_done", "\"console\":true");

	osviz_event("boot", "kernel_ready", "\"status\":\"ok\"");

	cpu_irq_enable();

	uart_puts("Hello, RVOS!\n");
#ifdef CONFIG_UART_LSR_DIAG
	uart_lsr_diag();
#else
	uart_puts("\nSystem ready. Log in at the prompt below.\n");
	uart_rx_flush_deep();
	console_run();
#endif
}
