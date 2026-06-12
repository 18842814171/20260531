#include "user.h"

int main(void)
{
	int pid;
	int i;

	pid = fork();
	if (pid == 0) {
		for (i = 0; i < 3; i++) {
			printf("child yield round %d\n", i);
			yield();
		}
		exit(0);
	}

	for (i = 0; i < 3; i++) {
		printf("parent yield round %d\n", i);
		yield();
	}
	waitpid(pid);
	printf("yield_demo done\n");
	return 0;
}

//yield() 就是进程自愿放弃当前 CPU 时间片，让调度器有机会运行其他进程，从而实现父子进程“轮流打印”的效果