# myos

## 用户目录与文件系统

- 宿主机构建目录 `home/root/` 对应目标机 `/home/root/`
- 登录后默认 `cd` 到 `/home/root`
- 支持 Linux 风格命令：`ls` `cd` `pwd` `cat` `touch` `vi` `echo` `echo >` `echo >>` `sh` `./程序名`

## 交叉编译（构建机）

```bash
./compile.sh c file_rw.c
```

用法： `./compile.sh c <文件名>`，源文件与可执行文件均放在用户目录（不在命令行中写路径）。
`./compile.sh dump <文件名>` 反汇编
## 构建内核并运行

```bash
make
./sh/start_qemu.sh
```

`make` 会把 `home/root/` 打包进 ramfs。

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

OpenSBI 启动
  └─ start_kernel()                    内核初始化（uart、vm、trap…）
       └─ debug_autorun_user_and_exit("pagefault")
            └─ proc_spawn_exec_wait("pagefault")
                 ├─ proc_alloc()           分配 pid=2
                 ├─ proc_load_elf()        把 pagefault 装进用户地址空间
                 └─ proc_user_run(2)       ★ BP1 停在这里面
                      ├─ proc_save_run_caller()   保存内核返回地址
                      ├─ proc_save_run_cont()     ★ 你见过的 BP1：写入 after_uspace
                      ├─ vm_activate()            切换页表
                      └─ enter_uspace() → sret    进用户态
                           └─ _start (crt0)
                                └─ main()          pagefault 用户代码
                                     ├─ write("using more stack...")
                                     ├─ 循环：sp 下降 + sb zero（缺页 trap 很多次）
                                     ├─ write("done.")
                                     └─ return 0
                                          └─ ret → 跳到 0  ★ 坏了
                                               └─ 取指 fault @ sepc=0
                                                    └─ handle_sync_exception()  ★ BP2 停这里
                                                         └─ panic