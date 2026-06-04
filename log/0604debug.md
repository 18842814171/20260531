# 0604 — myos U-mode debug session summary

Session focus: fix `return0` illegal-instruction and `./hi` missing output; complete `06.txt` logging/script cleanup. Reference notes: [log/0604_ref_usermode.md](0604_ref_usermode.md). Prior session: [log/0603debug.md](0603debug.md).

---

## 1. Conversation arc

| Phase | Goal | Outcome |
|-------|------|---------|
| T2025 / ArceOS compare | Map U-mode path vs myos (`exec`, trap return, ELF load) | Table in `0604_ref_usermode.md` |
| `AUTORUN=return0` illegal insn | `scause=2`, `sepc=0x80380002`, bad bytes at `0x80380000` | **Fixed** — bad embed + boot stack smash (§3) |
| Ramfs / ELF chain | GDB seed chain, `file_buf` vs `nodes[]` | Verified `7f 45 4c 46` @ +0, `37810000` @ +0x1000 |
| `./hi` no output | Write + exit syscalls trap; no `hi from ./hi` | **Fixed** — syscall args clobbered before `reg_save` (§4) |
| `06.txt` item 1 | LOG JSON for trap/diag lines | **Done** — `osviz_event` in `trap_diag.c` / `trap.c` (§5) |
| `06.txt` item 2 | One `debug.sh`, one `start_qemu.sh` | **Done** — removed 8 extra gdb scripts (§6) |

---

## 2. `./return0` illegal instruction (fixed)

### Symptom

```
AUTORUN=return0
scause=2  sepc=0x80380002  stval=0x8020
RAM @ 0x80380000: 0x8020fe72  (not 0x00008137 lui)
file_buf+0x1000 after fs_read: 72 fe 20 80  (not 37 81 00 00)
```

Expected first insn at `0x80380000`: `00008137` (`lui sp, 0x8`).

### Root causes (two)

| # | Cause | Fix |
|---|-------|-----|
| 1 | **Bad embedded ELF bytes** — GCC `.base64` + `.zero` padding in `home_data.c` placed symbol **4096 B before** payload; `fs_seed_file` copied wrong region | `tools/pack_home.py` → `fs/home_embed.S` (`.incbin`); slim `fs/home_data.c`; link embed in `.text` via `ld/os.ld` |
| 2 | **Boot stack smash** — OpenSBI path used `sp = 0x80210000`; stack grew into `.rodata`/BSS and corrupted `nodes[]` during `fs_load_home()` | `boot/start.S`: `sp = 0x87FF0000` (below 128M RAM end) |

### Verification

- GDB: `source+0` = ELF magic; `source+0x1000` = `37 81 00 00`; `nodes[9].data+0x1000` matches.
- `make AUTORUN=return0` → **`autorun: done status=0`** (consistent after stack fix).

### Note on PT_LOAD addressing

Single segment: file offset `0x1000` → VA `0x80380000`. Do **not** read kernel file at `VA - 0x80200000`; use `file_off = 0x1000 + (VA - 0x80380000)`.

---

## 3. `./hi` missing output (fixed)

### Symptom

Interactive and AUTORUN:

```
./hi
trap: pid=3 … epc=0x8038004a … code=8    # SYS_write
trap: pid=3 … epc=0x80380014 … code=8    # SYS_exit
LOG … "event":"exit" … "from":"user"
# no "hi from ./hi"
```

Program reached write and exit syscalls; traps were not panics.

### GDB at write ecall (`trap_handler`, `sepc=0x8038004a`)

Trap frame **after** `reg_save` (broken):

```
a0(fd)=garbage / 0     a1(buf)=0xa     a2(len)=garbage     a7=64
pc slot=0x8038004a     ✓
```

Expected: `a0=1`, `a1=0x80380080`, `a2=13`, `a7=64`.

Embedded hi and on-disk ELF were correct (`hi from ./hi\n` @ file offset `0x1080`). Failure was **kernel-side**, not ramfs content.

### Root cause

On user trap, **`a0`–`a7` were clobbered before `reg_save`**:

1. **`trap_diag_trap_pre()`** — C call at `trap_vector` **before** `csrrw` stack swap when `sscratch != 0` was skipped for user… but originally ran for kernel-only; for user path the issue was:
2. **`trap_get_user_frame()`** — C call in `.Ltrap_user` **before** `reg_save`; RISC-V ABI clobbers `a0`–`a7` (syscall args).
3. Earlier: **`trap_diag_trap_pre()`** also ran when `sscratch==0` only after our fix; user traps skip it because `sscratch != 0` at entry.

`a7` sometimes still showed `64` by luck; `a0`/`a1`/`a2` were wrong → `sys_write` copied from `0xa` or wrote zero bytes.

### Fix (`interrupt/entry.S`)

1. **Skip `trap_diag_trap_pre`** when `sscratch != 0` (user trap incoming — do not call C before saving regs).
2. **Remove `trap_get_user_frame` call** before `reg_save`; compute user context in asm:
   - `user_ctx = kstack_top - PROC_KSTACK_TOP_TO_UCTX` (`0x1120`)
3. **`reg_save` immediately** after frame pointer is known.

`PROC_KSTACK_TOP_TO_UCTX` in `include/proc.h`; `_Static_assert` in `proc/proc.c` guards `procs[]` layout.

### Verification

```
autorun: ./hi
hi from ./hi
autorun: done status=0
```

GDB at write ecall (fixed): `a0=1`, `a1=0x80380080`, `a2=13`, `a7=64`.

---

## 4. Changes made (by file)

### 4.1 Embed / ramfs (return0)

| File | Change |
|------|--------|
| `tools/pack_home.py` | Emit `fs/home_embed.S` with `.incbin` for ELFs with `\0` |
| `fs/home_data.c` | `extern` symbols only; seed from embed |
| `fs/home_embed.S` | Generated `.incbin` blobs |
| `ld/os.ld` | Merge `.rodata.home_embed` into `.text` for reliable load |
| `boot/start.S` | Boot `sp = 0x87FF0000` |
| `Makefile` | Link `out/fs/home_embed` |

### 4.2 User trap / syscalls (./hi)

| File | Change |
|------|--------|
| `interrupt/entry.S` | User trap: skip pre-swap C diag; asm `user_ctx` ptr; early `reg_save` |
| `include/proc.h` | `PROC_KSTACK_TOP_TO_UCTX` |
| `proc/proc.c` | `_Static_assert` on offset |

### 4.3 LOG format + script cleanup (06.txt)

| File | Change |
|------|--------|
| `interrupt/trap_diag.c` | All verbose trap/diag → `osviz_event()` (`module`: `trap`, `trap-diag`) |
| `interrupt/trap.c` | `trap leave` / nested enter → `osviz_event`; removed duplicate `trap_diag_post_handler` (was logged twice) |
| `sh/debug.sh` | Optional `-x script.gdb`; kept as sole debug launcher |
| `sh/gdbinit` | Generic symbol breakpoints (no hardcoded test names) |
| **Removed** | `gdb_hi_write.*`, `gdb_fs_chain.*`, `gdb_seed_return0.*`, `gdb_list_nodes.*` |

---

## 5. Log output format (06.txt item 1)

**Before:** plain `trap:`, `[trap-diag]`, `trap leave depth=1` mixed with program stdout.

**After:**

```
LOG {"ts_ms":13,"module":"trap","event":"enter","hart":0,"data":{"pid":2,"mode":"user","epc":"0x8038004a",...}}
hi from ./hi
LOG {"ts_ms":15,"module":"trap","event":"leave","hart":0,"data":{"depth":1,"return_pc":"0x8038004e",...}}
LOG {"ts_ms":15,"module":"trap-diag","event":"leave_handler","hart":0,"data":{"ret_sepc":"0x8038004e",...}}
LOG {"ts_ms":16,"module":"trap-diag","event":"return","hart":0,"data":{"sepc":"0x8038004e","restore_frame":"user_proc",...}}
LOG {"ts_ms":16,"module":"trap","event":"enter",...,"epc":"0x80380014",...}
LOG {"ts_ms":17,"module":"proc","event":"exit","hart":0,"data":{"from":"user"}}
LOG {"ts_ms":17,"module":"trap","event":"leave",...,"return_pc":"0x80204a70",...}
autorun: done status=0
```

Program output (`hi from ./hi`) stays **unwrapped** on UART. Trap noise is **`LOG` JSON** only when `CONFIG_LOG=1` (`make` default; `make DEBUG=0` silences).

