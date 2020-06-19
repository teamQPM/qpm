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
Function US_MsgInfo(parm,win)
Return MsgInfo( US_VarToStr(parm) , win )
*/
/*
Function GetModuleFileName()
Return GetExeFilename()
*/

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
//US_Log( win )
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
 * Función para Convertir TXT to RTF
 */
/*
Function US_TXT2RTF( memo )
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
*/

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

/*
 * Función para posicionar el reproductor de medios
 */
/*
Function US_SetPlayerPosition( ParentForm , ControlName , nPos )
   Local h , mVar
   mVar := '_' + ParentForm + '_' + ControlName
   h := _HMG_aControlhandles [&mVar]
   US_mcifunc ( h , 20 , nPos )
Return Nil
*/

/*
 * Función de API para agregar fuentes en forma dinámica
 * Ejemplo: US_AddFont( "VPArial.ttf", .T. )
 */
/*
Function US_AddFont( cNameFont , bCompartida )
   Local R
   #define FR_PRIVATE     0x10
   #define FR_NOT_ENUM    0x20
   if bCompartida=NIL .or. !bCompartida
      R:=AddFontResourceEx(cNameFont,FR_PRIVATE+FR_NOT_ENUM,0)
   else
      R:=AddFontResource(cNameFont)
   endif
   if R=NIL
      R:=0
   endif
   US_LOG("AddFont: "+cNameFont+", compartida: "+US_VarToStr(bCompartida)+", RC="+US_VarToStr(R)+", "+if(r<>0,"OK","ERROR") , .F. )
Return if(R<>0,0,-1)
*/

/*
 * Función de API para remover fuentes en forma dinámica
 * Ejemplo: US_RemoveFont( "VPArial.ttf", .T. )
 */
/*
Function US_RemoveFont(cNameFont,bCompartida)
   Local R
   if bCompartida=NIL .or. !bCompartida
      R:=RemoveFontResourceEx(cNameFont,FR_PRIVATE+FR_NOT_ENUM,0)
   else
      R:=RemoveFontResource(cNameFont)
   endif
   if R=NIL
      R:=0
   endif
   US_LOG("RemoveFont: "+cNameFont+", compartida: "+US_VarToStr(bCompartida)+", RC="+US_VarToStr(R)+", "+if(r<>0,"OK","ERROR") , .F. )
Return if(R<>0,0,-1)

// compartidas por otras aplicaciones
//DECLARE DLL_TYPE_INT AddFontResource ( DLL_TYPE_LPCTSTR lpszFilename ) IN GDI32.DLL
Function AddFontResource( lpszFilename )
Return CallDll32( "AddFontResource" , "GDI32.DLL" , lpszFilename )
//DECLARE DLL_TYPE_BOOL RemoveFontResource ( DLL_TYPE_LPCTSTR lpFileName ) IN GDI32.DLL
Function RemoveFontResource( lpFileName )
Return CallDll32( "RemoveFontResource" , "GDI32.DLL" , lpFileName )

// exclusivas de la aplicacion que las agrega
//DECLARE DLL_TYPE_INT AddFontResourceEx ( DLL_TYPE_LPCTSTR lpszFilename, DLL_TYPE_DWORD fl, DLL_TYPE_LPVOID pdv ) IN GDI32.DLL
Function AddFontResourceEx( lpszFilename, fl, pdv )
Return CallDll32( "AddFontResourceEx" , "GDI32.DLL" , lpszFilename, fl, pdv )
//DECLARE DLL_TYPE_BOOL RemoveFontResourceEx ( DLL_TYPE_LPCTSTR lpFileName, DLL_TYPE_DWORD fl, DLL_TYPE_LPVOID pdv ) IN GDI32.DLL
Function RemoveFontResourceEx( lpFileName, fl, pdv )
Return CallDll32( "RemoveFontResourceEx" , "GDI32.DLL" , lpFileName, fl, pdv )
*/

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

/*
FUNCTION US_RCol(nValor)
RETURN US_LCol(nValor + 1)
*/
FUNCTION US_TFil(nValor)
RETURN IIF(!US_SUBWIN,US_PAlto((nValor * 100) / US_TOTFil()),(US_PAlto((nValor * 100) / US_TOTFil()))-US_FILDES)
/*
FUNCTION US_BFil(nValor)
RETURN US_TFil(nValor + 1)
*/
FUNCTION US_Fils(nValor)
RETURN (US_PAlto((nValor * 100) / US_TOTFil()))

FUNCTION US_Cols(nValor)
RETURN (US_PAncho((nValor * 100) / US_TOTCol()))

FUNCTION US_PAncho(nValor)
RETURN ((US_WANCHO * nValor) / 100)
*RETURN int((US_WANCHO * nValor) / 100)

FUNCTION US_PAlto(nValor)
RETURN ((US_WALTO * nValor) / 100)
//RETURN int((US_WALTO * nValor) / 100)

/*
 * Función para establecer el tamaño de una fuente                   
 */
FUNCTION US_WFont(nValor)
//   Local ancho, alto
//   ancho:=( ( US_WLienzo * nValor ) / 640 )
//   alto :=( ( US_HLienzo * nValor ) / 480 )
//Return if( ancho<alto , ancho , alto )
Return ( ( US_WLienzo * nValor ) / 640 )
//Return ( ( US_HLienzo * nValor ) / 480 )

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

      *      DEFINE BUTTON  BUp
      *             ROW     US_TFil(WAux_Top)
      *             COL     US_LCol(WAux_Right-8)
      *             WIDTH   US_Cols(4)
      *             HEIGHT  US_Fils(1)
      *             CAPTION "^"
      *             ACTION  &("US_NOP()")
      *      END BUTTON
      *      DEFINE BUTTON  BDown
      *             ROW     US_TFil(WAux_Top)
      *             COL     US_LCol(WAux_Right-4)
      *             WIDTH   US_Cols(4)
      *             HEIGHT  US_Fils(1)
      *             CAPTION "v"
      *             ACTION  &("US_NOP()")
      *      END BUTTON

      *      IF !ESPERA
      *         &(Ventana).BUp.Enabled := .F.
      *         &(Ventana).BDown.Enabled := .F.
      *      ENDIF

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

