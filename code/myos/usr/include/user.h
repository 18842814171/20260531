#ifndef __USER_H__
#define __USER_H__

#include "types.h"

/* Syscall stubs (usr/usys.S). */
int gethid(unsigned int *hid);
int getpid(void);
int open(const char *path, int flags);
int close(int fd);
int read(int fd, void *buf, int len);
int write(int fd, const void *buf, int len);
void exit(int status) __attribute__((noreturn));
int fork(void);
int waitpid(int pid);
int execve(const char *path);

/* usr/ulib.c */
char *strcpy(char *dst, const char *src);
int strcmp(const char *a, const char *b);
uint strlen(const char *s);
void *memset(void *dst, int c, uint n);
void *memmove(void *dst, const void *src, int n);
void *memcpy(void *dst, const void *src, uint n);
int memcmp(const void *a, const void *b, uint n);
int puts(const char *s);

/* usr/printf.c */
void fprintf(int fd, const char *fmt, ...)
	__attribute__((format(printf, 2, 3)));
void printf(const char *fmt, ...)
	__attribute__((format(printf, 1, 2)));

#endif /* __USER_H__ */
