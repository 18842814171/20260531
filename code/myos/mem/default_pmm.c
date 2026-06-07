#include "os.h"
#include "pmm.h"

#define PAGE_SIZE 4096

#define PAGE_TAKEN (uint8_t)(1 << 0)
#define PAGE_LAST  (uint8_t)(1 << 1)

static size_t nr_free;

static inline void page_clear(struct Page *page)
{
	page->flags = 0;
}

static inline int page_is_free(struct Page *page)
{
	return !(page->flags & PAGE_TAKEN);
}

static inline void page_set_flag(struct Page *page, uint8_t flags)
{
	page->flags |= flags;
}

static inline int page_is_last(struct Page *page)
{
	return (page->flags & PAGE_LAST) != 0;
}

static void default_init(void)
{
	nr_free = 0;
}

static void default_init_memmap(struct Page *base, size_t n)
{
	size_t i;

	for (i = 0; i < n; i++)
		page_clear(base + i);
	nr_free = n;
}

static struct Page *default_alloc_pages(size_t n)
{
	int found;
	size_t i, j, k;

	if (n == 0 || n > pmm_npages)
		return NULL;

	for (i = 0; i <= pmm_npages - n; i++) {
		if (!page_is_free(pmm_pages + i))
			continue;
		found = 1;
		for (j = i + 1; j < i + n; j++) {
			if (!page_is_free(pmm_pages + j)) {
				found = 0;
				break;
			}
		}
		if (found) {
			for (k = i; k < i + n; k++)
				page_set_flag(pmm_pages + k, PAGE_TAKEN);
			page_set_flag(pmm_pages + i + n - 1, PAGE_LAST);
			nr_free -= n;
			return pmm_pages + i;
		}
	}
	return NULL;
}

static void default_free_pages(struct Page *base, size_t n)
{
	size_t i;

	if (!base || base < pmm_pages || base >= pmm_pages + pmm_npages)
		return;

	for (i = 0; i < n; i++) {
		if (base + i >= pmm_pages + pmm_npages)
			break;
		page_clear(base + i);
	}
	nr_free += n;
}

static size_t default_nr_free_pages(void)
{
	return nr_free;
}

static void default_check(void)
{
	struct Page *p;

	printf("pmm check: nr_free=%d\n", (int)nr_free);
	p = default_alloc_pages(2);
	printf("pmm check: alloc 2 -> %p\n", page2kva(p));
	if (p)
		default_free_pages(p, 2);
}

const struct pmm_manager default_pmm_manager = {
	.name = "default_pmm_manager",
	.init = default_init,
	.init_memmap = default_init_memmap,
	.alloc_pages = default_alloc_pages,
	.free_pages = default_free_pages,
	.nr_free_pages = default_nr_free_pages,
	.check = default_check,
};
