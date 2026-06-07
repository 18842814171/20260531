# 0607 — fork 演示崩溃与用户态退出调试记录

本次对话围绕 **fork 演示程序** 和 **用户程序退出** 两条线展开：一边修内核里「进用户态 / 从用户态回来」的路径，一边补测试程序和调试手段。下面按「出了什么事 → 改了什么 → 为什么改」写，尽量用人话，少用内核里的函数名代替正常说法。

---

## 一、背景与主要现象

### 1. fork 演示程序

运行 `./fork_demo`（或开机自动跑这个程序）时，大致输出是：

- 父进程：扩栈、创建子进程、等待前打印 `ooxx=666`
- 子进程：扩栈、打印 `ooxx=222` 和 `ooxx=999`
- 然后立刻崩溃：`page fault`，出错地址约在 `0x80400046`

这个地址 **不是** 程序主函数末尾的 `return`，而是 **通用系统调用封装里「发起系统调用」那条指令的下一条**——也就是每次 `write` 等调用从内核返回用户态时的常规落点。

### 2. 和 pagefault 演示的共性问题

更早还修过 **pagefault 演示**：程序用向下扩栈 + 往栈上写字触发缺页，跑完后若直接 `return` 给启动代码，启动代码里的返回地址可能已被栈上的 `sb zero` 清零，导致跳到地址 0 再崩溃。这类问题和 fork 演示里的「退出没回到内核」属于同一类：**用户程序结束方式不对，或内核返回地址丢了**。

---

## 二、根因分析（人话版）

### ★ 最终根因（2025-06-07 调试确认）：父进程 waitpid 回来时忘了切换页表

这是 fork_demo 崩溃的**真正原因**，和「子进程页表被销毁」容易搞混，要分开看。

#### 每个程序有自己的「地址翻译本」

CPU 访问内存要靠 **页表** 把虚拟地址翻译成物理地址。每个用户进程各有一本页表，内核还有一本。运行谁，就必须先翻到谁的那本。

#### waitpid 实际干了什么

1. **父进程** 在用户态调用 `waitpid`，触发系统调用，CPU 进内核
2. 内核去跑 **子进程**，把页表切成 **子进程那本**
3. 子进程跑完 `exit`，回到内核里「用户程序跑完该回来的地方」（`after_uspace`）
4. 这时页表切回 **内核那本** —— 到这里都对
5. 内核发现子进程已死，把 **子进程的页表销毁** —— 也合理
6. `waitpid` 处理完了，要把 **父进程** 送回用户态，继续执行系统调用后面的代码（地址 `0x80400046`）

**问题出在第 6 步：** 内核准备把父进程送回用户态，但 **忘了把页表切回父进程那本**，手上还拿着 **内核那本**。

#### 后果

- 父进程的代码还在用户地址 `0x80400046`，这本该由 **父进程的页表** 翻译
- 可当时 CPU 用的是 **内核页表**，里面 **没有** 这段用户代码的映射
- CPU 取指令时相当于「翻译手册里查不到这个地址」→ **Instruction Page Fault**
- GDB 里 `Cannot access 0x80400046` 也是这个原因：当前没有加载父进程的用户页，所以反汇编不了

#### 和子进程页表销毁的关系

子进程页表销毁 **不是直接原因**。真正原因是：送父进程回用户态时 **没有用父进程的页表**，却去执行父进程的用户代码。子进程页表销毁只是时间线上刚好发生在那之前，容易让人误以为是「子进程没了还去跑子进程的代码」。实际上 CPU 想跑的是 **父进程** 的代码，只是拿错了翻译手册。

#### 一句话

> 父进程通过 `waitpid` 从内核返回用户态时，内核忘了把内存翻译切换回父进程自己的页表，还拿着内核页表就让父进程继续跑，所以取指令失败。

#### 修法

在陷阱处理里，凡是「要送回用户态」之前，先 **把页表切回当前进程（父进程）的那本**（`trap.c` 里 `trap_return_to_user` 分支增加 `vm_activate`）。

#### 为什么 pagefault 演示没事

`pagefault` 没有 `waitpid → 内核代为运行子进程` 这条嵌套路径，不会出现「内核页表还开着就把用户程序送回去」的情况。

---

### 其它已修问题（调试过程中陆续发现）

#### 1. 子进程 fork 后反复创建子进程（物理页耗尽）

创建子进程时，子进程应拿到返回值 0，却可能仍走父进程分支，再次 fork，形成风暴。

**原因：** 子进程第一次进用户态时，程序计数器还指着「发起 fork 系统调用」那条指令；从陷阱返回时若按惯例加 4，子进程会 **再执行一次 fork**。

**修法：** 复制父进程上下文时，把子进程的程序计数器再往后挪 4 字节，并把返回值寄存器设为 0。

#### 2. 用户程序退出后仍回到用户态（子进程 exit 路径）

用户调用「退出」系统调用后，内核应：

1. 把进程标成僵尸
2. 把 CPU 交回 **内核里当初送它进用户态时保存的继续执行点**（`after_uspace`）
3. **不应** 再执行用户态下一条指令

