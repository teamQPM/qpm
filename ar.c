/*
 *    QPM - QAC based Project Manager
 *
 *    Copyright 2011-2020 Fernando Yurisich <qpm-users@lists.sourceforge.net>
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

/*    Adapted from ar.c
 *    Convert MS import libraries to GNU imports.
 *    Copyright (C) 1999 Anders Norlander
 */


#include <reimp.h>
#include <ctype.h>
#include <string.h>
#include <stdlib.h>

#define LONG_NAMES_NAME "//              "
char *long_names = NULL;

/* read an archive header */
int
ar_read_header (struct ar_hdr *hdr, FILE *f)
{
  size_t size;
  //fseek(f, (ftell(f) + 1) & ~1, SEEK_SET);	// or should it be fixed here?
  if (fread (hdr, sizeof (*hdr), 1, f) == 1)
    {
      if (memcmp (ARFMAG, hdr->ar_fmag, 2) != 0)
        return 0;
      if (memcmp (hdr->ar_name, LONG_NAMES_NAME, 16) == 0)
        {
          size = strtol (hdr->ar_size, NULL, 10);
          long_names = xmalloc (size);
          if (fread (long_names, size, 1, f) != 1)
            error (0, "unexpected end-of-file\n");
        }
      return 1;
    }
  else
    return 0;
}

char *
get_ar_name (struct ar_hdr *hdr)
{
  int i;
  static char buf[32];
  if (hdr->ar_name[0] == '/' && isdigit (hdr->ar_name[1]) && long_names)
    return long_names + strtol (hdr->ar_name + 1, NULL, 10);

  for (i = 0; i < 16; i++)
    {
      if (hdr->ar_name[i] == ' ')
        {
          hdr->ar_name[i] = '\0';
          return hdr->ar_name;
        }
    }
  memcpy (buf, hdr->ar_name, 16);
  buf[16] = '\0';
  return buf;
}
