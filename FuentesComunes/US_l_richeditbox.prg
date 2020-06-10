/*
 * $Id$
 */

/*
 *    QPM - QAC based Project Manager
 *
 *    Copyright 2011-2019 Fernando Yurisich <fernando.yurisich@gmail.com>
 *    https://qpm.sourceforge.io/
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

/*----------------------------------------------------------------------------*/
/* Copiado Tal Cual desde l_richedit.prg de Extended 1.2 build 24             */
/* Mas el agregado de los dos bloques #ifdef __MINGW32__ para compilar con    */
/* el MinGW que trae la Oficial MiniGui 2x (buscar xxMINGW32__                */
/*----------------------------------------------------------------------------*/
/*----------------------------------------------------------------------------
 MINIGUI - Harbour Win32 GUI library source code

 Copyright 2002 Roberto Lopez <roblez@ciudad.com.ar>
 http://www.geocities.com/harbour_minigui/

 This program is free software; you can redistribute it and/or modify it under
 the terms of the GNU General Public License as published by the Free Software
 Foundation; either version 2 of the License, or (at your option) any later
 version.

 This program is distributed in the hope that it will be useful, but WITHOUT
 ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

 You should have received a copy of the GNU General Public License along with
 this software; see the file COPYING. If not, write to the Free Software
 Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA (or
 visit the web site http://www.gnu.org/).

 As a special exception, you have permission for additional uses of the text
 contained in this release of Harbour Minigui.

 The exception is that, if you link the Harbour Minigui library with other
 files to produce an executable, this does not by itself cause the resulting
 executable to be covered by the GNU General Public License.
 Your use of that executable is in no way restricted on account of linking the
 Harbour-Minigui library code into it.

 Parts of this project are based upon:

        "Harbour GUI framework for Win32"
        Copyright 2001 Alexander S.Kresin <alex@belacy.belgorod.su>
        Copyright 2001 Antonio Linares <alinares@fivetech.com>
        www - http://www.harbour-project.org

        "Harbour Project"
        Copyright 1999-2003, http://www.harbour-project.org/
---------------------------------------------------------------------------*/

//#include "minigui.ch"
#include "common.ch"

#define DMORIENT_PORTRAIT   1
#define DMORIENT_LANDSCAPE  2
#define DMPAPER_A4                   9  /* A4 210 x 297 mm                    */

#define CFM_BOLD                0x00000001
#define CFM_ITALIC              0x00000002
#define CFM_UNDERLINE   0x00000004
#define CFM_STRIKEOUT   0x00000008
#define CFM_PROTECTED   0x00000010
#define CFM_LINK                0x00000020              /* Exchange hyperlink extension */
#define CFM_SIZE                0x80000000
#define CFM_COLOR               0x40000000
#define CFM_FACE                0x20000000
#define CFM_OFFSET              0x10000000
#define CFM_CHARSET             0x08000000

*-----------------------------------------------------------------------------*
Function _SetFontNameRTF (ParentForm, ControlName, Value, lAllText)
*-----------------------------------------------------------------------------*
Local Sel, H, an, s, ab, ai, ac, au, as, aFont, ret, mask

    DEFAULT lAllText TO .f.

    H := GetControlHandle( ControlName, ParentForm )
    if  !lAllText
        Sel := RangeSelRTF(H)
    else
        Sel := -1
    endif

    mask := CFM_FACE
    aFont := GetFontRTF(H, 1)

    an := Value
    s  := aFont [2]
    ab := aFont [3]
    ai := aFont [4]
    ac := aFont [5]
    au := aFont [6]
    as := aFont [7]

    ret := SetFontRTF(H, Sel, an, s, ab, ai, ac, au, as, mask)

Return ret


*-----------------------------------------------------------------------------*
Function _SetFontSizeRTF( ParentForm, ControlName, Value, lAllText )
*-----------------------------------------------------------------------------*
Local Sel, H, an, s, ab, ai, au, ac, as, aFont, ret, mask

    DEFAULT lAllText TO .f.

    H := GetControlHandle( ControlName, ParentForm )
    if  !lAllText
        Sel := RangeSelRTF(H)
    else
        Sel := -1
    endif

    mask := CFM_SIZE
    aFont := GetFontRTF(H, 0)

    an := aFont [1]
    s  := Value
    ab := aFont [3]
    ai := aFont [4]
    ac := aFont [5]
    au := aFont [6]
    as := aFont [7]

    ret := SetFontRTF(H, Sel, an, s, ab, ai, ac, au, as, mask)

Return ret


*-----------------------------------------------------------------------------*
Function _SetFontBoldRTF( ParentForm, ControlName, Value, lAllText )
*-----------------------------------------------------------------------------*
Local Sel, H, an, s, ab, ai, au, ac, as, aFont, ret, mask

    DEFAULT lAllText TO .f.

    H := GetControlHandle( ControlName, ParentForm )
    if  !lAllText
        Sel := RangeSelRTF(H)
    else
        Sel := -1
    endif

    mask := CFM_BOLD
    aFont := GetFontRTF(H, 1)

    an := aFont [1]
    s  := aFont [2]
    ab := Value
    ai := aFont [4]
    ac := aFont [5]
    au := aFont [6]
    as := aFont [7]

    ret := SetFontRTF(H, Sel, an, s, ab, ai, ac, au, as, mask)

Return Ret


*-----------------------------------------------------------------------------*
Function _SetFontItalicRTF( ParentForm, ControlName, Value, lAllText )
*-----------------------------------------------------------------------------*
Local Sel, H, an, s, ab, ai, au, ac, as, aFont, ret, mask

    DEFAULT lAllText TO .f.

    H := GetControlHandle( ControlName, ParentForm )
    if  !lAllText
        Sel := RangeSelRTF(H)
    else
        Sel := -1
    endif

    mask := CFM_ITALIC
    aFont := GetFontRTF(H, 1)

    an := aFont [1]
    s  := aFont [2]
    ab := aFont [3]
    ai := Value
    ac := aFont [5]
    au := aFont [6]
    as := aFont [7]

    ret := SetFontRTF(H, Sel, an, s, ab, ai, ac, au, as, mask)

Return Ret