**修法：** 退出单独处理；返回地址必须是内核地址，若是用户地址则 panic。

**GDB 结论：** 子进程 exit 后 **能** 落到 `after_uspace`（断点处 `pid=3` 正常），说明这条路径在 fork_demo 场景下是通的；后续 fault 出在 **父进程 waitpid 返回**，不是子进程 sret 目标错了。

#### 3. 陷入处理汇编里的多个 bug

| 问题 | 表现 | 原因（人话） |
|------|------|----------------|
| 汇编里重复用同名局部标签 | 编译失败或行为错乱 | 同一文件里局部标签重名 |
| `addi` 加 0x1120 | 编译报立即数超范围 | 该常数不能用 12 位立即数一条指令完成 |
| 从用户态陷阱返回前才设置切换寄存器，且用已被恢复的寄存器去算地址 | 启动后卡住、栈指针错 | 恢复寄存器会覆盖用来计算的临时值；顺序错了 |
| 用户陷阱时切换寄存器为 0，栈指针仍是用户栈 | 保存寄存器快照位置错 | 需根据当前进程重新加载内核栈顶 |
| 进用户态时未写入切换寄存器 | 第一次用户陷阱栈不对 | 应在进入用户态前写好内核栈顶 |

#### 4. 运行用户程序返回后「当前进程号」被写死

进用户态前先记住原来的进程号，回来后再恢复，不再写死 shell 的 1 号。

#### 5. 准备返回内核时，若没有保存的调用者地址却静默返回

改为直接 panic，便于定位。

#### 6. `printf` 里 `pid=1105377` 这类乱码

断在 `after_uspace` 时 `pid=3` 正常，下一行打印变垃圾值。更像是后续 fault 或栈被污染后的连带现象，**不是**「根本没回到 after_uspace」。主因仍是父进程返回用户态时页表错误。

---

## 三、GDB 调试要点（0607 会话）

### 1. 为什么不能 `break reg_restore`

`reg_restore` 是汇编 **宏**，展开成一串 `ld` 指令，没有独立符号。应断：

- `break trap_handler`（进 C 处理）
- `break entry.S:142`（用户陷阱换栈，会命中每次 syscall，太吵）
- `break proc_gdb_checkpoint` / `break proc_user.c:297 if pid == 3`（专盯退出返回）

### 2. 为什么不能 `break do_exit`

`do_exit` 是用户程序 `fork_demo` 里的 **static** 函数，GDB 默认只加载内核 `out/os` 符号。需要先：

```gdb
add-symbol-file /path/to/home/root/fork_demo 0x80400000
```

或 `break *0x80400252`（地址随重编译可能变）。

### 3. 三个可疑用户态地址分别是什么

| 地址 | 含义 |
|------|------|
| `0x80400046` | `syscall3` 里 `ecall` **之后**第一条：`mv a5, a0`（任意 syscall 从内核返回用户态的落点） |
| `0x8040005e` | `syscall1` 入口存参数（`waitpid` 等单参数 syscall 会经过） |
| `0x80400332` | `main` 里 `grow_stack_pages("parent")` 加载字符串地址 |

若 `saved_ra` / `cxt_ra` 是这些地址，说明 **用户态返回点被当成了内核 sret 后的 `$ra`**，返回链有 bug。  
fault 时 `sepc=0x80400046` 在 **已修页表问题** 的语境下，表示：**父进程 waitpid  syscall 正常返回路径**，但当时页表不对。

### 4. 子进程退出：sret 还是 ret？

- **进用户态**：`enter_uspace` 用 **sret**，不会用 `ret` 回到 `proc_user_run`
- **子进程 exit 回内核**：`proc_prepare_kernel_return` 设好快照 → **sret** 到 `after_uspace`
- **不是** `enter_uspace` 的 `ret` 回来

### 5. 推荐断点（`sh/gdbinit`）

- `break proc_user.c:297 if pid == 3` — 子进程回到 `after_uspace`、打印 `returned from user` 前
- `break proc_gdb_checkpoint` — phase 0 = exit 后即将 sret；phase 1 = 已落地
- `break panic` — 兜底
- 自动 `add-symbol-file fork_demo`，停住时跑 `bt`、`p proc_gdb_last`、`x/10i` 三个地址

### 6. 典型 backtrace（子进程回到 after_uspace 时）

```text
#0  proc_user_run(pid=3)
#1  proc_wait(...)
#2  sys_waitpid(...)
#3  do_syscall(...)
#4  handle_sync_exception(...)
```

说明子进程是在 **父进程 waitpid 系统调用处理过程中** 被内核代为运行的。

---

## 四、所有修改及原因

### A. 物理内存管理框架（课程幻灯片结构）

| 改动 | 原因 |
|------|------|
| 新增物理内存管理器抽象 | 按课程要求把算法和框架分开 |
| 原 `page.c` 迁到 `default_pmm.c` | 默认算法可跑通 |
| `best_fit_pmm.c` 占位 | 预留接口 |
| `pmm.c` 统一入口 | 框架层负责并发与日志 |
| 启动从 `page_init` 改为 `pmm_init` | 对接新框架 |

### B. 用户态陷阱与汇编入口

