#!/usr/bin/env python3
"""LibertyOS web backend — static files + WebSocket PTY (QEMU serial)."""

import json
import os
import pty
import select
import stat
import subprocess
import threading
from pathlib import Path
from typing import Callable, Dict, List, Optional

from flask import Flask, jsonify, request, send_from_directory
from flask_cors import CORS
from flask_sock import Sock

MYOS_ROOT = Path(os.environ.get("MYOS_ROOT", Path(__file__).resolve().parent.parent)).resolve()
WEB_DIR = Path(os.environ.get("WEB_DIR", Path(__file__).resolve().parent)).resolve()
HOME_ROOT = MYOS_ROOT / "home" / "root"
QEMU_SCRIPT = MYOS_ROOT / "sh" / "start_qemu.sh"
KERNEL = MYOS_ROOT / "out" / "os"

HOST = os.environ.get("VM_HOST", "127.0.0.1")  # nginx 反代时仅监听本机
PORT = int(os.environ.get("VM_PORT", "5000"))  # 与 nginx-libertyos.conf 中 proxy_pass 一致

LOG_EVENT_PREFIX = "LOG "
LOG_SNAPSHOT_PREFIX = "LOG_SNAPSHOT "

# Matches kernel console_io.h channels (step 2: both on UART; host demux splits).
CHANNEL_CONSOLE = "console"
CHANNEL_LOG = "log"

app = Flask(__name__, static_folder=str(WEB_DIR), static_url_path="")
CORS(app)
sock = Sock(app)


class SerialDemux:
    """Demux guest serial: console_write → terminal, log_write → event bubbles.

    Step 2: kernel routes both APIs to one UART; we split by LOG line framing.
    Step 3: log_write may use pipe/socket/file/2nd UART — demux stays the same.
    """

    _LOG_MARKERS = (
        (LOG_EVENT_PREFIX.encode("utf-8"), LOG_EVENT_PREFIX, "event"),
        (LOG_SNAPSHOT_PREFIX.encode("utf-8"), LOG_SNAPSHOT_PREFIX, "snapshot"),
    )

    def __init__(self, send_json: Callable[[Dict], None]):
        self._send_json = send_json
        self._buf = bytearray()

    def _send_console(self, data: str) -> None:
        self._send_json({"type": "output", "channel": CHANNEL_CONSOLE, "data": data})

    def _send_log_event(self, event: Dict) -> None:
        self._send_json({"type": "event", "channel": CHANNEL_LOG, "event": event})

    def _send_log_snapshot(self, snapshot: Dict) -> None:
        self._send_json({"type": "snapshot", "channel": CHANNEL_LOG, "snapshot": snapshot})

    def feed(self, chunk: bytes) -> None:
        if not chunk:
            return
        self._buf.extend(chunk)
        self._drain()

    def flush(self) -> None:
        if not self._buf:
            return
        text = self._buf.decode("utf-8", errors="replace")
        self._buf.clear()
        self._send_console(text)

    def _drain(self) -> None:
        while True:
            if self._try_extract_embedded_log():
                continue
            nl = self._buf.find(b"\n")
            if nl < 0:
                self._flush_safe_partial()
                return
            line = bytes(self._buf[: nl + 1])
            del self._buf[: nl + 1]
            self._dispatch_line(line)

    def _find_log_marker(self, data: bytes):
        best = None
        for prefix_b, prefix_s, kind in self._LOG_MARKERS:
            idx = data.find(prefix_b)
            if idx >= 0 and (best is None or idx < best[0]):
                best = (idx, prefix_s, kind)
        return best

    def _try_extract_embedded_log(self) -> bool:
        """Pull LOG / LOG_SNAPSHOT lines even when interleaved with shell bytes."""
        if not self._buf:
            return False

        found = self._find_log_marker(bytes(self._buf))
        if found is None:
            return False

        idx, prefix_s, kind = found
        nl = self._buf.find(b"\n", idx)
        if nl < 0:
            return False

        if idx > 0:
            before = bytes(self._buf[:idx]).decode("utf-8", errors="replace")
            if before:
                self._send_console(before)

        segment = bytes(self._buf[idx : nl + 1]).decode("utf-8", errors="replace")
        del self._buf[: nl + 1]
        self._dispatch_log_segment(segment, prefix_s, kind)
        return True

    @classmethod
    def _hold_partial(cls, text: str) -> bool:
        """Hold bytes that may be an incomplete LOG / LOG_SNAPSHOT line."""
        if not text:
            return False

        for prefix_b, prefix_s, _kind in cls._LOG_MARKERS:
            for k in range(1, len(prefix_s)):
                if text.endswith(prefix_s[:k]):
                    return True

        start = 0
        while True:
            found = None
            for _prefix_b, prefix_s, _kind in cls._LOG_MARKERS:
                idx = text.find(prefix_s, start)
                if idx >= 0 and (found is None or idx < found):
                    found = idx
            if found is None:
                break
            rest = text[found:]
            if "\n" not in rest and "\r" not in rest:
                return True
            start = found + 1

        return False

    def _flush_safe_partial(self) -> None:
        """Only release non-LOG bytes that cannot be part of a pending LOG line."""
        if not self._buf:
            return
        if self._hold_partial(self._buf.decode("utf-8", errors="replace")):
            return
        # Keep partial shell lines until '\n' so welcome / program output stay intact.

    def _dispatch_log_segment(self, line: str, prefix: str, kind: str) -> None:
        clean = line.rstrip("\r\n")
        body = clean[len(prefix) :].strip()
        if kind == "event":
            event = self._parse_json(body)
            if event is not None:
                self._send_log_event(event)
            else:
                self._send_console(line)
            return

        snapshot = self._parse_json(body)
        if snapshot is not None:
            self._send_log_snapshot(snapshot)
        else:
            self._send_console(line)

    def _dispatch_line(self, raw: bytes) -> None:
        line = raw.decode("utf-8", errors="replace")
        clean = line.rstrip("\r\n")

        if clean.startswith(LOG_EVENT_PREFIX):
            self._dispatch_log_segment(line, LOG_EVENT_PREFIX, "event")
            return

        if clean.startswith(LOG_SNAPSHOT_PREFIX):
            self._dispatch_log_segment(line, LOG_SNAPSHOT_PREFIX, "snapshot")
            return

        self._send_console(line)

    @staticmethod
    def _parse_json(body: str) -> Optional[Dict]:
        if not body:
            return None
        try:
            parsed = json.loads(body)
        except json.JSONDecodeError:
            return None
        return parsed if isinstance(parsed, dict) else None


