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
 *    along with this program.  If not, see <https://www.gnu.org/licenses/>.
*/

#include "US_Env.h"
#include "minigui.ch"

#translate MsgInfo(<texto>) => US_LOG( <texto> , .T. )

memvar US_SUBWIN
memvar US_FILDES
memvar US_COLDES
memvar US_WALTO
memvar US_WANCHO
memvar US_WLIENZO
memvar US_WCOL
memvar US_WFIL

Function GetActiveHelpFile()
Return _HMG_ActiveHelpFile

/*
 * Función para obtener el contenido de un RichEditBox
 */
Function US_GetRichEditValue( ventana , control , modo )
   Local cFile, memo , hRichEdit := GetControlHandle ( control , ventana )
   if empty( modo )
      modo := "TXT"
   endif
   do case
      case upper( modo ) == "RTF"
         cFile:=US_FileTmp("_Temp")
         StreamOut( hRichEdit , cFile , 2 )
         memo:=MemoRead( cFile )
         ferase( cFile )
      otherwise
      // memo := GetWindowText( hRichEdit )
         memo := GetProperty( ventana , control , "value" )
   endcase
Return memo

/*
 * Función para Convertir RTF to TXT
 */
Function US_RTF2TXT( memo )
   Local win := US_GetCurrentWindow() , cControl := procname()+"Control"+US_NameRandom()
   Local cAux
   @ 0,0 RICHEDITBOX &cControl ;
     OF &(Win) ;
     value memo ;
     width 0 ;
     height 0 ;
     INVISIBLE
   cAux := US_GetRichEditValue( win , cControl , "TXT" )
   DoMethod( win , cControl , "release" )
Return cAux

/*
 * Función para Recodificar correctamente un texto aparentemente RTF
 */
Function US_RTF2RTF( memo )
   Local win := US_GetCurrentWindow() , cControl := procname()+"control"+US_NameRandom()
   Local cAux
   @ 0,0 RICHEDITBOX &cControl ;
      OF &(Win) ;
      value memo ;
      width 0 ;
      height 0 ;
      INVISIBLE
   cAux := US_GetRichEditValue( win , cControl , "RTF" )
   DoMethod( win , cControl , "release" )
Return cAux

/*
 * Función para Obtener el contenido de un clipboard con texto RTF
 */
Function US_GetRtfClipboard()
   Local cVentana := US_GetCurrentWindow() , cControl := Procname()+"Control"+US_NameRandom()
   Local hEd
   Local cAux
   @ 0,0 RICHEDITBOX &cControl ;
      OF &( cVentana ) ;
      WIDTH 0 ;
      HEIGHT 0 ;
      value "" ;
      INVISIBLE
   hEd := GetControlHandle( cControl , cVentana )
   US_GetRtfClipboardPaste(hEd)
   cAux := US_GetRichEditValue( cVentana , cControl , "RTF" )
   DoMethod( cVentana , cControl , "release" )
Return cAux

FUNCTION US_NOP()
RETURN NIL

FUNCTION US_TOTFil()
RETURN (25)

FUNCTION US_TOTCol()
RETURN (80)

FUNCTION US_PCol(nValor)
RETURN US_PAncho(nValor)

FUNCTION US_PFil(nValor)
RETURN US_PAlto(nValor)

FUNCTION US_LCol(nValor)
RETURN IIF(!US_SUBWIN,US_PAncho((nValor * 100) / US_TOTCol()),(US_PAncho((nValor * 100) / US_TOTCol()))-US_COLDES)

FUNCTION US_TFil(nValor)
RETURN IIF(!US_SUBWIN,US_PAlto((nValor * 100) / US_TOTFil()),(US_PAlto((nValor * 100) / US_TOTFil()))-US_FILDES)

FUNCTION US_Fils(nValor)
RETURN (US_PAlto((nValor * 100) / US_TOTFil()))

FUNCTION US_Cols(nValor)
RETURN (US_PAncho((nValor * 100) / US_TOTCol()))

FUNCTION US_PAncho(nValor)
RETURN ((US_WANCHO * nValor) / 100)
*RETURN int((US_WANCHO * nValor) / 100)

FUNCTION US_PAlto(nValor)
RETURN ((US_WALTO * nValor) / 100)

