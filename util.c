/*
 * $Id: util.c 134 2016-07-24 15:37:13Z fyurisich $
 */

/*
 *    QPM - QAC based Project Manager
 *
 *    Copyright 2011-2020 Fernando Yurisich <teamqpm@gmail.com>
 *    https://teamqpm.github.io/
 *
 *    Based on QAC - Project Manager for (x)Harbour
 *    Copyright 2006-2011 Carozo de Quilmes <CarozoDeQuilmes@gmail.com>
 *    http://www.CarozoDeQuilmes.com.ar
 *
 *    This program is free software: you can redistribute it and/or modify
 *    it under the terms of the GNU General Public License as published by
 *    the Free Software Foundation, either version 3 of the License, or
 *    (at your option) any later version.
 *
 *    This program is distributed in the hope that it will be useful,
 *    but WITHOUT ANY WARRANTY; without even the implied warranty of
 *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *    GNU General Public License for more details.
 *
 *    You should have received a copy of the GNU General Public License
 *    along with this program. If not, see <https://www.gnu.org/licenses/>.
 */

/*    Adapted from util.c
 *    Convert MS import libraries to GNU imports.
 *    Copyright (C) 1999 Anders Norlander
 */


#include <stdarg.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#include <reimp.h>

char *program_name;

#define swapb(a,b) a ^= b; b ^= a; a ^= b

/* swap little <=> big endian */
uint32_t
swap_endian (uint32_t u)
{
#define swapb(a,b) a ^= b; b ^= a; a ^= b
  unsigned char *p = (unsigned char *) &u;
  swapb (p[0], p[3]);
  swapb (p[1], p[2]);
  return *((uint32_t *) p);
}


/* report warning and terminate */
void
warning (int perr, char *s, ...)
{
  va_list args;

  fprintf (stderr, "%s: ", program_name);
  if (!perr)
    {
      va_start (args, s);
      vfprintf (stderr, s, args);
      va_end (args);
    }
  else
    perror (s);
}

/* report error and terminate */
void
error (int perr, char *s, ...)
{
  va_list args;

  fprintf (stderr, "%s: ", program_name);
  if (!perr)
    {
      va_start (args, s);
      vfprintf (stderr, s, args);
      va_end (args);
    }
  else
    perror (s);
  exit (1);
}

/* allocate memory or die! */
void *
xmalloc (size_t size)
{
  void *p = malloc (size);
  if (!p)
    error (0, "out of memory\n");
  return p;
}

/* check if a string begins with with */
int
begins (char *s, char *with)
{
  return strncmp (s, with, strlen (with)) == 0;
}

#if !defined(_WIN32) && !defined(__MSDOS__)

#ifndef EXIT_FAILURE
#define EXIT_FAILURE 1
#endif

int
spawnvp (int mode, char *path, const char * const *argv)
{
  int pid;
  int status;

  switch ((pid = fork ()))
    {
    case -1:
      return -1;
    case 0:
      execvp (path, (char * const *) argv);

      _exit (EXIT_FAILURE);
      break;
    default:
      if (mode == P_WAIT)
        {
          if (wait (&status) == -1)
            return -1;
          return status;
        }
      else
        return pid;
    }
}
#endif
