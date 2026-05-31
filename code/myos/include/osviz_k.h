#ifndef __OSVIZ_K_H__
#define __OSVIZ_K_H__

#define OSVIZ_PREFIX_EVENT    "OSVIZ "
#define OSVIZ_PREFIX_SNAPSHOT "OSVIZ_SNAPSHOT "

#define MYOS_NAME    "myos"
#define MYOS_VERSION "0.2.0-boot"

void osviz_init(void);
uint64_t osviz_millis(void);
int osviz_event(const char *module, const char *event, const char *json_data);
int osviz_snapshot(void);
void osviz_boot_banner(void);

#endif /* __OSVIZ_K_H__ */
