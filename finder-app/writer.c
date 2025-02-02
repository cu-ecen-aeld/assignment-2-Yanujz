#include <stdio.h>
#include <stdlib.h>
#include <syslog.h>
#include <errno.h>
#include <string.h>

int main(int argc, char *argv[]) {
    // Open syslog with LOG_USER facility
    openlog("writer", LOG_PID, LOG_USER);

    // Validate input arguments
    if (argc != 3) {
        syslog(LOG_ERR, "Usage: %s <file> <string>", argv[0]);
        fprintf(stderr, "Usage: %s <file> <string>\n", argv[0]);
        closelog();
        return EXIT_FAILURE;
    }

    const char *file_path = argv[1];
    const char *write_str = argv[2];

    // Open file for writing (overwrite if exists)
    FILE *file = fopen(file_path, "w");
    if (file == NULL) {
        syslog(LOG_ERR, "Error opening file %s: %s", file_path, strerror(errno));
        fprintf(stderr, "Error opening file %s: %s\n", file_path, strerror(errno));
        closelog();
        return EXIT_FAILURE;
    }

    // Write string to file
    if (fprintf(file, "%s", write_str) < 0) {
        syslog(LOG_ERR, "Error writing to file %s", file_path);
        fprintf(stderr, "Error writing to file %s\n", file_path);
        fclose(file);
        closelog();
        return EXIT_FAILURE;
    }

    // Close file
    fclose(file);

    // Log success message
    syslog(LOG_DEBUG, "Writing '%s' to '%s'", write_str, file_path);

    // Close syslog
    closelog();

    return EXIT_SUCCESS;
}
