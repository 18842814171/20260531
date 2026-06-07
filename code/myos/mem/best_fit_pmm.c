#include "os.h"
#include "pmm.h"

/*
 * 5.4 可插拔算法占位：best-fit 未实现，注册后仅用于演示切换接口。
 * 在 pmm.c 的 init_pmm_manager() 里把 default 换成 best_fit 会 panic。
 */
static void best_fit_init(void)
{
}

static void best_fit_init_memmap(struct Page *base, size_t n)
{
	(void)base;
	(void)n;
}

static struct Page *best_fit_alloc_pages(size_t n)
{
	(void)n;
	panic("best_fit_pmm_manager: alloc_pages not implemented");
	return NULL;
}

static void best_fit_free_pages(struct Page *base, size_t n)
{
	(void)base;
	(void)n;
}

static size_t best_fit_nr_free_pages(void)
{
	return 0;
}

static void best_fit_check(void)
{
	printf("best_fit_pmm_manager: check skipped (placeholder)\n");
}

const struct pmm_manager best_fit_pmm_manager = {
	.name = "best_fit_pmm_manager",
	.init = best_fit_init,
	.init_memmap = best_fit_init_memmap,
	.alloc_pages = best_fit_alloc_pages,
	.free_pages = best_fit_free_pages,
	.nr_free_pages = best_fit_nr_free_pages,
	.check = best_fit_check,
};
