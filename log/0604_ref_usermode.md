## T2025 (ArceOS / Undefined-OS) vs myos — U-mode path

T202510003995291-2331 does **not** use xv6 names (`exec`, `usertrapret`, `trampoline.S`, `initcode`). The mapping is:

| xv6-style | T2025 (ArceOS) | myos |
|-----------|----------------|------|
| `exec()` | `load_user_app()` in `core/src/mm.rs` | `proc_load_elf()` in `proc/proc_user.c` |
| `usertrapret()` | `RESTORE_REGS 1` in `trap.S` after `riscv_trap_handler` | `reg_restore` + `trap_return_to_user` path in `entry.S` |
| `uservec` / `userret` | `trap_vector_base` + `SAVE_REGS` / `RESTORE_REGS` | `trap_vector` + `enter_uspace` |
| `initcode` | `run_user_app()` → `UspaceContext::new()` → `create_user_task` | `debug_autorun` → `proc_spawn_exec_wait("return0")` |

---

## Comparison answers (your five questions)

### 1. What goes into `sepc`?

| | Value |
|---|--------|
| **T2025** | ELF entry (`map_elf` → `entry`; stored in `TrapFrame.sepc`) |
| **myos** | `eh->e_entry` → `uc->pc` → `csrw sepc` in `enter_uspace` |

For `return0`: **`0x80380000`** in both (myos linker script / ELF).

### 2. What goes into user `sp`?

| | Value |
|---|--------|
| **T2025** | `USER_STACK_TOP - stack_data.len()` (typically ~`0x4_0000_0000` minus argc/argv/env/auxv), 16-byte aligned |
| **myos** | **`0x80390000`** (`USER_STACK_TOP` in `proc_load_elf`; also what `_start` sets via `lui`/`addiw`/`slli`) |

Note: myos sets `sp` in the context **before** `sret`; the guest `_start` immediately resets it again.

### 3. When is `satp` switched?

| | When |
|---|------|
| **T2025** | In `TaskContext::switch_to()` when `self.satp != next_ctx.satp` — **before** the task runs, not in the trap-return stub. User PTEs are already active when `enter_uspace`/`sret` happens. |
| **myos** | **Never.** Flat kernel map; no user page tables. |

### 4. What registers are initialized before `sret`?

**T2025 `enter_uspace`:**
- `sscratch = kstack_top`
- `sepc = entry`
- Restore full `TrapFrame`: all GPRs, **`sstatus`** (SPIE=1, SUM=1, SPP=0 implicit)
- Swap kernel/user `gp`/`tp` via frame slots 2/3

**myos `enter_uspace`:**
- `sscratch = kstack_top` (before `reg_restore`)
- `sepc = uc->pc`
- `reg_restore`: all GPRs from `struct context` (zeroed except `pc`, `sp`)
- **`sstatus` not stored in frame** — only `clear SPP`, `set SPIE`, `clear SIE`

Missing vs reference: no **`sstatus.SUM`** in the frame (myos sets SUM once in `trap_init`), no **`sstatus` slot** at all.

### 5. Trap frame layout

**T2025 `TrapFrame`** (`context.rs` + `trap.S`):

```
[0..30]  GeneralRegisters (ra, sp, gp, tp, t0..t6, s0,s1, a0..a7, s2..s11)
[31]     sepc
[32]     sstatus
```

On user trap: frame built on **kernel stack** (`sp -= sizeof(TrapFrame)`).

**myos `struct context`** (`os.h` + `entry.S`):

```
[0..30]  ra, sp, gp, tp, t0..t6, s0,s1, a0..a7, s2..s11, t3..t5
[31]     pc  (→ sepc on return)
(no sstatus)
```

Per-process **`user_ctx`** in `proc.c`; user trap finds it via `trap_get_user_frame(kstack_top)`.

User trap entry saves user `sp` into slot 1 after `sscratch` swap; **`gp` in frame is often kernel `gp`** (kernel `gp` reloaded before `reg_save`).

