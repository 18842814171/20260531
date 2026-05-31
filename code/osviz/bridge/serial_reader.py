#!/usr/bin/env python3
"""Read QEMU UART and capture OSVIZ JSON into code/osviz/events/."""

import argparse
import json
import re
import sys
from collections import deque
from pathlib import Path

EVENT_RE = re.compile(rb"^OSVIZ (.+)\r?\n$")
AUTO_RECENT_N = 10

OSVIZ_ROOT = Path(__file__).resolve().parent.parent
EVENTS_DIR = OSVIZ_ROOT / "events"
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


def main():
    parser = argparse.ArgumentParser(description="Filter OSVIZ lines from kernel UART")
    parser.add_argument(
        "-o",
        "--output",
        default=str(DEFAULT_JSONL),
        help=f"Append full log (default: {DEFAULT_JSONL})",
    )
    parser.add_argument(
        "input",
        nargs="?",
        default="-",
        help="Input file or '-' for stdin (default: stdin)",
    )
    args = parser.parse_args()

    out_path = Path(args.output)
    out_path.parent.mkdir(parents=True, exist_ok=True)
    EVENTS_DIR.mkdir(parents=True, exist_ok=True)

    recent = deque(maxlen=AUTO_RECENT_N)
    src = sys.stdin.buffer if args.input == "-" else open(args.input, "rb")
    count = 0
    with open(out_path, "a", encoding="utf-8") as out:
        for line in src:
            sys.stdout.buffer.write(line)
            sys.stdout.buffer.flush()
            m = EVENT_RE.match(line)
            if not m:
                continue
            text = m.group(1).decode("utf-8", errors="replace").strip()
            out.write(text)
            out.write("\n")
            out.flush()
            recent.append(text)
            write_recent(recent)
            count += 1

    if args.input != "-":
        src.close()

    print(
        f"osviz: {count} events -> {out_path}; auto recent({AUTO_RECENT_N}) -> {RECENT_JSON}",
        file=sys.stderr,
    )


if __name__ == "__main__":
    main()
