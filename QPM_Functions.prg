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

#include "minigui.ch"
#include <QPM.ch>

memvar tiempo
memvar WinMsg
memvar PrivAutoExit
memvar SM_oMGWait
memvar cMemoInP

Function Get_QPM_Builder_VersionDisplay()
   Local cVer := Get_QPM_Builder_Version()
Return "v" + substr( cVer, 1, 2 ) + "." + substr( cVer, 3, 2 ) + " Build " + substr( cVer, 5, 2 )

Procedure QPM_ForceRecompPRG()
   if GetProperty( "VentanaMain", "GPRGFiles", "value" ) > 0
      if GetProperty( "VentanaMain", "GPRGFiles", "Cell", GetProperty( "VentanaMain", "GPRGFiles", "value" ), NCOLPRGRECOMP ) == "R"
         SetProperty( "VentanaMain", "GPRGFiles", "Cell", GetProperty( "VentanaMain", "GPRGFiles", "value" ), NCOLPRGRECOMP, " " )
      else
         SetProperty( "VentanaMain", "GPRGFiles", "Cell", GetProperty( "VentanaMain", "GPRGFiles", "value" ), NCOLPRGRECOMP, "R" )
      endif
   endif
Return

/*
Function QPM_CartelCancelByBug()
   MsgInfo( "Selection canceled by user" + HB_OsNewLine() + ;   // esto es debido a un bug que se produce cuando se da escape sin seleccionar archivos: la rutina siguiente no termina
                                           HB_OsNewLine() + ;
            "Note: This msgbox fixes an Extended Minigui bug at the GetFile" + HB_OsNewLine() + ;
            "function that hangs the app if Cancel or Esc key are pressed." )
Return .T.
*/
Function BugGetFile( a, b, c, d, e, f )
   Local auxReto
// SetMGWaitHide()
   auxReto := GetFile( a, b, c, d, e, f )
// SetMGWaitShow()
/*
 *   if empty( auxReto )
 *     QPM_CartelCancelByBug()   // esto es debido a un bug que se produce cuando se da escape sin seleccionar archivos la rutina siguiente no termina
 *  endif
 */
Return auxReto

Function QPM_CreateNewFile( cType, cFile )
   Local cMemo, bReto := .F.
   Local nOption := 1
   Local aStruct
   do case
      case US_Upper( cType ) == "PRG"
         cMemo := '#include "minigui.ch"'                              + HB_OsNewLine() + ;
                  ''                                                   + HB_OsNewLine() + ;
                  'Function main()'                                    + HB_OsNewLine() + ;
                  ''                                                   + HB_OsNewLine() + ;
                  '   DEFINE WINDOW Sample ; '                         + HB_OsNewLine() + ;
                  '     AT 0, 0 ;     '                               + HB_OsNewLine() + ;
                  '     WIDTH 400 ;    '                               + HB_OsNewLine() + ;
                  '     HEIGHT 200 ;   '                               + HB_OsNewLine() + ;
                  '     TITLE "QPM Sample" ; '                         + HB_OsNewLine() + ;
                  '     MAIN'                                          + HB_OsNewLine() + ;
                  ''                                                   + HB_OsNewLine() + ;
                  '      DEFINE LABEL Label1'                          + HB_OsNewLine() + ;
                  '        ROW 40'                                     + HB_OsNewLine() + ;
                  '        COL 130'                                    + HB_OsNewLine() + ;
                  '        WIDTH 200'                                  + HB_OsNewLine() + ;
                  '        VALUE "Basic QPM Sample"'                   + HB_OsNewLine() + ;
                  '      END LABEL'                                    + HB_OsNewLine() + ;
                  ''                                                   + HB_OsNewLine() + ;
                  '      DEFINE BUTTON Button1'                        + HB_OsNewLine() + ;
                  '        ROW 100'                                    + HB_OsNewLine() + ;
                  '        COL 100'                                    + HB_OsNewLine() + ;
                  '        WIDTH 200'                                  + HB_OsNewLine() + ;
                  '        CAPTION "Exit"'                             + HB_OsNewLine() + ;
                  '        ONCLICK DoMethod( "Sample", "Release" )'   + HB_OsNewLine() + ;
                  '      END BUTTON'                                   + HB_OsNewLine() + ;
                  ''                                                   + HB_OsNewLine() + ;
                  '   END WINDOW'                                      + HB_OsNewLine() + ;
                  ''                                                   + HB_OsNewLine() + ;
                  '   CENTER WINDOW Sample'                            + HB_OsNewLine() + ;
                  '   ACTIVATE WINDOW Sample'                          + HB_OsNewLine() + ;
                  ''                                                   + HB_OsNewLine() + ;
                  'Return .T.'                                         + HB_OsNewLine()
         bReto := QPM_MemoWrit( cFile, cMemo )
      case US_Upper( cType ) == "PAN"
         SetMGWaitHide()
         DEFINE WINDOW EditPanNew ;
                AT 0, 0 ;
                WIDTH 300 ;
                HEIGHT 200 ;
                TITLE "Create New Form" ;
                MODAL ;
                NOSYSMENU ;
                ON INTERACTIVECLOSE US_NOP()

            @ 08, 35 FRAME EditPanNewF ;
               WIDTH 220 ;
               HEIGHT 90

            @ 13, 40 LABEL EditPanNewL ;
               VALUE 'Create for:' ;
               WIDTH 200 ;
               FONT 'arial' SIZE 10 BOLD ;
               FONTCOLOR DEF_COLORBLUE

            @ 40, 50 RADIOGROUP EditPanNewR ;
               OPTIONS { 'IDE+ by Ciro Vargas', 'HMGS-Ide by Walter Formigoni' } ;
               WIDTH 200 ;
               VALUE nOption ;
               TOOLTIP "Select tool"

            DEFINE BUTTON EditPanNewOK
                   ROW             115
                   COL             35
                   WIDTH           80
                   HEIGHT          25
                   CAPTION         'OK'
                   TOOLTIP         'Confirm selection'
                   ONCLICK         ( nOption := EditPanNew.EditPanNewR.value, EditPanNew.Release() )
            END BUTTON

            DEFINE BUTTON EditPanNewCANCEL
                   ROW             115
                   COL             175
                   WIDTH           80
                   HEIGHT          25
                   CAPTION         'Cancel'
                   TOOLTIP         'Cancel selection'
                   ONCLICK         ( nOption := 0, EditPanNew.Release() )
            END BUTTON

         END WINDOW
         Center Window EditPanNew
         Activate Window EditPanNew
         do case
            case nOption == 0
               bReto := .F.
            case nOption == 1
               cMemo := HB_OsNewLine() + ;
                        "* ooHG IDE Plus form generated code" + HB_OsNewLine() + ;
                        "* (c) 2003-" + LTrim( Str( Year( Date() ) ) ) + " Ciro Vargas Clemow <cvc@oohg.org>" + HB_OsNewLine() + ;
                        HB_OsNewLine() + ;
                        "DEFINE WINDOW TEMPLATE ;" + HB_OsNewLine() + ;
                        "   AT 238, 256 ;" + HB_OsNewLine() + ;
                        "   WIDTH 405 ;" + HB_OsNewLine() + ;
                        "   HEIGHT 218; " + HB_OsNewLine() + ;
                        "   TITLE 'QPM - Empty Sample Form' ;" + HB_OsNewLine() + ;
                        "   FONT 'MS Sans Serif' ; " + HB_OsNewLine() + ;
                        "   SIZE 10" + HB_OsNewLine() + ;
                        "   FONTCOLOR {0, 0, 0}" + HB_OsNewLine() + ;
                        HB_OsNewLine() + ;
                        "END WINDOW" + HB_OsNewLine()
               bReto := QPM_MemoWrit( cFile, cMemo )
            case nOption == 2
               cMemo := "*HMGS-MINIGUI-IDE Two-Way Form Designer Generated Code" + HB_OsNewLine() + ;
                         "*OPEN SOURCE PROJECT 2005-" + alltrim(str(year(date()))) + " Walter Formigoni http://sourceforge.net/projects/hmgs-minigui/" + HB_OsNewLine() + ;
                         'DEFINE WINDOW TEMPLATE AT 140, 235 WIDTH 324 HEIGHT 257 TITLE "QPM - HMGSIde - Empty Sample Form" MODAL' + HB_OsNewLine() + ;
                         "END WINDOW"
               bReto := QPM_MemoWrit( cFile, cMemo )
            Otherwise
               MsgInfo( "Error: Invalid option in Create PanNew." )
               bReto := .F.
         EndCase
         SetMGWaitShow()
      case US_Upper( cType ) == "DBF"
         SetMGWaitHide()
         aStruct := { { "COD", "N",  5, 0 }, ;
                      { "MEMO", "M", 10, 0 } }
         DEFINE WINDOW CreateDbfNew ;
                AT 0, 0 ;
                WIDTH 300 ;
                HEIGHT 200 ;
                TITLE "Create New DBF" ;
                MODAL ;
                NOSYSMENU ;
                ON INTERACTIVECLOSE US_NOP()

            @ 08, 35 FRAME CreateDbfNewF ;
               WIDTH 220 ;
               HEIGHT 90

            @ 13, 40 LABEL CreateDbfNewL ;
               VALUE 'Create for:' ;
               WIDTH 200 ;
               FONT 'arial' SIZE 10 BOLD ;
               FONTCOLOR DEF_COLORBLUE

            @ 40, 50 RADIOGROUP CreateDbfNewR ;
               OPTIONS { 'DBF/CDX Driver (Memo FPT)', 'DBF/NTX Diver (Memo DBT)' } ;
               WIDTH 200 ;
               VALUE nOption ;
               TOOLTIP "Select Driver"

            DEFINE BUTTON CreateDbfNewOK
                   ROW             115
                   COL             35
                   WIDTH           80
                   HEIGHT          25
                   CAPTION         'OK'
                   TOOLTIP         'Confirm selection'
                   ONCLICK         ( nOption := CreateDbfNew.CreateDbfNewR.value, CreateDbfNew.Release() )
            END BUTTON

            DEFINE BUTTON CreateDbfNewCANCEL
                   ROW             115
                   COL             175
                   WIDTH           80
                   HEIGHT          25
                   CAPTION         'Cancel'
                   TOOLTIP         'Cancel selection'
                   ONCLICK         ( nOption := 0, CreateDbfNew.Release() )
            END BUTTON

         END WINDOW
         Center Window CreateDbfNew
         Activate Window CreateDbfNew
         do case
            case nOption == 0
               bReto := .F.
            case nOption == 1
               DBCreate( cFile, aStruct, "DBFCDX" )
               if file( cFile )
                  bReto := .T.
               else
                  bReto := .F.
               endif
            case nOption == 2
               DBCreate( cFile, aStruct, "DBFNTX" )
               if file( cFile )
                  bReto := .T.
               else
                  bReto := .F.
               endif
            Otherwise
               MsgInfo( "Error: Invalid option in Create DbfNew." )
               bReto := .F.
         EndCase
         SetMGWaitShow()
      Otherwise
         QPM_MemoWrit( cFile, "" )
   endcase
