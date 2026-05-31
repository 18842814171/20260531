#ifndef __SBI_H__
#define __SBI_H__

#include "types.h"

/* Legacy SBI extension IDs (OpenSBI / 5.18 hello.s) */
#define SBI_EXT_SET_TIMER	0
#define SBI_EXT_CONSOLE_PUTCHAR	1
#define SBI_EXT_CONSOLE_GETCHAR	2

static inline uint64_t r_time(void)
{
	uint64_t t;

	asm volatile("rdtime %0" : "=r"(t));
	return t;
}

static inline void sbi_set_timer(uint64_t stime)
{
	register unsigned long a0 asm("a0") = stime;
	register unsigned long a7 asm("a7") = SBI_EXT_SET_TIMER;

	asm volatile("ecall" : "+r"(a0) : "r"(a7) : "memory");
}

static inline void sbi_putchar(int ch)
{
	register unsigned long a0 asm("a0") = (unsigned long)ch;
	register unsigned long a7 asm("a7") = SBI_EXT_CONSOLE_PUTCHAR;

	asm volatile("ecall" : "+r"(a0) : "r"(a7) : "memory");
}

/* Returns byte read, or -1 if no input (legacy SBI). */
static inline long sbi_getchar_try(void)
{
	register unsigned long a0 asm("a0") = 0;
	register unsigned long a7 asm("a7") = SBI_EXT_CONSOLE_GETCHAR;

	asm volatile("ecall" : "+r"(a0) : "r"(a7) : "memory");
	return (long)a0;
}

/* Legacy shutdown — QEMU virt exits when OpenSBI handles this. */
#define SBI_EXT_SHUTDOWN	8

static inline void sbi_shutdown(void)
{
	register unsigned long a7 asm("a7") = SBI_EXT_SHUTDOWN;

	asm volatile("ecall" : : "r"(a7) : "memory");
}

#endif /* __SBI_H__ */
