#include "os.h"
#include "osviz_k.h"
#include "stats.h"
#include "trap_csr.h"
#include "proc_sched.h"

/*
 * NS16550 MMIO console (QEMU virt, -serial stdio).
 * Phase 2: UART RX IRQ + PLIC → ring buffer; reads use ring_get only.
 * Poll and IRQ paths are mutually exclusive (uart_rx_use_irq).
 *
 * IRQs are masked inside poll-mode busy loops so timer traps cannot nest
 * during trap_vector reg_restore while blocked in uart_getc.
 */

#define UART_REG(reg) ((volatile uint8_t *)(UART0 + (reg)))

#define UART_RHR 0
#define UART_IER 1
#define UART_FCR 2
#define UART_LCR 3
#define UART_LSR 5

#define UART_IER_RX 0x01

#define UART_LCR_DLAB (1 << 7)
#define UART_LCR_8N1  3

#define UART_LSR_RX_READY (1 << 0)
#define UART_LSR_TX_IDLE  (1 << 5)

#define UART_FCR_ENABLE (1 << 0)
#define UART_FCR_CLEAR  (0x06)

#define UART_RING_SIZE 128

struct uart_ring {
	char buf[UART_RING_SIZE];
	int head;
	int tail;
};

static struct uart_ring uart_rx_ring;
static struct wait_queue uart_read_wq;
static int uart_rx_pushback = -1;
static int uart_rx_use_irq = 0;

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

static int uart_mmio_try_getc(void)
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

static void uart_mmio_drain(void)
{
	int n = 0;

	while (uart_read_reg(UART_LSR) & UART_LSR_RX_READY) {
		(void)uart_read_reg(UART_RHR);
		if (++n >= 256)
			break;
	}
}

static void uart_ring_put(int c)
{
	int next = (uart_rx_ring.head + 1) % UART_RING_SIZE;

	if (next == uart_rx_ring.tail)
		return;
	uart_rx_ring.buf[uart_rx_ring.head] = (char)c;
	uart_rx_ring.head = next;
	stats_inc_uart_rx();
}

static int uart_ring_get(void)
{
	int c;

	if (uart_rx_pushback >= 0) {
		c = uart_rx_pushback;
		uart_rx_pushback = -1;
		return c;
	}
	if (uart_rx_ring.head == uart_rx_ring.tail)
		return -1;
	c = (unsigned char)uart_rx_ring.buf[uart_rx_ring.tail];
	uart_rx_ring.tail = (uart_rx_ring.tail + 1) % UART_RING_SIZE;
	return c;
}

static void uart_ring_clear(void)
{
	uart_rx_ring.head = 0;
	uart_rx_ring.tail = 0;
	uart_rx_pushback = -1;
}

static void uart_read_wakeup(void)
{
	proc_wakeup(&uart_read_wq);
}

void uart_irq_handler(void)
{
	int c;
	int got = 0;

	while (uart_read_reg(UART_LSR) & UART_LSR_RX_READY) {
		c = uart_read_reg(UART_RHR);
		if (c == 0)
			continue;
		uart_ring_put(c);
		got = 1;
	}
	if (got)
		uart_read_wakeup();
}

void uart_init(void)
{
	uart_write_reg(UART_IER, 0x00);
	uart_write_reg(UART_LCR, UART_LCR_DLAB);
	uart_write_reg(UART_RHR, 0x03);
	uart_write_reg(UART_IER, 0x00);
	uart_write_reg(UART_LCR, UART_LCR_8N1);
	uart_write_reg(UART_FCR, UART_FCR_ENABLE | UART_FCR_CLEAR);

	uart_ring_clear();
	uart_read_wq.head_slot = -1;
	uart_rx_use_irq = 0;
	uart_rx_flush();
}

void uart_irq_enable(void)
{
	uart_ring_clear();
	uart_mmio_drain();
	plic_uart_enable();
	uart_write_reg(UART_IER, UART_IER_RX);
	uart_rx_use_irq = 1;
	LOG_IRQ("uart_init", "\"rx_irq\":true,\"rx_poll\":false,\"ring\":128");
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
	if (uart_rx_use_irq) {
		reg_t irq = uart_irq_save();
		int c = uart_ring_get();

		uart_irq_restore(irq);
		return c;
	}
	return uart_mmio_try_getc();
}

