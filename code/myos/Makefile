# myos kernel — 重要原则 #8:
#   make          default full build (OpenSBI + syscalls + osviz logging)
#   make DEBUG=0  same kernel, compile-time logging off
#   make clean

RISCV_PREFIX ?= /opt/riscv
CROSS_COMPILE ?= $(RISCV_PREFIX)/bin/riscv64-unknown-elf-
export PATH := $(RISCV_PREFIX)/bin:$(PATH)

DEBUG ?= 1

DEFS := -DCONFIG_SYSCALL -DCONFIG_OPENSBI
ifeq ($(DEBUG),0)
DEFS += -DCONFIG_LOG=0
else
DEFS += -DCONFIG_LOG=1
endif
ifdef AUTORUN
DEFS += -DCONFIG_AUTORUN=\"$(AUTORUN)\"
endif

ARCH_CFLAGS := -march=rv64gc -mabi=lp64 -mcmodel=medany
CFLAGS := -nostdlib -fno-builtin -g -Wall $(ARCH_CFLAGS) -I include

OUTPUT_PATH := out
KERNEL := $(OUTPUT_PATH)/os
LDSCRIPT := ld/os.ld
LDSCRIPT_GEN := $(OUTPUT_PATH)/os.ld.generated
HOME_DATA := fs/home_data.c
HOME_EMBED := fs/home_embed.S

SRCS_ASM := $(filter-out boot/hello_opensbi.S usr/crt0.S,\
	$(wildcard boot/*.S interrupt/*.S usr/*.S))
SRCS_C := $(wildcard boot/*.c interrupt/*.c mem/*.c proc/*.c fs/*.c usr/*.c)
SRCS_C := $(filter-out fs/home_data.c,$(SRCS_C)) fs/home_data.c

OBJS_ASM := $(patsubst %.S,$(OUTPUT_PATH)/%,$(SRCS_ASM))
OBJS_C := $(patsubst %.c,$(OUTPUT_PATH)/%,$(SRCS_C))
OBJS := $(OBJS_ASM) $(OBJS_C) $(OUTPUT_PATH)/fs/home_embed

.PHONY: all clean userprogs

all: userprogs $(HOME_DATA) $(HOME_EMBED) $(OUTPUT_PATH) $(KERNEL)

# Cross-compile guest ELFs in home/root/*.c → home/root/<name> (not done by gcc -c rules).
userprogs:
	@for f in home/root/*.c; do \
		[ -f "$$f" ] || continue; \
		./usr/compile.sh c "$$(basename "$$f")" || exit 1; \
	done

$(HOME_DATA) $(HOME_EMBED): home/root/*
	python3 tools/pack_home.py

$(OUTPUT_PATH):
	@mkdir -p $@

$(KERNEL): $(HOME_DATA) $(HOME_EMBED) $(OBJS) $(LDSCRIPT)
	$(CROSS_COMPILE)gcc -E -P -x c $(DEFS) $(CFLAGS) $(LDSCRIPT) > $(LDSCRIPT_GEN)
	$(CROSS_COMPILE)gcc $(DEFS) $(CFLAGS) -T $(LDSCRIPT_GEN) -o $(KERNEL) $(OBJS)

$(OUTPUT_PATH)/%: %.S
	@mkdir -p $(dir $@)
	$(CROSS_COMPILE)gcc $(DEFS) $(CFLAGS) -c -o $@ $<

$(OUTPUT_PATH)/%: %.c
	@mkdir -p $(dir $@)
	$(CROSS_COMPILE)gcc $(DEFS) $(CFLAGS) -c -o $@ $<

clean:
	rm -rf $(OUTPUT_PATH) $(HOME_DATA) $(HOME_EMBED)
