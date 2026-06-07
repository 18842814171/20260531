#ifndef __PMM_H__
#define __PMM_H__

#include "types.h"
#include <stddef.h>

/*
 * 5.1 抽象物理内存管理器接口（类似 C++ 虚函数表）
 */
struct Page {
	uint8_t flags;
};

struct pmm_manager {
	const char *name;
	void (*init)(void);
	void (*init_memmap)(struct Page *base, size_t n);
	struct Page *(*alloc_pages)(size_t n);
	void (*free_pages)(struct Page *base, size_t n);
	size_t (*nr_free_pages)(void);
	void (*check)(void);
};

extern const struct pmm_manager *pmm_manager;
extern const struct pmm_manager default_pmm_manager;
extern const struct pmm_manager best_fit_pmm_manager;

/* 由 pmm_init() 建立，供 page2kva / kva2page 使用 */
extern struct Page *pmm_pages;
extern size_t pmm_npages;
extern ptr_t pmm_alloc_start;
extern ptr_t pmm_alloc_end;

void pmm_init(void);

/* 5.6 统一入口：框架层做中断保护，算法无需关心 */
struct Page *alloc_pages(size_t n);
void free_pages(struct Page *base, size_t n);
size_t nr_free_pages(void);

static inline void *page2kva(struct Page *page)
{
	if (!page)
		return NULL;
	return (void *)(pmm_alloc_start + (page - pmm_pages) * 4096);
}

static inline struct Page *kva2page(void *kva)
{
	if (!kva || (ptr_t)kva >= pmm_alloc_end)
		return NULL;
	return pmm_pages + ((ptr_t)kva - pmm_alloc_start) / 4096;
}

#endif /* __PMM_H__ */
