#include "os.h"
#include "trap_csr.h"
#include "trap_diag.h"
#include "osviz_k.h"
#include "proc.h"
#include "proc_user.h"
#include "fs.h"
#include "vm.h"
#include "shell_env.h"

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

static int str_len(const char *s)
{
	int n = 0;

	while (s && s[n])
		n++;
	return n;
}

static int strip_background(char *line)
{
	int n = str_len(line);

	while (n > 0 && (line[n - 1] == ' ' || line[n - 1] == '\t'))
		line[--n] = '\0';
	if (n > 0 && line[n - 1] == '&') {
		line[n - 1] = '\0';
		trim_line(line);
		return 1;
	}
	return 0;
}

static int looks_like_assign(const char *s)
{
	const char *p = s;

	while (*p == ' ' || *p == '\t')
		p++;
	if (*p == '\0')
		return 0;
	while (*p && *p != '=' && *p != ' ' && *p != '\t')
		p++;
	return *p == '=';
}

static void cmd_export(const char *args)
{
	if (shell_env_set_line(args) < 0)
		console_puts("export: bad assignment\n");
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
		console_putc('-');
	while (i > 0)
		console_putc(buf[--i]);
}

static void cmd_ps(int verbose)
{
	struct proc_info list[PROC_MAX];
	char st;
	int n, i;

	n = proc_list(list, PROC_MAX);
	console_puts("USER   PID  PPID STAT CMD\n");
	for (i = 0; i < n; i++) {
		switch (list[i].state) {
		case PROC_RUNNING:
			st = 'R';
			break;
		case PROC_READY:
			st = 'S';
			break;
		case PROC_BLOCKED:
			st = 'D';
			break;
		case PROC_ZOMBIE:
			st = 'Z';
			break;
		default:
			st = '?';
			break;
		}
		console_puts("root ");
		put_dec(list[i].pid);
		console_putc(' ');
		put_dec(list[i].ppid);
		console_puts("   ");
		console_putc(st);
		console_puts("  ");
		console_puts(list[i].name);
		console_putc('\n');
	}
	if (verbose)
		console_puts("(ps aux)\n");
}

static void ls_emit(const char *name, int size, int is_dir, int exec)
{
	console_puts("  ");
	if (is_dir)
		console_putc('d');
	else if (exec)
		console_putc('x');
	else
		console_putc('-');
	console_putc(' ');
	console_puts((char *)name);
	if (!is_dir) {
		console_puts(" ");
		put_dec(size);
		console_puts(" bytes");
	}
	console_putc('\n');
}

static void cmd_ls(const char *path)
{
	const char *dir = path && path[0] ? path : fs_getcwd();

	console_puts(dir);
	console_puts(":\n");
	if (fs_listdir(dir, ls_emit) == 0 && !fs_is_dir(dir))
		console_puts("  (not a directory)\n");
}

static void cmd_pwd(void)
{
#ifdef CONFIG_TRAP_GP_DIAG
	printf("[gp] pwd before: gp=0x%lx kernel_gp=0x%lx\n",
	       (unsigned long)read_gp(), (unsigned long)kernel_gp_value);
#endif
	console_puts((char *)fs_getcwd());
	console_putc('\n');
#ifdef CONFIG_TRAP_GP_DIAG
	printf("[gp] pwd after: gp=0x%lx kernel_gp=0x%lx\n",
	       (unsigned long)read_gp(), (unsigned long)kernel_gp_value);
#endif
}

static void cmd_cd(const char *path)
{
	const char *target = path && path[0] ? path : "/home/root";

	if (fs_chdir(target) < 0)
		console_puts("cd: no such directory\n");
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
		console_puts("(empty)\n");
		return;
	}
	buf[n] = '\0';
	console_puts(buf);
	if (buf[n - 1] != '\n')
		console_putc('\n');
}

static void cmd_echo(char *args, char *redir, int append)
{
	char expanded[256];

	if (args && args[0])
		shell_env_expand(args, expanded, sizeof(expanded));
	else
		expanded[0] = '\0';

	if (redir && redir[0]) {
		if (append) {
			int fd = fs_open(redir, O_WRONLY | O_CREAT | O_APPEND);

			if (fd < 0) {
				console_puts("echo: write failed\n");
				return;
			}
			if (expanded[0]) {
				int i = 0;

				while (expanded[i])
					i++;
				fs_write(fd, expanded, i);
			}
			fs_write(fd, "\n", 1);
			fs_close(fd);
		} else {
			char out[256];
			int n = 0;
			int i = 0;

			if (expanded[0]) {
				while (expanded[i] && n < (int)sizeof(out) - 2)
					out[n++] = expanded[i++];
			}
			out[n++] = '\n';
			fs_write_file(redir, out, n, 1);
		}
		return;
	}
	if (expanded[0]) {
		console_puts(expanded);
		console_putc('\n');
	}
}

