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
#include <QPM.ch>

Function ProjectSettings()
   Local Folder:=""
   Private OLD_Radio_Harbour     := Prj_Radio_Harbour
   Private OLD_Check_HarbourIs31 := Prj_Check_HarbourIs31
   Private OLD_Radio_Cpp         := Prj_Radio_Cpp
   Private OLD_Radio_MiniGui     := Prj_Radio_MiniGui

   if Empty ( PUB_cProjectFolder )
      MsgStop('You must open project first')
      Return .F.
   EndIf

   DEFINE WINDOW WinPSettings ;
          AT 0 , 0 ;
          WIDTH 560 ;
          HEIGHT 610 ;
          TITLE "Project Options" ;
          MODAL ;
          NOSYSMENU ;
          ON INIT WinPSettingsInit() ;
          ON INTERACTIVECLOSE US_NOP()

      @ 08 , 35 FRAME FCompiler ;
         WIDTH 230 ;
         HEIGHT 120

      @ 13 , 40 LABEL LCompiler ;
         VALUE 'Compilers:' ;
         WIDTH 110 ;
         FONT 'arial' SIZE 10 BOLD ;
         FONTCOLOR DEF_COLORBLUE

    //DEFINE LABEL Label_34
    //        ROW             70
    //        COL             10
    //        VALUE           'xHarbour MultiThread:'
    //END LABEL
      @ 40 , 50 RADIOGROUP Radio_Harbour ;
         OPTIONS { 'Harbour' , 'xHarbour' } ;
         VALUE Prj_Radio_Harbour ;
         WIDTH  100 ;
         TOOLTIP "Select Compiler" ;
         ON CHANGE CheckCombinationRadio("H")

      @ 96 , 50 CHECKBOX Chk_HBVersion ;
         CAPTION "Harbour 3.1 or later: " ;
         WIDTH 150 ;
         HEIGHT 24 ;
         FONT 'arial' SIZE 10 ;
         VALUE Prj_Check_HarbourIs31 ;
         TRANSPARENT ;
         LEFTJUSTIFY

    //DEFINE CHECKBOX Check_34
    //        ROW             70
    //        COL             180
    //        VALUE           Prj_Check_34
    //END CHECKBOX

      @ 16 , 155 RADIOGROUP Radio_Cpp ;
         OPTIONS { 'BorlandC' , 'MinGW' , 'PellesC' } ;
         VALUE Prj_Radio_Cpp ;
         WIDTH  100 ;
         TOOLTIP "Select Compiler" ;
         ON CHANGE CheckCombinationRadio("C")

      @ 08 , 285 FRAME FMinigui ;
         WIDTH 230 ;
         HEIGHT 155

      @ 13 , 290 LABEL LMinigui ;
         VALUE 'GUI Library:' ;
         WIDTH 275 ;
         FONT 'arial' SIZE 10 BOLD ;
         FONTCOLOR DEF_COLORBLUE

      @ 30 , 300 RADIOGROUP Radio_MiniGui ;
         OPTIONS { 'MiniGUI Oficial 1.x' , 'MiniGUI Oficial 3.x' , 'MiniGUI Extended 1.x or later' , 'Object Oriented Harbour GUI 3.x' } ;
         VALUE Prj_Radio_MiniGui ;
         WIDTH 200 ;
         TOOLTIP "Select GUI Library Version" ;
         ON CHANGE CheckCombinationRadio("M")

      DEFINE CHECKBOX Check_Console
              CAPTION         "Console Mode"
              ROW             130
              COL             300
              WIDTH           200
              VALUE           Prj_Check_Console
              TOOLTIP "Compile Modo Console with (x)Harbour associated to Minigui Version"
      END CHECKBOX
          //  ON CHANGE       ActConsoleMode()

      @ 138 , 35 FRAME FOutputType ;
         WIDTH 230 ;
         HEIGHT 120

      @ 143 , 40 LABEL LOutputType ;
         VALUE 'Output Type:' ;
         WIDTH 150 ;
         FONT 'arial' SIZE 10 BOLD ;
         FONTCOLOR DEF_COLORBLUE

       //OPTIONS { 'Executable (.EXE)' , 'Library (.LIB or .A)' , 'Dynamic Library (.DLL) (only C)' } ;
      @ 170 , 50 RADIOGROUP Radio_OutputType ;
         OPTIONS { 'Executable (.EXE)' , 'Library (.LIB or .A)' , 'Interface Library (for DLL)' } ;
         VALUE Prj_Radio_OutputType ;
         WIDTH 160 ;
         ON CHANGE ( PrjSetColor() , HabilitoRadioSegunType() ) ;
         TOOLTIP "Select Output Type"

      DEFINE CHECKBOX Check_Upx
              CAPTION         "UPX"
              ROW             170
              COL             210
              WIDTH           50
              VALUE           Prj_Check_Upx
              TOOLTIP "Compress EXE with UPX utility.  Look at link menu for home page of UPX project"
      END CHECKBOX

      @ 268 , 35 FRAME FOutputCopyMove ;
         WIDTH 230 ;
         HEIGHT 160

      @ 273 , 40 LABEL LOutputCopyMove ;
         VALUE 'Output Copy/Move:' ;
         WIDTH 150 ;
         FONT 'arial' SIZE 10 BOLD ;
         FONTCOLOR DEF_COLORBLUE

      @ 300 , 50 RADIOGROUP Radio_OutputCopyMove ;
         OPTIONS { 'None' , 'Copy to...' , 'Move to...' } ;
         VALUE Prj_Radio_OutputCopyMove ;
         WIDTH 120 ;
         ON CHANGE SwitchRadioOutputCopyMove() ;
         TOOLTIP "Select Output Extra Options"

 //   DEFINE LABEL Label_CopyMove
 //           VALUE           'Copy / Move Folder:'
 //           ROW             330
 //           COL              50
 //           AUTOSIZE        .T.
 //   END LABEL
      DEFINE TEXTBOX Text_CopyMove
              VALUE           Prj_Text_OutputCopyMoveFolder
              ROW             390
              COL              50
              WIDTH           150
      END TEXTBOX
      DEFINE BUTTON Button_CopyMove
              ROW             390
              COL             210
              WIDTH           25
              HEIGHT          25
              PICTURE         'folderselect'
              TOOLTIP         'Select Folder for Copy or Move output file'
              ONCLICK         If ( !Empty( Folder := GetFolder( "Select Folder" , if( empty( WinPSettings.Text_CopyMove.Value ) , PUB_cProjectFolder , WinPSettings.Text_CopyMove.Value ) ) ) , WinPSettings.Text_CopyMove.Value := Folder , )
      END BUTTON

      @ 168 , 285 FRAME FOutputRename ;
         WIDTH 230 ;
         HEIGHT 150

      @ 173 , 290 LABEL LOutputRename ;
         VALUE 'Output Rename:' ;
         WIDTH 150 ;
         FONT 'arial' SIZE 10 BOLD ;
         FONTCOLOR DEF_COLORBLUE

      @ 190 , 300 RADIOGROUP Radio_OutputRename ;
         OPTIONS { 'None' , 'Rename to ...' } ;
         VALUE Prj_Radio_OutputRename ;
         WIDTH 160 ;
         ON CHANGE SwitchRadioOutputRename() ;
         TOOLTIP "Select Output Extra Options"

      DEFINE TEXTBOX Text_RenameOutput
              VALUE           Prj_Text_OutputRenameNewName
              ROW             250
              COL             300
              WIDTH           150
      END TEXTBOX

      DEFINE CHECKBOX Check_OutputSuffix
              CAPTION         'Add Automatic Suffix'
              ROW             280
              COL             300
              WIDTH           150
              VALUE           Prj_Check_OutputSuffix
              TOOLTIP "Add automatic Suffix identifier of harbour and minigui version to Output File"
      END CHECKBOX

      @ 325 , 285 FRAME FExtraRun ;
         WIDTH 230 ;
         HEIGHT 070

      @ 330 , 290 LABEL LExtraRun ;
         VALUE 'Extra Run After Successful Build:' ;
         WIDTH 350 ;
         FONT 'arial' SIZE 10 BOLD ;
         FONTCOLOR DEF_COLORBLUE

      DEFINE TEXTBOX Text_ExtraRunCmd
              VALUE           Prj_ExtraRunCmdFINAL
              ROW             360
              COL             300
              WIDTH           150
              READONLY        .T.
      END TEXTBOX
      DEFINE BUTTON Button_ExtraRun
              ROW             360
              COL             460
              WIDTH           25
              HEIGHT          25
              PICTURE         'folderselect'
              TOOLTIP         'Select Process for Extra Run'
              ONCLICK         QPM_GetExtraRun()
      END BUTTON

   // @ 385 , 35 FRAME FUpx ;
   //    WIDTH 450 ;
   //    HEIGHT 40

      @ 438 , 35 FRAME FDbf ;
         WIDTH 230 ;
         HEIGHT 90

      @ 443 , 40 LABEL LDbf ;
         VALUE "Tool to Modify DBFs:" ;
         WIDTH 275 ;
         FONT 'arial' SIZE 10 BOLD ;
         FONTCOLOR DEF_COLORBLUE

   //\\  OPTIONS { 'DbfView (by Grigory Filatov)' , 'DBU (by S. Rathinagiri)' , 'User Defined' } ;
      @ 470 , 50 RADIOGROUP Radio_Dbf ;
         OPTIONS { 'DbfView (by Grigory Filatov)' , 'User Defined' } ;
         VALUE Prj_Radio_DbfTool ;
         WIDTH 200

      @ 408 , 285 FRAME FForm ;
         WIDTH 230 ;
         HEIGHT 120

      @ 413 , 290 LABEL LForm ;
         VALUE 'Tool to Modify Forms:' ;
         WIDTH 275 ;
         FONT 'arial' SIZE 10 BOLD ;
         FONTCOLOR DEF_COLORBLUE

    //@ 410 , 300 RADIOGROUP Radio_Form ;
      @ 440 , 300 RADIOGROUP Radio_Form ;
         OPTIONS { 'Automatic' , 'ooHG IDE+ (by Ciro Vargas)' , 'HMGS-IDE (by Walter Formigoni)' } ;
         VALUE Prj_Radio_FormTool ;
         WIDTH 200

      DEFINE BUTTON B_OK
             ROW             538
             COL             180
             WIDTH           80
             HEIGHT          25
             CAPTION         'OK'
             TOOLTIP         'Confirm Changes'
             ONCLICK         if( ChequeoOutput() , ( ProjectSettingsSave() , WinPSettings.Release() ) , US_Nop() )
      END BUTTON

      DEFINE BUTTON B_CANCEL
             ROW             538
             COL             290
             WIDTH           80
             HEIGHT          25
             CAPTION         'Cancel'
             TOOLTIP         'Cancel Changes'
             ONCLICK         WinPSettings.Release()
      END BUTTON

   END WINDOW

   ON KEY ESCAPE OF WinPSettings ACTION ProjectEscape()

   CENTER   WINDOW WinPSettings

   HabilitoRadioSegunType()

   ActRadioCpp( GetProperty( "WinPSettings" , "Radio_MiniGui" , "value" ) , GetProperty( "WinPSettings" , "Radio_Cpp"     , "value" ) , GetProperty( "WinPSettings" , "Radio_Harbour" , "value" ) )

   ACTIVATE WINDOW WinPSettings

   QPM_SetColor()

