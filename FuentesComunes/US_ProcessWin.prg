/*
 * $Id$
 */

/*
 *    QPM - QAC Based Project Manager
 *
 *    Copyright 2011 Fernando Yurisich <fernando.yurisich@gmail.com>
 *    http://qpm.sourceforge.net
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
 *    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

//========================================================================
// Function US_GetProcessesNT()      Lista procesos en NT
// Retorna un vector (que comienza con indice en 1) con el ProcessID
// en los elementos impares
// y el nombre del proceso en los pares
// Ejemplo:
//   [1]    403
//   [2]    c:\winNT\System32\lla.exe
//   [3]    34
//   [4]    c:\winNT\System32\www.exe
//   [5]    121
//   [6]    d:\xxxxx\xxxxxxx\rte.exe
//------------------------------------------------------------------------
Function US_GetProcessesNT()
Return US_2GETPROCESSESNT()

#pragma BEGINDUMP
#include <windows.h>
#include <stdio.h>
#include <tchar.h>
#include "psapi.h"
#include "hbapi.h"

#ifdef __XHARBOUR__
   #define HB_STORC( n, x, y )    hb_storc( n, x, y )
   #define HB_STORNI( n, x, y )   hb_storni( n, x, y )
   #define HB_STORL( n, x, y )    hb_storl( n, x, y )
   #define HB_STORNL( n, x, y )   hb_stornl( n, x, y )
#else
   #define HB_STORC( n, x, y )    hb_storvc( n, x, y )
   #define HB_STORNI( n, x, y )   hb_storvni( n, x, y )
   #define HB_STORL( n, x, y )    hb_storvl( n, x, y )
   #define HB_STORNL( n, x, y )   hb_storvnl( n, x, y )
#endif

/*
typedef ULONG (FAR PASCAL MAPILOGON)(
    ULONG ulUIParam,
    LPSTR lpszProfileName,
    LPSTR lpszPassword,
    FLAGS flFlags,
    ULONG ulReserved,
    LPLHANDLE lplhSession
);
typedef MAPILOGON FAR *LPMAPILOGON;
MAPILOGON MAPILogon;
*/

typedef BOOL WINAPI (FAR PASCAL ENUMPROCESSES)(
    DWORD * lpidProcess,
    DWORD   cb,
    DWORD * cbNeeded
);
typedef ENUMPROCESSES FAR *LPENUMPROCESSES;
ENUMPROCESSES EnumProcesses;

typedef BOOL WINAPI (FAR PASCAL ENUMPROCESSMODULES)(
    HANDLE hProcess,
    HMODULE *lphModule,
    DWORD cb,
    LPDWORD lpcbNeeded
);
typedef ENUMPROCESSMODULES FAR *LPENUMPROCESSMODULES;
ENUMPROCESSMODULES EnumProcessModules;

typedef DWORD WINAPI (FAR PASCAL GETMODULEFILENAMEEXA)(
    HANDLE hProcess,
    HMODULE hModule,
    LPSTR lpFilename,
    DWORD nSize
);
typedef GETMODULEFILENAMEEXA FAR *LPGETMODULEFILENAMEEXA;
GETMODULEFILENAMEEXA GetModuleFileNameExA;

/*
BOOL
WINAPI
EnumProcesses(
    DWORD * lpidProcess,
    DWORD   cb,
    DWORD * cbNeeded
    );
BOOL
WINAPI
EnumProcessModules(
    HANDLE hProcess,
    HMODULE *lphModule,
    DWORD cb,
    LPDWORD lpcbNeeded
    );
DWORD
WINAPI
GetModuleFileNameExA(
    HANDLE hProcess,
    HMODULE hModule,
    LPSTR lpFilename,
    DWORD nSize
    );
*/

HINSTANCE      hPsApiLib = 0;
LPENUMPROCESSES pEnumProcesses = NULL;
LPENUMPROCESSMODULES pEnumProcessModules = NULL;
LPGETMODULEFILENAMEEXA pGetModuleFileNameExA = NULL;

