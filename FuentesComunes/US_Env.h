/*
 * $Id$
 */

/*
 *    QPM - QAC based Project Manager
 *
 *    Copyright 2011-2020 Fernando Yurisich <fernando.yurisich@gmail.com>
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
 *    along with this program.  If not, see <https://www.gnu.org/licenses/>.
*/

#ifndef DEF_SLASH
   #undef DEF_SLASH
   #define DEF_SLASH "\"
#endif

#ifndef __US_ENV
   #define __US_ENV

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
         // Object Oriented Harbour Gui con MinGW
         #define __O1MINGW32__
      #else
         // Object Oriented Harbour Gui con Borland
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
   ERROR EN DETECCION DE MINIGUI, SE DETECTÓ MÁS DE UNA MINIGUI !!!!
   #endif

   #ifdef __OOHG__
   #translate USMODAL => MODALSIZE
   #else
   #translate USMODAL => MODAL
   #endif

#endif

/* eof */
