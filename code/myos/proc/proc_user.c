#include "os.h"
#include "fs.h"
#include "proc.h"
#include "proc_user.h"
#include "syscall.h"
#include "osviz_k.h"
#include "trap_csr.h"

#define ELF_MAGIC  0x464c457fU
#define PT_LOAD    1
#define EM_RISCV   243
#define USER_STACK_TOP 0x80390000UL

struct elf64_ehdr {
	unsigned char e_ident[16];
	uint16_t e_type;
	uint16_t e_machine;
	uint32_t e_version;
	uint64_t e_entry;
	uint64_t e_phoff;
	uint64_t e_shoff;
	uint32_t e_flags;
	uint16_t e_ehsize;
	uint16_t e_phentsize;
	uint16_t e_phnum;
	uint16_t e_shentsize;
	uint16_t e_shnum;
	uint16_t e_shstrndx;
};

struct elf64_phdr {
	uint32_t p_type;
	uint32_t p_flags;
	uint64_t p_offset;
	uint64_t p_vaddr;
	uint64_t p_paddr;
	uint64_t p_filesz;
	uint64_t p_memsz;
	uint64_t p_align;
};

static char file_buf[FS_MAX_SIZE];

static int exit_status[PROC_MAX];
static int fork_child_pending = -1;
static int current_pid = PROC_SHELL_PID;

extern struct context kernel_trap_cxt;
extern void enter_uspace(struct context *uc, reg_t kstack_top);

static int pid_to_slot(int pid)
{
	return proc_slot_by_pid(pid);
}

struct context *trap_get_user_frame(reg_t kstack_top)
{
	struct context *c = proc_user_ctx_by_kstack_top(kstack_top);

	return c ? c : &kernel_trap_cxt;
}

void proc_enter_uspace(int pid, struct context *uc, reg_t kstack_top)
{
	printf("about to sret child=%d sscratch=0x%lx sepc=0x%lx\n",
	       pid, (unsigned long)kstack_top, (unsigned long)uc->pc);
	current_pid = pid;
	enter_uspace(uc, kstack_top);
}

struct context *proc_user_trap_frame(void)
{
	return proc_user_ctx(proc_current_pid());
}

int proc_current_pid(void)
{
	return current_pid;
}

void proc_set_current_pid(int pid)
{
	current_pid = pid;
}

void proc_user_init(void)
{
	int i;

	for (i = 0; i < PROC_MAX; i++)
		exit_status[i] = 0;
	fork_child_pending = -1;
	current_pid = PROC_SHELL_PID;
	trap_scratch_init(0);
	if (proc_slot_by_pid(PROC_SHELL_PID) < 0)
		proc_alloc("shell", 0);
}

static void uctx_clear(struct context *c)
{
	int i;

	for (i = 0; i < (int)(sizeof(*c) / sizeof(reg_t)); i++)
		((reg_t *)c)[i] = 0;
}

static void uctx_copy(struct context *dst, const struct context *src)
{
	int i, n = (int)(sizeof(*dst) / sizeof(reg_t));

	for (i = 0; i < n; i++)
		((reg_t *)dst)[i] = ((const reg_t *)src)[i];
}

static void addrspace_clone(int child_pid, int parent_pid)
{
	(void)child_pid;
	(void)parent_pid;
	/* Flat address space: fork duplicates trap frame only for now. */
}

int proc_load_elf(int pid, const char *path)
{
	struct elf64_ehdr *eh;
	struct elf64_phdr *ph;
	struct context *uc;
	int n, i;
	reg_t entry;
	char name[PROC_NAME_LEN];
	int slot;

	n = fs_read_file(path, file_buf, sizeof(file_buf));
	if (n < (int)sizeof(struct elf64_ehdr))
		return -1;

	eh = (struct elf64_ehdr *)file_buf;
	if (*(uint32_t *)eh->e_ident != ELF_MAGIC)
		return -1;
	if (eh->e_ident[4] != 2 || eh->e_machine != EM_RISCV)
		return -1;

	ph = (struct elf64_phdr *)(file_buf + eh->e_phoff);
	for (i = 0; i < eh->e_phnum; i++) {
		char *seg;
		uint64_t off;
		uint64_t j;

		if (ph[i].p_type != PT_LOAD)
			continue;
		if (ph[i].p_filesz > ph[i].p_memsz)
			return -1;
		seg = (char *)(unsigned long)ph[i].p_vaddr;
		off = ph[i].p_offset;
		if (off + ph[i].p_filesz > (uint64_t)n)
			return -1;
		for (j = 0; j < ph[i].p_filesz; j++)
			seg[j] = file_buf[off + j];
		for (j = ph[i].p_filesz; j < ph[i].p_memsz; j++)
			seg[j] = 0;
	}

	asm volatile("fence.i" ::: "memory");
	entry = (reg_t)eh->e_entry;

	uc = proc_user_ctx(pid);
	if (!uc)
		return -1;
	uctx_clear(uc);
	uc->pc = entry;
	uc->sp = USER_STACK_TOP;

	{
		const char *p = path;
		int j = 0;

		while (p[j] && j < PROC_NAME_LEN - 1) {
			if (p[j] == '/') {
				int k = j + 1;
				int t = 0;

				while (p[k] && t < PROC_NAME_LEN - 1)
					name[t++] = p[k++];
				name[t] = '\0';
				break;
			}
			j++;
		}
		if (name[0] == '\0') {
			j = 0;
			while (path[j] && j < PROC_NAME_LEN - 1) {
				name[j] = path[j];
				j++;
			}
			name[j] = '\0';
		}
	}
	proc_set_name(pid, name);
	slot = pid_to_slot(pid);
	if (slot >= 0)
		proc_set_state(pid, PROC_READY);
	return 0;
}

