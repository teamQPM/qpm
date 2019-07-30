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

#include "FuentesComunes\US_Env.h"
#include "fileio.ch"

#define DBLQT '"'
#define SNGQT "'"

PROCEDURE MAIN( ... )
   Local aParams := hb_aParams(), n
   Local Version := "01.09", bLoop := .T., cLinea := "", cFines := { Chr(13) + Chr(10), Chr(10) }, hFiIn, cont := 0, hFiOut
   Local cFileOut, nBytesSalida := 0, cFileIn, cParam, cPathSHR, cPathTMP, cLineaAux := "", bList := .F., cWord3 := ""
   Local cRule := "", bForceChg := .F., i, cChar, cSlash, bChg := .F., bFound := .F.
   Local bInclude := .F., cMemoAux, nCantLines, nInx, cAuxLine, cFileInclude, cMemoSal
   Local cMemoError := "", nSize := 256
   Private cQPMDir := ""

   cParam := ""
   n := Len( aParams )
   For i := 1 To n - 2
      cParam += ( aParams[ i ] + " " )
   Next i
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
   cPathTMP := aParams[ n - 1 ]
   cFileIn := US_Word( cParam, US_Words( cParam ) - 1 )
   cPathSHR := aParams[ n ]
   cFileOut := US_Word( cParam, US_Words( cParam ) )
   cParam := AllTrim( SubStr( cParam, 1, US_WordInd( cParam, US_Words( cParam ) - 1 ) - 1 ) )

   If bList
      QPM_Log( "US_Res " + Version )
      QPM_Log( "US_Res 000I: by QPM_Support ( https://qpm.sourceforge.io/ )" )
      QPM_Log( "US_Res 999I: Log into: " + cQPMDir + "QPM.log" )
      QPM_Log( "US_Res 003I: FileIn  : " + cFileIn )
      QPM_Log( "US_Res 013I: FileOut : " + cFileOut )
      QPM_Log( "US_Res 043I: Path    : " + cPathTMP )
      QPM_Log( "US_Res 053I: PathShrt: " + cPathSHR )
      QPM_Log( "US_Res 033I: Param   : " + cParam + hb_osNewLine() )
   EndIf

   For i := 1 To US_Words( cParam )
      Do Case
      Case Upper( US_Word( cParam, i ) ) = "-FORCE"
         bForceChg := .T.
      Case Upper( US_Word( cParam, i ) ) = "-ONLYINCLUDE"
         bInclude := .T.
      Otherwise
         QPM_Log( "US_Res 201E: Parameter error: " + US_Word( cParam, i) + hb_osNewLine() )
         ErrorLevel( 1 )
         RETURN
      EndCase
   Next i

   If ! File( cFileIn )
      QPM_Log( "US_Res 555E: File not found: " + cFileIn + hb_osNewLine() )
      ErrorLevel( 1 )
      RETURN
   EndIf

   US_FileChar26Zap( cFileIn )
   hFiIn := FOpen( cFileIn )
   If FError() != 0
      QPM_Log( "US_Res 786E: Error opening file: " + cFileIn + hb_osNewLine() )
      ErrorLevel( 1 )
      RETURN
   EndIf

   If bInclude
      // -ONLYINCLUDE
      cMemoSal := ""
      bLoop := .T.
      nInx := 0
      // Loop through the lines of the auxiliary file replacing every #include with its lines
      Do While bLoop
         nInx ++
         If hb_fReadLine( hFiIn, @cAuxLine, cFines ) != 0
            bLoop := .F.
         EndIf
         If Upper( US_Word( cAuxLine, 1 ) ) == "#INCLUDE"
            cFileInclude := US_WordSubStr( cAuxLine, 2 )
            cFileInclude := AllTrim( StrTran( StrTran( cFileInclude, DBLQT, "" ), SNGQT, "" ) )
            If ! File( cFileInclude )
               cMemoSal := cMemoSal + If( nInx > 1, hb_osNewLine(), "" ) + '// --- File not found !!! ' + cAuxLine
               cMemoError := cMemoError + "Error: Line " + AllTrim( Str( nInx ) ) + ", #INCLUDE file not found: " + cAuxLine + hb_osNewLine()
               QPM_Log( "US_Res 875E: #INCLUDE file not found: " + cAuxLine + hb_osNewLine() )
            Else
               cMemoSal := cMemoSal + If( nInx > 1, hb_osNewLine(), "" ) + "// " + Replicate( "=", 80 )
               cMemoSal := cMemoSal + hb_osNewLine() + "// INI - #INCLUDE file: " + cFileInclude
               cMemoSal := cMemoSal + hb_osNewLine() + "// " + Replicate( "-", 80 )
               cMemoSal := cMemoSal + hb_osNewLine() + MemoRead( cFileInclude )
               cMemoSal := cMemoSal + hb_osNewLine() + "// " + Replicate( "-", 80 )
               cMemoSal := cMemoSal + hb_osNewLine() + "// END - #INCLUDE file: " + cFileInclude
               cMemoSal := cMemoSal + hb_osNewLine() + "// " + Replicate( "=", 80 ) + hb_osNewLine()
               bFound := .T.
            EndIf
         Else
            cMemoSal := cMemoSal + If( nInx > 1, hb_osNewLine(), "" ) + cAuxLine
         EndIf
      EndDo
      FClose( hFiIn )
      // Check for errors
      If Empty( cMemoError )
         // Save new text to output file, exit loop and return
         MemoWrit( cFileOut, cMemoSal )
         ErrorLevel( 0 )
      Else
         MemoWrit( cFileOut + ".Error", "Processing #INCLUDE of RC file: " + cFileIn + hb_osNewLine() + cMemoError )
         ErrorLevel( 1 )
      EndIf
   Else
      // -FORCE of NONE
      If ( hFiOut := FCreate( cFileOut ) ) == -1
         QPM_Log( "US_Res 011E: Error (" + AllTrim( Str( FError() ) ) + ") creating file: " + cFileOut + hb_osNewLine() )
         FClose( hFiIn )
         ErrorLevel( 1 )
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
               cLinea := cLinea + hb_osNewLine()
               nBytesSalida := Len( cLinea )
               If FWrite( hFiOut, cLinea, nBytesSalida ) < nBytesSalida
                  QPM_Log( "US_Res 012E: Error (" + AllTrim( Str( FError() ) ) + ") writing to file: " + cFileOut + hb_osNewLine()  + hb_osNewLine() )
                  FClose( hFiIn )
                  ErrorLevel( 1 )
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
            Case SubStr( US_Word( cLinea, 3 ), 1, 3 ) == '..\' .or. ;
                 SubStr( US_Word( cLinea, 3 ), 1, 3 ) == '../'
               cLineaAux := cLinea
               cRule := "R02"
               cWord3 := US_Word( cLinea, 3 )
               If cPathSHR == "S"
                  cLinea := SubStr( cLinea, 1, US_WordInd( cLinea, 3 ) - 1 ) + US_ShortName( cPathTMP + US_WSlash( cWord3 ) )
               Else
                  cLinea := SubStr( cLinea, 1, US_WordInd( cLinea, 3 ) - 1 ) + cPathTMP + US_WSlash( cWord3 )
               EndIf
               bChg := .T.
            // For: .\resources\main.ico
            Case SubStr( US_Word( cLinea, 3 ), 1, 2 ) == '.\' .or. ;
                 SubStr( US_Word( cLinea, 3 ), 1, 2 ) == './'
               cLineaAux := cLinea
               cRule := "R01"
               cWord3 := US_Word( SubStr( cLinea, US_WordInd( cLinea, 3 ) + 2 ), 1 )
               If cPathSHR == "S"
                  cLinea := SubStr( cLinea, 1, US_WordInd( cLinea, 3 ) - 1 ) + US_ShortName( cPathTMP + US_WSlash( cWord3 ) )
               Else
                  cLinea := SubStr( cLinea, 1, US_WordInd( cLinea, 3 ) - 1 ) + cPathTMP + US_WSlash( cWord3 )
               EndIf
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
               If cPathSHR == "S"
                  cLinea := SubStr( cLinea, 1, US_WordInd( cLinea, 3 ) - 1 ) + US_ShortName( cPathTMP + US_WSlash( cWord3 ) )
               Else
                  cLinea := SubStr( cLinea, 1, US_WordInd( cLinea, 3 ) - 1 ) + cPathTMP + US_WSlash( cWord3 )
               EndIf
               bChg := .T.
            // For: 'main.ico'
            Case !( at( ':\', US_Word( cLinea, 3 ) ) > 0 ) .and. ;
                 !( at( ':/', US_Word( cLinea, 3 ) ) > 0 ) .and. ;
                 SubStr( US_Word( cLinea, 3 ), 1, 1 ) = SNGQT
               cLineaAux := cLinea
               cRule := "R04"
               cWord3 := SubStr( cLinea, US_WordInd( cLinea, 3 ) + 1, at( SNGQT, SubStr( cLinea, US_WordInd( cLinea, 3 ) + 1 ) ) - 1 )
               If cPathSHR == "S"
                  cLinea := SubStr( cLinea, 1, US_WordInd( cLinea, 3 ) - 1 ) + US_ShortName( cPathTMP + US_WSlash( cWord3 ) )
               Else
                  cLinea := SubStr( cLinea, 1, US_WordInd( cLinea, 3 ) - 1 ) + cPathTMP + US_WSlash( cWord3 )
               EndIf
               bChg := .T.
            // For: "main.ico"
            Case !( At( ':\', US_Word( cLinea, 3 ) ) > 0 ) .and. ;
                 !( At( ':/', US_Word( cLinea, 3 ) ) > 0 ) .and. ;
                 SubStr( US_Word( cLinea, 3 ), 1, 1 ) = DBLQT
               cLineaAux := cLinea
               cRule := "R05"
               cWord3 := SubStr( cLinea, US_WordInd( cLinea, 3 ) + 1, at( DBLQT, SubStr( cLinea, US_WordInd( cLinea, 3 ) + 1 ) ) - 1 )
               If cPathSHR == "S"
                  cLinea := SubStr( cLinea, 1, US_WordInd( cLinea, 3 ) - 1 ) + US_ShortName( cPathTMP + US_WSlash( cWord3 ) )
               Else
                  cLinea := SubStr( cLinea, 1, US_WordInd( cLinea, 3 ) - 1 ) + cPathTMP + US_WSlash( cWord3 )
               EndIf
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
               If cPathSHR == "S"
                  cLinea := SubStr( cLinea, 1, US_WordInd( cLinea, 3 ) - 1 ) + US_ShortName( cPathTMP + cWord3 )
               Else
                  cLinea := SubStr( cLinea, 1, US_WordInd( cLinea, 3 ) - 1 ) + cPathTMP + cWord3
               EndIf
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
               If cPathSHR == "S"
                  cLinea := SubStr( cLinea, 1, US_WordInd( cLinea, 3 ) - 1 ) + US_ShortName( cPathTMP + cWord3 )
               Else
                  cLinea := SubStr( cLinea, 1, US_WordInd( cLinea, 3 ) - 1 ) + cPathTMP + cWord3
               EndIf
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

         cLinea := cLinea + hb_osNewLine()
         nBytesSalida := Len( cLinea )
         If FWrite( hFiOut, cLinea, nBytesSalida ) < nBytesSalida
            QPM_Log( "US_Res 012E: Error (" + AllTrim( Str( FError() ) ) + ") writing to file: " + cFileOut + hb_osNewLine() )
            FClose( hFiIn )
            FClose( hFiOut )
            ErrorLevel( 1 )
            RETURN
         EndIf
      EndDo
      FClose( hFiIn )
      FClose( hFiOut )
      US_FileChar26Zap( cFileOut )
      If bList
         QPM_Log( hb_osNewLine() )
      EndIf
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
   LOCAL CONT, ESTR, ESTR2
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
FUNCTION US_WordSubstr( estring, pos )
   if Estring == NIL
      Estring := ""
   endif
RETURN substr( estring, us_wordind( estring, pos ) )

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
   LOCAL T, StringAux:="", i
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
            StringAux:=StringAux + US_VarToStr( x[i] ) + hb_osNewLine()
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

Function US_WSlash( arc )
Return strtran( arc, "/", "\" )

Function US_FileSize(cFile)
   Local vFile
   vFile:=DIRECTORY( cFile, "HS" )
   if len(vFile) = 1
      Return vFile[1][2]
   endif
Return -1

Function US_Stack()
Local n:=1
   WHILE ! Empty( ProcName( n ) )
      n++
   ENDDO
Return n - 1

//========================================================================
// Funcion para eliminar el caracter x'1A' que deja el MemoWrit al final del campo generado
// Retorna: 0 si el caracter no existe (no hace nada)
//          1 si pudo reemplazar el caracter
//          -1 si se produjo algun problema
//------------------------------------------------------------------------
Function US_FileChar26Zap( cFile )
   Local nHndIn, reto := -1, cAux := " ", cLinea := Space( 1024 ), nLeidosTotal, nLenFileOut, nLeidosLoop
   Local cFileOut := US_FileNameOnlyPathAndName( cFile ) + "_T" + AllTrim( Str( Int( Seconds() ) ) ) + "." + US_FileNameOnlyExt( cFile )
   Local nHndOut
   nHndIn := FOpen( cFile, FO_READWRITE )
   FSeek( nHndIn, -1, 2 )
   if FRead( nHndIn, @cAux, 1 ) == 1
      if cAux == Chr( 26 )
         FSeek( nHndIn, 0, 0 )
         nLeidosTotal := 0
         if ( nHndOut := FCreate( cFileOut ) ) >= 0
            nLenFileOut :=  US_FileSize( cFile ) - 1
            do while ( nLeidosLoop := FRead( nHndIn, @cLinea, if( ( nLenFileOut - nLeidosTotal ) > 1024, 1024, nLenFileOut - nLeidosTotal ) ) ) > 0
               nLeidosTotal := nLeidosTotal + nLeidosLoop
               if FWrite( nHndOut, cLinea, nLeidosLoop ) != nLeidosLoop
                  FClose( nHndIn )
                  FClose( nHndOut )
                  QPM_Log( "Error writing output file '" + cFileOut + "'" + hb_osNewLine() )
                  RETURN -1
               endif
            enddo
            FClose( nHndOut )
         else
            FClose( nHndIn )
            QPM_Log( "Error creating file '" + cFileOut + "', fError=" + US_VarToStr( FError() ) + hb_osNewLine() )
            RETURN -1
         endif
         reto := 1
      else
         reto := 0
      endif
   endif
   FClose( nHndIn )
   if reto == 1
      FErase( cFile )
      FRename( cFileOut, cFile )
   endif
RETURN Reto

Function US_FileNameOnlyExt( arc )
   arc := substr( arc, rat( DEF_SLASH, arc ) + 1 )
   if US_IsDirectory( arc )
      Return ""
   endif
   if rat( ".", arc ) == 0
      return ""
   endif
return substr( arc, rat( ".", arc ) + 1 )

Function US_FileNameOnlyName( arc )
   Local barra, punto, reto
   if arc == NIL
      arc := ""
   endif
   barra:=rat( DEF_SLASH, arc )
   punto:=rat( ".", arc )
   do case
      case punto > barra
         reto := substr( arc, barra + 1, punto - barra - 1 )
      case punto = 0
         reto := substr( arc, barra + 1 )
      case punto < barra
         reto := substr( arc, barra + 1 )
   endcase
Return reto

Function US_FileNameOnlyPath( arc )
   if arc == NIL
      Return ""
   endif
   if US_IsDirectory( arc )
      return arc
   endif
Return substr( arc, 1, rat( DEF_SLASH, arc ) - 1 )

Function US_FileNameOnlyPathAndName( arc )
   Local cPath := US_FileNameOnlyPath( arc ), cName := US_FileNameOnlyName( arc )
Return cPath + if( !empty( cPath ) .and. !empty( cName ), DEF_SLASH, "" ) + cName

Function US_FileNameOnlyNameAndExt( arc )
   Local cExt := US_FileNameOnlyExt( arc )
Return US_FileNameOnlyName( arc ) + if( !empty( cExt ), ".", "" ) + cExt

Function US_IsDirectory( Dire )
Return IsDirectory( Dire )

Function US_ShortName( nombre )
   Local Reto
   /* INI parche para parentesis por make GCC */
// if at( "(", Reto ) > 0 .or. ;
//    at( ")", Reto ) > 0 .or. ;
//    at( "&", Reto ) > 0 .or. ;
//    at( "'", Reto ) > 0
//    MsgStop( "This name: "+nombre+hb_osNewLine()+"don't work correctly with make utility. Please, use a name without parenthesis characters.", NIL, NIL, .F. )  // this is not translated
//    Reto := ""
// endif
   /* FIN parche para parentesis por make GCC */
   if US_IsDirectory( nombre )
      Reto := US_GetShortPathName( nombre )
   else
      Reto := US_GetShortFileName( nombre )
   endif
   /* ini parche para Novell */
   if Reto == ""
      return Reto
   endif
   if At( Chr( 0 ), Reto ) > 0
      if us_words( nombre ) > 1
         MsgInfo( "Name: " + nombre + hb_osNewLine() + "includes spaces, it won't work correctly with Novell. Please, use a name without spaces.",  NIL,  NIL,  .F. )
         Reto := ""
      else
         Reto := nombre
      endif
   else
      if US_IsDirectory( nombre ) .and. ! US_IsDirectory( Reto )
         MsgStop( "The name: " + nombre + hb_osNewLine() + ;
                  "was translated by the OS to a name that's not valid for a folder:" + hb_osNewLine() + ;
                  Reto + hb_osNewLine() + ;
                  "Please, use a name that follows the 8.3 convention.", NIL, NIL, .F. )  // this is not translated
         Reto := ""
      elseif File( nombre ) .and. ! File( Reto )
         MsgStop( "The name: " + nombre + hb_osNewLine() + ;
                  "was translated by the OS to ahb_osNewLine name that's not valid for a file:" + hb_osNewLine() + ;
                  Reto + hb_osNewLine() + ;
                  "Please, use a name that follows the 8.3 convention.", NIL, NIL, .F. )  // this is not translated
         Reto := ""
      endif
   endif
   /* fin parche para Novell */
   /* INI parche para parentesis */
   if At( "(", Reto ) > 0
      MsgStop( "This name doesn't work correctly: " + nombre + hb_osNewLine() + ;
               "Please, use a name without parenthesis characters.", NIL, NIL, .F. )  // this is not translated
      Reto := ""
   endif
   /* FIN parche para parentesis */
Return Reto

Function US_GetShortPathName( cPath )
   Local tmp, cFileTMP := US_FileTMP( cPath + iif( Right( cPath, 1 ) != DEF_SLASH, DEF_SLASH, '' ) + "_Path" )
   MemoWrit( cFileTMP, "Temp from " + ProcName() )
   tmp := US_GetShortFileName( cFileTMP )
   tmp := US_FileNameOnlyPath( tmp )
   FErase( cFileTMP )
Return tmp

Function US_GetShortFileName( cPath )
   Local sShortPathName:=""
   if File( cPath )
      USAUX_GETSHORTPATHNAME( cPath, @sShortPathName )
   endif
Return sShortPathName

Function US_FileTmp( prefix )
   Local cFile
   if Empty( prefix )
      prefix := "_Temp"
   endif
   do while .t.
      cFile := prefix +US_NameRandom() + ".tmp"
      if ! File( cFile )
         exit
      endif
   enddo
return cFile

Function US_NameRandom()
Return AllTrim( StrTran( StrTran( Str( Seconds() ), ".", AllTrim( Str( US_Rand( Seconds() ) ) ) ), "-", "M" ) )

FUNCTION US_RAND( RANDOM )
   LOCAL NEGATIVE,TTX,TTJ,TTY,TTK,TTL,TTZ,TTS,TTT,RETT
   NEGATIVE=(RANDOM < 0)
   IF RANDOM = 0
      RETURN(0)
   ENDIF
   RANDOM=ABS(RANDOM)
   TTX=SECONDS()/100
   TTJ=(TTX - INT(TTX)) * 100
   TTY=LOG(SQRT(SECONDS()/100))
   TTK=(TTY - INT(TTY)) * 100
   TTL=TTJ*TTK
   TTZ=TTL - INT(TTL)
   TTS= RANDOM * TTZ
   TTT= ROUND(TTS,2)
   RETT=INT(TTT) + IF(INT(TTT) + 1 < RANDOM+1,1,0)
RETURN (RETT * IF(NEGATIVE,-1,1))

#pragma BEGINDUMP
#define _WIN32_IE      0x0500
#define HB_OS_WIN_32_USED
#define _WIN32_WINNT   0x0400

#include <windows.h>
#include "hbapi.h"

HB_FUNC(USAUX_GETSHORTPATHNAME)
{
   char buffer[ MAX_PATH + 1 ] = {0};
   DWORD iRet;

   iRet = GetShortPathName( hb_parc(1), buffer, MAX_PATH ) ;
   if (iRet < MAX_PATH) {
   hb_storclen( buffer, iRet, 2);
   }
   else
   {
   hb_storc( "", 2 );
   }
   hb_retnl( iRet ) ;
}

#pragma ENDDUMP

/* eof */