/*
FUNCTION USROpcion(OPCION)
   RPTA:=OPCION
RETURN &(Ventana).Release()

FUNCTION US_SETKEY(TECLA,VENTANA,ACCION)
*us_log("tecla,ventana,accion "+US_VarToStr(tecla)+"<"+US_VarToStr(ventana)+"<"+US_VarToStr(accion))
DO CASE
*   CASE TECLA = "ADD"
*      IF ACCION = NIL
*         RELEASE KEY ADD OF &VENTANA
*      ELSE
*         IF VENTANA = NIL
*            ON KEY ADD  ACTION &ACCION
*         ELSE
*            ON KEY ADD OF &VENTANA ACTION &ACCION
*         ENDIF
*      ENDIF
*   CASE TECLA = "SUBTRACT"
*      IF ACCION = NIL
*         RELEASE KEY SUBTRACT OF &VENTANA
*      ELSE
*         IF VENTANA = NIL
*            ON KEY SUBTRACT  ACTION &ACCION
*         ELSE
*            ON KEY SUBTRACT OF &VENTANA ACTION &ACCION
*         ENDIF
*      ENDIF
*   CASE TECLA = "MULTIPLY"
*      IF ACCION = NIL
*         RELEASE KEY MULTIPLY OF &VENTANA
*      ELSE
*         IF VENTANA = NIL
*            ON KEY MULTIPLY  ACTION &ACCION
*         ELSE
*            ON KEY MULTIPLY OF &VENTANA ACTION &ACCION
*         ENDIF
*      ENDIF
   CASE TECLA = "K_A"
      IF ACCION = NIL
         RELEASE KEY A OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY A  ACTION &ACCION
         ELSE
            ON KEY A OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_B"
      IF ACCION = NIL
         RELEASE KEY B OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY B  ACTION &ACCION
         ELSE
            ON KEY B OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_C"
      IF ACCION = NIL
         RELEASE KEY C OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY C  ACTION &ACCION
         ELSE
            ON KEY C OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_D"
      IF ACCION = NIL
         RELEASE KEY D OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY D  ACTION &ACCION
         ELSE
            ON KEY D OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_E"
      IF ACCION = NIL
         RELEASE KEY E OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY E  ACTION &ACCION
         ELSE
            ON KEY E OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_F"
      IF ACCION = NIL
         RELEASE KEY F OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY F  ACTION &ACCION
         ELSE
            ON KEY F OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_G"
      IF ACCION = NIL
         RELEASE KEY G OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY G  ACTION &ACCION
         ELSE
            ON KEY G OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_H"
      IF ACCION = NIL
         RELEASE KEY H OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY H  ACTION &ACCION
         ELSE
            ON KEY H OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_I"
      IF ACCION = NIL
         RELEASE KEY I OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY I  ACTION &ACCION
         ELSE
            ON KEY I OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_J"
      IF ACCION = NIL
         RELEASE KEY J OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY J  ACTION &ACCION
         ELSE
            ON KEY J OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_K"
      IF ACCION = NIL
         RELEASE KEY K OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY K  ACTION &ACCION
         ELSE
            ON KEY K OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_L"
      IF ACCION = NIL
         RELEASE KEY L OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY L  ACTION &ACCION
         ELSE
            ON KEY L OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_M"
      IF ACCION = NIL
         RELEASE KEY M OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY M  ACTION &ACCION
         ELSE
            ON KEY M OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_N"
      IF ACCION = NIL
         RELEASE KEY N OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY N  ACTION &ACCION
         ELSE
            ON KEY N OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_O"
      IF ACCION = NIL
         RELEASE KEY O OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY O  ACTION &ACCION
         ELSE
            ON KEY O OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_P"
      IF ACCION = NIL
         RELEASE KEY P OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY P  ACTION &ACCION
         ELSE
            ON KEY P OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_Q"
      IF ACCION = NIL
         RELEASE KEY Q OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY Q  ACTION &ACCION
         ELSE
            ON KEY Q OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_R"
      IF ACCION = NIL
         RELEASE KEY R OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY R  ACTION &ACCION
         ELSE
            ON KEY R OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_S"
      IF ACCION = NIL
         RELEASE KEY S OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY S  ACTION &ACCION
         ELSE
            ON KEY S OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_T"
      IF ACCION = NIL
         RELEASE KEY T OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY T  ACTION &ACCION
         ELSE
            ON KEY T OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_U"
      IF ACCION = NIL
         RELEASE KEY U OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY U  ACTION &ACCION
         ELSE
            ON KEY U OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_V"
      IF ACCION = NIL
         RELEASE KEY V OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY V  ACTION &ACCION
         ELSE
            ON KEY V OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_W"
      IF ACCION = NIL
         RELEASE KEY W OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY W  ACTION &ACCION
         ELSE
            ON KEY W OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_X"
      IF ACCION = NIL
         RELEASE KEY X OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY X  ACTION &ACCION
         ELSE
            ON KEY X OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_Y"
      IF ACCION = NIL
         RELEASE KEY Y OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY Y  ACTION &ACCION
         ELSE
            ON KEY Y OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_Z"
      IF ACCION = NIL
         RELEASE KEY Z OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY Z  ACTION &ACCION
         ELSE
            ON KEY Z OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_0"
      IF ACCION = NIL
         RELEASE KEY 0 OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY 0  ACTION &ACCION
         ELSE
            ON KEY 0 OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_1"
      IF ACCION = NIL
         RELEASE KEY 1 OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY 1  ACTION &ACCION
         ELSE
            ON KEY 1 OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_2"
      IF ACCION = NIL
         RELEASE KEY 2 OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY 2  ACTION &ACCION
         ELSE
            ON KEY 2 OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_3"
      IF ACCION = NIL
         RELEASE KEY 3 OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY 3  ACTION &ACCION
         ELSE
            ON KEY 3 OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_4"
      IF ACCION = NIL
         RELEASE KEY 4 OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY 4  ACTION &ACCION
         ELSE
            ON KEY 4 OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_5"
      IF ACCION = NIL
         RELEASE KEY 5 OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY 5  ACTION &ACCION
         ELSE
            ON KEY 5 OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_6"
      IF ACCION = NIL
         RELEASE KEY 6 OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY 6  ACTION &ACCION
         ELSE
            ON KEY 6 OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_7"
      IF ACCION = NIL
         RELEASE KEY 7 OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY 7  ACTION &ACCION
         ELSE
            ON KEY 7 OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_8"
      IF ACCION = NIL
         RELEASE KEY 8 OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY 8  ACTION &ACCION
         ELSE
            ON KEY 8 OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_9"
      IF ACCION = NIL
         RELEASE KEY 9 OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY 9  ACTION &ACCION
         ELSE
            ON KEY 9 OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_F1"
      IF ACCION = NIL
         RELEASE KEY F1 OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY F1  ACTION &ACCION
         ELSE
            ON KEY F1 OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_F2"
      IF ACCION = NIL
         RELEASE KEY F2 OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY F2  ACTION &ACCION
         ELSE
            ON KEY F2 OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_F3"
      IF ACCION = NIL
         RELEASE KEY F3 OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY F3  ACTION &ACCION
         ELSE
            ON KEY F3 OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_F4"
      IF ACCION = NIL
         RELEASE KEY F4 OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY F4  ACTION &ACCION
         ELSE
            ON KEY F4 OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_F5"
      IF ACCION = NIL
         RELEASE KEY F5 OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY F5  ACTION &ACCION
         ELSE
            ON KEY F5 OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_F6"
      IF ACCION = NIL
         RELEASE KEY F6 OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY F6  ACTION &ACCION
         ELSE
            ON KEY F6 OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_F7"
      IF ACCION = NIL
         RELEASE KEY F7 OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY F7  ACTION &ACCION
         ELSE
            ON KEY F7 OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_F8"
      IF ACCION = NIL
         RELEASE KEY F8 OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY F8  ACTION &ACCION
         ELSE
            ON KEY F8 OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_F9"
      IF ACCION = NIL
         RELEASE KEY F9 OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY F9  ACTION &ACCION
         ELSE
            ON KEY F9 OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_F10"
      IF ACCION = NIL
         RELEASE KEY F10 OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY F10  ACTION &ACCION
         ELSE
            ON KEY F10 OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_F11"
      IF ACCION = NIL
         RELEASE KEY F11 OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY F11  ACTION &ACCION
         ELSE
            ON KEY F11 OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_F12"
      IF ACCION = NIL
         RELEASE KEY F12 OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY F12  ACTION &ACCION
         ELSE
            ON KEY F12 OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_BS"
      IF ACCION = NIL
         RELEASE KEY BACK OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY BACK  ACTION &ACCION
         ELSE
            ON KEY BACK OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_TAB"
      IF ACCION = NIL
         RELEASE KEY TAB OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY TAB  ACTION &ACCION
         ELSE
            ON KEY TAB OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_ENTER"
      IF ACCION = NIL
         RELEASE KEY RETURN OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY RETURN  ACTION &ACCION
         ELSE
            ON KEY RETURN OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_ESC"
      IF ACCION = NIL
         RELEASE KEY ESCAPE OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY ESCAPE  ACTION &ACCION
         ELSE
            ON KEY ESCAPE OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_END"
      IF ACCION = NIL
         RELEASE KEY END OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY END  ACTION &ACCION
         ELSE
            ON KEY END OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_HOME"
      IF ACCION = NIL
         RELEASE KEY HOME OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY HOME  ACTION &ACCION
         ELSE
            ON KEY HOME OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_LEFT"
      IF ACCION = NIL
         RELEASE KEY LEFT OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY LEFT  ACTION &ACCION
         ELSE
            ON KEY LEFT OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_UP"
      IF ACCION = NIL
         RELEASE KEY UP OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY UP  ACTION &ACCION
         ELSE
            ON KEY UP OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_RIGHT"
      IF ACCION = NIL
         RELEASE KEY RIGHT OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY RIGHT  ACTION &ACCION
         ELSE
            ON KEY RIGHT OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_DOWN"
      IF ACCION = NIL
         RELEASE KEY DOWN OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY DOWN  ACTION &ACCION
         ELSE
            ON KEY DOWN OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_INS"
      IF ACCION = NIL
         RELEASE KEY INSERT OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY INSERT  ACTION &ACCION
         ELSE
            ON KEY INSERT OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_DEL"
      IF ACCION = NIL
         RELEASE KEY DELETE OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY DELETE  ACTION &ACCION
         ELSE
            ON KEY DELETE OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
*   CASE TECLA = "PRIOR"
*      IF ACCION = NIL
*         RELEASE KEY PRIOR OF &VENTANA
*      ELSE
*         IF VENTANA = NIL
*            ON KEY PRIOR  ACTION &ACCION
*         ELSE
*            ON KEY PRIOR OF &VENTANA ACTION &ACCION
*         ENDIF
*      ENDIF
*   CASE TECLA = "NEXT"
*      IF ACCION = NIL
*         RELEASE KEY NEXT OF &VENTANA
*      ELSE
*         IF VENTANA = NIL
*            ON KEY NEXT  ACTION &ACCION
*         ELSE
*            ON KEY NEXT OF &VENTANA ACTION &ACCION
*         ENDIF
*      ENDIF
   CASE TECLA = "K_ALT_A"
      IF ACCION = NIL
         RELEASE KEY ALT+A OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY ALT+A  ACTION &ACCION
         ELSE
            ON KEY ALT+A OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_ALT_B"
      IF ACCION = NIL
         RELEASE KEY ALT+B OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY ALT+B  ACTION &ACCION
         ELSE
            ON KEY ALT+B OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_ALT_C"
      IF ACCION = NIL
         RELEASE KEY ALT+C OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY ALT+C  ACTION &ACCION
         ELSE
            ON KEY ALT+C OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_ALT_D"
      IF ACCION = NIL
         RELEASE KEY ALT+D OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY ALT+D  ACTION &ACCION
         ELSE
            ON KEY ALT+D OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_ALT_E"
      IF ACCION = NIL
         RELEASE KEY ALT+E OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY ALT+E  ACTION &ACCION
         ELSE
            ON KEY ALT+E OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_ALT_F"
      IF ACCION = NIL
         RELEASE KEY ALT+F OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY ALT+F  ACTION &ACCION
         ELSE
            ON KEY ALT+F OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_ALT_G"
      IF ACCION = NIL
         RELEASE KEY ALT+G OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY ALT+G  ACTION &ACCION
         ELSE
            ON KEY ALT+G OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_ALT_H"
      IF ACCION = NIL
         RELEASE KEY ALT+H OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY ALT+H  ACTION &ACCION
         ELSE
            ON KEY ALT+H OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_ALT_I"
      IF ACCION = NIL
         RELEASE KEY ALT+I OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY ALT+I  ACTION &ACCION
         ELSE
            ON KEY ALT+I OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_ALT_J"
      IF ACCION = NIL
         RELEASE KEY ALT+J OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY ALT+J  ACTION &ACCION
         ELSE
            ON KEY ALT+J OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_ALT_K"
      IF ACCION = NIL
         RELEASE KEY ALT+K OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY ALT+K  ACTION &ACCION
         ELSE
            ON KEY ALT+K OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_ALT_L"
      IF ACCION = NIL
         RELEASE KEY ALT+L OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY ALT+L  ACTION &ACCION
         ELSE
            ON KEY ALT+L OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_ALT_M"
      IF ACCION = NIL
         RELEASE KEY ALT+M OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY ALT+M  ACTION &ACCION
         ELSE
            ON KEY ALT+M OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_ALT_N"
      IF ACCION = NIL
         RELEASE KEY ALT+N OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY ALT+N  ACTION &ACCION
         ELSE
            ON KEY ALT+N OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_ALT_O"
      IF ACCION = NIL
         RELEASE KEY ALT+O OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY ALT+O  ACTION &ACCION
         ELSE
            ON KEY ALT+O OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_ALT_P"
      IF ACCION = NIL
         RELEASE KEY ALT+P OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY ALT+P  ACTION &ACCION
         ELSE
            ON KEY ALT+P OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_ALT_Q"
      IF ACCION = NIL
         RELEASE KEY ALT+Q OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY ALT+Q  ACTION &ACCION
         ELSE
            ON KEY ALT+Q OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_ALT_R"
      IF ACCION = NIL
         RELEASE KEY ALT+R OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY ALT+R  ACTION &ACCION
         ELSE
            ON KEY ALT+R OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_ALT_S"
      IF ACCION = NIL
         RELEASE KEY ALT+S OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY ALT+S  ACTION &ACCION
         ELSE
            ON KEY ALT+S OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_ALT_T"
      IF ACCION = NIL
         RELEASE KEY ALT+T OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY ALT+T  ACTION &ACCION
         ELSE
            ON KEY ALT+T OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_ALT_U"
      IF ACCION = NIL
         RELEASE KEY ALT+U OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY ALT+U  ACTION &ACCION
         ELSE
            ON KEY ALT+U OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_ALT_V"
      IF ACCION = NIL
         RELEASE KEY ALT+V OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY ALT+V  ACTION &ACCION
         ELSE
            ON KEY ALT+V OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_ALT_W"
      IF ACCION = NIL
         RELEASE KEY ALT+W OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY ALT+W  ACTION &ACCION
         ELSE
            ON KEY ALT+W OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_ALT_X"
      IF ACCION = NIL
         RELEASE KEY ALT+X OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY ALT+X  ACTION &ACCION
         ELSE
            ON KEY ALT+X OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_ALT_Y"
      IF ACCION = NIL
         RELEASE KEY ALT+Y OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY ALT+Y  ACTION &ACCION
         ELSE
            ON KEY ALT+Y OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_ALT_Z"
      IF ACCION = NIL
         RELEASE KEY ALT+Z OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY ALT+Z  ACTION &ACCION
         ELSE
            ON KEY ALT+Z OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_ALT_0"
      IF ACCION = NIL
         RELEASE KEY ALT+0 OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY ALT+0  ACTION &ACCION
         ELSE
            ON KEY ALT+0 OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_ALT_1"
      IF ACCION = NIL
         RELEASE KEY ALT+1 OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY ALT+1  ACTION &ACCION
         ELSE
            ON KEY ALT+1 OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_ALT_2"
      IF ACCION = NIL
         RELEASE KEY ALT+2 OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY ALT+2  ACTION &ACCION
         ELSE
            ON KEY ALT+2 OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_ALT_3"
      IF ACCION = NIL
         RELEASE KEY ALT+3 OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY ALT+3  ACTION &ACCION
         ELSE
            ON KEY ALT+3 OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_ALT_4"
      IF ACCION = NIL
         RELEASE KEY ALT+4 OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY ALT+4  ACTION &ACCION
         ELSE
            ON KEY ALT+4 OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_ALT_5"
      IF ACCION = NIL
         RELEASE KEY ALT+5 OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY ALT+5  ACTION &ACCION
         ELSE
            ON KEY ALT+5 OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_ALT_6"
      IF ACCION = NIL
         RELEASE KEY ALT+6 OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY ALT+6  ACTION &ACCION
         ELSE
            ON KEY ALT+6 OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_ALT_7"
      IF ACCION = NIL
         RELEASE KEY ALT+7 OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY ALT+7  ACTION &ACCION
         ELSE
            ON KEY ALT+7 OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_ALT_8"
      IF ACCION = NIL
         RELEASE KEY ALT+8 OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY ALT+8  ACTION &ACCION
         ELSE
            ON KEY ALT+8 OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_ALT_9"
      IF ACCION = NIL
         RELEASE KEY ALT+9 OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY ALT+9  ACTION &ACCION
         ELSE
            ON KEY ALT+9 OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_ALT_F1"
      IF ACCION = NIL
         RELEASE KEY ALT+F1 OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY ALT+F1  ACTION &ACCION
         ELSE
            ON KEY ALT+F1 OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_ALT_F2"
      IF ACCION = NIL
         RELEASE KEY ALT+F2 OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY ALT+F2  ACTION &ACCION
         ELSE
            ON KEY ALT+F2 OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_ALT_F3"
      IF ACCION = NIL
         RELEASE KEY ALT+F3 OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY ALT+F3  ACTION &ACCION
         ELSE
            ON KEY ALT+F3 OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_ALT_F4"
      IF ACCION = NIL
         RELEASE KEY ALT+F4 OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY ALT+F4  ACTION &ACCION
         ELSE
            ON KEY ALT+F4 OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_ALT_F5"
      IF ACCION = NIL
         RELEASE KEY ALT+F5 OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY ALT+F5  ACTION &ACCION
         ELSE
            ON KEY ALT+F5 OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_ALT_F6"
      IF ACCION = NIL
         RELEASE KEY ALT+F6 OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY ALT+F6  ACTION &ACCION
         ELSE
            ON KEY ALT+F6 OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_ALT_F7"
      IF ACCION = NIL
         RELEASE KEY ALT+F7 OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY ALT+F7  ACTION &ACCION
         ELSE
            ON KEY ALT+F7 OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_ALT_F8"
      IF ACCION = NIL
         RELEASE KEY ALT+F8 OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY ALT+F8  ACTION &ACCION
         ELSE
            ON KEY ALT+F8 OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_ALT_F9"
      IF ACCION = NIL
         RELEASE KEY ALT+F9 OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY ALT+F9  ACTION &ACCION
         ELSE
            ON KEY ALT+F9 OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_ALT_F10"
      IF ACCION = NIL
         RELEASE KEY ALT+F10 OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY ALT+F10  ACTION &ACCION
         ELSE
            ON KEY ALT+F10 OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_ALT_F11"
      IF ACCION = NIL
         RELEASE KEY ALT+F11 OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY ALT+F11  ACTION &ACCION
         ELSE
            ON KEY ALT+F11 OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_ALT_F12"
      IF ACCION = NIL
         RELEASE KEY ALT+F12 OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY ALT+F12  ACTION &ACCION
         ELSE
            ON KEY ALT+F12 OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_ALT_BS"
      IF ACCION = NIL
         RELEASE KEY ALT+BACK OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY ALT+BACK  ACTION &ACCION
         ELSE
            ON KEY ALT+BACK OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_ALT_TAB"
      IF ACCION = NIL
         RELEASE KEY ALT+TAB OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY ALT+TAB  ACTION &ACCION
         ELSE
            ON KEY ALT+TAB OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_ALT_ENTER"
      IF ACCION = NIL
         RELEASE KEY ALT+RETURN OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY ALT+RETURN  ACTION &ACCION
         ELSE
            ON KEY ALT+RETURN OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_ALT_ESC"
      IF ACCION = NIL
         RELEASE KEY ALT+ESCAPE OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY ALT+ESCAPE  ACTION &ACCION
         ELSE
            ON KEY ALT+ESCAPE OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_ALT_END"
      IF ACCION = NIL
         RELEASE KEY ALT+END OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY ALT+END  ACTION &ACCION
         ELSE
            ON KEY ALT+END OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_ALT_HOME"
      IF ACCION = NIL
         RELEASE KEY ALT+HOME OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY ALT+HOME  ACTION &ACCION
         ELSE
            ON KEY ALT+HOME OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_ALT_LEFT"
      IF ACCION = NIL
         RELEASE KEY ALT+LEFT OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY ALT+LEFT  ACTION &ACCION
         ELSE
            ON KEY ALT+LEFT OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_ALT_UP"
      IF ACCION = NIL
         RELEASE KEY ALT+UP OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY ALT+UP  ACTION &ACCION
         ELSE
            ON KEY ALT+UP OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_ALT_RIGHT"
      IF ACCION = NIL
         RELEASE KEY ALT+RIGHT OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY ALT+RIGHT  ACTION &ACCION
         ELSE
            ON KEY ALT+RIGHT OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_ALT_DOWN"
      IF ACCION = NIL
         RELEASE KEY ALT+DOWN OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY ALT+DOWN  ACTION &ACCION
         ELSE
            ON KEY ALT+DOWN OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_ALT_INS"
      IF ACCION = NIL
         RELEASE KEY ALT+INSERT OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY ALT+INSERT  ACTION &ACCION
         ELSE
            ON KEY ALT+INSERT OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_ALT_DEL"
      IF ACCION = NIL
         RELEASE KEY ALT+DELETE OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY ALT+DELETE  ACTION &ACCION
         ELSE
            ON KEY ALT+DELETE OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
*   CASE TECLA = "K_ALT_PRIOR"
*      IF ACCION = NIL
*         RELEASE KEY ALT+PRIOR OF &VENTANA
*      ELSE
*         IF VENTANA = NIL
*            ON KEY ALT+PRIOR  ACTION &ACCION
*         ELSE
*            ON KEY ALT+PRIOR OF &VENTANA ACTION &ACCION
*         ENDIF
*      ENDIF
*   CASE TECLA = "K_ALT_NEXT"
*      IF ACCION = NIL
*         RELEASE KEY ALT+NEXT OF &VENTANA
*      ELSE
*         IF VENTANA = NIL
*            ON KEY ALT+NEXT  ACTION &ACCION
*         ELSE
*            ON KEY ALT+NEXT OF &VENTANA ACTION &ACCION
*         ENDIF
*      ENDIF
   CASE TECLA = "K_SHIFT_A"
      IF ACCION = NIL
         RELEASE KEY SHIFT+A OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY SHIFT+A  ACTION &ACCION
         ELSE
            ON KEY SHIFT+A OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_SHIFT_B"
      IF ACCION = NIL
         RELEASE KEY SHIFT+B OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY SHIFT+B  ACTION &ACCION
         ELSE
            ON KEY SHIFT+B OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_SHIFT_C"
      IF ACCION = NIL
         RELEASE KEY SHIFT+C OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY SHIFT+C  ACTION &ACCION
         ELSE
            ON KEY SHIFT+C OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_SHIFT_D"
      IF ACCION = NIL
         RELEASE KEY SHIFT+D OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY SHIFT+D  ACTION &ACCION
         ELSE
            ON KEY SHIFT+D OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_SHIFT_E"
      IF ACCION = NIL
         RELEASE KEY SHIFT+E OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY SHIFT+E  ACTION &ACCION
         ELSE
            ON KEY SHIFT+E OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_SHIFT_F"
      IF ACCION = NIL
         RELEASE KEY SHIFT+F OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY SHIFT+F  ACTION &ACCION
         ELSE
            ON KEY SHIFT+F OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_SHIFT_G"
      IF ACCION = NIL
         RELEASE KEY SHIFT+G OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY SHIFT+G  ACTION &ACCION
         ELSE
            ON KEY SHIFT+G OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_SHIFT_H"
      IF ACCION = NIL
         RELEASE KEY SHIFT+H OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY SHIFT+H  ACTION &ACCION
         ELSE
            ON KEY SHIFT+H OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_SHIFT_I"
      IF ACCION = NIL
         RELEASE KEY SHIFT+I OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY SHIFT+I  ACTION &ACCION
         ELSE
            ON KEY SHIFT+I OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_SHIFT_J"
      IF ACCION = NIL
         RELEASE KEY SHIFT+J OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY SHIFT+J  ACTION &ACCION
         ELSE
            ON KEY SHIFT+J OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_SHIFT_K"
      IF ACCION = NIL
         RELEASE KEY SHIFT+K OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY SHIFT+K  ACTION &ACCION
         ELSE
            ON KEY SHIFT+K OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_SHIFT_L"
      IF ACCION = NIL
         RELEASE KEY SHIFT+L OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY SHIFT+L  ACTION &ACCION
         ELSE
            ON KEY SHIFT+L OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_SHIFT_M"
      IF ACCION = NIL
         RELEASE KEY SHIFT+M OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY SHIFT+M  ACTION &ACCION
         ELSE
            ON KEY SHIFT+M OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_SHIFT_N"
      IF ACCION = NIL
         RELEASE KEY SHIFT+N OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY SHIFT+N  ACTION &ACCION
         ELSE
            ON KEY SHIFT+N OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_SHIFT_O"
      IF ACCION = NIL
         RELEASE KEY SHIFT+O OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY SHIFT+O  ACTION &ACCION
         ELSE
            ON KEY SHIFT+O OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_SHIFT_P"
      IF ACCION = NIL
         RELEASE KEY SHIFT+P OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY SHIFT+P  ACTION &ACCION
         ELSE
            ON KEY SHIFT+P OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_SHIFT_Q"
      IF ACCION = NIL
         RELEASE KEY SHIFT+Q OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY SHIFT+Q  ACTION &ACCION
         ELSE
            ON KEY SHIFT+Q OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_SHIFT_R"
      IF ACCION = NIL
         RELEASE KEY SHIFT+R OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY SHIFT+R  ACTION &ACCION
         ELSE
            ON KEY SHIFT+R OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_SHIFT_S"
      IF ACCION = NIL
         RELEASE KEY SHIFT+S OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY SHIFT+S  ACTION &ACCION
         ELSE
            ON KEY SHIFT+S OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_SHIFT_T"
      IF ACCION = NIL
         RELEASE KEY SHIFT+T OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY SHIFT+T  ACTION &ACCION
         ELSE
            ON KEY SHIFT+T OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_SHIFT_U"
      IF ACCION = NIL
         RELEASE KEY SHIFT+U OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY SHIFT+U  ACTION &ACCION
         ELSE
            ON KEY SHIFT+U OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_SHIFT_V"
      IF ACCION = NIL
         RELEASE KEY SHIFT+V OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY SHIFT+V  ACTION &ACCION
         ELSE
            ON KEY SHIFT+V OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_SHIFT_W"
      IF ACCION = NIL
         RELEASE KEY SHIFT+W OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY SHIFT+W  ACTION &ACCION
         ELSE
            ON KEY SHIFT+W OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_SHIFT_X"
      IF ACCION = NIL
         RELEASE KEY SHIFT+X OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY SHIFT+X  ACTION &ACCION
         ELSE
            ON KEY SHIFT+X OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_SHIFT_Y"
      IF ACCION = NIL
         RELEASE KEY SHIFT+Y OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY SHIFT+Y  ACTION &ACCION
         ELSE
            ON KEY SHIFT+Y OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_SHIFT_Z"
      IF ACCION = NIL
         RELEASE KEY SHIFT+Z OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY SHIFT+Z  ACTION &ACCION
         ELSE
            ON KEY SHIFT+Z OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_SHIFT_0"
      IF ACCION = NIL
         RELEASE KEY SHIFT+0 OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY SHIFT+0  ACTION &ACCION
         ELSE
            ON KEY SHIFT+0 OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_SHIFT_1"
      IF ACCION = NIL
         RELEASE KEY SHIFT+1 OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY SHIFT+1  ACTION &ACCION
         ELSE
            ON KEY SHIFT+1 OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_SHIFT_2"
      IF ACCION = NIL
         RELEASE KEY SHIFT+2 OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY SHIFT+2  ACTION &ACCION
         ELSE
            ON KEY SHIFT+2 OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_SHIFT_3"
      IF ACCION = NIL
         RELEASE KEY SHIFT+3 OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY SHIFT+3  ACTION &ACCION
         ELSE
            ON KEY SHIFT+3 OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_SHIFT_4"
      IF ACCION = NIL
         RELEASE KEY SHIFT+4 OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY SHIFT+4  ACTION &ACCION
         ELSE
            ON KEY SHIFT+4 OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_SHIFT_5"
      IF ACCION = NIL
         RELEASE KEY SHIFT+5 OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY SHIFT+5  ACTION &ACCION
         ELSE
            ON KEY SHIFT+5 OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_SHIFT_6"
      IF ACCION = NIL
         RELEASE KEY SHIFT+6 OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY SHIFT+6  ACTION &ACCION
         ELSE
            ON KEY SHIFT+6 OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_SHIFT_7"
      IF ACCION = NIL
         RELEASE KEY SHIFT+7 OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY SHIFT+7  ACTION &ACCION
         ELSE
            ON KEY SHIFT+7 OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_SHIFT_8"
      IF ACCION = NIL
         RELEASE KEY SHIFT+8 OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY SHIFT+8  ACTION &ACCION
         ELSE
            ON KEY SHIFT+8 OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_SHIFT_9"
      IF ACCION = NIL
         RELEASE KEY SHIFT+9 OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY SHIFT+9  ACTION &ACCION
         ELSE
            ON KEY SHIFT+9 OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_SHIFT_F1"
      IF ACCION = NIL
         RELEASE KEY SHIFT+F1 OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY SHIFT+F1  ACTION &ACCION
         ELSE
            ON KEY SHIFT+F1 OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_SHIFT_F2"
      IF ACCION = NIL
         RELEASE KEY SHIFT+F2 OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY SHIFT+F2  ACTION &ACCION
         ELSE
            ON KEY SHIFT+F2 OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_SHIFT_F3"
      IF ACCION = NIL
         RELEASE KEY SHIFT+F3 OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY SHIFT+F3  ACTION &ACCION
         ELSE
            ON KEY SHIFT+F3 OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_SHIFT_F4"
      IF ACCION = NIL
         RELEASE KEY SHIFT+F4 OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY SHIFT+F4  ACTION &ACCION
         ELSE
            ON KEY SHIFT+F4 OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_SHIFT_F5"
      IF ACCION = NIL
         RELEASE KEY SHIFT+F5 OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY SHIFT+F5  ACTION &ACCION
         ELSE
            ON KEY SHIFT+F5 OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_SHIFT_F6"
      IF ACCION = NIL
         RELEASE KEY SHIFT+F6 OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY SHIFT+F6  ACTION &ACCION
         ELSE
            ON KEY SHIFT+F6 OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_SHIFT_F7"
      IF ACCION = NIL
         RELEASE KEY SHIFT+F7 OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY SHIFT+F7  ACTION &ACCION
         ELSE
            ON KEY SHIFT+F7 OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_SHIFT_F8"
      IF ACCION = NIL
         RELEASE KEY SHIFT+F8 OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY SHIFT+F8  ACTION &ACCION
         ELSE
            ON KEY SHIFT+F8 OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_SHIFT_F9"
      IF ACCION = NIL
         RELEASE KEY SHIFT+F9 OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY SHIFT+F9  ACTION &ACCION
         ELSE
            ON KEY SHIFT+F9 OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_SHIFT_F10"
      IF ACCION = NIL
         RELEASE KEY SHIFT+F10 OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY SHIFT+F10  ACTION &ACCION
         ELSE
            ON KEY SHIFT+F10 OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_SHIFT_F11"
      IF ACCION = NIL
         RELEASE KEY SHIFT+F11 OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY SHIFT+F11  ACTION &ACCION
         ELSE
            ON KEY SHIFT+F11 OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_SHIFT_F12"
      IF ACCION = NIL
         RELEASE KEY SHIFT+F12 OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY SHIFT+F12  ACTION &ACCION
         ELSE
            ON KEY SHIFT+F12 OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_SHIFT_BS"
      IF ACCION = NIL
         RELEASE KEY SHIFT+BACK OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY SHIFT+BACK  ACTION &ACCION
         ELSE
            ON KEY SHIFT+BACK OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_SHIFT_TAB"
      IF ACCION = NIL
         RELEASE KEY SHIFT+TAB OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY SHIFT+TAB  ACTION &ACCION
         ELSE
            ON KEY SHIFT+TAB OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_SHIFT_ENTER"
      IF ACCION = NIL
         RELEASE KEY SHIFT+RETURN OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY SHIFT+RETURN  ACTION &ACCION
         ELSE
            ON KEY SHIFT+RETURN OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_SHIFT_ESC"
      IF ACCION = NIL
         RELEASE KEY SHIFT+ESCAPE OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY SHIFT+ESCAPE  ACTION &ACCION
         ELSE
            ON KEY SHIFT+ESCAPE OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_SHIFT_END"
      IF ACCION = NIL
         RELEASE KEY SHIFT+END OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY SHIFT+END  ACTION &ACCION
         ELSE
            ON KEY SHIFT+END OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_SHIFT_HOME"
      IF ACCION = NIL
         RELEASE KEY SHIFT+HOME OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY SHIFT+HOME  ACTION &ACCION
         ELSE
            ON KEY SHIFT+HOME OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_SHIFT_LEFT"
      IF ACCION = NIL
         RELEASE KEY SHIFT+LEFT OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY SHIFT+LEFT  ACTION &ACCION
         ELSE
            ON KEY SHIFT+LEFT OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_SHIFT_UP"
      IF ACCION = NIL
         RELEASE KEY SHIFT+UP OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY SHIFT+UP  ACTION &ACCION
         ELSE
            ON KEY SHIFT+UP OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_SHIFT_RIGHT"
      IF ACCION = NIL
         RELEASE KEY SHIFT+RIGHT OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY SHIFT+RIGHT  ACTION &ACCION
         ELSE
            ON KEY SHIFT+RIGHT OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_SHIFT_DOWN"
      IF ACCION = NIL
         RELEASE KEY SHIFT+DOWN OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY SHIFT+DOWN  ACTION &ACCION
         ELSE
            ON KEY SHIFT+DOWN OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_SHIFT_INS"
      IF ACCION = NIL
         RELEASE KEY SHIFT+INSERT OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY SHIFT+INSERT  ACTION &ACCION
         ELSE
            ON KEY SHIFT+INSERT OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_SHIFT_DEL"
      IF ACCION = NIL
         RELEASE KEY SHIFT+DELETE OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY SHIFT+DELETE  ACTION &ACCION
         ELSE
            ON KEY SHIFT+DELETE OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
*   CASE TECLA = "K_SHIFT_PRIOR"
*      IF ACCION = NIL
*         RELEASE KEY SHIFT+PRIOR OF &VENTANA
*      ELSE
*         IF VENTANA = NIL
*            ON KEY SHIFT+PRIOR  ACTION &ACCION
*         ELSE
*            ON KEY SHIFT+PRIOR OF &VENTANA ACTION &ACCION
*         ENDIF
*      ENDIF
*   CASE TECLA = "K_SHIFT_NEXT"
*      IF ACCION = NIL
*         RELEASE KEY SHIFT+NEXT OF &VENTANA
*      ELSE
*         IF VENTANA = NIL
*            ON KEY SHIFT+NEXT  ACTION &ACCION
*         ELSE
*            ON KEY SHIFT+NEXT OF &VENTANA ACTION &ACCION
*         ENDIF
*      ENDIF
   CASE TECLA = "K_CTRL_A"
      IF ACCION = NIL
         RELEASE KEY CONTROL+A OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY CONTROL+A  ACTION &ACCION
         ELSE
            ON KEY CONTROL+A OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_CTRL_B"
      IF ACCION = NIL
         RELEASE KEY CONTROL+B OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY CONTROL+B  ACTION &ACCION
         ELSE
            ON KEY CONTROL+B OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_CTRL_C"
      IF ACCION = NIL
         RELEASE KEY CONTROL+C OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY CONTROL+C  ACTION &ACCION
         ELSE
            ON KEY CONTROL+C OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_CTRL_D"
      IF ACCION = NIL
         RELEASE KEY CONTROL+D OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY CONTROL+D  ACTION &ACCION
         ELSE
            ON KEY CONTROL+D OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_CTRL_E"
      IF ACCION = NIL
         RELEASE KEY CONTROL+E OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY CONTROL+E  ACTION &ACCION
         ELSE
            ON KEY CONTROL+E OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_CTRL_F"
      IF ACCION = NIL
         RELEASE KEY CONTROL+F OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY CONTROL+F  ACTION &ACCION
         ELSE
            ON KEY CONTROL+F OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_CTRL_G"
      IF ACCION = NIL
         RELEASE KEY CONTROL+G OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY CONTROL+G  ACTION &ACCION
         ELSE
            ON KEY CONTROL+G OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_CTRL_H"
      IF ACCION = NIL
         RELEASE KEY CONTROL+H OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY CONTROL+H  ACTION &ACCION
         ELSE
            ON KEY CONTROL+H OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_CTRL_I"
      IF ACCION = NIL
         RELEASE KEY CONTROL+I OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY CONTROL+I  ACTION &ACCION
         ELSE
            ON KEY CONTROL+I OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_CTRL_J"
      IF ACCION = NIL
         RELEASE KEY CONTROL+J OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY CONTROL+J  ACTION &ACCION
         ELSE
            ON KEY CONTROL+J OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_CTRL_K"
      IF ACCION = NIL
         RELEASE KEY CONTROL+K OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY CONTROL+K  ACTION &ACCION
         ELSE
            ON KEY CONTROL+K OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_CTRL_L"
      IF ACCION = NIL
         RELEASE KEY CONTROL+L OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY CONTROL+L  ACTION &ACCION
         ELSE
            ON KEY CONTROL+L OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_CTRL_M"
      IF ACCION = NIL
         RELEASE KEY CONTROL+M OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY CONTROL+M  ACTION &ACCION
         ELSE
            ON KEY CONTROL+M OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_CTRL_N"
      IF ACCION = NIL
         RELEASE KEY CONTROL+N OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY CONTROL+N  ACTION &ACCION
         ELSE
            ON KEY CONTROL+N OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_CTRL_O"
      IF ACCION = NIL
         RELEASE KEY CONTROL+O OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY CONTROL+O  ACTION &ACCION
         ELSE
            ON KEY CONTROL+O OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_CTRL_P"
      IF ACCION = NIL
         RELEASE KEY CONTROL+P OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY CONTROL+P  ACTION &ACCION
         ELSE
            ON KEY CONTROL+P OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_CTRL_Q"
      IF ACCION = NIL
         RELEASE KEY CONTROL+Q OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY CONTROL+Q  ACTION &ACCION
         ELSE
            ON KEY CONTROL+Q OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_CTRL_R"
      IF ACCION = NIL
         RELEASE KEY CONTROL+R OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY CONTROL+R  ACTION &ACCION
         ELSE
            ON KEY CONTROL+R OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_CTRL_S"
      IF ACCION = NIL
         RELEASE KEY CONTROL+S OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY CONTROL+S  ACTION &ACCION
         ELSE
            ON KEY CONTROL+S OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_CTRL_T"
      IF ACCION = NIL
         RELEASE KEY CONTROL+T OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY CONTROL+T  ACTION &ACCION
         ELSE
            ON KEY CONTROL+T OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_CTRL_U"
      IF ACCION = NIL
         RELEASE KEY CONTROL+U OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY CONTROL+U  ACTION &ACCION
         ELSE
            ON KEY CONTROL+U OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_CTRL_V"
      IF ACCION = NIL
         RELEASE KEY CONTROL+V OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY CONTROL+V  ACTION &ACCION
         ELSE
            ON KEY CONTROL+V OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_CTRL_W"
      IF ACCION = NIL
         RELEASE KEY CONTROL+W OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY CONTROL+W  ACTION &ACCION
         ELSE
            ON KEY CONTROL+W OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_CTRL_X"
      IF ACCION = NIL
         RELEASE KEY CONTROL+X OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY CONTROL+X  ACTION &ACCION
         ELSE
            ON KEY CONTROL+X OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_CTRL_Y"
      IF ACCION = NIL
         RELEASE KEY CONTROL+Y OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY CONTROL+Y  ACTION &ACCION
         ELSE
            ON KEY CONTROL+Y OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_CTRL_Z"
      IF ACCION = NIL
         RELEASE KEY CONTROL+Z OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY CONTROL+Z  ACTION &ACCION
         ELSE
            ON KEY CONTROL+Z OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_CTRL_0"
      IF ACCION = NIL
         RELEASE KEY CONTROL+0 OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY CONTROL+0  ACTION &ACCION
         ELSE
            ON KEY CONTROL+0 OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_CTRL_1"
      IF ACCION = NIL
         RELEASE KEY CONTROL+1 OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY CONTROL+1  ACTION &ACCION
         ELSE
            ON KEY CONTROL+1 OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_CTRL_2"
      IF ACCION = NIL
         RELEASE KEY CONTROL+2 OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY CONTROL+2  ACTION &ACCION
         ELSE
            ON KEY CONTROL+2 OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_CTRL_3"
      IF ACCION = NIL
         RELEASE KEY CONTROL+3 OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY CONTROL+3  ACTION &ACCION
         ELSE
            ON KEY CONTROL+3 OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_CTRL_4"
      IF ACCION = NIL
         RELEASE KEY CONTROL+4 OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY CONTROL+4  ACTION &ACCION
         ELSE
            ON KEY CONTROL+4 OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_CTRL_5"
      IF ACCION = NIL
         RELEASE KEY CONTROL+5 OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY CONTROL+5  ACTION &ACCION
         ELSE
            ON KEY CONTROL+5 OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_CTRL_6"
      IF ACCION = NIL
         RELEASE KEY CONTROL+6 OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY CONTROL+6  ACTION &ACCION
         ELSE
            ON KEY CONTROL+6 OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_CTRL_7"
      IF ACCION = NIL
         RELEASE KEY CONTROL+7 OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY CONTROL+7  ACTION &ACCION
         ELSE
            ON KEY CONTROL+7 OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_CTRL_8"
      IF ACCION = NIL
         RELEASE KEY CONTROL+8 OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY CONTROL+8  ACTION &ACCION
         ELSE
            ON KEY CONTROL+8 OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_CTRL_9"
      IF ACCION = NIL
         RELEASE KEY CONTROL+9 OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY CONTROL+9  ACTION &ACCION
         ELSE
            ON KEY CONTROL+9 OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_CTRL_F1"
      IF ACCION = NIL
         RELEASE KEY CONTROL+F1 OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY CONTROL+F1  ACTION &ACCION
         ELSE
            ON KEY CONTROL+F1 OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_CTRL_F2"
      IF ACCION = NIL
         RELEASE KEY CONTROL+F2 OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY CONTROL+F2  ACTION &ACCION
         ELSE
            ON KEY CONTROL+F2 OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_CTRL_F3"
      IF ACCION = NIL
         RELEASE KEY CONTROL+F3 OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY CONTROL+F3  ACTION &ACCION
         ELSE
            ON KEY CONTROL+F3 OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_CTRL_F4"
      IF ACCION = NIL
         RELEASE KEY CONTROL+F4 OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY CONTROL+F4  ACTION &ACCION
         ELSE
            ON KEY CONTROL+F4 OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_CTRL_F5"
      IF ACCION = NIL
         RELEASE KEY CONTROL+F5 OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY CONTROL+F5  ACTION &ACCION
         ELSE
            ON KEY CONTROL+F5 OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_CTRL_F6"
      IF ACCION = NIL
         RELEASE KEY CONTROL+F6 OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY CONTROL+F6  ACTION &ACCION
         ELSE
            ON KEY CONTROL+F6 OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_CTRL_F7"
      IF ACCION = NIL
         RELEASE KEY CONTROL+F7 OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY CONTROL+F7  ACTION &ACCION
         ELSE
            ON KEY CONTROL+F7 OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_CTRL_F8"
      IF ACCION = NIL
         RELEASE KEY CONTROL+F8 OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY CONTROL+F8  ACTION &ACCION
         ELSE
            ON KEY CONTROL+F8 OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_CTRL_F9"
      IF ACCION = NIL
         RELEASE KEY CONTROL+F9 OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY CONTROL+F9  ACTION &ACCION
         ELSE
            ON KEY CONTROL+F9 OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_CTRL_F10"
      IF ACCION = NIL
         RELEASE KEY CONTROL+F10 OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY CONTROL+F10  ACTION &ACCION
         ELSE
            ON KEY CONTROL+F10 OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_CTRL_F11"
      IF ACCION = NIL
         RELEASE KEY CONTROL+F11 OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY CONTROL+F11  ACTION &ACCION
         ELSE
            ON KEY CONTROL+F11 OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_CTRL_F12"
      IF ACCION = NIL
         RELEASE KEY CONTROL+F12 OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY CONTROL+F12  ACTION &ACCION
         ELSE
            ON KEY CONTROL+F12 OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_CTRL_BS"
      IF ACCION = NIL
         RELEASE KEY CONTROL+BACK OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY CONTROL+BACK  ACTION &ACCION
         ELSE
            ON KEY CONTROL+BACK OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_CTRL_TAB"
      IF ACCION = NIL
         RELEASE KEY CONTROL+TAB OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY CONTROL+TAB  ACTION &ACCION
         ELSE
            ON KEY CONTROL+TAB OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_CTRL_ENTER"
      IF ACCION = NIL
         RELEASE KEY CONTROL+RETURN OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY CONTROL+RETURN  ACTION &ACCION
         ELSE
            ON KEY CONTROL+RETURN OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_CTRL_ESC"
      IF ACCION = NIL
         RELEASE KEY CONTROL+ESCAPE OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY CONTROL+ESCAPE  ACTION &ACCION
         ELSE
            ON KEY CONTROL+ESCAPE OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_CTRL_END"
      IF ACCION = NIL
         RELEASE KEY CONTROL+END OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY CONTROL+END  ACTION &ACCION
         ELSE
            ON KEY CONTROL+END OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_CTRL_HOME"
      IF ACCION = NIL
         RELEASE KEY CONTROL+HOME OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY CONTROL+HOME  ACTION &ACCION
         ELSE
            ON KEY CONTROL+HOME OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_CTRL_LEFT"
      IF ACCION = NIL
         RELEASE KEY CONTROL+LEFT OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY CONTROL+LEFT  ACTION &ACCION
         ELSE
            ON KEY CONTROL+LEFT OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_CTRL_UP"
      IF ACCION = NIL
         RELEASE KEY CONTROL+UP OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY CONTROL+UP  ACTION &ACCION
         ELSE
            ON KEY CONTROL+UP OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_CTRL_RIGHT"
      IF ACCION = NIL
         RELEASE KEY CONTROL+RIGHT OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY CONTROL+RIGHT  ACTION &ACCION
         ELSE
            ON KEY CONTROL+RIGHT OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_CTRL_DOWN"
      IF ACCION = NIL
         RELEASE KEY CONTROL+DOWN OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY CONTROL+DOWN  ACTION &ACCION
         ELSE
            ON KEY CONTROL+DOWN OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_CTRL_INS"
      IF ACCION = NIL
         RELEASE KEY CONTROL+INSERT OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY CONTROL+INSERT  ACTION &ACCION
         ELSE
            ON KEY CONTROL+INSERT OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
   CASE TECLA = "K_CTRL_DEL"
      IF ACCION = NIL
         RELEASE KEY CONTROL+DELETE OF &VENTANA
      ELSE
         IF VENTANA = NIL
            ON KEY CONTROL+DELETE  ACTION &ACCION
         ELSE
            ON KEY CONTROL+DELETE OF &VENTANA ACTION &ACCION
         ENDIF
      ENDIF
*   CASE TECLA = "K_CTRL_PRIOR"
*      IF ACCION = NIL
*         RELEASE KEY CONTROL+PRIOR OF &VENTANA
*      ELSE
*         IF VENTANA = NIL
*            ON KEY CONTROL+PRIOR  ACTION &ACCION
*         ELSE
*            ON KEY CONTROL+PRIOR OF &VENTANA ACTION &ACCION
*         ENDIF
*      ENDIF
*   CASE TECLA = "K_CTRL_NEXT"
*      IF ACCION = NIL
*         RELEASE KEY CONTROL+NEXT OF &VENTANA
*      ELSE
*         IF VENTANA = NIL
*            ON KEY CONTROL+NEXT  ACTION &ACCION
*         ELSE
*            ON KEY CONTROL+NEXT OF &VENTANA ACTION &ACCION
*         ENDIF
*      ENDIF
   OTHERWISE
      US_LOG("TECLA NO CONTEMPLADA EN US_SETKEY(), VALOR RECIBIDO: "+US_VarToStr(TECLA),.T.)
ENDCASE
RETURN

/*
 * 0=LETRAS Y NUMEROS   1=LETRAS    2=NUMEROS
 ***
FUNCTION US_SETALLKEY(TIPO,VENTANA,ACCION,VARIABLE)
IF TIPO = NIL
   TIPO = 0
ENDIF
DO CASE
   CASE TIPO = 0
      US_SETALLKEY(1,VENTANA,ACCION,VARIABLE)
      US_SETALLKEY(2,VENTANA,ACCION,VARIABLE)
   CASE TIPO = 1
      US_SETKEY("K_A",VENTANA,"USASETALLKEY('"+VARIABLE+"',IIF(IsCapsLockActive(),'A',LOWER('A')),'"+ACCION+"')")
      US_SETKEY("K_B",VENTANA,"USASETALLKEY('"+VARIABLE+"',IIF(IsCapsLockActive(),'B',LOWER('B')),'"+ACCION+"')")
      US_SETKEY("K_C",VENTANA,"USASETALLKEY('"+VARIABLE+"',IIF(IsCapsLockActive(),'C',LOWER('C')),'"+ACCION+"')")
      US_SETKEY("K_D",VENTANA,"USASETALLKEY('"+VARIABLE+"',IIF(IsCapsLockActive(),'D',LOWER('D')),'"+ACCION+"')")
      US_SETKEY("K_E",VENTANA,"USASETALLKEY('"+VARIABLE+"',IIF(IsCapsLockActive(),'E',LOWER('E')),'"+ACCION+"')")
      US_SETKEY("K_F",VENTANA,"USASETALLKEY('"+VARIABLE+"',IIF(IsCapsLockActive(),'F',LOWER('F')),'"+ACCION+"')")
      US_SETKEY("K_G",VENTANA,"USASETALLKEY('"+VARIABLE+"',IIF(IsCapsLockActive(),'G',LOWER('G')),'"+ACCION+"')")
      US_SETKEY("K_H",VENTANA,"USASETALLKEY('"+VARIABLE+"',IIF(IsCapsLockActive(),'H',LOWER('H')),'"+ACCION+"')")
      US_SETKEY("K_I",VENTANA,"USASETALLKEY('"+VARIABLE+"',IIF(IsCapsLockActive(),'I',LOWER('I')),'"+ACCION+"')")
      US_SETKEY("K_J",VENTANA,"USASETALLKEY('"+VARIABLE+"',IIF(IsCapsLockActive(),'J',LOWER('J')),'"+ACCION+"')")
      US_SETKEY("K_K",VENTANA,"USASETALLKEY('"+VARIABLE+"',IIF(IsCapsLockActive(),'K',LOWER('K')),'"+ACCION+"')")
      US_SETKEY("K_L",VENTANA,"USASETALLKEY('"+VARIABLE+"',IIF(IsCapsLockActive(),'L',LOWER('L')),'"+ACCION+"')")
      US_SETKEY("K_M",VENTANA,"USASETALLKEY('"+VARIABLE+"',IIF(IsCapsLockActive(),'M',LOWER('M')),'"+ACCION+"')")
      US_SETKEY("K_N",VENTANA,"USASETALLKEY('"+VARIABLE+"',IIF(IsCapsLockActive(),'N',LOWER('N')),'"+ACCION+"')")
      US_SETKEY("K_O",VENTANA,"USASETALLKEY('"+VARIABLE+"',IIF(IsCapsLockActive(),'O',LOWER('O')),'"+ACCION+"')")
      US_SETKEY("K_P",VENTANA,"USASETALLKEY('"+VARIABLE+"',IIF(IsCapsLockActive(),'P',LOWER('P')),'"+ACCION+"')")
      US_SETKEY("K_Q",VENTANA,"USASETALLKEY('"+VARIABLE+"',IIF(IsCapsLockActive(),'Q',LOWER('Q')),'"+ACCION+"')")
      US_SETKEY("K_R",VENTANA,"USASETALLKEY('"+VARIABLE+"',IIF(IsCapsLockActive(),'R',LOWER('R')),'"+ACCION+"')")
      US_SETKEY("K_S",VENTANA,"USASETALLKEY('"+VARIABLE+"',IIF(IsCapsLockActive(),'S',LOWER('S')),'"+ACCION+"')")
      US_SETKEY("K_T",VENTANA,"USASETALLKEY('"+VARIABLE+"',IIF(IsCapsLockActive(),'T',LOWER('T')),'"+ACCION+"')")
      US_SETKEY("K_U",VENTANA,"USASETALLKEY('"+VARIABLE+"',IIF(IsCapsLockActive(),'U',LOWER('U')),'"+ACCION+"')")
      US_SETKEY("K_V",VENTANA,"USASETALLKEY('"+VARIABLE+"',IIF(IsCapsLockActive(),'V',LOWER('V')),'"+ACCION+"')")
      US_SETKEY("K_W",VENTANA,"USASETALLKEY('"+VARIABLE+"',IIF(IsCapsLockActive(),'W',LOWER('W')),'"+ACCION+"')")
      US_SETKEY("K_X",VENTANA,"USASETALLKEY('"+VARIABLE+"',IIF(IsCapsLockActive(),'X',LOWER('X')),'"+ACCION+"')")
      US_SETKEY("K_Y",VENTANA,"USASETALLKEY('"+VARIABLE+"',IIF(IsCapsLockActive(),'Y',LOWER('Y')),'"+ACCION+"')")
      US_SETKEY("K_Z",VENTANA,"USASETALLKEY('"+VARIABLE+"',IIF(IsCapsLockActive(),'Z',LOWER('Z')),'"+ACCION+"')")
      US_SETKEY("K_SHIFT_A",VENTANA,"USASETALLKEY('"+VARIABLE+"','A','"+ACCION+"')")
      US_SETKEY("K_SHIFT_B",VENTANA,"USASETALLKEY('"+VARIABLE+"','B','"+ACCION+"')")
      US_SETKEY("K_SHIFT_C",VENTANA,"USASETALLKEY('"+VARIABLE+"','C','"+ACCION+"')")
      US_SETKEY("K_SHIFT_D",VENTANA,"USASETALLKEY('"+VARIABLE+"','D','"+ACCION+"')")
      US_SETKEY("K_SHIFT_E",VENTANA,"USASETALLKEY('"+VARIABLE+"','E','"+ACCION+"')")
      US_SETKEY("K_SHIFT_F",VENTANA,"USASETALLKEY('"+VARIABLE+"','F','"+ACCION+"')")
      US_SETKEY("K_SHIFT_G",VENTANA,"USASETALLKEY('"+VARIABLE+"','G','"+ACCION+"')")
      US_SETKEY("K_SHIFT_H",VENTANA,"USASETALLKEY('"+VARIABLE+"','H','"+ACCION+"')")
      US_SETKEY("K_SHIFT_I",VENTANA,"USASETALLKEY('"+VARIABLE+"','I','"+ACCION+"')")
      US_SETKEY("K_SHIFT_J",VENTANA,"USASETALLKEY('"+VARIABLE+"','J','"+ACCION+"')")
      US_SETKEY("K_SHIFT_K",VENTANA,"USASETALLKEY('"+VARIABLE+"','K','"+ACCION+"')")
      US_SETKEY("K_SHIFT_L",VENTANA,"USASETALLKEY('"+VARIABLE+"','L','"+ACCION+"')")
      US_SETKEY("K_SHIFT_M",VENTANA,"USASETALLKEY('"+VARIABLE+"','M','"+ACCION+"')")
      US_SETKEY("K_SHIFT_N",VENTANA,"USASETALLKEY('"+VARIABLE+"','N','"+ACCION+"')")
      US_SETKEY("K_SHIFT_O",VENTANA,"USASETALLKEY('"+VARIABLE+"','O','"+ACCION+"')")
      US_SETKEY("K_SHIFT_P",VENTANA,"USASETALLKEY('"+VARIABLE+"','P','"+ACCION+"')")
      US_SETKEY("K_SHIFT_Q",VENTANA,"USASETALLKEY('"+VARIABLE+"','Q','"+ACCION+"')")
      US_SETKEY("K_SHIFT_R",VENTANA,"USASETALLKEY('"+VARIABLE+"','R','"+ACCION+"')")
      US_SETKEY("K_SHIFT_S",VENTANA,"USASETALLKEY('"+VARIABLE+"','S','"+ACCION+"')")
      US_SETKEY("K_SHIFT_T",VENTANA,"USASETALLKEY('"+VARIABLE+"','T','"+ACCION+"')")
      US_SETKEY("K_SHIFT_U",VENTANA,"USASETALLKEY('"+VARIABLE+"','U','"+ACCION+"')")
      US_SETKEY("K_SHIFT_V",VENTANA,"USASETALLKEY('"+VARIABLE+"','V','"+ACCION+"')")
      US_SETKEY("K_SHIFT_W",VENTANA,"USASETALLKEY('"+VARIABLE+"','W','"+ACCION+"')")
      US_SETKEY("K_SHIFT_X",VENTANA,"USASETALLKEY('"+VARIABLE+"','X','"+ACCION+"')")
      US_SETKEY("K_SHIFT_Y",VENTANA,"USASETALLKEY('"+VARIABLE+"','Y','"+ACCION+"')")
      US_SETKEY("K_SHIFT_Z",VENTANA,"USASETALLKEY('"+VARIABLE+"','Z','"+ACCION+"')")
   CASE TIPO = 2
      US_SETKEY("K_0",VENTANA,"USASETALLKEY('"+VARIABLE+"','0','"+ACCION+"')")
      US_SETKEY("K_1",VENTANA,"USASETALLKEY('"+VARIABLE+"','1','"+ACCION+"')")
      US_SETKEY("K_2",VENTANA,"USASETALLKEY('"+VARIABLE+"','2','"+ACCION+"')")
      US_SETKEY("K_3",VENTANA,"USASETALLKEY('"+VARIABLE+"','3','"+ACCION+"')")
      US_SETKEY("K_4",VENTANA,"USASETALLKEY('"+VARIABLE+"','4','"+ACCION+"')")
      US_SETKEY("K_5",VENTANA,"USASETALLKEY('"+VARIABLE+"','5','"+ACCION+"')")
      US_SETKEY("K_6",VENTANA,"USASETALLKEY('"+VARIABLE+"','6','"+ACCION+"')")
      US_SETKEY("K_7",VENTANA,"USASETALLKEY('"+VARIABLE+"','7','"+ACCION+"')")
      US_SETKEY("K_8",VENTANA,"USASETALLKEY('"+VARIABLE+"','8','"+ACCION+"')")
      US_SETKEY("K_9",VENTANA,"USASETALLKEY('"+VARIABLE+"','9','"+ACCION+"')")
   OTHERWISE
      US_LOG("TIPO NO CONTEMPLADA EN US_SETALLKEY(), VALOR RECIBIDO: "+US_VarToStr(TIPO)+".  Valores aceptados: 0 para Letras y Numeros, 1 para Letras solas y 2 para Numeros solos",.T.)
ENDCASE
RETURN
FUNCTION USASETALLKEY(VAR,CARACTER,ACCION)
LOCAL R
*US_LOG("VAR: "+VAR)
*US_LOG("CAR: "+CARACTER)
*US_LOG("ACC: "+US_VarToStr(ACCION))
&(VAR+":='"+CARACTER+"'")
R=&ACCION
RETURN

/*
 * 0=LETRAS Y NUMEROS   1=LETRAS    2=NUMEROS
 ***
FUNCTION US_RELALLKEY(TIPO,VENTANA)
IF TIPO = NIL
   TIPO = 0
ENDIF
DO CASE
   CASE TIPO = 0
      US_RELALLKEY(1,VENTANA)
      US_RELALLKEY(2,VENTANA)
   CASE TIPO = 1
      US_SETKEY("K_A",VENTANA)
      US_SETKEY("K_B",VENTANA)
      US_SETKEY("K_C",VENTANA)
      US_SETKEY("K_D",VENTANA)
      US_SETKEY("K_E",VENTANA)
      US_SETKEY("K_F",VENTANA)
      US_SETKEY("K_G",VENTANA)
      US_SETKEY("K_H",VENTANA)
      US_SETKEY("K_I",VENTANA)
      US_SETKEY("K_J",VENTANA)
      US_SETKEY("K_K",VENTANA)
      US_SETKEY("K_L",VENTANA)
      US_SETKEY("K_M",VENTANA)
      US_SETKEY("K_N",VENTANA)
      US_SETKEY("K_O",VENTANA)
      US_SETKEY("K_P",VENTANA)
      US_SETKEY("K_Q",VENTANA)
      US_SETKEY("K_R",VENTANA)
      US_SETKEY("K_S",VENTANA)
      US_SETKEY("K_T",VENTANA)
      US_SETKEY("K_U",VENTANA)
      US_SETKEY("K_V",VENTANA)
      US_SETKEY("K_W",VENTANA)
      US_SETKEY("K_X",VENTANA)
      US_SETKEY("K_Y",VENTANA)
      US_SETKEY("K_Z",VENTANA)
      US_SETKEY("K_SHIFT_A",VENTANA)
      US_SETKEY("K_SHIFT_B",VENTANA)
      US_SETKEY("K_SHIFT_C",VENTANA)
      US_SETKEY("K_SHIFT_D",VENTANA)
      US_SETKEY("K_SHIFT_E",VENTANA)
      US_SETKEY("K_SHIFT_F",VENTANA)
      US_SETKEY("K_SHIFT_G",VENTANA)
      US_SETKEY("K_SHIFT_H",VENTANA)
      US_SETKEY("K_SHIFT_I",VENTANA)
      US_SETKEY("K_SHIFT_J",VENTANA)
      US_SETKEY("K_SHIFT_K",VENTANA)
      US_SETKEY("K_SHIFT_L",VENTANA)
      US_SETKEY("K_SHIFT_M",VENTANA)
      US_SETKEY("K_SHIFT_N",VENTANA)
      US_SETKEY("K_SHIFT_O",VENTANA)
      US_SETKEY("K_SHIFT_P",VENTANA)
      US_SETKEY("K_SHIFT_Q",VENTANA)
      US_SETKEY("K_SHIFT_R",VENTANA)
      US_SETKEY("K_SHIFT_S",VENTANA)
      US_SETKEY("K_SHIFT_T",VENTANA)
      US_SETKEY("K_SHIFT_U",VENTANA)
      US_SETKEY("K_SHIFT_V",VENTANA)
      US_SETKEY("K_SHIFT_W",VENTANA)
      US_SETKEY("K_SHIFT_X",VENTANA)
      US_SETKEY("K_SHIFT_Y",VENTANA)
      US_SETKEY("K_SHIFT_Z",VENTANA)
   CASE TIPO = 2
      US_SETKEY("K_0",VENTANA)
      US_SETKEY("K_1",VENTANA)
      US_SETKEY("K_2",VENTANA)
      US_SETKEY("K_3",VENTANA)
      US_SETKEY("K_4",VENTANA)
      US_SETKEY("K_5",VENTANA)
      US_SETKEY("K_6",VENTANA)
      US_SETKEY("K_7",VENTANA)
      US_SETKEY("K_8",VENTANA)
      US_SETKEY("K_9",VENTANA)
   OTHERWISE
      US_LOG("TIPO NO CONTEMPLADA EN US_RELALLKEY(), VALOR RECIBIDO: "+US_VarToStr(TIPO)+".  Valores aceptados: 0 para Letras y Numeros, 1 para Letras solas y 2 para Numeros solos",.T.)
ENDCASE
RETURN
*/

