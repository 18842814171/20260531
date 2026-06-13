# LibertyOS Web Frontend

**Scope:** Browser UI for interactive QEMU sessions — terminal, file browser, and kernel event bubbles. Code under `code/web/`.

---

## 1. Layout

```text
index.html          Login (username must be root) → sessionStorage
desktop.html        Main workspace
  ├─ sidebar        Desktop icons + /home/root file tree
  ├─ workspace      File preview + terminal panel
  └─ log-bubble-panel   Right column: parsed LOG events (4 per page)
```

Scripts (load order on `desktop.html`):

| File | Role |
|------|------|
| `js/global.js` | Session, file icons (`bi-*`) |
| `js/logs.js` | Event bubble render + pager |
| `js/terminal.js` | WebSocket PTY, login gate, terminal output |
| `js/files.js` | `/api/files`, run command helper |
| `js/desktop.js` | Wiring, view switch |

Styles: `css/global.css`.

---

## 2. Backend stack

```text
Browser
  → nginx :3333 (optional, nginx-libertyos.conf)
  → Flask server.py  VM_HOST:VM_PORT (default 127.0.0.1:5000)
       ├─ GET /              index.html
       ├─ GET /api/files     list /home/root (host mirror)
       ├─ GET /api/file      read file content
       └─ WS  /ws/ssh        PTY ↔ QEMU
```

Start: `code/web/start_server.sh`  
Environment: `MYOS_ROOT`, `WEB_DIR`, `VM_HOST`, `VM_PORT`.

QEMU launch (inside PTY):

```bash
cd $MYOS_ROOT && DEBUG=n ./sh/start_qemu.sh
```

`server.py` forces `DEBUG=n` so stdout is **not** piped through `serial_reader.py`; demux is done in Python.

---

## 3. WebSocket protocol

Single connection `/ws/ssh`. JSON messages:

### Server → client

| type | Fields | Consumer |
|------|--------|----------|
| `output` | `data` (string, usually line with `\n`) | Terminal pane |
| `event` | `event` (object, parsed LOG JSON) | `LibertyLogs.addEvent` |
| `snapshot` | `snapshot` (object) | `LibertyLogs.handleSnapshot` |
| `error` | `message` | Terminal (error style) |

### Client → server

| type | Fields |
|------|--------|
| `input` | `data` (raw bytes, include `\n` for Enter) |

**No second WebSocket** for logs; message type discriminates streams.

---

## 4. SerialDemux (`server.py`)

Problem: kernel LOG and shell text share one PTY byte stream.

Solution: buffer PTY reads, split on `\n`, classify each complete line:

```text
line.startswith("LOG ")           →  {type:"event", event: json.loads(body)}
line.startswith("LOG_SNAPSHOT ")  →  {type:"snapshot", snapshot: …}
else                              →  {type:"output", data: line}
```

**Partial-line rules**

- Suffix that may be an incomplete `LOG` / `LOG_SNAPSHOT` prefix → hold in buffer
- Other incomplete lines → hold until `\n` (do not flush mid-line)
- On disconnect → `flush()` remaining buffer as `output`

Invalid JSON after `LOG ` prefix falls back to `output` (safe degradation).

---

## 5. Terminal gate (`terminal.js`)

Web UI does not show boot spam before login completes.

```text
preShellBuf accumulates all output chunks
until "Welcome, root." appears
  → shellReady = true, termGateOpen = true
  → clear #console-output, show from welcome onward
```

| Phase | Behaviour |
|-------|-----------|
| Before welcome | Output accumulated in `preShellBuf` only; terminal visually empty |
| After welcome | `appendTerminalOutput` renders `type=output` |
| Events | `type=event` / `snapshot` always go to right panel (even during boot) |

**Auto-login:** After seeing `login:` or `Username: root`, send session user (`root`) once.

**Local echo:** `sendCommand` appends the typed line to the terminal when `shellReady` (Web input box is not QEMU echo).

**Static prompt label:** `#console-prompt` in HTML is decorative; readiness is determined by welcome text, not the label.

---

## 6. Event bubbles (`logs.js`)

- Renders trap/boot/proc/pmm events as cards (Bootstrap Icons)
- Special templates: `trap/enter`, `trap/leave`, `trap-diag/leave_handler`
- Pager: 4 events per page, max 500 retained
- **No** client-side `LOG` line parsing after demux (legacy `stripEvents` removed)

---

## 7. Typical session flow

```text
1. index.html — login as root → sessionStorage
2. desktop.html — WebSocket connect
3. Boot LOG events → right panel bubbles
4. Boot printf (HEAP_*, etc.) → preShellBuf (hidden)
5. Welcome, root. → terminal opens; auto-login if needed
6. User runs ./hi in input box
   ├─ local echo: ./hi
   ├─ output: hi from ./hi
   └─ events: proc/fork, trap/enter, proc/exit (right panel)
```

---

## 8. Troubleshooting

| Symptom | Likely cause | Check |
|---------|--------------|-------|
| Bubbles work, terminal empty | Welcome never detected; gate closed | Serial has `\nWelcome, root.\n`; hard refresh |
| `./hi` no output | Same gate issue, or kernel exec failure | QEMU direct: `./sh/start_qemu.sh` |
| LOG lines in terminal | Old server without demux | Restart `start_server.sh` |
| JSON half-lines in UI | Partial flush bug | Update `SerialDemux` (hold until `\n`) |
| Keyboard ignored in QEMU direct | `DEBUG=y` pipes stdout to osviz | Use **`DEBUG=n ./sh/start_qemu.sh`** on a real terminal |
| Shell frozen at `login:` (post–Stage 2) | Scheduler did not resume pid 1 after UART block | Fixed via **`kctx_asleep`** (2026-06-13); rebuild kernel |
| Input ignored | WebSocket down | Status dot / reconnect |

---

## Related documents

| Document | Contents |
|----------|----------|
| [04_logging_and_osviz.md](04_logging_and_osviz.md) | LOG format, host tools |
| [01_architecture.md](01_architecture.md) | §9 Web data flow |
| [PROBLEMS_AND_SOLUTIONS.md](PROBLEMS_AND_SOLUTIONS.md) | §11 Web issues; §12 scheduling |
| [logs/0613.md](../logs/0613.md) | 2026-06-13 Stage 1–2 log |

---

*Last aligned with: xv6-style `proc_kctx` (Stage 1–2), `proc_kctx_switch` block-wakeup, `kctx_asleep` shell fix, AUTORUN `ipc_echo`.*
