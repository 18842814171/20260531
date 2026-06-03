# T202510003995291-2331 — Trap & UART Summary

Reference tree: **ArceOS** (Rust monolithic kernel) under `T202510003995291-2331/arceos/`.  
Default competition build targets **riscv64** and **loongarch64** (`Makefile` `test_build`).

---

## 1. Project shape (relevant to myos)

| Aspect | Reference (T202510…) | myos |
|--------|----------------------|------|
| Language | Rust (axhal / axruntime) | C |
| RISC-V console I/O | **SBI** (`sbi_rt::console_*`), not MMIO 16550 | **MMIO NS16550** at `0x10000000` |
| RISC-V UART IRQ | **Not implemented** (PLIC TODO) | PLIC wired; UART IRQ **disabled** |
| Trap entry | `sscratch` swap, separate S/U paths | `sscratch` + `kernel_trap_cxt` frame |
| Keyboard / stdin | Blocking read loop + yield (uspace) | Shell polls `uart_getc` in kernel |

**Bottom line for myos:** trap *ideas* are useful; the **riscv64 UART path is not a drop-in reference** for myos (different transport, no PLIC keyboard IRQ).

---

## 2. Trap system (RISC-V)

### 2.1 Vector entry (`trap.S`)

Uses **`sscratch` to distinguish S-mode vs U-mode** traps:

- `sscratch == 0` → trap from supervisor → save on current `sp`
- `sscratch != 0` → trap from user → swap `sp` with `sscratch`, save user `sp` in frame

```53:77:T202510003995291-2331/arceos/modules/axhal/src/arch/riscv/trap.S
.global trap_vector_base
trap_vector_base:
    // sscratch == 0: trap from S mode
    // sscratch != 0: trap from U mode
    csrrw   sp, sscratch, sp            // swap sscratch and sp
    bnez    sp, .Ltrap_entry_u

    csrr    sp, sscratch                // put supervisor sp back
    j       .Ltrap_entry_s

.Ltrap_entry_s:
    SAVE_REGS 0
    mv      a0, sp
    li      a1, 0
    call    riscv_trap_handler
    RESTORE_REGS 0
    sret

.Ltrap_entry_u:
    SAVE_REGS 1
    mv      a0, sp
    li      a1, 1
    call    riscv_trap_handler
    RESTORE_REGS 1
    sret
```

`SAVE_REGS` / `RESTORE_REGS` macros store `sepc`, `sstatus`, all GPRs; user path also swaps `gp`/`tp` with kernel values.

### 2.2 Trap frame (C layout)

Fixed `TrapFrame`: 31 GPRs + `sepc` + `sstatus` (matches myos `struct context` + `pc` idea):

```66:76:T202510003995291-2331/arceos/modules/axhal/src/arch/riscv/context.rs
/// Saved registers when a trap (interrupt or exception) occurs.
#[repr(C)]
#[derive(Debug, Default, Clone, Copy)]
pub struct TrapFrame {
    /// All general registers.
    pub regs: GeneralRegisters,
    /// Supervisor Exception Program Counter.
    pub sepc: usize,
    /// Supervisor Status Register.
    pub sstatus: usize,
}
```

### 2.3 C trap handler (`trap.rs`)

Flow:

1. Read `scause`, classify interrupt vs exception
2. **Exceptions only:** optionally re-enable IRQs if `SPIE` was set (`unmask_irqs`)
3. Dispatch: `UserEnvCall` → syscall, page faults, breakpoint, **Interrupt** → IRQ slice
4. `post_trap_callback` (hooks)
5. `mask_irqs` before return to assembly

```41:84:T202510003995291-2331/arceos/modules/axhal/src/arch/riscv/trap.rs
#[unsafe(no_mangle)]
fn riscv_trap_handler(tf: &mut TrapFrame, from_user: bool) {
    let scause = scause::read();
    if let Ok(cause) = scause.cause().try_into::<I, E>() {
        let vaddr = va!(stval::read());
        if scause.is_exception() {
            unmask_irqs(tf);
        }
        match cause {
            #[cfg(feature = "uspace")]
            Trap::Exception(E::UserEnvCall) => {
                tf.sepc += 4;
                tf.regs.a0 = crate::trap::handle_syscall(tf, tf.regs.a7) as usize;
            }
            // ... page faults, breakpoint ...
            Trap::Interrupt(_) => {
                handle_trap!(IRQ, scause.bits());
            }
            _ => { panic!(/* ... */); }
        }
        crate::trap::post_trap_callback(tf, from_user);
        mask_irqs();
    } else {
        panic!(/* ... */);
    }
}
```

