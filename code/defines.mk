# Define macros for conditional compilation.

ifeq (${SYSCALL}, y)
DEFS += -DCONFIG_SYSCALL
endif

ifeq (${OPENSBI}, y)
DEFS += -DCONFIG_OPENSBI
endif
