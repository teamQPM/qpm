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

Function QPM_GetExtraRun()
   Local Folder := "" , FileName := ""

   DEFINE WINDOW ExtraRun ;
      AT -2,122 ;
      WIDTH 540 ;
      HEIGHT 600 ;
      TITLE 'QPM - Extra Run Wizard' ;
      ICON '' ;
      MODAL ;
      FONT 'MS Sans Serif' ;
      SIZE 10 ;
      ON INIT QPM_GetExtraRunInit() ;

      @ 0 ,16 FRAME ExtraRunSelectFrame ;
         CAPTION "" ;
         WIDTH 498 ;
         HEIGHT 136 ;

      @ 18,133 RADIOGROUP ExtraRunSelectRadio ;
         OPTIONS  {'None' , 'Run Another QPM Instance' , 'Run Exe Program or Batch Process' , 'Execute free command'}   ;
         VALUE 1 ;
         WIDTH  330 ;
         SPACING  25 ;
         TOOLTIP 'Select process type' ;
         ON CHANGE QPM_GetExtraRunOptions() ;

      @ 142,16 FRAME ExtraRunQPMFrame ;
         CAPTION "" ;
         WIDTH 499 ;
         HEIGHT 174 ;

      @ 157,29 LABEL ExtraRunQPMLabel ;
         WIDTH 241 ;
         HEIGHT 15 ;
         VALUE 'Select Main Options for QPM Instance:' ;
         BOLD ;
         FONTCOLOR DEF_COLORBLUE

      @ 172,28 RADIOGROUP ExtraRunQPMRadio ;
         OPTIONS  {'OPEN Project','BUILD Project','RUN Project','CLEAR Temporary Folders of Project'}  ;
         VALUE 2 ;
         WIDTH  242 ;
         SPACING  25 ;
         ON CHANGE QPM_GetExtraRunQPMSubOptions() ;

      @ 193,290 CHECKBOX ExtraRunQPM2ForceFull ;
         CAPTION 'ForceFull' ;
         WIDTH 100 ;
         HEIGHT 28;
         VALUE .F. ;
         TOOLTIP 'Force NonIncremental Build' ;

      @ 218,290 CHECKBOX ExtraRunQPM2Run ;
         CAPTION 'Run' ;
         WIDTH 100 ;
         HEIGHT 28;
         VALUE .F. ;
         TOOLTIP 'Run the Open Project' ;

      @ 242,290 CHECKBOX ExtraRunQPM2ButtonRun ;
         CAPTION 'ButtonRun' ;
         WIDTH 100 ;
         HEIGHT 28;
         VALUE .F. ;
         TOOLTIP 'Enable Button For Run Project' ;

      @ 170,395 CHECKBOX ExtraRunQPM2Clear ;
         CAPTION 'Clear' ;
         WIDTH 84 ;
         HEIGHT 28;
         VALUE .F. ;
         TOOLTIP 'Clear temporary Object Directorys' ;

      @ 194,395 CHECKBOX ExtraRunQPM2Log ;
         CAPTION 'Log' ;
         WIDTH 63 ;
         HEIGHT 26;
         VALUE .F. ;
         TOOLTIP 'Log Activity' ;

      @ 218,395 CHECKBOX ExtraRunQPM2LogOnlyError ;
         CAPTION 'LogOnlyError' ;
         WIDTH 100;
         HEIGHT 28;
         VALUE .F. ;
         TOOLTIP 'Log Only Process with Error' ;

      @ 243,395 CHECKBOX ExtraRunQPM2Exit ;
         CAPTION 'AutoExit' ;
         WIDTH 76 ;
         HEIGHT 27;
         VALUE .T. ;
         TOOLTIP 'Auto Exit when finish Build' ;
         ON CHANGE QPM_GetExtraRunQPM2ExitOptions()

      @ 156,278 FRAME ExtraRunQPM2FrameSubOptions ;
         CAPTION "" ;
         WIDTH 222 ;
         HEIGHT 124 ;

      @ 170,290 CHECKBOX ExtraRunQPM2Lite ;
         CAPTION 'Lite' ;
         WIDTH 100 ;
         HEIGHT 28;
         VALUE .T. ;
         TOOLTIP 'Run QPM with reduced options' ;

      @ 288,27 LABEL ExtraRunQPMProjLabel ;
         WIDTH 50 ;
         HEIGHT 23 ;
         VALUE 'Project' ;

      @ 284,78 TEXTBOX ExtraRunQPMProjText ;
         HEIGHT 27 ;
         READONLY  ;
         WIDTH 385 ;
      // MAXLENGTH 30 ;

      @ 282,465 BUTTON ExtraRunQPMProjButton ;
         PICTURE 'folderselect';
         ACTION If ( !Empty( FileName := BugGetFile( { {'QPM Project File (*.QPM)','*.QPM;*.mpmQ'} } , 'Select Project' , US_FileNameOnlyPath( ChgPathToReal( ExtraRun.ExtraRunQPMProjText.Value ) ) , .F. , .T. ) ) , ExtraRun.ExtraRunQPMProjText.Value := ChgPathToRelative( FileName ) , ) ;
         WIDTH 34 ;
         HEIGHT 31 ;

      @ 326,16 FRAME ExtraRunExeFrame ;
         CAPTION "" ;
         WIDTH 501 ;
         HEIGHT 117 ;

      @ 348,24 LABEL ExtraRunExeLabel ;
         WIDTH 134 ;
         HEIGHT 22 ;
         VALUE 'Run Exe or Batch:' ;
         BOLD ;
         FONTCOLOR DEF_COLORBLUE

      @ 346,161 TEXTBOX ExtraRunExeText ;
         HEIGHT 28 ;
         READONLY  ;
         WIDTH 301 ;
      // MAXLENGTH 30 ;

      @ 344,464 BUTTON ExtraRunExeButton ;
         PICTURE 'FolderSelect';
         ACTION ( If( !Empty( FileName := BugGetFile( { {'EXE and BAT Programs','*.BAT;*.EXE'} } , 'Select Program or Process' , US_FileNameOnlyPath( ChgPathToReal( ExtraRun.ExtraRunExeText.Value ) ) , .F. , .T. ) ) , ExtraRun.ExtraRunExeText.Value := ChgPathToRelative( FileName ) , ) , ExtraRun.ExtraRunExePause.Enabled := if( upper( US_FileNameOnlyExt( ExtraRun.ExtraRunExeText.Value ) ) == "EXE" , .F. , .T. ) ) ;
         WIDTH 35 ;
         HEIGHT 31 ;

      @ 385,28 LABEL ExtraRunExeParm ;
         WIDTH 75 ;
         HEIGHT 19 ;
         VALUE 'Parameters' ;

      @ 381,160 TEXTBOX ExtraRunExeTextParm ;
         HEIGHT 28 ;
         WIDTH 339 ;

      @ 410,223 CHECKBOX ExtraRunExeWait ;
         CAPTION 'Wait' ;
         WIDTH 93 ;
         HEIGHT 30;
         VALUE .T.

      ExtraRun.ExtraRunExeWait.visible := .F.

      @ 410,329 CHECKBOX ExtraRunExePause ;
         CAPTION 'Add Pause' ;
         WIDTH 101 ;
         HEIGHT 27;
         VALUE .F.


      @ 449,16 FRAME ExtraRunFreeFrame ;
         CAPTION "" ;
         WIDTH 503 ;
         HEIGHT 72 ;

      @ 467,26 LABEL ExtraRunFreeLabel ;
         WIDTH 120 ;
         HEIGHT 24 ;
         VALUE 'DOS Command:' ;
         BOLD ;
         FONTCOLOR DEF_COLORBLUE

      @ 463,159 TEXTBOX ExtraRunFreeText ;
         HEIGHT 30 ;
         WIDTH 339 ;

      @ 494,220 CHECKBOX ExtraRunFreeWait ;
         CAPTION 'Wait' ;
         WIDTH 101 ;
         HEIGHT 23 ;
         VALUE .T.

      ExtraRun.ExtraRunFreeWait.visible := .F.

      @ 494,329 CHECKBOX ExtraRunFreePause ;
         CAPTION 'Add Pause' ;
         WIDTH 100 ;
         HEIGHT 21 ;
         VALUE .F.

      @ 533,64 BUTTON ExtraRunOk ;
         CAPTION 'Ok' ;
         ACTION QPM_GetExtraRunSave() ;
         WIDTH 100 ;
         HEIGHT 28 ;

      @ 532,235 BUTTON ExtraRunTest ;
         PICTURE 'TEST' ;
         NOXPSTYLE ;
         ACTION QPM_GetExtraRunSave( .T. ) ;
         WIDTH 70 ;
         HEIGHT 26

      @ 532,357 BUTTON ExtraRunCancel ;
         CAPTION 'Cancel' ;
         ACTION ExtraRun.release() ;
         WIDTH 100 ;
         HEIGHT 28 ;

   END WINDOW

   center window ExtraRun
   activate window ExtraRun
