#include "os.h"
#include "trap_csr.h"

int spin_lock()
{
	cpu_irq_disable();
	return 0;
}

int spin_unlock()
{
	cpu_irq_enable();
	return 0;
}
