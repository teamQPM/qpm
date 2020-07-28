/*
 * $Id$
 */

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
#include <QPM.ch>

memvar tiempo
memvar WinMsg
memvar PrivAutoExit
memvar SM_oMGWait
memvar cMemoInP

FUNCTION QPM_CreatePublicVars()

// VARIABLES FOR FLAVOR IDENTIFICATION
   QPM_VAR0 PUBLIC DefineMiniGui1       := DEF_MG_MINIGUI1
   QPM_VAR0 PUBLIC DefineMiniGui3       := DEF_MG_MINIGUI3
   QPM_VAR0 PUBLIC DefineExtended1      := DEF_MG_EXTENDED1
   QPM_VAR0 PUBLIC DefineOohg3          := DEF_MG_OOHG3
   QPM_VAR0 PUBLIC DefineHarbour        := DEF_MG_HARBOUR
   QPM_VAR0 PUBLIC DefineXHarbour       := DEF_MG_XHARBOUR
   QPM_VAR0 PUBLIC DefineBorland        := DEF_MG_BORLAND
   QPM_VAR0 PUBLIC DefineMinGW          := DEF_MG_MINGW
   QPM_VAR0 PUBLIC DefinePelles         := DEF_MG_PELLES
   QPM_VAR0 PUBLIC Define32bits         := DEF_MG_32
   QPM_VAR0 PUBLIC Define64bits         := DEF_MG_64

// VARIABLES
   PUBLIC BUILD_IN_PROGRESS             := .F.
   PUBLIC PUB_cQPM_Support_Link         := 'https://teamqpm.github.io/'
   PUBLIC PUB_cQPM_Support_Admin        := 'Fernando Yurisich (Uruguay)'
   PUBLIC PUB_cQPM_Support_eMail        := 'qpm-users@lists.sourceforge.net'
   PUBLIC PUB_cStatusLabel              := 'Status: Idle'
   PUBLIC PUB_MenuPrjOptions            := 'Project Options'
   PUBLIC PUB_MenuGblOptions            := 'Global Options (folders for [x]Harbour, MiniGUI, C++ and others)'
   PUBLIC PUB_cCharTab                  := Chr( 09 )
   PUBLIC PUB_cCharFileNameTemp         := '_'   // MinGW's MAKE doesn't support $, # prevents TEMP.LOG generation
   PUBLIC PUB_cQPM_Title                := 'QPM (QAC based Project Manager) - Project Manager for MiniGui (' + QPM_VERSION_DISPLAY_LONG + ')'
   PUBLIC PUB_cQPM_Folder               := US_FileNameOnlyPath( GetModuleFileName( GetInstance() ) )
   PUBLIC PUB_cTempFolder               := GetTempFolder()
   PUBLIC PUB_cThisFolder               := ''
   PUBLIC PUB_cProjectFile              := ''
   PUBLIC PUB_cProjectFolder            := ''
   PUBLIC cProjectFolderIdent           := '<ProjectFolder>'
   PUBLIC PUB_bOpenProjectFromParm      := .F.
   PUBLIC PUB_nProjectFileHandle        := 0
   PUBLIC PUB_bIgnoreVersionProject     := .F.
   PUBLIC PUB_bW800                     := iif( GetDesktopWidth() <     1024, .T., .F. )
   PUBLIC PUB_cAutoLog                  := ''
   PUBLIC PUB_cAutoLogTmp               := ''
   PUBLIC PUB_bLogOnlyError             := .F.
   PUBLIC PUB_cSecu                     := dtos(date()) + US_strCero( int(seconds()), 5 ) + PUB_cCharFileNameTemp
   PUBLIC PUB_bDebugActive              := .F.
   PUBLIC PUB_bDebugActiveAnt           := .F.
   PUBLIC PUB_bIsProcessing             := .F.
   PUBLIC PUB_xHarbourMT                := ''
   PUBLIC PUB_bAutoInc                  := .T.
   PUBLIC PUB_bHotKeys                  := .T.
   PUBLIC IsBorland                     := .F.
   PUBLIC IsMinGW                       := .F.
   PUBLIC IsPelles                      := .F.
   PUBLIC ProgLength                    := 0
   PUBLIC bAutoExit                     := .F.
   PUBLIC cUpxOpt                       := '--no-progress'   // By default icons are compressed except the first one, for no compression add '--compress-icons=0'
   PUBLIC LibsActiva                    := ''
   PUBLIC PagePRG                       := iif( PUB_bW800, 'SRC', 'Sources' )
   PUBLIC PageHEA                       := 'H && CH'
   PUBLIC PagePAN                       := 'FMG && RC'
   PUBLIC PageDBF                       := 'DBF'
   PUBLIC PageLIB                       := 'LIB'
   PUBLIC PageHLP                       := 'SHG'
   PUBLIC PageSysout                    := iif( PUB_bW800, 'Log', 'Log Build Process' )
   PUBLIC PageOUT                       := iif( PUB_bW800, 'Out', 'Output Error/Module' )
   PUBLIC PageWWW                       := iif( PUB_bW800, 'www', 'www' )
   PUBLIC PageCdQ                       := iif( PUB_bW800, 'QPM', 'QPM' )
   PUBLIC vSinLoadWindow                := {}
   PUBLIC vSinInclude                   := {}
   PUBLIC vXRefPrgHea                   := {}
   PUBLIC vXRefPrgFmg                   := {}
   PUBLIC cLastProjectFolder            := ''
   PUBLIC bLogActivity                  := .F.
   PUBLIC PUB_DeleteAux                 := .T.
   PUBLIC PUB_vAutoRun                  := {}
   PUBLIC RunControlFile                := {}
   PUBLIC bRunApp                       := .F.
   PUBLIC PUB_bLite                     := .F.
   PUBLIC bWaitForBuild                 := .F.
   PUBLIC nPagePrg                      := 1
   PUBLIC nPageHea                      := 2
   PUBLIC nPagePan                      := 3
   PUBLIC nPageDbf                      := 4
   PUBLIC nPageLib                      := 5
#ifdef QPM_SHG
   PUBLIC nPageHlp                      := 6
   PUBLIC nPageSysout                   := 7
   PUBLIC nPageOut                      := 8
#else
   PUBLIC nPageHlp                      := 10000
   PUBLIC nPageSysout                   := 6
   PUBLIC nPageOut                      := 7