Return .T.

Function QPM_GetExtraRunInit()
   //pepe
   //us_log(Prj_ExtraRunType)
   do case
      case Prj_ExtraRunType == "NONE" .or. Prj_ExtraRunType == ""
         ExtraRun.ExtraRunSelectRadio.Value := 1
      case Prj_ExtraRunType == "QPM"
         ExtraRun.ExtraRunSelectRadio.Value := 2
      case Prj_ExtraRunType == "EXE"
         ExtraRun.ExtraRunSelectRadio.Value := 3
      case Prj_ExtraRunType == "FREE"
         ExtraRun.ExtraRunSelectRadio.Value := 4
      otherwise
         MsgInfo( "Invalid ExtraRun Type: "+US_VarToStr( Prj_ExtraRunType ) )
   endcase
   ExtraRun.ExtraRunQPMProjText.Value      := Prj_ExtraRunProjQPM
   ExtraRun.ExtraRunExeText.Value          := Prj_ExtraRunCmdEXE
   ExtraRun.ExtraRunFreeText.Value         := Prj_ExtraRunCmdFREE
   ExtraRun.ExtraRunExeTextParm.Value      := Prj_ExtraRunCmdEXEParm
   do case
      case Prj_ExtraRunQPMRadio == "OPEN"
         ExtraRun.ExtraRunQPMRadio.Value   := 1
      case Prj_ExtraRunQPMRadio == "BUILD"
         ExtraRun.ExtraRunQPMRadio.Value   := 2
      case Prj_ExtraRunQPMRadio == "RUN"
         ExtraRun.ExtraRunQPMRadio.Value   := 3
      case Prj_ExtraRunQPMRadio == "CLEAR"
         ExtraRun.ExtraRunQPMRadio.Value   := 4
   endcase
   ExtraRun.ExtraRunQPM2ForceFull.Value    := Prj_ExtraRunQPMForceFull
   ExtraRun.ExtraRunQPM2Run.Value          := Prj_ExtraRunQPMRun
   ExtraRun.ExtraRunQPM2Exit.Value         := Prj_ExtraRunQPMAutoExit
   ExtraRun.ExtraRunQPM2Clear.Value        := Prj_ExtraRunQPMClear
   ExtraRun.ExtraRunQPM2Log.Value          := Prj_ExtraRunQPMLog
   ExtraRun.ExtraRunQPM2LogOnlyError.Value := Prj_ExtraRunQPMLogOnlyError
   ExtraRun.ExtraRunQPM2ButtonRun.Value    := Prj_ExtraRunQPMButtonRun
   ExtraRun.ExtraRunQPM2Lite.Value         := Prj_ExtraRunQPMLite
   ExtraRun.ExtraRunExeWait.Value          := Prj_ExtraRunExeWait
   ExtraRun.ExtraRunExePause.Value         := Prj_ExtraRunExePause
   ExtraRun.ExtraRunFreeWait.Value         := Prj_ExtraRunFreeWait
   ExtraRun.ExtraRunFreePause.Value        := Prj_ExtraRunFreePause
   QPM_GetExtraRunOptions()
   QPM_GetExtraRunQPMSubOptions()
   QPM_GetExtraRunQPM2ExitOptions()