Return .T.

Function ProjectEscape()
   if ProjectChanged()
      if MyMsgYesNo('Do you want to cancel the changes ?')
         WinPSettings.release()
      endif
   else
      WinPSettings.release()
   endif
// ON KEY ESCAPE OF WinPSettings ACTION ( if( MyMsgYesNo('Do you want to cancel the changes ?') , WinPSettings.release() , ) )
Return .T.

Function ProjectChanged()
   if Prj_Radio_Harbour             != WinPSettings.Radio_Harbour.value        .or. ;
      Prj_Check_HarbourIs31         != WinPSettings.Chk_HBVersion.value        .or. ;
      Prj_Radio_Cpp                 != WinPSettings.Radio_Cpp.value            .or. ;
      Prj_Radio_MiniGui             != WinPSettings.Radio_MiniGui.value        .or. ;
      Prj_Radio_OutputType          != WinPSettings.Radio_OutputType.value     .or. ;
      Prj_Radio_OutputCopyMove      != WinPSettings.Radio_OutputCopyMove.value .or. ;
      Prj_Text_OutputCopyMoveFolder != WinPSettings.Text_CopyMove.value        .or. ;
      Prj_Radio_OutputRename        != WinPSettings.Radio_OutputRename.value   .or. ;
      Prj_Text_OutputRenameNewName  != WinPSettings.Text_RenameOutput.value    .or. ;
      Prj_Check_OutputSuffix        != WinPSettings.Check_OutputSuffix.value   .or. ;
      Prj_Radio_FormTool            != WinPSettings.Radio_Form.value           .or. ;
      Prj_Radio_DbfTool             != WinPSettings.Radio_Dbf.value            .or. ;
      Prj_Check_Console             != WinPSettings.Check_Console.value        .or. ;
      Prj_ExtraRunCmdFINAL          != WinPSettings.Text_ExtraRunCmd.value     .or. ;
      Prj_Check_Upx                 != WinPSettings.Check_Upx.value
      //Prj_Check_34         := WinPSettings.Check_34.value
      //Prj_Check_34_Enabled := WinPSettings.Check_34.enabled
      Return .T.
   endif
