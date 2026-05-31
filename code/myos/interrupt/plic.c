#include "os.h"
#include "trap_csr.h"

void plic_init(void)
{
	int hart = r_tp();

	/*
	 * UART RX uses polling (see uart_irq_enable). Do not enable UART0
	 * on PLIC until switching to IRQ+ring mode.
	 */
	(void)UART0_IRQ;
	*(uint32_t*)PLIC_MTHRESHOLD(hart) = 0;

	trap_ie_enable(TRAP_IE_EXT);
}

void plic_uart_enable(void)
{
	int hart = r_tp();

	*(uint32_t*)PLIC_PRIORITY(UART0_IRQ) = 1;
	*(uint32_t*)PLIC_MENABLE(hart, UART0_IRQ) = (1 << (UART0_IRQ % 32));
}

int plic_claim(void)
{
	int hart = r_tp();
	return *(uint32_t*)PLIC_MCLAIM(hart);
}

void plic_complete(int irq)
{
	int hart = r_tp();
	*(uint32_t*)PLIC_MCOMPLETE(hart) = irq;
}