FUNCTION US_MGMenu(W_TOP,W_LEFT,W_BOTTOM,W_RIGHT,VECTOR,VECTORBOOL,USERFUNC)
   Local W_COLS, W_FILS
   Local Ventana:="US_PM"+ALLTRIM(STR(DAY(DATE())))+ALLTRIM(STR(INT(SECONDS())))
   Local Opcion:=0

   Empty(VECTORBOOL)
   Empty(USERFUNC)

   W_COLS:=W_RIGHT-W_LEFT
   W_FILS:=W_BOTTOM-W_TOP

   // WIDTH US_Cols(W_COLS*0.8) ;
   // HEIGHT US_Fils(W_FILS*2) ;
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

/*
FUNCTION US_IsEscDefined(Ventana)
   LOCAL bContenido:=NIL
   STORE KEY ESCAPE OF &(Ventana) TO bContenido
   IF bContenido != NIL
      RETURN .T.
   ENDIF
RETURN .F.

Function _DefaultMenuItem( ItemNumber, ItemName, FormName )
   Local i , h
   i := GetControlIndex( ItemName, FormName )
   h := _HMG_aControlpageMap[ i ]
   SetMenuDefaultItem( h, ItemNumber )
Return
*/

#define EM_SETSEL   177

Function US_Send_SelectAll(ControlName,Ventana)
   Local c := GetControlHandle (ControlName,Ventana)
   SendMessage( c , EM_SETSEL , 0 , -1 )
