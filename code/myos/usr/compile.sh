#!/bin/bash
set -e

CMD=${1:-}
FILE=${2:-}
USR_DIR="$(cd "$(dirname "$0")" && pwd)"
MYOS_ROOT="$(cd "$USR_DIR/.." && pwd)"
HOME_DIR="$MYOS_ROOT/home/root"
ULIB_DIR="$USR_DIR/out"

CC="${RV64_CC:-riscv64-unknown-elf-gcc}"
OBJDUMP="${RV64_OBJDUMP:-riscv64-unknown-elf-objdump}"

ARCH_CFLAGS="-march=rv64gc -mabi=lp64 -mcmodel=medany"
USER_CFLAGS="-ffreestanding -nostdlib -fno-builtin -static -Wall -Os"
USER_CFLAGS+=" $ARCH_CFLAGS -I $USR_DIR/include"
USER_CFLAGS+=" -fno-builtin-printf -fno-builtin-fprintf"
USER_CFLAGS+=" -fno-builtin-strlen -fno-builtin-memset -fno-builtin-memcpy"
USER_LDFLAGS="-nostdlib -static -T $MYOS_ROOT/ld/user.ld"

ULIB_OBJS="$ULIB_DIR/ulib.o $ULIB_DIR/usys.o $ULIB_DIR/printf.o"

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

build_ulib() {
	mkdir -p "$ULIB_DIR"
	"$CC" $USER_CFLAGS -c -o "$ULIB_DIR/ulib.o" "$USR_DIR/ulib.c"
	"$CC" $USER_CFLAGS -c -o "$ULIB_DIR/usys.o" "$USR_DIR/usys.S"
	"$CC" $USER_CFLAGS -c -o "$ULIB_DIR/printf.o" "$USR_DIR/printf.c"
}

build_guest_c() {
	local src="$1"
	local base=$(basename "$src" .c)
	local out="$HOME_DIR/$base"

	build_ulib
	mkdir -p "$HOME_DIR"
	"$CC" $USER_CFLAGS -c -o "$ULIB_DIR/$base.o" "$src"
	"$CC" $USER_CFLAGS $USER_LDFLAGS -o "$out" \
		"$USR_DIR/crt0.S" "$ULIB_DIR/$base.o" $ULIB_OBJS
	"${RV64_STRIP:-riscv64-unknown-elf-strip}" -s "$out"
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
		echo "  c     <file.c>   编译裸机 ELF (crt0 + libuser)"
		echo "  dump  <file>     反汇编"
		exit 1
		;;
esac
