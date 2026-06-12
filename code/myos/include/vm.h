#ifndef __VM_H__
#define __VM_H__

#include "types.h"

/* Sv39 page table (physical address of root page). */
typedef uint64_t *pagetable_t;

#define PTE_V   (1L << 0)
#define PTE_R   (1L << 1)
#define PTE_W   (1L << 2)
#define PTE_X   (1L << 3)
#define PTE_U   (1L << 4)
#define PTE_A   (1L << 6)
#define PTE_D   (1L << 7)

#define VM_PERM_KERN  (PTE_R | PTE_W | PTE_X)
#define VM_PERM_USER  (PTE_R | PTE_W | PTE_X | PTE_U)

void     vm_init(void);
pagetable_t vm_kernel_pt(void);
pagetable_t vm_create(void);
void     vm_destroy(pagetable_t pt);

/* Drop user 4KiB mappings (exec reload); leaves kernel map and page-table nodes. */
void     vm_clear_user_pages(pagetable_t pt);
void     vm_activate(pagetable_t pt);

int      vm_map_2m(pagetable_t pt, uint64_t va, uint64_t pa, int perm);
int      vm_map_user_page(pagetable_t pt, uint64_t va, const void *src,
			  uint64_t len, int perm);
int      vm_map_user_zero(pagetable_t pt, uint64_t va, uint64_t len, int perm);
int      vm_map_user_existing(pagetable_t pt, uint64_t va, void *page, int perm);
pagetable_t vm_fork_copy(pagetable_t parent);
uint64_t    vm_pte_at(pagetable_t pt, uint64_t va);

/* User VA -> PA if mapped with PTE_U (xv6 walkaddr). */
uint64_t    vm_walkaddr(pagetable_t pt, uint64_t va);

/* Demand-map one anonymous user page; returns page PA or 0. */
uint64_t    vm_user_fault_map(pagetable_t pt, uint64_t va);

/* Kernel page-fault handler: demand-map user anonymous pages (returns 0 if handled). */
int  vm_fault_handle(int pid, uint64_t stval, reg_t cause);

/* Shell debug (yebiao): inspect ramfs file storage or process Sv39 mappings. */
void vm_info_file(const char *path);
void vm_info_proc(int pid);

/* yebiao with no args: dump kernel + every live process. */
void vm_info_all_procs(void);

#endif /* __VM_H__ */
