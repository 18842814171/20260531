#ifndef __CONSOLE_IO_H__
#define __CONSOLE_IO_H__

#include <stddef.h>

/*
 * Guest output abstraction (3-step plan):
 *
 *   Step 1 — API split
 *     console_*  human-facing terminal (shell, printf, write(1/2))
 *     log_*      structured osviz events (LOG / LOG_SNAPSHOT)
 *
 *   Step 2 — both sink to UART; host SerialDemux maps log_* → sidebar,
 *            console_* → virtual terminal (WebSocket channel field).
 *
 *   Step 3 — redirect log_* to host pipe / socket / file / 2nd UART
 *            (change log_sink backend only; callers unchanged).
 */

/* ── console channel (virtual terminal) ── */

int console_putc(char ch);
void console_write(const char *buf, size_t len);
void console_puts(const char *s);

/* ── log channel (event bubbles / osviz) ── */

int log_putc(char ch);
void log_write(const char *buf, size_t len);
void log_puts(const char *s);

#endif /* __CONSOLE_IO_H__ */