*-----------------------------------------------------------------------------*
Function _SetFontUnderlineRTF( ParentForm, ControlName, Value, lAllText )
*-----------------------------------------------------------------------------*
Local Sel, H, an, s, ab, ai, au, ac, as, aFont, ret, mask

    DEFAULT lAllText TO .f.

    H := GetControlHandle( ControlName, ParentForm )
    if  !lAllText
        Sel := RangeSelRTF(H)
    else
        Sel := -1
    endif

    mask := CFM_UNDERLINE
    aFont := GetFontRTF(H, 1)

    an := aFont [1]
    s  := aFont [2]
    ab := aFont [3]
    ai := aFont [4]
    ac := aFont [5]
    au := Value
    as := aFont [7]

    ret := SetFontRTF(H, Sel, an, s, ab, ai, ac, au, as, mask)

Return Ret


*-----------------------------------------------------------------------------*
Function _SetFontStrikeOutRTF( ParentForm, ControlName, Value, lAllText )
*-----------------------------------------------------------------------------*
Local Sel, H, an, s, ab, ai, au, ac, as, aFont, ret, mask

    DEFAULT lAllText TO .f.

    H := GetControlHandle( ControlName, ParentForm )
    if  !lAllText
        Sel := RangeSelRTF(H)
    else
        Sel := -1
    endif

    mask := CFM_STRIKEOUT
    aFont := GetFontRTF(H, 1)

    an := aFont [1]
    s  := aFont [2]
    ab := aFont [3]
    ai := aFont [4]
    ac := aFont [5]
    au := aFont [6]
    as := Value

    ret := SetFontRTF(H, Sel, an, s, ab, ai, ac, au, as, mask)

Return Ret


*-----------------------------------------------------------------------------*
Function _SetFormatLeftRTF( ParentForm, ControlName, Value )
*-----------------------------------------------------------------------------*
    LOCAL aParForm, H, al, ac, ar, at, an, ret

    H := GetControlHandle( ControlName, ParentForm )

    aParForm := GetParForm(H)

    al := Value
    ac := .f.
    ar := .f.
    at := aParForm [4]
    an := aParForm [5]

    ret := SetParForm(H, al, ac, ar, at, an)

Return ret


*-----------------------------------------------------------------------------*
Function _SetFormatCenterRTF( ParentForm, ControlName, Value )
*-----------------------------------------------------------------------------*
    LOCAL aParForm, H, al, ac, ar, at, an, ret

    H := GetControlHandle( ControlName, ParentForm )

    aParForm := GetParForm(H)

    al := .f.
    ac := Value
    ar := .f.
    at := aParForm [4]
    an := aParForm [5]

    ret := SetParForm(H, al, ac, ar, at, an)

Return ret


*-----------------------------------------------------------------------------*
Function _SetFormatRightRTF( ParentForm, ControlName, Value )
*-----------------------------------------------------------------------------*
    LOCAL aParForm, H, al, ac, ar, at, an, ret

    H := GetControlHandle( ControlName, ParentForm )

    aParForm := GetParForm(H)

    al := .f.
    ac := .f.
    ar := Value
    at := aParForm [4]
    an := aParForm [5]

    ret := SetParForm(H, al, ac, ar, at, an)

Return ret


*-----------------------------------------------------------------------------*
Function _SetFormatTabRTF( ParentForm, ControlName, Value )
*-----------------------------------------------------------------------------*
    LOCAL aParForm, H, al, ac, ar, at, an, ret

    H := GetControlHandle( ControlName, ParentForm )

    aParForm := GetParForm(H)

    al := aParForm [1]
    ac := aParForm [2]
    ar := aParForm [3]
    at := Value
    an := aParForm [5]

    ret := SetParForm(H, al, ac, ar, at, an)

Return Ret


*-----------------------------------------------------------------------------*
Function RangeSelRTF(ControlHandle)
*-----------------------------------------------------------------------------*
    Local aRange

    aRange := GetSelRange(ControlHandle)

Return (aRange[2] - aRange[1])

*=============================================================



#pragma BEGINDUMP

#define _WIN32_IE      0x0500

#include <shlobj.h>
#include <windows.h>
#include <commctrl.h>
#include <richedit.h>
#include "hbapi.h"
#include "winreg.h"
#include "tchar.h"
#include "winuser.h"
#include <wingdi.h>
#include "qpm.h"

HB_FUNC( SETOPTIONS )                             // SetOptions( HWND hwndCtrl, nOption )
{
/*
    int nOption ;

    if( hb_parl( 2 ) )
                nOption = ECO_AUTOVSCROLL ;
    nOption = ECO_AUTOVSCROLL ;
*/
   SendMessage( (HWND) HB_PARNL( 1 ), (UINT) EM_SETOPTIONS, (WPARAM) ECOOP_SET, (LPARAM) HB_PARNL( 2 ) );
}

HB_FUNC( GETSELRANGE)                             // GetSelRange( HWND hwndCtrl )
{
   CHARRANGE cRange;

   SendMessage( (HWND) HB_PARNL( 1 ), (UINT) EM_EXGETSEL, 0, (LPARAM) &cRange );

   hb_reta( 2 );
   HB_STORNL3( cRange.cpMin, -1, 1 );
   HB_STORNL3( cRange.cpMax, -1, 2 );
}

HB_FUNC( SETSELRANGE )                            // SetSelRange( HWND hwndCtrl, LONG nMin, LONG nMax )
{
   CHARRANGE cRange;
   cRange.cpMin = 0;
   cRange.cpMax = 0;

   if( hb_parnl( 2 ) )
      cRange.cpMin = hb_parnl( 2 );
   if( hb_parnl( 3 ) )
      cRange.cpMax = hb_parnl( 3 );

   SendMessage( (HWND) HB_PARNL( 1 ), (UINT) EM_EXSETSEL, 0, (LPARAM) &cRange );
}

HB_FUNC( SELECTIONTYPE )                          // SelectionType( HWND hwndCtrl )
{
   LRESULT lResult;
   int nMode = 0;

   lResult = SendMessage( (HWND) HB_PARNL( 1 ), (UINT) EM_SELECTIONTYPE, 0, 0 );

   switch( lResult )
   {
      case SEL_EMPTY:
         nMode = 1;
         break;
      case SEL_TEXT:
         nMode = 2;
         break;
      case SEL_OBJECT:
         nMode = 3;
         break;
      case SEL_MULTICHAR:
         nMode = 4;
         break;
      case SEL_MULTIOBJECT:
         nMode = 5;
         break;
   }

/*
If the selection is empty, the return value is SEL_EMPTY.
If the selection is not empty, the return value is a set of flags containing one or more of the following values.
SEL_TEXT        Text.
SEL_OBJECT      At least one Component Object Model(COM) object.
SEL_MULTICHAR   More than one character of text.
SEL_MULTIOBJECT More than one COM object.
*/

   hb_retni( nMode );
}

