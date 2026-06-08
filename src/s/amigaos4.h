/* System description file for AmigaOS 4 (ppc-amigaos).
   Copyright (C) 2026 Free Software Foundation, Inc.

This file is part of XEmacs.

XEmacs is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2, or (at your option)
any later version.

XEmacs is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with XEmacs; see the file COPYING.  If not, write to
the Free Software Foundation, Inc., 59 Temple Place - Suite 330,
Boston, MA 02111-1307, USA.  */

/* AmigaOS 4 with newlib provides a POSIX-like environment for
   cross-compilation using the ppc-amigaos-gcc toolchain. */

#ifndef AMIGAOS4
#define AMIGAOS4
#endif

/* Disable small data sections (.sdata/.sbss) so that all global variables
   reside in .data/.bss and are relocated uniformly by the ELF loader.
   This is required for PDUMP's data_delta relocation to work correctly. */
#define C_SWITCH_SYSTEM "-msdata=none"

/* SYSTEM_TYPE should indicate the kind of system you are using.
   It sets the Lisp variable system-type.  */
#define SYSTEM_TYPE "amigaos4"

/* Use the portable dumper -- no unexec support on AmigaOS 4. */
#define CANNOT_DUMP

/* Use ordinary linking -- no special dumper tricks needed. */
#ifndef ORDINARY_LINK
#define ORDINARY_LINK
#endif

/* Use the system malloc -- we do not have unexec to remap the heap. */
#define SYSTEM_MALLOC

/* POSIX-like system calls are available via newlib. */
#define POSIX

/* On POSIX systems the system calls are interruptible by signals
   that the user program has elected to catch.  Thus the system call
   must be retried in these cases. */
#define INTERRUPTIBLE_OPEN
#define INTERRUPTIBLE_CLOSE
#define INTERRUPTIBLE_IO

/* newlib provides alloca via __builtin_alloca with GCC. */
#define HAVE_ALLOCA

/* AmigaOS 4 does not have real PTYs in the Unix sense. */
/* #undef HAVE_PTYS */

/* AmigaOS 4 does not have Unix-style process groups or job control
   in the traditional sense. */
#define NOMULTIPLEJOBS

/* The null device on AmigaOS 4. */
#define NULL_DEVICE "NIL:"

/* AmigaOS uses ':' as a volume/device separator (e.g., "Work:path").
   The path separator within a path is '/'.  For the executable search
   path, we use ';' since ':' is used in volume names. */
#define SEPCHAR ';'

/* ':' acts as a device separator in AmigaOS paths (e.g., "Work:path").
   IS_ANY_SEP recognizes both '/' and ':' so that path-scanning code
   (like pdump_load) correctly handles volume-qualified paths. */
#define DEVICE_SEP ':'
#define IS_DIRECTORY_SEP(c) ((c) == '/')
#define IS_ANY_SEP(c) (IS_DIRECTORY_SEP (c) || ((c) == DEVICE_SEP))

/* Recognize AmigaOS volume-qualified paths as absolute.
   A path like "Work:foo/bar" or "SYS:" is absolute on AmigaOS. */
#ifndef NOT_C_CODE
#include <string.h>
static inline int
amigaos_absolute_path_p (const char *path)
{
  const char *colon = strchr (path, ':');
  /* It's absolute if ':' appears before any '/' */
  return (colon != NULL && (strchr (path, '/') == NULL || colon < strchr (path, '/')));
}
#define IS_AMIGAOS_ABSOLUTE(p) amigaos_absolute_path_p ((const char *)(p))
#endif

/* newlib provides most standard time functions. */
#ifndef HAVE_TIMEVAL
#define HAVE_TIMEVAL
#endif

/* Standard C library functions available in newlib.
   Most of these are autodetected by configure; listing here
   only those that configure's cross-compile tests may miss. */

/* Do not try to include sioctl.h -- AmigaOS does not have it. */
#define NO_SIOCTL_H

/* Sanitize the PATH environment variable at startup.
   AmigaOS 4 systems with Cygnix installed have Unix-style paths
   in PATH (e.g., /Cygnix/CygnixPPC/local/bin) that trigger
   "Please insert volume" requesters when accessed via newlib.
   Replace PATH with a safe AmigaOS-native value early. */
#define EXTRA_INITIALIZE amigaos4_early_init()
#ifndef NOT_C_CODE
extern void amigaos4_early_init(void);
#endif

/* TAB3 is not defined in newlib's termios.  Define as 0 (no-op). */
#ifndef NOT_C_CODE
#ifndef TAB3
#define TAB3 0
#endif
#endif

/* newlib's getpgrp() takes no arguments (POSIX.1 style). */
#ifndef GETPGRP_VOID
#define GETPGRP_VOID
#endif

/* newlib provides strsignal(). */
#ifndef HAVE_STRSIGNAL
#define HAVE_STRSIGNAL
#endif

/* newlib defines PATH_MAX but not _POSIX_PATH_MAX. */
#ifndef NOT_C_CODE
#include <limits.h>
#ifndef _POSIX_PATH_MAX
#ifdef PATH_MAX
#define _POSIX_PATH_MAX PATH_MAX
#else
#define _POSIX_PATH_MAX 1024
#endif
#endif
#endif

/* newlib provides wait-related headers. */
#define HAVE_WAIT_HEADER

/* Do not define LOAD_AVE_TYPE or LOAD_AVE_CVT
   since there is no load average available on AmigaOS.
   The guard in m/powerpc.h checks for AMIGAOS4. */

/* Ask GCC where to find libgcc.a.  */
#define LIB_GCC "`$(CC) $(C_SWITCH_X_SITE) -print-libgcc-file-name`"

/* Terminal library -- use built-in termcap if no system library is available. */
/* #undef LIBS_TERMCAP */

/* No special system libraries needed beyond newlib defaults. */
#define LIBS_SYSTEM

/* No special debug libraries. */
#define LIBS_DEBUG

/* AmigaOS 4 does not have Unix-style process support.
   We will need to stub or emulate subprocess functionality. */
/* #undef HAVE_UNIX_PROCESSES */

/* Sockets are available via bsdsocket.library, but may need
   special initialization.  Autodetected by configure. */

/* Pending output detection for newlib stdio. */
#ifndef NOT_C_CODE
#include <stdio.h>
/* newlib's FILE structure -- adjust if needed at compile time */
#ifdef __NEWLIB__
#define GNU_LIBRARY_PENDING_OUTPUT_COUNT(FILE) \
  ((FILE)->_p - (FILE)->_bf._base)
#endif
#endif /* NOT_C_CODE */

/* Executable suffix for AmigaOS 4 binaries. */
#define EXEC_SUFFIXES ""
