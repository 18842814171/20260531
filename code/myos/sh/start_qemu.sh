#!/usr/bin/env bash
# Start QEMU for myos.
# OpenSBI: firmware/fw_jump (copied from 5.18, not built here) + kernel out/os

set -euo pipefail

MYOS_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
OSVIZ_ROOT="$(cd "${MYOS_ROOT}/../osviz" && pwd)"
SERIAL_READER="${OSVIZ_ROOT}/bridge/serial_reader.py"
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
	echo "hint: run 'make' in ${MYOS_ROOT}" >&2
	exit 1
fi

run_qemu() {
	echo "myos QEMU"
	echo "  kernel: ${KERNEL}"
	if [[ "${OSVIZ_CAPTURE:-y}" != "n" && -f "${SERIAL_READER}" ]]; then
		echo "  osviz:  ${OSVIZ_ROOT}/events/ (auto recent 10)"
	fi
	echo "  quit:   Ctrl+C  (stops QEMU)"
	echo "          poweroff at login: or myos>"
	echo "------------------------------------"
	if [[ -t 0 ]]; then
		stty -icanon -echo min 1 time 0 2>/dev/null || true
		trap 'stty sane 2>/dev/null || true' EXIT INT TERM
	fi
	if [[ "${OSVIZ_CAPTURE:-y}" != "n" && -f "${SERIAL_READER}" ]]; then
		"${QEMU}" "$@" 2>&1 | python3 "${SERIAL_READER}"
	else
		exec "${QEMU}" "$@"
	fi
}

if [[ "${USE_OPENSBI}" -eq 1 ]]; then
	if [[ ! -f "${FW}" ]]; then
		echo "error: OpenSBI firmware missing: ${FW}" >&2
		echo "hint: place fw_jump.bin there (prebuilt, not managed by make) or set OPENSBI_FW" >&2
		exit 1
	fi
	echo "  firmware: ${FW}  (OpenSBI M→S, prebuilt)"
	run_qemu ${QFLAGS} -bios "${FW}" -kernel "${KERNEL}"
else
	echo "  boot: direct M-mode (-bios none)"
	run_qemu ${QFLAGS} -kernel "${KERNEL}"
fi
