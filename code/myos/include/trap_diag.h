#ifndef __TRAP_DIAG_H__
#define __TRAP_DIAG_H__

#include "types.h"
#include "config.h"

#ifndef DEBUG
#define DEBUG CONFIG_LOG
#endif

struct context;

/* Quiet when DEBUG=0 (make DEBUG=0). Panic CSR dump stays on. */
#ifndef TRAP_DIAG_VERBOSE
#define TRAP_DIAG_VERBOSE (DEBUG == 1)
#endif

extern unsigned long trap_diag_user_exit_count;

/* Experiment B: nested kernel trap depth (trap_handler entries). */
extern volatile int kernel_trap_depth;
extern volatile int kernel_trap_busy;

/* Saved in trap_init() from current gp; restored at trap_handler entry. */
extern reg_t kernel_gp_value;

reg_t read_gp(void);

#ifdef CONFIG_TRAP_GP_DIAG
void trap_diag_trap_vector_entry(reg_t sepc, reg_t gp);
#endif

void trap_diag_trap_pre(reg_t epc, reg_t sscratch);
void trap_diag_trap_enter(reg_t epc, reg_t cause, struct context *cxt);
void trap_diag_post_handler(reg_t ret_epc);
void trap_diag_trap_return(reg_t sepc, struct context *frame);
void trap_diag_user_exit_branch(void);
void trap_diag_print_csrs(const char *tag);
void trap_diag_print_fault_frame(reg_t fault_epc, struct context *cxt);

#endif
