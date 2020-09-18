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

#include 'minigui.ch'
#include 'QPM.ch'

memvar OLD_Check_64bits
memvar OLD_Check_HarbourIs31
memvar OLD_Check_StaticBuild
memvar OLD_Radio_Cpp
memvar OLD_Radio_Harbour
memvar OLD_Radio_MiniGui

Function ProjectSettings()
   Local Folder := '', lAfterOnInit := .F.

   if Empty ( PUB_cProjectFolder )
      MyMsgStop( 'No project is open.' )
      Return .F.
   EndIf

   PRIVATE OLD_Check_64bits      := Prj_Check_64bits
   PRIVATE OLD_Check_HarbourIs31 := Prj_Check_HarbourIs31
   PRIVATE OLD_Check_StaticBuild := Prj_Check_StaticBuild
   PRIVATE OLD_Radio_Cpp         := Prj_Radio_Cpp
   PRIVATE OLD_Radio_Harbour     := Prj_Radio_Harbour
   PRIVATE OLD_Radio_MiniGui     := Prj_Radio_MiniGui

/* Ensure the values are valid and consistent.
 *
 * Forbiden combinations:
 *    MINIGUI1  + MINGW
 *    MINIGUI1  + PELLES
 *    MINIGUI3  + BORLAND
 *    MINIGUI3  + PELLES
 *    MINIGUI3  + XHARBOUR
 */
   do case
   case OLD_Radio_MiniGui == DEF_RG_MINIGUI1
      if OLD_Radio_Cpp != DEF_RG_BORLAND
         OLD_Radio_Cpp := DEF_RG_BORLAND
      endif
   case OLD_Radio_MiniGui == DEF_RG_MINIGUI3
      if OLD_Radio_Cpp != DEF_RG_MINGW
         OLD_Radio_Cpp := DEF_RG_MINGW
      endif
      if OLD_Radio_Harbour != DEF_RG_HARBOUR
         OLD_Radio_Harbour := DEF_RG_HARBOUR
      endif
   case OLD_Radio_MiniGui == DEF_RG_EXTENDED1
   case OLD_Radio_MiniGui == DEF_RG_OOHG3
   otherwise
      OLD_Radio_MiniGui := DEF_RG_OOHG3
   endcase
/* Forbiden combinations:
 *    BORLAND + 64 bits
 *    BORLAND + Non static build
 *    PELLES + Non static build
 */
   do case
   case OLD_Radio_Cpp == DEF_RG_BORLAND
      if OLD_Check_64bits
         OLD_Check_64bits := .F.
      endif
      if ! OLD_Check_StaticBuild
         OLD_Check_StaticBuild := .T.
      endif
   case OLD_Radio_Cpp == DEF_RG_MINGW
   case OLD_Radio_Cpp == DEF_RG_PELLES
      if ! OLD_Check_StaticBuild
         OLD_Check_StaticBuild := .T.
      endif
   otherwise
      OLD_Radio_Cpp := DEF_RG_MINGW
   endcase