HB_FUNC( GETRECT )                                // GetRect( HWND hwndCtrl )
{
   RECT rc;

   SendMessage( (HWND) HB_PARNL( 1 ), (UINT) EM_GETRECT, 0, (LPARAM) &rc );

   hb_reta( 4 );
   HB_STORNL3( rc.left,   -1, 1 );
   HB_STORNL3( rc.top,    -1, 2 );
   HB_STORNL3( rc.right,  -1, 3 );
   HB_STORNL3( rc.bottom, -1, 4 );
}

HB_FUNC( SETRECT )                                // SetRect( HWND hwndCtrl, int left, int.top, int right, int bottom )
{
   RECT rc;

   rc.left   = hb_parni( 2 );
   rc.top    = hb_parni( 3 );
   rc.right  = hb_parni( 4 );
   rc.bottom = hb_parni( 5 );

   SendMessage( (HWND) HB_PARNL( 1 ), (UINT) EM_SETRECT, (WPARAM) 1, (LPARAM) &rc );
}

HB_FUNC( AUTOURLDETECT )                          // AutoUrlDetect( HWND hwndCtrl, BOOL lLink )
{
   SendMessage( (HWND) HB_PARNL( 1 ), (UINT) EM_AUTOURLDETECT, (WPARAM) hb_parl( 2 ), 0);
}

HB_FUNC( COPYRTF )                                // CopyRTF( HWND hwndCtrl )
{
   SendMessage( (HWND) HB_PARNL( 1 ), (UINT) WM_COPY, 0, 0);
}

HB_FUNC( PASTERTF )                               // PasteRTF( HWND hwndCtrl )
{
   SendMessage( (HWND) HB_PARNL( 1 ), (UINT) WM_PASTE, 0, 0);
}

HB_FUNC( CUTRTF )                                 // CutRTF( HWND hwndCtrl )
{
   SendMessage( (HWND) HB_PARNL( 1 ), (UINT) WM_CUT, 0, 0);
}

HB_FUNC( CLEARRTF )                               // ClearRTF( HWND hwndCtrl )
{
   SendMessage( (HWND) HB_PARNL( 1 ), (UINT) WM_CLEAR, 0, 0);
}

HB_FUNC( UNDORTF )                                 // UndoRTF( HWND hwndCtrl )
{
   SendMessage( (HWND) HB_PARNL( 1 ), (UINT) EM_UNDO, 0, 0);
}

HB_FUNC( REDORTF )                                // RedoRTF( HWND hwndCtrl )
{
   SendMessage( (HWND) HB_PARNL( 1 ), (UINT) EM_REDO, 0, 0);
}

HB_FUNC( CANUNDO )                                // CanUndo( HWND hwndCtrl )
{
   LRESULT lResult;

   lResult = SendMessage( (HWND) HB_PARNL( 1 ), (UINT) EM_CANUNDO, 0, 0);

   if( lResult )
   {
      hb_retl( TRUE );
   }
   else
   {
      hb_retl( FALSE );
   }
}

HB_FUNC( CANREDO )                                // CanRedo( HWND hwndCtrl )
{
   LRESULT lResult;

   lResult = SendMessage( (HWND) HB_PARNL( 1 ), (UINT) EM_CANREDO, 0, 0);

   if( lResult )
   {
       hb_retl( TRUE );
   }
   else
   {
       hb_retl( FALSE );
   }
}

HB_FUNC( CANPASTE )                               // CanPaste( HWND hwndCtrl )
{
   LRESULT lResult;

   lResult = SendMessage( (HWND) HB_PARNL( 1 ), (UINT) EM_CANPASTE, 0, 0);

   if( lResult )
   {
       hb_retl( TRUE );
   }
   else
   {
       hb_retl( FALSE );
   }
}

HB_FUNC( FINDCHR )                                // FindChr( HWND hwnd, LPCTSTR lpszText, int Direction, int wholeword, int mcase, int seltxt )
{
   LRESULT lResult;
   FINDTEXTEX Findtxt;
   CHARRANGE cRng1;
   CHARRANGE cRng2;
   int Style = 0;

   if( hb_parl( 3 ) )
   {
      Style = Style | FR_DOWN  ;                  // search forward
   }
   if( hb_parl( 4 ) )
   {
      Style = Style | FR_WHOLEWORD ;
   }
   if( hb_parl( 5 ) )
   {
      Style = Style | FR_MATCHCASE ;
   }

   SendMessage( (HWND) HB_PARNL( 1 ), (UINT) EM_EXGETSEL, 0, (LPARAM) &cRng1 );

   if( hb_parl( 3 ) )                             // forward
   {
      cRng1.cpMin = cRng1.cpMax;
      cRng1.cpMax = -1;
   }
   else                                           // backward
   {
      cRng1.cpMin = cRng1.cpMin;
      cRng1.cpMax = 0;
   }

   cRng2.cpMin = 0;
   cRng2.cpMax = 0;

   Findtxt.chrg      = (CHARRANGE) cRng1;
   Findtxt.lpstrText = (LPCTSTR) hb_mbtowc( hb_parc( 2 ) );
   Findtxt.chrgText  = (CHARRANGE) cRng2;

   lResult = SendMessage( (HWND) HB_PARNL( 1 ), (UINT) EM_FINDTEXTEX, (WPARAM) Style, (LPARAM) &Findtxt );

   if( lResult > 0 )
   {
      if( ! hb_parl( 6 ) )
      {
         Findtxt.chrgText.cpMin = Findtxt.chrgText.cpMax;
      }

      SendMessage( (HWND) HB_PARNL( 1 ), (UINT) EM_EXSETSEL, 0, (LPARAM) &Findtxt.chrgText );
   }

   hb_reta( 3 );
   HB_STORNL3( Findtxt.chrgText.cpMin, -1, 1 );
   HB_STORNL3( Findtxt.chrgText.cpMax, -1, 2 );
   HB_STORNL3( lResult, -1, 3 );
}

