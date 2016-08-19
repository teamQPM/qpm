/*
 * $Id$
 */

/*
 *    QPM - QAC based Project Manager
 *
 *    Copyright 2011-2016 Fernando Yurisich <fernando.yurisich@gmail.com>
 *    http://qpm.sourceforge.net
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
 *    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

#define DBLQT '"'
#define SNGQT "'"

PROCEDURE MAIN( ... )
   Local aParams := hb_aParams(), n
   Local Version := "01.08", bLoop := .T., cLinea := "", cFines := { Chr(13) + Chr(10), Chr(10) }, hFiIn, cont := 0, hFiOut
   Local cFileOut := "", nBytesSalida := 0, cFileIn := "", cParam := "", cPathTMP := "", cLineaAux := "", bList := .F., cWord3 := ""
   Local cApost := '', cRule := "", bForceChg := .F., i := 0, cChar := "", cSlash := "", bChg := .F.
   Local bInclude := .F., cMemoAux, nCantLines, nInx, cAuxLine, cFileInclude, cMemoSal := ""
   Local cMemoError := "", nSize := 256
   Private cQPMDir := ""

   cParam := ""
   For n := 1 To Len( aParams )
      cParam += ( aParams[ n ] + " " )
   Next n
   cParam := AllTrim( cParam )

   If Upper( US_Word( cParam, 1 ) ) == "-VER" .or. Upper( US_Word( cParam, 1 ) ) == "-VERSION"
      MemoWrit( "US_Res.version", Version )
      RETURN
   EndIf

   If Upper( US_Word( cParam, 1 ) ) != "QPM"
      __Run( "ECHO " + "US_Res 999E: Running Outside System" )
      ERRORLEVEL( 1 )
      RETURN
   Else
      cParam := US_WordDel( cParam, 1 )
   EndIf

   If Upper( SubStr( cParam, 1, 5 ) ) == "-LIST"
      bList := .T.
      cQPMDir := SubStr( US_Word( cParam, 1), 6 ) + "\"
      cParam := AllTrim( Substr( cParam, US_WordInd( cParam, 2 ) ) )
   EndIf
   cFileIn := US_Word( cParam, US_Words( cParam ) - 1 )
   cPathTMP := SubStr( cFileIn, 1, RAt( '\', cFileIn ) )
   cFileOut := US_Word( cParam, US_Words( cParam ) )
   cParam := AllTrim( SubStr( cParam, 1, US_WordInd( cParam, US_Words( cParam ) - 1 ) - 1 ) )

   If bList
      QPM_Log( "US_Res " + Version )
      QPM_Log( "US_Res 000I: by QPM_Support ( http://qpm.sourceforge.net )" )
      QPM_Log( "US_Res 999I: Log into: " + cQPMDir + "QPM.log" )
      QPM_Log( "US_Res 003I: FileIn  : " + cFileIn )
      QPM_Log( "US_Res 013I: FileOut : " + cFileOut )
      QPM_Log( "US_Res 043I: Path    : " + cPathTMP )
      QPM_Log( "US_Res 033I: Param   : " + cParam )
   EndIf

   For i = 1 To US_Words( cParam )
      Do Case
      Case Upper( US_Word( cParam, i ) ) = "-FORCE"
         bForceChg := .T.
      Case Upper( US_Word( cParam, i ) ) = "-ONLYINCLUDE"
         bInclude := .T.
      Otherwise
         QPM_Log( "US_Res 201E: Parameter error: " + US_Word( cParam, i) )
         QPM_Log( "" + HB_OsNewLine() )
         ERRORLEVEL( 1 )
         RETURN
      EndCase
   Next i

   FErase( cFileOut )

   If ! File( cFileIn )
      QPM_Log( "US_Res 555E: File not found: " + cFileIn )
      QPM_Log( "" + HB_OsNewLine() )
      ERRORLEVEL( 1 )
      RETURN
   EndIf

   US_FileChar26Zap( cFileIn )

   hFiIn := FOpen( cFileIn )
   If FError() != 0
      US_Log( "US_Res 786E: Error opening file: " + cFileIn )
      QPM_Log( "" + HB_OsNewLine() )
      ERRORLEVEL( 1 )
      RETURN
   EndIf

   If bInclude
      bLoop := .T.
      nInx := 0
      Do While bLoop
         nInx ++
         If HB_FReadLine( hFiIn, @cAuxLine, cFines ) != 0
            bLoop := .F.
         EndIf
         If Upper( US_Word( cAuxLine, 1 ) ) == "#INCLUDE"
            cFileInclude := US_WordSubStr( cAuxLine, 2 )
            cFileInclude := AllTrim( StrTran( StrTran( cFileInclude, DBLQT, "" ), SNGQT, "" ) )
            If ! File( cFileInclude )
               cMemoSal := cMemoSal + If( nInx > 1, HB_OsNewLine(), "" ) + '// --- File not found !!! ' + cAuxLine
               cMemoError := cMemoError + "Error: Line " + AllTrim( Str( nInx ) ) + ", #INCLUDE file not found: " + cAuxLine + HB_OsNewLine()
               QPM_Log( "US_Res 875E: #INCLUDE file not found: " + cAuxLine )
               QPM_Log( "" + HB_OsNewLine() )
            Else
               cMemoSal := cMemoSal + If( nInx > 1, HB_OsNewLine(), "" ) + "// " + Replicate( "=", 80 )
               cMemoSal := cMemoSal + HB_OsNewLine() + "// INI - #INCLUDE file: " + cFileInclude
               cMemoSal := cMemoSal + HB_OsNewLine() + "// " + Replicate( "-", 80 )
               cMemoSal := cMemoSal + HB_OsNewLine() + MemoRead( cFileInclude )
               cMemoSal := cMemoSal + HB_OsNewLine() + "// " + Replicate( "-", 80 )
               cMemoSal := cMemoSal + HB_OsNewLine() + "// END - #INCLUDE file: " + cFileInclude
               cMemoSal := cMemoSal + HB_OsNewLine() + "// " + Replicate( "=", 80 )
            EndIf
         Else
            cMemoSal := cMemoSal + If( nInx > 1, HB_OsNewLine(), "" ) + cAuxLine
         EndIf
      EndDo
      FClose( hFiIn )
      HB_Memowrit( cFileOut, cMemoSal )
      If Len( cMemoError ) > 0
         HB_Memowrit( cFileOut + ".Error", "Processing #INCLUDE of RC file: " + cFileIn + HB_OsNewLine() + cMemoError )
         ERRORLEVEL( 1 )
      EndIf
      RETURN
   EndIf

   // -FORCE of NONE
   If ( hFiOut := FCreate( cFileOut ) ) == -1
      QPM_Log( "US_Res 011E: Error (" + AllTrim( Str( FError() ) ) + ") creating file: " + cFileOut )
      FClose( hFiIn )
      QPM_Log( "" + HB_OsNewLine() )
      ERRORLEVEL( 1 )
      RETURN
   EndIf

   Do While bLoop
      If HB_FReadLine( hFiIn, @cLinea, cFines ) != 0
         bLoop := .F.
      EndIf
      cont ++
      bChg := .F.
      cLinea := AllTrim( StrTran( cLinea, Chr( 09 ), " " ) )

      // #define
      If SubStr( cLinea, 1, 1 ) == "#" .and. SubStr( cLinea, 1, 7 ) == "#define"
         // Do not change it, just copy to output

      // One line comment or some reserved words
      ElseIf SubStr( cLinea, 1, 1 ) == "*" .or. ;
         ( SubStr( cLinea, 1, 1 ) == "#" .and. SubStr( cLinea, 1, 7 ) != "#define" ) .or. ;
         SubStr( cLinea, 1, 2 ) == "//" .or. ;
         SubStr( cLinea, 1, 2 ) == "&&" .or. ;
         US_Words( cLinea ) < 3 .or. ;
         Upper( US_Word( cLinea, 1 ) ) == "BLOCK" .or. ;
         Upper( US_Word( cLinea, 1 ) ) == "VALUE" .or. ;
         Upper( US_Word( cLinea, 1 ) ) == "POPUP" .or. ;
         Upper( US_Word( cLinea, 2 ) ) == "ACCELERATORS" .or. ;
         Upper( US_Word( cLinea, 2 ) ) == "DIALOG" .or. ;
         Upper( US_Word( cLinea, 2 ) ) == "DIALOGEX" .or. ;
         Upper( US_Word( cLinea, 2 ) ) == "FONT" .or. ;
         Upper( US_Word( cLinea, 2 ) ) == "MENU" .or. ;
         Upper( US_Word( cLinea, 2 ) ) == "MENUEX" .or. ;
         Upper( US_Word( cLinea, 2 ) ) == "RCDATA" .or. ;
         Upper( US_Word( cLinea, 2 ) ) == "STRINGTABLE" .or. ;
         Upper( US_Word( cLinea, 2 ) ) == "PLUGPLAY" .or. ;
         Upper( US_Word( cLinea, 2 ) ) == "TEXTINCLUDE" .or. ;
         Upper( US_Word( cLinea, 2 ) ) == "VERSIONINFO" .or. ;
         Upper( US_Word( cLinea, 2 ) ) == "VXD"
         If bList
            QPM_Log( "US_Res 234I: Comment (" + AllTrim( Str( cont ) ) + "): " + cLinea )
            QPM_Log( "------------" )
         EndIf

      // Multiple lines comment
      ElseIf SubStr( cLinea, 1, 1 ) == "/*"
         Do While bLoop
            If bList
               QPM_Log( "US_Res 234I: Comment (" + AllTrim( Str( cont ) ) + "): " + cLinea )
               QPM_Log( "------------" )
            EndIf
            // Copy to output
            cLinea := cLinea + HB_OsNewLine()
            nBytesSalida := Len( cLinea )
            If FWrite( hFiOut, cLinea, nBytesSalida ) < nBytesSalida
               QPM_Log( "US_Res 012E: Error (" + AllTrim( Str( FError() ) ) + ") writing to file: " + cFileOut )
               FClose( hFiIn )
               QPM_Log( "" + HB_OsNewLine() )
               ERRORLEVEL( 1 )
               RETURN
            EndIf
            // Read next
            If HB_FReadLine( hFiIn, @cLinea, cFines ) != 0
               bLoop := .F.
            EndIf
            cont ++
            bChg := .F.
            cLinea := AllTrim( StrTran( cLinea, Chr( 09 ), " " ) )
            // Check for comment's end
            If SubStr( cLinea, 1, 1 ) == "*/"
               If bList
                  QPM_Log( "US_Res 234I: Comment (" + AllTrim( Str( cont ) ) + "): " + cLinea )
                  QPM_Log( "------------" )
               EndIf
               Exit
            EndIf
         EndDo

      // resources
      Else
         Do Case
         // For: ..\resources\main.ico
         Case SubStr( US_Word( cLinea, 3 ), 1, 2 ) == '..\' .or. ;
              SubStr( US_Word( cLinea, 3 ), 1, 2 ) == '../'
            cLineaAux := cLinea
            cRule := "R02"
            cWord3 := US_Word( cLinea, 3 )
            cLinea := SubStr( cLinea, 1, US_WordInd( cLinea, 3 ) - 1 ) + cApost + cPathTMP + US_WSlash( cWord3 ) + cApost
            bChg := .T.
         // For: .\resources\main.ico
         Case SubStr( US_Word( cLinea, 3 ), 1, 2 ) == '.\' .or. ;  
              SubStr( US_Word( cLinea, 3 ), 1, 2 ) == './'         
            cLineaAux := cLinea
            cRule := "R01"
            cWord3 := US_Word( SubStr( cLinea, US_WordInd( cLinea, 3 ) + 2 ), 1 )
            cLinea := SubStr( cLinea, 1, US_WordInd( cLinea, 3 ) - 1 ) + cApost + cPathTMP + US_WSlash( cWord3 ) + cApost
            bChg := .T.
