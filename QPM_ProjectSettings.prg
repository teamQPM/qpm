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

#include 'minigui.ch'
#include 'QPM.ch'

MEMVAR OLD_Check_64bits
MEMVAR OLD_Check_AllowM
MEMVAR OLD_Check_HarbourIs31
MEMVAR OLD_Check_StaticBuild
MEMVAR OLD_Check_Strip
MEMVAR OLD_Radio_Cpp
MEMVAR OLD_Radio_Harbour
MEMVAR OLD_Radio_MiniGui

FUNCTION ProjectSettings()
   LOCAL Folder := '', lAfterOnInit := .F.

   IF Empty( PUB_cProjectFolder )
      MyMsgStop( 'No project is open.' )
      RETURN .F.
   ENDIF

   PRIVATE OLD_Check_64bits      := Prj_Check_64bits
   PRIVATE OLD_Check_AllowM      := Prj_Check_AllowM
   PRIVATE OLD_Check_HarbourIs31 := Prj_Check_HarbourIs31
   PRIVATE OLD_Check_StaticBuild := Prj_Check_StaticBuild
   PRIVATE OLD_Check_Strip       := Prj_Check_Strip
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
   DO CASE
   CASE OLD_Radio_MiniGui == DEF_RG_MINIGUI1
      IF OLD_Radio_Cpp != DEF_RG_BORLAND
         OLD_Radio_Cpp := DEF_RG_BORLAND
      ENDIF
   CASE OLD_Radio_MiniGui == DEF_RG_MINIGUI3
      IF OLD_Radio_Cpp != DEF_RG_MINGW
         OLD_Radio_Cpp := DEF_RG_MINGW
      ENDIF
      IF OLD_Radio_Harbour != DEF_RG_HARBOUR
         OLD_Radio_Harbour := DEF_RG_HARBOUR
      ENDIF
   CASE OLD_Radio_MiniGui == DEF_RG_EXTENDED1
   CASE OLD_Radio_MiniGui == DEF_RG_OOHG3
   OTHERWISE
      OLD_Radio_MiniGui := DEF_RG_OOHG3
   ENDCASE
/* Forbiden combinations:
 *    BORLAND + 64 bits
 *    BORLAND + Non static build
 *    BORLAND + Strip EXE
 *    BORLAND + Allow multiple
 *    PELLES + Non static build
 *    PELLES + Strip EXE
 *    PELLES + Allow multiple
 */
   DO CASE
   CASE OLD_Radio_Cpp == DEF_RG_BORLAND
      IF OLD_Check_64bits
         OLD_Check_64bits := .F.
      ENDIF
      IF ! OLD_Check_StaticBuild
         OLD_Check_StaticBuild := .T.
      ENDIF
      IF OLD_Check_Strip
         OLD_Check_Strip := .F.
      ENDIF
      IF OLD_Check_AllowM
         OLD_Check_AllowM := .F.
      ENDIF
   CASE OLD_Radio_Cpp == DEF_RG_MINGW
   CASE OLD_Radio_Cpp == DEF_RG_PELLES
      IF ! OLD_Check_StaticBuild
         OLD_Check_StaticBuild := .T.
      ENDIF
      IF OLD_Check_Strip
         OLD_Check_Strip := .F.
      ENDIF
      IF OLD_Check_AllowM
         OLD_Check_AllowM := .F.
      ENDIF
   OTHERWISE
      OLD_Radio_Cpp := DEF_RG_MINGW
   ENDCASE
