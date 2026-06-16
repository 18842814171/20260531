# myos Development: Problems, Root Causes, and Resolutions

**Scope:** Recurring issues on **RISC-V64** (QEMU `virt`, OpenSBI, S-mode kernel, Sv39, NS16550 + PLIC). Formal technical language; grouped by subsystem.

---

## 1. Platform and Boot

### 1.1 Illegal access to machine-mode resources from supervisor mode

**Problem.** After OpenSBI transfers control to the kernel in supervisor mode, reads of `mhartid` or direct MMIO access to the **CLINT** (machine-local interruptor) cause synchronous exceptions. Timer programming via CLINT registers fails for the same reason.

**Root cause.** On QEMU `virt` with OpenSBI, **PMP** and privilege rules restrict CLINT and some CSRs to machine mode. The kernel runs in S-mode and must not assume M-mode visibility of those resources.

**Resolution.** Store the boot hart ID from the value OpenSBI passes in register `a0` at entry (e.g. in `tp`). Use the `rdtime` instruction for time and **SBI** `set_timer` for the next timer event instead of programming CLINT from S-mode.

---

### 1.2 Split console paths (SBI output vs MMIO input)

**Problem.** Login appears to hang or behave inconsistently: output may be visible while keyboard input never reaches the guest, or login accepts empty lines repeatedly without authenticating.

**Root cause.** Console **transmit** used **SBI** `putchar` while **receive** used **MMIO NS16550**. Under QEMU `-serial stdio`, the host terminal is wired to the emulated 16550, not necessarily to the same channel as SBI semihosting-style console services. Input and output were therefore not on a single coherent path.

**Resolution.** Route both directions through **MMIO NS16550 at physical address `0x10000000`**, matching `platform.h` and QEMU `-serial stdio -monitor none`.

---

## 2. Console, UART, and Host Integration

### 2.1 Infinite loop in character receive when SBI returns zero

**Problem.** The system blocks forever inside the login read path even though the user presses keys on the host.

**Root cause.** A receive path that returned **0** (`NUL`) was treated as a valid character or not filtered; the polling loop in `uart_getc` discarded only some zero cases while other integration paths could spin without progress when no data was available on the MMIO path.

**Resolution.** In the MMIO polling implementation, **ignore received byte value zero** and continue polling until a non-zero byte or a valid line terminator is read.

---

### 2.2 QEMU started in background: stdin not attached to guest

**Problem.** Typed characters (e.g. `root`) appear in the terminal but the guest never reacts; only blank lines or no login progress occur.

**Root cause.** When `qemu-system-riscv64` is started with shell backgrounding (`&`), the **host shell retains stdin**. Characters are echoed by the IDE or terminal locally and are **not forwarded** to QEMU’s `-serial stdio` backend.

**Resolution.** Run QEMU in the **foreground** (e.g. `exec qemu ...` in the start script) so the launching terminal’s stdin is connected to the guest serial port.

---

### 2.3 `-serial stdio` transmit–receive loopback

**Problem.** After the shell prints a prompt or completes a line, the next `uart_read_line` blocks indefinitely although the user has not sent new input. Diagnostic reads of the line status register show **no RX data** (`LSR` bit 0 clear) while bit patterns consistent with **TX idle** remain set.

**Root cause.** With `-serial stdio`, bytes written to the UART **TX** can be reflected into **RX**. Aggressive post-newline flushing of the entire RX FIFO drains not only echo but also can interact badly with polling logic that assumes RX data implies user input.

**Resolution.** Treat **polling and interrupt-driven RX as mutually exclusive** code paths. In polling mode, **do not drain the full RX FIFO after every carriage return**. Avoid per-character guest echo that amplifies loopback. Rely on host `stty echo` for interactive visibility where appropriate.

---

### 2.4 Silent discard of login lines (plausibility filter)

**Problem.** The login prompt repeats with no “Login incorrect” message despite activity on the serial line.

