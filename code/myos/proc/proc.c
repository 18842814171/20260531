#include "os.h"
#include "proc.h"

extern reg_t kernel_gp_value;

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
	uint8_t kstack[PROC_KSTACK_SIZE] __attribute__((aligned(16)));
} procs[PROC_MAX];

static int proc_top = 1; /* pid 0 = kernel */

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

void proc_set_state(int pid, enum proc_state st)
{
	int i;

	for (i = 0; i < PROC_MAX; i++) {
		if (procs[i].pid == pid) {
			procs[i].state = st;
			return;
		}
	}
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

void proc_save_run_caller(int pid, reg_t ra, reg_t sp)
{
	int slot = proc_slot_by_pid(pid);

	if (slot < 0)
		return;
	procs[slot].run_saved_ra = ra;
	procs[slot].run_saved_sp = sp;
}

void proc_prepare_kernel_return(struct context *cxt, int pid)
{
	reg_t ra = proc_run_saved_ra(pid);
	reg_t sp = proc_run_saved_sp(pid);

	if (!cxt || !ra)
		return;
	cxt->pc = ra;
	cxt->sp = sp;
	cxt->ra = ra;
	cxt->gp = kernel_gp_value;
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
