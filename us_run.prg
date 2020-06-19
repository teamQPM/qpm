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

#include "minigui.ch"
#include "fileio.ch"

// For error codes see: http://msdn2.microsoft.com/en-us/library/ms681382(VS.85).aspx

FUNCTION MAIN( ... )
   Local aParams := hb_aParams(), n
   Local Version := "01.02", bOk := .T., nLineSize := 1024
   Local cParam, MemoAux := "", i, cLineaAux := ""
   Private cCMD, cControlFile, cDefaultPath, cCurrentPath, cMode := "NORMAL"

   cParam := ""
   For n := 1 To Len( aParams )
      cParam += ( aParams[ n ] + " " )
   Next n
   cParam := AllTrim( cParam )

   If Upper( US_Word( cParam, 1 ) ) == "-VER" .or. Upper( US_Word( cParam, 1 ) ) == "-VERSION"
      MemoWrit( "US_Run.version", Version )
      Return bOk
   EndIf

   If Upper( US_Word( cParam, 1 ) ) != "QPM"
      MsgInfo( "US_Run 999E: Running Outside System" )
      ERRORLEVEL( 1 )
      bOk := .F.
      Return bOk
   Else
      cParam := US_WordDel( cParam, 1 )
   EndIf

   If Empty( cParam )
      MsgInfo( "US_Run 123: Missing Parameters" )
      ERRORLEVEL( 1 )
      bOk := .F.
      Return bOk
   EndIf

   If ! File( cParam )
      MsgInfo( "US_Run 124: Parameters File Not Found: " + cParam )
      ERRORLEVEL( 1 )
      bOk := .F.
      Return bOk
   Else
      MemoAux := MemoRead( cParam )
      For i := 1 To MLCount( MemoAux, nLineSize )
         cLineaAux := AllTrim( MemoLine( MemoAux, nLineSize, i ) )
         If Upper( US_Word( cLineaAux, 1 ) ) == "COMMAND"
            cCMD := US_WordSubStr( cLineaAux, 2 )
         EndIf
         If Upper( US_Word( cLineaAux, 1 ) ) == "CONTROL"
            cControlFile := US_WordSubStr( cLineaAux, 2 )
         EndIf
         If Upper( US_Word( cLineaAux, 1 ) ) == "DEFAULTPATH"
            cDefaultPath := US_WordSubStr( cLineaAux, 2 )
         EndIf
         If Upper( US_Word( cLineaAux, 1 ) ) == "MODE"
            cMode := US_WordSubStr( cLineaAux, 2 )
         EndIf
      Next i
      FErase( cParam )
   EndIf

   DEFINE WINDOW VentanaMain ;
      AT 0, 0 ;
      WIDTH GetDesktopWidth() ;
      HEIGHT GetDesktopHeight() ;
      TITLE '' ;
      MAIN ;
      ICON "DOS" ;
      NOSHOW ;
      ON INIT US_RunInit()
   END WINDOW

   ACTIVATE WINDOW VentanaMain

   If ! bOk
      ERRORLEVEL( 1 )
   EndIf
Return bOk

Function US_RunInit()
   Local Reto, nHandle

   DO EVENTS
   nHandle := FOpen( cControlFile, FO_WRITE + FO_EXCLUSIVE )
   If ! Empty( cDefaultPath )
      cCurrentPath := GetCurrentFolder()
      SetCurrentFolder( cDefaultPath )
   EndIf
   DO EVENTS
   Do Case
   Case cMode == "HIDE"
      Reto := WaitRun( cCMD, 0 )            // EXECUTE FILE ( cCMD ) WAIT HIDE
   Case cMode == "MINIMIZE"
      Reto := WaitRun( cCMD, 6 )            // EXECUTE FILE ( cCMD ) WAIT MINIMIZE
   Case cMode == "MAXIMIZE"
      Reto := WaitRun( cCMD, 3 )            // EXECUTE FILE ( cCMD ) WAIT MAXIMIZE
   Otherwise
      Reto := WaitRun( cCMD, 5 )            // EXECUTE FILE ( cCMD ) WAIT
   EndCase
   If ! Empty( cDefaultPath )
      SetCurrentFolder( cCurrentPath )
   EndIf
   DO EVENTS
   If Reto > 8
      MsgInfo( "US_Run 333: Error Running: " + cCMD + HB_OsNewLine() + "Code: " + US_VarToStr( Reto ) )
      bOk := .F.
   EndIf
   FClose( nHandle )
   FErase( cControlFile )
   DO EVENTS
   VentanaMain.Release()
