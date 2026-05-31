#ifndef OSVIZ_LOG_H
#define OSVIZ_LOG_H

#define OSVIZ_LOG_DIR  "/var/log/osviz"
#define OSVIZ_LOG_PATH "/var/log/osviz/events.jsonl"

int osviz_log_init(void);
int osviz_log_event(const char *module, const char *event, const char *json_data);

#endif
