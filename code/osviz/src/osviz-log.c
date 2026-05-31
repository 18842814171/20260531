#include <stdio.h>
#include <stdlib.h>

#include "osviz/log.h"

static void usage(const char *prog)
{
	fprintf(stderr, "Usage: %s <module> <event> [json_data]\n", prog);
	fprintf(stderr, "Example: %s user test '{\"note\":\"hello\"}'\n", prog);
}

int main(int argc, char **argv)
{
	if (argc < 3) {
		usage(argv[0]);
		return 1;
	}

	if (osviz_log_init() != 0) {
		perror("osviz_log_init");
		return 1;
	}

	if (osviz_log_event(argv[1], argv[2], argc >= 4 ? argv[3] : NULL) != 0) {
		perror("osviz_log_event");
		return 1;
	}

	return 0;
}
