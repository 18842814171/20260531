#include "os.h"
#include "fs.h"
#include "syscall.h"
#include "proc_user.h"
#include "uaccess.h"
#include "osviz_k.h"

static int sys_open(const char *path, int flags)
{
	char kpath[256];
	int fd;

	if (copy_from_user(kpath, path, sizeof(kpath) - 1) < 0)
		return -1;
	kpath[sizeof(kpath) - 1] = '\0';
	return fs_open(kpath, flags);
}

static int sys_close(int fd)
{
	return fs_close(fd);
}

static int sys_write(int fd, const char *buf, int len)
{
	char kbuf[256];
	int chunk;
	int i;
	int total = 0;

	if (len < 0)
		return -1;
	if (fd == 1 || fd == 2) {
		while (total < len) {
			chunk = len - total;
			if (chunk > (int)sizeof(kbuf))
				chunk = (int)sizeof(kbuf);
			if (copy_from_user(kbuf, buf + total, chunk) < 0)
				return -1;
			for (i = 0; i < chunk; i++)
				uart_putc(kbuf[i]);
			total += chunk;
		}
		return total;
	}
	while (total < len) {
		chunk = len - total;
		if (chunk > (int)sizeof(kbuf))
			chunk = (int)sizeof(kbuf);
		if (copy_from_user(kbuf, buf + total, chunk) < 0)
			return -1;
		chunk = fs_write(fd, kbuf, chunk);
		if (chunk < 0)
			return chunk;
		total += chunk;
	}
	return total;
}

static int sys_read(int fd, char *buf, int len)
{
	char kbuf[256];
	int chunk;
	int n;
	int total = 0;

	if (len <= 0)
		return -1;
	if (fd == 0) {
		while (total < len) {
			chunk = len - total;
			if (chunk > (int)sizeof(kbuf))
				chunk = (int)sizeof(kbuf);
			n = uart_read_buf(kbuf, chunk);
			if (n <= 0)
				break;
			if (copy_to_user(buf + total, kbuf, n) < 0)
				return -1;
			total += n;
			if (n < chunk)
				break;
		}
		return total;
	}
	while (total < len) {
		chunk = len - total;
		if (chunk > (int)sizeof(kbuf))
			chunk = (int)sizeof(kbuf);
		n = fs_read(fd, kbuf, chunk);
		if (n <= 0)
			break;
		if (copy_to_user(buf + total, kbuf, n) < 0)
			return -1;
		total += n;
		if (n < chunk)
			break;
	}
	return total;
}

static int sys_fork(struct context *cxt)
{
	int parent = proc_current_pid();
	int child;

	if (parent <= 0)
		return ENOSYS;

	child = proc_fork(parent);
	if (child < 0)
		return -1;

	cxt->a0 = (reg_t)child;
	osviz_event("proc", "fork", "\"parent\":1");
	return child;
}

static int sys_waitpid(int parent, int child_wanted)
{
	if (parent <= 0)
		return -1;
	if (child_wanted <= 0)
		return ENOSYS;
	return proc_wait(parent, child_wanted);
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
	int pid = proc_current_pid();
	switch (syscall_num) {
	case SYS_gethid:
		{
			unsigned int hid;

			ret = sys_gethid(&hid);
			if (ret == 0)
				ret = copy_to_user((void *)(reg_t)cxt->a0, &hid,
						   sizeof(hid)) == 0 ? 0 : -1;
		}
		break;
	case SYS_getpid:
		ret = pid > 0 ? pid : PROC_SHELL_PID;
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
		ret = sys_fork(cxt);
		break;
	case SYS_waitpid:
		ret = sys_waitpid(pid > 0 ? pid : PROC_SHELL_PID, (int)cxt->a0);
		break;
	case SYS_execve:
		if (pid <= 0) {
			ret = ENOSYS;
			break;
		}
		{
			char kpath[256];

			if (copy_from_user(kpath, (const void *)(reg_t)cxt->a0,
					   sizeof(kpath) - 1) < 0) {
				ret = -1;
				break;
			}
			kpath[sizeof(kpath) - 1] = '\0';
			ret = proc_load_elf(pid, kpath);
			if (ret == 0)
				proc_user_run(pid);
		}
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

	if (syscall_num != SYS_fork)
		cxt->a0 = (reg_t)ret;
}
