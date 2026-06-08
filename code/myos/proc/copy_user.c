#include "os.h"
#include "uaccess.h"
#include "proc_user.h"
#include "proc.h"
#include "vm.h"

#define PGSIZE 4096UL
#define PGMASK (PGSIZE - 1)

static void kcopy(void *dst, const void *src, int n)
{
	char *d = (char *)dst;
	const char *s = (const char *)src;
	int i;

	for (i = 0; i < n; i++)
		d[i] = s[i];
}

static pagetable_t current_pt(void)
{
	int pid = proc_current_pid();

	if (pid <= 0)
		return NULL;
	return proc_pagetable(pid);
}

static int user_range_ok(uint64_t addr, size_t len)
{
	uint64_t end;

	if (len == 0)
		return 1;
	if (addr < USER_MEM_BASE || addr >= USER_MEM_END)
		return 0;
	end = addr + len;
	if (end <= addr || end > USER_MEM_END)
		return 0;
	return 1;
}

/* xv6 copyin: walk user PTEs and copy via physical pages. */
static int copyin(pagetable_t pt, void *dst, uint64_t srcva, size_t len)
{
	uint64_t n;
	uint64_t va0;
	uint64_t pa0;
	char *d = (char *)dst;

	while (len > 0) {
		va0 = srcva & ~PGMASK;
		pa0 = vm_walkaddr(pt, va0);
		if (pa0 == 0) {
			pa0 = vm_user_fault_map(pt, va0);
			if (pa0 == 0)
				return -1;
		}
		n = PGSIZE - (srcva - va0);
		if (n > len)
			n = len;
		kcopy(d, (void *)(pa0 + (srcva - va0)), (int)n);
		len -= n;
		d += n;
		srcva = va0 + PGSIZE;
	}
	return 0;
}

/* xv6 copyout: forbid writes to read-only user pages. */
static int copyout(pagetable_t pt, uint64_t dstva, const void *src, size_t len)
{
	uint64_t n;
	uint64_t va0;
	uint64_t pa0;
	uint64_t pte;
	const char *s = (const char *)src;

	while (len > 0) {
		va0 = dstva & ~PGMASK;
		if (va0 >= USER_MEM_END)
			return -1;
		pa0 = vm_walkaddr(pt, va0);
		if (pa0 == 0) {
			pa0 = vm_user_fault_map(pt, va0);
			if (pa0 == 0)
				return -1;
		}
		pte = vm_pte_at(pt, va0);
		if (!(pte & PTE_W))
			return -1;
		n = PGSIZE - (dstva - va0);
		if (n > len)
			n = len;
		kcopy((void *)(pa0 + (dstva - va0)), s, (int)n);
		len -= n;
		s += n;
		dstva = va0 + PGSIZE;
	}
	return 0;
}

int copy_from_user(void *dst, const void *usr, size_t n)
{
	pagetable_t pt;

	if (!dst || !usr)
		return -1;
	if (!user_range_ok((uint64_t)usr, n))
		return -1;
	pt = current_pt();
	if (!pt)
		return -1;
	return copyin(pt, dst, (uint64_t)usr, n);
}

int copy_to_user(void *usr, const void *src, size_t n)
{
	pagetable_t pt;

	if (!usr || !src)
		return -1;
	if (!user_range_ok((uint64_t)usr, n))
		return -1;
	pt = current_pt();
	if (!pt)
		return -1;
	return copyout(pt, (uint64_t)usr, src, n);
}

int copyinstr(void *dst, const void *usr, size_t max)
{
	pagetable_t pt;
	uint64_t srcva;
	uint64_t n;
	uint64_t va0;
	uint64_t pa0;
	int got_null = 0;
	char *d = (char *)dst;

	if (!dst || !usr || max == 0)
		return -1;
	srcva = (uint64_t)usr;
	if (srcva < USER_MEM_BASE || srcva >= USER_MEM_END)
		return -1;
	pt = current_pt();
	if (!pt)
		return -1;

	while (!got_null && max > 0) {
		va0 = srcva & ~PGMASK;
		pa0 = vm_walkaddr(pt, va0);
		if (pa0 == 0) {
			pa0 = vm_user_fault_map(pt, va0);
			if (pa0 == 0)
				return -1;
		}
		n = PGSIZE - (srcva - va0);
		if (n > max)
			n = max;
		{
			char *p = (char *)(pa0 + (srcva - va0));

			while (n > 0) {
				if (*p == '\0') {
					*d = '\0';
					got_null = 1;
					break;
				}
				*d++ = *p++;
				n--;
				max--;
			}
		}
		srcva = va0 + PGSIZE;
	}
	return got_null ? 0 : -1;
}