HB_FUNC( GETPARFORM )                             // GetParForm( HWND hwnd )
{
   PARAFORMAT2 parForm;
   int left, center, right, nNumb;

   parForm.cbSize= sizeof( PARAFORMAT2 );
   parForm.dwMask = PFM_ALIGNMENT | PFM_TABSTOPS | PFM_NUMBERING | PFM_OFFSET | PFM_OFFSETINDENT | PFM_RIGHTINDENT;

   SendMessage( (HWND) HB_PARNL( 1 ), (UINT) EM_GETPARAFORMAT, 0, (LPARAM) &parForm);

   left   = ( parForm.wAlignment  == PFA_LEFT )   ? TRUE : FALSE ;
   center = ( parForm.wAlignment  == PFA_CENTER ) ? TRUE : FALSE ;
   right  = ( parForm.wAlignment  == PFA_RIGHT )  ? TRUE : FALSE ;
   nNumb  = ( parForm.wNumbering  == PFN_BULLET ) ? TRUE : FALSE ;

   hb_reta( 8 );
   HB_STORL( left, -1, 1 );
   HB_STORL( center, -1, 2 );
   HB_STORL( right, -1, 3 );
   HB_STORNI( parForm.cTabCount, -1, 4 );
   HB_STORL( nNumb, -1, 5 );
   HB_STORNL3( parForm.dxStartIndent, -1, 6 );
   HB_STORNL3( parForm.dxRightIndent, -1, 7 );
   HB_STORNL3( parForm.dxOffset, -1, 8 );
}

HB_FUNC( SETPARFORM )                             // SetParForm( HWND hwnd, BOOL left, BOOL Center, BOOL Right, int Tab, int Number, int StartIndent, int RightIndent, int Offset)
{
   LRESULT lResult;
   PARAFORMAT2 parForm;
   DWORD Mask = 0;
   WORD wAlign = 0;
   WORD nNumb = 0;
   LONG nOffset, nRightId, nStartId;
   int nTab;

   if( hb_parl( 2 ) )
   {
      Mask = Mask | PFM_ALIGNMENT ;
      wAlign = PFA_LEFT ;
   }
   if( hb_parl( 3 ) )
   {
      Mask = Mask | PFM_ALIGNMENT ;
      wAlign = PFA_CENTER ;
   }
   if( hb_parl( 4 ) )
   {
      Mask = Mask | PFM_ALIGNMENT ;
      wAlign = PFA_RIGHT ;
   }
   if( hb_parl( 6 ) )
   {
      nNumb = PFN_BULLET ;
   }

   Mask = Mask | PFM_TABSTOPS | PFM_NUMBERING | PFM_OFFSETINDENT | PFM_RIGHTINDENT | PFM_OFFSET;
   nTab     = hb_parni( 5 );
   nStartId = hb_parnl( 7 );
   nRightId = hb_parnl( 8 );
   nOffset  = hb_parnl( 9 );

   parForm.cbSize = sizeof( PARAFORMAT2 );
   parForm.dwMask = Mask ;

   SendMessage( (HWND) HB_PARNL( 1 ), EM_GETPARAFORMAT, 0, (LPARAM) &parForm );

   parForm.dwMask     = Mask ;
   parForm.wAlignment = wAlign ;

   parForm.cTabCount  = nTab ;
   parForm.wNumbering = nNumb;
   parForm.dxStartIndent = nStartId - parForm.dxStartIndent;
   parForm.dxRightIndent = nRightId;
   parForm.dxOffset   = nOffset;

   lResult = SendMessage( (HWND) HB_PARNL( 1 ), EM_SETPARAFORMAT, 0, (LPARAM) &parForm );

   if( lResult )
   {
      hb_retl( TRUE );
   }
   else
   {
      hb_retl( FALSE );
   }
}

HB_FUNC( LINEPOS )                                // LinePos( HWND hwndCtrl )
{
   CHARRANGE cRange;
   LRESULT nLine, nIndex;

   SendMessage( (HWND) HB_PARNL( 1 ), (UINT) EM_EXGETSEL, 0, (LPARAM) &cRange );
   nLine  = SendMessage( (HWND) HB_PARNL( 1 ), (UINT) EM_LINEFROMCHAR, (WPARAM) cRange.cpMax, 0);
   nIndex = SendMessage( (HWND) HB_PARNL( 1 ), (UINT) EM_LINEINDEX, (WPARAM) nLine, 0);

   hb_reta( 2 );
   HB_STORNL3( nLine, -1, 1 );
   HB_STORNL3( (cRange.cpMax - nIndex), -1, 2 );
}

HB_FUNC( GETLINECOUNT )                           // GetLineCount( HWND hwndCtrl )
{
   hb_retnl( SendMessage( (HWND) HB_PARNL( 1 ), (UINT) EM_GETLINECOUNT, 0, 0) );
}

HB_FUNC( GETLINE )                                // GetLine( HWND hwnd, nLine )
{
   LRESULT lResult;
   WORD LenBuff ;
   LPCTSTR strBuffer[1024];
   LenBuff = sizeof(strBuffer);

   *( LPWORD ) strBuffer = LenBuff;

   lResult = SendMessage( (HWND) HB_PARNL( 1 ), (UINT)  EM_GETLINE, (WPARAM) hb_parnl( 2 ), (LPARAM) &strBuffer );

   if( lResult )
      hb_retc( (char*) strBuffer );
   else
      hb_retc( "" );
}

HB_FUNC( GETLINEINDEX )                           // GetLineIndex( HWND hwnd, nLine)
{
   hb_retnl( SendMessage( (HWND) HB_PARNL( 1 ), (UINT) EM_LINEINDEX, (WPARAM) hb_parnl( 2 ), 0) );
}

HB_FUNC( SETSEL )                                 // SetSel( HWND hwnd, int nFrom, int nTo ) xxx
{
   SendMessage( (HWND) HB_PARNL( 1 ), (UINT) EM_SETSEL, (WPARAM) hb_parnl( 2 ), (LPARAM) hb_parnl( 3 ));
}

HB_FUNC( HIDESELECTION )                          // HideSelection( HWND hwnd, int nFrom, int nTo ) xxx
{
   SendMessage( (HWND) HB_PARNL( 1 ), (UINT)  EM_HIDESELECTION, (WPARAM) hb_parnl( 2 ), 0);
}

HB_FUNC( MODIFYRTF )                              // ModifyRTF( HWND hwnd )
{
   LRESULT lResult ;

   if( hb_parni( 2 ) )
      SendMessage( (HWND) HB_PARNL( 1 ), (UINT) EM_SETMODIFY, (WPARAM) FALSE, 0);

   lResult = SendMessage( (HWND) HB_PARNL( 1 ), (UINT) EM_GETMODIFY, 0, 0);

   if( lResult )
   {
      hb_retl( TRUE );
   }
   else
   {
      hb_retl( FALSE );
   }
}