static void cmd_touch(const char *path)
{
	if (fs_create(path, 0) < 0 && !fs_exists(path))
		console_puts("touch: failed\n");
}

static void cmd_mkdir(const char *path)
{
	if (!path || !path[0]) {
		console_puts("usage: mkdir <dir>\n");
		return;
	}
	if (fs_mkdir(path) < 0)
		console_puts("mkdir: failed\n");
}

static reg_t shell_irq_save(void)
{
	reg_t s = r_sstatus();
	cpu_irq_disable();
	return s;
}

static void shell_irq_restore(reg_t saved)
{
	if (saved & SSTATUS_SIE)
		cpu_irq_enable();
}

static int login_name_plausible(const char *line)
{
	int i = 0;

	while (line[i]) {
		char c = line[i];

		if (c < 'a' || c > 'z')
			return 0;
		if (++i > 8)
			return 0;
	}
	return i > 0;
}

static int login_session(void)
{
	char line[LINE_MAX];

	console_puts("\nUsername: root\nlogin: \n");
	uart_rx_flush();
	for (;;) {
		cpu_irq_enable();
		if (uart_read_line(line, LINE_MAX) <= 0)
			continue;
		trim_line(line);
		if (line[0] == '\0')
			continue;
		/* Loopback garbage: ignore silently; do NOT re-print login: (causes spam). */
		if (!login_name_plausible(line))
			continue;
		if (is_poweroff_cmd(line))
			machine_poweroff();
		if (str_eq(line, LOGIN_USER))
			return 0;
		console_puts("\nLogin incorrect. Try again.\nlogin: ");
		uart_rx_flush();
	}
}

static int parse_pid_arg(const char *s)
{
	int pid = 0;

	if (!s || (s[0] != 'P' && s[0] != 'p'))
		return -1;
	s++;
	while (*s >= '0' && *s <= '9') {
		pid = pid * 10 + (*s - '0');
		s++;
	}
	if (*s != '\0')
		return -1;
	return pid;
}

static int parse_decimal_pid(const char *s)
{
	int pid = 0;

	if (!s || !s[0])
		return -1;
	while (*s >= '0' && *s <= '9') {
		pid = pid * 10 + (*s - '0');
		s++;
	}
	if (*s != '\0')
		return -1;
	return pid;
}

static void cmd_jobs(void)
{
	char desc[128];
	int pid;

	pid = script_bg_pid();
	if (pid < 0) {
		console_puts("(no background script)\n");
		return;
	}
	console_puts("[");
	put_dec(pid);
	console_puts("] ");
	if (script_bg_describe(pid, desc, sizeof(desc)))
		console_puts(desc);
	else
		console_puts("kernel bg script");
	console_putc('\n');
}

static void cmd_kill(const char *arg)
{
	int pid;

	if (!arg || !arg[0]) {
		pid = script_bg_pid();
		if (pid < 0) {
			console_puts("kill: no background script\n");
			return;
		}
		arg = NULL;
	}
	if (arg) {
		pid = parse_decimal_pid(arg);
		if (pid < 0) {
			console_puts("usage: kill [pid]  (e.g. kill 2)\n");
			return;
		}
	} else {
		pid = script_bg_pid();
	}
	if (script_bg_kill(pid) == 0)
		console_puts("background script stopped\n");
	else
		console_puts("kill: not a background script pid\n");
}

static void cmd_yebiao(const char *arg)
{
	int pid;

	if (!arg || !arg[0]) {
		vm_info_all_procs();
		return;
	}
	if (arg[0] == 'P' || arg[0] == 'p') {
		pid = parse_pid_arg(arg);
		if (pid < 0) {
			console_puts("usage: yebiao P<pid>  (e.g. yebiao P0, yebiao P2)\n");
			return;
		}
		vm_info_proc(pid);
	} else {
		vm_info_file(arg);
	}
}