IRQ dispatch uses a **linkme distributed slice** (`IRQ`, `PAGE_FAULT`, `POST_TRAP`) — modular, unlike myos’s single `trap_handler`.

### 2.4 RISC-V IRQ routing (`riscv64_qemu_virt/irq.rs`)

Timer / soft / external IRQs are distinguished by **`scause` code**, not PLIC claim (for external):

```67:76:T202510003995291-2331/arceos/modules/axhal/src/platform/riscv64_qemu_virt/irq.rs
pub fn dispatch_irq(scause: usize) {
    with_cause!(
        scause,
        @TIMER => {
            trace!("IRQ: timer");
            TIMER_HANDLER();
        },
        @EXT => crate::irq::dispatch_irq_common(0), // TODO: get IRQ number from PLIC
    );
}
```

PLIC enable and external IRQ source decoding are **explicit TODOs** — same feature myos needs for keyboard IRQ, but **not finished in the reference on riscv64**.

Timer on riscv64 uses **SBI `set_timer`**, same family as myos OpenSBI path.

---

## 3. UART / console system

### 3.1 riscv64 (primary competition arch) — SBI console

**No NS16550 registers.** All I/O goes through OpenSBI:

```9:11:T202510003995291-2331/arceos/modules/axhal/src/platform/riscv64_qemu_virt/console.rs
pub fn putchar(c: u8) {
    sbi_rt::console_write_byte(c);
}
```

```55:62:T202510003995291-2331/arceos/modules/axhal/src/platform/riscv64_qemu_virt/console.rs
pub fn read_bytes(bytes: &mut [u8]) -> usize {
    sbi_rt::console_read(sbi_rt::Physical::new(
        bytes.len().min(MAX_RW_SIZE),
        virt_to_phys(VirtAddr::from_mut_ptr_of(bytes.as_mut_ptr())).as_usize(),
        0,
    ))
    .value
}
```

Properties:

- **Non-blocking read** (`read_bytes` returns 0 if nothing available)
- **No ring buffer, no PLIC, no IER**
- `\n` handling done at API layer (`\r` → `\n` on read)

```22:29:T202510003995291-2331/arceos/api/arceos_api/src/imp/mod.rs
    pub fn ax_console_read_bytes(buf: &mut [u8]) -> crate::AxResult<usize> {
        let len = axhal::console::read_bytes(buf);
        for c in &mut buf[..len] {
            if *c == b'\r' {
                *c = b'\n';
            }
        }
        Ok(len)
    }
```

User stdin blocks by **yielding** until data arrives (`axstd` `Stdin::read`), not by spinning on LSR.

### 3.2 x86_64 — 16550 MMIO, **poll only**

Closest *hardware* UART pattern in the reference, but **x86 I/O ports**, not virt MMIO:

```72:81:T202510003995291-2331/arceos/modules/axhal/src/platform/x86_pc/uart16550.rs
    fn putchar(&mut self, c: u8) {
        while !self.line_sts().contains(LineStsFlags::OUTPUT_EMPTY) {}
        unsafe { self.data.write(c) };
    }

    fn getchar(&mut self) -> Option<u8> {
        if self.line_sts().contains(LineStsFlags::INPUT_FULL) {
            unsafe { Some(self.data.read()) }
        } else {
            None
        }
    }
```

Init: disable interrupts, 8N1, FIFO enable — **no RX IRQ registration**.

### 3.3 loongarch64 — ns16550a MMIO, **poll only**

Same QEMU-style MMIO base pattern as myos; still **no IRQ path** in console:

```29:36:T202510003995291-2331/arceos/modules/axhal/src/platform/loongarch64_qemu_virt/console.rs
pub fn read_bytes(bytes: &mut [u8]) -> usize {
    for (i, byte) in bytes.iter_mut().enumerate() {
        match UART.lock().get() {
            Some(c) => *byte = c,
            None => return i,
        }
    }
    bytes.len()
}
```

### 3.4 aarch64 — PL011 with optional IRQ (only fully wired UART-IRQ example)

Has `init_irq`, GIC enable, and ISR that reads and echoes — **not used on riscv64**:

```64:72:T202510003995291-2331/arceos/modules/axhal/src/platform/aarch64_common/pl011.rs
pub fn handle() {
    let is_receive_interrupt = UART.lock().is_receive_interrupt();
    UART.lock().ack_interrupts();
    if is_receive_interrupt {
        while let Some(c) = getchar() {
            putchar(c);
        }
    }
}
```

---

## 4. Comparison with myos (current)

### myos trap (abbreviated)

myos uses a **single `trap_vector`** with manual user/kernel frame selection, deferred IRQ re-enable (`trap_reenable_irq` after `reg_restore`), and PLIC dispatch for external IRQ including a stub `uart_isr`:

```113:159:code/myos/interrupt/entry.S
trap_vector:
	csrrw	t6, CSR_SCRATCH, t6
	/* ... user vs kernel frame via EPC range ... */
	reg_save t6
	/* ... call trap_handler on kernel stack for user traps ... */
	call	trap_handler
	/* ... reg_restore, trap_reenable_irq, sret ... */
```

```86:100:code/myos/interrupt/trap.c
void external_interrupt_handler()
{
	int irq = plic_claim();
	if (irq == UART0_IRQ) {
		uart_isr();
	} else if (irq) {
		printf("unexpected interrupt irq = %d\n", irq);
	}
	if (irq)
		plic_complete(irq);
}
```

### myos UART (abbreviated)

Direct MMIO 16550, **dual RX path** (IRQ ring vs poll) with poll active:

```221:231:code/myos/boot/uart.c
void uart_irq_enable(void)
{
	uart_rx_use_irq = 0;
	uart_write_reg(UART_IER, 0x00);
	osviz_event("irq", "uart_init", "\"rx_irq\":false,\"rx_poll\":true");
}
```

```259:281:code/myos/boot/uart.c
int uart_getc(void)
{
	for (;;) {
		if (uart_rx_use_irq) {
			c = uart_rx_get();
			/* ... */
		}
		while ((uart_read_reg(UART_LSR) & UART_LSR_RX_READY) == 0)
			;
		c = uart_read_reg(UART_RHR);
		/* ... */
	}
}
```

---

## 5. What is / is not suitable to copy

| Topic | Suitable from reference? | Notes |
|-------|-------------------------|-------|
| `sscratch` U/S trap split | **Partially** | Same idea; myos adds per-process frame + exit trampoline |
| Defer IRQ until after restore | **Yes (concept)** | Reference masks at end of handler; myos uses `trap_reenable_irq` flag |
| riscv64 console driver | **No** | SBI vs MMIO — different stack entirely |
| Keyboard IRQ + ring | **No on riscv64** | PLIC/UART IRQ unfinished in reference |
| 16550 init / LSR poll TX/RX | **Partially** | x86/loongarch poll patterns only |
| Line discipline (`\r`→`\n`) | **Yes** | Do in one layer, not scattered |
| Non-blocking `read` + block in shell | **Yes** | Cleaner than busy-wait inside driver |

---

## 6. One-paragraph verdict

**T202510003995291-2331 is an ArceOS competition kernel, not a C MMIO-UART teaching OS.** For **riscv64** (myos’s QEMU/OpenSBI target), console I/O bypasses the 16550 via **SBI**, and **PLIC keyboard interrupts are TODO**. Trap handling shares the RISC-V `sscratch` user/supervisor split with myos but is simpler (no myos-style user-exit trampoline or nested-frame bugs). Use the reference for **trap framing and IRQ-deferral philosophy**; for **UART**, prefer **loongarch/x86 poll-only 16550** snippets or myos’s own hardware docs — **not** the riscv64 SBI console path.
