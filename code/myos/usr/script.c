#include "os.h"
#include "fs.h"
#include "proc.h"
#include "proc_user.h"
#include "shell_env.h"
#include "platform.h"
#include "sbi.h"

#define SCRIPT_STEP_OK    0
#define SCRIPT_STEP_SLEEP 1
#define SCRIPT_STEP_DONE  2

static struct {
	int active;
	int pid;
	char path[FS_MAX_PATH];
	char buf[FS_MAX_SIZE];
	int len;
	int pos;
	uint64_t sleep_end;
} bg_job;

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

static int is_shebang(const char *line)
{
	return line[0] == '#' && line[1] == '!';
}

static int is_assign_line(const char *line)
{
	const char *p = line;

	while (*p == ' ' || *p == '\t')
		p++;
	if (*p == '\0')
		return 0;
	while (*p && *p != '=' && *p != ' ' && *p != '\t')
		p++;
	return *p == '=';
}

static void run_echo(const char *args)
{
	char out[256];

	skip_space(&args);
	shell_env_expand(args, out, sizeof(out));
	uart_puts(out);
	uart_putc('\n');
}

static int run_sleep_line(const char *args)
{
	int sec = 0;

	skip_space(&args);
	while (*args >= '0' && *args <= '9') {
		sec = sec * 10 + (*args - '0');
		args++;
	}
	if (sec <= 0)
		return SCRIPT_STEP_OK;
	if (proc_current_pid() != PROC_SHELL_PID) {
		bg_job.sleep_end = r_time() + (uint64_t)sec * CLINT_TIMEBASE_FREQ;
		return SCRIPT_STEP_SLEEP;
	}
	shell_sleep_sec(sec);
	return SCRIPT_STEP_OK;
}

static int run_one_line(char *line)
{
	while (*line == ' ' || *line == '\t')
		line++;
	if (*line == '\0' || *line == '#')
		return SCRIPT_STEP_OK;
	if (is_shebang(line))
		return SCRIPT_STEP_OK;
	if (line[0] == '#' || (line[0] == '/' && line[1] == '/'))
		return SCRIPT_STEP_OK;
	if (is_assign_line(line)) {
		if (shell_env_set_line(line) < 0)
			return SCRIPT_STEP_OK;
		return SCRIPT_STEP_OK;
	}
	if (line_eq(line, "echo")) {
		run_echo(line + 4);
		return SCRIPT_STEP_OK;
	}
	if (line_eq(line, "sleep"))
		return run_sleep_line(line + 5);
	printf("sh: unsupported: %s\n", line);
	return SCRIPT_STEP_OK;
}

static int script_run_buf(char *buf, int n)
{
	int i, start;
	int rc = 0;

	start = 0;
	for (i = 0; i <= n; i++) {
		if (i < n && buf[i] != '\n')
			continue;

		buf[i] = '\0';
		if (run_one_line(&buf[start]) == SCRIPT_STEP_SLEEP)
			rc = -1;
		start = i + 1;
	}
	return rc;
}

static int script_run_step(void)
{
	int i, start;
	int step;

	if (!bg_job.active || bg_job.pos >= bg_job.len)
		return SCRIPT_STEP_DONE;

	start = bg_job.pos;
	for (i = bg_job.pos; i <= bg_job.len; i++) {
		if (i < bg_job.len && bg_job.buf[i] != '\n')
			continue;

		bg_job.buf[i] = '\0';
		step = run_one_line(&bg_job.buf[start]);
		bg_job.pos = i + 1;
		if (step == SCRIPT_STEP_SLEEP)
			return SCRIPT_STEP_SLEEP;
		if (step != SCRIPT_STEP_OK)
			return SCRIPT_STEP_DONE;
		start = i + 1;
	}
	return SCRIPT_STEP_DONE;
}

static void script_name_from_path(const char *path, char *name, int namelen)
{
	const char *base = path;
	int j = 0;

	for (j = 0; path[j]; j++) {
		if (path[j] == '/')
			base = path + j + 1;
	}
	j = 0;
	while (base[j] && j < namelen - 1) {
		name[j] = base[j];
		j++;
	}
	name[j] = '\0';
}

int script_run(const char *path)
{
	char buf[FS_MAX_SIZE];
	int fd, n;

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
	script_run_buf(buf, n);
	printf("=== %s done ===\n", path);
	return 0;
}

static int script_load_bg(const char *path)
{
	int fd, n, i;

	if (!path || !path[0])
		return -1;
	for (i = 0; path[i] && i < FS_MAX_PATH - 1; i++)
		bg_job.path[i] = path[i];
	bg_job.path[i] = '\0';

	fd = fs_open(path, O_RDONLY);
	if (fd < 0)
		return -1;
	n = fs_read(fd, bg_job.buf, sizeof(bg_job.buf) - 1);
	fs_close(fd);
	if (n <= 0)
		return -1;
	bg_job.buf[n] = '\0';
	bg_job.len = n;
	bg_job.pos = 0;
	bg_job.sleep_end = 0;
	return 0;
}

int script_run_bg(const char *path)
{
	char name[PROC_NAME_LEN];
	int pid;

	if (bg_job.active) {
		uart_puts("bg: one script job already running\n");
		return -1;
	}
	if (script_load_bg(path) < 0) {
		printf("sh: %s: not found (ramfs)\n", path);
		return -1;
	}

	script_name_from_path(path, name, sizeof(name));
	pid = proc_alloc(name, PROC_SHELL_PID);
	if (pid < 0) {
		uart_puts("bg: no proc slot\n");
		return -1;
	}

	bg_job.active = 1;
	bg_job.pid = pid;
	proc_set_state(pid, PROC_RUNNING);
	return pid;
}

void script_bg_poll(void)
{
	int step;
	int saved_pid;

	if (!bg_job.active)
		return;

	for (;;) {
		if (bg_job.sleep_end) {
			if (r_time() < bg_job.sleep_end)
				return;
			bg_job.sleep_end = 0;
			proc_set_state(bg_job.pid, PROC_RUNNING);
		}

		saved_pid = proc_current_pid();
		proc_set_current_pid(bg_job.pid);
		step = script_run_step();
		proc_set_current_pid(saved_pid);

		if (step == SCRIPT_STEP_SLEEP) {
			proc_set_state(bg_job.pid, PROC_READY);
			return;
		}
		if (step == SCRIPT_STEP_DONE) {
			proc_set_state(bg_job.pid, PROC_UNUSED);
			bg_job.active = 0;
			bg_job.pid = -1;
			return;
		}
	}
}

int script_bg_describe(int pid, char *buf, int buflen)
{
	if (!buf || buflen <= 0)
		return 0;
	if (!bg_job.active || bg_job.pid != pid)
		return 0;
	if (bg_job.sleep_end && r_time() < bg_job.sleep_end)
		snprintf(buf, buflen, "kernel bg script: sleeping (%s)", bg_job.path);
	else
		snprintf(buf, buflen, "kernel bg script: running (%s)", bg_job.path);
	return 1;
}
