#include "os.h"
#include "sem.h"
#include "proc.h"
#include "proc_user.h"
#include "proc_sched.h"
#include "osviz_k.h"

struct ksem {
	int value;
	int used;
	struct wait_queue wq;
};

static struct ksem sems[SEM_MAX];

void sem_init(void)
{
	int i;

	for (i = 0; i < SEM_MAX; i++) {
		sems[i].value = 0;
		sems[i].used = 0;
		sems[i].wq.head_slot = -1;
	}
}

int sem_create(int initial)
{
	int i;

	if (initial < 0)
		return -1;
	for (i = 0; i < SEM_MAX; i++) {
		if (sems[i].used)
			continue;
		sems[i].used = 1;
		sems[i].value = initial;
		sems[i].wq.head_slot = -1;
		{
			char buf[64];

			snprintf(buf, sizeof(buf),
				 "\"id\":%d,\"value\":%d", i, initial);
			LOG_SEM("create", buf);
		}
		return i;
	}
	return -1;
}

int sem_getval(int id)
{
	if (id < 0 || id >= SEM_MAX || !sems[id].used)
		return -1;
	return sems[id].value;
}

int sem_wait(int id)
{
	int pid = proc_current_pid();
	char buf[96];

	if (id < 0 || id >= SEM_MAX || !sems[id].used)
		return -1;

	while (sems[id].value <= 0) {
		snprintf(buf, sizeof(buf),
			 "\"pid\":%d,\"sem\":%d,\"value\":%d,\"state\":\"BLOCK\"",
			 pid, id, sems[id].value);
		LOG_SEM("wait", buf);
		proc_block(&sems[id].wq);
	}
	sems[id].value--;
	snprintf(buf, sizeof(buf),
		 "\"pid\":%d,\"sem\":%d,\"value\":%d,\"state\":\"RUNNING\"",
		 pid, id, sems[id].value);
	LOG_SEM("acquire", buf);
	return 0;
}

int sem_post(int id)
{
	int pid = proc_current_pid();
	char buf[96];

	if (id < 0 || id >= SEM_MAX || !sems[id].used)
		return -1;

	{
		int wake = sems[id].wq.head_slot >= 0;

		sems[id].value++;
		snprintf(buf, sizeof(buf),
			 "\"pid\":%d,\"sem\":%d,\"value\":%d", pid, id,
			 sems[id].value);
		LOG_SEM("post", buf);
		proc_wakeup(&sems[id].wq);
		if (wake) {
			snprintf(buf, sizeof(buf), "\"sem\":%d", id);
			LOG_SEM("wake", buf);
		}
	}
	return 0;
}
