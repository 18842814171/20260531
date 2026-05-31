#include "os.h"
#include "trap_csr.h"

#ifdef CONFIG_OPENSBI
#include "sbi.h"
#endif

#ifdef CONFIG_OPENSBI
#include "osviz_k.h"
#endif

/* QEMU virt "test" device — write 0x5555 to request guest poweroff */
#define QEMU_VIRT_TEST_DEV 0x100000UL
#define QEMU_VIRT_TEST_POWEROFF 0x5555U

static void qemu_test_poweroff(void)
{
	*(volatile uint32_t *)QEMU_VIRT_TEST_DEV = QEMU_VIRT_TEST_POWEROFF;
}

static void shutdown_quiesce(void)
{
	cpu_irq_disable();
#ifdef CONFIG_OPENSBI
	w_sie(0);
#endif
}

/*
 * Graceful shutdown: stop interrupts, notify user/OSViz, then power off the VM.
 * Does not return.
 */
void machine_poweroff(void)
{
	shutdown_quiesce();

	uart_puts("\nShutting down myos...\n");

#ifdef CONFIG_OPENSBI
	osviz_event("boot", "poweroff", "\"action\":\"sbi_shutdown\"");
	sbi_shutdown();
#endif

	uart_puts("(SBI shutdown unavailable, trying QEMU test device)\n");
	qemu_test_poweroff();

	uart_puts("Poweroff failed; halted.\n");
	for (;;)
		asm volatile("wfi");
}