Return NIL

/*
Function US_SendMail(nModo, nIdioma, cRetoMsg, cTitulo, cTexto, cOrigName, cOrigAddress, cDestName, cDestAddress, cDestNameCC, cDestAddressCC, cAttachFile)
   Local rta:=0
   do case
      case nModo=0    // SMTP
         rta:=(-1)
         do case
            case nIdioma = 0
               cRetoMsg := "US_SendMail con protocolo SMTP no esta implementado"
            case nIdioma = 1
               cRetoMsg := "US_SendMail with SMTP protocol,  not implemented"
         endcase
      case nModo=1    // MAPI with Confirm
         rta:=US_MAPISendMail(0, cTitulo, cTexto, cOrigName, cOrigAddress, cDestName, cDestAddress, cDestNameCC, cDestAddressCC, cAttachFile, 8)
      case nModo=2    // MAPI withOUT Confirm
         rta:=US_MAPISendMail(0, cTitulo, cTexto, cOrigName, cOrigAddress, cDestName, cDestAddress, cDestNameCC, cDestAddressCC, cAttachFile, 0)
      otherwise
         rta:=(-2)
         do case
            case nIdioma = 0
               cRetoMsg := "US_SendMail: modo de envio invalido: "+alltrim(str(nModo))
            case nIdioma = 1
               cRetoMsg := "US_SendMail: invalid send method: "+alltrim(str(nModo))
         endcase
   endcase
   do case
      case rta=0
         cRetoMsg:="US_SendMail NOTIFY: Modo: MAPI, RC: 0 (SUCCESS)"
      case rta=1
         cRetoMsg:="US_SendMail WARNING: Modo: MAPI, RC: 1 (USER_ABORT)"
      case rta=2
         cRetoMsg:="US_SendMail ERROR: Modo: MAPI, RC: 2 (FAILURE)"
      case rta=3
         cRetoMsg:="US_SendMail ERROR: Modo: MAPI, RC: 3 (LOGON_FAILURE)"
      case rta=4
         cRetoMsg:="US_SendMail ERROR: Modo: MAPI, RC: 4 (DISK_FULL)"
      case rta=5
         cRetoMsg:="US_SendMail ERROR: Modo: MAPI, RC: 5 (INSUFFICIENT_MEMORY)"
      case rta=6
         cRetoMsg:="US_SendMail ERROR: Modo: MAPI, RC: 6 (ACCESS_DENIED)"
      case rta=8
         cRetoMsg:="US_SendMail ERROR: Modo: MAPI, RC: 8 (TOO_MANY_SESSIONS)"
      case rta=9
         cRetoMsg:="US_SendMail ERROR: Modo: MAPI, RC: 9 (TOO_MANY_FILES)"
      case rta=10
         cRetoMsg:="US_SendMail ERROR: Modo: MAPI, RC: 10 (TOO_MANY_RECIPIENTS)"
      case rta=11
         cRetoMsg:="US_SendMail ERROR: Modo: MAPI, RC: 11 (ATTACHMENT_NOT_FOUND)"
      case rta=12
         cRetoMsg:="US_SendMail ERROR: Modo: MAPI, RC: 12 (ATTACHMENT_OPEN_FAILURE)"
      case rta=13
         cRetoMsg:="US_SendMail ERROR: Modo: MAPI, RC: 13 (ATTACHMENT_WRITE_FAILURE)"
      case rta=14
         cRetoMsg:="US_SendMail ERROR: Modo: MAPI, RC: 14 (UNKNOWN_RECIPIENT)"
      case rta=15
         cRetoMsg:="US_SendMail ERROR: Modo: MAPI, RC: 15 (BAD_RECIPTYPE)"
      case rta=16
         cRetoMsg:="US_SendMail ERROR: Modo: MAPI, RC: 16 (NO_MESSAGES)"
      case rta=17
         cRetoMsg:="US_SendMail ERROR: Modo: MAPI, RC: 17 (INVALID_MESSAGE)"
      case rta=18
         cRetoMsg:="US_SendMail ERROR: Modo: MAPI, RC: 18 (TEXT_TOO_LARGE)"
      case rta=19
         cRetoMsg:="US_SendMail ERROR: Modo: MAPI, RC: 19 (INVALID_SESSION)"
      case rta=20
         cRetoMsg:="US_SendMail ERROR: Modo: MAPI, RC: 20 (TYPE_NOT_SUPPORTED)"
      case rta=21
         cRetoMsg:="US_SendMail ERROR: Modo: MAPI, RC: 21 (AMBIGUOUS_RECIPIENT)"
      case rta=22
         cRetoMsg:="US_SendMail ERROR: Modo: MAPI, RC: 22 (MESSAGE_IN_USE)"
      case rta=23
         cRetoMsg:="US_SendMail ERROR: Modo: MAPI, RC: 23 (NETWORK_FAILURE)"
      case rta=24
         cRetoMsg:="US_SendMail ERROR: Modo: MAPI, RC: 24 (INVALID_EDITFIELDS)"
      case rta=25
         cRetoMsg:="US_SendMail ERROR: Modo: MAPI, RC: 25 (INVALID_RECIPS)"
      case rta=26
         cRetoMsg:="US_SendMail ERROR: Modo: MAPI, RC: 26 (NOT_SUPPORTED)"
      case rta=101
         cRetoMsg:="US_SendMail ERROR: Modo: MAPI, Unable to load library MAPI32.DLL"
      case rta=102
         cRetoMsg:="US_SendMail ERROR: Modo: MAPI, Function MAPILogon not found in library MAPI32.DLL"
      case rta=103
         cRetoMsg:="US_SendMail ERROR: Modo: MAPI, Function MAPISendMail not found in library MAPI32.DLL"
      case rta=104
         cRetoMsg:="US_SendMail ERROR: Modo: MAPI, Function MAPILogoff not found in library MAPI32.DLL"
      case rta=105
         cRetoMsg:="US_SendMail ERROR: Modo: MAPI, Unable to Logon into Default eMail Client"
      case rta=108
         cRetoMsg:="US_SendMail ERROR: Modo: MAPI, invalid parameter for preview: "+alltrim(str(nPreview))
      otherwise
         cRetoMsg:="US_SendMail ERROR: Modo: MAPI, RC: "+alltrim(str(rta))+" (UNKNOWN ERROR)"
   endcase
return rta

#pragma BEGINDUMP

#include <windows.h>
#include <stdio.h>
#include <mapi.h>
#ifndef __MINGW32__
#include <mapix.h>
#endif

HINSTANCE      hMAPILib = 0;
LHANDLE        hSession = 0;
LPMAPILOGON    pMAPILogon = NULL;
LPMAPILOGOFF   pMAPILogoff = NULL;
LPMAPISENDMAIL pMAPISendMail = NULL;

MapiRecipDesc orig;

// http://www.dorn.org/uni/mapi/simple.html
MapiRecipDesc rcpt[2];    // this message needs two recipients.

MapiFileDesc  file;
MapiMessage   mssg;

HB_FUNC ( US_MAPISENDMAIL )
{
    int nModoDialog = hb_parni( 11 );

    orig.ulReserved         = 0;                                  // Reserved
    orig.ulRecipClass       = MAPI_ORIG;                          // Reciepient Class MAPI_TO MAPI_CC MAPI_BCC
    orig.lpszName           = (LPSTR) hb_parc( 4 );               // Originator's Name
    orig.lpszAddress        = (LPSTR) hb_parc( 5 );               // Originators Address
    orig.ulEIDSize          = 0;                                  // Count in bytes of size of pEntryID
    orig.lpEntryID          = 0;                                  // System-specific Originator reference

    rcpt[0].ulReserved         = 0;                               // Reserved
    rcpt[0].ulRecipClass       = MAPI_TO;                         // Reciepient Class MAPI_TO MAPI_CC MAPI_BCC
    rcpt[0].lpszName           = (LPSTR) hb_parc( 6 );            // Reciepient's Name, e.g., vouchcac@hotmail.com
    rcpt[0].lpszAddress        = (LPSTR) hb_parc( 7 );            // Reciepient's Address
    rcpt[0].ulEIDSize          = 0;                               // Count in bytes of size of pEntryID
    rcpt[0].lpEntryID          = 0;                               // System-specific Recipient reference

    rcpt[1].ulReserved         = 0;                               // Reserved
    rcpt[1].ulRecipClass       = MAPI_CC;                         // Reciepient Class MAPI_TO MAPI_CC MAPI_BCC
    rcpt[1].lpszName           = (LPSTR) hb_parc( 8 );            // Reciepient's Name, e.g., vouchcac@hotmail.com
    rcpt[1].lpszAddress        = (LPSTR) hb_parc( 9 );            // Reciepient's Address
    rcpt[1].ulEIDSize          = 0;                               // Count in bytes of size of pEntryID
    rcpt[1].lpEntryID          = 0;                               // System-specific Recipient reference

    file.ulReserved         = 0;                                  // Reserved for future usage
    file.flFlags            = 0;                                  // Flags ?
    file.nPosition          = -1;                                 // Character of text to be replaced by attachment
    file.lpszPathName       = (LPSTR) hb_parc( 10 );              // Full Path Name with Extension of the attached file
    file.lpszFileName       = 0;                                  // Original File Name ( optional )
    file.lpFileType         = 0;                                  // Attachment file type ( can be lpMapiFileTagExt )

    mssg.ulReserved         = 0;                                  // Reserved
    mssg.lpszSubject        = (LPSTR) hb_parc( 2 );               // Message Subject
    mssg.lpszNoteText       = (LPSTR) hb_parc( 3 );               // Message Text
    mssg.lpszMessageType    = 0;                                  // Message Class
    mssg.lpszDateReceived   = 0;                                  // in yyyy/mm/dd hh:mm format
    mssg.lpszConversationID = 0;                                  // Conversation thread ID
    mssg.flFlags            = MAPI_LOGON_UI | MAPI_NEW_SESSION;   // unread, return receipt
    mssg.lpOriginator       = (lpMapiRecipDesc) &orig;            // Originator's descriptor
    mssg.nRecipCount        = 1;                                  // Number of receipients
    mssg.lpRecips           = (lpMapiRecipDesc) &rcpt;            // Recipient descriptors
    mssg.nFileCount         = 1;                                  // Number of file attachments
    mssg.lpFiles            = (lpMapiFileDesc) &file;             // Attachment descriptors

    // Load the DLL at runtime
#ifdef __MINGW32__
    hMAPILib = LoadLibrary("MAPI32.DLL");
#else
    hMAPILib = ::LoadLibrary("MAPI32.DLL");
#endif

    if (!hMAPILib)
       {
        hb_retnl( 101 );   // failed
        return;
       }

    pMAPILogon = (LPMAPILOGON) GetProcAddress (hMAPILib, "MAPILogon");
    if (! pMAPILogon)
       {
        hb_retnl( 102 );   // failed
        return;
       }

    pMAPISendMail = (LPMAPISENDMAIL) GetProcAddress (hMAPILib, "MAPISendMail");
    if (! pMAPISendMail)
       {
        hb_retnl( 103 );   // failed
        return;
       }

    pMAPILogoff = (LPMAPILOGOFF) GetProcAddress (hMAPILib, "MAPILogoff");
    if (! pMAPILogoff)
       {
        hb_retnl( 104 );   // failed
        return;
       }

    // logon
    if (pMAPILogon(0, NULL, NULL, MAPI_LOGON_UI | MAPI_NEW_SESSION, 0, &hSession) != SUCCESS_SUCCESS)
       {
        hb_retnl( 105 );    // Logon failed
        return;
       }

    // Send email using the MAPISendMail API function
    if (nModoDialog == 0)
       {
        hb_retnl (pMAPISendMail(hSession, 0, &mssg, 0, 0)) ;
       }
    else
       {
        if (nModoDialog == 8)
           {
            hb_retnl (pMAPISendMail(hSession, 0, &mssg, MAPI_DIALOG, 0)) ;
           }
        else
           {
            hb_retnl( 108 );    // invalid parameter
           }
       }

    // Logoff session
    pMAPILogoff(hSession, 0, 0, 0) ;

    // Free DLL
#ifdef __MINGW32__
    FreeLibrary(hMAPILib) ;
#else
    ::FreeLibrary(hMAPILib) ;
#endif

    return;
}
// SUCCESS_SUCCESS                      0
// MAPI_USER_ABORT                      1
// MAPI_E_USER_ABORT                    MAPI_USER_ABORT
// MAPI_E_FAILURE                       2
// MAPI_E_LOGON_FAILURE                 3
// MAPI_E_LOGIN_FAILURE                 MAPI_E_LOGON_FAILURE
// MAPI_E_DISK_FULL                     4
// MAPI_E_INSUFFICIENT_MEMORY           5
// MAPI_E_ACCESS_DENIED                 6
// MAPI_E_TOO_MANY_SESSIONS             8
// MAPI_E_TOO_MANY_FILES                9
// MAPI_E_TOO_MANY_RECIPIENTS           10
// MAPI_E_ATTACHMENT_NOT_FOUND          11
// MAPI_E_ATTACHMENT_OPEN_FAILURE       12
// MAPI_E_ATTACHMENT_WRITE_FAILURE      13
// MAPI_E_UNKNOWN_RECIPIENT             14
// MAPI_E_BAD_RECIPTYPE                 15
// MAPI_E_NO_MESSAGES                   16
// MAPI_E_INVALID_MESSAGE               17
// MAPI_E_TEXT_TOO_LARGE                18
// MAPI_E_INVALID_SESSION               19
// MAPI_E_TYPE_NOT_SUPPORTED            20
// MAPI_E_AMBIGUOUS_RECIPIENT           21
// MAPI_E_AMBIG_RECIP                   MAPI_E_AMBIGUOUS_RECIPIENT
// MAPI_E_MESSAGE_IN_USE                22
// MAPI_E_NETWORK_FAILURE               23
// MAPI_E_INVALID_EDITFIELDS            24
// MAPI_E_INVALID_RECIPS                25
// MAPI_E_NOT_SUPPORTED                 26

// The 'Simple MAPI' interface. This interface is not by default available
// on any machine. The easiest way to ensure if Simple MAPI is available is to check
// the registry: the "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows Messaging Subsystem"
// variable "MAPI" should have value "1"

#pragma ENDDUMP

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
//      cValor := "*ERROR*"
      US_Log( "The requested internal function is only executed with Administrator User Atributes, but you user is not Administrator" , .T. , .T. )
   endif
   oReg:Close()
RETURN nValue

/*
Function US_DelRegKey(nKey, cRegKey, cSubKey)
   LOCAL oReg, nValue
   if US_IsNT()
      US_NT_Administrator()
   endif
   oReg := TReg32():New(nKey, cRegKey)
   nValue := oReg:KeyDelete(cSubKey)
   if oReg:lError
      cValor := "*ERROR*"
      US_Log( "The requested internal function is only execute with Administrator User Atributes, but you user is not Administrator" , .T. , .T. )
   endif
   oReg:Close()
RETURN nValue

Function US_DelRegVal(nKey, cRegKey, cValor)
   LOCAL oReg, nValue
   if US_IsNT()
      US_NT_Administrator()
   endif
   oReg := TReg32():New(nKey, cRegKey)
   nValue := oReg:Delete(cValor)
   if oReg:lError
      cValor := "*ERROR*"
      US_Log( "The requested internal function is only execute with Administrator User Atributes, but you user is not Administrator" , .T. , .T. )
   endif
   oReg:Close()
RETURN nValue

#pragma BEGINDUMP

#include <shlobj.h>

// La siguiente Función es llamada dinamicamente cuando se abre el browse de folders y setea el folder inicial
// con el valor de strTmpPath que fue cargado con el parametro 2 (si es que está)

char strTmpPath[MAX_PATH] ;

int CALLBACK BrowseCallbackProc(HWND hwnd, UINT uMsg, LPARAM lParam, LPARAM lpData)
{
TCHAR szDir[MAX_PATH];
switch(uMsg)
   {
   case BFFM_INITIALIZED:
      if (lpData)
         {
         strcpy(szDir, strTmpPath);
         SendMessage(hwnd,BFFM_SETSELECTION,TRUE,(LPARAM)szDir);
         }
      break;
   case BFFM_SELCHANGED:
      {
      if (SHGetPathFromIDList((LPITEMIDLIST) lParam ,szDir))
         {
         SendMessage(hwnd,BFFM_SETSTATUSTEXT,0,(LPARAM)szDir);
         }
      break;
      }
   default:
      break;
   }
return 0;
}

HB_FUNC( US_GETFOLDER ) // Based Upon Code Contributed By Ryszard Ry³ko
{
   HWND hwnd = GetActiveWindow();
   BROWSEINFO bi;
   char *lpBuffer = (char*) hb_xgrab( MAX_PATH+1);
   LPITEMIDLIST pidlBrowse;    // PIDL selected by user

   bi.hwndOwner = hwnd;
   bi.pidlRoot = NULL;
   bi.pszDisplayName = lpBuffer;
   bi.lpszTitle = hb_parc(1);
   bi.ulFlags = 0;
   bi.lpfn = BrowseCallbackProc;
   if (hb_parc(2) == NULL)
      {
      bi.lParam = FALSE ;
      }
   else
      {
      strcpy( strTmpPath , hb_parc(2) );
      bi.lParam = TRUE ;
      }

   // Browse for a folder and return its PIDL.
   pidlBrowse = SHBrowseForFolder(&bi);
   SHGetPathFromIDList(pidlBrowse,lpBuffer);
   hb_retc(lpBuffer);
   hb_xfree( lpBuffer);
}

#pragma ENDDUMP

Function US_MGIndex(cBase, cClave, cNombre, cPack)
   Local bPack:=.F.
   Private Incremento:=1
   if !empty(cPack) .and. upper(cPAck) = "PACK"
      bPack:=.T.
   endif
   DEFINE WINDOW US_MGIndexMenu;
      AT 0,0 ;
      WIDTH 330 HEIGHT 150 ;
      TITLE " Creando Indices ";
      USMODAL;
      ON INIT US_MGIndex_Creacion(cBase, cClave, cNombre, bPack)

      @ 10, 10 LABEL LOpcionPack;
         WIDTH 400 ;
         HEIGHT 20 ;
         VALUE "Opcion PACK: NO";
         FONT "Courier New" SIZE 10 FONTCOLOR BLUE

      @ 30, 10 PROGRESSBAR PProgressIndex ;
         RANGE 0, 100 ;
         WIDTH 300 ;
         HEIGHT 15 ;
         SMOOTH

       @ 50, 10  LABEL LInxNombre;
         WIDTH 100;
         HEIGHT 20 ;
         VALUE 'Indexando';
         FONT "Courier New" SIZE 10 FONTCOLOR BLUE

       @ 50, 100  LABEL TInxNombre;
         WIDTH 100;
         HEIGHT 20 ;
         VALUE STR(0);
         FONT "Courier New" SIZE 10 FONTCOLOR RED

       @ 70, 10  LABEL LRegistro;
         WIDTH 110;
         HEIGHT 20 ;
         VALUE 'Registro N°:';
         FONT "Courier New" SIZE 10 FONTCOLOR RED

      @ 70, 120  LABEL TRegistro;
         WIDTH 100;
         HEIGHT 20 ;
         VALUE STR(0);
         FONT "Courier New" SIZE 10 FONTCOLOR RED

      @ 90, 10  LABEL LPorcentaje;
         WIDTH 120;
         HEIGHT 20 ;
         VALUE 'Generado el ->';
         FONT "Courier New" SIZE 10 FONTCOLOR RED

      @ 90, 120  LABEL TPorcentaje;
         WIDTH 100;
         HEIGHT 20 ;
         VALUE STR(0);
         FONT "Courier New" SIZE 10 FONTCOLOR RED

   END WINDOW
   CENTER WINDOW US_MGIndexMenu
   ACTIVATE WINDOW US_MGIndexMenu
RETURN NIL

FUNCTION US_MGIndex_Creacion(cBase,cClave,cNombre,bPack)
   US_Use(.T. , , cBase, , .F.)  && not shared
   if reccount() < 101
      Incremento:=int(reccount() / 100)
   endif
   if bPack
      US_MGIndexMenu.LOpcionPack.Value:="Opcion PACK: SI"
      PACK
   else
      US_MGIndexMenu.LOpcionPack.Value:="Opcion PACK: NO"
   endif
   index on &cClave to (cNombre) EVAL { || US_MGIndex_IndexMeter(LASTREC(),cNombre)} EVERY Incremento
   dbclosearea(cBase)
   US_MGIndexMenu.release()
RETURN NIL

FUNCTION US_MGIndex_IndexMeter(mTamagno, NombreIndice)
   Local  nCompletado, registro
   registro:=recno()
   nCompletado := INT((registro/mTamagno) * 100)
   US_MGIndexMenu.PProgressIndex.value:=nCompletado
   US_MGIndexMenu.TInxNombre.value:=NombreIndice
   US_MGIndexMenu.TRegistro.value:=str(registro,10)
   US_MGIndexMenu.TPorcentaje.value:=str(nCompletado, 9, 2)+'%'
RETURN(.T.)
*/