def _sanitize_env() -> Dict[str, str]:
    env = os.environ.copy()
    env.setdefault("TERM", "xterm-256color")
    env.setdefault("LANG", "C.UTF-8")
    env.setdefault("LC_ALL", "C.UTF-8")
    env["DEBUG"] = "n"
    return env


def _qemu_shell_cmd() -> str:
    if not QEMU_SCRIPT.is_file():
        raise RuntimeError(f"QEMU 启动脚本不存在: {QEMU_SCRIPT}")
    return f"cd {MYOS_ROOT} && DEBUG=n ./{QEMU_SCRIPT.relative_to(MYOS_ROOT)}"


def _safe_home_path(name: str) -> Path:
    if not name or "/" in name or "\\" in name or name in (".", ".."):
        raise ValueError("非法文件名")
    target = (HOME_ROOT / name).resolve()
    root = HOME_ROOT.resolve()
    if target != root and not str(target).startswith(str(root) + os.sep):
        raise ValueError("非法路径")
    if not target.is_file():
        raise FileNotFoundError(name)
    return target


def _classify_file(path: Path) -> str:
    name = path.name
    mode = path.stat().st_mode
    is_exec = bool(mode & stat.S_IXUSR)
    suffix = path.suffix.lower()

    if suffix == ".sh":
        return "script"
    if suffix == ".c":
        return "source"
    if suffix == ".txt":
        return "text"
    if is_exec and suffix not in (".c", ".txt"):
        return "exec"
    return "file"