#endif
   PUBLIC GBL_TabGridNameFocus          := ''
   PUBLIC PUB_ErrorLogTime              := 0
   PUBLIC GBL_HR_cLastExternalFileName  := ''
   PUBLIC vDbfHeaders                   := { 'One', 'Two' }
   PUBLIC vDbfWidths                    := { 50, 50 }
   PUBLIC vDbfJustify                   := { BROWSE_JTFY_LEFT, BROWSE_JTFY_LEFT }
   PUBLIC bEditorLongName               := .F.
   PUBLIC bSuspendControlEdit           := .F.
   PUBLIC bPrgSorting                   := .F.
   PUBLIC bHeaSorting                   := .F.
   PUBLIC bPanSorting                   := .F.
   PUBLIC bDbfSorting                   := .F.
   PUBLIC bIncSorting                   := .F.
   PUBLIC bExcSorting                   := .F.
   PUBLIC bHlpSorting                   := .F.
   PUBLIC bPrgMoving                    := .F.
   PUBLIC bHeaMoving                    := .F.
   PUBLIC bPanMoving                    := .F.
   PUBLIC bDbfMoving                    := .F.
   PUBLIC bIncMoving                    := .F.
   PUBLIC bExcMoving                    := .F.
   PUBLIC bHlpMoving                    := .F.
   PUBLIC PUB_nGridImgNone              := 0
   PUBLIC PUB_nGridImgTilde             := 1
   PUBLIC PUB_nGridImgEquis             := 2
   PUBLIC PUB_nGridImgSearchOk          := 3   // this means 'to compress this image activate bit 3'
   PUBLIC PUB_nGridImgEdited            := 4
   PUBLIC PUB_nGridImgSearchNotOk       := 5
   PUBLIC PUB_nGridImgHlpGlobalFoot     := 6
   PUBLIC PUB_nGridImgHlpWelcome        := 7
   PUBLIC PUB_nGridImgHlpBook           := 8
   PUBLIC PUB_nGridImgHlpPage           := 9
   PUBLIC PUB_nGridImgTop               := 9   // equal to the last variable of GridImg ...
   PUBLIC vImagesGrid                   := { 'GridNone', ;
                                             'GridTilde', ;
                                             'GridEquis', ;
                                             'GridTildeEquis', ;
                                             'GridSearchok', ;
                                             'GridTildeSearchok', ;
                                             'GridEquisSearchok', ;
                                             'GridTildeEquisSearchok', ;
                                             'GridEdited', ;
                                             'GridTildeEdited', ;
                                             'GridEquisEdited', ;
                                             'GridTildeEquisEdited', ;
                                             'GridSearchokEdited', ;
                                             'GridTildeSearchokEdited', ;
                                             'GridEquisSearchokEdited', ;
                                             'GridTildeEquisSearchokEdited', ;
                                             'GridSearchNotOk', ;
                                             'GridHlpGlobalFoot', ;
                                             'GridHlpGlobalFootSearchOk', ;
                                             'GridHlpWelcome', ;
                                             'GridHlpWelcomeSearchOk', ;
                                             'GridHlpBook', ;
                                             'GridHlpBookSearchOk', ;
                                             'GridHlpPage', ;
                                             'GridHlpPageSearchOk' }   // See FUNCTION GridImage
   PUBLIC bGlobalSearch                 := .F.   // .T. means Global Search is active
   PUBLIC cLastGlobalSearch             := ''
   PUBLIC bLastGlobalSearchFun          := .F.
   PUBLIC bLastGlobalSearchDbf          := .F.
   PUBLIC bLastGlobalSearchCas          := .F.
   PUBLIC bAvisoDbfGlobalSearchLow      := .T.
   PUBLIC bAvisoDbfDataSearchLow        := .T.
   PUBLIC bDbfDataSearchAsk             := .T.
   PUBLIC cDbfDataSearchAskRpta         := ''
   PUBLIC aGridPrg                      := {}
   PUBLIC nGridPrgLastRow               := 0
   PUBLIC NCOLPRGSTATUS                 := 1
   PUBLIC NCOLPRGRECOMP                 := 2
   PUBLIC NCOLPRGNAME                   := 3
   PUBLIC NCOLPRGFULLNAME               := 4
   PUBLIC NCOLPRGOFFSET                 := 5
   PUBLIC NCOLPRGEDIT                   := 6
   PUBLIC NCOLPRGRECOVERY               := 7
   PUBLIC cEditControlFileRC            := ""
   PUBLIC bSortPrgAsc                   := .T.
   PUBLIC aGridHea                      := {}
   PUBLIC nGridHeaLastRow               := 0
   PUBLIC NCOLHEASTATUS                 := 1
   PUBLIC NCOLHEANAME                   := 2
   PUBLIC NCOLHEAFULLNAME               := 3
   PUBLIC NCOLHEAOFFSET                 := 4
   PUBLIC NCOLHEAEDIT                   := 5
   PUBLIC NCOLHEARECOVERY               := 6
   PUBLIC bSortHeaAsc                   := .T.
   PUBLIC aGridPan                      := {}
   PUBLIC nGridPanLastRow               := 0
   PUBLIC NCOLPANSTATUS                 := 1
   PUBLIC NCOLPANNAME                   := 2
   PUBLIC NCOLPANFULLNAME               := 3
   PUBLIC NCOLPANOFFSET                 := 4
   PUBLIC NCOLPANEDIT                   := 5
   PUBLIC NCOLPANRECOVERY               := 6
   PUBLIC bSortPanAsc                   := .T.
   PUBLIC aGridDbf                      := {}
   PUBLIC nGridDbfLastRow               := 0
   PUBLIC NCOLDBFSTATUS                 := 1
   PUBLIC NCOLDBFNAME                   := 2
   PUBLIC NCOLDBFFULLNAME               := 3
   PUBLIC NCOLDBFOFFSET                 := 4
   PUBLIC NCOLDBFEDIT                   := 5
   PUBLIC NCOLDBFSEARCH                 := 6
   PUBLIC bSortDbfAsc                   := .T.
   PUBLIC aGridInc                      := {}
   PUBLIC NCOLINCSTATUS                 := 1
   PUBLIC NCOLINCNAME                   := 2
   PUBLIC NCOLINCFULLNAME               := 3
   PUBLIC nColLibStatus                 := NCOLINCSTATUS     // auxiliar var for processes that don't differentiate between inc and exc
   PUBLIC nColLibFullName               := NCOLINCFULLNAME   // auxiliar var for processes that don't differentiate between inc and exc
   PUBLIC bSortIncAsc                   := .T.
   PUBLIC aGridExc                      := {}
   PUBLIC NCOLEXCSTATUS                 := 1
   PUBLIC NCOLEXCNAME                   := 2
   PUBLIC bSortExcAsc                   := .T.
   PUBLIC aGridHlp                      := {}
   PUBLIC nGridHlpLastRow               := 0
   PUBLIC NCOLHLPSTATUS                 := 1
   PUBLIC NCOLHLPTOPIC                  := 2
   PUBLIC NCOLHLPNICK                   := 3
   PUBLIC NCOLHLPOFFSET                 := 4
   PUBLIC NCOLHLPEDIT                   := 5
   PUBLIC bSortHlpAsc                   := .T.
   PUBLIC SHG_Database                  := ''
   PUBLIC SHG_DbSize                    := 0
   PUBLIC SHG_LastFolderImg             := ''
   PUBLIC SHG_CheckTypeOutput           := .F.
   PUBLIC SHG_HtmlFolder                := ''
   PUBLIC SHG_WWW                       := ''
   PUBLIC SHG_BaseOK                    := .F.
   PUBLIC bAutoSyncTab                  := .T.
   PUBLIC bRunParm                      := .F.
   PUBLIC GBL_cRunParm                  := ''
   PUBLIC bBuildRun                     := .F.
   PUBLIC PUB_bForceRunFromMsgOk        := .F.
   PUBLIC bBuildRunBack                 := .F.
   PUBLIC bNumberOnPrg                  := .F.
   PUBLIC bNumberOnHea                  := .F.
   PUBLIC bNumberOnPan                  := .F.
   PUBLIC bPPODisplayado                := .F.
   PUBLIC cPpoCaretPrg                  := '1'
   PUBLIC nGDbfRecord                   := 1
   PUBLIC bDbfAutoView :=               .T.
   PUBLIC oHlpRichEdit                  := US_RichEdit():New()
   PUBLIC vLastOpen                     :={}
   PUBLIC vLastSearch                   :={}
   PUBLIC vSuffix                       := { { DefineMiniGui1  + DefineBorland + DefineHarbour  + Define32bits, 'HMG 1.x with BCC32 and Harbour' }, ;
                                             { DefineMiniGui1  + DefineBorland + DefineXHarbour + Define32bits, 'HMG 1.x with BCC32 and xHarbour' }, ;
                                             { DefineMiniGui3  + DefineMinGW   + DefineHarbour  + Define32bits, 'HMG 3.x with MinGW and Harbour, 32 bits' }, ;
                                             { DefineMiniGui3  + DefineMinGW   + DefineHarbour  + Define64bits, 'HMG 3.x with MinGW and Harbour, 64 bits' }, ;
                                             { DefineExtended1 + DefineBorland + DefineHarbour  + Define32bits, 'HMG Extended with BCC32 and Harbour' }, ;
                                             { DefineExtended1 + DefineBorland + DefineXHarbour + Define32bits, 'HMG Extended with BCC32 and xHarbour' }, ;
                                             { DefineExtended1 + DefineMinGW   + DefineHarbour  + Define32bits, 'HMG Extended with MinGW and Harbour, 32 bits' }, ;
                                             { DefineExtended1 + DefineMinGW   + DefineXHarbour + Define32bits, 'HMG Extended with MinGW and xHarbour, 32 bits' }, ;
                                             { DefineExtended1 + DefineMinGW   + DefineHarbour  + Define64bits, 'HMG Extended with MinGW and Harbour, 64 bits' }, ;
                                             { DefineExtended1 + DefineMinGW   + DefineXHarbour + Define64bits, 'HMG Extended with MinGW and xHarbour, 64 bits' }, ;
                                             { DefineOohg3     + DefineBorland + DefineHarbour  + Define32bits, 'OOHG with BCC32 and Harbour' }, ;
                                             { DefineOohg3     + DefineBorland + DefineXHarbour + Define32bits, 'OOHG with BCC32 and xHarbour' }, ;
                                             { DefineOohg3     + DefineMinGW   + DefineHarbour  + Define32bits, 'OOHG with MinGW and Harbour, 32 bits' }, ;
                                             { DefineOohg3     + DefineMinGW   + DefineXHarbour + Define32bits, 'OOHG with MinGW and xHarbour, 32 bits' }, ;
                                             { DefineOohg3     + DefineMinGW   + DefineHarbour  + Define64bits, 'OOHG with MinGW and Harbour, 64 bits' }, ;
                                             { DefineOohg3     + DefineMinGW   + DefineXHarbour + Define64bits, 'OOHG with MinGW and xHarbour, 64 bits' }, ;
                                             { DefineOohg3     + DefinePelles  + DefineHarbour  + Define32bits, 'OOHG with Pelles C and Harbour, 32 bits' }, ;
                                             { DefineOohg3     + DefinePelles  + DefineXHarbour + Define32bits, 'OOHG with Pelles C and xHarbour, 32 bits' }, ;
                                             { DefineOohg3     + DefinePelles  + DefineHarbour  + Define64bits, 'OOHG with Pelles C and Harbour, 64 bits' }, ;
                                             { DefineOohg3     + DefinePelles  + DefineXHarbour + Define64bits, 'OOHG with Pelles C and xHarbour, 64 bits' } }
   PUBLIC Gbl_Text_DBF                  := ''
   PUBLIC Gbl_Text_Editor               := ''
   PUBLIC Gbl_Text_HMGSIDE              := ''
   PUBLIC Gbl_Text_HMI                  := ''
   PUBLIC Gbl_Comillas_DBF              := '"'
   PUBLIC QPM_KillerProcessLast         := {}
   PUBLIC QPM_KillerbLate               := .T.
   PUBLIC QPM_KillerModule              := ''
   PUBLIC QPM_bKiller                   := .F.
   PUBLIC cPrj_VersionAnt               := '00000000'
   PUBLIC cPrj_Version                  := '00000000'
   PUBLIC Prj_Check_PlaceRCFirst        := .F.
   PUBLIC Prj_Check_IgnoreMainRC        := .F.
   PUBLIC Prj_Check_IgnoreLibRCs        := .F.
   PUBLIC Prj_Check_64bits              := .F.
   PUBLIC Prj_Check_Console             := .F.
   PUBLIC Prj_Check_HarbourIs31         := .T.
   PUBLIC Prj_Check_MT                  := .F.
   PUBLIC Prj_Check_OutputPrefix        := .T.
   PUBLIC Prj_Check_OutputSuffix        := .F.
   PUBLIC Prj_Check_Upx                 := .F.
   PUBLIC Prj_Radio_Cpp                 := DEF_RG_MINGW
   PUBLIC Prj_Radio_DbFTool             := DEF_RG_DBFTOOL
   PUBLIC Prj_Radio_FormTool            := DEF_RG_EDITOR
   PUBLIC Prj_Radio_Harbour             := DEF_RG_HARBOUR
   PUBLIC Prj_Radio_MiniGui             := DEF_RG_OOHG3
   PUBLIC Prj_Radio_OutputCopyMove      := DEF_RG_NONE
   PUBLIC Prj_Radio_OutputRename        := DEF_RG_NONE
   PUBLIC Prj_Radio_OutputType          := DEF_RG_EXE
   PUBLIC Prj_Text_OutputCopyMoveFolder := ''
   PUBLIC Prj_Text_OutputRenameNewName  := ''
   PUBLIC Prj_ExtraRunCmdFINAL          := ''
   PUBLIC Prj_ExtraRunProjQPM           := ''
   PUBLIC Prj_ExtraRunCmdEXE            := ''
   PUBLIC Prj_ExtraRunCmdFREE           := ''
   PUBLIC Prj_ExtraRunCmdQPMParm        := ''
   PUBLIC Prj_ExtraRunCmdEXEParm        := ''
   PUBLIC Prj_ExtraRunCmdFREEParm       := ''
   PUBLIC Prj_ExtraRunType              := 'NONE'
   PUBLIC Prj_ExtraRunQPMRadio          := 'BUILD'
   PUBLIC Prj_ExtraRunQPMLite           := .T.
   PUBLIC Prj_ExtraRunQPMForceFull      := .F.
   PUBLIC Prj_ExtraRunQPMRun            := .F.
   PUBLIC Prj_ExtraRunQPMButtonRun      := .F.
   PUBLIC Prj_ExtraRunQPMClear          := .F.
   PUBLIC Prj_ExtraRunQPMLog            := .F.
   PUBLIC Prj_ExtraRunQPMLogOnlyError   := .F.
   PUBLIC Prj_ExtraRunQPMAutoExit       := .T.
   PUBLIC Prj_ExtraRunExeWait           := .T.
   PUBLIC Prj_ExtraRunExePause          := .T.
   PUBLIC Prj_ExtraRunFreeWait          := .T.
   PUBLIC Prj_ExtraRunFreePause         := .T.
   PUBLIC Prj_IsNew                     := .F.
   PUBLIC cProjectFileName
   PUBLIC PUB_cConvert                  := ''
   PUBLIC vExtraFoldersForSearchC       := {}
   PUBLIC vExtraFoldersForSearchHB      := {}
   PUBLIC bWarningCpp                   := .T.
   PUBLIC vExeNotFound                  := {}
   PUBLIC cExeNotFoundMsg               := {}
   PUBLIC Q_SCRIPT_FILE
   PUBLIC Q_TEMP_LOG
   PUBLIC Q_END_FILE
   PUBLIC Q_MAKE_FILE
   PUBLIC Q_PROGRESS_LOG
   PUBLIC Q_QPM_TMP_RC
   PUBLIC PUB_RunTabChange              := .T.
   PUBLIC PUB_RunTabAutoSync            := .T.
   PUBLIC PUB_MigrateFolderFrom         := ''
   PUBLIC PUB_MigrateVersionFrom        := ''
   PUBLIC PUB_MI_bExeAssociation        := .F.
   PUBLIC PUB_MI_cExeAssociation        := ''
   PUBLIC PUB_MI_nExeAssociationIcon    := 1
   PUBLIC PUB_MI_bExeBackupOption       := .F.
   PUBLIC PUB_MI_bNewFile               := .F.
   PUBLIC PUB_MI_nNewFileSuggested      := 1
   PUBLIC PUB_MI_cNewFileLeyend         := ''
   PUBLIC PUB_MI_nNewFileEmpty          := 1
   PUBLIC PUB_MI_cNewFileUserFile       := ''
   PUBLIC PUB_MI_nDestinationPath       := 1
   PUBLIC PUB_MI_cDestinationPath       := ''
   PUBLIC PUB_MI_nLeyendSuggested       := 1
   PUBLIC PUB_MI_cLeyendUserText        := ''
   PUBLIC PUB_MI_bDesktopShortCut       := .T.
   PUBLIC PUB_MI_nDesktopShortCut       := 1
   PUBLIC PUB_MI_bStartMenuShortCut     := .T.
   PUBLIC PUB_MI_nStartMenuShortCut     := 1
   PUBLIC PUB_MI_bLaunchApplication     := .T.
   PUBLIC PUB_MI_nLaunchApplication     := 1
   PUBLIC PUB_MI_bLaunchBackupOption    := .F.
   PUBLIC PUB_MI_bReboot                := .F.
   PUBLIC PUB_MI_cDefaultLanguage       := 'EN'
   PUBLIC PUB_MI_nInstallerName         := 1
   PUBLIC PUB_MI_cInstallerName         := ''
   PUBLIC PUB_MI_cImage                 := ''
   PUBLIC PUB_MI_bSelectAllPRG          := .F.
   PUBLIC PUB_MI_bSelectAllHEA          := .F.
   PUBLIC PUB_MI_bSelectAllPAN          := .F.
   PUBLIC PUB_MI_bSelectAllDBF          := .F.
   PUBLIC PUB_MI_bSelectAllLIB          := .F.
   PUBLIC vExeList                      := { PUB_cQPM_Folder + DEF_SLASH + 'QPM.EXE', ;          // TODO: check if these files are necessary
                                             PUB_cQPM_Folder + DEF_SLASH + 'QPM.chm', ;
                                             PUB_cQPM_Folder + DEF_SLASH + 'US_dbfview.exe', ;   // by Grigory Filatov
                                             PUB_cQPM_Folder + DEF_SLASH + 'US_dif.exe', ;       // CSDiff file-difference analysis tool
                                             PUB_cQPM_Folder + DEF_SLASH + 'US_difwi.dll', ;     // CSDiff file-difference analysis tool
                                             PUB_cQPM_Folder + DEF_SLASH + 'US_dtree.css', ;     // Tree for HTML Help
                                             PUB_cQPM_Folder + DEF_SLASH + 'US_dtree.im', ;      // Images for HTML Help
                                             PUB_cQPM_Folder + DEF_SLASH + 'US_dtree.js', ;      // Java function for HTML Help
                                             PUB_cQPM_Folder + DEF_SLASH + 'US_hha.dll', ;       // HTML HELP WorkShop Compiler
                                             PUB_cQPM_Folder + DEF_SLASH + 'US_hhc.exe', ;       // HTML HELP WorkShop Compiler
                                             PUB_cQPM_Folder + DEF_SLASH + 'US_impdef.exe', ;    // Generates .DEF from DLL (BCC32)       TODO: Delete and use from compiler
                                             PUB_cQPM_Folder + DEF_SLASH + 'US_implib.exe', ;    // Converts DLL to LIB (BCC32)           TODO: Delete and use from compiler
                                             PUB_cQPM_Folder + DEF_SLASH + 'US_itcc.dll', ;      // HTML HELP WorkShop Compiler
                                             PUB_cQPM_Folder + DEF_SLASH + 'US_make.exe', ;      // Make utility to compile and link
                                             PUB_cQPM_Folder + DEF_SLASH + 'US_msg.exe', ;       // Generates log messages
                                             PUB_cQPM_Folder + DEF_SLASH + 'US_objdump.exe', ;   // Lists MinGW's modules
                                             PUB_cQPM_Folder + DEF_SLASH + 'US_pexports.exe', ;  // Generates .DEF from DLL (MinGW)
                                             PUB_cQPM_Folder + DEF_SLASH + 'US_podump.exe', ;    // Lists modules (Pelles)                TODO: Delete and use from compiler
                                             PUB_cQPM_Folder + DEF_SLASH + 'US_polib.exe', ;     // Lists Libs (Pelles)                   TODO: Delete and use from compiler
                                             PUB_cQPM_Folder + DEF_SLASH + 'US_r2h.exe', ;       // Rtf to HTML
                                             PUB_cQPM_Folder + DEF_SLASH + 'US_reimp.exe', ;     // Generates .DEF from LIB (MinGW)
                                             PUB_cQPM_Folder + DEF_SLASH + 'US_res.exe', ;       // Preprocess rc files for MinGW
                                             PUB_cQPM_Folder + DEF_SLASH + 'US_run.exe', ;       // Executes other programs
                                             PUB_cQPM_Folder + DEF_SLASH + 'US_shell.exe', ;     // Executes batch scripts
                                             PUB_cQPM_Folder + DEF_SLASH + 'US_slash.exe', ;     // Preprocess and compiles C file using MinGW gcc
                                             PUB_cQPM_Folder + DEF_SLASH + 'US_tdump.exe', ;     // Dumps info from EXEOBJLIB modules Check for 64 bits files
                                             PUB_cQPM_Folder + DEF_SLASH + 'US_tlib.exe', ;      // Lists LIB (BCC32)
                                             PUB_cQPM_Folder + DEF_SLASH + 'US_upx.exe' }        // EXE compressor
