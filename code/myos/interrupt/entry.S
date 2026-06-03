#ifdef CONFIG_OPENSBI
#define LOAD		ld
#define STORE		sd
#define SIZE_REG	8
#define CSR_SCRATCH	sscratch
#define CSR_EPC		sepc
#define CSR_CAUSE	scause
#define CSR_STATUS	sstatus
#define SPP_MASK	(1 << 8)	/* SSTATUS_SPP: sret -> S-mode */
#define SPIE_MASK	(1 << 5)	/* SSTATUS_SPIE */
#define SIE_MASK	(1 << 1)	/* SSTATUS_SIE */
#define TRAP_RET	sret
#else
#define LOAD		lw
#define STORE		sw
#define SIZE_REG	4
#define CSR_SCRATCH	mscratch
#define CSR_EPC		mepc
#define CSR_CAUSE	mcause
#define TRAP_RET	mret
#endif

.macro reg_save base
	STORE ra,   0*SIZE_REG(\base)
	STORE sp,   1*SIZE_REG(\base)
	STORE gp,   2*SIZE_REG(\base)
	STORE tp,   3*SIZE_REG(\base)
	STORE t0,   4*SIZE_REG(\base)
	STORE t1,   5*SIZE_REG(\base)
	STORE t2,   6*SIZE_REG(\base)
	STORE s0,   7*SIZE_REG(\base)
	STORE s1,   8*SIZE_REG(\base)
	STORE a0,   9*SIZE_REG(\base)
	STORE a1,  10*SIZE_REG(\base)
	STORE a2,  11*SIZE_REG(\base)
	STORE a3,  12*SIZE_REG(\base)
	STORE a4,  13*SIZE_REG(\base)
	STORE a5,  14*SIZE_REG(\base)
	STORE a6,  15*SIZE_REG(\base)
	STORE a7,  16*SIZE_REG(\base)
	STORE s2,  17*SIZE_REG(\base)
	STORE s3,  18*SIZE_REG(\base)
	STORE s4,  19*SIZE_REG(\base)
	STORE s5,  20*SIZE_REG(\base)
	STORE s6,  21*SIZE_REG(\base)
	STORE s7,  22*SIZE_REG(\base)
	STORE s8,  23*SIZE_REG(\base)
	STORE s9,  24*SIZE_REG(\base)
	STORE s10, 25*SIZE_REG(\base)
	STORE s11, 26*SIZE_REG(\base)
	STORE t3,  27*SIZE_REG(\base)
	STORE t4,  28*SIZE_REG(\base)
	STORE t5,  29*SIZE_REG(\base)
.endm

.macro reg_restore base
	LOAD ra,   0*SIZE_REG(\base)
	LOAD sp,   1*SIZE_REG(\base)
	LOAD gp,   2*SIZE_REG(\base)
	LOAD tp,   3*SIZE_REG(\base)
	LOAD t0,   4*SIZE_REG(\base)
	LOAD t1,   5*SIZE_REG(\base)
	LOAD t2,   6*SIZE_REG(\base)
	LOAD s0,   7*SIZE_REG(\base)
	LOAD s1,   8*SIZE_REG(\base)
	LOAD a0,   9*SIZE_REG(\base)
	LOAD a1,  10*SIZE_REG(\base)
	LOAD a2,  11*SIZE_REG(\base)
	LOAD a3,  12*SIZE_REG(\base)
	LOAD a4,  13*SIZE_REG(\base)
	LOAD a5,  14*SIZE_REG(\base)
	LOAD a6,  15*SIZE_REG(\base)
	LOAD a7,  16*SIZE_REG(\base)
	LOAD s2,  17*SIZE_REG(\base)
	LOAD s3,  18*SIZE_REG(\base)
	LOAD s4,  19*SIZE_REG(\base)
	LOAD s5,  20*SIZE_REG(\base)
	LOAD s6,  21*SIZE_REG(\base)
	LOAD s7,  22*SIZE_REG(\base)
	LOAD s8,  23*SIZE_REG(\base)
	LOAD s9,  24*SIZE_REG(\base)
	LOAD s10, 25*SIZE_REG(\base)
	LOAD s11, 26*SIZE_REG(\base)
	LOAD t3,  27*SIZE_REG(\base)
	LOAD t4,  28*SIZE_REG(\base)
	LOAD t5,  29*SIZE_REG(\base)
	LOAD t6,  30*SIZE_REG(\base)
.endm

.text
.option norvc

.globl trap_vector
.globl trap_reenable_irq
.globl kernel_trap_busy
.globl trap_nested_timer_ack
.globl kernel_trap_cxt
.globl kernel_gp_value
.globl trap_get_user_frame
.globl trap_diag_post_handler
.globl trap_diag_trap_return
.globl trap_diag_trap_pre
.globl enter_uspace
.globl switch_to

	.text
.balign 4
trap_vector:
	mv	t3, t6
	la	t4, kernel_trap_busy
	lw	t2, 0(t4)
	bnez	t2, .Lskip_trap_pre
	addi	sp, sp, -32
	sd	ra, 0(sp)
	sd	t0, 8(sp)
	sd	t1, 16(sp)
	csrr	t0, CSR_SCRATCH
	csrr	t1, CSR_EPC
	mv	a0, t1
	mv	a1, t0
	call	trap_diag_trap_pre
	ld	t1, 16(sp)
	ld	t0, 8(sp)
	ld	ra, 0(sp)
	addi	sp, sp, 32
