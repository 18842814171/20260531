#include "os.h"
#include "shell_env.h"
#include "proc_user.h"
#include "platform.h"
#include "sbi.h"

typedef struct {
	char name[SHELL_ENV_NAME_LEN];
	char val[SHELL_ENV_VAL_LEN];
} shell_env_entry_t;

static shell_env_entry_t shell_env[SHELL_ENV_MAX];
static shell_env_entry_t bg_env[SHELL_ENV_MAX];

static shell_env_entry_t *active_env(void)
{
	if (proc_current_pid() != PROC_SHELL_PID)
		return bg_env;
	return shell_env;
}

static int str_eq_name(const char *a, const char *b)
{
	while (*a && *b) {
		if (*a != *b)
			return 0;
		a++;
		b++;
	}
	return *a == *b;
}

static int env_name_ok(const char *s, int n)
{
	int i;

	if (n <= 0 || n >= SHELL_ENV_NAME_LEN)
		return 0;
	for (i = 0; i < n; i++) {
		char c = s[i];

		if ((c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z')
		    || (c >= '0' && c <= '9') || c == '_')
			continue;
		return 0;
	}
	return 1;
}

int shell_env_set(const char *name, const char *val)
{
	int i, n;
	const char *v = val ? val : "";
	shell_env_entry_t *env = active_env();

	if (!name || !name[0])
		return -1;
	for (n = 0; name[n]; n++)
		;
	if (!env_name_ok(name, n))
		return -1;
	for (i = 0; i < SHELL_ENV_MAX; i++) {
		if (env[i].name[0] && !str_eq_name(env[i].name, name))
			continue;
		{
			int j = 0;

			while (name[j] && j < SHELL_ENV_NAME_LEN - 1) {
				env[i].name[j] = name[j];
				j++;
			}
			env[i].name[j] = '\0';
			j = 0;
			while (v[j] && j < SHELL_ENV_VAL_LEN - 1) {
				env[i].val[j] = v[j];
				j++;
			}
			env[i].val[j] = '\0';
		}
		return 0;
	}
	return -1;
}

const char *shell_env_get(const char *name)
{
	int i;
	shell_env_entry_t *env = active_env();

	if (!name || !name[0])
		return NULL;
	for (i = 0; i < SHELL_ENV_MAX; i++) {
		if (env[i].name[0] && str_eq_name(env[i].name, name))
			return env[i].val;
	}
	return NULL;
}

void shell_env_fork(void)
{
	int i;

	for (i = 0; i < SHELL_ENV_MAX; i++)
		bg_env[i] = shell_env[i];
}

void shell_env_reap_bg(void)
{
	int i;

	for (i = 0; i < SHELL_ENV_MAX; i++)
		bg_env[i].name[0] = '\0';
}

int shell_env_set_line(const char *line)
{
	char name[SHELL_ENV_NAME_LEN];
	char val[SHELL_ENV_VAL_LEN];
	int i = 0;
	int j = 0;

	if (!line)
		return -1;
	while (line[i] == ' ' || line[i] == '\t')
		i++;
	while (line[i] && line[i] != '=' && j < SHELL_ENV_NAME_LEN - 1)
		name[j++] = line[i++];
	name[j] = '\0';
	if (line[i] != '=')
		return -1;
	i++;
	while (line[i] == ' ' || line[i] == '\t')
		i++;
	j = 0;
	while (line[i] && j < SHELL_ENV_VAL_LEN - 1)
		val[j++] = line[i++];
	val[j] = '\0';
	return shell_env_set(name, val);
}

void shell_env_expand(const char *in, char *out, int outcap)
{
	int o = 0;

	if (!out || outcap <= 0)
		return;
	if (!in) {
		out[0] = '\0';
		return;
	}
	while (*in && o < outcap - 1) {
		if (*in == '$' && in[1]) {
			char name[SHELL_ENV_NAME_LEN];
			int n = 0;
			const char *p = in + 1;
			const char *val;

			while (*p && n < SHELL_ENV_NAME_LEN - 1
			       && ((*p >= 'a' && *p <= 'z')
				   || (*p >= 'A' && *p <= 'Z')
				   || (*p >= '0' && *p <= '9') || *p == '_'))
				name[n++] = *p++;
			name[n] = '\0';
			val = shell_env_get(name);
			if (val) {
				while (*val && o < outcap - 1)
					out[o++] = *val++;
			}
			in = p;
		} else {
			out[o++] = *in++;
		}
	}
	out[o] = '\0';
}

void shell_sleep_sec(int sec)
{
	uint64_t start;
	uint64_t end;

	if (sec <= 0)
		return;
	start = r_time();
	end = start + (uint64_t)sec * CLINT_TIMEBASE_FREQ;
	while (r_time() < end)
		asm volatile("wfi");
}
