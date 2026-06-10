# myos — System Architecture

**Target:** RISC-V64 (`rv64gc`), QEMU `virt`, OpenSBI firmware (M→S handoff), supervisor-mode kernel.  
**User isolation:** Sv39 per-process page tables; user VA window `0x80400000`–`0x80480000`.  
**Console:** MMIO NS16550 @ `0x10000000` (poll-only on the shell path).

This document describes overall structure, boot flow, observability, and core execution paths.

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
  • proc_init() / proc_user_init()
  • pmm_init()                    physical page allocator
  • vm_init()                     Sv39 kernel page table
  • plic_init()
  • uart_irq_enable()             RX IRQ off; poll for shell
  • timer_init()                  ~100 Hz via SBI set_timer
  • sched_init()                  soft-IRQ hook for demo tasks
  • os_main()                     (placeholder)
  • cpu_irq_enable()
  • console_run()  OR  debug_autorun_user_and_exit()
```

**Build flags**

| Flag | Effect |
|------|--------|
| `make` (default) | `-DDEBUG=1 -DCONFIG_LOG=1` — kernel `LOG_*` macros emit JSON |
| `make DEBUG=0` | All `LOG_*` compile to no-ops; no `LOG {...}` on serial |
| `make AUTORUN=hi` | Skip login; run one user ELF then poweroff |

**Core paths to remember**

| Path | Summary |
|------|---------|
| **Boot** | `start.S` → `start_kernel` → subsystems → `console_run` |
| **Syscall** | User `ecall` → `trap_vector` → `trap_handler` → `do_syscall` → `sret` |
| **User program** | Shell `./prog` → `proc_spawn_exec_wait` → `proc_user_run` → `enter_uspace` → user → `SYS_exit` → `after_uspace` → `proc_wait` |
| **File (kernel)** | Shell `cat`/`ls` → `fs_*` on ramfs (no syscall) |
| **File (user)** | `ecall` → `sys_open`/`read`/`write` → `fs_*` + `copy_*_user` |
| **Scheduling** | Timer IRQ → `timer_handler`; preemptive `schedule()` **disabled** on OpenSBI build; demo `spawn worker` uses `task_create` + `switch_to` |
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
                    │  trap_vector, trap_handler          │
                    │  do_syscall, vm_fault_handle        │
                    └──────────────────┬──────────────────┘
         ┌─────────────────────────────┼─────────────────────────────┐
         │              Kernel core (S-mode)                        │
         │  Process (proc, proc_user)  Memory (pmm, vm)             │
         │  Scheduler (sched — demo tasks)  LOG_* / trap_diag       │
         └─────────────────────────────┬─────────────────────────────┘
                                       │
         ┌─────────────────────────────┼─────────────────────────────┐
         │  VFS-like layer: ramfs (fs.c) — paths under /home/root    │
         └─────────────────────────────┬─────────────────────────────┘
                                       │
         ┌─────────────────────────────▼─────────────────────────────┐
         │  Drivers & platform                                         │
         │  UART (boot/uart.c)  PLIC (interrupt/plic.c)                │
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
| **Trap / IRQ** | `interrupt/entry.S`, `interrupt/trap.c`, `interrupt/timer.c`, `interrupt/plic.c`, `interrupt/trap_diag.c` | `trap_vector`, exceptions, timer, optional trap UART diag |
| **Memory** | `mem/pmm.c`, `mem/default_pmm.c`, `mem/vm.c` | Physical pages (`alloc_pages`), Sv39 walk/map/activate, demand faults |
| **Process** | `proc/proc.c`, `proc/proc_user.c`, `proc/syscall.c`, `proc/copy_user.c`, `proc/sched.c` | PCB, ELF exec, fork/wait, syscalls, uaccess |
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
│   Extra stack pages: demand-mapped on store fault            │
└──────────────────────────────────────────────────────────────┘
```

- **Shell** runs in the kernel (logical PID `PROC_SHELL_PID` = 1); it does not have a user page table until it spawns a child.
- **Child processes** get `vm_create()` on `proc_load_elf`, `vm_activate()` in `proc_user_run`, restored to `vm_kernel_pt()` at `after_uspace`.
- **Return to user after nested kernel work** (e.g. `waitpid` running child): `trap_handler` calls `proc_activate_user` when `trap_return_to_user` is set so the parent page table is active before `sret`.

---

## 5. Trap / `sscratch` model (RISC-V, OpenSBI)

```text
In U-mode:  sscratch = top of current process kernel stack
            (proc kstack; user_ctx lives below top)

In S-mode kernel trap handling:  sscratch = 0
            (set in trap_handler via trap_scratch_init)

User trap entry (sscratch != 0):
  swap sp ↔ sscratch → save frame on kernel stack → trap_handler

Return to user:
  reg_restore → set sscratch = kstack_top → optional SIE → sret

Return to kernel after SYS_exit:
  set SPP → sret to after_uspace (continuation in proc_user_run)
```

---

## 6. Data flow: interactive session (QEMU serial)

```text
Host keyboard
  → QEMU -serial stdio
  → NS16550 MMIO RX
  → uart_getc / uart_read_line
  → console.c (login_session → shell_loop)
        │
        ├─ Built-in command → fs_* / proc_* / vm_info_* (kernel)
        │
        └─ ./hi  → proc_spawn_exec_wait
                    → proc_load_elf (fs_read_file + vm_map)
                    → proc_user_run → enter_uspace
                    → user writes via SYS_write → uart_putc
                    → SYS_exit → proc_wait → prompt
```

---

## 7. Data flow: Web UI session

```text
Browser (desktop.html)
  ├─ WebSocket /ws/ssh  ←→  code/web/server.py (PTY)
  │                              │
  │                              └─ bash -lc start_qemu.sh (DEBUG=n)
  │                                     └─ exec qemu-system-riscv64 …
  │
  ├─ type=output   → terminal pane (shell text only)
  ├─ type=event    → log bubbles (parsed LOG JSON)
  └─ type=snapshot → LOG_SNAPSHOT stats card

Single QEMU serial byte stream; server.py SerialDemux splits by line:
  LOG {...}        → event
  LOG_SNAPSHOT …   → snapshot
  everything else  → output
```

See [05_web_frontend.md](05_web_frontend.md) and [04_logging_and_osviz.md](04_logging_and_osviz.md).

---

## 8. Observability (summary)

```text
Kernel (DEBUG=1):
  LOG_BOOT / LOG_TRAP / LOG_PROC / …  [include/osviz_k.h]
        → osviz_event()               [boot/osviz_k.c]
        → printf("LOG {...}\n")       → UART

Host (optional, non-Web):
  serial_reader.py  →  code/osviz/events/events.jsonl

Web (current):
  server.py demux   →  WebSocket typed messages (no file write yet)
```

---

## 9. Related documents

| Document | Contents |
|----------|----------|
| [02_call_chains.md](02_call_chains.md) | Step-by-step call trees |
| [03_module_index.md](03_module_index.md) | Per-module entry / core / exit |
| [04_logging_and_osviz.md](04_logging_and_osviz.md) | LOG macros, formats, host tools |
| [05_web_frontend.md](05_web_frontend.md) | Web stack, terminal gate, demux |
| [PROBLEMS_AND_SOLUTIONS.md](PROBLEMS_AND_SOLUTIONS.md) | Historical defects and fixes |

---

*Paths and symbols refer to `code/myos/` as of Sv39 + `proc_spawn_exec_wait` + Web serial demux.*
