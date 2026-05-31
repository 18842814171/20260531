#include "os.h"
#include "osviz_k.h"
#include "proc.h"
#include "proc_user.h"
#include "fs.h"

#define LINE_MAX 128
#define LOGIN_USER "root"

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

static int str_prefix(const char *s, const char *pfx)
{
	while (*pfx) {
		if (*s != *pfx)
			return 0;
		s++;
		pfx++;
	}
	return 1;
}

static void trim_line(char *s)
{
	int n = 0;
	int i = 0;

	while (s[n])
		n++;
	while (n > 0 && (s[n - 1] == '\n' || s[n - 1] == '\r' || s[n - 1] == ' '
			 || s[n - 1] == '\t')) {
		s[n - 1] = '\0';
		n--;
	}
	while (s[i] == ' ' || s[i] == '\t')
		i++;
	if (i > 0) {
		int j = 0;
		while (s[i])
			s[j++] = s[i++];
		s[j] = '\0';
	}
}

static const char *skip_word(const char *s)
{
	while (*s && *s != ' ' && *s != '\t')
		s++;
	while (*s == ' ' || *s == '\t')
		s++;
	return s;
}

static char *find_redirect(char *line, char **target, int *append)
{
	char *p = line;

	*target = NULL;
	*append = 0;
	while (*p) {
		if (*p == '>' && *(p + 1) == '>') {
			*p = '\0';
			*append = 1;
			*target = p + 2;
			trim_line(*target);
			return p;
		}
		if (*p == '>') {
			*p = '\0';
			*append = 0;
			*target = p + 1;
			trim_line(*target);
			return p;
		}
		p++;
	}
	return NULL;
}

static int is_poweroff_cmd(const char *line)
{
	return str_eq(line, "poweroff") || str_eq(line, "halt")
	    || str_eq(line, "shutdown");
}

static void put_dec(int v)
{
	char buf[12];
	int i = 0;
	int neg = 0;

	if (v < 0) {
		neg = 1;
		v = -v;
	}
	if (v == 0)
		buf[i++] = '0';
	else {
		while (v > 0) {
			buf[i++] = '0' + (v % 10);
			v /= 10;
		}
	}
	if (neg)
		uart_putc('-');
	while (i > 0)
		uart_putc(buf[--i]);
}

static void cmd_ps(int verbose)
{
	struct proc_info list[PROC_MAX];
	char st;
	int n, i;

	n = proc_list(list, PROC_MAX);
	uart_puts("USER   PID  PPID STAT CMD\n");
	for (i = 0; i < n; i++) {
		switch (list[i].state) {
		case PROC_RUNNING:
			st = 'R';
			break;
		case PROC_READY:
			st = 'S';
			break;
		case PROC_ZOMBIE:
			st = 'Z';
			break;
		default:
			st = '?';
			break;
		}
		uart_puts("root ");
		put_dec(list[i].pid);
		uart_putc(' ');
		put_dec(list[i].ppid);
		uart_puts("   ");
		uart_putc(st);
		uart_puts("  ");
		uart_puts(list[i].name);
		uart_putc('\n');
	}
	if (verbose)
		uart_puts("(ps aux)\n");
}

static void ls_emit(const char *name, int size, int is_dir, int exec)
{
	uart_puts("  ");
	if (is_dir)
		uart_putc('d');
	else if (exec)
		uart_putc('x');
	else
		uart_putc('-');
	uart_putc(' ');
	uart_puts((char *)name);
	if (!is_dir) {
		uart_puts(" ");
		put_dec(size);
		uart_puts(" bytes");
	}
	uart_putc('\n');
}

static void cmd_ls(const char *path)
{
	const char *dir = path && path[0] ? path : fs_getcwd();

	uart_puts(dir);
	uart_puts(":\n");
	if (fs_listdir(dir, ls_emit) == 0 && !fs_is_dir(dir))
		uart_puts("  (not a directory)\n");
}

static void cmd_pwd(void)
{
	uart_puts((char *)fs_getcwd());
	uart_putc('\n');
}

static void cmd_cd(const char *path)
{
	const char *target = path && path[0] ? path : "/home/root";

	if (fs_chdir(target) < 0)
		uart_puts("cd: no such directory\n");
}

static void cmd_cat(const char *path)
{
	char buf[256];
	int fd, n;

	fd = fs_open(path, O_RDONLY);
	if (fd < 0) {
		printf("cat: %s: no such file\n", path);
		return;
	}
	n = fs_read(fd, buf, sizeof(buf) - 1);
	fs_close(fd);
	if (n <= 0) {
		uart_puts("(empty)\n");
		return;
	}
	buf[n] = '\0';
	uart_puts(buf);
	if (buf[n - 1] != '\n')
		uart_putc('\n');
}