**Root cause.** The console layer **silently ignores** lines that fail a plausibility check (e.g. non-lowercase characters or excessive length), which is indistinguishable from “no input” when loopback or noise produces garbage lines.

**Resolution.** When debugging input, distinguish **Layer A/B** (host→QEMU→MMIO) from **Layer D** (login policy). Fix transport first; only then tune filters or add explicit error messages if product requirements demand it.

---

### 2.5 Host session suspended (SIGTSTP)

**Problem.** Boot reaches `login:` then all keyboard input stops working.

**Root cause.** The user or shell job control sent **SIGTSTP** (e.g. Ctrl+Z), placing the QEMU driver process in the **stopped** state. No bytes reach the guest while the process is stopped.

**Resolution.** Resume the job (`fg`) or restart QEMU in the foreground. This is an operator/session issue, not a kernel login defect.

---

## 3. Cooperative User Execution (`prog_exec` era)

Before **fork/exec/wait**, the shell executed ELF binaries by saving a **shell continuation context** and **directly switching** to user mode on the shell’s stack region.

### 3.1 Corruption of `user_cxt` via `sscratch` during nested traps

**Problem.** Running `./hi` or similar user binaries caused panics during trap entry or `sscratch` writes, sometimes after a successful `write` syscall.

**Root cause.** After a user trap, **`sscratch` still pointed at the user save frame** while C-level trap handling ran on the kernel stack. A nested trap (e.g. timer) could then save into **`user_cxt`** instead of the kernel trap frame.

**Resolution.** Immediately after saving user registers in the trap vector, set **`sscratch` to the kernel trap context pointer**. Preserve the restore frame pointer on the stack; do not depend on `sscratch` holding the restore target through C code.

---

### 3.2 Instruction fetch from ASCII prompt buffer (`sepc` ≈ string data)

**Problem.** Synchronous exception **instruction access fault** at an address whose bytes decode as ASCII (e.g. fragments of `root@/home/root$`), not a valid code pointer.

**Root cause.** **`shell_save_cxt` captured `sp` and `s0` from inside `prog_exec`**, not from the shell loop. After `SYS_exit` and restore, **`ret` used the wrong stack frame**, loading a return address from stack slots that overlapped the **prompt string buffer**.

**Resolution.** At **`prog_exec` entry** (before any nested calls such as file read): capture **`ra` via explicit register read**, set **`gp` to the kernel global pointer**, and **reconstruct shell `sp`/`s0`** from the known stack frame layout (`PROG_EXEC_FRAME` offset). **Zero the full 32-slot context** before restore so caller-saved slots are not garbage.

---

### 3.3 Illegal instruction on second user run (`csrw sscratch` in U-mode)

**Problem.** The first `./hi` succeeded; a subsequent `./file_rw` faulted with **illegal instruction** at the instruction that writes **`sscratch`**.

**Root cause.** User **environment calls** leave **`sstatus.SPP` cleared** (previous mode U). Returning to kernel code via **`sret` without setting SPP** caused **supervisor trap handlers and CSR writes to execute in U-mode**, where `sscratch` is not writable.

**Resolution.** On the **return-to-shell path** after `SYS_exit`, **set `sstatus.SPP`** before `sret`. On **entry to user mode**, **clear `SPP`** so `sret` enters U-mode.

---

### 3.4 User binary never invokes exit (`./spin` hang)

**Problem.** `./spin` produced no output and never returned to the shell prompt.

**Root cause.** The on-disk **`spin` ELF was linked for the wrong load address** and **`_start` returned from `main` with `ret`** instead of issuing **`ecall` for `SYS_exit`**. The cooperative restore path only runs after a proper exit syscall.

**Resolution.** Rebuild user programs with the **same linker script (`user.ld`), `crt0.S`, and compile script** as working binaries (`hi`, `file_rw`), repack the ramfs image, and verify **LOAD segment VADDR** and **entry symbol** with `readelf`/`objdump`.

