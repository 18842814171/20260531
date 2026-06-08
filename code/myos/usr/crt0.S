.section .text.entry, "ax", @progbits
.global _start
_start:
	li	sp, 0x80470000
	call	main
	mv	a0, a0
	call	exit
1:	j	1b