/*
 * Función para establecer el tamaño de una fuente                   
 */
FUNCTION US_WFont(nValor)
Return ( ( US_WLienzo * nValor ) / 640 )

/*
 * ESTA Función DEJA ELEJIR UNA OPCION DE UNA LISTA Y/O ENVIA UN CARTEL
 */
FUNCTION US_Opcion(cTexto,LISTA,FILA,DEFAULT,cMsgTIT,FAYUDA,TIPO,TECLASALIR,ESPERA,COLORTIT,COLORFTIT,COLORMSG,COLORFMSG)
   LOCAL PALS, LONGIHELP, AYUDA:=.F., KESCTXT, COLUMNA:=14, LINEAS, INDLIS, ;
         LONGIPAL, DESPLA, ;
         WAux_Top , WAux_Left, WAux_Bottom, WAux_Right, ;
         WAux_Cols , WAux_Fils

   Local cMsg, RPTA:=0, ACTIONAUX, cCRLF, ;
           Ventana:="US_OP"+ALLTRIM(STR(DAY(DATE())))+ALLTRIM(STR(INT(SECONDS())))

   IF TIPO = NIL
      TIPO="N"
   ENDIF

   IF TECLASALIR = NIL
      TECLASALIR = -1
   ENDIF

   PALS:=IIF(LISTA!=NIL,US_WORDS(LISTA),0)

   IF ESPERA=NIL
      ESPERA:=.T.
   ENDIF

   cCRLF:=HB_OsNewLine()
   cMsg:=cTexto

   IF FAYUDA!=NIL .AND. ESPERA
      AYUDA:=.T.
   ENDIF

   WAux_Left:=COLUMNA
   WAux_Right:=(US_TOTCol()-COLUMNA)

   WAux_Cols:=WAux_Right-WAux_Left

   LINEAS:=(MLCOUNT(cMsg,WAux_Cols-1))
   IF LINEAS=1
      cMsg:=cCRLF+cMsg
      LINEAS:=3
   ENDIF
   IF LINEAS=2
      cMsg:=cCRLF+cMsg+cCRLF
      LINEAS:=4
   ENDIF
   if ( Fila + Lineas + 3 ) > 24
      WAux_Top := ( 24 - ( Lineas + 3 ))
   else
      WAux_Top := FILA
   endif

   WAux_Bottom:=WAux_Top+1+LINEAS+2
   WAux_Fils:=WAux_Bottom-WAux_Top

   DO CASE
      CASE TECLASALIR=0
           KESCTXT="ENTER"
      CASE TECLASALIR=1
           KESCTXT="ESCAPE"
      CASE TECLASALIR=2
           KESCTXT="CONTROL+ENTER"
      OTHERWISE
           KESCTXT=""
   ENDCASE

   IF cMsgTIT=NIL
      cMsgTIT="????????"
   ENDIF

   DO CASE
      CASE UPPER(TIPO)="C"
         COLORTIT:={191,128,128}
         COLORFTIT:=WHITE
         COLORMSG:={198,19,46}
         COLORFMSG:=WHITE
      CASE UPPER(TIPO)="W"
         COLORTIT:={253,249,83}
         COLORFTIT:=BLACK
         COLORMSG:={228,223,3}
         COLORFMSG:=BLACK
      CASE UPPER(TIPO)="N"
         COLORTIT:={0,185,185}
         COLORFTIT:=WHITE
         COLORMSG:={0,128,128}
         COLORFMSG:=WHITE
      OTHERWISE
   ENDCASE

   IF COLORTIT=NIL
      COLORTIT:={0,185,185}
   ENDIF
   IF COLORFTIT=NIL
      COLORFTIT:=WHITE
   ENDIF
   IF COLORMSG=NIL
      COLORMSG:={0,128,128}
   ENDIF
   IF COLORFMSG=NIL
      COLORFMSG:=WHITE
   ENDIF

   if GetActiveWindow() = 0

      MsgInfo(cMsg)

   else

      DEFINE WINDOW &(Ventana) ;
         AT US_WFIL+US_TFil(WAux_Top),US_WCOL+US_LCol(WAux_Left) ;
         WIDTH US_Cols(WAux_Cols) ;
         HEIGHT US_Fils(WAux_Fils) ;
         USMODAL ;
         NOSYSMENU ;
         NOCAPTION ;
         FONT "ARIAL" SIZE US_WFont(9) ;
         BACKCOLOR COLORMSG ;
         ON INIT USIOPCION(Ventana, ESPERA) ;
         ON RELEASE US_NOP()

         PRIVATE US_SUBWIN:=.T.,;
                 US_FILDES:=(&(Ventana).Row - US_WFIL), ;
                 US_COLDES:=(&(Ventana).Col - US_WCOL)

         IF AYUDA
            ON KEY F1 ACTION &(FAYUDA)
         ENDIF

         IF ESPERA
            DO CASE
               CASE TECLASALIR=0
                    ON KEY RETURN ACTION &(Ventana).Release()
               CASE TECLASALIR=2
                    ON KEY CONTROL+RETURN ACTION &(Ventana).Release()
               OTHERWISE
                    ON KEY ESCAPE ACTION &(Ventana).Release()
            ENDCASE
         ENDIF

         IF AYUDA
            LONGIHELP:=8
            @ US_TFil(WAux_Top),US_LCol(WAux_Left) BUTTON BAyuda ;
                   CAPTION "Ayuda (F1)" ;
                   ACTION  &(FAYUDA) ;
                   WIDTH   US_Cols(LONGIHELP) ;
                   HEIGHT  US_Fils(1) ;
                   FONT "ARIAL" SIZE US_WFont(6)
         ELSE
            LONGIHELP:=0
         ENDIF

         @ US_TFil(WAux_Top),US_LCol(WAux_Left+LONGIHELP) LABEL LTitulo ;
            VALUE cMsgTIT+REPLICATE(" ",LONGIHELP) ;
            CENTERALIGN ;
            ACTION InterActiveMoveHandle( GetFormHandle(Ventana) ) ;
            WIDTH  US_Cols(WAux_Cols-LONGIHELP) ;
            HEIGHT US_Fils(1) ;
            FONT "ARIAL" SIZE US_WFont(11) BOLD ;
            BACKCOLOR COLORTIT ;
            FONTCOLOR COLORFTIT

         @ US_TFil(WAux_Top+1),US_LCol(WAux_Left) LABEL LMsg ;
            VALUE cMsg ;
            CENTERALIGN ;
            WIDTH  US_Cols(WAux_Cols-1) ;
            HEIGHT US_Fils(LINEAS) ;
            FONT "COURIER NEW" SIZE US_WFont(9) BOLD ;
            BACKCOLOR COLORMSG ;
            FONTCOLOR COLORFMSG

         IF PALS=0
            IF ESPERA
               DEFINE BUTTON  BContinuar
                      ROW     US_TFil(WAux_Bottom - 2)
                      COL     US_LCol(WAux_Left + 5)
                      WIDTH   US_Cols((WAux_Right-5) - (WAux_Left+5))
                      HEIGHT  US_Fils(1)
                      CAPTION "Presione "+KESCTXT+" para Continuar"
                      ACTION  &(Ventana).Release()
               END BUTTON
            ELSE
               @ US_TFil(WAux_Bottom - 2) , US_LCol(WAux_Left + 5) LABEL LWait ;
                  WIDTH   US_Cols((WAux_Right-5) - (WAux_Left+5)) ;
                  HEIGHT  US_Fils(1) ;
                  VALUE   "Espere..." ;
                  CENTERALIGN ;
                  FONT "ARIAL" SIZE US_WFont(11) BOLD ;
                  BACKCOLOR COLORTIT ;
                  FONTCOLOR COLORFTIT
            ENDIF
         ELSE
            LONGIPAL:=INT((WAux_Cols-20) / PALS)
            DESPLA:=INT((WAux_Cols - ((LONGIPAL+2)*PALS)) / 2)
            FOR INDLIS=1 TO PALS
               ACTIONAUX:="USROpcion("+STR(INDLIS)+")"
               DEFINE BUTTON  &("BOp"+ALLTRIM(STR(INDLIS)))
                      ROW     US_TFil(WAux_Bottom - 2)
                      COL     US_LCol((WAux_Left + DESPLA) + 1 + ((LONGIPAL+2)*(INDLIS-1)))
                      WIDTH   US_Cols(LONGIPAL)
                      HEIGHT  US_Fils(1)
                      CAPTION US_WORD(LISTA,INDLIS)
                      ACTION  &ACTIONAUX
               END BUTTON
            NEXT
         ENDIF

      END WINDOW

      IF PALS > 0
         IF DEFAULT != "SINDEFAULT"
            &(Ventana).BOp1.SetFocus
         ELSE
            &(Ventana).LMsg.SetFocus
         ENDIF
      ELSE
         IF TECLASALIR=0
            IF ESPERA
               &(Ventana).BContinuar.SetFocus
            ELSE
               &(Ventana).LWait.SetFocus
            ENDIF
         ELSE
            &(Ventana).LMsg.SetFocus
         ENDIF
      ENDIF

      ACTIVATE WINDOW &(Ventana)

      IF PALS > 0
         RETURN US_WORD(LISTA,RPTA)
      ENDIF

   endif
