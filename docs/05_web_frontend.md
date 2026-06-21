# LibertyOS Web Frontend

**Scope:** Browser UI for interactive QEMU sessions — terminal, file browser, and kernel event panel. Code under `code/web/`.

---

## 1. Layout

```text
index.html          Login (username must be root) → sessionStorage
desktop.html        Main workspace
  ├─ sidebar        Desktop icons + /home/root file tree
  ├─ workspace      File preview + resizable terminal (drag splitter)
  └─ log-bubble-panel   Right column: command → semantic event → raw JSON (tree)
```

Scripts (load order on `desktop.html`):

| File | Role |
|------|------|
| `js/global.js` | Session, file icons |
| `js/log_aggregate.js` | L1/L2 aggregation rules (module/event, no program-name lists) |
| `js/logs_tree.js` | Hierarchical command cards (default panel) |
| `js/logs.js` | Flat event cards fallback (max 500) |
| `js/terminal.js` | WebSocket, login gate, line/raw input, prompt label sync |
| `js/files.js` | `/api/files`, run command helper |
| `js/desktop.js` | Wiring, terminal height splitter |

Styles: `css/global.css`.

**Terminal height:** Drag `#console-splitter` between preview and terminal; double-click resets; height saved in `localStorage`.

---

## 2. Backend stack

```text
Browser
  → nginx :3333 (optional)
  → Flask server.py  VM_HOST:VM_PORT (default 127.0.0.1:5000)
       ├─ GET /              index.html
       ├─ GET /api/files     list /home/root (host mirror)
       ├─ GET /api/file      read file content
       └─ WS  /ws/ssh        PTY ↔ QEMU
```

Start: `code/web/start_server.sh`  
QEMU launch inside PTY: `DEBUG=n ./sh/start_qemu.sh` (interactive serial).

---

## 3. WebSocket protocol

Single connection `/ws/ssh`. JSON messages:

### Server → client

| type | Fields | UI target |
|------|--------|-----------|
| `output` | `channel: "console"`, `data` | Terminal pane |
| `event` | `channel: "log"`, `event` (object) | Event panel |
| `snapshot` | `channel: "log"`, `snapshot` (object) | Event panel |
| `error` | `message` | Terminal (error style) |

Legacy messages without `channel` are still accepted.

### Client → server

| type | Fields |
|------|--------|
| `input` | `data` (raw bytes; `\n` for Enter) |

One WebSocket carries both streams; type and channel distinguish them.

---

## 4. SerialDemux (`server.py`)

Guest console text and structured logs share one PTY byte stream.

**Classification**

- Lines (or embedded segments) starting with `LOG ` → `type=event`, `channel=log`
- `LOG_SNAPSHOT ` → `type=snapshot`, `channel=log`
- `LOG_NOTE ` → `type=note`, `channel=log`
- All other bytes → `type=output`, `channel=console`

**Invalid JSON:** Parsed log lines that fail `json.loads` are **dropped** (not shown in terminal or panel).

**JSON tails:** Lines like `odule":"sched"...` without a `LOG ` prefix are discarded (defence against historical UART interleave).

**Interleaved input:** When shell output and a log line arrive in one chunk (e.g. `cLOG {"ts_ms":…}`), demux extracts the log segment and forwards the surrounding bytes as console output.

**Partial lines:** Incomplete `LOG` / `LOG_SNAPSHOT` prefixes are held in buffer until `\n` or disconnect flush.

~~Invalid JSON after a log prefix falls back to console output.~~ *(2026-06-21: dropped instead.)*

---

## 5. Terminal (`terminal.js`)

### Login gate

Output before `\nWelcome, root.\n` is buffered in `preShellBuf` and not shown. After welcome, terminal opens; auto-login sends `root` when the login prompt appears.

### Line mode (default shell)

User types in the input box; **Enter** sends the full line. No local echo — only guest output is displayed (avoids duplicate lines with `vi` and shell echo).

### Raw mode (interactive programs)

