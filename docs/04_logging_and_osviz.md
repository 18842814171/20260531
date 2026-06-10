# Logging and OSViz

Structured kernel events, host capture tools, and how they relate to the Web UI. Kernel code lives under `code/myos/`; host package under `code/osviz/`.

---

## 1. Design constraint: one serial mux

```text
LOG_*  →  osviz_event()  →  printf()  →  UART  →  QEMU -serial stdio
shell  →  uart_putc()      →  printf()  →  UART  →  same byte stream
login  →  uart_puts()      →  …
panic  →  printf()         →  …
```

All guest-visible text shares **one** NS16550 / stdio link. There is no separate “log UART” in the current kernel. Separation happens on the **host** (Web demux or `serial_reader.py`), not inside `osviz_k.c`.

A future upgrade (post–acceptance) would use a ring buffer or second chardev; that is **not** the current design.

---

## 2. Kernel: macro-gated logging (my_sim style)

Header: `code/myos/include/osviz_k.h`  
Implementation: `code/myos/boot/osviz_k.c`

### Build switch

| Command | Preprocessor | Runtime effect |
|---------|--------------|----------------|
| `make` | `DEBUG=1`, `CONFIG_LOG=1` | `LOG_*` call `osviz_event()` |
| `make DEBUG=0` | `DEBUG=0`, `CONFIG_LOG=0` | All `LOG_*` expand to `((void)0)` |

### Macro reference

| Macro | Purpose |
|-------|---------|
| `LOG_INIT()` | Record boot time base (`osviz_init`) |
| `LOG_BOOT_BANNER()` | ASCII banner + `LOG_BOOT("banner", …)` |
| `LOG_EVENT(mod, ev, data)` | Generic event |
| `LOG_BOOT` / `LOG_TRAP` / `LOG_TRAP_DIAG` / `LOG_PMM` / `LOG_PROC` / `LOG_IRQ` | Module shortcuts |
| `LOG_SNAPSHOT()` | IRQ/proc aggregate JSON |
| `LOGIF(cond, mod, ev, data)` | Conditional event |

Call sites use macros (e.g. `LOG_PROC("fork", buf)` in `proc/syscall.c`), not raw `osviz_event()` except inside `osviz_k.c` and syscall dispatch.

### Wire format (UART line)

**Event** (prefix `LOG `):

```text
LOG {"ts_ms":123,"module":"trap","event":"enter","hart":0,"data":{"pid":2,"epc":"0x…"}}
```

**Snapshot** (prefix `LOG_SNAPSHOT `):

```text
LOG_SNAPSHOT {"boot":{…},"irq":{"timer_ticks":…,…}}
```

Fields:

| Field | Meaning |
|-------|---------|
| `ts_ms` | Milliseconds since `LOG_INIT` (CLINT/SBI time) |
| `module` | Subsystem tag |
| `event` | Event name within module |
| `hart` | `mhartid` |
| `data` | Optional JSON object (inline, not nested string) |

### Trap diagnostics

`interrupt/trap_diag.c` emits `LOG_TRAP` / `LOG_TRAP_DIAG` when `TRAP_DIAG_VERBOSE` is true (`DEBUG == 1`). Panic paths may still call `trap_diag_print_csrs` regardless; with `DEBUG=0` macros are silent.

### User / shell API

| API | Path |
|-----|------|
| Syscall `SYS_osviz_event` (1000) | `do_syscall` → `LOG_EVENT` |
| Syscall `SYS_osviz_snap` (1001) | `LOG_SNAPSHOT` |
| Shell `snapshot` | `LOG_SNAPSHOT()` in `usr/console.c` |

---

## 3. Host package: `code/osviz/`

### `src/log.c` — Linux userspace library

- Writes `{ts, module, event, pid, data}` lines to **`/var/log/osviz/events.jsonl`**
- Built by `make.sh` as `libosviz.a` + `osviz-record` for rootfs images
- **Independent** of kernel UART; same JSON shape, different transport

### `src/osviz-log.c`

CLI: `osviz-record <module> <event> [json_data]`

### `bridge/serial_reader.py`

Used when QEMU stdout is **piped** (non-interactive `start_qemu.sh`, `DEBUG=y`):

```text
QEMU serial
    ├─→ host stdout (full stream, for typing when --run PTY mode)
    └─→ events/events.jsonl (LOG lines only)
         └─→ events/recent.json (last 10, auto)
```

Web backend sets `DEBUG=n` and does **not** use this pipe; see [05_web_frontend.md](05_web_frontend.md).

### `events/`

Runtime capture directory when using `serial_reader.py`. See `events/README.md`.

---

## 4. Three consumption paths (comparison)

| Path | When | LOG destination | Shell text |
|------|------|-----------------|------------|
| **Raw QEMU TTY** | `./sh/start_qemu.sh` foreground | Mixed in terminal | Same terminal |
| **serial_reader.py** | Piped QEMU / offline | `events.jsonl` | stdout |
| **Web `server.py`** | Browser session | WebSocket `type=event` | WebSocket `type=output` |

---

## 5. Operational notes

| Practice | Rationale |
|----------|-----------|
| `make DEBUG=0` for quiet serial benchmarks | Zero `LOG_*` overhead at call sites |
| Do not expect file logs from Web alone | Demux does not write `events.jsonl` yet (planned P2) |
| Parse only **complete lines** starting with `LOG ` | Avoid JSON split across reads |
| Boot `printf` (e.g. `HEAP_START`) is **not** LOG | Still appears in Web terminal `output` |

---

## 6. Related documents

| Document | Contents |
|----------|----------|
| [01_architecture.md](01_architecture.md) | §7–§8 system diagrams |
| [02_call_chains.md](02_call_chains.md) | §10–§12 log and Web chains |
| [05_web_frontend.md](05_web_frontend.md) | SerialDemux and UI |
| [PROBLEMS_AND_SOLUTIONS.md](PROBLEMS_AND_SOLUTIONS.md) | §12 Web demux / terminal gate |

---

*Kernel logging is compile-time gated via `DEBUG`; host file logging is optional and separate from the Web path.*