HB_FUNC(US_2GETPROCESSESNT)
{
   DWORD aProcesses[1024], cbNeeded, cProcesses;
   unsigned int i;
   // Load Library and obtain pointers
   hPsApiLib = LoadLibrary("PSAPI.DLL");
   if (!hPsApiLib)
      {
      hb_reta( 2 );
      HB_STORNI( 101 , -1, 1 );
      HB_STORC( "Error in load of DLL PSAPI.DLL from Function GetProcessesNT" , -1, 2 );
      return;
      }
   pEnumProcesses = (LPENUMPROCESSES) GetProcAddress(hPsApiLib, "EnumProcesses");
   if (! pEnumProcesses)
      {
      hb_reta( 2 );
      HB_STORNI( 102 , -1, 1 );
      HB_STORC( "Error in GetProcAddress of Function EnumProcesses of DLL PSAPI.DLL from Function GetProcessesNT" , -1, 2 );
      FreeLibrary(hPsApiLib);
      return;
      }
   pEnumProcessModules = (LPENUMPROCESSMODULES) GetProcAddress(hPsApiLib, "EnumProcessModules");
   if (! pEnumProcessModules)
      {
      hb_reta( 2 );
      HB_STORNI( 103 , -1, 1 );
      HB_STORC( "Error in GetProcAddress of Function EnumProcessModules of DLL PSAPI.DLL from Function GetProcessesNT" , -1, 2 );
      FreeLibrary(hPsApiLib);
      return;
      }
   pGetModuleFileNameExA = (LPGETMODULEFILENAMEEXA) GetProcAddress(hPsApiLib, "GetModuleFileNameExA");
   if (! pGetModuleFileNameExA)
      {
      hb_reta( 2 );
      HB_STORNI( 104 , -1, 1 );
      HB_STORC( "Error in GetProcAddress of Function GetModuleFileNameExA of DLL PSAPI.DLL from Function GetProcessesNT" , -1, 2 );
      FreeLibrary(hPsApiLib);
      return;
      }
   // Get the list of process identifiers.
   if ( !pEnumProcesses( aProcesses, sizeof(aProcesses), &cbNeeded ) )
      {
      hb_reta( 2 );
      HB_STORNI( 105 , -1, 1 );
      HB_STORC( "Error in Function EnumProcesses of DLL PSAPI.DLL from Function GetProcessesNT" , -1, 2 );
      FreeLibrary(hPsApiLib);
      return;
      }
   // Calculate how many process identifiers were returned.
   cProcesses = cbNeeded / sizeof(DWORD);
   // establezco el tamaño del vector a devolver
   hb_reta( cProcesses * 2 );
   // Print the name and process identifier for each process.
   for ( i = 0; i < cProcesses; i++ )
       {
       // Get a handle to the process.
       HANDLE hProcess = OpenProcess( PROCESS_QUERY_INFORMATION |
                                      PROCESS_VM_READ,
                                      FALSE, aProcesses[i] );
       // Get the process name.
       TCHAR szProcessName[MAX_PATH];
       if (NULL != hProcess )
          {
          HMODULE hMod;
          DWORD cbNeeded;
          if ( pEnumProcessModules( hProcess, &hMod, sizeof(hMod),
               &cbNeeded) )
             {
       //    GetModuleBaseName( hProcess, hMod, szProcessName,
       //                       sizeof(szProcessName)/sizeof(TCHAR) );
             pGetModuleFileNameExA( hProcess, hMod, szProcessName,
                                sizeof(szProcessName)/sizeof(TCHAR) );
       //    GetModuleFileNameEx( hProcess, hMods[i], szModName,
       //                            sizeof(szModName)/sizeof(TCHAR))
             }
          }
       else
          {
          wsprintf(szProcessName,"%s",TEXT("<unknown>"));
          }
          // Print the process name and identifier.
     //   _tprintf( TEXT("%s  (PID: %u)\n"), szProcessName, aProcesses[i] );
          HB_STORNI( aProcesses[i] , -1, ( ( i + 1 ) * 2 ) - 1 );
          HB_STORC( szProcessName , -1, ( ( i + 1 ) * 2 ));
       };
   FreeLibrary(hPsApiLib);
}
#pragma ENDDUMP
//------------------------------------------------------------------------
// Fin Function US_GetProcessesNT()
//========================================================================

