/*
 * wipe_lnx
 *
 * See README for copyright, license and explanations.
 *
 * Be warned, this is just meant for demonstration.
 * Use the patch for coreutils for any other purposes.
 *
 * To build use: gcc -O2 -pipe -o wipe_lnx wipe_lnx.c
 */
#include <fcntl.h>
#include <unistd.h>
#include <stdio.h>

#ifndef AT_WIPE
#define AT_WIPE 0x8000
#endif

int main(int argc, char** argv)
{
	if (argc < 2 || *argv[1] == '-' ) {
		fprintf(stderr, "Usage: wipe_lnx FILE...\n");
		return 1;
	}
	while(--argc && *argv[argc] != '-') {
		int rc;
		printf("Trying to wipe file '%s': ", argv[argc]);
		fflush(stdout);
		rc = unlinkat(AT_FDCWD, argv[argc], AT_WIPE);
		if (rc) {
			perror("error: ");
			return 2;
		}
		printf("ok\n");
	}
	return 0;
}
