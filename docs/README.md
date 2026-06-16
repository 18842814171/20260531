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
| [05_web_frontend.md](05_web_frontend.md) | LibertyOS Web UI, channel demux, terminal/raw input, event panel |

---

## Operator quick start

### Build kernel

```bash
cd code/myos
make              # DEBUG=1 — LOG_* + boot/proc printf traces
make DEBUG=0      # no LOG_*; no boot_printf / proc_printf
make AUTORUN=test DEBUG=0   # batch kernel: quiet console + no LOG
make AUTORUN=ipc_echo       # single-program smoke (optional)
```

**Important:** shell `DEBUG=y|n` in `start_qemu.sh` is **not** the same as `make DEBUG=0|1`.

| Variable / flag | Layer | Effect |
|-----------------|-------|--------|
| `make DEBUG=1` | Kernel compile | `LOG {...}` JSON; `boot_printf` / `proc_printf` on |
| `make DEBUG=0` | Kernel compile | All `LOG_*` no-ops; boot/proc traces off |
| `make AUTORUN=…` | Kernel compile | Also disables `boot_printf` / `proc_printf` (batch/smoke) |
| `DEBUG=n ./sh/start_qemu.sh` | Host script | QEMU stdout → terminal (keyboard works); **Web default** |
| `DEBUG=y ./sh/start_qemu.sh` | Host script | Optional offline `events.jsonl` — not for Web bubbles |
| `MYOS_QUIET=1` | Host script | Suppress QEMU banner (`run_batch.sh` sets this) |

### Batch regression (guest)

Build once, run many times (`run_batch.sh` does **not** invoke `make`):

```bash
cd code/myos
make AUTORUN=test DEBUG=0
./sh/run_batch.sh
```

Reads `home/root/testcases.list` via `AUTORUN=test` → `test.c`; host judge: `tests/judge_batch.py`. See [03_module_index.md](03_module_index.md) § Batch testing.

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
| [log/0615debug.md](../log/0615debug.md) | 2026-06-15 — console/log split, Web demux, bg script poll |
| [log/0616.md](../log/0616.md) | 2026-06-16 — batch pipeline, boot/proc printf gates, event panel queue |
| [6.14.txt](../6.14.txt) | 2026-06-14 — Stage 3–4 completion notes (scheduler-only dispatch) |
| [6.16.txt](../6.16.txt) | 2026-06-16 — system status and task.md alignment |

---

*Last aligned with: batch testing, boot/proc console gates, event panel queue, PMM quiet (2026-06-16).*
