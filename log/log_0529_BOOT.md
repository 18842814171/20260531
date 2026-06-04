# 模块一：启动（OpenSBI M→S）

参考 `~/5.18/build-linux-system-from-scratch/package/opensbi/hello.s` 与 `hello.sh`。

## 启动流程

1. QEMU 加载 `firmware/fw_jump.bin`（OpenSBI，M 态，基址 `0x80000000`）
2. OpenSBI 将控制权交给内核：`Next Address = 0x80200000`，`Next Mode = S-mode`，`a0=hartid`，`a1=dtb`
3. `boot/start.S`：禁止 S 态中断、设置栈 `0x80210000`、清零 BSS、保存 `boot_hartid`/`boot_dtb`
4. `start_kernel()`：SBI 控制台、`stvec` 陷阱、各子系统初始化、登录 shell

## 注意

- **不要在 S 态读 `mhartid`**（会 trap）；hart 用 OpenSBI 传入的 `a0` 存到 `tp`
- **不要在 S 态直接访问 CLINT**（PMP 仅 M 态可访问）；时间用 `rdtime`，定时器用 SBI `set_timer`
- 日常控制台：**MMIO 16550 @ `0x10000000`**（与 `-serial stdio` 一致）；详见 `CONSOLE.md`
- `poweroff` 仍用 SBI shutdown（`boot/power.c`）

## 构建与运行

```bash
# 工具链：~/3.8/riscv-gnu-toolchain 安装到 /opt/riscv
export RISCV_PREFIX=/opt/riscv
export PATH=$RISCV_PREFIX/bin:$PATH

cd code/myos
make opensbi-firmware   # 从 5.18 复制或下载 fw_jump.bin
make                    # OPENSBI=y，生成 out/os.bin
./sh/start_qemu.sh
```

登录：`root`，命令见 `help`。

## 退出 QEMU

- **系统内 `poweroff`**（登录后或 `login:` 直接输入）— 通过 SBI 关闭虚拟机，**推荐**
- **`Ctrl+C`**（宿主机终端，即使在 `login:`）
- **`Ctrl+]` 松开，再按 `X`**

## 直接 M 态启动（无 OpenSBI）

```bash
make OPENSBI=n build
OPENSBI=n ./sh/start_qemu.sh
```