//========================================================================
// Function US_GetProcessesW9X()      Lista procesos en Windows 9X
// Retorna un vector (que comienza con indice en 1) con el ProcessID
// en los elementos impares
// y el nombre del proceso en los pares
// Ejemplo:
//   [1]    403
//   [2]    c:\windows\System32\lla.exe
//   [3]    34
//   [4]    c:\windows\System32\www.exe
//   [5]    121
//   [6]    d:\xxxxx\xxxxxxx\rte.exe
//------------------------------------------------------------------------
Function US_GetProcessesW9X()
Return US_2GETPROCESSESW9X()

#pragma BEGINDUMP
#include <windows.h>
#include <tlhelp32.h>
#include <stdio.h>
#include "hbapi.h"

/*
typedef ULONG (FAR PASCAL MAPILOGON)(
    ULONG ulUIParam,
    LPSTR lpszProfileName,
    LPSTR lpszPassword,
    FLAGS flFlags,
    ULONG ulReserved,
    LPLHANDLE lplhSession
);
typedef MAPILOGON FAR *LPMAPILOGON;
MAPILOGON MAPILogon;
*/

typedef HANDLE WINAPI (FAR PASCAL CREATETOOLHELP32SNAPSHOT)(
    DWORD dwFlags,
    DWORD th32ProcessID
);
typedef CREATETOOLHELP32SNAPSHOT FAR *LPCREATETOOLHELP32SNAPSHOT;
CREATETOOLHELP32SNAPSHOT CreateToolhelp32Snapshot;

typedef BOOL WINAPI (FAR PASCAL PROCESS32FIRST)(
    HANDLE hSnapshot,
    LPPROCESSENTRY32 lppe
);
typedef PROCESS32FIRST FAR *LPPROCESS32FIRST;
PROCESS32FIRST Process32First;

typedef BOOL WINAPI (FAR PASCAL PROCESS32NEXT)(
    HANDLE hSnapshot,
    LPPROCESSENTRY32 lppe
);
typedef PROCESS32NEXT FAR *LPPROCESS32NEXT;
PROCESS32NEXT Process32Next;

/*
HANDLE
WINAPI
CreateToolhelp32Snapshot(
    DWORD dwFlags,
    DWORD th32ProcessID
    );
BOOL
WINAPI
Process32First(
    HANDLE hSnapshot,
    LPPROCESSENTRY32 lppe
    );

BOOL
WINAPI
Process32Next(
    HANDLE hSnapshot,
    LPPROCESSENTRY32 lppe
    );
*/

HINSTANCE      bKernelDll = 0;
LPCREATETOOLHELP32SNAPSHOT pCreateToolhelp32Snapshot = NULL;
LPPROCESS32FIRST pProcess32First = NULL;
LPPROCESS32NEXT pProcess32Next = NULL;

