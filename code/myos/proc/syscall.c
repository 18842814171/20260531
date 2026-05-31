#include "os.h"
#include "fs.h"
#include "syscall.h"
#include "osviz_k.h"

static int sys_open(const char *path, int flags)
{
	return fs_open(path, flags);
}

static int sys_close(int fd)
{
	return fs_close(fd);
}

static int sys_write(int fd, const char *buf, int len)
{
	int i;

	if (!buf || len < 0)
		return -1;
	if (fd == 1 || fd == 2) {
		for (i = 0; i < len; i++)
			uart_putc(buf[i]);
		return i;
	}
	return fs_write(fd, buf, len);
}

static int sys_read(int fd, char *buf, int len)
{
	if (!buf || len <= 0)
		return -1;
	if (fd == 0)
		return uart_read_buf(buf, len);
	return fs_read(fd, buf, len);
}

static int sys_fork(void)
{
	return ENOSYS;
}

int sys_gethid(unsigned int *ptr_hid)
{
	if (ptr_hid == NULL)
		return -1;
	*ptr_hid = (unsigned int)r_mhartid();
	return 0;
}

void do_syscall(struct context *cxt)
{
	uint32_t syscall_num = (uint32_t)cxt->a7;
	int ret = ENOSYS;

	switch (syscall_num) {
	case SYS_gethid:
		ret = sys_gethid((unsigned int *)(reg_t)cxt->a0);
		break;
	case SYS_open:
		ret = sys_open((const char *)(reg_t)cxt->a0, (int)cxt->a1);
		break;
	case SYS_close:
		ret = sys_close((int)cxt->a0);
		break;
	case SYS_write:
		ret = sys_write((int)cxt->a0, (const char *)(reg_t)cxt->a1,
				(int)cxt->a2);
		break;
	case SYS_read:
		ret = sys_read((int)cxt->a0, (char *)(reg_t)cxt->a1, (int)cxt->a2);
		break;
	case SYS_exit:
		ret = 0;
		break;
	case SYS_fork:
		ret = sys_fork();
		osviz_event("proc", "fork_attempt", "\"ret\":-38");
		break;
	case SYS_osviz_event:
		if (cxt->a0 && cxt->a1)
			osviz_event((const char *)(reg_t)cxt->a0,
				    (const char *)(reg_t)cxt->a1,
				    cxt->a2 ? (const char *)(reg_t)cxt->a2 : NULL);
		ret = 0;
		break;
	case SYS_osviz_snap:
		osviz_snapshot();
		ret = 0;
		break;
	default:
		printf("Unknown syscall no: %u\n", syscall_num);
		ret = ENOSYS;
		break;
	}

	cxt->a0 = (reg_t)ret;
}
