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

/*    Adapted from oohg.h
 *    Copyright (C) OOHG Developers Team
 */


#define HWNDparam( n )        ( ( HWND ) HB_PARNL( n ) )
#define HWNDparam2( n, x )    ( ( HWND ) HB_PARNL2( n, x ) )
#define HWNDret( hWnd )       ( HB_RETNL( ( LONG_PTR ) hWnd ) )
#define HWNDpush( hWnd )      ( hb_vmPushNumInt( ( LONG_PTR ) hWnd ) )
#define HMENUparam( n )       ( ( HMENU ) HB_PARNL( n ) )
#define HMENUret( hMenu )     ( HB_RETNL( ( LONG_PTR ) hMenu ) )

/* Use this macros instead of Harbour/xHarbour specific functions */

#ifdef _WIN64
   /* For 64 bits WIN */

   #define HB_ARRAYGETNL( n, x )     hb_arrayGetNLL( n, x )
   #define HB_ARRAYSETNL( n, x, y )  hb_arraySetNLL( n, x, y )
   #define HB_RETNL( n )             hb_retnll( n )

   #ifdef __XHARBOUR__
      /* For XHARBOUR and 64 bits WIN */

      #define HB_PARC( n, x )           hb_parc( n, x )
      #define HB_PARCLEN( n, x )        hb_parclen( n, x )
      #define HB_PARND( n, x )          hb_parnd( n, x )
      #define HB_PARNI( n, x )          hb_parni( n, x )
      #define HB_PARNL( n )             hb_parnll( n )
      #define HB_PARNL2( n, x )         hb_parnll( n, x )
      #define HB_PARNL3( n, x, y )      hb_parnll( n, x, y )
      #define HB_PARPTR( n )            hb_parptr( n )
      #define HB_PARPTR2( n, x )        hb_parptr( n, x )
      #define HB_PARVNL( n, x )         hb_parnll( n, x )
      #define HB_STORC( n, x, y )       hb_storc( n, x, y )
      #define HB_STORDL( n, x, y )      hb_stordl( n, x, y )
      #define HB_STORL( n, x, y )       hb_storl( n, x, y )
      #define HB_STORND( n, x, y )      hb_stornd( n, x, y )
      #define HB_STORNI( n, x, y )      hb_storni( n, x, y )
      #define HB_STORNL2( n, x )        hb_stornll( n, x )
      #define HB_STORNL3( n, x, y )     hb_stornll( n, x, y )
      #define HB_STORPTR( n, x, y )     hb_storptr( n, x, y )
      #define HB_STORVNL( n, x, y )     hb_stornll( n, x, y )
      #define HB_STORVNLL( n, x, y )    hb_stornll( n, x, y )

   #else /*  __XHARBOUR__ */
      /* For HARBOUR and 64 bits WIN */

      #define HB_PARC( n, x )           hb_parvc( n, x )
      #define HB_PARCLEN( n, x )        hb_parvclen( n, x )
      #define HB_PARND( n, x )          hb_parvnd( n, x )
      #define HB_PARNI( n, x )          hb_parvni( n, x )
      #define HB_PARNL( n )             hb_parvnll( n )
      #define HB_PARNL2( n, x )         hb_parvnll( n, x )
      #define HB_PARNL3( n, x, y )      hb_parvnll( n, x, y )
      #define HB_PARPTR( n )            hb_parptr( n )
      #define HB_PARPTR2( n, x )        hb_parvptr( n, x )
      #define HB_PARVNL( n, x )         hb_parvnll( n, x )
      #define HB_STORC( n, x, y )       hb_storvc( n, x, y )
      #define HB_STORDL( n, x, y )      hb_storvdl( n, x, y )
      #define HB_STORL( n, x, y )       hb_storvl( n, x, y )
      #define HB_STORND( n, x, y )      hb_storvnd( n, x, y )
      #define HB_STORNI( n, x, y )      hb_storvni( n, x, y )
      #define HB_STORNL2( n, x )        hb_stornll( n, x )
      #define HB_STORNL3( n, x, y )     hb_storvnll( n, x, y )
      #define HB_STORPTR( n, x, y )     hb_storvptr( n, x, y )
      #define HB_STORVNL( n, x, y )     hb_storvnll( n, x, y )
      #define HB_STORVNLL( n, x, y )    hb_storvnll( n, x, y )

   #endif /*  __XHARBOUR__ */

