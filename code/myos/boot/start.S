#include "platform.h"

	.equ	STACK_SIZE, 4096

	.global	_start
#ifdef CONFIG_OPENSBI
	.extern boot_hartid
	.extern boot_dtb
#endif

	.text
_start:
#ifdef CONFIG_OPENSBI
	# OpenSBI M→S handoff: a0=hartid, a1=dtb (see 5.18 hello.s).
	# Do not read mhartid here — it traps in S-mode before stvec is set.
	mv	tp, a0
	bnez	a0, park

	csrw	sie, zero
	li	t1, 2
	csrc	sstatus, t1

	/* 128M QEMU RAM ends at 0x88000000; keep stack below that (see platform.h). */
	li	sp, 0x87FF0000

	/* P0: gp must be valid before any C code (trap_init captures kernel_gp). */
.option push
.option norelax
	la	gp, __global_pointer$
.option pop

	# Clear BSS (must run before C; boot_hartid/boot_dtb live in .bss)
	la	t0, _bss_start
	la	t1, _bss_end
	bgeu	t0, t1, 2f
1:
	sd	zero, 0(t0)
	addi	t0, t0, 8
	bltu	t0, t1, 1b
2:
	la	t2, boot_hartid
	sd	a0, 0(t2)
	la	t2, boot_dtb
	sd	a1, 0(t2)

	j	start_kernel
#else
	csrr	t0, mhartid
	mv	tp, t0
	bnez	t0, park

	la	a0, _bss_start
	la	a1, _bss_end
	bgeu	a0, a1, 2f
1:
	sw	zero, (a0)
	addi	a0, a0, 4
	bltu	a0, a1, 1b
2:
	slli	t0, t0, 10
	la	sp, stacks + STACK_SIZE
	add	sp, sp, t0

.option push
.option norelax
	la	gp, __global_pointer$
.option pop

#ifdef CONFIG_SYSCALL
	li      t0, 0xffffffff
	csrw    pmpaddr0, t0
	li      t0, 0xf
	csrw    pmpcfg0, t0
	li	t0, 3 << 11
	csrc	mstatus, t0
#else
	li	t0, 3 << 11 | 1 << 7
	csrs	mstatus, t0
#endif

	j	start_kernel
#endif

park:
	wfi
	j	park

#ifndef CONFIG_OPENSBI
.balign 16
stacks:
	.skip	STACK_SIZE * MAXNUM_CPU
#endif

	.end
