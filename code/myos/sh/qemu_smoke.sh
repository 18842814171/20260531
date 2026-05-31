#!/usr/bin/env bash
# Non-interactive smoke test: login, ./hi, ps, poweroff.
# Syncs on prompts (coproc) to avoid login garbage on -serial stdio.

set -euo pipefail

MYOS_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
export OSVIZ_CAPTURE=n
export TRAP_DIAG_VERBOSE=0

cd "${MYOS_ROOT}"
[[ -f out/os ]] || { echo "hint: run make in ${MYOS_ROOT}" >&2; exit 1; }

stage=0
coproc QEMU ( ./sh/start_qemu.sh 2>&1 )
exec 3>&"${QEMU[1]}"

while IFS= read -r -t 45 -u "${QEMU[0]}" line || [[ -n "${line:-}" ]]; do
	printf '%s\n' "$line"
	case "$stage" in
	0)
		# login: prompt has no newline until Enter
		if [[ "$line" == *"myos console"* ]] || [[ "$line" == *"Log in at"* ]]; then
			# Kernel uart_rx_flush() runs after this line; wait for login:
			sleep 1
			printf 'root\r\n' >&3
			stage=1
		fi
		;;
	1)
		if [[ "$line" == *Welcome* ]] || [[ "$line" == *'root@'*'$ '* ]]; then
			printf './hi\r\n' >&3
			stage=2
		fi
		;;
	2)
		if [[ "$line" == *'root@'*'$ '* ]]; then
			printf 'ps\r\n' >&3
			stage=3
		fi
		;;
	3)
		if [[ "$line" == *'root@'*'$ '* ]]; then
			printf 'poweroff\r\n' >&3
			stage=4
		fi
		;;
	4)
		if [[ "$line" == *poweroff* ]] || [[ "$line" == *Shutdown* ]]; then
			break
		fi
		;;
	esac
done

exec 3>&-
kill "${QEMU_PID}" 2>/dev/null || true
wait "${QEMU_PID}" 2>/dev/null || true

if [[ "$stage" -lt 4 ]]; then
	echo "smoke: failed at stage $stage" >&2
	exit 1
fi
echo "smoke: ok"
