#include "os.h"
#include "proc.h"
#include "proc_user.h"
#include "vm.h"

extern reg_t kernel_gp_value;

static void proc_kctx_zero(struct proc_kcontext *k)
{
	reg_t *words = (reg_t *)k;
	int i, n = (int)(sizeof(*k) / sizeof(reg_t));

	for (i = 0; i < n; i++)
		words[i] = 0;
}

static struct {
	int pid;
	int ppid;
	enum proc_state state;
	char name[PROC_NAME_LEN];
	void (*entry)(void);
	int task_idx;
	struct context user_ctx;
	reg_t run_saved_ra;
	reg_t run_saved_sp;
	reg_t run_saved_s0;
	reg_t run_saved_cont;
	int run_sched_parent;
	struct proc_kcontext kctx;
	int kctx_asleep; /* set in proc_sched until swtch back (shell + user blockers) */
	uint8_t kstack[PROC_KSTACK_SIZE] __attribute__((aligned(16)));
	pagetable_t pagetable;
} procs[PROC_MAX];

static int proc_top = 1; /* pid 0 = kernel */

_Static_assert((reg_t)&procs[0].kstack[PROC_KSTACK_SIZE] -
	       (reg_t)&procs[0].user_ctx == PROC_KSTACK_TOP_TO_UCTX,
	       "PROC_KSTACK_TOP_TO_UCTX must match procs[] layout");

void proc_init(void)
{
	int i;

	for (i = 0; i < PROC_MAX; i++) {
		procs[i].pid = -1;
		procs[i].ppid = 0;
		procs[i].state = PROC_UNUSED;
		procs[i].name[0] = '\0';
		procs[i].entry = NULL;
		procs[i].task_idx = -1;
		procs[i].run_saved_ra = 0;
		procs[i].run_saved_sp = 0;
		procs[i].run_saved_cont = 0;
		procs[i].run_sched_parent = 0;
		proc_kctx_zero(&procs[i].kctx);
		procs[i].kctx_asleep = 0;
		procs[i].pagetable = NULL;
	}

	procs[0].pid = 0;
	procs[0].ppid = 0;
	procs[0].state = PROC_RUNNING;
	{
		const char *k = "kernel";
		int j = 0;
		while (k[j] && j < PROC_NAME_LEN - 1) {
			procs[0].name[j] = k[j];
			j++;
		}
		procs[0].name[j] = '\0';
	}
	proc_top = 1;
}

int proc_alloc(const char *name, int ppid)
{
	int i, j;

	for (i = 1; i < PROC_MAX; i++) {
		if (procs[i].state != PROC_UNUSED)
			continue;
		procs[i].pid = proc_top++;
		procs[i].ppid = ppid;
		procs[i].state = PROC_READY;
		procs[i].entry = NULL;
		procs[i].task_idx = -1;
		procs[i].run_saved_ra = 0;
		procs[i].run_saved_sp = 0;
		procs[i].run_saved_cont = 0;
		procs[i].run_sched_parent = 0;
		proc_kctx_zero(&procs[i].kctx);
		procs[i].kctx_asleep = 0;
		procs[i].pagetable = NULL;
		procs[i].name[0] = '\0';
		if (name) {
			for (j = 0; name[j] && j < PROC_NAME_LEN - 1; j++)
				procs[i].name[j] = name[j];
			procs[i].name[j] = '\0';
		}
		return procs[i].pid;
	}
	return -1;
}

void proc_set_name(int pid, const char *name)
{
	int i, j;

	for (i = 0; i < PROC_MAX; i++) {
		if (procs[i].pid != pid)
			continue;
		for (j = 0; name && name[j] && j < PROC_NAME_LEN - 1; j++)
			procs[i].name[j] = name[j];
		procs[i].name[j] = '\0';
		return;
	}
}

enum proc_state proc_get_state(int pid)
{
	int slot = proc_slot_by_pid(pid);

	if (slot < 0)
		return PROC_UNUSED;
	return procs[slot].state;
}

void proc_set_state(int pid, enum proc_state st)
{
	int i;

	for (i = 0; i < PROC_MAX; i++) {
		if (procs[i].pid == pid) {
			if (st == PROC_UNUSED) {
				procs[i].run_saved_cont = 0;
				procs[i].run_saved_ra = 0;
				procs[i].run_saved_sp = 0;
				procs[i].run_saved_s0 = 0;
				procs[i].run_sched_parent = 0;
				proc_kctx_zero(&procs[i].kctx);
				procs[i].kctx_asleep = 0;
				if (procs[i].pagetable) {
					printf("destroy vm pid=%d pt=%p\n",
					       pid, (void *)procs[i].pagetable);
					vm_destroy(procs[i].pagetable);
					procs[i].pagetable = NULL;
				}
			}
			procs[i].state = st;
			return;
		}
	}
}

int proc_pid_by_slot(int slot)
{
	if (slot < 0 || slot >= PROC_MAX)
		return -1;
	if (procs[slot].state == PROC_UNUSED)
		return -1;
	return procs[slot].pid;
}