HB_FUNC( SELECTALL )                              // SelectAll( HWND hwnd )
{
   CHARRANGE cRange;
   cRange.cpMin = hb_parnl( 2 );
   cRange.cpMax = hb_parnl( 3 );

   SendMessage( (HWND) HB_PARNL( 1 ), (UINT) EM_EXSETSEL, 0, (LPARAM) &cRange );
}

HB_FUNC( GETSELTEXT )                             // GetSelText( HWND hwnd, nSel )
{
   char strBuffer[1024];

   SendMessage( (HWND) HB_PARNL( 1 ), (UINT)  EM_GETSELTEXT, 0, (LPARAM) &strBuffer );

   hb_retc( strBuffer );
}

//
// Sample WordBreakProc
//
// This routine uses "." as delimiters instead of spaces.
//
/*
int CALLBACK EditWordBreakProcX(LPSTR lpszEditText, int ichCurrent,
int cchEditText, int wActionCode)
{
char FAR *lpCurrentChar;
int  nIndex;

switch(wActionCode) {

case WB_LEFT:
// Look for the beginning of a word to the left
// of the current position.
for( lpCurrentChar = lpszEditText+ichCurrent,
      nIndex = ichCurrent; nIndex >= 0; nIndex--,
      lpCurrentChar = AnsiPrev(lpszEditText,
      lpCurrentChar) )
    if( *lpCurrentChar == '.' ) {
       return ++nIndex;
    }
return 0;
break;

case WB_RIGHT:
// Look for the beginning of a word to the right
// of the current position.
  for( lpCurrentChar = lpszEditText+ichCurrent,
        nIndex = ichCurrent; nIndex < cchEditText;
        nIndex++,
        lpCurrentChar = AnsiNext(lpCurrentChar) )
    if( *lpCurrentChar == '.' ) {
       lpCurrentChar = AnsiNext(lpCurrentChar);
       nIndex++;
       while( *lpCurrentChar == '.' ) {
           lpCurrentChar = AnsiNext(lpCurrentChar);
           nIndex++;
       }
       return nIndex;
    }
return cchEditText;
break;

case WB_ISDELIMITER:
// Is the character at the current position a delimiter?
if( lpszEditText[ichCurrent] == '.' )
   return TRUE;
else
   return FALSE;

break;
}
}
*/

HB_FUNC( PRINTRTF )                               // PrintRTF( HWND hwnd, LONG hDC, int maxrow, int maxcol, BOOL lPrn )
{
   LRESULT lResult ;
   FORMATRANGE formrange;
   CHARRANGE cprng;
   RECT rc1;
   RECT rcP;

   cprng.cpMin = hb_parni( 5 );
   cprng.cpMax = hb_parni( 6 );
   rc1.left = 10 * 20;
   rc1.top  = 10 * 20;
   rc1.right = hb_parni( 3 );
   rc1.bottom = hb_parni( 4 );
   rcP = rc1;

   formrange.hdc = (HDC) HB_PARNL( 2 );
   formrange.hdcTarget = (HDC) HB_PARNL( 2 );
   formrange.rc = rc1;
   formrange.rcPage = rcP;
   formrange.chrg = cprng;

   lResult = SendMessage( (HWND) HB_PARNL( 1 ), (UINT) EM_FORMATRANGE, 0, (LPARAM) &formrange );
   if( hb_parl( 7 ) )
      SendMessage( (HWND) HB_PARNL( 1 ), (UINT) EM_DISPLAYBAND, 0, (LPARAM) &rcP );

   SendMessage( (HWND) HB_PARNL( 1 ), (UINT) EM_FORMATRANGE, 0, 0 );

   hb_retnl( lResult );
}

HB_FUNC( GETLENTEXT )
{
   LRESULT lResult ;
   GETTEXTLENGTHEX gtl;

   gtl.flags = GTL_PRECISE ;
   gtl.codepage = CP_ACP;

   lResult = SendMessage( (HWND) HB_PARNL( 1 ), (UINT) EM_GETTEXTLENGTHEX, (WPARAM) &gtl, 0 );
   hb_retnl( lResult );
}

HB_FUNC( GETTEXT )                // GetText( HWND hwnd )
{
   LRESULT lResult ;
   GETTEXTEX gtxt;
   SETTEXTEX stxt;
   LPCTSTR strBuffer[4096];

   gtxt.cb            = 50;
   gtxt.flags         = ST_SELECTION  ;
   gtxt.codepage      = CP_ACP;
   gtxt.lpDefaultChar = 0;
   gtxt.lpUsedDefChar = 0;

   SendMessage( (HWND) HB_PARNL( 1 ), (UINT) EM_GETTEXTEX, (WPARAM) &gtxt, (LPARAM) &strBuffer );

   stxt.flags = ST_KEEPUNDO | ST_SELECTION;
   stxt.codepage = CP_ACP;

   lResult = SendMessage( (HWND) HB_PARNL( 1 ), (UINT) EM_SETTEXTEX, (WPARAM) &stxt, (LPARAM) (LPCTSTR) &strBuffer );
   hb_retnl( lResult );
}

HB_FUNC( REPLACESEL )                             // GetText( HWND hwnd, LPCTSTR lpszText )
{
   hb_retnl( SendMessage( (HWND) HB_PARNL( 1 ), (UINT) EM_REPLACESEL, (WPARAM) TRUE, (LPARAM) hb_parc( 2 ) ) );
}

HB_FUNC( GETUNDONAME )                            // GetUndoName( HWND hwnd )
{
   hb_retnl( SendMessage( (HWND) HB_PARNL( 1 ), (UINT) EM_GETUNDONAME, 0, 0) );
}

HB_FUNC( STOPUNDOGROUP )                          // GetUndoName( HWND hwnd )
{
   hb_retnl( SendMessage( (HWND) HB_PARNL( 1 ), (UINT) EM_STOPGROUPTYPING, 0, 0 ) );
}

HB_FUNC( CLEARUNDOBUFFER )                        // ClearUndoBuffer( HWND hwnd )
{
   hb_retnl( SendMessage( (HWND) HB_PARNL( 1 ), (UINT) EM_EMPTYUNDOBUFFER, 0, 0 ) );
}

HB_FUNC( GETZOOM )                                // GetZoom( HWND hwnd )
{
   int numer;
   int denom;

   SendMessage( (HWND) HB_PARNL( 1 ), (UINT) EM_GETZOOM, (WPARAM) &numer, (LPARAM) &denom);

   hb_reta( 2 );
   HB_STORNI( numer, -1, 1 );
   HB_STORNI( denom, -1, 2 );
}