/* Forbiden combinations:
 *    XHARBOUR + 3.1 or upper
 */
   do case
   case OLD_Radio_Harbour == DEF_RG_HARBOUR
   case OLD_Radio_Harbour == DEF_RG_XHARBOUR
      if OLD_Check_HarbourIs31
         OLD_Check_HarbourIs31 := .F.
      endif
   otherwise
      OLD_Radio_Cpp := DEF_RG_HARBOUR
   endcase

   DEFINE WINDOW WinPSettings ;
          AT 0, 0 ;
          WIDTH 560 ;
          HEIGHT 610 ;
          TITLE 'Project Options' ;
          MODAL ;
          NOSYSMENU ;
          ON INIT ( SwitchRadioOutputType(), ;
                    SwitchRadioOutputCopyMove(), ;
                    SwitchRadioOutputRename(), ;
                    CheckCombination( lAfterOnInit ), ;
                    lAfterOnInit := .T. ) ;
          ON INTERACTIVECLOSE US_NOP() ;
          ON RELEASE QPM_SetColor()

      @ 08, 20 FRAME FCompiler ;
         WIDTH 250 ;
         HEIGHT 120

      @ 13, 30 LABEL LCompiler ;
         VALUE 'Compilers:' ;
         WIDTH 110 ;
         FONT 'arial' SIZE 10 BOLD ;
         FONTCOLOR DEF_COLORBLUE

      @ 40, 40 RADIOGROUP Radio_Harbour ;
         OPTIONS { 'Harbour', 'xHarbour' } ;
         VALUE OLD_Radio_Harbour ;
         WIDTH  100 ;
         TOOLTIP 'Select PRG compiler' ;
         ON CHANGE CheckCombination( lAfterOnInit )

      @ 96, 40 CHECKBOX Chk_HBVersion ;
         CAPTION 'Harbour 3.1 or later' ;
         WIDTH 130 ;
         HEIGHT 24 ;
         FONT 'arial' SIZE 10 ;
         VALUE OLD_Check_HarbourIs31 ;
         TRANSPARENT ;
         LEFTJUSTIFY

      @ 16, 150 RADIOGROUP Radio_Cpp ;
         OPTIONS { 'BCC32', 'MinGW', 'Pelles' } ;
         VALUE OLD_Radio_Cpp ;
         WIDTH  100 ;
         TOOLTIP 'Select C compiler' ;
         ON CHANGE CheckCombination( lAfterOnInit )

      @ 96, 180 CHECKBOX Chk_64Bits ;
         CAPTION '64 bits' ;
         WIDTH 60 ;
         HEIGHT 24 ;
         FONT 'arial' SIZE 10 ;
         VALUE OLD_Check_64bits ;
         TRANSPARENT ;
         LEFTJUSTIFY ;
         ON CHANGE CheckCombination( lAfterOnInit )

      @ 08, 285 FRAME FMinigui ;
         WIDTH 240 ;
         HEIGHT 155

      @ 13, 290 LABEL LMinigui ;
         VALUE 'GUI Library:' ;
         WIDTH 275 ;
         FONT 'arial' SIZE 10 BOLD ;
         FONTCOLOR DEF_COLORBLUE

      @ 30, 300 RADIOGROUP Radio_MiniGui ;
         OPTIONS { 'HMG 1.x', 'HMG 3.x', 'HMG Extended', 'OOHG' } ;
         VALUE OLD_Radio_MiniGui ;
         WIDTH 200 ;
         TOOLTIP "Select Minigui flavor" ;
         ON CHANGE CheckCombination( lAfterOnInit )

      DEFINE CHECKBOX Check_Console
              CAPTION         'Console Mode'
              ROW             130
              COL             300
              WIDTH           140
              VALUE           Prj_Check_Console
              TOOLTIP         'Build in console mode using associated (x)Harbour compiler'
      END CHECKBOX

      DEFINE CHECKBOX Check_MT
              CAPTION         'MT Mode'
              ROW             130
              COL             450
              WIDTH           100
              VALUE           Prj_Check_MT
              TOOLTIP         'Use multithread libraries'
      END CHECKBOX

      @ 138, 20 FRAME FOutputType ;
         WIDTH 250 ;
         HEIGHT 120

      @ 143, 30 LABEL LOutputType ;
         VALUE 'Output Type:' ;
         WIDTH 150 ;
         FONT 'arial' SIZE 10 BOLD ;
         FONTCOLOR DEF_COLORBLUE

      @ 170, 40 RADIOGROUP Radio_OutputType ;
         OPTIONS { 'Executable (.EXE)', 'Library (.LIB or .A)', 'Interface Library (for DLL)' } ;
         VALUE Prj_Radio_OutputType ;
         WIDTH 160 ;
         ON CHANGE SwitchRadioOutputType() ;
         TOOLTIP 'Select Output Type'

      DEFINE CHECKBOX Check_StaticBuild
              CAPTION         'Static'
              ROW             170
              COL             200
              WIDTH           60
              VALUE           OLD_Check_StaticBuild
              TOOLTIP         'Link EXE using static libraries'
      END CHECKBOX

      DEFINE CHECKBOX Check_OutputPrefix
              CAPTION         'Add Lib'
              ROW             195
              COL             200
              WIDTH           60
              VALUE           Prj_Check_OutputPrefix
              TOOLTIP         'Add ' + DBLQT + 'Lib' + DBLQT + " prefix to Output's filename"
      END CHECKBOX

      DEFINE CHECKBOX Check_Upx
              CAPTION         'UPX'
              ROW             220
              COL             200
              WIDTH           50
              VALUE           Prj_Check_Upx
              TOOLTIP         'Compress EXE using ' + DBLQT + 'Ultimate Packer for eXecutables' + DBLQT + ' -UPX- utility.'
      END CHECKBOX

      @ 268, 20 FRAME FOutputCopyMove ;
         WIDTH 250 ;
         HEIGHT 160

      @ 273, 30 LABEL LOutputCopyMove ;
         VALUE 'Output Copy/Move:' ;
         WIDTH 150 ;
         FONT 'arial' SIZE 10 BOLD ;
         FONTCOLOR DEF_COLORBLUE

      @ 300, 40 RADIOGROUP Radio_OutputCopyMove ;
         OPTIONS { 'None', 'Copy to...', 'Move to...' } ;
         VALUE Prj_Radio_OutputCopyMove ;
         WIDTH 120 ;
         ON CHANGE SwitchRadioOutputCopyMove() ;
         TOOLTIP 'Select what to do after building'

      DEFINE TEXTBOX Text_CopyMove
              VALUE           Prj_Text_OutputCopyMoveFolder
              ROW             390
              COL              40
              WIDTH           150
      END TEXTBOX

      DEFINE BUTTON Button_CopyMove
              ROW             390
              COL             200
              WIDTH           25
              HEIGHT          25
              PICTURE         'folderselect'
              TOOLTIP         'Select destination folder for Copy or Move operation'
              ONCLICK         If ( !Empty( Folder := GetFolder( 'Select Folder', if( empty( WinPSettings.Text_CopyMove.Value ), PUB_cProjectFolder, WinPSettings.Text_CopyMove.Value ) ) ), WinPSettings.Text_CopyMove.Value := Folder, )
      END BUTTON

      @ 168, 285 FRAME FOutputRename ;
         WIDTH 240 ;
         HEIGHT 117

      @ 173, 290 LABEL LOutputRename ;
         VALUE 'Output Rename:' ;
         WIDTH 130 ;
         FONT 'arial' SIZE 10 BOLD ;
         FONTCOLOR DEF_COLORBLUE

      @ 190, 300 RADIOGROUP Radio_OutputRename ;
         OPTIONS { 'None', 'Rename to ...' } ;
         VALUE Prj_Radio_OutputRename ;
         WIDTH 140 ;
         ON CHANGE SwitchRadioOutputRename() ;
         TOOLTIP 'Select what to do after building'

      DEFINE TEXTBOX Text_RenameOutput
              VALUE           Prj_Text_OutputRenameNewName
              ROW             250
              COL             300
              WIDTH           150
      END TEXTBOX

      DEFINE CHECKBOX Check_OutputSuffix
              CAPTION         'Add Suffix'
              ROW             190
              COL             450
              WIDTH           100
              VALUE           Prj_Check_OutputSuffix
              TOOLTIP         "Automatically add to the Output's filename a suffix identifying (x)Harbour and Minigui versions"
      END CHECKBOX

      @ 292, 285 FRAME FExtraRun ;
         WIDTH 240 ;
         HEIGHT 070

      @ 297, 290 LABEL LExtraRun ;
         VALUE 'Extra Run After Successful Build:' ;
         WIDTH 350 ;
         FONT 'arial' SIZE 10 BOLD ;
         FONTCOLOR DEF_COLORBLUE

      DEFINE TEXTBOX Text_ExtraRunCmd
              VALUE           Prj_ExtraRunCmdFINAL
              ROW             327
              COL             300
              WIDTH           180
      END TEXTBOX

      DEFINE BUTTON Button_ExtraRun
              ROW             327
              COL             490
              WIDTH           25
              HEIGHT          25
              PICTURE         'folderselect'
              TOOLTIP         'Select process'
              ONCLICK         QPM_GetExtraRun()
      END BUTTON

      @ 438, 20 FRAME FDbf ;
         WIDTH 250 ;
         HEIGHT 90

      @ 443, 30 LABEL LDbf ;
         VALUE "Tool for DBF edition:" ;
         WIDTH 275 ;
         FONT 'arial' SIZE 10 BOLD ;
         FONTCOLOR DEF_COLORBLUE

      @ 470, 40 RADIOGROUP Radio_Dbf ;
         OPTIONS { 'DbfView (by Grigory Filatov)', 'User defined' } ;
         VALUE Prj_Radio_DbfTool ;
         WIDTH 200

      @ 375, 285 FRAME FForm ;
         WIDTH 240 ;
         HEIGHT 153

      @ 380, 290 LABEL LForm ;
         VALUE 'Tool for FMG edition:' ;
         WIDTH 275 ;
         FONT 'arial' SIZE 10 BOLD ;
         FONTCOLOR DEF_COLORBLUE

      @ 407, 300 RADIOGROUP Radio_Form ;
         OPTIONS { 'Automatic', 'OOHG IDE+', 'HMGS-IDE', 'HMG-IDE' } ;
         VALUE Prj_Radio_FormTool ;
         WIDTH 200

      DEFINE BUTTON B_OK
             ROW             538
             COL             190
             WIDTH           80
             HEIGHT          25
             CAPTION         'OK'
             TOOLTIP         'Confirm changes'
             ONCLICK         ProjectSettingsSave()
      END BUTTON

      DEFINE BUTTON B_CANCEL
             ROW             538
             COL             285
             WIDTH           80
             HEIGHT          25
             CAPTION         'Cancel'
             TOOLTIP         'Cancel changes'
             ONCLICK         ProjectEscape()
      END BUTTON

      ON KEY ESCAPE OF WinPSettings ACTION ProjectEscape()
   END WINDOW

   CENTER WINDOW WinPSettings
   ACTIVATE WINDOW WinPSettings