HB_FUNC(US_2GETPROCESSESW9X)
{
   HANDLE hProcessSnap;
   PROCESSENTRY32 pe32;
   int i=0;
   bKernelDll = LoadLibrary("KERNEL32.DLL");
   if (!bKernelDll)
      {
      hb_reta( 2 );
      HB_STORNI( 901 , -1, 1 );
      HB_STORC( "Error in load of DLL PSAPI.DLL from Function GetProcessesNT" , -1, 2 );
      return;
      }
   pCreateToolhelp32Snapshot = (LPCREATETOOLHELP32SNAPSHOT) GetProcAddress(bKernelDll, "CreateToolhelp32Snapshot");
   if (! pCreateToolhelp32Snapshot)
      {
      hb_reta( 2 );
      HB_STORNI( 902 , -1, 1 );
      HB_STORC( "Error in GetProcAddress of Function CreateToolhelp32Snapshot of DLL KERNEL32.DLL from Function GetProcessesNT" , -1, 2 );
      FreeLibrary(bKernelDll);
      return;
      }
   pProcess32First = (LPPROCESS32FIRST) GetProcAddress(bKernelDll, "Process32First");
   if (! pProcess32First)
      {
      hb_reta( 2 );
      HB_STORNI( 903 , -1, 1 );
      HB_STORC( "Error in GetProcAddress of Function Process32First of DLL KERNEL32.DLL from Function GetProcessesNT" , -1, 2 );
      FreeLibrary(bKernelDll);
      return;
      }
   pProcess32Next = (LPPROCESS32NEXT) GetProcAddress(bKernelDll, "Process32Next");
   if (! pProcess32Next)
      {
      hb_reta( 2 );
      HB_STORNI( 904 , -1, 1 );
      HB_STORC( "Error in GetProcAddress of Function Process32Next of DLL KERNEL32.DLL from Function GetProcessesNT" , -1, 2 );
      FreeLibrary(bKernelDll);
      return;
      }
   // Take a snapshot of all processes in the system.
   hProcessSnap = pCreateToolhelp32Snapshot( TH32CS_SNAPPROCESS, 0 );
   if( hProcessSnap == INVALID_HANDLE_VALUE )
      {
      hb_reta( 2 );
      HB_STORNI( 905 , -1, 1 );
      HB_STORC( "Error in Create of function CreateToolhelp32Snapshot of DLL Kernel.DLL from Function US_GetProcessesW9X" , -1, 2 );
      return;
      }
   // Set the size of the structure before using it.
   pe32.dwSize = sizeof( PROCESSENTRY32 );
   // Retrieve information about the first process,
   // and exit if unsuccessful
   hb_reta( 100 );
   if( !pProcess32First( hProcessSnap, &pe32 ) )
      {
      hb_reta( 2 );
      HB_STORNI( 906 , -1, 1 );
      HB_STORC( "Error in Function Process32First of DLL Kernel.DLL from Function US_GetProcessesW9X" , -1, 2 );
      CloseHandle( hProcessSnap );     // Must clean up the snapshot object!
      return;
      }
   do
      {
      i++;
      //printf( "\nPROCESS NAME:  %s", pe32.szExeFile );
      //printf( "\n  process ID        = 0x%08X", pe32.th32ProcessID );
      HB_STORNI( pe32.th32ProcessID , -1, ( ( i + 1 ) * 2 ) - 1 );
      HB_STORC( pe32.szExeFile , -1, ( ( i + 1 ) * 2 ));
      } while( pProcess32Next( hProcessSnap, &pe32 ) );
   CloseHandle( hProcessSnap );
   FreeLibrary(bKernelDll);
   return;
}
#pragma ENDDUMP
//------------------------------------------------------------------------
// Fin Function US_GetProcessesW9X()
//========================================================================

//========================================================================
// Function US_KillProcess(nPid)         Termina un proceso
// Recibe como parámetro el numero de Proceso
// Retorna 0 (success) o -1 (failed)
//------------------------------------------------------------------------
#pragma BEGINDUMP
#include <windows.h>
#include <stdio.h>
#include <stdio.h>
#include "psapi.h"
#include "hbapi.h"

#pragma hdrstop

void getDebugPriv( void )
{
        HANDLE hToken;
        LUID sedebugnameValue;
        TOKEN_PRIVILEGES tkp;

        if ( ! OpenProcessToken( GetCurrentProcess(),
                TOKEN_ADJUST_PRIVILEGES | TOKEN_QUERY, &hToken ) )
                return;

        if ( !LookupPrivilegeValue( NULL, SE_DEBUG_NAME, &sedebugnameValue ) )
        {
                CloseHandle( hToken );
                return;
        }

        tkp.PrivilegeCount = 1;
        tkp.Privileges[0].Luid = sedebugnameValue;
        tkp.Privileges[0].Attributes = SE_PRIVILEGE_ENABLED;

        AdjustTokenPrivileges( hToken, FALSE, &tkp, sizeof tkp, NULL, NULL );

        CloseHandle( hToken );
}

