#include "os.h"
#include "vm.h"
#include "ipc_shm.h"
#include "proc_user.h"
#include "proc.h"
#include "fs.h"
#include "platform.h"

#define PGSHIFT 12
#define PGSIZE  (1UL << PGSHIFT)
#define PGMASK  (PGSIZE - 1)

#define SATP_MODE_SV39 (8UL << 60)

#define PXMASK          0x1FFUL
#define PXSHIFT(level)  (PGSHIFT + (9 * (level)))
#define PX(va, level)   (((va) >> PXSHIFT(level)) & PXMASK)

#define PA2PTE(pa)   ((((uint64_t)(pa)) >> 12) << 10)
#define PTE2PA(pte)  (((pte) >> 10) << 12)
#define PTE_FLAGS(pte) ((pte) & 0x3FFUL)

// PTE_U:page is user accessible
//PTE_V:page is valid
static pagetable_t kernel_pt;

static void kzero(void *p, int n)
{
	char *b = (char *)p;
	int i;

	for (i = 0; i < n; i++)
		b[i] = 0;
}

static void kcopy(void *dst, const void *src, int n)
{
	char *d = (char *)dst;
	const char *s = (const char *)src;
	int i;

	for (i = 0; i < n; i++)
		d[i] = s[i];
}

static uint64_t *vm_walk(pagetable_t pt, uint64_t va, int alloc)
{
	uint64_t idx;
	int level;
	pagetable_t node = pt;

	for (level = 2; level > 0; level--) {
		idx = PX(va, level);
		if (!(node[idx] & PTE_V)) {
			pagetable_t child;

			if (!alloc)
				return NULL;
			child = (pagetable_t)page_alloc(1);
			if (!child)
				return NULL;
			kzero(child, PGSIZE);
			node[idx] = PA2PTE((uint64_t)child) | PTE_V;
		}
		node = (pagetable_t)PTE2PA(node[idx]);
	}
	return &node[PX(va, 0)];
}

static uint64_t *vm_walk_level1(pagetable_t pt, uint64_t va, int alloc)
{
	uint64_t idx;
	pagetable_t l1;
	pagetable_t l2 = pt;

	idx = PX(va, 2);
	if (!(l2[idx] & PTE_V)) {
		if (!alloc)
			return NULL;
		l1 = (pagetable_t)page_alloc(1);
		if (!l1)
			return NULL;
		kzero(l1, PGSIZE);
		l2[idx] = PA2PTE((uint64_t)l1) | PTE_V;
	} else {
		l1 = (pagetable_t)PTE2PA(l2[idx]);
	}
	return &l1[PX(va, 1)];
}

static void vm_map_kernel_devices(pagetable_t pt)
{
	uint64_t va;

	/* UART @ 0x10000000 */
	vm_map_2m(pt, 0x10000000UL, 0x10000000UL, VM_PERM_KERN);
	/* CLINT @ 0x02000000 */
	vm_map_2m(pt, 0x02000000UL, 0x02000000UL, VM_PERM_KERN);
	/* PLIC: contexts extend past first 2 MiB (e.g. 0x0c201000) */
	for (va = 0x0c000000UL; va < 0x10000000UL; va += 2UL * 1024UL * 1024UL)
		vm_map_2m(pt, va, va, VM_PERM_KERN);
}

static void vm_map_kernel_ram(pagetable_t pt)
{
	uint64_t va;

	/*
	 * 2 MiB identity map, skipping megapages that overlap the user VA
	 * window so per-process 4 KiB PTEs are not shadowed.
	 */
	for (va = 0x80000000UL; va < 0x88000000UL; va += 2UL * 1024UL * 1024UL) {
		if (va + 2UL * 1024UL * 1024UL <= USER_MEM_BASE || va >= USER_MEM_END)
			vm_map_2m(pt, va, va, VM_PERM_KERN);
	}
}

static void vm_map_kernel_into(pagetable_t pt)
{
	vm_map_kernel_ram(pt);
	vm_map_kernel_devices(pt);
}

void vm_activate(pagetable_t pt)
{
	uint64_t satp = SATP_MODE_SV39 | (((uint64_t)pt) >> 12);

	w_satp((reg_t)satp);
}