Return .T.

Function ProjectEscape()
   if ProjectChanged()
      if MyMsgYesNo( 'Changes will be discarded. Continue?' )
         WinPSettings.release()
      endif
   else
      WinPSettings.release()
   endif
Return .T.

Function ProjectChanged()
   if Prj_Radio_Harbour             != WinPSettings.Radio_Harbour.value        .or. ;
      Prj_Check_HarbourIs31         != WinPSettings.Chk_HBVersion.value        .or. ;
      Prj_Check_64bits              != WinPSettings.Chk_64bits.value           .or. ;
      Prj_Radio_Cpp                 != WinPSettings.Radio_Cpp.value            .or. ;
      Prj_Radio_MiniGui             != WinPSettings.Radio_MiniGui.value        .or. ;
      Prj_Check_Console             != WinPSettings.Check_Console.value        .or. ;
      Prj_Check_MT                  != WinPSettings.Check_MT.value             .or. ;
      Prj_Radio_OutputType          != WinPSettings.Radio_OutputType.value     .or. ;
      Prj_Radio_OutputCopyMove      != WinPSettings.Radio_OutputCopyMove.value .or. ;
      Prj_Text_OutputCopyMoveFolder != WinPSettings.Text_CopyMove.value        .or. ;
      Prj_Radio_OutputRename        != WinPSettings.Radio_OutputRename.value   .or. ;
      Prj_Text_OutputRenameNewName  != WinPSettings.Text_RenameOutput.value    .or. ;
      Prj_Check_OutputSuffix        != WinPSettings.Check_OutputSuffix.value   .or. ;
      Prj_Check_OutputPrefix        != WinPSettings.Check_OutputPrefix.value   .or. ;
      Prj_Check_StaticBuild         != WinPSettings.Check_StaticBuild.value    .or. ;
      Prj_Radio_FormTool            != WinPSettings.Radio_Form.value           .or. ;
      Prj_Radio_DbfTool             != WinPSettings.Radio_Dbf.value            .or. ;
      Prj_ExtraRunCmdFINAL          != WinPSettings.Text_ExtraRunCmd.value     .or. ;
      Prj_Check_Upx                 != WinPSettings.Check_Upx.value
      Return .T.
   endif