Return .T.

Function QPM_GetExtraRunSave( bTest )
   Local Prefix := ""
   Private Tst_ExtraRunProjQPM
   Private Tst_ExtraRunCmdEXE
   Private Tst_ExtraRunCmdFREE
   Private Tst_ExtraRunQPMRadio
   Private Tst_ExtraRunQPMForceFull
   Private Tst_ExtraRunQPMRun
   Private Tst_ExtraRunQPMAutoExit
   Private Tst_ExtraRunQPMClear
   Private Tst_ExtraRunQPMLog
   Private Tst_ExtraRunQPMLogOnlyError
   Private Tst_ExtraRunQPMButtonRun
   Private Tst_ExtraRunQPMLite
   Private Tst_ExtraRunExeWait
   Private Tst_ExtraRunExePause
   Private Tst_ExtraRunFreeWait
   Private Tst_ExtraRunFreePause
   Private Tst_ExtraRunType
   Private Tst_ExtraRunCmdQPMParm
   Private Tst_ExtraRunCmdEXEParm
   Private Tst_ExtraRunCmdFREEParm
   DEFAULT bTest TO .F.
   if bTest
      Prefix := "Tst"
   else
      Prefix := "Tmp"
   endif
   /* */
   if ExtraRun.ExtraRunSelectRadio.Value = 2 .and. empty( ExtraRun.ExtraRunQPMProjText.Value )
      MsgInfo( "Project name is empty !!!" )
      Return .F.
   endif
   if ExtraRun.ExtraRunSelectRadio.Value = 3 .and. empty( ExtraRun.ExtraRunExeText.Value )
      MsgInfo( "Run Program o Process is empty !!!" )
      Return .F.
   endif
   if ExtraRun.ExtraRunSelectRadio.Value = 4 .and. empty( ExtraRun.ExtraRunFreeText.Value )
      MsgInfo( "Free command is empty !!!" )
      Return .F.
   endif
   &( Prefix + "_ExtraRunProjQPM" ) := ExtraRun.ExtraRunQPMProjText.Value
   &( Prefix + "_ExtraRunCmdEXE" )  := ExtraRun.ExtraRunExeText.Value
   &( Prefix + "_ExtraRunCmdFREE" ) := ExtraRun.ExtraRunFreeText.Value
   do case
      case ExtraRun.ExtraRunQPMRadio.Value == 1
         &( Prefix + "_ExtraRunQPMRadio" ) := "OPEN"
      case ExtraRun.ExtraRunQPMRadio.Value == 2
         &( Prefix + "_ExtraRunQPMRadio" ) := "BUILD"
      case ExtraRun.ExtraRunQPMRadio.Value == 3
         &( Prefix + "_ExtraRunQPMRadio" ) := "RUN"
      case ExtraRun.ExtraRunQPMRadio.Value == 4
         &( Prefix + "_ExtraRunQPMRadio" ) := "CLEAR"
      otherwise
         MsgInfo( "Invalid Radio Type: " + US_VarToStr( ExtraRun.ExtraRunQPMRadio.Value ) )
         &( Prefix + "_ExtraRunQPMRadio" ) := "OPEN"
   endcase
   &( Prefix + "_ExtraRunQPMForceFull" ) := ExtraRun.ExtraRunQPM2ForceFull.Value
   &( Prefix + "_ExtraRunQPMRun" ) := ExtraRun.ExtraRunQPM2Run.Value
   &( Prefix + "_ExtraRunQPMAutoExit" ) := ExtraRun.ExtraRunQPM2Exit.Value
   &( Prefix + "_ExtraRunQPMClear" ) := ExtraRun.ExtraRunQPM2Clear.Value
   &( Prefix + "_ExtraRunQPMLog" ) := ExtraRun.ExtraRunQPM2Log.Value
   &( Prefix + "_ExtraRunQPMLogOnlyError" ) := ExtraRun.ExtraRunQPM2LogOnlyError.Value
   &( Prefix + "_ExtraRunQPMButtonRun" ) := ExtraRun.ExtraRunQPM2ButtonRun.Value
   &( Prefix + "_ExtraRunQPMLite" ) := ExtraRun.ExtraRunQPM2Lite.Value
   &( Prefix + "_ExtraRunCmdEXEParm" ) := ExtraRun.ExtraRunExeTextParm.Value
   &( Prefix + "_ExtraRunCmdFREEParm" ) := ""
   &( Prefix + "_ExtraRunExeWait" ) := ExtraRun.ExtraRunExeWait.Value
   &( Prefix + "_ExtraRunExePause" ) := ExtraRun.ExtraRunExePause.Value
   &( Prefix + "_ExtraRunFreeWait" ) := ExtraRun.ExtraRunFreeWait.Value
   &( Prefix + "_ExtraRunFreePause" ) := ExtraRun.ExtraRunFreePause.Value
   do case
      case ExtraRun.ExtraRunSelectRadio.Value = 1
         &( Prefix + "_ExtraRunType" ) := "NONE"
         SetProperty( "WinPSettings" , "Text_ExtraRunCmd" , "Value" , "" )
      case ExtraRun.ExtraRunSelectRadio.Value = 2
         &( Prefix + "_ExtraRunType" ) := "QPM"
         &( Prefix + "_ExtraRunCmdQPMParm" ) := ""
         do case
            case &( Prefix + "_ExtraRunQPMRadio" ) == "OPEN"
               &( Prefix + "_ExtraRunCmdQPMParm" ) := &( Prefix + "_ExtraRunCmdQPMParm" ) + " " + "-OPEN"
            case &( Prefix + "_ExtraRunQPMRadio" ) = "BUILD"
               &( Prefix + "_ExtraRunCmdQPMParm" ) := &( Prefix + "_ExtraRunCmdQPMParm" ) + " " + "-BUILD"
            case &( Prefix + "_ExtraRunQPMRadio" ) = "RUN"
               &( Prefix + "_ExtraRunCmdQPMParm" ) := &( Prefix + "_ExtraRunCmdQPMParm" ) + " " + "-RUN"
            case &( Prefix + "_ExtraRunQPMRadio" ) = "CLEAR"
               &( Prefix + "_ExtraRunCmdQPMParm" ) := &( Prefix + "_ExtraRunCmdQPMParm" ) + " " + "-CLEAR"
         endcase
         if &( Prefix + "_ExtraRunQPMLite" ) .and. ExtraRun.ExtraRunQPM2Lite.Enabled
            &( Prefix + "_ExtraRunCmdQPMParm" ) := &( Prefix + "_ExtraRunCmdQPMParm" ) + " " + "-LITE"
         endif
         if &( Prefix + "_ExtraRunQPMForceFull" ) .and. ExtraRun.ExtraRunQPM2ForceFull.Enabled
            &( Prefix + "_ExtraRunCmdQPMParm" ) := &( Prefix + "_ExtraRunCmdQPMParm" ) + " " + "-FORCEFULL"
         endif
         if &( Prefix + "_ExtraRunQPMButtonRun" ) .and. ExtraRun.ExtraRunQPM2ButtonRun.Enabled
            &( Prefix + "_ExtraRunCmdQPMParm" ) := &( Prefix + "_ExtraRunCmdQPMParm" ) + " " + "-BUTTONRUN"
         endif
         if &( Prefix + "_ExtraRunQPMRun" ) .and. ExtraRun.ExtraRunQPM2Run.Enabled
            &( Prefix + "_ExtraRunCmdQPMParm" ) := &( Prefix + "_ExtraRunCmdQPMParm" ) + " " + "-RUN"
         endif
         if &( Prefix + "_ExtraRunQPMClear" ) .and. ExtraRun.ExtraRunQPM2Clear.Enabled
            &( Prefix + "_ExtraRunCmdQPMParm" ) := &( Prefix + "_ExtraRunCmdQPMParm" ) + " " + "-CLEAR"
         endif
         if &( Prefix + "_ExtraRunQPMAutoExit" ) .and. ExtraRun.ExtraRunQPM2Exit.Enabled
            &( Prefix + "_ExtraRunCmdQPMParm" ) := &( Prefix + "_ExtraRunCmdQPMParm" ) + " " + "-EXIT"
         endif
         if &( Prefix + "_ExtraRunQPMLogOnlyError" ) .and. ExtraRun.ExtraRunQPM2LogOnlyError.Enabled
            &( Prefix + "_ExtraRunCmdQPMParm" ) := &( Prefix + "_ExtraRunCmdQPMParm" ) + " " + "-LOGONLYERROR"
         endif
         if &( Prefix + "_ExtraRunQPMLog" ) .and. ExtraRun.ExtraRunQPM2Log.Enabled
            &( Prefix + "_ExtraRunCmdQPMParm" ) := &( Prefix + "_ExtraRunCmdQPMParm" ) + " " + "-LOG(" + US_FileNameOnlyName( PUB_cProjectFile ) + ".LOG)"
          //&( Prefix + "_ExtraRunCmdQPMParm" ) := &( Prefix + "_ExtraRunCmdQPMParm" ) + " " + "-LOG(" + strtran( US_FileNameOnlyName( PUB_cProjectFile ) , " " , "_" ) + ".LOG)"
         endif
         SetProperty( "WinPSettings" , "Text_ExtraRunCmd" , "Value" , "<QPM> " + &( Prefix + "_ExtraRunProjQPM" ) + " " + &( Prefix + "_ExtraRunCmdQPMParm" ) )
      case ExtraRun.ExtraRunSelectRadio.Value = 3
         &( Prefix + "_ExtraRunType" ) := "EXE"
         SetProperty( "WinPSettings" , "Text_ExtraRunCmd" , "Value" , &( Prefix + "_ExtraRunCmdEXE" ) + " " + &( Prefix + "_ExtraRunCmdEXEParm" ) )
      case ExtraRun.ExtraRunSelectRadio.Value = 4
         &( Prefix + "_ExtraRunType" ) := "FREE"
         SetProperty( "WinPSettings" , "Text_ExtraRunCmd" , "Value" , &( Prefix + "_ExtraRunCmdFREE" ) )
      otherwise
         MsgInfo( "Invalid ExtraRun Radio: " + US_VarToStr( ExtraRun.ExtraRunSelectRadio.Value ) )
   endcase
   if bTest
      QPM_ExecuteExtraRun( .T. )
   else
      ExtraRun.release()
   endif
