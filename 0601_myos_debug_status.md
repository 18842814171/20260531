## 1. 目标与范围

| 目标 | 状态 |
|------|------|
| 登录前 console 可读、能输入 `root` | **已基本达成**（轮询 UART + 分流修复后） |
| 内置 shell 命令（`pwd`、`ls` 等） | **`pwd` 已验证可回到 prompt** |
| 用户程序 `./hi` / `./file_rw` / `./spin` 执行后回到 `root@...$` | **未达成**（`./hi` 仍触发内核 panic） |
| `task.md` 中的键盘中断（IRQ+ring） | **刻意未启用**；当前保持 **RX 轮询** |

---

## 2. 当前可复现现象

### 2.1 正常路径

```text
make && DEBUG=n ./sh/start_qemu.sh
→ login: root
→ Welcome
→ pwd
→ 输出 /home/root
→ 回到 root@/home/root$
```

### 2.2 失败路径（阻塞项）

```text
./hi
→ Sync exception code = 2 at 0x0000000080200254
→ panic("OOPS! What can I do!")
```

- **异常类型**：`scause` code **2** = Illegal instruction  
- **故障 PC**：`0x80200254`，位于 `trap_vector` 的 **`reg_restore` 宏**内（`objdump` 对应 `ld a6, 120(t6)`）  
- **典型 CSR 快照**（panic 时）：`sepc=0x80200254`，`stval=0`，`sscratch=kernel_trap_cxt`，`sstatus` 含 S-mode 相关位  

说明：问题出在 **从 trap 返回、恢复寄存器帧** 的阶段，而不是用户 ELF 加载地址错误（`hi` 的 LOAD 已在 `0x80380000`）。

### 2.3 测试方式注意

| 方式 | 说明 |
|------|------|
| `DEBUG=n ./sh/start_qemu.sh` | **推荐**：`-serial stdio` 可交互 |
| `DEBUG=y` 或管道自动化 | 经管道时 **无法手打输入**；输出可能停在半行 `LOG {"ts_m...`（作业被 stop，非内核死在 `page_init`） |
| 自动化脚本 | 须在见到 **`Welcome` 且 `root@/home/root$`** 后再发 `./hi`；过早发送会变成 `Unknown command` 或读行超时 |

---

## 3. 已确认结论（实验与代码）

### 3.1 UART / console

| 结论 | 依据 |
|------|------|
| **ring + `uart_rx_unget` 不是 login 乱码主因** | 按 `problemrecord.txt` 做纯 `LSR/RHR` 轮询实验，仍可能读到垃圾字节 |
| **polling 与 IRQ 路径必须分离** | `uart_getc` / `uart_read_buf` / `uart_read_line` / `uart_drain_echo_prefix` 按 `uart_rx_use_irq` 分支 |
| **polling 下 `\r` 后不能排空整个 RX FIFO** | 否则 `-serial stdio` 回环导致 **shell 永久阻塞** |
| **`uart_read_line` 每字节 `[xx]` 十六进制回显会加剧回环** | 已去掉逐字节 `uart_putc` 调试回显 |
| **当前 RX 模式** | `uart_irq_enable()` 关 IER，`uart_rx_use_irq=0`，`plic` UART RX 关闭，console **纯轮询** |

### 3.2 Trap / 用户态（相对 `0531log.md` 旧方案）

旧树使用 `prog/loader.c` + `shell_cxt_capture`；**当前树已改为**：

```text
proc_spawn_exec_wait()
  → proc_user_run(child)     // switch_to 进用户态
  → proc_wait()              // 等子进程 zombie
```

用户退出路径：

```text
SYS_exit (ecall)
  → proc_user_exit()
  → sepc = user_exit_trampoline
  → trap_vector：proc_user_exit_pending → 恢复 kernel_user_exit_cxt → sret
  → user_exit_trampoline：恢复 gp/sp，jr user_kernel_ra 回 shell
```

相关文件：

- `interrupt/entry.S` — `trap_vector`、`switch_to`
- `interrupt/trap.c` — `SYS_exit`、`trap_reenable_irq`
- `proc/proc_user.c` — ELF 加载、`proc_user_run`、`user_exit_trampoline`

