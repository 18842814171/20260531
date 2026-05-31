#include "os.h"
#include "fs.h"

struct fs_node {
	char path[FS_MAX_PATH];
	char data[FS_MAX_SIZE];
	int size;
	int is_dir;
	int executable;
	int used;
	int read_off;
};

static struct fs_node nodes[FS_MAX_FILES];
static char cwd[FS_MAX_PATH] = "/home/root";

static int str_len(const char *s)
{
	int n = 0;

	while (s && s[n])
		n++;
	return n;
}

static int str_eq(const char *a, const char *b)
{
	while (*a && *b) {
		if (*a != *b)
			return 0;
		a++;
		b++;
	}
	return *a == *b;
}

static int str_prefix(const char *s, const char *pfx)
{
	while (*pfx) {
		if (*s != *pfx)
			return 0;
		s++;
		pfx++;
	}
	return 1;
}

static void path_copy(char *dst, int cap, const char *src)
{
	int i = 0;

	while (src && src[i] && i < cap - 1) {
		dst[i] = src[i];
		i++;
	}
	dst[i] = '\0';
}

static int path_normalize(const char *in, char *out, int cap)
{
	char parts[32][FS_MAX_NAME];
	int np = 0;
	int abs = 0;
	int i;
	const char *p;

	if (!in || !out || cap <= 0)
		return -1;

	if (in[0] == '/')
		abs = 1;

	p = in;
	while (*p) {
		char seg[FS_MAX_NAME];
		int k = 0;

		while (*p == '/')
			p++;
		if (!*p)
			break;
		while (*p && *p != '/' && k < FS_MAX_NAME - 1)
			seg[k++] = *p++;
		seg[k] = '\0';
		if (seg[0] == '\0' || str_eq(seg, "."))
			continue;
		if (str_eq(seg, "..")) {
			if (np > 0)
				np--;
			continue;
		}
		if (np < 32)
			path_copy(parts[np++], FS_MAX_NAME, seg);
	}

	if (abs) {
		if (np == 0) {
			path_copy(out, cap, "/");
			return 0;
		}
		out[0] = '\0';
		for (i = 0; i < np; i++) {
			if (out[0] == '\0')
				snprintf(out, cap, "/%s", parts[i]);
			else
				snprintf(out + str_len(out), cap - str_len(out), "/%s", parts[i]);
		}
		return 0;
	}

	path_copy(out, cap, cwd);
	for (i = 0; i < np; i++)
		snprintf(out + str_len(out), cap - str_len(out), "/%s", parts[i]);
	return 0;
}

static struct fs_node *lookup_path(const char *path)
{
	char norm[FS_MAX_PATH];
	int i;

	if (path_normalize(path, norm, sizeof(norm)) < 0)
		return NULL;
	for (i = 0; i < FS_MAX_FILES; i++) {
		if (!nodes[i].used)
			continue;
		if (str_eq(nodes[i].path, norm))
			return &nodes[i];
	}
	return NULL;
}

static struct fs_node *alloc_node(void)
{
	int i;

	for (i = 0; i < FS_MAX_FILES; i++) {
		if (!nodes[i].used)
			return &nodes[i];
	}
	return NULL;
}

static int parent_path(const char *path, char *parent, int cap)
{
	int i = str_len(path);

	while (i > 0 && path[i - 1] == '/')
		i--;
	while (i > 0 && path[i - 1] != '/')
		i--;
	if (i <= 0) {
		path_copy(parent, cap, "/");
		return 0;
	}
	if (i == 1) {
		path_copy(parent, cap, "/");
		return 0;
	}
	{
		int n = i - 1;
		if (n >= cap)
			return -1;
		for (i = 0; i < n; i++)
			parent[i] = path[i];
		parent[n] = '\0';
	}
	return 0;
}