Return bReto

Function QPM_DirValid( cDir, cDirLib, cTipo )
   Local bReto := .F.
   if US_IsDirectory( cDir )
      do case
      // HMG 1.x
      case cTipo == DefineMiniGui1 + DefineBorland
         if File( cDir + DEF_SLASH + "INCLUDE" + DEF_SLASH + "minigui.ch" ) .and. ;
            ! File( cDir + DEF_SLASH + "INCLUDE" + DEF_SLASH + "oohg.ch" ) .and. ;
            ! US_IsDirectory( cDir + DEF_SLASH + "SOURCE" + DEF_SLASH + "TsBrowse" ) .and. ;
            File( cDirLib + DEF_SLASH + 'minigui.lib' )
            bReto := .T.
         endif
      case cTipo == "C_" + DefineMiniGui1 + DefineBorland
         if File( cDir + DEF_SLASH + "BIN" + DEF_SLASH + "BCC32.EXE" )
            bReto:=.T.
         endif
      // HMG 3.x
      case cTipo == DefineMiniGui3 + DefineMinGW
         if File( cDir + DEF_SLASH + "INCLUDE" + DEF_SLASH + "minigui.ch" ) .and. ;
            ! File( cDir + DEF_SLASH + "INCLUDE" + DEF_SLASH + "tsbrowse.ch" ) .and. ;
            ! File( cDir + DEF_SLASH + "INCLUDE" + DEF_SLASH + "oohg.h" )  .and. ;
            File( cDirLib + DEF_SLASH + 'libhmg.a' )
            bReto := .T.
         endif
      case cTipo == "C_" + DefineMiniGui3 + DefineMinGW
         if File( cDir + DEF_SLASH + "BIN" + DEF_SLASH + "GCC.EXE" )
            bReto:=.T.
         endif
      // Extended
      case cTipo == DefineExtended1 + DefineBorland
         if File( cDir + DEF_SLASH + "INCLUDE" + DEF_SLASH + "minigui.ch" ) .and. ;
            File( cDir + DEF_SLASH + "INCLUDE" + DEF_SLASH + "tsbrowse.ch" ) .and. ;
            ! File( cDir + DEF_SLASH + "INCLUDE" + DEF_SLASH + "oohg.ch" ) .and. ;
            File( cDirLib + DEF_SLASH + 'minigui.lib' )
            bReto:=.T.
         endif
      case cTipo == "C_" + DefineExtended1 + DefineBorland
         if File( cDir + DEF_SLASH + "BIN" + DEF_SLASH + "BCC32.EXE" )
            bReto:=.T.
         endif
      case cTipo == DefineExtended1 + DefineMinGW
         if File( cDir + DEF_SLASH + "INCLUDE" + DEF_SLASH + "minigui.ch" ) .and. ;
            File( cDir + DEF_SLASH + "INCLUDE" + DEF_SLASH + "tsbrowse.ch" ) .and. ;
            ! File( cDir + DEF_SLASH + "INCLUDE" + DEF_SLASH + "oohg.ch" )  .and. ;
            File( cDirLib + DEF_SLASH + 'libminigui.a' )
            bReto:=.T.
         endif
      case cTipo == "C_" + DefineExtended1 + DefineMinGW
         if File( cDir + DEF_SLASH + "BIN" + DEF_SLASH + "GCC.EXE" )
            bReto:=.T.
         endif
      // OOHG
      case cTipo == DefineOohg3 + DefineBorland
         if File( cDir + DEF_SLASH + "INCLUDE" + DEF_SLASH + "oohg.ch" ) .and. ;
            File( cDirLib + DEF_SLASH + 'oohg.lib' )
            bReto:=.T.
         endif
      case cTipo == "C_" + DefineOohg3 + DefineBorland
         if File( cDir + DEF_SLASH + "BIN" + DEF_SLASH + "BCC32.EXE" )
            bReto:=.T.
         endif
      case cTipo == DefineOohg3 + DefineMinGW
         if File( cDir + DEF_SLASH + "INCLUDE" + DEF_SLASH + "oohg.ch" ) .and. ;
            File( cDirLib + DEF_SLASH + "liboohg.a" )
            bReto:=.T.
         endif
      case cTipo == "C_" + DefineOohg3 + DefineMinGW
         if File( cDir + DEF_SLASH + "BIN" + DEF_SLASH + "GCC.EXE" )
            bReto:=.T.
         endif
      case cTipo == DefineOohg3 + DefinePelles
         if File( cDir + DEF_SLASH + "INCLUDE" + DEF_SLASH + "oohg.ch" ) .and. ;
            File( cDirLib + DEF_SLASH + 'oohg.lib' )
            bReto:=.T.
         endif
      case cTipo == "C_" + DefineOohg3 + DefinePelles
         if File( cDir + DEF_SLASH + "BIN" + DEF_SLASH + "POCC.EXE" )
            bReto:=.T.
         endif
      otherwise
         cTipo := Left( cTipo, Len( cTipo ) - 3 )
         do case
         // HMG 1.x
         case cTipo == DefineMiniGui1 + DefineBorland + DefineHarbour
            if File( cDir + DEF_SLASH + "BIN" + DEF_SLASH + "HARBOUR.EXE" ) .and. ;
               ( File( cDirLib + DEF_SLASH + "rtl.lib" ) .or. ;
                 File( cDirLib + DEF_SLASH + "hbrtl.lib" ) )
               bReto:=.T.
            endif
         case cTipo == DefineMiniGui1 + DefineBorland + DefineXHarbour
            if File( cDir + DEF_SLASH + "BIN" + DEF_SLASH + "HARBOUR.EXE" ) .and. ;
               File( cDirLib + DEF_SLASH + "rtl.lib" )
               bReto:=.T.
            endif
         // HMG 3.x
         case cTipo == DefineMiniGui3 + DefineMinGW + DefineHarbour
            if File( cDir + DEF_SLASH + "BIN" + DEF_SLASH + "HARBOUR.EXE" ) .and. ;
               ( File( cDirLib + DEF_SLASH + "librtl.a" ) .or. ;
                 File( cDirLib + DEF_SLASH + "libhbrtl.a" ) .or. ;
                 File( cDirLib + DEF_SLASH + "WIN" + DEF_SLASH + "MINGW" + DEF_SLASH + "librtl.a" ) .or. ;
                 File( cDirLib + DEF_SLASH + "WIN" + DEF_SLASH + "MINGW" + DEF_SLASH + "libhbrtl.a" ) )
               bReto:=.T.
            endif
         case cTipo == DefineMiniGui3 + DefineMinGW + DefineXHarbour
            if File( cDir + DEF_SLASH + "BIN" + DEF_SLASH + "HARBOUR.EXE" ) .and. ;
               File( cDirLib + DEF_SLASH + "librtl.a" ) .and. ;
               File( cDirLib + DEF_SLASH + "libtip.a" )
               bReto:=.T.
            endif
         // Extended
         case cTipo == DefineExtended1 + DefineBorland + DefineHarbour
            if File( cDir + DEF_SLASH + "BIN" + DEF_SLASH + "HARBOUR.EXE" ) .and. ;
               ( File( cDirLib + DEF_SLASH + "rtl.lib" ) .or. ;
                 File( cDirLib + DEF_SLASH + "hbrtl.lib" ) )
               bReto:=.T.
            endif
         case cTipo == DefineExtended1 + DefineBorland + DefineXHarbour
            if File( cDir + DEF_SLASH + "BIN" + DEF_SLASH + "HARBOUR.EXE" ) .and. ;
               File( cDirLib + DEF_SLASH + "rtl.lib" ) .and. ;
               File( cDirLib + DEF_SLASH + "tip.lib" )
               bReto:=.T.
            endif
         case cTipo == DefineExtended1 + DefineMinGW + DefineHarbour
            if File( cDir + DEF_SLASH + "BIN" + DEF_SLASH + "HARBOUR.EXE" ) .and. ;
               ( File( cDirLib + DEF_SLASH + "librtl.a" ) .or. ;
                 File( cDirLib + DEF_SLASH + "libhbrtl.a" ) .or. ;
                 File( cDirLib + DEF_SLASH + "WIN" + DEF_SLASH + "MINGW" + DEF_SLASH + "librtl.a" ) .or. ;
                 File( cDirLib + DEF_SLASH + "WIN" + DEF_SLASH + "MINGW" + DEF_SLASH + "libhbrtl.a" ) )
               bReto:=.T.
            endif
         case cTipo == DefineExtended1 + DefineMinGW + DefineXHarbour
            if File( cDir + DEF_SLASH + "BIN" + DEF_SLASH + "HARBOUR.EXE" ) .and. ;
               File( cDirLib + DEF_SLASH + "librtl.a" ) .and. ;
               File( cDirLib + DEF_SLASH + "libtip.a" )
               bReto:=.T.
            endif
         // OOHG
         case cTipo == DefineOohg3 + DefineBorland + DefineHarbour
            if File( cDir + DEF_SLASH + "BIN" + DEF_SLASH + "HARBOUR.EXE" ) .and. ;
               ( File( cDirLib + DEF_SLASH + "rtl.lib" ) .or. ;
                 File( cDirLib + DEF_SLASH + "hbrtl.lib" ) )
               bReto:=.T.
            endif
         case cTipo == DefineOohg3 + DefineBorland + DefineXHarbour
            if File( cDir + DEF_SLASH + "BIN" + DEF_SLASH + "HARBOUR.EXE" ) .and. ;
               File( cDirLib + DEF_SLASH + "rtl.lib" ) .and. ;
               File( cDirLib + DEF_SLASH + "tip.lib" )
               bReto:=.T.
            endif
         case cTipo == DefineOohg3 + DefineMinGW + DefineHarbour
            if File( cDir + DEF_SLASH + "BIN" + DEF_SLASH + "HARBOUR.EXE" ) .and. ;
               ( File( cDirLib + DEF_SLASH + "librtl.a" ) .or. ;
              File( cDirLib + DEF_SLASH + "libhbrtl.a" ) .or. ;
                 File( cDirLib + DEF_SLASH + "WIN" + DEF_SLASH + "MINGW" + DEF_SLASH + "librtl.a" ) .or. ;
                 File( cDirLib + DEF_SLASH + "WIN" + DEF_SLASH + "MINGW" + DEF_SLASH + "libhbrtl.a" ) )
               bReto:=.T.
            endif
         case cTipo == DefineOohg3 + DefineMinGW + DefineXHarbour
            if File( cDir + DEF_SLASH + "BIN" + DEF_SLASH + "HARBOUR.EXE" ) .and. ;
               File( cDirLib + DEF_SLASH + "librtl.a" ) .and. ;
               File( cDirLib + DEF_SLASH + "libtip.a" )
               bReto:=.T.
            endif
         case cTipo == DefineOohg3 + DefinePelles + DefineHarbour
            if File( cDir + DEF_SLASH + "BIN" + DEF_SLASH + "HARBOUR.EXE" ) .and. ;
               ( File( cDirLib + DEF_SLASH + "rtl.lib" ) .or. ;
                 File( cDirLib + DEF_SLASH + "hbrtl.lib" ) )
               bReto:=.T.
            endif
         case cTipo == DefineOohg3 + DefinePelles + DefineXHarbour
            if File( cDir + DEF_SLASH + "BIN" + DEF_SLASH + "HARBOUR.EXE" ) .and. ;
               File( cDirLib + DEF_SLASH + "rtl.lib" ) .and. ;
               File( cDirLib + DEF_SLASH + "tip.lib" )
               bReto:=.T.
            endif
         otherwise
            US_Log( "QPM1234E: Tipo de Directorio invalido: " + cTipo )
         endcase
      endcase
   endif