#ifdef QPM_HOTRECOVERY
   QPM_HotInitPublicVariables()
#endif

// QPM_GLOBALSETTINGS VARIABLES
   /* MiniGui Oficial 1 with BCC */
   QPM_VAR2 PUBLIC Gbl_T_C_      DEF_MG_MINIGUI1  DEF_MG_BORLAND DEF_MG_HARBOUR  DEF_MG_32 := ''           // c compiler
   QPM_VAR2 PUBLIC Gbl_T_C_      DEF_MG_MINIGUI1  DEF_MG_BORLAND DEF_MG_XHARBOUR DEF_MG_32 := ''
   QPM_VAR2 PUBLIC Gbl_T_C_LIBS_ DEF_MG_MINIGUI1  DEF_MG_BORLAND DEF_MG_HARBOUR  DEF_MG_32 := ''           // c compiler libs
   QPM_VAR2 PUBLIC Gbl_T_C_LIBS_ DEF_MG_MINIGUI1  DEF_MG_BORLAND DEF_MG_XHARBOUR DEF_MG_32 := ''
   QPM_VAR2 PUBLIC Gbl_T_M_      DEF_MG_MINIGUI1  DEF_MG_BORLAND DEF_MG_HARBOUR  DEF_MG_32 := ''           // minigui
   QPM_VAR2 PUBLIC Gbl_T_M_      DEF_MG_MINIGUI1  DEF_MG_BORLAND DEF_MG_XHARBOUR DEF_MG_32 := ''
   QPM_VAR2 PUBLIC Gbl_T_M_LIBS_ DEF_MG_MINIGUI1  DEF_MG_BORLAND DEF_MG_HARBOUR  DEF_MG_32 := ''           // minigui libs
   QPM_VAR2 PUBLIC Gbl_T_M_LIBS_ DEF_MG_MINIGUI1  DEF_MG_BORLAND DEF_MG_XHARBOUR DEF_MG_32 := ''
   QPM_VAR2 PUBLIC Gbl_T_P_      DEF_MG_MINIGUI1  DEF_MG_BORLAND DEF_MG_HARBOUR  DEF_MG_32 := ''           // (x)harbour compiler
   QPM_VAR2 PUBLIC Gbl_T_P_      DEF_MG_MINIGUI1  DEF_MG_BORLAND DEF_MG_XHARBOUR DEF_MG_32 := ''
   QPM_VAR2 PUBLIC Gbl_T_P_LIBS_ DEF_MG_MINIGUI1  DEF_MG_BORLAND DEF_MG_HARBOUR  DEF_MG_32 := ''           // (x)harbour compiler libs
   QPM_VAR2 PUBLIC Gbl_T_P_LIBS_ DEF_MG_MINIGUI1  DEF_MG_BORLAND DEF_MG_XHARBOUR DEF_MG_32 := ''
   QPM_VAR2 PUBLIC Gbl_T_N_      DEF_MG_MINIGUI1  DEF_MG_BORLAND DEF_MG_HARBOUR  DEF_MG_32 := ''           // minigui
   QPM_VAR2 PUBLIC Gbl_T_N_      DEF_MG_MINIGUI1  DEF_MG_BORLAND DEF_MG_XHARBOUR DEF_MG_32 := ''
   /* MiniGui Oficial 3 with MinGW */
   QPM_VAR2 PUBLIC Gbl_T_C_      DEF_MG_MINIGUI3  DEF_MG_MINGW   DEF_MG_HARBOUR  DEF_MG_32 := ''
   QPM_VAR2 PUBLIC Gbl_T_C_      DEF_MG_MINIGUI3  DEF_MG_MINGW   DEF_MG_HARBOUR  DEF_MG_64 := ''
   QPM_VAR2 PUBLIC Gbl_T_C_LIBS_ DEF_MG_MINIGUI3  DEF_MG_MINGW   DEF_MG_HARBOUR  DEF_MG_32 := ''
   QPM_VAR2 PUBLIC Gbl_T_C_LIBS_ DEF_MG_MINIGUI3  DEF_MG_MINGW   DEF_MG_HARBOUR  DEF_MG_64 := ''
   QPM_VAR2 PUBLIC Gbl_T_M_      DEF_MG_MINIGUI3  DEF_MG_MINGW   DEF_MG_HARBOUR  DEF_MG_32 := ''
   QPM_VAR2 PUBLIC Gbl_T_M_      DEF_MG_MINIGUI3  DEF_MG_MINGW   DEF_MG_HARBOUR  DEF_MG_64 := ''
   QPM_VAR2 PUBLIC Gbl_T_M_LIBS_ DEF_MG_MINIGUI3  DEF_MG_MINGW   DEF_MG_HARBOUR  DEF_MG_32 := ''
   QPM_VAR2 PUBLIC Gbl_T_M_LIBS_ DEF_MG_MINIGUI3  DEF_MG_MINGW   DEF_MG_HARBOUR  DEF_MG_64 := ''
   QPM_VAR2 PUBLIC Gbl_T_P_      DEF_MG_MINIGUI3  DEF_MG_MINGW   DEF_MG_HARBOUR  DEF_MG_32 := ''
   QPM_VAR2 PUBLIC Gbl_T_P_      DEF_MG_MINIGUI3  DEF_MG_MINGW   DEF_MG_HARBOUR  DEF_MG_64 := ''
   QPM_VAR2 PUBLIC Gbl_T_P_LIBS_ DEF_MG_MINIGUI3  DEF_MG_MINGW   DEF_MG_HARBOUR  DEF_MG_32 := ''
   QPM_VAR2 PUBLIC Gbl_T_P_LIBS_ DEF_MG_MINIGUI3  DEF_MG_MINGW   DEF_MG_HARBOUR  DEF_MG_64 := ''
   QPM_VAR2 PUBLIC Gbl_T_N_      DEF_MG_MINIGUI3  DEF_MG_MINGW   DEF_MG_HARBOUR  DEF_MG_32 := ''
   QPM_VAR2 PUBLIC Gbl_T_N_      DEF_MG_MINIGUI3  DEF_MG_MINGW   DEF_MG_HARBOUR  DEF_MG_64 := ''
   /* MiniGui Extended 1 with BCC */
   QPM_VAR2 PUBLIC Gbl_T_C_      DEF_MG_EXTENDED1 DEF_MG_BORLAND DEF_MG_HARBOUR  DEF_MG_32 := ''
   QPM_VAR2 PUBLIC Gbl_T_C_      DEF_MG_EXTENDED1 DEF_MG_BORLAND DEF_MG_XHARBOUR DEF_MG_32 := ''
   QPM_VAR2 PUBLIC Gbl_T_C_LIBS_ DEF_MG_EXTENDED1 DEF_MG_BORLAND DEF_MG_HARBOUR  DEF_MG_32 := ''
   QPM_VAR2 PUBLIC Gbl_T_C_LIBS_ DEF_MG_EXTENDED1 DEF_MG_BORLAND DEF_MG_XHARBOUR DEF_MG_32 := ''
   QPM_VAR2 PUBLIC Gbl_T_M_      DEF_MG_EXTENDED1 DEF_MG_BORLAND DEF_MG_HARBOUR  DEF_MG_32 := ''
   QPM_VAR2 PUBLIC Gbl_T_M_      DEF_MG_EXTENDED1 DEF_MG_BORLAND DEF_MG_XHARBOUR DEF_MG_32 := ''
   QPM_VAR2 PUBLIC Gbl_T_M_LIBS_ DEF_MG_EXTENDED1 DEF_MG_BORLAND DEF_MG_HARBOUR  DEF_MG_32 := ''
   QPM_VAR2 PUBLIC Gbl_T_M_LIBS_ DEF_MG_EXTENDED1 DEF_MG_BORLAND DEF_MG_XHARBOUR DEF_MG_32 := ''
   QPM_VAR2 PUBLIC Gbl_T_P_      DEF_MG_EXTENDED1 DEF_MG_BORLAND DEF_MG_HARBOUR  DEF_MG_32 := ''
   QPM_VAR2 PUBLIC Gbl_T_P_      DEF_MG_EXTENDED1 DEF_MG_BORLAND DEF_MG_XHARBOUR DEF_MG_32 := ''
   QPM_VAR2 PUBLIC Gbl_T_P_LIBS_ DEF_MG_EXTENDED1 DEF_MG_BORLAND DEF_MG_HARBOUR  DEF_MG_32 := ''
   QPM_VAR2 PUBLIC Gbl_T_P_LIBS_ DEF_MG_EXTENDED1 DEF_MG_BORLAND DEF_MG_XHARBOUR DEF_MG_32 := ''
   QPM_VAR2 PUBLIC Gbl_T_N_      DEF_MG_EXTENDED1 DEF_MG_BORLAND DEF_MG_HARBOUR  DEF_MG_32 := ''
   QPM_VAR2 PUBLIC Gbl_T_N_      DEF_MG_EXTENDED1 DEF_MG_BORLAND DEF_MG_XHARBOUR DEF_MG_32 := ''
   /* MiniGui Extended 1 with MinGW */
   QPM_VAR2 PUBLIC Gbl_T_C_      DEF_MG_EXTENDED1 DEF_MG_MINGW   DEF_MG_HARBOUR  DEF_MG_32 := ''
   QPM_VAR2 PUBLIC Gbl_T_C_      DEF_MG_EXTENDED1 DEF_MG_MINGW   DEF_MG_HARBOUR  DEF_MG_64 := ''
   QPM_VAR2 PUBLIC Gbl_T_C_      DEF_MG_EXTENDED1 DEF_MG_MINGW   DEF_MG_XHARBOUR DEF_MG_32 := ''
   QPM_VAR2 PUBLIC Gbl_T_C_      DEF_MG_EXTENDED1 DEF_MG_MINGW   DEF_MG_XHARBOUR DEF_MG_64 := ''
   QPM_VAR2 PUBLIC Gbl_T_C_LIBS_ DEF_MG_EXTENDED1 DEF_MG_MINGW   DEF_MG_HARBOUR  DEF_MG_32 := ''
   QPM_VAR2 PUBLIC Gbl_T_C_LIBS_ DEF_MG_EXTENDED1 DEF_MG_MINGW   DEF_MG_HARBOUR  DEF_MG_64 := ''
   QPM_VAR2 PUBLIC Gbl_T_C_LIBS_ DEF_MG_EXTENDED1 DEF_MG_MINGW   DEF_MG_XHARBOUR DEF_MG_32 := ''
   QPM_VAR2 PUBLIC Gbl_T_C_LIBS_ DEF_MG_EXTENDED1 DEF_MG_MINGW   DEF_MG_XHARBOUR DEF_MG_64 := ''
   QPM_VAR2 PUBLIC Gbl_T_M_      DEF_MG_EXTENDED1 DEF_MG_MINGW   DEF_MG_HARBOUR  DEF_MG_32 := ''
   QPM_VAR2 PUBLIC Gbl_T_M_      DEF_MG_EXTENDED1 DEF_MG_MINGW   DEF_MG_HARBOUR  DEF_MG_64 := ''
   QPM_VAR2 PUBLIC Gbl_T_M_      DEF_MG_EXTENDED1 DEF_MG_MINGW   DEF_MG_XHARBOUR DEF_MG_32 := ''
   QPM_VAR2 PUBLIC Gbl_T_M_      DEF_MG_EXTENDED1 DEF_MG_MINGW   DEF_MG_XHARBOUR DEF_MG_64 := ''
   QPM_VAR2 PUBLIC Gbl_T_M_LIBS_ DEF_MG_EXTENDED1 DEF_MG_MINGW   DEF_MG_HARBOUR  DEF_MG_32 := ''
   QPM_VAR2 PUBLIC Gbl_T_M_LIBS_ DEF_MG_EXTENDED1 DEF_MG_MINGW   DEF_MG_HARBOUR  DEF_MG_64 := ''
   QPM_VAR2 PUBLIC Gbl_T_M_LIBS_ DEF_MG_EXTENDED1 DEF_MG_MINGW   DEF_MG_XHARBOUR DEF_MG_32 := ''
   QPM_VAR2 PUBLIC Gbl_T_M_LIBS_ DEF_MG_EXTENDED1 DEF_MG_MINGW   DEF_MG_XHARBOUR DEF_MG_64 := ''
   QPM_VAR2 PUBLIC Gbl_T_P_      DEF_MG_EXTENDED1 DEF_MG_MINGW   DEF_MG_HARBOUR  DEF_MG_32 := ''
   QPM_VAR2 PUBLIC Gbl_T_P_      DEF_MG_EXTENDED1 DEF_MG_MINGW   DEF_MG_HARBOUR  DEF_MG_64 := ''
   QPM_VAR2 PUBLIC Gbl_T_P_      DEF_MG_EXTENDED1 DEF_MG_MINGW   DEF_MG_XHARBOUR DEF_MG_32 := ''
   QPM_VAR2 PUBLIC Gbl_T_P_      DEF_MG_EXTENDED1 DEF_MG_MINGW   DEF_MG_XHARBOUR DEF_MG_64 := ''
   QPM_VAR2 PUBLIC Gbl_T_P_LIBS_ DEF_MG_EXTENDED1 DEF_MG_MINGW   DEF_MG_HARBOUR  DEF_MG_32 := ''
   QPM_VAR2 PUBLIC Gbl_T_P_LIBS_ DEF_MG_EXTENDED1 DEF_MG_MINGW   DEF_MG_HARBOUR  DEF_MG_64 := ''
   QPM_VAR2 PUBLIC Gbl_T_P_LIBS_ DEF_MG_EXTENDED1 DEF_MG_MINGW   DEF_MG_XHARBOUR DEF_MG_32 := ''
   QPM_VAR2 PUBLIC Gbl_T_P_LIBS_ DEF_MG_EXTENDED1 DEF_MG_MINGW   DEF_MG_XHARBOUR DEF_MG_64 := ''
   QPM_VAR2 PUBLIC Gbl_T_N_      DEF_MG_EXTENDED1 DEF_MG_MINGW   DEF_MG_HARBOUR  DEF_MG_32 := ''
   QPM_VAR2 PUBLIC Gbl_T_N_      DEF_MG_EXTENDED1 DEF_MG_MINGW   DEF_MG_HARBOUR  DEF_MG_64 := ''
   QPM_VAR2 PUBLIC Gbl_T_N_      DEF_MG_EXTENDED1 DEF_MG_MINGW   DEF_MG_XHARBOUR DEF_MG_32 := ''
   QPM_VAR2 PUBLIC Gbl_T_N_      DEF_MG_EXTENDED1 DEF_MG_MINGW   DEF_MG_XHARBOUR DEF_MG_64 := ''
   /* OOHG with BCC */
   QPM_VAR2 PUBLIC Gbl_T_C_      DEF_MG_OOHG3    DEF_MG_BORLAND DEF_MG_HARBOUR  DEF_MG_32 := ''
   QPM_VAR2 PUBLIC Gbl_T_C_      DEF_MG_OOHG3    DEF_MG_BORLAND DEF_MG_XHARBOUR DEF_MG_32 := ''
   QPM_VAR2 PUBLIC Gbl_T_C_LIBS_ DEF_MG_OOHG3    DEF_MG_BORLAND DEF_MG_HARBOUR  DEF_MG_32 := ''
   QPM_VAR2 PUBLIC Gbl_T_C_LIBS_ DEF_MG_OOHG3    DEF_MG_BORLAND DEF_MG_XHARBOUR DEF_MG_32 := ''
   QPM_VAR2 PUBLIC Gbl_T_M_      DEF_MG_OOHG3    DEF_MG_BORLAND DEF_MG_HARBOUR  DEF_MG_32 := ''
   QPM_VAR2 PUBLIC Gbl_T_M_      DEF_MG_OOHG3    DEF_MG_BORLAND DEF_MG_XHARBOUR DEF_MG_32 := ''
   QPM_VAR2 PUBLIC Gbl_T_M_LIBS_ DEF_MG_OOHG3    DEF_MG_BORLAND DEF_MG_HARBOUR  DEF_MG_32 := ''
   QPM_VAR2 PUBLIC Gbl_T_M_LIBS_ DEF_MG_OOHG3    DEF_MG_BORLAND DEF_MG_XHARBOUR DEF_MG_32 := ''
   QPM_VAR2 PUBLIC Gbl_T_P_      DEF_MG_OOHG3    DEF_MG_BORLAND DEF_MG_HARBOUR  DEF_MG_32 := ''
   QPM_VAR2 PUBLIC Gbl_T_P_      DEF_MG_OOHG3    DEF_MG_BORLAND DEF_MG_XHARBOUR DEF_MG_32 := ''
   QPM_VAR2 PUBLIC Gbl_T_P_LIBS_ DEF_MG_OOHG3    DEF_MG_BORLAND DEF_MG_HARBOUR  DEF_MG_32 := ''
   QPM_VAR2 PUBLIC Gbl_T_P_LIBS_ DEF_MG_OOHG3    DEF_MG_BORLAND DEF_MG_XHARBOUR DEF_MG_32 := ''
   QPM_VAR2 PUBLIC Gbl_T_N_      DEF_MG_OOHG3    DEF_MG_BORLAND DEF_MG_HARBOUR  DEF_MG_32 := ''
   QPM_VAR2 PUBLIC Gbl_T_N_      DEF_MG_OOHG3    DEF_MG_BORLAND DEF_MG_XHARBOUR DEF_MG_32 := ''
   /* OOHG with MinGW */
   QPM_VAR2 PUBLIC Gbl_T_C_      DEF_MG_OOHG3    DEF_MG_MINGW   DEF_MG_HARBOUR  DEF_MG_32 := ''
   QPM_VAR2 PUBLIC Gbl_T_C_      DEF_MG_OOHG3    DEF_MG_MINGW   DEF_MG_HARBOUR  DEF_MG_64 := ''
   QPM_VAR2 PUBLIC Gbl_T_C_      DEF_MG_OOHG3    DEF_MG_MINGW   DEF_MG_XHARBOUR DEF_MG_32 := ''
   QPM_VAR2 PUBLIC Gbl_T_C_      DEF_MG_OOHG3    DEF_MG_MINGW   DEF_MG_XHARBOUR DEF_MG_64 := ''
   QPM_VAR2 PUBLIC Gbl_T_C_LIBS_ DEF_MG_OOHG3    DEF_MG_MINGW   DEF_MG_HARBOUR  DEF_MG_32 := ''
   QPM_VAR2 PUBLIC Gbl_T_C_LIBS_ DEF_MG_OOHG3    DEF_MG_MINGW   DEF_MG_HARBOUR  DEF_MG_64 := ''
   QPM_VAR2 PUBLIC Gbl_T_C_LIBS_ DEF_MG_OOHG3    DEF_MG_MINGW   DEF_MG_XHARBOUR DEF_MG_32 := ''
   QPM_VAR2 PUBLIC Gbl_T_C_LIBS_ DEF_MG_OOHG3    DEF_MG_MINGW   DEF_MG_XHARBOUR DEF_MG_64 := ''
   QPM_VAR2 PUBLIC Gbl_T_M_      DEF_MG_OOHG3    DEF_MG_MINGW   DEF_MG_HARBOUR  DEF_MG_32 := ''
   QPM_VAR2 PUBLIC Gbl_T_M_      DEF_MG_OOHG3    DEF_MG_MINGW   DEF_MG_HARBOUR  DEF_MG_64 := ''
   QPM_VAR2 PUBLIC Gbl_T_M_      DEF_MG_OOHG3    DEF_MG_MINGW   DEF_MG_XHARBOUR DEF_MG_32 := ''
   QPM_VAR2 PUBLIC Gbl_T_M_      DEF_MG_OOHG3    DEF_MG_MINGW   DEF_MG_XHARBOUR DEF_MG_64 := ''
   QPM_VAR2 PUBLIC Gbl_T_M_LIBS_ DEF_MG_OOHG3    DEF_MG_MINGW   DEF_MG_HARBOUR  DEF_MG_32 := ''
   QPM_VAR2 PUBLIC Gbl_T_M_LIBS_ DEF_MG_OOHG3    DEF_MG_MINGW   DEF_MG_HARBOUR  DEF_MG_64 := ''
   QPM_VAR2 PUBLIC Gbl_T_M_LIBS_ DEF_MG_OOHG3    DEF_MG_MINGW   DEF_MG_XHARBOUR DEF_MG_32 := ''
   QPM_VAR2 PUBLIC Gbl_T_M_LIBS_ DEF_MG_OOHG3    DEF_MG_MINGW   DEF_MG_XHARBOUR DEF_MG_64 := ''
   QPM_VAR2 PUBLIC Gbl_T_P_      DEF_MG_OOHG3    DEF_MG_MINGW   DEF_MG_HARBOUR  DEF_MG_32 := ''
   QPM_VAR2 PUBLIC Gbl_T_P_      DEF_MG_OOHG3    DEF_MG_MINGW   DEF_MG_HARBOUR  DEF_MG_64 := ''
   QPM_VAR2 PUBLIC Gbl_T_P_      DEF_MG_OOHG3    DEF_MG_MINGW   DEF_MG_XHARBOUR DEF_MG_32 := ''
   QPM_VAR2 PUBLIC Gbl_T_P_      DEF_MG_OOHG3    DEF_MG_MINGW   DEF_MG_XHARBOUR DEF_MG_64 := ''
   QPM_VAR2 PUBLIC Gbl_T_P_LIBS_ DEF_MG_OOHG3    DEF_MG_MINGW   DEF_MG_HARBOUR  DEF_MG_32 := ''
   QPM_VAR2 PUBLIC Gbl_T_P_LIBS_ DEF_MG_OOHG3    DEF_MG_MINGW   DEF_MG_HARBOUR  DEF_MG_64 := ''
   QPM_VAR2 PUBLIC Gbl_T_P_LIBS_ DEF_MG_OOHG3    DEF_MG_MINGW   DEF_MG_XHARBOUR DEF_MG_32 := ''
   QPM_VAR2 PUBLIC Gbl_T_P_LIBS_ DEF_MG_OOHG3    DEF_MG_MINGW   DEF_MG_XHARBOUR DEF_MG_64 := ''
   QPM_VAR2 PUBLIC Gbl_T_N_      DEF_MG_OOHG3    DEF_MG_MINGW   DEF_MG_HARBOUR  DEF_MG_32 := ''
   QPM_VAR2 PUBLIC Gbl_T_N_      DEF_MG_OOHG3    DEF_MG_MINGW   DEF_MG_HARBOUR  DEF_MG_64 := ''
   QPM_VAR2 PUBLIC Gbl_T_N_      DEF_MG_OOHG3    DEF_MG_MINGW   DEF_MG_XHARBOUR DEF_MG_32 := ''
   QPM_VAR2 PUBLIC Gbl_T_N_      DEF_MG_OOHG3    DEF_MG_MINGW   DEF_MG_XHARBOUR DEF_MG_64 := ''
   /* OOHG with Pelles */
   QPM_VAR2 PUBLIC Gbl_T_C_      DEF_MG_OOHG3    DEF_MG_PELLES  DEF_MG_HARBOUR  DEF_MG_32 := ''
   QPM_VAR2 PUBLIC Gbl_T_C_      DEF_MG_OOHG3    DEF_MG_PELLES  DEF_MG_HARBOUR  DEF_MG_64 := ''
   QPM_VAR2 PUBLIC Gbl_T_C_      DEF_MG_OOHG3    DEF_MG_PELLES  DEF_MG_XHARBOUR DEF_MG_32 := ''
   QPM_VAR2 PUBLIC Gbl_T_C_      DEF_MG_OOHG3    DEF_MG_PELLES  DEF_MG_XHARBOUR DEF_MG_64 := ''
   QPM_VAR2 PUBLIC Gbl_T_C_LIBS_ DEF_MG_OOHG3    DEF_MG_PELLES  DEF_MG_HARBOUR  DEF_MG_32 := ''
   QPM_VAR2 PUBLIC Gbl_T_C_LIBS_ DEF_MG_OOHG3    DEF_MG_PELLES  DEF_MG_HARBOUR  DEF_MG_64 := ''
   QPM_VAR2 PUBLIC Gbl_T_C_LIBS_ DEF_MG_OOHG3    DEF_MG_PELLES  DEF_MG_XHARBOUR DEF_MG_32 := ''
   QPM_VAR2 PUBLIC Gbl_T_C_LIBS_ DEF_MG_OOHG3    DEF_MG_PELLES  DEF_MG_XHARBOUR DEF_MG_64 := ''
   QPM_VAR2 PUBLIC Gbl_T_M_      DEF_MG_OOHG3    DEF_MG_PELLES  DEF_MG_HARBOUR  DEF_MG_32 := ''
   QPM_VAR2 PUBLIC Gbl_T_M_      DEF_MG_OOHG3    DEF_MG_PELLES  DEF_MG_HARBOUR  DEF_MG_64 := ''
   QPM_VAR2 PUBLIC Gbl_T_M_      DEF_MG_OOHG3    DEF_MG_PELLES  DEF_MG_XHARBOUR DEF_MG_32 := ''
   QPM_VAR2 PUBLIC Gbl_T_M_      DEF_MG_OOHG3    DEF_MG_PELLES  DEF_MG_XHARBOUR DEF_MG_64 := ''
   QPM_VAR2 PUBLIC Gbl_T_M_LIBS_ DEF_MG_OOHG3    DEF_MG_PELLES  DEF_MG_HARBOUR  DEF_MG_32 := ''
   QPM_VAR2 PUBLIC Gbl_T_M_LIBS_ DEF_MG_OOHG3    DEF_MG_PELLES  DEF_MG_HARBOUR  DEF_MG_64 := ''
   QPM_VAR2 PUBLIC Gbl_T_M_LIBS_ DEF_MG_OOHG3    DEF_MG_PELLES  DEF_MG_XHARBOUR DEF_MG_32 := ''
   QPM_VAR2 PUBLIC Gbl_T_M_LIBS_ DEF_MG_OOHG3    DEF_MG_PELLES  DEF_MG_XHARBOUR DEF_MG_64 := ''
   QPM_VAR2 PUBLIC Gbl_T_P_      DEF_MG_OOHG3    DEF_MG_PELLES  DEF_MG_HARBOUR  DEF_MG_32 := ''
   QPM_VAR2 PUBLIC Gbl_T_P_      DEF_MG_OOHG3    DEF_MG_PELLES  DEF_MG_HARBOUR  DEF_MG_64 := ''
   QPM_VAR2 PUBLIC Gbl_T_P_      DEF_MG_OOHG3    DEF_MG_PELLES  DEF_MG_XHARBOUR DEF_MG_32 := ''
   QPM_VAR2 PUBLIC Gbl_T_P_      DEF_MG_OOHG3    DEF_MG_PELLES  DEF_MG_XHARBOUR DEF_MG_64 := ''
   QPM_VAR2 PUBLIC Gbl_T_P_LIBS_ DEF_MG_OOHG3    DEF_MG_PELLES  DEF_MG_HARBOUR  DEF_MG_32 := ''
   QPM_VAR2 PUBLIC Gbl_T_P_LIBS_ DEF_MG_OOHG3    DEF_MG_PELLES  DEF_MG_HARBOUR  DEF_MG_64 := ''
   QPM_VAR2 PUBLIC Gbl_T_P_LIBS_ DEF_MG_OOHG3    DEF_MG_PELLES  DEF_MG_XHARBOUR DEF_MG_32 := ''
   QPM_VAR2 PUBLIC Gbl_T_P_LIBS_ DEF_MG_OOHG3    DEF_MG_PELLES  DEF_MG_XHARBOUR DEF_MG_64 := ''
   QPM_VAR2 PUBLIC Gbl_T_N_      DEF_MG_OOHG3    DEF_MG_PELLES  DEF_MG_HARBOUR  DEF_MG_32 := ''
   QPM_VAR2 PUBLIC Gbl_T_N_      DEF_MG_OOHG3    DEF_MG_PELLES  DEF_MG_HARBOUR  DEF_MG_64 := ''
   QPM_VAR2 PUBLIC Gbl_T_N_      DEF_MG_OOHG3    DEF_MG_PELLES  DEF_MG_XHARBOUR DEF_MG_32 := ''
   QPM_VAR2 PUBLIC Gbl_T_N_      DEF_MG_OOHG3    DEF_MG_PELLES  DEF_MG_XHARBOUR DEF_MG_64 := ''