Return .T.

Function QPM_GetExtraRunOptions()
   do case
      case ExtraRun.ExtraRunSelectRadio.Value == 1
         ExtraRun.ExtraRunQPMLabel.Enabled           := .F.
         ExtraRun.ExtraRunQPMRadio.Enabled           := .F.
         ExtraRun.ExtraRunQPM2ForceFull.Enabled      := .F.
         ExtraRun.ExtraRunQPM2Run.Enabled            := .F.
         ExtraRun.ExtraRunQPM2Exit.Enabled           := .F.
         ExtraRun.ExtraRunQPM2Clear.Enabled          := .F.
         ExtraRun.ExtraRunQPM2Log.Enabled            := .F.
         ExtraRun.ExtraRunQPM2LogOnlyError.Enabled   := .F.
         ExtraRun.ExtraRunQPM2ButtonRun.Enabled      := .F.
         ExtraRun.ExtraRunQPM2Lite.Enabled           := .F.
         ExtraRun.ExtraRunQPMProjButton.Enabled      := .F.
         ExtraRun.ExtraRunQPMProjText.Enabled        := .F.
         ExtraRun.ExtraRunQPMProjLabel.Enabled       := .F.
         ExtraRun.ExtraRunExeLabel.Enabled           := .F.
         ExtraRun.ExtraRunExeText.Enabled            := .F.
         ExtraRun.ExtraRunExeParm.Enabled            := .F.
         ExtraRun.ExtraRunExeTextParm.Enabled        := .F.
         ExtraRun.ExtraRunExeWait.Enabled            := .F.
         ExtraRun.ExtraRunExePause.Enabled           := .F.
         ExtraRun.ExtraRunExeButton.Enabled          := .F.
         ExtraRun.ExtraRunFreeLabel.Enabled          := .F.
         ExtraRun.ExtraRunFreeText.Enabled           := .F.
         ExtraRun.ExtraRunFreeWait.Enabled           := .F.
         ExtraRun.ExtraRunFreePause.Enabled          := .F.
      case ExtraRun.ExtraRunSelectRadio.Value == 2
         ExtraRun.ExtraRunQPMLabel.Enabled           := .T.
         ExtraRun.ExtraRunQPMRadio.Enabled           := .T.
         ExtraRun.ExtraRunQPM2ForceFull.Enabled      := .T.
         ExtraRun.ExtraRunQPM2Run.Enabled            := .T.
         ExtraRun.ExtraRunQPM2Exit.Enabled           := .T.
         ExtraRun.ExtraRunQPM2Clear.Enabled          := .T.
         ExtraRun.ExtraRunQPM2Log.Enabled            := .T.
         ExtraRun.ExtraRunQPM2LogOnlyError.Enabled   := .T.
         ExtraRun.ExtraRunQPM2ButtonRun.Enabled      := .T.
         ExtraRun.ExtraRunQPM2Lite.Enabled           := .T.
         ExtraRun.ExtraRunQPMProjButton.Enabled      := .T.
         ExtraRun.ExtraRunQPMProjText.Enabled        := .T.
         ExtraRun.ExtraRunQPMProjLabel.Enabled       := .T.
         ExtraRun.ExtraRunExeLabel.Enabled           := .F.
         ExtraRun.ExtraRunExeText.Enabled            := .F.
         ExtraRun.ExtraRunExeParm.Enabled            := .F.
         ExtraRun.ExtraRunExeTextParm.Enabled        := .F.
         ExtraRun.ExtraRunExeWait.Enabled            := .F.
         ExtraRun.ExtraRunExePause.Enabled           := .F.
         ExtraRun.ExtraRunExeButton.Enabled          := .F.
         ExtraRun.ExtraRunFreeLabel.Enabled          := .F.
         ExtraRun.ExtraRunFreeText.Enabled           := .F.
         ExtraRun.ExtraRunFreeWait.Enabled           := .F.
         ExtraRun.ExtraRunFreePause.Enabled          := .F.
      case ExtraRun.ExtraRunSelectRadio.Value == 3
         ExtraRun.ExtraRunQPMLabel.Enabled           := .F.
         ExtraRun.ExtraRunQPMRadio.Enabled           := .F.
         ExtraRun.ExtraRunQPM2ForceFull.Enabled      := .F.
         ExtraRun.ExtraRunQPM2Run.Enabled            := .F.
         ExtraRun.ExtraRunQPM2Exit.Enabled           := .F.
         ExtraRun.ExtraRunQPM2Clear.Enabled          := .F.
         ExtraRun.ExtraRunQPM2Log.Enabled            := .F.
         ExtraRun.ExtraRunQPM2LogOnlyError.Enabled   := .F.
         ExtraRun.ExtraRunQPM2ButtonRun.Enabled      := .F.
         ExtraRun.ExtraRunQPM2Lite.Enabled           := .F.
         ExtraRun.ExtraRunQPMProjButton.Enabled      := .F.
         ExtraRun.ExtraRunQPMProjText.Enabled        := .F.
         ExtraRun.ExtraRunQPMProjLabel.Enabled       := .F.
         ExtraRun.ExtraRunExeLabel.Enabled           := .T.
         ExtraRun.ExtraRunExeText.Enabled            := .T.
         ExtraRun.ExtraRunExeParm.Enabled            := .T.
         ExtraRun.ExtraRunExeTextParm.Enabled        := .T.
         ExtraRun.ExtraRunExeWait.Enabled            := .T.
         ExtraRun.ExtraRunExePause.Enabled := if( upper( US_FileNameOnlyExt( ExtraRun.ExtraRunExeText.Value ) ) == "EXE" , .F. , .T. )
         //ExtraRun.ExtraRunExePause.Enabled           := .T.
         ExtraRun.ExtraRunExeButton.Enabled          := .T.
         ExtraRun.ExtraRunFreeLabel.Enabled          := .F.
         ExtraRun.ExtraRunFreeText.Enabled           := .F.
         ExtraRun.ExtraRunFreeWait.Enabled           := .F.
         ExtraRun.ExtraRunFreePause.Enabled          := .F.
      case ExtraRun.ExtraRunSelectRadio.Value == 4
         ExtraRun.ExtraRunQPMLabel.Enabled           := .F.
         ExtraRun.ExtraRunQPMRadio.Enabled           := .F.
         ExtraRun.ExtraRunQPM2ForceFull.Enabled      := .F.
         ExtraRun.ExtraRunQPM2Run.Enabled            := .F.
         ExtraRun.ExtraRunQPM2Exit.Enabled           := .F.
         ExtraRun.ExtraRunQPM2Clear.Enabled          := .F.
         ExtraRun.ExtraRunQPM2Log.Enabled            := .F.
         ExtraRun.ExtraRunQPM2LogOnlyError.Enabled   := .F.
         ExtraRun.ExtraRunQPM2ButtonRun.Enabled      := .F.
         ExtraRun.ExtraRunQPM2Lite.Enabled           := .F.
         ExtraRun.ExtraRunQPMProjButton.Enabled      := .F.
         ExtraRun.ExtraRunQPMProjText.Enabled        := .F.
         ExtraRun.ExtraRunQPMProjLabel.Enabled       := .F.
         ExtraRun.ExtraRunExeLabel.Enabled           := .F.
         ExtraRun.ExtraRunExeText.Enabled            := .F.
         ExtraRun.ExtraRunExeParm.Enabled            := .F.
         ExtraRun.ExtraRunExeTextParm.Enabled        := .F.
         ExtraRun.ExtraRunExeWait.Enabled            := .F.
         ExtraRun.ExtraRunExePause.Enabled           := .F.
         ExtraRun.ExtraRunExeButton.Enabled          := .F.
         ExtraRun.ExtraRunFreeLabel.Enabled          := .T.
         ExtraRun.ExtraRunFreeText.Enabled           := .T.
         ExtraRun.ExtraRunFreeWait.Enabled           := .T.
         ExtraRun.ExtraRunFreePause.Enabled          := .T.
   EndCase
   QPM_GetExtraRunQPMSubOptions()