Return bReto

Function CambioTitulo()
   if PUB_bLite
      if _IsWindowDefined( "VentanaLite" )
         SetProperty( "VentanaLite", "Title", 'QPM (' + QPM_VERSION_DISPLAY_LONG + ') [ ' + alltrim( PUB_cProjectFile ) + ' ]' )
      endif
      if _IsWindowDefined( "WinHotRecovery" )
         SetProperty( "WinHotRecovery", "title", 'Hot Recovery for QPM Projects [ ' + alltrim( PUB_cProjectFile ) + ' ]' )
      endif
   else
      if _IsWindowDefined( "VentanaLite" )
         SetProperty( "VentanaMain", "Title", 'QPM (QAC based Project Manager) - Project Manager for MiniGui (' + QPM_VERSION_DISPLAY_LONG + ') [ ' + alltrim( PUB_cProjectFile ) + ' ]' )
      endif
      if _IsWindowDefined( "WinHotRecovery" )
         SetProperty( "WinHotRecovery", "title", 'QPM (QAC based Project Manager) - Hot Recovery for QPM Projects [ ' + alltrim( PUB_cProjectFile ) + ' ]' )
      endif
   endif
Return .T.

Function QPM_MemoWrit( p1, p2, bMute )
   if bMute == NIL
      bMute := .F.
   endif
   if ! HB_MemoWrit( p1, p2 )
      if !bMute
         US_Log( "Error in write file to: " + p1 + HB_OsNewLine() + "Requered from: " + US_StackList() )
      endif
      Return .F.
   endif
Return .T.

Function OutputExt()
   Local cRet
   do case
   case Prj_Radio_OutputType == DEF_RG_EXE
      cRet := 'EXE'
   case Prj_Radio_OutputType == DEF_RG_LIB
      if Prj_Radio_Cpp == DEF_RG_MINGW
         cRet := "A"
      else
         cRet := "LIB"
      endif
   case Prj_Radio_OutputType == DEF_RG_IMPORT
      if Prj_Radio_Cpp == DEF_RG_MINGW
         cRet := "A"
      else
         cRet := "LIB"
      endif
   otherwise
      cRet := ''
   endcase
Return cRet

Function GetObjExt()
   if Prj_Radio_Cpp == DEF_RG_MINGW
      Return "O"
   endif
Return "OBJ"

Function GetObjFolder()
Return PUB_cProjectFolder + DEF_SLASH + GetObjName()

Function GetObjName()
Return GetObjPrefix() + GetSuffix()

Function GetObjPrefix()
Return "OBJ"

Function GetSuffix()
Return GetMiniGuiSuffix() + GetCppSuffix() + GetHarbourSuffix() + GetBitsSuffix()

Function GetMiniGuiSuffix()
   Local minver
   if Prj_Radio_MiniGui == DEF_RG_MINIGUI1
      minver := DefineMiniGui1
   elseif Prj_Radio_MiniGui == DEF_RG_MINIGUI3
      minver := DefineMiniGui3
   elseif Prj_Radio_MiniGui == DEF_RG_EXTENDED1
      minver := DefineExtended1
   elseif Prj_Radio_MiniGui == DEF_RG_OOHG3
      minver := DefineOohg3
   endif
Return minver

Function GetCppSuffix()
   Local CompCVer
   if Prj_Radio_Cpp == DEF_RG_PELLES
      CompCVer := DefinePelles
   elseif Prj_Radio_Cpp == DEF_RG_MINGW
      CompCVer := DefineMinGW
   else
      CompCVer := DefineBorland
   endif
Return CompCVer

Function GetHarbourSuffix()
   Local hbver
   if Prj_Radio_Harbour == DEF_RG_HARBOUR
      hbver := DefineHarbour
   elseif Prj_Radio_Harbour == DEF_RG_XHARBOUR
      hbver := DefineXHarbour
   endif
Return hbver

Function GetBitsSuffix()
Return if( Prj_Check_64bits, Define64bits, Define32bits )

Function QPM_IsXHarbour()
Return ( Prj_Radio_Harbour == DEF_RG_XHARBOUR )

Function GetMiniGuiFolder()
Return &( "Gbl_T_M_" + GetSuffix() )

Function GetCppFolder()
Return &( "Gbl_T_C_" + GetSuffix() )

Function GetHarbourFolder()
Return &( "Gbl_T_P_" + GetSuffix() )

Function GetMiniguiLibFolder( lLong )
   Local cDir := &( "Gbl_T_M_LIBS_" + GetSuffix() )
   DEFAULT lLong TO .F.
   if ! lLong
     cDir := US_ShortName( cDir )
   endif
   if empty( cDir )
      if lLong
        cDir := GetMiniGuiFolder() + DEF_SLASH + 'LIB'
      else
        cDir := US_ShortName( GetMiniGuiFolder() ) + DEF_SLASH + 'LIB'
      endif
   endif
Return cDir

Function GetCppLibFolder( lLong )
   Local cDir := &( "Gbl_T_C_LIBS_" + GetSuffix() )
   DEFAULT lLong TO .F.
   if ! lLong
     cDir := US_ShortName( cDir )
   endif
   if empty( cDir )
      if lLong
        cDir := GetCppFolder() + DEF_SLASH + 'LIB'
      else
        cDir := US_ShortName( GetCppFolder() ) + DEF_SLASH + 'LIB'
      endif
   endif
Return cDir

Function GetHarbourLibFolder( lLong )
   Local cDir := &( "Gbl_T_P_LIBS_" + GetSuffix() )
   DEFAULT lLong TO .F.
   if ! lLong
     cDir := US_ShortName( cDir )
   endif
   if empty( cDir )
      if lLong
        cDir := GetHarbourFolder() + DEF_SLASH + 'LIB'
      else
        cDir := US_ShortName( GetHarbourFolder() ) + DEF_SLASH + 'LIB'
      endif
   endif
Return cDir

Function GetMiniGuiType()
Return Substr( GetMiniGuiSuffix(), 1, 1 )

Function GetResourceFileName()
   Local cNombre
   do case
   case GetMiniGuiSuffix() == DefineOohg3
      if QPM_IsXHarbour() .and. File( GetMiniGuiFolder() + DEF_SLASH + 'RESOURCES' + DEF_SLASH + "xoohg.rc" )
         cNombre := "xoohg"
      else
         cNombre := "oohg"
      endif
   case ( GetMiniGuiSuffix() + GetCppSuffix() ) == DefineMiniGui3 + DefineMinGW
      if QPM_IsXHarbour() .and. File( GetMiniGuiFolder() + DEF_SLASH + 'RESOURCES' + DEF_SLASH + "xhmg.rc" )
         cNombre := "xhmg"
      else
         cNombre := "hmg"
      endif
      cNombre += if( Prj_Check_64bits, "64", "32" )
   case ( GetMiniGuiSuffix() + GetCppSuffix() ) == DefineExtended1 + DefineMinGW
      if QPM_IsXHarbour() .and. File( GetMiniGuiFolder() + DEF_SLASH + 'RESOURCES' + DEF_SLASH + "xhmg.rc" )
         cNombre := "xhmg"
      elseif QPM_IsXHarbour() .and. File( GetMiniGuiFolder() + DEF_SLASH + 'RESOURCES' + DEF_SLASH + "xminigui.rc" )
         cNombre := "xminigui"
      elseif File( GetMiniGuiFolder() + DEF_SLASH + 'RESOURCES' + DEF_SLASH + "hmg.rc" )
         cNombre := "hmg"
      else
         cNombre := "minigui"
      endif
   otherwise
      if QPM_IsXHarbour() .and. File( GetMiniGuiFolder() + DEF_SLASH + 'RESOURCES' + DEF_SLASH + "xminigui.rc" )
         cNombre := "xminigui"
      else
         cNombre := "minigui"
      endif
   endcase