---

## 4. Trap Vector, Interrupts, and Global Pointer

### 4.1 Illegal instruction inside `reg_restore` at trap return

**Problem.** After introducing process-based user execution, `./hi` panicked with **illegal instruction** at an address inside the trap vector’s **register restore** sequence (`ld` from the context pointer).

**Root cause.** **Timer or software interrupts became enabled while `reg_restore` was still executing**, causing a **nested trap** that corrupted the saved frame pointer (register **`t6`**) or misaligned the trap entry when **compressed instructions (RVC)** were mixed into the vector region.

**Resolution.** Defer re-enabling interrupts until **`reg_restore` completes** (flag-based `trap_reenable_irq`). Mark the trap vector with **`.option norvc`** to avoid size/layout drift. Validate with disassembly that restore slots match **`struct context`**.

---

### 4.2 User-exit pending flag test on wrong operand

**Problem.** The user exit trampoline path never ran; the kernel did not resume the shell after `SYS_exit`.

**Root cause.** Assembly used **`beqz` on an address** (pointer to the flag) instead of **loading the flag word** first.

**Resolution.** **`lw` the pending flag, then branch on zero.**

---

### 4.3 Kernel global pointer zero at trap initialization

**Problem.** Shell commands such as `pwd` eventually crashed with **return PC in read-only data** (e.g. inside format strings), **nested trap depth 2**, and **`stval`** patterns consistent with bad addressing.

**Root cause.** **`gp` was not initialized** before C code used GP-relative addressing for globals (timer lists, diagnostics). Uninitialized **`gp`** produced subtle memory corruption and impossible control flow.

**Resolution.** In early boot assembly, load **`gp` from `__global_pointer$`** with **`.option norelax`**. At `trap_init`, **panic if `kernel_gp_value == 0`**.

---

### 4.4 Adjacent BSS: timer list overlapping trap save area

**Problem.** Seemingly random faults during shell use; **return PC** landed in **`.rodata`**. Timer callback pointers appeared valid in logs, but **frame storage abutted `timer_list`**.

**Root cause.** The **256-byte `kernel_trap_cxt`** region was placed immediately after **`timer_list`** without guard space; stack or trap activity **overwrote timer nodes or the trap frame**.

**Resolution.** Insert a **256-byte `timer_guard`** between **`timer_list`** and **`kernel_trap_cxt`**. Print layout addresses once at boot for verification.

---

## 5. Process Model, User Mode Entry, and Exit Return

The shell path **`proc_spawn_exec_wait` → scheduler dispatch → user execution → `SYS_exit` → `proc_wait`** replaced cooperative `prog_exec`. **Current (2026-06-14):** `proc_load_elf` sets READY; **`proc_sched_dispatch_one`** runs **`proc_user_first_run`**; exit returns via **`proc_user_trap_return`**. Historical sections below describe earlier coroutine-based paths.

### 5.1 Wrong trap frame and corrupted `sepc` on first user fault

**Problem.** `./hi` raised a synchronous fault at a **non-canonical PC** (e.g. high bits set on a kernel-linked address pattern).

**Root cause.** A **single global user trap frame** or incorrect **kernel stack top → user context** mapping caused **`sepc` and saved registers** to disagree with the active process.

**Resolution.** Allocate **`user_ctx` and dedicated kernel stack per process slot**; derive the user context pointer from **`kstack_top - PROC_KSTACK_TOP_TO_UCTX`** in assembly.

---

### 5.2 `sscratch` cleared before user register save

**Problem.** User **ecall** handling saw **`sscratch == 0`** in U-mode; subsequent traps misclassified mode or used the wrong stack.

**Root cause.** **`reg_restore` clobbered registers** (e.g. **`a1`**) before **`csrw sscratch`**, or **`sscratch` was written too late** on the path into user mode.

