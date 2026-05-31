#include "os.h"

/*
 * One-shot demo for "run task" — runs in M-mode from the console (no scheduler loop).
 */
static void demo_task0_once(void)
{
	uart_puts("  [task0] completed one step\n");
}

static void demo_task1_once(void)
{
	uart_puts("  [task1] completed one step\n");
}

void demo_run_tasks(void)
{
	uart_puts("Running task demo (one line per task, no background spam):\n");
	demo_task0_once();
	demo_task1_once();
	uart_puts("Task demo finished.\n");
}

void os_main(void)
{
	/* Interactive console owns the CPU; see console_run() in kernel.c */
}