/*
 * Type: 0 Reset
 */
Function US_SetWindowRgn(name,col,row,w,h,lx)
   local lhand
   lhand := GetFormHandle( name )
   US_2SetWindowRgn(lhand,col,row,w,h,lx)
Return Nil

/*
#define SW_HIDE             0
#define SW_SHOWNORMAL       1
#define SW_NORMAL           1
#define SW_SHOWMINIMIZED    2
#define SW_SHOWMAXIMIZED    3
#define SW_MAXIMIZE         3
#define SW_SHOWNOACTIVATE   4
#define SW_SHOW             5
#define SW_MINIMIZE         6
#define SW_SHOWMINNOACTIVE  7
#define SW_SHOWNA           8
#define SW_RESTORE          9
#define SW_SHOWDEFAULT      10
#define SW_FORCEMINIMIZE    11
#define SW_MAX              11

#DEFINE ERROR_FILE_NOT_FOUND        2
#DEFINE ERROR_PATH_NOT_FOUND        3
#DEFINE ERROR_BAD_FORMAT           11
#DEFINE SE_ERR_FNF                  2       // FILE NOT FOUND
#DEFINE SE_ERR_PNF                  3       // PATH NOT FOUND
#DEFINE SE_ERR_ACCESSDENIED         5       // ACCESS DENIED
#DEFINE SE_ERR_OOM                  8       // OUT OF MEMORY
#DEFINE SE_ERR_DLLNOTFOUND         32
#DEFINE SE_ERR_SHARE               26
#DEFINE SE_ERR_ASSOCINCOMPLETE     27
#DEFINE SE_ERR_DDETIMEOUT          28
#DEFINE SE_ERR_DDEFAIL             29
#DEFINE SE_ERR_DDEBUSY             30
#DEFINE SE_ERR_NOASSOC             31

Function US_Execute(cFile,cParm)
   Local cExt:=""
   cExt:=substr(cFile,rat(".",cFile)+1)
   do case
      case cExt == "TXT"
         Reto:=ShellExecute( NIL , "open" , "notepad" , cFile , , SW_SHOWNORMAL )
      otherwise
         Reto:=ShellExecute( NIL , "open" , cFile     , cParm , , SW_SHOWNORMAL )
   endcase
   do case
      case Reto > 32    && Succesfull
      case Reto = 0     && The operating system is out of memory or resources.
         MsgInfo("Windows no tiene suficiente memoria para abrir el archivo")
      case Reto = ERROR_FILE_NOT_FOUND      && The specified file was not found.
         MsgInfo("Windows no encuentra el archivo seleccionado")
      case Reto = ERROR_PATH_NOT_FOUND      && The specified path was not found.
         MsgInfo("Windows no encuentra el directorio de la aplicacion seleccionada")
      case Reto = ERROR_BAD_FORMAT          && The .exe file is invalid (non-Microsoft Win32 .exe or error in .exe image).
         MsgInfo("El archivo seleccionado no es un ejecutable vßlido para Windows")
      case Reto = SE_ERR_ACCESSDENIED       && The operating system denied access to the specified file.
         MsgInfo("El sistema operativo nego el acceso al archivo solicitado")
      case Reto = SE_ERR_ASSOCINCOMPLETE    && The file name association is incomplete or invalid.
         MsgInfo("El archivo esta asociado a una aplicacion inválida")
      case Reto = SE_ERR_DDEBUSY            && The Dynamic Data Exchange (DDE) transaction could not be completed because other DDE transactions were being processed.
         MsgInfo("El Dynamic Data Exchange (DDE) no se puede completar porque otra transaccion esta siendo procesada")
      Case Reto = SE_ERR_DDEFAIL            && The DDE transaction failed.
         MsgInfo("El Dynamic Data Exchange (DDE) falló.")
      Case Reto = SE_ERR_DDETIMEOUT         && The DDE transaction could not be completed because the request timed out.
         MsgInfo("El Dynamic Data Exchange (DDE) cancelo por Time Out")
      Case Reto = SE_ERR_DLLNOTFOUND        && The specified dynamic-link library (DLL) was not found.
         MsgInfo("La libreria de llamada Dinamica no fue encontrada")
      Case Reto = SE_ERR_FNF                && The specified file was not found.
         MsgInfo("Windows no encuentra el archivo seleccionado")
      Case Reto = SE_ERR_NOASSOC            && There is no application associated with the given file name extension. This error will also be returned if you attempt to print a file that is not printable.
         MsgInfo("Este tipo de archivo no tiene programa asociado")
      Case Reto = SE_ERR_OOM                && There was not enough memory to complete the operation.
         MsgInfo("Windows no tiene suficiente memoria para satisfascer el requerimiento")
      Case Reto = SE_ERR_PNF                && The specified path was not found.
         MsgInfo("Windows no encuentra el directorio de la aplicacion seleccionada")
      Case Reto = SE_ERR_SHARE              && A sharing violation occurred.
         MsgInfo("Error al interntar compartir el recurso o archivo")
      otherwise
         US_Log("Función "+Procname()+": Error desconocido al intentar ver el Reporte, RC="+US_VarToStr(Reto))
         MsgInfo("Función "+Procname()+": Error desconocido al intentar ver el Reporte, RC="+US_VarToStr(Reto))
   endcase
Return if( Reto > 32 , 0 , -1 )

Function US_WinStackAdd( Vector , Ventana )
   // sexto elemento es el estado de la ventana: NORMAL MINIMIZADA MAXIMIZADA
   // es usado para cuando se restauran todas las ventanas minimizadas
   AADD(Vector, { Ventana , GetProperty( Ventana , "row" ) , GetProperty( Ventana , "col" ) , GetProperty( Ventana , "width") , GetProperty( Ventana , "height" ) , "NORMAL" } )
Return nil

Function US_WinStackDel( Vector , Ventana )
   Local array:={} , i, j
   for i:=1 to len(Vector)
      if Vector[i][1] != Ventana
         AADD( array , { Vector[i][1] , Vector[i][2] , Vector[i][3] , Vector[i][4] , Vector[i][5] , Vector[i][6] } )
      endif
   next
   for i:=1 to len(array)
      for j=1 to 6
         Vector[i][j] := array[i][j]
      next
   next
   for j:=1 to 6
       Vector[len(Vector)][j] := NIL
   next
Return nil

Function US_WinStackStatus( Vector , Ventana , Estado )
   Local i
   for i=1 to len(Vector)
      if Vector[i][1] = Ventana
         Vector[i][6] := Estado
      endif
   next
Return nil

Function US_WinMinimizeAll( Vector )
   Local i:=0
   US_Log( , .F. )
   for i=1 to len(Vector)
      if Vector[i][1] != NIL
         DoMethod( Vector[i][1] , "Minimize" )
      endif
   next
Return .T.

Function US_WinRestoreAll( Vector )
   Local i:=0
*  US_Log( , .F. )
   for i=1 to len(Vector)
      if Vector[i][1] != NIL
         if i = 1
            DoMethod( Vector[i][1] , "Restore" )
         else
            if Vector[i][6] = "MAXIMIZADA"
               DoMethod( Vector[i][1] , "Maximize" )
            else
               if Vector[i][6] = "NORMAL"
                  DoMethod( Vector[i][1] , "Restore" )
               else
                  if Vector[i][6] = "MINIMIZADA"
                     DoMethod( Vector[i][1] , "Minimize" )
                  else
                     US_LOG("Estado de ventana desconocido: "+Vector[i][6],.t.)
                  endif
               endif
            endif
         endif
      endif
   next
Return .T.

Function US_WinHideAll( Vector )
   Local i:=0
   US_Log( , .F. )
   DoMethod( Vector[1][1] , "Hide" )
   * for i=1 to len(Vector)
   for i=len(Vector) to 2 step -1
      if Vector[i][1] != NIL
         DoMethod( Vector[i][1] , "Hide" )
      endif
   next
Return .T.

Function US_WinShowAll( Vector )
   Local i:=0
   US_Log( , .F. )
   for i=1 to len(Vector)
      if Vector[i][1] != NIL
         DoMethod( Vector[i][1] , "Show" )
      endif
   next
Return .T.

 * Function US_AutoScroll
 ***
Function US_AutoScroll( sVentana, cTextBox, nOffset )
   #define WM_VSCROLL                      0x0115
   Local nVentH, nVScrollValue , reto:=.F.
   //
   nVentH := GetProperty(sVentana,"height")
   if _IsControlDefined(sVentana,"vScrollBar")
      nVScrollValue := GetProperty(sVentana,"vScrollBar","value")
   else
      nVScrollValue := 0
   endif
   //
   hWnd := GetFormHandle(sVentana)
   // Veo si tengo que hacer scroll para abajo ****
***If ( GetProperty( sVentana, cTextBox , "Row" ) + nOffset) > (nVentH + nVScrollValue)
   If ( GetProperty( sVentana, cTextBox , "Row" ) + ( nOffset * 5 ) ) > (nVentH + nVScrollValue)
      NewPos := GetProperty( sVentana, cTextBox , "Row" ) - nOffset
      SetScrollPos( hwnd , 1 , NewPos , 1 )
      SendMessage( GetFormHandle(sVentana) , WM_VSCROLL , 0 , 0 )
      reto:=.T.
   else
      // Veo si tengo que hacer scroll para arriba ****
      If GetProperty( sVentana, cTextBox , "Row" ) < nVScrollValue + nOffset
         NewPos := GetProperty( sVentana, cTextBox , "Row" ) - nVentH + nOffset
         SetScrollPos( hwnd , 1 , NewPos , 1 )
         SendMessage( GetFormHandle(sVentana) , WM_VSCROLL , 0 , 0 )
         reto:=.T.
      EndIf
   EndIf
Return reto
//= END Function US_AutoScroll                                                     =\\
//==================================================================================\\

//==================================================================================\\
//= PROCEDIMIENTOS Y FUNCIONES PARA CARGAR MENSAJES DESDE ARCHIVOS XX_MSGnn.HLP    =\\
//----------------------------------------------------------------------------------\\
FUNCTION US_MSGUP(MSG_PREFIX,MSG_VERSION,MSG_RELEASE,MSG_DISPLAY)
   PRIVATE U,ERROR,I
   PRIVATE cCRLF:=HB_OSNEWLINE()
   IF MSG_DISPLAY=NIL .OR. MSG_DISPLAY="ON"
      MSG_DISPLAY="SI"
   ELSE
      IF MSG_DISPLAY="OFF"
         MSG_DISPLAY="NO"
      ELSE
         MsgStop("MUP999I: "+MSG_PREFIX+" VERSION "+MSG_VERSION+" RELEASE "+MSG_RELEASE+cCRLF+ ;
                 "MUP444E: PARAMETRO DISPLAY ERRONEO, VALORES ACEPTADOS: 'ON' U 'OFF'"+cCRLF+ ;
                 "         RECIBIDO:"+cCRLF+ ;
                 MSG_DISPLAY)
         RETURN .F.
      ENDIF
   ENDIF
   ERROR="NO"
   MSG_ARC=MSG_PREFIX+"_MSG??.HLP"
   MSG_DIR=DIRECTORY(MSG_ARC)
   IF LEN(MSG_DIR)=0
      MsgStop("MUP999I: "+MSG_PREFIX+" VERSION "+MSG_VERSION+" RELEASE "+MSG_RELEASE+cCRLF+ ;
            "MUP345E: NO SE ENCONTRARON ARCHIVOS '"+MSG_PREFIX+"_MSG??.HLP'")
      RETURN .F.
   ENDIF
   ASORT(MSG_DIR,,, { |X, Y| UPPER(X[1]) < UPPER(Y[1]) })
   MSG_BASE=MSG_PREFIX+"_MSG"
   MSG_IND=MSG_PREFIX+"_MSG01"
   IF !FILE(MSG_PREFIX+"_MSG.DBF")
      MsgStop("MUP999I: "+MSG_PREFIX+" VERSION "+MSG_VERSION+" RELEASE "+MSG_RELEASE+cCRLF+ ;
            "MUP998E: NO SE ENCUENTRA LA BASE DE MENSAJES '"+MSG_PREFIX+"_MSG.DBF'")
      RETURN .F.
   ENDIF

   IF MSG_DISPLAY="SI"
      MsgStop("MUP000I: "+US_LOWER("Presione OK para refrescar la base de mensajes '"+MSG_BASE+".DBF' DESDE '"+MSG_ARC+"'."))
   ENDIF

   CREATE ESTRTEMP
   APPEND BLANK
   REPLACE FIELD_NAME WITH "MSG_LINEA" , FIELD_TYPE WITH "C" , FIELD_LEN WITH 254   , FIELD_DEC  WITH 0
   APPEND BLANK
   REPLACE FIELD_NAME WITH "MSG_RECORD" , FIELD_TYPE WITH "N" , FIELD_LEN WITH 5    , FIELD_DEC  WITH 0
   CLOSE
   CREATE MSG_TEMP FROM ESTRTEMP

   *US_Use(.T.,,"MSG_TEMP","TEM")
   USE MSG_TEMP ALIAS TEM
   ZAP
   FOR I=1 TO LEN(MSG_DIR)
      MSG_ARC2=MSG_DIR[I,1]
      APPEND FROM &MSG_ARC2 SDF
   NEXT
   GO TOP
   US_Use(.T.,,MSG_BASE,"BAS")
   *USE &MSG_BASE ALIAS BAS
   ZAP
   INDEX ON MSG_NUM TO &MSG_IND
   MSG_SECU = 11
   SELE TEM
   MSG_CONT=1
   DO WHILE !EOF()
      REPLACE MSG_RECORD WITH MSG_CONT
      MSG_CONT=MSG_CONT+1
      MSG_INI=SUBSTR(MSG_LINEA,1,5)
      DO CASE
         CASE MSG_INI=".NUM "
              IF SUBSTR(MSG_LINEA,6,5) = "   "
                 msgExclamation("MUP001E: FALTA NUMERO DE MENSAJE EN LINEA "+ALLTRIM(STR(RECNO())))
                 ERROR = "SI"
              ELSE
                 IF MSG_SECU != 0
                    MSG_ERRORSEC(MSG_SECU)
                 ELSE
                    SELE BAS
                    APPEND BLANK
                    REPLACE MSG_NUM WITH VAL(ALLTRIM(SUBSTR(TEM->MSG_LINEA,6,5)))
                    SELE TEM
                 ENDIF
              ENDIF
              MSG_SECU = 1
         CASE MSG_INI=".NEW "
              IF MSG_SECU != 1
                 MSG_ERRORSEC(MSG_SECU)
              ELSE
                 SELE BAS
                 REPLACE MSG_NEW WITH ALLTRIM(SUBSTR(TEM->MSG_LINEA,6,4))
                 SELE TEM
              ENDIF
              MSG_SECU = 2
         CASE MSG_INI=".UPG "
              IF MSG_SECU != 2 .AND. MSG_SECU != 3
                 MSG_ERRORSEC(MSG_SECU)
              ELSE
                 SELE BAS
                 REPLACE MSG_UPG WITH ALLTRIM(MSG_UPG)+" "+ALLTRIM(SUBSTR(TEM->MSG_LINEA,6,4))
                 SELE TEM
              ENDIF
              MSG_SECU = 3
         CASE MSG_INI=".TIP "
              IF MSG_SECU != 3
                 MSG_ERRORSEC(MSG_SECU)
              ELSE
                 U=SUBSTR(MSG_LINEA,6,1)
                 IF U!="N" .AND. U!="W" .AND. U!="C" .AND. U!="S"
                    MSG_ERRORVAL(ALLTRIM(SUBSTR(MSG_LINEA,6,1)))
                 ELSE
                    SELE BAS
                    REPLACE MSG_TIPO WITH ALLTRIM(SUBSTR(TEM->MSG_LINEA,6,1))
                    SELE TEM
                 ENDIF
              ENDIF
              MSG_SECU = 4
         CASE MSG_INI=".RES "
              IF MSG_SECU != 4
                 MSG_ERRORSEC(MSG_SECU)
              ELSE
                 U=SUBSTR(MSG_LINEA,6,1)
                 IF U!="N" .AND. U!="S"
                    MSG_ERRORVAL(ALLTRIM(SUBSTR(MSG_LINEA,6,1)))
                 ELSE
                    SELE BAS
                    REPLACE MSG_RESP WITH ALLTRIM(SUBSTR(TEM->MSG_LINEA,6,1))
                    SELE TEM
                 ENDIF
              ENDIF
              MSG_SECU = 5
         CASE MSG_INI=".ALA "
              IF MSG_SECU != 5
                 MSG_ERRORSEC(MSG_SECU)
              ELSE
                 U=SUBSTR(MSG_LINEA,6,1)
                 IF U!="N" .AND. U!="S"
                    MSG_ERRORVAL(ALLTRIM(SUBSTR(MSG_LINEA,6,1)))
                 ELSE
                    SELE BAS
                    REPLACE MSG_ALARMA WITH ALLTRIM(SUBSTR(TEM->MSG_LINEA,6,1))
                    SELE TEM
                 ENDIF
              ENDIF
              MSG_SECU = 6
         CASE MSG_INI=".TEX "
              IF MSG_SECU != 6
                 MSG_ERRORSEC(MSG_SECU)
              ELSE
                 IF SUBSTR(MSG_LINEA,6) = SPACE(LEN(MSG_LINEA)-5)
                    MSG_ERRORVAL("EN BLANCO")
                 ELSE
                    SELE BAS
                    REPLACE MSG_TEXTO WITH ALLTRIM(SUBSTR(TEM->MSG_LINEA,6))
                    SELE TEM
                 ENDIF
              ENDIF
              MSG_SECU = 7
         CASE MSG_INI=".EXP "
              IF MSG_SECU != 7 .AND. MSG_SECU != 8
                 MSG_ERRORSEC(MSG_SECU)
              ELSE
                 IF SUBSTR(MSG_LINEA,6) = SPACE(LEN(MSG_LINEA)-5)
                    MSG_ERRORVAL("EN BLANCO")
                 ELSE
                    SELE BAS
                    REPLACE MSG_EXPLIC WITH ALLTRIM(MSG_EXPLIC)+" "+ALLTRIM(SUBSTR(TEM->MSG_LINEA,6))
                    SELE TEM
                 ENDIF
              ENDIF
              MSG_SECU = 8
         CASE MSG_INI=".SYS "
              IF MSG_SECU != 8 .AND. MSG_SECU != 9
                 MSG_ERRORSEC(MSG_SECU)
              ELSE
                 IF SUBSTR(MSG_LINEA,6) = SPACE(LEN(MSG_LINEA)-5)
                    MSG_ERRORVAL("EN BLANCO")
                 ELSE
                    SELE BAS
                    REPLACE MSG_SISACC WITH ALLTRIM(MSG_SISACC)+" "+ALLTRIM(SUBSTR(TEM->MSG_LINEA,6))
                    SELE TEM
                 ENDIF
              ENDIF
              MSG_SECU = 9
         CASE MSG_INI=".USR "
              IF MSG_SECU != 9 .AND. MSG_SECU != 10
                 MSG_ERRORSEC(MSG_SECU)
              ELSE
                 IF SUBSTR(MSG_LINEA,6) = SPACE(LEN(MSG_LINEA)-5)
                    MSG_ERRORVAL("EN BLANCO")
                 ELSE
                    SELE BAS
                    REPLACE MSG_USRACC WITH ALLTRIM(MSG_USRACC)+" "+ALLTRIM(SUBSTR(TEM->MSG_LINEA,6))
                    SELE TEM
                 ENDIF
              ENDIF
              MSG_SECU = 10
         CASE MSG_INI=".MOD "
              IF MSG_SECU != 10 .AND. MSG_SECU != 11
                 MSG_ERRORSEC(MSG_SECU)
              ELSE
                 IF SUBSTR(MSG_LINEA,6) = SPACE(LEN(MSG_LINEA)-5)
                    MSG_ERRORVAL("EN BLANCO")
                 ELSE
                    SELE BAS
                    REPLACE MSG_MODULO WITH ALLTRIM(MSG_MODULO)+" "+ALLTRIM(SUBSTR(TEM->MSG_LINEA,6))
                    SELE TEM
                 ENDIF
              ENDIF
              MSG_SECU = 11
         CASE MSG_INI="-----"
              IF MSG_SECU != 11
                 MSG_ERRORSEC(MSG_SECU)
              ENDIF
              MSG_SECU = 0
         CASE MSG_INI="====="
              IF MSG_SECU != 11
                 MSG_ERRORSEC(MSG_SECU)
              ENDIF
              MSG_SECU = 0
         CASE SUBSTR(MSG_LINEA,1,55)=REPLICATE(" ",55)
         CASE SUBSTR(MSG_LINEA,1,1)="*"
         CASE SUBSTR(MSG_LINEA,1,2)="/*"
         OTHERWISE
              MsgStop("MUP002E: MSG_INI INVALIDO EN LINEA "+ALLTRIM(STR(RECNO()))+": "+MSG_INI)
              ERROR = "SI"
      ENDCASE
      SKIP
   ENDDO
   IF ERROR = "SI"
      MsgStop("Sección de programa no desarrollada para MINIGUI, buscar 985678.")
      **US_LOG( "MUP005I: PRESIONE ENTER PARA VER LOS ERRORES...", .T. )
      **US_LOG("Inkey(0) , Presione Enter" , .T. )
      **SELE TEM
      **GO TOP
      **DBEDIT()
      **USE
      **SELE BAS
      **USE
      **CLEAR
      MsgStop("MUP006E: REFRESH DE BASE DE MENSAJES TERMINADO CON ERROR...", NIL, NIL, .F.)    // this is not translated
      RETURN .F.
   ENDIF
   SELE BAS
   USE
   SELE TEM
   USE
   IF FILE("ESTRTEMP.DBF")
      DELETE FILE ("ESTRTEMP.DBF")
   ENDIF
   IF FILE("MSG_TEMP.DBF")
      DELETE FILE ("MSG_TEMP.DBF")
   ENDIF
   IF FILE("MSG_TEMP.DBT")
      DELETE FILE ("MSG_TEMP.DBT")
   ENDIF
   IF MSG_DISPLAY="SI"
      MsgInfo("MUP007I: "+US_LOWER("REFRESH DE BASE DE MENSAJES TERMINADO OK."))
   ENDIF
RETURN .T.

FUNCTION MSG_ERRORSEC
   PARAMETERS S
   DECLARE ESEC[12]
   ESEC[1]=".NUM"
   ESEC[2]=".NEW"
   ESEC[3]=".UPG"
   ESEC[4]=".TIP"
   ESEC[5]=".RES"
   ESEC[6]=".ALA"
   ESEC[7]=".TEX"
   ESEC[8]=".EXP"
   ESEC[9]=".SYS"
   ESEC[10]=".USR"
   ESEC[11]=".MOD"
   ESEC[12]="----"
   S=S+1
   US_LOG("MUP003E: EN SECUENCIA EN LINEA "+ALLTRIM(STR(RECNO()))+", SE ESPERABA "+ESEC[S] , .t. )
   ERROR = "SI"
RETURN .T.

FUNCTION MSG_ERRORVAL
   PARAMETERS V
   US_LOG( "MUP004E: EN VALIDACION, CARACTER: '"+V+"' EN LINEA "+ALLTRIM(STR(RECNO()))+" ES INVALIDO." , .t. )
   ERROR = "SI"
RETURN .T.
//= END Funcion US_MSGUP                                                           =\\
//==================================================================================\\

//==================================================================================\\
//= FUNCION PARA PROCESAMIENTO DE MENSAJES                                         =\\
//----------------------------------------------------------------------------------\\
FUNCTION US_MSG(M99SISTEMA,M99NUM,M99FILPOS,M99MODO)
   Local cCRLF:=HB_OsNewLine()
   IF PCOUNT() < 4
      M99MODO = "ONLINE"
   ENDIF
   M99ERROR = "NO"
   IF M99SISTEMA = NIL
      US_LOG( "MSG000: ERROR EN PARAMETROS : PARAMETRO NUMERO 1, CORRESPONDIENTE AL IDENTIFICADOR"+cCRLF+ ;
              "DE ARCHIVO DE MENSAJES, ES NULO." , .t. )
      M99ERROR = "SI"
   ENDIF
   IF VALTYPE(M99NUM) != "N"
      US_LOG( "MSG002: ERROR EN PARAMETROS : PARAMETRO NUMERO 2, CORRESPONDIENTE AL NUMERO"+cCRLF+ ;
              "DEL MENSAJE, NO ES DE TIPO NUMERICO." , .t. )
      M99ERROR = "SI"
   ENDIF
   IF VALTYPE(M99FILPOS) != "N"
      US_LOG( "MSG001: ERROR EN PARAMETROS : PARAMETRO NUMERO 3, CORRESPONDIENTE A LA POSICION"+cCRLF+ ;
              "DEL MENSAJE, NO ES DE TIPO NUMERICO." , .t. )
      M99ERROR = "SI"
   ENDIF
   IF M99ERROR = "SI"
      RETURN -1
   ENDIF
   M99SISTEMA = ALLTRIM(M99SISTEMA)
   M99NUMB = M99NUM
   M99NUM = STRTRAN(STR(M99NUM,5)," ","0")
   if M99SISTEMA = "RN"
      M99SISTEMA := "VP"
   endif
   M99BASE = M99SISTEMA+"_MSG"
   IF !FILE(M99BASE+".DBF")
      US_LOG( "MSG003: ERROR EN MENSAJE "+M99NUM+" : BASE DE MENSAJES '"+M99BASE+".DBF' NO EXISTE O NO FUE ENCONTRADA" , .t. )
      M99ERROR = "SI"
   ENDIF
   IF !FILE(M99BASE+"01.NTX")
      US_LOG( "MSG004: ERROR EN MENSAJE "+M99NUM+" : ARCHIVO '"+M99BASE+"01.NTX', CORRESPONDIENTE AL"+cCRLF+ ;
              "INDICE DE LA BASE DE MENSAJES NO EXISTE O NO FUE ENCONTRADA" , .t. )
      M99ERROR = "SI"
   ENDIF
   IF M99ERROR = "SI"
      RETURN -1
   ENDIF
   // AREA ACTUAL 
   M99AREAA = DBF()
   // ABRE LA BASE DE MENSAJES Y EL INDICE 
   US_Use(.T.,,M99BASE,"MSG")
   DBSETINDEX(M99BASE+"01")
   // PROCESO EL MENSAJE 
   M99I = 0
   DECLARE M99LMEN[0]
   M99CONTRASTE= "N"                 /// GRIS
   M99FONDO = "N/"+M99CONTRASTE      /// NEGRO
   M99NOTIFY = "G/"+M99CONTRASTE     /// VERDE
   M99WARNING = "GR+/"+M99CONTRASTE  /// AMARILLO
   M99CRITICAL = "R+/"+M99CONTRASTE   /// ROJO
   M99SEVERO = "R+/"+M99CONTRASTE     /// ROJO
   M99AYUDA = "BG+/"+M99CONTRASTE      /// CELESTE
   M99CCREVERSE= "W/B"
   M99CCPROMPT = "W+/R,R/W, , ,W/R"
   M99RPTA = DBSEEK(M99NUMB,.F.)
   IF !M99RPTA
      US_LOG( "MSG005: ERROR EN MENSAJE "+M99NUM+" : MENSAJE NUMERO : "+M99NUM+" NO EXISTE.........." , .t. )
      RETURN -1
   ELSE
      IF MSG_RESP = "S"
      ELSE
         IF MSG_RESP != "N"
            US_LOG( "MSG006: ERROR EN MENSAJE "+M99NUM+" : ERROR EN ESPERA RESPUESTA" , .t. )
            RETURN -1
         ENDIF
      ENDIF

      IF MSG_ALARMA = "S"
         TONE(500,3)
      ELSE
         IF MSG_ALARMA != "S" .AND. MSG_ALARMA != "N"
            US_LOG( "MSG007: ERROR EN MENSAJE "+M99NUM+" : ERROR EN ALARMA" , .t. )
            RETURN -1
         ENDIF
      ENDIF

      M99MEN = ALLTRIM(MSG_TEXTO)
      M99MEN2 = M99MEN
      DO WHILE AT("@.",M99MEN2) != 0
         M99MENVAR = SUBSTR(M99MEN2,AT("@.",M99MEN2)+2)
         M99MENVAR2 = SUBSTR(M99MENVAR,1,AT(".@",M99MENVAR)-1)
         IF SUBSTR(M99MENVAR2,1,3) = "M99"
            US_LOG( "MSG008: ERROR EN MENSAJE "+M99NUM+" : NOMBRE DE VARIABLE '"+M99MENVAR2+"'"+cCRLF+ ;
                    "ES INCORRECTO, LAS VARIABLES QUE COMIENZAN CON 'M99' SON RESERVADAS DE"+cCRLF+ ;
                    "LA FUNCION 'US_MSG'." , .t. )
            RETURN -1
         ENDIF
         DO CASE
            CASE VALTYPE(&M99MENVAR2) = "C"
                 M99MENVAR3 = ALLTRIM(&M99MENVAR2)
            CASE VALTYPE(&M99MENVAR2) = "D"
                 M99MENVAR3 = SUBSTR(DTOS(&M99MENVAR2),7,2)+"/"+SUBSTR(DTOS(&M99MENVAR2),5,2)+"/"+SUBSTR(DTOS(&M99MENVAR2),1,4)
            CASE VALTYPE(&M99MENVAR2) = "N"
                 M99MENVAR3 = ALLTRIM(STR(&M99MENVAR2))
            OTHERWISE
                 US_LOG( "MSG009: ERROR EN MENSAJE "+M99NUM+" : ERROR EN TIPO DE VARIABLE DE VARIABLE: "+M99MENVAR2+cCRLF+ ;
                         "TIPO DETECTADO: "+VALTYPE(&M99MENVAR2) , .t. )
                 RETURN -1
         ENDCASE
         M99MEN = STRTRAN(M99MEN,"@."+M99MENVAR2+".@",M99MENVAR3)
         M99MEN2 = SUBSTR(M99MENVAR,AT(".@",M99MENVAR)+2)
      ENDDO
      DO CASE
         CASE MSG_TIPO = "S"
            M99TIPO = "ERROR INTERNO DEL PROGRAMA !!!"
         CASE MSG_TIPO = "N"
            M99TIPO = "INFORMACION"
         CASE MSG_TIPO = "W"
            M99TIPO = "CUIDADO..."
         CASE MSG_TIPO = "C"
            M99TIPO = "ERROR !!!"
         OTHERWISE
            US_LOG( "MSG010: ERROR EN MENSAJE "+M99NUM+" : ERROR EN TIPO DE MENSAJE" , .t. )
            RETURN -1
      ENDCASE
      US_OPCION(M99MEN,"",M99FILPOS,,M99SISTEMA+M99NUM+" "+M99TIPO,"US_MSGHELP("+M99NUM+","+STR(M99FILPOS)+")",IIF(MSG_TIPO="S","C",MSG_TIPO),IIF(MSG_TIPO="N",0,2),IIF(MSG_RESP="N",.F.,.T.))
   ENDIF
   // CIERRA EL INDICE Y LA BASE DE MENSAJES 
   DBCLEARINDEX()
   DBCLOSEAREA()
   // VUELVE AL AREA ACTIVA ANTES DEL MENSAJE 
   IF M99AREAA != ""
      DBSELECTAREA(M99AREAA)
   ENDIF
RETURN .T.
//= END Funcion US_MSG                                                             =\\
//==================================================================================\\
*/

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

