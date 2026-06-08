#ifndef __SHELL_ENV_H__
#define __SHELL_ENV_H__

#define SHELL_ENV_MAX      8
#define SHELL_ENV_NAME_LEN 16
#define SHELL_ENV_VAL_LEN  32

int  shell_env_set(const char *name, const char *val);
const char *shell_env_get(const char *name);
int  shell_env_set_line(const char *line);
void shell_env_expand(const char *in, char *out, int outcap);
void shell_sleep_sec(int sec);

#endif /* __SHELL_ENV_H__ */