Return .F.

Function ProjectSettingsSave()
   if Prj_Radio_Harbour     != WinPSettings.Radio_Harbour.value    .or. ;
      Prj_Check_HarbourIs31 != WinPSettings.Chk_HBVersion.value    .or. ;
      Prj_Radio_Cpp         != WinPSettings.Radio_Cpp.value        .or. ;
      Prj_Radio_MiniGui     != WinPSettings.Radio_MiniGui.value    .or. ;
      Prj_Radio_OutputType  != WinPSettings.Radio_OutputType.value .or. ;
      Prj_Check_Console     != WinPSettings.Check_Console.value
      ActConsoleMode()
      FSwitchMode()
      QPM_SetResumen()
   endif
   ActUpx()
   ActOutputType()
   ActOutputRename()
   ActOutputSuffix()
   ActFormTool()
   ActDbfTool()
   ActOutputCopyMove()
   QPM_ActExtraRun()
   ActLibReimp()
   CambioTitulo()
Return .T.

Function WinPSettingsInit()
   Prj_ExtraRunCmdFINAL        := Prj_ExtraRunCmdFINAL
   Prj_ExtraRunProjQPM         := Prj_ExtraRunProjQPM
   Prj_ExtraRunCmdEXE          := Prj_ExtraRunCmdEXE
   Prj_ExtraRunCmdFREE         := Prj_ExtraRunCmdFREE
   Prj_ExtraRunCmdQPMParm      := Prj_ExtraRunCmdQPMParm
   Prj_ExtraRunCmdEXEParm      := Prj_ExtraRunCmdEXEParm
   Prj_ExtraRunCmdFREEParm     := Prj_ExtraRunCmdFREEParm
   Prj_ExtraRunType            := Prj_ExtraRunType
   Prj_ExtraRunQPMRadio        := Prj_ExtraRunQPMRadio
   Prj_ExtraRunQPMLite         := Prj_ExtraRunQPMLite
   Prj_ExtraRunQPMForceFull    := Prj_ExtraRunQPMForceFull
   Prj_ExtraRunQPMRun          := Prj_ExtraRunQPMRun
   Prj_ExtraRunQPMButtonRun    := Prj_ExtraRunQPMButtonRun
   Prj_ExtraRunQPMClear        := Prj_ExtraRunQPMClear
   Prj_ExtraRunQPMLog          := Prj_ExtraRunQPMLog
   Prj_ExtraRunQPMLogOnlyError := Prj_ExtraRunQPMLogOnlyError
   Prj_ExtraRunQPMAutoExit     := Prj_ExtraRunQPMAutoExit
   Prj_ExtraRunExeWait         := Prj_ExtraRunExeWait
   Prj_ExtraRunExePause        := Prj_ExtraRunExePause
   Prj_ExtraRunFreeWait        := Prj_ExtraRunFreeWait
   Prj_ExtraRunFreePause       := Prj_ExtraRunFreePause

   SwitchRadioOutputCopyMove()
   SwitchRadioOutputRename()
