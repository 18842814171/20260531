# myos — Module Entry Index

For each major component: **entry points** (how execution reaches the module), **core functions** (main logic), and **exit / return paths** (how control leaves). Paths are relative to `code/myos/`.

---

## Boot

**Role:** Firmware handoff, early CPU state, kernel `start_kernel` orchestration.

| Kind | Functions / symbols |
|------|---------------------|
| **Entry** | `_start` (`boot/start.S`) → `start_kernel` (`boot/kernel.c`) |
| **Core** | `osviz_log_boot_progress`, subsystem init calls, `LOG_*` boot milestones |
| **Exit** | Falls through to `console_run` or `debug_autorun_user_and_exit`; does not return to `start.S` |

**Calls:** `uart_init`, `trap_init`, `LOG_INIT`, `fs_init`, `proc_init`, `proc_user_init`, `pmm_init`, `vm_init`, `plic_init`, `timer_init`, `sched_init`, `os_main`, `console_run`.

---

## Trap and exceptions

**Role:** Single trap vector, save/restore `struct context`, delegate to C handler.

| Kind | Functions / symbols |
|------|---------------------|
| **Entry** | Any trap → `trap_vector` (`interrupt/entry.S`) |
| **Core** | `reg_save` / `reg_restore`; `trap_handler` (`interrupt/trap.c`); `handle_sync_exception`; `trap_check_return_pc` |
| **Exit** | `sret` with `sepc` = return PC; user return sets `sscratch`, `proc_activate_user` when needed |

**Related:** `trap_init`, `trap_scratch_init`, `trap_diag_*` (`interrupt/trap_diag.c`, gated by `TRAP_DIAG_VERBOSE`).

---

## Timer

**Role:** Periodic SBI timer, software timer list, callback dispatch.

| Kind | Functions / symbols |
|------|---------------------|
| **Entry** | `timer_handler` from `trap_handler` (IRQ timer) or `trap_nested_timer_ack` |
| **Core** | `timer_init`, `timer_load`, `timer_check`, `timer_add` / `timer_delete` (`interrupt/timer.c`) |
| **Exit** | Returns to `trap_handler`; rearms via `timer_load` |

---

## PLIC / external IRQ

**Role:** Platform interrupt controller; UART IRQ wired but shell uses polling.

| Kind | Functions / symbols |
|------|---------------------|
| **Entry** | `external_interrupt_handler` ← `trap_handler` (external IRQ) |
| **Core** | `plic_init`, `plic_claim`, `plic_complete` (`interrupt/plic.c`); `uart_rx_flush` on UART IRQ |
| **Exit** | Return to trap epilogue |

---

## UART driver

**Role:** NS16550 MMIO console; line editing for shell.

| Kind | Functions / symbols |
|------|---------------------|
| **Entry** | `uart_init` at boot; `uart_getc` / `uart_read_line` from `console.c`; `uart_putc` from `sys_write` and shell |
| **Core** | `uart_read_reg` / `uart_write_reg`, `uart_read_buf`, `uart_rx_flush`, `uart_irq_enable` (`boot/uart.c`) |
| **Exit** | Blocking `uart_getc` returns byte; `uart_read_line` returns length |

**Note:** `LOG_*` output and shell text share the same UART TX path.

---

## Physical memory (PMM)

**Role:** Page allocator backing kernel structures and user page tables.

| Kind | Functions / symbols |
|------|---------------------|
| **Entry** | `pmm_init` from `start_kernel` |
| **Core** | `pmm_manager` (`default_pmm_manager` or `best_fit_pmm_manager`); `alloc_pages`, `free_pages`, `alloc_page` (`mem/pmm.c`, `mem/default_pmm.c`) |
| **Exit** | N/A (library-style) |

**Observability:** `LOG_PMM("init"|"alloc"|"free", …)` when `DEBUG=1`.

---

## Virtual memory (Sv39)

**Role:** Per-process page tables, kernel map duplication, demand faults.

