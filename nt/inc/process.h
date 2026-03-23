/* nt/inc/process.h - Shim for MSVC system <process.h>
   
   This file exists to resolve the conflict between the system
   <process.h> and src/process.h. Since nt/inc is listed before src
   in the include path, #include <process.h> finds this file first.
   We provide the necessary MSVC CRT process declarations directly. */

#ifndef NT_INC_PROCESS_H
#define NT_INC_PROCESS_H

#include <corecrt.h>

#ifndef _P_WAIT
#define _P_WAIT    0
#endif
#ifndef _P_NOWAIT
#define _P_NOWAIT  1
#endif
#ifndef _P_OVERLAY
#define _P_OVERLAY 2
#endif

#ifdef __cplusplus
extern "C" {
#endif

_ACRTIMP intptr_t __cdecl _spawnve(int, char const*, char const* const*, char const* const*);
_ACRTIMP intptr_t __cdecl _spawnvp(int, char const*, char const* const*);
_ACRTIMP intptr_t __cdecl _spawnvpe(int, char const*, char const* const*, char const* const*);
_ACRTIMP intptr_t __cdecl _spawnl(int, char const*, char const*, ...);
_ACRTIMP intptr_t __cdecl _spawnle(int, char const*, char const*, ...);
_ACRTIMP intptr_t __cdecl _spawnlp(int, char const*, char const*, ...);
_ACRTIMP intptr_t __cdecl _spawnlpe(int, char const*, char const*, ...);

_ACRTIMP int __cdecl _getpid(void);

#ifdef __cplusplus
}
#endif

#endif /* NT_INC_PROCESS_H */
