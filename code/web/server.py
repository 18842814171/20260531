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

app = Flask(__name__, static_folder=str(WEB_DIR), static_url_path="")
CORS(app)
sock = Sock(app)


class SerialDemux:
    """Split QEMU serial: LOG* -> WebSocket event/snapshot, everything else -> output."""

    def __init__(self, send_json: Callable[[Dict], None]):
        self._send_json = send_json
        self._buf = bytearray()

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
        self._send_json({"type": "output", "data": text})

    def _drain(self) -> None:
        while True:
            nl = self._buf.find(b"\n")
            if nl < 0:
                self._flush_safe_partial()
                return
            line = bytes(self._buf[: nl + 1])
            del self._buf[: nl + 1]
            self._dispatch_line(line)

    @staticmethod
    def _hold_partial(text: str) -> bool:
        """Hold bytes that may be an incomplete LOG / LOG_SNAPSHOT line."""
        stripped = text.lstrip("\r\n")
        if not stripped:
            return False
        if stripped.startswith(LOG_SNAPSHOT_PREFIX):
            return True
        if stripped.startswith(LOG_EVENT_PREFIX):
            return True
        for marker in (LOG_EVENT_PREFIX, LOG_SNAPSHOT_PREFIX):
            if len(stripped) < len(marker) and marker.startswith(stripped):
                return True
        return False

    def _flush_safe_partial(self) -> None:
        """Only release non-LOG bytes that cannot be part of a pending LOG line."""
        if not self._buf:
            return
        if self._hold_partial(self._buf.decode("utf-8", errors="replace")):
            return
        # Keep partial shell lines until '\n' so welcome / program output stay intact.

    def _dispatch_line(self, raw: bytes) -> None:
        line = raw.decode("utf-8", errors="replace")
        clean = line.rstrip("\r\n")

        if clean.startswith(LOG_EVENT_PREFIX):
            body = clean[len(LOG_EVENT_PREFIX) :].strip()
            event = self._parse_json(body)
            if event is not None:
                self._send_json({"type": "event", "event": event})
            else:
                self._send_json({"type": "output", "data": line})
            return

        if clean.startswith(LOG_SNAPSHOT_PREFIX):
            body = clean[len(LOG_SNAPSHOT_PREFIX) :].strip()
            snapshot = self._parse_json(body)
            if snapshot is not None:
                self._send_json({"type": "snapshot", "snapshot": snapshot})
            else:
                self._send_json({"type": "output", "data": line})
            return

        self._send_json({"type": "output", "data": line})

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