pagetable_t vm_pt_from_satp(reg_t satp)
{
	if ((satp >> 60) != (SATP_MODE_SV39 >> 60))
		return NULL;
	return (pagetable_t)((satp & ((1UL << 44) - 1)) << 12);
}

void vm_deactivate_if_active(pagetable_t pt)
{
	if (!pt || pt == kernel_pt)
		return;
	if (vm_pt_from_satp(r_satp()) == pt)
		vm_activate(kernel_pt);
}

pagetable_t vm_kernel_pt(void)
{
	return kernel_pt;
}

void vm_init(void)
{
	kernel_pt = (pagetable_t)page_alloc(1);
	if (!kernel_pt)
		panic("vm_init: no page for kernel page table");
	kzero(kernel_pt, PGSIZE);
	vm_map_kernel_into(kernel_pt);
	vm_activate(kernel_pt);
	printf("vm_init: Sv39 enabled satp=0x%lx\n", (unsigned long)r_satp());
}

pagetable_t vm_create(void)
{
	pagetable_t pt = (pagetable_t)page_alloc(1);

	if (!pt)
		return NULL;
	kzero(pt, PGSIZE);
	vm_map_kernel_into(pt);
	return pt;
}

static void vm_free_ptree(pagetable_t pt, int level)
{
	int i;

	for (i = 0; i < 512; i++) {
		uint64_t pte = pt[i];
		pagetable_t child;

		if (!(pte & PTE_V))
			continue;
		/* 4K user leaves are freed in vm_free_user_pages. */
		if (level == 0)
			continue;
		/* 2M kernel identity leaves: do not page_free(pa). */
		if (level == 1 && (pte & (PTE_R | PTE_W | PTE_X)))
			continue;
		child = (pagetable_t)PTE2PA(pte);
		vm_free_ptree(child, level - 1);
		page_free(child);
	}
}

static void vm_free_user_pages(pagetable_t pt)
{
	uint64_t va;

	for (va = USER_MEM_BASE; va < USER_MEM_END; va += PGSIZE) {
		uint64_t *pte = vm_walk(pt, va, 0);

		if (!pte || !(*pte & PTE_V) || !(*pte & PTE_U))
			continue;
		page_free((void *)PTE2PA(*pte));
		*pte = 0;
	}
}

void vm_clear_user_pages(pagetable_t pt)
{
	vm_free_user_pages(pt);
}

void vm_destroy(pagetable_t pt)
{
	if (!pt || pt == kernel_pt)
		return;
	vm_deactivate_if_active(pt);
	vm_free_user_pages(pt);
	vm_free_ptree(pt, 2);
	page_free(pt);
}

int vm_map_2m(pagetable_t pt, uint64_t va, uint64_t pa, int perm)
{
	uint64_t *pte;

	if ((va | pa) & (2UL * 1024UL * 1024UL - 1))
		return -1;
	pte = vm_walk_level1(pt, va, 1);
	if (!pte)
		return -1;
	*pte = PA2PTE(pa) | perm | PTE_V | PTE_A | PTE_D;
	return 0;
}

int vm_map_user_page(pagetable_t pt, uint64_t va, const void *src,
		     uint64_t len, int perm)
{
	uint64_t *pte;
	void *page;
	uint64_t n;

	if (va & PGMASK)
		return -1;
	page = page_alloc(1);
	if (!page)
		return -1;
	kzero(page, PGSIZE);
	if (src && len) {
		n = len;
		if (n > PGSIZE)
			n = PGSIZE;
		kcopy(page, src, (int)n);
	}
	pte = vm_walk(pt, va, 1);
	if (!pte) {
		page_free(page);
		return -1;
	}
	*pte = PA2PTE((uint64_t)page) | perm | PTE_V | PTE_A | PTE_D;
	return 0;
}

int vm_map_user_zero(pagetable_t pt, uint64_t va, uint64_t len, int perm)
{
	return vm_map_user_page(pt, va, NULL, len, perm);
}

int vm_map_user_existing(pagetable_t pt, uint64_t va, void *page, int perm)
{
	uint64_t *pte;

	if (!pt || !page || (va & PGMASK))
		return -1;
	pte = vm_walk(pt, va, 1);
	if (!pte)
		return -1;
	*pte = PA2PTE((uint64_t)page) | perm | PTE_V | PTE_A | PTE_D;
	return 0;
}