---

## Illegal instruction at `0x80380002` — what we checked

### ELF program header (myos `return0`)

```
LOAD  off=0x1000  vaddr=0x80380000  filesz=0x2e  flags=R|E
e_entry = 0x80380000
```

Expected first instructions:

```text
80380000:  00008137   lui  sp, 0x8
80380004:  0391011b   addiw sp, sp, 57
80380008:  0142       slli sp, sp, 16
80380014:  00000073   ecall
```

Embedded blob in `home_data.c` and `home/root/return0` both have **`37 81 00 00`** at file offset `0x1000`.

### Memory at `0x80380000` at runtime (GDB + QEMU)

After `proc_load_elf` copy loop, **actual RAM**:

```text
0x80380000:  0x8020fe72   (not 0x00008137)
file_buf+0x1000:  72 fe 20 80   (not 37 81 00 00)
```

Live AUTORUN reproduces the fault:

```text
scause=2 (illegal instruction)
sepc=0x80380002
stval=0x8020
sp=0x80390000   ← context setup OK
```

**Mechanism:** word `0x8020fe72` → halfwords `0xf560` then **`0x8020`** → PC advances to `+2` → illegal insn, `stval=0x8020`. GDB’s `fe72`/`sd t3,312(sp)` is a mis-disassembly of garbage, not the real `lui`.

### User page-table translation for `0x80380000`

**N/A for myos today** — no `satp` switch, no user PTEs. VA `0x80380000` is direct physical RAM in the flat map (inside the heap reservation `[0x80333000, …)`). There is no separate “physical page behind a user mapping”; **`0x80380000` is the mapping**.

### Physical / flat contents behind that VA

Should be the 46-byte PT_LOAD segment starting with **`37 81 00 00 …`**.  
Actually present: **runtime garbage** (`0x8020fe72 …`), i.e. kernel-pointer-like bytes never present in the ELF on disk or in kernel rodata blobs.

`proc_load_elf` **does run** the copy loop (`ph[1].p_vaddr=0x80380000`, `p_filesz=0x2e`, `n=6840`), but it copies **from corrupted `file_buf`**, which already has wrong bytes at `+0x1000` after `fs_read_file` — even though the ELF **header** in `file_buf` is valid (`7f 45 4c 46`).

So the bug is **before / during ramfs read**, not in `enter_uspace` / `sepc` / `sscratch` setup:

| Layer | Status |
|-------|--------|
| ELF on disk / in `home_data.c` rodata | ✅ correct (`37810000` @ 0x1000) |
| `proc_load_elf` logic | ✅ reaches copy, sets `uc->pc`/`sp` |
| `file_buf` after `fs_read` @ 0x1000 | ❌ `72 fe 20 80` |
| RAM @ `0x80380000` after load | ❌ same garbage |
| U-mode entry (`sepc`, `sp`, `sscratch`) | ✅ values look right |
| First user instruction | ❌ illegal @ `0x80380002` |

---

## Practical next steps (ordered)

1. **At `fence.i` in `proc_load_elf`:** `x/4bx file_buf+0x1000` and `x/4wx 0x80380000` — confirm whether load or FS is wrong.
2. **Right after `fs_load_home`:** dump `nodes[i].data[0x1000]` for `/home/root/return0` — see if ramfs seed is already bad or corruption happens later.
3. **`make clean && make userprogs && python3 tools/pack_home.py && make AUTORUN=return0`** — keep `home_data.c` in sync with rebuilt ELFs.
4. **Do not trust GDB `ni` at `0x80380000`** until bytes verify as `37 81 00 00`; use `continue` to `0x80380014` (ecall).

The U-mode **return path** (`enter_uspace`, trap frame, `sscratch`) matches the reference in spirit; the current crash is an **ELF bytes not reaching `0x80380000`** problem, not a wrong `sepc` on first entry.