.Lskip_trap_pre:
	li	t2, 1
	sw	t2, 0(t4)

	/* sscratch==0: kernel trap; sscratch!=0: user trap (kstack top). */
	csrrw	sp, CSR_SCRATCH, sp
	bnez	sp, .Ltrap_user

	csrr	sp, CSR_SCRATCH
	csrw	CSR_SCRATCH, zero
#ifndef CONFIG_TRAP_NO_NESTED_TIMER_FASTPATH
	la	t4, kernel_trap_busy
	lw	t2, 0(t4)
	beqz	t2, 1f
	csrr	t0, CSR_CAUSE
	bgez	t0, 1f
	andi	t0, t0, 0x7ff
	li	t2, 5
	bne	t0, t2, 1f
	addi	sp, sp, -16
	sd	ra, 0(sp)
	call	trap_nested_timer_ack
	ld	ra, 0(sp)
	addi	sp, sp, 16
	TRAP_RET
#endif
1:
	la	t6, kernel_trap_cxt
	j	.Ltrap_save

.Ltrap_user:
	csrr	t4, CSR_SCRATCH
	csrw	CSR_SCRATCH, zero
	mv	t2, sp
	addi	sp, sp, -16
	sd	ra, 0(sp)
	la	t0, kernel_gp_value
	LOAD	gp, 0(t0)
	mv	a0, t2
	call	trap_get_user_frame
	ld	ra, 0(sp)
	addi	sp, sp, 16
	mv	t6, a0
	reg_save t6
	STORE	t3, 30*SIZE_REG(t6)
	STORE	t4, 1*SIZE_REG(t6)
	j	.Ltrap_saved

.Ltrap_save:
	reg_save t6
	STORE	t3, 30*SIZE_REG(t6)

.Ltrap_saved:
#ifdef CONFIG_TRAP_GP_DIAG
	addi	sp, sp, -16
	sd	ra, 0(sp)
	csrr	a0, CSR_EPC
	mv	a1, gp
	call	trap_diag_trap_vector_entry
	ld	ra, 0(sp)
	addi	sp, sp, 16
#endif
	mv	t5, t6

	csrr	a0, CSR_EPC
	STORE	a0, 31*SIZE_REG(t5)

	csrr	a0, CSR_EPC
	csrr	a1, CSR_CAUSE
	mv	a2, t5

	addi	sp, sp, -16
	sd	ra, 0(sp)
	sd	t5, 8(sp)
	call	trap_handler
	ld	t5, 8(sp)
	ld	ra, 0(sp)
	addi	sp, sp, 16

	csrw	CSR_EPC, a0

	addi	sp, sp, -16
	sd	ra, 0(sp)
	sd	a0, 8(sp)
	call	trap_diag_post_handler
	ld	a0, 8(sp)
	ld	ra, 0(sp)
	addi	sp, sp, 16

	mv	t6, t5

	addi	sp, sp, -32
	sd	ra, 0(sp)
	sd	t6, 8(sp)
	csrr	a0, CSR_EPC
	mv	a1, t6
	call	trap_diag_trap_return
	ld	t6, 8(sp)
	ld	ra, 0(sp)
	addi	sp, sp, 32

	reg_restore t6

	la	t4, trap_reenable_irq
	lw	t4, 0(t4)
	beqz	t4, 6f
	sw	zero, 0(t4)
	li	t0, SIE_MASK
	csrs	CSR_STATUS, t0
6:
	la	t4, kernel_trap_busy
	sw	zero, 0(t4)
	TRAP_RET

.globl enter_uspace
.globl uart_putc
.balign 4
enter_uspace:
	/* a0 = user context, a1 = kstack_top. Set sscratch before reg_restore (a1 is clobbered). */
	li	t2, SIE_MASK
	csrc	CSR_STATUS, t2
	csrw	CSR_SCRATCH, a1
	LOAD	t1, 31*SIZE_REG(a0)
	csrw	CSR_EPC, t1
	mv	t6, a0
	reg_restore t6
#ifdef CONFIG_OPENSBI
	li	t0, SPP_MASK
	csrc	CSR_STATUS, t0
	li	t0, SPIE_MASK
	csrs	CSR_STATUS, t0
#endif
	addi	sp, sp, -16
	sd	ra, 0(sp)
	li	a0, '>'
	call	uart_putc
	ld	ra, 0(sp)
	addi	sp, sp, 16
	TRAP_RET

.globl switch_to
.balign 4
switch_to:
	csrw	CSR_SCRATCH, zero
	LOAD	a1, 31*SIZE_REG(a0)
	csrw	CSR_EPC, a1

	mv	t6, a0
	reg_restore t6

#ifdef CONFIG_OPENSBI
	/* Scheduler / kernel task switch: stay in S-mode. */
	li	t0, SPP_MASK
	csrs	CSR_STATUS, t0
	li	t0, SPIE_MASK
	csrs	CSR_STATUS, t0
#endif

	TRAP_RET

.end
