#include "syscall.h"

.macro SYSCALL name, num
.global \name
\name:
	li a7, \num
	ecall
	ret
.endm

SYSCALL gethid, SYS_gethid
SYSCALL write, SYS_write
SYSCALL read, SYS_read
SYSCALL exit, SYS_exit
SYSCALL fork, SYS_fork