int fs_mkdir(const char *path)
{
	char norm[FS_MAX_PATH];
	char parent[FS_MAX_PATH];
	struct fs_node *n;
	struct fs_node *p;

	if (path_normalize(path, norm, sizeof(norm)) < 0)
		return -1;
	if (lookup_path(norm))
		return 0;

	if (str_eq(norm, "/")) {
		n = alloc_node();
		if (!n)
			return -1;
		path_copy(n->path, sizeof(n->path), "/");
		n->is_dir = 1;
		n->size = 0;
		n->executable = 0;
		n->read_off = 0;
		n->used = 1;
		return 0;
	}

	parent_path(norm, parent, sizeof(parent));
	p = lookup_path(parent);
	if (!p || !p->is_dir)
		return -1;
	n = alloc_node();
	if (!n)
		return -1;
	path_copy(n->path, sizeof(n->path), norm);
	n->is_dir = 1;
	n->size = 0;
	n->executable = 0;
	n->read_off = 0;
	n->used = 1;
	return 0;
}

int fs_create(const char *path, int executable)
{
	char norm[FS_MAX_PATH];
	char parent[FS_MAX_PATH];
	struct fs_node *n;
	struct fs_node *p;

	if (path_normalize(path, norm, sizeof(norm)) < 0)
		return -1;
	if (lookup_path(norm)) {
		n = lookup_path(norm);
		if (n->is_dir)
			return -1;
		n->executable = executable;
		return 0;
	}
	parent_path(norm, parent, sizeof(parent));
	p = lookup_path(parent);
	if (!p || !p->is_dir)
		return -1;
	n = alloc_node();
	if (!n)
		return -1;
	path_copy(n->path, sizeof(n->path), norm);
	n->is_dir = 0;
	n->size = 0;
	n->data[0] = '\0';
	n->executable = executable;
	n->read_off = 0;
	n->used = 1;
	return 0;
}

int fs_unlink(const char *path)
{
	char norm[FS_MAX_PATH];
	struct fs_node *n;

	if (path_normalize(path, norm, sizeof(norm)) < 0)
		return -1;
	n = lookup_path(norm);
	if (!n || n->is_dir)
		return -1;
	n->used = 0;
	return 0;
}

int fs_exists(const char *path)
{
	return lookup_path(path) != NULL;
}

int fs_is_dir(const char *path)
{
	struct fs_node *n = lookup_path(path);

	return n && n->is_dir;
}

int fs_is_executable(const char *path)
{
	struct fs_node *n = lookup_path(path);

	return n && !n->is_dir && n->executable;
}

const char *fs_getcwd(void)
{
	return cwd;
}

int fs_chdir(const char *path)
{
	char norm[FS_MAX_PATH];
	struct fs_node *n;

	if (path_normalize(path, norm, sizeof(norm)) < 0)
		return -1;
	n = lookup_path(norm);
	if (!n || !n->is_dir)
		return -1;
	path_copy(cwd, sizeof(cwd), norm);
	return 0;
}

int fs_listdir(const char *dir, void (*emit)(const char *name, int size, int is_dir, int exec))
{
	char norm[FS_MAX_PATH];
	char prefix[FS_MAX_PATH];
	int i, n = 0;

	if (path_normalize(dir, norm, sizeof(norm)) < 0)
		return -1;
	if (!lookup_path(norm) || !fs_is_dir(norm))
		return -1;
	snprintf(prefix, sizeof(prefix), "%s/", norm);
	if (str_eq(norm, "/"))
		path_copy(prefix, sizeof(prefix), "/");

	for (i = 0; i < FS_MAX_FILES; i++) {
		char base[FS_MAX_NAME];
		const char *rest;
		int j, slashes;

		if (!nodes[i].used)
			continue;
		if (str_eq(nodes[i].path, norm))
			continue;
		if (!str_eq(norm, "/")) {
			if (!str_prefix(nodes[i].path, prefix))
				continue;
			rest = nodes[i].path + str_len(prefix);
		} else {
			if (nodes[i].path[0] != '/')
				continue;
			rest = nodes[i].path + 1;
		}
		slashes = 0;
		for (j = 0; rest[j]; j++) {
			if (rest[j] == '/')
				slashes++;
		}
		if (slashes > 0)
			continue;
		path_copy(base, sizeof(base), rest);
		if (emit)
			emit(base, nodes[i].size, nodes[i].is_dir, nodes[i].executable);
		n++;
	}
	return n;
}

