/*
 * $Id$
 */

/*
 *    QPM - QAC Based Project Manager
 *
 *    Copyright 2011-2014 Fernando Yurisich <fernando.yurisich@gmail.com>
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
      MsgInfo( "US_Run 124: Paramters File Not Found: " + cParam )
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

/* eof */