Return .T.

Function HabilitoRadioSegunType()
   if GetProperty( "WinPSettings" , "Radio_OutputType" , "value" ) < DEF_RG_IMPORT
      SetProperty( "WinPSettings" , "Check_Console" , "enabled" , .T. )
      SetProperty( "WinPSettings" , "Radio_Harbour" , "enabled" , .T. )
   else
      SetProperty( "WinPSettings" , "Check_Console" , "enabled" , .F. )
      SetProperty( "WinPSettings" , "Radio_Harbour" , "enabled" , .F. )
   endif
Return .T.

Function ChequeoOutput()
   if GetProperty( "WinPSettings" , "Radio_OutputType" , "value" ) < DEF_RG_IMPORT .and. ;
      GetProperty( "VentanaMain" , "GPrgFiles" , "itemcount" ) == 1 .and. ;
      ( upper( US_FileNameOnlyExt( GetProperty( "VentanaMain" , "GPrgFiles" , "Cell" , 1 , NCOLPRGNAME ) ) ) == "DLL" .or. ;
        upper( US_FileNameOnlyExt( GetProperty( "VentanaMain" , "GPrgFiles" , "Cell" , 1 , NCOLPRGNAME ) ) ) == "LIB" .or. ;
        upper( US_FileNameOnlyExt( GetProperty( "VentanaMain" , "GPrgFiles" , "Cell" , 1 , NCOLPRGNAME ) ) ) == "A" )
      msgstop( "Output type 'Executable' or 'Library' do not support 'DLL', 'LIB' or 'A' into source list" )
      Return .F.
   else
      if GetProperty( "WinPSettings" , "Radio_OutputType" , "value" ) == DEF_RG_IMPORT .and. ;
         GetProperty( "VentanaMain" , "GPrgFiles" , "itemcount" ) == 1 .and. ;
         ( upper( US_FileNameOnlyExt( GetProperty( "VentanaMain" , "GPrgFiles" , "Cell" , 1 , NCOLPRGNAME ) ) ) == "PRG" .or. ;
           upper( US_FileNameOnlyExt( GetProperty( "VentanaMain" , "GPrgFiles" , "Cell" , 1 , NCOLPRGNAME ) ) ) == "C" .or. ;
           upper( US_FileNameOnlyExt( GetProperty( "VentanaMain" , "GPrgFiles" , "Cell" , 1 , NCOLPRGNAME ) ) ) == "CPP" )
         msgstop( "Output type 'Convert' do not support 'PRG', 'C' or 'CPP' into source list" )
         Return .F.
      else
         if GetProperty( "WinPSettings" , "Radio_OutputType" , "value" ) == DEF_RG_IMPORT .and. ;
            GetProperty( "VentanaMain" , "GPrgFiles" , "itemcount" ) > 1
            msgstop( "Output type 'Convert' do not support 'PRG', 'C' or 'CPP' into source list" )
            Return .F.
         endif
      endif
   endif