int fs_open(const char *path, int flags)
{
	char norm[FS_MAX_PATH];
	struct fs_node *n;

	if (path_normalize(path, norm, sizeof(norm)) < 0)
		return -1;
	n = lookup_path(norm);
	if (!n) {
		if (flags & O_CREAT) {
			if (fs_create(path, 0) < 0)
				return -1;
			n = lookup_path(norm);
		} else {
			return -1;
		}
	}
	if (n->is_dir)
		return -1;
	if (flags & O_TRUNC)
		n->size = 0;
	if (flags & O_APPEND)
		n->read_off = n->size;
	else
		n->read_off = 0;
	return 3 + (int)(n - nodes);
}

int fs_size(int fd)
{
	int idx = fd - 3;

	if (fd < 3 || idx >= FS_MAX_FILES || !nodes[idx].used)
		return -1;
	return nodes[idx].size;
}

int fs_read(int fd, char *buf, int len)
{
	int idx = fd - 3;
	struct fs_node *f;
	int n = 0;

	if (!buf || len <= 0 || fd < 3 || idx >= FS_MAX_FILES || !nodes[idx].used)
		return -1;
	f = &nodes[idx];
	if (f->is_dir)
		return -1;
	while (n < len && f->read_off < f->size)
		buf[n++] = f->data[f->read_off++];
	return n;
}

int fs_write(int fd, const char *buf, int len)
{
	int idx = fd - 3;
	struct fs_node *f;
	int i;

	if (!buf || len < 0 || fd < 3 || idx >= FS_MAX_FILES || !nodes[idx].used)
		return -1;
	f = &nodes[idx];
	if (f->is_dir)
		return -1;
	for (i = 0; i < len && f->size < FS_MAX_SIZE - 1; i++)
		f->data[f->size++] = buf[i];
	f->data[f->size] = '\0';
	return i;
}

int fs_truncate(int fd, int size)
{
	int idx = fd - 3;

	if (fd < 3 || idx >= FS_MAX_FILES || !nodes[idx].used)
		return -1;
	if (size < 0 || size >= FS_MAX_SIZE)
		return -1;
	nodes[idx].size = size;
	nodes[idx].data[size] = '\0';
	return 0;
}

int fs_close(int fd)
{
	int idx = fd - 3;

	if (fd < 3 || idx >= FS_MAX_FILES)
		return -1;
	return 0;
}

int fs_read_file(const char *path, char *buf, int len)
{
	int fd, n;

	fd = fs_open(path, O_RDONLY);
	if (fd < 0)
		return -1;
	n = fs_read(fd, buf, len);
	fs_close(fd);
	return n;
}

int fs_write_file(const char *path, const char *buf, int len, int truncate)
{
	int fd, flags = O_WRONLY | O_CREAT;
	int n;

	if (truncate)
		flags |= O_TRUNC;
	fd = fs_open(path, flags);
	if (fd < 0)
		return -1;
	if (truncate)
		fs_truncate(fd, 0);
	n = fs_write(fd, buf, len);
	fs_close(fd);
	return n;
}

void fs_seed_file(const char *path, const char *data, int size, int is_dir, int exec)
{
	char norm[FS_MAX_PATH];
	struct fs_node *n;
	int i;

	if (path_normalize(path, norm, sizeof(norm)) < 0)
		return;
	n = lookup_path(norm);
	if (!n) {
		if (is_dir)
			fs_mkdir(norm);
		else
			fs_create(norm, exec);
		n = lookup_path(norm);
	}
	if (!n)
		return;
	if (is_dir) {
		n->is_dir = 1;
		return;
	}
	n->is_dir = 0;
	n->executable = exec;
	if (size < 0) {
		for (i = 0; data[i] && i < FS_MAX_SIZE - 1; i++)
			n->data[i] = data[i];
		n->size = i;
	} else {
		for (i = 0; i < size && i < FS_MAX_SIZE - 1; i++)
			n->data[i] = data[i];
		n->size = i;
	}
	n->data[n->size] = '\0';
}

void fs_init(void)
{
	int i;

	for (i = 0; i < FS_MAX_FILES; i++)
		nodes[i].used = 0;

	fs_mkdir("/");
	fs_mkdir("/home");
	fs_mkdir("/home/root");
	path_copy(cwd, sizeof(cwd), "/home/root");
	fs_load_home();
}