HB_FUNC( SETZOOM )                                // SetZoom( HWND hwnd, int numer, int denom )
{
   hb_retnl( SendMessage( (HWND) HB_PARNL( 1 ), (UINT) EM_SETZOOM, (WPARAM) hb_parni( 2 ), (LPARAM) hb_parni( 3 ) ) );
}

HB_FUNC( GETPARTABS )                             // GetParTabs( HWND hwnd )
{
   PARAFORMAT2 parForm;
   int n;

   parForm.cbSize = sizeof( PARAFORMAT2 );
   parForm.dwMask = PFM_TABSTOPS;

   SendMessage( (HWND) HB_PARNL( 1 ), (UINT) EM_GETPARAFORMAT, 0, (LPARAM) &parForm );

   hb_reta( parForm.cTabCount );
   for( n = 1; n <= parForm.cTabCount; n++ )
      HB_STORNI( parForm.rgxTabs[ n-1 ] / 20, -1, n );
}

HB_FUNC( SETPARTABS )                             // SetParTabs( HWND hwnd, aTabs )
{
   PARAFORMAT2 parForm;
   LRESULT lResult ;
   PHB_ITEM tArray;
   int n;
   int nArr;

   nArr = hb_parinfa( 2, 0 ) - 1 ;
   tArray = hb_param( 2, HB_IT_ARRAY );

   parForm.cbSize = sizeof(PARAFORMAT2);
   parForm.dwMask = PFM_TABSTOPS;
   parForm.cTabCount = nArr + 1;

   for( n = 0 ; n <= nArr ; n++ )
      parForm.rgxTabs[ n ]  = 20 * hb_arrayGetNI( tArray, n + 1 );

   lResult = SendMessage( (HWND) HB_PARNL( 1 ), (UINT) EM_SETPARAFORMAT, 0, (LPARAM) &parForm );
   if( lResult )
   {
      hb_retl( TRUE );
   }
   else
   {
      hb_retl( FALSE );
   }
}

HB_FUNC( GETPARSTARTID )                          // GetParStartId( HWND hwnd )
{
   PARAFORMAT2 parForm;

   parForm.cbSize = sizeof( PARAFORMAT2 );
   parForm.dwMask = PFM_OFFSETINDENT;

   SendMessage( (HWND) HB_PARNL( 1 ), (UINT) EM_GETPARAFORMAT, 0, (LPARAM) &parForm);

   hb_retnl( parForm.dxStartIndent );
}

HB_FUNC( SETPARSTARTID )                          // SetParStartId( HWND hwnd, LONG dxStartOffset)
{
   PARAFORMAT2 parForm;
   LONG oldStartId;

   parForm.cbSize = sizeof( PARAFORMAT2 );
   parForm.dwMask = PFM_OFFSETINDENT;

   SendMessage( (HWND) HB_PARNL( 1 ), (UINT) EM_GETPARAFORMAT, 0, (LPARAM) &parForm );
   oldStartId = parForm.dxStartIndent;
   parForm.dxStartIndent = hb_parnl( 2 );
   SendMessage( (HWND) HB_PARNL( 1 ), (UINT) EM_SETPARAFORMAT, 0, (LPARAM) &parForm );

   hb_retnl( oldStartId );
}

HB_FUNC( GETPARRIGHTID )                          // GetParRightId( HWND hwnd )
{
   PARAFORMAT2 parForm;

   parForm.cbSize = sizeof( PARAFORMAT2 );
   parForm.dwMask = PFM_RIGHTINDENT;

   SendMessage( (HWND) HB_PARNL( 1 ), (UINT) EM_GETPARAFORMAT, 0, (LPARAM) &parForm );

   hb_retnl( parForm.dxRightIndent );
}

HB_FUNC( SETPARRIGHTID )                          // SetParRightId( HWND hwnd, LONG dxRightId)
{
   PARAFORMAT2 parForm;
   LONG oldRightId;

   parForm.cbSize = sizeof(PARAFORMAT2);
   parForm.dwMask = PFM_RIGHTINDENT;

   SendMessage( (HWND) HB_PARNL( 1 ), (UINT) EM_GETPARAFORMAT, 0, (LPARAM) &parForm );
   oldRightId = parForm.dxRightIndent;
   parForm.dxRightIndent = hb_parnl( 2 );
   SendMessage( (HWND) HB_PARNL( 1 ), (UINT) EM_SETPARAFORMAT, 0, (LPARAM) &parForm );

   hb_retnl( oldRightId );
}

HB_FUNC( GETPAROFFSET )                           // GetParTabs( HWND hwnd )
{
   PARAFORMAT2 parForm;

   parForm.cbSize = sizeof( PARAFORMAT2 );
   parForm.dwMask = PFM_OFFSET;

   SendMessage( (HWND) HB_PARNL( 1 ), (UINT) EM_GETPARAFORMAT, 0, (LPARAM) &parForm );

   hb_retnl( parForm.dxOffset );
}

HB_FUNC( SETPAROFFSET )                           // SetParOffset( HWND hwnd, LONG dxOffset )
{
   PARAFORMAT2 parForm;
   LONG oldOffset;

   parForm.cbSize = sizeof( PARAFORMAT2 );
   parForm.dwMask = PFM_OFFSET;

   SendMessage( (HWND) HB_PARNL( 1 ), (UINT) EM_GETPARAFORMAT, 0, (LPARAM) &parForm );
   oldOffset = parForm.dxOffset;
   parForm.dxOffset = hb_parnl( 2 );
   SendMessage( (HWND) HB_PARNL( 1 ), (UINT) EM_SETPARAFORMAT, 0, (LPARAM) &parForm );

   hb_retnl( oldOffset );
}

HB_FUNC( SHOWSCROLLBAR )                          // ShowScrollBar( HWND hwnd, vert/hor, show/hide )
{
   UINT nBar;

   if( hb_parl( 2 ) )
      nBar = SB_VERT;
   else
      nBar = SB_HORZ;

   SendMessage( (HWND) HB_PARNL( 1 ), (UINT) EM_SHOWSCROLLBAR, (WPARAM) (UINT) nBar, (LPARAM) (BOOL) hb_parl( 3 ) );
}

HB_FUNC( REQUESTRESIZE )                          // RequestResize( HWND hwnd )
{
   SendMessage( (HWND) HB_PARNL( 1 ), (UINT) EM_REQUESTRESIZE, 0, 0 );
}

