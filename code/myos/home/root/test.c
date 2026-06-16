/*
 * Run ELFs listed in /home/root/testcases.list (one name per line).
 * Build: ./usr/compile.sh c test.c
 *        make AUTORUN=test && ./sh/run_batch.sh
 */
#include "fcntl.h"
#include "user.h"

#define LINE_MAX 96
#define NAME_MAX 64

static int read_line(int fd, char *buf, int cap)
{
	int i = 0;
	char c = 0;

	if (cap <= 1)
		return -1;
	while (i < cap - 1) {
		int n = read(fd, &c, 1);

		if (n < 1)
			return i > 0 ? 0 : -1;
		if (c == '\n')
			break;
		if (c == '\r')
			continue;
		buf[i++] = c;
	}
	buf[i] = '\0';
	return 0;
}

static void trim(char *s)
{
	int n;
	int i = 0;

	while (s[i] == ' ' || s[i] == '\t')
		i++;
	if (i > 0)
		memmove(s, s + i, strlen(s + i) + 1);
	n = (int)strlen(s);
	while (n > 0 && (s[n - 1] == ' ' || s[n - 1] == '\t')) {
		s[n - 1] = '\0';
		n--;
	}
}

static const char *base_name(const char *path)
{
	const char *p = path;

	while (*path) {
		if (*path == '/')
			p = path + 1;
		path++;
	}
	return p;
}

static int run_one(const char *path, const char *tag)
{
	int pid;
	int st;

	printf("========== START %s ==========\n", tag);
	pid = fork();
	if (pid < 0) {
		printf("fork failed for %s\n", path);
		printf("========== END %s ==========\n", tag);
		return -1;
	}
	if (pid == 0) {
		if (execve(path) < 0) {
			printf("execve failed: %s\n", path);
			exit(127);
		}
		exit(125);
	}
	st = waitpid(pid);
	printf("exit status=%d\n", st);
	printf("========== END %s ==========\n", tag);
	return st;
}

int main(void)
{
	int fd;
	int pass = 0;
	int fail = 0;
	int skip = 0;
	int total = 0;
	char line[LINE_MAX];
	char tag[NAME_MAX];

	fd = open("/home/root/testcases.list", O_RDONLY);
	if (fd < 0) {
		printf("test: missing /home/root/testcases.list\n");
		return 1;
	}

	printf("test: batch runner start\n");
	while (read_line(fd, line, sizeof(line)) == 0) {
		trim(line);
		if (!line[0] || line[0] == '#')
			continue;
		if (line[0] == '!' || line[0] == '-') {
			skip++;
			continue;
		}

		{
			const char *bn = base_name(line);
			int j = 0;

			while (bn[j] && j < NAME_MAX - 1) {
				tag[j] = bn[j];
				j++;
			}
			tag[j] = '\0';
		}

		total++;
		if (run_one(line, tag) == 0)
			pass++;
		else
			fail++;
	}
	close(fd);

	printf("BATCH_SUMMARY pass=%d fail=%d skip=%d total=%d\n",
	       pass, fail, skip, total);
	write(1, "test: batch done\n", 18);
	if (fail > 0)
		return 1;
	return 0;
}