Return cNombre

Function GetResConfigFileName()
   Local cType, cNombre
   cType := GetMiniGuiSuffix()       // + GetCppSuffix()
   do case
   case cType == DefineOohg3         // + DefineMinGW
      cNombre := "_oohg_resconfig.h"
   case cType == DefineExtended1     // + DefineMinGW
      cNombre := "_hmg_resconfig.h"
   case cType == DefineMiniGui3      // + DefineMinGW
      cNombre := "_hmg_resconfig.h"
   otherwise
      cNombre := "_resconfig.h"
   endcase
Return cNombre

Function GetResConfigVarName()
   Local cType, cNombre
   cType := GetMiniGuiSuffix() + GetCppSuffix()
   do case
   case cType == DefineOohg3 + DefineMinGW
      cNombre := "oohgpath"
   case cType == DefineExtended1 + DefineMinGW
      cNombre := "HMGRPATH"
   case cType == DefineMiniGui3 + DefineMinGW
      cNombre := "HMGRPATH"
   otherwise
      cNombre := ""
   endcase
Return cNombre

Function GetMiniGuiName( cForceCompiler )
   Local cNombre, sufijo := GetMiniGuiSuffix() + GetCppSuffix()
   do case
   case sufijo == DefineOohg3 + DefineBorland
      if empty( cForceCompiler )
         if QPM_IsXHarbour()
            if File( GetMiniguiLibFolder() + DEF_SLASH + "xoohg.lib" )
               cNombre := "xoohg.lib"
            else
               cNombre := "oohg.lib"
            endif
         else
            cNombre := "oohg.lib"
         endif
      elseif cForceCompiler == DefineHarbour
         cNombre := "oohg.lib"
      else
         cNombre := "xoohg.lib"
      endif
   case sufijo == DefineOohg3 + DefineMinGW
      if empty( cForceCompiler )
         if QPM_IsXHarbour()
            if File( GetMiniguiLibFolder() + DEF_SLASH + "libxoohg.a" )
               cNombre := "libxoohg.a"
            else
               cNombre := "liboohg.a"
            endif
         else
            cNombre := "liboohg.a"
         endif
      elseif cForceCompiler == DefineHarbour
         cNombre := "liboohg.a"
      else
         cNombre := "libxoohg.a"
      endif
   case sufijo == DefineOohg3 + DefinePelles
      if empty( cForceCompiler )
         if QPM_IsXHarbour()
            if file( GetMiniguiLibFolder() + DEF_SLASH + "xoohg.lib" )
               cNombre := "xoohg.lib"
            else
               cNombre := "oohg.lib"
            endif
         else
            cNombre := "oohg.lib"
         endif
      elseif cForceCompiler == DefineHarbour
         cNombre := "oohg.lib"
      else
         cNombre := "xoohg.lib"
      endif
   case sufijo == DefineMiniGui3 + DefineMinGW
      if empty( cForceCompiler )
         if QPM_IsXHarbour()
            if File( GetMiniguiLibFolder() + DEF_SLASH + "libxhmg.a" )
               cNombre := "libxhmg.a"
            else
               cNombre := "libhmg.a"
            endif
         else
            cNombre := "libhmg.a"
         endif
      elseif cForceCompiler == DefineHarbour
         cNombre := "libhmg.a"
      else
         cNombre := "libxhmg.a"
      endif
   case sufijo == DefineExtended1 + DefineMinGW
      if empty( cForceCompiler )
         if QPM_IsXHarbour()
            if File( GetMiniguiLibFolder() + DEF_SLASH + "libxminigui.a" )
               cNombre := "libxminigui.a"
            else
               cNombre := "libminigui.a"
            endif
         else
            cNombre := "libminigui.a"
         endif
      elseif cForceCompiler == DefineHarbour
         cNombre := "libminigui.a"
      else
         cNombre := "libxminigui.a"
      endif
   otherwise            // DefineMiniGui1 + DefineBorland or DefineExtended1 + DefineBorland
      if empty( cForceCompiler )
         if QPM_IsXHarbour()
            if file( GetMiniguiLibFolder() + DEF_SLASH + "xminigui.lib" )
               cNombre := "xminigui.lib"
            else
               cNombre := "minigui.lib"
            endif
         else
            cNombre := "minigui.lib"
         endif
      elseif cForceCompiler == DefineHarbour
         cNombre := "minigui.lib"
      else
         cNombre := "xminigui.lib"
      endif
   endcase
Return cNombre

Function ChgPathToReal( cLinea )
   cLinea := US_StrTran( cLinea, "<NewLine>",       HB_OsNewLine() )
   cLinea := US_StrTran( cLinea, "<QPM>",           PUB_cQPM_Folder + DEF_SLASH + "QPM.EXE" )
   cLinea := US_StrTran( cLinea, "<QPMFolder>",     PUB_cQPM_Folder )
   cLinea := US_StrTran( cLinea, "<ProjectFolder>", PUB_cProjectFolder )
   cLinea := US_StrTran( cLinea, "<ThisFolder>",    PUB_cThisFolder )
Return cLinea

Function ChgPathToRelative( cLinea )
   cLinea := US_StrTran( cLinea, HB_OsNewLine(),                          "<NewLine>" )
   cLinea := US_StrTran( cLinea, PUB_cQPM_Folder + DEF_SLASH + "QPM.EXE", "<QPM>" )
   cLinea := US_StrTran( cLinea, PUB_cQPM_Folder,                         "<QPMFolder>" )
   cLinea := US_StrTran( cLinea, PUB_cProjectFolder,                      "<ProjectFolder>" )
   cLinea := US_StrTran( cLinea, PUB_cThisFolder,                         "<ThisFolder>" )
Return cLinea

Function MsgOK( titulo, txt, tipo, autoexit, Ptiempo, bButtonRun )
   Local ColorBack, ColorFont
   Private tiempo, WinMsg := US_WindowNameRandom("MsgOk")
   Private PrivAutoExit
   DEFAULT Ptiempo TO 0
   DEFAULT bButtonRun TO .F.
   tiempo := Ptiempo
   if empty( titulo )
      titulo := 'QPM (QAC based Project Manager)'
   endif
   if empty( autoexit )
      autoexit := .F.
   endif
   PrivAutoExit := autoexit
   do case
      case US_Upper( tipo ) == "E"
         ColorBack := DEF_COLORRED
         ColorFont := DEF_COLORWHITE
         if tiempo == 0
            tiempo := 10
         endif
      case US_Upper( tipo ) == "W"
         ColorBack := DEF_COLORYELLOW
         ColorFont := DEF_COLORBLACK
         if tiempo == 0
            tiempo := 5
         endif
      otherwise
         ColorBack := DEF_COLORGREEN
         ColorFont := DEF_COLORWHITE
         if tiempo == 0
            tiempo := 2
         endif
   endcase

   if US_IsWindowModalActive()
      DEFINE WINDOW &(WinMsg) ;
              AT 0,0 ;
              WIDTH if( bButtonRun, 295, 170 ) HEIGHT 125 ;
              TITLE titulo ;
              MODAL ;
              NOSYSMENU ;
              NOCAPTION ;
              BACKCOLOR ColorBack ;
              FONT 'Arial' SIZE 9
      END WINDOW
   else
      DEFINE WINDOW &(WinMsg) ;
              AT 0,0 ;
              WIDTH if( bButtonRun, 295, 170 ) HEIGHT 125 ;
              TITLE titulo ;
              CHILD ;
              TOPMOST ;
              NOSYSMENU ;
              NOCAPTION ;
              BACKCOLOR ColorBack ;
              FONT 'Arial' SIZE 9
      END WINDOW
   endif

   @ 0, 0 LABEL LQPM ;
      OF &(WinMsg) ;
      VALUE "QPM" ;
      WIDTH GetProperty( WinMsg, "Width" ) - GetBorderWidth() ;
      HEIGHT 23 ;
      FONT  'Arial' SIZE 12 BOLD ;
      FONTCOLOR ColorBack ;
      BACKCOLOR ColorFont ;
      CENTERALIGN ;
      ACTION InterActiveMoveHandle( GetFormHandle( WinMsg ) )

   @ 32, 0 LABEL LText ;
      OF &(WinMsg) ;
      VALUE txt ;
      WIDTH GetProperty( WinMsg, "Width" ) - GetBorderWidth() ;
      HEIGHT 45 ;
      FONT  'Arial' SIZE 10 BOLD ;
      FONTCOLOR ColorFont ;
      TRANSPARENT ;
      CENTERALIGN ;
      ACTION InterActiveMoveHandle( GetFormHandle( WinMsg ) )

   DEFINE BUTTON bOK
      PARENT          &(WinMsg)
      ROW             75
      COL             35
      WIDTH           100
      HEIGHT          25
      CAPTION         if( PrivAutoExit, 'Ok (' + alltrim( str( tiempo ) ) + ')', 'Ok' )
      ONCLICK         MsgOk_Salir()
   END BUTTON

   if bButtonRun
      DEFINE BUTTON bRUN
         PARENT          &(WinMsg)
         ROW             75
         COL             160
         WIDTH           100
         HEIGHT          25
         CAPTION         'Run'
         ONCLICK         ( PUB_bForceRunFromMsgOk := .T., MsgOk_Salir() )
      END BUTTON
   endif

   if PrivAutoExit
      DEFINE TIMER Timer_Msg ;
             OF &(WinMsg) ;
             INTERVAL 1000 ;
             ACTION MsgOk_Contador()
   endif

   if bButtonRun
      DoMethod( WinMsg, "bRUN", "SetFocus" )
   else
      DoMethod( WinMsg, "bOK", "SetFocus" )
   endif

   CENTER WINDOW &WinMsg
   ACTIVATE WINDOW &WinMsg
