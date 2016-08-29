/*
 * $Id$
 */

/*
 *    QPM - QAC based Project Manager
 *
 *    Copyright 2011-2016 Fernando Yurisich <fernando.yurisich@gmail.com>
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
#include "QPM.ch"

#define SCRIPT_FILE  ( US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + '_' + PUB_cSecu + 'Script.ld' )
#define TEMP_LOG     ( US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + '_' + PUB_cSecu + 'Temp.Log' )
#define END_FILE     ( US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + '_' + PUB_cSecu + 'End.Txt' )
#define BUILD_BAT    ( US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + '_' + PUB_cSecu + 'Build.Bat' )
#define MAKE_FILE    ( US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + '_' + PUB_cSecu + 'Temp.Bc' )
#define PROGRESS_LOG ( US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + '_' + PUB_cSecu + 'Progress.Log' )
#define RUN_FILE     ( US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + '_' + PUB_cSecu + 'RunShell.bat' )
#define QPM_GET_DEF  ( US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + '_' + PUB_cSecu + 'QPM_gt.prg' )


Function Main( PAR_cP01, PAR_cP02, PAR_cP03, PAR_cP04, PAR_cP05, PAR_cP06, PAR_cP07, PAR_cP08, PAR_cP09, PAR_cP10, ;
               PAR_cP11, PAR_cP12, PAR_cP13, PAR_cP14, PAR_cP15, PAR_cP16, PAR_cP17, PAR_cP18, PAR_cP19, PAR_cP20 )
   Local Folder, FileName, i, nPos, LogIni, LOC_cParam, nRow, nCol, nWidth, nHeight

   Request DBFCDX, DBFFPT
   Rddsetdefault( 'DBFCDX' )

// LOAD PARAMETERS
   PAR_cP01 = IIF( PAR_cP01 = NIL, '', PAR_cP01 )
   PAR_cP02 = IIF( PAR_cP02 = NIL, '', PAR_cP02 )
   PAR_cP03 = IIF( PAR_cP03 = NIL, '', PAR_cP03 )
   PAR_cP04 = IIF( PAR_cP04 = NIL, '', PAR_cP04 )
   PAR_cP05 = IIF( PAR_cP05 = NIL, '', PAR_cP05 )
   PAR_cP06 = IIF( PAR_cP06 = NIL, '', PAR_cP06 )
   PAR_cP07 = IIF( PAR_cP07 = NIL, '', PAR_cP07 )
   PAR_cP08 = IIF( PAR_cP08 = NIL, '', PAR_cP08 )
   PAR_cP09 = IIF( PAR_cP09 = NIL, '', PAR_cP09 )
   PAR_cP10 = IIF( PAR_cP10 = NIL, '', PAR_cP10 )
   PAR_cP11 = IIF( PAR_cP11 = NIL, '', PAR_cP11 )
   PAR_cP12 = IIF( PAR_cP12 = NIL, '', PAR_cP12 )
   PAR_cP13 = IIF( PAR_cP13 = NIL, '', PAR_cP13 )
   PAR_cP14 = IIF( PAR_cP14 = NIL, '', PAR_cP14 )
   PAR_cP15 = IIF( PAR_cP15 = NIL, '', PAR_cP15 )
   PAR_cP16 = IIF( PAR_cP16 = NIL, '', PAR_cP16 )
   PAR_cP17 = IIF( PAR_cP17 = NIL, '', PAR_cP17 )
   PAR_cP18 = IIF( PAR_cP18 = NIL, '', PAR_cP18 )
   PAR_cP19 = IIF( PAR_cP19 = NIL, '', PAR_cP19 )
   PAR_cP20 = IIF( PAR_cP20 = NIL, '', PAR_cP20 )
   LOC_cParam := alltrim( PAR_cP01 + ' ' + PAR_cP02 + ' ' + PAR_cP03 + ' ' + PAR_cP04 + ' ' + PAR_cP05 + ' ' + ;
                          PAR_cP06 + ' ' + PAR_cP07 + ' ' + PAR_cP08 + ' ' + PAR_cP09 + ' ' + PAR_cP10 + ' ' + ;
                          PAR_cP11 + ' ' + PAR_cP12 + ' ' + PAR_cP13 + ' ' + PAR_cP14 + ' ' + PAR_cP15 + ' ' + ;
                          PAR_cP16 + ' ' + PAR_cP17 + ' ' + PAR_cP18 + ' ' + PAR_cP19 + ' ' + PAR_cP20 )

// PRIORITY
   PUBLIC PUB_QPM_bHigh := .F.
   QPM_SetProcessPriority( 'HIGH' )

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
   PUBLIC MAIN_HAS_FOCUS                := .F.
   PUBLIC PUB_cQPM_Support_Link         := 'http://qpm.sourceforge.net'
   PUBLIC PUB_cQPM_Support_Admin        := 'Fernando Yurisich (Uruguay)'
   PUBLIC PUB_cQPM_Support_eMail        := 'qpm-users@lists.sourceforge.net'
   PUBLIC PUB_cStatusLabel              := 'Status: Idle'
   PUBLIC PUB_MenuPrjOptions            := 'Project Options'
   PUBLIC PUB_MenuGblOptions            := 'Global Options (folders for [x]Harbour, MiniGUI, C++ and others)'
   PUBLIC PUB_cCharTab                  := CHR( 09 )
   PUBLIC PUB_cCharFileNameTemp         := '_'                                                        // $ trae problemas con Make de MinGW, # no genera uno de los Temp.log
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
   PUBLIC PUB_bW800                     := if( GetDesktopWidth() <     1024, .T., .F. )
   PUBLIC PUB_cAutoLog                  := ''
   PUBLIC PUB_cAutoLogTmp               := ''
   PUBLIC PUB_bLogOnlyError             := .F.
   PUBLIC PUB_cSecu                     := dtos(date()) + US_strCero( int(seconds()), 5 ) + PUB_cCharFileNameTemp
   PUBLIC PUB_cUS_RedirOpt              := ' -eo -o '
   PUBLIC PUB_bDebugActive              := .F.
   PUBLIC PUB_bDebugActiveAnt           := .F.
   PUBLIC PUB_bIsProcessing             := .f.
   PUBLIC PUB_xHarbourMT                := ''
   PUBLIC PUB_bAutoInc                  := .T.
   PUBLIC IsBorland                     := .F.
   PUBLIC IsMinGW                       := .F.
   PUBLIC IsPelles                      := .F.
   PUBLIC ProgLength                    := 0
   PUBLIC bAutoExit                     := .F.
   PUBLIC cUpxOpt                       := '--no-progress'                                            // Por default comprime los iconos excepto el primero, para no comprimir agregar '--compress-icons=0'
   PUBLIC LibsActiva                    := ''
   PUBLIC PagePRG                       := if( PUB_bW800, 'SRC', 'Sources' )
   PUBLIC PageHEA                       := 'H && CH'
   PUBLIC PagePAN                       := 'FMG && RC'
   PUBLIC PageDBF                       := 'DBF'
   PUBLIC PageLIB                       := 'LIB'
   PUBLIC PageHLP                       := 'SHG'
   PUBLIC PageSysout                    := if( PUB_bW800, 'Log', 'Log Build Process' )
   PUBLIC PageOUT                       := if( PUB_bW800, 'Out', 'Output Error/Module' )
   PUBLIC PageWWW                       := if( PUB_bW800, 'www', 'www' )
   PUBLIC PageCdQ                       := if( PUB_bW800, 'QPM', 'QPM' )
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
   PUBLIC PUB_nGridImgSearchOk          := 3                                                          // Esto quiere decir que para activar esta imagen hay que activar el bit 3
   PUBLIC PUB_nGridImgEdited            := 4
   PUBLIC PUB_nGridImgSearchNotOk       := 5
   PUBLIC PUB_nGridImgHlpGlobalFoot     := 6
   PUBLIC PUB_nGridImgHlpWelcome        := 7
   PUBLIC PUB_nGridImgHlpBook           := 8
   PUBLIC PUB_nGridImgHlpPage           := 9
   PUBLIC PUB_nGridImgTop               := 9                                                          // igual a la ultima variable GridImg ...
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
                                             'GridHlpPageSearchOk' }                                  // See Function GridImage
   PUBLIC bGlobalSearch                 := .F.                                                        // Flag general para saber si estoy en Global Search
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
   PUBLIC nColLibStatus                 := NCOLINCSTATUS                                              // AuxIliar para procesos que no diferencian entre inc y exc
   PUBLIC nColLibFullName               := NCOLINCFULLNAME                                            // Auxliar para procesos que no diferencian entre inc y exc
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
   PUBLIC bPpoDisplayado                := .F.
   PUBLIC cPpoCaretPrg                  := '1'
   PUBLIC nGDbfRecord                   := 1
   PUBLIC bDbfAutoView :=               .T.
   PUBLIC oHlpRichEdit                  := US_RichEdit():New()
   PUBLIC vLastOpen                     :={}
   PUBLIC vLastSearch                   :={}
   PUBLIC vSuffix                       := { { DefineMiniGui1  + DefineBorland + DefineHarbour  + Define32bits, 'HMG 1.x with BCC32 and Harbour' }, ;                  
                                             { DefineMiniGui1  + DefineBorland + DefineXHarbour + Define32bits, 'HMG 1.x with BCC32 and xHarbour' }, ;
                                             { DefineMiniGui3  + DefineMinGW   + DefineHarbour  + Define32bits, 'HMG 3.x with MinGW and Harbour, 32 bits' }, ;
                                             { DefineMiniGui3  + DefineMinGW   + DefineXHarbour + Define32bits, 'HMG 3.x with MinGW and xHarbour, 32 bits' }, ;
                                             { DefineMiniGui3  + DefineMinGW   + DefineHarbour  + Define64bits, 'HMG 3.x with MinGW and Harbour, 64 bits' }, ;
                                             { DefineMiniGui3  + DefineMinGW   + DefineXHarbour + Define64bits, 'HMG 3.x with MinGW and xHarbour, 64 bits' }, ;
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
   PUBLIC Prj_Check_64bits              := .F.
   PUBLIC Prj_Check_Console             := .F.             
   PUBLIC Prj_Check_HarbourIs31         := .T.
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
   PUBLIC vExtraFoldersForSearch        := {}
   PUBLIC bWarningCpp                   := .T.
   PUBLIC vExeNotFound                  := {}
   PUBLIC cExeNotFoundMsg               := {}
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
   PUBLIC PUB_MI_vFiles                 := {}
   PUBLIC PUB_MI_bSelectAllPRG          := .F.
   PUBLIC PUB_MI_bSelectAllHEA          := .F.
   PUBLIC PUB_MI_bSelectAllPAN          := .F.
   PUBLIC PUB_MI_bSelectAllDBF          := .F.
   PUBLIC PUB_MI_bSelectAllLIB          := .F.
   PUBLIC vExeList                      := { PUB_cQPM_Folder + DEF_SLASH + 'QPM.EXE', ;          // TODO: Verificar uso de estos exes
                                             PUB_cQPM_Folder + DEF_SLASH + 'QPM.chm', ;
                                             PUB_cQPM_Folder + DEF_SLASH + 'us_dbfview.exe', ;   // by Grigory Filatov
                                             PUB_cQPM_Folder + DEF_SLASH + 'us_dif.exe', ;       // CSDiff file-difference analysis tool
                                             PUB_cQPM_Folder + DEF_SLASH + 'us_difwi.dll', ;     // CSDiff file-difference analysis tool
                                             PUB_cQPM_Folder + DEF_SLASH + 'us_dtree.css', ;     // Tree for HTML Help
                                             PUB_cQPM_Folder + DEF_SLASH + 'us_dtree.im', ;      // Images for HTML Help
                                             PUB_cQPM_Folder + DEF_SLASH + 'us_dtree.js', ;      // Java function for HTML Help
                                             PUB_cQPM_Folder + DEF_SLASH + 'us_hha.dll', ;       // HTML HELP WorkShop Compiler
                                             PUB_cQPM_Folder + DEF_SLASH + 'us_hhc.exe', ;       // HTML HELP WorkShop Compiler
                                             PUB_cQPM_Folder + DEF_SLASH + 'us_impdef.exe', ;    // Generates .DEF from DLL (BCC32)       TODO: Delete and use from compiler
                                             PUB_cQPM_Folder + DEF_SLASH + 'us_implib.exe', ;    // Converts DLL to LIB (BCC32)           TODO: Delete and use from compiler
                                             PUB_cQPM_Folder + DEF_SLASH + 'us_itcc.dll', ;      // HTML HELP WorkShop Compiler
                                             PUB_cQPM_Folder + DEF_SLASH + 'us_make.exe', ;      // Make utility to compile and link
                                             PUB_cQPM_Folder + DEF_SLASH + 'us_msg.exe', ;       // Generates log messages
                                             PUB_cQPM_Folder + DEF_SLASH + 'us_objdump.exe', ;   // Lists MinGW's modules
                                             PUB_cQPM_Folder + DEF_SLASH + 'us_pexports.exe', ;  // Generates .DEF from DLL (MinGW)
                                             PUB_cQPM_Folder + DEF_SLASH + 'us_podump.exe', ;    // Lists modules (Pelles)                TODO: Delete and use from compiler
                                             PUB_cQPM_Folder + DEF_SLASH + 'us_polib.exe', ;     // Lists Libs (Pelles)                   TODO: Delete and use from compiler
                                             PUB_cQPM_Folder + DEF_SLASH + 'us_r2h.exe', ;       // Rtf to HTML
                                             PUB_cQPM_Folder + DEF_SLASH + 'us_reimp.exe', ;     // Generates .DEF from LIB (MinGW)
                                             PUB_cQPM_Folder + DEF_SLASH + 'us_res.exe', ;       // Preprocess rc files for MinGW
                                             PUB_cQPM_Folder + DEF_SLASH + 'us_run.exe', ;       // Executes other programs
                                             PUB_cQPM_Folder + DEF_SLASH + 'us_shell.exe', ;     // Executes batch scripts
                                             PUB_cQPM_Folder + DEF_SLASH + 'us_slash.exe', ;     // Preprocess and compiles C file using MinGW gcc
                                             PUB_cQPM_Folder + DEF_SLASH + 'us_tdump.exe', ;     // Dumps info from EXEOBJLIB modules Check for 64 bits files
                                             PUB_cQPM_Folder + DEF_SLASH + 'us_tlib.exe', ;      // Lists LIB (BCC32)
                                             PUB_cQPM_Folder + DEF_SLASH + 'us_upx.exe' }        // EXE compressor
//                                           PUB_cQPM_Folder + DEF_SLASH + 'us_redir.exe', ;     // MinGW's command redirector
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

// CONFIGURATION
   SET LANGUAGE TO ENGLISH
   SET DELETED ON
   SET NAVIGATION EXTENDED
   SET MENUSTYLE EXTENDED
   SET EXACT ON
	SET TOOLTIPSTYLE BALLOON

// CHECK SCREEN SIZE
   if GetDesktopRealWidth() < 800
      MsgStop( 'Sorry, QPM needs a minimun screen configuration of 800x600.' + Hb_OsNewLine() + 'QPM is optimized for 1024x768 resolution.' )
      Return .F.
   endif

   if empty( LOC_cParam )
      if PUB_bW800
         MsgInfo( 'QPM has been optimized for 1024x768 screen size' + Hb_OsNewLine() + 'but your configuration is also supported with reduced workplace.' )
      endif
   endif

// CHECK FILE EXISTENCE
   For i := 1 to len( vExeList )
      if ! file( vExeList[i] )
         aadd( vExeNotFound, vExeList[i] )
      endif
   Next
   if len( vExeNotFound ) > 0
      cExeNotFoundMsg := 'This product is incomplete:' + Hb_OsNewLine() + Hb_OsNewLine()
      For i := 1 to len( vExeNotFound )
          cExeNotFoundMsg := cExeNotFoundMsg + vExeNotFound[i] + ' not found.' + Hb_OsNewLine()
      next
      cExeNotFoundMsg := cExeNotFoundMsg + Hb_OsNewLine() + 'Full package is: ' + Hb_OsNewLine() + Hb_OsNewLine()
      For i := 1 to len( vExeList )
          cExeNotFoundMsg := cExeNotFoundMsg + vExeList[i] + Hb_OsNewLine()
      next
      MsgStop( cExeNotFoundMsg )
      Return .F.
   endif

// ANALIZE PARAMETERS
   if !  empty( LOC_cParam )
      if ( nPos := US_WordPos( '--BUILD', US_Upper( LOC_cParam ) ) ) > 0
         LOC_cParam := US_WordDel( LOC_cParam, nPos )
      endif
      If ( nPos := US_WordPos( '--LITE', US_Upper( LOC_cParam ) ) ) > 0
         LOC_cParam := US_WordDel( LOC_cParam, nPos )
      endif
      If ( nPos := US_WordPos( '--DEBUG', US_Upper( LOC_cParam ) ) ) > 0
         LOC_cParam := US_WordDel( LOC_cParam, nPos )
      endif
      If ( nPos := US_WordPos( '--RUN', US_Upper( LOC_cParam ) ) ) > 0
         LOC_cParam := US_WordDel( LOC_cParam, nPos )
      endif
      If ( nPos := US_WordPos( '--BUTTONRUN', US_Upper( LOC_cParam ) ) ) > 0
         LOC_cParam := US_WordDel( LOC_cParam, nPos )
      endif
      If ( nPos := US_WordPos( '--CLEAR', US_Upper( LOC_cParam ) ) ) > 0
         LOC_cParam := US_WordDel( LOC_cParam, nPos )
      endif
      If ( nPos := US_WordPos( '--OPEN', US_Upper( LOC_cParam ) ) ) > 0
         LOC_cParam := US_WordDel( LOC_cParam, nPos )
      endif
      if ( nPos := US_WordPos( '--IGNOREVERSIONPROJECT', US_Upper( LOC_cParam ) ) ) > 0
         LOC_cParam := US_WordDel( LOC_cParam, nPos )
      endif
      If ( nPos := US_WordPos( '--FORCEFULL', US_Upper( LOC_cParam ) ) ) > 0
         LOC_cParam := US_WordDel( LOC_cParam, nPos )
      endif
      If ( nPos := US_WordStrPos( '--LOG(', US_Upper( LOC_cParam ) ) ) > 0
         LOC_cParam := US_WordDel( LOC_cParam, nPos )
      endif
      If ( nPos := US_WordPos( '--LOGONLYERROR', US_Upper( LOC_cParam ) ) ) > 0
         LOC_cParam := US_WordDel( LOC_cParam, nPos )
      endif
      If ( nPos := US_WordPos( '--EXIT', US_Upper( LOC_cParam ) ) ) > 0
         LOC_cParam := US_WordDel( LOC_cParam, nPos )
      endif
      do case
      case US_Upper( US_Word( LOC_cParam, 1 ) ) == '-VER' .or. US_Upper( US_Word( LOC_cParam, 1 ) ) == '-VERSION'
         QPM_MemoWrit( US_FileNameOnlyPathAndName( GetModuleFileName( GetInstance() ) ) + '.version', QPM_VERSION_NUMBER_LONG )
         Return .T.
      case ( nPos := US_WordPos( '-BUILD', US_Upper( LOC_cParam ) ) ) > 0
         LOC_cParam := US_WordDel( LOC_cParam, nPos )
         aadd( PUB_vAutoRun, 'QPM_OpenProject(PUB_cProjectFile)' )
         if ( nPos := US_WordPos( '-LITE', US_Upper( LOC_cParam ) ) ) > 0
            LOC_cParam := US_WordDel( LOC_cParam, nPos )
            PUB_bLite := .T.
         endif
         if ( nPos := US_WordPos( '-FORCEFULL', US_Upper( LOC_cParam ) ) ) > 0
            LOC_cParam := US_WordDel( LOC_cParam, nPos )
            aadd( PUB_vAutoRun, 'EraseObj()' )
         endif
         if ( nPos := US_WordPos( '-DEBUG', US_Upper( LOC_cParam ) ) ) > 0
            LOC_cParam := US_WordDel( LOC_cParam, nPos )
            aadd( PUB_vAutoRun, 'SwitchDebug()' )
         endif
         aadd( PUB_vAutoRun, 'QPM_Build()' )
         if ( nPos := US_WordPos( '-BUTTONRUN', US_Upper( LOC_cParam ) ) ) > 0
            LOC_cParam := US_WordDel( LOC_cParam, nPos )
            aadd( PUB_vAutoRun, 'EnableButtonRun()' )
            bWaitForBuild := .T.
         endif
         if ( nPos := US_WordPos( '-RUN', US_Upper( LOC_cParam ) ) ) > 0
            LOC_cParam := US_WordDel( LOC_cParam, nPos )
            aadd( PUB_vAutoRun, 'QPM_Run( bRunParm )' )
            bWaitForBuild := .T.
         endif
         if ( nPos := US_WordPos( '-CLEAR', US_Upper( LOC_cParam ) ) ) > 0
            LOC_cParam := US_WordDel( LOC_cParam, nPos )
            aadd( PUB_vAutoRun, 'EraseAll()' )
            bWaitForBuild := .T.
         endif
         if ( nPos := US_WordPos( '-EXIT', US_Upper( LOC_cParam ) ) ) > 0
            LOC_cParam := US_WordDel( LOC_cParam, nPos )
            aadd( PUB_vAutoRun, 'QPM_Exit()' )
            bWaitForBuild := .T.
            bAutoExit     := .T.
            if ( nPos := US_WordStrPos( '-LOG(', US_Upper( LOC_cParam ) ) ) > 0
               LogIni := US_WordInd( LOC_cParam, nPos )
               PUB_cAutoLog := US_WordSubStr( LOC_cParam, nPos )
               PUB_cAutoLog := SubStr( PUB_cAutoLog, 6, at( ')', PUB_cAutoLog ) - 6 )
               if empty( PUB_cAutoLog )
                  MsgInfo( 'Error detecting Log Archive: ' + LOC_cParam )
               else
                  LOC_cParam := substr( LOC_cParam, 1, LogIni - 1 ) + substr( LOC_cParam, LogIni + len( PUB_cAutoLog ) + 6 )
                  if ( nPos := US_WordPos( '-LOGONLYERROR', US_Upper( LOC_cParam ) ) ) > 0
                     LOC_cParam := US_WordDel( LOC_cParam, nPos )
                     PUB_bLogOnlyError := .T.
                  endif
               endif
            endif
         endif
         if ( nPos := US_WordPos( '-OPEN', US_Upper( LOC_cParam ) ) ) > 0
            LOC_cParam := US_WordDel( LOC_cParam, nPos )
         endif
         if ( nPos := US_WordPos( '-IGNOREVERSIONPROJECT', US_Upper( LOC_cParam ) ) ) > 0
            LOC_cParam := US_WordDel( LOC_cParam, nPos )
            PUB_bIgnoreVersionProject := .T.
         endif
         PUB_cProjectFile := alltrim( LOC_cParam )
      case ( nPos := US_WordPos( '-RUN', US_Upper( LOC_cParam ) ) ) > 0
         LOC_cParam := US_WordDel( LOC_cParam, nPos )
         aadd( PUB_vAutoRun, 'QPM_OpenProject(PUB_cProjectFile)' )
         aadd( PUB_vAutoRun, 'QPM_Run( bRunParm )' )
         bWaitForBuild := .F. // No es requerido porque no hay Build
         if ( nPos := US_WordPos( '-LITE', US_Upper( LOC_cParam ) ) ) > 0
            LOC_cParam := US_WordDel( LOC_cParam, nPos )
            PUB_bLite := .T.
         endif
         if ( nPos := US_WordPos( '-CLEAR', US_Upper( LOC_cParam ) ) ) > 0
            LOC_cParam := US_WordDel( LOC_cParam, nPos )
            aadd( PUB_vAutoRun, 'EraseAll()' )
            bWaitForBuild := .T.
         endif
         if ( nPos := US_WordPos( '-EXIT', US_Upper( LOC_cParam ) ) ) > 0
            LOC_cParam := US_WordDel( LOC_cParam, nPos )
            aadd( PUB_vAutoRun, 'QPM_Exit()' )
            bWaitForBuild := .F. // No es requerido porque no hay Build
            bAutoExit     := .T.
            if ( nPos := US_WordStrPos( '-LOG(', US_Upper( LOC_cParam ) ) ) > 0
               LogIni := US_WordInd( LOC_cParam, nPos )
               PUB_cAutoLog := US_WordSubStr( LOC_cParam, nPos )
               PUB_cAutoLog := SubStr( PUB_cAutoLog, 6, at( ')', PUB_cAutoLog ) - 6 )
               if empty( PUB_cAutoLog )
                  MsgInfo( 'Error detecting Log Archive: ' + LOC_cParam )
               else
                  LOC_cParam := substr( LOC_cParam, 1, LogIni - 1 ) + substr( LOC_cParam, LogIni + len( PUB_cAutoLog ) + 6 )
                  if ( nPos := US_WordPos( '-LOGONLYERROR', US_Upper( LOC_cParam ) ) ) > 0
                     LOC_cParam := US_WordDel( LOC_cParam, nPos )
                     PUB_bLogOnlyError := .T.
                  endif
               endif
            endif
         endif
         if ( nPos := US_WordPos( '-OPEN', US_Upper( LOC_cParam ) ) ) > 0
            LOC_cParam := US_WordDel( LOC_cParam, nPos )
         endif
         if ( nPos := US_WordPos( '-IGNOREVERSIONPROJECT', US_Upper( LOC_cParam ) ) ) > 0
            LOC_cParam := US_WordDel( LOC_cParam, nPos )
            PUB_bIgnoreVersionProject := .T.
         endif
         PUB_cProjectFile := alltrim( LOC_cParam )
      case ( nPos := US_WordPos( '-CLEAR', US_Upper( LOC_cParam ) ) ) > 0
         LOC_cParam := US_WordDel( LOC_cParam, nPos )
         aadd( PUB_vAutoRun, 'QPM_OpenProject(PUB_cProjectFile)' )
         if ( nPos := US_WordPos( '-LITE', US_Upper( LOC_cParam ) ) ) > 0
            LOC_cParam := US_WordDel( LOC_cParam, nPos )
            PUB_bLite := .T.
         endif
         if ( nPos := US_WordPos( '-FORCEFULL', US_Upper( LOC_cParam ) ) ) > 0
            LOC_cParam := US_WordDel( LOC_cParam, nPos )
            aadd( PUB_vAutoRun, 'EraseObj()' )
         endif
         aadd( PUB_vAutoRun, 'EraseALL()' )
         if ( nPos := US_WordPos( '-EXIT', US_Upper( LOC_cParam ) ) ) > 0
            LOC_cParam := US_WordDel( LOC_cParam, nPos )
            aadd( PUB_vAutoRun, 'QPM_Exit()' )
            bWaitForBuild := .F. // No es requerido porque no hay Build
            bAutoExit     := .T.
            if ( nPos := US_WordStrPos( '-LOG(', US_Upper( LOC_cParam ) ) ) > 0
               LogIni := US_WordInd( LOC_cParam, nPos )
               PUB_cAutoLog := US_WordSubStr( LOC_cParam, nPos )
               PUB_cAutoLog := SubStr( PUB_cAutoLog, 6, at( ')', PUB_cAutoLog ) - 6 )
               if empty( PUB_cAutoLog )
                  MsgInfo( 'Error detecting Log Archive: ' + LOC_cParam )
               else
                  LOC_cParam := substr( LOC_cParam, 1, LogIni - 1 ) + substr( LOC_cParam, LogIni + len( PUB_cAutoLog ) + 6 )
                  if ( nPos := US_WordPos( '-LOGONLYERROR', US_Upper( LOC_cParam ) ) ) > 0
                     LOC_cParam := US_WordDel( LOC_cParam, nPos )
                     PUB_bLogOnlyError := .T.
                  endif
               endif
            endif
         endif
         if ( nPos := US_WordPos( '-IGNOREVERSIONPROJECT', US_Upper( LOC_cParam ) ) ) > 0
            LOC_cParam := US_WordDel( LOC_cParam, nPos )
            PUB_bIgnoreVersionProject := .T.
         endif
         PUB_cProjectFile := alltrim( LOC_cParam )
      case ( nPos := US_WordPos( '-OPEN', US_Upper( LOC_cParam ) ) ) > 0
         LOC_cParam := US_WordDel( LOC_cParam, nPos )
         aadd( PUB_vAutoRun, 'QPM_OpenProject(PUB_cProjectFile)' )
         if ( nPos := US_WordPos( '-FORCEFULL', US_Upper( LOC_cParam ) ) ) > 0
            LOC_cParam := US_WordDel( LOC_cParam, nPos )
            aadd( PUB_vAutoRun, 'EraseObj()' )
         endif
         if ( nPos := US_WordPos( '-IGNOREVERSIONPROJECT', US_Upper( LOC_cParam ) ) ) > 0
            LOC_cParam := US_WordDel( LOC_cParam, nPos )
            PUB_bIgnoreVersionProject := .T.
         endif
         PUB_cProjectFile := alltrim( LOC_cParam )
      otherwise
         PUB_cProjectFile := LOC_cParam
         aadd( PUB_vAutoRun, 'QPM_OpenProject(PUB_cProjectFile)' )
      endcase
      if ! empty( PUB_cProjectFile )
         PUB_bOpenProjectFromParm := .T.
         if empty( US_FileNameOnlyPath( PUB_cProjectFile ) )
            PUB_cProjectFile := GetCurrentFolder() + DEF_SLASH + PUB_cProjectFile
         endif
      endif
   endif

// CREATE LOG
   if bAutoExit .and. ! empty( PUB_cAutoLog )
      if RAt( DEF_SLASH, PUB_cAutoLog ) == 0
         PUB_cAutoLog := GetCurrentFolder() + DEF_SLASH + PUB_cAutoLog
      endif
      PUB_cAutoLogTmp := MemoRead( PUB_cAutoLog )
      if ( i := RAt( Replicate( '=', 80 ) + Hb_OsNewLine(), PUB_cAutoLogTmp ) ) > 0
         if i # Len( PUB_cAutoLogTmp ) - 80 - Len( Hb_OsNewLine() ) + 1
           i := 0
         endif
      endif
      if i == 0
         PUB_cAutoLogTmp += Hb_OsNewLine() + Replicate( '=', 80 ) + Hb_OsNewLine()
      endif
      PUB_cAutoLogTmp += 'Project file: ' + PUB_cProjectFile + Hb_OsNewLine()
      PUB_cAutoLogTmp += US_VarToStr( Date() ) + ' ' + US_VarToStr( Time() ) + Hb_OsNewLine()
      QPM_MemoWrit( PUB_cAutoLog, PUB_cAutoLogTmp )
   endif

   SET FONT TO 'Arial', 9

   SET HELPFILE TO PUB_cQPM_Folder + DEF_SLASH + 'QPM.chm'

   QPM_Wait( 'LoadEnvironment()', 'Loading environment ...' )

   DEFINE WINDOW VentanaMain ;
           AT GetDesktopRealTop(), GetDesktopRealLeft() ;
           WIDTH GetDesktopRealWidth() HEIGHT GetDesktopRealHeight() ;
           TITLE PUB_cQPM_Title + ' [ Project not opened !!! ]' ;
           ICON 'QPM' ;
           MAIN ;
           ON GOTFOCUS DefinoWindowsHotKeys(.T.) ;
           ON LOSTFOCUS LiberoWindowsHotKeys(.T.) ;
           ON MINIMIZE LiberoWindowsHotKeys(.T.) ;
           ON INIT MainInitAutoRun() ;
           ON RELEASE if( PUB_bLite, NIL, SaveEnvironment() ) ;
           ON INTERACTIVECLOSE QPM_Exit( .T. )


           DEFINE TOOLBAR ToolBar_1 OF VentanaMain
           END TOOLBAR

           QPM_DefinoMainMenu()

           DEFINE CONTEXT MENU
#ifdef QPM_SHG
              ITEM '&Move Item'           ACTION SHG_Move_Item()  IMAGE 'US_EditCopy'  NAME ItC_Move
              SEPARATOR
              ITEM '&Copy'                ACTION SHG_Send_Copy()  IMAGE 'US_EditCopy'  NAME ItC_Copy
              ITEM 'C&ut'                 ACTION SHG_Send_Cut()   IMAGE 'US_EditCut'   NAME ItC_Cut
              ITEM '&Paste'               ACTION SHG_Send_Paste() IMAGE 'US_EditPaste' NAME ItC_Paste
              SEPARATOR
              ITEM '&Select all'          ACTION QPM_Send_SelectAll()                  NAME ItC_SelectAll
              SEPARATOR
              ITEM '&Add to Key List'     ACTION SHG_AddHlpKey()  IMAGE 'add'          NAME ItC_AddHlpKey
              SEPARATOR
              ITEM 'Add Character &&'     ACTION SHG_AddHlpHTML('Ampersand')           NAME ItC_AddHlpHTMLAmpersand
              ITEM 'Add Character <'      ACTION SHG_AddHlpHTML('Menor')               NAME ItC_AddHlpHTMLMenor
              ITEM 'Add Character >'      ACTION SHG_AddHlpHTML('Mayor')               NAME ItC_AddHlpHTMLMayor
              ITEM 'Add Character SPACE'  ACTION SHG_AddHlpHTML('Space')               NAME ItC_AddHlpHTMLSpace
              SEPARATOR
              ITEM 'Add Image from File'  ACTION SHG_AddHlpHTML('Image')               NAME ItC_AddHlpHTMLImage
              ITEM 'Add eMail'            ACTION SHG_AddHlpHTML('eMail')               NAME ItC_AddHlpHTMLeMail
              ITEM 'Add Link to Internet' ACTION SHG_AddHlpHTML('Link')                NAME ItC_AddHlpHTMLLink
              ITEM 'Add Link to Topic'    ACTION SHG_AddHlpHTML('LinkTopic')           NAME ItC_AddHlpHTMLLinkTopic
              ITEM 'Add Ancora'           ACTION SHG_AddHlpHTML('Ancora')              NAME ItC_AddHlpHTMLAncora
#else
              ITEM '&Copy'                ACTION US_Send_Copy()  IMAGE 'US_EditCopy'   NAME ItC_Copy
              ITEM 'C&ut'                 ACTION US_Send_Cut()   IMAGE 'US_EditCut'    NAME ItC_Cut
              ITEM '&Paste'               ACTION US_Send_Paste() IMAGE 'US_EditPaste'  NAME ItC_Paste
              SEPARATOR
              ITEM '&Select all'          ACTION QPM_Send_SelectAll()                  NAME ItC_SelectAll
#endif
           END MENU

           VentanaMain.ItC_Cut.Enabled       := .F.
           VentanaMain.ItC_Paste.Enabled     := .F.
           VentanaMain.ItC_CutM.Enabled      := .F.
           VentanaMain.ItC_PasteM.Enabled    := .F.
#ifdef QPM_SHG
           VentanaMain.ItC_Move.Enabled      := .F.
           VentanaMain.ItC_AddHlpKey.Enabled := .F.
           VentanaMain.ItC_AddHlpHTMLAmpersand.Enabled := .F.
           VentanaMain.ItC_AddHlpHTMLMenor.Enabled := .F.
           VentanaMain.ItC_AddHlpHTMLMayor.Enabled := .F.
           VentanaMain.ItC_AddHlpHTMLSpace.Enabled := .F.
           VentanaMain.ItC_AddHlpHTMLImage.Enabled := .F.
           VentanaMain.ItC_AddHlpHTMLeMail.Enabled := .F.
           VentanaMain.ItC_AddHlpHTMLLink.Enabled  := .F.
           VentanaMain.ItC_AddHlpHTMLLinkTopic.Enabled  := .F.
           VentanaMain.ItC_AddHlpHTMLAncora.Enabled  := .F.
#endif

           @ if( IsXPThemeActive(), 54, 47 ), 1 FRAME FFrame ;
              WIDTH ( GetDesktopRealWidth() - 9 ) ;
              HEIGHT ( GetDesktopRealHeight() - 105 )

#ifndef QPM_SYNCRECOVERY

           DEFINE BUTTONEX EraseALL
                   ROW     63
                   COL     10
                   WIDTH   135
                   HEIGHT  25
                   PICTURE 'clearall'
                   TOOLTIP 'Delete ALL existing object folders'
                   ONCLICK EraseALL()
           END BUTTONEX

#else

           DEFINE BUTTONEX BTakeSyncRecovery
                   ROW     63
                   COL     10
                   WIDTH   65
                   HEIGHT  25
                   PICTURE 'SyncRec'
                   TOOLTIP 'Force the taking of a Sync Recovery Point for this project'
                   ONCLICK QPM_ForceSyncRecovery()
           END BUTTONEX

           DEFINE BUTTONEX EraseALL
                   ROW     63
                   COL     80
                   WIDTH   65
                   HEIGHT  25
                   PICTURE 'clearall'
                   TOOLTIP 'Delete ALL existing object folders'
                   ONCLICK EraseALL()
           END BUTTONEX

#endif

           DEFINE BUTTONEX EraseOBJ
                   ROW     63
                   COL     150
                   WIDTH   170
                   HEIGHT  25
                   PICTURE 'force'
                   TOOLTIP 'Force recompilation of all programs in the project'
                   ONCLICK EraseOBJ()
           END BUTTONEX

           // HEIGHT ( GetDesktopRealHeight() - 95 ) ;
           DEFINE TAB TabGrids ;
              OF VentanaMain ;
              AT 95, 10 ;
              WIDTH 310 ;
              HEIGHT ( GetDesktopRealHeight() - 165 ) ;
              ON CHANGE TabChange( 'GRIDS' )

              DEFINE PAGE PagePRG

                 DEFINE LABEL LProjectFolder
                         ROW             40
                         COL             12
                         WIDTH           89
                         VALUE           'Project Folder:'
                         TRANSPARENT     if( IsXPThemeActive(), .T., .F. )
                 END LABEL

                 DEFINE TEXTBOX TProjectFolder
                         ROW             40
                         COL             102
                         WIDTH           160
                         ON CHANGE       ( If( Right( PUB_cProjectFolder := alltrim( US_FileNameOnlyPath( GetProperty( 'VentanaMain', 'TProjectFolder', 'Value' ) ) ), 1 ) == DEF_SLASH, PUB_cProjectFolder := Left( PUB_cProjectFolder, Len( PUB_cProjectFolder ) - 1 ), NIL ) )
                 END TEXTBOX

                 DEFINE BUTTONEX BProjectFolder
                         ROW             40
                         COL             270
                         WIDTH           25
                         HEIGHT          25
                         PICTURE         'folderselect'
                         TOOLTIP         "Select project's folder"
                         ONCLICK         ( If ( ! Empty( Folder := GetFolder( 'Select Folder', VentanaMain.TProjectFolder.Value ) ), VentanaMain.TProjectFolder.Value := Folder, ), QPM_CheckFiles() )
                 END BUTTONEX

                 DEFINE LABEL LRunProjectFolder
                         ROW             70
                         COL             12
                         WIDTH           89
                         VALUE           'Run Folder:'
                         TRANSPARENT     if( IsXPThemeActive(), .T., .F. )
                 END LABEL

                 DEFINE TEXTBOX TRunProjectFolder
                         ROW             70
                         COL             102
                         WIDTH           160
                 END TEXTBOX

                 DEFINE BUTTONEX BRunProjectFolder
                         ROW             70
                         COL             270
                         WIDTH           25
                         HEIGHT          25
                         PICTURE         'folderselect'
                         TOOLTIP         "Select project's run folder"
                         ONCLICK         If ( ! Empty( Folder := GetFolder( 'Select Folder', VentanaMain.TRunProjectFolder.Value ) ), VentanaMain.TRunProjectFolder.Value := Folder, )
                 END BUTTONEX

                 DEFINE BUTTONEX BPrgAdd
                         ROW     100
                         COL     12
                         WIDTH   65
                         HEIGHT  25
                         PICTURE 'add'
                         TOOLTIP 'Add file to project'
                         ONCLICK QPM_AddFilesPRG()
                 END BUTTONEX

#ifndef QPM_HOTRECOVERYWINDOW

                 DEFINE BUTTONEX BPrgRemove
                         ROW     100
                         COL     85
                         WIDTH   65
                         HEIGHT          25
                         PICTURE 'remove'
                         TOOLTIP 'Remove file from project'
                         ONCLICK QPM_RemoveFilePRG()
                 END BUTTONEX

#else

                 DEFINE BUTTONEX BPrgRemove
                         ROW     100
                         COL     85
                         WIDTH   30
                         HEIGHT  25
                         PICTURE 'remove'
                         TOOLTIP 'Remove file from project'
                         ONCLICK QPM_RemoveFilePRG()
                 END BUTTONEX

                 DEFINE BUTTONEX BPrgHotRecovery
                         ROW     100
                         COL     120
                         WIDTH   30
                         HEIGHT  25
                         PICTURE 'hotrec'
                         TOOLTIP 'Force the saving of a Hot Recovery Version for the selected source'
                         ONCLICK QPM_ForceHotRecovery( 'PRG' )
                 END BUTTONEX
#endif

                 DEFINE BUTTONEX BPrgEdit
                         ROW     100
                         COL     158
                         WIDTH   65
                         HEIGHT  25
                         PICTURE 'Edit'
                         TOOLTIP 'Edit selected file'
                         ONCLICK QPM_EditPRG ()
                 END BUTTONEX

                 DEFINE BUTTONEX SetTopPRG
                         ROW     100
                         COL     230
                         WIDTH   30
                         HEIGHT  25
                         PICTURE 'SetTop'
                         TOOLTIP "Set the selected file as project's " + DBLQT + "Top File" + DBLQT
                         ONCLICK QPM_SetTopPRG()
                 END BUTTONEX

                 DEFINE BUTTONEX ForceRecompPRG
                         ROW     100
                         COL     265
                         WIDTH   30
                         HEIGHT  25
                         PICTURE 'ForceRecomp'
                         TOOLTIP 'Toggle the "Forced Recompilation" switch of the selected file'
                         ONCLICK QPM_ForceRecompPRG()
                 END BUTTONEX

                 DEFINE BUTTONEX BSortPRG
                         ROW     130
                         COL     12
                         WIDTH   65
                         HEIGHT  25
                         PICTURE 'Sort'
                         TOOLTIP "Sort sources in alphabetical order (except " + DBLQT + "Top File" + DBLQT + ")"
                         ONCLICK SortPRG( 'VentanaMain', 'GPrgFiles', NCOLPRGNAME )
                 END BUTTONEX

                 DEFINE BUTTONEX BVerChange
                         ROW     130
                         COL     85
                         WIDTH   55
                         HEIGHT  25
                         PICTURE 'ChangeVersion'
                         TOOLTIP "Change project's version, release and/or build numbers"
                         ONCLICK QPM_ChangePrj_Version()
                 END BUTTONEX

                 DEFINE LABEL LVerTitle
                         ROW             135
                         COL             145
                         VALUE           'Version'
                         WIDTH           45
                         HEIGHT          25
                         FONTCOLOR       DEF_COLORGREEN
                         TRANSPARENT     if( IsXPThemeActive(), .T., .F. )
                 END LABEL

                 DEFINE LABEL LVerVerNum
                         ROW             135
                         COL             193
                         VALUE           Replicate( '0', DEF_LEN_VER_VERSION )
                         WIDTH           15
                         HEIGHT          25
                         FONTBOLD        .T.
                         FONTCOLOR       DEF_COLORGREEN
                         TRANSPARENT     if( IsXPThemeActive(), .T., .F. )
                 END LABEL

                 DEFINE LABEL LVerPoint
                         ROW             135
                         COL             208
                         VALUE           '.'
                         WIDTH           5
                         HEIGHT          25
                         FONTCOLOR       DEF_COLORGREEN
                         TRANSPARENT     if( IsXPThemeActive(), .T., .F. )
                 END LABEL

                 DEFINE LABEL LVerRelNum
                         ROW             135
                         COL             212
                         VALUE           Replicate( '0', DEF_LEN_VER_RELEASE )
                         WIDTH           15
                         HEIGHT          25
                         FONTBOLD        .T.
                         FONTCOLOR       DEF_COLORGREEN
                         TRANSPARENT     if( IsXPThemeActive(), .T., .F. )
                 END LABEL

                 DEFINE LABEL LVerBui
                         ROW             135
                         COL             230
                         VALUE           'Build'
                         WIDTH           30
                         HEIGHT          25
                         FONTCOLOR       DEF_COLORBLUE
                         TRANSPARENT     if( IsXPThemeActive(), .T., .F. )
                 END LABEL

                 DEFINE LABEL LVerBuiNum
                         ROW             135
                         COL             265
                         VALUE           Replicate( '0', DEF_LEN_VER_BUILD )
                         WIDTH           30
                         HEIGHT          25
                         FONTBOLD        .T.
                         FONTCOLOR       DEF_COLORBLUE
                         TRANSPARENT     if( IsXPThemeActive(), .T., .F. )
                 END LABEL

                 DEFINE BUTTONEX BSyncPrg
                         ROW     312
                         COL     296
                         WIDTH   11
                         HEIGHT  21
                         PICTURE 'SYNC'
                         TOOLTIP 'Syncronize tabs'
                         ONCLICK TabSync()
                 END BUTTONEX

                 DEFINE BUTTONEX BUpPrg
                         ROW     160
                         COL     12
                         WIDTH   11
                         HEIGHT  21
                         PICTURE 'UP'
                         TOOLTIP 'Move the selected file up in the list'
                         ONCLICK UpPrg()
                 END BUTTONEX

                 DEFINE BUTTONEX BDownPrg
                         ROW     190
                         COL     12
                         WIDTH   11
                         HEIGHT  21
                         PICTURE 'DOWN'
                         TOOLTIP 'Move the selected file down in the list'
                         ONCLICK DownPrg()
                 END BUTTONEX

                 DEFINE BUTTONEX BUpPrg2
                         ROW     GetDesktopRealHeight() - 237
                         COL     12
                         WIDTH   11
                         HEIGHT  21
                         PICTURE 'UP'
                         TOOLTIP 'Move the selected file up in the list'
                         ONCLICK UpPrg()
                 END BUTTONEX

                 DEFINE BUTTONEX BDownPrg2
                         ROW     GetDesktopRealHeight() - 207
                         COL     12
                         WIDTH   11
                         HEIGHT  21
                         PICTURE 'DOWN'
                         TOOLTIP 'Move the selected file down in the list'
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
                    ON HEADCLICK { {||SortPRG( 'VentanaMain', 'GPrgFiles', 1 )}, {||SortPRG( 'VentanaMain', 'GPrgFiles', 2 )}, {||SortPRG( 'VentanaMain', 'GPrgFiles', 3 )}, {||SortPRG( 'VentanaMain', 'GPrgFiles', 4 )} } ;
                    ON DBLCLICK { QPM_EditPRG() } ;
                    ON CHANGE { || if( ! bPrgSorting .and. ! PUB_bLite, ;
                                       if( bNumberOnPrg, ;
                                           QPM_Wait( "RichEditDisplay('PRG')", 'Reloading' ), ;
                                           RichEditDisplay('PRG') ), US_NOP() ) } ;
                    JUSTIFY { BROWSE_JTFY_LEFT }

                 DEFINE CHECKBOX Check_Reimp
                         CAPTION         'ReImport from .Lib library (Only for MinGW)'
                         ROW             if( PUB_bW800, 280, 320 )
                         COL             30
                         WIDTH           250
                         HEIGHT          20
                         VALUE           .F.
                         TOOLTIP         'Make ".a" interface library from ".lib" interface library'
                         TRANSPARENT     if( IsXPThemeActive(), .T., .F. )
                         ON CHANGE       ( SetProperty( 'VentanaMain', 'LReImportLib', 'enabled', GetProperty( 'VentanaMain', 'Check_Reimp', 'Value' ) ), ;
                                           SetProperty( 'VentanaMain', 'TReImportLib', 'enabled', GetProperty( 'VentanaMain', 'Check_Reimp', 'Value' ) ), ;
                                           SetProperty( 'VentanaMain', 'BReImportLib', 'enabled', GetProperty( 'VentanaMain', 'Check_Reimp', 'Value' ) ) )
                 END CHECKBOX

                 DEFINE LABEL LReImportLib
                         ROW             if( PUB_bW800, 320, 360 )
                         COL             30
                         VALUE           "Input interface '.lib':"
                         TRANSPARENT     IsXPThemeActive()
                 END LABEL

                 DEFINE TEXTBOX TReImportLib
                         ROW             if( PUB_bW800, 350, 390 )
                         COL             30
                         WIDTH           220
                 END TEXTBOX

                 DEFINE BUTTONEX BReImportLib
                         ROW             if( PUB_bW800, 350, 390 )
                         COL             270
                         WIDTH           25
                         HEIGHT          25
                         PICTURE         'folderselect'
                         TOOLTIP         'Select library'
                         ONCLICK         If( ! Empty( FileName := BugGetFile( { {'Library (*.lib)','*.lib'} }, 'Select Library for ReImport', US_FileNameOnlyPath( ChgPathToReal( VentanaMain.TReImportLib.Value ) ), .F., .T. ) ), VentanaMain.TReImportLib.Value := ChgPathToRelative( FileName ), )
                 END BUTTONEX

                 DEFINE CHECKBOX Check_GuionA
                         CAPTION         "Add '_' alias (not for MinGW)"
                         ROW             if( PUB_bW800, 420, 460 )
                         COL             30
                         WIDTH           250
                         HEIGHT          20
                         VALUE           .F.
                         TOOLTIP 'Add "_" alias for MS flavor cdecl functions (only for BCC32 and Pelles)'
                         TRANSPARENT     IsXPThemeActive()
                 END CHECKBOX

                 ActLibReimp()

              END PAGE

              DEFINE PAGE PageHEA

                 DEFINE BUTTONEX BHeaAdd
                         ROW     40
                         COL     12
                         WIDTH   65
                         HEIGHT  25
                         PICTURE 'add'
                         TOOLTIP 'Add header'
                         ONCLICK QPM_AddFilesHEA()
                 END BUTTONEX

#ifndef QPM_HOTRECOVERYWINDOW

                 DEFINE BUTTONEX BHeaRemove
                         ROW     40
                         COL     85
                         WIDTH   65
                         HEIGHT          25
                         PICTURE 'remove'
                         TOOLTIP 'Remove header'
                         ONCLICK QPM_RemoveFileHEA()
                 END BUTTONEX

#else

                 DEFINE BUTTONEX BHeaRemove
                         ROW     40
                         COL     85
                         WIDTH   30
                         HEIGHT  25
                         PICTURE 'remove'
                         TOOLTIP 'Remove header'
                         ONCLICK QPM_RemoveFileHEA()
                 END BUTTONEX

                 DEFINE BUTTONEX BHeaHotRecovery
                         ROW     40
                         COL     120
                         WIDTH   30
                         HEIGHT  25
                         PICTURE 'hotrec'
                         TOOLTIP 'Force the saving of a Hot Recovery Version for this header'
                         ONCLICK QPM_ForceHotRecovery( 'HEA' )
                 END BUTTONEX
#endif

                 DEFINE BUTTONEX BHeaEdit
                         ROW     40
                         COL     158
                         WIDTH   65
                         HEIGHT  25
                         PICTURE 'Edit'
                         TOOLTIP 'Modify header'
                         ONCLICK QPM_EditHEA ()
                 END BUTTONEX

                 DEFINE BUTTONEX BSortHea
                         ROW     70
                         COL     12
                         WIDTH   65
                         HEIGHT  25
                         PICTURE 'Sort'
                         TOOLTIP 'Sort headers in alphabetical order'
                         ONCLICK SortHEA( 'VentanaMain', 'GHeaFiles', NCOLHEANAME )
                 END BUTTONEX

                 DEFINE BUTTONEX BSyncHea
                         ROW     312
                         COL     296
                         WIDTH   11
                         HEIGHT  21
                         PICTURE 'SYNC'
                         TOOLTIP 'Syncronize tabs'
                         ONCLICK TabSync()
                 END BUTTONEX

                 DEFINE BUTTONEX BUpHea
                         ROW     100
                         COL     12
                         WIDTH   11
                         HEIGHT  21
                         PICTURE 'UP'
                         TOOLTIP 'Move the selected header up in the list'
                         ONCLICK UpHea()
                 END BUTTONEX

                 DEFINE BUTTONEX BDownHea
                         ROW     130
                         COL     12
                         WIDTH   11
                         HEIGHT  21
                         PICTURE 'DOWN'
                         TOOLTIP 'Move the selected header down in the list'
                         ONCLICK DownHea()
                 END BUTTONEX

                 DEFINE BUTTONEX BUpHea2
                         ROW     GetDesktopRealHeight() - 237
                         COL     12
                         WIDTH   11
                         HEIGHT  21
                         PICTURE 'UP'
                         TOOLTIP 'Move the selected header up in the list'
                         ONCLICK UpHea()
                 END BUTTONEX

                 DEFINE BUTTONEX BDownHea2
                         ROW     GetDesktopRealHeight() - 207
                         COL     12
                         WIDTH   11
                         HEIGHT  21
                         PICTURE 'DOWN'
                         TOOLTIP 'Move the selected header down in the list'
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
                    ON HEADCLICK { {||SortHEA( 'VentanaMain', 'GHeaFiles', 1 )}, {||SortHEA( 'VentanaMain', 'GHeaFiles', 2)}, {||SortHEA( 'VentanaMain', 'GHeaFiles', 3)}, {||SortHEA( 'VentanaMain', 'GHeaFiles', 4)} } ;
                    ON DBLCLICK { QPM_EditHEA() } ;
                    ON CHANGE { || if( ! bHeaSorting .and. ! PUB_bLite, if( bNumberOnHea, QPM_Wait( "RichEditDisplay('HEA')", 'Reloading' ), RichEditDisplay('HEA') ), US_NOP() ) } ;
                    JUSTIFY { BROWSE_JTFY_LEFT }

              END PAGE

              DEFINE PAGE PagePAN

                 DEFINE BUTTONEX BPanAdd
                         ROW     40
                         COL     12
                         WIDTH   65
                         HEIGHT  25
                         PICTURE 'add'
                         TOOLTIP 'Add form'
                         ONCLICK QPM_AddFilesPAN()
                 END BUTTONEX

#ifndef QPM_HOTRECOVERYWINDOW

                 DEFINE BUTTONEX BPanRemove
                         ROW     40
                         COL     85
                         WIDTH   65
                         HEIGHT          25
                         PICTURE 'remove'
                         TOOLTIP 'Remove form'
                         ONCLICK QPM_RemoveFilePAN()
                 END BUTTONEX

#else

                 DEFINE BUTTONEX BPanRemove
                         ROW     40
                         COL     85
                         WIDTH   30
                         HEIGHT  25
                         PICTURE 'remove'
                         TOOLTIP 'Remove form'
                         ONCLICK QPM_RemoveFilePAN()
                 END BUTTONEX

                 DEFINE BUTTONEX BPanHotRecovery
                         ROW     40
                         COL     120
                         WIDTH   30
                         HEIGHT  25
                         PICTURE 'hotrec'
                         TOOLTIP 'Force the saving of a Hot Recovery Version for this form'
                         ONCLICK QPM_ForceHotRecovery( 'PAN' )
                 END BUTTONEX

#endif

                 DEFINE BUTTONEX BPanEditTool
                         ROW     40
                         COL     158
                         WIDTH   65
                         HEIGHT  25
                         CAPTION 'With Tool'
                         TOOLTIP 'Modify form with associated tool'
                         ONCLICK QPM_EditPAN()
                 END BUTTONEX

                 DEFINE BUTTONEX BPanEditEditor
                         ROW     40
                         COL     230
                         WIDTH   65
                         HEIGHT  25
                         CAPTION 'With Edit'
                         TOOLTIP 'Open form with associated editor'
                         ONCLICK QPM_EditPAN( .T. )
                 END BUTTONEX

                 DEFINE BUTTONEX BSortPan
                         ROW     70
                         COL     12
                         WIDTH   65
                         HEIGHT  25
                         PICTURE 'Sort'
                         TOOLTIP 'Sort forms in alphabetical order'
                         ONCLICK SortPAN( 'VentanaMain', 'GPanFiles', NCOLPANNAME )
                 END BUTTONEX

                 DEFINE BUTTONEX BEditRC
                         ROW     70
                         COL     85
                         WIDTH   209
                         HEIGHT  25
                         CAPTION 'Edit Main .RC'
                         TOOLTIP "Edit the project's main resource file"
                         ONCLICK QPM_EditRES()
                 END BUTTONEX

                 DEFINE CHECKBOX Check_Place
                         CAPTION         'Place Main .RC First (Only for MinGW)'
                         ROW             100
                         COL             12
                         WIDTH           282
                         HEIGHT          25
                         VALUE           .T.
                         TOOLTIP         "The Main .RC content will be placed before the MINIGUI's .RC content when building _Temp.RC file."
                         TRANSPARENT     IsXPThemeActive()
                         ON CHANGE       Prj_Check_PlaceRCFirst := VentanaMain.Check_Place.Value
                 END CHECKBOX

                 DEFINE BUTTONEX BSyncPan
                         ROW     312
                         COL     296
                         WIDTH   11
                         HEIGHT  21
                         PICTURE 'SYNC'
                         TOOLTIP 'Syncronize tabs'
                         ONCLICK TabSync()
                 END BUTTONEX

                 DEFINE BUTTONEX BUpPan
                         ROW     100
                         COL     12
                         WIDTH   11
                         HEIGHT  21
                         PICTURE 'UP'
                         TOOLTIP 'Move the selected form up in the list'
                         ONCLICK UpPan()
                 END BUTTONEX

                 DEFINE BUTTONEX BDownPan
                         ROW     130
                         COL     12
                         WIDTH   11
                         HEIGHT  21
                         PICTURE 'DOWN'
                         TOOLTIP 'Move the selected form down in the list'
                         ONCLICK DownPan()
                 END BUTTONEX

                 DEFINE BUTTONEX BUpPan2
                         ROW     GetDesktopRealHeight() - 237
                         COL     12
                         WIDTH   11
                         HEIGHT  21
                         PICTURE 'UP'
                         TOOLTIP 'Move the selected form up in the list'
                         ONCLICK UpPan()
                 END BUTTONEX

                 DEFINE BUTTONEX BDownPan2
                         ROW     GetDesktopRealHeight() - 207
                         COL     12
                         WIDTH   11
                         HEIGHT  21
                         PICTURE 'DOWN'
                         TOOLTIP 'Move the selected form down in the list'
                         ONCLICK DownPan()
                 END BUTTONEX

                 @ 130, 25 GRID GPanFiles ;
                    WIDTH 270 ;
                    HEIGHT GetDesktopRealHeight() - 315 ;
                    HEADERS { 'S', 'Form Name', 'Form Full Name', 'Offset', 'Control Edit', 'Hot Recovery' } ;
                    WIDTHS { 25, 100, 1000, 20, 20, 20 };
                    ITEMS aGridPan ;
                    VALUE 1 ;
                    IMAGE vImagesGrid ;
                    BACKCOLOR DEF_COLORBACKPAN ;
                    ON HEADCLICK { {||SortPAN( 'VentanaMain', 'GPanFiles', 1)}, {||SortPAN( 'VentanaMain', 'GPanFiles', 2)}, {||SortPAN( 'VentanaMain', 'GPanFiles', 3)}, {||SortPAN( 'VentanaMain', 'GPanFiles', 4)} } ;
                    ON DBLCLICK { QPM_EditPAN() } ;
                    ON CHANGE { || if( ! bPanSorting .and. ! PUB_bLite, if( bNumberOnPan, QPM_Wait( "RichEditDisplay('PAN')", 'Reloading' ), RichEditDisplay('PAN') ), US_NOP() ) } ;
                    JUSTIFY { BROWSE_JTFY_LEFT }

              END PAGE

              DEFINE PAGE PageDBF

                 DEFINE BUTTONEX BDbfAdd
                         ROW     40
                         COL     12
                         WIDTH   65
                         HEIGHT  25
                         PICTURE 'add'
                         TOOLTIP 'Add DBF file'
                         ONCLICK QPM_AddFilesDBF()
                 END BUTTONEX

                 DEFINE BUTTONEX BDbfRemove
                         ROW     40
                         COL     85
                         WIDTH   65
                         HEIGHT  25
                         PICTURE 'remove'
                         TOOLTIP 'Remove DBF file'
                         ONCLICK QPM_RemoveFileDBF()
                 END BUTTONEX

                 DEFINE BUTTONEX BDbfEditTool
                         ROW     40
                         COL     158
                         WIDTH   65
                         HEIGHT  25
                         PICTURE 'Edit'
                         TOOLTIP 'Modify DBF file with associated tool'
                         ONCLICK QPM_EditDBF()
                 END BUTTONEX

                 DEFINE BUTTONEX BSortDbf
                         ROW     70
                         COL     12
                         WIDTH   65
                         HEIGHT  25
                         PICTURE 'Sort'
                         TOOLTIP 'Sort DBF files in alphabetical order'
                         ONCLICK SortDBF( 'VentanaMain', 'GDbfFiles', NCOLDBFNAME )
                 END BUTTONEX

                 DEFINE BUTTONEX BSyncDbf
                         ROW     312
                         COL     296
                         WIDTH   11
                         HEIGHT  21
                         PICTURE 'SYNC'
                         TOOLTIP 'Syncronize tabs'
                         ONCLICK TabSync()
                 END BUTTONEX

                 DEFINE BUTTONEX BUpDbf
                         ROW     100
                         COL     12
                         WIDTH   11
                         HEIGHT  21
                         PICTURE 'UP'
                         TOOLTIP 'Move the selected DBF file up in the list'
                         ONCLICK UpDbf()
                 END BUTTONEX

                 DEFINE BUTTONEX BDownDbf
                         ROW     130
                         COL     12
                         WIDTH   11
                         HEIGHT  21
                         PICTURE 'DOWN'
                         TOOLTIP 'Move the selected DBF file down in the list'
                         ONCLICK DownDbf()
                 END BUTTONEX

                 DEFINE BUTTONEX BUpDbf2
                         ROW     GetDesktopRealHeight() - 237
                         COL     12
                         WIDTH   11
                         HEIGHT  21
                         PICTURE 'UP'
                         TOOLTIP 'Move the selected DBF file up in the list'
                         ONCLICK UpDbf()
                 END BUTTONEX

                 DEFINE BUTTONEX BDownDbf2
                         ROW     GetDesktopRealHeight() - 207
                         COL     12
                         WIDTH   11
                         HEIGHT  21
                         PICTURE 'DOWN'
                         TOOLTIP 'Move the selected DBF file down in the list'
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
                    ON HEADCLICK { {||SortDBF( 'VentanaMain', 'GDbfFiles', 1)}, {||SortDBF( 'VentanaMain', 'GDbfFiles', 2)}, {||SortDBF( 'VentanaMain', 'GDbfFiles', 3)}, {||SortDBF( 'VentanaMain', 'GDbfFiles', 4)} } ;
                    ON DBLCLICK { QPM_EditDBF() } ;
                    ON CHANGE { || if( ! bDbfSorting .and. ! PUB_bLite, QPM_Wait( "RichEditDisplay( 'DBF', .T. )", 'Loading ...' ), US_NOP() ) } ;
                    JUSTIFY { BROWSE_JTFY_LEFT }

              END PAGE

              DEFINE PAGE PageLIB

                 @ 43, 12 LABEL LLibLabel ;
                    VALUE 'Include:' ;
                    WIDTH 155 ;
                    FONT 'arial' SIZE 10 BOLD ;
                    TRANSPARENT ;
                    FONTCOLOR DEF_COLORBLUE

                 DEFINE BUTTONEX BLibAdd
                         ROW     70
                         COL     12
                         WIDTH   65
                         HEIGHT  25
                         PICTURE 'add'
                         TOOLTIP 'Add file'
                         ONCLICK QPM_AddFilesLIB()
                 END BUTTONEX

                 DEFINE BUTTONEX BLibRemove
                         ROW     70
                         COL     85
                         WIDTH   65
                         HEIGHT  25
                         PICTURE 'remove'
                         TOOLTIP 'Remove file'
                         ONCLICK QPM_RemoveFileLIB()
                 END BUTTONEX

                 DEFINE BUTTONEX BFirst
                         ROW     70
                         COL     158
                         WIDTH   65
                         HEIGHT  25
                         CAPTION 'First'
                         TOOLTIP 'Move selected lib or object to first position in the libs concatenation'
                         ONCLICK LibPos( VentanaMain.GIncFiles.Value, '*First*' )
                 END BUTTONEX

                 DEFINE BUTTONEX BLast
                         ROW     70
                         COL     231
                         WIDTH   65
                         HEIGHT  25
                         CAPTION 'Last'
                         TOOLTIP 'Move selected lib or object to last position in the libs concatenation (default)'
                         ONCLICK LibPos( VentanaMain.GIncFiles.Value, '*Last*' )
                 END BUTTONEX

                 DEFINE BUTTONEX BSortInc
                         ROW     100
                         COL     12
                         WIDTH   65
                         HEIGHT  25
                         PICTURE 'Sort'
                         TOOLTIP 'Sorts included libs and objects in alphabetical order'
                         ONCLICK SortINC( 'VentanaMain', 'GIncFiles', NCOLINCNAME )
                 END BUTTONEX

                 DEFINE BUTTONEX BSyncLib
                         ROW     312
                         COL     296
                         WIDTH   11
                         HEIGHT  21
                         PICTURE 'SYNC'
                         TOOLTIP 'Syncronize tabs'
                         ONCLICK TabSync()
                 END BUTTONEX

                 DEFINE BUTTONEX BUpLibInclude
                         ROW     130
                         COL     12
                         WIDTH   11
                         HEIGHT  21
                         PICTURE 'UP'
                         TOOLTIP 'Move the selected lib or object up in the list'
                         ONCLICK UpLibInclude()
                 END BUTTONEX

                 DEFINE BUTTONEX BDownLibInclude
                         ROW     160
                         COL     12
                         WIDTH   11
                         HEIGHT  21
                         PICTURE 'DOWN'
                         TOOLTIP 'Move down the selected lib or object in the list'
                         ONCLICK DownLibInclude()
                 END BUTTONEX

                 @ 130, 25 GRID GIncFiles ;
                    WIDTH 270 ;
                    HEIGHT 170 ;
                    HEADERS { 'S', 'Include Name', 'Include Full Name'} ;
                    WIDTHS { 25, 100, 1000 };
                    ITEMS aGridInc ;
                    VALUE 1 ;
                    IMAGE vImagesGrid ;
                    BACKCOLOR DEF_COLORBACKINC ;
                    ON HEADCLICK { {||SortINC( 'VentanaMain', 'GIncFiles', 1)}, {||SortINC( 'VentanaMain', 'GIncFiles', 2)}, {||SortINC( 'VentanaMain', 'GIncFiles', 3)} } ;
                    ON DBLCLICK { LibInfo() } ;
                    ON CHANGE { || if( ! bIncSorting .and. ! PUB_bLite, RichEditDisplay('INC'), US_NOP() ) } ;
                    JUSTIFY { BROWSE_JTFY_LEFT }

                 @ 313, 12 LABEL LLibLabel_e ;
                    VALUE 'Exclude:' ;
                    WIDTH 155 ;
                    FONT 'arial' SIZE 10 BOLD ;
                    TRANSPARENT ;
                    FONTCOLOR DEF_COLORBLUE

                 DEFINE BUTTONEX BLibAdd_E
                         ROW     340
                         COL     12
                         WIDTH   65
                         HEIGHT  25
                         PICTURE 'add'
                         TOOLTIP 'Add file'
                         ONCLICK QPM_AddExcludeFilesLIB()
                 END BUTTONEX

                 DEFINE BUTTONEX BLibRemove_E
                         ROW     340
                         COL     85
                         WIDTH   65
                         HEIGHT  25
                         PICTURE 'remove'
                         TOOLTIP 'Remove file'
                         ONCLICK QPM_RemoveExcludeFileLIB()
                 END BUTTONEX

                 DEFINE BUTTONEX BSortExc
                         ROW     370
                         COL     12
                         WIDTH   65
                         HEIGHT  25
                         PICTURE 'Sort'
                         TOOLTIP 'Sort excluded libs in alphabetical order'
                         ONCLICK SortEXC( 'VentanaMain', 'GExcFiles', NCOLEXCNAME )
                 END BUTTONEX

                 DEFINE BUTTONEX BUpLibExclude
                         ROW     400
                         COL     12
                         WIDTH   11
                         HEIGHT  21
                         PICTURE 'UP'
                         TOOLTIP 'Move the selected lib up in the list'
                         ONCLICK UpLibExclude()
                 END BUTTONEX

                 DEFINE BUTTONEX BDownLibExclude
                         ROW     430
                         COL     12
                         WIDTH   11
                         HEIGHT  21
                         PICTURE 'DOWN'
                         TOOLTIP 'Move the selected lib down in the list'
                         ONCLICK DownLibExclude()
                 END BUTTONEX

                 @ 400, 25 GRID GExcFiles ;
                    WIDTH 270 ;
                    HEIGHT GetDesktopRealHeight() - 585 ;
                    HEADERS { 'S', 'Library Name' } ;
                    WIDTHS { 25, 200 };
                    ITEMS aGridExc ;
                    VALUE 1 ;
                    IMAGE vImagesGrid ;
                    BACKCOLOR DEF_COLORBACKEXC ;
                    ON HEADCLICK { {||SortEXC( 'VentanaMain', 'GExcFiles', 1)}, {||SortEXC( 'VentanaMain', 'GExcFiles', 2)} } ;
                    ON DBLCLICK { LibExcludeInfo() } ;
                    JUSTIFY { BROWSE_JTFY_LEFT }

              END PAGE

#ifdef QPM_SHG

              DEFINE PAGE PageHlp

                 DEFINE LABEL LHlpDataBase
                         ROW             40
                         COL             12
                         VALUE           'SHG Database:'
                         TRANSPARENT     IsXPThemeActive()
                 END LABEL

                 DEFINE TEXTBOX THlpDataBase
                         ROW             40
                         COL             132
                         WIDTH           130
                 END TEXTBOX

                 DEFINE BUTTONEX BHlpDataBase
                         ROW             40
                         COL             270
                         WIDTH           25
                         HEIGHT          25
                         PICTURE         'folderselect'
                         TOOLTIP         'Select SHG database'
                         ONCLICK         (            SHG_GetDatabase(), if( SHG_BaseOK, SetProperty( 'VentanaMain', 'RichEditHlp', 'readonly', .F. ), US_NOP() ) )
                 END BUTTONEX
                 //      ONCLICK         ( QPM_Wait( 'SHG_GetDatabase()', 'Loading Database ...' ), if( SHG_BaseOK, SetProperty( 'VentanaMain', 'RichEditHlp', 'readonly', .F. ), US_NOP() ) )

                 DEFINE LABEL LWWWHlp
                         ROW             70
                         COL             12
                         VALUE           'Your Link for Foot:'
                         TRANSPARENT     IsXPThemeActive()
                 END LABEL

                 DEFINE TEXTBOX TWWWHlp
                         ROW             70
                         COL             132
                         WIDTH           163
                 END TEXTBOX

                 DEFINE BUTTONEX BHlpAdd
                         ROW     100
                         COL     12
                         WIDTH   65
                         HEIGHT  25
                         PICTURE 'add'
                         TOOLTIP 'Add topic'
                         ONCLICK QPM_AddFilesHLP()
                 END BUTTONEX

                 DEFINE BUTTONEX BHlpRemove
                         ROW     100
                         COL     85
                         WIDTH   65
                         HEIGHT  25
                         PICTURE 'remove'
                         TOOLTIP 'Remove topic'
                         ONCLICK QPM_RemoveFileHLP()
                 END BUTTONEX

                 DEFINE BUTTONEX BHlpEdit
                         ROW     100
                         COL     158
                         WIDTH   65
                         HEIGHT  25
                         PICTURE 'Edit'
                         TOOLTIP "Edit topic's name"
                         ONCLICK QPM_EditHLP ()
                 END BUTTONEX

                 DEFINE BUTTONEX SetTestHlp
                         ROW     100
                         COL     230
                         WIDTH   65
                         HEIGHT  25
                         PICTURE 'TEST'
                         TOOLTIP 'Test CHM file'
                         ONCLICK SHG_DisplayHelp( SHG_GetOutputName() )
                         BACKCOLOR WHITE
                 END BUTTONEX

                 DEFINE BUTTONEX BToggle
                         ROW     130
                         COL     12
                         WIDTH   65
                         HEIGHT  25
                         CAPTION 'Toggle'
                         TOOLTIP "Toggle topic's type (Book or Page)"
                         ONCLICK SHG_Toggle()
                 END BUTTONEX

                 DEFINE BUTTONEX HlpCheckSave
                         ROW     130
                         COL     85
                         WIDTH   65
                         HEIGHT  25
                         CAPTION 'Save all ?'
                         TOOLTIP 'Save all unsaved topics'
                         ONCLICK QPM_WAIT( 'SHG_CheckSave()', 'Checking for save ...' )
                 END BUTTONEX

                 DEFINE BUTTONEX HlpClose
                         ROW     130
                         COL     158
                         WIDTH   65
                         HEIGHT  25
                         CAPTION 'Close'
                         TOOLTIP 'Close SHG database'
                         ONCLICK SHG_Close()
                 END BUTTONEX

                 DEFINE BUTTONEX HlpGenerate
                         ROW     130
                         COL     230
                         WIDTH   65
                         HEIGHT  25
                         CAPTION 'Generate'
                         TOOLTIP 'Generate help file in CHM format'
                         ONCLICK QPM_Wait( "SHG_Generate( SHG_Database, SHG_CheckTypeOutput, PUB_cSecu, GetProperty( 'VentanaMain', 'TWWWHlp', 'Value' ) )", 'Generating Help ...' )
                 END BUTTONEX

                 DEFINE BUTTONEX BSyncHlp
                         ROW     312
                         COL     296
                         WIDTH   11
                         HEIGHT  21
                         PICTURE 'SYNC'
                         TOOLTIP 'Syncronize tabs'
                         ONCLICK TabSync()
                 END BUTTONEX

                 DEFINE BUTTONEX BUpHlp
                         ROW     160
                         COL     12
                         WIDTH   11
                         HEIGHT  21
                         PICTURE 'UP'
                         TOOLTIP 'Move the selected topic up in the list'
                         ONCLICK UpHlp()
                 END BUTTONEX

                 DEFINE BUTTONEX BDownHlp
                         ROW     190
                         COL     12
                         WIDTH   11
                         HEIGHT  21
                         PICTURE 'DOWN'
                         TOOLTIP 'Move the selected topic down in the list'
                         ONCLICK DownHlp()
                 END BUTTONEX

                 DEFINE BUTTONEX BUpHlp2
                         ROW     GetDesktopRealHeight() - 237
                         COL     12
                         WIDTH   11
                         HEIGHT  21
                         PICTURE 'UP'
                         TOOLTIP 'Move the selected topic up in the list'
                         ONCLICK UpHlp()
                 END BUTTONEX

                 DEFINE BUTTONEX BDownHlp2
                         ROW     GetDesktopRealHeight() - 207
                         COL     12
                         WIDTH   11
                         HEIGHT  21
                         PICTURE 'DOWN'
                         TOOLTIP 'Move the selected topic down in the list'
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
                    ON CHANGE { || SetProperty( 'VentanaMain', 'GHlpFilesItem', 'value', 'Current item: ' + ltrim( str( VentanaMain.GHlpFiles.Value ) ) ), ;
                                   if( ! bHlpSorting .and. ! PUB_bLite, ;
                                       ( RichEditDisplay('HLP'), OcultaHlpKeys() ), ;
                                       US_NOP() ) } ;
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
                   ROW             15
                   COL             if( IsXPThemeActive(), 363, 335 )
                   WIDTH           if( IsXPThemeActive(), 70, 80 )
                   HEIGHT          18
                   VALUE           PUB_cStatusLabel
                   TRANSPARENT     IsXPThemeActive()
           END LABEL

           DEFINE LABEL LResumen
                   ROW             09
                   COL             433
                   HEIGHT          18
                   WIDTH           600
                   VALUE           ''
                   FONTNAME        'arial'
                   FONTSIZE        10
                   FONTBOLD        .T.
                   FONTCOLOR       DEF_COLORBLUE
                   TRANSPARENT     IsXPThemeActive()
           END LABEL

           DEFINE LABEL LFull
                   ROW             28
                   COL             433
                   HEIGHT          18
                   WIDTH           160
                   VALUE           ''
                   FONTNAME        'arial'
                   FONTSIZE        10
                   FONTBOLD        .T.
                   FONTCOLOR       DEF_COLORGREEN
                   TRANSPARENT     IsXPThemeActive()
           END LABEL

           DEFINE LABEL LExtra
                   ROW             28
                   COL             600
                   WIDTH           200
                   HEIGHT          18
                   VALUE           ''
                   FONTNAME        'arial'
                   FONTSIZE        10
                   FONTBOLD        .T.
                   FONTCOLOR DEF_COLORBLACK
                   TRANSPARENT     IsXPThemeActive()
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
                         CAPTION         'Auto Sync'
                         ROW             00
                         COL             ( GetDesktopRealWidth() - 420 )
                         WIDTH           70
                         HEIGHT          20
                         VALUE           .T.
                         TOOLTIP         'Toggle automatic tab syncronization'
                         ON CHANGE       TabAutoSync('PRG')
                 END CHECKBOX

                 @ 25, 00 IMAGE IBorde1PRG ;
                     PICTURE         'YELLOW' ;
                     WIDTH           GetDesktopRealWidth() - 348 ;
                     HEIGHT          GetDesktopRealHeight() - 217 ;
                     STRETCH

                 @ 35, 10 RICHEDITBOX RichEditPRG ;
                         WIDTH           GetDesktopRealWidth() - 364 ;
                         HEIGHT          GetDesktopRealHeight() - 272 ;
                         READONLY ;
                         FONT            'Courier New' ;
                         SIZE            9 ;
                         BACKCOLOR DEF_COLORBACKPRG

                 DEFINE CHECKBOX Check_NumberOnPrg
                         CAPTION         'Line Number'
                         ROW             GetDesktopRealHeight() - 224
                         COL             10
                         WIDTH           95
                         HEIGHT          20
                         VALUE           .F.
                         TOOLTIP         "Show line numbers (file's loading is slower)"
                         ON CHANGE       ( bNumberOnPrg := GetProperty( 'VentanaMain', 'Check_NumberOnPrg', 'value' ), if( bPpoDisplayado, QPM_Wait( 'PpoDisplay(.T.)', 'Reloading ...' ), QPM_Wait( "RichEditDisplay( 'PRG', .T. )", 'Reloading ...' ) ) )
                 END CHECKBOX
                 //      TRANSPARENT     IsXPThemeActive()

                 DEFINE BUTTONEX bReLoadPpo
                         ROW             GetDesktopRealHeight() - 227
                         COL             110
                         WIDTH           95
                         HEIGHT          25
                         CAPTION         'Browse PPO'
                         TOOLTIP         "Browse the selected file's preprocessor output"
                         ONCLICK         QPM_Wait( 'PpoDisplay()', 'Reloading ...' )
                 END BUTTONEX

                 DEFINE BUTTONEX bReLoadPrg
                         ROW             GetDesktopRealHeight() - 227
                         COL             210
                         WIDTH           GetDesktopRealWidth() - 630
                         HEIGHT          25
                         CAPTION         'Reload Source'
                         TOOLTIP         'Reload source from disk'
                         ONCLICK QPM_Wait( "RichEditDisplay( 'PRG', .T. )", 'Reloading ...' )
                 END BUTTONEX

                 DEFINE BUTTONEX BLocalSearchPrg
                         ROW             GetDesktopRealHeight() - 227
                         COL             GetDesktopRealWidth() - 415
                         WIDTH           60
                         HEIGHT          25
                         CAPTION 'Search'
                         TOOLTIP 'Search in displayed text'
                         ONCLICK LocalSearch( GetProperty( 'VentanaMain', 'CSearch', 'DisplayValue' ) )
                 END BUTTONEX

              END PAGE

              DEFINE PAGE if( PUB_bW800, 'Hea', PageHEA )

                 DEFINE CHECKBOX Check_AutoSyncHea
                         CAPTION         'Auto Sync'
                         ROW             00
                         COL             ( GetDesktopRealWidth() - 420 )
                         WIDTH           70
                         HEIGHT          20
                         VALUE           .T.
                         TOOLTIP         'Toggle automatic tab syncronization'
                         ON CHANGE       TabAutoSync('HEA')
                 END CHECKBOX

                 @ 25, 00 IMAGE IBorde1HEA ;
                         PICTURE         'YELLOW' ;
                         WIDTH           GetDesktopRealWidth() - 348 ;
                         HEIGHT          GetDesktopRealHeight() - 217 ;
                         STRETCH
                     
                 @ 35, 10 RICHEDITBOX RichEditHEA ;
                         WIDTH           GetDesktopRealWidth() - 364 ;
                         HEIGHT          GetDesktopRealHeight() - 272 ;
                         READONLY ;
                         FONT            'Courier New' ;
                         SIZE            9 ;
                         BACKCOLOR DEF_COLORBACKHEA

                 DEFINE CHECKBOX Check_NumberOnHea
                         CAPTION         'Line Number'
                         ROW             GetDesktopRealHeight() - 224
                         COL             10
                         WIDTH           95
                         HEIGHT          20
                         VALUE           .F.
                         TOOLTIP         "Show line numbers (file's loading is slower)"
                         ON CHANGE       ( bNumberOnHea := GetProperty( 'VentanaMain', 'Check_NumberOnHea', 'value' ), QPM_Wait( "RichEditDisplay( 'HEA', .T. )", 'Reloading ...' ) )
                 END CHECKBOX
                 //      TRANSPARENT     IsXPThemeActive()

                 DEFINE BUTTONEX bReLoadHea
                         ROW             GetDesktopRealHeight() - 227
                         COL             110
                         WIDTH           GetDesktopRealWidth() - 530
                         HEIGHT          25
                         CAPTION 'Reload Header'
                         TOOLTIP 'Reload header file from disk'
                         ONCLICK { || QPM_Wait( "RichEditDisplay( 'HEA', .T. )", 'Reloading ...' ) }
                 END BUTTONEX

                 DEFINE BUTTONEX BLocalSearchHea
                         ROW             GetDesktopRealHeight() - 227
                         COL             GetDesktopRealWidth() - 415
                         WIDTH           60
                         HEIGHT          25
                         CAPTION 'Search'
                         TOOLTIP 'Search in displayed text'
                         ONCLICK LocalSearch( GetProperty( 'VentanaMain', 'CSearch', 'DisplayValue' ) )
                 END BUTTONEX

              END PAGE

              DEFINE PAGE if( PUB_bW800, 'FMG', PagePAN )

                 DEFINE CHECKBOX Check_AutoSyncPan
                         CAPTION         'Auto Sync'
                         ROW             00
                         COL             ( GetDesktopRealWidth() - 420 )
                         WIDTH           70
                         HEIGHT          20
                         VALUE           .T.
                         TOOLTIP         'Toggle automatic tab syncronization'
                         ON CHANGE       TabAutoSync('PAN')
                 END CHECKBOX

                 @ 25, 00 IMAGE IBorde1PAN ;
                     PICTURE         'YELLOW' ;
                     WIDTH           GetDesktopRealWidth() - 348 ;
                     HEIGHT          GetDesktopRealHeight() - 217 ;
                     STRETCH
                 @ 35, 10 RICHEDITBOX RichEditPAN ;
                         WIDTH           GetDesktopRealWidth() - 364 ;
                         HEIGHT          GetDesktopRealHeight() - 272 ;
                         READONLY ;
                         FONT            'Courier New' ;
                         SIZE            9 ;
                         BACKCOLOR DEF_COLORBACKPAN

                 DEFINE CHECKBOX Check_NumberOnPan
                         CAPTION         'Line Number'
                         ROW             GetDesktopRealHeight() - 224
                         COL             10
                         WIDTH           95
                         HEIGHT          20
                         VALUE           .F.
                         TOOLTIP         "Show line numbers (file's loading is slower)"
                         ON CHANGE       ( bNumberOnPan := GetProperty( 'VentanaMain', 'Check_NumberOnPan', 'value' ), QPM_Wait( "RichEditDisplay( 'PAN', .T. )", 'Reloading ...' ) )
                 END CHECKBOX
                 //      TRANSPARENT     IsXPThemeActive()

                 DEFINE BUTTONEX bReLoadPan
                         ROW             GetDesktopRealHeight() - 227
                         COL             110
                         WIDTH           GetDesktopRealWidth() - 530
                         HEIGHT          25
                         CAPTION 'Reload Form'
                         TOOLTIP 'Reload form file from disk'
                         ONCLICK { || QPM_Wait( "RichEditDisplay( 'PAN', .T. )", 'Reloading ...' ) }
                 END BUTTONEX

                 DEFINE BUTTONEX BLocalSearchPan
                         ROW             GetDesktopRealHeight() - 227
                         COL             GetDesktopRealWidth() - 415
                         WIDTH           60
                         HEIGHT          25
                         CAPTION         'Search'
                         TOOLTIP         'Search in displayed text'
                         ONCLICK LocalSearch( GetProperty( 'VentanaMain', 'CSearch', 'DisplayValue' ) )
                 END BUTTONEX

              END PAGE

              DEFINE PAGE PageDBF

                 DEFINE CHECKBOX Check_AutoSyncDbf
                         CAPTION         'Auto Sync'
                         ROW             00
                         COL             ( GetDesktopRealWidth() - 420 )
                         WIDTH           70
                         HEIGHT          20
                         VALUE           .T.
                         TOOLTIP         'Toggle automatic tab syncronization'
                         ON CHANGE       TabAutoSync('DBF')
                 END CHECKBOX

                 @ 25, 00 IMAGE IBorde1DBF ;
                     PICTURE         'YELLOW' ;
                     WIDTH           GetDesktopRealWidth() - 348 ;
                     HEIGHT          GetDesktopRealHeight() - 217 ;
                     STRETCH
                 @ 35, 10 RICHEDITBOX RichEditDBF ;
                         WIDTH           GetDesktopRealWidth() - 364 ;
                         HEIGHT          GetDesktopRealHeight() - int( ( GetDesktopRealHeight() * 78 ) / 100 ) ;
                         READONLY ;
                         FONT            'Courier New' ;
                         SIZE            9 ;
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
                         CAPTION         'Auto View'
                         ROW             GetDesktopRealHeight() - 223
                         COL             10
                         WIDTH           80
                         HEIGHT          20
                         VALUE           bDbfAutoView
                         TOOLTIP         'Toggle automatic browsing of DBF file in Quick View'
                         ON CHANGE       ( bDbfAutoView := GetProperty( 'VentanaMain', 'Check_DbfAutoView', 'Value' ), QPM_Wait( "RichEditDisplay( 'DBF', .T.,, .F. )", 'Reloading ...' ) )
                 END CHECKBOX
                 //      TRANSPARENT     IsXPThemeActive()

                 DEFINE BUTTONEX bReLoadDbf
                         ROW             GetDesktopRealHeight() - 227
                         COL             90
                         WIDTH           GetDesktopRealWidth() - 675
                         HEIGHT          25
                         CAPTION         if( PUB_bW800, '(Re)Display DBF', 'Force (re)display of DBF information or data' )
                         TOOLTIP         'Display DBF information from disk'
                         ONCLICK         { || QPM_Wait( "RichEditDisplay( 'DBF', .T., NIL, .T. )", 'Reloading ...' ) }
                 END BUTTONEX

                 DEFINE BUTTONEX BLocalSearchStructure
                         ROW             GetDesktopRealHeight() - 227
                         COL             GetDesktopRealWidth() - 580
                         WIDTH           110
                         HEIGHT          25
                         CAPTION         'Search Struc.'
                         TOOLTIP         "Search text in DBF's structure"
                         ONCLICK         LocalSearch( GetProperty( 'VentanaMain', 'CSearch', 'DisplayValue' ) )
                 END BUTTONEX

                 DEFINE BUTTONEX BLocalSearchDbf
                         ROW             GetDesktopRealHeight() - 227
                         COL             GetDesktopRealWidth() - 465
                         WIDTH           110
                         HEIGHT          25
                         CAPTION         'Dbf Search'
                         TOOLTIP         "Search text in DBF's data"
                         ONCLICK         QPM_Wait( "DbfDataSearch( GetProperty( 'VentanaMain', 'CSearch', 'DisplayValue' ) )", 'Searching ...' )
                 END BUTTONEX

              END PAGE

              DEFINE PAGE PageLIB

                 DEFINE CHECKBOX Check_AutoSyncLib
                         CAPTION         'Auto Sync'
                         ROW             00
                         COL             ( GetDesktopRealWidth() - 420 )
                         WIDTH           70
                         HEIGHT          20
                         VALUE           .T.
                         TOOLTIP         'Toggle automatic tab syncronization'
                         ON CHANGE       TabAutoSync('LIB')
                 END CHECKBOX

                 @ 25, 00 IMAGE IBorde1LIB ;
                     PICTURE         'YELLOW' ;
                     WIDTH           GetDesktopRealWidth() - 348 ;
                     HEIGHT          GetDesktopRealHeight() - 217 ;
                     STRETCH
                 @ 35, 10 RICHEDITBOX RichEditLIB ;
                         WIDTH           GetDesktopRealWidth() - 364 ;
                         HEIGHT          GetDesktopRealHeight() - 272 ;
                         READONLY ;
                         FONT            'Courier New' ;
                         SIZE            9 ;
                         BACKCOLOR       DEF_COLORBACKINC

                 DEFINE BUTTONEX bReLoadLib
                         ROW             GetDesktopRealHeight() - 227
                         COL             10
                         WIDTH           GetDesktopRealWidth() - 430
                         HEIGHT          25
                         CAPTION         'List Library/Object (or Re-List)'
                         TOOLTIP         'List Library/Object content'
                         ONCLICK         SetProperty( 'VentanaMain', 'RichEditLib', 'Value', QPM_Wait( "ListModule( '" + ChgPathToReal( US_WordSubStr( GetProperty( "VentanaMain", "GIncFiles", "Cell", VentanaMain.GIncFiles.Value, NCOLINCFULLNAME ), 3 ) ) + "' )", 'Listing ...', NIL, .T. ) )
                 END BUTTONEX

                 DEFINE BUTTONEX BLocalSearchLib
                         ROW             GetDesktopRealHeight() - 227
                         COL             GetDesktopRealWidth() - 415
                         WIDTH           60
                         HEIGHT          25
                         CAPTION         'Search'
                         TOOLTIP         'Search in displayed text'
                         ONCLICK LocalSearch( GetProperty( 'VentanaMain', 'CSearch', 'DisplayValue' ) )
                 END BUTTONEX

              END PAGE

#ifdef QPM_SHG

              DEFINE PAGE PageHlp

                 DEFINE CHECKBOX Check_AutoSyncHlp
                         CAPTION         'Auto Sync'
                         ROW             00
                         COL             ( GetDesktopRealWidth() - 420 )
                         WIDTH           70
                         HEIGHT          20
                         VALUE           .T.
                         TOOLTIP         'Toggle automatic tab syncronization'
                         ON CHANGE       TabAutoSync('HLP')
                 END CHECKBOX

                 @ 25, 00 IMAGE IBorde1Hlp ;
                     PICTURE         'YELLOW' ;
                     WIDTH           GetDesktopRealWidth() - 348 ;
                     HEIGHT          GetDesktopRealHeight() - 217 ;
                     STRETCH
                       //READONLY ;
               //@ 35, 10 RICHEDITBOX RichEditHlp ;
               //        WIDTH           GetDesktopRealWidth() - 364 ;
               //        HEIGHT          GetDesktopRealHeight() - 272 ;
               //        FONT            'Courier New' ;
               //        SIZE            9 ;
               //        BACKCOLOR DEF_COLORBACKHLP
              // oHlpRichEdit:vBackColor := DEF_COLORPan
              // oHlpRichEdit:vFontColor := DEF_COLOREdit
                 oHlpRichEdit:cWindowName      := 'VentanaMain'
                 oHlpRichEdit:cRichControlName := 'RichEditHlp'
                 oHlpRichEdit:cLanguage        := 'EN'
                 oHlpRichEdit:cFunctionPostPaste := 'SHG_Post_Paste()'
           //    oHlpRichEdit:nPorcentajeAncho := 66.8
                 if PUB_bW800
                    oHlpRichEdit:nPorcentajeAncho := 49.0
                    oHlpRichEdit:nPorcentajeAlto  := 72
                 else
                    oHlpRichEdit:nPorcentajeAncho := 60.0
                    if US_InitialBarIsOculta()
                       oHlpRichEdit:nPorcentajeAlto  := 81
                    else
                       oHlpRichEdit:nPorcentajeAlto  := 78
                    endif
                 endif
                 oHlpRichEdit:bEdit       := .T.
                 oHlpRichEdit:bRTF        := .T.
                 oHlpRichEdit:bButtonFind := .F.
              // oHlpRichEdit:cSkin       := 'VP'
                 oHlpRichEdit:Init( '' )
              // oHlpRichEdit:SetTitle( Titulo+' '+ESTRING )
              // oHlpRichEdit:SetBackColor( DEF_COLORPan ) // el cambio dinamico de backcolor de window no esta permitido en minigui oficial
              // oHlpRichEdit:SetTitleBackColor( DEF_COLOREdit )
              // oHlpRichEdit:SetTitleFontColor( DEF_COLORPan )
              // oHlpRichEdit:SetPos( OFFSET )
              // oHlpRichEdit:FindText( TextoABuscar )
              // oHlpRichEdit:Activate()
                 SetProperty( 'VentanaMain', 'RichEditHlp', 'readonly', .T. )

                 DEFINE BUTTONEX BAddHlpKey
                         ROW             GetProperty( 'VentanaMain', 'CB_Vinetas', 'row' )
                         COL             GetDesktopRealWidth() - 416
                         WIDTH           28
                         HEIGHT          25
                         PICTURE         'add'
                         TOOLTIP         'Add key to index'
                         ONCLICK SHG_AddHlpKey()
                 END BUTTONEX

                 DEFINE BUTTONEX BRemoveHlpKey
                         ROW             GetProperty( 'VentanaMain', 'CB_Vinetas', 'row' )
                         COL             GetDesktopRealWidth() - 384
                         WIDTH           28
                         HEIGHT          25
                         PICTURE         'remove'
                         TOOLTIP         'Remove key from index'
                         ONCLICK QPM_RemoveKeyHLP()
                 END BUTTONEX

                 nRow    := GetProperty( 'VentanaMain', 'RichEditHlp', 'row' )
                 nCol    := GetProperty( 'VentanaMain', 'RichEditHlp', 'col' ) + GetProperty( 'VentanaMain', 'RichEditHlp', 'width' ) + 20
                 nWidth  := ( GetDesktopRealWidth() - 480 ) + 124 - nCol
                 nHeight := GetProperty( 'VentanaMain', 'RichEditHlp', 'Height' )

                 @ nRow, nCol GRID GHlpKeys ;
                    WIDTH nWidth ;
                    HEIGHT nHeight ;
                    HEADERS { 'Keys' } ;
                    WIDTHS { 100 };
                    ITEMS {} ;
                    VALUE 0 ;
                    TOOLTIP "Index keys associated with this topic" ;
                    BACKCOLOR DEF_COLORBACKHLP ;
                    ON DBLCLICK { QPM_EditKeyHLP() } ;
                    PAINTDOUBLEBUFFER ;
                    JUSTIFY { BROWSE_JTFY_LEFT }

                 DEFINE BUTTONEX bReLoadHlp
                         ROW             GetDesktopRealHeight() - 227
                         COL             10
                         WIDTH           124
                         HEIGHT          25
                         CAPTION         'Cancel changes ?'
                         TOOLTIP         'Select "Yes" to discard changes'
                         ONCLICK         { || QPM_Wait( 'SHG_CancelChangesTopic()', 'Checking for restore ...' ) }
                 END BUTTONEX

                 DEFINE CHECKBOX CH_SHG_TypeOutput
                         CAPTION         'Add HTML Output'
                         ROW             GetDesktopRealHeight() - 224
                         COL             if( PUB_bW800, 140, 230 )
                         WIDTH           if( PUB_bW800, 120, 120 )
                         HEIGHT          20
                         VALUE           SHG_CheckTypeOutput
                         TOOLTIP         'Toggles generation of HTML files'
                         ON CHANGE       ( SHG_CheckTypeOutput := GetProperty( 'VentanaMain', 'CH_SHG_TypeOutput', 'value' ) )
                 END CHECKBOX

                 DEFINE BUTTONEX BLocalSearchHlp
                         ROW             GetDesktopRealHeight() - 227
                         COL             GetDesktopRealWidth() - 480
                         WIDTH           124
                         HEIGHT          25
                         CAPTION         'Search'
                         TOOLTIP         'Search in displayed text'
                         ONCLICK LocalSearch( GetProperty( 'VentanaMain', 'CSearch', 'DisplayValue' ) )
                 END BUTTONEX

              END PAGE

#endif

              DEFINE PAGE PageSysout

                 DEFINE LABEL L_OverrideCompile
                         ROW             40
                         COL             10
                         WIDTH           150
                         VALUE           'Extra Compile Params'
                         TRANSPARENT     IsXPThemeActive()
                 END LABEL
                 
                 DEFINE TEXTBOX OverrideCompile
                         ROW             37
                         COL             155
                         WIDTH           ( GetDesktopRealWidth() - 670 ) / 2
                         HEIGHT          25
                 END TEXTBOX

                 DEFINE LABEL L_OverrideLink
                         ROW             40
                         COL             145 + ( ( GetDesktopRealWidth() - 620 ) / 2 )
                         WIDTH           150
                         VALUE           'Extra Link Params:'
                         TRANSPARENT     IsXPThemeActive()
                 END LABEL
                 
                 DEFINE TEXTBOX OverrideLink
                         ROW             37
                         COL             263 + ( ( GetDesktopRealWidth() - 620 ) / 2 )
                         WIDTH           ( GetDesktopRealWidth() - 620 ) / 2
                         HEIGHT          25
                 END TEXTBOX

                 @ 75, 10 RICHEDITBOX RichEditSysout ;
                         WIDTH           GetDesktopRealWidth() - 364 ;
                         HEIGHT          GetDesktopRealHeight() - 312 ;
                         READONLY ;
                         FONT            'Courier New' ;
                         SIZE            9

                 DEFINE BUTTONEX BLocalSearchSysOut
                         ROW             GetDesktopRealHeight() - 227
                         COL             10
                         WIDTH           GetDesktopRealWidth() - 364
                         HEIGHT          25
                         CAPTION         'Search'
                         TOOLTIP         'Search in displayed text'
                         ONCLICK         LocalSearch( GetProperty( 'VentanaMain', 'CSearch', 'DisplayValue' ) )
                 END BUTTONEX

              END PAGE

              DEFINE PAGE PageOUT

                 @ 35, 10 RICHEDITBOX RichEditOUT ;
                         WIDTH           GetDesktopRealWidth() - 364 ;
                         HEIGHT          GetDesktopRealHeight() - 272 ;
                         READONLY ;
                         BACKCOLOR       DEF_COLORBACKOUT ;
                         FONT            'Courier New' ;
                         SIZE            9

                 DEFINE BUTTONEX bDeleteErrorLog
                         ROW             GetDesktopRealHeight() - 227
                         COL             10
                         WIDTH           120
                         HEIGHT          25
                         CAPTION         'Delete Error Log'
                         TOOLTIP         "Delete content of MiniGui's error log"
                         ONCLICK QPM_DeleteErrorLog()
                 END BUTTONEX

                 DEFINE BUTTONEX bReLoadErrorLog
                         ROW             GetDesktopRealHeight() - 227
                         COL             140
                         WIDTH           GetDesktopRealWidth() - 780
                         HEIGHT          25
                         CAPTION         'Reload Error Log'
                         TOOLTIP         "Reload content of MiniGui's error log"
                         ONCLICK MuestroErrorLog()
                 END BUTTONEX

                 DEFINE BUTTONEX bReLoadOut
                         ROW             GetDesktopRealHeight() - 227
                         COL             GetDesktopRealWidth() - 620
                         WIDTH           184
                         HEIGHT          25
                         CAPTION         '(Re)List Output File'
                         TOOLTIP         "List content of project's output file"
                         ONCLICK         ( SetProperty( 'VentanaMain', 'RichEditOut', 'Value', QPM_Wait( "ListModuleMoved( '" + GetOutputModuleName() + "' )", 'Listing ...' ) ), SetProperty( 'VentanaMain', 'RichEditOut', 'caretpos', 1 ) )
                 END BUTTONEX

                 DEFINE BUTTONEX BLocalSearchOut
                         ROW             GetDesktopRealHeight() - 227
                         COL             GetDesktopRealWidth() - 415
                         WIDTH           60
                         HEIGHT          25
                         CAPTION         'Search'
                         TOOLTIP         'Search in displayed text'
                         ONCLICK LocalSearch( GetProperty( 'VentanaMain', 'CSearch', 'DisplayValue' ) )
                 END BUTTONEX

              END PAGE


           END TAB


           DEFINE BUTTONEX BStop
                   ROW             GetDesktopRealHeight() - 118
                   COL             328
                   WIDTH           85
                   HEIGHT          25
                   PICTURE         'STOP'
                   TOOLTIP         'Stop BUILD process'
                   ONCLICK         QPM_Wait( 'BuildStop()', 'Stopping, please wait ...' )
           END BUTTONEX

#ifdef QPM_KILLER
           DEFINE BUTTONEX BKill
                   ROW             GetDesktopRealHeight() - 118
                   COL             418
                   WIDTH           85
                   HEIGHT          25
                   PICTURE         'KILL'
                   TOOLTIP         'Use "Process Manager" to kill a process'
                   ONCLICK         ( SetProperty( 'VentanaMain', 'bKill', 'Enabled', .F. ), DoMethod( 'WinKiller', 'restore' ), QPM_bKiller := .T., if( PUB_QPM_bHigh, NIL, QPM_SetProcessPriority( 'HIGH' ) ), SetProperty( 'WinKiller', 'TimerRefresh', 'Enabled', GetProperty( 'WinKiller', 'Check_AutoRefresh', 'value' ) ), DoMethod( 'VentanaMain', 'minimize' ) )
           END BUTTONEX
#endif

           @ GetDesktopRealHeight() - 118, 508 COMBOBOX CSearch ;
              ITEMS {} ;
              VALUE 1 ;
              DISPLAYEDIT ;
              WIDTH GetDesktopRealWidth() - if( PUB_bW800, 735, 810 ) ;
              TOOLTIP 'Text to search for' ;
              ON ENTER ( AddSearchTxt(), QPM_Wait( "GlobalSearch( GetProperty( 'VentanaMain', 'CSearch', 'DisplayValue' ) )", 'Searching ...' ) )
              ON LOSTFOCUS AddSearchTxt()

           DEFINE BUTTONEX BGlobalSearch
                   ROW             GetDesktopRealHeight() - 118
                   COL             GetDesktopRealWidth() - if( PUB_bW800, 223, 293 )
                   WIDTH           90
                   HEIGHT          25
                   CAPTION         'Global Search'
                   TOOLTIP         "Search in all project's files"
                   ONCLICK         ( AddSearchTxt(), QPM_Wait( "GlobalSearch( GetProperty( 'VentanaMain', 'CSearch', 'DisplayValue' ) )", 'Searching ...' ) )
           END BUTTONEX

           DEFINE BUTTONEX BGlobalReset
                   ROW             GetDesktopRealHeight() - 118
                   COL             GetDesktopRealWidth() - if( PUB_bW800, 129, 194 )
                   WIDTH           if( PUB_bW800, 15, 50 )
                   HEIGHT          25
                   CAPTION         if( PUB_bW800, 'R', 'Reset' )
                   TOOLTIP         'Reset Global Search indicators and counts'
                   ONCLICK         QPM_Wait( "ResetImgGrid( '*' )", 'Reseting Search Indicators ...' )
           END BUTTONEX
           VentanaMain.BGlobalReset.Enabled := .F.

           DEFINE CHECKBOX Check_SearchFun
                   CAPTION         if( PUB_bW800, 'Func/Proc', 'Func/Proc/Method' )
                   ROW             GetDesktopRealHeight() - 125
                   COL             GetDesktopRealWidth() - if( PUB_bW800, 105, 135 )
                   WIDTH           if( PUB_bW800, 80, 120 )
                   HEIGHT          20
                   VALUE           .F.
                   TOOLTIP         'Global Search: only find Function, Procedure and/or Method name'
                   TRANSPARENT     IsXPThemeActive()
           END CHECKBOX

           DEFINE CHECKBOX Check_SearchDbf
                   CAPTION         if( PUB_bW800, 'DBF Data', 'DBF Data Search' )
                   ROW             GetDesktopRealHeight() - 104
                   COL             GetDesktopRealWidth() - if( PUB_bW800, 105, 135 )
                   WIDTH           if( PUB_bW800, 80, 120 )
                   HEIGHT          20
                   VALUE           .F.
                   TOOLTIP         "Global Search: include DBF's data in search process"
                   TRANSPARENT     IsXPThemeActive()
           END CHECKBOX

           DEFINE CHECKBOX Check_SearchCas
                   CAPTION         if( PUB_bW800, 'Case Sens', 'Case Sensitive' )
                   ROW             GetDesktopRealHeight() - 83
                   COL             GetDesktopRealWidth() - if( PUB_bW800, 105, 135 )
                   WIDTH           if( PUB_bW800, 80, 120 )
                   HEIGHT          20
                   VALUE           .F.
                   TOOLTIP         "Global Search: include DBF's data in search process"
                   TRANSPARENT     IsXPThemeActive()
           END CHECKBOX

           DEFINE LABEL Label_2
                   ROW             GetDesktopRealHeight() - 85
                   COL             328
                   VALUE           'F1 Help     F2 Open/New    F3 Save     F4 Build     F5 Run     F10 Exit'
                   AUTOSIZE        .T.
                   FONTNAME        'Arial'
                   FONTSIZE        9
                   TRANSPARENT     IsXPThemeActive()
           END LABEL

           DEFINE LABEL LGlobal
                   ROW             GetDesktopRealHeight() - 85
                   COL             GetDesktopRealWidth() - if( PUB_bW800, 205, 330 )
                   WIDTH           if( PUB_bW800, 80, 180 )
                   VALUE           if( PUB_bW800, 'Global Is On', 'Global Search Is Active' )
                   FONTNAME        'arial'
                   FONTSIZE        10
                   FONTBOLD        .T.
                   FONTCOLOR       DEF_COLORRED
                   TOOLTIP         'Global Search is active, use "Reset" button to disable'
                   TRANSPARENT     IsXPThemeActive()
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

#ifdef QPM_SHG
           ON KEY CONTROL+V  ACTION SHG_Send_Paste()
           ON KEY CONTROL+C  ACTION SHG_Send_Copy()
           ON KEY CONTROL+X  ACTION SHG_Send_Cut()
#else
           ON KEY CONTROL+V  ACTION US_Send_Paste()
           ON KEY CONTROL+C  ACTION US_Send_Copy()
           ON KEY CONTROL+X  ACTION SHG_Send_Cut()
#endif
   END WINDOW
#ifdef QPM_KILLER
   QPM_DefinoKillerWindow()
   DoMethod( 'WinKiller', 'hide' )
#endif

   if ! PUB_bLite
      TabChange( 'FILES' )
   endif

   CargoSearch()

   if PUB_bLite

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
                      ROW             15
                      COL             28
                      WIDTH           100
                      HEIGHT          18
                      VALUE           PUB_cStatusLabel
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
                      WIDTH           ( ( GetDesktopRealWidth() * 67 ) / 100 ) ;
                      HEIGHT          ( ( GetDesktopRealHeight() * 74 ) / 100 ) ;
                      READONLY ;
                      FONT            'Arial' ;
                      SIZE            9 ;
                      BACKCOLOR       DEF_COLORBACKSYSOUT

              DEFINE LABEL Label_3
                      ROW             ( ( GetDesktopRealHeight() * 86 ) / 100 )
                      COL             50
                      VALUE           'F5: Run'
                      AUTOSIZE        .T.
                      FONTNAME        'Arial'
                      FONTSIZE        9
              END LABEL
              VentanaLite.Label_3.enabled := .F.

              DEFINE BUTTONEX BStop
                      ROW             ( ( GetDesktopRealHeight() * 85 ) / 100 )
                      COL             ( ( GetDesktopRealWidth() * 18 ) / 100 )
                      WIDTH           75
                      HEIGHT          25
                      PICTURE 'STOP'
                      TOOLTIP 'Stop BUILD process'
                      ONCLICK QPM_Wait( 'BuildStop()', 'Stopping, please wait ...' )
              END BUTTONEX

              DEFINE BUTTONEX BAbout
                      ROW             ( ( GetDesktopRealHeight() * 85 ) / 100 )
                      COL             ( ( GetDesktopRealWidth() * 28 ) / 100 )
                      WIDTH           75
                      HEIGHT          25
                      CAPTION         'About'
                      TOOLTIP         "QPM's info and credits"
                      ONCLICK QPM_About()
              END BUTTONEX

              DEFINE BUTTONEX BRunP
                      ROW             ( ( GetDesktopRealHeight() * 85 ) / 100 )
                      COL             ( ( GetDesktopRealWidth() * 38 ) / 100 )
                      WIDTH           75
                      HEIGHT          25
                      CAPTION 'Run Parm'
                      TOOLTIP 'Run program using command line parameters'
                      ONCLICK ( bRunParm := .T., QPM_Run( bRunParm ) )
              END BUTTONEX
              
              DEFINE BUTTONEX BRun
                      ROW             ( ( GetDesktopRealHeight() * 85 ) / 100 )
                      COL             ( ( GetDesktopRealWidth() * 48 ) / 100 )
                      WIDTH           75
                      HEIGHT          25
                      CAPTION 'Run'
                      TOOLTIP 'Run program without command line parameters'
                      ONCLICK ( bRunParm := .F., QPM_Run( bRunParm ) )
              END BUTTONEX
              
              VentanaLite.BRunP.enabled := .F.
              VentanaLite.BRun.enabled := .F.

              DEFINE BUTTONEX BExit
                      ROW             ( ( GetDesktopRealHeight() * 85 ) / 100 )
                      COL             ( ( GetDesktopRealWidth() * 58 ) / 100 )
                      WIDTH           75
                      HEIGHT          25
                      CAPTION 'Exit'
                      TOOLTIP 'Exit QPM and return to caller'
                      ONCLICK if( PUB_bIsProcessing, NIL, DoMethod( 'VentanaLite', 'release' ) )
              END BUTTONEX
      END WINDOW

      CENTER WINDOW VentanaLite

      VentanaMain.Minimize()

   endif

   QPM_SetProcessPriority( 'NORMAL' )

   SetProperty( 'VentanaMain', 'OverrideCompile', 'enabled', .F. )
   SetProperty( 'VentanaMain', 'OverrideLink', 'enabled', .F. )

#ifdef QPM_KILLER
   ACTIVATE WINDOW WinKiller, VentanaMain
#else
   ACTIVATE WINDOW VentanaMain
#endif

Return Nil

Function QPM_AddFilesPRG
Return QPM_Wait( 'QPM_AddFilesPRG2()', 'Loading file ...' )

Function QPM_AddFilesPRG2()
   Local Files, x, i, Exists
   Local bTop := if( GetProperty( 'VentanaMain', 'GPrgFiles', 'itemcount' ) == 0, .T., .F. )
   if Empty( PUB_cProjectFolder ) .or. ! US_IsDirectory( PUB_cProjectFolder )
      MsgStop( DBLQT + "Project Folder" + DBLQT + " is not a valid folder:" + Hb_OsNewLine() + PUB_cProjectFolder + Hb_OsNewLine() + 'Look at tab ' + DBLQT + PagePRG + DBLQT )
      Return .F.
   endif
// SetMGWaitHide()
   Files := QPM_GetFilesPRG()
   x := 1
   Do While x <= Len( Files )
      if " " $ US_FileNameOnlyNameAndExt( Files[ x ] )
         MsgStop( "QPM can't handle filenames with spaces." + Hb_OsNewLine() + DBLQT + Files[ x ] + DBLQT + ' will be deleted.' )
         aDel( Files, x )
         aSize( Files, Len( Files ) - 1 )
      else
         x ++
      endif
   EndDo
// SetMGWaitShow()
   if len( Files ) == 1
      if ! ( US_Upper( US_FileNameOnlyExt( Files[1] ) ) == 'PRG' ) .and. ;
         ! ( US_Upper( US_FileNameOnlyExt( Files[1] ) ) == 'C' ) .and. ;
         ! ( US_Upper( US_FileNameOnlyExt( Files[1] ) ) == 'CPP' ) .and. ;
         ! ( US_Upper( US_FileNameOnlyExt( Files[1] ) ) == 'LIB' ) .and. ;
         ! ( US_Upper( US_FileNameOnlyExt( Files[1] ) ) == 'A' ) .and. ;
         ! ( US_Upper( US_FileNameOnlyExt( Files[1] ) ) == 'DLL' )
         Files[1] := Files[1] + '.PRG'
      endif
      if ! file( Files[1] )
         if ! MyMsgYesNo( 'File not found: ' + DBLQT + Files[1] + DBLQT + Hb_OsNewLine() + 'Do you want to create an empty file ?' )
            Return .F.
         endif
         if US_Upper( US_FileNameOnlyExt( Files[1] ) ) == 'PRG'
            QPM_CreateNewFile( 'PRG', Files[1] )
         else
            QPM_MemoWrit( Files[1], ' ' )
         endif
      endif
   endif
   For x := 1 To Len( Files )
      Exists := .F.
   // if substr( US_FileNameOnlyPath( Files[x] ), 2, 2 ) == ':' + DEF_SLASH .and. len( US_FileNameOnlyPath( Files[x] ) ) == 3
   //    MsgStop( 'Components located in a root folder will not work correctly in QPM: ' + Files[ x ] )
   //    exit
   // endif
      Files[x] := ChgPathToRelative( Files[x] )
      For i := 1 To VentanaMain.GPrgFiles.ItemCount
         If US_Upper(alltrim(Files [x])) == US_Upper(alltrim(GetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', i, NCOLPRGFULLNAME )))
            Exists := .T.
            Exit
         EndIf
      Next i
      If .Not. Exists
         VentanaMain.GPrgFiles.AddItem( { PUB_nGridImgNone, ' ', US_FileNameOnlyNameAndExt( Files[x] ), Files[x], '0', '', '' } )
         if ! empty( cLastGlobalSearch )
            if GlobalSearch2( 'PRG', cLastGlobalSearch, VentanaMain.GPrgFiles.ItemCount, bLastGlobalSearchFun, bLastGlobalSearchDbf )
               TotCaption( 'PRG', +1 )
            endif
         endif
         if AScan( vExtraFoldersForSearch, { |y| upper( US_VarToStr( y ) ) == upper( US_FileNameOnlyPath( ChgPathToReal( Files[x] ) ) ) } ) == 0
            aadd( vExtraFoldersForSearch, US_FileNameOnlyPath( ChgPathToReal( Files[x] ) ) )
         endif
      EndIf
   Next x
   if VentanaMain.GPrgFiles.Value = 0
      VentanaMain.GPrgFiles.Value := 1
   endif
   DoMethod( 'VentanaMain', 'GPrgFiles', 'ColumnsAutoFitH' )
   QPM_CheckFiles()
// QPM_ForceRecompCheck( ChgPathToReal( GetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', GetProperty( 'VentanaMain', 'GPrgFiles', 'ItemCount' ), NCOLPRGFULLNAME ) ), GetProperty( 'VentanaMain', 'GPrgFiles', 'ItemCount' ) )
   if bTop .and. VentanaMain.GPrgFiles.ItemCount > 0
      CambioTitulo()
      MsgInfo ( DBLQT + ChgPathToReal( GetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', 1, NCOLPRGFULLNAME ) ) + DBLQT + Hb_OsNewLine() + 'is the new project´s "Top File".' )
   endif
Return .T.

Function QPM_AddFilesHEA
Return QPM_Wait( 'QPM_AddFilesHEA2()', 'Loading ...' )

Function QPM_AddFilesHEA2()
   Local Files, x, i, Exists
   if Empty( PUB_cProjectFolder ) .or. ! US_IsDirectory( PUB_cProjectFolder )
      MsgStop( DBLQT + "Project Folder" + DBLQT + " is not a valid folder:" + Hb_OsNewLine() + PUB_cProjectFolder + Hb_OsNewLine() + 'Look at tab ' + DBLQT + PagePRG + DBLQT )
      Return .F.
   endif
   SetMGWaitHide()
   Files := QPM_GetFilesHEA()
   SetMGWaitShow()
   if len( Files ) == 1
      if ! ( US_Upper( US_FileNameOnlyExt( Files[1] ) ) == 'H' ) .and. ;
         ! ( US_Upper( US_FileNameOnlyExt( Files[1] ) ) == 'CH' )
         Files[1] := Files[1] + '.H'
      endif
      if ! file( Files[1] )
         if MyMsgYesNo( 'File not found: ' + DBLQT + Files[1] + DBLQT + Hb_OsNewLine() + 'Do you want create an empty file ?' )
            QPM_CreateNewFile( 'HEA', Files[1] )
         else
            Return .F.
         endif
      endif
   endif
   For x := 1 To Len ( Files )
      Exists := .F.
      Files[x] := ChgPathToRelative( Files[x] )
      For i := 1 To VentanaMain.GHeaFiles.ItemCount
         If US_Upper(alltrim(Files [x])) == US_Upper(alltrim(GetProperty( 'VentanaMain', 'GHeaFiles', 'Cell', i, NCOLHEAFULLNAME )))
            Exists := .T.
            Exit
         EndIf
      Next i
      If .Not. Exists
         VentanaMain.GHeaFiles.AddItem( { PUB_nGridImgNone, US_FileNameOnlyNameAndExt( Files[x] ), Files[x], '0', '', '' } )
         if ! empty( cLastGlobalSearch )
            if GlobalSearch2( 'HEA', cLastGlobalSearch, VentanaMain.GHeaFiles.ItemCount, bLastGlobalSearchFun, bLastGlobalSearchDbf )
               TotCaption( 'HEA', +1 )
            endif
         endif
   //    if ascan( vExtraFoldersForSearch, US_FileNameOnlyPath( ChgPathToReal( Files[x] ) ) ) = 0
         if AScan( vExtraFoldersForSearch, { |y| upper( US_VarToStr( y ) ) == upper( US_FileNameOnlyPath( ChgPathToReal( Files[x] ) ) ) } ) == 0
            aadd( vExtraFoldersForSearch, US_FileNameOnlyPath( ChgPathToReal( Files[x] ) ) )
         endif
      EndIf
   Next x
   if VentanaMain.GHeaFiles.Value = 0
      VentanaMain.GHeaFiles.Value := 1
   endif
   DoMethod( 'VentanaMain', 'GHeaFiles', 'ColumnsAutoFitH' )
   QPM_CheckFiles()
Return .T.

Function QPM_AddFilesPAN
Return QPM_Wait( 'QPM_AddFilesPAN2()', 'Loading ...' )

Function QPM_AddFilesPAN2()
   Local Files, x, i, Exists
   if Empty( PUB_cProjectFolder ) .or. ! US_IsDirectory( PUB_cProjectFolder )
      MsgStop( DBLQT + "Project Folder" + DBLQT + " is not a valid folder:" + Hb_OsNewLine() + PUB_cProjectFolder + Hb_OsNewLine() + 'Look at tab ' + DBLQT + PagePRG + DBLQT )
      Return .F.
   endif
   // SetMGWaitHide()
   Files := QPM_GetFilesPAN()
   if len( Files ) == 1
      if ! ( US_Upper( US_FileNameOnlyExt( Files[1] ) ) == 'FMG' )
         Files[1] := Files[1] + '.FMG'
      endif
      if ! file( Files[1] )
         if MyMsgYesNo( "File '"+Files[1]+"' not found.  Do you want to create an empty file?" )
            if ! QPM_CreateNewFile( 'PAN', Files[1] )
               Return .F.
            endif
         else
            Return .F.
         endif
      endif
   endif
// SetMGWaitShow()
   For x := 1 To Len ( Files )
      Exists := .F.
   // if substr( US_FileNameOnlyPath( Files[x] ), 2, 2 ) == ':' + DEF_SLASH .and. len( US_FileNameOnlyPath( Files[x] ) ) == 3
   //    MsgStop( 'Components located in a root folder will not work correctly in QPM: ' + Files[ x ] )
   //    exit
   // endif
      Files[x] := ChgPathToRelative( Files[x] )
      For i := 1 To VentanaMain.GPanFiles.ItemCount
         If US_Upper(alltrim(Files[x])) == US_Upper(alltrim(GetProperty( 'VentanaMain', 'GPanFiles', 'Cell', i, NCOLPANFULLNAME )))
            Exists := .T.
            Exit
         EndIf
      Next i
      If .Not. Exists
         VentanaMain.GPanFiles.AddItem( { PUB_nGridImgNone, US_FileNameOnlyNameAndExt( Files[x] ), Files[x], '0', '', '' } )
         if ! empty( cLastGlobalSearch )
            if GlobalSearch2( 'PAN', cLastGlobalSearch, VentanaMain.GPanFiles.ItemCount, bLastGlobalSearchFun, bLastGlobalSearchDbf )
               TotCaption( 'PAN', +1 )
            endif
         endif
     //  if ascan( vExtraFoldersForSearch, US_FileNameOnlyPath( ChgPathToReal( Files[x] ) ) ) = 0
         if AScan( vExtraFoldersForSearch, { |y| upper( US_VarToStr( y ) ) == upper( US_FileNameOnlyPath( ChgPathToReal( Files[x] ) ) ) } ) == 0
            aadd( vExtraFoldersForSearch, US_FileNameOnlyPath( ChgPathToReal( Files[x] ) ) )
         endif
      EndIf
   Next x
   if VentanaMain.GPanFiles.Value = 0
      VentanaMain.GPanFiles.Value := 1
   endif
   DoMethod( 'VentanaMain', 'GPanFiles', 'ColumnsAutoFitH' )
   QPM_CheckFiles()
Return .T.

Function QPM_AddFilesDBF
Return QPM_Wait( 'QPM_AddFilesDBF2()', 'Loading ...' )
Function QPM_AddFilesDBF2()
   Local Files, x, i, Exists
   if Empty( PUB_cProjectFolder ) .or. ! US_IsDirectory( PUB_cProjectFolder )
      MsgStop( DBLQT + "Project Folder" + DBLQT + " is not a valid folder:" + Hb_OsNewLine() + PUB_cProjectFolder + Hb_OsNewLine() + 'Look at tab ' + DBLQT + PagePRG + DBLQT )
      Return .F.
   endif
// SetMGWaitHide()
   Files := QPM_GetFilesDBF()
// SetMGWaitShow()
   if len( Files ) == 1
      if ! ( US_Upper( US_FileNameOnlyExt( Files[1] ) ) == 'DBF' )
         Files[1] := Files[1] + '.dbf'
      endif
      if ! file( Files[1] )
         if MyMsgYesNo( 'File not found: ' + DBLQT + Files[1] + DBLQT + Hb_OsNewLine() + 'Do you want create an empty file ?' )
            if ! QPM_CreateNewFile( 'DBF', Files[1] )
               Return .F.
            endif
         else
            Return .F.
         endif
      endif
   endif
   For x := 1 To Len ( Files )
      Exists := .F.
      Files[x] := ChgPathToRelative( Files[x] )
      For i := 1 To VentanaMain.GDbfFiles.ItemCount
         If US_Upper(alltrim(Files [x])) == US_Upper(alltrim(GetProperty( 'VentanaMain', 'GDbfFiles', 'Cell', i, NCOLDBFFULLNAME )))
            Exists := .T.
            Exit
         EndIf
      Next i
      If .Not. Exists
         VentanaMain.GDbfFiles.AddItem( { PUB_nGridImgNone, US_FileNameOnlyNameAndExt( Files[x] ), Files[x], '0 0', '', '0 ** 0' } )
         if ! empty( cLastGlobalSearch )
            if GlobalSearch2( 'DBF', cLastGlobalSearch, VentanaMain.GDbfFiles.ItemCount, bLastGlobalSearchFun, bLastGlobalSearchDbf )
               TotCaption( 'DBF', +1 )
            endif
         endif
   //    if ascan( vExtraFoldersForSearch, US_FileNameOnlyPath( ChgPathToReal( Files[x] ) ) ) = 0
       //if AScan( vExtraFoldersForSearch, { |y| upper( US_VarToStr( y ) ) == upper( US_FileNameOnlyPath( ChgPathToReal( Files[x] ) ) ) } ) == 0
       //   aadd( vExtraFoldersForSearch, US_FileNameOnlyPath( ChgPathToReal( Files[x] ) ) )
       //endif
      EndIf
   Next x
   if VentanaMain.GDbfFiles.Value = 0
      VentanaMain.GDbfFiles.Value := 1
   endif
   DoMethod( 'VentanaMain', 'GDbfFiles', 'ColumnsAutoFitH' )
   QPM_CheckFiles()
Return .T.

Function QPM_AddFilesLIB
Return QPM_Wait( 'QPM_AddFilesLIB2()', 'Loading ...' )
Function QPM_AddFilesLIB2()
   Local Files, x, i, Exists
   SetMGWaitHide()
   Files := QPM_GetFilesLIB()
   SetMGWaitShow()
   For x := 1 To Len( Files )
      Exists := .F.
      Files[x] := ChgPathToRelative( Files[x] )
      For i := 1 To VentanaMain.GIncFiles.ItemCount
         If US_Upper(alltrim(Files[x])) == US_Upper( US_WordSubStr( GetProperty( 'VentanaMain', 'GIncFiles', 'Cell', i, NCOLINCFULLNAME ), 3 ) )
            Exists := .T.
            Exit
         EndIf
      Next i
      If .Not. Exists
         VentanaMain.GIncFiles.AddItem( { PUB_nGridImgNone, US_FileNameOnlyNameAndExt( Files[x] ), '* * ' + Files[x] } )
         LibPos( VentanaMain.GIncFiles.ItemCount, '*Last*' )
         if ! empty( cLastGlobalSearch )
            if GlobalSearch2( 'LIB', cLastGlobalSearch, VentanaMain.GIncFiles.ItemCount, bLastGlobalSearchFun, bLastGlobalSearchDbf )
               TotCaption( 'LIB', +1 )
            endif
         endif
         if AScan( &('vExtraFoldersForLibs'+GetSuffix()), { |y| upper( US_VarToStr( y ) ) == upper( US_FileNameOnlyPath( ChgPathToReal( Files[x] ) ) ) } ) == 0
            aadd( &('vExtraFoldersForLibs'+GetSuffix()), upper( US_FileNameOnlyPath( ChgPathToReal( Files[x] ) ) ) )
         endif
      EndIf
   Next x
   if VentanaMain.GIncFiles.ItemCount = 1
      VentanaMain.GIncFiles.Value := 1
   endif
   DoMethod( 'VentanaMain', 'GIncFiles', 'ColumnsAutoFitH' )
   QPM_CheckFiles()
Return .T.

Function QPM_AddExcludeFilesLIB
   Local Files, x, i, Exists
   Files := QPM_GetExcludeFilesLIB( )
   For x := 1 To Len ( Files )
       Exists := .F.
       For i := 1 To VentanaMain.GExcFiles.ItemCount
          If US_Upper(alltrim(Files[x])) == US_Upper( US_WordSubStr( GetProperty( 'VentanaMain', 'GExcFiles', 'Cell', i, NCOLEXCNAME ), 3 ) )
             Exists := .T.
             Exit
          EndIf
       Next
       If .Not. Exists
          VentanaMain.GExcFiles.AddItem( { PUB_nGridImgNone, Files[x] } )
       EndIf
   next
   DoMethod( 'VentanaMain', 'GExcFiles', 'ColumnsAutoFitH' )
Return .T.

#ifdef QPM_SHG
Function QPM_AddFilesHLP()
   Local cAuxTopic := '', cAuxNick := ''
   if SHG_BaseOK
   // SetMGWaitHide()
      if SHG_InputTopic( @cAuxTopic, @cAuxNick )
   //    SetMGWaitShow()
         VentanaMain.GHlpFiles.AddItem( { 0, cAuxTopic, cAuxNick, '0', 'E' } )
         GridImage( 'VentanaMain', 'GHlpFiles', VentanaMain.GHlpFiles.ItemCount, NCOLHLPSTATUS, '+', PUB_nGridImgHlpPage )
         SHG_AddRecord( 'P', VentanaMain.GHlpFiles.ItemCount, cAuxTopic, cAuxNick, 'New Topic !!!' )
         VentanaMain.GHlpFiles.Value := VentanaMain.GHlpFiles.ItemCount
         DoMethod( 'VentanaMain', 'GHlpFiles', 'ColumnsAutoFitH' )
   // else
   //    SetMGWaitShow()
      endif
   else
      MsgInfo( "Help Database hasn't been selected." + Hb_OsNewLine() + "Use Open button to open or create a Help Database." )
   endif
Return .T.
#endif

Function QPM_EditPRG
   Local Editor, Rs, i, vAux := {}
   Local EditControlFile, RunParms, cLineCmd
#ifdef QPM_HOTRECOVERY
   Local HotRecoveryControlFile
#endif
   if Empty( PUB_cProjectFolder ) .or. ! US_IsDirectory( PUB_cProjectFolder )
      MsgStop( DBLQT + "Project Folder" + DBLQT + " is not a valid folder:" + Hb_OsNewLine() + PUB_cProjectFolder + Hb_OsNewLine() + 'Look at tab ' + DBLQT + PagePRG + DBLQT )
      Return .F.
   endif
   if VentanaMain.GPrgFiles.Value < 1
      MsgStop( 'No file has been selected.' )
      Return .F.
   endif
   if ! File( i := ChgPathToReal( GetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', VentanaMain.GPrgFiles.Value, NCOLPRGFULLNAME ) ) )
      MsgStop( 'File not found: ' + i )
      Return .F.
   endif
   if ! File( alltrim( Gbl_Text_Editor ) )
      MsgStop( 'Program editor not found: ' + alltrim( Gbl_Text_Editor ) + Hb_OsNewLine() + 'Look at ' + PUB_MenuGblOptions + ' of Settings menu.' )
      Return .F.
   endif
   If Empty( Gbl_Text_Editor )
      MyMsg( 'Operation aborted.', 'Program editor is not defined.' + Hb_OsNewLine() + ' Look at ' + PUB_MenuGblOptions + ' of Settings menu.', 'E', bAutoExit )
      Return .F.
   Else
      Editor := US_ShortName( alltrim( Gbl_Text_Editor ) )
   EndIf
   if bLogActivity
      QPM_MemoWrit( PUB_cQPM_Folder+DEF_SLASH + 'QPM.log', memoread( PUB_cQPM_Folder + DEF_SLASH + 'QPM.log' ) + Hb_OsNewLine() + 'xRefPrgFmg Edit ' + GetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', VentanaMain.GPrgFiles.Value, NCOLPRGFULLNAME ) )
   endif
   if bSuspendControlEdit
      if bEditorLongName
         cLineCmd := ChgPathToReal( GetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', VentanaMain.GPrgFiles.Value, NCOLPRGFULLNAME ) )
      else
         cLineCmd := US_ShortName( ChgPathToReal( GetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', VentanaMain.GPrgFiles.Value, NCOLPRGFULLNAME ) ) )
      endif
      if bLogActivity
         QPM_MemoWrit( PUB_cQPM_Folder+DEF_SLASH + 'QPM.log', memoread( PUB_cQPM_Folder + DEF_SLASH + 'QPM.log' ) + Hb_OsNewLine() + 'Editor  ' + Editor + Hb_OsNewLine() + 'CmdLine ' + cLineCmd )
      endif
      QPM_Execute( Editor, cLineCmd )
   else
      if GridImage( 'VentanaMain', 'GPrgFiles', VentanaMain.GPrgFiles.Value, NCOLPRGSTATUS, '?', PUB_nGridImgEdited )
         MsgInfo( 'The file is already open.' )
         Return .F.
      endif
      GridImage( 'VentanaMain', 'GPrgFiles', VentanaMain.GPrgFiles.Value, NCOLPRGSTATUS, '+', PUB_nGridImgEdited )
      VentanaMain.RichEditPrg.BackColor := DEF_COLORBACKEXTERNALEDIT
      VentanaMain.RichEditPrg.FontColor := DEF_COLORFONTEXTERNALEDIT
      EditControlFile := US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + '_' + PUB_cSecu + 'ECF' + US_DateTimeCen() + '.cnt'
#ifdef QPM_HOTRECOVERY
      HotRecoveryControlFile := US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + '_' + PUB_cSecu + 'SrcHOTRecovery' + US_DateTimeCen() + '.hot'
      US_FileCopy( ChgPathToReal( GetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', VentanaMain.GPrgFiles.Value, NCOLPRGFULLNAME ) ), HotRecoveryControlFile )
      SetFDaTi( HotRecoveryControlFile, US_FileDate( ChgPathToReal( GetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', VentanaMain.GPrgFiles.Value, NCOLPRGFULLNAME ) ) ), US_FileTime( ChgPathToReal( GetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', VentanaMain.GPrgFiles.Value, NCOLPRGFULLNAME ) ) ) )
      SetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', VentanaMain.GPrgFiles.Value, NCOLPRGRECOVERY, HotRecoveryControlFile )
      if _IsControlDefined( 'HR_GridItemTargetPRG', 'WinHotRecovery' )
         GridImage( 'WinHotRecovery', 'HR_GridItemTargetPRG', GetProperty( 'VentanaMain', 'GPrgFiles', 'Value' ), DEF_N_ITEM_COLIMAGE, '+', PUB_nGridImgEdited )
      endif
#endif
      SetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', VentanaMain.GPrgFiles.Value, NCOLPRGEDIT, EditControlFile )
      RunParms        := US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + '_' + PUB_cSecu + 'RP' + US_DateTimeCen() + '.cng'
      if bEditorLongName
         cLineCmd := 'COMMAND ' + Editor + ' ' + ChgPathToReal( GetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', VentanaMain.GPrgFiles.Value, NCOLPRGFULLNAME ) )
      else
         cLineCmd := 'COMMAND ' + Editor + ' ' + US_ShortName( ChgPathToReal( GetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', VentanaMain.GPrgFiles.Value, NCOLPRGFULLNAME ) ) )
      endif
      QPM_MemoWrit( RunParms, 'Run Parms for ' + ChgPathToReal( GetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', VentanaMain.GPrgFiles.Value, NCOLPRGFULLNAME ) ) + Hb_OsNewLine() + ;
                              cLineCmd + Hb_OsNewLine() + ;
                              'CONTROL ' + EditControlFile )
      QPM_MemoWrit( EditControlFile, 'Edit Control File for ' + ChgPathToReal( GetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', VentanaMain.GPrgFiles.Value, NCOLPRGFULLNAME ) ) )
      if bLogActivity
         QPM_MemoWrit( PUB_cQPM_Folder+DEF_SLASH + 'QPM.log', memoread( PUB_cQPM_Folder + DEF_SLASH + 'QPM.log' ) + Hb_OsNewLine() + 'RunParms ' + RunParms )
      endif
      QPM_Execute( US_ShortName( PUB_cQPM_Folder ) + DEF_SLASH + 'US_Run.exe', 'QPM ' + RunParms )
   endif
   if ( Rs := AScan( vSinLoadWindow, { |y| upper( US_VarToStr( y ) ) == US_Upper( ChgPathToReal( GetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', VentanaMain.GPrgFiles.Value, NCOLPRGFULLNAME ) ) ) } ) ) > 0 // Para Forzar Scan de PRG en busca de xREF con FMG
      adel( vSinLoadWindow, Rs ) // Para Forzar Scan de PRG en busca de xREF con FMG
      if bLogActivity
         QPM_MemoWrit( PUB_cQPM_Folder+DEF_SLASH + 'QPM.log', memoread( PUB_cQPM_Folder+DEF_SLASH + 'QPM.log' ) + Hb_OsNewLine() + 'xRefPrgFmg Delete ' + GetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', VentanaMain.GPrgFiles.Value, NCOLPRGFULLNAME ) + ' from vSinLoadWindow by Edit' )
      endif
   endif
   if ( Rs := ascan( vSinInclude, { |y| upper( US_VarToStr( y ) ) == US_Upper( ChgPathToReal( GetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', VentanaMain.GPrgFiles.Value, NCOLPRGFULLNAME ) ) ) } ) ) > 0 // Para Forzar Scan de PRG en busca de xREF con Header
      adel( vSinInclude, Rs ) // Para Forzar Scan de PRG en busca de xREF con HEA
      if bLogActivity
         QPM_MemoWrit( PUB_cQPM_Folder+DEF_SLASH + 'QPM.log', memoread( PUB_cQPM_Folder+DEF_SLASH + 'QPM.log' ) + Hb_OsNewLine() + 'xRefPrgHea Delete ' + GetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', VentanaMain.GPrgFiles.Value, NCOLPRGFULLNAME ) + ' from vSinInclude by Edit' )
      endif
   endif
   /* limpio las ocurrencias del prg dentro de xref con header */
   For i:=1 to len( vXRefPrgHea )
      if !( US_Word( vXRefPrgHea[i], 1 ) == US_Upper( US_FileNameOnlyNameAndExt( GetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', VentanaMain.GPrgFiles.Value, NCOLPRGFULLNAME ) ) ) )
         AADD( vAux, vXRefPrgHea[i] )
      endif
   next
   vXRefPrgHea := {}
   For i:=1 to len( vAux )
      AADD( vXRefPrgHea, vAux[i] )
   next
   /* fin limpio las ocurrencias del prg */
   vAux := {}
   /* limpio las ocurrencias del prg dentro de xref con form   */
   For i:=1 to len( vXRefPrgFmg )
      if !( US_Word( vXRefPrgFmg[i], 1 ) == US_Upper( US_FileNameOnlyNameAndExt( GetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', VentanaMain.GPrgFiles.Value, NCOLPRGFULLNAME ) ) ) )
         AADD( vAux, vXRefPrgFmg[i] )
      endif
   next
   vXRefPrgFmg := {}
   For i:=1 to len( vAux )
      AADD( vXRefPrgFmg, vAux[i] )
   next
   /* fin limpio las ocurrencias del prg */
Return .T.

Function QPM_EditPPO
   Local Editor
   Local cLineCmd
   if Empty( PUB_cProjectFolder ) .or. ! US_IsDirectory( PUB_cProjectFolder )
      MsgStop( DBLQT + "Project Folder" + DBLQT + " is not a valid folder:" + Hb_OsNewLine() + PUB_cProjectFolder + Hb_OsNewLine() + 'Look at tab ' + DBLQT + PagePRG + DBLQT )
      Return .F.
   endif
   if !File( alltrim( Gbl_Text_Editor ) )
      MsgStop( 'Program editor not found: ' + alltrim( Gbl_Text_Editor ) + Hb_OsNewLine() + 'Look at ' + PUB_MenuGblOptions + ' of Settings menu.' )
      Return .F.
   endif
   if VentanaMain.GPrgFiles.Value < 1
      MsgStop( 'No file has been selected.' )
      Return .F.
   endif
   if Empty( Gbl_Text_Editor )
      MyMsg( 'Operation Aborted', 'Program Editor Not Defined.' + Hb_OsNewLine() + 'Look at ' + PUB_MenuGblOptions + ' of Settings menu.', 'E', bAutoExit )
      Return .F.
   endif
   Editor := US_ShortName( alltrim( Gbl_Text_Editor ) )
   if bEditorLongName
      cLineCmd := GetObjFolder() + DEF_SLASH + US_FileNameOnlyName( GetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', VentanaMain.GPrgFiles.Value, NCOLPRGNAME ) ) + '.ppo'
   else
      cLineCmd := US_ShortName( GetObjFolder() + DEF_SLASH + US_FileNameOnlyName( GetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', VentanaMain.GPrgFiles.Value, NCOLPRGNAME ) ) + '.ppo' )
   endif
   if bLogActivity
      QPM_MemoWrit( PUB_cQPM_Folder + DEF_SLASH + 'QPM.log', memoread( PUB_cQPM_Folder+DEF_SLASH + 'QPM.log' ) + Hb_OsNewLine() + 'xRefPrgHea Edit Ppo ' + cLineCmd )
   endif
   QPM_Execute( Editor, cLineCmd )
Return .T.

Function QPM_EditHEA
   Local Editor, i
   Local EditControlFile, RunParms, cLineCmd
#ifdef QPM_HOTRECOVERY
   Local HotRecoveryControlFile
#endif
   if Empty( PUB_cProjectFolder ) .or. ! US_IsDirectory( PUB_cProjectFolder )
      MsgStop( DBLQT + "Project Folder" + DBLQT + " is not a valid folder:" + Hb_OsNewLine() + PUB_cProjectFolder + Hb_OsNewLine() + 'Look at tab ' + DBLQT + PagePRG + DBLQT )
      Return .F.
   endif
   if VentanaMain.GHeaFiles.Value < 1
      MsgStop( 'No file has been selected.' )
      Return .F.
   endif
   if !File( i := ChgPathToReal( GetProperty( 'VentanaMain', 'GHeaFiles', 'Cell', VentanaMain.GHeaFiles.Value, NCOLHEAFULLNAME ) ) )
      MsgStop( 'File not found: ' + i )
      Return .F.
   endif
   If Empty ( Gbl_Text_Editor )
      MyMsg( 'Operation Aborted', "Editor's folder is empty." + Hb_OsNewLine() + 'Look at ' + PUB_MenuGblOptions + ' of Settings menu.', 'E', bAutoExit )
      Return .F.
   EndIf
   if !File( alltrim( Gbl_Text_Editor ) )
      MsgStop( 'Editor program not found: ' + alltrim( Gbl_Text_Editor ) + '.' + Hb_OsNewLine() + 'Look at ' + PUB_MenuGblOptions + ' of Settings menu.' )
      Return .F.
   endif
   Editor := US_ShortName( alltrim( Gbl_Text_Editor ) )
   if bSuspendControlEdit
      if bEditorLongName
         cLineCmd := ChgPathToReal( GetProperty( 'VentanaMain', 'GHeaFiles', 'Cell', VentanaMain.GHeaFiles.Value, NCOLHEAFULLNAME ) )
      else
         cLineCmd := US_ShortName( ChgPathToReal( GetProperty( 'VentanaMain', 'GHeaFiles', 'Cell', VentanaMain.GHeaFiles.Value, NCOLHEAFULLNAME ) ) )
      endif
      if bLogActivity
         QPM_MemoWrit( PUB_cQPM_Folder + DEF_SLASH + 'QPM.log', memoread( PUB_cQPM_Folder + DEF_SLASH + 'QPM.log' ) + Hb_OsNewLine() + 'xRefPrgHea Edit Hea ' + cLineCmd )
      endif
      QPM_Execute( Editor, cLineCmd )
   else
      if GridImage( 'VentanaMain', 'GHeaFiles', VentanaMain.GHeaFiles.Value, NCOLHEASTATUS, '?', PUB_nGridImgEdited )
         MsgInfo( 'The file is already open.' )
         Return .F.
      endif
      GridImage( 'VentanaMain', 'GHeaFiles', VentanaMain.GHeaFiles.Value, NCOLHEASTATUS, '+', PUB_nGridImgEdited )
      VentanaMain.RichEditHea.BackColor := DEF_COLORBACKEXTERNALEDIT
      VentanaMain.RichEditHea.FontColor := DEF_COLORFONTEXTERNALEDIT
      EditControlFile := US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + '_' + PUB_cSecu + 'ECF' + US_DateTimeCen() + '.cnt'
#ifdef QPM_HOTRECOVERY
      HotRecoveryControlFile := US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + '_' + PUB_cSecu + 'HeaHOTRecovery' + US_DateTimeCen() + '.hot'
      US_FileCopy( ChgPathToReal( GetProperty( 'VentanaMain', 'GHeaFiles', 'Cell', VentanaMain.GHeaFiles.Value, NCOLHEAFULLNAME ) ), HotRecoveryControlFile )
      SetFDaTi( HotRecoveryControlFile, US_FileDate( ChgPathToReal( GetProperty( 'VentanaMain', 'GHeaFiles', 'Cell', VentanaMain.GHeaFiles.Value, NCOLHEAFULLNAME ) ) ), US_FileTime( ChgPathToReal( GetProperty( 'VentanaMain', 'GHeaFiles', 'Cell', VentanaMain.GHeaFiles.Value, NCOLHEAFULLNAME ) ) ) )
      SetProperty( 'VentanaMain', 'GHeaFiles', 'Cell', VentanaMain.GHeaFiles.Value, NCOLHEARECOVERY, HotRecoveryControlFile )
      if _IsControlDefined( 'HR_GridItemTargetHea', 'WinHotRecovery' )
         GridImage( 'WinHotRecovery', 'HR_GridItemTargetHea', GetProperty( 'VentanaMain', 'GHeaFiles', 'Value' ), DEF_N_ITEM_COLIMAGE, '+', PUB_nGridImgEdited )
      endif
#endif
      SetProperty( 'VentanaMain', 'GHeaFiles', 'Cell', VentanaMain.GHeaFiles.Value, NCOLHEAEDIT, EditControlFile )
      RunParms        := US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + '_' + PUB_cSecu + 'RP' + US_DateTimeCen() + '.cng'
      if bEditorLongName
         cLineCmd := 'COMMAND ' + Editor + ' ' + ChgPathToReal( GetProperty( 'VentanaMain', 'GHeaFiles', 'Cell', VentanaMain.GHeaFiles.Value, NCOLHEAFULLNAME ) )
      else
         cLineCmd := 'COMMAND ' + Editor + ' ' + US_ShortName( ChgPathToReal( GetProperty( 'VentanaMain', 'GHeaFiles', 'Cell', VentanaMain.GHeaFiles.Value, NCOLHEAFULLNAME ) ) )
      endif
      QPM_MemoWrit( RunParms, 'Run Parms for ' + ChgPathToReal( GetProperty( 'VentanaMain', 'GHeaFiles', 'Cell', VentanaMain.GHeaFiles.Value, NCOLHEAFULLNAME ) ) + Hb_OsNewLine() + ;
                              cLineCmd + Hb_OsNewLine() + ;
                              'CONTROL ' + EditControlFile )
      QPM_MemoWrit( EditControlFile, 'Edit Control File for ' + ChgPathToReal( GetProperty( 'VentanaMain', 'GHeaFiles', 'Cell', VentanaMain.GHeaFiles.Value, NCOLHEAFULLNAME ) ) )
      if bLogActivity
         QPM_MemoWrit( PUB_cQPM_Folder + DEF_SLASH + 'QPM.log', memoread( PUB_cQPM_Folder + DEF_SLASH + 'QPM.log' ) + Hb_OsNewLine() + 'xRefPrgHea Edit Hea ' + cLineCmd )
      endif
      QPM_Execute( US_ShortName( PUB_cQPM_Folder ) + DEF_SLASH + 'US_Run.exe', 'QPM ' + RunParms )
   endif
Return .T.

Function QPM_EditPAN( bForceEditor )
   Local Editor, toolMake, ToolAux, i
   Local EditControlFile, RunParms, cLineCmd
#ifdef QPM_HOTRECOVERY
   Local HotRecoveryControlFile
#endif
   if empty( bForceEditor )
      bForceEditor := .F.
   endif
   if Empty( PUB_cProjectFolder ) .or. ! US_IsDirectory( PUB_cProjectFolder )
      MsgStop( DBLQT + "Project Folder" + DBLQT + " is not a valid folder:" + Hb_OsNewLine() + PUB_cProjectFolder + Hb_OsNewLine() + 'Look at tab ' + DBLQT + PagePRG + DBLQT )
      Return .F.
   endif
   if VentanaMain.GPanFiles.Value < 1
      MsgStop( 'No file has been selected.' )
      Return .F.
   endif
   if ! File( i := ChgPathToReal( GetProperty( 'VentanaMain', 'GPanFiles', 'Cell', VentanaMain.GPanFiles.Value, NCOLPANFULLNAME ) ) )
      MsgStop( 'File not found: ' + i )
      Return .F.
   endif
   if bForceEditor
      ToolAux := 'EDITOR'
   else
      if Prj_Radio_FormTool == DEF_RG_EDITOR
         if us_word( toolMake := CheckMakeForm( US_ShortName( ChgPathToReal( GetProperty( 'VentanaMain', 'GPanFiles', 'Cell', VentanaMain.GPanFiles.Value, NCOLPANFULLNAME ) ) ) ), 1 ) == 'UNKNOWN'
            ToolAux := 'EDITOR'
         else
            ToolAux := US_Word( toolMake, 1 )
            if ToolAux == 'IDE'    /* Todavia no soportada */
               ToolAux := 'HMGSIDE'    /* Todavia no soportada */
            endif
         endif
      else
         ToolAux := cFormTool()
      endif
   endif
   do case
      case ToolAux == 'EDITOR'
         If Empty ( Gbl_Text_Editor )
            MyMsg( 'Operation Aborted', 'Folder for Editor Not Completed.' + Hb_OsNewLine() + 'Look at ' + PUB_MenuGblOptions + ' of Settings menu.', 'E', bAutoExit )
            Return .F.
         Else
            if !File( alltrim( Gbl_Text_Editor ) )
               MsgStop( 'Program editor not found: ' + alltrim( Gbl_Text_Editor ) + '.' + Hb_OsNewLine() + 'Look at ' + PUB_MenuGblOptions + ' of Settings menu.' )
               Return .F.
            endif
            Editor := US_ShortName( alltrim( Gbl_Text_Editor ) )
         EndIf
         if bSuspendControlEdit
            if bEditorLongName
               cLineCmd := ChgPathToReal( GetProperty( 'VentanaMain', 'GPanFiles', 'Cell', VentanaMain.GPanFiles.Value, NCOLPANFULLNAME ) )
            else
               cLineCmd := US_ShortName( ChgPathToReal( GetProperty( 'VentanaMain', 'GPanFiles', 'Cell', VentanaMain.GPanFiles.Value, NCOLPANFULLNAME ) ) )
            endif
            QPM_Execute( Editor, cLineCmd )
         else
            if GridImage( 'VentanaMain', 'GPanFiles', VentanaMain.GPanFiles.Value, NCOLPANSTATUS, '?', PUB_nGridImgEdited )
               MsgInfo( 'Already Opened' )
               Return .F.
            endif
            GridImage( 'VentanaMain', 'GPanFiles', VentanaMain.GPanFiles.Value, NCOLPANSTATUS, '+', PUB_nGridImgEdited )
            VentanaMain.RichEditPan.BackColor := DEF_COLORBACKEXTERNALEDIT
            VentanaMain.RichEditPan.FontColor := DEF_COLORFONTEXTERNALEDIT
            EditControlFile := US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + '_' + PUB_cSecu + 'ECF' + US_DateTimeCen() + '.cnt'
#ifdef QPM_HOTRECOVERY
            HotRecoveryControlFile := US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + '_' + PUB_cSecu + 'PanHOTRecovery' + US_DateTimeCen() + '.hot'
            US_FileCopy( ChgPathToReal( GetProperty( 'VentanaMain', 'GPanFiles', 'Cell', VentanaMain.GPanFiles.Value, NCOLPANFULLNAME ) ), HotRecoveryControlFile )
            SetFDaTi( HotRecoveryControlFile, US_FileDate( ChgPathToReal( GetProperty( 'VentanaMain', 'GPanFiles', 'Cell', VentanaMain.GPanFiles.Value, NCOLPANFULLNAME ) ) ), US_FileTime( ChgPathToReal( GetProperty( 'VentanaMain', 'GPanFiles', 'Cell', VentanaMain.GPanFiles.Value, NCOLPANFULLNAME ) ) ) )
            SetProperty( 'VentanaMain', 'GPanFiles', 'Cell', VentanaMain.GPanFiles.Value, NCOLPANRECOVERY, HotRecoveryControlFile )
            if _IsControlDefined( 'HR_GridItemTargetPan', 'WinHotRecovery' )
               GridImage( 'WinHotRecovery', 'HR_GridItemTargetPan', GetProperty( 'VentanaMain', 'GPanFiles', 'Value' ), DEF_N_ITEM_COLIMAGE, '+', PUB_nGridImgEdited )
            endif
#endif
            SetProperty( 'VentanaMain', 'GPanFiles', 'Cell', VentanaMain.GPanFiles.Value, NCOLPANEDIT, EditControlFile )
            RunParms        := US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + '_' + PUB_cSecu + 'RP' + US_DateTimeCen() + '.cng'
            if bEditorLongName
               cLineCmd := 'COMMAND ' + Editor + ' ' + ChgPathToReal( GetProperty( 'VentanaMain', 'GPanFiles', 'Cell', VentanaMain.GPanFiles.Value, NCOLPANFULLNAME ) )
            else
               cLineCmd := 'COMMAND ' + Editor + ' ' + US_ShortName( ChgPathToReal( GetProperty( 'VentanaMain', 'GPanFiles', 'Cell', VentanaMain.GPanFiles.Value, NCOLPANFULLNAME ) ) )
            endif
            QPM_MemoWrit( RunParms, 'Run Parms for ' + ChgPathToReal( GetProperty( 'VentanaMain', 'GPanFiles', 'Cell', VentanaMain.GPanFiles.Value, NCOLPANFULLNAME ) ) + Hb_OsNewLine() + ;
                                    cLineCmd + Hb_OsNewLine() + ;
                                    'CONTROL ' + EditControlFile )
            QPM_MemoWrit( EditControlFile, 'Edit Control File for ' + ChgPathToReal( GetProperty( 'VentanaMain', 'GPanFiles', 'Cell', VentanaMain.GPanFiles.Value, NCOLPANFULLNAME ) ) )
            QPM_Execute( US_ShortName( PUB_cQPM_Folder ) + DEF_SLASH + 'US_Run.exe', 'QPM ' + RunParms )
         endif
      case ToolAux == 'HMI'
         if GridImage( 'VentanaMain', 'GPanFiles', VentanaMain.GPanFiles.Value, NCOLPANSTATUS, '?', PUB_nGridImgEdited )
            MsgInfo( 'Already Opened' )
            Return .F.
         endif
         If Empty ( Gbl_Text_HMI )
            MyMsg( 'Operation Aborted', 'Folder for Form Tool Not Completed.' + Hb_OsNewLine() + 'Look at ' + PUB_MenuGblOptions + ' of Settings menu.', 'E', bAutoExit )
            Return .F.
         Else
            if !File( alltrim( Gbl_Text_HMI ) )
               MsgStop( 'Form Tool not found: ' + alltrim( Gbl_Text_HMI ) + '.' + Hb_OsNewLine() + 'Look at ' + PUB_MenuGblOptions + ' of Settings menu.' )
               Return .F.
            endif
            Editor := US_ShortName( alltrim( Gbl_Text_HMI ) )
         EndIf
         if !( us_word( toolMake := CheckMakeForm( US_ShortName( ChgPathToReal( GetProperty( 'VentanaMain', 'GPanFiles', 'Cell', VentanaMain.GPanFiles.Value, NCOLPANFULLNAME ) ) ) ), 1 ) == 'HMI' )
            if US_Upper( US_Word( toolMake, 1 ) ) == 'UNKNOWN'
               if ! MyMsgYesNo("Form was builded with tool '"+toolMake+"', do you want to edit with 'HMI+'?" )
                  Return .F.
               endif
            else
               MsgStop( 'Form was builded with tool ' + DBLQT + toolMake + DBLQT + '.' + Hb_OsNewLine() + 'the selected tool, ' + DBLQT + 'HMI' + DBLQT + ', is not compatible.' )
               Return .F.
            endif
         endif
         GridImage( 'VentanaMain', 'GPanFiles', VentanaMain.GPanFiles.Value, NCOLPANSTATUS, '+', PUB_nGridImgEdited )
         VentanaMain.RichEditPan.BackColor := DEF_COLORBACKEXTERNALEDIT
         VentanaMain.RichEditPan.FontColor := DEF_COLORFONTEXTERNALEDIT
         EditControlFile := US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + '_' + PUB_cSecu + 'ECF' + US_DateTimeCen() + '.cnt'
#ifdef QPM_HOTRECOVERY
         HotRecoveryControlFile := US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + '_' + PUB_cSecu + 'PanHOTRecovery' + US_DateTimeCen() + '.hot'
         US_FileCopy( ChgPathToReal( GetProperty( 'VentanaMain', 'GPanFiles', 'Cell', VentanaMain.GPanFiles.Value, NCOLPANFULLNAME ) ), HotRecoveryControlFile )
         SetFDaTi( HotRecoveryControlFile, US_FileDate( ChgPathToReal( GetProperty( 'VentanaMain', 'GPanFiles', 'Cell', VentanaMain.GPanFiles.Value, NCOLPANFULLNAME ) ) ), US_FileTime( ChgPathToReal( GetProperty( 'VentanaMain', 'GPanFiles', 'Cell', VentanaMain.GPanFiles.Value, NCOLPANFULLNAME ) ) ) )
         SetProperty( 'VentanaMain', 'GPanFiles', 'Cell', VentanaMain.GPanFiles.Value, NCOLPANRECOVERY, HotRecoveryControlFile )
         if _IsControlDefined( 'HR_GridItemTargetPan', 'WinHotRecovery' )
            GridImage( 'WinHotRecovery', 'HR_GridItemTargetPan', GetProperty( 'VentanaMain', 'GPanFiles', 'Value' ), DEF_N_ITEM_COLIMAGE, '+', PUB_nGridImgEdited )
         endif
#endif
         SetProperty( 'VentanaMain', 'GPanFiles', 'Cell', VentanaMain.GPanFiles.Value, NCOLPANEDIT, EditControlFile )
         RunParms        := US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + '_' + PUB_cSecu + 'RP' + US_DateTimeCen() + '.cng'
         cLineCmd := 'COMMAND ' + Editor + ' ' + US_ShortName( US_FileNameOnlyPath( ChgPathToReal( GetProperty( 'VentanaMain', 'GPanFiles', 'Cell', VentanaMain.GPanFiles.Value, NCOLPANFULLNAME ) ) ) ) + DEF_SLASH + US_FileNameOnlyName( ChgPathToReal( GetProperty( 'VentanaMain', 'GPanFiles', 'Cell', VentanaMain.GPanFiles.Value, NCOLPANFULLNAME ) ) )
         QPM_MemoWrit( RunParms, 'Run Parms for ' + ChgPathToReal( GetProperty( 'VentanaMain', 'GPanFiles', 'Cell', VentanaMain.GPanFiles.Value, NCOLPANFULLNAME ) ) + Hb_OsNewLine() + ;
                                 cLineCmd + Hb_OsNewLine() + ;
                                 'CONTROL ' + EditControlFile )
         QPM_MemoWrit( EditControlFile, 'Edit Control File for ' + ChgPathToReal( GetProperty( 'VentanaMain', 'GPanFiles', 'Cell', VentanaMain.GPanFiles.Value, NCOLPANFULLNAME ) ) )
         QPM_Execute( US_ShortName( PUB_cQPM_Folder ) + DEF_SLASH + 'US_Run.exe', 'QPM ' + RunParms )
      case ToolAux == 'HMGSIDE'
         if GridImage( 'VentanaMain', 'GPanFiles', VentanaMain.GPanFiles.Value, NCOLPANSTATUS, '?', PUB_nGridImgEdited )
            MsgInfo( 'Already Opened' )
            Return .F.
         endif
         If Empty ( Gbl_Text_HMGSIDE )
            MyMsg( 'Operation Aborted', 'Folder for Form Tool Not Completed.' + Hb_OsNewLine() + 'Look at ' + PUB_MenuGblOptions + ' of Settings menu.', 'E', bAutoExit )
            Return .F.
         Else
            if !File( alltrim( Gbl_Text_HMGSIDE ) )
               MsgStop( 'Form Tool not found: ' + alltrim( Gbl_Text_HMGSIDE ) + '.' + Hb_OsNewLine() + 'Look at ' + PUB_MenuGblOptions + ' of Settings menu.' )
               Return .F.
            endif
            Editor := US_ShortName( alltrim( Gbl_Text_HMGSIDE ) )
         EndIf
         if !( us_word( toolMake := CheckMakeForm( US_ShortName( ChgPathToReal( GetProperty( 'VentanaMain', 'GPanFiles', 'Cell', VentanaMain.GPanFiles.Value, NCOLPANFULLNAME ) ) ) ), 1 ) == 'HMGSIDE' )
            if !( US_Upper( US_Word( toolMake, 1 ) ) == 'HMI' )
               if ! MyMsgYesNo("Form was builded with tool '"+toolMake+"', do you want edit with 'HMGSIDE'?" )
                  Return .F.
               endif
            else
               MsgStop( 'Form was builded with tool ' + DBLQT + toolMake + DBLQT + '.' + Hb_OsNewLine() + 'The selected tool, ' + DBLQT + 'HMGSIDE' + DBLQT + ', is not compatible.' )
               Return .F.
            endif
         endif
         GridImage( 'VentanaMain', 'GPanFiles', VentanaMain.GPanFiles.Value, NCOLPANSTATUS, '+', PUB_nGridImgEdited )
         VentanaMain.RichEditPan.BackColor := DEF_COLORBACKEXTERNALEDIT
         VentanaMain.RichEditPan.FontColor := DEF_COLORFONTEXTERNALEDIT
         EditControlFile := US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + '_' + PUB_cSecu + 'ECF' + US_DateTimeCen() + '.cnt'
#ifdef QPM_HOTRECOVERY
         HotRecoveryControlFile := US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + '_' + PUB_cSecu + 'PanHOTRecovery' + US_DateTimeCen() + '.hot'
         US_FileCopy( ChgPathToReal( GetProperty( 'VentanaMain', 'GPanFiles', 'Cell', VentanaMain.GPanFiles.Value, NCOLPANFULLNAME ) ), HotRecoveryControlFile )
         SetFDaTi( HotRecoveryControlFile, US_FileDate( ChgPathToReal( GetProperty( 'VentanaMain', 'GPanFiles', 'Cell', VentanaMain.GPanFiles.Value, NCOLPANFULLNAME ) ) ), US_FileTime( ChgPathToReal( GetProperty( 'VentanaMain', 'GPanFiles', 'Cell', VentanaMain.GPanFiles.Value, NCOLPANFULLNAME ) ) ) )
         SetProperty( 'VentanaMain', 'GPanFiles', 'Cell', VentanaMain.GPanFiles.Value, NCOLPANRECOVERY, HotRecoveryControlFile )
         if _IsControlDefined( 'HR_GridItemTargetPan', 'WinHotRecovery' )
            GridImage( 'WinHotRecovery', 'HR_GridItemTargetPan', GetProperty( 'VentanaMain', 'GPanFiles', 'Value' ), DEF_N_ITEM_COLIMAGE, '+', PUB_nGridImgEdited )
         endif
#endif
         SetProperty( 'VentanaMain', 'GPanFiles', 'Cell', VentanaMain.GPanFiles.Value, NCOLPANEDIT, EditControlFile )
         RunParms        := US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + '_' + PUB_cSecu + 'RP' + US_DateTimeCen() + '.cng'
         cLineCmd := 'COMMAND ' + Editor + ' ' + US_ShortName( US_FileNameOnlyPath( ChgPathToReal( GetProperty( 'VentanaMain', 'GPanFiles', 'Cell', VentanaMain.GPanFiles.Value, NCOLPANFULLNAME ) ) ) ) + DEF_SLASH + US_FileNameOnlyName( ChgPathToReal( GetProperty( 'VentanaMain', 'GPanFiles', 'Cell', VentanaMain.GPanFiles.Value, NCOLPANFULLNAME ) ) )
         QPM_MemoWrit( RunParms, 'Run Parms for ' + ChgPathToReal( GetProperty( 'VentanaMain', 'GPanFiles', 'Cell', VentanaMain.GPanFiles.Value, NCOLPANFULLNAME ) ) + Hb_OsNewLine() + ;
                                 cLineCmd + Hb_OsNewLine() + ;
                                 'DEFAULTPATH ' + US_FileNameOnlyPath( Editor ) + Hb_OsNewLine() + ;
                                 'CONTROL ' + EditControlFile )
         QPM_MemoWrit( EditControlFile, 'Edit Control File for ' + ChgPathToReal( GetProperty( 'VentanaMain', 'GPanFiles', 'Cell', VentanaMain.GPanFiles.Value, NCOLPANFULLNAME ) ) )
         QPM_Execute( US_ShortName( PUB_cQPM_Folder ) + DEF_SLASH + 'US_Run.exe', 'QPM ' + RunParms )
      otherwise
         MsgInfo( 'Invalid FormTool in Function EditPan: '+ToolAux )
   endcase
   if bLogActivity
      QPM_MemoWrit( PUB_cQPM_Folder + DEF_SLASH + 'QPM.log', memoread( PUB_cQPM_Folder + DEF_SLASH + 'QPM.log' ) + Hb_OsNewLine() + 'xRefPrgFmg Edit Form ' + GetProperty( 'VentanaMain', 'GPanFiles', 'Cell', VentanaMain.GPanFiles.Value, NCOLPANFULLNAME ) )
   endif
Return .T.

Function QPM_EditDBF()
   Local EditControlFile, RunParms, cLineCmd, Editor, i
   if GridImage( 'VentanaMain', 'GDbfFiles', VentanaMain.GDbfFiles.Value, NCOLDBFSTATUS, '?', PUB_nGridImgEdited )
      MsgInfo( 'The DBF is already open.' )
      Return .F.
   endif
   if Empty( PUB_cProjectFolder ) .or. ! US_IsDirectory( PUB_cProjectFolder )
      MsgStop( DBLQT + "Project Folder" + DBLQT + " is not a valid folder:" + Hb_OsNewLine() + PUB_cProjectFolder + Hb_OsNewLine() + 'Look at tab ' + DBLQT + PagePRG + DBLQT )
      Return .F.
   endif
   if VentanaMain.GDbfFiles.Value < 1
      MsgStop( 'No file has been selected.' )
      Return .F.
   endif
   if !File( i := ChgPathToReal( GetProperty( 'VentanaMain', 'GDbfFiles', 'Cell', VentanaMain.GDbfFiles.Value, NCOLDBFFULLNAME ) ) )
      MsgStop( 'File not found: ' + i )
      Return .F.
   endif
   if Prj_Radio_DbfTool == DEF_RG_DBFTOOL
      GridImage( 'VentanaMain', 'GDbfFiles', VentanaMain.GDbfFiles.Value, NCOLDBFSTATUS, '+', PUB_nGridImgEdited )
      VentanaMain.RichEditDbf.BackColor := DEF_COLORBACKEXTERNALEDIT
      VentanaMain.RichEditDbf.FontColor := DEF_COLORFONTEXTERNALEDIT
      CloseDbfAutoView()
      DefineRichEditForNotDbfView( 'DBF Open with external tool !!!' )
      Editor := US_ShortName( alltrim( PUB_cQPM_Folder ) ) + DEF_SLASH + 'US_DBFVIEW.exe'
      EditControlFile := US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + '_' + PUB_cSecu + 'ECF' + US_DateTimeCen() + '.cnt'
      SetProperty( 'VentanaMain', 'GDbfFiles', 'Cell', VentanaMain.GDbfFiles.Value, NCOLDBFEDIT, EditControlFile )
      RunParms        := US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + '_' + PUB_cSecu + 'RP' + US_DateTimeCen() + '.cng'
      cLineCmd := 'COMMAND ' + Editor + ' ' + US_ShortName( US_FileNameOnlyPath( ChgPathToReal( GetProperty( 'VentanaMain', 'GDbfFiles', 'Cell', VentanaMain.GDbfFiles.Value, NCOLDBFFULLNAME ) ) ) ) + DEF_SLASH + US_FileNameOnlyNameAndExt( ChgPathToReal( GetProperty( 'VentanaMain', 'GDbfFiles', 'Cell', VentanaMain.GDbfFiles.Value, NCOLDBFFULLNAME ) ) )
      QPM_MemoWrit( RunParms, 'Run Parms for ' + ChgPathToReal( GetProperty( 'VentanaMain', 'GDbfFiles', 'Cell', VentanaMain.GDbfFiles.Value, NCOLDBFFULLNAME ) ) + Hb_OsNewLine() + ;
                              cLineCmd + Hb_OsNewLine() + ;
                              'CONTROL ' + EditControlFile )
      QPM_MemoWrit( EditControlFile, 'Edit Control File for ' + ChgPathToReal( GetProperty( 'VentanaMain', 'GDbfFiles', 'Cell', VentanaMain.GDbfFiles.Value, NCOLDBFFULLNAME ) ) )
      QPM_Execute( US_ShortName( PUB_cQPM_Folder ) + DEF_SLASH + 'US_Run.exe', 'QPM ' + RunParms )
   else // 'OTHER'
      If Empty ( Gbl_Text_DBF )
         MyMsg( 'Operation Aborted', 'Folder for Dbf Tool Not Completed.' + Hb_OsNewLine() + 'Look at ' + PUB_MenuGblOptions + ' of Settings menu.', 'E', bAutoExit )
         Return .F.
      Else
         if ! File( alltrim( Gbl_Text_DBF ) )
            MsgStop( 'Dbf tool not found: ' + alltrim( Gbl_Text_DBF ) + '.' + Hb_OsNewLine() + 'Look at ' + PUB_MenuGblOptions + ' of Settings menu.' )
            Return .F.
         endif
         Editor := US_ShortName( alltrim( Gbl_Text_DBF ) )
      EndIf
      GridImage( 'VentanaMain', 'GDbfFiles', VentanaMain.GDbfFiles.Value, NCOLDBFSTATUS, '+', PUB_nGridImgEdited )
      VentanaMain.RichEditDbf.BackColor := DEF_COLORBACKEXTERNALEDIT
      VentanaMain.RichEditDbf.FontColor := DEF_COLORFONTEXTERNALEDIT
      CloseDbfAutoView()
      DefineRichEditForNotDbfView( 'DBF Open with external tool !!!' )
      EditControlFile := US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + '_' + PUB_cSecu + 'ECF' + US_DateTimeCen() + '.cnt'
      SetProperty( 'VentanaMain', 'GDbfFiles', 'Cell', VentanaMain.GDbfFiles.Value, NCOLDBFEDIT, EditControlFile )
      RunParms        := US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + '_' + PUB_cSecu + 'RP' + US_DateTimeCen() + '.cng'
      cLineCmd := 'COMMAND ' + Editor + ' ' + Gbl_Comillas_DBF + US_ShortName( US_FileNameOnlyPath( ChgPathToReal( GetProperty( 'VentanaMain', 'GDbfFiles', 'Cell', VentanaMain.GDbfFiles.Value, NCOLDBFFULLNAME ) ) ) ) + DEF_SLASH + US_FileNameOnlyNameAndExt( ChgPathToReal( GetProperty( 'VentanaMain', 'GDbfFiles', 'Cell', VentanaMain.GDbfFiles.Value, NCOLDBFFULLNAME ) ) ) + Gbl_Comillas_DBF
      QPM_MemoWrit( RunParms, 'Run Parms for ' + ChgPathToReal( GetProperty( 'VentanaMain', 'GDbfFiles', 'Cell', VentanaMain.GDbfFiles.Value, NCOLDBFFULLNAME ) ) + Hb_OsNewLine() + ;
                              cLineCmd + Hb_OsNewLine() + ;
                              'CONTROL ' + EditControlFile )
      QPM_MemoWrit( EditControlFile, 'Edit Control File for ' + ChgPathToReal( GetProperty( 'VentanaMain', 'GDbfFiles', 'Cell', VentanaMain.GDbfFiles.Value, NCOLDBFFULLNAME ) ) )
      QPM_Execute( US_ShortName( PUB_cQPM_Folder ) + DEF_SLASH + 'US_Run.exe', 'QPM ' + RunParms )
   endif
   if bLogActivity
      QPM_MemoWrit( PUB_cQPM_Folder + DEF_SLASH + 'QPM.log', memoread( PUB_cQPM_Folder + DEF_SLASH + 'QPM.log' ) + Hb_OsNewLine() + 'xRefPrgFmg Edit Dbf ' + GetProperty( 'VentanaMain', 'GDbfFiles', 'Cell', VentanaMain.GDbfFiles.Value, NCOLDBFFULLNAME ) )
   endif
Return .T.

#ifdef QPM_SHG
Function QPM_EditHLP()
   Local cAuxTopic := '', cAuxNick
   if VentanaMain.GHlpFiles.Value == 1
      MsgInfo( "Global foot can't be edited, it's a System topic !!!" )
      Return .T.
   endif
   if VentanaMain.GHlpFiles.Value > 1
      cAuxTopic := alltrim( GetProperty( 'VentanaMain', 'GHlpFiles', 'Cell', VentanaMain.GHlpFiles.Value, NCOLHLPTOPIC ) )
      cAuxNick  := alltrim( GetProperty( 'VentanaMain', 'GHlpFiles', 'Cell', VentanaMain.GHlpFiles.Value, NCOLHLPNICK ) )
      if SHG_InputTopic( @cAuxTopic, @cAuxNick )
         SetProperty( 'VentanaMain', 'GHlpFiles', 'Cell', VentanaMain.GHlpFiles.Value, NCOLHLPTOPIC, cAuxTopic )
         SetProperty( 'VentanaMain', 'GHlpFiles', 'Cell', VentanaMain.GHlpFiles.Value, NCOLHLPNICK, cAuxNick )
         DoMethod( 'VentanaMain', 'GHlpFiles', 'ColumnsAutoFitH' )
         SHG_SetField( 'SHG_TOPICT', VentanaMain.GHlpFiles.Value, cAuxTopic )
         SHG_SetField( 'SHG_NICKT', VentanaMain.GHlpFiles.Value, cAuxNick )
         if !( alltrim( cAuxTopic ) == SHG_GetField( 'SHG_TOPIC', VentanaMain.GHlpFiles.Value ) ) .or. ;
            !( alltrim( cAuxTopic ) == SHG_GetField( 'SHG_TOPIC', VentanaMain.GHlpFiles.Value ) )
            SetProperty( 'VentanaMain', 'GHlpFiles', 'Cell', VentanaMain.GHlpFiles.Value, NCOLHLPEDIT, 'D' )
         endif
      endif
   endif
Return .T.
#endif

#ifdef QPM_SHG
Function QPM_EditKeyHLP()
   Local cAux, MemoAux := '', i
   if VentanaMain.GHlpKeys.Value > 0
      cAux := InputBox( 'Key:', 'Keys for Help', alltrim( VentanaMain.GHlpKeys.Cell( VentanaMain.GHlpKeys.Value, 1 ) ) )
      if !empty( cAux )
         VentanaMain.GHlpKeys.Cell( VentanaMain.GHlpKeys.Value, 1 ) := cAux
         DoMethod( 'VentanaMain', 'GHlpKeys', 'ColumnsAutoFitH' )
         For i:=1 to VentanaMain.GHlpKeys.ItemCount
            MemoAux := MemoAux + if( i > 1, Hb_OsNewLine(), '' ) + VentanaMain.GHlpKeys.Cell( i, 1 )
         Next
         SHG_SetField( 'SHG_KEYST', VentanaMain.GHlpFiles.Value, MemoAux )
      endif
   endif
Return .T.
#endif

Function QPM_EditRES
   Local Editor, FileRC
   if Empty( PUB_cProjectFolder ) .or. ! US_IsDirectory( PUB_cProjectFolder )
      MsgStop( DBLQT + "Project Folder" + DBLQT + " is not a valid folder:" + Hb_OsNewLine() + PUB_cProjectFolder + Hb_OsNewLine() + 'Look at tab ' + DBLQT + PagePRG + DBLQT )
      Return .F.
   endif
   if VentanaMain.GPrgFiles.ItemCount < 1
      MsgStop( DBLQT + 'Top File' + DBLQT + ' is not defined.' + Hb_OsNewLine() + 'Look at tab ' + DBLQT + PagePRG + DBLQT )
      Return .F.
   endif
   If Empty ( Gbl_Text_Editor )
      MyMsg( 'Operation Aborted', "Editor's folder is empty." + Hb_OsNewLine() + 'Look at ' + PUB_MenuGblOptions + ' of Settings menu.', 'E', bAutoExit )
      Return .F.
   EndIf
   if ! File( alltrim( Gbl_Text_Editor ) )
      MsgStop( 'Editor program not found: ' + alltrim( Gbl_Text_Editor ) + '.' + Hb_OsNewLine() + 'Look at ' + PUB_MenuGblOptions + ' of Settings menu.' )
      Return .F.
   endif
   Editor := US_ShortName( alltrim( Gbl_Text_Editor ) )
   FileRC := US_FileNameOnlyPathAndName( ChgPathToReal( GetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', 1, NCOLPRGFULLNAME ) ) ) + '.RC'
   if ! File( FileRC )
      if ! MyMsgYesNo( 'File not found: ' + DBLQT + FileRC + DBLQT + Hb_OsNewLine() + 'Do you want create an empty file ?' )
         Return .F.
      endif
      QPM_MemoWrit( FileRC, 'MAIN ICON     .' + DEF_SLASH + 'RESOURCES' + DEF_SLASH + 'MAIN.ICO' )
   endif
   QPM_Execute( Editor, if( bEditorLongName, FileRC, US_ShortName( FileRC ) ) )
Return .T.

Function QPM_SetTopPRG
   Local i, vTop, vLine
   i := VentanaMain.GPrgFiles.Value
   If i == 1 .or. i == 0
      Return .T.
   EndIf
   vTop := VentanaMain.GPrgFiles.item( 1 )
   vLine := VentanaMain.GPrgFiles.item( VentanaMain.GPrgFiles.Value )
   VentanaMain.GPrgFiles.item( VentanaMain.GPrgFiles.Value ) := vTop
   VentanaMain.GPrgFiles.item( 1 ) := vLine
   VentanaMain.GPrgFiles.Value := 1
   VentanaMain.GPrgFiles.SetFocus
   MsgInfo ( DBLQT + ChgPathToReal( vLine[NCOLPRGFULLNAME] ) + DBLQT + Hb_OsNewLine() + "is the new project's " + DBLQT + "Top File" + DBLQT + "." )
   CambioTitulo()
Return .T.

Function QPM_GetFilesPRG()
   Local RetVal := {}, BaseFolder, cAux
   if Empty( PUB_cProjectFolder ) .or. ! US_IsDirectory( PUB_cProjectFolder )
      MsgStop( DBLQT + "Project Folder" + DBLQT + " is not a valid folder:" + Hb_OsNewLine() + PUB_cProjectFolder + Hb_OsNewLine() + 'Look at tab ' + DBLQT + PagePRG + DBLQT )
      Return ( {} )
   endif
   if Prj_Radio_OutputType == DEF_RG_IMPORT .and. GetProperty( 'VentanaMain', 'GPrgFiles', 'itemcount' ) > 0
      MsgStop( 'The process to make an Interface Library allows only one source.' )
      Return ( {} )
   endif
   if GetProperty( 'VentanaMain', 'GPrgFiles', 'Value' ) = 0
      BaseFolder := PUB_cProjectFolder
   else
      BaseFolder := US_FileNameOnlyPath( ChgPathToReal( GetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', GetProperty( 'VentanaMain', 'GPrgFiles', 'Value' ), NCOLPRGFULLNAME ) ) )
   endif
   If Right( Basefolder, 1) != DEF_SLASH
      BaseFolder := BaseFolder + DEF_SLASH
   EndIf
   if Prj_Radio_OutputType == DEF_RG_IMPORT
      cAux := BugGetFile( { {'DLL file','*.DLL'} }, 'Select Input Files', BaseFolder, .F., .T. )
      if ! empty( cAux )
         aadd( RetVal, cAux )
      endif
   else
      RetVal := US_GetFile( { {'Source files (prg,c,cpp)','*.prg;*.c;*.cpp'}, {'Only PRG files','*.prg'}, {'Only C files','*.C'}, {'Only C++ files','*.CPP'}, {'Only C and C++ files','*.C;*.CPP'} }, 'Select Source or Input Files', BaseFolder, .T., .T. )
   endif
Return RetVal

Function QPM_GetFilesHEA()
   Local BaseFolder
   if Empty( PUB_cProjectFolder ) .or. ! US_IsDirectory( PUB_cProjectFolder )
      MsgStop( DBLQT + "Project Folder" + DBLQT + " is not a valid folder:" + Hb_OsNewLine() + PUB_cProjectFolder + Hb_OsNewLine() + 'Look at tab ' + DBLQT + PagePRG + DBLQT )
      Return ( {} )
   endif
   if GetProperty( 'VentanaMain', 'GHeaFiles', 'Value' ) = 0
      BaseFolder := PUB_cProjectFolder
   else
      BaseFolder := US_FileNameOnlyPath( ChgPathToReal( GetProperty( 'VentanaMain', 'GHeaFiles', 'Cell', GetProperty( 'VentanaMain', 'GHeaFiles', 'Value' ), NCOLHEAFULLNAME ) ) )
   endif
   If Right( Basefolder, 1 ) != DEF_SLASH
      BaseFolder := BaseFolder + DEF_SLASH
   EndIf
Return US_GetFile( { {'Headers files (*.h and *.ch)','*.h;*.ch'} }, 'Select Headers Files', BaseFolder, .T., .T. )

Function QPM_GetFilesPAN()
   Local BaseFolder
   if Empty( PUB_cProjectFolder ) .or. ! US_IsDirectory( PUB_cProjectFolder )
      MsgStop( DBLQT + "Project Folder" + DBLQT + " is not a valid folder:" + Hb_OsNewLine() + PUB_cProjectFolder + Hb_OsNewLine() + 'Look at tab ' + DBLQT + PagePRG + DBLQT )
      Return ( {} )
   endif
   if GetProperty( 'VentanaMain', 'GPanFiles', 'Value' ) = 0
      BaseFolder := PUB_cProjectFolder
   else
      BaseFolder := US_FileNameOnlyPath( ChgPathToReal( GetProperty( 'VentanaMain', 'GPanFiles', 'Cell', GetProperty( 'VentanaMain', 'GPanFiles', 'Value' ), NCOLPANFULLNAME ) ) )
   endif
   If Right( Basefolder, 1 ) != DEF_SLASH
      BaseFolder := BaseFolder + DEF_SLASH
   EndIf
Return US_GetFile( { {'Forms files (*.FMG)','*.fmg'} }, 'Select Forms Files', BaseFolder, .T., .T. )

Function QPM_GetFilesDBF()
   Local BaseFolder
   if Empty( PUB_cProjectFolder ) .or. ! US_IsDirectory( PUB_cProjectFolder )
      MsgStop( DBLQT + "Project Folder" + DBLQT + " is not a valid folder:" + Hb_OsNewLine() + PUB_cProjectFolder + Hb_OsNewLine() + 'Look at tab ' + DBLQT + PagePRG + DBLQT )
      Return ( {} )
   endif
   if GetProperty( 'VentanaMain', 'GDbfFiles', 'Value' ) = 0
      BaseFolder := PUB_cProjectFolder
   else
      BaseFolder := US_FileNameOnlyPath( ChgPathToReal( GetProperty( 'VentanaMain', 'GDbfFiles', 'Cell', GetProperty( 'VentanaMain', 'GDbfFiles', 'Value' ), NCOLDBFFULLNAME ) ) )
   endif
   If Right( Basefolder, 1 ) != DEF_SLASH
      BaseFolder := BaseFolder + DEF_SLASH
   EndIf
Return US_GetFile( { {'DBF files (*.DBF)', '*.dbf'} }, 'Select DBF files', BaseFolder, .T., .T. )

Function QPM_GetExcludeFilesLIB()
   local RetVal := {}
   local vAux
   QPM_CargoLibraries()
   vAux := array( len( &( 'vLibDefault'+GetSuffix() ) ) )
   if Empty( PUB_cProjectFolder ) .or. ! US_IsDirectory( PUB_cProjectFolder )
      MsgStop( DBLQT + "Project Folder" + DBLQT + " is not a valid folder:" + Hb_OsNewLine() + PUB_cProjectFolder + Hb_OsNewLine() + 'Look at tab ' + DBLQT + PagePRG + DBLQT )
      Return ( {} )
   endif
   aCopy( &( 'vLibDefault'+GetSuffix() ), vAux )
   if Prj_Check_Console
      aadd( vAux, GetMiniGuiName() )
   endif
   aSort( vAux, NIL, NIL, { |x, y| US_Upper(x) < US_Upper( y ) } )
   DEFINE WINDOW GetExcludeLibFiles ;
           AT 0,0 ;
           WIDTH 310 HEIGHT 390 ;
           TITLE 'Select library for exclude' ;
           MODAL FONT 'Arial' SIZE 9

           DEFINE LISTBOX List_1
                   ITEMS           vAux
                   ROW             10
                   COL             10
                   WIDTH           280
                   HEIGHT          300
                   MULTISELECT     .T.
           END LISTBOX
           DEFINE BUTTONEX OK
                   ROW             320
                   COL             45
                   CAPTION         'Ok'
                   ONCLICK         ( RetVal := QPM_GetExcludeFilesOkLIB( vAux, GetExcludeLibFiles.List_1.Value ), DoMethod( 'GetExcludeLibFiles', 'Release' ) )
           END BUTTONEX
           DEFINE BUTTONEX CANCEL
                   ROW             320
                   COL             160
                   CAPTION         'Cancel'
                   ONCLICK         ( RetVal := {}, DoMethod( 'GetExcludeLibFiles', 'Release' ) )
           END BUTTONEX
   END WINDOW
   CENTER WINDOW GetExcludeLibFiles
   ACTIVATE WINDOW GetExcludeLibFiles
Return ( RetVal )

Function QPM_GetExcludeFilesOkLIB( aFiles, aSelected )
   Local aNew := {}, i
   For i := 1 To Len( aSelected )
      aadd( aNew, aFiles[ aSelected[ i ] ] )
   Next i
Return aNew

Function QPM_GetFilesLIB()
   Local RetVal := {}, cFolderAux
   if ! Empty( &( 'cLastLibFolder'+GetSuffix() ) ) .and. US_IsDirectory( &( 'cLastLibFolder'+GetSuffix() ) )
      cFolderAux := &( 'cLastLibFolder'+GetSuffix() )
   elseif Empty( PUB_cProjectFolder ) .or. ! US_IsDirectory( PUB_cProjectFolder )
      MsgStop( DBLQT + "Project Folder" + DBLQT + " is not a valid folder:" + Hb_OsNewLine() + PUB_cProjectFolder + Hb_OsNewLine() + 'Look at tab ' + DBLQT + PagePRG + DBLQT )
      Return ""
   else
      cFolderAux := PUB_cProjectFolder
   endif
   if Prj_Radio_Cpp == DEF_RG_BORLAND .or. Prj_Radio_Cpp == DEF_RG_PELLES
      RetVal := BugGetFile( { {'Libs and objects for include on concatenation (*.lib,*.obj)','*.lib;*obj'}, {'Libs for include on concatenation (*.lib)','*.lib'}, {'Objects for include on concatenation (*.obj)','*.obj'} }, 'Libs and objects for include on concatenation', cFolderAux, .T., .T. )
      if len( RetVal ) > 0
         &( 'cLastLibFolder'+GetSuffix() ) := US_FileNameOnlyPath( RetVal[ len( RetVal ) ] )
      endif
   elseif Prj_Radio_Cpp == DEF_RG_MINGW
      RetVal := BugGetFile( { {'Libs and objects for include on concatenation (lib*.a,*.o)','lib*.a;*.o'}, {'Libs for include on concatenation (lib*.a)','lib*.a'}, {'Objects for include on concatenation (*.o)','*.o'} }, 'Libs and objects for include on concatenation', cFolderAux, .T., .T. )
      if len( RetVal ) > 0
         &( 'cLastLibFolder'+GetSuffix() ) := US_FileNameOnlyPath( RetVal[ len( RetVal ) ] )
      endif
   endif
Return ( RetVal )

Function QPM_OpenProject( cParmProjectFileName )
   Local Temp_SHG_Database
   Local Open_TmpCreateFile
   Local vProjectFileNameAux
   Local Open_FromFileType
   Local cFile
   Local Open_ProjectExt := '*.qac;*.qpm'
   Local Open_FilesExt   := '*.prg;*.c;*.cpp;*.dll'

   Prj_IsNew := .F.

   // Save previous project
#ifdef QPM_SHG
   if ! QPM_WAIT( 'SHG_CheckSave()', 'Checking for save ...' )
      Return .F.
   endif
   if SHG_BaseOk
      if US_FileSize( US_FileNameOnlyPathAndName( SHG_Database ) + '.dbt' ) > SHG_DbSize
         QPM_Wait( 'SHG_PackDatabase()' )
      endif
   endif
#endif
   QPM_Wait( 'QPM_SaveProject( .T. )', 'Checking for save ...' )

   // Open or create
   If empty( cParmProjectFileName )
      CloseDbfAutoView()
      // MultiSelect parameter is set to .T. because, sometimes, the function returned the filename even when the file didn't exists
      vProjectFileNameAux := US_GetFile( { { 'Open/Create Project (' + Open_ProjectExt + ';' + Open_FilesExt + ')', Open_ProjectExt + ';' + Open_FilesExt }, { 'Open/Create Project Files (' + Open_ProjectExt + ')', Open_ProjectExt }, { 'Create Project for file (' + Open_FilesExt + ')', Open_FilesExt } }, 'Open or Create Project', cLastProjectFolder, .T., .T. )
      cProjectFileName := if( len( vProjectFileNameAux ) == 0, '', vProjectFileNameAux[1] )
      if empty( cProjectFileName )
         QPM_Wait( "RichEditDisplay( 'DBF', .T., NIL, .F. )", 'DBF reloading ...' )
         Return .F.
      endif
      // Avoid projects with spaces in their names
      if " " $ ( cFile := US_FileNameOnlyNameAndExt( cProjectFileName ) )
         MsgStop( "QPM can't handle filenames with spaces." + Hb_OsNewLine() + DBLQT + cFile + DBLQT + ' will be renamed as: ' + DBLQT + ( cFile := StrTran( cFile, " ", "_" ) ) + DBLQT )
         cProjectFileName := US_FileNameOnlyPath( cProjectFileName ) + DEF_SLASH + cFile
      endif
      // Rename .qac to .qpm
      if upper( US_FileNameOnlyExt( cProjectFileName ) ) == 'QAC'
         frename( cProjectFileName, US_FileNameOnlyPathAndName( cProjectFileName ) + '.qpm' )
         cProjectFileName := US_FileNameOnlyPathAndName( cProjectFileName ) + '.qpm'
      endif
      // Process non project files
      if Empty( US_FileNameOnlyExt( cProjectFileName ) )
         Open_FromFileType := 'QPM'
      else
         Open_FromFileType := US_Upper( US_FileNameOnlyExt( cProjectFileName ) )
      endif
      // Force .qpm extension
      cProjectFileName := US_FileNameOnlyPathAndName( cProjectFileName ) + '.qpm'
      // Use current folder if none is already set
      if Empty( US_FileNameOnlyPath( cProjectFileName ) )
         cProjectFileName := GetCurrentFolder() + DEF_SLASH + cProjectFileName
      endif
      // Create new project
      if ! file( cProjectFileName )
         if ! MyMsgYesNo( 'Create new project: ' + DBLQT + cProjectFileName + DBLQT + '?', 'Create Project' )
            QPM_Wait( "RichEditDisplay( 'DBF', .T., NIL, .F. )", 'DBF reloading ...' )
            Return .F.
         endif
         Prj_IsNew := .T.
#ifdef QPM_SHG
         Temp_SHG_Database := SHG_StrTran( SHG_GetDatabaseName( US_FileNameOnlyPathAndName( cProjectFileName ) ) + '_SHG.dbf' )
         if MyMsgYesNo( 'Create Simple Help Generator (SHG) database: ' + DBLQT + Temp_SHG_Database + DBLQT + "?", 'Create Project' )
            SHG_CreateDatabase( Temp_SHG_Database )
         else
            Temp_SHG_Database := '*NONE*'
         endif
#else
         Temp_SHG_Database := '*NONE*'
#endif
         Open_TmpCreateFile := 'VERSION ' + QPM_VERSION_NUMBER + ' ' + Hb_OsNewLine()
         Open_TmpCreateFile += 'SHGDATABASE ' + Temp_SHG_Database + ' ' + Hb_OsNewLine()
         if Open_FromFileType == 'DLL'
            Open_TmpCreateFile += Open_TmpCreateFile + 'OUTPUTTYPE DLLLIB ' + Hb_OsNewLine()
         endif
         if Open_FromFileType == 'PRG' .or. Open_FromFileType == 'C' .or. Open_FromFileType == 'CPP'
            Open_TmpCreateFile += Open_TmpCreateFile + 'SOURCE ' + US_FileNameOnlyPathAndName( cProjectFileName ) + '.' + lower( Open_FromFileType ) + ' ' + Hb_OsNewLine()
            if ! file( US_FileNameOnlyPathAndName( cProjectFileName ) + '.' + lower( Open_FromFileType ) )
               QPM_CreateNewFile( Open_FromFileType, US_FileNameOnlyPathAndName( cProjectFileName ) + '.' + lower( Open_FromFileType ) )
            endif
         endif
         if QPM_MemoWrit( cProjectFileName, Open_TmpCreateFile )
            MsgInfo( 'Project successfully created: ' + DBLQT + cProjectFileName + DBLQT )
         else
            MsgInfo( 'Error creating project: ' + DBLQT + cProjectFileName + DBLQT )
         endif
      endif
   else
      cProjectFileName := cParmProjectFileName
      if Empty( US_FileNameOnlyExt( cProjectFileName ) )
         cProjectFileName += ".qpm"
      endif
      if ! File( cProjectFileName )
         MsgStop( 'File not found: ' + alltrim( cProjectFileName ) )
         Return .F.
      endif
      if Empty( US_FileNameOnlyPath( cProjectFileName ) )
         cProjectFileName := GetCurrentFolder() + DEF_SLASH + cProjectFileName
      endif
   endif
Return QPM_Wait( 'QPM_OpenProject2()', 'Opening ...' )

Function QPM_OpenProject2()
   Local cForceRecomp
   Local LOC_nOpenError
   Local i
   Local cMemoProjectFile
   Local cMemoProjectFileAux := ""
   Local cCfgVrsn := '010001'
   Local cCfgVrsnEdtd := '01.00.01'
   Local ConfigVersion
   Local LOC_cLine

   DoMethod( 'VentanaMain', 'GPrgFiles', 'DisableUpdate' )
   DoMethod( 'VentanaMain', 'GPanFiles', 'DisableUpdate' )
   DoMethod( 'VentanaMain', 'GDbfFiles', 'DisableUpdate' )
   DoMethod( 'VentanaMain', 'GHeaFiles', 'DisableUpdate' )
   DoMethod( 'VentanaMain', 'GIncFiles', 'DisableUpdate' )
   DoMethod( 'VentanaMain', 'GExcFiles', 'DisableUpdate' )
#ifdef QPM_SHG
   DoMethod( 'VentanaMain', 'GHlpFiles', 'DisableUpdate' )
#endif

   If ! Empty( cProjectFileName )
      if bLogActivity
         QPM_MemoWrit( PUB_cQPM_Folder + DEF_SLASH + 'QPM.log', memoread( PUB_cQPM_Folder + DEF_SLASH + 'QPM.log' ) + Hb_OsNewLine() + 'QPM_OpenProject ' + cProjectFileName )
      endif

      cLastProjectFolder                        := US_FileNameOnlyPath( cProjectFileName )
      PUB_cThisFolder                           := cLastProjectFolder
      PUB_cProjectFile                          := US_FileNameOnlyPathAndName( cProjectFileName ) + '.qpm'
      if PUB_bLite
         VentanaLite.Title                      := 'QPM (' + QPM_VERSION_DISPLAY_LONG + ') [ ' + alltrim ( cProjectFileName ) + ' ]'
      else
         VentanaMain.Title                      := 'QPM (QAC based Project Manager) - Project Manager for MiniGui (' + QPM_VERSION_DISPLAY_LONG + ') [ ' + alltrim ( cProjectFileName ) + ' ]'
      endif
      VentanaMain.TProjectFolder.Value          := cLastProjectFolder
      VentanaMain.TRunProjectFolder.Value       := ''
      bWarningCpp                               := .T.
      Prj_Check_PlaceRCFirst                    := .F.
// Ini: Project Options default values
      Prj_Radio_Harbour                         := DEF_RG_HARBOUR
      Prj_Check_HarbourIs31                     := .T.
      Prj_Check_64bits                          := .F.
      Prj_Radio_Cpp                             := DEF_RG_MINGW
      Prj_Radio_MiniGui                         := DEF_RG_OOHG3
      Prj_Check_Console                         := .F.
      Prj_Radio_OutputType                      := DEF_RG_EXE
      Prj_Radio_OutputCopyMove                  := DEF_RG_NONE
      Prj_Text_OutputCopyMoveFolder             := ''
      Prj_Radio_OutputRename                    := DEF_RG_NONE
      Prj_Text_OutputRenameNewName              := ''
      Prj_Check_OutputSuffix                    := .F.
      Prj_Check_OutputPrefix                    := .T.
      Prj_Check_Upx                             := .F.
      Prj_Radio_FormTool                        := DEF_RG_EDITOR
      Prj_Radio_DbfTool                         := DEF_RG_DBFTOOL
// End: Project Options default values
      bGlobalSearch                             := .F.
      bLastGlobalSearchFun                      := .F.
      bLastGlobalSearchDbf                      := .F.
      bLastGlobalSearchCas                      := .F.
      VentanaMain.LGlobal.visible     :=        .F.
      bPpoDisplayado                            := .F.
      SHG_Database                              := ''
      SHG_DbSize                                := 0
      SHG_LastFolderImg                         := ''
      SHG_CheckTypeOutput                       := .F.
      SHG_HtmlFolder                            := ''
      SHG_WWW                                   := ''
      SHG_BaseOK                                := .F.
      cPrj_VersionAnt                           := '00000000'
      VentanaMain.LVerVerNum.Value              := Replicate( '0', DEF_LEN_VER_VERSION )
      VentanaMain.LVerRelNum.Value              := Replicate( '0', DEF_LEN_VER_RELEASE )
      VentanaMain.LVerBuiNum.Value              := Replicate( '0', DEF_LEN_VER_BUILD )
      VentanaMain.OverrideCompile.Enabled       := .T.
      VentanaMain.OverrideLink.Enabled          := .T.
      VentanaMain.OverrideCompile.Value         := ''
      VentanaMain.OverrideLink.Value            := ''
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
      Prj_ExtraRunQPMAutoExit                   := .T.
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
      VentanaMain.RichEditPrg.Value             := ''
      VentanaMain.RichEditHea.Value             := ''
      VentanaMain.RichEditPan.Value             := ''
      VentanaMain.RichEditDbf.Value             := ''
      VentanaMain.RichEditLib.Value             := ''
#ifdef QPM_SHG
      VentanaMain.RichEditHlp.Value             := ''
      oHlpRichEdit:lChanged                     := .F.
#endif
      VentanaMain.RichEditSysout.Value          := ''
      VentanaMain.RichEditOut.Value             := ''
      VentanaMain.Check_Reimp.Value             := .F.
      VentanaMain.TReimportLib.Value            := ''
      VentanaMain.Check_NumberOnPrg.Enabled     := .T.
      VentanaMain.Check_GuionA.Value            := .F.
      VentanaMain.bReLoadPpo.Enabled            := .T.
      VentanaMain.bReLoadPrg.Enabled            := .T.
      bDbfAutoView                              := .T.
      For i     := 1 to len( vSuffix )
      &( 'IncludeLibs'+vSuffix[i][1] )          := {}
      &( 'ExcludeLibs'+vSuffix[i][1] )          := {}
      &( 'vExtraFoldersForLibs'+vSuffix[i][1] ) := {}
      Next
      vExtraFoldersForSearch                    := {}
      vSinLoadWindow                            := {}
      vSinInclude                               := {}
      vXRefPrgHea                               := {}
      vXRefPrgFmg                               := {}
      PUB_bDebugActive                          := .F.
      PUB_bDebugActiveAnt                       := .F.
      VentanaMain.Debug.Checked                 := .T.
      PUB_cConvert                              := ''
      bRunParm                                  := .F.
      GBL_cRunParm                              := ''
      bBuildRun                                 := .F.
      bBuildRunBack                             := .F.
      GBL_HR_cLastExternalFileName              := ''

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
      PUB_MI_vFiles                             := {}
      PUB_MI_bSelectAllPRG                      := .F.
      PUB_MI_bSelectAllHEA                      := .F.
      PUB_MI_bSelectAllPAN                      := .F.
      PUB_MI_bSelectAllDBF                      := .F.
      PUB_MI_bSelectAllLIB                      := .F.

      PUB_bAutoInc                              := .T.
      VentanaMain.AutoInc.Checked               := .T.
      QPM_SetResumen()

      // Lock project's file
      QPM_ProjectFileUnLock()
      if ! ( ( LOC_nOpenError := QPM_ProjectFileLock( cProjectFileName ) ) == 0 )
         if LOC_nOpenError == 5
            MsgInfo( "Project already in use: " + DBLQT + cProjectFileName + DBLQT )
         else
            MsgInfo( "Error #" + US_VarToStr( LOC_nOpenError ) + " opening project: " + DBLQT + cProjectFileName + DBLQT )
         endif
         PUB_cProjectFile := ''
         PUB_cProjectFolder := ''
         Return .F.
      endif

      // Get project's version
      cMemoProjectFile := MemoRead( cProjectFileName )
      if MLCount ( cMemoProjectFile, 254 ) > 0
         LOC_cLine := alltrim ( MEMOLINE( cMemoProjectFile, 254, 1 ) )
         if us_word( LOC_cLine, 1 ) == 'VERSION'
            cCfgVrsn := us_word( LOC_cLine, 2 ) + us_word( LOC_cLine, 3 ) + us_word( LOC_cLine, 4 )
         endif
      else
         Prj_IsNew := .T.
      endif
      configversion := val( cCfgVrsn )
      if configVersion > val( QPM_VERSION_NUMBER_SHORT ) .and. ! PUB_bIgnoreVersionProject
         if ! MyMsgYesNo( "The project's version (" + cCfgVrsnEdtd + ") is newer than QPM's version (" + QPM_VERSION_DISPLAY_SHORT + ').' + Hb_OsNewLine() + 'If you go on some information might be discarded.' + Hb_OsNewLine() + 'Continue ?' )
            PUB_cProjectFile := ''
            PUB_cProjectFolder := ''
            Return .f.
         endif
      endif

      // Update older versions
      PRIVATE PRI_COMPATIBILITY_THISFOLDER         := PUB_cThisFolder
      PRIVATE PRI_COMPATIBILITY_CONFIGVERSION      := ConfigVersion
      PRIVATE PRI_COMPATIBILITY_MEMOPROJECTFILE    := cMemoProjectFile
      PRIVATE PRI_COMPATIBILITY_MEMOPROJECTFILEAUX := cMemoProjectFileAux
      PRIVATE PRI_COMPATIBILITY_PROJECTFOLDER      := PUB_cProjectFolder
      PRIVATE PRI_COMPATIBILITY_PROJECTFOLDERIDENT := cProjectFolderIdent
      #include "QPM_CompatibilityOpenProject.CH"
      PUB_cThisFolder    := PRI_COMPATIBILITY_THISFOLDER
//    ConfigVersion      := PRI_COMPATIBILITY_CONFIGVERSION
      cMemoProjectFile   := PRI_COMPATIBILITY_MEMOPROJECTFILE
//    cMemoProjectFileAux:= PRI_COMPATIBILITY_MEMOPROJECTFILEAUX
      PUB_cProjectFolder := PRI_COMPATIBILITY_PROJECTFOLDER
      cProjectFolderIdent:= PRI_COMPATIBILITY_PROJECTFOLDERIDENT
      RELEASE PRI_COMPATIBILITY_THISFOLDER
      RELEASE PRI_COMPATIBILITY_CONFIGVERSION
      RELEASE PRI_COMPATIBILITY_MEMOPROJECTFILE
      RELEASE PRI_COMPATIBILITY_MEMOPROJECTFILEAUX
      RELEASE PRI_COMPATIBILITY_PROJECTFOLDER
      RELEASE PRI_COMPATIBILITY_PROJECTFOLDERIDENT

      // Process project's file
      For i := 1 To MLCount ( cMemoProjectFile, 254 )
         LOC_cLine := alltrim ( MEMOLINE( cMemoProjectFile, 254, i ) )
         If      US_Upper( US_Word( LOC_cLine, 1 ) ) == 'PROJECTFOLDER'
                 VentanaMain.TProjectFolder.Value := US_StrTran( US_WordSubStr( LOC_cLine, 2 ), '<ThisFolder>', PUB_cThisFolder )
         ElseIf  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'PRJ_VERSION'
                 SetProperty( 'VentanaMain', 'LVerVerNum', 'value', PadL( US_Word( LOC_cLine, 2 ), DEF_LEN_VER_VERSION, '0' ) )
                 SetProperty( 'VentanaMain', 'LVerRelNum', 'value', PadL( US_Word( LOC_cLine, 3 ), DEF_LEN_VER_RELEASE, '0' ) )
                 SetProperty( 'VentanaMain', 'LVerBuiNum', 'value', PadL( US_Word( LOC_cLine, 4 ), DEF_LEN_VER_BUILD, '0' ) )
                 cPrj_VersionAnt := GetPrj_Version()
         ElseIf  at( 'LASTLIBFOLDER', US_Upper( LOC_cLine ) ) = 1
                 if US_IsVar( 'cLastLibFolder'+substr( US_Upper( us_Word( LOC_cLine, 1 ) ), 14 ) )
                    &( 'cLastLibFolder'+substr( US_Upper( us_Word( LOC_cLine, 1 ) ), 14 ) ) := us_wordSubStr( LOC_cLine, 2 )
                 elseif US_IsVar( 'cLastLibFolder'+substr( US_Upper( us_Word( LOC_cLine, 1 ) ), 14 )+Define32bits )
                    &( 'cLastLibFolder'+substr( US_Upper( us_Word( LOC_cLine, 1 ) ), 14 )+Define32bits ) := us_wordSubStr( LOC_cLine, 2 )
                 endif
         ElseIf  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'RUNFOLDER'
                 VentanaMain.TRunProjectFolder.Value := ChgPathToReal( US_WordSubStr( LOC_cLine, 2 ) )
         ElseIf  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'RUNPARAM'
                 GBL_cRunParm := US_WordSubStr( LOC_cLine, 2 )
         ElseIf  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'OVERRIDECOMPILEPARM'
                 SetProperty( 'VentanaMain', 'OverrideCompile', 'Value', US_WordSubStr( LOC_cLine, 2 ) )
         ElseIf  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'OVERRIDELINKPARM'
                 SetProperty( 'VentanaMain', 'OverrideLink', 'Value', US_WordSubStr( LOC_cLine, 2 ) )
         ElseIf  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'CHECKHARBOUR'
                 Prj_Radio_Harbour := if( US_Word( LOC_cLine, 2 ) == DefineXHarbour, DEF_RG_XHARBOUR, DEF_RG_HARBOUR )
         ElseIf  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'CHECKHARBOURIS31'
                 Prj_Check_HarbourIs31 := if( US_Word( LOC_cLine, 2 ) == 'YES', .T., .F. )
         ElseIf  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'CHECKPLACERCFIRST'
                 Prj_Check_PlaceRCFirst := if( US_Word( LOC_cLine, 2 ) == 'YES', .T., .F. )
         ElseIf  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'CHECK64BITS'
                 Prj_Check_64bits := if( US_Word( LOC_cLine, 2 ) == 'YES', .T., .F. )
         ElseIf  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'AUTOINC'
                 PUB_bAutoInc := if( US_Word( LOC_cLine, 2 ) == 'NO', .F., .T. )
         ElseIf  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'CHECKCPP'
                 do case
                 case US_Word( LOC_cLine, 2 ) == DefineBorland
                    Prj_Radio_Cpp := DEF_RG_BORLAND
                 case US_Word( LOC_cLine, 2 ) == DefineMinGW
                    Prj_Radio_Cpp := DEF_RG_MINGW
                 case US_Word( LOC_cLine, 2 ) == DefinePelles
                    Prj_Radio_Cpp := DEF_RG_PELLES
                 endcase
         ElseIf  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'CHECKMINIGUI'
                 do case
                 case US_Word( LOC_cLine, 2 ) == DefineMiniGui1
                    Prj_Radio_MiniGui := DEF_RG_MINIGUI1
                 case US_Word( LOC_cLine, 2 ) == DefineMiniGui3
                    Prj_Radio_MiniGui := DEF_RG_MINIGUI3
                 case US_Word( LOC_cLine, 2 ) == DefineExtended1
                    Prj_Radio_MiniGui := DEF_RG_EXTENDED1
                 case US_Word( LOC_cLine, 2 ) == DefineOohg3
                    Prj_Radio_MiniGui := DEF_RG_OOHG3
                 endcase
         ElseIf  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'DEBUGACTIVE'
                 PUB_bDebugActive := if( US_Word( LOC_cLine, 2 ) == 'YES', .T., .F. )
                 PUB_bDebugActiveAnt := PUB_bDebugActive
         ElseIf  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'CHECKCONSOLE'
                 Prj_Check_Console := if( US_Word( LOC_cLine, 2 ) == 'YES', .T., .F. )
         ElseIf  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'OUTPUTTYPE'
                 do case
                 case US_Word( LOC_cLine, 2 ) == 'SRCEXE'
                    Prj_Radio_OutputType := DEF_RG_EXE
                 case US_Word( LOC_cLine, 2 ) == 'SRCLIB'
                    Prj_Radio_OutputType := DEF_RG_LIB
                 case US_Word( LOC_cLine, 2 ) == 'DLLLIB'
                    Prj_Radio_OutputType := DEF_RG_IMPORT
                    VentanaMain.Check_NumberOnPrg.enabled := .F.
                    VentanaMain.bReLoadPpo.enabled := .F.
                 endcase
                 ActOutputTypeSet()
         ElseIf  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'CHECKREIMPORT'
                 SetProperty( 'VentanaMain', 'Check_Reimp', 'Value', if( US_Word( LOC_cLine, 2 ) == 'YES', .T., .F. ) )
         ElseIf  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'LIBREIMPORT'
                 SetProperty( 'VentanaMain', 'TReimportLib', 'Value', US_WordSubStr( LOC_cLine, 2 ) )
         ElseIf  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'IMPORTGUIONA'
                 SetProperty( 'VentanaMain', 'Check_GuionA', 'Value', if( US_Word( LOC_cLine, 2 ) == 'YES', .T., .F. ) )
         ElseIf  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'OUTPUTCOPYMOVE'
                 do case
                 case US_Word( LOC_cLine, 2 ) == 'NONE'
                    Prj_Radio_OutputCopyMove := DEF_RG_NONE
                 case US_Word( LOC_cLine, 2 ) == 'COPY'
                    Prj_Radio_OutputCopyMove := DEF_RG_COPY
                 case US_Word( LOC_cLine, 2 ) == 'MOVE'
                    Prj_Radio_OutputCopyMove := DEF_RG_MOVE
                 endcase
         ElseIf  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'OUTPUTCOPYMOVEFOLDER'
                 Prj_Text_OutputCopyMoveFolder := ChgPathToReal( US_WordSubStr( LOC_cLine, 2 ) )
         ElseIf  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'DBFAUTOVIEW'
                 bDbfAutoView := if( US_Word( LOC_cLine, 2 ) == '.T.', .T., .F. )
         ElseIf  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'EXTRARUNCMDFINAL'
                 Prj_ExtraRunCmdFINAL := US_WordSubStr( LOC_cLine, 2 )
         ElseIf  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'EXTRARUNPROJQPM'
                 Prj_ExtraRunProjQPM := US_WordSubStr( LOC_cLine, 2 )
         ElseIf  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'EXTRARUNCMDEXE'
                 Prj_ExtraRunCmdEXE := US_WordSubStr( LOC_cLine, 2 )
         ElseIf  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'EXTRARUNCMDFREE'
                 Prj_ExtraRunCmdFREE := US_WordSubStr( LOC_cLine, 2 )
         ElseIf  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'EXTRARUNQPMPARM'
                 Prj_ExtraRunCmdQPMParm := US_WordSubStr( LOC_cLine, 2 )
         ElseIf  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'EXTRARUNEXEPARM'
                 Prj_ExtraRunCmdEXEParm := US_WordSubStr( LOC_cLine, 2 )
         ElseIf  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'EXTRARUNFREEPARM'
                 Prj_ExtraRunCmdFREEParm := US_WordSubStr( LOC_cLine, 2 )
         ElseIf  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'EXTRARUNTYPE'
                 Prj_ExtraRunType := US_WordSubStr( LOC_cLine, 2 )
                 if Empty( Prj_ExtraRunType )
                    Prj_ExtraRunType := 'NONE'
                 endif
         ElseIf  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'EXTRARUNQPMRADIO'
                 Prj_ExtraRunQPMRadio := US_WordSubStr( LOC_cLine, 2 )
         ElseIf  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'EXTRARUNQPMLITE'
                 Prj_ExtraRunQPMLite := if( US_WordSubStr( LOC_cLine, 2 ) == '.T.', .T., .F. )
         ElseIf  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'EXTRARUNQPMFORCEFULL'
                 Prj_ExtraRunQPMForceFull := if( US_WordSubStr( LOC_cLine, 2 ) == '.T.', .T., .F. )
         ElseIf  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'EXTRARUNQPMRUN'
                 Prj_ExtraRunQPMRun := if( US_WordSubStr( LOC_cLine, 2 ) == '.T.', .T., .F. )
         ElseIf  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'EXTRARUNQPMBUTTONRUN'
                 Prj_ExtraRunQPMButtonRun := if( US_WordSubStr( LOC_cLine, 2 ) == '.T.', .T., .F. )
         ElseIf  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'EXTRARUNQPMCLEAR'
                 Prj_ExtraRunQPMClear := if( US_WordSubStr( LOC_cLine, 2 ) == '.T.', .T., .F. )
         ElseIf  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'EXTRARUNQPMLOG'
                 Prj_ExtraRunQPMLog := if( US_WordSubStr( LOC_cLine, 2 ) == '.T.', .T., .F. )
         ElseIf  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'EXTRARUNQPMLOGONLYERROR'
                 Prj_ExtraRunQPMLogOnlyError := if( US_WordSubStr( LOC_cLine, 2 ) == '.T.', .T., .F. )
         ElseIf  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'EXTRARUNQPMAUTOEXIT'
                 Prj_ExtraRunQPMAutoExit := if( US_WordSubStr( LOC_cLine, 2 ) == '.T.', .T., .F. )
         ElseIf  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'EXTRARUNEXEWAIT'
                 Prj_ExtraRunExeWait := if( US_WordSubStr( LOC_cLine, 2 ) == '.T.', .T., .F. )
         ElseIf  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'EXTRARUNEXEPAUSE'
                 Prj_ExtraRunExePause := if( US_WordSubStr( LOC_cLine, 2 ) == '.T.', .T., .F. )
         ElseIf  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'EXTRARUNFREEWAIT'
                 Prj_ExtraRunFreeWait := if( US_WordSubStr( LOC_cLine, 2 ) == '.T.', .T., .F. )
         ElseIf  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'EXTRARUNFREEPAUSE'
                 Prj_ExtraRunFreePause := if( US_WordSubStr( LOC_cLine, 2 ) == '.T.', .T., .F. )
         ElseIf  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'OUTPUTRENAME'
                 do case
                 case US_Word( LOC_cLine, 2 ) == 'NONE'
                    Prj_Radio_OutputRename := DEF_RG_NONE
                 case US_Word( LOC_cLine, 2 ) == 'NEWNAME'
                    Prj_Radio_OutputRename := DEF_RG_NEWNAME
                 endcase
         ElseIf  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'OUTPUTRENAMENEWNAME'
                 Prj_Text_OutputRenameNewName := US_WordSubStr( LOC_cLine, 2 )
         ElseIf  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'CHECKOUTPUTSUFFIX'
                 Prj_Check_OutputSuffix := if( US_Word( LOC_cLine, 2 ) == 'YES', .T., .F. )
         ElseIf  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'CHECKOUTPUTPREFIX'
                 Prj_Check_OutputPrefix := if( US_Word( LOC_cLine, 2 ) == 'YES', .T., .F. )
         ElseIf  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'CHECKUPX'
                 Prj_Check_Upx := if( US_Word( LOC_cLine, 2 ) == 'YES', .T., .F. )
         ElseIf  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'CHECKFORMTOOL'
                 do case
                 case US_Word( LOC_cLine, 2 ) == 'EDITOR'
                    Prj_Radio_FormTool := DEF_RG_EDITOR
                 case US_Word( LOC_cLine, 2 ) == 'HMI'
                    Prj_Radio_FormTool := DEF_RG_HMI
                 case US_Word( LOC_cLine, 2 ) == 'HMGSIDE'
                    Prj_Radio_FormTool := DEF_RG_HMGS
                 endcase
         ElseIf  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'CHECKDBFTOOL'
                 do case
                 case US_Word( LOC_cLine, 2 ) == 'DBFVIEW'
                    Prj_Radio_DbfTool := DEF_RG_DBFTOOL
                 case US_Word( LOC_cLine, 2 ) == 'DBU'
                    Prj_Radio_DbfTool := DEF_RG_OTHER
                 case US_Word( LOC_cLine, 2 ) == 'OTHER'
                    Prj_Radio_DbfTool := DEF_RG_OTHER
                 endcase
         ElseIf  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'MI_BEXEASSOCIATION'
                 PUB_MI_bExeAssociation := if( US_WordSubStr( LOC_cLine, 2 ) == '.T.', .T., .F. )
         ElseIf  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'MI_CEXEASSOCIATION'
                 PUB_MI_cExeAssociation := US_WordSubStr( LOC_cLine, 2 )
         ElseIf  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'MI_NEXEASSOCIATIONICON'
                 PUB_MI_nExeAssociationIcon := val( US_Word( LOC_cLine, 2 ) )
         ElseIf  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'MI_BEXEBACKUPOPTION'
                 PUB_MI_bExeBackupOption := if( US_WordSubStr( LOC_cLine, 2 ) == '.T.', .T., .F. )
         ElseIf  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'MI_BNEWFILE'
                 PUB_MI_bNewFile := if( US_WordSubStr( LOC_cLine, 2 ) == '.T.', .T., .F. )
         ElseIf  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'MI_NNEWFILESUGGESTED'
                 PUB_MI_nNewFileSuggested := val( US_WordSubStr( LOC_cLine, 2 ) )
         ElseIf  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'MI_CNEWFILELEYEND'
                 PUB_MI_cNewFileLeyend := US_WordSubStr( LOC_cLine, 2 )
         ElseIf  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'MI_NNEWFILEEMPTY'
                 PUB_MI_nNewFileEmpty := val( US_WordSubStr( LOC_cLine, 2 ) )
         ElseIf  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'MI_CNEWFILEUSERFILE'
                 PUB_MI_cNewFileUserFile := US_WordSubStr( LOC_cLine, 2 )
         ElseIf  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'MI_NDESTINATIONPATH'
                 PUB_MI_nDestinationPath := val( US_WordSubStr( LOC_cLine, 2 ) )
         ElseIf  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'MI_CDESTINATIONPATH'
                 PUB_MI_cDestinationPath := US_WordSubStr( LOC_cLine, 2 )
         ElseIf  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'MI_NLEYENDSUGGESTED'
                 PUB_MI_nLeyendSuggested := val( US_WordSubStr( LOC_cLine, 2 ) )
         ElseIf  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'MI_CLEYENDUSERTEXT'
                 PUB_MI_cLeyendUserText := US_WordSubStr( LOC_cLine, 2 )
         ElseIf  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'MI_BDESKTOPSHORTCUT'
                 PUB_MI_bDesktopShortCut := if( US_WordSubStr( LOC_cLine, 2 ) == '.T.', .T., .F. )
         ElseIf  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'MI_NDESKTOPSHORTCUT'
                 PUB_MI_nDesktopShortCut := val( US_WordSubStr( LOC_cLine, 2 ) )
         ElseIf  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'MI_BSTARTMENUSHORTCUT'
                 PUB_MI_bStartMenuShortCut := if( US_WordSubStr( LOC_cLine, 2 ) == '.T.', .T., .F. )
         ElseIf  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'MI_NSTARTMENUSHORTCUT'
                 PUB_MI_nStartMenuShortCut := val( US_WordSubStr( LOC_cLine, 2 ) )
         ElseIf  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'MI_BLAUNCHAPPLICATION'
                 PUB_MI_bLaunchApplication := if( US_WordSubStr( LOC_cLine, 2 ) == '.T.', .T., .F. )
         ElseIf  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'MI_NLAUNCHAPPLICATION'
                 PUB_MI_nLaunchApplication := val( US_WordSubStr( LOC_cLine, 2 ) )
         ElseIf  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'MI_BLAUNCHBACKUPOPTION'
                 PUB_MI_bLaunchBackupOption := if( US_WordSubStr( LOC_cLine, 2 ) == '.T.', .T., .F. )
         ElseIf  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'MI_BREBOOT'
                 PUB_MI_bReboot := if( US_WordSubStr( LOC_cLine, 2 ) == '.T.', .T., .F. )
         ElseIf  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'MI_CDEFAULTLANGUAGE'
                 PUB_MI_cDefaultLanguage := US_Word( LOC_cLine, 2 )
         ElseIf  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'MI_NINSTALLERNAME'
                 PUB_MI_nInstallerName := val( US_WordSubStr( LOC_cLine, 2 ) )
         ElseIf  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'MI_CINSTALLERNAME'
                 PUB_MI_cInstallerName := US_WordSubStr( LOC_cLine, 2 )
         ElseIf  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'MI_CIMAGE'
                 PUB_MI_cImage := US_WordSubStr( LOC_cLine, 2 )
         ElseIf  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'MI_BSELECTALLPRG'
                 PUB_MI_bSelectAllPRG := if( US_WordSubStr( LOC_cLine, 2 ) == '.T.', .T., .F. )
         ElseIf  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'MI_BSELECTALLHEA'
                 PUB_MI_bSelectAllHEA := if( US_WordSubStr( LOC_cLine, 2 ) == '.T.', .T., .F. )
         ElseIf  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'MI_BSELECTALLPAN'
                 PUB_MI_bSelectAllPAN := if( US_WordSubStr( LOC_cLine, 2 ) == '.T.', .T., .F. )
         ElseIf  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'MI_BSELECTALLDBF'
                 PUB_MI_bSelectAllDBF := if( US_WordSubStr( LOC_cLine, 2 ) == '.T.', .T., .F. )
         ElseIf  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'MI_BSELECTALLLIB'
                 PUB_MI_bSelectAllLIB := if( US_WordSubStr( LOC_cLine, 2 ) == '.T.', .T., .F. )
         ElseIf  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'MI_CFILE'
                 aadd( PUB_MI_vFiles, { val( US_Word( LOC_cLine, 2 ) ), strtran( US_Word( LOC_cLine, 3 ), '|', ' ' ), strtran( US_Word( LOC_cLine, 4 ), '|', ' ' ), strtran( US_Word( LOC_cLine, 5 ), '|', ' ' ), strtran( US_Word( LOC_cLine, 6 ), '|', ' ' ), strtran( US_Word( LOC_cLine, 7 ), '|', ' ' ) } )
         ElseIf  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'SHGDATABASE'
                 SHG_Database := ChgPathToReal( US_WordSubStr( LOC_cLine, 2 ) )
         ElseIf  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'SHGLASTFOLDERIMG'
                 SHG_LastFolderImg := US_WordSubStr( LOC_cLine, 2 )
         ElseIf  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'SHGOUTPUTTYPE'
                 SHG_CheckTypeOutput := if( US_Word( LOC_cLine, 2 ) == 'YES', .T., .F. )
#ifdef QPM_SHG
                 SetProperty( 'VentanaMain', 'CH_SHG_TypeOutput', 'value', SHG_CheckTypeOutput )
#endif
         ElseIf  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'SHGHTMLFOLDER'
                 SHG_HtmlFolder := US_WordSubStr( LOC_cLine, 2 )
         ElseIf  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'SHGWWW'
                 SHG_WWW := US_WordSubStr( LOC_cLine, 2 )
#ifdef QPM_HOTRECOVERY
         ElseIf  US_Upper( US_Word( LOC_cLine, 1 ) ) == 'HOTLASTEXTERNALFILE'
                 GBL_HR_cLastExternalFileName := US_WordSubStr( LOC_cLine, 2 )
#endif
         ElseIf  US_Upper ( US_Word( LOC_cLine, 1 ) ) == 'SOURCE'
                 cForceRecomp := ' '
                 if at( '<FR> ', LOC_cLine ) > 0
                    LOC_cLine := StrTran( LOC_cLine, '<FR> ', '' )
                    cForceRecomp := 'R'
                 endif
                 VentanaMain.GPrgFiles.AddItem( { PUB_nGridImgNone, cForceRecomp, US_FileNameOnlyNameAndExt( US_WordSubStr( LOC_cLine, 2 ) ), ChgPathToRelative( US_WordSubStr( LOC_cLine, 2 ) ), '0', '', '' } )
              // if ascan( vExtraFoldersForSearch, US_FileNameOnlyPath( ChgPathToReal( GetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', VentanaMain.GPrgFiles.ItemCount, NCOLPRGFULLNAME ) ) ) ) = 0
                 if AScan( vExtraFoldersForSearch, { |y| upper( US_VarToStr( y ) ) == upper( US_FileNameOnlyPath( ChgPathToReal( GetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', VentanaMain.GPrgFiles.ItemCount, NCOLPRGFULLNAME ) ) ) ) } ) == 0
                    aadd( vExtraFoldersForSearch, US_FileNameOnlyPath( ChgPathToReal( GetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', VentanaMain.GPrgFiles.ItemCount, NCOLPRGFULLNAME ) ) ) )
                 endif
         ElseIf  US_Upper ( US_Word( LOC_cLine, 1 ) ) == 'HEAD'
                 VentanaMain.GHeaFiles.AddItem( { PUB_nGridImgNone, US_FileNameOnlyNameAndExt( US_WordSubStr( LOC_cLine, 2 ) ), ChgPathToRelative( US_WordSubStr( LOC_cLine, 2 ) ), '0', '', '' } )
              // if ascan( vExtraFoldersForSearch, US_FileNameOnlyPath( ChgPathToReal( GetProperty( 'VentanaMain', 'GHeaFiles', 'Cell', VentanaMain.GHeaFiles.ItemCount, NCOLHEAFULLNAME ) ) ) ) = 0
                 if AScan( vExtraFoldersForSearch, { |y| upper( US_VarToStr( y ) ) == upper( US_FileNameOnlyPath( ChgPathToReal( GetProperty( 'VentanaMain', 'GHeaFiles', 'Cell', VentanaMain.GHeaFiles.ItemCount, NCOLHEAFULLNAME ) ) ) ) } ) == 0
                    aadd( vExtraFoldersForSearch, US_FileNameOnlyPath( ChgPathToReal( GetProperty( 'VentanaMain', 'GHeaFiles', 'Cell', VentanaMain.GHeaFiles.ItemCount, NCOLHEAFULLNAME ) ) ) )
                 endif
         ElseIf  US_Upper ( US_Word( LOC_cLine, 1 ) ) == 'FORM'
                 VentanaMain.GPanFiles.AddItem( { PUB_nGridImgNone, US_FileNameOnlyNameAndExt( US_WordSubStr( LOC_cLine, 2 ) ), ChgPathToRelative( US_WordSubStr( LOC_cLine, 2 ) ), '0', '', '' } )
             //  if ascan( vExtraFoldersForSearch, US_FileNameOnlyPath( ChgPathToReal( GetProperty( 'VentanaMain', 'GPanFiles', 'Cell', VentanaMain.GPanFiles.ItemCount, NCOLPANFULLNAME ) ) ) ) = 0
                 if AScan( vExtraFoldersForSearch, { |y| upper( US_VarToStr( y ) ) == upper( US_FileNameOnlyPath( ChgPathToReal( GetProperty( 'VentanaMain', 'GPanFiles', 'Cell', VentanaMain.GPanFiles.ItemCount, NCOLPANFULLNAME ) ) ) ) } ) == 0
                    aadd( vExtraFoldersForSearch, US_FileNameOnlyPath( ChgPathToReal( GetProperty( 'VentanaMain', 'GPanFiles', 'Cell', VentanaMain.GPanFiles.ItemCount, NCOLPANFULLNAME ) ) ) )
                 endif
         ElseIf  US_Upper ( US_Word( LOC_cLine, 1 ) ) == 'DBF'
                 VentanaMain.GDbfFiles.AddItem( { PUB_nGridImgNone, US_FileNameOnlyNameAndExt( US_WordSubStr( LOC_cLine, 2 ) ), ChgPathToRelative( US_WordSubStr( LOC_cLine, 2 ) ), '0 0', '', '0 ** 0' } )

         ElseIf  substr( us_word( US_Upper ( LOC_cLine ), 1 ), 1, 7 ) == 'INCLUDE'
                  if US_IsVar( 'IncludeLibs' + substr( US_Upper( US_Word( LOC_cLine, 1 ) ), 8 ) )
                     aadd( &( 'IncludeLibs' + substr( US_Upper( US_Word( LOC_cLine, 1 ) ), 8 ) ), US_Word( LOC_cLine, 2 ) + ' ' + substr( LOC_cLine, US_WordInd( LOC_cLine, 3 ) ) )
                  else
                     if US_IsVar( 'IncludeLibs' + substr( US_Upper( US_Word( LOC_cLine, 1 ) ), 8 ) + Define32bits )
                        aadd( &( 'IncludeLibs' + substr( US_Upper( US_Word( LOC_cLine, 1 ) ), 8 ) + Define32bits ), US_Word( LOC_cLine, 2 ) + ' ' + substr( LOC_cLine, US_WordInd( LOC_cLine, 3 ) ) )
                     endif
                  endif
         ElseIf  substr( us_word( US_Upper ( LOC_cLine ), 1 ), 1, 7 ) == 'EXCLUDE'
                  if US_IsVar( 'ExcludeLibs' + substr( US_Upper( US_Word( LOC_cLine, 1 ) ), 8 ) )
                     aadd( &( 'ExcludeLibs' + substr( US_Upper( US_Word( LOC_cLine, 1 ) ), 8 ) ), US_Word( LOC_cLine, 2 ) + ' ' + substr( LOC_cLine, US_WordInd( LOC_cLine, 3 ) ) )
                  else
                     if US_IsVar( 'ExcludeLibs' + substr( US_Upper( US_Word( LOC_cLine, 1 ) ), 8 ) + Define32bits )
                        aadd( &( 'ExcludeLibs' + substr( US_Upper( US_Word( LOC_cLine, 1 ) ), 8 ) + Define32bits ), US_Word( LOC_cLine, 2 ) + ' ' + substr( LOC_cLine, US_WordInd( LOC_cLine, 3 ) ) )
                     endif
                  endif
         EndIf
      Next i
   EndIf
   if ! PUB_bLite
#ifdef QPM_SHG
      if SHG_Database == '*NONE*'
         SHG_Database := ''
      else
         if empty( SHG_Database )
            SHG_Database := SHG_StrTran( SHG_GetDatabaseName( US_FileNameOnlyPathAndName(cProjectFileName) ) + '_SHG.dbf' )
            if MyMsgYesNo( 'Create Simple Help Generator (SHG) database ' + DBLQT + SHG_Database + DBLQT + "?")
               SHG_CreateDatabase( SHG_Database )
            else
               SHG_Database := ''
            endif
         endif
      endif
      VentanaMain.TWWWHlp.Value      := SHG_WWW
      VentanaMain.THlpDataBase.Value := SHG_Database
      SetProperty( 'VentanaMain', 'RichEditHlp', 'readonly', .T. )
      if !empty( SHG_Database )
         if file( SHG_Database )
            SHG_LoadDatabase( SHG_Database )
            SetProperty( 'VentanaMain', 'RichEditHlp', 'readonly', .F. )
         else
            MsgInfo( 'Simple Help Generator (SHG) database not found: ' + SHG_Database + Hb_OsNewLine() + 'Look at tab ' + DBLQT + PageHlp + DBLQT  )
         endif
      endif
#endif
      RichEditDisplay('OUT')
      VentanaMain.LFull.FontColor := DEF_COLORGREEN
      VentanaMain.LFull.Value     := 'Incremental'
   else
      VentanaLite.LFull.FontColor := DEF_COLORGREEN
      VentanaLite.LFull.Value     := 'Incremental'
   endif
   CargoIncludeLibs( GetSuffix() )
   CargoExcludeLibs( GetSuffix() )
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
   if Prj_IsNew
      SetMGWaitHide()
      ProjectSettings()
      GlobalSettings()
      SetMGWaitShow()
   endif
   SetProperty( 'VentanaMain', 'build', 'enabled', .T. )
   ActOutputTypeSet()
   ActLibReimp()
   CambioTitulo()
   QPM_SetResumen()
Return .T.

Function QPM_ClearLastOpenList()
   vLastOpen := {}
   QPM_DefinoMainMenu()
Return .t.

Function QPM_CheckFiles()
   Local i
   SetMGWaitTxt( 'Checking files ...' )
   DoMethod( 'VentanaMain', 'GPrgFiles', 'DisableUpdate' )
   For i:=1 to VentanaMain.GPrgFiles.ItemCount
      if !file( ChgPathToReal( GetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', i, NCOLPRGFULLNAME ) ) )
       //GetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', i, NCOLPRGSTATUS ) := PUB_nGridImgEquis
         GridImage( 'VentanaMain', 'GPrgFiles', i, NCOLPRGSTATUS, '+', PUB_nGridImgEquis )
      else
       //GetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', i, NCOLPRGSTATUS ) := PUB_nGridImgNone
         GridImage( 'VentanaMain', 'GPrgFiles', i, NCOLPRGSTATUS, '-', PUB_nGridImgEquis )
      endif
   Next i
   DoMethod( 'VentanaMain', 'GPrgFiles', 'EnableUpdate' )
   DoMethod( 'VentanaMain', 'GPanFiles', 'DisableUpdate' )
   For i:=1 to VentanaMain.GPanFiles.ItemCount
      if !file( ChgPathToReal( GetProperty( 'VentanaMain', 'GPanFiles', 'Cell', i, NCOLPANFULLNAME ) ) )
       //GetProperty( 'VentanaMain', 'GPanFiles', 'Cell', i, NCOLPANSTATUS ) := PUB_nGridImgEquis
         GridImage( 'VentanaMain', 'GPanFiles', i, NCOLPANSTATUS, '+', PUB_nGridImgEquis )
      else
       //GetProperty( 'VentanaMain', 'GPanFiles', 'Cell', i, NCOLPANSTATUS ) := PUB_nGridImgNone
         GridImage( 'VentanaMain', 'GPanFiles', i, NCOLPANSTATUS, '-', PUB_nGridImgEquis )
      endif
   Next i
   DoMethod( 'VentanaMain', 'GPanFiles', 'EnableUpdate' )
   DoMethod( 'VentanaMain', 'GDbfFiles', 'DisableUpdate' )
   For i:=1 to VentanaMain.GDbfFiles.ItemCount
      if !file( ChgPathToReal( GetProperty( 'VentanaMain', 'GDbfFiles', 'Cell', i, NCOLDBFFULLNAME ) ) )
      // GetProperty( 'VentanaMain', 'GDbfFiles', 'Cell', i, NCOLDBFSTATUS ) := PUB_nGridImgEquis
         GridImage( 'VentanaMain', 'GDbfFiles', i, NCOLDBFSTATUS, '+', PUB_nGridImgEquis )
      else
      // GetProperty( 'VentanaMain', 'GDbfFiles', 'Cell', i, NCOLDBFSTATUS ) := PUB_nGridImgNone
         GridImage( 'VentanaMain', 'GDbfFiles', i, NCOLDBFSTATUS, '-', PUB_nGridImgEquis )
      endif
   Next i
   DoMethod( 'VentanaMain', 'GDbfFiles', 'EnableUpdate' )
   DoMethod( 'VentanaMain', 'GHeaFiles', 'DisableUpdate' )
   For i:=1 to VentanaMain.GHeaFiles.ItemCount
      if !file( ChgPathToReal( GetProperty( 'VentanaMain', 'GHeaFiles', 'Cell', i, NCOLHEAFULLNAME ) ) )
       //GetProperty( 'VentanaMain', 'GHeaFiles', 'Cell', i, NCOLHEASTATUS ) := PUB_nGridImgEquis
         GridImage( 'VentanaMain', 'GHeaFiles', i, NCOLHEASTATUS, '+', PUB_nGridImgEquis )
      else
      // GetProperty( 'VentanaMain', 'GHeaFiles', 'Cell', i, NCOLHEASTATUS ) := PUB_nGridImgNone
         GridImage( 'VentanaMain', 'GHeaFiles', i, NCOLHEASTATUS, '-', PUB_nGridImgEquis )
      endif
   Next i
   DoMethod( 'VentanaMain', 'GHeaFiles', 'EnableUpdate' )
   DoMethod( 'VentanaMain', 'GIncFiles', 'DisableUpdate' )
   For i:=1 to VentanaMain.GIncFiles.ItemCount
      if !file( ChgPathToReal( US_WordSubStr( GetProperty( 'VentanaMain', 'GIncFiles', 'Cell', i, NCOLINCFULLNAME ), 3 ) ) )
      // GetProperty( 'VentanaMain', 'GIncFiles', 'Cell', i, NCOLINCSTATUS ) := PUB_nGridImgEquis
         GridImage( 'VentanaMain', 'GIncFiles', i, NCOLINCSTATUS, '+', PUB_nGridImgEquis )
      else
       //GetProperty( 'VentanaMain', 'GIncFiles', 'Cell', i, NCOLINCSTATUS ) := PUB_nGridImgNone
         GridImage( 'VentanaMain', 'GIncFiles', i, NCOLINCSTATUS, '-', PUB_nGridImgEquis )
      endif
   Next i
   DoMethod( 'VentanaMain', 'GIncFiles', 'EnableUpdate' )
Return .T.

Function QPM_SetResumen()
   local Venta := if( PUB_bLite, 'VentanaLite', 'VentanaMain' ), cAux
   if Prj_Radio_OutputType == DEF_RG_IMPORT
      do case
         case GetCppSuffix() == DefineBorland
            cAux := 'BCC32'
         case GetCppSuffix() == DefineMinGW
            cAux := 'MinGW'
         case GetCppSuffix() == DefinePelles
            cAux := 'Pelles'
         otherwise
            MsgStop( 'Invalid CPP type: ' + GetCppSuffix() )
      endcase
      SetProperty( Venta, 'LResumen', 'Value', 'Build Interface Library from DLL for ' + cAux )
      SetProperty( Venta, 'LFull', 'visible', .F. )
      SetProperty( Venta, 'LExtra', 'visible', .F. )
   else
      SetProperty( Venta, 'LResumen', 'Value', vSuffix[ AScan( vSuffix, { |x| x[1] == GetSuffix() } ) ][ 2 ] )
      SetProperty( Venta, 'LExtra', 'Value', if( Prj_Check_Console, 'Console Mode', '' ) + if( PUB_bDebugActive, ' With DEBUG', '' ) + if( VentanaMain.AutoInc.Checked, '', ' AutoInc OFF' ) )
      SetProperty( Venta, 'LFull', 'visible', .T. )
      SetProperty( Venta, 'LExtra', 'visible', .T. )
   endif
Return NIL

Function QPM_About()
   MsgInfo( 'QPM (QAC based Project Manager)' + Hb_OsNewLine() + ;
            'Project Manager for MiniGui (' + QPM_VERSION_DISPLAY_LONG + ')' + Hb_OsNewLine() + ;
            Hb_OsNewLine() + ;
            'Created by CarozoDeQuilmes (Argentina)' + Hb_OsNewLine() + ;
            'Supported by ' + PUB_cQPM_Support_Admin + Hb_OsNewLine() + ;
            Hb_OsNewLine() + ;
            'Home Site: ' + PUB_cQPM_Support_Link + Hb_OsNewLine() + ;
            'Users list: ' + PUB_cQPM_Support_eMail + Hb_OsNewLine() + ;
            Hb_OsNewLine() + ;
            'Based on MPM Harbour MiniGUI Project Manager' + Hb_OsNewLine() + ;
            'Created by Roberto Lopez <roblez@ciudad.com.ar>' + Hb_OsNewLine() + ;
            '(c) 2003-2006 Roberto Lopez <roblez@ciudad.com.ar>' + Hb_OsNewLine() + ;
            Hb_OsNewLine() + ;
            'This release has been builded with previous QPM version ' + Hb_OsNewLine() + ;
            Get_QPM_Builder_VersionDisplay() + ' using: ' + Hb_OsNewLine() + ;
            '- ' + MiniGuiVersion() + '    ' + Hb_OsNewLine() + ;
            '- ' + HB_COMPILER() + Hb_OsNewLine() + ;
            '- ' + Version() + Hb_OsNewLine() + ;
            Hb_OsNewLine() + ;
            'Building date: ' + substr( GetLinkDate(), 1, 4 ) + '.' + substr( GetLinkDate(), 5, 2 ) + '.' + substr( GetLinkDate(), 7, 2 ) + Hb_OsNewLine() + ;
            'Building time: ' + GetLinkTime(), 'About QPM' ) // this is not translated
Return .T.

Function QPM_Licence()
   MsgInfo( HB_LoadString( ID_LICENSE_LINE_1 ) + Hb_OsNewLine() + ;
            Hb_OsNewLine() + ;
            HB_LoadString( ID_LICENSE_LINE_2 ) + Hb_OsNewLine() + ;
            HB_LoadString( ID_LICENSE_LINE_3 ) + Hb_OsNewLine() + ;
            Hb_OsNewLine() + ;
            HB_LoadString( ID_LICENSE_LINE_4 ) + Hb_OsNewLine() + ;
            Hb_OsNewLine() + ;
            HB_LoadString( ID_LICENSE_LINE_5 ) + ' ' + HB_LoadString( ID_LICENSE_LINE_6 ) + Hb_OsNewLine() + ;
            Hb_OsNewLine() + ;
            HB_LoadString( ID_LICENSE_LINE_7 ) + Hb_OsNewLine() + ;
            HB_LoadString( ID_LICENSE_LINE_8 ), HB_LoadString( ID_LICENSE_LINE_9 ) ) // this is not translated
Return .T.

Function QPM_SaveProject( bCheck )
   Local i, j, bDiff, MemoAux, LineasC, LineasProject
   Local cForceRecomp, bWrite := .F., MI_cFilesAux
   Local cINI := ''
   if empty( bCheck )
      bCheck := .F.
   endif
   if PUB_bOpenProjectFromParm
      PUB_bOpenProjectFromParm := .F.
      Return .F.
   endif
   if Empty( PUB_cProjectFile ) .and. empty( PUB_cProjectFolder )
      if ! bCheck
         MsgStop( DBLQT + "Project Folder" + DBLQT + " is not a valid folder:" + Hb_OsNewLine() + PUB_cProjectFolder + Hb_OsNewLine() + 'Look at tab ' + DBLQT + PagePRG + DBLQT )
         MsgStop( 'No project is open.' )
      endif
      Return .F.
   endif
   cINI := cINI + 'VERSION '                    + QPM_VERSION_NUMBER + Hb_OsNewLine()
   cINI := cINI + 'PRJ_VERSION '                + MakePrj_Version() + Hb_OsNewLine()
   cINI := cINI + 'PROJECTFOLDER '              + US_StrTran( PUB_cProjectFolder, PUB_cThisFolder, '<ThisFolder>' ) + Hb_OsNewLine()
   For i=1 to len( vSuffix )
      cINI := cINI + 'LASTLIBFOLDER'            + vSuffix[i][1]+' ' + &( 'cLastLibFolder'+vSuffix[i][1] ) + Hb_OsNewLine()
   next
   cINI := cINI + 'RUNFOLDER '                  + alltrim(ChgPathToRelative(VentanaMain.TRunProjectFolder.Value)) + Hb_OsNewLine()
   cINI := cINI + 'RUNPARAM '                   + alltrim( GBL_cRunParm ) + Hb_OsNewLine()
   cINI := cINI + 'OVERRIDECOMPILEPARM '        + GetProperty( 'VentanaMain', 'OverrideCompile', 'value' ) + Hb_OsNewLine()
   cINI := cINI + 'OVERRIDELINKPARM '           + GetProperty( 'VentanaMain', 'OverrideLink', 'value' ) + Hb_OsNewLine()
   cINI := cINI + 'CHECKHARBOUR '               + if ( Prj_Radio_Harbour == DEF_RG_XHARBOUR, DefineXHarbour, DefineHarbour ) + Hb_OsNewLine()
   cINI := cINI + 'CHECKHARBOURIS31 '           + if ( Prj_Check_HarbourIs31, 'YES', 'NO' ) + Hb_OsNewLine()
   cINI := cINI + 'CHECKPLACERCFIRST '          + if ( Prj_Check_PlaceRCFirst, 'YES', 'NO' ) + Hb_OsNewLine()
   cINI := cINI + 'CHECK64BITS '                + if ( Prj_Check_64bits, 'YES', 'NO' ) + Hb_OsNewLine()
   cINI := cINI + 'AUTOINC '                    + if ( GetProperty( 'VentanaMain', 'AutoInc', 'checked' ), 'YES', 'NO' ) + Hb_OsNewLine()
   cINI := cINI + 'CHECKCPP '                   + GetCppSuffix() + Hb_OsNewLine()
   cINI := cINI + 'CHECKMINIGUI '               + GetMiniGuiSuffix() + Hb_OsNewLine()
   cINI := cINI + 'CHECKCONSOLE '               + if( Prj_Check_Console, 'YES', 'NO' ) + Hb_OsNewLine()
   cINI := cINI + 'CHECKUPX '                   + if( Prj_Check_Upx, 'YES', 'NO' ) + Hb_OsNewLine()
   cINI := cINI + 'CHECKFORMTOOL '              + cFormTool() + Hb_OsNewLine()
   cINI := cINI + 'CHECKDBFTOOL '               + cDbfTool() + Hb_OsNewLine()
   cINI := cINI + 'OUTPUTCOPYMOVE '             + cOutputCopyMove() + Hb_OsNewLine()
   cINI := cINI + 'OUTPUTCOPYMOVEFOLDER '       + ChgPathToRelative( Prj_Text_OutputCopyMoveFolder ) + Hb_OsNewLine()
   cINI := cINI + 'OUTPUTRENAME '               + cOutputRename() + Hb_OsNewLine()
   cINI := cINI + 'OUTPUTRENAMENEWNAME '        + Prj_Text_OutputRenameNewName + Hb_OsNewLine()
   cINI := cINI + 'CHECKOUTPUTSUFFIX '          + if( Prj_Check_OutputSuffix, 'YES', 'NO' ) + Hb_OsNewLine()
   cINI := cINI + 'CHECKOUTPUTPREFIX '          + if( Prj_Check_OutputPrefix, 'YES', 'NO' ) + Hb_OsNewLine()
   cINI := cINI + 'OUTPUTTYPE '                 + cOutputType() + Hb_OsNewLine()
   cINI := cINI + 'CHECKREIMPORT '              + if( GetProperty( 'VentanaMain', 'Check_Reimp', 'Value' ), 'YES', 'NO' ) + Hb_OsNewLine()
   cINI := cINI + 'LIBREIMPORT '                + GetProperty( 'VentanaMain', 'TReimportLib', 'Value' ) + Hb_OsNewLine()
   cINI := cINI + 'IMPORTGUIONA '               + if( GetProperty( 'VentanaMain', 'Check_GuionA', 'Value' ), 'YES', 'NO' ) + Hb_OsNewLine()
   cINI := cINI + 'DBFAUTOVIEW '                + US_VarToStr( bDbfAutoView ) + Hb_OsNewLine()
   cINI := cINI + 'EXTRARUNCMDFINAL '           + Prj_ExtraRunCmdFINAL + Hb_OsNewLine()
   cINI := cINI + 'EXTRARUNPROJQPM '            + Prj_ExtraRunProjQPM + Hb_OsNewLine()
   cINI := cINI + 'EXTRARUNCMDEXE '             + Prj_ExtraRunCmdEXE + Hb_OsNewLine()
   cINI := cINI + 'EXTRARUNCMDFREE '            + Prj_ExtraRunCmdFREE + Hb_OsNewLine()
   cINI := cINI + 'EXTRARUNQPMPARM '            + Prj_ExtraRunCmdQPMParm + Hb_OsNewLine()
   cINI := cINI + 'EXTRARUNEXEPARM '            + Prj_ExtraRunCmdEXEParm + Hb_OsNewLine()
   cINI := cINI + 'EXTRARUNFREEPARM '           + Prj_ExtraRunCmdFREEParm + Hb_OsNewLine()
   cINI := cINI + 'EXTRARUNTYPE '               + Prj_ExtraRunType + Hb_OsNewLine()
   cINI := cINI + 'EXTRARUNQPMRADIO '           + US_VarToStr( Prj_ExtraRunQPMRadio ) + Hb_OsNewLine()
   cINI := cINI + 'EXTRARUNQPMLITE '            + US_VarToStr( Prj_ExtraRunQPMLite ) + Hb_OsNewLine()
   cINI := cINI + 'EXTRARUNQPMFORCEFULL '       + US_VarToStr( Prj_ExtraRunQPMForceFull ) + Hb_OsNewLine()
   cINI := cINI + 'EXTRARUNQPMRUN '             + US_VarToStr( Prj_ExtraRunQPMRun ) + Hb_OsNewLine()
   cINI := cINI + 'EXTRARUNQPMBUTTONRUN '       + US_VarToStr( Prj_ExtraRunQPMButtonRun ) + Hb_OsNewLine()
   cINI := cINI + 'EXTRARUNQPMCLEAR '           + US_VarToStr( Prj_ExtraRunQPMClear ) + Hb_OsNewLine()
   cINI := cINI + 'EXTRARUNQPMLOG '             + US_VarToStr( Prj_ExtraRunQPMLog ) + Hb_OsNewLine()
   cINI := cINI + 'EXTRARUNQPMLOGONLYERROR '    + US_VarToStr( Prj_ExtraRunQPMLogOnlyError ) + Hb_OsNewLine()
   cINI := cINI + 'EXTRARUNQPMAUTOEXIT '        + US_VarToStr( Prj_ExtraRunQPMAutoExit ) + Hb_OsNewLine()
   cINI := cINI + 'EXTRARUNEXEWAIT '            + US_VarToStr( Prj_ExtraRunExeWait ) + Hb_OsNewLine()
   cINI := cINI + 'EXTRARUNEXEPAUSE '           + US_VarToStr( Prj_ExtraRunExePause ) + Hb_OsNewLine()
   cINI := cINI + 'EXTRARUNFREEWAIT '           + US_VarToStr( Prj_ExtraRunFreeWait ) + Hb_OsNewLine()
   cINI := cINI + 'EXTRARUNFREEPAUSE '          + US_VarToStr( Prj_ExtraRunFreePause ) + Hb_OsNewLine()
   cINI := cINI + 'DEBUGACTIVE '                + if( PUB_bDebugActive, 'YES', 'NO' ) + Hb_OsNewLine()
   cINI := cINI + 'MI_BEXEASSOCIATION '         + US_VarToStr( PUB_MI_bExeAssociation ) + Hb_OsNewLine()
   cINI := cINI + 'MI_CEXEASSOCIATION '         + US_VarToStr( PUB_MI_cExeAssociation ) + Hb_OsNewLine()
   cINI := cINI + 'MI_NEXEASSOCIATIONICON '     + US_VarToStr( PUB_MI_nExeAssociationIcon ) + Hb_OsNewLine()
   cINI := cINI + 'MI_BEXEBACKUPOPTION '        + US_VarToStr( PUB_MI_bExeBackupOption ) + Hb_OsNewLine()
   cINI := cINI + 'MI_BNEWFILE '                + US_VarToStr( PUB_MI_bNewFile ) + Hb_OsNewLine()
   cINI := cINI + 'MI_NNEWFILESUGGESTED '       + US_VarToStr( PUB_MI_nNewFileSuggested ) + Hb_OsNewLine()
   cINI := cINI + 'MI_CNEWFILELEYEND '          + US_VarToStr( PUB_MI_cNewFileLeyend ) + Hb_OsNewLine()
   cINI := cINI + 'MI_NNEWFILEEMPTY '           + US_VarToStr( PUB_MI_nNewFileEmpty ) + Hb_OsNewLine()
   cINI := cINI + 'MI_CNEWFILEUSERFILE '        + US_VarToStr( PUB_MI_cNewFileUserFile ) + Hb_OsNewLine()
   cINI := cINI + 'MI_NDESTINATIONPATH '        + US_VarToStr( PUB_MI_nDestinationPath ) + Hb_OsNewLine()
   cINI := cINI + 'MI_CDESTINATIONPATH '        + US_VarToStr( PUB_MI_cDestinationPath ) + Hb_OsNewLine()
   cINI := cINI + 'MI_NLEYENDSUGGESTED '        + US_VarToStr( PUB_MI_nLeyendSuggested ) + Hb_OsNewLine()
   cINI := cINI + 'MI_CLEYENDUSERTEXT '         + US_VarToStr( PUB_MI_cLeyendUserText ) + Hb_OsNewLine()
   cINI := cINI + 'MI_BDESKTOPSHORTCUT '        + US_VarToStr( PUB_MI_bDesktopShortCut ) + Hb_OsNewLine()
   cINI := cINI + 'MI_NDESKTOPSHORTCUT '        + US_VarToStr( PUB_MI_nDesktopShortCut ) + Hb_OsNewLine()
   cINI := cINI + 'MI_BSTARTMENUSHORTCUT '      + US_VarToStr( PUB_MI_bStartMenuShortCut ) + Hb_OsNewLine()
   cINI := cINI + 'MI_NSTARTMENUSHORTCUT '      + US_VarToStr( PUB_MI_nStartMenuShortCut ) + Hb_OsNewLine()
   cINI := cINI + 'MI_BLAUNCHAPPLICATION '      + US_VarToStr( PUB_MI_bLaunchApplication ) + Hb_OsNewLine()
   cINI := cINI + 'MI_NLAUNCHAPPLICATION '      + US_VarToStr( PUB_MI_nLaunchApplication ) + Hb_OsNewLine()
   cINI := cINI + 'MI_BLAUNCHBACKUPOPTION '     + US_VarToStr( PUB_MI_bLaunchBackupOption ) + Hb_OsNewLine()
   cINI := cINI + 'MI_BREBOOT '                 + US_VarToStr( PUB_MI_bReboot ) + Hb_OsNewLine()
   cINI := cINI + 'MI_CDEFAULTLANGUAGE '        + US_VarToStr( PUB_MI_cDefaultLanguage ) + Hb_OsNewLine()
   cINI := cINI + 'MI_NINSTALLERNAME '          + US_VarToStr( PUB_MI_nInstallerName ) + Hb_OsNewLine()
   cINI := cINI + 'MI_CINSTALLERNAME '          + US_VarToStr( PUB_MI_cInstallerName ) + Hb_OsNewLine()
   cINI := cINI + 'MI_CIMAGE '                  + US_VarToStr( PUB_MI_cImage ) + Hb_OsNewLine()
   cINI := cINI + 'MI_BSELECTALLPRG '           + US_VarToStr( PUB_MI_bSelectAllPRG ) + Hb_OsNewLine()
   cINI := cINI + 'MI_BSELECTALLHEA '           + US_VarToStr( PUB_MI_bSelectAllHEA ) + Hb_OsNewLine()
   cINI := cINI + 'MI_BSELECTALLPAN '           + US_VarToStr( PUB_MI_bSelectAllPAN ) + Hb_OsNewLine()
   cINI := cINI + 'MI_BSELECTALLDBF '           + US_VarToStr( PUB_MI_bSelectAllDBF ) + Hb_OsNewLine()
   cINI := cINI + 'MI_BSELECTALLLIB '           + US_VarToStr( PUB_MI_bSelectAllLIB ) + Hb_OsNewLine()
   For i := 1 To Len( PUB_MI_vFiles )
      MI_cFilesAux := US_VarToStr( PUB_MI_vFiles[ i ][ 1 ] )
      For j := 2 To Len( PUB_MI_vFiles[ i ] )
         MI_cFilesAux := MI_cFilesAux + ' ' + strtran( PUB_MI_vFiles[ i ][ j ], ' ', '|' )
      Next
      cINI := cINI + 'MI_CFILE '                + MI_cFilesAux + Hb_OsNewLine()
   Next
   //
   cINI := cINI + 'SHGDATABASE '                + if( empty( SHG_Database ), '*NONE*', ChgPathToRelative( SHG_Database ) ) + Hb_OsNewLine()
   cINI := cINI + 'SHGLASTFOLDERIMG '           + SHG_LastFolderImg + Hb_OsNewLine()
   cINI := cINI + 'SHGOUTPUTTYPE '              + if( SHG_CheckTypeOutput, 'YES', 'NO' ) + Hb_OsNewLine()
   cINI := cINI + 'SHGHTMLFOLDER '              + SHG_HtmlFolder + Hb_OsNewLine()
#ifdef QPM_SHG
   cINI := cINI + 'SHGWWW '                     + VentanaMain.TWWWHlp.Value + Hb_OsNewLine()
#endif
#ifdef QPM_HOTRECOVERY
   cINI := cINI + 'HOTLASTEXTERNALFILE '        + GBL_HR_cLastExternalFileName + Hb_OsNewLine()
#endif
   For i := 1 To VentanaMain.GPrgFiles.ItemCount
      cForceRecomp := ''
      if GetProperty( 'VentanaMain', 'GPRGFiles', 'Cell', i, NCOLPRGRECOMP ) == 'R'
         cForceRecomp := '<FR> '
      endif
      cINI := cINI + 'SOURCE '                  + cForceRecomp + ChgPathToRelative( GetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', i, NCOLPRGFULLNAME ) ) + Hb_OsNewLine()
   Next i
   For i := 1 To VentanaMain.GHeaFiles.ItemCount
      cINI := cINI + 'HEAD '                    + ChgPathToRelative( GetProperty( 'VentanaMain', 'GHeaFiles', 'Cell', i, NCOLHEAFULLNAME ) ) + Hb_OsNewLine()
   Next i
   For i := 1 To VentanaMain.GPanFiles.ItemCount
      cINI := cINI + 'FORM '                    + ChgPathToRelative( GetProperty( 'VentanaMain', 'GPanFiles', 'Cell', i, NCOLPANFULLNAME ) ) + Hb_OsNewLine()
   Next i
   For i := 1 To VentanaMain.GDbfFiles.ItemCount
      cINI := cINI + 'DBF '                     + ChgPathToRelative( GetProperty( 'VentanaMain', 'GDbfFiles', 'Cell', i, NCOLDBFFULLNAME ) ) + Hb_OsNewLine()
   Next i
   DesCargoIncludeLibs( GetSuffix() )
   For i=1 to len( vSuffix )
      For j = 1 to len( &( 'IncludeLibs'+vSuffix[i][1] ) )
         cINI := cINI + 'INCLUDE'               + vSuffix[i][1] + ' ' + US_Word( &( 'IncludeLibs'+vSuffix[i][1]+'['+str(j)+']' ), 1 ) + ' ' + US_Word( &( 'IncludeLibs'+vSuffix[i][1]+'['+str(j)+']' ), 2 ) + ' ' + ChgPathToRelative( US_WordSubstr( &( 'IncludeLibs'+vSuffix[i][1]+'['+str(j)+']' ), 3 ) ) + Hb_OsNewLine()
      Next
   Next
   DescargoExcludeLibs( GetSuffix() )
   For i=1 to len( vSuffix )
      For j = 1 to len( &( 'ExcludeLibs'+vSuffix[i][1] ) )
         cINI := cINI + 'EXCLUDE'               + vSuffix[i][1] + ' ' + alltrim( &( 'ExcludeLibs'+vSuffix[i][1]+'['+str(j)+']' ) ) + Hb_OsNewLine()
      Next
   Next

   if bCheck
      MemoAux       := MemoRead( PUB_cProjectFile )
      LineasProject := MLCount( MemoAux, 254 )
      LineasC       := MLCount( cINI, 254 )
      if !( LineasC == LineasProject )
         bDiff := .T.
      else
         bDiff := .F.
         For i := 1 to LineasC
            if !( alltrim( memoline( cINI, 254, i ) ) == alltrim( memoline( MemoAux, 254, i ) ) ) .and. ;
               !( US_Word( memoline( MemoAux, 254, i ), 1 ) == 'PRJ_VERSION' .and. ;
                  US_Word( memoline( MemoAux, 254, i ), 1 ) == 'PRJ_VERSION' )
               bDiff := .T.
            endif
         next
      endif
      if bDiff
         if !bAutoExit
            if MyMsgYesNo( 'Save changes made to project ' + DBLQT + US_FileNameOnlyNameAndExt( PUB_cProjectFile) + DBLQT + " ?" )
               if empty( PUB_cProjectFile )
                  QPM_SaveAsProject( .T. )
               else
                  QPM_ProjectFileUnLock()
                  QPM_MemoWrit( PUB_cProjectFile, cINI )
                  bWrite := .T.
                  QPM_ProjectFileLock( PUB_cProjectFile )
               endif
               cPrj_VersionAnt := GetPrj_Version()
               PUB_bDebugActiveAnt := PUB_bDebugActive
            endif
         endif
      endif
      if !bWrite .and. ;
         !( cPrj_VersionAnt == GetPrj_Version() )
         QPM_ProjectFileUnLock()
         ReplacePrj_Version( PUB_cProjectFile, MakePrj_Version() )
         QPM_ProjectFileLock( PUB_cProjectFile )
         cPrj_VersionAnt := GetPrj_Version()
      endif
      if !bWrite .and. ;
         !( PUB_bDebugActiveAnt == PUB_bDebugActive )
         QPM_ProjectFileUnLock()
         ReplaceDebugActive( PUB_cProjectFile, PUB_bDebugActive )
         QPM_ProjectFileLock( PUB_cProjectFile )
         PUB_bDebugActiveAnt := PUB_bDebugActive
      endif
   else
      QPM_ProjectFileUnLock()
      QPM_MemoWrit( PUB_cProjectFile, cINI )
      QPM_ProjectFileLock( PUB_cProjectFile )
      cPrj_VersionAnt := GetPrj_Version()
      PUB_bDebugActiveAnt := PUB_bDebugActive
   endif
Return .T.

Function MakePrj_Version()
Return substr( GetPrj_Version(), 1, 2 ) + ' ' + substr( GetPrj_Version(), 3, 2 ) + ' ' + substr( GetPrj_Version(), 5, 4 )

Function CargoIncludeLibs( tipo )
   Local i
   VentanaMain.GIncFiles.DeleteAllItems
   For i := 1 to len( &('IncludeLibs'+tipo) )
      VentanaMain.GIncFiles.AddItem( { PUB_nGridImgNone, US_FileNameOnlyNameAndExt( &('IncludeLibs'+tipo+'['+str(i)+']') ), '* ' + &('IncludeLibs'+tipo+'['+str(i)+']') } )
      LibPos( VentanaMain.GIncFiles.itemcount )
      if ascan( &('vExtraFoldersForLibs'+GetSuffix()), upper( US_FileNameOnlyPath( ChgPathToReal( US_WordSubStr( &('IncludeLibs'+tipo+'['+str(i)+']'), 2 ) ) ) ) ) = 0
         aadd( &('vExtraFoldersForLibs'+GetSuffix()), upper( US_FileNameOnlyPath( ChgPathToReal( US_WordSubStr( &('IncludeLibs'+tipo+'['+str(i)+']'), 2 ) ) ) ) )
      endif
   Next
   LibsActiva := tipo
   if VentanaMain.GDbfFiles.Value = 0
      VentanaMain.GDbfFiles.Value := 1
   endif
Return .t.

Function LibCheck( item )
   local estado
   if file( ChgPathToReal( us_wordsubstr( GetProperty( 'VentanaMain', 'GIncFiles', 'Cell', item, NCOLINCFULLNAME ), 3 ) ) )
      estado := 'Ok'
      SetProperty( 'VentanaMain', 'GIncFiles', 'Cell', item, NCOLINCSTATUS, PUB_nGridImgNone )
   else
      estado := 'Error'
      GridImage( 'VentanaMain', 'GIncFiles', item, NCOLINCSTATUS, '+', PUB_nGridImgEquis )
   endif
   SetProperty( 'VentanaMain', 'GIncFiles', 'Cell', item, NCOLINCFULLNAME, estado + ' ' + US_WordSubStr( GetProperty( 'VentanaMain', 'GIncFiles', 'Cell', item, NCOLINCFULLNAME ), 2 ) )
Return estado

Function LibPos( item, pos )
   If item > 0
      if empty( pos )
         pos := us_word( GetProperty( 'VentanaMain', 'GIncFiles', 'Cell', item, NCOLINCFULLNAME ), 2 )
      endif
      SetProperty( 'VentanaMain', 'GIncFiles', 'Cell', item, NCOLINCFULLNAME, LibCheck( item ) + ' ' + Pos + ' ' + US_WordSubStr( GetProperty( 'VentanaMain', 'GIncFiles', 'Cell', item, NCOLINCFULLNAME ), 3 ) )
   endif
   VentanaMain.GIncFiles.setfocus
Return .t.

Function DesCargoIncludeLibs( tipo )
   Local i
   &('IncludeLibs'+tipo) := {}
   For i=1 to VentanaMain.GIncFiles.ItemCount
      AADD( &('IncludeLibs'+tipo), us_word( GetProperty( 'VentanaMain', 'GIncFiles', 'Cell', i, NCOLINCFULLNAME ), 2 ) + ' ' + US_WordSubStr( GetProperty( 'VentanaMain', 'GIncFiles', 'Cell', i, NCOLINCFULLNAME ), 3 ) )
   Next
   VentanaMain.RichEditLib.Value := ''
   VentanaMain.GDbfFiles.Value := 0
Return .t.

Function CargoExcludeLibs( tipo )
   Local i
   VentanaMain.GExcFiles.DeleteAllItems
   For i=1 to len( &('ExcludeLibs'+tipo) )
      VentanaMain.GExcFiles.AddItem( { PUB_nGridImgNone, &('ExcludeLibs'+tipo+'['+str(i)+']') } )
   Next
   LibsActiva := tipo
Return .t.

Function DescargoExcludeLibs( tipo )
   Local i
   &('ExcludeLibs'+tipo) := {}
   For i=1 to VentanaMain.GExcFiles.ItemCount
      AADD( &('ExcludeLibs'+tipo), GetProperty( 'VentanaMain', 'GExcFiles', 'Cell', i, NCOLEXCNAME ) )
   Next
Return .t.

Function QPM_SaveAsProject( isNew )
   Local TmpName
   if Empty ( PUB_cProjectFile ) .and. Empty( isNew )
      MsgStop( 'No project is open.' )
      Return ''
   endif
   TmpName := alltrim ( PutFile( { {'QPM Project Files (*.qpm)','*.qpm'} }, if( !empty( isNew ) .and. isNew, 'Create New Project', 'Save Project' ), cLastProjectFolder, .T. ) )
   If ! Empty( TmpName )
      If ! ( US_Upper( US_FileNameOnlyExt(Tmpname) ) == US_Upper( 'QPM' ) )
         TmpName := TmpName + '.qpm'
      EndIf
      PUB_cProjectFile := TmpName
      if ! empty( isNew ) .and. isNew
         VentanaMain.TProjectFolder.Value := US_FileNameOnlyPath( TmpName )
      endif
      PUB_cThisFolder := US_FileNameOnlyPath( PUB_cProjectFile )
      VentanaMain.Title := 'QPM (QAC based Project Manager) - Project Manager for MiniGui (' + QPM_VERSION_DISPLAY_LONG + ') [ ' + alltrim ( PUB_cProjectFile ) + ' ]'
      QPM_SaveProject()
      cLastProjectFolder := US_FileNameOnlyPath( TmpName )
   EndIf
Return TmpName

Function QPM_Exit( bWait )
   Local r
   if ! HB_IsLogical( bWait )
      bWait := .F.
   endif
   if bWait .and. BUILD_IN_PROGRESS
      Return .F.
   endif
   if bWaitForBuild
      do while BUILD_IN_PROGRESS
         DO EVENTS
      enddo
   endif
#ifdef QPM_SHG
   if QPM_Wait( 'SHG_CheckSave()', 'Checking changes in Hlp Topics ...' )
      if SHG_BaseOk
         if US_FileSize( US_FileNameOnlyPathAndName( SHG_Database ) + '.dbt' ) > SHG_DbSize
            QPM_Wait( 'SHG_PackDatabase()' )
         endif
      endif
      if ! PUB_bLite .and. ! bWaitForBuild .and. ( ! empty( PUB_cProjectFile ) .or. ! empty( PUB_cProjectFolder ) )
         r := MyMsgYesNo( 'Are you sure ?', 'Exit QPM' )
      else
         r := .T.
      endif
   else
      r := .F.
   endif
#else
   r := .T.
#endif
   If r == .T.
      QPM_Wait( 'QPM_SaveProject( .T. )', 'Checking for save ...' )
      CloseDbfAutoView()
      DoMethod( 'VentanaMain', 'Release' )
   EndIf
   QPM_ProjectFileUnLock()
// ferase( PUB_cQPM_Folder + DEF_SLASH + 'hha.dll' )
// ferase( PUB_cQPM_Folder + DEF_SLASH + 'dtoolbar.dbf' )
// ferase( PUB_cQPM_Folder + DEF_SLASH + 'hmi.ini' )
// ferase( PUB_cQPM_Folder + DEF_SLASH + 'dbfview.ini' )
// ferase( PUB_cQPM_Folder + DEF_SLASH + 'dbfview.lng' )
   if bAutoExit .and. ! empty( PUB_cAutoLog )
      PUB_cAutoLogTmp := MemoRead( PUB_cAutoLog )
      PUB_cAutoLogTmp += Hb_OsNewLine()
      PUB_cAutoLogTmp += Replicate( '=', 80 )
      PUB_cAutoLogTmp += Hb_OsNewLine()
      QPM_MemoWrit( PUB_cAutoLog, PUB_cAutoLogTmp )
   endif
Return .F.

Function QPM_Build()
Return QPM_Wait( 'QPM_Build2()', 'Prepare for build ...' )

Function QPM_Build2()
   Local bExtraFolderSearchRoot
   Local bIsCpp := .F.
   Local bld_cmd
   Local cAux
   Local cDebugPath         := ''
   Local cExtraFoldersC := ''
   Local cExtraFoldersHB := ''
   Local cInputName         := ''
   Local cInputNameDisplay  := ''
   Local cInputNameLong     := ''
   Local cInputReImpDef := ''
   Local cInputReImpName := ''
   Local cInputReImpNameDisplay := ''
   Local cOutputName
   Local cOutputNameDisplay
   Local cResourceFileName
   Local HeaFILES           := {}
   Local i
   Local MemoAux
   Local MemoObj
   Local nCant
   Local nLastExtraFolderSearchAdded := 0
   Local OBJFOLDER
   Local Out := ''
   Local PanFILES           := {}
   Local PRGFILES           := {}
   Local vConcatIncludeC    := {}
   Local vConcatIncludeHB   := {}
   Local vDebugPath         := {}
   Local vLibExcludeFiles   := {}
   Local vLibIncludeFiles   := {}
   Local vTemp
   Local vTemp2
   Local vTemp3
   Local w_group
   Local w_hay

   BUILD_IN_PROGRESS := .T.
   LiberoWindowsHotKeys(.F.)

   if Empty ( PUB_cProjectFile )
      MsgStop( 'You must save the project before building it.' )
      BUILD_IN_PROGRESS := .F.
      DefinoWindowsHotKeys( .F. )
      Return .T.
   EndIf

   QPM_CargoLibraries()

   PUB_cConvert := ''
   PUB_bForceRunFromMsgOk := .F.

   if bRunApp
      MsgStop( 'Program running, you need to stop or kill the process before building it.' )
      BUILD_IN_PROGRESS := .F.
      DefinoWindowsHotKeys( .F. )
      Return .F.
   endif

   VentanaMain.TabFiles.Value := nPageSysout
   TabChange( 'FILES' )

   vTemp := Array( ADIR( PUB_cProjectFolder + DEF_SLASH + '_'+replicate('?',13)+PUB_cCharFileNameTemp+'*.*' ) )
   vTemp2 := Array( ADIR( GetCppFolder() + DEF_SLASH + 'BIN' + DEF_SLASH + '_'+replicate('?',13)+PUB_cCharFileNameTemp+'*.*' ) )
   vTemp3 := Array( ADIR( substr( GetCppFolder(), 1, 2 ) + DEF_SLASH + '_'+replicate('?',13)+PUB_cCharFileNameTemp+'*.*' ) )
   ADIR( PUB_cProjectFolder + DEF_SLASH + '_'+replicate('?',13)+PUB_cCharFileNameTemp+'*.*', vTemp )
   ADIR( GetCppFolder() + DEF_SLASH + 'BIN' + DEF_SLASH + '_'+replicate('?',13)+PUB_cCharFileNameTemp+'*.*', vTemp2 )
   ADIR( substr( GetCppFolder(), 1, 2 ) + DEF_SLASH + '_'+replicate('?',13)+PUB_cCharFileNameTemp+'*.*', vTemp3 )
   For i=1 to len( vTemp )
      vTemp[i] := PUB_cProjectFolder + DEF_SLASH + vTemp[i]
   next
   For i=1 to len( vTemp2 )
      AADD( vTemp, GetCppFolder() + DEF_SLASH + 'BIN' + DEF_SLASH + vTemp2[i] )
   next
   For i=1 to len( vTemp3 )
      AADD( vTemp, substr( GetCppFolder(), 1, 2 ) + DEF_SLASH + vTemp3[i] )
   next
   For i=1 to len( vTemp )
      if val( substr( US_FileNameOnlyName( vTemp[i] ), 2, 13 ) ) < ( val( substr( PUB_cSecu, 1, 13 ) ) - 100000 )
         ferase( vTemp[i] )
      endif
   next

   if Prj_Radio_OutputType == DEF_RG_IMPORT
      PUB_cConvert := upper( US_FileNameOnlyExt( ChgPathToReal( GetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', 1, NCOLPRGFULLNAME ) ) ) ) + ' ' + OutputExt()
      cInputName := US_ShortName( ChgPathToReal( GetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', 1, NCOLPRGFULLNAME ) ) )
      cInputNameDisplay := ChgPathToReal( GetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', 1, NCOLPRGFULLNAME ) )
      cInputNameLong := US_FileNameOnlyPath( cInputName ) + DEF_SLASH + US_FileNameOnlyNameAndExt( cInputNameDisplay )
      if GetProperty( 'VentanaMain', 'Check_Reimp', 'Value' )
         if !file( ChgPathToReal( GetProperty( 'VentanaMain', 'TReimportLib', 'Value' ) ) )
            MsgStop( 'Library for ReImport not found: ' + ChgPathToReal( GetProperty( 'VentanaMain', 'TReimportLib', 'Value' ) ) )
            BUILD_IN_PROGRESS := .F.
            DefinoWindowsHotKeys( .F. )
            Return .F.
         endif
         cInputReImpNameDisplay := ChgPathToReal( GetProperty( 'VentanaMain', 'TReimportLib', 'Value' ) )
         cInputReImpName := US_ShortName( cInputReImpNameDisplay )
         cInputReImpDef := PUB_cQPM_Folder + DEF_SLASH + US_FileNameOnlyName( GetProperty( 'VentanaMain', 'TReimportLib', 'Value' ) ) + '.def'
      endif
   endif

   if OutputExt() == 'LIB' .and. at( '-', US_ShortName( PUB_cProjectFolder ) ) > 0
      MsgStop( "Utility TLIB.EXE doesn't work properly when a file's path contains slash [-] characters." + Hb_OsNewLine() + "Please, change the name of the project's folder." )
      BUILD_IN_PROGRESS := .F.
      DefinoWindowsHotKeys( .F. )
      Return .F.
   endif

   if at( '(', US_ShortName( PUB_cProjectFolder ) ) > 0 .or. at( ')', US_ShortName( PUB_cProjectFolder ) ) > 0
      MsgStop( "Utility US_MAKE.EXE doesn't work properly when a file's path contains parentheses [()] characters." + Hb_OsNewLine() + "Please, change the name of the project's folder." )
      BUILD_IN_PROGRESS := .F.
      DefinoWindowsHotKeys( .F. )
      Return .F.
   endif
   
   DO EVENTS

   For i=1 to VentanaMain.GIncFiles.itemcount
      LibCheck( i )
   next
   if bLogActivity
      QPM_MemoWrit( PUB_cQPM_Folder + DEF_SLASH + 'QPM.log', memoread( PUB_cQPM_Folder + DEF_SLASH + 'QPM.log' ) + Hb_OsNewLine() + replicate( '>',80 ) )
      QPM_MemoWrit( PUB_cQPM_Folder + DEF_SLASH + 'QPM.log', memoread( PUB_cQPM_Folder + DEF_SLASH + 'QPM.log' ) + Hb_OsNewLine() + replicate( '>',80 ) )
   endif

   PUB_xHarbourMT := ''
   do case
      case GetCppSuffix() == DefineMinGW
         IsBorland := .F.
         IsMinGW   := .T.
         IsPelles  := .F.
      case GetCppSuffix() == DefinePelles
         IsBorland := .F.
         IsMinGW   := .F.
         IsPelles  := .T.
      case GetCppSuffix() == DefineBorland
         IsBorland := .T.
         IsMinGW   := .F.
         IsPelles  := .F.
      otherwise
         US_Log( 'Error 5288' )
   endcase

   cResourceFileName := GetResourceFileName()

   do case
      case Prj_Radio_OutputRename = DEF_RG_NEWNAME .and. Empty( Prj_Text_OutputRenameNewName )
         MsgStop( 'Filename for Output Rename operation is empty.' + Hb_OsNewLine() + 'Look at ' + PUB_MenuPrjOptions + ' of Settings menu.' )
         BUILD_IN_PROGRESS := .F.
         DefinoWindowsHotKeys( .F. )
         Return .F.
      case Prj_Radio_OutputCopyMove # DEF_RG_NONE .and. Empty( Prj_Text_OutputCopyMoveFolder )
         MsgStop ( 'Folder for Output Copy/Move operation is empty.' + Hb_OsNewLine() + 'Look at ' + PUB_MenuPrjOptions + ' of Settings menu.' )
         BUILD_IN_PROGRESS := .F.
         DefinoWindowsHotKeys( .F. )
         Return .F.
      case Prj_Radio_OutputCopyMove # DEF_RG_NONE .and. ! US_IsDirectory( Prj_Text_OutputCopyMoveFolder )
         MsgStop ( 'Folder for Output Copy/Move operation is not valid.' + Hb_OsNewLine() + 'Look at ' + PUB_MenuPrjOptions + ' of Settings menu.' )
         BUILD_IN_PROGRESS := .F.
         DefinoWindowsHotKeys( .F. )
         Return .F.
      case Empty( PUB_cProjectFolder ) .or. ! US_IsDirectory( PUB_cProjectFolder )
         MsgStop( DBLQT + "Project Folder" + DBLQT + " is not a valid folder:" + Hb_OsNewLine() + PUB_cProjectFolder + Hb_OsNewLine() + 'Look at tab ' + DBLQT + PagePRG + DBLQT )
         BUILD_IN_PROGRESS := .F.
         DefinoWindowsHotKeys( .F. )
         Return .F.
      case Empty ( GetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', 1, NCOLPRGFULLNAME ) )
         MsgStop ( 'PRG list is empty.' + Hb_OsNewLine() + 'Look at tab ' + DBLQT + PagePRG + DBLQT )
         BUILD_IN_PROGRESS := .F.
         DefinoWindowsHotKeys( .F. )
         Return .F.
      case empty( GetMiniGuiFolder() )
         MsgStop ( 'Folder for Minigui in ' + vSuffix[ AScan( vSuffix, { |x| x[1] == GetSuffix() } ) ][2] + ' is empty.' + Hb_OsNewLine() + 'Look at ' + PUB_MenuGblOptions + ' of Settings menu.' )
         BUILD_IN_PROGRESS := .F.
         DefinoWindowsHotKeys( .F. )
         Return .F.
      case empty( GetCppFolder() )
         MsgStop ( 'Folder for C++ Compiler in ' + vSuffix[ AScan( vSuffix, { |x| x[1] == GetSuffix() } ) ][2] + ' is empty.' + Hb_OsNewLine() + 'Look at ' + PUB_MenuGblOptions + ' of Settings menu.' )
         BUILD_IN_PROGRESS := .F.
         DefinoWindowsHotKeys( .F. )
         Return .F.
      case !QPM_IsXHarbour() .and. empty( GetHarbourFolder() )
         MsgStop ( 'Folder for Harbour in ' + vSuffix[ AScan( vSuffix, { |x| x[1] == GetSuffix() } ) ][2] + ' is empty.' + Hb_OsNewLine() + 'Look at ' + PUB_MenuGblOptions + ' of Settings menu.' )
         BUILD_IN_PROGRESS := .F.
         DefinoWindowsHotKeys( .F. )
         Return .F.
      case QPM_IsXHarbour() .and. empty( GetHarbourFolder() )
         MsgStop ( 'Folder for xHarbour in ' + vSuffix[ AScan( vSuffix, { |x| x[1] == GetSuffix() } ) ][2] + ' is empty.' + Hb_OsNewLine() + 'Look at ' + PUB_MenuGblOptions + ' of Settings menu.' )
         BUILD_IN_PROGRESS := .F.
         DefinoWindowsHotKeys( .F. )
         Return .F.
      case !Empty(  GetMiniGuiFolder() ) .and. !QPM_DirValid( US_ShortName( GetMiniGuiFolder() ), US_ShortName( GetMiniGuiLibFolder() ), GetMiniGuiSuffix() + GetCppSuffix() )
         MsgStop ( 'Minigui folder is not valid.' + Hb_OsNewLine() + 'Look at ' + PUB_MenuGblOptions + ' of Settings menu.' )
         BUILD_IN_PROGRESS := .F.
         DefinoWindowsHotKeys( .F. )
         Return .F.
      case !Empty( GetCppFolder() ) .and. !QPM_DirValid( US_ShortName( GetCppFolder() ), US_ShortName( GetCppLibFolder() ), 'C_'+GetMiniGuiSuffix() + GetCppSuffix() )
         MsgStop ( 'C++ Compiler folder is not valid.' + Hb_OsNewLine() + 'Look at ' + PUB_MenuGblOptions + ' of Settings menu.' )
         BUILD_IN_PROGRESS := .F.
         DefinoWindowsHotKeys( .F. )
         Return .F.
      case !Empty(  GetHarbourFolder() ) .and. !QPM_IsXHarbour() .and. !QPM_DirValid( US_ShortName( GetHarbourFolder() ), US_ShortName( GetHarbourLibFolder() ), GetSuffix() )
         MsgStop ( 'Harbour folder is not valid.' + Hb_OsNewLine() + 'Look at ' + PUB_MenuGblOptions + ' of Settings menu.' )
         BUILD_IN_PROGRESS := .F.
         DefinoWindowsHotKeys( .F. )
         Return .F.
      case !Empty(  GetHarbourFolder() ) .and. QPM_IsXHarbour() .and. !QPM_DirValid( US_ShortName( GetHarbourFolder() ), US_ShortName( GetHarbourLibFolder() ), GetSuffix() )
         MsgStop ( 'xHarbour folder is not valid.' + Hb_OsNewLine() + 'Look at ' + PUB_MenuGblOptions + ' of Settings menu.' )
         BUILD_IN_PROGRESS := .F.
         DefinoWindowsHotKeys( .F. )
         Return .F.
   endcase

   DO EVENTS

   For i := 1 To VentanaMain.GPrgFiles.ItemCount
      if upper( US_FileNameOnlyExt( ChgPathToReal( GetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', i, NCOLPRGFULLNAME ) ) ) ) == 'CPP'
         bIsCpp := .T.
      endif
      if ascan( PRGFILES, { |x| US_Upper( US_FileNameOnlyName( x ) ) == US_Upper( US_FileNameOnlyName( alltrim(GetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', i, NCOLPRGFULLNAME )) ) ) } ) > 0
         MsgStop( "Duplicate file name '"+US_FileNameOnlyName( alltrim(GetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', i, NCOLPRGFULLNAME )) )+"' in diferent directories or with diferent extensions (.PRG and .C)."+Hb_OsNewLine()+'The object generated for the second file will override the object of the previous file.' )
         BUILD_IN_PROGRESS := .F.
         DefinoWindowsHotKeys( .F. )
         Return .F.
      endif
      aadd( PRGFILES, ChgPathToReal( GetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', i, NCOLPRGFULLNAME ) ) )

      if ! file( PRGFILES[ i ] )
         MsgStop( "File '" + PRGFILES[ i ] + "' not found !!!" )
         BUILD_IN_PROGRESS := .F.
         DefinoWindowsHotKeys( .F. )
         Return .F.
      endif
      
      if PUB_bDebugActive
         if ascan( vDebugPath, { |x| US_Upper( x ) == US_Upper( alltrim( US_FileNameOnlyPath( PRGFILES[ i ] ) ) ) } ) == 0
            aadd( vDebugPath, alltrim( US_FileNameOnlyPath( PRGFILES[ i ] ) ) )
         endif
      endif
   Next i

   // This handles the lack of a default GT in HMG 3.x
   if IsMinGW .and. Getminiguisuffix() == DefineMiniGui3 .and. Prj_Radio_OutputType != DEF_RG_IMPORT
      if Prj_Check_Console
         QPM_Memowrit( QPM_GET_DEF, 'ANNOUNCE GT_SYS' + HB_OsNewLine() + 'REQUEST HB_GT_WIN_DEFAULT' + HB_OsNewLine() )
         if file( QPM_GET_DEF )
            aadd( PRGFILES, QPM_GET_DEF )
         else
            MsgInfo( "Warning, QPM can't add QPM_GT.PRG auxiliary file to your project." + HB_OsNewLine() + ;
                     "In order for your app to work properly, you may need to add " + HB_OsNewLine() + ;
                     DBLQT + "REQUEST HB_GT_WIN_DEFAULT" + DBLQT + " before Main()." )
         endif
      else
         QPM_Memowrit( QPM_GET_DEF, 'ANNOUNCE GT_SYS' + HB_OsNewLine() + 'REQUEST HB_GT_GUI_DEFAULT' + HB_OsNewLine() )
         if file( QPM_GET_DEF )
            aadd( PRGFILES, QPM_GET_DEF )
         else
            MsgInfo( "Warning, QPM can't add QPM_GT.PRG auxiliary file to your project." + HB_OsNewLine() + ;
                     "In order for your app to work properly, you may need to add " + HB_OsNewLine() + ;
                     DBLQT + "REQUEST HB_GT_GUI_DEFAULT" + DBLQT + " before Main()." )
         endif
      endif
   endif

   DO EVENTS

   if PUB_bDebugActive
      aeval( vDebugPath, { |x| cDebugPath := cDebugPath + x + ';' } )
      cDebugPath := cDebugPath + DEF_SLASH
   endif
   if !bAutoExit
      if bIsCpp .and. GetCppSuffix() == DefinePelles
         MsgStop( 'Error, your project includes C++ files and Pelles C does not support them.' )
         BUILD_IN_PROGRESS := .F.
         DefinoWindowsHotKeys( .F. )
         Return .F.
      endif
      if bIsCpp .and. bWarningCpp .and. GetCppSuffix() == DefineMinGW
         MsgInfo( 'Warning, your project includes C++ files. You need to download a full version of MinGW.' )
         bWarningCpp := .F.
      endif
   endif

   DO EVENTS

   For i := 1 To VentanaMain.GPanFiles.ItemCount
      if ascan( PanFILES, { |x| US_Upper( US_FileNameOnlyNameAndExt( x ) ) == US_Upper( US_FileNameOnlyNameAndExt( alltrim(GetProperty( 'VentanaMain', 'GPanFiles', 'Cell', i, NCOLPANFULLNAME )) ) ) } ) > 0
         MsgStop( "Duplicate form name '"+US_FileNameOnlyNameAndExt( alltrim(GetProperty( 'VentanaMain', 'GPanFiles', 'Cell', i, NCOLPANFULLNAME )) )+"' in diferents directories"+Hb_OsNewLine()+'Process canceled.' )
         BUILD_IN_PROGRESS := .F.
         DefinoWindowsHotKeys( .F. )
         Return .F.
      endif
      aadd( PANFILES, ChgPathToReal( GetProperty( 'VentanaMain', 'GPanFiles', 'Cell', i, NCOLPANFULLNAME ) ) )
      if !file( PanFILES[ i ] )
         MsgStop( "Form '"+PanFILES[ i ]+"' not found" )
         BUILD_IN_PROGRESS := .F.
         DefinoWindowsHotKeys( .F. )
         Return .F.
      endif
   Next i

   DO EVENTS

   For i := 1 To VentanaMain.GHeaFiles.ItemCount
      if ascan( HeaFILES, { |x| US_Upper( US_FileNameOnlyNameAndExt( x ) ) == US_Upper( US_FileNameOnlyNameAndExt( alltrim(GetProperty( 'VentanaMain', 'GHeaFiles', 'Cell', i, NCOLHEAFULLNAME )) ) ) } ) > 0
         MsgStop( "Duplicate header name '"+US_FileNameOnlyNameAndExt( alltrim(GetProperty( 'VentanaMain', 'GHeaFiles', 'Cell', i, NCOLHEAFULLNAME )) )+"' in diferents directories"+Hb_OsNewLine()+'Process canceled.' )
         BUILD_IN_PROGRESS := .F.
         DefinoWindowsHotKeys( .F. )
         Return .F.
      endif
      aadd( HeaFILES, ChgPathToReal( GetProperty( 'VentanaMain', 'GHeaFiles', 'Cell', i, NCOLHEAFULLNAME ) ) )
      if !file( HeaFILES[ i ] )
         MsgStop( "Header (include) '"+HeaFILES[ i ]+"' not found." )
         BUILD_IN_PROGRESS := .F.
         DefinoWindowsHotKeys( .F. )
         Return .F.
      endif
   Next i

   DO EVENTS

   For i := 1 To VentanaMain.GIncFiles.ItemCount
      aadd( vLibIncludeFiles, ChgPathToReal( US_WordSubStr( GetProperty( 'VentanaMain', 'GIncFiles', 'Cell', i, NCOLINCFULLNAME ), 3 ) ) )
      if ! file( vLibIncludeFiles[ i ] )
         MsgStop( "File '" + vLibIncludeFiles[ i ] + "' not found !!!" )
         BUILD_IN_PROGRESS := .F.
         DefinoWindowsHotKeys( .F. )
         Return .F.
      endif
   Next i
   For i := 1 To VentanaMain.GExcFiles.ItemCount
      aadd( vLibExcludeFiles, US_Upper( alltrim( GetProperty( 'VentanaMain', 'GExcFiles', 'Cell', i, NCOLEXCNAME ) ) ) )
   Next i

   aadd( vConcatIncludeHB, US_ShortName( GetHarbourFolder() ) + DEF_SLASH + 'INCLUDE' )
   aadd( vConcatIncludeHB, US_ShortName( GetMiniGuiFolder() ) + DEF_SLASH + 'INCLUDE' )
   aadd( vConcatIncludeHB, US_ShortName( PUB_cProjectFolder ) )

   aadd( vConcatIncludeC, US_ShortName( GetCppFolder() ) + DEF_SLASH + 'INCLUDE' )
   if IsPelles
      aadd( vConcatIncludeC, US_ShortName( GetCppFolder() ) + DEF_SLASH + 'INCLUDE'+DEF_SLASH+'WIN' )
   endif
   aadd( vConcatIncludeC, US_ShortName( GetHarbourFolder() ) + DEF_SLASH + 'INCLUDE' )
   aadd( vConcatIncludeC, US_ShortName( GetMiniGuiFolder() ) + DEF_SLASH + 'INCLUDE' )
   aadd( vConcatIncludeC, US_ShortName( PUB_cProjectFolder ) )

   For i := 1 to len( vConcatIncludeHB )
      if ! empty( vConcatIncludeHB[ i ] )
         if US_IsRootFolder( vConcatIncludeHB[ i ] )
            bExtraFolderSearchRoot := .T.
         else
            bExtraFolderSearchRoot := .F.
         endif
         do case
         case IsMinGW
            cExtraFoldersHB := cExtraFoldersHB + ';' + vConcatIncludeHB[i] + if( bExtraFolderSearchRoot, DEF_SLASH, '' )
         case IsPelles
            cExtraFoldersHB := cExtraFoldersHB + ';' + vConcatIncludeHB[i] + if( bExtraFolderSearchRoot, DEF_SLASH, '' )
         case IsBorland
            cExtraFoldersHB := cExtraFoldersHB + ';' + vConcatIncludeHB[i] + if( bExtraFolderSearchRoot, DEF_SLASH, '' )
         otherwise
            US_Log( 'Error 5443')
         endcase
      endif
   Next i

   DO EVENTS

   For i := 1 to len( vConcatIncludeC )
      if ! empty( vConcatIncludeC[i] )
         if US_IsRootFolder( vConcatIncludeC[i] )
            bExtraFolderSearchRoot := .T.
         else
            bExtraFolderSearchRoot := .F.
         endif
         do case
         case IsMinGW
            cExtraFoldersC := cExtraFoldersC + ' -I' + vConcatIncludeC[i] + if( bExtraFolderSearchRoot, DEF_SLASH, '' )
         case IsPelles
            cExtraFoldersC := cExtraFoldersC + ' /I' + vConcatIncludeC[i] + if( bExtraFolderSearchRoot, DEF_SLASH, '' )
         case IsBorland
            cExtraFoldersC := cExtraFoldersC + ';' + vConcatIncludeC[i] + if( bExtraFolderSearchRoot, DEF_SLASH, '' )
         otherwise
            US_Log( 'Error 5444')
         endcase
      endif
   Next i

   DO EVENTS

   For i := 1 to len( vExtraFoldersForSearch )
      if ! empty( vExtraFoldersForSearch[i] )
         cAux := US_ShortName( vExtraFoldersForSearch[i] )
         if ! empty( cAux )
            nLastExtraFolderSearchAdded := i
            if US_IsRootFolder( vExtraFoldersForSearch[ i ] )
               bExtraFolderSearchRoot := .T.
            else
               bExtraFolderSearchRoot := .F.
            endif
            aadd( vConcatIncludeHB, cAux )
            aadd( vConcatIncludeC, cAux )

            if bExtraFolderSearchRoot
               cAux += DEF_SLASH
            endif

            if ! cAux $ cExtraFoldersHB
               do case
               case IsMinGW
                  cExtraFoldersHB := cExtraFoldersHB + ';' + cAux
               case IsPelles
                  cExtraFoldersHB := cExtraFoldersHB + ';' + cAux
               case IsBorland
                  cExtraFoldersHB := cExtraFoldersHB + ';' + cAux
               otherwise
                  US_Log( 'Error 5445' )
               endcase
            endif
            if ! cAux $ cExtraFoldersC
               do case
               case IsMinGW
                  cExtraFoldersC := cExtraFoldersC + ' -I' + cAux
               case IsPelles
                  cExtraFoldersC := cExtraFoldersC + ' /I' + cAux
               case IsBorland
                  cExtraFoldersC := cExtraFoldersC + ';' + cAux
               otherwise
                  US_Log( 'Error 5446' )
               endcase
            endif
         endif
      endif
   Next i

   // INI - El siguiente es un parche para cuando el ultimo folder a agregar en Search es del formato 'C:',
   //       ya que hay que agregarle algun folder del formato 'C:\xxxxx' para que no cancele
   if US_IsRootFolder( vExtraFoldersForSearch[ nLastExtraFolderSearchAdded ] )
      do case
      case IsMinGW
         cExtraFoldersHB := cExtraFoldersHB + ';' + US_ShortName( DiskName() + ':' + DEF_SLASH + '_' + PUB_cSecu + 'SearchBug' )
         cExtraFoldersC  := cExtraFoldersC  + ' -I' + US_ShortName( DiskName() + ':' + DEF_SLASH + '_' + PUB_cSecu + 'SearchBug' )
      case IsPelles
         cExtraFoldersHB := cExtraFoldersHB + ';' + US_ShortName( DiskName() + ':' + DEF_SLASH + '_' + PUB_cSecu + 'SearchBug' )
         cExtraFoldersC  := cExtraFoldersC  + ' /I' + US_ShortName( DiskName() + ':' + DEF_SLASH + '_' + PUB_cSecu + 'SearchBug' )
      case IsBorland
         cExtraFoldersHB := cExtraFoldersHB + ';' + US_ShortName( DiskName() + ':' + DEF_SLASH + '_' + PUB_cSecu + 'SearchBug' )
         cExtraFoldersC  := cExtraFoldersC  + ';' + US_ShortName( DiskName() + ':' + DEF_SLASH + '_' + PUB_cSecu + 'SearchBug' )
      otherwise
         US_Log( 'Error 5447' )
      endcase
   endif

   do case
   case IsMinGW
      cExtraFoldersHB := SubStr( cExtraFoldersHB, 2 )  // get rid of first ';'
      cExtraFoldersC  := SubStr( cExtraFoldersC, 4 )   // get rid of first ' -I'
   case IsPelles
      cExtraFoldersHB := SubStr( cExtraFoldersHB, 2 )  // get rid of first ';'
      cExtraFoldersC  := SubStr( cExtraFoldersC, 4 )   // get rid of first ' /I'
   case IsBorland
      cExtraFoldersHB := SubStr( cExtraFoldersHB, 2 )  // get rid of first ';'
      cExtraFoldersC  := SubStr( cExtraFoldersC, 2 )   // get rid of first ';'
   otherwise
      US_Log( 'Error 5445')
   endcase

   DO EVENTS

   ferase( SCRIPT_FILE )
   ferase( END_FILE )
   ferase( TEMP_LOG )
   ferase( PROGRESS_LOG )
   ProgLength := 0

   SetProperty( 'VentanaMain', 'EraseOBJ', 'enabled', .F. )
   SetProperty( 'VentanaMain', 'EraseALL', 'enabled', .F. )
   SetProperty( 'VentanaMain', 'open', 'enabled', .F. )
   SetProperty( 'VentanaMain', 'build', 'enabled', .F. )
   SetProperty( 'VentanaMain', 'BVerChange', 'enabled', .F. )
   SetProperty( 'VentanaMain', 'OverrideCompile', 'enabled', .F. )
   SetProperty( 'VentanaMain', 'OverrideLink', 'enabled', .F. )
   if Prj_Radio_OutputType == DEF_RG_EXE
      SetProperty( 'VentanaMain', 'run', 'enabled', .F. )
   endif

   PUB_bIsProcessing := .t.
   VentanaMain.RichEditSysout.Value := ''

   SetMGWaitHide()

   DO EVENTS

   ferase( PUB_cProjectFolder + DEF_SLASH + '_' + PUB_cSecu + 'MSG.SYSIN' )

   SetCurrentFolder( PUB_cProjectFolder )
   if ! US_CreateFolder( GetObjFolder() )
      US_Log( 'Unable to create OBJ folder: ' + GetObjFolder() )
      BUILD_IN_PROGRESS := .F.
      DefinoWindowsHotKeys( .F. )
      Return .F.
   endif
   SetCurrentFolder( PUB_cQPM_Folder )

   OBJFOLDER          := US_ShortName( GetObjFolder() )
   cOutputName        := GetOutputModuleName( .F. )
   cOutputNameDisplay := GetOutputModuleName( .T. )
   
/*
 * Out contiene los comandos que luego se grabarán en
 * Temp.Bc para ser ejecutados por MAKE.EXE desde Build.bat
 */
   Out := Out + 'APP_NAME = ' + cOutputName + Hb_OsNewLine()

   if Prj_Radio_OutputType == DEF_RG_EXE .or. Prj_Radio_OutputType == DEF_RG_LIB
      if VentanaMain.GHeaFiles.itemcount > 0
         xRefPrgHea( vConcatIncludeC )
      endif
      if VentanaMain.GPanFiles.itemcount > 0
         xRefPrgFmg( vConcatIncludeHB )
      endif
   endif

   MemoAux := memoread( PROGRESS_LOG )
   QPM_MemoWrit( PROGRESS_LOG, MemoAux + US_TimeDis( Time() ) + ' - Checking libraries ...' + Hb_OsNewLine() )

   DO EVENTS

/*
 * Variables y aplicaciones a utilizar en Temp.Bc
 */
   do case
      case IsMinGW
         Out := Out + 'IMPDEF_MGW_EXE = '  + US_ShortName( PUB_cQPM_Folder )    + DEF_SLASH                             + 'US_PEXPORTS.EXE'  + Hb_OsNewLine()
         Out := Out + 'IMPLIB_MGW_EXE = '  + US_ShortName( GetCppFolder() )     + DEF_SLASH + 'BIN'         + DEF_SLASH + 'DLLTOOL.EXE'      + Hb_OsNewLine()
         Out := Out + 'LSTA_EXE = '        + US_ShortName( PUB_cQPM_Folder )    + DEF_SLASH                             + 'US_OBJDUMP.EXE'   + Hb_OsNewLine()
         Out := Out + 'COMPILATOR_C = '    + US_ShortName( GetCppFolder() )     + DEF_SLASH + 'BIN'         + DEF_SLASH + 'GCC.EXE'          + Hb_OsNewLine()
         Out := Out + 'ILINK_EXE = '       + US_ShortName( GetCppFolder() )     + DEF_SLASH + 'BIN'         + DEF_SLASH + 'GCC.EXE'          + Hb_OsNewLine()
         Out := Out + 'TLIB_EXE = '        + US_ShortName( GetCppFolder() )     + DEF_SLASH + 'BIN'         + DEF_SLASH + 'AR.EXE'           + Hb_OsNewLine()
         Out := Out + 'RESOURCE_COMP = '   + US_ShortName( GetCppFolder() )     + DEF_SLASH + 'BIN'         + DEF_SLASH + 'WINDRES.EXE'      + Hb_OsNewLine()
         Out := Out + 'REIMPORT_EXE = '    + US_ShortName( PUB_cQPM_Folder )    + DEF_SLASH                             + 'US_REIMP.EXE'     + Hb_OsNewLine()
         Out := Out + 'DEF_SLASH = '       + US_ShortName( PUB_cQPM_Folder )    + DEF_SLASH                             + 'US_SLASH.EXE QPM' + Hb_OsNewLine()
         Out := Out + 'DIR_COMPC = '       + US_ShortName( GetCppFolder() )                                                                  + Hb_OsNewLine()
         Out := Out + 'DIR_HARBOUR = '     + US_ShortName( GetHarbourFolder() )                                                              + Hb_OsNewLine()
      case IsPelles
         Out := Out + 'IMPDEF_PC_EXE = '   + US_ShortName( PUB_cQPM_Folder )    + DEF_SLASH                             + 'US_IMPDEF.EXE'    + Hb_OsNewLine()
         Out := Out + 'IMPLIB_PC_EXE = '   + US_ShortName( PUB_cQPM_Folder )    + DEF_SLASH                             + 'US_POLIB.EXE'     + Hb_OsNewLine()
         Out := Out + 'LSTLIB_EXE = '      + US_ShortName( PUB_cQPM_Folder )    + DEF_SLASH                             + 'US_POLIB.EXE'     + Hb_OsNewLine()
         Out := Out + 'COMPILATOR_C = '    + US_ShortName( GetCppFolder() )     + DEF_SLASH + 'BIN'         + DEF_SLASH + 'POCC.EXE'         + Hb_OsNewLine()
         Out := Out + 'ILINK_EXE = '       + US_ShortName( GetCppFolder() )     + DEF_SLASH + 'BIN'         + DEF_SLASH + 'POLINK.EXE'       + Hb_OsNewLine()
         Out := Out + 'TLIB_EXE = '        + US_ShortName( PUB_cQPM_Folder )    + DEF_SLASH                             + 'US_POLIB.EXE'     + Hb_OsNewLine()
         Out := Out + 'RESOURCE_COMP = '   + US_ShortName( GetCppFolder() )     + DEF_SLASH + 'BIN'         + DEF_SLASH + 'PORC.EXE'         + Hb_OsNewLine()
      case IsBorland
         Out := Out + 'IMPDEF_BCC_EXE = '  + US_ShortName( PUB_cQPM_Folder )    + DEF_SLASH                             + 'US_IMPDEF.EXE'    + Hb_OsNewLine()
         Out := Out + 'IMPLIB_BCC_EXE = '  + US_ShortName( PUB_cQPM_Folder )    + DEF_SLASH                             + 'US_IMPLIB.EXE'    + Hb_OsNewLine()
         Out := Out + 'LSTLIB_EXE = '      + US_ShortName( PUB_cQPM_Folder )    + DEF_SLASH                             + 'US_TLIB.EXE'      + Hb_OsNewLine()
         Out := Out + 'COMPILATOR_C = '    + US_ShortName( GetCppFolder() )     + DEF_SLASH + 'BIN'         + DEF_SLASH + 'BCC32.EXE'        + Hb_OsNewLine()
         Out := Out + 'ILINK_EXE = '       + US_ShortName( GetCppFolder() )     + DEF_SLASH + 'BIN'         + DEF_SLASH + 'ILINK32.EXE'      + Hb_OsNewLine()
         Out := Out + 'TLIB_EXE = '        + US_ShortName( PUB_cQPM_Folder )    + DEF_SLASH                             + 'US_TLIB.EXE'      + Hb_OsNewLine()
         Out := Out + 'RESOURCE_COMP = '   + US_ShortName( GetCppFolder() )     + DEF_SLASH + 'BIN'         + DEF_SLASH + 'BRC32.EXE'        + Hb_OsNewLine()
      otherwise
         US_Log( 'Error 5549' )
   endcase
//   Out := Out + 'REDIR = ' + US_ShortName(PUB_cQPM_Folder) + DEF_SLASH + 'US_REDIR.EXE' + PUB_cUS_RedirOpt + TEMP_LOG + Hb_OsNewLine()
   Out := Out + 'HARBOUR_EXE = '        + US_ShortName( GetHarbourFolder() ) + DEF_SLASH + 'BIN' + DEF_SLASH + 'HARBOUR.EXE' + Hb_OsNewLine()
   Out := Out + 'US_MSG_EXE = '         + US_ShortName(PUB_cQPM_Folder) + DEF_SLASH + 'US_MSG.EXE'                           + Hb_OsNewLine()
   Out := Out + 'US_UPX_EXE = '         + US_ShortName(PUB_cQPM_Folder) + DEF_SLASH + 'US_UPX.EXE'                           + Hb_OsNewLine()
   Out := Out + 'US_SHELL_EXE = '       + US_ShortName(PUB_cQPM_Folder) + DEF_SLASH + 'US_SHELL.EXE QPM'                     + Hb_OsNewLine()
   Out := Out + 'DIR_HB_INCLUDE = '     + cExtraFoldersHB                                                                    + Hb_OsNewLine()
   Out := Out + 'DIR_C_INCLUDE = '      + cExtraFoldersC                                                                     + Hb_OsNewLine()
   Out := Out + 'DIR_MINIGUI = '        + US_ShortName( GetMiniGuiFolder() )                                                 + Hb_OsNewLine()
   Out := Out + 'DIR_MINIGUI_LIB = '    + GetMiniguiLibFolder()                                                              + Hb_OsNewLine()
   Out := Out + 'DIR_MINIGUI_RES = '    + US_ShortName( GetMiniGuiFolder() + DEF_SLASH + 'RESOURCES' )                       + Hb_OsNewLine()
   Out := Out + 'DIR_COMPC_LIB = '      + GetCppLibFolder()                                                                  + Hb_OsNewLine()
   Out := Out + 'DIR_HARBOUR_LIB = '    + GetHarbourLibFolder()                                                              + Hb_OsNewLine()
   if IsBorland
   Out := Out + 'DIR_COMPC_LIB2 = '     + GetCppLibFolder() + DEF_SLASH + 'PSDK'                                             + Hb_OsNewLine()
   endif
   Out := Out + 'PAUSE_EXE = '          + 'PAUSE'                                                                            + Hb_OsNewLine()
   Out := Out + 'DIR_OBJECTS = '        + OBJFOLDER                                                                          + Hb_OsNewLine()
   Out := Out + 'C_DIR = '              + OBJFOLDER                                                                          + Hb_OsNewLine()
   Out := Out + 'USER_FLAGS_HARBOUR = ' + GetProperty( 'VentanaMain', 'OverrideCompile', 'value' )                         + Hb_OsNewLine()
   Out := Out + 'USER_FLAGS_LINK = '    + GetProperty( 'VentanaMain', 'OverrideLink', 'value' )                            + Hb_OsNewLine()

   if Prj_Radio_OutputType != DEF_RG_IMPORT
      cPrj_Version := GetPrj_Version()
      if Empty( GetProperty( 'VentanaMain', 'OverrideCompile', 'value' ) )
         Out := Out + 'HARBOUR_FLAGS = /D__QPM_VERSION__="' + "'" + QPM_VERSION_NUMBER_SHORT + "'" + '" /D__PRJ_VERSION__="'+"'"+cPrj_Version+"'"+'" /D__PROJECT_FOLDER__="'+"'"+VentanaMain.TProjectFolder.Value+"'"+ '" /n' + If(PUB_bDebugActive,' /b','') + ' /i$(DIR_HB_INCLUDE) ' + Hb_OsNewLine()
      else
         Out := Out + 'HARBOUR_FLAGS = /D__QPM_VERSION__="' + "'" + QPM_VERSION_NUMBER_SHORT + "'" + '" /D__PRJ_VERSION__="'+"'"+cPrj_Version+"'"+'" /D__PROJECT_FOLDER__="'+"'"+VentanaMain.TProjectFolder.Value+"'"+ '" /n' + If(PUB_bDebugActive,' /b','') + ' $(USER_FLAGS_HARBOUR) /i$(DIR_HB_INCLUDE) ' + Hb_OsNewLine()
      endif
      if PUB_xHarbourMT = 'MT'
         if !IsMinGW
            Out := Out + 'COBJFLAGS =  -c -O2 -tWM -M -I$(DIR_C_INCLUDE) -L' + GetCppLibFolder() + Hb_OsNewLine()
         endif
      else
         do case
            case IsMinGW
               Out := Out + 'COBJFLAGS = -I$(DIR_C_INCLUDE) -Wall -c ' + Hb_OsNewLine()
            case IsPelles
               Out := Out + 'COBJFLAGS = ' + if( ! Prj_Check_Console, ' /Ze /Zx /Go /Tx86-coff /D__WIN32__ ', ' /Ze /Zx /Go /Tx86-coff /D__WIN32__ ' ) + ' /I$(DIR_C_INCLUDE)' + Hb_OsNewLine()
            case IsBorland
               // TODO: use this flags -6 -OS -Ov -Oi -Oc
               Out := Out + 'COBJFLAGS = ' + if( Prj_Check_Console, '-c -O2 -d -M', '-c -O2 -tW -M' ) + ' -I$(DIR_C_INCLUDE) -L' + GetCppLibFolder() + Hb_OsNewLine()
            otherwise
               US_Log( 'Error 5598' )
         endcase
      endif
      Out := Out + Hb_OsNewLine()

/*
 * Objetos de los que depende el ejecutable
 */
      nCant := Len( PRGFILES )
      if IsMinGW
         Out := Out + '$(APP_NAME) : $(DIR_OBJECTS)' + DEF_SLASH + US_FileNameOnlyName( PRGFILES[1] ) + '.o ' + if( nCant > 1, DEF_SLASH, '' ) + Hb_OsNewLine()
      else
         Out := Out + '$(APP_NAME) : $(DIR_OBJECTS)' + DEF_SLASH + US_FileNameOnlyName( PRGFILES[1] ) + '.obj ' + if( nCant > 1, DEF_SLASH, '' ) + Hb_OsNewLine()
      endif
      For i := 2 To nCant
         if i == nCant
            if IsMinGW
               Out := Out + '              $(DIR_OBJECTS)' + DEF_SLASH + US_FileNameOnlyName( PRGFILES[i] ) + '.o' + Hb_OsNewLine()
            else
               Out := Out + '              $(DIR_OBJECTS)' + DEF_SLASH + US_FileNameOnlyName( PRGFILES[i] ) + '.obj' + Hb_OsNewLine()
            endif
         else
            if IsMinGW
               Out := Out + '              $(DIR_OBJECTS)' + DEF_SLASH + US_FileNameOnlyName( PRGFILES[i] ) + '.o ' + DEF_SLASH + Hb_OsNewLine()
            else
               Out := Out + '              $(DIR_OBJECTS)' + DEF_SLASH + US_FileNameOnlyName( PRGFILES[i] ) + '.obj ' + DEF_SLASH + Hb_OsNewLine()
            endif
         endif
      Next i

      DO EVENTS

/*
 * Comandos para generar el ejecutable.
 * Esta lista NO debe estar separada de la anterior por renglones en blanco.
 */
 
 /*
  * Comandos para compilar el archivo de recursos
  */
      if ! Prj_Check_Console
         if IsMinGW
            if Prj_Radio_OutputType == DEF_RG_EXE .or. File( US_FileNameOnlyPathAndName( PRGFILES[1] ) + '.RC' )
               Out := Out + PUB_cCharTab + '$(US_MSG_EXE) ' + PROGRESS_LOG + ' -MSG:Compiling Resource File (.RC file has been copied to _Temp.rc file for building _Temp.o) ...' + Hb_OsNewLine()
               Out := Out + PUB_cCharTab + '$(RESOURCE_COMP) -I $(DIR_MINIGUI_RES) -i ' + Us_ShortName( US_FileNameOnlyPath( PRGFILES[1] ) ) + DEF_SLASH + '_Temp.RC -o $(DIR_OBJECTS)' + DEF_SLASH + '_Temp.o' + Hb_OsNewLine()
            endif
         else
            if File( US_FileNameOnlyPathAndName( PRGFILES[1] ) + '.RC' )
               do case
               case IsPelles
                  Out := Out + PUB_cCharTab + '$(US_MSG_EXE) ' + PROGRESS_LOG + ' -MSG:Compiling Resource File ' + US_FileNameOnlyPathAndName( PRGFILES[1] ) + '.rc' + ' ...' + Hb_OsNewLine()
                  Out := Out + PUB_cCharTab + '$(RESOURCE_COMP) /Fo$(DIR_OBJECTS)' + DEF_SLASH + US_FileNameOnlyName( PRGFILES[1] ) + '.res ' + US_ShortName( US_FileNameOnlyPathAndName( PRGFILES[1] ) + '.rc' ) + ' ' + Hb_OsNewLine()
               case IsBorland
                  Out := Out + PUB_cCharTab + '$(US_MSG_EXE) ' + PROGRESS_LOG + ' -MSG:Compiling Resource File ' + US_FileNameOnlyPathAndName( PRGFILES[1] ) + '.rc' + ' ...' + Hb_OsNewLine()
                  Out := Out + PUB_cCharTab + '$(RESOURCE_COMP) -d__BORLANDC__ -r -fo$(DIR_OBJECTS)' + DEF_SLASH + US_FileNameOnlyName( PRGFILES[1] ) + '.res ' + US_ShortName( US_FileNameOnlyPathAndName( PRGFILES[1] ) + '.rc' ) + ' ' + Hb_OsNewLine()
               otherwise
                  US_Log( 'Error 5649' )
               endcase
            endif
         endif
      endif

/*
 * Comandos para generar el ejecutable (van en Out) y para generar el
 * script de linkedición (van en script.ld)
 */
      do case
      case Prj_Radio_OutputType == DEF_RG_EXE
         Out := Out + PUB_cCharTab + '$(US_MSG_EXE) ' + PROGRESS_LOG + ' -MSG:Making script for link process ...' + Hb_OsNewLine()

/*
 * Grabo lista de objetos incluidos en las Include Libraries (estos objetos
 * deben estar en la carpeta Resources), y que estén marcados *FIRST*, en script.ld
 */
         For i := 1 To Len ( vLibIncludeFiles )
            if US_Upper( US_Word( GetProperty( 'VentanaMain', 'GIncFiles', 'Cell', i, NCOLINCFULLNAME ), 2 ) ) == '*FIRST*'
               if file( GetMiniGuiFolder() + DEF_SLASH + 'RESOURCES' + DEF_SLASH + substr( US_FileNameOnlyName( vLibIncludeFiles[i] ), 4 ) + '.o' )
                  do case
                  case IsMinGW
                     Out := Out + PUB_cCharTab + 'echo INPUT( $(DIR_MINIGUI_RES)' + DEF_SLASH + substr( US_FileNameOnlyName( vLibIncludeFiles[i] ), 4 ) + '.o ) >> ' + SCRIPT_FILE + Hb_OsNewLine()
                  case IsPelles
                     Out := Out + PUB_cCharTab + 'echo $(DIR_MINIGUI_RES)' + DEF_SLASH + substr( US_FileNameOnlyName( vLibIncludeFiles[i] ), 4 ) + '.obj >> ' + SCRIPT_FILE + Hb_OsNewLine()
                  case IsBorland
                     Out := Out + PUB_cCharTab + 'echo $(DIR_MINIGUI_RES)' + DEF_SLASH + substr( US_FileNameOnlyName( vLibIncludeFiles[i] ), 4 ) + '.obj >> ' + SCRIPT_FILE + Hb_OsNewLine()
                  otherwise
                     US_Log( 'Error 5671' )
                  endcase
               endif
            endif
         Next i

/*
 * Grabo lista de objetos derivados de los .prg en script.ld
 */
         For i := 1 To Len ( PrgFiles )
            do case
            case IsMinGW
               Out := Out + PUB_cCharTab + 'echo INPUT( $(DIR_OBJECTS)' + DEF_SLASH + US_FileNameOnlyName( PRGFILES[i] ) + '.o ) >> ' + SCRIPT_FILE + Hb_OsNewLine()
            case IsPelles
               Out := Out + PUB_cCharTab + 'echo $(DIR_OBJECTS)' + DEF_SLASH + US_FileNameOnlyName( PRGFILES[i] ) + '.obj >> ' + SCRIPT_FILE + Hb_OsNewLine()
            case IsBorland
               Out := Out + PUB_cCharTab + 'echo $(DIR_OBJECTS)' + DEF_SLASH + US_FileNameOnlyName( PRGFILES[i] ) + '.obj + >> ' + SCRIPT_FILE + Hb_OsNewLine()
            otherwise
               US_Log( 'Error 5672' )
            endcase
         Next i

         DO EVENTS

         do case
         case IsMinGW
/*
 * Grabo objeto generado a partir del archivo de recursos en script.ld
 */
            if ! Prj_Check_Console
               Out := Out + PUB_cCharTab + 'echo INPUT( $(DIR_OBJECTS)' + DEF_SLASH + '_Temp.o ) >> ' + SCRIPT_FILE + Hb_OsNewLine()
            endif

/*
 * Grabo objetos incluidos en las Default Libraries (estos objetos deben estar en la carpeta Resources) en script.ld
 */
            For i := 1 to len( &( 'vLibDefault'+GetSuffix() ) )
               if ascan( vLibExcludeFiles, US_Upper( &( 'vLibDefault'+GetSuffix()+'['+str(i)+']' ) ) ) = 0
                  if file( GetMiniGuiFolder() + DEF_SLASH + 'RESOURCES' + DEF_SLASH + substr( US_FileNameOnlyName( &('vLibDefault'+GetSuffix()+'['+str(i)+']') ), 4 ) + '.o' )
                     Out := Out + PUB_cCharTab + 'echo INPUT( $(DIR_MINIGUI_RES)' + DEF_SLASH + substr( US_FileNameOnlyName( &('vLibDefault'+GetSuffix()+'['+str(i)+']') ), 4 ) + '.o ) >> ' + SCRIPT_FILE + Hb_OsNewLine()
                  endif
               endif
            Next i

            DO EVENTS

/*
 * Grabo objetos incluidos en las Include Libraries (estos objetos deben estar
 * en la carpeta Resources), y que estén marcados *LAST*, en script.ld
 */
            For i := 1 To Len ( vLibIncludeFiles )
               if US_Upper( US_Word( GetProperty( 'VentanaMain', 'GIncFiles', 'Cell', i, NCOLINCFULLNAME ), 2 ) ) == '*LAST*' // for .res
                  if file( GetMiniGuiFolder() + DEF_SLASH + 'RESOURCES' + DEF_SLASH + substr( US_FileNameOnlyName( vLibIncludeFiles[i] ), 4 ) + '.o' )
                     Out := Out + PUB_cCharTab + 'echo INPUT( $(DIR_MINIGUI_RES)' + DEF_SLASH + substr( US_FileNameOnlyName( vLibIncludeFiles[i] ), 4 ) + '.o ) >> ' + SCRIPT_FILE + Hb_OsNewLine()
                  endif
               endif
            Next i

         case IsPelles
            Out := Out + PUB_cCharTab + 'echo /OUT:$(APP_NAME) >> ' + SCRIPT_FILE + Hb_OsNewLine()
            Out := Out + PUB_cCharTab + 'echo /FORCE:MULTIPLE >> ' + SCRIPT_FILE + Hb_OsNewLine()
            Out := Out + PUB_cCharTab + 'echo /LIBPATH:' + GetCppLibFolder() + ' >> ' + SCRIPT_FILE + Hb_OsNewLine()
            Out := Out + PUB_cCharTab + 'echo /LIBPATH:' + GetCppLibFolder() + DEF_SLASH + 'WIN' + ' >> ' + SCRIPT_FILE + Hb_OsNewLine()

         case IsBorland
            do case
            case Prj_Check_Console
               Out := Out + PUB_cCharTab + 'echo ' + GetCppLibFolder() + DEF_SLASH + 'c0x32.obj, + >> ' + SCRIPT_FILE + Hb_OsNewLine()
            case Prj_Radio_OutputType == DEF_RG_EXE
               Out := Out + PUB_cCharTab + 'echo ' + GetCppLibFolder() + DEF_SLASH + 'c0w32.obj, + >> ' + SCRIPT_FILE + Hb_OsNewLine()
            endcase
            Out := Out + PUB_cCharTab + 'echo $(APP_NAME), ' + US_ShortName(PUB_cProjectFolder) + DEF_SLASH + US_FileNameOnlyName( GetOutputModuleName() ) + '.MAP' + ', + >> ' + SCRIPT_FILE + Hb_OsNewLine()

         otherwise
            US_Log( 'Error 5746' )
      endcase

/*
 * Grabo libraries en script.ld
 */
            if QPM_IsXHarbour() .and. !IsMinGW .and. file( GetHarbourLibFolder() + DEF_SLASH + 'bcc640' + PUB_xHarbourMT + '.lib' )
               Out := Out + PUB_cCharTab + 'echo $(DIR_HARBOUR_LIB)'+DEF_SLASH+'bcc640'+PUB_xHarbourMT+'.lib + >> ' + SCRIPT_FILE + Hb_OsNewLine()
            endif

            DO EVENTS

            do case
               case IsMinGW
                  w_hay := .f.
                  w_group := 'GROUP( '
                  
/*
 * MINGW: add libraries marked FIRST
 */
                  For i := 1 To Len ( vLibIncludeFiles )
                     if US_Upper( US_Word( GetProperty( 'VentanaMain', 'GIncFiles', 'Cell', i, NCOLINCFULLNAME ), 2 ) ) == '*FIRST*'
                        if US_upper( US_FileNameOnlyExt( vLibIncludeFiles[i] ) ) == 'A'
                           w_hay := .t.
                           w_group += '-l' + substr( US_FileNameOnlyName( vLibIncludeFiles[i] ), 4 ) + ' '
                        else
                           w_hay := .t.
                           w_group += US_ShortName( vLibIncludeFiles[i] ) + ' '
                        endif
                     endif
                  Next

/*
 * MINGW: add MiniGui main library
 */
                  if Prj_Check_Console
                     if ascan( vLibExcludeFiles, US_Upper( GetMiniGuiName() ) ) = 0
                        w_hay := .t.
                        w_group += '-l' + substr( US_FileNameOnlyName( GetMiniGuiName() ), 4 ) + ' '
                        aadd( &( 'vLibDefault'+GetSuffix() ), 'libgtgui.a' )
                     endif
                  else
                     w_hay := .t.
                     w_group += '-l' + substr( US_FileNameOnlyName( GetMiniGuiName() ), 4 ) + ' '
                     if ascan( vLibExcludeFiles, US_Upper( GetMiniGuiName() ) ) > 0
                        MsgInfo( 'Warning: ' + GetMiniGuiName() + ' excluded for Windows mode.' + Hb_OsNewLine() + 'QPM added it automatically.' + Hb_OsNewLine() + 'Look at tab ' + DBLQT + PageLIB + DBLQT )
                     endif
                  endif

                  DO EVENTS

/*
 * MINGW: add other libraries
 */
                  // Algoritmo de búsqueda:
                  //    Que no esté excluida
                  //    La busco con o sin X (según sea xharbour o harbour) en el directorio lib de minigui
                  //    Si no está y es xharbour y es Extended la busco sin X en el directorio xlib de minigui
                  //    Si no está la busco con o sin X en el directorio de libs de (x)harbour
                  //    Si no está y es xharbour la busco sin X en el directorio de libs de xharbour
                  //    Si no está la busco en el directorio de libs de MINGW
                  For i := 1 to len( &( 'vLibDefault'+GetSuffix() ) )
                     if ascan( vLibExcludeFiles, US_Upper( &( 'vLibDefault'+GetSuffix()+'['+str(i)+']' ) ) ) = 0
                        if File( GetMiniGuiLibFolder() + DEF_SLASH + ( 'lib' + if(QPM_IsXHarbour(),'x','') + substr( &('vLibDefault'+GetSuffix()+'['+str(i)+']'), 4 ) ) )
                           w_hay := .t.
                           w_group += '-l' + if(QPM_IsXHarbour(),'x','') + substr( US_FileNameOnlyName( &( 'vLibDefault'+GetSuffix()+'['+str(i)+']' ) ), 4 ) + ' '
                        elseif QPM_IsXHarbour() .and. ( Getminiguisuffix() == DefineExtended1 ) .and. File( GetMiniGuiFolder() + DEF_SLASH + 'xlib' + DEF_SLASH + ( 'lib' + substr( &('vLibDefault'+GetSuffix()+'['+str(i)+']'), 4 ) ) )
                           w_hay := .t.
                           w_group += '-l' + substr( US_FileNameOnlyName( &( 'vLibDefault'+GetSuffix()+'['+str(i)+']' ) ), 4 ) + ' '
                        elseif File( GetHarbourLibFolder() + DEF_SLASH + ( 'lib' + if(QPM_IsXHarbour(),'x','') + substr( &('vLibDefault'+GetSuffix()+'['+str(i)+']'), 4 ) ) )
                           w_hay := .t.
                           w_group += '-l' + if(QPM_IsXHarbour(),'x','') + substr( US_FileNameOnlyName( &( 'vLibDefault'+GetSuffix()+'['+str(i)+']' ) ), 4 ) + ' '
                        elseif QPM_IsXHarbour() .and. File( GetHarbourLibFolder() + DEF_SLASH + ( 'lib' + substr( &('vLibDefault'+GetSuffix()+'['+str(i)+']'), 4 ) ) )
                           w_hay := .t.
                           w_group += '-l' + substr( US_FileNameOnlyName( &( 'vLibDefault'+GetSuffix()+'['+str(i)+']' ) ), 4 ) + ' '
                        elseif File( GetCppLibFolder() + DEF_SLASH + ( 'lib' + substr( &('vLibDefault'+GetSuffix()+'['+str(i)+']'), 4 ) ) )
                           w_hay := .t.
                           w_group += '-l' + substr( US_FileNameOnlyName( &( 'vLibDefault'+GetSuffix()+'['+str(i)+']' ) ), 4 ) + ' '
                        endif
                     endif
                  next

                  DO EVENTS

/*
 * MINGW: add libraries marked LAST
 */
                  For i := 1 To Len ( vLibIncludeFiles )
                     if US_Upper( US_Word( GetProperty( 'VentanaMain', 'GIncFiles', 'Cell', i, NCOLINCFULLNAME ), 2 ) ) == '*LAST*'
                        if US_upper( US_FileNameOnlyExt( vLibIncludeFiles[i] ) ) == 'A'
                           w_hay := .t.
                           w_group += '-l' + substr( US_FileNameOnlyName( vLibIncludeFiles[i] ), 4 ) + ' '
                        else
                           w_hay := .t.
                           w_group += US_ShortName( vLibIncludeFiles[i] ) + ' '
                        endif
                     endif
                  Next

                  if w_hay
                     w_group += ')'
                     Out := Out + PUB_cCharTab + 'echo ' + w_group + ' >> ' + SCRIPT_FILE + Hb_OsNewLine()
                  endif

/*
 * Add search folders to script.ld
 */
                  Out := Out + PUB_cCharTab + 'echo SEARCH_DIR( $(DIR_MINIGUI_LIB) ) >> ' + SCRIPT_FILE + Hb_OsNewLine()
                  if QPM_IsXHarbour() .and. ( Getminiguisuffix() == DefineExtended1 )
                     Out := Out + PUB_cCharTab + 'echo SEARCH_DIR( $(DIR_MINIGUI)' + DEF_SLASH + 'xlib ) >> ' + SCRIPT_FILE + Hb_OsNewLine()
                  endif
                  Out := Out + PUB_cCharTab + 'echo SEARCH_DIR( $(DIR_HARBOUR_LIB) ) >> ' + SCRIPT_FILE + Hb_OsNewLine()
                  Out := Out + PUB_cCharTab + 'echo SEARCH_DIR( $(DIR_COMPC_LIB) ) >> ' + SCRIPT_FILE + Hb_OsNewLine()
                  For i := 1 To Len( &('vExtraFoldersForLibs'+GetSuffix()) )
                     if ! empty( &('vExtraFoldersForLibs'+GetSuffix()+'['+str(i)+']') ) .and. ;
                         &('vExtraFoldersForLibs'+GetSuffix()+'['+str(i)+']') != upper( GetCppLibFolder() ) .and. ;
                         &('vExtraFoldersForLibs'+GetSuffix()+'['+str(i)+']') != upper( GetMiniguiLibFolder() ) .and. ;
                         &('vExtraFoldersForLibs'+GetSuffix()+'['+str(i)+']') != upper( GetHarbourLibFolder() )
                        Out := Out + PUB_cCharTab + 'echo SEARCH_DIR( ' + US_ShortName( &('vExtraFoldersForLibs'+GetSuffix()+'['+str(i)+']') ) + ' ) >> ' + SCRIPT_FILE + Hb_OsNewLine()
                     endif
                  next
               case IsPelles
                  For i := 1 To Len ( vLibIncludeFiles )
                     if US_Upper( US_Word( GetProperty( 'VentanaMain', 'GIncFiles', 'Cell', i, NCOLINCFULLNAME ), 2 ) ) == '*FIRST*'
                        Out := Out + PUB_cCharTab + 'echo ' + US_ShortName(vLibIncludeFiles[i]) + ' >> ' + SCRIPT_FILE + Hb_OsNewLine()
                     endif
                  Next i

                  if Prj_Check_Console
                     if ascan( vLibExcludeFiles, US_Upper( GetMiniGuiName() ) ) = 0
                        Out := Out + PUB_cCharTab + 'echo ' + GetMiniguiLibFolder() + DEF_SLASH + GetMiniGuiName() + ' >> ' + SCRIPT_FILE + Hb_OsNewLine()
                        aadd( &( 'vLibDefault'+GetSuffix() ), 'gtgui.lib' )
                     endif
                  else
                     Out := Out + PUB_cCharTab + 'echo ' + GetMiniguiLibFolder() + DEF_SLASH + GetMiniGuiName() + ' >> ' + SCRIPT_FILE + Hb_OsNewLine()
                     if ascan( vLibExcludeFiles, US_Upper( GetMiniGuiName() ) ) > 0
                        MsgInfo( 'Warning: ' + GetMiniGuiName() + ' excluded for Windows mode.' + Hb_OsNewLine() + 'QPM added it automatically.' + Hb_OsNewLine() + 'Look at tab ' + DBLQT + PageLIB + DBLQT )
                     endif
                  endif

                  DO EVENTS

/*
 * PELLES: add other libraries
 */
                  // Algoritmo de búsqueda:
                  //    Que no esté excluida
                  //    La busco con o sin X (según sea xharbour o harbour) en el directorio lib de minigui
                  //    Si no está y es xharbour y es Extended la busco sin X en el directorio xlib de minigui
                  //    Si no está la busco con o sin X en el directorio de libs de (x)harbour
                  //    Si no está y es xharbour la busco sin X en el directorio de libs de xharbour
                  //    Si no está la busco en el directorio de libs de PELLES o en el subdirectorio WIN
                  For i := 1 to len( &( 'vLibDefault'+GetSuffix() ) )
                     if ascan( vLibExcludeFiles, US_Upper( &( 'vLibDefault'+GetSuffix()+'['+str(i)+']' ) ) ) = 0
                        if File( GetMiniguiLibFolder() + DEF_SLASH + ( if(QPM_IsXHarbour(),'x','') + &('vLibDefault'+GetSuffix()+'['+str(i)+']') ) )
                           Out := Out + PUB_cCharTab + 'echo $(DIR_MINIGUI_LIB)' + DEF_SLASH + ( if(QPM_IsXHarbour(),'x','') + &('vLibDefault'+GetSuffix()+'['+str(i)+']') ) + ' >> ' + SCRIPT_FILE + Hb_OsNewLine()
                        elseif QPM_IsXHarbour() .and. ( Getminiguisuffix() == DefineExtended1 ) .and. File( GetMiniGuiFolder() + DEF_SLASH + 'xlib' + DEF_SLASH + substr( &('vLibDefault'+GetSuffix()+'['+str(i)+']'), 4 ) )
                           Out := Out + PUB_cCharTab + 'echo $(DIR_MINIGUI)' + DEF_SLASH + 'xlib' + DEF_SLASH + &('vLibDefault'+GetSuffix()+'['+str(i)+']') + ' >> ' + SCRIPT_FILE + Hb_OsNewLine()
                        elseif File( GetHarbourLibFolder() + DEF_SLASH + ( if(QPM_IsXHarbour(),'x','') + &('vLibDefault'+GetSuffix()+'['+str(i)+']') ) )
                           Out := Out + PUB_cCharTab + 'echo $(DIR_HARBOUR_LIB)' + DEF_SLASH + ( if(QPM_IsXHarbour(),'x','') + &('vLibDefault'+GetSuffix()+'['+str(i)+']') ) + ' >> ' + SCRIPT_FILE + Hb_OsNewLine()
                        elseif QPM_IsXHarbour() .and. File( GetHarbourLibFolder() + DEF_SLASH + &('vLibDefault'+GetSuffix()+'['+str(i)+']') )
                           Out := Out + PUB_cCharTab + 'echo $(DIR_HARBOUR_LIB)' + DEF_SLASH + &('vLibDefault'+GetSuffix()+'['+str(i)+']') + ' >> ' + SCRIPT_FILE + Hb_OsNewLine()
                        elseif File( GetCppLibFolder() + DEF_SLASH + &('vLibDefault'+GetSuffix()+'['+str(i)+']') ) .or. ;
                               File( GetCppLibFolder() + DEF_SLASH + 'WIN' + DEF_SLASH + &('vLibDefault'+GetSuffix()+'['+str(i)+']') )
                           Out := Out + PUB_cCharTab + 'echo ' + &('vLibDefault'+GetSuffix()+'['+str(i)+']') + ' >> ' + SCRIPT_FILE + Hb_OsNewLine()
                        endif
                     endif
                  Next

                  For i := 1 To Len ( vLibIncludeFiles )
                     if US_Upper( US_Word( GetProperty( 'VentanaMain', 'GIncFiles', 'Cell', i, NCOLINCFULLNAME ), 2 ) ) == '*LAST*'
                        Out := Out + PUB_cCharTab + 'echo ' + US_ShortName(vLibIncludeFiles[i]) + ' >> ' + SCRIPT_FILE + Hb_OsNewLine()
                     endif
                  Next i

                  DO EVENTS

                  if ! Prj_Check_Console
                     if File( US_FileNameOnlyPathAndName( PRGFILES[1] ) + '.rc' )
                        Out := Out + PUB_cCharTab + 'echo $(DIR_OBJECTS)' + DEF_SLASH + US_FileNameOnlyName( PRGFILES[1] ) + '.res' + ' >> ' + SCRIPT_FILE + Hb_OsNewLine()
                     endif
                     For i := 1 To Len ( vLibIncludeFiles )
                        if US_Upper( US_Word( GetProperty( 'VentanaMain', 'GIncFiles', 'Cell', i, NCOLINCFULLNAME ), 2 ) ) == '*FIRST*' // for .res
                           if file( GetMiniGuiFolder() + DEF_SLASH + 'RESOURCES' + DEF_SLASH + US_FileNameOnlyName( vLibIncludeFiles[i] ) + '.res' )
                              Out := Out + PUB_cCharTab + 'echo ' + US_ShortName( GetMiniGuiFolder()) + DEF_SLASH + 'RESOURCES' + DEF_SLASH + US_FileNameOnlyName( vLibIncludeFiles[i] ) + '.res' + ' >> ' + SCRIPT_FILE + Hb_OsNewLine()
                           endif
                        endif
                     Next i

                     Out := Out + PUB_cCharTab + 'echo ' + US_ShortName( GetMiniGuiFolder() + DEF_SLASH + 'RESOURCES' ) + DEF_SLASH + cResourceFileName + '.res >> ' + SCRIPT_FILE + Hb_OsNewLine()
                     For i := 1 to len( &( 'vLibDefault'+GetSuffix() ) )
                        if ! ( Getminiguisuffix() == DefineOohg3 .and. ;
                               ( US_Upper( &('vLibDefault'+GetSuffix()+'['+str(i)+']') ) == 'HBPRINTER.LIB' .or. ;
                               US_Upper( &('vLibDefault'+GetSuffix()+'['+str(i)+']') ) == 'MINIPRINT.LIB' ) )
                           if ascan( vLibExcludeFiles, US_Upper( &( 'vLibDefault'+GetSuffix()+'['+str(i)+']' ) ) ) = 0
                              if file( GetMiniGuiFolder() + DEF_SLASH + 'RESOURCES' + DEF_SLASH + US_FileNameOnlyName( &('vLibDefault'+GetSuffix()+'['+str(i)+']') ) + '.res' )
                                 Out := Out + PUB_cCharTab + 'echo ' + US_ShortName( GetMiniGuiFolder() + DEF_SLASH + 'RESOURCES' ) + DEF_SLASH + US_FileNameOnlyName( &('vLibDefault'+GetSuffix()+'['+str(i)+']') ) + '.res >> ' + SCRIPT_FILE + Hb_OsNewLine()
                              endif
                           endif
                        endif
                     Next i

                     For i := 1 To Len ( vLibIncludeFiles )
                        if US_Upper( US_Word( GetProperty( 'VentanaMain', 'GIncFiles', 'Cell', i, NCOLINCFULLNAME ), 2 ) ) == '*LAST*' // for .res
                           if file( GetMiniGuiFolder() + DEF_SLASH + 'RESOURCES' + DEF_SLASH + US_FileNameOnlyName( vLibIncludeFiles[i] ) + '.res' )
                              Out := Out + PUB_cCharTab + 'echo ' + US_ShortName( GetMiniGuiFolder() + DEF_SLASH + 'RESOURCES' ) + DEF_SLASH + US_FileNameOnlyName( vLibIncludeFiles[i] ) + '.res >> ' + SCRIPT_FILE + Hb_OsNewLine()
                           endif
                        endif
                     Next i

                     DO EVENTS
                  endif
               case IsBorland
                  For i := 1 To Len ( vLibIncludeFiles )
                     if US_Upper( US_Word( GetProperty( 'VentanaMain', 'GIncFiles', 'Cell', i, NCOLINCFULLNAME ), 2 ) ) == '*FIRST*'
                        Out := Out + PUB_cCharTab + 'echo ' + US_ShortName(vLibIncludeFiles[i]) + ' + >> ' + SCRIPT_FILE + Hb_OsNewLine()
                     endif
                  Next i

                  if Prj_Check_Console
                     if ascan( vLibExcludeFiles, US_Upper( GetMiniGuiName() ) ) = 0
                        Out := Out + PUB_cCharTab + 'echo ' + GetMiniguiLibFolder() + DEF_SLASH + GetMiniGuiName() + ' + >> ' + SCRIPT_FILE + Hb_OsNewLine()
                        aadd( &( 'vLibDefault'+GetSuffix() ), 'gtgui.lib' )
                     endif
                  else
                     Out := Out + PUB_cCharTab + 'echo ' + GetMiniguiLibFolder() + DEF_SLASH + GetMiniGuiName() + ' + >> ' + SCRIPT_FILE + Hb_OsNewLine()
                     if ascan( vLibExcludeFiles, US_Upper( GetMiniGuiName() ) ) > 0
                        MsgInfo( 'Warning: ' + GetMiniGuiName() + ' excluded for Windows mode.' + Hb_OsNewLine() + 'QPM added it automatically.' + Hb_OsNewLine() + 'Look at tab ' + DBLQT + PageLIB + DBLQT )
                     endif
                  endif

                  DO EVENTS

/*
 * BCC32: add other libraries
 */
                  // Algoritmo de búsqueda:
                  //    Que no esté excluida
                  //    La busco con o sin X (según sea xharbour o harbour) en el directorio lib de minigui
                  //    Si no está y es xharbour y es Extended la busco sin X en el directorio xlib de minigui
                  //    Si no está la busco con o sin X en el directorio de libs de (x)harbour
                  //    Si no está y es xharbour la busco sin X en el directorio de libs de xharbour
                  //    Si no está la busco en el directorio de libs de BCC32 o en el subdirectorio PSDK
                  For i := 1 to len( &( 'vLibDefault'+GetSuffix() ) )
                     if aScan( vLibExcludeFiles, US_Upper( &( 'vLibDefault'+GetSuffix()+'['+str(i)+']' ) ) ) = 0
                        if File( GetMiniguiLibFolder() + DEF_SLASH + ( if(QPM_IsXHarbour(),'x','') + &('vLibDefault'+GetSuffix()+'['+str(i)+']') ) )
                           Out := Out + PUB_cCharTab + 'echo $(DIR_MINIGUI_LIB)' + DEF_SLASH + ( if(QPM_IsXHarbour(),'x','') + &('vLibDefault'+GetSuffix()+'['+str(i)+']') ) + ' + >> ' + SCRIPT_FILE + Hb_OsNewLine()
                        elseif QPM_IsXHarbour() .and. ( Getminiguisuffix() == DefineExtended1 ) .and. File( GetMiniGuiFolder() + DEF_SLASH + 'xlib' + DEF_SLASH + &('vLibDefault'+GetSuffix()+'['+str(i)+']') )
                           Out := Out + PUB_cCharTab + 'echo $(DIR_MINIGUI)' + DEF_SLASH + 'xlib' + DEF_SLASH + &('vLibDefault'+GetSuffix()+'['+str(i)+']') + ' + >> ' + SCRIPT_FILE + Hb_OsNewLine()
                        elseif File( GetHarbourLibFolder() + DEF_SLASH + ( if(QPM_IsXHarbour(),'x','') + &('vLibDefault'+GetSuffix()+'['+str(i)+']') ) )
                           Out := Out + PUB_cCharTab + 'echo $(DIR_HARBOUR_LIB)' + DEF_SLASH + ( if(QPM_IsXHarbour(),'x','') + &('vLibDefault'+GetSuffix()+'['+str(i)+']') ) + ' + >> ' + SCRIPT_FILE + Hb_OsNewLine()
                        elseif QPM_IsXHarbour() .and. File( GetHarbourLibFolder() + DEF_SLASH + &('vLibDefault'+GetSuffix()+'['+str(i)+']') )
                           Out := Out + PUB_cCharTab + 'echo $(DIR_HARBOUR_LIB)' + DEF_SLASH + &('vLibDefault'+GetSuffix()+'['+str(i)+']') + ' + >> ' + SCRIPT_FILE + Hb_OsNewLine()
                        elseif File( GetCppLibFolder() + DEF_SLASH + &('vLibDefault'+GetSuffix()+'['+str(i)+']') )
                           Out := Out + PUB_cCharTab + 'echo $(DIR_COMPC_LIB)' + DEF_SLASH + &('vLibDefault'+GetSuffix()+'['+str(i)+']') + ' + >> ' + SCRIPT_FILE + Hb_OsNewLine()
                        elseif File( GetCppLibFolder() + DEF_SLASH + 'PSDK' + DEF_SLASH + &('vLibDefault'+GetSuffix()+'['+str(i)+']') )
                           Out := Out + PUB_cCharTab + 'echo $(DIR_COMPC_LIB2)' + DEF_SLASH + &('vLibDefault'+GetSuffix()+'['+str(i)+']') + ' + >> ' + SCRIPT_FILE + Hb_OsNewLine()
                        endif
                     endif
                  Next

                  DO EVENTS

                  For i := 1 To Len ( vLibIncludeFiles )
                     if US_Upper( US_Word( GetProperty( 'VentanaMain', 'GIncFiles', 'Cell', i, NCOLINCFULLNAME ), 2 ) ) == '*LAST*'
                        Out := Out + PUB_cCharTab + 'echo ' + US_ShortName( vLibIncludeFiles[i] ) + ' + >> ' + SCRIPT_FILE + Hb_OsNewLine()
                     endif
                  Next i

                  Out := Out + PUB_cCharTab + 'echo $(DIR_COMPC_LIB)' + DEF_SLASH + 'import32.lib + >> ' + SCRIPT_FILE + Hb_OsNewLine()
                  Out := Out + PUB_cCharTab + 'echo $(DIR_COMPC_LIB)' + DEF_SLASH + 'cw32.lib,, + >> ' + SCRIPT_FILE + Hb_OsNewLine()
                  if ! Prj_Check_Console
                     if File( US_FileNameOnlyPathAndName( PRGFILES[1] ) + '.RC' )
                        Out := Out + PUB_cCharTab + 'echo $(DIR_OBJECTS)' + DEF_SLASH + US_FileNameOnlyName( PRGFILES[1] ) + '.res' + ' + >> ' + SCRIPT_FILE + Hb_OsNewLine()
                     endif

                     For i := 1 To Len ( vLibIncludeFiles )
                        if US_Upper( US_Word( GetProperty( 'VentanaMain', 'GIncFiles', 'Cell', i, NCOLINCFULLNAME ), 2 ) ) == '*FIRST*' // for .res
                           if file( GetMiniGuiFolder() + DEF_SLASH + 'RESOURCES' + DEF_SLASH + US_FileNameOnlyName( vLibIncludeFiles[i] ) + '.res' )
                              Out := Out + PUB_cCharTab + 'echo ' + US_ShortName( GetMiniGuiFolder() + DEF_SLASH + 'RESOURCES' ) + DEF_SLASH + US_FileNameOnlyName( vLibIncludeFiles[i] ) + '.res' + ' + >> ' + SCRIPT_FILE + Hb_OsNewLine()
                           endif
                        endif
                     Next i

                     DO EVENTS

                     Out := Out + PUB_cCharTab + 'echo ' + US_ShortName( GetMiniGuiFolder() + DEF_SLASH + 'RESOURCES' ) + DEF_SLASH + cResourceFileName + '.res' + ' + >> ' + SCRIPT_FILE + Hb_OsNewLine()
                     For i := 1 to len( &( 'vLibDefault'+GetSuffix() ) )
                        if ! ( Getminiguisuffix() == DefineOohg3 .and. ;
                             ( US_Upper( &('vLibDefault'+GetSuffix()+'['+str(i)+']') ) == 'HBPRINTER.LIB' .or. ;
                               US_Upper( &('vLibDefault'+GetSuffix()+'['+str(i)+']') ) == 'MINIPRINT.LIB' ) )
                           if ascan( vLibExcludeFiles, US_Upper( &( 'vLibDefault'+GetSuffix()+'['+str(i)+']' ) ) ) = 0
                              if file( GetMiniGuiFolder() + DEF_SLASH + 'RESOURCES' + DEF_SLASH + US_FileNameOnlyName( &('vLibDefault'+GetSuffix()+'['+str(i)+']') ) + '.res' )
                                 Out := Out + PUB_cCharTab + 'echo ' + US_ShortName( GetMiniGuiFolder() + DEF_SLASH + 'RESOURCES' ) + DEF_SLASH + US_FileNameOnlyName( &('vLibDefault'+GetSuffix()+'['+str(i)+']') ) + '.res' + ' + >> ' + SCRIPT_FILE + Hb_OsNewLine()
                              endif
                           endif
                        endif
                     Next i

                     DO EVENTS

                     For i := 1 To Len ( vLibIncludeFiles )
                        if US_Upper( US_Word( GetProperty( 'VentanaMain', 'GIncFiles', 'Cell', i, NCOLINCFULLNAME ), 2 ) ) == '*LAST*' // for .res
                           if file( GetMiniGuiFolder() + DEF_SLASH + 'RESOURCES' + DEF_SLASH + US_FileNameOnlyName( vLibIncludeFiles[i] ) + '.res' )
                              Out := Out + PUB_cCharTab + 'echo ' + US_ShortName( GetMiniGuiFolder() + DEF_SLASH + 'RESOURCES' ) + DEF_SLASH + US_FileNameOnlyName( vLibIncludeFiles[i] ) + '.res' + ' + >> ' + SCRIPT_FILE + Hb_OsNewLine()
                           endif
                        endif
                     Next i
                  endif

                  DO EVENTS
               otherwise
                  US_Log( 'Error 6127' )
            endcase
         case Prj_Radio_OutputType == DEF_RG_LIB
            For i := 1 To Len ( PRGFILES )
               do case
                  case IsMinGW
                  case IsPelles
                     if i==1
                        Out := Out + PUB_cCharTab + 'echo /out:$@ ' + '> ' + SCRIPT_FILE + Hb_OsNewLine()
                     endif
                     Out := Out + PUB_cCharTab + 'echo $(DIR_OBJECTS)' + DEF_SLASH + US_FileNameOnlyName( PRGFILES[i] ) + '.obj ' + '>> ' + SCRIPT_FILE + Hb_OsNewLine()
                  case IsBorland
                     // La siguiente linea tiene el string *AMPERSAND* porque en el sistema operativo Windows 2003 Server Enterprise Edition si codifico el & no funciona el PIPE (>)
                     Out := Out + PUB_cCharTab + 'echo +$(DIR_OBJECTS)' + DEF_SLASH + US_FileNameOnlyName( PRGFILES[i] ) + '.obj ' + if(i<len( PRGFILES ),'*AMPERSAND* ',' ') + if(i>1,'>','') + '> ' + SCRIPT_FILE + Hb_OsNewLine()
                  otherwise
                     US_Log( 'Error 6143' )
               endcase
            Next i
         otherwise
            MsgInfo( 'Invalid Output Type: ' + cOutputType() )
            BUILD_IN_PROGRESS := .F.
            DefinoWindowsHotKeys( .F. )
            Return .F.
      endcase

      DO EVENTS

/*
 * Add command for linking to script.ld
 */
      do case
      case IsMinGw
         do case
         case Prj_Radio_OutputType == DEF_RG_EXE
            Out := Out + PUB_cCharTab + '$(US_MSG_EXE) ' + PROGRESS_LOG + ' -MSG:Linking ' + cOutputNameDisplay + ' ...' + Hb_OsNewLine()
            if Empty( GetProperty( 'VentanaMain', 'OverrideLink', 'value' ) )
               Out := Out + PUB_cCharTab + '$(ILINK_EXE) -Wall -o $(APP_NAME) ' + SCRIPT_FILE + if( Prj_Check_Console, ' -mconsole', ' -mwindows' ) + Hb_OsNewLine()
            else
               Out := Out + PUB_cCharTab + '$(ILINK_EXE) -Wall $(USER_FLAGS_LINK) -o $(APP_NAME) ' + SCRIPT_FILE + if( Prj_Check_Console, ' -mconsole', ' -mwindows' ) + Hb_OsNewLine()
            endif
            if Prj_Check_Upx
               Out := Out + PUB_cCharTab + '$(US_MSG_EXE) ' + PROGRESS_LOG + ' -MSG:Compressing ' + cOutputNameDisplay + ' with UPX ...' + Hb_OsNewLine()
               Out := Out + PUB_cCharTab + '$(US_UPX_EXE) ' + cUpxOpt + ' ' + cOutputName + ' ' + Hb_OsNewLine()
            endif
         case Prj_Radio_OutputType == DEF_RG_LIB
            Out := Out + PUB_cCharTab + '$(US_MSG_EXE) ' + PROGRESS_LOG + ' -MSG:Making Library ' + cOutputNameDisplay + ' ...' + Hb_OsNewLine()
            For i := 1 To Len ( PRGFILES )
               Out := Out + PUB_cCharTab + '$(TLIB_EXE) rc ' + cOutputName + ' $(DIR_OBJECTS)' + DEF_SLASH + US_FileNameOnlyName( PRGFILES[i] ) + '.o ' + Hb_OsNewLine()
            Next i
         otherwise
            Out := Out + PUB_cCharTab + '$(US_MSG_EXE) ' + PROGRESS_LOG + ' -MSG:Output Type Invalid: '+ US_VarToStr( Prj_Radio_OutputType ) + Hb_OsNewLine()
         endcase
      case IsPelles
         do case
         case Prj_Radio_OutputType == DEF_RG_EXE
            Out := Out + PUB_cCharTab + '$(US_MSG_EXE) ' + PROGRESS_LOG + ' -MSG:Linking ' + cOutputNameDisplay + ' ...' + Hb_OsNewLine()
            if Empty( GetProperty( 'VentanaMain', 'OverrideLink', 'value' ) )
               Out := Out + PUB_cCharTab + '$(ILINK_EXE) ' + if( Prj_Check_Console, '/SUBSYSTEM:CONSOLE ', '/SUBSYSTEM:WINDOWS ' ) + '@' + SCRIPT_FILE + Hb_OsNewLine()
            else
               Out := Out + PUB_cCharTab + '$(ILINK_EXE) ' + if( Prj_Check_Console, '/SUBSYSTEM:CONSOLE ', '/SUBSYSTEM:WINDOWS ' ) + '$(USER_FLAGS_LINK) ' + '@' + SCRIPT_FILE + Hb_OsNewLine()
            endif
            if Prj_Check_Upx
               Out := Out + PUB_cCharTab + '$(US_MSG_EXE) ' + PROGRESS_LOG + ' -MSG:Compressing ' + cOutputNameDisplay + ' with UPX ...' + Hb_OsNewLine()
               Out := Out + PUB_cCharTab + '$(US_UPX_EXE) ' + cUpxOpt + ' ' + cOutputName + Hb_OsNewLine()
            endif
         case Prj_Radio_OutputType == DEF_RG_LIB
            Out := Out + PUB_cCharTab + '$(US_MSG_EXE) ' + PROGRESS_LOG + ' -MSG:Making Library ' + cOutputNameDisplay + ' ...' + Hb_OsNewLine()
            Out := Out + PUB_cCharTab + '$(TLIB_EXE) @' + SCRIPT_FILE + Hb_OsNewLine()
         otherwise
            Out := Out + PUB_cCharTab + '$(US_MSG_EXE) ' + PROGRESS_LOG + ' -MSG:Output Type Invalid: '+ US_VarToStr( Prj_Radio_OutputType ) + Hb_OsNewLine()
         endcase
      case IsBorland
         do case
         case Prj_Radio_OutputType == DEF_RG_EXE
            Out := Out + PUB_cCharTab + '$(US_MSG_EXE) ' + PROGRESS_LOG + ' -MSG:Linking ' + cOutputNameDisplay + ' ...' + Hb_OsNewLine()
            if Empty( GetProperty( 'VentanaMain', 'OverrideLink', 'value' ) )
               Out := Out + PUB_cCharTab + '$(ILINK_EXE) -x ' + if( !Prj_Check_Console, '-Gn -Tpe '+If(PUB_bDebugActive,'-ap ','-aa '), '-Gn ' ) + '-L' + GetCppLibFolder() + ' @' + SCRIPT_FILE + Hb_OsNewLine()
            else
               Out := Out + PUB_cCharTab + '$(ILINK_EXE) -x ' + if( !Prj_Check_Console, '-Gn -Tpe '+If(PUB_bDebugActive,'-ap ','-aa '), '-Gn ' ) + '$(USER_FLAGS_LINK) -L' + GetCppLibFolder() + ' @' + SCRIPT_FILE + Hb_OsNewLine()
            endif
            if Prj_Check_Upx
               Out := Out + PUB_cCharTab + '$(US_MSG_EXE) ' + PROGRESS_LOG + ' -MSG:Compressing ' + cOutputNameDisplay + ' with UPX ...' + Hb_OsNewLine()
               Out := Out + PUB_cCharTab + '$(US_UPX_EXE) ' + cUpxOpt + ' ' + cOutputName + Hb_OsNewLine()
            endif
         case Prj_Radio_OutputType == DEF_RG_LIB
            Out := Out + PUB_cCharTab + '$(US_MSG_EXE) ' + PROGRESS_LOG + ' -MSG:Making Library ' + cOutputNameDisplay + ' ...' + Hb_OsNewLine()
            // La siguiente linea tiene el string *AMPERSAND* porque en el sistema operativo Windows 2003 Server Enterprise Edition si codifico el & no funciona el PIPE (>)
            Out := Out + PUB_cCharTab + '$(US_SHELL_EXE) CHANGE ' + SCRIPT_FILE + ' *AMPERSAND* & ' + Hb_OsNewLine()
            Out := Out + PUB_cCharTab + '$(TLIB_EXE) /P32 $@ @' + SCRIPT_FILE + Hb_OsNewLine()
         otherwise
            Out := Out + PUB_cCharTab + '$(US_MSG_EXE) ' + PROGRESS_LOG + ' -MSG:Output Type Invalid: '+ US_VarToStr( Prj_Radio_OutputType ) + Hb_OsNewLine()
         endcase
      otherwise
         US_Log( 'Error 6255' )
      endcase

      // Copy or Move
      if Prj_Radio_OutputCopyMove # DEF_RG_NONE
         Out := Out + PUB_cCharTab + '$(US_MSG_EXE) ' + PROGRESS_LOG + ' -MSG:' + cOutputCopyMove() + ' '+cOutputNameDisplay+' to ' + Prj_Text_OutputCopyMoveFolder + DEF_SLASH + US_FileNameOnlyNameAndExt( cOutputNameDisplay ) + ' ...' + Hb_OsNewLine()
         Out := Out + PUB_cCharTab + if(! bLogActivity, '@', '') + '$(US_SHELL_EXE) ' + if(! bLogActivity, '-OFF ','') + cOutputCopyMove() + ' ' + cOutputName + ' ' + US_ShortName( Prj_Text_OutputCopyMoveFolder ) + DEF_SLASH + US_FileNameOnlyNameAndExt( cOutputName ) + Hb_OsNewLine()
      endif

      if PUB_bDebugActive
         if Prj_Radio_OutputCopyMove == DEF_RG_MOVE
            DebugOptions( US_ShortName( Prj_Text_OutputCopyMoveFolder ), cDebugPath )
         else
            if Prj_Radio_OutputCopyMove == DEF_RG_COPY
               DebugOptions( US_ShortName( Prj_Text_OutputCopyMoveFolder ), cDebugPath )
            endif
            DebugOptions( US_FileNameOnlyPath( cOutputName ), cDebugPath )
         endif
         if !empty( VentanaMain.TRunProjectFolder.Value )
            DebugOptions( US_FileNameOnlyPath( VentanaMain.TRunProjectFolder.Value ), cDebugPath )
         endif
      endif

      DO EVENTS

/*
 * Add commands for compiling to script.ld
 */
      For i := 1 To Len ( PRGFILES )
         Out := Out + Hb_OsNewLine()
         Out := Out + '$(C_DIR)' + DEF_SLASH + US_FileNameOnlyName( PRGFILES[i] ) + '.' + if( upper( US_FileNameOnlyExt( PRGFILES[i] ) ) == 'CPP', 'cpp', 'c' ) + ' : ' + US_ShortName( US_FileNameOnlyPath( PRGFILES[i] ) ) + DEF_SLASH + US_FileNameOnlyNameAndExt( PRGFILES[i] ) + Hb_OsNewLine()
         Out := Out + PUB_cCharTab + '$(US_MSG_EXE) ' + PROGRESS_LOG + ' -MSG:Processing ' + PRGFILES[i] + ' ...' + Hb_OsNewLine()
         if US_Upper( US_FileNameOnlyExt( PRGFILES[i] ) ) == US_Upper( 'C' ) .or. ;
            US_Upper( US_FileNameOnlyExt( PRGFILES[i] ) ) == US_Upper( 'CPP' )
            Out := Out + PUB_cCharTab + if(! bLogActivity, '@', '') + '$(US_SHELL_EXE) ' + if(! bLogActivity, '-OFF ','') + 'COPYZAP $** $@' + Hb_OsNewLine()
         else
            Out := Out + PUB_cCharTab + if(! bLogActivity, '@', '') + '$(US_SHELL_EXE) ' + if(! bLogActivity, '-OFF ', '') + 'DELETE $@' + Hb_OsNewLine()
            Out := Out + PUB_cCharTab + '$(HARBOUR_EXE) $(HARBOUR_FLAGS) /q /p' + US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + US_FileNameOnlyName( PRGFILES[i] ) + '.ppo $** -o$@' + Hb_OsNewLine()
            Out := Out + PUB_cCharTab + if(! bLogActivity, '@', '') + '$(US_SHELL_EXE) ' + if(! bLogActivity, '-OFF ', '') + 'MOVE ' + US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + US_FileNameOnlyName( PRGFILES[i] ) + '.ppo $(DIR_OBJECTS)' + DEF_SLASH + US_FileNameOnlyName( PRGFILES[i] ) + '.ppo' + Hb_OsNewLine()
            Out := Out + PUB_cCharTab + if(! bLogActivity, '@', '') + '$(US_SHELL_EXE) ' + if(! bLogActivity, '-OFF ', '') + 'DELETE ' + US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + US_FileNameOnlyName( PRGFILES[i] ) + '.ppo.MOVED.TXT' + Hb_OsNewLine()
            Out := Out + PUB_cCharTab + if(! bLogActivity, '@', '') + '$(US_SHELL_EXE) ' + if(! bLogActivity, '-OFF ', '') + 'CHECKRC NOTFILE $@' + Hb_OsNewLine()
         endif
         Out := Out + Hb_OsNewLine()
         if IsMinGW
            Out := Out + '$(DIR_OBJECTS)' + DEF_SLASH + US_FileNameOnlyName( PRGFILES[i] ) + '.o : $(C_DIR)' + DEF_SLASH + US_FileNameOnlyName( PRGFILES[i] ) + '.' + if( upper( US_FileNameOnlyExt( PRGFILES[i] ) ) == 'CPP', 'cpp', 'c' ) + Hb_OsNewLine()
         else
            Out := Out + '$(DIR_OBJECTS)' + DEF_SLASH + US_FileNameOnlyName( PRGFILES[i] ) + '.obj : $(C_DIR)' + DEF_SLASH + US_FileNameOnlyName( PRGFILES[i] ) + '.' + if( upper( US_FileNameOnlyExt( PRGFILES[i] ) ) == 'CPP', 'cpp', 'c' ) + Hb_OsNewLine()
         endif
         Out := Out + PUB_cCharTab + '$(US_MSG_EXE) ' + PROGRESS_LOG + ' -MSG:Processing ' + US_FileNameOnlyName( PRGFILES[i] ) + '.' + if( upper( US_FileNameOnlyExt( PRGFILES[i] ) ) == 'CPP', 'cpp', 'c' ) + ' ...' + Hb_OsNewLine()
         Out := Out + PUB_cCharTab + if(! bLogActivity, '@', '') + '$(US_SHELL_EXE) ' + if(! bLogActivity, '-OFF ', '' ) + 'DELETE $@' + Hb_OsNewLine()
         do case
         case IsMinGW
            Out := Out + PUB_cCharTab + '$(DEF_SLASH)' + if( bLogActivity, ' -LIST' + US_ShortName(PUB_cQPM_Folder), '' ) + ' $(COBJFLAGS) $** -o$@' + Hb_OsNewLine()
         case IsPelles
            Out := Out + PUB_cCharTab + '$(COMPILATOR_C) $(COBJFLAGS) /Fo$@ $**' + Hb_OsNewLine()
         case IsBorland
            Out := Out + PUB_cCharTab + '$(COMPILATOR_C) $(COBJFLAGS) -o$@ $**' + Hb_OsNewLine()
         otherwise
            US_Log( 'Error 6324' )
         endcase
         Out := Out + PUB_cCharTab + if(! bLogActivity, '@', '') + '$(US_SHELL_EXE) ' + if(! bLogActivity, '-OFF ', '') + 'CHECKRC NOTFILE $@' + Hb_OsNewLine()
      Next i

   endif

   if Prj_Radio_OutputType == DEF_RG_IMPORT
      Out := Out + '$(APP_NAME) : ' + US_ShortName( PRGFILES[1] ) + Hb_OsNewLine()
      do case
         case PUB_cConvert == 'DLL A'
            if GetProperty( 'VentanaMain', 'Check_Reimp', 'Value' )
               Out := Out + PUB_cCharTab + '$(US_MSG_EXE) ' + PROGRESS_LOG + ' -MSG:ReImport From Library ' + cInputReImpNameDisplay + Hb_OsNewLine()
               Out := Out + PUB_cCharTab + '$(REIMPORT_EXE) -d ' + cInputReImpName + Hb_OsNewLine()
               Out := Out + PUB_cCharTab + '$(US_MSG_EXE) ' + PROGRESS_LOG + ' -MSG:DLL Function List for ' + cInputNameDisplay + ' ...' + Hb_OsNewLine()
               Out := Out + PUB_cCharTab + if(! bLogActivity, '@', '') + '$(US_SHELL_EXE) ' + if(! bLogActivity, '-OFF ', '') + 'ANALIZE_DLL ' + cInputReImpDef + Hb_OsNewLine()
               Out := Out + PUB_cCharTab + '$(US_MSG_EXE) ' + PROGRESS_LOG + ' -MSG:Generating Interface Library (.' + US_Word( PUB_cConvert, 2 ) + ') for ' + cInputNameDisplay + ' ...' + Hb_OsNewLine()
               Out := Out + PUB_cCharTab + '$(IMPLIB_MGW_EXE) -k -d ' + US_USlash( cInputReImpDef ) + ' -D ' + US_FileNameOnlyNameAndExt( cInputNameDisplay ) + ' -l ' + US_USlash( cOutputName ) + Hb_OsNewLine()
               Out := Out + PUB_cCharTab + if(! bLogActivity, '@', '') + '$(US_SHELL_EXE) ' + if(! bLogActivity, '-OFF ', '') + 'DELETE ' + cInputReImpDef + Hb_OsNewLine()
            else
               Out := Out + PUB_cCharTab + '$(US_MSG_EXE) ' + PROGRESS_LOG + ' -MSG:DLL Function List for ' + cInputNameDisplay + ' ...' + Hb_OsNewLine()
               Out := Out + PUB_cCharTab + '$(IMPDEF_MGW_EXE) ' + cInputNameLong + ' > ' + cInputNameLong + '.def ' + Hb_OsNewLine()
               Out := Out + PUB_cCharTab + if(! bLogActivity, '@', '') + '$(US_SHELL_EXE) ' + if(! bLogActivity, '-OFF ', '') + 'ANALIZE_DLL ' + cInputNameLong + '.def ' + Hb_OsNewLine()
               Out := Out + PUB_cCharTab + '$(US_MSG_EXE) ' + PROGRESS_LOG + ' -MSG:Generating Interface Library (.' + US_Word( PUB_cConvert, 2 ) + ') for ' + cInputNameDisplay + ' ...' + Hb_OsNewLine()
               Out := Out + PUB_cCharTab + '$(IMPLIB_MGW_EXE) -d ' + US_USlash( cInputNameLong ) + '.def -D ' + US_FileNameOnlyNameAndExt( cInputNameDisplay ) + ' -l ' + US_USlash( cOutputName ) + Hb_OsNewLine()
               Out := Out + PUB_cCharTab + if(! bLogActivity, '@', '') + '$(US_SHELL_EXE) ' + if(! bLogActivity, '-OFF ', '') + 'DELETE ' + cInputNameLong + '.def' + Hb_OsNewLine()
            endif
         case PUB_cConvert == 'DLL LIB'
            do case
               case Prj_Radio_Cpp == DEF_RG_PELLES
                  Out := Out + PUB_cCharTab + '$(US_MSG_EXE) ' + PROGRESS_LOG + ' -MSG:DLL Function List for ' + cInputNameDisplay + ' ...' + Hb_OsNewLine()
                  Out := Out + PUB_cCharTab + '$(IMPDEF_PC_EXE) ' + cInputNameLong + '.def ' + cInputNameLong + Hb_OsNewLine()
                  Out := Out + PUB_cCharTab + if(! bLogActivity, '@', '') + '$(US_SHELL_EXE) ' + if(! bLogActivity, '-OFF ', '') + 'ANALIZE_DLL ' + cInputNameLong + '.def ' + Hb_OsNewLine()
                  //
                  Out := Out + PUB_cCharTab + '$(US_MSG_EXE) ' + PROGRESS_LOG + ' -MSG:Generating Interface Library (.' + US_Word( PUB_cConvert, 2 ) + ') for ' + cInputNameDisplay + ' ...' + Hb_OsNewLine()
                  Out := Out + PUB_cCharTab + '$(IMPLIB_PC_EXE) ' + if( GetProperty( 'VentanaMain', 'Check_GuionA', 'Value' ), '', '-NOUND ' ) + cInputNameLong + ' -OUT:' + cOutputName + Hb_OsNewLine()
                  //
                  Out := Out + PUB_cCharTab + if(! bLogActivity, '@', '') + '$(US_SHELL_EXE) ' + if(! bLogActivity, '-OFF ', '') + 'DELETE ' + cInputNameLong + '.def' + Hb_OsNewLine()
               case Prj_Radio_Cpp == DEF_RG_BORLAND
                  Out := Out + PUB_cCharTab + '$(US_MSG_EXE) ' + PROGRESS_LOG + ' -MSG:DLL Function List for ' + cInputNameDisplay + ' ...' + Hb_OsNewLine()
                  Out := Out + PUB_cCharTab + '$(IMPDEF_BCC_EXE) ' + cInputNameLong + '.def ' + cInputNameLong + Hb_OsNewLine()
                  Out := Out + PUB_cCharTab + if(! bLogActivity, '@', '') + '$(US_SHELL_EXE) ' + if(! bLogActivity, '-OFF ', '') + 'ANALIZE_DLL ' + cInputNameLong + '.def ' + Hb_OsNewLine()
                  //
                  Out := Out + PUB_cCharTab + '$(US_MSG_EXE) ' + PROGRESS_LOG + ' -MSG:Generating Interface Library (.' + US_Word( PUB_cConvert, 2 ) + ') for ' + cInputNameDisplay + ' ...' + Hb_OsNewLine()
                  Out := Out + PUB_cCharTab + '$(IMPLIB_BCC_EXE) ' + if( GetProperty( 'VentanaMain', 'Check_GuionA', 'Value' ), '-a ', '' ) + cOutputName + ' ' + cInputNameLong + Hb_OsNewLine()
                  //
                  Out := Out + PUB_cCharTab + if(! bLogActivity, '@', '') + '$(US_SHELL_EXE) ' + if(! bLogActivity, '-OFF ', '') + 'DELETE ' + cInputNameLong + '.def' + Hb_OsNewLine()
               otherwise
                  US_Log( 'Error in Convert DLL to LIB, Invalid C Compiler: ' + US_VarToStr( Prj_Radio_Cpp ) )
            endcase
         case PUB_cConvert == 'LIB DLL'
            Out := Out + PUB_cCharTab + '$(US_MSG_EXE) ' + PROGRESS_LOG + ' -MSG:Copying Library (.' + US_Word( PUB_cConvert, 1 ) + ') to Working Folder' + ' ...' + Hb_OsNewLine()
            Out := Out + PUB_cCharTab + '$(US_SHELL_EXE) COPY ' + cInputName + ' ' + OBJFOLDER + DEF_SLASH + US_FileNameOnlyNameAndExt( cInputName ) + Hb_OsNewLine()
            //
            Out := Out + PUB_cCharTab + '$(US_MSG_EXE) ' + PROGRESS_LOG + ' -MSG:Listing Functions in Library (.' + US_Word( PUB_cConvert, 1 ) + ')' + ' ...' + Hb_OsNewLine()
            Out := Out + PUB_cCharTab + '$(LSTLIB_EXE) ' + OBJFOLDER + DEF_SLASH + US_FileNameOnlyNameAndExt( cInputName ) + ', ' + OBJFOLDER + DEF_SLASH + US_FileNameOnlyNameAndExt( cInputName ) + '.lst ' + Hb_OsNewLine()
            Out := Out + PUB_cCharTab + '$(US_SHELL_EXE) ANALIZE_LIB_BORLAND ' + OBJFOLDER + DEF_SLASH + US_FileNameOnlyNameAndExt( cInputName ) + '.lst ' + Hb_OsNewLine()
            //
            QPM_Execute( US_ShortName(PUB_cQPM_Folder) + DEF_SLASH + 'US_TLIB.EXE', cInputName + ', ' + OBJFOLDER + DEF_SLASH + US_FileNameOnlyNameAndExt( cInputName ) + '.lst', DEF_QPM_EXEC_WAIT, DEF_QPM_EXEC_MINIMIZE )
            QPM_Execute( US_ShortName(PUB_cQPM_Folder) + DEF_SLASH + 'US_SHELL.EXE', 'QPM ANALIZE_LIB_BORLAND ' + OBJFOLDER + DEF_SLASH + US_FileNameOnlyNameAndExt( cInputName ) + '.lst -OBJLST -EXPLST -OFF', DEF_QPM_EXEC_WAIT, DEF_QPM_EXEC_MINIMIZE )
            //
            MemoObj := MemoRead( OBJFOLDER + DEF_SLASH + US_FileNameOnlyNameAndExt( cInputName ) + '.Lst.ObjLst' )
            //
            Out := Out + PUB_cCharTab + '$(US_MSG_EXE) ' + PROGRESS_LOG + ' -MSG:Extracting Modules from Library (.' + US_Word( PUB_cConvert, 1 ) + ')' + ' ...' + Hb_OsNewLine()
            Out := Out + PUB_cCharTab + '$(TLIB_EXE) ' + OBJFOLDER + DEF_SLASH + US_FileNameOnlyNameAndExt( cInputName )
            For i:=1 to MLCount( MemoObj, 254 )
               Out := Out + PUB_cCharTab + '*' + OBJFOLDER + DEF_SLASH + alltrim( memoline( MemoObj, 254, i ) )
            next
            Out := Out + ' ' + Hb_OsNewLine()
            Out := Out + PUB_cCharTab + '$(US_MSG_EXE) ' + PROGRESS_LOG + ' -MSG:Making DLL from Modules Object of Library (.' + US_Word( PUB_cConvert, 1 ) + ') in ' + cOutputNameDisplay + ' ...' + Hb_OsNewLine()
            Out := Out + PUB_cCharTab + '$(ILINK_EXE) ' + if( !Prj_Check_Console, '-Gn -Tpd '+If(PUB_bDebugActive,'-ap ','-aa '), '-Gn -Tpd ' ) + '-L' + GetCppLibFolder()
            For i:=1 to MLCount( MemoObj, 254 )
               Out := Out + ' ' + OBJFOLDER + DEF_SLASH + alltrim( memoline( MemoObj, 254, i ) ) + '.obj'
            next
            Out := Out + ' c0d32.obj, ' + cOutputName + ',, import32.lib msimg32.lib cw32.lib, '
            Out := Out + ' ' + OBJFOLDER + DEF_SLASH + US_FileNameOnlyNameAndExt( cInputName ) + '.Lst.ExpLst' + Hb_OsNewLine()
            //
            Out := Out + PUB_cCharTab + '$(US_MSG_EXE) ' + PROGRESS_LOG + ' -MSG:DLL Function List for ' + cOutputNameDisplay + ' ...' + Hb_OsNewLine()
            Out := Out + PUB_cCharTab + '$(IMPDEF_BCC_EXE) ' + cOutputName + '.def ' + cOutputName + Hb_OsNewLine()
            Out := Out + PUB_cCharTab + if(! bLogActivity, '@', '') + '$(US_SHELL_EXE) ' + if(! bLogActivity, '-OFF ', '') + 'ANALIZE_DLL ' + cOutputName + '.def -DELETE' + Hb_OsNewLine()
            //
            Out := Out + PUB_cCharTab + '$(US_MSG_EXE) ' + PROGRESS_LOG + ' -MSG:Cleaning Temporary Files' + ' ...' + Hb_OsNewLine()
            Out := Out + PUB_cCharTab + '$(US_SHELL_EXE) DELETE ' + OBJFOLDER + DEF_SLASH + US_FileNameOnlyNameAndExt( cInputName ) + ' -OFF' + Hb_OsNewLine()
            Out := Out + PUB_cCharTab + '$(US_SHELL_EXE) DELETE ' + OBJFOLDER + DEF_SLASH + US_FileNameOnlyNameAndExt( cInputName ) + '.lst -OFF' + Hb_OsNewLine()
            For i:=1 to MLCount( MemoObj, 254 )
               Out := Out + PUB_cCharTab + '$(US_SHELL_EXE) DELETE ' + OBJFOLDER + DEF_SLASH + alltrim( memoline( MemoObj, 254, i ) ) + '.obj -OFF' + Hb_OsNewLine()
            next
            Out := Out + PUB_cCharTab + '$(US_SHELL_EXE) DELETE ' + OBJFOLDER + DEF_SLASH + US_FileNameOnlyNameAndExt( cInputName ) + '.lst.ObjLst -OFF' + Hb_OsNewLine()
            Out := Out + PUB_cCharTab + '$(US_SHELL_EXE) DELETE ' + OBJFOLDER + DEF_SLASH + US_FileNameOnlyNameAndExt( cInputName ) + '.lst.ExpLst -OFF' + Hb_OsNewLine()
         case PUB_cConvert == 'A DLL'
            Out := Out + PUB_cCharTab + '$(US_MSG_EXE) ' + PROGRESS_LOG + ' -MSG:Copying Library (.' + US_Word( PUB_cConvert, 1 ) + ') to Working Folder' + ' ...' + Hb_OsNewLine()
            Out := Out + PUB_cCharTab + '$(US_SHELL_EXE) COPY ' + cInputName + ' ' + OBJFOLDER + DEF_SLASH + US_FileNameOnlyNameAndExt( cInputName ) + Hb_OsNewLine()
            //
            Out := Out + PUB_cCharTab + '$(US_MSG_EXE) ' + PROGRESS_LOG + ' -MSG:Listing Functions in Library (.' + US_Word( PUB_cConvert, 1 ) + ')' + ' ...' + Hb_OsNewLine()
            Out := Out + PUB_cCharTab + '$(LSTA_EXE) -x ' + OBJFOLDER + DEF_SLASH + US_FileNameOnlyNameAndExt( cInputName ) + ' > ' + OBJFOLDER + DEF_SLASH + US_FileNameOnlyNameAndExt( cInputName ) + '.lst ' + Hb_OsNewLine()
            Out := Out + PUB_cCharTab + '$(US_SHELL_EXE) ANALIZE_LIB_MINGW ' + OBJFOLDER + DEF_SLASH + US_FileNameOnlyNameAndExt( cInputName ) + '.lst ' + Hb_OsNewLine()
            //
            QPM_MemoWrit( RUN_FILE, US_ShortName(PUB_cQPM_Folder) + DEF_SLASH + 'US_OBJDUMP.EXE -t ' + cInputName + ' > ' + OBJFOLDER + DEF_SLASH + US_FileNameOnlyNameAndExt( cInputName ) + '.lst' )
            QPM_Execute( RUN_FILE,, DEF_QPM_EXEC_WAIT, DEF_QPM_EXEC_MINIMIZE )
            ferase( RUN_FILE )
            QPM_Execute( US_ShortName(PUB_cQPM_Folder) + DEF_SLASH + 'US_SHELL.EXE', 'QPM ANALIZE_LIB_MINGW ' + OBJFOLDER + DEF_SLASH + US_FileNameOnlyNameAndExt( cInputName ) + '.lst -OBJLST -EXPLST', DEF_QPM_EXEC_WAIT, DEF_QPM_EXEC_MINIMIZE )
            //
            MemoObj := MemoRead( OBJFOLDER + DEF_SLASH + US_FileNameOnlyNameAndExt( cInputName ) + '.Lst.ObjLst' )
            //
            Out := Out + PUB_cCharTab + '$(US_MSG_EXE) ' + PROGRESS_LOG + ' -MSG:Extracting Modules from Library (.' + US_Word( PUB_cConvert, 1 ) + ')' + ' ...' + Hb_OsNewLine()
            Out := Out + PUB_cCharTab + '$(TLIB_EXE) x ' + OBJFOLDER + DEF_SLASH + US_FileNameOnlyNameAndExt( cInputName )
            For i:=1 to MLCount( MemoObj, 254 )
               Out := Out + ' ' + alltrim( memoline( MemoObj, 254, i ) ) + '.o'
            next
            Out := Out + ' ' + Hb_OsNewLine()
            //
            Out := Out + PUB_cCharTab + '$(US_MSG_EXE) ' + PROGRESS_LOG + ' -MSG:Making DLL from Modules Object of Library (.' + US_Word( PUB_cConvert, 1 ) + ') in ' + cOutputNameDisplay + ' ...' + Hb_OsNewLine()
            Out := Out + PUB_cCharTab + '$(ILINK_EXE) -shared -o' + cOutputName + ' '
            For i:=1 to MLCount( MemoObj, 254 )
               Out := Out + ' ' + US_ShortName( GetCppFolder() ) + DEF_SLASH + 'BIN' + DEF_SLASH + alltrim( memoline( MemoObj, 254, i ) ) + '.o '
            next
            Out := Out + if( Prj_Check_Console, ' -mconsole', ' -mwindows' ) + ;
                   ' -L$(DIR_COMPC_LIB)' + ;
                   ' -L$(DIR_MINIGUI_LIB)' + ;
                   ' -L$(DIR_HARBOUR_LIB)' + Hb_OsNewLine()
            //
            Out := Out + PUB_cCharTab + '$(US_MSG_EXE) ' + PROGRESS_LOG + ' -MSG:DLL Function List for ' + cOutputNameDisplay + ' ...' + Hb_OsNewLine()
            Out := Out + PUB_cCharTab + '$(IMPDEF_MGW_EXE) ' + cOutputName + ' > ' + cOutputName + '.def ' + Hb_OsNewLine()
            Out := Out + PUB_cCharTab + if(! bLogActivity, '@', '') + '$(US_SHELL_EXE) ' + if(! bLogActivity, '-OFF ', '') + 'ANALIZE_DLL ' + cOutputName + '.def -DELETE' + Hb_OsNewLine()
            //
            Out := Out + PUB_cCharTab + '$(US_MSG_EXE) ' + PROGRESS_LOG + ' -MSG:Cleaning Temporary Files' + ' ...' + Hb_OsNewLine()
            Out := Out + PUB_cCharTab + '$(US_SHELL_EXE) DELETE ' + OBJFOLDER + DEF_SLASH + US_FileNameOnlyNameAndExt( cInputName ) + ' -OFF' + Hb_OsNewLine()
            Out := Out + PUB_cCharTab + '$(US_SHELL_EXE) DELETE ' + OBJFOLDER + DEF_SLASH + US_FileNameOnlyNameAndExt( cInputName ) + '.lst -OFF' + Hb_OsNewLine()
            For i:=1 to MLCount( MemoObj, 254 )
               Out := Out + PUB_cCharTab + '$(US_SHELL_EXE) DELETE ' + US_ShortName( GetCppFolder() ) + DEF_SLASH + 'BIN' + DEF_SLASH + alltrim( memoline( MemoObj, 254, i ) ) + '.o -OFF' + Hb_OsNewLine()
            next
            Out := Out + PUB_cCharTab + '$(US_SHELL_EXE) DELETE ' + OBJFOLDER + DEF_SLASH + US_FileNameOnlyNameAndExt( cInputName ) + '.lst.ObjLst -OFF' + Hb_OsNewLine()
            Out := Out + PUB_cCharTab + '$(US_SHELL_EXE) DELETE ' + OBJFOLDER + DEF_SLASH + US_FileNameOnlyNameAndExt( cInputName ) + '.lst.ExpLst -OFF' + Hb_OsNewLine()
      endcase
   endif
// Out := Out + Hb_OsNewLine()

   DO EVENTS

   QPM_MemoWrit( MAKE_FILE, Out )

   ferase( cOutputName )
   ferase( cOutputName + '.MOVED' )
   ferase( cOutputName + '.MOVED.TXT' )
   ferase( US_ShortName( Prj_Text_OutputCopyMoveFolder ) + DEF_SLASH + US_FileNameOnlyNameAndExt( cOutputName ) )

   DO EVENTS

/*
 * Create BUILD.BAT
 */
   do case
   case IsMinGW
      #define BM_TEMP_RC ( DBLQT + US_FileNameOnlyPath( PRGFILES[1] ) + DEF_SLASH + '_TEMP.RC' + DBLQT )
      #define BM_TMP_ERR ( DBLQT + PUB_cProjectFolder + DEF_SLASH + '_' + PUB_cSecu + 'TEMP.ERR' + DBLQT )
      #define BM_RC_FOLD ( GetMiniGuiFolder() + DEF_SLASH + 'RESOURCES' )
      #define BM_RC_MINI ( DBLQT + BM_RC_FOLD + DEF_SLASH + cResourceFileName + '.RC' + DBLQT )
      #define BM_RCM_ERR ( "US_Res from Batch Error: Resource File Not Found: " + BM_RC_MINI )
      #define BM_RC_CONF ( DBLQT + US_FileNameOnlyPath( PRGFILES[1] ) + DEF_SLASH + GetResConfigFileName() + DBLQT )
      #define BM_RCF_ERR ( "US_Res from Batch Error: Can't create ResConfig File: " + BM_RC_CONF )
      #define BM_RC_MAIN ( DBLQT + US_FileNameOnlyPathAndName( PRGFILES[1] ) + '.RC' + DBLQT )
      #define BM_US_RES  ( DBLQT + PUB_cQPM_Folder + DEF_SLASH + 'US_Res.exe' + DBLQT + ' QPM' + if( bLogActivity, ' -LIST' + US_ShortName(PUB_cQPM_Folder), '' ) )
      #define BM_RC_MA_S ( US_ShortName( US_FileNameOnlyPathAndName( PRGFILES[1] ) + '.RC' ) )
      #define BM_RC1_SHR ( BM_RC_MA_S + '1' )
      #define BM_RC2_SHR ( BM_RC_MA_S + '2' )
      #define BM_FILLER  ( DBLQT + BM_RC_FOLD + DEF_SLASH + 'FILLER' + DBLQT )
      #define BM_CPP_BIN ( US_ShortName( GetCppFolder() + DEF_SLASH + 'BIN' ) )
      #define BM_DLLTOOL ( DBLQT + GetCppFolder() + DEF_SLASH + 'BIN' + DEF_SLASH + 'DLLTOOL.EXE' + DBLQT )
      #define BM_DLL_ERR ( "US_Res from Batch Error: DLLTOOL.EXE not found at MinGW's BIN folder" )
      #define BM_WINDRES ( DBLQT + GetCppFolder() + DEF_SLASH + 'BIN' + DEF_SLASH + 'WINDRES.EXE' + DBLQT )
      #define BM_WIN_ERR ( "US_Res from Batch Error: WINDRES.EXE not found at MinGW's BIN folder" )
      #define BM_US_MAKE ( DBLQT + PUB_cQPM_Folder + DEF_SLASH + 'US_MAKE.EXE' + DBLQT )
      #define BM_EXE     ( DBLQT + cOutputNameDisplay + DBLQT )
      #define BM_OUTPUT  ( DBLQT + Prj_Text_OutputCopyMoveFolder + DBLQT + DEF_SLASH + US_FileNameOnlyNameAndExt( cOutputName ) )

      bld_cmd := '@ECHO OFF'                                                                                                  + Hb_OsNewLine()
      if bLogActivity
      bld_cmd += 'ECHO Writing Log Activity ...'                                                                              + Hb_OsNewLine()
      endif
      bld_cmd += 'IF EXIST ' + BM_TMP_ERR  + ' DEL ' + BM_TMP_ERR  + ' > NUL'                                                 + Hb_OsNewLine()
      bld_cmd += 'IF EXIST ' + TEMP_LOG    + ' DEL ' + TEMP_LOG    + ' > NUL'                                                 + Hb_OsNewLine()
      bld_cmd += 'IF EXIST ' + SCRIPT_FILE + ' DEL ' + SCRIPT_FILE + ' > NUL'                                                 + Hb_OsNewLine()

      if Prj_Radio_OutputType != DEF_RG_IMPORT .and. ! Prj_Check_Console
      bld_cmd += 'IF EXIST ' + BM_TEMP_RC  + ' DEL ' + BM_TEMP_RC  + ' > NUL'                                                 + Hb_OsNewLine()
      bld_cmd += 'IF EXIST ' + BM_RC_CONF  + ' DEL ' + BM_RC_CONF  + ' > NUL'                                                 + Hb_OsNewLine()
      bld_cmd += 'IF EXIST ' + BM_RC1_SHR  + ' DEL ' + BM_RC1_SHR  + ' > NUL'                                                 + Hb_OsNewLine()
      bld_cmd += 'IF EXIST ' + BM_RC2_SHR  + ' DEL ' + BM_RC2_SHR  + ' > NUL'                                                 + Hb_OsNewLine()

      bld_cmd += 'IF NOT EXIST ' + BM_RC_MINI + ' ECHO ' + BM_RCM_ERR + ' > ' + BM_TMP_ERR                                    + Hb_OsNewLine()
      bld_cmd += 'ECHO #define ' + GetResConfigVarName() + ' ' + GetMiniGuiFolder() + DEF_SLASH + 'RESOURCES > ' + BM_RC_CONF + HB_OsNewLIne()
      bld_cmd += 'IF NOT EXIST ' + BM_RC_CONF + ' ECHO ' + BM_RCF_ERR + ' > ' + BM_TMP_ERR                                    + Hb_OsNewLine()

      // Generate auxiliary resource file
      bld_cmd += 'IF NOT EXIST ' + BM_RC_MAIN + ' GOTO NORC'                                                                  + Hb_OsNewLine()
      bld_cmd += BM_US_RES + ' -ONLYINCLUDE ' + BM_RC_MA_S + ' ' + BM_RC1_SHR                                                 + Hb_OsNewLine()
      bld_cmd += 'IF ERRORLEVEL = 1 GOTO ERROR'                                                                               + Hb_OsNewLine()
      bld_cmd += BM_US_RES  + ' ' + BM_RC1_SHR + ' ' + BM_RC2_SHR                                                             + Hb_OsNewLine()
      bld_cmd += 'IF ERRORLEVEL = 1 GOTO ERROR'                                                                               + Hb_OsNewLine()
      if Prj_Check_PlaceRCFirst
      bld_cmd += 'COPY /B ' + BM_RC2_SHR + ' + ' + BM_FILLER + ' + ' + BM_RC_MINI + ' ' + BM_TEMP_RC + ' > NUL'               + Hb_OsNewLine()
      else
      bld_cmd += 'COPY /B ' + BM_RC_MINI + ' + ' + BM_RC2_SHR + ' + ' + BM_FILLER + ' ' + BM_TEMP_RC + ' > NUL'               + Hb_OsNewLine()
      endif
      bld_cmd += 'GOTO NEXT'                                                                                                  + Hb_OsNewLine()
      bld_cmd += ':NORC'                                                                                                      + Hb_OsNewLine()
      bld_cmd += 'COPY /B ' + BM_RC_MINI + ' ' + BM_TEMP_RC + ' > NUL'                                                        + Hb_OsNewLine()
      endif

      bld_cmd += ':NEXT'                                                                                                      + Hb_OsNewLine()
      bld_cmd += 'SET PATH=' + BM_CPP_BIN                                                                                     + Hb_OsNewLine()
      if Prj_Radio_OutputType == DEF_RG_IMPORT
      bld_cmd += 'IF NOT EXIST ' + BM_DLLTOOL + ' ECHO ' + BM_DLL_ERR + ' > ' + BM_TMP_ERR                                    + Hb_OsNewLine()
      elseif ! Prj_Check_Console
      bld_cmd += 'IF NOT EXIST ' + BM_WINDRES + ' ECHO ' + BM_WIN_ERR + ' > ' + BM_TMP_ERR                                    + Hb_OsNewLine()
      endif

      bld_cmd += ':MAKE'                                                                                                      + Hb_OsNewLine()
      bld_cmd += BM_US_MAKE + ' ' + '-f' + MAKE_FILE + ' >> ' + TEMP_LOG + ' 2>&1'                                            + Hb_OsNewLine()

      do case
      case Prj_Radio_OutputCopyMove == DEF_RG_MOVE
      bld_cmd += 'IF EXIST ' + BM_EXE + ' GOTO ERROR'                                                                         + Hb_OsNewLine()
      bld_cmd += 'IF EXIST ' + BM_OUTPUT + ' GOTO OK'                                                                         + Hb_OsNewLine()
      case Prj_Radio_OutputCopyMove == DEF_RG_COPY
      bld_cmd += 'IF NOT EXIST ' + BM_EXE + ' GOTO ERROR'                                                                     + Hb_OsNewLine()
      bld_cmd += 'IF EXIST ' + BM_OUTPUT + ' GOTO OK'                                                                         + Hb_OsNewLine()
      otherwise
      bld_cmd += 'IF EXIST ' + BM_EXE + ' GOTO OK'                                                                            + Hb_OsNewLine()
      endcase

      bld_cmd += ':ERROR'                                                                                                     + Hb_OsNewLine()
      bld_cmd += 'IF EXIST ' + BM_TMP_ERR + ' COPY ' + BM_TMP_ERR + ' ' + TEMP_LOG + ' > NUL'                                 + Hb_OsNewLine()
      bld_cmd += 'ECHO ERROR > ' + END_FILE                                                                                   + Hb_OsNewLine()
      bld_cmd += 'GOTO END'                                                                                                   + Hb_OsNewLine()
      bld_cmd += ':OK'                                                                                                        + Hb_OsNewLine()
      bld_cmd += 'ECHO OK > ' + END_FILE                                                                                      + Hb_OsNewLine()
      bld_cmd += ':END'                                                                                                       + Hb_OsNewLine()

      if PUB_DeleteAux .and. Prj_Radio_OutputType != DEF_RG_IMPORT .and. ! Prj_Check_Console
      bld_cmd += 'IF EXIST ' + BM_TEMP_RC  + ' DEL ' + BM_TEMP_RC + ' > NUL'                                                  + Hb_OsNewLine()
      bld_cmd += 'IF EXIST ' + BM_RC_CONF  + ' DEL ' + BM_RC_CONF + ' > NUL'                                                  + Hb_OsNewLine()
      bld_cmd += 'IF EXIST ' + BM_RC1_SHR  + ' DEL ' + BM_RC1_SHR + ' > NUL'                                                  + Hb_OsNewLine()
      bld_cmd += 'IF EXIST ' + BM_RC2_SHR  + ' DEL ' + BM_RC2_SHR + ' > NUL'                                                  + Hb_OsNewLine()
      endif

      QPM_MemoWrit( BUILD_BAT, bld_cmd )
   case ( IsBorland .or. IsPelles )
      #define BO_EXE     ( DBLQT + cOutputNameDisplay + DBLQT )
      #define BO_OUTPUT  ( DBLQT + Prj_Text_OutputCopyMoveFolder + DBLQT + DEF_SLASH + US_FileNameOnlyNameAndExt( cOutputName ) )
      #define BO_CPP_BIN ( DBLQT + GetCppFolder() + DEF_SLASH + 'BIN' + DBLQT )
      #define BO_US_MAKE ( DBLQT + PUB_cQPM_Folder + DEF_SLASH + 'US_MAKE.EXE' + DBLQT )

      bld_cmd := '@ECHO OFF' + Hb_OsNewLine()
      if bLogActivity
      bld_cmd += 'ECHO Writing Log Activity ...'                                   + Hb_OsNewLine()
      endif
      bld_cmd += 'IF EXIST ' + TEMP_LOG    + ' DEL ' + TEMP_LOG + ' > NUL'         + Hb_OsNewLine()
      bld_cmd += 'IF EXIST ' + SCRIPT_FILE + ' DEL ' + TEMP_LOG + ' > NUL'         + Hb_OsNewLine()
      bld_cmd += 'PUSHD ' + BO_CPP_BIN                                             + Hb_OsNewLine()
      bld_cmd += BO_US_MAKE + ' ' + '-f' + MAKE_FILE + ' >> ' + TEMP_LOG + ' 2>&1' + Hb_OsNewLine()
      do case
      case Prj_Radio_OutputCopyMove == DEF_RG_MOVE
      bld_cmd += 'IF EXIST '     + BO_EXE +    ' GOTO ERROR'                       + Hb_OsNewLine()
      bld_cmd += 'IF EXIST '     + BO_OUTPUT + ' GOTO OK'                          + Hb_OsNewLine()
      case Prj_Radio_OutputCopyMove == DEF_RG_COPY
      bld_cmd += 'IF NOT EXIST ' + BO_EXE +    ' GOTO ERROR'                       + Hb_OsNewLine()
      bld_cmd += 'IF EXIST '     + BO_OUTPUT + ' GOTO OK'                          + Hb_OsNewLine()
      otherwise
      bld_cmd += 'IF EXIST '     + BO_EXE +    ' GOTO OK'                          + Hb_OsNewLine()
      endcase
      bld_cmd += ':ERROR'                                                          + Hb_OsNewLine()
      bld_cmd += 'ECHO ERROR > ' + END_FILE                                        + Hb_OsNewLine()
      bld_cmd += 'GOTO END'                                                        + Hb_OsNewLine()
      bld_cmd += ':OK'                                                             + Hb_OsNewLine()
      bld_cmd += 'ECHO OK > '    + END_FILE                                        + Hb_OsNewLine()
      bld_cmd += ':END'                                                            + Hb_OsNewLine()
      QPM_MemoWrit( BUILD_BAT, bld_cmd )
   otherwise
      US_Log( 'Unknown C compiler.' )
      BUILD_IN_PROGRESS := .F.
      DefinoWindowsHotKeys( .F. )
      Return .F.
   endcase

   if PUB_bLite
      VentanaLite.bStop.Enabled := .T.
   else
      VentanaMain.bStop.Enabled := .T.
   endif

   DO EVENTS

   MemoAux := memoread( PROGRESS_LOG )
   QPM_MemoWrit( PROGRESS_LOG, MemoAux + US_TimeDis( Time() ) + ' - Checking Force Recomp Modules ...' + Hb_OsNewLine() )
// For i:=1 to len( vForceRecomp )
//    MemoAux := memoread( PROGRESS_LOG )
//    QPM_MemoWrit( PROGRESS_LOG, MemoAux + US_TimeDis( Time() ) + ' - Force Recomp by #define for ' + vForceRecomp[i] + Hb_OsNewLine() )
//    ferase( GetObjFolder() + DEF_SLASH + US_FileNameOnlyName( vForceRecomp[i] ) + if( US_Upper( US_FileNameOnlyExt( vForceRecomp[i] ) ) == 'CPP', '.CPP', '.C' ) )
// Next i
   For i:=1 to GetProperty( 'VentanaMain', 'GPRGFiles', 'itemcount' )
      if GetProperty( 'VentanaMain', 'GPRGFiles', 'cell', i, NCOLPRGRECOMP ) == 'R'
         MemoAux := memoread( PROGRESS_LOG )
         QPM_MemoWrit( PROGRESS_LOG, MemoAux + US_TimeDis( Time() ) + ' - Force Recomp by User for ' + ChgPathToReal( GetProperty( 'VentanaMain', 'GPRGFiles', 'cell', i, NCOLPRGFULLNAME ) ) + Hb_OsNewLine() )
         ferase( GetObjFolder() + DEF_SLASH + US_FileNameOnlyName( GetProperty( 'VentanaMain', 'GPRGFiles', 'cell', i, NCOLPRGNAME ) ) + if( US_Upper( US_FileNameOnlyExt( GetProperty( 'VentanaMain', 'GPRGFiles', 'cell', i, NCOLPRGNAME ) ) ) == 'CPP', '.CPP', '.C' ) )
      endif
   Next i

   DO EVENTS

   QPM_Execute( BUILD_BAT, NIL, DEF_QPM_EXEC_NOWAIT, DEF_QPM_EXEC_HIDE )

Return .T.

Function QPM_Run( bWithParm )
// QPM_Run2
   Local RUNFOLDER     := alltrim(US_FileNameOnlyPath(VentanaMain.TRunProjectFolder.Value))
   Local App
   Local cParm         := ''
   Local cRunParms
   Local cOldFolder    := GetCurrentFolder()
   Local oInput        := US_InputBox():New()

   if bWaitForBuild
      do while BUILD_IN_PROGRESS
         DO EVENTS
      enddo
   endif
   if Empty( PUB_cProjectFile )
      MsgStop( 'You must save the project before running it.' )
      Return .F.
   EndIf
   if Empty( PUB_cProjectFolder ) .or. ! US_IsDirectory( PUB_cProjectFolder )
      MsgStop( DBLQT + "Project Folder" + DBLQT + " is not a valid folder:" + Hb_OsNewLine() + PUB_cProjectFolder + Hb_OsNewLine() + 'Look at tab ' + DBLQT + PagePRG + DBLQT )
      Return .F.
   endif

   if Prj_Radio_OutputCopyMove == DEF_RG_MOVE
      App := US_ShortName( Prj_Text_OutputCopyMoveFolder ) + DEF_SLASH + US_FileNameOnlyNameAndExt( GetOutputModuleName() )
   else
      App := GetOutputModuleName()
   endif
   
   If .Not. File( App )
      MsgStop ( 'Application ' + DBLQT + App + DBLQT + ' not found.' + Hb_OsNewLine() + 'You must build the project before running it.' )
   Else
      if bWithParm
//us_log( 'previo' )
         oInput:cTitulo := 'Parameters for Run Program'
         oInput:ValorInicial := GBL_cRunParm
         oInput:cLeyenda :=  'Parm:'
         oInput:nPorAlto := if( PUB_bW800, 30, 20 )
         oInput:nPorAncho := 60
         oInput:bButtonOk := .T.
         oInput:bButtonCancel := .T.
         oInput:bEscape := .T.
         oInput:DefineWindow()
         cParm := oInput:Show()
//us_log( cParm )
//us_log( valtype( cParm  ))
//       cParm := InputBox( 'Parm:', 'Parameters for Run Program', GBL_cRunParm )
//us_log( 'post' )
//us_log( empty( cParm ) )
// us_log( valtype(cParm ) )
         if !empty( cParm )
// US_LOG( 'entro en no empty' )
            GBL_cRunParm := cParm
         else
            cParm := ''
         endif
      endif
      VentanaMain.GPrgFiles.SetFocus()
      If Empty( RUNFOLDER )
         RUNFOLDER := PUB_cProjectFolder
         if PUB_bDebugActive
            if !file( PUB_cProjectFolder + DEF_SLASH + 'Init.Cld' )
               MsgInfo( 'Configuration file for debug is missing, rebuild the project with Debug option and try again.' )
               Return .F.
            Endif
         Endif
      else
         if PUB_bDebugActive
            if !file( RUNFOLDER + DEF_SLASH + 'Init.Cld' )
               if file( PUB_cProjectFolder + DEF_SLASH + 'Init.Cld' )
                  US_FileCopy( PUB_cProjectFolder + DEF_SLASH + 'Init.Cld', RUNFOLDER + DEF_SLASH + 'Init.Cld' )
               else
                  MsgInfo( 'Configuration file for debug is missing, rebuild the project with Debug option and try again.' )
                  Return .F.
               endif
            Endif
         Endif
      EndIf

      if !PUB_QPM_bHigh
         QPM_SetProcessPriority( 'HIGH' )
         if file( ErrorLogName() )
            PUB_ErrorLogTime := val( DToS( US_FileDate( ErrorLogName() ) ) + US_StrCero( US_TimeSec( US_FileTime( ErrorLogName() ) ), 5 ) )
         else
            PUB_ErrorLogTime := 0
         endif
      endif

      QPM_KillerModule := App

      SetCurrentFolder( RUNFOLDER )

      CloseDbfAutoView()
      if VentanaMain.GDbfFiles.Value > 0
         DefineRichEditForNotDbfView( 'DBF view is disable while running application !!!' )
      endif
      cRunParms := US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + '_' + PUB_cSecu + 'RUN' + US_DateTimeCen() + '.cng'
      aadd( RunControlFile, US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + '_' + PUB_cSecu + 'RCF' + US_DateTimeCen() + '.cnt' )
      QPM_MemoWrit( cRunParms, 'Run Parms for ' + App + Hb_OsNewLine() + ;
                               'COMMAND ' + App + ' ' + cParm + Hb_OsNewLine() + ;
                               'CONTROL ' + RunControlFile[ len( RunControlFile ) ] )
      QPM_MemoWrit( RunControlFile[ len( RunControlFile ) ], 'Run Control File for ' + App )
      QPM_Execute( US_ShortName( PUB_cQPM_Folder ) + DEF_SLASH + 'US_Run.exe', 'QPM ' + cRunParms )
      bRunApp := .T.
      VentanaMain.Check_DbfAutoView.Enabled := .F.

      SetCurrentFolder( cOldFolder )
   EndIf
Return .T.

Function QPM_Timer_Run()
   Local i, bLocalRun := .F.
   if bRunApp
      For i:=1 to len( RunControlFile )
         if file( RunControlFile[ i ] )
            bLocalRun := .T.
            exit
         endif
      next
      if !bLocalRun
         bRunApp := .F.
         if !QPM_bKiller .and. PUB_QPM_bHigh
            QPM_SetProcessPriority( 'NORMAL' )
         endif
         VentanaMain.Check_DbfAutoView.Enabled := .T.
         QPM_Wait( "RichEditDisplay( 'DBF', .T. )", 'Loading ...' )
         if file( ErrorLogName() )
            if PUB_ErrorLogTime < val( DToS( US_FileDate( ErrorLogName() ) ) + US_StrCero( US_TimeSec( US_FileTime( ErrorLogName() ) ), 5 ) )
            // us_log( 'displayar errorlog' )
               VentanaMain.TabFiles.Value := nPageOut
               TabChange( 'FILES' )
               MuestroErrorLog()
            endif
         endif
      endif
   endif
Return .T.

Function QPM_Timer_StatusRefresh()
   Local memotmp, lenAux
   Local Venta := if( PUB_bLite, 'VentanaLite', 'VentanaMain' )
   Local TopName
   Local OutName, estado
   Local cBaseVerVer := Replicate( '0', DEF_LEN_VER_VERSION )
   Local cBaseVerRel := Replicate( '0', DEF_LEN_VER_RELEASE )
   Local cBaseVerBui := Replicate( '0', DEF_LEN_VER_BUILD )
   Local cTopVerVer := Replicate( '9', DEF_LEN_VER_VERSION )
   Local cTopVerRel := Replicate( '9', DEF_LEN_VER_RELEASE )
   Local cTopVerBui := Replicate( '9', DEF_LEN_VER_BUILD )
   Local cLog
   If PUB_bIsProcessing
      If Empty( GetProperty( Venta, 'LStatusLabel', 'value' ) )
         SetProperty( Venta, 'LStatusLabel', 'value', 'Building ...' )
      Else
         SetProperty( Venta, 'LStatusLabel', 'value', '' )
      EndIf
      If File( END_FILE )
         PUB_bIsProcessing := .F.
         ferase( PUB_cProjectFolder + DEF_SLASH + '_' + PUB_cSecu + 'MSG.SYSIN' ) /* por si estubiera activado el proceso de stop y la compilacion cancela por error */
         if PUB_bLite
            VentanaLite.bStop.Enabled := .F.
         else
            VentanaMain.bStop.Enabled := .F.
         endif
         VentanaMain.TabFiles.Value := nPageSysout
         TabChange( 'FILES' )
         QPM_MemoWrit( TEMP_LOG, cLog := TranslateLog( MemoRead( TEMP_LOG ) ) )
         TopName       := US_FileNameOnlyName(GetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', 1, NCOLPRGNAME ))
         OutName       := US_FileNameOnlyName( GetOutputModuleName() )
         estado        := US_Word( memoread( END_FILE ), 1 )

/*
La existencia del ejecutable se hace en BUILD.BAT teniendo en cuenta el COPY/MOVE
         if estado == 'ERROR'
            if file( GetOutputModuleName()+'.MOVED.TXT' )
               estado := 'OK'
            endif
         endif
*/

         /* ini Parche para cuando el EXE esta corriendo y queremos hacer build sin modificar ningun prg */
         if mlcount( GetProperty( Venta, 'RichEditSysout', 'value' ) ) < 3 .and. ;
            US_Word( GetProperty( Venta, 'RichEditSysout', 'value' ), 1 ) == 'MAKE'
            SetProperty( Venta, 'RichEditSysout', 'value', GetProperty( Venta, 'RichEditSysout', 'value' ) + Hb_OsNewLine() + 'Fatal: Could not open ' + GetOutputModuleName() + ', (is program still running?)' )
            estado := 'ERROR'
         endif
         /* Fin Parche para cuando el EXE esta corriendo y queremos hacer build sin modificar ningun prg */

         if bAutoExit .and. ! empty( PUB_cAutoLog )
            PUB_cAutoLogTmp := MemoRead( PUB_cAutoLog )
            PUB_cAutoLogTmp += Hb_OsNewLine()
            PUB_cAutoLogTmp += 'Result: ' + estado
            if estado == 'ERROR' .or. ( ! PUB_bLogOnlyError .and. estado == 'WARNING' )
               if ! left(cLog, 1) == Hb_OsNewLine()
                  PUB_cAutoLogTmp += Hb_OsNewLine()
               endif
               PUB_cAutoLogTmp += cLog
            endif
            PUB_cAutoLogTmp += Hb_OsNewLine()
            PUB_cAutoLogTmp += Replicate( '=', 80 )
            PUB_cAutoLogTmp += Hb_OsNewLine()
            QPM_MemoWrit( PUB_cAutoLog, PUB_cAutoLogTmp )
         endif

         SetProperty( Venta, 'RichEditSysout', 'value', MemoRead( TEMP_LOG ) )
         SetProperty( Venta, 'RichEditSysout', 'CaretPos', Len( GetProperty( Venta, 'RichEditSysout', 'value' ) ) )
         if bLogActivity
            memoTMP := memoread( PUB_cQPM_Folder + DEF_SLASH + 'QPM.log' ) + Hb_OsNewLine()

            memoTMP := memoTMP + '****** ' + PUB_cProjectFolder + DEF_SLASH + '_' + PUB_cSecu + 'Progress.Log' + Hb_OsNewLine()+ Hb_OsNewLine()
            memoTMP := memoTMP + memoread( PROGRESS_LOG ) + Hb_OsNewLine()

            memoTMP := memoTMP + '****** ' + PUB_cProjectFolder + DEF_SLASH + '_' + PUB_cSecu + 'Build.Bat' + Hb_OsNewLine()+ Hb_OsNewLine()
            memoTMP := memoTMP + memoread( BUILD_BAT ) + Hb_OsNewLine()

            memoTMP := memoTMP + '****** ' + PUB_cProjectFolder + DEF_SLASH + '_' + PUB_cSecu + 'Temp.Log' + Hb_OsNewLine()
            memoTMP := memoTMP + memoread( TEMP_LOG ) + Hb_OsNewLine()

            memoTMP := memoTMP + '****** ' + PUB_cProjectFolder + DEF_SLASH + '_' + PUB_cSecu + 'Temp.Bc' + Hb_OsNewLine() + Hb_OsNewLine()
            memoTMP := memoTMP + memoread( MAKE_FILE ) + Hb_OsNewLine()

            memoTMP := memoTMP + '****** ' + PUB_cProjectFolder + DEF_SLASH + '_' + PUB_cSecu + 'Script.ld' + Hb_OsNewLine()+ Hb_OsNewLine()
            memoTMP := memoTMP + memoread( SCRIPT_FILE ) + Hb_OsNewLine()

            memoTMP := memoTMP + replicate( '<',80 ) + Hb_OsNewLine()
            memoTMP := memoTMP + replicate( '<',80 ) + Hb_OsNewLine()

            QPM_MemoWrit( PUB_cQPM_Folder + DEF_SLASH + 'QPM.log', memoTMP )
         endif

         SetProperty( Venta, 'LStatusLabel', 'value', 'Status: Idle' )
         do case
            case estado == 'OK'
               MsgOk( 'QPM (QAC based Project Manager)', 'Build Finished'+Hb_OsNewLine()+'OK', 'I', if( bBuildRun .or. !empty( Prj_ExtraRunCmdFINAL ), .T., bAutoexit ), if( bBuildRun, 2, ), if( !bBuildRun .and. empty( Prj_ExtraRunCmdFINAL ) .and. upper( OutputExt() ) == 'EXE', .T., .F. ) )
            case estado == 'WARNING'
               MsgOk( 'QPM (QAC based Project Manager)', 'Build Finished'+Hb_OsNewLine()+'with Warnings', 'W', if( bBuildRun .or. !empty( Prj_ExtraRunCmdFINAL ), .T., bAutoexit ), if( bBuildRun, 4, ), if( !bBuildRun .and. empty( Prj_ExtraRunCmdFINAL ) .and. upper( OutputExt() ) == 'EXE', .T., .F. ) )
            case estado == 'ERROR'
               MsgOk( 'QPM (QAC based Project Manager)', 'Build Finished'+Hb_OsNewLine()+'WITH ERRORS', 'E', bAutoExit )
            otherwise
               MsgOK( 'QPM (QAC based Project Manager)', 'Invalid Return Code'+Hb_OsNewLine()+'form Build Process: '+estado, 'E' )
         endcase
         RichEditDisplay( 'OUT' )

         SetProperty( Venta, 'LFull', 'FontColor', DEF_COLORGREEN )
         SetProperty( Venta, 'LFull', 'value', 'Incremental' )
         SetProperty( 'VentanaMain', 'EraseALL', 'enabled', .T. )
         SetProperty( 'VentanaMain', 'EraseOBJ', 'enabled', .T. )
         SetProperty( 'VentanaMain', 'open', 'enabled', .T. )
         SetProperty( 'VentanaMain', 'build', 'enabled', .T. )
         SetProperty( 'VentanaMain', 'BVerChange', 'enabled', .T. )
         SetProperty( 'VentanaMain', 'OverrideCompile', 'enabled', .T. )
         SetProperty( 'VentanaMain', 'OverrideLink', 'enabled', .T. )
         if Prj_Radio_OutputType == DEF_RG_EXE
            SetProperty( 'VentanaMain', 'run', 'enabled', .T. )
         endif

         DO EVENTS

         if estado == 'OK' .and. ! empty( Prj_ExtraRunCmdFINAL )
            QPM_ExecuteExtraRun()
         endif
         // ini BUG ======================================================================================
         // No pone enable el boton build
         if !GetProperty( 'VentanaMain', 'build', 'enabled' )
            SetProperty( 'VentanaMain', 'build', 'enabled', .F. )
            SetProperty( 'VentanaMain', 'build', 'enabled', .T. )
            US_Log( 'Boton Build sigue disable', .F. )
         endif
         // fin BUG ======================================================================================

         if PUB_DeleteAux
            ferase( QPM_GET_DEF )
            ferase( GetObjFolder() + DEF_SLASH + '_' + PUB_cSecu + 'QPM_gt.c' )
            ferase( GetObjFolder() + DEF_SLASH + '_' + PUB_cSecu + 'QPM_gt.cus' )
            ferase( GetObjFolder() + DEF_SLASH + '_' + PUB_cSecu + 'QPM_gt.o' )
            ferase( GetObjFolder() + DEF_SLASH + '_' + PUB_cSecu + 'QPM_gt.ppo' )
            ferase( BUILD_BAT )
            ferase( END_FILE )
            ferase( MAKE_FILE )
            ferase( PROGRESS_LOG )
            ferase( SCRIPT_FILE )
            ferase( TEMP_LOG )
            ferase( PUB_cProjectFolder + DEF_SLASH + OutName + '.exp' )
            ferase( PUB_cProjectFolder + DEF_SLASH + OutName + '.TDS' )
            ferase( PUB_cProjectFolder + DEF_SLASH + TopName + '.MAP' )
            ferase( PUB_cProjectFolder + DEF_SLASH + '_' + PUB_cSecu + 'TEMP.ERR' )
         endif

         if VentanaMain.AutoInc.Checked
            if estado == 'OK' .or. estado == 'WARNING'
               if Val( GetProperty( 'VentanaMain', 'LVerBuiNum', 'value' ) ) == val( cTopVerBui )
                  SetProperty( 'VentanaMain', 'LVerBuiNum', 'value', cBaseVerBui )
                  if Val( GetProperty( 'VentanaMain', 'LVerRelNum', 'value' ) ) == val( cTopVerRel )
                     SetProperty( 'VentanaMain', 'LVerRelNum', 'value', cBaseVerRel )
                     if Val( GetProperty( 'VentanaMain', 'LVerVerNum', 'value' ) ) == val( cTopVerVer )
                        SetProperty( 'VentanaMain', 'LVerVerNum', 'value', cBaseVerVer )
                        MsgWarn( 'Warning, Version counter limit reached ('+cTopVerVer+'.'+cTopVerRel+' build '+cTopVerBui+').  Counter reseted to '+cBaseVerVer+'.'+cBaseVerRel+' build '+cBaseVerBui )
                     else
                        SetProperty( 'VentanaMain', 'LVerVerNum', 'value', US_StrCero( Val( GetProperty( 'VentanaMain', 'LVerVerNum', 'value' ) ) + 1, DEF_LEN_VER_VERSION ) )
                        MsgWarn( 'Warning, Release counter limit reached ('+cTopVerRel+').  Release counter reseted to '+cBaseVerRel+' and Version counter  incremented by one digit.' )
                     endif
                  else
                     SetProperty( 'VentanaMain', 'LVerRelNum', 'value', US_StrCero( Val( GetProperty( 'VentanaMain', 'LVerRelNum', 'value' ) ) + 1, DEF_LEN_VER_RELEASE ) )
                     MsgWarn( 'Warning, Build counter limit reached ('+cTopVerBui+').  Build counter reseted to '+cBaseVerBui+' and Release counter incremented by one digit.' )
                  endif
               else
                  SetProperty( 'VentanaMain', 'LVerBuiNum', 'value', US_StrCero( Val( GetProperty( 'VentanaMain', 'LVerBuiNum', 'value' ) ) + 1, DEF_LEN_VER_BUILD ) )
               endif
            endif
         endif

         if ( bBuildRun .or. PUB_bForceRunFromMsgOk ) .and. ( estado == 'OK' .or. estado == 'WARNING' )
            QPM_Run( bRunParm )
         endif

         BUILD_IN_PROGRESS := .F.
         DefinoWindowsHotKeys( .F. )
      else
         lenAux := US_FileSize( PROGRESS_LOG )
         if lenAux > ProgLength
            ProgLength := lenAux
            SetProperty( Venta, 'RichEditSysout', 'value', MemoRead( PROGRESS_LOG ) )
            SetProperty( Venta, 'RichEditSysout', 'CaretPos', Len( GetProperty( Venta, 'RichEditSysout', 'value' ) ) )
         endif
      EndIf
   EndIf
Return .T.

Function QPM_CopyFile( orig, dest )

   local bError, oSaveHandler

   if file( orig )
      if file( dest )
         ferase( dest )

         if file( dest )
            Return .F.
         endif
      endif

      bError := .F.
      oSaveHandler := errorblock( { |x| break(x) } )
      BEGIN SEQUENCE
         COPY FILE ( orig ) TO ( dest )
      RECOVER
         bError := .T.
      END SEQUENCE
      errorblock( oSaveHandler )

      if ! bError .and. file( dest )
         Return .T.
      endif
   endif

Return .F.

Function QPM_RemoveFilePRG()
   Local Pos, dire, i, bBorrar := .T.
   Local item := VentanaMain.GPrgFiles.Value
   Local bTop := if( item == 1, .T., .F. )
   If VentanaMain.GPrgFiles.Value > 0
      If MyMsgYesNo( 'Remove file' + Hb_OsNewLIne() + DBLQT + ChgPathToReal( GetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', VentanaMain.GPrgFiles.Value, NCOLPRGFULLNAME ) ) + DBLQT + Hb_OsNewLine() + 'from project ?', 'Confirm' )
      // QPM_ForceRecompExclude( ChgPathToReal( GetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', VentanaMain.GPrgFiles.Value, NCOLPRGFULLNAME ) ), VentanaMain.GPrgFiles.Value )
         dire := US_FileNameOnlyPath( GetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', VentanaMain.GPrgFiles.Value, NCOLPRGFULLNAME ) )
         VentanaMain.GPrgFiles.DeleteItem( VentanaMain.GPrgFiles.Value )
         SetProperty( 'VentanaMain', 'GPrgFiles', 'tooltip', '' )
         if item > VentanaMain.GPrgFiles.ItemCount
            item := VentanaMain.GPrgFiles.ItemCount
         endif
         if GridImage( 'VentanaMain', 'GPrgFiles', item, NCOLPRGSTATUS, '?', PUB_nGridImgSearchOk )
            TotCaption( 'PRG', -1 )
         endif
         SetProperty( 'VentanaMain', 'GPrgFiles', 'value', item )
         RichEditDisplay( 'PRG' )
         Pos := AScan( vExtraFoldersForSearch, { |y| upper( US_VarToStr( y ) ) == upper( ChgPathToReal( dire ) ) } )
         For i=1 to VentanaMain.GPrgFiles.ItemCount
            if dire == US_FileNameOnlyPath( GetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', i, NCOLPRGFULLNAME ) )
               bBorrar := .F.
            endif
         next
         For i=1 to VentanaMain.GPanFiles.ItemCount
            if dire == US_FileNameOnlyPath( GetProperty( 'VentanaMain', 'GPanFiles', 'Cell', i, NCOLPANFULLNAME ) )
               bBorrar := .F.
            endif
         next
         For i=1 to VentanaMain.GDbfFiles.ItemCount
            if dire == US_FileNameOnlyPath( GetProperty( 'VentanaMain', 'GDbfFiles', 'Cell', i, NCOLDBFFULLNAME ) )
               bBorrar := .F.
            endif
         next
         For i=1 to VentanaMain.GHeaFiles.ItemCount
            if dire == US_FileNameOnlyPath( GetProperty( 'VentanaMain', 'GHeaFiles', 'Cell', i, NCOLHEAFULLNAME ) )
               bBorrar := .F.
            endif
         next
         if Pos > 0 .and. bBorrar
            adel( vExtraFoldersForSearch, Pos )
         endif
         if bTop
            CambioTitulo()
            if GetProperty( 'VentanaMain', 'GPrgFiles', 'itemcount' ) > 0
               MsgInfo( DBLQT + ChgPathToReal( GetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', 1, NCOLPRGFULLNAME ) ) + DBLQT + Hb_OsNewLine() + "is the new project's " + DBLQT + "Top File" + DBLQT + '.' )
            else
               MsgInfo( "Project's " + DBLQT + "Top File" + DBLQT + " is not defined." )
            endif
         endif
      EndIf
   EndIf
   DoMethod( 'VentanaMain', 'GPrgFiles', 'ColumnsAutoFitH' )
Return .T.

Function QPM_RemoveFileHEA()
   Local pos, dire, i, bBorrar := .T.
   Local item := VentanaMain.GHeaFiles.Value
   If VentanaMain.GHeaFiles.Value > 0
      If MyMsgYesNo( 'Remove file' + Hb_OsNewLIne() + DBLQT + ChgPathToReal( GetProperty( 'VentanaMain', 'GHeaFiles', 'Cell', VentanaMain.GHeaFiles.Value, NCOLHEAFULLNAME ) ) + DBLQT + Hb_OsNewLine() + 'from project ?', 'Confirm' )
         dire := US_FileNameOnlyPath( GetProperty( 'VentanaMain', 'GHeaFiles', 'Cell', VentanaMain.GHeaFiles.Value, NCOLHEAFULLNAME ) )
         VentanaMain.GHeaFiles.DeleteItem( VentanaMain.GHeaFiles.Value )
         SetProperty( 'VentanaMain', 'GHeaFiles', 'tooltip', '' )
         if item > VentanaMain.GHeaFiles.ItemCount
            item := VentanaMain.GHeaFiles.ItemCount
         endif
         if GridImage( 'VentanaMain', 'GHeaFiles', item, NCOLHEASTATUS, '?', PUB_nGridImgSearchOk )
            TotCaption( 'HEA', -1 )
         endif
         SetProperty( 'VentanaMain', 'GHeaFiles', 'value', item )
         RichEditDisplay( 'HEA' )
      // Pos := ascan( vExtraFoldersForSearch, ChgPathToReal( dire ) )
         Pos := AScan( vExtraFoldersForSearch, { |y| upper( US_VarToStr( y ) ) == upper( ChgPathToReal( dire ) ) } )
         For i=1 to VentanaMain.GPrgFiles.ItemCount
            if dire == US_FileNameOnlyPath( GetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', i, NCOLPRGFULLNAME ) )
               bBorrar := .F.
            endif
         next
         For i=1 to VentanaMain.GPanFiles.ItemCount
            if dire == US_FileNameOnlyPath( GetProperty( 'VentanaMain', 'GPanFiles', 'Cell', i, NCOLPANFULLNAME ) )
               bBorrar := .F.
            endif
         next
         For i=1 to VentanaMain.GDbfFiles.ItemCount
            if dire == US_FileNameOnlyPath( GetProperty( 'VentanaMain', 'GDbfFiles', 'Cell', i, NCOLDBFFULLNAME ) )
               bBorrar := .F.
            endif
         next
         For i=1 to VentanaMain.GHeaFiles.ItemCount
            if dire == US_FileNameOnlyPath( GetProperty( 'VentanaMain', 'GHeaFiles', 'Cell', i, NCOLHEAFULLNAME ) )
               bBorrar := .F.
            endif
         next
         if Pos > 0 .and. bBorrar
            adel( vExtraFoldersForSearch, Pos )
         endif
      EndIf
   EndIf
   DoMethod( 'VentanaMain', 'GHeaFiles', 'ColumnsAutoFitH' )
Return .T.

Function QPM_RemoveFilePAN()
   Local pos, dire, i, bBorrar := .T.
   Local item := VentanaMain.GPanFiles.Value
   If VentanaMain.GPanFiles.Value > 0
      If MyMsgYesNo( 'Remove file' + Hb_OsNewLIne() + DBLQT + ChgPathToReal( GetProperty( 'VentanaMain', 'GPanFiles', 'Cell', VentanaMain.GPanFiles.Value, NCOLPANFULLNAME ) ) + DBLQT + Hb_OsNewLine() + 'from project ?', 'Confirm' )
         dire := US_FileNameOnlyPath( GetProperty( 'VentanaMain', 'GPanFiles', 'Cell', VentanaMain.GPanFiles.Value, NCOLPANFULLNAME ) )
         VentanaMain.GPanFiles.DeleteItem( VentanaMain.GPanFiles.Value )
         SetProperty( 'VentanaMain', 'GPanFiles', 'tooltip', '' )
         if item > VentanaMain.GPanFiles.ItemCount
            item := VentanaMain.GPanFiles.ItemCount
         endif
         if GridImage( 'VentanaMain', 'GPanFiles', item, NCOLPANSTATUS, '?', PUB_nGridImgSearchOk )
            TotCaption( 'PAN', -1 )
         endif
         SetProperty( 'VentanaMain', 'GPanFiles', 'value', item )
         RichEditDisplay( 'PAN' )
      // Pos := ascan( vExtraFoldersForSearch, ChgPathToReal( dire ) )
         Pos := AScan( vExtraFoldersForSearch, { |y| upper( US_VarToStr( y ) ) == upper( ChgPathToReal( dire ) ) } )
         For i=1 to VentanaMain.GPrgFiles.ItemCount
            if dire == US_FileNameOnlyPath( GetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', i, NCOLPRGFULLNAME ) )
               bBorrar := .F.
            endif
         next
         For i=1 to VentanaMain.GPanFiles.ItemCount
            if dire == US_FileNameOnlyPath( GetProperty( 'VentanaMain', 'GPanFiles', 'Cell', i, NCOLPANFULLNAME ) )
               bBorrar := .F.
            endif
         next
         For i=1 to VentanaMain.GHeaFiles.ItemCount
            if dire == US_FileNameOnlyPath( GetProperty( 'VentanaMain', 'GHeaFiles', 'Cell', i, NCOLHEAFULLNAME ) )
               bBorrar := .F.
            endif
         next
         if Pos > 0 .and. bBorrar
            adel( vExtraFoldersForSearch, Pos )
         endif
      EndIf
   EndIf
   DoMethod( 'VentanaMain', 'GPanFiles', 'ColumnsAutoFitH' )
Return .T.

Function QPM_RemoveFileDBF()
   Local item := VentanaMain.GDbfFiles.Value
   If VentanaMain.GDbfFiles.Value > 0
      If MyMsgYesNo( 'Remove file' + Hb_OsNewLIne() + DBLQT + ChgPathToReal( GetProperty( 'VentanaMain', 'GDbfFiles', 'Cell', VentanaMain.GDbfFiles.Value, NCOLDBFFULLNAME ) ) + DBLQT + Hb_OsNewLine() + 'from project ?', 'Confirm' )
         VentanaMain.GDbfFiles.DeleteItem( VentanaMain.GDbfFiles.Value )
         SetProperty( 'VentanaMain', 'GDbfFiles', 'tooltip', '' )
         if item > VentanaMain.GDbfFiles.ItemCount
            item := VentanaMain.GDbfFiles.ItemCount
         endif
         if GridImage( 'VentanaMain', 'GDbfFiles', item, NCOLDBFSTATUS, '?', PUB_nGridImgSearchOk )
            TotCaption( 'DBF', -1 )
         endif
         SetProperty( 'VentanaMain', 'GDbfFiles', 'value', item )
         if item = 0
            CloseDbfAutoView()
            VentanaMain.RichEditDbf.Value := ''
         else
            RichEditDisplay( 'DBF' )
         endif
      EndIf
   EndIf
   DoMethod( 'VentanaMain', 'GDbfFiles', 'ColumnsAutoFitH' )
Return .T.

Function QPM_RemoveFileLIB()
   Local pos, dire, i, bBorrar := .T.
   Local item := VentanaMain.GIncFiles.Value
   If VentanaMain.GIncFiles.Value > 0
      If MyMsgYesNo( 'Remove file' + Hb_OsNewLIne() + DBLQT + ChgPathToReal( US_WordSubStr( GetProperty( 'VentanaMain', 'GIncFiles', 'Cell', VentanaMain.GIncFiles.Value, NCOLINCFULLNAME ), 3 ) ) + DBLQT + Hb_OsNewLine() + 'from project ?', 'Confirm' )
         dire := upper( US_FileNameOnlyPath( ChgPathToReal( US_WordSubStr( GetProperty( 'VentanaMain', 'GIncFiles', 'Cell', VentanaMain.GIncFiles.Value, NCOLINCFULLNAME ), 3 ) ) ) )
         VentanaMain.GIncFiles.DeleteItem( VentanaMain.GIncFiles.Value )
         if item > VentanaMain.GIncFiles.ItemCount
            item := VentanaMain.GIncFiles.ItemCount
         endif
         if GridImage( 'VentanaMain', 'GIncFiles', item, NCOLINCSTATUS, '?', PUB_nGridImgSearchOk )
            TotCaption( 'LIB', -1 )
         endif
         SetProperty( 'VentanaMain', 'GIncFiles', 'value', item )
         RichEditDisplay( 'INC' )
         Pos := ascan( &('vExtraFoldersForLibs'+GetSuffix()), dire )
         For i=1 to VentanaMain.GIncFiles.ItemCount
            if dire == upper( US_FileNameOnlyPath( ChgPathToReal( US_WordSubStr( GetProperty( 'VentanaMain', 'GIncFiles', 'Cell', i, NCOLINCFULLNAME ), 3 ) ) ) )
               bBorrar := .F.
            endif
         next
         if Pos > 0 .and. bBorrar
            adel( &('vExtraFoldersForLibs'+GetSuffix()), Pos )
         endif
      EndIf
   EndIf
   DoMethod( 'VentanaMain', 'GIncFiles', 'ColumnsAutoFitH' )
Return .T.

Function QPM_RemoveExcludeFileLIB()
   Local item := VentanaMain.GExcFiles.Value
   If VentanaMain.GExcFiles.Value > 0
      If MyMsgYesNo( 'Remove file' + Hb_OsNewLIne() + DBLQT + GetProperty( 'VentanaMain', 'GExcFiles', 'Cell', VentanaMain.GExcFiles.Value, NCOLEXCNAME ) + DBLQT + Hb_OsNewLine() + 'from exclude list ?', 'Confirm' )
         VentanaMain.GExcFiles.DeleteItem( VentanaMain.GExcFiles.Value )
         if item > VentanaMain.GExcFiles.ItemCount
            item := VentanaMain.GExcFiles.ItemCount
         endif
         SetProperty( 'VentanaMain', 'GExcFiles', 'value', item )
         //RichEditDisplay( 'EXC' )
      EndIf
   EndIf
   DoMethod( 'VentanaMain', 'GExcFiles', 'ColumnsAutoFitH' )
Return .T.

#ifdef QPM_SHG
Function QPM_RemoveFileHLP()
   Local nAuxRecord, item := VentanaMain.GHlpFiles.Value
   If VentanaMain.GHlpFiles.Value > 2
      If MyMsgYesNo('Remove Toppic ' + alltrim( GetProperty( 'VentanaMain', 'GHlpFiles', 'Cell', VentanaMain.GHlpFiles.Value, NCOLHLPTOPIC ) ) + ' From Help ?','Confirm')
         bHlpMoving := .T.
         nAuxRecord := VentanaMain.GHlpFiles.Value
         VentanaMain.GHlpFiles.DeleteItem( VentanaMain.GHlpFiles.Value )
         SetProperty( 'VentanaMain', 'GHlpFiles', 'tooltip', '' )
         if item > VentanaMain.GHlpFiles.ItemCount
            item := VentanaMain.GHlpFiles.ItemCount
         endif
         if GridImage( 'VentanaMain', 'GHlpFiles', item, NCOLHLPSTATUS, '?', PUB_nGridImgSearchOk )
            TotCaption( 'HLP', -1 )
         endif
         SetProperty( 'VentanaMain', 'GHlpFiles', 'value', item )
         SHG_DeleteRecord( nAuxRecord )
      // SHG_NewSecuence()
         RichEditDisplay( 'HLP' )
         bHlpMoving := .F.
      EndIf
   else
      if VentanaMain.GHlpFiles.Value == 1
         MsgInfo( "Global foot can't be edited, it's a System topic !!!" )
         Return .F.
      endif
      if VentanaMain.GHlpFiles.Value == 2
         MsgInfo( "Welcome page can't be deleted, it's a System topic !!!" )
         Return .F.
      endif
   EndIf
   DoMethod( 'VentanaMain', 'GHlpFiles', 'ColumnsAutoFitH' )
Return .T.
#endif

#ifdef QPM_SHG
Function QPM_RemoveKeyHLP()
   Local item := VentanaMain.GHlpKeys.Value, MemoAux := '', i
   If VentanaMain.GHlpKeys.Value > 0
         VentanaMain.GHlpKeys.DeleteItem( VentanaMain.GHlpKeys.Value )
         if item > VentanaMain.GHlpKeys.ItemCount
            item := VentanaMain.GHlpKeys.ItemCount
         endif
         SetProperty( 'VentanaMain', 'GHlpKeys', 'value', item )
         For i:=1 to VentanaMain.GHlpKeys.ItemCount
            MemoAux := MemoAux + if( i > 1, Hb_OsNewLine(), '' ) + VentanaMain.GHlpKeys.Cell( i, 1 )
         Next
         SHG_SetField( 'SHG_KEYST', VentanaMain.GHlpFiles.Value, MemoAux )
   EndIf
   DoMethod( 'VentanaMain', 'GHlpKeys', 'ColumnsAutoFitH' )
Return .T.
#endif

Function LibInfo()
   Local a, b, c
   If VentanaMain.GIncFiles.Value > 0
      a:='Library name: ' + US_FileNameOnlyNameAndExt( ChgPathToReal( US_WordSubStr( GetProperty( 'VentanaMain', 'GIncFiles', 'Cell', VentanaMain.GIncFiles.Value, NCOLINCFULLNAME ), 3 ) ) )
      b:='   in Folder: ' + US_FileNameOnlyPath( ChgPathToReal( US_WordSubStr( GetProperty( 'VentanaMain', 'GIncFiles', 'Cell', VentanaMain.GIncFiles.Value, NCOLINCFULLNAME ), 3 ) ) )
      c:='Concatenated ' + if( US_Upper( us_word( GetProperty( 'VentanaMain', 'GIncFiles', 'Cell', VentanaMain.GIncFiles.Value, NCOLINCFULLNAME ), 2 ) ) == '*FIRST*', 'BEFORE MiniGui library', 'AFTER last significant library' )
      MsgInfo( a + Hb_OsNewLine() + ;
               b + Hb_OsNewLine() + ;
               ' ' + Hb_OsNewLine() + ;
               c + Hb_OsNewLine() + ;
               'Status: ' + LibCheck( VentanaMain.GIncFiles.Value ) )
   endif
Return .T.

Function LibExcludeInfo()
   Local a, c
   If VentanaMain.GExcFiles.Value > 0
      a:='Library name: ' + GetProperty( 'VentanaMain', 'GExcFiles', 'Cell', VentanaMain.GExcFiles.Value, NCOLEXCNAME )
      c:='Will be EXCLUDE of Library Concatenated'
      MsgInfo( a + Hb_OsNewLine() + ;
               ' ' + Hb_OsNewLine() + ;
               c )
   endif
Return .T.

Function DefinoWindowsHotKeys( w_foco )
   LiberoWindowsHotKeys( w_foco )
   If w_foco
     MAIN_HAS_FOCUS := .T.
   EndIf
   If MAIN_HAS_FOCUS
     ON KEY F1 OF VentanaMain ACTION US_DisplayHelpTopic( GetActiveHelpFile(), 1 )
     ON KEY F2 OF VentanaMain ACTION QPM_OpenProject()
     ON KEY F3 OF VentanaMain ACTION QPM_SaveProject()
     ON KEY F4 OF VentanaMain ACTION QPM_Build()
     If ! BUILD_IN_PROGRESS .and. Prj_Radio_OutputType == DEF_RG_EXE
        ON KEY F5 OF VentanaMain ACTION QPM_Run( bRunParm )
     EndIf
     ON KEY F10 OF VentanaMain ACTION QPM_Exit( .T. )
   EndIf
Return .T.

Function LiberoWindowsHotKeys( w_foco )
   RELEASE KEY F1 OF VentanaMain
   RELEASE KEY F2 OF VentanaMain
   RELEASE KEY F3 OF VentanaMain
   RELEASE KEY F4 OF VentanaMain
   RELEASE KEY F5 OF VentanaMain
   RELEASE KEY F10 OF VentanaMain
   If w_foco
     MAIN_HAS_FOCUS := .F.
   EndIf
Return .T.

Function TranslateLog( Log )
   Local NewLog, i, e, w
   Local msg          := PUB_cCharTab + US_ShortName(PUB_cQPM_Folder) + DEF_SLASH + 'US_MSG.EXE ' + PROGRESS_LOG + ' -MSG:'
   Local harbour      := US_ShortName(GetHarbourFolder()) + DEF_SLASH + 'BIN' + DEF_SLASH + 'HARBOUR.EXE'
   Local pocc         := US_ShortName(GetCppFolder()) + DEF_SLASH + 'BIN' + DEF_SLASH + 'POCC.EXE'
   Local bcc32        := US_ShortName(GetCppFolder()) + DEF_SLASH + 'BIN' + DEF_SLASH + 'BCC32.EXE'
   Local brc32        := US_ShortName(GetCppFolder()) + DEF_SLASH + 'BIN' + DEF_SLASH + 'BRC32.EXE'
   Local ilink32      := US_ShortName(GetCppFolder()) + DEF_SLASH + 'BIN' + DEF_SLASH + 'ILINK32.EXE'
   Local windres      := US_ShortName(GetCppFolder()) + DEF_SLASH + 'BIN' + DEF_SLASH + 'WINDRES.EXE'
   Local dlltool      := US_ShortName(GetCppFolder()) + DEF_SLASH + 'BIN' + DEF_SLASH + 'DLLTOOL.EXE'
   Local slash        := US_ShortName(PUB_cQPM_Folder) + DEF_SLASH + 'US_SLASH.EXE QPM'
   Local slashlist    := US_ShortName(PUB_cQPM_Folder) + DEF_SLASH + 'US_SLASH.EXE QPM -LIST' + US_ShortName(PUB_cQPM_Folder)
   Local upx          := US_ShortName(PUB_cQPM_Folder) + DEF_SLASH + 'US_UPX.EXE'
   Local shellCZ      := US_ShortName(PUB_cQPM_Folder) + DEF_SLASH + 'US_SHELL.EXE QPM COPYZAP '
   Local shellMZ      := US_ShortName(PUB_cQPM_Folder) + DEF_SLASH + 'US_SHELL.EXE QPM MOVEZAP '
   Local shell        := US_ShortName(PUB_cQPM_Folder) + DEF_SLASH + 'US_SHELL.EXE QPM '
   Local implib       := US_ShortName(PUB_cQPM_Folder) + DEF_SLASH + 'US_IMPLIB.EXE'
   Local implibPelles := US_ShortName(PUB_cQPM_Folder) + DEF_SLASH + 'US_POLIB.EXE'
   Local impdef       := US_ShortName(PUB_cQPM_Folder) + DEF_SLASH + 'US_IMPDEF.EXE'
   Local PExports     := US_ShortName(PUB_cQPM_Folder) + DEF_SLASH + 'US_PEXPORTS.EXE'
   Local Make         := 'MAKE Version 5.2  Copyright (c) 1987, 2000 Borland' + Hb_OsNewLine()
   Local ImpLibBor    := Hb_OsNewLine() + 'Borland Implib Version 3.0.22 Copyright (c) 1991, 2000 Inprise Corporation' + Hb_OsNewLine()
   Local ImpDefBor    := Hb_OsNewLine() + 'Borland Impdef Version 3.0.22 Copyright (c) 1991, 2000 Inprise Corporation' + Hb_OsNewLine()
   Local reimp        := US_ShortName(PUB_cQPM_Folder) + DEF_SLASH + 'US_REIMP.EXE'
//   Local myredir      := US_ShortName(PUB_cQPM_Folder) + DEF_SLASH + 'US_REDIR.EXE' + PUB_cUS_RedirOpt + TEMP_LOG + ' '
   Local QPM_Ver      := '/D__QPM_VERSION__="' + "'" + QPM_VERSION_NUMBER_SHORT + "'" + '" '
   Local PRJ_Ver      := '/D__PRJ_VERSION__="' + "'" + cPrj_Version + "'" + '" '
   Local PRJ_Folder   := '/D__PROJECT_FOLDER__="' + "'" + VentanaMain.TProjectFolder.Value + "'" + '" '
   Local cEcho2       := '>> ' + SCRIPT_FILE
   Local cEcho        := '> ' + SCRIPT_FILE
   Local cDelete      := '** error 1 ** '
                          /* Texto,  Position ( 0=Cualquiera ), Producto */
   Local vWarnings := { { ') Warning W',                                0, DefineXHarbour }, ; // Warning en Compilaciones
                        { 'Warning W',                                  1, 'CBORLAND' }, ;     // Warning en funcion C
                        { ': warning: ',                                0, 'CMINGW' }, ;       // Warning en funcion C
                        { ': No such file or directory',                0, 'RMINGW' }, ;       // Warning en Resource Compiler (include not found)
                        { 'Duplicate resource:',                        1, 'RBORLAND' }, ;     // Warning en Resource Compiler
                        { 'warning: ',                                  1, 'LNKBORLAND' }, ;   // Warning en Linkeditor de Borland (No recuerdo si aparecia en minuscula por eso lo agrego
                        { 'Warning: ',                                  1, 'LNKBORLAND' }, ;   // Warning en Linkeditor o TLIB de Borland
                        { 'POLIB: warning: ',                           1, 'LIBPELLES' }, ;    // Warning en creacion de libreria Pelles C
                        { 'POLINK: warning: ',                          1, 'LNKPELLES' } ;     // Warning en Linkeditor de Pelles C
                      }
   Local vErrors   := { { '** error 1 **',                              1, 'LNKMINGW' }, ;     // Error en linkedicion MinGW
                        { '** error 2 **',                              1, 'LNKBORLAND' }, ;   // Error en Linkeditor de Borland
                        { 'Error: Unresolved external',                 1, 'LNKBORLAND' }, ;   // Error en Linkeditor de Borland
                        { 'Fatal: Access violation.  Link terminated.', 1, 'LNKBORLAND' }, ;   // Error en Linkeditor de Borland
                        { 'Fatal: Could not open',                      1, 'LNKBORLAND' }, ;   // Error en Linkeditor de Borland
                        { 'POLIB: error: ',                             1, 'LIBPELLES' }, ;    // Error en Libreria de Pelles C
                        { 'POLINK: error: ',                            1, 'LNKPELLES' }, ;    // Error en Linkeditor de Pelles C
                        { 'POLINK: fatal error: ',                      1, 'LNKPELLES' }, ;    // Error en Linkeditor de Pelles C
                        { 'Packed 0 files.',                            1, 'UPX' }, ;          // Error en UPX
                        { 'Packed 1 file: 0 ok, 1 error.',              1, 'UPX' } ;           // Error en UPX
                      }
   VentanaMain.RichEditSysout.Value := VentanaMain.RichEditSysout.Value + Hb_OsNewLine() + US_TimeDis( Time() ) + ' - >>>>>>> Reading Process Output ...'
   VentanaMain.RichEditSysout.SetFocus()
   VentanaMain.RichEditSysout.CaretPos := Len( VentanaMain.RichEditSysout.Value )
   NewLog := StrTran( Log,    chr(13) + chr(13), Hb_OsNewLine() )
//   NewLog := StrTran( NewLog, myredir,           If( bLogActivity, 'Sysout MinGW Family to ' + TEMP_LOG + Hb_OsNewLine(), '' ) )
   NewLog := StrTran( NewLog, Make,              '' )
   NewLog := StrTran( NewLog, msg,               Hb_OsNewLine() + '==> ' )
   NewLog := StrTran( NewLog, slashlist,         'GCC' )
   NewLog := StrTran( NewLog, slash,             'GCC' )
   NewLog := StrTran( NewLog, bcc32,             'BCC32' )
   NewLog := StrTran( NewLog, brc32,             'BRC32' )
   NewLog := StrTran( NewLog, ilink32,           'ILINK32' )
   NewLog := StrTran( NewLog, windres,           'WINDRES' )
   NewLog := StrTran( NewLog, pocc,              'POCC' )
   NewLog := StrTran( NewLog, shellCZ,           'COPY -z' )
   NewLog := StrTran( NewLog, shellMZ,           'MOVE -z' )
   NewLog := StrTran( NewLog, shell,             '' )
   NewLog := StrTran( NewLog, harbour,           'HARBOUR' )
   NewLog := StrTran( NewLog, upx,               'UPX' )
   NewLog := StrTran( NewLog, implib,            "GENERATE 'LIB'" )
   NewLog := StrTran( NewLog, implibPelles,      "GENERATE 'LIB'" )
   NewLog := StrTran( NewLog, impdef,            "LIST 'DLL'" )
   NewLog := StrTran( NewLog, reimp,             'ReIMPORT ' )
   NewLog := StrTran( NewLog, dlltool,           "GENERATE 'A'" )
   NewLog := StrTran( NewLog, PExports,          "LIST 'DLL'" )
   NewLog := StrTran( NewLog, cEcho2,            '' )
   NewLog := StrTran( NewLog, cEcho,             '' )
   NewLog := StrTran( NewLog, ImpLibBor,         '' )
   NewLog := StrTran( NewLog, ImpDefBor,         '' )
   NewLog := StrTran( NewLog, '_Temp.RC:',       US_FileNameOnlyName( GetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', 1, NCOLPRGFULLNAME ) ) + '.RC:' )
   NewLog := StrTran( NewLog, QPM_Ver,           '' )
   NewLog := StrTran( NewLog, PRJ_Ver,           '' )
   NewLog := StrTran( NewLog, PRJ_Folder,        '' )
   NewLog := StrTran( NewLog, cDelete,           '' )
   NewLog := StrTran( NewLog, '   -o',           ' -o' )
   NewLog := StrTran( NewLog, ' -o',             '  -o' )
   NewLog := StrTran( NewLog, '  -o ',           ' -o ' )
   If US_Word( memoread( END_FILE ), 1 ) == 'OK'
      For w := 1 to len( vWarnings )
         If At( vWarnings[w][1], NewLog ) > 0
            QPM_MemoWrit( END_FILE, 'WARNING' )
            Exit
         Endif
      Next
   EndIf
   If !( US_Word( MemoRead( END_FILE ), 1 ) == 'ERROR' )
      For e := 1 To Len( vErrors )
         If At( vErrors[e][1], NewLog ) > 0
            QPM_MemoWrit( END_FILE, 'ERROR' )
            Exit
         EndIf
      Next
   EndIf
   NewLog := StrTran( NewLog, Hb_OsNewLine(),                  chr(255) )
   NewLog := StrTran( NewLog, chr(13),                         Hb_OsNewLine() )
   NewLog := StrTran( NewLog, Hb_OsNewLine(),                  chr(255) )
   NewLog := StrTran( NewLog, chr(10),                         Hb_OsNewLine() )
   NewLog := StrTran( NewLog, chr(255),                        Hb_OsNewLine() )
   NewLog := StrTran( NewLog, Hb_OsNewLine() + Hb_OsNewLine(), Hb_OsNewLine() )
   NewLog := StrTran( NewLog, Hb_OsNewLine() + Hb_OsNewLine(), Hb_OsNewLine() )
   NewLog := StrTran( NewLog, Hb_OsNewLine(),                  Hb_OsNewLine() + PUB_cCharTab )
   NewLog := StrTran( NewLog, PUB_cCharTab + PUB_cCharTab,     PUB_cCharTab )
   NewLog := StrTran( NewLog, PUB_cCharTab + '==> ',           '==> ' )
   If Left( NewLog, Len( Hb_OsNewLine() ) ) == Hb_OsNewLine()
      NewLog := Substr( NewLog, Len( Hb_OsNewLine() ) + 1 )
   EndIf
   NewLog := StrTran( NewLog, '==> ', Hb_OsNewLine() + '==> ' )
   i := 1
   Do While (e := At( ') Error E', SubStr( NewLog, i ) ) ) > 0
      w := RAt( PUB_cCharTab, Left( NewLog, i - 1 + e ) )
      NewLog := Left( NewLog, w - 1 ) + PUB_cCharTab + PUB_cCharTab + SubStr( NewLog, w + 1 )
      i := i + e + 8
   EndDo
   i := 1
   Do While (e := At( ') Warning W', SubStr( NewLog, i ) ) ) > 0
      w := RAt( PUB_cCharTab, Left( NewLog, i - 1 + e ) )
      NewLog := Left( NewLog, w - 1 ) + PUB_cCharTab + PUB_cCharTab + SubStr( NewLog, w + 1 )
      i := i + e + 10
   EndDo
   If Right( NewLog, 1 ) == PUB_cCharTab
      NewLog := Left( NewLog, Len( NewLog ) - 1 )
   EndIf
   NewLog := StrTran( NewLog, Hb_OsNewLine() + PUB_cCharTab, Hb_OsNewLine() + '    ' )
   NewLog := StrTran( NewLog, PUB_cCharTab, '   ' )
Return NewLog

Function SwitchAutoInc()
   VentanaMain.AutoInc.Checked := ! VentanaMain.AutoInc.Checked
   QPM_SetResumen()
Return .T.

Function SwitchDebug()
   if Empty( PUB_cProjectFolder ) .or. ! US_IsDirectory( PUB_cProjectFolder )
      MsgStop( DBLQT + "Project Folder" + DBLQT + " is not a valid folder:" + Hb_OsNewLine() + PUB_cProjectFolder + Hb_OsNewLine() + 'Look at tab ' + DBLQT + PagePRG + DBLQT )
      Return .F.
   endif
   if VentanaMain.GPrgFiles.ItemCount == 0
      MsgInfo( "Can't switch debug flag when " + DBLQT + "Sources" + DBLQT + "list is empty." + Hb_OsNewLine() + "Look at tab " + DBLQT + PagePRG + DBLQT )
      Return .F.
   endif
   IF PUB_bDebugActive == .T.
      PUB_bDebugActive          := .F.
      VentanaMain.Debug.Checked := .F.
   Else
      PUB_bDebugActive          := .T.
      VentanaMain.Debug.Checked := .T.
   EndIf
   EraseOBJ()
   if PUB_bLite
      VentanaLite.LFull.FontColor := DEF_COLORRED
      VentanaLite.LFull.Value     := 'Force non-incremental'
   else
      VentanaMain.LFull.FontColor := DEF_COLORRED
      VentanaMain.LFull.Value     := 'Force non-incremental'
   endif
   QPM_SetResumen()
Return .T.

Function ClearLog()
   ferase( PUB_cQPM_Folder + DEF_SLASH + 'QPM.LOG' )
Return .T.

Function FormToolCheck( tool )
   Local FileName
   do case
   case tool == 'HMI'
      If !Empty( FileName := BugGetFile( { {'IDE+ by Ciro (MGIde.exe or oIDE*.exe)','MGIde.exe;oIDE*.exe'} }, 'Select Form Tool', US_FileNameOnlyPath( GetProperty( 'WinGSettings', 'Text_HMI', 'value' ) ), .F., .T. ) )
         SetProperty( 'WinGSettings', 'Text_HMI', 'value', FileName )
      endif
   case tool == 'HMGSIDE'
      If !Empty( FileName := BugGetFile( { {'HMGS-IDE by Walter (HMGSIDE.exe or IDE.exe)','HMGSIDE.exe;IDE.exe'} }, 'Select Form Tool', US_FileNameOnlyPath( GetProperty( 'WinGSettings', 'Text_HMGSIDE', 'value' ) ), .F., .T. ) )
         SetProperty( 'WinGSettings', 'Text_HMGSIDE', 'value', FileName )
      endif
   otherwise
      MsgStop( 'Tool inválida en función FormToolCheck: '+tool )
   endcase
Return .T.

Function cFormTool()
   Local cRet
   do case
   case Prj_Radio_FormTool == DEF_RG_EDITOR
      cRet := 'EDITOR'
   case Prj_Radio_FormTool == DEF_RG_HMI
      cRet := 'HMI'
   case Prj_Radio_FormTool == DEF_RG_HMGS
      cRet := 'HMGSIDE'
   otherwise
      cRet := 'ERROR'
   endcase
Return cRet

Function cDbfTool()
   Local cRet
   if Prj_Radio_DbfTool == DEF_RG_DBFTOOL
      cRet := 'DBFVIEW'
   else
      cRet := 'OTHER'
   endif
Return cRet

Function cOutputCopyMove()
   Local cRet
   do case
   case Prj_Radio_OutputCopyMove == DEF_RG_NONE
      cRet := 'NONE'
   case Prj_Radio_OutputCopyMove == DEF_RG_COPY
      cRet := 'COPY'
   case Prj_Radio_OutputCopyMove == DEF_RG_MOVE
      cRet := 'MOVE'
   otherwise
      cRet := 'ERROR'
   endcase
Return cRet

Function cOutputRename()
   Local cRet
   do case
   case Prj_Radio_OutputRename == DEF_RG_NONE
      cRet := 'NONE'
   case Prj_Radio_OutputRename == DEF_RG_NEWNAME
      cRet := 'NEWNAME'
   otherwise
      cRet := 'ERROR'
   endcase
Return cRet

Function cOutputType()
   Local cRet
   do case
   case Prj_Radio_OutputType == DEF_RG_EXE
      cRet := 'SRCEXE'
   case Prj_Radio_OutputType == DEF_RG_LIB
      cRet := 'SRCLIB'
   case Prj_Radio_OutputType == DEF_RG_IMPORT
      cRet := 'DLLLIB'
   otherwise
      cRet := 'ERROR'
   endcase
Return cRet

Function ActOutputTypeSet()
   do case
      case Prj_Radio_OutputType == DEF_RG_EXE
         bBuildRun := bBuildRunBack
         SetProperty( 'VentanaMain', 'bDropDownBandR', 'enabled', .T. )
         SetProperty( 'VentanaMain', 'run', 'enabled', .T. )
         DefinoWindowsHotKeys( .F. )
      case Prj_Radio_OutputType == DEF_RG_LIB
         bBuildRunBack := bBuildRun
         bBuildRun := .F.
         SetProperty( 'VentanaMain', 'bDropDownBandR', 'enabled', .F. )
         SetProperty( 'VentanaMain', 'run', 'enabled', .F. )
         DefinoWindowsHotKeys( .F. )
      case Prj_Radio_OutputType == DEF_RG_IMPORT
         bBuildRunBack := bBuildRun
         bBuildRun := .F.
         SetProperty( 'VentanaMain', 'bDropDownBandR', 'enabled', .F. )
         SetProperty( 'VentanaMain', 'run', 'enabled', .F. )
         DefinoWindowsHotKeys( .F. )
   endcase
Return .T.

Function MainInitAutoRun()
   Local i, bError := .F.
#ifdef QPM_HOTRECOVERY
   QPM_HR_Database := PUB_cQPM_Folder + DEF_SLASH + 'QPM_HotRecovery_' + QPM_VERSION_NUMBER_LONG + '.dbf'
   if !PUB_bLite
      if !file( QPM_HR_Database )
         QPM_Wait( 'QPM_HotRecovery_Migrate()', 'Creating or Migrating Hot Recovery Version database from previous releases ...' )
         MsgInfo( 'Migration finished.' )
      else
         QPM_Wait( 'HotRecoveryDatabaseCompatibility( QPM_HR_Database )', 'Checking Compatibility on Hot Recovery Versions Database' )
      endif
   endif
#endif
   if PUB_bLite
      VentanaLite.bStop.Enabled := .F.
      VentanaMain.Hide()
      VentanaLite.Activate()
      DoMethod( 'VentanaMain', 'Release' )
   else
      VentanaMain.bStop.Enabled := .F.
      if len( PUB_vAutoRun ) > 0
         For i = 1 to len( PUB_vAutoRun )
            if !eval( {|| &( PUB_vAutoRun[ i ] ) } )
               bError := .T.
               exit
            endif
         next
         if bError .and. bAutoExit
            bWaitForBuild := .F.
            QPM_Exit()
         EndIf
      EndIf
   endif
Return .T.

Function HideInitAutoRun()
   Local i, bError := .F.
   if len( PUB_vAutoRun ) > 0
      For i = 1 to len( PUB_vAutoRun )
     //  eval( {|| &( PUB_vAutoRun[ i ] ) } )
         if !eval( {|| &( PUB_vAutoRun[ i ] ) } )
       //   Return .F.
            bError := .T.
            exit
         endif
      next
      if bError .and. bAutoExit
         bWaitForBuild := .F.
         QPM_Exit()
      EndIf
   EndIf
Return .T.

Function EnableButtonRun()
   if bWaitForBuild
      do while BUILD_IN_PROGRESS
         DO EVENTS
      enddo
   endif
   SetProperty( 'VentanaLite', 'Label_3', 'enabled', .T. )
   SetProperty( 'VentanaLite', 'BRunP', 'enabled', .T. )
   SetProperty( 'VentanaLite', 'BRun', 'enabled', .T. )
   ON KEY ESCAPE OF VentanaLite ACTION DoMethod( 'VentanaLite', 'release' )
Return .T.

Function xRefPrgFmg( vConcatIncludeHB )
   Local f, p, Fol := PUB_cProjectFolder+DEF_SLASH, MemoAux, i
   Local vScanned := {}, vPRGFiles := {}, vPANFiles := {}
   MemoAux := memoread( PROGRESS_LOG )
   QPM_MemoWrit( PROGRESS_LOG, MemoAux + US_TimeDis( Time() ) + ' - Checking cross references between PRG files and FMG files ...' + Hb_OsNewLine() )
   if bLogActivity
      QPM_MemoWrit( PUB_cQPM_Folder + DEF_SLASH + 'QPM.log', memoread( PUB_cQPM_Folder + DEF_SLASH + 'QPM.log' ) + Hb_OsNewLine() + 'xRefPrgFmg Initialize' )
   endif
   For f:=1 to VentanaMain.GPanFiles.itemcount
      aadd( vPANFiles, ChgPathToReal( GetProperty( 'VentanaMain', 'GPanFiles', 'Cell', f, NCOLPANFULLNAME ) ) )
   Next f
   For f:=1 to len( vPanFiles )
      For i:=1 to len( vConcatIncludeHB )
         if file( vConcatIncludeHB[i]+DEF_SLASH+US_FileNameOnlyNameAndExt( vPanFiles[f] ) )
            if !( US_Upper( US_ShortName( vConcatIncludeHB[i]+DEF_SLASH+US_FileNameOnlyNameAndExt( vPanFiles[f] ) ) ) == US_Upper( US_ShortName( vPanFiles[f] ) ) )
               MsgWarn( 'In Folder '+vConcatIncludeHB[i]+' exists the Form '+US_FileNameOnlyNameAndExt( vPanFiles[f] ) + Hb_OsNewLine() + ;
                        "Harbour's search process will locate THIS Form first," + Hb_OsNewLine() + ;
                        'then the form in '+US_FileNameOnlyPath( vPanFiles[f] ) +' will be ignored.' )
            else
               exit
            endif
         endif
      Next i
   Next f
   For f:=1 to VentanaMain.GPrgFiles.itemcount
      aadd( vPRGFiles, ChgPathToReal( GetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', f, NCOLPRGFULLNAME ) ) )
   Next f
   /* Nota: Lo referido a vSinLoadWindow y vXRefPrgFmg puede ser eliminado, si eso ocurre, provocamos que en cada BUILD se */
   /*       scaneen los PRG que no tienen LOAD WINDOW, enlenteciendo el proceso                                            */
   /*       Si se usa -BUILD como parametro no tiene ninguna implicancia ya que actúa despues de la primera pasada         */
   For f:=1 to len( vPANFiles )
      For p:=1 to len( vPRGFiles )
         if ascan( vSinLoadWindow, { |y| US_Upper( US_VarToStr( y ) ) == US_Upper( vPRGFiles[ p ] ) } ) == 0                // a nivel programa
            if ascan( vScanned, { |y| US_Upper( US_VarToStr( y ) ) == US_Upper( vPRGFiles[ p ] ) } ) == 0                   // a nivel funcion
               if US_FileDateTime( vPANFiles[ f ] ) > US_FileDateTime( Fol + GetObjName() + DEF_SLASH + US_FileNameOnlyName( vPRGFiles[ p ] ) + '.c' )
                  // el primer ascan hace una comparacion parcial ( = ) y se le añade un blanco al final para que solo encuentre palabras completas
                  // el segundo ascan hace una comparacion total ( == ) del string (son dos palabras)
                  // El vector contiene 'myPRG myFmg'
                  if ( AScan( vXRefPrgFmg, { |x| US_Upper( US_VarToStr( x ) ) = US_Upper( US_FileNameOnlyNameAndExt( vPrgFiles[ p ] ) ) + ' ' } ) = 0 .or. ;
                     AScan( vXRefPrgFmg, { |x| US_Upper( US_VarToStr( x ) ) == US_Upper( US_FileNameOnlyNameAndExt( vPrgFiles[ p ] ) ) + ' ' + US_Upper( US_FileNameOnlyNameAndExt( vPanFiles[ f ] ) ) } ) > 0 )
                     if !( FMG_Scan( vPRGFiles[ p ], US_FileDateTime( Fol + GetObjName() + DEF_SLASH + US_FileNameOnlyName( vPRGFiles[ p ] ) + '.c' ), vScanned, vPanFiles ) )
                        AADD( vSinLoadWindow, US_Upper( vPRGFiles[ p ] ) ) // Para Control de Programa desde segunda pasada hasta que se vuele a ingresar
                        if bLogActivity
                           QPM_MemoWrit( PUB_cQPM_Folder+DEF_SLASH + 'QPM.log', memoread( PUB_cQPM_Folder+DEF_SLASH + 'QPM.log' ) + Hb_OsNewLine() + "xRefPrgFmg Add file '" + vPRGFiles[ p ] + "' to vSinLoadWindow" )
                        endif
                     endif
                  endif
               endif
            endif
         endif
      next
   next
Return .T.

Function FMG_Scan( cFileIn, DateTimeOfC, vScanned, vPanFiles )
   Local hFiIn, i, cLinea:='', vFines := { chr(13) + chr(10), Chr(10) }, bLoadWindow := .F.
   Local vAux := {}
   Local cFilePrgAux := US_Upper( US_FileNameOnlyNameAndExt( cFileIn ) )
   if bLogActivity
      QPM_MemoWrit( PUB_cQPM_Folder + DEF_SLASH + 'QPM.log', memoread( PUB_cQPM_Folder + DEF_SLASH + 'QPM.log' ) + Hb_OsNewLine() + "xRefPrgFmg Scan file '" + cFileIn + "'" )
   endif
   QPM_MemoWrit( PROGRESS_LOG, memoread( PROGRESS_LOG ) + US_TimeDis( Time() ) + ' - ' + 'Scanning: '+cFileIn + Hb_OsNewLine() )
   /* limpio las ocurrencias del prg */
   For i:=1 to len( vXRefPrgFmg )
      if !( US_Word( vXRefPrgFmg[i], 1 ) == cFilePrgAux )
         AADD( vAux, vXRefPrgFmg[i] )
      endif
   next
   vXRefPrgFmg := {}
   For i:=1 to len( vAux )
      AADD( vXRefPrgFmg, vAux[i] )
   next
   /* fin limpio las ocurrencias del prg */
   AADD( vScanned, cFileIn )     // Para Control de Funcion llamadora xRefPrgFmg()
   hFiIn := fopen( cFileIn )
   if ferror() = 0
      do while US_FReadLine( hFiIn, @cLinea, vFines ) == 0
         cLinea := alltrim( strtran( cLinea, chr(09), ' ' ) )
         if substr( cLinea, 1, 1 ) == '*'   .or. ;
            substr( cLinea, 1, 2 ) == '//'  .or. ;
            substr( cLinea, 1, 2 ) == '##'  .or. ;
            substr( cLinea, 1, 2 ) == '&&'  .or. ;
            us_words( cLinea ) < 3
         else
            if US_Words( cLinea ) > 2 .and. ;
               US_Upper( US_Word( cLinea, 1 ) ) == 'LOAD' .and. ;
               US_Upper( US_Word( cLinea, 2 ) ) == 'WINDOW'
               bLoadWindow := .T.
               AADD( vXRefPrgFmg, cFilePrgAux + ' ' + US_Upper( US_Word( cLinea, 3 ) + '.FMG' ) )
               if ascan( vPanFiles, { |x| US_Upper( US_FileNameOnlyNameAndExt( x ) ) == US_Upper( US_Word( cLinea, 3 ) + '.FMG' ) } ) > 0 .and. ;
                  DateTimeOfC < US_FileDateTime( vPanFiles[ ascan( vPanFiles, { |x| US_Upper( US_FileNameOnlyNameAndExt( x ) ) == US_Upper( US_Word( cLinea, 3 ) + '.FMG' ) } ) ] )
                  QPM_MemoWrit( PROGRESS_LOG, memoread( PROGRESS_LOG ) + US_TimeDis( Time() ) + ' - ' + US_Word( cLinea, 3 ) + '.FMG' + ' forced compilation of ' + cFileIn + Hb_OsNewLine() )
                  ferase( GetObjFolder() + DEF_SLASH + US_FileNameOnlyName( cFileIn ) + '.C' )
                  if bLogActivity
                     QPM_MemoWrit( PUB_cQPM_Folder + DEF_SLASH + 'QPM.log', memoread( PUB_cQPM_Folder + DEF_SLASH + 'QPM.log' ) + Hb_OsNewLine() + 'xRefPrgFmg ' + US_Word( cLinea, 3 ) + '.FMG' + " forced erasure .C of file '" + cFileIn + "' in Scan" )
                  endif
                  exit
               endif
            endif
         endif
      enddo
      fclose( hFiIn )
   else
      Return bLoadWindow
   endif
Return bLoadWindow

Function xRefPrgHea( vConcatIncludeC )
   Local i, f, p, Fol := PUB_cProjectFolder + DEF_SLASH
   Local vScanned := {}, vPRGFiles := {}, vHEAFiles := {}
   QPM_MemoWrit( PROGRESS_LOG, US_TimeDis( Time() ) + ' - Checking cross references between PRG files and Header files ...' + Hb_OsNewLine() )
   if bLogActivity
      QPM_MemoWrit( PUB_cQPM_Folder + DEF_SLASH + 'QPM.log', memoread( PUB_cQPM_Folder + DEF_SLASH + 'QPM.log' ) + Hb_OsNewLine() + 'xRefPrgHea Initialize' + Hb_OsNewLine() )
   endif
   For f:=1 to VentanaMain.GHeaFiles.itemcount
      aadd( vHEAFiles, ChgPathToReal( GetProperty( 'VentanaMain', 'GHeaFiles', 'Cell', f, NCOLHEAFULLNAME ) ) )
   Next f
   For f:=1 to len( vHeaFiles )
      For i := 1 to len( vConcatIncludeC )
         if file( vConcatIncludeC[i]+DEF_SLASH+US_FileNameOnlyNameAndExt( vHeaFiles[f] ) )
            if !( US_Upper( US_ShortName( vConcatIncludeC[i]+DEF_SLASH+US_FileNameOnlyNameAndExt( vHeaFiles[f] ) ) ) == US_Upper( US_ShortName(vHeaFiles[f]) ) )
               MsgWarn( 'In Folder '+vConcatIncludeC[i]+' exists the Header '+US_FileNameOnlyNameAndExt( vHeaFiles[f] ) + Hb_OsNewLine() + ;
                        "If you code #include with caracters '<' and '>', the search process of Harbour and C compilers will locate THIS header first," + Hb_OsNewLine() + ;
                        'then the header in '+US_FileNameOnlyPath( vHeaFiles[f] ) +' will be ignored.' )
            else
               exit
            endif
         endif
      Next i
   Next f
   For f:=1 to VentanaMain.GPrgFiles.itemcount
      aadd( vPRGFiles, ChgPathToReal( GetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', f, NCOLPRGFULLNAME ) ) )
   Next f
   /* Nota: Lo referido a vSinInclude y vXRefPrgHea puede ser eliminado, si eso ocurre, provocamos que en cada BUILD se */
   /*       scaneen los PRG que no tienen #include, enlenteciendo el proceso                                            */
   /*       Si se usa -BUILD como parametro no tiene ninguna implicancia ya que actúa despues de la primera pasada      */
   For f:=1 to len( vHEAFiles )
      For p:=1 to len( vPRGFiles )
         if ascan( vScanned, { |y| US_Upper( US_VarToStr( y ) ) == US_Upper( vPrgFiles[ p ] ) } ) == 0                      // a nivel funcion
         // if US_FileDateTime( vHeaFiles[ f ] ) > US_FileDateTime( Fol + GetObjName() + DEF_SLASH + US_FileNameOnlyName( vPrgFiles[ p ] ) + '.c' )
         // if US_FileDateTime( vHeaFiles[ f ] ) > US_FileDateTime( Fol + GetObjName() + DEF_SLASH + US_FileNameOnlyName( vPrgFiles[ p ] ) + if( US_Upper( US_FileNameOnlyExt( vPrgFiles[ p ] ) ) == 'CPP', '.cpp', '.c' ) )
            if US_FileDateTime( vHeaFiles[ f ] ) > US_FileDateTime( Fol + GetObjName() + DEF_SLASH + US_FileNameOnlyName( vPrgFiles[ p ] ) + if( US_Upper( US_FileNameOnlyExt( vPrgFiles[ p ] ) ) == 'PRG', '.c', '.'+GetObjExt() ) )
               if ascan( vSinInclude, { |y| US_Upper( US_VarToStr( y ) ) == US_Upper( vPrgFiles[ p ] ) } ) == 0                // a nivel programa
                  // el primer ascan hace una comparacion parcial ( = ) y se le añade un blanco al final para que solo encuentre palabras completas
                  // el segundo ascan hace una comparacion total ( == ) del string (son dos palabras)
                  // El vector contiene 'myPRG myHeader.h'
                  if ( AScan( vXRefPrgHea, { |x| US_Upper( US_VarToStr( x ) ) = US_Upper( US_FileNameOnlyNameAndExt( vPrgFiles[ p ] ) ) + ' ' } ) = 0 .or. ;
                     AScan( vXRefPrgHea, { |x| US_Upper( US_VarToStr( x ) ) == US_Upper( US_FileNameOnlyNameAndExt( vPrgFiles[ p ] ) ) + ' ' + US_Upper( US_FileNameOnlyNameAndExt( vHeaFiles[ f ] ) ) } ) > 0 )
                     if !( HEA_Scan( vPrgFiles[ p ], US_FileDateTime( Fol + GetObjName() + DEF_SLASH + US_FileNameOnlyName( vPrgFiles[ p ] ) + if( US_Upper( US_FileNameOnlyExt( vPrgFiles[ p ] ) ) == 'PRG', '.c', '.'+GetObjExt() ) ), vScanned, vHeaFiles ) )
                        AADD( vSinInclude, US_Upper( vPrgFiles[ p ] ) ) // Para Control de Programa desde segunda pasada hasta que se vuele a ingresar
                        if bLogActivity
                           QPM_MemoWrit( PUB_cQPM_Folder + DEF_SLASH + 'QPM.log', memoread( PUB_cQPM_Folder + DEF_SLASH + 'QPM.log' ) + Hb_OsNewLine() + "xRefPrgHea Add file '" + vPrgFiles[ p ] + "' to vSinInclude" )
                        endif
                     endif
                  endif
               endif
            endif
         endif
      next
   next
Return .T.

Function HEA_Scan( cFileIn, DateTimeOfC, vScanned, vHeaFiles )
   Local hFiIn, cLinea:='', vFines := { Chr(13) + Chr(10), Chr(10) }, bIncludeFound := .F., cName := '', i
   Local maxDateHeader := '00000000000000', incChars := { { '"', '"' }, { "'", "'" }, { '<', '>' } }
   Local vAux := {}
   Local cFilePrgAux := US_Upper( US_FileNameOnlyNameAndExt( cFileIn ) )
   Local vPreventLoop := {}
   QPM_MemoWrit( PROGRESS_LOG, memoread( PROGRESS_LOG ) + US_TimeDis( Time() ) + ' - ' + 'Scanning: '+cFileIn + Hb_OsNewLine() )
   if bLogActivity
      QPM_MemoWrit( PUB_cQPM_Folder + DEF_SLASH + 'QPM.log', memoread( PUB_cQPM_Folder + DEF_SLASH + 'QPM.log' ) + Hb_OsNewLine() + "xRefPrgHea Scan file '" + cFileIn + "'" )
   endif
   AADD( vScanned, cFileIn )     // Para Control de Funcion llamadora xRefPrgHea()
   hFiIn := fopen( cFileIn )
   if ferror() = 0
      do while US_FReadLine( hFiIn, @cLinea, vFines ) == 0
         cLinea := alltrim( strtran( cLinea, chr(09), ' ' ) )
         if US_Words( cLinea ) > 1 .and. ;
            US_Upper( US_Word( cLinea, 1 ) ) == '#INCLUDE'
            cName := ''
            For i:=1 to len( incChars )
               if substr( us_word( cLinea, 2 ), 1, 1 ) == incChars[i][1]
                  cName := substr( US_WordSubStr( cLinea, 2 ), 2, rat( incChars[i][2], US_WordSubStr( cLinea, 2 ) ) - 2 )
               endif
            next
            if ascan( vHeaFiles, { |x| US_Upper( US_FileNameOnlyNameAndExt( x ) ) == US_Upper( cName ) } ) > 0 .and. ;
               file( vHeaFiles[ ascan( vHeaFiles, { |x| US_Upper( US_FileNameOnlyNameAndExt( x ) ) == US_Upper( cName ) } ) ] )
               bIncludeFound := .T.
               if ascan( vPreventLoop, US_Upper( cName ) ) = 0
                  AADD( vPreventLoop, US_Upper( cName ) )
                  /* limpio las ocurrencias del prg */
                  For i:=1 to len( vXRefPrgHea )
                     if !( US_Word( vXRefPrgHea[i], 1 ) == cFilePrgAux )
                        AADD( vAux, vXRefPrgHea[i] )
                     endif
                  next
                  vXRefPrgHea := {}
                  For i:=1 to len( vAux )
                     AADD( vXRefPrgHea, vAux[i] )
                  next
                  /* fin limpio las ocurrencias del prg */
                  AADD( vXRefPrgHea, cFilePrgAux + ' ' + US_Upper( cName ) )
                  maxDateHeader := ScanIncRecursive( vHeaFiles[ ascan( vHeaFiles, { |x| US_Upper( US_FileNameOnlyNameAndExt( x ) ) == US_Upper( cName ) } ) ], cFilePrgAux, vPreventLoop, vHeaFiles )
               endif
            endif
            if DateTimeOfC < maxDateHeader
               QPM_MemoWrit( PROGRESS_LOG, memoread( PROGRESS_LOG ) + US_TimeDis( Time() ) + ' - ' + cName + ' or sub includes forced compilation of ' + cFileIn + Hb_OsNewLine() )
            // ferase( GetObjFolder() + DEF_SLASH + US_FileNameOnlyName( cFileIn ) + '.c' )
            // ferase( GetObjFolder() + DEF_SLASH + US_FileNameOnlyName( cFileIn ) + if( US_Upper( US_FileNameOnlyExt( cFileIn ) ) == 'CPP', '.cpp', '.c' ) )
               ferase( GetObjFolder() + DEF_SLASH + US_FileNameOnlyName( cFileIn ) + if( US_Upper( US_FileNameOnlyExt( cFileIn ) ) == 'PRG', '.c', '.'+GetObjExt() ) )
               if bLogActivity
                  QPM_MemoWrit( PUB_cQPM_Folder + DEF_SLASH + 'QPM.log', memoread( PUB_cQPM_Folder + DEF_SLASH + 'QPM.log' ) + Hb_OsNewLine() + 'xRefPrgHea ' + cName + " or sub includes forced erasure .C of file '" + cFileIn + "' in Scan" )
               endif
               exit
            endif
         endif
      enddo
      fclose( hFiIn )
   else
      Return bIncludeFound
   endif
Return bIncludeFound

Function ScanIncRecursive( cFileIn, cFilePrgAux, vPreventLoop, vHeaFiles )
   Local cName, i, hFiIn, cLinea:='', vFines := { Chr(13) + Chr(10), Chr(10) }
   Local maxDateHeader  := US_FileDateTime( cFileIn ), incChars := { { '"', '"' }, { "'", "'" }, { '<', '>' } }
   Local callDateHeader
   hFiIn := fopen( cFileIn )
   if ferror() = 0
      do while US_FReadLine( hFiIn, @cLinea, vFines ) == 0
         cLinea := alltrim( strtran( cLinea, chr(09), ' ' ) )
         if US_Words( cLinea ) > 1 .and. ;
            US_Upper( US_Word( cLinea, 1 ) ) == '#INCLUDE'
            cName := ''
            For i:=1 to len( incChars )
               if substr( us_word( cLinea, 2 ), 1, 1 ) == incChars[i][1]
                  cName := substr( US_WordSubStr( cLinea, 2 ), 2, rat( incChars[i][2], US_WordSubStr( cLinea, 2 ) ) - 2 )
               endif
            next
            if ascan( vHeaFiles, { |x| US_Upper( US_FileNameOnlyNameAndExt( x ) ) == US_Upper( cName ) } ) > 0 .and. ;
               file( vHeaFiles[ ascan( vHeaFiles, { |x| US_Upper( US_FileNameOnlyNameAndExt( x ) ) == US_Upper( cName ) } ) ] )
               if ascan( vPreventLoop, US_Upper( cName ) ) = 0
                  AADD( vPreventLoop, US_Upper( cName ) )
                  AADD( vXRefPrgHea, cFilePrgAux + ' ' + US_Upper( cName ) )
                  if maxDateHeader < ( callDateHeader := ScanIncRecursive( vHeaFiles[ ascan( vHeaFiles, { |x| US_Upper( US_FileNameOnlyNameAndExt( x ) ) == US_Upper( cName ) } ) ], cFilePrgAux, vPreventLoop, vHeaFiles ) )
                     maxDateHeader := callDateHeader
                  endif
               endif
            endif
         endif
      enddo
      fclose( hFiIn )
   else
      Return maxDateHeader
   endif
Return maxDateHeader

Function CheckMakeForm( cForm )
   Local hFiIn, cLinea:='', vFines := { Chr(13) + Chr(10), Chr(10) }, reto := 'UNKNOWN'
   hFiIn := fopen( cForm )
   if ferror() = 0
      do while US_FReadLine( hFiIn, @cLinea, vFines ) == 0
         cLinea := alltrim( strtran( cLinea, chr(09), ' ' ) )
         do case
            case US_Upper( US_Word( cLinea, 1 ) ) == '*HMGS-MINIGUI-IDE'
               reto := 'HMGSIDE (Open Source by Walter Formigoni)'
               exit
            case at( '* HARBOUR MINIGUI IDE HMI+', US_Upper( cLinea ) ) > 0
               reto := 'HMI (by Ciro Vargas Clemow)'
               exit
            case at( '* ooHG IDE Plus', US_Upper( cLinea ) ) > 0
               reto := 'ooHGIDE+ (by Ciro Vargas Clemow)'
               exit
            case at( '* OOHG IDE', US_Upper( cLinea ) ) > 0
               reto := 'HMI (by Ciro Vargas Clemow)'
               exit
            case at( '* HARBOUR MINIGUI IDE TWO-WAY', US_Upper( cLinea ) ) > 0
               reto := 'IDE (by Roberto Lopez)'
               exit
         endcase
      enddo
      fclose( hFiIn )
   endif
Return reto

Function QPM_SetColor()
   if PUB_bLite
      Do case
         case Prj_Radio_OutputType == DEF_RG_EXE
            SetProperty( 'VentanaLite', 'RichEditSysout', 'backcolor', DEF_COLOREXE )
         case Prj_Radio_OutputType == DEF_RG_LIB
            SetProperty( 'VentanaLite', 'RichEditSysout', 'backcolor', DEF_COLORLIB )
         case Prj_Radio_OutputType == DEF_RG_IMPORT
            SetProperty( 'VentanaLite', 'RichEditSysout', 'backcolor', DEF_COLORDLL )
      endcase
   else
      Do case
         case Prj_Radio_OutputType == DEF_RG_EXE
            SetProperty( 'VentanaMain', 'RichEditSysout', 'backcolor', DEF_COLOREXE )
         case Prj_Radio_OutputType == DEF_RG_LIB
            SetProperty( 'VentanaMain', 'RichEditSysout', 'backcolor', DEF_COLORLIB )
         case Prj_Radio_OutputType == DEF_RG_IMPORT
            SetProperty( 'VentanaMain', 'RichEditSysout', 'backcolor', DEF_COLORDLL )
      endcase
   endif
Return .T.

Function SortPRG( cVentana, cGrid, nColumna )
   Local i, vAux := {}, cAux := GetProperty( cVentana, cGrid, 'item', 1 )
   Local nActual := GetProperty( cVentana, cGrid, 'cell', GetProperty( cVentana, cGrid, 'value' ), nColumna )
   bPrgSorting := .T.
   if VentanaMain.GPrgFiles.ItemCount > 1
      DoMethod( cVentana, cGrid, 'DisableUpdate' )
      For i:=2 to GetProperty( cVentana, cGrid, 'itemcount' )
         aadd( vAux, GetProperty( cVentana, cGrid, 'item', i ) )
      next
      DoMethod( cVentana, cGrid, 'deleteallitems' )
      DoMethod( cVentana, cGrid, 'additem', cAux )
      if bSortPrgAsc
         aSort( vAux,,, { |x, y| US_Upper(x[nColumna]) < US_Upper(y[nColumna]) })
      else
         aSort( vAux,,, { |x, y| US_Upper(x[nColumna]) > US_Upper(y[nColumna]) })
      endif
      bSortPrgAsc := !bSortPrgAsc
      For i:=1 to len( vAux )
         DoMethod( cVentana, cGrid, 'additem', vAux[ i ] )
      next
      SetProperty( cVentana, cGrid, 'value', aScan( vAux, {|x| x[ nColumna ] == nActual } ) + 1 )
      DoMethod( cVentana, cGrid, 'setfocus' )
      DoMethod( cVentana, cGrid, 'EnableUpdate' )
   endif
   bPrgSorting := .F.
Return .T.

Function SortHEA( cVentana, cGrid, nColumna )
   Local i, vAux := {}
   Local nActual := GetProperty( cVentana, cGrid, 'cell', GetProperty( cVentana, cGrid, 'value' ), nColumna )
   bHeaSorting := .T.
   DoMethod( cVentana, cGrid, 'DisableUpdate' )
   For i:=1 to GetProperty( cVentana, cGrid, 'itemcount' )
      aadd( vAux, GetProperty( cVentana, cGrid, 'item', i ) )
   next
   DoMethod( cVentana, cGrid, 'deleteallitems' )
   if bSortHeaAsc
      aSort( vAux,,, { |x, y| US_Upper(x[nColumna]) < US_Upper(y[nColumna]) })
   else
      aSort( vAux,,, { |x, y| US_Upper(x[nColumna]) > US_Upper(y[nColumna]) })
   endif
   bSortHeaAsc := !bSortHeaAsc
   For i:=1 to len( vAux )
      DoMethod( cVentana, cGrid, 'additem', vAux[ i ] )
   next
   SetProperty( cVentana, cGrid, 'value', aScan( vAux, {|x| x[ nColumna ] == nActual } ) )
   DoMethod( cVentana, cGrid, 'setfocus' )
   DoMethod( cVentana, cGrid, 'EnableUpdate' )
   bHeaSorting := .F.
Return .T.

Function SortPAN( cVentana, cGrid, nColumna )
   Local i, vAux := {}
   Local nActual := GetProperty( cVentana, cGrid, 'cell', GetProperty( cVentana, cGrid, 'value' ), nColumna )
   bPanSorting := .T.
   DoMethod( cVentana, cGrid, 'DisableUpdate' )
   For i:=1 to GetProperty( cVentana, cGrid, 'itemcount' )
      aadd( vAux, GetProperty( cVentana, cGrid, 'item', i ) )
   next
   DoMethod( cVentana, cGrid, 'deleteallitems' )
   if bSortPanAsc
      aSort( vAux,,, { |x, y| US_Upper(x[nColumna]) < US_Upper(y[nColumna]) })
   else
      aSort( vAux,,, { |x, y| US_Upper(x[nColumna]) > US_Upper(y[nColumna]) })
   endif
   bSortPanAsc := !bSortPanAsc
   For i:=1 to len( vAux )
      DoMethod( cVentana, cGrid, 'additem', vAux[ i ] )
   next
   SetProperty( cVentana, cGrid, 'value', aScan( vAux, {|x| x[ nColumna ] == nActual } ) )
   DoMethod( cVentana, cGrid, 'setfocus' )
   DoMethod( cVentana, cGrid, 'EnableUpdate' )
   bPanSorting := .F.
Return .T.

Function SortDBF( cVentana, cGrid, nColumna )
   Local i, vAux := {}
   Local nActual := GetProperty( cVentana, cGrid, 'cell', GetProperty( cVentana, cGrid, 'value' ), nColumna )
   bDbfSorting := .T.
   DoMethod( cVentana, cGrid, 'DisableUpdate' )
   For i:=1 to GetProperty( cVentana, cGrid, 'itemcount' )
      aadd( vAux, GetProperty( cVentana, cGrid, 'item', i ) )
   next
   DoMethod( cVentana, cGrid, 'deleteallitems' )
   if bSortDbfAsc
      aSort( vAux,,, { |x, y| US_Upper(x[nColumna]) < US_Upper(y[nColumna]) })
   else
      aSort( vAux,,, { |x, y| US_Upper(x[nColumna]) > US_Upper(y[nColumna]) })
   endif
   bSortDbfAsc := !bSortDbfAsc
   For i:=1 to len( vAux )
      DoMethod( cVentana, cGrid, 'additem', vAux[ i ] )
   next
   SetProperty( cVentana, cGrid, 'value', aScan( vAux, {|x| x[ nColumna ] == nActual } ) )
   DoMethod( cVentana, cGrid, 'setfocus' )
   DoMethod( cVentana, cGrid, 'EnableUpdate' )
   bDbfSorting := .F.
Return .T.

Function SortInc( cVentana, cGrid, nColumna )
   Local i, vAux := {}
   Local nActual := GetProperty( cVentana, cGrid, 'cell', GetProperty( cVentana, cGrid, 'value' ), nColumna )
   bIncSorting := .T.
   DoMethod( cVentana, cGrid, 'DisableUpdate' )
   For i:=1 to GetProperty( cVentana, cGrid, 'itemcount' )
      aadd( vAux, GetProperty( cVentana, cGrid, 'item', i ) )
   next
   DoMethod( cVentana, cGrid, 'deleteallitems' )
   if nColumna = NCOLINCFULLNAME
      if bSortIncAsc
         aSort( vAux,,, { |x, y| US_Upper(US_WordSubstr(x[nColumna],3)) < US_Upper(US_WordSubStr(y[nColumna],3)) })
      else
         aSort( vAux,,, { |x, y| US_Upper(US_WordSubstr(x[nColumna],3)) > US_Upper(US_WordSubStr(y[nColumna],3)) })
      endif
   else
      if bSortIncAsc
         aSort( vAux,,, { |x, y| US_Upper( x[nColumna] ) < US_Upper( y[nColumna] ) } )
      else
         aSort( vAux,,, { |x, y| US_Upper( x[nColumna] ) > US_Upper( y[nColumna] ) } )
      endif
   endif
   bSortIncAsc := !bSortIncAsc
   For i:=1 to len( vAux )
      DoMethod( cVentana, cGrid, 'additem', vAux[ i ] )
   next
   if nColumna = NCOLINCFULLNAME
      SetProperty( cVentana, cGrid, 'value', aScan( vAux, {|x| US_WordSubStr( x[ nColumna ], 3 ) == US_WordSubStr( nActual, 3 ) } ) )
   else
      SetProperty( cVentana, cGrid, 'value', aScan( vAux, {|x| x[ nColumna ] == nActual } ) )
   endif
   DoMethod( cVentana, cGrid, 'setfocus' )
   DoMethod( cVentana, cGrid, 'EnableUpdate' )
   bIncSorting := .F.
Return .T.

Function SortExc( cVentana, cGrid, nColumna )
   Local i, vAux := {}
   Local nActual := GetProperty( cVentana, cGrid, 'cell', GetProperty( cVentana, cGrid, 'value' ), nColumna )
   bExcSorting := .T.
   DoMethod( cVentana, cGrid, 'DisableUpdate' )
   For i:=1 to GetProperty( cVentana, cGrid, 'itemcount' )
      aadd( vAux, GetProperty( cVentana, cGrid, 'item', i ) )
   next
   DoMethod( cVentana, cGrid, 'deleteallitems' )
   if bSortExcAsc
      aSort( vAux,,, { |x, y| US_Upper(x[nColumna]) < US_Upper(y[nColumna]) })
   else
      aSort( vAux,,, { |x, y| US_Upper(x[nColumna]) > US_Upper(y[nColumna]) })
   endif
   bSortExcAsc := !bSortExcAsc
   For i:=1 to len( vAux )
      DoMethod( cVentana, cGrid, 'additem', vAux[ i ] )
   next
   SetProperty( cVentana, cGrid, 'value', aScan( vAux, {|x| x[ nColumna ] == nActual } ) )
   DoMethod( cVentana, cGrid, 'setfocus' )
   DoMethod( cVentana, cGrid, 'EnableUpdate' )
   bExcSorting := .F.
Return .T.

//Function SortHlp( cVentana, cGrid, nColumna )
//   Local i, vAux := {}, cAux := GetProperty( cVentana, cGrid, 'item', 1 )
//   Local nActual := GetProperty( cVentana, cGrid, 'cell', GetProperty( cVentana, cGrid, 'value' ), nColumna )
//   bHlpSorting := .T.
//   if VentanaMain.GHlpFiles.ItemCount > 1
//      DoMethod( cVentana, cGrid, 'DisableUpdate' )
//      For i:=2 to GetProperty( cVentana, cGrid, 'itemcount' )
//         aadd( vAux, GetProperty( cVentana, cGrid, 'item', i ) )
//      next
//      DoMethod( cVentana, cGrid, 'deleteallitems' )
//      DoMethod( cVentana, cGrid, 'additem', cAux )
//      if bSortHlpAsc
//         aSort( vAux,,, { |x, y| US_Upper(x[nColumna]) < US_Upper(y[nColumna]) })
//      else
//         aSort( vAux,,, { |x, y| US_Upper(x[nColumna]) > US_Upper(y[nColumna]) })
//      endif
//      bSortHlpAsc := !bSortHlpAsc
//      For i:=1 to len( vAux )
//         DoMethod( cVentana, cGrid, 'additem', vAux[ i ] )
//      next
//      SetProperty( cVentana, cGrid, 'value', aScan( vAux, {|x| x[ nColumna ] == nActual } ) + 1 )
//      DoMethod( cVentana, cGrid, 'setfocus' )
//      DoMethod( cVentana, cGrid, 'EnableUpdate' )
//   endif
//   bHlpSorting := .F.
//Return .T.

Function UpPrg()
   Local i := GetProperty( 'VentanaMain', 'GPrgFiles', 'value' )
   Local cAux := GetProperty( 'VentanaMain', 'GPrgFiles', 'item', i )
   Local cAux2 := GetProperty( 'VentanaMain', 'GPrgFiles', 'item', i - 1 )
   if i = 2
      MsgInfo( 'Use the SetTop button for Up this item to Top of Project' )
   endif
   if i > 2
      bPrgMoving := .T.
      SetProperty( 'VentanaMain', 'GPrgFiles', 'item', i, cAux2 )
      SetProperty( 'VentanaMain', 'GPrgFiles', 'item', i - 1, cAux )
      SetProperty( 'VentanaMain', 'GPrgFiles', 'value', i - 1 )
      DoMethod( 'VentanaMain', 'GPrgFiles', 'setfocus' )
      bPrgMoving := .F.
   endif
Return .T.

Function DownPrg()
   Local i := GetProperty( 'VentanaMain', 'GPrgFiles', 'value' )
   Local cAux := GetProperty( 'VentanaMain', 'GPrgFiles', 'item', i )
   Local cAux2 := GetProperty( 'VentanaMain', 'GPrgFiles', 'item', i + 1 )
   if i = 1
      MsgInfo( DBLQT + "Top File" + DBLQT + " can't be moved. Use the SetTop button to make another source the new " + DBLQT + "Top File" + DBLQT + "." )
   endif
   if i < GetProperty( 'VentanaMain', 'GPrgFiles', 'itemcount' ) .and. i > 1
      bPrgMoving := .T.
      SetProperty( 'VentanaMain', 'GPrgFiles', 'item', i, cAux2 )
      SetProperty( 'VentanaMain', 'GPrgFiles', 'item', i + 1, cAux )
      SetProperty( 'VentanaMain', 'GPrgFiles', 'value', i + 1 )
      DoMethod( 'VentanaMain', 'GPrgFiles', 'setfocus' )
      bPrgMoving := .F.
   endif
Return .T.

Function UpPan()
   Local i := GetProperty( 'VentanaMain', 'GPanFiles', 'value' )
   Local cAux := GetProperty( 'VentanaMain', 'GPanFiles', 'item', i )
   Local cAux2 := GetProperty( 'VentanaMain', 'GPanFiles', 'item', i - 1 )
   if i > 1
      bPanMoving := .T.
      SetProperty( 'VentanaMain', 'GPanFiles', 'item', i, cAux2 )
      SetProperty( 'VentanaMain', 'GPanFiles', 'item', i - 1, cAux )
      SetProperty( 'VentanaMain', 'GPanFiles', 'value', i - 1 )
      DoMethod( 'VentanaMain', 'GPanFiles', 'setfocus' )
      bPanMoving := .F.
   endif
Return .T.

Function DownPan()
   Local i := GetProperty( 'VentanaMain', 'GPanFiles', 'value' )
   Local cAux := GetProperty( 'VentanaMain', 'GPanFiles', 'item', i )
   Local cAux2 := GetProperty( 'VentanaMain', 'GPanFiles', 'item', i + 1 )
   if i > 0 .and. i < GetProperty( 'VentanaMain', 'GPanFiles', 'itemcount' )
      bPanMoving := .T.
      SetProperty( 'VentanaMain', 'GPanFiles', 'item', i, cAux2 )
      SetProperty( 'VentanaMain', 'GPanFiles', 'item', i + 1, cAux )
      SetProperty( 'VentanaMain', 'GPanFiles', 'value', i + 1 )
      DoMethod( 'VentanaMain', 'GPanFiles', 'setfocus' )
      bPanMoving := .F.
   endif
Return .T.

Function UpDbf()
   Local i := GetProperty( 'VentanaMain', 'GDbfFiles', 'value' )
   Local cAux := GetProperty( 'VentanaMain', 'GDbfFiles', 'item', i )
   Local cAux2 := GetProperty( 'VentanaMain', 'GDbfFiles', 'item', i - 1 )
   if i > 1
      bDbfMoving := .T.
      SetProperty( 'VentanaMain', 'GDbfFiles', 'item', i, cAux2 )
      SetProperty( 'VentanaMain', 'GDbfFiles', 'item', i - 1, cAux )
      SetProperty( 'VentanaMain', 'GDbfFiles', 'value', i - 1 )
      DoMethod( 'VentanaMain', 'GDbfFiles', 'setfocus' )
      bDbfMoving := .F.
   endif
Return .T.

Function DownDbf()
   Local i := GetProperty( 'VentanaMain', 'GDbfFiles', 'value' )
   Local cAux := GetProperty( 'VentanaMain', 'GDbfFiles', 'item', i )
   Local cAux2 := GetProperty( 'VentanaMain', 'GDbfFiles', 'item', i + 1 )
   if i > 0 .and. i < GetProperty( 'VentanaMain', 'GDbfFiles', 'itemcount' )
      bDbfMoving := .T.
      SetProperty( 'VentanaMain', 'GDbfFiles', 'item', i, cAux2 )
      SetProperty( 'VentanaMain', 'GDbfFiles', 'item', i + 1, cAux )
      SetProperty( 'VentanaMain', 'GDbfFiles', 'value', i + 1 )
      DoMethod( 'VentanaMain', 'GDbfFiles', 'setfocus' )
      bDbfMoving := .F.
   endif
Return .T.

Function UpHea()
   Local i := GetProperty( 'VentanaMain', 'GHeaFiles', 'value' )
   Local cAux := GetProperty( 'VentanaMain', 'GHeaFiles', 'item', i )
   Local cAux2 := GetProperty( 'VentanaMain', 'GHeaFiles', 'item', i - 1 )
   if i > 1
      bHeaMoving := .T.
      SetProperty( 'VentanaMain', 'GHeaFiles', 'item', i, cAux2 )
      SetProperty( 'VentanaMain', 'GHeaFiles', 'item', i - 1, cAux )
      SetProperty( 'VentanaMain', 'GHeaFiles', 'value', i - 1 )
      DoMethod( 'VentanaMain', 'GHeaFiles', 'setfocus' )
      bHeaMoving := .F.
   endif
Return .T.

Function DownHea()
   Local i := GetProperty( 'VentanaMain', 'GHeaFiles', 'value' )
   Local cAux := GetProperty( 'VentanaMain', 'GHeaFiles', 'item', i )
   Local cAux2 := GetProperty( 'VentanaMain', 'GHeaFiles', 'item', i + 1 )
   if i > 0 .and. i < GetProperty( 'VentanaMain', 'GHeaFiles', 'itemcount' )
      bHeaMoving := .T.
      SetProperty( 'VentanaMain', 'GHeaFiles', 'item', i, cAux2 )
      SetProperty( 'VentanaMain', 'GHeaFiles', 'item', i + 1, cAux )
      SetProperty( 'VentanaMain', 'GHeaFiles', 'value', i + 1 )
      DoMethod( 'VentanaMain', 'GHeaFiles', 'setfocus' )
      bHeaMoving := .F.
   endif
Return .T.

Function UpLibInclude()
   Local i := GetProperty( 'VentanaMain', 'GIncFiles', 'value' )
   Local cAux := GetProperty( 'VentanaMain', 'GIncFiles', 'item', i )
   Local cAux2 := GetProperty( 'VentanaMain', 'GIncFiles', 'item', i - 1 )
   if i > 1
      bIncMoving := .T.
      SetProperty( 'VentanaMain', 'GIncFiles', 'item', i, cAux2 )
      SetProperty( 'VentanaMain', 'GIncFiles', 'item', i - 1, cAux )
      SetProperty( 'VentanaMain', 'GIncFiles', 'value', i - 1 )
      DoMethod( 'VentanaMain', 'GIncFiles', 'setfocus' )
      bIncMoving := .F.
   endif
Return .T.

Function DownLibInclude()
   Local i := GetProperty( 'VentanaMain', 'GIncFiles', 'value' )
   Local cAux := GetProperty( 'VentanaMain', 'GIncFiles', 'item', i )
   Local cAux2 := GetProperty( 'VentanaMain', 'GIncFiles', 'item', i + 1 )
   if i > 0 .and. i < GetProperty( 'VentanaMain', 'GIncFiles', 'itemcount' )
      bIncMoving := .T.
      SetProperty( 'VentanaMain', 'GIncFiles', 'item', i, cAux2 )
      SetProperty( 'VentanaMain', 'GIncFiles', 'item', i + 1, cAux )
      SetProperty( 'VentanaMain', 'GIncFiles', 'value', i + 1 )
      DoMethod( 'VentanaMain', 'GIncFiles', 'setfocus' )
      bIncMoving := .F.
   endif
Return .T.

Function UpLibExclude()
   Local i := GetProperty( 'VentanaMain', 'GExcFiles', 'value' )
   Local cAux := GetProperty( 'VentanaMain', 'GExcFiles', 'item', i )
   Local cAux2 := GetProperty( 'VentanaMain', 'GExcFiles', 'item', i - 1 )
   if i > 1
      bExcMoving := .T.
      SetProperty( 'VentanaMain', 'GExcFiles', 'item', i, cAux2 )
      SetProperty( 'VentanaMain', 'GExcFiles', 'item', i - 1, cAux )
      SetProperty( 'VentanaMain', 'GExcFiles', 'value', i - 1 )
      DoMethod( 'VentanaMain', 'GExcFiles', 'setfocus' )
      bExcMoving := .F.
   endif
Return .T.

Function DownLibExclude()
   Local i := GetProperty( 'VentanaMain', 'GExcFiles', 'value' )
   Local cAux := GetProperty( 'VentanaMain', 'GExcFiles', 'item', i )
   Local cAux2 := GetProperty( 'VentanaMain', 'GExcFiles', 'item', i + 1 )
   if i > 0 .and. i < GetProperty( 'VentanaMain', 'GExcFiles', 'itemcount' )
      bExcMoving := .T.
      SetProperty( 'VentanaMain', 'GExcFiles', 'item', i, cAux2 )
      SetProperty( 'VentanaMain', 'GExcFiles', 'item', i + 1, cAux )
      SetProperty( 'VentanaMain', 'GExcFiles', 'value', i + 1 )
      DoMethod( 'VentanaMain', 'GExcFiles', 'setfocus' )
      bExcMoving := .F.
   endif
Return .T.

#ifdef QPM_SHG
Function UpHlp()
   Local i := GetProperty( 'VentanaMain', 'GHlpFiles', 'value' )
   Local cAux := GetProperty( 'VentanaMain', 'GHlpFiles', 'item', i )
   Local cAux2 := GetProperty( 'VentanaMain', 'GHlpFiles', 'item', i - 1 )
   if i = 3
      MsgInfo( "Global foot and Welcome page can't be moved, they're system topics !!!" )
   endif
   if i > 3
      bHlpMoving := .T.
      SHG_SetField( 'SHG_ORDER', i - 1, 0 )
      SHG_SetField( 'SHG_ORDER', i, i - 1 )
      SHG_SetField( 'SHG_ORDER', 0, i )
      SetProperty( 'VentanaMain', 'GHlpFiles', 'item', i, cAux2 )
      SetProperty( 'VentanaMain', 'GHlpFiles', 'item', i - 1, cAux )
      SetProperty( 'VentanaMain', 'GHlpFiles', 'value', i - 1 )
      DoMethod( 'VentanaMain', 'GHlpFiles', 'setfocus' )
      bHlpMoving := .F.
   endif
Return .T.
#endif

#ifdef QPM_SHG
Function DownHlp()
   Local i := GetProperty( 'VentanaMain', 'GHlpFiles', 'value' )
   Local cAux := GetProperty( 'VentanaMain', 'GHlpFiles', 'item', i )
   Local cAux2 := GetProperty( 'VentanaMain', 'GHlpFiles', 'item', i + 1 )
   if i = 1
      MsgInfo( "Global foot can't be moved, it's a system topic !!!" )
   endif
   if i = 2
      MsgInfo( "Welcome page can't be moved, it's a system topic !!!" )
   endif
   if i < GetProperty( 'VentanaMain', 'GHlpFiles', 'itemcount' ) .and. i > 2
      bHlpMoving := .T.
      SHG_SetField( 'SHG_ORDER', i + 1, 0 )
      SHG_SetField( 'SHG_ORDER', i, i + 1 )
      SHG_SetField( 'SHG_ORDER', 0, i )
      SetProperty( 'VentanaMain', 'GHlpFiles', 'item', i, cAux2 )
      SetProperty( 'VentanaMain', 'GHlpFiles', 'item', i + 1, cAux )
      SetProperty( 'VentanaMain', 'GHlpFiles', 'value', i + 1 )
      DoMethod( 'VentanaMain', 'GHlpFiles', 'setfocus' )
      bHlpMoving := .F.
   endif
Return .T.
#endif

Function ToolTipPrgList()
   if GetProperty( 'VentanaMain', 'GPrgFiles', 'value' ) = 0
      SetProperty( 'VentanaMain', 'GPrgFiles', 'tooltip', '' )
   else
      SetProperty( 'VentanaMain', 'GPrgFiles', 'tooltip', GetProperty( 'VentanaMain', 'GPrgFiles', 'item', GetProperty( 'VentanaMain', 'GPrgFiles', 'value' ) ) )
   endif
Return .t.

Function ToolTipHEAList()
   if GetProperty( 'VentanaMain', 'GHeaFiles', 'value' ) = 0
      SetProperty( 'VentanaMain', 'GHeaFiles', 'tooltip', '' )
   else
      SetProperty( 'VentanaMain', 'GHeaFiles', 'tooltip', GetProperty( 'VentanaMain', 'GHeaFiles', 'item', GetProperty( 'VentanaMain', 'GHeaFiles', 'value' ) ) )
   endif
Return .t.

Function ToolTipPANList()
   if GetProperty( 'VentanaMain', 'GPanFiles', 'value' ) = 0
      SetProperty( 'VentanaMain', 'GPanFiles', 'tooltip', '' )
   else
      SetProperty( 'VentanaMain', 'GPanFiles', 'tooltip', GetProperty( 'VentanaMain', 'GPanFiles', 'item', GetProperty( 'VentanaMain', 'GPanFiles', 'value' ) ) )
   endif
Return .t.

Function ToolTipDbfList()
   if GetProperty( 'VentanaMain', 'GDbfFiles', 'value' ) = 0
      SetProperty( 'VentanaMain', 'GDbfFiles', 'tooltip', '' )
   else
      SetProperty( 'VentanaMain', 'GDbfFiles', 'tooltip', GetProperty( 'VentanaMain', 'GDbfFiles', 'item', GetProperty( 'VentanaMain', 'GDbfFiles', 'value' ) ) )
   endif
Return .t.

Function ToolTipHlpList()
   if GetProperty( 'VentanaMain', 'GHlpFiles', 'value' ) = 0
      SetProperty( 'VentanaMain', 'GHlpFiles', 'tooltip', '' )
   else
      SetProperty( 'VentanaMain', 'GHlpFiles', 'tooltip', GetProperty( 'VentanaMain', 'GHlpFiles', 'item', GetProperty( 'VentanaMain', 'GHlpFiles', 'value' ) ) )
   endif
Return .t.

Function EraseOBJ()
   Local TopName := US_FileNameOnlyName( GetOutputModuleName() )
   if ! empty( PUB_cProjectFolder )
      US_DirRemove( GetObjFolder() )
      ferase( PUB_cProjectFolder + DEF_SLASH + TopName + '.' + OutputExt() )
      ferase( PUB_cProjectFolder + DEF_SLASH + TopName + '.TDS' )
   endif
   if PUB_bLite
      VentanaLite.LFull.FontColor := DEF_COLORRED
      VentanaLite.LFull.Value := 'Force non-incremental'
   else
      VentanaMain.LFull.FontColor := DEF_COLORRED
      VentanaMain.LFull.Value := 'Force non-incremental'
   endif
   QPM_SetResumen()
   vSinLoadWindow := {}
   vSinInclude    := {}
   vXRefPrgHea    := {}
   vXRefPrgFmg    := {}
   if bLogActivity
      QPM_MemoWrit( PUB_cQPM_Folder + DEF_SLASH + 'QPM.log', memoread( PUB_cQPM_Folder + DEF_SLASH + 'QPM.log' ) + Hb_OsNewLine() + 'xRefPrgFmg CleanUp of vSinLoadWindow by EraseObj' )
      QPM_MemoWrit( PUB_cQPM_Folder + DEF_SLASH + 'QPM.log', memoread( PUB_cQPM_Folder + DEF_SLASH + 'QPM.log' ) + Hb_OsNewLine() + 'xRefPrgHea CleanUp of vSinInclude by EraseObj' )
      QPM_MemoWrit( PUB_cQPM_Folder + DEF_SLASH + 'QPM.log', memoread( PUB_cQPM_Folder + DEF_SLASH + 'QPM.log' ) + Hb_OsNewLine() + 'xRefPrgHea CleanUp of vXRefPrgHea by EraseObj' )
      QPM_MemoWrit( PUB_cQPM_Folder + DEF_SLASH + 'QPM.log', memoread( PUB_cQPM_Folder + DEF_SLASH + 'QPM.log' ) + Hb_OsNewLine() + 'xRefPrgFmg CleanUp of vXRefPrgFmg by EraseObj' )
   endif
   RichEditDisplay('OUT')
Return .T.

Function EraseALL()
   Local i, dire
   if bWaitForBuild
      do while BUILD_IN_PROGRESS
         DO EVENTS
      enddo
   endif
   if ! empty( PUB_cProjectFolder )
      For i := 1 to len( vSuffix )
         dire := PUB_cProjectFolder + DEF_SLASH + GetObjPrefix() + vSuffix[i][1]
         US_DirRemove( dire )
         dire := PUB_cProjectFolder + DEF_SLASH + GetObjPrefix() + Left( vSuffix[i][1], Len( vSuffix[i][1] ) - 3 )
         US_DirRemove( dire )
      Next i
      if PUB_bLite
         VentanaLite.LFull.FontColor := DEF_COLORRED
         VentanaLite.LFull.Value := 'Force non-incremental'
      else
         VentanaMain.LFull.FontColor := DEF_COLORRED
         VentanaMain.LFull.Value := 'Force non-incremental'
      endif
      QPM_SetResumen()
      vSinLoadWindow := {}
      vSinInclude    := {}
      vXRefPrgHea    := {}
      vXRefPrgFmg    := {}
      if bLogActivity
         QPM_MemoWrit( PUB_cQPM_Folder + DEF_SLASH + 'QPM.log', memoread( PUB_cQPM_Folder + DEF_SLASH + 'QPM.log' ) + Hb_OsNewLine() + 'xRefPrgFmg CleanUp of vSinLoadWindow by EraseALL' )
         QPM_MemoWrit( PUB_cQPM_Folder + DEF_SLASH + 'QPM.log', memoread( PUB_cQPM_Folder + DEF_SLASH + 'QPM.log' ) + Hb_OsNewLine() + 'xRefPrgHea CleanUp of vSinInclude by EraseALL' )
         QPM_MemoWrit( PUB_cQPM_Folder + DEF_SLASH + 'QPM.log', memoread( PUB_cQPM_Folder + DEF_SLASH + 'QPM.log' ) + Hb_OsNewLine() + 'xRefPrgHea CleanUp of vXRefPrgHea by EraseALL' )
         QPM_MemoWrit( PUB_cQPM_Folder + DEF_SLASH + 'QPM.log', memoread( PUB_cQPM_Folder + DEF_SLASH + 'QPM.log' ) + Hb_OsNewLine() + 'xRefPrgFmg CleanUp of vXRefPrgFmg by EraseALL' )
      endif
   endif
Return .T.

Function BuildStop()
   QPM_MemoWrit( PUB_cProjectFolder + DEF_SLASH + '_' + PUB_cSecu + 'MSG.SYSIN', 'STOP ' )
   if PUB_bLite
      VentanaLite.bStop.Enabled := .F.
   else
      VentanaMain.bStop.Enabled := .F.
   endif
   VentanaMain.TabFiles.Value := nPageSysout
   TabChange( 'FILES' )
   do while file( PUB_cProjectFolder + DEF_SLASH + '_' + PUB_cSecu + 'MSG.SYSIN' )
      US_Wait( 2 )
      DO EVENTS
   enddo
Return .T.

Function TabAutoSync( tab )
   Local bSync := GetProperty( 'VentanaMain', 'Check_AutoSync'+tab, 'Value' )
   bAutoSyncTab := bSync
   if !PUB_RunTabAutoSync
      Return .T.
   else
      PUB_RunTabAutoSync := .F.
   endif
   if !( tab == 'PRG' )
      VentanaMain.Check_AutoSyncPrg.Value := bSync
   endif
   if !( tab == 'HEA' )
      VentanaMain.Check_AutoSyncHea.Value := bSync
   endif
   if !( tab == 'PAN' )
      VentanaMain.Check_AutoSyncPan.Value := bSync
   endif
   if !( tab == 'DBF' )
      VentanaMain.Check_AutoSyncDbf.Value := bSync
   endif
   if !( tab == 'LIB' )
      VentanaMain.Check_AutoSyncLib.Value := bSync
   endif
   if !( tab == 'HLP' )
      VentanaMain.Check_AutoSyncHlp.Value := bSync
   endif
// if !( tab == 'SYSOUT' )
//    VentanaMain.Check_AutoSyncSysout.Value := bSync
// endif
// if !( tab == 'OUT' )
//    VentanaMain.Check_AutoSyncOut.Value := bSync
// endif
   PUB_RunTabAutoSync := .T.
   if bSync
      TabSync()
   endif
Return .T.

Function TabSync()
   VentanaMain.TabFiles.Value := VentanaMain.TabGrids.Value
   TabChange()
Return .T.

Function TabChange( cTabGroups )
   Local w_antes
   
   if !PUB_RunTabChange
      PUB_RunTabChange := .T.
      Return .F.
   endif
   if Prj_Radio_OutputType == DEF_RG_IMPORT
      if cTabGroups == 'GRIDS' .and. ;
         GetProperty( 'VentanaMain', 'TabGrids', 'value' ) > 1 .and. ;
         GetProperty( 'VentanaMain', 'TabGrids', 'value' ) < 6
         PUB_RunTabChange := .F.
         SetProperty( 'VentanaMain', 'TabGrids', 'value', 1 )
      endif
      if cTabGroups == 'FILES' .and. ;
         GetProperty( 'VentanaMain', 'TabFiles', 'value' ) > 1 .and. ;
         GetProperty( 'VentanaMain', 'TabFiles', 'value' ) < 6
         PUB_RunTabChange := .F.
         SetProperty( 'VentanaMain', 'TabFiles', 'value', 1 )
      endif
   endif

   if bAutoSyncTab
      if cTabGroups == 'FILES'
         PUB_RunTabChange := .F.
         SetProperty ( 'VentanaMain', 'TabGrids', 'Value', VentanaMain.TabFiles.Value )
      else
         if VentanaMain.TabFiles.Value < nPageSysout
            PUB_RunTabChange := .F.
            SetProperty( 'VentanaMain', 'TabFiles', 'Value', VentanaMain.TabGrids.Value )
         endif
      endif
   endif

   if VentanaMain.TabFiles.Value <> VentanaMain.TabGrids.Value
      VentanaMain.bSyncPrg.Show()
      VentanaMain.bSyncHea.Show()
      VentanaMain.bSyncPan.Show()
      VentanaMain.bSyncDbf.Show()
      VentanaMain.bSyncLib.Show()
#ifdef QPM_SHG
      VentanaMain.bSyncHlp.Show()
#endif
   else
      VentanaMain.bSyncPrg.Hide()
      VentanaMain.bSyncHea.Hide()
      VentanaMain.bSyncPan.Hide()
      VentanaMain.bSyncDbf.Hide()
      VentanaMain.bSyncLib.Hide()
#ifdef QPM_SHG
      VentanaMain.bSyncHlp.Hide()
#endif
   endif
   if VentanaMain.TabFiles.Value <> VentanaMain.TabGrids.Value .and. ;
      VentanaMain.TabFiles.Value < nPageSysOut
      VentanaMain.IBorde1PRG.Show()
      VentanaMain.IBorde1HEA.Show()
      VentanaMain.IBorde1PAN.Show()
      VentanaMain.IBorde1DBF.Show()
      VentanaMain.IBorde1LIB.Show()
#ifdef QPM_SHG
      VentanaMain.IBorde1HLP.Show()
#endif
   else
      VentanaMain.IBorde1PRG.Hide()
      VentanaMain.IBorde1HEA.Hide()
      VentanaMain.IBorde1PAN.Hide()
      VentanaMain.IBorde1DBF.Hide()
      VentanaMain.IBorde1LIB.Hide()
#ifdef QPM_SHG
      VentanaMain.IBorde1HLP.Hide()
#endif
   endif
   if VentanaMain.TabFiles.Value == nPageHlp
      VentanaMain.ItC_Cut.Enabled       := .T.
      VentanaMain.ItC_Paste.Enabled     := .T.
      VentanaMain.ItC_CutM.Enabled      := .T.
      VentanaMain.ItC_PasteM.Enabled    := .T.
      VentanaMain.ItC_Move.Enabled      := .T.
   else
      VentanaMain.ItC_Cut.Enabled       := .F.
      VentanaMain.ItC_Paste.Enabled     := .F.
      VentanaMain.ItC_CutM.Enabled      := .F.
      VentanaMain.ItC_PasteM.Enabled    := .F.
      VentanaMain.ItC_Move.Enabled      := .F.
   endif
   if !PUB_bIsProcessing
      if VentanaMain.TabGrids.Value == nPageHlp
         SetProperty( 'VentanaMain', 'save', 'enabled', .F. )
         SetProperty( 'VentanaMain', 'build', 'enabled', .F. )
         SetProperty( 'VentanaMain', 'EraseALL', 'enabled', .F. )
         SetProperty( 'VentanaMain', 'EraseOBJ', 'enabled', .F. )
         SetProperty( 'VentanaMain', 'BVerChange', 'enabled', .F. )
#ifdef QPM_SYNCRECOVERY
         SetProperty( 'VentanaMain', 'BTakeSyncRecovery', 'enabled', .F. )
#endif
      else
         SetProperty( 'VentanaMain', 'save', 'enabled', .T. )
         SetProperty( 'VentanaMain', 'build', 'enabled', .T. )
         SetProperty( 'VentanaMain', 'EraseALL', 'enabled', .T. )
         SetProperty( 'VentanaMain', 'EraseOBJ', 'enabled', .T. )
         SetProperty( 'VentanaMain', 'BVerChange', 'enabled', .T. )
#ifdef QPM_SYNCRECOVERY
         if VentanaMain.TabGrids.Value <= nPagePan
            SetProperty( 'VentanaMain', 'BTakeSyncRecovery', 'enabled', .T. )
         else
            SetProperty( 'VentanaMain', 'BTakeSyncRecovery', 'enabled', .F. )
         endif
#endif
      endif
   endif
#ifdef QPM_SHG
   OcultaHlpKeys()
#endif
   // este parche es hasta que se resuelva el problema de la barra de desplazamiento en el browse dentro de un page of tab
   if VentanaMain.TabFiles.Value == nPageDbf
      if _IsControlDefined( 'DbfBrowse', 'VentanaMain' )
         SetProperty( 'VentanaMain', 'DbfBrowse', 'visible', .T. )
      endif
   else
      if _IsControlDefined( 'DbfBrowse', 'VentanaMain' )
         SetProperty( 'VentanaMain', 'DbfBrowse', 'visible', .F. )
      endif
   endif
   // Fin parche
   do case
      case VentanaMain.TabGrids.Value == nPagePRG
         GBL_TabGridNameFocus := 'PRG'
      case VentanaMain.TabGrids.Value == nPageHEA
         GBL_TabGridNameFocus := 'HEA'
      case VentanaMain.TabGrids.Value == nPagePAN
         GBL_TabGridNameFocus := 'PAN'
      case VentanaMain.TabGrids.Value == nPageDBF
         GBL_TabGridNameFocus := 'DBF'
      case VentanaMain.TabGrids.Value == nPageLIB
         GBL_TabGridNameFocus := 'LIB'
      case VentanaMain.TabGrids.Value == nPageHLP
         GBL_TabGridNameFocus := 'HLP'

         if VentanaMain.GHlpFiles.ItemCount > 0
            VentanaMain.GHlpFiles.SetFocus
            w_antes := GetProperty( 'VentanaMain', 'GHlpFiles', 'Value' )
            SetProperty( 'VentanaMain', 'GHlpFiles', 'Value', 0 )
            SetProperty( 'VentanaMain', 'GHlpFiles', 'Value', w_antes )
         endif
      otherwise
         GBL_TabGridNameFocus := 'OTHER'
   endcase
Return .T.

Function TotCaption( cType, nValor )
   Local nPage := 0, cAux := '', nAux := 0
   do case
      case cType == 'PRG'
         nPage := nPagePrg
      case cType == 'HEA'
         nPage := nPageHea
      case cType == 'PAN'
         nPage := nPagePan
      case cType == 'DBF'
         nPage := nPageDbf
      case cType == 'LIB'
         nPage := nPageLib
#ifdef QPM_SHG
      case cType == 'HLP'
         nPage := nPageHlp
#endif
   endcase
   if !( nValor == 0 )
      if at( '(', VentanaMain.TabGrids.Caption( nPage ) ) > 0
         cAux := us_word( strtran( strtran( VentanaMain.TabGrids.Caption( nPage ), '(', '' ), ')', '' ), us_Words( VentanaMain.TabGrids.Caption( nPage ) ) )
      endif
      if !empty( cAux )
         nAux := val( cAux )
      endif
      nAux := nAux + nValor
   endif
   if nAux > 0
      VentanaMain.TabGrids.Caption( nPage ) := &('Page'+cType) + ' (' + alltrim( str( nAux ) ) + ')'
   else
      VentanaMain.TabGrids.Caption( nPage ) := &('Page'+cType)
   endif
Return .T.

Function PpoDisplay( bOnlyRenumering )
   Local ppoFile, nRow
   if empty( bOnlyRenumering )
      bOnlyRenumering := .F.
   endif
   if bPpoDisplayado .and. !bOnlyRenumering
      QPM_EditPPO()
   else
      if nRow == 0 .or. GetProperty( 'VentanaMain', 'GPrgFiles', 'Itemcount' ) == 0
         VentanaMain.RichEditPrg.Value := ''
      else
         nRow := GetProperty( 'VentanaMain', 'GPrgFiles', 'value' )
         if Upper( US_FileNameOnlyExt( GetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', nRow, NCOLPRGNAME ) ) ) == 'PRG'
            ppoFile := GetObjFolder() + DEF_SLASH + Us_FileNameOnlyName( GetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', nRow, NCOLPRGNAME ) ) + '.ppo'
            if file( ppoFile )
               if val( US_FileDateTime( ppoFile ) ) < val( US_FileDateTime( ChgPathToReal( GetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', nRow, NCOLPRGFULLNAME ) ) ) )
                  MsgInfo( 'Warning, date of prg file is more recent than date of creation of ppo file' + Hb_OsNewLine() + 'ReBuild the project after press Non-Incremental Button or after save prg file' )
               endif
               cPpoCaretPrg := alltrim( str( VentanaMain.RichEditPRG.CaretPos ) )
               VentanaMain.RichEditPrg.FontColor := DEF_COLORFONTPPO
               VentanaMain.RichEditPrg.BackColor := DEF_COLORBACKPPO
               VentanaMain.RichEditPRG.Value := Enumeracion( MemoRead( ppoFile ), 'PRG' )
               VentanaMain.RichEditPRG.CaretPos := 1
               VentanaMain.bReLoadPpo.caption := 'Edit PPO'
               bPpoDisplayado := .T.
            else
               MsgInfo( 'PreProcess file not found, ReBuild the project after press Non-Incremental Button or after save prg file' )
            endif
         else
            MsgInfo( 'PreProcess Files is only for PRG files' )
         endif
      endif
   endif
Return .t.

Function RichEditDisplay( tipo, bReload, nRow, bForce )
   Local DbfName
   Local IncName
// Local EXCName := ''
   Local aStru, x, DbfCode
   Local ListOut, cType := '', AuxRegistro
   Local nInx, LinesKeys, aLines
   Local MemoKeys
   if empty( nRow ) .and. !( tipo == 'OUT' )
      nRow := GetProperty( 'VentanaMain', 'G'+tipo+'Files', 'Value' )
   endif
   if nRow == NIL
      nRow := 0
   endif

   DbfName := ChgPathToReal( GetProperty( 'VentanaMain', 'GDbfFiles', 'Cell', nRow, NCOLDBFFULLNAME ) )
   IncName := ChgPathToReal( US_WordSubStr( GetProperty( 'VentanaMain', 'GIncFiles', 'Cell', nRow, NCOLINCFULLNAME ), 3 ) )
// EXCName := ChgPathToReal( US_WordSubstr( GetProperty( 'VentanaMain', 'GExcFiles', 'Cell', nRow, NCOLEXCNAME ), 3 ) )
   DEFAULT bReload TO .F.
   DEFAULT bForce  TO .F.
   do case
      case tipo == 'PRG'
         if nRow == 0
            VentanaMain.RichEditPrg.Value := ''
            Return .F.
         endif
         if bReload .and. bGlobalSearch
            SetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', nRow, NCOLPRGOFFSET, '0' )
            if GridImage( 'VentanaMain', 'GPrgFiles', nRow, NCOLPRGSTATUS, '?', PUB_nGridImgSearchOk )
               TotCaption( tipo, -1 )
            endif
            if GlobalSearch2( tipo, cLastGlobalSearch, nRow, bLastGlobalSearchFun, bLastGlobalSearchDbf )
               TotCaption( tipo, +1 )
            endif
         else
            if nGridPrgLastRow > 0
               LostRichEdit( 'PRG' )
            endif
            nGridPrgLastRow := nRow
         endif
         if GridImage( 'VentanaMain', 'GPrgFiles', nRow, NCOLPRGSTATUS, '?', PUB_nGridImgEdited )
            VentanaMain.RichEditPrg.BackColor := DEF_COLORBACKEXTERNALEDIT
            VentanaMain.RichEditPrg.FontColor := DEF_COLORFONTEXTERNALEDIT
         else
            VentanaMain.RichEditPrg.BackColor := DEF_COLORBACKPRG
            VentanaMain.RichEditPrg.FontColor := DEF_COLORFONTVIEW
         endif
         if Prj_Radio_OutputType == DEF_RG_IMPORT
            VentanaMain.RichEditPRG.Value := QPM_Wait( "ListModule( '" + ChgPathToReal( GetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', 1, NCOLPRGFULLNAME ) ) + "' )", 'Listing ...', NIL, .T. )
            VentanaMain.RichEditPRG.CaretPos := 1
         else
            bPpoDisplayado := .F.
            VentanaMain.RichEditPRG.Value := Enumeracion( MemoRead( ChgPathToReal( GetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', nRow, NCOLPRGFULLNAME ) ) ), tipo )
            VentanaMain.RichEditPRG.CaretPos := val( GetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', nRow, NCOLPRGOFFSET ) )
            VentanaMain.bReLoadPpo.caption := 'Browse PPO'
         endif
      case tipo == 'HEA'
         if nRow == 0
            VentanaMain.RichEditHea.Value := ''
            Return .F.
         endif
         if bReload .and. bGlobalSearch
            SetProperty( 'VentanaMain', 'GHeaFiles', 'Cell', nRow, NCOLHEAOFFSET, '0' )
        //  if !empty( cLastGlobalSearch )
        //  GridImage( 'VentanaMain', 'GHeaFiles', nRow, NCOLHEASTATUS, '-', PUB_nGridImgEdited )
            if GridImage( 'VentanaMain', 'GHeaFiles', nRow, NCOLHEASTATUS, '?', PUB_nGridImgSearchOk )
               TotCaption( tipo, -1 )
            endif
            if GlobalSearch2( tipo, cLastGlobalSearch, nRow, bLastGlobalSearchFun, bLastGlobalSearchDbf )
               TotCaption( tipo, +1 )
            endif
        //  endif
         else
            if nGridHeaLastRow > 0
               LostRichEdit( 'HEA' )
            endif
            nGridHeaLastRow := nRow
         endif
         if GridImage( 'VentanaMain', 'GHeaFiles', nRow, NCOLHEASTATUS, '?', PUB_nGridImgEdited )
            VentanaMain.RichEditHea.BackColor := DEF_COLORBACKEXTERNALEDIT
            VentanaMain.RichEditHea.FontColor := DEF_COLORFONTEXTERNALEDIT
         else
            VentanaMain.RichEditHea.BackColor := DEF_COLORBACKHEA
            VentanaMain.RichEditHea.FontColor := DEF_COLORFONTVIEW
         endif
         VentanaMain.RichEditHea.Value := Enumeracion( MemoRead( ChgPathToReal( GetProperty( 'VentanaMain', 'GHeaFiles', 'Cell', nRow, NCOLHEAFULLNAME ) ) ), tipo )
         VentanaMain.RichEditHea.CaretPos := val( GetProperty( 'VentanaMain', 'GHeaFiles', 'Cell', nRow, NCOLHEAOFFSET ) )
      case tipo == 'PAN'
         if nRow == 0
            VentanaMain.RichEditPan.Value := ''
            Return .F.
         endif
         if bReload .and. bGlobalSearch
            SetProperty( 'VentanaMain', 'GPanFiles', 'Cell', nRow, NCOLPANOFFSET, '0' )
            if GridImage( 'VentanaMain', 'GPanFiles', nRow, NCOLPANSTATUS, '?', PUB_nGridImgSearchOk )
               TotCaption( tipo, -1 )
            endif
            if GlobalSearch2( tipo, cLastGlobalSearch, nRow, bLastGlobalSearchFun, bLastGlobalSearchDbf )
               TotCaption( tipo, +1 )
            endif
         else
            if nGridPanLastRow > 0
               LostRichEdit( 'PAN' )
            endif
            nGridPanLastRow := nRow
         endif
         if GridImage( 'VentanaMain', 'GPanFiles', nRow, NCOLPANSTATUS, '?', PUB_nGridImgEdited )
            VentanaMain.RichEditPan.BackColor := DEF_COLORBACKEXTERNALEDIT
            VentanaMain.RichEditPan.FontColor := DEF_COLORFONTEXTERNALEDIT
         else
            VentanaMain.RichEditPan.BackColor := DEF_COLORBACKPAN
            VentanaMain.RichEditPan.FontColor := DEF_COLORFONTVIEW
         endif
         VentanaMain.RichEditPan.Value := Enumeracion( MemoRead( ChgPathToReal( GetProperty( 'VentanaMain', 'GPanFiles', 'Cell', nRow, NCOLPANFULLNAME ) ) ), tipo )
         VentanaMain.RichEditPan.CaretPos := val( GetProperty( 'VentanaMain', 'GPanFiles', 'Cell', nRow, NCOLPANOFFSET ) )
      case tipo == 'DBF'
         if nRow == 0
            VentanaMain.RichEditDbf.Value := ''
         // DefineRichEditForNotDbfView( 'DBF view is disable while Run Appl !!!' )
            Return .F.
         endif

         if _IsControlDefined( 'DbfBrowse', 'VentanaMain' )
            AuxRegistro := VentanaMain.DbfBrowse.Value
         else
            AuxRegistro := 1
         endif
         CloseDbfAutoView()
         if bGlobalSearch .and. bLastGlobalSearchDbf .and. bAvisoDbfGlobalSearchLow
            MsgInfo( "Last Global Search with 'Dbf Data' set true causes a very slow reload" + Hb_OsNewLine() + 'Use Reset Button for disable this option' )
            bAvisoDbfGlobalSearchLow := .F.
         endif
         if bReload .and. bGlobalSearch
            //GetProperty( 'VentanaMain', 'GDbfFiles', 'Cell', nRow, NCOLDBFOFFSET ) := '0 0'
            if GridImage( 'VentanaMain', 'GDbfFiles', nRow, NCOLDBFSTATUS, '?', PUB_nGridImgSearchOk )
               TotCaption( tipo, -1 )
            endif
            if GlobalSearch2( tipo, cLastGlobalSearch, nRow, bLastGlobalSearchFun, bLastGlobalSearchDbf )
               TotCaption( tipo, +1 )
            endif
         else
            if nGridDbfLastRow > 0
               LostRichEdit( 'DBF', AuxRegistro )
            endif
            nGridDbfLastRow := nRow
         endif
         if bReload
            bAvisoDbfDataSearchLow := .T.
            bDbfDataSearchAsk     := .T.
            cDbfDataSearchAskRpta := ''
         endif

         if GridImage( 'VentanaMain', 'GDbfFiles', nRow, NCOLDBFSTATUS, '?', PUB_nGridImgEdited )
            VentanaMain.RichEditDbf.BackColor := DEF_COLORBACKEXTERNALEDIT
            VentanaMain.RichEditDbf.FontColor := DEF_COLORFONTEXTERNALEDIT
         else
            VentanaMain.RichEditDbf.BackColor := DEF_COLORBACKDBF
            VentanaMain.RichEditDbf.FontColor := DEF_COLORFONTVIEW
         endif

         DbfCode := US_IsDBF( DbfName )
         If !( DbfCode == 0 )
            if DbfCode = 21   // open exclusive by another program
               VentanaMain.RichEditDbf.Value := Hb_OsNewLine() + ;
                                                Hb_OsNewLine() + ;
                                                Hb_OsNewLine() + ;
                                                Hb_OsNewLine() + ;
                                                Hb_OsNewLine() + ;
                                                Hb_OsNewLine() + ;
                                                "     Database '"+DbfName+"' is open EXCLUSIVE for another process .or. DBT file is missing"
            else
               VentanaMain.RichEditDbf.Value := Hb_OsNewLine() + ;
                                                Hb_OsNewLine() + ;
                                                Hb_OsNewLine() + ;
                                                Hb_OsNewLine() + ;
                                                Hb_OsNewLine() + ;
                                                Hb_OsNewLine() + ;
                                                "     Database '"+DbfName+"' is not valid DBF"
            endif
            DefineRichEditForNotDbfView( 'DBF Not Open !!!' )
         else
            VentanaMain.RichEditDbf.Value := Hb_OsNewLine() + ;
                                             'Structure for Database: '+DbfName + Hb_OsNewLine() + Hb_OsNewLine() + ;
                                             replicate( ' ', 22 ) + padr( 'Field', 15 )     + padr( 'Type', 4 ) + padl( 'Length', 8 )+ padl( 'Decimal', 8 ) + Hb_OsNewLine() + ;
                                             replicate( ' ', 22 ) + replicate( '=', 35 )

            US_Use( .T.,, DbfName, 'DbfAlias', DEF_DBF_SHARED, DEF_DBF_READ ) /* si lo pongo exclusive y write no funciona el search, revisarlo */
            aStru:=DBSTRUCT()
            vDbfJustify := {}
            vDbfHeaders := {}
            vDbfWidths  := {}
            FOR x:=1 TO LEN(aStru)
               aadd( vDbfJustify, if( aStru[x][2] == 'N', BROWSE_JTFY_RIGHT, BROWSE_JTFY_LEFT ) )
               aadd( vDbfHeaders, aStru[x][1] )
               aadd( vDbfWidths, if( aStru[x][3] > 20, 330, 90 ) )
               VentanaMain.RichEditDbf.Value := VentanaMain.RichEditDbf.Value + Hb_OsNewLine() + ;
                                                replicate( ' ', 22 ) + padr( aStru[x][1], 15 ) + padr( aStru[x][2], 4 ) + padl( aStru[x][3], 8 )+ padl( aStru[x][4], 8 )
            NEXT

            if ( bDbfAutoView .and. !bRunApp ) .or. bForce

               if _IsControlDefined( 'DbfAutoView', 'VentanaMain' )
                  VentanaMain.DbfAutoView.Release()
               endif

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
                //NOVSCROLL
            //    ON CHANGE ( GetProperty( 'VentanaMain', 'GDbfFiles', 'Cell', VentanaMain.GDbfFiles.Value, NCOLDBFSEARCH ) := '0 ** 0' )
            //    EDIT INPLACE
            //    ON HEADCLICK  { || us_log('headclick') } ;
            //    ON CHANGE  { || TBL_BrowseRefresh() } ;
            //    ON DBLCLICK  { || TBL_EjecutoDefault() }

               VentanaMain.TabFiles.AddControl( 'DbfBrowse', nPageDbf, GetDesktopRealHeight() - int( ( GetDesktopRealHeight() * 72 ) / 100 ), 10 )
               VentanaMain.DbfBrowse.DisableUpdate()
               VentanaMain.DbfBrowse.Width  := GetDesktopRealWidth() - 364
               VentanaMain.DbfBrowse.Height := ( GetDesktopRealHeight() - 237 ) - ( GetDesktopRealHeight() - int( ( GetDesktopRealHeight() * 72 ) / 100 ) )
               VentanaMain.DbfBrowse.value  := val( US_Word( GetProperty( 'VentanaMain', 'GDbfFiles', 'Cell', nRow, NCOLDBFOFFSET ), 2 ) )
               VentanaMain.DbfBrowse.EnableUpdate()
               VentanaMain.DbfBrowse.Refresh()
            else
               CloseDbfAutoView()
               if bRunApp
                  DefineRichEditForNotDbfView( 'DBF view is disable while Run Appl !!!' )
               else
                  DefineRichEditForNotDbfView( 'DBF AutoView is OFF !!!' )
               endif
            endif
         endif
         VentanaMain.BLocalSearchDbf.caption := 'Dbf Search'
         VentanaMain.BLocalSearchDbf.Tooltip := "Search in DBF's Data"
         VentanaMain.RichEditDbf.CaretPos := val( US_Word( GetProperty( 'VentanaMain', 'GDbfFiles', 'Cell', nRow, NCOLDBFOFFSET ), 1 ) )
      case tipo == 'INC'
         if nRow == 0
            VentanaMain.RichEditLib.Value := ''
            Return .F.
         endif
       //VentanaMain.RichEditLib.Value := ListModule( IncName )
         if !file( IncName )
            VentanaMain.RichEditLib.Value := Hb_OsNewLine() + ;
                                             Hb_OsNewLine() + ;
                                             Hb_OsNewLine() + ;
                                             Hb_OsNewLine() + ;
                                             Hb_OsNewLine() + ;
                                             Hb_OsNewLine() + ;
                                             "     Library '"+IncName+"' not found !!!"
         else
            do case
               case US_upper( US_FileNameOnlyExt( IncName ) ) == 'LIB'
                  cType := QPM_ModuleType( IncName ) + ' Library'
               case US_upper( US_FileNameOnlyExt( IncName ) ) == 'A'
                  cType := QPM_ModuleType( IncName ) + ' Library'
               case US_upper( US_FileNameOnlyExt( IncName ) ) == "OBJ"
                  cType := QPM_ModuleType( IncName ) + ' Object'
               case US_upper( US_FileNameOnlyExt( IncName ) ) == 'O'
                  cType := QPM_ModuleType( IncName ) + ' Object'
               otherwise
                  US_Log( 'Invalid Library extention' )
            endcase
            VentanaMain.RichEditLib.Value := Hb_OsNewLine() + ;
                                             Hb_OsNewLine() + ;
                                             Hb_OsNewLine() + ;
                                             Hb_OsNewLine() + ;
                                             Hb_OsNewLine() + ;
                                             Hb_OsNewLine() + ;
                                             "     Library '" + IncName + "'" + Hb_OsNewLine() + ;
                                             '             Size: ' + alltrim( Str( US_FileSize( IncName ) ) ) + Hb_OsNewLine() + ;
                                             '             Type: ' + cType + Hb_OsNewLine() + ;
                                             Hb_OsNewLine() + ;
                                             "             Press 'List Library/Object' button for view function in library or Object"
         endif
   // case tipo == 'EXC'
   //    if nRow == 0
   //       VentanaMain.RichEditLib.Value := ''
   //       Return .F.
   //    endif
   //    VentanaMain.RichEditLib.Value := Enumeracion( MemoRead( ChgPathToReal( GetProperty( 'VentanaMain', 'GExcFiles', 'Cell', nRow, NCOLEXCNAME ) ) ), tipo )
      case tipo == 'OUT'
         ListOut := GetOutputModuleName()
         if !file( ListOut )
            if file( ListOut + '.MOVED.TXT' )
               ListOut := US_WordSubStr( MemoRead( ListOut + '.MOVED.TXT' ), 7 )
            else
               VentanaMain.RichEditOut.Value := Hb_OsNewLine() + ;
                                                Hb_OsNewLine() + ;
                                                Hb_OsNewLine() + ;
                                                Hb_OsNewLine() + ;
                                                Hb_OsNewLine() + ;
                                                Hb_OsNewLine() + ;
                                                "     Output Module file not found: '" + ListOut + "' !!!"
               ListOut := ''
            endif
         endif
         if !empty( ListOut )
            do case
               case US_upper( US_FileNameOnlyExt( ListOut ) ) == 'LIB'
                  cType := QPM_ModuleType( ListOut ) + ' Library'
               case US_upper( US_FileNameOnlyExt( ListOut ) ) == 'A'
                  cType := QPM_ModuleType( ListOut ) + ' Library'
               case US_upper( US_FileNameOnlyExt( ListOut ) ) == 'EXE'
                  cType := 'Executable ' + QPM_ModuleType( ListOut )
               case US_upper( US_FileNameOnlyExt( ListOut ) ) == 'DLL'
                  cType := 'Dynamic Link Library'
               otherwise
                  MsgInfo( 'Error en Type for List Output' )
            endcase
            VentanaMain.RichEditOut.Value := Hb_OsNewLine() + ;
                                             Hb_OsNewLine() + ;
                                             Hb_OsNewLine() + ;
                                             Hb_OsNewLine() + ;
                                             Hb_OsNewLine() + ;
                                             Hb_OsNewLine() + ;
                                             "        File '" + ListOut + "'" + Hb_OsNewLine() + ;
                                             '             Size: ' + alltrim( Str( US_FileSize( ListOut ) ) ) + Hb_OsNewLine() + ;
                                             '             Type: ' + cType + Hb_OsNewLine() + ;
                                             Hb_OsNewLine() + ;
                                             "             Press 'List' button for expand this module info"
         endif
#ifdef QPM_SHG
      case tipo == 'HLP'
         if nRow == 0
            VentanaMain.RichEditHlp.Value := ''
            oHlpRichEdit:lChanged := .F.
            Return .F.
         endif
         if bReload .and. bGlobalSearch
            SetProperty( 'VentanaMain', 'GHlpFiles', 'Cell', nRow, NCOLHLPOFFSET, '0' )
            if GridImage( 'VentanaMain', 'GHlpFiles', nRow, NCOLHLPSTATUS, '?', PUB_nGridImgSearchOk )
               TotCaption( tipo, -1 )
            endif
            if GlobalSearch2( tipo, cLastGlobalSearch, nRow, bLastGlobalSearchFun, bLastGlobalSearchDbf )
               TotCaption( tipo, +1 )
            endif
         else
            if nGridHlpLastRow > 0
               if !bHlpMoving
                  if !bReload
                     LostRichEdit( 'HLP', nGridHlpLastRow )
                  endif
               endif
            endif
            if bGlobalSearch
               if GridImage( 'VentanaMain', 'GHlpFiles', nGridHlpLastRow, NCOLHLPSTATUS, '?', PUB_nGridImgSearchOk )
                  TotCaption( tipo, -1 )
               endif
               if GlobalSearch2( tipo, cLastGlobalSearch, nGridHlpLastRow, bLastGlobalSearchFun, bLastGlobalSearchDbf )
                  TotCaption( tipo, +1 )
               endif
            endif
            nGridHlpLastRow := nRow
         endif
         if GridImage( 'VentanaMain', 'GHlpFiles', nRow, NCOLHLPSTATUS, '?', PUB_nGridImgEdited )
            VentanaMain.RichEditHlp.BackColor := DEF_COLORBACKEXTERNALEDIT
            VentanaMain.RichEditHlp.FontColor := DEF_COLORFONTEXTERNALEDIT
         else
            VentanaMain.RichEditHlp.BackColor := DEF_COLORBACKHLP
            VentanaMain.RichEditHlp.FontColor := DEF_COLORFONTVIEW
         endif
         VentanaMain.RichEditHlp.Value := SHG_GetField( 'SHG_MEMOT', nRow )
         VentanaMain.RichEditHlp.CaretPos := val( GetProperty( 'VentanaMain', 'GHlpFiles', 'Cell', nRow, NCOLHLPOFFSET ) )
         oHlpRichEdit:US_EditRefreshButtons()
         oHlpRichEdit:lChanged := .F.
         MemoKeys := SHG_GetField( 'SHG_KEYST', VentanaMain.GHlpFiles.Value )
         LinesKeys := MLCount( MEmoKeys, 254 )
         aLines := {}
         For nInx := 1 to LinesKeys
            aAdd( aLInes, { MemoLine( MemoKeys, 254, nInx ) } )
         Next
         VentanaMain.GHlpKeys.DisableUpdate
         VentanaMain.GHlpKeys.DeleteAllItems
         For nInx := 1 to LinesKeys
            VentanaMain.GHlpKeys.AddItem( aLines[nInx] )
         Next
         VentanaMain.GHlpKeys.value := VentanaMain.GHlpFiles.ItemCount
         VentanaMain.GHlpKeys.EnableUpdate
         DoMethod( 'VentanaMain', 'GHlpKeys', 'ColumnsAutoFitH' )
#endif
      otherwise
         MsgInfo( 'Invalid type in RicheditDisplay: ' + US_VarToStr( tipo ) )
   endcase
Return .T.

#ifdef QPM_SHG
Function OcultaHlpKeys()
   do case
      case VentanaMain.GHlpFiles.Value < 2 .and. GetProperty( 'VentanaMain', 'TabFiles', 'Value' ) == nPageHlp
         VentanaMain.BAddHlpKey.Enabled    := .F.
         VentanaMain.BRemoveHlpKey.Enabled := .F.
         VentanaMain.GHlpKeys.Enabled      := .F.
         VentanaMain.ItC_AddHlpKey.Enabled := .F.
      case VentanaMain.GHlpFiles.Value > 1 .and. GetProperty( 'VentanaMain', 'TabFiles', 'Value' ) == nPageHlp
         VentanaMain.BAddHlpKey.Enabled    := .T.
         VentanaMain.BRemoveHlpKey.Enabled := .T.
         VentanaMain.GHlpKeys.Enabled      := .T.
         VentanaMain.ItC_AddHlpKey.Enabled := .T.
   endcase
   if GetProperty( 'VentanaMain', 'TabFiles', 'Value' ) == nPageHlp
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
   else
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
   endif
Return .T.
#endif

Function ListRichEditLib( LibName, RichEdit )
   SetProperty( 'VentanaMain', RichEdit, 'Value', QPM_Wait( "ListModule( '" + LibName + "' )", 'Listing ...', NIL, .T. ) )
Return .T.

Function ListModuleMoved( ModName )
   Local ListOut := ModName
   if ! file( ModName )
      if file( ModName + '.MOVED.TXT' )
         ListOut := US_WordSubStr( MemoRead( ModName + '.MOVED.TXT' ), 7 )
      endif
   endif
Return QPM_Wait( "ListModule( '" + ListOut + "' )", "Listing ...", NIL, .T. )

Function ListModule( ModName )
   Local MemoAux, TempExeType, LOC_RunWaitFileStop := US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + '_' + PUB_cSecu + 'RWFS' + US_DateTimeCen() + '.cnt'
   Local OrigModName := ModName, TempLibType
   if ! file( ModName )
      MemoAux := "File '" + ModName + "' not found !!!"
      Return MemoAux
   endif
   ferase( ModName + '.Tmp' )
   ferase( ModName + '.TmpOut' )
   if upper( US_FileNameOnlyExt( ModName ) ) == 'LIB'
      TempLibType := QPM_ModuleType( ModName )
      do case
         case TempLibType == 'PELLES'
            QPM_MemoWrit( RUN_FILE, US_ShortName(PUB_cQPM_Folder) + DEF_SLASH + 'US_PODUMP.EXE -LINKERMEMBER:2 -ARCHIVEMEMBERS ' + US_ShortName( ModName ) + ' > "' + US_ShortName( ModName ) + '.Tmp"' )
            QPM_Execute( RUN_FILE,, DEF_QPM_EXEC_WAIT, DEF_QPM_EXEC_MINIMIZE )
            ferase( RUN_FILE )

            QPM_MemoWrit( RUN_FILE, US_ShortName(PUB_cQPM_Folder) + DEF_SLASH + 'US_SHELL.EXE QPM ANALIZE_LIB_PELLES ' + US_ShortName( ModName ) + '.Tmp' + ' -FILESTOP ' + LOC_RunWaitFileStop + ' > "' + US_ShortName( ModName ) + '.TmpOut"' )
            QPM_Execute( RUN_FILE,, DEF_QPM_EXEC_WAIT, DEF_QPM_EXEC_MINIMIZE, LOC_RunWaitFileStop )
            ferase( RUN_FILE )
         case TempLibType == 'BORLAND'
            QPM_Execute( US_ShortName(PUB_cQPM_Folder) + DEF_SLASH + 'US_TLIB.EXE', US_ShortName( ModName ) + ', ' + US_ShortName( ModName ) + '.Tmp', DEF_QPM_EXEC_WAIT, DEF_QPM_EXEC_MINIMIZE )

            QPM_MemoWrit( RUN_FILE, US_ShortName(PUB_cQPM_Folder) + DEF_SLASH + 'US_SHELL.EXE QPM ANALIZE_LIB_BORLAND ' + US_ShortName( ModName ) + '.Tmp' + ' -FILESTOP ' + LOC_RunWaitFileStop + ' > "' + US_ShortName( ModName ) + '.TmpOut"' )
            QPM_Execute( RUN_FILE,, DEF_QPM_EXEC_WAIT, DEF_QPM_EXEC_MINIMIZE, LOC_RunWaitFileStop )
            ferase( RUN_FILE )
         case TempLibType == 'NONE'
            QPM_MemoWrit( ModName + '.TmpOut', 'File not found' )
         otherwise
            MsgStop( 'Unknown LIB type: ' + ModName )
      endcase
   endif
   if upper( US_FileNameOnlyExt( ModName ) ) == 'A'
      QPM_MemoWrit( RUN_FILE, US_ShortName(PUB_cQPM_Folder) + DEF_SLASH + 'US_OBJDUMP.EXE -t -s ' + US_ShortName( ModName ) + ' > "' + US_ShortName( ModName ) + '.Tmp"' )
      QPM_Execute( RUN_FILE,, DEF_QPM_EXEC_WAIT, DEF_QPM_EXEC_MINIMIZE )
      ferase( RUN_FILE )

      QPM_MemoWrit( RUN_FILE, US_ShortName(PUB_cQPM_Folder) + DEF_SLASH + 'US_SHELL.EXE QPM ANALIZE_LIB_MINGW ' + US_ShortName( ModName ) + '.Tmp' + ' -FILESTOP ' + LOC_RunWaitFileStop + ' > "' + US_ShortName( ModName ) + '.TmpOut"' )
      QPM_Execute( RUN_FILE,, DEF_QPM_EXEC_WAIT, DEF_QPM_EXEC_MINIMIZE, LOC_RunWaitFileStop )
      ferase( RUN_FILE )
   endif
   if upper( US_FileNameOnlyExt( ModName ) ) == 'DLL'
      QPM_Execute( US_ShortName(PUB_cQPM_Folder) + DEF_SLASH + 'US_IMPDEF.EXE', US_ShortName( ModName ) + '.Tmp ' + US_ShortName( ModName ), DEF_QPM_EXEC_WAIT, DEF_QPM_EXEC_MINIMIZE )

      QPM_MemoWrit( RUN_FILE, US_ShortName(PUB_cQPM_Folder) + DEF_SLASH + 'US_SHELL.EXE QPM -OFF ANALIZE_DLL ' + US_ShortName( ModName ) + '.Tmp' + ' -FILESTOP ' + LOC_RunWaitFileStop + ' > "' + US_ShortName( ModName ) + '.TmpOut"' )
      QPM_Execute( RUN_FILE,, DEF_QPM_EXEC_WAIT, DEF_QPM_EXEC_MINIMIZE, LOC_RunWaitFileStop )
      ferase( RUN_FILE )
   endif
   if upper( US_FileNameOnlyExt( ModName ) ) == 'EXE'
      TempExeType := QPM_ModuleType( ModName )
      if TempExeType == 'COMPRESSED'
         ListModuleUnUpx( US_ShortName( ModName ), US_ShortName( ModName ) + '.UnUpx.Exe' )
         ModName := US_Shortname( ModName ) + '.UnUpx.Exe'
         TempExeType := QPM_ModuleType( ModName )
      endif
      do case
      case TempExeType == 'BORLAND'
         QPM_MemoWrit( RUN_FILE, US_ShortName(PUB_cQPM_Folder) + DEF_SLASH + 'US_TDUMP.EXE ' + US_ShortName( ModName ) + ' > "' + US_ShortName( ModName ) + '.TmpOut"' )
         QPM_Execute( RUN_FILE,, DEF_QPM_EXEC_WAIT, DEF_QPM_EXEC_MINIMIZE )
         ferase( RUN_FILE )
      case TempExeType == 'PELLES'
      // QPM_MemoWrit( RUN_FILE, US_ShortName(PUB_cQPM_Folder) + DEF_SLASH + 'US_PODUMP.EXE /ALL ' + US_ShortName( ModName ) + ' > "' + US_ShortName( ModName ) + '.TmpOut"' )
         QPM_MemoWrit( RUN_FILE, US_ShortName(PUB_cQPM_Folder) + DEF_SLASH + 'US_TDUMP.EXE ' + US_ShortName( ModName ) + ' > "' + US_ShortName( ModName ) + '.TmpOut"' )
         QPM_Execute( RUN_FILE,, DEF_QPM_EXEC_WAIT, DEF_QPM_EXEC_MINIMIZE )
         ferase( RUN_FILE )
      case TempExeType == 'MINGW'
       //QPM_MemoWrit( RUN_FILE, US_ShortName(PUB_cQPM_Folder) + DEF_SLASH + 'US_OBJDUMP.EXE -x ' + US_ShortName( ModName ) + ' > "' + US_ShortName( ModName ) + '.TmpOut"' )
         QPM_MemoWrit( RUN_FILE, US_ShortName(PUB_cQPM_Folder) + DEF_SLASH + 'US_TDUMP.EXE ' + US_ShortName( ModName ) + ' > "' + US_ShortName( ModName ) + '.TmpOut"' )
         QPM_Execute( RUN_FILE,, DEF_QPM_EXEC_WAIT, DEF_QPM_EXEC_MINIMIZE )
         ferase( RUN_FILE )
      case TempExeType == 'NONE'
         QPM_MemoWrit( ModName + '.TmpOut', 'File not found' )
      otherwise
         MsgStop( 'Unknown EXE type: ' + OrigModName )
      endcase
   endif
   MemoAux := MemoRead( US_ShortName( ModName ) + '.TmpOut' )
   ferase( US_ShortName( ModName ) + '.Tmp' )
   ferase( US_ShortName( ModName ) + '.TmpOut' )
   ferase( US_ShortName( OrigModName ) + '.TmpOut' )
   ferase( US_ShortName( OrigModName ) + '.UnUpx.Exe' )
Return MemoAux

Function ListModuleUnUpx( cIn, cOut )
   QPM_MemoWrit( RUN_FILE, US_ShortName(PUB_cQPM_Folder) + DEF_SLASH + 'US_UPX.EXE -d -o' + cOut + ' ' + cIn + ' > "' + cIn + '.TmpOut"' )
   QPM_Execute( RUN_FILE,, DEF_QPM_EXEC_WAIT, DEF_QPM_EXEC_MINIMIZE )
   ferase( RUN_FILE )
Return .T.

Function LocalSearch( Txt, bFunc )
   Local cTab := '', PositionAux := 0
   Local Resultado := {}, CaretAnt

 //#define EM_SETSEL   177

   DEFAULT bFunc TO .F.
   if empty( Txt )
      MsgInfo( 'Empty Text for Search ...' )
      Return .F.
   endif
   AddSearchTxt()
   do case
      case VentanaMain.TabFiles.value == nPagePrg
         cTab := 'PRG'
      case VentanaMain.TabFiles.value == nPageHea
         cTab := 'HEA'
      case VentanaMain.TabFiles.value == nPagePan
         cTab := 'PAN'
      case VentanaMain.TabFiles.value == nPageDbf
         cTab := 'DBF'
      case VentanaMain.TabFiles.value == nPageLib
         cTab := 'LIB'
      case VentanaMain.TabFiles.value == nPageSysOut
         cTab := 'SYSOUT'
      case VentanaMain.TabFiles.value == nPageOut
         cTab := 'OUT'
#ifdef QPM_SHG
      case VentanaMain.TabFiles.value == nPageHlp
         cTab := 'HLP'
#endif
      otherwise
         MsgInfo( 'Error in function LocalSearch, TabFile invalid: ' + US_VarToStr( VentanaMain.TabFiles.value ) )
   endcase
   if bFunc .and. !( cTab == 'PRG' )
      MsgInfo( 'Error in Local Search, invalid bFunc in true with cTab equal '+cTab )
      Return .F.
   endif
   CaretAnt := GetProperty( 'VentanaMain', 'RichEdit'+cTab, 'CaretPos' )
   if bFunc
      VentanaMain.Check_SearchCas.Value := bLastGlobalSearchCas := .F.
      GlobalSearch2( 'PRG', Txt, GetProperty( 'VentanaMain', 'G'+cTab+'Files', 'Value' ), .T.,,,,, @PositionAux )
      PositionAux--
      aadd( Resultado, PositionAux )
      aadd( Resultado, PositionAux )
      aadd( Resultado, PositionAux )
      if Resultado[1] > 0
         SetProperty( 'VentanaMain', 'RichEdit'+cTab, 'CaretPos', PositionAux )
         FindChr( GetControlHandle ( 'RichEdit'+cTab, 'VentanaMain' ), Txt, .T., .F., bLastGlobalSearchCas, .T. )
      endif
   else
      bLastGlobalSearchCas := VentanaMain.Check_SearchCas.Value
      Resultado := FindChr( GetControlHandle( 'RichEdit'+cTab, 'VentanaMain' ), Txt, .T., .F., bLastGlobalSearchCas, .T. )
   endif
   if Resultado[3] < 0
      if CaretAnt == 0
         MsgOk( 'QPM (QAC based Project Manager)', 'Text not found.', 'E', .T., 2 )
      else
         MsgOk( 'QPM (QAC based Project Manager)', 'Text not found.' + Hb_OsNewLine() + 'Restart search from top.', 'W', .T., 2 )
      endif
      SetProperty( 'VentanaMain', 'RichEdit'+cTab, 'CaretPos', CaretAnt )
      Return .F.
   endif
Return .T.

Function DbfDataSearch( Txt )
   Local nRecord := 0, cFieldName := '', nFieldPos := 0, cFieldTxt := ''
   Local nOldValue := VentanaMain.GDbfFiles.Value
   Local nOldRecord
   Local nAuxRecord
   Local cTypeDbfSearch := 'R'  /* Record Base Type */
   if VentanaMain.GDbfFiles.Value < 1
      MsgInfo( 'No DBF has been selected.' )
      Return .F.
   endif
   if empty( Txt )
      MsgInfo( 'No text for Search has been entered.' )
      Return .F.
   endif
   nOldRecord := VentanaMain.DbfBrowse.Value
   nAuxRecord := nOldRecord
   AddSearchTxt()
   if bAvisoDbfDataSearchLow .or. !( val( US_Word( GetProperty( 'VentanaMain', 'GDbfFiles', 'Cell', VentanaMain.GDbfFiles.Value, NCOLDBFSEARCH ), 1 ) ) == nOldRecord )
      if ! MyMsgYesNo( "Search 'Dbf Data' is very slow. Do you want to continue ?" )
         Return .F.
      endif
      bAvisoDbfDataSearchLow := .F.
      bDbfDataSearchAsk  := .T.
   else
      if !( bDbfDataSearchAsk )
         cTypeDbfSearch := cDbfDataSearchAskRpta
      else
         SetMGWaitHide()
         if ( cTypeDbfSearch := LocalSearchContinue() ) == ''
            SetMGWaitShow()
            Return .F.
         else
            if !( bDbfDataSearchAsk )
               cDbfDataSearchAskRpta := cTypeDbfSearch
            endif
         endif
         SetMGWaitShow()
      endif
      if cTypeDbfSearch == 'R'
         nAuxRecord++
      endif
   Endif
   VentanaMain.RichEditDbf.BackColor := DEF_COLORBACKDBFSEARCHOK
   if GlobalSearch2( 'DBF', Txt, VentanaMain.GDbfFiles.Value, NIL, .T., cTypeDbfSearch, nAuxRecord, @nRecord, @cFieldName, @nFieldPos, @cFieldTxt )
      DBSelectarea( 'DbfAlias' )
      VentanaMain.DbfBrowse.Value := nRecord
      VentanaMain.DbfBrowse.Refresh()
#IFDEF __XHARBOUR__
      VentanaMain.RichEditDbf.Value := '     ' + Hb_OsNewLine() + ;
                                       '     ' + Hb_OsNewLine() + ;
                                       '     Text found at record: ' + alltrim( str( nRecord ) ) + Hb_OsNewLine() + ;
                                       '     Field: ' + cFieldName + Hb_OsNewLine() + ;
                                       '     Position: ' + alltrim( str( nFieldPos ) ) + Hb_OsNewLine() + ;
                                       '     Content: ' + substr( cFieldTxt, at( us_upper( Txt ), US_Upper( cFieldTxt ), nFieldPos ), 200 ) + Hb_OsNewLine()
#ELSE
      VentanaMain.RichEditDbf.Value := '     ' + Hb_OsNewLine() + ;
                                       '     ' + Hb_OsNewLine() + ;
                                       '     Text found at record: ' + alltrim( str( nRecord ) ) + Hb_OsNewLine() + ;
                                       '     Field: ' + cFieldName + Hb_OsNewLine() + ;
                                       '     Position: ' + alltrim( str( nFieldPos ) ) + Hb_OsNewLine() + ;
                                       '     Content: ' + substr( cFieldTxt, hb_at( us_upper( Txt ), US_Upper( cFieldTxt ), nFieldPos ), 200 ) + Hb_OsNewLine()
#ENDIF

      VentanaMain.RichEditDbf.CaretPos := 1
      FindChr( GetControlHandle ( 'RichEditDbf', 'VentanaMain' ), VentanaMain.CSearch.DisplayValue, FindChr( GetControlHandle ( 'RichEditDbf', 'VentanaMain' ), 'Content: ', .T., .F., bLastGlobalSearchCas, .T. ), .F., bLastGlobalSearchCas, .T. )
      SetProperty( 'VentanaMain', 'GDbfFiles', 'Cell', VentanaMain.GDbfFiles.Value, NCOLDBFSEARCH, alltrim( str( nRecord ) ) + ' ' + cFieldName + ' ' + alltrim( str( nFieldPos ) ) )
      DoMethod( 'VentanaMain', 'GDbfFiles', 'ColumnsAutoFitH' )
      VentanaMain.BLocalSearchDbf.caption := 'Continue Search'
      VentanaMain.BLocalSearchDbf.Tooltip := "Continue searching in DBF's data. To reset use " + DBLQT + "Force Display Dbf"  + DBLQT + "button"
      Return .T.
   endif
   SetMGWaitHide()
   if nOldRecord == 1
      MsgOk( 'QPM (QAC based Project Manager)', 'Text not found', 'E', .T., 2 )
      bAvisoDbfDataSearchLow := .T.
      VentanaMain.RichEditDbf.Value := '     ' + Hb_OsNewLine() + ;
                                       '     Text not found in DBF data'
  //  if !( US_Word( GetProperty( 'VentanaMain', 'GDbfFiles', 'Cell', VentanaMain.GDbfFiles.Value, NCOLDBFSEARCH ), 1 ) == '0' )
  //     VentanaMain.RichEditDbf.Value := '     ' + Hb_OsNewLine() + ;
  //                                      '     Text not found in DBF data'
  //     GetProperty( 'VentanaMain', 'GDbfFiles', 'Cell', VentanaMain.GDbfFiles.Value, NCOLDBFSEARCH ) := '0 ** 0'
  //  endif
   else
      MsgOk( 'QPM (QAC based Project Manager)', 'Text not found'+Hb_OsNewLine()+'Re-Search from Top', 'W', .T., 2 )
      VentanaMain.RichEditDbf.Value := '     ' + Hb_OsNewLine() + ;
                                       '     Text not found in DBF data from record ' + alltrim( str( nOldRecord ) ) + Hb_OsNewLine() + ;
                                       '     Re-Search from Top Record'
    //GetProperty( 'VentanaMain', 'GDbfFiles', 'Cell', VentanaMain.GDbfFiles.Value, NCOLDBFSEARCH ) := '0 ** 0'
   endif
   VentanaMain.DbfBrowse.Value := nOldRecord
   bDbfDataSearchAsk     := .T.
   cDbfDataSearchAskRpta := ''
   VentanaMain.BLocalSearchDbf.caption := 'New Dbf Search'
   VentanaMain.BLocalSearchDbf.Tooltip := 'Search in DBF data from the beginning. To reset use "Force Display Dbf" button'
   VentanaMain.GDbfFiles.Value := nOldValue
   DoMethod( 'VentanaMain', 'GDbfFiles', 'ColumnsAutoFitH' )
Return .F.

Function GlobalSearch( Txt )
   Local i
   Local nFound, bSearchDbfData
   if empty( Txt )
      MsgInfo( 'Empty Text for Search ...' )
      Return .F.
   endif
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

   if bLastGlobalSearchFun
      nFound := 0
      TotCaption( 'PRG', 0 )
      For i:=1 to VentanaMain.GPrgFiles.ItemCount
         if GlobalSearch2( 'PRG', Txt, i, .T. )
            nFound++
         endif
      Next i
      TotCaption( 'PRG', nFound )
      Return .T.
   else
      nFound := 0
      TotCaption( 'PRG', 0 )
      For i:=1 to VentanaMain.GPrgFiles.ItemCount
         if GlobalSearch2( 'PRG', Txt, i )
            nFound++
         endif
      Next i
      TotCaption( 'PRG', nFound )
   endif

   nFound := 0
   TotCaption( 'HEA', 0 )
   For i:=1 to VentanaMain.GHeaFiles.ItemCount
      if GlobalSearch2( 'HEA', Txt, i )
         nFound++
      endif
   Next i
   TotCaption( 'HEA', nFound )
   
   nFound := 0
   TotCaption( 'PAN', 0 )
   For i:=1 to VentanaMain.GPanFiles.ItemCount
      if GlobalSearch2( 'PAN', Txt, i )
         nFound++
      endif
   Next i
   TotCaption( 'PAN', nFound )
   /* */
   nFound := 0
// VentanaMain.Check_SearchDbf.value := bSearchDbfData
   TotCaption( 'DBF', 0 )
   if bSearchDbfData
      if ! MyMsgYesNo( "Global Search with 'Dbf Data' set true is very slow.  Do you want to continue ?" )
         VentanaMain.Check_SearchDbf.value := .F.
         bLastGlobalSearchDbf := .F.
         Return .F.
      endif
   endif
   if bSearchDbfData
      bAvisoDbfGlobalSearchLow := .T.
   endif
   For i:=1 to VentanaMain.GDbfFiles.ItemCount
      if GlobalSearch2( 'DBF', Txt, i,, bSearchDbfData )
         nFound++
      endif
   Next i
   TotCaption( 'DBF', nFound )
   VentanaMain.Check_SearchDbf.value := bSearchDbfData
   bAvisoDbfGlobalSearchLow := .T.

   nFound := 0
   TotCaption( 'LIB', 0 )
   For i:=1 to VentanaMain.GIncFiles.ItemCount
      if GlobalSearch2( 'LIB', Txt, i )
         nFound++
      endif
   Next i
   TotCaption( 'LIB', nFound )

   nFound := 0
   TotCaption( 'HLP', 0 )
   if SHG_BaseOk
      if ! MyMsgYesNo( 'Skip search of Help Topics ?', nil, .T. )
         For i:=1 to VentanaMain.GHlpFiles.ItemCount
            if GlobalSearch2( 'HLP', Txt, i )
               nFound++
            endif
         Next i
         TotCaption( 'HLP', nFound )
      endif
   endif

   QPM_CheckFiles()
Return .T.

Function GlobalSearch2( cType, Txt, nRow, bFunc, bDbfData, DBFcBaseType, nRecordBase, nRecordFound, cFieldNameFound, nFieldPosFound, cFieldTxtFound )
   Local Pos, MemoAux, x, LineAux, nWord, vAux, nPosition
   Local bSalir, nPosAux
   Local bFound := .F., bChangeImg
   Local aStru, DbfName, DbfCode
   Local cFieldBase, nPosBase, columnValid
   DEFAULT bFunc        TO .F.
   DEFAULT bDbfData     TO .F.
   DEFAULT DBFcBaseType TO 'R' /* R : Record, F : Filed, P : Position */
   DEFAULT nRecordBase  TO 1
   SetMGWaitTxt( 'Searching: ' + ChgPathToReal( GetProperty( 'VentanaMain', 'G' + if( cType == 'LIB', 'INC', cType ) + 'Files', 'Cell', nRow, &( 'nCol'+cType+if(cType=='HLP','Topic','FullName') ) ) ) )
   if bGlobalSearch
      bChangeImg := .T.
   else
      bChangeImg := .F.
   endif
   nFieldPosFound := 0
   if bFunc .and. ( Prj_Radio_OutputType == DEF_RG_EXE .or. Prj_Radio_OutputType == DEF_RG_LIB )
      VentanaMain.Check_SearchCas.Value := bLastGlobalSearchCas := .F.
      if bChangeImg
         GridImage( 'VentanaMain', 'GPrgFiles', nRow, NCOLPRGSTATUS, '-', PUB_nGridImgSearchOk )
      endif
      MemoAux := us_upper( MemoRead( ChgPathToReal( GetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', nRow, NCOLPRGFULLNAME ) ) ) )
      bSalir := .F.
      nPosition := 1

#IFDEF __XHARBOUR__
      do while ( Pos := at( us_upper( Txt ), MemoAux, nPosition ) ) > 0 .and. !bSalir
#ELSE
      do while ( Pos := hb_at( us_upper( Txt ), MemoAux, nPosition ) ) > 0 .and. !bSalir
#ENDIF
         nPosition := Pos + 1
         vAux := MPOSTOLC( MemoAux, 254, Pos )
         LineAux := MemoLine( MemoAux, 254, vAux[1] )
         if at( us_upper( Txt ), LineAux ) > 0 .and. ;
            ( at( 'PROCEDURE',   LineAux ) > 0 .or. ;
              at( 'PROC',        LineAux ) > 0 .or. ;
              at( 'FUNCTION',    LineAux ) > 0 .or. ;
              at( 'FUNC',        LineAux ) > 0 .or. ;
              at( 'METHOD',      LineAux ) > 0 .or. ;
              at( 'METH',        LineAux ) > 0 )
            if US_Word( LineAux, 1 ) == 'STATIC'
               nWord := 2
            else
               nWord := 1
            endif
            if ( ( US_Word( LineAux, nWord ) == 'PROCEDURE' ) .or. ;
                 ( US_Word( LineAux, nWord ) == 'PROC' ) .or. ;
                 ( US_Word( LineAux, nWord ) == 'FUNCTION' ) .or. ;
                 ( US_Word( LineAux, nWord ) == 'FUNC' ) .or. ;
                 ( US_Word( LineAux, nWord ) == 'METHOD' ) .or. ;
                 ( US_Word( LineAux, nWord ) == 'METH' ) ) .and. ;
               ( ( at( US_Upper( Txt ) + '(', substr( LineAux, US_WordInd( LineAux, nWord + 1 ) ) ) = 1 ) .or. ;
                 ( at( US_Upper( Txt ) + ' ', substr( LineAux, US_WordInd( LineAux, nWord + 1 ) ) ) = 1 ) )
               if bChangeImg
                  GridImage( 'VentanaMain', 'GPrgFiles', nRow, NCOLPRGSTATUS, '+', PUB_nGridImgSearchOk )
               endif
               bSalir := .T.
               bFound := .T.
               nFieldPosFound := MLCTOPOS( MemoAux, 254, vAux[1], US_WordInd( LineAux, nWord + 1 ) )       // - vAux[1]
            // nFieldPosFound := MLCTOPOS( MemoRead( ChgPathToReal( GetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', nRow, NCOLPRGFULLNAME ) ) ), 254, vAux[1], US_WordInd( LineAux, nWord + 1 ) ) // - vAux[1]
            endif
         endif
      enddo
   else
      do case
         case cType == 'PRG'
            if bLastGlobalSearchCas
               if Prj_Radio_OutputType == DEF_RG_IMPORT
                  nPosAux := at( Txt, GetProperty( 'VentanaMain', 'RichEditPRG', 'value' ) )
               else
                  nPosAux := at( Txt, MemoRead( ChgPathToReal( GetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', nRow, NCOLPRGFULLNAME ) ) ) )
               endif
            else
               if Prj_Radio_OutputType == DEF_RG_IMPORT
                  nPosAux := at( US_upper( Txt ), US_upper( GetProperty( 'VentanaMain', 'RichEditPRG', 'value' ) ) )
               else
                  nPosAux := at( US_upper( Txt ), US_upper( MemoRead( ChgPathToReal( GetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', nRow, NCOLPRGFULLNAME ) ) ) ) )
               endif
            endif
            if nPosAux > 0
               if bChangeImg
                  GridImage( 'VentanaMain', 'GPrgFiles', nRow, NCOLPRGSTATUS, '+', PUB_nGridImgSearchOk )
               endif
               bFound := .T.
            else
               if bChangeImg
                  GridImage( 'VentanaMain', 'GPrgFiles', nRow, NCOLPRGSTATUS, '-', PUB_nGridImgSearchOk )
               endif
            endif
         case cType == 'HEA'
            if bLastGlobalSearchCas
               nPosAux := at( Txt, MemoRead( ChgPathToReal( GetProperty( 'VentanaMain', 'GHeaFiles', 'Cell', nRow, NCOLHEAFULLNAME ) ) ) )
            else
               nPosAux := at( US_upper( Txt ), US_upper( MemoRead( ChgPathToReal( GetProperty( 'VentanaMain', 'GHeaFiles', 'Cell', nRow, NCOLHEAFULLNAME ) ) ) ) )
            endif
            if nPosAux > 0
               if bChangeImg
                  GridImage( 'VentanaMain', 'GHeaFiles', nRow, NCOLHEASTATUS, '+', PUB_nGridImgSearchOk )
               endif
               bFound := .T.
            else
               if bChangeImg
                  GridImage( 'VentanaMain', 'GHeaFiles', nRow, NCOLHEASTATUS, '-', PUB_nGridImgSearchOk )
               endif
            endif
         case cType == 'PAN'
            if bLastGlobalSearchCas
               nPosAux := at( Txt, MemoRead( ChgPathToReal( GetProperty( 'VentanaMain', 'GPanFiles', 'Cell', nRow, NCOLPANFULLNAME ) ) ) )
            else
               nPosAux := at( US_upper( Txt ), US_upper( MemoRead( ChgPathToReal( GetProperty( 'VentanaMain', 'GPanFiles', 'Cell', nRow, NCOLPANFULLNAME ) ) ) ) )
            endif
            if nPosAux > 0
               if bChangeImg
                  GridImage( 'VentanaMain', 'GPanFiles', nRow, NCOLPANSTATUS, '+', PUB_nGridImgSearchOk )
               endif
               bFound := .T.
            else
               if bChangeImg
                  GridImage( 'VentanaMain', 'GPanFiles', nRow, NCOLPANSTATUS, '-', PUB_nGridImgSearchOk )
               endif
            endif
         case cType == 'DBF'
            DbfName := ChgPathToReal( GetProperty( 'VentanaMain', 'GDbfFiles', 'Cell', nRow, NCOLDBFFULLNAME ) )
            DbfCode := US_IsDBF( DbfName )
            If DbfCode = 0
               US_Use( .T.,, DbfName, 'DSearch', DEF_DBF_SHARED, DEF_DBF_READ ) /* si pongo exclusive y write no funciona el search, revisarlo */
               aStru := DBSTRUCT()
               if ! bDbfData
                  VentanaMain.Check_SearchCas.Value := bLastGlobalSearchCas := .F.
                  FOR x := 1 TO LEN( aStru )
                     if at( US_upper( Txt ), aStru[x][1] ) > 0
                        bFound := .T.
                        exit
                     endif
                  NEXT x
               else
                  cFieldBase  := ''
                  if DBFcBaseType == 'F'   /* Field base type */
                     cFieldBase  := US_Word( GetProperty( 'VentanaMain', 'GDbfFiles', 'Cell', nRow, NCOLDBFSEARCH ), 2 )
                  endif
                  if DBFcBaseType == 'P'   /* Position base type */
                     cFieldBase  := US_Word( GetProperty( 'VentanaMain', 'GDbfFiles', 'Cell', nRow, NCOLDBFSEARCH ), 2 )
                  endif
                  DBGoTo( nRecordBase )
                  columnValid := .F.
                  if DBFcBaseType == 'R'  /* Record base type */
                     columnValid := .T.
                  endif
                  Do while !eof()
                     FOR x:=1 TO LEN(aStru)
                        if DBFcBaseType == 'F' .and. !columnValid        /* Field base type */
                           if aStru[x][1] == cFieldBase
                              columnValid := .T.
                              loop
                           endif
                        endif
                        nPosBase := 1
                        if DBFcBaseType == 'P' .and. !columnValid        /* Position base type */
                           if aStru[x][1] == cFieldBase
                              nPosBase := val( US_Word( GetProperty( 'VentanaMain', 'GDbfFiles', 'Cell', nRow, NCOLDBFSEARCH ), 3 ) ) + 1
                              columnValid := .T.
                           endif
                        endif
                        if columnValid
                           if bLastGlobalSearchCas
#IFDEF __XHARBOUR__
                              nPosAux := at( Txt, US_VarToStr( &( aStru[x][1] ) ), nPosBase )
#ELSE
                              nPosAux := hb_at( Txt, US_VarToStr( &( aStru[x][1] ) ), nPosBase )
#ENDIF
                           else
#IFDEF __XHARBOUR__
                              nPosAux := at( US_Upper( Txt ), US_Upper( US_VarToStr( &( aStru[x][1] ) ) ), nPosBase )
#ELSE
                              nPosAux := hb_at( US_Upper( Txt ), US_Upper( US_VarToStr( &( aStru[x][1] ) ) ), nPosBase )
#ENDIF
                           endif
                           if nPosAux > 0
                              bFound := .T.
                              nRecordFound      := RecNo()
                              cFieldNameFound   := aStru[x][1]
                              nFieldPosFound    := nPosAux
                              cFieldTxtFound    := US_VarToStr( &( aStru[x][1] ) )
                              exit
                           endif
                        endif
                     Next x
                     if bFound
                        exit
                     endif
                     DBSkip( 1 )
                  enddo
               endif
               DBCloseArea( 'DSearch' )
            endif
            if bFound
               if bChangeImg
                  GridImage( 'VentanaMain', 'GDbfFiles', nRow, NCOLDBFSTATUS, '+', PUB_nGridImgSearchOk )
               endif
               bFound := .T.
            else
               if bChangeImg
                  GridImage( 'VentanaMain', 'GDbfFiles', nRow, NCOLDBFSTATUS, '-', PUB_nGridImgSearchOk )
               endif
            endif
         case cType == 'LIB'
            if bLastGlobalSearchCas
               nPosAux := at( Txt, MemoRead( ChgPathToReal( GetProperty( 'VentanaMain', 'GIncFiles', 'Cell', nRow, NCOLINCFULLNAME ) ) ) )
            else
               nPosAux := at( US_Upper( Txt ), US_Upper( MemoRead( ChgPathToReal( GetProperty( 'VentanaMain', 'GIncFiles', 'Cell', nRow, NCOLINCFULLNAME ) ) ) ) )
            endif
            if nPosAux > 0
               if bChangeImg
                  GridImage( 'VentanaMain', 'GIncFiles', nRow, NCOLINCSTATUS, '+', PUB_nGridImgSearchOk )
               endif
               bFound := .T.
            else
               if bChangeImg
                  GridImage( 'VentanaMain', 'GIncFiles', nRow, NCOLINCSTATUS, '-', PUB_nGridImgSearchOk )
               endif
            endif
#ifdef QPM_SHG
         case cType == 'HLP'
            if bLastGlobalSearchCas
               nPosAux := at( Txt, US_RTF2TXT( SHG_GetField( 'SHG_MEMOT', nRow ) ) )
            else
               nPosAux := at( US_Upper( Txt ), US_Upper( US_RTF2TXT( SHG_GetField( 'SHG_MEMOT', nRow ) ) ) )
            endif
            if nPosAux > 0
               if bChangeImg
                  GridImage( 'VentanaMain', 'GHlpFiles', nRow, NCOLHLPSTATUS, '+', PUB_nGridImgSearchOk )
               endif
               bFound := .T.
            else
               if bChangeImg
                  GridImage( 'VentanaMain', 'GHlpFiles', nRow, NCOLHLPSTATUS, '-', PUB_nGridImgSearchOk )
               endif
            endif
#endif
         otherwise
            MsgInfo( 'Invalid type in GlobalSearch2: ' + cType )
      endcase
   endif
Return bFound

Function ResetImgGrid( cGrid )
   Local i
   if empty( cGrid )
      cGrid := '*'
   endif
   VentanaMain.BGlobalReset.enabled    := .F.
   VentanaMain.Check_SearchFun.enabled := .T.
   VentanaMain.Check_SearchDbf.enabled := .T.
   VentanaMain.Check_SearchCas.enabled := .T.
   VentanaMain.LGlobal.visible         := .F.
   bGlobalSearch         := .F.
   bLastGlobalSearchDbf  := .F.
   bAvisoDbfGlobalSearchLow := .F.
   if cGrid == 'PRG' .or. cGrid == '*'
      For i:=1 to VentanaMain.GPrgFiles.ItemCount
         if GridImage( 'VentanaMain', 'GPrgFiles', i, NCOLPRGSTATUS, '?', PUB_nGridImgSearchOk )
            GridImage( 'VentanaMain', 'GPrgFiles', i, NCOLPRGSTATUS, '-', PUB_nGridImgSearchOk )
         endif
      Next i
      VentanaMain.TabGrids.Caption( 1 ) := PagePRG
   endif

   if cGrid == 'HEA' .or. cGrid == '*'
      For i:=1 to VentanaMain.GHeaFiles.ItemCount
         if GridImage( 'VentanaMain', 'GHeaFiles', i, NCOLHEASTATUS, '?', PUB_nGridImgSearchOk )
            GridImage( 'VentanaMain', 'GHeaFiles', i, NCOLHEASTATUS, '-', PUB_nGridImgSearchOk )
         endif
      Next i
      VentanaMain.TabGrids.Caption( 2 ) := PageHEA
   endif

   if cGrid == 'PAN' .or. cGrid == '*'
      For i:=1 to VentanaMain.GPanFiles.ItemCount
         if GridImage( 'VentanaMain', 'GPanFiles', i, NCOLPANSTATUS, '?', PUB_nGridImgSearchOk )
            GridImage( 'VentanaMain', 'GPanFiles', i, NCOLPANSTATUS, '-', PUB_nGridImgSearchOk )
         endif
      Next i
      VentanaMain.TabGrids.Caption( 3 ) := PagePAN
   endif

   if cGrid == 'DBF' .or. cGrid == '*'
      For i:=1 to VentanaMain.GDbfFiles.ItemCount
         if GridImage( 'VentanaMain', 'GDbfFiles', i, NCOLDBFSTATUS, '?', PUB_nGridImgSearchOk )
            GridImage( 'VentanaMain', 'GDbfFiles', i, NCOLDBFSTATUS, '-', PUB_nGridImgSearchOk )
         endif
         SetProperty( 'VentanaMain', 'GDbfFiles', 'Cell', i, NCOLDBFSEARCH, '0 ** 0' )
      Next i
      VentanaMain.TabGrids.Caption( 4 ) := PageDBF
      VentanaMain.BLocalSearchDbf.caption := 'Dbf Search'
      VentanaMain.BLocalSearchDbf.Tooltip := 'Search text in Dbf Data'
      VentanaMain.RichEditDbf.BackColor := DEF_COLORBACKDBF
      QPM_Wait( "RichEditDisplay( 'DBF', .F. )", 'Loading ...' )
   endif

   if cGrid == 'LIB' .or. cGrid == '*'
      For i:=1 to VentanaMain.GIncFiles.ItemCount
         if GridImage( 'VentanaMain', 'GIncFiles', i, NCOLINCSTATUS, '?', PUB_nGridImgSearchOk )
            GridImage( 'VentanaMain', 'GIncFiles', i, NCOLINCSTATUS, '-', PUB_nGridImgSearchOk )
         endif
      Next i
      VentanaMain.TabGrids.Caption( 5 ) := PageLIB
   endif

   if cGrid == 'HLP' .or. cGrid == '*'
      For i:=1 to VentanaMain.GHlpFiles.ItemCount
         if GridImage( 'VentanaMain', 'GHlpFiles', i, NCOLHLPSTATUS, '?', PUB_nGridImgSearchOk )
            GridImage( 'VentanaMain', 'GHlpFiles', i, NCOLHLPSTATUS, '-', PUB_nGridImgSearchOk )
         endif
      Next i
      VentanaMain.TabGrids.Caption( 6 ) := PageHlp
   endif
Return .T.

Function GridImage( cWin, cGrid, nRow, nCol, cOper, nBitImage )
   Local nBits  := 256   // ( 2 ** PUB_nGridImgTop ) // ej: 9 imagenes primarias = 256 ( PUB_nGridImgTilde, PUB_nGridImgEquis, etc )
   Local i, cString, nAux
   Local vImagesTranslateGrid := { {   0,   0 }, ;              // 0        0            0000 0000
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
   if nRow < 1
      Return .F.
   endif
   if ( nAux := aScan( vImagesTranslateGrid, { |x| x[2] == GetProperty( cWin, cGrid, 'Cell', nRow, nCol ) } ) ) == 0
      MsgInfo( 'Error en posicionamiento en Funcion GridImage para el valor: ' + US_VarToStr( GetProperty( cWin, cGrid, 'Cell', nRow, nCol ) ) )
      Return .F.
   endif
   cString := NTOC( vImagesTranslateGrid[ nAux ][ 1 ], 2, nBits, '0' )
   For i:=1 to len( cOper )
      do case
         case substr( cOper, i, 1 ) == '?'              /* preguntar si esta activo */
            if substr( cString, nBits - nBitImage + 1, 1 ) == '1'
               Return .T.
            else
               Return .F.
            endif
         case substr( cOper, i, 1 ) == '+'              /* agregarle */
            cString := substr( cString, 1, nBits - nBitImage ) + '1' + substr( cString, nBits - nBitImage + 2 )
         case substr( cOper, i, 1 ) == '-'              /* sacarle */
            cString := substr( cString, 1, nBits - nBitImage ) + '0' + substr( cString, nBits - nBitImage + 2 )
         case upper( substr( cOper, i, 1 ) ) == 'X'     /* limpiar */
            cString := strtran( cString, '1', '0' )
 //      case upper( substr( cOper, i, 1 ) ) == '='     /* setear  */
 //         cString := strtran( cString, '1', '0' )
 //         cString := substr( cString, 1, nBits - nBitImage ) + '1' + substr( cString, nBits - nBitImage + 2 )
         otherwise
            MsgInfo( 'Error in operator from Function GridImage' )
      endcase
   Next i
   if ( nAux := aScan( vImagesTranslateGrid, { |x| x[1] == CTON( cString, 2 ) } ) ) == 0
      MsgInfo( 'Error en posicionamiento (2) en Funcion GridImage para el valor: ' + US_VarToStr( CTON( cString, 2 ) ) )
      Return .F.
   endif
   SetProperty( cWin, cGrid, 'Cell', nRow, nCol, vImagesTranslateGrid[ nAux ][ 2 ] )
Return .F.

Function AddSearchTxt()
   Local Aux, cValor, i
   cValor:=VentanaMain.CSearch.DisplayValue
   if !empty( alltrim(cValor)) .and. !AddSearchTxtFound(cValor)
      if VentanaMain.CSearch.ItemCount < 15
         VentanaMain.CSearch.AddItem('*')
      endif
      Aux:=VentanaMain.CSearch.ItemCount
      For i := (Aux - 1) to 1 step -1
         VentanaMain.CSearch.Item((i+1)):=VentanaMain.CSearch.Item(i)
      next
      VentanaMain.CSearch.Item(1):=cValor
      VentanaMain.CSearch.Value:=1
   endif
Return .T.

Function AddSearchTxtFound(email)
   Local i
   For i := 1 to VentanaMain.CSearch.ItemCount
       if bLastGlobalSearchCas
          if email == VentanaMain.CSearch.Item(i)
             Return .T.
          endif
       else
          if upper(email) == upper(VentanaMain.CSearch.Item(i))
             Return .T.
          endif
       endif
   next
Return .F.

Function LostRichEdit( tipo, nRecord )
   Local cAuxMemo
   do case
      case tipo == 'PRG'
         if bPpoDisplayado
            SetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', nGridPrgLastRow, NCOLPRGOFFSET, cPpoCaretPrg )
         else
            SetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', nGridPrgLastRow, NCOLPRGOFFSET, alltrim( str( VentanaMain.RichEditPRG.CaretPos ) ) )
         endif
         DoMethod( 'VentanaMain', 'GPrgFiles', 'ColumnsAutoFitH' )
      case tipo == 'HEA'
         SetProperty( 'VentanaMain', 'GHeaFiles', 'Cell', nGridHeaLastRow, NCOLHEAOFFSET, alltrim( str( VentanaMain.RichEditHea.CaretPos ) ) )
         DoMethod( 'VentanaMain', 'GHeaFiles', 'ColumnsAutoFitH' )
      case tipo == 'PAN'
         SetProperty( 'VentanaMain', 'GPanFiles', 'Cell', nGridPanLastRow, NCOLPANOFFSET, alltrim( str( VentanaMain.RichEditPan.CaretPos ) ) )
         DoMethod( 'VentanaMain', 'GPanFiles', 'ColumnsAutoFitH' )
      case tipo == 'DBF'
         SetProperty( 'VentanaMain', 'GDbfFiles', 'Cell', nGridDbfLastRow, NCOLDBFOFFSET, alltrim( str( VentanaMain.RichEditDbf.CaretPos ) ) + ' ' + alltrim( str( nRecord ) ) )
         DoMethod( 'VentanaMain', 'GDbfFiles', 'ColumnsAutoFitH' )
#ifdef QPM_SHG
      case tipo == 'HLP'
         if nRecord > 0
            SetProperty( 'VentanaMain', 'GHlpFiles', 'Cell', nGridHlpLastRow, NCOLHLPOFFSET, alltrim( str( VentanaMain.RichEditHlp.CaretPos ) ) )
            cAuxMemo := US_GetRichEditValue( 'VentanaMain', 'RichEditHlp', 'RTF' )
*            SHG_LimpioRtf( @cAuxMemo )
            SHG_SetField( 'SHG_MEMOT', nRecord, cAuxMemo )

/*
            if !( SHG_GetField( 'SHG_TYPE', nRecord ) == SHG_GetField( 'SHG_TYPET', nRecord ) ) .or. ;
               !( SHG_GetField( 'SHG_TOPIC', nRecord ) == SHG_GetField( 'SHG_TOPICT', nRecord ) ) .or. ;
               !( SHG_GetField( 'SHG_NICK', nRecord ) == SHG_GetField( 'SHG_NICKT', nRecord ) ) .or. ;
               !( cAuxMemo == SHG_GetField( 'SHG_MEMO', nRecord ) ) .or. ;
               !( SHG_GetField( 'SHG_KEYS', nRecord ) == SHG_GetField( 'SHG_KEYST', nRecord ) )
               SetProperty( 'VentanaMain', 'GHlpFiles', 'Cell', nGridHlpLastRow, NCOLHLPEDIT, 'D' )
            endif
*/
            if !( SHG_GetField( 'SHG_TYPE', nRecord ) == SHG_GetField( 'SHG_TYPET', nRecord ) ) .or. ;
               !( SHG_GetField( 'SHG_TOPIC', nRecord ) == SHG_GetField( 'SHG_TOPICT', nRecord ) ) .or. ;
               !( SHG_GetField( 'SHG_NICK', nRecord ) == SHG_GetField( 'SHG_NICKT', nRecord ) ) .or. ;
               oHlpRichEdit:lChanged .or. ;
               !( SHG_GetField( 'SHG_KEYS', nRecord ) == SHG_GetField( 'SHG_KEYST', nRecord ) )
               
               SetProperty( 'VentanaMain', 'GHlpFiles', 'Cell', nGridHlpLastRow, NCOLHLPEDIT, 'D' )
               oHlpRichEdit:lChanged := .F.
            endif
            DoMethod( 'VentanaMain', 'GHlpFiles', 'ColumnsAutoFitH' )
         endif
#endif
   endcase
Return .T.

Function FormQuickView()
   QPM_MemoWrit( PUB_cProjectFolder + DEF_SLASH + '_' + PUB_cSecu + 'RunViewForm.Cng', ;
                 'PATH ' + US_ShortName( PUB_cProjectFolder ) + Hb_OsNewLine() + ;
                 'SECUENCE ' + PUB_cSecu + Hb_OsNewLine() + ;
                 'HARBOUR ' + US_ShortName( GetHarbourFolder() ) + DEF_SLASH + 'BIN'+DEF_SLASH+'HARBOUR.EXE' + Hb_OsNewLine() + ;
                 'HARBOURINCLUDE ' + US_ShortName( GetHarbourFolder() ) + DEF_SLASH + 'INCLUDE' + Hb_OsNewLine() + ;
                 'MINIGUIINCLUDE ' + US_ShortName(GetMiniGuiFolder()) + DEF_SLASH + 'INCLUDE' + Hb_OsNewLine() + ;
                 'FORMINCLUDE ' + US_ShortName( US_FileNameOnlyPath( ChgPathToReal( GetProperty( 'VentanaMain', 'GPanFiles', 'Cell', nGridPanLastRow, NCOLPANFULLNAME ) ) ) ) + Hb_OsNewLine() + ;
                 'FORM ' + US_FileNameOnlyName( ChgPathToReal( GetProperty( 'VentanaMain', 'GPanFiles', 'Cell', nGridPanLastRow, NCOLPANFULLNAME ) ) ) )
   QPM_MemoWrit( PUB_cProjectFolder + DEF_SLASH + '_'+PUB_cSecu+'RunView.bat', US_ShortName( PUB_cQPM_Folder ) + DEF_SLASH + 'US_VIEW_' + GetHarbourSuffix() + GetMiniGuiSuffix() + '.EXE ' + US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + '_' + PUB_cSecu + 'RunViewForm.Cng' )
   QPM_Execute( US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + '_'+PUB_cSecu+'RunView.bat',, DEF_QPM_EXEC_WAIT, DEF_QPM_EXEC_HIDE )
// ferase( US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + '_'+PUB_cSecu+'RunView.bat' )
Return .T.

Function QPM_Timer_Edit()
   Local i, FechaCnt
   For i := 1 to VentanaMain.GPrgFiles.ItemCount
      if !empty( GetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', i, NCOLPRGEDIT ) )
         if !file( GetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', i, NCOLPRGEDIT ) )
            FechaCnt := val( Right( US_FileNameOnlyName( GetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', i, NCOLPRGEDIT ) ), 16 ) )
            SetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', i, NCOLPRGEDIT, '' )
            GridImage( 'VentanaMain', 'GPrgFiles', i, NCOLPRGSTATUS, '-', PUB_nGridImgEdited )
            if FechaCnt < val( US_FileDateTime( ChgPathToReal( GetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', i, NCOLPRGFULLNAME ) ) ) + '00' )
               QPM_Wait( "RichEditDisplay( 'PRG', .T., " + str( i ) + ')', 'Reloading ...' )
#ifdef QPM_HOTRECOVERY
               QPM_Wait( "QPM_HotRecovery( 'ADD', 'EDIT', 'SRC', '" + GetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', i, NCOLPRGFULLNAME ) + "', '" + GetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', i, NCOLPRGRECOVERY ) + "' )", 'Creating Version File for Hot Recovery ...' )
               SetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', i, NCOLPRGRECOVERY, '' )
               if _IsControlDefined( 'HR_GridItemTargetPRG', 'WinHotRecovery' ) .and. ;
                  i == GetProperty( 'WinHotRecovery', 'HR_GridItemTargetPRG', 'value' )
                  eval( { || if( !bPrgSorting .and. !PUB_bLite, if( HR_bNumberOnPrg, QPM_Wait( "QPM_HotChangeGrid( 'TARGET', 'ITEM', 'PRG' )", 'Comparing' ), QPM_HotChangeGrid( 'TARGET', 'ITEM', 'PRG' ) ), US_NOP() ) } )
               endif
#endif
            else
               VentanaMain.RichEditPrg.BackColor := DEF_COLORBACKPRG
               VentanaMain.RichEditPrg.FontColor := DEF_COLORFONTVIEW
#ifdef QPM_HOTRECOVERY
               ferase( GetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', i, NCOLPRGRECOVERY ) )
               SetProperty( 'VentanaMain', 'GPrgFiles', 'Cell', i, NCOLPRGRECOVERY, '' )
#endif
            endif
#ifdef QPM_HOTRECOVERY
            if _IsControlDefined( 'HR_GridItemTargetPRG', 'WinHotRecovery' )
               GridImage( 'WinHotRecovery', 'HR_GridItemTargetPRG', i, DEF_N_ITEM_COLIMAGE, '-', PUB_nGridImgEdited )
            endif
#endif
         endif
      endif
   Next i

   For i:=1 to VentanaMain.GHeaFiles.ItemCount
      if !empty( GetProperty( 'VentanaMain', 'GHeaFiles', 'Cell', i, NCOLHEAEDIT ) )
         if !file( GetProperty( 'VentanaMain', 'GHeaFiles', 'Cell', i, NCOLHEAEDIT ) )
            FechaCnt := val( Right( US_FileNameOnlyName( GetProperty( 'VentanaMain', 'GHeaFiles', 'Cell', i, NCOLHEAEDIT ) ), 16 ) )
            SetProperty( 'VentanaMain', 'GHeaFiles', 'Cell', i, NCOLHEAEDIT, '' )
            GridImage( 'VentanaMain', 'GHeaFiles', i, NCOLHEASTATUS, '-', PUB_nGridImgEdited )
            if FechaCnt < val( US_FileDateTime( ChgPathToReal( GetProperty( 'VentanaMain', 'GHeaFiles', 'Cell', i, NCOLHEAFULLNAME ) ) ) + '00' )
               QPM_Wait( "RichEditDisplay( 'HEA', .T., " + str( i ) + ')', 'Reloading ...' )
#ifdef QPM_HOTRECOVERY
               QPM_Wait( "QPM_HotRecovery( 'ADD', 'EDIT', 'HEA', '" + GetProperty( 'VentanaMain', 'GHeaFiles', 'Cell', i, NCOLHEAFULLNAME ) + "', '" + GetProperty( 'VentanaMain', 'GHeaFiles', 'Cell', i, NCOLHEARECOVERY ) + "' )", 'Creating Version File for Hot Recovery ...' )
               SetProperty( 'VentanaMain', 'GHeaFiles', 'Cell', i, NCOLHEARECOVERY, '' )
               if _IsControlDefined( 'HR_GridItemTargetHea', 'WinHotRecovery' ) .and. ;
                  i == GetProperty( 'WinHotRecovery', 'HR_GridItemTargetHea', 'value' )
                  eval( { || if( !bHeaSorting .and. !PUB_bLite, if( HR_bNumberOnHea, QPM_Wait( "QPM_HotChangeGrid( 'TARGET', 'ITEM', 'HEA' )", 'Comparing' ), QPM_HotChangeGrid( 'TARGET', 'ITEM', 'HEA' ) ), US_NOP() ) } )
               endif
#endif
            else
               VentanaMain.RichEditHea.BackColor := DEF_COLORBACKHEA
#ifdef QPM_HOTRECOVERY
               ferase( GetProperty( 'VentanaMain', 'GHeaFiles', 'Cell', i, NCOLHEARECOVERY ) )
               SetProperty( 'VentanaMain', 'GHeaFiles', 'Cell', i, NCOLHEARECOVERY, '' )
#endif
            endif
#ifdef QPM_HOTRECOVERY
            if _IsControlDefined( 'HR_GridItemTargetHea', 'WinHotRecovery' )
               GridImage( 'WinHotRecovery', 'HR_GridItemTargetHea', i, DEF_N_ITEM_COLIMAGE, '-', PUB_nGridImgEdited )
            endif
#endif
         endif
      endif
   Next i

   For i:=1 to VentanaMain.GPanFiles.ItemCount
      if !empty( GetProperty( 'VentanaMain', 'GPanFiles', 'Cell', i, NCOLPANEDIT ) )
         if !file( GetProperty( 'VentanaMain', 'GPanFiles', 'Cell', i, NCOLPANEDIT ) )
            FechaCnt := val( Right( US_FileNameOnlyName( GetProperty( 'VentanaMain', 'GPanFiles', 'Cell', i, NCOLPANEDIT ) ), 16 ) )
            SetProperty( 'VentanaMain', 'GPanFiles', 'Cell', i, NCOLPANEDIT, '' )
            GridImage( 'VentanaMain', 'GPanFiles', i, NCOLPANSTATUS, '-', PUB_nGridImgEdited )
            if FechaCnt < val( US_FileDateTime( ChgPathToReal( GetProperty( 'VentanaMain', 'GPanFiles', 'Cell', i, NCOLPANFULLNAME ) ) ) + '00' )
               QPM_Wait( "RichEditDisplay( 'PAN', .T., " + str( i ) + ')', 'Reloading ...' )
#ifdef QPM_HOTRECOVERY
               QPM_Wait( "QPM_HotRecovery( 'ADD', 'EDIT', 'PAN', '" + GetProperty( 'VentanaMain', 'GPanFiles', 'Cell', i, NCOLPANFULLNAME ) + "', '" + GetProperty( 'VentanaMain', 'GPanFiles', 'Cell', i, NCOLPANRECOVERY ) + "' )", 'Creating Version File for Hot Recovery ...' )
               SetProperty( 'VentanaMain', 'GPanFiles', 'Cell', i, NCOLPANRECOVERY, '' )
               if _IsControlDefined( 'HR_GridItemTargetPAN', 'WinHotRecovery' ) .and. ;
                  i == GetProperty( 'WinHotRecovery', 'HR_GridItemTargetPAN', 'value' )
                  eval( { || if( !bPanSorting .and. !PUB_bLite, if( HR_bNumberOnPan, QPM_Wait( "QPM_HotChangeGrid( 'TARGET', 'ITEM', 'PAN' )", 'Comparing' ), QPM_HotChangeGrid( 'TARGET', 'ITEM', 'PAN' ) ), US_NOP() ) } )
               endif
#endif
            else
               VentanaMain.RichEditPan.BackColor := DEF_COLORBACKPAN
#ifdef QPM_HOTRECOVERY
               ferase( GetProperty( 'VentanaMain', 'GPanFiles', 'Cell', i, NCOLPANRECOVERY ) )
               SetProperty( 'VentanaMain', 'GPanFiles', 'Cell', i, NCOLPANRECOVERY, '' )
#endif
            endif
#ifdef QPM_HOTRECOVERY
            if _IsControlDefined( 'HR_GridItemTargetPan', 'WinHotRecovery' )
               GridImage( 'WinHotRecovery', 'HR_GridItemTargetPan', i, DEF_N_ITEM_COLIMAGE, '-', PUB_nGridImgEdited )
            endif
#endif
         endif
      endif
   Next i

   For i:=1 to VentanaMain.GDbfFiles.ItemCount
      if !empty( GetProperty( 'VentanaMain', 'GDbfFiles', 'Cell', i, NCOLDBFEDIT ) )
         if !file( GetProperty( 'VentanaMain', 'GDbfFiles', 'Cell', i, NCOLDBFEDIT ) )
            SetProperty( 'VentanaMain', 'GDbfFiles', 'Cell', i, NCOLDBFEDIT, '' )
            GridImage( 'VentanaMain', 'GDbfFiles', i, NCOLDBFSTATUS, '-', PUB_nGridImgEdited )
            if VentanaMain.GDbfFiles.Value == i
               QPM_Wait( "RichEditDisplay( 'DBF', .T., " + str( i ) + ')', 'Reloading ...' )
            endif
         endif
      endif
   Next i
Return .T.

Function CloseDbfAutoView()
   if select( 'DbfAlias' ) > 0
      DBSelectarea( 'DbfAlias' )
      DBCloseArea( 'DbfAlias' )
   endif
   if _IsControlDefined( 'DbfBrowse', 'VentanaMain' )
      VentanaMain.DbfBrowse.Release()
   endif
Return .T.

Function DefineRichEditForNotDbfView( cTxt )

   if !( _IsControlDefined( 'DbfAutoView', 'VentanaMain' ) )
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
   endif
   VentanaMain.DbfAutoView.Value := Hb_OsNewLine() + ;
                                    Hb_OsNewLine() + ;
                                    Hb_OsNewLine() + ;
                                    Hb_OsNewLine() + ;
                                    Hb_OsNewLine() + ;
                                    Hb_OsNewLine() + ;
                                    '               '+cTxt
// VentanaMain.DbfAutoView.Refresh()

Return .T.

Function ProjectButtons( bEna )
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
Return bEna

Function AddLastOpen( cPrj )
   Local r, i, cont:=0
   If ( r := AScan( vLastOpen, { |x| us_upper( x ) == us_upper( cPrj ) } ) ) > 0
      vLastOpen[r] := ''
   else
      aeval( vLastOpen, { |x| if( ! empty( x ), cont ++, ) } )
      if cont > 19  // Tope de menu Items para proyectos abiertos anteriormente
         For i := 1 to len( vLastOpen )
            if !empty( vLastOpen[i] )
               vLastOpen[ i ] := ''
               exit
            endif
         next
      endif
   endif
   aadd( vLastOpen, cPrj )
Return .T.

FUNCTION LocalSearchContinue()
   Local RPTA := '', Ventana := US_WindowNameRandom( 'Next' )

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
             ROW        12
             COL        20
             WIDTH      240
             VALUE      "Continue Search From NEXT:"
      END LABEL

      DEFINE BUTTONEX BPosition
              ROW       40
              COL       20
              WIDTH     65
              HEIGHT    25
              CAPTION   'Position'
              ACTION    ( RPTA := 'P', DoMethod( Ventana, 'Release' ) )
              TOOLTIP   'Resume search from the last text found'
      END BUTTONEX

      DEFINE BUTTONEX BField
              ROW       40
              COL       100
              WIDTH     65
              HEIGHT    25
              CAPTION   'Column'
              ACTION    ( RPTA := 'F', DoMethod( Ventana, 'Release' ) )
              TOOLTIP   'Resume search from the the next column'
      END BUTTONEX

      DEFINE BUTTONEX BRecord
              ROW       40
              COL       180
              WIDTH     65
              HEIGHT    25
              CAPTION   'Record'
              ACTION    ( RPTA := 'R', DoMethod( Ventana, 'Release' ) )
              TOOLTIP   'Resume search from the the next record'
      END BUTTONEX

      DEFINE CHECKBOX Check_Continue
              CAPTION   'Remember my election'
              ROW       70
              COL       50
              WIDTH     185
              VALUE     .F.
              TOOLTIP   "Do not ask again until the search starts from the beginning"
              ON CHANGE ( bDbfDataSearchAsk := ! ( GetProperty( Ventana, 'Check_Continue', 'value' ) ) )
      END CHECKBOX

      DEFINE BUTTONEX BCancel
              ROW       110
              COL       90
              WIDTH     85
              HEIGHT    25
              CAPTION   'Cancel'
              ACTION    ( RPTA := '', DoMethod( Ventana, 'Release' ) )
              TOOLTIP   'Cancel search'
      END BUTTONEX

   END WINDOW

   CENTER WINDOW &Ventana
   ACTIVATE WINDOW &Ventana
Return RPTA

Function CargoSearch()
   aEval( vLastSearch, { |x| VentanaMain.CSearch.AddItem( x ) } )
Return nil

Function QPM_DefinoMainMenu()
   Local i, cProj, bAction
   DEFINE MAIN MENU OF VentanaMain
      POPUP '&File'
         ITEM '&Open/New' ACTION QPM_OpenProject()
         ITEM '&Save' ACTION QPM_SaveProject()
         ITEM 'Save &As ...' ACTION QPM_SaveAsProject()
      if len( vLastOpen ) > 0
         SEPARATOR
      endif
      for i := len( vLastOpen ) to 1 step -1
         cProj := vLastOpen[i]
         if ! empty( cProj )
            bAction := "{|| QPM_OpenProject( '" + cProj + "' ) }"
            _DefineMenuItem( cProj, &bAction, NIL, if( file( cProj ), 'GridTilde', 'GridEquis' ) )
         endif
      next
       if len( vLastOpen ) > 0
         SEPARATOR
         ITEM '&Clear list' ACTION QPM_ClearLastOpenList()
       endif
         SEPARATOR
         ITEM '&Exit' ACTION QPM_Exit( .T. )
      END POPUP
      POPUP '&Edit'
      #ifdef QPM_SHG
         ITEM '&Copy' ACTION SHG_Send_Copy() NAME ItC_CopyM
         ITEM 'C&ut' ACTION SHG_Send_Cut() NAME ItC_CutM
         ITEM '&Paste' ACTION SHG_Send_Paste() NAME ItC_PasteM
      #else
         ITEM '&Copy' ACTION US_Send_Copy() NAME ItC_CopyM
         ITEM 'C&ut' ACTION US_Send_Cut() NAME ItC_CutM
         ITEM '&Paste' ACTION US_Send_Paste() NAME ItC_PasteM
      #endif
         ITEM '&Select All' ACTION QPM_Send_SelectAll()
      END POPUP
      POPUP '&Debug'
         ITEM '&Build' ACTION ( bBuildRun := .F., QPM_Build() )
         ITEM 'B&uild and Run' ACTION ( bBuildRun := .T., QPM_Build() )
         ITEM '&Run' ACTION ( bRunParm := .F., QPM_Run( bRunParm ) )
         ITEM 'Run With &Parm' ACTION ( bRunParm := .T., QPM_Run( bRunParm ) )
         SEPARATOR
      if PUB_bDebugActive
         ITEM '&Debug' ACTION SwitchDebug() NAME DEBUG CHECKMARK 'GridTilde' CHECKED
      else
         ITEM '&Debug' ACTION SwitchDebug() NAME DEBUG CHECKMARK 'GridTilde'
      endif
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
      if PUB_bAutoInc
         ITEM 'AutoInc Version Number' ACTION SwitchAutoInc() NAME AUTOINC CHECKMARK 'GridTilde' CHECKED
      else
         ITEM 'AutoInc Version Number' ACTION SwitchAutoInc() NAME AUTOINC CHECKMARK 'GridTilde'
      endif
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
         ITEM 'Go To topic Link in Help' ACTION US_DisplayHelpTopic( GetActiveHelpFile(), 'links' )
         ITEM 'Go To QPM Home Site: '+PUB_cQPM_Support_Link ACTION ShellExecute(0, 'open', 'rundll32.exe', 'url.dll,FileProtocolHandler ' + PUB_cQPM_Support_Link,,1)
      END POPUP
      POPUP '&OnlyForSupport     '
         ITEM 'Record Activity in Log '+PUB_cQPM_Folder + DEF_SLASH + 'QPM.log' ACTION ( bLogActivity := !bLogActivity, VentanaMain.MLog.Checked := bLogActivity ) NAME MLog CHECKMARK 'GridTilde'
         ITEM 'Clear Log File '+PUB_cQPM_Folder + DEF_SLASH + 'QPM.log' ACTION ClearLog()
         ITEM 'View Log File '+PUB_cQPM_Folder + DEF_SLASH + 'QPM.log' ACTION ViewLog()
         SEPARATOR
         ITEM 'Do not delete auxiliary files'  ACTION ( PUB_DeleteAux := ! PUB_DeleteAux, VentanaMain.MDelete.Checked := ! PUB_DeleteAux ) NAME MDelete CHECKMARK 'GridTilde'
         SEPARATOR
         ITEM 'Go To QPM Home Site: ' + PUB_cQPM_Support_Link ACTION ShellExecute( 0, 'open', 'rundll32.exe', 'url.dll,FileProtocolHandler ' + PUB_cQPM_Support_Link,, 1)
         ITEM '&Mail to QPM_Support <' + PUB_cQPM_Support_eMail + '> ...' ACTION ShellExecute( 0, 'open', 'rundll32.exe', 'url.dll,FileProtocolHandler ' + 'mailto:' + PUB_cQPM_Support_eMail + '?cc=&bcc=' + '&subject=' + PUB_cQPM_Title + '&body=Thank%20for%20use%20' + PUB_cQPM_Title + '',, 1)
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
             for i := len( vLastOpen ) to 1 step -1
                cProj := vLastOpen[i]
                if ! empty( cProj )
                   bAction := "{|| QPM_OpenProject( '" + cProj + "' ) }"
                   _DefineMenuItem( cProj, &bAction, NIL, if( file( cProj ), 'GridTilde', 'GridEquis' ) )
                endif
             next
             if len( vLastOpen ) > 0
                SEPARATOR
                ITEM '&Clear list' ACTION QPM_ClearLastOpenList()
             endif
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
                  PICTURE 'help' ;
                  ACTION  US_DisplayHelpTopic( GetActiveHelpFile(), 1 ) ;
                  SEPARATOR

  END TOOLBAR

Return .T.

Function GetPrj_Version()
Return PadL( GetProperty( 'VentanaMain', 'LVerVerNum', 'value' ), DEF_LEN_VER_VERSION, '0' ) + PadL( GetProperty( 'VentanaMain', 'LVerRelNum', 'value' ), DEF_LEN_VER_RELEASE, '0' ) + PadL( GetProperty( 'VentanaMain', 'LVerBuiNum', 'value' ), DEF_LEN_VER_BUILD, '0' )

Function US_GetFile( aFilter, title, cIniFolder, multiselect, nochangedir )
   Local reto
   SetMGWaitHide()
   Reto := US_GetFile2( aFilter, title, cIniFolder, multiselect, nochangedir )
   SetMGWaitShow()
Return reto

Function US_GetFile2( aFilter, title, cIniFolder, multiselect, nochangedir )
   local c := '', cfiles, fileslist := {}, n
   IF aFilter == Nil
      aFilter := {}
   EndIf
   FOR n:=1 TO LEN(aFilter)
      c += aFilter[n][1] + chr(0) + aFilter[n][2] + chr(0)
   NEXT
   if valtype(multiselect) == 'U'
      multiselect := .f.
   endif
   if .not. multiselect
      Return ( US_C_GetFile( c, title, cIniFolder, multiselect,nochangedir ) )
   else
      cfiles := US_C_GetFile( c, title, cIniFolder, multiselect,nochangedir )
      if len( cfiles ) > 0
         if valtype( cfiles ) == 'A'
            fileslist := aclone( cfiles )
         else
            aadd( fileslist, cfiles )
         endif
      endif
      Return ( fileslist )
   endif
Return Nil

#pragma BEGINDUMP

#define _WIN32_IE      0x0500
#define HB_OS_WIN_32_USED
#define _WIN32_WINNT   0x0400
#include <shlobj.h>

#include <windows.h>
#include <commctrl.h>
#include "hbapi.h"
#include "hbvm.h"
#include "hbstack.h"
#include "hbapiitm.h"
#include "winreg.h"
#include "tchar.h"
#include "Winuser.h"
#include <wingdi.h>
#include <setupapi.h>

#ifdef __XHARBOUR__
   #define HB_STORC( n, x, y )    hb_storc( n, x, y )
   #define HB_STORNI( n, x, y )   hb_storni( n, x, y )
   #define HB_STORL( n, x, y )    hb_storl( n, x, y )
   #define HB_STORNL( n, x, y )   hb_stornl( n, x, y )
#else
   #define HB_STORC( n, x, y )    hb_storvc( n, x, y )
   #define HB_STORNI( n, x, y )   hb_storvni( n, x, y )
   #define HB_STORL( n, x, y )    hb_storvl( n, x, y )
   #define HB_STORNL( n, x, y )   hb_storvnl( n, x, y )
#endif

HB_FUNC( HB_LOADSTRING )
{
   LPBYTE cBuffer;
   cBuffer = GlobalAlloc(GPTR, 255);
   LoadString(GetModuleHandle(NULL), hb_parni(1), (LPSTR) cBuffer, 254);
   hb_retc(cBuffer);
   GlobalFree(cBuffer);
}

HB_FUNC ( US_C_GETFILE )
{
        OPENFILENAME ofn;
        char buffer[32768];
        char cFullName[64][1024];
        char cCurDir[512];
        char cFileName[512];
        int iPosition = 0;
        int iNumSelected = 0;
        int n;

        int flags = 0 ;
   /*   int flags = OFN_FILEMUSTEXIST ;    */

        buffer[0] = 0 ;

        if ( hb_parl(4) )
        {
                flags = flags | OFN_ALLOWMULTISELECT | OFN_EXPLORER ;
        }
        if ( hb_parl(5) )
        {
                flags = flags | OFN_NOCHANGEDIR ;
        }

        memset( (void*) &ofn, 0, sizeof( OPENFILENAME ) );
        ofn.lStructSize = sizeof(ofn);
        ofn.hwndOwner = GetActiveWindow();
        ofn.lpstrFilter = hb_parc(1);
        ofn.nFilterIndex = 1;
        ofn.lpstrFile = buffer;
        ofn.nMaxFile = sizeof(buffer);
        ofn.lpstrInitialDir = hb_parc(3);
        ofn.lpstrTitle = hb_parc(2);
        ofn.nMaxFileTitle = 512;
        ofn.Flags = flags;

        if( GetOpenFileName( &ofn ) )
        {
                if(ofn.nFileExtension!=0)
                {
                        hb_retc( ofn.lpstrFile );
                }
                else
                {
                        wsprintf(cCurDir,"%s",&buffer[iPosition]);
                        iPosition=iPosition+strlen(cCurDir)+1;

                        do
                        {
                                iNumSelected++;
                                wsprintf(cFileName,"%s",&buffer[iPosition]);
                                iPosition=iPosition+strlen(cFileName)+1;
                                wsprintf(cFullName[iNumSelected],"%s\\%s",cCurDir,cFileName);
                        }
                        while(  (strlen(cFileName)!=0) && ( iNumSelected <= 63 ) );

                        if(iNumSelected > 1)
                        {
                                hb_reta( iNumSelected - 1 );

                                for (n = 1; n < iNumSelected; n++)
                                {
                                        HB_STORC( cFullName[n], -1, n );
                                }
                        }
                        else
                        {
                                hb_retc( &buffer[0] );
                        }
                }
        }
        else
        {
                hb_retc( "" );
        }
}

#pragma ENDDUMP

#ifndef QPM_KILLER
Function QPM_SETPROCESSPRIORITY( x )
Return .T.
#endif

Function QPM_CompressUtilities()
   Local i, Out

   QPM_Execute( PUB_cQPM_Folder + DEF_SLASH + 'US_UPX.EXE ' + US_ShortName(PUB_cQPM_Folder) + DEF_SLASH + 'US_RUN.EXE', '', DEF_QPM_EXEC_NOWAIT, DEF_QPM_EXEC_HIDE )
   DO EVENTS

   Out := '@ECHO OFF' + Hb_OsNewLine()
   Out += 'COPY ' + US_ShortName(PUB_cQPM_Folder) + DEF_SLASH + 'US_UPX.EXE ' + US_ShortName(PUB_cQPM_Folder) + DEF_SLASH + 'XYZ_UPX.EXE' + Hb_OsNewLine()
   For i := 1 to len(vExeList)
      do case
      case upper(right(vExeList[i], 04)) != '.EXE'
      case upper(right(vExeList[i], 07)) == 'QPM.EXE'
      case upper(right(vExeList[i], 10)) == 'US_RUN.EXE'
      case upper(right(vExeList[i], 13)) == 'US_IMPDEF.EXE'
      case upper(right(vExeList[i], 15)) == 'US_PEXPORTS.EXE'
      case upper(right(vExeList[i], 12)) == 'US_REIMP.EXE'
      case upper(right(vExeList[i], 13)) == 'US_IMPLIB.EXE'
      case upper(right(vExeList[i], 14)) == 'US_OBJDUMP.EXE'
      case upper(right(vExeList[i], 12)) == 'US_TDUMP.EXE'
      otherwise
         Out += US_ShortName(PUB_cQPM_Folder) + DEF_SLASH + 'XYZ_UPX.EXE --no-progress ' + vExeList[i] + Hb_OsNewLine()
      endcase
   Next
   Out += 'DEL ' + US_ShortName(PUB_cQPM_Folder) + DEF_SLASH + 'XYZ_UPX.EXE' + Hb_OsNewLine()

   QPM_MemoWrit( PUB_cQPM_Folder + DEF_SLASH + 'Compress.bat', Out )
   QPM_Execute( PUB_cQPM_Folder + DEF_SLASH + 'Compress.bat', '', DEF_QPM_EXEC_WAIT, DEF_QPM_EXEC_NORMAL )

   MsgInfo('Compression finished !!!' + Hb_OsNewLine() + ;
           'To compress QPM.EXE, you must close it and then manually do:' + Hb_OsNewLine() + ;
           'us_upx QPM.EXE')
Return Nil

Function QPM_DecompressUtilities()
   Local i, Out

   QPM_Execute( PUB_cQPM_Folder + DEF_SLASH + 'US_UPX.EXE -d ' + US_ShortName(PUB_cQPM_Folder) + DEF_SLASH + 'US_RUN.EXE', '', DEF_QPM_EXEC_NOWAIT, DEF_QPM_EXEC_HIDE )
   DO EVENTS

   Out := '@ECHO OFF' + Hb_OsNewLine()
   Out += 'COPY ' + US_ShortName(PUB_cQPM_Folder) + DEF_SLASH + 'US_UPX.EXE ' + US_ShortName(PUB_cQPM_Folder) + DEF_SLASH + 'XYZ_UPX.EXE' + Hb_OsNewLine()
   For i := 1 to len(vExeList)
      do case
      case upper(right(vExeList[i], 04)) != '.EXE'
      case upper(right(vExeList[i], 07)) == 'QPM.EXE'
      case upper(right(vExeList[i], 10)) == 'US_RUN.EXE'
      case upper(right(vExeList[i], 13)) == 'US_IMPDEF.EXE'
      case upper(right(vExeList[i], 15)) == 'US_PEXPORTS.EXE'
      case upper(right(vExeList[i], 12)) == 'US_REIMP.EXE'
      case upper(right(vExeList[i], 13)) == 'US_IMPLIB.EXE'
      case upper(right(vExeList[i], 14)) == 'US_OBJDUMP.EXE'
      case upper(right(vExeList[i], 12)) == 'US_TDUMP.EXE'
      otherwise
         Out += US_ShortName(PUB_cQPM_Folder) + DEF_SLASH + 'XYZ_UPX.EXE -d --no-progress ' + vExeList[i] + Hb_OsNewLine()
      endcase
   Next
   Out += 'DEL ' + US_ShortName(PUB_cQPM_Folder) + DEF_SLASH + 'XYZ_UPX.EXE' + Hb_OsNewLine()
//   Out += 'PAUSE' + Hb_OsNewLine()

   QPM_MemoWrit( PUB_cQPM_Folder + DEF_SLASH + 'Decompress.bat', Out )

   QPM_Execute( PUB_cQPM_Folder + DEF_SLASH + 'Decompress.bat', '', DEF_QPM_EXEC_WAIT, DEF_QPM_EXEC_NORMAL )

   MsgInfo('Decompression finished !!!' + Hb_OsNewLine() + ;
           'To decompress QPM.EXE, you must close it and then manually do:' + Hb_OsNewLine() + ;
           'us_upx -d QPM.EXE')
Return nil

/* eof */
