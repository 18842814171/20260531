/*
 * Use more stack than exec() pre-maps; kernel demand-maps on store fault.
 */
#include "user.h"

#define STACK_GROW_BYTES  (20 * 4096)

int main(void)
{
	int i;

	write(1, "pagefault: using more stack than usual...\n", 42);
	for (i = 0; i < 20; i++) {
		asm volatile(
			"addi sp, sp, -2048\n"
			"addi sp, sp, -2048\n"
			"sb   zero, 0(sp)\n"
			::: "memory");
	}
	write(1, "pagefault: done.\n", 17);
	asm volatile(
		"li   t0, %0\n"
		"add  sp, sp, t0\n"
		:: "i"(STACK_GROW_BYTES) : "t0", "memory");
	exit(0);
}