Return .T.

Function MsgOk_Contador()
   tiempo--
   if tiempo < 1
      if _IsWindowActive( WinMsg )
         DoMethod( WinMsg, "Release" )
      endif
      Return .T.
   else
      if _IsWindowActive( WinMsg )
         SetProperty( WinMsg, "bOK", "caption", "Ok (" + alltrim( str( tiempo ) ) + ")" )
      else
         Return .T.
      endif
   endif
Return .F.

Function MsgOk_Salir()
   if PrivAutoExit
      if _IsWindowActive( WinMsg )
         SetProperty( WinMsg, "bOK", "enabled", .F. )
      endif
      tiempo := 1
   else
      DoMethod( WinMsg, "Release" )
   endif
Return .T.

Function MyMsg( titulo, texto, tipo, autoexit )
   if bAutoExit .and. !empty( PUB_cAutoLog )
      PUB_cAutoLogTmp := MemoRead( PUB_cAutoLog )
      QPM_MemoWrit( PUB_cAutoLog, PUB_cAutoLogTmp + HB_OsNewLine() + ;
                texto + HB_OsNewLine() + ;
                "" )
      msgok( titulo, "Info saved" + HB_OsNewLine() + "Check into LOG", tipo, autoexit )
   else
      SetMGWaitHide()
      Do case
         case us_upper( tipo ) == "W"
            MsgExclamation( texto, titulo, nil, .F. )    // this is not translated
         case us_upper( tipo ) == "E"
            MsgStop( texto, titulo, nil, .F. )           // this is not translated
         otherwise
            MsgInfo( texto, titulo, nil, .F. )           // this is not translated
      endcase
      SetMGWaitShow()
   endif
Return .T.

Function QPM_ModuleType( cFile )
   Local MemoAux, u0, u1, u2
   Local cAux1 := "Bor"
   Local cBorland := cAux1 + "land C++ - Copyright 1999 Inprise Corporation"
   Local cAux2 := "Min"
   Local cMinGW   := cAux2 + "GW GNU C"
   Local cAux3 := "___m"
   Local cMinGW2  := cAux3 + "ingw_CRTStartup"
   Local cAux4 := "Pel"
   Local cPelles  := cAux4 + "les ISO C Compiler"
   Local cAux5 := "UP"
   if !file( cFile )
      Return "NONE"
   endif
   MemoAux := memoread( cFile )
   if Upper( US_FileNameOnlyExt( cFile ) ) == "EXE" .and. ;
      ( u0 := at( cAux5 + "X0", MemoAux ) ) > 0 .and. ;
      ( u1 := at( cAux5 + "X1", MemoAux ) ) > 0 .and. ;
      ( u2 := at( cAux5 + "X!", MemoAux ) ) > 0 .and. ;
      u0 < u1 .and. u1 < u2
      Return "COMPRESSED"
   endif
   if Upper( US_FileNameOnlyExt( cFile ) ) == "EXE" .and. ;
      at( cBorland, MemoAux ) > 0 .and. ;
      at( cMinGW  , MemoAux ) = 0 .and. ;
      at( cMinGW2 , MemoAux ) = 0 .and. ;
      at( cPelles , MemoAux ) = 0
      Return "BORLAND"
   endif
   if Upper( US_FileNameOnlyExt( cFile ) ) == "EXE" .and. ;
      at( cBorland, MemoAux ) = 0 .and. ;
      at( cMinGW  , MemoAux ) > 0 .and. ;
      at( cMinGW2 , MemoAux ) > 0 .and. ;
      at( cPelles , MemoAux ) = 0
      Return "MINGW"
   endif
   if Upper( US_FileNameOnlyExt( cFile ) ) == "EXE" .and. ;
      at( cBorland, MemoAux ) = 0 .and. ;
      at( cMinGW  , MemoAux ) = 0 .and. ;
      at( cMinGW2 , MemoAux ) = 0 .and. ;
      at( cPelles , MemoAux ) > 0
      Return "PELLES"
   endif
   if Upper( US_FileNameOnlyExt( cFile ) ) == "LIB" .and. ;
      at( "<arch>", MemoAux ) == 2
      Return "PELLES"
   endif
   if Upper( US_FileNameOnlyExt( cFile ) ) == "LIB" .and. ;
      at( "Borland C++ 5.5.", MemoAux ) > 0
      Return "BORLAND"
   endif
   if Upper( US_FileNameOnlyExt( cFile ) ) == "LIB" .and. ;
      at( CHR( 240 ), MemoAux ) == 1
      Return "BORLAND"
   endif
   if Upper( US_FileNameOnlyExt( cFile ) ) == "A" .and. ;
      at( "<arch>", MemoAux ) == 2
      Return "MINGW"
   endif
   if Upper( US_FileNameOnlyExt( cFile ) ) == "OBJ" .and. ;
      at( "L", MemoAux ) == 1 .and. ;
      at( "CRT$XIC", MemoAux ) > 0
      Return "PELLES"
   endif
   if Upper( US_FileNameOnlyExt( cFile ) ) == "OBJ" .and. ;
      at( "Borland C++ 5.5.", MemoAux ) > 0
      Return "BORLAND"
   endif
   if Upper( US_FileNameOnlyExt( cFile ) ) == "O"
      Return "MINGW"
   endif
Return "UNKNOWN"

Function GetOutputModuleName( bForDisplay )
   Local cOutputName
   Local cOutputNameDisplay
   if empty( bForDisplay )
      bForDisplay := .F.
   endif
   do case
      case Prj_Radio_OutputRename = DEF_RG_NEWNAME
         if empty( US_FileNameOnlyExt( Prj_Text_OutputRenameNewName ) )
            if OutputExt() == "A" .and. Prj_Check_OutputPrefix
               cOutputName        := US_ShortName(PUB_cProjectFolder) + DEF_SLASH + 'lib' + US_FileNameOnlyName( Prj_Text_OutputRenameNewName ) + '.' + lower( OutputExt() )
               cOutputNameDisplay := PUB_cProjectFolder + DEF_SLASH + 'lib' + US_FileNameOnlyName( Prj_Text_OutputRenameNewName ) + '.' + lower( OutputExt() )
            else
               cOutputName        := US_ShortName(PUB_cProjectFolder) + DEF_SLASH + US_FileNameOnlyName( Prj_Text_OutputRenameNewName ) + '.' + lower( OutputExt() )
               cOutputNameDisplay := PUB_cProjectFolder + DEF_SLASH + US_FileNameOnlyName( Prj_Text_OutputRenameNewName ) + '.' + lower( OutputExt() )
            endif
         else
            if OutputExt() == "A" .and. Prj_Check_OutputPrefix
               cOutputName        := US_ShortName(PUB_cProjectFolder) + DEF_SLASH + 'lib' + US_FileNameOnlyNameAndExt( Prj_Text_OutputRenameNewName )
               cOutputNameDisplay := PUB_cProjectFolder + DEF_SLASH + 'lib' + US_FileNameOnlyNameAndExt( Prj_Text_OutputRenameNewName )
            else
               cOutputName        := US_ShortName(PUB_cProjectFolder) + DEF_SLASH + US_FileNameOnlyNameAndExt( Prj_Text_OutputRenameNewName )
               cOutputNameDisplay := PUB_cProjectFolder + DEF_SLASH + US_FileNameOnlyNameAndExt( Prj_Text_OutputRenameNewName )
            endif
         endif
      otherwise
         cOutputName        := US_ShortName(PUB_cProjectFolder) + DEF_SLASH + if( OutputExt() == "A", 'lib', '' ) + if( PUB_cConvert == "A DLL", substr( US_FileNameOnlyName( GetProperty( "VentanaMain", "GPrgFiles", "Cell", 1, NCOLPRGFULLNAME ) ), 4 ), US_FileNameOnlyName( GetProperty( "VentanaMain", "GPrgFiles", "Cell", 1, NCOLPRGFULLNAME ) ) ) + '.' + lower( OutputExt() )
         cOutputNameDisplay := PUB_cProjectFolder + DEF_SLASH + if( OutputExt() == "A", 'lib', '' ) + US_FileNameOnlyName( GetProperty( "VentanaMain", "GPrgFiles", "Cell", 1, NCOLPRGFULLNAME ) ) + '.' + lower( OutputExt() )
   endcase
   if Prj_Check_OutputSuffix
      cOutputName        := US_FileNameOnlyPathAndName( cOutputName ) + "_" + GetSuffix() + '.' + lower( OutputExt() )
      cOutputNameDisplay := US_FileNameOnlyPathAndName( cOutputNameDisplay ) + "_" + GetSuffix() + '.' + lower( OutputExt() )
   endif
Return if( bForDisplay, cOutputNameDisplay, cOutputName )

Function MyMsgYesNo( a, b, c )
   Local Reto
   DEFAULT b TO "QPM - Confirm"
   DEFAULT c TO nil
   SetMGWaitHide()
   Reto := MsgYesNo( a, b, c, .F. )
   SetMGWaitShow()
Return Reto

Function MyMsgYesNoCancel( a, b )
   Local Reto
   DEFAULT b TO "QPM - Confirm"
   SetMGWaitHide()
   Reto := MsgYesNoCancel( a, b, nil, .F. )
   SetMGWaitShow()
Return Reto

Function MyMsgOkCancel( a, b )
   Local Reto
   DEFAULT b TO "QPM - Confirm"
   SetMGWaitHide()
   Reto := MsgOkCancel( a, b, nil, .F. )
   SetMGWaitShow()