/* Forbiden combinations:
 *    XHARBOUR + 3.1 or upper
 */
   DO CASE
   CASE OLD_Radio_Harbour == DEF_RG_HARBOUR
   CASE OLD_Radio_Harbour == DEF_RG_XHARBOUR
      IF OLD_Check_HarbourIs31
         OLD_Check_HarbourIs31 := .F.
      ENDIF
   OTHERWISE
      OLD_Radio_Cpp := DEF_RG_HARBOUR
   ENDCASE

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

      @ 40, 30 RADIOGROUP Radio_Harbour ;
         OPTIONS { 'Harbour', 'xHarbour' } ;
         VALUE OLD_Radio_Harbour ;
         WIDTH  100 ;
         TOOLTIP 'Select PRG compiler' ;
         ON CHANGE CheckCombination( lAfterOnInit )

      @ 96, 30 CHECKBOX Check_HBVersion ;
         CAPTION 'Harbour 3.1 or later' ;
         WIDTH 130 ;
         HEIGHT 24 ;
         FONT 'arial' SIZE 10 ;
         VALUE OLD_Check_HarbourIs31 ;
         TRANSPARENT

      @ 16, 180 RADIOGROUP Radio_Cpp ;
         OPTIONS { 'BCC32', 'MinGW', 'Pelles' } ;
         VALUE OLD_Radio_Cpp ;
         WIDTH  100 ;
         TOOLTIP 'Select C compiler' ;
         ON CHANGE CheckCombination( lAfterOnInit )

      @ 96, 180 CHECKBOX Check_64Bits ;
         CAPTION '64 bits' ;
         WIDTH 60 ;
         HEIGHT 24 ;
         FONT 'arial' SIZE 10 ;
         VALUE OLD_Check_64bits ;
         TRANSPARENT ;
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
              WIDTH           130
              VALUE           Prj_Check_Console
              TOOLTIP         'Build in console mode using associated (x)Harbour compiler'
      END CHECKBOX

      DEFINE CHECKBOX Check_MT
              CAPTION         'MT Mode'
              ROW             130
              COL             440
              WIDTH           80
              VALUE           Prj_Check_MT
              TOOLTIP         'Use multithread libraries'
      END CHECKBOX

      @ 138, 20 FRAME FOutputType ;
         WIDTH 250 ;
         HEIGHT 160

      @ 143, 30 LABEL LOutputType ;
         VALUE 'Output Type:' ;
         WIDTH 150 ;
         FONT 'arial' SIZE 10 BOLD ;
         FONTCOLOR DEF_COLORBLUE

      @ 165, 30 RADIOGROUP Radio_OutputType ;
         OPTIONS { 'Executable (.EXE)', 'Library (.LIB or .A)', 'DLL Interface Library' } ;
         VALUE Prj_Radio_OutputType ;
         WIDTH 160 ;
         ON CHANGE SwitchRadioOutputType() ;
         TOOLTIP 'Select Output Type'

      DEFINE CHECKBOX Check_StaticBuild
              CAPTION         'Static'
              ROW             165
              COL             200
              WIDTH           60
              VALUE           OLD_Check_StaticBuild
              TOOLTIP         'Link EXE using static libraries'
              ON CHANGE       CheckCombination( lAfterOnInit )
      END CHECKBOX

      DEFINE CHECKBOX Check_OutputPrefix
              CAPTION         'Add Lib'
              ROW             190
              COL             200
              WIDTH           60
              VALUE           Prj_Check_OutputPrefix
              TOOLTIP         'Add ' + DBLQT + 'Lib' + DBLQT + " prefix to Output's filename"
      END CHECKBOX

      DEFINE CHECKBOX Check_Upx
              CAPTION         'UPX'
              ROW             215
              COL             200
              WIDTH           50
              VALUE           Prj_Check_Upx
              TOOLTIP         'Compress EXE using ' + DBLQT + 'Ultimate Packer for eXecutables' + DBLQT + ' -UPX- utility.'
      END CHECKBOX

      DEFINE CHECKBOX Check_Strip
              CAPTION         'Strip EXE'
              ROW             240
              COL             30
              WIDTH           150
              VALUE           Prj_Check_Strip
              TOOLTIP         'Omit all symbol information from the output file.'
              ON CHANGE       CheckCombination( lAfterOnInit )
      END CHECKBOX

      DEFINE CHECKBOX Check_AllowM
              CAPTION         'Allow multiple definitions'
              ROW             265
              COL             30
              WIDTH           155
              VALUE           Prj_Check_AllowM
              TOOLTIP         'Allow multiple definitions of a symbol (first will be used).'
              ON CHANGE       CheckCombination( lAfterOnInit )
      END CHECKBOX

      @ 308, 20 FRAME FOutputCopyMove ;
         WIDTH 250 ;
         HEIGHT 120

      @ 313, 30 LABEL LOutputCopyMove ;
         VALUE 'Output Copy/Move:' ;
         WIDTH 150 ;
         FONT 'arial' SIZE 10 BOLD ;
         FONTCOLOR DEF_COLORBLUE

      @ 340, 30 RADIOGROUP Radio_OutputCopyMove ;
         OPTIONS { 'None', 'Copy', 'Move' } ;
         VALUE Prj_Radio_OutputCopyMove ;
         WIDTH 50 ;
         ON CHANGE SwitchRadioOutputCopyMove() ;
         TOOLTIP 'Select what to do after building'

      DEFINE TEXTBOX Text_CopyMove
              VALUE           Prj_Text_OutputCopyMoveFolder
              ROW             390
              COL             85
              WIDTH           150
              HEIGHT          25
      END TEXTBOX

      DEFINE BUTTON Button_CopyMove
              ROW             390
              COL             240
              WIDTH           25
              HEIGHT          25
              PICTURE         'folderselect'
              TOOLTIP         'Select destination folder for Copy or Move operation'
              ONCLICK         IF ( !Empty( Folder := GetFolder( 'Select Folder', if( empty( WinPSettings.Text_CopyMove.Value ), PUB_cProjectFolder, WinPSettings.Text_CopyMove.Value ) ) ), WinPSettings.Text_CopyMove.Value := Folder, )
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
              COL             440
              WIDTH           80
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
              READONLY        .T.
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

      @ 470, 30 RADIOGROUP Radio_Dbf ;
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
RETURN .T.

