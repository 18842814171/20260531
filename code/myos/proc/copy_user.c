#include "os.h"
#include "uaccess.h"

int copy_from_user(void *dst, const void *usr, size_t n)
{
	if (!dst || !usr)
		return -1;
	if (n == 0)
		return 0;
	{
		char *d = (char *)dst;
		const char *s = (const char *)usr;
		size_t i;

		for (i = 0; i < n; i++)
			d[i] = s[i];
	}
	return 0;
}

int copy_to_user(void *usr, const void *src, size_t n)
{
	if (!usr || !src)
		return -1;
	if (n == 0)
		return 0;
	{
		char *d = (char *)usr;
		const char *s = (const char *)src;
		size_t i;

		for (i = 0; i < n; i++)
			d[i] = s[i];
	}
	return 0;
}