**Resolution.** In **`enter_uspace`**, assign **`sscratch = kstack_top` before `reg_restore`**. On **return to supervisor** from kernel traps, set **`sscratch = 0`**. Defer user **`sscratch` updates** on syscall return until the assembly epilogue after restore.

---

### 5.3 `current_pid` assigned before entering user mode

**Problem.** Timer interrupt handling saved state into the **wrong process** during spawn.

**Root cause.** **`current_pid` was updated too early**, before the child actually entered user mode.

**Resolution.** Set **`current_pid` only in `proc_enter_uspace()`** (or equivalent) immediately before user execution.

---

### 5.4 Trap vector `la` with user `gp == 0`

**Problem.** User programs hung with **no trap log lines**; the CPU never reached syscall handling.

**Root cause.** In user mode **`gp` is zero**; GP-relative **`la`** in the trap vector computed **wrong addresses** for kernel symbols.

**Resolution.** **Reload kernel `gp` at trap vector entry** (with **norelax**) before any kernel data access.

---

### 5.5 Exit return used spawn caller frame with `proc_user_run` stack pointer

**Problem.** User program exited (syscall logged) but **`proc_wait` spun forever**. Debugger showed **`child_pid` garbage**, **`path` pointer corrupted**, while the child was already **zombie** in the process table.

**Root cause.** **`SYS_exit` resumed at `proc_run_saved_ra` (inside `proc_spawn_exec_wait`)** while **`sp`/`s0` still reflected `proc_user_run`**. The CPU executed **frame A’s stack with frame B’s return address**—classic **stack/frame mismatch**.

**Resolution (historical).** Save **`run_saved_cont` = address of label `after_uspace`**. On exit, set **`pc` (via `sepc` path) to that continuation**, restore **`sp`/`s0`/`ra`/`gp`**, run **`trap_scratch_init(0)`**, reset **`current_pid`**, then return to waiter.

**Superseded (2026-06-14):** Continuation is now **`proc_user_trap_return`** (real function, not C label). `proc_prepare_kernel_return` sets trapframe `pc` to that entry; **`run_saved_cont` removed**. See §12.5.

---

### 5.6 Bogus exit status and broken stack frame in spawn helper

**Problem.** Automated run reported **`autorun: done status=0x8020fef0`** (kernel pointer as status).

**Root cause.** **`a0` held a pointer or trap-frame garbage** when copied as exit status; declaring **`wait_st` mid-function** disturbed the compiler’s stack frame on some paths.

**Resolution.** Treat **exit status > 255 as 0** when the value is clearly not a byte (temporary hardening). Declare **`wait_st` at function scope top**. Prefer reading status only from the **user trap frame** once that path is reliable.

---

### 5.7 GDB single-step at user entry vs non-debug execution

**Problem.** Under GDB, **continuing after `sret` to `0x80380000`** faulted at **`PC+2`** with **illegal instruction** and **`sscratch=0`**; the same binary under **AUTORUN** completed without fault.

**Root cause.** Multiple factors: **(a)** memory at user entry did not contain valid instructions (see Section 6); **(b)** debugger **disassembly mode** misinterpreted 32-bit instructions as RVC; **(c)** **single-stepping** interacted with timer IRQ and **`sscratch` invariants**.

**Resolution.** Verify guest memory with **`x/4wx` at user entry** before trusting **`ni`**. Break on **`ecall` at the program’s exit site** instead of stepping the first instruction. Compare **AUTORUN** (no GDB) vs interactive debug.

---

## 6. ELF Loading, Ramfs, and Embedded Home Image

### 6.1 Valid on-disk ELF but invalid instructions at user entry address

**Problem.** **`scause = illegal instruction`**, **`sepc = user_entry + 2`**, **`stval`** showing halfword of a misdecoded word. RAM at **`0x80380000`** (later **`0x80400000`**) contained **`0x8020fe72`** instead of **`lui sp`** encoding **`0x00008137`**.

