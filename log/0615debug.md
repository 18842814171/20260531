# 0615 调试与功能变更记录

本文记录 6 月 15 日前后一轮网页终端、观测分流、后台脚本与界面交互改动。叙述采用书面语；涉及模块名、文件名处为便于对照保留原文。

---

## 一、背景与目标

此前网页端已具备终端与右侧事件面板，但存在三类突出问题：观测 JSON 与 shell 输出在终端中交织；交互式程序（如 vi、ipc_echo）在浏览器中无法正常使用；内核后台脚本在 `sleep` 后无法自行结束。本轮在保持「guest 侧仍共用一条串口」的前提下，从内核输出分层、主机分流、前端输入模式三方面一并处理，并同步修订 `docs/`。

---

## 二、内核：控制台与观测输出分层

### 2.1 新增接口

| 项目 | 说明 |
|------|------|
| 头文件 | `code/myos/include/console_io.h` |
| 实现 | `code/myos/boot/console_io.c` |
| 控制台通道 | `console_putc` / `console_write` / `console_puts` — shell、`printf`、标准输出系统调用、UART 回显 |
| 观测通道 | `log_putc` / `log_write` / `log_puts` — `osviz_event`、`osviz_snapshot` |

### 2.2 当前行为与后续规划

两路 API **现阶段均写入同一 UART**；分流由主机完成。`log_write` 内预留 `log_sink` 枚举，后续可单独重定向至管道、套接字、文件或第二串口，调用方无需改动。

### 2.3 调用点迁移

| 原路径 | 现路径 |
|--------|--------|
| `printf` → `uart_puts` | `printf` → `console_puts` |
| `osviz_event` → `printf("LOG …")` | `osviz_event` → `log_puts` |
| `sys_write(1/2)` → `uart_putc` | → `console_putc` |
| shell、vi、脚本等直接 `uart_puts` | → `console_*` |
| 硬件层 | `uart_putc` 仅由 `console_io.c` 调用 |

---

## 三、内核：后台脚本与 shell 命令

### 3.1 现象

执行 `. sh01.sh &` 或 `sh sh01.sh &` 时，脚本前几行能输出，`sleep 20` 之后最后一行 `echo` 不出现；`ps` 中长期存在 pid 2、状态为 S 的 `sh01.sh`。再次启动后台脚本则提示「已有任务在运行」。

### 3.2 原因

启用 UART 中断接收后，shell 等待输入时在 `proc_block` 中睡眠，**不再**像轮询模式那样在循环里调用 `script_bg_poll`。`sleep` 到期后无人推进脚本指针，任务一直挂起。

### 3.3 修复

| 位置 | 改动 |
|------|------|
| `interrupt/timer.c` | 定时器处理中调用 `script_bg_poll` |
| `boot/uart.c` | `uart_readc_wait` 阻塞前先 poll 一次 |
| `usr/console.c` | 每次显示提示符前 poll 一次 |

### 3.4 新增 shell 命令

| 命令 | 作用 |
|------|------|
| `jobs` | 查看当前内核后台脚本及 sleep 状态 |
| `kill` | 结束唯一的后台脚本 |
| `kill <pid>` | 按 pid 结束（须为后台脚本 pid） |

实现于 `usr/script.c`（`script_bg_kill`、`script_bg_pid` 等）与 `usr/console.c`。

### 3.5 vi 小改动

`:q!` 退出时打印 `vi: quit`，便于网页端识别并退出单键输入模式（`usr/vi.c`）。

---

## 四、网页后端：串口分流增强

### 4.1 通道字段

WebSocket 消息增加 `channel` 字段，与消息类型配合：

| type | channel | 前端消费 |
|------|---------|----------|
| output | console | 终端面板 |
| event | log | 右侧事件面板 |
| snapshot | log | 右侧事件面板 |

### 4.2 交错字节处理

当 shell 输出与观测行在同一读缓冲中交错（例如 `cLOG {"ts_ms":…}`）时，分流器在缓冲区内搜索 `LOG ` / `LOG_SNAPSHOT ` 标记，拆出完整行送观测通道，其余字节送终端通道。不完整观测前缀仍暂存至换行。

修改文件：`code/web/server.py`（`SerialDemux`）。

---

## 五、网页前端：终端与事件面板

### 5.1 终端输入

| 模式 | 触发 | 行为 |
|------|------|------|
| 行模式 | 默认 shell | 输入框内编辑，Enter 发送整行 |
| 单键模式 | 出现 vi 横幅、`ipc_echo` 输入提示等 | 每个键即时发送，含 Esc、退格 |

