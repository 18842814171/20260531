#ifndef __TRAP_DIAG_H__
#define __TRAP_DIAG_H__

#include "types.h"

struct context;

/* Set to 0 to silence trap enter/exit logs (panic CSR dump stays on). */
#ifndef TRAP_DIAG_VERBOSE
#define TRAP_DIAG_VERBOSE 0
#endif

extern unsigned long trap_diag_user_exit_count;

void trap_diag_trap_enter(reg_t epc, reg_t cause, struct context *cxt);
void trap_diag_post_handler(reg_t ret_epc);
void trap_diag_trap_return(reg_t sepc, struct context *frame);
void trap_diag_user_exit_branch(void);
void trap_diag_print_csrs(const char *tag);

#endif
