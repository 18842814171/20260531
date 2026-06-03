#include "os.h"
#include "trap_csr.h"
#include "trap_diag.h"

int spin_lock()
{
	cpu_irq_disable();
	return 0;
}

int spin_unlock()
{
	/* Do not enable IRQ while inside trap_handler (nested trap risk). */
	if (kernel_trap_depth == 0)
		cpu_irq_enable();
	return 0;
}
