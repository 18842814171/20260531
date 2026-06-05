# myos — Module Entry Index

For each major component: **entry points** (how execution reaches the module), **core functions** (main logic), and **exit / return paths** (how control leaves). Paths are relative to `code/myos/`.

---

## Boot

**Role:** Firmware handoff, early CPU state, kernel `start_kernel` orchestration.

| Kind | Functions / symbols |
|------|---------------------|
| **Entry** | `_start` (`boot/start.S`) → `start_kernel` (`boot/kernel.c`) |
| **Core** | `clear_bss` (inline in `start_kernel` or `start.S`), `osviz_log_boot_progress`, subsystem init calls |
| **Exit** | Falls through to `console_run` or `debug_autorun_user_and_exit`; does not return to `start.S` |

**Called by:** QEMU / OpenSBI only at reset.

**Calls:** `uart_init`, `trap_init`, `fs_init`, `proc_init`, `proc_user_init`, `page_init`, `vm_init`, `plic_init`, `timer_init`, `sched_init`, `os_main`, `console_run`.

---

## Trap and exceptions

**Role:** Single trap vector, save/restore `struct context`, delegate to C handler.

| Kind | Functions / symbols |
|------|---------------------|
| **Entry** | Any trap → `trap_vector` (`interrupt/entry.S`) |
| **Core** | `reg_save` / `reg_restore` macros; `trap_handler` (`interrupt/trap.c`); `handle_sync_exception`; `trap_check_return_pc` |
| **Exit** | `sret` with `sepc` = return PC from `trap_handler`; user return sets `sscratch` and optional `SIE` |

**Fast paths:** `trap_nested_timer_ack` when `kernel_trap_busy`; `enter_uspace` for first entry to user; `switch_to` for kernel cooperative tasks.

**Related:** `trap_init`, `trap_scratch_init`, `trap_diag_*` (`interrupt/trap_diag.c`).

---

## Timer

**Role:** Periodic SBI timer, software timer list, callback dispatch.

| Kind | Functions / symbols |
|------|---------------------|
| **Entry** | `timer_handler` from `trap_handler` (IRQ timer) or `trap_nested_timer_ack` |
| **Core** | `timer_init`, `timer_load`, `timer_check`, `timer_add` / `timer_delete` (`interrupt/timer.c`) |
| **Exit** | Returns to `trap_handler`; rearms via `timer_load` |

**Note:** `timer_guard[]` pads BSS between `timer_list` and `kernel_trap_cxt`.

---

## PLIC / external IRQ

**Role:** Platform interrupt controller; UART IRQ wired but shell uses polling.

| Kind | Functions / symbols |
|------|---------------------|
| **Entry** | `external_interrupt_handler` ← `trap_handler` (external IRQ) |
| **Core** | `plic_init`, `plic_claim`, `plic_complete` (`interrupt/plic.c`); `uart_rx_flush` on UART IRQ |
| **Exit** | Return to trap epilogue |

**Entry (optional):** `plic_uart_enable` — not used for Phase-1 console.

---

## UART driver

**Role:** NS16550 MMIO console; line editing for shell.

| Kind | Functions / symbols |
|------|---------------------|
| **Entry** | `uart_init` at boot; `uart_getc` / `uart_read_line` from `console.c`; `uart_putc` from `sys_write` and shell |
| **Core** | `uart_read_reg` / `uart_write_reg`, `uart_read_buf`, `uart_rx_flush`, `uart_irq_enable` (`boot/uart.c`) |
| **Exit** | Blocking `uart_getc` returns byte; `uart_read_line` returns length |

**ISR:** `uart_isr` exists for IRQ mode; `uart_rx_use_irq == 0` on shell path.

---

## Physical memory

**Role:** Page allocator for kernel and user page tables.

| Kind | Functions / symbols |
|------|---------------------|
| **Entry** | `page_init` from `start_kernel` |
| **Core** | `alloc_page`, `free_page` (`mem/page.c`) |
| **Exit** | N/A (library-style) |

---

## Virtual memory (Sv39)

**Role:** Per-process page tables, kernel map duplication, demand faults.

| Kind | Functions / symbols |
|------|---------------------|
| **Entry** | `vm_init` at boot; `vm_activate` on user run/exit; faults → `vm_fault_handle` |
| **Core** | `vm_create`, `vm_destroy`, `vm_map_user_page`, `vm_map_user_zero`, `vm_map_2m`, `vm_fork_copy`, `vm_pte_at` (`mem/vm.c`); `vm_info_file`, `vm_info_proc` |
| **Exit** | `vm_activate(vm_kernel_pt())` at `after_uspace` |

**Consumers:** `proc_load_elf`, `proc_user_run`, `trap.c` page-fault cases, `cmd_yebiao`.

---

## Process management (PCB)

**Role:** PID table, states, zombie, kernel worker spawn.

| Kind | Functions / symbols |
|------|---------------------|
| **Entry** | `proc_init`, `proc_alloc`, `proc_spawn`, `proc_list` (`proc/proc.c`) |
| **Core** | `proc_set_state`, `proc_mark_zombie`, `proc_slot_by_pid`, `proc_pagetable`, `proc_user_ctx`, `proc_kstack_top` |
| **Exit** | `proc_set_state(UNUSED)` on reap; `proc_spawn` returns pid |

**Shell identity:** `PROC_SHELL_PID` (1) reserved in `proc_user_init`.

---

## User processes and ELF

**Role:** Load ELF into user PT, run in U-mode, fork/wait, spawn from shell.

