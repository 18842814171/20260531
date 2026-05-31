#!/bin/bash
set -e

CMD=${1:-}
FILE=${2:-}
USR_DIR="$(cd "$(dirname "$0")" && pwd)"
MYOS_ROOT="$(cd "$USR_DIR/.." && pwd)"
HOME_DIR="$MYOS_ROOT/home/root"

CC="${RV64_CC:-riscv64-unknown-elf-gcc}"

ARCH_CFLAGS="-march=rv64gc -mabi=lp64 -mcmodel=medany"
USER_CFLAGS="-ffreestanding -nostdlib -fno-builtin -static -Wall -g"
USER_CFLAGS+=" $ARCH_CFLAGS -I $MYOS_ROOT/include"
USER_LDFLAGS="-nostdlib -static -T $USR_DIR/user.ld"

if [[ "$CMD" != "c" || -z "$FILE" ]]; then
	echo "用法: $0 c <文件名>"
	exit 1
fi

resolve_src() {
	local f="$1"
	local base="${f%.c}"

	if [[ -f "$HOME_DIR/$f" ]]; then
		echo "$HOME_DIR/$f"
		return
	fi
	if [[ -f "$HOME_DIR/${base}.c" ]]; then
		echo "$HOME_DIR/${base}.c"
		return
	fi
	echo "找不到源文件: $f" >&2
	exit 1
}

SRC=$(resolve_src "$FILE")
BASE=$(basename "$SRC" .c)
OUT="$HOME_DIR/$BASE"

mkdir -p "$HOME_DIR"
"$CC" $USER_CFLAGS $USER_LDFLAGS -o "$OUT" "$USR_DIR/crt0.S" "$SRC"
echo "OK: $BASE"
