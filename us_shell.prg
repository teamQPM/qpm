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

FUNCTION MAIN( ... )
   Local aParams := hb_aParams()
   Local Version := "01.06", cTxtAux := "", cTxtAux2 := "", i := 0
   Local cModuleNameAux := "?", cLineaAux := "", cLineaAux2 := "", bEncontroValido := .F.
   Local nPos := 0, bObjLst := .F., bExpLst := .F., cObjExt := ".ObjLst", cExpExt := ".ExpLst"
   Local MemoObjLst := "", MemoExpLst := "EXPORTS"
   Local bDelete := .F., cLastModuleFound := "", nZap := 0
   Local bPellesDynamic := .F.
   Local bBorlandDynamic := .F.
   Local bMinGWDynamic := .F.
   Local cDLL_Name := ""
   Local nDLL_NameAux := 0
   Local cDLL_NameFunAux := ""
   Local cDLL_NameMemoAux := ""
   Local cParam, cPar1, cPar2, cPar3, cPar4
   Local nLineaBaseExport := 0, vObjectsPelles := {}, vFuncionesPelles := {}, bFunList := .F.
   Private Tab := Replicate(" ", 0), vFun := {}, j := 0, bSay := .T., bError := .F., bWarning := .F., cFileStop := ""
   Private cTimeStamp := ""

   cParam := ""
   For i := 1 To Len( aParams )
      cParam += ( aParams[ i ] + " " )
   Next i
   cParam := AllTrim( cParam )

   cPar1 := Upper( US_Word( cParam, 1 ) )
   If cPar1 == "-VER" .or. cPar1 == "-VERSION"
      MemoWrit( "US_Shell.version", Version )
      Return .T.
   ElseIf cPar1 != "QPM"
      Say( "US_Shell 999E: Running Outside System" )
      ERRORLEVEL( 1 )
      Return -1
   Else
      cParam := US_WordDel( cParam, 1 )
   EndIf

   If ( nPos := US_WordPos( "-OFF", US_Upper( cParam ) ) ) > 0
      cParam := US_WordDel( cParam, nPos )
      bSay := .F.
   EndIf

   If ( nPos := US_WordPos( "-FILESTOP", US_Upper( cParam ) ) ) > 0
      If US_Words( cParam ) == nPos
         Say( "US_Shell 934E: FILESTOP without FileName, USE: -FILESTOP cDisc:\cPath\cFileName.ext", .T. )
         ERRORLEVEL( 1 )
         Return -1
      EndIf
      cFileStop := StrTran( US_Word( cParam, nPos + 1 ), "|", " " )
      Say( "US_Shell 933I: FILESTOP: " + cFileStop )
      cParam := US_WordDel( cParam, nPos + 1 )
      cParam := US_WordDel( cParam, nPos )
   EndIf

   cPar1 := Upper( US_Word( cParam, 1 ) )

   Do Case
   Case cPar1 == "CHECKRC"
      If US_Words( cParam ) < 2
         Say( "US_Shell 410E: Invalid parm (count): " + cParam, .T. )
         bError := .T.
      Else
         Say( "US_Shell 000I: Processing: " + cParam )
         Say( "US_Shell 300I: CheckRC" )
         cPar2 := US_Word( cParam, 2 )
         Say( "       Option: " + cPar2 )
         If Upper( cPar2 ) == "NOTFILE"
            cPar3 := StrTran( US_Word( cParam, 3 ), "|", " " )
            Say( "         File: " + cPar3 )
            If ! File( cPar3 )
               Say( "US_Shell 380I: File Not Found: " + cPar3, .T. )
               bError := .T.
            Else
               Say( "US_Shell 386I: File Found: " + cPar3 + ' (' + AllTrim( Str( US_FileSize( cPar3 ) ) ) + ' bytes)' )
            EndIf
         Else
            Say( "US_Shell 401E: Invalid parm (options 2): " + cPar2, .T. )
            bError := .T.
         EndIf
      EndIf
   case cPar1 == "COPY" .or. cPar1 == "COPYZAP"
      If US_Words( cParam ) < 3
         Say( "US_Shell 010E: Invalid parm (count): " + cParam )
         bError := .T.
      Else
         Say( "US_Shell 000I: Processing: " + cParam )
         Say( "US_Shell 011I: Copy file" )
         cPar2 := StrTran( US_Word( cParam, 2 ), "|", " " )
         Say( "         File In: " + cPar2 )
         cPar3 := StrTran( US_Word( cParam, 3 ), "|", " " )
         Say( "         File Out: " + cPar3 )
         If ! File( cPar2 )
            Say( "US_Shell 012E: Input file not found: " + cPar2 )
            bError := .T.
         Else
            If ! US_IsDirectory( US_FileNameOnlyPath( cPar3 ) )
               Say( "US_Shell 015E: Output Folder not found: " + cPar3 )
               bError := .T.
            Else
               If FileCopy( cPar2, cPar3 ) == US_FileSize( cPar2 )
                  Say( "US_Shell 013I: Copy file OK" )
                  If cPar1 == "COPYZAP"
                     nZap := US_FileChar26Zap( cPar3 )
                     Do Case
                     Case nZap == -1
                        Say( "US_Shell 234W: Warning, char x'1A' not removed" )
                     Case nZap == 1
                        Say( "US_Shell 235I: Char x'1A' removed" )
                     EndCase
                  EndIf
               Else
                  Say( "US_Shell 014E: Error in File Copy !!!" )
                  Say( "               " + cPar3 + " Is Running or Open by Another Application ???" )
                  bError := .T.
               EndIf
            EndIf
         EndIf
      EndIf
      If bError .and. ! bSay
         Say( "US_Shell 016E: Error in File Copy !!!", .T. )
      EndIf
   Case cPar1 == "MOVE" .or. cPar1 == "MOVEZAP"
      If US_Words( cParam ) < 3
         Say( "US_Shell 020E: Invalid parm (count): " + cParam )
         bError := .T.
      Else
         Say( "US_Shell 000I: Processing: " + cParam )
         Say( "US_Shell 021I: Move file" )
         cPar2 := StrTran( US_Word( cParam, 2 ), "|", " " )
         Say( "         File In: " + cPar2 )
         cPar3 := StrTran( US_Word( cParam, 3 ), "|", " " )
         Say( "         File Out: " + cPar3 )
         If ! File( cPar2 )
            Say( "US_Shell 022E: Input file not found: " + cPar2 )
            bError := .T.
         Else
            If ! US_IsDirectory( US_FileNameOnlyPath( cPar3 ) )
               Say( "US_Shell 025E: Output Folder not found: " + cPar3 )
               bError := .T.
            Else
               If FileCopy( cPar2, cPar3 ) != US_FileSize( cPar2 )
                  Say( "US_Shell 023E: Error in File Move (File Copy error !!!)" )
                  Say( "               " + cPar3 + " Is Running or Open by Another Application ???" )
                  bError := .T.
               Else
                  If FErase( cPar2 ) == -1
                     Say( "US_Shell 026E: Error in Move file (Original file not deleted !!! )" )
                     bError := .T.
                  Else
                     Say( "US_Shell 024I: Move file OK" )
                     If cPar1 == "MOVEZAP"
                        nZap := US_FileChar26Zap( cPar3 )
                        Do Case
                        Case nZap == -1
                           Say( "US_Shell 234W: Warning, char x'1A' not removed" )
                        Case nZap == 1
                           Say( "US_Shell 235I: Char x'1A' removed" )
                        EndCase
                     EndIf
                     MemoWrit( cPar2 + ".MOVED.TXT", "File " + cPar2 + " has been moved to: " + cPar3 )
                  EndIf
               EndIf
            EndIf
         EndIf
      EndIf
      If bError .and. ! bSay
         Say( "US_Shell 027E: Error in File Move !!!", .T. )
      EndIf
   Case cPar1 == "LIST_TXT"
      If US_Words( cParam ) < 2
         Say( "US_Shell 080E: Invalid parm (count): " + cParam )
         bError := .T.
      Else
         Say( "US_Shell 000I: Processing: " + cParam )
         If ( nPos := US_WordPos( "-DELETE", US_Upper( cParam ) ) ) > 0
            cParam := US_WordDel( cParam, nPos )
            bDelete := .T.
         EndIf
         Say( "US_Shell 081I: Listing Content File" )
         cPar2 := StrTran( US_Word( cParam, 2 ), "|", " " )
         Say( "US_Shell 087I: File to List: " + cPar2 )
         If ! File( cPar2 )
            Say( "US_Shell 082E: Input file not found: " + cPar2 )
            bError := .T.
         Else
            cTxtAux := MemoRead( cPar2 )
            For i := 1 To MLCount( cTxtAux, 254 )
               Say( MemoLine( cTxtAux, 254, i ) )
               If US_Shell_bStop()
                  Say( "US_Shell 930W: User Stop" )
                  bWarning := .T.
                  Exit
               EndIf
            Next i
            Say( "US_Shell 088I: End List" )
            If bDelete
               FErase( cPar2 )
            EndIf
         EndIf
      EndIf
      If bError .and. ! bSay
         Say( "US_Shell 087E: Error in List Txt !!!", .T. )
      EndIf
   Case cPar1 == "ANALIZE_DLL"
      If US_Words( cParam ) < 2
         Say( "US_Shell 030E: Invalid parm (count): " + cParam )
         bError := .T.
      Else
         Say( "US_Shell 000I: Processing: " + cParam )
         If ( nPos := US_WordPos( "-DELETE", US_Upper( cParam ) ) ) > 0
            cParam := US_WordDel( cParam, nPos )
            bDelete := .T.
         EndIf
         Say( "US_Shell 031I: Analizing Definition File For Dynamic Library (DLL)" )
         cPar2 := StrTran( US_Word( cParam, 2 ), "|", " " )
         Say( "         File In: " + cPar2 )
         If ! File( cPar2 )
            Say( "US_Shell 032E: Input file not found: " + cPar2 )
            bError := .T.
         Else
            Say( "Functions Exported For this DLL: ", .T. )
            cTxtAux := MemoRead( cPar2 )
            nLineaBaseExport := MLCount( cTxtAux, 254 )
            For i := 1 To MLCount( cTxtAux, 254 )
               If AllTrim( MemoLine( cTxtAux, 254, i ) ) == "EXPORTS"
                  nLineaBaseExport := i + 1
               EndIf
            Next i
            For i := nLineaBaseExport To MLCount( cTxtAux, 254 )
               cLineaAux := US_Word( MemoLine( cTxtAux, 254, i ), 1 )
               Say( "             " + PadL( AllTrim( Str( i - nLineaBaseExport + 1 ) ), 5 ) + ": " + cLineaAux, .T. )
               If US_Shell_bStop()
                  Say( "US_Shell 930W: User Stop" )
                  bWarning := .T.
                  Exit
               EndIf
            Next i
            Say( "End Functions List", .T. )
            If bDelete
               FErase( cPar2 )
            EndIf
         EndIf
      EndIf
      If bError .and. ! bSay
         Say( "US_Shell 007E: Error in Analize DLL !!!", .T. )
      EndIf
   Case cPar1 == "ANALIZE_LIB_PELLES"
      If US_Words( cParam ) < 2
         Say( "US_Shell 040E: Invalid parm (count): " + cParam )
         bError := .T.
      Else
         Say( "US_Shell 000I: Processing: " + cParam )
         If ( nPos := US_WordPos( "-DELETE", US_Upper( cParam ) ) ) > 0
            cParam := US_WordDel( cParam, nPos )
            bDelete := .T.
         EndIf
         If ( nPos := US_WordPos( "-OBJLST", US_Upper( cParam ) ) ) > 0
            cParam := US_WordDel( cParam, nPos )
            bObjLst := .T.
         EndIf
         If ( nPos := US_WordPos( "-EXPLST", US_Upper( cParam ) ) ) > 0
            cParam := US_WordDel( cParam, nPos )
            bExpLst := .T.
         EndIf
         Say( "US_Shell 041I: Analizing Definition File For Pelles Static Library" )
         cPar2 := StrTran( US_Word( cParam, 2 ), "|", " " )
         Say( "         File In: " + cPar2 )
         If bObjLst
            Say( "         File Out: " + cPar2 + cObjExt )
         EndIf
         If bExpLst
            Say( "         File Out: " + cPar2 + cExpExt )
         EndIf
         If ! File( cPar2 )
            Say( "US_Shell 042E: Input file not found: " + cPar2 )
            bError := .T.
         Else
            Say( "Functions List For this LIB: ", .T. )
            bPellesDynamic := .F.
            cTxtAux := MemoRead( cPar2 )
            For i := 1 To MLCount( cTxtAux, 254 )
               cLineaAux := MemoLine( cTxtAux, 254, i )
               If at( "Long name: ", cLineaAux ) == 1
                  aAdd( vObjectsPelles, US_FileNameOnlyName( SubStr( cLineaAux, 12 ) ) )
               EndIf
            Next i
            If Len( vObjectsPelles ) == 0
               bPellesDynamic := .T.
               cDLL_Name := StrTran( US_Word( SubStr( cTxtAux, RAt( "Member at offset", cTxtAux ) ), 5 ), "/", "" )
            EndIf
            bFunList := .F.
            For i := 1 To MLCount( cTxtAux, 254 )
               cLineaAux := MemoLine( cTxtAux, 254, i )
               If US_Word( cLineaAux, 2 ) == "global" .and. ;
                  US_Word( cLineaAux, 3 ) == "symbols" .and. ;
                  US_Words( cLineaAux ) == 3
                  bFunList := .T.
               EndIf
               If bFunList .and. ;
                  US_Word( cLineaAux, 1 ) == "Member" .and. ;
                  US_Word( cLineaAux, 2 ) == "at" .and. ;
                  US_Word( cLineaAux, 3 ) == "offset"
                  exit
               EndIf
               If bFunList .and. ;
                  US_Words( cLineaAux ) == 2
                  If bPellesDynamic
                     aAdd( vFuncionesPelles, "DYNAMIC " + cDLL_Name + " " + US_Word( cLineaAux, 2 ) )
                  Else
                     aAdd( vFuncionesPelles, "STATIC " + vObjectsPelles[ Val( NToC( US_Word( cLineaAux, 1 ), 10 ) ) ] + " " + US_Word( cLineaAux, 2 ) )
                  EndIf
               EndIf
            Next i
            aSort( vFuncionesPelles, { |x, y| x < y } )
            If Len( vFuncionesPelles ) == 0
               cTxtAux2 := 'No public symbols exist.'
            Else
               For i := 1 To len( vFuncionesPelles )
                  cTxtAux2 := cTxtAux2 + vFuncionesPelles[i] + HB_OsNewLine()
               Next i
            EndIf
            cTxtAux := cTxtAux2
            If AllTrim( MemoLine( cTxtAux, 254, 1 ) ) == 'No public symbols exist.'
               Say( "US_Shell 048W: " + AllTrim( MemoLine( cTxtAux, 254, 1 ) ) )
               bWarning := .T.
            Else
               cModuleNameAux := "."
               For i := 1 To MLCount( cTxtAux, 254 )
                  cLineaAux := MemoLine( cTxtAux, 254, i )
                  If US_Word( cLineaAux, 2 ) != cModuleNameAux
                     US_Shell_Listo()
                     cModuleNameAux := US_Word( cLineaAux, 2 )
                     If US_Word( cLineaAux, 1 ) == "DYNAMIC"
                        Say( "    Dynamic link import (IMPDEF) From " + cModuleNameAux, .T. )
                     Else
                        Say( "    Static Module " + cModuleNameAux, .T. )
                        If bObjLst
                           MemoObjLst := MemoObjLst + If( ! Empty( MemoObjLst ), hb_OsNewLine(), "" ) + cModuleNameAux
                        EndIf
                     EndIf
                  EndIf
                  If ! Empty( cLineaAux )
                     cModuleNameAux := US_Word( cLineaAux, 2 )
                     aadd( vFun, "             " + SubStr( US_Word( cLineaAux, 3 ), 1 ) )
                     If bExpLst
                        MemoExpLst := MemoExpLst + hb_OsNewLine() + SubStr( US_Word( cLineaAux, 3 ), 1 )
                     EndIf
                  EndIf
                  If US_Shell_bStop()
                     Say( "US_Shell 930W: User Stop" )
                     bWarning := .T.
                     exit
                  EndIf
               Next i
               US_Shell_Listo()
               Say( "End Functions List", .T. )
               If bObjLst
                  MemoWrit( cPar2 + cObjExt, MemoObjLst )
               EndIf
               If bExpLst
                  MemoWrit( cPar2 + cExpExt, MemoExpLst )
               EndIf
            EndIf
            If bDelete
               FErase( cPar2 )
            EndIf
         EndIf
      EndIf
   Case cPar1 == "ANALIZE_LIB_BORLAND"
      If US_Words( cParam ) < 2
         Say( "US_Shell 140E: Invalid parm (count): " + cParam )
         bError := .T.
      Else
         Say( "US_Shell 000I: Processing: " + cParam )
         If ( nPos := US_WordPos( "-DELETE", US_Upper( cParam ) ) ) > 0
            cParam := US_WordDel( cParam, nPos )
            bDelete := .T.
         EndIf
         If ( nPos := US_WordPos( "-OBJLST", US_Upper( cParam ) ) ) > 0
            cParam := US_WordDel( cParam, nPos )
            bObjLst := .T.
         EndIf
         If ( nPos := US_WordPos( "-EXPLST", US_Upper( cParam ) ) ) > 0
            cParam := US_WordDel( cParam, nPos )
            bExpLst := .T.
         EndIf
         Say( "US_Shell 141I: Analizing Definition File For Borland Static Library" )
         cPar2 := StrTran( US_Word( cParam, 2 ), "|", " " )
         Say( "         File In: " + cPar2 )
         If bObjLst
            Say( "         File Out: " + cPar2 + cObjExt )
         EndIf
         If bExpLst
            Say( "         File Out: " + cPar2 + cExpExt )
         EndIf
         If ! File( cPar2 )
            Say( "US_Shell 142E: Input file not found: " + cPar2 )
            bError := .T.
         Else
            Say( "Functions List For this LIB: ", .T. )
            cTxtAux := MemoRead( cPar2 )
            If AllTrim( MemoLine( cTxtAux, 254, 1 ) ) == 'No public symbols exist.'
               Say( "US_Shell 148W: " + AllTrim( MemoLine( cTxtAux, 254, 1 ) ) )
               bWarning := .T.
            Else
               bBorlandDynamic := .F.
               For i := 1 To MLCount( cTxtAux, 254 )
                  cLineaAux := MemoLine( cTxtAux, 254, i )
                  If US_Word( cLineaAux, 2 ) == "size" .and. ;
                     US_Word( cLineaAux, 3 ) == "="
                     US_Shell_Listo()
                     cModuleNameAux := US_Word( cLineaAux, 1 )
                     If Val( US_Word( cLineaAux, 4 ) ) = 0
                        If ! bBorlandDynamic
                           cDLL_NameFunAux := US_Word( cLineaAux, 1 )
                           cDLL_NameMemoAux := MemoRead( US_FileNameOnlyPathAndName( cPar2 ) )
                           cDLL_NameMemoAux := SubStr( cDLL_NameMemoAux, At( Chr( 14 ) + cDLL_NameFunAux + Chr( 12 ), cDLL_NameMemoAux ) )
                           cDLL_NameMemoAux := StrTran( cDLL_NameMemoAux, Chr( 12 ), " " )
                           cDLL_NameMemoAux := US_Word( cDLL_NameMemoAux, 2 )
                           cDLL_Name := SubStr( cDLL_NameMemoAux, 1, RAt( ".DLL", Upper( cDLL_NameMemoAux ) ) + 3 )
                           Say( "    Dynamic link import (IMPDEF) From " + cDLL_Name, .T. )
                           bBorlandDynamic := .T.
                        EndIf
                     Else
                        Say( "    Static Module " + cModuleNameAux, .T. )
                        If bObjLst
                           MemoObjLst := MemoObjLst + If( ! Empty( MemoObjLst ), hb_OsNewLine(), "" ) + cModuleNameAux
                        EndIf
                     EndIf
                  Else
                     If ! Empty( cLineaAux ) .and. cLineaAux != "Publics by module"
                        aAdd( vFun, "             " + SubStr( US_Word( cLineaAux, 1 ), 1 ) )
                        If bExpLst
                           MemoExpLst := MemoExpLst + hb_OsNewLine() + SubStr( US_Word( cLineaAux, 1 ), 1 )
                        EndIf
                        If US_Words( cLineaAux ) == 2
                           aAdd( vFun, "             " + SubStr( US_Word( cLineaAux, 2 ), 1 ) )
                           If bExpLst
                              MemoExpLst := MemoExpLst + hb_OsNewLine() + SubStr( US_Word( cLineaAux, 2 ), 1 )
                           EndIf
                        EndIf
                     EndIf
                  EndIf
                  If US_Shell_bStop()
                     Say( "US_Shell 930W: User Stop" )
                     bWarning := .T.
                     Exit
                  EndIf
               Next i
               US_Shell_Listo()
               Say( "End Functions List", .T. )
               If bObjLst
                  MemoWrit( cPar2 + cObjExt, MemoObjLst )
               EndIf
               If bExpLst
                  MemoWrit( cPar2 + cExpExt, MemoExpLst )
               EndIf
            EndIf
            If bDelete
               FErase( cPar2 )
            EndIf
         EndIf
      EndIf
   Case cPar1 == "ANALIZE_LIB_MINGW"
      If US_Words( cParam ) < 2
         Say( "US_Shell 050E: Invalid parm (count): " + cParam )
         bError := .T.
      Else
         Say( "US_Shell 000I: Processing: " + cParam )
         If ( nPos := US_WordPos( "-DELETE", US_Upper( cParam ) ) ) > 0
            cParam := US_WordDel( cParam, nPos )
            bDelete := .T.
         EndIf
         If ( nPos := US_WordPos( "-OBJLST", US_Upper( cParam ) ) ) > 0
            cParam := US_WordDel( cParam, nPos )
            bObjLst := .T.
         EndIf
         If ( nPos := US_WordPos( "-EXPLST", US_Upper( cParam ) ) ) > 0
            cParam := US_WordDel( cParam, nPos )
            bExpLst := .T.
         EndIf
         Say( "US_Shell 051I: Analizing Definition File For MinGW Static Library" )
         cPar2 := StrTran( US_Word( cParam, 2 ), "|", " " )
         Say( "         File In: " + cPar2 )
         If bObjLst
            Say( "         File Out: " + cPar2 + cObjExt )
         EndIf
         If bExpLst
            Say( "         File Out: " + cPar2 + cExpExt )
         EndIf
         If ! File( cPar2 )
            Say( "US_Shell 052E: Input file not found: " + cPar2 )
            bError := .T.
         Else
            Say( "Functions List For this LIB (.A): ", .T. )
            cTxtAux := MemoRead( cPar2 )
            bMinGWDynamic := .F.
            For i := 1 To MLCount( cTxtAux, 254 )
               cLineaAux := MemoLine( cTxtAux, 254, i )
               cLineaAux2 := MemoLine( cTxtAux, 254, i + 1 )
               If US_Words( cLineaAux ) > 3
                  If AllTrim( US_WordSubStr( cLineaAux, 2 ) ) == "file format pe-i386"
                     cLastModuleFound := US_Word( cLineaAux, 1 )
                     cLastModuleFound := AllTrim( StrTran( cLastModuleFound, ":", "" ) )
                  EndIf
               EndIf
               If US_Word( cLineaAux, 1 ) == "SYMBOL" .and. ;
                  US_Word( cLineaAux, 2 ) == "TABLE:"
                  cModuleNameAux := US_Word( cLineaAux2, US_Words( cLineaAux2 ) )
                  // ignore first two files in import originated libraries
                  If cModuleNameAux == "fake"
                     bEncontroValido := .F.
                     Loop
                  EndIf
                  // is a module originated by import
                  If cModuleNameAux == ".text"
                     bEncontroValido := .F.
                     cModuleNameAux := cLastModuleFound
                     If ! bMinGWDynamic
                        cDLL_Name := SubStr( cTxtAux, at( "Contents of section", cTxtAux ) )
                        nDLL_NameAux := RAt( " ", SubStr( cDLL_Name, 1, At( ".DLL....", Upper( cDLL_Name ) ) ) ) + 1
                        cDLL_Name := StrTran( US_Word( SubStr( cDLL_Name, nDLL_NameAux ), 1 ), "....", "" )
                        Say( "    Dynamic link import (IMPDEF) From " + cDLL_Name, .T. )
                        bMinGWDynamic := .T.
                     EndIf
                     aAdd( vFun, "             " + US_Word( MemoLine( cTxtAux, 254, i + 8 ), US_Words( MemoLine( cTxtAux, 254, i + 8 ) ) ) )
                     Loop
                  Else
                     // standard module
                     US_Shell_Listo()
                     bEncontroValido := .T.
                     cModuleNameAux := SubStr( cModuleNameAux, 1, RAt( ".", cModuleNameAux ) - 1 )
                     Say( "    Static Module " + cModuleNameAux, .T. )
                     If bObjLst
                        MemoObjLst := MemoObjLst + If( ! Empty( MemoObjLst ), hb_OsNewLine(), "" ) + cModuleNameAux
                     EndIf
                  EndIf
               Else
                  // function in standard module
                  If AllTrim( cLineaAux ) == "File" .and. bEncontroValido
                     For j := i + 1 To MLCount( cTxtAux, 254 )
                        cLineaAux = MemoLine( cTxtAux, 254, j )
                        If SubStr( US_Word( cLineaAux, US_Words( cLineaAux ) ), 1, 7 ) == "_HB_FUN"
                           aAdd( vFun, "             " + US_Word( cLineaAux, US_Words( cLineaAux ) ) )
                           If bExpLst
                              MemoExpLst := MemoExpLst + hb_OsNewLine() + US_Word( cLineaAux, US_Words( cLineaAux ) )
                           EndIf
                           i := j
                        EndIf
                        If SubStr( US_Word( cLineaAux, US_Words( cLineaAux ) ), 1, 1 ) == "." .or. ;
                           ( !( SubStr( US_Word( cLineaAux, 1 ), 1, 1 ) == "[" ) .and. !( US_Word( cLineaAux, 1 ) == "AUX" ) )
                           i := j
                           Exit
                        EndIf
                        If US_Shell_bStop()
                           Exit
                        EndIf
                     Next j
                     bEncontroValido := .F.
                  EndIf
               EndIf
               If US_Shell_bStop()
                  Say( "US_Shell 930W: User Stop" )
                  bWarning := .T.
                  Exit
               EndIf
            Next i
            US_Shell_Listo()
            Say( "End Functions List", .T. )
            If bObjLst
               MemoWrit( cPar2 + cObjExt, MemoObjLst )
            EndIf
            If bExpLst
               MemoWrit( cPar2 + cExpExt, MemoExpLst )
            EndIf
            If bDelete
               FErase( cPar2 )
            EndIf
         EndIf
      EndIf
   Case cPar1 == "DELETE"
      If US_Words( cParam ) < 2
         Say( "US_Shell 060E: Invalid parm (count): " + cParam )
         bError := .T.
      Else
         Say( "US_Shell 000I: Processing: " + cParam )
         cPar2 := StrTran( US_Word( cParam, 2 ), "|", " " )
         If File( cPar2 )
            If FErase( cPar2 ) == -1
               Say( "US_Shell 064E: Error in File Delete !!!" )
               bError := .T.
            Else
               Say( "US_Shell 065I: File Deleted OK" )
            EndIf
         Else
            Say( "US_Shell 066E: File not found" )
         EndIf
      EndIf
      If bError .and. ! bSay
         Say( "US_Shell 067E: Error in File Delete !!!", .T. )
      EndIf
   Case cPar1 == "CHANGE"
      If US_Words( cParam ) != 4
         Say( "US_Shell 070E: Invalid parm (count): " + cParam )
         bError := .T.
      Else
         cPar2 := StrTran( US_Word( cParam, 2 ), "|", " " )
         cPar3 := US_Word( cParam, 3 )
         cPar4 := US_Word( cParam, 4 )
         Say( "US_Shell 071I: Change into File" )
         Say( "               File: " + cPar2 )
         Say( "               Old String: " + if( cPar3 == "&", "(Character ampersand)", cPar3 ) )
         Say( "               New String: " + if( cPar4 == "&", "(Character ampersand)", cPar4 ) )
         If ! File( cPar2 )
            Say( "US_Shell 072E: Input file not found: " + cPar2 )
            bError := .T.
         Else
            If MemoWrit( cPar2, StrTran( MemoRead( cPar2 ), cPar3, cPar4 ) )
               Say( "US_Shell 073I: Change OK" )
            Else
               Say( "US_Shell 074E: Error in Change File !!!" )
               bError := .T.
            EndIf
         EndIf
      EndIf
   Case cPar1 == "ECHO"
      If US_Words( cParam ) < 2
         __Run( "@ECHO." )
      Else
         cPar2 := StrTran( US_Word( cParam, 2 ), "|", " " )
         __Run( "@ECHO " + cPar2 )
      EndIf
   Otherwise
      Say( "US_Shell 002E: Invalid parm: " + cParam )
      bError := .T.
   EndCase

   FErase( cFileStop )
   If bWarning
      ERRORLEVEL( 2 )
   EndIf
   If bError
      ERRORLEVEL( 1 )
   EndIf
