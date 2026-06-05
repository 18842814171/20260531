# myos — Key Call Chains

Index of important control-flow paths. Indentation shows call order. File names are under `code/myos/` unless noted.

---

## 1. Cold boot → login shell

```text
_start                          boot/start.S
 └─ start_kernel                boot/kernel.c
     ├─ uart_init               boot/uart.c
     ├─ trap_init                interrupt/trap.c
     │   └─ w_stvec(trap_vector)
     ├─ fs_init                  fs/fs.c
     │   └─ fs_load_home         (embedded nodes from home_data.c)
     ├─ proc_init                proc/proc.c
     ├─ proc_user_init           proc/proc_user.c
     ├─ page_init                mem/page.c
     ├─ vm_init                  mem/vm.c
     ├─ plic_init                interrupt/plic.c
     ├─ uart_irq_enable          boot/uart.c
     ├─ timer_init               interrupt/timer.c
     ├─ sched_init               proc/sched.c
     ├─ os_main                  usr/user.c
     ├─ cpu_irq_enable
     └─ console_run              usr/console.c
         └─ login_session
             └─ uart_read_line → uart_getc
         └─ shell_loop
             └─ uart_prompt_and_read_line
```

---

## 2. Trap dispatch (all exceptions and interrupts)

```text
(hardware) supervisor trap
 └─ trap_vector                  interrupt/entry.S
     ├─ [optional] trap_diag_trap_pre
     ├─ [busy] trap_nested_timer_ack → timer_handler → TRAP_RET
     ├─ reg_save (kernel_trap_cxt or per-proc user_ctx)
     ├─ trap_handler               interrupt/trap.c
     │   ├─ reload kernel gp
     │   ├─ if interrupt:
     │   │   ├─ TRAP_IRQ_TIMER → timer_handler
     │   │   ├─ TRAP_IRQ_SOFT  → (schedule disabled)
     │   │   └─ TRAP_IRQ_EXTERNAL → external_interrupt_handler
     │   │         └─ plic_claim → uart_rx_flush (UART IRQ not used for stdin)
     │   └─ if sync exception:
     │       └─ handle_sync_exception
     ├─ csrw sepc, return_pc (a0 from trap_handler)
     ├─ reg_restore
     ├─ trap_reenable_irq path (SIE only if returning to user)
     ├─ trap_return_to_user: csrw sscratch, kstack_top
     └─ sret
```

---

## 3. User environment call (generic syscall)

```text
user: ecall                     (a7 = syscall number, a0–a2 = args)
 └─ trap_vector                  interrupt/entry.S
     └─ user path: reg_save to proc user_ctx (early save)
 └─ trap_handler
     └─ handle_sync_exception (cause 8 or 9)
         ├─ if a7 == SYS_exit → [see §4]
         └─ else:
             ├─ cxt->ra = epc + 4   (user-mode only)
             ├─ do_syscall           proc/syscall.c
             │   └─ switch(a7): sys_open, sys_read, …
             └─ return_pc = epc + 4
 └─ reg_restore → sret to user (sepc advanced)
```

---

## 4. Syscall: `open` → ramfs

```text
user: SYS_open (1024)
 └─ do_syscall
     └─ sys_open
         ├─ copy_from_user(kpath, path)   proc/copy_user.c
         └─ fs_open(path, flags)          fs/fs.c
             └─ path normalize + node lookup in ramfs table
```

---

## 5. Syscall: `read` / `write`

```text
user: SYS_read (63) / SYS_write (64)
 └─ do_syscall
     └─ sys_read / sys_write
         ├─ fd 0/1/2: uart_read_buf / uart_putc loop + copy_*_user
         └─ else: fs_read / fs_write + copy_*_user
```

---

## 6. Syscall: `exit` → return to shell waiter

```text
user: SYS_exit (93), status in a0
 └─ trap_handler → handle_sync_exception
     ├─ proc_user_exit(pid, status)     proc/proc_user.c
     │   └─ proc_mark_zombie
     ├─ proc_prepare_kernel_return(cxt, pid)
     ├─ return_pc = proc_run_saved_cont(pid)
     │            or proc_run_saved_ra(pid)
     ├─ w_sstatus | SPP                  (return in S-mode)
     └─ sret → after_uspace in proc_user_run
         ├─ vm_activate(vm_kernel_pt())
         ├─ trap_scratch_init(0)
         ├─ current_pid = PROC_SHELL_PID
         └─ return 0
             └─ proc_spawn_exec_wait
                 └─ proc_wait → reap zombie → shell prompt
```

---

## 7. Shell: run user program (`./prog`)

