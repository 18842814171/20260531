# myos — Module Entry Index

**Scope:** For each major component — **entry points**, **core functions**, and **exit / return paths**. Paths are under `code/myos/`.

---

## Boot

**Role:** Firmware handoff, early CPU state, kernel `start_kernel` orchestration.

| Kind | Functions / symbols |
|------|---------------------|
| **Entry** | `_start` (`boot/start.S`) → `start_kernel` (`boot/kernel.c`) |
| **Core** | Subsystem init calls, `LOG_*` boot milestones |
| **Exit** | `console_run` or `debug_autorun_user_and_exit`; does not return to `start.S` |

---

## Trap and exceptions

**Role:** Single trap vector, save/restore `struct context`, delegate to C handler.

| Kind | Functions / symbols |
|------|---------------------|
| **Entry** | Any trap → `trap_vector` (`interrupt/entry.S`) |
| **Core** | `trap_handler`, `handle_sync_exception`, `trap_check_return_pc` |
| **Exit** | `sret`; user return sets `sscratch`, `proc_activate_user` when needed |

---

## Timer

**Role:** Periodic SBI timer, software timer list, callback dispatch.

| Kind | Functions / symbols |
|------|---------------------|
| **Entry** | `timer_handler` from `trap_handler` or `trap_nested_timer_ack` |
| **Core** | `timer_init`, `timer_load`, `timer_check` (`interrupt/timer.c`) |
| **Exit** | Returns to `trap_handler`; rearms via `timer_load` |

---

## PLIC / external IRQ

**Role:** Platform interrupt controller; UART RX wired at boot.

| Kind | Functions / symbols |
|------|---------------------|
| **Entry** | `external_interrupt_handler` ← external IRQ |
| **Core** | `plic_init`, `plic_claim`, `plic_complete`; `uart_irq_handler` on UART0_IRQ |
| **Exit** | Return to trap epilogue |

---

## UART driver

**Role:** NS16550 MMIO console; RX IRQ + 128-byte ring; blocking read for user and shell.

| Kind | Functions / symbols |
|------|---------------------|
| **Entry** | `uart_init` at boot; `uart_irq_enable`; `uart_readc_wait` from `sys_read` |
| **Core** | `uart_irq_handler`, `uart_ring_put/get`, `uart_putc`, `uart_read_line` (`boot/uart.c`) |
| **Exit** | `proc_block(&uart_read_wq)` when ring empty; wakeup on IRQ |

**Note:** `LOG_*` and shell text share the same UART TX path.

---

## Physical memory (PMM)

**Role:** Page allocator backing kernel structures and user page tables.

| Kind | Functions / symbols |
|------|---------------------|
| **Entry** | `pmm_init` from `start_kernel` |
| **Core** | `alloc_pages`, `free_pages` (`mem/pmm.c`, `mem/default_pmm.c`) |
| **Exit** | N/A (library-style) |

---

## Virtual memory (Sv39)

**Role:** Per-process page tables, kernel map duplication, demand faults, fork copy.

| Kind | Functions / symbols |
|------|---------------------|
| **Entry** | `vm_init`; `vm_activate`; faults → `vm_fault_handle` |
| **Core** | `vm_create`, `vm_destroy`, `vm_map_user_page`, `vm_fork_copy` (`mem/vm.c`) |
| **Exit** | `vm_activate(vm_kernel_pt())` at `after_uspace` |

---

## Process management (PCB)

**Role:** PID table, states, zombie, kernel worker spawn.

| Kind | Functions / symbols |
|------|---------------------|
| **Entry** | `proc_init`, `proc_alloc`, `proc_spawn` (`proc/proc.c`) |
| **Core** | `proc_set_state`, `proc_mark_zombie`, `proc_pagetable`, `proc_user_ctx` |
| **Exit** | `proc_set_state(UNUSED)` on reap |

---

## User processes and ELF

**Role:** Load ELF, run in U-mode, fork/wait, spawn from shell.

| Kind | Functions / symbols |
|------|---------------------|
| **Entry** | `proc_spawn_exec_wait`, `proc_user_run`, `SYS_execve` / `SYS_fork` |
| **Core** | `proc_load_elf`, `proc_enter_uspace`, `proc_wait`, `proc_fork`, `proc_user_run_dispatch`, `proc_user_run_resume` (`proc/proc_user.c`) |
| **Exit** | `after_uspace` → return to waiter; `proc_wait` returns exit status |

---

## Process scheduler (`proc_sched`)

**Role:** Wait queues, block/wakeup, run READY user processes while others sleep.

| Kind | Functions / symbols |
|------|---------------------|
| **Entry** | `proc_block`, `proc_wakeup` from sem/UART/wait paths |
| **Core** | `proc_sched_run_ready`, `proc_user_run_dispatch` (`proc/proc_sched.c`) |
| **Exit** | Blocked process resumes when `proc_get_state != BLOCKED` |

