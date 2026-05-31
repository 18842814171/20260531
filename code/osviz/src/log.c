#include <errno.h>
#include <fcntl.h>
#include <stdio.h>
#include <string.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <time.h>
#include <unistd.h>

#include "osviz/log.h"

static int ensure_log_dir(void)
{
	if (mkdir(OSVIZ_LOG_DIR, 0755) == 0)
		return 0;
	if (errno == EEXIST)
		return 0;
	return -1;
}

int osviz_log_init(void)
{
	return ensure_log_dir();
}

int osviz_log_event(const char *module, const char *event, const char *json_data)
{
	struct timespec ts;
	FILE *fp;

	if (!module || !event)
		return -1;
	if (ensure_log_dir() != 0)
		return -1;

	if (clock_gettime(CLOCK_REALTIME, &ts) != 0)
		return -1;

	fp = fopen(OSVIZ_LOG_PATH, "a");
	if (!fp)
		return -1;

	if (json_data && json_data[0] != '\0') {
		fprintf(fp,
			"{\"ts\":%.3f,\"module\":\"%s\",\"event\":\"%s\",\"pid\":%d,\"data\":%s}\n",
			ts.tv_sec + ts.tv_nsec / 1000000000.0,
			module, event, (int)getpid(), json_data);
	} else {
		fprintf(fp,
			"{\"ts\":%.3f,\"module\":\"%s\",\"event\":\"%s\",\"pid\":%d}\n",
			ts.tv_sec + ts.tv_nsec / 1000000000.0,
			module, event, (int)getpid());
	}

	if (fflush(fp) != 0) {
		fclose(fp);
		return -1;
	}

	fclose(fp);
	return 0;
}
