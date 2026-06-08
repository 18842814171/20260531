#include "fcntl.h"
#include "user.h"

int main(void)
{
	char buf[256];
	int fd, n;

	fd = open("/home/root/hello.txt", O_RDONLY);
	if (fd < 0) {
		write(2, "file_rw: open hello.txt failed\n", 32);
		return 1;
	}

	n = read(fd, buf, sizeof(buf) - 1);
	if (n > 0) {
		buf[n] = '\0';
		write(1, "--- file_rw output ---\n", 23);
		write(1, buf, n);
		write(1, "--- end ---\n", 12);
	}
	close(fd);
	return 0;
}
