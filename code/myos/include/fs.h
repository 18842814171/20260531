#ifndef __FS_H__
#define __FS_H__

#include "types.h"

#define FS_MAX_FILES   64
#define FS_MAX_PATH    96
#define FS_MAX_SIZE    16384
#define FS_MAX_NAME    64

#define O_RDONLY  0
#define O_WRONLY  1
#define O_RDWR    2
#define O_CREAT   4
#define O_TRUNC   8
#define O_APPEND  16

void fs_init(void);
void fs_load_home(void);

int  fs_chdir(const char *path);
const char *fs_getcwd(void);

int  fs_mkdir(const char *path);
int  fs_create(const char *path, int executable);
int  fs_unlink(const char *path);
int  fs_exists(const char *path);
int  fs_is_dir(const char *path);
int  fs_is_executable(const char *path);

int  fs_listdir(const char *dir, void (*emit)(const char *name, int size, int is_dir, int exec));
int  fs_open(const char *path, int flags);
int  fs_read(int fd, char *buf, int len);
int  fs_write(int fd, const char *buf, int len);
int  fs_truncate(int fd, int size);
int  fs_close(int fd);
int  fs_size(int fd);
int  fs_read_file(const char *path, char *buf, int len);
int  fs_write_file(const char *path, const char *buf, int len, int truncate);

void fs_seed_file(const char *path, const char *data, int size, int is_dir, int exec);

#endif /* __FS_H__ */
