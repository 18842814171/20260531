# 0603 — myos U-mode debug session summary

Session focus: refactor user-mode trap ownership, fix `SYS_exit` return path, restore normal user programs. Reference tree: `T202510003995291-2331` (Undefined-OS / ArceOS `uspace`). Detailed reference notes: [log/0603_ref_umode_summary.md](0603_ref_umode_summary.md).

---

## 1. Conversation arc

| Phase | Goal | Outcome |
|-------|------|---------|
| Reference study | Map ArceOS U-mode (sscratch split, per-task kstack, SUM, ELF load) | `log/0603_ref_umode_summary.md` |
| Structural refactor | Per-proc trap frame, pure sscratch semantics, no exit trampoline | Landed in `proc/`, `interrupt/entry.S`, `trap.c` |
| `./hi` crash | Instruction fault at transformed kernel PC (`0x1802026e4`) | Root cause: sscratch / frame / gp bugs (see §3) |
| ebreak probe | Verify CPU actually enters U-mode at `0x80380000` | **Success** — breakpoint trap from U-mode, hardware `sepc` matched frame |
| “Back to normal” | Remove ebreak patch and verbose probes | Probes removed; syscall/exit path fixes added |
| `proc_wait` hang | GDB showed `child_pid=10`, garbage `path` | **Fixed** — exit returned to wrong frame (§4, §5) |
| Exit return fix | Resume in `proc_user_run`, not caller | **Landed** — `run_saved_cont` + `after_uspace` (§4) |
| AUTORUN smoke | `make AUTORUN=return0` | **`autorun: done status=0`** without GDB (§5.1) |
| GDB step into user | Single-step after `sret` to `0x80380000` | **Fails** — illegal insn at `0x80380002`, `sscratch=0` (§5.2) |

---

## 2. Changes made (by file)

### 2.1 Removed (debug / probe)

| Item | Status |
|------|--------|
| `CONFIG_USPACE_PROBE`, ebreak patch in `proc_load_elf` | Removed |
| `trap_uspace_sret_probe()`, `[user-trap]` / `[user-ecall]` | Removed |
| `proc_user_run begin` / `about to sret` prints | Removed |
| ebreak panic handler (`scause` code 3) | Removed |
| `uart_putc('>')` before `sret` in `enter_uspace` | Removed |

### 2.2 Kept / added (structural + exit fix)

#### `interrupt/entry.S`

- Reload `kernel_gp_value` at `trap_vector` (`.option norelax`).
- User trap: save `t3`/`t4` → frame slots 30/1; defer `sscratch = kstack_top` via `trap_return_to_user` after `reg_restore`.
- `enter_uspace`: `sscratch` before `reg_restore`; clear `SIE`; clear `SPP`, set `SPIE`; `sret`.

#### `interrupt/trap.c`

- `SUM` in `trap_init`; `trap_return_to_user` flag; `sscratch` cleared in C, set in asm for user return.
- User `ecall`: `cxt->ra = epc + 4` before `handle_sync_exception`.
- **`SYS_exit` (updated)**:
  - `proc_user_exit()` with sanitized status (`> 255` → `0` when trap frame has bogus pointer-as-status).
  - `proc_prepare_kernel_return()` sets **`pc = run_saved_cont`** (not `saved_ra`).
  - `*return_pc = run_saved_cont` → resume at **`after_uspace`** in `proc_user_run`.
  - No `trap_scratch_init` in trap handler on exit (tail in `proc_user_run` runs it).

#### `proc/proc.c` / `proc/proc_user.c`

- Per-proc: `user_ctx`, `kstack[]`, `run_saved_ra/sp/s0`, **`run_saved_cont`**.
- `proc_prepare_kernel_return`: `pc = cont ? cont : ra`; restore `sp`, `s0`, `ra`, `gp`.
- **`proc_user_run`**: save `ra/sp/s0` before any calls; `proc_save_run_cont(pid, &&after_uspace)`; label **`after_uspace:`** runs `trap_scratch_init(0)`, `current_pid = PROC_SHELL_PID`, `return 0`.
- **`proc_spawn_exec_wait`**: `wait_st` declared at function top (avoid broken epilogue); `proc_user_run` then `proc_wait`.

#### `interrupt/trap_diag.c`

- Verbose return logging also accepts `proc_run_saved_cont` PC.

---

## 3. Root causes found (chronological)

