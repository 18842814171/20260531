#ifndef __RISCV_H__
#define __RISCV_H__

#include "types.h"

static inline reg_t r_tp()
{
	reg_t x;
	asm volatile("mv %0, tp" : "=r" (x));
	return x;
}

static inline reg_t r_mhartid()
{
#ifdef CONFIG_OPENSBI
	/* S-mode: hart id from tp (set from a0 at _start). */
	return r_tp();
#else
	reg_t x;
	asm volatile("csrr %0, mhartid" : "=r" (x));
	return x;
#endif
}

/* mstatus (M-mode) */
#define MSTATUS_MPP (3UL << 11)
#define MSTATUS_MPIE (1UL << 7)
#define MSTATUS_MIE (1UL << 3)

static inline reg_t r_mstatus()
{
	reg_t x;
	asm volatile("csrr %0, mstatus" : "=r" (x));
	return x;
}

static inline void w_mstatus(reg_t x)
{
	asm volatile("csrw mstatus, %0" : : "r" (x));
}

static inline void w_mepc(reg_t x)
{
	asm volatile("csrw mepc, %0" : : "r" (x));
}

static inline reg_t r_mepc()
{
	reg_t x;
	asm volatile("csrr %0, mepc" : "=r" (x));
	return x;
}

static inline void w_mscratch(reg_t x)
{
	asm volatile("csrw mscratch, %0" : : "r" (x));
}

static inline void w_mtvec(reg_t x)
{
	asm volatile("csrw mtvec, %0" : : "r" (x));
}

static inline reg_t r_mtvec()
{
	reg_t x;
	asm volatile("csrr %0, mtvec" : "=r" (x));
	return x;
}

#define MIE_MEIE (1UL << 11)
#define MIE_MTIE (1UL << 7)
#define MIE_MSIE (1UL << 3)

static inline reg_t r_mie()
{
	reg_t x;
	asm volatile("csrr %0, mie" : "=r" (x));
	return x;
}

static inline void w_mie(reg_t x)
{
	asm volatile("csrw mie, %0" : : "r" (x));
}

static inline reg_t r_mcause()
{
	reg_t x;
	asm volatile("csrr %0, mcause" : "=r" (x));
	return x;
}

/* sstatus / S-mode CSRs (used after OpenSBI M→S handoff) */
#define SSTATUS_SPP (1UL << 8)
#define SSTATUS_SPIE (1UL << 5)
#define SSTATUS_SIE (1UL << 1)
#define SSTATUS_SUM (1UL << 18)

static inline reg_t r_sstatus()
{
	reg_t x;
	asm volatile("csrr %0, sstatus" : "=r" (x));
	return x;
}

static inline void w_sstatus(reg_t x)
{
	asm volatile("csrw sstatus, %0" : : "r" (x));
}

static inline void w_sepc(reg_t x)
{
	asm volatile("csrw sepc, %0" : : "r" (x));
}

static inline reg_t r_sepc()
{
	reg_t x;
	asm volatile("csrr %0, sepc" : "=r" (x));
	return x;
}

static inline reg_t r_sscratch(void)
{
	reg_t x;
	asm volatile("csrr %0, sscratch" : "=r" (x));
	return x;
}

static inline void w_sscratch(reg_t x)
{
	asm volatile("csrw sscratch, %0" : : "r" (x));
}

static inline reg_t r_stval(void)
{
	reg_t x;
	asm volatile("csrr %0, stval" : "=r" (x));
	return x;
}

static inline reg_t r_satp(void)
{
	reg_t x;
	asm volatile("csrr %0, satp" : "=r" (x));
	return x;
}

static inline void w_satp(reg_t x)
{
	asm volatile("csrw satp, %0" : : "r" (x));
	asm volatile("sfence.vma zero, zero");
}

static inline void w_stvec(reg_t x)
{
	asm volatile("csrw stvec, %0" : : "r" (x));
}

static inline reg_t r_stvec()
{
	reg_t x;
	asm volatile("csrr %0, stvec" : "=r" (x));
	return x;
}

#define SIE_SEIE (1UL << 9)
#define SIE_STIE (1UL << 5)
#define SIE_SSIE (1UL << 1)

static inline reg_t r_sie()
{
	reg_t x;
	asm volatile("csrr %0, sie" : "=r" (x));
	return x;
}

static inline void w_sie(reg_t x)
{
	asm volatile("csrw sie, %0" : : "r" (x));
}

static inline reg_t r_scause()
{
	reg_t x;
	asm volatile("csrr %0, scause" : "=r" (x));
	return x;
}

#define SIP_SSIP (1UL << 1)

static inline reg_t r_sip()
{
	reg_t x;
	asm volatile("csrr %0, sip" : "=r" (x));
	return x;
}

static inline void w_sip(reg_t x)
{
	asm volatile("csrw sip, %0" : : "r" (x));
}

#define CAUSE_MASK_INTERRUPT (reg_t)0x8000000000000000UL
#define CAUSE_MASK_ECODE     (reg_t)0x7FFFFFFFFFFFFFFFUL

/* Privilege mode helpers (mstatus.MPP or sstatus.SPP) */
static inline int cpu_in_smode(void)
{
#ifdef CONFIG_OPENSBI
	return 1;
#else
	return (r_mstatus() & MSTATUS_MPP) == (1UL << 11);
#endif
}

static inline reg_t r_priv_mode_bits(void)
{
#ifdef CONFIG_OPENSBI
	return r_sstatus();
#else
	return r_mstatus();
#endif
}

#endif /* __RISCV_H__ */