RETURN ""

FUNCTION USIOpcion(Ventana, ESPERA)
   IF !ESPERA
      US_Wait(1)
      RETURN &(Ventana).Release()
   ENDIF
RETURN nil

FUNCTION US_MGMenu(W_TOP,W_LEFT,W_BOTTOM,W_RIGHT,VECTOR,VECTORBOOL,USERFUNC)
   Local W_COLS, W_FILS
   Local Ventana:="US_PM"+ALLTRIM(STR(DAY(DATE())))+ALLTRIM(STR(INT(SECONDS())))
   Local Opcion:=0

   Empty(VECTORBOOL)
   Empty(USERFUNC)

   W_COLS:=W_RIGHT-W_LEFT
   W_FILS:=W_BOTTOM-W_TOP

   DEFINE WINDOW &(Ventana) ;
      AT US_WFIL+US_TFil(W_TOP),US_WCOL+US_LCol(W_LEFT) ;
      WIDTH US_Cols(W_COLS) ;
      HEIGHT US_Fils(W_FILS) ;
      USMODAL ;
      NOSYSMENU ;
      FONT "COURIER NEW" SIZE US_WFont(09) ;
      ON RELEASE US_NOP()

      PRIVATE US_SUBWIN:=.T.,;
              US_FILDES:=(&(Ventana).Row - US_WFIL), ;
              US_COLDES:=(&(Ventana).Col - US_WCOL)

      ON KEY ESCAPE OF &VENTANA ACTION US_MenuEleccion(Ventana, .T., @Opcion)

      DEFINE LISTBOX List_1
             ROW     0
             COL     0
             WIDTH   &(Ventana).Width
             HEIGHT  &(Ventana).Height
             ITEMS VECTOR
             VALUE 1
             ONDBLCLICK US_MenuEleccion(Ventana, .F., @Opcion)
       END LISTBOX

   END WINDOW

   ACTIVATE WINDOW &(Ventana)