Return .T.

Function QPM_GetExtraRunQPMSubOptions()
   if ExtraRun.ExtraRunSelectRadio.Value = 2
      Do case
         case ExtraRun.ExtraRunQPMRadio.Value == 1
            ExtraRun.ExtraRunQPM2Lite.Enabled           := .F.
            ExtraRun.ExtraRunQPM2ForceFull.Enabled      := .T.
            ExtraRun.ExtraRunQPM2Run.Enabled            := .F.
            ExtraRun.ExtraRunQPM2ButtonRun.Enabled      := .F.
            ExtraRun.ExtraRunQPM2Clear.Enabled          := .F.
            ExtraRun.ExtraRunQPM2Exit.Enabled           := .F.
            ExtraRun.ExtraRunQPM2Log.Enabled            := .F.
            ExtraRun.ExtraRunQPM2LogOnlyError.Enabled   := .F.
         case ExtraRun.ExtraRunQPMRadio.Value == 2
            ExtraRun.ExtraRunQPM2Lite.Enabled           := .T.
            ExtraRun.ExtraRunQPM2ForceFull.Enabled      := .T.
            ExtraRun.ExtraRunQPM2Run.Enabled            := .T.
            ExtraRun.ExtraRunQPM2ButtonRun.Enabled      := .T.
            ExtraRun.ExtraRunQPM2Clear.Enabled          := .T.
            ExtraRun.ExtraRunQPM2Exit.Enabled           := .T.
            ExtraRun.ExtraRunQPM2Log.Enabled            := .T.
            ExtraRun.ExtraRunQPM2LogOnlyError.Enabled   := .T.
         case ExtraRun.ExtraRunQPMRadio.Value == 3
            ExtraRun.ExtraRunQPM2Lite.Enabled           := .T.
            ExtraRun.ExtraRunQPM2ForceFull.Enabled      := .F.
            ExtraRun.ExtraRunQPM2Run.Enabled            := .F.
            ExtraRun.ExtraRunQPM2ButtonRun.Enabled      := .F.
            ExtraRun.ExtraRunQPM2Clear.Enabled          := .T.
            ExtraRun.ExtraRunQPM2Exit.Enabled           := .T.
            ExtraRun.ExtraRunQPM2Log.Enabled            := .T.
            ExtraRun.ExtraRunQPM2LogOnlyError.Enabled   := .T.
         case ExtraRun.ExtraRunQPMRadio.Value == 4
            ExtraRun.ExtraRunQPM2Lite.Enabled           := .T.
            ExtraRun.ExtraRunQPM2ForceFull.Enabled      := .T.
            ExtraRun.ExtraRunQPM2Run.Enabled            := .F.
            ExtraRun.ExtraRunQPM2ButtonRun.Enabled      := .F.
            ExtraRun.ExtraRunQPM2Clear.Enabled          := .F.
            ExtraRun.ExtraRunQPM2Exit.Enabled           := .T.
            ExtraRun.ExtraRunQPM2Log.Enabled            := .T.
            ExtraRun.ExtraRunQPM2LogOnlyError.Enabled   := .T.
      endcase
      QPM_GetExtraRunQPM2ExitOptions()
   endif
