#!/usr/bin/env bash
# Pipe-driven console smoke test (non-interactive).
# Usage: ./sh/test-console-pipe.sh
set -euo pipefail

MYOS_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "${MYOS_ROOT}"

make build >/dev/null

OUT="$(mktemp)"
trap 'rm -f "${OUT}"' EXIT

timeout 22 bash -c '
  sleep 4
  printf "root\r\nls\r\npwd\r\nvi 1.txt\r\nline one\r\n:wq\r\ncat 1.txt\r\npoweroff\r\n"
' | ./sh/start_qemu.sh 2>&1 >"${OUT}" || true

fail=0
grep -q 'Welcome, root' "${OUT}" || { echo "FAIL: login"; fail=1; }
grep -q '/home/root:' "${OUT}" || { echo "FAIL: ls listing"; fail=1; }
grep -q '/home/root' "${OUT}" || { echo "FAIL: pwd"; fail=1; }
grep -q 'vi: saved' "${OUT}" || { echo "FAIL: vi save"; fail=1; }
grep -q 'line one' "${OUT}" || { echo "FAIL: cat after vi"; fail=1; }
grep -q 'Shutting down myos' "${OUT}" || { echo "FAIL: poweroff"; fail=1; }

if [[ "${fail}" -eq 0 ]]; then
  echo "console pipe test: OK"
  exit 0
fi
echo "log: ${OUT}"
exit 1