static void print_help(void)
{
	console_puts("Shell commands (Linux-style):\n");
	console_puts("  cd [dir]        pwd             ls [dir]\n");
	console_puts("  cat <file>      mkdir <dir>     touch <file>\n");
	console_puts("  vi <file> (i/Esc/:wq)\n");
	console_puts("  echo ...        echo ... > f      echo ... >> f\n");
	console_puts("  export k=v      k=v               . script.sh [&]\n");
	console_puts("  ./program [&]   sh script.sh [&]\n");
	console_puts("  ps / ps aux     jobs              kill [pid]\n");
	console_puts("  yebiao [file|P<pid>]  help / logout\n");
}

static void run_script_path(const char *path, int bg)
{
	int pid;

	if (bg) {
		pid = script_run_bg(path);
		if (pid > 0) {
			console_puts("[bg] pid ");
			put_dec(pid);
			console_putc('\n');
			script_bg_poll();
			console_puts("(background script started)\n");
		}
	} else {
		script_run(path);
	}
}

static void run_elf_path(const char *path, int bg)
{
	int pid;

	if (bg) {
		pid = proc_spawn_exec_bg(path);
		if (pid > 0) {
			console_puts("[bg] pid ");
			put_dec(pid);
			console_putc('\n');
		}
	} else {
		proc_spawn_exec_wait(path);
	}
}

extern void demo_run_tasks(void);

static void shell_loop(void)
{
	static char line[LINE_MAX];
	static char prompt[96];

	console_puts("\nWelcome, root.\n");
	fs_chdir("/home/root");
	print_help();

	for (;;) {
		reg_t irq;

		script_bg_poll();
		uart_rx_flush();
		console_putc('\n');
		snprintf(prompt, sizeof(prompt), "root@%s$ ", fs_getcwd());
		if (uart_prompt_and_read_line(prompt, line, LINE_MAX) < 0)
			continue;
		cpu_irq_enable();
		trim_line(line);
		if (line[0] == '\0')
			continue;

		{
			int bg = strip_background(line);

			irq = shell_irq_save();
			if (str_eq(line, "help") || str_eq(line, "?")) {
			print_help();
		} else if (str_eq(line, "logout") || str_eq(line, "exit")) {
			console_puts("Goodbye.\n");
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
		} else if (str_prefix(line, "mkdir ")) {
			cmd_mkdir(skip_word(line + 5));
		} else if (str_eq(line, "mkdir")) {
			cmd_mkdir(NULL);
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
		} else if (str_prefix(line, "export ")) {
			cmd_export(line + 7);
		} else if (looks_like_assign(line)) {
			cmd_export(line);
		} else if (line[0] == '.' && (line[1] == ' ' || line[1] == '\t')) {
			run_script_path(skip_word(line + 1), bg);
		} else if (str_prefix(line, "sh ")) {
			run_script_path(skip_word(line + 2), bg);
		} else if (str_prefix(line, "./") || (line[0] == '/' && !str_prefix(line, "//"))) {
			if (str_prefix(line, "./"))
				run_elf_path(line + 2, bg);
			else
				run_elf_path(line, bg);
		} else if (str_eq(line, "ps")) {
			cmd_ps(0);
		} else if (str_eq(line, "ps aux")) {
			cmd_ps(1);
		} else if (str_eq(line, "jobs")) {
			cmd_jobs();
		} else if (str_eq(line, "kill") || str_prefix(line, "kill ")) {
			cmd_kill(str_eq(line, "kill") ? NULL : skip_word(line + 5));
		} else if (str_eq(line, "spawn worker") || str_eq(line, "spawn")) {
			proc_spawn_worker_demo();
			console_puts("spawned worker (check with ps)\n");
		} else if (str_eq(line, "run task") || str_eq(line, "task")) {
			demo_run_tasks();
		} else if (str_eq(line, "snapshot") || str_eq(line, "~snapshot")) {
			LOG_SNAPSHOT();
		} else if (str_prefix(line, "yebiao ")) {
			cmd_yebiao(skip_word(line + 6));
		} else if (str_eq(line, "yebiao")) {
			cmd_yebiao(NULL);
		} else {
			console_puts("Unknown command. Type 'help'.\n");
		}
			shell_irq_restore(irq);
		}
	}
}

void console_run(void)
{
	for (;;) {
		console_puts("\n=== libertyos console ===\n");
		login_session();
		shell_loop();
	}
}
