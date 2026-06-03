# myos debug log — 2026-06-02 (updated)

Status document for trap, UART, shell, timer layout, and user-program bring-up.  
Related: `0602_ref_trap_uart_summary.md`, `0602plan.md`, `01.txt`, `priority.txt`, `重要原则.txt` §7.

---

## 1. Current status (from terminal, latest runs)

### 1.1 Boot / P0 GP fix — OK

```text
trap_init: kernel_gp=0x0000000080210800   # non-zero after start.S la gp, __global_pointer$
```

`start.S` sets `gp` with `.option norelax`; `ld/os.ld` provides `__global_pointer$`; `trap_init()` panics if `kernel_gp_value == 0`.

### 1.2 BSS layout (P2/P3) — separated

Boot prints (formatting interleaved with LOG — see §7):

```text
timer_list=0x802104c0 ...
timer_guard=0x802105b0..0x802106b0
kernel_trap_cxt=0x802106b0 ...
```

Previously `timer_list` ended exactly at `kernel_trap_cxt` (240 B abutting 256 B frame). **256 B `timer_guard`** added in `interrupt/timer.c`; no overlap in `nm` output.

### 1.3 Shell / ramfs — OK (after guard build)

| Command | Result |
|---------|--------|
| `pwd` | `/home/root` — no `depth=2` / rodata panic |
| `ls` | Lists `/home/root` |
| `cat hello.txt` | Prints file |
| `sh hello.sh` | Script runs to completion |
| `poweroff` | Clean shutdown |

Earlier runs **without** guard (or before rebuild) still showed:

```text
pwd → trap enter depth=2 epc=0x80207c72 (.rodata "status":"ok")
      stval=0xc0, gp=0x8020f800, ra=.text (timer_check after jalr)
      panic: return_pc in rodata
```

**Conclusion:** rodata `pwd` crash strongly correlated with **`timer_list` / `kernel_trap_cxt` adjacency**; **padding + GP fix** clears shell P1 tests. No `timer[N] func=0x80207c72` or `bad timer callback` seen — slots stayed NULL; failure mode was likely frame stomp, not a live bad callback pointer.

### 1.4 User vs kernel paths — split (per `01.txt`)

| Command | Result |
|---------|--------|
| `spawn worker` | **OK** — `spawned worker`, `ps` shows PID 2 `worker` |
| `./hi` | **Hangs** — one `trap leave depth=1` at `0x80201254`, no user output, then QEMU killed (Ctrl+C) |
| `./spin` | **Hangs** — same pattern |

So the active problem is **no longer timer/shell rodata** on the tested shell commands; it is **S-mode ↔ U-mode** (exec → `sret` → user ELF), while **kernel worker thread** path works.

Background noise on every command: `trap leave depth=1 return_pc=0x80201254` (timer IRQ, cause `0x800…0005`). Normal at 100 Hz while console polls.

---

## 2. Root-cause timeline (condensed)

```text
[Early] gp=0 at trap_init → gp-relative timer/shell UB; stval=0xc0; hidden timer_check jalr
[GP fix] kernel_gp=0x8020f800 → real timer_list access; rodata PC if frame stomps timer_list
[Guard] timer_guard[256] → pwd/ls/cat/sh stable
[Now]  ./hi / ./spin → user entry or user trap path (xv6 trampoline / SPP / sepc / sp)
```

| Hypothesis | Status |
|------------|--------|
| Nested timer fast path sole cause | **Rejected** (A/B same symptom; guard fixed shell without removing fast path) |
| Bad `ra` → ret into rodata | **Rejected** (`ra` in `.text` at fault) |
| `gp=0` | **Fixed** at boot; fault frame showed valid `gp` after fix |
| `timer_list` → `kernel_trap_cxt` overlap | **Likely** — padding fixed shell |
| `timer_check` callback → rodata | **Not observed** (no bad `func` log); `jalr` theory secondary |

---

## 3. Architecture (unchanged — `重要原则` + plan)

### 3.1 Console (§7 single I/O path — `重要原则.txt` §7 spirit)

- **MMIO UART poll-only** for shell; SBI for timer/shutdown only.
- No mixed poll + IRQ stdin on shell path (Phase 2 `uart_irq.c` still deferred).
- **Principle §7:** new debug should go through **LOG**, not ad-hoc `printf` spam (current session added many `printf`s — migrate or gate; see §8).

### 3.2 Phased UART

| Phase | State |
|-------|--------|
| 1 | Done — poll-only `uart.c` |
| 2 | Not started — `uart_irq.c` lab |
| 3 | Optional — one stdin model only |

---

## 4. Fixes landed in tree