/*
         // For: main.ico
         Case !( At( ':\', US_Word( cLinea, 3 ) ) > 0 ) .and. ;
              !( At( ':/', US_Word( cLinea, 3 ) ) > 0 ) .and. ;
              SubStr( US_Word( cLinea, 3 ), 1, 1 ) != SNGQT .and. ;
              SubStr( US_Word( cLinea, 3 ), 1, 1 ) != DBLQT
            cLineaAux := cLinea
            cRule := "R03"
            cWord3 := US_Word( SubStr( cLinea, US_WordInd( cLinea, 3 ) ), 1 )
            cLinea := SubStr( cLinea, 1, US_WordInd( cLinea, 3 ) - 1 ) + cApost + cPathTMP + US_WSlash( cWord3 ) + cApost
            bChg := .T.
         // For: 'main.ico'
         Case !( at( ':\', US_Word( cLinea, 3 ) ) > 0 ) .and. ;
              !( at( ':/', US_Word( cLinea, 3 ) ) > 0 ) .and. ;
              SubStr( US_Word( cLinea, 3 ), 1, 1 ) = SNGQT
            cLineaAux := cLinea
            cRule := "R04"
            cWord3 := SubStr( cLinea, US_WordInd( cLinea, 3 ) + 1, at( SNGQT, SubStr( cLinea, US_WordInd( cLinea, 3 ) + 1 ) ) - 1 )
            cLinea := SubStr( cLinea, 1, US_WordInd( cLinea, 3 ) - 1 ) + cApost + cPathTMP + US_WSlash( cWord3 ) + cApost
            bChg := .T.
         // For: "main.ico"
         Case !( At( ':\', US_Word( cLinea, 3 ) ) > 0 ) .and. ;
              !( At( ':/', US_Word( cLinea, 3 ) ) > 0 ) .and. ;
              SubStr( US_Word( cLinea, 3 ), 1, 1 ) = DBLQT
            cLineaAux := cLinea
            cRule := "R05"
            cWord3 := SubStr( cLinea, US_WordInd( cLinea, 3 ) + 1, at( DBLQT, SubStr( cLinea, US_WordInd( cLinea, 3 ) + 1 ) ) - 1 )
            cLinea := SubStr( cLinea, 1, US_WordInd( cLinea, 3 ) - 1 ) + cApost + cPathTMP + US_WSlash( cWord3 ) + cApost
            bChg := .T.
*/
         EndCase

         If bForceChg .and. ( At( ':\', US_Word( cLinea, 3 ) ) = 2 .or. ;
                              At( ":/", US_Word( cLinea, 3 ) ) = 2 )
            cLineaAux := cLinea
            cRule := "R10 forced"
            cSlash := SubStr( US_Word( cLinea, 3 ), 3, 1 )
            cWord3 := US_Word( SubStr( cLinea, US_WordInd( cLinea, 3 ) ), 1 )
            cWord3 := SubStr( cWord3, RAt( cSlash, cWord3 ) + 1 )
            cLinea := SubStr( cLinea, 1, US_WordInd( cLinea, 3 ) - 1 ) + cApost + cPathTMP + cWord3 + cApost
            bChg := .T.
         EndIf
         If bForceChg .and. ( At( ':\', US_Word( cLinea, 3 ) ) = 3 .or. ;
                              At( ":/", US_Word( cLinea, 3 ) ) = 3 ) .and. ;
            ( At( SNGQT, US_Word( cLinea, 3 ) ) = 1 .or. ;
              At( DBLQT, US_Word( cLinea, 3 ) ) = 1 )
            cLineaAux := cLinea
            cRule := "R11 forced"
            cSlash := SubStr( US_Word( cLinea, 3 ), 4, 1 )
            cChar := SubStr( US_Word( cLinea, 3 ), 1, 1 )
            cWord3 := US_Word( SubStr( cLinea, US_WordInd( cLinea, 3 ) + 1 ), 1 )
            cWord3 := SubStr( cWord3, RAt( cSlash, cWord3 ) + 1 )
            cWord3 := SubStr( cWord3, 1, RAt( cChar, cWord3 ) - 1 )
            cLinea := SubStr( cLinea, 1, US_WordInd( cLinea, 3 ) - 1 ) + cApost + cPathTMP + cWord3 + cApost
            bChg := .T.
         EndIf

         If bList
            If bChg
               QPM_Log( "US_Res 004I: Old (" + PadL( AllTrim( Str( cont ) ), 8 ) + "): " + cLineaAux )
               QPM_Log( "US_Res 234I: Resource rule " + cRule + " > " + cWord3 )
               QPM_Log( "US_Res 005I: New (" + PadL( AllTrim( Str( cont ) ), 8 ) + "): " + cLinea )
               QPM_Log( "------------" )
               cLineaAux := ""
            Else
               QPM_Log( "US_Res 444I: Without change (" + AllTrim( Str( cont ) ) + "): " + cLinea )
               QPM_Log( "------------" )
            EndIf
         EndIf
      EndIf

      cLinea := cLinea + HB_OsNewLine()
      nBytesSalida := Len( cLinea )
      If FWrite( hFiOut, cLinea, nBytesSalida ) < nBytesSalida
         QPM_Log( "US_Res 012E: Error (" + AllTrim( Str( FError() ) ) + ") writing to file: " + cFileOut )
         FClose( hFiIn )
         FClose( hFiOut )
         QPM_Log( "" + HB_OsNewLine() )
         ERRORLEVEL( 1 )
         RETURN
      EndIf
   EndDo
   FClose( hFiIn )
   FClose( hFiOut )
   US_FileChar26Zap( cFileOut )
   If bList
      QPM_Log( "" + HB_OsNewLine() )
   EndIf
RETURN

STATIC FUNCTION QPM_Log( string )
   Local LogArchi := cQPMDir + "QPM.LOG"
   Local msg := Dtos( Date() ) + " " + Time() + " Stack(" + AllTrim( Str( US_Stack() ) ) + ") " + ProcName( 1 ) + "(" + AllTrim( Str( ProcLine( 1 ) ) ) + ")" + " " + string

   SET CONSOLE OFF
   SET ALTERNATE TO ( LogArchi ) ADDITIVE
   SET ALTERNATE ON
   ? msg
   SET ALTERNATE OFF
   SET ALTERNATE TO
   SET CONSOLE ON
RETURN .T.

/*
STATIC FUNCTION US_Word( estring, pos )
   LOCAL cont := 1, nDonde
   IF pos == NIL
      pos := 1
   ENDIF
   estring := ALLTRIM( estring )
   DO WHILE .T.
      IF LEFT( estring, 1 ) == DBLQT
         IF ( nDonde := AT( DBLQT, SUBSTR( estring, 2 ) ) ) == 0
            IF cont == pos
               RETURN estring
            ELSE
               EXIT
            ENDIF
         ELSE
            IF cont == pos
               RETURN ALLTRIM( SUBSTR( estring, 2, nDonde - 1 ) )
            ELSE
               estring := ALLTRIM( SUBSTR( estring, nDonde + 1 ) )
               cont ++
            ENDIF
         ENDIF
      ELSE
         IF (nDonde := AT( " ", estring ) ) == 0
            IF cont == pos
               RETURN estring
            ELSE
               EXIT
            ENDIF
         ELSE
            IF cont == pos
               RETURN SUBSTR( estring, 1, nDonde - 1 )
            ELSE
               estring := ALLTRIM( SUBSTR( estring, nDonde + 1 ) )
               cont ++
            ENDIF
         ENDIF
      ENDIF
   ENDDO
RETURN ""

STATIC FUNCTION US_WordInd( estring, pos )
   LOCAL cont := 1, estrtrm
   IF estring == NIL
      estring := ""
   ENDIF
   IF US_Words( estring ) < pos
      RETURN ( LEN( estring ) + 1 )
   ENDIF
   estrtrm := RTRIM( estring )
   estring := ALLTRIM( estring )       
   DO WHILE .T.
      IF LEFT( estring, 1 ) == DBLQT
         IF ( nDonde := AT( DBLQT, SUBSTR( estring, 2 ) ) ) == 0
            IF cont == pos
               RETURN ( LEN(estrtrm) - LEN(estring) + 2 )
            ELSE
               EXIT
            ENDIF
         ELSE
            IF cont == pos
               RETURN ( LEN(estrtrm) - LEN(estring) + 2 )
            ELSE
               estring := ALLTRIM( SUBSTR( estring, nDonde + 1 ) )
               cont ++
            ENDIF
         ENDIF
      ELSE
         IF (nDonde := AT( " ", estring ) ) == 0
            IF cont == pos
               RETURN ( LEN(estrtrm) - LEN(estring) + 1 )
            ELSE
               EXIT
            ENDIF
         ELSE
            IF cont == pos
               RETURN ( LEN(estrtrm) - LEN(estring) + 1 )
            ELSE
               estring := ALLTRIM( SUBSTR( estring, nDonde + 1 ) )
               cont ++
            ENDIF
         ENDIF
      ENDIF
   ENDDO
RETURN 0

STATIC FUNCTION US_WordDel( estring, pos )
LOCAL ret
   IF pos > 0
      ret := ALLTRIM( SUBSTR( estring, 1, US_WordInd( estring, pos ) - 1 ) + STRTRAN( SUBSTR( estring, US_WordInd( estring, pos ) ), US_Word( estring, pos ), " " , 1 , 1 ) )
   ELSE
      ret := estring
   ENDIF
RETURN ret

STATIC FUNCTION US_Words( estring )
   LOCAL cont := 0, nDonde
   IF estring # NIL
      estring := ALLTRIM( estring )
      DO WHILE ! EMPTY( estring )
         IF LEFT( estring, 1 ) == DBLQT
            cont ++
            IF ( nDonde := AT( DBLQT, SUBSTR( estring, 2 ) ) ) == 0
               EXIT
            ENDIF
            estring := ALLTRIM( SUBSTR( estring, nDonde + 1 ) )
            IF EMPTY( estring )
               EXIT
            ENDIF
         ELSE
            cont ++
            IF (nDonde := AT( " ", estring ) ) == 0
               EXIT
            ENDIF
            estring := ALLTRIM( SUBSTR( estring, nDonde + 1 ) )
         ENDIF
      ENDDO
   ENDIF
RETURN cont

STATIC FUNCTION US_WordSubstr( estring, pos )
   IF estring == NIL
      estring := ""
   ENDIF
RETURN SUBSTR( estring, US_WordInd( estring, pos ) )
*/

/* eof */
