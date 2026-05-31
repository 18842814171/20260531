.section .text
.global _start
_start:
	li sp, 0x80210000
	li a0, 'H'
	li a7, 1
	ecall
	li a0, '\n'
	li a7, 1
	ecall
1:	j 1b