#else /*  _WIN64 */
   /* For 32 bits WIN */

   #define HB_ARRAYGETNL( n, x )     hb_arrayGetNL( n, x )
   #define HB_ARRAYSETNL( n, x, y )  hb_arraySetNL( n, x, y )
   #define HB_RETNL( n )             hb_retnl( n )

   #ifdef __XHARBOUR__
      /* For XHARBOUR and 32 bits WIN */

      #define HB_PARC( n, x )           hb_parc( n, x )
      #define HB_PARCLEN( n, x )        hb_parclen( n, x )
      #define HB_PARND( n, x )          hb_parnd( n, x )
      #define HB_PARNI( n, x )          hb_parni( n, x )
      #define HB_PARNL( n )             hb_parnl( n )
      #define HB_PARNL2( n, x )         hb_parnl( n, x )
      #define HB_PARNL3( n, x, y )      hb_parnl( n, x, y )
      #define HB_PARPTR( n )            hb_parptr( n )
      #define HB_PARPTR2( n, x )        hb_parptr( n, x )
      #define HB_PARVNL( n, x )         hb_parnl( n, x )
      #define HB_STORC( n, x, y )       hb_storc( n, x, y )
      #define HB_STORDL( n, x, y )      hb_stordl( n, x, y )
      #define HB_STORL( n, x, y )       hb_storl( n, x, y )
      #define HB_STORND( n, x, y )      hb_stornd( n, x, y )
      #define HB_STORNI( n, x, y )      hb_storni( n, x, y )
      #define HB_STORNL2( n, x )        hb_stornl( n, x )
      #define HB_STORNL3( n, x, y )     hb_stornl( n, x, y )
      #define HB_STORPTR( n, x, y )     hb_storptr( n, x, y )
      #define HB_STORVNL( n, x, y )     hb_stornl( n, x, y )
      #define HB_STORVNLL( n, x, y )    hb_stornll( n, x, y )

   #else /* __XHARBOUR__ */
      /* For HARBOUR and 32 bits WIN */

      #define HB_PARC( n, x )           hb_parvc( n, x )
      #define HB_PARCLEN( n, x )        hb_parvclen( n, x )
      #define HB_PARND( n, x )          hb_parvnd( n, x )
      #define HB_PARNI( n, x )          hb_parvni( n, x )
      #define HB_PARNL( n )             hb_parvnl( n )
      #define HB_PARNL2( n, x )         hb_parvnl( n, x )
      #define HB_PARNL3( n, x, y )      hb_parvnl( n, x, y )
      #define HB_PARPTR( n )            hb_parptr( n )
      #define HB_PARPTR2( n, x )        hb_parvptr( n, x )
      #define HB_PARVNL( n, x )         hb_parvnl( n, x )
      #define HB_STORC( n, x, y )       hb_storvc( n, x, y )
      #define HB_STORDL( n, x, y )      hb_storvdl( n, x, y )
      #define HB_STORL( n, x, y )       hb_storvl( n, x, y )
      #define HB_STORND( n, x, y )      hb_storvnd( n, x, y )
      #define HB_STORNI( n, x, y )      hb_storvni( n, x, y )
      #define HB_STORNL2( n, x )        hb_stornl( n, x )
      #define HB_STORNL3( n, x, y )     hb_storvnl( n, x, y )
      #define HB_STORPTR( n, x, y )     hb_storvptr( n, x, y )
      #define HB_STORVNL( n, x, y )     hb_storvnl( n, x, y )
      #define HB_STORVNLL( n, x, y )    hb_storvnll( n, x, y )

   #endif /*  __XHARBOUR__ */

#endif /* _WIN64 */