Return .T.

Function CheckCombinationRadio(cFrom)
   Local nHarbourValue, lHarbourIs31 , nCppValue , nMiniGuiValue , bError := .F.
   nHarbourValue := GetProperty( "WinPSettings" , "Radio_Harbour" , "value" )
   lHarbourIs31  := GetProperty( "WinPSettings" , "Chk_HBVersion" , "value" )
   nCppValue     := GetProperty( "WinPSettings" , "Radio_Cpp"     , "value" )
   nMiniGuiValue := GetProperty( "WinPSettings" , "Radio_MiniGui" , "value" )
   
   if cFrom == "H"
      SetProperty( "WinPSettings", "Chk_HBVersion", "enabled", nHarbourValue == 1 )
   endif

   do case
      case nCppValue == DEF_RG_BORLAND .and. nMiniGuiValue == DEF_RG_MINIGUI3
         bError := .T.
      case nCppValue == DEF_RG_MINGW .and. nMiniGuiValue == DEF_RG_MINIGUI1
         bError := .T.
      case nCppValue == DEF_RG_PELLES .and. nMiniGuiValue != DEF_RG_OOHG3
         bError := .T.
   endcase
   if bError
      do case
         case cFrom == "H"
         case cFrom == "C"
            msgstop( "C++ Compiler is not valid for selected MiniGui." )
            SetProperty( "WinPSettings" , "Radio_Cpp"     , "value" , OLD_Radio_Cpp )
         case cFrom == "M"
            MsgInfo( "Warning, C++ Compiler has been changed." )
            do case
               case nMiniGuiValue == DEF_RG_MINIGUI1
                  SetProperty( "WinPSettings" , "Radio_Cpp"     , "value" , DEF_RG_BORLAND )
               case nMiniGuiValue == DEF_RG_MINIGUI3
                  SetProperty( "WinPSettings" , "Radio_Cpp"     , "value" , DEF_RG_MINGW )
               case nMiniGuiValue == DEF_RG_OOHG3
                  SetProperty( "WinPSettings" , "Radio_Cpp"     , "value" , DEF_RG_BORLAND )
            endcase
         Otherwise
            US_Log( "Invalid cFrom value: " + US_VarToStr( cFrom ) )
            Return .F.
      endcase
   else
      OLD_Radio_Harbour     := nHarbourValue
      OLD_Check_HarbourIs31 := lHarbourIs31
      OLD_Radio_Cpp         := nCppValue
      OLD_Radio_MiniGui     := nMiniGuiValue
   endif
   ActRadioCpp( nMiniGuiValue , nCppValue , nHarbourValue )
