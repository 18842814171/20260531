# 0604 — myos U-mode debug session summary

Session focus: fix `return0` illegal-instruction and `./hi` missing output; complete `06.txt` logging/script cleanup; add **Sv39**, demand stack faults, **`yebiao`**, and **`pagefault`** demo. Reference: [log/0604_ref_usermode.md](0604_ref_usermode.md). Prior: [log/0603debug.md](0603debug.md).

**Architecture:** **RV64** (`-march=rv64gc -mabi=lp64`), OpenSBI S-mode, **Sv39** (`satp` mode 8). User VA window `0x80400000`–`0x80480000` (see `include/proc_user.h`).

---

## 1. Conversation arc

| Phase | Goal | Outcome |
|-------|------|---------|
| T2025 / ArceOS compare | Map U-mode path vs myos (`exec`, trap return, ELF load) | Table in `0604_ref_usermode.md` |
| `AUTORUN=return0` illegal insn | `scause=2`, bad bytes at old `0x80380000` | **Fixed** — embed + boot stack (§2) |
| `./hi` no output | Syscall args clobbered before `reg_save` | **Fixed** — `entry.S` order (§3) |
| `06.txt` item 1–2 | LOG JSON + script cleanup | **Done** (§4–5) |
| `file_rw` | `open hello.txt failed` | **Fixed** — `entry.S` syscall `a0` restore (§12.1) |
| Sv39 + page faults | Per-process PT, `vm_activate`, demand map | **Implemented** — `mem/vm.c`, `proc_user.c` (§12.2) |
| User should not “feel” page tables | Normal C + shell `yebiao` | **Done** — `pagefault.c`, `console.c` (§12.3) |
| Interactive `./pagefault` | Crash after `done` | **Open** — §13 |

---

## 2. `./return0` illegal instruction (fixed)

### Symptom

```
AUTORUN=return0
scause=2  sepc=0x80380002  stval=0x8020
RAM @ 0x80380000: 0x8020fe72  (not 0x00008137 lui)
```

Expected first insn at user entry: `lui sp, …` (`0x00008137` style).

### Root causes (two)

| # | Cause | Fix |
|---|-------|-----|
| 1 | Bad embedded ELF — `.base64` padding placed symbol 4096 B before payload | `tools/pack_home.py` → `fs/home_embed.S` (`.incbin`) |
| 2 | Boot stack smash into `.rodata`/BSS during `fs_load_home()` | `boot/start.S`: `sp = 0x87FF0000` |

### Note on addresses (post-Sv39)

User ELFs now link at **`0x80400000`** (`ld/user.ld`) to avoid overlapping the kernel **2 MiB** identity map at `0x80200000`. Old notes referencing `0x80380000` are from the pre-Sv39 layout.

---

## 3. `./hi` missing output (fixed)

### Root cause

On user trap, **`a0`–`a7` were clobbered before `reg_save`** (`trap_get_user_frame` / diag C calls in `entry.S`).

### Fix (`interrupt/entry.S`)

1. Skip `trap_diag_trap_pre` when `sscratch != 0` (incoming user trap).
2. Compute `user_ctx = kstack_top - PROC_KSTACK_TOP_TO_UCTX` in asm; **`reg_save` immediately**.

### Verification

```
autorun: ./hi
hi from ./hi
autorun: done status=0
```

---

## 4. Changes made (by file) — original 0604 session

### Embed / ramfs / boot stack

| File | Change |
|------|--------|
| `tools/pack_home.py` | `fs/home_embed.S` with `.incbin` |
| `boot/start.S` | Boot `sp = 0x87FF0000` |

### User trap / syscalls

| File | Change |
|------|--------|
| `interrupt/entry.S` | User trap: asm `user_ctx`; early `reg_save`; syscall `a0` save around `proc_current_kstack_top` |
| `include/proc.h` | `PROC_KSTACK_TOP_TO_UCTX` |

### LOG + scripts (`06.txt`)

| File | Change |
|------|--------|
| `interrupt/trap_diag.c`, `trap.c` | `osviz_event()` JSON |
| `sh/debug.sh`, `sh/gdbinit` | Single debug entry; removed one-off gdb scripts |

---

## 5. Log output format

Trap noise → `LOG {"module":"trap",...}` when `CONFIG_LOG=1`. Program UART output stays plain text. `make DEBUG=0` sets `CONFIG_LOG=0`.

---

## 6. Scripts

| Script | Role |
|--------|------|
| `sh/start_qemu.sh` | Run QEMU (`DEBUG=n` disables osviz pipe only, not kernel `LOG`) |
| `sh/debug.sh` | QEMU `-S` + GDB |
| `sh/gdbinit` | Generic breakpoints |

---

## 7. T2025 vs myos (trap path)