/*
//CDQ  //= Funciones para flat border y transparent form                               =\\
//CDQ  //----------------------------------------------------------------------------------\\
//CDQ  #define SWP_NOMOVE     2
//CDQ  #define SWP_NOSIZE     1
//CDQ  #define GWL_EXSTYLE    (-20)
//CDQ  #define WS_EX_CLIENTEDGE 512
//CDQ  #define WS_EX_STATICEDGE 8192
//CDQ  #define SWP_FRAMECHANGED 32
//CDQ  #define SWP_NOACTIVATE 16
//CDQ  #define SWP_NOZORDER   4
//CDQ  #define SWP_DRAWFRAME SWP_FRAMECHANGED
//CDQ  #define SWP_FLAGS SWP_NOZORDER + SWP_NOSIZE + SWP_NOMOVE + SWP_DRAWFRAME
//CDQ  #define BS_FLAT 32768
//CDQ
//CDQ  Function FlatBorder( ControlHwnd )
//CDQ  LOCAL TFlat
//CDQ  TFlat = GetWindowLong(ControlHwnd, GWL_EXSTYLE)
//CDQ  TFlat = TFlat + WS_EX_CLIENTEDGE + WS_EX_STATICEDGE
//CDQ  SetWindowLongA(ControlHwnd, GWL_EXSTYLE, TFlat)
//CDQ  //SetWindowPos(ControlHwnd, 0, 0, 0, 0, 0, SWP_NOACTIVATE + SWP_NOZORDER + SWP_FRAMECHANGED + SWP_NOSIZE + SWP_NOMOVE)
//CDQ  SetWindowPos(ControlHwnd, 0, 0, 0, 0, 0, SWP_NOACTIVATE + SWP_NOZORDER + SWP_NOSIZE + SWP_NOMOVE)
//CDQ  RETURN
//CDQ
//CDQ  #pragma BEGINDUMP
//CDQ
//CDQ  #include <windows.h>
//CDQ  #include <windowsx.h>
//CDQ  #include <commctrl.h>
//CDQ  #include "hbapi.h"
//CDQ  #include "hbapiitm.h"
//CDQ  #include "hbvm.h"
//CDQ  #include "hbstack.h"
//CDQ  #include <winuser.h>
//CDQ
//CDQ  #define WS_EX_LAYERED 0x80000
//CDQ  #define LWA_COLORKEY 1
//CDQ  #define LWA_ALPHA 2
//CDQ
//CDQ  WINUSERAPI
//CDQ  BOOL
//CDQ  WINAPI
//CDQ  SetLayeredWindowAttributes(
//CDQ  HWND hwnd,
//CDQ  COLORREF crKey,
//CDQ  BYTE bAlpha,
//CDQ  DWORD dwFlags);
//CDQ
//CDQ  HB_FUNC ( GETWINDOWLONG )
//CDQ  {
//CDQ  hb_retnl( ( LONG ) GetWindowLong( ( HWND ) hb_parnl( 1 ), hb_parni( 2 ) ) );
//CDQ  }
//CDQ
//CDQ  HB_FUNC ( SETWINDOWPOS )
//CDQ  {
//CDQ  HWND hwnd           = (HWND) hb_parnl(1);    // handle to window or control
//CDQ  HWND hWndInsertAfter= (HWND) hb_parnl(2);    // placement-order handle
//CDQ  int X               =        hb_parni(3);    // horizontal position
//CDQ  int Y               =        hb_parni(4);    // vertical position
//CDQ  int cx              =        hb_parni(5);    // width
//CDQ  int cy              =        hb_parni(6);    // height
//CDQ  UINT uFlags         = (UINT) hb_parni(7);    // window-positioning options
//CDQ
//CDQ  hb_retl( (BOOL) SetWindowPos( hwnd, hWndInsertAfter, X, Y, cx, cy, uFlags ) );
//CDQ  }
//CDQ
//CDQ  //HB_FUNC ( SETLAYEREDWINDOWATTRIBUTES )
//CDQ  //{
//CDQ  // HWND hwnd            = (HWND)     hb_parnl(1);    // handle to window or control
//CDQ  // COLORREF crKey       = (COLORREF) hb_parnl(2);
//CDQ  // BYTE bAlpha          = (BYTE)     hb_parni(3);
//CDQ  // DWORD dwFlags        = (DWORD)    hb_parni(4);
//CDQ  //
//CDQ  // hb_retl( (BOOL) SetLayeredWindowAttributes(hwnd, crKey, bAlpha, dwFlags) );
//CDQ  //}
//CDQ
//CDQ  //HB_FUNC (MAKELAYER)
//CDQ  //{
//CDQ  // HWND hwnd            = (HWND)     hb_parnl(1);
//CDQ  // COLORREF crKey       = (COLORREF) hb_parnl(2);
//CDQ  //
//CDQ  // SetWindowLong (hwnd , GWL_EXSTYLE ,
//CDQ  // GetWindowLong (hwnd , GWL_EXSTYLE ) | WS_EX_LAYERED ) ;
//CDQ  // SetLayeredWindowAttributes(hwnd, 0, crKey, LWA_ALPHA);
//CDQ  //}
//CDQ
//CDQ  #pragma ENDDUMP
//CDQ
//CDQ  //= END Funciones para flat border y transparent form                           =\\
//CDQ  //==================================================================================\\
*/

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