int proc_user_run(int pid)
{
	struct context *uc = proc_user_ctx(pid);
	reg_t ktop = proc_kstack_top(pid);
	reg_t saved_ra, saved_sp;

	if (!uc || !ktop)
		return -1;

	printf("proc_user_run begin child=%d current=%d\n", pid, current_pid);

	asm volatile("mv %0, ra" : "=r"(saved_ra));
	asm volatile("mv %0, sp" : "=r"(saved_sp));
	proc_save_run_caller(pid, saved_ra, saved_sp);

	proc_set_state(pid, PROC_RUNNING);
	proc_enter_uspace(pid, uc, ktop);

	trap_scratch_init(0);
	current_pid = PROC_SHELL_PID;
	return 0;
}

void proc_user_exit(int pid, int status)
{
	int slot = pid_to_slot(pid);

	if (slot < 0)
		return;

	exit_status[slot] = status;
	proc_mark_zombie(pid);
}

int proc_fork(int parent_pid)
{
	int child_pid;
	struct context *parent_uc;
	struct context *child_uc;
	int parent_slot, child_slot;

	child_pid = proc_alloc(NULL, parent_pid);
	if (child_pid < 0)
		return -1;

	parent_slot = pid_to_slot(parent_pid);
	child_slot = pid_to_slot(child_pid);
	if (parent_slot < 0 || child_slot < 0)
		return -1;

	parent_uc = proc_user_ctx(parent_pid);
	child_uc = proc_user_ctx(child_pid);
	if (!parent_uc || !child_uc)
		return -1;
	uctx_copy(child_uc, parent_uc);
	child_uc->a0 = 0;
	addrspace_clone(child_pid, parent_pid);
	proc_set_state(child_pid, PROC_READY);
	fork_child_pending = child_pid;
	return child_pid;
}

int proc_wait(int parent_pid, int child_pid)
{
	int i, n;
	struct proc_info list[PROC_MAX];

	(void)parent_pid;

	if (fork_child_pending > 0 && fork_child_pending == child_pid) {
		int cp = fork_child_pending;

		fork_child_pending = -1;
		proc_user_run(cp);
	}

	for (;;) {
		n = proc_list(list, PROC_MAX);
		for (i = 0; i < n; i++) {
			if (list[i].pid != child_pid)
				continue;
			if (list[i].state == PROC_ZOMBIE) {
				int slot = pid_to_slot(child_pid);
				int st = (slot >= 0) ? exit_status[slot] : 0;

				proc_set_state(child_pid, PROC_UNUSED);
				return st;
			}
		}
		asm volatile("wfi");
	}
}

int proc_spawn_exec_wait(const char *path)
{
	int child;
	const char *base;
	char name[PROC_NAME_LEN];
	int j;

	base = path;
	for (j = 0; path[j]; j++) {
		if (path[j] == '/')
			base = path + j + 1;
	}
	j = 0;
	while (base[j] && j < PROC_NAME_LEN - 1) {
		name[j] = base[j];
		j++;
	}
	name[j] = '\0';

	child = proc_alloc(name, PROC_SHELL_PID);
	if (child < 0)
		return -1;

	if (proc_load_elf(child, path) < 0) {
		proc_set_state(child, PROC_UNUSED);
		uart_puts("exec: load failed\n");
		return -1;
	}

	proc_user_run(child);
	return proc_wait(PROC_SHELL_PID, child);
}

int prog_is_elf_path(const char *path)
{
	char hdr[8];
	int n;

	n = fs_read_file(path, hdr, sizeof(hdr));
	if (n < 4)
		return 0;
	return *(uint32_t *)hdr == ELF_MAGIC;
}