#define isBadHandle(h) ( (h) == NULL || (h) == INVALID_HANDLE_VALUE )
#define lenof(x) ( sizeof (x) / sizeof ((x)[0]) )

HB_FUNC(US_KILLPROCESS)
{
    //  char *p;
        HANDLE hProcess;
        static DWORD pid;
    //  static DWORD pid[MAXPID];

   //   pid = strtol( hb_parni(1), &p, 0 );
        pid = hb_parnl(1);

        // try to acquire SeDebugPrivilege
        getDebugPriv();

     // printf( "pid %lu: ", pid[i] );

        // open process
        hProcess = OpenProcess( PROCESS_TERMINATE, FALSE, pid );
        if ( isBadHandle( hProcess ) )
           hb_retni( GetLastError() );
        else
           {
           // kill process
           if ( ! TerminateProcess( hProcess, (DWORD) -1 ) )
              hb_retni( GetLastError() );
           else
              hb_retni( 0 );

           // close handle
           CloseHandle( hProcess );
           }
}
#pragma ENDDUMP
//------------------------------------------------------------------------
// Fin Function US_KillProcess(nPid)
//========================================================================

//========================================================================
// Function US_SetPriorityToProcess( nPId , nPriority )     Cambiar prioridad a un proceso
// Recibe como parámetro el numero de Proceso y la nueva prioridad
// Retorna 0 (success) o -1 (failed) y -2 (failed)
//------------------------------------------------------------------------

#define ABOVE_NORMAL_PRIORITY_CLASS    0x00008000
#define BELOW_NORMAL_PRIORITY_CLASS    0x00004000
#define HIGH_PRIORITY_CLASS            0x00000080
#define IDLE_PRIORITY_CLASS            0x00000040
#define NORMAL_PRIORITY_CLASS          0x00000020
#define REALTIME_PRIORITY_CLASS        0x00000100

Function US_SetPriorityToProcess( nPId , nPriority )
   local nReto := 0
   do case
      case nPriority == 1
         nReto := US_2SetPriorityToProcess( nPId , ABOVE_NORMAL_PRIORITY_CLASS )
      case nPriority == 2
         nReto := US_2SetPriorityToProcess( nPId , BELOW_NORMAL_PRIORITY_CLASS )
      case nPriority == 3
         nReto := US_2SetPriorityToProcess( nPId , HIGH_PRIORITY_CLASS )
      case nPriority == 4
         nReto := US_2SetPriorityToProcess( nPId , IDLE_PRIORITY_CLASS )
      case nPriority == 5
         nReto := US_2SetPriorityToProcess( nPId , NORMAL_PRIORITY_CLASS )
      case nPriority == 6
         nReto := US_2SetPriorityToProcess( nPId , REALTIME_PRIORITY_CLASS )
      OTHERWISE
         msgstop( "Invalid Priority Class: " + alltrim( str( nPriority ) ) + " in function " + Procname() )
         nReto := -3
   endcase
Return nReto

#pragma BEGINDUMP
#include <windows.h>
#include <stdio.h>
#include <stdio.h>
#include "psapi.h"
#include "hbapi.h"

HB_FUNC(US_2SETPRIORITYTOPROCESS)
   {
   // Get a handle to the process.
   HANDLE hProcess = OpenProcess( PROCESS_SET_INFORMATION , FALSE , hb_parnl(1) );
   if (!hProcess)
      {
      hb_retni( -2 );
      }
   else
      {
      if( !SetPriorityClass( hProcess , hb_parnl(2) ) )
         {
         hb_retni( -1 );
         }
      else
         {
         hb_retni( 0 );
         }
      }
   return;
   }
#pragma ENDDUMP
//------------------------------------------------------------------------
// Fin Function US_SetPriorityToProcess( nPId , nPriority )
//========================================================================

/* eof */
