#include "user.h"

char *
strcpy(char *dst, const char *src)
{
	char *d = dst;

	while ((*dst++ = *src++) != 0)
		;
	return d;
}

int
strcmp(const char *a, const char *b)
{
	while (*a && *a == *b)
		a++, b++;
	return (uchar)*a - (uchar)*b;
}

uint
strlen(const char *s)
{
	uint n;

	for (n = 0; s[n]; n++)
		;
	return n;
}

void *
memset(void *dst, int c, uint n)
{
	char *d = dst;
	uint i;

	for (i = 0; i < n; i++)
		d[i] = (char)c;
	return dst;
}

void *
memmove(void *vdst, const void *vsrc, int n)
{
	char *dst = vdst;
	const char *src = vsrc;

	if (src > dst) {
		while (n-- > 0)
			*dst++ = *src++;
	} else {
		dst += n;
		src += n;
		while (n-- > 0)
			*--dst = *--src;
	}
	return vdst;
}

void *
memcpy(void *dst, const void *src, uint n)
{
	return memmove(dst, src, (int)n);
}

int
memcmp(const void *a, const void *b, uint n)
{
	const char *p = a;
	const char *q = b;

	while (n-- > 0) {
		if (*p != *q)
			return (uchar)*p - (uchar)*q;
		p++;
		q++;
	}
	return 0;
}

int
puts(const char *s)
{
	uint n = strlen(s);
	int r = write(1, s, (int)n);

	if (r < 0)
		return r;
	return write(1, "\n", 1);
}