| Item | myos (current) | T2025 (ArceOS / Undefined-OS) |
|------|----------------|-------------------------------|
| ISA | **rv64gc**, lp64 | **rv64** (same class; ArceOS build) |
| User link base | `0x80400000` (`ld/user.ld`) | ELF entry from `map_elf` / `load_user_app` (high user VA, e.g. ~`0x4_0000_0000` region for bundled apps) |
| User stack top | `0x80470000` (`USER_STACK_TOP`) | `USER_STACK_TOP - stack_data.len()` (~`0x4_0000_0000` minus argc/argv/env), 16-byte aligned |
| `satp` | Sv39 per process; `vm_activate()` on user entry/exit; kernel 2 MiB map duplicated in each PT | Switched in `TaskContext::switch_to()` when `satp` changes — **before** the task runs, not in the trap-return stub |
| Page faults | Kernel `vm_fault_handle()` for user load/store in `[USER_MEM_BASE, USER_MEM_END)` (demand stack pages) | Kernel MM / trap path (full user page tables; not a flat identity map) |
| Trap return | `reg_restore` + `trap_return_to_user` in `entry.S`; no `sstatus` in frame | `RESTORE_REGS` in `trap.S`; frame includes **`sstatus`** @ slot 32 |
| First `sepc` | `eh->e_entry` → `uc->pc` → `enter_uspace` | ELF `entry` → `TrapFrame.sepc` |

---

## 10. Key symbols (re-verify: `nm out/os`, `objdump -d home/root/pagefault`)

| Symbol / VA | Role |
|-------------|------|
| `0x80400000` | User ELF entry (`_start` in `crt0.S`) |
| `USER_STACK_TOP` (`0x80470000`) | Initial user `sp` |
| `vm_fault_handle` | Demand-map user stack/heap pages |
| `vm_info_file` / `vm_info_proc` | `yebiao` backend |
| `proc_spawn_exec_wait` | Shell `./prog` and AUTORUN |
| `after_uspace` | Kernel continuation after `proc_user_run` |

---

## 11. Open / optional follow-ups (from early session)

1. Makefile — rebuild `out/boot/kernel` when `AUTORUN=` changes.
2. User `gp` in trap frame — kernel `gp` reloaded before `reg_save`.
3. Update `0604_ref_usermode.md` if it still describes pre-`reg_save` trap path.

---

## 12. Post-0604: Sv39, pagefault demo, yebiao

### 12.1 `file_rw` (fixed)

**Symptom:** `open hello.txt failed` under user PT.

**Cause:** `proc_current_kstack_top()` in `entry.S` user-return path clobbered **`a0`** (syscall return value) before writing `sscratch`.

**Fix:** `sd a0, 8(sp)` before the call; restore after.

### 12.2 Sv39 implementation

| Area | Files | Notes |
|------|-------|-------|
| Walk/map/activate | `mem/vm.c`, `include/vm.h` | `vm_create`, `vm_map_user_page`, `vm_map_user_zero`, kernel 2 MiB + devices |
| Per-process PT | `proc/proc.c` | `pagetable` per slot; `vm_activate` on user entry/exit |
| Exec | `proc/proc_user.c` | ELF mapped at `p_vaddr`; initial stack `USER_STACK_PAGES` (4 × 4 KiB below `USER_STACK_TOP`) |
| Faults | `interrupt/trap.c` | Cause 13/15 → `vm_fault_handle`; retry `epc` |
| Boot | `boot/kernel.c` | `vm_init()` after `page_init()` |

Kernel RAM identity map **skips** megapages overlapping `[USER_MEM_BASE, USER_MEM_END)` so per-process 4 KiB PTEs are not shadowed by a 2 MiB leaf.

### 12.3 Design: user invisible to page tables

| Principle | Implementation |
|-----------|----------------|
| User program | `home/root/pagefault.c` — plain C + inline asm that lowers **`sp`** one page at a time; no PTE vocabulary |
| Who handles faults | `vm_fault_handle()` in kernel only |
| How to *inspect* mappings | Shell command **`yebiao`** (not a syscall API) |

**`yebiao` usage (interactive shell):**

```text
yebiao hello.txt     # ramfs file bytes in kernel RAM (not a process PT)
yebiao hi            # same for embedded ELF file
yebiao P0            # kernel: satp + Sv39 summary
yebiao P1            # shell (no user PT until it runs a program)
./pagefault
ps                   # note child pid, e.g. 2
yebiao P2            # that process’s user-region PTE dump
```

**`pagefault.c` stack demo (current source):** loop of `addi sp,-2048` ×2 + `sb zero,0(sp)` — avoids GCC frame-pointer locals **above** `sp` (which had caused faults at kernel addresses like `0x80217bd0`).

**AUTORUN note:** After editing `pagefault.c`, run `./usr/compile.sh c pagefault.c && make` (not only `compile.sh`).

---

## 13. Bug: interactive `./pagefault` — crash after `done` (OPEN)

### 13.1 Observed symptom (terminal)

From interactive shell (`terminals/1.txt` ~L284–287):

```text
root@/home/root$ ./pagefault
pagefault: using more stack than usual...
pagefault: done.page fault sepc=0x0000000000000000 stval=0x0000000000000000 cause=12 (unhandled)
return_pc not in kernel .text or user: 0x0000000000000000 (trap epc=0x0000000000000000)
panic: return_pc not in kernel .text or user
```

