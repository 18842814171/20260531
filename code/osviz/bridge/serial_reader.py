#!/usr/bin/env python3
"""Read QEMU UART (stdin/stdout) and extract OSVIZ JSON lines into events.jsonl."""

import argparse
import re
import sys
from pathlib import Path

EVENT_RE = re.compile(rb"^OSVIZ (.+)\r?\n$")


def main():
    parser = argparse.ArgumentParser(description="Filter OSVIZ lines from kernel UART")
    parser.add_argument(
        "-o",
        "--output",
        default="output/osviz/events.jsonl",
        help="Output JSONL file (default: output/osviz/events.jsonl)",
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

    src = sys.stdin.buffer if args.input == "-" else open(args.input, "rb")
    count = 0
    with open(out_path, "a", encoding="utf-8") as out:
        for line in src:
            sys.stdout.buffer.write(line)
            sys.stdout.buffer.flush()
            m = EVENT_RE.match(line)
            if m:
                out.write(m.group(1).decode("utf-8", errors="replace"))
                out.write("\n")
                out.flush()
                count += 1

    if args.input != "-":
        src.close()

    print(f"osviz: captured {count} events -> {out_path}", file=sys.stderr)


if __name__ == "__main__":
    main()
