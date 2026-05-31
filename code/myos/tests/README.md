# 测试说明

用户程序与数据在 `home/root/`，由 `usr/compile.sh` 交叉编译，由 `make build` 打包进 ramfs。

```bash
cd usr
./compile.sh c file_rw.c
cd .. && make build
```

QEMU 内（`/home/root` 为家目录）：

```text
ls
cat hello.txt
vi mynote.txt
echo hello > mynote.txt
./file_rw
sh hello.sh
```
