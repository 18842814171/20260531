# myos / LibertyOS — Documentation Index

Technical reference for the RISC-V kernel (`code/myos/`), host observability (`code/osviz/`), and the Web UI (`code/web/`). Paths are relative to the repository root unless noted.

---

## Core kernel

| Document | Contents |
|----------|----------|
| [01_architecture.md](01_architecture.md) | Boot order, layers, Sv39, UART IRQ + ring, `proc_sched`, sem/IPC, Web serial flow |
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

### Web backend

```bash
cd code/web && ./start_server.sh
# Browser → nginx :3333 or Flask :5000 (see 05_web_frontend.md)
```

See [使用方法.md](../使用方法.md) for a concise Chinese operator sheet.

---

## Demo programs (user)

| Program | Purpose |
|---------|---------|
| `./hi` | Minimal write + exit |
| `./ipc_echo` | UART → producer → sem → shared buffer → consumer → echo |
| `./yield_demo` | `SYS_yield` smoke test |
| `make AUTORUN=ipc_echo` | Auto-run `./ipc_echo` at boot |

User sources: `code/myos/home/root/`. Rebuild user ELFs and kernel after edits (`make clean && make`).

---

## Related paths outside `docs/`

| Path | Role |
|------|------|
| [使用方法.md](../使用方法.md) | Local commands (Chinese) |
| [code/myos/README.md](../code/myos/README.md) | Kernel tree quick reference |
| `log/*.md` | Session debug notes (not canonical spec) |
| `重要现场演示项目.txt` | Demo checklist (Chinese) |

---

## Related documents

| Document | Contents |
|----------|----------|
| [01_architecture.md](01_architecture.md) | System structure and data flows |
| [PROBLEMS_AND_SOLUTIONS.md](PROBLEMS_AND_SOLUTIONS.md) | Known issues and resolutions |

---

*Last aligned with: Sv39, UART RX IRQ + ring, `proc_sched` block/wakeup + `proc_user_run_dispatch`, sem/IPC shm, Web serial demux.*