```text
shell_loop                      usr/console.c
 └─ proc_spawn_exec_wait(path)  proc/proc_user.c
     ├─ proc_alloc(name, PROC_SHELL_PID)
     ├─ proc_load_elf(child, path)
     │   ├─ fs_read_file(path, file_buf)
     │   ├─ vm_create + proc_set_pagetable
     │   ├─ foreach PT_LOAD: vm_map_user_page
     │   ├─ vm_map_user_zero (initial stack pages)
     │   └─ uctx: pc = e_entry, sp = USER_STACK_TOP
     ├─ proc_user_run(child)
     │   ├─ proc_save_run_caller / proc_save_run_cont(&&after_uspace)
     │   ├─ vm_activate(child pagetable)
     │   └─ proc_enter_uspace → enter_uspace      interrupt/entry.S
     │       ├─ csrw sscratch, kstack_top
     │       ├─ reg_restore(user_ctx)
     │       ├─ csrc SPP; set SPIE; clear SIE
     │       └─ sret → user _start (usr/crt0.S)
     │             └─ main → … → ecall SYS_exit
     ├─ after_uspace: (see §6 tail)
     └─ proc_wait(PROC_SHELL_PID, child)
```

---

## 8. Syscall: `execve` (in-process reload)

```text
user: SYS_execve (221)
 └─ do_syscall
     ├─ copy_from_user(kpath)
     ├─ proc_load_elf(current_pid, kpath)
     └─ proc_user_run(current_pid)    (does not return until program exits)
```

Used when a user process replaces its own image; shell path prefers `proc_spawn_exec_wait` instead.

---

## 9. Syscall: `fork` / `waitpid`

```text
user: SYS_fork (214)
 └─ sys_fork
     ├─ proc_fork(parent)
     │   ├─ proc_alloc child
     │   ├─ uctx_copy(child, parent); child a0 = 0
     │   └─ addrspace_clone → vm_fork_copy
     └─ parent cxt->a0 = child_pid

user: SYS_waitpid (260)
 └─ sys_waitpid → proc_wait
     ├─ [fork path] may proc_user_run(child) first
     └─ loop: proc_list until child PROC_ZOMBIE → PROC_UNUSED
```

---

## 10. Page fault (demand stack)

```text
user load/store to unmapped user page
 └─ trap_handler → handle_sync_exception (cause 12/13/15)
     └─ vm_fault_handle(pid, stval, cause)   mem/vm.c
         └─ vm_map_user_zero (anonymous stack/heap growth)
     └─ return_pc = epc (retry instruction)
 └─ sret
```

Instruction page fault at unmapped VA → unhandled → panic.

---

## 11. Timer interrupt (background)

```text
SBI timer fires
 └─ trap_vector → trap_handler (interrupt, cause timer)
     └─ timer_handler              interrupt/timer.c
         └─ timer_check            (callbacks; validate .text)
         └─ timer_load(next)       SBI set_timer
```

**Note:** `schedule()` from soft/timer preempt path is intentionally not used during active user programs on this OpenSBI configuration.

---

## 12. Kernel demo worker (`spawn worker`)

```text
shell: "spawn worker"
 └─ proc_spawn_worker_demo       proc/proc.c
     └─ proc_spawn("worker", worker_demo)
         ├─ proc_alloc
         ├─ task_create(worker_demo)   proc/sched.c
         └─ switch_to(ctx_tasks[i])    interrupt/entry.S
             └─ worker runs on scheduler stack (kernel thread, not ELF user)
```

Distinct from `./hi` — no `proc_load_elf` / `enter_uspace`.

---

## 13. Built-in shell file read (no syscall)

```text
shell: cat hello.txt
 └─ cmd_cat                      usr/console.c
     └─ fs_read_file(path, buf)  fs/fs.c
         └─ ramfs node data pointer
     └─ uart_puts(buf)
```

---

## 14. `yebiao` (inspect mappings / ramfs)

```text
shell: yebiao [arg]
 └─ cmd_yebiao                   usr/console.c
     ├─ path → vm_info_file      mem/vm.c
     └─ P<n> / P0 / P1 → vm_info_proc
```

---

## 15. Power off

```text
shell: poweroff
 └─ machine_poweroff           boot/power.c
     └─ SBI shutdown
```

---

## Quick reference: syscall numbers

| Number | Name | Handler |
|--------|------|---------|
| 63 | SYS_read | `sys_read` |
| 64 | SYS_write | `sys_write` |
| 93 | SYS_exit | zombie + kernel return (not `do_syscall` retval) |
| 172 | SYS_getpid | `proc_current_pid` |
| 214 | SYS_fork | `sys_fork` |
| 221 | SYS_execve | `proc_load_elf` + `proc_user_run` |
| 260 | SYS_waitpid | `proc_wait` |
| 1024 | SYS_open | `sys_open` → `fs_open` |
| 1025 | SYS_close | `sys_close` |

Definitions: `include/syscall.h`.

---

*For module entry points and “who calls whom” at a glance, see [03_module_index.md](03_module_index.md).*
