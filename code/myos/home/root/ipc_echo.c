#include "user.h"

#define IPC_SLOTS 8
#define BUF_SIZE  64
#define IPC_EOF   0

struct ipc_buffer {
	char buf[BUF_SIZE];
	int head;
	int tail;
	int empty_sem;
	int full_sem;
	int mutex_sem;
};

static struct ipc_buffer *ipc = (struct ipc_buffer *)USER_IPC_BASE;

static void ipc_put(char c)
{
	sem_wait(ipc->empty_sem);
	sem_wait(ipc->mutex_sem);
	ipc->buf[ipc->head % BUF_SIZE] = c;
	ipc->head++;
	sem_post(ipc->mutex_sem);
	sem_post(ipc->full_sem);
}

static char ipc_get(void)
{
	char c;

	sem_wait(ipc->full_sem);
	sem_wait(ipc->mutex_sem);
	c = ipc->buf[ipc->tail % BUF_SIZE];
	ipc->tail++;
	sem_post(ipc->mutex_sem);
	sem_post(ipc->empty_sem);
	return c;
}

static void producer_loop(void)
{
	char c;

	for (;;) {
		if (read(0, &c, 1) != 1)
			break;
		if (c == '\r')
			continue;
		if (c == '\n')
			break;
		if (c == 'q' || c == 'Q')
			break;
		ipc_put(c);
		printf("[producer] put '%c' full=%d\n", c,
		       sem_getval(ipc->full_sem));
	}
	ipc_put((char)IPC_EOF);
	exit(0);
}

static void consumer_loop(void)
{
	char c;

	for (;;) {
		c = ipc_get();
		if (c == (char)IPC_EOF)
			break;
		printf("[consumer] get '%c' empty=%d\n", c,
		       sem_getval(ipc->empty_sem));
		write(1, &c, 1);
		write(1, "\n", 1);
	}
	exit(0);
}

int main(void)
{
	int empty, full, mutex;
	int pid_p, pid_c;

	if (ipc_shm_map() < 0) {
		printf("ipc_echo: shm map failed\n");
		exit(1);
	}

	empty = sem_create(IPC_SLOTS);
	full = sem_create(0);
	mutex = sem_create(1);
	if (empty < 0 || full < 0 || mutex < 0) {
		printf("ipc_echo: sem create failed\n");
		exit(1);
	}

	ipc->head = 0;
	ipc->tail = 0;
	ipc->empty_sem = empty;
	ipc->full_sem = full;
	ipc->mutex_sem = mutex;

	printf("[sem] create empty=%d full=0 mutex=1\n", IPC_SLOTS);

	pid_p = fork();
	if (pid_p == 0)
		producer_loop();

	pid_c = fork();
	if (pid_c == 0)
		consumer_loop();

	printf("producer pid=%d start\n", pid_p);
	printf("consumer pid=%d start\n", pid_c);
	printf("Type text and press Enter (q to quit):\n");

	waitpid(pid_p);
	waitpid(pid_c);
	return 0;
}