**Root cause (dual).**

1. **Embedded ramfs object**: padding between the linker symbol and **`.incbin` payload** placed file content **4096 bytes away** from the symbol used as base—reads indexed from the symbol returned **wrong bytes** at ELF offset `0x1000`.

2. **Boot stack overlap**: **`fs_load_home()`** ran with a **boot stack pointer too low**, **smashing `.rodata`/BSS** including home image buffers or node tables before copy.

**Resolution.** Generate **`home_embed.S` with `.incbin`** so the embedded blob is contiguous with the symbol. Raise **boot `sp` to `0x87FF0000`** (or another safe region) before heavy C initialization. Rebuild with **`make clean && make home`** after changing user ELFs.

---

### 6.2 User virtual address layout vs kernel megapage map

**Problem.** After enabling Sv39, documentation and scripts still referenced **`0x80380000`** while faults or links failed at new addresses.

**Root cause.** **User load address moved to `0x80400000`** to avoid conflicting with the kernel’s **2 MiB identity map** around **`0x80200000`**.

**Resolution.** Link user binaries with **`ld/user.ld`**. When duplicating kernel mappings into per-process page tables, **omit megapages that span the user VA window** so per-page user PTEs are not shadowed.

---

## 7. User Trap Entry and Syscall Register Contract

### 7.1 User syscall arguments destroyed before context save

**Problem.** **`./hi` ran but produced no output**; **`write` appeared not to receive correct **`fd`/`buf`/`count`**.

**Root cause.** On user trap entry, **diagnostic or helper calls clobbered `a0`–`a7` before `reg_save`**.

**Resolution.** For traps from user mode (**`sscratch != 0`**), **compute `user_ctx` in assembly and call `reg_save` immediately**; skip pre-save diagnostics that touch argument registers.

---

### 7.2 Syscall return value clobbered on trap return path

**Problem.** **`file_rw` reported `open hello.txt failed`** despite a correct ramfs file.

**Root cause.** **`proc_current_kstack_top()`** (or similar) was invoked on the **`sret` return path** and **overwrote `a0`** after the syscall handler filled it.

**Resolution.** **Spill `a0` to the kernel stack** before calls that may clobber argument registers; **reload before** writing **`sscratch`** and **`sret`**.

---

## 8. Sv39, Demand Paging, and User Stack Growth

### 8.1 Implementation summary (resolved design points)

**Problem.** Flat mapping could not support per-process isolation or grow user stack on demand.

**Resolution.** Introduce **`vm_create` / `vm_map_user_page` / `vm_activate`**, per-process **`pagetable`**, **page fault handler** for load/store in the user region, and **demand mapping** for stack pages. Shell command **`yebiao`** inspects mappings (kernel RAM file vs process PTEs)—not exposed as a user syscall API.

---

### 8.2 Compiler stack slots above lowered `sp` (kernel fault during user stack demo)

**Problem.** User **`pagefault`** test faulted at a **kernel address** during stack growth loops.

**Root cause.** C locals lived **above the current `sp`** in the compiler’s view while inline assembly lowered **`sp`** without establishing a frame pointer—stores targeted **unmapped or kernel-only VAs**.

**Resolution.** In the demo program, grow stack with **inline assembly only** (`addi sp,-2048` and stores at `0(sp)`), avoiding large stack frames in the same function.

---

### 8.3 Interactive `./pagefault` crash after successful user output (resolved: waitpid page table)

**Problem.** The program printed expected messages including **`done`**, then the kernel reported **instruction page fault at `sepc = 0`**.

**Root cause (confirmed).** After **`waitpid`** ran the child inside the kernel, **`trap_return_to_user`** resumed the parent in user mode while **`satp` still pointed at the kernel page table**, so the parent’s user code at `0x80400046` was not mapped.

**Resolution.** In `trap_handler`, when returning to user (`trap_return_to_user`), call **`proc_activate_user(proc_current_pid())`** before `sret`. See debug notes in `log/0607-0608debug.md`.