### 3.3 已合入的内核修复（摘要）

| 修改 | 目的 |
|------|------|
| `entry.S` **`.option norvc`** | 避免 `trap_vector` 尾部被 RVC 压缩错位 → 曾出现 `illegal instruction` |
| `proc_user_exit_pending`：**`lw` 后再 `beqz`** | 原先对地址做 `beqz` 导致用户 exit 分支永不生效 |
| 用户 trap：**`sscratch` 立即指回 `kernel_trap_cxt`**，trapped `t3` 写入 frame | 避免 `sscratch=0` 时嵌套 trap 写错地址 |
| `switch_to`：**`csrc SPP`** | `sret` 进入 U-mode |
| 用户 exit：**`csrs SPP`** | `sret` 回 S-mode 内核 trampoline |
| **`trap_reenable_irq`**：在 `trap_handler` 只置标志，**`reg_restore` 完成后**再 `csrs SIE` | 避免 timer 在 `reg_restore` 中途嵌套 trap，破坏 `t6` 指向的上下文 |

---

## 4. 未解决问题（按优先级）

### P0：`./hi` 触发 `trap_vector` 内 illegal instruction

- **现象**：见 §2.2；`FINAL_step=2~3`（已发 `./hi`，未见 `hi from ./hi`）。  
- **最可能原因**：**定时器/软中断在 `reg_restore` 或 `sret` 边界嵌套**，保存帧 `t6` 被破坏；已将 `cpu_irq_enable()` 延后到 `reg_restore` 之后，**部分自动化跑测仍报同一 PC**。  
- **待验证**：  
  1. 临时关闭 timer 或全程在用户 syscall 路径保持关中断，观察 panic 是否消失。  
  2. `objdump -d out/os | sed -n '/trap_vector>/,/^$/p'` 确认 `0x80200254` 仍为合法 `ld`。  
  3. 打开 `TRAP_DIAG_VERBOSE=1` 编译，看 `USER_EXIT` / `RETURN sepc=` 序列是否在 panic 前完整。  

### P1：用户程序无法回到 shell（产品层面）

在 P0 未解前，`./file_rw`、`./spin` 不应期望通过；`0531log.md` §10 对 `spin` ELF 错误、`file_rw` 二次 exec 的分析 **仍部分适用**，但需以 **当前 `proc_user.c` 路径** 重新验证。

### P2：自动化 / 文档与脚本

- 管道测试易 **超时在 login**（`step=1`），需等待 `Welcome` 或首个 `root@` prompt。  
- `hi_test.log`、`DEBUG=y` 容易误导为「内核卡死」。  

### P3：`task.md` 键盘中断

- 在 P0/P1 稳定前 **不要** 打开 `uart_rx_use_irq=1` + PLIC UART IRQ，避免再次混入 polling/ring 双路径。

---

---

## 6. 手动验证步骤

```bash
cd code/myos
make clean && make
DEBUG=n ./sh/start_qemu.sh

---

## 7. 建议的下一步（开发）

1. **确认 `trap_reenable_irq` 路径**：单步或加计数器，证明 timer 不再在 `reg_restore` 中间入 trap。  
2. **用户态 syscall 返回前保持关中断**，直到 `sret` 离开 `trap_vector`（与「仅回内核开中断」一致，且 **开中断点必须在 `reg_restore` 之后**）。  
3. **`trap_diag_trap_return`**：对用户态每次 syscall 都 `uart_puts` 可能拖慢；建议用 `TRAP_DIAG_VERBOSE` 门控（printf 路径已门控，uart 路径仍常开）。  
4. P0 通过后：回归 `./file_rw`、重编 `./spin`（`usr/compile.sh` + `make home`），更新 `0531log.md` 或本文件 §2。  

---


## 9. 一句话摘要

**登录与 shell 内置命令已基本可用；用户程序 `./hi` 在 trap 返回时于 `reg_restore`（`0x80200254`）发生 illegal instruction，是当前阻塞回到 prompt 的核心问题；已做 trap/sscratch/IRQ 延后等多项修复，但该 panic 在最新自动化测试中仍会出现，需继续收窄「嵌套 trap / 帧破坏」路径。**