Return Reto

Function MyMsgRetryCancel( a, b )
   Local Reto
   DEFAULT b TO "QPM - Confirm"
   SetMGWaitHide()
   Reto := MsgRetryCancel( a, b, nil, .F. )
   SetMGWaitShow()
Return Reto

Function KillTask()
   Local cRunParms
   Local KillPgm := US_ShortName( PUB_cQPM_Folder ) + DEF_SLASH + "US_Killer.exe"
   Local KillParm := "QPM " + GetOutputModuleName()
   Local cKillTaskControlFile
   cRunParms := US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + "_" + PUB_cSecu + "KILL" + US_DateTimeCen() + ".cng"
   cKillTaskControlFile := US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + "_" + PUB_cSecu + "KCF" + US_DateTimeCen() + ".cnt"
   QPM_MemoWrit( cRunParms, "Run Parms for Kill Task" + HB_OsNewLine() + ;
                        "COMMAND " + KillPgm + " " + KillParm + HB_OsNewLine() + ;
                        "CONTROL " + cKillTaskControlFile )
   QPM_MemoWrit( cKillTaskControlFile, "Run Control File for " + KillPgm )
   QPM_Execute( US_ShortName( PUB_cQPM_Folder ) + DEF_SLASH + "US_Run.exe", "QPM " + cRunParms )
Return .T.

Function DebugOptions( cDire, cPath )
   Local cAux := "", cLeido, i, memoTMP, cLinea
   Local cFile := US_FileNameOnlyPath( cDire ) + DEF_SLASH + "Init.Cld"
   cAux := cAux + 'Options Path ' + cPath + HB_OsNewLine()
// cAux := cAux + 'Options Colors {"W + /BG","N/BG","R/BG","N + /BG","W + /B","GR + /B","W/B","N/W","R/W","N/BG","R/BG","GR + /BG"}' + HB_OsNewLine()
   cAux := cAux + 'Options NoRunAtStartup' + HB_OsNewLine()
// cAux := cAux + 'Window Size 13 64' + HB_OsNewLine()
// cAux := cAux + 'Window Move 6 0' + HB_OsNewLine()
// cAux := cAux + 'Window Next' + HB_OsNewLine()
// cAux := cAux + 'Window Size 5 80' + HB_OsNewLine()
// cAux := cAux + 'Window Move 19 0' + HB_OsNewLine()
// cAux := cAux + 'Window Next' + HB_OsNewLine()
// cAux := cAux + 'Window Size 18 16' + HB_OsNewLine()
// cAux := cAux + 'Window Move 1 64' + HB_OsNewLine()
// cAux := cAux + 'Window Next' + HB_OsNewLine()
// cAux := cAux + 'Window Size 5 64' + HB_OsNewLine()
// cAux := cAux + 'Window Move 1 0' + HB_OsNewLine()
// cAux := cAux + 'Window Next' + HB_OsNewLine()
   cAux := cAux + 'Monitor Static' + HB_OsNewLine()
   cAux := cAux + 'Monitor Public' + HB_OsNewLine()
   cAux := cAux + 'Monitor Local' + HB_OsNewLine()
   cAux := cAux + 'Monitor Private' + HB_OsNewLine()
   cAux := cAux + 'Monitor Sort' + HB_OsNewLine()
   cAux := cAux + 'View CallStack'
   if file( cFile )
      cAux := ""
      cLeido := memoread( cFile )
      for i:=1 to mlcount( cLeido, 254 )
         cLinea := memoline( cLeido, 254, i )
         if upper( US_Word( cLinea, 1 ) ) == "OPTIONS" .and. ;
            upper( US_Word( cLinea, 2 ) ) == "PATH"
            cAux := cAux + "Options Path " + cPath + HB_OsNewLine()
         else
            cAux := cAux + cLinea + HB_OsNewLine()
         endif
      next
   endif
   QPM_MemoWrit( cFile, cAux )
   if bLogActivity
      memoTMP := memoread( PUB_cQPM_Folder + DEF_SLASH + 'QPM.log' )

      memoTMP := memoTMP + HB_OSNewLine() + HB_OSNewLine()
      memoTMP := memoTMP + '****** ' + cFile + HB_OSNewLine()+ HB_OSNewLine()
      memoTMP := memoTMP + cAux + HB_OSNewLine()

      QPM_MemoWrit( PUB_cQPM_Folder+DEF_SLASH + 'QPM.log', memoTMP )
   endif
return .T.

Function ViewLog()
   if ! File( AllTrim( Gbl_Text_Editor ) )
      MsgStop( "Program Editor not Found: " + AllTrim( Gbl_Text_Editor ) + '. Look at ' + PUB_MenuGblOptions + ' of Settings menu.' )
      Return .F.
   endif
   If Empty( Gbl_Text_Editor )
      MyMsg( 'Operation Aborted', US_VarToStr( 'Program editor not defined. Look at ' + PUB_MenuGblOptions + ' of Settings menu.' ), "E", bAutoExit )
      Return .F.
   Endif
   QPM_Execute( US_ShortName( AllTrim( Gbl_Text_Editor ) ), PUB_cQPM_Folder + DEF_SLASH + "QPM.log" )
Return .T.

Function ActLibReimp()
   Local bON := if( Prj_Radio_OutputType == DEF_RG_IMPORT, .T., .F. )
   if bOn
      SetProperty( "VentanaMain", "GPrgFiles", "height", 100 )
   else
      SetProperty( "VentanaMain", "GPrgFiles", "height", GetDesktopRealHeight() - 345 )
   endif
   SetProperty( "VentanaMain", "Check_Reimp"      , "visible", bON )
   SetProperty( "VentanaMain", "LReImportLib"     , "visible", bON )
   SetProperty( "VentanaMain", "TReImportLib"     , "visible", bON )
   SetProperty( "VentanaMain", "BReImportLib"     , "visible", bON )
   SetProperty( "VentanaMain", "Check_GuionA"     , "visible", bON )
   SetProperty( "VentanaMain", "Check_Reimp"      , "enabled", if( Prj_Radio_Cpp == DEF_RG_MINGW, .T., .F. ) )
   SetProperty( "VentanaMain", "LReImportLib"     , "enabled", if( GetProperty( "VentanaMain", "Check_Reimp", "Value" ) .and. GetProperty( "VentanaMain", "Check_Reimp", "enabled" ), .T., .F. ) )
   SetProperty( "VentanaMain", "TReImportLib"     , "enabled", if( GetProperty( "VentanaMain", "Check_Reimp", "Value" ) .and. GetProperty( "VentanaMain", "Check_Reimp", "enabled" ), .T., .F. ) )
   SetProperty( "VentanaMain", "BReImportLib"     , "enabled", if( GetProperty( "VentanaMain", "Check_Reimp", "Value" ) .and. GetProperty( "VentanaMain", "Check_Reimp", "enabled" ), .T., .F. ) )
   SetProperty( "VentanaMain", "Check_GuionA"     , "enabled", if( Prj_Radio_Cpp == DEF_RG_MINGW, .F., .T. ) )
   SetProperty( "VentanaMain", "BUpPrg"           , "enabled", !bON )
   SetProperty( "VentanaMain", "BUpPrg2"          , "visible", !bON )
   SetProperty( "VentanaMain", "BDownPrg"         , "enabled", !bON )
   SetProperty( "VentanaMain", "BDownPrg2"        , "visible", !bON )
   SetProperty( "VentanaMain", "BSortPrg"         , "enabled", !bON )
   SetProperty( "VentanaMain", "BVerChange"       , "enabled", !bON )
   SetProperty( "VentanaMain", "LVerTitle"        , "enabled", !bON )
   SetProperty( "VentanaMain", "LVerVerNum"       , "enabled", !bON )
   SetProperty( "VentanaMain", "LVerPoint"        , "enabled", !bON )
   SetProperty( "VentanaMain", "LVerRelNum"       , "enabled", !bON )
   SetProperty( "VentanaMain", "LVerBui"          , "enabled", !bON )
   SetProperty( "VentanaMain", "LVerBuiNum"       , "enabled", !bON )
   SetProperty( "VentanaMain", "ForceRecompPRG"   , "enabled", !bON )
#ifdef QPM_SYNCRECOVERY
   SetProperty( "VentanaMain", "BTakeSyncRecovery", "enabled", !bON )
#endif
   SetProperty( "VentanaMain", "EraseALL"         , "enabled", !bON )
   SetProperty( "VentanaMain", "EraseOBJ"         , "enabled", !bON )
   SetProperty( "VentanaMain", "BVerChange"       , "enabled", !bON )
   SetProperty( "VentanaMain", "SetTopPrg"        , "enabled", !bON )
   SetProperty( "VentanaMain", "BPrgEdit"         , "enabled", !bON )
   SetProperty( "VentanaMain", "LRunProjectFolder", "enabled", !bON )
   SetProperty( "VentanaMain", "TRunProjectFolder", "enabled", !bON )
   SetProperty( "VentanaMain", "BRunProjectFolder", "enabled", !bON )
Return .T.

Function Enumeracion( cMemoIn, cType )
   Local bNumberOn
   Private cMemoInP := cMemoIn
   bNumberOn := &( "bNumberOn" + cType )
   if ! bNumberOn
      Return cMemoIn
   endif
return QPM_Wait( "Enumeracion2( cMemoInP )", "Enumerating",, .T. )