| # | Symptom | Cause | Fix |
|---|---------|-------|-----|
| 1 | `./hi` sync fault at `0x1802026e4` | Wrong trap frame / corrupted `sepc` | Per-proc frame, kstack lookup |
| 2 | User ecall with `sscratch=0` in U-mode | `reg_restore` clobbered `a1` before `csrw sscratch` | Set `sscratch` before `reg_restore` in `enter_uspace` |
| 3 | Kernel timer + `sscratch=kernel_sp` | `csrrw` left kernel SP in `sscratch` | Zero `sscratch` on kernel return |
| 4 | Timer saved into wrong proc during spawn | `current_pid` set too early | Defer until `proc_enter_uspace()` |
| 5 | Hang before `sret` (probe path) | `la kernel_gp_value` with `gp=0` | `.option norelax` at trap entry |
| 6 | ebreak: wrong `frame_pc` | `a1` clobbered | Read kstack from `sscratch` CSR |
| 7 | `./hi` hang (no trap lines) | `trap_vector` `la` with user `gp=0` | Reload kernel `gp` at trap entry |
| 8 | Store fault in `proc_user_run` after exit | `saved_ra` captured after helper calls | Save `ra/sp/s0` at start of `proc_user_run` |
| 9 | Invariant: kernel epc + sscratch on syscall return | `sscratch` set in C before `sret` | Defer user `sscratch` to `entry.S` |
| 10 | Exit `return_pc` inside `proc_user_run` | Same as #8 for `saved_ra` | Correct `saved_ra` to spawn caller |
| **11** | **`proc_wait` spin; `child_pid=10`; `path=0xffffffff`** | **Exit jumped to `saved_ra` with `proc_user_run` `sp/s0`** — frame A restore, frame B execution | **Resume at `after_uspace`; normal `return 0` to spawn** (§4) |
| **12** | **`autorun: done status=0x8020fef0`** | Bogus `cxt->a0` on exit + mid-function `wait_st` broke spawn epilogue | **`status > 255` → 0**; move `wait_st` to top of `proc_spawn_exec_wait` |
| **13** | **GDB: illegal insn at `0x80380002`** | **`sscratch=0` on first user trap**; possible timer/step interaction; GDB may disassemble U-code wrong (§5.2) | **Open** — fix user-trap `sscratch` invariant under debug |

---

## 4. Exit return bug (06.txt analysis — confirmed)

### Symptom triad (all caller-local)

| Observation | Value | Meaning |
|-------------|-------|---------|
| `path` | `0xffffffff…` | `proc_spawn_exec_wait` frame corrupt |
| `child_pid` in `proc_wait` | `10` (not `2`) | Load from wrong `s0`/stack slot |
| Zombie in `proc_list` | pid 2 `PROC_ZOMBIE` | `proc_mark_zombie` **was** working |

**Not** a wait-table bug or missing zombie — **stack/frame mismatch**.

### Mechanism

`proc_save_run_caller()` stored **`proc_user_run`’s** `sp/s0`, but `SYS_exit` returned to **`proc_spawn_exec_wait`** via `proc_run_saved_ra` (`0x80204c44`), skipping the `proc_user_run` epilogue.

### Fix

1. Save **`run_saved_cont`** = address of `after_uspace:` (GCC `&&label`).
2. On `SYS_exit`: `proc_prepare_kernel_return()` sets **`pc/sp/s0`** for `proc_user_run`; `return_pc = cont`.
3. Run tail: `trap_scratch_init(0)`, `current_pid = PROC_SHELL_PID`, `return 0`.
4. Normal C return into `proc_spawn_exec_wait` → correct `child` → `proc_wait` succeeds.

### GDB confirmation (pre-fix at `0x80204c44`)

```
sp=0x8020fef0  s0=0x8020ff40  ra=pc=0x80204c44
#0  0x80204c44 in ?? ()    ← no proc_spawn / kernel_main chain
current_pid == 2            ← not reset to shell
```

Post-fix, `trap leave … return_pc=0x80204562` (`after_uspace` in LOG=0 build) and **`autorun: done status=0`**.

---

## 5. Current runtime status

### 5.1 What works (non-GDB / AUTORUN)

```bash
cd code/myos && make AUTORUN=return0
DEBUG=n ./sh/start_qemu.sh
```

Observed:

```
autorun: ./return0
autorun: done status=0
```

- U-mode entry, user `ecall` exit, resume at **`after_uspace`**, zombie reaped, shell pid restored.
- Full path completes and powers off.

Same with default `CONFIG_LOG=1` after exit-status sanitize (no panic in quick smoke).

### 5.2 What fails (GDB single-step — terminal 2026-06-03)

Session: step through `enter_uspace` → `sret` → land at `0x80380000`, then `continue`.