| Kind | Functions / symbols |
|------|---------------------|
| **Entry** | `vm_init` at boot; `vm_activate` on user run/exit; faults → `vm_fault_handle` |
| **Core** | `vm_create`, `vm_destroy`, `vm_map_user_page`, `vm_map_user_zero`, `vm_fork_copy`, `vm_pte_at` (`mem/vm.c`); `vm_info_file`, `vm_info_proc` |
| **Exit** | `vm_activate(vm_kernel_pt())` at `after_uspace` |

---

## Process management (PCB)

**Role:** PID table, states, zombie, kernel worker spawn.

| Kind | Functions / symbols |
|------|---------------------|
| **Entry** | `proc_init`, `proc_alloc`, `proc_spawn`, `proc_list` (`proc/proc.c`) |
| **Core** | `proc_set_state`, `proc_mark_zombie`, `proc_pagetable`, `proc_user_ctx`, `proc_kstack_top` |
| **Exit** | `proc_set_state(UNUSED)` on reap |

**Shell identity:** `PROC_SHELL_PID` (1) reserved in `proc_user_init`.

---

## User processes and ELF

**Role:** Load ELF into user PT, run in U-mode, fork/wait, spawn from shell.

| Kind | Functions / symbols |
|------|---------------------|
| **Entry** | `proc_spawn_exec_wait`, `proc_user_run`, `SYS_execve` / `SYS_fork` paths |
| **Core** | `proc_load_elf`, `proc_enter_uspace`, `proc_user_exit`, `proc_wait`, `proc_fork`, `proc_prepare_kernel_return`, `proc_save_run_cont` (`proc/proc_user.c`) |
| **Exit** | `after_uspace` → `return 0`; `proc_wait` returns exit status |

**Assembly partner:** `enter_uspace` (`interrupt/entry.S`).

---

## System calls

**Role:** Dispatch `ecall` by number in `a7`; copy user buffers.

| Kind | Functions / symbols |
|------|---------------------|
| **Entry** | `do_syscall` from `handle_sync_exception` (`interrupt/trap.c`) |
| **Core** | `sys_open`, `sys_read`, `sys_write`, `sys_close`, `sys_fork`, `sys_waitpid`, `sys_gethid` (`proc/syscall.c`) |
| **Exit** | Result in `cxt->a0` (except `SYS_exit` and `SYS_fork` parent semantics) |

**Helpers:** `copy_from_user`, `copy_to_user`, `copyinstr` (`proc/copy_user.c`).

---

## Scheduler (kernel demo tasks)

**Role:** Small round-robin demo using `ctx_tasks`; not the shell/user scheduler.

| Kind | Functions / symbols |
|------|---------------------|
| **Entry** | `sched_init` at boot; `task_yield` → soft IRQ; `schedule` (if enabled) |
| **Core** | `task_create`, `schedule`, `switch_to` target (`proc/sched.c`) |
| **Exit** | `task_exit_to_idle`; `switch_to` does not return until next schedule |

---

## Filesystem (ramfs)

**Role:** In-memory tree seeded at boot; no block device.

| Kind | Functions / symbols |
|------|---------------------|
| **Entry** | `fs_init` → `fs_load_home`; shell `cmd_*`; `fs_read_file` from `proc_load_elf` |
| **Core** | `fs_open`, `fs_read`, `fs_write`, `fs_close`, `fs_listdir`, `fs_chdir`, `fs_seed_file` (`fs/fs.c`) |
| **Exit** | FD-based calls return count or error |

**Backend:** Embedded `home_data.c` / `home_embed.S` (`tools/pack_home.py`).

---

## Console / shell

**Role:** Login, command parser, built-ins, `./prog` launcher.

| Kind | Functions / symbols |
|------|---------------------|
| **Entry** | `console_run` (`usr/console.c`) from `start_kernel` |
| **Core** | `login_session`, `shell_loop`, `cmd_*`, `proc_spawn_exec_wait` for `./prog` |
| **Exit** | `logout` → `login_session`; `poweroff` → `machine_poweroff` |

