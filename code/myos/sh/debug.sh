#!/usr/bin/env bash
# Start QEMU (frozen) + GDB for myos kernel debugging.
#
# Usage:
#   ./sh/debug.sh              # default kernel out/os
#   ./sh/debug.sh out/os       # explicit kernel path
#   GDB_PORT=1235 ./sh/debug.sh
#
# In GDB:
#   break proc_user_run
#   break trap_handler
#   continue
#   info registers
#   bt
#
# Quit: Ctrl-C in GDB, then "quit". QEMU is stopped automatically.

set -euo pipefail

MYOS_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
KERNEL="${1:-${MYOS_KERNEL:-${MYOS_ROOT}/out/os}}"
FW="${OPENSBI_FW:-${MYOS_ROOT}/firmware/fw_jump}"
GDBINIT="${MYOS_ROOT}/sh/gdbinit"
GDB_PORT="${GDB_PORT:-1234}"

QEMU="${QEMU:-qemu-system-riscv64}"
GDB="${GDB:-riscv64-unknown-elf-gdb}"

# Fall back if the cross gdb name differs.
if ! command -v "${GDB}" >/dev/null 2>&1; then
	GDB=gdb-multiarch
fi

QFLAGS="-nographic -serial stdio -display none -monitor none -echr 29"
QFLAGS+=" -smp 1 -machine virt -m 128M"
QFLAGS+=" -S -gdb tcp::${GDB_PORT}"

if [[ ! -f "${KERNEL}" ]]; then
	echo "error: kernel not found: ${KERNEL}" >&2
	echo "hint: run 'make' in ${MYOS_ROOT}" >&2
	exit 1
fi

USE_OPENSBI=0
if [[ "${OPENSBI:-y}" != "n" && -f "${FW}" ]]; then
	USE_OPENSBI=1
fi

if ! command -v "${QEMU}" >/dev/null 2>&1; then
	echo "error: ${QEMU} not found" >&2
	exit 1
fi

if ! command -v "${GDB}" >/dev/null 2>&1; then
	echo "error: ${GDB} not found (install riscv64-unknown-elf-gdb or gdb-multiarch)" >&2
	exit 1
fi

cleanup() {
	if [[ -n "${QEMU_PID:-}" ]] && kill -0 "${QEMU_PID}" 2>/dev/null; then
		kill "${QEMU_PID}" 2>/dev/null || true
		wait "${QEMU_PID}" 2>/dev/null || true
	fi
	stty sane 2>/dev/null || true
}
trap cleanup EXIT INT TERM

echo "myos GDB debug session"
echo "  kernel:   ${KERNEL}"
echo "  gdb port: ${GDB_PORT}"
echo "  gdb:      ${GDB}"
if [[ "${USE_OPENSBI}" -eq 1 ]]; then
	echo "  firmware: ${FW}"
	QEMU_ARGS=(${QFLAGS} -bios "${FW}" -kernel "${KERNEL}")
else
	echo "  boot:     direct M-mode (-bios none)"
	QEMU_ARGS=(${QFLAGS} -kernel "${KERNEL}")
fi
echo "------------------------------------"
echo "QEMU starts frozen (-S). GDB will connect and continue to start_kernel."
echo "Quit GDB with 'quit' to stop QEMU."
echo

# Do not pipe through serial_reader — GDB needs a clean stdio path.
"${QEMU}" "${QEMU_ARGS[@]}" &
QEMU_PID=$!

# Give QEMU a moment to bind the gdb port.
sleep 0.3

exec "${GDB}" "${KERNEL}" -q -ex "target remote :${GDB_PORT}" -x "${GDBINIT}"
