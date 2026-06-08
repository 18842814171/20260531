#include "user.h"

#define STACK_GROW_PAGES  10
#define STACK_GROW_BYTES  (STACK_GROW_PAGES * 4096)

static void grow_stack_pages(const char *who)
{
	int i;

	printf("%s: growing stack (expect store page faults)...\n", who);
	for (i = 0; i < STACK_GROW_PAGES; i++) {
		asm volatile(
			"addi sp, sp, -2048\n"
			"addi sp, sp, -2048\n"
			"sb   zero, 0(sp)\n"
			::: "memory");
	}
	printf("%s: stack grow done\n", who);
	asm volatile(
		"li   t0, %0\n"
		"add  sp, sp, t0\n"
		:: "i"(STACK_GROW_BYTES) : "t0", "memory");
}

volatile int ooxx = 222;

int main(void)
{
	int pid;

	grow_stack_pages("parent");
	pid = fork();
	if (pid == 0) {
		grow_stack_pages("child");
		printf("child:  ooxx=%d (expect 222)\n", ooxx);
		ooxx = 999;
		printf("child:  ooxx=%d (expect 999)\n", ooxx);
		exit(0);
	}

	printf("parent: fork pid=%d\n", pid);
	ooxx = 666;
	printf("parent: ooxx=666 before wait (child not run yet)\n");
	waitpid(pid);
	printf("parent: ooxx=%d after wait (expect 666)\n", ooxx);
	exit(0);
}
