# myos — Key Call Chains

**Scope:** Important control-flow paths in `code/myos/`. Indentation shows call order.

---

## 1. Cold boot → login shell

```text
_start                          boot/start.S
 └─ start_kernel                boot/kernel.c
     ├─ uart_init               boot/uart.c
     ├─ trap_init               interrupt/trap.c
     ├─ fs_init                 fs/fs.c
     ├─ proc_init / proc_user_init / sem_init
     ├─ pmm_init / vm_init
     ├─ plic_init
     ├─ uart_irq_enable         boot/uart.c  (PLIC + IER RX)
     ├─ timer_init              interrupt/timer.c
     ├─ sched_init              proc/sched.c
     └─ console_run             usr/console.c
         └─ login_session → shell_loop
```

---

## 2. Trap dispatch (exceptions and interrupts)

```text
(hardware) supervisor trap
 └─ trap_vector                  interrupt/entry.S
     ├─ reg_save (kernel_trap_cxt or per-proc user_ctx)
     ├─ trap_handler               interrupt/trap.c
     │   ├─ TRAP_IRQ_TIMER → timer_handler
     │   ├─ TRAP_IRQ_SOFT  → (preemptive schedule disabled)
     │   └─ TRAP_IRQ_EXTERNAL → external_interrupt_handler
     │         ├─ plic_claim
     │         ├─ if irq == UART0_IRQ → uart_irq_handler
     │         └─ plic_complete
     │   └─ sync → handle_sync_exception
     ├─ proc_activate_user(pid)  if trap_return_to_user
     └─ sret
```

---

## 3. User environment call (generic syscall)

```text
user: ecall                     (a7 = syscall number)
 └─ trap_vector → trap_handler
     └─ handle_sync_exception (cause 8 or 9)
         ├─ if a7 == SYS_exit → [see §4]
         ├─ if a7 == SYS_yield → proc_user_yield_trap
         └─ else:
             ├─ do_syscall           proc/syscall.c
             └─ return_pc = epc + 4
 └─ reg_restore → sret
```

---

## 4. Syscall: `exit` → scheduler → waiter

```text
user: SYS_exit (93), status in a0
 └─ proc_user_exit_trap
     ├─ proc_user_exit → proc_mark_zombie → proc_sched_child_exit
     ├─ proc_prepare_kernel_return(cxt, pid)   pc = proc_user_trap_return
     └─ sret → proc_user_trap_return
         ├─ proc_activate_kernel(); trap_scratch_init(0)
         ├─ proc_set_current_pid(run_sched_parent)
         └─ proc_kctx_switch(child→kctx, sched→kctx)
               proc_scheduler_loop continues
               parent unblocks in proc_wait → shell prompt
```

---

## 5. Shell: run user program (`./prog`)

```text
shell_loop                      usr/console.c
 └─ proc_spawn_exec_wait(path)  proc/proc_user.c
     ├─ proc_alloc / proc_load_elf → PROC_READY
     └─ proc_wait(PROC_SHELL_PID, child)
           └─ proc_block(child_wait_chan)   sleep until zombie

(proc_scheduler_loop picks READY child in parallel:)
 proc_sched_dispatch_one(child)
   ├─ proc_kctx_bootstrap_fresh → kctx.ra = proc_user_first_run
   └─ proc_kctx_switch(sched→kctx, child→kctx)
         proc_user_first_run → proc_enter_uspace → enter_uspace → user main
```

---

## 6. Syscall: `read` (stdin, IRQ path)

```text
user: SYS_read (63), fd=0
 └─ sys_read → uart_readc_wait     boot/uart.c
     ├─ uart_try_getc → uart_ring_get
     └─ if empty: proc_block(&uart_read_wq)
           └─ proc_sched → proc_kctx_switch → proc_scheduler_loop
                 └─ proc_pick_next_ready_resume → back to uart_readc_wait
```

---

## 7. Syscall: `fork` / `waitpid`

```text
user: SYS_fork (214)
 └─ sys_fork → proc_fork → vm_fork_copy + child pc += 4

user: SYS_waitpid (260)
 └─ sys_waitpid → proc_wait
     └─ loop: check zombie → proc_block(child_wait_chan)   sleep-only (xv6-style)
           (scheduler runs other READY children via proc_sched_dispatch_one)
```

---

## 8. Block, wakeup, and resume (xv6-style)

