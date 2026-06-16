# myos — System Architecture

**Scope:** RISC-V64 (`rv64gc`), QEMU `virt`, OpenSBI M→S handoff, Sv39 user isolation, NS16550 console with RX IRQ + ring buffer, xv6-style `proc_kctx_switch` scheduling (Stages 1–4 complete).

Paths refer to `code/myos/` unless noted.

---

## 1. Boot and initialization sequence

```text
QEMU loads OpenSBI (M-mode) @ 0x80000000
        │
        ▼
OpenSBI → kernel @ 0x80200000 (S-mode), a0=hartid, a1=dtb
        │
        ▼
boot/start.S
  • park secondary harts
  • disable S-mode IRQs; clear SPP
  • sp = 0x87FF0000
  • gp = __global_pointer$
  • zero BSS; save boot_hartid / boot_dtb
        │
        ▼
start_kernel()                    [boot/kernel.c]
  • uart_init()
  • trap_init()                   stvec = trap_vector
  • LOG_INIT() / LOG_BOOT_BANNER()
  • fs_init()                     ramfs + embedded /home
  • proc_init() / proc_user_init() / sem_init()
  • pmm_init()                    physical page allocator
  • vm_init()                     Sv39 kernel page table
  • plic_init()
  • uart_irq_enable()             PLIC + UART IER RX; ring buffer active
  • timer_init()                  ~100 Hz via SBI set_timer
  • sched_init()                  soft-IRQ hook for demo tasks
  • os_main()                     (placeholder)
  • cpu_irq_enable()
  • console_run()  OR  debug_autorun_user_and_exit()
```

### Build flags

| Flag | Effect |
|------|--------|
| `make` (default) | `-DDEBUG=1 -DCONFIG_LOG=1` — kernel `LOG_*` macros emit JSON |
| `make DEBUG=0` | All `LOG_*` compile to no-ops; no `LOG {...}` on serial |
| `make AUTORUN=ipc_echo` | Skip login; run one user ELF then poweroff |

### Core paths

| Path | Summary |
|------|---------|
| **Boot** | `start.S` → `start_kernel` → subsystems → `console_run` |
| **Syscall** | User `ecall` → `trap_vector` → `trap_handler` → `do_syscall` → `sret` |
| **User program** | Shell `./prog` → `proc_spawn_exec_wait` → `proc_load_elf` (READY) → scheduler `proc_sched_dispatch_one` → `proc_user_first_run` → `enter_uspace` → user → `SYS_exit` → `proc_user_trap_return` → `proc_wait` |
| **Block / wake** | `proc_block` → `proc_sched` → `proc_kctx_switch` to scheduler → IRQ → `proc_wakeup` → `proc_kctx_switch` back (fresh READY uses `proc_sched_dispatch_one` only) |
| **IPC demo** | `./ipc_echo` → fork producer/consumer → sem + shared page `@ USER_IPC_BASE` |
| **Observability** | `LOG_*` → `printf` → UART; optional host capture / Web demux (see §8) |

---

## 2. Layered architecture (logical)

```text
                    ┌─────────────────────────────────────┐
                    │           User space                │
                    │  ELF @ 0x80400000, stack @ top      │
                    │  crt0.S → main → ecall (syscalls)   │
                    └──────────────────┬──────────────────┘
                                       │ ecall / page fault
                    ┌──────────────────▼──────────────────┐
                    │        Trap & syscall layer           │
                    │  trap_vector, trap_handler            │
                    │  do_syscall, vm_fault_handle          │
                    └──────────────────┬──────────────────┘
         ┌─────────────────────────────┼─────────────────────────────┐
         │              Kernel core (S-mode)                        │
         │  Process (proc, proc_user, proc_sched)                   │
         │  Memory (pmm, vm, ipc_shm)  Semaphores (sem)           │
         │  Scheduler (sched — demo tasks)  LOG_* / trap_diag       │
         └─────────────────────────────┬─────────────────────────────┘
                                       │
         ┌─────────────────────────────┼─────────────────────────────┐
         │  VFS-like layer: ramfs (fs.c) — paths under /home/root    │
         └─────────────────────────────┬─────────────────────────────┘
                                       │
         ┌─────────────────────────────▼─────────────────────────────┐
         │  Drivers & platform                                         │
         │  UART (boot/uart.c)  PLIC (interrupt/plic.c)               │
         │  Timer (interrupt/timer.c, SBI)  Power (boot/power.c, SBI)  │
         └─────────────────────────────┬─────────────────────────────┘
                                       │
                              QEMU virt hardware
                         (16550, PLIC, CLINT via SBI)
```

---

## 3. Module map (source tree)

