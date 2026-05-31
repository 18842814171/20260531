#include "os.h"
#include "fs.h"
#include "syscall.h"
#include "proc_user.h"
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
		ret = sys_gethid((unsigned int *)(reg_t)cxt->a0);
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
		ret = proc_load_elf(pid, (const char *)(reg_t)cxt->a0);
		if (ret == 0)
			proc_user_run(pid);
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