Return .T.

Function US_Shell_bStop()
   If File( cFileStop )
      Return .T.
   EndIf
Return .F.

Function US_Shell_Listo()
   asort( vFun, {|x, y| US_Word( x, 1 ) < US_Word( y, 1 ) } )
   For j := 1 To len( vFun )
      Say( vFun[j], .T. )
      If US_Shell_bStop()
         Say( "US_Shell 930W: User Stop" )
         bWarning := .T.
         exit
      EndIf
   Next
   vFun := {}
Return .T.

Function Say( txt, lSay )
   If If( lSay == Nil, bSay, lSay )
      __Run( "ECHO " + Tab + US_VarToStr( txt ) )
   EndIf
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
// ESTA FUNCION TRANSFORMA EN MAYUSCULAS STRINGS, INCLUSO CON ACENTOS.
//========================================================================
FUNCTION US_Upper(STR)
   IF valType( STR ) == "N"
      Return STR
   endif
RETURN upper(STRTRAN(STRTRAN(STRTRAN(STRTRAN(STRTRAN(STRTRAN(STRTRAN(STRTRAN(STRTRAN(STRTRAN(STRTRAN(STRTRAN(STRTRAN(STR,"ü","U"),"ñ","N"),"Ñ","N"),"á","A"),"é","E"),"í","I"),"ó","O"),"ú","U"),"Á","A"),"É","E"),"Í","I"),"Ó","O"),"Ú","U"))

