.section .text.entry, "ax", @progbits
.global _start
_start:
	li	sp, 0x80390000
	call	main
	li	a0, 0
	li	a7, 93
	ecall
1:	j	1b