pagetable_t proc_pagetable(int pid)
{
	int slot = proc_slot_by_pid(pid);

	if (slot < 0)
		return NULL;
	return procs[slot].pagetable;
}

void proc_set_pagetable(int pid, pagetable_t pt)
{
	int slot = proc_slot_by_pid(pid);

	if (slot < 0)
		return;
	procs[slot].pagetable = pt;
}

int proc_slot_by_pid(int pid)
{
	int i;

	for (i = 0; i < PROC_MAX; i++) {
		if (procs[i].pid == pid && procs[i].state != PROC_UNUSED)
			return i;
	}
	return -1;
}

static int sched_rr = 1;

int proc_pick_next_ready(void)
{
	int tries, slot;

	for (tries = 0; tries < PROC_MAX; tries++) {
		slot = (sched_rr + tries) % PROC_MAX;
		if (slot == 0)
			continue;
		if (procs[slot].state != PROC_READY)
			continue;
		if (!procs[slot].pagetable)
			continue;
		/*
		 * READY + active continuation: wakeup target for proc_block below.
		 * Like xv6 sleep/sched — resume the existing path, not dispatch.
		 */
		if (proc_user_run_inflight(procs[slot].pid))
			continue;
		if (procs[slot].kctx_asleep)
			continue;
		sched_rr = (slot + 1) % PROC_MAX;
		return procs[slot].pid;
	}
	return -1;
}

static int sched_rr_resume = 1;

/*
 * READY process that slept in proc_sched (shell UART wait, user syscall block).
 * Distinct from fresh READY user procs (proc_user_run_dispatch).
 */
int proc_pick_next_ready_resume(void)
{
	int tries, slot;

	for (tries = 0; tries < PROC_MAX; tries++) {
		slot = (sched_rr_resume + tries) % PROC_MAX;
		if (slot == 0)
			continue;
		if (procs[slot].state != PROC_READY)
			continue;
		if (!procs[slot].kctx_asleep)
			continue;
		if (procs[slot].kctx.ra == 0)
			continue;
		sched_rr_resume = (slot + 1) % PROC_MAX;
		return procs[slot].pid;
	}
	return -1;
}

int proc_count(void)
{
	int i, n = 0;

	for (i = 0; i < PROC_MAX; i++) {
		if (procs[i].state != PROC_UNUSED)
			n++;
	}
	return n;
}

int proc_list(struct proc_info *out, int max)
{
	int i, n = 0;

	for (i = 0; i < PROC_MAX && n < max; i++) {
		if (procs[i].state == PROC_UNUSED)
			continue;
		out[n].pid = procs[i].pid;
		out[n].ppid = procs[i].ppid;
		out[n].state = procs[i].state;
		{
			int j = 0;
			while (procs[i].name[j] && j < PROC_NAME_LEN - 1) {
				out[n].name[j] = procs[i].name[j];
				j++;
			}
			out[n].name[j] = '\0';
		}
		n++;
	}
	return n;
}

void proc_mark_zombie(int pid)
{
	int slot = proc_slot_by_pid(pid);
	int ppid = -1;

	if (slot >= 0)
		ppid = procs[slot].ppid;
	printf("[zombie] pid=%d parent=%d\n", pid, ppid);
	proc_set_state(pid, PROC_ZOMBIE);
}

struct context *proc_user_ctx(int pid)
{
	int slot = proc_slot_by_pid(pid);

	if (slot < 0)
		return NULL;
	return &procs[slot].user_ctx;
}

struct context *proc_user_ctx_by_kstack_top(reg_t kstack_top)
{
	int i;

	for (i = 0; i < PROC_MAX; i++) {
		if (procs[i].state == PROC_UNUSED)
			continue;
		if ((reg_t)&procs[i].kstack[PROC_KSTACK_SIZE] == kstack_top)
			return &procs[i].user_ctx;
	}
	return NULL;
}

reg_t proc_kstack_top(int pid)
{
	int slot = proc_slot_by_pid(pid);

	if (slot < 0)
		return 0;
	return (reg_t)&procs[slot].kstack[PROC_KSTACK_SIZE];
}

struct proc_kcontext *proc_kctx(int pid)
{
	int slot = proc_slot_by_pid(pid);

	if (slot < 0)
		return NULL;
	return &procs[slot].kctx;
}

void proc_kctx_clear(int pid)
{
	int slot = proc_slot_by_pid(pid);

	if (slot < 0)
		return;
	proc_kctx_zero(&procs[slot].kctx);
	procs[slot].kctx_asleep = 0;
}

void proc_kctx_set_asleep(int pid, int asleep)
{
	int slot = proc_slot_by_pid(pid);

	if (slot < 0)
		return;
	procs[slot].kctx_asleep = asleep ? 1 : 0;
}

