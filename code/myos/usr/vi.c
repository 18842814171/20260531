#include "os.h"
#include "fs.h"

#define VI_BUF FS_MAX_SIZE

static int str_eq(const char *a, const char *b)
{
	while (*a && *b) {
		if (*a != *b)
			return 0;
		a++;
		b++;
	}
	return *a == *b;
}

static void trim_eol(char *s)
{
	int n = 0;

	while (s[n])
		n++;
	while (n > 0 && (s[n - 1] == '\n' || s[n - 1] == '\r'))
		s[--n] = '\0';
}

int vi_edit(const char *path)
{
	char buf[VI_BUF];
	char line[128];
	int len = 0;
	int i;

	len = fs_read_file(path, buf, sizeof(buf) - 1);
	if (len < 0)
		len = 0;
	buf[len] = '\0';

	uart_puts("\n-- vi ");
	uart_puts((char *)path);
	uart_puts(" --\n");
	if (len > 0) {
		uart_puts("--- current ---\n");
		uart_puts(buf);
		if (len == 0 || buf[len - 1] != '\n')
			uart_putc('\n');
		uart_puts("--- end ---\n");
	} else {
		uart_puts("[New file]\n");
	}
	uart_puts("Type lines to replace content.\n");
	uart_puts("Finish with a line containing only ':wq' (save) or ':q!' (abort).\n");

	len = 0;
	buf[0] = '\0';
	for (;;) {
		if (uart_prompt_and_read_line("> ", line, sizeof(line)) < 0)
			continue;
		trim_eol(line);
		if (str_eq(line, ":q!"))
			return -1;
		if (str_eq(line, ":wq"))
			break;
		for (i = 0; line[i] && len < (int)sizeof(buf) - 2; i++)
			buf[len++] = line[i];
		buf[len++] = '\n';
		buf[len] = '\0';
	}

	if (fs_write_file(path, buf, len, 1) < 0) {
		uart_puts("vi: write failed\n");
		return -1;
	}
	uart_puts("vi: saved\n");
	return 0;
}
