#include "os.h"
#include "pmm.h"
#include "osviz_k.h"

/*
 * Following global vars are defined in mem.S
 */
extern ptr_t TEXT_START;
extern ptr_t TEXT_END;
extern ptr_t DATA_START;
extern ptr_t DATA_END;
extern ptr_t RODATA_START;
extern ptr_t RODATA_END;
extern ptr_t BSS_START;
extern ptr_t BSS_END;
extern ptr_t HEAP_START;
extern ptr_t HEAP_SIZE;

const struct pmm_manager *pmm_manager;
struct Page *pmm_pages;
size_t pmm_npages;
ptr_t pmm_alloc_start;
ptr_t pmm_alloc_end;

#define PAGE_SIZE 4096
#define PAGE_ORDER 12

static inline ptr_t align_page(ptr_t address)
{
	ptr_t order = (1 << PAGE_ORDER) - 1;
	return (address + order) & (~order);
}

/*
 * 5.4 选择具体算法，调用其 init()
 * 修改 pmm_manager = &best_fit_pmm_manager 即可切换算法。
 */
static void init_pmm_manager(void)
{
	pmm_manager = &default_pmm_manager;
	/* pmm_manager = &best_fit_pmm_manager; */
	printf("memory management: %s\n", pmm_manager->name);
	pmm_manager->init();
}

void pmm_init(void)
{
	ptr_t heap_start_aligned = align_page(HEAP_START);
	uint32_t num_reserved_pages = LENGTH_RAM / (PAGE_SIZE * PAGE_SIZE);

	pmm_npages = (HEAP_SIZE - (heap_start_aligned - HEAP_START)) / PAGE_SIZE
		     - num_reserved_pages;
	printf("HEAP_START = %p(aligned to %p), HEAP_SIZE = 0x%lx,\n"
	       "num of reserved pages = %d, num of pages to be allocated for heap = %d\n",
	       HEAP_START, heap_start_aligned, HEAP_SIZE,
	       num_reserved_pages, (int)pmm_npages);

	pmm_pages = (struct Page *)HEAP_START;
	pmm_alloc_start = heap_start_aligned + num_reserved_pages * PAGE_SIZE;
	pmm_alloc_end = pmm_alloc_start + (PAGE_SIZE * pmm_npages);

	init_pmm_manager();
	pmm_manager->init_memmap(pmm_pages, pmm_npages);

	printf("TEXT:   %p -> %p\n", TEXT_START, TEXT_END);
	printf("RODATA: %p -> %p\n", RODATA_START, RODATA_END);
	printf("DATA:   %p -> %p\n", DATA_START, DATA_END);
	printf("BSS:    %p -> %p\n", BSS_START, BSS_END);
	printf("HEAP:   %p -> %p\n", (void *)pmm_alloc_start, (void *)pmm_alloc_end);

	pmm_manager->check();

#if CONFIG_LOG
	{
		char buf[160];

		snprintf(buf, sizeof(buf),
			 "\"heap_start\":\"0x%lx\",\"heap_end\":\"0x%lx\","
			 "\"npages\":%d,\"nr_free\":%d,\"algo\":\"%s\"",
			 (unsigned long)pmm_alloc_start, (unsigned long)pmm_alloc_end,
			 (int)pmm_npages, (int)nr_free_pages(), pmm_manager->name);
		osviz_event("pmm", "init", buf);
	}
#endif
}

struct Page *alloc_pages(size_t n)
{
	struct Page *p;
#if CONFIG_LOG
	char buf[128];
#endif

	spin_lock();
	p = pmm_manager->alloc_pages(n);
	spin_unlock();

#if CONFIG_LOG
	if (p) {
		snprintf(buf, sizeof(buf),
			 "\"kva\":\"0x%lx\",\"npages\":%d,\"nr_free\":%d,\"algo\":\"%s\"",
			 (unsigned long)page2kva(p), (int)n, (int)nr_free_pages(),
			 pmm_manager->name);
		osviz_event("pmm", "alloc", buf);
	} else {
		snprintf(buf, sizeof(buf),
			 "\"npages\":%d,\"nr_free\":%d,\"ok\":false",
			 (int)n, (int)nr_free_pages());
		osviz_event("pmm", "alloc_fail", buf);
	}
#endif

	return p;
}

void free_pages(struct Page *base, size_t n)
{
#if CONFIG_LOG
	char buf[128];
	void *kva = page2kva(base);
#endif

	spin_lock();
	pmm_manager->free_pages(base, n);
	spin_unlock();

#if CONFIG_LOG
	if (base) {
		snprintf(buf, sizeof(buf),
			 "\"kva\":\"0x%lx\",\"npages\":%d,\"nr_free\":%d,\"algo\":\"%s\"",
			 (unsigned long)kva, (int)n, (int)nr_free_pages(),
			 pmm_manager->name);
		osviz_event("pmm", "free", buf);
	}
#endif
}

size_t nr_free_pages(void)
{
	return pmm_manager->nr_free_pages();
}

/* 兼容旧接口：vm.c 等仍可直接调用 page_alloc / page_free */
void *page_alloc(int npages)
{
	return page2kva(alloc_pages(npages));
}

void page_free(void *kva)
{
	struct Page *page = kva2page(kva);
	struct Page *p;
	size_t n = 0;

	if (!page)
		return;

	p = page;
	while (p < pmm_pages + pmm_npages) {
		n++;
		if (p->flags & (1 << 1)) /* PAGE_LAST */
			break;
		p++;
	}
	free_pages(page, n);
}