// VARIABLES FOR LIB HANDLING
   /* MiniGui Oficial 1 with BCC */
   QPM_VAR2 PUBLIC IncludeLibs          DEF_MG_MINIGUI1  DEF_MG_BORLAND  DEF_MG_HARBOUR  DEF_MG_32 := {}
   QPM_VAR2 PUBLIC ExcludeLibs          DEF_MG_MINIGUI1  DEF_MG_BORLAND  DEF_MG_HARBOUR  DEF_MG_32 := {}
   QPM_VAR2 PUBLIC vExtraFoldersForLibs DEF_MG_MINIGUI1  DEF_MG_BORLAND  DEF_MG_HARBOUR  DEF_MG_32 := {}
   QPM_VAR2 PUBLIC cLastLibFolder       DEF_MG_MINIGUI1  DEF_MG_BORLAND  DEF_MG_HARBOUR  DEF_MG_32 := ''
   QPM_VAR2 PUBLIC vLibDefault          DEF_MG_MINIGUI1  DEF_MG_BORLAND  DEF_MG_HARBOUR  DEF_MG_32 := {}
   QPM_VAR2 PUBLIC IncludeLibs          DEF_MG_MINIGUI1  DEF_MG_BORLAND  DEF_MG_XHARBOUR DEF_MG_32 := {}
   QPM_VAR2 PUBLIC ExcludeLibs          DEF_MG_MINIGUI1  DEF_MG_BORLAND  DEF_MG_XHARBOUR DEF_MG_32 := {}
   QPM_VAR2 PUBLIC vExtraFoldersForLibs DEF_MG_MINIGUI1  DEF_MG_BORLAND  DEF_MG_XHARBOUR DEF_MG_32 := {}
   QPM_VAR2 PUBLIC cLastLibFolder       DEF_MG_MINIGUI1  DEF_MG_BORLAND  DEF_MG_XHARBOUR DEF_MG_32 := ''
   QPM_VAR2 PUBLIC vLibDefault          DEF_MG_MINIGUI1  DEF_MG_BORLAND  DEF_MG_XHARBOUR DEF_MG_32 := {}
   /* MiniGui Oficial 3 with MinGW */
   QPM_VAR2 PUBLIC IncludeLibs          DEF_MG_MINIGUI3  DEF_MG_MINGW    DEF_MG_HARBOUR  DEF_MG_32 := {}
   QPM_VAR2 PUBLIC ExcludeLibs          DEF_MG_MINIGUI3  DEF_MG_MINGW    DEF_MG_HARBOUR  DEF_MG_32 := {}
   QPM_VAR2 PUBLIC vExtraFoldersForLibs DEF_MG_MINIGUI3  DEF_MG_MINGW    DEF_MG_HARBOUR  DEF_MG_32 := {}
   QPM_VAR2 PUBLIC cLastLibFolder       DEF_MG_MINIGUI3  DEF_MG_MINGW    DEF_MG_HARBOUR  DEF_MG_32 := ''
   QPM_VAR2 PUBLIC vLibDefault          DEF_MG_MINIGUI3  DEF_MG_MINGW    DEF_MG_HARBOUR  DEF_MG_32 := {}
   QPM_VAR2 PUBLIC IncludeLibs          DEF_MG_MINIGUI3  DEF_MG_MINGW    DEF_MG_HARBOUR  DEF_MG_64 := {}
   QPM_VAR2 PUBLIC ExcludeLibs          DEF_MG_MINIGUI3  DEF_MG_MINGW    DEF_MG_HARBOUR  DEF_MG_64 := {}
   QPM_VAR2 PUBLIC vExtraFoldersForLibs DEF_MG_MINIGUI3  DEF_MG_MINGW    DEF_MG_HARBOUR  DEF_MG_64 := {}
   QPM_VAR2 PUBLIC cLastLibFolder       DEF_MG_MINIGUI3  DEF_MG_MINGW    DEF_MG_HARBOUR  DEF_MG_64 := ''
   QPM_VAR2 PUBLIC vLibDefault          DEF_MG_MINIGUI3  DEF_MG_MINGW    DEF_MG_HARBOUR  DEF_MG_64 := {}
   /* MiniGui Extended 1 with BCC */
   QPM_VAR2 PUBLIC IncludeLibs          DEF_MG_EXTENDED1 DEF_MG_BORLAND  DEF_MG_HARBOUR  DEF_MG_32 := {}
   QPM_VAR2 PUBLIC ExcludeLibs          DEF_MG_EXTENDED1 DEF_MG_BORLAND  DEF_MG_HARBOUR  DEF_MG_32 := {}
   QPM_VAR2 PUBLIC vExtraFoldersForLibs DEF_MG_EXTENDED1 DEF_MG_BORLAND  DEF_MG_HARBOUR  DEF_MG_32 := {}
   QPM_VAR2 PUBLIC cLastLibFolder       DEF_MG_EXTENDED1 DEF_MG_BORLAND  DEF_MG_HARBOUR  DEF_MG_32 := ''
   QPM_VAR2 PUBLIC vLibDefault          DEF_MG_EXTENDED1 DEF_MG_BORLAND  DEF_MG_HARBOUR  DEF_MG_32 := {}
   QPM_VAR2 PUBLIC IncludeLibs          DEF_MG_EXTENDED1 DEF_MG_BORLAND  DEF_MG_XHARBOUR DEF_MG_32 := {}
   QPM_VAR2 PUBLIC ExcludeLibs          DEF_MG_EXTENDED1 DEF_MG_BORLAND  DEF_MG_XHARBOUR DEF_MG_32 := {}
   QPM_VAR2 PUBLIC vExtraFoldersForLibs DEF_MG_EXTENDED1 DEF_MG_BORLAND  DEF_MG_XHARBOUR DEF_MG_32 := {}
   QPM_VAR2 PUBLIC cLastLibFolder       DEF_MG_EXTENDED1 DEF_MG_BORLAND  DEF_MG_XHARBOUR DEF_MG_32 := ''
   QPM_VAR2 PUBLIC vLibDefault          DEF_MG_EXTENDED1 DEF_MG_BORLAND  DEF_MG_XHARBOUR DEF_MG_32 := {}
   /* MiniGui Extended 1 with MinGW */
   QPM_VAR2 PUBLIC IncludeLibs          DEF_MG_EXTENDED1 DEF_MG_MINGW    DEF_MG_HARBOUR  DEF_MG_32 := {}
   QPM_VAR2 PUBLIC ExcludeLibs          DEF_MG_EXTENDED1 DEF_MG_MINGW    DEF_MG_HARBOUR  DEF_MG_32 := {}
   QPM_VAR2 PUBLIC vExtraFoldersForLibs DEF_MG_EXTENDED1 DEF_MG_MINGW    DEF_MG_HARBOUR  DEF_MG_32 := {}
   QPM_VAR2 PUBLIC cLastLibFolder       DEF_MG_EXTENDED1 DEF_MG_MINGW    DEF_MG_HARBOUR  DEF_MG_32 := ''
   QPM_VAR2 PUBLIC vLibDefault          DEF_MG_EXTENDED1 DEF_MG_MINGW    DEF_MG_HARBOUR  DEF_MG_32 := {}
   QPM_VAR2 PUBLIC IncludeLibs          DEF_MG_EXTENDED1 DEF_MG_MINGW    DEF_MG_XHARBOUR DEF_MG_32 := {}
   QPM_VAR2 PUBLIC ExcludeLibs          DEF_MG_EXTENDED1 DEF_MG_MINGW    DEF_MG_XHARBOUR DEF_MG_32 := {}
   QPM_VAR2 PUBLIC vExtraFoldersForLibs DEF_MG_EXTENDED1 DEF_MG_MINGW    DEF_MG_XHARBOUR DEF_MG_32 := {}
   QPM_VAR2 PUBLIC cLastLibFolder       DEF_MG_EXTENDED1 DEF_MG_MINGW    DEF_MG_XHARBOUR DEF_MG_32 := ''
   QPM_VAR2 PUBLIC vLibDefault          DEF_MG_EXTENDED1 DEF_MG_MINGW    DEF_MG_XHARBOUR DEF_MG_32 := {}
   QPM_VAR2 PUBLIC IncludeLibs          DEF_MG_EXTENDED1 DEF_MG_MINGW    DEF_MG_HARBOUR  DEF_MG_64 := {}
   QPM_VAR2 PUBLIC ExcludeLibs          DEF_MG_EXTENDED1 DEF_MG_MINGW    DEF_MG_HARBOUR  DEF_MG_64 := {}
   QPM_VAR2 PUBLIC vExtraFoldersForLibs DEF_MG_EXTENDED1 DEF_MG_MINGW    DEF_MG_HARBOUR  DEF_MG_64 := {}
   QPM_VAR2 PUBLIC cLastLibFolder       DEF_MG_EXTENDED1 DEF_MG_MINGW    DEF_MG_HARBOUR  DEF_MG_64 := ''
   QPM_VAR2 PUBLIC vLibDefault          DEF_MG_EXTENDED1 DEF_MG_MINGW    DEF_MG_HARBOUR  DEF_MG_64 := {}
   QPM_VAR2 PUBLIC IncludeLibs          DEF_MG_EXTENDED1 DEF_MG_MINGW    DEF_MG_XHARBOUR DEF_MG_64 := {}
   QPM_VAR2 PUBLIC ExcludeLibs          DEF_MG_EXTENDED1 DEF_MG_MINGW    DEF_MG_XHARBOUR DEF_MG_64 := {}
   QPM_VAR2 PUBLIC vExtraFoldersForLibs DEF_MG_EXTENDED1 DEF_MG_MINGW    DEF_MG_XHARBOUR DEF_MG_64 := {}
   QPM_VAR2 PUBLIC cLastLibFolder       DEF_MG_EXTENDED1 DEF_MG_MINGW    DEF_MG_XHARBOUR DEF_MG_64 := ''
   QPM_VAR2 PUBLIC vLibDefault          DEF_MG_EXTENDED1 DEF_MG_MINGW    DEF_MG_XHARBOUR DEF_MG_64 := {}
   /* OOHG with BCC */
   QPM_VAR2 PUBLIC IncludeLibs          DEF_MG_OOHG3     DEF_MG_BORLAND  DEF_MG_HARBOUR  DEF_MG_32 := {}
   QPM_VAR2 PUBLIC ExcludeLibs          DEF_MG_OOHG3     DEF_MG_BORLAND  DEF_MG_HARBOUR  DEF_MG_32 := {}
   QPM_VAR2 PUBLIC vExtraFoldersForLibs DEF_MG_OOHG3     DEF_MG_BORLAND  DEF_MG_HARBOUR  DEF_MG_32 := {}
   QPM_VAR2 PUBLIC cLastLibFolder       DEF_MG_OOHG3     DEF_MG_BORLAND  DEF_MG_HARBOUR  DEF_MG_32 := ''
   QPM_VAR2 PUBLIC vLibDefault          DEF_MG_OOHG3     DEF_MG_BORLAND  DEF_MG_HARBOUR  DEF_MG_32 := {}
   QPM_VAR2 PUBLIC IncludeLibs          DEF_MG_OOHG3     DEF_MG_BORLAND  DEF_MG_XHARBOUR DEF_MG_32 := {}
   QPM_VAR2 PUBLIC ExcludeLibs          DEF_MG_OOHG3     DEF_MG_BORLAND  DEF_MG_XHARBOUR DEF_MG_32 := {}
   QPM_VAR2 PUBLIC vExtraFoldersForLibs DEF_MG_OOHG3     DEF_MG_BORLAND  DEF_MG_XHARBOUR DEF_MG_32 := {}
   QPM_VAR2 PUBLIC cLastLibFolder       DEF_MG_OOHG3     DEF_MG_BORLAND  DEF_MG_XHARBOUR DEF_MG_32 := ''
   QPM_VAR2 PUBLIC vLibDefault          DEF_MG_OOHG3     DEF_MG_BORLAND  DEF_MG_XHARBOUR DEF_MG_32 := {}
   /* OOHG with MinGW */
   QPM_VAR2 PUBLIC IncludeLibs          DEF_MG_OOHG3     DEF_MG_MINGW    DEF_MG_HARBOUR  DEF_MG_32 := {}
   QPM_VAR2 PUBLIC ExcludeLibs          DEF_MG_OOHG3     DEF_MG_MINGW    DEF_MG_HARBOUR  DEF_MG_32 := {}
   QPM_VAR2 PUBLIC vExtraFoldersForLibs DEF_MG_OOHG3     DEF_MG_MINGW    DEF_MG_HARBOUR  DEF_MG_32 := {}
   QPM_VAR2 PUBLIC cLastLibFolder       DEF_MG_OOHG3     DEF_MG_MINGW    DEF_MG_HARBOUR  DEF_MG_32 := ''
   QPM_VAR2 PUBLIC vLibDefault          DEF_MG_OOHG3     DEF_MG_MINGW    DEF_MG_HARBOUR  DEF_MG_32 := {}
   QPM_VAR2 PUBLIC IncludeLibs          DEF_MG_OOHG3     DEF_MG_MINGW    DEF_MG_XHARBOUR DEF_MG_32 := {}
   QPM_VAR2 PUBLIC ExcludeLibs          DEF_MG_OOHG3     DEF_MG_MINGW    DEF_MG_XHARBOUR DEF_MG_32 := {}
   QPM_VAR2 PUBLIC vExtraFoldersForLibs DEF_MG_OOHG3     DEF_MG_MINGW    DEF_MG_XHARBOUR DEF_MG_32 := {}
   QPM_VAR2 PUBLIC cLastLibFolder       DEF_MG_OOHG3     DEF_MG_MINGW    DEF_MG_XHARBOUR DEF_MG_32 := ''
   QPM_VAR2 PUBLIC vLibDefault          DEF_MG_OOHG3     DEF_MG_MINGW    DEF_MG_XHARBOUR DEF_MG_32 := {}
   QPM_VAR2 PUBLIC IncludeLibs          DEF_MG_OOHG3     DEF_MG_MINGW    DEF_MG_HARBOUR  DEF_MG_64 := {}
   QPM_VAR2 PUBLIC ExcludeLibs          DEF_MG_OOHG3     DEF_MG_MINGW    DEF_MG_HARBOUR  DEF_MG_64 := {}
   QPM_VAR2 PUBLIC vExtraFoldersForLibs DEF_MG_OOHG3     DEF_MG_MINGW    DEF_MG_HARBOUR  DEF_MG_64 := {}
   QPM_VAR2 PUBLIC cLastLibFolder       DEF_MG_OOHG3     DEF_MG_MINGW    DEF_MG_HARBOUR  DEF_MG_64 := ''
   QPM_VAR2 PUBLIC vLibDefault          DEF_MG_OOHG3     DEF_MG_MINGW    DEF_MG_HARBOUR  DEF_MG_64 := {}
   QPM_VAR2 PUBLIC IncludeLibs          DEF_MG_OOHG3     DEF_MG_MINGW    DEF_MG_XHARBOUR DEF_MG_64 := {}
   QPM_VAR2 PUBLIC ExcludeLibs          DEF_MG_OOHG3     DEF_MG_MINGW    DEF_MG_XHARBOUR DEF_MG_64 := {}
   QPM_VAR2 PUBLIC vExtraFoldersForLibs DEF_MG_OOHG3     DEF_MG_MINGW    DEF_MG_XHARBOUR DEF_MG_64 := {}
   QPM_VAR2 PUBLIC cLastLibFolder       DEF_MG_OOHG3     DEF_MG_MINGW    DEF_MG_XHARBOUR DEF_MG_64 := ''
   QPM_VAR2 PUBLIC vLibDefault          DEF_MG_OOHG3     DEF_MG_MINGW    DEF_MG_XHARBOUR DEF_MG_64 := {}
   /* OOHG with Pelles */
   QPM_VAR2 PUBLIC IncludeLibs          DEF_MG_OOHG3     DEF_MG_PELLES   DEF_MG_HARBOUR  DEF_MG_32 := {}
   QPM_VAR2 PUBLIC ExcludeLibs          DEF_MG_OOHG3     DEF_MG_PELLES   DEF_MG_HARBOUR  DEF_MG_32 := {}
   QPM_VAR2 PUBLIC vExtraFoldersForLibs DEF_MG_OOHG3     DEF_MG_PELLES   DEF_MG_HARBOUR  DEF_MG_32 := {}
   QPM_VAR2 PUBLIC cLastLibFolder       DEF_MG_OOHG3     DEF_MG_PELLES   DEF_MG_HARBOUR  DEF_MG_32 := ''
   QPM_VAR2 PUBLIC vLibDefault          DEF_MG_OOHG3     DEF_MG_PELLES   DEF_MG_HARBOUR  DEF_MG_32 := {}
   QPM_VAR2 PUBLIC IncludeLibs          DEF_MG_OOHG3     DEF_MG_PELLES   DEF_MG_XHARBOUR DEF_MG_32 := {}
   QPM_VAR2 PUBLIC ExcludeLibs          DEF_MG_OOHG3     DEF_MG_PELLES   DEF_MG_XHARBOUR DEF_MG_32 := {}
   QPM_VAR2 PUBLIC vExtraFoldersForLibs DEF_MG_OOHG3     DEF_MG_PELLES   DEF_MG_XHARBOUR DEF_MG_32 := {}
   QPM_VAR2 PUBLIC cLastLibFolder       DEF_MG_OOHG3     DEF_MG_PELLES   DEF_MG_XHARBOUR DEF_MG_32 := ''
   QPM_VAR2 PUBLIC vLibDefault          DEF_MG_OOHG3     DEF_MG_PELLES   DEF_MG_XHARBOUR DEF_MG_32 := {}
   QPM_VAR2 PUBLIC IncludeLibs          DEF_MG_OOHG3     DEF_MG_PELLES   DEF_MG_HARBOUR  DEF_MG_64 := {}
   QPM_VAR2 PUBLIC ExcludeLibs          DEF_MG_OOHG3     DEF_MG_PELLES   DEF_MG_HARBOUR  DEF_MG_64 := {}
   QPM_VAR2 PUBLIC vExtraFoldersForLibs DEF_MG_OOHG3     DEF_MG_PELLES   DEF_MG_HARBOUR  DEF_MG_64 := {}
   QPM_VAR2 PUBLIC cLastLibFolder       DEF_MG_OOHG3     DEF_MG_PELLES   DEF_MG_HARBOUR  DEF_MG_64 := ''
   QPM_VAR2 PUBLIC vLibDefault          DEF_MG_OOHG3     DEF_MG_PELLES   DEF_MG_HARBOUR  DEF_MG_64 := {}
   QPM_VAR2 PUBLIC IncludeLibs          DEF_MG_OOHG3     DEF_MG_PELLES   DEF_MG_XHARBOUR DEF_MG_64 := {}
   QPM_VAR2 PUBLIC ExcludeLibs          DEF_MG_OOHG3     DEF_MG_PELLES   DEF_MG_XHARBOUR DEF_MG_64 := {}
   QPM_VAR2 PUBLIC vExtraFoldersForLibs DEF_MG_OOHG3     DEF_MG_PELLES   DEF_MG_XHARBOUR DEF_MG_64 := {}
   QPM_VAR2 PUBLIC cLastLibFolder       DEF_MG_OOHG3     DEF_MG_PELLES   DEF_MG_XHARBOUR DEF_MG_64 := ''
   QPM_VAR2 PUBLIC vLibDefault          DEF_MG_OOHG3     DEF_MG_PELLES   DEF_MG_XHARBOUR DEF_MG_64 := {}

