#include "syscall.h"

#define STACK_GROW_PAGES  10
#define STACK_GROW_BYTES  (STACK_GROW_PAGES * 4096)

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

static long syscall1(long n, long a0)
{
	return syscall3(n, a0, 0, 0);
}

static long syscall0(long n)
{
	return syscall3(n, 0, 0, 0);
}

static int write(int fd, const char *buf, int len)
{
	return (int)syscall3(SYS_write, fd, (long)buf, len);
}

static int write_str(const char *s)
{
	int n = 0;

	while (s[n])
		n++;
	return write(1, s, n);
}

static void write_int(int v)
{
	char buf[16];
	int i = 0;
	unsigned int u;
	int neg = 0;

	if (v < 0) {
		neg = 1;
		u = (unsigned int)(-(v + 1)) + 1U;
	} else {
		u = (unsigned int)v;
	}
	if (u == 0) {
		write(1, "0", 1);
		return;
	}
	while (u) {
		buf[i++] = (char)('0' + (u % 10));
		u /= 10;
	}
	if (neg)
		buf[i++] = '-';
	while (i > 0)
		write(1, &buf[--i], 1);
}

static void do_exit(int status)
{
	register long t0 asm("a0") = status;
	register long t7 asm("a7") = SYS_exit;

	asm volatile("ecall" : "+r"(t0) : "r"(t7) : "memory");
	for(;;);
}

static int fork(void)
{
	return (int)syscall0(SYS_fork);
}

static int waitpid(int pid)
{
	return (int)syscall1(SYS_waitpid, (long)pid);
}

/*
 * Lower sp one page at a time and store — kernel demand-maps each page on
 * store fault. No page-table API in user code.
 */
static void grow_stack_pages(const char *who)
{
	int i;

	write_str(who);
	write_str(": growing stack (expect store page faults)...\n");
	for (i = 0; i < STACK_GROW_PAGES; i++) {
		asm volatile(
			"addi sp, sp, -2048\n"
			"addi sp, sp, -2048\n"
			"sb   zero, 0(sp)\n"
			::: "memory");
	}
	write_str(who);
	write_str(": stack grow done\n");
	asm volatile(
		"li   t0, %0\n"
		"add  sp, sp, t0\n"
		:: "i"(STACK_GROW_BYTES) : "t0", "memory");
}

/*
 * 用全局变量模拟 shell 演示里的 ooxx：
 * fork 时整页复制，父子各自修改互不影响。
 * 注意：myos 里子进程在父进程 waitpid 时才运行，不能并发 sleep。
 */
volatile int ooxx = 222;

int main(void)
{
	int pid;

	grow_stack_pages("parent");
	pid = fork();
	if (pid == 0) {
		grow_stack_pages("child");
		write_str("child:  ooxx=");
		write_int(ooxx);
		write_str(" (expect 222)\n");
		ooxx = 999;
		write_str("child:  ooxx=");
		write_int(ooxx);
		write_str(" (expect 999)\n");
		do_exit(0);
	}

	write_str("parent: fork pid=");
	write_int(pid);
	write_str("\n");
	ooxx = 666;
	write_str("parent: ooxx=666 before wait (child not run yet)\n");
	waitpid(pid);
	write_str("parent: ooxx=");
	write_int(ooxx);
	write_str(" after wait (expect 666)\n");
	do_exit(0);
}
