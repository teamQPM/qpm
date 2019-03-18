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

#include "minigui.ch"
#include "hbclass.ch"

CLASS US_ActiveX
   DATA aAxEv        INIT {}
   DATA aAxExec      INIT {}
   DATA hAtl
   DATA hSink
   DATA oOle
   DATA hWnd
   DATA cWindowName
   DATA cProgId
   DATA nRow
   DATA nCol
   DATA nWidth
   DATA nHeight
   DATA nOldWinWidth
   DATA nOldWinHeight
   DATA bHide INIT .F.
   METHOD New( cWindowName, cProgId , nRow , nCol , nWidth , nHeight )
   METHOD Load()
   METHOD ReSize( nRow , nCol , nWidth , nHeight )
   METHOD Hide()
   METHOD Show()
   METHOD Release()
   METHOD Refresh()
   METHOD Adjust()
   METHOD GetRow()
   METHOD GetCol()
   METHOD GetWidth()
   METHOD GetHeight()
   METHOD UserMap( nMsg, xExec, oSelf )
   ERROR HANDLER __Error
ENDCLASS

METHOD New( cWindowName , cProgId , nRow , nCol , nWidth , nHeight ) CLASS US_ActiveX
   if( empty( nRow )    , nRow    := 0                              , )
   if( empty( nCol )    , nCol    := 0                              , )
   if( empty( nWidth )  , nWidth  := GetProperty( cWindowName , "width" ) , )
   if( empty( nHeight ) , nHeight := GetProperty( cWindowName , "Height" ) , )
   ::nRow := nRow
   ::nCol := nCol
   ::nWidth := nWidth
   ::nHeight := nHeight
   ::cWindowName := cWindowName
   ::cProgId := cProgId
   ::nOldWinWidth := GetProperty( cWindowName , "width" )
   ::nOldWinHeight := GetProperty( cWindowName , "Height" )
Return Self

METHOD Load() CLASS US_ActiveX
   local nHandle := GetFormHandle(::cWindowName)
   local hSink
   local OCX_oError
   local OCX_bSaveHandler
   local OCX_nError := 0
   ::hWnd := InitActiveX( nHandle, ::cProgId , ::nCol , ::nRow , ::nWidth , ::nHeight )
   hAtl     := AtlAxGetDisp( ::hWnd )
   SetupConnectionPoint( hAtl, @hSink, ::aAxEv , ::aAxExec )
   ::hSink := hSink
#ifdef __XHARBOUR__
   TRY
      ::oOle := ToleAuto():New( hAtl )
   CATCH OCX_oError
      MsgInfo( OCX_oError:description, NIL, NIL, .F. )
   END
#else
   OCX_bSaveHandler := errorblock( { |x| break(x) } )
   BEGIN SEQUENCE
      ::oOle := ToleAuto():New( hAtl )
      RECOVER USING OCX_oError
         OCX_nError = OCX_oError:genCode
   END
   errorblock( OCX_bSaveHandler )
   if OCX_nError != 0
      MsgInfo( OCX_oError:description, NIL, NIL, .F. )
   endif
#endif
RETURN ::oOle

METHOD ReSize( nRow , nCol , nWidth , nHeight ) CLASS US_ActiveX
   if !::bHide
      MoveWindow( ::hWnd , nCol , nRow , nWidth , nHeight , .t. )
   endif
   ::nRow := nRow
   ::nCol := nCol
   ::nWidth := nWidth
   ::nHeight := nHeight
   ::nOldWinWidth := GetProperty( ::cWindowName , "width" )
   ::nOldWinHeight := GetProperty( ::cWindowName , "Height" )
RETURN .T.

METHOD Adjust() CLASS US_ActiveX
   Local nAuxRight , nAuxBottom
   nAuxRight := ( ::nOldWinWidth - ( ::nWidth + ::nCol ) )
   nAuxBottom := ( ::nOldWinHeight - ( ::nHeight + ::nRow ) )
   MoveWindow( ::hWnd , ::nCol , ::nRow , GetProperty( ::cWindowName , "width" ) - ::nCol - nAuxRight , GetProperty( ::cWindowName , "height" ) - ::nRow - nAuxBottom , .t. )
   ::nWidth := GetProperty( ::cWindowName , "width" ) - ::nCol - nAuxRight
   ::nHeight := GetProperty( ::cWindowName , "height" ) - ::nRow - nAuxBottom
   ::nOldWinWidth := GetProperty( ::cWindowName , "width" )
   ::nOldWinHeight := GetProperty( ::cWindowName , "Height" )
RETURN .T.

METHOD GetRow() CLASS US_ActiveX
RETURN ::nRow

METHOD GetCol() CLASS US_ActiveX
RETURN ::nCol

METHOD GetWidth() CLASS US_ActiveX
RETURN ::nWidth

METHOD GetHeight() CLASS US_ActiveX
RETURN ::nHeight

METHOD Hide() CLASS US_ActiveX
   MoveWindow( ::hWnd , 0 , 0 , 0 , 0 , .t. )
   ::bHide := .T.
RETURN .T.

METHOD Show() CLASS US_ActiveX
   MoveWindow( ::hWnd , ::nCol , ::nRow , ::nWidth , ::nHeight , .t. )
   ::bHide := .F.
RETURN .T.

METHOD Release() CLASS US_ActiveX
// SHUTDOWNCONNECTIONPOINT( ::hSink )
// ReleaseDispatch( ::hAtl )  // CdQ - Esta funcion provoca GPF en Windows
   DestroyWindow( ::hWnd )
// AtlAxWinEnd()
Return .T.

METHOD Refresh() CLASS US_ActiveX
   ::Hide()
   ::Show()
RETURN .T.

METHOD UserMap( nMsg, xExec, oSelf ) CLASS US_ActiveX
   LOCAL nAt
   nAt := AScan( ::aAxEv, nMsg )
   IF nAt == 0
      AAdd( ::aAxEv, nMsg )
      AAdd( ::aAxExec, { NIL, NIL } )
      nAt := Len( ::aAxEv )
   ENDIF
   ::aAxExec[ nAt ] := { xExec, oSelf }
RETURN NIL

///*-----------------------------------------------------------------------------------------------*/
#pragma BEGINDUMP
#include <windows.h>
#include "hbapi.h"

HB_FUNC_STATIC( DESTROYWINDOW ) // hWnd
{
    DestroyWindow( (HWND)hb_parnl( 1 ) );
    return;
}

#pragma ENDDUMP

/* eof */