```text
proc_block(chan)                proc/proc_sched.c
 ├─ wq_enqueue; PROC_BLOCKED
 └─ while BLOCKED:
     └─ proc_sched()
           ├─ proc_kctx_set_asleep(pid, 1)
           └─ proc_kctx_switch(p→kctx, sched→kctx)
                 proc_scheduler_loop()     [sched_stack, proc/proc_sched.c]
                   ├─ proc_sched_dispatch_one()   fresh READY (not in_uspace, not asleep)
                   ├─ proc_pick_next_ready_resume()
                   │     └─ proc_kctx_switch(sched, p→kctx)   kctx_asleep
                   └─ wfi
           └─ proc_kctx_set_asleep(pid, 0)   /* return in proc_block */

proc_wakeup(chan)
 └─ wq_dequeue → PROC_READY

proc_kctx_switch(old, new)      interrupt/kctx_switch.S
 └─ save ra/sp/s0–s11 to *old; load from *new; ret

UART IRQ path:
 external_interrupt_handler
   └─ uart_irq_handler
         ├─ uart_ring_put
         └─ proc_wakeup(&uart_read_wq)    → shell or user reader resumes via kctx
```

**Shell path:** pid 1 has no pagetable; blocks in `uart_read_line` → same `proc_sched` / `kctx_asleep` resume as user `sem_wait`.

---

## 9. IPC demo (`./ipc_echo`)

```text
main                            home/root/ipc_echo.c
 ├─ ipc_shm_map()                SYS_ipc_shm_map → mem/ipc_shm.c
 ├─ sem_create × 3               proc/sem.c
 ├─ fork → producer_loop
 │     └─ read(0) → ipc_put → sem_wait/post
 ├─ fork → consumer_loop
 │     └─ ipc_get → write(1, echo)
 └─ waitpid × 2
```

---

## 10. Page fault (demand stack)

```text
user load/store to unmapped user page
 └─ trap_handler → vm_fault_handle   mem/vm.c
     └─ vm_map_user_zero → return_pc = epc (retry)
 └─ sret
```

---

## 11. Kernel structured log (osviz)

```text
LOG_SCHED("run", d)             proc/proc_sched.c
 └─ osviz_event → printf("LOG {...}\n") → UART
```

See [04_logging_and_osviz.md](04_logging_and_osviz.md).

---

## 12. Web: serial → browser

```text
QEMU -serial stdio
 └─ PTY (server.py) → SerialDemux → WebSocket
     ├─ LOG {...}     → type=event
     ├─ LOG_SNAPSHOT  → type=snapshot
     └─ else          → type=output
```

See [05_web_frontend.md](05_web_frontend.md).

---

## Quick reference: syscall numbers

| Number | Name | Handler |
|--------|------|---------|
| 63 | SYS_read | `sys_read` |
| 64 | SYS_write | `sys_write` |
| 93 | SYS_exit | `proc_user_exit_trap` (not `do_syscall` retval) |
| 172 | SYS_getpid | `proc_current_pid` |
| 214 | SYS_fork | `sys_fork` |
| 221 | SYS_execve | `proc_load_elf` + re-enter via `enter_uspace` |
| 247 | SYS_yield | `proc_user_yield_trap` → `proc_user_trap_return` |
| 260 | SYS_waitpid | `proc_wait` |
| 1024 | SYS_open | `sys_open` → `fs_open` |
| 1025 | SYS_close | `sys_close` |
| 2001–2004 | SYS_sem_* | `sem_create/wait/post/getval` |
| 2005 | SYS_ipc_shm_map | `ipc_shm_map` |
| 1000 | SYS_osviz_event | `LOG_EVENT` |
| 1001 | SYS_osviz_snap | `LOG_SNAPSHOT` |

Definitions: `include/syscall.h`.

---

## Related documents

| Document | Contents |
|----------|----------|
| [01_architecture.md](01_architecture.md) | Diagrams and boot order |
| [03_module_index.md](03_module_index.md) | Module entry points |
| [04_logging_and_osviz.md](04_logging_and_osviz.md) | LOG macro details |
| [05_web_frontend.md](05_web_frontend.md) | Web demux |
| [PROBLEMS_AND_SOLUTIONS.md](PROBLEMS_AND_SOLUTIONS.md) | Scheduling bugs (§12) |

---

*Last aligned with: xv6-style scheduler (Stages 1–4), `proc_user_first_run` + `proc_user_trap_return`, `proc_kctx_switch` dispatch/resume, TTY + AUTORUN `ipc_echo` verified (2026-06-14).*