Event names:

| Event | Module | Replaces |
|-------|--------|----------|
| `enter` | `trap` | `trap: pid=…` (incl. `phase:pre_swap` when logged) |
| `leave` | `trap` | `trap leave depth=1 …` |
| `enter_nested` | `trap` | `trap enter depth=N …` |
| `leave_handler` | `trap-diag` | `[trap-diag] LEAVE …` |
| `return` | `trap-diag` | `[trap-diag] RETURN …` |

---

## 6. Scripts (06.txt item 2)

`code/myos/sh/` now:

| Script | Role |
|--------|------|
| `start_qemu.sh` | Run QEMU (interactive or piped to osviz) |
| `debug.sh` | QEMU `-S` + GDB; `./sh/debug.sh [kernel] [-x extra.gdb]` |
| `gdbinit` | Default GDB init (included by `debug.sh`) |

---

## 7. T2025 vs myos (trap path — still valid)

| Question | T2025 | myos |
|----------|-------|------|
| `sepc` | ELF entry | `eh->e_entry` → `uc->pc` |
| User `sp` | ~`0x4_0000_0000` region | `0x80390000` |
| `satp` | Switched in task switch | Flat map, no user PTEs |
| Regs before `sret` | Full TrapFrame + `sstatus` | `reg_restore`; SPP/SPIE/SIE only |
| Trap frame | GPRs, `sepc`@31, `sstatus`@32 | Same GPR order, `pc`@31, no `sstatus` |

Illegal-instruction for `return0` was **not** a trap-return bug; it was **bad seeded ELF + stack corruption during seed**. Missing `./hi` output was **not** ramfs; it was **register save order on user ecall**.

---

## 8. Current runtime status

| Test | Status |
|------|--------|
| `make AUTORUN=return0` | **Pass** — `autorun: done status=0` |
| `make AUTORUN=hi` | **Pass** — prints `hi from ./hi`, status 0 |
| Interactive `./hi` from shell | **Pass** after rebuild (same kernel fix) |
| GDB user entry single-step | Still fragile (see 0603debug §5.2); prefer `break` on `ecall` / `do_syscall` |

---

## 9. Test commands

```bash
cd code/myos
make userprogs && make              # interactive shell
make AUTORUN=return0 && DEBUG=n ./sh/start_qemu.sh
make AUTORUN=hi && DEBUG=n ./sh/start_qemu.sh

# GDB
make AUTORUN=hi && ./sh/debug.sh
# (gdb) break trap_handler if $a0 == 0x8038004a
# (gdb) break do_syscall
# (gdb) continue
```

**Rebuild note:** `make AUTORUN=…` only recompiles `boot/kernel.c` when `out/boot/kernel` is missing or stale. After changing `AUTORUN`, run `rm -f out/boot/kernel && make AUTORUN=hi`.

---

## 10. Key symbols (re-verify after rebuild: `nm out/os`)

| Symbol / VA | Role |
|-------------|------|
| `0x80380000` | User ELF entry (`return0`, `hi`) |
| `0x8038004a` | `ecall` in `hi` `write()` |
| `0x80380080` | `hi` rodata string |
| `0x80380014` | `ecall` SYS_exit in bundled ELFs |
| `PROC_KSTACK_TOP_TO_UCTX` (`0x1120`) | `user_ctx` below kstack top |
| `proc_load_elf` | PT_LOAD copy + `fence.i` |
| `do_syscall` / `sys_write` | Syscall dispatch / stdout |

---

## 11. Open / optional follow-ups

1. **Makefile** — Rebuild `out/boot/kernel` when `AUTORUN=` changes (dependency on `DEFS`).
2. **User `gp` in trap frame** — `trap_vector` reloads kernel `gp` before `reg_save`; user `gp` slot may hold kernel value (OK for current tiny ELFs with `gp=0`).
3. **GDB at `0x80380000`** — Use `x/4wx 0x80380000`; avoid trusting `ni` disassembly until bytes verified.
4. **`0604_ref_usermode.md`** — Update if trap entry path description still mentions `trap_get_user_frame` before save.

*Last updated: 2026-06-04 — return0 + hi fixed; 06.txt LOG format and script cleanup done.*
