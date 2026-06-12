#include "os.h"
#include "vm.h"
#include "proc.h"
#include "ipc_shm.h"

static void *ipc_shm_page;

int ipc_shm_map(int pid)
{
	pagetable_t pt;
	int perm = PTE_U | PTE_R | PTE_W | PTE_V;

	pt = proc_pagetable(pid);
	if (!pt)
		return -1;
	if (!ipc_shm_page) {
		ipc_shm_page = page_alloc(1);
		if (!ipc_shm_page)
			return -1;
	}
	return vm_map_user_existing(pt, USER_IPC_BASE, ipc_shm_page, perm);
}
