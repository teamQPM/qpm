#ifndef DEF_SLASH
   #define DEF_SLASH "\"
   #ifdef HB_OS_WIN
      // defined(HB_OS_WIN_CE) || \
      // defined(HB_OS_WIN_32) || \
      // defined(HB_OS_WIN_64)
      #undef  DEF_SLASH
      #define DEF_SLASH "\"
   #endif
   #ifdef HB_OS_UNIX
      // defined(HB_OS_UNIX_COMPATIBLE) || \
      // defined(HB_OS_LINUX) || \
      // defined(HB_OS_DARWIN) || \
      // defined(HB_OS_BSD) || \
      // defined(HB_OS_SUNOS) || \
      // defined(HB_OS_HPUX)
      #undef  DEF_SLASH
      #define DEF_SLASH "/"
   #endif
   #ifdef HB_OS_OS2
      #undef  DEF_SLASH
      #define DEF_SLASH "\"
   #endif
#endif

#ifndef __US_ENV
   #define __US_ENV

   #include "hbclass.ch"
   #include "minigui.ch"

   #ifdef PRINTER_COLLATE_TRUE
      #define __US_MULTIPLE__
      #define __M3__
      #define __MINIGUI__
      #ifdef __MINGW32__
         // Oficial MiniGui 3x con MinGW
         #define __M3MINGW32__
      #else
         // Oficial MiniGui 3x con Borland
         #define __M3BORLAND__
      #endif
   #endif

   #ifdef __OOHG__
      #ifdef __US_MULTIPLE__
         #define __US_ERROR_MULTIPLE__
      #else
         #define __US_MULTIPLE__
      #endif
      #define __O3__
      #define __MINIGUI__
      #ifdef __MINGW32__
         // Object Oriented Harbour Gui 3.x con MinGW
         #define __O1MINGW32__
      #else
         // Object Oriented Harbour Gui 3.x con Borland
         #define __O1BORLAND__
      #endif
   #endif

   #ifdef __HMG__
      #ifdef __US_MULTIPLE__
         #define __US_ERROR_MULTIPLE__
      #else
         #define __US_MULTIPLE__
      #endif
      #define __E1__
      #define __MINIGUI__
      #ifdef __MINGW32__
         // Extended MiniGui 1.x con MinGW
         #define __E1MINGW32__
      #else
         // Extended MiniGui 1.x con MinGW
         #define __E1BORLAND__
      #endif
   #endif

   #ifdef __US_ERROR_MULTIPLE__
   ERROR EN DETECCION DE MINIGUI, SE DETECTARON MAS DE UNA MINIGUI !!!!
   #endif

   #include "US_K.ch"
   #include "US.ch"

   #ifdef __OOHG__
   #translate USMODAL => MODALSIZE
   #else
   #translate USMODAL => MODAL
   #endif

#endif
