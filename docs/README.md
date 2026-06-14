## Core kernel

| Document | Contents |
|----------|----------|
| [01_architecture.md](01_architecture.md) | Boot order, layers, Sv39, UART IRQ + ring, xv6-style `proc_kctx` / `proc_sched`, sem/IPC, Web serial flow |
| [02_call_chains.md](02_call_chains.md) | Call trees: trap, syscall, exec, fork/wait, block/wakeup, IPC |
| [03_module_index.md](03_module_index.md) | Per-module entry / core / exit functions |
| [PROBLEMS_AND_SOLUTIONS.md](PROBLEMS_AND_SOLUTIONS.md) | Historical defects, root causes, and fixes |

---

## Observability and Web

| Document | Contents |
|----------|----------|
| [04_logging_and_osviz.md](04_logging_and_osviz.md) | Kernel `LOG_*` macros, UART JSON lines, host capture, WebSocket demux |
| [05_web_frontend.md](05_web_frontend.md) | LibertyOS Web UI, `server.py`, terminal gate, event bubbles |

---

## Operator quick start

### Build kernel

```bash
cd code/myos
make              # DEBUG=1, CONFIG_LOG=1 — kernel LOG_* on serial
make DEBUG=0      # compile-time logging off (quieter serial)
make AUTORUN=ipc_echo   # non-interactive smoke test (optional)
```

**Important:** shell `DEBUG=y|n` in `start_qemu.sh` is **not** the same as `make DEBUG=0|1`.

| Variable / flag | Layer | Effect |
|-----------------|-------|--------|
| `make DEBUG=1` | Kernel compile | `LOG {...}` JSON on UART |
| `make DEBUG=0` | Kernel compile | All `LOG_*` are no-ops |
| `DEBUG=n ./sh/start_qemu.sh` | Host script | QEMU stdout → your terminal (keyboard works) |
| `DEBUG=y ./sh/start_qemu.sh` | Host script | Pipe to osviz capture — **do not type into guest** |

### Run QEMU (interactive)

```bash
cd code/myos
make DEBUG=0
DEBUG=n ./sh/start_qemu.sh
```

Login `root`, then e.g. `./ipc_echo` — type text and Enter; `q` quits producer.

**Scheduling (2026-06-14):** User-process dispatch now uses xv6-style context switching (Stages 1–4 complete). See [01_architecture.md](01_architecture.md) §6 and [log/0614debug.md](../log/0614debug.md).

### Web backend

```bash
cd code/web && ./start_server.sh
# Browser → nginx :3333 or Flask :5000 (see 05_web_frontend.md)
```

See [使用方法.md](../使用方法.md) for a concise Chinese operator sheet.

---

## Development logs

| Log | Contents |
|-----|----------|
| [log/0613.md](../log/0613.md) | 2026-06-13 — xv6-style `proc_kctx` Stage 1–2, shell `kctx_asleep` fix |
| [log/0614debug.md](../log/0614debug.md) | 2026-06-14 — Stage 3–4 收尾、文档同步、原则 9 检查 |
| [6.14.txt](../6.14.txt) | 2026-06-14 — Stage 3–4 completion notes (scheduler-only dispatch) |

---

*Last aligned with: xv6-style scheduler (Stages 1–4), `proc_user_first_run` + `proc_user_trap_return`, `proc_kctx_switch` dispatch/resume, TTY + AUTORUN `ipc_echo` verified (2026-06-14).*