| 改动 | 原因 |
|------|------|
| 局部标签唯一化 | 避免汇编标号冲突 |
| 大偏移改用 `li` + `add` | 修复非法指令 |
| `trap_fixup_kstack_top` | 切换寄存器异常时重载内核栈顶 |
| 切换寄存器在 reg_restore **之前** 设置 | 避免临时寄存器被覆盖 |
| 返回内核路径切换寄存器清零 | 退出后留在内核态 |
| 进用户态前写入切换寄存器 | 第一次用户陷阱能 swap 栈 |

### C. 进程与用户程序运行

| 改动 | 原因 |
|------|------|
| fork 时子进程 pc +4、a0 = 0 | 防止 fork 风暴 |
| `proc_user_exit_trap` 专路径 | 退出集中处理、校验内核返回地址 |
| 退出不走普通 syscall 返回用户态 | 避免 exit 后继续跑用户代码 |
| `proc_prepare_kernel_return` 无保存调用者则 panic | 避免静默坏地址 |
| 运行用户程序返回后恢复 `saved_pid` | fork / wait 场景进程号正确 |
| `after_uspace` 打印 `proc_user_run: pid=N returned from user` | 确认子进程是否回到内核落点 |
| **`trap.c`：送回用户态前 `vm_activate(当前进程页表)`** | **修复 waitpid 返回父进程时页表仍是内核页表导致 fault** |
| `proc_set_state(UNUSED)` 时打印 `destroy vm pid=...` | 验证子进程页表销毁时机 |
| page fault 打印 `pid` / `current` / `sepc` | 便于对照是谁在跑、错在哪 |

### D. GDB 调试支持

| 改动 | 原因 |
|------|------|
| `proc_gdb_snap` / `proc_gdb_checkpoint` | 记录退出返回链关键字段 |
| 重写 `sh/gdbinit` | 专盯 `after_uspace` 与 exit，避免每次 syscall 都停 |

### E. 测试用户程序

| 程序 | 改动 | 原因 |
|------|------|------|
| `pagefault.c` | 扩栈后恢复 sp；显式 exit | 避免 ret 到 0 |
| `fork_demo.c` | 父子扩栈、ooxx、wait/exit | 演示 fork + COW + wait 嵌套路径 |

### F. 其它

| 改动 | 原因 |
|------|------|
| `yebiao` 无参显示所有进程页表 | 方便调试映射 |
| fork osviz 日志带父/子 pid | 日志可读 |
| `README` 补充调试链 | 文档对齐 |

---

## 五、调试结论：child 应该回到哪里

内核送子进程进用户态时，会用 **`after_uspace`** 记录「用户程序结束后内核该继续执行的地址」（随编译变化，约在 `0x8020xxxx`）。

正常子进程退出流程：

```text
父进程在 wait 里
  → 内核运行子进程（用户态）
  → 子进程调用退出系统调用
  → 内核 sret 到 after_uspace
  → 打印：proc_user_run: pid=3 returned from user
  → wait 发现子进程已僵尸，回收（destroy vm pid=3）
  → waitpid 返回父进程用户态（此处必须先切回父进程页表）← 曾缺这一步
  → 父进程继续打印 ooxx=666 after wait
```

若 **看不到** `returned from user` 就 fault：子进程 exit 的 sret 目标有问题。  
若 **看到** `returned from user` 再 fault @ `0x80400046`：曾是 **父进程 waitpid 返回时页表未切换**（已修）。

---

## 六、当前状态

| 项目 | 状态 |
|------|------|
| pagefault 演示 | 已按栈修复思路改程序 |
| fork 风暴（子进程 pc/a0） | 已修 |
| 汇编陷阱入口 | 已修 |
| 退出专路径 + 返回地址校验 | 已加 |
| 子进程 exit → after_uspace | GDB 确认可达（pid=3 正常） |
| **父进程 waitpid 返回页表** | **已修（trap.c vm_activate）** |
| fork_demo 完整跑通 | **待重新 make 后验证** |
| best_fit 物理页算法 | 仅占位 |
| GDB | `gdbinit` 已配 after_uspace / checkpoint / panic |

---

## 七、建议的验证步骤

1. `make` 后跑 `./fork_demo`，应看到：
   - `proc_user_run: pid=3 returned from user`
   - `destroy vm pid=3 pt=...`
   - `parent: ooxx=666 after wait (expect 666)`
   - 不再出现 `page fault sepc=0x80400046`
2. 若仍 fault：看新日志里 `page fault pid=... current=... sepc=...` 与 `destroy vm` 先后顺序。
3. GDB：`break proc_user.c:297 if pid == 3`，停住后 `p proc_gdb_last`、`bt`、`x/10i $ra`。

---

## 八、相关文件索引

内核：`interrupt/entry.S`、`interrupt/trap.c`、`proc/proc_user.c`、`proc/proc.c`、`proc/syscall.c`  
用户程序：`home/root/fork_demo.c`、`home/root/pagefault.c`  
调试：`sh/gdbinit`  
内存框架：`mem/pmm.c`、`mem/default_pmm.c`、`include/pmm.h`