---

### 8.4 Fork child re-executing `fork` (resolved)

**Problem.** Runaway fork / physical page exhaustion.

**Root cause.** Child’s **`pc` still pointed at the `ecall` instruction**; syscall return advanced parent only.

**Resolution.** On **`proc_fork`**, set child **`a0 = 0`** and advance child **`pc` past the `ecall`**.

---

## 10. Verification and Operational Discipline

| Practice | Rationale |
|----------|-----------|
| Interactive testing with **foreground QEMU** and **`-serial stdio`** | Ensures stdin reaches MMIO UART |
| Wait for **`Welcome` and shell prompt** before driving automation | Avoids sending commands during login |
| After editing `home/root/*.c`: **user compile script + full kernel rebuild** | Stale ELF in ramfs causes silent wrong-code faults |
| Use **`x/4wx` at user PC** before trusting debugger single-step | Separates **memory/load bugs** from **trap/sscratch bugs** |
| Do not enable **UART IRQ RX** while shell uses **polling** | Prevents double-consumption of RX bytes |
| Web UI: wait for **`Welcome, root.`** before judging terminal | Static HTML prompt is not a readiness indicator |
| After Web demux changes, restart **`start_server.sh`** and hard-refresh browser | Avoid stale client-side LOG filtering |

---

## 11. Web Frontend and Serial Demux

### 11.1 LOG lines mixed with shell text in browser terminal

**Problem.** After adding kernel `LOG {...}` output, the Web terminal showed JSON lines interleaved with login and shell I/O. Client-side regex filtering caused sticky packets, truncated JSON, and swallowed login prompts.

**Root cause.** A **single QEMU serial stream** was forwarded verbatim as WebSocket `output`. The frontend tried to strip `LOG` lines after the fact.

**Resolution.** Host **`SerialDemux`** classifies log lines; browser shows them only in the event panel. Client-side strip is a fallback only. See [05_web_frontend.md](05_web_frontend.md).

---

### 11.2 Program output missing (e.g. `./hi`) while event bubbles update

**Problem.** User runs `./hi`; event panel updates but terminal never shows program text.

**Root cause (dual).**

1. **Terminal gate:** Output before **`Welcome, root.`** is dropped.
2. **Line splitting:** Partial demux flush split the welcome string; gate never opened.

**Resolution.** Accumulate **`preShellBuf`** until welcome; hold partial non-log lines until `\n`.

---

### 11.3 Log bytes interleaved with shell output

**Problem.** Terminal shows fragments like `cLOG {"ts_ms":…}` during interactive programs.

**Root cause.** Console and log share one serial stream; reads can split mid-line.

**Resolution.** Demux scans for embedded `LOG` / `LOG_SNAPSHOT` markers, not only line starts. Kernel uses separate **`console_write`** and **`log_write`** APIs (same UART today). Client strips any remaining log segments from console chunks.

---

### 11.4 Web `vi` duplicated lines or broken keys

**Problem.** Insert mode prints each line twice; single keys (`i`, Esc) do not reach the editor.

**Root cause.** Line-at-a-time Web input plus local echo conflicted with guest character echo and `vi`’s raw read loop.

**Resolution.** Remove local echo; auto **raw mode** when `vi` banner appears; single-key send until save or quit.

---

### 11.5 Background script `sleep` never finishes (Web)

**Problem.** `. sh01.sh &` prints first lines then stalls; last `echo` after `sleep 20` missing; `ps` shows pid stuck.

**Root cause.** With UART IRQ, shell blocked in `proc_block` without calling **`script_bg_poll`**; sleep expiry was never checked.

**Resolution.** Call **`script_bg_poll`** from timer handler and before UART block; shell commands **`jobs`** and **`kill [pid]`** to inspect or stop.

## 12. User process scheduling (`proc_sched`)

