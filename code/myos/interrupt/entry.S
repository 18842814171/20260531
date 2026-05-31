#ifdef CONFIG_OPENSBI
#define LOAD		ld
#define STORE		sd
#define SIZE_REG	8
#define CSR_SCRATCH	sscratch
#define CSR_EPC		sepc
#define CSR_CAUSE	scause
#define CSR_STATUS	sstatus
#define SPP_MASK	(1 << 8)	/* SSTATUS_SPP: sret -> S-mode */
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

.globl trap_vector
.globl proc_user_exit_pending
.globl user_trap_save_cxt
.globl kernel_trap_cxt
.globl trap_diag_post_handler
.globl trap_diag_shell_restore_branch
.globl trap_diag_print_csrs
.globl trap_diag_trap_return

	.section .rodata
	.align 3
kernel_trap_sp:
	.dword	0x80210000
user_code_start:
	.dword	0x80380000
user_code_end:
	.dword	0x80400000

	.text
.balign 4
trap_vector:
	csrrw	t6, CSR_SCRATCH, t6
	/* User EPC: save/restore frame via user_trap_save_cxt (per-process). */
	csrr	t4, CSR_EPC
	la	t0, user_code_start
	ld	t0, 0(t0)
	bltu	t4, t0, 1f
	la	t0, user_code_end
	ld	t0, 0(t0)
	bgeu	t4, t0, 1f
	la	t0, user_trap_save_cxt
	ld	t6, 0(t0)
	bnez	t6, 1f
	la	t6, kernel_trap_cxt
1:
	reg_save t6

	mv	t5, t6
	csrr	t6, CSR_SCRATCH
	STORE	t6, 30*SIZE_REG(t5)

	csrr	a0, CSR_EPC
	STORE	a0, 31*SIZE_REG(t5)

	/* t5 = restore frame; sscratch = kernel_trap_cxt for nested traps in C. */
	la	t0, kernel_trap_cxt
	csrw	CSR_SCRATCH, t0

	csrr	a0, CSR_EPC
	csrr	a1, CSR_CAUSE
	mv	a2, t5
	/* User traps run trap_handler on the kernel stack (user sp is tiny). */
	csrr	t4, CSR_EPC
	la	t0, user_code_start
	ld	t0, 0(t0)
	bltu	t4, t0, 1f
	la	t0, user_code_end
	ld	t0, 0(t0)
	bgeu	t4, t0, 1f
	la	t3, kernel_trap_sp
	ld	sp, 0(t3)
1:
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

	la	t4, proc_user_exit_pending
	lw	t4, 0(t4)
	beqz	t4, 2f
	addi	sp, sp, -16
	sd	ra, 0(sp)
	call	trap_diag_user_exit_branch
	ld	ra, 0(sp)
	addi	sp, sp, 16
	la	t0, user_trap_save_cxt
	ld	t6, 0(t0)
	/* User exit via syscall leaves SPP=0; sret must land in S-mode (kernel). */
	li	t0, SPP_MASK
	csrs	CSR_STATUS, t0
	j	3f
2:
	mv	t6, t5
3:
	addi	sp, sp, -32
	sd	ra, 0(sp)
	sd	t6, 8(sp)
	csrr	a0, CSR_EPC
	mv	a1, t6
	call	trap_diag_trap_return
	ld	t6, 8(sp)
	ld	ra, 0(sp)
	addi	sp, sp, 32
	la	t0, kernel_trap_cxt
	csrw	CSR_SCRATCH, t0
	reg_restore t6

	la	t4, proc_user_exit_pending
	beqz	t4, 5f
	la	t4, proc_user_exit_pending
	sw	zero, 0(t4)
5:
	TRAP_RET

.globl switch_to
.balign 4
switch_to:
	LOAD	a1, 31*SIZE_REG(a0)
	csrw	CSR_EPC, a1

	mv	t6, a0
	reg_restore t6

#ifdef CONFIG_OPENSBI
	/* Enter user at U-mode (clear SPP before sret). */
	li	t0, SPP_MASK
	csrc	CSR_STATUS, t0
#endif

	TRAP_RET

.end
