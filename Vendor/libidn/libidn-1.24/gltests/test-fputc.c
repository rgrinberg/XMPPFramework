/* Test of fputc() function.
   Copyright (C) 2011-2012 Free Software Foundation, Inc.

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 3, or (at your option)
   any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software Foundation,
   Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.  */

#include <config.h>

#include <stdio.h>

#include "signature.h"
SIGNATURE_CHECK (fputc, int, (int, FILE *));

#include <errno.h>
#include <fcntl.h>
#include <unistd.h>

#include "msvc-inval.h"

#include "macros.h"

int
main (int argc, char **argv)
{
  const char *filename = "test-fputc.txt";

  /* We don't have an fputc() function that installs an invalid parameter
     handler so far.  So install that handler here, explicitly.  */
#if HAVE_MSVC_INVALID_PARAMETER_HANDLER \
    && MSVC_INVALID_PARAMETER_HANDLING == DEFAULT_HANDLING
  gl_msvc_inval_ensure_handler ();
#endif

  /* Test that fputc() on an unbuffered stream sets errno if someone else
     closes the stream fd behind the back of stdio.  */
  {
    FILE *fp = fopen (filename, "w");
    ASSERT (fp != NULL);
    setvbuf (fp, NULL, _IONBF, 0);
    ASSERT (close (fileno (fp)) == 0);
    errno = 0;
    ASSERT (fputc ('x', fp) == EOF);
    ASSERT (errno == EBADF);
    ASSERT (ferror (fp));
    fclose (fp);
  }

  /* Test that fputc() on an unbuffered stream sets errno if the stream
     was constructed with an invalid file descriptor.  */
  {
    FILE *fp = fdopen (-1, "w");
    if (fp != NULL)
      {
        setvbuf (fp, NULL, _IONBF, 0);
        errno = 0;
        ASSERT (fputc ('x', fp) == EOF);
        ASSERT (errno == EBADF);
        ASSERT (ferror (fp));
        fclose (fp);
      }
  }
  {
    FILE *fp = fdopen (99, "w");
    if (fp != NULL)
      {
        setvbuf (fp, NULL, _IONBF, 0);
        errno = 0;
        ASSERT (fputc ('x', fp) == EOF);
        ASSERT (errno == EBADF);
        ASSERT (ferror (fp));
        fclose (fp);
      }
  }

  /* Clean up.  */
  unlink (filename);

  return 0;
}