Function Enumeracion2( cMemoIn )
   Local cFileIn  := PUB_cProjectFolder + DEF_SLASH + "_" + PUB_cSecu + "TmpRenumIn.mem", ;
         cFileOut := PUB_cProjectFolder + DEF_SLASH + "_" + PUB_cSecu + "TmpRenumOut.mem", ;
         nAcum := 0, nTam := len( cMemoIn ), nPor, nPorAnt := 0, hIn, hOut, ;
         cLinea, vFines := { chr(13) + chr(10), Chr(10) }, i:=0, cMemoOut
   QPM_MemoWrit( cFileIn, cMemoIn )
   hOut := fcreate( cFileOut, 0 )       // read/write mode
   hIn := fopen( cFileIn, 0 )        // read mode
   if ferror() = 0
      do while US_FReadLine( hIn, @cLinea, vFines ) == 0
         i ++
         nAcum := nAcum + len( cLinea )
         if GetMGWaitStop()
            fclose( hOut )
            fclose( hIn )
            ferase( cFileIn )
            ferase( cFileOut )
            Return cMemoIn
         endif
         nPor := int( ( nAcum * 100 ) / nTam )
         if nPor != nPorAnt
            SetMGWaitTxt( "Enumerating " + alltrim( str( nPor ) ) + "%" )
            nPorAnt := nPor
         endif
         DO EVENTS
         fwrite( hOut, US_StrCero( i, 6 ) + " " + cLinea + HB_OsNewLine() )
      enddo
   endif
   fclose( hOut )
   fclose( hIn )
   cMemoOut := memoread( cFileOut )
   ferase( cFileIn )
   ferase( cFileOut )
Return cMemoOut

Procedure QPM_Execute( cCMD, cParms, bWait, nSize, RunWaitFileStop )
   Local RunWaitControlFile, RunWaitParms, cSize
   DEFAULT cParms TO ""
   DEFAULT bWait TO .F.
   DEFAULT nSize TO 1      // normal
   if !bWait
      do case
         case nSize == -1           // hide
            EXECUTE FILE ( cCMD ) PARAMETERS ( cParms ) HIDE
         case nSize == 0            // minimized
            EXECUTE FILE ( cCMD ) PARAMETERS ( cParms ) MINIMIZE
         case nSize == 1            // normal
            EXECUTE FILE ( cCMD ) PARAMETERS ( cParms )
         case nSize == 2            // maximized
            EXECUTE FILE ( cCMD ) PARAMETERS ( cParms ) MAXIMIZE
         otherwise
            MsgInfo( "Invalid nSize parm in function QPM_Execute: " + US_VarToStr( nSize ) )
      endcase
   else
      do case
         case nSize == -1           // hide
            cSize := "HIDE"
         case nSize == 0            // minimized
            cSize := "MINIMIZE"
         case nSize == 1            // normal
            cSize := "NORMAL"
         case nSize == 2            // maximized
            cSize := "MAXIMIZE"
         otherwise
            MsgInfo( "Invalid nSize parm in function QPM_Execute (2): " + US_VarToStr( nSize ) )
      endcase
      RunWaitControlFile := US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + "_" + PUB_cSecu + "RWCF" + US_DateTimeCen() + ".cnt"
      RunWaitParms       := US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + "_" + PUB_cSecu + "RWP" + US_DateTimeCen() + ".cng"
      QPM_MemoWrit( RunWaitParms, "Run Wait Parms" + HB_OsNewLine() + ;
                               "COMMAND " + cCMD + " " + cParms + HB_OsNewLine() + ;
                               "CONTROL " + RunWaitControlFile + HB_OsNewLine() + ;
                               "MODE " + cSize )
      QPM_MemoWrit( RunWaitControlFile, "Run Wait Control File" )
      EXECUTE FILE ( US_ShortName( PUB_cQPM_Folder ) + DEF_SLASH + "US_Run.exe" ) PARAMETERS ( "QPM " + RunWaitParms ) HIDE
      do while file( RunWaitControlFile )
         DO EVENTS
         if GetMGWaitStop()
            if !( RunWaitFileStop == NIL )
               //MsgStop( "QPM_Execute: Stop detected but StopFile not received from parameters" )
               //Return .F.
               //endif
               QPM_MemoWrit( RunWaitFileStop, "Run Wait File Stop" )
               do while file( RunWaitFileStop ) .and. file( RunWaitControlFile )
                  DO EVENTS
               enddo
               ferase( RunWaitFileStop )
            endif
         endif
      enddo
   endif
Return

Function ErrorLogName()
   Local cErrorLog := ""
   Local cVer := GetMiniGuiSuffix()
   do case
      case cVer == "M1" .or. cVer == "M3"
         if empty( GetProperty( "VentanaMain", "TRunProjectFolder", "value" ) )
            cErrorLog := PUB_cProjectFolder + DEF_SLASH + "ErrorLog.htm"
         else
         // cErrorLog := "*RUNFOLDER*"
            cErrorLog := GetProperty( "VentanaMain", "TRunProjectFolder", "value" ) + DEF_SLASH + "ErrorLog.htm"
         endif
      case cVer == "E1"
      // if empty( GetProperty( "VentanaMain", "TRunProjectFolder", "value" ) )
            cErrorLog := PUB_cProjectFolder + DEF_SLASH + "ErrorLog.htm"
      // else
      //    cErrorLog := GetProperty( "VentanaMain", "TRunProjectFolder", "value" ) + DEF_SLASH + "ErrorLog.htm"
      // endif
      case cVer == "O3"
         if empty( GetProperty( "VentanaMain", "TRunProjectFolder", "value" ) )
            cErrorLog := PUB_cProjectFolder + DEF_SLASH + "ErrorLog.htm"
         else
            cErrorLog := GetProperty( "VentanaMain", "TRunProjectFolder", "value" ) + DEF_SLASH + "ErrorLog.htm"
         endif
      otherwise
         US_Log( "Invalid minigui suffix" )
   endcase
Return cErrorLog

Function QPM_DeleteErrorLog()
   Local cErrorLog := ErrorLogName()
   if MyMsgYesNo( "Confirm Delete Error Log ?" )
      ferase( cErrorLog )
      SetProperty( "VentanaMain", "RichEditOut", "Value", cErrorLog + " Deleted !!!" )
      SetProperty( "VentanaMain", "RichEditOut", "caretpos", 1 )
   endif
Return .T.

Function MuestroErrorLog()
   SetProperty( "VentanaMain", "RichEditOut", "Value", QPM_Wait( "US_ViewErrorLog()") )
//   SetProperty( "VentanaMain", "RichEditOut", "CaretPos", Len( GetProperty( "VentanaMain", "RichEditOut", "Value" ) ) )
   SetProperty( "VentanaMain", "RichEditOut", "CaretPos", 1 )
Return .T.

