#ifndef __USER_API_H__
#define __USER_API_H__

extern int gethid(unsigned int *hid);
extern int write(int fd, const char *buf, int len);
extern int read(int fd, char *buf, int len);
extern void exit(int status) __attribute__((noreturn));
extern int fork(void);

#endif /* __USER_API_H__ */