---

## Semaphores and IPC shared memory

**Role:** Kernel counting semaphores; one shared page mapped into fork children.

| Kind | Functions / symbols |
|------|---------------------|
| **Entry** | `sem_init` at boot; `SYS_sem_*`, `SYS_ipc_shm_map` from user |
| **Core** | `sem_wait/post/create`, `ipc_shm_map` (`proc/sem.c`, `mem/ipc_shm.c`) |
| **Exit** | `sem_wait` returns after `proc_block` cycle; post wakes waiters |

---

## System calls

**Role:** Dispatch `ecall` by number in `a7`; copy user buffers.

| Kind | Functions / symbols |
|------|---------------------|
| **Entry** | `do_syscall` from `handle_sync_exception` |
| **Core** | `sys_*` handlers (`proc/syscall.c`) |
| **Exit** | Result in `cxt->a0` (except `SYS_exit`, yield, fault paths) |

---

## Scheduler (kernel demo tasks)

**Role:** Small round-robin demo using `ctx_tasks`; not the user `proc_sched` path.

| Kind | Functions / symbols |
|------|---------------------|
| **Entry** | `sched_init`; `task_yield` → soft IRQ |
| **Core** | `task_create`, `schedule`, `switch_to` (`proc/sched.c`) |
| **Exit** | `task_exit_to_idle` |

---

## Filesystem (ramfs)

**Role:** In-memory tree seeded at boot; no block device.

| Kind | Functions / symbols |
|------|---------------------|
| **Entry** | `fs_init`; shell `cmd_*`; `fs_read_file` from `proc_load_elf` |
| **Core** | `fs_open`, `fs_read`, `fs_write`, `fs_listdir` (`fs/fs.c`) |
| **Exit** | FD-based calls return count or error |

---

## Console / shell

**Role:** Login, command parser, built-ins, `./prog` launcher.

| Kind | Functions / symbols |
|------|---------------------|
| **Entry** | `console_run` from `start_kernel` |
| **Core** | `login_session`, `shell_loop`, `proc_spawn_exec_wait` |
| **Exit** | `logout` → `login_session`; `poweroff` → `machine_poweroff` |

**Welcome string:** `\nWelcome, root.\n` — used by Web UI terminal gate.

---

## Observability (osviz)

**Role:** JSON `LOG` lines on UART; compile-time macro gate.

| Kind | Functions / symbols |
|------|---------------------|
| **Entry** | `LOG_*` at call sites; `trap_diag_*` when verbose |
| **Core** | `osviz_event`, `osviz_snapshot` (`boot/osviz_k.c`) |
| **Build** | `make` → `DEBUG=1`; `make DEBUG=0` → no-ops |

**Modules:** `boot`, `trap`, `trap-diag`, `proc`, `pmm`, `sched`, `sem`, `irq`.

---

## Web backend (`code/web/`)

**Role:** Browser access to QEMU serial; split LOG from shell text.

| Kind | Functions / symbols |
|------|---------------------|
| **Entry** | `ws_ssh` (`server.py`); PTY runs `start_qemu.sh` with `DEBUG=n` |
| **Core** | `SerialDemux`; WebSocket types `output` / `event` / `snapshot` |
| **Exit** | WebSocket close → terminate QEMU subprocess |

---

## AUTORUN (development)

**Role:** Non-interactive smoke test of one user program.

| Kind | Functions / symbols |
|------|---------------------|
| **Entry** | `debug_autorun_user_and_exit(CONFIG_AUTORUN)` (`usr/autorun.c`) |
| **Core** | `proc_spawn_exec_wait(prog)` then `machine_poweroff` |
| **Exit** | Does not return |

---

## Cross-module reference

| Question | Answer |
|----------|--------|
| When is `vm_activate` called? | Start of `proc_user_run`; `after_uspace` (kernel PT); `trap_return_to_user` |
| When does stdin block? | `uart_readc_wait` → `proc_block(uart_read_wq)` → IRQ wakeup → `proc_user_run_dispatch` |
| When is `do_syscall` skipped for exit? | `SYS_exit` handled in `handle_sync_exception` |
| When does Web show program output? | `SYS_write` → UART → demux `type=output` after Welcome gate |

---

## Related documents

| Document | Contents |
|----------|----------|
| [01_architecture.md](01_architecture.md) | Diagrams and boot order |
| [02_call_chains.md](02_call_chains.md) | Indented call trees |
| [04_logging_and_osviz.md](04_logging_and_osviz.md) | LOG format and tools |
| [05_web_frontend.md](05_web_frontend.md) | Browser UI |
| [PROBLEMS_AND_SOLUTIONS.md](PROBLEMS_AND_SOLUTIONS.md) | Historical fixes |

---

*Last aligned with: Sv39, UART RX IRQ + ring, `proc_sched` block/wakeup + `proc_user_run_dispatch`, sem/IPC shm, Web serial demux.*
