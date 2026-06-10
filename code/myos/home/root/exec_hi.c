#include "user.h"

int main(void)
{
	write(1, "exec_hi: calling execve\n", 24);
	if (execve("hi") < 0) {
		write(1, "exec_hi: execve failed\n", 23);
		return 1;
	}
	write(1, "exec_hi: should not reach\n", 27);
	return 0;
}