| Area | Change |
|------|--------|
| **P0 GP** | `start.S`: `la gp, __global_pointer$`; `ld/os.ld`: `PROVIDE(__global_pointer$)`; `trap_init` log + panic if 0 |
| **P1 timer** | `timer_check`: log `func`/`arg`, `.text` check, `panic("bad timer callback")` |
| **P2 layout** | `timer_init` prints `timer_list` / `timer_guard` / `kernel_trap_cxt` |
| **P3 guard** | `char timer_guard[256]` between `timer_list` and `kernel_trap_cxt` |
| **Trap** | `trap_reenable_irq` user-only; `shell_irq_save`; nested timer fast path; `trap_check_return_pc` / fault frame on sync |
| **UART** | Phase 1 poll-only; `uart_irq_save` around poll |
| **Diag** | `TRAP_GP_DIAG`, `TRAP_NO_NESTED_FAST` via Makefile |

---

## 5. Next work (`01.txt` — user programs)

Do **not** prioritize more timer/PLIC patches until user path is understood.

Reference: **xv6-riscv** `trampoline.S`, `trap.c`, `proc.c` — `uservec` / `usertrap` / `usertrapret`, **SPP clear before `sret`**.

| Step | Action |
|------|--------|
| 1 | Confirm ELF **entry** for `hi` (`nm hi` / loader log) |
| 2 | `[exec] entry=%lx sp=%lx` before first user run |
| 3 | `[user-enter] sepc=%lx sstatus=%lx` — **SPP=0** for U-mode `sret` |
| 4 | `[user-trap] epc= cause=` on first user fault (if any) |

Checklist from `01.txt`:

- `sstatus.SPP` cleared before user `sret` (`entry.S` `switch_to` already has `csrc SPP` under `CONFIG_OPENSBI` — verify on **exec** path too).
- `sepc` = ELF entry (e.g. `0x80380000` region).
- User `sp` = `USER_STACK_TOP` / per-process stack in `uctx`.
- If no `[user-trap]` at all → may never enter U-mode.

**Defer:** per-task trap frame (P4 in `priority.txt`) until exec/sret chain is verified.

---

## 6. Trap / diagnostic cheat sheet

```text
trap_vector
  ├─ [optional] trap_diag_trap_vector_entry (CONFIG_TRAP_GP_DIAG)
  ├─ [busy + timer] → trap_nested_timer_ack → TRAP_RET
  └─ reg_save → trap_handler → csrw sepc, a0 → reg_restore → TRAP_RET

timer_handler → timer_check (validate func ∈ .text)
```

Sync fault: `trap_diag_print_fault_frame` then `trap_check_return_pc` (may panic `return_pc in rodata` before `OOPS`).

---

## 7. Test procedure

```bash
cd code/myos && make clean && make
DEBUG=n ./sh/start_qemu.sh
```

**P1 (shell)** — expect pass:

- `pwd`, `ls`, `cat hello.txt`, idle 1–2 min — no `depth=2` rodata

**P2 (user)** — current failures:

- `./hi`, `./spin` — hang; capture `[exec]` / `[user-enter]` / `[user-trap]` once added

**P3 (kernel thread)** — expect pass:

- `spawn worker`, `ps`

Optional: `make TRAP_GP_DIAG=1`, `make TRAP_NO_NESTED_FAST=1` for A/B.

---

## 8. LOG vs printf (`重要原则.txt` §7)

> 所有调试语句涉及项目都加入 osviz 记录内容

Current debug (`trap leave`, `timer_list=`, `timer[%d] func=`, `[gp] pwd`, fault frame `printf`) **violates** §7. Plan:

- Gate verbose trap/timer logs behind `#ifdef` (e.g. `CONFIG_TRAP_DEBUG`) default **off**.
- Emit stable events via `osviz_event()` / `osviz_k.c` (e.g. `trap`, `timer_bad_callback`, `user_enter`, `user_trap`).
- Fix `timer_init` printf line broken by concurrent LOG JSON (use `\n` + single line or LOG only).

---

## 9. Open items

| Item | Priority |
|------|----------|
| `./hi` / `./spin` U-mode entry | **P0** (`01.txt`) |
| `[exec]` / `[user-enter]` / `[user-trap]` logs | P0 |
| Migrate debug prints → LOG (§7) | P1 |
| Reduce always-on `trap leave depth=1` noise | P2 |
| Trap frame offset audit (`struct context` vs `reg_save`) | P2 (`priority.txt`) |
| Phase 2 UART IRQ lab | P5 |
| Per-task trap frame | After user path stable |

---

## 10. File index

| Topic | Path |
|-------|------|
| Boot GP | `boot/start.S`, `ld/os.ld` |
| Trap | `interrupt/entry.S`, `interrupt/trap.c` |
| Timer + guard | `interrupt/timer.c` |
| User proc | `proc/proc_user.c` |
| Console | `usr/console.c` |
| LOG | `boot/osviz_k.c` |
| Principles | `重要原则.txt` §7 |
| Next focus | `01.txt` |

---

## 11. One-line summary

**GP init + `timer_guard` fixed shell/rodata crashes; shell and kernel worker are OK; `./hi` / `./spin` hang on the user exec/sret path — next: xv6-style S/U checks and LOG-backed user-trap diagnostics per `01.txt`, while moving ad-hoc `printf` debug under §7.**
