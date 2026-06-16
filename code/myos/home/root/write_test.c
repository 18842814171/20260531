#include "user.h"

int main(void)
{
	if (write(1, "write_test: line1\n", 18) != 18)
		return 1;
	if (write(2, "write_test: stderr\n", 19) != 19)
		return 1;
	write(1, "write_test: ok\n", 15);
	return 0;
}