uint64_t vm_pte_at(pagetable_t pt, uint64_t va)
{
	uint64_t *pte = vm_walk(pt, va, 0);

	if (!pte)
		return 0;
	return *pte;
}

uint64_t vm_walkaddr(pagetable_t pt, uint64_t va)
{
	uint64_t *pte;
	uint64_t pa;

	if (va < USER_MEM_BASE || va >= USER_MEM_END)
		return 0;
	pte = vm_walk(pt, va, 0);
	if (!pte)
		return 0;
	if (!(*pte & PTE_V))
		return 0;
	if (!(*pte & PTE_U))
		return 0;
	pa = PTE2PA(*pte);
	return pa;
}

uint64_t vm_user_fault_map(pagetable_t pt, uint64_t va)
{
	uint64_t *pte;
	uint64_t page_va;

	if (va < USER_MEM_BASE || va >= USER_MEM_END)
		return 0;
	page_va = va & ~PGMASK;
	pte = vm_walk(pt, page_va, 0);
	if (pte && (*pte & PTE_V) && (*pte & PTE_U))
		return 0;
	if (vm_map_user_zero(pt, page_va, 0, PTE_U | PTE_R | PTE_W | PTE_V) < 0)
		return 0;
	return vm_walkaddr(pt, page_va);
}

static void vm_perm_string(uint64_t pte, char *buf, int cap)
{
	int i = 0;

	if (!buf || cap <= 0)
		return;
	if (pte & PTE_R)
		buf[i++] = 'r';
	if (pte & PTE_W)
		buf[i++] = 'w';
	if (pte & PTE_X)
		buf[i++] = 'x';
	if (pte & PTE_U)
		buf[i++] = 'u';
	buf[i] = '\0';
	if (i == 0 && cap > 1) {
		buf[0] = '-';
		buf[1] = '\0';
	}
}

int vm_fault_handle(int pid, uint64_t stval, reg_t cause)
{
	pagetable_t pt;
	uint64_t va;
	uint64_t *pte;
	reg_t code = cause & 0xff;

	if (pid <= 0 || stval < USER_MEM_BASE || stval >= USER_MEM_END)
		return -1;
	/* Demand-map stack/heap-like accesses only (load/store). */
	if (code != 13 && code != 15)
		return -1;

	pt = proc_pagetable(pid);
	if (!pt)
		return -1;

	va = stval & ~(PGSIZE - 1);
	pte = vm_walk(pt, va, 0);
	if (pte && (*pte & PTE_V) && (*pte & PTE_U))
		return -1;

	if (vm_user_fault_map(pt, va) == 0)
		return -1;
	return 0;
}

void vm_info_file(const char *path)
{
	char norm[FS_MAX_PATH];
	const char *data;
	int size, is_dir, off, pg;

	if (fs_file_stat(path, norm, sizeof(norm), &data, &size, &is_dir) < 0) {
		printf("yebiao: no such file: %s\n", path);
		return;
	}
	printf("yebiao file: %s\n", norm);
	if (is_dir) {
		printf("  type: directory (no file data pages)\n");
		return;
	}
	printf("  note: ramfs copy in kernel RAM, not in a process page table\n");
	printf("  storage: %d bytes @ kernel %p\n", size, (void *)data);
	for (off = 0, pg = 0; off < size; off += (int)PGSIZE, pg++) {
		int chunk = size - off;

		if (chunk > (int)PGSIZE)
			chunk = (int)PGSIZE;
		printf("  page %d: storage_off=0x%x len=%d data=%p\n",
		       pg, off, chunk, (void *)(data + off));
	}
	if (size == 0)
		printf("  (empty file)\n");
}

static const char *proc_state_label(enum proc_state st)
{
	switch (st) {
	case PROC_RUNNING:
		return "R running";
	case PROC_READY:
		return "S sleeping";
	case PROC_BLOCKED:
		return "D blocked";
	case PROC_ZOMBIE:
		return "Z zombie";
	default:
		return "? unknown";
	}
}