*Sections 12.1–12.4 document historical defects during coroutine-era scheduling. Current model: [01_architecture.md](01_architecture.md) §6.*

### 12.1 False early exit via `proc_user_run_unwind_blocked` *(removed 2026-06-14)*

**Problem.** Running `./ipc_echo` (or `AUTORUN=ipc_echo`) destroyed pid=2 page tables before `main` reached sem create; `vm_destroy` panicked on corrupt PTEs.

**Root cause.** `proc_block()` called `proc_user_run_unwind_blocked()`, which **`jr`’d to `after_uspace`** without a normal trap return. User/kernel context (satp, stack, `run_saved_cont`) was inconsistent; the parent appeared to exit while still inside `waitpid`.

**Resolution.** Do **not** unwind from `proc_block`. Return blocked processes through **`proc_block` → `proc_sched` → `proc_kctx_switch`** (Stage 2+). **`proc_user_run_unwind_blocked` deleted** in Stage 4.

---

### 12.2 READY starvation: `proc_user_run_inflight` vs blocked syscall

**Problem.** After disabling unwind, `./ipc_echo` printed the input prompt but **keyboard had no effect** (no producer/consumer output, `q` did not quit). UART IRQ fired and `wakeup pid=3` appeared in logs, but no `sched run pid=3` followed.

**Root cause.** Nested `proc_block` + `proc_user_run` used `if (!proc_user_run_inflight(next))` before running a woken process. A process blocked in a syscall still has **`proc_user_run_depth > 0`**, so READY pid=3 was filtered out and the CPU stayed in **`wfi`** forever.

**Resolution (superseded in part by §12.3–12.4).**

- Removed **`proc_user_run_resume`** — no second `enter_uspace` on wakeup.
- Blocked processes resume through **`proc_block` → syscall return → user** after `proc_kctx_switch` back (Stage 2).
- **`proc_user_run_dispatch`**: only **`depth==0`** fresh runs.

---

### 12.3 `ipc_echo quit` panic — stale `after_uspace` / wrong `saved_pid`

**Problem.** Interactive `./ipc_echo`, then `q`: panic at garbage address (`LEAVE pid=4 restore=3`, page fault in kernel).

**Root cause (Case A — stale continuation).** Producer (pid=3) blocked inside `proc_user_run` → syscall → `proc_block`. `current_pid` stayed 3; nested scheduling captured **`saved_pid=3`** instead of ipc_echo parent (2). On consumer exit, trap return used stale `after_uspace` with a dead stack frame.

**Resolution.**

- **`saved_pid` correction** when blocked inflight parent exists (`run_sched_parent`).
- **`proc_pick_next_ready`**: skip `depth>0` — never re-dispatch a process with an active continuation.
- **`after_uspace`**: call **`proc_activate_kernel()`** before touching globals.
- Stage 2: blocking no longer nests `proc_sched_run_ready` on the blocked frame.

---

### 12.4 Stage 2 shell typing freeze — `kctx_asleep`

**Problem.** After Stage 2 (`proc_block` → `proc_sched` → `proc_kctx_switch`), **interactive shell could not accept keyboard input** at `login:` or `root@…$`.

**Root cause.** Resume picker required **`depth>0` AND pagetable**. Shell (pid 1) runs in kernel context: **no pagetable**, **`depth==0`**. UART wakeup set READY but scheduler never `swtch`ed back → permanent `wfi`.

**Resolution.**

- **`kctx_asleep`** flag: set in `proc_sched()` before switch, cleared on return.
- **`proc_pick_next_ready_resume()`**: `READY && kctx_asleep && kctx.ra != 0` (covers shell and user blockers).
- **`proc_pick_next_ready()`**: skip `kctx_asleep`.

**Operator note:** Interactive typing requires **`DEBUG=n ./sh/start_qemu.sh`** on a real terminal.

See [log/0613.md](../log/0613.md).

---

