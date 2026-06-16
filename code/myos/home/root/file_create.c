#include "fcntl.h"
#include "user.h"

int main(void)
{
	const char *path = "/home/root/_test_out.txt";
	const char *msg = "create_ok";
	char buf[16];
	int fd;
	int n;

	fd = open(path, O_WRONLY | O_CREAT | O_TRUNC);
	if (fd < 0) {
		write(1, "file_create: open write failed\n", 32);
		return 1;
	}
	if (write(fd, msg, 9) != 9) {
		close(fd);
		write(1, "file_create: write failed\n", 27);
		return 1;
	}
	close(fd);

	fd = open(path, O_RDONLY);
	if (fd < 0) {
		write(1, "file_create: open read failed\n", 31);
		return 1;
	}
	n = read(fd, buf, sizeof(buf) - 1);
	close(fd);
	if (n != 9 || memcmp(buf, msg, 9) != 0) {
		write(1, "file_create: read mismatch\n", 28);
		return 1;
	}
	write(1, "file_create: ok\n", 16);
	return 0;
}