/*
Function US_Achoice( aItems, nValue, cTitle )
   // DEFAULT cTitle TO "Please, select", nValue TO 0
   if( cTitle == NIL , cTitle := "Please, select" , )
   if( nValue == NIL , nValue := 0 , )
   DEFINE WINDOW US_AcoiceForm ;
      AT 0,0 ;
      WIDTH 400 HEIGHT 300 ;
      TITLE cTitle ;
      ICON 'MAIN' ;
      TOPMOST ;
      NOMAXIMIZE NOSIZE
      @ 235,190 BUTTON US_AcoiceOk ;
         CAPTION 'OK' ;
         ACTION {|| nValue := GetProperty( "US_AcoiceForm" , "US_AcoiceList" , "value" ) , US_AcoiceForm.Release } ;
         WIDTH 80
      @ 235,295 BUTTON US_AcoiceCancel ;
         CAPTION 'Cancel' ;
         ACTION {|| nValue := 0, US_AcoiceForm.Release } ;
         WIDTH 80
      @ 20,15 LISTBOX US_AcoiceList ;
         WIDTH 360 ;
         HEIGHT 200 ;
         ITEMS aItems ;
         VALUE nValue ;
         FONT "Ms Sans Serif" ;
         SIZE 12 ;
         ON DBLCLICK {|| nValue := GetProperty( "US_AcoiceForm" , "US_AcoiceList" , "value" ), US_AcoiceForm.Release }
   END WINDOW
   CENTER WINDOW US_AcoiceForm
   ACTIVATE WINDOW US_AcoiceForm
return nValue
*/

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