| Module | Primary paths | Responsibility |
|--------|---------------|----------------|
| **Boot** | `boot/start.S`, `boot/kernel.c`, `boot/uart.c`, `boot/power.c`, `boot/osviz_k.c` | Entry, init order, UART, shutdown, structured LOG |
| **Trap / IRQ** | `interrupt/entry.S`, `interrupt/kctx_switch.S`, `interrupt/trap.c`, `interrupt/timer.c`, `interrupt/plic.c`, `interrupt/trap_diag.c` | `trap_vector`, exceptions, timer, external IRQ, xv6-style context switch |
| **Memory** | `mem/pmm.c`, `mem/vm.c`, `mem/ipc_shm.c` | Physical pages, Sv39, shared IPC mapping |
| **Process** | `proc/proc.c`, `proc/proc_user.c`, `proc/proc_sched.c`, `proc/syscall.c` | PCB, ELF exec, fork/wait, block/wakeup, syscalls |
| **Sync / IPC** | `proc/sem.c`, `mem/ipc_shm.c` | Kernel semaphores, shared page for user IPC |
| **Filesystem** | `fs/fs.c`, `fs/home_data.c`, `tools/pack_home.py` | In-memory ramfs, embedded home image |
| **Console** | `usr/console.c`, `usr/autorun.c` | Login, shell commands, `./prog` spawn |
| **User binaries** | `home/root/*.c`, `usr/crt0.S`, `ld/user.ld` | Programs linked for user VA |
| **Web** | `code/web/server.py`, `code/web/js/*.js` | Browser terminal + event bubbles over WebSocket |
| **Host osviz** | `code/osviz/bridge/serial_reader.py`, `code/osviz/src/log.c` | Optional file capture; Linux userspace log API |

---

## 4. Privilege and address spaces

```text
┌──────────────────────────────────────────────────────────────┐
│ Kernel (identity / shared map in each satp)                  │
│   .text/.rodata/.data/BSS ~ 0x80200000                       │
│   kernel_trap_cxt, timer_list, proc tables                   │
│   MMIO: UART 0x10000000, PLIC, etc.                          │
├──────────────────────────────────────────────────────────────┤
│ Per-process user region (Sv39, PTE_U)                        │
│   [USER_MEM_BASE, USER_MEM_END) = [0x80400000, 0x80480000)   │
│   ELF PT_LOAD mapped at p_vaddr                              │
│   Stack: 4 pre-mapped pages below USER_STACK_TOP (0x80470000)│
│   IPC shared page mapped at USER_IPC_BASE (fork-shared)      │
└──────────────────────────────────────────────────────────────┘
```

- **Shell** runs in the kernel (logical PID `PROC_SHELL_PID` = 1); it does not have a user page table until it spawns a child.
- **Child processes** get `vm_create()` on `proc_load_elf`, `vm_activate()` in `proc_user_first_run`, restored to `vm_kernel_pt()` in `proc_user_trap_return`.
- **Return to user after nested kernel work** (e.g. parent syscall after `proc_block`): `trap_handler` calls `proc_activate_user` when `trap_return_to_user` is set so the parent page table is active before `sret`.

---

## 5. UART input (IRQ + ring)

```text
Host keyboard → QEMU -serial stdio → NS16550 RX
        │
        ▼
PLIC UART0_IRQ (10) → trap_vector → external_interrupt_handler
        │
        ▼
uart_irq_handler()          [boot/uart.c]
  • drain RHR → uart_ring_put (128-byte ring)
  • proc_wakeup(&uart_read_wq)
        │
        ▼
Blocked reader (shell login/shell_loop OR sys_read fd=0 → uart_readc_wait → proc_block)
        │
        ▼
proc_sched() → proc_kctx_switch(blocked, scheduler)
        │
        ▼
proc_scheduler_loop() on sched_stack
  • proc_pick_next_ready_resume() → proc_kctx_switch(scheduler, blocked)
  • blocked returns in proc_block → reader continues
```

Shell and user stdin share the same ring and wait queue; the shell runs in **kernel context** (pid 1, no user pagetable) and resumes via **`kctx_asleep`**, not fresh dispatch.

---

## 6. User process scheduling model

### 6.1 Current state (xv6-style, Stages 1–4)

```text
proc_sched_dispatch_one(pid)          scheduler-owned sched_kctx
  └─ proc_kctx_bootstrap_fresh(pid)   kctx.ra = proc_user_first_run
  └─ proc_kctx_switch(sched→kctx, child→kctx)
        proc_user_first_run()
          └─ enter_uspace → user → syscall
                ├─ proc_block(chan)           BLOCKED
                │     └─ proc_sched()
                │           └─ proc_kctx_switch(p→kctx, sched→kctx)
                │                 proc_scheduler_loop [sched_stack]
                │                   ├─ proc_sched_dispatch_one()   fresh READY only
                │                   ├─ proc_pick_next_ready_resume()
                │                   │     └─ proc_kctx_switch(sched, p→kctx)   kctx_asleep
                │                   └─ wfi
                │     └─ return in proc_block → syscall → user
                └─ SYS_exit / yield / fault
                      └─ proc_prepare_kernel_return → proc_user_trap_return
                            └─ proc_kctx_switch(child→kctx, sched→kctx)
```

**xv6 invariant:** READY + active session (`proc_user_in_uspace` or `kctx_asleep`) must **not** get a fresh `proc_sched_dispatch_one` — blockers resume via `proc_kctx_switch` into `proc_sched()`.