HB_FUNC( WINSIZE1 )                               // WinSize( HWND hwnd )
{
   HWND hwnd;
   TEXTMETRIC tm;
   HDC hdc;

   hwnd = (HWND) HB_PARNL( 1 );
   hdc = GetDC( hwnd );

   GetTextMetrics( hdc, &tm );

   ReleaseDC( hwnd, hdc);

   hb_reta( 2 );
   HB_STORNI( tm.tmDigitizedAspectX, -1, 1 );
   HB_STORNI( tm.tmAveCharWidth, -1, 2 );
}

HB_FUNC( POSFROMCHAR )                            // PointRTF( HWND hwnd )
{
   CHARRANGE cRange;
   DWORD ptl;

   SendMessage( (HWND) HB_PARNL( 1 ), (UINT) EM_EXGETSEL, 0, (LPARAM) &cRange );
   ptl = SendMessage( (HWND) HB_PARNL( 1 ), (UINT) EM_POSFROMCHAR, (WPARAM)(LONG) cRange.cpMax, 0 );

   hb_reta( 2 );
   HB_STORNL3( HIWORD( ptl ), -1, 1 );
   HB_STORNL3( LOWORD( ptl ), -1, 2 );
}

HB_FUNC( GETTEXTMODE )                            // GetTextMode( HWND hwnd )
{
hb_retnl( SendMessage( (HWND) HB_PARNL( 1 ), (UINT) EM_GETTEXTMODE, 0, 0) );
}

HB_FUNC( SETTEXTMODE )                            // SetTextMode( HWND hwnd, Mode )
{
   LRESULT lResult;
   UINT Mode;

   if( hb_parni( 2 ) == 2 )
      Mode = TM_RICHTEXT;
   else
      Mode = TM_PLAINTEXT;

   lResult = SendMessage( (HWND) HB_PARNL( 1 ), (UINT) EM_SETTEXTMODE, (WPARAM) Mode, 0 );
   if( lResult )
   {
      hb_retl( FALSE );
   }
   else
   {
      hb_retl( TRUE );
   }
}

HB_FUNC( GETEVENTMASK )                           // GetEventMask( HWND hwnd)
{
   hb_retnl( SendMessage( (HWND) HB_PARNL( 1 ), (UINT) EM_GETEVENTMASK, 0, 0 ) );
}

HB_FUNC( SETEVENTMASK )                           // SetEventMask( HWND hwnd, eMask)
{
   hb_retnl( SendMessage( (HWND) HB_PARNL( 1 ), (UINT) EM_SETEVENTMASK, 0, (LPARAM) hb_parni( 2 ) ) );
}

HB_FUNC( PAGESETUPRTF )                           // PageSetupRtf( HWND hwnd, lMar, rMar, tMar, bMar, wPage, hPage, sPage, oPage )
{
   LRESULT lResult;
   DEVMODE *DevMode;
   PAGESETUPDLG psd;
   POINT ptPapSize;
   RECT rtMar;
   SHORT PaperSize = DMPAPER_A5;
   SHORT PaperOrient = DMORIENT_PORTRAIT;
   UINT nFlags = PSD_DEFAULTMINMARGINS;     // PSD_SHOWHELP;
   rtMar.top = 0;
   rtMar.bottom = 0;

   DevMode = (DEVMODE *) GlobalAlloc( GPTR, sizeof( DEVMODE ) );

   if( hb_parni( 2 ) && hb_parni( 3 ) )
   {
      nFlags       = nFlags | PSD_MARGINS;
      rtMar.left   = hb_parni( 2 ) * 100;
      rtMar.right  = hb_parni( 3 ) * 100;
      rtMar.top    = hb_parni( 4 ) * 100;
      rtMar.bottom = hb_parni( 5 ) * 100;
   }
   if( hb_parni( 6 ) && hb_parni( 7 ) )
   {
      ptPapSize.x = hb_parni( 6 ) * 100;
      ptPapSize.y = hb_parni( 7 ) * 100;
   }
   if( hb_parni( 8 ) )
      PaperSize = (SHORT) hb_parni( 8 );
   if( hb_parni( 9 ) )
      PaperOrient = (SHORT) hb_parni( 9 );

   DevMode->dmSize        = sizeof( DEVMODE );
   DevMode->dmFields      = DM_ORIENTATION | DM_PAPERSIZE;
   DevMode->dmPaperSize   = PaperSize;
   DevMode->dmOrientation = PaperOrient;

   psd.lStructSize             = sizeof( PAGESETUPDLG );
#ifdef __XHARBOUR__
   psd.hwndOwner               = ISNIL( 1 ) ? GetActiveWindow() : (HWND) HB_PARNL( 1 );
#else
   psd.hwndOwner               = HB_ISNIL( 1 ) ? GetActiveWindow() : (HWND) HB_PARNL( 1 );
#endif
   psd.hDevMode                = (HGLOBAL) DevMode;
   psd.hDevNames               = (HGLOBAL) NULL;
   psd.rtMargin                = rtMar;
   psd.ptPaperSize             = ptPapSize;
   psd.Flags                   = nFlags;
   psd.hInstance               = (HINSTANCE) NULL;
   psd.lpfnPageSetupHook       = (LPPAGESETUPHOOK) NULL;
   psd.lpfnPagePaintHook       = (LPPAGEPAINTHOOK) NULL;
   psd.lpPageSetupTemplateName = (LPCTSTR) NULL;
   psd.hPageSetupTemplate      = (HGLOBAL) NULL;

   lResult = PageSetupDlg( &psd );
   if( lResult )
   {
      ptPapSize = psd.ptPaperSize;
      rtMar = psd.rtMargin;
      DevMode = psd.hDevMode;
      PaperSize = DevMode->dmPaperSize;
      PaperOrient = DevMode->dmOrientation;
   }

   hb_reta( 9 );
   HB_STORNI( lResult, -1, 1 );
   HB_STORNI( rtMar.left   / 100, -1, 2 );
   HB_STORNI( rtMar.right  / 100, -1, 3 );
   HB_STORNI( rtMar.top    / 100, -1, 4 );
   HB_STORNI( rtMar.bottom / 100, -1, 5 );
   HB_STORNI( ptPapSize.x  / 100, -1, 6 );
   HB_STORNI( ptPapSize.y  / 100, -1, 7 );
   HB_STORNI( PaperSize, -1, 8 );
   HB_STORNI( PaperOrient, -1, 9 );
}