int uart_readc_wait(void)
{
	int c;

	for (;;) {
		c = uart_try_getc();
		if (c >= 0)
			return c;
		script_bg_poll();
		if (uart_rx_use_irq)
			proc_block(&uart_read_wq);
	}
}

int uart_getc(void)
{
	return uart_readc_wait();
}

void uart_rx_flush(void)
{
	if (uart_rx_use_irq) {
		reg_t irq = uart_irq_save();

		uart_ring_clear();
		uart_mmio_drain();
		uart_irq_restore(irq);
		return;
	}
	uart_mmio_drain();
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
		if (uart_try_getc() >= 0)
			idle = 0;
		else if (++idle >= quiet_need)
			return;
		spin++;
	}
}

static int uart_read_line_poll(char *buf, int maxlen)
{
	int i = 0;
	reg_t irq = uart_irq_save();

	if (!buf || maxlen < 2) {
		uart_irq_restore(irq);
		return 0;
	}

	while (i < maxlen - 1) {
		int c;

		while ((c = uart_mmio_try_getc()) < 0)
			script_bg_poll();

		if (c == '\r' || c == '\n') {
			if (c == '\r') {
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
				console_puts("\b \b");
			}
			continue;
		}
		if (c >= 32 && c < 127) {
			buf[i++] = (char)c;
			console_putc((char)c);
		}
	}

	buf[i] = '\0';
	console_puts("\n");
	uart_irq_restore(irq);
	return i;
}

static int uart_read_line_irq(char *buf, int maxlen)
{
	int i = 0;

	if (!buf || maxlen < 2)
		return 0;

	while (i < maxlen - 1) {
		int c = uart_readc_wait();

		if (c == '\r' || c == '\n') {
			if (c == '\r') {
				int n = uart_try_getc();

				if (n >= 0 && n != '\n') {
					reg_t irq = uart_irq_save();

					uart_rx_pushback = n;
					uart_irq_restore(irq);
				}
			}
			break;
		}
		if (c == 3)
			continue;
		if (c == 8 || c == 127) {
			if (i > 0) {
				i--;
				console_puts("\b \b");
			}
			continue;
		}
		if (c >= 32 && c < 127) {
			buf[i++] = (char)c;
			console_putc((char)c);
		}
	}

	buf[i] = '\0';
	console_puts("\n");
	return i;
}

int uart_read_line(char *buf, int maxlen)
{
	if (uart_rx_use_irq)
		return uart_read_line_irq(buf, maxlen);
	return uart_read_line_poll(buf, maxlen);
}

int uart_prompt_and_read_line(const char *prompt, char *buf, int maxlen)
{
	if (prompt)
		console_puts((char *)prompt);
	uart_rx_flush();
	return uart_read_line(buf, maxlen);
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

#ifdef CONFIG_UART_LSR_DIAG
static void uart_puthex8(uint8_t v)
{
	static const char hex[] = "0123456789abcdef";
	char buf[3];

	buf[0] = hex[(v >> 4) & 0xf];
	buf[1] = hex[v & 0xf];
	buf[2] = '\0';
	console_puts(buf);
}

void uart_lsr_diag(void)
{
	console_puts("\n=== UART LSR diag (press keys; LSR bit0=RX ready) ===\n");
	for (;;) {
		uint8_t lsr = uart_read_reg(UART_LSR);

		uart_puthex8(lsr);
		console_puts("\n");
		if (lsr & UART_LSR_RX_READY) {
			uint8_t ch = uart_read_reg(UART_RHR);

			console_puts("  RHR=");
			uart_puthex8(ch);
			console_puts(" '");
			if (ch >= 32 && ch < 127)
				console_putc((char)ch);
			else if (ch == '\r')
				console_puts("\\r");
			else if (ch == '\n')
				console_puts("\\n");
			console_puts("'\n");
		}
		for (volatile int j = 0; j < 1000000; j++)
			;
	}
}
#endif

void uart_hw_test(void)
{
	int c;

	console_puts("\nUART TEST (IRQ ring or poll; type keys + Enter)\n");
	for (;;) {
		c = uart_try_getc();
		if (c < 0)
			continue;
		console_puts("\nRX=");
		console_putc((char)c);
		console_puts("\n");
	}
}
