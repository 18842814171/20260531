#ifndef  LOG_H
#define  LOG_H

#define  LOG_DIR  "/var/log/osviz"
#define  LOG_PATH "/var/log/osviz/events.jsonl"

int osviz_log_init(void);
int osviz_log_event(const char *module, const char *event, const char *json_data);

#endif
