#include "syscall.h"

static int write(int fd, const char *buf, int len)
{
	register long t0 asm("a0") = fd;
	register long t1 asm("a1") = (long)buf;
	register long t2 asm("a2") = len;
	register long t7 asm("a7") = SYS_write;

	asm volatile("ecall" : "+r"(t0) : "r"(t1), "r"(t2), "r"(t7) : "memory");
	return (int)t0;
}

int main(void)
{
	write(1, "hi from ./hi\n", 13);
	return 0;
}
