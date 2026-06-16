#include "user.h"

int main(void)
{
	int pid = getpid();

	if (pid <= 0) {
		write(1, "getpid_test: bad pid\n", 21);
		return 1;
	}
	printf("getpid_test: pid=%d ok\n", pid);
	return 0;
}