Return .T.

Function QPM_GetExtraRunQPM2ExitOptions()
   if ExtraRun.ExtraRunQPM2Exit.Value
      if ExtraRun.ExtraRunQPM2Exit.Enabled
         ExtraRun.ExtraRunQPM2Log.Enabled            := .T.
         ExtraRun.ExtraRunQPM2LogOnlyError.Enabled   := .T.
      endif
   else
      if ExtraRun.ExtraRunQPM2Exit.Enabled
         ExtraRun.ExtraRunQPM2Log.Enabled            := .F.
         ExtraRun.ExtraRunQPM2LogOnlyError.Enabled   := .F.
      endif
   endif
Return .T.

Function QPM_ExecuteExtraRun( bTest )
   Local CurrentFolder := GetCurrentFolder()
   Local Prefix , Memorun := ""
   DEFAULT bTest TO .F.
   if bTest
      Prefix := "Tst"
   else
      Prefix := "Prj"
   endif
   DirChange( PUB_cProjectFolder )
   do case
      case &( Prefix + "_ExtraRunType" ) == "QPM"
         QPM_Execute( US_ShortName( ChgPathToReal( "<QPM>" ) ) , ChgPathToReal( &( Prefix + "_ExtraRunProjQPM" ) ) + " " + ChgPathToReal( &( Prefix + "_ExtraRunCmdQPMParm" ) ) )
      case &( Prefix + "_ExtraRunType" ) == "EXE"
         do case
            case UPPER( US_FileNameOnlyExt( ChgPathToReal( &( Prefix + "_ExtraRunCmdEXE" ) ) ) ) == "EXE"
               QPM_Execute( US_ShortName( ChgPathToReal( &( Prefix + "_ExtraRunCmdEXE" ) ) ) , ChgPathToReal( &( Prefix + "_ExtraRunCmdEXEParm" ) ) )
            case UPPER( US_FileNameOnlyExt( ChgPathToReal( &( Prefix + "_ExtraRunCmdEXE" ) ) ) ) == "BAT"
               MemoRun := US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + "_" + PUB_cSecu + "ExtraRun.bat"
               ferase( MemoRun )
               QPM_MemoWrit( MemoRun , 'call "' + ChgPathToReal( &( Prefix + "_ExtraRunCmdEXE" ) ) + '" ' + ChgPathToReal( &( Prefix + "_ExtraRunCmdEXEParm" ) ) + if( &( Prefix + "_ExtraRunExePause" ) , HB_OsNewLine() + "Pause" , "" ) + HB_OsNewLine() + "del " + MemoRun )
               QPM_Execute( MemoRun )
            otherwise
         endcase
      case &( Prefix + "_ExtraRunType" ) == "FREE"
         MemoRun := US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + "_" + PUB_cSecu + "ExtraRun.bat"
         ferase( MemoRun )
         QPM_MemoWrit( MemoRun , ChgPathToReal( &( Prefix + "_ExtraRunCmdFREE" ) ) + if( &( Prefix + "_ExtraRunFreePause" ) , HB_OsNewLine() + "Pause" , "" ) + HB_OsNewLine() + "del " + MemoRun )
         QPM_Execute( MemoRun )
   endcase
   DirChange( CurrentFolder )
