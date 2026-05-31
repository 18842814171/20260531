#ifndef __STATS_H__
#define __STATS_H__

#include "types.h"

struct irq_stats {
	uint32_t timer_ticks;
	uint32_t uart_rx_chars;
	uint32_t sw_irq;
	uint32_t ext_irq;
	uint32_t ecall_count;
	uint32_t page_fault_count;
};

extern struct irq_stats g_irq_stats;

void stats_inc_timer(void);
void stats_inc_uart_rx(void);
void stats_inc_sw_irq(void);
void stats_inc_ext_irq(void);
void stats_inc_ecall(void);
void stats_inc_page_fault(void);

#endif /* __STATS_H__ */