FUNCTION ProjectEscape()
   IF ProjectChanged()
      IF MyMsgYesNo( 'Changes will be discarded. Continue?' )
         WinPSettings.release()
      ENDIF
   ELSE
      WinPSettings.release()
   ENDIF
RETURN .T.

FUNCTION ProjectChanged()
   IF Prj_Radio_Harbour             != GetProperty( 'WinPSettings', 'Radio_Harbour', 'Value' )        .OR. ;
      Prj_Check_HarbourIs31         != GetProperty( 'WinPSettings', 'Check_HBVersion', 'Value' )        .OR. ;
      Prj_Check_64bits              != GetProperty( 'WinPSettings', 'Check_64bits', 'Value' )           .OR. ;
      Prj_Radio_Cpp                 != GetProperty( 'WinPSettings', 'Radio_Cpp', 'Value' )            .OR. ;
      Prj_Radio_MiniGui             != GetProperty( 'WinPSettings', 'Radio_MiniGui', 'Value' )        .OR. ;
      Prj_Check_Console             != GetProperty( 'WinPSettings', 'Check_Console', 'Value' )        .OR. ;
      Prj_Check_MT                  != GetProperty( 'WinPSettings', 'Check_MT', 'Value' )             .OR. ;
      Prj_Radio_OutputType          != GetProperty( 'WinPSettings', 'Radio_OutputType', 'Value' )     .OR. ;
      Prj_Radio_OutputCopyMove      != GetProperty( 'WinPSettings', 'Radio_OutputCopyMove', 'Value' ) .OR. ;
      Prj_Text_OutputCopyMoveFolder != GetProperty( 'WinPSettings', 'Text_CopyMove', 'Value' )        .OR. ;
      Prj_Radio_OutputRename        != GetProperty( 'WinPSettings', 'Radio_OutputRename', 'Value' )   .OR. ;
      Prj_Text_OutputRenameNewName  != GetProperty( 'WinPSettings', 'Text_RenameOutput', 'Value' )    .OR. ;
      Prj_Check_OutputSuffix        != GetProperty( 'WinPSettings', 'Check_OutputSuffix', 'Value' )   .OR. ;
      Prj_Check_OutputPrefix        != GetProperty( 'WinPSettings', 'Check_OutputPrefix', 'Value' )   .OR. ;
      Prj_Check_StaticBuild         != GetProperty( 'WinPSettings', 'Check_StaticBuild', 'Value' )    .OR. ;
      Prj_Check_Strip               != GetProperty( 'WinPSettings', 'Check_Strip', 'Value' )          .OR. ;
      Prj_Check_AllowM              != GetProperty( 'WinPSettings', 'Check_AllowM', 'Value' )         .OR. ;
      Prj_Radio_FormTool            != GetProperty( 'WinPSettings', 'Radio_Form', 'Value' )           .OR. ;
      Prj_Radio_DbfTool             != GetProperty( 'WinPSettings', 'Radio_Dbf', 'Value' )            .OR. ;
      Prj_ExtraRunCmdFINAL          != GetProperty( 'WinPSettings', 'Text_ExtraRunCmd', 'Value' )     .OR. ;
      Prj_Check_Upx                 != GetProperty( 'WinPSettings', 'Check_Upx', 'Value' )
      RETURN .T.
   ENDIF
RETURN .F.

