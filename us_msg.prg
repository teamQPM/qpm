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

#define VERSION "01.02"
MEMVAR CQPMDIR

PROCEDURE MAIN( ... )
   LOCAL aParams := hb_aParams()
   LOCAL cParam, n, cFileMemo, cFileOut, cMSG, cChkFile, bList := .F.
   PRIVATE cQPMDir := ""

   cParam := ""
   FOR n := 1 TO Len( aParams )
      cParam += ( aParams[ n ] + " " )
   NEXT n
   cParam := AllTrim( cParam )

   IF Upper( US_Word( cParam, 1 ) ) == "-VER" .OR. Upper( US_Word( cParam, 1 ) ) == "-VERSION"
      hb_MemoWrit( "US_Msg.version", VERSION )
      RETURN .T.
   ENDIF

   IF Upper( US_Word( cParam, 1 ) ) == "QPM"
      cParam := US_WordDel( cParam, 1 )
   ENDIF

   IF Upper( SubStr( cParam, 1, 5 ) ) == "-LIST"
      bList := .T.
      cQPMDir := SubStr( US_Word( cParam, 1), 6 )
      IF ! Right( cQPMDir, 1 ) == "\"
         cQPMDir += "\"
      ENDIF
   ENDIF

   IF bList
      QPM_Log( "------------ " + "US_Msg.version " + VERSION )
   ENDIF

   cFileOut := SubStr( cParam, 1, RAt( "-MSG:", upper( cParam ) ) - 1 )
   cMSG := SubStr( cParam, RAt( "-MSG:", Upper( cParam ) ) + 5 )
   cChkFile := SubStr( cFileOut, 1, RAt( "\", cFileOut ) + 15 ) + "MSG.SYSIN"

   IF bList
      QPM_Log( "US_Msg 002I: " + cFileOut )
      QPM_Log( "US_Msg 003I: " + cMSG )
      QPM_Log( "US_Msg 004I: " + cChkFile )
      QPM_Log( "------------" + CRLF )
   ENDIF

   IF File( cChkFile )
      IF US_Word( Memoread( cChkFile ), 1 ) == "STOP"
         FErase( cChkFile )
         __Run( "ECHO " + ".               ============================================================" )
         __Run( "ECHO " + ".               ==          Build proccess was stoped by the user         ==" )
         __Run( "ECHO " + ".               ============================================================" )
         ExitProcess( 1 )
      ENDIF
   ENDIF

   cFileMemo := US_TimeDis( Time() ) + " - " + cMSG + hb_osNewLine()
   IF File( cFileOut )
      cFileMemo := MemoRead( cFileOut ) + cFileMemo
   ENDIF
   hb_MemoWrit( cFileOut, cFileMemo)

   ExitProcess( 0 )

   RETURN

//========================================================================
// FUNCION PARA ELIMINAR UNA PALABRA DE UN STRING
//========================================================================
FUNCTION US_WordDel( estring, posicion )

   RETURN iif( posicion > 0, ;
               AllTrim( SubStr( estring, 1, US_WordInd( estring, posicion ) - 1 ) + ;
                        StrTran( SubStr( estring, US_WordInd( estring, posicion ) ), US_Word( estring, posicion ), " ", 1, 1 ) ), ;
               estring )

//========================================================================
// RETORNA LA POSICION DONDE EMPIEZA LA PALABRA numero
//========================================================================
FUNCTION US_WordInd( estring, numero )
   LOCAL cont, estr, estr2

   IF estring == NIL
      estring := ""
   ENDIF
   IF US_Words( estring ) < numero
      RETURN ( Len( estring ) + 1 )
   ENDIF
   cont := 1
   estr := estring
   estr2 := RTrim( estring )
   estring := AllTrim( estring )
   DO WHILE .T.
      IF At( " ", estring ) == 0
         RETURN iif( numero == cont, Len( estr ) - ( Len( estring ) + ( Len( estr ) - Len( estr2 ) ) ) + 1, 0 )
      ELSEIF cont == numero
         RETURN ( Len( estr ) - ( Len( estring ) + ( Len( estr ) - Len( estr2 ) ) ) + 1 )
      ENDIF
      estring := AllTrim( SubStr( estring, At( " ", estring ) + 1 ) )
      cont ++
   ENDDO

   RETURN 0

//========================================================================
// CUENTA LAS PALABRAS EN UN STRING
//========================================================================
FUNCTION US_Words( estring )
   LOCAL cont := 0

   IF estring == NIL
      estring := ""
   ENDIF
   estring := AllTrim( estring)
   DO WHILE .T.
      IF At( " ", estring ) == 0
         RETURN iif( Len( estring ) > 0, cont + 1, cont )
      ENDIF
      estring := AllTrim( SubStr( estring, At( " ", estring ) + 1 ) )
      cont ++
   ENDDO

   RETURN 0

//========================================================================
// FUNCION PARA EXTRAER UNA PALABRA DE UN ESTRING
//========================================================================
FUNCTION US_WORD(ESTRING, POSICION)
   LOCAL CONT
   CONT := 1
   if Posicion == NIL
      Posicion := 1
   endif
   ESTRING := ALLTRIM(ESTRING)
   DO WHILE .T.
      IF AT(" ",ESTRING) != 0
         IF CONT == POSICION
            RETURN SUBSTR(ESTRING,1,AT(" ",ESTRING)-1)
         ELSE
            ESTRING := ALLTRIM(SUBSTR(ESTRING,AT(" ",ESTRING) + 1))
            CONT := CONT + 1
         ENDIF
      ELSE
         IF POSICION == CONT
            RETURN ESTRING
         ELSE
            RETURN ""
         ENDIF
      ENDIF
   ENDDO
Return ""

//========================================================================
// FUNCION PARA MOSTRAR UN CAMPO TIME SIN CEROS A LA IZQUIERDA
//========================================================================
FUNCTION US_TIMEDIS(TIEMPO)
   LOCAL RES,I
   RES := ""
   FOR I:=1 TO 4
      IF SUBSTR(TIEMPO,I,1) != "0" .AND. SUBSTR(TIEMPO,I,1) != ":"
         RES:=RES+SUBSTR(TIEMPO,I)
         RETURN RES
      ELSE
         RES:=RES+" "
      ENDIF
   NEXT
RETURN RES+SUBSTR(TIEMPO,I)

//========================================================================
// ESCRIBE EN EL LOG
//========================================================================
STATIC FUNCTION QPM_Log( string )
   LOCAL LogArchi := cQPMDir + "QPM.LOG"
   LOCAL msg := DToS( Date() ) + " " + Time() + " US_MSG " + ProcName( 1 ) + "(" + Str( ProcLine( 1 ), 3, 0 ) + ")" + " " + string

   SET CONSOLE OFF
   SET ALTERNATE TO ( LogArchi ) ADDITIVE
   SET ALTERNATE ON
   ? msg
   SET ALTERNATE OFF
   SET ALTERNATE TO
   SET CONSOLE ON

   RETURN .T.

/* eof */