When output contains `-- vi … --`, `-- NORMAL --`, `-- INSERT --`, or `ipc_echo`’s input prompt, the UI switches to **single-key** mode: each key is sent immediately (Esc, Backspace, Enter included). Exits on `vi: saved`, `vi: quit`, or `ipc_echo` done.

### Log leak fallback

If a log line still reaches `type=output`, the client strips `LOG {"ts_ms"…}` segments and forwards them to the event panel.

### Prompt label sync (2026-06-21)

Guest shell prints `root@<cwd>$` in the serial stream. The input row also has `#console-prompt` — updated from each prompt line detected in output so `cd` changes stay in sync. Placeholder text is owned by `terminal.js` only (not `desktop.js`).

---

## 6. Event panel

### Flat mode (`logs.js`)

- Card templates for trap, boot, proc, pmm, etc.
- Newest events at bottom; max 500 retained
- **`QUIET_MODULES`:** `pmm` events dropped from main panel

### Tree mode (`logs_tree.js` + `log_aggregate.js`) — default

```text
L1 CommandRun     one user command (deferred reveal after prompt/exit)
  L2 SysEvent     page faults, process lifecycle, sem, … (only if bucket non-empty)
    L3 Raw        LOG JSON fields
```

| Profile | L1 behaviour |
|---------|----------------|
| Shell builtin (no `./`) | Title + “completed”, usually no L2 |
| External ELF (`./prog`) | Expandable; L2 from kernel buckets |

- Serial reveal queue (same as flat mode)
- L1 closes on: process exit + prompt, explicit end (`ipc_echo done`), or prompt heuristic for builtins
- Page-fault episodes: NOTE context stack until trap leave (P4 `activity_id` planned)

---

## 7. Typical session

```text
1. Login → WebSocket connect
2. Boot logs → right panel (via demux)
3. Welcome, root. → terminal visible
4. User runs ./hi
   → output: hi from ./hi
   → events: proc/trap (right panel)
5. User runs vi file — raw mode; :wq saves; returns to line mode
```

---

## 8. Troubleshooting

| Symptom | Likely cause | Action |
|---------|--------------|--------|
| Terminal empty after login | Welcome not detected | Check serial has `\nWelcome, root.\n`; hard refresh |
| LOG JSON in terminal | Old server or demux gap | Restart `start_server.sh`; hard refresh |
| vi lines duplicated | Local echo (fixed) | Hard refresh browser |
| vi keys ignored | Still in line mode | Wait for raw-mode hint; focus input box |
| Background script stuck in sleep | Poll only on timer | Rebuild kernel; or `kill 2` in shell |
| Cannot start second `sh … &` | One bg script limit | `kill` or `jobs` then retry |
| Bubble list won't scroll up | CSS flex-end bug (fixed) | Hard refresh |
| Trap bubbles appear out of order | Independent random delays (fixed) | Hard refresh; see serial reveal queue |
| PMM alloc/free floods panel | High-frequency LOG (fixed) | Kernel + `QUIET_MODULES`; hard refresh |
| `./pagefault` only shows lifecycle L2 | Handled faults had no LOG; or 64B JSON truncated | Rebuild kernel; see [log/0621debug.md](../log/0621debug.md) |
| Output glued to prompt (`done.root@`) | `write()` length off by one | Fixed in `pagefault.c`; shell adds `\n` before prompt |
| Input prompt stuck at `/home/root` after `cd` | Static `#console-prompt` | Hard refresh; prompt sync in `terminal.js` |
| JSON fragment `odule":"sched"` in terminal | UART interleave | Rebuild kernel (`console_io.c` atomic write) |

---

## Related documents

| Document | Contents |
|----------|----------|
| [04_logging_and_osviz.md](04_logging_and_osviz.md) | Kernel log format, host tools |
| [01_architecture.md](01_architecture.md) | §9 Web data flow |
| [PROBLEMS_AND_SOLUTIONS.md](PROBLEMS_AND_SOLUTIONS.md) | §11 Web issues |

---

*Last aligned with: hierarchical log tree, prompt sync, demux JSON drop, page_fault LOG (2026-06-21).*
