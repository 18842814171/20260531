#include "syscall.h"

#define O_RDONLY 0

static long syscall3(long n, long a0, long a1, long a2)
{
	register long t0 asm("a0") = a0;
	register long t1 asm("a1") = a1;
	register long t2 asm("a2") = a2;
	register long t7 asm("a7") = n;

	asm volatile("ecall"
		     : "+r"(t0)
		     : "r"(t1), "r"(t2), "r"(t7)
		     : "memory");
	return t0;
}

static int open(const char *path, int flags)
{
	return (int)syscall3(SYS_open, (long)path, flags, 0);
}

static int read(int fd, char *buf, int len)
{
	return (int)syscall3(SYS_read, fd, (long)buf, len);
}

static int write(int fd, const char *buf, int len)
{
	return (int)syscall3(SYS_write, fd, (long)buf, len);
}

int main(void)
{
	char buf[256];
	int fd, n;

	fd = open("/home/root/hello.txt", O_RDONLY);
	if (fd < 0) {
		write(2, "file_rw: open hello.txt failed\n", 32);
		return 1;
	}

	n = read(fd, buf, sizeof(buf) - 1);
	if (n > 0) {
		buf[n] = '\0';
		write(1, "--- file_rw output ---\n", 23);
		write(1, buf, n);
		write(1, "--- end ---\n", 12);
	}
	return 0;
}
