#include "syscall.h"

.macro SYSCALL name, num
.global \name
\name:
	li a7, \num
	ecall
	ret
.endm

SYSCALL gethid, SYS_gethid
SYSCALL getpid, SYS_getpid
SYSCALL open, SYS_open
SYSCALL close, SYS_close
SYSCALL read, SYS_read
SYSCALL write, SYS_write
SYSCALL exit, SYS_exit
SYSCALL fork, SYS_fork
SYSCALL waitpid, SYS_waitpid
SYSCALL execve, SYS_execve