RETURN Opcion

FUNCTION US_MenuEleccion(Ventana, Escape, Opcion)
   IF ESCAPE
      Opcion := 0
   ELSE
      Opcion := &(Ventana).List_1.Value
   ENDIF
   &(Ventana).Release()
RETURN nil

#define EM_SETSEL   177

Function US_Send_SelectAll(ControlName,Ventana)
   Local c := GetControlHandle (ControlName,Ventana)
   SendMessage( c , EM_SETSEL , 0 , -1 )
Return NIL

/*
 * Functiones para registry
 */
Function US_GetReg(nKey, cRegKey, cVar)
   LOCAL oReg, cValor
   oReg := TReg32():Create(nKey, cRegKey)
   cValor := oReg:Get(cVar)
   if empty( cValor )
      cValor := ""
   endif
   if oReg:lError
      cValor := "*ERROR*"
      US_Log( "The requested internal function is only execute with Administrator User Atributes, but you user is not Administrator" , .T. , .T. )
   endif
   oReg:Close()
RETURN cValor

Function US_SetReg(nKey, cRegKey, cVar, Valor)
   LOCAL oReg, nValue
   oReg := TReg32():Create(nKey, cRegKey)
   nValue := oReg:Set(cVar, Valor)
   if oReg:lError
      US_Log( "The requested internal function is only executed with Administrator User Atributes, but you user is not Administrator" , .T. , .T. )
   endif
   oReg:Close()