**Welcome string:** `\nWelcome, root.\n` — used by Web UI to open the terminal gate.

---

## User-mode libc stub (programs)

**Role:** `_start`, syscall wrappers in each `home/root/*.c`.

| Kind | Functions / symbols |
|------|---------------------|
| **Entry** | ELF `e_entry` → `_start` (`usr/crt0.S`) |
| **Core** | Set `sp`, call `main`, `ecall` with `a7 = SYS_exit` |
| **Exit** | Only via `SYS_exit` |

**Link:** `ld/user.ld` → `USER_MEM_BASE` / `USER_STACK_TOP` in `include/proc_user.h`.

---

## Observability (osviz)

**Role:** JSON `LOG` lines on UART; compile-time macro gate (my_sim style).

| Kind | Functions / symbols |
|------|---------------------|
| **Entry** | `LOG_INIT`, `LOG_BOOT_BANNER`, `LOG_*` at call sites; `trap_diag_*` when `TRAP_DIAG_VERBOSE` |
| **Core** | `osviz_event`, `osviz_snapshot` (`boot/osviz_k.c`); macros in `include/osviz_k.h` |
| **Build** | `make` → `DEBUG=1`; `make DEBUG=0` → all `LOG_*` no-ops |

**Prefixes:** `LOG ` (event), `LOG_SNAPSHOT ` (aggregate stats).

**Modules:** `boot`, `trap`, `trap-diag`, `proc`, `pmm`, `irq`.

---

## Web backend (`code/web/`)

**Role:** Browser access to QEMU serial; split LOG from shell text.

| Kind | Functions / symbols |
|------|---------------------|
| **Entry** | `ws_ssh` (`server.py`); PTY runs `start_qemu.sh` with `DEBUG=n` |
| **Core** | `SerialDemux` line parser; JSON message types `output` / `event` / `snapshot` |
| **Exit** | WebSocket close → terminate QEMU subprocess |

---

## Host osviz package (`code/osviz/`)

**Role:** Optional capture and Linux userspace logging (not used by Web demux today).

| Kind | Functions / symbols |
|------|---------------------|
| **Entry** | `serial_reader.py` on piped QEMU stdout; `osviz-record` CLI |
| **Core** | Append JSON to `/var/log/osviz/events.jsonl` (`src/log.c`) |
| **Exit** | N/A |

---

## AUTORUN (development)

**Role:** Non-interactive smoke test of one user program.

| Kind | Functions / symbols |
|------|---------------------|
| **Entry** | `debug_autorun_user_and_exit(CONFIG_AUTORUN)` (`usr/autorun.c`) |
| **Core** | `proc_spawn_exec_wait(prog)` then `machine_poweroff` |
| **Exit** | Does not return |

---

## Cross-module “when does this run?”

| Question | Answer |
|----------|--------|
| When is `vm_activate` called? | Start of `proc_user_run` (child PT); `after_uspace` (kernel PT); `trap_return_to_user` (current user PT) |
| When is `current_pid` set? | `proc_enter_uspace` / `after_uspace` / `proc_user_init` default shell |
| When is `do_syscall` not used for exit? | `SYS_exit` handled in `handle_sync_exception` |
| When does shell touch `fs_*` directly? | Built-in `ls`, `cat`, `cd`, etc. |
| When does user output reach the Web terminal? | `SYS_write` → `uart_putc` → serial → demux `type=output` → `appendTerminalOutput` after Welcome gate |

---

## Related documents

- [01_architecture.md](01_architecture.md) — diagrams and boot order  
- [02_call_chains.md](02_call_chains.md) — indented call trees  
- [04_logging_and_osviz.md](04_logging_and_osviz.md) — LOG format and tools  
- [05_web_frontend.md](05_web_frontend.md) — browser UI  

---

*Index reflects Sv39, PMM, macro-gated osviz, and Web serial demux.*
