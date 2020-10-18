/*
 *    QPM - QAC based Project Manager
 *
 *    Copyright 2011-2020 Fernando Yurisich <qpm-users@lists.sourceforge.net>
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

#include "minigui.ch"

#define LASTNEW "C:/QPMdev/qpm/HelpQPM/"

FUNCTION Main()

   DEFINE WINDOW Sample ;
      AT 0, 0 ;
      WIDTH 408 ;
      HEIGHT 200 ;
      TITLE "Change path to help files" ;
      MAIN

      DEFINE LABEL LabelOld
        ROW 24
        COL 20
        WIDTH 30
        VALUE "From:"
      END LABEL

      DEFINE TEXTBOX old
        VALUE LASTNEW
        ROW 20
        COL 60
        WIDTH 320
      END TEXTBOX

      DEFINE LABEL LabelNew
        ROW 64
        COL 20
        WIDTH 30
        VALUE "To:"
      END LABEL

      DEFINE TEXTBOX new
        VALUE ""
        ROW 60
        COL 60
        WIDTH 320
      END TEXTBOX

      DEFINE BUTTON Button1
        ROW 100
        COL 100
        WIDTH 200
        CAPTION "Change"
        ONCLICK Change()
      END BUTTON

   END WINDOW

   CENTER WINDOW Sample
   ACTIVATE WINDOW Sample

RETURN .T.


PROCEDURE Change()

   old := Sample.old.value
   new := Sample.new.value

   IF Empty( old )
      MsgInfo( 'Error: "From" is empty!' )
      RETURN
   ENDIF
   IF Empty( new )
      MsgInfo( 'Error: "To" is empty!' )
      RETURN
   ENDIF

   USE QPM_SHG.dbf ALIAS "SHG"
   PACK
   dbGoTop()
   DO WHILE ! Eof()
      REPLACE SHG_Topic  WITH US_StrTran( SHG_Topic,  old, new ), ;
              SHG_TopicT WITH US_StrTran( SHG_TopicT, old, new ), ;
              SHG_Memo   WITH US_StrTran( SHG_Memo,   old, new ), ;
              SHG_MemoT  WITH US_StrTran( SHG_MemoT,  old, new ), ;
              SHG_Keys   WITH US_StrTran( SHG_Keys,   old, new ), ;
              SHG_KeysT  WITH US_StrTran( SHG_KeysT,  old, new ), ;
              SHG_Nick   WITH US_StrTran( SHG_Nick,   old, new ), ;
              SHG_NickT  WITH US_StrTran( SHG_NickT,  old, new )
      dbSkip()
   ENDDO
   USE
   MsgInfo( "Path changed to " + new )

   cPrg := MemoRead( "SHG_Change.prg" )
   cPrg := US_StrTran( cPrg, '#define LASTNEW "' + old + '"', '#define LASTNEW "' + new + '"' )
   hb_MemoWrit( "SHG_Change.prg", cPrg )

   Sample.old.value := Sample.new.value
   Sample.new.value := ""

RETURN


// US_StrTran reemplaza caracteres ignorando si es mayusculas o minusculas
FUNCTION US_StrTran( cLinea, cOld, cNew, nDesde, nCant )
   LOCAL nBase, nPos, cLineaSal := "", nContador := 0, bTope := .F.
   LOCAL cLineaUpper, cOldUpper, cNewUpper

   //us_log( cLinea )
   //us_log( cold   )
   //us_log( cnew   )
   IF cLinea == NIL
      cLinea := ""
   ENDIF
   cLineaUpper := Upper( cLinea )
   cOldUpper := Upper( cOld )
   cNewUpper := Upper( cNew )
   IF Empty( nDesde )
      nDesde := 1
   ENDIF
   IF ! Empty( nCant )
      bTope := .T.
   ENDIF
   nBase := nDesde
   cLineaSal := SubStr( cLinea, 1, nBase - 1 )
   // us_log( "==============================================" )
   DO WHILE ( ( nPos := At( cOldUpper, SubStr( cLineaUpper, nBase ) ) ) > 0 .AND. ( ! bTope .OR. nContador < nCant ) )
      nPos := nPos + ( nBase - 1 )
      //us_log( "--------------------------------------------" )
      //us_log( nPos )
      IF bTope
         nContador++
      ENDIF
      cLineaSal := cLineaSal + SubStr( cLinea, nBase, nPos - nBase ) + cNew
      //us_log( clineasal )
      nBase := nPos + Len( cOldUpper )
      //us_log( nBase )
   ENDDO
   IF nBase < Len( cLinea )
      cLineaSal := cLineaSal + SubStr( cLinea, nBase )
   ENDIF
   //us_log( cLineasal )

RETURN cLineaSal

/* eof */