reg_t proc_run_saved_ra(int pid)
{
	int slot = proc_slot_by_pid(pid);

	if (slot < 0)
		return 0;
	return procs[slot].run_saved_ra;
}

reg_t proc_run_saved_sp(int pid)
{
	int slot = proc_slot_by_pid(pid);

	if (slot < 0)
		return 0;
	return procs[slot].run_saved_sp;
}

reg_t proc_run_saved_s0(int pid)
{
	int slot = proc_slot_by_pid(pid);

	if (slot < 0)
		return 0;
	return procs[slot].run_saved_s0;
}

reg_t proc_run_saved_cont(int pid)
{
	int slot = proc_slot_by_pid(pid);

	if (slot < 0)
		return 0;
	return procs[slot].run_saved_cont;
}

void proc_save_run_caller(int pid, reg_t ra, reg_t sp, reg_t s0)
{
	int slot = proc_slot_by_pid(pid);

	if (slot < 0)
		return;
	procs[slot].run_saved_ra = ra;
	procs[slot].run_saved_sp = sp;
	procs[slot].run_saved_s0 = s0;
	/* Stage 1 shadow: mirror into xv6-style kctx (not used for resume yet). */
	procs[slot].kctx.ra = ra;
	procs[slot].kctx.sp = sp;
	procs[slot].kctx.s0 = s0;
}

void proc_save_run_cont(int pid, reg_t cont)
{
	int slot = proc_slot_by_pid(pid);

	if (slot < 0)
		return;
	procs[slot].run_saved_cont = cont;
	procs[slot].kctx.ra = cont;
}

void proc_set_run_sched_parent(int pid, int parent_pid)
{
	int slot = proc_slot_by_pid(pid);

	if (slot < 0)
		return;
	procs[slot].run_sched_parent = parent_pid;
}

int proc_run_sched_parent(int pid)
{
	int slot = proc_slot_by_pid(pid);

	if (slot < 0)
		return -1;
	return procs[slot].run_sched_parent;
}

struct proc_gdb_snap proc_gdb_last;

void proc_gdb_checkpoint(int phase, int pid, struct context *cxt)
{
	int slot = proc_slot_by_pid(pid);

	proc_gdb_last.phase = phase;
	proc_gdb_last.pid = pid;
	proc_gdb_last.state = (slot >= 0) ? (int)procs[slot].state : -1;
	proc_gdb_last.cur_pid = proc_current_pid();
	proc_gdb_last.saved_cont = proc_run_saved_cont(pid);
	proc_gdb_last.saved_ra = proc_run_saved_ra(pid);
	proc_gdb_last.cxt_pc = cxt ? cxt->pc : 0;
	proc_gdb_last.cxt_ra = cxt ? cxt->ra : 0;
	proc_gdb_last.cxt_sp = cxt ? cxt->sp : 0;
}

void proc_prepare_kernel_return(struct context *cxt, int pid)
{
	reg_t cont = proc_run_saved_cont(pid);
	reg_t ra = proc_run_saved_ra(pid);
	reg_t sp = proc_run_saved_sp(pid);
	reg_t s0 = proc_run_saved_s0(pid);
	reg_t pc;

	if (!cxt || !ra)
		panic("proc_prepare_kernel_return: no saved caller");
	pc = cont ? cont : ra;
	cxt->pc = pc;
	cxt->sp = sp;
	cxt->ra = ra;
	cxt->gp = kernel_gp_value;
	cxt->s0 = s0;
	proc_gdb_checkpoint(0, pid, cxt);
}

extern int task_create(void (*start)(void));
extern int sched_task_count(void);

static void worker_demo(void);

static void (*spawn_entry)(void);
static int spawn_pid;

static void spawn_trampoline(void)
{
	if (spawn_entry)
		spawn_entry();
	proc_mark_zombie(spawn_pid);
	for (;;)
		asm volatile("wfi");
}

int proc_spawn(const char *name, void (*entry)(void))
{
	int pid = proc_alloc(name, 0);

	if (pid < 0)
		return -1;

	spawn_pid = pid;
	spawn_entry = entry;
	if (task_create(spawn_trampoline) != 0) {
		proc_set_state(pid, PROC_UNUSED);
		return -1;
	}
	proc_set_state(pid, PROC_READY);
	return pid;
}

void proc_run_binary(const char *name, void *entry, void *stack_top)
{
	int pid = proc_alloc(name, 0);

	(void)stack_top;
	if (pid < 0)
		return;

	spawn_pid = pid;
	spawn_entry = (void (*)(void))entry;
	task_create(spawn_trampoline);
	proc_set_state(pid, PROC_RUNNING);
}

void proc_spawn_worker_demo(void)
{
	proc_spawn("worker", worker_demo);
}

static void worker_demo(void)
{
	int i;

	for (i = 0; i < 3; i++) {
		printf("  [worker pid=%d] step %d/3\n", spawn_pid, i + 1);
		task_delay(2000);
	}
	printf("  [worker pid=%d] done\n", spawn_pid);
}
