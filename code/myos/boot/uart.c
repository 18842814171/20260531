#include "os.h"
#include "osviz_k.h"
#include "stats.h"
#include "trap_csr.h"

/*
 * NS16550 MMIO console (QEMU virt, -serial stdio).
 * Phase 1: poll-only — uart_try_getc / uart_putc on LSR/RHR.
 * UART IRQ + ring buffer: Phase 2 (interrupt/uart_irq.c).
 *
 * IRQs are masked inside busy poll loops so timer traps cannot nest
 * during trap_vector reg_restore while blocked in uart_getc.
 */

#define UART_REG(reg) ((volatile uint8_t *)(UART0 + (reg)))

#define UART_RHR 0
#define UART_IER 1
#define UART_FCR 2
#define UART_LCR 3
#define UART_LSR 5

#define UART_LCR_DLAB (1 << 7)
#define UART_LCR_8N1  3

#define UART_LSR_RX_READY (1 << 0)
#define UART_LSR_TX_IDLE  (1 << 5)

#define UART_FCR_ENABLE (1 << 0)
#define UART_FCR_CLEAR  (0x06)

static inline uint8_t uart_read_reg(int reg)
{
	return *UART_REG(reg);
}

static inline void uart_write_reg(int reg, uint8_t v)
{
	*UART_REG(reg) = v;
}

static reg_t uart_irq_save(void)
{
	reg_t s = r_sstatus();
	cpu_irq_disable();
	return s;
}

static void uart_irq_restore(reg_t saved)
{
	if (saved & SSTATUS_SIE)
		cpu_irq_enable();
}

void uart_init(void)
{
	uart_write_reg(UART_IER, 0x00);
	uart_write_reg(UART_LCR, UART_LCR_DLAB);
	uart_write_reg(UART_RHR, 0x03);
	uart_write_reg(UART_IER, 0x00);
	uart_write_reg(UART_LCR, UART_LCR_8N1);
	uart_write_reg(UART_FCR, UART_FCR_ENABLE | UART_FCR_CLEAR);

	uart_rx_flush();
}

void uart_irq_enable(void)
{
	/* Console RX is poll-only; keep UART interrupts disabled. */
	uart_write_reg(UART_IER, 0x00);
	osviz_event("irq", "uart_init", "\"rx_irq\":false,\"rx_poll\":true");
}

int uart_putc(char ch)
{
	reg_t irq = uart_irq_save();

	while ((uart_read_reg(UART_LSR) & UART_LSR_TX_IDLE) == 0)
		;
	uart_write_reg(UART_RHR, (uint8_t)ch);
	uart_irq_restore(irq);
	return ch;
}

void uart_puts(char *s)
{
	while (*s)
		uart_putc(*s++);
}

int uart_try_getc(void)
{
	int c;

	if ((uart_read_reg(UART_LSR) & UART_LSR_RX_READY) == 0)
		return -1;
	c = uart_read_reg(UART_RHR);
	if (c == 0)
		return -1;
	stats_inc_uart_rx();
	return c;
}

int uart_getc(void)
{
	int c;
	reg_t irq = uart_irq_save();

	while ((c = uart_try_getc()) < 0)
		;
	uart_irq_restore(irq);
	return c;
}

void uart_rx_flush(void)
{
	int n = 0;

	while (uart_read_reg(UART_LSR) & UART_LSR_RX_READY) {
		(void)uart_read_reg(UART_RHR);
		if (++n >= 256)
			break;
	}
}

void uart_rx_flush_deep(void)
{
	int i;

	for (i = 0; i < 8; i++)
		uart_rx_flush();
}

void uart_rx_drain_quiet(unsigned quiet_need, unsigned max_spin)
{
	unsigned idle = 0, spin = 0;

	uart_rx_flush_deep();
	while (spin < max_spin) {
		if (uart_read_reg(UART_LSR) & UART_LSR_RX_READY) {
			(void)uart_read_reg(UART_RHR);
			idle = 0;
		} else if (++idle >= quiet_need) {
			return;
		}
		spin++;
	}
}

int uart_read_buf(char *buf, int maxlen)
{
	int i = 0;

	if (!buf || maxlen <= 0)
		return 0;

	while (i < maxlen) {
		int c = uart_try_getc();

		if (c < 0)
			break;
		buf[i++] = (char)c;
	}

	return i;
}

int uart_read_line(char *buf, int maxlen)
{
	int i = 0;
	reg_t irq = uart_irq_save();

	if (!buf || maxlen < 2) {
		uart_irq_restore(irq);
		return 0;
	}

	while (i < maxlen - 1) {
		int c;

		/*
		 * Poll with try_getc only — do not call uart_getc() here.
		 * uart_getc() save/restores IRQ independently; nested restore
		 * can re-enable timer IRQ during reg_restore and corrupt the
		 * caller stack (seen as buf==NULL in this frame).
		 */
		while ((c = uart_try_getc()) < 0)
			script_bg_poll();

		if (c == '\r' || c == '\n') {
			if (c == '\r') {
				/*
				 * Swallow optional LF after CR only.
				 * Do not drain the whole RX FIFO — loopback can
				 * keep LSR ready forever and hang the shell.
				 */
				if (uart_read_reg(UART_LSR) & UART_LSR_RX_READY)
					(void)uart_read_reg(UART_RHR);
			}
			break;
		}
		if (c == 3)
			continue;
		if (c == 8 || c == 127) {
			if (i > 0) {
				i--;
				uart_puts("\b \b");
			}
			continue;
		}
		if (c >= 32 && c < 127) {
			buf[i++] = (char)c;
			uart_putc((char)c);
		}
	}

	buf[i] = '\0';
	uart_puts("\n");
	uart_irq_restore(irq);
	return i;
}

int uart_prompt_and_read_line(const char *prompt, char *buf, int maxlen)
{
	int n;
	reg_t irq = uart_irq_save();

	if (prompt)
		uart_puts((char *)prompt);
	uart_rx_flush();
	n = uart_read_line(buf, maxlen);
	uart_irq_restore(irq);
	return n;
}

#ifdef CONFIG_UART_LSR_DIAG
static void uart_puthex8(uint8_t v)
{
	static const char hex[] = "0123456789abcdef";
	char buf[3];

	buf[0] = hex[(v >> 4) & 0xf];
	buf[1] = hex[v & 0xf];
	buf[2] = '\0';
	uart_puts(buf);
}

void uart_lsr_diag(void)
{
	uart_puts("\n=== UART LSR diag (press keys; LSR bit0=RX ready) ===\n");
	for (;;) {
		uint8_t lsr = uart_read_reg(UART_LSR);

		uart_puthex8(lsr);
		uart_puts("\n");
		if (lsr & UART_LSR_RX_READY) {
			uint8_t ch = uart_read_reg(UART_RHR);

			uart_puts("  RHR=");
			uart_puthex8(ch);
			uart_puts(" '");
			if (ch >= 32 && ch < 127)
				uart_putc((char)ch);
			else if (ch == '\r')
				uart_puts("\\r");
			else if (ch == '\n')
				uart_puts("\\n");
			uart_puts("'\n");
		}
		for (volatile int j = 0; j < 1000000; j++)
			;
	}
}
#endif

void uart_hw_test(void)
{
	int c;

	uart_puts("\nUART TEST (poll LSR/RHR; type keys + Enter)\n");
	for (;;) {
		c = uart_try_getc();
		if (c < 0)
			continue;
		uart_puts("\nRX=");
		uart_putc((char)c);
		uart_puts("\n");
	}
}