FUNCTION ProjectSettingsSave()
   LOCAL i
   LOCAL aCtrls := { 'Radio_OutputType', ;
                     'Radio_OutputCopyMove', ;
                     'Text_CopyMove', ;
                     'Radio_OutputRename', ;
                     'Text_RenameOutput', ;
                     'Check_OutputSuffix', ;
                     'Check_OutputPrefix', ;
                     'Check_StaticBuild', ;
                     'Radio_Form', ;
                     'Radio_Dbf', ;
                     'Text_ExtraRunCmd', ;
                     'Check_Upx', ;
                     'Radio_Harbour', ;
                     'Check_HBVersion', ;
                     'Check_64bits', ;
                     'Check_AllowM', ;
                     'Check_Strip', ;
                     'Check_StaticBuild', ;
                     'Radio_Cpp', ;
                     'Radio_MiniGui', ;
                     'Check_Console', ;
                     'Check_MT', ;
                     'Radio_OutputType' }

   IF ! _IsWindowDefined( 'WinPSettings' )
      MyMsgStop( "WinPSettings not defined!" + hb_osNewLine() + "Exit QPM and retry." )
      RETURN .F.
   ENDIF
   FOR i := 1 TO Len( aCtrls )
      IF ! _IsControlDefined ( aCtrls[i], 'WinPSettings' )
         MyMsgStop( aCtrls[i] + " not defined!" + hb_osNewLine() + "Exit QPM and retry." )
         RETURN .F.
      ENDIF
   NEXT i

   DO CASE
   CASE GetProperty( 'WinPSettings', 'Radio_OutputType', 'Value' ) < DEF_RG_IMPORT .AND. ;
        GetProperty( 'VentanaMain', 'GPrgFiles', 'ItemCount' ) == 1 .AND. ;
        ( Upper( US_FileNameOnlyExt( GetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', 1, NCOLPRGNAME ) ) ) == 'DLL' .OR. ;
          Upper( US_FileNameOnlyExt( GetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', 1, NCOLPRGNAME ) ) ) == 'LIB' .OR. ;
          Upper( US_FileNameOnlyExt( GetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', 1, NCOLPRGNAME ) ) ) == 'A' )
      MyMsgStop( 'Output types ' + DBLQT + 'Executable' + DBLQT + ' and ' + DBLQT + 'Library' + DBLQT + ' do not support ' + DBLQT + 'DLL' + DBLQT + ', ' + DBLQT + 'LIB' + DBLQT + ' or ' + DBLQT + 'A' + DBLQT + ' into source list.' + hb_osNewLine() + ;
               'Remove those files before changing the ' + DBLQT + 'Output Type' + DBLQT + '.' )
      RETURN .F.
   CASE GetProperty( 'WinPSettings', 'Radio_OutputType', 'Value' ) == DEF_RG_IMPORT .AND. ;
        GetProperty( 'VentanaMain', 'GPrgFiles', 'ItemCount' ) == 1 .AND. ;
        ( Upper( US_FileNameOnlyExt( GetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', 1, NCOLPRGNAME ) ) ) == 'PRG' .OR. ;
          Upper( US_FileNameOnlyExt( GetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', 1, NCOLPRGNAME ) ) ) == 'C' .OR. ;
          Upper( US_FileNameOnlyExt( GetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', 1, NCOLPRGNAME ) ) ) == 'CPP' )
      MyMsgStop( 'Output type ' + DBLQT + 'Interface Library' + DBLQT + ' does not support ' + DBLQT + 'PRG' + DBLQT + ', ' + DBLQT + 'C' + DBLQT + ' or ' + DBLQT + 'CPP' + DBLQT + ' into source list.' + hb_osNewLine() + ;
               'Remove those files before changing the ' + DBLQT + 'Output Type' + DBLQT + '.' )
      RETURN .F.
   CASE GetProperty( 'WinPSettings', 'Radio_OutputType', 'Value' ) == DEF_RG_IMPORT .AND. ;
        GetProperty( 'VentanaMain', 'GPrgFiles', 'ItemCount' ) > 1
      MyMsgStop( 'Output type ' + DBLQT + 'Interface Library' + DBLQT + ' does not support ' + DBLQT + 'PRG' + DBLQT + ', ' + DBLQT + 'C' + DBLQT + ' or ' + DBLQT + 'CPP' + DBLQT + ' into source list.' + hb_osNewLine() + ;
               'Remove those files before changing the ' + DBLQT + 'Output Type' + DBLQT + '.' )
      RETURN .F.
   ENDCASE

   Prj_Radio_OutputCopyMove      := GetProperty( 'WinPSettings', 'Radio_OutputCopyMove', 'Value' )
   Prj_Text_OutputCopyMoveFolder := GetProperty( 'WinPSettings', 'Text_CopyMove', 'Value' )
   Prj_Radio_OutputRename        := GetProperty( 'WinPSettings', 'Radio_OutputRename', 'Value' )
   Prj_Text_OutputRenameNewName  := GetProperty( 'WinPSettings', 'Text_RenameOutput', 'Value' )
   Prj_Check_OutputSuffix        := GetProperty( 'WinPSettings', 'Check_OutputSuffix', 'Value' )
   Prj_Check_OutputPrefix        := GetProperty( 'WinPSettings', 'Check_OutputPrefix', 'Value' )
   Prj_Check_StaticBuild         := GetProperty( 'WinPSettings', 'Check_StaticBuild', 'Value' )
   Prj_Check_Strip               := GetProperty( 'WinPSettings', 'Check_Strip', 'Value' )
   Prj_Check_AllowM              := GetProperty( 'WinPSettings', 'Check_AllowM', 'Value' )
   Prj_Radio_FormTool            := GetProperty( 'WinPSettings', 'Radio_Form', 'Value' )
   Prj_Radio_DbfTool             := GetProperty( 'WinPSettings', 'Radio_Dbf', 'Value' )
   Prj_ExtraRunCmdFINAL          := GetProperty( 'WinPSettings', 'Text_ExtraRunCmd', 'Value' )
   Prj_Check_Upx                 := GetProperty( 'WinPSettings', 'Check_Upx', 'Value' )

   IF Prj_Radio_Harbour     != GetProperty( 'WinPSettings', 'Radio_Harbour', 'Value' )    .OR. ;
      Prj_Check_HarbourIs31 != GetProperty( 'WinPSettings', 'Check_HBVersion', 'Value' )    .OR. ;
      Prj_Check_64bits      != GetProperty( 'WinPSettings', 'Check_64bits', 'Value' )       .OR. ;
      Prj_Radio_Cpp         != GetProperty( 'WinPSettings', 'Radio_Cpp', 'Value' )        .OR. ;
      Prj_Radio_MiniGui     != GetProperty( 'WinPSettings', 'Radio_MiniGui', 'Value' )    .OR. ;
      Prj_Check_Console     != GetProperty( 'WinPSettings', 'Check_Console', 'Value' )    .OR. ;
      Prj_Check_MT          != GetProperty( 'WinPSettings', 'Check_MT', 'Value' )         .OR. ;
      Prj_Radio_OutputType  != GetProperty( 'WinPSettings', 'Radio_OutputType', 'Value' )

      IF ! Empty( LibsActiva )
         DescargoDefaultLibs( LibsActiva )
         DescargoIncludeLibs( LibsActiva )
         DescargoExcludeLibs( LibsActiva )
      ENDIF

      Prj_Radio_Harbour     := GetProperty( 'WinPSettings', 'Radio_Harbour', 'Value' )
      Prj_Check_HarbourIs31 := GetProperty( 'WinPSettings', 'Check_HBVersion', 'Value' )
      Prj_Check_64bits      := GetProperty( 'WinPSettings', 'Check_64bits', 'Value' )
      Prj_Radio_Cpp         := GetProperty( 'WinPSettings', 'Radio_Cpp', 'Value' )
      Prj_Radio_MiniGui     := GetProperty( 'WinPSettings', 'Radio_MiniGui', 'Value' )
      Prj_Check_Console     := GetProperty( 'WinPSettings', 'Check_Console', 'Value' )
      Prj_Check_MT          := GetProperty( 'WinPSettings', 'Check_MT', 'Value' )
      Prj_Radio_OutputType  := GetProperty( 'WinPSettings', 'Radio_OutputType', 'Value' )

      QPM_InitLibrariesForFlavor( GetSuffix() )
      CargoDefaultLibs( GetSuffix() )
      CargoIncludeLibs( GetSuffix() )
      CargoExcludeLibs( GetSuffix() )

      QPM_SetResumen()
   ENDIF

   ActOutputTypeSet()
   ActLibReimp()
   CambioTitulo()

   WinPSettings.Release()
RETURN .T.

FUNCTION SwitchRadioOutputCopyMove()
   DO CASE
   CASE WinPSettings.Radio_OutputCopyMove.value == 1
      WinPSettings.Text_CopyMove.Enabled := .F.
      WinPSettings.Button_CopyMove.Enabled := .F.
   CASE WinPSettings.Radio_OutputCopyMove.value == 2
      WinPSettings.Text_CopyMove.Enabled := .T.
      WinPSettings.Button_CopyMove.Enabled := .T.
   CASE WinPSettings.Radio_OutputCopyMove.value == 3
      WinPSettings.Text_CopyMove.Enabled := .T.
      WinPSettings.Button_CopyMove.Enabled := .T.
   ENDCASE
RETURN .T.

FUNCTION SwitchRadioOutputRename()
   DO CASE
   CASE WinPSettings.Radio_OutputRename.value == 1
      WinPSettings.Text_RenameOutput.Enabled := .F.
   CASE WinPSettings.Radio_OutputRename.value == 2
      WinPSettings.Text_RenameOutput.Enabled := .T.
   ENDCASE
RETURN .T.

FUNCTION SwitchRadioOutputType()
   IF GetProperty( 'WinPSettings', 'Radio_OutputType', 'Value' ) < DEF_RG_IMPORT
      WinPSettings.Check_Console.Enabled := .T.
      WinPSettings.Radio_Harbour.Enabled := .T.
   ELSE
      WinPSettings.Check_Console.Enabled := .F.
      WinPSettings.Radio_Harbour.Enabled := .F.
   ENDIF
RETURN .T.

FUNCTION CheckCombination( lAfterOnInit )
/*
 * Forbiden combinations:
 *
 *    MINIGUI1  + MINGW
 *    MINIGUI1  + PELLES
 *    MINIGUI3  + BORLAND
 *    MINIGUI3  + PELLES
 *    MINIGUI3  + XHARBOUR
 */
   DO CASE
   CASE WinPSettings.Radio_MiniGui.value == DEF_RG_MINIGUI1
      IF WinPSettings.Radio_Cpp.value != DEF_RG_BORLAND
         IF lAfterOnInit
            MyMsgStop( 'The selected C compiler is not valid for the selected MiniGui.' )
         ENDIF
         IF OLD_Radio_Cpp != DEF_RG_BORLAND
            OLD_Radio_Cpp := DEF_RG_BORLAND
         ENDIF
         WinPSettings.Radio_Cpp.value := OLD_Radio_Cpp
      ENDIF
   CASE WinPSettings.Radio_MiniGui.value == DEF_RG_MINIGUI3
      IF WinPSettings.Radio_Cpp.value != DEF_RG_MINGW
         IF lAfterOnInit
            MyMsgStop( 'The selected C compiler is not valid for the selected MiniGui.' )
         ENDIF
         IF OLD_Radio_Cpp != DEF_RG_MINGW
            OLD_Radio_Cpp := DEF_RG_MINGW
         ENDIF
         WinPSettings.Radio_Cpp.value := OLD_Radio_Cpp
      ENDIF
      IF WinPSettings.Radio_Harbour.value != DEF_RG_HARBOUR
         IF lAfterOnInit
            MyMsgStop( 'The selected PRG compiler is not valid for the selected MiniGui.' )
         ENDIF
         IF OLD_Radio_Harbour != DEF_RG_HARBOUR
            OLD_Radio_Harbour := DEF_RG_HARBOUR
         ENDIF
         WinPSettings.Radio_Harbour.value := OLD_Radio_Harbour
      ENDIF
   CASE WinPSettings.Radio_MiniGui.value == DEF_RG_EXTENDED1
   CASE WinPSettings.Radio_MiniGui.value == DEF_RG_OOHG3
   OTHERWISE
      IF lAfterOnInit
         MyMsgStop( 'No valid MiniGui is selected.' )
      ENDIF
      IF OLD_Radio_MiniGui != DEF_RG_MINIGUI1 .AND. OLD_Radio_MiniGui != DEF_RG_MINIGUI3 .AND. OLD_Radio_MiniGui != DEF_RG_EXTENDED1 .AND. OLD_Radio_MiniGui != DEF_RG_OOHG3
         OLD_Radio_MiniGui := DEF_RG_OOHG3
      ENDIF
      WinPSettings.Radio_MiniGui.value := OLD_Radio_MiniGui
   ENDCASE
/* Forbiden combinations:
 *    BORLAND + 64 bits
 *    BORLAND + Non static build
 *    BORLAND + Strip EXE
 *    BORLAND + Allow multiple
 *    PELLES + Non static build
 *    PELLES + Strip EXE
 *    PELLES + Allow multiple
 */
   DO CASE
   CASE WinPSettings.Radio_Cpp.value == DEF_RG_BORLAND
      OLD_Check_64bits := .F.
      IF WinPSettings.Check_64bits.value
         IF lAfterOnInit
            MyMsgStop( DBLQT + '64 bits' + DBLQT + ' switch only applies to MinGW and Pelles compilers.' )
         ENDIF
         WinPSettings.Check_64bits.value := .F.
      ENDIF
      OLD_Check_StaticBuild := .T.
      IF ! WinPSettings.Check_StaticBuild.value
         IF lAfterOnInit
            MyMsgStop( DBLQT + 'Static' + DBLQT + ' switch must be set for Borland and Pelles compilers.' )
         ENDIF
         WinPSettings.Check_StaticBuild.value := .T.
      ENDIF
      OLD_Check_Strip := .F.
      IF WinPSettings.Check_Strip.value
         IF lAfterOnInit
            MyMsgStop( DBLQT + 'Strip EXE' + DBLQT + ' switch only applies to MinGW compiler.' )
         ENDIF
         WinPSettings.Check_Strip.value := .F.
      ENDIF
      OLD_Check_AllowM := .F.
      IF WinPSettings.Check_AllowM.value
         IF lAfterOnInit
            MyMsgStop( DBLQT + 'Allow multiple definitions' + DBLQT + ' switch only applies to MinGW compiler.' )
         ENDIF
         WinPSettings.Check_AllowM.value := .F.
      ENDIF
   CASE WinPSettings.Radio_Cpp.value == DEF_RG_MINGW
   CASE WinPSettings.Radio_Cpp.value == DEF_RG_PELLES
      OLD_Check_StaticBuild := .T.
      IF ! WinPSettings.Check_StaticBuild.value
         IF lAfterOnInit
            MyMsgStop( DBLQT + 'Static' + DBLQT + ' switch must be set for Borland and Pelles compilers.' )
         ENDIF
         WinPSettings.Check_StaticBuild.value := .T.
      ENDIF
      OLD_Check_Strip := .F.
      IF WinPSettings.Check_Strip.value
         IF lAfterOnInit
            MyMsgStop( DBLQT + 'Strip EXE' + DBLQT + ' switch only applies to MinGW compiler.' )
         ENDIF
         WinPSettings.Check_Strip.value := .F.
      ENDIF
      OLD_Check_AllowM := .F.
      IF WinPSettings.Check_AllowM.value
         IF lAfterOnInit
            MyMsgStop( DBLQT + 'Allow multiple definitions' + DBLQT + ' switch only applies to MinGW compiler.' )
         ENDIF
         WinPSettings.Check_AllowM.value := .F.
      ENDIF
   OTHERWISE
      IF lAfterOnInit
         MyMsgStop( 'No valid C compiler is selected.' )
      ENDIF
      DO CASE
      CASE WinPSettings.Radio_MiniGui.value == DEF_RG_MINIGUI1
         OLD_Radio_Cpp := DEF_RG_BORLAND
      CASE WinPSettings.Radio_MiniGui.value == DEF_RG_MINIGUI3
         OLD_Radio_Cpp := DEF_RG_MINGW
      CASE WinPSettings.Radio_MiniGui.value == DEF_RG_EXTENDED1
         IF OLD_Radio_Cpp != DEF_RG_MINGW .AND. OLD_Radio_Cpp != DEF_RG_BORLAND
            IF WinPSettings.Check_64bits.value
               OLD_Radio_Cpp := DEF_RG_MINGW
            ELSE
               OLD_Radio_Cpp := DEF_RG_BORLAND
            ENDIF
         ENDIF
      CASE WinPSettings.Radio_MiniGui.value == DEF_RG_OOHG3
         IF OLD_Radio_Cpp != DEF_RG_MINGW .AND. OLD_Radio_Cpp != DEF_RG_BORLAND .AND. OLD_Radio_Cpp != DEF_RG_PELLES
            OLD_Radio_Cpp := DEF_RG_MINGW
         ENDIF
      ENDCASE
      WinPSettings.Radio_Cpp.value := OLD_Radio_Cpp
   ENDCASE
/* Forbiden combinations:
 *    XHARBOUR + 3.1 or upper
 */
   DO CASE
   CASE WinPSettings.Radio_Harbour.value == DEF_RG_HARBOUR
   CASE WinPSettings.Radio_Harbour.value == DEF_RG_XHARBOUR
      IF WinPSettings.Check_HBVersion.value
         IF lAfterOnInit
            MyMsgStop( DBLQT + 'Harbour 3.1 or later' + DBLQT + ' switch only applies to Harbour compiler.' )
         ENDIF
         WinPSettings.Check_HBVersion.value := .F.
      ENDIF
   OTHERWISE
      IF lAfterOnInit
         MyMsgStop( 'No valid PRG compiler is selected.' )
      ENDIF
      IF OLD_Radio_Harbour != DEF_RG_HARBOUR .AND. OLD_Radio_Harbour != DEF_RG_XHARBOUR
         OLD_Radio_Harbour := DEF_RG_HARBOUR
      ENDIF
      WinPSettings.Radio_Harbour.value := OLD_Radio_Harbour
   ENDCASE

   OLD_Check_64bits      := WinPSettings.Check_64bits.value
   OLD_Check_AllowM      := WinPSettings.Check_AllowM.value
   OLD_Check_HarbourIs31 := WinPSettings.Check_HBVersion.value
   OLD_Check_StaticBuild := WinPSettings.Check_StaticBuild.value
   OLD_Check_Strip       := WinPSettings.Check_Strip.value
   OLD_Radio_Cpp         := WinPSettings.Radio_Cpp.value
   OLD_Radio_Harbour     := WinPSettings.Radio_Harbour.value
   OLD_Radio_MiniGui     := WinPSettings.Radio_MiniGui.value

   DO CASE
   CASE WinPSettings.Radio_MiniGui.value == DEF_RG_MINIGUI1
      SetProperty( 'WinPSettings', 'Radio_Cpp',     'enabled', DEF_RG_BORLAND,  .T. )
      SetProperty( 'WinPSettings', 'Radio_Cpp',     'enabled', DEF_RG_MINGW,    .F. )
      SetProperty( 'WinPSettings', 'Radio_Cpp',     'enabled', DEF_RG_PELLES,   .F. )
      SetProperty( 'WinPSettings', 'Radio_Harbour', 'enabled', DEF_RG_HARBOUR,  .T. )
      SetProperty( 'WinPSettings', 'Radio_Harbour', 'enabled', DEF_RG_XHARBOUR, .T. )
   CASE WinPSettings.Radio_MiniGui.value == DEF_RG_MINIGUI3
      SetProperty( 'WinPSettings', 'Radio_Cpp',     'enabled', DEF_RG_BORLAND,  .F. )
      SetProperty( 'WinPSettings', 'Radio_Cpp',     'enabled', DEF_RG_MINGW,    .T. )
      SetProperty( 'WinPSettings', 'Radio_Cpp',     'enabled', DEF_RG_PELLES,   .F. )
      SetProperty( 'WinPSettings', 'Radio_Harbour', 'enabled', DEF_RG_HARBOUR,  .T. )
      SetProperty( 'WinPSettings', 'Radio_Harbour', 'enabled', DEF_RG_XHARBOUR, .F. )
   CASE WinPSettings.Radio_MiniGui.value == DEF_RG_EXTENDED1
      SetProperty( 'WinPSettings', 'Radio_Cpp',     'enabled', DEF_RG_BORLAND,  .T. )
      SetProperty( 'WinPSettings', 'Radio_Cpp',     'enabled', DEF_RG_MINGW,    .T. )
      SetProperty( 'WinPSettings', 'Radio_Cpp',     'enabled', DEF_RG_PELLES,   .T. )
      SetProperty( 'WinPSettings', 'Radio_Harbour', 'enabled', DEF_RG_HARBOUR,  .T. )
      SetProperty( 'WinPSettings', 'Radio_Harbour', 'enabled', DEF_RG_XHARBOUR, .T. )
   CASE WinPSettings.Radio_MiniGui.value == DEF_RG_OOHG3
      SetProperty( 'WinPSettings', 'Radio_Cpp',     'enabled', DEF_RG_BORLAND,  .T. )
      SetProperty( 'WinPSettings', 'Radio_Cpp',     'enabled', DEF_RG_MINGW,    .T. )
      SetProperty( 'WinPSettings', 'Radio_Cpp',     'enabled', DEF_RG_PELLES,   .T. )
      SetProperty( 'WinPSettings', 'Radio_Harbour', 'enabled', DEF_RG_HARBOUR,  .T. )
      SetProperty( 'WinPSettings', 'Radio_Harbour', 'enabled', DEF_RG_XHARBOUR, .T. )
   ENDCASE
   DO CASE
   CASE WinPSettings.Radio_Cpp.value == DEF_RG_BORLAND
      SetProperty( 'WinPSettings', 'Check_64bits',      'enabled', .F. )
      SetProperty( 'WinPSettings', 'Check_AllowM',      'enabled', .F. )
      SetProperty( 'WinPSettings', 'Check_StaticBuild', 'enabled', .F. )
      SetProperty( 'WinPSettings', 'Check_Strip',       'enabled', .F. )
   CASE WinPSettings.Radio_Cpp.value == DEF_RG_MINGW
      SetProperty( 'WinPSettings', 'Check_64bits',      'enabled', .T. )
      SetProperty( 'WinPSettings', 'Check_AllowM',      'enabled', .T. )
      SetProperty( 'WinPSettings', 'Check_StaticBuild', 'enabled', .T. )
      SetProperty( 'WinPSettings', 'Check_Strip',       'enabled', .T. )
   CASE WinPSettings.Radio_Cpp.value == DEF_RG_PELLES
      SetProperty( 'WinPSettings', 'Check_64bits',      'enabled', .T. )
      SetProperty( 'WinPSettings', 'Check_AllowM',      'enabled', .F. )
      SetProperty( 'WinPSettings', 'Check_StaticBuild', 'enabled', .F. )
      SetProperty( 'WinPSettings', 'Check_Strip',       'enabled', .F. )
   ENDCASE
   DO CASE
   CASE WinPSettings.Radio_Harbour.value == DEF_RG_HARBOUR
      SetProperty( 'WinPSettings', 'Check_HBVersion', 'enabled', .T. )
   CASE WinPSettings.Radio_Harbour.value == DEF_RG_XHARBOUR
      SetProperty( 'WinPSettings', 'Check_HBVersion', 'enabled', .F. )
   ENDCASE
RETURN .T.

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
