#include "user.h"

int main(void)
{
	if (yield() < 0) {
		write(1, "yield_once: yield failed\n", 25);
		return 1;
	}
	write(1, "yield_once: ok\n", 15);
	return 0;
}
