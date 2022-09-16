/* See LICENSE file for copyright and license details. */
#include <sys/stat.h>

#include <dirent.h>
#include <limits.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#include "arg.h"
char *argv0;

#define FLAG(x)  (flag[(x)-'a'])

static void test(const char *, const char *);
static void usage(void);

static int match = 0;
static int flag[26];
static struct stat old, new;

static void
test(const char *path, const char *name)
{
	struct stat st, ln;

	if ((!stat(path, &st) && (FLAG('a') || name[0] != '.')        /* hidden files      */
	&& (!FLAG('b') || S_ISBLK(st.st_mode))                        /* block special     */
	&& (!FLAG('c') || S_ISCHR(st.st_mode))                        /* character special */
	&& (!FLAG('d') || S_ISDIR(st.st_mode))                        /* directory         */
	&& (!FLAG('e') || access(path, F_OK) == 0)                    /* exists            */
	&& (!FLAG('f') || S_ISREG(st.st_mode))                        /* regular file      */
	&& (!FLAG('g') || st.st_mode & S_ISGID)                       /* set-group-id flag */
	&& (!FLAG('h') || (!lstat(path, &ln) && S_ISLNK(ln.st_mode))) /* symbolic link     */
	&& (!FLAG('n') || st.st_mtime > new.st_mtime)                 /* newer than file   */
	&& (!FLAG('o') || st.st_mtime < old.st_mtime)                 /* older than file   */
	&& (!FLAG('p') || S_ISFIFO(st.st_mode))                       /* named pipe        */
	&& (!FLAG('r') || access(path, R_OK) == 0)                    /* readable          */
	&& (!FLAG('s') || st.st_size > 0)                             /* not empty         */
	&& (!FLAG('u') || st.st_mode & S_ISUID)                       /* set-user-id flag  */
	&& (!FLAG('w') || access(path, W_OK) == 0)                    /* writable          */
	&& (!FLAG('x') || access(path, X_OK) == 0)) != FLAG('v')) {   /* executable        */
		if (FLAG('q'))
			exit(0);
		match = 1;
		puts(name);
	}
}

static void
usage(void)
{
	fprintf(stderr, "usage: %s [-abcdefghlpqrsuvwx] "
	        "[-n file] [-o file] [file...]\n", argv0);
	exit(2); /* like test(1) return > 1 on error */
}

int
main(int argc, char *argv[])
{
	struct dirent *d;
	char path[PATH_MAX], *line = NULL, *file;
	size_t linesiz = 0;
	ssize_t n;
	DIR *dir;
	int r;

	ARGBEGIN {
	case 'n': /* newer than file */
	case 'o': /* older than file */
		file = EARGF(usage());
		if (!(FLAG(ARGC()) = !stat(file, (ARGC() == 'n' ? &new : &old))))
			perror(file);
		break;
	default:
		/* miscellaneous operators */
		if (strchr("abcdefghlpqrsuvwx", ARGC()))
			FLAG(ARGC()) = 1;
		else
			usage(); /* unknown flag */
	} ARGEND;

	if (!argc) {
		/* read list from stdin */
		while ((n = getline(&line, &linesiz, stdin)) > 0) {
			if (line[n - 1] == '\n')
				line[n - 1] = '\0';
			test(line, line);
		}
		free(line);
	} else {
		for (; argc; argc--, argv++) {
			if (FLAG('l') && (dir = opendir(*argv))) {
				/* test directory contents */
				while ((d = readdir(dir))) {
					r = snprintf(path, sizeof path, "%s/%s",
					             *argv, d->d_name);
					if (r >= 0 && (size_t)r < sizeof path)
						test(path, d->d_name);
				}
				closedir(dir);
			} else {
				test(*argv, *argv);
			}
		}
	}
	return match ? 0 : 1;
}
