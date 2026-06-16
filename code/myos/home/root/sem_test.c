#include "user.h"

int main(void)
{
	int sem;
	int pid;

	sem = sem_create(0);
	if (sem < 0) {
		write(1, "sem_test: create failed\n", 24);
		return 1;
	}

	pid = fork();
	if (pid < 0) {
		write(1, "sem_test: fork failed\n", 22);
		return 1;
	}
	if (pid == 0) {
		sem_wait(sem);
		exit(0);
	}

	sem_post(sem);
	if (waitpid(pid) != 0) {
		write(1, "sem_test: bad child status\n", 27);
		return 1;
	}
	write(1, "sem_test: ok\n", 13);
	return 0;
}