static void cmd_echo(char *args, char *redir, int append)
{
	if (redir && redir[0]) {
		if (append) {
			int fd = fs_open(redir, O_WRONLY | O_CREAT | O_APPEND);

			if (fd < 0) {
				uart_puts("echo: write failed\n");
				return;
			}
			if (args && args[0]) {
				int i = 0;
				while (args[i])
					i++;
				fs_write(fd, args, i);
			}
			fs_write(fd, "\n", 1);
			fs_close(fd);
		} else {
			char out[256];
			int n = 0;
			int i = 0;

			if (args && args[0]) {
				while (args[i] && n < (int)sizeof(out) - 2)
					out[n++] = args[i++];
			}
			out[n++] = '\n';
			fs_write_file(redir, out, n, 1);
		}
		return;
	}
	if (args && args[0]) {
		uart_puts(args);
		uart_putc('\n');
	}
}

static void cmd_touch(const char *path)
{
	if (fs_create(path, 0) < 0 && !fs_exists(path))
		uart_puts("touch: failed\n");
}

static int login_session(void)
{
	char line[LINE_MAX];

	for (;;) {
		if (uart_prompt_and_read_line("login: ", line, LINE_MAX) <= 0)
			continue;
		trim_line(line);
		if (line[0] == '\0')
			continue;
		if (is_poweroff_cmd(line))
			machine_poweroff();
		if (str_eq(line, LOGIN_USER))
			return 0;
		uart_puts("Login incorrect. Try again.\n");
	}
}

static void print_help(void)
{
	uart_puts("Shell commands (Linux-style):\n");
	uart_puts("  cd [dir]        pwd             ls [dir]\n");
	uart_puts("  cat <file>      touch <file>      vi <file>\n");
	uart_puts("  echo ...        echo ... > f      echo ... >> f\n");
	uart_puts("  ./program       sh script.sh\n");
	uart_puts("  ps / ps aux     spawn worker      help / logout / poweroff\n");
}

extern void demo_run_tasks(void);

static void shell_loop(void)
{
	char line[LINE_MAX];
	char prompt[96];

	uart_puts("\nWelcome, root.\n");
	fs_chdir("/home/root");
	print_help();

	for (;;) {
		snprintf(prompt, sizeof(prompt), "root@%s$ ", fs_getcwd());
		if (uart_prompt_and_read_line(prompt, line, LINE_MAX) < 0)
			continue;
		trim_line(line);
		if (line[0] == '\0')
			continue;

		if (str_eq(line, "help") || str_eq(line, "?")) {
			print_help();
		} else if (str_eq(line, "logout") || str_eq(line, "exit")) {
			uart_puts("Goodbye.\n");
			return;
		} else if (is_poweroff_cmd(line)) {
			machine_poweroff();
		} else if (str_eq(line, "pwd")) {
			cmd_pwd();
		} else if (str_prefix(line, "cd ")) {
			cmd_cd(skip_word(line + 2));
		} else if (str_eq(line, "cd")) {
			cmd_cd("/home/root");
		} else if (str_prefix(line, "ls ")) {
			cmd_ls(skip_word(line + 2));
		} else if (str_eq(line, "ls")) {
			cmd_ls(NULL);
		} else if (str_prefix(line, "cat ")) {
			cmd_cat(skip_word(line + 3));
		} else if (str_prefix(line, "touch ")) {
			cmd_touch(skip_word(line + 5));
		} else if (str_prefix(line, "vi ")) {
			vi_edit(skip_word(line + 2));
		} else if (str_prefix(line, "echo ")) {
			char *target = NULL;
			int append = 0;
			char *args = line + 5;

			find_redirect(args, &target, &append);
			trim_line(args);
			if (target)
				trim_line(target);
			cmd_echo(args, target, append);
		} else if (str_prefix(line, "sh ")) {
			script_run(skip_word(line + 2));
		} else if (str_prefix(line, "./") || (line[0] == '/' && !str_prefix(line, "//"))) {
			if (str_prefix(line, "./"))
				proc_spawn_exec_wait(line + 2);
			else
				proc_spawn_exec_wait(line);
		} else if (str_eq(line, "ps")) {
			cmd_ps(0);
		} else if (str_eq(line, "ps aux")) {
			cmd_ps(1);
		} else if (str_eq(line, "spawn worker") || str_eq(line, "spawn")) {
			proc_spawn_worker_demo();
			uart_puts("spawned worker (check with ps)\n");
		} else if (str_eq(line, "run task") || str_eq(line, "task")) {
			demo_run_tasks();
		} else if (str_eq(line, "snapshot") || str_eq(line, "~snapshot")) {
			osviz_snapshot();
		} else {
			uart_puts("Unknown command. Type 'help'.\n");
		}
	}
}

void console_run(void)
{
	for (;;) {
		uart_puts("\n=== myos console ===\n");
		/* Once per session: drop -serial stdio TX loopback from boot. */
		uart_rx_flush();
		login_session();
		shell_loop();
	}
}