def _list_home_files() -> List[Dict]:
    if not HOME_ROOT.is_dir():
        return []
    items: List[Dict] = []
    for p in sorted(HOME_ROOT.iterdir(), key=lambda x: x.name.lower()):
        if not p.is_file():
            continue
        kind = _classify_file(p)
        items.append(
            {
                "name": p.name,
                "type": kind,
                "size": p.stat().st_size,
                "executable": bool(p.stat().st_mode & stat.S_IXUSR),
            }
        )
    return items


@app.route("/")
def index():
    return send_from_directory(str(WEB_DIR), "index.html")


@app.route("/health", methods=["GET"])
def health():
    return jsonify(
        {
            "status": "ok",
            "myos_root": str(MYOS_ROOT),
            "home_root": str(HOME_ROOT),
            "kernel": str(KERNEL),
            "kernel_exists": KERNEL.is_file(),
        }
    )


@app.route("/api/files", methods=["GET"])
def api_files():
    return jsonify({"path": "/home/root", "files": _list_home_files()})


@app.route("/api/file", methods=["GET"])
def api_file_read():
    name = (request.args.get("name") or "").strip()
    try:
        target = _safe_home_path(name)
        data = target.read_text(encoding="utf-8", errors="replace")
        return jsonify(
            {
                "name": name,
                "path": f"/home/root/{name}",
                "type": _classify_file(target),
                "size": target.stat().st_size,
                "content": data,
            }
        )
    except FileNotFoundError:
        return jsonify({"error": f"文件不存在: {name}"}), 404
    except ValueError as exc:
        return jsonify({"error": str(exc)}), 400


@sock.route("/ws/ssh")
def ws_ssh(ws):
    send_lock = threading.Lock()
    stop_event = threading.Event()

    master_fd, slave_fd = pty.openpty()
    try:
        shell_proc = subprocess.Popen(
            ["/bin/bash", "-lc", _qemu_shell_cmd()],
            stdin=slave_fd,
            stdout=slave_fd,
            stderr=slave_fd,
            cwd=str(MYOS_ROOT),
            env=_sanitize_env(),
            close_fds=True,
        )
    except Exception as exc:
        os.close(master_fd)
        os.close(slave_fd)
        ws.send(json.dumps({"type": "error", "message": str(exc)}, ensure_ascii=False))
        return

    os.close(slave_fd)

    def send_json(payload: Dict):
        msg = json.dumps(payload, ensure_ascii=False)
        with send_lock:
            ws.send(msg)

    demux = SerialDemux(send_json)

    def shell_reader():
        while not stop_event.is_set():
            try:
                ready, _, _ = select.select([master_fd], [], [], 0.3)
                if not ready:
                    if shell_proc.poll() is not None:
                        break
                    continue
                data = os.read(master_fd, 4096)
                if not data:
                    break
                demux.feed(data)
            except Exception:
                break
        demux.flush()

    reader_thread = threading.Thread(target=shell_reader, daemon=True)
    reader_thread.start()
    send_json({"type": "output", "data": "[ready]\n"})

    try:
        while True:
            raw = ws.receive()
            if raw is None:
                break
            try:
                message = json.loads(raw)
            except Exception:
                send_json({"type": "error", "message": "消息不是合法 JSON"})
                continue

            msg_type = message.get("type")
            if msg_type == "input":
                data = str(message.get("data", ""))
                if data:
                    os.write(master_fd, data.encode("utf-8", errors="replace"))
                continue

            send_json({"type": "error", "message": f"不支持的消息类型: {msg_type}"})
    except Exception:
        pass
    finally:
        stop_event.set()
        try:
            shell_proc.terminate()
        except Exception:
            pass
        try:
            os.close(master_fd)
        except Exception:
            pass


if __name__ == "__main__":
    print(f"LibertyOS web server  http://{HOST}:{PORT}")
    print(f"  MYOS_ROOT:  {MYOS_ROOT}")
    print(f"  HOME_ROOT:  {HOME_ROOT}")
    print(f"  WEB_DIR:    {WEB_DIR}")
    print(f"  QEMU:       {QEMU_SCRIPT}")
    app.run(host=HOST, port=PORT, threaded=True)
