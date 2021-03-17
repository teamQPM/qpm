/*
 *    QPM - QAC based Project Manager
 *
 *    Copyright 2011-2021 Fernando Yurisich <qpm-users@lists.sourceforge.net>
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

#define VERSION "01.07"
#define CRLF hb_osNewLine()
MEMVAR CQPMDIR
MEMVAR bList

PROCEDURE MAIN( ... )
   LOCAL aParams := hb_AParams()
   LOCAL cTxtAux, cTxtAux2 := "", i, nCount, cWord
   LOCAL cModuleNameAux, cLineaAux, cLineaAux2, bEncontroValido := .F.
   LOCAL nPos, bObjLst := .F., bExpLst := .F., cObjExt := ".ObjLst", cExpExt := ".ExpLst"
   LOCAL MemoObjLst := "", MemoExpLst := "EXPORTS"
   LOCAL bDelete := .F., nZap, cFileStop := "", lStop := .F.
   LOCAL bPellesDynamic, bBorlandDynamic, bMinGWDynamic
   LOCAL cDLL_Name := "", nDLL_NameAux, cDLL_NameFunAux, cDLL_NameMemoAux
   LOCAL cParam, cPar1, cPar2, cPar3, cPar4, j, vFun := {}
   LOCAL nLineaBaseExport, vObjectsPelles := {}, vFuncionesPelles := {}, bFunList

   PRIVATE cQPMDir := "", bList := .F.

   cParam := ""
   FOR i := 1 TO Len( aParams )
      cParam += ( aParams[ i ] + " " )
   NEXT i
   cParam := AllTrim( cParam )

   IF Upper( US_Word( cParam, 1 ) ) == "-VER" .or. Upper( US_Word( cParam, 1 ) ) == "-VERSION"
      hb_MemoWrit( "US_Shell.version", VERSION )
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

    Say( "------------ " + "US_Shell.version " + VERSION )

   IF ( nPos := US_WordPos( "-FILESTOP", US_Upper( cParam ) ) ) > 0
      IF US_Words( cParam ) == nPos
         Say(  "US_Shell 001E: FILESTOP without file, USE: -FILESTOP cDisc:\cPath\cFileName.ext" )
         RETURN
      ENDIF
      cFileStop := StrTran( US_Word( cParam, nPos + 1 ), "|", " " )
      Say(  "US_Shell 001I: FILESTOP: " + cFileStop )
      cParam := US_WordDel( cParam, nPos + 1 )
      cParam := US_WordDel( cParam, nPos )
   ENDIF

   cPar1 := Upper( US_Word( cParam, 1 ) )

   DO CASE
   CASE cPar1 == "CHECKRC"
      Say( "US_Shell 100I: " + cPar1 )
      IF US_Words( cParam ) < 2
         Say( "US_Shell 101E: Invalid parameter count: " + cParam + CRLF )
         Say( "No file to check!", .T. )
      ELSE
         Say( "US_Shell 101I: Processing: " + cParam )
         cPar2 := US_Word( cParam, 2 )
         Say( "US_Shell 102I: Option: " + cPar2 )
         IF Upper( cPar2 ) == "NOTFILE"
            cPar3 := StrTran( US_Word( cParam, 3 ), "|", " " )
            Say( "US_Shell 103I: File: " + cPar3 )
            IF ! File( cPar3 )
               Say( "US_Shell 104I: File not found" + CRLF )
               Say( "File not found!", .T. )
            ELSE
               Say( "US_Shell 105I: File found" )
               Say( "US_Shell 106I: Size " + AllTrim( Str( US_FileSize( cPar3 ) ) ) + ' bytes' + CRLF )
            ENDIF
         ELSE
            Say( "US_Shell 107E: Invalid parameter" + CRLF )
         ENDIF
      ENDIF
   CASE cPar1 == "COPY" .OR. cPar1 == "COPYZAP"
      Say( "US_Shell 200I: " + cPar1 )
      IF US_Words( cParam ) < 3
         Say( "US_Shell 201E: Invalid parameter count: " + cParam + CRLF )
         Say( "No file to copy!", .T. )
      ELSE
         Say( "US_Shell 101I: Processing: " + cParam )
         cPar2 := StrTran( US_Word( cParam, 2 ), "|", " " )
         Say( "US_Shell 202I: File In: " + cPar2 )
         IF ! File( cPar2 )
            Say( "US_Shell 203E: File not found" + CRLF )
            Say( "File not found!", .T. )
         ELSE
            cPar3 := StrTran( US_Word( cParam, 3 ), "|", " " )
            Say( "US_Shell 203I: Folder Out: " + cPar3 )
            IF ! US_IsDirectory( US_FileNameOnlyPath( cPar3 ) )
               Say( "US_Shell 204E: Output folder not found: " + cPar3 + CRLF )
               Say( "Output folder not found!", .T. )
            ELSE
               IF FileCopy( cPar2, cPar3 ) == US_FileSize( cPar2 )
                  IF cPar1 == "COPYZAP"
                     nZap := US_FileChar26Zap( cPar3 )
                     DO CASE
                     CASE nZap == -1
                        Say( "US_Shell 205I: OK" )
                        Say( "US_Shell 206W: Char x'1A' not removed" + CRLF )
                     CASE nZap == 1
                        Say( "US_Shell 205I: OK" )
                        Say( "US_Shell 207I: Char x'1A' removed" + CRLF )
                     OTHERWISE
                        Say( "US_Shell 205I: OK" + CRLF )
                     ENDCASE
                  ELSE
                     Say( "US_Shell 205I: OK" + CRLF )
                  ENDIF
               ELSE
                  Say( "US_Shell 208E: ERROR" + CRLF )
                  Say( "Error copying file!", .T. )
               ENDIF
            ENDIF
         ENDIF
      ENDIF
   CASE cPar1 == "MOVE" .OR. cPar1 == "MOVEZAP"
      Say( "US_Shell 300I: " + cPar1 )
      IF US_Words( cParam ) < 3
         Say( "US_Shell 301E: Invalid parameter count: " + cParam + CRLF )
         Say( "No file to move!", .T. )
      ELSE
         Say( "US_Shell 301I: Processing: " + cParam )
         cPar2 := StrTran( US_Word( cParam, 2 ), "|", " " )
         Say( "US_Shell 302I: File In: " + cPar2 )
         IF ! File( cPar2 )
            Say( "US_Shell 303E: File not found" + CRLF )
            Say( "File not found!", .T. )
         ELSE
            cPar3 := StrTran( US_Word( cParam, 3 ), "|", " " )
            Say( "US_Shell 303I: Folder Out: " + cPar3 )
            IF ! US_IsDirectory( US_FileNameOnlyPath( cPar3 ) )
               Say( "US_Shell 304E: Output folder not found: " + cPar3 + CRLF )
               Say( "Output folder not found!", .T. )
            ELSE
               IF FileCopy( cPar2, cPar3 ) == US_FileSize( cPar2 )
                  IF FErase( cPar2 ) != -1
                     IF cPar1 == "MOVEZAP"
                        nZap := US_FileChar26Zap( cPar3 )
                        DO CASE
                        CASE nZap == -1
                           Say( "US_Shell 305I: OK" )
                           Say( "US_Shell 306W: Char x'1A' not removed" + CRLF )
                        CASE nZap == 1
                           Say( "US_Shell 305I: OK" )
                           Say( "US_Shell 307I: Char x'1A' removed" + CRLF )
                        OTHERWISE
                           Say( "US_Shell 305I: OK" + CRLF )
                        ENDCASE
                     ELSE
                        Say( "US_Shell 305I: OK" + CRLF )
                     ENDIF
                     hb_MemoWrit( cPar2 + ".MOVED.TXT", "File " + cPar2 + " has been moved to: " + cPar3 )
                  ELSE
                     Say( "US_Shell 308E: ERROR deleting" + CRLF )
                     Say( "Error deleting file!", .T. )
                  ENDIF
               ELSE
                  Say( "US_Shell 309E: ERROR copying" + CRLF )
                  Say( "Error copying file!", .T. )
               ENDIF
            ENDIF
         ENDIF
      ENDIF
   CASE cPar1 == "LIST_TXT"
      Say( "US_Shell 400I: LIST_TXT" )
      IF US_Words( cParam ) < 2
         Say( "US_Shell 401E: Invalid parameter count: " + cParam + CRLF )
         Say( "No file to list!", .T. )
      ELSE
         Say( "US_Shell 401I: Processing: " + cParam )
         IF ( nPos := US_WordPos( "-DELETE", US_Upper( cParam ) ) ) > 0
            cParam := US_WordDel( cParam, nPos )
            bDelete := .T.
         ENDIF
         cPar2 := StrTran( US_Word( cParam, 2 ), "|", " " )
         Say( "US_Shell 402I: File In: " + cPar2 )
         IF ! File( cPar2 )
            Say( "US_Shell 402E: File not found" + CRLF )
            Say( "File not found!", .T. )
         ELSE
            cTxtAux := MemoRead( cPar2 )
            FOR i := 1 TO MLCount( cTxtAux, 254 )
               Say( MemoLine( cTxtAux, 254, i ) )
               IF File( cFileStop )
                  lStop := .T.
                  Say( "User stop!", .T. )
                  Say( "US_Shell 402W: User Stop" + CRLF )
                  EXIT
               ENDIF
            NEXT i
            IF ! lStop
               Say( "End of list.", .T. )
               Say( "US_Shell 403I: End of list" + CRLF )
            ENDIF
            IF bDelete
               FErase( cPar2 )
            ENDIF
         ENDIF
      ENDIF
   CASE cPar1 == "ANALIZE_DLL"
      Say( "US_Shell 500I: ANALIZE_DLL" )
      IF US_Words( cParam ) < 2
         Say( "US_Shell 501E: Invalid parameter count: " + cParam + CRLF )
         Say( "No file to analize!", .T. )
      ELSE
         Say( "US_Shell 501I: Processing: " + cParam )
         IF ( nPos := US_WordPos( "-DELETE", US_Upper( cParam ) ) ) > 0
            cParam := US_WordDel( cParam, nPos )
            bDelete := .T.
         ENDIF
         Say( "Analizing Definition File for Dynamic Library (DLL)", .T. )
         cPar2 := StrTran( US_Word( cParam, 2 ), "|", " " )
         Say( "US_Shell 502I: File In: " + cPar2 )
         IF ! File( cPar2 )
            Say( "US_Shell 502E: File not found" + CRLF )
            Say( "File not found!", .T. )
         ELSE
            Say( "Functions exported: ", .T. )
            Say( "US_Shell 503I: Functions exported: " )
            cTxtAux := MemoRead( cPar2 )
            nLineaBaseExport := MLCount( cTxtAux, 254 )
            FOR i := 1 TO MLCount( cTxtAux, 254 )
               IF AllTrim( MemoLine( cTxtAux, 254, i ) ) == "EXPORTS"
                  nLineaBaseExport := i + 1
               ENDIF
               IF File( cFileStop )
                  lStop := .T.
                  Say( "User stop!", .T. )
                  Say( "US_Shell 504W: User Stop" + CRLF )
                  EXIT
               ENDIF
            NEXT i
            IF ! lStop
               FOR i := nLineaBaseExport TO MLCount( cTxtAux, 254 )
                  cLineaAux := US_Word( MemoLine( cTxtAux, 254, i ), 1 )
                  Say( "             " + PadL( AllTrim( Str( i - nLineaBaseExport + 1 ) ), 5 ) + ": " + cLineaAux, .T. )
                  Say( "US_Shell 505I: " + PadL( AllTrim( Str( i - nLineaBaseExport + 1 ) ), 5 ) + ": " + cLineaAux )
                  IF File( cFileStop )
                     lStop := .T.
                     Say( "User stop!", .T. )
                     Say( "US_Shell 506W: User Stop" )
                     EXIT
                  ENDIF
               NEXT i
               IF ! lStop
                  Say( "End of list.", .T. )
                  Say( "US_Shell 507I: End of list" + CRLF )
               ENDIF
            ENDIF
            IF bDelete
               FErase( cPar2 )
            ENDIF
         ENDIF
      ENDIF
   CASE cPar1 == "ANALIZE_LIB_PELLES"
      Say( "US_Shell 600I: ANALIZE_LIB_PELLES" )
      IF US_Words( cParam ) < 2
         Say( "US_Shell 601E: Invalid parameter count: " + cParam + CRLF )
         Say( "No file to analize!", .T. )
      ELSE
         Say( "US_Shell 601I: Processing: " + cParam )
         IF ( nPos := US_WordPos( "-DELETE", US_Upper( cParam ) ) ) > 0
            cParam := US_WordDel( cParam, nPos )
            bDelete := .T.
         ENDIF
         IF ( nPos := US_WordPos( "-OBJLST", US_Upper( cParam ) ) ) > 0
            cParam := US_WordDel( cParam, nPos )
            bObjLst := .T.
         ENDIF
         IF ( nPos := US_WordPos( "-EXPLST", US_Upper( cParam ) ) ) > 0
            cParam := US_WordDel( cParam, nPos )
            bExpLst := .T.
         ENDIF
         Say( "Analizing Definition File for Pelles Static Library", .T. )
         Say( "US_Shell 602I: ANALIZE_LIB_PELLES" )
         cPar2 := StrTran( US_Word( cParam, 2 ), "|", " " )
         Say( "File In: " + cPar2, .T. )
         Say( "US_Shell 603I: File In: " + cPar2 )
         IF ! File( cPar2 )
            Say( "File not found!" )
            Say( "US_Shell 604E: File not found" + CRLF )
         ELSE
            IF bObjLst
               Say( "File Obj: " + cPar2 + cObjExt, .T. )
               Say( "US_Shell 605I: File Obj: " + cPar2 + cObjExt )
            ENDIF
            IF bExpLst
               Say( "File Ext: " + cPar2 + cExpExt, .T. )
               Say( "US_Shell 606I: File Ext: " + cPar2 + cExpExt )
            ENDIF
            Say( "Function exported: ", .T. )
            Say( "US_Shell 607E: Functions exported: " )
            bPellesDynamic := .F.
            cTxtAux := MemoRead( cPar2 )
            FOR i := 1 TO MLCount( cTxtAux, 254 )
               cLineaAux := MemoLine( cTxtAux, 254, i )
               IF At( "Long name: ", cLineaAux ) == 1
                  AAdd( vObjectsPelles, US_FileNameOnlyName( SubStr( cLineaAux, 12 ) ) )
               ENDIF
               IF File( cFileStop )
                  lStop := .T.
                  Say( "User stop!", .T. )
                  Say( "US_Shell 506W: User Stop" + CRLF )
                  EXIT
               ENDIF
            NEXT i
            IF ! lStop
               IF Len( vObjectsPelles ) == 0
                  bPellesDynamic := .T.
                  cDLL_Name := StrTran( US_Word( SubStr( cTxtAux, RAt( "Member at offset", cTxtAux ) ), 5 ), "/", "" )
               ENDIF
               bFunList := .F.
               FOR i := 1 TO MLCount( cTxtAux, 254 )
                  cLineaAux := MemoLine( cTxtAux, 254, i )
                  IF US_Word( cLineaAux, 2 ) == "global" .AND. ;
                     US_Word( cLineaAux, 3 ) == "symbols" .AND. ;
                     US_Words( cLineaAux ) == 3
                     bFunList := .T.
                  ENDIF
                  IF bFunList .AND. ;
                     US_Word( cLineaAux, 1 ) == "Member" .AND. ;
                     US_Word( cLineaAux, 2 ) == "at" .AND. ;
                     US_Word( cLineaAux, 3 ) == "offset"
                     EXIT
                  ENDIF
                  IF bFunList .AND. ;
                     US_Words( cLineaAux ) == 2
                     IF bPellesDynamic
                        AAdd( vFuncionesPelles, "DYNAMIC " + cDLL_Name + " " + US_Word( cLineaAux, 2 ) )
                     ELSE
                        AAdd( vFuncionesPelles, "STATIC " + vObjectsPelles[ Val( NToC( US_Word( cLineaAux, 1 ), 10 ) ) ] + " " + US_Word( cLineaAux, 2 ) )
                     ENDIF
                  ENDIF
                  IF File( cFileStop )
                     lStop := .T.
                     Say( "User stop!", .T. )
                     Say( "US_Shell 506W: User Stop" + CRLF )
                     EXIT
                  ENDIF
               NEXT i
               IF ! lStop
                  ASort( vFuncionesPelles, { |x, y| x < y } )
                  IF Len( vFuncionesPelles ) == 0
                     cTxtAux2 := 'No public symbols exist.'
                  ELSE
                     FOR i := 1 TO len( vFuncionesPelles )
                        cTxtAux2 := cTxtAux2 + vFuncionesPelles[i] + hb_osNewLine()
                     NEXT i
                  ENDIF
                  cTxtAux := cTxtAux2
                  IF AllTrim( MemoLine( cTxtAux, 254, 1 ) ) == 'No public symbols exist.'
                     Say( "US_Shell 608W: No public symbols found" + CRLF )
                     Say( "No public symbols found.", .T. )
                  ELSE
                     cModuleNameAux := "."
                     FOR i := 1 TO MLCount( cTxtAux, 254 )
                        cLineaAux := MemoLine( cTxtAux, 254, i )
                        IF US_Word( cLineaAux, 2 ) != cModuleNameAux
                           cModuleNameAux := US_Word( cLineaAux, 2 )
                           IF US_Word( cLineaAux, 1 ) == "DYNAMIC"
                              Say( "US_Shell 609I: Dynamic link import (IMPDEF) from " + cModuleNameAux )
                              Say( "    Dynamic link import (IMPDEF) from " + cModuleNameAux, .T. )
                           ELSE
                              Say( "US_Shell 610I: Static Module " + cModuleNameAux )
                              Say( "    Static Module " + cModuleNameAux, .T. )
                              IF bObjLst
                                 MemoObjLst := MemoObjLst + iif( ! Empty( MemoObjLst ), hb_osNewLine(), "" ) + cModuleNameAux
                              ENDIF
                           ENDIF
                        ENDIF
                        IF ! Empty( cLineaAux )
                           cModuleNameAux := US_Word( cLineaAux, 2 )
                           AAdd( vFun, "             " + SubStr( US_Word( cLineaAux, 3 ), 1 ) )
                           IF bExpLst
                              MemoExpLst := MemoExpLst + hb_osNewLine() + SubStr( US_Word( cLineaAux, 3 ), 1 )
                           ENDIF
                        ENDIF
                        IF File( cFileStop )
                           US_Shell_Listo( vFun )
                           lStop := .T.
                           Say( "User stop!", .T. )
                           Say( "US_Shell 611W: User Stop" + CRLF )
                           EXIT
                        ENDIF
                     NEXT i
                     IF ! lStop
                        US_Shell_Listo( vFun )
                        Say( "US_Shell 612I: End of list" + CRLF )
                        Say( "End of list.", .T. )
                        IF bObjLst
                           hb_MemoWrit( cPar2 + cObjExt, MemoObjLst )
                        ENDIF
                        IF bExpLst
                           hb_MemoWrit( cPar2 + cExpExt, MemoExpLst )
                        ENDIF
                     ENDIF
                  ENDIF
               ENDIF
            ENDIF
            IF bDelete
               FErase( cPar2 )
            ENDIF
         ENDIF
      ENDIF
   CASE cPar1 == "ANALIZE_LIB_BORLAND"
      Say( "US_Shell 700I: ANALIZE_LIB_BORLAND" )
      IF US_Words( cParam ) < 2
         Say( "US_Shell 701E: Invalid parameter count: " + cParam + CRLF )
         Say( "No file to analize!", .T. )
      ELSE
         Say( "US_Shell 701I: Processing: " + cParam )
         IF ( nPos := US_WordPos( "-DELETE", US_Upper( cParam ) ) ) > 0
            cParam := US_WordDel( cParam, nPos )
            bDelete := .T.
         ENDIF
         IF ( nPos := US_WordPos( "-OBJLST", US_Upper( cParam ) ) ) > 0
            cParam := US_WordDel( cParam, nPos )
            bObjLst := .T.
         ENDIF
         IF ( nPos := US_WordPos( "-EXPLST", US_Upper( cParam ) ) ) > 0
            cParam := US_WordDel( cParam, nPos )
            bExpLst := .T.
         ENDIF
         Say( "Analizing Definition File for Borland Static Library", .T. )
         Say( "US_Shell 702I: ANALIZE_LIB_BORLAND" )
         cPar2 := StrTran( US_Word( cParam, 2 ), "|", " " )
         Say( "File In: " + cPar2, .T. )
         Say( "US_Shell 703I: File In: " + cPar2 )
         IF ! File( cPar2 )
            Say( "File not found!" )
            Say( "US_Shell 704E: File not found" + CRLF )
         ELSE
            IF bObjLst
               Say( "File Obj: " + cPar2 + cObjExt, .T. )
               Say( "US_Shell 705I: File Obj: " + cPar2 + cObjExt )
            ENDIF
            IF bExpLst
               Say( "File Ext: " + cPar2 + cExpExt, .T. )
               Say( "US_Shell 706I: File Ext: " + cPar2 + cExpExt )
            ENDIF
            Say( "Functions exported: ", .T. )
            Say( "US_Shell 707E: Functions exported: " )
            cTxtAux := MemoRead( cPar2 )
            IF AllTrim( MemoLine( cTxtAux, 254, 1 ) ) == 'No public symbols exist.'
               Say( "US_Shell 708W: No public symbols found" + CRLF )
               Say( "No public symbols found.", .T. )
            ELSE
               bBorlandDynamic := .F.
               FOR i := 1 TO MLCount( cTxtAux, 254 )
                  cLineaAux := MemoLine( cTxtAux, 254, i )
                  IF US_Word( cLineaAux, 2 ) == "size" .AND. ;
                     US_Word( cLineaAux, 3 ) == "="
                     cModuleNameAux := US_Word( cLineaAux, 1 )
                     IF Val( US_Word( cLineaAux, 4 ) ) = 0
                        IF ! bBorlandDynamic
                           cDLL_NameFunAux := US_Word( cLineaAux, 1 )
                           cDLL_NameMemoAux := MemoRead( US_FileNameOnlyPathAndName( cPar2 ) )
                           cDLL_NameMemoAux := SubStr( cDLL_NameMemoAux, At( Chr( 14 ) + cDLL_NameFunAux + Chr( 12 ), cDLL_NameMemoAux ) )
                           cDLL_NameMemoAux := StrTran( cDLL_NameMemoAux, Chr( 12 ), " " )
                           cDLL_NameMemoAux := US_Word( cDLL_NameMemoAux, 2 )
                           cDLL_Name := SubStr( cDLL_NameMemoAux, 1, RAt( ".DLL", Upper( cDLL_NameMemoAux ) ) + 3 )
                           Say( "US_Shell 709I: Dynamic link import (IMPDEF) from " + cDLL_Name )
                           Say( "    Dynamic link import (IMPDEF) from " + cDLL_Name, .T. )
                           bBorlandDynamic := .T.
                        ENDIF
                     ELSE
                        Say( "US_Shell 709I: Static Module " + cModuleNameAux )
                        Say( "    Static Module " + cModuleNameAux, .T. )
                        IF bObjLst
                           MemoObjLst := MemoObjLst + iif( ! Empty( MemoObjLst ), hb_osNewLine(), "" ) + cModuleNameAux
                        ENDIF
                     ENDIF
                  ELSE
                     IF ! Empty( cLineaAux ) .AND. cLineaAux != "Publics by module"
                        AAdd( vFun, "             " + SubStr( US_Word( cLineaAux, 1 ), 1 ) )
                        IF bExpLst
                           MemoExpLst := MemoExpLst + hb_osNewLine() + SubStr( US_Word( cLineaAux, 1 ), 1 )
                        ENDIF
                        IF US_Words( cLineaAux ) == 2
                           AAdd( vFun, "             " + SubStr( US_Word( cLineaAux, 2 ), 1 ) )
                           IF bExpLst
                              MemoExpLst := MemoExpLst + hb_osNewLine() + SubStr( US_Word( cLineaAux, 2 ), 1 )
                           ENDIF
                        ENDIF
                     ENDIF
                  ENDIF
                  IF File( cFileStop )
                     US_Shell_Listo( vFun )
                     lStop := .T.
                     Say( "User stop!", .T. )
                     Say( "US_Shell 710W: User Stop" + CRLF )
                     EXIT
                  ENDIF
               NEXT i
               IF ! lStop
                  US_Shell_Listo( vFun )
                  Say( "US_Shell 711I: End of list" + CRLF )
                  Say( "End of list.", .T. )
                  IF bObjLst
                     hb_MemoWrit( cPar2 + cObjExt, MemoObjLst )
                  ENDIF
                  IF bExpLst
                     hb_MemoWrit( cPar2 + cExpExt, MemoExpLst )
                  ENDIF
               ENDIF
            ENDIF
            IF bDelete
               FErase( cPar2 )
            ENDIF
         ENDIF
      ENDIF
   CASE cPar1 == "ANALIZE_LIB_MINGW"
      Say( "US_Shell 800I: ANALIZE_LIB_MINGW" )
      IF US_Words( cParam ) < 2
         Say( "US_Shell 801E: Invalid parameter count: " + cParam + CRLF )
         Say( "No file to analize!", .T. )
      ELSE
         Say( "US_Shell 801I: Processing: " + cParam )
         IF ( nPos := US_WordPos( "-DELETE", US_Upper( cParam ) ) ) > 0
            cParam := US_WordDel( cParam, nPos )
            bDelete := .T.
         ENDIF
         IF ( nPos := US_WordPos( "-OBJLST", US_Upper( cParam ) ) ) > 0
            cParam := US_WordDel( cParam, nPos )
            bObjLst := .T.
         ENDIF
         IF ( nPos := US_WordPos( "-EXPLST", US_Upper( cParam ) ) ) > 0
            cParam := US_WordDel( cParam, nPos )
            bExpLst := .T.
         ENDIF
         Say( "US_Shell 802I: Analizing Definition File for MinGW Static Library" )
         cPar2 := StrTran( US_Word( cParam, 2 ), "|", " " )
         Say( "File In: " + SubStr( cPar2, 1, Len( cPar2 ) - 4 ), .T. )
         Say( "US_Shell 803I: File In: " + cPar2 )
         IF ! File( cPar2 )
            Say( "File not found!" )
            Say( "US_Shell 804E: File not found" + CRLF )
         ELSE
            IF bObjLst
               Say( "File Obj: " + cPar2 + cObjExt, .T. )
               Say( "US_Shell 805I: File Obj: " + cPar2 + cObjExt )
            ENDIF
            IF bExpLst
               Say( "File Ext: " + cPar2 + cExpExt, .T. )
               Say( "US_Shell 806I: File Ext: " + cPar2 + cExpExt )
            ENDIF
            Say( "Functions exported: ", .T. )
            Say( "US_Shell 807E: Functions exported: " )
            cTxtAux := MemoRead( cPar2 )
            bMinGWDynamic := .F.
            nCount := MLCount( cTxtAux, 254 )
            FOR i := 1 TO nCount
               cLineaAux := MemoLine( cTxtAux, 254, i )
               IF US_Word( cLineaAux, 1 ) == "SYMBOL" .AND. US_Word( cLineaAux, 2 ) == "TABLE:"
                  cLineaAux2 := MemoLine( cTxtAux, 254, i + 1 )
                  cModuleNameAux := US_Word( cLineaAux2, US_Words( cLineaAux2 ) )
                  // ignore first two files in import originated libraries
                  IF cModuleNameAux == "fake"
                     bEncontroValido := .F.
                     LOOP
                  ENDIF
                  // is a module originated by import
                  IF cModuleNameAux == ".text"
                     bEncontroValido := .F.
                     IF ! bMinGWDynamic
                        cDLL_Name := SubStr( cTxtAux, At( "Contents of section", cTxtAux ) )
                        nDLL_NameAux := RAt( " ", SubStr( cDLL_Name, 1, At( ".DLL.", Upper( cDLL_Name ) ) ) ) + 1
                        cDLL_Name := StrTran( US_Word( SubStr( cDLL_Name, nDLL_NameAux ), 1 ), "....", "" )
                        Say( "    Dynamic link import (IMPDEF) from " + cDLL_Name )
                        bMinGWDynamic := .T.
                     ENDIF
                     AAdd( vFun, "             " + US_Word( MemoLine( cTxtAux, 254, i + 8 ), US_Words( MemoLine( cTxtAux, 254, i + 8 ) ) ) )
                  ELSE
                     // standard module
                     bEncontroValido := .T.
                     cModuleNameAux := SubStr( cModuleNameAux, 1, RAt( ".", cModuleNameAux ) - 1 )
                     Say( "    Static Module " + cModuleNameAux )
                     IF bObjLst
                        MemoObjLst := MemoObjLst + iif( ! Empty( MemoObjLst ), hb_osNewLine(), "" ) + cModuleNameAux
                     ENDIF
                  ENDIF
               ELSE
                  // function in standard module
                  IF AllTrim( cLineaAux ) == "File" .AND. bEncontroValido
                     FOR j := i + 1 TO nCount
                        cLineaAux = MemoLine( cTxtAux, 254, j )
                        cWord := US_Word( cLineaAux, US_Words( cLineaAux ) )
                        IF Left( cWord, 1 ) == "."
                           i := j
                           EXIT
                        ENDIF
                        IF SubStr( cWord, 1, 7 ) == "_HB_FUN"
                           AAdd( vFun, "             " + US_Word( cLineaAux, US_Words( cLineaAux ) ) )
                           IF bExpLst
                              MemoExpLst := MemoExpLst + hb_osNewLine() + US_Word( cLineaAux, US_Words( cLineaAux ) )
                           ENDIF
                           i := j
                        ENDIF
                        cWord := US_Word( cLineaAux, 1 )
                        IF Left( cWord, 1 ) # "[" .AND. cWord # "AUX"
                           i := j
                           EXIT
                        ENDIF
                        IF File( cFileStop )
                           EXIT
                        ENDIF
                     NEXT j
                     bEncontroValido := .F.
                  ENDIF
               ENDIF
               IF File( cFileStop )
                  US_Shell_Listo( vFun )
                  lStop := .T.
                  Say( "User stop!", .T. )
                  Say( "US_Shell 808W: User Stop" + CRLF )
                  EXIT
               ENDIF
            NEXT i
            IF ! lStop
               US_Shell_Listo( vFun )
               Say( "US_Shell 809I: End of list" + CRLF )
               Say( "End of list.", .T. )
               IF bObjLst
                  hb_MemoWrit( cPar2 + cObjExt, MemoObjLst )
               ENDIF
               IF bExpLst
                  hb_MemoWrit( cPar2 + cExpExt, MemoExpLst )
               ENDIF
            ENDIF
            IF bDelete
               FErase( cPar2 )
            ENDIF
         ENDIF
      ENDIF
   CASE cPar1 == "DELETE"
      Say( "US_Shell 900I: DELETE" )
      IF US_Words( cParam ) < 2
         Say( "US_Shell 901E: Invalid parameter count: " + cParam + CRLF )
         Say( "No file to delete!", .T. )
      ELSE
         Say( "US_Shell 901I: Processing: " + cParam )
         cPar2 := StrTran( US_Word( cParam, 2 ), "|", " " )
         IF File( cPar2 )
            IF FErase( cPar2 ) == -1
               Say( "US_Shell 902E: ERROR" + CRLF )
               Say( "Error deleting file!", .T. )
            ELSE
               Say( "US_Shell 902I: OK" + CRLF )
            ENDIF
         ELSE
            Say( "US_Shell 903W: File not found" + CRLF )
         ENDIF
      ENDIF
   CASE cPar1 == "CHANGE"
      Say( "US_Shell 910I: CHANGE" )
      IF US_Words( cParam ) != 4
         Say( "US_Shell 911E: Invalid parameter count: " + cParam + CRLF )
      ELSE
         Say( "US_Shell 911I: Processing: " + cParam )
         cPar2 := StrTran( US_Word( cParam, 2 ), "|", " " )
         cPar3 := US_Word( cParam, 3 )
         cPar4 := US_Word( cParam, 4 )
         Say( "               File: " + cPar2 )
         Say( "               Old String: " + if( cPar3 == "&", "(Character ampersand)", cPar3 ) )
         Say( "               New String: " + if( cPar4 == "&", "(Character ampersand)", cPar4 ) )
         IF ! File( cPar2 )
            Say( "US_Shell 912E: File not found" + CRLF )
            Say( "File not found!", .T. )
         ELSE
            IF hb_MemoWrit( cPar2, StrTran( MemoRead( cPar2 ), cPar3, cPar4 ) )
               Say( "US_Shell 913I: OK" + CRLF )
            ELSE
               Say( "US_Shell 913E: ERROR" + CRLF )
               Say( "Error changing file!", .T. )
            ENDIF
         ENDIF
      ENDIF
   CASE cPar1 == "ECHO"
      IF US_Words( cParam ) < 2
         __Run( "@ECHO." )
      ELSE
         cPar2 := StrTran( US_Word( cParam, 2 ), "|", " " )
         __Run( "@ECHO " + cPar2 )
      ENDIF
   OTHERWISE
      Say( "US_Shell 002E: Invalid parameter: " + cParam + CRLF )
   ENDCASE
   Say( CRLF )

   FErase( cFileStop )

   RETURN

//========================================================================
FUNCTION US_Shell_Listo( vFun )

   ASort( vFun, {|x, y| US_Word( x, 1 ) < US_Word( y, 1 ) } )
   AEval( vFun, {|x| Say( x ), Say( x, .T. ) } )

   RETURN NIL

//========================================================================
// FUNCION PARA EXTRAER UNA PALABRA DE UN ESTRING
//========================================================================
FUNCTION US_Word(ESTRING, POSICION)
   LOCAL CONT

   CONT := 1
   IF Posicion == NIL
      Posicion := 1
   ENDIF
   ESTRING := AllTrim( ESTRING )
   DO WHILE .T.
      IF At( " ", ESTRING ) != 0
         IF CONT == POSICION
            RETURN SubStr( ESTRING, 1, At( " ", ESTRING ) - 1 )
         ELSE
            ESTRING := AllTrim( SubStr( ESTRING, At( " ", ESTRING ) + 1 ) )
            CONT ++
         ENDIF
      ELSE
         IF POSICION == CONT
            RETURN ESTRING
         ELSE
            EXIT
         ENDIF
      ENDIF
   ENDDO

   RETURN ""

//========================================================================
// FUNCION PARA ELIMINAR UNA PALABRA DE UN STRING
//========================================================================
FUNCTION US_WordDel( ESTRING, POSICION )
   LOCAL cRet

   IF POSICION > 0
      cRet := AllTrim( SubStr( ESTRING, 1, US_WordInd( ESTRING, POSICION ) - 1 ) + ;
                       StrTran( SubStr( ESTRING, US_WordInd( ESTRING, POSICION ) ), US_Word( ESTRING, POSICION ), " ", 1, 1 ) )
   ELSE
      cRet := ESTRING
   ENDIF

   RETURN cRet

//========================================================================
// FUNCION PARA SABER LA POSICION DE LA PALABRA NUMERO ....
// ESTA FUNCION RETORNA EL BYTE DONDE EMPIEZA LA PALABRA
//========================================================================
FUNCTION US_WordInd( ESTRING, POSICION )
   LOCAL CONT, ESTR, ESTR2

   IF ESTRING == NIL
      ESTRING := ""
   ENDIF
   IF US_Words( Estring ) < Posicion
      RETURN ( Len( Estring ) + 1 )
   ENDIF
   CONT := 1
   ESTR := ESTRING
   ESTR2 := Rtrim( ESTRING )
   ESTRING := AllTrim( ESTRING )
   DO WHILE .T.
      IF At( " ", ESTRING ) != 0
         IF CONT == POSICION
            RETURN ( Len( ESTR ) - ( Len( ESTRING ) + ( Len( ESTR ) - Len( ESTR2 ) ) ) + 1 )
         ELSE
            ESTRING := AllTrim( SubStr( ESTRING, At( " ", ESTRING ) + 1 ) )
            CONT ++
         ENDIF
      ELSE
         IF POSICION == CONT
            RETURN ( Len( ESTR ) - ( Len( ESTRING ) + ( Len( ESTR ) - Len( ESTR2 ) ) ) + 1 )
         ELSE
            EXIT
         ENDIF
      ENDIF
   ENDDO

   RETURN 0

//========================================================================
// ESTA FUNCION TRANSFORMA EN MAYUSCULAS STRINGS, INCLUSO CON ACENTOS.
//========================================================================
FUNCTION US_Upper( STR )
   IF ValType( STR ) == "N"
      RETURN STR
   ENDIF

   RETURN Upper(StrTran(StrTran(StrTran(StrTran(StrTran(StrTran(StrTran(StrTran(StrTran(StrTran(StrTran(StrTran(StrTran(STR,"ü","U"),"ñ","N"),"Ñ","N"),"á","A"),"é","E"),"í","I"),"ó","O"),"ú","U"),"Á","A"),"É","E"),"Í","I"),"Ó","O"),"Ú","U"))

//========================================================================
// FUNCION PARA DETERMINAR EL NUMERO DE PALABRA DE UNA PALABRA EN UN ESTRING
// OJO, ES EL NUMERO DE PALABRA, NO EL BYTE DEL OFFSET
//========================================================================
FUNCTION US_WordPos( PAL, ESTRING )
   LOCAL I

   PAL := AllTrim( PAL )
   ESTRING := AllTrim( ESTRING )
   FOR I := 1 TO US_Words( ESTRING )
      IF PAL == US_Word( ESTRING, I )
         RETURN I
      ENDIF
   NEXT

   RETURN 0

//========================================================================
// FUNCION PARA retornar un SubStr a partir de la posicion de una palabra
//========================================================================
FUNCTION US_WordSubStr( estring, pos )

   IF Estring == NIL
      Estring := ""
   ENDIF

   RETURN SubStr( estring, US_WordInd( estring, pos ) )

//========================================================================
// FUNCION PARA CONTAR LAS PALABRAS EN UN ESTRING
//========================================================================
FUNCTION US_Words( ESTRING )
   LOCAL CONT := 0

   IF Estring == NIL
      Estring := ""
   ENDIF
   ESTRING := AllTrim( ESTRING )
   DO WHILE .T.
      IF At( " ", ESTRING) != 0
         ESTRING := AllTrim( SubStr( ESTRING, At( " ", ESTRING ) + 1 ) )
         CONT++
      ELSE
         IF Len( ESTRING ) > 0
             RETURN ( CONT + 1 )
         ELSE
            EXIT
         ENDIF
      ENDIF
   ENDDO

   RETURN CONT

//========================================================================
FUNCTION US_VarToStr( X )
   LOCAL T, StringAux := "", i

   IF X == NIL
      X := "*NIL*"
   ENDIF
   T = ValType( X )
   DO CASE
   CASE T = 'C'
      RETURN X
   CASE T = 'O'
      RETURN "*OBJ*"
   CASE T = 'U'
      RETURN "*UND*"
   CASE T = 'M'
      RETURN X
   CASE T = 'D'
      StringAux := DToS( X )
      RETURN StringAux
   CASE T = 'N'
      StringAux := US_StrCero( X )
      RETURN StringAux
   CASE T = 'L'
      StringAux := iif( X, '.T.', '.F.' )
      RETURN StringAux
   CASE T = 'A'
      FOR i := 1 TO Len( X ) - 1
         StringAux := StringAux + US_VarToStr( X[ i ] ) + hb_osNewLine()
      NEXT i
      IF Len( X ) > 0
         StringAux := StringAux + US_VarToStr( X[ Len( X ) ] )
      ENDIF
      RETURN StringAux
   ENDCASE

   RETURN ""

//========================================================================
FUNCTION US_StrCero( NUM, LONG, DEC )
   LOCAL INDICIO

   IF DEC == NIL
      IF LONG == NIL
         NUM := Str( NUM )
      ELSE
         NUM := Str( NUM, LONG )
      ENDIF
   ELSE
      NUM := Str( NUM, LONG, DEC )
   ENDIF
   LONG := Len( NUM )
   FOR INDICIO := 1 TO LONG
      IF SubStr( NUM, INDICIO, 1 ) == " "
         NUM := Stuff( NUM, INDICIO, 1, "0" )
      ENDIF
   NEXT

   RETURN NUM

//========================================================================
FUNCTION US_FileChar26Zap( cFile )

   LOCAL nHndIn, reto := -1, cAux := " ", cLinea := Space( 1024 ), nLeidosTotal, nLenFileOut, nLeidosLoop
   LOCAL cFileOut := US_FileNameOnlyPathAndName( cFile ) + "_T" + AllTrim( STR( INT( SECONDS() ) ) ) + "." + US_FileNameOnlyExt( cFile )
   LOCAL nHndOut

   nHndIn := FOpen( cFile, FO_READWRITE )
   FSeek( nHndIn, -1, 2 )
   IF FRead( nHndIn, @cAux, 1 ) == 1
      IF cAux == Chr( 26 )
         FSeek( nHndIn, 0, 0 )
         nLeidosTotal := 0
         IF ( nHndOut := FCreate( cFileOut ) ) >= 0
            nLenFileOut := US_FileSize( cFile ) - 1
            DO WHILE ( nLeidosLoop := FRead( nHndIn, @cLinea, iif( ( nLenFileOut - nLeidosTotal ) > 1024, 1024, nLenFileOut - nLeidosTotal ) ) ) > 0
               nLeidosTotal := nLeidosTotal + nLeidosLoop
               IF FWrite( nHndOut, cLinea, nLeidosLoop ) != nLeidosLoop
                  FClose( nHndIn )
                  FClose( nHndOut )
                  RETURN -1
               ENDIF
            ENDDO
            FClose( nHndOut )
         ELSE
            FClose( nHndIn )
            RETURN -1
         ENDIF
         reto := 1
      ELSE
         reto := 0
      ENDIF
   ENDIF
   FClose( nHndIn )
   IF reto == 1
      FErase( cFile )
      FRename( cFileOut, cFile )
   ENDIF

   RETURN Reto

//========================================================================
FUNCTION US_FileNameOnlyExt( arc )
   arc := SubStr( arc, RAt( DEF_SLASH, arc ) + 1 )
   IF US_IsDirectory( arc )
      RETURN ""
   ENDIF
   IF RAt( ".", arc ) == 0
      RETURN ""
   ENDIF

   RETURN SubStr( arc, RAt( ".", arc ) + 1 )

//========================================================================
FUNCTION US_FileNameOnlyName( arc )
   LOCAL barra, punto, reto

   IF arc == NIL
      arc := ""
   ENDIF
   barra := RAt( DEF_SLASH, arc )
   punto := RAt( ".", arc )
   DO CASE
   CASE punto > barra
      reto := SubStr( arc, barra + 1, punto - barra - 1 )
   CASE punto = 0
      reto := SubStr( arc, barra + 1 )
   CASE punto < barra
      reto := SubStr( arc, barra + 1 )
   ENDCASE

   RETURN reto

//========================================================================
FUNCTION US_FileSize( cFile )
   LOCAL vFile := Directory( cFile, "HS" )

   IF Len( vFile ) == 1
      RETURN vFile[1][2]
   ENDIF

   RETURN -1

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
FUNCTION US_FileNameOnlyPathAndName( arc )
   LOCAL cPath := US_FileNameOnlyPath( arc ), cName := US_FileNameOnlyName( arc )

   RETURN cPath + iif( ! Empty( cPath ) .AND. ! Empty( cName ), DEF_SLASH, "" ) + cName

//========================================================================
FUNCTION US_FileNameOnlyNameAndExt( arc )
   LOCAL cExt := US_FileNameOnlyExt( arc )

   RETURN US_FileNameOnlyName( arc ) + iif( ! Empty( cExt ), ".", "" ) + cExt

//========================================================================
FUNCTION US_IsDirectory( Dire )

   RETURN IsDirectory( Dire )

//========================================================================
FUNCTION Say( txt, lSay )

   IF HB_ISLOGICAL( lSay ) .AND. lSay
      __Run( "ECHO " + US_VarToStr( txt ) )
   ELSEIF bList
      SET CONSOLE OFF
      SET ALTERNATE TO ( cQPMDir + "QPM.LOG" ) ADDITIVE
      SET ALTERNATE ON
      ? DToS( Date() ) + " " + Time() + " US_SHELL " + ProcName( 2 ) + "(" + Str( ProcLine( 2 ), 3, 0 ) + ")" + " " + txt
      SET ALTERNATE OFF
      SET ALTERNATE TO
      SET CONSOLE ON
   ENDIF

   RETURN .T.

/* eof */
