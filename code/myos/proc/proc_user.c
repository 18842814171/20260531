#include "os.h"
#include "fs.h"
#include "proc.h"
#include "proc_user.h"
#include "syscall.h"
#include "osviz_k.h"
#include "trap_csr.h"
#include "vm.h"

#define ELF_MAGIC  0x464c457fU
#define PT_LOAD    1
#define EM_RISCV   243
#define PF_X       1
#define PF_W       2
#define PF_R       4
#define USER_STACK_PAGES 4

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
static int spawn_bg_pid = -1;

static void spawn_bg_trampoline(void)
{
	int pid = spawn_bg_pid;

	if (pid <= 0)
		return;
	proc_user_run(pid);
	proc_wait(PROC_SHELL_PID, pid);
	spawn_bg_pid = -1;
}
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
	current_pid = pid;
	w_sscratch(kstack_top);
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

reg_t proc_current_kstack_top(void)
{
	return proc_kstack_top(proc_current_pid());
}

/*
 * User trap: after csrrw, sp must be the process kernel stack top.
 * If sscratch was wrong (user-range), reload from proc_kstack_top().
 */
reg_t trap_fixup_kstack_top(reg_t sp_after_swap)
{
	if (sp_after_swap < USER_MEM_BASE)
		return sp_after_swap;
	return proc_kstack_top(proc_current_pid());
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
	pagetable_t parent_pt = proc_pagetable(parent_pid);
	pagetable_t child_pt;

	if (!parent_pt)
		return;
	child_pt = vm_fork_copy(parent_pt);
	if (child_pt)
		proc_set_pagetable(child_pid, child_pt);
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

	{
		pagetable_t old_pt = proc_pagetable(pid);
		pagetable_t pt = vm_create();

		if (!pt)
			return -1;
		if (old_pt)
			vm_destroy(old_pt);
		proc_set_pagetable(pid, pt);
	}

	ph = (struct elf64_phdr *)(file_buf + eh->e_phoff);
	for (i = 0; i < eh->e_phnum; i++) {
		uint64_t va, off, remain, chunk;
		int perm;
		pagetable_t pt = proc_pagetable(pid);

		if (ph[i].p_type != PT_LOAD)
			continue;
		if (ph[i].p_filesz > ph[i].p_memsz)
			return -1;
		if (ph[i].p_vaddr < USER_MEM_BASE || ph[i].p_vaddr + ph[i].p_memsz > USER_MEM_END)
			return -1;
		off = ph[i].p_offset;
		if (off + ph[i].p_filesz > (uint64_t)n)
			return -1;
		perm = PTE_U | PTE_V;
		if (ph[i].p_flags & PF_R)
			perm |= PTE_R;
		if (ph[i].p_flags & PF_W)
			perm |= PTE_W;
		if (ph[i].p_flags & PF_X)
			perm |= PTE_X;
		if (!perm)
			perm |= PTE_R;
		for (va = ph[i].p_vaddr; va < ph[i].p_vaddr + ph[i].p_memsz; va += 4096UL) {
			uint64_t page_off = va - ph[i].p_vaddr;
			const char *src = NULL;
			uint64_t src_len = 0;

			if (page_off < ph[i].p_filesz) {
				src = file_buf + off + page_off;
				remain = ph[i].p_filesz - page_off;
				chunk = remain > 4096UL ? 4096UL : remain;
				src_len = chunk;
			}
			if (vm_map_user_page(pt, va, src, src_len, perm) < 0)
				return -1;
		}
	}
	{
		pagetable_t pt = proc_pagetable(pid);
		uint64_t sp_va = USER_STACK_TOP - USER_STACK_PAGES * 4096UL;
		uint64_t va;

		for (va = sp_va; va < USER_STACK_TOP; va += 4096UL) {
			if (vm_map_user_zero(pt, va, 0, PTE_U | PTE_R | PTE_W | PTE_V) < 0)
				return -1;
		}
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
	struct context *uc;
	reg_t ktop;
	reg_t saved_ra, saved_sp, saved_s0;
	int saved_pid;

	asm volatile("mv %0, ra" : "=r"(saved_ra));
	asm volatile("mv %0, sp" : "=r"(saved_sp));
	asm volatile("mv %0, s0" : "=r"(saved_s0));

	saved_pid = current_pid;

	uc = proc_user_ctx(pid);
	ktop = proc_kstack_top(pid);
	if (!uc || !ktop)
		return -1;
	if (!proc_pagetable(pid))
		return -1;

	proc_save_run_caller(pid, saved_ra, saved_sp, saved_s0);

	proc_set_state(pid, PROC_RUNNING);
	proc_save_run_cont(pid, (reg_t)&&after_uspace);
	vm_activate(proc_pagetable(pid));
	proc_enter_uspace(pid, uc, ktop);
after_uspace:
	proc_gdb_checkpoint(1, pid, uc);
	printf("proc_user_run: pid=%d returned from user\n", pid);
	vm_activate(vm_kernel_pt());
	trap_scratch_init(0);
	current_pid = saved_pid;
	printf("\nproc_user_run returns 0...\n\n");
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

reg_t proc_user_exit_trap(struct context *cxt)
{
	int pid = proc_current_pid();
	reg_t cont, ret;
	unsigned int status;

	if (pid <= 0)
		return 0;

	vm_activate(vm_kernel_pt());
	status = (unsigned int)cxt->a0;
	if (status > 255)
		status = 0;
	proc_user_exit(pid, (int)status);
	proc_prepare_kernel_return(cxt, pid);
	cont = proc_run_saved_cont(pid);
	ret = cont ? cont : proc_run_saved_ra(pid);
	if (!ret || (ret >= USER_MEM_BASE && ret < USER_MEM_END))
		panic("proc_user_exit_trap: bad kernel return");
	return ret;
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
	/*
	 * enter_uspace() uses uc->pc as sepc. Syscall return advances epc+4 in
	 * trap_handler; fork child must match or it re-executes ecall (fork storm).
	 */
	child_uc->pc += 4;
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
				int st = 0;

				if (slot >= 0)
					st = exit_status[slot];
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
	int wait_st;
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
	wait_st = proc_wait(PROC_SHELL_PID, child);
	return wait_st;
}

int proc_spawn_exec_bg(const char *path)
{
	int child;
	const char *base;
	char name[PROC_NAME_LEN];
	int j;

	if (spawn_bg_pid > 0) {
		uart_puts("bg: one user job already starting\n");
		return -1;
	}

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

	spawn_bg_pid = child;
	if (task_create(spawn_bg_trampoline) != 0) {
		spawn_bg_pid = -1;
		proc_set_state(child, PROC_UNUSED);
		uart_puts("bg: task create failed\n");
		return -1;
	}
	return child;
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
