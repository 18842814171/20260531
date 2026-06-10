# myos / LibertyOS — Documentation Index

Technical reference for the RISC-V kernel (`code/myos/`), observability (`code/osviz/`), and the Web UI (`code/web/`). Paths are relative to the repository root unless noted.

---

## Core kernel

| Document | Contents |
|----------|----------|
| [01_architecture.md](01_architecture.md) | Boot order, layers, address spaces, end-to-end data paths (QEMU serial, Web) |
| [02_call_chains.md](02_call_chains.md) | Indented call trees: trap, syscall, exec, fork/wait, file I/O |
| [03_module_index.md](03_module_index.md) | Per-module entry / core / exit functions |
| [PROBLEMS_AND_SOLUTIONS.md](PROBLEMS_AND_SOLUTIONS.md) | Historical defects, root causes, and fixes |

---

## Observability and Web

| Document | Contents |
|----------|----------|
| [04_logging_and_osviz.md](04_logging_and_osviz.md) | Kernel `LOG_*` macros, UART JSON lines, host capture, WebSocket demux |
| [05_web_frontend.md](05_web_frontend.md) | LibertyOS Web UI, `server.py`, terminal gate, event bubbles |

---

## Quick start (operator)

```bash
# Kernel
cd code/myos && make              # DEBUG=1 (logging on)
make DEBUG=0                      # compile-time logging off

# QEMU (foreground serial)
./sh/start_qemu.sh

# Web backend (Flask on 127.0.0.1:5000; nginx may expose :3333)
cd code/web && ./start_server.sh
```

See also [使用方法.md](../使用方法.md) at repo root for local commands.

---

*Last aligned with: Sv39 + `proc_spawn_exec_wait`, PMM (`pmm_init`), macro-gated osviz, Web serial demux.*