### 12.5 Stage 3–4 — scheduler-only dispatch and trap return *(2026-06-14)*

**Problem.** Three continuation mechanisms coexisted: C coroutine (`proc_user_run` / `after_uspace`), kctx switch (block/wake), and longjmp dispatch (`sched_dispatch_jmp` / `dispatch_ret`). Interactive **`ipc_echo`** failed on TTY while piped tests passed: producer blocked on UART → scheduler dispatched consumer from unstable longjmp frame → panic on parent return.

**Resolution.**

- **Fresh READY:** `proc_sched_dispatch_one` → `proc_kctx_switch(sched_kctx, child_kctx)` → `proc_user_first_run` → `enter_uspace` (no `proc_user_run`, no longjmp).
- **Exit/yield/fault:** `proc_prepare_kernel_return` → **`proc_user_trap_return`** → `proc_kctx_switch` back to scheduler (no `after_uspace` label).
- **`proc_wait`:** sleep-only loop (`proc_block`); scheduler runs other READY children — no nested dispatch on waiter frame.
- **Removed:** `proc_user_run`, `run_saved_cont`, `proc_user_run_depth`, longjmp dispatch stack, `dispatch_longjmp` / `dispatch_ret` PCB fields.
- **`proc_user_in_uspace`:** replaces depth guard for yield unwind; **`proc_pick_next_ready`** skips `in_uspace` and `kctx_asleep`.

**Verified:** TTY interactive `ipc_echo`; piped `AUTORUN=ipc_echo`; `PROC_KSTACK_TOP_TO_UCTX` updated to `0x11a0` after PCB shrink.

See [6.14.txt](../6.14.txt) and [01_architecture.md](01_architecture.md) §6.

---

## 13. Chronological arc (summary)

Bring-up began with **OpenSBI and unified MMIO UART** for login. **Cooperative `prog_exec`** exposed **`sscratch` lifecycle**, **incorrect shell stack capture**, and **`SPP` not restored** on return to supervisor. Migration to **per-process trap frames** and **`proc_wait`** required **kernel `gp` in the trap vector** and **strict ordering of `reg_save` vs syscall arguments**. **ELF corruption** from **embed padding** and **low boot stack** masqueraded as trap bugs until memory at user entry was verified. **Sv39** moved user base to **`0x80400000`**, added **demand stack mapping** and **`yebiao`**. **`waitpid` parent resume** required **`proc_activate_user` on trap return**. **UART RX IRQ + ring** and **`proc_sched` block/wakeup** enabled blocking `read` and **`ipc_echo`**. Coroutine-era **`proc_user_run` / `after_uspace`** fixed early exit stack mismatches but caused **READY starvation** and **stale continuation panics** until **`proc_kctx_switch`** and **`kctx_asleep`**. **2026-06-13:** **Stage 1–2** — `proc_kcontext`, dedicated **scheduler stack**, shell UART resume. **2026-06-14:** **Stages 3–4** — scheduler-only fresh dispatch, **`proc_user_trap_return`**, removal of coroutine/longjmp paths; TTY + piped **`ipc_echo`** verified. **Observability:** macro-gated **`LOG_*`** and **LibertyOS Web UI** with **server-side serial demux**.

---

## Related documents

| Document | Contents |
|----------|----------|
| [01_architecture.md](01_architecture.md) | Current architecture |
| [02_call_chains.md](02_call_chains.md) | Block/wakeup call trees |
| [README.md](README.md) | Operator quick start |
| [log/0613.md](../log/0613.md) | 2026-06-13 Stage 1–2 change log |
| [6.14.txt](../6.14.txt) | 2026-06-14 Stage 3–4 completion notes |

---

*Last aligned with: xv6-style scheduler (Stages 1–4), `proc_user_first_run` + `proc_user_trap_return`, `proc_kctx_switch` dispatch/resume, TTY + AUTORUN `ipc_echo` verified (2026-06-14).*
