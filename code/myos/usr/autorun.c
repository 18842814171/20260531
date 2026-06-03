/*
 * Non-interactive boot path for GDB / automated testing.
 * Enable: make AUTORUN=return0   (or hi, spin, file_rw, …)
 * Skips login/shell; runs one user ELF then poweroff.
 */
#include "os.h"
#include "fs.h"

void debug_autorun_user_and_exit(const char *prog)
{
	int st;

	if (!prog || !prog[0]) {
		uart_puts("autorun: empty program name\n");
		machine_poweroff();
	}

	uart_puts("autorun: ./");
	uart_puts((char *)prog);
	uart_putc('\n');

	fs_chdir("/home/root");
	st = proc_spawn_exec_wait(prog);
	printf("autorun: done status=%d\n", st);
	machine_poweroff();
}
