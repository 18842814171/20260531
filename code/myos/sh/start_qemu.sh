#!/usr/bin/env bash
# Start QEMU for myos.
# OpenSBI: firmware/fw_jump (copied from 5.18, not built here) + kernel out/os

set -euo pipefail

MYOS_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
KERNEL="${1:-${MYOS_KERNEL:-${MYOS_ROOT}/out/os}}"
FW="${OPENSBI_FW:-${MYOS_ROOT}/firmware/fw_jump}"

QEMU_COMMON="-nographic -serial stdio -display none -monitor none -echr 29"

USE_OPENSBI=0
if [[ "${OPENSBI:-y}" != "n" && -f "${FW}" ]]; then
	USE_OPENSBI=1
	QEMU="${QEMU:-qemu-system-riscv64}"
	QFLAGS="${QFLAGS:-${QEMU_COMMON} -smp 1 -machine virt -m 128M}"
else
	QEMU="${QEMU:-qemu-system-riscv32}"
	QFLAGS="${QFLAGS:-${QEMU_COMMON} -smp 1 -machine virt -bios none}"
fi

if ! command -v "${QEMU}" >/dev/null 2>&1; then
	echo "error: ${QEMU} not found" >&2
	exit 1
fi

if [[ ! -f "${KERNEL}" ]]; then
	echo "error: kernel not found: ${KERNEL}" >&2
	echo "hint: run 'make build' in ${MYOS_ROOT}" >&2
	exit 1
fi

run_qemu() {
	echo "myos QEMU"
	echo "  kernel: ${KERNEL}"
	echo "  quit:   Ctrl+C  (stops QEMU)"
	echo "          poweroff at login: or myos>"
	echo "------------------------------------"
	if [[ -t 0 ]]; then
		stty -icanon -echo min 1 time 0 2>/dev/null || true
		trap 'stty sane 2>/dev/null || true' EXIT INT TERM
	fi
	exec "$@"
}

if [[ "${USE_OPENSBI}" -eq 1 ]]; then
	if [[ ! -f "${FW}" ]]; then
		echo "error: OpenSBI firmware missing: ${FW}" >&2
		echo "hint: run 'make fw' (copies from ~/5.18/.../fw_jump.bin) or set OPENSBI_FW" >&2
		exit 1
	fi
	echo "  firmware: ${FW}  (OpenSBI M→S, prebuilt)"
	run_qemu "${QEMU}" ${QFLAGS} -bios "${FW}" -kernel "${KERNEL}"
else
	echo "  boot: direct M-mode (-bios none)"
	run_qemu "${QEMU}" ${QFLAGS} -kernel "${KERNEL}"
fi