Function US_ViewErrorLog()
   Local cMemoHtml, cMemoRtf
   Local cMemoHtmlIni, cMemoHtmlFin
   Local cErrorLog := ErrorLogName()
   Local nLenLog
   Local nPosAux
   Local nTopLenLog := 100000
   if cErrorLog == "*RUNFOLDER*"
      Return "Program is not running from Project Folder" + HB_OsNewLine() + "MiniGui can't generate 'ErrorLog' file. This is a MiniGui limitation or bug"
   endif
   if !file( cErrorLog )
      Return "Error Log Not Found: " + cErrorLog
   endif
   cMemoHtml := memoread( cErrorLog )
   if ( nLenLog := len( cMemoHtml ) ) > nTopLenLog
      cMemoHtmlIni := substr( cMemoHtml, 1, int( nTopLenLog / 2 ) )
      cMemoHtmlIni := substr( cMemoHtmlIni, 1, if( ( nPosAux := rat( '<p class="updated">', cMemoHtmlIni ) ) == 0, Len( cMemoHtmlIni ), nPosAux - 1 ) )
      cMemoHtmlFin := substr( cMemoHtml, nLenLog - int( nTopLenLog / 2 ) )
      cMemoHtmlFin := substr( cMemoHtmlFin, at( '<p class="updated">', cMemoHtmlFin ) )
      cMemoHtml := cMemoHtmlIni + HB_OsNewLine() + ;
                   Replicate( '<HR>', 4 ) + ;
                   '<p class="updated"> - - - - - - - - - - - - - - - - Hidden Text - - - - - - - - - - - - - - - -</p>' + ;
                   Replicate( '<HR>', 4 ) + ;
                   '<HR>' + HB_OsNewLine() + ;
                   cMemoHtmlFin
   endif
   cMemoRtf := '{\rtf1\ansi\ansicpg1252\deff0\deflang3082{\fonttbl{\f0\froman\fcharset0 Arial;}{\f1\froman\fcharset0 Times New Roman;}}' + HB_OsNewLine() + ;
            '{\colortbl ;\red0\green0\blue255;\red221\green0\blue0;}' + HB_OsNewLine() + ;
            '\viewkind4\uc1\pard\keepn\qc\cf1\kerning36\b\f0\fs28 '
   cMemoHtml := substr( cMemoHtml, at( '<BODY>', cMemoHtml ) + 6 )
   cMemoHtml := strtran( cMemoHtml, '\', '\\' )
   cMemoHtml := US_StrTran( cMemoHtml, '<p class="updated">', '\par\cf2 ' )
   cMemoHtml := US_StrTran( cMemoHtml, '</p>', '\cf0\par' )
   cMemoHtml := US_StrTran( cMemoHtml, '<br>', '\line ' )
   cMemoHtml := US_StrTran( cMemoHtml, '<HR>', '\b ' + replicate( '_', 100 ) + '\b0\par' )
   cMemoHtml := US_StrTran( cMemoHtml, '<b>', '{\b ' )
   cMemoHtml := US_StrTran( cMemoHtml, '</b>', '} ' )
   cMemoHtml := US_StrTran( cMemoHtml, '<i>', '{\i ' )
   cMemoHtml := US_StrTran( cMemoHtml, '</i>', '}' )
   cMemoHtml := US_StrTran( cMemoHtml, '<u>', '{\ul ' )
   cMemoHtml := US_StrTran( cMemoHtml, '</u>', '}' )
   cMemoHtml := US_StrTran( cMemoHtml, '</BODY></HTML>', HB_OsNewLine() )
   cMemoHtml := US_StrTran( cMemoHtml, '<H1 Align=Center>', '' )
   cMemoHtml := US_StrTran( cMemoHtml, '</H1>', '\par ' + HB_OsNewLine() + '\pard\cf0\kerning0\b0\f0\fs20\par' )
   cMemoRtf := cMemoRtf + cMemoHtml + '\par\cf1\b\f0\fs24 Error Log from: ' + strtran( cErrorLog, '\', '\\' ) + '\line\par }'
Return cMemoRtf

Function QPM_Send_SelectAll()
   Local cType
   do case
      case GetProperty( "VentanaMain", "TabFiles", "Value" ) == nPagePrg
         cType := "PRG"
      case GetProperty( "VentanaMain", "TabFiles", "Value" ) == nPageHea
         cType := "HEA"
      case GetProperty( "VentanaMain", "TabFiles", "Value" ) == nPagePan
         cType := "PAN"
      case GetProperty( "VentanaMain", "TabFiles", "Value" ) == nPageDbf
         cType := "DBF"
      case GetProperty( "VentanaMain", "TabFiles", "Value" ) == nPageLib
         cType := "LIB"
      case GetProperty( "VentanaMain", "TabFiles", "Value" ) == nPageHlp
         cType := "HLP"
      case GetProperty( "VentanaMain", "TabFiles", "Value" ) == nPageSysout
         cType := "SYSOUT"
      case GetProperty( "VentanaMain", "TabFiles", "Value" ) == nPageOut
         cType := "OUT"
      otherwise
         MsgInfo( "Error en SelectAll, página incorrecta." )
         Return .F.
   endcase
   US_Send_SelectAll( "RichEdit" + cType, "VentanaMain" )
Return .T.

Function QPM_Wait( cFun, cTexto, nFila, bStop )
   PRIVATE SM_oMGWait := US_MGWait():New()

   if cTexto == NIL
      SM_oMGWait:cImagen := "QPMWAIT"
      SM_oMGWait:nImagenWidth  := GetDesktopRealWidth() / 20
      SM_oMGWait:nImagenHeight := SM_oMGWait:nImagenWidth
   else
      SM_oMGWait:cTXT := cTexto
   endif
   if !empty( nFila )
      SM_oMGWait:nFila := nFila
   endif
   if !empty( bStop )
      SM_oMGWait:bStopButton := bStop
   endif
//
// El siguiente scan es para la correccion del problema de las teclas de funcion
// el problema se manifiesta cuando desde un proceso en background se hace release da una ventana MODAL
// ya que Extended Minigui le pasa el foco y ejecuta el ONGOTFOCUS de la ventana anterior, con lo cual tambien activa sus teclas en el sistema
// La clase MGWait hace precisamente eso, hace ACTIVATE y RELEASE de una ventana mientras se ejecuta una funcion, por eso cuando no hay
// una ventana activa ejecuto directamente la funcion sin llamar a MGWait
// Esto no corrige definitivamente el problema pero corrige el 99% de los casos en QPM
// El error se regenera facilmente:
// edite prg 1
// edite prg 2
// coloque el orden de las ventanas de modo que despues de cerrar PRG 1 quede el foco en PRG2
// una vez que las tenga asi, cierre prg 1 y vera que prg 2 ya no responde
// obiamente que para esa prueba hay que sacar la pregunta de getActiveWindow()
*  us_log( GetFocus(), .F. )
*  us_log( GetActiveWindow(), .F. )
*  us_log( _HMG_aFormNames[ AScan( _HMG_aFormHandles, GetActiveWindow() ) ], .F. )
*  AScan( US_StackListArray(), { |x| x = "QPM_TIMER_" .or. substr( x, 3 ) = "QPM_TIMER_" } ) > 0    // Notese que la comparacion es por "="

Return if( GetActiveWindow() == 0, &( cFun ), SM_oMGWait:Ejecutar( cFun ) )
   
Function SetMGWaitTxt( txt )
   if US_IsVarDefined( "SM_oMGWait" )
      SM_oMGWait:cTXT := txt
      DO EVENTS
   endif
Return .T.

Function GetMGWaitTxt()
   Local txt := ""
   if US_IsVarDefined( "SM_oMGWait" )
      txt := SM_oMGWait:cTXT
   endif
Return txt

Function GetMGWaitStop()
   if US_IsVarDefined( "SM_oMGWait" )
      Return SM_oMGWait:bStop
   endif
Return .F.

Function SetMGWaitShow()
   if US_IsVarDefined( "SM_oMGWait" )
      US_Wait( ( SM_oMGWait:nTimerRefresh / 1000 ) * 2 )
      SM_oMGWait:bShow := .T.
   endif
Return .T.

Function SetMGWaitHide()
   if US_IsVarDefined( "SM_oMGWait" )
      SM_oMGWait:bShow := .F.
      US_Wait( ( SM_oMGWait:nTimerRefresh / 1000 ) * 2 )
   endif
Return .T.

Function QPM_ChangePrj_Version()
   DEFINE WINDOW WinChangeVersion ;
      AT 0, 0 ;
      WIDTH 300 ;
      HEIGHT 200 ;
      TITLE "Change Project Version" ;
      MODAL ;
      NOSYSMENU ;
      ON INTERACTIVECLOSE US_NOP()

      @ 08, 35 FRAME WinChangeVersionF ;
         WIDTH 220 ;
         HEIGHT 90

      @ 18, 40 LABEL WinChangeVersionL ;
         VALUE 'Version : Release : Build' ;
         WIDTH 200 ;
         FONT 'arial' SIZE 10 BOLD ;
         FONTCOLOR DEF_COLORBLUE

      DEFINE TEXTBOX TVerVerNum
         ROW             50
         COL             90
         WIDTH           25
         VALUE           GetProperty( "VentanaMain", "LVerVerNum", "value" )
         INPUTMASK       Replicate( "9", DEF_LEN_VER_VERSION )
      END TEXTBOX

      DEFINE TEXTBOX TVerRelNum
         ROW             50
         COL             120
         WIDTH           25
         VALUE           GetProperty( "VentanaMain", "LVerRelNum", "value" )
         INPUTMASK       Replicate( "9", DEF_LEN_VER_RELEASE )
      END TEXTBOX

      DEFINE TEXTBOX TVerBuiNum
         ROW             50
         COL             150
         WIDTH           50
         VALUE           GetProperty( "VentanaMain", "LVerBuiNum", "value" )
         INPUTMASK       Replicate( "9", DEF_LEN_VER_BUILD )
      END TEXTBOX

      DEFINE BUTTON WinChangeVersionOK
         ROW             115
         COL             35
         WIDTH           80
         HEIGHT          25
         CAPTION         'OK'
         TOOLTIP         'Confirm change'
         ONCLICK         QPM_ChangePrj_VersionOK()
      END BUTTON

      DEFINE BUTTON WinChangeVersionCANCEL
         ROW             115
         COL             175
         WIDTH           80
         HEIGHT          25
         CAPTION         'Cancel'
         TOOLTIP         'Cancel change'
         ONCLICK         WinChangeVersion.Release()
      END BUTTON

      ON KEY ESCAPE ACTION WinChangeVersion.Release()
   END WINDOW
   CENTER WINDOW WinChangeVersion
   ACTIVATE WINDOW WinChangeVersion
Return .T.

Function QPM_ChangePrj_VersionOK()
   DELETE FILE ( PUB_cProjectFolder + DEF_SLASH + US_FileNameOnlyName( GetOutputModuleName() ) + '.' + OutputExt() )
   SetProperty( "VentanaMain", "LVerVerNum", "value", PadL( alltrim( GetProperty( "WinChangeVersion", "TVerVerNum", "value" ) ), DEF_LEN_VER_VERSION, "0" ) )
   SetProperty( "VentanaMain", "LVerRelNum", "value", PadL( alltrim( GetProperty( "WinChangeVersion", "TVerRelNum", "value" ) ), DEF_LEN_VER_RELEASE, "0" ) )
   SetProperty( "VentanaMain", "LVerBuiNum", "value", PadL( alltrim( GetProperty( "WinChangeVersion", "TVerBuiNum", "value" ) ), DEF_LEN_VER_BUILD, "0" ) )
   RichEditDisplay( "OUT" )
   WinChangeVersion.Release()
Return .T.

Function ReplacePrj_Version( cFile, cPrj_Version )
   Local cMemo := MemoRead( cFile ), nInx, cLine, cMemoOut := "", bFound := .F.
   For nInx := 1 to MLCount( cMemo, 254 )
      cLine := Memoline( cMemo, 254, nInx )
      if ! bFound .and. ;
         US_Word( cLine, 1 ) == "PRJ_VERSION"
         bFound := .T.
         cMemoOut := cMemoOut + "PRJ_VERSION " + cPrj_Version + HB_OsNewLine()
      else
         cMemoOut := cMemoOut + cLine + HB_OsNewLine()
      endif
   Next
   QPM_MemoWrit( cFile, cMemoOut )
Return .T.

Function ReplaceDebugActive( cFile, bDebugActive )
   Local cMemo := MemoRead( cFile ), nInx, cLine, cMemoOut := "", bFound := .F.
   For nInx := 1 to MLCount( cMemo, 254 )
      cLine := Memoline( cMemo, 254, nInx )
      if !bFound .and. ;
         US_Word( cLine, 1 ) == "DEBUGACTIVE"
         bFound := .T.
         cMemoOut := cMemoOut + "DEBUGACTIVE " + IF( bDebugActive, "YES", "NO" ) + HB_OsNewLine()
      else
         cMemoOut := cMemoOut + cLine + HB_OsNewLine()
      endif
   Next
   QPM_MemoWrit( cFile, cMemoOut )
Return .T.

Function QPM_ProjectFileLock( cFile )
   PUB_nProjectFileHandle := FOpen( cFile, 2 + 32 ) // 2 FO_READWRITE Open for reading or writing + 32 FO_DENYWRITE Prevent others from writing
Return FError()

Function QPM_ProjectFileUnLock()
   if PUB_nProjectFileHandle != 0
      FClose( PUB_nProjectFileHandle )
   endif
Return FError()

/* eof */
