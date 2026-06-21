#include "os.h"
#include "console_io.h"
#include "trap_csr.h"
#include <stdarg.h>

/*
 * Step 2 backend: both channels share the NS16550 UART byte stream.
 * log_write lines must carry LOG / LOG_SNAPSHOT prefixes (see osviz_k.c);
 * the host demux routes by prefix until Step 3 adds an alternate sink.
 */

enum log_sink_kind {
	LOG_SINK_UART = 0,
	/* Step 3: LOG_SINK_PIPE, LOG_SINK_SOCKET, LOG_SINK_FILE, LOG_SINK_UART2 */
};

static enum log_sink_kind log_sink = LOG_SINK_UART;

/* One UART stream for console + LOG — emit each write atomically (no byte interleave). */
static void uart_emit(const char *buf, size_t len)
{
	size_t i;
#ifdef CONFIG_OPENSBI
	reg_t saved = r_sstatus();
#else
	reg_t saved = r_mstatus();
#endif

	if (!buf || len == 0)
		return;

	cpu_irq_disable();
	for (i = 0; i < len; i++)
		uart_putc(buf[i]);
#ifdef CONFIG_OPENSBI
	w_sstatus(saved);
#else
	w_mstatus(saved);
#endif
}

int console_putc(char ch)
{
	return uart_putc(ch);
}

void console_write(const char *buf, size_t len)
{
	uart_emit(buf, len);
}

void console_puts(const char *s)
{
	if (!s)
		return;
	while (*s)
		uart_putc(*s++);
}

static void log_write_uart(const char *buf, size_t len)
{
	uart_emit(buf, len);
}

int log_putc(char ch)
{
	char c = ch;

	log_write(&c, 1);
	return (unsigned char)ch;
}

void log_write(const char *buf, size_t len)
{
	if (!buf || len == 0)
		return;

	switch (log_sink) {
	case LOG_SINK_UART:
	default:
		log_write_uart(buf, len);
		break;
	}
}

void log_puts(const char *s)
{
	size_t n;

	if (!s)
		return;
	for (n = 0; s[n]; n++)
		;
	log_write(s, n);
}

#define LOG_NOTE_PREFIX "LOG_NOTE "

void proc_trace_printf(const char *fmt, ...)
{
	char body[280];
	char line[320];
	va_list ap;
	int n;

	if (!fmt)
		return;
	va_start(ap, fmt);
	n = vsnprintf(body, sizeof(body), fmt, ap);
	va_end(ap);
	if (n <= 0)
		return;
	n = snprintf(line, sizeof(line), "%s%.*s", LOG_NOTE_PREFIX, n, body);
	if (n <= 0)
		return;
	log_write(line, (size_t)n);
}
