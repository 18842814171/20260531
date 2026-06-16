#!/usr/bin/env python3
"""Parse serial output from make AUTORUN=test / run_batch.sh."""

from __future__ import annotations

import re
import sys
from pathlib import Path


def parse_log(text: str) -> dict:
    summary = re.search(
        r"BATCH_SUMMARY pass=(\d+) fail=(\d+) skip=(\d+) total=(\d+)",
        text,
    )
    blocks: list[dict] = []
    cur_name = None
    cur_lines: list[str] = []

    for line in text.splitlines():
        m_start = re.match(r"========== START (\S+) ==========", line)
        m_end = re.match(r"========== END (\S+) ==========", line)
        if m_start:
            if cur_name is not None:
                blocks.append({"name": cur_name, "lines": cur_lines})
            cur_name = m_start.group(1)
            cur_lines = []
            continue
        if m_end and cur_name == m_end.group(1):
            blocks.append({"name": cur_name, "lines": cur_lines})
            cur_name = None
            cur_lines = []
            continue
        if cur_name is not None:
            cur_lines.append(line)

    result = {
        "summary": None,
        "blocks": blocks,
        "panic": "panic(" in text or "OOPS!" in text,
        "autorun_ok": "autorun: done status=0" in text,
    }
    if summary:
        result["summary"] = {
            "pass": int(summary.group(1)),
            "fail": int(summary.group(2)),
            "skip": int(summary.group(3)),
            "total": int(summary.group(4)),
        }
    return result


def main() -> int:
    if len(sys.argv) > 1:
        text = Path(sys.argv[1]).read_text(encoding="utf-8", errors="replace")
    else:
        text = sys.stdin.read()

    data = parse_log(text)
    summary = data["summary"]

    if data["panic"]:
        print("FAIL: kernel panic detected")
        return 2

    if not summary:
        print("FAIL: no BATCH_SUMMARY (did AUTORUN=test run?)")
        return 2

    p, f, s, t = (
        summary["pass"],
        summary["fail"],
        summary["skip"],
        summary["total"],
    )
    pct = (100.0 * p / t) if t else 0.0
    print(f"batch: {p}/{t} passed ({pct:.1f}%), fail={f}, skip={s}")

    for block in data["blocks"]:
        status = None
        for line in block["lines"]:
            m = re.match(r"exit status=(\d+)", line.strip())
            if m:
                status = int(m.group(1))
        if status is not None and status != 0:
            print(f"  FAIL {block['name']}: exit status={status}")

    if f > 0 or not data["autorun_ok"]:
        if not data["autorun_ok"]:
            print("FAIL: autorun did not finish with status=0")
        return 1

    print("PASS")
    return 0


if __name__ == "__main__":
    sys.exit(main())
