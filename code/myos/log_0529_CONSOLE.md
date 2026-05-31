# 控制台字符传递链（login / shell）

## 总览

```
键盘 (宿主机)
  → 终端 stdin (Cursor / bash)
  → qemu-system-riscv64 进程
  → QEMU 参数 -serial stdio
  → virt 机器上的 NS16550，物理地址 0x10000000
  → 内核 boot/uart.c：MMIO 读/写
  → uart_read_line()
  → usr/console.c：login_session() / shell_loop()
```

**OpenSBI 只负责 M→S 启动和 `poweroff` 的 SBI shutdown，不参与日常字符收发。**

## 分层说明

| 层 | 组件 | 作用 |
|----|------|------|
| 1 | 宿主机键盘 | 用户按键 |
| 2 | 终端 | 通常行缓冲；Enter 产生 `\r` 或 `\n` |
| 3 | `sh/start_qemu.sh` | 启动 `qemu-system-riscv64 -serial stdio ...` |
| 4 | QEMU 16550 | 把 stdio 与 guest UART 对接 |
| 5 | `uart_putc` / `uart_getc` | 写/读 `UART0`（`platform.h` → `0x10000000`） |
| 6 | `uart_read_line` | 回显、退格、遇 `\r`/`\n` 结束一行 |
| 7 | `login_session` | `str_eq(line, "root")`；`poweroff` → `machine_poweroff()` |
| 8 | `shell_loop` | `myos>` 命令解析 |

## 关键函数（按调用顺序）

### 登录

```c
console_run()           // console.c
  → login_session()
       uart_puts("login: ");
       uart_read_line(line, LINE_MAX);   // boot/uart.c — 阻塞到 Enter
       trim_line(line);
       str_eq(line, "root") ? 进入 shell : 重试
```

### 读一行

```c
uart_read_line(buf, maxlen)
  loop:
    c = uart_getc();           // 等 LSR.RX_READY，读 RHR
    if c == '\r' || '\n' → break
    if 可打印 → buf[i++]=c; uart_putc(c);  // 回显
  uart_putc('\n');
  return i;                    // 字符个数；0 表示空行
```

### `login_session` 不等于卡住

- 若 **`uart_read_line` 不返回**：卡在 `uart_getc()`（链条 5–6），不是 `str_eq` 问题。
- 若 **只有空行**：`uart_read_line` 返回 0 → `continue`，你会看到多次换行（每次 Enter 一次）。

## 宿主机：`start_qemu.sh` 必须前台运行 QEMU

若使用 `qemu ... &` 把 QEMU 放到后台，**stdin 由 bash 占用**，按键进不了 guest。终端里看到的 `root` 往往是 **IDE 本地回显**，不是 `uart_putc`。

正确做法：`exec qemu ...`（前台），与管道测试一致：

```bash
printf 'root\r\n' | qemu-system-riscv64 ... -serial stdio ...
# → Welcome, root.  （已实测通过）
```

## 以前为何 login 失败

1. **输出用 SBI `putchar`，输入用 MMIO** — OpenSBI 可能把 SBI 接到 semihosting，而 `-serial stdio` 接 16550，**不是同一条路**。
2. **SBI `getchar` 返回 `0`** — `uart_read_line` 忽略 `NUL`，`uart_getc` 若返回 0 会**死循环**。
3. **空行** — 只收到 `\n` 时 `login_session` 静默 `continue`，表现为多个空行。

## 当前修复

- **收发统一 MMIO 16550**（`boot/uart.c`）
- **QEMU 使用 `-serial stdio -monitor none`**（`sh/start_qemu.sh`）
- **`uart_getc` 丢弃 `0`**
- **`trim_line`** 去掉首尾空白

## 退出

| 方式 | 层级 |
|------|------|
| `poweroff` | guest → `machine_poweroff()` → SBI shutdown |
| `Ctrl+C` | 宿主机 shell trap → 结束 QEMU |
| `Ctrl+]` 再 `X` | QEMU 监视器（当前 `-monitor none` 时不可用） |
