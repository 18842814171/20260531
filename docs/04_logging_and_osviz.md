# Logging and OSViz

**Scope:** Structured kernel events, host capture tools, and Web UI consumption. Kernel code under `code/myos/`; host package under `code/osviz/`.

---

## 1. Design constraint: one serial mux

Kernel output uses two APIs (`include/console_io.h`, `boot/console_io.c`):

| API | Typical callers | Current sink |
|-----|-----------------|--------------|
| `console_write` / `console_puts` | Shell, `printf`, `sys_write(1/2)`, UART echo | UART |
| `log_write` / `log_puts` | `osviz_event`, `osviz_snapshot` | UART (same wire) |

Both still share **one** NS16550 / stdio link. The host (Web demux or `serial_reader.py`) separates streams by line prefix and optional `channel` field — not by a second UART in the guest.

Planned later: redirect `log_write` only to a host pipe, socket, file, or second chardev; callers stay unchanged.

```text
console_*  →  UART  →  host  →  terminal pane   (channel: console)
log_*      →  UART  →  host  →  event bubbles   (channel: log)
```

A future in-guest ring buffer or second chardev is **not** implemented yet.

---

## 2. Kernel: macro-gated logging (my_sim style)

Header: `code/myos/include/osviz_k.h`  
Implementation: `code/myos/boot/osviz_k.c` (events via `log_puts`)

### Build switches (`config.h`)

| Command | `LOG_*` | `boot_printf` | `proc_printf` |
|---------|---------|---------------|---------------|
| `make` | on | on | on |
| `make DEBUG=0` | off | off | off |
| `make AUTORUN=…` | follows DEBUG | off | off |

**Note:** `#define DEBUG` inside a user program (e.g. `test.c`) does **not** affect kernel macros — guest and kernel are separate builds.

Human boot traces (`HEAP_START`, `trap_init`, …) use **`boot_printf`**. Process dispatch traces (`ENTER proc_user_first_run`, `[exit]`, …) use **`proc_printf`**. Both are independent of `LOG_*`.

### Macro reference

| Macro | Purpose |
|-------|---------|
| `LOG_INIT()` | Record boot time base (`osviz_init`) |
| `LOG_BOOT_BANNER()` | ASCII banner + `LOG_BOOT("banner", …)` |
| `LOG_EVENT(mod, ev, data)` | Generic event |
| `LOG_BOOT` / `LOG_TRAP` / `LOG_TRAP_DIAG` / `LOG_PMM` / `LOG_PROC` / `LOG_SCHED` / `LOG_SEM` / `LOG_IRQ` | Module shortcuts |
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

### PMM event policy (2026-06-16)

| Event | Kernel `LOG_PMM` | Web event panel |
|-------|------------------|-----------------|
| `pmm/init` | yes | hidden (`QUIET_MODULES`) |
| `pmm/alloc_fail` | yes | hidden |
| per alloc/free | **removed** | — |

---

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
| **Web `server.py`** | Browser session | WebSocket `channel:log` | WebSocket `channel:console` |

---

## 5. Operational notes

| Practice | Rationale |
|----------|-----------|
| `make DEBUG=0` for quiet serial benchmarks | Zero `LOG_*` and boot/proc printf overhead |
| `make AUTORUN=test DEBUG=0` for batch | Quiet console + no LOG; see `sh/run_batch.sh` |
| Do not expect file logs from Web alone | Demux does not write `events.jsonl` yet (planned P2) |
| Parse only **complete** `LOG` / `LOG_SNAPSHOT` lines | Avoid split JSON on the wire |
| Interleaved bytes (`cLOG {…}`) | Host demux scans for markers mid-stream, not only line start |
| Boot `HEAP_START` etc. use `boot_printf`, not LOG | Suppressed when `DEBUG=0` or `AUTORUN`; otherwise in Web terminal |
| `LOG_SCHED` with `"via":"kctx"` | Fresh dispatch or resume after `proc_kctx_switch` |

---

## Related documents

| Document | Contents |
|----------|----------|
| [01_architecture.md](01_architecture.md) | §10 observability summary |
| [02_call_chains.md](02_call_chains.md) | §11 log and Web chains |
| [05_web_frontend.md](05_web_frontend.md) | SerialDemux and UI |
| [PROBLEMS_AND_SOLUTIONS.md](PROBLEMS_AND_SOLUTIONS.md) | §11 Web demux / terminal gate |
| [log/0613.md](../log/0613.md) | Stage 1–2 scheduling migration log |
| [log/0616.md](../log/0616.md) | Batch pipeline, console gates, PMM quiet |

---

*Last aligned with: boot/proc printf gates, batch testing, PMM quiet, Web channel demux (2026-06-16).*