RETURN NIL

FUNCTION QPM_About()
   MsgInfo( 'QPM (QAC based Project Manager)' + CRLF + ;
            'Project Manager For MiniGui (' + QPM_VERSION_DISPLAY_LONG + ')' + CRLF + ;
            CRLF + ;
            'Created by CarozoDeQuilmes (Argentina)' + CRLF + ;
            'Supported by ' + PUB_cQPM_Support_Admin + CRLF + ;
            CRLF + ;
            'Home Site: ' + PUB_cQPM_Support_Link + CRLF + ;
            'Users list: ' + PUB_cQPM_Support_eMail + CRLF + ;
            CRLF + ;
            'Based on MPM Harbour MiniGUI Project Manager' + CRLF + ;
            'Created by Roberto Lopez <roblez@ciudad.com.ar>' + CRLF + ;
            '(c) 2003-2006 Roberto Lopez <roblez@ciudad.com.ar>' + CRLF + ;
            CRLF + ;
            'This release was built with previous QPM version ' + CRLF + ;
            Get_QPM_Builder_VersionDisplay() + ' using: ' + CRLF + ;
            '- ' + MiniGuiVersion() + '    ' + CRLF + ;
            '- ' + hb_Compiler() + CRLF + ;
            '- ' + Version() + CRLF + ;
            CRLF + ;
            'Building date: ' + SubStr( GetLinkDate(), 1, 4 ) + '.' + SubStr( GetLinkDate(), 5, 2 ) + '.' + SubStr( GetLinkDate(), 7, 2 ) + CRLF + ;
            'Building time: ' + GetLinkTime(), 'About QPM' ) // this is not translated
