#ifndef __TRAP_CSR_H__
#define __TRAP_CSR_H__

#include "riscv.h"

#ifdef CONFIG_OPENSBI

#define TRAP_IRQ_SOFT      1
#define TRAP_IRQ_TIMER     5
#define TRAP_IRQ_EXTERNAL  9

static inline void trap_vec_init(reg_t addr)
{
	w_stvec(addr);
}

static inline reg_t trap_vec_read(void)
{
	return r_stvec();
}

static inline void trap_scratch_init(reg_t val)
{
	w_sscratch(val);
}

static inline void trap_ie_enable(reg_t bits)
{
	w_sie(r_sie() | bits);
}

#define TRAP_IE_SOFT  SIE_SSIE
#define TRAP_IE_TIMER SIE_STIE
#define TRAP_IE_EXT   SIE_SEIE

static inline void cpu_irq_disable(void)
{
	w_sstatus(r_sstatus() & ~SSTATUS_SIE);
}

static inline void cpu_irq_enable(void)
{
	w_sstatus(r_sstatus() | SSTATUS_SIE);
}

#else

#define TRAP_IRQ_SOFT      3
#define TRAP_IRQ_TIMER     7
#define TRAP_IRQ_EXTERNAL  11

static inline void trap_vec_init(reg_t addr)
{
	w_mtvec(addr);
}

static inline reg_t trap_vec_read(void)
{
	return r_mtvec();
}

static inline void trap_scratch_init(reg_t val)
{
	w_mscratch(val);
}

static inline void trap_ie_enable(reg_t bits)
{
	w_mie(r_mie() | bits);
}

#define TRAP_IE_SOFT  MIE_MSIE
#define TRAP_IE_TIMER MIE_MTIE
#define TRAP_IE_EXT   MIE_MEIE

static inline void cpu_irq_disable(void)
{
	w_mstatus(r_mstatus() & ~MSTATUS_MIE);
}

static inline void cpu_irq_enable(void)
{
	w_mstatus(r_mstatus() | MSTATUS_MIE);
}

#define CAUSE_MASK_INTERRUPT (reg_t)0x80000000
#define CAUSE_MASK_ECODE     (reg_t)0x7FFFFFFF

#endif

#ifndef CAUSE_MASK_INTERRUPT
#define CAUSE_MASK_INTERRUPT (reg_t)0x8000000000000000UL
#define CAUSE_MASK_ECODE     (reg_t)0x7FFFFFFFFFFFFFFFUL
#endif

#endif /* __TRAP_CSR_H__ */