取消 `sendCommand` 的**本地回显**，仅显示 guest 回显，避免 vi 等程序双重打印。

若仍有观测行漏入终端，客户端对 `LOG {"ts_ms"…}` 做兜底剥离并转送事件面板（`terminal.js`）。

### 5.2 事件面板滚动

原列表容器使用 `justify-content: flex-end`，内容溢出时无法向上滚动。改为占位元素贴底 + 正常滚动；用户上滚时暂停自动跟随，回到底部后恢复（`logs.js`、`global.css`）。

### 5.3 事件卡片样式

气泡改为无边框、按类型浅色渐变、柔和阴影；保留原有类型色区分（trap 进入/离开/诊断、boot、默认）。

### 5.4 终端高度可调

文件预览与终端之间增加 `#console-splitter` 拖拽条；高度写入 `localStorage`；双击恢复默认（`desktop.html`、`desktop.js`、`global.css`）。

---

## 六、文档同步

已按**重要原则 9**（书面、简洁、少在叙述中堆砌符号）更新 `docs/` 全部相关章节：

| 文件 | 摘要 |
|------|------|
| 04_logging_and_osviz.md | console/log 分层、通道分流、交错行 |
| 05_web_frontend.md | 重写：通道协议、单键模式、分流、排障表 |
| 01_architecture.md | Web 数据流、可观测性路径 |
| 02_call_chains.md | 观测链、后台脚本链、Web 分流链 |
| 03_module_index.md | console_io、jobs/kill、Web 前端 |
| PROBLEMS_AND_SOLUTIONS.md | §11.3–11.5 新增 |
| README.md | 索引与对齐日期 |

---

## 七、涉及文件一览

### 内核（新增）

- `code/myos/include/console_io.h`
- `code/myos/boot/console_io.c`

### 内核（修改）

- `boot/printf.c`, `boot/osviz_k.c`, `boot/uart.c`, `boot/kernel.c`, `boot/power.c`
- `interrupt/timer.c`
- `proc/syscall.c`, `proc/proc_user.c`
- `usr/console.c`, `usr/script.c`, `usr/vi.c`
- `usr/autorun.c`, `usr/user.c`
- `include/os.h`

### 网页

- `code/web/server.py`
- `code/web/js/terminal.js`, `desktop.js`, `logs.js`
- `code/web/desktop.html`, `css/global.css`

### 文档

- `docs/*.md`（见第六节）

---

## 八、已知事项

1. 观测与控制台在 guest 侧仍共用 UART；高频率 trap 观测时终端仍可能偶发短片段，需依赖主机分流与客户端兜底。
2. 内核后台脚本同时仅允许一个；与用户态 `fork` 后台程序机制不同。
3. 网页 vi 需在出现「交互模式」提示后，**焦点保持在输入框**内逐键操作；`:wq` 为四个键，不必再按 Enter。
4. `log_write` 重定向至独立主机通道（原则中的第三步）尚未实现，仅留扩展点。

---

## 九、验证建议

```text
1. code/myos 下 make，重启 QEMU / Web 后端，浏览器硬刷新

2. 终端与观测分流
   - 执行 ./segfault_null、./hi
   - 终端应无 LOG JSON 行；右侧可见 trap/proc 事件

3. 后台脚本
   - export ooxx=888
   - . sh01.sh &
   - 约 20 秒后应自动出现第三个 echo；或 kill 2 立即结束
   - jobs 查看状态

4. vi（网页）
   - vi sh02.sh → i 插入 → Esc → :wq
   - 无重复行；保存后 cat sh02.sh 内容正确

5. 终端高度
   - 拖动预览与终端之间的分隔条；刷新后高度应保持

6. 文档
   - 对照 docs/05_web_frontend.md、docs/04_logging_and_osviz.md
```

---

## 十、与其它项目的对照（调研摘要）

| 项目 | 控制台与日志是否同通道 | 处理方式 |
|------|------------------------|----------|
| xv6-riscv | 是 | 无结构化观测；部分锁缓解交错 |
| T202510 竞赛提交 | 是 | 评测构建关闭内核日志 |
| my_sim（5.18） | 否 | 模拟器日志重定向文件，guest UART 直出 stdout |
| 本项目（本轮后） | guest 侧是；主机分流 | console/log API + SerialDemux + channel |

---

*记录日期：2026-06-15*  
*记录原则：说明性文字尽量书面化；必要处保留路径与命令以便复现。*