//========================================================================
// FUNCION PARA DETERMINAR EL NUMERO DE PALABRA DE UNA PALABRA EN UN ESTRING
// OJO, ES EL NUMERO DE PALABRA, NO EL BYTE DEL OFFSET
//========================================================================
FUNCTION US_WORDPOS(PAL,ESTRING)
   LOCAL I
   PAL:=ALLTRIM(PAL)
   ESTRING:=ALLTRIM(ESTRING)
   FOR I:=1 TO US_WORDS(ESTRING)
      IF PAL == US_WORD(ESTRING,I)
         RETURN I
      ENDIF
   NEXT
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

Function US_FileChar26Zap( cFile )
   Local nHndIn, reto := -1, cAux := " ", cLinea := Space( 1024 ), nLeidosTotal, nLenFileOut, nLeidosLoop
   Local cFileOut := US_FileNameOnlyPathAndName( cFile ) + "_T" + ALLTRIM( STR( INT( SECONDS() ) ) ) + "." + US_FileNameOnlyExt( cFile )
   Local nHndOut
   nHndIn := fopen( cFile, FO_READWRITE )
   fseek( nHndIn, -1, 2 )
   if fread( nHndIn, @cAux, 1 ) == 1
      if cAux == chr( 26 )
         fseek( nHndIn, 0, 0 )
         nLeidosTotal := 0
         if ( nHndOut := fcreate( cFileOut ) ) >= 0
            nLenFileOut :=  US_FileSize( cFile ) - 1
            do while ( nLeidosLoop := fread( nHndIn, @cLinea, if( ( nLenFileOut - nLeidosTotal ) > 1024, 1024, nLenFileOut - nLeidosTotal ) ) ) > 0
               nLeidosTotal := nLeidosTotal + nLeidosLoop
               if fwrite( nHndOut, cLinea, nLeidosLoop ) != nLeidosLoop
                  fclose( nHndIn )
                  fclose( nHndOut )
                  return -1
               endif
            enddo
            fclose( nHndOut )
         else
            fclose( nHndIn )
            return -1
         endif
         reto := 1
      else
         reto := 0
      endif
   endif
   fclose( nHndIn )
   if reto == 1
      ferase( cFile )
      frename( cFileOut, cFile )
   endif
