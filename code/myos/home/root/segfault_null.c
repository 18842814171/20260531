#include "user.h"

int main(void)
{
	volatile int *p = (volatile int *)0;

	write(1, "segfault_null: before fault\n", 29);
	*p = 1;
	write(1, "segfault_null: should not reach\n", 33);
	return 0;
}
