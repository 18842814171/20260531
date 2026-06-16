#!/usr/bin/env bash
# Batch guest tests: run prebuilt AUTORUN=test kernel, judge serial output.
# Build first:  make AUTORUN=test DEBUG=0
# Usage: ./sh/run_batch.sh [timeout_seconds]

set -euo pipefail

MYOS_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TIMEOUT="${1:-120}"
LOG="${MYOS_BATCH_LOG:-${MYOS_ROOT}/out/batch.log}"
JUDGE="${MYOS_ROOT}/tests/judge_batch.py"
KERNEL="${MYOS_ROOT}/out/os"

cd "$MYOS_ROOT"
mkdir -p "${MYOS_ROOT}/out"

if [[ ! -f "${KERNEL}" ]]; then
	echo "error: ${KERNEL} not found" >&2
	echo "hint: make AUTORUN=test DEBUG=0" >&2
	exit 1
fi

echo "== batch: QEMU (timeout ${TIMEOUT}s, kernel ${KERNEL}) =="
MYOS_QUIET=1 DEBUG=n timeout --foreground "${TIMEOUT}" ./sh/start_qemu.sh </dev/null 2>&1 | tee "${LOG}" || true

echo "== batch: judge =="
python3 "${JUDGE}" "${LOG}"
exit $?