Return .T.

Function ActRadioCpp( nMiniGui , nCpp , nHarbour )
   do case
      case nMiniGui == DEF_RG_MINIGUI1
         SetProperty( "WinPSettings" , "Radio_Cpp"     , "enabled" , DEF_RG_BORLAND , .T. )
         SetProperty( "WinPSettings" , "Radio_Cpp"     , "enabled" , DEF_RG_MINGW , .F. )
         SetProperty( "WinPSettings" , "Radio_Cpp"     , "enabled" , DEF_RG_PELLES , .F. )
      case nMiniGui == DEF_RG_MINIGUI3
         SetProperty( "WinPSettings" , "Radio_Cpp"     , "enabled" , DEF_RG_BORLAND , .F. )
         SetProperty( "WinPSettings" , "Radio_Cpp"     , "enabled" , DEF_RG_MINGW , .T. )
         SetProperty( "WinPSettings" , "Radio_Cpp"     , "enabled" , DEF_RG_PELLES , .F. )
      case nMiniGui == DEF_RG_EXTENDED1
         SetProperty( "WinPSettings" , "Radio_Cpp"     , "enabled" , DEF_RG_BORLAND , .T. )
         SetProperty( "WinPSettings" , "Radio_Cpp"     , "enabled" , DEF_RG_MINGW , .T. )
         SetProperty( "WinPSettings" , "Radio_Cpp"     , "enabled" , DEF_RG_PELLES , .F. )
      case nMiniGui == DEF_RG_OOHG3
         SetProperty( "WinPSettings" , "Radio_Cpp"     , "enabled" , DEF_RG_BORLAND , .T. )
         SetProperty( "WinPSettings" , "Radio_Cpp"     , "enabled" , DEF_RG_MINGW , .T. )
         SetProperty( "WinPSettings" , "Radio_Cpp"     , "enabled" , DEF_RG_PELLES , .T. )
      otherwise
         msgstop( "Invalid Value in function " + procname() + ": " + US_VarToStr( nMiniGui ) + " " + US_VarToStr( nCpp ) + " " + US_VarToStr( nHarbour ) )
         Return .F.
   endcase
Return .T.

Function FSwitchMode()
   Prj_Radio_Harbour     := GetProperty( "WinPSettings", "Radio_Harbour", "value" )
   Prj_Check_HarbourIs31 := GetProperty( "WinPSettings", "Chk_HBVersion", "value" )
   Prj_Radio_Cpp         := GetProperty( "WinPSettings", "Radio_Cpp", "value" )
   Prj_Radio_MiniGui     := GetProperty( "WinPSettings", "Radio_MiniGui", "value" )
   Prj_Radio_OutputType  := GetProperty( "WinPSettings", "Radio_OutputType", "value" )
   if Prj_Radio_OutputType == DEF_RG_IMPORT
      if !empty( LibsActiva )
         DesCargoIncludeLibs( LibsActiva )
         DescargoExcludeLibs( LibsActiva )
      endif
   else
      if !empty( LibsActiva )
         DesCargoIncludeLibs( LibsActiva )
         DescargoExcludeLibs( LibsActiva )
      endif
      CargoIncludeLibs( GetSuffix() )
      CargoExcludeLibs( GetSuffix() )
   endif
Return .t.

/* eof */