RETURN nValue

/*
 * Type: 0 Reset
 */
Function US_SetWindowRgn(name,col,row,w,h,lx)
   local lhand
   lhand := GetFormHandle( name )
   US_2SetWindowRgn(lhand,col,row,w,h,lx)
Return Nil

/*
 * Funciones simples para porcentajes de pantalla
 */

// Pantalla completa
Function US_PorScreenAncho( nPor )
Return ( ( GetDesktopRealWidth() * nPor ) / 100 )

// Pantalla completa
Function US_PorScreenAlto( nPor )
Return ( ( GetDesktopRealHeight() * nPor ) / 100 )

// Ventana completa
Function US_PorWindowAncho( Ven , nPor )
Return ( ( GetProperty( Ven , "Width" ) * nPor ) / 100 )

// Ventana completa
Function US_PorWindowAlto( Ven , nPor )
Return ( ( GetProperty( Ven , "Height" ) * nPor ) / 100 )

Function US_GetCurrentWindow()
Return ThisWindow.name

Function US_IsWindowMainActive()
   Local i := ascan ( _HMG_aFormType , 'A' )
   if i <= 0
      Return .F.
   Endif
Return .T.

Function US_IsWindowModalActive()
Return _HMG_IsModalActive

Function US_WindowNameRandom( prefix )
   local win
   if prefix == NIL
      prefix := ""
   endif
   win := prefix + US_NameRandom()
   do while _IsWindowDefined( win )
      win := prefix + US_NameRandom()
   enddo
Return win

Function US_TempMainWindow( cFun )
   Local Reto
   Local cPan := "RSM" + US_NameRandom()
   DEFINE WINDOW &(cPan) at 0 , 0 ;
      WIDTH 0 ;
      HEIGHT 0 ;
      MAIN ;
      NOCAPTION ;
      NOSIZE ;
      ON INIT ( Reto := &( cFun ) , DoMethod( cPan , "release" ) )
   END WINDOW
   // NOSHOW ;
   DoMethod( cPan , "center" )
   DoMethod( cPan , "activate" )
Return Reto

Function US_DisplayHelpTopic( cActiveHelpFile , xTopic , nMet )
   LOCAL cParam := ""
   If empty(cActiveHelpFile)
       Return nil
   endif
   _HMG_nTopic := xTopic
   _HMG_nMet   := nMet
   if valtype(nMet) == 'U'
       nMet := 0
   endif
   If ValType( xTopic ) == 'N'
       cParam := "-mapid " + LTrim( Str( xTopic )) +  " " + cActiveHelpFile
   ElseIf ValType( xTopic ) == 'C'
       cParam :=  '"' + cActiveHelpFile + "::/" + AllTrim( xTopic ) + '.htm"'
   ElseIf ValType( xTopic ) == 'U'
       cParam := '"' + cActiveHelpFile + '"'
   EndIf
   _Execute( 0 , "Open", "HH.exe", cParam , , 5 )
Return nil

Function US_InitialBarIsOculta()
Return ( ( GetDesktopRealHeight() == GetDesktopHeight() ) .and. ( GetDesktopRealWidth() == GetDesktopWidth() ) )


#pragma BEGINDUMP

#define _WIN32_IE      0x0500

#include <windows.h>
#include <windows.h>
#include <commctrl.h>
#include "hbapi.h"
#include "winreg.h"
#include "tchar.h"
#include "qpm.h"

/*
 * Función para Obtener el contenido de un clipboard con texto RTF
 */
HB_FUNC(US_GETRTFCLIPBOARDPASTE)
{
   SendMessage( (HWND) HB_PARNL( 1 ), (UINT) WM_PASTE, 0, 0 );
}

HB_FUNC ( INTERACTIVEMOVEHANDLE )
{

        keybd_event(
                VK_RIGHT,       // virtual-key code
                0,              // hardware scan code
                0,              // flags specifying various function options
                0               // additional data associated with keystroke
        );
        keybd_event(
                VK_LEFT,        // virtual-key code
                0,              // hardware scan code
                0,              // flags specifying various function options
                0               // additional data associated with keystroke
        );

        SendMessage( (HWND) HB_PARNL(1) , WM_SYSCOMMAND , SC_MOVE ,10 );

}

