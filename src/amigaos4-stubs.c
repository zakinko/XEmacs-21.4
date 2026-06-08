/* Stubs for POSIX and other functions missing from AmigaOS 4 newlib.
   Copyright (C) 2026 Free Software Foundation, Inc.

This file is part of XEmacs.

XEmacs is free software; you can redistribute it and/or modify it
under the terms of the GNU General Public License as published by the
Free Software Foundation; either version 2, or (at your option) any
later version.

XEmacs is distributed in the hope that it will be useful, but WITHOUT
ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
for more details.

You should have received a copy of the GNU General Public License
along with XEmacs; see the file COPYING.  If not, write to
the Free Software Foundation, Inc., 59 Temple Place - Suite 330,
Boston, MA 02111-1307, USA.  */

/* This file provides stub implementations of POSIX functions that
   AmigaOS 4's newlib does not provide.  These stubs allow XEmacs to
   link; full implementations can be added as the port matures. */

#include <config.h>

#ifdef AMIGAOS4

#include "lisp.h"
#include <errno.h>
#include <signal.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>

/* Request a large stack from the AmigaOS process loader.
   The portable dumper (pdump) traverses the entire Lisp object graph
   recursively and can easily exceed the default 64KB-256KB stack.
   8MB should be more than sufficient. */
#ifdef __GNUC__
static const char __attribute__((used)) stackcookie[] = "$STACK:8388608";
#endif
unsigned long __stack = 8388608;  /* newlib stack request (8 MB) */

/* ==================== Early initialization ==================== */

/* Sanitize the PATH environment variable.
   AmigaOS 4 systems with Cygnix installed have a Unix-style PATH
   using ':' as separator (e.g., "/Cygnix/bin:/C:").  These paths
   trigger "Please insert volume" requesters when accessed via
   newlib.  If PATH starts with '/', it is Cygnix-corrupted and
   we replace it entirely with "C:" (the system command directory).
   A properly configured AmigaOS PATH uses ';' as separator and
   contains only absolute volume paths like "C:;SYS:Utilities". */
void amigaos4_early_init (void)
{
  const char *path = getenv ("PATH");
  if (path && path[0] == '/')
    setenv ("PATH", "C:", 1);
}

/* ==================== Process stubs ==================== */

/* AmigaOS 4 does not have fork().  Return -1 with ENOSYS. */
pid_t fork (void)
{
  errno = ENOSYS;
  return (pid_t) -1;
}

/* AmigaOS 4 does not have pipe(). */
int pipe (int fd[2])
{
  errno = ENOSYS;
  return -1;
}

/* AmigaOS 4 does not have wait3(). */
pid_t wait3 (int *status, int options, void *rusage)
{
  errno = ENOSYS;
  return (pid_t) -1;
}

/* ==================== Signal/timer stubs ==================== */

/* AmigaOS 4 newlib does not have alarm(). */
unsigned int alarm (unsigned int seconds)
{
  /* No-op: pretend no previous alarm was pending. */
  return 0;
}

/* AmigaOS 4 newlib does not have pause(). */
int pause (void)
{
  errno = ENOSYS;
  return -1;
}

/* ==================== Filesystem stubs ==================== */

/* AmigaOS 4 newlib has fsync() but not sync(). */
void sync (void)
{
  /* No-op on AmigaOS 4. */
}

/* ==================== Signal name stubs ==================== */

/* AmigaOS 4 newlib does not have strsignal(). */
char *strsignal (int signum)
{
  static char buf[32];
  sprintf (buf, "Signal %d", signum);
  return buf;
}

/* ==================== Profiling stubs ==================== */
/* These are needed because profile.c requires HAVE_SETITIMER,
   which AmigaOS 4 does not have.  The profiling variables and
   functions are referenced unconditionally in eval.c and
   redisplay.c, so we provide no-op stubs here. */

int profiling_active;
int profiling_redisplay_flag;

void
profile_increase_call_count (Lisp_Object fun)
{
  /* No-op without setitimer-based profiling. */
}

void
mark_profiling_info (void)
{
  /* No-op. */
}

void
syms_of_profile (void)
{
  /* No-op. */
}

void
vars_of_profile (void)
{
  /* No-op. */
}

/* AmigaOS 4 newlib does not have execvp(). */
int execvp (const char *file, char *const argv[])
{
  errno = ENOSYS;
  return -1;
}

#endif /* AMIGAOS4 */
