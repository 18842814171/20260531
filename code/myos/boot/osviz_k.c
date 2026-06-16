#include "os.h"
#include "osviz_k.h"
#include "config.h"
#include "stats.h"
#include "trap_csr.h"
#ifdef CONFIG_OPENSBI
#include "sbi.h"
#endif

extern ptr_t BSS_START;
extern ptr_t BSS_END;
extern ptr_t TEXT_START;

#ifdef CONFIG_OPENSBI
extern reg_t boot_hartid;
extern reg_t boot_dtb;
#endif

static uint64_t boot_mtime;

#if DEBUG == 1

void osviz_init(void)
{
#ifdef CONFIG_OPENSBI
	boot_mtime = r_time();
#else
	boot_mtime = *(volatile uint64_t *)CLINT_MTIME;
#endif
}

uint64_t osviz_millis(void)
{
#ifdef CONFIG_OPENSBI
	uint64_t now = r_time();
#else
	uint64_t now = *(volatile uint64_t *)CLINT_MTIME;
#endif
	uint32_t delta;

	if (now < boot_mtime)
		return 0;

	delta = (uint32_t)(now - boot_mtime);
	return delta / (CLINT_TIMEBASE_FREQ / 1000);
}

int osviz_event(const char *module, const char *event, const char *json_data)
{
	reg_t hart = r_mhartid();
	uint64_t ts_ms = osviz_millis();

	if (!module || !event)
		return -1;

	if (json_data && json_data[0] != '\0') {
		char line[640];

		snprintf(line, sizeof(line),
			 "%s{\"ts_ms\":%d,\"module\":\"%s\",\"event\":\"%s\","
			 "\"hart\":%d,\"data\":{%s}}\n",
			 LOG_PREFIX_EVENT, (int)ts_ms, module, event,
			 (int)hart, json_data);
		log_puts(line);
	} else {
		char line[256];

		snprintf(line, sizeof(line),
			 "%s{\"ts_ms\":%d,\"module\":\"%s\",\"event\":\"%s\","
			 "\"hart\":%d}\n",
			 LOG_PREFIX_EVENT, (int)ts_ms, module, event,
			 (int)hart);
		log_puts(line);
	}

	return 0;
}

int osviz_snapshot(void)
{
	char buf[384];
	reg_t tvec = trap_vec_read();
	reg_t priv = r_priv_mode_bits();

	snprintf(buf, sizeof(buf),
		 "\"boot\":{\"banner\":\"%s %s\",\"mtvec\":\"0x%lx\","
		 "\"priv\":\"0x%lx\",\"mhartid\":%d},"
		 "\"irq\":{\"timer_ticks\":%d,\"timer_hz\":100,"
		 "\"uart_rx_chars\":%d,\"sw_irq\":%d,\"ext_irq\":%d,"
		 "\"exceptions\":{\"ecall\":%d,\"page_fault\":%d}}",
		 MYOS_NAME, MYOS_VERSION, (long)tvec, (long)priv,
		 (int)r_mhartid(),
		 (int)g_irq_stats.timer_ticks, (int)g_irq_stats.uart_rx_chars,
		 (int)g_irq_stats.sw_irq, (int)g_irq_stats.ext_irq,
		 (int)g_irq_stats.ecall_count, (int)g_irq_stats.page_fault_count);

	{
		char line[512];

		snprintf(line, sizeof(line), "%s{%s}\n", LOG_PREFIX_SNAPSHOT, buf);
		log_puts(line);
	}
	return 0;
}

void osviz_boot_banner(void)
{
	printf("\n");
	printf("========================================\n");
#ifdef CONFIG_OPENSBI
	printf("  %s %s (RISC-V rv64, S-mode via OpenSBI)\n", MYOS_NAME, MYOS_VERSION);
	printf("  OpenSBI M→S handoff, kernel @ 0x80200000\n");
#else
	printf("  %s %s (RISC-V rv32, M-mode direct boot)\n", MYOS_NAME, MYOS_VERSION);
	printf("  QEMU direct kernel @ 0x80200000\n");
#endif
	printf("========================================\n");
	osviz_event("boot", "banner", "\"version\":\"" MYOS_VERSION "\"");
}

#else /* DEBUG != 1 */

void osviz_init(void)
{
}

uint64_t osviz_millis(void)
{
	return 0;
}

int osviz_event(const char *module, const char *event, const char *json_data)
{
	(void)module;
	(void)event;
	(void)json_data;
	return 0;
}

int osviz_snapshot(void)
{
	return 0;
}

void osviz_boot_banner(void)
{
}

#endif /* DEBUG */
