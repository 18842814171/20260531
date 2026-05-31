#!/bin/bash
set -e

CMD=${1:-}
FILE=${2:-}
USR_DIR="$(cd "$(dirname "$0")" && pwd)"
MYOS_ROOT="$(cd "$USR_DIR/.." && pwd)"
HOME_DIR="$MYOS_ROOT/home/root"

CC="${RV64_CC:-riscv64-unknown-elf-gcc}"
OBJDUMP="${RV64_OBJDUMP:-riscv64-unknown-elf-objdump}"

ARCH_CFLAGS="-march=rv64gc -mabi=lp64 -mcmodel=medany"
USER_CFLAGS="-ffreestanding -nostdlib -fno-builtin -static -Wall -g"
USER_CFLAGS+=" $ARCH_CFLAGS -I $MYOS_ROOT/include"
USER_LDFLAGS="-nostdlib -static -T $USR_DIR/user.ld"

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

build_guest_c() {
	local src="$1"
	local base=$(basename "$src" .c)
	local out="$HOME_DIR/$base"
	
	mkdir -p "$HOME_DIR"
	"$CC" $USER_CFLAGS $USER_LDFLAGS -o "$out" "$USR_DIR/crt0.S" "$src"
}

case "$CMD" in
	c)
		if [[ -z "$FILE" ]]; then
			echo "用法: $0 c <文件名>"
			exit 1
		fi
		SRC=$(resolve_src "$FILE")
		build_guest_c "$SRC"
		echo "OK: $(basename "$SRC" .c)"
		;;
	dump)
		if [[ -z "$FILE" ]]; then
			echo "用法: $0 dump <文件>"
			exit 1
		fi
		if [[ ! -f "$FILE" ]]; then
			echo "文件不存在: $FILE"
			exit 1
		fi
		BASENAME=$(basename "$FILE")
		BASENAME="${BASENAME%.*}"
		OUTPUT_FILE="${BASENAME}.s"
		"$OBJDUMP" -d "$FILE" > "$OUTPUT_FILE"
		echo "Saved to: $OUTPUT_FILE"
		;;
	*)
		echo "用法: $0 <command> [file]"
		echo ""
		echo "命令:"
		echo "  c     <file.c>   编译裸机 ELF"
		echo "  dump  <file>     反汇编"
		exit 1
		;;
esac
