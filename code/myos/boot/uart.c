#include "os.h"
#include "osviz_k.h"
#include "stats.h"

/*
 * Console character chain (QEMU -nographic, OpenSBI + virt machine):
 * Host keyboard -> QEMU UART MMIO -> uart_getc (poll) or uart_isr (IRQ).
 *
 * RX uses either IRQ+ring OR polling, never both (avoids duplicate chars).
 * uart_prompt_and_read_line() prints a prompt then uart_read_line().
 * After Enter, uart_drain_echo_prefix("\n") drops TX loopback on -serial stdio.
 */

#define UART_REG(reg) ((volatile uint8_t *)(UART0 + (reg)))

#define UART_RHR 0
#define UART_IER 1
#define UART_LCR 3
#define UART_LSR 5

#define UART_IER_RX (1 << 0)

#define UART_LSR_RX_READY (1 << 0)
#define UART_LSR_TX_IDLE  (1 << 5)

#define UART_RX_BUF_SIZE 256

static char uart_rx_buf[UART_RX_BUF_SIZE];
static volatile int uart_rx_head;
static volatile int uart_rx_tail;
static int uart_rx_use_irq;

static inline uint8_t uart_read_reg(int reg)
{
	return *UART_REG(reg);
}

static inline void uart_write_reg(int reg, uint8_t v)
{
	*UART_REG(reg) = v;
}

static void uart_rx_put(char ch)
{
	int next = (uart_rx_head + 1) % UART_RX_BUF_SIZE;

	if (next == uart_rx_tail)
		return;

	uart_rx_buf[uart_rx_head] = ch;
	uart_rx_head = next;
	stats_inc_uart_rx();
}

static int uart_rx_get(void)
{
	char ch;

	if (uart_rx_head == uart_rx_tail)
		return -1;

	ch = uart_rx_buf[uart_rx_tail];
	uart_rx_tail = (uart_rx_tail + 1) % UART_RX_BUF_SIZE;
	return (unsigned char)ch;
}

static void uart_rx_unget(char ch)
{
	int prev = (uart_rx_tail - 1 + UART_RX_BUF_SIZE) % UART_RX_BUF_SIZE;

	if (prev == uart_rx_head)
		return;

	uart_rx_tail = prev;
	uart_rx_buf[uart_rx_tail] = ch;
}

void uart_drain_echo_prefix(const char *pfx)
{
	char matched[64];
	int i = 0;

	if (!pfx)
		return;

	while (pfx[i] && i < (int)sizeof(matched) - 1) {
		int c;

		if (!(uart_read_reg(UART_LSR) & UART_LSR_RX_READY))
			goto rollback;
		c = uart_read_reg(UART_RHR);
		if (c != (unsigned char)pfx[i]) {
			uart_rx_unget((char)c);
			goto rollback;
		}
		matched[i++] = (char)c;
	}
	return;

rollback:
	while (i > 0)
		uart_rx_unget(matched[--i]);
}

void uart_rx_flush(void)
{
	while (uart_rx_get() >= 0)
		;
	while (uart_read_reg(UART_LSR) & UART_LSR_RX_READY)
		(void)uart_read_reg(UART_RHR);
}

void uart_init(void)
{
	uart_rx_head = 0;
	uart_rx_tail = 0;
	uart_rx_use_irq = 0;

	uart_write_reg(UART_IER, 0x00);

	uint8_t lcr = uart_read_reg(UART_LCR);
	uart_write_reg(UART_LCR, lcr | (1 << 7));
	uart_write_reg(UART_RHR, 0x03);
	uart_write_reg(UART_IER, 0x00);

	lcr = uart_read_reg(UART_LCR);
	uart_write_reg(UART_LCR, (lcr & ~(1 << 7)) | 3);

	uart_rx_flush();
}

void uart_irq_enable(void)
{
	/*
	 * Console input uses polling (uart_rx_use_irq=0) to avoid reading
	 * the same byte from both the IRQ ring and UART RHR.
	 * To switch to IRQ mode: plic_uart_enable(); uart_rx_use_irq=1;
	 * uart_write_reg(UART_IER, UART_IER_RX);
	 */
	uart_rx_use_irq = 0;
	uart_write_reg(UART_IER, 0x00);
	osviz_event("irq", "uart_init", "\"rx_irq\":false,\"rx_poll\":true");
}

int uart_putc(char ch)
{
	while ((uart_read_reg(UART_LSR) & UART_LSR_TX_IDLE) == 0)
		;
	uart_write_reg(UART_RHR, (uint8_t)ch);
	return ch;
}

void uart_puts(char *s)
{
	while (*s)
		uart_putc(*s++);
}

int uart_getc(void)
{
	int c;

	for (;;) {
		if (uart_rx_use_irq) {
			c = uart_rx_get();
			if (c >= 0) {
				if (c != 0)
					return c;
				continue;
			}
			/* IRQ mode: never poll RHR (ISR owns it). */
			continue;
		}

		c = uart_rx_get();
		if (c >= 0) {
			if (c != 0)
				return c;
			continue;
		}

		while ((uart_read_reg(UART_LSR) & UART_LSR_RX_READY) == 0)
			;
		c = uart_read_reg(UART_RHR);
		if (c != 0) {
			stats_inc_uart_rx();
			return c;
		}
	}
}

int uart_read_buf(char *buf, int maxlen)
{
	int i = 0;

	if (!buf || maxlen <= 0)
		return 0;

	while (i < maxlen) {
		int c = uart_rx_get();

		if (c < 0)
			break;
		buf[i++] = (char)c;
	}

	return i;
}

int uart_read_line(char *buf, int maxlen)
{
	int i = 0;

	if (maxlen < 2)
		return 0;

	while (i < maxlen - 1) {
		int c = uart_getc();

		if (c == '\r' || c == '\n') {
			/* Swallow LF after CR so one Enter does not yield two lines. */
			if (c == '\r') {
				while (uart_read_reg(UART_LSR) & UART_LSR_RX_READY) {
					int n = uart_read_reg(UART_RHR);

					if (n == '\n' || n == 0)
						break;
					uart_rx_unget((char)n);
					break;
				}
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
	uart_putc('\n');
	/* -serial stdio may loop back our TX newline; do not treat it as next line. */
	uart_drain_echo_prefix("\n");
	return i;
}

int uart_prompt_and_read_line(const char *prompt, char *buf, int maxlen)
{
	if (prompt)
		uart_puts((char *)prompt);
	return uart_read_line(buf, maxlen);
}

void uart_isr(void)
{
	while (uart_read_reg(UART_LSR) & UART_LSR_RX_READY) {
		int c = uart_read_reg(UART_RHR);

		if (c == 0)
			continue;
		if (c >= 32 && c < 127)
			uart_rx_put((char)c);
		else if (c == '\r' || c == '\n')
			uart_rx_put('\n');
	}
}
