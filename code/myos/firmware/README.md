# OpenSBI 预编译固件（不在 myos 内构建）

QEMU `-bios` 使用的 M 态固件，文件名 **无后缀**：`fw_jump`

获取方式（任选其一）：

```bash
make
# 默认从 ~/5.18/build-linux-system-from-scratch/output/images/fw_jump.bin 复制

FW_SRC=/path/to/fw_jump.bin make
# 手动指定来源

cp /path/to/fw_jump.bin firmware/fw_jump
```

来源通常是 [5.18 build-linux-system-from-scratch](~/5.18/build-linux-system-from-scratch) 里 `package/opensbi` 构建后的 `output/images/fw_jump.bin`，**不是**在本仓库里重新编译 OpenSBI。
