#ifndef __TYPES_H__
#define __TYPES_H__

typedef unsigned char uint8_t;
typedef unsigned short uint16_t;
typedef unsigned int  uint32_t;
typedef unsigned long long uint64_t;

#ifdef CONFIG_OPENSBI
typedef unsigned long reg_t;
typedef unsigned long ptr_t;
#else
typedef uint32_t reg_t;
typedef uint32_t ptr_t;
#endif

#endif /* __TYPES_H__ */
