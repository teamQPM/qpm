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

FUNCTION MAIN( ... )
   Local aParams := hb_aParams(), n
   Local Version := "01.05", bLoop := .T., cLinea, cFines := { Chr(13) + Chr(10), Chr(10) }, hFiIn, cont := 0, hFiOut
   Local cFileOut, nBytesSalida := 0, cFileIn, cParam, cFileTMP, cmd, cmdbat, bList := .F., gccbat := "_GCCbat.bat"
   Local estado := "_Status.tmp"
   Private cQPMDir := ""

   cParam := ""
   For n := 1 to Len( aParams )
      cParam += ( aParams[ n ] + " " )
   Next n
   cParam := AllTrim( cParam )

   If Upper( US_Word( cParam, 1 ) ) == "-VER" .or. Upper( US_Word( cParam, 1 ) ) == "-VERSION"
      MemoWrit( "US_Slash.version", Version )
      Return .T.
   EndIf

   If Upper( US_Word( cParam, 1 ) ) != "QPM"
      __Run( "ECHO " + "US_Slash 999E: Running Outside System" )
      ERRORLEVEL( 1 )
      Return -1
   Else
      cParam := US_WordDel( cParam, 1 )
   EndIf

   If Upper(SubStr( cParam, 1, 5 ) ) == "-LIST"
      bList := .T.
      cQPMDir := SubStr( US_Word( cParam, 1 ), 6 ) + "\"
      cParam := AllTrim( SubStr( cParam, US_WordInd( cParam, 2 ) ) )
   EndIf
   cFileIn := US_Word( cParam, US_Words( cParam ) - 1 )
   cFileOut := US_Word( cParam, US_Words( cParam ) )
   cFileOut := SubStr( cFileOut, 3 )
   cFileTMP := SubStr( cFileIn, 1, RAt( ".", cFileIn ) ) + "CUS"
   cParam := AllTrim( SubStr( cParam, 1, US_WordInd( cParam, US_Words( cParam ) - 1 ) - 1 ) )
   If bList
      QPM_Log( "US_Slash " + Version )
      QPM_Log( "Slash 000I: by QPM_Support ( https://qpm.sourceforge.io/ )" )
      QPM_Log( "Slash 999I: Log into: " + cQPMDir + "QPM.log" )
      QPM_Log( "Slash 003I: FileIn:   " + cFileIn )
      QPM_Log( "Slash 013I: FileOut:  " + cFileOut )
      QPM_Log( "Slash 023I: FileTMP:  " + cFileTMP )
      QPM_Log( "Slash 033I: Param:    " + cParam )
   EndIf
   hFiIn := FOpen( cFileIn )
   If FError() = 0
      If ( hFiOut := FCreate( cFileTMP ) ) == -1
         QPM_Log( "Slash 011E: Error in creation of File Out (" + AllTrim( Str( Ferror() ) ) + ") " + cFileOut )
         FClose( hFiIn )
         QPM_Log( "" + HB_OsNewLine() )
         Return 12
      EndIf
      Do While bLoop
         If HB_FReadLine( hFiIn, @cLinea, cFines ) != 0
            bLoop := .F.
         EndIf
         cont ++
         If SubStr( cLinea, 1, 6 ) == "#line " .and. ;
            US_Words( cLinea ) > 2 .and. ;
            IsDigit( US_Word( cLinea, 2 ) ) = .T.
            If bList
               QPM_Log( "Slash 004I: Old (" + PadL( AllTrim( Str( cont ) ), 8 ) + ") " + cLinea )
            EndIf
            cLinea := StrTran( cLinea, '\', "\\" )
            If bList
               QPM_Log( "Slash 005I: New (" + PadL( AllTrim( Str( cont ) ), 8 ) + ") " + cLinea )
               QPM_Log( "-----------" )
            EndIf
         EndIf
         cLinea := cLinea + HB_OsNewLine()
         nBytesSalida := Len( cLinea )
         If FWrite( hFiOut, cLinea, nBytesSalida ) < nBytesSalida
            QPM_Log( "Slash 012E: Error in save into Out File (" + AllTrim( Str( FError() ) ) + ") " + cFileOut )
            FClose( hFiIn )
            QPM_Log( "" + HB_OsNewLine() )
            Return 16
         EndIf
      EndDo
      FClose( hFiIn )
      FClose( hFiOut )
   Else
      QPM_Log( "Slash 001E: Error open Input File " + cFileIn )
      QPM_Log( "" + HB_OsNewLine() )
      Return 8
   EndIf
   FErase( cFileIn + ".temporal" )
   FRename( cFileIn, cFileIn + ".temporal" )
   FRename( cFileTMP, cFileIn )
   cmdbat := "GCC.EXE " + cParam + " " + cFileIn + " -o" + cFileOut
   cmd := "@echo off" + HB_OsNewLine() + ;
        cmdbat + HB_OsNewLine() + ;
        "If errorlevel 1 goto bad" + HB_OsNewLine() + ;
        "Echo OK > " + estado + HB_OsNewLine() + ;
        "goto good" + HB_OsNewLine() + ;
        ":bad" + HB_OsNewLine() + ;
        "Echo ERROR > " + estado + HB_OsNewLine() + ;
        ":good" + HB_OsNewLine()
   MemoWrit( GCCbat, cmd )
   If bList
      QPM_Log( "Slash 043I: Command: " + cmdbat )
   EndIf
   __Run( GCCbat )
   FRename( cFileIn, cFileTMP )
   FRename( cFileIn + ".temporal", cFileIn )
   If MemoLine( MemoRead( estado ), 254, 1 ) = "ERROR"
      ERRORLEVEL( 1 )
   EndIf
   FErase( GCCbat )
   FErase( estado )
   If bList
      QPM_Log( "" )
   EndIf
Return .T.

Function QPM_Log( string )
   Local LogArchi, msg

   if empty( string )
      msg := ""
   else
      msg := Dtos( Date() ) + " " + Time() + " Stack(" + AllTrim( Str( US_Stack() ) ) + ") " + ProcName( 1 ) + "(" + StrZero( ProcLine( 1 ), 3, 0 ) + ")" + " " + string
   endif

   SET CONSOLE OFF
   SET ALTERNATE TO ( cQPMDir + "QPM.LOG" ) ADDITIVE
   SET ALTERNATE ON
   ? msg
   SET ALTERNATE OFF
   SET ALTERNATE TO
   SET CONSOLE ON
Return .T.

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

FUNCTION US_Stack()
   LOCAL n := 1
   WHILE ! Empty( ProcName( n ) )
      n++
   ENDDO
RETURN n - 1

/* eof */