HB_FUNC (US_2SETWINDOWRGN)
{
   HWND hWnd;
   HRGN hrgn;

   hWnd = (HWND) HB_PARNL (1);
   if ( hb_parni(6)==0)
          SetWindowRgn(GetActiveWindow(),NULL,TRUE);
   else
     {
     if ( hb_parni(6)==1 )
        hrgn=CreateRectRgn(hb_parni(2),hb_parni(3),hb_parni(4),hb_parni(5));
     else
        hrgn=CreateEllipticRgn(hb_parni(2),hb_parni(3),hb_parni(4),hb_parni(5));
     // SetWindowRgn(GetActiveWindow(),hrgn,TRUE);
     SetWindowRgn( hWnd , hrgn , TRUE ) ;
     // Should be hb_parnl(1) instead of GetActiveWindow()
     }
}

#define VK_C 67
#define VK_V 86
#define VK_X 88
#define VK_Z 90

// copy - ctrl-c
HB_FUNC( US_SEND_COPY )
{
    keybd_event(VK_CONTROL, MapVirtualKey(VK_CONTROL, 0), 0, 0);
    keybd_event(VK_C, MapVirtualKey(VK_C, 0), 0, 0);
    keybd_event(VK_C, MapVirtualKey(VK_C, 0), KEYEVENTF_KEYUP, 0);
    keybd_event(VK_CONTROL, MapVirtualKey(VK_CONTROL, 0), KEYEVENTF_KEYUP, 0);
}

// paste - ctrl-v
HB_FUNC( US_SEND_PASTE )
{
    keybd_event(VK_CONTROL, MapVirtualKey(VK_CONTROL, 0), 0, 0);
    keybd_event(VK_V, MapVirtualKey(VK_V, 0), 0, 0);
    keybd_event(VK_V, MapVirtualKey(VK_V, 0), KEYEVENTF_KEYUP, 0);
    keybd_event(VK_CONTROL, MapVirtualKey(VK_CONTROL, 0), KEYEVENTF_KEYUP, 0);
}

// cut - ctrl-x
HB_FUNC( US_SEND_CUT )
{
    keybd_event(VK_CONTROL, MapVirtualKey(VK_CONTROL, 0), 0, 0);
    keybd_event(VK_X, MapVirtualKey(VK_X, 0), 0, 0);
    keybd_event(VK_X, MapVirtualKey(VK_X, 0), KEYEVENTF_KEYUP, 0);
    keybd_event(VK_CONTROL, MapVirtualKey(VK_CONTROL, 0), KEYEVENTF_KEYUP, 0);
}

// undo - ctrl-z
HB_FUNC( US_SEND_UNDO )
{
    keybd_event(VK_CONTROL, MapVirtualKey(VK_CONTROL, 0), 0, 0);
    keybd_event(VK_Z, MapVirtualKey(VK_Z, 0), 0, 0);
    keybd_event(VK_Z, MapVirtualKey(VK_Z, 0), KEYEVENTF_KEYUP, 0);
    keybd_event(VK_CONTROL, MapVirtualKey(VK_CONTROL, 0), KEYEVENTF_KEYUP, 0);
}

HB_FUNC (GETDESKTOPREALTOP)
{
   RECT rect;
   SystemParametersInfo( SPI_GETWORKAREA, 1, &rect, 0 );
   hb_retni(rect.top);
}

HB_FUNC (GETDESKTOPREALLEFT)
{
   RECT rect;
   SystemParametersInfo( SPI_GETWORKAREA, 1, &rect, 0 );
   hb_retni(rect.left);
}

HB_FUNC (GETDESKTOPREALWIDTH)
{
   RECT rect;
   SystemParametersInfo( SPI_GETWORKAREA, 1, &rect, 0 );
   hb_retni(rect.right - rect.left);
}

HB_FUNC (GETDESKTOPREALHEIGHT)
{
   RECT rect;
   SystemParametersInfo( SPI_GETWORKAREA, 1, &rect, 0 );
   hb_retni(rect.bottom - rect.top);
}

#pragma ENDDUMP

/* eof */