RETURN .T.

FUNCTION QPM_Licence()
   MsgInfo( hb_LoadString( ID_LICENSE_LINE_1 ) + CRLF + ;
            CRLF + ;
            hb_LoadString( ID_LICENSE_LINE_2 ) + CRLF + ;
            hb_LoadString( ID_LICENSE_LINE_3 ) + CRLF + ;
            CRLF + ;
            hb_LoadString( ID_LICENSE_LINE_4 ) + CRLF + ;
            CRLF + ;
            hb_LoadString( ID_LICENSE_LINE_5 ) + ' ' + hb_LoadString( ID_LICENSE_LINE_6 ) + CRLF + ;
            CRLF + ;
            hb_LoadString( ID_LICENSE_LINE_7 ) + CRLF + ;
            hb_LoadString( ID_LICENSE_LINE_8 ), hb_LoadString( ID_LICENSE_LINE_9 ) ) // this is not translated
RETURN .T.

FUNCTION QPM_CopyFile( orig, dest )

   LOCAL bError, oSaveHandler

   IF File( orig )
      IF File( dest )
         ferase( dest )

         IF File( dest )
            RETURN .F.
         ENDIF
      ENDIF

      bError := .F.
      oSaveHandler := errorblock( { |x| break(x) } )
      BEGIN SEQUENCE
         COPY FILE ( orig ) TO ( dest )
      RECOVER
         bError := .T.
      END SEQUENCE
      errorblock( oSaveHandler )

      IF ! bError .AND. File( dest )
         RETURN .T.
      ENDIF
   ENDIF

