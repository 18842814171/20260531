# 链接脚本（集中存放）

| 文件 | 用途 |
|------|------|
| `os.ld` | 内核 `out/os`（`make` 预处理 `-I include`） |
| `user.ld` | 用户 ELF（`usr/compile.sh c <file.c>`） |

勿在 `boot/`、`usr/` 下再放 `.ld` 文件。