Return .T.

Function QPM_ActExtraRun()
   Prj_ExtraRunCmdFINAL        := GetProperty( "WinPSettings" , "Text_ExtraRunCmd" , "value" )
   Prj_ExtraRunProjQPM         := Tmp_ExtraRunProjQPM
   Prj_ExtraRunCmdEXE          := Tmp_ExtraRunCmdEXE
   Prj_ExtraRunCmdFREE         := Tmp_ExtraRunCmdFREE
   Prj_ExtraRunCmdQPMParm      := Tmp_ExtraRunCmdQPMParm
   Prj_ExtraRunCmdEXEParm      := Tmp_ExtraRunCmdEXEParm
   Prj_ExtraRunCmdFREEParm     := Tmp_ExtraRunCmdFREEParm
   Prj_ExtraRunType            := Tmp_ExtraRunType
   Prj_ExtraRunQPMRadio        := Tmp_ExtraRunQPMRadio
   Prj_ExtraRunQPMLite         := Tmp_ExtraRunQPMLite
   Prj_ExtraRunQPMForceFull    := Tmp_ExtraRunQPMForceFull
   Prj_ExtraRunQPMRun          := Tmp_ExtraRunQPMRun
   Prj_ExtraRunQPMButtonRun    := Tmp_ExtraRunQPMButtonRun
   Prj_ExtraRunQPMClear        := Tmp_ExtraRunQPMClear
   Prj_ExtraRunQPMLog          := Tmp_ExtraRunQPMLog
   Prj_ExtraRunQPMLogOnlyError := Tmp_ExtraRunQPMLogOnlyError
   Prj_ExtraRunQPMAutoExit     := Tmp_ExtraRunQPMAutoExit
   Prj_ExtraRunExeWait         := Tmp_ExtraRunExeWait
   Prj_ExtraRunExePause        := Tmp_ExtraRunExePause
   Prj_ExtraRunFreeWait        := Tmp_ExtraRunFreeWait
   Prj_ExtraRunFreePause       := Tmp_ExtraRunFreePause
Return .T.

/* eof */