RETURN .F.

FUNCTION US_GetFile( aFilter, title, cIniFolder, multiselect, nochangedir )
   LOCAL reto
   SetMGWaitHide()
   Reto := US_GetFile2( aFilter, title, cIniFolder, multiselect, nochangedir )
   SetMGWaitShow()
RETURN reto

FUNCTION US_GetFile2( aFilter, title, cIniFolder, multiselect, nochangedir )
   LOCAL c := '', cfiles, fileslist := {}, n
   IF aFilter == NIL
      aFilter := {}
   ENDIF
   FOR n := 1 TO Len( aFilter )
      c += aFilter[n][1] + Chr( 0 ) + aFilter[n][2] + Chr( 0 )
   NEXT
   IF ValType( multiselect ) == 'U'
      multiselect := .F.
   ENDIF
   IF ! multiselect
      RETURN ( US_C_GetFile( c, title, cIniFolder, multiselect,nochangedir ) )
   ELSE
      cfiles := US_C_GetFile( c, title, cIniFolder, multiselect,nochangedir )
      IF Len( cfiles ) > 0
         IF ValType( cfiles ) == 'A'
            fileslist := aclone( cfiles )
         ELSE
            AAdd( fileslist, cfiles )
         ENDIF
      ENDIF
      RETURN ( fileslist )
   ENDIF