Return Nil

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
// FUNCION PARA ELIMINAR UNA PALABRA DE UN STRING
//========================================================================
FUNCTION US_WORDDEL(ESTRING,POSICION)
RETURN IIF(POSICION>0,ALLTRIM(SUBSTR(ESTRING,1,US_WORDIND(ESTRING,POSICION)-1)+STRTRAN(SUBSTR(ESTRING,US_WORDIND(ESTRING,POSICION)),US_WORD(ESTRING,POSICION)," ",1,1)),ESTRING)

//========================================================================
// FUNCION PARA SABER LA POSICION DE LA PALABRA NUMERO ....
// ESTA FUNCION RETORNA EL BYTE DONDE EMPIEZA LA PALABRA
//========================================================================
FUNCTION US_WORDIND(ESTRING, POSICION)
   LOCAL CONT , ESTR , ESTR2
   if ESTRING == NIL
      ESTRING := ""
   ENDIF
   if us_words( Estring ) < Posicion
      Return ( len( Estring ) + 1 )
//    Return 0
   endif
   CONT := 1
   ESTR := ESTRING
   ESTR2 := RTRIM(ESTRING)
   ESTRING := ALLTRIM(ESTRING)
   DO WHILE .T.
      IF AT(" ",ESTRING) != 0
         IF CONT == POSICION
            RETURN (LEN(ESTR)-(LEN(ESTRING)+(LEN(ESTR)-LEN(ESTR2)))+1)
         ELSE
            ESTRING := ALLTRIM(SUBSTR(ESTRING,AT(" ",ESTRING) + 1))
            CONT := CONT + 1
         ENDIF
      ELSE
         IF POSICION == CONT
            RETURN (LEN(ESTR)-(LEN(ESTRING)+(LEN(ESTR)-LEN(ESTR2)))+1)
         ELSE
            RETURN 0
         ENDIF
      ENDIF
   ENDDO
RETURN 0

//========================================================================
// FUNCION PARA retornar un substr a partir de la posicion de una palabra
//========================================================================
FUNCTION US_WordSubstr( estring , pos )
   if Estring == NIL
      Estring := ""
   endif
RETURN substr( estring , us_wordind( estring , pos ) )

//========================================================================
// FUNCION PARA CONTAR LAS PALABRAS EN UN ESTRING
//========================================================================
FUNCTION US_WORDS(ESTRING)
   LOCAL CONT:=0
   if Estring == NIL
      Estring := ""
   endif
   ESTRING:=ALLTRIM(ESTRING)
   DO WHILE .T.
      IF AT(" ",ESTRING) != 0
         ESTRING:=ALLTRIM(SUBSTR(ESTRING,AT(" ",ESTRING) + 1))
         CONT++
      ELSE
         IF LEN(ESTRING) > 0
            RETURN CONT + 1
         ELSE
            RETURN CONT
         ENDIF
      ENDIF
   ENDDO
RETURN 0

FUNCTION US_VarToStr(X)
   LOCAL T, StringAux:="" , i
   if X == NIL
      X := "*NIL*"
   endif
   T=Valtype(X)
   do case
      case T='C'
         return X
      case T='O'
         return "*OBJ*"
      case T='U'
         return "*UND*"
      case T='M'
         return X
      case T='D'
         StringAux=DTOS(X)
         return StringAux
      case T='N'
         StringAux=US_STRCERO(X)
         return StringAux
      case T='L'
         StringAux=IF(X,'.T.','.F.')
         return StringAux
      case T='A'
         for i:=1 to ( len(x) - 1 )
            StringAux:=StringAux + US_VarToStr( x[i] ) + HB_OSNewLine()
         next
         if len(x) > 0
            StringAux:=StringAux + US_VarToStr( x[len(x)] )
         endif
         return StringAux
   endcase
RETURN ""

FUNCTION US_StrCero(NUM,LONG,DEC)
   LOCAL INDICIO
   IF DEC=NIL
      IF LONG=NIL
         NUM=STR(NUM)
      ELSE
         NUM=STR(NUM,LONG)
      ENDIF
   ELSE
      NUM=STR(NUM,LONG,DEC)
   ENDIF
   LONG=LEN(NUM)
   FOR INDICIO=1 TO LONG
      IF SUBSTR(NUM,INDICIO,1) = " "
         NUM=STUFF(NUM,INDICIO,1,"0")
      ENDIF
   NEXT
RETURN NUM

/* eof */
