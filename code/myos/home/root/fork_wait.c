#include "user.h"

int main(void)
{
	int pid;
	int st;

	pid = fork();
	if (pid < 0) {
		write(1, "fork_wait: fork failed\n", 23);
		return 1;
	}
	if (pid == 0)
		exit(42);

	st = waitpid(pid);
	if (st != 42) {
		printf("fork_wait: expected 42 got %d\n", st);
		return 1;
	}
	write(1, "fork_wait: ok\n", 14);
	return 0;
}
