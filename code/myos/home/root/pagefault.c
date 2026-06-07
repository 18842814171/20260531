/*
 * Ordinary C program: use more stack than exec() pre-maps; the kernel
 * handles page faults on store — no mention of page tables here.
 */
#include "syscall.h"

#define STACK_GROW_BYTES  (20 * 4096)

static int write(int fd, const char *buf, int len)
{
	register long t0 asm("a0") = fd;
	register long t1 asm("a1") = (long)buf;
	register long t2 asm("a2") = len;
	register long t7 asm("a7") = SYS_write;

	asm volatile("ecall" : "+r"(t0) : "r"(t1), "r"(t2), "r"(t7) : "memory");
	return (int)t0;
}

static void do_exit(int status)
{
	register long t0 asm("a0") = status;
	register long t7 asm("a7") = SYS_exit;

	asm volatile("ecall" : "+r"(t0) : "r"(t7) : "memory");
}

int main(void)
{
	int i;

	write(1, "pagefault: using more stack than usual...\n", 42);
	/* Touch one page at a time via sp only (avoid frame-pointer locals above sp). */
	for (i = 0; i < 20; i++) {
		asm volatile(
			"addi sp, sp, -2048\n"
			"addi sp, sp, -2048\n"
			"sb   zero, 0(sp)\n"
			::: "memory");
	}
	write(1, "pagefault: done.\n", 16);
	/*
	 * Restore sp before teardown: sb zero,0(sp) clears stack slots
	 * (including crt0's return address). Use SYS_exit — do not ret to crt0.
	 */
	asm volatile(
		"li   t0, %0\n"
		"add  sp, sp, t0\n"
		:: "i"(STACK_GROW_BYTES) : "t0", "memory");
	do_exit(0);
}
