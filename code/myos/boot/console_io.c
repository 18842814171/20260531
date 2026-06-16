#include "os.h"
#include "console_io.h"

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

int console_putc(char ch)
{
	return uart_putc(ch);
}

void console_write(const char *buf, size_t len)
{
	size_t i;

	if (!buf || len == 0)
		return;
	for (i = 0; i < len; i++)
		uart_putc(buf[i]);
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
	size_t i;

	for (i = 0; i < len; i++)
		uart_putc(buf[i]);
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
