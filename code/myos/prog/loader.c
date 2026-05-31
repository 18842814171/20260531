#include "os.h"
#include "fs.h"
#include "trap_csr.h"

#define ELF_MAGIC  0x464c457fU
#define PT_LOAD    1
#define EM_RISCV   243

#define USER_STACK_TOP 0x80390000UL

struct elf64_ehdr {
	unsigned char e_ident[16];
	uint16_t e_type;
	uint16_t e_machine;
	uint32_t e_version;
	uint64_t e_entry;
	uint64_t e_phoff;
	uint64_t e_shoff;
	uint32_t e_flags;
	uint16_t e_ehsize;
	uint16_t e_phentsize;
	uint16_t e_phnum;
	uint16_t e_shentsize;
	uint16_t e_shnum;
	uint16_t e_shstrndx;
};

struct elf64_phdr {
	uint32_t p_type;
	uint32_t p_flags;
	uint64_t p_offset;
	uint64_t p_vaddr;
	uint64_t p_paddr;
	uint64_t p_filesz;
	uint64_t p_memsz;
	uint64_t p_align;
};

static char file_buf[FS_MAX_SIZE];
struct context user_cxt;
struct context shell_save_cxt;
extern struct context kernel_trap_cxt;

#define USER_CODE_START 0x80380000UL
#define USER_CODE_END   0x80400000UL

int prog_exec_active;
int prog_exec_restore_shell;
void prog_exec_done(void);

extern void switch_to(struct context *next);
extern reg_t kernel_gp_value;

#define PROG_EXEC_FRAME 112

static void context_save_shell(struct context *dst, reg_t resume_pc)
{
	register reg_t ra asm("ra");
	register reg_t sp asm("sp");
	register reg_t gp asm("gp");
	register reg_t tp asm("tp");
	register reg_t s0 asm("s0");
	register reg_t s1 asm("s1");
	register reg_t s2 asm("s2");
	register reg_t s3 asm("s3");
	register reg_t s4 asm("s4");
	register reg_t s5 asm("s5");
	register reg_t s6 asm("s6");
	register reg_t s7 asm("s7");
	register reg_t s8 asm("s8");
	register reg_t s9 asm("s9");
	register reg_t s10 asm("s10");
	register reg_t s11 asm("s11");

	dst->ra = ra;
	dst->sp = sp;
	dst->gp = gp;
	dst->tp = tp;
	dst->s0 = s0;
	dst->s1 = s1;
	dst->s2 = s2;
	dst->s3 = s3;
	dst->s4 = s4;
	dst->s5 = s5;
	dst->s6 = s6;
	dst->s7 = s7;
	dst->s8 = s8;
	dst->s9 = s9;
	dst->s10 = s10;
	dst->s11 = s11;
	dst->pc = resume_pc;
}

static void shell_cxt_clear(struct context *dst)
{
	int i;

	for (i = 0; i < (int)(sizeof(*dst) / sizeof(reg_t)); i++)
		((reg_t *)dst)[i] = 0;
}

/*
 * Capture shell callee-saved state at prog_exec() entry (after the compiler
 * prologue).  sp/s0 must be reconstructed: prog_exec nests inside shell_loop's
 * stack frame, so raw sp/s0 here belong to prog_exec, not shell.
 */
static void shell_cxt_capture(reg_t console_ra, reg_t resume_pc)
{
	reg_t cur_sp;
	reg_t shell_s0;

	shell_cxt_clear(&shell_save_cxt);
	context_save_shell(&shell_save_cxt, resume_pc);
	shell_save_cxt.ra = console_ra;
	shell_save_cxt.gp = kernel_gp_value;

	asm volatile("mv %0, sp" : "=r"(cur_sp));
	shell_s0 = *(reg_t *)(unsigned long)(cur_sp + 96);
	shell_save_cxt.sp = cur_sp + PROG_EXEC_FRAME;
	shell_save_cxt.s0 = shell_s0;
}

static void *load_vaddr(void *file_base, uint64_t vaddr)
{
	(void)file_base;
	return (void *)(unsigned long)vaddr;
}

int prog_exec(const char *path)
{
	struct elf64_ehdr *eh;
	struct elf64_phdr *ph;
	int n, i;
	reg_t entry;
	reg_t console_ra;

	/* Capture shell context before any call clobbers callee-saved regs. */
	asm volatile("mv %0, ra" : "=r"(console_ra));
	shell_cxt_capture(console_ra, (reg_t)prog_exec_done);

	n = fs_read_file(path, file_buf, sizeof(file_buf));
	if (n < (int)sizeof(struct elf64_ehdr)) {
		uart_puts("exec: not found or not executable\n");
		return -1;
	}

	eh = (struct elf64_ehdr *)file_buf;
	if (*(uint32_t *)eh->e_ident != ELF_MAGIC) {
		uart_puts("exec: not an ELF file\n");
		return -1;
	}
	if (eh->e_ident[4] != 2 || eh->e_machine != EM_RISCV) {
		uart_puts("exec: need ELF64 RISC-V\n");
		return -1;
	}

	ph = (struct elf64_phdr *)(file_buf + eh->e_phoff);
	for (i = 0; i < eh->e_phnum; i++) {
		char *dst;
		uint64_t off;
		uint64_t j;

		if (ph[i].p_type != PT_LOAD)
			continue;
		if (ph[i].p_filesz > ph[i].p_memsz) {
			uart_puts("exec: bad segment size\n");
			return -1;
		}
		dst = (char *)load_vaddr(file_buf, ph[i].p_vaddr);
		off = ph[i].p_offset;
		if (off + ph[i].p_filesz > (uint64_t)n) {
			uart_puts("exec: segment out of range\n");
			return -1;
		}
		for (j = 0; j < ph[i].p_filesz; j++)
			dst[j] = file_buf[off + j];
		for (j = ph[i].p_filesz; j < ph[i].p_memsz; j++)
			dst[j] = 0;
	}

	asm volatile("fence.i" ::: "memory");

	entry = (reg_t)eh->e_entry;

	for (i = 0; i < (int)(sizeof(user_cxt) / sizeof(reg_t)); i++)
		((reg_t *)&user_cxt)[i] = 0;
	user_cxt.pc = entry;
	user_cxt.sp = USER_STACK_TOP;

	prog_exec_active = 1;
	prog_exec_restore_shell = 0;
	trap_use_kernel_cxt();
	switch_to(&user_cxt);
	return -1;
}

__attribute__((naked))
void prog_exec_done(void)
{
	asm volatile(
		"mv gp, %0\n"
		"ret\n"
		:
		: "r"(kernel_gp_value)
		: "memory");
}

int prog_is_elf_path(const char *path)
{
	char hdr[8];
	int n;

	n = fs_read_file(path, hdr, sizeof(hdr));
	if (n < 4)
		return 0;
	return *(uint32_t *)hdr == ELF_MAGIC;
}
