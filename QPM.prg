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

#include "minigui.ch"
#include "QPM.ch"

#define  SCRIPT_FILE  ( US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + '_' + PUB_cSecu + 'script.ld' )
#define  TEMP_LOG     ( US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + '_' + PUB_cSecu + 'temp.log' )
#define  END_FILE     ( US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + '_' + PUB_cSecu + 'end.txt' )
#define  BUILD_BAT    ( US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + '_' + PUB_cSecu + 'build.bat' )
#define  MAKE_FILE    ( US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + '_' + PUB_cSecu + 'temp.bc' )
#define  PROGRESS_LOG ( US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + '_' + PUB_cSecu + 'progress.log' )
#define  RUN_FILE     ( US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + '_' + PUB_cSecu + 'runshell.bat' )
#define  QPM_GET_DEF  ( US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + '_' + PUB_cSecu + 'qpm_gt.prg' )
#define  QPM_TMP_RC   ( US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + '_' + PUB_cSecu + 'temp.rc' )
#define  MSG_SYSIN    ( US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + '_' + PUB_cSecu + 'MSG.SYSIN' )

#define LISTOLOG iif( bLogActivity, ' -LIST' + US_ShortName(PUB_cQPM_Folder) + ' ', ' ' )

PROCEDURE Main( PAR_cP01, PAR_cP02, PAR_cP03, PAR_cP04, PAR_cP05, PAR_cP06, PAR_cP07, PAR_cP08, PAR_cP09, PAR_cP10, ;
                PAR_cP11, PAR_cP12, PAR_cP13, PAR_cP14, PAR_cP15, PAR_cP16, PAR_cP17, PAR_cP18, PAR_cP19, PAR_cP20 )
   LOCAL Folder, FileName, i, nPos, LogIni, LOC_cParam, nRow, nCol, nWidth, nHeight

   REQUEST DBFCDX, DBFFPT
   rddSetDefault( 'DBFCDX' )

// Load parameters (do not change = to := because it brokes the pp rule)
   PAR_cP01 = iif( PAR_cP01 = NIL, '', PAR_cP01 )
   PAR_cP02 = iif( PAR_cP02 = NIL, '', PAR_cP02 )
   PAR_cP03 = iif( PAR_cP03 = NIL, '', PAR_cP03 )
   PAR_cP04 = iif( PAR_cP04 = NIL, '', PAR_cP04 )
   PAR_cP05 = iif( PAR_cP05 = NIL, '', PAR_cP05 )
   PAR_cP06 = iif( PAR_cP06 = NIL, '', PAR_cP06 )
   PAR_cP07 = iif( PAR_cP07 = NIL, '', PAR_cP07 )
   PAR_cP08 = iif( PAR_cP08 = NIL, '', PAR_cP08 )
   PAR_cP09 = iif( PAR_cP09 = NIL, '', PAR_cP09 )
   PAR_cP10 = iif( PAR_cP10 = NIL, '', PAR_cP10 )
   PAR_cP11 = iif( PAR_cP11 = NIL, '', PAR_cP11 )
   PAR_cP12 = iif( PAR_cP12 = NIL, '', PAR_cP12 )
   PAR_cP13 = iif( PAR_cP13 = NIL, '', PAR_cP13 )
   PAR_cP14 = iif( PAR_cP14 = NIL, '', PAR_cP14 )
   PAR_cP15 = iif( PAR_cP15 = NIL, '', PAR_cP15 )
   PAR_cP16 = iif( PAR_cP16 = NIL, '', PAR_cP16 )
   PAR_cP17 = iif( PAR_cP17 = NIL, '', PAR_cP17 )
   PAR_cP18 = iif( PAR_cP18 = NIL, '', PAR_cP18 )
   PAR_cP19 = iif( PAR_cP19 = NIL, '', PAR_cP19 )
   PAR_cP20 = iif( PAR_cP20 = NIL, '', PAR_cP20 )
   LOC_cParam := AllTrim( PAR_cP01 + ' ' + PAR_cP02 + ' ' + PAR_cP03 + ' ' + PAR_cP04 + ' ' + PAR_cP05 + ' ' + ;
                          PAR_cP06 + ' ' + PAR_cP07 + ' ' + PAR_cP08 + ' ' + PAR_cP09 + ' ' + PAR_cP10 + ' ' + ;
                          PAR_cP11 + ' ' + PAR_cP12 + ' ' + PAR_cP13 + ' ' + PAR_cP14 + ' ' + PAR_cP15 + ' ' + ;
                          PAR_cP16 + ' ' + PAR_cP17 + ' ' + PAR_cP18 + ' ' + PAR_cP19 + ' ' + PAR_cP20 )

// PRIORITY
   PUBLIC PUB_QPM_bHigh := .F.
   QPM_SetProcessPriority( 'HIGH' )

// create other public vars
   QPM_CreatePublicVars()

// configuration
   SET LANGUAGE TO ENGLISH
   SET DELETED ON
   SET NAVIGATION EXTENDED
   SET MENUSTYLE EXTENDED
//   SET EXACT ON           **** DO NO ENABLE THIS, SEE FUNCTION xRefPrgFmg ****
   SET TOOLTIPSTYLE BALLOON

// check screen size
   IF GetDesktopRealWidth() < 800
      MyMsgStop( 'Sorry, QPM needs a minimun screen configuration of 800x600.' + CRLF + 'QPM is optimized for 1024x768 resolution.' )
      ExitProcess( 1 )
   ENDIF

   IF Empty( LOC_cParam )
      IF PUB_bW800
         MyMsgInfo( 'QPM has been optimized for 1024x768 screen size' + CRLF + 'but your configuration is also supported with reduced workplace.' )
      ENDIF
   ENDIF

// check file existence
   FOR i := 1 TO Len( vExeList )
      IF ! File( vExeList[i] )
         AAdd( vExeNotFound, vExeList[i] )
      ENDIF
   NEXT
   IF Len( vExeNotFound ) > 0
      cExeNotFoundMsg := 'This product is incomplete:' + CRLF + CRLF
      FOR i := 1 TO Len( vExeNotFound )
         cExeNotFoundMsg := cExeNotFoundMsg + vExeNotFound[i] + ' was not found.' + CRLF
      NEXT
      cExeNotFoundMsg := cExeNotFoundMsg + CRLF + 'Full package is: ' + CRLF + CRLF
      FOR i := 1 TO Len( vExeList )
         cExeNotFoundMsg := cExeNotFoundMsg + vExeList[i] + CRLF
      NEXT
      MyMsgStop( cExeNotFoundMsg )
      ExitProcess( 1 )
   ENDIF
   IF ! File( PUB_cQPM_Folder + DEF_SLASH + 'filler' )
      QPM_LogText( "Filler file" )
      QPM_MemoWrit( PUB_cQPM_Folder + DEF_SLASH + 'filler', Chr( 13 ) + Chr( 10 ) )
      QPM_LogText( "Created" )
   ENDIF

// analize parameters
   IF !  Empty( LOC_cParam )
      IF ( nPos := US_WordPos( '--BUILD', US_Upper( LOC_cParam ) ) ) > 0
         LOC_cParam := US_WordDel( LOC_cParam, nPos )
      ENDIF
      IF ( nPos := US_WordPos( '--LITE', US_Upper( LOC_cParam ) ) ) > 0
         LOC_cParam := US_WordDel( LOC_cParam, nPos )
      ENDIF
      IF ( nPos := US_WordPos( '--DEBUG', US_Upper( LOC_cParam ) ) ) > 0
         LOC_cParam := US_WordDel( LOC_cParam, nPos )
      ENDIF
      IF ( nPos := US_WordPos( '--RUN', US_Upper( LOC_cParam ) ) ) > 0
         LOC_cParam := US_WordDel( LOC_cParam, nPos )
      ENDIF
      IF ( nPos := US_WordPos( '--BUTTONRUN', US_Upper( LOC_cParam ) ) ) > 0
         LOC_cParam := US_WordDel( LOC_cParam, nPos )
      ENDIF
      IF ( nPos := US_WordPos( '--CLEAR', US_Upper( LOC_cParam ) ) ) > 0
         LOC_cParam := US_WordDel( LOC_cParam, nPos )
      ENDIF
      IF ( nPos := US_WordPos( '--OPEN', US_Upper( LOC_cParam ) ) ) > 0
         LOC_cParam := US_WordDel( LOC_cParam, nPos )
      ENDIF
      IF ( nPos := US_WordPos( '--IGNOREVERSIONPROJECT', US_Upper( LOC_cParam ) ) ) > 0
         LOC_cParam := US_WordDel( LOC_cParam, nPos )
      ENDIF
      IF ( nPos := US_WordPos( '--FORCEFULL', US_Upper( LOC_cParam ) ) ) > 0
         LOC_cParam := US_WordDel( LOC_cParam, nPos )
      ENDIF
      IF ( nPos := US_WordStrPos( '--LOG(', US_Upper( LOC_cParam ) ) ) > 0
         LOC_cParam := US_WordDel( LOC_cParam, nPos )
      ENDIF
      IF ( nPos := US_WordPos( '--LOGONLYERROR', US_Upper( LOC_cParam ) ) ) > 0
         LOC_cParam := US_WordDel( LOC_cParam, nPos )
      ENDIF
      IF ( nPos := US_WordPos( '--EXIT', US_Upper( LOC_cParam ) ) ) > 0
         LOC_cParam := US_WordDel( LOC_cParam, nPos )
      ENDIF
      DO CASE
      CASE US_Upper( US_Word( LOC_cParam, 1 ) ) == '-VER' .OR. US_Upper( US_Word( LOC_cParam, 1 ) ) == '-VERSION'
         QPM_LogText( QPM_VERSION_NUMBER_LONG )
         QPM_MemoWrit( US_FileNameOnlyPathAndName( GetModuleFileName( GetInstance() ) ) + '.version', QPM_VERSION_NUMBER_LONG )
         QPM_LogText( "Done" )
         ExitProcess( 0 )
      CASE ( nPos := US_WordPos( '-BUILD', US_Upper( LOC_cParam ) ) ) > 0
         LOC_cParam := US_WordDel( LOC_cParam, nPos )
         AAdd( PUB_vAutoRun, 'QPM_OpenProject(PUB_cProjectFile)' )
         IF ( nPos := US_WordPos( '-LITE', US_Upper( LOC_cParam ) ) ) > 0
            LOC_cParam := US_WordDel( LOC_cParam, nPos )
            PUB_bLite := .T.
         ENDIF
         IF ( nPos := US_WordPos( '-FORCEFULL', US_Upper( LOC_cParam ) ) ) > 0
            LOC_cParam := US_WordDel( LOC_cParam, nPos )
            AAdd( PUB_vAutoRun, 'EraseObj()' )
         ENDIF
         IF ( nPos := US_WordPos( '-DEBUG', US_Upper( LOC_cParam ) ) ) > 0
            LOC_cParam := US_WordDel( LOC_cParam, nPos )
            AAdd( PUB_vAutoRun, 'SwitchDebug()' )
         ENDIF
         AAdd( PUB_vAutoRun, 'QPM_Build()' )
         IF ( nPos := US_WordPos( '-BUTTONRUN', US_Upper( LOC_cParam ) ) ) > 0
            LOC_cParam := US_WordDel( LOC_cParam, nPos )
            AAdd( PUB_vAutoRun, 'EnableButtonRun()' )
            bWaitForBuild := .T.
         ENDIF
         IF ( nPos := US_WordPos( '-RUN', US_Upper( LOC_cParam ) ) ) > 0
            LOC_cParam := US_WordDel( LOC_cParam, nPos )
            AAdd( PUB_vAutoRun, 'QPM_Run( bRunParm )' )
            bWaitForBuild := .T.
         ENDIF
         IF ( nPos := US_WordPos( '-CLEAR', US_Upper( LOC_cParam ) ) ) > 0
            LOC_cParam := US_WordDel( LOC_cParam, nPos )
            AAdd( PUB_vAutoRun, 'EraseAll()' )
            bWaitForBuild := .T.
         ENDIF
         IF ( nPos := US_WordPos( '-EXIT', US_Upper( LOC_cParam ) ) ) > 0
            LOC_cParam := US_WordDel( LOC_cParam, nPos )
            AAdd( PUB_vAutoRun, 'QPM_Exit()' )
            bWaitForBuild := .T.
            bAutoExit     := .T.
            IF ( nPos := US_WordStrPos( '-LOG(', US_Upper( LOC_cParam ) ) ) > 0
               LogIni := US_WordInd( LOC_cParam, nPos )
               PUB_cAutoLog := US_WordSubStr( LOC_cParam, nPos )
               PUB_cAutoLog := SubStr( PUB_cAutoLog, 6, at( ')', PUB_cAutoLog ) - 6 )
               IF Empty( PUB_cAutoLog )
                  MyMsgInfo( 'Error detecting log: ' + DBLQT + LOC_cParam + DBLQT )
               ELSE
                  LOC_cParam := SubStr( LOC_cParam, 1, LogIni - 1 ) + SubStr( LOC_cParam, LogIni + Len( PUB_cAutoLog ) + 6 )
                  IF ( nPos := US_WordPos( '-LOGONLYERROR', US_Upper( LOC_cParam ) ) ) > 0
                     LOC_cParam := US_WordDel( LOC_cParam, nPos )
                     PUB_bLogOnlyError := .T.
                  ENDIF
               ENDIF
            ENDIF
         ENDIF
         IF ( nPos := US_WordPos( '-OPEN', US_Upper( LOC_cParam ) ) ) > 0
            LOC_cParam := US_WordDel( LOC_cParam, nPos )
         ENDIF
         IF ( nPos := US_WordPos( '-IGNOREVERSIONPROJECT', US_Upper( LOC_cParam ) ) ) > 0
            LOC_cParam := US_WordDel( LOC_cParam, nPos )
            PUB_bIgnoreVersionProject := .T.
         ENDIF
         PUB_cProjectFile := AllTrim( LOC_cParam )
      CASE ( nPos := US_WordPos( '-RUN', US_Upper( LOC_cParam ) ) ) > 0
         LOC_cParam := US_WordDel( LOC_cParam, nPos )
         AAdd( PUB_vAutoRun, 'QPM_OpenProject(PUB_cProjectFile)' )
         AAdd( PUB_vAutoRun, 'QPM_Run( bRunParm )' )
         bWaitForBuild := .F. 
         IF ( nPos := US_WordPos( '-LITE', US_Upper( LOC_cParam ) ) ) > 0
            LOC_cParam := US_WordDel( LOC_cParam, nPos )
            PUB_bLite := .T.
         ENDIF
         IF ( nPos := US_WordPos( '-CLEAR', US_Upper( LOC_cParam ) ) ) > 0
            LOC_cParam := US_WordDel( LOC_cParam, nPos )
            AAdd( PUB_vAutoRun, 'EraseAll()' )
            bWaitForBuild := .T.
         ENDIF
         IF ( nPos := US_WordPos( '-EXIT', US_Upper( LOC_cParam ) ) ) > 0
            LOC_cParam := US_WordDel( LOC_cParam, nPos )
            AAdd( PUB_vAutoRun, 'QPM_Exit()' )
            bWaitForBuild := .F.
            bAutoExit := .T.
            IF ( nPos := US_WordStrPos( '-LOG(', US_Upper( LOC_cParam ) ) ) > 0
               LogIni := US_WordInd( LOC_cParam, nPos )
               PUB_cAutoLog := US_WordSubStr( LOC_cParam, nPos )
               PUB_cAutoLog := SubStr( PUB_cAutoLog, 6, At( ')', PUB_cAutoLog ) - 6 )
               IF Empty( PUB_cAutoLog )
                  MyMsgInfo( 'Error detecting log: ' + DBLQT + LOC_cParam + DBLQT )
               ELSE
                  LOC_cParam := SubStr( LOC_cParam, 1, LogIni - 1 ) + SubStr( LOC_cParam, LogIni + Len( PUB_cAutoLog ) + 6 )
                  IF ( nPos := US_WordPos( '-LOGONLYERROR', US_Upper( LOC_cParam ) ) ) > 0
                     LOC_cParam := US_WordDel( LOC_cParam, nPos )
                     PUB_bLogOnlyError := .T.
                  ENDIF
               ENDIF
            ENDIF
         ENDIF
         IF ( nPos := US_WordPos( '-OPEN', US_Upper( LOC_cParam ) ) ) > 0
            LOC_cParam := US_WordDel( LOC_cParam, nPos )
         ENDIF
         IF ( nPos := US_WordPos( '-IGNOREVERSIONPROJECT', US_Upper( LOC_cParam ) ) ) > 0
            LOC_cParam := US_WordDel( LOC_cParam, nPos )
            PUB_bIgnoreVersionProject := .T.
         ENDIF
         PUB_cProjectFile := AllTrim( LOC_cParam )
      CASE ( nPos := US_WordPos( '-CLEAR', US_Upper( LOC_cParam ) ) ) > 0
         LOC_cParam := US_WordDel( LOC_cParam, nPos )
         AAdd( PUB_vAutoRun, 'QPM_OpenProject(PUB_cProjectFile)' )
         IF ( nPos := US_WordPos( '-LITE', US_Upper( LOC_cParam ) ) ) > 0
            LOC_cParam := US_WordDel( LOC_cParam, nPos )
            PUB_bLite := .T.
         ENDIF
         IF ( nPos := US_WordPos( '-FORCEFULL', US_Upper( LOC_cParam ) ) ) > 0
            LOC_cParam := US_WordDel( LOC_cParam, nPos )
            AAdd( PUB_vAutoRun, 'EraseObj()' )
         ENDIF
         AAdd( PUB_vAutoRun, 'EraseALL()' )
         IF ( nPos := US_WordPos( '-EXIT', US_Upper( LOC_cParam ) ) ) > 0
            LOC_cParam := US_WordDel( LOC_cParam, nPos )
            AAdd( PUB_vAutoRun, 'QPM_Exit()' )
            bWaitForBuild := .F. 
            bAutoExit     := .T.
            IF ( nPos := US_WordStrPos( '-LOG(', US_Upper( LOC_cParam ) ) ) > 0
               LogIni := US_WordInd( LOC_cParam, nPos )
               PUB_cAutoLog := US_WordSubStr( LOC_cParam, nPos )
               PUB_cAutoLog := SubStr( PUB_cAutoLog, 6, At( ')', PUB_cAutoLog ) - 6 )
               IF Empty( PUB_cAutoLog )
                  MyMsgInfo( 'Error detecting log: ' + DBLQT + LOC_cParam + DBLQT )
               ELSE
                  LOC_cParam := SubStr( LOC_cParam, 1, LogIni - 1 ) + SubStr( LOC_cParam, LogIni + Len( PUB_cAutoLog ) + 6 )
                  IF ( nPos := US_WordPos( '-LOGONLYERROR', US_Upper( LOC_cParam ) ) ) > 0
                     LOC_cParam := US_WordDel( LOC_cParam, nPos )
                     PUB_bLogOnlyError := .T.
                  ENDIF
               ENDIF
            ENDIF
         ENDIF
         IF ( nPos := US_WordPos( '-IGNOREVERSIONPROJECT', US_Upper( LOC_cParam ) ) ) > 0
            LOC_cParam := US_WordDel( LOC_cParam, nPos )
            PUB_bIgnoreVersionProject := .T.
         ENDIF
         PUB_cProjectFile := AllTrim( LOC_cParam )
      CASE ( nPos := US_WordPos( '-OPEN', US_Upper( LOC_cParam ) ) ) > 0
         LOC_cParam := US_WordDel( LOC_cParam, nPos )
         AAdd( PUB_vAutoRun, 'QPM_OpenProject(PUB_cProjectFile)' )
         IF ( nPos := US_WordPos( '-FORCEFULL', US_Upper( LOC_cParam ) ) ) > 0
            LOC_cParam := US_WordDel( LOC_cParam, nPos )
            AAdd( PUB_vAutoRun, 'EraseObj()' )
         ENDIF
         IF ( nPos := US_WordPos( '-IGNOREVERSIONPROJECT', US_Upper( LOC_cParam ) ) ) > 0
            LOC_cParam := US_WordDel( LOC_cParam, nPos )
            PUB_bIgnoreVersionProject := .T.
         ENDIF
         PUB_cProjectFile := AllTrim( LOC_cParam )
      OTHERWISE
         AAdd( PUB_vAutoRun, 'QPM_OpenProject(PUB_cProjectFile)' )
         PUB_cProjectFile := AllTrim( LOC_cParam )
      ENDCASE
      IF ! Empty( PUB_cProjectFile )
         PUB_bOpenProjectFromParm := .T.
         IF Empty( US_FileNameOnlyPath( PUB_cProjectFile ) )
            PUB_cProjectFile := GetCurrentFolder() + DEF_SLASH + PUB_cProjectFile
         ENDIF
      ENDIF
   ENDIF

// create log
   IF bAutoExit .AND. ! Empty( PUB_cAutoLog )
      IF RAt( DEF_SLASH, PUB_cAutoLog ) == 0
         PUB_cAutoLog := GetCurrentFolder() + DEF_SLASH + PUB_cAutoLog
      ENDIF
      PUB_cAutoLogTmp := MemoRead( PUB_cAutoLog )
      IF ( i := RAt( Replicate( '=', 80 ) + CRLF, PUB_cAutoLogTmp ) ) > 0
         IF i # Len( PUB_cAutoLogTmp ) - 80 - Len( CRLF ) + 1
            i := 0
         ENDIF
      ENDIF
      IF i == 0
         PUB_cAutoLogTmp += CRLF + Replicate( '=', 80 ) + CRLF
      ENDIF
      PUB_cAutoLogTmp += 'Project file: ' + PUB_cProjectFile + CRLF
      PUB_cAutoLogTmp += US_VarToStr( Date() ) + ' ' + US_VarToStr( Time() ) + CRLF
      QPM_LogText( "Creating Autolog" )
      QPM_MemoWrit( PUB_cAutoLog, PUB_cAutoLogTmp )
      QPM_LogText( "Done" )
   ENDIF

   SET FONT TO 'Arial', 9

   QPM_Wait( 'LoadEnvironment()', 'Loading environment ...' )

   DEFINE WINDOW VentanaMain ;
      AT GetDesktopRealTop(), GetDesktopRealLeft() ;
      WIDTH GetDesktopRealWidth() HEIGHT GetDesktopRealHeight() ;
      TITLE PUB_cQPM_Title + ' [ Project not opened! ]' ;
      ICON 'QPM' ;
      MAIN ;
      ON INIT MainInitAutoRun() ;
      ON RELEASE iif( PUB_bLite, NIL, ( SaveEnvironment( .T. ), CleanAuxFiles() ) );
      ON INTERACTIVECLOSE QPM_Exit( .T. )

      DEFINE TOOLBAR ToolBar_1 OF VentanaMain
      END TOOLBAR

      QPM_DefinoMainMenu()

      DEFINE CONTEXT MENU
#ifdef QPM_SHG
         ITEM '&Move Item'           ACTION SHG_Move_Item()             IMAGE 'US_EditCopy'  NAME ItC_Move
         SEPARATOR
         ITEM '&Copy'                ACTION SHG_Send_Copy()             IMAGE 'US_EditCopy'  NAME ItC_Copy
         ITEM 'C&ut'                 ACTION SHG_Send_Cut()              IMAGE 'US_EditCut'   NAME ItC_Cut
         ITEM '&Paste'               ACTION SHG_Send_Paste()            IMAGE 'US_EditPaste' NAME ItC_Paste
         SEPARATOR
         ITEM '&Select all'          ACTION QPM_Send_SelectAll()                             NAME ItC_SelectAll
         SEPARATOR
         ITEM '&Add to Key List'     ACTION SHG_AddHlpKey()             IMAGE 'add'          NAME ItC_AddHlpKey
         SEPARATOR
         ITEM 'Add Character &&'     ACTION SHG_AddHlpHTML('Ampersand')                      NAME ItC_AddHlpHTMLAmpersand
         ITEM 'Add Character <'      ACTION SHG_AddHlpHTML('Menor')                          NAME ItC_AddHlpHTMLMenor
         ITEM 'Add Character >'      ACTION SHG_AddHlpHTML('Mayor')                          NAME ItC_AddHlpHTMLMayor
         ITEM 'Add Character SPACE'  ACTION SHG_AddHlpHTML('Space')                          NAME ItC_AddHlpHTMLSpace
         SEPARATOR
         ITEM 'Add Image from File'  ACTION SHG_AddHlpHTML('Image')                          NAME ItC_AddHlpHTMLImage
         ITEM 'Add eMail'            ACTION SHG_AddHlpHTML('eMail')                          NAME ItC_AddHlpHTMLeMail
         ITEM 'Add Link to Internet' ACTION SHG_AddHlpHTML('Link')                           NAME ItC_AddHlpHTMLLink
         ITEM 'Add Link to Topic'    ACTION SHG_AddHlpHTML('LinkTopic')                      NAME ItC_AddHlpHTMLLinkTopic
         ITEM 'Add Ancora'           ACTION SHG_AddHlpHTML('Ancora')                         NAME ItC_AddHlpHTMLAncora
#else
         ITEM '&Copy'                ACTION ( US_Send_Copy(), DoEvents() )  IMAGE 'US_EditCopy'  NAME ItC_Copy
         ITEM 'C&ut'                 ACTION ( US_Send_Cut(), DoEvents() )   IMAGE 'US_EditCut'   NAME ItC_Cut
         ITEM '&Paste'               ACTION ( US_Send_Paste(), DoEvents() ) IMAGE 'US_EditPaste' NAME ItC_Paste
         SEPARATOR
         ITEM '&Select all'          ACTION QPM_Send_SelectAll(), DoEvents() )               NAME ItC_SelectAll
#endif
      END MENU

      VentanaMain.ItC_Cut.Enabled := .F.
      VentanaMain.ItC_Paste.Enabled := .F.
      VentanaMain.ItC_CutM.Enabled := .F.
      VentanaMain.ItC_PasteM.Enabled := .F.
#ifdef QPM_SHG
      VentanaMain.ItC_Move.Enabled := .F.
      VentanaMain.ItC_AddHlpKey.Enabled := .F.
      VentanaMain.ItC_AddHlpHTMLAmpersand.Enabled := .F.
      VentanaMain.ItC_AddHlpHTMLMenor.Enabled := .F.
      VentanaMain.ItC_AddHlpHTMLMayor.Enabled := .F.
      VentanaMain.ItC_AddHlpHTMLSpace.Enabled := .F.
      VentanaMain.ItC_AddHlpHTMLImage.Enabled := .F.
      VentanaMain.ItC_AddHlpHTMLeMail.Enabled := .F.
      VentanaMain.ItC_AddHlpHTMLLink.Enabled := .F.
      VentanaMain.ItC_AddHlpHTMLLinkTopic.Enabled := .F.
      VentanaMain.ItC_AddHlpHTMLAncora.Enabled := .F.
#endif

      @ iif( IsXPThemeActive(), 54, 47 ), 1 FRAME FFrame ;
         WIDTH ( GetDesktopRealWidth() - 9 ) ;
         HEIGHT ( GetDesktopRealHeight() - 105 )

#ifndef QPM_SYNCRECOVERY
      DEFINE BUTTONEX EraseALL
         ROW 63
         COL 10
         WIDTH 135
         HEIGHT 25
         PICTURE 'clearall'
         TOOLTIP 'Delete ALL existing object folders.'
         ONCLICK EraseALL()
      END BUTTONEX
#else
      DEFINE BUTTONEX BTakeSyncRecovery
         ROW 63
         COL 10
         WIDTH 65
         HEIGHT 25
         PICTURE 'SyncRec'
         TOOLTIP 'Force the taking of a Sync Recovery Point for this project.'
         ONCLICK QPM_ForceSyncRecovery()
      END BUTTONEX

      DEFINE BUTTONEX EraseALL
         ROW 63
         COL 80
         WIDTH 65
         HEIGHT 25
         PICTURE 'clearall'
         TOOLTIP 'Delete ALL existing object folders.'
         ONCLICK EraseALL()
      END BUTTONEX
#endif

      DEFINE BUTTONEX EraseOBJ
         ROW 63
         COL 150
         WIDTH 170
         HEIGHT 25
         PICTURE 'force'
         TOOLTIP 'Force recompilation of all programs in the project.'
         ONCLICK EraseOBJ()
      END BUTTONEX

      DEFINE TAB TabGrids ;
         OF VentanaMain ;
         AT 95, 10 ;
         WIDTH 310 ;
         HEIGHT ( GetDesktopRealHeight() - 165 ) ;
         ON CHANGE TabChange( 'GRIDS' )

         DEFINE PAGE PagePRG
            DEFINE LABEL LProjectFolder
               ROW 40
               COL 12
               WIDTH 89
               VALUE 'Project Folder:'
               TRANSPARENT iif( IsXPThemeActive(), .T., .F. )
            END LABEL

            DEFINE TEXTBOX TProjectFolder
               ROW 40
               COL 102
               WIDTH 160
               ON CHANGE iif( Right( PUB_cProjectFolder := AllTrim( US_FileNameOnlyPath( GetProperty( 'VentanaMain', 'TProjectFolder', 'Value' ) ) ), 1 ) == DEF_SLASH, ;
                              PUB_cProjectFolder := Left( PUB_cProjectFolder, Len( PUB_cProjectFolder ) - 1 ), ;
                              NIL )
            END TEXTBOX

            DEFINE BUTTONEX BProjectFolder
               ROW 40
               COL 270
               WIDTH 25
               HEIGHT 25
               PICTURE 'folderselect'
               TOOLTIP "Select project's folder."
               ONCLICK ( iif( ! Empty( Folder := GetFolder( 'Select Folder', VentanaMain.TProjectFolder.Value ) ), ;
                              VentanaMain.TProjectFolder.Value := Folder, ;
                              NIL), ;
                         QPM_CheckFiles() )
            END BUTTONEX

            DEFINE LABEL LRunProjectFolder
               ROW 70
               COL 12
               WIDTH 89
               VALUE 'Run Folder:'
               TRANSPARENT iif( IsXPThemeActive(), .T., .F. )
            END LABEL

            DEFINE TEXTBOX TRunProjectFolder
               ROW 70
               COL 102
               WIDTH 160
            END TEXTBOX

            DEFINE BUTTONEX BRunProjectFolder
               ROW 70
               COL 270
               WIDTH 25
               HEIGHT 25
               PICTURE 'folderselect'
               TOOLTIP "Select project's run folder."
               ONCLICK iif( ! Empty( Folder := GetFolder( 'Select Folder', VentanaMain.TRunProjectFolder.Value ) ), ;
                            VentanaMain.TRunProjectFolder.Value := Folder, ;
                            NIL )
            END BUTTONEX

            DEFINE BUTTONEX BPrgAdd
               ROW 100
               COL 12
               WIDTH 65
               HEIGHT 25
               PICTURE 'add'
               TOOLTIP 'Add file to project.'
               ONCLICK QPM_AddFilesPRG()
            END BUTTONEX

#ifndef QPM_HOTRECOVERYWINDOW
            DEFINE BUTTONEX BPrgRemove
               ROW 100
               COL 85
               WIDTH 65
               HEIGHT 25
               PICTURE 'remove'
               TOOLTIP 'Remove file from project.'
               ONCLICK QPM_RemoveFilePRG()
            END BUTTONEX
#else
            DEFINE BUTTONEX BPrgRemove
               ROW 100
               COL 85
               WIDTH 30
               HEIGHT 25
               PICTURE 'remove'
               TOOLTIP 'Remove file from project.'
               ONCLICK QPM_RemoveFilePRG()
            END BUTTONEX

            DEFINE BUTTONEX BPrgHotRecovery
               ROW 100
               COL 120
               WIDTH 30
               HEIGHT 25
               PICTURE 'hotrec'
               TOOLTIP 'Save a Hot Recovery Version for the selected source'
               ONCLICK QPM_ForceHotRecovery( 'PRG' )
            END BUTTONEX
#endif

            DEFINE BUTTONEX BPrgEdit
               ROW 100
               COL 158
               WIDTH 65
               HEIGHT 25
               PICTURE 'Edit'
               TOOLTIP 'Edit selected file.'
               ONCLICK QPM_EditPRG()
            END BUTTONEX

            DEFINE BUTTONEX SetTopPRG
               ROW 100
               COL 230
               WIDTH 30
               HEIGHT 25
               PICTURE 'SetTop'
               TOOLTIP "Set the selected file as Project's " + DBLQT + "Top File" + DBLQT + "."
               ONCLICK QPM_SetTopPRG()
            END BUTTONEX

            DEFINE BUTTONEX ForceRecompPRG
               ROW 100
               COL 265
               WIDTH 30
               HEIGHT 25
               PICTURE 'ForceRecomp'
               TOOLTIP 'Toggle the "Forced Recompilation" switch of the selected file.'
               ONCLICK QPM_ForceRecompPRG()
            END BUTTONEX

            DEFINE BUTTONEX BSortPRG
               ROW 130
               COL 12
               WIDTH 65
               HEIGHT 25
               PICTURE 'Sort'
               TOOLTIP "Sort files in alphabetical order. Note that the " + DBLQT + "Top File" + DBLQT + "will remain unchanged."
               ONCLICK SortPRG( 'VentanaMain', 'GPrgFiles', NCOLPRGNAME )
            END BUTTONEX

            DEFINE BUTTONEX BVerChange
               ROW 130
               COL 85
               WIDTH 55
               HEIGHT 25
               PICTURE 'ChangeVersion'
               TOOLTIP "Change project's version, release and/or build numbers."
               ONCLICK QPM_ChangePrj_Version()
            END BUTTONEX

            DEFINE LABEL LVerTitle
               ROW 135
               COL 145
               VALUE 'Version'
               WIDTH 45
               HEIGHT 25
               FONTCOLOR DEF_COLORGREEN
               TRANSPARENT iif( IsXPThemeActive(), .T., .F. )
            END LABEL

            DEFINE LABEL LVerVerNum
               ROW 135
               COL 193
               VALUE Replicate( '0', DEF_LEN_VER_VERSION )
               WIDTH 15
               HEIGHT 25
               FONTBOLD .T.
               FONTCOLOR DEF_COLORGREEN
               TRANSPARENT iif( IsXPThemeActive(), .T., .F. )
            END LABEL

            DEFINE LABEL LVerPoint
               ROW 135
               COL 208
               VALUE '.'
               WIDTH 5
               HEIGHT 25
               FONTCOLOR DEF_COLORGREEN
               TRANSPARENT iif( IsXPThemeActive(), .T., .F. )
            END LABEL

            DEFINE LABEL LVerRelNum
               ROW 135
               COL 212
               VALUE Replicate( '0', DEF_LEN_VER_RELEASE )
               WIDTH 15
               HEIGHT 25
               FONTBOLD .T.
               FONTCOLOR DEF_COLORGREEN
               TRANSPARENT iif( IsXPThemeActive(), .T., .F. )
            END LABEL

            DEFINE LABEL LVerBui
               ROW 135
               COL 230
               VALUE 'Build'
               WIDTH 30
               HEIGHT 25
               FONTCOLOR DEF_COLORBLUE
               TRANSPARENT iif( IsXPThemeActive(), .T., .F. )
            END LABEL

            DEFINE LABEL LVerBuiNum
               ROW 135
               COL 265
               VALUE Replicate( '0', DEF_LEN_VER_BUILD )
               WIDTH 30
               HEIGHT 25
               FONTBOLD .T.
               FONTCOLOR DEF_COLORBLUE
               TRANSPARENT iif( IsXPThemeActive(), .T., .F. )
            END LABEL

            DEFINE BUTTONEX BSyncPrg
               ROW 312
               COL 296
               WIDTH 11
               HEIGHT 21
               PICTURE 'SYNC'
               TOOLTIP 'Syncronize tabs.'
               ONCLICK TabSync()
            END BUTTONEX

            DEFINE BUTTONEX BUpPrg
               ROW 160
               COL 12
               WIDTH 11
               HEIGHT 21
               PICTURE 'UP'
               TOOLTIP 'Move the selected file up in the list.'
               ONCLICK UpPrg()
            END BUTTONEX

            DEFINE BUTTONEX BDownPrg
               ROW 190
               COL 12
               WIDTH 11
               HEIGHT 21
               PICTURE 'DOWN'
               TOOLTIP 'Move the selected file down in the list.'
               ONCLICK DownPrg()
            END BUTTONEX

            DEFINE BUTTONEX BUpPrg2
               ROW GetDesktopRealHeight() - 237
               COL 12
               WIDTH 11
               HEIGHT 21
               PICTURE 'UP'
               TOOLTIP 'Move the selected file up in the list.'
               ONCLICK UpPrg()
            END BUTTONEX

            DEFINE BUTTONEX BDownPrg2
               ROW GetDesktopRealHeight() - 207
               COL 12
               WIDTH 11
               HEIGHT 21
               PICTURE 'DOWN'
               TOOLTIP 'Move the selected file down in the list.'
               ONCLICK DownPrg()
            END BUTTONEX

            // OJO, la altura de este grid se controla tembien desde la funcion ActLibReimp()
            @ 160, 25 GRID GPrgFiles ;
               WIDTH 270 ;
               HEIGHT GetDesktopRealHeight() - 345 ;
               HEADERS { 'S', 'R', 'Src Name', 'Src Full Name', 'Offset', 'Control Edit', 'Hot Recovery' } ;
               WIDTHS { 25, 0, 100, 1000, 20, 20, 20 };
               ITEMS aGridPRG ;
               VALUE 1 ;
               IMAGE vImagesGrid ;
               BACKCOLOR DEF_COLORBACKPRG ;
               ON HEADCLICK { { || SortPRG( 'VentanaMain', 'GPrgFiles', 1 ) }, ;
                              { || SortPRG( 'VentanaMain', 'GPrgFiles', 2 ) }, ;
                              { || SortPRG( 'VentanaMain', 'GPrgFiles', 3 ) }, ;
                              { || SortPRG( 'VentanaMain', 'GPrgFiles', 4 ) } } ;
               ON DBLCLICK { || QPM_EditPRG() } ;
               ON CHANGE { || iif( ! bPrgSorting .AND. ! PUB_bLite, ;
                                   iif( bNumberOnPrg, ;
                                        QPM_Wait( "RichEditDisplay('PRG')", 'Reloading' ), ;
                                        RichEditDisplay('PRG') ), ;
                                   NIL ) } ;
               JUSTIFY { BROWSE_JTFY_LEFT }

            DEFINE CHECKBOX Check_Reimp
               CAPTION 'ReImport from .Lib library (MinGW only)'
               ROW iif( PUB_bW800, 280, 320 )
               COL 30
               WIDTH 250
               HEIGHT 20
               VALUE .F.
               TOOLTIP 'Make ".a" interface library from ".lib" interface library.'
               TRANSPARENT iif( IsXPThemeActive(), .T., .F. )
               ON CHANGE ( SetProperty( 'VentanaMain', 'LReImportLib', 'enabled', GetProperty( 'VentanaMain', 'Check_Reimp', 'Value' ) ), ;
                           SetProperty( 'VentanaMain', 'TReImportLib', 'enabled', GetProperty( 'VentanaMain', 'Check_Reimp', 'Value' ) ), ;
                           SetProperty( 'VentanaMain', 'BReImportLib', 'enabled', GetProperty( 'VentanaMain', 'Check_Reimp', 'Value' ) ) )
            END CHECKBOX

            DEFINE LABEL LReImportLib
               ROW iif( PUB_bW800, 320, 360 )
               COL 30
               VALUE "Input interface '.lib':"
               TRANSPARENT IsXPThemeActive()
            END LABEL

            DEFINE TEXTBOX TReImportLib
               ROW iif( PUB_bW800, 350, 390 )
               COL 30
               WIDTH 220
            END TEXTBOX

            DEFINE BUTTONEX BReImportLib
               ROW iif( PUB_bW800, 350, 390 )
               COL 270
               WIDTH 25
               HEIGHT 25
               PICTURE 'folderselect'
               TOOLTIP 'Select library.'
               ONCLICK iif( Empty( FileName := GetFile( { {'Library (*.lib)','*.lib'} }, ;
                                                           'Select Library for ReImport', ;
                                                           US_FileNameOnlyPath( ChgPathToReal( VentanaMain.TReImportLib.Value ) ), ;
                                                           .T., .F. ) ), ;
                            NIL, ;
                            VentanaMain.TReImportLib.Value := ChgPathToRelative( FileName ) )
            END BUTTONEX

            DEFINE CHECKBOX Check_GuionA
               CAPTION "Add '_' alias (except MinGW)"
               ROW iif( PUB_bW800, 420, 460 )
               COL 30
               WIDTH 250
               HEIGHT 20
               VALUE .F.
               TOOLTIP 'Add "_" alias for MS flavor cdecl functions (BCC32 or Pelles).'
               TRANSPARENT IsXPThemeActive()
            END CHECKBOX

            ActLibReimp()
         END PAGE

         DEFINE PAGE PageHEA
            DEFINE BUTTONEX BHeAAdd
               ROW 40
               COL 12
               WIDTH 65
               HEIGHT 25
               PICTURE 'add'
               TOOLTIP 'Add header.'
               ONCLICK QPM_AddFilesHEA()
            END BUTTONEX

#ifndef QPM_HOTRECOVERYWINDOW
            DEFINE BUTTONEX BHeaRemove
               ROW 40
               COL 85
               WIDTH 65
               HEIGHT 25
               PICTURE 'remove'
               TOOLTIP 'Remove header.'
               ONCLICK QPM_RemoveFileHEA()
            END BUTTONEX
#else
            DEFINE BUTTONEX BHeaRemove
               ROW 40
               COL 85
               WIDTH 30
               HEIGHT 25
               PICTURE 'remove'
               TOOLTIP 'Remove header.'
               ONCLICK QPM_RemoveFileHEA()
            END BUTTONEX

            DEFINE BUTTONEX BHeaHotRecovery
               ROW 40
               COL 120
               WIDTH 30
               HEIGHT 25
               PICTURE 'hotrec'
               TOOLTIP 'Force the saving of a Hot Recovery Version for the selected header.'
               ONCLICK QPM_ForceHotRecovery( 'HEA' )
            END BUTTONEX
#endif

            DEFINE BUTTONEX BHeaEdit
               ROW 40
               COL 158
               WIDTH 65
               HEIGHT 25
               PICTURE 'Edit'
               TOOLTIP 'Modify header.'
               ONCLICK QPM_EditHEA ()
            END BUTTONEX

            DEFINE BUTTONEX BSortHea
               ROW 70
               COL 12
               WIDTH 65
               HEIGHT 25
               PICTURE 'Sort'
               TOOLTIP 'Sort headers in alphabetical order.'
               ONCLICK SortHEA( 'VentanaMain', 'GHeaFiles', NCOLHEANAME )
            END BUTTONEX

            DEFINE BUTTONEX BSyncHea
               ROW 312
               COL 296
               WIDTH 11
               HEIGHT 21
               PICTURE 'SYNC'
               TOOLTIP 'Syncronize tabs.'
               ONCLICK TabSync()
            END BUTTONEX

            DEFINE BUTTONEX BUpHea
               ROW 100
               COL 12
               WIDTH 11
               HEIGHT 21
               PICTURE 'UP'
               TOOLTIP 'Move the selected header up in the list.'
               ONCLICK UpHea()
            END BUTTONEX

            DEFINE BUTTONEX BDownHea
               ROW 130
               COL 12
               WIDTH 11
               HEIGHT 21
               PICTURE 'DOWN'
               TOOLTIP 'Move the selected header down in the list.'
               ONCLICK DownHea()
            END BUTTONEX

            DEFINE BUTTONEX BUpHea2
               ROW GetDesktopRealHeight() - 237
               COL 12
               WIDTH 11
               HEIGHT 21
               PICTURE 'UP'
               TOOLTIP 'Move the selected header up in the list.'
               ONCLICK UpHea()
            END BUTTONEX

            DEFINE BUTTONEX BDownHea2
               ROW GetDesktopRealHeight() - 207
               COL 12
               WIDTH 11
               HEIGHT 21
               PICTURE 'DOWN'
               TOOLTIP 'Move the selected header down in the list.'
               ONCLICK DownHea()
            END BUTTONEX

            @ 100, 25 GRID GHeaFiles ;
               WIDTH 270 ;
               HEIGHT GetDesktopRealHeight() - 285 ;
               HEADERS { 'S', 'Header Name', 'Header Full Name', 'Offset', 'Control Edit', 'Hot Recovery' } ;
               WIDTHS { 25, 100, 1000, 20, 20, 20 };
               ITEMS aGridHea ;
               IMAGE vImagesGrid ;
               VALUE 1 ;
               BACKCOLOR DEF_COLORBACKHEA ;
               ON HEADCLICK { { || SortHEA( 'VentanaMain', 'GHeaFiles', 1 ) }, ;
                              { || SortHEA( 'VentanaMain', 'GHeaFiles', 2 ) }, ;
                              { || SortHEA( 'VentanaMain', 'GHeaFiles', 3 ) }, ;
                              { || SortHEA( 'VentanaMain', 'GHeaFiles', 4 ) } } ;
               ON DBLCLICK { QPM_EditHEA() } ;
               ON CHANGE { || iif( ! bHeaSorting .AND. ! PUB_bLite, ;
                                   iif( bNumberOnHea, QPM_Wait( "RichEditDisplay('HEA')", 'Reloading' ), RichEditDisplay('HEA') ), ;
                                   NIL ) } ;
               JUSTIFY { BROWSE_JTFY_LEFT }
         END PAGE

         DEFINE PAGE PagePAN
            DEFINE BUTTONEX BPanAdd
               ROW 40
               COL 12
               WIDTH 65
               HEIGHT 25
               PICTURE 'add'
               TOOLTIP 'Add form.'
               ONCLICK QPM_AddFilesPAN()
            END BUTTONEX

#ifndef QPM_HOTRECOVERYWINDOW
            DEFINE BUTTONEX BPanRemove
               ROW 40
               COL 85
               WIDTH 65
               HEIGHT 25
               PICTURE 'remove'
               TOOLTIP 'Remove form.'
               ONCLICK QPM_RemoveFilePAN()
            END BUTTONEX
#else
            DEFINE BUTTONEX BPanRemove
               ROW 40
               COL 85
               WIDTH 30
               HEIGHT 25
               PICTURE 'remove'
               TOOLTIP 'Remove form.'
               ONCLICK QPM_RemoveFilePAN()
            END BUTTONEX

            DEFINE BUTTONEX BPanHotRecovery
               ROW 40
               COL 120
               WIDTH 30
               HEIGHT 25
               PICTURE 'hotrec'
               TOOLTIP 'Force the saving of a Hot Recovery Version for the selected form.'
               ONCLICK QPM_ForceHotRecovery( 'PAN' )
            END BUTTONEX
#endif

            DEFINE BUTTONEX BPanEditTool
               ROW 40
               COL 158
               WIDTH 65
               HEIGHT 25
               CAPTION 'With Tool'
               TOOLTIP 'Modify form with associated tool.'
               ONCLICK QPM_EditPAN()
            END BUTTONEX

            DEFINE BUTTONEX BPanEditEditor
               ROW 40
               COL 230
               WIDTH 65
               HEIGHT 25
               CAPTION 'With Edit'
               TOOLTIP 'Open form with associated editor.'
               ONCLICK QPM_EditPAN( .T. )
            END BUTTONEX

            DEFINE BUTTONEX BSortPan
               ROW 70
               COL 12
               WIDTH 65
               HEIGHT 25
               PICTURE 'Sort'
               TOOLTIP 'Sort forms in alphabetical order.'
               ONCLICK SortPAN( 'VentanaMain', 'GPanFiles', NCOLPANNAME )
            END BUTTONEX

            DEFINE BUTTONEX BEditRC
               ROW 70
               COL 85
               WIDTH 209
               HEIGHT 25
               CAPTION 'Edit Main .RC'
               TOOLTIP "Edit the project's main resource file."
               ONCLICK QPM_EditRES()
            END BUTTONEX

            DEFINE CHECKBOX Check_Place
               CAPTION 'Place Main .RC First'
               ROW 100
               COL 12
               WIDTH 282
               HEIGHT 25
               VALUE .T.
               TOOLTIP "The Main .RC content will be placed before the MINIGUI's .RC content."
               TRANSPARENT IsXPThemeActive()
               ON CHANGE Prj_Check_PlaceRCFirst := VentanaMain.Check_Place.Value
            END CHECKBOX

            DEFINE CHECKBOX Check_NoMainRC
               CAPTION "Don't compile Main .RC"
               ROW 130
               COL 12
               WIDTH 282
               HEIGHT 25
               VALUE .T.
               TOOLTIP "Check this to ignore the Main .RC when building the project."
               TRANSPARENT IsXPThemeActive()
               ON CHANGE Prj_Check_IgnoreMainRC := VentanaMain.Check_NoMainRC.Value
            END CHECKBOX

            DEFINE CHECKBOX Check_NoLibRCs
               CAPTION "Don't compile MINIGUI's .RC files"
               ROW 160
               COL 12
               WIDTH 282
               HEIGHT 25
               VALUE .T.
               TOOLTIP "Check this to ignore the MINIGUI's .RC files when building the project."
               TRANSPARENT IsXPThemeActive()
               ON CHANGE Prj_Check_IgnoreLibRCs := VentanaMain.Check_NoLibRCs.Value
            END CHECKBOX

            DEFINE BUTTONEX BSyncPan
               ROW 312
               COL 296
               WIDTH 11
               HEIGHT 21
               PICTURE 'SYNC'
               TOOLTIP 'Syncronize tabs.'
               ONCLICK TabSync()
            END BUTTONEX

            DEFINE BUTTONEX BUpPan
               ROW 100
               COL 12
               WIDTH 11
               HEIGHT 21
               PICTURE 'UP'
               TOOLTIP 'Move the selected form up the list.'
               ONCLICK UpPan()
            END BUTTONEX

            DEFINE BUTTONEX BDownPan
               ROW 130
               COL 12
               WIDTH 11
               HEIGHT 21
               PICTURE 'DOWN'
               TOOLTIP 'Move the selected form down the list.'
               ONCLICK DownPan()
            END BUTTONEX

            DEFINE BUTTONEX BUpPan2
               ROW GetDesktopRealHeight() - 237
               COL 12
               WIDTH 11
               HEIGHT 21
               PICTURE 'UP'
               TOOLTIP 'Move the selected form up the list.'
               ONCLICK UpPan()
            END BUTTONEX

            DEFINE BUTTONEX BDownPan2
               ROW GetDesktopRealHeight() - 207
               COL 12
               WIDTH 11
               HEIGHT 21
               PICTURE 'DOWN'
               TOOLTIP 'Move the selected form down the list.'
               ONCLICK DownPan()
            END BUTTONEX

            @ 220, 25 GRID GPanFiles ;
               WIDTH 270 ;
               HEIGHT GetDesktopRealHeight() - 405 ;
               HEADERS { 'S', 'Form Name', 'Form Full Name', 'Offset', 'Control Edit', 'Hot Recovery' } ;
               WIDTHS { 25, 100, 1000, 20, 20, 20 };
               ITEMS aGridPan ;
               VALUE 1 ;
               IMAGE vImagesGrid ;
               BACKCOLOR DEF_COLORBACKPAN ;
               ON HEADCLICK { { || SortPAN( 'VentanaMain', 'GPanFiles', 1 ) }, ;
                              { || SortPAN( 'VentanaMain', 'GPanFiles', 2 ) }, ;
                              { || SortPAN( 'VentanaMain', 'GPanFiles', 3 ) }, ;
                              { || SortPAN( 'VentanaMain', 'GPanFiles', 4 ) } } ;
               ON DBLCLICK { QPM_EditPAN() } ;
               ON CHANGE { || iif( ! bPanSorting .AND. ! PUB_bLite, ;
                                   iif( bNumberOnPan, QPM_Wait( "RichEditDisplay('PAN')", 'Reloading' ), RichEditDisplay('PAN') ), ;
                                   NIL ) } ;
               JUSTIFY { BROWSE_JTFY_LEFT }
         END PAGE

         DEFINE PAGE PageDBF
            DEFINE BUTTONEX BDbfAdd
               ROW 40
               COL 12
               WIDTH 65
               HEIGHT 25
               PICTURE 'add'
               TOOLTIP 'Add DBF file.'
               ONCLICK QPM_AddFilesDBF()
            END BUTTONEX

            DEFINE BUTTONEX BDbfRemove
               ROW 40
               COL 85
               WIDTH 65
               HEIGHT 25
               PICTURE 'remove'
               TOOLTIP 'Remove DBF file.'
               ONCLICK QPM_RemoveFileDBF()
            END BUTTONEX

            DEFINE BUTTONEX BDbfEditTool
               ROW 40
               COL 158
               WIDTH 65
               HEIGHT 25
               PICTURE 'Edit'
               TOOLTIP 'Modify DBF file with associated tool.'
               ONCLICK QPM_EditDBF()
            END BUTTONEX

            DEFINE BUTTONEX BSortDbf
               ROW 70
               COL 12
               WIDTH 65
               HEIGHT 25
               PICTURE 'Sort'
               TOOLTIP 'Sort DBF files in alphabetical order.'
               ONCLICK SortDBF( 'VentanaMain', 'GDbfFiles', NCOLDBFNAME )
            END BUTTONEX

            DEFINE BUTTONEX BSyncDbf
               ROW 312
               COL 296
               WIDTH 11
               HEIGHT 21
               PICTURE 'SYNC'
               TOOLTIP 'Syncronize tabs.'
               ONCLICK TabSync()
            END BUTTONEX

            DEFINE BUTTONEX BUpDbf
               ROW 100
               COL 12
               WIDTH 11
               HEIGHT 21
               PICTURE 'UP'
               TOOLTIP 'Move the selected DBF file up in the list.'
               ONCLICK UpDbf()
            END BUTTONEX

            DEFINE BUTTONEX BDownDbf
               ROW 130
               COL 12
               WIDTH 11
               HEIGHT 21
               PICTURE 'DOWN'
               TOOLTIP 'Move the selected DBF file down in the list.'
               ONCLICK DownDbf()
            END BUTTONEX

            DEFINE BUTTONEX BUpDbf2
               ROW GetDesktopRealHeight() - 237
               COL 12
               WIDTH 11
               HEIGHT 21
               PICTURE 'UP'
               TOOLTIP 'Move the selected DBF file up in the list.'
               ONCLICK UpDbf()
            END BUTTONEX

            DEFINE BUTTONEX BDownDbf2
               ROW GetDesktopRealHeight() - 207
               COL 12
               WIDTH 11
               HEIGHT 21
               PICTURE 'DOWN'
               TOOLTIP 'Move the selected DBF file down in the list.'
               ONCLICK DownDbf()
            END BUTTONEX

            @ 100, 25 GRID GDbfFiles ;
               WIDTH 270 ;
               HEIGHT GetDesktopRealHeight() - 285 ;
               HEADERS { 'S', 'Dbf Name', 'Dbf Full Name', 'Offset', 'Control Edit', 'Search' } ;
               WIDTHS { 25, 100, 1000, 20, 20, 20 };
               ITEMS aGridDbf ;
               VALUE 1 ;
               IMAGE vImagesGrid ;
               BACKCOLOR DEF_COLORBACKDBF ;
               ON HEADCLICK { { || SortDBF( 'VentanaMain', 'GDbfFiles', 1 ) }, ;
                              { || SortDBF( 'VentanaMain', 'GDbfFiles', 2 ) }, ;
                              { || SortDBF( 'VentanaMain', 'GDbfFiles', 3 ) }, ;
                              { || SortDBF( 'VentanaMain', 'GDbfFiles', 4 ) } } ;
               ON DBLCLICK { QPM_EditDBF() } ;
               ON CHANGE { || iif( ! bDbfSorting .AND. ! PUB_bLite, QPM_Wait( "RichEditDisplay( 'DBF', .T. )", 'Loading ...' ), NIL ) } ;
               JUSTIFY { BROWSE_JTFY_LEFT }
         END PAGE

         DEFINE PAGE PageLIB
            @ 25, 6 LABEL LDefLabel ;
               VALUE 'Default:' ;
               WIDTH 155 ;
               HEIGHT 20 ;
               FONT 'arial' SIZE 10 BOLD ;
               TRANSPARENT ;
               FONTCOLOR DEF_COLORBLUE

            DEFINE BUTTONEX BDefAdd
               ROW 45
               COL 6
               WIDTH 53
               HEIGHT 25
               PICTURE 'add'
               TOOLTIP 'Add file.'
               ONCLICK QPM_AddDefaultLibs()
            END BUTTONEX

            DEFINE BUTTONEX BDefRemove
               ROW 45
               COL 65
               WIDTH 53
               HEIGHT 25
               PICTURE 'remove'
               TOOLTIP 'Remove file.'
               ONCLICK QPM_RemoveDefaultLIB()
            END BUTTONEX

            DEFINE BUTTONEX BDefMode
               ROW 45
               COL 124
               WIDTH 53
               HEIGHT 25
               CAPTION 'Mode'
               TOOLTIP 'Select between Console, GUI or both modes.'
               ONCLICK ToggleDefMode()
            END BUTTONEX

            DEFINE BUTTONEX BDefThreads
               ROW 45
               COL 183
               WIDTH 53
               HEIGHT 25
               CAPTION 'Thread'
               TOOLTIP 'Select between for ST, MT or both modes.'
               ONCLICK ToggleDefThreads()
            END BUTTONEX

            DEFINE BUTTONEX BDefDebug
               ROW 45
               COL 242
               WIDTH 53
               HEIGHT 25
               CAPTION 'Debug'
               TOOLTIP 'Select between Debug, Non-debug or both modes.'
               ONCLICK ToggleDefDebug()
            END BUTTONEX

            DEFINE BUTTONEX BUpDefOrder
               ROW 75
               COL 6
               WIDTH 11
               HEIGHT 21
               PICTURE 'UP'
               TOOLTIP 'Move the selected item up in the list.'
               ONCLICK UpLibDefault()
            END BUTTONEX

            DEFINE BUTTONEX BDownDefOrder
               ROW 105
               COL 6
               WIDTH 11
               HEIGHT 21
               PICTURE 'DOWN'
               TOOLTIP 'Move the selected item down in the list.'
               ONCLICK DownLibDefault()
            END BUTTONEX

            @ 75, 19 GRID GDefFiles ;
               WIDTH 276 ;
               HEIGHT 170 ;
               HEADERS { 'S', 'Name', 'Mode', 'Threads', 'Debug'} ;
               WIDTHS { 25, 100, 40, 40, 40 };
               ITEMS aGridDef ;
               VALUE 1 ;
               IMAGE vImagesGrid ;
               BACKCOLOR DEF_COLORBACKDEF ;
               ON CHANGE { || iif( ! PUB_bLite, RichEditDisplay('DEF'), NIL ) } ;
               JUSTIFY { BROWSE_JTFY_LEFT }

            @ 250, 6 LABEL LLibLabel ;
               VALUE 'Include:' ;
               WIDTH 155 ;
               FONT 'arial' SIZE 10 BOLD ;
               TRANSPARENT ;
               FONTCOLOR DEF_COLORBLUE

            DEFINE BUTTONEX BLibAdd
               ROW 270
               COL 6
               WIDTH 53
               HEIGHT 25
               PICTURE 'add'
               TOOLTIP 'Add file.'
               ONCLICK QPM_AddIncludeLibs()
            END BUTTONEX

            DEFINE BUTTONEX BLibRemove
               ROW 270
               COL 65
               WIDTH 53
               HEIGHT 25
               PICTURE 'remove'
               TOOLTIP 'Remove file.'
               ONCLICK QPM_RemoveFileLIB()
            END BUTTONEX

            DEFINE BUTTONEX BFirst
               ROW 270
               COL 124
               WIDTH 53
               HEIGHT 25
               CAPTION 'First'
               TOOLTIP 'Move the selected item to the first position of the concatenation order.'
               ONCLICK LibPos( VentanaMain.GIncFiles.Value, '*FIRST*' )
            END BUTTONEX

            DEFINE BUTTONEX BLast
               ROW 270
               COL 183
               WIDTH 53
               HEIGHT 25
               CAPTION 'Last'
               TOOLTIP 'Move the selected item to last position of the concatenation order (default).'
               ONCLICK LibPos( VentanaMain.GIncFiles.Value, '*LAST*' )
            END BUTTONEX

            DEFINE BUTTONEX BUpLibInclude
               ROW 300
               COL 6
               WIDTH 11
               HEIGHT 21
               PICTURE 'UP'
               TOOLTIP 'Move the selected item up in the list.'
               ONCLICK UpLibInclude()
            END BUTTONEX

            DEFINE BUTTONEX BDownLibInclude
               ROW 330
               COL 6
               WIDTH 11
               HEIGHT 21
               PICTURE 'DOWN'
               TOOLTIP 'Move the selected item down in the list.'
               ONCLICK DownLibInclude()
            END BUTTONEX

            @ 300, 19 GRID GIncFiles ;
               WIDTH 276 ;
               HEIGHT 150 ;
               HEADERS { 'S', 'Name', 'Full Name'} ;
               WIDTHS { 25, 100, 1000 };
               ITEMS aGridInc ;
               VALUE 1 ;
               IMAGE vImagesGrid ;
               BACKCOLOR DEF_COLORBACKINC ;
               ON DBLCLICK { LibInfo() } ;
               ON CHANGE { || iif( ! PUB_bLite, RichEditDisplay('INC'), NIL ) } ;
               JUSTIFY { BROWSE_JTFY_LEFT }

            DEFINE BUTTONEX BSyncLib
               ROW 332
               COL 296
               WIDTH 11
               HEIGHT 21
               PICTURE 'SYNC'
               TOOLTIP 'Syncronize tabs.'
               ONCLICK TabSync()
            END BUTTONEX

            @ 455, 6 LABEL LLibLabel_e ;
               VALUE 'Exclude:' ;
               WIDTH 155 ;
               FONT 'arial' SIZE 10 BOLD ;
               TRANSPARENT ;
               FONTCOLOR DEF_COLORBLUE

            DEFINE BUTTONEX BLibAdd_E
               ROW 475
               COL 6
               WIDTH 55
               HEIGHT 25
               PICTURE 'add'
               TOOLTIP 'Add file.'
               ONCLICK QPM_AddExcludeLibs()
            END BUTTONEX

            DEFINE BUTTONEX BLibRemove_E
               ROW 475
               COL 67
               WIDTH 55
               HEIGHT 25
               PICTURE 'remove'
               TOOLTIP 'Remove file.'
               ONCLICK QPM_RemoveExcludeFileLIB()
            END BUTTONEX

            DEFINE BUTTONEX BSortExc
               ROW 475
               COL 128
               WIDTH 55
               HEIGHT 25
               PICTURE 'Sort'
               TOOLTIP 'Sort excluded libs in alphabetical order.'
               ONCLICK SortEXC( 'VentanaMain', 'GExcFiles', NCOLEXCNAME )
            END BUTTONEX

            DEFINE BUTTONEX BHelpExc
               ROW 475
               COL 242
               WIDTH 53
               HEIGHT 25
               PICTURE 'HELPBMP'
               ONCLICK US_DisplayHelpTopic( GetActiveHelpFile(), 'libsconfig' )
            END BUTTONEX

            DEFINE BUTTONEX BUpLibExclude
               ROW 505
               COL 6
               WIDTH 11
               HEIGHT 21
               PICTURE 'UP'
               TOOLTIP 'Move the selected lib up in the list.'
               ONCLICK UpLibExclude()
            END BUTTONEX

            DEFINE BUTTONEX BDownLibExclude
               ROW 535
               COL 6
               WIDTH 11
               HEIGHT 21
               PICTURE 'DOWN'
               TOOLTIP 'Move the selected lib down in the list.'
               ONCLICK DownLibExclude()
            END BUTTONEX

            @ 505, 19 GRID GExcFiles ;
               WIDTH 276 ;
               HEIGHT 150 ;
               HEADERS { 'S', 'Name' } ;
               WIDTHS { 25, 200 };
               ITEMS aGridExc ;
               VALUE 1 ;
               IMAGE vImagesGrid ;
               BACKCOLOR DEF_COLORBACKEXC ;
               ON HEADCLICK { { || SortEXC( 'VentanaMain', 'GExcFiles', 1) }, { || SortEXC( 'VentanaMain', 'GExcFiles', 2) } } ;
               ON DBLCLICK { LibExcludeInfo() } ;
               JUSTIFY { BROWSE_JTFY_LEFT }
         END PAGE

#ifdef QPM_SHG
         DEFINE PAGE PageHlp
            DEFINE LABEL LHlpDataBase
               ROW 40
               COL 12
               VALUE 'SHG Database:'
               TRANSPARENT IsXPThemeActive()
            END LABEL

            DEFINE TEXTBOX THlpDataBase
               ROW 40
               COL 132
               WIDTH 130
            END TEXTBOX

            DEFINE BUTTONEX BHlpDataBase
               ROW 40
               COL 270
               WIDTH 25
               HEIGHT 25
               PICTURE 'folderselect'
               TOOLTIP 'Select SHG database.'
               ONCLICK ( SHG_GetDatabase(), iif( SHG_BaseOK, SetProperty( 'VentanaMain', 'RichEditHlp', 'readonly', .F. ), NIL ) )
            END BUTTONEX

            DEFINE LABEL LWWWHlp
               ROW 70
               COL 12
               VALUE 'Footer Link:'
               TRANSPARENT IsXPThemeActive()
            END LABEL

            DEFINE TEXTBOX TWWWHlp
               ROW 70
               COL 132
               WIDTH 163
               TOOLTIP 'Defaults to "Powered by QPM (https://teamqpm.github.io/)".'
            END TEXTBOX

            DEFINE BUTTONEX BHlpAdd
               ROW 100
               COL 12
               WIDTH 65
               HEIGHT 25
               PICTURE 'add'
               TOOLTIP 'Add topic.'
               ONCLICK QPM_AddFilesHLP()
            END BUTTONEX

            DEFINE BUTTONEX BHlpRemove
               ROW 100
               COL 85
               WIDTH 65
               HEIGHT 25
               PICTURE 'remove'
               TOOLTIP 'Remove topic.'
               ONCLICK QPM_RemoveFileHLP()
            END BUTTONEX

            DEFINE BUTTONEX BHlpEdit
               ROW 100
               COL 158
               WIDTH 65
               HEIGHT 25
               PICTURE 'Edit'
               TOOLTIP "Edit topic's name."
               ONCLICK QPM_EditHLP ()
            END BUTTONEX

            DEFINE BUTTONEX SetTestHlp
               ROW 100
               COL 230
               WIDTH 65
               HEIGHT 25
               PICTURE 'TEST'
               TOOLTIP 'Test CHM file.'
               ONCLICK SHG_DisplayHelp( SHG_GetOutputName() )
               BACKCOLOR WHITE
            END BUTTONEX

            DEFINE BUTTONEX BToggle
               ROW 130
               COL 12
               WIDTH 65
               HEIGHT 25
               CAPTION 'Toggle'
               TOOLTIP "Toggle topic's type (Book or Page)."
               ONCLICK SHG_Toggle()
            END BUTTONEX

            DEFINE BUTTONEX HlpCheckSave
               ROW 130
               COL 85
               WIDTH 65
               HEIGHT 25
               CAPTION 'Save all?'
               TOOLTIP 'Save all unsaved topics.'
               ONCLICK QPM_WAIT( 'SHG_CheckSave()', 'Checking for save ...' )
            END BUTTONEX

            DEFINE BUTTONEX HlpClose
               ROW 130
               COL 158
               WIDTH 65
               HEIGHT 25
               CAPTION 'Close'
               TOOLTIP 'Close SHG database.'
               ONCLICK SHG_Close()
            END BUTTONEX

            DEFINE BUTTONEX HlpGenerate
               ROW 130
               COL 230
               WIDTH 65
               HEIGHT 25
               CAPTION 'Generate'
               TOOLTIP 'Generate help file in CHM format.'
               ONCLICK QPM_Wait( "SHG_Generate( SHG_Database, SHG_CheckTypeOutput, PUB_cSecu, GetProperty( 'VentanaMain', 'TWWWHlp', 'Value' ) )", 'Generating Help ...' )
            END BUTTONEX

            DEFINE BUTTONEX BSyncHlp
               ROW 312
               COL 296
               WIDTH 11
               HEIGHT 21
               PICTURE 'SYNC'
               TOOLTIP 'Syncronize tabs.'
               ONCLICK TabSync()
            END BUTTONEX

            DEFINE BUTTONEX BUpHlp
               ROW 160
               COL 12
               WIDTH 11
               HEIGHT 21
               PICTURE 'UP'
               TOOLTIP 'Move the selected topic up in the list.'
               ONCLICK UpHlp()
            END BUTTONEX

            DEFINE BUTTONEX BDownHlp
               ROW 190
               COL 12
               WIDTH 11
               HEIGHT 21
               PICTURE 'DOWN'
               TOOLTIP 'Move the selected topic down in the list.'
               ONCLICK DownHlp()
            END BUTTONEX

            DEFINE BUTTONEX BUpHlp2
               ROW GetDesktopRealHeight() - 237
               COL 12
               WIDTH 11
               HEIGHT 21
               PICTURE 'UP'
               TOOLTIP 'Move the selected topic up in the list.'
               ONCLICK UpHlp()
            END BUTTONEX

            DEFINE BUTTONEX BDownHlp2
               ROW GetDesktopRealHeight() - 207
               COL 12
               WIDTH 11
               HEIGHT 21
               PICTURE 'DOWN'
               TOOLTIP 'Move the selected topic down in the list.'
               ONCLICK DownHlp()
            END BUTTONEX

            @ 160, 25 GRID GHlpFiles ;
               WIDTH 270 ;
               HEIGHT GetDesktopRealHeight() - 345 ;
               HEADERS { 'I', 'Topic', 'Nick Name', 'Offset', 'Control Edit' } ;
               WIDTHS { 25, 1000, 0, 20, 20 };
               ITEMS aGridHlp ;
               VALUE 0 ;
               IMAGE vImagesGrid ;
               BACKCOLOR DEF_COLORBACKHLP ;
               ON DBLCLICK { QPM_EditHLP() } ;
               ON CHANGE { || SetProperty( 'VentanaMain', 'GHlpFilesItem', 'value', 'Current item: ' + LTrim( Str( VentanaMain.GHlpFiles.Value ) ) ), ;
                              iif( ! bHlpSorting .AND. ! PUB_bLite, ( RichEditDisplay( 'HLP' ), OcultaHlpKeys() ), NIL ) } ;
               JUSTIFY { BROWSE_JTFY_LEFT }

            @ 160 + GetDesktopRealHeight() - 345 + 2, 25 LABEL GHlpFilesItem ;
               WIDTH 270 ;
               HEIGHT 20 ;
               VALUE '' ;
               FONT 'arial' SIZE 8 ;
               FONTCOLOR DEF_COLORBLUE
         END PAGE
#endif
      END TAB

      ProjectButtons( .F. )

      DEFINE LABEL LStatusLabel
         ROW 15
         COL iif( IsXPThemeActive(), 363, 335 )
         WIDTH iif( IsXPThemeActive(), 70, 80 )
         HEIGHT 18
         VALUE PUB_cStatusLabel
         TRANSPARENT IsXPThemeActive()
      END LABEL

      DEFINE LABEL LResumen
         ROW 09
         COL 433
         HEIGHT 18
         WIDTH 600
         VALUE ''
         FONTNAME 'arial'
         FONTSIZE 10
         FONTBOLD .T.
         FONTCOLOR DEF_COLORBLUE
         TRANSPARENT IsXPThemeActive()
      END LABEL

      DEFINE LABEL LFull
         ROW 28
         COL 433
         HEIGHT 18
         WIDTH 160
         VALUE ''
         FONTNAME 'arial'
         FONTSIZE 10
         FONTBOLD .T.
         FONTCOLOR DEF_COLORGREEN
         TRANSPARENT IsXPThemeActive()
      END LABEL

      DEFINE LABEL LExtra
         ROW 28
         COL 600
         WIDTH 200
         HEIGHT 18
         VALUE ''
         FONTNAME 'arial'
         FONTSIZE 10
         FONTBOLD .T.
         FONTCOLOR DEF_COLORBLACK
         TRANSPARENT IsXPThemeActive()
      END LABEL

      DEFINE TAB TabFiles ;
         OF VentanaMain ;
         AT 60, 328 ;
         WIDTH ( GetDesktopRealWidth() - 344 ) ;
         HEIGHT ( GetDesktopRealHeight() - 190 ) ;
         VALUE nPagePRG ;
         ON CHANGE TabChange( 'FILES' )

         DEFINE PAGE PagePRG
            DEFINE CHECKBOX Check_AutoSyncPrg
               CAPTION 'Auto Sync'
               ROW 00
               COL ( GetDesktopRealWidth() - 420 )
               WIDTH 70
               HEIGHT 20
               VALUE .T.
               TOOLTIP 'Toggle automatic tab syncronization.'
               ON CHANGE       TabAutoSync('PRG')
            END CHECKBOX

            @ 25, 00 IMAGE IBorde1PRG ;
               PICTURE 'YELLOW' ;
               WIDTH GetDesktopRealWidth() - 348 ;
               HEIGHT GetDesktopRealHeight() - 217 ;
               STRETCH

            @ 35, 10 RICHEDITBOX RichEditPRG ;
               WIDTH GetDesktopRealWidth() - 364 ;
               HEIGHT GetDesktopRealHeight() - 272 ;
               READONLY ;
               FONT 'Courier New' ;
               SIZE 9 ;
               BACKCOLOR DEF_COLORBACKPRG

            DEFINE CHECKBOX Check_NumberOnPrg
               CAPTION 'Line Number'
               ROW GetDesktopRealHeight() - 224
               COL 10
               WIDTH 95
               HEIGHT 20
               VALUE .F.
               TOOLTIP "Check to display line numbers. Please note that loading time will increase."
               ON CHANGE ( bNumberOnPrg := GetProperty( 'VentanaMain', 'Check_NumberOnPrg', 'value' ), ;
                           iif( bPpoDisplayado, QPM_Wait( 'PpoDisplay(.T.)', 'Reloading ...' ), QPM_Wait( "RichEditDisplay( 'PRG', .T. )", 'Reloading ...' ) ) )
            END CHECKBOX

            DEFINE BUTTONEX bReLoadPpo
               ROW GetDesktopRealHeight() - 227
               COL 110
               WIDTH 95
               HEIGHT 25
               CAPTION 'Browse PPO'
               TOOLTIP "Browse the selected file's preprocessor output."
               ONCLICK QPM_Wait( 'PpoDisplay()', 'Reloading ...' )
            END BUTTONEX

            DEFINE BUTTONEX bReLoadPrg
               ROW GetDesktopRealHeight() - 227
               COL 210
               WIDTH GetDesktopRealWidth() - 630
               HEIGHT 25
               CAPTION 'Reload Source'
               TOOLTIP 'Reload source from disk.'
               ONCLICK QPM_Wait( "RichEditDisplay( 'PRG', .T. )", 'Reloading ...' )
            END BUTTONEX

            DEFINE BUTTONEX BLocalSearchPrg
               ROW GetDesktopRealHeight() - 227
               COL GetDesktopRealWidth() - 415
               WIDTH 60
               HEIGHT 25
               CAPTION 'Search'
               TOOLTIP 'Search current data for some text.'
               ONCLICK LocalSearch( GetProperty( 'VentanaMain', 'CSearch', 'DisplayValue' ) )
            END BUTTONEX
         END PAGE

         DEFINE PAGE iif( PUB_bW800, 'Hea', PageHEA )
            DEFINE CHECKBOX Check_AutoSyncHea
               CAPTION 'Auto Sync'
               ROW 00
               COL ( GetDesktopRealWidth() - 420 )
               WIDTH 70
               HEIGHT 20
               VALUE .T.
               TOOLTIP 'Toggle automatic tab syncronization.'
               ON CHANGE TabAutoSync('HEA')
            END CHECKBOX

            @ 25, 00 IMAGE IBorde1HEA ;
               PICTURE 'YELLOW' ;
               WIDTH GetDesktopRealWidth() - 348 ;
               HEIGHT GetDesktopRealHeight() - 217 ;
               STRETCH

            @ 35, 10 RICHEDITBOX RichEditHEA ;
               WIDTH GetDesktopRealWidth() - 364 ;
               HEIGHT GetDesktopRealHeight() - 272 ;
               READONLY ;
               FONT 'Courier New' ;
               SIZE 9 ;
               BACKCOLOR DEF_COLORBACKHEA

            DEFINE CHECKBOX Check_NumberOnHea
               CAPTION 'Line Number'
               ROW GetDesktopRealHeight() - 224
               COL 10
               WIDTH 95
               HEIGHT 20
               VALUE .F.
               TOOLTIP "Check to display line numbers. Please note that loading time will increase."
               ON CHANGE ( bNumberOnHea := GetProperty( 'VentanaMain', 'Check_NumberOnHea', 'value' ), QPM_Wait( "RichEditDisplay( 'HEA', .T. )", 'Reloading ...' ) )
              END CHECKBOX

            DEFINE BUTTONEX bReLoadHea
               ROW GetDesktopRealHeight() - 227
               COL 110
               WIDTH GetDesktopRealWidth() - 530
               HEIGHT 25
               CAPTION 'Reload Header'
               TOOLTIP 'Reload header file from disk,'
               ONCLICK { || QPM_Wait( "RichEditDisplay( 'HEA', .T. )", 'Reloading ...' ) }
            END BUTTONEX

            DEFINE BUTTONEX BLocalSearchHea
               ROW GetDesktopRealHeight() - 227
               COL GetDesktopRealWidth() - 415
               WIDTH 60
               HEIGHT 25
               CAPTION 'Search'
               TOOLTIP 'Search current data for some text.'
               ONCLICK LocalSearch( GetProperty( 'VentanaMain', 'CSearch', 'DisplayValue' ) )
            END BUTTONEX
         END PAGE

         DEFINE PAGE iif( PUB_bW800, 'FMG', PagePAN )
            DEFINE CHECKBOX Check_AutoSyncPan
               CAPTION 'Auto Sync'
               ROW 00
               COL ( GetDesktopRealWidth() - 420 )
               WIDTH 70
               HEIGHT 20
               VALUE .T.
               TOOLTIP 'Toggle automatic tab syncronization.'
               ON CHANGE TabAutoSync('PAN')
            END CHECKBOX

            @ 25, 00 IMAGE IBorde1PAN ;
               PICTURE 'YELLOW' ;
               WIDTH GetDesktopRealWidth() - 348 ;
               HEIGHT GetDesktopRealHeight() - 217 ;
               STRETCH

            @ 35, 10 RICHEDITBOX RichEditPAN ;
               WIDTH GetDesktopRealWidth() - 364 ;
               HEIGHT GetDesktopRealHeight() - 272 ;
               READONLY ;
               FONT 'Courier New' ;
               SIZE 9 ;
               BACKCOLOR DEF_COLORBACKPAN

            DEFINE CHECKBOX Check_NumberOnPan
               CAPTION 'Line Number'
               ROW GetDesktopRealHeight() - 224
               COL 10
               WIDTH 95
               HEIGHT 20
               VALUE .F.
               TOOLTIP "Check to display line numbers. Please note that loading time will increase."
               ON CHANGE ( bNumberOnPan := GetProperty( 'VentanaMain', 'Check_NumberOnPan', 'value' ), QPM_Wait( "RichEditDisplay( 'PAN', .T. )", 'Reloading ...' ) )
            END CHECKBOX

            DEFINE BUTTONEX bReLoadPan
               ROW GetDesktopRealHeight() - 227
               COL 110
               WIDTH GetDesktopRealWidth() - 530
               HEIGHT 25
               CAPTION 'Reload Form'
               TOOLTIP 'Reload form file from disk.'
               ONCLICK { || QPM_Wait( "RichEditDisplay( 'PAN', .T. )", 'Reloading ...' ) }
            END BUTTONEX

            DEFINE BUTTONEX BLocalSearchPan
               ROW GetDesktopRealHeight() - 227
               COL GetDesktopRealWidth() - 415
               WIDTH 60
               HEIGHT 25
               CAPTION 'Search'
               TOOLTIP 'Search current data for some text.'
               ONCLICK LocalSearch( GetProperty( 'VentanaMain', 'CSearch', 'DisplayValue' ) )
            END BUTTONEX
         END PAGE

         DEFINE PAGE PageDBF
            DEFINE CHECKBOX Check_AutoSyncDbf
               CAPTION 'Auto Sync'
               ROW 00
               COL ( GetDesktopRealWidth() - 420 )
               WIDTH 70
               HEIGHT 20
               VALUE .T.
               TOOLTIP 'Toggle automatic tab syncronization.'
               ON CHANGE  TabAutoSync('DBF')
            END CHECKBOX

            @ 25, 00 IMAGE IBorde1DBF ;
               PICTURE 'YELLOW' ;
               WIDTH GetDesktopRealWidth() - 348 ;
               HEIGHT GetDesktopRealHeight() - 217 ;
               STRETCH

            @ 35, 10 RICHEDITBOX RichEditDBF ;
               WIDTH GetDesktopRealWidth() - 364 ;
               HEIGHT GetDesktopRealHeight() - int( ( GetDesktopRealHeight() * 78 ) / 100 ) ;
               READONLY ;
               FONT 'Courier New' ;
               SIZE 9 ;
               BACKCOLOR DEF_COLORBACKDBF

            @ GetDesktopRealHeight() - int( ( GetDesktopRealHeight() * 72 ) / 100 ), 10 BROWSE DbfBrowse ;
               OF VentanaMain ;
               WIDTH GetDesktopRealWidth() - 364 ;
               HEIGHT ( GetDesktopRealHeight() - 237 ) - ( GetDesktopRealHeight() - int( ( GetDesktopRealHeight() * 72 ) / 100 ) ) ;
               HEADERS ( vDbfHeaders ) ;
               WIDTHS ( vDbfWidths ) ;
               WORKAREA Alias() ;
               FIELDS ( vDbfHeaders ) ;
               VALUE RECNO() ;
               FONT 'Courier New' SIZE 9 ;
               BACKCOLOR DEF_COLORBACKDBF

            DEFINE CHECKBOX Check_DbfAutoView
               CAPTION 'Auto View'
               ROW GetDesktopRealHeight() - 223
               COL 10
               WIDTH 80
               HEIGHT 20
               VALUE bDbfAutoView
               TOOLTIP 'Toggle automatic browsing of DBF file in Quick View.'
               ON CHANGE ( bDbfAutoView := GetProperty( 'VentanaMain', 'Check_DbfAutoView', 'Value' ), QPM_Wait( "RichEditDisplay( 'DBF', .T.,, .F. )", 'Reloading ...' ) )
            END CHECKBOX

            DEFINE BUTTONEX bReLoadDbf
               ROW GetDesktopRealHeight() - 227
               COL 90
               WIDTH GetDesktopRealWidth() - 675
               HEIGHT 25
               CAPTION iif( PUB_bW800, '(Re)Display DBF', '(Re)Display DBF information or data' )
               TOOLTIP 'Display DBF information from disk.'
               ONCLICK { || QPM_Wait( "RichEditDisplay( 'DBF', .T., NIL, .T. )", 'Reloading ...' ) }
            END BUTTONEX

            DEFINE BUTTONEX BLocalSearchStructure
               ROW GetDesktopRealHeight() - 227
               COL GetDesktopRealWidth() - 580
               WIDTH 110
               HEIGHT 25
               CAPTION 'Search Struc.'
               TOOLTIP "Search DBF's structure for some text."
               ONCLICK LocalSearch( GetProperty( 'VentanaMain', 'CSearch', 'DisplayValue' ) )
            END BUTTONEX

            DEFINE BUTTONEX BLocalSearchDbf
               ROW GetDesktopRealHeight() - 227
               COL GetDesktopRealWidth() - 465
               WIDTH 110
               HEIGHT 25
               CAPTION 'DBF Search'
               TOOLTIP "Search DBF's data for some text."
               ONCLICK QPM_Wait( "DbfDataSearch( GetProperty( 'VentanaMain', 'CSearch', 'DisplayValue' ) )", 'Searching ...' )
            END BUTTONEX
         END PAGE

         DEFINE PAGE PageLIB
            DEFINE CHECKBOX Check_AutoSyncLib
               CAPTION 'Auto Sync'
               ROW 00
               COL ( GetDesktopRealWidth() - 420 )
               WIDTH 70
               HEIGHT 20
               VALUE .T.
               TOOLTIP 'Toggle automatic tab syncronization.'
               ON CHANGE TabAutoSync('LIB')
            END CHECKBOX

            @ 25, 00 IMAGE IBorde1LIB ;
               PICTURE 'YELLOW' ;
               WIDTH GetDesktopRealWidth() - 348 ;
               HEIGHT GetDesktopRealHeight() - 217 ;
               STRETCH

            @ 35, 10 RICHEDITBOX RichEditLIB ;
               WIDTH GetDesktopRealWidth() - 364 ;
               HEIGHT GetDesktopRealHeight() - 272 ;
               READONLY ;
               FONT 'Courier New' ;
               SIZE 9 ;
               BACKCOLOR DEF_COLORBACKINC

            DEFINE BUTTONEX bReLoadLib
               ROW GetDesktopRealHeight() - 227
               COL 10
               WIDTH GetDesktopRealWidth() - 430
               HEIGHT 25
               CAPTION 'List Library/Object (or Re-List)'
               TOOLTIP 'List Library/Object content.'
               ONCLICK SetProperty( 'VentanaMain', 'RichEditLib', 'Value', QPM_Wait( "ListModule( '" + ChgPathToReal( US_WordSubStr( GetProperty( "VentanaMain", "GIncFiles", "Cell", VentanaMain.GIncFiles.Value, NCOLINCFULLNAME ), 3 ) ) + "' )", 'Listing ...', NIL, .T. ) )
            END BUTTONEX

            DEFINE BUTTONEX BLocalSearchLib
               ROW GetDesktopRealHeight() - 227
               COL GetDesktopRealWidth() - 415
               WIDTH 60
               HEIGHT 25
               CAPTION 'Search'
               TOOLTIP 'Search current data for some text.'
               ONCLICK LocalSearch( GetProperty( 'VentanaMain', 'CSearch', 'DisplayValue' ) )
            END BUTTONEX
         END PAGE

#ifdef QPM_SHG
         DEFINE PAGE PageHlp
            DEFINE CHECKBOX Check_AutoSyncHlp
               CAPTION 'Auto Sync'
               ROW 00
               COL ( GetDesktopRealWidth() - 420 )
               WIDTH 70
               HEIGHT 20
               VALUE .T.
               TOOLTIP 'Toggle automatic tab syncronization.'
               ON CHANGE TabAutoSync('HLP')
            END CHECKBOX

            @ 25, 00 IMAGE IBorde1Hlp ;
               PICTURE 'YELLOW' ;
               WIDTH GetDesktopRealWidth() - 348 ;
               HEIGHT GetDesktopRealHeight() - 217 ;
               STRETCH

            // these instructions must come before the definition of BAddHlpKey and BRemoveHlpKey
            oHlpRichEdit:cWindowName := 'VentanaMain'
            oHlpRichEdit:cRichControlName := 'RichEditHlp'
            oHlpRichEdit:cLanguage := 'EN'
            oHlpRichEdit:cFunctionPostPaste := 'SHG_Post_Paste()'
            IF PUB_bW800
               oHlpRichEdit:nPorcentajeAncho := 49.0
               oHlpRichEdit:nPorcentajeAlto := 72
            ELSE
               oHlpRichEdit:nPorcentajeAncho := 60.0
               IF US_InitialBarIsOculta()
                  oHlpRichEdit:nPorcentajeAlto := 81
               ELSE
                  oHlpRichEdit:nPorcentajeAlto := 78
               ENDIF
            ENDIF
            oHlpRichEdit:bEdit := .T.
            oHlpRichEdit:bRTF := .T.
            oHlpRichEdit:bButtonFind := .F.
            oHlpRichEdit:Init( '' )
            SetProperty( 'VentanaMain', 'RichEditHlp', 'readonly', .T. )

            DEFINE BUTTONEX BAddHlpKey
               ROW GetProperty( 'VentanaMain', 'CB_Vinetas', 'row' )
               COL GetDesktopRealWidth() - 416
               WIDTH 28
               HEIGHT 25
               PICTURE 'add'
               TOOLTIP 'Add key to index.'
               ONCLICK SHG_AddHlpKey()
            END BUTTONEX

            DEFINE BUTTONEX BRemoveHlpKey
               ROW GetProperty( 'VentanaMain', 'CB_Vinetas', 'row' )
               COL GetDesktopRealWidth() - 384
               WIDTH 28
               HEIGHT 25
               PICTURE 'remove'
               TOOLTIP 'Remove key from index.'
               ONCLICK QPM_RemoveKeyHLP()
            END BUTTONEX

            nRow := GetProperty( 'VentanaMain', 'RichEditHlp', 'row' )
            nCol := GetProperty( 'VentanaMain', 'RichEditHlp', 'col' ) + GetProperty( 'VentanaMain', 'RichEditHlp', 'width' ) + 20
            nWidth := ( GetDesktopRealWidth() - 480 ) + 124 - nCol
            nHeight := GetProperty( 'VentanaMain', 'RichEditHlp', 'Height' )

            @ nRow, nCol GRID GHlpKeys ;
               WIDTH nWidth ;
               HEIGHT nHeight ;
               HEADERS { 'Keys' } ;
               WIDTHS { 100 };
               ITEMS {} ;
               VALUE 0 ;
               TOOLTIP "Index keys associated with this topic." ;
               BACKCOLOR DEF_COLORBACKHLP ;
               ON DBLCLICK { QPM_EditKeyHLP() } ;
               PAINTDOUBLEBUFFER ;
               JUSTIFY { BROWSE_JTFY_LEFT }

            DEFINE BUTTONEX bReLoadHlp
               ROW GetDesktopRealHeight() - 227
               COL 10
               WIDTH 124
               HEIGHT 25
               CAPTION 'Cancel changes?'
               TOOLTIP 'Select [Yes] to discard changes.'
               ONCLICK { || QPM_Wait( 'SHG_CancelChangesTopic()', 'Checking for restore ...' ) }
            END BUTTONEX

            DEFINE CHECKBOX CH_SHG_TypeOutput
               CAPTION 'Add HTML Output'
               ROW GetDesktopRealHeight() - 224
               COL iif( PUB_bW800, 140, 230 )
               WIDTH iif( PUB_bW800, 120, 120 )
               HEIGHT 20
               VALUE SHG_CheckTypeOutput
               TOOLTIP 'Toggles generation of HTML files.'
               ON CHANGE       ( SHG_CheckTypeOutput := GetProperty( 'VentanaMain', 'CH_SHG_TypeOutput', 'value' ) )
            END CHECKBOX

            DEFINE BUTTONEX BLocalSearchHlp
               ROW GetDesktopRealHeight() - 227
               COL GetDesktopRealWidth() - 480
               WIDTH 124
               HEIGHT 25
               CAPTION 'Search'
               TOOLTIP 'Search current data for some text.'
               ONCLICK LocalSearch( GetProperty( 'VentanaMain', 'CSearch', 'DisplayValue' ) )
            END BUTTONEX
         END PAGE
#endif

         DEFINE PAGE PageSysout
            DEFINE LABEL L_OverrideCompile
               ROW 40
               COL 10
               WIDTH 150
               VALUE 'Extra Compile Params'
               TRANSPARENT IsXPThemeActive()
            END LABEL

            DEFINE TEXTBOX OverrideCompile
               ROW 37
               COL 155
               WIDTH ( GetDesktopRealWidth() - 670 ) / 2
               HEIGHT 25
            END TEXTBOX

            DEFINE LABEL L_OverrideLink
               ROW 40
               COL 145 + ( ( GetDesktopRealWidth() - 620 ) / 2 )
               WIDTH 150
               VALUE 'Extra Link Params:'
               TRANSPARENT IsXPThemeActive()
            END LABEL

            DEFINE TEXTBOX OverrideLink
               ROW 37
               COL 263 + ( ( GetDesktopRealWidth() - 620 ) / 2 )
               WIDTH ( GetDesktopRealWidth() - 620 ) / 2
               HEIGHT 25
            END TEXTBOX

            @ 75, 10 RICHEDITBOX RichEditSysout ;
               WIDTH GetDesktopRealWidth() - 364 ;
               HEIGHT GetDesktopRealHeight() - 312 ;
               READONLY ;
               FONT 'Courier New' ;
               SIZE 9

            DEFINE BUTTONEX BLocalSearchSysOut
               ROW GetDesktopRealHeight() - 227
               COL 10
               WIDTH GetDesktopRealWidth() - 364
               HEIGHT 25
               CAPTION 'Search'
               TOOLTIP 'Search current data for some text.'
               ONCLICK LocalSearch( GetProperty( 'VentanaMain', 'CSearch', 'DisplayValue' ) )
            END BUTTONEX
         END PAGE

         DEFINE PAGE PageOUT
            @ 35, 10 RICHEDITBOX RichEditOUT ;
               WIDTH GetDesktopRealWidth() - 364 ;
               HEIGHT GetDesktopRealHeight() - 272 ;
               READONLY ;
               BACKCOLOR DEF_COLORBACKOUT ;
               FONT 'Courier New' ;
               SIZE 9

            DEFINE BUTTONEX bDeleteErrorLog
               ROW GetDesktopRealHeight() - 227
               COL 10
               WIDTH 120
               HEIGHT 25
               CAPTION 'Delete Error Log'
               TOOLTIP "Delete content of MiniGui's error log."
               ONCLICK QPM_DeleteErrorLog()
            END BUTTONEX

            DEFINE BUTTONEX bReLoadErrorLog
               ROW GetDesktopRealHeight() - 227
               COL 140
               WIDTH GetDesktopRealWidth() - 780
               HEIGHT 25
               CAPTION 'Reload Error Log'
               TOOLTIP "Reload content of MiniGui's error log."
               ONCLICK MuestroErrorLog()
            END BUTTONEX

            DEFINE BUTTONEX bReLoadOut
               ROW GetDesktopRealHeight() - 227
               COL GetDesktopRealWidth() - 620
               WIDTH 184
               HEIGHT 25
               CAPTION '(Re)List Output File'
               TOOLTIP "List content of project's output file."
               ONCLICK ( SetProperty( 'VentanaMain', 'RichEditOut', 'Value', QPM_Wait( "ListModuleMoved( '" + GetOutputModuleName() + "' )", 'Listing ...' ) ), SetProperty( 'VentanaMain', 'RichEditOut', 'caretpos', 1 ) )
            END BUTTONEX

            DEFINE BUTTONEX BLocalSearchOut
               ROW GetDesktopRealHeight() - 227
               COL GetDesktopRealWidth() - 415
               WIDTH 60
               HEIGHT 25
               CAPTION 'Search'
               TOOLTIP 'Search current data for some text.'
               ONCLICK LocalSearch( GetProperty( 'VentanaMain', 'CSearch', 'DisplayValue' ) )
            END BUTTONEX
         END PAGE
      END TAB

      DEFINE BUTTONEX BStop
         ROW GetDesktopRealHeight() - 118
         COL 328
         WIDTH 85
         HEIGHT 25
         PICTURE 'STOP'
         TOOLTIP 'Stop BUILD process.'
         ONCLICK QPM_Wait( 'BuildStop()', 'Stopping, please wait ...' )
      END BUTTONEX

#ifdef QPM_KILLER
      DEFINE BUTTONEX BKill
         ROW GetDesktopRealHeight() - 118
         COL 418
         WIDTH 85
         HEIGHT 25
         PICTURE 'KILL'
         TOOLTIP 'Use "Process Manager" to kill a process.'
         ONCLICK ( SetProperty( 'VentanaMain', 'bKill', 'Enabled', .F. ), DoMethod( 'WinKiller', 'restore' ), QPM_bKiller := .T., iif( PUB_QPM_bHigh, NIL, QPM_SetProcessPriority( 'HIGH' ) ), SetProperty( 'WinKiller', 'TimerRefresh', 'Enabled', GetProperty( 'WinKiller', 'Check_AutoRefresh', 'value' ) ), DoMethod( 'VentanaMain', 'minimize' ) )
      END BUTTONEX
#endif

      @ GetDesktopRealHeight() - 118, 508 COMBOBOX CSearch ;
         ITEMS {} ;
         VALUE 1 ;
         DISPLAYEDIT ;
         WIDTH GetDesktopRealWidth() - iif( PUB_bW800, 735, 810 ) ;
         TOOLTIP 'Text to search for.' ;
         ON ENTER ( AddSearchTxt(), QPM_Wait( "GlobalSearch( GetProperty( 'VentanaMain', 'CSearch', 'DisplayValue' ) )", 'Searching ...' ) )
         ON LOSTFOCUS AddSearchTxt()

      DEFINE BUTTONEX BGlobalSearch
         ROW GetDesktopRealHeight() - 118
         COL GetDesktopRealWidth() - iif( PUB_bW800, 223, 293 )
         WIDTH 90
         HEIGHT 25
         CAPTION 'Global Search'
         TOOLTIP "Search into all project's files."
         ONCLICK ( AddSearchTxt(), QPM_Wait( "GlobalSearch( GetProperty( 'VentanaMain', 'CSearch', 'DisplayValue' ) )", 'Searching ...' ) )
      END BUTTONEX

      DEFINE BUTTONEX BGlobalReset
         ROW GetDesktopRealHeight() - 118
         COL GetDesktopRealWidth() - iif( PUB_bW800, 129, 194 )
         WIDTH iif( PUB_bW800, 15, 50 )
         HEIGHT 25
         CAPTION iif( PUB_bW800, 'R', 'Reset' )
         TOOLTIP 'Reset Global Search indicators and counters.'
         ONCLICK QPM_Wait( "ResetImgGrid( '*' )", 'Reseting Search Indicators ...' )
      END BUTTONEX
      VentanaMain.BGlobalReset.Enabled := .F.

      DEFINE CHECKBOX Check_SearchFun
         CAPTION iif( PUB_bW800, 'Func/Proc', 'Func/Proc/Method' )
         ROW GetDesktopRealHeight() - 125
         COL GetDesktopRealWidth() - iif( PUB_bW800, 105, 135 )
         WIDTH iif( PUB_bW800, 80, 120 )
         HEIGHT 20
         VALUE .F.
         TOOLTIP 'Global Search for Function, Procedure and/or Method name.'
         TRANSPARENT IsXPThemeActive()
      END CHECKBOX

      DEFINE CHECKBOX Check_SearchDbf
         CAPTION iif( PUB_bW800, 'DBF Data', 'DBF Data Search' )
         ROW GetDesktopRealHeight() - 104
         COL GetDesktopRealWidth() - iif( PUB_bW800, 105, 135 )
         WIDTH iif( PUB_bW800, 80, 120 )
         HEIGHT 20
         VALUE .F.
         TOOLTIP "Check to include DBF's data when performing a Global Search."
         TRANSPARENT IsXPThemeActive()
      END CHECKBOX

      DEFINE CHECKBOX Check_SearchCas
         CAPTION iif( PUB_bW800, 'Case Sens', 'Case Sensitive' )
         ROW GetDesktopRealHeight() - 83
         COL GetDesktopRealWidth() - iif( PUB_bW800, 105, 135 )
         WIDTH iif( PUB_bW800, 80, 120 )
         HEIGHT 20
         VALUE .F.
         TOOLTIP "Check to enable case sensitive processing when performing a Global Search."
         TRANSPARENT IsXPThemeActive()
      END CHECKBOX

      DEFINE LABEL Label_2
         ROW GetDesktopRealHeight() - 85
         COL 328
         VALUE 'F1 Help     F2 Open/New    F3 Save     F4 Build     F5 Run     F10 Exit'
         AUTOSIZE .T.
         FONTNAME 'Arial'
         FONTSIZE 9
         TRANSPARENT IsXPThemeActive()
      END LABEL

      DEFINE LABEL LGlobal
         ROW GetDesktopRealHeight() - 85
         COL GetDesktopRealWidth() - iif( PUB_bW800, 205, 330 )
         WIDTH iif( PUB_bW800, 80, 180 )
         VALUE iif( PUB_bW800, 'Global Is On', 'Global Search Is Active' )
         FONTNAME 'arial'
         FONTSIZE 10
         FONTBOLD .T.
         FONTCOLOR DEF_COLORRED
         TOOLTIP 'Global Search is active, use "Reset" button to disable.'
         TRANSPARENT IsXPThemeActive()
      END LABEL
      VentanaMain.LGlobal.visible := .F.

      DEFINE TIMER Timer_Refresh ;
         INTERVAL 500 ;
         ACTION QPM_Timer_StatusRefresh()

      DEFINE TIMER Timer_Edit ;
         INTERVAL 500 ;
         ACTION QPM_Timer_Edit()

      DEFINE TIMER Timer_Run ;
         INTERVAL 500 ;
         ACTION QPM_Timer_Run()

      IF PUB_bHotKeys
         DefinoWindowsHotKeys()
      ENDIF

   END WINDOW   // VentanaMain

#ifdef QPM_KILLER
   QPM_DefinoKillerWindow()
   DoMethod( 'WinKiller', 'hide' )
#endif

   IF ! PUB_bLite
      TabChange( 'FILES' )
   ENDIF

   CargoSearch()

   CargoDefaultLibs( GetSuffix() )

   IF PUB_bLite
      DEFINE WINDOW VentanaLite ;
         AT 0,0 ;
         WIDTH ( ( GetDesktopRealWidth() * 70 ) / 100 ) HEIGHT ( ( GetDesktopRealHeight() * 95 ) / 100 ) ;
         TITLE PUB_cQPM_Title + ' [ New Project ]' ;
         CHILD ;
         ICON 'QPM' ;
         ON INIT HideInitAutoRun()

         @ 47, 2 FRAME FFrame ;
            WIDTH ( ( GetDesktopRealWidth() * 68.7 ) / 100 ) ;
            HEIGHT ( ( GetDesktopRealHeight() * 85 ) / 100 )

            DEFINE LABEL LStatusLabel
               ROW 15
               COL 28
               WIDTH 100
               HEIGHT 18
               VALUE PUB_cStatusLabel
            END LABEL

            @ 07, 153 LABEL LResumen ;
               VALUE '' ;
               WIDTH 600 ;
               HEIGHT 18 ;
               FONT 'arial' SIZE 10 BOLD ;
               FONTCOLOR DEF_COLORBLUE

            @ 26, 153 LABEL LFull ;
               VALUE '' ;
               WIDTH 160 ;
               HEIGHT 18 ;
               FONT 'arial' SIZE 10 BOLD ;
               FONTCOLOR DEF_COLORGREEN

            @ 26, 320 LABEL LExtra ;
               VALUE '' ;
               WIDTH 200 ;
               HEIGHT 18 ;
               FONT 'arial' SIZE 10 BOLD ;
               FONTCOLOR DEF_COLORBLACK

            @ 60, 10 RICHEDITBOX RichEditSysout ;
               WIDTH ( ( GetDesktopRealWidth() * 67 ) / 100 ) ;
               HEIGHT ( ( GetDesktopRealHeight() * 74 ) / 100 ) ;
               READONLY ;
               FONT 'Arial' ;
               SIZE 9 ;
               BACKCOLOR DEF_COLORBACKSYSOUT

            DEFINE LABEL Label_3
               ROW ( ( GetDesktopRealHeight() * 86 ) / 100 )
               COL 50
               VALUE 'F5: Run'
               AUTOSIZE .T.
               FONTNAME 'Arial'
               FONTSIZE 9
            END LABEL
            VentanaLite.Label_3.enabled := .F.

            DEFINE BUTTONEX BStop
               ROW ( ( GetDesktopRealHeight() * 85 ) / 100 )
               COL ( ( GetDesktopRealWidth() * 18 ) / 100 )
               WIDTH 75
               HEIGHT 25
               PICTURE 'STOP'
               TOOLTIP 'Stop BUILD process.'
               ONCLICK QPM_Wait( 'BuildStop()', 'Stopping, please wait ...' )
            END BUTTONEX

            DEFINE BUTTONEX BAbout
               ROW ( ( GetDesktopRealHeight() * 85 ) / 100 )
               COL ( ( GetDesktopRealWidth() * 28 ) / 100 )
               WIDTH 75
               HEIGHT 25
               CAPTION 'About'
               TOOLTIP "QPM's info and credits."
               ONCLICK QPM_About()
            END BUTTONEX

            DEFINE BUTTONEX BRunP
               ROW ( ( GetDesktopRealHeight() * 85 ) / 100 )
               COL ( ( GetDesktopRealWidth() * 38 ) / 100 )
               WIDTH 75
               HEIGHT 25
               CAPTION 'Run Parm'
               TOOLTIP 'Run program using command line parameters.'
               ONCLICK ( bRunParm := .T., QPM_Run( bRunParm ) )
            END BUTTONEX
            VentanaLite.BRunP.enabled := .F.

            DEFINE BUTTONEX BRun
               ROW ( ( GetDesktopRealHeight() * 85 ) / 100 )
               COL ( ( GetDesktopRealWidth() * 48 ) / 100 )
               WIDTH 75
               HEIGHT 25
               CAPTION 'Run'
               TOOLTIP 'Run program without command line parameters.'
               ONCLICK ( bRunParm := .F., QPM_Run( bRunParm ) )
            END BUTTONEX
            VentanaLite.BRun.enabled := .F.

            DEFINE BUTTONEX BExit
               ROW ( ( GetDesktopRealHeight() * 85 ) / 100 )
               COL ( ( GetDesktopRealWidth() * 58 ) / 100 )
               WIDTH 75
               HEIGHT 25
               CAPTION 'Exit'
               TOOLTIP 'Exit QPM and return to caller process.'
               ONCLICK iif( PUB_bIsProcessing, NIL, DoMethod( 'VentanaLite', 'release' ) )
            END BUTTONEX
      END WINDOW

      CENTER WINDOW VentanaLite

      VentanaMain.Minimize()
   ENDIF

   QPM_SetProcessPriority( 'NORMAL' )

   SetProperty( 'VentanaMain', 'OverrideCompile', 'enabled', .F. )
   SetProperty( 'VentanaMain', 'OverrideLink', 'enabled', .F. )

#ifdef QPM_KILLER
   ACTIVATE WINDOW WinKiller, VentanaMain
#else
   ACTIVATE WINDOW VentanaMain
#endif

   ExitProcess( 0 )
RETURN

FUNCTION QPM_AddFilesPRG
RETURN QPM_Wait( 'QPM_AddFilesPRG2()', 'Loading file ...' )

FUNCTION QPM_AddFilesPRG2()
   LOCAL Files, x, i, Exists
   LOCAL bTop := iif( GetProperty( 'VentanaMain', 'GPrgFiles', 'itemcount' ) == 0, .T., .F. )
   IF Empty( PUB_cProjectFolder ) .OR. ! US_IsDirectory( PUB_cProjectFolder )
      MyMsgStop( DBLQT + "Project Folder" + DBLQT + " is not a valid folder:" + CRLF + PUB_cProjectFolder + CRLF + 'Look at tab ' + DBLQT + PagePRG + DBLQT )
      RETURN .F.
   ENDIF
   SetMGWaitHide()
   Files := QPM_GetFilesPRG()
   x := 1
   DO WHILE x <= Len( Files )
      IF " " $ US_FileNameOnlyNameAndExt( Files[ x ] )
         MyMsgStop( "QPM can't handle filenames with spaces." + CRLF + DBLQT + Files[ x ] + DBLQT + ' will be deleted.' )
         ADel( Files, x )
         ASize( Files, Len( Files ) - 1 )
      ELSE
         x ++
      ENDIF
   ENDDO
   SetMGWaitShow()
   IF Len( Files ) == 1
      IF ! ( Upper( US_FileNameOnlyExt( Files[1] ) ) == 'PRG' ) .AND. ;
         ! ( Upper( US_FileNameOnlyExt( Files[1] ) ) == 'C' ) .AND. ;
         ! ( Upper( US_FileNameOnlyExt( Files[1] ) ) == 'CPP' )
         Files[1] := US_FileNameOnlyPathAndName( Files[1] ) + '.PRG'
      ENDIF
      IF ! File( Files[1] )
         IF ! MyMsgYesNo( 'File ' + DBLQT + Files[1] + DBLQT + 'was not found.' + CRLF + 'Do you want to create an empty file?' )
            RETURN .F.
         ENDIF
         IF Upper( US_FileNameOnlyExt( Files[1] ) ) == 'PRG'
            QPM_CreateNewFile( 'PRG', Files[1] )
         ELSE
            QPM_MemoWrit( Files[1], ' ' )
         ENDIF
      ENDIF
   ENDIF
   FOR x := 1 TO Len( Files )
      Exists := .F.
      IF SubStr( US_FileNameOnlyPath( Files[x] ), 2, 2 ) == ':' + DEF_SLASH .AND. Len( US_FileNameOnlyPath( Files[x] ) ) == 3
         MyMsgStop( 'Components located in a root folder will not work correctly in QPM: ' + Files[ x ] )
         EXIT
      ENDIF
      Files[x] := ChgPathToRelative( Files[x] )
      FOR i := 1 TO VentanaMain.GPrgFiles.ItemCount
         IF US_Upper( AllTrim( Files[x] ) ) == US_Upper( AllTrim( GetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', i, NCOLPRGFULLNAME ) ) )
            Exists := .T.
            EXIT
         ENDIF
      NEXT i
      IF ! Exists
         VentanaMain.GPrgFiles.AddItem( { PUB_nGridImgNone, ' ', US_FileNameOnlyNameAndExt( Files[x] ), Files[x], '0', '', '' } )
         IF ! Empty( cLastGlobalSearch )
            IF GlobalSearch2( 'PRG', cLastGlobalSearch, VentanaMain.GPrgFiles.ItemCount, bLastGlobalSearchFun, bLastGlobalSearchDbf )
               TotCaption( 'PRG', +1 )
            ENDIF
         ENDIF
         IF Upper( US_FileNameOnlyExt( Files[1] ) ) == 'PRG'
            IF AScan( vExtraFoldersForSearchHB, { |y| US_Upper( y ) == US_Upper( US_FileNameOnlyPath( ChgPathToReal( Files[x] ) ) ) } ) == 0
               AAdd( vExtraFoldersForSearchHB, US_FileNameOnlyPath( ChgPathToReal( Files[x] ) ) )
            ENDIF
         ELSEIF Upper( US_FileNameOnlyExt( Files[1] ) ) == 'CPP' .OR. Upper( US_FileNameOnlyExt( Files[1] ) ) == 'C'
            IF AScan( vExtraFoldersForSearchC, { |y| US_Upper( y ) == US_Upper( US_FileNameOnlyPath( ChgPathToReal( Files[x] ) ) ) } ) == 0
               AAdd( vExtraFoldersForSearchC, US_FileNameOnlyPath( ChgPathToReal( Files[x] ) ) )
            ENDIF
         ENDIF
      ENDIF
   NEXT x
   IF VentanaMain.GPrgFiles.Value == 0
      VentanaMain.GPrgFiles.Value := 1
   ENDIF
   DoMethod( 'VentanaMain', 'GPrgFiles', 'ColumnsAutoFitH' )
   QPM_CheckFiles()
   IF bTop .AND. VentanaMain.GPrgFiles.ItemCount > 0
      CambioTitulo()
      IF Prj_Warn_TopFile
         IF MyMsgYesNo( DBLQT + ChgPathToReal( GetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', 1, NCOLPRGFULLNAME ) ) + DBLQT + CRLF + "is the new " + DBLQT + "Top File" + DBLQT + "." + CRLF + ;
                        'Omit this message from now on?' )
            Prj_Warn_TopFile := .F.
            MyMsgInfo( 'Use ' + DBLQT + PUB_MenuResetWarnings + DBLQT + ' option of Settings menu to enable the previous message.' )
         ENDIF
      ENDIF
   ENDIF
RETURN .T.

FUNCTION QPM_AddFilesHEA
RETURN QPM_Wait( 'QPM_AddFilesHEA2()', 'Loading ...' )

FUNCTION QPM_AddFilesHEA2()
   LOCAL Files, x, i, Exists
   IF Empty( PUB_cProjectFolder ) .OR. ! US_IsDirectory( PUB_cProjectFolder )
      MyMsgStop( DBLQT + "Project Folder" + DBLQT + " is not a valid folder:" + CRLF + PUB_cProjectFolder + CRLF + 'Look at tab ' + DBLQT + PagePRG + DBLQT )
      RETURN .F.
   ENDIF
   SetMGWaitHide()
   Files := QPM_GetFilesHEA()
   SetMGWaitShow()
   IF Len( Files ) == 1
      IF ! ( Upper( US_FileNameOnlyExt( Files[1] ) ) == 'H' ) .AND. ;
         ! ( Upper( US_FileNameOnlyExt( Files[1] ) ) == 'CH' )
         Files[1] := Files[1] + '.H'
      ENDIF
      IF ! File( Files[1] )
         IF MyMsgYesNo( 'File ' + DBLQT + Files[1] + DBLQT + 'was not found.' + CRLF + 'Do you want to create an empty file?' )
            QPM_CreateNewFile( 'HEA', Files[1] )
         ELSE
            RETURN .F.
         ENDIF
      ENDIF
   ENDIF
   FOR x := 1 TO Len ( Files )
      Exists := .F.
      Files[x] := ChgPathToRelative( Files[x] )
      FOR i := 1 TO VentanaMain.GHeaFiles.ItemCount
         IF US_Upper( AllTrim( Files[x] ) ) == US_Upper( AllTrim( GetProperty( 'VentanaMain', 'GHeaFiles', 'Cell', i, NCOLHEAFULLNAME ) ) )
            Exists := .T.
            EXIT
         ENDIF
      NEXT i
      IF ! Exists
         VentanaMain.GHeaFiles.AddItem( { PUB_nGridImgNone, US_FileNameOnlyNameAndExt( Files[x] ), Files[x], '0', '', '' } )
         IF ! Empty( cLastGlobalSearch )
            IF GlobalSearch2( 'HEA', cLastGlobalSearch, VentanaMain.GHeaFiles.ItemCount, bLastGlobalSearchFun, bLastGlobalSearchDbf )
               TotCaption( 'HEA', +1 )
            ENDIF
         ENDIF
         IF AScan( vExtraFoldersForSearchHB, { |y| US_Upper( y ) == US_Upper( US_FileNameOnlyPath( ChgPathToReal( Files[x] ) ) ) } ) == 0
            AAdd( vExtraFoldersForSearchHB, US_FileNameOnlyPath( ChgPathToReal( Files[x] ) ) )
         ENDIF
         IF AScan( vExtraFoldersForSearchC, { |y| US_Upper( y ) == US_Upper( US_FileNameOnlyPath( ChgPathToReal( Files[x] ) ) ) } ) == 0
            AAdd( vExtraFoldersForSearchC, US_FileNameOnlyPath( ChgPathToReal( Files[x] ) ) )
         ENDIF
      ENDIF
   NEXT x
   IF VentanaMain.GHeaFiles.Value == 0
      VentanaMain.GHeaFiles.Value := 1
   ENDIF
   DoMethod( 'VentanaMain', 'GHeaFiles', 'ColumnsAutoFitH' )
   QPM_CheckFiles()
RETURN .T.

FUNCTION QPM_AddFilesPAN
RETURN QPM_Wait( 'QPM_AddFilesPAN2()', 'Loading ...' )

FUNCTION QPM_AddFilesPAN2()
   LOCAL Files, x, i, Exists
   IF Empty( PUB_cProjectFolder ) .OR. ! US_IsDirectory( PUB_cProjectFolder )
      MyMsgStop( DBLQT + "Project Folder" + DBLQT + " is not a valid folder:" + CRLF + PUB_cProjectFolder + CRLF + 'Look at tab ' + DBLQT + PagePRG + DBLQT )
      RETURN .F.
   ENDIF
   SetMGWaitHide()
   Files := QPM_GetFilesPAN()
   IF Len( Files ) == 1
      IF ! ( Upper( US_FileNameOnlyExt( Files[1] ) ) == 'FMG' )
         Files[1] := US_FileNameOnlyPathAndName( Files[1] ) + '.fmg'
      ENDIF
      IF ! File( Files[1] )
         IF MyMsgYesNo( 'File not found: ' + DBLQT + Files[1] + DBLQT + CRLF + 'Do you want to create an empty file?' )
            IF ! QPM_CreateNewFile( 'PAN', Files[1] )
               RETURN .F.
            ENDIF
         ELSE
            RETURN .F.
         ENDIF
      ENDIF
   ENDIF
   SetMGWaitShow()
   FOR x := 1 TO Len ( Files )
      Exists := .F.
      IF SubStr( US_FileNameOnlyPath( Files[x] ), 2, 2 ) == ':' + DEF_SLASH .AND. Len( US_FileNameOnlyPath( Files[x] ) ) == 3
         MyMsgStop( 'Components located in a root folder will not work correctly in QPM: ' + Files[ x ] )
         EXIT
      ENDIF
      Files[x] := ChgPathToRelative( Files[x] )
      FOR i := 1 TO VentanaMain.GPanFiles.ItemCount
         IF US_Upper( AllTrim( Files[x] ) ) == US_Upper( AllTrim( GetProperty( 'VentanaMain', 'GPanFiles', 'Cell', i, NCOLPANFULLNAME ) ) )
            Exists := .T.
            EXIT
         ENDIF
      NEXT i
      IF ! Exists
         VentanaMain.GPanFiles.AddItem( { PUB_nGridImgNone, US_FileNameOnlyNameAndExt( Files[x] ), Files[x], '0', '', '' } )
         IF ! Empty( cLastGlobalSearch )
            IF GlobalSearch2( 'PAN', cLastGlobalSearch, VentanaMain.GPanFiles.ItemCount, bLastGlobalSearchFun, bLastGlobalSearchDbf )
               TotCaption( 'PAN', +1 )
            ENDIF
         ENDIF
         IF AScan( vExtraFoldersForSearchHB, { |y| US_Upper( y ) == US_Upper( US_FileNameOnlyPath( ChgPathToReal( Files[x] ) ) ) } ) == 0
            AAdd( vExtraFoldersForSearchHB, US_FileNameOnlyPath( ChgPathToReal( Files[x] ) ) )
         ENDIF
      ENDIF
   NEXT x
   IF VentanaMain.GPanFiles.Value == 0
      VentanaMain.GPanFiles.Value := 1
   ENDIF
   DoMethod( 'VentanaMain', 'GPanFiles', 'ColumnsAutoFitH' )
   QPM_CheckFiles()
RETURN .T.

FUNCTION QPM_AddFilesDBF
RETURN QPM_Wait( 'QPM_AddFilesDBF2()', 'Loading ...' )

FUNCTION QPM_AddFilesDBF2()
   LOCAL Files, x, i, Exists
   IF Empty( PUB_cProjectFolder ) .OR. ! US_IsDirectory( PUB_cProjectFolder )
      MyMsgStop( DBLQT + "Project Folder" + DBLQT + " is not a valid folder:" + CRLF + PUB_cProjectFolder + CRLF + 'Look at tab ' + DBLQT + PagePRG + DBLQT )
      RETURN .F.
   ENDIF
   SetMGWaitHide()
   Files := QPM_GetFilesDBF()
   SetMGWaitShow()
   IF Len( Files ) == 1
      IF ! ( Upper( US_FileNameOnlyExt( Files[1] ) ) == 'DBF' )
         Files[1] := US_FileNameOnlyPathAndName( Files[1] ) + '.dbf'
      ENDIF
      IF ! File( Files[1] )
         IF MyMsgYesNo( 'File not found: ' + DBLQT + Files[1] + DBLQT + CRLF + 'Do you want to create an empty file?' )
            IF ! QPM_CreateNewFile( 'DBF', Files[1] )
               RETURN .F.
            ENDIF
         ELSE
            RETURN .F.
         ENDIF
      ENDIF
   ENDIF
   FOR x := 1 TO Len ( Files )
      Exists := .F.
      Files[x] := ChgPathToRelative( Files[x] )
      FOR i := 1 TO VentanaMain.GDbfFiles.ItemCount
         IF US_Upper( AllTrim( Files[x] ) ) == US_Upper( AllTrim( GetProperty( 'VentanaMain', 'GDbfFiles', 'Cell', i, NCOLDBFFULLNAME ) ) )
            Exists := .T.
            EXIT
         ENDIF
      NEXT i
      IF ! Exists
         VentanaMain.GDbfFiles.AddItem( { PUB_nGridImgNone, US_FileNameOnlyNameAndExt( Files[x] ), Files[x], '0 0', '', '0 ** 0' } )
         IF ! Empty( cLastGlobalSearch )
            IF GlobalSearch2( 'DBF', cLastGlobalSearch, VentanaMain.GDbfFiles.ItemCount, bLastGlobalSearchFun, bLastGlobalSearchDbf )
               TotCaption( 'DBF', +1 )
            ENDIF
         ENDIF
      ENDIF
   NEXT x
   IF VentanaMain.GDbfFiles.Value == 0
      VentanaMain.GDbfFiles.Value := 1
   ENDIF
   DoMethod( 'VentanaMain', 'GDbfFiles', 'ColumnsAutoFitH' )
   QPM_CheckFiles()
RETURN .T.

FUNCTION QPM_AddDefaultLibs
RETURN QPM_Wait( 'QPM_AddDefaultLibs2()', 'Loading ...' )

FUNCTION QPM_AddDefaultLibs2()
   LOCAL aFiles, x, i, cFile, cMode, cMode1, cMode2, cFileUpper, cThreads, cDebug
   SetMGWaitHide()
   aFiles := QPM_GetLibs()
   SetMGWaitShow()
   FOR x := 1 TO Len( aFiles )
      cFile := US_FileNameOnlyNameAndExt( AllTrim( aFiles[x] ) )
      cFileUpper := US_Upper( cFile )
      cMode1 := ""
      cMode2 := ""
      FOR i := 1 TO VentanaMain.GDefFiles.ItemCount
         IF cFileUpper == US_Upper( GetProperty( 'VentanaMain', 'GDefFiles', 'Cell', i, NCOLDEFNAME ) )
            IF Empty( cMode1 )
               cMode1 := GetProperty( 'VentanaMain', 'GDefFiles', 'Cell', i, NCOLDEFMODE )
            ELSE
               cMode2 := GetProperty( 'VentanaMain', 'GDefFiles', 'Cell', i, NCOLDEFMODE )
               EXIT
            ENDIF
         ENDIF
      NEXT i
      IF Empty( cMode1 ) .OR. ( cMode1 $ "CG" .AND. Empty( cMode2 ) )
         IF cMode1 == "C"
            cMode := "G"
         ELSEIF cMode1 == "G"
            cMode := "C"
         ELSEIF cFileUpper == GetGTGUIName() .OR. cFileUpper == GetGTWINName()
            cMode := iif( Prj_Check_Console, "C", "G" )
         ELSE
            cMode := "B"
         ENDIF
         IF AScan( { 'VM.LIB', 'LIBVM.A', 'HBVM.LIB', 'LIBHBVM.A', 'VM64.LIB' }, cFileUpper ) # 0
            cThreads := "S"
         ELSEIF AScan( { 'VMMT.LIB', 'LIBVMMT.A', 'HBVMMT.LIB', 'LIBHBVMMT.A', 'VMMT64.LIB' }, cFileUpper ) # 0
            cThreads := "M"
         ELSE
            cThreads := "B"
         ENDIF
         IF AScan( { 'DEBUG.LIB', 'LIBDEBUG.A', 'HBDEBUG.LIB', 'LIBHBDEBUG.A', 'DEBUGGER.LIB', 'LIBDEBUGGER.A', 'HBDEBUGGER.LIB', 'LIBHBDEBUGGER.A' }, cFileUpper ) # 0
            cDebug := "Y"
         ELSE
            cDebug := "B"
         ENDIF
         VentanaMain.GDefFiles.AddItem( { PUB_nGridImgNone, cFile, cMode, cThreads, cDebug } )
         VentanaMain.GDefFiles.Value := VentanaMain.GDefFiles.ItemCount
         IF ! Empty( cLastGlobalSearch )
            IF GlobalSearch2( 'LIB', cLastGlobalSearch, VentanaMain.GDefFiles.ItemCount, bLastGlobalSearchFun, bLastGlobalSearchDbf )
               TotCaption( 'LIB', +1 )
            ENDIF
         ENDIF
      ELSE
         MyMsgStop( "Library " + DBLQT + cFile + DBLQT + " is already in the defaultlLibraries list!" )
      ENDIF
   NEXT x
   CheckRelativeOrderOfLibsGT()
   IF VentanaMain.GDefFiles.Value == 0
      VentanaMain.GDefFiles.Value := 1
   ENDIF
   DoMethod( 'VentanaMain', 'GDefFiles', 'ColumnsAutoFitH' )
   QPM_CheckFiles()
RETURN .T.

FUNCTION CheckRelativeOrderOfLibsGT()
   LOCAL i, cLib, iGuiC := 0, iWinC := 0, iGuiG := 0, iWinG := 0, n, m, t, d, lCont
   FOR i := 1 TO VentanaMain.GDefFiles.ItemCount
      cLib := US_Upper( GetProperty( 'VentanaMain', 'GDefFiles', 'Cell', i, NCOLDEFNAME ) )
      IF cLib == GetGTGUIName()
         IF GetProperty( 'VentanaMain', 'GDefFiles', 'Cell', i, NCOLDEFMODE ) == "C"
            iGuiC := i
         ELSE
            iGuiG := i
         ENDIF
      ELSEIF cLib == GetGTWINName()
         IF GetProperty( 'VentanaMain', 'GDefFiles', 'Cell', i, NCOLDEFMODE ) == "C"
            iWinC := i
         ELSE
            iWinG := i
         ENDIF
      ENDIF
   NEXT i
   IF iGuiC > 0 .AND. iWinC > 0
      IF iGuiC < iWinC
         IF Prj_Warn_GT_Order
            lCont := MyMsgYesNo( 'For a CONSOLE project the usual lib order is GTWIN first followed by GTGUI.' + CRLF + ;
                                 'Changing this order could end in a non-functional application.' + CRLF + ;
                                 'Select [Yes] to continue or [No] to change the order.' )
            IF MyMsgYesNo( 'Omit the previous validation from now on?' + CRLF + iif( lCont, "[Yes] will be assumed!", "[No] will be assumed!" ) )
               Prj_Warn_GT_Order := .F.
               Prj_Warn_GT_Order_Cont := lCont
               MyMsgInfo( 'Use ' + DBLQT + PUB_MenuResetWarnings + DBLQT + ' option of Settings menu to enable the previous check.' )
            ELSE
               Prj_Warn_GT_Order := .T.
            ENDIF
         ELSE
            lCont := Prj_Warn_GT_Order_Cont
         ENDIF
         IF lCont
            n := GetProperty( 'VentanaMain', 'GDefFiles', 'Cell', iGuiC, NCOLDEFNAME )
            m := GetProperty( 'VentanaMain', 'GDefFiles', 'Cell', iGuiC, NCOLDEFMODE )
            t := GetProperty( 'VentanaMain', 'GDefFiles', 'Cell', iGuiC, NCOLDEFTHREADS )
            d := GetProperty( 'VentanaMain', 'GDefFiles', 'Cell', iGuiC, NCOLDEFDEBUG )
            SetProperty( 'VentanaMain', 'GDefFiles', 'Cell', iGuiC, NCOLDEFNAME,    GetProperty( 'VentanaMain', 'GDefFiles', 'Cell', iWinC, NCOLDEFNAME ) )
            SetProperty( 'VentanaMain', 'GDefFiles', 'Cell', iGuiC, NCOLDEFMODE,    GetProperty( 'VentanaMain', 'GDefFiles', 'Cell', iWinC, NCOLDEFMODE ) )
            SetProperty( 'VentanaMain', 'GDefFiles', 'Cell', iGuiC, NCOLDEFTHREADS, GetProperty( 'VentanaMain', 'GDefFiles', 'Cell', iWinC, NCOLDEFTHREADS ) )
            SetProperty( 'VentanaMain', 'GDefFiles', 'Cell', iGuiC, NCOLDEFDEBUG,   GetProperty( 'VentanaMain', 'GDefFiles', 'Cell', iWinC, NCOLDEFDEBUG ) )
            SetProperty( 'VentanaMain', 'GDefFiles', 'Cell', iWinC, NCOLDEFNAME,    n )
            SetProperty( 'VentanaMain', 'GDefFiles', 'Cell', iWinC, NCOLDEFMODE,    m )
            SetProperty( 'VentanaMain', 'GDefFiles', 'Cell', iWinC, NCOLDEFTHREADS, t )
            SetProperty( 'VentanaMain', 'GDefFiles', 'Cell', iWinC, NCOLDEFDEBUG,   d )
         ENDIF
      ENDIF
   ENDIF
   IF iGuiG > 0 .AND. iWinG > 0
      IF iWinG < iGuiG
         IF Prj_Warn_GT_Order
            lCont := MyMsgYesNo( 'For a GUI project the usual lib order is GTGUI first followed by GTWIN.' + CRLF + ;
                                 'Changing this order could end in a non-functional application.' + CRLF + ;
                                 'Select [Yes] to continue or [No] to change the order.' )
            IF MyMsgYesNo( 'Omit the previous validation from now on?' + CRLF + iif( lCont, "[Yes] will be assumed!", "[No] will be assumed!" ) )
               Prj_Warn_GT_Order := .F.
               Prj_Warn_GT_Order_Cont := lCont
               MyMsgInfo( 'Use ' + DBLQT + PUB_MenuResetWarnings + DBLQT + ' option of Settings menu to enable the previous check.' )
            ELSE
               Prj_Warn_GT_Order := .T.
            ENDIF
         ELSE
            lCont := Prj_Warn_GT_Order_Cont
         ENDIF
         IF lCont
            n := GetProperty( 'VentanaMain', 'GDefFiles', 'Cell', iGuiG, NCOLDEFNAME )
            m := GetProperty( 'VentanaMain', 'GDefFiles', 'Cell', iGuiG, NCOLDEFMODE )
            t := GetProperty( 'VentanaMain', 'GDefFiles', 'Cell', iGuiG, NCOLDEFTHREADS )
            d := GetProperty( 'VentanaMain', 'GDefFiles', 'Cell', iGuiG, NCOLDEFDEBUG )
            SetProperty( 'VentanaMain', 'GDefFiles', 'Cell', iGuiG, NCOLDEFNAME,    GetProperty( 'VentanaMain', 'GDefFiles', 'Cell', iWinG, NCOLDEFNAME ) )
            SetProperty( 'VentanaMain', 'GDefFiles', 'Cell', iGuiG, NCOLDEFMODE,    GetProperty( 'VentanaMain', 'GDefFiles', 'Cell', iWinG, NCOLDEFMODE ) )
            SetProperty( 'VentanaMain', 'GDefFiles', 'Cell', iGuiG, NCOLDEFTHREADS, GetProperty( 'VentanaMain', 'GDefFiles', 'Cell', iWinG, NCOLDEFTHREADS ) )
            SetProperty( 'VentanaMain', 'GDefFiles', 'Cell', iGuiG, NCOLDEFDEBUG,   GetProperty( 'VentanaMain', 'GDefFiles', 'Cell', iWinG, NCOLDEFDEBUG ) )
            SetProperty( 'VentanaMain', 'GDefFiles', 'Cell', iWinG, NCOLDEFNAME,    n )
            SetProperty( 'VentanaMain', 'GDefFiles', 'Cell', iWinG, NCOLDEFMODE,    m )
            SetProperty( 'VentanaMain', 'GDefFiles', 'Cell', iWinG, NCOLDEFTHREADS, t )
            SetProperty( 'VentanaMain', 'GDefFiles', 'Cell', iWinG, NCOLDEFDEBUG,   d )
         ENDIF
      ENDIF
   ENDIF
RETURN NIL

FUNCTION QPM_AddIncludeLibs
RETURN QPM_Wait( 'QPM_AddIncludeLibs2()', 'Loading ...' )

FUNCTION QPM_AddIncludeLibs2()
   LOCAL Files, x, i, Exists
   SetMGWaitHide()
   Files := QPM_GetLibs()
   SetMGWaitShow()
   FOR x := 1 TO Len( Files )
      Exists := .F.
      Files[x] := ChgPathToRelative( Files[x] )
      FOR i := 1 TO VentanaMain.GIncFiles.ItemCount
         IF US_Upper( AllTrim( Files[x] ) ) == US_Upper( US_WordSubStr( GetProperty( 'VentanaMain', 'GIncFiles', 'Cell', i, NCOLINCFULLNAME ), 3 ) )
            Exists := .T.
            EXIT
         ENDIF
      NEXT i
      IF ! Exists
         VentanaMain.GIncFiles.AddItem( { PUB_nGridImgNone, US_FileNameOnlyNameAndExt( Files[x] ), '* * ' + Files[x] } )
         LibPos( VentanaMain.GIncFiles.ItemCount, '*LAST*' )
         IF ! Empty( cLastGlobalSearch )
            IF GlobalSearch2( 'LIB', cLastGlobalSearch, VentanaMain.GIncFiles.ItemCount, bLastGlobalSearchFun, bLastGlobalSearchDbf )
               TotCaption( 'LIB', +1 )
            ENDIF
         ENDIF
         IF AScan( &('vExtraFoldersForLibs'+GetSuffix()), US_Upper( US_FileNameOnlyPath( ChgPathToReal( Files[x] ) ) ) ) == 0
            AAdd( &('vExtraFoldersForLibs'+GetSuffix()), US_Upper( US_FileNameOnlyPath( ChgPathToReal( Files[x] ) ) ) )
         ENDIF
      ENDIF
   NEXT x
   IF VentanaMain.GIncFiles.Value == 0
      VentanaMain.GIncFiles.Value := 1
   ENDIF
   DoMethod( 'VentanaMain', 'GIncFiles', 'ColumnsAutoFitH' )
   QPM_CheckFiles()
RETURN .T.

FUNCTION QPM_AddExcludeLibs
   LOCAL Files, x, i, Exists
   Files := QPM_GetExcludeFilesLIB( )
   FOR x := 1 TO Len ( Files )
       Exists := .F.
       FOR i := 1 TO VentanaMain.GExcFiles.ItemCount
          IF US_Upper( Files[x] ) == US_Upper( GetProperty( 'VentanaMain', 'GExcFiles', 'Cell', i, NCOLEXCNAME ) )
             Exists := .T.
             EXIT
          ENDIF
       NEXT
       IF ! Exists
          VentanaMain.GExcFiles.AddItem( { PUB_nGridImgNone, Files[x] } )
       ENDIF
   NEXT
   DoMethod( 'VentanaMain', 'GExcFiles', 'ColumnsAutoFitH' )
   QPM_CheckFiles()
RETURN .T.

#ifdef QPM_SHG
FUNCTION QPM_AddFilesHLP()
   LOCAL cAuxTopic := '', cAuxNick := ''
   IF SHG_BaseOK
      SetMGWaitHide()
      IF SHG_InputTopic( @cAuxTopic, @cAuxNick )
         SetMGWaitShow()
         VentanaMain.GHlpFiles.AddItem( { 0, cAuxTopic, cAuxNick, '0', 'E' } )
         GridImage( 'VentanaMain', 'GHlpFiles', VentanaMain.GHlpFiles.ItemCount, NCOLHLPSTATUS, '+', PUB_nGridImgHlpPage )
         SHG_AddRecord( 'P', VentanaMain.GHlpFiles.ItemCount, cAuxTopic, cAuxNick, 'New Topic!' )
         VentanaMain.GHlpFiles.Value := VentanaMain.GHlpFiles.ItemCount
         DoMethod( 'VentanaMain', 'GHlpFiles', 'ColumnsAutoFitH' )
      ELSE
         SetMGWaitShow()
      ENDIF
   ELSE
      MyMsgInfo( "Help Database has not been selected." + CRLF + "Use Open button to open or create a Help Database." )
   ENDIF
RETURN .T.
#endif

FUNCTION QPM_EditPRG
   LOCAL Editor, Rs, i, vAux := {}
   LOCAL EditControlFile, RunParms, cLineCmd, cLineFile
#ifdef QPM_HOTRECOVERY
   LOCAL HotRecoveryControlFile
#endif
   IF Empty( PUB_cProjectFolder ) .OR. ! US_IsDirectory( PUB_cProjectFolder )
      MyMsgStop( DBLQT + "Project Folder" + DBLQT + " is not a valid folder:" + CRLF + PUB_cProjectFolder + CRLF + 'Look at tab ' + DBLQT + PagePRG + DBLQT )
      RETURN .F.
   ENDIF
   IF VentanaMain.GPrgFiles.Value < 1
      MyMsgStop( 'No file has been selected!' )
      RETURN .F.
   ENDIF
   IF ! File( i := ChgPathToReal( GetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', VentanaMain.GPrgFiles.Value, NCOLPRGFULLNAME ) ) )
      MyMsgStop( 'File not found: ' + DBLQT + i + DBLQT )
      RETURN .F.
   ENDIF
   IF Empty( Gbl_Text_Editor )
      MyMsgStop( 'Editor is not defined.' + CRLF + ' Look at ' + PUB_MenuGblOptions + ' of Settings menu.' )
      RETURN .F.
   ENDIF
   IF ! File( Editor := ChgPathToReal( AllTrim( Gbl_Text_Editor ) ) )
      MyMsgStop( 'Editor ' + DBLQT + AllTrim( Gbl_Text_Editor ) + DBLQT + ' not found!' + CRLF + 'Look at ' + PUB_MenuGblOptions + ' of Settings menu.' )
      RETURN .F.
   ENDIF
   QPM_LogText( 'Edit PRG ' + i )
   IF bSuspendControlEdit
      IF bEditorLongName
         cLineCmd := Editor
         cLineFile := i
      ELSE
         cLineCmd := US_ShortName( Editor )
         cLineFile := US_ShortName( i )
      ENDIF
      QPM_Execute( cLineCmd, cLineFile )
      QPM_LogText( "COMMAND " + cLineCmd + CRLF + "FILE " + cLineFile )
   ELSE
      IF GridImage( 'VentanaMain', 'GPrgFiles', VentanaMain.GPrgFiles.Value, NCOLPRGSTATUS, '?', PUB_nGridImgEdited )
         MyMsgStop( 'The file is already open!' )
         RETURN .F.
      ENDIF
      GridImage( 'VentanaMain', 'GPrgFiles', VentanaMain.GPrgFiles.Value, NCOLPRGSTATUS, '+', PUB_nGridImgEdited )
      VentanaMain.RichEditPrg.BackColor := DEF_COLORBACKEXTERNALEDIT
      VentanaMain.RichEditPrg.FontColor := DEF_COLORFONTEXTERNALEDIT
      EditControlFile := US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + '_' + PUB_cSecu + 'ECF' + US_DateTimeCen() + '.cnt'
#ifdef QPM_HOTRECOVERY
      HotRecoveryControlFile := US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + '_' + PUB_cSecu + 'SrcHOTRecovery' + US_DateTimeCen() + '.hot'
      US_FileCopy( i, HotRecoveryControlFile )
      SetFDaTi( HotRecoveryControlFile, US_FileDate( i ), US_FileTime( i ) )
      SetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', VentanaMain.GPrgFiles.Value, NCOLPRGRECOVERY, HotRecoveryControlFile )
      IF _IsControlDefined( 'HR_GridItemTargetPRG', 'WinHotRecovery' )
         GridImage( 'WinHotRecovery', 'HR_GridItemTargetPRG', GetProperty( 'VentanaMain', 'GPrgFiles', 'Value' ), DEF_N_ITEM_COLIMAGE, '+', PUB_nGridImgEdited )
      ENDIF
#endif
      SetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', VentanaMain.GPrgFiles.Value, NCOLPRGEDIT, EditControlFile )
      RunParms := US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + '_' + PUB_cSecu + 'RP' + US_DateTimeCen() + '.cng'
      IF bEditorLongName
         cLineCmd := Editor
         cLineFile := i
      ELSE
         cLineCmd := US_ShortName( Editor )
         cLineFile := US_ShortName( i )
      ENDIF
      QPM_LogText( RunParms )
      QPM_MemoWrit( RunParms, 'Run Parms For ' + i + CRLF + ;
                              "COMMAND " + cLineCmd + " " + cLineFile + CRLF + ;
                              'CONTROL ' + EditControlFile + CRLF )
      QPM_LogFile( RunParms )
      QPM_MemoWrit( EditControlFile, 'Edit Control File For ' + i )
      QPM_Execute( US_ShortName( PUB_cQPM_Folder ) + DEF_SLASH + 'US_Run.exe', 'QPM' + LISTOLOG + RunParms )
      QPM_LogText( "Done" )
   ENDIF
   IF ( Rs := AScan( vSinLoadWindow, { |y| US_Upper( US_VarToStr( y ) ) == US_Upper( ChgPathToReal( GetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', VentanaMain.GPrgFiles.Value, NCOLPRGFULLNAME ) ) ) } ) ) > 0 // Para Forzar Scan de PRG en busca de xREF con FMG
      ADel( vSinLoadWindow, Rs ) // Para Forzar Scan de PRG en busca de xREF con FMG
      ASize( vSinLoadWindow, Len( vSinLoadWindow ) - 1 )
      QPM_LogText( 'xRefPrgFmg Delete ' + GetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', VentanaMain.GPrgFiles.Value, NCOLPRGFULLNAME ) + ' from vSinLoadWindow by Edit' )
   ENDIF
   IF ( Rs := AScan( vSinInclude, { |y| US_Upper( US_VarToStr( y ) ) == US_Upper( ChgPathToReal( GetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', VentanaMain.GPrgFiles.Value, NCOLPRGFULLNAME ) ) ) } ) ) > 0 // Para Forzar Scan de PRG en busca de xREF con Header
      ADel( vSinInclude, Rs ) // Para Forzar Scan de PRG en busca de xREF con HEA
      ASize( vSinInclude, Len( vSinInclude ) - 1 )
      QPM_LogText( 'xRefPrgHea Delete ' + GetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', VentanaMain.GPrgFiles.Value, NCOLPRGFULLNAME ) + ' from vSinInclude by Edit' )
   ENDIF
   /* limpio las ocurrencias del prg dentro de xref con header */
   FOR i := 1 TO Len( vXRefPrgHea )
      IF ! ( US_Word( vXRefPrgHea[i], 1 ) == US_Upper( US_FileNameOnlyNameAndExt( GetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', VentanaMain.GPrgFiles.Value, NCOLPRGFULLNAME ) ) ) )
         AAdd( vAux, vXRefPrgHea[i] )
      ENDIF
   NEXT
   vXRefPrgHea := {}
   FOR i := 1 TO Len( vAux )
      AAdd( vXRefPrgHea, vAux[i] )
   NEXT
   /* fin limpio las ocurrencias del prg */
   vAux := {}
   /* limpio las ocurrencias del prg dentro de xref con form   */
   FOR i := 1 TO Len( vXRefPrgFmg )
      IF ! ( US_Word( vXRefPrgFmg[i], 1 ) == US_Upper( US_FileNameOnlyNameAndExt( GetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', VentanaMain.GPrgFiles.Value, NCOLPRGFULLNAME ) ) ) )
         AAdd( vAux, vXRefPrgFmg[i] )
      ENDIF
   NEXT
   vXRefPrgFmg := {}
   FOR i := 1 TO Len( vAux )
      AAdd( vXRefPrgFmg, vAux[i] )
   NEXT
   /* fin limpio las ocurrencias del prg */
RETURN .T.

FUNCTION QPM_EditPPO
   LOCAL Editor, i, cLineCmd, cLineFile
   IF Empty( PUB_cProjectFolder ) .OR. ! US_IsDirectory( PUB_cProjectFolder )
      MyMsgStop( DBLQT + "Project Folder" + DBLQT + " is not a valid folder:" + CRLF + PUB_cProjectFolder + CRLF + 'Look at tab ' + DBLQT + PagePRG + DBLQT )
      RETURN .F.
   ENDIF
   IF VentanaMain.GPrgFiles.Value < 1
      MyMsgStop( 'No file has been selected!' )
      RETURN .F.
   ENDIF
   IF ! File( i := ChgPathToReal( GetObjFolder() + DEF_SLASH + US_FileNameOnlyName( GetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', VentanaMain.GPrgFiles.Value, NCOLPRGNAME ) ) + '.ppo' ) )
      MyMsgStop( 'File not found: ' + DBLQT + i + DBLQT )
      RETURN .F.
   ENDIF
   IF Empty( Gbl_Text_Editor )
      MyMsgStop( 'Editor is not defined.' + CRLF + ' Look at ' + PUB_MenuGblOptions + ' of Settings menu.' )
      RETURN .F.
   ENDIF
   IF ! File( Editor := ChgPathToReal( AllTrim( Gbl_Text_Editor ) ) )
      MyMsgStop( 'Editor not found: ' + AllTrim( Gbl_Text_Editor ) + CRLF + 'Look at ' + PUB_MenuGblOptions + ' of Settings menu.' )
      RETURN .F.
   ENDIF
   QPM_LogText( 'Edit PPO ' + i )
   IF bEditorLongName
      cLineCmd := Editor
      cLineFile := i
   ELSE
      cLineCmd := US_ShortName( Editor )
      cLineFile := US_ShortName( i )
   ENDIF
   QPM_Execute( cLineCmd, cLineFile )
   QPM_LogText( 'COMMAND ' + cLineCmd + CRLF + "FILE " + cLineFile )
RETURN .T.

FUNCTION QPM_EditHEA
   LOCAL Editor, i
   LOCAL EditControlFile, RunParms, cLineCmd, cLineFile
#ifdef QPM_HOTRECOVERY
   LOCAL HotRecoveryControlFile
#endif
   IF Empty( PUB_cProjectFolder ) .OR. ! US_IsDirectory( PUB_cProjectFolder )
      MyMsgStop( DBLQT + "Project Folder" + DBLQT + " is not a valid folder:" + CRLF + PUB_cProjectFolder + CRLF + 'Look at tab ' + DBLQT + PagePRG + DBLQT )
      RETURN .F.
   ENDIF
   IF VentanaMain.GHeaFiles.Value < 1
      MyMsgStop( 'No file has been selected!' )
      RETURN .F.
   ENDIF
   IF ! File( i := ChgPathToReal( GetProperty( 'VentanaMain', 'GHeaFiles', 'Cell', VentanaMain.GHeaFiles.Value, NCOLHEAFULLNAME ) ) )
      MyMsgStop( 'File not found: ' + DBLQT + i + DBLQT )
      RETURN .F.
   ENDIF
   IF Empty( Gbl_Text_Editor )
      MyMsgStop( 'Editor is not defined.' + CRLF + ' Look at ' + PUB_MenuGblOptions + ' of Settings menu.' )
      RETURN .F.
   ENDIF
   IF ! File( Editor := ChgPathToReal( AllTrim( Gbl_Text_Editor ) ) )
      MyMsgStop( 'Editor not found: ' + AllTrim( Gbl_Text_Editor ) + CRLF + 'Look at ' + PUB_MenuGblOptions + ' of Settings menu.' )
      RETURN .F.
   ENDIF
   QPM_LogText( 'Edit Header ' + i )
   IF bSuspendControlEdit
      IF bEditorLongName
         cLineCmd := Editor
         cLineFile := i
      ELSE
         cLineCmd := US_ShortName( Editor )
         cLineFile := US_ShortName( i )
      ENDIF
      QPM_Execute( cLineCmd, cLineFile )
      QPM_LogText( 'COMMAND ' + cLineCmd + CRLF + "FILE " + cLineFile )
   ELSE
      IF GridImage( 'VentanaMain', 'GHeaFiles', VentanaMain.GHeaFiles.Value, NCOLHEASTATUS, '?', PUB_nGridImgEdited )
         MyMsgStop( 'The file is already open!' )
         RETURN .F.
      ENDIF
      GridImage( 'VentanaMain', 'GHeaFiles', VentanaMain.GHeaFiles.Value, NCOLHEASTATUS, '+', PUB_nGridImgEdited )
      VentanaMain.RichEditHea.BackColor := DEF_COLORBACKEXTERNALEDIT
      VentanaMain.RichEditHea.FontColor := DEF_COLORFONTEXTERNALEDIT
      EditControlFile := US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + '_' + PUB_cSecu + 'ECF' + US_DateTimeCen() + '.cnt'
#ifdef QPM_HOTRECOVERY
      HotRecoveryControlFile := US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + '_' + PUB_cSecu + 'HeaHOTRecovery' + US_DateTimeCen() + '.hot'
      US_FileCopy( i, HotRecoveryControlFile )
      SetFDaTi( HotRecoveryControlFile, US_FileDate( i ), US_FileTime( i ) )
      SetProperty( 'VentanaMain', 'GHeaFiles', 'Cell', VentanaMain.GHeaFiles.Value, NCOLHEARECOVERY, HotRecoveryControlFile )
      IF _IsControlDefined( 'HR_GridItemTargetHea', 'WinHotRecovery' )
         GridImage( 'WinHotRecovery', 'HR_GridItemTargetHea', GetProperty( 'VentanaMain', 'GHeaFiles', 'Value' ), DEF_N_ITEM_COLIMAGE, '+', PUB_nGridImgEdited )
      ENDIF
#endif
      SetProperty( 'VentanaMain', 'GHeaFiles', 'Cell', VentanaMain.GHeaFiles.Value, NCOLHEAEDIT, EditControlFile )
      RunParms := US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + '_' + PUB_cSecu + 'RP' + US_DateTimeCen() + '.cng'
      IF bEditorLongName
         cLineCmd := Editor
         cLineFile := i
      ELSE
         cLineCmd := US_ShortName( Editor )
         cLineFile := US_ShortName( i )
      ENDIF
      QPM_LogText( RunParms )
      QPM_MemoWrit( RunParms, 'Run Parms For ' + i + CRLF + ;
                              "COMMAND " + cLineCmd + " " + cLineFile + CRLF + ;
                              'CONTROL ' + EditControlFile )
      QPM_LogFile( RunParms )
      QPM_MemoWrit( EditControlFile, 'Edit Control File For ' + i )
      QPM_Execute( US_ShortName( PUB_cQPM_Folder ) + DEF_SLASH + 'US_Run.exe', 'QPM' + LISTOLOG + RunParms )
      QPM_LogText( "Done" )
   ENDIF
RETURN .T.

FUNCTION QPM_EditPAN( bForceEditor )
   LOCAL Editor, toolMake, ToolAux, i
   LOCAL EditControlFile, RunParms, cLineCmd, cLineFile
#ifdef QPM_HOTRECOVERY
   LOCAL HotRecoveryControlFile
#endif
   IF Empty( bForceEditor )
      bForceEditor := .F.
   ENDIF
   IF Empty( PUB_cProjectFolder ) .OR. ! US_IsDirectory( PUB_cProjectFolder )
      MyMsgStop( DBLQT + "Project Folder" + DBLQT + " is not a valid folder:" + CRLF + PUB_cProjectFolder + CRLF + 'Look at tab ' + DBLQT + PagePRG + DBLQT )
      RETURN .F.
   ENDIF
   IF VentanaMain.GPanFiles.Value < 1
      MyMsgStop( 'No file has been selected!' )
      RETURN .F.
   ENDIF
   IF ! File( i := ChgPathToReal( GetProperty( 'VentanaMain', 'GPanFiles', 'Cell', VentanaMain.GPanFiles.Value, NCOLPANFULLNAME ) ) )
      MyMsgStop( 'File not found: ' + DBLQT + i + DBLQT )
      RETURN .F.
   ENDIF
   IF bForceEditor
      ToolAux := 'EDITOR'
   ELSE
      ToolAux := GetFormTool()   // EDITOR, OOHGIDE, HMGSIDE, HMG_IDE
   ENDIF
   DO CASE
   CASE ToolAux == 'EDITOR'
      IF Empty( Gbl_Text_Editor )
         MyMsgStop( 'Editor is not defined.' + CRLF + 'Look at ' + PUB_MenuGblOptions + ' of Settings menu.' )
         RETURN .F.
      ENDIF
      IF ! File( Editor := ChgPathToReal( AllTrim( Gbl_Text_Editor ) ) )
         MyMsgStop( 'Editor not found: ' + AllTrim( Gbl_Text_Editor ) + CRLF + 'Look at ' + PUB_MenuGblOptions + ' of Settings menu.' )
         RETURN .F.
      ENDIF
      QPM_LogText( 'Edit PAN ' + i )
      IF bSuspendControlEdit
         IF bEditorLongName
            cLineCmd := Editor
            cLineFile := i
         ELSE
            cLineCmd := US_ShortName( Editor )
            cLineFile := US_ShortName( i )
         ENDIF
         QPM_Execute( cLineCmd, iif( bNoFMGextension, US_FileNameOnlyPathAndName( cLineFile ), cLineFile ) )
         QPM_LogText( 'COMMAND ' + cLineCmd + CRLF + "FILE " + cLineFile )
      ELSE
         IF GridImage( 'VentanaMain', 'GPanFiles', VentanaMain.GPanFiles.Value, NCOLPANSTATUS, '?', PUB_nGridImgEdited )
            MyMsgStop( 'The file is already open!' )
            RETURN .F.
         ENDIF
         GridImage( 'VentanaMain', 'GPanFiles', VentanaMain.GPanFiles.Value, NCOLPANSTATUS, '+', PUB_nGridImgEdited )
         VentanaMain.RichEditPan.BackColor := DEF_COLORBACKEXTERNALEDIT
         VentanaMain.RichEditPan.FontColor := DEF_COLORFONTEXTERNALEDIT
         EditControlFile := US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + '_' + PUB_cSecu + 'ECF' + US_DateTimeCen() + '.cnt'
#ifdef QPM_HOTRECOVERY
         HotRecoveryControlFile := US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + '_' + PUB_cSecu + 'PanHOTRecovery' + US_DateTimeCen() + '.hot'
         US_FileCopy( i, HotRecoveryControlFile )
         SetFDaTi( HotRecoveryControlFile, US_FileDate( i ), US_FileTime( i ) )

         SetProperty( 'VentanaMain', 'GPanFiles', 'Cell', VentanaMain.GPanFiles.Value, NCOLPANRECOVERY, HotRecoveryControlFile )
         IF _IsControlDefined( 'HR_GridItemTargetPan', 'WinHotRecovery' )
            GridImage( 'WinHotRecovery', 'HR_GridItemTargetPan', GetProperty( 'VentanaMain', 'GPanFiles', 'Value' ), DEF_N_ITEM_COLIMAGE, '+', PUB_nGridImgEdited )
         ENDIF
#endif
         SetProperty( 'VentanaMain', 'GPanFiles', 'Cell', VentanaMain.GPanFiles.Value, NCOLPANEDIT, EditControlFile )
         RunParms := US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + '_' + PUB_cSecu + 'RP' + US_DateTimeCen() + '.cng'
         IF bEditorLongName
            cLineCmd := Editor
            cLineFile := i
         ELSE
            cLineCmd := US_ShortName( Editor )
            cLineFile := US_ShortName( i )
         ENDIF
         QPM_LogText( RunParms )
         QPM_MemoWrit( RunParms, 'Run Parms For ' + i + CRLF + ;
                                 "COMMAND " + cLineCmd + " " + iif( bNoFMGextension, US_FileNameOnlyPathAndName( cLineFile ), cLineFile ) + CRLF + ;
                                 'CONTROL ' + EditControlFile )
         QPM_LogFile( RunParms )
         QPM_MemoWrit( EditControlFile, 'Edit Control File For ' + i )
         QPM_Execute( US_ShortName( PUB_cQPM_Folder ) + DEF_SLASH + 'US_Run.exe', 'QPM' + LISTOLOG + RunParms )
         QPM_LogFile( "Done" )
      ENDIF
   CASE ToolAux == "OOHGIDE" .OR. ToolAux == 'HMGSIDE' .OR. ToolAux == 'HMG_IDE'
      IF ToolAux == 'OOHG'
         IF Empty( Gbl_Text_OOHGIDE )
            MyMsgStop( 'Form tool is not defined.' + CRLF + 'Look at ' + PUB_MenuGblOptions + ' of Settings menu.' )
            RETURN .F.
         ELSEIF ! File( Editor := ChgPathToReal( AllTrim( Gbl_Text_OOHGIDE ) ) )
            MyMsgStop( 'Form tool not found: ' + AllTrim( Gbl_Text_OOHGIDE ) + CRLF + 'Look at ' + PUB_MenuGblOptions + ' of Settings menu.' )
            RETURN .F.
         ENDIF
      ELSEIF ToolAux == 'HMGSIDE'
         IF Empty( Gbl_Text_HMGSIDE )
            MyMsgStop( 'Form tool is not defined.' + CRLF + 'Look at ' + PUB_MenuGblOptions + ' of Settings menu.' )
            RETURN .F.
         ELSEIF ! File( Editor := ChgPathToReal( AllTrim( Gbl_Text_HMGSIDE ) ) )
            MyMsgStop( 'Form tool not found: ' + AllTrim( Gbl_Text_HMGSIDE ) + CRLF + 'Look at ' + PUB_MenuGblOptions + ' of Settings menu.' )
            RETURN .F.
         ENDIF
      ELSE
         IF Empty( Gbl_Text_HMG_IDE )
            MyMsgStop( 'Form tool is not defined.' + CRLF + 'Look at ' + PUB_MenuGblOptions + ' of Settings menu.' )
            RETURN .F.
         ELSEIF ! File( Editor := ChgPathToReal( AllTrim( Gbl_Text_HMG_IDE ) ) )
            MyMsgStop( 'Form tool not found: ' + AllTrim( Gbl_Text_HMG_IDE ) + CRLF + 'Look at ' + PUB_MenuGblOptions + ' of Settings menu.' )
            RETURN .F.
         ENDIF
      ENDIF
      IF bSuspendControlEdit
         IF bEditorLongName
            cLineCmd := Editor
            cLineFile := i
         ELSE
            cLineCmd := US_ShortName( Editor )
            cLineFile := US_ShortName( i )
         ENDIF
         QPM_Execute( cLineCmd, iif( bNoFMGextension, US_FileNameOnlyPathAndName( cLineFile ), cLineFile ) )
         QPM_LogText( 'COMMAND ' + cLineCmd + CRLF + "FILE " + cLineFile )
      ELSE
         IF GridImage( 'VentanaMain', 'GPanFiles', VentanaMain.GPanFiles.Value, NCOLPANSTATUS, '?', PUB_nGridImgEdited )
            MyMsgStop( 'The file is already open!' )
            RETURN .F.
         ENDIF
         toolMake := US_Word( CheckMakeForm( US_ShortName( i ) ), 1 )
         IF toolMake == 'UNKNOWN'
            IF ! MyMsgYesNo( 'The form was built with an unknown tool.' + CRLF + ;
                             'Do you want to edit it with ' + DBLQT + iif( ToolAux == "OOHGIDE", 'OOHG IDE+', iif( ToolAux == 'HMGS-IDE', 'HMGS-IDE', 'HMG-IDE' ) ) + DBLQT + '?' + CRLF + ;
                             'Note that some form features may not be supported by this tool.' )
               RETURN .F.
            ENDIF
         ELSEIF ! toolMake == ToolAux
            IF ! MyMsgYesNo( 'The form was built with tool: ' + DBLQT + toolMake + DBLQT + CRLF + ;
                             'Do you want to edit it with ' + DBLQT + iif( ToolAux == "OOHGIDE", 'OOHG IDE+', iif( ToolAux == 'HMGS-IDE', 'HMGS-IDE', 'HMG-IDE' ) ) + DBLQT + '?' + CRLF + ;
                             'Note that some form features may not be supported by this tool.' )
               RETURN .F.
            ENDIF
         ENDIF
         GridImage( 'VentanaMain', 'GPanFiles', VentanaMain.GPanFiles.Value, NCOLPANSTATUS, '+', PUB_nGridImgEdited )
         VentanaMain.RichEditPan.BackColor := DEF_COLORBACKEXTERNALEDIT
         VentanaMain.RichEditPan.FontColor := DEF_COLORFONTEXTERNALEDIT
         EditControlFile := US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + '_' + PUB_cSecu + 'ECF' + US_DateTimeCen() + '.cnt'
#ifdef QPM_HOTRECOVERY
         HotRecoveryControlFile := US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + '_' + PUB_cSecu + 'PanHOTRecovery' + US_DateTimeCen() + '.hot'
         US_FileCopy( i, HotRecoveryControlFile )
         SetFDaTi( HotRecoveryControlFile, US_FileDate( i ), US_FileTime( i ) )
         SetProperty( 'VentanaMain', 'GPanFiles', 'Cell', VentanaMain.GPanFiles.Value, NCOLPANRECOVERY, HotRecoveryControlFile )
         IF _IsControlDefined( 'HR_GridItemTargetPan', 'WinHotRecovery' )
            GridImage( 'WinHotRecovery', 'HR_GridItemTargetPan', GetProperty( 'VentanaMain', 'GPanFiles', 'Value' ), DEF_N_ITEM_COLIMAGE, '+', PUB_nGridImgEdited )
         ENDIF
#endif
         SetProperty( 'VentanaMain', 'GPanFiles', 'Cell', VentanaMain.GPanFiles.Value, NCOLPANEDIT, EditControlFile )
         RunParms := US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + '_' + PUB_cSecu + 'RP' + US_DateTimeCen() + '.cng'
         IF bEditorLongName
            cLineCmd := Editor
            cLineFile := i
         ELSE
            cLineCmd := US_ShortName( Editor )
            cLineFile := US_ShortName( i )
         ENDIF
         QPM_LogText( RunParms )
         QPM_MemoWrit( RunParms, 'Run Parms For ' + i + CRLF + ;
                                 "COMMAND " + cLineCmd + " " + iif( bNoFMGextension, US_FileNameOnlyPathAndName( cLineFile ), cLineFile ) + CRLF + ;
                                 'CONTROL ' + EditControlFile )
         QPM_LogFile( RunParms )
         QPM_MemoWrit( EditControlFile, 'Edit Control File For ' + i )
         QPM_Execute( US_ShortName( PUB_cQPM_Folder ) + DEF_SLASH + 'US_Run.exe', 'QPM' + LISTOLOG + RunParms )
         QPM_LogText( "Done" )
      ENDIF
   OTHERWISE
      QPM_LogText( 'Edit PAN ' + i + CRLF + 'Form tool is not supported: ' + ToolAux )
      MyMsgStop( 'Form tool error!' + CRLF + 'Look at ' + PUB_MenuPrjOptions + ' of Settings menu.' )
      RETURN .F.
   ENDCASE
RETURN .T.

FUNCTION QPM_EditDBF()
   LOCAL EditControlFile, RunParms, cLineCmd, Editor, i, cLineFile
   IF GridImage( 'VentanaMain', 'GDbfFiles', VentanaMain.GDbfFiles.Value, NCOLDBFSTATUS, '?', PUB_nGridImgEdited )
      MyMsgStop( 'The file is already open!' )
      RETURN .F.
   ENDIF
   IF Empty( PUB_cProjectFolder ) .OR. ! US_IsDirectory( PUB_cProjectFolder )
      MyMsgStop( DBLQT + "Project Folder" + DBLQT + " is not a valid folder:" + CRLF + PUB_cProjectFolder + CRLF + 'Look at tab ' + DBLQT + PagePRG + DBLQT )
      RETURN .F.
   ENDIF
   IF VentanaMain.GDbfFiles.Value < 1
      MyMsgStop( 'No file has been selected!' )
      RETURN .F.
   ENDIF
   IF ! File( i := ChgPathToReal( GetProperty( 'VentanaMain', 'GDbfFiles', 'Cell', VentanaMain.GDbfFiles.Value, NCOLDBFFULLNAME ) ) )
      MyMsgStop( 'File not found: ' + DBLQT + i + DBLQT )
      RETURN .F.
   ENDIF
   QPM_LogText( 'Edit DBF ' + i )
   IF Prj_Radio_DbfTool == DEF_RG_DBFTOOL
      IF ! File( Editor := ChgPathToReal( AllTrim( PUB_cQPM_Folder ) + DEF_SLASH + 'US_DBFVIEW.exe' ) )
         MyMsgStop( "QPM's DBF editor (US_DBFVIEW.exe) not found!" + CRLF + 'Reinstall QPM.' )
         RETURN .F.
      ENDIF
      IF bSuspendControlEdit
         IF bEditorLongName
            cLineCmd := Editor
            cLineFile := i
         ELSE
            cLineCmd := US_ShortName( Editor )
            cLineFile := US_ShortName( i )
         ENDIF
         QPM_Execute( cLineCmd, cLineFile )
         QPM_LogText( 'COMMAND ' + cLineCmd + CRLF + "FILE " + cLineFile )
      ELSE
         GridImage( 'VentanaMain', 'GDbfFiles', VentanaMain.GDbfFiles.Value, NCOLDBFSTATUS, '+', PUB_nGridImgEdited )
         VentanaMain.RichEditDbf.BackColor := DEF_COLORBACKEXTERNALEDIT
         VentanaMain.RichEditDbf.FontColor := DEF_COLORFONTEXTERNALEDIT
         CloseDbfAutoView()
         DefineRichEditForNotDbfView( 'DBF Open with QPM tool!' )
         EditControlFile := US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + '_' + PUB_cSecu + 'ECF' + US_DateTimeCen() + '.cnt'
         SetProperty( 'VentanaMain', 'GDbfFiles', 'Cell', VentanaMain.GDbfFiles.Value, NCOLDBFEDIT, EditControlFile )
         RunParms := US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + '_' + PUB_cSecu + 'RP' + US_DateTimeCen() + '.cng'
         IF bEditorLongName
            cLineCmd := Editor
            cLineFile := i
         ELSE
            cLineCmd := US_ShortName( Editor )
            cLineFile := US_ShortName( i )
         ENDIF
         QPM_LogText( RunParms )
         QPM_MemoWrit( RunParms, 'Run Parms For ' + i + CRLF + ;
                                 "COMMAND " + cLineCmd + " " + cLineFile + CRLF + ;
                                 'CONTROL ' + EditControlFile )
         QPM_LogFile( RunParms )
         QPM_MemoWrit( EditControlFile, 'Edit Control File For ' + i )
         QPM_Execute( US_ShortName( PUB_cQPM_Folder ) + DEF_SLASH + 'US_Run.exe', 'QPM' + LISTOLOG + RunParms )
         QPM_LogText( "Done" )
      ENDIF
   ELSE // 'OTHER'
      IF Empty( Gbl_Text_DBF )
         MyMsgStop( 'DBF tool is not defined!' + CRLF + 'Look at ' + PUB_MenuGblOptions + ' of Settings menu.' )
         RETURN .F.
      ENDIF
      IF ! File( Editor := ChgPathToReal( AllTrim( Gbl_Text_DBF ) ) )
         MyMsgStop( 'DBF tool ' + DBLQT + AllTrim( Gbl_Text_DBF ) + DBLQT + ' was not found!' + CRLF + 'Look at ' + PUB_MenuGblOptions + ' of Settings menu.' )
         RETURN .F.
      ENDIF
      IF bSuspendControlEdit
         IF bEditorLongName
            cLineCmd := Editor
            cLineFile := i
         ELSE
            cLineCmd := US_ShortName( Editor )
            cLineFile := US_ShortName( i )
         ENDIF
         QPM_Execute( cLineCmd, cLineFile )
         QPM_LogText( 'COMMAND ' + cLineCmd + CRLF + "FILE " + cLineFile )
      ELSE
         GridImage( 'VentanaMain', 'GDbfFiles', VentanaMain.GDbfFiles.Value, NCOLDBFSTATUS, '+', PUB_nGridImgEdited )
         VentanaMain.RichEditDbf.BackColor := DEF_COLORBACKEXTERNALEDIT
         VentanaMain.RichEditDbf.FontColor := DEF_COLORFONTEXTERNALEDIT
         CloseDbfAutoView()
         DefineRichEditForNotDbfView( 'DBF Open with external tool!' )
         EditControlFile := US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + '_' + PUB_cSecu + 'ECF' + US_DateTimeCen() + '.cnt'
         SetProperty( 'VentanaMain', 'GDbfFiles', 'Cell', VentanaMain.GDbfFiles.Value, NCOLDBFEDIT, EditControlFile )
         RunParms := US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + '_' + PUB_cSecu + 'RP' + US_DateTimeCen() + '.cng'
         IF bEditorLongName
            cLineCmd := Editor
            cLineFile := Gbl_Comillas_DBF + i + Gbl_Comillas_DBF
         ELSE
            cLineCmd := US_ShortName( Editor )
            cLineFile := Gbl_Comillas_DBF + US_ShortName( i ) + Gbl_Comillas_DBF
         ENDIF
         QPM_LogText( RunParms )
         QPM_MemoWrit( RunParms, 'Run Parms For ' + i + CRLF + ;
                                 "COMMAND " + cLineCmd + " " + cLineFile + CRLF + ;
                                 'CONTROL ' + EditControlFile )
         QPM_LogFile( RunParms )
         QPM_MemoWrit( EditControlFile, 'Edit Control File For ' + i )
         QPM_Execute( US_ShortName( PUB_cQPM_Folder ) + DEF_SLASH + 'US_Run.exe', 'QPM' + LISTOLOG + RunParms )
         QPM_LogText( "Done" )
      ENDIF
   ENDIF
RETURN .T.

#ifdef QPM_SHG
FUNCTION QPM_EditHLP()
   LOCAL cAuxTopic := '', cAuxNick
   IF VentanaMain.GHlpFiles.Value == 1
      MyMsgStop( "Global footer can't be edited!" )
      RETURN .T.
   ENDIF
   IF VentanaMain.GHlpFiles.Value > 1
      cAuxTopic := AllTrim( GetProperty( 'VentanaMain', 'GHlpFiles', 'Cell', VentanaMain.GHlpFiles.Value, NCOLHLPTOPIC ) )
      cAuxNick  := AllTrim( GetProperty( 'VentanaMain', 'GHlpFiles', 'Cell', VentanaMain.GHlpFiles.Value, NCOLHLPNICK ) )
      IF SHG_InputTopic( @cAuxTopic, @cAuxNick )
         SetProperty( 'VentanaMain', 'GHlpFiles', 'Cell', VentanaMain.GHlpFiles.Value, NCOLHLPTOPIC, cAuxTopic )
         SetProperty( 'VentanaMain', 'GHlpFiles', 'Cell', VentanaMain.GHlpFiles.Value, NCOLHLPNICK, cAuxNick )
         DoMethod( 'VentanaMain', 'GHlpFiles', 'ColumnsAutoFitH' )
         SHG_SetField( 'SHG_TOPICT', VentanaMain.GHlpFiles.Value, cAuxTopic )
         SHG_SetField( 'SHG_NICKT', VentanaMain.GHlpFiles.Value, cAuxNick )
         IF ! ( AllTrim( cAuxTopic ) == SHG_GetField( 'SHG_TOPIC', VentanaMain.GHlpFiles.Value ) ) .OR. ;
            ! ( AllTrim( cAuxTopic ) == SHG_GetField( 'SHG_TOPIC', VentanaMain.GHlpFiles.Value ) )
            SetProperty( 'VentanaMain', 'GHlpFiles', 'Cell', VentanaMain.GHlpFiles.Value, NCOLHLPEDIT, 'D' )
         ENDIF
      ENDIF
   ENDIF
RETURN .T.
#endif

#ifdef QPM_SHG
FUNCTION QPM_EditKeyHLP()
   LOCAL cAux, MemoAux := '', i
   IF VentanaMain.GHlpKeys.Value > 0
      cAux := InputBox( 'Key:', 'Keys For Help', AllTrim( VentanaMain.GHlpKeys.Cell( VentanaMain.GHlpKeys.Value, 1 ) ) )
      IF ! Empty( cAux )
         VentanaMain.GHlpKeys.Cell( VentanaMain.GHlpKeys.Value, 1 ) := cAux
         DoMethod( 'VentanaMain', 'GHlpKeys', 'ColumnsAutoFitH' )
         FOR i := 1 TO VentanaMain.GHlpKeys.ItemCount
            MemoAux := MemoAux + iif( i > 1, CRLF, '' ) + VentanaMain.GHlpKeys.Cell( i, 1 )
         NEXT
         SHG_SetField( 'SHG_KEYST', VentanaMain.GHlpFiles.Value, MemoAux )
      ENDIF
   ENDIF
RETURN .T.
#endif

FUNCTION QPM_EditRES
   LOCAL Editor, FileRC, Alt_RC
   LOCAL EditControlFile, RunParms, cLineCmd, cLineFile
#ifdef QPM_HOTRECOVERY
   LOCAL HotRecoveryControlFile
#endif
   IF Empty( PUB_cProjectFolder ) .OR. ! US_IsDirectory( PUB_cProjectFolder )
      MyMsgStop( DBLQT + "Project Folder" + DBLQT + " is not a valid folder:" + CRLF + PUB_cProjectFolder + CRLF + 'Look at tab ' + DBLQT + PagePRG + DBLQT )
      RETURN .F.
   ENDIF
   IF VentanaMain.GPrgFiles.ItemCount < 1
      MyMsgStop( DBLQT + 'Top File' + DBLQT + ' is not defined!' + CRLF + 'Look at tab ' + DBLQT + PagePRG + DBLQT )
      RETURN .F.
   ENDIF
   IF Empty( Gbl_Text_Editor )
      MyMsgStop( 'Editor is not defined!' + CRLF + ' Look at ' + PUB_MenuGblOptions + ' of Settings menu.' )
      RETURN .F.
   ENDIF
   IF ! File( Editor := ChgPathToReal( AllTrim( Gbl_Text_Editor ) ) )
      MyMsgStop( 'Editor not found: ' + AllTrim( Gbl_Text_Editor ) + CRLF + 'Look at ' + PUB_MenuGblOptions + ' of Settings menu.' )
      RETURN .F.
   ENDIF
   FileRC := US_FileNameOnlyPathAndName( ChgPathToReal( GetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', 1, NCOLPRGFULLNAME ) ) ) + '.RC'
   IF ! File( FileRC )
      Alt_RC := PUB_cProjectFolder + DEF_SLASH + US_FileNameOnlyName( ChgPathToReal( GetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', 1, NCOLPRGFULLNAME ) ) ) + '.RC'
      IF File( Alt_RC )
         FileRC := Alt_RC
      ELSE
         IF ! MyMsgYesNo( 'Main resource file not found' + CRLF + ;
                          'at: ' + DBLQT + FileRC + DBLQT + CRLF + ;
                          'nor at: ' + DBLQT + Alt_RC + DBLQT + CRLF + ;
                          'Do you want to create an empty file?' )
            RETURN .F.
         ENDIF
         QPM_LogText( 'New RC ' + FileRC )
         QPM_MemoWrit( FileRC, 'MAIN ICON     .' + DEF_SLASH + 'RESOURCES' + DEF_SLASH + 'MAIN.ICO' )
         MyMsgInfo( "Main resource file " + DBLQT + FileRC + DBLQT + "was created." )
      ENDIF
   ENDIF
   QPM_LogText( 'Edit RC ' + FileRC )
   IF bSuspendControlEdit
      IF bEditorLongName
         cLineCmd := Editor
         cLineFile := FileRC
      ELSE
         cLineCmd := US_ShortName( Editor )
         cLineFile := US_ShortName( FileRC )
      ENDIF
      VentanaMain.BEditRC.Enabled := .F.
      QPM_Execute( cLineCmd, cLineFile )
      VentanaMain.BEditRC.Enabled := .T.
      QPM_LogText( 'COMMAND ' + cLineCmd + CRLF + "FILE " + cLineFile )
   ELSE
      IF ! Empty( cEditControlFileRC )
         MyMsgStop( 'The file is already open!' )
         RETURN .F.
      ENDIF
      VentanaMain.RichEditPAN.BackColor := DEF_COLORBACKEXTERNALEDIT
      VentanaMain.RichEditPAN.FontColor := DEF_COLORFONTEXTERNALEDIT
      EditControlFile := US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + '_' + PUB_cSecu + 'ECF' + US_DateTimeCen() + '.cnt'
#ifdef QPM_HOTRECOVERY
      HotRecoveryControlFile := US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + '_' + PUB_cSecu + 'SrcHOTRecovery' + US_DateTimeCen() + '.hot'
      US_FileCopy( FileRC, HotRecoveryControlFile )
      SetFDaTi( HotRecoveryControlFile, US_FileDate( FileRC ), US_FileTime( FileRC ) )
      HR_ControlFileRC := HotRecoveryControlFile
#endif
      cEditControlFileRC := EditControlFile
      RunParms := US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + '_' + PUB_cSecu + 'RP' + US_DateTimeCen() + '.cng'
      IF bEditorLongName
         cLineCmd := Editor
         cLineFile := FileRC
      ELSE
         cLineCmd := US_ShortName( Editor )
         cLineFile := US_ShortName( FileRC )
      ENDIF
      QPM_LogText( RunParms )
      QPM_MemoWrit( RunParms, 'Run Parms For ' + FileRC + CRLF + ;
                              "COMMAND " + cLineCmd + " " + cLineFile + CRLF + ;
                              'CONTROL ' + EditControlFile )
      QPM_LogFile( RunParms )
      QPM_MemoWrit( EditControlFile, 'Edit Control File For ' + FileRC )
      QPM_Execute( US_ShortName( PUB_cQPM_Folder ) + DEF_SLASH + 'US_Run.exe', 'QPM' + LISTOLOG + RunParms )
      QPM_LogText( "Done" )
   ENDIF
RETURN .T.

FUNCTION QPM_SetTopPRG
   LOCAL i, vTop, vLine
   i := VentanaMain.GPrgFiles.Value
   IF i == 1 .OR. i == 0
      RETURN .T.
   ENDIF
   vTop := VentanaMain.GPrgFiles.item( 1 )
   vLine := VentanaMain.GPrgFiles.item( VentanaMain.GPrgFiles.Value )
   VentanaMain.GPrgFiles.item( VentanaMain.GPrgFiles.Value ) := vTop
   VentanaMain.GPrgFiles.item( 1 ) := vLine
   VentanaMain.GPrgFiles.Value := 1
   VentanaMain.GPrgFiles.SetFocus
   IF Prj_Warn_TopFile
      IF MyMsgYesNo( DBLQT + ChgPathToReal( vLine[NCOLPRGFULLNAME] ) + DBLQT + CRLF + "is the new " + DBLQT + "Top File" + DBLQT + "." + CRLF + ;
                     'Omit this message from now on?' )
         Prj_Warn_TopFile := .F.
         MyMsgInfo( 'Use ' + DBLQT + PUB_MenuResetWarnings + DBLQT + ' option of Settings menu to enable the previous message.' )
      ENDIF
   ENDIF

   CambioTitulo()
RETURN .T.

FUNCTION QPM_GetFilesPRG()
   LOCAL RetVal := {}, BaseFolder, cAux
   IF Empty( PUB_cProjectFolder ) .OR. ! US_IsDirectory( PUB_cProjectFolder )
      MyMsgStop( DBLQT + "Project Folder" + DBLQT + " is not a valid folder:" + CRLF + PUB_cProjectFolder + CRLF + 'Look at tab ' + DBLQT + PagePRG + DBLQT )
      RETURN ( {} )
   ENDIF
   IF Prj_Radio_OutputType == DEF_RG_IMPORT .AND. GetProperty( 'VentanaMain', 'GPrgFiles', 'itemcount' ) > 0
      MyMsgStop( 'The process to make an Interface Library allows only one source.' )
      RETURN ( {} )
   ENDIF
   IF GetProperty( 'VentanaMain', 'GPrgFiles', 'Value' ) == 0
      BaseFolder := PUB_cProjectFolder
   ELSE
      BaseFolder := US_FileNameOnlyPath( ChgPathToReal( GetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', GetProperty( 'VentanaMain', 'GPrgFiles', 'Value' ), NCOLPRGFULLNAME ) ) )
   ENDIF
   IF Right( Basefolder, 1) != DEF_SLASH
      BaseFolder := BaseFolder + DEF_SLASH
   ENDIF
   IF Prj_Radio_OutputType == DEF_RG_IMPORT
      cAux := GetFile( { {'DLL file','*.DLL'} }, 'Select Input Files', BaseFolder, .F., .T. )
      IF ! Empty( cAux )
         AAdd( RetVal, cAux )
      ENDIF
   ELSE
      RetVal := US_GetFile( { {'Source files (prg,c,cpp)','*.prg;*.c;*.cpp'}, {'Only PRG files','*.prg'}, {'Only C files','*.C'}, {'Only C++ files','*.CPP'}, {'Only C and C++ files','*.C;*.CPP'} }, 'Select Source or Input Files', BaseFolder, .T., .T. )
   ENDIF
RETURN RetVal

FUNCTION QPM_GetFilesHEA()
   LOCAL BaseFolder
   IF Empty( PUB_cProjectFolder ) .OR. ! US_IsDirectory( PUB_cProjectFolder )
      MyMsgStop( DBLQT + "Project Folder" + DBLQT + " is not a valid folder:" + CRLF + PUB_cProjectFolder + CRLF + 'Look at tab ' + DBLQT + PagePRG + DBLQT )
      RETURN ( {} )
   ENDIF
   IF GetProperty( 'VentanaMain', 'GHeaFiles', 'Value' ) == 0
      BaseFolder := PUB_cProjectFolder
   ELSE
      BaseFolder := US_FileNameOnlyPath( ChgPathToReal( GetProperty( 'VentanaMain', 'GHeaFiles', 'Cell', GetProperty( 'VentanaMain', 'GHeaFiles', 'Value' ), NCOLHEAFULLNAME ) ) )
   ENDIF
   IF Right( Basefolder, 1 ) != DEF_SLASH
      BaseFolder := BaseFolder + DEF_SLASH
   ENDIF
RETURN US_GetFile( { {'Headers files (*.h and *.ch)','*.h;*.ch'} }, 'Select Headers Files', BaseFolder, .T., .T. )

FUNCTION QPM_GetFilesPAN()
   LOCAL BaseFolder
   IF Empty( PUB_cProjectFolder ) .OR. ! US_IsDirectory( PUB_cProjectFolder )
      MyMsgStop( DBLQT + "Project Folder" + DBLQT + " is not a valid folder:" + CRLF + PUB_cProjectFolder + CRLF + 'Look at tab ' + DBLQT + PagePRG + DBLQT )
      RETURN ( {} )
   ENDIF
   IF GetProperty( 'VentanaMain', 'GPanFiles', 'Value' ) == 0
      BaseFolder := PUB_cProjectFolder
   ELSE
      BaseFolder := US_FileNameOnlyPath( ChgPathToReal( GetProperty( 'VentanaMain', 'GPanFiles', 'Cell', GetProperty( 'VentanaMain', 'GPanFiles', 'Value' ), NCOLPANFULLNAME ) ) )
   ENDIF
   IF Right( Basefolder, 1 ) != DEF_SLASH
      BaseFolder := BaseFolder + DEF_SLASH
   ENDIF
RETURN US_GetFile( { {'Forms files (*.FMG)','*.fmg'} }, 'Select Forms Files', BaseFolder, .T., .T. )

FUNCTION QPM_GetFilesDBF()
   LOCAL BaseFolder
   IF Empty( PUB_cProjectFolder ) .OR. ! US_IsDirectory( PUB_cProjectFolder )
      MyMsgStop( DBLQT + "Project Folder" + DBLQT + " is not a valid folder:" + CRLF + PUB_cProjectFolder + CRLF + 'Look at tab ' + DBLQT + PagePRG + DBLQT )
      RETURN ( {} )
   ENDIF
   IF GetProperty( 'VentanaMain', 'GDbfFiles', 'Value' ) == 0
      BaseFolder := PUB_cProjectFolder
   ELSE
      BaseFolder := US_FileNameOnlyPath( ChgPathToReal( GetProperty( 'VentanaMain', 'GDbfFiles', 'Cell', GetProperty( 'VentanaMain', 'GDbfFiles', 'Value' ), NCOLDBFFULLNAME ) ) )
   ENDIF
   IF Right( Basefolder, 1 ) != DEF_SLASH
      BaseFolder := BaseFolder + DEF_SLASH
   ENDIF
RETURN US_GetFile( { {'DBF files (*.DBF)', '*.dbf'} }, 'Select DBF files', BaseFolder, .T., .T. )

FUNCTION QPM_GetExcludeFilesLIB()
   LOCAL RetVal := {}, aLibsE, aLibsI, i, vAux := {}, cFlavor := GetSuffix()
   IF Empty( PUB_cProjectFolder ) .OR. ! US_IsDirectory( PUB_cProjectFolder )
      MyMsgStop( DBLQT + "Project Folder" + DBLQT + " is not a valid folder:" + CRLF + PUB_cProjectFolder + CRLF + 'Look at tab ' + DBLQT + PagePRG + DBLQT )
      RETURN ( RetVal )
   ENDIF
   DescargoIncludeLibs( cFlavor )   // vLibIncludeFiles, with path
   aLibsI := &('IncludeLibs'+cFlavor)
   DescargoExcludeLibs( cFlavor )   // vLibExcludeFiles, no path
   aLibsE := &('ExcludeLibs'+cFlavor)
   DescargoDefaultLibs( cFlavor )   // vLibsToLink, no path
   FOR i := 1 TO Len( vLibsToLink )
      IF AScan( aLibsE, { |x| US_Upper( x ) == US_Upper( vLibsToLink[i] ) } ) == 0
         AAdd( vAux, vLibsToLink[i] )
      ENDIF
   NEXT i
   FOR i := 1 TO Len( aLibsI )
      IF AScan( aLibsE, { |x| US_Upper( x ) == US_Upper( aLibsI[i] ) } ) == 0
         AAdd( vAux, US_FileNameOnlyNameAndExt( US_Word( aLibsI[i], 2 ) ) )
      ENDIF
   NEXT i
   ASort( vAux, NIL, NIL, { |x, y| US_Upper(x) < US_Upper( y ) } )

   DEFINE WINDOW GetExcludeLibFiles ;
      AT 0,0 ;
      WIDTH 310 HEIGHT 390 ;
      TITLE 'Select library for Exclude' ;
      MODAL FONT 'Arial' SIZE 9

      DEFINE LISTBOX List_1
         ITEMS vAux
         ROW 10
         COL 10
         WIDTH 280
         HEIGHT 300
         MULTISELECT .T.
      END LISTBOX

      DEFINE BUTTONEX OK
         ROW 320
         COL 45
         CAPTION 'OK'
         ONCLICK ( RetVal := QPM_GetExcludeFilesOkLIB( vAux, GetExcludeLibFiles.List_1.Value ), DoMethod( 'GetExcludeLibFiles', 'Release' ) )
      END BUTTONEX

      DEFINE BUTTONEX CANCEL
         ROW 320
         COL 160
         CAPTION 'Cancel'
         ONCLICK ( RetVal := {}, DoMethod( 'GetExcludeLibFiles', 'Release' ) )
      END BUTTONEX
   END WINDOW

   CENTER WINDOW GetExcludeLibFiles
   ACTIVATE WINDOW GetExcludeLibFiles
RETURN ( RetVal )

FUNCTION QPM_GetExcludeFilesOkLIB( aFiles, aSelected )
   LOCAL aNew := {}, i
   FOR i := 1 TO Len( aSelected )
      AAdd( aNew, aFiles[ aSelected[ i ] ] )
   NEXT i
RETURN aNew

FUNCTION QPM_GetLibs()
   LOCAL RetVal := {}, cFolderAux
   IF ! Empty( &( 'cLastLibFolder'+GetSuffix() ) ) .AND. US_IsDirectory( &( 'cLastLibFolder'+GetSuffix() ) )
      cFolderAux := &( 'cLastLibFolder'+GetSuffix() )
   ELSEIF Empty( PUB_cProjectFolder ) .OR. ! US_IsDirectory( PUB_cProjectFolder )
      MyMsgStop( DBLQT + "Project Folder" + DBLQT + " is not a valid folder:" + CRLF + PUB_cProjectFolder + CRLF + 'Look at tab ' + DBLQT + PagePRG + DBLQT )
      RETURN ""
   ELSE
      cFolderAux := PUB_cProjectFolder
   ENDIF
   IF Prj_Radio_Cpp == DEF_RG_BORLAND .OR. Prj_Radio_Cpp == DEF_RG_PELLES
      RetVal := GetFile( { {'Libs, objects and resources to include on concatenation (*.lib,*.obj,*.res)','*.lib;*obj;*res'}, {'Libs to include on concatenation (*.lib)','*.lib'}, {'Objects to include on concatenation (*.obj)','*.obj'}, {'Resources to include on concatenation (*.res)','*.res'} }, 'Libs, objects and resources to include on concatenation', cFolderAux, .T., .T. )
      IF Len( RetVal ) > 0
         &( 'cLastLibFolder'+GetSuffix() ) := US_FileNameOnlyPath( RetVal[ Len( RetVal ) ] )
      ENDIF
   ELSEIF Prj_Radio_Cpp == DEF_RG_MINGW
      RetVal := GetFile( { {'Libs and objects to include on concatenation (lib*.a,*.o)','lib*.a;*.o'}, {'Libs to include on concatenation (lib*.a)','lib*.a'}, {'Objects to include on concatenation (*.o)','*.o'} }, 'Libs and objects to include on concatenation', cFolderAux, .T., .T. )
      IF Len( RetVal ) > 0
         &( 'cLastLibFolder'+GetSuffix() ) := US_FileNameOnlyPath( RetVal[ Len( RetVal ) ] )
      ENDIF
   ENDIF
RETURN ( RetVal )

FUNCTION QPM_OpenProject( cParmProjectFileName )
   LOCAL Temp_SHG_Database
   LOCAL Open_TmpCreateFile
   LOCAL vProjectFileNameAux
   LOCAL Open_FromFileType
   LOCAL cFile
   LOCAL Open_ProjectExt := '*.qac;*.qpm'
   LOCAL Open_FilesExt   := '*.prg;*.c;*.cpp;*.dll'

   Prj_IsNew := .F.

   // Save previous project
#ifdef QPM_SHG
   IF ! QPM_WAIT( 'SHG_CheckSave()', 'Checking for save ...' )
      RETURN .F.
   ENDIF
   IF SHG_BaseOk
      IF US_FileSize( US_FileNameOnlyPathAndName( SHG_Database ) + '.dbt' ) > SHG_DbSize
         QPM_Wait( 'SHG_PackDatabase()' )
      ENDIF
   ENDIF
#endif
   QPM_Wait( 'QPM_SaveProject( .T. )', 'Checking for save ...' )

   // Open or create
   IF Empty( cParmProjectFileName )
      CloseDbfAutoView()
      // MultiSelect parameter is set to .T. because, sometimes, the function returned the filename even when the file didn't exists
      vProjectFileNameAux := US_GetFile( { { 'Open/Create Project (' + Open_ProjectExt + ';' + Open_FilesExt + ')', Open_ProjectExt + ';' + Open_FilesExt }, { 'Open/Create Project Files (' + Open_ProjectExt + ')', Open_ProjectExt }, { 'Create Project For File (' + Open_FilesExt + ')', Open_FilesExt } }, 'Open or Create Project', cLastProjectFolder, .T., .T. )
      cProjectFileName := iif( Len( vProjectFileNameAux ) == 0, '', vProjectFileNameAux[1] )
      IF Empty( cProjectFileName )
         QPM_Wait( "RichEditDisplay( 'DBF', .T., NIL, .F. )", 'DBF reloading ...' )
         RETURN .F.
      ENDIF
      // Avoid projects with spaces in their names
      IF " " $ ( cFile := US_FileNameOnlyNameAndExt( cProjectFileName ) )
         MyMsgStop( "QPM can't handle filenames with spaces." + CRLF + DBLQT + cFile + DBLQT + ' will be renamed as: ' + DBLQT + ( cFile := StrTran( cFile, " ", "_" ) ) + DBLQT )
         cProjectFileName := US_FileNameOnlyPath( cProjectFileName ) + DEF_SLASH + cFile
      ENDIF
      // Avoid projects with & in their names
      IF "&" $ ( cFile := US_FileNameOnlyNameAndExt( cProjectFileName ) )
         MyMsgStop( "QPM can't handle filenames with ampersands (&)." + CRLF + DBLQT + cFile + DBLQT + ' will be renamed as: ' + DBLQT + ( cFile := StrTran( cFile, "&", "_" ) ) + DBLQT )
         cProjectFileName := US_FileNameOnlyPath( cProjectFileName ) + DEF_SLASH + cFile
      ENDIF
      // Rename .qac to .qpm
      IF Upper( US_FileNameOnlyExt( cProjectFileName ) ) == 'QAC'
         frename( cProjectFileName, US_FileNameOnlyPathAndName( cProjectFileName ) + '.qpm' )
         cProjectFileName := US_FileNameOnlyPathAndName( cProjectFileName ) + '.qpm'
      ENDIF
      // Process non project files
      IF Empty( US_FileNameOnlyExt( cProjectFileName ) )
         Open_FromFileType := 'QPM'
      ELSE
         Open_FromFileType := Upper( US_FileNameOnlyExt( cProjectFileName ) )
      ENDIF
      // Force .qpm extension
      cProjectFileName := US_FileNameOnlyPathAndName( cProjectFileName ) + '.qpm'
      // Use current folder if none is already set
      IF Empty( US_FileNameOnlyPath( cProjectFileName ) )
         cProjectFileName := GetCurrentFolder() + DEF_SLASH + cProjectFileName
      ENDIF
      // Create new project
      IF ! File( cProjectFileName )
         IF ! MyMsgYesNo( 'Create new project ' + DBLQT + cProjectFileName + DBLQT + '?' )
            QPM_Wait( "RichEditDisplay( 'DBF', .T., NIL, .F. )", 'DBF reloading ...' )
            RETURN .F.
         ENDIF
         Prj_IsNew := .T.
#ifdef QPM_SHG
         Temp_SHG_Database := SHG_StrTran( SHG_GetDatabaseName( US_FileNameOnlyPathAndName( cProjectFileName ) ) + '_SHG.dbf' )
         IF MyMsgYesNo( 'Create Simple Help Generator (SHG) database ' + DBLQT + Temp_SHG_Database + DBLQT + "?" )
            SHG_CreateDatabase( Temp_SHG_Database )
         ELSE
            Temp_SHG_Database := '*NONE*'
         ENDIF
#else
         Temp_SHG_Database := '*NONE*'
#endif
         Open_TmpCreateFile := 'VERSION ' + QPM_VERSION_NUMBER + ' ' + CRLF
         Open_TmpCreateFile += 'SHGDATABASE ' + Temp_SHG_Database + ' ' + CRLF
         IF Open_FromFileType == 'DLL'
            Open_TmpCreateFile += Open_TmpCreateFile + 'OUTPUTTYPE DLLLIB ' + CRLF
         ENDIF
         IF Open_FromFileType == 'PRG' .OR. Open_FromFileType == 'C' .OR. Open_FromFileType == 'CPP'
            Open_TmpCreateFile += Open_TmpCreateFile + 'SOURCE ' + US_FileNameOnlyPathAndName( cProjectFileName ) + '.' + lower( Open_FromFileType ) + ' ' + CRLF
            IF ! File( US_FileNameOnlyPathAndName( cProjectFileName ) + '.' + lower( Open_FromFileType ) )
               QPM_CreateNewFile( Open_FromFileType, US_FileNameOnlyPathAndName( cProjectFileName ) + '.' + lower( Open_FromFileType ) )
            ENDIF
         ENDIF
         IF QPM_MemoWrit( cProjectFileName, Open_TmpCreateFile )
            MyMsgInfo( 'Project successfully created: ' + DBLQT + cProjectFileName + DBLQT )
         ELSE
            MyMsgStop( 'The project file ' + DBLQT + cProjectFileName + DBLQT + "could not be created!" )
         ENDIF
      ENDIF
   ELSE
      cProjectFileName := cParmProjectFileName
      IF Empty( US_FileNameOnlyExt( cProjectFileName ) )
         cProjectFileName += ".qpm"
      ENDIF
      IF Empty( US_FileNameOnlyPath( cProjectFileName ) )
         cProjectFileName := GetCurrentFolder() + DEF_SLASH + cProjectFileName
      ENDIF
      IF ! File( cProjectFileName )
         MyMsgStop( 'File not found: ' + DBLQT + AllTrim( cProjectFileName ) + DBLQT )
         RETURN .F.
      ENDIF
   ENDIF
RETURN QPM_Wait( 'QPM_OpenProject2()', 'Opening ...' )

FUNCTION QPM_OpenProject2()
   LOCAL cForceRecomp
   LOCAL LOC_nOpenError
   LOCAL i
   LOCAL cFile
   LOCAL cMemoProjectFile
   LOCAL cMemoProjectFileAux := ""
   LOCAL cCfgVrsn := '010001'
   LOCAL cCfgVrsnEdtd := '01.00.01'
   LOCAL ConfigVersion
   LOCAL LOC_cLine

   DoMethod( 'VentanaMain', 'GPrgFiles', 'DisableUpdate' )
   DoMethod( 'VentanaMain', 'GPanFiles', 'DisableUpdate' )
   DoMethod( 'VentanaMain', 'GDbfFiles', 'DisableUpdate' )
   DoMethod( 'VentanaMain', 'GHeaFiles', 'DisableUpdate' )
   DoMethod( 'VentanaMain', 'GIncFiles', 'DisableUpdate' )
   DoMethod( 'VentanaMain', 'GExcFiles', 'DisableUpdate' )
#ifdef QPM_SHG
   DoMethod( 'VentanaMain', 'GHlpFiles', 'DisableUpdate' )
#endif

   IF ! Empty( cProjectFileName )
      QPM_LogText( 'QPM_OpenProject ' + cProjectFileName )

      cLastProjectFolder                        := US_FileNameOnlyPath( cProjectFileName )
      PUB_cThisFolder                           := cLastProjectFolder
      PUB_cProjectFile                          := US_FileNameOnlyPathAndName( cProjectFileName ) + '.qpm'
      IF PUB_bLite
         VentanaLite.Title                      := 'QPM (' + QPM_VERSION_DISPLAY_LONG + ') [ ' + AllTrim ( cProjectFileName ) + ' ]'
      ELSE
         VentanaMain.Title                      := 'QPM (QAC based Project Manager) - Project Manager For MiniGui (' + QPM_VERSION_DISPLAY_LONG + ') [ ' + AllTrim ( cProjectFileName ) + ' ]'
      ENDIF
      VentanaMain.TProjectFolder.Value          := cLastProjectFolder
      VentanaMain.TRunProjectFolder.Value       := ''
      Prj_Warn_BccObject                        := .T.
      Prj_Warn_BccObject_Cont                   := .T.
      Prj_Warn_Cpp                              := .T.
      Prj_Warn_DBF_Search                       := .T.
      Prj_Warn_DBF_Search_Cont                  := .T.
      Prj_Warn_GT_Order                         := .T.
      Prj_Warn_GT_Order_Cont                    := .T.
      Prj_Warn_InfoSaved                        := .T.
      Prj_Warn_NullRDD                          := .T.
      Prj_Warn_PPO_Browse                       := .T.
      Prj_Warn_SlowSearch                       := .T.
      Prj_Warn_SlowSearch_Cont                  := .T.
      Prj_Warn_TopFile                          := .T.
      Prj_Check_PlaceRCFirst                    := .F.
      Prj_Check_IgnoreMainRC                    := .F.
      Prj_Check_IgnoreLibRCs                    := .F.
// Ini: Project Options default values
      Prj_Radio_Harbour                         := DEF_RG_HARBOUR
      Prj_Check_HarbourIs31                     := .T.
      Prj_Check_64bits                          := .F.
      Prj_Radio_Cpp                             := DEF_RG_MINGW
      Prj_Radio_MiniGui                         := DEF_RG_OOHG3
      Prj_Check_Console                         := .F.
      Prj_Check_MT                              := .F.
      Prj_Radio_OutputType                      := DEF_RG_EXE
      Prj_Radio_OutputCopyMove                  := DEF_RG_NONE
      Prj_Text_OutputCopyMoveFolder             := ''
      Prj_Radio_OutputRename                    := DEF_RG_NONE
      Prj_Text_OutputRenameNewName              := ''
      Prj_Check_OutputSuffix                    := .F.
      Prj_Check_OutputPrefix                    := .T.
      Prj_Check_StaticBuild                     := .T.
      Prj_Check_Upx                             := .F.
      Prj_Radio_FormTool                        := DEF_RG_EDITOR
      Prj_Radio_DbfTool                         := DEF_RG_DBFTOOL
// End: Project Options default values
      bGlobalSearch                             := .F.
      bLastGlobalSearchFun                      := .F.
      bLastGlobalSearchDbf                      := .F.
      bLastGlobalSearchCas                      := .F.
      VentanaMain.LGlobal.visible               := .F.
      bPpoDisplayado                            := .F.
      SHG_Database                              := ''
      SHG_DbSize                                := 0
      SHG_LastFolderImg                         := ''
      SHG_CheckTypeOutput                       := .F.
      SHG_HtmlFolder                            := ''
      SHG_WWW                                   := ''
      SHG_BaseOK                                := .F.
      cPrj_VersionAnt                           := '00000000'
      VentanaMain.LVerVerNum.VALUE              := Replicate( '0', DEF_LEN_VER_VERSION )
      VentanaMain.LVerRelNum.VALUE              := Replicate( '0', DEF_LEN_VER_RELEASE )
      VentanaMain.LVerBuiNum.VALUE              := Replicate( '0', DEF_LEN_VER_BUILD )
      VentanaMain.OverrideCompile.Enabled       := .T.
      VentanaMain.OverrideLink.Enabled          := .T.
      VentanaMain.OverrideCompile.Value         := ''
      VentanaMain.OverrideLink.VALUE            := ''
      Prj_ExtraRunCmdFINAL                      := ''
      Prj_ExtraRunProjQPM                       := ''
      Prj_ExtraRunCmdEXE                        := ''
      Prj_ExtraRunCmdFREE                       := ''
      Prj_ExtraRunCmdQPMParm                    := ''
      Prj_ExtraRunCmdEXEParm                    := ''
      Prj_ExtraRunCmdFREEParm                   := ''
      Prj_ExtraRunType                          := 'NONE'
      Prj_ExtraRunQPMRadio                      := 'BUILD'
      Prj_ExtraRunQPMLite                       := .T.
      Prj_ExtraRunQPMForceFull                  := .F.
      Prj_ExtraRunQPMRun                        := .F.
      Prj_ExtraRunQPMButtonRun                  := .F.
      Prj_ExtraRunQPMClear                      := .F.
      Prj_ExtraRunQPMLog                        := .F.
      Prj_ExtraRunQPMLogOnlyError               := .F.
      Prj_ExtraRunQPMAutoEXIT                   := .T.
      Prj_ExtraRunExeWait                       := .T.
      Prj_ExtraRunExePause                      := .T.
      Prj_ExtraRunFreeWait                      := .T.
      Prj_ExtraRunFreePause                     := .T.
      TotCaption( 'PRG', 0 )
      TotCaption( 'HEA', 0 )
      TotCaption( 'PAN', 0 )
      TotCaption( 'DBF', 0 )
      TotCaption( 'LIB', 0 )
      TotCaption( 'HEA', 0 )
#ifdef QPM_SHG
      TotCaption( 'HLP', 0 )
#endif
      VentanaMain.GPrgFiles.DeleteAllItems
      VentanaMain.GHeaFiles.DeleteAllItems
      VentanaMain.GPanFiles.DeleteAllItems
      VentanaMain.GDbfFiles.DeleteAllItems
#ifdef QPM_SHG
      VentanaMain.GHlpFiles.DeleteAllItems
#endif
      VentanaMain.RichEditPrg.VALUE             := ''
      VentanaMain.RichEditHea.VALUE             := ''
      VentanaMain.RichEditPan.VALUE             := ''
      VentanaMain.RichEditDbf.VALUE             := ''
      VentanaMain.RichEditLib.VALUE             := ''
#ifdef QPM_SHG
      VentanaMain.RichEditHlp.VALUE             := ''
      oHlpRichEdit:lChanged                     := .F.
#endif
      VentanaMain.RichEditSysout.Value          := ''
      VentanaMain.RichEditOut.VALUE             := ''
      VentanaMain.Check_Reimp.VALUE             := .F.
      VentanaMain.TReimportLib.VALUE            := ''
      VentanaMain.Check_NumberOnPrg.Enabled     := .T.
      VentanaMain.Check_GuionA.VALUE            := .F.
      VentanaMain.bReLoadPpo.Enabled            := .T.
      VentanaMain.bReLoadPrg.Enabled            := .T.
      bDbfAutoView                              := .T.
      FOR i := 1 TO Len( vSuffix )
      &( 'IncludeLibs'+vSuffix[i][1] )          := {}
      &( 'ExcludeLibs'+vSuffix[i][1] )          := {}
      &( 'vExtraFoldersForLibs'+vSuffix[i][1] ) := {}
      NEXT
      vExtraFoldersForSearchC                   := {}
      vExtraFoldersForSearchHB                  := {}
      vSinLoadWindow                            := {}
      vSinInclude                               := {}
      vXRefPrgHea                               := {}
      vXRefPrgFmg                               := {}
      PUB_bDebugActive                          := .F.
      PUB_bDebugActiveAnt                       := .F.
      VentanaMain.Debug.Checked                 := .T.
      PUB_cConvert                              := ''
      bRunParm                                  := .F.
      Gbl_cRunParm                              := ''
      bBuildRun                                 := .F.
      bBuildRunBack                             := .F.
      Gbl_HR_cLastExternalFileName              := ''

      PUB_MI_bExeAssociation                    := .F.
      PUB_MI_cExeAssociation                    := ''
      PUB_MI_nExeAssociationIcon                := 1
      PUB_MI_bExeBackupOption                   := .F.
      PUB_MI_bNewFile                           := .F.
      PUB_MI_nNewFileSuggested                  := 1
      PUB_MI_cNewFileLeyend                     := ''
      PUB_MI_nNewFileEmpty                      := 1
      PUB_MI_cNewFileUserFile                   := ''
      PUB_MI_nDestinationPath                   := 1
      PUB_MI_cDestinationPath                   := ''
      PUB_MI_nLeyendSuggested                   := 1
      PUB_MI_cLeyendUserText                    := ''
      PUB_MI_bDesktopShortCut                   := .T.
      PUB_MI_nDesktopShortCut                   := 1
      PUB_MI_bStartMenuShortCut                 := .T.
      PUB_MI_nStartMenuShortCut                 := 1
      PUB_MI_bLaunchApplication                 := .T.
      PUB_MI_nLaunchApplication                 := 1
      PUB_MI_bLaunchBackupOption                := .F.
      PUB_MI_bReboot                            := .F.
      PUB_MI_cDefaultLanguage                   := 'EN'
      PUB_MI_nInstallerName                     := 1
      PUB_MI_cInstallerName                     := ''
      PUB_MI_cImage                             := ''
      PUB_MI_bSelectAllPRG                      := .F.
      PUB_MI_bSelectAllHEA                      := .F.
      PUB_MI_bSelectAllPAN                      := .F.
      PUB_MI_bSelectAllDBF                      := .F.
      PUB_MI_bSelectAllLIB                      := .F.

      PUB_bAutoInc                              := .T.
      VentanaMain.AutoInc.Checked               := .T.
      PUB_bHotKeys                              := .T.
      VentanaMain.HotKeys.Checked               := .T.
      QPM_SetResumen()

      // Lock project's file
      QPM_ProjectFileUnLock()
      IF ! ( ( LOC_nOpenError := QPM_ProjectFileLock( cProjectFileName ) ) == 0 )
         IF LOC_nOpenError == 5 .OR. LOC_nOpenError == 32
            MyMsgStop( "Project " + DBLQT + cProjectFileName + DBLQT + " is already open!" )
         ELSE
            MyMsgStop( "Project " + DBLQT + cProjectFileName + DBLQT + "can't be opened!" + CRLF + ;
                       "Error code was #" + US_VarToStr( LOC_nOpenError ) + "." )
         ENDIF
         PUB_cProjectFile := ''
         PUB_cProjectFolder := ''
         RETURN .F.
      ENDIF

      // Get project's version
      cMemoProjectFile := MemoRead( cProjectFileName )
      IF MLCount ( cMemoProjectFile, 254 ) > 0
         LOC_cLine := AllTrim ( MEMOLINE( cMemoProjectFile, 254, 1 ) )
         IF US_Word( LOC_cLine, 1 ) == 'VERSION'
            cCfgVrsn := US_Word( LOC_cLine, 2 ) + US_Word( LOC_cLine, 3 ) + US_Word( LOC_cLine, 4 )
            cCfgVrsnEdtd := US_Word( LOC_cLine, 2 ) + "." + US_Word( LOC_cLine, 3 ) + "." + US_Word( LOC_cLine, 4 )
         ENDIF
      ELSE
         Prj_IsNew := .T.
      ENDIF
      configversion := Val( cCfgVrsn )
      IF configVersion > Val( QPM_VERSION_NUMBER_SHORT ) .AND. ! PUB_bIgnoreVersionProject
         IF ! MyMsgYesNo( "The project's version (" + cCfgVrsnEdtd + ") is newer than QPM's version (" + QPM_VERSION_DISPLAY_SHORT + ').' + CRLF + ;
                          'If you go on some information may be discarded.' + CRLF + 'Continue?' )
            PUB_cProjectFile := ''
            PUB_cProjectFolder := ''
            RETURN .F.
         ENDIF
      ENDIF

      // Update older versions
      PRIVATE PRI_COMPATIBILITY_THISFOLDER         := PUB_cThisFolder
      PRIVATE PRI_COMPATIBILITY_CONFIGVERSION      := ConfigVersion
      PRIVATE PRI_COMPATIBILITY_MEMOPROJECTFILE    := cMemoProjectFile
      PRIVATE PRI_COMPATIBILITY_MEMOPROJECTFILEAUX := cMemoProjectFileAux
      PRIVATE PRI_COMPATIBILITY_PROJECTFOLDER      := PUB_cProjectFolder
      PRIVATE PRI_COMPATIBILITY_PROJECTFOLDERIDENT := cProjectFolderIdent
      #include "QPM_CompatibilityOpenProject.CH"
      PUB_cThisFolder                              := PRI_COMPATIBILITY_THISFOLDER
//    ConfigVersion                                := PRI_COMPATIBILITY_CONFIGVERSION
      cMemoProjectFile                             := PRI_COMPATIBILITY_MEMOPROJECTFILE
//    cMemoProjectFileAux                          := PRI_COMPATIBILITY_MEMOPROJECTFILEAUX
      PUB_cProjectFolder                           := PRI_COMPATIBILITY_PROJECTFOLDER
      cProjectFolderIdent                          := PRI_COMPATIBILITY_PROJECTFOLDERIDENT
      RELEASE PRI_COMPATIBILITY_THISFOLDER
      RELEASE PRI_COMPATIBILITY_CONFIGVERSION
      RELEASE PRI_COMPATIBILITY_MEMOPROJECTFILE
      RELEASE PRI_COMPATIBILITY_MEMOPROJECTFILEAUX
      RELEASE PRI_COMPATIBILITY_PROJECTFOLDER
      RELEASE PRI_COMPATIBILITY_PROJECTFOLDERIDENT

// TODO: format from here

      // Process project's file
      FOR i := 1 TO MLCount ( cMemoProjectFile, 254 )
         LOC_cLine := AllTrim ( MEMOLINE( cMemoProjectFile, 254, i ) )
         IF US_Upper( US_Word( LOC_cLine, 1 ) ) == 'PROJECTFOLDER'
            VentanaMain.TProjectFolder.Value := US_StrTran( US_WordSubStr( LOC_cLine, 2 ), '<ThisFolder>', PUB_cThisFolder )
         ELSEIF  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'PRJ_VERSION'
            SetProperty( 'VentanaMain', 'LVerVerNum', 'value', PadL( US_Word( LOC_cLine, 2 ), DEF_LEN_VER_VERSION, '0' ) )
            SetProperty( 'VentanaMain', 'LVerRelNum', 'value', PadL( US_Word( LOC_cLine, 3 ), DEF_LEN_VER_RELEASE, '0' ) )
            SetProperty( 'VentanaMain', 'LVerBuiNum', 'value', PadL( US_Word( LOC_cLine, 4 ), DEF_LEN_VER_BUILD, '0' ) )
            cPrj_VersionAnt := GetPrj_Version()
         ELSEIF  At( 'LASTLIBFOLDER', US_Upper( LOC_cLine ) ) == 1
            IF US_IsVar( 'cLastLibFolder'+SubStr( US_Upper( US_Word( LOC_cLine, 1 ) ), 14 ) )
              &( 'cLastLibFolder'+SubStr( US_Upper( US_Word( LOC_cLine, 1 ) ), 14 ) ) := US_WordSubStr( LOC_cLine, 2 )
            ELSEIF US_IsVar( 'cLastLibFolder'+SubStr( US_Upper( US_Word( LOC_cLine, 1 ) ), 14 )+Define32bits )
              &( 'cLastLibFolder'+SubStr( US_Upper( US_Word( LOC_cLine, 1 ) ), 14 )+Define32bits ) := US_WordSubStr( LOC_cLine, 2 )
            ENDIF
         ELSEIF  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'RUNFOLDER'
                 VentanaMain.TRunProjectFolder.Value := ChgPathToReal( US_WordSubStr( LOC_cLine, 2 ) )
         ELSEIF  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'RUNPARAM'
                 Gbl_cRunParm := US_WordSubStr( LOC_cLine, 2 )
         ELSEIF  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'OVERRIDECOMPILEPARM'
                 SetProperty( 'VentanaMain', 'OverrideCompile', 'Value', US_WordSubStr( LOC_cLine, 2 ) )
         ELSEIF  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'OVERRIDELINKPARM'
                 SetProperty( 'VentanaMain', 'OverrideLink', 'Value', US_WordSubStr( LOC_cLine, 2 ) )
         ELSEIF  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'CHECKHARBOUR'
                 Prj_Radio_Harbour := iif( US_Word( LOC_cLine, 2 ) == DefineXHarbour, DEF_RG_XHARBOUR, DEF_RG_HARBOUR )
         ELSEIF  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'CHECKHARBOURIS31'
                 Prj_Check_HarbourIs31 := iif( US_Word( LOC_cLine, 2 ) == 'YES', .T., .F. )
         ELSEIF  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'CHECKPLACERCFIRST'
                 Prj_Check_PlaceRCFirst := iif( US_Word( LOC_cLine, 2 ) == 'YES', .T., .F. )
                 VentanaMain.Check_Place.Value := Prj_Check_PlaceRCFirst
         ELSEIF  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'CHECKNOMAINRC'
                 Prj_Check_IgnoreMainRC := iif( US_Word( LOC_cLine, 2 ) == 'YES', .T., .F. )
                 VentanaMain.Check_NoMainRC.Value := Prj_Check_IgnoreMainRC
         ELSEIF  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'CHECKNOLIBRCS'
                 Prj_Check_IgnoreLibRCs := iif( US_Word( LOC_cLine, 2 ) == 'YES', .T., .F. )
                 VentanaMain.Check_NoLibRCs.Value := Prj_Check_IgnoreLibRCs
         ELSEIF  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'CHECK64BITS'
                 Prj_Check_64bits := iif( US_Word( LOC_cLine, 2 ) == 'YES', .T., .F. )
         ELSEIF  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'AUTOINC'
                 PUB_bAutoInc := iif( US_Word( LOC_cLine, 2 ) == 'NO', .F., .T. )
         ELSEIF  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'HOTKEYS'
                 PUB_bHotKeys := iif( US_Word( LOC_cLine, 2 ) == 'NO', .F., .T. )
         ELSEIF  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'CHECKCPP'
                 DO CASE
                 CASE US_Word( LOC_cLine, 2 ) == DefineBorland
                    Prj_Radio_Cpp := DEF_RG_BORLAND
                 CASE US_Word( LOC_cLine, 2 ) == DefineMinGW
                    Prj_Radio_Cpp := DEF_RG_MINGW
                 CASE US_Word( LOC_cLine, 2 ) == DefinePelles
                    Prj_Radio_Cpp := DEF_RG_PELLES
                 ENDCASE
         ELSEIF  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'CHECKMINIGUI'
                 DO CASE
                 CASE US_Word( LOC_cLine, 2 ) == DefineMiniGui1
                    Prj_Radio_MiniGui := DEF_RG_MINIGUI1
                 CASE US_Word( LOC_cLine, 2 ) == DefineMiniGui3
                    Prj_Radio_MiniGui := DEF_RG_MINIGUI3
                 CASE US_Word( LOC_cLine, 2 ) == DefineExtended1
                    Prj_Radio_MiniGui := DEF_RG_EXTENDED1
                 CASE US_Word( LOC_cLine, 2 ) == DefineOohg3
                    Prj_Radio_MiniGui := DEF_RG_OOHG3
                 ENDCASE
         ELSEIF  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'DEBUGACTIVE'
                 PUB_bDebugActive := iif( US_Word( LOC_cLine, 2 ) == 'YES', .T., .F. )
                 PUB_bDebugActiveAnt := PUB_bDebugActive
         ELSEIF  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'CHECKCONSOLE'
                 Prj_Check_Console := iif( US_Word( LOC_cLine, 2 ) == 'YES', .T., .F. )
         ELSEIF  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'CHECKMT'
                 Prj_Check_MT := iif( US_Word( LOC_cLine, 2 ) == 'YES', .T., .F. )
         ELSEIF  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'OUTPUTTYPE'
                 DO CASE
                 CASE US_Word( LOC_cLine, 2 ) == 'SRCEXE'
                    Prj_Radio_OutputType := DEF_RG_EXE
                 CASE US_Word( LOC_cLine, 2 ) == 'SRCLIB'
                    Prj_Radio_OutputType := DEF_RG_LIB
                 CASE US_Word( LOC_cLine, 2 ) == 'DLLLIB'
                    Prj_Radio_OutputType := DEF_RG_IMPORT
                    VentanaMain.Check_NumberOnPrg.enabled := .F.
                    VentanaMain.bReLoadPpo.enabled := .F.
                 ENDCASE
                 ActOutputTypeSet()
         ELSEIF  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'CHECKREIMPORT'
                 SetProperty( 'VentanaMain', 'Check_Reimp', 'Value', iif( US_Word( LOC_cLine, 2 ) == 'YES', .T., .F. ) )
         ELSEIF  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'LIBREIMPORT'
                 SetProperty( 'VentanaMain', 'TReimportLib', 'Value', US_WordSubStr( LOC_cLine, 2 ) )
         ELSEIF  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'IMPORTGUIONA'
                 SetProperty( 'VentanaMain', 'Check_GuionA', 'Value', iif( US_Word( LOC_cLine, 2 ) == 'YES', .T., .F. ) )
         ELSEIF  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'OUTPUTCOPYMOVE'
                 DO CASE
                 CASE US_Word( LOC_cLine, 2 ) == 'NONE'
                    Prj_Radio_OutputCopyMove := DEF_RG_NONE
                 CASE US_Word( LOC_cLine, 2 ) == 'COPY'
                    Prj_Radio_OutputCopyMove := DEF_RG_COPY
                 CASE US_Word( LOC_cLine, 2 ) == 'MOVE'
                    Prj_Radio_OutputCopyMove := DEF_RG_MOVE
                 ENDCASE
         ELSEIF  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'OUTPUTCOPYMOVEFOLDER'
                 Prj_Text_OutputCopyMoveFolder := ChgPathToReal( US_WordSubStr( LOC_cLine, 2 ) )
         ELSEIF  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'DBFAUTOVIEW'
                 bDbfAutoView := iif( US_Word( LOC_cLine, 2 ) == '.T.', .T., .F. )
         ELSEIF  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'EXTRARUNCMDFINAL'
                 Prj_ExtraRunCmdFINAL := US_WordSubStr( LOC_cLine, 2 )
         ELSEIF  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'EXTRARUNPROJQPM'
                 Prj_ExtraRunProjQPM := US_WordSubStr( LOC_cLine, 2 )
         ELSEIF  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'EXTRARUNCMDEXE'
                 Prj_ExtraRunCmdEXE := US_WordSubStr( LOC_cLine, 2 )
         ELSEIF  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'EXTRARUNCMDFREE'
                 Prj_ExtraRunCmdFREE := US_WordSubStr( LOC_cLine, 2 )
         ELSEIF  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'EXTRARUNQPMPARM'
                 Prj_ExtraRunCmdQPMParm := US_WordSubStr( LOC_cLine, 2 )
         ELSEIF  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'EXTRARUNEXEPARM'
                 Prj_ExtraRunCmdEXEParm := US_WordSubStr( LOC_cLine, 2 )
         ELSEIF  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'EXTRARUNFREEPARM'
                 Prj_ExtraRunCmdFREEParm := US_WordSubStr( LOC_cLine, 2 )
         ELSEIF  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'EXTRARUNTYPE'
                 Prj_ExtraRunType := US_WordSubStr( LOC_cLine, 2 )
                 IF Empty( Prj_ExtraRunType )
                    Prj_ExtraRunType := 'NONE'
                 ENDIF
         ELSEIF  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'EXTRARUNQPMRADIO'
                 Prj_ExtraRunQPMRadio := US_WordSubStr( LOC_cLine, 2 )
         ELSEIF  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'EXTRARUNQPMLITE'
                 Prj_ExtraRunQPMLite := iif( US_WordSubStr( LOC_cLine, 2 ) == '.T.', .T., .F. )
         ELSEIF  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'EXTRARUNQPMFORCEFULL'
                 Prj_ExtraRunQPMForceFull := iif( US_WordSubStr( LOC_cLine, 2 ) == '.T.', .T., .F. )
         ELSEIF  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'EXTRARUNQPMRUN'
                 Prj_ExtraRunQPMRun := iif( US_WordSubStr( LOC_cLine, 2 ) == '.T.', .T., .F. )
         ELSEIF  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'EXTRARUNQPMBUTTONRUN'
                 Prj_ExtraRunQPMButtonRun := iif( US_WordSubStr( LOC_cLine, 2 ) == '.T.', .T., .F. )
         ELSEIF  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'EXTRARUNQPMCLEAR'
                 Prj_ExtraRunQPMClear := iif( US_WordSubStr( LOC_cLine, 2 ) == '.T.', .T., .F. )
         ELSEIF  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'EXTRARUNQPMLOG'
                 Prj_ExtraRunQPMLog := iif( US_WordSubStr( LOC_cLine, 2 ) == '.T.', .T., .F. )
         ELSEIF  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'EXTRARUNQPMLOGONLYERROR'
                 Prj_ExtraRunQPMLogOnlyError := iif( US_WordSubStr( LOC_cLine, 2 ) == '.T.', .T., .F. )
         ELSEIF  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'EXTRARUNQPMAUTOEXIT'
                 Prj_ExtraRunQPMAutoEXIT := iif( US_WordSubStr( LOC_cLine, 2 ) == '.T.', .T., .F. )
         ELSEIF  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'EXTRARUNEXEWAIT'
                 Prj_ExtraRunExeWait := iif( US_WordSubStr( LOC_cLine, 2 ) == '.T.', .T., .F. )
         ELSEIF  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'EXTRARUNEXEPAUSE'
                 Prj_ExtraRunExePause := iif( US_WordSubStr( LOC_cLine, 2 ) == '.T.', .T., .F. )
         ELSEIF  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'EXTRARUNFREEWAIT'
                 Prj_ExtraRunFreeWait := iif( US_WordSubStr( LOC_cLine, 2 ) == '.T.', .T., .F. )
         ELSEIF  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'EXTRARUNFREEPAUSE'
                 Prj_ExtraRunFreePause := iif( US_WordSubStr( LOC_cLine, 2 ) == '.T.', .T., .F. )
         ELSEIF  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'OUTPUTRENAME'
                 DO CASE
                 CASE US_Word( LOC_cLine, 2 ) == 'NONE'
                    Prj_Radio_OutputRename := DEF_RG_NONE
                 CASE US_Word( LOC_cLine, 2 ) == 'NEWNAME'
                    Prj_Radio_OutputRename := DEF_RG_NEWNAME
                 ENDCASE
         ELSEIF  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'OUTPUTRENAMENEWNAME'
                 Prj_Text_OutputRenameNewName := US_WordSubStr( LOC_cLine, 2 )
         ELSEIF  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'CHECKOUTPUTSUFFIX'
                 Prj_Check_OutputSuffix := iif( US_Word( LOC_cLine, 2 ) == 'YES', .T., .F. )
         ELSEIF  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'CHECKOUTPUTPREFIX'
                 Prj_Check_OutputPrefix := iif( US_Word( LOC_cLine, 2 ) == 'YES', .T., .F. )
         ELSEIF  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'CHECKSTATICBUILD'
                 Prj_Check_StaticBuild := iif( US_Word( LOC_cLine, 2 ) == 'YES', .T., .F. )
         ELSEIF  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'WARNBCCOBJECT'
                 Prj_Warn_BccObject := iif( US_Word( LOC_cLine, 2 ) == 'YES', .T., .F. )
         ELSEIF  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'WARNBCCOBJECTCONT'
                 Prj_Warn_BccObject_Cont := iif( US_Word( LOC_cLine, 2 ) == 'YES', .T., .F. )
         ELSEIF  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'WARNCPP'
                 Prj_Warn_Cpp := iif( US_Word( LOC_cLine, 2 ) == 'YES', .T., .F. )
         ELSEIF  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'WARNGTORDER'
                 Prj_Warn_GT_Order := iif( US_Word( LOC_cLine, 2 ) == 'YES', .T., .F. )
         ELSEIF  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'WARNGTORDERCONT'
                 Prj_Warn_GT_Order_Cont := iif( US_Word( LOC_cLine, 2 ) == 'YES', .T., .F. )
         ELSEIF  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'WARNDBFSEARCH'
                 Prj_Warn_DBF_Search := iif( US_Word( LOC_cLine, 2 ) == 'YES', .T., .F. )
         ELSEIF  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'WARNDBFSEARCHCONT'
                 Prj_Warn_DBF_Search_Cont := iif( US_Word( LOC_cLine, 2 ) == 'YES', .T., .F. )
         ELSEIF  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'WARNINFOSAVEDMSG'
                 Prj_Warn_InfoSaved := iif( US_Word( LOC_cLine, 2 ) == 'YES', .T., .F. )
         ELSEIF  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'WARNNULRDD'
                 Prj_Warn_NullRDD := iif( US_Word( LOC_cLine, 2 ) == 'YES', .T., .F. )
         ELSEIF  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'WARNPPOBROWSE'
                 Prj_Warn_PPO_Browse := iif( US_Word( LOC_cLine, 2 ) == 'YES', .T., .F. )
         ELSEIF  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'WARNSLOWSEARCH'
                 Prj_Warn_SlowSearch := iif( US_Word( LOC_cLine, 2 ) == 'YES', .T., .F. )
         ELSEIF  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'WARNSLOWSEARCHCONT'
                 Prj_Warn_SlowSearch_Cont := iif( US_Word( LOC_cLine, 2 ) == 'YES', .T., .F. )
         ELSEIF  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'WARNTOPFILE'
                 Prj_Warn_TopFile := iif( US_Word( LOC_cLine, 2 ) == 'YES', .T., .F. )
         ELSEIF  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'CHECKUPX'
                 Prj_Check_Upx := iif( US_Word( LOC_cLine, 2 ) == 'YES', .T., .F. )
         ELSEIF  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'CHECKFORMTOOL'
                 DO CASE
                 CASE US_Word( LOC_cLine, 2 ) == 'EDITOR'
                    Prj_Radio_FormTool := DEF_RG_EDITOR
                 CASE US_Word( LOC_cLine, 2 ) == 'HMI'
                    Prj_Radio_FormTool := DEF_RG_OOHGIDE
                 CASE US_Word( LOC_cLine, 2 ) == 'OOHGIDE'
                    Prj_Radio_FormTool := DEF_RG_OOHGIDE
                 CASE US_Word( LOC_cLine, 2 ) == 'HMGSIDE'
                    Prj_Radio_FormTool := DEF_RG_HMGSIDE
                 CASE US_Word( LOC_cLine, 2 ) == 'HMG_IDE'
                    Prj_Radio_FormTool := DEF_RG_HMG_IDE
                 ENDCASE
         ELSEIF  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'CHECKDBFTOOL'
                 DO CASE
                 CASE US_Word( LOC_cLine, 2 ) == 'DBFVIEW'
                    Prj_Radio_DbfTool := DEF_RG_DBFTOOL
                 CASE US_Word( LOC_cLine, 2 ) == 'DBU'
                    Prj_Radio_DbfTool := DEF_RG_OTHER
                 CASE US_Word( LOC_cLine, 2 ) == 'OTHER'
                    Prj_Radio_DbfTool := DEF_RG_OTHER
                 ENDCASE
         ELSEIF  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'MI_BEXEASSOCIATION'
                 PUB_MI_bExeAssociation := iif( US_WordSubStr( LOC_cLine, 2 ) == '.T.', .T., .F. )
         ELSEIF  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'MI_CEXEASSOCIATION'
                 PUB_MI_cExeAssociation := US_WordSubStr( LOC_cLine, 2 )
         ELSEIF  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'MI_NEXEASSOCIATIONICON'
                 PUB_MI_nExeAssociationIcon := Val( US_Word( LOC_cLine, 2 ) )
         ELSEIF  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'MI_BEXEBACKUPOPTION'
                 PUB_MI_bExeBackupOption := iif( US_WordSubStr( LOC_cLine, 2 ) == '.T.', .T., .F. )
         ELSEIF  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'MI_BNEWFILE'
                 PUB_MI_bNewFile := iif( US_WordSubStr( LOC_cLine, 2 ) == '.T.', .T., .F. )
         ELSEIF  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'MI_NNEWFILESUGGESTED'
                 PUB_MI_nNewFileSuggested := Val( US_WordSubStr( LOC_cLine, 2 ) )
         ELSEIF  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'MI_CNEWFILELEYEND'
                 PUB_MI_cNewFileLeyend := US_WordSubStr( LOC_cLine, 2 )
         ELSEIF  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'MI_NNEWFILEEmpty'
                 PUB_MI_nNewFileEmpty := Val( US_WordSubStr( LOC_cLine, 2 ) )
         ELSEIF  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'MI_CNEWFILEUSERFILE'
                 PUB_MI_cNewFileUserFile := US_WordSubStr( LOC_cLine, 2 )
         ELSEIF  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'MI_NDESTINATIONPATH'
                 PUB_MI_nDestinationPath := Val( US_WordSubStr( LOC_cLine, 2 ) )
         ELSEIF  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'MI_CDESTINATIONPATH'
                 PUB_MI_cDestinationPath := US_WordSubStr( LOC_cLine, 2 )
         ELSEIF  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'MI_NLEYENDSUGGESTED'
                 PUB_MI_nLeyendSuggested := Val( US_WordSubStr( LOC_cLine, 2 ) )
         ELSEIF  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'MI_CLEYENDUSERTEXT'
                 PUB_MI_cLeyendUserText := US_WordSubStr( LOC_cLine, 2 )
         ELSEIF  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'MI_BDESKTOPSHORTCUT'
                 PUB_MI_bDesktopShortCut := iif( US_WordSubStr( LOC_cLine, 2 ) == '.T.', .T., .F. )
         ELSEIF  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'MI_NDESKTOPSHORTCUT'
                 PUB_MI_nDesktopShortCut := Val( US_WordSubStr( LOC_cLine, 2 ) )
         ELSEIF  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'MI_BSTARTMENUSHORTCUT'
                 PUB_MI_bStartMenuShortCut := iif( US_WordSubStr( LOC_cLine, 2 ) == '.T.', .T., .F. )
         ELSEIF  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'MI_NSTARTMENUSHORTCUT'
                 PUB_MI_nStartMenuShortCut := Val( US_WordSubStr( LOC_cLine, 2 ) )
         ELSEIF  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'MI_BLAUNCHAPPLICATION'
                 PUB_MI_bLaunchApplication := iif( US_WordSubStr( LOC_cLine, 2 ) == '.T.', .T., .F. )
         ELSEIF  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'MI_NLAUNCHAPPLICATION'
                 PUB_MI_nLaunchApplication := Val( US_WordSubStr( LOC_cLine, 2 ) )
         ELSEIF  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'MI_BLAUNCHBACKUPOPTION'
                 PUB_MI_bLaunchBackupOption := iif( US_WordSubStr( LOC_cLine, 2 ) == '.T.', .T., .F. )
         ELSEIF  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'MI_BREBOOT'
                 PUB_MI_bReboot := iif( US_WordSubStr( LOC_cLine, 2 ) == '.T.', .T., .F. )
         ELSEIF  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'MI_CDEFAULTLANGUAGE'
                 PUB_MI_cDefaultLanguage := US_Word( LOC_cLine, 2 )
         ELSEIF  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'MI_NINSTALLERNAME'
                 PUB_MI_nInstallerName := Val( US_WordSubStr( LOC_cLine, 2 ) )
         ELSEIF  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'MI_CINSTALLERNAME'
                 PUB_MI_cInstallerName := US_WordSubStr( LOC_cLine, 2 )
         ELSEIF  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'MI_CIMAGE'
                 PUB_MI_cImage := US_WordSubStr( LOC_cLine, 2 )
         ELSEIF  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'MI_BSELECTALLPRG'
                 PUB_MI_bSelectAllPRG := iif( US_WordSubStr( LOC_cLine, 2 ) == '.T.', .T., .F. )
         ELSEIF  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'MI_BSELECTALLHEA'
                 PUB_MI_bSelectAllHEA := iif( US_WordSubStr( LOC_cLine, 2 ) == '.T.', .T., .F. )
         ELSEIF  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'MI_BSELECTALLPAN'
                 PUB_MI_bSelectAllPAN := iif( US_WordSubStr( LOC_cLine, 2 ) == '.T.', .T., .F. )
         ELSEIF  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'MI_BSELECTALLDBF'
                 PUB_MI_bSelectAllDBF := iif( US_WordSubStr( LOC_cLine, 2 ) == '.T.', .T., .F. )
         ELSEIF  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'MI_BSELECTALLLIB'
                 PUB_MI_bSelectAllLIB := iif( US_WordSubStr( LOC_cLine, 2 ) == '.T.', .T., .F. )
         ELSEIF  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'SHGDATABASE'
                 SHG_Database := ChgPathToReal( US_WordSubStr( LOC_cLine, 2 ) )
         ELSEIF  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'SHGLASTFOLDERIMG'
                 SHG_LastFolderImg := ChgPathToReal( US_WordSubStr( LOC_cLine, 2 ) )
         ELSEIF  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'SHGOUTPUTTYPE'
                 SHG_CheckTypeOutput := iif( US_Word( LOC_cLine, 2 ) == 'YES', .T., .F. )
#ifdef QPM_SHG
                 SetProperty( 'VentanaMain', 'CH_SHG_TypeOutput', 'value', SHG_CheckTypeOutput )
#endif
         ELSEIF  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'SHGHTMLFOLDER'
                 SHG_HtmlFolder := ChgPathToReal( US_WordSubStr( LOC_cLine, 2 ) )
         ELSEIF  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'SHGWWW'
                 SHG_WWW := US_WordSubStr( LOC_cLine, 2 )
#ifdef QPM_HOTRECOVERY
         ELSEIF  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'HOTLASTEXTERNALFILE'
                 Gbl_HR_cLastExternalFileName := US_WordSubStr( LOC_cLine, 2 )
#endif
         ELSEIF  US_Upper ( US_Word( LOC_cLine, 1 ) ) == 'SOURCE'
                 cForceRecomp := ' '
                 IF At( '<FR> ', LOC_cLine ) > 0
                    LOC_cLine := StrTran( LOC_cLine, '<FR> ', '' )
                    cForceRecomp := 'R'
                 ENDIF
                 cFile := US_WordSubStr( LOC_cLine, 2 )
                 VentanaMain.GPrgFiles.AddItem( { PUB_nGridImgNone, cForceRecomp, US_FileNameOnlyNameAndExt( US_WordSubStr( LOC_cLine, 2 ) ), ChgPathToRelative( cFile ), '0', '', '' } )
                 IF Upper( US_FileNameOnlyExt( cFile ) ) == 'PRG'
                    IF AScan( vExtraFoldersForSearchHB, { |y| US_Upper( y ) == US_Upper( US_FileNameOnlyPath( cFile ) ) } ) == 0
                       AAdd( vExtraFoldersForSearchHB, US_FileNameOnlyPath( cFile ) )
                    ENDIF
                 ELSE
                    IF AScan( vExtraFoldersForSearchC, { |y| US_Upper( y ) == US_Upper( US_FileNameOnlyPath( cFile ) ) } ) == 0
                       AAdd( vExtraFoldersForSearchC, US_FileNameOnlyPath( cFile ) )
                    ENDIF
                 ENDIF
         ELSEIF  US_Upper ( US_Word( LOC_cLine, 1 ) ) == 'HEAD'
                 VentanaMain.GHeaFiles.AddItem( { PUB_nGridImgNone, US_FileNameOnlyNameAndExt( US_WordSubStr( LOC_cLine, 2 ) ), ChgPathToRelative( US_WordSubStr( LOC_cLine, 2 ) ), '0', '', '' } )
                 IF AScan( vExtraFoldersForSearchHB, { |y| US_Upper( y ) == US_Upper( US_FileNameOnlyPath( ChgPathToReal( GetProperty( 'VentanaMain', 'GHeaFiles', 'Cell', VentanaMain.GHeaFiles.ItemCount, NCOLHEAFULLNAME ) ) ) ) } ) == 0
                    AAdd( vExtraFoldersForSearchHB, US_FileNameOnlyPath( ChgPathToReal( GetProperty( 'VentanaMain', 'GHeaFiles', 'Cell', VentanaMain.GHeaFiles.ItemCount, NCOLHEAFULLNAME ) ) ) )
                 ENDIF
                 IF AScan( vExtraFoldersForSearchC, { |y| US_Upper( y ) == US_Upper( US_FileNameOnlyPath( ChgPathToReal( GetProperty( 'VentanaMain', 'GHeaFiles', 'Cell', VentanaMain.GHeaFiles.ItemCount, NCOLHEAFULLNAME ) ) ) ) } ) == 0
                    AAdd( vExtraFoldersForSearchC, US_FileNameOnlyPath( ChgPathToReal( GetProperty( 'VentanaMain', 'GHeaFiles', 'Cell', VentanaMain.GHeaFiles.ItemCount, NCOLHEAFULLNAME ) ) ) )
                 ENDIF
         ELSEIF  US_Upper ( US_Word( LOC_cLine, 1 ) ) == 'FORM'
                 VentanaMain.GPanFiles.AddItem( { PUB_nGridImgNone, US_FileNameOnlyNameAndExt( US_WordSubStr( LOC_cLine, 2 ) ), ChgPathToRelative( US_WordSubStr( LOC_cLine, 2 ) ), '0', '', '' } )
                 IF AScan( vExtraFoldersForSearchHB, { |y| US_Upper( y ) == US_Upper( US_FileNameOnlyPath( ChgPathToReal( GetProperty( 'VentanaMain', 'GPanFiles', 'Cell', VentanaMain.GPanFiles.ItemCount, NCOLPANFULLNAME ) ) ) ) } ) == 0
                    AAdd( vExtraFoldersForSearchHB, US_FileNameOnlyPath( ChgPathToReal( GetProperty( 'VentanaMain', 'GPanFiles', 'Cell', VentanaMain.GPanFiles.ItemCount, NCOLPANFULLNAME ) ) ) )
                 ENDIF
         ELSEIF  US_Upper ( US_Word( LOC_cLine, 1 ) ) == 'DBF'
                 VentanaMain.GDbfFiles.AddItem( { PUB_nGridImgNone, US_FileNameOnlyNameAndExt( US_WordSubStr( LOC_cLine, 2 ) ), ChgPathToRelative( US_WordSubStr( LOC_cLine, 2 ) ), '0 0', '', '0 ** 0' } )

         ELSEIF  SubStr( US_Word( US_Upper ( LOC_cLine ), 1 ), 1, 7 ) == 'INCLUDE'
                  IF US_IsVar( 'IncludeLibs' + SubStr( US_Upper( US_Word( LOC_cLine, 1 ) ), 8 ) )
                     AAdd( &( 'IncludeLibs' + SubStr( US_Upper( US_Word( LOC_cLine, 1 ) ), 8 ) ), US_Word( LOC_cLine, 2 ) + ' ' + SubStr( LOC_cLine, US_WordInd( LOC_cLine, 3 ) ) )
                  ELSE
                     IF US_IsVar( 'IncludeLibs' + SubStr( US_Upper( US_Word( LOC_cLine, 1 ) ), 8 ) + Define32bits )
                        AAdd( &( 'IncludeLibs' + SubStr( US_Upper( US_Word( LOC_cLine, 1 ) ), 8 ) + Define32bits ), US_Word( LOC_cLine, 2 ) + ' ' + SubStr( LOC_cLine, US_WordInd( LOC_cLine, 3 ) ) )
                     ENDIF
                  ENDIF
         ELSEIF  SubStr( US_Word( US_Upper ( LOC_cLine ), 1 ), 1, 7 ) == 'EXCLUDE'
                  IF US_IsVar( 'ExcludeLibs' + SubStr( US_Upper( US_Word( LOC_cLine, 1 ) ), 8 ) )
                     AAdd( &( 'ExcludeLibs' + SubStr( US_Upper( US_Word( LOC_cLine, 1 ) ), 8 ) ), AllTrim( US_Word( LOC_cLine, 2 ) + ' ' + SubStr( LOC_cLine, US_WordInd( LOC_cLine, 3 ) ) ) )
                  ELSE
                     IF US_IsVar( 'ExcludeLibs' + SubStr( US_Upper( US_Word( LOC_cLine, 1 ) ), 8 ) + Define32bits )
                        AAdd( &( 'ExcludeLibs' + SubStr( US_Upper( US_Word( LOC_cLine, 1 ) ), 8 ) + Define32bits ), AllTrim( US_Word( LOC_cLine, 2 ) + ' ' + SubStr( LOC_cLine, US_WordInd( LOC_cLine, 3 ) ) ) )
                     ENDIF
                  ENDIF
         ENDIF
      NEXT i
   ENDIF

   IF ! PUB_bLite
#ifdef QPM_SHG
      IF SHG_Database == '*NONE*'
         SHG_Database := ''
      ELSE
         IF Empty( SHG_Database )
            SHG_Database := SHG_StrTran( SHG_GetDatabaseName( US_FileNameOnlyPathAndName(cProjectFileName) ) + '_SHG.dbf' )
            IF MyMsgYesNo( 'Create Simple Help Generator (SHG) database ' + DBLQT + SHG_Database + DBLQT + "?" )
               SHG_CreateDatabase( SHG_Database )
            ELSE
               SHG_Database := ''
            ENDIF
         ENDIF
      ENDIF
      VentanaMain.TWWWHlp.Value      := SHG_WWW
      SetProperty( 'VentanaMain', 'RichEditHlp', 'readonly', .T. )
      IF ! Empty( SHG_Database )
         IF File( SHG_Database )
            SHG_LoadDatabase( SHG_Database )
            SetProperty( 'VentanaMain', 'RichEditHlp', 'readonly', .F. )
         ELSE
            IF MyMsgYesNo( 'Simple Help Generator (SHG) database not found: ' + SHG_Database + CRLF + ;
                           'Erase setting?' + CRLF + CRLF + ;
                           'Use tab ' + DBLQT + PageHlp + DBLQT + ' to select or create a new one.' )
               SHG_Database := ""
            ENDIF
         ENDIF
      ENDIF
      VentanaMain.THlpDataBase.Value := SHG_Database
#endif
      RichEditDisplay('OUT')
      VentanaMain.LFull.FontColor := DEF_COLORGREEN
      VentanaMain.LFull.Value     := 'Incremental'
   ELSE
      VentanaLite.LFull.FontColor := DEF_COLORGREEN
      VentanaLite.LFull.Value     := 'Incremental'
   ENDIF
   QPM_InitLibrariesForFlavor( GetSuffix() )
   CargoDefaultLibs( GetSuffix() )                   // This loads the default libraries grid
   CargoIncludeLibs( GetSuffix() )                   // This loads the include libraries grid
   CargoExcludeLibs( GetSuffix() )                   // This loads the exclude libraries grid
   QPM_SetColor()
   SetMGWaitTxt( 'Columns Autofit ...' )
   DoMethod( 'VentanaMain', 'GPrgFiles', 'ColumnsAutoFitH' )
   DoMethod( 'VentanaMain', 'GPanFiles', 'ColumnsAutoFitH' )
   DoMethod( 'VentanaMain', 'GDbfFiles', 'ColumnsAutoFitH' )
   DoMethod( 'VentanaMain', 'GHeaFiles', 'ColumnsAutoFitH' )
   DoMethod( 'VentanaMain', 'GIncFiles', 'ColumnsAutoFitH' )
   DoMethod( 'VentanaMain', 'GExcFiles', 'ColumnsAutoFitH' )
#ifdef QPM_SHG
   DoMethod( 'VentanaMain', 'GHlpFiles', 'ColumnsAutoFitH' )
#endif
   QPM_CheckFiles()
   VentanaMain.TabGrids.Value  := 1
   VentanaMain.GPrgFiles.Value := 1
   VentanaMain.GHeaFiles.Value := 1
   VentanaMain.GPanFiles.Value := 1
   VentanaMain.GDbfFiles.Value := 1
   VentanaMain.GIncFiles.Value := 1
   VentanaMain.GExcFiles.Value := 1
#ifdef QPM_SHG
   VentanaMain.GHlpFiles.Value := 1
#endif
   TabSync()
   DoMethod( 'VentanaMain', 'GPrgFiles', 'EnableUpdate' )
   DoMethod( 'VentanaMain', 'GPanFiles', 'EnableUpdate' )
   DoMethod( 'VentanaMain', 'GDbfFiles', 'EnableUpdate' )
   DoMethod( 'VentanaMain', 'GHeaFiles', 'EnableUpdate' )
   DoMethod( 'VentanaMain', 'GIncFiles', 'EnableUpdate' )
   DoMethod( 'VentanaMain', 'GExcFiles', 'EnableUpdate' )
#ifdef QPM_SHG
   DoMethod( 'VentanaMain', 'GHlpFiles', 'EnableUpdate' )
#endif
   ProjectButtons( .T. )
   AddLastOpen( cProjectFileName )
   QPM_DefinoMainMenu()
   VentanaMain.Check_DbfAutoView.Value := bDbfAutoView
   IF Prj_IsNew
      SetMGWaitHide()
      ProjectSettings()
      GlobalSettings()
      SetMGWaitShow()
   ENDIF
   SetProperty( 'VentanaMain', 'build', 'enabled', .T. )
   ActOutputTypeSet()
   ActLibReimp()
   CambioTitulo()
   QPM_SetResumen()
RETURN .T.

FUNCTION QPM_ClearLastOpenList()
   vLastOpen := {}
   QPM_DefinoMainMenu()
RETURN .T.

FUNCTION QPM_CheckFiles()
   LOCAL i
   SetMGWaitTxt( 'Checking files ...' )
   DoMethod( 'VentanaMain', 'GPrgFiles', 'DisableUpdate' )
   FOR i := 1 TO VentanaMain.GPrgFiles.ItemCount
      IF ! File( ChgPathToReal( GetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', i, NCOLPRGFULLNAME ) ) )
         GridImage( 'VentanaMain', 'GPrgFiles', i, NCOLPRGSTATUS, '+', PUB_nGridImgEquis )
      ELSE
         GridImage( 'VentanaMain', 'GPrgFiles', i, NCOLPRGSTATUS, '-', PUB_nGridImgEquis )
      ENDIF
   NEXT i
   DoMethod( 'VentanaMain', 'GPrgFiles', 'EnableUpdate' )
   DoMethod( 'VentanaMain', 'GPanFiles', 'DisableUpdate' )
   FOR i := 1 TO VentanaMain.GPanFiles.ItemCount
      IF ! File( ChgPathToReal( GetProperty( 'VentanaMain', 'GPanFiles', 'Cell', i, NCOLPANFULLNAME ) ) )
         GridImage( 'VentanaMain', 'GPanFiles', i, NCOLPANSTATUS, '+', PUB_nGridImgEquis )
      ELSE
         GridImage( 'VentanaMain', 'GPanFiles', i, NCOLPANSTATUS, '-', PUB_nGridImgEquis )
      ENDIF
   NEXT i
   DoMethod( 'VentanaMain', 'GPanFiles', 'EnableUpdate' )
   DoMethod( 'VentanaMain', 'GDbfFiles', 'DisableUpdate' )
   FOR i := 1 TO VentanaMain.GDbfFiles.ItemCount
      IF ! File( ChgPathToReal( GetProperty( 'VentanaMain', 'GDbfFiles', 'Cell', i, NCOLDBFFULLNAME ) ) )
         GridImage( 'VentanaMain', 'GDbfFiles', i, NCOLDBFSTATUS, '+', PUB_nGridImgEquis )
      ELSE
         GridImage( 'VentanaMain', 'GDbfFiles', i, NCOLDBFSTATUS, '-', PUB_nGridImgEquis )
      ENDIF
   NEXT i
   DoMethod( 'VentanaMain', 'GDbfFiles', 'EnableUpdate' )
   DoMethod( 'VentanaMain', 'GHeaFiles', 'DisableUpdate' )
   FOR i := 1 TO VentanaMain.GHeaFiles.ItemCount
      IF ! File( ChgPathToReal( GetProperty( 'VentanaMain', 'GHeaFiles', 'Cell', i, NCOLHEAFULLNAME ) ) )
         GridImage( 'VentanaMain', 'GHeaFiles', i, NCOLHEASTATUS, '+', PUB_nGridImgEquis )
      ELSE
         GridImage( 'VentanaMain', 'GHeaFiles', i, NCOLHEASTATUS, '-', PUB_nGridImgEquis )
      ENDIF
   NEXT i
   DoMethod( 'VentanaMain', 'GHeaFiles', 'EnableUpdate' )
   DoMethod( 'VentanaMain', 'GIncFiles', 'DisableUpdate' )
   FOR i := 1 TO VentanaMain.GIncFiles.ItemCount
      IF ! File( ChgPathToReal( US_WordSubStr( GetProperty( 'VentanaMain', 'GIncFiles', 'Cell', i, NCOLINCFULLNAME ), 3 ) ) )
         GridImage( 'VentanaMain', 'GIncFiles', i, NCOLINCSTATUS, '+', PUB_nGridImgEquis )
      ELSE
         GridImage( 'VentanaMain', 'GIncFiles', i, NCOLINCSTATUS, '-', PUB_nGridImgEquis )
      ENDIF
   NEXT i
   DoMethod( 'VentanaMain', 'GIncFiles', 'EnableUpdate' )
RETURN .T.

FUNCTION QPM_SetResumen()
   LOCAL Venta := iif( PUB_bLite, 'VentanaLite', 'VentanaMain' ), cAux
   IF Prj_Radio_OutputType == DEF_RG_IMPORT
      DO CASE
         CASE GetCppSuffix() == DefineBorland
            cAux := 'BCC32'
         CASE GetCppSuffix() == DefineMinGW
            cAux := 'MinGW'
         CASE GetCppSuffix() == DefinePelles
            cAux := 'Pelles'
         OTHERWISE
            MyMsgStop( 'Invalid CPP type: ' + GetCppSuffix() )
      ENDCASE
      SetProperty( Venta, 'LResumen', 'Value', 'Build Interface Library From DLL For ' + cAux )
      SetProperty( Venta, 'LFull', 'visible', .F. )
      SetProperty( Venta, 'LExtra', 'visible', .F. )
   ELSE
      SetProperty( Venta, 'LResumen', 'Value', vSuffix[ AScan( vSuffix, { |x| x[1] == GetSuffix() } ) ][ 2 ] )
      SetProperty( Venta, 'LExtra', 'Value', LTrim( iif( Prj_Check_MT, ' MT Mode', '' ) + iif( Prj_Check_Console, ' Console Mode', '' ) + iif( PUB_bDebugActive, ' With DEBUG', '' ) + iif( VentanaMain.AutoInc.Checked, '', ' AutoInc OFF' ) + iif( VentanaMain.HotKeys.Checked, '', ' HotKeys OFF' ) ) )
      SetProperty( Venta, 'LFull', 'visible', .T. )
      SetProperty( Venta, 'LExtra', 'visible', .T. )
   ENDIF
RETURN NIL

FUNCTION QPM_SaveProject( bCheck )
   LOCAL i, j, bDiff, MemoAux, LineasC, LineasProject
   LOCAL cForceRecomp, bWrite := .F.
   LOCAL cINI := ''
   IF Empty( bCheck )
      bCheck := .F.
   ENDIF
   IF PUB_bOpenProjectFromParm
      PUB_bOpenProjectFromParm := .F.
      RETURN .F.
   ENDIF
   IF Empty( PUB_cProjectFile ) .AND. Empty( PUB_cProjectFolder )
      IF ! bCheck
         MyMsgStop( 'No project is open!' )
      ENDIF
      RETURN .F.
   ENDIF

      cINI += 'VERSION '                    + QPM_VERSION_NUMBER + CRLF
      cINI += 'PRJ_VERSION '                + MakePrj_Version() + CRLF
      cINI += 'PROJECTFOLDER '              + US_StrTran( PUB_cProjectFolder, PUB_cThisFolder, '<ThisFolder>' ) + CRLF
      cINI += 'AUTOINC '                    + iif( GetProperty( 'VentanaMain', 'AutoInc', 'checked' ), 'YES', 'NO' ) + CRLF
      cINI += 'CHECK64BITS '                + iif( Prj_Check_64bits, 'YES', 'NO' ) + CRLF
      cINI += 'CHECKCONSOLE '               + iif( Prj_Check_Console, 'YES', 'NO' ) + CRLF
      cINI += 'CHECKCPP '                   + GetCppSuffix() + CRLF
      cINI += 'CHECKDBFTOOL '               + cDbfTool() + CRLF
      cINI += 'CHECKFORMTOOL '              + GetFormTool() + CRLF
      cINI += 'CHECKHARBOUR '               + iif( Prj_Radio_Harbour == DEF_RG_XHARBOUR, DefineXHarbour, DefineHarbour ) + CRLF
      cINI += 'CHECKHARBOURIS31 '           + iif( Prj_Check_HarbourIs31, 'YES', 'NO' ) + CRLF
      cINI += 'CHECKMINIGUI '               + GetMiniGuiSuffix() + CRLF
      cINI += 'CHECKMT '                    + iif( Prj_Check_MT, 'YES', 'NO' ) + CRLF
      cINI += 'CHECKNOLIBRCS '              + iif( Prj_Check_IgnoreLibRCs, 'YES', 'NO' ) + CRLF
      cINI += 'CHECKNOMAINRC '              + iif( Prj_Check_IgnoreMainRC, 'YES', 'NO' ) + CRLF
      cINI += 'CHECKOUTPUTPREFIX '          + iif( Prj_Check_OutputPrefix, 'YES', 'NO' ) + CRLF
      cINI += 'CHECKOUTPUTSUFFIX '          + iif( Prj_Check_OutputSuffix, 'YES', 'NO' ) + CRLF
      cINI += 'CHECKPLACERCFIRST '          + iif( Prj_Check_PlaceRCFirst, 'YES', 'NO' ) + CRLF
      cINI += 'CHECKREIMPORT '              + iif( GetProperty( 'VentanaMain', 'Check_Reimp', 'Value' ), 'YES', 'NO' ) + CRLF
      cINI += 'CHECKSTATICBUILD '           + iif( Prj_Check_StaticBuild, 'YES', 'NO' ) + CRLF
      cINI += 'CHECKUPX '                   + iif( Prj_Check_Upx, 'YES', 'NO' ) + CRLF
   FOR i := 1 TO VentanaMain.GDbfFiles.ItemCount
      cINI += 'DBF '                        + ChgPathToRelative( GetProperty( 'VentanaMain', 'GDbfFiles', 'Cell', i, NCOLDBFFULLNAME ) ) + CRLF
   NEXT i
      cINI += 'DBFAUTOVIEW '                + US_VarToStr( bDbfAutoView ) + CRLF
      cINI += 'DEBUGACTIVE '                + iif( PUB_bDebugActive, 'YES', 'NO' ) + CRLF
   DescargoExcludeLibs( GetSuffix() )
   FOR i := 1 TO Len( vSuffix )
      FOR j := 1 TO Len( &( 'ExcludeLibs'+vSuffix[i][1] ) )
         cINI += 'EXCLUDE'                  + vSuffix[i][1] + ' ' + AllTrim( &( 'ExcludeLibs'+vSuffix[i][1]+'['+Str(j)+']' ) ) + CRLF
      NEXT
   NEXT
      cINI += 'EXTRARUNCMDEXE '             + Prj_ExtraRunCmdEXE + CRLF
      cINI += 'EXTRARUNCMDFINAL '           + Prj_ExtraRunCmdFINAL + CRLF
      cINI += 'EXTRARUNCMDFREE '            + Prj_ExtraRunCmdFREE + CRLF
      cINI += 'EXTRARUNEXEPARM '            + Prj_ExtraRunCmdEXEParm + CRLF
      cINI += 'EXTRARUNEXEPAUSE '           + US_VarToStr( Prj_ExtraRunExePause ) + CRLF
      cINI += 'EXTRARUNEXEWAIT '            + US_VarToStr( Prj_ExtraRunExeWait ) + CRLF
      cINI += 'EXTRARUNFREEPARM '           + Prj_ExtraRunCmdFREEParm + CRLF
      cINI += 'EXTRARUNFREEPAUSE '          + US_VarToStr( Prj_ExtraRunFreePause ) + CRLF
      cINI += 'EXTRARUNFREEWAIT '           + US_VarToStr( Prj_ExtraRunFreeWait ) + CRLF
      cINI += 'EXTRARUNPROJQPM '            + Prj_ExtraRunProjQPM + CRLF
      cINI += 'EXTRARUNQPMAUTOEXIT '        + US_VarToStr( Prj_ExtraRunQPMAutoEXIT ) + CRLF
      cINI += 'EXTRARUNQPMBUTTONRUN '       + US_VarToStr( Prj_ExtraRunQPMButtonRun ) + CRLF
      cINI += 'EXTRARUNQPMCLEAR '           + US_VarToStr( Prj_ExtraRunQPMClear ) + CRLF
      cINI += 'EXTRARUNQPMFORCEFULL '       + US_VarToStr( Prj_ExtraRunQPMForceFull ) + CRLF
      cINI += 'EXTRARUNQPMLITE '            + US_VarToStr( Prj_ExtraRunQPMLite ) + CRLF
      cINI += 'EXTRARUNQPMLOG '             + US_VarToStr( Prj_ExtraRunQPMLog ) + CRLF
      cINI += 'EXTRARUNQPMLOGONLYERROR '    + US_VarToStr( Prj_ExtraRunQPMLogOnlyError ) + CRLF
      cINI += 'EXTRARUNQPMPARM '            + Prj_ExtraRunCmdQPMParm + CRLF
      cINI += 'EXTRARUNQPMRADIO '           + US_VarToStr( Prj_ExtraRunQPMRadio ) + CRLF
      cINI += 'EXTRARUNQPMRUN '             + US_VarToStr( Prj_ExtraRunQPMRun ) + CRLF
      cINI += 'EXTRARUNTYPE '               + Prj_ExtraRunType + CRLF
   FOR i := 1 TO VentanaMain.GPanFiles.ItemCount
      cINI += 'FORM '                       + ChgPathToRelative( GetProperty( 'VentanaMain', 'GPanFiles', 'Cell', i, NCOLPANFULLNAME ) ) + CRLF
   NEXT i
   FOR i := 1 TO VentanaMain.GHeaFiles.ItemCount
      cINI += 'HEAD '                       + ChgPathToRelative( GetProperty( 'VentanaMain', 'GHeaFiles', 'Cell', i, NCOLHEAFULLNAME ) ) + CRLF
   NEXT i
      cINI += 'HOTKEYS '                    + iif( GetProperty( 'VentanaMain', 'HotKeys', 'checked' ), 'YES', 'NO' ) + CRLF
   #ifdef QPM_HOTRECOVERY
      cINI += 'HOTLASTEXTERNALFILE '        + Gbl_HR_cLastExternalFileName + CRLF
   #endif
      cINI += 'IMPORTGUIONA '               + iif( GetProperty( 'VentanaMain', 'Check_GuionA', 'Value' ), 'YES', 'NO' ) + CRLF
   DescargoIncludeLibs( GetSuffix() )
FOR i := 1 TO Len( vSuffix )
   FOR j := 1 TO Len( &( 'IncludeLibs'+vSuffix[i][1] ) )
      cINI += 'INCLUDE'                     + vSuffix[i][1] + ' ' + US_Word( &( 'IncludeLibs'+vSuffix[i][1]+'['+Str(j)+']' ), 1 ) + ' ' + US_Word( &( 'IncludeLibs'+vSuffix[i][1]+'['+Str(j)+']' ), 2 ) + CRLF
   NEXT
NEXT
   FOR i := 1 TO Len( vSuffix )
      cINI += 'LASTLIBFOLDER'               + vSuffix[i][1] + ' ' + &( 'cLastLibFolder'+vSuffix[i][1] ) + CRLF
   NEXT
      cINI += 'LIBREIMPORT '                + GetProperty( 'VentanaMain', 'TReimportLib', 'Value' ) + CRLF
      cINI += 'MI_BDESKTOPSHORTCUT '        + US_VarToStr( PUB_MI_bDesktopShortCut ) + CRLF
      cINI += 'MI_BEXEASSOCIATION '         + US_VarToStr( PUB_MI_bExeAssociation ) + CRLF
      cINI += 'MI_BEXEBACKUPOPTION '        + US_VarToStr( PUB_MI_bExeBackupOption ) + CRLF
      cINI += 'MI_BLAUNCHAPPLICATION '      + US_VarToStr( PUB_MI_bLaunchApplication ) + CRLF
      cINI += 'MI_BLAUNCHBACKUPOPTION '     + US_VarToStr( PUB_MI_bLaunchBackupOption ) + CRLF
      cINI += 'MI_BNEWFILE '                + US_VarToStr( PUB_MI_bNewFile ) + CRLF
      cINI += 'MI_BREBOOT '                 + US_VarToStr( PUB_MI_bReboot ) + CRLF
      cINI += 'MI_BSELECTALLDBF '           + US_VarToStr( PUB_MI_bSelectAllDBF ) + CRLF
      cINI += 'MI_BSELECTALLHEA '           + US_VarToStr( PUB_MI_bSelectAllHEA ) + CRLF
      cINI += 'MI_BSELECTALLLIB '           + US_VarToStr( PUB_MI_bSelectAllLIB ) + CRLF
      cINI += 'MI_BSELECTALLPAN '           + US_VarToStr( PUB_MI_bSelectAllPAN ) + CRLF
      cINI += 'MI_BSELECTALLPRG '           + US_VarToStr( PUB_MI_bSelectAllPRG ) + CRLF
      cINI += 'MI_BSTARTMENUSHORTCUT '      + US_VarToStr( PUB_MI_bStartMenuShortCut ) + CRLF
      cINI += 'MI_CDEFAULTLANGUAGE '        + US_VarToStr( PUB_MI_cDefaultLanguage ) + CRLF
      cINI += 'MI_CDESTINATIONPATH '        + US_VarToStr( PUB_MI_cDestinationPath ) + CRLF
      cINI += 'MI_CEXEASSOCIATION '         + US_VarToStr( PUB_MI_cExeAssociation ) + CRLF
      cINI += 'MI_CIMAGE '                  + US_VarToStr( PUB_MI_cImage ) + CRLF
      cINI += 'MI_CINSTALLERNAME '          + US_VarToStr( PUB_MI_cInstallerName ) + CRLF
      cINI += 'MI_CLEYENDUSERTEXT '         + US_VarToStr( PUB_MI_cLeyendUserText ) + CRLF
      cINI += 'MI_CNEWFILELEYEND '          + US_VarToStr( PUB_MI_cNewFileLeyend ) + CRLF
      cINI += 'MI_CNEWFILEUSERFILE '        + US_VarToStr( PUB_MI_cNewFileUserFile ) + CRLF
      cINI += 'MI_NDESKTOPSHORTCUT '        + US_VarToStr( PUB_MI_nDesktopShortCut ) + CRLF
      cINI += 'MI_NDESTINATIONPATH '        + US_VarToStr( PUB_MI_nDestinationPath ) + CRLF
      cINI += 'MI_NEXEASSOCIATIONICON '     + US_VarToStr( PUB_MI_nExeAssociationIcon ) + CRLF
      cINI += 'MI_NINSTALLERNAME '          + US_VarToStr( PUB_MI_nInstallerName ) + CRLF
      cINI += 'MI_NLAUNCHAPPLICATION '      + US_VarToStr( PUB_MI_nLaunchApplication ) + CRLF
      cINI += 'MI_NLEYENDSUGGESTED '        + US_VarToStr( PUB_MI_nLeyendSuggested ) + CRLF
      cINI += 'MI_NNEWFILEEMPTY '           + US_VarToStr( PUB_MI_nNewFileEmpty ) + CRLF
      cINI += 'MI_NNEWFILESUGGESTED '       + US_VarToStr( PUB_MI_nNewFileSuggested ) + CRLF
      cINI += 'MI_NSTARTMENUSHORTCUT '      + US_VarToStr( PUB_MI_nStartMenuShortCut ) + CRLF
      cINI += 'OUTPUTCOPYMOVE '             + cOutputCopyMove() + CRLF
      cINI += 'OUTPUTCOPYMOVEFOLDER '       + ChgPathToRelative( Prj_Text_OutputCopyMoveFolder ) + CRLF
      cINI += 'OUTPUTRENAME '               + cOutputRename() + CRLF
      cINI += 'OUTPUTRENAMENEWNAME '        + Prj_Text_OutputRenameNewName + CRLF
      cINI += 'OUTPUTTYPE '                 + cOutputType() + CRLF
      cINI += 'OVERRIDECOMPILEPARM '        + GetProperty( 'VentanaMain', 'OverrideCompile', 'value' ) + CRLF
      cINI += 'OVERRIDELINKPARM '           + GetProperty( 'VentanaMain', 'OverrideLink', 'value' ) + CRLF
      cINI += 'RUNFOLDER '                  + ChgPathToRelative(VentanaMain.TRunProjectFolder.Value) + CRLF
      cINI += 'RUNPARAM '                   + Gbl_cRunParm + CRLF
      cINI += 'SHGDATABASE '                + iif( Empty( SHG_Database ), '*NONE*', ChgPathToRelative( SHG_Database ) ) + CRLF
      cINI += 'SHGHTMLFOLDER '              + ChgPathToRelative( SHG_HtmlFolder ) + CRLF
      cINI += 'SHGLASTFOLDERIMG '           + ChgPathToRelative( SHG_LastFolderImg ) + CRLF
      cINI += 'SHGOUTPUTTYPE '              + iif( SHG_CheckTypeOutput, 'YES', 'NO' ) + CRLF
   #ifdef QPM_SHG
      cINI += 'SHGWWW '                     + VentanaMain.TWWWHlp.Value + CRLF
   #endif
      cINI += 'WARNBCCOBJECT '              + iif( Prj_Warn_BccObject, 'YES', 'NO' ) + CRLF
      cINI += 'WARNBCCOBJECTCONT '          + iif( Prj_Warn_BccObject_Cont, 'YES', 'NO' ) + CRLF
      cINI += 'WARNCPP '                    + iif( Prj_Warn_Cpp, 'YES', 'NO' ) + CRLF
      cINI += 'WARNDBFSEARCH '              + iif( Prj_Warn_DBF_Search, 'YES', 'NO' ) + CRLF
      cINI += 'WARNDBFSEARCHCONT '          + iif( Prj_Warn_DBF_Search_Cont, 'YES', 'NO' ) + CRLF
      cINI += 'WARNGTORDER '                + iif( Prj_Warn_GT_Order, 'YES', 'NO' ) + CRLF
      cINI += 'WARNGTORDERCONT '            + iif( Prj_Warn_GT_Order_Cont, 'YES', 'NO' ) + CRLF
      cINI += 'WARNINFOSAVEDMSG '           + iif( Prj_Warn_InfoSaved, 'YES', 'NO' ) + CRLF
      cINI += 'WARNNULLRDD '                + iif( Prj_Warn_NullRDD, 'YES', 'NO' ) + CRLF
      cINI += 'WARNPPOBROWSE '              + iif( Prj_Warn_PPO_Browse, 'YES', 'NO' ) + CRLF
      cINI += 'WARNSLOWSEARCH '             + iif( Prj_Warn_SlowSearch, 'YES', 'NO' ) + CRLF
      cINI += 'WARNSLOWSEARCHCONT '         + iif( Prj_Warn_SlowSearch_Cont, 'YES', 'NO' ) + CRLF
      cINI += 'WARNTOPFILE '                + iif( Prj_Warn_TopFile, 'YES', 'NO' ) + CRLF
   FOR i := 1 TO VentanaMain.GPrgFiles.ItemCount
      cForceRecomp := ''
      IF GetProperty( 'VentanaMain', 'GPRGFiles', 'Cell', i, NCOLPRGRECOMP ) == 'R'
         cForceRecomp := '<FR> '
      ENDIF
      cINI += 'SOURCE '                     + cForceRecomp + ChgPathToRelative( GetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', i, NCOLPRGFULLNAME ) ) + CRLF
   NEXT i
   DO WHILE " " + CRLF $ cINI
      cINI := StrTran( cINI, " " + CRLF, CRLF )
   ENDDO

   IF bCheck
      MemoAux       := MemoRead( PUB_cProjectFile )
      LineasProject := MLCount( MemoAux, 254 )
      LineasC       := MLCount( cINI, 254 )
      IF LineasC == LineasProject
         bDiff := .F.
         FOR i := 1 TO LineasC
            IF ! ( AllTrim( MemoLine( cINI, 254, i ) ) == AllTrim( MemoLine( MemoAux, 254, i ) ) )
               IF ! ( US_Word( MemoLine( MemoAux, 254, i ), 1 ) == 'PRJ_VERSION' .AND. ;
                      US_Word( MemoLine( MemoAux, 254, i ), 1 ) == 'PRJ_VERSION' )
                  bDiff := .T.
               ENDIF
            ENDIF
         NEXT
      ELSE
         bDiff := .T.
      ENDIF
      IF bDiff
         IF ! bAutoEXIT
            IF MyMsgYesNo( 'Save changes made to project: ' + DBLQT + US_FileNameOnlyNameAndExt( PUB_cProjectFile) + DBLQT + "?" )
               IF Empty( PUB_cProjectFile )
                  QPM_SaveAsProject( .T. )
               ELSE
                  QPM_LogText( "Writing project file " + PUB_cProjectFile )
                  QPM_ProjectFileUnLock()
                  QPM_MemoWrit( PUB_cProjectFile, cINI )
                  bWrite := .T.
                  QPM_ProjectFileLock( PUB_cProjectFile )
                  QPM_LogText( "Done" )
               ENDIF
               cPrj_VersionAnt := GetPrj_Version()
               PUB_bDebugActiveAnt := PUB_bDebugActive
            ENDIF
         ENDIF
      ENDIF
      IF ! bWrite
         IF ! ( cPrj_VersionAnt == GetPrj_Version() )
            QPM_LogText( "Replacing project version: file " + PUB_cProjectFile + " version " + MakePrj_Version() )
            QPM_ProjectFileUnLock()
            ReplacePrj_Version( PUB_cProjectFile, MakePrj_Version() )
            QPM_ProjectFileLock( PUB_cProjectFile )
            QPM_LogText( "Done" )
            cPrj_VersionAnt := GetPrj_Version()
            bWrite := .T.
         ENDIF
         IF ! ( PUB_bDebugActiveAnt == PUB_bDebugActive )
            QPM_LogText( "Replacing DEBUGATIVE: file " + PUB_cProjectFile + " value " + iif( PUB_bDebugActive, "YES", "NO" ) )
            QPM_ProjectFileUnLock()
            ReplaceMemoData( PUB_cProjectFile, 'DEBUGACTIVE', iif( PUB_bDebugActive, "YES", "NO" ) )
            QPM_ProjectFileLock( PUB_cProjectFile )
            QPM_LogText( "Done" )
            PUB_bDebugActiveAnt := PUB_bDebugActive
            bWrite := .T.
         ENDIF
      ENDIF
   ELSE
      QPM_LogText( "Writing project file " + PUB_cProjectFile )
      QPM_ProjectFileUnLock()
      QPM_MemoWrit( PUB_cProjectFile, cINI )
      QPM_ProjectFileLock( PUB_cProjectFile )
      QPM_LogText( "Done" )
      cPrj_VersionAnt := GetPrj_Version()
      PUB_bDebugActiveAnt := PUB_bDebugActive
      bWrite := .T.
   ENDIF

   IF bWrite .AND. Prj_Warn_InfoSaved
      IF MyMsgYesNo( "Project's information was saved." + CRLF + 'Omit this message from now on?' )
         Prj_Warn_InfoSaved := .F.
         QPM_LogText( "Replacing WARNINFOSAVEDMSG: file " + PUB_cProjectFile + " value NO" )
         QPM_ProjectFileUnLock()
         ReplaceMemoData( PUB_cProjectFile, 'WARNINFOSAVEDMSG', "NO" )
         QPM_ProjectFileLock( PUB_cProjectFile )
         QPM_LogText( "Done" )
         MyMsgInfo( 'Use ' + DBLQT + PUB_MenuResetWarnings + DBLQT + ' option of Settings menu to enable the previous message.' )
      ENDIF
   ENDIF
RETURN .T.

FUNCTION MakePrj_Version()
RETURN SubStr( GetPrj_Version(), 1, 2 ) + ' ' + SubStr( GetPrj_Version(), 3, 2 ) + ' ' + SubStr( GetPrj_Version(), 5, 4 )

FUNCTION CargoIncludeLibs()
   LOCAL i, Exists, cFile, k, cFlavor := GetSuffix()
   VentanaMain.GIncFiles.DeleteAllItems
   FOR i := 1 TO Len( &('IncludeLibs'+cFlavor) )
       cFile := US_FileNameOnlyNameAndExt( &('IncludeLibs'+cFlavor+'['+Str(i)+']') )
       Exists := .F.
       FOR k := 1 TO VentanaMain.GIncFiles.ItemCount
          IF US_Upper( cFile ) == US_Upper( GetProperty( 'VentanaMain', 'GIncFiles', 'Cell', k, NCOLEXCNAME ) )
             Exists := .T.
             EXIT
          ENDIF
       NEXT
       IF ! Exists
          VentanaMain.GIncFiles.AddItem( { PUB_nGridImgNone, cFile, '* ' + &('IncludeLibs'+cFlavor+'['+Str(i)+']') } )
          LibPos( VentanaMain.GIncFiles.ItemCount )
          IF AScan( &('vExtraFoldersForLibs'+GetSuffix()), US_Upper( US_FileNameOnlyPath( ChgPathToReal( US_WordSubStr( &('IncludeLibs'+cFlavor+'['+Str(i)+']'), 2 ) ) ) ) ) == 0
             AAdd( &('vExtraFoldersForLibs'+GetSuffix()), US_Upper( US_FileNameOnlyPath( ChgPathToReal( US_WordSubStr( &('IncludeLibs'+cFlavor+'['+Str(i)+']'), 2 ) ) ) ) )
          ENDIF
       ENDIF
   NEXT
   LibsActiva := cFlavor
   IF VentanaMain.GIncFiles.Value == 0
      VentanaMain.GIncFiles.Value := 1
   ENDIF
RETURN .T.

FUNCTION CargoExcludeLibs()
   LOCAL i, Exists, cFile, k, cFlavor := GetSuffix()
   VentanaMain.GExcFiles.DeleteAllItems
   FOR i := 1 TO Len( &('ExcludeLibs'+cFlavor) )
       cFile := &('ExcludeLibs'+cFlavor+'['+Str(i)+']')
       Exists := .F.
       FOR k := 1 TO VentanaMain.GExcFiles.ItemCount
          IF US_Upper( cFile ) == US_Upper( GetProperty( 'VentanaMain', 'GExcFiles', 'Cell', k, NCOLEXCNAME ) )
             Exists := .T.
             EXIT
          ENDIF
       NEXT
       IF ! Exists
          VentanaMain.GExcFiles.AddItem( { PUB_nGridImgNone, cFile } )
       ENDIF
   NEXT
   LibsActiva := cFlavor
   IF VentanaMain.GExcFiles.Value == 0
      VentanaMain.GExcFiles.Value := 1
   ENDIF
RETURN .T.

FUNCTION CargoDefaultLibs( cFlavor )
   LOCAL nCant, i
   IF ! Empty( GetMiniGuiName() )
      IF AScan( vLibsDefault, { |x| US_Upper( x[1] ) == US_Upper( GetMiniGuiName() ) } ) == 0
         AAdd( vLibsDefault, NIL )
         AIns( vLibsDefault, 1 )
         vLibsDefault[1] := { GetMiniGuiName(), "B", "B", "B" }
      ENDIF
   ENDIF
   nCant := Len( vLibsDefault )
   VentanaMain.GDefFiles.DeleteAllItems
   FOR i := 1 TO nCant
      VentanaMain.GDefFiles.AddItem( { PUB_nGridImgNone, vLibsDefault[i,1], vLibsDefault[i,2], vLibsDefault[i,3], vLibsDefault[i,4] } )
   NEXT i
   IF VentanaMain.GDefFiles.Value == 0
      VentanaMain.GDefFiles.Value := 1
   ENDIF
   LibsActiva := cFlavor
RETURN .T.

FUNCTION LibCheck( item )
   LOCAL estado
   IF File( ChgPathToReal( US_WordSubStr( GetProperty( 'VentanaMain', 'GIncFiles', 'Cell', item, NCOLINCFULLNAME ), 3 ) ) )
      estado := 'Ok'
      SetProperty( 'VentanaMain', 'GIncFiles', 'Cell', item, NCOLINCSTATUS, PUB_nGridImgNone )
   ELSE
      estado := 'Error'
      GridImage( 'VentanaMain', 'GIncFiles', item, NCOLINCSTATUS, '+', PUB_nGridImgEquis )
   ENDIF
   SetProperty( 'VentanaMain', 'GIncFiles', 'Cell', item, NCOLINCFULLNAME, estado + ' ' + US_WordSubStr( GetProperty( 'VentanaMain', 'GIncFiles', 'Cell', item, NCOLINCFULLNAME ), 2 ) )
RETURN estado

FUNCTION LibPos( item, pos )
   IF item > 0
      IF Empty( pos )
         pos := US_Word( GetProperty( 'VentanaMain', 'GIncFiles', 'Cell', item, NCOLINCFULLNAME ), 2 )
      ENDIF
      SetProperty( 'VentanaMain', 'GIncFiles', 'Cell', item, NCOLINCFULLNAME, LibCheck( item ) + ' ' + Pos + ' ' + US_WordSubStr( GetProperty( 'VentanaMain', 'GIncFiles', 'Cell', item, NCOLINCFULLNAME ), 3 ) )
   ENDIF
   VentanaMain.GIncFiles.setfocus
RETURN .T.

FUNCTION DescargoIncludeLibs( cFlavor )
   LOCAL aLibs, i
   aLibs := {}
   FOR i := 1 TO VentanaMain.GIncFiles.ItemCount
      AAdd( aLibs, US_Word( GetProperty( 'VentanaMain', 'GIncFiles', 'Cell', i, NCOLINCFULLNAME ), 2 ) + ' ' + US_WordSubStr( GetProperty( 'VentanaMain', 'GIncFiles', 'Cell', i, NCOLINCFULLNAME ), 3 ) )
   NEXT
   &('IncludeLibs'+cFlavor) := aLibs
   VentanaMain.RichEditLib.Value := ''
   VentanaMain.GIncFiles.Value := 0
RETURN .T.

FUNCTION DescargoExcludeLibs( cFlavor )
   LOCAL aLibs, i
   aLibs := {}
   FOR i := 1 TO VentanaMain.GExcFiles.ItemCount
      AAdd( aLibs, GetProperty( 'VentanaMain', 'GExcFiles', 'Cell', i, NCOLEXCNAME ) )
   NEXT
   &('ExcludeLibs'+cFlavor) := aLibs
RETURN .T.

FUNCTION DescargoDefaultLibs( cFlavor )
   LOCAL aLibs, n, m, t, d, i
   aLibs        := {}
   vLibsDefault := {}
   vLibsToLink  := {}
   FOR i := 1 TO VentanaMain.GDefFiles.ItemCount
      n := GetProperty( 'VentanaMain', 'GDefFiles', 'Cell', i, NCOLDEFNAME )
      m := GetProperty( 'VentanaMain', 'GDefFiles', 'Cell', i, NCOLDEFMODE )
      t := GetProperty( 'VentanaMain', 'GDefFiles', 'Cell', i, NCOLDEFTHREADS )
      d := GetProperty( 'VentanaMain', 'GDefFiles', 'Cell', i, NCOLDEFDEBUG )
      AAdd( aLibs, { n, m, t, d } )
      AAdd( vLibsDefault, { n, m, t, d } )
      IF ( Prj_Check_Console .AND. m $ "CB" ) .OR. ( ! Prj_Check_Console .AND. m $ "GB" )
         IF ( Prj_Check_MT .AND. t $ "MB" ) .OR. ( ! Prj_Check_MT .AND. t $ "SB" )
            IF ( PUB_bDebugActive .AND. d $ "YB" ) .OR. ( ! PUB_bDebugActive .AND. d $ "NB" )
               AAdd( vLibsToLink, n )
            ENDIF
         ENDIF
      ENDIF
   NEXT
   &('Gbl_DEF_LIBS_'+cFlavor) := aLibs
   VentanaMain.RichEditLib.Value := ''
RETURN .T.

FUNCTION QPM_SaveAsProject( isNew )
   LOCAL TmpName
   IF Empty( PUB_cProjectFile ) .AND. Empty( isNew )
      MyMsgStop( 'No project is open!' )
      RETURN ''
   ENDIF
   TmpName := AllTrim ( PutFile( { {'QPM Project Files (*.qpm)','*.qpm'} }, iif( ! Empty( isNew ) .AND. isNew, 'Create New Project', 'Save Project' ), cLastProjectFolder, .T. ) )
   IF ! Empty( TmpName )
      IF ! ( Upper( US_FileNameOnlyExt(Tmpname) ) == 'QPM' )
         TmpName := TmpName + '.qpm'
      ENDIF
      PUB_cProjectFile := TmpName
      IF ! Empty( isNew ) .AND. isNew
         VentanaMain.TProjectFolder.Value := US_FileNameOnlyPath( TmpName )
      ENDIF
      PUB_cThisFolder := US_FileNameOnlyPath( PUB_cProjectFile )
      VentanaMain.Title := 'QPM (QAC based Project Manager) - Project Manager For MiniGui (' + QPM_VERSION_DISPLAY_LONG + ') [ ' + AllTrim ( PUB_cProjectFile ) + ' ]'
      QPM_SaveProject()
      cLastProjectFolder := US_FileNameOnlyPath( TmpName )
   ENDIF
RETURN TmpName

FUNCTION QPM_EXIT( bWait )
   LOCAL r
   IF ! hb_IsLogical( bWait )
      bWait := .F.
   ENDIF
   IF bWait .AND. BUILD_IN_PROGRESS
      RETURN .F.
   ENDIF
   IF bWaitForBuild
      DO WHILE BUILD_IN_PROGRESS
         DO EVENTS
      ENDDO
   ENDIF
#ifdef QPM_SHG
   IF QPM_Wait( 'SHG_CheckSave()', 'Checking changes in Hlp Topics ...' )
      IF SHG_BaseOk
         IF US_FileSize( US_FileNameOnlyPathAndName( SHG_Database ) + '.dbt' ) > SHG_DbSize
            QPM_Wait( 'SHG_PackDatabase()' )
         ENDIF
      ENDIF
      IF ! PUB_bLite .AND. ! bWaitForBuild .AND. ( ! Empty( PUB_cProjectFile ) .OR. ! Empty( PUB_cProjectFolder ) )
         r := MyMsgYesNo( 'Are you sure?', 'EXIT QPM' )
      ELSE
         r := .T.
      ENDIF
   ELSE
      r := .F.
   ENDIF
#else
   r := .T.
#endif
   IF r == .T.
      QPM_Wait( 'QPM_SaveProject( .T. )', 'Checking for save ...' )
      CloseDbfAutoView()
      DoMethod( 'VentanaMain', 'Release' )
   ENDIF
   QPM_ProjectFileUnLock()
   IF bAutoEXIT .AND. ! Empty( PUB_cAutoLog )
      PUB_cAutoLogTmp := MemoRead( PUB_cAutoLog )
      PUB_cAutoLogTmp += CRLF
      PUB_cAutoLogTmp += Replicate( '=', 80 )
      PUB_cAutoLogTmp += CRLF
      QPM_LogText( "Saving Autolog" )
      QPM_MemoWrit( PUB_cAutoLog, PUB_cAutoLogTmp )
      QPM_LogText( "Done" )
   ENDIF
RETURN .F.

FUNCTION QPM_Build()
RETURN QPM_Wait( 'QPM_Build2()', 'Preparing for build ...' )

FUNCTION QPM_Build2()
   LOCAL aNulRDD
   LOCAL bExtraFolderSearchRoot
   LOCAL bIsCpp := .F.
   LOCAL bld_cmd
   LOCAL cAux
   LOCAL cB_CPP_BIN
   LOCAL cB_DLLTOOL
   LOCAL cB_DLL_ERR
   LOCAL cB_EXE
   LOCAL cB_FILLER
   LOCAL cB_OUTPUT
   LOCAL cB_RC1_PTH
   LOCAL cB_RC1_SHR
   LOCAL cB_RC1_FER
   LOCAL cB_RC2_SHR
   LOCAL cB_RC2_FER
   LOCAL cB_RCC_ERR
   LOCAL cB_RCF_ERR
   LOCAL cB_RCM_ERR
   LOCAL cB_RC_COMP
   LOCAL cB_RC_CONF
   LOCAL cB_RC_FOLD
   LOCAL cB_RC_HBPR
   LOCAL cB_RC_MAIN
   LOCAL cB_RC_MA_S
   LOCAL cB_RC_MINI
   LOCAL cB_RC_MIPR
   LOCAL cB_TMP_ERR
   LOCAL cB_US_MAKE
   LOCAL cB_US_RES
   LOCAL cDebugPath := ''
   LOCAL cExtraFoldersC := ''
   LOCAL cExtraFoldersHB := ''
   LOCAL cInputName := ''
   LOCAL cInputNameDisplay := ''
   LOCAL cInputNameLong := ''
   LOCAL cInputReImpDef := ''
   LOCAL cInputReImpName := ''
   LOCAL cInputReImpNameDisplay := ''
   LOCAL cOldFolder := GetCurrentFolder()
   LOCAL cOutputName
   LOCAL cOutputNameDisplay
   LOCAL cRCFileName
   LOCAL HeaFILES := {}
   LOCAL i
   LOCAL lIncludeMiniPrintRC
   LOCAL lCont
   LOCAL MemoAux
   LOCAL MemoObj
   LOCAL nCant
   LOCAL nLastExtraFolderSearchAdded := 0
   LOCAL OBJFOLDER
   LOCAL Out
   LOCAL PanFILES := {}
   LOCAL PRGFILES := {}
   LOCAL vConcatIncludeC := {}
   LOCAL vConcatIncludeHB := {}
   LOCAL vDebugPath := {}
   LOCAL vLibExcludeFiles := {}
   LOCAL vLibIncludeFiles
   LOCAL vTemp
   LOCAL vTemp2
   LOCAL vTemp3
   LOCAL w_group
   LOCAL w_hay
   LOCAL w_LibFolders

   BUILD_IN_PROGRESS := .T.

   IF Empty( PUB_cProjectFile )
      MyMsgStop( 'You must save the project before building it!' )
      BUILD_IN_PROGRESS := .F.
      RETURN .T.
   ENDIF

   PUB_cConvert := ''
   PUB_bForceRunFromMsgOk := .F.

   IF bRunApp
      MyMsgStop( 'Program is running!' + CRLF + 'You need to stop or kill the process before building it.' )
      BUILD_IN_PROGRESS := .F.
      RETURN .F.
   ENDIF

   Q_SCRIPT_FILE  := AddDBLQT( SCRIPT_FILE )
   Q_TEMP_LOG     := AddDBLQT( TEMP_LOG )
   Q_END_FILE     := AddDBLQT( END_FILE )
   Q_MAKE_FILE    := AddDBLQT( MAKE_FILE )
   Q_PROGRESS_LOG := AddDBLQT( PROGRESS_LOG )
   Q_QPM_TMP_RC   := AddDBLQT( QPM_TMP_RC )

   VentanaMain.TabFiles.Value := nPageSysout
   TabChange( 'FILES' )

   vTemp := Array( ADIR( PUB_cProjectFolder + DEF_SLASH + '_'+replicate('?',13)+PUB_cCharFileNameTemp+'*.*' ) )
   vTemp2 := Array( ADIR( GetCppFolder() + DEF_SLASH + 'BIN' + DEF_SLASH + '_'+replicate('?',13)+PUB_cCharFileNameTemp+'*.*' ) )
   vTemp3 := Array( ADIR( SubStr( GetCppFolder(), 1, 2 ) + DEF_SLASH + '_'+replicate('?',13)+PUB_cCharFileNameTemp+'*.*' ) )
   ADir( PUB_cProjectFolder + DEF_SLASH + '_'+replicate('?',13)+PUB_cCharFileNameTemp+'*.*', vTemp )
   ADir( GetCppFolder() + DEF_SLASH + 'BIN' + DEF_SLASH + '_'+replicate('?',13)+PUB_cCharFileNameTemp+'*.*', vTemp2 )
   ADir( SubStr( GetCppFolder(), 1, 2 ) + DEF_SLASH + '_'+replicate('?',13)+PUB_cCharFileNameTemp+'*.*', vTemp3 )
   FOR i := 1 TO Len( vTemp )
      vTemp[i] := PUB_cProjectFolder + DEF_SLASH + vTemp[i]
   NEXT
   FOR i := 1 TO Len( vTemp2 )
      AAdd( vTemp, GetCppFolder() + DEF_SLASH + 'BIN' + DEF_SLASH + vTemp2[i] )
   NEXT
   FOR i := 1 TO Len( vTemp3 )
      AAdd( vTemp, SubStr( GetCppFolder(), 1, 2 ) + DEF_SLASH + vTemp3[i] )
   NEXT
   FOR i := 1 TO Len( vTemp )
      IF Val( SubStr( US_FileNameOnlyName( vTemp[i] ), 2, 13 ) ) < ( Val( SubStr( PUB_cSecu, 1, 13 ) ) - 100000 )
         FErase( vTemp[i] )
      ENDIF
   NEXT

   IF Prj_Radio_OutputType == DEF_RG_IMPORT
      PUB_cConvert := Upper( US_FileNameOnlyExt( ChgPathToReal( GetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', 1, NCOLPRGFULLNAME ) ) ) ) + ' ' + OutputExt()
      cInputName := US_ShortName( ChgPathToReal( GetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', 1, NCOLPRGFULLNAME ) ) )
      cInputNameDisplay := ChgPathToReal( GetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', 1, NCOLPRGFULLNAME ) )
      cInputNameLong := US_FileNameOnlyPath( cInputName ) + DEF_SLASH + US_FileNameOnlyNameAndExt( cInputNameDisplay )
      IF GetProperty( 'VentanaMain', 'Check_Reimp', 'Value' )
         IF ! File( ChgPathToReal( GetProperty( 'VentanaMain', 'TReimportLib', 'Value' ) ) )
            MyMsgStop( 'Library for ReImport was not found!' + CRLF + ChgPathToReal( GetProperty( 'VentanaMain', 'TReimportLib', 'Value' ) ) )
            BUILD_IN_PROGRESS := .F.
            RETURN .F.
         ENDIF
         cInputReImpNameDisplay := ChgPathToReal( GetProperty( 'VentanaMain', 'TReimportLib', 'Value' ) )
         cInputReImpName := US_ShortName( cInputReImpNameDisplay )
         cInputReImpDef := PUB_cQPM_Folder + DEF_SLASH + US_FileNameOnlyName( GetProperty( 'VentanaMain', 'TReimportLib', 'Value' ) ) + '.def'
      ENDIF
   ENDIF

   IF OutputExt() == 'LIB' .AND. At( '-', US_ShortName( PUB_cProjectFolder ) ) > 0
      MyMsgStop( "Utility TLIB.EXE doesn't work properly when a file's path contains hyphens [-]." + CRLF + "Please, change the name of the project's folder." )
      BUILD_IN_PROGRESS := .F.
      RETURN .F.
   ENDIF

   IF At( '(', US_ShortName( PUB_cProjectFolder ) ) > 0 .OR. At( ')', US_ShortName( PUB_cProjectFolder ) ) > 0
      MyMsgStop( "Utility US_MAKE.EXE doesn't work properly when a file's path contains parentheses [()] characters." + CRLF + "Please, change the name of the project's folder." )
      BUILD_IN_PROGRESS := .F.
      RETURN .F.
   ENDIF

   DO EVENTS

   QPM_LogText( PadR( '*****  BUILD START: ' + US_VarToStr( Date() ) + ' ' + US_VarToStr( Time() ) + '  ', 100, '*' ) + CRLF + ;
                CRLF + ;
                "Content of " + cProjectFileName )
   QPM_LogText( ( i := MemoRead( cProjectFileName ) ) + iif( Right( i, 2 ) == CRLF, "", CRLF ) + "Done" + CRLF )

   PUB_xHarbourMT := ''
   DO CASE
      CASE GetCppSuffix() == DefineMinGW
         IsBorland := .F.
         IsMinGW   := .T.
         IsPelles  := .F.
      CASE GetCppSuffix() == DefinePelles
         IsBorland := .F.
         IsMinGW   := .F.
         IsPelles  := .T.
      CASE GetCppSuffix() == DefineBorland
         IsBorland := .T.
         IsMinGW   := .F.
         IsPelles  := .F.
      OTHERWISE
         US_Log( 'Error 5288' )
   ENDCASE

   cRCFileName := Get_RC_FileName()

   DO CASE
      CASE Prj_Radio_OutputRename == DEF_RG_NEWNAME .AND. Empty( Prj_Text_OutputRenameNewName )
         MyMsgStop( 'Filename for Output Rename operation is empty!' + CRLF + 'Look at ' + PUB_MenuPrjOptions + ' of Settings menu.' )
         BUILD_IN_PROGRESS := .F.
         RETURN .F.
      CASE Prj_Radio_OutputCopyMove # DEF_RG_NONE .AND. Empty( Prj_Text_OutputCopyMoveFolder )
         MyMsgStop( 'Folder for Output Copy/Move operation is empty!' + CRLF + 'Look at ' + PUB_MenuPrjOptions + ' of Settings menu.' )
         BUILD_IN_PROGRESS := .F.
         RETURN .F.
      CASE Prj_Radio_OutputCopyMove # DEF_RG_NONE .AND. ! US_IsDirectory( Prj_Text_OutputCopyMoveFolder )
         MyMsgStop( 'Folder for Output Copy/Move operation is not valid!' + CRLF + 'Look at ' + PUB_MenuPrjOptions + ' of Settings menu.' )
         BUILD_IN_PROGRESS := .F.
         RETURN .F.
      CASE Empty( PUB_cProjectFolder ) .OR. ! US_IsDirectory( PUB_cProjectFolder )
         MyMsgStop( "Project folder " + DBLQT + PUB_cProjectFolder + DBLQT + " is not a valid!" + CRLF + 'Look at tab ' + DBLQT + PagePRG + DBLQT + "." )
         BUILD_IN_PROGRESS := .F.
         RETURN .F.
      CASE Empty( GetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', 1, NCOLPRGFULLNAME ) )
         MyMsgStop( 'PRG list is empty!' + CRLF + 'Look at tab ' + DBLQT + PagePRG + DBLQT + "." )
         BUILD_IN_PROGRESS := .F.
         RETURN .F.
      CASE Empty( GetMiniGuiFolder() )
         MyMsgStop( 'Folder for Minigui in ' + vSuffix[ AScan( vSuffix, { |x| x[1] == GetSuffix() } ) ][2] + ' is empty!' + CRLF + 'Look at ' + PUB_MenuGblOptions + ' of Settings menu.' )
         BUILD_IN_PROGRESS := .F.
         RETURN .F.
      CASE Empty( GetMiniGuiName() )
         MyMsgStop( 'Lib Name for Minigui in ' + vSuffix[ AScan( vSuffix, { |x| x[1] == GetSuffix() } ) ][2] + ' is empty!' + CRLF + 'Look at ' + PUB_MenuGblOptions + ' of Settings menu.' )
         BUILD_IN_PROGRESS := .F.
         RETURN .F.
      CASE Empty( GetCppFolder() )
         MyMsgStop( 'Folder for C++ Compiler in ' + vSuffix[ AScan( vSuffix, { |x| x[1] == GetSuffix() } ) ][2] + ' is empty!' + CRLF + 'Look at ' + PUB_MenuGblOptions + ' of Settings menu.' )
         BUILD_IN_PROGRESS := .F.
         RETURN .F.
      CASE ! QPM_IsXHarbour() .AND. Empty( GetHarbourFolder() )
         MyMsgStop( 'Folder for Harbour in ' + vSuffix[ AScan( vSuffix, { |x| x[1] == GetSuffix() } ) ][2] + ' is empty!' + CRLF + 'Look at ' + PUB_MenuGblOptions + ' of Settings menu.' )
         BUILD_IN_PROGRESS := .F.
         RETURN .F.
      CASE QPM_IsXHarbour() .AND. Empty( GetHarbourFolder() )
         MyMsgStop( 'Folder for xHarbour in ' + vSuffix[ AScan( vSuffix, { |x| x[1] == GetSuffix() } ) ][2] + ' is empty!' + CRLF + 'Look at ' + PUB_MenuGblOptions + ' of Settings menu.' )
         BUILD_IN_PROGRESS := .F.
         RETURN .F.
      CASE ! QPM_DirValid( US_ShortName( GetMiniGuiFolder() ), US_ShortName( GetMiniGuiLibFolder() ), GetMiniGuiSuffix() + GetCppSuffix() )
         MyMsgStop( 'Minigui folder is not valid!' + CRLF + 'Look at ' + PUB_MenuGblOptions + ' of Settings menu.' )
         BUILD_IN_PROGRESS := .F.
         RETURN .F.
      CASE ! Empty( GetCppFolder() ) .AND. ! QPM_DirValid( US_ShortName( GetCppFolder() ), US_ShortName( GetCppLibFolder() ), 'C_' + GetMiniGuiSuffix() + GetCppSuffix() )
         MyMsgStop( 'C++ Compiler folder is not valid!' + CRLF + 'Look at ' + PUB_MenuGblOptions + ' of Settings menu.' )
         BUILD_IN_PROGRESS := .F.
         RETURN .F.
      CASE ! Empty(  GetHarbourFolder() ) .AND. !QPM_IsXHarbour() .AND. !QPM_DirValid( US_ShortName( GetHarbourFolder() ), US_ShortName( GetHarbourLibFolder() ), GetSuffix() )
         MyMsgStop( 'Harbour folder is not valid!' + CRLF + 'Look at ' + PUB_MenuGblOptions + ' of Settings menu.' )
         BUILD_IN_PROGRESS := .F.
         RETURN .F.
      CASE ! Empty(  GetHarbourFolder() ) .AND. QPM_IsXHarbour() .AND. !QPM_DirValid( US_ShortName( GetHarbourFolder() ), US_ShortName( GetHarbourLibFolder() ), GetSuffix() )
         MyMsgStop( 'xHarbour folder is not valid!' + CRLF + 'Look at ' + PUB_MenuGblOptions + ' of Settings menu.' )
         BUILD_IN_PROGRESS := .F.
         RETURN .F.
   ENDCASE

   FOR i := 1 TO VentanaMain.GPrgFiles.ItemCount
      IF Upper( US_FileNameOnlyExt( ChgPathToReal( GetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', i, NCOLPRGFULLNAME ) ) ) ) == 'CPP'
         bIsCpp := .T.
      ENDIF
      IF AScan( PRGFILES, { |x| US_Upper( US_FileNameOnlyName( x ) ) == US_Upper( US_FileNameOnlyName( AllTrim( GetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', i, NCOLPRGFULLNAME )) ) ) } ) > 0
         MyMsgStop( "Two project's files, in diferent folders o with diferent extensions (.PRG and .C), have the same name: " + ;
                    DBLQT + US_FileNameOnlyName( AllTrim( GetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', i, NCOLPRGFULLNAME ) ) ) + DBLQT + "." + CRLF + ;
                    'The object generated from the second file in the list will override the object of the first one!' )
         BUILD_IN_PROGRESS := .F.
         RETURN .F.
      ENDIF
      AAdd( PRGFILES, ChgPathToReal( GetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', i, NCOLPRGFULLNAME ) ) )

      IF ! File( PRGFILES[ i ] )
         MyMsgStop( "File " + DBLQT + PRGFILES[ i ] + DBLQT + " was not found!" )
         BUILD_IN_PROGRESS := .F.
         RETURN .F.
      ENDIF

      IF PUB_bDebugActive
         IF AScan( vDebugPath, { |x| US_Upper( x ) == US_Upper( AllTrim( US_FileNameOnlyPath( PRGFILES[ i ] ) ) ) } ) == 0
            AAdd( vDebugPath, AllTrim( US_FileNameOnlyPath( PRGFILES[ i ] ) ) )
         ENDIF
      ENDIF
   NEXT i

   DO EVENTS

   // This handles the lack of a default GT in HMG 3.x
   IF IsMinGW .AND. GetMiniGuiSuffix() == DefineMiniGui3 .AND. Prj_Radio_OutputType != DEF_RG_IMPORT
      IF Prj_Check_Console
         QPM_LogText( "QPM_GT_WIN" )
         QPM_Memowrit( QPM_GET_DEF, 'ANNOUNCE GT_SYS' + CRLF + 'REQUEST HB_GT_WIN_DEFAULT' + CRLF )
         IF File( QPM_GET_DEF )
            QPM_LogFile( QPM_GET_DEF )
            AAdd( PRGFILES, QPM_GET_DEF )
         ELSE
            QPM_LogText( "Not done" )
            MyMsgWarn( "QPM can't add QPM_GT.PRG auxiliary file to your project." + CRLF + ;
                       "In order for your app to work properly, you may need to add " + CRLF + ;
                       DBLQT + "REQUEST HB_GT_WIN_DEFAULT" + DBLQT + " before Main()." )
         ENDIF
      ELSE
         QPM_LogText( "QPM_GT_GUI" )
         QPM_Memowrit( QPM_GET_DEF, 'ANNOUNCE GT_SYS' + CRLF + 'REQUEST HB_GT_GUI_DEFAULT' + CRLF )
         IF File( QPM_GET_DEF )
            QPM_LogFile( QPM_GET_DEF )
            AAdd( PRGFILES, QPM_GET_DEF )
         ELSE
            QPM_LogText( "Not done" )
            MyMsgWarn( "QPM can't add QPM_GT.PRG auxiliary file to your project." + CRLF + ;
                       "In order for your app to work properly, you may need to add " + CRLF + ;
                       DBLQT + "REQUEST HB_GT_GUI_DEFAULT" + DBLQT + " before Main()." )
         ENDIF
      ENDIF
   ENDIF

   IF PUB_bDebugActive
      AEval( vDebugPath, { |x| cDebugPath := cDebugPath + x + ';' } )
      cDebugPath := cDebugPath + DEF_SLASH
   ENDIF

   IF ! bAutoEXIT
      IF bIsCpp .AND. GetCppSuffix() == DefinePelles
         MyMsgStop( 'Your project includes C++ files and Pelles C does not support them.' )
         BUILD_IN_PROGRESS := .F.
         RETURN .F.
      ENDIF
      IF bIsCpp .AND. Prj_Warn_Cpp .AND. GetCppSuffix() == DefineMinGW
         IF MyMsgYesNo( 'The project includes C++ files.' + CRLF + ;
                        'You must use a full version of MinGW in order to successfully build it.' + CRLF + ;
                        'Omit this message from now on?' )
            Prj_Warn_Cpp := .F.
            MyMsgInfo( 'Use ' + DBLQT + PUB_MenuResetWarnings + DBLQT + ' option of Settings menu to enable the previous message.' )
         ENDIF
      ENDIF
   ENDIF

   DO EVENTS

   FOR i := 1 TO VentanaMain.GPanFiles.ItemCount
      IF AScan( PanFILES, { |x| US_Upper( US_FileNameOnlyNameAndExt( x ) ) == US_Upper( US_FileNameOnlyNameAndExt( AllTrim(GetProperty( 'VentanaMain', 'GPanFiles', 'Cell', i, NCOLPANFULLNAME )) ) ) } ) > 0
         MyMsgStop( "Duplicate form name '"+US_FileNameOnlyNameAndExt( AllTrim( GetProperty( 'VentanaMain', 'GPanFiles', 'Cell', i, NCOLPANFULLNAME ) ) ) + "' in diferents directories" + CRLF + 'Process canceled.' )
         BUILD_IN_PROGRESS := .F.
         RETURN .F.
      ENDIF
      AAdd( PANFILES, ChgPathToReal( GetProperty( 'VentanaMain', 'GPanFiles', 'Cell', i, NCOLPANFULLNAME ) ) )
      IF ! File( PanFILES[ i ] )
         MyMsgStop( 'Form "' + PanFILES[ i ] + '" was not found!' )
         BUILD_IN_PROGRESS := .F.
         RETURN .F.
      ENDIF
   NEXT i

   DO EVENTS

   FOR i := 1 TO VentanaMain.GHeaFiles.ItemCount
      IF AScan( HeaFILES, { |x| US_Upper( US_FileNameOnlyNameAndExt( x ) ) == US_Upper( US_FileNameOnlyNameAndExt( AllTrim(GetProperty( 'VentanaMain', 'GHeaFiles', 'Cell', i, NCOLHEAFULLNAME )) ) ) } ) > 0
         MyMsgStop( 'Duplicate header name "' + US_FileNameOnlyNameAndExt( AllTrim( GetProperty( 'VentanaMain', 'GHeaFiles', 'Cell', i, NCOLHEAFULLNAME ) ) ) + '" in diferents directories.' + CRLF + 'Process canceled!' )
         BUILD_IN_PROGRESS := .F.
         RETURN .F.
      ENDIF
      AAdd( HeaFILES, ChgPathToReal( GetProperty( 'VentanaMain', 'GHeaFiles', 'Cell', i, NCOLHEAFULLNAME ) ) )
      IF ! File( HeaFILES[ i ] )
         MyMsgStop( 'File "' + HeaFILES[ i ] + '" was not found!' )
         BUILD_IN_PROGRESS := .F.
         RETURN .F.
      ENDIF
   NEXT i

   DO EVENTS

   CheckRelativeOrderOfLibsGT()

   // Load vLibsToLink with default libs, objs and res (no path)
   DescargoDefaultLibs( GetSuffix() )
   // Load and check include libs (with path)
   vLibIncludeFiles := {}
   FOR i := 1 TO VentanaMain.GIncFiles.ItemCount
      LibCheck( i )
      vTemp := US_Upper( ChgPathToReal( US_WordSubStr( GetProperty( 'VentanaMain', 'GIncFiles', 'Cell', i, NCOLINCFULLNAME ), 3 ) ) )
      AAdd( vLibIncludeFiles, vTemp )
      IF ! File( vTemp )
         MyMsgStop( "File " + DBLQT + vTemp + DBLQT + " not found!" )
         BUILD_IN_PROGRESS := .F.
         RETURN .F.
      ENDIF
   NEXT i
   // Load exclude libs (no path)
   FOR i := 1 TO VentanaMain.GExcFiles.ItemCount
      AAdd( vLibExcludeFiles, US_Upper( AllTrim( GetProperty( 'VentanaMain', 'GExcFiles', 'Cell', i, NCOLEXCNAME ) ) ) )
   NEXT i

   DO EVENTS

   IF IsBorland .AND. Prj_Radio_OutputType == DEF_RG_EXE
      IF Prj_Check_Console
         IF ( AScan( vLibsToLink, { |x| US_Upper( x ) == "C0X32.OBJ" } ) == 0 .AND. ;
              AScan( vLibIncludeFiles, { |x| US_Upper( US_FileNameOnlyNameAndExt( x ) ) == "C0X32.OBJ" } ) == 0 )
            IF Prj_Warn_BccObject
               lCont := MyMsgYesNo( 'File [C0X32.OBJ] is not in the list of libraries to link.' + CRLF + ;
                                    'This file is usually present in CONSOLE projects.' + CRLF + ;
                                    'Select [Yes] to continue without it or [No] to cancel the build.' )
               IF MyMsgYesNo( 'Omit the previous validation from now on?' + CRLF + iif( lCont, "[Yes] will be assumed!", "[No] will be assumed!" ) )
                  Prj_Warn_BccObject := .F.
                  Prj_Warn_BccObject_Cont := lCont
                  MyMsgInfo( 'Use ' + DBLQT + PUB_MenuResetWarnings + DBLQT + ' option of Settings menu to enable the previous check.' )
               ELSE
                  Prj_Warn_BccObject := .T.
               ENDIF
            ELSE
               lCont := Prj_Warn_BccObject_Cont
            ENDIF
            IF ! lCont
               BUILD_IN_PROGRESS := .F.
               RETURN .F.
            ENDIF
         ELSEIF AScan( vLibExcludeFiles, { |x| US_Upper( x ) == "C0X32.OBJ" } ) # 0
            IF Prj_Warn_BccObject
               lCont := MyMsgYesNo( 'File [C0X32.OBJ] is not in the list of libraries to link.' + CRLF + ;
                                    'This file is usually present in CONSOLE projects.' + CRLF + ;
                                    'Select [Yes] to continue without it or [No] to cancel the build.' )
               IF MyMsgYesNo( 'Omit the previous validation from now on?' + CRLF + iif( lCont, "[Yes] will be assumed!", "[No] will be assumed!" ) )
                  Prj_Warn_BccObject := .F.
                  Prj_Warn_BccObject_Cont := lCont
                  MyMsgInfo( 'Use ' + DBLQT + PUB_MenuResetWarnings + DBLQT + ' option of Settings menu to enable the previous check.' )
               ELSE
                  Prj_Warn_BccObject := .T.
               ENDIF
            ELSE
               lCont := Prj_Warn_BccObject_Cont
            ENDIF
            IF ! lCont
               BUILD_IN_PROGRESS := .F.
               RETURN .F.
            ENDIF
         ENDIF
      ELSE
         IF ( AScan( vLibsToLink, { |x| US_Upper( x ) == "C0W32.OBJ" } ) == 0 .AND. ;
              AScan( vLibIncludeFiles, { |x| US_Upper( US_FileNameOnlyNameAndExt( x ) ) == "C0W32.OBJ" } ) == 0 )
            IF Prj_Warn_BccObject
               lCont := MyMsgYesNo( 'File [C0W32.OBJ] is not in the list of libraries to link.' + CRLF + ;
                                    'This file is usually present in GUI projects.' + CRLF + ;
                                    'Select [Yes] to continue without it or [No] to cancel the build.' )
               IF MyMsgYesNo( 'Omit the previous validation from now on?' + CRLF + iif( lCont, "[Yes] will be assumed!", "[No] will be assumed!" ) )
                  Prj_Warn_BccObject := .F.
                  Prj_Warn_BccObject_Cont := lCont
                  MyMsgInfo( 'Use ' + DBLQT + PUB_MenuResetWarnings + DBLQT + ' option of Settings menu to enable the previous check.' )
               ELSE
                  Prj_Warn_BccObject := .T.
               ENDIF
            ELSE
               lCont := Prj_Warn_BccObject_Cont
            ENDIF
            IF ! lCont
               BUILD_IN_PROGRESS := .F.
               RETURN .F.
            ENDIF
         ELSEIF AScan( vLibExcludeFiles, { |x| US_Upper( x ) == "C0W32.OBJ" } ) # 0
            IF Prj_Warn_BccObject
               lCont := MyMsgYesNo( 'File [C0W32.OBJ] is not in the list of libraries to link.' + CRLF + ;
                                    'This file is usually present in GUI projects.' + CRLF + ;
                                    'Select [Yes] to continue without it or [No] to cancel the build.' )
               IF MyMsgYesNo( 'Omit the previous validation from now on?' + CRLF + iif( lCont, "[Yes] will be assumed!", "[No] will be assumed!" ) )
                  Prj_Warn_BccObject := .F.
                  Prj_Warn_BccObject_Cont := lCont
                  MyMsgInfo( 'Use ' + DBLQT + PUB_MenuResetWarnings + DBLQT + ' option of Settings menu to enable the previous check.' )
               ELSE
                  Prj_Warn_BccObject := .T.
               ENDIF
            ELSE
               lCont := Prj_Warn_BccObject_Cont
            ENDIF
            IF ! lCont
               BUILD_IN_PROGRESS := .F.
               RETURN .F.
            ENDIF
         ENDIF
      ENDIF
   ENDIF

   aNulRDD := { 'NULSYS.LIB', 'LIBNULSYS.A', 'HBNULRDD.LIB', 'LIBHBNULRDD.A' }
   i := AScan( vLibsToLink, { |x| AScan( aNulRDD, US_Upper( x ) ) # 0 } )
   IF i == 0
      i := AScan( vLibIncludeFiles, { |x| AScan( aNulRDD, US_Upper( US_FileNameOnlyNameAndExt( x ) ) ) # 0 } )
   ENDIF
   IF i # 0 .AND. Prj_Warn_NullRDD
      IF AScan( vLibExcludeFiles, { |x| US_Upper( x ) == US_Upper( vLibsToLink[ i ] ) } ) == 0
         IF ! MyMsgYesNo( 'File ' + DBLQT + aNulRDD[i] + DBLQT + ' is in the list of libraries to link.' + CRLF + ;
                          'This file will prevent your project to access any file via RDD system.' + CRLF + ;
                          'Select [Yes] to continue or [No] to cancel the build.' )
            BUILD_IN_PROGRESS := .F.
            RETURN .F.
         ENDIF
         IF MyMsgYesNo( 'Omit the previous validation from now on?' )
            Prj_Warn_NullRDD := .F.
            MyMsgInfo( 'Use ' + DBLQT + PUB_MenuResetWarnings + DBLQT + ' option of Settings menu to enable the previous message.' )
         ENDIF
      ENDIF
   ENDIF

   AAdd( vConcatIncludeHB, US_ShortName( GetHarbourFolder() ) + DEF_SLASH + 'INCLUDE' )
   AAdd( vConcatIncludeHB, US_ShortName( GetMiniGuiFolder() ) + DEF_SLASH + 'INCLUDE' )
   AAdd( vConcatIncludeHB, US_ShortName( PUB_cProjectFolder ) )

   AAdd( vConcatIncludeC, US_ShortName( GetCppFolder() ) + DEF_SLASH + 'INCLUDE' )
   IF IsMinGW
      AAdd( vConcatIncludeC, GetCppLibFolder() + DEF_SLASH + ".." + DEF_SLASH + 'INCLUDE' )
   ENDIF
   IF IsPelles
      AAdd( vConcatIncludeC, US_ShortName( GetCppFolder() ) + DEF_SLASH + 'INCLUDE' + DEF_SLASH +'WIN' )
   ENDIF
   AAdd( vConcatIncludeC, US_ShortName( GetHarbourFolder() ) + DEF_SLASH + 'INCLUDE' )
   AAdd( vConcatIncludeC, US_ShortName( GetMiniGuiFolder() ) + DEF_SLASH + 'INCLUDE' )
   AAdd( vConcatIncludeC, US_ShortName( PUB_cProjectFolder ) )

   FOR i := 1 TO Len( vConcatIncludeHB )
      IF ! Empty( vConcatIncludeHB[ i ] )
         IF US_IsRootFolder( vConcatIncludeHB[ i ] )
            bExtraFolderSearchRoot := .T.
         ELSE
            bExtraFolderSearchRoot := .F.
         ENDIF
         DO CASE
         CASE IsMinGW
            cExtraFoldersHB := cExtraFoldersHB + ';' + vConcatIncludeHB[i] + iif( bExtraFolderSearchRoot, DEF_SLASH, '' )
         CASE IsPelles
            cExtraFoldersHB := cExtraFoldersHB + ';' + vConcatIncludeHB[i] + iif( bExtraFolderSearchRoot, DEF_SLASH, '' )
         CASE IsBorland
            cExtraFoldersHB := cExtraFoldersHB + ';' + vConcatIncludeHB[i] + iif( bExtraFolderSearchRoot, DEF_SLASH, '' )
         OTHERWISE
            US_Log( 'Error 5443')
         ENDCASE
      ENDIF
   NEXT i

   DO EVENTS

   FOR i := 1 TO Len( vConcatIncludeC )
      IF ! Empty( vConcatIncludeC[i] )
         IF US_IsRootFolder( vConcatIncludeC[i] )
            bExtraFolderSearchRoot := .T.
         ELSE
            bExtraFolderSearchRoot := .F.
         ENDIF
         DO CASE
         CASE IsMinGW
            cExtraFoldersC := cExtraFoldersC + ' -I ' + vConcatIncludeC[i] + iif( bExtraFolderSearchRoot, DEF_SLASH, '' )
         CASE IsPelles
            cExtraFoldersC := cExtraFoldersC + ' /I' + vConcatIncludeC[i] + iif( bExtraFolderSearchRoot, DEF_SLASH, '' )
         CASE IsBorland
            cExtraFoldersC := cExtraFoldersC + ';' + vConcatIncludeC[i] + iif( bExtraFolderSearchRoot, DEF_SLASH, '' )
         OTHERWISE
            US_Log( 'Error 5444')
         ENDCASE
      ENDIF
   NEXT i

   DO EVENTS

   FOR i := 1 TO Len( vExtraFoldersForSearchHB )
      IF ! Empty( vExtraFoldersForSearchHB[i] )
         cAux := US_ShortName( vExtraFoldersForSearchHB[i] )
         IF ! Empty( cAux )
            nLastExtraFolderSearchAdded := i
            IF US_IsRootFolder( vExtraFoldersForSearchHB[ i ] )
               bExtraFolderSearchRoot := .T.
            ELSE
               bExtraFolderSearchRoot := .F.
            ENDIF
            AAdd( vConcatIncludeHB, cAux )

            IF bExtraFolderSearchRoot
               cAux += DEF_SLASH
            ENDIF

            IF ! cAux $ cExtraFoldersHB
               DO CASE
               CASE IsMinGW
                  cExtraFoldersHB := cExtraFoldersHB + ';' + cAux
               CASE IsPelles
                  cExtraFoldersHB := cExtraFoldersHB + ';' + cAux
               CASE IsBorland
                  cExtraFoldersHB := cExtraFoldersHB + ';' + cAux
               OTHERWISE
                  US_Log( 'Error 5445' )
               ENDCASE
            ENDIF
         ENDIF
      ENDIF
   NEXT i

   DO EVENTS

   // INI - El siguiente es un parche para cuando el ultimo folder a agregar en Search es del formato 'C:',
   //       ya que hay que agregarle algun folder del formato 'C:\something' para que no cancele
   IF nLastExtraFolderSearchAdded > 0 .AND. nLastExtraFolderSearchAdded <= Len( vExtraFoldersForSearchHB ) .AND. ;
      US_IsRootFolder( vExtraFoldersForSearchHB[ nLastExtraFolderSearchAdded ] )
      DO CASE
      CASE IsMinGW
         cExtraFoldersHB := cExtraFoldersHB + ';' + US_ShortName( DiskName() + ':' + DEF_SLASH + '_' + PUB_cSecu + 'SearchBug' )
      CASE IsPelles
         cExtraFoldersHB := cExtraFoldersHB + ';' + US_ShortName( DiskName() + ':' + DEF_SLASH + '_' + PUB_cSecu + 'SearchBug' )
      CASE IsBorland
         cExtraFoldersHB := cExtraFoldersHB + ';' + US_ShortName( DiskName() + ':' + DEF_SLASH + '_' + PUB_cSecu + 'SearchBug' )
      OTHERWISE
         US_Log( 'Error 5446' )
      ENDCASE
   ENDIF

   FOR i := 1 TO Len( vExtraFoldersForSearchC )
      IF ! Empty( vExtraFoldersForSearchC[i] )
         cAux := US_ShortName( vExtraFoldersForSearchC[i] )
         IF ! Empty( cAux )
            nLastExtraFolderSearchAdded := i
            IF US_IsRootFolder( vExtraFoldersForSearchC[ i ] )
               bExtraFolderSearchRoot := .T.
            ELSE
               bExtraFolderSearchRoot := .F.
            ENDIF
            AAdd( vConcatIncludeHB, cAux )

            IF bExtraFolderSearchRoot
               cAux += DEF_SLASH
            ENDIF

            IF ! cAux $ cExtraFoldersC
               DO CASE
               CASE IsMinGW
                  cExtraFoldersC := cExtraFoldersC + ' -I ' + cAux
               CASE IsPelles
                  cExtraFoldersC := cExtraFoldersC + ' /I' + cAux
               CASE IsBorland
                  cExtraFoldersC := cExtraFoldersC + ';' + cAux
               OTHERWISE
                  US_Log( 'Error 5447' )
               ENDCASE
            ENDIF
         ENDIF
      ENDIF
   NEXT i

   DO EVENTS

   // INI - El siguiente es un parche para cuando el ultimo folder a agregar en Search es del formato 'C:',
   //       ya que hay que agregarle algun folder del formato 'C:\something' para que no cancele
   IF nLastExtraFolderSearchAdded > 0 .AND. nLastExtraFolderSearchAdded <= Len( vExtraFoldersForSearchC ) .AND. ;
      US_IsRootFolder( vExtraFoldersForSearchC[ nLastExtraFolderSearchAdded ] )
      DO CASE
      CASE IsMinGW
         cExtraFoldersC  := cExtraFoldersC  + ' -I ' + US_ShortName( DiskName() + ':' + DEF_SLASH + '_' + PUB_cSecu + 'SearchBug' )
      CASE IsPelles
         cExtraFoldersC  := cExtraFoldersC  + ' /I' + US_ShortName( DiskName() + ':' + DEF_SLASH + '_' + PUB_cSecu + 'SearchBug' )
      CASE IsBorland
         cExtraFoldersC  := cExtraFoldersC  + ';' + US_ShortName( DiskName() + ':' + DEF_SLASH + '_' + PUB_cSecu + 'SearchBug' )
      OTHERWISE
         US_Log( 'Error 5448' )
      ENDCASE
   ENDIF

   DO CASE
   CASE IsMinGW
      cExtraFoldersHB := SubStr( cExtraFoldersHB, 2 )  // get rid of first ';'
      cExtraFoldersC  := SubStr( cExtraFoldersC, 2 )   // get rid of first ' '
   CASE IsPelles
      cExtraFoldersHB := SubStr( cExtraFoldersHB, 2 )  // get rid of first ';'
      cExtraFoldersC  := SubStr( cExtraFoldersC, 2 )   // get rid of first ' '
   CASE IsBorland
      cExtraFoldersHB := SubStr( cExtraFoldersHB, 2 )  // get rid of first ';'
      cExtraFoldersC  := SubStr( cExtraFoldersC, 2 )   // get rid of first ';'
   OTHERWISE
      US_Log( 'Error 5449')
   ENDCASE

   FErase( SCRIPT_FILE )
   FErase( END_FILE )
   FErase( TEMP_LOG )
   FErase( PROGRESS_LOG )
   ProgLength := 0

   SetProperty( 'VentanaMain', 'EraseOBJ', 'enabled', .F. )
   SetProperty( 'VentanaMain', 'EraseALL', 'enabled', .F. )
   SetProperty( 'VentanaMain', 'open', 'enabled', .F. )
   SetProperty( 'VentanaMain', 'build', 'enabled', .F. )
   SetProperty( 'VentanaMain', 'BVerChange', 'enabled', .F. )
   SetProperty( 'VentanaMain', 'OverrideCompile', 'enabled', .F. )
   SetProperty( 'VentanaMain', 'OverrideLink', 'enabled', .F. )
   IF Prj_Radio_OutputType == DEF_RG_EXE
      SetProperty( 'VentanaMain', 'run', 'enabled', .F. )
   ENDIF

   PUB_bIsProcessing := .T.
   VentanaMain.RichEditSysout.Value := ''

   DO EVENTS

   FErase( MSG_SYSIN )

   SetCurrentFolder( PUB_cProjectFolder )
   IF ! US_CreateFolder( GetObjFolder() )
      US_Log( 'Unable to create OBJ folder: ' + GetObjFolder() )
      BUILD_IN_PROGRESS := .F.
      RETURN .F.
   ENDIF
   SetCurrentFolder( cOldFolder )

   OBJFOLDER          := US_ShortName( GetObjFolder() )
   cOutputName        := GetOutputModuleName( .F. )
   cOutputNameDisplay := GetOutputModuleName( .T. )

/*
 * Out contiene los comandos que luego se grabarán en
 * Temp.Bc para ser ejecutados por MAKE.EXE desde Build.bat
 */
   Out := 'APP_NAME = ' + cOutputName + CRLF

   IF Prj_Radio_OutputType == DEF_RG_EXE .OR. Prj_Radio_OutputType == DEF_RG_LIB
      IF VentanaMain.GHeaFiles.itemcount > 0
         FUNC_xRefPrgHea( vConcatIncludeC )
      ENDIF
      IF VentanaMain.GPanFiles.itemcount > 0
         FUNC_xRefPrgFmg( vConcatIncludeHB )
      ENDIF
   ENDIF

   MemoAux := MemoRead( PROGRESS_LOG )
   QPM_MemoWrit( PROGRESS_LOG, MemoAux + US_TimeDis( Time() ) + ' - Checking libraries ...' + CRLF )

   DO EVENTS

/*
 * Variables y aplicaciones a utilizar en Temp.Bc
 */
   DO CASE
   CASE IsMinGW
      Out := Out + 'IMPDEF_MGW_EXE = '  + DBLQT + US_ShortName( PUB_cQPM_Folder ) + DEF_SLASH                     + 'US_PEXPORTS.EXE' + DBLQT + CRLF
      Out := Out + 'IMPLIB_MGW_EXE = '  + DBLQT + US_ShortName( GetCppFolder() )  + DEF_SLASH + 'BIN' + DEF_SLASH + 'DLLTOOL.EXE'     + DBLQT + CRLF
      Out := Out + 'LSTA_EXE = '        + DBLQT + US_ShortName( PUB_cQPM_Folder ) + DEF_SLASH                     + 'US_OBJDUMP.EXE'  + DBLQT + CRLF
      Out := Out + 'COMPILATOR_C = '    + DBLQT + US_ShortName( PUB_cQPM_Folder ) + DEF_SLASH                     + 'US_SLASH.EXE'    + DBLQT + CRLF
      Out := Out + 'ILINK_EXE = '       + DBLQT + US_ShortName( PUB_cQPM_Folder ) + DEF_SLASH                     + 'US_SLASH.EXE'    + DBLQT + CRLF
      Out := Out + 'TLIB_EXE = '        + DBLQT + US_ShortName( GetCppFolder() )  + DEF_SLASH + 'BIN' + DEF_SLASH + 'AR.EXE'          + DBLQT + CRLF
      Out := Out + 'RESOURCE_COMP = '   + DBLQT + US_ShortName( GetCppFolder() )  + DEF_SLASH + 'BIN' + DEF_SLASH + 'WINDRES.EXE'     + DBLQT + CRLF
      Out := Out + 'REIMPORT_EXE = '    + DBLQT + US_ShortName( PUB_cQPM_Folder ) + DEF_SLASH                     + 'US_REIMP.EXE'    + DBLQT + CRLF
      Out := Out + 'DIR_COMPC = '       + DBLQT + US_ShortName( GetCppFolder() )                                                      + DBLQT + CRLF
      Out := Out + 'DIR_HARBOUR = '     + DBLQT + US_ShortName( GetHarbourFolder() )                                                  + DBLQT + CRLF
      i := " " + AllTrim( GetProperty( 'VentanaMain', 'OverrideLink', 'value' ) ) + " "
      IF Prj_Check_StaticBuild
         IF ! " -static " $ i
            SetProperty( 'VentanaMain', 'OverrideLink', 'value', "-static" + i )
         ENDIF
      ELSE
         IF " -static " $ i
            SetProperty( 'VentanaMain', 'OverrideLink', 'value', AllTrim( StrTran( i, " -static ", " " ) ) )
         ENDIF
      ENDIF
      Out := Out + 'USER_FLAGS_LINK = ' + GetProperty( 'VentanaMain', 'OverrideLink', 'value' )                                               + CRLF
   CASE IsPelles
      Out := Out + 'IMPDEF_PC_EXE = '   + DBLQT + US_ShortName( PUB_cQPM_Folder ) + DEF_SLASH                     + 'US_IMPDEF.EXE'   + DBLQT + CRLF
      Out := Out + 'IMPLIB_PC_EXE = '   + DBLQT + US_ShortName( PUB_cQPM_Folder ) + DEF_SLASH                     + 'US_POLIB.EXE'    + DBLQT + CRLF
      Out := Out + 'LSTLIB_EXE = '      + DBLQT + US_ShortName( PUB_cQPM_Folder ) + DEF_SLASH                     + 'US_POLIB.EXE'    + DBLQT + CRLF
      Out := Out + 'COMPILATOR_C = '    + DBLQT + US_ShortName( GetCppFolder() )  + DEF_SLASH + 'BIN' + DEF_SLASH + 'POCC.EXE'        + DBLQT + CRLF
      Out := Out + 'ILINK_EXE = '       + DBLQT + US_ShortName( GetCppFolder() )  + DEF_SLASH + 'BIN' + DEF_SLASH + 'POLINK.EXE'      + DBLQT + CRLF
      Out := Out + 'TLIB_EXE = '        + DBLQT + US_ShortName( PUB_cQPM_Folder ) + DEF_SLASH                     + 'US_POLIB.EXE'    + DBLQT + CRLF
      Out := Out + 'RESOURCE_COMP = '   + DBLQT + US_ShortName( GetCppFolder() )  + DEF_SLASH + 'BIN' + DEF_SLASH + 'PORC.EXE'        + DBLQT + CRLF
      i := " " + AllTrim( GetProperty( 'VentanaMain', 'OverrideLink', 'value' ) ) + " "
      IF " -static " $ i
         SetProperty( 'VentanaMain', 'OverrideLink', 'value', AllTrim( StrTran( i, " -static ", " " ) ) )
      ENDIF
      Out := Out + 'USER_FLAGS_LINK = ' + GetProperty( 'VentanaMain', 'OverrideLink', 'value' )                                               + CRLF
   CASE IsBorland
      Out := Out + 'IMPDEF_BCC_EXE = '  + DBLQT + US_ShortName( PUB_cQPM_Folder ) + DEF_SLASH                     + 'US_IMPDEF.EXE'   + DBLQT + CRLF
      Out := Out + 'IMPLIB_BCC_EXE = '  + DBLQT + US_ShortName( PUB_cQPM_Folder ) + DEF_SLASH                     + 'US_IMPLIB.EXE'   + DBLQT + CRLF
      Out := Out + 'LSTLIB_EXE = '      + DBLQT + US_ShortName( PUB_cQPM_Folder ) + DEF_SLASH                     + 'US_TLIB.EXE'     + DBLQT + CRLF
      Out := Out + 'COMPILATOR_C = '    + DBLQT + US_ShortName( GetCppFolder() )  + DEF_SLASH + 'BIN' + DEF_SLASH + 'BCC32.EXE'       + DBLQT + CRLF
      Out := Out + 'ILINK_EXE = '       + DBLQT + US_ShortName( GetCppFolder() )  + DEF_SLASH + 'BIN' + DEF_SLASH + 'ILINK32.EXE'     + DBLQT + CRLF
      Out := Out + 'TLIB_EXE = '        + DBLQT + US_ShortName( PUB_cQPM_Folder ) + DEF_SLASH                     + 'US_TLIB.EXE'     + DBLQT + CRLF
      Out := Out + 'RESOURCE_COMP = '   + DBLQT + US_ShortName( GetCppFolder() )  + DEF_SLASH + 'BIN' + DEF_SLASH + 'BRCC32.EXE'      + DBLQT + CRLF
      Out := Out + 'USER_FLAGS_LINK = ' + GetProperty( 'VentanaMain', 'OverrideLink', 'value' )                                               + CRLF
      i := " " + AllTrim( GetProperty( 'VentanaMain', 'OverrideLink', 'value' ) ) + " "
      IF " -static " $ i
         SetProperty( 'VentanaMain', 'OverrideLink', 'value', AllTrim( StrTran( i, " -static ", " " ) ) )
      ENDIF
   OTHERWISE
      US_Log( 'Error 5549' )
   ENDCASE
      Out := Out + 'HARBOUR_EXE = '     + DBLQT + US_ShortName( GetHarbourFolder() ) + DEF_SLASH + 'BIN' + DEF_SLASH + 'HARBOUR.EXE'  + DBLQT + CRLF
      Out := Out + 'US_MSG_EXE = '      + DBLQT + US_ShortName(PUB_cQPM_Folder)      + DEF_SLASH + 'US_MSG.EXE'                       + DBLQT + CRLF
      Out := Out + 'US_UPX_EXE = '      + DBLQT + US_ShortName(PUB_cQPM_Folder)      + DEF_SLASH + 'US_UPX.EXE'                       + DBLQT + CRLF
      Out := Out + 'US_SHELL_EXE = '    + DBLQT + US_ShortName(PUB_cQPM_Folder)      + DEF_SLASH + 'US_SHELL.EXE'                     + DBLQT + CRLF
      Out := Out + 'DIR_HB_INCLUDE = '  + cExtraFoldersHB                                                                                     + CRLF
      Out := Out + 'DIR_C_INCLUDE = '   + cExtraFoldersC                                                                                      + CRLF
      Out := Out + 'DIR_MINIGUI = '     + US_ShortName( GetMiniGuiFolder() )                                                                  + CRLF
      Out := Out + 'DIR_MINIGUI_LIB = ' + GetMiniguiLibFolder()                                                                               + CRLF
      Out := Out + 'DIR_MINIGUI_RES = ' + US_ShortName( GetMiniGuiFolder() + DEF_SLASH + 'RESOURCES' )                                        + CRLF
      Out := Out + 'DIR_COMPC_LIB = '   + GetCppLibFolder()                                                                                   + CRLF
      Out := Out + 'DIR_HARBOUR_LIB = ' + GetHarbourLibFolder()                                                                               + CRLF
      Out := Out + 'DIR_PROJECT = '     + VentanaMain.TProjectFolder.Value                                                                    + CRLF
   IF IsBorland
      Out := Out + 'DIR_COMPC_LIB2 = '  + GetCppLibFolder() + DEF_SLASH + 'PSDK'                                                              + CRLF
   ENDIF
      Out := Out + 'PAUSE_EXE = '       + 'PAUSE'                                                                                             + CRLF
      Out := Out + 'DIR_OBJECTS = '     + OBJFOLDER                                                                                           + CRLF
      Out := Out + 'C_DIR = '           + OBJFOLDER                                                                                           + CRLF
      Out := Out + 'USER_FLAGS_HARB = ' + GetProperty( 'VentanaMain', 'OverrideCompile', 'value' )                                            + CRLF

   IF Prj_Radio_OutputType != DEF_RG_IMPORT
      cPrj_Version := GetPrj_Version()
      IF Empty( GetProperty( 'VentanaMain', 'OverrideCompile', 'value' ) )
         Out := Out + 'HARBOUR_FLAGS = /D__QPM_VERSION__="' + "'" + QPM_VERSION_NUMBER_SHORT + "'" + '" /D__PRJ_VERSION__="'+"'"+cPrj_Version+"'"+'" /D__PROJECT_FOLDER__="'+"'"+VentanaMain.TProjectFolder.Value+"'"+ '" /n' + iif(PUB_bDebugActive,' /b','') + ' /i$(DIR_HB_INCLUDE) ' + CRLF
      ELSE
         Out := Out + 'HARBOUR_FLAGS = /D__QPM_VERSION__="' + "'" + QPM_VERSION_NUMBER_SHORT + "'" + '" /D__PRJ_VERSION__="'+"'"+cPrj_Version+"'"+'" /D__PROJECT_FOLDER__="'+"'"+VentanaMain.TProjectFolder.Value+"'"+ '" /n' + iif(PUB_bDebugActive,' /b','') + ' $(USER_FLAGS_HARB) /i$(DIR_HB_INCLUDE) ' + CRLF
      ENDIF
      IF PUB_xHarbourMT == 'MT'
         DO CASE
         CASE IsMinGW
            Out := Out + 'COBJFLAGS = $(DIR_C_INCLUDE) -Wall -c' + CRLF
         CASE IsPelles
            Out := Out + 'COBJFLAGS =  -c -O2 -tWM -M $(DIR_C_INCLUDE) -L' + GetCppLibFolder() + CRLF
         CASE IsBorland
            Out := Out + 'COBJFLAGS =  -c -O2 -tWM -M -I$(DIR_C_INCLUDE) -L' + GetCppLibFolder() + CRLF
         OTHERWISE
            US_Log( 'Error 5598' )
         ENDCASE
      ELSE
         DO CASE
         CASE IsMinGW
            Out := Out + 'COBJFLAGS = $(DIR_C_INCLUDE) -Wall -c' + CRLF
         CASE IsPelles
            Out := Out + 'COBJFLAGS = ' + iif( ! Prj_Check_Console, ' /Ze /Zx /Go /Tx86-coff /D__WIN32__ ', ' /Ze /Zx /Go /Tx86-coff /D__WIN32__ ' ) + ' $(DIR_C_INCLUDE)' + CRLF
         CASE IsBorland
            // TODO: use this flags -6 -OS -Ov -Oi -Oc
            Out := Out + 'COBJFLAGS = ' + iif( Prj_Check_Console, '-c -O2 -d -M', '-c -O2 -tW -M' ) + ' -I$(DIR_C_INCLUDE) -L' + GetCppLibFolder() + CRLF
         OTHERWISE
            US_Log( 'Error 5598' )
         ENDCASE
      ENDIF
      Out := Out + CRLF

      DO EVENTS

/*
 * Objetos de los que depende el ejecutable
 */
      nCant := Len( PRGFILES )
      IF IsMinGW
         Out := Out + '$(APP_NAME) : $(DIR_OBJECTS)' + DEF_SLASH + US_FileNameOnlyName( PRGFILES[1] ) + '.o ' + iif( nCant > 1, DEF_SLASH, '' ) + CRLF
      ELSE
         Out := Out + '$(APP_NAME) : $(DIR_OBJECTS)' + DEF_SLASH + US_FileNameOnlyName( PRGFILES[1] ) + '.obj ' + iif( nCant > 1, DEF_SLASH, '' ) + CRLF
      ENDIF
      FOR i := 2 TO nCant
         IF i == nCant
            IF IsMinGW
               Out := Out + '              $(DIR_OBJECTS)' + DEF_SLASH + US_FileNameOnlyName( PRGFILES[i] ) + '.o' + CRLF
            ELSE
               Out := Out + '              $(DIR_OBJECTS)' + DEF_SLASH + US_FileNameOnlyName( PRGFILES[i] ) + '.obj' + CRLF
            ENDIF
         ELSE
            IF IsMinGW
               Out := Out + '              $(DIR_OBJECTS)' + DEF_SLASH + US_FileNameOnlyName( PRGFILES[i] ) + '.o ' + DEF_SLASH + CRLF
            ELSE
               Out := Out + '              $(DIR_OBJECTS)' + DEF_SLASH + US_FileNameOnlyName( PRGFILES[i] ) + '.obj ' + DEF_SLASH + CRLF
            ENDIF
         ENDIF
      NEXT i

      DO EVENTS

/*
 * Comandos para generar el ejecutable.
 * Esta lista NO debe estar separada de la anterior por renglones en blanco.
 */

 /*
  * Comandos para compilar el archivo de recursos
  */
      IF ! Prj_Check_IgnoreLibRCs .OR. ( ! Prj_Check_IgnoreMainRC .AND. File( US_FileNameOnlyPathAndName( PRGFILES[1] ) + '.RC' ) )
         DO CASE
         CASE IsMinGW
            IF Prj_Radio_OutputType != DEF_RG_IMPORT
               Out := Out + PUB_cCharTab + '$(US_MSG_EXE) ' + Q_PROGRESS_LOG + ' -MSG:Compiling Resource File ' + US_FileNameOnlyPathAndName( PRGFILES[1] ) + '.rc' + ' ...' + CRLF
               IF ! PUB_DeleteAux
                  Out := Out + PUB_cCharTab + '$(US_MSG_EXE) ' + Q_PROGRESS_LOG + ' -MSG:QPM_TMP_RC is ' + US_FileNameOnlyNameAndExt( QPM_TMP_RC ) + CRLF
               ENDIF
               Out := Out + PUB_cCharTab + '$(RESOURCE_COMP) -I $(DIR_MINIGUI_RES) $(DIR_C_INCLUDE) -i ' + QPM_TMP_RC + ' -o $(DIR_OBJECTS)' + DEF_SLASH + '_Temp.o' + CRLF
            ENDIF
         CASE IsPelles
            Out := Out + PUB_cCharTab + '$(US_MSG_EXE) ' + Q_PROGRESS_LOG + ' -MSG:Compiling Resource File ' + US_FileNameOnlyPathAndName( PRGFILES[1] ) + '.rc' + ' ...' + CRLF
            IF ! PUB_DeleteAux
               Out := Out + PUB_cCharTab + '$(US_MSG_EXE) ' + Q_PROGRESS_LOG + ' -MSG:QPM_TMP_RC is ' + US_FileNameOnlyNameAndExt( QPM_TMP_RC ) + CRLF
            ENDIF
            Out := Out + PUB_cCharTab + '$(RESOURCE_COMP) /I$(DIR_MINIGUI_RES) $(DIR_C_INCLUDE) /Fo$(DIR_OBJECTS)' + DEF_SLASH + '_Temp.res ' + QPM_TMP_RC + CRLF
         CASE IsBorland
            Out := Out + PUB_cCharTab + '$(US_MSG_EXE) ' + Q_PROGRESS_LOG + ' -MSG:Compiling Resource File ...' + CRLF
            IF ! PUB_DeleteAux
               Out := Out + PUB_cCharTab + '$(US_MSG_EXE) ' + Q_PROGRESS_LOG + ' -MSG:QPM_TMP_RC is ' + US_FileNameOnlyNameAndExt( QPM_TMP_RC ) + CRLF
            ENDIF
            Out := Out + PUB_cCharTab + '$(RESOURCE_COMP) -i$(DIR_MINIGUI_RES);$(DIR_C_INCLUDE) -r -fo$(DIR_OBJECTS)' + DEF_SLASH + '_Temp.res ' + QPM_TMP_RC + CRLF
         OTHERWISE
            US_Log( 'Error 5649' )
         ENDCASE
      ENDIF

/*
 * Comandos para generar el ejecutable (van en Out) y para generar el
 * script de linkedición (van en script.ld)
 */
      DO CASE
      CASE Prj_Radio_OutputType == DEF_RG_EXE
         Out := Out + PUB_cCharTab + '$(US_MSG_EXE) ' + Q_PROGRESS_LOG + ' -MSG:Making script for link process ...' + CRLF
         IF ! PUB_DeleteAux
            Out := Out + PUB_cCharTab + '$(US_MSG_EXE) ' + Q_PROGRESS_LOG + ' -MSG:SCRIPT_FILE is ' + US_FileNameOnlyNameAndExt( SCRIPT_FILE ) + CRLF
         ENDIF
         IF QPM_IsXHarbour() .AND. IsMinGW
            IF Prj_Check_Console
               Out := Out + PUB_cCharTab + 'echo INPUT( ' + GetHarbourLibFolder() + DEF_SLASH + 'mainstd.o ) >> ' + Q_SCRIPT_FILE + CRLF
            ELSE
               Out := Out + PUB_cCharTab + 'echo INPUT( ' + GetHarbourLibFolder() + DEF_SLASH + 'mainwin.o ) >> ' + Q_SCRIPT_FILE + CRLF
            ENDIF
         ENDIF

/*
 * Grabo en script.ld los objetos listados en las Include Libraries que estén marcados *FIRST* y que no estén excluidos
 */
         FOR i := 1 TO Len ( vLibIncludeFiles )
            IF US_Upper( US_Word( GetProperty( 'VentanaMain', 'GIncFiles', 'Cell', i, NCOLINCFULLNAME ), 2 ) ) == '*FIRST*'
               DO CASE
               CASE IsMinGW
                  IF Upper( US_FileNameOnlyExt( vLibIncludeFiles[i] ) ) == 'O'
                     IF ! QPM_IsXHarbour() .OR. ! ( US_Upper( US_FileNameOnlyName( vLibIncludeFiles[i] ) ) $ ( 'MAINSTD' + CRLF + 'MAINWIN' ) )
                        IF AScan( vLibExcludeFiles, { |x| US_Upper( x ) == US_Upper( vLibsToLink[ i ] ) } ) == 0
                           Out := Out + PUB_cCharTab + 'echo INPUT( ' + US_ShortName( vLibIncludeFiles[i] ) + ' ) >> ' + Q_SCRIPT_FILE + CRLF
                        ENDIF
                     ENDIF
                  ENDIF
               CASE IsPelles
                  IF Upper( US_FileNameOnlyExt( vLibIncludeFiles[i] ) ) == 'OBJ'
                     IF AScan( vLibExcludeFiles, { |x| US_Upper( x ) == US_Upper( vLibsToLink[ i ] ) } ) == 0
                        Out := Out + PUB_cCharTab + 'echo ' + US_ShortName( vLibIncludeFiles[i] ) + ' >> ' + Q_SCRIPT_FILE + CRLF
                     ENDIF
                  ENDIF
               CASE IsBorland
                  IF Upper( US_FileNameOnlyExt( vLibIncludeFiles[i] ) ) == 'OBJ'
                     IF AScan( vLibExcludeFiles, { |x| US_Upper( x ) == US_Upper( vLibsToLink[ i ] ) } ) == 0
                        Out := Out + PUB_cCharTab + 'echo ' + US_ShortName( vLibIncludeFiles[i] ) + ' + >> ' + Q_SCRIPT_FILE + CRLF
                     ENDIF
                  ENDIF
               OTHERWISE
                  US_Log( 'Error 5671' )
               ENDCASE
            ENDIF
         NEXT i

         DO EVENTS
/*
 * Grabo lista de objetos derivados de los .prg en script.ld
 */
         FOR i := 1 TO Len ( PRGFILES )
            DO CASE
            CASE IsMinGW
               Out := Out + PUB_cCharTab + 'echo INPUT( $(DIR_OBJECTS)' + DEF_SLASH + US_FileNameOnlyName( PRGFILES[i] ) + '.o ) >> ' + Q_SCRIPT_FILE + CRLF
            CASE IsPelles
               Out := Out + PUB_cCharTab + 'echo $(DIR_OBJECTS)' + DEF_SLASH + US_FileNameOnlyName( PRGFILES[i] ) + '.obj >> ' + Q_SCRIPT_FILE + CRLF
            CASE IsBorland
               Out := Out + PUB_cCharTab + 'echo $(DIR_OBJECTS)' + DEF_SLASH + US_FileNameOnlyName( PRGFILES[i] ) + '.obj + >> ' + Q_SCRIPT_FILE + CRLF
            OTHERWISE
               US_Log( 'Error 5672' )
            ENDCASE
         NEXT i

         DO EVENTS

         DO CASE
         CASE IsMinGW

/*
 * Grabo objeto generado a partir del archivo de recursos en script.ld
 */
            IF ! Prj_Check_IgnoreMainRC .OR. ! Prj_Check_IgnoreLibRCs
               Out := Out + PUB_cCharTab + 'echo INPUT( $(DIR_OBJECTS)' + DEF_SLASH + '_Temp.o ) >> ' + Q_SCRIPT_FILE + CRLF
            ENDIF

/*
 * Grabo en script.ld los objetos listados en las Default Libraries (deben estar en RESOURCES o Project o CPP )
 */
            FOR i := 1 TO Len( vLibsToLink )
               IF Upper( US_FileNameOnlyExt( vLibsToLink[i] ) ) == 'O'
                  IF AScan( vLibExcludeFiles, { |x| US_Upper( x ) == US_Upper( vLibsToLink[i] ) } ) == 0
                     IF File( GetMiniGuiFolder() + DEF_SLASH + 'RESOURCES' + DEF_SLASH + vLibsToLink[i] )
                        Out := Out + PUB_cCharTab + 'echo INPUT( $(DIR_MINIGUI_RES)' + DEF_SLASH + vLibsToLink[i] + ' ) >> ' + Q_SCRIPT_FILE + CRLF
                     ELSEIF File( PUB_cProjectFolder + DEF_SLASH + vLibsToLink[i] )
                        Out := Out + PUB_cCharTab + 'echo INPUT( ' + US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + vLibsToLink[i] + ' ) >> ' + Q_SCRIPT_FILE + CRLF
                     ELSEIF File( GetCppLibFolder() + DEF_SLASH + vLibsToLink[i] )
                        Out := Out + PUB_cCharTab + 'echo INPUT( ' + US_ShortName( GetCppLibFolder() ) + DEF_SLASH + vLibsToLink[i] + ' ) >> ' + Q_SCRIPT_FILE + CRLF
                     ENDIF
                  ENDIF
               ENDIF
            NEXT i

            DO EVENTS

/*
 * Grabo en script.ld los objetos listados en las Include Libraries que estén marcados *LAST*
 */
            FOR i := 1 TO Len ( vLibIncludeFiles )
               IF US_Word( GetProperty( 'VentanaMain', 'GIncFiles', 'Cell', i, NCOLINCFULLNAME ), 2 ) == '*LAST*'
                  IF Upper( US_FileNameOnlyExt( vLibIncludeFiles[i] ) ) == 'O'
                     IF ! QPM_IsXHarbour() .OR. ! ( US_Upper( US_FileNameOnlyName( vLibIncludeFiles[i] ) ) $ ( 'MAINSTD' + CRLF + 'MAINWIN' ) )
                        Out := Out + PUB_cCharTab + 'echo INPUT( ' + US_ShortName( vLibIncludeFiles[i] ) + ' ) >> ' + Q_SCRIPT_FILE + CRLF
                     ENDIF
                  ENDIF
               ENDIF
            NEXT i

         CASE IsPelles

/*
 * Grabo en script.ld los objetos listados en las Default Libraries (deben estar en RESOURCES o Project o CPP )
 */
            FOR i := 1 TO Len( vLibsToLink )
               IF Upper( US_FileNameOnlyExt( vLibsToLink[i] ) ) == 'OBJ'
                  IF AScan( vLibExcludeFiles, { |x| US_Upper( x ) == US_Upper( vLibsToLink[i] ) } ) == 0
                     IF File( GetMiniGuiFolder() + DEF_SLASH + 'RESOURCES' + DEF_SLASH + vLibsToLink[i] )
                        Out := Out + PUB_cCharTab + 'echo INPUT( $(DIR_MINIGUI_RES)' + DEF_SLASH + vLibsToLink[i] + ' ) >> ' + Q_SCRIPT_FILE + CRLF
                     ELSEIF File( PUB_cProjectFolder + DEF_SLASH + vLibsToLink[i] )
                        Out := Out + PUB_cCharTab + 'echo INPUT( ' + US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + vLibsToLink[i] + ' ) >> ' + Q_SCRIPT_FILE + CRLF
                     ELSEIF File( GetCppLibFolder() + DEF_SLASH + vLibsToLink[i] )
                        Out := Out + PUB_cCharTab + 'echo INPUT( ' + US_ShortName( GetCppLibFolder() ) + DEF_SLASH + vLibsToLink[i] + ' ) >> ' + Q_SCRIPT_FILE + CRLF
                     ENDIF
                  ENDIF
               ENDIF
            NEXT i

            DO EVENTS
/*
 * Grabo en script.ld los objetos listados en las Include Libraries que estén marcados *LAST*
 */
            FOR i := 1 TO Len ( vLibIncludeFiles )
               IF US_Word( GetProperty( 'VentanaMain', 'GIncFiles', 'Cell', i, NCOLINCFULLNAME ), 2 ) == '*LAST*'
                  IF Upper( US_FileNameOnlyExt( vLibIncludeFiles[i] ) ) == 'OBJ'
                     Out := Out + PUB_cCharTab + 'echo ' + US_ShortName( vLibIncludeFiles[i] ) + ' + >> ' + Q_SCRIPT_FILE + CRLF
                  ENDIF
               ENDIF
            NEXT i

            Out := Out + PUB_cCharTab + 'echo /OUT:$(APP_NAME) >> ' + Q_SCRIPT_FILE + CRLF
            Out := Out + PUB_cCharTab + 'echo /FORCE:MULTIPLE >> ' + Q_SCRIPT_FILE + CRLF
            Out := Out + PUB_cCharTab + 'echo /LIBPATH:' + GetCppLibFolder() + ' >> ' + Q_SCRIPT_FILE + CRLF
            Out := Out + PUB_cCharTab + 'echo /LIBPATH:' + GetCppLibFolder() + DEF_SLASH + 'WIN' + ' >> ' + Q_SCRIPT_FILE + CRLF

         CASE IsBorland

/*
 * Grabo en script.ld los objetos listados en las Default Libraries (deben estar en RESOURCES o Project o CPP )
 */
            FOR i := 1 TO Len( vLibsToLink )
               IF Upper( US_FileNameOnlyExt( vLibsToLink[i] ) ) == 'OBJ'
                  IF AScan( vLibExcludeFiles, { |x| US_Upper( x ) == US_Upper( vLibsToLink[i] ) } ) == 0
                     IF File( GetMiniGuiFolder() + DEF_SLASH + 'RESOURCES' + DEF_SLASH + vLibsToLink[i] )
                        Out := Out + PUB_cCharTab + 'echo $(DIR_MINIGUI_RES)' + DEF_SLASH + vLibsToLink[i] + ' + >> ' + Q_SCRIPT_FILE + CRLF
                     ELSEIF File( PUB_cProjectFolder + DEF_SLASH + vLibsToLink[i] )
                        Out := Out + PUB_cCharTab + 'echo $(DIR_PROJECT)' + DEF_SLASH + vLibsToLink[i] + ' + >> ' + Q_SCRIPT_FILE + CRLF
                     ELSEIF File( GetCppLibFolder() + DEF_SLASH + vLibsToLink[i] )
                        Out := Out + PUB_cCharTab + 'echo $(DIR_COMPC_LIB)' + DEF_SLASH + vLibsToLink[i] + ' + >> ' + Q_SCRIPT_FILE + CRLF
                     ENDIF
                  ENDIF
               ENDIF
            NEXT i

            DO EVENTS
/*
 * Grabo en script.ld los objetos listados en las Include Libraries que estén marcados *LAST*
 */
            FOR i := 1 TO Len ( vLibIncludeFiles )
               IF US_Word( GetProperty( 'VentanaMain', 'GIncFiles', 'Cell', i, NCOLINCFULLNAME ), 2 ) == '*LAST*'
                  IF Upper( US_FileNameOnlyExt( vLibIncludeFiles[i] ) ) == 'OBJ'
                     Out := Out + PUB_cCharTab + 'echo ' + US_ShortName( vLibIncludeFiles[i] ) + ' + >> ' + Q_SCRIPT_FILE + CRLF
                  ENDIF
               ENDIF
            NEXT i

            i := RAt( " + >> ", Out )
            Out := SubStr( Out, 1, i - 1 ) + "," + SubStr( Out, i )

            Out := Out + PUB_cCharTab + 'echo $(APP_NAME), ' + US_ShortName(PUB_cProjectFolder) + DEF_SLASH + US_FileNameOnlyName( GetOutputModuleName() ) + '.MAP' + ', + >> ' + Q_SCRIPT_FILE + CRLF

         OTHERWISE
            US_Log( 'Error 5746' )
         ENDCASE

         DO EVENTS

/*
 * Add libraries to script.ld
 */
         DO CASE
         CASE IsMinGW
            w_hay := .F.
            w_group := 'GROUP( '

/*
 * MINGW: add libraries marked *FIRST* that are not excluded
 */
            FOR i := 1 TO Len ( vLibIncludeFiles )
               IF US_Upper( US_Word( GetProperty( 'VentanaMain', 'GIncFiles', 'Cell', i, NCOLINCFULLNAME ), 2 ) ) == '*FIRST*'
                  IF Upper( US_FileNameOnlyExt( vLibIncludeFiles[i] ) ) == 'A'
                     IF AScan( vLibExcludeFiles, { |x| US_Upper( x ) == US_Upper( US_FileNameOnlyNameAndExt( vLibIncludeFiles[i] ) ) } ) == 0
                        w_hay := .T.
                        w_group += '-l' + SubStr( US_FileNameOnlyName( vLibIncludeFiles[i] ), 4 ) + ' '
                     ENDIF
                  ENDIF
               ENDIF
            NEXT

            DO EVENTS

/*
 * MINGW: add default libraries that are not excluded
 */
            FOR i := 1 TO Len( vLibsToLink )
               IF AScan( vLibExcludeFiles, { |x| US_Upper( x ) == US_Upper( vLibsToLink[i] ) } ) == 0
                  DO CASE
                  CASE File( GetMiniGuiLibFolder() + DEF_SLASH + vLibsToLink[i] )
                     w_hay := .T.
                     w_group += '-l' + SubStr( US_FileNameOnlyName( vLibsToLink[i] ), 4 ) + ' '
                  CASE File( GetHarbourLibFolder() + DEF_SLASH + vLibsToLink[i] )
                     w_hay := .T.
                     w_group += '-l' + SubStr( US_FileNameOnlyName( vLibsToLink[i] ), 4 ) + ' '
                  CASE File( GetCppLibFolder() + DEF_SLASH + vLibsToLink[i] )
                     w_hay := .T.
                     w_group += '-l' + SubStr( US_FileNameOnlyName( vLibsToLink[i] ), 4 ) + ' '
                  CASE File( GetCppFolder() + DEF_SLASH + "lib" + DEF_SLASH + vLibsToLink[i] )
                     w_hay := .T.
                     w_group += '-l' + SubStr( US_FileNameOnlyName( vLibsToLink[i] ), 4 ) + ' '
                  CASE Prj_Check_64bits .AND. File( GetCppFolder() + DEF_SLASH + "x86_64-w64-mingw32" + DEF_SLASH + "lib" + DEF_SLASH + vLibsToLink[i] )
                     w_hay := .T.
                     w_group += '-l' + SubStr( US_FileNameOnlyName( vLibsToLink[i] ), 4 ) + ' '
                  CASE ! Prj_Check_64bits .AND. File( GetCppFolder() + DEF_SLASH + "i686-w64-mingw32" + DEF_SLASH + "lib" + DEF_SLASH + vLibsToLink[i] )
                     w_hay := .T.
                     w_group += '-l' + SubStr( US_FileNameOnlyName( vLibsToLink[i] ), 4 ) + ' '
                  ENDCASE
               ENDIF
            NEXT

            DO EVENTS

/*
 * MINGW: add libraries marked *LAST* that are not excluded
 */
            FOR i := 1 TO Len ( vLibIncludeFiles )
               IF US_Word( GetProperty( 'VentanaMain', 'GIncFiles', 'Cell', i, NCOLINCFULLNAME ), 2 ) == '*LAST*'
                  IF Upper( US_FileNameOnlyExt( vLibIncludeFiles[i] ) ) == 'A'
                     IF AScan( vLibExcludeFiles, { |x| US_Upper( x ) == US_Upper( US_FileNameOnlyNameAndExt( vLibIncludeFiles[i] ) ) } ) == 0
                        w_hay := .T.
                        w_group += '-l' + SubStr( US_FileNameOnlyName( vLibIncludeFiles[i] ), 4 ) + ' '
                     ENDIF
                  ENDIF
               ENDIF
            NEXT

            DO EVENTS

            IF w_hay
               w_group += ')'
               Out := Out + PUB_cCharTab + 'echo ' + w_group + ' >> ' + Q_SCRIPT_FILE + CRLF
            ENDIF

/*
 * Add search folders to script.ld
 */
            Out := Out + PUB_cCharTab + 'echo SEARCH_DIR( $(DIR_PROJECT) ) >> ' + Q_SCRIPT_FILE + CRLF
            Out := Out + PUB_cCharTab + 'echo SEARCH_DIR( $(DIR_MINIGUI_LIB) ) >> ' + Q_SCRIPT_FILE + CRLF
            IF QPM_IsXHarbour() .AND. ( GetMiniGuiSuffix() == DefineExtended1 )
               Out := Out + PUB_cCharTab + 'echo SEARCH_DIR( $(DIR_MINIGUI)' + DEF_SLASH + 'xlib ) >> ' + Q_SCRIPT_FILE + CRLF
            ENDIF
            Out := Out + PUB_cCharTab + 'echo SEARCH_DIR( $(DIR_HARBOUR_LIB) ) >> ' + Q_SCRIPT_FILE + CRLF
            Out := Out + PUB_cCharTab + 'echo SEARCH_DIR( $(DIR_COMPC_LIB) ) >> ' + Q_SCRIPT_FILE + CRLF
            FOR i := 1 TO Len( &('vExtraFoldersForLibs'+GetSuffix()) )
               IF ! Empty( &('vExtraFoldersForLibs'+GetSuffix()+'['+Str(i)+']') ) .AND. ;
                   &('vExtraFoldersForLibs'+GetSuffix()+'['+Str(i)+']') != US_Upper( GetCppLibFolder() ) .AND. ;
                   &('vExtraFoldersForLibs'+GetSuffix()+'['+Str(i)+']') != US_Upper( GetMiniguiLibFolder() ) .AND. ;
                   &('vExtraFoldersForLibs'+GetSuffix()+'['+Str(i)+']') != US_Upper( GetHarbourLibFolder() )
                  Out := Out + PUB_cCharTab + 'echo SEARCH_DIR( ' + US_ShortName( &('vExtraFoldersForLibs'+GetSuffix()+'['+Str(i)+']') ) + ' ) >> ' + Q_SCRIPT_FILE + CRLF
               ENDIF
            NEXT

         CASE IsPelles

/*
 * PELLES: add libraries marked *FIRST*
 */
            FOR i := 1 TO Len ( vLibIncludeFiles )
               IF US_Upper( US_Word( GetProperty( 'VentanaMain', 'GIncFiles', 'Cell', i, NCOLINCFULLNAME ), 2 ) ) == '*FIRST*'
                  IF Upper( US_FileNameOnlyExt( vLibIncludeFiles[i] ) ) == 'LIB'
                     IF AScan( vLibExcludeFiles, { |x| US_Upper( x ) == US_Upper( US_FileNameOnlyNameAndExt( vLibIncludeFiles[i] ) ) } ) == 0
                        Out := Out + PUB_cCharTab + 'echo ' + US_ShortName( vLibIncludeFiles[i] ) + ' + >> ' + Q_SCRIPT_FILE + CRLF
                     ENDIF
                  ENDIF
               ENDIF
            NEXT i

            DO EVENTS

/*
 * PELLES: add default libraries that are not excluded
 */
            FOR i := 1 TO Len( vLibsToLink )
               IF AScan( vLibExcludeFiles, { |x| US_Upper( x ) == US_Upper( vLibsToLink[i] ) } ) == 0
                  DO CASE
                  CASE File( GetMiniguiLibFolder() + DEF_SLASH + vLibsToLink[i] )
                     Out := Out + PUB_cCharTab + 'echo $(DIR_MINIGUI_LIB)' + DEF_SLASH + vLibsToLink[i] + ' + >> ' + Q_SCRIPT_FILE + CRLF
                  CASE File( GetHarbourLibFolder() + DEF_SLASH + vLibsToLink[i] )
                     Out := Out + PUB_cCharTab + 'echo $(DIR_HARBOUR_LIB)' + DEF_SLASH + vLibsToLink[i] + ' + >> ' + Q_SCRIPT_FILE + CRLF
                  CASE File( GetCppLibFolder() + DEF_SLASH + vLibsToLink[i] )
                     Out := Out + PUB_cCharTab + 'echo ' + vLibsToLink[i] + ' >> ' + Q_SCRIPT_FILE + CRLF
                  CASE File( GetCppLibFolder() + DEF_SLASH + 'WIN' + DEF_SLASH + vLibsToLink[i] )
                     Out := Out + PUB_cCharTab + 'echo ' + vLibsToLink[i] + ' >> ' + Q_SCRIPT_FILE + CRLF
                  ENDCASE
               ENDIF
            NEXT

            DO EVENTS

/*
 * PELLES: add libraries marked *LAST*
 */
            FOR i := 1 TO Len ( vLibIncludeFiles )
               IF US_Word( GetProperty( 'VentanaMain', 'GIncFiles', 'Cell', i, NCOLINCFULLNAME ), 2 ) == '*LAST*'
                  IF Upper( US_FileNameOnlyExt( vLibIncludeFiles[i] ) ) == 'LIB'
                     IF AScan( vLibExcludeFiles, { |x| US_Upper( x ) == US_Upper( US_FileNameOnlyNameAndExt( vLibIncludeFiles[i] ) ) } ) == 0
                        Out := Out + PUB_cCharTab + 'echo ' + US_ShortName( vLibIncludeFiles[i] ) + ' >> ' + Q_SCRIPT_FILE + CRLF
                     ENDIF
                  ENDIF
               ENDIF
            NEXT i

            DO EVENTS

/*
 * PELLES: add resource files
 */
            IF ! Prj_Check_IgnoreMainRC .OR. ! Prj_Check_IgnoreLibRCs
               FOR i := 1 TO Len ( vLibIncludeFiles )
                  IF US_Upper( US_Word( GetProperty( 'VentanaMain' , 'GIncFiles' , 'Cell' , i , NCOLINCFULLNAME ) , 2 ) ) == '*FIRST*' // for .res
                     IF Upper( US_FileNameOnlyExt( vLibIncludeFiles[i] ) ) == 'RES'
                        Out := Out + PUB_cCharTab + 'echo ' + US_ShortName( vLibIncludeFiles[i] ) + ' >> ' + Q_SCRIPT_FILE + CRLF
                     ENDIF
                  ENDIF
               NEXT i
               IF File( US_FileNameOnlyPathAndName( PRGFILES[1] ) + '.RC' )
                  Out := Out + PUB_cCharTab + 'echo $(DIR_OBJECTS)' + DEF_SLASH + '_Temp.res' + ' >> ' + Q_SCRIPT_FILE + CRLF
               ENDIF
               FOR i := 1 TO Len ( vLibIncludeFiles )
                  IF US_Word( GetProperty( 'VentanaMain' , 'GIncFiles' , 'Cell' , i , NCOLINCFULLNAME ) , 2 ) == '*LAST*' // for .res
                     IF Upper( US_FileNameOnlyExt( vLibIncludeFiles[i] ) ) == 'RES'
                        Out := Out + PUB_cCharTab + 'echo ' + US_ShortName( vLibIncludeFiles[i] ) + ' >> ' + Q_SCRIPT_FILE + CRLF
                     ENDIF
                  ENDIF
               NEXT i
            ENDIF

         CASE IsBorland

/*
 * BCC32: add libraries marked *FIRST*
 */
            FOR i := 1 TO Len ( vLibIncludeFiles )
               IF US_Upper( US_Word( GetProperty( 'VentanaMain', 'GIncFiles', 'Cell', i, NCOLINCFULLNAME ), 2 ) ) == '*FIRST*'
                  IF Upper( US_FileNameOnlyExt( vLibIncludeFiles[i] ) ) == 'LIB'
                     IF AScan( vLibExcludeFiles, { |x| US_Upper( x ) == US_Upper( US_FileNameOnlyNameAndExt( vLibIncludeFiles[i] ) ) } ) == 0
                        Out := Out + PUB_cCharTab + 'echo ' + US_ShortName( vLibIncludeFiles[i] ) + ' + >> ' + Q_SCRIPT_FILE + CRLF
                     ENDIF
                  ENDIF
               ENDIF
            NEXT i

            DO EVENTS

/*
 * BCC32: add default libraries that are not excluded
 */
            FOR i := 1 TO Len( vLibsToLink )
               IF ! Upper( US_FileNameOnlyExt( vLibsToLink[i] ) ) == 'OBJ'
                  IF AScan( vLibExcludeFiles, { |x| US_Upper( x ) == US_Upper( vLibsToLink[i] ) } ) == 0
                     DO CASE
                     CASE File( GetMiniguiLibFolder() + DEF_SLASH + vLibsToLink[i] )
                        Out := Out + PUB_cCharTab + 'echo $(DIR_MINIGUI_LIB)' + DEF_SLASH + vLibsToLink[i] + ' + >> ' + Q_SCRIPT_FILE + CRLF
                     CASE File( GetHarbourLibFolder() + DEF_SLASH + vLibsToLink[i] )
                        Out := Out + PUB_cCharTab + 'echo $(DIR_HARBOUR_LIB)' + DEF_SLASH + vLibsToLink[i] + ' + >> ' + Q_SCRIPT_FILE + CRLF
                     CASE File( GetCppLibFolder() + DEF_SLASH + vLibsToLink[i] )
                        Out := Out + PUB_cCharTab + 'echo $(DIR_COMPC_LIB)' + DEF_SLASH + vLibsToLink[i] + ' + >> ' + Q_SCRIPT_FILE + CRLF
                     CASE File( GetCppLibFolder() + DEF_SLASH + 'PSDK' + DEF_SLASH + vLibsToLink[i] )
                        Out := Out + PUB_cCharTab + 'echo $(DIR_COMPC_LIB2)' + DEF_SLASH + vLibsToLink[i] + ' + >> ' + Q_SCRIPT_FILE + CRLF
                     ENDCASE
                  ENDIF
               ENDIF
            NEXT

            DO EVENTS

/*
 * BCC32: add libraries marked *LAST*
 */
            FOR i := 1 TO Len ( vLibIncludeFiles )
               IF US_Word( GetProperty( 'VentanaMain', 'GIncFiles', 'Cell', i, NCOLINCFULLNAME ), 2 ) == '*LAST*'
                  IF Upper( US_FileNameOnlyExt( vLibIncludeFiles[i] ) ) == 'LIB'
                     IF AScan( vLibExcludeFiles, { |x| US_Upper( x ) == US_Upper( US_FileNameOnlyNameAndExt( vLibIncludeFiles[i] ) ) } ) == 0
                        Out := Out + PUB_cCharTab + 'echo ' + US_ShortName( vLibIncludeFiles[i] ) + ' + >> ' + Q_SCRIPT_FILE + CRLF
                     ENDIF
                  ENDIF
               ENDIF
            NEXT i

            DO EVENTS

/*
 * BCC32: add resource files
 */
            Out := Out + PUB_cCharTab + 'echo , , + >> ' + Q_SCRIPT_FILE + CRLF
            FOR i := 1 TO Len ( vLibIncludeFiles )
               IF US_Upper( US_Word( GetProperty( 'VentanaMain' , 'GIncFiles' , 'Cell' , i , NCOLINCFULLNAME ) , 2 ) ) == '*FIRST*' // for .res
                  IF Upper( US_FileNameOnlyExt( vLibIncludeFiles[i] ) ) == 'RES'
                     IF AScan( vLibExcludeFiles, { |x| US_Upper( x ) == US_Upper( US_FileNameOnlyNameAndExt( vLibIncludeFiles[i] ) ) } ) == 0
                        Out := Out + PUB_cCharTab + 'echo ' + US_ShortName( vLibIncludeFiles[i] ) + ' + >> ' + Q_SCRIPT_FILE + CRLF
                     ENDIF
                  ENDIF
               ENDIF
            NEXT i
            IF ! Prj_Check_IgnoreMainRC .OR. ! Prj_Check_IgnoreLibRCs
               IF ( ! Prj_Check_IgnoreMainRC .AND. File( US_FileNameOnlyPathAndName( PRGFILES[1] ) + '.RC' ) ) .OR. ! Prj_Check_IgnoreLibRCs
                  Out := Out + PUB_cCharTab + 'echo $(DIR_OBJECTS)' + DEF_SLASH + '_Temp.res + >> ' + Q_SCRIPT_FILE + CRLF
               ENDIF
            ENDIF
            FOR i := 1 TO Len ( vLibIncludeFiles )
               IF US_Word( GetProperty( 'VentanaMain' , 'GIncFiles' , 'Cell' , i , NCOLINCFULLNAME ) , 2 ) == '*LAST*' // for .res
                  IF Upper( US_FileNameOnlyExt( vLibIncludeFiles[i] ) ) == 'RES'
                     IF AScan( vLibExcludeFiles, { |x| US_Upper( x ) == US_Upper( US_FileNameOnlyNameAndExt( vLibIncludeFiles[i] ) ) } ) == 0
                        Out := Out + PUB_cCharTab + 'echo ' + US_ShortName( vLibIncludeFiles[i] ) + ' + >> ' + Q_SCRIPT_FILE + CRLF
                     ENDIF
                  ENDIF
               ENDIF
            NEXT i

         OTHERWISE
            US_Log( 'Error 6127' )
         ENDCASE

         IF IsMinGW
            Out := Out + PUB_cCharTab + 'echo PATH( ' + ;
                         US_ShortName( GetCppFolder() ) + DEF_SLASH + 'BIN;' + ;
                         US_ShortName( GetHarbourFolder() ) + DEF_SLASH + 'BIN' + ;
                         ' ) >> ' + Q_SCRIPT_FILE + CRLF
         ENDIF

      CASE Prj_Radio_OutputType == DEF_RG_LIB
         FOR i := 1 TO Len ( PRGFILES )
            DO CASE
               CASE IsMinGW
               CASE IsPelles
                  IF i == 1
                     Out := Out + PUB_cCharTab + 'echo /out:$@ ' + '> ' + Q_SCRIPT_FILE + CRLF
                  ENDIF
                  Out := Out + PUB_cCharTab + 'echo $(DIR_OBJECTS)' + DEF_SLASH + US_FileNameOnlyName( PRGFILES[i] ) + '.obj ' + '>> ' + Q_SCRIPT_FILE + CRLF
               CASE IsBorland
                  // La siguiente linea tiene el string *AMPERSAND* porque en el sistema operativo Windows 2003 Server Enterprise Edition si codifico el & no funciona el PIPE (>)
                  Out := Out + PUB_cCharTab + 'echo +$(DIR_OBJECTS)' + DEF_SLASH + US_FileNameOnlyName( PRGFILES[i] ) + '.obj ' + iif(i<Len( PRGFILES ),'*AMPERSAND* ',' ') + iif(i>1,'>','') + '> ' + Q_SCRIPT_FILE + CRLF
               OTHERWISE
                  US_Log( 'Error 6143' )
            ENDCASE
         NEXT i
      OTHERWISE
         MyMsgStop( 'Invalid Output Type: ' + cOutputType() )
         BUILD_IN_PROGRESS := .F.
         RETURN .F.
      ENDCASE

      DO EVENTS

/*
 * Add command for linking to script.ld
 */
      DO CASE
      CASE IsMinGw
         DO CASE
         CASE Prj_Radio_OutputType == DEF_RG_EXE
            Out := Out + PUB_cCharTab + '$(US_MSG_EXE) ' + Q_PROGRESS_LOG + ' -MSG:Linking ' + cOutputNameDisplay + ' ...' + CRLF
            Out := Out + PUB_cCharTab + '$(ILINK_EXE) QPM' + LISTOLOG + ;
                        '-Wall ' + iif( Prj_Check_Console, '-mconsole ', '-mwindows ' ) + iif( Prj_Check_64bits, '-m64 ', '' ) + ;
                         iif( ! Empty( GetProperty( 'VentanaMain', 'OverrideLink', 'value' ) ), '$(USER_FLAGS_LINK) ', "" ) + ;
                        Q_SCRIPT_FILE + ;
                        ' -o$(APP_NAME)' + CRLF
            IF Prj_Check_Upx
               Out := Out + PUB_cCharTab + '$(US_MSG_EXE) ' + Q_PROGRESS_LOG + ' -MSG:Compressing ' + cOutputNameDisplay + ' with UPX ...' + CRLF
               Out := Out + PUB_cCharTab + '$(US_UPX_EXE) ' + cUpxOpt + ' ' + cOutputName + ' ' + CRLF
            ENDIF
         CASE Prj_Radio_OutputType == DEF_RG_LIB
            Out := Out + PUB_cCharTab + '$(US_MSG_EXE) ' + Q_PROGRESS_LOG + ' -MSG:Making Library ' + cOutputNameDisplay + ' ...' + CRLF
/*
 * Grabo lista de objetos derivados de los .prg 
 */
            FOR i := 1 TO Len ( PRGFILES )
               Out := Out + PUB_cCharTab + '$(TLIB_EXE) rc ' + cOutputName + ' $(DIR_OBJECTS)' + DEF_SLASH + US_FileNameOnlyName( PRGFILES[i] ) + '.o' + CRLF
            NEXT i
/*
 * Grabo los objetos listados en las Include Libraries marcados *FIRST* que no estén excluidos
 */
            FOR i := 1 TO Len ( vLibIncludeFiles )
               IF Upper( US_FileNameOnlyExt( vLibIncludeFiles[i] ) ) == 'O'
                  IF US_Upper( US_Word( GetProperty( 'VentanaMain', 'GIncFiles', 'Cell', i, NCOLINCFULLNAME ), 2 ) ) == '*FIRST*'
                     IF ! ( US_Upper( US_FileNameOnlyName( vLibIncludeFiles[i] ) ) $ ( 'MAINSTD' + CRLF + 'MAINWIN' ) )
                        IF AScan( vLibExcludeFiles, { |x| US_Upper( x ) == US_Upper( US_FileNameOnlyPathAndName( vLibsToLink[i] ) ) } ) == 0
                           IF File( vLibIncludeFiles[i] )
                              Out := Out + PUB_cCharTab + '$(TLIB_EXE) rc ' + cOutputName + ' ' + vLibIncludeFiles[i] + CRLF
                           ENDIF
                        ENDIF
                     ENDIF
                  ENDIF
               ENDIF
            NEXT i
/*
 * Grabo los objetos listados en las Default Libraries que no estén excluidos
 */
            FOR i := 1 TO Len( vLibsToLink )
               IF Upper( US_FileNameOnlyExt( vLibsToLink[i] ) ) == 'O'
                  IF AScan( vLibExcludeFiles, { |x| US_Upper( x ) == US_Upper( vLibsToLink[i] ) } ) == 0
                     IF File( GetMiniGuiFolder() + DEF_SLASH + 'RESOURCES' + DEF_SLASH + vLibsToLink[i] )
                        Out := Out + PUB_cCharTab + '$(TLIB_EXE) rc ' + cOutputName + ' ' + GetMiniGuiFolder() + DEF_SLASH + 'RESOURCES' + DEF_SLASH + vLibsToLink[i] + CRLF
                     ELSEIF File( PUB_cProjectFolder + DEF_SLASH + vLibsToLink[i] )
                        Out := Out + PUB_cCharTab + '$(TLIB_EXE) rc ' + cOutputName + ' ' + PUB_cProjectFolder + DEF_SLASH + vLibsToLink[i] + CRLF
                     ELSEIF File( GetCppLibFolder() + DEF_SLASH + vLibsToLink[i] )
                        Out := Out + PUB_cCharTab + '$(TLIB_EXE) rc ' + cOutputName + ' ' + GetCppLibFolder() + DEF_SLASH + vLibsToLink[i] + CRLF
                     ENDIF
                  ENDIF
               ENDIF
            NEXT i
/*
 * Grabo los objetos listados en las Include Libraries marcados *LAST* que no estén excluidos
 */
            FOR i := 1 TO Len ( vLibIncludeFiles )
               IF Upper( US_FileNameOnlyExt( vLibIncludeFiles[i] ) ) == 'O'
                  IF US_Upper( US_Word( GetProperty( 'VentanaMain', 'GIncFiles', 'Cell', i, NCOLINCFULLNAME ), 2 ) ) == '*LAST*'
                     IF ! ( US_Upper( US_FileNameOnlyName( vLibIncludeFiles[i] ) ) $ ( 'MAINSTD' + CRLF + 'MAINWIN' ) )
                        IF AScan( vLibExcludeFiles, { |x| US_Upper( x ) == US_Upper( US_FileNameOnlyPathAndName( vLibsToLink[i] ) ) } ) == 0
                           IF File( vLibIncludeFiles[i] )
                              Out := Out + PUB_cCharTab + '$(TLIB_EXE) rc ' + cOutputName + ' ' + vLibIncludeFiles[i] + CRLF
                           ENDIF
                        ENDIF
                     ENDIF
                  ENDIF
               ENDIF
            NEXT i
         OTHERWISE
            Out := Out + PUB_cCharTab + '$(US_MSG_EXE) ' + Q_PROGRESS_LOG + ' -MSG:Output Type Invalid: '+ US_VarToStr( Prj_Radio_OutputType ) + CRLF
         ENDCASE
      CASE IsPelles
         DO CASE
         CASE Prj_Radio_OutputType == DEF_RG_EXE
            Out := Out + PUB_cCharTab + '$(US_MSG_EXE) ' + Q_PROGRESS_LOG + ' -MSG:Linking ' + cOutputNameDisplay + ' ...' + CRLF
            IF Empty( GetProperty( 'VentanaMain', 'OverrideLink', 'value' ) )
               Out := Out + PUB_cCharTab + '$(ILINK_EXE) ' + iif( Prj_Check_Console, '/SUBSYSTEM:CONSOLE ', '/SUBSYSTEM:WINDOWS ' ) + '@' + Q_SCRIPT_FILE + CRLF
            ELSE
               Out := Out + PUB_cCharTab + '$(ILINK_EXE) ' + iif( Prj_Check_Console, '/SUBSYSTEM:CONSOLE ', '/SUBSYSTEM:WINDOWS ' ) + '$(USER_FLAGS_LINK) ' + '@' + Q_SCRIPT_FILE + CRLF
            ENDIF
            IF Prj_Check_Upx
               Out := Out + PUB_cCharTab + '$(US_MSG_EXE) ' + Q_PROGRESS_LOG + ' -MSG:Compressing ' + cOutputNameDisplay + ' with UPX ...' + CRLF
               Out := Out + PUB_cCharTab + '$(US_UPX_EXE) ' + cUpxOpt + ' ' + cOutputName + CRLF
            ENDIF
         CASE Prj_Radio_OutputType == DEF_RG_LIB
            Out := Out + PUB_cCharTab + '$(US_MSG_EXE) ' + Q_PROGRESS_LOG + ' -MSG:Making Library ' + cOutputNameDisplay + ' ...' + CRLF
            Out := Out + PUB_cCharTab + '$(TLIB_EXE) @' + Q_SCRIPT_FILE + CRLF
         OTHERWISE
            Out := Out + PUB_cCharTab + '$(US_MSG_EXE) ' + Q_PROGRESS_LOG + ' -MSG:Output Type Invalid: '+ US_VarToStr( Prj_Radio_OutputType ) + CRLF
         ENDCASE
      CASE IsBorland
         DO CASE
         CASE Prj_Radio_OutputType == DEF_RG_EXE
            Out := Out + PUB_cCharTab + '$(US_MSG_EXE) ' + Q_PROGRESS_LOG + ' -MSG:Linking ' + cOutputNameDisplay + ' ...' + CRLF
            w_LibFolders := GetCppLibFolder()
            w_LibFolders += ";" + w_LibFolders + "\PSDK;"
            IF Empty( GetProperty( 'VentanaMain', 'OverrideLink', 'value' ) )
               Out := Out + PUB_cCharTab + '$(ILINK_EXE) -x -Gn -Tpe ' + iif( Prj_Check_Console, '-ap ', '-aa ' ) + '-L' + w_LibFolders + ' @' + Q_SCRIPT_FILE + CRLF
            ELSE
               Out := Out + PUB_cCharTab + '$(ILINK_EXE) -x -Gn -Tpe ' + iif( Prj_Check_Console, '-ap ', '-aa ') + '$(USER_FLAGS_LINK) -L' + w_LibFolders + ' @' + Q_SCRIPT_FILE + CRLF
            ENDIF
            IF Prj_Check_Upx
               Out := Out + PUB_cCharTab + '$(US_MSG_EXE) ' + Q_PROGRESS_LOG + ' -MSG:Compressing ' + cOutputNameDisplay + ' with UPX ...' + CRLF
               Out := Out + PUB_cCharTab + '$(US_UPX_EXE) ' + cUpxOpt + ' ' + cOutputName + CRLF
            ENDIF
         CASE Prj_Radio_OutputType == DEF_RG_LIB
            Out := Out + PUB_cCharTab + '$(US_MSG_EXE) ' + Q_PROGRESS_LOG + ' -MSG:Making Library ' + cOutputNameDisplay + ' ...' + CRLF
            // La siguiente linea tiene el string *AMPERSAND* porque en el sistema operativo Windows 2003 Server Enterprise Edition si codifico el & no funciona el PIPE (>)
            Out := Out + PUB_cCharTab + '@$(US_SHELL_EXE) QPM' + LISTOLOG + ' CHANGE ' + Q_SCRIPT_FILE + ' *AMPERSAND* & ' + CRLF
            Out := Out + PUB_cCharTab + '$(TLIB_EXE) /P32 $@ @' + Q_SCRIPT_FILE + CRLF
         OTHERWISE
            Out := Out + PUB_cCharTab + '$(US_MSG_EXE) ' + Q_PROGRESS_LOG + ' -MSG:Output Type Invalid: '+ US_VarToStr( Prj_Radio_OutputType ) + CRLF
         ENDCASE
      OTHERWISE
         US_Log( 'Error 6255' )
      ENDCASE

      // Copy or Move
      IF Prj_Radio_OutputCopyMove # DEF_RG_NONE
         Out := Out + PUB_cCharTab + '$(US_MSG_EXE) ' + Q_PROGRESS_LOG + ' -MSG:' + cOutputCopyMove() + ' ' + cOutputNameDisplay + ' to ' + Prj_Text_OutputCopyMoveFolder + DEF_SLASH + US_FileNameOnlyNameAndExt( cOutputNameDisplay ) + ' ...' + CRLF
         Out := Out + PUB_cCharTab + '@$(US_SHELL_EXE) QPM' + LISTOLOG + cOutputCopyMove() + ' ' + cOutputName + ' ' + US_ShortName( Prj_Text_OutputCopyMoveFolder ) + DEF_SLASH + US_FileNameOnlyNameAndExt( cOutputName ) + CRLF
      ENDIF

      IF PUB_bDebugActive
         IF Prj_Radio_OutputCopyMove == DEF_RG_MOVE
            DebugOptions( US_ShortName( Prj_Text_OutputCopyMoveFolder ), cDebugPath )
         ELSE
            IF Prj_Radio_OutputCopyMove == DEF_RG_COPY
               DebugOptions( US_ShortName( Prj_Text_OutputCopyMoveFolder ), cDebugPath )
            ENDIF
            DebugOptions( US_FileNameOnlyPath( cOutputName ), cDebugPath )
         ENDIF
         IF ! Empty( VentanaMain.TRunProjectFolder.Value )
            DebugOptions( US_FileNameOnlyPath( VentanaMain.TRunProjectFolder.Value ), cDebugPath )
         ENDIF
      ENDIF

      DO EVENTS

/*
 * Add commands for compiling to script.ld
 */
      FOR i := 1 TO Len ( PRGFILES )
         Out := Out + CRLF
         Out := Out + '$(C_DIR)' + DEF_SLASH + US_FileNameOnlyName( PRGFILES[i] ) + '.' + iif( Upper( US_FileNameOnlyExt( PRGFILES[i] ) ) == 'CPP', 'cpp', 'c' ) + ' : ' + US_ShortName( US_FileNameOnlyPath( PRGFILES[i] ) ) + DEF_SLASH + US_FileNameOnlyNameAndExt( PRGFILES[i] ) + CRLF
         Out := Out + PUB_cCharTab + '$(US_MSG_EXE) ' + Q_PROGRESS_LOG + ' -MSG:Processing ' + PRGFILES[i] + ' ...' + CRLF
         IF Upper( US_FileNameOnlyExt( PRGFILES[i] ) ) == US_Upper( 'C' ) .OR. ;
            Upper( US_FileNameOnlyExt( PRGFILES[i] ) ) == US_Upper( 'CPP' )
            Out := Out + PUB_cCharTab + '@$(US_SHELL_EXE) QPM' + LISTOLOG + 'COPYZAP $< $@' + CRLF
         ELSE
            Out := Out + PUB_cCharTab + '@$(US_SHELL_EXE) QPM' + LISTOLOG + 'DELETE $@' + CRLF
            IF QPM_IsXHarbour()
               Out := Out + PUB_cCharTab + '$(HARBOUR_EXE) $(HARBOUR_FLAGS) /q /po' + US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + US_FileNameOnlyName( PRGFILES[i] ) + '.ppo $< -o$@' + CRLF
            ELSE
               Out := Out + PUB_cCharTab + '$(HARBOUR_EXE) $(HARBOUR_FLAGS) /q /p' + US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + US_FileNameOnlyName( PRGFILES[i] ) + '.ppo $< -o$@' + CRLF
            ENDIF
            Out := Out + PUB_cCharTab + '@$(US_SHELL_EXE) QPM' + LISTOLOG + 'MOVE ' + US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + US_FileNameOnlyName( PRGFILES[i] ) + '.ppo $(DIR_OBJECTS)' + DEF_SLASH + US_FileNameOnlyName( PRGFILES[i] ) + '.ppo' + CRLF
            Out := Out + PUB_cCharTab + '@$(US_SHELL_EXE) QPM' + LISTOLOG + 'DELETE ' + US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + US_FileNameOnlyName( PRGFILES[i] ) + '.ppo.MOVED.TXT' + CRLF
            Out := Out + PUB_cCharTab + '@$(US_SHELL_EXE) QPM' + LISTOLOG + 'CHECKRC NOTFILE $@' + CRLF
         ENDIF
         Out := Out + CRLF
         IF IsMinGW
            Out := Out + '$(DIR_OBJECTS)' + DEF_SLASH + US_FileNameOnlyName( PRGFILES[i] ) + '.o : $(C_DIR)' + DEF_SLASH + US_FileNameOnlyName( PRGFILES[i] ) + '.' + iif( Upper( US_FileNameOnlyExt( PRGFILES[i] ) ) == 'CPP', 'cpp', 'c' ) + CRLF
         ELSE
            Out := Out + '$(DIR_OBJECTS)' + DEF_SLASH + US_FileNameOnlyName( PRGFILES[i] ) + '.obj : $(C_DIR)' + DEF_SLASH + US_FileNameOnlyName( PRGFILES[i] ) + '.' + iif( Upper( US_FileNameOnlyExt( PRGFILES[i] ) ) == 'CPP', 'cpp', 'c' ) + CRLF
         ENDIF
         Out := Out + PUB_cCharTab + '$(US_MSG_EXE) ' + Q_PROGRESS_LOG + ' -MSG:Processing ' + US_FileNameOnlyName( PRGFILES[i] ) + '.' + iif( Upper( US_FileNameOnlyExt( PRGFILES[i] ) ) == 'CPP', 'cpp', 'c' ) + ' ...' + CRLF
         Out := Out + PUB_cCharTab + '@$(US_SHELL_EXE) QPM' + LISTOLOG + 'DELETE $@' + CRLF
         DO CASE
         CASE IsMinGW
            Out := Out + PUB_cCharTab + '$(COMPILATOR_C) QPM' + LISTOLOG + '$(COBJFLAGS) $< -o$@' + CRLF
         CASE IsPelles
            Out := Out + PUB_cCharTab + '$(COMPILATOR_C) $(COBJFLAGS) /Fo$@ $<' + CRLF
         CASE IsBorland
            Out := Out + PUB_cCharTab + '$(COMPILATOR_C) $(COBJFLAGS) -o$@ $<' + CRLF
         OTHERWISE
            US_Log( 'Error 6324' )
         ENDCASE
         Out := Out + PUB_cCharTab + '@$(US_SHELL_EXE) QPM' + LISTOLOG + 'CHECKRC NOTFILE $@' + CRLF
      NEXT i

   ENDIF

   IF Prj_Radio_OutputType == DEF_RG_IMPORT
      Out := Out + '$(APP_NAME) : ' + US_ShortName( PRGFILES[1] ) + CRLF
      DO CASE
         CASE PUB_cConvert == 'DLL A'
            IF GetProperty( 'VentanaMain', 'Check_Reimp', 'Value' )
               Out := Out + PUB_cCharTab + '$(US_MSG_EXE) ' + Q_PROGRESS_LOG + ' -MSG:ReImport from library ' + cInputReImpNameDisplay + CRLF
               Out := Out + PUB_cCharTab + '$(REIMPORT_EXE) -d ' + cInputReImpName + CRLF
               Out := Out + PUB_cCharTab + '$(US_MSG_EXE) ' + Q_PROGRESS_LOG + ' -MSG:DLL functions list for ' + cInputNameDisplay + ' ...' + CRLF
               Out := Out + PUB_cCharTab + '@$(US_SHELL_EXE) QPM' + LISTOLOG + 'ANALIZE_DLL ' + cInputReImpDef + CRLF
               Out := Out + PUB_cCharTab + '$(US_MSG_EXE) ' + Q_PROGRESS_LOG + ' -MSG:Generating interface library (.' + US_Word( PUB_cConvert, 2 ) + ') FOR ' + cInputNameDisplay + ' ...' + CRLF
               Out := Out + PUB_cCharTab + '$(IMPLIB_MGW_EXE) -k -d ' + US_USlash( cInputReImpDef ) + ' -D ' + US_FileNameOnlyNameAndExt( cInputNameDisplay ) + ' -l ' + US_USlash( cOutputName ) + CRLF
               Out := Out + PUB_cCharTab + '@$(US_SHELL_EXE) QPM' + LISTOLOG + 'DELETE ' + cInputReImpDef + CRLF
            ELSE
               Out := Out + PUB_cCharTab + '$(US_MSG_EXE) ' + Q_PROGRESS_LOG + ' -MSG:DLL functions list for ' + cInputNameDisplay + ' ...' + CRLF
               Out := Out + PUB_cCharTab + '$(IMPDEF_MGW_EXE) ' + cInputNameLong + ' > ' + cInputNameLong + '.def ' + CRLF
               Out := Out + PUB_cCharTab + '@$(US_SHELL_EXE) QPM' + LISTOLOG + 'ANALIZE_DLL ' + cInputNameLong + '.def ' + CRLF
               Out := Out + PUB_cCharTab + '$(US_MSG_EXE) ' + Q_PROGRESS_LOG + ' -MSG:Generating interface library (.' + US_Word( PUB_cConvert, 2 ) + ') for ' + cInputNameDisplay + ' ...' + CRLF
               Out := Out + PUB_cCharTab + '$(IMPLIB_MGW_EXE) -d ' + US_USlash( cInputNameLong ) + '.def -D ' + US_FileNameOnlyNameAndExt( cInputNameDisplay ) + ' -l ' + US_USlash( cOutputName ) + CRLF
               Out := Out + PUB_cCharTab + '@$(US_SHELL_EXE) QPM' + LISTOLOG + 'DELETE ' + cInputNameLong + '.def' + CRLF
            ENDIF
         CASE PUB_cConvert == 'DLL LIB'
            DO CASE
               CASE Prj_Radio_Cpp == DEF_RG_PELLES
                  Out := Out + PUB_cCharTab + '$(US_MSG_EXE) ' + Q_PROGRESS_LOG + ' -MSG:DLL functions list for ' + cInputNameDisplay + ' ...' + CRLF
                  Out := Out + PUB_cCharTab + '$(IMPDEF_PC_EXE) ' + cInputNameLong + '.def ' + cInputNameLong + CRLF
                  Out := Out + PUB_cCharTab + '@$(US_SHELL_EXE) QPM' + LISTOLOG + 'ANALIZE_DLL ' + cInputNameLong + '.def ' + CRLF
                  //
                  Out := Out + PUB_cCharTab + '$(US_MSG_EXE) ' + Q_PROGRESS_LOG + ' -MSG:Generating interface library (.' + US_Word( PUB_cConvert, 2 ) + ') for ' + cInputNameDisplay + ' ...' + CRLF
                  Out := Out + PUB_cCharTab + '$(IMPLIB_PC_EXE) ' + iif( GetProperty( 'VentanaMain', 'Check_GuionA', 'Value' ), '', '-NOUND ' ) + cInputNameLong + ' -OUT:' + cOutputName + CRLF
                  //
                  Out := Out + PUB_cCharTab + '@$(US_SHELL_EXE) QPM' + LISTOLOG + 'DELETE ' + cInputNameLong + '.def' + CRLF
               CASE Prj_Radio_Cpp == DEF_RG_BORLAND
                  Out := Out + PUB_cCharTab + '$(US_MSG_EXE) ' + Q_PROGRESS_LOG + ' -MSG:DLL functions list for ' + cInputNameDisplay + ' ...' + CRLF
                  Out := Out + PUB_cCharTab + '$(IMPDEF_BCC_EXE) ' + cInputNameLong + '.def ' + cInputNameLong + CRLF
                  Out := Out + PUB_cCharTab + '@$(US_SHELL_EXE) QPM' + LISTOLOG + 'ANALIZE_DLL ' + cInputNameLong + '.def ' + CRLF
                  //
                  Out := Out + PUB_cCharTab + '$(US_MSG_EXE) ' + Q_PROGRESS_LOG + ' -MSG:Generating Interface Library (.' + US_Word( PUB_cConvert, 2 ) + ') for ' + cInputNameDisplay + ' ...' + CRLF
                  Out := Out + PUB_cCharTab + '$(IMPLIB_BCC_EXE) ' + iif( GetProperty( 'VentanaMain', 'Check_GuionA', 'Value' ), '-a ', '' ) + cOutputName + ' ' + cInputNameLong + CRLF
                  //
                  Out := Out + PUB_cCharTab + '@$(US_SHELL_EXE) QPM' + LISTOLOG + 'DELETE ' + cInputNameLong + '.def' + CRLF
               OTHERWISE
                  US_Log( 'Error in Convert DLL to LIB, Invalid C Compiler: ' + US_VarToStr( Prj_Radio_Cpp ) )
            ENDCASE
         CASE PUB_cConvert == 'LIB DLL'
            Out := Out + PUB_cCharTab + '$(US_MSG_EXE) ' + Q_PROGRESS_LOG + ' -MSG:Copying Library (.' + US_Word( PUB_cConvert, 1 ) + ') to Working Folder' + ' ...' + CRLF
            Out := Out + PUB_cCharTab + '@$(US_SHELL_EXE) QPM' + LISTOLOG + 'COPY ' + cInputName + ' ' + OBJFOLDER + DEF_SLASH + US_FileNameOnlyNameAndExt( cInputName ) + CRLF
            //
            Out := Out + PUB_cCharTab + '$(US_MSG_EXE) ' + Q_PROGRESS_LOG + ' -MSG:Listing Functions in Library (.' + US_Word( PUB_cConvert, 1 ) + ')' + ' ...' + CRLF
            Out := Out + PUB_cCharTab + '$(LSTLIB_EXE) ' + OBJFOLDER + DEF_SLASH + US_FileNameOnlyNameAndExt( cInputName ) + ', ' + OBJFOLDER + DEF_SLASH + US_FileNameOnlyNameAndExt( cInputName ) + '.lst ' + CRLF
            Out := Out + PUB_cCharTab + '@$(US_SHELL_EXE) QPM' + LISTOLOG + 'ANALIZE_LIB_BORLAND ' + OBJFOLDER + DEF_SLASH + US_FileNameOnlyNameAndExt( cInputName ) + '.lst ' + CRLF
            //
            QPM_Execute( US_ShortName(PUB_cQPM_Folder) + DEF_SLASH + 'US_TLIB.EXE', cInputName + ', ' + OBJFOLDER + DEF_SLASH + US_FileNameOnlyNameAndExt( cInputName ) + '.lst', DEF_QPM_EXEC_WAIT, DEF_QPM_EXEC_MINIMIZE )
            QPM_Execute( US_ShortName(PUB_cQPM_Folder) + DEF_SLASH + 'US_SHELL.EXE', 'QPM' + LISTOLOG + 'ANALIZE_LIB_BORLAND ' + OBJFOLDER + DEF_SLASH + US_FileNameOnlyNameAndExt( cInputName ) + '.lst -OBJLST -EXPLST', DEF_QPM_EXEC_WAIT, DEF_QPM_EXEC_MINIMIZE )
            //
            MemoObj := MemoRead( OBJFOLDER + DEF_SLASH + US_FileNameOnlyNameAndExt( cInputName ) + '.Lst.ObjLst' )
            //
            Out := Out + PUB_cCharTab + '$(US_MSG_EXE) ' + Q_PROGRESS_LOG + ' -MSG:Extracting Modules from Library (.' + US_Word( PUB_cConvert, 1 ) + ')' + ' ...' + CRLF
            Out := Out + PUB_cCharTab + '$(TLIB_EXE) ' + OBJFOLDER + DEF_SLASH + US_FileNameOnlyNameAndExt( cInputName )
            FOR i := 1 TO MLCount( MemoObj, 254 )
               Out := Out + PUB_cCharTab + '*' + OBJFOLDER + DEF_SLASH + AllTrim( memoline( MemoObj, 254, i ) )
            NEXT
            Out := Out + ' ' + CRLF
            Out := Out + PUB_cCharTab + '$(US_MSG_EXE) ' + Q_PROGRESS_LOG + ' -MSG:Making DLL from Modules Object of Library (.' + US_Word( PUB_cConvert, 1 ) + ') in ' + cOutputNameDisplay + ' ...' + CRLF
            Out := Out + PUB_cCharTab + '$(ILINK_EXE) ' + iif( !Prj_Check_Console, '-Gn -Tpd '+iif(PUB_bDebugActive,'-ap ','-aa '), '-Gn -Tpd ' ) + '-L' + GetCppLibFolder()
            FOR i := 1 TO MLCount( MemoObj, 254 )
               Out := Out + ' ' + OBJFOLDER + DEF_SLASH + AllTrim( memoline( MemoObj, 254, i ) ) + '.obj'
            NEXT
            Out := Out + ' c0d32.obj, ' + cOutputName + ',, import32.lib msimg32.lib cw32.lib, '
            Out := Out + ' ' + OBJFOLDER + DEF_SLASH + US_FileNameOnlyNameAndExt( cInputName ) + '.Lst.ExpLst' + CRLF
            //
            Out := Out + PUB_cCharTab + '$(US_MSG_EXE) ' + Q_PROGRESS_LOG + ' -MSG:DLL functions list for ' + cOutputNameDisplay + ' ...' + CRLF
            Out := Out + PUB_cCharTab + '$(IMPDEF_BCC_EXE) ' + cOutputName + '.def ' + cOutputName + CRLF
            Out := Out + PUB_cCharTab + '@$(US_SHELL_EXE) QPM' + LISTOLOG + 'ANALIZE_DLL ' + cOutputName + '.def -DELETE' + CRLF
            //
            Out := Out + PUB_cCharTab + '$(US_MSG_EXE) ' + Q_PROGRESS_LOG + ' -MSG:Cleaning temporary files' + ' ...' + CRLF
            Out := Out + PUB_cCharTab + '@$(US_SHELL_EXE) QPM' + LISTOLOG + 'DELETE ' + OBJFOLDER + DEF_SLASH + US_FileNameOnlyNameAndExt( cInputName ) + CRLF
            Out := Out + PUB_cCharTab + '@$(US_SHELL_EXE) QPM' + LISTOLOG + 'DELETE ' + OBJFOLDER + DEF_SLASH + US_FileNameOnlyNameAndExt( cInputName ) + '.lst' + CRLF
            FOR i := 1 TO MLCount( MemoObj, 254 )
               Out := Out + PUB_cCharTab + '@$(US_SHELL_EXE) QPM' + LISTOLOG + 'DELETE ' + OBJFOLDER + DEF_SLASH + AllTrim( memoline( MemoObj, 254, i ) ) + '.obj' + CRLF
            NEXT
            Out := Out + PUB_cCharTab + '@$(US_SHELL_EXE) QPM' + LISTOLOG + 'DELETE ' + OBJFOLDER + DEF_SLASH + US_FileNameOnlyNameAndExt( cInputName ) + '.lst.ObjLst' + CRLF
            Out := Out + PUB_cCharTab + '@$(US_SHELL_EXE) QPM' + LISTOLOG + 'DELETE ' + OBJFOLDER + DEF_SLASH + US_FileNameOnlyNameAndExt( cInputName ) + '.lst.ExpLst' + CRLF
         CASE PUB_cConvert == 'A DLL'
            Out := Out + PUB_cCharTab + '$(US_MSG_EXE) ' + Q_PROGRESS_LOG + ' -MSG:Copying Library (.' + US_Word( PUB_cConvert, 1 ) + ') to Working Folder' + ' ...' + CRLF
            Out := Out + PUB_cCharTab + '@$(US_SHELL_EXE) QPM COPY ' + cInputName + ' ' + OBJFOLDER + DEF_SLASH + US_FileNameOnlyNameAndExt( cInputName ) + CRLF
            //
            Out := Out + PUB_cCharTab + '$(US_MSG_EXE) ' + Q_PROGRESS_LOG + ' -MSG:Listing Functions in Library (.' + US_Word( PUB_cConvert, 1 ) + ')' + ' ...' + CRLF
            Out := Out + PUB_cCharTab + '$(LSTA_EXE) -x ' + OBJFOLDER + DEF_SLASH + US_FileNameOnlyNameAndExt( cInputName ) + ' > ' + OBJFOLDER + DEF_SLASH + US_FileNameOnlyNameAndExt( cInputName ) + '.lst ' + CRLF
            Out := Out + PUB_cCharTab + '@$(US_SHELL_EXE) QPM' + LISTOLOG + 'ANALIZE_LIB_MINGW ' + OBJFOLDER + DEF_SLASH + US_FileNameOnlyNameAndExt( cInputName ) + '.lst ' + CRLF
            //
            QPM_LogText( "A DLL" )
            QPM_MemoWrit( RUN_FILE, US_ShortName(PUB_cQPM_Folder) + DEF_SLASH + 'US_OBJDUMP.EXE -t ' + cInputName + ' > ' + OBJFOLDER + DEF_SLASH + US_FileNameOnlyNameAndExt( cInputName ) + '.lst' )
            QPM_LogFile( RUN_FILE )
            QPM_Execute( RUN_FILE, "", DEF_QPM_EXEC_WAIT, DEF_QPM_EXEC_MINIMIZE )
            QPM_LogText( "Done" )
            FErase( RUN_FILE )
            QPM_Execute( US_ShortName(PUB_cQPM_Folder) + DEF_SLASH + 'US_SHELL.EXE', 'QPM ANALIZE_LIB_MINGW ' + OBJFOLDER + DEF_SLASH + US_FileNameOnlyNameAndExt( cInputName ) + '.lst -OBJLST -EXPLST', DEF_QPM_EXEC_WAIT, DEF_QPM_EXEC_MINIMIZE )
            //
            MemoObj := MemoRead( OBJFOLDER + DEF_SLASH + US_FileNameOnlyNameAndExt( cInputName ) + '.Lst.ObjLst' )
            //
            Out := Out + PUB_cCharTab + '$(US_MSG_EXE) ' + Q_PROGRESS_LOG + ' -MSG:Extracting Modules from Library (.' + US_Word( PUB_cConvert, 1 ) + ')' + ' ...' + CRLF
            Out := Out + PUB_cCharTab + '$(TLIB_EXE) x ' + OBJFOLDER + DEF_SLASH + US_FileNameOnlyNameAndExt( cInputName )
            FOR i := 1 TO MLCount( MemoObj, 254 )
               Out := Out + ' ' + AllTrim( memoline( MemoObj, 254, i ) ) + '.o'
            NEXT
            Out := Out + ' ' + CRLF
            //
            Out := Out + PUB_cCharTab + '$(US_MSG_EXE) ' + Q_PROGRESS_LOG + ' -MSG:Making DLL from Modules Object of Library (.' + US_Word( PUB_cConvert, 1 ) + ') in ' + cOutputNameDisplay + ' ...' + CRLF
            Out := Out + PUB_cCharTab + '$(ILINK_EXE) -shared -o' + cOutputName + ' '
            FOR i := 1 TO MLCount( MemoObj, 254 )
               Out := Out + ' ' + US_ShortName( GetCppFolder() ) + DEF_SLASH + 'BIN' + DEF_SLASH + AllTrim( memoline( MemoObj, 254, i ) ) + '.o '
            NEXT
            Out := Out + iif( Prj_Check_Console, ' -mconsole', ' -mwindows' ) + ;
                   ' -L$(DIR_COMPC_LIB)' + ;
                   ' -L$(DIR_MINIGUI_LIB)' + ;
                   ' -L$(DIR_HARBOUR_LIB)' + CRLF
            //
            Out := Out + PUB_cCharTab + '$(US_MSG_EXE) ' + Q_PROGRESS_LOG + ' -MSG:DLL functions list for ' + cOutputNameDisplay + ' ...' + CRLF
            Out := Out + PUB_cCharTab + '$(IMPDEF_MGW_EXE) ' + cOutputName + ' > ' + cOutputName + '.def ' + CRLF
            Out := Out + PUB_cCharTab + '@$(US_SHELL_EXE) QPM' + LISTOLOG + 'ANALIZE_DLL ' + cOutputName + '.def -DELETE' + CRLF
            //
            Out := Out + PUB_cCharTab + '$(US_MSG_EXE) ' + Q_PROGRESS_LOG + ' -MSG:Cleaning Temporary Files' + ' ...' + CRLF
            Out := Out + PUB_cCharTab + '@$(US_SHELL_EXE) QPM' + LISTOLOG + 'DELETE ' + OBJFOLDER + DEF_SLASH + US_FileNameOnlyNameAndExt( cInputName ) + CRLF
            Out := Out + PUB_cCharTab + '@$(US_SHELL_EXE) QPM' + LISTOLOG + 'DELETE ' + OBJFOLDER + DEF_SLASH + US_FileNameOnlyNameAndExt( cInputName ) + '.lst' + CRLF
            FOR i := 1 TO MLCount( MemoObj, 254 )
               Out := Out + PUB_cCharTab + '@$(US_SHELL_EXE) QPM' + LISTOLOG + 'DELETE ' + US_ShortName( GetCppFolder() ) + DEF_SLASH + 'BIN' + DEF_SLASH + AllTrim( memoline( MemoObj, 254, i ) ) + '.o' + CRLF
            NEXT
            Out := Out + PUB_cCharTab + '@$(US_SHELL_EXE) QPM' + LISTOLOG + 'DELETE ' + OBJFOLDER + DEF_SLASH + US_FileNameOnlyNameAndExt( cInputName ) + '.lst.ObjLst' + CRLF
            Out := Out + PUB_cCharTab + '@$(US_SHELL_EXE) QPM' + LISTOLOG + 'DELETE ' + OBJFOLDER + DEF_SLASH + US_FileNameOnlyNameAndExt( cInputName ) + '.lst.ExpLst' + CRLF
      ENDCASE
   ENDIF

   DO EVENTS

   QPM_MemoWrit( MAKE_FILE, Out )

   FErase( cOutputName )
   FErase( cOutputName + '.MOVED' )
   FErase( cOutputName + '.MOVED.TXT' )
   FErase( US_ShortName( Prj_Text_OutputCopyMoveFolder ) + DEF_SLASH + US_FileNameOnlyNameAndExt( cOutputName ) )

   DO EVENTS

/*
 * Create BUILD.BAT
 */
      cB_TMP_ERR := ( DBLQT + PUB_cProjectFolder + DEF_SLASH + '_' + PUB_cSecu + 'TEMP.ERR' + DBLQT )
      cB_RC_FOLD := ( GetMiniGuiFolder() + DEF_SLASH + 'RESOURCES' )
      cB_RC_MINI := ( DBLQT + cB_RC_FOLD+ DEF_SLASH + cRCFileName + DBLQT )
      cB_RC_HBPR := ( DBLQT + cB_RC_FOLD + DEF_SLASH + 'HBPRINTER.RC' + DBLQT )
      cB_RC_MIPR := ( DBLQT + cB_RC_FOLD + DEF_SLASH + 'MINIPRINT.RC' + DBLQT )
      cB_RCM_ERR := ( "US_Res from Batch Error: Resource File Not Found: " + cB_RC_MINI )
      cB_RC_CONF := ( DBLQT + PUB_cProjectFolder + DEF_SLASH + GetResConfigFileName() + DBLQT )
      cB_RCF_ERR := ( "US_Res from Batch Error: Can't create ResConfig File: " + cB_RC_CONF )
      cB_US_RES  := ( DBLQT + PUB_cQPM_Folder + DEF_SLASH + 'US_Res.exe' + DBLQT + ' QPM' + LISTOLOG )
   IF File( US_FileNameOnlyPathAndName( PRGFILES[1] ) + '.RC' )
      cB_RC_MAIN := ( US_FileNameOnlyPathAndName( PRGFILES[1] ) + '.RC' )
      cB_RC1_PTH := ( DBLQT + US_FileNameOnlyPath( cB_RC_MAIN ) + "\" + DBLQT )
   ELSE
      cB_RC_MAIN := ( PUB_cProjectFolder + DEF_SLASH + US_FileNameOnlyName( PRGFILES[1] ) + '.RC' )
      cB_RC1_PTH := ( DBLQT + PUB_cProjectFolder + "\" + DBLQT )
   ENDIF
      cB_RC1_SHR := ( DBLQT + US_ShortName( cB_RC_MAIN ) + '1' + DBLQT )
      cB_RC1_FER := ( DBLQT + US_ShortName( cB_RC_MAIN ) + '1.Error' + DBLQT )
      cB_RC2_SHR := ( DBLQT + US_ShortName( cB_RC_MAIN ) + '2' + DBLQT )
      cB_RC2_FER := ( DBLQT + US_ShortName( cB_RC_MAIN ) + '2.Error' + DBLQT )
      cB_RC_MA_S := ( DBLQT + US_ShortName( cB_RC_MAIN ) + DBLQT )
      cB_RC_MAIN := ( DBLQT + cB_RC_MAIN + DBLQT )
      cB_FILLER  := ( DBLQT + PUB_cQPM_Folder + DEF_SLASH + 'FILLER' + DBLQT )
      cB_CPP_BIN := ( US_ShortName( GetCppFolder() + DEF_SLASH + 'BIN' ) )
   IF IsMinGW
      cB_DLLTOOL := ( DBLQT + GetCppFolder() + DEF_SLASH + 'BIN' + DEF_SLASH + 'DLLTOOL.EXE' + DBLQT )
      cB_DLL_ERR := ( "US_Res from Batch Error: DLLTOOL.EXE not found at MinGW's BIN folder" )
      cB_RC_COMP := ( DBLQT + GetCppFolder() + DEF_SLASH + 'BIN' + DEF_SLASH + 'WINDRES.EXE' + DBLQT )
      cB_RCC_ERR := ( "US_Res from Batch Error: WINDRES.EXE not found at MinGW's BIN folder" )
   ELSE
      cB_RC_COMP := ( DBLQT + GetCppFolder() + DEF_SLASH + 'BIN' + DEF_SLASH + 'BRCC32.EXE' + DBLQT )
      cB_RCC_ERR := ( "US_Res from Batch Error: BRCC32.EXE not found at BCC's BIN folder" )
   ENDIF
      cB_US_MAKE := ( DBLQT + PUB_cQPM_Folder + DEF_SLASH + 'US_MAKE.EXE' + DBLQT )
      cB_EXE     := ( DBLQT + cOutputNameDisplay + DBLQT )
      cB_OUTPUT  := ( DBLQT + Prj_Text_OutputCopyMoveFolder + DEF_SLASH + US_FileNameOnlyNameAndExt( cOutputName ) + DBLQT )

   DO CASE
   CASE IsMinGW
                  bld_cmd := '@ECHO OFF'                                                                                        + CRLF
      IF bLogActivity
                  bld_cmd += 'ECHO Writing Activity Log ...'                                                                    + CRLF
      ENDIF
      // delete preexisting temp files
                  bld_cmd += 'IF EXIST ' + cB_TMP_ERR    + ' DEL ' + cB_TMP_ERR    + ' > NUL'                                   + CRLF
                  bld_cmd += 'IF EXIST ' + Q_TEMP_LOG    + ' DEL ' + Q_TEMP_LOG    + ' > NUL'                                   + CRLF
                  bld_cmd += 'IF EXIST ' + Q_SCRIPT_FILE + ' DEL ' + Q_SCRIPT_FILE + ' > NUL'                                   + CRLF
                  bld_cmd += 'IF EXIST ' + Q_QPM_TMP_RC  + ' DEL ' + Q_QPM_TMP_RC  + ' > NUL'                                   + CRLF
                  bld_cmd += 'IF EXIST ' + cB_RC_CONF    + ' DEL ' + cB_RC_CONF    + ' > NUL'                                   + CRLF
                  bld_cmd += 'IF EXIST ' + cB_RC1_SHR    + ' DEL ' + cB_RC1_SHR    + ' > NUL'                                   + CRLF
                  bld_cmd += 'IF EXIST ' + cB_RC2_SHR    + ' DEL ' + cB_RC2_SHR    + ' > NUL'                                   + CRLF
                  bld_cmd += 'IF EXIST ' + cB_RC1_FER    + ' DEL ' + cB_RC1_FER    + ' > NUL'                                   + CRLF
                  bld_cmd += 'IF EXIST ' + cB_RC2_FER    + ' DEL ' + cB_RC2_FER    + ' > NUL'                                   + CRLF
      // concatenate project's and MINIGUI's RC files into a temporary RC file
      IF Prj_Radio_OutputType != DEF_RG_IMPORT .AND. ( ! Prj_Check_IgnoreMainRC .OR. ! Prj_Check_IgnoreLibRCs )
         IF Prj_Check_IgnoreMainRC
            IF ! Prj_Check_IgnoreLibRCs
                  bld_cmd += 'ECHO #define ' + GetResConfigVarName() + ' ' + cB_RC_FOLD + ' > ' + cB_RC_CONF                    + CRLF
                  bld_cmd += 'IF NOT EXIST ' + cB_RC_CONF + ' ECHO ' + cB_RCF_ERR + ' > ' + cB_TMP_ERR                          + CRLF
                  bld_cmd += 'IF NOT EXIST ' + cB_RC_MINI + ' ECHO ' + cB_RCM_ERR + ' > ' + cB_TMP_ERR                          + CRLF
                  bld_cmd += 'COPY /B ' + cB_RC_MINI + ' ' + Q_QPM_TMP_RC + ' > NUL'                                            + CRLF
               lIncludeMiniPrintRC := .F.
               FOR i := 1 TO Len( vLibsToLink )
                  IF ! GetMiniGuiSuffix() == DefineOohg3
                     IF US_Upper( vLibsToLink[i] ) == 'LIBHBPRINTER.A'
                        IF AScan( vLibExcludeFiles, { |x| US_Upper( x ) == 'LIBHBPRINTER.A' } ) == 0
                  bld_cmd += 'COPY /B ' + Q_QPM_TMP_RC + ' + ' + cB_FILLER + ' + ' + cB_RC_HBPR + ' ' + Q_QPM_TMP_RC + ' > NUL' + CRLF
                        ENDIF
                     ELSEIF US_Upper( vLibsToLink[i] ) == 'LIBMINIPRINT.A'
                        IF AScan( vLibExcludeFiles, { |x| US_Upper( x ) == 'LIBMINIPRINT.A' } ) == 0
                           lIncludeMiniPrintRC := .T.
                        ENDIF
                     ENDIF
                  ENDIF
               NEXT i
               IF ! lIncludeMiniPrintRC
                  IF AScan( vLibIncludeFiles, { |x| US_Upper( US_FileNameOnlyNameAndExt( x ) ) == 'LIBMINIPRINT2.A' } ) # 0
                     IF AScan( vLibExcludeFiles, { |x| US_Upper( x ) == 'LIBMINIPRINT2.A' } ) == 0
                        lIncludeMiniPrintRC := .T.
                     ENDIF
                  ENDIF
               ENDIF
               IF lIncludeMiniPrintRC
                  bld_cmd += 'COPY /B ' + Q_QPM_TMP_RC + ' + ' + cB_FILLER + ' + ' + cB_RC_MIPR + ' ' + Q_QPM_TMP_RC + ' > NUL' + CRLF
               ENDIF
            ENDIF
         ELSE
            // check if the project has an RC file
                  bld_cmd += 'ECHO #define ' + GetResConfigVarName() + ' ' + cB_RC_FOLD + ' > ' + cB_RC_CONF                    + CRLF
                  bld_cmd += 'IF NOT EXIST ' + cB_RC_CONF + ' ECHO ' + cB_RCF_ERR + ' > ' + cB_TMP_ERR                          + CRLF
                  bld_cmd += 'IF NOT EXIST ' + cB_RC_MAIN + ' GOTO NORC'                                                        + CRLF
            // in project's RC file change .\ and ..\ to full path ("S" means use 8.3 path, "N" means use long path)
                  bld_cmd += cB_US_RES + '-ONLYINCLUDE ' + cB_RC_MA_S + ' ' + cB_RC1_SHR + ' ' + cB_RC1_PTH + ' ' + "N"        + CRLF
                  bld_cmd += 'IF ERRORLEVEL 1 GOTO ERROR'                                                                     + CRLF
                  bld_cmd += cB_US_RES  + cB_RC1_SHR + ' ' + cB_RC2_SHR + ' ' + cB_RC1_PTH + ' ' + "N"                    + CRLF
                  bld_cmd += 'IF ERRORLEVEL 1 GOTO ERROR'                                                                     + CRLF
            // concatenate project's and MINIGUI's RC files into a temporary RC file
            IF Prj_Check_IgnoreLibRCs
                  bld_cmd += 'COPY /B ' + cB_RC2_SHR + ' ' + Q_QPM_TMP_RC + ' > NUL'                                            + CRLF
            ELSE
                  bld_cmd += 'IF NOT EXIST ' + cB_RC_MINI + ' ECHO ' + cB_RCM_ERR + ' > ' + cB_TMP_ERR                          + CRLF
               IF Prj_Check_PlaceRCFirst
                  bld_cmd += 'COPY /B ' + cB_RC2_SHR + ' + ' + cB_FILLER + ' + ' + cB_RC_MINI + ' ' + Q_QPM_TMP_RC + ' > NUL'   + CRLF
               ELSE
                  bld_cmd += 'COPY /B ' + cB_RC_MINI + ' + ' + cB_FILLER + ' + ' + cB_RC2_SHR + ' ' + Q_QPM_TMP_RC + ' > NUL'   + CRLF
               ENDIF
               lIncludeMiniPrintRC := .F.
               FOR i := 1 TO Len( vLibsToLink )
                  IF ! GetMiniGuiSuffix() == DefineOohg3
                     IF US_Upper( vLibsToLink[i] ) == 'LIBHBPRINTER.A'
                        IF AScan( vLibExcludeFiles, { |x| US_Upper( x ) == 'LIBHBPRINTER.A' } ) == 0
                  bld_cmd += 'COPY /B ' + Q_QPM_TMP_RC + ' + ' + cB_FILLER + ' + ' + cB_RC_HBPR + ' ' + Q_QPM_TMP_RC + ' > NUL' + CRLF
                        ENDIF
                     ELSEIF US_Upper( vLibsToLink[i] ) == 'LIBMINIPRINT.A'
                        IF AScan( vLibExcludeFiles, { |x| US_Upper( x ) == 'LIBMINIPRINT.A' } ) == 0
                           lIncludeMiniPrintRC := .T.
                        ENDIF
                     ENDIF
                  ENDIF
               NEXT i
               IF ! lIncludeMiniPrintRC
                  IF AScan( vLibIncludeFiles, { |x| US_Upper( US_FileNameOnlyNameAndExt( x ) ) == 'LIBMINIPRINT2.A' } ) # 0
                     IF AScan( vLibExcludeFiles, { |x| US_Upper( x ) == 'LIBMINIPRINT2.A' } ) == 0
                        lIncludeMiniPrintRC := .T.
                     ENDIF
                  ENDIF
               ENDIF
               IF lIncludeMiniPrintRC
                  bld_cmd += 'COPY /B ' + Q_QPM_TMP_RC + ' + ' + cB_FILLER + ' + ' + cB_RC_MIPR + ' ' + Q_QPM_TMP_RC + ' > NUL' + CRLF
               ENDIF
            ENDIF
                  bld_cmd += 'GOTO NEXT'                                                                                        + CRLF
            // concatenate MINIGUI's RC files into a temporary RC file
                  bld_cmd += ':NORC'                                                                                            + CRLF
            IF ! Prj_Check_IgnoreLibRCs
                  bld_cmd += 'IF NOT EXIST ' + cB_RC_MINI + ' ECHO ' + cB_RCM_ERR + ' > ' + cB_TMP_ERR                          + CRLF
                  bld_cmd += 'COPY /B ' + cB_RC_MINI + ' ' + Q_QPM_TMP_RC + ' > NUL'                                            + CRLF
               lIncludeMiniPrintRC := .F.
               FOR i := 1 TO Len( vLibsToLink )
                  IF ! GetMiniGuiSuffix() == DefineOohg3
                     IF US_Upper( vLibsToLink[i] ) == 'LIBHBPRINTER.A'
                        IF AScan( vLibExcludeFiles, { |x| US_Upper( x ) == 'LIBHBPRINTER.A' } ) == 0
                  bld_cmd += 'COPY /B ' + Q_QPM_TMP_RC + ' + ' + cB_FILLER + ' + ' + cB_RC_HBPR + ' ' + Q_QPM_TMP_RC + ' > NUL' + CRLF
                        ENDIF
                     ELSEIF US_Upper( vLibsToLink[i] ) == 'LIBMINIPRINT.A'
                        IF AScan( vLibExcludeFiles, { |x| US_Upper( x ) == 'LIBMINIPRINT.A' } ) == 0
                           lIncludeMiniPrintRC := .T.
                        ENDIF
                     ENDIF
                  ENDIF
               NEXT i
               IF ! lIncludeMiniPrintRC
                  IF AScan( vLibIncludeFiles, { |x| US_Upper( US_FileNameOnlyNameAndExt( x ) ) == 'LIBMINIPRINT2.A' } ) # 0
                     IF AScan( vLibExcludeFiles, { |x| US_Upper( x ) == 'LIBMINIPRINT2.A' } ) == 0
                        lIncludeMiniPrintRC := .T.
                     ENDIF
                  ENDIF
               ENDIF
               IF lIncludeMiniPrintRC
                  bld_cmd += 'COPY /B ' + Q_QPM_TMP_RC + ' + ' + cB_FILLER + ' + ' + cB_RC_MIPR + ' ' + Q_QPM_TMP_RC + ' > NUL' + CRLF
               ENDIF
            ENDIF
         ENDIF
      ENDIF
      // check if the tool exists
                  bld_cmd += ':NEXT'                                                                                            + CRLF
      IF Prj_Radio_OutputType == DEF_RG_IMPORT
                  bld_cmd += 'IF NOT EXIST ' + cB_DLLTOOL + ' ECHO ' + cB_DLL_ERR + ' > ' + cB_TMP_ERR                          + CRLF
      ELSEIF ! Prj_Check_IgnoreMainRC .OR. ! Prj_Check_IgnoreLibRCs
                  bld_cmd += 'IF NOT EXIST ' + cB_RC_COMP + ' ECHO ' + cB_RCC_ERR + ' > ' + cB_TMP_ERR                          + CRLF
      ENDIF
      // build
                  bld_cmd += 'SET PATH=' + cB_CPP_BIN                                                                           + CRLF
                  bld_cmd += ':MAKE'                                                                                            + CRLF
                  bld_cmd += cB_US_MAKE + ' ' + '-f ' + Q_MAKE_FILE + ' >> ' + Q_TEMP_LOG + ' 2>&1'                              + CRLF
      // check errors
      DO CASE
      CASE Prj_Radio_OutputCopyMove == DEF_RG_MOVE
                  bld_cmd += 'IF EXIST ' + cB_EXE + ' GOTO ERROR'                                                               + CRLF
                  bld_cmd += 'IF EXIST ' + cB_OUTPUT + ' GOTO OK'                                                               + CRLF
      CASE Prj_Radio_OutputCopyMove == DEF_RG_COPY
                  bld_cmd += 'IF NOT EXIST ' + cB_EXE + ' GOTO ERROR'                                                           + CRLF
                  bld_cmd += 'IF EXIST ' + cB_OUTPUT + ' GOTO OK'                                                               + CRLF
      OTHERWISE
                  bld_cmd += 'IF EXIST ' + cB_EXE + ' GOTO OK'                                                                  + CRLF
      ENDCASE
      // report result
                  bld_cmd += ':ERROR'                                                                                           + CRLF
                  bld_cmd += 'IF EXIST ' + cB_TMP_ERR + ' COPY ' + cB_TMP_ERR + ' ' + Q_TEMP_LOG + ' > NUL'                     + CRLF
                  bld_cmd += 'ECHO ERROR > ' + Q_END_FILE                                                                       + CRLF
                  bld_cmd += 'GOTO END'                                                                                         + CRLF
                  bld_cmd += ':OK'                                                                                              + CRLF
                  bld_cmd += 'ECHO OK > ' + Q_END_FILE                                                                          + CRLF
                  bld_cmd += ':END'                                                                                             + CRLF
      // clean temporary files
      IF PUB_DeleteAux
                  bld_cmd += 'IF EXIST ' + cB_RC_CONF  + ' DEL ' + cB_RC_CONF + ' > NUL'                                        + CRLF
                  bld_cmd += 'IF EXIST ' + cB_RC1_SHR  + ' DEL ' + cB_RC1_SHR + ' > NUL'                                        + CRLF
                  bld_cmd += 'IF EXIST ' + cB_RC2_SHR  + ' DEL ' + cB_RC2_SHR + ' > NUL'                                        + CRLF
                  bld_cmd += 'IF EXIST ' + cB_RC1_FER  + ' DEL ' + cB_RC1_FER + ' > NUL'                                        + CRLF
                  bld_cmd += 'IF EXIST ' + cB_RC2_FER  + ' DEL ' + cB_RC2_FER + ' > NUL'                                        + CRLF
      ENDIF
      QPM_MemoWrit( BUILD_BAT, bld_cmd )
   CASE ( IsBorland .OR. IsPelles )
                  bld_cmd := '@ECHO OFF'                                                                                        + CRLF
      IF bLogActivity
                  bld_cmd += 'ECHO Writing Log Activity ...'                                                                    + CRLF
      ENDIF
      // delete preexisting temp files
                  bld_cmd += 'IF EXIST ' + cB_TMP_ERR    + ' DEL ' + cB_TMP_ERR + ' > NUL'                                      + CRLF
                  bld_cmd += 'IF EXIST ' + Q_TEMP_LOG    + ' DEL ' + Q_TEMP_LOG + ' > NUL'                                      + CRLF
                  bld_cmd += 'IF EXIST ' + Q_SCRIPT_FILE + ' DEL ' + Q_SCRIPT_FILE + ' > NUL'                                   + CRLF
                  bld_cmd += 'IF EXIST ' + Q_QPM_TMP_RC  + ' DEL ' + Q_QPM_TMP_RC + ' > NUL'                                    + CRLF
      // concatenate project's and MINIGUI's RC files into a temporary RC file
      // this is needed because BCC only allows icons and cursors in the first RC file
      IF Prj_Radio_OutputType != DEF_RG_IMPORT .AND. ( ! Prj_Check_IgnoreMainRC .OR. ! Prj_Check_IgnoreLibRCs )
         IF Prj_Check_IgnoreMainRC
            IF ! Prj_Check_IgnoreLibRCs
                  bld_cmd += 'ECHO #define ' + GetResConfigVarName() + ' ' + cB_RC_FOLD + ' > ' + cB_RC_CONF                    + CRLF
                  bld_cmd += 'IF NOT EXIST ' + cB_RC_CONF + ' ECHO ' + cB_RCF_ERR + ' > ' + cB_TMP_ERR                          + CRLF
                  bld_cmd += 'IF NOT EXIST ' + cB_RC_MINI + ' ECHO ' + cB_RCM_ERR + ' > ' + cB_TMP_ERR                          + CRLF
                  bld_cmd += 'COPY /B ' + cB_RC_MINI + ' ' + Q_QPM_TMP_RC + ' > NUL'                                            + CRLF
               lIncludeMiniPrintRC := .F.
               FOR i := 1 TO Len( vLibsToLink )
                  IF ! GetMiniGuiSuffix() == DefineOohg3
                     IF US_Upper( vLibsToLink[i] ) == 'HBPRINTER.LIB'
                        IF AScan( vLibExcludeFiles, { |x| US_Upper( x ) == 'HBPRINTER.LIB' } ) == 0
                  bld_cmd += 'COPY /B ' + Q_QPM_TMP_RC + ' + ' + cB_FILLER + ' + ' + cB_RC_HBPR + ' ' + Q_QPM_TMP_RC + ' > NUL' + CRLF
                        ENDIF
                     ELSEIF US_Upper( vLibsToLink[i] ) == 'MINIPRINT.LIB'
                        IF AScan( vLibExcludeFiles, { |x| US_Upper( x ) == 'MINIPRINT.LIB' } ) == 0
                           lIncludeMiniPrintRC := .T.
                        ENDIF
                     ENDIF
                  ENDIF
               NEXT i
               IF ! lIncludeMiniPrintRC
                  IF AScan( vLibIncludeFiles, { |x| US_Upper( US_FileNameOnlyNameAndExt( x ) ) == 'MINIPRINT2.LIB' } ) # 0
                     IF AScan( vLibExcludeFiles, { |x| US_Upper( x ) == 'MINIPRINT2.LIB' } ) == 0
                        lIncludeMiniPrintRC := .T.
                     ENDIF
                  ENDIF
               ENDIF
               IF lIncludeMiniPrintRC
                  bld_cmd += 'COPY /B ' + Q_QPM_TMP_RC + ' + ' + cB_FILLER + ' + ' + cB_RC_MIPR + ' ' + Q_QPM_TMP_RC + ' > NUL' + CRLF
               ENDIF
            ENDIF
         ELSE
            // check if the project has an RC file
                  bld_cmd += 'ECHO #define ' + GetResConfigVarName() + ' ' + cB_RC_FOLD + ' > ' + cB_RC_CONF                    + CRLF
                  bld_cmd += 'IF NOT EXIST ' + cB_RC_CONF + ' ECHO ' + cB_RCF_ERR + ' > ' + cB_TMP_ERR                          + CRLF
                  bld_cmd += 'IF NOT EXIST ' + cB_RC_MAIN + ' GOTO NORC'                                                        + CRLF
            // in project's RC file change .\ and ..\ to full path ("S" means use 8.3 path, "N" means use long path)
                  bld_cmd += cB_US_RES + '-ONLYINCLUDE ' + cB_RC_MA_S + ' ' + cB_RC1_SHR + ' ' + cB_RC1_PTH + ' ' + "N"        + CRLF
                  bld_cmd += 'IF ERRORLEVEL 1 GOTO ERROR'                                                                       + CRLF
                  bld_cmd += cB_US_RES  + cB_RC1_SHR + ' ' + cB_RC2_SHR + ' ' + cB_RC1_PTH + ' ' + "N"                    + CRLF
                  bld_cmd += 'IF ERRORLEVEL 1 GOTO ERROR'                                                                       + CRLF
            // concatenate project's and MINIGUI's RC files into a temporary RC file
            IF Prj_Check_IgnoreLibRCs
                  bld_cmd += 'COPY /B ' + cB_RC2_SHR + ' ' + Q_QPM_TMP_RC + ' > NUL'                                            + CRLF
            ELSE
                  bld_cmd += 'IF NOT EXIST ' + cB_RC_MINI + ' ECHO ' + cB_RCM_ERR + ' > ' + cB_TMP_ERR                          + CRLF
               IF Prj_Check_PlaceRCFirst
                  bld_cmd += 'COPY /B ' + cB_RC2_SHR + ' + ' + cB_FILLER + ' + ' + cB_RC_MINI + ' ' + Q_QPM_TMP_RC + ' > NUL'   + CRLF
               ELSE
                  bld_cmd += 'COPY /B ' + cB_RC_MINI + ' + ' + cB_FILLER + ' + ' + cB_RC2_SHR + ' ' + Q_QPM_TMP_RC + ' > NUL'   + CRLF
               ENDIF
               lIncludeMiniPrintRC := .F.
               FOR i := 1 TO Len( vLibsToLink )
                  IF ! GetMiniGuiSuffix() == DefineOohg3
                     IF US_Upper( vLibsToLink[i] ) == 'HBPRINTER.LIB'
                        IF AScan( vLibExcludeFiles, { |x| US_Upper( x ) == 'HBPRINTER.LIB' } ) == 0
                  bld_cmd += 'COPY /B ' + Q_QPM_TMP_RC + ' + ' + cB_FILLER + ' + ' + cB_RC_HBPR + ' ' + Q_QPM_TMP_RC + ' > NUL' + CRLF
                        ENDIF
                     ELSEIF US_Upper( vLibsToLink[i] ) == 'MINIPRINT.LIB'
                        IF AScan( vLibExcludeFiles, { |x| US_Upper( x ) == 'MINIPRINT.LIB' } ) == 0
                           lIncludeMiniPrintRC := .T.
                        ENDIF
                     ENDIF
                  ENDIF
               NEXT i
               IF ! lIncludeMiniPrintRC
                  IF AScan( vLibIncludeFiles, { |x| US_Upper( US_FileNameOnlyNameAndExt( x ) ) == 'MINIPRINT2.LIB' } ) # 0
                     IF AScan( vLibExcludeFiles, { |x| US_Upper( x ) == 'MINIPRINT2.LIB' } ) == 0
                        lIncludeMiniPrintRC := .T.
                     ENDIF
                  ENDIF
               ENDIF
               IF lIncludeMiniPrintRC
                  bld_cmd += 'COPY /B ' + Q_QPM_TMP_RC + ' + ' + cB_FILLER + ' + ' + cB_RC_MIPR + ' ' + Q_QPM_TMP_RC + ' > NUL' + CRLF
               ENDIF
            ENDIF
                  bld_cmd += 'GOTO NEXT'                                                                                        + CRLF
            // concatenate MINIGUI's RC files into a temporary RC file
                  bld_cmd += ':NORC'                                                                                            + CRLF
            IF ! Prj_Check_IgnoreLibRCs
                  bld_cmd += 'IF NOT EXIST ' + cB_RC_MINI + ' ECHO ' + cB_RCM_ERR + ' > ' + cB_TMP_ERR                          + CRLF
                  bld_cmd += 'COPY /B ' + cB_RC_MINI + ' ' + Q_QPM_TMP_RC + ' > NUL'                                            + CRLF
               lIncludeMiniPrintRC := .F.
               FOR i := 1 TO Len( vLibsToLink )
                  IF ! GetMiniGuiSuffix() == DefineOohg3
                     IF US_Upper( vLibsToLink[i] ) == 'HBPRINTER.LIB'
                        IF AScan( vLibExcludeFiles, { |x| US_Upper( x ) == 'HBPRINTER.LIB' } ) == 0
                  bld_cmd += 'COPY /B ' + Q_QPM_TMP_RC + ' + ' + cB_FILLER + ' + ' + cB_RC_HBPR + ' ' + Q_QPM_TMP_RC + ' > NUL' + CRLF
                        ENDIF
                     ELSEIF US_Upper( vLibsToLink[i] ) == 'MINIPRINT.LIB'
                        IF AScan( vLibExcludeFiles, { |x| US_Upper( x ) == 'MINIPRINT.LIB' } ) == 0
                           lIncludeMiniPrintRC := .T.
                        ENDIF
                     ENDIF
                  ENDIF
               NEXT i
               IF ! lIncludeMiniPrintRC
                  IF AScan( vLibIncludeFiles, { |x| US_Upper( US_FileNameOnlyNameAndExt( x ) ) == 'MINIPRINT2.LIB' } ) # 0
                     IF AScan( vLibExcludeFiles, { |x| US_Upper( x ) == 'MINIPRINT2.LIB' } ) == 0
                        lIncludeMiniPrintRC := .T.
                     ENDIF
                  ENDIF
               ENDIF
               IF lIncludeMiniPrintRC
                  bld_cmd += 'COPY /B ' + Q_QPM_TMP_RC + ' + ' + cB_FILLER + ' + ' + cB_RC_MIPR + ' ' + Q_QPM_TMP_RC + ' > NUL' + CRLF
               ENDIF
            ENDIF
         ENDIF
      ENDIF
      // build
                  bld_cmd += ':NEXT'                                                                                            + CRLF
                  bld_cmd += 'SET PATH=' + cB_CPP_BIN                                                                           + CRLF
                  bld_cmd += cB_US_MAKE + ' ' + '-f ' + Q_MAKE_FILE + ' >> ' + Q_TEMP_LOG + ' 2>&1'                           + CRLF
      // check errors
      DO CASE
      CASE Prj_Radio_OutputCopyMove == DEF_RG_MOVE
                  bld_cmd += 'IF EXIST ' + cB_EXE + ' GOTO ERROR'                                                               + CRLF
                  bld_cmd += 'IF EXIST ' + cB_OUTPUT + ' GOTO OK'                                                               + CRLF
      CASE Prj_Radio_OutputCopyMove == DEF_RG_COPY
                  bld_cmd += 'IF NOT EXIST ' + cB_EXE + ' GOTO ERROR'                                                           + CRLF
                  bld_cmd += 'IF EXIST ' + cB_OUTPUT + ' GOTO OK'                                                               + CRLF
      OTHERWISE
                  bld_cmd += 'IF EXIST ' + cB_EXE + ' GOTO OK'                                                                  + CRLF
      ENDCASE
      // report result
                  bld_cmd += ':ERROR'                                                                                           + CRLF
                  bld_cmd += 'IF EXIST ' + cB_TMP_ERR + ' COPY ' + cB_TMP_ERR + ' ' + Q_TEMP_LOG + ' > NUL'                     + CRLF
                  bld_cmd += 'ECHO ERROR > ' + Q_END_FILE                                                                       + CRLF
                  bld_cmd += 'GOTO END'                                                                                         + CRLF
                  bld_cmd += ':OK'                                                                                              + CRLF
                  bld_cmd += 'ECHO OK > ' + Q_END_FILE                                                                          + CRLF
      // clean temporary files
                  bld_cmd += ':END'                                                                                             + CRLF
      IF PUB_DeleteAux
                  bld_cmd += 'IF EXIST ' + cB_RC_CONF  + ' DEL ' + cB_RC_CONF + ' > NUL'                                        + CRLF
                  bld_cmd += 'IF EXIST ' + cB_RC1_SHR  + ' DEL ' + cB_RC1_SHR + ' > NUL'                                        + CRLF
                  bld_cmd += 'IF EXIST ' + cB_RC2_SHR  + ' DEL ' + cB_RC2_SHR + ' > NUL'                                        + CRLF
                  bld_cmd += 'IF EXIST ' + cB_RC1_FER  + ' DEL ' + cB_RC1_FER + ' > NUL'                                        + CRLF
                  bld_cmd += 'IF EXIST ' + cB_RC2_FER  + ' DEL ' + cB_RC2_FER + ' > NUL'                                        + CRLF
      ENDIF
      QPM_MemoWrit( BUILD_BAT, bld_cmd )
   OTHERWISE
      US_Log( 'Unknown C compiler.' )
      BUILD_IN_PROGRESS := .F.
      RETURN .F.
   ENDCASE

   IF PUB_bLite
      VentanaLite.bStop.Enabled := .T.
   ELSE
      VentanaMain.bStop.Enabled := .T.
   ENDIF

   DO EVENTS

   MemoAux := MemoRead( PROGRESS_LOG )
   QPM_MemoWrit( PROGRESS_LOG, MemoAux + US_TimeDis( Time() ) + ' - Checking Force Recomp Modules ...' + CRLF )
   FOR i := 1 TO GetProperty( 'VentanaMain', 'GPRGFiles', 'itemcount' )
      IF GetProperty( 'VentanaMain', 'GPRGFiles', 'cell', i, NCOLPRGRECOMP ) == 'R'
         MemoAux := MemoRead( PROGRESS_LOG )
         QPM_MemoWrit( PROGRESS_LOG, MemoAux + US_TimeDis( Time() ) + ' - Force Recomp by User for ' + ChgPathToReal( GetProperty( 'VentanaMain', 'GPRGFiles', 'cell', i, NCOLPRGFULLNAME ) ) + CRLF )
         FErase( GetObjFolder() + DEF_SLASH + US_FileNameOnlyName( GetProperty( 'VentanaMain', 'GPRGFiles', 'cell', i, NCOLPRGNAME ) ) + iif( Upper( US_FileNameOnlyExt( GetProperty( 'VentanaMain', 'GPRGFiles', 'cell', i, NCOLPRGNAME ) ) ) == 'CPP', '.CPP', '.C' ) )
      ENDIF
   NEXT i

   DO EVENTS

   SetMGWaitHide()

   QPM_Execute( BUILD_BAT, "", DEF_QPM_EXEC_NOWAIT, DEF_QPM_EXEC_HIDE )

RETURN .T.

FUNCTION QPM_Run( bWithParm )
// QPM_Run2
   LOCAL RUNFOLDER     := AllTrim(US_FileNameOnlyPath(VentanaMain.TRunProjectFolder.Value))
   LOCAL App
   LOCAL cParm         := ''
   LOCAL RunParms
   LOCAL cOldFolder    := GetCurrentFolder()
   LOCAL oInput        := US_InputBox():New()

   IF bWaitForBuild
      DO WHILE BUILD_IN_PROGRESS
         DO EVENTS
      ENDDO
   ENDIF
   IF Empty( PUB_cProjectFile )
      MyMsgStop( 'You must save the project before running it.' )
      RETURN .F.
   ENDIF
   IF Empty( PUB_cProjectFolder ) .OR. ! US_IsDirectory( PUB_cProjectFolder )
      MyMsgStop( DBLQT + "Project Folder" + DBLQT + " is not a valid folder:" + CRLF + PUB_cProjectFolder + CRLF + 'Look at tab ' + DBLQT + PagePRG + DBLQT )
      RETURN .F.
   ENDIF

   IF Prj_Radio_OutputCopyMove == DEF_RG_MOVE
      App := US_ShortName( Prj_Text_OutputCopyMoveFolder ) + DEF_SLASH + US_FileNameOnlyNameAndExt( GetOutputModuleName() )
   ELSE
      App := GetOutputModuleName()
   ENDIF

   IF ! File( App )
      MyMsgStop( 'Application ' + DBLQT + App + DBLQT + ' was not found!' + CRLF + 'You must build the project before running it.' )
   ELSE
      IF bWithParm
         oInput:cTitulo := 'Parameters for Run Program'
         oInput:ValorInicial := Gbl_cRunParm
         oInput:cLeyenda :=  'Parm:'
         oInput:nPorAlto := iif( PUB_bW800, 30, 20 )
         oInput:nPorAncho := 60
         oInput:bButtonOk := .T.
         oInput:bButtonCancel := .T.
         oInput:bEscape := .T.
         oInput:DefineWindow()
         cParm := oInput:Show()
         IF ! Empty( cParm )
            Gbl_cRunParm := cParm
         ELSE
            cParm := ''
         ENDIF
      ENDIF
      VentanaMain.GPrgFiles.SetFocus()
      IF Empty( RUNFOLDER )
         RUNFOLDER := PUB_cProjectFolder
         IF PUB_bDebugActive
            IF ! File( PUB_cProjectFolder + DEF_SLASH + 'Init.Cld' )
               MyMsgStop( 'Configuration file for debug is missing, rebuild the project with Debug option and try again.' )
               RETURN .F.
            ENDIF
         ENDIF
      ELSE
         IF PUB_bDebugActive
            IF ! File( RUNFOLDER + DEF_SLASH + 'Init.Cld' )
               IF File( PUB_cProjectFolder + DEF_SLASH + 'Init.Cld' )
                  US_FileCopy( PUB_cProjectFolder + DEF_SLASH + 'Init.Cld', RUNFOLDER + DEF_SLASH + 'Init.Cld' )
               ELSE
                  MyMsgStop( 'Configuration file for debug is missing, rebuild the project with Debug option and try again.' )
                  RETURN .F.
               ENDIF
            ENDIF
         ENDIF
      ENDIF

      IF !PUB_QPM_bHigh
         QPM_SetProcessPriority( 'HIGH' )
         IF File( ErrorLogName() )
            PUB_ErrorLogTime := Val( DToS( US_FileDate( ErrorLogName() ) ) + US_StrCero( US_TimeSec( US_FileTime( ErrorLogName() ) ), 5 ) )
         ELSE
            PUB_ErrorLogTime := 0
         ENDIF
      ENDIF

      QPM_KillerModule := App

      SetCurrentFolder( RUNFOLDER )

      CloseDbfAutoView()
      IF VentanaMain.GDbfFiles.Value > 0
         DefineRichEditForNotDbfView( 'DBF view is disable while application is running!' )
      ENDIF
      RunParms := US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + '_' + PUB_cSecu + 'RUN' + US_DateTimeCen() + '.cng'
      QPM_LogText( RunParms )
      AAdd( RunControlFile, US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + '_' + PUB_cSecu + 'RCF' + US_DateTimeCen() + '.cnt' )
      QPM_MemoWrit( RunParms, 'Run Parms For ' + App + CRLF + ;
                              'COMMAND ' + App + ' ' + cParm + CRLF + ;
                              'CONTROL ' + RunControlFile[ Len( RunControlFile ) ] )
      QPM_LogFile( RunParms )
      QPM_MemoWrit( RunControlFile[ Len( RunControlFile ) ], 'Run Control File for ' + App )
      QPM_LogFile( RunControlFile[ Len( RunControlFile ) ] )
      QPM_Execute( US_ShortName( PUB_cQPM_Folder ) + DEF_SLASH + 'US_Run.exe', 'QPM' + LISTOLOG + RunParms )
      bRunApp := .T.
      VentanaMain.Check_DbfAutoView.Enabled := .F.

      SetCurrentFolder( cOldFolder )
   ENDIF
RETURN .T.

FUNCTION QPM_Timer_Run()
   LOCAL i, bLOCALRun := .F.
   SetProperty( 'VentanaMain', 'Timer_Run', 'Enabled', .F. )

   IF bRunApp
      FOR i := 1 TO Len( RunControlFile )
         IF File( RunControlFile[ i ] )
            bLOCALRun := .T.
            EXIT
         ENDIF
      NEXT
      IF !bLOCALRun
         bRunApp := .F.
         IF !QPM_bKiller .AND. PUB_QPM_bHigh
            QPM_SetProcessPriority( 'NORMAL' )
         ENDIF
         VentanaMain.Check_DbfAutoView.Enabled := .T.
         QPM_Wait( "RichEditDisplay( 'DBF', .T. )", 'Loading ...' )
         IF File( ErrorLogName() )
            IF PUB_ErrorLogTime < Val( DToS( US_FileDate( ErrorLogName() ) ) + US_StrCero( US_TimeSec( US_FileTime( ErrorLogName() ) ), 5 ) )
               VentanaMain.TabFiles.Value := nPageOut
               TabChange( 'FILES' )
               MuestroErrorLog()
            ENDIF
         ENDIF
      ENDIF
   ENDIF
   SetProperty( 'VentanaMain', 'Timer_Run', 'Enabled', .T. )
RETURN .T.

FUNCTION QPM_Timer_StatusRefresh()
   LOCAL memotmp, lenAux
   LOCAL Venta := iif( PUB_bLite, 'VentanaLite', 'VentanaMain' )
   LOCAL TopName, OutName, estado
   LOCAL cBaseVerVer := Replicate( '0', DEF_LEN_VER_VERSION )
   LOCAL cBaseVerRel := Replicate( '0', DEF_LEN_VER_RELEASE )
   LOCAL cBaseVerBui := Replicate( '0', DEF_LEN_VER_BUILD )
   LOCAL cTopVerVer := Replicate( '9', DEF_LEN_VER_VERSION )
   LOCAL cTopVerRel := Replicate( '9', DEF_LEN_VER_RELEASE )
   LOCAL cTopVerBui := Replicate( '9', DEF_LEN_VER_BUILD )
   LOCAL cLog

   SetProperty( 'VentanaMain', 'Timer_Refresh', 'Enabled', .F. )

   IF PUB_bIsProcessing
      IF Empty( GetProperty( Venta, 'LStatusLabel', 'value' ) )
         SetProperty( Venta, 'LStatusLabel', 'value', 'Building ...' )
      ELSE
         SetProperty( Venta, 'LStatusLabel', 'value', '' )
      ENDIF
      IF File( END_FILE )
         PUB_bIsProcessing := .F.
         FErase( MSG_SYSIN )   /* por si estubiera activado el proceso de stop y la compilacion cancela por error */
         SetProperty( Venta, 'bStop', 'enabled', .T. )
         VentanaMain.TabFiles.Value := nPageSysout
         TabChange( 'FILES' )
         QPM_LogText( "Translating log" )
         QPM_MemoWrit( TEMP_LOG, cLog := TranslateLog( MemoRead( TEMP_LOG ) ) )
         QPM_LogText( "Done" )
         estado := US_Word( MemoRead( END_FILE ), 1 )
         /* ini Parche para cuando el EXE esta corriendo y queremos hacer build sin modificar ningún prg */
         IF MLCount( GetProperty( Venta, 'RichEditSysout', 'value' ) ) < 3 .AND. ;
            US_Word( GetProperty( Venta, 'RichEditSysout', 'value' ), 1 ) == 'MAKE'
            SetProperty( Venta, 'RichEditSysout', 'value', GetProperty( Venta, 'RichEditSysout', 'value' ) + CRLF + 'Fatal error opening "' + GetOutputModuleName() + '".' + CRLF + 'May be the program is still running?' )
            estado := 'ERROR'
         ENDIF
         /* Fin Parche para cuando el EXE esta corriendo y queremos hacer build sin modificar ningun prg */
         IF bAutoEXIT .AND. ! Empty( PUB_cAutoLog )
            PUB_cAutoLogTmp := MemoRead( PUB_cAutoLog )
            PUB_cAutoLogTmp += CRLF
            PUB_cAutoLogTmp += 'Result: ' + estado
            IF estado == 'ERROR' .OR. ( ! PUB_bLogOnlyError .AND. estado == 'WARNING' )
               IF ! Left( cLog, 1 ) == CRLF
                  PUB_cAutoLogTmp += CRLF
               ENDIF
               PUB_cAutoLogTmp += cLog
            ENDIF
            PUB_cAutoLogTmp += CRLF
            PUB_cAutoLogTmp += Replicate( '=', 80 )
            PUB_cAutoLogTmp += CRLF
            QPM_LogText( "Writing result to AutoLog" )
            QPM_MemoWrit( PUB_cAutoLog, PUB_cAutoLogTmp )
            QPM_LogText( "Done" )
         ENDIF
         // Write to QPM's log
         IF bLogActivity
            memoTMP := MemoRead( PUB_cQPM_Folder + DEF_SLASH + 'QPM.log' ) + CRLF
            memoTMP := memoTMP + '****** ' + PUB_cProjectFolder + DEF_SLASH + '_' + PUB_cSecu + 'Progress.Log' + CRLF + CRLF
            memoTMP := memoTMP + MemoRead( PROGRESS_LOG ) + CRLF
            memoTMP := memoTMP + '****** ' + PUB_cProjectFolder + DEF_SLASH + '_' + PUB_cSecu + 'Build.Bat'    + CRLF + CRLF
            memoTMP := memoTMP + MemoRead( BUILD_BAT ) + CRLF
            memoTMP := memoTMP + '****** ' + PUB_cProjectFolder + DEF_SLASH + '_' + PUB_cSecu + 'Temp.Log'     + CRLF + CRLF
            memoTMP := memoTMP + MemoRead( TEMP_LOG ) + CRLF
            memoTMP := memoTMP + '****** ' + PUB_cProjectFolder + DEF_SLASH + '_' + PUB_cSecu + 'Temp.Bc'      + CRLF + CRLF
            memoTMP := memoTMP + MemoRead( MAKE_FILE ) + CRLF
            memoTMP := memoTMP + '****** ' + PUB_cProjectFolder + DEF_SLASH + '_' + PUB_cSecu + 'Script.ld'    + CRLF + CRLF
            memoTMP := memoTMP + MemoRead( SCRIPT_FILE ) + CRLF
         IF File( QPM_TMP_RC )
            memoTMP := memoTMP + '****** ' + PUB_cProjectFolder + DEF_SLASH + '_' + PUB_cSecu + 'temp.rc'      + CRLF + CRLF
            memoTMP := memoTMP + MemoRead( QPM_TMP_RC ) + CRLF
         ELSE
            memoTMP := memoTMP + '****** Project has no RC file'                                               + CRLF + CRLF
         ENDIF
            memoTMP := memoTMP + PadR( '*****  BUILD END: ' + US_VarToStr( Date() ) + ' ' + US_VarToStr( Time() ) + '  ', 100, '*' ) + CRLF + CRLF
            QPM_MemoWrit( PUB_cQPM_Folder + DEF_SLASH + 'QPM.log', memoTMP )
         ENDIF
         // Load build log to richedit control
         SetProperty( Venta, 'RichEditSysout', 'value', MemoRead( TEMP_LOG ) )
         SetProperty( Venta, 'RichEditSysout', 'CaretPos', Len( GetProperty( Venta, 'RichEditSysout', 'value' ) ) )
         // Update status
         SetProperty( Venta, 'LStatusLabel', 'value', 'Status: Idle' )
         // Show result
         DO CASE
         CASE estado == 'OK'
            MyMsgOk( NIL, 'Build Finished'+CRLF+'OK', 'I', iif( bBuildRun .OR. ! Empty( Prj_ExtraRunCmdFINAL ), .T., bAutoEXIT ), iif( bBuildRun, 2, ), iif( !bBuildRun .AND. Empty( Prj_ExtraRunCmdFINAL ) .AND. US_Upper( OutputExt() ) == 'EXE', .T., .F. ) )
         CASE estado == 'WARNING'
            MyMsgOk( NIL, 'Build Finished'+CRLF+'with Warnings', 'W', iif( bBuildRun .OR. ! Empty( Prj_ExtraRunCmdFINAL ), .T., bAutoEXIT ), iif( bBuildRun, 4, ), iif( !bBuildRun .AND. Empty( Prj_ExtraRunCmdFINAL ) .AND. US_Upper( OutputExt() ) == 'EXE', .T., .F. ) )
         CASE estado == 'ERROR'
            MyMsgOk( NIL, 'Build Finished'+CRLF+'with ERRORS', 'E', bAutoEXIT )
         OTHERWISE
            MyMsgOk( NIL, 'Build Finished'+CRLF+'with Invalid Code: '+estado, 'E' )
         ENDCASE
         // Show log
         RichEditDisplay( 'OUT' )
         // Restore controls
         SetProperty( Venta, 'LFull', 'FontColor', DEF_COLORGREEN )
         SetProperty( Venta, 'LFull', 'value', 'Incremental' )
         SetProperty( 'VentanaMain', 'EraseALL', 'enabled', .T. )
         SetProperty( 'VentanaMain', 'EraseOBJ', 'enabled', .T. )
         SetProperty( 'VentanaMain', 'open', 'enabled', .T. )
         SetProperty( 'VentanaMain', 'build', 'enabled', .T. )
         SetProperty( 'VentanaMain', 'BVerChange', 'enabled', .T. )
         SetProperty( 'VentanaMain', 'OverrideCompile', 'enabled', .T. )
         SetProperty( 'VentanaMain', 'OverrideLink', 'enabled', .T. )
         IF Prj_Radio_OutputType == DEF_RG_EXE
            SetProperty( 'VentanaMain', 'run', 'enabled', .T. )
         ENDIF
         DO EVENTS
         // Execute extra run commands
         IF estado == 'OK' .AND. ! Empty( Prj_ExtraRunCmdFINAL )
            QPM_ExecuteExtraRun()
         ENDIF
         // ini BUG ======================================================================================
         // No pone enable el boton build
         IF ! GetProperty( 'VentanaMain', 'build', 'enabled' )
            SetProperty( 'VentanaMain', 'build', 'enabled', .F. )
            SetProperty( 'VentanaMain', 'build', 'enabled', .T. )
            US_Log( 'Boton Build sigue disable', .F. )
         ENDIF
         // fin BUG ======================================================================================
         // Clean auxiliary files
         IF PUB_DeleteAux
            TopName := US_FileNameOnlyName( GetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', 1, NCOLPRGNAME ) )
            OutName := US_FileNameOnlyName( GetOutputModuleName() )
            FErase( QPM_GET_DEF )
            FErase( BUILD_BAT )
            FErase( END_FILE )
            FErase( MAKE_FILE )
            FErase( PROGRESS_LOG )
            FErase( SCRIPT_FILE )
            FErase( TEMP_LOG )
            FErase( QPM_TMP_RC )
            FErase( US_FileNameOnlyPathAndName( TEMP_LOG ) + ".save" )
            FErase( PUB_cProjectFolder + DEF_SLASH + OutName + '.exp' )
            FErase( PUB_cProjectFolder + DEF_SLASH + OutName + '.TDS' )
            FErase( PUB_cProjectFolder + DEF_SLASH + TopName + '.MAP' )
            FErase( PUB_cProjectFolder + DEF_SLASH + '_' + PUB_cSecu + 'TEMP.ERR' )
         ENDIF
         // Update version numbers
         IF VentanaMain.AutoInc.Checked
            IF estado == 'OK' .OR. estado == 'WARNING'
               IF Val( GetProperty( 'VentanaMain', 'LVerBuiNum', 'value' ) ) == Val( cTopVerBui )
                  SetProperty( 'VentanaMain', 'LVerBuiNum', 'value', cBaseVerBui )
                  IF Val( GetProperty( 'VentanaMain', 'LVerRelNum', 'value' ) ) == Val( cTopVerRel )
                     SetProperty( 'VentanaMain', 'LVerRelNum', 'value', cBaseVerRel )
                     IF Val( GetProperty( 'VentanaMain', 'LVerVerNum', 'value' ) ) == Val( cTopVerVer )
                        SetProperty( 'VentanaMain', 'LVerVerNum', 'value', cBaseVerVer )
                        MyMsgWarn( 'Version counter limit reached ('+cTopVerVer+'.'+cTopVerRel+' build '+cTopVerBui+').' + CRLF + 'Counter reseted to '+cBaseVerVer+'.'+cBaseVerRel+' build '+cBaseVerBui )
                     ELSE
                        SetProperty( 'VentanaMain', 'LVerVerNum', 'value', US_StrCero( Val( GetProperty( 'VentanaMain', 'LVerVerNum', 'value' ) ) + 1, DEF_LEN_VER_VERSION ) )
                        MyMsgWarn( 'Release counter limit reached ('+cTopVerRel+').' + CRLF + 'Release counter reseted to '+cBaseVerRel+' and Version counter incremented by one.' )
                     ENDIF
                  ELSE
                     SetProperty( 'VentanaMain', 'LVerRelNum', 'value', US_StrCero( Val( GetProperty( 'VentanaMain', 'LVerRelNum', 'value' ) ) + 1, DEF_LEN_VER_RELEASE ) )
                     MyMsgWarn( 'Build counter limit reached ('+cTopVerBui+').' + CRLF + 'Build counter reseted to '+cBaseVerBui+' and Release counter incremented by one.' )
                  ENDIF
               ELSE
                  SetProperty( 'VentanaMain', 'LVerBuiNum', 'value', US_StrCero( Val( GetProperty( 'VentanaMain', 'LVerBuiNum', 'value' ) ) + 1, DEF_LEN_VER_BUILD ) )
               ENDIF
            ENDIF
         ENDIF
         DO EVENTS
         // Execute
         IF ( bBuildRun .OR. PUB_bForceRunFromMsgOk ) .AND. ( estado == 'OK' .OR. estado == 'WARNING' )
            QPM_Run( bRunParm )
         ENDIF
         // Restore status
         BUILD_IN_PROGRESS := .F.
      ELSE
         lenAux := US_FileSize( PROGRESS_LOG )
         IF lenAux > ProgLength
            ProgLength := lenAux
            SetProperty( Venta, 'RichEditSysout', 'value', MemoRead( PROGRESS_LOG ) )
            SetProperty( Venta, 'RichEditSysout', 'CaretPos', Len( GetProperty( Venta, 'RichEditSysout', 'value' ) ) )
         ENDIF
      ENDIF
   ENDIF

   SetProperty( 'VentanaMain', 'Timer_Refresh', 'Enabled', .T. )
RETURN .T.

FUNCTION QPM_RemoveFilePRG()
   LOCAL Pos, dire, exte, i, bBorrar := .T.
   LOCAL item := VentanaMain.GPrgFiles.Value
   LOCAL bTop := iif( item == 1, .T., .F. )
   IF VentanaMain.GPrgFiles.Value > 0
      IF MyMsgYesNo( 'Remove file' + CRLF + DBLQT + ChgPathToReal( GetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', VentanaMain.GPrgFiles.Value, NCOLPRGFULLNAME ) ) + DBLQT + CRLF + 'from project?', 'Confirm' )
      // QPM_ForceRecompExclude( ChgPathToReal( GetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', VentanaMain.GPrgFiles.Value, NCOLPRGFULLNAME ) ), VentanaMain.GPrgFiles.Value )
         dire := US_FileNameOnlyPath( GetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', VentanaMain.GPrgFiles.Value, NCOLPRGFULLNAME ) )
         exte := Upper( US_FileNameOnlyExt( GetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', VentanaMain.GPrgFiles.Value, NCOLPRGFULLNAME ) ) )
         IF GridImage( 'VentanaMain', 'GPrgFiles', item, NCOLPRGSTATUS, '?', PUB_nGridImgSearchOk )
            TotCaption( 'PRG', -1 )
         ENDIF
         VentanaMain.GPrgFiles.DeleteItem( VentanaMain.GPrgFiles.Value )
         IF item > VentanaMain.GPrgFiles.ItemCount
            item := VentanaMain.GPrgFiles.ItemCount
         ENDIF
         SetProperty( 'VentanaMain', 'GPrgFiles', 'value', item )
         RichEditDisplay( 'PRG' )
         FOR i := 1 TO VentanaMain.GPrgFiles.ItemCount
            IF dire == US_FileNameOnlyPath( GetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', i, NCOLPRGFULLNAME ) )
               bBorrar := .F.
            ENDIF
         NEXT
         FOR i := 1 TO VentanaMain.GPanFiles.ItemCount
            IF dire == US_FileNameOnlyPath( GetProperty( 'VentanaMain', 'GPanFiles', 'Cell', i, NCOLPANFULLNAME ) )
               bBorrar := .F.
            ENDIF
         NEXT
         FOR i := 1 TO VentanaMain.GDbfFiles.ItemCount
            IF dire == US_FileNameOnlyPath( GetProperty( 'VentanaMain', 'GDbfFiles', 'Cell', i, NCOLDBFFULLNAME ) )
               bBorrar := .F.
            ENDIF
         NEXT
         FOR i := 1 TO VentanaMain.GHeaFiles.ItemCount
            IF dire == US_FileNameOnlyPath( GetProperty( 'VentanaMain', 'GHeaFiles', 'Cell', i, NCOLHEAFULLNAME ) )
               bBorrar := .F.
            ENDIF
         NEXT
         IF bBorrar
            IF exte == "PRG"
               Pos := AScan( vExtraFoldersForSearchHB, { |y| US_Upper( y ) == US_Upper( ChgPathToReal( dire ) ) } )
               IF Pos > 0
                  ADel( vExtraFoldersForSearchHB, Pos )
                  ASize( vExtraFoldersForSearchHB, Len( vExtraFoldersForSearchHB ) - 1 )
               ENDIF
            ELSE
               Pos := AScan( vExtraFoldersForSearchC, { |y| US_Upper( y ) == US_Upper( ChgPathToReal( dire ) ) } )
               IF Pos > 0
                  ADel( vExtraFoldersForSearchC, Pos )
                  ASize( vExtraFoldersForSearchC, Len( vExtraFoldersForSearchC ) - 1 )
               ENDIF
            ENDIF
         ENDIF
         IF bTop
            CambioTitulo()
            IF GetProperty( 'VentanaMain', 'GPrgFiles', 'itemcount' ) > 0
               IF Prj_Warn_TopFile
                  IF MyMsgYesNo( DBLQT + ChgPathToReal( GetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', 1, NCOLPRGFULLNAME ) ) + DBLQT + CRLF + "is the new " + DBLQT + "Top File" + DBLQT + "." + CRLF + ;
                                 'Omit this message from now on?' )
                     Prj_Warn_TopFile := .F.
                     MyMsgInfo( 'Use ' + DBLQT + PUB_MenuResetWarnings + DBLQT + ' option of Settings menu to enable the previous message.' )
                  ENDIF
               ENDIF
            ENDIF
         ENDIF
      ENDIF
   ENDIF
   DoMethod( 'VentanaMain', 'GPrgFiles', 'ColumnsAutoFitH' )
RETURN .T.

FUNCTION QPM_RemoveFileHEA()
   LOCAL pos, dire, i, bBorrar := .T.
   LOCAL item := VentanaMain.GHeaFiles.Value
   IF VentanaMain.GHeaFiles.Value > 0
      IF MyMsgYesNo( 'Remove file' + CRLF + DBLQT + ChgPathToReal( GetProperty( 'VentanaMain', 'GHeaFiles', 'Cell', VentanaMain.GHeaFiles.Value, NCOLHEAFULLNAME ) ) + DBLQT + CRLF + 'from project?', 'Confirm' )
         dire := US_FileNameOnlyPath( GetProperty( 'VentanaMain', 'GHeaFiles', 'Cell', VentanaMain.GHeaFiles.Value, NCOLHEAFULLNAME ) )
         IF GridImage( 'VentanaMain', 'GHeaFiles', item, NCOLHEASTATUS, '?', PUB_nGridImgSearchOk )
            TotCaption( 'HEA', -1 )
         ENDIF
         VentanaMain.GHeaFiles.DeleteItem( VentanaMain.GHeaFiles.Value )
         IF item > VentanaMain.GHeaFiles.ItemCount
            item := VentanaMain.GHeaFiles.ItemCount
         ENDIF
         SetProperty( 'VentanaMain', 'GHeaFiles', 'value', item )
         RichEditDisplay( 'HEA' )
         FOR i := 1 TO VentanaMain.GPrgFiles.ItemCount
            IF dire == US_FileNameOnlyPath( GetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', i, NCOLPRGFULLNAME ) )
               bBorrar := .F.
            ENDIF
         NEXT
         FOR i:= 1 TO VentanaMain.GPanFiles.ItemCount
            IF dire == US_FileNameOnlyPath( GetProperty( 'VentanaMain', 'GPanFiles', 'Cell', i, NCOLPANFULLNAME ) )
               bBorrar := .F.
            ENDIF
         NEXT
         FOR i := 1 TO VentanaMain.GDbfFiles.ItemCount
            IF dire == US_FileNameOnlyPath( GetProperty( 'VentanaMain', 'GDbfFiles', 'Cell', i, NCOLDBFFULLNAME ) )
               bBorrar := .F.
            ENDIF
         NEXT
         FOR i := 1 TO VentanaMain.GHeaFiles.ItemCount
            IF dire == US_FileNameOnlyPath( GetProperty( 'VentanaMain', 'GHeaFiles', 'Cell', i, NCOLHEAFULLNAME ) )
               bBorrar := .F.
            ENDIF
         NEXT
         Pos := AScan( vExtraFoldersForSearchHB, { |y| US_Upper( y ) == US_Upper( ChgPathToReal( dire ) ) } )
         IF Pos > 0 .AND. bBorrar
            ADel( vExtraFoldersForSearchHB, Pos )
            ASize( vExtraFoldersForSearchHB, Len( vExtraFoldersForSearchHB ) - 1 )
         ENDIF
         Pos := AScan( vExtraFoldersForSearchC, { |y| US_Upper( y ) == US_Upper( ChgPathToReal( dire ) ) } )
         IF Pos > 0 .AND. bBorrar
            ADel( vExtraFoldersForSearchC, Pos )
            ASize( vExtraFoldersForSearchC, Len( vExtraFoldersForSearchC ) - 1 )
         ENDIF
      ENDIF
   ENDIF
   DoMethod( 'VentanaMain', 'GHeaFiles', 'ColumnsAutoFitH' )
RETURN .T.

FUNCTION QPM_RemoveFilePAN()
   LOCAL pos, dire, i, bBorrar := .T.
   LOCAL item := VentanaMain.GPanFiles.Value
   IF VentanaMain.GPanFiles.Value > 0
      IF MyMsgYesNo( 'Remove file' + CRLF + DBLQT + ChgPathToReal( GetProperty( 'VentanaMain', 'GPanFiles', 'Cell', VentanaMain.GPanFiles.Value, NCOLPANFULLNAME ) ) + DBLQT + CRLF + 'from project?', 'Confirm' )
         dire := US_FileNameOnlyPath( GetProperty( 'VentanaMain', 'GPanFiles', 'Cell', VentanaMain.GPanFiles.Value, NCOLPANFULLNAME ) )
         IF GridImage( 'VentanaMain', 'GPanFiles', item, NCOLPANSTATUS, '?', PUB_nGridImgSearchOk )
            TotCaption( 'PAN', -1 )
         ENDIF
         VentanaMain.GPanFiles.DeleteItem( VentanaMain.GPanFiles.Value )
         IF item > VentanaMain.GPanFiles.ItemCount
            item := VentanaMain.GPanFiles.ItemCount
         ENDIF
         SetProperty( 'VentanaMain', 'GPanFiles', 'value', item )
         RichEditDisplay( 'PAN' )
         FOR i := 1 TO VentanaMain.GPrgFiles.ItemCount
            IF dire == US_FileNameOnlyPath( GetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', i, NCOLPRGFULLNAME ) )
               bBorrar := .F.
            ENDIF
         NEXT
         FOR i := 1 TO VentanaMain.GPanFiles.ItemCount
            IF dire == US_FileNameOnlyPath( GetProperty( 'VentanaMain', 'GPanFiles', 'Cell', i, NCOLPANFULLNAME ) )
               bBorrar := .F.
            ENDIF
         NEXT
         FOR i := 1 TO VentanaMain.GHeaFiles.ItemCount
            IF dire == US_FileNameOnlyPath( GetProperty( 'VentanaMain', 'GHeaFiles', 'Cell', i, NCOLHEAFULLNAME ) )
               bBorrar := .F.
            ENDIF
         NEXT
         Pos := AScan( vExtraFoldersForSearchHB, { |y| US_Upper( y ) == US_Upper( ChgPathToReal( dire ) ) } )
         IF Pos > 0 .AND. bBorrar
            ADel( vExtraFoldersForSearchHB, Pos )
            ASize( vExtraFoldersForSearchHB, Len( vExtraFoldersForSearchHB ) - 1 )
         ENDIF
      ENDIF
   ENDIF
   DoMethod( 'VentanaMain', 'GPanFiles', 'ColumnsAutoFitH' )
RETURN .T.

FUNCTION QPM_RemoveFileDBF()
   LOCAL item := VentanaMain.GDbfFiles.Value
   IF VentanaMain.GDbfFiles.Value > 0
      IF MyMsgYesNo( 'Remove file' + CRLF + DBLQT + ChgPathToReal( GetProperty( 'VentanaMain', 'GDbfFiles', 'Cell', VentanaMain.GDbfFiles.Value, NCOLDBFFULLNAME ) ) + DBLQT + CRLF + 'from project?', 'Confirm' )
         IF GridImage( 'VentanaMain', 'GDbfFiles', item, NCOLDBFSTATUS, '?', PUB_nGridImgSearchOk )
            TotCaption( 'DBF', -1 )
         ENDIF
         VentanaMain.GDbfFiles.DeleteItem( VentanaMain.GDbfFiles.Value )
         IF item > VentanaMain.GDbfFiles.ItemCount
            item := VentanaMain.GDbfFiles.ItemCount
         ENDIF
         SetProperty( 'VentanaMain', 'GDbfFiles', 'value', item )
         IF item == 0
            CloseDbfAutoView()
            VentanaMain.RichEditDbf.Value := ''
         ELSE
            RichEditDisplay( 'DBF' )
         ENDIF
      ENDIF
   ENDIF
   DoMethod( 'VentanaMain', 'GDbfFiles', 'ColumnsAutoFitH' )
RETURN .T.

FUNCTION QPM_RemoveDefaultLIB()
   LOCAL item := VentanaMain.GDefFiles.Value
   LOCAL cFileUpper := US_Upper( GetProperty( 'VentanaMain', 'GDefFiles', 'Cell', item, NCOLDEFNAME ) )
   IF cFileUpper == GetGTGUIName() .OR. cFileUpper == GetGTWINName() .OR. cFileUpper == US_Upper( GetMiniguiName() ) .OR. ;
      ( AScan( { 'VM.LIB', 'LIBVM.A', 'HBVM.LIB', 'LIBHBVM.A', 'VM64.LIB', 'VMMT.LIB', 'LIBVMMT.A', 'HBVMMT.LIB', ;
                 'LIBHBVMMT.A', 'VMMT64.LIB', 'DEBUG.LIB', 'LIBDEBUG.A', 'HBDEBUG.LIB', 'LIBHBDEBUG.A', 'DEBUGGER.LIB', ;
                 'LIBDEBUGGER.A', 'HBDEBUGGER.LIB', 'LIBHBDEBUGGER.A', 'C0X32.OBJ', 'C0W32.OBJ' }, cFileUpper ) # 0 )
      MyMsgStop( "It's not allowed to remove this file from the default list!" + CRLF + ;
                 'Use "Exclude" section to remove it from this project.' )
      RETURN .F.
   ENDIF
   IF VentanaMain.GDefFiles.Value > 0
      IF MyMsgYesNo( 'Remove file' + CRLF + DBLQT + GetProperty( 'VentanaMain', 'GDefFiles', 'Cell', VentanaMain.GDefFiles.Value, NCOLDEFNAME ) + DBLQT + CRLF + 'from default libraries list?', 'Confirm' )
         IF GridImage( 'VentanaMain', 'GDefFiles', item, NCOLDEFSTATUS, '?', PUB_nGridImgSearchOk )
            TotCaption( 'LIB', -1 )
         ENDIF
         VentanaMain.GDefFiles.DeleteItem( VentanaMain.GDefFiles.Value )
         IF item > VentanaMain.GDefFiles.ItemCount
            item := VentanaMain.GDefFiles.ItemCount
         ENDIF
         SetProperty( 'VentanaMain', 'GDefFiles', 'value', item )
         RichEditDisplay( 'DEF' )
      ENDIF
   ENDIF
   DoMethod( 'VentanaMain', 'GDefFiles', 'ColumnsAutoFitH' )
RETURN .T.

FUNCTION QPM_RemoveFileLIB()
   LOCAL pos, dire, i, bBorrar := .T.
   LOCAL item := VentanaMain.GIncFiles.Value
   IF VentanaMain.GIncFiles.Value > 0
      IF MyMsgYesNo( 'Remove file' + CRLF + DBLQT + ChgPathToReal( US_WordSubStr( GetProperty( 'VentanaMain', 'GIncFiles', 'Cell', VentanaMain.GIncFiles.Value, NCOLINCFULLNAME ), 3 ) ) + DBLQT + CRLF + 'from project?', 'Confirm' )
         dire := US_Upper( US_FileNameOnlyPath( ChgPathToReal( US_WordSubStr( GetProperty( 'VentanaMain', 'GIncFiles', 'Cell', VentanaMain.GIncFiles.Value, NCOLINCFULLNAME ), 3 ) ) ) )
         IF GridImage( 'VentanaMain', 'GIncFiles', item, NCOLINCSTATUS, '?', PUB_nGridImgSearchOk )
            TotCaption( 'LIB', -1 )
         ENDIF
         VentanaMain.GIncFiles.DeleteItem( VentanaMain.GIncFiles.Value )
         IF item > VentanaMain.GIncFiles.ItemCount
            item := VentanaMain.GIncFiles.ItemCount
         ENDIF
         SetProperty( 'VentanaMain', 'GIncFiles', 'value', item )
         RichEditDisplay( 'INC' )
         Pos := AScan( &('vExtraFoldersForLibs'+GetSuffix()), dire )
         FOR i := 1 TO VentanaMain.GIncFiles.ItemCount
            IF dire == US_Upper( US_FileNameOnlyPath( ChgPathToReal( US_WordSubStr( GetProperty( 'VentanaMain', 'GIncFiles', 'Cell', i, NCOLINCFULLNAME ), 3 ) ) ) )
               bBorrar := .F.
            ENDIF
         NEXT
         IF Pos > 0 .AND. bBorrar
            ADel( &('vExtraFoldersForLibs'+GetSuffix()), Pos )
            ASize( &('vExtraFoldersForLibs'+GetSuffix()), Len( &('vExtraFoldersForLibs'+GetSuffix()) ) - 1 )
         ENDIF
      ENDIF
   ENDIF
   DoMethod( 'VentanaMain', 'GIncFiles', 'ColumnsAutoFitH' )
RETURN .T.

FUNCTION QPM_RemoveExcludeFileLIB()
   LOCAL item := VentanaMain.GExcFiles.Value
   IF VentanaMain.GExcFiles.Value > 0
      IF MyMsgYesNo( 'Remove file' + CRLF + DBLQT + GetProperty( 'VentanaMain', 'GExcFiles', 'Cell', VentanaMain.GExcFiles.Value, NCOLEXCNAME ) + DBLQT + CRLF + 'from exclude list?', 'Confirm' )
         IF GridImage( 'VentanaMain', 'GExcFiles', item, NCOLINCSTATUS, '?', PUB_nGridImgSearchOk )
            TotCaption( 'LIB', -1 )
         ENDIF
         VentanaMain.GExcFiles.DeleteItem( VentanaMain.GExcFiles.Value )
         IF item > VentanaMain.GExcFiles.ItemCount
            item := VentanaMain.GExcFiles.ItemCount
         ENDIF
         SetProperty( 'VentanaMain', 'GExcFiles', 'value', item )
         //RichEditDisplay( 'EXC' )
      ENDIF
   ENDIF
   DoMethod( 'VentanaMain', 'GExcFiles', 'ColumnsAutoFitH' )
RETURN .T.

#ifdef QPM_SHG
FUNCTION QPM_RemoveFileHLP()
   LOCAL nAuxRecord, item := VentanaMain.GHlpFiles.Value
   IF VentanaMain.GHlpFiles.Value > 2
      IF MyMsgYesNo('Remove topic ' + AllTrim( GetProperty( 'VentanaMain', 'GHlpFiles', 'Cell', VentanaMain.GHlpFiles.Value, NCOLHLPTOPIC ) ) + ' From Help?','Confirm')
         bHlpMoving := .T.
         nAuxRecord := VentanaMain.GHlpFiles.Value
         IF GridImage( 'VentanaMain', 'GHlpFiles', item, NCOLHLPSTATUS, '?', PUB_nGridImgSearchOk )
            TotCaption( 'HLP', -1 )
         ENDIF
         VentanaMain.GHlpFiles.DeleteItem( VentanaMain.GHlpFiles.Value )
         IF item > VentanaMain.GHlpFiles.ItemCount
            item := VentanaMain.GHlpFiles.ItemCount
         ENDIF
         SetProperty( 'VentanaMain', 'GHlpFiles', 'value', item )
         SHG_DeleteRecord( nAuxRecord )
         RichEditDisplay( 'HLP' )
         bHlpMoving := .F.
      ENDIF
   ELSE
      IF VentanaMain.GHlpFiles.Value == 1
         MyMsgStop( "Global footer can't be edited!" )
         RETURN .F.
      ENDIF
      IF VentanaMain.GHlpFiles.Value == 2
         MyMsgStop( "Welcome page can't be deleted!" )
         RETURN .F.
      ENDIF
   ENDIF
   DoMethod( 'VentanaMain', 'GHlpFiles', 'ColumnsAutoFitH' )
RETURN .T.
#endif

#ifdef QPM_SHG
FUNCTION QPM_RemoveKeyHLP()
   LOCAL item := VentanaMain.GHlpKeys.Value, MemoAux := '', i
   IF VentanaMain.GHlpKeys.Value > 0
         VentanaMain.GHlpKeys.DeleteItem( VentanaMain.GHlpKeys.Value )
         IF item > VentanaMain.GHlpKeys.ItemCount
            item := VentanaMain.GHlpKeys.ItemCount
         ENDIF
         SetProperty( 'VentanaMain', 'GHlpKeys', 'value', item )
         FOR i := 1 TO VentanaMain.GHlpKeys.ItemCount
            MemoAux := MemoAux + iif( i > 1, CRLF, '' ) + VentanaMain.GHlpKeys.Cell( i, 1 )
         NEXT
         SHG_SetField( 'SHG_KEYST', VentanaMain.GHlpFiles.Value, MemoAux )
   ENDIF
   DoMethod( 'VentanaMain', 'GHlpKeys', 'ColumnsAutoFitH' )
RETURN .T.
#endif

FUNCTION LibInfo()
   LOCAL a, b, c
   IF VentanaMain.GIncFiles.Value > 0
      a := 'Library name: ' + US_FileNameOnlyNameAndExt( ChgPathToReal( US_WordSubStr( GetProperty( 'VentanaMain', 'GIncFiles', 'Cell', VentanaMain.GIncFiles.Value, NCOLINCFULLNAME ), 3 ) ) )
      b := '   in folder: ' + US_FileNameOnlyPath( ChgPathToReal( US_WordSubStr( GetProperty( 'VentanaMain', 'GIncFiles', 'Cell', VentanaMain.GIncFiles.Value, NCOLINCFULLNAME ), 3 ) ) )
      c := 'was concatenated ' + iif( US_Upper( US_Word( GetProperty( 'VentanaMain', 'GIncFiles', 'Cell', VentanaMain.GIncFiles.Value, NCOLINCFULLNAME ), 2 ) ) == '*FIRST*', 'BEFORE MiniGui library', 'AFTER last significant library.' )
      MyMsgInfo( a + CRLF + ;
                 b + CRLF + ;
                 ' ' + CRLF + ;
                 c + CRLF + ;
                 'Status: ' + LibCheck( VentanaMain.GIncFiles.Value ) )
   ENDIF
RETURN .T.

FUNCTION LibExcludeInfo()
   LOCAL a, c
   IF VentanaMain.GExcFiles.Value > 0
      a := 'Library ' + GetProperty( 'VentanaMain', 'GExcFiles', 'Cell', VentanaMain.GExcFiles.Value, NCOLEXCNAME )
      c := 'will be excluded from the build process.'
      MyMsgInfo( a + CRLF + ;
                 ' ' + CRLF + ;
                 c )
   ENDIF
RETURN .T.

FUNCTION DefinoWindowsHotKeys()
   SET HELPFILE TO PUB_cQPM_Folder + DEF_SLASH + 'QPM.chm'
   ON KEY F1 OF VentanaMain ACTION US_DisplayHelpTopic( GetActiveHelpFile(), 1 )
   ON KEY F2 OF VentanaMain ACTION QPM_OpenProject()
   ON KEY F3 OF VentanaMain ACTION QPM_SaveProject()
   ON KEY F4 OF VentanaMain ACTION QPM_Build()
   ON KEY F5 OF VentanaMain ACTION QPM_Run( bRunParm )
   ON KEY F10 OF VentanaMain ACTION QPM_EXIT( .T. )
#ifdef QPM_SHG
   ON KEY CONTROL+C OF VentanaMain ACTION SHG_Send_Copy()
   ON KEY CONTROL+X OF VentanaMain ACTION SHG_Send_Cut()
   ON KEY CONTROL+V OF VentanaMain ACTION SHG_Send_Paste()
#else
   ON KEY CONTROL+C OF VentanaMain ACTION ( US_Send_Copy(), DoEvents() )
   ON KEY CONTROL+X OF VentanaMain ACTION ( US_Send_Cut(), DoEvents() )
   ON KEY CONTROL+V OF VentanaMain ACTION ( US_Send_Paste(), DoEvents() )
#endif
RETURN .T.

FUNCTION LiberoWindowsHotKeys()
   _HMG_ActiveHelpFile := ""
   RELEASE KEY F1 OF VentanaMain
   RELEASE KEY F2 OF VentanaMain
   RELEASE KEY F3 OF VentanaMain
   RELEASE KEY F4 OF VentanaMain
   RELEASE KEY F5 OF VentanaMain
   RELEASE KEY F10 OF VentanaMain
   RELEASE KEY CONTROL+C OF VentanaMain
   RELEASE KEY CONTROL+X OF VentanaMain
   RELEASE KEY CONTROL+V OF VentanaMain
RETURN .T.

FUNCTION TranslateLog( Log )
   LOCAL NewLog, i, e, w, j, d, aLines, cErrLvl, nIndLineRC, nIndNameRC, aData
   LOCAL objfolder    := Chr(10) + Upper( US_ShortName( GetObjFolder() ) )
   LOCAL nLenOF       := Len( objfolder )
   LOCAL qpmfolder    := US_ShortName( PUB_cQPM_Folder )
   LOCAL cppfolder    := US_ShortName( GetCppFolder() ) + DEF_SLASH + 'BIN'
   LOCAL msg          := DBLQT + qpmfolder + DEF_SLASH + 'US_MSG.EXE'+ DBLQT + " " + Q_PROGRESS_LOG + ' -MSG:'
   LOCAL slash        := DBLQT + qpmfolder + DEF_SLASH + 'US_SLASH.EXE' + DBLQT + ' QPM'
   LOCAL slashlist    := DBLQT + qpmfolder + DEF_SLASH + 'US_SLASH.EXE' + DBLQT + ' QPM -LIST' + qpmfolder
   LOCAL upx          := DBLQT + qpmfolder + DEF_SLASH + 'US_UPX.EXE' + DBLQT
   LOCAL shellCZ      := DBLQT + qpmfolder + DEF_SLASH + 'US_SHELL.EXE' + DBLQT + ' QPM COPYZAP '
   LOCAL shellMZ      := DBLQT + qpmfolder + DEF_SLASH + 'US_SHELL.EXE' + DBLQT + ' QPM MOVEZAP '
   LOCAL shell        := DBLQT + qpmfolder + DEF_SLASH + 'US_SHELL.EXE' + DBLQT + ' QPM '
   LOCAL implib       := DBLQT + qpmfolder + DEF_SLASH + 'US_IMPLIB.EXE' + DBLQT
   LOCAL implibPelles := DBLQT + qpmfolder + DEF_SLASH + 'US_POLIB.EXE' + DBLQT
   LOCAL impdef       := DBLQT + qpmfolder + DEF_SLASH + 'US_IMPDEF.EXE' + DBLQT
   LOCAL PExports     := DBLQT + qpmfolder + DEF_SLASH + 'US_PEXPORTS.EXE' + DBLQT
   LOCAL reimp        := DBLQT + qpmfolder + DEF_SLASH + 'US_REIMP.EXE' + DBLQT
   LOCAL harbour      := US_ShortName( GetHarbourFolder() ) + DEF_SLASH + 'BIN' + DEF_SLASH + 'HARBOUR.EXE'
   LOCAL gcc          := cppfolder + DEF_SLASH + 'GCC.EXE'    
   LOCAL pocc         := cppfolder + DEF_SLASH + 'POCC.EXE'   
   LOCAL bcc32        := cppfolder + DEF_SLASH + 'BCC32.EXE'  
   LOCAL brc32        := cppfolder + DEF_SLASH + 'BRCC32.EXE' 
   LOCAL ilink32      := cppfolder + DEF_SLASH + 'ILINK32.EXE'
   LOCAL windres      := cppfolder + DEF_SLASH + 'WINDRES.EXE'
   LOCAL dlltool      := cppfolder + DEF_SLASH + 'DLLTOOL.EXE'
   LOCAL ImpLibBor    := Chr(10) + 'Borland Implib Version 3.0.22 Copyright (c) 1991, 2000 Inprise Corporation' + Chr(10)
   LOCAL ImpDefBor    := Chr(10) + 'Borland Impdef Version 3.0.22 Copyright (c) 1991, 2000 Inprise Corporation' + Chr(10)
   LOCAL QPM_Ver      := '/D__QPM_VERSION__="' + "'" + QPM_VERSION_NUMBER_SHORT + "'" + '" '
   LOCAL PRJ_Ver      := '/D__PRJ_VERSION__="' + "'" + cPrj_Version + "'" + '" '
   LOCAL PRJ_Folder   := '/D__PROJECT_FOLDER__="' + "'" + VentanaMain.TProjectFolder.Value + "'" + '" '
   LOCAL cEcho2       := '>> ' + Q_SCRIPT_FILE
   LOCAL cEcho        := '> ' + Q_SCRIPT_FILE
   LOCAL cDelete      := '** error 1 ** '
   LOCAL TMP_RC       := US_FileNameOnlyNameAndExt( QPM_TMP_RC )
                          /* Texto,  Position ( 0=Cualquiera ), Producto */
   LOCAL vWarnings    := { { ') Warning W',                                0, DefineXHarbour }, ; // Warning en Compilaciones
                           { 'Warning W',                                  1, 'CBORLAND' }, ;     // Warning en funcion C
                           { ': warning: ',                                0, 'CMINGW' }, ;       // Warning en funcion C
                           { ': No such file or directory',                0, 'RMINGW' }, ;       // Warning en Resource Compiler (include not found)
                           { 'Duplicate resource:',                        1, 'RBORLAND' }, ;     // Warning en Resource Compiler
                           { 'warning: ',                                  1, 'LNKBORLAND' }, ;   // Warning en Linkeditor de Borland (No recuerdo si aparecia en minuscula por eso lo agrego
                           { 'Warning: ',                                  1, 'LNKBORLAND' }, ;   // Warning en Linkeditor o TLIB de Borland
                           { 'POLIB: warning: ',                           1, 'LIBPELLES' }, ;    // Warning en creacion de libreria Pelles C
                           { 'POLINK: warning: ',                          1, 'LNKPELLES' } ;     // Warning en Linkeditor de Pelles C
                         }
   LOCAL vErrors      := { { '** error 1 **',                              1, 'LNKMINGW' }, ;     // Error en linkedicion MinGW
                           { '** error 2 **',                              1, 'LNKBORLAND' }, ;   // Error en Linkeditor de Borland
                           { 'Error: Unresolved external',                 1, 'LNKBORLAND' }, ;   // Error en Linkeditor de Borland
                           { 'Fatal: Access violation.  Link terminated.', 1, 'LNKBORLAND' }, ;   // Error en Linkeditor de Borland
                           { 'Fatal: Could not open',                      1, 'LNKBORLAND' }, ;   // Error en Linkeditor de Borland
                           { 'POLIB: error: ',                             1, 'LIBPELLES' }, ;    // Error en Libreria de Pelles C
                           { 'POLINK: error: ',                            1, 'LNKPELLES' }, ;    // Error en Linkeditor de Pelles C
                           { 'POLINK: fatal error: ',                      1, 'LNKPELLES' }, ;    // Error en Linkeditor de Pelles C
                           { 'Packed 0 files.',                            1, 'UPX' }, ;          // Error en UPX
                           { 'Packed 1 file: 0 ok, 1 error.',              1, 'UPX' }, ;          // Error en UPX
                           { 'error:',                                     1, 'RC compiler' }, ;
                           { 'Error ' + TMP_RC + ' ',                      1, 'RC compiler' }, ;
                           { 'No code generated.',                         1, 'compiler' }, ;
                           { "compilation terminated.",                    1, 'compiler' }, ;
                           { "preprocessing failed.",                      1, 'compiler' } ;
                         }

   VentanaMain.RichEditSysout.Value := VentanaMain.RichEditSysout.Value + CRLF + US_TimeDis( Time() ) + ' - >>>>>>> Reading Process Output ...'
   VentanaMain.RichEditSysout.SetFocus()
   VentanaMain.RichEditSysout.CaretPos := Len( VentanaMain.RichEditSysout.Value )

// Set build's error level
   cErrLvl := US_Word( MemoRead( END_FILE ), 1 )
   IF cErrLvl == 'OK'
      FOR i := 1 TO Len( vWarnings )
         IF At( vWarnings[i][1], Log ) > 0
            QPM_MemoWrit( END_FILE, ( cErrLvl := 'WARNING' ) )
            EXIT
         ENDIF
      NEXT
   ENDIF
   IF ! cErrLvl == 'ERROR'
      FOR i := 1 TO Len( vErrors )
         IF At( vErrors[i][1], Log ) > 0
            QPM_MemoWrit( END_FILE, ( cErrLvl := 'ERROR' ) )
            EXIT
         ENDIF
      NEXT
   ENDIF

// Start of log beautification

   IF ! PUB_DeleteAux
      QPM_MemoWrit( US_FileNameOnlyPathAndName( TEMP_LOG ) + ".save", Log )
   ENDIF

// This lines must come FIRST and its order IS significant
   NewLog := Chr(10) + Log + Chr(10)
   NewLog := StrTran( NewLog, CRLF, Chr(10) )
   NewLog := StrTran( NewLog, Chr(13), Chr(10) )
   NewLog := StrTran( NewLog, PUB_cCharTab, " " )
   NewLog := StrTran( NewLog, DEF_SLASH + DEF_SLASH, DEF_SLASH )
   DO WHILE At( Chr(10) + Chr(10), NewLog ) > 0
      NewLog := StrTran( NewLog, Chr(10) + Chr(10), Chr(10) )
   ENDDO

// This lines must come SECOND and it's order IS NOT significant
   NewLog := StrTran( NewLog, msg, '==> ' )
   NewLog := StrTran( NewLog, slash, 'GCC' )
   NewLog := StrTran( NewLog, slashlist, 'GCC' )
   NewLog := StrTran( NewLog, upx, 'UPX' )
   NewLog := StrTran( NewLog, shellCZ, 'COPY -z' )
   NewLog := StrTran( NewLog, shellMZ, 'MOVE -z' )
   NewLog := StrTran( NewLog, shell, '' )
   NewLog := StrTran( NewLog, implib, "GENERATE 'LIB'" )
   NewLog := StrTran( NewLog, implibPelles, "GENERATE 'LIB'" )
   NewLog := StrTran( NewLog, impdef, "LIST 'DLL'" )
   NewLog := StrTran( NewLog, PExports, "LIST 'DLL'" )
   NewLog := StrTran( NewLog, reimp, 'ReIMPORT ' )
   NewLog := StrTran( NewLog, "WINDRES: ", '' )
   NewLog := StrTran( NewLog, QPM_TMP_RC, ' QPM_TMP_RC ' )
   NewLog := StrTran( NewLog, ' -o', ' -o ' )
   NewLog := StrTran( NewLog, cEcho2, '' )
   NewLog := StrTran( NewLog, cEcho, '' )
   NewLog := StrTran( NewLog, ImpLibBor, '' )
   NewLog := StrTran( NewLog, ImpDefBor, '' )
   NewLog := StrTran( NewLog, QPM_Ver, '' )
   NewLog := StrTran( NewLog, PRJ_Ver, '' )
   NewLog := StrTran( NewLog, PRJ_Folder, '' )
   NewLog := StrTran( NewLog, cDelete, '' )
   NewLog := StrTran( NewLog, Chr(10) + "US_Shell ", Chr(10) )
   NewLog := StrTran( NewLog, " US_Shell ", '' )
   NewLog := StrTran( NewLog, Chr(10) + "Copyright (c) ", " Copyright (c) " )

   IF At( Chr(10) + 'Error ' + TMP_RC + ' ', NewLog ) > 0
      // Read RC file and build an array of lines
      aLines := hb_ATokens( MemoRead( QPM_TMP_RC ), CRLF )
   ENDIF
   i := 1
   DO WHILE ( e := At( Chr(10) + 'Error ' + TMP_RC + ' ', SubStr( NewLog, i ) ) ) > 0
      nIndNameRC := i + e + 6
      nIndLineRC := j := i + e + 7 + Len( TMP_RC )
      w := "0"
      DO WHILE IsDigit( d := SubStr( NewLog, j, 1 ) )
         w += d
         j ++
      ENDDO
      i := j
      IF ( w := Val( w ) ) > 0
         // Locate the real file and the line number
         aData := SearchRealNameAndLineRC( aLines, w )   // return {RC filename, RC line number}
         IF Empty( aData[1] )
            NewLog := Left( NewLog, nIndNameRC - 1 ) + "in QPM_TMP_RC at line/col " + SubStr( NewLog, nIndLineRC )
            // Add offending line
            j := At( Chr(10), SubStr( NewLog, i ) )
            NewLog := Left( NewLog, i + j - 2 ) + ": " + aLines[w] + SubStr( NewLog, i + j - 1 )
            i := i + j + Len( aLines[w] )
         ELSE
            // Insert RC's name and line number into the log
            NewLog := Left( NewLog, nIndNameRC - 1 ) + "in " + aData[1] + " at line/col " + aData[2] + SubStr( NewLog, j )
            // Add offending line
            j := At( Chr(10), SubStr( NewLog, i ) )
            NewLog := Left( NewLog, i + j - 2 ) + ": " + aLines[w] + SubStr( NewLog, i + j - 1 )
            // Continue from
            i := At( Chr(10), SubStr( NewLog, nIndNameRC ) ) + 1
         ENDIF
      ENDIF
   ENDDO

// This lines must come THIRD and it's order IS significant
   NewLog := StrTran( NewLog, Chr(10) + '==> QPM_TMP_RC is ', Chr(10) + 'QPM_TMP_RC is ' )
   NewLog := StrTran( NewLog, Chr(10) + '==> SCRIPT_FILE is ', Chr(10) + 'SCRIPT_FILE is ' )
   NewLog := StrTran( NewLog, Q_SCRIPT_FILE, 'SCRIPT_FILE' )
   NewLog := StrTran( NewLog, DBLQT + harbour + DBLQT, 'HARBOUR' )
   NewLog := StrTran( NewLog, harbour, 'HARBOUR' )
   NewLog := StrTran( NewLog, DBLQT + gcc + DBLQT, 'GCC' )
   NewLog := StrTran( NewLog, gcc, 'GCC' )
   NewLog := StrTran( NewLog, DBLQT + pocc + DBLQT, 'POCC' )
   NewLog := StrTran( NewLog, pocc, 'POCC' )
   NewLog := StrTran( NewLog, DBLQT + bcc32 + DBLQT, 'BCC32' )
   NewLog := StrTran( NewLog, bcc32, 'BCC32' )
   NewLog := StrTran( NewLog, DBLQT + brc32 + DBLQT, 'BRCC32' )
   NewLog := StrTran( NewLog, brc32, 'BRCC32' )
   NewLog := StrTran( NewLog, DBLQT + ilink32 + DBLQT, 'ILINK32' )
   NewLog := StrTran( NewLog, ilink32, 'ILINK32' )
   NewLog := StrTran( NewLog, DBLQT + windres + DBLQT, 'WINDRES' )
   NewLog := StrTran( NewLog, windres, 'WINDRES' )
   NewLog := StrTran( NewLog, DBLQT + dlltool + DBLQT, "GENERATE 'A'" )
   NewLog := StrTran( NewLog, dlltool, "GENERATE 'A'" )
   NewLog := StrTran( NewLog, " QPM_TMP_RC :", 'QPM_TMP_RC line ' )

// Remove or translate obscure or uninformative messages
   i := 1
   DO WHILE ( e := At( "fatal error: when writing output to : Broken pipe", SubStr( NewLog, i ) ) ) > 0
      w := RAt( Chr(10), Left( NewLog, i + e - 2 ) )
      j := At( Chr(10), SubStr( NewLog, i + e ) )
      NewLog := Left( NewLog, w ) + SubStr( NewLog, i + e + j )
      i := w + 1
   ENDDO
   i := 1
   DO WHILE ( e := At( " error" + Chr(10) + "No code generated.", SubStr( NewLog, i ) ) ) > 0
      w := RAt( Chr(10), Left( NewLog, i + e - 2 ) )
      j := At( Chr(10), SubStr( NewLog, i + e ) )
      NewLog := Left( NewLog, w ) + SubStr( NewLog, i + e + j )
      i := w + 1
   ENDDO
   i := 1
   DO WHILE ( e := At( " errors" + Chr(10) + "No code generated.", SubStr( NewLog, i ) ) ) > 0
      w := RAt( Chr(10), Left( NewLog, i + e - 2 ) )
      j := At( Chr(10), SubStr( NewLog, i + e ) )
      NewLog := Left( NewLog, w ) + SubStr( NewLog, i + e + j )
      i := w + 1
   ENDDO
   i := 1
   DO WHILE ( e := At( "No code generated.", SubStr( NewLog, i ) ) ) > 0
      w := RAt( Chr(10), Left( NewLog, i + e - 2 ) )
      j := At( Chr(10), SubStr( NewLog, i + e ) )
      NewLog := Left( NewLog, w ) + SubStr( NewLog, i + e + j )
      i := w + 1
   ENDDO
   i := 1
   DO WHILE ( e := At( "compilation terminated.", SubStr( NewLog, i ) ) ) > 0
      w := RAt( Chr(10), Left( NewLog, i + e - 2 ) )
      j := At( Chr(10), SubStr( NewLog, i + e ) )
      NewLog := Left( NewLog, w ) + SubStr( NewLog, i + e + j )
      i := w + 1
   ENDDO
   i := 1
   DO WHILE ( e := At( "preprocessing failed.", SubStr( NewLog, i ) ) ) > 0
      w := RAt( Chr(10), Left( NewLog, i + e - 2 ) )
      j := At( Chr(10), SubStr( NewLog, i + e ) )
      NewLog := Left( NewLog, w ) + SubStr( NewLog, i + e + j )
      i := w + 1
   ENDDO
   i := 1
   DO WHILE ( e := At( "ld.exe: ", SubStr( NewLog, i ) ) ) > 0
      w := RAt( Chr(10), Left( NewLog, i + e - 2 ) )
      NewLog := Left( NewLog, w ) + "Error: " + SubStr( NewLog, i + e + 8 )
      i := w + 1
   ENDDO
   i := 1
   DO WHILE ( e := At( "collect2.exe: ", SubStr( NewLog, i ) ) ) > 0
      w := RAt( Chr(10), Left( NewLog, i + e - 2 ) )
      j := At( Chr(10), SubStr( NewLog, i + e ) )
      NewLog := Left( NewLog, w ) + SubStr( NewLog, i + e + j )
      i := w + 1
   ENDDO
   i := 1
   DO WHILE ( e := At( 'US_MAKE.EXE:', SubStr( NewLog, i ) ) ) > 0
      w := RAt( Chr(10), Left( NewLog, i + e - 2 ) )
      j := At( Chr(10), SubStr( NewLog, i + e ) )
      NewLog := Left( NewLog, w ) + SubStr( NewLog, i + e + j )
      i := w + 1
   ENDDO
   i := 1
   DO WHILE ( e := At( "deleting ", SubStr( NewLog, i ) ) ) > 0
      w := RAt( Chr(10), Left( NewLog, i + e - 2 ) )
      j := At( Chr(10), SubStr( NewLog, i + e ) )
      NewLog := Left( NewLog, w ) + SubStr( NewLog, i + e + j )
      i := w + 1
   ENDDO
   i := 1
   DO WHILE ( e := At( ".c:" + Chr(10), SubStr( NewLog, i ) ) ) > 0
      w := RAt( Chr(10), Left( NewLog, i + e - 2 ) )
      IF Upper( SubStr( NewLog, w, nLenOF ) ) == objfolder
         j := At( Chr(10), SubStr( NewLog, i + e ) )
         NewLog := Left( NewLog, w ) + SubStr( NewLog, i + e + j )
         i := w + 1
      ELSE
         i := i + e + 4
      ENDIF
   ENDDO

// From now on the order IS significant!

   IF At( "WINDRES: QPM_TMP_RC line ", NewLog ) > 0
      // Read RC file and build an array of lines
      aLines := hb_ATokens( MemoRead( QPM_TMP_RC ), CRLF )
   ENDIF
   i := 1
   DO WHILE ( e := At( "WINDRES: QPM_TMP_RC line ", SubStr( NewLog, i ) ) ) > 0
      nIndNameRC := i + e + 8
      nIndLineRC := j := i + e + 24
      w := "0"
      DO WHILE IsDigit( d := SubStr( NewLog, j, 1 ) )
         w += d
         j ++
      ENDDO
      i := j
      IF ( w := Val( w ) ) > 0
         // Locate the real file and the line number
         aData := SearchRealNameAndLineRC( aLines, w )   // return {RC filename, RC line number}
         IF Empty( aData[1] )
            // Add offending line
            j := At( Chr(10), SubStr( NewLog, i ) )
            NewLog := Left( NewLog, i + j - 2 ) + ": " + aLines[w] + SubStr( NewLog, i + j - 1 )
            i := i + j + Len( aLines[w] )
         ELSE
            // Insert RC's offending line into the log
            NewLog := Left( NewLog, nIndLineRC - 1 ) + aData[2] + SubStr( NewLog, j )
            // Add offending line
            j := At( Chr(10), SubStr( NewLog, i ) )
            NewLog := Left( NewLog, i + j - 2 ) + ": " + aLines[w] + SubStr( NewLog, i + j - 1 )
            // Insert RC's name into the log
            NewLog := Left( NewLog, nIndNameRC - 1 ) + aData[1] + SubStr( Newlog, nIndNameRC + Len( "QPM_TMP_RC" ) )
            // Continue from
            i := At( Chr(10), SubStr( NewLog, nIndNameRC ) ) + 1
         ENDIF
      ENDIF
   ENDDO

// Cleanup leading and trailing spaces, replace multiple spaces with a single one
   DO WHILE At( "  ", NewLog ) > 0
      NewLog := StrTran( NewLog, "  ", " " )
   ENDDO
   NewLog := StrTran( NewLog, " " + Chr(10), Chr(10) )
   NewLog := StrTran( NewLog, Chr(10) + " ", Chr(10) )

// Replace 2 or move empty line with a single one
   DO WHILE At( Chr(10) + Chr(10), NewLog ) > 0
      NewLog := StrTran( NewLog, Chr(10) + Chr(10), Chr(10) )
   ENDDO

// Add empty lines to improve readability of compiler output
   i := 1
   DO WHILE ( e := At( ') Error E', SubStr( NewLog, i ) ) ) > 0
      w := RAt( Chr(10), Left( NewLog, i + e - 2 ) )
      NewLog := Left( NewLog, w ) + Chr(10) + SubStr( NewLog, w + 1 )
      i := i + e + 8
   ENDDO
   i := 1
   DO WHILE ( e := At( ') Warning W', SubStr( NewLog, i ) ) ) > 0
      w := RAt( Chr(10), Left( NewLog, i + e - 2 ) )
      NewLog := Left( NewLog, w ) + Chr(10) + SubStr( NewLog, w + 1 )
      i := i + e + 10
   ENDDO

// Highlight message lines and indent others
   NewLog := StrTran( NewLog, Chr(10), Chr(10) + PUB_cCharTab )
   NewLog := StrTran( NewLog, PUB_cCharTab + '==> ', Chr(10) + '==> ' )

// Remove 'lonely' tab chars
   NewLog := StrTran( NewLog, PUB_cCharTab + Chr(10), Chr(10) )
   IF Right( NewLog, Len( PUB_cCharTab ) ) == PUB_cCharTab
     NewLog := Left( NewLog, Len( NewLog ) - Len( PUB_cCharTab) )
   ENDIF

// Remove empty lines at top leaving only one
   DO WHILE Left( NewLog, 2 ) == Chr(10) + Chr(10)
      NewLog := SubStr( NewLog, 2 )
   ENDDO

// Remove empty lines at bottom leaving only one
   DO WHILE Right( NewLog, 2 ) == Chr(10) + Chr(10)
      NewLog := Left( NewLog, Len( NewLog ) - 1 )
   ENDDO

// Replace tab char with 4 spaces
   NewLog := StrTran( NewLog, PUB_cCharTab, '    ' )

// Make the log readable
   NewLog := StrTran( NewLog, Chr(10), CRLF )

// Show build status

   NewLog += CRLF + "==> Build status: " + cErrLvl + CRLF

RETURN NewLog

FUNCTION SearchRealNameAndLineRC( aLines, w )
   LOCAL i, aRet, cData
   FOR i := w TO 1 STEP -1
      IF Left( aLines[i], 8 ) == "// line "
         EXIT
      ENDIF
   NEXT i
   IF i > 0
      cData := SubStr( aLines[i], 9 )
      aRet := { US_Word( cData, 2 ), LTrim( Str( w - i + Val( US_Word( cData, 1 ) ) - 1 ) ) }
   ELSE
      aRet := { "", LTrim( Str( w ) ) }
   ENDIF
RETURN aRet

FUNCTION SwitchAutoInc()
   VentanaMain.AutoInc.Checked := ! VentanaMain.AutoInc.Checked
   QPM_SetResumen()
RETURN .T.

FUNCTION SwitchHotKeys()
   VentanaMain.HotKeys.Checked := ! VentanaMain.HotKeys.Checked
   IF VentanaMain.HotKeys.Checked
      DefinoWindowsHotKeys()
   ELSE
      LiberoWindowsHotKeys()
   ENDIF
   QPM_SetResumen()
RETURN .T.

FUNCTION SwitchDebug()
   IF Empty( PUB_cProjectFolder ) .OR. ! US_IsDirectory( PUB_cProjectFolder )
      MyMsgStop( DBLQT + "Project Folder" + DBLQT + " is not a valid folder:" + CRLF + PUB_cProjectFolder + CRLF + 'Look at tab ' + DBLQT + PagePRG + DBLQT )
      RETURN .F.
   ENDIF
   IF VentanaMain.GPrgFiles.ItemCount == 0
      MyMsgInfo( "Can't switch debug flag when " + DBLQT + "Sources" + DBLQT + "list is Empty." + CRLF + "Look at tab " + DBLQT + PagePRG + DBLQT )
      RETURN .F.
   ENDIF
   IF PUB_bDebugActive == .T.
      PUB_bDebugActive          := .F.
      VentanaMain.Debug.Checked := .F.
   ELSE
      PUB_bDebugActive          := .T.
      VentanaMain.Debug.Checked := .T.
   ENDIF
   EraseOBJ()
   IF PUB_bLite
      VentanaLite.LFull.FontColor := DEF_COLORRED
      VentanaLite.LFull.Value     := 'Force non-incremental'
   ELSE
      VentanaMain.LFull.FontColor := DEF_COLORRED
      VentanaMain.LFull.Value     := 'Force non-incremental'
   ENDIF
   QPM_SetResumen()
RETURN .T.

FUNCTION ClearLog()
   FErase( PUB_cQPM_Folder + DEF_SLASH + 'QPM.LOG' )
RETURN .T.

FUNCTION ActOutputTypeSet()
   DO CASE
      CASE Prj_Radio_OutputType == DEF_RG_EXE
         bBuildRun := bBuildRunBack
         SetProperty( 'VentanaMain', 'bDropDownBandR', 'enabled', .T. )
         SetProperty( 'VentanaMain', 'run', 'enabled', .T. )
      CASE Prj_Radio_OutputType == DEF_RG_LIB
         bBuildRunBack := bBuildRun
         bBuildRun := .F.
         SetProperty( 'VentanaMain', 'bDropDownBandR', 'enabled', .F. )
         SetProperty( 'VentanaMain', 'run', 'enabled', .F. )
      CASE Prj_Radio_OutputType == DEF_RG_IMPORT
         bBuildRunBack := bBuildRun
         bBuildRun := .F.
         SetProperty( 'VentanaMain', 'bDropDownBandR', 'enabled', .F. )
         SetProperty( 'VentanaMain', 'run', 'enabled', .F. )
   ENDCASE
RETURN .T.

FUNCTION MainInitAutoRun()
   LOCAL i, bError := .F.
#ifdef QPM_HOTRECOVERY
   QPM_HR_Database := PUB_cQPM_Folder + DEF_SLASH + 'QPM_HotRecovery_' + QPM_VERSION_NUMBER_LONG + '.dbf'
   IF ! PUB_bLite
      IF ! File( QPM_HR_Database )
         QPM_Wait( 'QPM_HotRecovery_Migrate()', 'Creating or Migrating Hot Recovery Version database from previous releases ...' )
         MyMsgInfo( 'Migration finished.' )
      ELSE
         QPM_Wait( 'HotRecoveryDatabaseCompatibility( QPM_HR_Database )', 'Checking Compatibility on Hot Recovery Versions Database' )
      ENDIF
   ENDIF
#endif
   IF PUB_bLite
      VentanaLite.bStop.Enabled := .F.
      VentanaMain.Hide()
      VentanaLite.Activate()
      DoMethod( 'VentanaMain', 'Release' )
   ELSE
      VentanaMain.bStop.Enabled := .F.
      IF Len( PUB_vAutoRun ) > 0
         FOR i := 1 TO Len( PUB_vAutoRun )
            IF ! EVal( {|| &( PUB_vAutoRun[ i ] ) } )
               bError := .T.
               EXIT
            ENDIF
         NEXT
         IF bError .AND. bAutoEXIT
            bWaitForBuild := .F.
            QPM_EXIT()
         ENDIF
      ENDIF
   ENDIF
RETURN .T.

FUNCTION HideInitAutoRun()
   LOCAL i, bError := .F.
   IF Len( PUB_vAutoRun ) > 0
      FOR i := 1 TO Len( PUB_vAutoRun )
         IF ! Eval( {|| &( PUB_vAutoRun[ i ] ) } )
            bError := .T.
            EXIT
         ENDIF
      NEXT
      IF bError .AND. bAutoEXIT
         bWaitForBuild := .F.
         QPM_EXIT()
      ENDIF
   ENDIF
RETURN .T.

FUNCTION EnableButtonRun()
   IF bWaitForBuild
      DO WHILE BUILD_IN_PROGRESS
         DO EVENTS
      ENDDO
   ENDIF
   SetProperty( 'VentanaLite', 'Label_3', 'enabled', .T. )
   SetProperty( 'VentanaLite', 'BRunP', 'enabled', .T. )
   SetProperty( 'VentanaLite', 'BRun', 'enabled', .T. )
   ON KEY ESCAPE OF VentanaLite ACTION DoMethod( 'VentanaLite', 'release' )
RETURN .T.

FUNCTION FUNC_xRefPrgFmg( vConcatIncludeHB )
   LOCAL f, p, Fol := PUB_cProjectFolder+DEF_SLASH, MemoAux, i
   LOCAL vScanned := {}, vPRGFiles := {}, vPANFiles := {}
   QPM_LogText( "FUNC_xRefPrgFmg start" )
   MemoAux := MemoRead( PROGRESS_LOG )
   QPM_MemoWrit( PROGRESS_LOG, MemoAux + US_TimeDis( Time() ) + ' - Checking cross references between PRG files and FMG files ...' + CRLF )
   FOR f := 1 TO VentanaMain.GPanFiles.itemcount
      AAdd( vPANFiles, ChgPathToReal( GetProperty( 'VentanaMain', 'GPanFiles', 'Cell', f, NCOLPANFULLNAME ) ) )
   NEXT f
   FOR f := 1 TO Len( vPanFiles )
      FOR i := 1 TO Len( vConcatIncludeHB )
         IF File( vConcatIncludeHB[i]+DEF_SLASH+US_FileNameOnlyNameAndExt( vPanFiles[f] ) )
            IF ! ( US_Upper( US_ShortName( vConcatIncludeHB[i]+DEF_SLASH+US_FileNameOnlyNameAndExt( vPanFiles[f] ) ) ) == US_Upper( US_ShortName( vPanFiles[f] ) ) )
               QPM_LogText( "Warning on " + US_FileNameOnlyNameAndExt( vPanFiles[f] ) )
               MyMsgWarn( 'Folder ' + vConcatIncludeHB[i] + ' contains a form named ' + DBLQT + US_FileNameOnlyNameAndExt( vPanFiles[f] ) + DBLQT + "." + CRLF + ;
                          "Harbour's search process will locate it first and will therefore ignore the form located at folder " + DBLQT + US_FileNameOnlyPath( vPanFiles[f] ) + DBLQT + '.' )
            ELSE
               EXIT
            ENDIF
         ENDIF
      NEXT i
   NEXT f
   FOR f := 1 TO VentanaMain.GPrgFiles.itemcount
      AAdd( vPRGFiles, ChgPathToReal( GetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', f, NCOLPRGFULLNAME ) ) )
   NEXT f
   /* Nota: Lo referido a vSinLoadWindow y vXRefPrgFmg puede ser eliminado, si eso ocurre, provocamos que en cada BUILD se */
   /*       scaneen los PRG que no tienen LOAD WINDOW, enlenteciendo el proceso                                            */
   /*       Si se usa -BUILD como parametro no tiene ninguna implicancia ya que actúa despues de la primera pasada         */
   FOR f := 1 TO Len( vPANFiles )
      FOR p := 1 TO Len( vPRGFiles )
         IF AScan( vSinLoadWindow, { |y| US_Upper( y ) == US_Upper( vPRGFiles[ p ] ) } ) == 0                // a nivel programa
            IF AScan( vScanned, { |y| US_Upper( y ) == US_Upper( vPRGFiles[ p ] ) } ) == 0                   // a nivel funcion
               IF US_FileDateTime( vPANFiles[ f ] ) > US_FileDateTime( Fol + GetObjName() + DEF_SLASH + US_FileNameOnlyName( vPRGFiles[ p ] ) + '.c' )
// TODO: ELIMINAR COMPARACION POR =
                  // el primer AScan hace una comparacion parcial ( = ) y se le añade un blanco al final para que solo encuentre palabras completas
                  // el segundo AScan hace una comparacion total ( == ) del string (son dos palabras)
                  // El vector contiene 'myPRG myFmg'
                  IF ( AScan( vXRefPrgFmg, { |x| US_Upper( x ) = US_Upper( US_FileNameOnlyNameAndExt( vPRGFiles[ p ] ) ) + ' ' } ) == 0 .OR. ;
                     AScan( vXRefPrgFmg, { |x| US_Upper( x ) == US_Upper( US_FileNameOnlyNameAndExt( vPRGFiles[ p ] ) ) + ' ' + US_Upper( US_FileNameOnlyNameAndExt( vPanFiles[ f ] ) ) } ) > 0 )
                     IF ! ( FMG_Scan( vPRGFiles[ p ], US_FileDateTime( Fol + GetObjName() + DEF_SLASH + US_FileNameOnlyName( vPRGFiles[ p ] ) + '.c' ), vScanned, vPanFiles ) )
                        AAdd( vSinLoadWindow, US_Upper( vPRGFiles[ p ] ) ) // Para Control de Programa desde segunda pasada hasta que se vuele a ingresar
                        QPM_LogText( 'FUNC_xRefPrgFmg: file "' + vPRGFiles[ p ] + '" added to vSinLoadWindow' )
                     ENDIF
                  ENDIF
               ENDIF
            ENDIF
         ENDIF
      NEXT
   NEXT
   QPM_LogText( 'FUNC_xRefPrgFmg end' + CRLF + CRLF )
RETURN .T.

FUNCTION FMG_Scan( cFileIn, DateTimeOfC, vScanned, vPanFiles )
   LOCAL hFiIn, i, cLinea:='', vFines := { Chr(13) + Chr(10), Chr(10) }, bLoadWindow := .F.
   LOCAL vAux := {}
   LOCAL cFilePrgAux := US_Upper( US_FileNameOnlyNameAndExt( cFileIn ) )
   QPM_LogText( 'FMG_Scan file "' + cFileIn + '"' + CRLF )
   QPM_MemoWrit( PROGRESS_LOG, MemoRead( PROGRESS_LOG ) + US_TimeDis( Time() ) + ' - ' + 'Scanning: ' + cFileIn + CRLF )
   /* limpio las ocurrencias del prg */
   FOR i := 1 TO Len( vXRefPrgFmg )
      IF ! ( US_Word( vXRefPrgFmg[i], 1 ) == cFilePrgAux )
         AAdd( vAux, vXRefPrgFmg[i] )
      ENDIF
   NEXT
   vXRefPrgFmg := {}
   FOR i := 1 TO Len( vAux )
      AAdd( vXRefPrgFmg, vAux[i] )
   NEXT
   /* fin limpio las ocurrencias del prg */
   AAdd( vScanned, cFileIn )     // Para Control de Funcion llamadora xRefPrgFmg()
   hFiIn := FOpen( cFileIn )
   IF FError() == 0
      DO WHILE hb_FReadLine( hFiIn, @cLinea, vFines ) == 0
         cLinea := AllTrim( strtran( cLinea, Chr(09), ' ' ) )
         IF SubStr( cLinea, 1, 1 ) == '*'   .OR. ;
            SubStr( cLinea, 1, 2 ) == '//'  .OR. ;
            SubStr( cLinea, 1, 2 ) == '##'  .OR. ;
            SubStr( cLinea, 1, 2 ) == '&&'  .OR. ;
            US_Words( cLinea ) < 3
         ELSE
            IF US_Words( cLinea ) > 2 .AND. ;
               US_Upper( US_Word( cLinea, 1 ) ) == 'LOAD' .AND. ;
               US_Upper( US_Word( cLinea, 2 ) ) == 'WINDOW'
               bLoadWindow := .T.
               AAdd( vXRefPrgFmg, cFilePrgAux + ' ' + US_Upper( US_Word( cLinea, 3 ) + '.FMG' ) )
               IF AScan( vPanFiles, { |x| US_Upper( US_FileNameOnlyNameAndExt( x ) ) == US_Upper( US_Word( cLinea, 3 ) + '.FMG' ) } ) > 0 .AND. ;
                  DateTimeOfC < US_FileDateTime( vPanFiles[ AScan( vPanFiles, { |x| US_Upper( US_FileNameOnlyNameAndExt( x ) ) == US_Upper( US_Word( cLinea, 3 ) + '.FMG' ) } ) ] )
                  QPM_LogText( '"' + US_Word( cLinea, 3 ) + '.FMG" triggers forced compilation of "' + cFileIn + '"' )
                  QPM_MemoWrit( PROGRESS_LOG, MemoRead( PROGRESS_LOG ) + US_TimeDis( Time() ) + ' - "' + US_Word( cLinea, 3 ) + '.FMG" triggers forced compilation of ' + cFileIn + CRLF )
                  FErase( GetObjFolder() + DEF_SLASH + US_FileNameOnlyName( cFileIn ) + '.C' )
                  QPM_LogText( GetObjFolder() + DEF_SLASH + US_FileNameOnlyName( cFileIn ) + '.c was erased' )
                  EXIT
               ENDIF
            ENDIF
         ENDIF
      ENDDO
      FClose( hFiIn )
   ELSE
      RETURN bLoadWindow
   ENDIF
   QPM_LogText( 'FMG_Scan end' + CRLF )
RETURN bLoadWindow

FUNCTION FUNC_xRefPrgHea( vConcatIncludeC )
   LOCAL i, f, p, Fol := PUB_cProjectFolder + DEF_SLASH
   LOCAL vScanned := {}, vPRGFiles := {}, vHEAFiles := {}
   QPM_LogText( "FUNC_xRefPrgHea start" )
   QPM_MemoWrit( PROGRESS_LOG, US_TimeDis( Time() ) + ' - Checking cross references between PRG files and Header files ...' + CRLF )
   FOR f := 1 TO VentanaMain.GHeaFiles.itemcount
      AAdd( vHEAFiles, ChgPathToReal( GetProperty( 'VentanaMain', 'GHeaFiles', 'Cell', f, NCOLHEAFULLNAME ) ) )
   NEXT f
   FOR f := 1 TO Len( vHeaFiles )
      FOR i := 1 TO Len( vConcatIncludeC )
         IF File( vConcatIncludeC[i]+DEF_SLASH+US_FileNameOnlyNameAndExt( vHeaFiles[f] ) )
            IF ! ( US_Upper( US_ShortName( vConcatIncludeC[i]+DEF_SLASH+US_FileNameOnlyNameAndExt( vHeaFiles[f] ) ) ) == US_Upper( US_ShortName(vHeaFiles[f]) ) )
               QPM_LogText( "Warning on " + US_FileNameOnlyNameAndExt( vHeaFiles[f] ) )
               MyMsgWarn( 'Folder ' + vConcatIncludeC[i] + ' contains a header named ' + US_FileNameOnlyNameAndExt( vHeaFiles[f] ) + "." + CRLF + ;
                          "If the #include is coded with characters '<' and '>', the search processes of Harbour and C compilers will locate it first and will therefore ignore the header located at folder " + ;
                          DBLQT + US_FileNameOnlyPath( vHeaFiles[f] ) + DBLQT + '.' )
            ELSE
               EXIT
            ENDIF
         ENDIF
      NEXT i
   NEXT f
   FOR f := 1 TO VentanaMain.GPrgFiles.itemcount
      AAdd( vPRGFiles, ChgPathToReal( GetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', f, NCOLPRGFULLNAME ) ) )
   NEXT f
   /* Nota: Lo referido a vSinInclude y vXRefPrgHea puede ser eliminado, si eso ocurre, provocamos que en cada BUILD se */
   /*       scaneen los PRG que no tienen #include, enlenteciendo el proceso                                            */
   /*       Si se usa -BUILD como parametro no tiene ninguna implicancia ya que actúa despues de la primera pasada      */
   FOR f := 1 TO Len( vHEAFiles )
      FOR p := 1 TO Len( vPRGFiles )
         IF AScan( vScanned, { |y| US_Upper( US_VarToStr( y ) ) == US_Upper( vPRGFiles[ p ] ) } ) == 0                      // a nivel funcion
         // IF US_FileDateTime( vHeaFiles[ f ] ) > US_FileDateTime( Fol + GetObjName() + DEF_SLASH + US_FileNameOnlyName( vPRGFiles[ p ] ) + '.c' )
         // IF US_FileDateTime( vHeaFiles[ f ] ) > US_FileDateTime( Fol + GetObjName() + DEF_SLASH + US_FileNameOnlyName( vPRGFiles[ p ] ) + iif( Upper( US_FileNameOnlyExt( vPRGFiles[ p ] ) ) == 'CPP', '.cpp', '.c' ) )
            IF US_FileDateTime( vHeaFiles[ f ] ) > US_FileDateTime( Fol + GetObjName() + DEF_SLASH + US_FileNameOnlyName( vPRGFiles[ p ] ) + iif( Upper( US_FileNameOnlyExt( vPRGFiles[ p ] ) ) == 'PRG', '.c', '.'+GetObjExt() ) )
               IF AScan( vSinInclude, { |y| US_Upper( US_VarToStr( y ) ) == US_Upper( vPRGFiles[ p ] ) } ) == 0                // a nivel programa
// TODO: ELIMINAR COMPARACION POR =
                  // el primer AScan hace una comparacion parcial ( = ) y se le añade un blanco al final para que solo encuentre palabras completas
                  // el segundo AScan hace una comparacion total ( == ) del string (son dos palabras)
                  // El vector contiene 'myPRG myHeader.h'
                  IF ( AScan( vXRefPrgHea, { |x| US_Upper( US_VarToStr( x ) ) = US_Upper( US_FileNameOnlyNameAndExt( vPRGFiles[ p ] ) ) + ' ' } ) == 0 .OR. ;
                     AScan( vXRefPrgHea, { |x| US_Upper( US_VarToStr( x ) ) == US_Upper( US_FileNameOnlyNameAndExt( vPRGFiles[ p ] ) ) + ' ' + US_Upper( US_FileNameOnlyNameAndExt( vHeaFiles[ f ] ) ) } ) > 0 )
                     IF ! ( HEA_Scan( vPRGFiles[ p ], US_FileDateTime( Fol + GetObjName() + DEF_SLASH + US_FileNameOnlyName( vPRGFiles[ p ] ) + iif( Upper( US_FileNameOnlyExt( vPRGFiles[ p ] ) ) == 'PRG', '.c', '.'+GetObjExt() ) ), vScanned, vHeaFiles ) )
                        AAdd( vSinInclude, US_Upper( vPRGFiles[ p ] ) ) // Para Control de Programa desde segunda pasada hasta que se vuele a ingresar
                        QPM_LogText( 'FUNC_xRefPrgHea: file "' + vPRGFiles[ p ] + '" added to vSinInclude' )
                     ENDIF
                  ENDIF
               ENDIF
            ENDIF
         ENDIF
      NEXT
   NEXT
   QPM_LogText( 'FUNC_xRefPrgHea end' )
RETURN .T.

FUNCTION HEA_Scan( cFileIn, DateTimeOfC, vScanned, vHeaFiles )
   LOCAL hFiIn, cLinea:='', vFines := { Chr(13) + Chr(10), Chr(10) }, bIncludeFound := .F., cName := '', i
   LOCAL maxDateHeader := '00000000000000', incChars := { { '"', '"' }, { "'", "'" }, { '<', '>' } }
   LOCAL vAux := {}
   LOCAL cFilePrgAux := US_Upper( US_FileNameOnlyNameAndExt( cFileIn ) )
   LOCAL vPreventLoop := {}
   QPM_LogText( 'HEA_Scan file "' + cFileIn + '"' + CRLF )
   QPM_MemoWrit( PROGRESS_LOG, MemoRead( PROGRESS_LOG ) + US_TimeDis( Time() ) + ' - ' + 'Scanning: ' + cFileIn + CRLF )
   AAdd( vScanned, cFileIn )     // Para Control de funcion llamadora FUNC_xRefPrgHea()
   hFiIn := FOpen( cFileIn )
   IF FError() == 0
      DO WHILE hb_FReadLine( hFiIn, @cLinea, vFines ) == 0
         cLinea := AllTrim( strtran( cLinea, Chr(09), ' ' ) )
         IF US_Words( cLinea ) > 1 .AND. ;
            US_Upper( US_Word( cLinea, 1 ) ) == '#INCLUDE'
            cName := ''
            FOR i := 1 TO Len( incChars )
               IF SubStr( US_Word( cLinea, 2 ), 1, 1 ) == incChars[i][1]
                  cName := SubStr( US_WordSubStr( cLinea, 2 ), 2, RAt( incChars[i][2], US_WordSubStr( cLinea, 2 ) ) - 2 )
               ENDIF
            NEXT
            IF AScan( vHeaFiles, { |x| US_Upper( US_FileNameOnlyNameAndExt( x ) ) == US_Upper( cName ) } ) > 0 .AND. ;
               File( vHeaFiles[ AScan( vHeaFiles, { |x| US_Upper( US_FileNameOnlyNameAndExt( x ) ) == US_Upper( cName ) } ) ] )
               bIncludeFound := .T.
               IF AScan( vPreventLoop, US_Upper( cName ) ) == 0
                  AAdd( vPreventLoop, US_Upper( cName ) )
                  /* limpio las ocurrencias del prg */
                  FOR i := 1 TO Len( vXRefPrgHea )
                     IF ! ( US_Word( vXRefPrgHea[i], 1 ) == cFilePrgAux )
                        AAdd( vAux, vXRefPrgHea[i] )
                     ENDIF
                  NEXT
                  vXRefPrgHea := {}
                  FOR i := 1 TO Len( vAux )
                     AAdd( vXRefPrgHea, vAux[i] )
                  NEXT
                  /* fin limpio las ocurrencias del prg */
                  AAdd( vXRefPrgHea, cFilePrgAux + ' ' + US_Upper( cName ) )
                  maxDateHeader := ScanIncRecursive( vHeaFiles[ AScan( vHeaFiles, { |x| US_Upper( US_FileNameOnlyNameAndExt( x ) ) == US_Upper( cName ) } ) ], cFilePrgAux, vPreventLoop, vHeaFiles )
               ENDIF
            ENDIF
            IF DateTimeOfC < maxDateHeader
               QPM_LogText( '"' + US_Word( cLinea, 3 ) + '.FMG" triggers forced compilation of "' + cFileIn + '"' )
               QPM_MemoWrit( PROGRESS_LOG, MemoRead( PROGRESS_LOG ) + US_TimeDis( Time() ) + ' - "' + cName + '" or a nested #include triggers forced compilation of ' + cFileIn + CRLF )
               FErase( GetObjFolder() + DEF_SLASH + US_FileNameOnlyName( cFileIn ) + iif( Upper( US_FileNameOnlyExt( cFileIn ) ) == 'PRG', '.c', '.' + GetObjExt() ) )
               QPM_LogText( GetObjFolder() + DEF_SLASH + US_FileNameOnlyName( cFileIn ) + iif( Upper( US_FileNameOnlyExt( cFileIn ) ) == 'PRG', '.c', '.' + GetObjExt() ) + ' was erased' )
               EXIT
            ENDIF
         ENDIF
      ENDDO
      FClose( hFiIn )
   ELSE
      RETURN bIncludeFound
   ENDIF
   QPM_LogText( 'HEA_Scan end' + CRLF )
RETURN bIncludeFound

FUNCTION ScanIncRecursive( cFileIn, cFilePrgAux, vPreventLoop, vHeaFiles )
   LOCAL cName, i, hFiIn, cLinea:='', vFines := { Chr(13) + Chr(10), Chr(10) }
   LOCAL maxDateHeader  := US_FileDateTime( cFileIn ), incChars := { { '"', '"' }, { "'", "'" }, { '<', '>' } }
   LOCAL callDateHeader
   hFiIn := FOpen( cFileIn )
   IF FError() == 0
      DO WHILE hb_FReadLine( hFiIn, @cLinea, vFines ) == 0
         cLinea := AllTrim( strtran( cLinea, Chr(09), ' ' ) )
         IF US_Words( cLinea ) > 1 .AND. ;
            US_Upper( US_Word( cLinea, 1 ) ) == '#INCLUDE'
            cName := ''
            FOR i := 1 TO Len( incChars )
               IF SubStr( US_Word( cLinea, 2 ), 1, 1 ) == incChars[i][1]
                  cName := SubStr( US_WordSubStr( cLinea, 2 ), 2, RAt( incChars[i][2], US_WordSubStr( cLinea, 2 ) ) - 2 )
               ENDIF
            NEXT
            IF AScan( vHeaFiles, { |x| US_Upper( US_FileNameOnlyNameAndExt( x ) ) == US_Upper( cName ) } ) > 0 .AND. ;
               File( vHeaFiles[ AScan( vHeaFiles, { |x| US_Upper( US_FileNameOnlyNameAndExt( x ) ) == US_Upper( cName ) } ) ] )
               IF AScan( vPreventLoop, US_Upper( cName ) ) == 0
                  AAdd( vPreventLoop, US_Upper( cName ) )
                  AAdd( vXRefPrgHea, cFilePrgAux + ' ' + US_Upper( cName ) )
                  IF maxDateHeader < ( callDateHeader := ScanIncRecursive( vHeaFiles[ AScan( vHeaFiles, { |x| US_Upper( US_FileNameOnlyNameAndExt( x ) ) == US_Upper( cName ) } ) ], cFilePrgAux, vPreventLoop, vHeaFiles ) )
                     maxDateHeader := callDateHeader
                  ENDIF
               ENDIF
            ENDIF
         ENDIF
      ENDDO
      FClose( hFiIn )
   ELSE
      RETURN maxDateHeader
   ENDIF
RETURN maxDateHeader

FUNCTION CheckMakeForm( cForm )
   LOCAL hFiIn, cLinea:='', vFines := { Chr(13) + Chr(10), Chr(10) }, reto := 'UNKNOWN'
   hFiIn := FOpen( cForm )
   IF FError() == 0
      DO WHILE hb_FReadLine( hFiIn, @cLinea, vFines ) == 0
         cLinea := AllTrim( strtran( cLinea, Chr(09), ' ' ) )
         DO CASE
            CASE US_Upper( US_Word( cLinea, 1 ) ) == '*HMGS-MINIGUI-IDE'
               reto := 'HMGSIDE (by Walter Formigoni)'
               EXIT
            CASE At( '* HARBOUR MINIGUI IDE HMI+', US_Upper( cLinea ) ) > 0
               reto := 'HMI (by Ciro Vargas Clemow)'
               EXIT
            CASE At( "* GENERATED BY OOHG IDE PLUS", US_Upper( cLinea ) ) > 0
               reto := 'OOHG IDE+ (by OOHG development team)'
               EXIT
            CASE At( '* OOHG IDE PLUS', US_Upper( cLinea ) ) > 0
               reto := 'OOHG IDE+ (by OOHG development team)'
               EXIT
            CASE At( '* OOHG IDE', US_Upper( cLinea ) ) > 0
               reto := 'HMI (by Ciro Vargas Clemow)'
               EXIT
            CASE At( '* HARBOUR MINIGUI IDE TWO-WAY', US_Upper( cLinea ) ) > 0
               reto := 'IDE (by Roberto Lopez)'
               EXIT
         ENDCASE
      ENDDO
      FClose( hFiIn )
   ENDIF
   QPM_LogText( "CheckMakeForm = " + reto )
RETURN reto

FUNCTION QPM_SetColor()
   IF PUB_bLite
      DO CASE
      CASE Prj_Radio_OutputType == DEF_RG_EXE
         SetProperty( 'VentanaLite', 'RichEditSysout', 'backcolor', DEF_COLOREXE )
      CASE Prj_Radio_OutputType == DEF_RG_LIB
         SetProperty( 'VentanaLite', 'RichEditSysout', 'backcolor', DEF_COLORLIB )
      CASE Prj_Radio_OutputType == DEF_RG_IMPORT
         SetProperty( 'VentanaLite', 'RichEditSysout', 'backcolor', DEF_COLORDLL )
      ENDCASE
   ELSE
      DO CASE
      CASE Prj_Radio_OutputType == DEF_RG_EXE
         SetProperty( 'VentanaMain', 'RichEditSysout', 'backcolor', DEF_COLOREXE )
      CASE Prj_Radio_OutputType == DEF_RG_LIB
         SetProperty( 'VentanaMain', 'RichEditSysout', 'backcolor', DEF_COLORLIB )
      CASE Prj_Radio_OutputType == DEF_RG_IMPORT
         SetProperty( 'VentanaMain', 'RichEditSysout', 'backcolor', DEF_COLORDLL )
      ENDCASE
   ENDIF
RETURN .T.

FUNCTION ToggleDefMode()
   LOCAL nRow, cValue, aNoGo := { GetGTGUIName(), GetGTWINName(), "C0X32.OBJ", "C0W32.OBJ", US_Upper( GetMiniguiName() ) }
   nRow := VentanaMain.GDefFiles.Value
   IF AScan( aNoGo, US_Upper( GetProperty( 'VentanaMain', 'GDefFiles', 'Cell', nRow, NCOLDEFNAME ) ) ) # 0
      MyMsgStop( "It's not allowed to change the " + DBLQT + "Mode" + DBLQT + " attribute of this file!" )
      RETURN .F.
   ENDIF
   cValue := GetProperty( 'VentanaMain', 'GDefFiles', 'Cell', nRow, NCOLDEFMODE )
   IF cValue == "C"       // Console
      cValue := "G"
   ELSEIF cValue == "G"   // GUI
      cValue := "B"
   ELSE                   // Both
      cValue := "C"
   ENDIF
   SetProperty( 'VentanaMain', 'GDefFiles', 'Cell', nRow, NCOLDEFMODE, cValue )
RETURN .T.

FUNCTION ToggleDefThreads()
   LOCAL nRow, cValue
   LOCAL aNoGo := { "CW32.LIB", "CW32MT.LIB", "VM.LIB", "LIBVM.A", "HBVM.LIB", "LIBHBVM.A", "VM64.LIB", "VMMT.LIB", "HBVMMT.LIB", ;
                    "LIBVMMT.A", "LIBHBVMMT.A", "VMMT64.LIB", 'CRTMT.LIB', 'CRT.LIB', 'CRTMT64.LIB', 'CRT64.LIB' }
   nRow := VentanaMain.GDefFiles.Value
   IF AScan( aNoGo, US_Upper( GetProperty( 'VentanaMain', 'GDefFiles', 'Cell', nRow, NCOLDEFNAME ) ) ) # 0
      MyMsgStop( "It's not allowed to change the " + DBLQT + "Threads" + DBLQT + " attribute of this file!" )
      RETURN .F.
   ENDIF
   cValue := GetProperty( 'VentanaMain', 'GDefFiles', 'Cell', nRow, NCOLDEFTHREADS )
   IF cValue == "M"   // Multiple threads
      cValue := "S"
   ELSEIF cValue == "S"   // Single thread
      cValue := "B"
   ELSE   // Both
      cValue := "M"
   ENDIF
   SetProperty( 'VentanaMain', 'GDefFiles', 'Cell', nRow, NCOLDEFTHREADS, cValue )
RETURN .T.

FUNCTION ToggleDefDebug()
   LOCAL nRow, cValue, aNoGo := { "DEBUG.LIB", "HBDEBUG.LIB", "LIBDEBUG.A", "LIBHBDEBUG.A", "DEBUGGER.LIB", "LIBDEBUGGER.A", "HBDEBUGGER.LIB", "LIBHBDEBUGGER.A" }
   nRow := VentanaMain.GDefFiles.Value
   IF AScan( aNoGo, US_Upper( GetProperty( 'VentanaMain', 'GDefFiles', 'Cell', nRow, NCOLDEFNAME ) ) ) # 0
      MyMsgStop( "It's not allowed to change the " + DBLQT + "Debug" + DBLQT + " attribute of this file!" )
      RETURN .F.
   ENDIF
   cValue := GetProperty( 'VentanaMain', 'GDefFiles', 'Cell', nRow, NCOLDEFDEBUG )
   IF cValue == "Y"   // Debug only mode
      cValue := "N"
   ELSEIF cValue == "N"   // Non-debug mode
      cValue := "B"
   ELSE   // Both modes
      cValue := "Y"
   ENDIF
   SetProperty( 'VentanaMain', 'GDefFiles', 'Cell', nRow, NCOLDEFDEBUG, cValue )
RETURN .T.

FUNCTION SortPRG( cVentana, cGrid, nColumna )
   LOCAL i, vAux := {}, cAux := GetProperty( cVentana, cGrid, 'item', 1 )
   LOCAL nActual := GetProperty( cVentana, cGrid, 'cell', GetProperty( cVentana, cGrid, 'value' ), nColumna )
   bPrgSorting := .T.
   IF VentanaMain.GPrgFiles.ItemCount > 1
      DoMethod( cVentana, cGrid, 'DisableUpdate' )
      FOR i := 2 TO GetProperty( cVentana, cGrid, 'itemcount' )
         AAdd( vAux, GetProperty( cVentana, cGrid, 'item', i ) )
      NEXT
      DoMethod( cVentana, cGrid, 'deleteallitems' )
      DoMethod( cVentana, cGrid, 'additem', cAux )
      IF bSortPrgAsc
         ASort( vAux,,, { |x, y| US_Upper(x[nColumna]) < US_Upper(y[nColumna]) })
      ELSE
         ASort( vAux,,, { |x, y| US_Upper(x[nColumna]) > US_Upper(y[nColumna]) })
      ENDIF
      bSortPrgAsc := !bSortPrgAsc
      FOR i := 1 TO Len( vAux )
         DoMethod( cVentana, cGrid, 'additem', vAux[ i ] )
      NEXT
      SetProperty( cVentana, cGrid, 'value', AScan( vAux, {|x| x[ nColumna ] == nActual } ) + 1 )
      DoMethod( cVentana, cGrid, 'setfocus' )
      DoMethod( cVentana, cGrid, 'EnableUpdate' )
   ENDIF
   bPrgSorting := .F.
RETURN .T.

FUNCTION SortHEA( cVentana, cGrid, nColumna )
   LOCAL i, vAux := {}
   LOCAL nActual := GetProperty( cVentana, cGrid, 'cell', GetProperty( cVentana, cGrid, 'value' ), nColumna )
   bHeaSorting := .T.
   DoMethod( cVentana, cGrid, 'DisableUpdate' )
   FOR i := 1 TO GetProperty( cVentana, cGrid, 'itemcount' )
      AAdd( vAux, GetProperty( cVentana, cGrid, 'item', i ) )
   NEXT
   DoMethod( cVentana, cGrid, 'deleteallitems' )
   IF bSortHeaAsc
      ASort( vAux,,, { |x, y| US_Upper(x[nColumna]) < US_Upper(y[nColumna]) })
   ELSE
      ASort( vAux,,, { |x, y| US_Upper(x[nColumna]) > US_Upper(y[nColumna]) })
   ENDIF
   bSortHeaAsc := !bSortHeaAsc
   FOR i := 1 TO Len( vAux )
      DoMethod( cVentana, cGrid, 'additem', vAux[ i ] )
   NEXT
   SetProperty( cVentana, cGrid, 'value', AScan( vAux, {|x| x[ nColumna ] == nActual } ) )
   DoMethod( cVentana, cGrid, 'setfocus' )
   DoMethod( cVentana, cGrid, 'EnableUpdate' )
   bHeaSorting := .F.
RETURN .T.

FUNCTION SortPAN( cVentana, cGrid, nColumna )
   LOCAL i, vAux := {}
   LOCAL nActual := GetProperty( cVentana, cGrid, 'cell', GetProperty( cVentana, cGrid, 'value' ), nColumna )
   bPanSorting := .T.
   DoMethod( cVentana, cGrid, 'DisableUpdate' )
   FOR i := 1 TO GetProperty( cVentana, cGrid, 'itemcount' )
      AAdd( vAux, GetProperty( cVentana, cGrid, 'item', i ) )
   NEXT
   DoMethod( cVentana, cGrid, 'deleteallitems' )
   IF bSortPanAsc
      ASort( vAux,,, { |x, y| US_Upper(x[nColumna]) < US_Upper(y[nColumna]) })
   ELSE
      ASort( vAux,,, { |x, y| US_Upper(x[nColumna]) > US_Upper(y[nColumna]) })
   ENDIF
   bSortPanAsc := !bSortPanAsc
   FOR i := 1 TO Len( vAux )
      DoMethod( cVentana, cGrid, 'additem', vAux[ i ] )
   NEXT
   SetProperty( cVentana, cGrid, 'value', AScan( vAux, {|x| x[ nColumna ] == nActual } ) )
   DoMethod( cVentana, cGrid, 'setfocus' )
   DoMethod( cVentana, cGrid, 'EnableUpdate' )
   bPanSorting := .F.
RETURN .T.

FUNCTION SortDBF( cVentana, cGrid, nColumna )
   LOCAL i, vAux := {}
   LOCAL nActual := GetProperty( cVentana, cGrid, 'cell', GetProperty( cVentana, cGrid, 'value' ), nColumna )
   bDbfSorting := .T.
   DoMethod( cVentana, cGrid, 'DisableUpdate' )
   FOR i := 1 TO GetProperty( cVentana, cGrid, 'itemcount' )
      AAdd( vAux, GetProperty( cVentana, cGrid, 'item', i ) )
   NEXT
   DoMethod( cVentana, cGrid, 'deleteallitems' )
   IF bSortDbfAsc
      ASort( vAux,,, { |x, y| US_Upper(x[nColumna]) < US_Upper(y[nColumna]) })
   ELSE
      ASort( vAux,,, { |x, y| US_Upper(x[nColumna]) > US_Upper(y[nColumna]) })
   ENDIF
   bSortDbfAsc := !bSortDbfAsc
   FOR i := 1 TO Len( vAux )
      DoMethod( cVentana, cGrid, 'additem', vAux[ i ] )
   NEXT
   SetProperty( cVentana, cGrid, 'value', AScan( vAux, {|x| x[ nColumna ] == nActual } ) )
   DoMethod( cVentana, cGrid, 'setfocus' )
   DoMethod( cVentana, cGrid, 'EnableUpdate' )
   bDbfSorting := .F.
RETURN .T.

FUNCTION SortExc( cVentana, cGrid, nColumna )
   LOCAL i, vAux := {}
   LOCAL nActual := GetProperty( cVentana, cGrid, 'cell', GetProperty( cVentana, cGrid, 'value' ), nColumna )
   bExcSorting := .T.
   DoMethod( cVentana, cGrid, 'DisableUpdate' )
   FOR i := 1 TO GetProperty( cVentana, cGrid, 'itemcount' )
      AAdd( vAux, GetProperty( cVentana, cGrid, 'item', i ) )
   NEXT
   DoMethod( cVentana, cGrid, 'deleteallitems' )
   IF bSortExcAsc
      ASort( vAux,,, { |x, y| US_Upper(x[nColumna]) < US_Upper(y[nColumna]) })
   ELSE
      ASort( vAux,,, { |x, y| US_Upper(x[nColumna]) > US_Upper(y[nColumna]) })
   ENDIF
   bSortExcAsc := !bSortExcAsc
   FOR i := 1 TO Len( vAux )
      DoMethod( cVentana, cGrid, 'additem', vAux[ i ] )
   NEXT
   SetProperty( cVentana, cGrid, 'value', AScan( vAux, {|x| x[ nColumna ] == nActual } ) )
   DoMethod( cVentana, cGrid, 'setfocus' )
   DoMethod( cVentana, cGrid, 'EnableUpdate' )
   bExcSorting := .F.
RETURN .T.

FUNCTION UpPrg()
   LOCAL i := GetProperty( 'VentanaMain', 'GPrgFiles', 'value' )
   LOCAL cAux := GetProperty( 'VentanaMain', 'GPrgFiles', 'item', i )
   LOCAL cAux2 := GetProperty( 'VentanaMain', 'GPrgFiles', 'item', i - 1 )
   IF i == 2
      MyMsgStop( 'Use the "SetTop" button to set this file as "Top File".' )
   ENDIF
   IF i > 2
      SetProperty( 'VentanaMain', 'GPrgFiles', 'item', i, cAux2 )
      SetProperty( 'VentanaMain', 'GPrgFiles', 'item', i - 1, cAux )
      SetProperty( 'VentanaMain', 'GPrgFiles', 'value', i - 1 )
      DoMethod( 'VentanaMain', 'GPrgFiles', 'setfocus' )
   ENDIF
RETURN .T.

FUNCTION DownPrg()
   LOCAL i := GetProperty( 'VentanaMain', 'GPrgFiles', 'value' )
   LOCAL cAux := GetProperty( 'VentanaMain', 'GPrgFiles', 'item', i )
   LOCAL cAux2 := GetProperty( 'VentanaMain', 'GPrgFiles', 'item', i + 1 )
   IF i == 1
      MyMsgStop( "The " + DBLQT + "Top File" + DBLQT + " can't be moved!" + CRLF + ;
                 'Use the "SetTop" button to set another file as the new "Top File".' )
   ENDIF
   IF i < GetProperty( 'VentanaMain', 'GPrgFiles', 'itemcount' ) .AND. i > 1
      SetProperty( 'VentanaMain', 'GPrgFiles', 'item', i, cAux2 )
      SetProperty( 'VentanaMain', 'GPrgFiles', 'item', i + 1, cAux )
      SetProperty( 'VentanaMain', 'GPrgFiles', 'value', i + 1 )
      DoMethod( 'VentanaMain', 'GPrgFiles', 'setfocus' )
   ENDIF
RETURN .T.

FUNCTION UpPan()
   LOCAL i := GetProperty( 'VentanaMain', 'GPanFiles', 'value' )
   LOCAL cAux := GetProperty( 'VentanaMain', 'GPanFiles', 'item', i )
   LOCAL cAux2 := GetProperty( 'VentanaMain', 'GPanFiles', 'item', i - 1 )
   IF i > 1
      SetProperty( 'VentanaMain', 'GPanFiles', 'item', i, cAux2 )
      SetProperty( 'VentanaMain', 'GPanFiles', 'item', i - 1, cAux )
      SetProperty( 'VentanaMain', 'GPanFiles', 'value', i - 1 )
      DoMethod( 'VentanaMain', 'GPanFiles', 'setfocus' )
   ENDIF
RETURN .T.

FUNCTION DownPan()
   LOCAL i := GetProperty( 'VentanaMain', 'GPanFiles', 'value' )
   LOCAL cAux := GetProperty( 'VentanaMain', 'GPanFiles', 'item', i )
   LOCAL cAux2 := GetProperty( 'VentanaMain', 'GPanFiles', 'item', i + 1 )
   IF i > 0 .AND. i < GetProperty( 'VentanaMain', 'GPanFiles', 'itemcount' )
      SetProperty( 'VentanaMain', 'GPanFiles', 'item', i, cAux2 )
      SetProperty( 'VentanaMain', 'GPanFiles', 'item', i + 1, cAux )
      SetProperty( 'VentanaMain', 'GPanFiles', 'value', i + 1 )
      DoMethod( 'VentanaMain', 'GPanFiles', 'setfocus' )
   ENDIF
RETURN .T.

FUNCTION UpDbf()
   LOCAL i := GetProperty( 'VentanaMain', 'GDbfFiles', 'value' )
   LOCAL cAux := GetProperty( 'VentanaMain', 'GDbfFiles', 'item', i )
   LOCAL cAux2 := GetProperty( 'VentanaMain', 'GDbfFiles', 'item', i - 1 )
   IF i > 1
      SetProperty( 'VentanaMain', 'GDbfFiles', 'item', i, cAux2 )
      SetProperty( 'VentanaMain', 'GDbfFiles', 'item', i - 1, cAux )
      SetProperty( 'VentanaMain', 'GDbfFiles', 'value', i - 1 )
      DoMethod( 'VentanaMain', 'GDbfFiles', 'setfocus' )
   ENDIF
RETURN .T.

FUNCTION DownDbf()
   LOCAL i := GetProperty( 'VentanaMain', 'GDbfFiles', 'value' )
   LOCAL cAux := GetProperty( 'VentanaMain', 'GDbfFiles', 'item', i )
   LOCAL cAux2 := GetProperty( 'VentanaMain', 'GDbfFiles', 'item', i + 1 )
   IF i > 0 .AND. i < GetProperty( 'VentanaMain', 'GDbfFiles', 'itemcount' )
      SetProperty( 'VentanaMain', 'GDbfFiles', 'item', i, cAux2 )
      SetProperty( 'VentanaMain', 'GDbfFiles', 'item', i + 1, cAux )
      SetProperty( 'VentanaMain', 'GDbfFiles', 'value', i + 1 )
      DoMethod( 'VentanaMain', 'GDbfFiles', 'setfocus' )
   ENDIF
RETURN .T.

FUNCTION UpHea()
   LOCAL i := GetProperty( 'VentanaMain', 'GHeaFiles', 'value' )
   LOCAL cAux := GetProperty( 'VentanaMain', 'GHeaFiles', 'item', i )
   LOCAL cAux2 := GetProperty( 'VentanaMain', 'GHeaFiles', 'item', i - 1 )
   IF i > 1
      SetProperty( 'VentanaMain', 'GHeaFiles', 'item', i, cAux2 )
      SetProperty( 'VentanaMain', 'GHeaFiles', 'item', i - 1, cAux )
      SetProperty( 'VentanaMain', 'GHeaFiles', 'value', i - 1 )
      DoMethod( 'VentanaMain', 'GHeaFiles', 'setfocus' )
   ENDIF
RETURN .T.

FUNCTION DownHea()
   LOCAL i := GetProperty( 'VentanaMain', 'GHeaFiles', 'value' )
   LOCAL cAux := GetProperty( 'VentanaMain', 'GHeaFiles', 'item', i )
   LOCAL cAux2 := GetProperty( 'VentanaMain', 'GHeaFiles', 'item', i + 1 )
   IF i > 0 .AND. i < GetProperty( 'VentanaMain', 'GHeaFiles', 'itemcount' )
      SetProperty( 'VentanaMain', 'GHeaFiles', 'item', i, cAux2 )
      SetProperty( 'VentanaMain', 'GHeaFiles', 'item', i + 1, cAux )
      SetProperty( 'VentanaMain', 'GHeaFiles', 'value', i + 1 )
      DoMethod( 'VentanaMain', 'GHeaFiles', 'setfocus' )
   ENDIF
RETURN .T.

FUNCTION UpLibDefault()
   LOCAL i := GetProperty( 'VentanaMain', 'GDefFiles', 'value' )
   LOCAL cAux := GetProperty( 'VentanaMain', 'GDefFiles', 'item', i )
   LOCAL cAux2 := GetProperty( 'VentanaMain', 'GDefFiles', 'item', i - 1 )
   IF i > 1
      SetProperty( 'VentanaMain', 'GDefFiles', 'item', i, cAux2 )
      SetProperty( 'VentanaMain', 'GDefFiles', 'item', i - 1, cAux )
      SetProperty( 'VentanaMain', 'GDefFiles', 'value', i - 1 )
      DoMethod( 'VentanaMain', 'GDefFiles', 'setfocus' )
   ENDIF
   CheckRelativeOrderOfLibsGT()
RETURN .T.

FUNCTION DownLibDefault()
   LOCAL i := GetProperty( 'VentanaMain', 'GDefFiles', 'value' )
   LOCAL cAux := GetProperty( 'VentanaMain', 'GDefFiles', 'item', i )
   LOCAL cAux2 := GetProperty( 'VentanaMain', 'GDefFiles', 'item', i + 1 )
   IF i > 0 .AND. i < GetProperty( 'VentanaMain', 'GDefFiles', 'itemcount' )
      SetProperty( 'VentanaMain', 'GDefFiles', 'item', i, cAux2 )
      SetProperty( 'VentanaMain', 'GDefFiles', 'item', i + 1, cAux )
      SetProperty( 'VentanaMain', 'GDefFiles', 'value', i + 1 )
      DoMethod( 'VentanaMain', 'GDefFiles', 'setfocus' )
   ENDIF
   CheckRelativeOrderOfLibsGT()
RETURN .T.

FUNCTION UpLibInclude()
   LOCAL i := GetProperty( 'VentanaMain', 'GIncFiles', 'value' )
   LOCAL cAux := GetProperty( 'VentanaMain', 'GIncFiles', 'item', i )
   LOCAL cAux2 := GetProperty( 'VentanaMain', 'GIncFiles', 'item', i - 1 )
   IF i > 1
      SetProperty( 'VentanaMain', 'GIncFiles', 'item', i, cAux2 )
      SetProperty( 'VentanaMain', 'GIncFiles', 'item', i - 1, cAux )
      SetProperty( 'VentanaMain', 'GIncFiles', 'value', i - 1 )
      DoMethod( 'VentanaMain', 'GIncFiles', 'setfocus' )
   ENDIF
RETURN .T.

FUNCTION DownLibInclude()
   LOCAL i := GetProperty( 'VentanaMain', 'GIncFiles', 'value' )
   LOCAL cAux := GetProperty( 'VentanaMain', 'GIncFiles', 'item', i )
   LOCAL cAux2 := GetProperty( 'VentanaMain', 'GIncFiles', 'item', i + 1 )
   IF i > 0 .AND. i < GetProperty( 'VentanaMain', 'GIncFiles', 'itemcount' )
      SetProperty( 'VentanaMain', 'GIncFiles', 'item', i, cAux2 )
      SetProperty( 'VentanaMain', 'GIncFiles', 'item', i + 1, cAux )
      SetProperty( 'VentanaMain', 'GIncFiles', 'value', i + 1 )
      DoMethod( 'VentanaMain', 'GIncFiles', 'setfocus' )
   ENDIF
RETURN .T.

FUNCTION UpLibExclude()
   LOCAL i := GetProperty( 'VentanaMain', 'GExcFiles', 'value' )
   LOCAL cAux := GetProperty( 'VentanaMain', 'GExcFiles', 'item', i )
   LOCAL cAux2 := GetProperty( 'VentanaMain', 'GExcFiles', 'item', i - 1 )
   IF i > 1
      SetProperty( 'VentanaMain', 'GExcFiles', 'item', i, cAux2 )
      SetProperty( 'VentanaMain', 'GExcFiles', 'item', i - 1, cAux )
      SetProperty( 'VentanaMain', 'GExcFiles', 'value', i - 1 )
      DoMethod( 'VentanaMain', 'GExcFiles', 'setfocus' )
   ENDIF
RETURN .T.

FUNCTION DownLibExclude()
   LOCAL i := GetProperty( 'VentanaMain', 'GExcFiles', 'value' )
   LOCAL cAux := GetProperty( 'VentanaMain', 'GExcFiles', 'item', i )
   LOCAL cAux2 := GetProperty( 'VentanaMain', 'GExcFiles', 'item', i + 1 )
   IF i > 0 .AND. i < GetProperty( 'VentanaMain', 'GExcFiles', 'itemcount' )
      SetProperty( 'VentanaMain', 'GExcFiles', 'item', i, cAux2 )
      SetProperty( 'VentanaMain', 'GExcFiles', 'item', i + 1, cAux )
      SetProperty( 'VentanaMain', 'GExcFiles', 'value', i + 1 )
      DoMethod( 'VentanaMain', 'GExcFiles', 'setfocus' )
   ENDIF
RETURN .T.

#ifdef QPM_SHG
FUNCTION UpHlp()
   LOCAL i := GetProperty( 'VentanaMain', 'GHlpFiles', 'value' )
   LOCAL cAux := GetProperty( 'VentanaMain', 'GHlpFiles', 'item', i )
   LOCAL cAux2 := GetProperty( 'VentanaMain', 'GHlpFiles', 'item', i - 1 )
   IF i == 3
      MyMsgStop( "Global footer and Welcome page can't be moved!" )
   ENDIF
   IF i > 3
      bHlpMoving := .T.
      SHG_SetField( 'SHG_ORDER', i - 1, 0 )
      SHG_SetField( 'SHG_ORDER', i, i - 1 )
      SHG_SetField( 'SHG_ORDER', 0, i )
      SetProperty( 'VentanaMain', 'GHlpFiles', 'item', i, cAux2 )
      SetProperty( 'VentanaMain', 'GHlpFiles', 'item', i - 1, cAux )
      SetProperty( 'VentanaMain', 'GHlpFiles', 'value', i - 1 )
      DoMethod( 'VentanaMain', 'GHlpFiles', 'setfocus' )
      bHlpMoving := .F.
   ENDIF
RETURN .T.
#endif

#ifdef QPM_SHG
FUNCTION DownHlp()
   LOCAL i := GetProperty( 'VentanaMain', 'GHlpFiles', 'value' )
   LOCAL cAux := GetProperty( 'VentanaMain', 'GHlpFiles', 'item', i )
   LOCAL cAux2 := GetProperty( 'VentanaMain', 'GHlpFiles', 'item', i + 1 )
   IF i == 1
      MyMsgStop( "Global footer can't be moved!" )
   ENDIF
   IF i == 2
      MyMsgStop( "Welcome page can't be moved!" )
   ENDIF
   IF i < GetProperty( 'VentanaMain', 'GHlpFiles', 'itemcount' ) .AND. i > 2
      bHlpMoving := .T.
      SHG_SetField( 'SHG_ORDER', i + 1, 0 )
      SHG_SetField( 'SHG_ORDER', i, i + 1 )
      SHG_SetField( 'SHG_ORDER', 0, i )
      SetProperty( 'VentanaMain', 'GHlpFiles', 'item', i, cAux2 )
      SetProperty( 'VentanaMain', 'GHlpFiles', 'item', i + 1, cAux )
      SetProperty( 'VentanaMain', 'GHlpFiles', 'value', i + 1 )
      DoMethod( 'VentanaMain', 'GHlpFiles', 'setfocus' )
      bHlpMoving := .F.
   ENDIF
RETURN .T.
#endif

FUNCTION EraseOBJ()
   LOCAL TopName := US_FileNameOnlyName( GetOutputModuleName() )
   IF ! Empty( PUB_cProjectFolder )
      US_DirRemove( GetObjFolder() )
      ferase( PUB_cProjectFolder + DEF_SLASH + TopName + '.' + OutputExt() )
      ferase( PUB_cProjectFolder + DEF_SLASH + TopName + '.TDS' )
   ENDIF
   IF PUB_bLite
      VentanaLite.LFull.FontColor := DEF_COLORRED
      VentanaLite.LFull.Value := 'Force non-incremental'
   ELSE
      VentanaMain.LFull.FontColor := DEF_COLORRED
      VentanaMain.LFull.Value := 'Force non-incremental'
   ENDIF
   QPM_SetResumen()
   vSinLoadWindow := {}
   vSinInclude    := {}
   vXRefPrgHea    := {}
   vXRefPrgFmg    := {}
   RichEditDisplay('OUT')
   QPM_LogText( "EraseOBJ() done" )
RETURN .T.

FUNCTION EraseALL()
   LOCAL i, dire
   IF bWaitForBuild
      DO WHILE BUILD_IN_PROGRESS
         DO EVENTS
      ENDDO
   ENDIF
   IF ! Empty( PUB_cProjectFolder )
      FOR i := 1 TO Len( vSuffix )
         dire := PUB_cProjectFolder + DEF_SLASH + GetObjPrefix() + vSuffix[i][1]
         US_DirRemove( dire )
         dire := PUB_cProjectFolder + DEF_SLASH + GetObjPrefix() + Left( vSuffix[i][1], Len( vSuffix[i][1] ) - 3 )
         US_DirRemove( dire )
      NEXT i
      IF PUB_bLite
         VentanaLite.LFull.FontColor := DEF_COLORRED
         VentanaLite.LFull.Value := 'Force non-incremental'
      ELSE
         VentanaMain.LFull.FontColor := DEF_COLORRED
         VentanaMain.LFull.Value := 'Force non-incremental'
      ENDIF
      QPM_SetResumen()
      vSinLoadWindow := {}
      vSinInclude    := {}
      vXRefPrgHea    := {}
      vXRefPrgFmg    := {}
      QPM_LogText( "Done" + CRLF )
   ENDIF
RETURN .T.

FUNCTION BuildStop()
   QPM_MemoWrit( MSG_SYSIN, 'STOP ' )
   IF PUB_bLite
      VentanaLite.bStop.Enabled := .F.
   ELSE
      VentanaMain.bStop.Enabled := .F.
   ENDIF
   VentanaMain.TabFiles.Value := nPageSysout
   TabChange( 'FILES' )
   DO WHILE File( MSG_SYSIN )
      US_Wait( 2 )
      DO EVENTS
   ENDDO
   QPM_LogText( "BuildStop() done" + CRLF )
RETURN .T.

FUNCTION TabAutoSync( tab )
   LOCAL bSync := GetProperty( 'VentanaMain', 'Check_AutoSync'+tab, 'Value' )
   bAutoSyncTab := bSync
   IF !PUB_RunTabAutoSync
      RETURN .T.
   ELSE
      PUB_RunTabAutoSync := .F.
   ENDIF
   IF ! ( tab == 'PRG' )
      VentanaMain.Check_AutoSyncPrg.Value := bSync
   ENDIF
   IF ! ( tab == 'HEA' )
      VentanaMain.Check_AutoSyncHea.Value := bSync
   ENDIF
   IF ! ( tab == 'PAN' )
      VentanaMain.Check_AutoSyncPan.Value := bSync
   ENDIF
   IF ! ( tab == 'DBF' )
      VentanaMain.Check_AutoSyncDbf.Value := bSync
   ENDIF
   IF ! ( tab == 'LIB' )
      VentanaMain.Check_AutoSyncLib.Value := bSync
   ENDIF
   IF ! ( tab == 'HLP' )
      VentanaMain.Check_AutoSyncHlp.Value := bSync
   ENDIF
// IF ! ( tab == 'SYSOUT' )
//    VentanaMain.Check_AutoSyncSysout.Value := bSync
// ENDIF
// IF ! ( tab == 'OUT' )
//    VentanaMain.Check_AutoSyncOut.Value := bSync
// ENDIF
   PUB_RunTabAutoSync := .T.
   IF bSync
      TabSync()
   ENDIF
RETURN .T.

FUNCTION TabSync()
   VentanaMain.TabFiles.Value := VentanaMain.TabGrids.Value
   TabChange()
RETURN .T.

FUNCTION TabChange( cTabGroups )
   LOCAL w_antes

   IF !PUB_RunTabChange
      PUB_RunTabChange := .T.
      RETURN .F.
   ENDIF
   IF Prj_Radio_OutputType == DEF_RG_IMPORT
      IF cTabGroups == 'GRIDS' .AND. ;
         GetProperty( 'VentanaMain', 'TabGrids', 'value' ) > 1 .AND. ;
         GetProperty( 'VentanaMain', 'TabGrids', 'value' ) < 6
         PUB_RunTabChange := .F.
         SetProperty( 'VentanaMain', 'TabGrids', 'value', 1 )
      ENDIF
      IF cTabGroups == 'FILES' .AND. ;
         GetProperty( 'VentanaMain', 'TabFiles', 'value' ) > 1 .AND. ;
         GetProperty( 'VentanaMain', 'TabFiles', 'value' ) < 6
         PUB_RunTabChange := .F.
         SetProperty( 'VentanaMain', 'TabFiles', 'value', 1 )
      ENDIF
   ENDIF

   IF bAutoSyncTab
      IF cTabGroups == 'FILES'
         PUB_RunTabChange := .F.
         SetProperty ( 'VentanaMain', 'TabGrids', 'Value', VentanaMain.TabFiles.Value )
      ELSE
         IF VentanaMain.TabFiles.Value < nPageSysout
            PUB_RunTabChange := .F.
            SetProperty( 'VentanaMain', 'TabFiles', 'Value', VentanaMain.TabGrids.Value )
         ENDIF
      ENDIF
   ENDIF

   IF VentanaMain.TabFiles.Value <> VentanaMain.TabGrids.Value
      VentanaMain.bSyncPrg.Show()
      VentanaMain.bSyncHea.Show()
      VentanaMain.bSyncPan.Show()
      VentanaMain.bSyncDbf.Show()
      VentanaMain.bSyncLib.Show()
#ifdef QPM_SHG
      VentanaMain.bSyncHlp.Show()
#endif
   ELSE
      VentanaMain.bSyncPrg.Hide()
      VentanaMain.bSyncHea.Hide()
      VentanaMain.bSyncPan.Hide()
      VentanaMain.bSyncDbf.Hide()
      VentanaMain.bSyncLib.Hide()
#ifdef QPM_SHG
      VentanaMain.bSyncHlp.Hide()
#endif
   ENDIF
   IF VentanaMain.TabFiles.Value <> VentanaMain.TabGrids.Value .AND. ;
      VentanaMain.TabFiles.Value < nPageSysOut
      VentanaMain.IBorde1PRG.Show()
      VentanaMain.IBorde1HEA.Show()
      VentanaMain.IBorde1PAN.Show()
      VentanaMain.IBorde1DBF.Show()
      VentanaMain.IBorde1LIB.Show()
#ifdef QPM_SHG
      VentanaMain.IBorde1HLP.Show()
#endif
   ELSE
      VentanaMain.IBorde1PRG.Hide()
      VentanaMain.IBorde1HEA.Hide()
      VentanaMain.IBorde1PAN.Hide()
      VentanaMain.IBorde1DBF.Hide()
      VentanaMain.IBorde1LIB.Hide()
#ifdef QPM_SHG
      VentanaMain.IBorde1HLP.Hide()
#endif
   ENDIF
   IF VentanaMain.TabFiles.Value == nPageHlp
      VentanaMain.ItC_Cut.Enabled       := .T.
      VentanaMain.ItC_Paste.Enabled     := .T.
      VentanaMain.ItC_CutM.Enabled      := .T.
      VentanaMain.ItC_PasteM.Enabled    := .T.
      VentanaMain.ItC_Move.Enabled      := .T.
   ELSE
      VentanaMain.ItC_Cut.Enabled       := .F.
      VentanaMain.ItC_Paste.Enabled     := .F.
      VentanaMain.ItC_CutM.Enabled      := .F.
      VentanaMain.ItC_PasteM.Enabled    := .F.
      VentanaMain.ItC_Move.Enabled      := .F.
   ENDIF
   IF !PUB_bIsProcessing
      IF VentanaMain.TabGrids.Value == nPageHlp
         SetProperty( 'VentanaMain', 'save', 'enabled', .F. )
         SetProperty( 'VentanaMain', 'build', 'enabled', .F. )
         SetProperty( 'VentanaMain', 'EraseALL', 'enabled', .F. )
         SetProperty( 'VentanaMain', 'EraseOBJ', 'enabled', .F. )
         SetProperty( 'VentanaMain', 'BVerChange', 'enabled', .F. )
#ifdef QPM_SYNCRECOVERY
         SetProperty( 'VentanaMain', 'BTakeSyncRecovery', 'enabled', .F. )
#endif
      ELSE
         SetProperty( 'VentanaMain', 'save', 'enabled', .T. )
         SetProperty( 'VentanaMain', 'build', 'enabled', .T. )
         SetProperty( 'VentanaMain', 'EraseALL', 'enabled', .T. )
         SetProperty( 'VentanaMain', 'EraseOBJ', 'enabled', .T. )
         SetProperty( 'VentanaMain', 'BVerChange', 'enabled', .T. )
#ifdef QPM_SYNCRECOVERY
         IF VentanaMain.TabGrids.Value <= nPagePan
            SetProperty( 'VentanaMain', 'BTakeSyncRecovery', 'enabled', .T. )
         ELSE
            SetProperty( 'VentanaMain', 'BTakeSyncRecovery', 'enabled', .F. )
         ENDIF
#endif
      ENDIF
   ENDIF
#ifdef QPM_SHG
   OcultaHlpKeys()
#endif
   // este parche es hasta que se resuelva el problema de la barra de desplazamiento en el browse dentro de un page of tab
   IF VentanaMain.TabFiles.Value == nPageDbf
      IF _IsControlDefined( 'DbfBrowse', 'VentanaMain' )
         SetProperty( 'VentanaMain', 'DbfBrowse', 'visible', .T. )
      ENDIF
   ELSE
      IF _IsControlDefined( 'DbfBrowse', 'VentanaMain' )
         SetProperty( 'VentanaMain', 'DbfBrowse', 'visible', .F. )
      ENDIF
   ENDIF
   // Fin parche
   DO CASE
      CASE VentanaMain.TabGrids.Value == nPagePRG
         GBL_TabGridNameFocus := 'PRG'
      CASE VentanaMain.TabGrids.Value == nPageHEA
         GBL_TabGridNameFocus := 'HEA'
      CASE VentanaMain.TabGrids.Value == nPagePAN
         GBL_TabGridNameFocus := 'PAN'
      CASE VentanaMain.TabGrids.Value == nPageDBF
         GBL_TabGridNameFocus := 'DBF'
      CASE VentanaMain.TabGrids.Value == nPageLIB
         GBL_TabGridNameFocus := 'LIB'
      CASE VentanaMain.TabGrids.Value == nPageHLP
         GBL_TabGridNameFocus := 'HLP'

         IF VentanaMain.GHlpFiles.ItemCount > 0
            VentanaMain.GHlpFiles.SetFocus
            w_antes := GetProperty( 'VentanaMain', 'GHlpFiles', 'Value' )
            SetProperty( 'VentanaMain', 'GHlpFiles', 'Value', 0 )
            SetProperty( 'VentanaMain', 'GHlpFiles', 'Value', w_antes )
         ENDIF
      OTHERWISE
         GBL_TabGridNameFocus := 'OTHER'
   ENDCASE
RETURN .T.

FUNCTION TotCaption( cType, nValor )
   LOCAL nPage := 0, cAux := '', nAux := 0
   DO CASE
      CASE cType == 'PRG'
         nPage := nPagePrg
      CASE cType == 'HEA'
         nPage := nPageHea
      CASE cType == 'PAN'
         nPage := nPagePan
      CASE cType == 'DBF'
         nPage := nPageDbf
      CASE cType == 'LIB'
         nPage := nPageLib
#ifdef QPM_SHG
      CASE cType == 'HLP'
         nPage := nPageHlp
#endif
   ENDCASE
   IF ! ( nValor == 0 )
      IF At( '(', VentanaMain.TabGrids.Caption( nPage ) ) > 0
         cAux := US_Word( strtran( strtran( VentanaMain.TabGrids.Caption( nPage ), '(', '' ), ')', '' ), US_Words( VentanaMain.TabGrids.Caption( nPage ) ) )
      ENDIF
      IF ! Empty( cAux )
         nAux := Val( cAux )
      ENDIF
      nAux := nAux + nValor
   ENDIF
   IF nAux > 0
      VentanaMain.TabGrids.Caption( nPage ) := &('Page'+cType) + ' (' + AllTrim( Str( nAux ) ) + ')'
   ELSE
      VentanaMain.TabGrids.Caption( nPage ) := &('Page'+cType)
   ENDIF
RETURN .T.

FUNCTION PpoDisplay( bOnlyRenumering )
   LOCAL ppoFile, nRow
   IF Empty( bOnlyRenumering )
      bOnlyRenumering := .F.
   ENDIF
   IF bPpoDisplayado .AND. !bOnlyRenumering
      QPM_EditPPO()
   ELSE
      IF nRow == 0 .OR. GetProperty( 'VentanaMain', 'GPrgFiles', 'Itemcount' ) == 0
         VentanaMain.RichEditPrg.Value := ''
      ELSE
         nRow := GetProperty( 'VentanaMain', 'GPrgFiles', 'value' )
         IF Upper( US_FileNameOnlyExt( GetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', nRow, NCOLPRGNAME ) ) ) == 'PRG'
            ppoFile := GetObjFolder() + DEF_SLASH + US_FileNameOnlyName( GetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', nRow, NCOLPRGNAME ) ) + '.ppo'
            IF File( ppoFile )
               IF Val( US_FileDateTime( ppoFile ) ) < Val( US_FileDateTime( ChgPathToReal( GetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', nRow, NCOLPRGFULLNAME ) ) ) )
                  MyMsgWarn( "The date of the PRG file is more recent than that of the PPO file." + CRLF + ;
                             'Rebuild the project after pressing "Non-Incremental" button or after saving the PRG file.' )
               ENDIF
               cPpoCaretPrg := AllTrim( Str( VentanaMain.RichEditPRG.CaretPos ) )
               VentanaMain.RichEditPrg.FontColor := DEF_COLORFONTPPO
               VentanaMain.RichEditPrg.BackColor := DEF_COLORBACKPPO
               VentanaMain.RichEditPRG.Value := Enumeracion( MemoRead( ppoFile ), 'PRG' )
               VentanaMain.RichEditPRG.CaretPos := 1
               VentanaMain.bReLoadPpo.caption := 'Edit PPO'
               bPpoDisplayado := .T.
            ELSE
               MyMsgWarn( 'PPO file was not found!' + CRLF + ;
                          'ReBuild the project after pressing "Non-Incremental" button or after saving the PRG file.' )
            ENDIF
         ELSE
            IF Prj_Warn_PPO_Browse
               IF MyMsgYesNo( "PPO file browsing only applies to PRG files." + CRLF + 'Omit this message from now on?' )
                  Prj_Warn_PPO_Browse := .F.
                  MyMsgInfo( 'Use ' + DBLQT + PUB_MenuResetWarnings + DBLQT + ' option of Settings menu to enable the previous message.' )
               ENDIF
            ENDIF
         ENDIF
      ENDIF
   ENDIF
RETURN .T.

FUNCTION RichEditDisplay( tipo, bReload, nRow, bForce )
   LOCAL DbfName, IncName, lCont
   LOCAL aStru, x, DbfCode
   LOCAL ListOut, cType := '', AuxRegistro
   LOCAL nInx, LinesKeys, aLines
   LOCAL MemoKeys
   IF Empty( nRow ) .AND. ! ( tipo == 'OUT' )
      nRow := GetProperty( 'VentanaMain', 'G'+tipo+'Files', 'Value' )
   ENDIF
   IF nRow == NIL
      nRow := 0
   ENDIF
   DbfName := ChgPathToReal( GetProperty( 'VentanaMain', 'GDbfFiles', 'Cell', nRow, NCOLDBFFULLNAME ) )
   IncName := ChgPathToReal( US_WordSubStr( GetProperty( 'VentanaMain', 'GIncFiles', 'Cell', nRow, NCOLINCFULLNAME ), 3 ) )
   DEFAULT bReload TO .F.
   DEFAULT bForce  TO .F.
   DO CASE
   CASE tipo == 'PRG'
      IF nRow == 0
         VentanaMain.RichEditPrg.Value := ''
         RETURN .F.
      ENDIF
      IF bReload .AND. bGlobalSearch
         SetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', nRow, NCOLPRGOFFSET, '0' )
         IF GridImage( 'VentanaMain', 'GPrgFiles', nRow, NCOLPRGSTATUS, '?', PUB_nGridImgSearchOk )
            TotCaption( tipo, -1 )
         ENDIF
         IF GlobalSearch2( tipo, cLastGlobalSearch, nRow, bLastGlobalSearchFun, bLastGlobalSearchDbf )
            TotCaption( tipo, +1 )
         ENDIF
      ELSE
         IF nGridPrgLastRow > 0
            LostRichEdit( 'PRG' )
         ENDIF
         nGridPrgLastRow := nRow
      ENDIF
      IF GridImage( 'VentanaMain', 'GPrgFiles', nRow, NCOLPRGSTATUS, '?', PUB_nGridImgEdited )
         VentanaMain.RichEditPrg.BackColor := DEF_COLORBACKEXTERNALEDIT
         VentanaMain.RichEditPrg.FontColor := DEF_COLORFONTEXTERNALEDIT
      ELSE
         VentanaMain.RichEditPrg.BackColor := DEF_COLORBACKPRG
         VentanaMain.RichEditPrg.FontColor := DEF_COLORFONTVIEW
      ENDIF
      IF Prj_Radio_OutputType == DEF_RG_IMPORT
         VentanaMain.RichEditPRG.Value := QPM_Wait( "ListModule( '" + ChgPathToReal( GetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', 1, NCOLPRGFULLNAME ) ) + "' )", 'Listing ...', NIL, .T. )
         VentanaMain.RichEditPRG.CaretPos := 1
      ELSE
         bPpoDisplayado := .F.
         VentanaMain.RichEditPRG.Value := Enumeracion( MemoRead( ChgPathToReal( GetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', nRow, NCOLPRGFULLNAME ) ) ), tipo )
         VentanaMain.RichEditPRG.CaretPos := Val( GetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', nRow, NCOLPRGOFFSET ) )
         VentanaMain.bReLoadPpo.caption := 'Browse PPO'
      ENDIF
   CASE tipo == 'HEA'
      IF nRow == 0
         VentanaMain.RichEditHea.Value := ''
         RETURN .F.
      ENDIF
      IF bReload .AND. bGlobalSearch
         SetProperty( 'VentanaMain', 'GHeaFiles', 'Cell', nRow, NCOLHEAOFFSET, '0' )
         IF GridImage( 'VentanaMain', 'GHeaFiles', nRow, NCOLHEASTATUS, '?', PUB_nGridImgSearchOk )
            TotCaption( tipo, -1 )
         ENDIF
         IF GlobalSearch2( tipo, cLastGlobalSearch, nRow, bLastGlobalSearchFun, bLastGlobalSearchDbf )
            TotCaption( tipo, +1 )
         ENDIF
      ELSE
         IF nGridHeaLastRow > 0
            LostRichEdit( 'HEA' )
         ENDIF
         nGridHeaLastRow := nRow
      ENDIF
      IF GridImage( 'VentanaMain', 'GHeaFiles', nRow, NCOLHEASTATUS, '?', PUB_nGridImgEdited )
         VentanaMain.RichEditHea.BackColor := DEF_COLORBACKEXTERNALEDIT
         VentanaMain.RichEditHea.FontColor := DEF_COLORFONTEXTERNALEDIT
      ELSE
         VentanaMain.RichEditHea.BackColor := DEF_COLORBACKHEA
         VentanaMain.RichEditHea.FontColor := DEF_COLORFONTVIEW
      ENDIF
      VentanaMain.RichEditHea.Value := Enumeracion( MemoRead( ChgPathToReal( GetProperty( 'VentanaMain', 'GHeaFiles', 'Cell', nRow, NCOLHEAFULLNAME ) ) ), tipo )
      VentanaMain.RichEditHea.CaretPos := Val( GetProperty( 'VentanaMain', 'GHeaFiles', 'Cell', nRow, NCOLHEAOFFSET ) )
   CASE tipo == 'PAN'
      IF nRow == 0
         VentanaMain.RichEditPan.Value := ''
         RETURN .F.
      ENDIF
      IF bReload .AND. bGlobalSearch
         SetProperty( 'VentanaMain', 'GPanFiles', 'Cell', nRow, NCOLPANOFFSET, '0' )
         IF GridImage( 'VentanaMain', 'GPanFiles', nRow, NCOLPANSTATUS, '?', PUB_nGridImgSearchOk )
            TotCaption( tipo, -1 )
         ENDIF
         IF GlobalSearch2( tipo, cLastGlobalSearch, nRow, bLastGlobalSearchFun, bLastGlobalSearchDbf )
            TotCaption( tipo, +1 )
         ENDIF
      ELSE
         IF nGridPanLastRow > 0
            LostRichEdit( 'PAN' )
         ENDIF
         nGridPanLastRow := nRow
      ENDIF
      IF GridImage( 'VentanaMain', 'GPanFiles', nRow, NCOLPANSTATUS, '?', PUB_nGridImgEdited )
         VentanaMain.RichEditPan.BackColor := DEF_COLORBACKEXTERNALEDIT
         VentanaMain.RichEditPan.FontColor := DEF_COLORFONTEXTERNALEDIT
      ELSE
         VentanaMain.RichEditPan.BackColor := DEF_COLORBACKPAN
         VentanaMain.RichEditPan.FontColor := DEF_COLORFONTVIEW
      ENDIF
      VentanaMain.RichEditPan.Value := Enumeracion( MemoRead( ChgPathToReal( GetProperty( 'VentanaMain', 'GPanFiles', 'Cell', nRow, NCOLPANFULLNAME ) ) ), tipo )
      VentanaMain.RichEditPan.CaretPos := Val( GetProperty( 'VentanaMain', 'GPanFiles', 'Cell', nRow, NCOLPANOFFSET ) )
   CASE tipo == 'DBF'
      IF nRow == 0
         VentanaMain.RichEditDbf.Value := ''
         RETURN .F.
      ENDIF
      IF _IsControlDefined( 'DbfBrowse', 'VentanaMain' )
         AuxRegistro := VentanaMain.DbfBrowse.Value
      ELSE
         AuxRegistro := 1
      ENDIF
      CloseDbfAutoView()
      IF bGlobalSearch .AND. bLastGlobalSearchDbf
         IF Prj_Warn_SlowSearch
            lCont := MyMsgYesNo( 'Loading a DBF when Global Search is active and "DBF Data Search" is selected may take a long time.' + CRLF + ;
                                 'Select [Yes] to continue or [No] to cancel.' )
            IF MyMsgYesNo( 'Omit the previous validation from now on?' + CRLF + iif( lCont, "[Yes] will be assumed!", "[No] will be assumed!" ) )
               Prj_Warn_SlowSearch := .F.
               Prj_Warn_SlowSearch_Cont := lCont
               MyMsgInfo( 'Use ' + DBLQT + PUB_MenuResetWarnings + DBLQT + ' option of Settings menu to enable the previous check.' )
            ELSE
               Prj_Warn_SlowSearch := .T.
            ENDIF
         ELSE
            lCont := Prj_Warn_SlowSearch_Cont
         ENDIF
         IF ! lCont
            bReload := .F.
         ENDIF
      ENDIF
      IF bReload .AND. bGlobalSearch
         IF GridImage( 'VentanaMain', 'GDbfFiles', nRow, NCOLDBFSTATUS, '?', PUB_nGridImgSearchOk )
            TotCaption( tipo, -1 )
         ENDIF
         IF GlobalSearch2( tipo, cLastGlobalSearch, nRow, bLastGlobalSearchFun, bLastGlobalSearchDbf )
            TotCaption( tipo, +1 )
         ENDIF
      ELSE
         IF nGridDbfLastRow > 0
            LostRichEdit( 'DBF', AuxRegistro )
         ENDIF
         nGridDbfLastRow := nRow
      ENDIF
      IF bReload
         bAvisoDbfDataSearchLow := .T.
         bDbfDataSearchAsk      := .T.
         cDbfDataSearchAskRpta  := ''
      ENDIF
      IF GridImage( 'VentanaMain', 'GDbfFiles', nRow, NCOLDBFSTATUS, '?', PUB_nGridImgEdited )
         VentanaMain.RichEditDbf.BackColor := DEF_COLORBACKEXTERNALEDIT
         VentanaMain.RichEditDbf.FontColor := DEF_COLORFONTEXTERNALEDIT
      ELSE
         VentanaMain.RichEditDbf.BackColor := DEF_COLORBACKDBF
         VentanaMain.RichEditDbf.FontColor := DEF_COLORFONTVIEW
      ENDIF
      DbfCode := US_IsDBF( DbfName )
      IF ! ( DbfCode == 0 )
         IF DbfCode == 21   // open exclusive by another program
            VentanaMain.RichEditDbf.Value := CRLF + ;
                                             CRLF + ;
                                             CRLF + ;
                                             CRLF + ;
                                             CRLF + ;
                                             CRLF + ;
                                             "     Database '"+DbfName+"' is open EXCLUSIVE by another process or DBT file is missing."
         ELSE
            VentanaMain.RichEditDbf.Value := CRLF + ;
                                             CRLF + ;
                                             CRLF + ;
                                             CRLF + ;
                                             CRLF + ;
                                             CRLF + ;
                                             "     Database '"+DbfName+"' is not valid DBF file."
         ENDIF
         DefineRichEditForNotDbfView( 'DBF Not Open!' )
      ELSE
         VentanaMain.RichEditDbf.Value := CRLF + ;
                                          'Structure of database: ' + DbfName + CRLF + CRLF + ;
                                          replicate( ' ', 22 ) + padr( 'Field', 15 ) + padr( 'Type', 4 ) + padl( 'Length', 8 )+ padl( 'Decimal', 8 ) + CRLF + ;
                                          replicate( ' ', 22 ) + replicate( '=', 35 )

         US_Use( .T.,, DbfName, 'DbfAlias', DEF_DBF_SHARED, DEF_DBF_READ ) /* si lo pongo exclusive y write no funciona el search, revisarlo */
         aStru:=DBSTRUCT()
         vDbfJustify := {}
         vDbfHeaders := {}
         vDbfWidths  := {}
         FOR x := 1 TO Len(aStru)
            AAdd( vDbfJustify, iif( aStru[x][2] == 'N', BROWSE_JTFY_RIGHT, BROWSE_JTFY_LEFT ) )
            AAdd( vDbfHeaders, aStru[x][1] )
            AAdd( vDbfWidths, iif( aStru[x][3] > 20, 330, 90 ) )
            VentanaMain.RichEditDbf.Value := VentanaMain.RichEditDbf.Value + CRLF + ;
                                             replicate( ' ', 22 ) + padr( aStru[x][1], 15 ) + padr( aStru[x][2], 4 ) + padl( aStru[x][3], 8 )+ padl( aStru[x][4], 8 )
         NEXT

         IF ( bDbfAutoView .AND. !bRunApp ) .OR. bForce

            IF _IsControlDefined( 'DbfAutoView', 'VentanaMain' )
               VentanaMain.DbfAutoView.Release()
            ENDIF

            SET BROWSESYNC ON

            @ GetDesktopRealHeight() - int( ( GetDesktopRealHeight() * 72 ) / 100 ), 10 BROWSE DbfBrowse ;
               OF VentanaMain ;
               WIDTH 0 ;
               HEIGHT 0 ;
               HEADERS ( vDbfHeaders ) ;
               WIDTHS ( vDbfWidths ) ;
               WORKAREA DbfAlias ;
               FIELDS ( vDbfHeaders ) ;
               VALUE RECNO() ;
               FONT 'CourierNew' SIZE 9 ;
               BACKCOLOR DEF_COLORBACKDBF

            VentanaMain.TabFiles.AddControl( 'DbfBrowse', nPageDbf, GetDesktopRealHeight() - int( ( GetDesktopRealHeight() * 72 ) / 100 ), 10 )
            VentanaMain.DbfBrowse.DisableUpdate()
            VentanaMain.DbfBrowse.Width  := GetDesktopRealWidth() - 364
            VentanaMain.DbfBrowse.Height := ( GetDesktopRealHeight() - 237 ) - ( GetDesktopRealHeight() - int( ( GetDesktopRealHeight() * 72 ) / 100 ) )
            VentanaMain.DbfBrowse.value  := Val( US_Word( GetProperty( 'VentanaMain', 'GDbfFiles', 'Cell', nRow, NCOLDBFOFFSET ), 2 ) )
            VentanaMain.DbfBrowse.EnableUpdate()
            VentanaMain.DbfBrowse.Refresh()
         ELSE
            CloseDbfAutoView()
            IF bRunApp
               DefineRichEditForNotDbfView( 'DBF view is disable while the app is running!' )
            ELSE
               DefineRichEditForNotDbfView( 'DBF AutoView is OFF!' )
            ENDIF
         ENDIF
      ENDIF
      VentanaMain.BLocalSearchDbf.caption := 'DBF Search'
      VentanaMain.BLocalSearchDbf.Tooltip := "Search DBF's data for some text."
      VentanaMain.RichEditDbf.CaretPos := Val( US_Word( GetProperty( 'VentanaMain', 'GDbfFiles', 'Cell', nRow, NCOLDBFOFFSET ), 1 ) )
   CASE tipo == 'DEF'
      IF nRow == 0
         VentanaMain.RichEditLib.Value := ''
         RETURN .F.
      ENDIF
      VentanaMain.RichEditLib.Value := CRLF + ;
                                       CRLF + ;
                                       CRLF + ;
                                       CRLF + ;
                                       CRLF + ;
                                       CRLF + ;
                                       '     To list a default library temporarily add it to "Include" list.'
   CASE tipo == 'INC'
      IF nRow == 0
         VentanaMain.RichEditLib.Value := ''
         RETURN .F.
      ENDIF
      VentanaMain.RichEditLib.Value := ListModule( IncName )
      IF ! File( IncName )
         VentanaMain.RichEditLib.Value := CRLF + ;
                                          CRLF + ;
                                          CRLF + ;
                                          CRLF + ;
                                          CRLF + ;
                                          CRLF + ;
                                          "     Library '" + IncName + "' not found!"
      ELSE
         DO CASE
            CASE Upper( US_FileNameOnlyExt( IncName ) ) == 'LIB'
               cType := QPM_ModuleType( IncName ) + ' Library'
            CASE Upper( US_FileNameOnlyExt( IncName ) ) == 'A'
               cType := QPM_ModuleType( IncName ) + ' Library'
            CASE Upper( US_FileNameOnlyExt( IncName ) ) == "OBJ"
               cType := QPM_ModuleType( IncName ) + ' Object'
            CASE Upper( US_FileNameOnlyExt( IncName ) ) == 'O'
               cType := QPM_ModuleType( IncName ) + ' Object'
            CASE Upper( US_FileNameOnlyExt( IncName ) ) == "RES"
               cType := QPM_ModuleType( IncName ) + ' Resource'
            OTHERWISE
               US_Log( 'Extension ' + DBLQT + Upper( US_FileNameOnlyExt( IncName ) ) + DBLQT + " is not supported." )
         ENDCASE
         VentanaMain.RichEditLib.Value := CRLF + ;
                                          CRLF + ;
                                          CRLF + ;
                                          CRLF + ;
                                          CRLF + ;
                                          CRLF + ;
                                          "     Library '" + IncName + "'" + CRLF + ;
                                          '             Size: ' + AllTrim( Str( US_FileSize( IncName ) ) ) + CRLF + ;
                                          '             Type: ' + cType + CRLF + ;
                                          CRLF + ;
                                          "             Press 'List Library/Object' button for view function in Library or Object"
      ENDIF
   CASE tipo == 'OUT'
      ListOut := GetOutputModuleName()
      IF Left( ListOut, 1 ) == "."
         VentanaMain.RichEditOut.Value := CRLF + ;
                                          CRLF + ;
                                          CRLF + ;
                                          CRLF + ;
                                          CRLF + ;
                                          CRLF + ;
                                          "     Output Module file not found!"
      ELSE
         IF ! File( ListOut )
            IF File( ListOut + '.MOVED.TXT' )
               ListOut := US_WordSubStr( MemoRead( ListOut + '.MOVED.TXT' ), 7 )
            ELSE
               VentanaMain.RichEditOut.Value := CRLF + ;
                                                CRLF + ;
                                                CRLF + ;
                                                CRLF + ;
                                                CRLF + ;
                                                CRLF + ;
                                                '     Output Module file "' + ListOut + '" not found!'
            ENDIF
         ENDIF
         cType := Upper( US_FileNameOnlyExt( ListOut ) )
         DO CASE
         CASE cType == 'LIB'
            cType := QPM_ModuleType( ListOut ) + ' Library'
         CASE cType == 'A'
            cType := QPM_ModuleType( ListOut ) + ' Library'
         CASE cType == 'EXE'
            cType := 'Executable ' + QPM_ModuleType( ListOut )
         CASE cType == 'DLL'
            cType := 'Dynamic Link Library'
         OTHERWISE
            cType += ' ( unknown )'
         ENDCASE
         VentanaMain.RichEditOut.Value := CRLF + ;
                                          CRLF + ;
                                          CRLF + ;
                                          CRLF + ;
                                          CRLF + ;
                                          CRLF + ;
                                          "        File '" + ListOut + "'" + CRLF + ;
                                          '             Size: ' + AllTrim( Str( US_FileSize( ListOut ) ) ) + CRLF + ;
                                          '             Type: ' + cType + CRLF + ;
                                          iif( ! "( unknown )" $ cType, 'Press "List" button to expand this module info.' + CRLF, "" )
      ENDIF
#ifdef QPM_SHG
   CASE tipo == 'HLP'
      IF nRow == 0
         VentanaMain.RichEditHlp.Value := ''
         oHlpRichEdit:lChanged := .F.
         RETURN .F.
      ENDIF
      IF bReload .AND. bGlobalSearch
         SetProperty( 'VentanaMain', 'GHlpFiles', 'Cell', nRow, NCOLHLPOFFSET, '0' )
         IF GridImage( 'VentanaMain', 'GHlpFiles', nRow, NCOLHLPSTATUS, '?', PUB_nGridImgSearchOk )
            TotCaption( tipo, -1 )
         ENDIF
         IF GlobalSearch2( tipo, cLastGlobalSearch, nRow, bLastGlobalSearchFun, bLastGlobalSearchDbf )
            TotCaption( tipo, +1 )
         ENDIF
      ELSE
         IF nGridHlpLastRow > 0
            IF !bHlpMoving
               IF !bReload
                  LostRichEdit( 'HLP', nGridHlpLastRow )
               ENDIF
            ENDIF
         ENDIF
         IF bGlobalSearch
            IF GridImage( 'VentanaMain', 'GHlpFiles', nGridHlpLastRow, NCOLHLPSTATUS, '?', PUB_nGridImgSearchOk )
               TotCaption( tipo, -1 )
            ENDIF
            IF GlobalSearch2( tipo, cLastGlobalSearch, nGridHlpLastRow, bLastGlobalSearchFun, bLastGlobalSearchDbf )
               TotCaption( tipo, +1 )
            ENDIF
         ENDIF
         nGridHlpLastRow := nRow
      ENDIF
      IF GridImage( 'VentanaMain', 'GHlpFiles', nRow, NCOLHLPSTATUS, '?', PUB_nGridImgEdited )
         VentanaMain.RichEditHlp.BackColor := DEF_COLORBACKEXTERNALEDIT
         VentanaMain.RichEditHlp.FontColor := DEF_COLORFONTEXTERNALEDIT
      ELSE
         VentanaMain.RichEditHlp.BackColor := DEF_COLORBACKHLP
         VentanaMain.RichEditHlp.FontColor := DEF_COLORFONTVIEW
      ENDIF
      VentanaMain.RichEditHlp.Value := SHG_GetField( 'SHG_MEMOT', nRow )
      VentanaMain.RichEditHlp.CaretPos := Val( GetProperty( 'VentanaMain', 'GHlpFiles', 'Cell', nRow, NCOLHLPOFFSET ) )
      oHlpRichEdit:US_EditRefreshButtons()
      oHlpRichEdit:lChanged := .F.
      MemoKeys := SHG_GetField( 'SHG_KEYST', VentanaMain.GHlpFiles.Value )
      LinesKeys := MLCount( MEmoKeys, 254 )
      aLines := {}
      FOR nInx := 1 TO LinesKeys
         AAdd( aLInes, { MemoLine( MemoKeys, 254, nInx ) } )
      NEXT
      VentanaMain.GHlpKeys.DisableUpdate
      VentanaMain.GHlpKeys.DeleteAllItems
      FOR nInx := 1 TO LinesKeys
         VentanaMain.GHlpKeys.AddItem( aLines[nInx] )
      NEXT
      VentanaMain.GHlpKeys.value := VentanaMain.GHlpFiles.ItemCount
      VentanaMain.GHlpKeys.EnableUpdate
      DoMethod( 'VentanaMain', 'GHlpKeys', 'ColumnsAutoFitH' )
#endif
   OTHERWISE
      RETURN .F.
   ENDCASE
RETURN .T.

#ifdef QPM_SHG
FUNCTION OcultaHlpKeys()
   DO CASE
      CASE VentanaMain.GHlpFiles.Value < 2 .AND. GetProperty( 'VentanaMain', 'TabFiles', 'Value' ) == nPageHlp
         VentanaMain.BAddHlpKey.Enabled    := .F.
         VentanaMain.BRemoveHlpKey.Enabled := .F.
         VentanaMain.GHlpKeys.Enabled      := .F.
         VentanaMain.ItC_AddHlpKey.Enabled := .F.
      CASE VentanaMain.GHlpFiles.Value > 1 .AND. GetProperty( 'VentanaMain', 'TabFiles', 'Value' ) == nPageHlp
         VentanaMain.BAddHlpKey.Enabled    := .T.
         VentanaMain.BRemoveHlpKey.Enabled := .T.
         VentanaMain.GHlpKeys.Enabled      := .T.
         VentanaMain.ItC_AddHlpKey.Enabled := .T.
   ENDCASE
   IF GetProperty( 'VentanaMain', 'TabFiles', 'Value' ) == nPageHlp
      VentanaMain.ItC_Move.Enabled                := .T.
      VentanaMain.ItC_AddHlpHTMLAmpersand.Enabled := .T.
      VentanaMain.ItC_AddHlpHTMLMenor.Enabled := .T.
      VentanaMain.ItC_AddHlpHTMLMayor.Enabled := .T.
      VentanaMain.ItC_AddHlpHTMLSpace.Enabled := .T.
      VentanaMain.ItC_AddHlpHTMLImage.Enabled := .T.
      VentanaMain.ItC_AddHlpHTMLeMail.Enabled := .T.
      VentanaMain.ItC_AddHlpHTMLLink.Enabled  := .T.
      VentanaMain.ItC_AddHlpHTMLLinkTopic.Enabled  := .T.
      VentanaMain.ItC_AddHlpHTMLAncora.Enabled  := .T.
      VentanaMain.ItC_Cut.Enabled       := .T.
      VentanaMain.ItC_Paste.Enabled     := .T.
      VentanaMain.ItC_CutM.Enabled      := .T.
      VentanaMain.ItC_PasteM.Enabled    := .T.
   ELSE
      VentanaMain.ItC_Move.Enabled                := .F.
      VentanaMain.ItC_AddHlpHTMLAmpersand.Enabled := .F.
      VentanaMain.ItC_AddHlpHTMLMenor.Enabled := .F.
      VentanaMain.ItC_AddHlpHTMLMayor.Enabled := .F.
      VentanaMain.ItC_AddHlpHTMLSpace.Enabled := .F.
      VentanaMain.ItC_AddHlpHTMLImage.Enabled := .F.
      VentanaMain.ItC_AddHlpHTMLeMail.Enabled := .F.
      VentanaMain.ItC_AddHlpHTMLLink.Enabled  := .F.
      VentanaMain.ItC_AddHlpHTMLLinkTopic.Enabled  := .F.
      VentanaMain.ItC_AddHlpHTMLAncora.Enabled  := .F.
      VentanaMain.ItC_Cut.Enabled       := .F.
      VentanaMain.ItC_Paste.Enabled     := .F.
      VentanaMain.ItC_CutM.Enabled      := .F.
      VentanaMain.ItC_PasteM.Enabled    := .F.
      VentanaMain.BAddHlpKey.Enabled    := .F.
      VentanaMain.BRemoveHlpKey.Enabled := .F.
      VentanaMain.GHlpKeys.Enabled      := .F.
      VentanaMain.ItC_AddHlpKey.Enabled := .F.
   ENDIF
RETURN .T.
#endif

FUNCTION ListRichEditLib( LibName, RichEdit )
   SetProperty( 'VentanaMain', RichEdit, 'Value', QPM_Wait( "ListModule( '" + LibName + "' )", 'Listing ...', NIL, .T. ) )
RETURN .T.

FUNCTION ListModuleMoved( ModName )
   LOCAL ListOut := ModName
   IF ! File( ModName )
      IF File( ModName + '.MOVED.TXT' )
         ListOut := US_WordSubStr( MemoRead( ModName + '.MOVED.TXT' ), 7 )
      ENDIF
   ENDIF
RETURN QPM_Wait( "ListModule( '" + ListOut + "' )", "Listing ...", NIL, .T. )

FUNCTION QPM_LogWrite( cData )
   QPM_MemoWrit( PUB_cQPM_Folder + DEF_SLASH + 'QPM.log', ;
                 MemoRead( PUB_cQPM_Folder + DEF_SLASH + 'QPM.log' ) + ;
                 DToS( Date() ) + " " + Time() + " US_QPM " + ProcName( 2 ) + "(" + Str( ProcLine( 2 ), 5, 0 ) + ")" + " " + cData + CRLF )
RETURN NIL

FUNCTION QPM_LogFile( cFile, lName )
   IF bLogActivity
      IF File( cFile )
         QPM_LogWrite( iif( HB_ISLOGICAL( lName ) .AND. lName, "File " + cFile + CRLF, "" ) + MemoRead( cFile ) )
      ELSE
         QPM_LogWrite( "File not found: " + cFile + CRLF + MemoRead( cFile )  )
      ENDIF
   ENDIF
RETURN NIL

FUNCTION QPM_LogText( cText, cTitle )
   IF bLogActivity .AND. ! Empty( cText )
      QPM_LogWrite( iif( ! Empty( cTitle), cTitle + CRLF, "" ) + cText )
   ENDIF
RETURN NIL

FUNCTION ListModule( ModName )
   LOCAL MemoAux, TempExeType, LOC_RunWaitFileStop := US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + '_' + PUB_cSecu + 'RWFS' + US_DateTimeCen() + '.cnt'
   LOCAL OrigModName := ModName, TempLibType
   IF ! File( ModName )
      MemoAux := "File '" + ModName + "' not found!"
      RETURN MemoAux
   ENDIF
   QPM_LogText( "ListModule start" )
   FErase( ModName + '.Tmp' )
   FErase( ModName + '.TmpOut' )
   IF Upper( US_FileNameOnlyExt( ModName ) ) == 'LIB'
      TempLibType := QPM_ModuleType( ModName )
      DO CASE
      CASE TempLibType == 'PELLES'
         QPM_MemoWrit( RUN_FILE, US_ShortName(PUB_cQPM_Folder) + DEF_SLASH + 'US_PODUMP.EXE -LINKERMEMBER:2 -ARCHIVEMEMBERS ' + US_ShortName( ModName ) + ' > "' + US_ShortName( ModName ) + '.Tmp"' )
         QPM_LogFile( RUN_FILE )
         QPM_Execute( RUN_FILE, "", DEF_QPM_EXEC_WAIT, DEF_QPM_EXEC_MINIMIZE )
         FErase( RUN_FILE )
         QPM_MemoWrit( RUN_FILE, US_ShortName(PUB_cQPM_Folder) + DEF_SLASH + 'US_SHELL.EXE QPM ANALIZE_LIB_PELLES ' + US_ShortName( ModName ) + '.Tmp' + ' -FILESTOP ' + LOC_RunWaitFileStop + ' > "' + US_ShortName( ModName ) + '.TmpOut"' )
         QPM_LogFile( RUN_FILE )
         QPM_Execute( RUN_FILE, "", DEF_QPM_EXEC_WAIT, DEF_QPM_EXEC_MINIMIZE, LOC_RunWaitFileStop )
         FErase( RUN_FILE )
      CASE TempLibType == 'BORLAND'
         QPM_LogText( US_ShortName(PUB_cQPM_Folder) + DEF_SLASH + 'US_TLIB.EXE ' + US_ShortName( ModName ) + ', ' + US_ShortName( ModName ) + '.Tmp' )
         QPM_Execute( US_ShortName(PUB_cQPM_Folder) + DEF_SLASH + 'US_TLIB.EXE', US_ShortName( ModName ) + ', ' + US_ShortName( ModName ) + '.Tmp', DEF_QPM_EXEC_WAIT, DEF_QPM_EXEC_MINIMIZE )
         QPM_MemoWrit( RUN_FILE, US_ShortName(PUB_cQPM_Folder) + DEF_SLASH + 'US_SHELL.EXE QPM ANALIZE_LIB_BORLAND ' + US_ShortName( ModName ) + '.Tmp' + ' -FILESTOP ' + LOC_RunWaitFileStop + ' > "' + US_ShortName( ModName ) + '.TmpOut"' )
         QPM_LogFile( RUN_FILE )
         QPM_Execute( RUN_FILE, "", DEF_QPM_EXEC_WAIT, DEF_QPM_EXEC_MINIMIZE, LOC_RunWaitFileStop )
         FErase( RUN_FILE )
      CASE TempLibType == 'NONE'
         QPM_LogText( 'File not found' )
         QPM_MemoWrit( ModName + '.TmpOut', 'File not found' )
      OTHERWISE
         QPM_LogText( 'Unknown LIB type: ' + ModName )
         QPM_MemoWrit( ModName + '.TmpOut', 'Unknown LIB type: ' + ModName )
      ENDCASE
   ELSEIF Upper( US_FileNameOnlyExt( ModName ) ) == 'A'
      QPM_MemoWrit( RUN_FILE, US_ShortName(PUB_cQPM_Folder) + DEF_SLASH + 'US_OBJDUMP.EXE -t -s ' + US_ShortName( ModName ) + ' > "' + US_ShortName( ModName ) + '.Tmp"' )
      QPM_LogFile( RUN_FILE )
      QPM_Execute( RUN_FILE, "", DEF_QPM_EXEC_WAIT, DEF_QPM_EXEC_MINIMIZE )
      FErase( RUN_FILE )
      QPM_MemoWrit( RUN_FILE, US_ShortName(PUB_cQPM_Folder) + DEF_SLASH + 'US_SHELL.EXE QPM ANALIZE_LIB_MINGW ' + US_ShortName( ModName ) + '.Tmp' + ' -FILESTOP ' + LOC_RunWaitFileStop + ' > "' + US_ShortName( ModName ) + '.TmpOut"' )
      QPM_LogFile( RUN_FILE )
      QPM_Execute( RUN_FILE, "", DEF_QPM_EXEC_WAIT, DEF_QPM_EXEC_MINIMIZE, LOC_RunWaitFileStop )
      FErase( RUN_FILE )
   ELSEIF Upper( US_FileNameOnlyExt( ModName ) ) == 'DLL'
      QPM_LogText( US_ShortName(PUB_cQPM_Folder) + DEF_SLASH + 'US_IMPDEF.EXE' + US_ShortName( ModName ) + '.Tmp ' + US_ShortName( ModName ) )
      QPM_Execute( US_ShortName(PUB_cQPM_Folder) + DEF_SLASH + 'US_IMPDEF.EXE', US_ShortName( ModName ) + '.Tmp ' + US_ShortName( ModName ), DEF_QPM_EXEC_WAIT, DEF_QPM_EXEC_MINIMIZE )
      QPM_MemoWrit( RUN_FILE, US_ShortName(PUB_cQPM_Folder) + DEF_SLASH + 'US_SHELL.EXE QPM' + LISTOLOG + 'ANALIZE_DLL ' + US_ShortName( ModName ) + '.Tmp' + ' -FILESTOP ' + LOC_RunWaitFileStop + ' > "' + US_ShortName( ModName ) + '.TmpOut"' )
      QPM_LogFile( RUN_FILE )
      QPM_Execute( RUN_FILE, "", DEF_QPM_EXEC_WAIT, DEF_QPM_EXEC_MINIMIZE, LOC_RunWaitFileStop )
      FErase( RUN_FILE )
   ELSEIF Upper( US_FileNameOnlyExt( ModName ) ) == 'EXE'
      TempExeType := QPM_ModuleType( ModName )
      QPM_LogText( TempExeType )
      IF TempExeType == 'COMPRESSED'
         QPM_LogText( ModName )
         ListModuleUnUpx( US_ShortName( ModName ), US_ShortName( ModName ) + '.UnUpx.Exe' )
         ModName := US_Shortname( ModName ) + '.UnUpx.Exe'
         TempExeType := QPM_ModuleType( ModName )
         QPM_LogText( TempExeType )
      ENDIF
      DO CASE
      CASE TempExeType == 'BORLAND'
         QPM_MemoWrit( RUN_FILE, US_ShortName(PUB_cQPM_Folder) + DEF_SLASH + 'US_TDUMP.EXE ' + US_ShortName( ModName ) + ' > "' + US_ShortName( ModName ) + '.TmpOut"' )
         QPM_LogFile( RUN_FILE )
         QPM_Execute( RUN_FILE, "", DEF_QPM_EXEC_WAIT, DEF_QPM_EXEC_MINIMIZE )
         FErase( RUN_FILE )
      CASE TempExeType == 'PELLES'
         QPM_MemoWrit( RUN_FILE, US_ShortName(PUB_cQPM_Folder) + DEF_SLASH + 'US_TDUMP.EXE ' + US_ShortName( ModName ) + ' > "' + US_ShortName( ModName ) + '.TmpOut"' )
         QPM_LogFile( RUN_FILE )
         QPM_Execute( RUN_FILE, "", DEF_QPM_EXEC_WAIT, DEF_QPM_EXEC_MINIMIZE )
         FErase( RUN_FILE )
      CASE TempExeType == 'MINGW'
         QPM_MemoWrit( RUN_FILE, US_ShortName(PUB_cQPM_Folder) + DEF_SLASH + 'US_TDUMP.EXE ' + US_ShortName( ModName ) + ' > "' + US_ShortName( ModName ) + '.TmpOut"' )
         QPM_LogFile( RUN_FILE )
         QPM_Execute( RUN_FILE, "", DEF_QPM_EXEC_WAIT, DEF_QPM_EXEC_MINIMIZE )
         FErase( RUN_FILE )
      CASE TempExeType == 'NONE'
         QPM_MemoWrit( ModName + '.TmpOut', 'File not found' )
      OTHERWISE
         QPM_LogText( 'Unknown EXE type: ' + OrigModName )
         QPM_MemoWrit( ModName + '.TmpOut', 'Unknown EXE type: ' + OrigModName )
      ENDCASE
   ELSE
      QPM_LogText( 'Unsupported file type: ' + Upper( US_FileNameOnlyExt( ModName ) ) )
      QPM_MemoWrit( ModName + '.TmpOut', 'Unsupported file type: ' + Upper( US_FileNameOnlyExt( ModName ) ) )
   ENDIF
   MemoAux := MemoRead( US_ShortName( ModName ) + '.TmpOut' )
   FErase( US_ShortName( ModName ) + '.Tmp' )
   FErase( US_ShortName( ModName ) + '.TmpOut' )
   FErase( US_ShortName( OrigModName ) + '.TmpOut' )
   FErase( US_ShortName( OrigModName ) + '.UnUpx.Exe' )
RETURN MemoAux

FUNCTION ListModuleUnUpx( cIn, cOut )
   QPM_MemoWrit( RUN_FILE, US_ShortName(PUB_cQPM_Folder) + DEF_SLASH + 'US_UPX.EXE -d -o' + cOut + ' ' + cIn + ' > "' + cIn + '.TmpOut"' )
   QPM_LogFile( RUN_FILE )
   QPM_Execute( RUN_FILE, "", DEF_QPM_EXEC_WAIT, DEF_QPM_EXEC_MINIMIZE )
   FErase( RUN_FILE )
RETURN .T.

FUNCTION LocalSearch( Txt )
   LOCAL cTab, Resultado, CaretAnt
   IF Empty( Txt )
      MyMsgStop( "You must input some text before starting a search!" )
      RETURN .F.
   ENDIF
   AddSearchTxt()
   DO CASE
   CASE VentanaMain.TabFiles.value == nPagePrg
      cTab := 'PRG'
   CASE VentanaMain.TabFiles.value == nPageHea
      cTab := 'HEA'
   CASE VentanaMain.TabFiles.value == nPagePan
      cTab := 'PAN'
   CASE VentanaMain.TabFiles.value == nPageDbf
      cTab := 'DBF'
   CASE VentanaMain.TabFiles.value == nPageLib
      cTab := 'LIB'
   CASE VentanaMain.TabFiles.value == nPageSysOut
      cTab := 'SYSOUT'
   CASE VentanaMain.TabFiles.value == nPageOut
      cTab := 'OUT'
#ifdef QPM_SHG
   CASE VentanaMain.TabFiles.value == nPageHlp
      cTab := 'HLP'
#endif
   OTHERWISE
      RETURN .F.
   ENDCASE
   CaretAnt := GetProperty( 'VentanaMain', 'RichEdit' + cTab, 'CaretPos' )
   bLastGlobalSearchCas := VentanaMain.Check_SearchCas.Value
   Resultado := FindChr( GetControlHandle( 'RichEdit' + cTab, 'VentanaMain' ), Txt, .T., .F., bLastGlobalSearchCas, .T. )
   IF Resultado[3] < 0
      IF CaretAnt == 0
         MyMsgInfo( 'The text was not found.' )
      ELSE
         MyMsgInfo( 'The text was not found.' + CRLF + 'Try again after moving the caret to the top.' )
      ENDIF
      SetProperty( 'VentanaMain', 'RichEdit' + cTab, 'CaretPos', CaretAnt )
      RETURN .F.
   ENDIF
RETURN .T.

FUNCTION DbfDataSearch( Txt )
   LOCAL nRecord := 0, cFieldName := '', nFieldPos := 0, cFieldTxt := ''
   LOCAL nOldValue := VentanaMain.GDbfFiles.Value
   LOCAL nOldRecord
   LOCAL nAuxRecord
   LOCAL cTypeDbfSearch := 'R'  /* Record Base Type */
   IF VentanaMain.GDbfFiles.Value < 1
      MyMsgStop( 'No DBF file has been selected!' )
      RETURN .F.
   ENDIF
   IF Empty( Txt )
      MyMsgStop( "You must input some text before starting a search!" )
      RETURN .F.
   ENDIF
   nOldRecord := VentanaMain.DbfBrowse.Value
   nAuxRecord := nOldRecord
   AddSearchTxt()
   IF bAvisoDbfDataSearchLow .OR. ! ( Val( US_Word( GetProperty( 'VentanaMain', 'GDbfFiles', 'Cell', VentanaMain.GDbfFiles.Value, NCOLDBFSEARCH ), 1 ) ) == nOldRecord )
      IF ! MyMsgYesNo( "Searching text into DBF data may take a long time to end." + CRLF + "Do you want to continue?" )
         RETURN .F.
      ENDIF
      bAvisoDbfDataSearchLow := .F.
      bDbfDataSearchAsk  := .T.
   ELSE
      IF ! ( bDbfDataSearchAsk )
         cTypeDbfSearch := cDbfDataSearchAskRpta
      ELSE
         SetMGWaitHide()
         IF ( cTypeDbfSearch := LocalSearchContinue() ) == ''
            SetMGWaitShow()
            RETURN .F.
         ELSE
            IF ! ( bDbfDataSearchAsk )
               cDbfDataSearchAskRpta := cTypeDbfSearch
            ENDIF
         ENDIF
         SetMGWaitShow()
      ENDIF
      IF cTypeDbfSearch == 'R'
         nAuxRecord++
      ENDIF
   ENDIF
   VentanaMain.RichEditDbf.BackColor := DEF_COLORBACKDBFSEARCHOK
   IF GlobalSearch2( 'DBF', Txt, VentanaMain.GDbfFiles.Value, NIL, .T., cTypeDbfSearch, nAuxRecord, @nRecord, @cFieldName, @nFieldPos, @cFieldTxt )
      DBSelectarea( 'DbfAlias' )
      VentanaMain.DbfBrowse.Value := nRecord
      VentanaMain.DbfBrowse.Refresh()
#ifdef __XHARBOUR__
      VentanaMain.RichEditDbf.Value := '     ' + CRLF + ;
                                       '     ' + CRLF + ;
                                       '     Text found at record: ' + AllTrim( Str( nRecord ) ) + CRLF + ;
                                       '     Field: ' + cFieldName + CRLF + ;
                                       '     Position: ' + AllTrim( Str( nFieldPos ) ) + CRLF + ;
                                       '     Content: ' + SubStr( cFieldTxt, At( US_Upper( Txt ), US_Upper( cFieldTxt ), nFieldPos ), 200 ) + CRLF
#else
      VentanaMain.RichEditDbf.Value := '     ' + CRLF + ;
                                       '     ' + CRLF + ;
                                       '     Text found at record: ' + AllTrim( Str( nRecord ) ) + CRLF + ;
                                       '     Field: ' + cFieldName + CRLF + ;
                                       '     Position: ' + AllTrim( Str( nFieldPos ) ) + CRLF + ;
                                       '     Content: ' + SubStr( cFieldTxt, hb_At( US_Upper( Txt ), US_Upper( cFieldTxt ), nFieldPos ), 200 ) + CRLF
#endif

      VentanaMain.RichEditDbf.CaretPos := 1
      FindChr( GetControlHandle ( 'RichEditDbf', 'VentanaMain' ), VentanaMain.CSearch.DisplayValue, FindChr( GetControlHandle ( 'RichEditDbf', 'VentanaMain' ), 'Content: ', .T., .F., bLastGlobalSearchCas, .T. ), .F., bLastGlobalSearchCas, .T. )
      SetProperty( 'VentanaMain', 'GDbfFiles', 'Cell', VentanaMain.GDbfFiles.Value, NCOLDBFSEARCH, AllTrim( Str( nRecord ) ) + ' ' + cFieldName + ' ' + AllTrim( Str( nFieldPos ) ) )
      DoMethod( 'VentanaMain', 'GDbfFiles', 'ColumnsAutoFitH' )
      VentanaMain.BLocalSearchDbf.caption := 'Continue Search'
      VentanaMain.BLocalSearchDbf.Tooltip := "Continue searching DBF's data. To reset use " + DBLQT + "(Re)Display DBF"  + DBLQT + " button."
      RETURN .T.
   ENDIF
   SetMGWaitHide()
   IF nOldRecord == 1
      MyMsgWarn( 'Text not found.' )
      bAvisoDbfDataSearchLow := .T.
      VentanaMain.RichEditDbf.Value := '     ' + CRLF + ;
                                       "     The text was not found into DBF's data."
   ELSE
      MyMsgWarn( 'Text not found.' + CRLF + 'Try starting the search from the top record.' )
      VentanaMain.RichEditDbf.Value := '     ' + CRLF + ;
                                       "     The text was not found into DBF's data while searching from record " + AllTrim( Str( nOldRecord ) ) + " to EOF." + CRLF + ;
                                       '     Try starting the search from the top record.'
   ENDIF
   VentanaMain.DbfBrowse.Value := nOldRecord
   bDbfDataSearchAsk     := .T.
   cDbfDataSearchAskRpta := ''
   VentanaMain.BLocalSearchDbf.caption := 'DBF Search'
   VentanaMain.BLocalSearchDbf.Tooltip := "Search DBF's data for some text."
   VentanaMain.GDbfFiles.Value := nOldValue
   DoMethod( 'VentanaMain', 'GDbfFiles', 'ColumnsAutoFitH' )
RETURN .F.

FUNCTION GlobalSearch( Txt )
   LOCAL i, lCont, nFound, bSearchDbfData
   IF Empty( Txt )
      MyMsgStop( "You must input some text before starting a search!" )
      RETURN .F.
   ENDIF
   ResetImgGrid( '*' )
   bGlobalSearch        := .T.
   cLastGlobalSearch    := Txt
   bLastGlobalSearchFun := VentanaMain.Check_SearchFun.value
   bLastGlobalSearchDbf := VentanaMain.Check_SearchDbf.value
   bLastGlobalSearchCas := VentanaMain.Check_SearchCas.value
   bSearchDbfData       := bLastGlobalSearchDbf
   VentanaMain.Check_SearchFun.enabled := .F.
   VentanaMain.Check_SearchDbf.enabled := .F.
   VentanaMain.Check_SearchCas.enabled := .F.
   VentanaMain.BGlobalReset.enabled    := .T.
   VentanaMain.LGlobal.visible         := .T.

   IF bLastGlobalSearchFun
      nFound := 0
      TotCaption( 'PRG', 0 )
      FOR i := 1 TO VentanaMain.GPrgFiles.ItemCount
         IF GlobalSearch2( 'PRG', Txt, i, .T. )
            nFound++
         ENDIF
      NEXT i
      TotCaption( 'PRG', nFound )
      RETURN .T.
   ELSE
      nFound := 0
      TotCaption( 'PRG', 0 )
      FOR i := 1 TO VentanaMain.GPrgFiles.ItemCount
         IF GlobalSearch2( 'PRG', Txt, i )
            nFound++
         ENDIF
      NEXT i
      TotCaption( 'PRG', nFound )
   ENDIF

   nFound := 0
   TotCaption( 'HEA', 0 )
   FOR i := 1 TO VentanaMain.GHeaFiles.ItemCount
      IF GlobalSearch2( 'HEA', Txt, i )
         nFound++
      ENDIF
   NEXT i
   TotCaption( 'HEA', nFound )

   nFound := 0
   TotCaption( 'PAN', 0 )
   FOR i := 1 TO VentanaMain.GPanFiles.ItemCount
      IF GlobalSearch2( 'PAN', Txt, i )
         nFound++
      ENDIF
   NEXT i
   TotCaption( 'PAN', nFound )

   nFound := 0
   TotCaption( 'DBF', 0 )
   IF bSearchDbfData
      IF Prj_Warn_DBF_Search
         lCont := MyMsgYesNo( "Global Search into DBF data may be a very slow process." + CRLF + ;
                              'Select [Yes] to continue or [No] to cancel the search.' )
         IF MyMsgYesNo( 'Omit the previous validation from now on?' + CRLF + iif( lCont, "[Yes] will be assumed!", "[No] will be assumed!" ) )
            Prj_Warn_DBF_Search := .F.
            Prj_Warn_DBF_Search_Cont := lCont
            MyMsgInfo( 'Use ' + DBLQT + PUB_MenuResetWarnings + DBLQT + ' option of Settings menu to enable the previous check.' )
         ELSE
            Prj_Warn_DBF_Search := .T.
         ENDIF
      ELSE
         lCont := Prj_Warn_DBF_Search_Cont
      ENDIF
      IF ! lCont
         VentanaMain.Check_SearchDbf.value := .F.
         bLastGlobalSearchDbf := .F.
         RETURN .F.
      ENDIF
   ENDIF
   FOR i := 1 TO VentanaMain.GDbfFiles.ItemCount
      IF GlobalSearch2( 'DBF', Txt, i,, bSearchDbfData )
         nFound++
      ENDIF
   NEXT i
   TotCaption( 'DBF', nFound )
   VentanaMain.Check_SearchDbf.value := bSearchDbfData

   nFound := 0
   TotCaption( 'LIB', 0 )
   FOR i := 1 TO VentanaMain.GIncFiles.ItemCount
      IF GlobalSearch2( 'LIB', Txt, i )
         nFound++
      ENDIF
   NEXT i
   TotCaption( 'LIB', nFound )

   nFound := 0
   TotCaption( 'HLP', 0 )
   IF SHG_BaseOk
      IF ! MyMsgYesNo( 'Skip search of Help Topics?', NIL, .T. )
         FOR i := 1 TO VentanaMain.GHlpFiles.ItemCount
            IF GlobalSearch2( 'HLP', Txt, i )
               nFound++
            ENDIF
         NEXT i
         TotCaption( 'HLP', nFound )
      ENDIF
   ENDIF

   QPM_CheckFiles()
RETURN .T.

FUNCTION GlobalSearch2( cType, Txt, nRow, bFunc, bDbfData, DBFcBaseType, nRecordBase, nRecordFound, cFieldNameFound, nFieldPosFound, cFieldTxtFound )
   LOCAL Pos, MemoAux, x, LineAux, nWord, vAux, nPosition
   LOCAL bSalir, nPosAux
   LOCAL bFound := .F., bChangeImg
   LOCAL aStru, DbfName, DbfCode
   LOCAL cFieldBase, nPosBase, columnValid
   DEFAULT bFunc        TO .F.
   DEFAULT bDbfData     TO .F.
   DEFAULT DBFcBaseType TO 'R' /* R : Record, F : Filed, P : Position */
   DEFAULT nRecordBase  TO 1
   SetMGWaitTxt( 'Searching: ' + ChgPathToReal( GetProperty( 'VentanaMain', 'G' + iif( cType == 'LIB', 'INC', cType ) + 'Files', 'Cell', nRow, &( 'nCol'+cType+iif(cType=='HLP','Topic','FullName') ) ) ) )
   IF bGlobalSearch
      bChangeImg := .T.
   ELSE
      bChangeImg := .F.
   ENDIF
   nFieldPosFound := 0
   IF bFunc .AND. ( Prj_Radio_OutputType == DEF_RG_EXE .OR. Prj_Radio_OutputType == DEF_RG_LIB )
      VentanaMain.Check_SearchCas.Value := bLastGlobalSearchCas := .F.
      IF bChangeImg
         GridImage( 'VentanaMain', 'GPrgFiles', nRow, NCOLPRGSTATUS, '-', PUB_nGridImgSearchOk )
      ENDIF
      MemoAux := US_Upper( MemoRead( ChgPathToReal( GetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', nRow, NCOLPRGFULLNAME ) ) ) )
      bSalir := .F.
      nPosition := 1

#IFDEF __XHARBOUR__
      DO WHILE ( Pos := At( US_Upper( Txt ), MemoAux, nPosition ) ) > 0 .AND. !bSalir
#ELSE
      DO WHILE ( Pos := hb_At( US_Upper( Txt ), MemoAux, nPosition ) ) > 0 .AND. !bSalir
#endif
         nPosition := Pos + 1
         vAux := MPOSTOLC( MemoAux, 254, Pos )
         LineAux := MemoLine( MemoAux, 254, vAux[1] )
         IF At( US_Upper( Txt ), LineAux ) > 0 .AND. ;
            ( At( 'PROCEDURE',   LineAux ) > 0 .OR. ;
              At( 'PROC',        LineAux ) > 0 .OR. ;
              At( 'FUNCTION',    LineAux ) > 0 .OR. ;
              At( 'FUNC',        LineAux ) > 0 .OR. ;
              At( 'METHOD',      LineAux ) > 0 .OR. ;
              At( 'METH',        LineAux ) > 0 )
            IF US_Word( LineAux, 1 ) == 'STATIC'
               nWord := 2
            ELSE
               nWord := 1
            ENDIF
            IF ( ( US_Word( LineAux, nWord ) == 'PROCEDURE' ) .OR. ;
                 ( US_Word( LineAux, nWord ) == 'PROC' ) .OR. ;
                 ( US_Word( LineAux, nWord ) == 'FUNCTION' ) .OR. ;
                 ( US_Word( LineAux, nWord ) == 'FUNC' ) .OR. ;
                 ( US_Word( LineAux, nWord ) == 'METHOD' ) .OR. ;
                 ( US_Word( LineAux, nWord ) == 'METH' ) ) .AND. ;
               ( ( At( US_Upper( Txt ) + '(', SubStr( LineAux, US_WordInd( LineAux, nWord + 1 ) ) ) == 1 ) .OR. ;
                 ( At( US_Upper( Txt ) + ' ', SubStr( LineAux, US_WordInd( LineAux, nWord + 1 ) ) ) == 1 ) )
               IF bChangeImg
                  GridImage( 'VentanaMain', 'GPrgFiles', nRow, NCOLPRGSTATUS, '+', PUB_nGridImgSearchOk )
               ENDIF
               bSalir := .T.
               bFound := .T.
               nFieldPosFound := MLCTOPOS( MemoAux, 254, vAux[1], US_WordInd( LineAux, nWord + 1 ) )       // - vAux[1]
            // nFieldPosFound := MLCTOPOS( MemoRead( ChgPathToReal( GetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', nRow, NCOLPRGFULLNAME ) ) ), 254, vAux[1], US_WordInd( LineAux, nWord + 1 ) ) // - vAux[1]
            ENDIF
         ENDIF
      ENDDO
   ELSE
      DO CASE
      CASE cType == 'PRG'
         IF bLastGlobalSearchCas
            IF Prj_Radio_OutputType == DEF_RG_IMPORT
               nPosAux := At( Txt, GetProperty( 'VentanaMain', 'RichEditPRG', 'value' ) )
            ELSE
               nPosAux := At( Txt, MemoRead( ChgPathToReal( GetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', nRow, NCOLPRGFULLNAME ) ) ) )
            ENDIF
         ELSE
            IF Prj_Radio_OutputType == DEF_RG_IMPORT
               nPosAux := At( US_Upper( Txt ), US_Upper( GetProperty( 'VentanaMain', 'RichEditPRG', 'value' ) ) )
            ELSE
               nPosAux := At( US_Upper( Txt ), US_Upper( MemoRead( ChgPathToReal( GetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', nRow, NCOLPRGFULLNAME ) ) ) ) )
            ENDIF
         ENDIF
         IF nPosAux > 0
            IF bChangeImg
               GridImage( 'VentanaMain', 'GPrgFiles', nRow, NCOLPRGSTATUS, '+', PUB_nGridImgSearchOk )
            ENDIF
            bFound := .T.
         ELSE
            IF bChangeImg
               GridImage( 'VentanaMain', 'GPrgFiles', nRow, NCOLPRGSTATUS, '-', PUB_nGridImgSearchOk )
            ENDIF
         ENDIF
      CASE cType == 'HEA'
         IF bLastGlobalSearchCas
            nPosAux := At( Txt, MemoRead( ChgPathToReal( GetProperty( 'VentanaMain', 'GHeaFiles', 'Cell', nRow, NCOLHEAFULLNAME ) ) ) )
         ELSE
            nPosAux := At( US_Upper( Txt ), US_Upper( MemoRead( ChgPathToReal( GetProperty( 'VentanaMain', 'GHeaFiles', 'Cell', nRow, NCOLHEAFULLNAME ) ) ) ) )
         ENDIF
         IF nPosAux > 0
            IF bChangeImg
               GridImage( 'VentanaMain', 'GHeaFiles', nRow, NCOLHEASTATUS, '+', PUB_nGridImgSearchOk )
            ENDIF
            bFound := .T.
         ELSE
            IF bChangeImg
               GridImage( 'VentanaMain', 'GHeaFiles', nRow, NCOLHEASTATUS, '-', PUB_nGridImgSearchOk )
            ENDIF
         ENDIF
      CASE cType == 'PAN'
         IF bLastGlobalSearchCas
            nPosAux := At( Txt, MemoRead( ChgPathToReal( GetProperty( 'VentanaMain', 'GPanFiles', 'Cell', nRow, NCOLPANFULLNAME ) ) ) )
         ELSE
            nPosAux := At( US_Upper( Txt ), US_Upper( MemoRead( ChgPathToReal( GetProperty( 'VentanaMain', 'GPanFiles', 'Cell', nRow, NCOLPANFULLNAME ) ) ) ) )
         ENDIF
         IF nPosAux > 0
            IF bChangeImg
               GridImage( 'VentanaMain', 'GPanFiles', nRow, NCOLPANSTATUS, '+', PUB_nGridImgSearchOk )
            ENDIF
            bFound := .T.
         ELSE
            IF bChangeImg
               GridImage( 'VentanaMain', 'GPanFiles', nRow, NCOLPANSTATUS, '-', PUB_nGridImgSearchOk )
            ENDIF
         ENDIF
      CASE cType == 'DBF'
         DbfName := ChgPathToReal( GetProperty( 'VentanaMain', 'GDbfFiles', 'Cell', nRow, NCOLDBFFULLNAME ) )
         DbfCode := US_IsDBF( DbfName )
         IF DbfCode == 0
            US_Use( .T.,, DbfName, 'DSearch', DEF_DBF_SHARED, DEF_DBF_READ ) /* si pongo exclusive y write no funciona el search, revisarlo */
            aStru := DBSTRUCT()
            IF ! bDbfData
               VentanaMain.Check_SearchCas.Value := bLastGlobalSearchCas := .F.
               FOR x := 1 TO Len( aStru )
                  IF At( US_Upper( Txt ), aStru[x][1] ) > 0
                     bFound := .T.
                     EXIT
                  ENDIF
               NEXT x
            ELSE
               cFieldBase  := ''
               IF DBFcBaseType == 'F'   /* Field base type */
                  cFieldBase  := US_Word( GetProperty( 'VentanaMain', 'GDbfFiles', 'Cell', nRow, NCOLDBFSEARCH ), 2 )
               ENDIF
               IF DBFcBaseType == 'P'   /* Position base type */
                  cFieldBase  := US_Word( GetProperty( 'VentanaMain', 'GDbfFiles', 'Cell', nRow, NCOLDBFSEARCH ), 2 )
               ENDIF
               DBGoTo( nRecordBase )
               columnValid := .F.
               IF DBFcBaseType == 'R'  /* Record base type */
                  columnValid := .T.
               ENDIF
               DO WHILE !eof()
                  FOR x:=1 TO Len(aStru)
                     IF DBFcBaseType == 'F' .AND. !columnValid        /* Field base type */
                        IF aStru[x][1] == cFieldBase
                           columnValid := .T.
                           loop
                        ENDIF
                     ENDIF
                     nPosBase := 1
                     IF DBFcBaseType == 'P' .AND. !columnValid        /* Position base type */
                        IF aStru[x][1] == cFieldBase
                           nPosBase := Val( US_Word( GetProperty( 'VentanaMain', 'GDbfFiles', 'Cell', nRow, NCOLDBFSEARCH ), 3 ) ) + 1
                           columnValid := .T.
                        ENDIF
                     ENDIF
                     IF columnValid
                        IF bLastGlobalSearchCas
#IFDEF __XHARBOUR__
                           nPosAux := At( Txt, US_VarToStr( &( aStru[x][1] ) ), nPosBase )
#ELSE
                           nPosAux := hb_At( Txt, US_VarToStr( &( aStru[x][1] ) ), nPosBase )
#endif
                        ELSE
#IFDEF __XHARBOUR__
                           nPosAux := At( US_Upper( Txt ), US_Upper( US_VarToStr( &( aStru[x][1] ) ) ), nPosBase )
#ELSE
                           nPosAux := hb_At( US_Upper( Txt ), US_Upper( US_VarToStr( &( aStru[x][1] ) ) ), nPosBase )
#endif
                        ENDIF
                        IF nPosAux > 0
                           bFound := .T.
                           nRecordFound      := RecNo()
                           cFieldNameFound   := aStru[x][1]
                           nFieldPosFound    := nPosAux
                           cFieldTxtFound    := US_VarToStr( &( aStru[x][1] ) )
                           EXIT
                        ENDIF
                     ENDIF
                  NEXT x
                  IF bFound
                     EXIT
                  ENDIF
                  DBSkip( 1 )
               ENDDO
            ENDIF
            DBCloseArea( 'DSearch' )
         ENDIF
         IF bFound
            IF bChangeImg
               GridImage( 'VentanaMain', 'GDbfFiles', nRow, NCOLDBFSTATUS, '+', PUB_nGridImgSearchOk )
            ENDIF
            bFound := .T.
         ELSE
            IF bChangeImg
               GridImage( 'VentanaMain', 'GDbfFiles', nRow, NCOLDBFSTATUS, '-', PUB_nGridImgSearchOk )
            ENDIF
         ENDIF
      CASE cType == 'LIB'
         IF bLastGlobalSearchCas
            nPosAux := At( Txt, MemoRead( ChgPathToReal( GetProperty( 'VentanaMain', 'GIncFiles', 'Cell', nRow, NCOLINCFULLNAME ) ) ) )
         ELSE
            nPosAux := At( US_Upper( Txt ), US_Upper( MemoRead( ChgPathToReal( GetProperty( 'VentanaMain', 'GIncFiles', 'Cell', nRow, NCOLINCFULLNAME ) ) ) ) )
         ENDIF
         IF nPosAux > 0
            IF bChangeImg
               GridImage( 'VentanaMain', 'GIncFiles', nRow, NCOLINCSTATUS, '+', PUB_nGridImgSearchOk )
            ENDIF
            bFound := .T.
         ELSE
            IF bChangeImg
               GridImage( 'VentanaMain', 'GIncFiles', nRow, NCOLINCSTATUS, '-', PUB_nGridImgSearchOk )
            ENDIF
         ENDIF
#ifdef QPM_SHG
      CASE cType == 'HLP'
         IF bLastGlobalSearchCas
            nPosAux := At( Txt, US_RTF2TXT( SHG_GetField( 'SHG_MEMOT', nRow ) ) )
         ELSE
            nPosAux := At( US_Upper( Txt ), US_Upper( US_RTF2TXT( SHG_GetField( 'SHG_MEMOT', nRow ) ) ) )
         ENDIF
         IF nPosAux > 0
            IF bChangeImg
               GridImage( 'VentanaMain', 'GHlpFiles', nRow, NCOLHLPSTATUS, '+', PUB_nGridImgSearchOk )
            ENDIF
            bFound := .T.
         ELSE
            IF bChangeImg
               GridImage( 'VentanaMain', 'GHlpFiles', nRow, NCOLHLPSTATUS, '-', PUB_nGridImgSearchOk )
            ENDIF
         ENDIF
#endif
   ENDCASE
ENDIF
RETURN bFound

FUNCTION ResetImgGrid( cGrid )
   LOCAL i
   IF Empty( cGrid )
      cGrid := '*'
   ENDIF
   VentanaMain.BGlobalReset.enabled    := .F.
   VentanaMain.Check_SearchFun.enabled := .T.
   VentanaMain.Check_SearchDbf.enabled := .T.
   VentanaMain.Check_SearchCas.enabled := .T.
   VentanaMain.LGlobal.visible         := .F.
   bGlobalSearch         := .F.
   bLastGlobalSearchDbf  := .F.
   IF cGrid == 'PRG' .OR. cGrid == '*'
      FOR i := 1 TO VentanaMain.GPrgFiles.ItemCount
         IF GridImage( 'VentanaMain', 'GPrgFiles', i, NCOLPRGSTATUS, '?', PUB_nGridImgSearchOk )
            GridImage( 'VentanaMain', 'GPrgFiles', i, NCOLPRGSTATUS, '-', PUB_nGridImgSearchOk )
         ENDIF
      NEXT i
      VentanaMain.TabGrids.Caption( 1 ) := PagePRG
   ENDIF

   IF cGrid == 'HEA' .OR. cGrid == '*'
      FOR i := 1 TO VentanaMain.GHeaFiles.ItemCount
         IF GridImage( 'VentanaMain', 'GHeaFiles', i, NCOLHEASTATUS, '?', PUB_nGridImgSearchOk )
            GridImage( 'VentanaMain', 'GHeaFiles', i, NCOLHEASTATUS, '-', PUB_nGridImgSearchOk )
         ENDIF
      NEXT i
      VentanaMain.TabGrids.Caption( 2 ) := PageHEA
   ENDIF

   IF cGrid == 'PAN' .OR. cGrid == '*'
      FOR i := 1 TO VentanaMain.GPanFiles.ItemCount
         IF GridImage( 'VentanaMain', 'GPanFiles', i, NCOLPANSTATUS, '?', PUB_nGridImgSearchOk )
            GridImage( 'VentanaMain', 'GPanFiles', i, NCOLPANSTATUS, '-', PUB_nGridImgSearchOk )
         ENDIF
      NEXT i
      VentanaMain.TabGrids.Caption( 3 ) := PagePAN
   ENDIF

   IF cGrid == 'DBF' .OR. cGrid == '*'
      FOR i := 1 TO VentanaMain.GDbfFiles.ItemCount
         IF GridImage( 'VentanaMain', 'GDbfFiles', i, NCOLDBFSTATUS, '?', PUB_nGridImgSearchOk )
            GridImage( 'VentanaMain', 'GDbfFiles', i, NCOLDBFSTATUS, '-', PUB_nGridImgSearchOk )
         ENDIF
         SetProperty( 'VentanaMain', 'GDbfFiles', 'Cell', i, NCOLDBFSEARCH, '0 ** 0' )
      NEXT i
      VentanaMain.TabGrids.Caption( 4 ) := PageDBF
      VentanaMain.BLocalSearchDbf.caption := 'DBF Search'
      VentanaMain.BLocalSearchDbf.Tooltip := "Search DBF's data for some text."
      VentanaMain.RichEditDbf.BackColor := DEF_COLORBACKDBF
      QPM_Wait( "RichEditDisplay( 'DBF', .F. )", 'Loading ...' )
   ENDIF

   IF cGrid == 'LIB' .OR. cGrid == '*'
      FOR i := 1 TO VentanaMain.GIncFiles.ItemCount
         IF GridImage( 'VentanaMain', 'GIncFiles', i, NCOLINCSTATUS, '?', PUB_nGridImgSearchOk )
            GridImage( 'VentanaMain', 'GIncFiles', i, NCOLINCSTATUS, '-', PUB_nGridImgSearchOk )
         ENDIF
      NEXT i
      VentanaMain.TabGrids.Caption( 5 ) := PageLIB
   ENDIF

   IF cGrid == 'HLP' .OR. cGrid == '*'
      FOR i := 1 TO VentanaMain.GHlpFiles.ItemCount
         IF GridImage( 'VentanaMain', 'GHlpFiles', i, NCOLHLPSTATUS, '?', PUB_nGridImgSearchOk )
            GridImage( 'VentanaMain', 'GHlpFiles', i, NCOLHLPSTATUS, '-', PUB_nGridImgSearchOk )
         ENDIF
      NEXT i
      VentanaMain.TabGrids.Caption( 6 ) := PageHlp
   ENDIF
RETURN .T.

FUNCTION GridImage( cWin, cGrid, nRow, nCol, cOper, nBitImage )
   LOCAL nBits  := 256   // ( 2 ** PUB_nGridImgTop ) // ej: 9 imagenes primarias equivale a 256 ( PUB_nGridImgTilde, PUB_nGridImgEquis, etc )
   LOCAL i, cString, nAux
   LOCAL vImagesTranslateGrid := { {   0,   0 }, ;              // 0        0            0000 0000
                                   {   1,   1 }, ;              // 1        1            0000 0001
                                   {   2,   2 }, ;              // 2        2            0000 0010
                                   {   3,   3 }, ;              // 3        3            0000 0011
                                   {   4,   4 }, ;              // 4        4            0000 0100
                                   {   5,   5 }, ;              // 5        5            0000 0101
                                   {   6,   6 }, ;              // 6        6            0000 0110
                                   {   7,   7 }, ;              // 7        7            0000 0111
                                   {   8,   8 }, ;              // 8        8            0000 1000
                                   {   9,   9 }, ;              // 9        9            0000 1001
                                   {  10,  10 }, ;              // 10      10            0000 1010
                                   {  11,  11 }, ;              // 11      11            0000 1011
                                   {  12,  12 }, ;              // 12      12            0000 1100
                                   {  13,  13 }, ;              // 13      13            0000 1101
                                   {  14,  14 }, ;              // 14      14            0000 1110
                                   {  15,  15 }, ;              // 15      15            0000 1111
                                   {  16,  16 }, ;              // 16      16            0001 0000
                                   {  32,  17 }, ;              // 17      32            0010 0000
                                   {  36,  18 }, ;              // 18      36            0010 0100
                                   {  64,  19 }, ;              // 19      64            0100 0000
                                   {  68,  20 }, ;              // 20      68            0100 0100
                                   { 128,  21 }, ;              // 21     128            1000 0000
                                   { 132,  22 }, ;              // 22     132            1000 0100
                                   { 256,  23 }, ;              // 23     256          1 0000 0000
                                   { 260,  24 } }               // 24     260          1 0000 0100
   IF nRow < 1
      RETURN .F.
   ENDIF
   IF ( nAux := AScan( vImagesTranslateGrid, { |x| x[2] == GetProperty( cWin, cGrid, 'Cell', nRow, nCol ) } ) ) == 0
      MyMsgStop( 'First scan failed at function GridImage for value: ' + US_VarToStr( GetProperty( cWin, cGrid, 'Cell', nRow, nCol ) ) + CRLF + ;
                  "Please report this error to QPM's Support List." + CRLF + ;
                  'Thank you.' )
      RETURN .F.
   ENDIF
   cString := NTOC( vImagesTranslateGrid[ nAux ][ 1 ], 2, nBits, '0' )
   FOR i := 1 TO Len( cOper )
      DO CASE
      CASE SubStr( cOper, i, 1 ) == '?'              /* preguntar si esta activo */
         IF SubStr( cString, nBits - nBitImage + 1, 1 ) == '1'
            RETURN .T.
         ELSE
            RETURN .F.
         ENDIF
      CASE SubStr( cOper, i, 1 ) == '+'              /* agregarle */
         cString := SubStr( cString, 1, nBits - nBitImage ) + '1' + SubStr( cString, nBits - nBitImage + 2 )
      CASE SubStr( cOper, i, 1 ) == '-'              /* sacarle */
         cString := SubStr( cString, 1, nBits - nBitImage ) + '0' + SubStr( cString, nBits - nBitImage + 2 )
      CASE US_Upper( SubStr( cOper, i, 1 ) ) == 'X'     /* limpiar */
         cString := strtran( cString, '1', '0' )
//    CASE US_Upper( SubStr( cOper, i, 1 ) ) == '='     /* setear  */
//       cString := strtran( cString, '1', '0' )
//       cString := SubStr( cString, 1, nBits - nBitImage ) + '1' + SubStr( cString, nBits - nBitImage + 2 )
      OTHERWISE
         MyMsgStop( 'Unexpected operator ' + US_Upper( SubStr( cOper, i, 1 ) ) + ' at function GridImage for value: ' + US_VarToStr( GetProperty( cWin, cGrid, 'Cell', nRow, nCol ) ) + CRLF + ;
                     "Please report this error to QPM's Support List." + CRLF + ;
                     'Thank you.' )
         RETURN .F.
      ENDCASE
   NEXT i
   IF ( nAux := AScan( vImagesTranslateGrid, { |x| x[1] == CToN( cString, 2 ) } ) ) == 0
      MyMsgStop( 'Last scan failed at function GridImage for value: ' + US_VarToStr( CTON( cString, 2 ) ) + CRLF + ;
                  "Please report this error to QPM's Support List." + CRLF + ;
                  'Thank you.' )
      RETURN .F.
   ENDIF
   SetProperty( cWin, cGrid, 'Cell', nRow, nCol, vImagesTranslateGrid[ nAux ][ 2 ] )
RETURN .T.

FUNCTION AddSearchTxt()
   LOCAL Aux, cValor, i
   cValor:=VentanaMain.CSearch.DisplayValue
   IF ! Empty( AllTrim(cValor)) .AND. !AddSearchTxtFound(cValor)
      IF VentanaMain.CSearch.ItemCount < 15
         VentanaMain.CSearch.AddItem('*')
      ENDIF
      Aux:=VentanaMain.CSearch.ItemCount
      FOR i := (Aux - 1) TO 1 step -1
         VentanaMain.CSearch.Item((i+1)):=VentanaMain.CSearch.Item(i)
      NEXT
      VentanaMain.CSearch.Item(1):=cValor
      VentanaMain.CSearch.Value:=1
   ENDIF
RETURN .T.

FUNCTION AddSearchTxtFound(email)
   LOCAL i
   FOR i := 1 TO VentanaMain.CSearch.ItemCount
       IF bLastGlobalSearchCas
          IF email == VentanaMain.CSearch.Item(i)
             RETURN .T.
          ENDIF
       ELSE
          IF US_Upper(email) == US_Upper(VentanaMain.CSearch.Item(i))
             RETURN .T.
          ENDIF
       ENDIF
   NEXT
RETURN .F.

FUNCTION LostRichEdit( tipo, nRecord )
   LOCAL cAuxMemo
   DO CASE
      CASE tipo == 'PRG'
         IF bPpoDisplayado
            SetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', nGridPrgLastRow, NCOLPRGOFFSET, cPpoCaretPrg )
         ELSE
            SetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', nGridPrgLastRow, NCOLPRGOFFSET, AllTrim( Str( VentanaMain.RichEditPRG.CaretPos ) ) )
         ENDIF
         DoMethod( 'VentanaMain', 'GPrgFiles', 'ColumnsAutoFitH' )
      CASE tipo == 'HEA'
         SetProperty( 'VentanaMain', 'GHeaFiles', 'Cell', nGridHeaLastRow, NCOLHEAOFFSET, AllTrim( Str( VentanaMain.RichEditHea.CaretPos ) ) )
         DoMethod( 'VentanaMain', 'GHeaFiles', 'ColumnsAutoFitH' )
      CASE tipo == 'PAN'
         SetProperty( 'VentanaMain', 'GPanFiles', 'Cell', nGridPanLastRow, NCOLPANOFFSET, AllTrim( Str( VentanaMain.RichEditPan.CaretPos ) ) )
         DoMethod( 'VentanaMain', 'GPanFiles', 'ColumnsAutoFitH' )
      CASE tipo == 'DBF'
         SetProperty( 'VentanaMain', 'GDbfFiles', 'Cell', nGridDbfLastRow, NCOLDBFOFFSET, AllTrim( Str( VentanaMain.RichEditDbf.CaretPos ) ) + ' ' + AllTrim( Str( nRecord ) ) )
         DoMethod( 'VentanaMain', 'GDbfFiles', 'ColumnsAutoFitH' )
#ifdef QPM_SHG
      CASE tipo == 'HLP'
         IF nRecord > 0
            SetProperty( 'VentanaMain', 'GHlpFiles', 'Cell', nGridHlpLastRow, NCOLHLPOFFSET, AllTrim( Str( VentanaMain.RichEditHlp.CaretPos ) ) )
            cAuxMemo := US_GetRichEditValue( 'VentanaMain', 'RichEditHlp', 'RTF' )
*            SHG_LimpioRtf( @cAuxMemo )
            SHG_SetField( 'SHG_MEMOT', nRecord, cAuxMemo )

/*
            IF ! ( SHG_GetField( 'SHG_TYPE', nRecord ) == SHG_GetField( 'SHG_TYPET', nRecord ) ) .OR. ;
               ! ( SHG_GetField( 'SHG_TOPIC', nRecord ) == SHG_GetField( 'SHG_TOPICT', nRecord ) ) .OR. ;
               ! ( SHG_GetField( 'SHG_NICK', nRecord ) == SHG_GetField( 'SHG_NICKT', nRecord ) ) .OR. ;
               ! ( cAuxMemo == SHG_GetField( 'SHG_MEMO', nRecord ) ) .OR. ;
               ! ( SHG_GetField( 'SHG_KEYS', nRecord ) == SHG_GetField( 'SHG_KEYST', nRecord ) )
               SetProperty( 'VentanaMain', 'GHlpFiles', 'Cell', nGridHlpLastRow, NCOLHLPEDIT, 'D' )
            ENDIF
*/
            IF ! ( SHG_GetField( 'SHG_TYPE', nRecord ) == SHG_GetField( 'SHG_TYPET', nRecord ) ) .OR. ;
               ! ( SHG_GetField( 'SHG_TOPIC', nRecord ) == SHG_GetField( 'SHG_TOPICT', nRecord ) ) .OR. ;
               ! ( SHG_GetField( 'SHG_NICK', nRecord ) == SHG_GetField( 'SHG_NICKT', nRecord ) ) .OR. ;
               oHlpRichEdit:lChanged .OR. ;
               ! ( SHG_GetField( 'SHG_KEYS', nRecord ) == SHG_GetField( 'SHG_KEYST', nRecord ) )

               SetProperty( 'VentanaMain', 'GHlpFiles', 'Cell', nGridHlpLastRow, NCOLHLPEDIT, 'D' )
               oHlpRichEdit:lChanged := .F.
            ENDIF
            DoMethod( 'VentanaMain', 'GHlpFiles', 'ColumnsAutoFitH' )
         ENDIF
#endif
   ENDCASE
RETURN .T.

FUNCTION FormQuickView()
   LOCAL cCng := PUB_cProjectFolder + DEF_SLASH + '_' + PUB_cSecu + 'RunViewForm.cng'
   LOCAL cBat := PUB_cProjectFolder + DEF_SLASH + '_' + PUB_cSecu + 'RunView.bat'
   QPM_LogText( "FormQuickView" )
   QPM_MemoWrit( cCng, ;
                 'PATH ' + US_ShortName( PUB_cProjectFolder ) + CRLF + ;
                 'SECUENCE ' + PUB_cSecu + CRLF + ;
                 'HARBOUR ' + US_ShortName( GetHarbourFolder() ) + DEF_SLASH + 'BIN'+DEF_SLASH+'HARBOUR.EXE' + CRLF + ;
                 'HARBOURINCLUDE ' + US_ShortName( GetHarbourFolder() ) + DEF_SLASH + 'INCLUDE' + CRLF + ;
                 'MINIGUIINCLUDE ' + US_ShortName(GetMiniGuiFolder()) + DEF_SLASH + 'INCLUDE' + CRLF + ;
                 'FORMINCLUDE ' + US_ShortName( US_FileNameOnlyPath( ChgPathToReal( GetProperty( 'VentanaMain', 'GPanFiles', 'Cell', nGridPanLastRow, NCOLPANFULLNAME ) ) ) ) + CRLF + ;
                 'FORM ' + US_FileNameOnlyName( ChgPathToReal( GetProperty( 'VentanaMain', 'GPanFiles', 'Cell', nGridPanLastRow, NCOLPANFULLNAME ) ) ) )
   QPM_LogFile( cCng )
   QPM_MemoWrit( cBat, US_ShortName( PUB_cQPM_Folder ) + DEF_SLASH + 'US_VIEW_' + GetHarbourSuffix() + GetMiniGuiSuffix() + '.EXE ' + cCng )
   QPM_LogFile( cBat )
   QPM_Execute( cBat, NIL, DEF_QPM_EXEC_WAIT, DEF_QPM_EXEC_HIDE )
   FErase( cBat )
RETURN .T.

FUNCTION QPM_Timer_Edit()
   LOCAL i, FechaCnt, FileRC, x
   SetProperty( 'VentanaMain', 'Timer_Edit', 'Enabled', .F. )

   FOR i := 1 TO VentanaMain.GPrgFiles.ItemCount
      x := GetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', i, NCOLPRGEDIT )
      IF ! Empty( x )
         IF ! File( x )
            FechaCnt := Val( Right( US_FileNameOnlyName( x ), 16 ) )
            SetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', i, NCOLPRGEDIT, '' )
            GridImage( 'VentanaMain', 'GPrgFiles', i, NCOLPRGSTATUS, '-', PUB_nGridImgEdited )
            IF FechaCnt < Val( US_FileDateTime( ChgPathToReal( GetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', i, NCOLPRGFULLNAME ) ) ) + '00' )
               QPM_Wait( "RichEditDisplay( 'PRG', .T., " + Str( i ) + ')', 'Reloading ...' )
#ifdef QPM_HOTRECOVERY
               QPM_Wait( "QPM_HotRecovery( 'ADD', 'EDIT', 'SRC', '" + GetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', i, NCOLPRGFULLNAME ) + "', '" + GetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', i, NCOLPRGRECOVERY ) + "' )", 'Creating Version File for Hot Recovery ...' )
               SetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', i, NCOLPRGRECOVERY, '' )
               IF _IsControlDefined( 'HR_GridItemTargetPRG', 'WinHotRecovery' ) .AND. ;
                  i == GetProperty( 'WinHotRecovery', 'HR_GridItemTargetPRG', 'value' )
                  eVal( { || iif( !bPrgSorting .AND. !PUB_bLite, iif( HR_bNumberOnPrg, QPM_Wait( "QPM_HotChangeGrid( 'TARGET', 'ITEM', 'PRG' )", 'Comparing' ), QPM_HotChangeGrid( 'TARGET', 'ITEM', 'PRG' ) ), US_NOP() ) } )
               ENDIF
#endif
            ELSE
               VentanaMain.RichEditPrg.BackColor := DEF_COLORBACKPRG
               VentanaMain.RichEditPrg.FontColor := DEF_COLORFONTVIEW
#ifdef QPM_HOTRECOVERY
               ferase( GetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', i, NCOLPRGRECOVERY ) )
               SetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', i, NCOLPRGRECOVERY, '' )
#endif
            ENDIF
#ifdef QPM_HOTRECOVERY
            IF _IsControlDefined( 'HR_GridItemTargetPRG', 'WinHotRecovery' )
               GridImage( 'WinHotRecovery', 'HR_GridItemTargetPRG', i, DEF_N_ITEM_COLIMAGE, '-', PUB_nGridImgEdited )
            ENDIF
#endif
         ENDIF
      ENDIF
   NEXT i

   FOR i := 1 TO VentanaMain.GHeaFiles.ItemCount
      x := GetProperty( 'VentanaMain', 'GHeaFiles', 'Cell', i, NCOLHEAEDIT )
      IF ! Empty( x )
         IF ! File( x )
            FechaCnt := Val( Right( US_FileNameOnlyName( x ), 16 ) )
            SetProperty( 'VentanaMain', 'GHeaFiles', 'Cell', i, NCOLHEAEDIT, '' )
            GridImage( 'VentanaMain', 'GHeaFiles', i, NCOLHEASTATUS, '-', PUB_nGridImgEdited )
            IF FechaCnt < Val( US_FileDateTime( ChgPathToReal( GetProperty( 'VentanaMain', 'GHeaFiles', 'Cell', i, NCOLHEAFULLNAME ) ) ) + '00' )
               QPM_Wait( "RichEditDisplay( 'HEA', .T., " + Str( i ) + ')', 'Reloading ...' )
#ifdef QPM_HOTRECOVERY
               QPM_Wait( "QPM_HotRecovery( 'ADD', 'EDIT', 'HEA', '" + GetProperty( 'VentanaMain', 'GHeaFiles', 'Cell', i, NCOLHEAFULLNAME ) + "', '" + GetProperty( 'VentanaMain', 'GHeaFiles', 'Cell', i, NCOLHEARECOVERY ) + "' )", 'Creating Version File for Hot Recovery ...' )
               SetProperty( 'VentanaMain', 'GHeaFiles', 'Cell', i, NCOLHEARECOVERY, '' )
               IF _IsControlDefined( 'HR_GridItemTargetHea', 'WinHotRecovery' ) .AND. ;
                  i == GetProperty( 'WinHotRecovery', 'HR_GridItemTargetHea', 'value' )
                  eVal( { || iif( !bHeaSorting .AND. !PUB_bLite, iif( HR_bNumberOnHea, QPM_Wait( "QPM_HotChangeGrid( 'TARGET', 'ITEM', 'HEA' )", 'Comparing' ), QPM_HotChangeGrid( 'TARGET', 'ITEM', 'HEA' ) ), US_NOP() ) } )
               ENDIF
#endif
            ELSE
               VentanaMain.RichEditHea.BackColor := DEF_COLORBACKHEA
               VentanaMain.RichEditHea.FontColor := DEF_COLORFONTVIEW
#ifdef QPM_HOTRECOVERY
               ferase( GetProperty( 'VentanaMain', 'GHeaFiles', 'Cell', i, NCOLHEARECOVERY ) )
               SetProperty( 'VentanaMain', 'GHeaFiles', 'Cell', i, NCOLHEARECOVERY, '' )
#endif
            ENDIF
#ifdef QPM_HOTRECOVERY
            IF _IsControlDefined( 'HR_GridItemTargetHea', 'WinHotRecovery' )
               GridImage( 'WinHotRecovery', 'HR_GridItemTargetHea', i, DEF_N_ITEM_COLIMAGE, '-', PUB_nGridImgEdited )
            ENDIF
#endif
         ENDIF
      ENDIF
   NEXT i

   FOR i := 1 TO VentanaMain.GPanFiles.ItemCount
      x := GetProperty( 'VentanaMain', 'GPanFiles', 'Cell', i, NCOLPANEDIT )
      IF ! Empty( x )
         IF ! File( x )
            FechaCnt := Val( Right( US_FileNameOnlyName( GetProperty( 'VentanaMain', 'GPanFiles', 'Cell', i, NCOLPANEDIT ) ), 16 ) )
            SetProperty( 'VentanaMain', 'GPanFiles', 'Cell', i, NCOLPANEDIT, '' )
            GridImage( 'VentanaMain', 'GPanFiles', i, NCOLPANSTATUS, '-', PUB_nGridImgEdited )
            IF FechaCnt < Val( US_FileDateTime( ChgPathToReal( GetProperty( 'VentanaMain', 'GPanFiles', 'Cell', i, NCOLPANFULLNAME ) ) ) + '00' )
               QPM_Wait( "RichEditDisplay( 'PAN', .T., " + Str( i ) + ')', 'Reloading ...' )
#ifdef QPM_HOTRECOVERY
               QPM_Wait( "QPM_HotRecovery( 'ADD', 'EDIT', 'PAN', '" + GetProperty( 'VentanaMain', 'GPanFiles', 'Cell', i, NCOLPANFULLNAME ) + "', '" + GetProperty( 'VentanaMain', 'GPanFiles', 'Cell', i, NCOLPANRECOVERY ) + "' )", 'Creating Version File for Hot Recovery ...' )
               SetProperty( 'VentanaMain', 'GPanFiles', 'Cell', i, NCOLPANRECOVERY, '' )
               IF _IsControlDefined( 'HR_GridItemTargetPAN', 'WinHotRecovery' ) .AND. ;
                  i == GetProperty( 'WinHotRecovery', 'HR_GridItemTargetPAN', 'value' )
                  eVal( { || iif( !bPanSorting .AND. !PUB_bLite, iif( HR_bNumberOnPan, QPM_Wait( "QPM_HotChangeGrid( 'TARGET', 'ITEM', 'PAN' )", 'Comparing' ), QPM_HotChangeGrid( 'TARGET', 'ITEM', 'PAN' ) ), US_NOP() ) } )
               ENDIF
#endif
            ELSE
               VentanaMain.RichEditPan.BackColor := DEF_COLORBACKPAN
               VentanaMain.RichEditPan.FontColor := DEF_COLORFONTVIEW
#ifdef QPM_HOTRECOVERY
               ferase( GetProperty( 'VentanaMain', 'GPanFiles', 'Cell', i, NCOLPANRECOVERY ) )
               SetProperty( 'VentanaMain', 'GPanFiles', 'Cell', i, NCOLPANRECOVERY, '' )
#endif
            ENDIF
#ifdef QPM_HOTRECOVERY
            IF _IsControlDefined( 'HR_GridItemTargetPan', 'WinHotRecovery' )
               GridImage( 'WinHotRecovery', 'HR_GridItemTargetPan', i, DEF_N_ITEM_COLIMAGE, '-', PUB_nGridImgEdited )
            ENDIF
#endif
         ENDIF
      ENDIF
   NEXT i

   IF ! Empty( PUB_cProjectFolder ) .AND. US_IsDirectory( PUB_cProjectFolder )
      IF VentanaMain.GPrgFiles.ItemCount > 0
         x := ChgPathToReal( GetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', 1, NCOLPRGFULLNAME ) )
         FileRC := US_FileNameOnlyPathAndName( x ) + '.RC'
         IF ! File( FileRC )
            FileRC := PUB_cProjectFolder + DEF_SLASH + US_FileNameOnlyName( x ) + '.RC'
         ENDIF
         IF File( FileRC )
            IF ! Empty( cEditControlFileRC )
               IF ! File( cEditControlFileRC )
                  FechaCnt := Val( Right( US_FileNameOnlyName( cEditControlFileRC ), 16 ) )
                  cEditControlFileRC := ""
                  IF FechaCnt < Val( US_FileDateTime( ChgPathToReal( FileRC ) ) + '00' )
                     QPM_Wait( "RichEditDisplay( 'PAN', .T., " + Str( i ) + ')', 'Reloading ...' )
#ifdef QPM_HOTRECOVERY
                     QPM_Wait( "QPM_HotRecovery( 'ADD', 'EDIT', 'PAN', '" + FileRC + "', '" + HR_ControlFileRC + "' )", 'Creating Version File for Hot Recovery ...' )
                     HR_ControlFileRC := ""
                     IF _IsControlDefined( 'HR_GridItemTargetPRG', 'WinHotRecovery' ) .AND. ;
                        i == GetProperty( 'WinHotRecovery', 'HR_GridItemTargetPRG', 'value' )
                        Eval( { || iif( !bPrgSorting .AND. !PUB_bLite, iif( HR_bNumberOnPrg, QPM_Wait( "QPM_HotChangeGrid( 'TARGET', 'ITEM', 'PRG' )", 'Comparing' ), QPM_HotChangeGrid( 'TARGET', 'ITEM', 'PRG' ) ), US_NOP() ) } )
                     ENDIF
#endif
                  ELSE
                     VentanaMain.RichEditPAN.BackColor := DEF_COLORBACKPAN
                     VentanaMain.RichEditPAN.FontColor := DEF_COLORFONTVIEW
#ifdef QPM_HOTRECOVERY
                     FErase( HR_ControlFileRC )
                     HR_ControlFileRC := ""
#endif
                  ENDIF
               ENDIF
            ENDIF
         ENDIF
      ENDIF
   ENDIF

   FOR i := 1 TO VentanaMain.GDbfFiles.ItemCount
      x := GetProperty( 'VentanaMain', 'GDbfFiles', 'Cell', i, NCOLDBFEDIT )
      IF ! Empty( x )
         IF ! File( x )
            SetProperty( 'VentanaMain', 'GDbfFiles', 'Cell', i, NCOLDBFEDIT, '' )
            GridImage( 'VentanaMain', 'GDbfFiles', i, NCOLDBFSTATUS, '-', PUB_nGridImgEdited )
            IF VentanaMain.GDbfFiles.Value == i
               QPM_Wait( "RichEditDisplay( 'DBF', .T., " + Str( i ) + ')', 'Reloading ...' )
            ENDIF
         ENDIF
      ENDIF
   NEXT i

   SetProperty( 'VentanaMain', 'Timer_Edit', 'Enabled', .T. )
RETURN .T.

FUNCTION CloseDbfAutoView()
   IF select( 'DbfAlias' ) > 0
      DBSelectarea( 'DbfAlias' )
      DBCloseArea( 'DbfAlias' )
   ENDIF
   IF _IsControlDefined( 'DbfBrowse', 'VentanaMain' )
      VentanaMain.DbfBrowse.Release()
   ENDIF
RETURN .T.

FUNCTION DefineRichEditForNotDbfView( cTxt )

   IF ! ( _IsControlDefined( 'DbfAutoView', 'VentanaMain' ) )
      @ GetDesktopRealHeight() - int( ( GetDesktopRealHeight() * 72 ) / 100 ), 10 EDITBOX DbfAutoView ;
         OF VentanaMain ;
         WIDTH 0 ;
         HEIGHT 0 ;
         READONLY ;
         FONT            'Courier New' ;
         SIZE            9 ;
         NOVSCROLL ;
         NOHSCROLL

      VentanaMain.TabFiles.AddControl( 'DbfAutoView', nPageDbf, GetDesktopRealHeight() - int( ( GetDesktopRealHeight() * 72 ) / 100 ), 10 )
      VentanaMain.DbfAutoView.Width  := GetDesktopRealWidth() - 364
      VentanaMain.DbfAutoView.Height := ( GetDesktopRealHeight() - 237 ) - ( GetDesktopRealHeight() - int( ( GetDesktopRealHeight() * 72 ) / 100 ) )
   ENDIF
   VentanaMain.DbfAutoView.Value := CRLF + ;
                                    CRLF + ;
                                    CRLF + ;
                                    CRLF + ;
                                    CRLF + ;
                                    CRLF + ;
                                    '               '+cTxt
// VentanaMain.DbfAutoView.Refresh()

RETURN .T.

FUNCTION ProjectButtons( bEna )
   VentanaMain.TProjectFolder.Enabled    := bEna
   VentanaMain.BProjectFolder.Enabled    := bEna
   VentanaMain.TRunProjectFolder.Enabled := bEna
   VentanaMain.BRunProjectFolder.Enabled := bEna
   VentanaMain.BPrgAdd.Enabled           := bEna
#ifdef QPM_SHG
   VentanaMain.THlpDatabase.Enabled      := bEna
   VentanaMain.BHlpDatabase.Enabled      := bEna
   VentanaMain.TWWWHlp.Enabled           := bEna
#endif
RETURN bEna

FUNCTION AddLastOpen( cPrj )
   LOCAL r, i, cont:=0
   IF ( r := AScan( vLastOpen, { |x| US_Upper( x ) == US_Upper( cPrj ) } ) ) > 0
      vLastOpen[r] := ''
   ELSE
      AEval( vLastOpen, { |x| iif( ! Empty( x ), cont ++, ) } )
      IF cont > 19  // Tope de menu Items para proyectos abiertos anteriormente
         FOR i := 1 TO Len( vLastOpen )
            IF ! Empty( vLastOpen[i] )
               vLastOpen[ i ] := ''
               EXIT
            ENDIF
         NEXT
      ENDIF
   ENDIF
   AAdd( vLastOpen, cPrj )
RETURN .T.

FUNCTION LocalSearchContinue()
   LOCAL RPTA := '', Ventana := US_WindowNameRandom( 'NEXT' )

   DEFINE WINDOW &( Ventana ) ;
      AT 0, 0 ;
      WIDTH 265 ;
      HEIGHT 175 ;
      TITLE "Continue Search in DBF's Data" ;
      MODAL ;
      NOSYSMENU ;
      FONT 'ARIAL' SIZE 10 ;
      ON RELEASE US_NOP()

      DEFINE LABEL LContinue
             ROW    12
             COL    20
             WIDTH  240
             VALUE      "Continue Search From NEXT:"
      END LABEL

      DEFINE BUTTONEX BPosition
              ROW   40
              COL   20
              WIDTH 65
              HEIGHT 25
              CAPTION   'Position'
              ACTION    ( RPTA := 'P', DoMethod( Ventana, 'Release' ) )
              TOOLTIP   'Resume search from the last text found.'
      END BUTTONEX

      DEFINE BUTTONEX BField
              ROW   40
              COL   100
              WIDTH 65
              HEIGHT 25
              CAPTION   'Column'
              ACTION    ( RPTA := 'F', DoMethod( Ventana, 'Release' ) )
              TOOLTIP   'Resume search from the the NEXT column.'
      END BUTTONEX

      DEFINE BUTTONEX BRecord
              ROW   40
              COL   180
              WIDTH 65
              HEIGHT 25
              CAPTION   'Record'
              ACTION    ( RPTA := 'R', DoMethod( Ventana, 'Release' ) )
              TOOLTIP   'Resume search from the the NEXT record.'
      END BUTTONEX

      DEFINE CHECKBOX Check_Continue
              CAPTION   'Remember my election'
              ROW   70
              COL   50
              WIDTH 185
              VALUE     .F.
              TOOLTIP   "Do not ask again until the search starts from the beginning."
              ON CHANGE ( bDbfDataSearchAsk := ! ( GetProperty( Ventana, 'Check_Continue', 'value' ) ) )
      END CHECKBOX

      DEFINE BUTTONEX BCancel
              ROW   110
              COL   90
              WIDTH 85
              HEIGHT 25
              CAPTION   'Cancel'
              ACTION    ( RPTA := '', DoMethod( Ventana, 'Release' ) )
              TOOLTIP   'Cancel search.'
      END BUTTONEX

   END WINDOW

   CENTER WINDOW &Ventana
   ACTIVATE WINDOW &Ventana
RETURN RPTA

FUNCTION CargoSearch()
   AEval( vLastSearch, { |x| VentanaMain.CSearch.AddItem( x ) } )
RETURN NIL

FUNCTION QPM_DefinoMainMenu()
   LOCAL i, cProj, bAction
   DEFINE MAIN MENU OF VentanaMain
      POPUP '&File'
         ITEM '&Open/New' ACTION QPM_OpenProject()
         ITEM '&Save' ACTION QPM_SaveProject()
         ITEM 'Save &As ...' ACTION QPM_SaveAsProject()
      IF Len( vLastOpen ) > 0
         SEPARATOR
      ENDIF
      FOR i := Len( vLastOpen ) TO 1 step -1
         cProj := vLastOpen[i]
         IF ! Empty( cProj )
            bAction := "{|| QPM_OpenProject( '" + cProj + "' ) }"
            _DefineMenuItem( cProj, &bAction, NIL, iif( File( cProj ), 'GridTilde', 'GridEquis' ) )
         ENDIF
      NEXT
      IF Len( vLastOpen ) > 0
         SEPARATOR
         ITEM '&Clear list' ACTION QPM_ClearLastOpenList()
      ENDIF
         SEPARATOR
         ITEM '&EXIT' ACTION QPM_EXIT( .T. )
      END POPUP
      POPUP '&Edit'
#ifdef QPM_SHG
         ITEM '&Copy' ACTION SHG_Send_Copy() NAME ItC_CopyM
         ITEM 'C&ut' ACTION SHG_Send_Cut() NAME ItC_CutM
         ITEM '&Paste' ACTION SHG_Send_Paste() NAME ItC_PasteM
#else
         ITEM '&Copy' ACTION ( US_Send_Copy(), DoEvents() ) NAME ItC_CopyM
         ITEM 'C&ut' ACTION ( US_Send_Cut(), DoEvents() ) NAME ItC_CutM
         ITEM '&Paste' ACTION ( US_Send_Paste(), DoEvents() ) NAME ItC_PasteM
#endif
         ITEM '&Select All' ACTION QPM_Send_SelectAll()
      END POPUP
      POPUP '&Debug'
         ITEM '&Build' ACTION ( bBuildRun := .F., QPM_Build() )
         ITEM 'B&uild and Run' ACTION ( bBuildRun := .T., QPM_Build() )
         ITEM '&Run' ACTION ( bRunParm := .F., QPM_Run( bRunParm ) )
         ITEM 'Run With &Parm' ACTION ( bRunParm := .T., QPM_Run( bRunParm ) )
         SEPARATOR
      IF PUB_bDebugActive
         ITEM '&Debug' ACTION SwitchDebug() NAME DEBUG CHECKMARK 'GridTilde' CHECKED
      ELSE
         ITEM '&Debug' ACTION SwitchDebug() NAME DEBUG CHECKMARK 'GridTilde'
      ENDIF
      END POPUP
      POPUP '&Settings'
         ITEM PUB_MenuPrjOptions ACTION ProjectSettings()
         SEPARATOR
         ITEM PUB_MenuGblOptions ACTION GlobalSettings()
#ifdef QPM_HOTRECOVERYWINDOW
         SEPARATOR
         ITEM 'Hot Recovery &Options' ACTION QPM_HotRecoveryOptions()
#endif
         SEPARATOR
         ITEM 'Compress QPM Utilities' ACTION QPM_CompressUtilities()
         ITEM 'Decompress QPM Utilities' ACTION QPM_DecompressUtilities()
         SEPARATOR
      IF PUB_bAutoInc
         ITEM 'AutoInc Version Number' ACTION SwitchAutoInc() NAME AUTOINC CHECKMARK 'GridTilde' CHECKED
      ELSE
         ITEM 'AutoInc Version Number' ACTION SwitchAutoInc() NAME AUTOINC CHECKMARK 'GridTilde'
      ENDIF
      IF PUB_bHotKeys
         ITEM "Hotkeys enabled" ACTION SwitchHotKeys() NAME HOTKEYS CHECKMARK 'GridTilde' CHECKED
      ELSE
         ITEM "Hotkeys enabled" ACTION SwitchHotKeys() NAME HOTKEYS CHECKMARK 'GridTilde'
      ENDIF
      ITEM PUB_MenuResetWarnings ACTION ResetMsgs() NAME WARNINGS
      END POPUP

#ifdef QPM_HOTRECOVERYWINDOW
      POPUP '&Recovery'
         ITEM '&Hot Recovery' ACTION QPM_HotRecoveryMenu()
         SEPARATOR
         ITEM 'Hot Recovery &Options' ACTION QPM_HotRecoveryOptions()
         SEPARATOR
         ITEM '&Import Versions from Another Hot Recovery Database' ACTION HotRecoveryImport()
         SEPARATOR
         ITEM '&Reindex Hot Recovery Database' ACTION QPM_Wait( 'HotRecoveryReindex()', 'Reindexing Hot Recovery Database' )
#ifdef QPM_SYNCRECOVERY
         SEPARATOR
         ITEM '&Sync Point Recovery' ACTION QPM_SyncRecoveryMenu()
#endif
      END POPUP
#else
#ifdef QPM_SYNCRECOVERY
      POPUP '&Recovery'
         ITEM '&Sync Point Recovery' ACTION QPM_SyncRecoveryMenu()
      END POPUP
#endif
#endif
      POPUP '&Help'
      ITEM 'QPM &Help' ACTION US_DisplayHelpTopic( GetActiveHelpFile(), 1 )
         SEPARATOR
         ITEM '&About' ACTION QPM_About()
         SEPARATOR
         ITEM '&License' ACTION QPM_Licence()
      END POPUP
      POPUP '&Links     '
         ITEM 'Go to the "Links" topic in Help' ACTION US_DisplayHelpTopic( GetActiveHelpFile(), 'links' )
         ITEM 'Go to QPM Home Site: ' + PUB_cQPM_Support_Link ACTION ShellExecute(0, 'open', 'rundll32.exe', 'url.dll,FileProtocolHandler ' + PUB_cQPM_Support_Link,,1)
      END POPUP
      POPUP '&Only For Support     '
         ITEM 'Record Activity in Log ' + PUB_cQPM_Folder + DEF_SLASH + 'QPM.log' ACTION ( bLogActivity := ! bLogActivity, VentanaMain.MLog.Checked := bLogActivity ) NAME MLog CHECKMARK 'GridTilde'
         ITEM 'Clear Log ' + PUB_cQPM_Folder + DEF_SLASH + 'QPM.log' ACTION ClearLog()
         ITEM 'View Log ' + PUB_cQPM_Folder + DEF_SLASH + 'QPM.log' ACTION ViewLog()
         SEPARATOR
         ITEM 'Do not delete auxiliary files'  ACTION ( PUB_DeleteAux := ! PUB_DeleteAux, VentanaMain.MDelete.Checked := ! PUB_DeleteAux ) NAME MDelete CHECKMARK 'GridTilde'
         SEPARATOR
         ITEM 'Go to QPM Home Site: ' + PUB_cQPM_Support_Link ACTION ShellExecute( 0, 'open', 'rundll32.exe', 'url.dll,FileProtocolHandler ' + PUB_cQPM_Support_Link, NIL, 1)
         ITEM '&Mail to QPM_Support <' + PUB_cQPM_Support_eMail + '> ...' ACTION ShellExecute( 0, 'open', 'rundll32.exe', 'url.dll,FileProtocolHandler ' + 'mailto:' + PUB_cQPM_Support_eMail + '?cc=&bcc=' + '&subject=' + PUB_cQPM_Title + '&body=My%20version%20is%20' + PUB_cQPM_Title + '', NIL, 1)
      END POPUP
      POPUP '&Make a donation'
         ITEM "PayPal" ACTION ShellExecute( 0, 'open', 'rundll32.exe', 'url.dll,FileProtocolHandler ' + PUB_cQPM_Donation_Link, NIL, 1)
         ITEM "Other ways" ACTION ShellExecute( 0, 'open', 'rundll32.exe', 'url.dll,FileProtocolHandler ' + 'mailto:fernando.yurisich@gmail.com?cc=&bcc=' + '&subject=I%20want%20to%20make%20a%20donation&body=Please%20contact%20me.', NIL, 1)
      END POPUP
   END MENU

   RELEASE CONTROL ToolBar_1 OF VentanaMain

   DEFINE TOOLBAR ToolBar_1 OF VentanaMain BUTTONSIZE 50,35 FLAT
      BUTTON OPEN ;
         CAPTION 'Open/New' ;
         PICTURE 'open' ;
         ACTION QPM_OpenProject() ;
         SEPARATOR ;
         AUTOSIZE ;
         DROPDOWN

      DEFINE DROPDOWN MENU BUTTON OPEN OF VentanaMain
         ITEM 'Open/New' ACTION QPM_OpenProject()
         SEPARATOR
         FOR i := Len( vLastOpen ) TO 1 step -1
            cProj := vLastOpen[i]
            IF ! Empty( cProj )
               bAction := "{|| QPM_OpenProject( '" + cProj + "' ) }"
               _DefineMenuItem( cProj, &bAction, NIL, iif( File( cProj ), 'GridTilde', 'GridEquis' ) )
            ENDIF
         NEXT
         IF Len( vLastOpen ) > 0
            SEPARATOR
            ITEM '&Clear list' ACTION QPM_ClearLastOpenList()
         ENDIF
      END MENU

      BUTTON SAVE ;
         CAPTION 'Save' ;
         PICTURE 'save' ;
         ACTION QPM_SaveProject() ;
         SEPARATOR ;
         AUTOSIZE ;
         DROPDOWN

      DEFINE DROPDOWN MENU BUTTON SAVE OF VentanaMain
         ITEM 'Save'       ACTION QPM_SaveProject()
         ITEM 'Save As'    ACTION QPM_SaveAsProject()
      END MENU

      BUTTON BUILD ;
         CAPTION 'Build' ;
         PICTURE 'build' ;
         ACTION QPM_Build() ;
         SEPARATOR ;
         AUTOSIZE ;
         DROPDOWN

      DEFINE DROPDOWN MENU BUTTON BUILD OF VentanaMain
         ITEM 'Build'                 ACTION ( bBuildRun := .F., QPM_Build() )
         ITEM 'Build and Run'         ACTION ( bBuildRun := .T., QPM_Build() ) NAME bDropDownBandR
      END MENU

      BUTTON RUN ;
         CAPTION 'Run' ;
         PICTURE 'run' ;
         ACTION QPM_Run( bRunParm ) ;
         SEPARATOR ;
         AUTOSIZE ;
         DROPDOWN

      DEFINE DROPDOWN MENU BUTTON RUN OF VentanaMain
         ITEM 'Run'                 ACTION ( bRunParm := .F., QPM_Run( bRunParm ) )
         ITEM 'Run With Parm'       ACTION ( bRunParm := .T., QPM_Run( bRunParm ) )
      END MENU

      BUTTON HELP ;
         CAPTION 'Help' ;
         PICTURE 'HELPBMP' ;
         ACTION  US_DisplayHelpTopic( GetActiveHelpFile(), 1 ) ;
         SEPARATOR
   END TOOLBAR

RETURN .T.

FUNCTION ResetMsgs
   IF MyMsgYesNo( "Enable all warnings and messages?" )
      Prj_Warn_BccObject       := .T.
      Prj_Warn_BccObject_Cont  := .T.
      Prj_Warn_Cpp             := .T.
      Prj_Warn_GT_Order        := .T.
      Prj_Warn_GT_Order_Cont   := .T.
      Prj_Warn_InfoSaved       := .T.
      Prj_Warn_NullRDD         := .T.
      Prj_Warn_PPO_Browse      := .T.
      Prj_Warn_TopFile         := .T.
   ENDIF
RETURN NIL

FUNCTION GetPrj_Version()
RETURN PadL( GetProperty( 'VentanaMain', 'LVerVerNum', 'value' ), DEF_LEN_VER_VERSION, '0' ) + PadL( GetProperty( 'VentanaMain', 'LVerRelNum', 'value' ), DEF_LEN_VER_RELEASE, '0' ) + PadL( GetProperty( 'VentanaMain', 'LVerBuiNum', 'value' ), DEF_LEN_VER_BUILD, '0' )

#ifndef QPM_KILLER
FUNCTION QPM_SETPROCESSPRIORITY( x )
RETURN .T.
#endif

FUNCTION QPM_CompressUtilities()
   LOCAL i, Out, cBat := PUB_cQPM_Folder + DEF_SLASH + 'Compress.bat'

   QPM_Execute( PUB_cQPM_Folder + DEF_SLASH + 'US_UPX.EXE ' + US_ShortName(PUB_cQPM_Folder) + DEF_SLASH + 'US_RUN.EXE', '', DEF_QPM_EXEC_NOWAIT, DEF_QPM_EXEC_HIDE )
   DO EVENTS

   Out := '@ECHO OFF' + CRLF
   Out += 'COPY ' + US_ShortName(PUB_cQPM_Folder) + DEF_SLASH + 'US_UPX.EXE ' + US_ShortName(PUB_cQPM_Folder) + DEF_SLASH + 'XYZ_UPX.EXE' + CRLF
   FOR i := 1 TO Len(vExeList)
      DO CASE
      CASE US_Upper(right(vExeList[i], 04)) != '.EXE'
      CASE US_Upper(right(vExeList[i], 07)) == 'QPM.EXE'
      CASE US_Upper(right(vExeList[i], 10)) == 'US_RUN.EXE'
      CASE US_Upper(right(vExeList[i], 13)) == 'US_IMPDEF.EXE'
      CASE US_Upper(right(vExeList[i], 15)) == 'US_PEXPORTS.EXE'
      CASE US_Upper(right(vExeList[i], 12)) == 'US_REIMP.EXE'
      CASE US_Upper(right(vExeList[i], 13)) == 'US_IMPLIB.EXE'
      CASE US_Upper(right(vExeList[i], 14)) == 'US_OBJDUMP.EXE'
      CASE US_Upper(right(vExeList[i], 12)) == 'US_TDUMP.EXE'
      OTHERWISE
         Out += US_ShortName(PUB_cQPM_Folder) + DEF_SLASH + 'XYZ_UPX.EXE --no-progress ' + vExeList[i] + CRLF
      ENDCASE
   NEXT
   Out += 'DEL ' + US_ShortName(PUB_cQPM_Folder) + DEF_SLASH + 'XYZ_UPX.EXE' + CRLF

   QPM_LogFile( cBat )
   QPM_MemoWrit( cBat, Out )
   QPM_Execute( cBat, NIL, DEF_QPM_EXEC_WAIT, DEF_QPM_EXEC_NORMAL )

   MyMsgInfo( 'Compression done.' + CRLF + ;
              "To compress QPM.EXE: close QPM, switch to QPM's installation folder and manually execute:" + CRLF + ;
              'us_upx QPM.EXE')
   QPM_LogText( "Done" )
RETURN NIL

FUNCTION QPM_DecompressUtilities()
   LOCAL i, Out, cBat := PUB_cQPM_Folder + DEF_SLASH + 'Decompress.bat'

   QPM_Execute( PUB_cQPM_Folder + DEF_SLASH + 'US_UPX.EXE -d ' + US_ShortName(PUB_cQPM_Folder) + DEF_SLASH + 'US_RUN.EXE', '', DEF_QPM_EXEC_NOWAIT, DEF_QPM_EXEC_HIDE )
   DO EVENTS

   Out := '@ECHO OFF' + CRLF
   Out += 'COPY ' + US_ShortName(PUB_cQPM_Folder) + DEF_SLASH + 'US_UPX.EXE ' + US_ShortName(PUB_cQPM_Folder) + DEF_SLASH + 'XYZ_UPX.EXE' + CRLF
   FOR i := 1 TO Len( vExeList )
      DO CASE
      CASE US_Upper(right(vExeList[i], 04)) != '.EXE'
      CASE US_Upper(right(vExeList[i], 07)) == 'QPM.EXE'
      CASE US_Upper(right(vExeList[i], 10)) == 'US_RUN.EXE'
      CASE US_Upper(right(vExeList[i], 13)) == 'US_IMPDEF.EXE'
      CASE US_Upper(right(vExeList[i], 15)) == 'US_PEXPORTS.EXE'
      CASE US_Upper(right(vExeList[i], 12)) == 'US_REIMP.EXE'
      CASE US_Upper(right(vExeList[i], 13)) == 'US_IMPLIB.EXE'
      CASE US_Upper(right(vExeList[i], 14)) == 'US_OBJDUMP.EXE'
      CASE US_Upper(right(vExeList[i], 12)) == 'US_TDUMP.EXE'
      OTHERWISE
         Out += US_ShortName(PUB_cQPM_Folder) + DEF_SLASH + 'XYZ_UPX.EXE -d --no-progress ' + vExeList[i] + CRLF
      ENDCASE
   NEXT
   Out += 'DEL ' + US_ShortName(PUB_cQPM_Folder) + DEF_SLASH + 'XYZ_UPX.EXE' + CRLF

   QPM_LogFile( cBat )
   QPM_MemoWrit( cBat, Out )
   QPM_Execute( cBat, NIL, DEF_QPM_EXEC_WAIT, DEF_QPM_EXEC_NORMAL )

   MyMsgInfo( 'Decompression done.' + CRLF + ;
              "To decompress QPM.EXE: close QPM, switch to QPM's installation folder and manually execute:" + CRLF + ;
              'us_upx -d QPM.EXE')
   QPM_LogText( "Done" )
RETURN NIL

FUNCTION CleanAuxFiles
   LOCAL cAux, TDS_FILE := "", EXP_FILE := "", MAP_FILE := "", SAVE_FILE, ERR_FILE, RC_MAIN
   LOCAL RC1_SHR := "", RC1_FER := "", RC2_SHR := "", RC2_FER := ""

   QPM_LogText( "CleanAuxFile start" )
   IF ! Empty( cAux := US_FileNameOnlyName( GetOutputModuleName() ) )
      TDS_FILE := cAux + ".TDS"
      EXP_FILE := cAux + ".EXP"
   ENDIF
   IF VentanaMain.GPrgFiles.ItemCount > 0
      cAux := PUB_cProjectFolder + DEF_SLASH + US_FileNameOnlyName( GetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', 1, NCOLPRGNAME ) )
      MAP_FILE := cAux + '.MAP'
      IF ! File( RC_MAIN := US_FileNameOnlyPathAndName( GetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', 1, NCOLPRGNAME ) ) + '.RC' )
         IF ! File( RC_MAIN := cAux + '.RC' )
            RC_MAIN := ""
         ENDIF
      ENDIF
      IF ! Empty( RC_MAIN )
         RC1_SHR := RC_MAIN + '1'
         RC1_FER := RC_MAIN + '1.Error'
         RC2_SHR := RC_MAIN + '2'
         RC2_FER := RC_MAIN + '2.Error'
      ENDIF
   ENDIF
   SAVE_FILE := US_FileNameOnlyPathAndName( TEMP_LOG ) + ".save"
   ERR_FILE  := PUB_cProjectFolder + DEF_SLASH + '_' + PUB_cSecu + 'TEMP.ERR'

   IF ( File( SCRIPT_FILE ) .OR. File( TEMP_LOG ) .OR. File( END_FILE ) .OR. File( BUILD_BAT ) .OR. ;
        File( MAKE_FILE ) .OR. File( PROGRESS_LOG ) .OR. File( RUN_FILE ) .OR. File( QPM_GET_DEF ) .OR. ;
        File( QPM_TMP_RC ) .OR. File( "_hmg_resconfig.h" ) .OR. File( TDS_FILE ) .OR. File( EXP_FILE ) .OR. ;
        File( MAP_FILE ) .OR. File( SAVE_FILE ) .OR. File( ERR_FILE ) .OR. File( RC1_SHR ) .OR. ;
        File( RC1_FER ) .OR. File( RC2_SHR ) .OR. File( RC2_FER ) )
      IF MyMsgYesNo( "Delete auxiliary files?" )
         IF File( SCRIPT_FILE )
            FErase( SCRIPT_FILE )
         ENDIF
         IF File( TEMP_LOG )
            FErase( TEMP_LOG )
         ENDIF
         IF File( END_FILE )
            FErase( END_FILE )
         ENDIF
         IF File( BUILD_BAT )
            FErase( BUILD_BAT )
         ENDIF
         IF File( MAKE_FILE )
            FErase( MAKE_FILE )
         ENDIF
         IF File( PROGRESS_LOG )
            FErase( PROGRESS_LOG )
         ENDIF
         IF File( RUN_FILE )
            FErase( RUN_FILE )
         ENDIF
         IF File( QPM_GET_DEF )
            FErase( QPM_GET_DEF )
         ENDIF
         IF File( QPM_TMP_RC )
            FErase( QPM_TMP_RC )
         ENDIF
         IF File( "_hmg_resconfig.h" )
            FErase( "_hmg_resconfig.h" )
         ENDIF
         IF File( TDS_FILE )
            FErase( TDS_FILE )
         ENDIF
         IF File( EXP_FILE )
            FErase( EXP_FILE )
         ENDIF
         IF File( MAP_FILE )
            FErase( MAP_FILE )
         ENDIF
         IF File( SAVE_FILE )
            FErase( SAVE_FILE )
         ENDIF
         IF File( ERR_FILE )
            FErase( ERR_FILE )
         ENDIF
         IF File( RC1_SHR )
            FErase( RC1_SHR )
         ENDIF
         IF File( RC1_FER )
            FErase( RC1_FER )
         ENDIF
         IF File( RC2_SHR )
            FErase( RC2_SHR )
         ENDIF
         IF File( RC2_FER )
            FErase( RC2_FER )
         ENDIF
      ENDIF
   ENDIF
   QPM_LogText( "CleanAuxFile end" )
RETURN NIL

/* eof */