Return .F.

Function ProjectSettingsSave()
   do case
   case WinPSettings.Radio_OutputType.value < DEF_RG_IMPORT .and. ;
        GetProperty( 'VentanaMain', 'GPrgFiles', 'ItemCount' ) == 1 .and. ;
        ( Upper( US_FileNameOnlyExt( GetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', 1, NCOLPRGNAME ) ) ) == 'DLL' .or. ;
          Upper( US_FileNameOnlyExt( GetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', 1, NCOLPRGNAME ) ) ) == 'LIB' .or. ;
          Upper( US_FileNameOnlyExt( GetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', 1, NCOLPRGNAME ) ) ) == 'A' )
      MyMsgStop( 'Output types ' + DBLQT + 'Executable' + DBLQT + ' and ' + DBLQT + 'Library' + DBLQT + ' do not support ' + DBLQT + 'DLL' + DBLQT + ', ' + DBLQT + 'LIB' + DBLQT + ' or ' + DBLQT + 'A' + DBLQT + ' into source list.' + HB_OsNewLine() + ;
               'Remove those files before changing the ' + DBLQT + 'Output Type' + DBLQT + '.' )
      Return .F.
   case WinPSettings.Radio_OutputType.value == DEF_RG_IMPORT .and. ;
        GetProperty( 'VentanaMain', 'GPrgFiles', 'ItemCount' ) == 1 .and. ;
        ( Upper( US_FileNameOnlyExt( GetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', 1, NCOLPRGNAME ) ) ) == 'PRG' .or. ;
          Upper( US_FileNameOnlyExt( GetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', 1, NCOLPRGNAME ) ) ) == 'C' .or. ;
          Upper( US_FileNameOnlyExt( GetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', 1, NCOLPRGNAME ) ) ) == 'CPP' )
      MyMsgStop( 'Output type ' + DBLQT + 'Interface Library' + DBLQT + ' does not support ' + DBLQT + 'PRG' + DBLQT + ', ' + DBLQT + 'C' + DBLQT + ' or ' + DBLQT + 'CPP' + DBLQT + ' into source list.' + HB_OsNewLine() + ;
               'Remove those files before changing the ' + DBLQT + 'Output Type' + DBLQT + '.' )
      Return .F.
   case WinPSettings.Radio_OutputType.value == DEF_RG_IMPORT .and. ;
        GetProperty( 'VentanaMain', 'GPrgFiles', 'ItemCount' ) > 1
      MyMsgStop( 'Output type ' + DBLQT + 'Interface Library' + DBLQT + ' does not support ' + DBLQT + 'PRG' + DBLQT + ', ' + DBLQT + 'C' + DBLQT + ' or ' + DBLQT + 'CPP' + DBLQT + ' into source list.' + HB_OsNewLine() + ;
               'Remove those files before changing the ' + DBLQT + 'Output Type' + DBLQT + '.' )
      Return .F.
   endcase

   if Prj_Radio_Harbour     != WinPSettings.Radio_Harbour.value    .or. ;
      Prj_Check_HarbourIs31 != WinPSettings.Chk_HBVersion.value    .or. ;
      Prj_Check_64bits      != WinPSettings.Chk_64bits.value       .or. ;
      Prj_Radio_Cpp         != WinPSettings.Radio_Cpp.value        .or. ;
      Prj_Radio_MiniGui     != WinPSettings.Radio_MiniGui.value    .or. ;
      Prj_Check_Console     != WinPSettings.Check_Console.value    .or. ;
      Prj_Check_MT          != WinPSettings.Check_MT.value         .or. ;
      Prj_Radio_OutputType  != WinPSettings.Radio_OutputType.value

      IF ! Empty( LibsActiva )
         DescargoDefaultLibs( LibsActiva )
         DescargoIncludeLibs( LibsActiva )
         DescargoExcludeLibs( LibsActiva )
      ENDIF

      Prj_Radio_Harbour     := WinPSettings.Radio_Harbour.value
      Prj_Check_HarbourIs31 := WinPSettings.Chk_HBVersion.value
      Prj_Check_64bits      := WinPSettings.Chk_64bits.value
      Prj_Radio_Cpp         := WinPSettings.Radio_Cpp.value
      Prj_Radio_MiniGui     := WinPSettings.Radio_MiniGui.value
      Prj_Check_Console     := WinPSettings.Check_Console.value
      Prj_Check_MT          := WinPSettings.Check_MT.value
      Prj_Radio_OutputType  := WinPSettings.Radio_OutputType.value

      IF ! Prj_Radio_OutputType == DEF_RG_IMPORT
         QPM_InitLibrariesForFlavor( GetSuffix() )
         CargoDefaultLibs( GetSuffix() )
         CargoIncludeLibs( GetSuffix() )
         CargoExcludeLibs( GetSuffix() )
      ENDIF

      QPM_SetResumen()
   endif

   Prj_Radio_OutputCopyMove      := WinPSettings.Radio_OutputCopyMove.value
   Prj_Text_OutputCopyMoveFolder := WinPSettings.Text_CopyMove.value
   Prj_Radio_OutputRename        := WinPSettings.Radio_OutputRename.value
   Prj_Text_OutputRenameNewName  := WinPSettings.Text_RenameOutput.value
   Prj_Check_OutputSuffix        := WinPSettings.Check_OutputSuffix.value
   Prj_Check_OutputPrefix        := WinPSettings.Check_OutputPrefix.value
   Prj_Check_StaticBuild         := WinPSettings.Check_StaticBuild.value
   Prj_Radio_FormTool            := WinPSettings.Radio_Form.value
   Prj_Radio_DbfTool             := WinPSettings.Radio_Dbf.value
   Prj_ExtraRunCmdFINAL          := WinPSettings.Text_ExtraRunCmd.value
   Prj_Check_Upx                 := WinPSettings.Check_Upx.value

   ActOutputTypeSet()
   ActLibReimp()
   CambioTitulo()

   WinPSettings.Release()
Return .T.

Function SwitchRadioOutputCopyMove()
   do case
   case WinPSettings.Radio_OutputCopyMove.value == 1
      WinPSettings.Text_CopyMove.Enabled := .F.
      WinPSettings.Button_CopyMove.Enabled := .F.
   case WinPSettings.Radio_OutputCopyMove.value == 2
      WinPSettings.Text_CopyMove.Enabled := .T.
      WinPSettings.Button_CopyMove.Enabled := .T.
   case WinPSettings.Radio_OutputCopyMove.value == 3
      WinPSettings.Text_CopyMove.Enabled := .T.
      WinPSettings.Button_CopyMove.Enabled := .T.
   endcase
Return .T.

Function SwitchRadioOutputRename()
   do case
   case WinPSettings.Radio_OutputRename.value == 1
      WinPSettings.Text_RenameOutput.Enabled := .F.
   case WinPSettings.Radio_OutputRename.value == 2
      WinPSettings.Text_RenameOutput.Enabled := .T.
   endcase
Return .T.

Function SwitchRadioOutputType()
   if WinPSettings.Radio_OutputType.value < DEF_RG_IMPORT
      WinPSettings.Check_Console.Enabled := .T.
      WinPSettings.Radio_Harbour.Enabled := .T.
   else
      WinPSettings.Check_Console.Enabled := .F.
      WinPSettings.Radio_Harbour.Enabled := .F.
   endif
Return .T.

Function CheckCombination( lAfterOnInit )
/*
 * Forbiden combinations:
 *
 *    MINIGUI1  + MINGW
 *    MINIGUI1  + PELLES
 *    MINIGUI3  + BORLAND
 *    MINIGUI3  + PELLES
 *    MINIGUI3  + XHARBOUR
 */
   do case
   case WinPSettings.Radio_MiniGui.value == DEF_RG_MINIGUI1
      if WinPSettings.Radio_Cpp.value != DEF_RG_BORLAND
         if lAfterOnInit
            MyMsgStop( 'The selected C compiler is not valid for the selected MiniGui.' )
         endif
         if OLD_Radio_Cpp != DEF_RG_BORLAND
            OLD_Radio_Cpp := DEF_RG_BORLAND
         endif
         WinPSettings.Radio_Cpp.value := OLD_Radio_Cpp
      endif
   case WinPSettings.Radio_MiniGui.value == DEF_RG_MINIGUI3
      if WinPSettings.Radio_Cpp.value != DEF_RG_MINGW
         if lAfterOnInit
            MyMsgStop( 'The selected C compiler is not valid for the selected MiniGui.' )
         endif
         if OLD_Radio_Cpp != DEF_RG_MINGW
            OLD_Radio_Cpp := DEF_RG_MINGW
         endif
         WinPSettings.Radio_Cpp.value := OLD_Radio_Cpp
      endif
      if WinPSettings.Radio_Harbour.value != DEF_RG_HARBOUR
         if lAfterOnInit
            MyMsgStop( 'The selected PRG compiler is not valid for the selected MiniGui.' )
         endif
         if OLD_Radio_Harbour != DEF_RG_HARBOUR
            OLD_Radio_Harbour := DEF_RG_HARBOUR
         endif
         WinPSettings.Radio_Harbour.value := OLD_Radio_Harbour
      endif
   case WinPSettings.Radio_MiniGui.value == DEF_RG_EXTENDED1
   case WinPSettings.Radio_MiniGui.value == DEF_RG_OOHG3
   otherwise
      if lAfterOnInit
         MyMsgStop( 'No valid MiniGui is selected.' )
      endif
      if OLD_Radio_MiniGui != DEF_RG_MINIGUI1 .and. OLD_Radio_MiniGui != DEF_RG_MINIGUI3 .and. OLD_Radio_MiniGui != DEF_RG_EXTENDED1 .and. OLD_Radio_MiniGui != DEF_RG_OOHG3
         OLD_Radio_MiniGui := DEF_RG_OOHG3
      endif
      WinPSettings.Radio_MiniGui.value := OLD_Radio_MiniGui
   endcase
/* Forbiden combinations:
 *    BORLAND + 64 bits
 *    BORLAND + Non static build
 *    PELLES + Non static build
 */
   do case
   case WinPSettings.Radio_Cpp.value == DEF_RG_BORLAND
      if WinPSettings.Chk_64bits.value
         if lAfterOnInit
            MyMsgStop( DBLQT + '64 bits' + DBLQT + ' switch only applies to MinGW and Pelles compilers.' )
         endif
         if OLD_Check_64bits
            OLD_Check_64bits := .F.
         endif
         WinPSettings.Chk_64bits.value := OLD_Check_64bits
         if ! OLD_Check_StaticBuild
            OLD_Check_StaticBuild := .T.
         endif
         WinPSettings.Check_StaticBuild.value := OLD_Check_StaticBuild
      endif
   case WinPSettings.Radio_Cpp.value == DEF_RG_MINGW
   case WinPSettings.Radio_Cpp.value == DEF_RG_PELLES
      if ! OLD_Check_StaticBuild
         OLD_Check_StaticBuild := .T.
      endif
      WinPSettings.Check_StaticBuild.value := OLD_Check_StaticBuild
   otherwise
      if lAfterOnInit
         MyMsgStop( 'No valid C compiler is selected.' )
      endif
      do case
      case WinPSettings.Radio_MiniGui.value == DEF_RG_MINIGUI1
         OLD_Radio_Cpp := DEF_RG_BORLAND
      case WinPSettings.Radio_MiniGui.value == DEF_RG_MINIGUI3
         OLD_Radio_Cpp := DEF_RG_MINGW
      case WinPSettings.Radio_MiniGui.value == DEF_RG_EXTENDED1
         if OLD_Radio_Cpp != DEF_RG_MINGW .and. OLD_Radio_Cpp != DEF_RG_BORLAND
            if WinPSettings.Chk_64bits.value
               OLD_Radio_Cpp := DEF_RG_MINGW
            else
               OLD_Radio_Cpp := DEF_RG_BORLAND
            endif
         endif
      case WinPSettings.Radio_MiniGui.value == DEF_RG_OOHG3
         if OLD_Radio_Cpp != DEF_RG_MINGW .and. OLD_Radio_Cpp != DEF_RG_BORLAND .and. OLD_Radio_Cpp != DEF_RG_PELLES
            OLD_Radio_Cpp := DEF_RG_MINGW
         endif
      endcase
      WinPSettings.Radio_Cpp.value := OLD_Radio_Cpp
   endcase
/* Forbiden combinations:
 *    XHARBOUR + 3.1 or upper
 */
   do case
   case WinPSettings.Radio_Harbour.value == DEF_RG_HARBOUR
   case WinPSettings.Radio_Harbour.value == DEF_RG_XHARBOUR
      if WinPSettings.Chk_HBVersion.value
         if lAfterOnInit
            MyMsgStop( DBLQT + 'Harbour 3.1 or later' + DBLQT + ' switch only applies to Harbour compiler.' )
         endif
         WinPSettings.Chk_HBVersion.value := .F.
      endif
   otherwise
      if lAfterOnInit
         MyMsgStop( 'No valid PRG compiler is selected.' )
      endif
      if OLD_Radio_Harbour != DEF_RG_HARBOUR .and. OLD_Radio_Harbour != DEF_RG_XHARBOUR
         OLD_Radio_Harbour := DEF_RG_HARBOUR
      endif
      WinPSettings.Radio_Harbour.value := OLD_Radio_Harbour
   endcase

   OLD_Check_64bits      := WinPSettings.Chk_64bits.value
   OLD_Check_StaticBuild := WinPSettings.Check_StaticBuild.value
   OLD_Check_HarbourIs31 := WinPSettings.Chk_HBVersion.value
   OLD_Radio_Cpp         := WinPSettings.Radio_Cpp.value
   OLD_Radio_Harbour     := WinPSettings.Radio_Harbour.value
   OLD_Radio_MiniGui     := WinPSettings.Radio_MiniGui.value

   do case
   case WinPSettings.Radio_MiniGui.value == DEF_RG_MINIGUI1
      SetProperty( 'WinPSettings', 'Radio_Cpp',     'enabled', DEF_RG_BORLAND,  .T. )
      SetProperty( 'WinPSettings', 'Radio_Cpp',     'enabled', DEF_RG_MINGW,    .F. )
      SetProperty( 'WinPSettings', 'Radio_Cpp',     'enabled', DEF_RG_PELLES,   .F. )
      SetProperty( 'WinPSettings', 'Radio_Harbour', 'enabled', DEF_RG_HARBOUR,  .T. )
      SetProperty( 'WinPSettings', 'Radio_Harbour', 'enabled', DEF_RG_XHARBOUR, .T. )
   case WinPSettings.Radio_MiniGui.value == DEF_RG_MINIGUI3
      SetProperty( 'WinPSettings', 'Radio_Cpp',     'enabled', DEF_RG_BORLAND,  .F. )
      SetProperty( 'WinPSettings', 'Radio_Cpp',     'enabled', DEF_RG_MINGW,    .T. )
      SetProperty( 'WinPSettings', 'Radio_Cpp',     'enabled', DEF_RG_PELLES,   .F. )
      SetProperty( 'WinPSettings', 'Radio_Harbour', 'enabled', DEF_RG_HARBOUR,  .T. )
      SetProperty( 'WinPSettings', 'Radio_Harbour', 'enabled', DEF_RG_XHARBOUR, .F. )
   case WinPSettings.Radio_MiniGui.value == DEF_RG_EXTENDED1
      SetProperty( 'WinPSettings', 'Radio_Cpp',     'enabled', DEF_RG_BORLAND,  .T. )
      SetProperty( 'WinPSettings', 'Radio_Cpp',     'enabled', DEF_RG_MINGW,    .T. )
      SetProperty( 'WinPSettings', 'Radio_Cpp',     'enabled', DEF_RG_PELLES,   .T. )
      SetProperty( 'WinPSettings', 'Radio_Harbour', 'enabled', DEF_RG_HARBOUR,  .T. )
      SetProperty( 'WinPSettings', 'Radio_Harbour', 'enabled', DEF_RG_XHARBOUR, .T. )
   case WinPSettings.Radio_MiniGui.value == DEF_RG_OOHG3
      SetProperty( 'WinPSettings', 'Radio_Cpp',     'enabled', DEF_RG_BORLAND,  .T. )
      SetProperty( 'WinPSettings', 'Radio_Cpp',     'enabled', DEF_RG_MINGW,    .T. )
      SetProperty( 'WinPSettings', 'Radio_Cpp',     'enabled', DEF_RG_PELLES,   .T. )
      SetProperty( 'WinPSettings', 'Radio_Harbour', 'enabled', DEF_RG_HARBOUR,  .T. )
      SetProperty( 'WinPSettings', 'Radio_Harbour', 'enabled', DEF_RG_XHARBOUR, .T. )
   endcase
   do case
   case WinPSettings.Radio_Cpp.value == DEF_RG_BORLAND
      SetProperty( 'WinPSettings', 'Chk_64bits',        'enabled', .F. )
      SetProperty( 'WinPSettings', 'Check_StaticBuild', 'enabled', .F. )
   case WinPSettings.Radio_Cpp.value == DEF_RG_MINGW
      SetProperty( 'WinPSettings', 'Chk_64bits',        'enabled', .T. )
      SetProperty( 'WinPSettings', 'Check_StaticBuild', 'enabled', .T. )
   case WinPSettings.Radio_Cpp.value == DEF_RG_PELLES
      SetProperty( 'WinPSettings', 'Chk_64bits',        'enabled', .T. )
      SetProperty( 'WinPSettings', 'Check_StaticBuild', 'enabled', .F. )
   endcase
   do case
   case WinPSettings.Radio_Harbour.value == DEF_RG_HARBOUR
      SetProperty( 'WinPSettings', 'Chk_HBVersion', 'enabled', .T. )
   case WinPSettings.Radio_Harbour.value == DEF_RG_XHARBOUR
      SetProperty( 'WinPSettings', 'Chk_HBVersion', 'enabled', .F. )
   endcase
Return .T.

FUNCTION GetFormTool()
   LOCAL cRet
   DO CASE
   CASE Prj_Radio_FormTool == DEF_RG_EDITOR
      cRet := 'EDITOR'
   CASE Prj_Radio_FormTool == DEF_RG_OOHGIDE
      cRet := 'OOHGIDE'
   CASE Prj_Radio_FormTool == DEF_RG_HMGSIDE
      cRet := 'HMGSIDE'
   CASE Prj_Radio_FormTool == DEF_RG_HMG_IDE
      cRet := 'HMG_IDE'
   OTHERWISE
      cRet := 'EDITOR'
   ENDCASE
RETURN cRet

FUNCTION cDbfTool()
   LOCAL cRet
   IF Prj_Radio_DbfTool == DEF_RG_DBFTOOL
      cRet := 'DBFVIEW'
   ELSE
      cRet := 'OTHER'
   ENDIF
RETURN cRet

FUNCTION cOutputCopyMove()
   LOCAL cRet
   DO CASE
   CASE Prj_Radio_OutputCopyMove == DEF_RG_NONE
      cRet := 'NONE'
   CASE Prj_Radio_OutputCopyMove == DEF_RG_COPY
      cRet := 'COPY'
   CASE Prj_Radio_OutputCopyMove == DEF_RG_MOVE
      cRet := 'MOVE'
   OTHERWISE
      cRet := 'ERROR'
   ENDCASE
RETURN cRet

FUNCTION cOutputRename()
   LOCAL cRet
   DO CASE
   CASE Prj_Radio_OutputRename == DEF_RG_NONE
      cRet := 'NONE'
   CASE Prj_Radio_OutputRename == DEF_RG_NEWNAME
      cRet := 'NEWNAME'
   OTHERWISE
      cRet := 'ERROR'
   ENDCASE
RETURN cRet

FUNCTION cOutputType()
   LOCAL cRet
   DO CASE
   CASE Prj_Radio_OutputType == DEF_RG_EXE
      cRet := 'SRCEXE'
   CASE Prj_Radio_OutputType == DEF_RG_LIB
      cRet := 'SRCLIB'
   CASE Prj_Radio_OutputType == DEF_RG_IMPORT
      cRet := 'DLLLIB'
   OTHERWISE
      cRet := 'ERROR'
   ENDCASE
RETURN cRet

/* eof */