RETURN NIL

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
            File( cDirLib + DEF_SLASH + GetMiniGuiName() )
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
            File( cDirLib + DEF_SLASH + GetMiniGuiName() )
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
            File( cDirLib + DEF_SLASH + GetMiniGuiName() )
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
            File( cDirLib + DEF_SLASH + GetMiniGuiName() )
            bReto:=.T.
         endif
      case cTipo == "C_" + DefineExtended1 + DefineMinGW
         if File( cDir + DEF_SLASH + "BIN" + DEF_SLASH + "GCC.EXE" )
            bReto:=.T.
         endif
      // OOHG
      case cTipo == DefineOohg3 + DefineBorland
         if File( cDir + DEF_SLASH + "INCLUDE" + DEF_SLASH + "oohg.ch" ) .and. ;
            File( cDirLib + DEF_SLASH + GetMiniGuiName() )
            bReto:=.T.
         endif
      case cTipo == "C_" + DefineOohg3 + DefineBorland
         if File( cDir + DEF_SLASH + "BIN" + DEF_SLASH + "BCC32.EXE" )
            bReto:=.T.
         endif
      case cTipo == DefineOohg3 + DefineMinGW
         if File( cDir + DEF_SLASH + "INCLUDE" + DEF_SLASH + "oohg.ch" ) .and. ;
            File( cDirLib + DEF_SLASH + GetMiniGuiName() )
            bReto:=.T.
         endif
      case cTipo == "C_" + DefineOohg3 + DefineMinGW
         if File( cDir + DEF_SLASH + "BIN" + DEF_SLASH + "GCC.EXE" )
            bReto:=.T.
         endif
      case cTipo == DefineOohg3 + DefinePelles
         if File( cDir + DEF_SLASH + "INCLUDE" + DEF_SLASH + "oohg.ch" ) .and. ;
            File( cDirLib + DEF_SLASH + GetMiniGuiName() )
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
            US_Log( "Tipo de Directorio inválido: " + cTipo )
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
         US_Log( "Error in write file to: " + p1 + HB_OsNewLine() + "Required from: " + US_StackList() )
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

Function GetMiniGuiName()
Return &( "Gbl_T_N_" + GetSuffix() )

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

Function Get_RC_FileName()
   Local cNombre
   do case
   case GetMiniGuiSuffix() == DefineOohg3
      if QPM_IsXHarbour() .and. File( GetMiniGuiFolder() + DEF_SLASH + 'RESOURCES' + DEF_SLASH + "xoohg.rc" )
         cNombre := "xoohg.rc"
      elseif GetCppSuffix() == DefineBorland .and. File( GetMiniGuiFolder() + DEF_SLASH + 'RESOURCES' + DEF_SLASH + "oohg_bcc.rc" )
         cNombre := "oohg_bcc.rc"
      else
         cNombre := "oohg.rc"
      endif
   case ( GetMiniGuiSuffix() + GetCppSuffix() ) == DefineMiniGui3 + DefineMinGW
      if QPM_IsXHarbour() .and. File( GetMiniGuiFolder() + DEF_SLASH + 'RESOURCES' + DEF_SLASH + "xhmg.rc" )
         cNombre := "xhmg"
      else
         cNombre := "hmg"
      endif
      cNombre += if( Prj_Check_64bits, "64.rc", "32.rc" )
   case ( GetMiniGuiSuffix() + GetCppSuffix() ) == DefineExtended1 + DefineMinGW
      if QPM_IsXHarbour() .and. File( GetMiniGuiFolder() + DEF_SLASH + 'RESOURCES' + DEF_SLASH + "xhmg.rc" )
         cNombre := "xhmg.rc"
      elseif QPM_IsXHarbour() .and. File( GetMiniGuiFolder() + DEF_SLASH + 'RESOURCES' + DEF_SLASH + "xminigui.rc" )
         cNombre := "xminigui.rc"
      elseif File( GetMiniGuiFolder() + DEF_SLASH + 'RESOURCES' + DEF_SLASH + "hmg.rc" )
         cNombre := "hmg.rc"
      else
         cNombre := "minigui.rc"
      endif
   otherwise
      if QPM_IsXHarbour() .and. File( GetMiniGuiFolder() + DEF_SLASH + 'RESOURCES' + DEF_SLASH + "xminigui.rc" )
         cNombre := "xminigui.rc"
      else
         cNombre := "minigui.rc"
      endif
   endcase
Return cNombre

Function Get_RES_FileName()
   Local cNombre
   do case
   case GetMiniGuiSuffix() == DefineOohg3
      if QPM_IsXHarbour() .and. File( GetMiniGuiFolder() + DEF_SLASH + 'RESOURCES' + DEF_SLASH + "xoohg.rc" )
         cNombre := "xoohg.res"
      elseif GetCppSuffix() == DefineBorland .and. File( GetMiniGuiFolder() + DEF_SLASH + 'RESOURCES' + DEF_SLASH + "oohg_bcc.rc" )
         cNombre := "oohg.res"
      else
         cNombre := "oohg.res"
      endif
   case ( GetMiniGuiSuffix() + GetCppSuffix() ) == DefineMiniGui3 + DefineMinGW
      if QPM_IsXHarbour() .and. File( GetMiniGuiFolder() + DEF_SLASH + 'RESOURCES' + DEF_SLASH + "xhmg.rc" )
         cNombre := "xhmg.res"
      else
         cNombre := "hmg.res"
      endif
      cNombre += if( Prj_Check_64bits, "64", "32" )
   case ( GetMiniGuiSuffix() + GetCppSuffix() ) == DefineExtended1 + DefineMinGW
      if QPM_IsXHarbour() .and. File( GetMiniGuiFolder() + DEF_SLASH + 'RESOURCES' + DEF_SLASH + "xhmg.rc" )
         cNombre := "xhmg.res"
      elseif QPM_IsXHarbour() .and. File( GetMiniGuiFolder() + DEF_SLASH + 'RESOURCES' + DEF_SLASH + "xminigui.rc" )
         cNombre := "xminigui.res"
      elseif File( GetMiniGuiFolder() + DEF_SLASH + 'RESOURCES' + DEF_SLASH + "hmg.rc" )
         cNombre := "hmg.res"
      else
         cNombre := "minigui.res"
      endif
   otherwise
      if QPM_IsXHarbour() .and. File( GetMiniGuiFolder() + DEF_SLASH + 'RESOURCES' + DEF_SLASH + "xminigui.rc" )
         cNombre := "xminigui.res"
      else
         cNombre := "minigui.res"
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
   cType := GetMiniGuiSuffix()       // + GetCppSuffix()
   do case
   case cType == DefineOohg3         // + DefineMinGW
      cNombre := "oohgpath"
   case cType == DefineExtended1     // + DefineMinGW
      cNombre := "HMGRPATH"
   case cType == DefineMiniGui3      // + DefineMinGW
      cNombre := "HMGRPATH"
   otherwise
      cNombre := "MINIGUIPATH"
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
   cLinea := US_StrTran( cLinea, PUB_cQPM_Folder + DEF_SLASH,             "<QPMFolder>" + DEF_SLASH )
   cLinea := US_StrTran( cLinea, PUB_cProjectFolder + DEF_SLASH,          "<ProjectFolder>" + DEF_SLASH )
   cLinea := US_StrTran( cLinea, PUB_cThisFolder + DEF_SLASH,             "<ThisFolder>" + DEF_SLASH )
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
   Local cBorland55 := cAux1 + "land C++ - Copyright 1999 Inprise Corporation"
   Local cBorland58 := cAux1 + "land C++ - Copyright 2005 Borland Corporation"
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
      ( at( cBorland55, MemoAux ) > 0 .or. at( cBorland58, MemoAux ) > 0 ) .and. ;
      at( cMinGW  , MemoAux ) = 0 .and. ;
      at( cMinGW2 , MemoAux ) = 0 .and. ;
      at( cPelles , MemoAux ) = 0
      Return "BORLAND"
   endif
   if Upper( US_FileNameOnlyExt( cFile ) ) == "EXE" .and. ;
      at( cBorland55, MemoAux ) = 0 .and. ;
      at( cBorland58, MemoAux ) = 0 .and. ;
      at( cMinGW  , MemoAux ) > 0 .and. ;
      at( cMinGW2 , MemoAux ) > 0 .and. ;
      at( cPelles , MemoAux ) = 0
      Return "MINGW"
   endif
   if Upper( US_FileNameOnlyExt( cFile ) ) == "EXE" .and. ;
      at( cBorland55, MemoAux ) = 0 .and. ;
      at( cBorland58, MemoAux ) = 0 .and. ;
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
   if Upper( US_FileNameOnlyExt( cFile ) ) == "RES" .and. ;
      at( CHR(0)+CHR(0)+CHR(0)+CHR(0)+CHR(32)+CHR(0)+CHR(0)+CHR(0)+CHR(255)+CHR(255)+CHR(0)+CHR(0)+CHR(255)+CHR(255), MemoAux ) > 0
      Return "BORLAND"
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
      case GetProperty( 'VentanaMain', 'GPrgFiles', 'itemcount' ) == 0
         // no sources
         cOutputName        := '.' + lower( OutputExt() )
         cOutputNameDisplay := '.' + lower( OutputExt() )
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

PROCEDURE QPM_Execute( cCMD, cParms, bWait, nSize, RunWaitFileStop )
   LOCAL RunWaitControlFile, RunWaitParms, cSize
   DEFAULT cParms TO ""
   DEFAULT bWait TO .F.
   DEFAULT nSize TO 1
   IF ! bWait
      DO CASE
      CASE nSize == -1           // hide
         EXECUTE FILE ( cCMD ) PARAMETERS ( cParms ) HIDE
      CASE nSize == 0            // minimized
         EXECUTE FILE ( cCMD ) PARAMETERS ( cParms ) MINIMIZE
      CASE nSize == 1            // normal
         EXECUTE FILE ( cCMD ) PARAMETERS ( cParms )
      CASE nSize == 2            // maximized
         EXECUTE FILE ( cCMD ) PARAMETERS ( cParms ) MAXIMIZE
      OTHERWISE
         MsgInfo( "Invalid nSize parm in function QPM_Execute: " + US_VarToStr( nSize ) )
      ENDCASE
   ELSE
      DO CASE
      CASE nSize == -1           // hide
         cSize := "HIDE"
      CASE nSize == 0            // minimized
         cSize := "MINIMIZE"
      CASE nSize == 1            // normal
         cSize := "NORMAL"
      CASE nSize == 2            // maximized
         cSize := "MAXIMIZE"
      OTHERWISE
         MsgInfo( "Invalid nSize parm in function QPM_Execute (2): " + US_VarToStr( nSize ) )
      ENDCASE
      RunWaitControlFile := US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + "_" + PUB_cSecu + "RWCF" + US_DateTimeCen() + ".cnt"
      RunWaitParms       := US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + "_" + PUB_cSecu + "RWP" + US_DateTimeCen() + ".cng"
      QPM_MemoWrit( RunWaitParms, "Run Wait Parms" + HB_OsNewLine() + ;
                               "COMMAND " + cCMD + " " + cParms + HB_OsNewLine() + ;
                               "CONTROL " + RunWaitControlFile + HB_OsNewLine() + ;
                               "MODE " + cSize )
      QPM_MemoWrit( RunWaitControlFile, "Run Wait Control File" )
      EXECUTE FILE ( US_ShortName( PUB_cQPM_Folder ) + DEF_SLASH + "US_Run.exe" ) PARAMETERS ( "QPM " + RunWaitParms ) HIDE
      DO WHILE File( RunWaitControlFile )
         DO EVENTS
         IF GetMGWaitStop()
            IF RunWaitFileStop != NIL
               QPM_MemoWrit( RunWaitFileStop, "Run Wait File Stop" )
               DO WHILE File( RunWaitFileStop ) .and. file( RunWaitControlFile )
                  DO EVENTS
               ENDDO
               FErase( RunWaitFileStop )
            ENDIF
         ENDIF
      ENDDO
   ENDIF
RETURN

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
   DO EVENTS
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
// obviamente que para esa prueba hay que sacar la pregunta de getActiveWindow()
// us_log( GetFocus(), .F. )
// us_log( GetActiveWindow(), .F. )
// us_log( _HMG_aFormNames[ AScan( _HMG_aFormHandles, GetActiveWindow() ) ], .F. )
// AScan( US_StackListArray(), { |x| x = "QPM_TIMER_" .or. substr( x, 3 ) = "QPM_TIMER_" } ) > 0    // Notese que la comparacion es por "="
//
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