| Kind | Functions / symbols |
|------|---------------------|
| **Entry** | `proc_spawn_exec_wait`, `proc_user_run`, `SYS_execve` / `SYS_fork` paths |
| **Core** | `proc_load_elf`, `proc_enter_uspace`, `proc_user_exit`, `proc_wait`, `proc_fork`, `proc_prepare_kernel_return`, `proc_save_run_cont` (`proc/proc_user.c`) |
| **Exit** | `after_uspace` label → `return 0`; `proc_wait` returns exit status; `SYS_exit` → zombie |

**Assembly partner:** `enter_uspace` (`interrupt/entry.S`).

---

## System calls

**Role:** Dispatch `ecall` by number in `a7`; copy user buffers.

| Kind | Functions / symbols |
|------|---------------------|
| **Entry** | `do_syscall` from `handle_sync_exception` (`interrupt/trap.c`) |
| **Core** | `sys_open`, `sys_read`, `sys_write`, `sys_close`, `sys_fork`, `sys_waitpid`, `sys_gethid` (`proc/syscall.c`) |
| **Exit** | Result in `cxt->a0` (except `SYS_exit` and `SYS_fork` parent semantics) |

**Helpers:** `copy_from_user`, `copy_to_user` (`proc/copy_user.c`).

---

## Scheduler (kernel demo tasks)

**Role:** Small round-robin demo using `ctx_tasks`; not the shell/user scheduler.

| Kind | Functions / symbols |
|------|---------------------|
| **Entry** | `sched_init` at boot; `task_yield` → soft IRQ; `schedule` (if enabled) |
| **Core** | `task_create`, `schedule`, `switch_to` target (`proc/sched.c`) |
| **Exit** | `task_exit_to_idle` sets `pc` to `task_idle_loop`; `switch_to` does not return until next schedule |

**Shell hook:** `proc_spawn_worker_demo` → `proc_spawn` → `task_create(worker_demo)`.

---

## Filesystem (ramfs)

**Role:** In-memory tree seeded at boot; no block device.

| Kind | Functions / symbols |
|------|---------------------|
| **Entry** | `fs_init` → `fs_load_home`; shell `cmd_*`; `fs_read_file` from `proc_load_elf` |
| **Core** | `fs_open`, `fs_read`, `fs_write`, `fs_close`, `fs_mkdir`, `fs_create`, `fs_listdir`, `fs_chdir`, `fs_seed_file` (`fs/fs.c`) |
| **Exit** | FD-based calls return count or error; path ops return 0 / -1 |

**Backend:** Single table `nodes[]`; file payload pointers from embedded `home_data.c` / `pack_home.py`.

---

## Console / shell

**Role:** Login, command parser, built-ins, `./prog` launcher.

| Kind | Functions / symbols |
|------|---------------------|
| **Entry** | `console_run` (`usr/console.c`) from `start_kernel` |
| **Core** | `login_session`, `shell_loop`, `cmd_pwd`, `cmd_ls`, `cmd_cat`, `cmd_cd`, `cmd_echo`, `cmd_ps`, `cmd_yebiao` |
| **Exit** | `logout` → `login_session`; `poweroff` → `machine_poweroff` (no return) |

**User program launch:** `proc_spawn_exec_wait` for lines starting with `./` or bare ELF path.

---

## User-mode libc stub (programs)

**Role:** `_start`, syscall wrappers in each `home/root/*.c`.

| Kind | Functions / symbols |
|------|---------------------|
| **Entry** | ELF `e_entry` → `_start` (`usr/crt0.S`) |
| **Core** | Set `sp`, call `main`, `ecall` with `a7 = SYS_exit` |
| **Exit** | Only via `SYS_exit` (return from `main` falls into crt0 exit) |

**Link:** `ld/user.ld` → `USER_MEM_BASE` / `USER_STACK_TOP` in `include/proc_user.h`.

---

## Observability (osviz / trap diag)

**Role:** JSON LOG lines; optional UART trap breadcrumbs.

| Kind | Functions / symbols |
|------|---------------------|
| **Entry** | `osviz_init`, `osviz_event` (`boot/osviz_k.c`); `trap_diag_*` from `trap_vector` / `trap_handler` |
| **Core** | Module tags: `boot`, `trap`, `proc`, `irq`; `CONFIG_LOG` / `TRAP_DIAG_VERBOSE` gates |
| **Exit** | N/A |

**User:** `SYS_osviz_event`, `SYS_osviz_snap`; shell `snapshot`.

---

## AUTORUN (development)

**Role:** Non-interactive smoke test of one user program.

| Kind | Functions / symbols |
|------|---------------------|
| **Entry** | `debug_autorun_user_and_exit(CONFIG_AUTORUN)` (`usr/autorun.c`) from `start_kernel` when `CONFIG_AUTORUN` set |
| **Core** | `proc_spawn_exec_wait(prog)` then poweroff |
| **Exit** | `machine_poweroff` after print status |

---

## Cross-module “when does this run?”

| Question | Answer |
|----------|--------|
| When is `vm_activate` called? | Start of `proc_user_run` (child PT); end at `after_uspace` (kernel PT) |
| When is `current_pid` set? | `proc_enter_uspace` / `after_uspace` / `proc_user_init` default shell |
| When is `do_syscall` not used for exit? | `SYS_exit` handled entirely in `handle_sync_exception` |
| When does shell touch `fs_*` directly? | Built-in `ls`, `cat`, `cd`, etc. (supervisor, no `ecall`) |
| When does shell touch `proc_*` for programs? | `./prog` → `proc_spawn_exec_wait` only |

---

## Related documents

- [01_architecture.md](01_architecture.md) — diagrams and boot order  
- [02_call_chains.md](02_call_chains.md) — indented call trees  

---

*Index reflects the post–`proc_spawn_exec_wait` design with Sv39 and poll-only UART shell I/O.*