RETURN Reto

FUNCTION US_FileNameOnlyExt( arc )
   arc := SubStr( arc, RAt( DEF_SLASH, arc ) + 1 )
   if US_IsDirectory( arc )
      Return ""
   endif
   if RAt( ".", arc ) == 0
      RETURN ""
   endif
RETURN substr( arc, rat( ".", arc ) + 1 )

FUNCTION US_FileNameOnlyName( arc )
   LOCAL barra, punto, reto
   if arc == NIL
      arc := ""
   endif
   barra := RAt( DEF_SLASH, arc )
   punto := RAt( ".", arc )
   do case
   case punto > barra
      reto := SubStr( arc, barra + 1, punto - barra - 1 )
   case punto = 0
      reto := SubStr( arc, barra + 1 )
   case punto < barra
      reto := SubStr( arc, barra + 1 )
   endcase
RETURN reto

FUNCTION US_FileSize( cFile )
   LOCAL vFile
   vFile := Directory( cFile, "HS" )
   if Len( vFile ) == 1
      RETURN vFile[1][2]
   endif
RETURN -1

FUNCTION US_FileNameOnlyPath( arc )
   if arc == NIL
      RETURN ""
   endif
   if US_IsDirectory( arc )
      RETURN arc
   endif
RETURN SubStr( arc, 1, RAt( DEF_SLASH, arc ) - 1 )

FUNCTION US_FileNameOnlyPathAndName( arc )
   LOCAL cPath := US_FileNameOnlyPath( arc ), cName := US_FileNameOnlyName( arc )
RETURN cPath + iif( ! Empty( cPath ) .AND. ! Empty( cName ), DEF_SLASH, "" ) + cName

FUNCTION US_FileNameOnlyNameAndExt( arc )
   LOCAL cExt := US_FileNameOnlyExt( arc )
RETURN US_FileNameOnlyName( arc ) + iif( ! Empty( cExt ), ".", "" ) + cExt

FUNCTION US_IsDirectory( Dire )
RETURN IsDirectory( Dire )

/* eof */
