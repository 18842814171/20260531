#!/usr/bin/env python3
"""Read QEMU UART and capture LOG JSON into code/osviz/events/."""

import argparse
import json
import os
import pty
import re
import select
import subprocess
import sys
from collections import deque
from pathlib import Path

EVENT_RE = re.compile(rb"^LOG (.+)\r?\n$")
AUTO_RECENT_N = 10

LOG_ROOT = Path(__file__).resolve().parent.parent
EVENTS_DIR = LOG_ROOT / "events"
DEFAULT_JSONL = EVENTS_DIR / "events.jsonl"
RECENT_JSON = EVENTS_DIR / "recent.json"


def write_recent(recent: deque) -> None:
    items = []
    for line in recent:
        try:
            items.append(json.loads(line))
        except json.JSONDecodeError:
            items.append({"raw": line})
    RECENT_JSON.write_text(
        json.dumps(items, ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8",
    )


def record_osviz_line(out, recent: deque, line: bytes) -> int:
    m = EVENT_RE.match(line)
    if not m:
        return 0
    text = m.group(1).decode("utf-8", errors="replace").strip()
    out.write(text)
    out.write("\n")
    out.flush()
    recent.append(text)
    write_recent(recent)
    return 1


def ingest_osviz(parse_buf: bytearray, out, recent: deque) -> int:
    count = 0
    while True:
        nl = parse_buf.find(b"\n")
        if nl < 0:
            break
        line = bytes(parse_buf[: nl + 1])
        del parse_buf[: nl + 1]
        count += record_osviz_line(out, recent, line)
    return count


def pump(src, dst, parse_buf: bytearray, out, recent: deque) -> int:
    """Forward guest UART immediately; parse LOG from complete lines only."""
    chunk = src.read(4096)
    if not chunk:
        return 0

    dst.write(chunk)
    dst.flush()

    parse_buf.extend(chunk)
    return ingest_osviz(parse_buf, out, recent)


def run_qemu_pty(qemu_cmd, out_path: Path) -> int:
    """Run QEMU on a PTY so host keyboard and guest serial share one link."""
    master, slave = pty.openpty()
    proc = subprocess.Popen(
        qemu_cmd,
        stdin=slave,
        stdout=slave,
        stderr=slave,
        close_fds=True,
    )
    os.close(slave)

    recent = deque(maxlen=AUTO_RECENT_N)
    parse_buf = bytearray()
    count = 0

    out_path.parent.mkdir(parents=True, exist_ok=True)
    EVENTS_DIR.mkdir(parents=True, exist_ok=True)

    try:
        with open(out_path, "a", encoding="utf-8") as out:
            while True:
                if proc.poll() is not None:
                    break

                rfds = [master]
                if sys.stdin.isatty():
                    rfds.append(sys.stdin.fileno())

                ready, _, _ = select.select(rfds, [], [], 0.05)

                if master in ready:
                    try:
                        data = os.read(master, 4096)
                    except OSError:
                        break
                    if not data:
                        break
                    sys.stdout.buffer.write(data)
                    sys.stdout.buffer.flush()
                    parse_buf.extend(data)
                    count += ingest_osviz(parse_buf, out, recent)

                if sys.stdin.isatty() and sys.stdin.fileno() in ready:
                    data = os.read(sys.stdin.fileno(), 4096)
                    if not data:
                        break
                    os.write(master, data)
    finally:
        if proc.poll() is None:
            proc.terminate()
            try:
                proc.wait(timeout=2)
            except subprocess.TimeoutExpired:
                proc.kill()
                proc.wait()

    return count


def main():
    parser = argparse.ArgumentParser(description="Filter LOG lines from kernel UART")
    parser.add_argument(
        "-o",
        "--output",
        default=str(DEFAULT_JSONL),
        help=f"Append full log (default: {DEFAULT_JSONL})",
    )
    parser.add_argument(
        "--run",
        action="store_true",
        help="Run QEMU on a PTY (keyboard + serial); args after -- are the QEMU command",
    )
    parser.add_argument(
        "input",
        nargs="?",
        default="-",
        help="Input file or '-' for stdin (default: stdin)",
    )
    args, rest = parser.parse_known_args()

    out_path = Path(args.output)

    if args.run:
        if not rest or rest[0] == "--":
            rest = rest[1:] if rest and rest[0] == "--" else rest
        if not rest:
            print("error: --run requires a QEMU command after --", file=sys.stderr)
            sys.exit(2)
        count = run_qemu_pty(rest, out_path)
        print(
            f"osviz: {count} events -> {out_path}; auto recent({AUTO_RECENT_N}) -> {RECENT_JSON}",
            file=sys.stderr,
        )
        return

    recent = deque(maxlen=AUTO_RECENT_N)
    src = sys.stdin.buffer if args.input == "-" else open(args.input, "rb")
    parse_buf = bytearray()
    count = 0
    out_path.parent.mkdir(parents=True, exist_ok=True)
    EVENTS_DIR.mkdir(parents=True, exist_ok=True)
    with open(out_path, "a", encoding="utf-8") as out:
        while True:
            n = pump(src, sys.stdout.buffer, parse_buf, out, recent)
            if n == 0:
                break
            count += n

    if args.input != "-" and parse_buf:
        with open(out_path, "a", encoding="utf-8") as out:
            count += record_osviz_line(out, recent, bytes(parse_buf))

    if args.input != "-":
        src.close()

    print(
        f"osviz: {count} events -> {out_path}; auto recent({AUTO_RECENT_N}) -> {RECENT_JSON}",
        file=sys.stderr,
    )


if __name__ == "__main__":
    main()
