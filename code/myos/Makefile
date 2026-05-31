# myos — task.md modules: boot, interrupt, mem, proc, fs, usr

SYSCALL = y
OPENSBI ?= y

include ../defines.mk

RISCV_PREFIX ?= /opt/riscv
CROSS_COMPILE ?= $(RISCV_PREFIX)/bin/riscv64-unknown-elf-
export PATH := $(RISCV_PREFIX)/bin:$(PATH)

ifeq (${OPENSBI}, y)
ARCH_CFLAGS = -march=rv64gc -mabi=lp64 -mcmodel=medany
QEMU = qemu-system-riscv64
QMEM = -m 128M
else
ARCH_CFLAGS = -march=rv32g -mabi=ilp32
QEMU = qemu-system-riscv32
QMEM =
endif

CFLAGS += -nostdlib -fno-builtin -g -Wall
CFLAGS += $(ARCH_CFLAGS)
CFLAGS += -I include

QFLAGS = -nographic -smp 1 -machine virt $(QMEM)

OUTPUT_PATH = out
LDSCRIPT = boot/os.ld
LDSCRIPT_GEN = $(OUTPUT_PATH)/os.ld.generated
KERNEL = $(OUTPUT_PATH)/os
FW_JUMP = firmware/fw_jump
HOME_DATA = fs/home_data.c

SRCS_ASM = \
	boot/start.S \
	boot/mem.S \
	interrupt/entry.S \
	usr/usys.S

SRCS_C = \
	boot/kernel.c \
	boot/uart.c \
	boot/power.c \
	boot/printf.c \
	boot/osviz_k.c \
	boot/stats.c \
	interrupt/trap.c \
	interrupt/timer.c \
	interrupt/plic.c \
	mem/page.c \
	proc/sched.c \
	proc/lock.c \
	proc/proc.c \
	proc/syscall.c \
	prog/loader.c \
	fs/fs.c \
	fs/home_data.c \
	usr/user.c \
	usr/console.c \
	usr/script.c \
	usr/vi.c

OBJS_ASM := $(patsubst %.S,$(OUTPUT_PATH)/%,$(SRCS_ASM))
OBJS_C   := $(patsubst %.c,$(OUTPUT_PATH)/%,$(SRCS_C))
OBJS     := $(OBJS_ASM) $(OBJS_C)

.PHONY: build run debug code clean fw home pack

build: fw home $(OUTPUT_PATH) $(KERNEL)

home: $(HOME_DATA)

$(HOME_DATA): home/root/*
	python3 tools/pack_home.py

pack:
	python3 tools/pack_home.py

# OpenSBI：预编译固件，从 5.18 输出目录复制，不在此项目内编译
FW_SRC ?= $(HOME)/5.18/build-linux-system-from-scratch/output/images/fw_jump.bin

.DEFAULT_GOAL := build

$(OUTPUT_PATH):
	@mkdir -p $@

$(KERNEL): $(OBJS) $(LDSCRIPT)
	$(CROSS_COMPILE)gcc -E -P -x c $(DEFS) $(CFLAGS) -I include $(LDSCRIPT) > $(LDSCRIPT_GEN)
	$(CROSS_COMPILE)gcc $(CFLAGS) -T $(LDSCRIPT_GEN) -o $(KERNEL) $(OBJS)

$(OUTPUT_PATH)/%: %.S
	@mkdir -p $(dir $@)
	$(CROSS_COMPILE)gcc $(DEFS) $(CFLAGS) -c -o $@ $<

$(OUTPUT_PATH)/%: %.c
	@mkdir -p $(dir $@)
	$(CROSS_COMPILE)gcc $(DEFS) $(CFLAGS) -c -o $@ $<

clean:
	rm -rf $(OUTPUT_PATH) fs/home_data.c