/*
Function US_MiniGuiType()
   do case
      case at( "Extended" , MiniGuiVersion() ) > 0
         Return "E1"
      case at( "ooHG" , MiniGuiVersion() ) == 1
         Return "O3"
      case at( "Harbour MiniGUI 1" , MiniGuiVersion() ) == 1
         Return "M1"
      case at( "Harbour MiniGUI 2" , MiniGuiVersion() ) == 1
         Return "M2"
      case at( "Harbour MiniGUI 3" , MiniGuiVersion() ) == 1
         Return "M3"
      otherwise
         MsgInfo( "Error detecting MiniGui type: " + MiniGuiVersion() )
   endcase
Return "?"
*/

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

/*
HB_FUNC ( SETMENUDEFAULTITEM )
{
        SetMenuDefaultItem( (HMENU) hb_parnl( 1 ), hb_parni( 2 ) - 1, TRUE );
}

HB_FUNC ( US_MCIFUNC )
{
        HWND mcihand = (HWND) hb_parnl(1);
        int  func    = hb_parni(2);
        switch(func)
      {
         case  1:  hb_retnl( MCIWndPlay(mcihand) ); break;
         case  2:  hb_retnl( MCIWndStop(mcihand) ); break;
         case  3:  hb_retnl( MCIWndPause(mcihand) ); break;
         case  4:  hb_retnl( MCIWndClose(mcihand) ); break;
         case  5:            MCIWndDestroy(mcihand); hb_retnl(0);break;
         case  6:  hb_retnl( MCIWndEject(mcihand) ); break;
         case  7:  hb_retnl( MCIWndEnd(mcihand) ); break;
         case  8:  hb_retnl( MCIWndHome(mcihand) ); break;
         case  9:  hb_retnl( MCIWndOpen(mcihand,hb_parc(3),NULL) ); break;
         case 10:  hb_retnl( MCIWndOpenDialog(mcihand) ); break;
         case 11:  hb_retnl( MCIWndPlayReverse(mcihand) ); break;
         case 12:  hb_retnl( MCIWndResume(mcihand) ); break;
         case 13:            MCIWndSetRepeat(mcihand,hb_parl(3) );hb_retnl(0); break;
         case 14:  hb_retnl( MCIWndSetSpeed(mcihand,hb_parni(3)) ); break;
         case 15:  hb_retnl( MCIWndSetVolume(mcihand,hb_parni(3)) ); break;
         case 16:            MCIWndSetZoom(mcihand,hb_parni(3) ); hb_retnl(0); break;
         case 17:  hb_retnl( MCIWndGetLength(mcihand) ); break;
         case 18:  hb_retnl( MCIWndGetPosition(mcihand) ); break;
         case 19:  hb_retnl( MCIWndGetVolume(mcihand) ); break;
         case 20:  hb_retnl( MCIWndSeek(mcihand,hb_parni(3)) ); hb_retnl(0); break;
         default: hb_retnl( 0 );
      }
}

HB_FUNC ( US_INITIMAGE )
{
        HWND  h;
        HBITMAP hBitmap;
        HWND hwnd;

        hwnd = (HWND) hb_parnl (1);

        h = CreateWindowEx(0,"static",NULL,
        WS_CHILD | WS_VISIBLE | SS_BITMAP | SS_NOTIFY,
        hb_parni(3), hb_parni(4), 0, 0,
        hwnd,(HMENU)hb_parni(2) , GetModuleHandle(NULL) , NULL );

        hBitmap = (HBITMAP)LoadImage(0,hb_parc(5),IMAGE_BITMAP,hb_parni(6),hb_parni(7),LR_LOADFROMFILE|LR_CREATEDIBSECTION);
        if (hBitmap==NULL)
        {
                hBitmap = (HBITMAP)LoadImage(GetModuleHandle(NULL),hb_parc(5),IMAGE_BITMAP,hb_parni(6),hb_parni(7),LR_CREATEDIBSECTION);
        }


        SendMessage(h,(UINT)STM_SETIMAGE,(WPARAM)IMAGE_BITMAP,(LPARAM)hBitmap);

        hb_retnl ( (LONG) h );
}

HB_FUNC ( US_C_SETPICTURE )
{
        HBITMAP hBitmap;

        hBitmap = (HBITMAP)LoadImage(0,hb_parc(2),IMAGE_BITMAP,hb_parni(3),hb_parni(4),LR_LOADFROMFILE|LR_CREATEDIBSECTION);
        if (hBitmap==NULL)
        {
                hBitmap = (HBITMAP)LoadImage(GetModuleHandle(NULL),hb_parc(2),IMAGE_BITMAP,hb_parni(3),hb_parni(4),LR_CREATEDIBSECTION);
        }

        SendMessage((HWND) hb_parnl (1),(UINT)STM_SETIMAGE,(WPARAM)IMAGE_BITMAP,(LPARAM)hBitmap);
}
*/

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

/*
HB_FUNC (GETEXEFILENAME)
{
   unsigned char pBuf[250];

   GetModuleFileName( GetModuleHandle(NULL), (LPTSTR) pBuf, 249 );

   hb_retc( (char*) pBuf );
}
*/

#pragma ENDDUMP

/* eof */