/*
The DEVMODE data structure contains information about the device initialization and environment of a printer.

typedef struct _devicemode {   
BCHAR  dmDeviceName[CCHDEVICENAME];
WORD   dmSpecVersion;
WORD   dmDriverVersion;
WORD   dmSize;
WORD   dmDriverExtra;
DWORD  dmFields;
short  dmOrientation;
short  dmPaperSize;
short  dmPaperLength;
short  dmPaperWidth;
short  dmScale;
short  dmCopies;
short  dmDefaultSource;
short  dmPrintQuality;
short  dmColor;
short  dmDuplex;
short  dmYResolution;
short  dmTTOption;
short  dmCollate;
BCHAR  dmFormName[CCHFORMNAME];
WORD  dmLogPixels;
DWORD  dmBitsPerPel;
DWORD  dmPelsWidth;
DWORD  dmPelsHeight;
DWORD  dmDisplayFlags;
DWORD  dmDisplayFrequency;
#if(WINVER >= 0x0400)
DWORD  dmICMMethod;         // Windows 95 only
DWORD  dmICMIntent;         // Windows 95 only
DWORD  dmMediaType;         // Windows 95 only
DWORD  dmDitherType;        // Windows 95 only
DWORD  dmReserved1;         // Windows 95 only
DWORD  dmReserved2;         // Windows 95 only
#endif
} DEVMODE;
*/

HB_FUNC( TESTCHR )                                // TestChr( HWND hwnd, LPCTSTR lpszText, int Direction )
{
   LRESULT lResult;
   FINDTEXTEX Findtxt;
   CHARRANGE cRng1;
   CHARRANGE cRng2;
   int Style = 0;

   if( hb_parl( 3 ) )
   {
   Style = Style | FR_DOWN;
   }

   SendMessage( (HWND) HB_PARNL( 1 ), (UINT) EM_EXGETSEL, 0, (LPARAM) &cRng1 );

   if( hb_parl( 3 ) )
   {
      cRng1.cpMin = cRng1.cpMax;
      cRng1.cpMax = -1;
   }
   else
   {
      cRng1.cpMin = cRng1.cpMin;
      cRng1.cpMax = 0;
   }

   cRng2.cpMin = 0;
   cRng2.cpMax = 0;

   Findtxt.chrg      = (CHARRANGE) cRng1;
   Findtxt.lpstrText = hb_parc( 2 );
   Findtxt.chrgText  = (CHARRANGE) cRng2;

   lResult = SendMessage( (HWND) HB_PARNL( 1 ), (UINT) EM_FINDTEXTEX, (WPARAM) Style, (LPARAM) &Findtxt );

   hb_reta( 3 );
   HB_STORNL3( Findtxt.chrgText.cpMin, -1, 1 );
   HB_STORNL3( Findtxt.chrgText.cpMax, -1, 2 );
   HB_STORNL3( lResult, -1, 3 );
}

HB_FUNC( PLAINSELTEXT )                           // PlainSelText( HWND hwnd )
{
   LRESULT lResult;
   SETTEXTEX stxt;
   LPCTSTR strBuffer[ 64096 ];
   CHARRANGE cRange;

   stxt.flags = ST_KEEPUNDO | ST_SELECTION;
   stxt.codepage = CP_ACP;

   SendMessage( (HWND) HB_PARNL( 1 ), (UINT) EM_EXGETSEL, 0, (LPARAM) &cRange );
   SendMessage( (HWND) HB_PARNL( 1 ), (UINT)  EM_GETSELTEXT, 0, (LPARAM) &strBuffer );

   lResult = SendMessage( (HWND) HB_PARNL( 1 ), (UINT) EM_SETTEXTEX, (WPARAM) &stxt, (LPARAM)(LPCTSTR) &strBuffer );
   SendMessage( (HWND) HB_PARNL( 1 ), (UINT) EM_EXSETSEL, 0, (LPARAM) &cRange );

   hb_retnl( lResult );
}

HB_FUNC( SETTABSTOP )                             // SetTabStop( HWND hwnd )
{
   UINT dis = 4;
   LRESULT lResult;

   SendMessage( (HWND) HB_PARNL( 1 ), (UINT) EM_SETTABSTOPS, (WPARAM) 1, (LPARAM) &dis );
   lResult = GetDialogBaseUnits();

   hb_reta( 2 );
   HB_STORNL3( HIWORD( lResult ), -1, 1 );
   HB_STORNL3( LOWORD( lResult ), -1, 2 );
}

HB_FUNC( RTFREFRESH )                             // RtfRefresh( HWND hwnd )
{
   LRESULT lResult;
   RECT rc;

   SendMessage( (HWND) HB_PARNL( 1 ), (UINT) EM_GETRECT, 0, (LPARAM) &rc );
   rc.left = rc.left - hb_parni( 2 );
   rc.right = rc.right + hb_parni( 3 );

   lResult = InvalidateRect( (HWND) HB_PARNL( 1 ), &rc, FALSE );
   hb_retnl( lResult );
}

HB_FUNC( SCROLLCARET )                            // ScrollCaret( HWND hwnd, lSyscol, nRed, nGreen, nBlue )
{
   SendMessage( (HWND) HB_PARNL( 1 ), (UINT) EM_SCROLLCARET, 0, 0 );
}

HB_FUNC( LINESCROLL )                             // LineScroll( HWND hwnd, lSyscol, nRed, nGreen, nBlue )
{
   hb_retnl( SendMessage( (HWND) HB_PARNL( 1 ), (UINT) EM_LINESCROLL, 0, (LPARAM) hb_parnl( 2 ) ) );
}

HB_FUNC( GETFIRSTVISIBLELINE )                    // GetFirstVisibleLine( HWND hwnd, lSyscol, nRed, nGreen, nBlue )
{
   hb_retnl( SendMessage( (HWND) HB_PARNL( 1 ), (UINT) EM_GETFIRSTVISIBLELINE, 0, 0 ) );
}

HB_FUNC( GETSCROLLPOSRTF )                        // GetScrollPosRtf( HWND hwnd )
{
   POINT pt;

   SendMessage( (HWND) HB_PARNL( 1 ), (UINT) EM_GETSCROLLPOS, 0, (LPARAM) &pt );

   hb_reta( 2 );
   HB_STORNL3( pt.x, -1, 1 );
   HB_STORNL3( pt.y, -1, 2 );
}

HB_FUNC( SETSCROLLPOSRTF )                        // SetScrollPosRtf( HWND hwnd, x, y )
{
   POINT pt;
   pt.x = hb_parnl( 2 );
   pt.y = hb_parnl( 3 );

   SendMessage( (HWND) HB_PARNL( 1 ), (UINT) EM_SETSCROLLPOS, 0, (LPARAM) &pt );
}

#pragma ENDDUMP

/* eof */