```
(gdb) n
0x0000000080380000 in ?? ()
=> 0x80380000:  fe72    sd      t3,312(sp)    ← GDB disassembly (see note below)

(gdb) c
trap: pid=2 mode=user epc=0x80380002 sscratch=0 frame=user_proc kind=sync code=2
Sync exception code = 2 at 0x80380002
  ra=0 sp=0x80390000 gp=0x80210800
[trap-diag] panic-sync scause=2 stval=0x8020 sepc=0x80380002 sscratch=0
panic: OOPS! What can I do!
```

**Interpretation:**

| Field | Value | Notes |
|-------|-------|-------|
| `scause` | 2 | Illegal instruction |
| `sepc` | `0x80380002` | PC+2 from entry — fault on 2nd half of first insn or misaligned fetch |
| `sscratch` | 0 | User trap path mis-identified / no kstack swap — **known weak point** |
| `stval` | `0x8020` | Faulting instruction bits (low half) |

**ELF ground truth** (`home/root/return0`):

```
80380000:  00008137   lui sp,0x8
80380004:  0391011b   addiw sp,sp,57
```

GDB’s `fe72` at `0x80380000` is **not** the ELF encoding — likely **wrong disassembly mode** (treating 32-bit slot as RVC) or stale memory view while stepping. **Verify with** `x/4i 0x80380000` and `x/4wx 0x80380000` in GDB before trusting `ni` at user PC.

**Contrast:** AUTORUN without stepping reaches exit at `0x80380014` and status 0. Interactive GDB step/continue is **not** yet a reliable test of user entry.

### 5.3 `./spin` / `./hi` (interactive shell)

- Before exit fix: `./spin` exited (syscall logged) then **hung in `proc_wait`**.
- After exit fix: expect spawn/wait to complete; **re-test from login** after rebuild.
- `./hi` (write syscall): not re-verified in latest log; still higher risk than `return0`/`spin`.

---

## 6. Comparison with reference project

| Mechanism | Reference (ArceOS / Undefined-OS) | myos (current) |
|-----------|-----------------------------------|----------------|
| Address space | Per-process Sv39, `satp` | Flat map; user VA `[0x80380000, 0x80400000)` |
| Enter U-mode | `sscratch` + `sret` | `enter_uspace(uc, kstack_top)` — same idea |
| Trap frame | On task kernel stack | `user_ctx` + `kstack[]` per proc |
| Trap detect | `sscratch == 0` → kernel | Same |
| `sscratch` on return to U | Set immediately before `sret` | `entry.S` after `reg_restore` |
| Process exit | Scheduler reaps | `SYS_exit` → zombie → **`proc_wait`** (fixed return path) |
| Wait / reap | Kernel scheduler | **`proc_wait` + `wfi`** — **working in AUTORUN** |

---

## 7. Recommended next steps

1. **GDB user entry** — At `0x80380000`: `info reg sscratch sepc`; `x/4wx 0x80380000`; `set riscv use-compressed-breakpoints off` if needed; break on `ecall` at `0x80380014` instead of stepping first insn.
2. **`sscratch=0` on first user trap** — Ensure `enter_uspace` / first `sret` leaves `sscratch = kstack_top` until next kernel entry; audit timer IRQ during GDB single-step.
3. **Re-test interactive** — `./spin`, `./hi`, `return0` from shell after `make clean && make`.
4. **Remove or narrow `status > 255` sanitize** once exit status is read from a reliable source (user trap frame only, not `kernel_trap_cxt`).
5. **Optional** — `proc_wait` should validate `ppid` when `parent_pid` is used.

---

## 8. Test commands

```bash
cd code/myos
make clean && make home          # build home/root/*.c ELFs
make AUTORUN=return0                  # non-interactive smoke
DEBUG=n ./sh/start_qemu.sh

# GDB (two terminals if connect times out)
make AUTORUN=return0 && ./sh/debug.sh
# (gdb) break proc_user_run
# (gdb) break *0x80380014          # user exit ecall (adjust addr after rebuild)
# (gdb) continue
```

---

## 9. Key symbols (move after each rebuild — use `nm out/os`)

| Symbol | Role |
|--------|------|
| `proc_user_run` | Saves caller + cont; `enter_uspace`; **`after_uspace`** tail |
| `after_uspace` / `run_saved_cont` | Resume PC after user returns |
| `proc_spawn_exec_wait` | `proc_user_run(child)` → `proc_wait` |
| `0x80380000` | User ELF entry (`return0` / `spin`) |
| `0x80380014` | `ecall` (SYS_exit) in bundled `return0` |

*Last updated: 2026-06-03 — exit return fix landed; AUTORUN status=0; GDB step-at-entry still open.*