| Field | Value | Meaning |
|-------|-------|---------|
| User-visible progress | Both messages printed | User code finished (`main` + `write` of `done.\n`) |
| `cause=12` | Instruction page fault | Fetch from `sepc` failed |
| `sepc=0`, `stval=0` | Null PC | CPU tried to execute at address **0** |
| `return_pc` check | Also **0** | `trap_handler` would have returned to PC 0 → `sret` to NULL |

**Contrast:** Same `pagefault` binary via **`AUTORUN=pagefault`** has been reported to complete with `pagefault: done.` and no panic (verify after full `make` with `CONFIG_AUTORUN`).

### 13.2 Likely failure point

Failure is **after** user program logic, on the path **user `SYS_exit` → kernel return to `proc_user_run`’s `after_uspace:`**, not during the demand-fault loop itself.

Relevant code:

```c
// trap.c — SYS_exit
cont = proc_run_saved_cont(pid);
*return_pc = cont ? cont : proc_run_saved_ra(pid);

// proc_user.c
proc_save_run_cont(pid, (reg_t)&&after_uspace);
// ...
after_uspace:
    vm_activate(vm_kernel_pt());
```

If **`run_saved_cont` and `run_saved_ra` are both 0** for the exiting child, `return_pc` becomes **0** → instruction fault at `sepc=0` → panic in `trap_check_return_pc()`.

### 13.3 Hypotheses (investigation order)

| # | Hypothesis | Why plausible |
|---|------------|----------------|
| H1 | **`run_saved_cont` cleared or never set** for this pid | Wrong `proc_current_pid()` on exit, slot reuse, or memory corruption |
| H2 | **`proc_prepare_kernel_return` skipped** (`run_saved_ra == 0`) | Early return leaves trap frame inconsistent (less likely if H1 already zeroes `return_pc`) |
| H3 | **Deep user `sp` without restore** before `crt0` `ecall` exit | 20 × 4 KiB growth; may corrupt adjacent trap state or return metadata (not the printed user strings) |
| H4 | **Many page faults + trap frame** | Each fault retries user insn; verify `user_ctx` / `kernel_trap_cxt` not confused on final exit trap |
| H5 | **Stale kernel image** | Guest rebuilt but `out/os` not relinked (less likely if `done` string is new) |

### 13.4 Debug plan

1. **Reproduce with LOG**
   ```bash
   cd code/myos
   ./usr/compile.sh c pagefault.c && make
   ./sh/debug.sh
   ```
   - `(gdb) break trap_handler` when `cause & 0xff == 8` and `a7 == 93` (SYS_exit), child pid ≥ 2  
   - Print `proc_run_saved_cont(pid)`, `proc_run_saved_ra(pid)`, `return_pc` before `trap_check_return_pc`

2. **Compare AUTORUN vs shell**
   ```bash
   make AUTORUN=pagefault && DEBUG=n ./sh/start_qemu.sh
   # vs interactive ./pagefault
   ```
   - If AUTORUN passes and shell fails → focus on **pid**, **shell `proc_spawn_exec_wait`**, and **timer/IRQ** during long fault storm.

3. **Minimal user workaround (test H3)**
   - At end of `pagefault.c` `main`, restore stack (`asm` add `sp,+N`) or call **`SYS_exit` from C** via inline `ecall` without returning through `crt0`.
   - If panic disappears → stack/teardown interaction confirmed.

4. **Kernel hardening (after root cause)**
   - On `SYS_exit`, if `cont == 0`, log pid/slot and panic with explicit message (avoid silent `sret` to 0).
   - Optionally use **`kernel_trap_cxt`** for exit return instead of mutating `user_ctx` (audit `proc_prepare_kernel_return`).

5. **Regression suite**
   | Command | Expected |
   |---------|----------|
   | `AUTORUN=pagefault` | `done.` + shell/autorun continues |
   | Interactive `./pagefault` | Same, shell prompt returns |
   | `yebiao P<pid>` after run | Extra user stack pages visible vs initial 4 |

### 13.5 Acceptance criteria

- Interactive `./pagefault` prints both lines and returns to `root@/home/root$` without panic.
- `ps` shows shell pid stable; child becomes zombie then reclaimed by `proc_wait`.
- `yebiao P<pid>` after run shows additional mapped pages in the stack region (demand-filled).

---

## 14. Planned work (from `0604.txt` / demo list)

| Item | Status |
|------|--------|
| Sv39 + `satp` switch | Done |
| Page-fault handling (demand stack) | Done for load/store; exit path bug §13 |
| More user programs (`重要现场演示项目.txt`) | Partial — `pagefault`, `file_rw`; expand as needed |
| `yebiao` polish | Optional — VPN/PTE bit decode, align with Linux `pmap`-style output |

---

*Last updated: 2026-06-03 — Sv39, pagefault/yebiao, interactive `./pagefault` exit-at-PC-0 documented with debug plan (§13).*