void vm_info_proc(int pid)
{
	pagetable_t pt;
	struct proc_info list[PROC_MAX];
	int n, i, found, count;
	uint64_t va;
	char perm[8];
	char note[128];

	if (pid == 0) {
		printf("yebiao proc: pid=0 (kernel)\n");
		printf("  satp=0x%lx root=%p\n", (unsigned long)r_satp(),
		       (void *)kernel_pt);
		printf("  map: Sv39 2MiB identity RAM/MMIO + per-process user 4KiB\n");
		return;
	}

	n = proc_list(list, PROC_MAX);
	found = 0;
	for (i = 0; i < n; i++) {
		if (list[i].pid == pid) {
			found = 1;
			break;
		}
	}
	if (!found) {
		printf("yebiao: no process pid=%d\n", pid);
		return;
	}

	pt = proc_pagetable(pid);
	printf("yebiao proc: pid=%d name=%s state=%s\n", pid, list[i].name,
	       proc_state_label(list[i].state));
	if (!pt) {
		if (script_bg_describe(pid, note, sizeof(note)))
			printf("  %s\n", note);
		else if (pid == 1)
			printf("  interactive shell (kernel task, no user PT)\n");
		else
			printf("  kernel task (no user page table)\n");
		return;
	}
	printf("  satp=0x%lx root=%p\n",
	       (unsigned long)(SATP_MODE_SV39 | (((uint64_t)pt) >> 12)),
	       (void *)pt);
	printf("  user mappings [%lx, %lx):\n",
	       (unsigned long)USER_MEM_BASE, (unsigned long)USER_MEM_END);
	count = 0;
	for (va = USER_MEM_BASE; va < USER_MEM_END; va += PGSIZE) {
		uint64_t pte = vm_pte_at(pt, va);

		if (!(pte & PTE_V) || !(pte & PTE_U))
			continue;
		vm_perm_string(pte, perm, sizeof(perm));
		printf("  va %lx -> pa %lx perm=%s\n",
		       (unsigned long)va, (unsigned long)PTE2PA(pte), perm);
		count++;
	}
	printf("  total user 4KiB pages: %d\n", count);
}

void vm_info_all_procs(void)
{
	struct proc_info list[PROC_MAX];
	int n, i;

	n = proc_list(list, PROC_MAX);
	printf("yebiao: all processes (%d listed)\n", n);
	vm_info_proc(0);
	for (i = 0; i < n; i++) {
		if (list[i].pid == 0)
			continue;
		printf("\n");
		vm_info_proc(list[i].pid);
	}
}

pagetable_t vm_fork_copy(pagetable_t parent)
{
	pagetable_t child;
	uint64_t va;
	uint64_t *src_pte;
	void *page;
	char *dst;
	const char *s;
	int i;

	if (!parent)
		return NULL;
	child = vm_create();
	if (!child)
		return NULL;

	for (va = USER_MEM_BASE; va < USER_MEM_END; va += PGSIZE) {
		src_pte = vm_walk(parent, va, 0);
		if (!src_pte || !(*src_pte & PTE_V) || !(*src_pte & PTE_U))
			continue;
		if (va == USER_IPC_BASE) {
			uint64_t *dst_pte = vm_walk(child, va, 1);

			if (!dst_pte) {
				vm_destroy(child);
				return NULL;
			}
			*dst_pte = (*src_pte & (PTE_R | PTE_W | PTE_X | PTE_U)) |
				PA2PTE(PTE2PA(*src_pte)) | PTE_V | PTE_A | PTE_D;
			continue;
		}
		page = page_alloc(1);
		if (!page) {
			vm_destroy(child);
			return NULL;
		}
		s = (const char *)PTE2PA(*src_pte);
		dst = (char *)page;
		for (i = 0; i < (int)PGSIZE; i++)
			dst[i] = s[i];
		{
			uint64_t *dst_pte = vm_walk(child, va, 1);

			if (!dst_pte) {
				page_free(page);
				vm_destroy(child);
				return NULL;
			}
			*dst_pte = PA2PTE((uint64_t)page) |
				PTE_FLAGS(*src_pte) | PTE_V | PTE_A | PTE_D;
		}
	}
	return child;
}
