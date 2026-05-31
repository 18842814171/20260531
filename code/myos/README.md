# myos

## 用户目录与文件系统

- 宿主机构建目录 `home/root/` 对应目标机 `/home/root/`
- 登录后默认 `cd` 到 `/home/root`
- 支持 Linux 风格命令：`ls` `cd` `pwd` `cat` `touch` `vi` `echo` `echo >` `echo >>` `sh` `./程序名`

## 交叉编译（构建机）

```bash
cd usr
./compile.sh c file_rw.c
```

仅支持 `./compile.sh c <文件名>`，源文件与可执行文件均放在用户目录（不在命令行中写路径）。

## 构建内核并运行

```bash
make build
./sh/start_qemu.sh
```

`make build` 会把 `home/root/` 打包进 ramfs。

## 目标机示例

```text
login: root
root@/home/root$ ls
root@/home/root$ vi note.txt
root@/home/root$ echo hello > note.txt
root@/home/root$ cat note.txt
root@/home/root$ ./file_rw
root@/home/root$ sh hello.sh
```

## 测试

```bash
./sh/run-tests.sh
```
