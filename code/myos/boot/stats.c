#include "stats.h"

struct irq_stats g_irq_stats;

void stats_inc_timer(void)
{
	g_irq_stats.timer_ticks++;
}

void stats_inc_uart_rx(void)
{
	g_irq_stats.uart_rx_chars++;
}

void stats_inc_sw_irq(void)
{
	g_irq_stats.sw_irq++;
}

void stats_inc_ext_irq(void)
{
	g_irq_stats.ext_irq++;
}

void stats_inc_ecall(void)
{
	g_irq_stats.ecall_count++;
}

void stats_inc_page_fault(void)
{
	g_irq_stats.page_fault_count++;
}
