/* See LICENSE file for copyright and license details. */
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "util.h"

void *
ecalloc(size_t nmemb, size_t size)
{
	void *p;

	if (!(p = calloc(nmemb, size)))
		die("calloc:");
	return p;
}

void
die(const char *fmt, ...) {
	va_list ap;

	va_start(ap, fmt);
	vfprintf(stderr, fmt, ap);
	va_end(ap);

	if (fmt[0] && fmt[strlen(fmt)-1] == ':') {
		fputc(' ', stderr);
		perror(NULL);
	} else {
		fputc('\n', stderr);
	}

	exit(1);
}

char
*remove_special_chars(char *str)
{
  char *result = malloc(strlen(str) + 1);
  char *allowedCharsArray = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz-_+='\"123456789,.<>/\\;()!@#$%^&*?| ";
  int i = 0, j = 0;

  while (str[i] != '\0') {
    int l = 0;
    while (allowedCharsArray[l] != '\0') {
      if (allowedCharsArray[l] == str[i]) {
        result[j] = str[i];
        j++;
        break;
      }
      l++;
    }
    i++;
  }

  result[j] = '\0';

  return result;
}
