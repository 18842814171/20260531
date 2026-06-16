#include "os.h"
#include "fs.h"

#define VI_BUF FS_MAX_SIZE

enum vi_mode {
	VI_NORMAL = 0,
	VI_INSERT,
};

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

static void buf_shift_right(char *buf, int pos, int len, int cap)
{
	int i;

	if (len >= cap - 1)
		return;
	for (i = len; i >= pos; i--)
		buf[i + 1] = buf[i];
}

static void buf_shift_left(char *buf, int pos, int len)
{
	int i;

	for (i = pos; i < len; i++)
		buf[i - 1] = buf[i];
}

static void vi_show_file(const char *path, const char *buf, int len)
{
	console_puts("\n-- vi ");
	console_puts((char *)path);
	console_puts(" --\n");
	if (len > 0) {
		console_puts(buf);
		if (buf[len - 1] != '\n')
			console_putc('\n');
	} else {
		console_puts("[New file]\n");
	}
}

static void vi_show_normal_help(void)
{
	console_puts("-- NORMAL --  i:insert  a:append  :wq save  :q! quit\n");
}

static void vi_show_insert_help(void)
{
	console_puts("-- INSERT --  Esc: normal mode\n");
}

static int vi_read_key(void)
{
	int c;

	while ((c = uart_getc()) == 3)
		;
	return c;
}

static int vi_read_colon_cmd(char *cmd, int maxlen)
{
	int i = 0;
	int c;

	console_putc(':');
	while (i < maxlen - 1) {
		c = vi_read_key();
		if (c == '\r' || c == '\n')
			break;
		if (c == 27) {
			cmd[0] = '\0';
			console_putc('\n');
			return -1;
		}
		if (c == 8 || c == 127) {
			if (i > 0) {
				i--;
				console_puts("\b \b");
			}
			continue;
		}
		if (c >= 32 && c < 127) {
			cmd[i++] = (char)c;
			console_putc((char)c);
		}
	}
	cmd[i] = '\0';
	console_putc('\n');
	return 0;
}

static int vi_insert_char(char *buf, int *len, int *cur, int cap, int c)
{
	if (*len >= cap - 1)
		return -1;
	buf_shift_right(buf, *cur, *len, cap);
	buf[*cur] = (char)c;
	(*len)++;
	(*cur)++;
	buf[*len] = '\0';
	console_putc((char)c);
	return 0;
}

static void vi_delete_before(char *buf, int *len, int *cur)
{
	if (*cur <= 0)
		return;
	buf_shift_left(buf, *cur, *len);
	(*len)--;
	(*cur)--;
	buf[*len] = '\0';
	console_puts("\b \b");
}

static int vi_handle_cmd(const char *cmd)
{
	if (str_eq(cmd, "wq"))
		return 1;
	if (str_eq(cmd, "q!"))
		return -2;
	if (cmd[0] == '\0')
		return 0;
	console_puts("vi: unknown command (use :wq or :q!)\n");
	return 0;
}

int vi_edit(const char *path)
{
	char buf[VI_BUF];
	char cmd[32];
	int len = 0;
	int cur = 0;
	int mode = VI_NORMAL;
	int c;
	int rc;

	len = fs_read_file(path, buf, sizeof(buf) - 1);
	if (len < 0)
		len = 0;
	buf[len] = '\0';
	cur = len;

	vi_show_file(path, buf, len);
	vi_show_normal_help();

	for (;;) {
		c = vi_read_key();

		if (mode == VI_NORMAL) {
			if (c == 'i') {
				mode = VI_INSERT;
				vi_show_insert_help();
				continue;
			}
			if (c == 'a') {
				if (cur < len)
					cur++;
				mode = VI_INSERT;
				vi_show_insert_help();
				continue;
			}
			if (c == ':') {
				if (vi_read_colon_cmd(cmd, sizeof(cmd)) < 0) {
					vi_show_normal_help();
					continue;
				}
				rc = vi_handle_cmd(cmd);
				if (rc == 1)
					break;
				if (rc < 0) {
					if (rc == -2)
						console_puts("vi: quit\n");
					return -1;
				}
				vi_show_normal_help();
				continue;
			}
			continue;
		}

		/* INSERT */
		if (c == 27) {
			mode = VI_NORMAL;
			console_putc('\n');
			vi_show_normal_help();
			continue;
		}
		if (c == '\r' || c == '\n') {
			if (vi_insert_char(buf, &len, &cur, sizeof(buf), '\n') < 0)
				console_puts("\nvi: buffer full\n");
			continue;
		}
		if (c == 8 || c == 127) {
			vi_delete_before(buf, &len, &cur);
			continue;
		}
		if (c >= 32 && c < 127) {
			if (vi_insert_char(buf, &len, &cur, sizeof(buf), c) < 0)
				console_puts("\nvi: buffer full\n");
		}
	}

	if (fs_write_file(path, buf, len, 1) < 0) {
		console_puts("vi: write failed\n");
		return -1;
	}
	console_puts("vi: saved\n");
	return 0;
}
