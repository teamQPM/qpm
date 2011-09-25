/*
 * $Id$
 */

/*
 *    QPM - QAC Based Project Manager
 *
 *    Copyright 2011 Fernando Yurisich <fernando.yurisich@gmail.com>
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
#include "Fileio.ch"

// Codigos de error en: http://msdn2.microsoft.com/en-us/library/ms681382(VS.85).aspx

FUNCTION MAIN(cP1,cP2,cP3,cP4,cP5,cP6,cP7,cP8,cP9,cP10,cP11,cP12,cP13,cP14,cP15,cP16,cP17,cP18,cP19,cP20)
   Local Version:="01.01" , bOk:=.T. , nLineSize := 1024
   Local cParam , MemoAux := "" , i , cLineaAux := ""
   Private cCMD , cControlFile , cDefaultPath , cCurrentPath , cMode:="NORMAL"                // , cFileStop := ""

   cP1 =IIF(cP1 =NIL,"",cP1 )
   cP2 =IIF(cP2 =NIL,"",cP2 )
   cP3 =IIF(cP3 =NIL,"",cP3 )
   cP4 =IIF(cP4 =NIL,"",cP4 )
   cP5 =IIF(cP5 =NIL,"",cP5 )
   cP6 =IIF(cP6 =NIL,"",cP6 )
   cP7 =IIF(cP7 =NIL,"",cP7 )
   cP8 =IIF(cP8 =NIL,"",cP8 )
   cP9 =IIF(cP9 =NIL,"",cP9 )
   cP10=IIF(cP10=NIL,"",cP10)
   cP11=IIF(cP11=NIL,"",cP11)
   cP12=IIF(cP12=NIL,"",cP12)
   cP13=IIF(cP13=NIL,"",cP13)
   cP14=IIF(cP14=NIL,"",cP14)
   cP15=IIF(cP15=NIL,"",cP15)
   cP16=IIF(cP16=NIL,"",cP16)
   cP17=IIF(cP17=NIL,"",cP17)
   cP18=IIF(cP18=NIL,"",cP18)
   cP19=IIF(cP19=NIL,"",cP19)
   cP20=IIF(cP20=NIL,"",cP20)
   cParam:=ALLTRIM(cP1+" "+cP2+" "+cP3+" "+cP4+" "+cP5+" "+cP6+" "+cP7+" "+cP8+" "+cP9+" "+cP10+" "+cP11+" "+cP12+" "+cP13+" "+cP14+" "+cP15+" "+cP16+" "+cP17+" "+cP18+" "+cP19+" "+cP20)

   if ( Upper( US_Word( cParam , 1 ) ) == "-VER" .or. Upper( US_Word( cParam , 1 ) ) == "-VERSION" )
      MemoWrit( "US_Run.version" , Version )
      Return bOk
   endif

   if Upper( US_Word( cParam , 1 ) ) != "QPM"
      MsgInfo( "US_Run 999E: Running out System" )
      ERRORLEVEL(1)
      bOk := .F.
      return bOk
   else
      cParam := US_WordDel( cParam , 1 )
   endif

   if empty( cParam )
      msginfo( "US_Run 123: Missing Parameters" )
      ERRORLEVEL(1)
      bOk := .F.
      return bOk
   endif

   if !file( cParam )
      msginfo( "US_Run 124: Paramters File not Found: " + cParam )
      ERRORLEVEL(1)
      bOk := .F.
      return bOk
   else
      MemoAux := MemoRead( cParam )
      for i := 1 to MLCount( MemoAux , nLineSize )
         cLineaAux := alltrim( MemoLine( MemoAux , nLineSize , i ) )
         if Upper( US_Word( cLineaAux , 1 ) ) == "COMMAND"
            cCMD := US_WordSubStr( cLineaAux , 2 )
         endif
         if Upper( US_Word( cLineaAux , 1 ) ) == "CONTROL"
            cControlFile := US_WordSubStr( cLineaAux , 2 )
         endif
         if Upper( US_Word( cLineaAux , 1 ) ) == "DEFAULTPATH"
            cDefaultPath := US_WordSubStr( cLineaAux , 2 )
         endif
//       if Upper( US_Word( cLineaAux , 1 ) ) == "FILESTOP"
//          cFileStop := US_WordSubStr( cLineaAux , 2 )
//       endif
         if Upper( US_Word( cLineaAux , 1 ) ) == "MODE"
            cMode := US_WordSubStr( cLineaAux , 2 )
         endif
      next i
      ferase( cParam )
   endif

   DEFINE WINDOW VentanaMain ;
      AT 0,0 ;
      WIDTH GetDesktopWidth() ;
      HEIGHT GetDesktopHeight() ;
      TITLE '' ;
      MAIN ;
      ICON "DOS" ;
      NOSHOW ;
      ON INIT US_RunInit() ;
      ON RELEASE US_RunRelease()
   END WINDOW

   ACTIVATE WINDOW VentanaMain

   if !bOk
      ERRORLEVEL(1)
   endif
Return bOk

Function US_RunInit()
   Local Reto , nHandle
   DO EVENTS
// memowrit( cFileStop , "Run Wait File Stop" )
   nHandle := FOpen( cControlFile , FO_WRITE + FO_EXCLUSIVE )
   if !empty( cDefaultPath )
      cCurrentPath := GetCurrentFolder()
      SetCurrentFolder( cDefaultPath )
   endif
   DO EVENTS
   do case
      case cMode == "HIDE"
         Reto := WaitRun( cCMD , 0 )            // EXECUTE FILE ( cCMD ) WAIT HIDE
      case cMode == "MINIMIZE"
         Reto := WaitRun( cCMD , 6 )            // EXECUTE FILE ( cCMD ) WAIT MINIMIZE
      case cMode == "MAXIMIZE"
         Reto := WaitRun( cCMD , 3 )            // EXECUTE FILE ( cCMD ) WAIT MAXIMIZE
      otherwise
         Reto := WaitRun( cCMD , 5 )            // EXECUTE FILE ( cCMD ) WAIT
   endcase
   if !empty( cDefaultPath )
      SetCurrentFolder( cCurrentPath )
   endif
   DO EVENTS
// msginfo( str( reto ) )
   if Reto > 8
      msginfo( "US_Run 333: Error Running: " + cCMD + HB_OsNewLine() + ;
               "Code: "+US_TodoStr( Reto ) )
      // Code 0019798320 = File Not Found
      bOk := .F.
   endif
   fClose( nHandle )
   ferase( cControlFile )
// ferase( cFileStop )
   DO EVENTS
   VentanaMain.Release()
Return

Function US_RunRelease()
Return

Function STREAMOUT()
   msginfo( "Function " + procname() + " suspend from US_Run" )
Return
Function PASTERTF()
   msginfo( "Function " + procname() + " suspend from US_Run" )
Return
Function GETCONTROLINDEX()
   msginfo( "Function " + procname() + " suspend from US_Run" )
Return
Function VP_MGWAIT()
   msginfo( "Function " + procname() + " suspend from US_Run" )
Return
Function COPYTOCLIPBOARD()
   msginfo( "Function " + procname() + " suspend from US_Run" )
Return
Function COPYRTFTOCLIPBOARD()
   msginfo( "Function " + procname() + " suspend from US_Run" )
Return

/* eof */
