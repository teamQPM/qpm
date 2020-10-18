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

#include "FuentesComunes\US_Env.h"
#include "fileio.ch"

#define DBLQT    '"'
#define SNGQT    "'"
#define CRLF     hb_osNewLine()
#define VERSION  "01.12"
MEMVAR cQPMDir

PROCEDURE MAIN( ... )
   LOCAL aParams := hb_AParams()
   LOCAL cParam, n, i, cPathTMP, cFileIn, cPathSHR, cFileOut, bForceChg, bInclude, cMemoIn, aLines, cMemoOut, bList := .F.
   LOCAL nInx, cLine, cFileInclude, lWarning, aPaths, aIncLines, nCount, bChg, cRule, cWord3, cPathInc, aIncStk
   LOCAL nEnd, cLineAux, cSlash, cChar
   PRIVATE cQPMDir := ""

/*
 * Parameters: -VERSION|-VER
 * Creates a file named US_Res.version containing the program's version number.
 *
 * Parameters: QPM [-LISTxxx] -ONLYINCLUDE RcFileIn RcFileOut cPathTMP type_of_path
 * Replaces #include <file> in RcFileIn with it's content creating file RcFileOut
 *
 * Parameters: QPM [-LISTxxx] RcFileIn RcFileOut cPathTMP type_of_path
 * Processes resource lines replacing .\filename with ( cPathTMP + .\filename )
 * and ..\filename with ( cPathTMP + ..\filename )
 *
 * Parameters: QPM [-LISTxxx] -FORCE RcFileIn RcFileOut cPathTMP type_of_path
 * Idem previous plus replacing C:\filename with ( cPathTMP + filename )
 *
 * QPM is a required parameter.
 * -LIST means write progress messages to QPM's log situated at folder xxx
 * RcFileIn and RcFileOut must be valid filenames and can be surrounded by single/doubles quotes or brackets.
 * type_of_path must be S for short path names or N for long path names.
 * Accepts / and \ as folder separator.
 * Supports nested #include directives.
 */

   cParam := ""
   n := Len( aParams )
   FOR i := 1 TO n - 2
      cParam += ( aParams[ i ] + " " )
   NEXT i
   cParam := AllTrim( cParam )

   IF Upper( US_Word( cParam, 1 ) ) == "-VER" .OR. Upper( US_Word( cParam, 1 ) ) == "-VERSION"
      hb_MemoWrit( "US_Res.version", VERSION )
      RETURN
   ENDIF

   IF Upper( US_Word( cParam, 1 ) ) != "QPM"
      __Run( "ECHO " + "US_Res 001E: Running Outside System" )
      RETURN
   ENDIF
   cParam := US_WordDel( cParam, 1 )

   IF Upper( SubStr( cParam, 1, 5 ) ) == "-LIST"
      bList := .T.
      cQPMDir := SubStr( US_Word( cParam, 1), 6 )
      IF ! Right( cQPMDir, 1 ) == "\"
         cQPMDir += "\"
      ENDIF
      cParam := AllTrim( SubStr( cParam, US_WordInd( cParam, 2 ) ) )
   ENDIF

   IF bList
      QPM_Log( "------------ " + "US_Res.version " + VERSION )
   ENDIF

   cPathSHR := aParams[ n ]
   cPathTMP := aParams[ n - 1 ]
   IF ! Right( cPathTMP, 1 ) == "\"
      cPathTMP += "\"
   ENDIF
   cFileIn  := US_Word( cParam, US_Words( cParam ) - 1 )
   cFileOut := US_Word( cParam, US_Words( cParam ) )
   cParam   := AllTrim( SubStr( cParam, 1, US_WordInd( cParam, US_Words( cParam ) - 1 ) - 1 ) )

   IF bList
      QPM_Log( "US_Res 003I: FileIn  : " + cFileIn )
      QPM_Log( "US_Res 004I: FileOut : " + cFileOut )
      QPM_Log( "US_Res 005I: Path    : " + cPathTMP )
      QPM_Log( "US_Res 006I: PathShrt: " + cPathSHR )
      QPM_Log( "US_Res 007I: Param   : " + cParam )
   ENDIF

   bForceChg := .F.
   bInclude := .F.
   FOR i := 1 TO US_Words( cParam )
      DO CASE
      CASE Upper( US_Word( cParam, i ) ) = "-FORCE"
         bForceChg := .T.
      CASE Upper( US_Word( cParam, i ) ) = "-ONLYINCLUDE"
         bInclude := .T.
      OTHERWISE
         IF bList
            QPM_Log( "US_Res 008E: Parameter error: " + US_Word( cParam, i ) )
            QPM_Log( "------------" + CRLF )
         ENDIF
         RETURN
      ENDCASE
   NEXT i

   IF ! File( cFileIn )
      IF bList
         QPM_Log( "US_Res 009E: File not found: " + cFileIn )
         QPM_Log( "------------" + CRLF )
      ENDIF
      RETURN
   ENDIF

   IF bList
      QPM_Log( "US_Res 010I: Process started" )
   ENDIF

   AAdd( ( aPaths := {} ), US_FileNameOnlyPath( cFileIn ) + "\" )

   IF bInclude                                    // -ONLYINCLUDE: just build one large RC file with the content of all #included files
      // Read input file and build an array of lines
      cMemoIn := MemoRead( cFileIn )
      cMemoIn := StrTran( cMemoIn, CRLF, Chr(10) )
      cMemoIn := StrTran( cMemoIn, Chr(13), Chr(10) )
      aLines  := hb_ATokens( cMemoIn, Chr(10) )
      IF Right( cMemoIn, 1 ) == Chr(10)
         ASize( aLines, Len( aLines ) - 1 )
      ENDIF
      aIncStk := { { cFileIn, 0 } }

      // Add a cute header
      cMemoOut := "// Project's resource file built by QPM" + CRLF + CRLF
      cMemoOut += "// " + Replicate( "=", 80 ) + CRLF
      cMemoOut += "// QPM - INI #INCLUDE file: " + cFileIn + CRLF
      cMemoOut += "// " + Replicate( "-", 80 ) + CRLF
      cMemoOut += "// line 1 " + cFileIn + CRLF

      // Process each line
      lWarning := .F.
      nInx := 0
      DO WHILE nInx < Len( aLines )
         nInx ++
         cLine := AllTrim( aLines[ nInx ] )
         ATail( aIncStk )[ 2 ] ++

         IF Upper( US_Word( cLine, 1 ) ) == "#INCLUDE"
            cFileInclude := AllTrim( StrTran( StrTran( US_WordSubStr( cLine, 2 ), DBLQT, "" ), SNGQT, "" ) )

            IF ! File( cFileInclude )
               cMemoOut += cLine + CRLF
               IF bList
                  QPM_Log( "US_Res 011W: File not found: " + cLine )
               ENDIF
               lWarning := .T.
            ELSE
               IF Left( cFileInclude, 2 ) == [.\]
                  cFileInclude := ATail( aPaths ) + SubStr( cFileInclude, 3 )
               ELSEIF Left( cFileInclude, 2 ) == [.\] .OR. Left( cFileInclude, 3 ) == [..\]
                  cFileInclude := ATail( aPaths ) + cFileInclude
               ENDIF
               cPathInc := US_FileNameOnlyPath( cFileInclude )
               IF Empty( cPathInc )
                  cFileInclude := cPathTMP + cFileInclude
                  AAdd( aPaths, cPathTMP )
               ELSE
                  AAdd( aPaths, cPathInc + "\" )
               ENDIF

                // Read the content of the included file and insert the lines
               cMemoOut += "// " + Replicate( "=", 80 ) + CRLF
               cMemoOut += "// QPM - INI #INCLUDE file: " + cFileInclude + CRLF
               cMemoOut += "// " + Replicate( "-", 80 ) + CRLF
               cMemoOut += "// line 1 " + cFileInclude + CRLF

               cMemoIn := MemoRead( cFileInclude )
               cMemoIn := StrTran( cMemoIn, CRLF, Chr(10) )
               cMemoIn := StrTran( cMemoIn, Chr(13), Chr(10) )
               cMemoIn := StrTran( cMemoIn, Chr(10), CRLF )
               aIncLines := hb_ATokens( cMemoIn, CRLF )
               IF Right( cMemoIn, 1 ) == Chr(10)
                  ASize( aIncLines, Len( aIncLines ) - 1 )
               ENDIF
               AAdd( aIncLines, "// " + Replicate( "-", 80 ) )
               AAdd( aIncLines, "// QPM - END #INCLUDE file: " + cFileInclude )
               AAdd( aIncLines, "// " + Replicate( "=", 80 ) )
               AAdd( aIncLines, "// line " + LTrim( Str( ATail( aIncStk )[ 2 ] + 1 ) ) + " " + ATail( aIncStk )[ 1 ] )
               AAdd( aIncStk, { cFileInclude, 0 } )

               nCount := Len( aIncLines )
               FOR i := 1 TO nCount
                  hb_AIns( aLines, nInx + 1, aIncLines[nCount - i + 1], .T. )
               NEXT i

               IF bList
                  QPM_Log( "US_Res 012I: File read: " + cLine )
               ENDIF
            ENDIF
         ELSE
            cMemoOut += cLine + CRLF

            IF Left( cLine, 28 ) == "// QPM - END #INCLUDE file: "
               ASize( aPaths, Len( aPaths ) - 1 )
               ASize( aIncStk, Len( aIncStk ) - 1 )
            ENDIF
         ENDIF
      ENDDO

      cMemoOut += "// " + Replicate( "-", 80 ) + CRLF
      cMemoOut += "// QPM - END #INCLUDE file: " + cFileIn + CRLF
      cMemoOut += "// " + Replicate( "=", 80 ) + CRLF

      // Save new text to output file
      hb_MemoWrit( cFileOut, cMemoOut )

      IF lWarning
         IF bList
            QPM_Log( "US_Res 013E: Process ended with a warning" )
            QPM_Log( "------------" + CRLF )
         ENDIF
      ELSE
         IF bList
            QPM_Log( "US_Res 014I: Process ended without error" )
            QPM_Log( "------------" + CRLF )
         ENDIF
      ENDIF
   ELSE                                           // List and parse each line changing the path of the resources, other lines are copied unchanged
      // Read input file, replace tabs with a space and build an array of lines
      cMemoIn := MemoRead( cFileIn )
      cMemoIn := StrTran( cMemoIn, CRLF, Chr(10) )
      cMemoIn := StrTran( cMemoIn, Chr(13), Chr(10) )
      cMemoIn := StrTran( cMemoIn, Chr(09), " " )
      aLines := hb_ATokens( cMemoIn, Chr(10) )
      IF Right( cMemoIn, 1 ) == Chr(10)
         ASize( aLines, Len( aLines ) - 1 )
      ENDIF

      // Process each line
      cMemoOut := ""
      nInx := 0
      DO WHILE nInx < Len( aLines )
         nInx ++
         cLine := AllTrim( aLines[ nInx ] )
         bChg := .F.

         IF Left( cLine, 28 ) == "// QPM - INI #INCLUDE file: "
            cPathInc := US_FileNameOnlyPath( SubStr( cLine, 29 ) )
            IF Empty( cPathInc )
               cPathInc := cPathTMP
            ELSE
               cPathInc += "\"
            ENDIF
            AAdd( aPaths, cPathInc )
         ELSEIF Left( cLine, 28 ) == "// QPM - END #INCLUDE file: "
            ASize( aPaths, Len( aPaths ) - 1 )
         ENDIF

         // Get rid of inline comments at the start of the line
         IF SubStr( cLine, 1, 2 ) == "/*" .AND. ( nEnd := At( "*/", cLine ) ) # 0
            cLine := AllTrim( SubStr( cLine, nEnd + 2 ) )
         ENDIF

         // #define
         IF SubStr( cLine, 1, 1 ) == "#" .AND. Upper( SubStr( cLine, 2, 6 ) ) == "DEFINE"
            // Do not change it, just copy to output
            cMemoOut += cLine + CRLF

         // One line comment or some reserved words
         ELSEIF SubStr( cLine, 1, 1 ) == "*" .OR. ;
                ( SubStr( cLine, 1, 1 ) == "#" .AND. ! Upper( SubStr( cLine, 2, 6 ) ) == "DEFINE" ) .OR. ;
                SubStr( cLine, 1, 2 ) == "//" .OR. ;
                SubStr( cLine, 1, 2 ) == "&&" .OR. ;
                US_Words( cLine ) < 3 .OR. ;
                Upper( US_Word( cLine, 1 ) ) == "BLOCK" .OR. ;
                Upper( US_Word( cLine, 1 ) ) == "VALUE" .OR. ;
                Upper( US_Word( cLine, 1 ) ) == "POPUP" .OR. ;
                Upper( US_Word( cLine, 2 ) ) == "ACCELERATORS" .OR. ;
                Upper( US_Word( cLine, 2 ) ) == "DIALOG" .OR. ;
                Upper( US_Word( cLine, 2 ) ) == "DIALOGEX" .OR. ;
                Upper( US_Word( cLine, 2 ) ) == "FONT" .OR. ;
                Upper( US_Word( cLine, 2 ) ) == "MENU" .OR. ;
                Upper( US_Word( cLine, 2 ) ) == "MENUEX" .OR. ;
                Upper( US_Word( cLine, 2 ) ) == "RCDATA" .OR. ;
                Upper( US_Word( cLine, 2 ) ) == "STRINGTABLE" .OR. ;
                Upper( US_Word( cLine, 2 ) ) == "PLUGPLAY" .OR. ;
                Upper( US_Word( cLine, 2 ) ) == "TEXTINCLUDE" .OR. ;
                Upper( US_Word( cLine, 2 ) ) == "VERSIONINFO" .OR. ;
                Upper( US_Word( cLine, 2 ) ) == "VXD"
            // Do not change it, just copy to output
            cMemoOut += cLine + CRLF

         // Multiple lines comment
         ELSEIF SubStr( cLine, 1, 2 ) == "/*"
           // Do not change it, just copy to output
            DO WHILE .T.
               cMemoOut += cLine + CRLF
               // Read next line
               IF ! nInx < Len( aLines )
                  EXIT
               ENDIF
               nInx ++
               cLine := AllTrim( aLines[ nInx ] )
               // Check for comment's end
               IF ( nEnd := At( "*/", cLine ) ) # 0
                  EXIT
               ENDIF
            ENDDO
/*
PROBAR SI SE PUEDE TENER COMENTARIOS DEL TIPO
XXX ICON ZZZ /* ...............
................
......../* UUU ICON MMM
*/

         // Resources
         ELSE
            DO CASE
            // For: .\resources\main.ico
            CASE SubStr( US_Word( cLine, 3 ), 1, 2 ) == './' .OR. ;
                 SubStr( US_Word( cLine, 3 ), 1, 2 ) == '.\'
               cLineAux := cLine
               cRule := "R01"
               cWord3 := US_Word( SubStr( cLine, US_WordInd( cLine, 3 ) + 2 ), 1 )
               IF cPathSHR == "S"
                  cLine := SubStr( cLine, 1, US_WordInd( cLine, 3 ) - 1 ) + US_ShortName( cPathInc + US_WSlash( cWord3 ), bList )
               ELSE
                  cLine := SubStr( cLine, 1, US_WordInd( cLine, 3 ) - 1 ) + cPathInc + US_WSlash( cWord3 )
               ENDIF
               bChg := .T.
            // For: ..\resources\main.ico
            CASE SubStr( US_Word( cLine, 3 ), 1, 3 ) == '../' .OR. ;
                 SubStr( US_Word( cLine, 3 ), 1, 3 ) == '..\'
               cLineAux := cLine
               cRule := "R02"
               cWord3 := US_Word( cLine, 3 )
               IF cPathSHR == "S"
                  cLine := SubStr( cLine, 1, US_WordInd( cLine, 3 ) - 1 ) + US_ShortName( cPathInc + US_WSlash( cWord3 ), bList )
               ELSE
                  cLine := SubStr( cLine, 1, US_WordInd( cLine, 3 ) - 1 ) + cPathInc + US_WSlash( cWord3 )
               ENDIF
               bChg := .T.
            // For: c:\resources\main.ico
            CASE bForceChg .AND. ;
                 ( At( ':/', US_Word( cLine, 3 ) ) == 2 .OR. At( [:\], US_Word( cLine, 3 ) ) == 2 )
               cLineAux := cLine
               cRule := "R10 forced"
               cSlash := SubStr( US_Word( cLine, 3 ), 3, 1 )
               cWord3 := US_Word( SubStr( cLine, US_WordInd( cLine, 3 ) ), 1 )
               cWord3 := SubStr( cWord3, RAt( cSlash, cWord3 ) + 1 )
               IF cPathSHR == "S"
                  cLine := SubStr( cLine, 1, US_WordInd( cLine, 3 ) - 1 ) + US_ShortName( cPathInc + cWord3, bList )
               ELSE
                  cLine := SubStr( cLine, 1, US_WordInd( cLine, 3 ) - 1 ) + cPathInc + cWord3
               ENDIF
               bChg := .T.
            // For: "c:\resources\main.ico"
            CASE bForceChg .AND. ;
                 ( At( [:\], US_Word( cLine, 3 ) ) = 3 .OR. At( ":/", US_Word( cLine, 3 ) ) = 3 ) .AND. ;
                 ( At( SNGQT, US_Word( cLine, 3 ) ) = 1 .OR.  At( DBLQT, US_Word( cLine, 3 ) ) = 1 )
               cLineAux := cLine
               cRule := "R11 forced"
               cSlash := SubStr( US_Word( cLine, 3 ), 4, 1 )
               cChar := SubStr( US_Word( cLine, 3 ), 1, 1 )
               cWord3 := US_Word( SubStr( cLine, US_WordInd( cLine, 3 ) + 1 ), 1 )
               cWord3 := SubStr( cWord3, RAt( cSlash, cWord3 ) + 1 )
               cWord3 := SubStr( cWord3, 1, RAt( cChar, cWord3 ) - 1 )
               IF cPathSHR == "S"
                  cLine := SubStr( cLine, 1, US_WordInd( cLine, 3 ) - 1 ) + US_ShortName( cPathInc + cWord3, bList )
               ELSE
                  cLine := SubStr( cLine, 1, US_WordInd( cLine, 3 ) - 1 ) + cPathInc + cWord3
               ENDIF
               bChg := .T.
            ENDCASE

            cMemoOut += cLine + CRLF
            IF bList
               IF bChg
                  QPM_Log( "US_Res 015I: Input line: " + cLineAux )
                  QPM_Log( "US_Res 016I: Rule:       " + cRule + " > " + cWord3 )
                  QPM_Log( "US_Res 017I: Output:     " + cLine )
               ELSE
                  QPM_Log( "US_Res 018I: Unchanged:  " + cLine )
               ENDIF
            ENDIF
         ENDIF
      ENDDO

      // Save new text to output file, exit loop and return
      hb_MemoWrit( cFileOut, cMemoOut )

      IF bList
         QPM_Log( "US_Res 019I: Process ended without error" )
         QPM_Log( "------------" + CRLF )
      ENDIF
   ENDIF

   RETURN

//========================================================================
// EXTRAE UNA PALABRA DE UN STRING
//========================================================================
FUNCTION US_Word( estring, posicion )
   LOCAL cont := 1

   IF posicion == NIL
      posicion := 1
   ENDIF
   estring := AllTrim( estring )
   DO WHILE .T.
      IF AT( " ", estring ) == 0
         RETURN iif( posicion == cont, estring, "" )
      ELSEIF cont == posicion
         RETURN SubStr( estring, 1, AT( " ", estring ) - 1 )
      ENDIF
      estring := AllTrim( SubStr( estring, AT( " ", estring ) + 1 ) )
      cont ++
   ENDDO

   RETURN ""

//========================================================================
// ELIMINAR UNA PALABRA DE UN STRING
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
// ESCRIBE EN EL LOG
//========================================================================
STATIC FUNCTION QPM_Log( string )
   LOCAL LogArchi := cQPMDir + "QPM.LOG"
   LOCAL msg := DToS( Date() ) + " " + Time() + " US_RES " + ProcName( 1 ) + "(" + Str( ProcLine( 1 ), 3, 0 ) + ")" + " " + string
   SET CONSOLE OFF
   SET ALTERNATE TO ( LogArchi ) ADDITIVE
   SET ALTERNATE ON
   ? msg
   SET ALTERNATE OFF
   SET ALTERNATE TO
   SET CONSOLE ON

   RETURN .T.

//========================================================================
// RETORNA EL PATH DE UN ARCHIVO
//========================================================================
FUNCTION US_FileNameOnlyPath( arc )
   IF arc == NIL
      RETURN ""
   ENDIF
   IF US_IsDirectory( arc )
      RETURN arc
   ENDIF

   RETURN SubStr( arc, 1, RAt( DEF_SLASH, arc ) - 1 )

//========================================================================
// RETORNA .T. SI ES UN FOLDER
//========================================================================
FUNCTION US_IsDirectory( Dire )

   RETURN IsDirectory( Dire )

//========================================================================
// RETORNA UN SUBSTR A PARTIR DE LA POSICION DE UNA PALABRA
//========================================================================
FUNCTION US_WordSubstr( estring, pos )

   IF Estring == NIL
      Estring := ""
   ENDIF

   RETURN SubStr( estring, US_WordInd( estring, pos ) )

//========================================================================
// RETORNA EL NOMBRE 'CORTO' DE UN ARCHIVO O FOLDER
//========================================================================
FUNCTION US_ShortName( nombre, bList )
   LOCAL Reto

   IF US_IsDirectory( nombre )
      Reto := US_GetShortPathName( nombre )
   ELSE
      Reto := US_GetShortFileName( nombre )
   ENDIF
   /* ini parche para Novell */
   IF Reto == ""
      RETURN Reto
   ENDIF
   IF At( Chr(0), Reto ) > 0
      IF US_Words( nombre ) > 1
         IF bList
            QPM_Log( "US_Res 020E: Folder name is not valid: " + DBLQT + nombre + DBLQT )
            QPM_Log( "US_Res 021E: Folder name is not valid: " + DBLQT + StrTran( Reto, Chr(0), "|" ) + DBLQT )
         ENDIF
         MsgStop( "The name: " + DBLQT + nombre + DBLQT + CRLF + ;
                  "was translated by the OS to a name not supported by QPM." + CRLF + ;
                  "Please, use an 8.3 name without spaces or parenthesis.", NIL, NIL, .F. )  // this is not translated
         Reto := ""
      ELSE
         Reto := nombre
      ENDIF
   ELSE
      IF US_IsDirectory( nombre ) .AND. ! US_IsDirectory( Reto )
         IF bList
            QPM_Log( "US_Res 022E: Folder name is not valid: " + DBLQT + nombre + DBLQT )
            QPM_Log( "US_Res 023E: Folder name is not valid: " + DBLQT + Reto + DBLQT )
         ENDIF
         MsgStop( "The name: " + DBLQT + nombre + DBLQT + CRLF + ;
                  "was translated by the OS to a name not supported by QPM." + CRLF + ;
                  "Please, use an 8.3 name without spaces or parenthesis.", NIL, NIL, .F. )  // this is not translated
         Reto := ""
      ELSEIF File( nombre ) .AND. ! File( Reto )
         IF bList
            QPM_Log( "US_Res 024E: Folder name is not valid: " + DBLQT + nombre + DBLQT )
            QPM_Log( "US_Res 025E: Folder name is not valid: " + DBLQT + Reto + DBLQT )
         ENDIF
         MsgStop( "The name: " +  DBLQT + nombre + DBLQT + CRLF + ;
                  "was translated by the OS to a name not supported by QPM." + CRLF + ;
                  "Please, use an 8.3 name without spaces or parenthesis.", NIL, NIL, .F. )  // this is not translated
         Reto := ""
      ENDIF
   ENDIF
   /* fin parche para Novell */
   /* ini parche para parentesis */
   IF At( "(", Reto ) > 0 .OR. At( ')', Reto )
      IF bList
         QPM_Log( "US_Res 026E: Folder name is not valid: " + DBLQT + nombre + DBLQT )
         QPM_Log( "US_Res 027E: Folder name is not valid: " + DBLQT + Reto + DBLQT )
      ENDIF
      MsgStop( "The name: " +  DBLQT + nombre + DBLQT + CRLF + ;
               "was translated by the OS to a name not supported by QPM." + CRLF + ;
               "Please, use an 8.3 name without spaces or parenthesis.", NIL, NIL, .F. )  // this is not translated
      Reto := ""
   ENDIF
   /* fin parche para parentesis */

   RETURN Reto

//========================================================================
// RETORNA EL NOMBRE 'CORTO' DE UN FOLDER
//========================================================================
FUNCTION US_GetShortPathName( cPath )
   LOCAL tmp, cFileTMP := US_FileTMP( cPath + iif( Right( cPath, 1 ) != DEF_SLASH, DEF_SLASH, '' ) + "_Path" )

   hb_MemoWrit( cFileTMP, "Temp from " + ProcName() )
   tmp := US_GetShortFileName( cFileTMP )
   tmp := US_FileNameOnlyPath( tmp )
   FErase( cFileTMP )

   RETURN tmp

//========================================================================
// RETORNA EL NOMBRE 'CORTO' DE UN ARCHIVO
//========================================================================
FUNCTION US_GetShortFileName( cPath )
   LOCAL sShortPathName:=""

   IF File( cPath )
      USAUX_GetShortPathname( cPath, @sShortPathName )
   ENDIF

   RETURN sShortPathName

//========================================================================
// REMPLAZA EL CARACTER SLASH POR BACKSLASH
//========================================================================
FUNCTION US_WSlash( arc )

   RETURN StrTran( arc, "/", "\" )

//========================================================================
// RETORNA EL NOMBRE DE UN ARCHIVO INEXISTENTE
//========================================================================
FUNCTION US_FileTmp( prefix, suffix )
   LOCAL cFile

   IF Empty( prefix )
      prefix := "_temp"
   ENDIF
   IF Empty( suffix )
      suffix := ".tmp"
   ENDIF
   IF ! Left( suffix, 1 ) == "."
      suffix := "." + suffix
   ENDIF
   DO WHILE .T.
      cFile := prefix + US_NameRandom() + suffix
      IF ! File( cFile )
         EXIT
      ENDIF
   ENDDO

   RETURN cFile

//========================================================================
// RETORNA UN STRING A PARTIR DEL NÚMERO DE SEGUNDOS TRANSCURRIDOS
//========================================================================
FUNCTION US_NameRandom()

   RETURN AllTrim( StrTran( StrTran( Str( Seconds() ), ".", AllTrim( Str( US_Rand( Seconds() ) ) ) ), "-", "M" ) )

//========================================================================
// RETORNA UN STRING A PARTIR DEL NÚMERO DE SEGUNDOS TRANSCURRIDOS
//========================================================================
FUNCTION US_Rand( random )
   LOCAL negative, ttx, ttj, tty, ttk, ttl, ttz, tts, ttt, rett

   negative := ( random < 0 )
   IF random == 0
      RETURN 0
   ENDIF
   random := Abs( random )
   ttx := Seconds() / 100
   ttj := ( ttx - Int( ttx ) ) * 100
   tty := Log( Sqrt( Seconds() / 100 ) )
   ttk := ( tty - Int( tty ) ) * 100
   ttl := ttj * ttk
   ttz := ttl - Int( ttl )
   tts :=  random * ttz
   ttt :=  Round( tts, 2 )
   rett := Int( ttt ) + iif( Int( ttt ) + 1 < random + 1, 1, 0 )

   RETURN ( rett * iif( negative, -1, 1 ) )

//========================================================================
#pragma BEGINDUMP

#define _WIN32_IE      0x0500

#include <windows.h>
#include "hbapi.h"

HB_FUNC( USAUX_GETSHORTPATHNAME )
{
   char buffer[ MAX_PATH + 1 ] = {0};
   DWORD iRet;

   iRet = GetShortPathName( hb_parc(1), buffer, MAX_PATH ) ;
   if( iRet < MAX_PATH )
   {
      hb_storclen( buffer, iRet, 2 );
   }
   else
   {
      hb_storc( "", 2 );
   }
   hb_retnl( iRet ) ;
}

#pragma ENDDUMP

/* eof */
