#include "os.h"
#include "fs.h"

static void skip_space(const char **p)
{
	while (**p == ' ' || **p == '\t')
		(*p)++;
}

static int line_eq(const char *line, const char *cmd)
{
	while (*cmd) {
		if (*line != *cmd)
			return 0;
		line++;
		cmd++;
	}
	return *line == '\0' || *line == ' ' || *line == '\t';
}

static void run_echo(const char *args)
{
	skip_space(&args);
	uart_puts(args);
	uart_putc('\n');
}

int script_run(const char *path)
{
	char buf[FS_MAX_SIZE];
	int fd, n, i, start;
	int rc = 0;

	fd = fs_open(path, O_RDONLY);
	if (fd < 0) {
		printf("sh: %s: not found (ramfs)\n", path);
		return -1;
	}

	n = fs_read(fd, buf, sizeof(buf) - 1);
	fs_close(fd);
	if (n <= 0) {
		printf("sh: %s: empty\n", path);
		return -1;
	}
	buf[n] = '\0';

	printf("=== running %s ===\n", path);
	start = 0;
	for (i = 0; i <= n; i++) {
		if (i < n && buf[i] != '\n')
			continue;

		buf[i] = '\0';
		{
			char *line = &buf[start];
			while (*line == ' ' || *line == '\t')
				line++;
			if (*line == '\0' || *line == '#') {
				start = i + 1;
				continue;
			}
			if (line[0] == '#' || (line[0] == '/' && line[1] == '/')) {
				start = i + 1;
				continue;
			}
			if (line_eq(line, "echo"))
				run_echo(line + 4);
			else {
				printf("sh: unsupported: %s\n", line);
				rc = -1;
			}
		}
		start = i + 1;
	}
	printf("=== %s done ===\n", path);
	return rc;
}