| Mechanism | Role |
|-----------|------|
| `struct proc_kcontext` | Per-process `ra/sp/s0–s11` (xv6 `swtch` layout) |
| `proc_kctx_switch` | `interrupt/kctx_switch.S` — save old, load new, `ret` |
| `sched_kctx` + `sched_stack` | Dedicated scheduler context (not any process frame) |
| `proc_user_first_run` | First entry after fresh dispatch; calls `enter_uspace` |
| `proc_user_trap_return` | Exit/yield/fault kernel return; `proc_kctx_switch` back to scheduler |
| `run_saved_ra/sp/s0` | Trapframe stack restore for `proc_prepare_kernel_return` only |
| `proc_user_in_uspace` | Guards fresh dispatch while yield/exit unwinds through trap_ret |
| `kctx_asleep` | Set in `proc_sched()`; resume picker uses it (shell + user blockers) |

### 6.2 Migration stages (xv6 alignment)

| Stage | Status | Description |
|-------|--------|-------------|
| 1 | Done | `proc_kcontext` in each PCB |
| 2 | Done | `proc_block` → `proc_sched` → scheduler stack; `kctx_asleep` resume |
| 3 | Done | Fresh READY via `proc_kctx_switch(sched_kctx, child_kctx)`, not coroutine dispatch |
| 4 | Done | Removed `proc_user_run`, `after_uspace`, `run_saved_cont`, `depth`, longjmp dispatch |

**Removed (2026-06-14):** `proc_user_run`, `proc_user_run_dispatch`, `proc_user_run_unwind_blocked`, `dispatch_longjmp`, `dispatch_ret`, C-label continuations (`&&after_uspace`).

See [log/0613.md](../log/0613.md) for the 2026-06-13 change log; planning notes in [6.14.txt](../6.14.txt).

---

## 7. Trap / `sscratch` model (RISC-V, OpenSBI)

```text
In U-mode:  sscratch = top of current process kernel stack
            (proc kstack; user_ctx lives below top)

In S-mode kernel trap handling:  sscratch = 0
            (set in trap_handler via trap_scratch_init)

User trap entry (sscratch != 0):
  swap sp ↔ sscratch → save frame on kernel stack → trap_handler

Return to user:
  reg_restore → set sscratch = kstack_top → optional SIE → sret

Return to kernel after SYS_exit / yield / fault:
  set SPP → sret to proc_user_trap_return (via trapframe pc)
  → proc_kctx_switch back to scheduler
```

---

## 8. Data flow: interactive session (QEMU serial)

```text
Host keyboard
  → QEMU -serial stdio
  → NS16550 MMIO RX (IRQ → ring)
  → uart_readc_wait / uart_read_line
  → console.c (login_session → shell_loop)
        │
        ├─ Built-in command → fs_* / proc_* / vm_info_* (kernel)
        │
        └─ ./ipc_echo  → proc_spawn_exec_wait
                    → proc_load_elf (fs_read_file + vm_map) → PROC_READY
                    → scheduler picks child → proc_user_first_run → enter_uspace
                    → fork + sem + shm → producer/consumer
                    → SYS_exit → proc_user_trap_return → proc_wait → prompt
```

---

## 9. Data flow: Web UI session

```text
Browser (desktop.html)
  ├─ WebSocket /ws/ssh  ←→  code/web/server.py (PTY)
  │                              │
  │                              └─ bash -lc start_qemu.sh (DEBUG=n)
  │                                     └─ exec qemu-system-riscv64 …
  │
  ├─ type=output   → terminal (channel: console)
  ├─ type=event    → event panel (channel: log)
  └─ type=snapshot → stats card (channel: log)

Single serial stream; SerialDemux splits by LOG line framing and sets channel.
Interleaved bytes (shell + LOG in one read) are split before WebSocket send.
```

See [05_web_frontend.md](05_web_frontend.md) and [04_logging_and_osviz.md](04_logging_and_osviz.md).

---

## 10. Observability (summary)

```text
Kernel (DEBUG=1):
  LOG_* macros → log_write() → UART (LOG prefix lines)

Shell / user text:
  console_write() → UART

Host Web:
  SerialDemux → WebSocket with channel console | log
```

---

## Related documents

| Document | Contents |
|----------|----------|
| [02_call_chains.md](02_call_chains.md) | Step-by-step call trees |
| [03_module_index.md](03_module_index.md) | Per-module entry / core / exit |
| [04_logging_and_osviz.md](04_logging_and_osviz.md) | LOG macros, formats, host tools |
| [05_web_frontend.md](05_web_frontend.md) | Web stack, terminal gate, demux |
| [PROBLEMS_AND_SOLUTIONS.md](PROBLEMS_AND_SOLUTIONS.md) | Historical defects and fixes |
| [log/0613.md](../log/0613.md) | 2026-06-13 Stage 1–2 migration log |
| [log/0614debug.md](../log/0614debug.md) | 2026-06-14 Stage 3–4 收尾与文档同步 |

---

*Last aligned with: console/log write split, Web channel demux, bg script timer poll (2026-06-15).*
