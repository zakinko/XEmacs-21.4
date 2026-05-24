/* AmigaOS 4 DOS library wrappers for XEmacs.
   This file is compiled separately to avoid header conflicts between
   the AmigaOS SDK (which defines TEXT, SIZEOF_LONG, etc.) and XEmacs
   internal headers.

   Copyright (C) 2026 Free Software Foundation, Inc.

This file is part of XEmacs.

XEmacs is free software; you can redistribute it and/or modify it
under the terms of the GNU General Public License as published by the
Free Software Foundation; either version 2, or (at your option) any
later version.  */

#ifdef AMIGAOS4

#define __USE_INLINE__
#include <proto/dos.h>

/* Wait for input on the AmigaOS console.
   timeout_usecs: microseconds to wait (0 = poll, >0 = block).
   Returns non-zero if input is available. */
int amigaos4_wait_for_char (long timeout_usecs)
{
  return WaitForChar (Input (), timeout_usecs);
}

#endif /* AMIGAOS4 */
