#ifndef __UACCESS_H__
#define __UACCESS_H__

#include "types.h"

int copy_from_user(void *dst, const void *usr, size_t n);
int copy_to_user(void *usr, const void *src, size_t n);
int copyinstr(void *dst, const void *usr, size_t max);

#endif /* __UACCESS_H__ */
