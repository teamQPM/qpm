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
#include <QPM.ch>

#define QPM_VERSION_NUMBER "05 03 21"
#define DEF_INCLUDE_GT  '#include "QPM_gt.ch"'

Function Main(PAR_cP1,PAR_cP2,PAR_cP3,PAR_cP4,PAR_cP5,PAR_cP6,PAR_cP7,PAR_cP8,PAR_cP9,PAR_cP10,PAR_cP11,PAR_cP12,PAR_cP13,PAR_cP14,PAR_cP15,PAR_cP16,PAR_cP17,PAR_cP18,PAR_cP19,PAR_cP20)
   Local Folder , FileName , i , nPos , LogIni := 0 , nIndx
   Local LOC_cParam := ""

   PUBLIC PUB_cQPM_Version := QPM_VERSION_NUMBER

   PUBLIC BUILD_IN_PROGRESS := .F.
   PUBLIC MAIN_HAS_FOCUS := .F.

   PUBLIC PUB_QPM_bHigh := .F.
   QPM_SetProcessPriority( "HIGH" )

   Request DBFCDX , DBFFPT
   Rddsetdefault( "DBFCDX" )

   PAR_cP1 =IIF(PAR_cP1 =NIL,"",PAR_cP1 )
   PAR_cP2 =IIF(PAR_cP2 =NIL,"",PAR_cP2 )
   PAR_cP3 =IIF(PAR_cP3 =NIL,"",PAR_cP3 )
   PAR_cP4 =IIF(PAR_cP4 =NIL,"",PAR_cP4 )
   PAR_cP5 =IIF(PAR_cP5 =NIL,"",PAR_cP5 )
   PAR_cP6 =IIF(PAR_cP6 =NIL,"",PAR_cP6 )
   PAR_cP7 =IIF(PAR_cP7 =NIL,"",PAR_cP7 )
   PAR_cP8 =IIF(PAR_cP8 =NIL,"",PAR_cP8 )
   PAR_cP9 =IIF(PAR_cP9 =NIL,"",PAR_cP9 )
   PAR_cP10=IIF(PAR_cP10=NIL,"",PAR_cP10)
   PAR_cP11=IIF(PAR_cP11=NIL,"",PAR_cP11)
   PAR_cP12=IIF(PAR_cP12=NIL,"",PAR_cP12)
   PAR_cP13=IIF(PAR_cP13=NIL,"",PAR_cP13)
   PAR_cP14=IIF(PAR_cP14=NIL,"",PAR_cP14)
   PAR_cP15=IIF(PAR_cP15=NIL,"",PAR_cP15)
   PAR_cP16=IIF(PAR_cP16=NIL,"",PAR_cP16)
   PAR_cP17=IIF(PAR_cP17=NIL,"",PAR_cP17)
   PAR_cP18=IIF(PAR_cP18=NIL,"",PAR_cP18)
   PAR_cP19=IIF(PAR_cP19=NIL,"",PAR_cP19)
   PAR_cP20=IIF(PAR_cP20=NIL,"",PAR_cP20)
   LOC_cParam:=alltrim(PAR_cP1+" "+PAR_cP2+" "+PAR_cP3+" "+PAR_cP4+" "+PAR_cP5+" "+PAR_cP6+" "+PAR_cP7+" "+PAR_cP8+" "+PAR_cP9+" "+PAR_cP10+" "+PAR_cP11+" "+PAR_cP12+" "+PAR_cP13+" "+PAR_cP14+" "+PAR_cP15+" "+PAR_cP16+" "+PAR_cP17+" "+PAR_cP18+" "+PAR_cP19+" "+PAR_cP20)

// PUBLIC PUB_cQPM_Version       := substr( Prj_Version() , 1 , 2 ) + " " + substr( Prj_Version() , 3 , 2 ) + " " + substr( Prj_Version() , 7 , 2 )
   PUBLIC PUB_cQPM_Support_Link  := "http://qpm.sourceforge.net"
   PUBLIC PUB_cQPM_Support_Admin := "Fernando Yurisich (Uruguay)"
   PUBLIC PUB_cQPM_Support_eMail := "qpm-users@lists.sourceforge.net"
   PUBLIC PUB_cStatusLabel       := "Status: Idle"
   PUBLIC PUB_MenuPrjOptions     := "Project Options"
   PUBLIC PUB_MenuGblOptions     := "Global Options (Folders for [x]Harbour, MiniGUI, C++ and others)"
   PUBLIC PUB_nBottom            := 9999999999      // ir al bottom de editbox
   PUBLIC PUB_cCharTab           := CHR( 09 )
   PUBLIC PUB_cCharFileNameTemp  := "_"      // $ trae problemas con Make de MinGW
                                            // # no genera uno de los Temp.log
   //
   PUBLIC PUB_cQPM_Version2 := us_word(PUB_cQPM_Version,1) + US_Word(PUB_cQPM_Version,2) + us_word(PUB_cQPM_Version,3)
   PUBLIC PUB_cQPM_Version3 := us_word(PUB_cQPM_Version,1) + US_Word(PUB_cQPM_Version,2) + "00" + us_word(PUB_cQPM_Version,3)
   PUBLIC PUB_nQPM_Version := val( us_word(PUB_cQPM_Version,1) + US_Word(PUB_cQPM_Version,2) + us_word(PUB_cQPM_Version,3) )
   PUBLIC PUB_cQPM_VersionDisplay := "v" + strtran( substr( PUB_cQPM_Version , 1 , 5 ) , " " , "." ) + " Build " + substr( PUB_cQPM_Version , 7 , 2 )
   PUBLIC PUB_cQPM_Title := 'QPM (QAC Based Project Manager) - Project Manager for MiniGui ('+PUB_cQPM_VersionDisplay+')'
   PUBLIC PUB_cQPM_Folder := US_FileNameOnlyPath( GetModuleFileName( GetInstance() ) )
   PUBLIC PUB_cTempFolder := GetTempFolder()
   PUBLIC PUB_cThisFolder := ""
   PUBLIC PUB_cProjectFile := ""
   PUBLIC PUB_bOpenProjectFromParm := .F.
   PUBLIC PUB_nProjectFileHandle := 0
   PUBLIC PUB_cProjectFolder := ""
   PUBLIC PUB_bIgnoreVersionProject := .F.
   //
   PUBLIC PUB_bW800 := if( GetDesktopWidth() <     1024 , .T. , .F. )
   //
   PUBLIC PUB_cAutoLog := ""
   PUBLIC PUB_cAutoLogTmp := ""
   PUBLIC PUB_bLogOnlyError := .F.
   PUBLIC PUB_cSecu := dtos(date())+US_strCero(int(seconds()),5)+PUB_cCharFileNameTemp
   PUBLIC PUB_cUS_RedirOpt := " -eo -o "
   PUBLIC PUB_bDebugActive := .F.
   PUBLIC PUB_bIsProcessing := .f.
   PUBLIC PUB_xHarbourMT := ""
   PUBLIC IsBorland := .T. // (Default)
   PUBLIC IsMinGW     := .F.
   PUBLIC IsPelles := .F.
   PUBLIC ProgLength := 0
   PUBLIC bAutoExit := .F.
   PUBLIC bConsole := .F.
   PUBLIC bUpx        := .F.
   PUBLIC bOutputSuffix := .F.
// Public cUpxOpt     := "--no-progress --compress-icons=0"     // con esta opcion NO comprime los ICONOS
   PUBLIC cUpxOpt     := "--no-progress"                        // por default comprime los iconos excepto el primero
   PUBLIC cFormTool := "AUTO"
   PUBLIC cDbfTool := "DBU"
   PUBLIC cHeadTool := "EDITOR"
   PUBLIC cResTool := "EDITOR"
   PUBLIC cOutputType := "SRCEXE"
   PUBLIC cOutputCopyMove := "NONE"
   PUBLIC cOutputRename     := "NONE"
   PUBLIC LibsActiva := ""
   PUBLIC PagePRG     := if( PUB_bW800 , "SRC" , "Sources" )
   PUBLIC PageHEA     := "H && CH"
   PUBLIC PagePAN     := "FMG && RC"
   PUBLIC PageDBF     := "DBF"
   PUBLIC PageLIB     := "LIB"
   PUBLIC PageHLP     := "SHG"
   PUBLIC PageSysout := if( PUB_bW800 , "Log" , "Log Build Process" )
   PUBLIC PageOUT     := if( PUB_bW800 , "Out" , "Output Error/Module" )
   PUBLIC PageWWW     := if( PUB_bW800 , "www" , "www" )
   PUBLIC PageCdQ     := if( PUB_bW800 , "QPM" , "QPM" )
   PUBLIC vSinLoadWindow           := {}
   PUBLIC vSinInclude              := {}
   PUBLIC vXRefPrgHea              := {}
   PUBLIC vXRefPrgFmg              := {}
   PUBLIC cLastProjectFolder       := ""
   PUBLIC bLogActivity             := .F.
   PUBLIC PUB_DeleteAux            := .T.
   PUBLIC PUB_vAutoRun             := {}
   PUBLIC RunControlFile           := {}
   PUBLIC bRunApp                  := .F.
   PUBLIC PUB_bLite                := .F.
   PUBLIC bWaitForBuild            := .F.
   PUBLIC bBuildFinished           := .F.
   PUBLIC nPagePrg                 := 1
   PUBLIC nPageHea                 := 2
   PUBLIC nPagePan                 := 3
   PUBLIC nPageDbf                 := 4
   PUBLIC nPageLib                 := 5
   PUBLIC nTotalPages              := nPageLib
#ifdef QPM_SHG
   PUBLIC nPageHlp                 := nTotalPages + 1
   nTotalPages++
#endif
   PUBLIC nPageSysout              := nTotalPages + 1
   nTotalPages++
   PUBLIC nPageOut                 := nTotalPages + 1
   nTotalPages++
   //
   PUBLIC GBL_TabGridNameFocus := ""
   //
   PUBLIC PUB_ErrorLogTime := 0
   //
   //
   PUBLIC GBL_HR_cLastExternalFileName := ""
   //
   PUBLIC vDbfHeaders := { 'One' , 'Two' }
   PUBLIC vDbfWidths := { 50 , 50 }
   PUBLIC vDbfJustify := { BROWSE_JTFY_LEFT , BROWSE_JTFY_LEFT }
   //
   PUBLIC bEditorLongName := .F.
   PUBLIC bSuspendControlEdit := .F.
   //
   PUBLIC bPrgSorting := .F.
   PUBLIC bHeaSorting := .F.
   PUBLIC bPanSorting := .F.
   PUBLIC bDbfSorting := .F.
   PUBLIC bIncSorting := .F.
   PUBLIC bExcSorting := .F.
   PUBLIC bHlpSorting := .F.
   //
   PUBLIC bPrgMoving := .F.
   PUBLIC bHeaMoving := .F.
   PUBLIC bPanMoving := .F.
   PUBLIC bDbfMoving := .F.
   PUBLIC bIncMoving := .F.
   PUBLIC bExcMoving := .F.
   PUBLIC bHlpMoving := .F.
   //
   PUBLIC cProjectFolderIdent := "<ProjectFolder>"
   //
   PUBLIC PUB_nGridImgNone        := 0
   PUBLIC PUB_nGridImgTilde       := 1
   PUBLIC PUB_nGridImgEquis       := 2
   PUBLIC PUB_nGridImgSearchOk    := 3    // Esto quiere decir que para activar esta imagen hay que activar el bit 3
   PUBLIC PUB_nGridImgEdited      := 4
   PUBLIC PUB_nGridImgSearchNotOk := 5
   PUBLIC PUB_nGridImgHlpGlobalFoot := 6
   PUBLIC PUB_nGridImgHlpWelcome  := 7
   PUBLIC PUB_nGridImgHlpBook     := 8
   PUBLIC PUB_nGridImgHlpPage     := 9
   PUBLIC PUB_nGridImgTop         := 9    // igual a la ultima variable GridImg...
   //
   PUBLIC vImagesGrid          := {}
   aadd( vImagesGrid , 'GridNone' )                        // 0        0            0000 0000
   aadd( vImagesGrid , 'GridTilde' )                       // 1        1            0000 0001
   aadd( vImagesGrid , 'GridEquis' )                       // 2        2            0000 0010
   aadd( vImagesGrid , 'GridTildeEquis' )                  // 3        3            0000 0011
   aadd( vImagesGrid , 'GridSearchok' )                    // 4        4            0000 0100
   aadd( vImagesGrid , 'GridTildeSearchok' )               // 5        5            0000 0101
   aadd( vImagesGrid , 'GridEquisSearchok' )               // 6        6            0000 0110
   aadd( vImagesGrid , 'GridTildeEquisSearchok' )          // 7        7            0000 0111
   aadd( vImagesGrid , 'GridEdited' )                      // 8        8            0000 1000
   aadd( vImagesGrid , 'GridTildeEdited' )                 // 9        9            0000 1001
   aadd( vImagesGrid , 'GridEquisEdited' )                 // 10      10            0000 1010
   aadd( vImagesGrid , 'GridTildeEquisEdited' )            // 11      11            0000 1011
   aadd( vImagesGrid , 'GridSearchokEdited' )              // 12      12            0000 1100
   aadd( vImagesGrid , 'GridTildeSearchokEdited' )         // 13      13            0000 1101
   aadd( vImagesGrid , 'GridEquisSearchokEdited' )         // 14      14            0000 1110
   aadd( vImagesGrid , 'GridTildeEquisSearchokEdited' )    // 15      15            0000 1111
   aadd( vImagesGrid , 'GridSearchNotOk')                  // 16      16            0001 0000
   aadd( vImagesGrid , 'GridHlpGlobalFoot')                // 17      32            0010 0000
   aadd( vImagesGrid , 'GridHlpGlobalFootSearchOk')        // 18      36            0010 0100
   aadd( vImagesGrid , 'GridHlpWelcome')                   // 19      64            0100 0000
   aadd( vImagesGrid , 'GridHlpWelcomeSearchOk')           // 20      68            0100 0100
   aadd( vImagesGrid , 'GridHlpBook')                      // 21     128            1000 0000
   aadd( vImagesGrid , 'GridHlpBookSearchOk')              // 22     132            1000 0100
   aadd( vImagesGrid , 'GridHlpPage')                      // 23     256          1 0000 0000
   aadd( vImagesGrid , 'GridHlpPageSearchOk')              // 24     260          1 0000 0100
   PUBLIC vImagesTranslateGrid := {}
   /* Para representar 256 pongo 23 */
   aadd( vImagesTranslateGrid , {   0 ,   0 } )
   aadd( vImagesTranslateGrid , {   1 ,   1 } )
   aadd( vImagesTranslateGrid , {   2 ,   2 } )
   aadd( vImagesTranslateGrid , {   3 ,   3 } )
   aadd( vImagesTranslateGrid , {   4 ,   4 } )
   aadd( vImagesTranslateGrid , {   5 ,   5 } )
   aadd( vImagesTranslateGrid , {   6 ,   6 } )
   aadd( vImagesTranslateGrid , {   7 ,   7 } )
   aadd( vImagesTranslateGrid , {   8 ,   8 } )
   aadd( vImagesTranslateGrid , {   9 ,   9 } )
   aadd( vImagesTranslateGrid , {  10 ,  10 } )
   aadd( vImagesTranslateGrid , {  11 ,  11 } )
   aadd( vImagesTranslateGrid , {  12 ,  12 } )
   aadd( vImagesTranslateGrid , {  13 ,  13 } )
   aadd( vImagesTranslateGrid , {  14 ,  14 } )
   aadd( vImagesTranslateGrid , {  15 ,  15 } )
   aadd( vImagesTranslateGrid , {  16 ,  16 } )
   aadd( vImagesTranslateGrid , {  32 ,  17 } )
   aadd( vImagesTranslateGrid , {  36 ,  18 } )
   aadd( vImagesTranslateGrid , {  64 ,  19 } )
   aadd( vImagesTranslateGrid , {  68 ,  20 } )
   aadd( vImagesTranslateGrid , { 128 ,  21 } )
   aadd( vImagesTranslateGrid , { 132 ,  22 } )
   aadd( vImagesTranslateGrid , { 256 ,  23 } )
   aadd( vImagesTranslateGrid , { 260 ,  24 } )
// aadd( vImagesTranslateGrid , { 512 ,  25 } )
// aadd( vImagesTranslateGrid , { 1024 ,  26 } )
// aadd( vImagesTranslateGrid , { 2048 ,  27 } )
// aadd( vImagesTranslateGrid , { 2560 ,  28 } )
// aadd( vImagesTranslateGrid , { 3072 ,  29 } )
   //
   PUBLIC bGlobalSearch         := .F.   /* Flag general para saber si estoy en Global Search */
   PUBLIC cLastGlobalSearch     := ""
   PUBLIC bLastGlobalSearchFun := .F.
   PUBLIC bLastGlobalSearchDbf := .F.
   PUBLIC bAvisoDbfGlobalSearchLow := .T.
   PUBLIC bAvisoDbfDataSearchLow := .T.
   //
   PUBLIC bDbfDataSearchAsk     := .T.
   PUBLIC cDbfDataSearchAskRpta := ""
   //
   PUBLIC aGridPrg := {}
   PUBLIC nGridPrgLastRow := 0
   PUBLIC NCOLPRGSTATUS := 1
   PUBLIC NCOLPRGRECOMP := 2
   PUBLIC NCOLPRGNAME     := 3
   PUBLIC NCOLPRGFULLNAME := 4
   PUBLIC NCOLPRGOFFSET := 5
   PUBLIC NCOLPRGEDIT     := 6
   PUBLIC NCOLPRGRECOVERY := 7
   PUBLIC bSortPrgAsc     := .T.
   PUBLIC aGridHea := {}
   PUBLIC nGridHeaLastRow := 0
   PUBLIC NCOLHEASTATUS := 1
   PUBLIC NCOLHEANAME     := 2
   PUBLIC NCOLHEAFULLNAME := 3
   PUBLIC NCOLHEAOFFSET := 4
   PUBLIC NCOLHEAEDIT     := 5
   PUBLIC NCOLHEARECOVERY := 6
   PUBLIC bSortHeaAsc     := .T.
   PUBLIC aGridPan := {}
   PUBLIC nGridPanLastRow := 0
   PUBLIC NCOLPANSTATUS := 1
   PUBLIC NCOLPANNAME     := 2
   PUBLIC NCOLPANFULLNAME := 3
   PUBLIC NCOLPANOFFSET := 4
   PUBLIC NCOLPANEDIT     := 5
   PUBLIC NCOLPANRECOVERY := 6
   PUBLIC bSortPanAsc     := .T.
   PUBLIC aGridDbf := {}
   PUBLIC nGridDbfLastRow := 0
   PUBLIC NCOLDBFSTATUS := 1
   PUBLIC NCOLDBFNAME     := 2
   PUBLIC NCOLDBFFULLNAME := 3
   PUBLIC NCOLDBFOFFSET := 4
   PUBLIC NCOLDBFEDIT     := 5
   PUBLIC NCOLDBFSEARCH := 6
   PUBLIC bSortDbfAsc     := .T.
   PUBLIC aGridInc := {}
   PUBLIC NCOLINCSTATUS := 1
   PUBLIC NCOLINCNAME     := 2
   PUBLIC NCOLINCFULLNAME := 3
   PUBLIC nColLibStatus := NCOLINCSTATUS       && Auxliar para procesos que no diferencian entre inc y exc
   PUBLIC nColLibFullName := NCOLINCFULLNAME && Auxliar para procesos que no diferencian entre inc y exc
   PUBLIC bSortIncAsc     := .T.
   PUBLIC aGridExc := {}
   PUBLIC NCOLEXCSTATUS := 1
   PUBLIC NCOLEXCNAME     := 2
   PUBLIC bSortExcAsc     := .T.
   PUBLIC aGridHlp := {}
   PUBLIC nGridHlpLastRow := 0
   PUBLIC NCOLHLPSTATUS := 1
   PUBLIC NCOLHLPTOPIC := 2
   PUBLIC NCOLHLPNICK     := 3
   PUBLIC NCOLHLPOFFSET := 4
   PUBLIC NCOLHLPEDIT     := 5
   PUBLIC bSortHlpAsc     := .T.
   //
   PUBLIC SHG_Database := ""
   PUBLIC SHG_DbSize      := 0
   PUBLIC SHG_LastFolderImg := ""
   PUBLIC SHG_CheckTypeOutput := .F.
   PUBLIC SHG_HtmlFolder := ""
   PUBLIC SHG_WWW         := ""
   PUBLIC SHG_BaseOK      := .F.

/*
   PUBLIC SHG_vImagesGrid := {}
   aadd( SHG_vImagesGrid , 'SHG_ImgNone' )      // 0                     0000 0000
   aadd( SHG_vImagesGrid , 'SHG_ImgBook' )      // 1                     0000 0001
   aadd( SHG_vImagesGrid , 'SHG_ImgPage' )      // 2                     0000 0010
   aadd( SHG_vImagesGrid , 'SHG_ImgFoot' )      // 3                     0000 0011
   aadd( SHG_vImagesGrid , 'SHG_ImgWelcome' )   // 4                     0000 0100
*/
   //
   PUBLIC bAutoSyncTab := .T.
   PUBLIC bRunParm        := .F.
   PUBLIC GBL_cRunParm := ""
   PUBLIC bBuildRun       := .F.
   PUBLIC PUB_bForceRunFromMsgOk := .F.
   PUBLIC bBuildRunBack := .F.
   //
   PUBLIC bNumberOnPrg := .F.
   PUBLIC bNumberOnHea := .F.
   PUBLIC bNumberOnPan := .F.
   PUBLIC bPpoDisplayado := .F.
   PUBLIC cPpoCaretPrg := "1"
   //
   PUBLIC nGDbfRecord     := 1
   //
   PUBLIC bDbfAutoView := .T.
   //
   PUBLIC oHlpRichEdit := US_RichEdit():New()
   //
   PUBLIC vLastOpen:={}
   PUBLIC vLastSearch:={}
   //
   //
#ifdef QPM_HOTRECOVERY
   QPM_HotInitPublicVariables()
#endif
   //
   PUBLIC Gbl_TEditor       := ""
   PUBLIC Gbl_Text_HMI      := ""
   PUBLIC Gbl_Text_HMGSIDE := ""
   PUBLIC Gbl_Text_DBF      := ""
   PUBLIC Gbl_Comillas_DBF := '"'
   //
   QPM_VAR0 Public DefineMiniGui1  := DEF_MG_MINIGUI1     // Oficial MiniGui 1.x
   QPM_VAR0 Public DefineMiniGui3  := DEF_MG_MINIGUI3     // Oficial MiniGui 3.x
   QPM_VAR0 Public DefineExtended1 := DEF_MG_EXTENDED1    // Extended MiniGui 1.x
   QPM_VAR0 Public DefineOohg3     := DEF_MG_OOHG3        // oohg 3.x
   QPM_VAR0 Public DefineHarbour   := DEF_MG_HARBOUR      // Harbour
   QPM_VAR0 Public DefineXHarbour  := DEF_MG_XHARBOUR     // xHarbour
   QPM_VAR0 Public DefineBorland   := DEF_MG_BORLAND      // Borland C
   QPM_VAR0 Public DefineMinGW     := DEF_MG_MINGW        // MinGW C
   QPM_VAR0 Public DefinePelles    := DEF_MG_PELLES       // Pelles C
   //
// NOTE: added suport for MinGW and Extended
   PUBLIC vSuffix := { { DefineMiniGui1+DefineBorland+DefineHarbour   , "MiniGUI Oficial 1.x with Borland C and Harbour" } ;
                     , { DefineMiniGui1+DefineBorland+DefineXHarbour  , "MiniGUI Oficial 1.x with Borland C and xHarbour" } ;
                     , { DefineExtended1+DefineBorland+DefineHarbour  , "MiniGUI Extended 1.x with Borland C and Harbour" } ;
                     , { DefineExtended1+DefineBorland+DefineXHarbour , "MiniGUI Extended 1.x with Borland C and xHarbour" } ;
                     , { DefineExtended1+DefineMinGW+DefineHarbour    , "MiniGUI Extended 1.x with MinGW and Harbour" } ;
                     , { DefineExtended1+DefineMinGW+DefineXHarbour   , "MiniGUI Extended 1.x with MinGW and xHarbour" } ;
                     , { DefineOohg3+DefineBorland+DefineHarbour      , "OOHG 3.x with Borland C and Harbour" } ;
                     , { DefineOohg3+DefineBorland+DefineXHarbour     , "OOHG 3.x with Borland C and xHarbour" } ;
                     , { DefineOohg3+DefineMinGW+DefineHarbour        , "OOHG 3.x with MinGW and Harbour" } ;
                     , { DefineOohg3+DefineMinGW+DefineXHarbour       , "OOHG 3.x with MinGW and xHarbour" } ;
                     , { DefineOohg3+DefinePelles+DefineHarbour       , "OOHG 3.x with Pelles C and Harbour" } ;
                     , { DefineOohg3+DefinePelles+DefineXHarbour      , "OOHG 3.x with Pelles C and xHarbour" } ;
                     , { DefineMiniGui3+DefineMinGW+DefineHarbour     , "MiniGUI Oficial 3.x with MinGW and Harbour" } ;
                     , { DefineMiniGui3+DefineMinGW+DefineXHarbour    , "MiniGUI Oficial 3.x with MinGW and xHarbour" } ;
                     }
   //
   /* MiniGui Oficial 1 */
   QPM_VAR2 Public Gbl_T_M_ DEF_MG_MINIGUI1 DEF_MG_BORLAND := ""
   QPM_VAR2 Public Gbl_T_C_ DEF_MG_MINIGUI1 DEF_MG_BORLAND := ""
   QPM_VAR2 Public Gbl_T_H_ DEF_MG_MINIGUI1 DEF_MG_BORLAND := ""
   QPM_VAR2 Public Gbl_T_X_ DEF_MG_MINIGUI1 DEF_MG_BORLAND := ""
   QPM_VAR1 Public IncludeLibs          DEF_MG_MINIGUI1 DEF_MG_BORLAND DEF_MG_HARBOUR := {}
   QPM_VAR1 Public ExcludeLibs          DEF_MG_MINIGUI1 DEF_MG_BORLAND DEF_MG_HARBOUR := {}
   QPM_VAR1 Public vExtraFoldersForLibs DEF_MG_MINIGUI1 DEF_MG_BORLAND DEF_MG_HARBOUR := {}
   QPM_VAR1 Public cLastLibFolder       DEF_MG_MINIGUI1 DEF_MG_BORLAND DEF_MG_HARBOUR := ""
   QPM_VAR1 Public vLibDefault          DEF_MG_MINIGUI1 DEF_MG_BORLAND DEF_MG_HARBOUR := {}
   QPM_VAR1 Public IncludeLibs          DEF_MG_MINIGUI1 DEF_MG_BORLAND DEF_MG_XHARBOUR := {}
   QPM_VAR1 Public ExcludeLibs          DEF_MG_MINIGUI1 DEF_MG_BORLAND DEF_MG_XHARBOUR := {}
   QPM_VAR1 Public vExtraFoldersForLibs DEF_MG_MINIGUI1 DEF_MG_BORLAND DEF_MG_XHARBOUR := {}
   QPM_VAR1 Public cLastLibFolder       DEF_MG_MINIGUI1 DEF_MG_BORLAND DEF_MG_XHARBOUR := ""
   QPM_VAR1 Public vLibDefault          DEF_MG_MINIGUI1 DEF_MG_BORLAND DEF_MG_XHARBOUR := {}
   /* MiniGui Oficial 2 */
   QPM_VAR2 Public Gbl_T_M_ DEF_MG_MINIGUI3 DEF_MG_MINGW := ""
   QPM_VAR2 Public Gbl_T_C_ DEF_MG_MINIGUI3 DEF_MG_MINGW := ""
   QPM_VAR2 Public Gbl_T_H_ DEF_MG_MINIGUI3 DEF_MG_MINGW := ""
   QPM_VAR2 Public Gbl_T_X_ DEF_MG_MINIGUI3 DEF_MG_MINGW := ""
   QPM_VAR1 Public IncludeLibs          DEF_MG_MINIGUI3 DEF_MG_MINGW DEF_MG_HARBOUR := {}
   QPM_VAR1 Public ExcludeLibs          DEF_MG_MINIGUI3 DEF_MG_MINGW DEF_MG_HARBOUR := {}
   QPM_VAR1 Public vExtraFoldersForLibs DEF_MG_MINIGUI3 DEF_MG_MINGW DEF_MG_HARBOUR := {}
   QPM_VAR1 Public cLastLibFolder       DEF_MG_MINIGUI3 DEF_MG_MINGW DEF_MG_HARBOUR := ""
   QPM_VAR1 Public vLibDefault          DEF_MG_MINIGUI3 DEF_MG_MINGW DEF_MG_HARBOUR := {}
   QPM_VAR1 Public IncludeLibs          DEF_MG_MINIGUI3 DEF_MG_MINGW DEF_MG_XHARBOUR := {}
   QPM_VAR1 Public ExcludeLibs          DEF_MG_MINIGUI3 DEF_MG_MINGW DEF_MG_XHARBOUR := {}
   QPM_VAR1 Public vExtraFoldersForLibs DEF_MG_MINIGUI3 DEF_MG_MINGW DEF_MG_XHARBOUR := {}
   QPM_VAR1 Public cLastLibFolder       DEF_MG_MINIGUI3 DEF_MG_MINGW DEF_MG_XHARBOUR := ""
   QPM_VAR1 Public vLibDefault          DEF_MG_MINIGUI3 DEF_MG_MINGW DEF_MG_XHARBOUR := {}
   /* MiniGui Extended 1 */
   QPM_VAR2 Public Gbl_T_M_ DEF_MG_EXTENDED1 DEF_MG_BORLAND := ""
   QPM_VAR2 Public Gbl_T_C_ DEF_MG_EXTENDED1 DEF_MG_BORLAND := ""
   QPM_VAR2 Public Gbl_T_H_ DEF_MG_EXTENDED1 DEF_MG_BORLAND := ""
   QPM_VAR2 Public Gbl_T_X_ DEF_MG_EXTENDED1 DEF_MG_BORLAND := ""
   QPM_VAR1 Public IncludeLibs          DEF_MG_EXTENDED1 DEF_MG_BORLAND DEF_MG_HARBOUR := {}
   QPM_VAR1 Public ExcludeLibs          DEF_MG_EXTENDED1 DEF_MG_BORLAND DEF_MG_HARBOUR := {}
   QPM_VAR1 Public vExtraFoldersForLibs DEF_MG_EXTENDED1 DEF_MG_BORLAND DEF_MG_HARBOUR := {}
   QPM_VAR1 Public cLastLibFolder       DEF_MG_EXTENDED1 DEF_MG_BORLAND DEF_MG_HARBOUR := ""
   QPM_VAR1 Public vLibDefault          DEF_MG_EXTENDED1 DEF_MG_BORLAND DEF_MG_HARBOUR := {}
   QPM_VAR1 Public IncludeLibs          DEF_MG_EXTENDED1 DEF_MG_BORLAND DEF_MG_XHARBOUR := {}
   QPM_VAR1 Public ExcludeLibs          DEF_MG_EXTENDED1 DEF_MG_BORLAND DEF_MG_XHARBOUR := {}
   QPM_VAR1 Public vExtraFoldersForLibs DEF_MG_EXTENDED1 DEF_MG_BORLAND DEF_MG_XHARBOUR := {}
   QPM_VAR1 Public cLastLibFolder       DEF_MG_EXTENDED1 DEF_MG_BORLAND DEF_MG_XHARBOUR := ""
   QPM_VAR1 Public vLibDefault          DEF_MG_EXTENDED1 DEF_MG_BORLAND DEF_MG_XHARBOUR := {}
// NOTE: added suport for MinGW and Extended
   QPM_VAR2 Public Gbl_T_M_ DEF_MG_EXTENDED1 DEF_MG_MINGW := ""
   QPM_VAR2 Public Gbl_T_C_ DEF_MG_EXTENDED1 DEF_MG_MINGW := ""
   QPM_VAR2 Public Gbl_T_H_ DEF_MG_EXTENDED1 DEF_MG_MINGW := ""
   QPM_VAR2 Public Gbl_T_X_ DEF_MG_EXTENDED1 DEF_MG_MINGW := ""
   QPM_VAR1 Public IncludeLibs          DEF_MG_EXTENDED1 DEF_MG_MINGW DEF_MG_HARBOUR := {}
   QPM_VAR1 Public ExcludeLibs          DEF_MG_EXTENDED1 DEF_MG_MINGW DEF_MG_HARBOUR := {}
   QPM_VAR1 Public vExtraFoldersForLibs DEF_MG_EXTENDED1 DEF_MG_MINGW DEF_MG_HARBOUR := {}
   QPM_VAR1 Public cLastLibFolder       DEF_MG_EXTENDED1 DEF_MG_MINGW DEF_MG_HARBOUR := ""
   QPM_VAR1 Public vLibDefault          DEF_MG_EXTENDED1 DEF_MG_MINGW DEF_MG_HARBOUR := {}
   QPM_VAR1 Public IncludeLibs          DEF_MG_EXTENDED1 DEF_MG_MINGW DEF_MG_XHARBOUR := {}
   QPM_VAR1 Public ExcludeLibs          DEF_MG_EXTENDED1 DEF_MG_MINGW DEF_MG_XHARBOUR := {}
   QPM_VAR1 Public vExtraFoldersForLibs DEF_MG_EXTENDED1 DEF_MG_MINGW DEF_MG_XHARBOUR := {}
   QPM_VAR1 Public cLastLibFolder       DEF_MG_EXTENDED1 DEF_MG_MINGW DEF_MG_XHARBOUR := ""
   QPM_VAR1 Public vLibDefault          DEF_MG_EXTENDED1 DEF_MG_MINGW DEF_MG_XHARBOUR := {}
   /* oohg 1 */
   QPM_VAR2 Public Gbl_T_M_ DEF_MG_OOHG3 DEF_MG_BORLAND := ""
   QPM_VAR2 Public Gbl_T_C_ DEF_MG_OOHG3 DEF_MG_BORLAND := ""
   QPM_VAR2 Public Gbl_T_H_ DEF_MG_OOHG3 DEF_MG_BORLAND := ""
   QPM_VAR2 Public Gbl_T_X_ DEF_MG_OOHG3 DEF_MG_BORLAND := ""
   QPM_VAR1 Public IncludeLibs          DEF_MG_OOHG3 DEF_MG_BORLAND DEF_MG_HARBOUR := {}
   QPM_VAR1 Public ExcludeLibs          DEF_MG_OOHG3 DEF_MG_BORLAND DEF_MG_HARBOUR := {}
   QPM_VAR1 Public vExtraFoldersForLibs DEF_MG_OOHG3 DEF_MG_BORLAND DEF_MG_HARBOUR := {}
   QPM_VAR1 Public cLastLibFolder       DEF_MG_OOHG3 DEF_MG_BORLAND DEF_MG_HARBOUR := ""
   QPM_VAR1 Public vLibDefault          DEF_MG_OOHG3 DEF_MG_BORLAND DEF_MG_HARBOUR := {}
   QPM_VAR1 Public IncludeLibs          DEF_MG_OOHG3 DEF_MG_BORLAND DEF_MG_XHARBOUR := {}
   QPM_VAR1 Public ExcludeLibs          DEF_MG_OOHG3 DEF_MG_BORLAND DEF_MG_XHARBOUR := {}
   QPM_VAR1 Public vExtraFoldersForLibs DEF_MG_OOHG3 DEF_MG_BORLAND DEF_MG_XHARBOUR := {}
   QPM_VAR1 Public cLastLibFolder       DEF_MG_OOHG3 DEF_MG_BORLAND DEF_MG_XHARBOUR := ""
   QPM_VAR1 Public vLibDefault          DEF_MG_OOHG3 DEF_MG_BORLAND DEF_MG_XHARBOUR := {}
   QPM_VAR2 Public Gbl_T_M_ DEF_MG_OOHG3 DEF_MG_MINGW := ""
   QPM_VAR2 Public Gbl_T_C_ DEF_MG_OOHG3 DEF_MG_MINGW := ""
   QPM_VAR2 Public Gbl_T_H_ DEF_MG_OOHG3 DEF_MG_MINGW := ""
   QPM_VAR2 Public Gbl_T_X_ DEF_MG_OOHG3 DEF_MG_MINGW := ""
   QPM_VAR1 Public IncludeLibs          DEF_MG_OOHG3 DEF_MG_MINGW DEF_MG_HARBOUR := {}
   QPM_VAR1 Public ExcludeLibs          DEF_MG_OOHG3 DEF_MG_MINGW DEF_MG_HARBOUR := {}
   QPM_VAR1 Public vExtraFoldersForLibs DEF_MG_OOHG3 DEF_MG_MINGW DEF_MG_HARBOUR := {}
   QPM_VAR1 Public cLastLibFolder       DEF_MG_OOHG3 DEF_MG_MINGW DEF_MG_HARBOUR := ""
   QPM_VAR1 Public vLibDefault          DEF_MG_OOHG3 DEF_MG_MINGW DEF_MG_HARBOUR := {}
   QPM_VAR1 Public IncludeLibs          DEF_MG_OOHG3 DEF_MG_MINGW DEF_MG_XHARBOUR := {}
   QPM_VAR1 Public ExcludeLibs          DEF_MG_OOHG3 DEF_MG_MINGW DEF_MG_XHARBOUR := {}
   QPM_VAR1 Public vExtraFoldersForLibs DEF_MG_OOHG3 DEF_MG_MINGW DEF_MG_XHARBOUR := {}
   QPM_VAR1 Public cLastLibFolder       DEF_MG_OOHG3 DEF_MG_MINGW DEF_MG_XHARBOUR := ""
   QPM_VAR1 Public vLibDefault          DEF_MG_OOHG3 DEF_MG_MINGW DEF_MG_XHARBOUR := {}
   QPM_VAR2 Public Gbl_T_M_ DEF_MG_OOHG3 DEF_MG_PELLES := ""
   QPM_VAR2 Public Gbl_T_C_ DEF_MG_OOHG3 DEF_MG_PELLES := ""
   QPM_VAR2 Public Gbl_T_H_ DEF_MG_OOHG3 DEF_MG_PELLES := ""
   QPM_VAR2 Public Gbl_T_X_ DEF_MG_OOHG3 DEF_MG_PELLES := ""
   QPM_VAR1 Public IncludeLibs          DEF_MG_OOHG3 DEF_MG_PELLES DEF_MG_HARBOUR := {}
   QPM_VAR1 Public ExcludeLibs          DEF_MG_OOHG3 DEF_MG_PELLES DEF_MG_HARBOUR := {}
   QPM_VAR1 Public vExtraFoldersForLibs DEF_MG_OOHG3 DEF_MG_PELLES DEF_MG_HARBOUR := {}
   QPM_VAR1 Public cLastLibFolder       DEF_MG_OOHG3 DEF_MG_PELLES DEF_MG_HARBOUR := ""
   QPM_VAR1 Public vLibDefault          DEF_MG_OOHG3 DEF_MG_PELLES DEF_MG_HARBOUR := {}
   QPM_VAR1 Public IncludeLibs          DEF_MG_OOHG3 DEF_MG_PELLES DEF_MG_XHARBOUR := {}
   QPM_VAR1 Public ExcludeLibs          DEF_MG_OOHG3 DEF_MG_PELLES DEF_MG_XHARBOUR := {}
   QPM_VAR1 Public vExtraFoldersForLibs DEF_MG_OOHG3 DEF_MG_PELLES DEF_MG_XHARBOUR := {}
   QPM_VAR1 Public cLastLibFolder       DEF_MG_OOHG3 DEF_MG_PELLES DEF_MG_XHARBOUR := ""
   QPM_VAR1 Public vLibDefault          DEF_MG_OOHG3 DEF_MG_PELLES DEF_MG_XHARBOUR := {}
   //
   PUBLIC QPM_KillerProcessLast := {}
   PUBLIC QPM_KillerbLate := .T.
   PUBLIC QPM_KillerModule := ""
   PUBLIC QPM_bKiller := .F.
   //
   PUBLIC cPrj_VersionAnt:= "00000000"   // VVRRBBBB
   PUBLIC cPrj_Version    := "00000000"  // VVRRBBBB
   //
   PUBLIC Prj_Radio_Harbour     := DEF_RG_HARBOUR
   PUBLIC Prj_Check_HarbourIs31 := .T.
   //PUBLIC Prj_Check_34          := .F.
   //PUBLIC Prj_Check_34_Enabled := .F.
   PUBLIC Prj_Radio_Cpp         := DEF_RG_BORLAND
   PUBLIC Prj_Radio_MiniGui     := DEF_RG_EXTENDED1
   PUBLIC Prj_Check_Console     := .F.
   PUBLIC Prj_Radio_OutputType := DEF_RG_EXE
   PUBLIC Prj_Radio_OutputCopyMove := 1
   PUBLIC Prj_Text_OutputCopyMoveFolder := ""
   PUBLIC Prj_Radio_OutputRename   := 1
   PUBLIC Prj_Text_OutputRenameNewName := ""
   PUBLIC Prj_Check_OutputSuffix   := .F.
   PUBLIC Prj_Check_Upx            := .F.
   PUBLIC Prj_Radio_FormTool       := 1
   PUBLIC Prj_Radio_DbFTool        := 1
   PUBLIC Prj_ExtraRunCmdFINAL     := ""
   PUBLIC Prj_ExtraRunProjQPM      := ""
   PUBLIC Prj_ExtraRunCmdEXE       := ""
   PUBLIC Prj_ExtraRunCmdFREE      := ""
   PUBLIC Prj_ExtraRunCmdQPMParm   := ""
   PUBLIC Prj_ExtraRunCmdEXEParm   := ""
   PUBLIC Prj_ExtraRunCmdFREEParm := ""
   PUBLIC Prj_ExtraRunType         := "NONE"
   PUBLIC Prj_ExtraRunQPMRadio         := "BUILD"
   PUBLIC Prj_ExtraRunQPMLite          := .T.
   PUBLIC Prj_ExtraRunQPMForceFull     := .F.
   PUBLIC Prj_ExtraRunQPMRun           := .F.
   PUBLIC Prj_ExtraRunQPMButtonRun     := .F.
   PUBLIC Prj_ExtraRunQPMClear         := .F.
   PUBLIC Prj_ExtraRunQPMLog           := .F.
   PUBLIC Prj_ExtraRunQPMLogOnlyError := .F.
   PUBLIC Prj_ExtraRunQPMAutoExit      := .T.
   PUBLIC Prj_ExtraRunExeWait     := .T.
   PUBLIC Prj_ExtraRunExePause    := .T.
   PUBLIC Prj_ExtraRunFreeWait    := .T.
   PUBLIC Prj_ExtraRunFreePause   := .T.
   PUBLIC Tmp_ExtraRunCmdFINAL    := ""
   PUBLIC Tmp_ExtraRunProjQPM     := ""
   PUBLIC Tmp_ExtraRunCmdEXE      := ""
   PUBLIC Tmp_ExtraRunCmdFREE     := ""
   PUBLIC Tmp_ExtraRunCmdQPMParm := ""
   PUBLIC Tmp_ExtraRunCmdEXEParm := ""
   PUBLIC Tmp_ExtraRunCmdFREEParm := ""
   PUBLIC Tmp_ExtraRunType        := "NONE"
   PUBLIC Tmp_ExtraRunQPMRadio         := ""
   PUBLIC Tmp_ExtraRunQPMLite          := .T.
   PUBLIC Tmp_ExtraRunQPMForceFull     := .F.
   PUBLIC Tmp_ExtraRunQPMRun           := .F.
   PUBLIC Tmp_ExtraRunQPMButtonRun     := .F.
   PUBLIC Tmp_ExtraRunQPMClear         := .F.
   PUBLIC Tmp_ExtraRunQPMLog           := .F.
   PUBLIC Tmp_ExtraRunQPMLogOnlyError := .F.
   PUBLIC Tmp_ExtraRunQPMAutoExit      := .T.
   PUBLIC Tmp_ExtraRunExeWait    := .T.
   PUBLIC Tmp_ExtraRunExePause   := .T.
   PUBLIC Tmp_ExtraRunFreeWait   := .T.
   PUBLIC Tmp_ExtraRunFreePause := .T.
   //
   PUBLIC bConvert := .F.
   PUBLIC cConvert := ""
   //
   PUBLIC vExtraFoldersForSearch := {}
   //
   PUBLIC bWarningCpp                := .T.
   //
   PUBLIC vExeList := {}
   aadd( vExeList , PUB_cQPM_Folder+DEF_SLASH+"QPM.exe"                   )
   aadd( vExeList , PUB_cQPM_Folder+DEF_SLASH+"QPM.chm"                   )
   aadd( vExeList , PUB_cQPM_Folder+DEF_SLASH+"US_Slash.exe"              )
   aadd( vExeList , PUB_cQPM_Folder+DEF_SLASH+"US_Shell.exe"              )
   aadd( vExeList , PUB_cQPM_Folder+DEF_SLASH+"US_Make.exe"               )
   aadd( vExeList , PUB_cQPM_Folder+DEF_SLASH+"US_Msg.exe"                )
   aadd( vExeList , PUB_cQPM_Folder+DEF_SLASH+"US_Res.exe"                )
   aadd( vExeList , PUB_cQPM_Folder+DEF_SLASH+"US_Run.exe"                )
   aadd( vExeList , PUB_cQPM_Folder+DEF_SLASH+"US_Redir.exe"              )   // Redireccionador de comandos MinGW
   aadd( vExeList , PUB_cQPM_Folder+DEF_SLASH+"US_ImpDef.exe"             )   // Gener .def from DLL (for Borland)
   aadd( vExeList , PUB_cQPM_Folder+DEF_SLASH+"US_PExports.exe"           )   // Gener .def from DLL (for MinGW)
   aadd( vExeList , PUB_cQPM_Folder+DEF_SLASH+"US_Reimp.exe"              )   // Gener .def from LIB (for MinGW)
   aadd( vExeList , PUB_cQPM_Folder+DEF_SLASH+"US_ImpLib.exe"             )   // Convert DLL to LIB Borland
   aadd( vExeList , PUB_cQPM_Folder+DEF_SLASH+"US_DllTool.exe"            )   // Convert DLL to A MinGW
   aadd( vExeList , PUB_cQPM_Folder+DEF_SLASH+"US_TLib.exe"               )   // Lista LIB Borland
   aadd( vExeList , PUB_cQPM_Folder+DEF_SLASH+"US_POLib.exe"              )   // LIBs for Pelles
   aadd( vExeList , PUB_cQPM_Folder+DEF_SLASH+"US_ObjDump.exe"            )   // Lista Modulos MinGW
   aadd( vExeList , PUB_cQPM_Folder+DEF_SLASH+"US_Tdump.exe"              )   // Lista EXE Borland, MinGW y Pelles
   aadd( vExeList , PUB_cQPM_Folder+DEF_SLASH+"US_PODump.exe"             )   // Lista Modulos Pelles
   aadd( vExeList , PUB_cQPM_Folder+DEF_SLASH+"US_Upx.exe"                )
   aadd( vExeList , PUB_cQPM_Folder+DEF_SLASH+"US_DbfView.exe"            )   // by Grigory Filatov
   aadd( vExeList , PUB_cQPM_Folder+DEF_SLASH+"US_R2H.exe"                )   // Rtf to HTML
   aadd( vExeList , PUB_cQPM_Folder+DEF_SLASH+"US_dif.exe"                )   // Compare (exe)
   aadd( vExeList , PUB_cQPM_Folder+DEF_SLASH+"US_difwi.dll"              )   // Compare (dll)
   aadd( vExeList , PUB_cQPM_Folder+DEF_SLASH+"US_windres.exe"            )   // Resource compiler for MinGW
   aadd( vExeList , PUB_cQPM_Folder+DEF_SLASH+"US_hhc.exe"                )   // Compilador de HTML HELP WorkShop
   aadd( vExeList , PUB_cQPM_Folder+DEF_SLASH+"US_hha.dll"                )   // DLL de HTML HELP WorkShop
   aadd( vExeList , PUB_cQPM_Folder+DEF_SLASH+"US_itcc.dll"               )   // DLL de HTML HELP WorkShop
   aadd( vExeList , PUB_cQPM_Folder+DEF_SLASH+"US_dtree.css"              )   // Tree for HTML Help
   aadd( vExeList , PUB_cQPM_Folder+DEF_SLASH+"US_dtree.js"               )   // Java Function for Tree for HTML Help
   aadd( vExeList , PUB_cQPM_Folder+DEF_SLASH+"US_dtree.im"               )   // ZIP encubierto para imagenes de Tree for HTML Help
   //
   PUBLIC vExeNotFound          := {}
   PUBLIC cExeNotFoundMsg       := {}
   //
   PUBLIC PUB_RunTabChange      := .T.
   PUBLIC PUB_RunTabAutoSync    := .T.
   //
   PUBLIC PUB_MigrateFolderFrom := ""
   PUBLIC PUB_MigrateVersionFrom := ""
   //
// PUBLIC PUB_MI_cMainApplName      := ""
   PUBLIC PUB_MI_bExeAssociation    := .F.
   PUBLIC PUB_MI_cExeAssociation    := ""
   PUBLIC PUB_MI_nExeAssociationIcon:= 1
   PUBLIC PUB_MI_bExeBackupOption   := .F.
   PUBLIC PUB_MI_bNewFile           := .F.
   PUBLIC PUB_MI_nNewFileSuggested  := 1
   PUBLIC PUB_MI_cNewFileLeyend     := ""
   PUBLIC PUB_MI_nNewFileEmpty      := 1
   PUBLIC PUB_MI_cNewFileUserFile   := ""
   PUBLIC PUB_MI_nDestinationPath   := 1
   PUBLIC PUB_MI_cDestinationPath   := ""
   PUBLIC PUB_MI_nLeyendSuggested   := 1
   PUBLIC PUB_MI_cLeyendUserText    := ""
   PUBLIC PUB_MI_bDesktopShortCut   := .T.
   PUBLIC PUB_MI_nDesktopShortCut   := 1
   PUBLIC PUB_MI_bStartMenuShortCut := .T.
   PUBLIC PUB_MI_nStartMenuShortCut := 1
   PUBLIC PUB_MI_bLaunchApplication := .T.
   PUBLIC PUB_MI_nLaunchApplication := 1
   PUBLIC PUB_MI_bLaunchBackupOption := .F.
   PUBLIC PUB_MI_bReboot            := .F.
   PUBLIC PUB_MI_cDefaultLanguage   := "EN"
   PUBLIC PUB_MI_nInstallerName     := 1
   PUBLIC PUB_MI_cInstallerName     := ""
   PUBLIC PUB_MI_cImage             := ""
   PUBLIC PUB_MI_vFiles             := {}
   PUBLIC PUB_MI_bSelectAllPRG      := .F.
   PUBLIC PUB_MI_bSelectAllHEA      := .F.
   PUBLIC PUB_MI_bSelectAllPAN      := .F.
   PUBLIC PUB_MI_bSelectAllDBF      := .F.
   PUBLIC PUB_MI_bSelectAllLIB      := .F.
   //

   SET LANGUAGE TO ENGLISH
   SET DELETED ON

// if PUB_bW800
//    MsgStop( "Sorry, QPM needs a minimun screen configuration of 1024x768." )
//    Return .F.
// endif

   if GetDesktopRealWidth() < 800
      MsgStop( "Sorry, QPM needs a minimun screen configuration of 800x600."+HB_OsNewLine()+"QPM is optimized for 1024x768 resolution.")
      Return .F.
   endif

   if empty( LOC_cParam )
      if PUB_bW800
         MsgInfo( "QPM has been optimized for 1024x768 screen size"+Hb_OsNewLine()+ ;
                  "but your configuration is also supported with reduced workplace.  Continue !!!")
      endif
   endif

   For i=1 to len(vExeList)
      if !file( vExeList[i] )
         aadd( vExeNotFound , vExeList[i] )
      endif
   Next
   if len( vExeNotFound ) > 0
      cExeNotFoundMsg := "This product is incomplete !!!!!"+HB_OSNewLine()+HB_OSNewLine()
      For i:=1 to len( vExeNotFound )
          cExeNotFoundMsg := cExeNotFoundMsg + vExeNotFound[i] + " not found !!!" + HB_OSNewLine()
      next
      cExeNotFoundMsg := cExeNotFoundMsg + HB_OSNewLine() + "Full package is: " + HB_OSNewLine() + HB_OSNewLine()
      For i:=1 to len( vExeList )
          cExeNotFoundMsg := cExeNotFoundMsg + vExeList[i] + HB_OSNewLine()
      next
      MsgStop( cExeNotFoundMsg )
      Return .F.
   endif

   if !( empty( LOC_cParam ) )
      if ( nPos := US_WordPos( "--BUILD" , US_Upper( LOC_cParam ) ) ) > 0
         LOC_cParam := US_WordDel( LOC_cParam , nPos )
      endif
      If ( nPos := US_WordPos( "--LITE" , US_Upper( LOC_cParam ) ) ) > 0
         LOC_cParam := US_WordDel( LOC_cParam , nPos )
      endif
      If ( nPos := US_WordPos( "--DEBUG" , US_Upper( LOC_cParam ) ) ) > 0
         LOC_cParam := US_WordDel( LOC_cParam , nPos )
      endif
      If ( nPos := US_WordPos( "--RUN" , US_Upper( LOC_cParam ) ) ) > 0
         LOC_cParam := US_WordDel( LOC_cParam , nPos )
      endif
      If ( nPos := US_WordPos( "--BUTTONRUN" , US_Upper( LOC_cParam ) ) ) > 0
         LOC_cParam := US_WordDel( LOC_cParam , nPos )
      endif
      If ( nPos := US_WordPos( "--CLEAR" , US_Upper( LOC_cParam ) ) ) > 0
         LOC_cParam := US_WordDel( LOC_cParam , nPos )
      endif
      If ( nPos := US_WordPos( "--OPEN" , US_Upper( LOC_cParam ) ) ) > 0
         LOC_cParam := US_WordDel( LOC_cParam , nPos )
      endif
      if ( nPos := US_WordPos( "--IGNOREVERSIONPROJECT" , US_Upper( LOC_cParam ) ) ) > 0
         LOC_cParam := US_WordDel( LOC_cParam , nPos )
      endif
      If ( nPos := US_WordPos( "--FORCEFULL" , US_Upper( LOC_cParam ) ) ) > 0
         LOC_cParam := US_WordDel( LOC_cParam , nPos )
      endif
      If ( nPos := US_WordStrPos( "--LOG(" , US_Upper( LOC_cParam ) ) ) > 0
         LOC_cParam := US_WordDel( LOC_cParam , nPos )
      endif
      If ( nPos := US_WordPos( "--LOGONLYERROR" , US_Upper( LOC_cParam ) ) ) > 0
         LOC_cParam := US_WordDel( LOC_cParam , nPos )
      endif
      If ( nPos := US_WordPos( "--EXIT" , US_Upper( LOC_cParam ) ) ) > 0
         LOC_cParam := US_WordDel( LOC_cParam , nPos )
      endif
      do case
         case US_Upper( US_Word( LOC_cParam , 1 ) ) == "-VER" .or. US_Upper( US_Word( LOC_cParam , 1 ) ) == "-VERSION"
            QPM_MemoWrit( US_FileNameOnlyPathAndName(GetModuleFileName(GetInstance()))+"."+"version" , PUB_cQPM_Version )
            Return .T.
         case ( nPos := US_WordPos( "-BUILD" , US_Upper( LOC_cParam ) ) ) > 0
            LOC_cParam := US_WordDel( LOC_cParam , nPos )
            aadd( PUB_vAutoRun , "QPM_OpenProject(PUB_cProjectFile)" )
            if ( nPos := US_WordPos( "-LITE" , US_Upper( LOC_cParam ) ) ) > 0
               LOC_cParam := US_WordDel( LOC_cParam , nPos )
               PUB_bLite := .T.
            endif
            if ( nPos := US_WordPos( "-FORCEFULL" , US_Upper( LOC_cParam ) ) ) > 0
               LOC_cParam := US_WordDel( LOC_cParam , nPos )
               aadd( PUB_vAutoRun , "EraseObj()" )
            endif
            if ( nPos := US_WordPos( "-DEBUG" , US_Upper( LOC_cParam ) ) ) > 0
               LOC_cParam := US_WordDel( LOC_cParam , nPos )
               aadd( PUB_vAutoRun , "SwitchDebug()" )
            endif
            aadd( PUB_vAutoRun , "QPM_Build()" )
            if ( nPos := US_WordPos( "-BUTTONRUN" , US_Upper( LOC_cParam ) ) ) > 0
               LOC_cParam := US_WordDel( LOC_cParam , nPos )
               aadd( PUB_vAutoRun , "EnableButtonRun()" )
               bWaitForBuild := .T.
            endif
            if ( nPos := US_WordPos( "-RUN" , US_Upper( LOC_cParam ) ) ) > 0
               LOC_cParam := US_WordDel( LOC_cParam , nPos )
               aadd( PUB_vAutoRun , "QPM_Run( bRunParm )" )
               bWaitForBuild := .T.
            endif
            if ( nPos := US_WordPos( "-CLEAR" , US_Upper( LOC_cParam ) ) ) > 0
               LOC_cParam := US_WordDel( LOC_cParam , nPos )
               aadd( PUB_vAutoRun , "EraseAll()" )
               bWaitForBuild := .T.
            endif
            if ( nPos := US_WordPos( "-EXIT" , US_Upper( LOC_cParam ) ) ) > 0
               LOC_cParam := US_WordDel( LOC_cParam , nPos )
               aadd( PUB_vAutoRun , "QPM_Exit()" )
               bWaitForBuild := .T.
               bAutoExit     := .T.
               if ( nPos := US_WordStrPos( "-LOG(" , US_Upper( LOC_cParam ) ) ) > 0
                  LogIni := US_WordInd( LOC_cParam , nPos )
                  PUB_cAutoLog := US_WordSubStr( LOC_cParam , nPos )
                  PUB_cAutoLog := SubStr( PUB_cAutoLog , 6 , at( ")" , PUB_cAutoLog ) - 6 )
                  if empty( PUB_cAutoLog )
                     MsgInfo( "Error detecting Log Archuive: " + LOC_cParam )
                  else
                     LOC_cParam := substr( LOC_cParam , 1 , LogIni - 1 ) + substr( LOC_cParam , LogIni + len( PUB_cAutoLog ) + 6 )
                     if ( nPos := US_WordPos( "-LOGONLYERROR" , US_Upper( LOC_cParam ) ) ) > 0
                        LOC_cParam := US_WordDel( LOC_cParam , nPos )
                        PUB_bLogOnlyError := .T.
                     endif
                  endif
               endif
            endif
            if ( nPos := US_WordPos( "-OPEN" , US_Upper( LOC_cParam ) ) ) > 0
               LOC_cParam := US_WordDel( LOC_cParam , nPos )
            endif
            if ( nPos := US_WordPos( "-IGNOREVERSIONPROJECT" , US_Upper( LOC_cParam ) ) ) > 0
               LOC_cParam := US_WordDel( LOC_cParam , nPos )
               PUB_bIgnoreVersionProject := .T.
            endif
            PUB_cProjectFile := alltrim( LOC_cParam )
         case ( nPos := US_WordPos( "-RUN" , US_Upper( LOC_cParam ) ) ) > 0
            LOC_cParam := US_WordDel( LOC_cParam , nPos )
            aadd( PUB_vAutoRun , "QPM_OpenProject(PUB_cProjectFile)" )
            aadd( PUB_vAutoRun , "QPM_Run( bRunParm )" )
            bWaitForBuild := .F. && No es requerido porque no hay Build
            if ( nPos := US_WordPos( "-LITE" , US_Upper( LOC_cParam ) ) ) > 0
               LOC_cParam := US_WordDel( LOC_cParam , nPos )
               PUB_bLite := .T.
            endif
            if ( nPos := US_WordPos( "-CLEAR" , US_Upper( LOC_cParam ) ) ) > 0
               LOC_cParam := US_WordDel( LOC_cParam , nPos )
               aadd( PUB_vAutoRun , "EraseAll()" )
               bWaitForBuild := .T.
            endif
            if ( nPos := US_WordPos( "-EXIT" , US_Upper( LOC_cParam ) ) ) > 0
               LOC_cParam := US_WordDel( LOC_cParam , nPos )
               aadd( PUB_vAutoRun , "QPM_Exit()" )
               bWaitForBuild := .F. && No es requerido porque no hay Build
               bAutoExit     := .T.
               if ( nPos := US_WordStrPos( "-LOG(" , US_Upper( LOC_cParam ) ) ) > 0
                  LogIni := US_WordInd( LOC_cParam , nPos )
                  PUB_cAutoLog := US_WordSubStr( LOC_cParam , nPos )
                  PUB_cAutoLog := SubStr( PUB_cAutoLog , 6 , at( ")" , PUB_cAutoLog ) - 6 )
                  if empty( PUB_cAutoLog )
                     MsgInfo( "Error detecting Log Archuive: " + LOC_cParam )
                  else
                     LOC_cParam := substr( LOC_cParam , 1 , LogIni - 1 ) + substr( LOC_cParam , LogIni + len( PUB_cAutoLog ) + 6 )
                     if ( nPos := US_WordPos( "-LOGONLYERROR" , US_Upper( LOC_cParam ) ) ) > 0
                        LOC_cParam := US_WordDel( LOC_cParam , nPos )
                        PUB_bLogOnlyError := .T.
                     endif
                  endif
               endif
            endif
            if ( nPos := US_WordPos( "-OPEN" , US_Upper( LOC_cParam ) ) ) > 0
               LOC_cParam := US_WordDel( LOC_cParam , nPos )
            endif
            if ( nPos := US_WordPos( "-IGNOREVERSIONPROJECT" , US_Upper( LOC_cParam ) ) ) > 0
               LOC_cParam := US_WordDel( LOC_cParam , nPos )
               PUB_bIgnoreVersionProject := .T.
            endif
            PUB_cProjectFile := alltrim( LOC_cParam )
         case ( nPos := US_WordPos( "-CLEAR" , US_Upper( LOC_cParam ) ) ) > 0
            LOC_cParam := US_WordDel( LOC_cParam , nPos )
            aadd( PUB_vAutoRun , "QPM_OpenProject(PUB_cProjectFile)" )
            if ( nPos := US_WordPos( "-LITE" , US_Upper( LOC_cParam ) ) ) > 0
               LOC_cParam := US_WordDel( LOC_cParam , nPos )
               PUB_bLite := .T.
            endif
            if ( nPos := US_WordPos( "-FORCEFULL" , US_Upper( LOC_cParam ) ) ) > 0
               LOC_cParam := US_WordDel( LOC_cParam , nPos )
               aadd( PUB_vAutoRun , "EraseObj()" )
            endif
            aadd( PUB_vAutoRun , "EraseALL()" )
            if ( nPos := US_WordPos( "-EXIT" , US_Upper( LOC_cParam ) ) ) > 0
               LOC_cParam := US_WordDel( LOC_cParam , nPos )
               aadd( PUB_vAutoRun , "QPM_Exit()" )
               bWaitForBuild := .F. && No es requerido porque no hay Build
               bAutoExit     := .T.
               if ( nPos := US_WordStrPos( "-LOG(" , US_Upper( LOC_cParam ) ) ) > 0
                  LogIni := US_WordInd( LOC_cParam , nPos )
                  PUB_cAutoLog := US_WordSubStr( LOC_cParam , nPos )
                  PUB_cAutoLog := SubStr( PUB_cAutoLog , 6 , at( ")" , PUB_cAutoLog ) - 6 )
                  if empty( PUB_cAutoLog )
                     MsgInfo( "Error detecting Log Archuive: " + LOC_cParam )
                  else
                     LOC_cParam := substr( LOC_cParam , 1 , LogIni - 1 ) + substr( LOC_cParam , LogIni + len( PUB_cAutoLog ) + 6 )
                     if ( nPos := US_WordPos( "-LOGONLYERROR" , US_Upper( LOC_cParam ) ) ) > 0
                        LOC_cParam := US_WordDel( LOC_cParam , nPos )
                        PUB_bLogOnlyError := .T.
                     endif
                  endif
               endif
            endif
            if ( nPos := US_WordPos( "-IGNOREVERSIONPROJECT" , US_Upper( LOC_cParam ) ) ) > 0
               LOC_cParam := US_WordDel( LOC_cParam , nPos )
               PUB_bIgnoreVersionProject := .T.
            endif
            PUB_cProjectFile := alltrim( LOC_cParam )
         case ( nPos := US_WordPos( "-OPEN" , US_Upper( LOC_cParam ) ) ) > 0
            LOC_cParam := US_WordDel( LOC_cParam , nPos )
            aadd( PUB_vAutoRun , "QPM_OpenProject(PUB_cProjectFile)" )
            PUB_cProjectFile := alltrim( LOC_cParam )
            if ( nPos := US_WordPos( "-FORCEFULL" , US_Upper( LOC_cParam ) ) ) > 0
               LOC_cParam := US_WordDel( LOC_cParam , nPos )
               aadd( PUB_vAutoRun , "EraseObj()" )
            endif
            if ( nPos := US_WordPos( "-IGNOREVERSIONPROJECT" , US_Upper( LOC_cParam ) ) ) > 0
               LOC_cParam := US_WordDel( LOC_cParam , nPos )
               PUB_bIgnoreVersionProject := .T.
            endif
         Otherwise
            PUB_cProjectFile := LOC_cParam
            aadd( PUB_vAutoRun , "QPM_OpenProject(PUB_cProjectFile)" )
      endcase
      if !empty( PUB_cProjectFile )
         PUB_bOpenProjectFromParm := .T.
         if empty( US_FileNameOnlyPath( PUB_cProjectFile ) )
            PUB_cProjectFile := GetCurrentFolder() + DEF_SLASH + PUB_cProjectFile
         endif
      // PUB_cProjectFolder := US_FileNameOnlyPath( PUB_cProjectFile )
      endif
   endif

   if bAutoExit .and. !empty( PUB_cAutoLog )
      PUB_cAutoLogTmp := MemoRead( PUB_cAutoLog )
      QPM_MemoWrit( PUB_cAutoLog , PUB_cAutoLogTmp + HB_OsNewLine() + Replicate( "=" , 80 ) + HB_OsNewLine() + ;
                "Project file: " + PUB_cProjectFile + HB_OsNewLine() + ;
                US_VarToStr( Date() ) + " " + US_VarToStr( Time() ) + HB_OsNewLine() + ;
                "" )
   endif

   SET FONT TO 'Arial' , 9

   SET HELPFILE TO PUB_cQPM_Folder + DEF_SLASH + "QPM.chm"

// DEFINE WINDOW QPM_VentanaFondo ;
//         AT 0 , 0 ;
//         WIDTH 0 ;
//         HEIGHT 0 ;
//         MAIN ;
//         NOSHOW
// END WINDOW
// ACTIVATE WINDOW QPM_VentanaFondo NOWAIT

   QPM_Wait( "LoadEnvironment()" , "Loading environment..." )

   DEFINE WINDOW VentanaMain ;
           AT GetDesktopRealTop() , GetDesktopRealLeft() ;
           WIDTH GetDesktopRealWidth() HEIGHT GetDesktopRealHeight() ;
           TITLE PUB_cQPM_Title+' [ Project not opened !!! ]' ;
           ICON "QPM" ;
           MAIN ;
           ON GOTFOCUS DefinoWindowsHotKeys(.T.) ;
           ON LOSTFOCUS LiberoWindowsHotKeys(.T.) ;
           ON MINIMIZE LiberoWindowsHotKeys(.T.) ;
           ON INIT MainInitAutoRun() ;
           ON RELEASE if( !PUB_bLite , SaveEnvironment() , ) ;
           ON INTERACTIVECLOSE QPM_Exit()


           DEFINE TOOLBAR ToolBar_1 OF VentanaMain
           END TOOLBAR

           QPM_DefinoMainMenu()

           DEFINE CONTEXT MENU
#ifdef QPM_SHG
              ITEM '&Copy'            ACTION SHG_Send_Copy()  IMAGE 'US_EditCopy'  NAME ItC_Copy
              ITEM 'C&ut'             ACTION SHG_Send_Cut()   IMAGE 'US_EditCut'   NAME ItC_Cut
              ITEM '&Paste'           ACTION SHG_Send_Paste() IMAGE 'US_EditPaste' NAME ItC_Paste
              SEPARATOR
              ITEM '&Select all'      ACTION QPM_Send_SelectAll()             NAME ItC_SelectAll
              SEPARATOR
              ITEM '&Add to Key List'     ACTION SHG_AddHlpKey()  IMAGE 'add' NAME ItC_AddHlpKey
              SEPARATOR
              ITEM 'Add Character &&'     ACTION SHG_AddHlpHTML("Ampersand")  NAME ItC_AddHlpHTMLAmpersand
              ITEM 'Add Character <'      ACTION SHG_AddHlpHTML("Menor")      NAME ItC_AddHlpHTMLMenor
              ITEM 'Add Character >'      ACTION SHG_AddHlpHTML("Mayor")      NAME ItC_AddHlpHTMLMayor
              ITEM 'Add Character SPACE'  ACTION SHG_AddHlpHTML("Space")      NAME ItC_AddHlpHTMLSpace
              SEPARATOR
              ITEM 'Add Image from File'  ACTION SHG_AddHlpHTML("Image")      NAME ItC_AddHlpHTMLImage
              ITEM 'Add eMail'            ACTION SHG_AddHlpHTML("eMail")      NAME ItC_AddHlpHTMLeMail
              ITEM 'Add Link to Internet' ACTION SHG_AddHlpHTML("Link")       NAME ItC_AddHlpHTMLLink
              ITEM 'Add Link to Topic'    ACTION SHG_AddHlpHTML("LinkTopic")  NAME ItC_AddHlpHTMLLinkTopic
              ITEM 'Add Ancora'           ACTION SHG_AddHlpHTML("Ancora")     NAME ItC_AddHlpHTMLAncora
#else
              ITEM '&Copy'            ACTION US_Send_Copy()  IMAGE 'US_EditCopy'  NAME ItC_Copy
              ITEM 'C&ut'             ACTION US_Send_Cut()   IMAGE 'US_EditCut'   NAME ItC_Cut
              ITEM '&Paste'           ACTION US_Send_Paste() IMAGE 'US_EditPaste' NAME ItC_Paste
              SEPARATOR
              ITEM '&Select all'      ACTION QPM_Send_SelectAll()             NAME ItC_SelectAll
#endif
           END MENU

           //
           //
           VentanaMain.ItC_Cut.Enabled       := .F.
           VentanaMain.ItC_Paste.Enabled     := .F.
           VentanaMain.ItC_CutM.Enabled      := .F.
           VentanaMain.ItC_PasteM.Enabled    := .F.
#ifdef QPM_SHG
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

           @ if( IsXPThemeActive() , 54 , 47 ) , 1 FRAME FFrame ;
              WIDTH ( GetDesktopRealWidth() - 9 ) ;
              HEIGHT ( GetDesktopRealHeight() - 105 )

#ifndef QPM_SYNCRECOVERY

           DEFINE BUTTON EraseALL
                   ROW     63
                   COL     10
                   WIDTH   135
                   HEIGHT  25
                   PICTURE "clearall"
                   NOXPSTYLE .T.
                   TOOLTIP 'Delete ALL temporary objects folders and ALL Installer folders'
                   ONCLICK EraseALL()
           END BUTTON

#else

           DEFINE BUTTON BTakeSyncRecovery
                   ROW     63
                   COL     10
                   WIDTH   65
                   HEIGHT  25
                   PICTURE 'SyncRec'
                   NOXPSTYLE .T.
                   TOOLTIP 'Force take Sync Recovery Point for this project'
                   ONCLICK QPM_ForceSyncRecovery()
           END BUTTON

           DEFINE BUTTON EraseALL
                   ROW     63
                   COL     80
                   WIDTH   65
                   HEIGHT  25
                   PICTURE "clearall"
                   NOXPSTYLE .T.
                   TOOLTIP 'Delete ALL temporary objects folders and ALL Installer folders'
                   ONCLICK EraseALL()
           END BUTTON

#endif

           DEFINE BUTTON EraseOBJ
                   ROW     63
                   COL     150
                   WIDTH   170
                   HEIGHT  25
                   PICTURE 'force'
                   NOXPSTYLE .T.
                   TOOLTIP 'Force Recomp of all program in project'
                   ONCLICK EraseOBJ()
           END BUTTON

           // HEIGHT ( GetDesktopRealHeight() - 95 ) ;
           DEFINE TAB TabGrids ;
              OF VentanaMain ;
              AT 95 , 10 ;
              WIDTH 310 ;
              HEIGHT ( GetDesktopRealHeight() - 165 ) ;
              ON CHANGE TabChange( "GRIDS" )

              DEFINE PAGE PagePRG

                 DEFINE LABEL LProjectFolder
                         ROW             40
                         COL             12
                         WIDTH           89
                         VALUE           'Project Folder:'
                         TRANSPARENT     if( IsXPThemeActive() , .T. , .F. )
                 END LABEL

                 DEFINE TEXTBOX TProjectFolder
                         ROW             40
                         COL             102
                         WIDTH           160
                         ON CHANGE       PUB_cProjectFolder := alltrim( US_FileNameOnlyPath( GetProperty( "VentanaMain" , "TProjectFolder" , "Value" ) ) )
                 END TEXTBOX

                 DEFINE BUTTON BProjectFolder
                         ROW             40
                         COL             270
                         WIDTH           25
                         HEIGHT          25
                         PICTURE         'folderselect'
                         NOXPSTYLE       .T.
                         TOOLTIP         'Select Folder'
                         ONCLICK         ( If ( !Empty( Folder := GetFolder( "Select Folder" , VentanaMain.TProjectFolder.Value ) ) , VentanaMain.TProjectFolder.Value := Folder , ) , QPM_CheckFiles() )
                 END BUTTON

                 DEFINE LABEL LRunProjectFolder
                         ROW             70
                         COL             12
                         WIDTH           89
                         VALUE           'Run Folder:'
                         TRANSPARENT     if( IsXPThemeActive() , .T. , .F. )
                 END LABEL

                 DEFINE TEXTBOX TRunProjectFolder
                         ROW             70
                         COL             102
                         WIDTH           160
                 END TEXTBOX

                 DEFINE BUTTON BRunProjectFolder
                         ROW             70
                         COL             270
                         WIDTH           25
                         HEIGHT          25
                         PICTURE         'folderselect'
                         NOXPSTYLE       .T.
                         TOOLTIP         'Select Folder'
                         ONCLICK         If ( !Empty( Folder := GetFolder( "Select Folder" , VentanaMain.TRunProjectFolder.Value ) ) , VentanaMain.TRunProjectFolder.Value := Folder , )
                 END BUTTON

                 DEFINE BUTTON BPrgAdd
                         ROW     100
                         COL     12
                         WIDTH   65
                         HEIGHT  25
                         PICTURE 'add'
                         NOXPSTYLE .T.
                         TOOLTIP 'Add File'
                         ONCLICK QPM_AddFilesPRG()
                 END BUTTON

#ifndef QPM_HOTRECOVERYWINDOW

                 DEFINE BUTTON BPrgRemove
                         ROW     100
                         COL     85
                         WIDTH   65
                         HEIGHT          25
                         PICTURE 'remove'
                         NOXPSTYLE .T.
                         TOOLTIP 'Remove File'
                         ONCLICK QPM_RemoveFilePRG()
                 END BUTTON

#else

                 DEFINE BUTTON BPrgRemove
                         ROW     100
                         COL     85
                         WIDTH   30
                         HEIGHT  25
                         PICTURE 'remove'
                         NOXPSTYLE .T.
                         TOOLTIP 'Remove File'
                         ONCLICK QPM_RemoveFilePRG()
                 END BUTTON

                 DEFINE BUTTON BPrgHotRecovery
                         ROW     100
                         COL     120
                         WIDTH   30
                         HEIGHT  25
                         PICTURE 'hotrec'
                         NOXPSTYLE .T.
                         TOOLTIP 'Force take Hot Recovery Version for this source'
                         ONCLICK QPM_ForceHotRecovery( "PRG" )
                 END BUTTON
                 //      ONCLICK QPM_ForceHotRecovery( GBL_TabGridNameFocus )   // esto tambien funciona

#endif

                 DEFINE BUTTON BPrgEdit
                         ROW     100
                         COL     158
                         WIDTH   65
                         HEIGHT  25
                         PICTURE 'Edit'
                         NOXPSTYLE .T.
                         TOOLTIP 'Edit File'
                         ONCLICK QPM_EditPRG ()
                 END BUTTON

                 DEFINE BUTTON SetTopPRG
                         ROW     100
                         COL     230
                         WIDTH   30
                         HEIGHT  25
                         PICTURE 'SetTop'
                         NOXPSTYLE .T.
                         TOOLTIP 'Set Top Project File'
                         ONCLICK QPM_SetTopPRG()
                 END BUTTON

                 DEFINE BUTTON ForceRecompPRG
                         ROW     100
                         COL     265
                         WIDTH   30
                         HEIGHT  25
                         PICTURE 'ForceRecomp'
                         NOXPSTYLE .T.
                         TOOLTIP 'Force Source Recomp (Togle On/Off)'
                         ONCLICK QPM_ForceRecompPRG()
                 END BUTTON

                 DEFINE BUTTON BSortPRG
                         ROW     130
                         COL     12
                         WIDTH   65
                         HEIGHT  25
                         PICTURE "Sort"
                         NOXPSTYLE .T.
                         TOOLTIP 'Sort PRG and C files in alfabetical order, except top File'
                         ONCLICK SortPRG( "VentanaMain" , "GPrgFiles" , NCOLPRGNAME )
                 END BUTTON

                 DEFINE BUTTON BVerChange
                         ROW     130
                         COL     85
                         WIDTH   55
                         HEIGHT  25
                         PICTURE 'ChangeVersion'
                         NOXPSTYLE .T.
                         TOOLTIP 'Change Version, Release and Build'
                         ONCLICK QPM_ChangePrjVersion()
                 END BUTTON

                 DEFINE LABEL LVerTitle
                         ROW             135
                         COL             145
                         VALUE           "Version"
                         WIDTH           45
                         HEIGHT          25
                         FONTCOLOR       DEF_COLORGREEN
                         TRANSPARENT     if( IsXPThemeActive() , .T. , .F. )
                 END LABEL

                 DEFINE LABEL LVerVerNum
                         ROW             135
                         COL             193
                         VALUE           Replicate( "0" , DEF_LEN_VER_VERSION )
                         WIDTH           15
                         HEIGHT          25
                         FONTBOLD        .T.
                         FONTCOLOR       DEF_COLORGREEN
                         TRANSPARENT     if( IsXPThemeActive() , .T. , .F. )
                 END LABEL

                 DEFINE LABEL LVerPoint
                         ROW             135
                         COL             208
                         VALUE           "."
                         WIDTH           5
                         HEIGHT          25
                         FONTCOLOR       DEF_COLORGREEN
                         TRANSPARENT     if( IsXPThemeActive() , .T. , .F. )
                 END LABEL

                 DEFINE LABEL LVerRelNum
                         ROW             135
                         COL             212
                         VALUE           Replicate( "0" , DEF_LEN_VER_RELEASE )
                         WIDTH           15
                         HEIGHT          25
                         FONTBOLD        .T.
                         FONTCOLOR       DEF_COLORGREEN
                         TRANSPARENT     if( IsXPThemeActive() , .T. , .F. )
                 END LABEL

                 DEFINE LABEL LVerBui
                         ROW             135
                         COL             230
                         VALUE           "Build"
                         WIDTH           30
                         HEIGHT          25
                         FONTCOLOR       DEF_COLORBLUE
                         TRANSPARENT     if( IsXPThemeActive() , .T. , .F. )
                 END LABEL

                 DEFINE LABEL LVerBuiNum
                         ROW             135
                         COL             265
                         VALUE           Replicate( "0" , DEF_LEN_VER_BUILD )
                         WIDTH           30
                         HEIGHT          25
                         FONTBOLD        .T.
                         FONTCOLOR       DEF_COLORBLUE
                         TRANSPARENT     if( IsXPThemeActive() , .T. , .F. )
                 END LABEL

                 DEFINE BUTTON BSyncPrg
                         ROW     312
                         COL     296
                         WIDTH   11
                         HEIGHT  21
                         PICTURE 'SYNC'
                         NOXPSTYLE .T.
                         TOOLTIP 'Syncronize Tabs'
                         ONCLICK TabSync()
                 END BUTTON

                 DEFINE BUTTON BUpPrg
                         ROW     160
                         COL     12
                         WIDTH   11
                         HEIGHT  21
                         PICTURE 'UP'
                         NOXPSTYLE .T.
                         TOOLTIP 'Up PRG or C file in List'
                         ONCLICK UpPrg()
                 END BUTTON

                 DEFINE BUTTON BDownPrg
                         ROW     190
                         COL     12
                         WIDTH   11
                         HEIGHT  21
                         PICTURE 'DOWN'
                         NOXPSTYLE .T.
                         TOOLTIP 'Down PRG or C file in List'
                         ONCLICK DownPrg()
                 END BUTTON

                 DEFINE BUTTON BUpPrg2
                         ROW     GetDesktopRealHeight() - 237
                         COL     12
                         WIDTH   11
                         HEIGHT  21
                         PICTURE 'UP'
                         NOXPSTYLE .T.
                         TOOLTIP 'Up PRG or C file in List'
                         ONCLICK UpPrg()
                 END BUTTON

                 DEFINE BUTTON BDownPrg2
                         ROW     GetDesktopRealHeight() - 207
                         COL     12
                         WIDTH   11
                         HEIGHT  21
                         PICTURE 'DOWN'
                         NOXPSTYLE .T.
                         TOOLTIP 'Down PRG or C file in List'
                         ONCLICK DownPrg()
                 END BUTTON

                 // OJO, la altura de este grid se controla tembien desde la funcion ActLibReimp()
                 @ 160, 25 GRID GPrgFiles ;
                    WIDTH 270 ;
                    HEIGHT GetDesktopRealHeight() - 345 ;
                    HEADERS { 'S' , 'R' , 'Src Name' , 'Src Full Name' , 'Offset' , 'Control Edit' , 'Hot Recovery' } ;
                    WIDTHS { 25 , 0 , 100 , 1000 , 20 , 20 , 20 };
                    ITEMS aGridPRG ;
                    VALUE 1 ;
                    IMAGE vImagesGrid ;
                    TOOLTIP '' ;
                    BACKCOLOR DEF_COLORBACKPRG ;
                    ON HEADCLICK { {||SortPRG( "VentanaMain" , "GPrgFiles" , 1 )} , {||SortPRG( "VentanaMain" , "GPrgFiles" , 2 )} , {||SortPRG( "VentanaMain" , "GPrgFiles" , 3 )} , {||SortPRG( "VentanaMain" , "GPrgFiles" , 4 )} } ;
                    ON DBLCLICK { QPM_EditPRG() } ;
                    ON CHANGE { || if( !bPrgSorting .and. !PUB_bLite , if( bNumberOnPrg , QPM_Wait( "RichEditDisplay('PRG')" , "Reloading" ) , RichEditDisplay('PRG') ) , US_NOP() ) } ;
                    JUSTIFY { BROWSE_JTFY_LEFT }

                 DEFINE CHECKBOX Check_Reimp
                         CAPTION         "ReImport from .Lib library (Only for MinGW)"
                         ROW             if( PUB_bW800 , 280 , 320 )
                         COL             30
                         WIDTH           250
                         HEIGHT          20
                         VALUE           .F.
                         TOOLTIP "Make '.a' Interface Library from '.lib' Interface Library"
                         TRANSPARENT     if( IsXPThemeActive() , .T. , .F. )
                         ON CHANGE       ( SetProperty( "VentanaMain" , "LReImportLib" , "enabled" , GetProperty( "VentanaMain" , "Check_Reimp" , "Value" ) ) , ;
                                           SetProperty( "VentanaMain" , "TReImportLib" , "enabled" , GetProperty( "VentanaMain" , "Check_Reimp" , "Value" ) ) , ;
                                           SetProperty( "VentanaMain" , "BReImportLib" , "enabled" , GetProperty( "VentanaMain" , "Check_Reimp" , "Value" ) ) )
                 END CHECKBOX

                 DEFINE LABEL LReImportLib
                         ROW             if( PUB_bW800 , 320 , 360 )
                         COL             30
                         VALUE           "Input Interface '.Lib':"
                         TRANSPARENT     if( IsXPThemeActive() , .T. , .F. )
                 END LABEL

                 DEFINE TEXTBOX TReImportLib
                         ROW             if( PUB_bW800 , 350 , 390 )
                         COL             30
                         WIDTH           220
                 END TEXTBOX

                 DEFINE BUTTON BReImportLib
                         ROW             if( PUB_bW800 , 350 , 390 )
                         COL             270
                         WIDTH           25
                         HEIGHT          25
                         PICTURE         'folderselect'
                         NOXPSTYLE .T.
                         TOOLTIP         'Select Library'
                         ONCLICK         If( !Empty( FileName := BugGetFile( { {'Library (*.lib)','*.lib'} } , 'Select Library for ReImport' , US_FileNameOnlyPath( ChgPathToReal( VentanaMain.TReImportLib.Value ) ) , .F. , .T. ) ) , VentanaMain.TReImportLib.Value := ChgPathToRelative( FileName ) , )
                 END BUTTON

                 DEFINE CHECKBOX Check_GuionA
                         CAPTION         "Add '_' alias (Not for MinGW)"
                         ROW             if( PUB_bW800 , 420 , 460 )
                         COL             30
                         WIDTH           250
                         HEIGHT          20
                         VALUE           .F.
                         TOOLTIP "Add '_' alias for MS flavor cdecl functions (Only for Borland C and Pelles C)"
                         TRANSPARENT     if( IsXPThemeActive() , .T. , .F. )
                 END CHECKBOX

                 ActLibReimp()

              END PAGE

              DEFINE PAGE PageHEA

                 DEFINE BUTTON BHeaAdd
                         ROW     40
                         COL     12
                         WIDTH   65
                         HEIGHT  25
                         PICTURE 'add'
                         NOXPSTYLE .T.
                         TOOLTIP 'Add Header'
                         ONCLICK QPM_AddFilesHEA()
                 END BUTTON

#ifndef QPM_HOTRECOVERYWINDOW

                 DEFINE BUTTON BHeaRemove
                         ROW     40
                         COL     85
                         WIDTH   65
                         HEIGHT          25
                         PICTURE 'remove'
                         NOXPSTYLE .T.
                         TOOLTIP 'Remove Header'
                         ONCLICK QPM_RemoveFileHEA()
                 END BUTTON

#else

                 DEFINE BUTTON BHeaRemove
                         ROW     40
                         COL     85
                         WIDTH   30
                         HEIGHT  25
                         PICTURE 'remove'
                         NOXPSTYLE .T.
                         TOOLTIP 'Remove Header'
                         ONCLICK QPM_RemoveFileHEA()
                 END BUTTON

                 DEFINE BUTTON BHeaHotRecovery
                         ROW     40
                         COL     120
                         WIDTH   30
                         HEIGHT  25
                         PICTURE 'hotrec'
                         NOXPSTYLE .T.
                         TOOLTIP 'Force take Hot Recovery Version for this header'
                         ONCLICK QPM_ForceHotRecovery( "HEA" )
                 END BUTTON

#endif

                 DEFINE BUTTON BHeaEdit
                         ROW     40
                         COL     158
                         WIDTH   65
                         HEIGHT  25
                         PICTURE 'Edit'
                         NOXPSTYLE .T.
                         TOOLTIP 'Modify Header'
                         ONCLICK QPM_EditHEA ()
                 END BUTTON

                 DEFINE BUTTON BSortHea
                         ROW     70
                         COL     12
                         WIDTH   65
                         HEIGHT  25
                         PICTURE "Sort"
                         NOXPSTYLE .T.
                         TOOLTIP 'Sort Headers in alfabetical order'
                         ONCLICK SortHEA( "VentanaMain" , "GHeaFiles" , NCOLHEANAME )
                 END BUTTON

                 DEFINE BUTTON BSyncHea
                         ROW     312
                         COL     296
                         WIDTH   11
                         HEIGHT  21
                         PICTURE 'SYNC'
                         NOXPSTYLE .T.
                         TOOLTIP 'Syncronize Tabs'
                         ONCLICK TabSync()
                 END BUTTON

                 DEFINE BUTTON BUpHea
                         ROW     100
                         COL     12
                         WIDTH   11
                         HEIGHT  21
                         PICTURE 'UP'
                         NOXPSTYLE .T.
                         TOOLTIP 'Up Headers in List'
                         ONCLICK UpHea()
                 END BUTTON

                 DEFINE BUTTON BDownHea
                         ROW     130
                         COL     12
                         WIDTH   11
                         HEIGHT  21
                         PICTURE 'DOWN'
                         NOXPSTYLE .T.
                         TOOLTIP 'Down Headers in List'
                         ONCLICK DownHea()
                 END BUTTON

                 DEFINE BUTTON BUpHea2
                         ROW     GetDesktopRealHeight() - 237
                         COL     12
                         WIDTH   11
                         HEIGHT  21
                         PICTURE 'UP'
                         NOXPSTYLE .T.
                         TOOLTIP 'Up Headers in List'
                         ONCLICK UpHea()
                 END BUTTON

                 DEFINE BUTTON BDownHea2
                         ROW     GetDesktopRealHeight() - 207
                         COL     12
                         WIDTH   11
                         HEIGHT  21
                         PICTURE 'DOWN'
                         NOXPSTYLE .T.
                         TOOLTIP 'Down Headers in List'
                         ONCLICK DownHea()
                 END BUTTON

                 @ 100, 25 GRID GHeaFiles ;
                    WIDTH 270 ;
                    HEIGHT GetDesktopRealHeight() - 285 ;
                    HEADERS { 'S' , 'Header Name' , 'Header Full Name' , 'Offset' , 'Control Edit' , 'Hot Recovery' } ;
                    WIDTHS { 25 , 100 , 1000 , 20 , 20 , 20 };
                    ITEMS aGridHea ;
                    IMAGE vImagesGrid ;
                    VALUE 1 ;
                    TOOLTIP '' ;
                    BACKCOLOR DEF_COLORBACKHEA ;
                    ON HEADCLICK { {||SortHEA( "VentanaMain" , "GHeaFiles" , 1 )} , {||SortHEA( "VentanaMain" , "GHeaFiles" , 2)} , {||SortHEA( "VentanaMain" , "GHeaFiles" , 3)} , {||SortHEA( "VentanaMain" , "GHeaFiles" , 4)} } ;
                    ON DBLCLICK { QPM_EditHEA() } ;
                    ON CHANGE { || if( !bHeaSorting .and. !PUB_bLite , if( bNumberOnHea , QPM_Wait( "RichEditDisplay('HEA')" , "Reloading" ) , RichEditDisplay('HEA') ) , US_NOP() ) } ;
                    JUSTIFY { BROWSE_JTFY_LEFT }

              END PAGE

              DEFINE PAGE PagePAN

                 DEFINE BUTTON BPanAdd
                         ROW     40
                         COL     12
                         WIDTH   65
                         HEIGHT  25
                         PICTURE 'add'
                         NOXPSTYLE .T.
                         TOOLTIP 'Add Form'
                         ONCLICK QPM_AddFilesPAN()
                 END BUTTON

#ifndef QPM_HOTRECOVERYWINDOW

                 DEFINE BUTTON BPanRemove
                         ROW     40
                         COL     85
                         WIDTH   65
                         HEIGHT          25
                         PICTURE 'remove'
                         NOXPSTYLE .T.
                         TOOLTIP 'Remove Form'
                         ONCLICK QPM_RemoveFilePAN()
                 END BUTTON

#else

                 DEFINE BUTTON BPanRemove
                         ROW     40
                         COL     85
                         WIDTH   30
                         HEIGHT  25
                         PICTURE 'remove'
                         NOXPSTYLE .T.
                         TOOLTIP 'Remove Form'
                         ONCLICK QPM_RemoveFilePAN()
                 END BUTTON

                 DEFINE BUTTON BPanHotRecovery
                         ROW     40
                         COL     120
                         WIDTH   30
                         HEIGHT  25
                         PICTURE 'hotrec'
                         NOXPSTYLE .T.
                         TOOLTIP 'Force take Hot Recovery Version for this form'
                         ONCLICK QPM_ForceHotRecovery( "PAN" )
                 END BUTTON

#endif

                 DEFINE BUTTON BPanEditTool
                         ROW     40
                         COL     158
                         WIDTH   65
                         HEIGHT  25
                         CAPTION 'With-Tool'
                         TOOLTIP 'Modify Form with associated Tool'
                         ONCLICK QPM_EditPAN()
                 END BUTTON

                 DEFINE BUTTON BPanEditEditor
                         ROW     40
                         COL     230
                         WIDTH   65
                         HEIGHT  25
                         CAPTION 'With-Edit'
                         TOOLTIP 'Open Form with Editor'
                         ONCLICK QPM_EditPAN( .T. )
                 END BUTTON

                 DEFINE BUTTON BSortPan
                         ROW     70
                         COL     12
                         WIDTH   65
                         HEIGHT  25
                         PICTURE "Sort"
                         NOXPSTYLE .T.
                         TOOLTIP 'Sort Forms in alfabetical order'
                         ONCLICK SortPAN( "VentanaMain" , "GPanFiles" , NCOLPANNAME )
                 END BUTTON

                 DEFINE BUTTON BEditRC
                         ROW     70
                         COL     85
                         WIDTH   209
                         HEIGHT  25
                         CAPTION 'Edit Main .RC'
                         TOOLTIP 'Edit the Main Resource File of Project'
                         ONCLICK QPM_EditRES()
                 END BUTTON

                 DEFINE BUTTON BSyncPan
                         ROW     312
                         COL     296
                         WIDTH   11
                         HEIGHT  21
                         PICTURE 'SYNC'
                         NOXPSTYLE .T.
                         TOOLTIP 'Syncronize Tabs'
                         ONCLICK TabSync()
                 END BUTTON

                 DEFINE BUTTON BUpPan
                         ROW     100
                         COL     12
                         WIDTH   11
                         HEIGHT  21
                         PICTURE 'UP'
                         NOXPSTYLE .T.
                         TOOLTIP 'Up Forms in List'
                         ONCLICK UpPan()
                 END BUTTON

                 DEFINE BUTTON BDownPan
                         ROW     130
                         COL     12
                         WIDTH   11
                         HEIGHT  21
                         PICTURE 'DOWN'
                         NOXPSTYLE .T.
                         TOOLTIP 'Down Forms in List'
                         ONCLICK DownPan()
                 END BUTTON

                 DEFINE BUTTON BUpPan2
                         ROW     GetDesktopRealHeight() - 237
                         COL     12
                         WIDTH   11
                         HEIGHT  21
                         PICTURE 'UP'
                         NOXPSTYLE .T.
                         TOOLTIP 'Up Forms in List'
                         ONCLICK UpPan()
                 END BUTTON

                 DEFINE BUTTON BDownPan2
                         ROW     GetDesktopRealHeight() - 207
                         COL     12
                         WIDTH   11
                         HEIGHT  21
                         PICTURE 'DOWN'
                         NOXPSTYLE .T.
                         TOOLTIP 'Down Forms in List'
                         ONCLICK DownPan()
                 END BUTTON

                 @ 100, 25 GRID GPanFiles ;
                    WIDTH 270 ;
                    HEIGHT GetDesktopRealHeight() - 285 ;
                    HEADERS { 'S' , 'Form Name' , 'Form Full Name' , 'Offset' , 'Control Edit' , 'Hot Recovery' } ;
                    WIDTHS { 25 , 100 , 1000 , 20 , 20 , 20 };
                    ITEMS aGridPan ;
                    VALUE 1 ;
                    IMAGE vImagesGrid ;
                    TOOLTIP '' ;
                    BACKCOLOR DEF_COLORBACKPAN ;
                    ON HEADCLICK { {||SortPAN( "VentanaMain" , "GPanFiles" , 1)} , {||SortPAN( "VentanaMain" , "GPanFiles" , 2)} , {||SortPAN( "VentanaMain" , "GPanFiles" , 3)} , {||SortPAN( "VentanaMain" , "GPanFiles" , 4)} } ;
                    ON DBLCLICK { QPM_EditPAN() } ;
                    ON CHANGE { || if( !bPanSorting .and. !PUB_bLite , if( bNumberOnPan , QPM_Wait( "RichEditDisplay('PAN')" , "Reloading" ) , RichEditDisplay('PAN') ) , US_NOP() ) } ;
                    JUSTIFY { BROWSE_JTFY_LEFT }

              END PAGE

              DEFINE PAGE PageDBF

                 DEFINE BUTTON BDbfAdd
                         ROW     40
                         COL     12
                         WIDTH   65
                         HEIGHT  25
                         PICTURE 'add'
                         NOXPSTYLE .T.
                         TOOLTIP 'Add Dbf'
                         ONCLICK QPM_AddFilesDBF()
                 END BUTTON

                 DEFINE BUTTON BDbfRemove
                         ROW     40
                         COL     85
                         WIDTH   65
                         HEIGHT  25
                         PICTURE 'remove'
                         NOXPSTYLE .T.
                         TOOLTIP 'Remove Dbf'
                         ONCLICK QPM_RemoveFileDBF()
                 END BUTTON

                 DEFINE BUTTON BDbfEditTool
                         ROW     40
                         COL     158
                         WIDTH   65
                         HEIGHT  25
                         PICTURE 'Edit'
                         NOXPSTYLE .T.
                         TOOLTIP 'Modify Dbf with associated Tool'
                         ONCLICK QPM_EditDBF()
                 END BUTTON

                 DEFINE BUTTON BSortDbf
                         ROW     70
                         COL     12
                         WIDTH   65
                         HEIGHT  25
                         PICTURE "Sort"
                         NOXPSTYLE .T.
                         TOOLTIP "Sort Dbf's in alfabetical order"
                         ONCLICK SortDBF( "VentanaMain" , "GDbfFiles" , NCOLDBFNAME )
                 END BUTTON

                 DEFINE BUTTON BSyncDbf
                         ROW     312
                         COL     296
                         WIDTH   11
                         HEIGHT  21
                         PICTURE 'SYNC'
                         NOXPSTYLE .T.
                         TOOLTIP 'Syncronize Tabs'
                         ONCLICK TabSync()
                 END BUTTON

                 DEFINE BUTTON BUpDbf
                         ROW     100
                         COL     12
                         WIDTH   11
                         HEIGHT  21
                         PICTURE 'UP'
                         NOXPSTYLE .T.
                         TOOLTIP "Up Dbf's in List"
                         ONCLICK UpDbf()
                 END BUTTON

                 DEFINE BUTTON BDownDbf
                         ROW     130
                         COL     12
                         WIDTH   11
                         HEIGHT  21
                         PICTURE 'DOWN'
                         NOXPSTYLE .T.
                         TOOLTIP "Down Dbf's in List"
                         ONCLICK DownDbf()
                 END BUTTON

                 DEFINE BUTTON BUpDbf2
                         ROW     GetDesktopRealHeight() - 237
                         COL     12
                         WIDTH   11
                         HEIGHT  21
                         PICTURE 'UP'
                         NOXPSTYLE .T.
                         TOOLTIP "Up Dbf's in List"
                         ONCLICK UpDbf()
                 END BUTTON

                 DEFINE BUTTON BDownDbf2
                         ROW     GetDesktopRealHeight() - 207
                         COL     12
                         WIDTH   11
                         HEIGHT  21
                         PICTURE 'DOWN'
                         NOXPSTYLE .T.
                         TOOLTIP "Down Dbf's in List"
                         ONCLICK DownDbf()
                 END BUTTON

                 @ 100, 25 GRID GDbfFiles ;
                    WIDTH 270 ;
                    HEIGHT GetDesktopRealHeight() - 285 ;
                    HEADERS { 'S' , 'Dbf Name' , 'Dbf Full Name' , 'Offset' , 'Control Edit' , 'Search' } ;
                    WIDTHS { 25 , 100 , 1000 , 20 , 20 , 20 };
                    ITEMS aGridDbf ;
                    VALUE 1 ;
                    IMAGE vImagesGrid ;
                    TOOLTIP '' ;
                    BACKCOLOR DEF_COLORBACKDBF ;
                    ON HEADCLICK { {||SortDBF( "VentanaMain" , "GDbfFiles" , 1)} , {||SortDBF( "VentanaMain" , "GDbfFiles" , 2)} , {||SortDBF( "VentanaMain" , "GDbfFiles" , 3)} , {||SortDBF( "VentanaMain" , "GDbfFiles" , 4)} } ;
                    ON DBLCLICK { QPM_EditDBF() } ;
                    ON CHANGE { || if( !bDbfSorting .and. !PUB_bLite , QPM_Wait( "RichEditDisplay( 'DBF' , .T. )" , "Loading..." ) , US_NOP() ) } ;
                    JUSTIFY { BROWSE_JTFY_LEFT }

              END PAGE

              DEFINE PAGE PageLIB

                 @ 43 , 12 LABEL LLibLabel ;
                    VALUE 'Include:' ;
                    WIDTH 155 ;
                    FONT 'arial' SIZE 10 BOLD ;
                    TRANSPARENT ;
                    FONTCOLOR DEF_COLORBLUE

                 DEFINE BUTTON BLibAdd
                         ROW     70
                         COL     12
                         WIDTH   65
                         HEIGHT  25
                         PICTURE 'add'
                         NOXPSTYLE .T.
                         TOOLTIP 'Add File'
                         ONCLICK QPM_AddFilesLIB()
                 END BUTTON

                 DEFINE BUTTON BLibRemove
                         ROW     70
                         COL     85
                         WIDTH   65
                         HEIGHT  25
                         PICTURE 'remove'
                         NOXPSTYLE .T.
                         TOOLTIP 'Remove File'
                         ONCLICK QPM_RemoveFileLIB()
                 END BUTTON

                 DEFINE BUTTON BFirst
                         ROW     70
                         COL     158
                         WIDTH   65
                         HEIGHT  25
                         CAPTION "First"
                         TOOLTIP "Put Lib or Obj at First position in Lib's Concatenation"
                         ONCLICK LibPos( VentanaMain.GIncFiles.Value , "*First*" )
                 END BUTTON

                 DEFINE BUTTON BLast
                         ROW     70
                         COL     231
                         WIDTH   65
                         HEIGHT  25
                         CAPTION "Last"
                         TOOLTIP "Put Lib or Obj at Last position in Lib's Concatenation (Default)"
                         ONCLICK LibPos( VentanaMain.GIncFiles.Value , "*Last*" )
                 END BUTTON

                 DEFINE BUTTON BSortInc
                         ROW     100
                         COL     12
                         WIDTH   65
                         HEIGHT  25
                         PICTURE "Sort"
                         NOXPSTYLE .T.
                         TOOLTIP 'Sort Libs and Objects Included in alfabetical order'
                         ONCLICK SortINC( "VentanaMain" , "GIncFiles" , NCOLINCNAME )
                 END BUTTON

                 DEFINE BUTTON BSyncLib
                         ROW     312
                         COL     296
                         WIDTH   11
                         HEIGHT  21
                         PICTURE 'SYNC'
                         NOXPSTYLE .T.
                         TOOLTIP 'Syncronize Tabs'
                         ONCLICK TabSync()
                 END BUTTON

                 DEFINE BUTTON BUpLibInclude
                         ROW     130
                         COL     12
                         WIDTH   11
                         HEIGHT  21
                         PICTURE 'UP'
                         NOXPSTYLE .T.
                         TOOLTIP 'Up Lib or Obj in Include List'
                         ONCLICK UpLibInclude()
                 END BUTTON

                 DEFINE BUTTON BDownLibInclude
                         ROW     160
                         COL     12
                         WIDTH   11
                         HEIGHT  21
                         PICTURE 'DOWN'
                         NOXPSTYLE .T.
                         TOOLTIP 'Down Lib or Obj in Include List'
                         ONCLICK DownLibInclude()
                 END BUTTON

                 @ 130, 25 GRID GIncFiles ;
                    WIDTH 270 ;
                    HEIGHT 170 ;
                    HEADERS { 'S' , 'Include Name' , 'Include Full Name'} ;
                    WIDTHS { 25 , 100 , 1000 };
                    ITEMS aGridInc ;
                    VALUE 1 ;
                    IMAGE vImagesGrid ;
                    TOOLTIP '' ;
                    BACKCOLOR DEF_COLORBACKINC ;
                    ON HEADCLICK { {||SortINC( "VentanaMain" , "GIncFiles" , 1)} , {||SortINC( "VentanaMain" , "GIncFiles" , 2)} , {||SortINC( "VentanaMain" , "GIncFiles" , 3)} } ;
                    ON DBLCLICK { LibInfo() } ;
                    ON CHANGE { || if( !bIncSorting .and. !PUB_bLite , RichEditDisplay('INC') , US_NOP() ) } ;
                    JUSTIFY { BROWSE_JTFY_LEFT }

                 @ 313 , 12 LABEL LLibLabel_e ;
                    VALUE 'Force Exclude:' ;
                    WIDTH 155 ;
                    FONT 'arial' SIZE 10 BOLD ;
                    TRANSPARENT ;
                    FONTCOLOR DEF_COLORBLUE

                 DEFINE BUTTON BLibAdd_E
                         ROW     340
                         COL     12
                         WIDTH   65
                         HEIGHT  25
                         PICTURE 'add'
                         NOXPSTYLE .T.
                         TOOLTIP 'Add File'
                         ONCLICK QPM_AddExcludeFilesLIB()
                 END BUTTON

                 DEFINE BUTTON BLibRemove_E
                         ROW     340
                         COL     85
                         WIDTH   65
                         HEIGHT  25
                         PICTURE 'remove'
                         NOXPSTYLE .T.
                         TOOLTIP 'Remove File'
                         ONCLICK QPM_RemoveExcludeFileLIB()
                 END BUTTON

                 DEFINE BUTTON BSortExc
                         ROW     370
                         COL     12
                         WIDTH   65
                         HEIGHT  25
                         PICTURE "Sort"
                         NOXPSTYLE .T.
                         TOOLTIP 'Sort Libs Excluded in alfabetical order'
                         ONCLICK SortEXC( "VentanaMain" , "GExcFiles" , NCOLEXCNAME )
                 END BUTTON

                 DEFINE BUTTON BUpLibExclude
                         ROW     400
                         COL     12
                         WIDTH   11
                         HEIGHT  21
                         PICTURE 'UP'
                         NOXPSTYLE .T.
                         TOOLTIP 'Up Libs in Exclude List'
                         ONCLICK UpLibExclude()
                 END BUTTON

                 DEFINE BUTTON BDownLibExclude
                         ROW     430
                         COL     12
                         WIDTH   11
                         HEIGHT  21
                         PICTURE 'DOWN'
                         NOXPSTYLE .T.
                         TOOLTIP 'Down Libs in Exclude List'
                         ONCLICK DownLibExclude()
                 END BUTTON

                 @ 400, 25 GRID GExcFiles ;
                    WIDTH 270 ;
                    HEIGHT GetDesktopRealHeight() - 585 ;
                    HEADERS { 'S' , 'Exclude Library Name' } ;
                    WIDTHS { 25 , 200 };
                    ITEMS aGridExc ;
                    VALUE 1 ;
                    IMAGE vImagesGrid ;
                    TOOLTIP '' ;
                    BACKCOLOR DEF_COLORBACKEXC ;
                    ON HEADCLICK { {||SortEXC( "VentanaMain" , "GExcFiles" , 1)} , {||SortEXC( "VentanaMain" , "GExcFiles" , 2)} } ;
                    ON DBLCLICK { LibExcludeInfo() } ;
                    JUSTIFY { BROWSE_JTFY_LEFT }

              END PAGE

#ifdef QPM_SHG

              DEFINE PAGE PageHlp

                 DEFINE LABEL LHlpDataBase
                         ROW             40
                         COL             12
                         VALUE           'SHG Database:'
                         TRANSPARENT     if( IsXPThemeActive() , .T. , .F. )
                 END LABEL

                 DEFINE TEXTBOX THlpDataBase
                         ROW             40
                         COL             132
                         WIDTH           130
                 END TEXTBOX

                 DEFINE BUTTON BHlpDataBase
                         ROW             40
                         COL             270
                         WIDTH           25
                         HEIGHT          25
                         PICTURE         'folderselect'
                         NOXPSTYLE .T.
                         TOOLTIP         'Select QPM Help Generator Database'
                         ONCLICK         (            SHG_GetDatabase()                            , if( SHG_BaseOK , SetProperty( "VentanaMain" , "RichEditHlp" , "readonly" , .F. ) , US_NOP() ) )
                 END BUTTON
                 //      ONCLICK         ( QPM_Wait( "SHG_GetDatabase()" , "Loading Database..." ) , if( SHG_BaseOK , SetProperty( "VentanaMain" , "RichEditHlp" , "readonly" , .F. ) , US_NOP() ) )

                 DEFINE LABEL LWWWHlp
                         ROW             70
                         COL             12
                         VALUE           'Your Link for Foot:'
                         TRANSPARENT     if( IsXPThemeActive() , .T. , .F. )
                 END LABEL

                 DEFINE TEXTBOX TWWWHlp
                         ROW             70
                         COL             132
                         WIDTH           163
                 END TEXTBOX

                 DEFINE BUTTON BHlpAdd
                         ROW     100
                         COL     12
                         WIDTH   65
                         HEIGHT  25
                         PICTURE 'add'
                         NOXPSTYLE .T.
                         TOOLTIP 'Add Topic'
                         ONCLICK QPM_AddFilesHLP()
                 END BUTTON

                 DEFINE BUTTON BHlpRemove
                         ROW     100
                         COL     85
                         WIDTH   65
                         HEIGHT  25
                         PICTURE 'remove'
                         NOXPSTYLE .T.
                         TOOLTIP 'Remove Topic'
                         ONCLICK QPM_RemoveFileHLP()
                 END BUTTON

                 DEFINE BUTTON BHlpEdit
                         ROW     100
                         COL     158
                         WIDTH   65
                         HEIGHT  25
                         PICTURE 'Edit'
                         NOXPSTYLE .T.
                         TOOLTIP 'Edit Topic Name'
                         ONCLICK QPM_EditHLP ()
                 END BUTTON

                 DEFINE BUTTON SetTestHlp
                         ROW     100
                         COL     230
                         WIDTH   65
                         HEIGHT  25
                         PICTURE 'TEST'
                         NOXPSTYLE .T.
                         TOOLTIP 'Test CHM file'
                         ONCLICK SHG_DisplayHelp( SHG_GetOutputName() )
                 END BUTTON

                 DEFINE BUTTON BTogle
                         ROW     130
                         COL     12
                         WIDTH   65
                         HEIGHT  25
                         CAPTION "Togle"
                         TOOLTIP 'Togle topic type (Book or Page)'
                         ONCLICK SHG_Togle()
                 END BUTTON

                 DEFINE BUTTON HlpCheckSave
                         ROW     130
                         COL     85
                         WIDTH   65
                         HEIGHT  25
                         CAPTION "Save All ?"
                         TOOLTIP 'Check for save topics'
                         ONCLICK QPM_WAIT( "SHG_CheckSave()" , "Checking for save..." )
                 END BUTTON

                 DEFINE BUTTON HlpClose
                         ROW     130
                         COL     158
                         WIDTH   65
                         HEIGHT  25
                         CAPTION "Close"
                         TOOLTIP 'Close Help Database'
                         ONCLICK SHG_Close()
                 END BUTTON

                 DEFINE BUTTON HlpGenerate
                         ROW     130
                         COL     230
                         WIDTH   65
                         HEIGHT  25
                         CAPTION "Generate"
                         TOOLTIP 'Genera help file in format CHM'
                         ONCLICK QPM_Wait( 'SHG_Generate( SHG_Database , SHG_CheckTypeOutput , PUB_cSecu , GetProperty( "VentanaMain" , "TWWWHlp" , "Value" ) )' ,"Generating Help..." )
                 END BUTTON

                 DEFINE BUTTON BSyncHlp
                         ROW     312
                         COL     296
                         WIDTH   11
                         HEIGHT  21
                         PICTURE 'SYNC'
                         NOXPSTYLE .T.
                         TOOLTIP 'Syncronize Tabs'
                         ONCLICK TabSync()
                 END BUTTON

                 DEFINE BUTTON BUpHlp
                         ROW     160
                         COL     12
                         WIDTH   11
                         HEIGHT  21
                         PICTURE 'UP'
                         NOXPSTYLE .T.
                         TOOLTIP 'Up Hlp file in List'
                         ONCLICK UpHlp()
                 END BUTTON

                 DEFINE BUTTON BDownHlp
                         ROW     190
                         COL     12
                         WIDTH   11
                         HEIGHT  21
                         PICTURE 'DOWN'
                         NOXPSTYLE .T.
                         TOOLTIP 'Down Hlp file in List'
                         ONCLICK DownHlp()
                 END BUTTON

                 DEFINE BUTTON BUpHlp2
                         ROW     GetDesktopRealHeight() - 237
                         COL     12
                         WIDTH   11
                         HEIGHT  21
                         PICTURE 'UP'
                         NOXPSTYLE .T.
                         TOOLTIP 'Up Hlp file in List'
                         ONCLICK UpHlp()
                 END BUTTON

                 DEFINE BUTTON BDownHlp2
                         ROW     GetDesktopRealHeight() - 207
                         COL     12
                         WIDTH   11
                         HEIGHT  21
                         PICTURE 'DOWN'
                         NOXPSTYLE .T.
                         TOOLTIP 'Down Hlp file in List'
                         ONCLICK DownHlp()
                 END BUTTON

                 @ 160, 25 GRID GHlpFiles ;
                    WIDTH 270 ;
                    HEIGHT GetDesktopRealHeight() - 345 ;
                    HEADERS { 'I' , 'Topic' , 'Nick Name' , 'Offset' , 'Control Edit' } ;
                    WIDTHS { 25 , 1000 , 0 , 20 , 20 };
                    ITEMS aGridHlp ;
                    VALUE 0 ;
                    IMAGE vImagesGrid ;
                    TOOLTIP '' ;
                    BACKCOLOR DEF_COLORBACKHLP ;
                    ON DBLCLICK { QPM_EditHLP() } ;
                    ON CHANGE { || if( !bHlpSorting .and. !PUB_bLite , ( RichEditDisplay('HLP') , OcultaHlpKeys() ) , US_NOP() ) } ;
                    JUSTIFY { BROWSE_JTFY_LEFT }

              END PAGE

#endif

           END TAB

           ProjectButtons( .F. )

           DEFINE LABEL LStatusLabel
                   ROW             15
                   COL             if( IsXPThemeActive() , 363 , 335 )
                   WIDTH           if( IsXPThemeActive() , 70 , 80 )
                   HEIGHT          18
                   VALUE           PUB_cStatusLabel
                   TRANSPARENT     if( IsXPThemeActive() , .T. , .F. )
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
                   TRANSPARENT     if( IsXPThemeActive() , .T. , .F. )
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
                   TRANSPARENT     if( IsXPThemeActive() , .T. , .F. )
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
                   TRANSPARENT     if( IsXPThemeActive() , .T. , .F. )
           END LABEL

           DEFINE TAB TabFiles ;
              OF VentanaMain ;
              AT 60 , 328 ;
              WIDTH ( GetDesktopRealWidth() - 344 ) ;
              HEIGHT ( GetDesktopRealHeight() - 190 ) ;
              VALUE nPagePRG ;
              ON CHANGE TabChange( "FILES" )

              DEFINE PAGE PagePRG

                 DEFINE CHECKBOX Check_AutoSyncPrg
                         CAPTION         "Auto Sync"
                         ROW             00
                         COL             ( GetDesktopRealWidth() - 420 )
                         WIDTH           70
                         HEIGHT          20
                         VALUE           .T.
                         TOOLTIP "Automatic Syncronice Tabs"
                         ON CHANGE       TabAutoSync("PRG")
                 END CHECKBOX

                 @ 25, 00 IMAGE IBorde1PRG ;
                     PICTURE         "YELLOW" ;
                     WIDTH           GetDesktopRealWidth() - 348 ;
                     HEIGHT          GetDesktopRealHeight() - 217 ;
                     STRETCH

                 @ 35, 10 RICHEDITBOX RichEditPRG ;
                         WIDTH           GetDesktopRealWidth() - 364 ;
                         HEIGHT          GetDesktopRealHeight() - 272 ;
                         READONLY        ;
                         FONT            'Courier New' ;
                         SIZE            9 ;
                         BACKCOLOR DEF_COLORBACKPRG

                 DEFINE CHECKBOX Check_NumberOnPrg
                         CAPTION         "Line Number"
                         ROW             GetDesktopRealHeight() - 224
                         COL             10
                         WIDTH           95
                         HEIGHT          20
                         VALUE           .F.
                         TOOLTIP         "Browse line number (with ON, load more slow)"
                         ON CHANGE       ( bNumberOnPrg := GetProperty( "VentanaMain" , "Check_NumberOnPrg" , "value" ) , if( bPpoDisplayado , QPM_Wait( "PpoDisplay(.T.)" , "Reloading..." ) , QPM_Wait( "RichEditDisplay( 'PRG' , .T. )" , "Reloading..." ) ) )
                 END CHECKBOX
                 //      TRANSPARENT     if( IsXPThemeActive() , .T. , .F. )

                 DEFINE BUTTON bReLoadPpo
                         ROW             GetDesktopRealHeight() - 227
                         COL             110
                         WIDTH           95
                         HEIGHT          25
                         CAPTION "Browse PPO"
                         TOOLTIP 'Browse PreProcess for this PRG'
                         ONCLICK QPM_Wait( "PpoDisplay()" , "Reloading..." )
                 END BUTTON

                 DEFINE BUTTON bReLoadPrg
                         ROW             GetDesktopRealHeight() - 227
                         COL             210
                         WIDTH           GetDesktopRealWidth() - 630
                         HEIGHT          25
                         CAPTION "ReLoad Source"
                         TOOLTIP 'ReLoad Source form disk'
                         ONCLICK QPM_Wait( "RichEditDisplay( 'PRG' , .T. )" , "Reloading..." )
                 END BUTTON

                 DEFINE BUTTON BLocalSearchPrg
                         ROW             GetDesktopRealHeight() - 227
                         COL             GetDesktopRealWidth() - 415
                         WIDTH           60
                         HEIGHT          25
                         CAPTION "Search"
                         TOOLTIP 'Search text in displayed text'
                         ONCLICK LocalSearch( GetProperty( 'VentanaMain' , 'CSearch' , 'DisplayValue' ) )
                 END BUTTON

              END PAGE

              DEFINE PAGE if( PUB_bW800 , "Hea" , PageHEA )

                 DEFINE CHECKBOX Check_AutoSyncHea
                         CAPTION         "Auto Sync"
                         ROW             00
                         COL             ( GetDesktopRealWidth() - 420 )
                         WIDTH           70
                         HEIGHT          20
                         VALUE           .T.
                         TOOLTIP "Automatic Syncronice Tabs"
                         ON CHANGE       TabAutoSync("HEA")
                 END CHECKBOX

                 @ 25, 00 IMAGE IBorde1HEA ;
                         PICTURE         "YELLOW" ;
                         WIDTH           GetDesktopRealWidth() - 348 ;
                         HEIGHT          GetDesktopRealHeight() - 217 ;
                         STRETCH
                     
                 @ 35, 10 RICHEDITBOX RichEditHEA ;
                         WIDTH           GetDesktopRealWidth() - 364 ;
                         HEIGHT          GetDesktopRealHeight() - 272 ;
                         READONLY        ;
                         FONT            'Courier New' ;
                         SIZE            9 ;
                         BACKCOLOR DEF_COLORBACKHEA

                 DEFINE CHECKBOX Check_NumberOnHea
                         CAPTION         "Line Number"
                         ROW             GetDesktopRealHeight() - 224
                         COL             10
                         WIDTH           95
                         HEIGHT          20
                         VALUE           .F.
                         TOOLTIP         "Browse line number (with ON, load more slow)"
                         ON CHANGE       ( bNumberOnHea := GetProperty( "VentanaMain" , "Check_NumberOnHea" , "value" ) , QPM_Wait( "RichEditDisplay( 'HEA' , .T. )" , "Reloading..." ) )
                 END CHECKBOX
                 //      TRANSPARENT     if( IsXPThemeActive() , .T. , .F. )

                 DEFINE BUTTON bReLoadHea
                         ROW             GetDesktopRealHeight() - 227
                         COL             110
                         WIDTH           GetDesktopRealWidth() - 530
                         HEIGHT          25
                         CAPTION "ReLoad Header"
                         TOOLTIP 'ReLoad Header file form disk'
                         ONCLICK { || QPM_Wait( "RichEditDisplay( 'HEA' , .T. )" , "Reloading..." ) }
                 END BUTTON

                 DEFINE BUTTON BLocalSearchHea
                         ROW             GetDesktopRealHeight() - 227
                         COL             GetDesktopRealWidth() - 415
                         WIDTH           60
                         HEIGHT          25
                         CAPTION "Search"
                         TOOLTIP 'Search text in displayed text'
                         ONCLICK LocalSearch( GetProperty( 'VentanaMain' , 'CSearch' , 'DisplayValue' ) )
                 END BUTTON

              END PAGE

              DEFINE PAGE if( PUB_bW800 , "FMG" , PagePAN )

                 DEFINE CHECKBOX Check_AutoSyncPan
                         CAPTION         "Auto Sync"
                         ROW             00
                         COL             ( GetDesktopRealWidth() - 420 )
                         WIDTH           70
                         HEIGHT          20
                         VALUE           .T.
                         TOOLTIP "Automatic Syncronice Tabs"
                         ON CHANGE       TabAutoSync("PAN")
                 END CHECKBOX

                 @ 25, 00 IMAGE IBorde1PAN ;
                     PICTURE         "YELLOW" ;
                     WIDTH           GetDesktopRealWidth() - 348 ;
                     HEIGHT          GetDesktopRealHeight() - 217 ;
                     STRETCH
                 @ 35, 10 RICHEDITBOX RichEditPAN ;
                         WIDTH           GetDesktopRealWidth() - 364 ;
                         HEIGHT          GetDesktopRealHeight() - 272 ;
                         READONLY        ;
                         FONT            'Courier New' ;
                         SIZE            9 ;
                         BACKCOLOR DEF_COLORBACKPAN

                 DEFINE CHECKBOX Check_NumberOnPan
                         CAPTION         "Line Number"
                         ROW             GetDesktopRealHeight() - 224
                         COL             10
                         WIDTH           95
                         HEIGHT          20
                         VALUE           .F.
                         TOOLTIP         "Browse line number (with ON, load more slow)"
                         ON CHANGE       ( bNumberOnPan := GetProperty( "VentanaMain" , "Check_NumberOnPan" , "value" ) , QPM_Wait( "RichEditDisplay( 'PAN' , .T. )" , "Reloading..." ) )
                 END CHECKBOX
                 //      TRANSPARENT     if( IsXPThemeActive() , .T. , .F. )

                 DEFINE BUTTON bReLoadPan
                         ROW             GetDesktopRealHeight() - 227
                         COL             110
                         WIDTH           GetDesktopRealWidth() - 530
                         HEIGHT          25
                         CAPTION "ReLoad Form"
                         TOOLTIP 'ReLoad Form file form disk'
                         ONCLICK { || QPM_Wait( "RichEditDisplay( 'PAN' , .T. )" , "Reloading..." ) }
                 END BUTTON

                 DEFINE BUTTON BLocalSearchPan
                         ROW             GetDesktopRealHeight() - 227
                         COL             GetDesktopRealWidth() - 415
                         WIDTH           60
                         HEIGHT          25
                         CAPTION "Search"
                         TOOLTIP 'Search text in displayed text'
                         ONCLICK LocalSearch( GetProperty( 'VentanaMain' , 'CSearch' , 'DisplayValue' ) )
                 END BUTTON

              END PAGE

              DEFINE PAGE PageDBF

                 DEFINE CHECKBOX Check_AutoSyncDbf
                         CAPTION         "Auto Sync"
                         ROW             00
                         COL             ( GetDesktopRealWidth() - 420 )
                         WIDTH           70
                         HEIGHT          20
                         VALUE           .T.
                         TOOLTIP "Automatic Syncronice Tabs"
                         ON CHANGE       TabAutoSync("DBF")
                 END CHECKBOX

                 @ 25, 00 IMAGE IBorde1DBF ;
                     PICTURE         "YELLOW" ;
                     WIDTH           GetDesktopRealWidth() - 348 ;
                     HEIGHT          GetDesktopRealHeight() - 217 ;
                     STRETCH
                 @ 35, 10 RICHEDITBOX RichEditDBF ;
                         WIDTH           GetDesktopRealWidth() - 364 ;
                         HEIGHT          GetDesktopRealHeight() - int( ( GetDesktopRealHeight() * 78 ) / 100 ) ;
                         READONLY        ;
                         FONT            'Courier New' ;
                         SIZE            9 ;
                         BACKCOLOR DEF_COLORBACKDBF
                 @ GetDesktopRealHeight() - int( ( GetDesktopRealHeight() * 72 ) / 100 ) , 10 BROWSE DbfBrowse ;
                    OF VentanaMain ;
                    WIDTH GetDesktopRealWidth() - 364 ;
                    HEIGHT ( GetDesktopRealHeight() - 237 ) - ( GetDesktopRealHeight() - int( ( GetDesktopRealHeight() * 72 ) / 100 ) ) ;
                    HEADERS ( vDbfHeaders ) ;
                    WIDTHS ( vDbfWidths ) ;
                    WORKAREA Alias() ;
                    FIELDS ( vDbfHeaders ) ;
                    VALUE RECNO() ;
                    FONT "CourierNew" SIZE 9 ;
                    BACKCOLOR DEF_COLORBACKDBF

                 DEFINE CHECKBOX Check_DbfAutoView
                         CAPTION         "Auto View"
                         ROW             GetDesktopRealHeight() - 223
                         COL             10
                         WIDTH           80
                         HEIGHT          20
                         VALUE           bDbfAutoView
                         TOOLTIP "Automatic Open DBF for Quick View in Browse"
                         ON CHANGE       ( bDbfAutoView := GetProperty( "VentanaMain" , "Check_DbfAutoView" , "Value" ) , QPM_Wait( "RichEditDisplay( 'DBF' , .T. , , .F. )" , "Reloading..." ) )
                 END CHECKBOX
                 //      TRANSPARENT     if( IsXPThemeActive() , .T. , .F. )

                 DEFINE BUTTON bReLoadDbf
                         ROW             GetDesktopRealHeight() - 227
                         COL             90
                         WIDTH           GetDesktopRealWidth() - 675
                         HEIGHT          25
                         CAPTION         if( PUB_bW800 , "(Re)Display DBF" , "Force (Re)Display DBF information y/o data" )
                         TOOLTIP 'ReDisplay DBF information from DBF file in disk'
                         ONCLICK { || QPM_Wait( "RichEditDisplay( 'DBF' , .T. , , .T. )" , "Reloading..." ) }
                 END BUTTON

                 DEFINE BUTTON BLocalSearchStructure
                         ROW             GetDesktopRealHeight() - 227
                         COL             GetDesktopRealWidth() - 580
                         WIDTH           110
                         HEIGHT          25
                         CAPTION "Search Struc."
                         TOOLTIP 'Search text in Structure of DBF'
                         ONCLICK LocalSearch( GetProperty( 'VentanaMain' , 'CSearch' , 'DisplayValue' ) )
                 END BUTTON

                 DEFINE BUTTON BLocalSearchDbf
                         ROW             GetDesktopRealHeight() - 227
                         COL             GetDesktopRealWidth() - 465
                         WIDTH           110
                         HEIGHT          25
                         CAPTION "Dbf Search"
                         TOOLTIP 'Search text in Dbf Data'
                         ONCLICK QPM_Wait( "DbfDataSearch( GetProperty( 'VentanaMain' , 'CSearch' , 'DisplayValue' ) )" , "Searching..." )
                 END BUTTON

              END PAGE

              DEFINE PAGE PageLIB

                 DEFINE CHECKBOX Check_AutoSyncLib
                         CAPTION         "Auto Sync"
                         ROW             00
                         COL             ( GetDesktopRealWidth() - 420 )
                         WIDTH           70
                         HEIGHT          20
                         VALUE           .T.
                         TOOLTIP "Automatic Syncronice Tabs"
                         ON CHANGE       TabAutoSync("LIB")
                 END CHECKBOX

                 @ 25, 00 IMAGE IBorde1LIB ;
                     PICTURE         "YELLOW" ;
                     WIDTH           GetDesktopRealWidth() - 348 ;
                     HEIGHT          GetDesktopRealHeight() - 217 ;
                     STRETCH
                 @ 35, 10 RICHEDITBOX RichEditLIB ;
                         WIDTH           GetDesktopRealWidth() - 364 ;
                         HEIGHT          GetDesktopRealHeight() - 272 ;
                         READONLY        ;
                         FONT            'Courier New' ;
                         SIZE            9 ;
                         BACKCOLOR DEF_COLORBACKINC

                 DEFINE BUTTON bReLoadLib
                         ROW             GetDesktopRealHeight() - 227
                         COL             10
                         WIDTH           GetDesktopRealWidth() - 430
                         HEIGHT          25
                         CAPTION "List Library/Object (or Re-List)"
                         TOOLTIP 'List Library/Object Content'
                         ONCLICK SetProperty( "VentanaMain" , "RichEditLib" , "Value" , QPM_Wait( "ListModule( '" + ChgPathToReal( US_WordSubStr( GetProperty( "VentanaMain" , "GIncFiles" , "Cell" , VentanaMain.GIncFiles.Value , NCOLINCFULLNAME ) , 3 ) ) + "' )" , "Listing..." , , .T. ) )
                 END BUTTON

                 DEFINE BUTTON BLocalSearchLib
                         ROW             GetDesktopRealHeight() - 227
                         COL             GetDesktopRealWidth() - 415
                         WIDTH           60
                         HEIGHT          25
                         CAPTION "Search"
                         TOOLTIP 'Search text in displayed text'
                         ONCLICK LocalSearch( GetProperty( 'VentanaMain' , 'CSearch' , 'DisplayValue' ) )
                 END BUTTON

              END PAGE

#ifdef QPM_SHG

              DEFINE PAGE PageHlp

                 DEFINE CHECKBOX Check_AutoSyncHlp
                         CAPTION         "Auto Sync"
                         ROW             00
                         COL             ( GetDesktopRealWidth() - 420 )
                         WIDTH           70
                         HEIGHT          20
                         VALUE           .T.
                         TOOLTIP "Automatic Syncronice Tabs"
                         ON CHANGE       TabAutoSync("HLP")
                 END CHECKBOX

                 @ 25, 00 IMAGE IBorde1Hlp ;
                     PICTURE         "YELLOW" ;
                     WIDTH           GetDesktopRealWidth() - 348 ;
                     HEIGHT          GetDesktopRealHeight() - 217 ;
                     STRETCH
                       //READONLY        ;
               //@ 35, 10 RICHEDITBOX RichEditHlp ;
               //        WIDTH           GetDesktopRealWidth() - 364 ;
               //        HEIGHT          GetDesktopRealHeight() - 272 ;
               //        FONT            'Courier New' ;
               //        SIZE            9 ;
               //        BACKCOLOR DEF_COLORBACKHLP
              // oHlpRichEdit:vBackColor := DEF_COLORPan
              // oHlpRichEdit:vFontColor := DEF_COLOREdit
                 oHlpRichEdit:cWindowName      := "VentanaMain"
                 oHlpRichEdit:cRichControlName := "RichEditHlp"
                 oHlpRichEdit:cLanguage        := "EN"
                 oHlpRichEdit:cFunctionPostPaste := "SHG_Post_Paste()"
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
              // oHlpRichEdit:cSkin       := "VP"
                 oHlpRichEdit:Init( "" )
              // oHlpRichEdit:SetTitle( Titulo+" "+ESTRING )
              // oHlpRichEdit:SetBackColor( DEF_COLORPan ) // el cambio dinamico de backcolor de window no esta permitido en minigui oficial
              // oHlpRichEdit:SetTitleBackColor( DEF_COLOREdit )
              // oHlpRichEdit:SetTitleFontColor( DEF_COLORPan )
              // oHlpRichEdit:SetPos( OFFSET )
              // oHlpRichEdit:FindText( TextoABuscar )
              // oHlpRichEdit:Activate()
                 SetProperty( "VentanaMain" , "RichEditHlp" , "readonly" , .T. )

                 DEFINE BUTTON BAddHlpKey
                         ROW             66
                         COL             GetDesktopRealWidth() - 416
                         WIDTH           28
                         HEIGHT          25
                         PICTURE 'add'
                         NOXPSTYLE .T.
                         TOOLTIP 'Add Key for Automatic Index on Help'
                         ONCLICK SHG_AddHlpKey()
                 END BUTTON

                 DEFINE BUTTON BRemoveHlpKey
                         ROW             66
                         COL             GetDesktopRealWidth() - 384
                         WIDTH           28
                         HEIGHT          25
                         PICTURE 'remove'
                         NOXPSTYLE .T.
                         TOOLTIP 'Remove Key from Help'
                         ONCLICK QPM_RemoveKeyHLP()
                 END BUTTON

                 @ 95, ( GetDesktopRealWidth() - 480 ) GRID GHlpKeys ;
                    WIDTH 124 ;
                    HEIGHT GetDesktopRealHeight() - 332 ;
                    HEADERS { 'Keys' } ;
                    WIDTHS { 100 };
                    ITEMS {} ;
                    VALUE 0 ;
                    TOOLTIP 'Keys for automatic index on help' ;
                    BACKCOLOR DEF_COLORBACKHLP ;
                    ON DBLCLICK { QPM_EditKeyHLP() } ;
                    JUSTIFY { BROWSE_JTFY_LEFT }

                 DEFINE BUTTON bReLoadHlp
                         ROW             GetDesktopRealHeight() - 227
                         COL             10
                         WIDTH           124
                         HEIGHT          25
                         CAPTION "Cancel Changes ?"
                         TOOLTIP 'Ask for Restore Topic before last save'
                         ONCLICK { || QPM_Wait( "SHG_CancelChangesTopic()" , "Checking for restore..." ) }
                 END BUTTON

                 DEFINE CHECKBOX CH_SHG_TypeOutput
                         CAPTION         "Add HTML Output"
                         ROW             GetDesktopRealHeight() - 224
                         COL             if( PUB_bW800 , 140 , 230 )
                         WIDTH           if( PUB_bW800 , 120 , 120 )
                         HEIGHT          20
                         VALUE           SHG_CheckTypeOutput
                         TOOLTIP         "Add Generate of HTML Files (CHM + HTML)"
                         ON CHANGE       ( SHG_CheckTypeOutput := GetProperty( "VentanaMain" , "CH_SHG_TypeOutput" , "value" ) )
                 END CHECKBOX

                 DEFINE BUTTON BLocalSearchHlp
                         ROW             GetDesktopRealHeight() - 227
                         COL             GetDesktopRealWidth() - 480
                         WIDTH           124
                         HEIGHT          25
                         CAPTION "Search"
                         TOOLTIP 'Search text in displayed text'
                         ONCLICK LocalSearch( GetProperty( 'VentanaMain' , 'CSearch' , 'DisplayValue' ) )
                 END BUTTON

              END PAGE

#endif

              DEFINE PAGE PageSysout

                 DEFINE LABEL L_OverrideCompile
                         ROW             40
                         COL             10
                         WIDTH           150
                         VALUE           'Override Compile Parm:'
                         TRANSPARENT     if( IsXPThemeActive() , .T. , .F. )
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
                         VALUE           'Override Link Parm:'
                         TRANSPARENT     if( IsXPThemeActive() , .T. , .F. )
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
                         READONLY        ;
                         FONT            'Courier New' ;
                         SIZE            9

                 DEFINE BUTTON BLocalSearchSysOut
                         ROW             GetDesktopRealHeight() - 227
                         COL             10
                         WIDTH           GetDesktopRealWidth() - 364
                         HEIGHT          25
                         CAPTION "Search"
                         TOOLTIP 'Search text in displayed text'
                         ONCLICK LocalSearch( GetProperty( 'VentanaMain' , 'CSearch' , 'DisplayValue' ) )
                 END BUTTON

              END PAGE

              DEFINE PAGE PageOUT

                 @ 35, 10 RICHEDITBOX RichEditOUT ;
                         WIDTH           GetDesktopRealWidth() - 364 ;
                         HEIGHT          GetDesktopRealHeight() - 272 ;
                         READONLY        ;
                         BACKCOLOR       DEF_COLORBACKOUT ;
                         FONT            'Courier New' ;
                         SIZE            9

                 DEFINE BUTTON bDeleteErrorLog
                         ROW             GetDesktopRealHeight() - 227
                         COL             10
                         WIDTH           120
                         HEIGHT          25
                         CAPTION "Delete Error Log"
                         TOOLTIP 'Delete Content of MiniGui Error Log'
                         ONCLICK QPM_DeleteErrorLog()
                 END BUTTON

                 DEFINE BUTTON bReLoadErrorLog
                         ROW             GetDesktopRealHeight() - 227
                         COL             140
                         WIDTH           GetDesktopRealWidth() - 780
                         HEIGHT          25
                         CAPTION "(Re)Browse Error Log"
                         TOOLTIP 'Browse Content of MiniGui Error Log'
                         ONCLICK MuestroErrorLog()
                 END BUTTON

                 DEFINE BUTTON bReLoadOut
                         ROW             GetDesktopRealHeight() - 227
                         COL             GetDesktopRealWidth() - 620
                         WIDTH           184
                         HEIGHT          25
                         CAPTION "List Output File (or ReList)"
                         TOOLTIP 'List Content of output file for project'
                         ONCLICK ( SetProperty( "VentanaMain" , "RichEditOut" , "Value" , QPM_Wait( "ListModuleMoved( '" + GetOutputModuleName() + "' )" , "Listing..." ) ) , SetProperty( "VentanaMain" , "RichEditOut" , "caretpos" , 1 ) )
                 END BUTTON

                 DEFINE BUTTON BLocalSearchOut
                         ROW             GetDesktopRealHeight() - 227
                         COL             GetDesktopRealWidth() - 415
                         WIDTH           60
                         HEIGHT          25
                         CAPTION "Search"
                         TOOLTIP 'Search text in displayed text'
                         ONCLICK LocalSearch( GetProperty( 'VentanaMain' , 'CSearch' , 'DisplayValue' ) )
                 END BUTTON

              END PAGE


           END TAB


           DEFINE BUTTON BStop
                   ROW             GetDesktopRealHeight() - 118
                   COL             328
                   WIDTH           85
                   HEIGHT          25
                   PICTURE "STOP"
                   NOXPSTYLE .T.
                   TOOLTIP 'Stop BUILD Process'
                   ONCLICK QPM_Wait( "BuildStop()" , "Stopping, please wait ..." )
           END BUTTON

#ifdef QPM_KILLER
           DEFINE BUTTON BKill
                   ROW             GetDesktopRealHeight() - 118
                   COL             418
                   WIDTH           85
                   HEIGHT          25
                   PICTURE "KILL"
                   NOXPSTYLE .T.
                   TOOLTIP 'Open Process Manager'
                   ONCLICK ( SetProperty( "VentanaMain" , "bKill" , "Enabled" , .F. ) , DoMethod( "WinKiller" , "restore" ) , QPM_bKiller := .T. , if( !PUB_QPM_bHigh , QPM_SetProcessPriority( "HIGH" ) , ) , SetProperty( "WinKiller" , "TimerRefresh" , "Enabled" , GetProperty( "WinKiller" , "Check_AutoRefresh" , "value" ) ) , DoMethod( "VentanaMain" , "minimize" ) )
           END BUTTON
#endif

           @ GetDesktopRealHeight() - 118 , 510 COMBOBOX CSearch ;
              ITEMS {} ;
              VALUE 1 ;
              DISPLAYEDIT ;
              WIDTH GetDesktopRealWidth() - if( PUB_bW800 , 735 , 810 ) ;
              TOOLTIP 'Text to Search' ;
              ON ENTER ( AddSearchTxt() , QPM_Wait( "GlobalSearch( GetProperty( 'VentanaMain' , 'CSearch' , 'DisplayValue' ) )" , "Searching..." ) )
              ON LOSTFOCUS AddSearchTxt()

           DEFINE BUTTON BGlobalSearch
                   ROW             GetDesktopRealHeight() - 118
                   COL             GetDesktopRealWidth() - if( PUB_bW800 , 220 , 290 )
                   WIDTH           90
                   HEIGHT          25
                   CAPTION "Global Search"
                   TOOLTIP 'Search text in project'
                   ONCLICK ( AddSearchTxt() , QPM_Wait( "GlobalSearch( GetProperty( 'VentanaMain' , 'CSearch' , 'DisplayValue' ) )" , "Searching..." ) )
           END BUTTON

           DEFINE BUTTON BGlobalReset
                   ROW             GetDesktopRealHeight() - 118
                   COL             GetDesktopRealWidth() - if( PUB_bW800 , 125 , 190 )
                   WIDTH           if( PUB_bW800 , 15 , 50 )
                   HEIGHT          25
                   CAPTION if( PUB_bW800 , "R" , "Reset" )
                   TOOLTIP 'Reset Global Search Indicators and Counts'
                   ONCLICK QPM_Wait( "ResetImgGrid( '*' )" , "Reseting Search Indicators..." )
           END BUTTON
           VentanaMain.BGlobalReset.Enabled := .F.

           DEFINE CHECKBOX Check_SearchFun
                   CAPTION         if( PUB_bW800 , "Func/Proc" , "Func/Proc/Method" )
                   ROW             GetDesktopRealHeight() - 125
                   COL             GetDesktopRealWidth() - if( PUB_bW800 , 100 , 130 )
                   WIDTH           if( PUB_bW800 , 80 , 120 )
                   HEIGHT          20
                   VALUE           .F.
                   TOOLTIP "GLOBAL Search: Find Only Function, Procedure and/or Method name"
                   TRANSPARENT     if( IsXPThemeActive() , .T. , .F. )
           END CHECKBOX

           DEFINE CHECKBOX Check_SearchDbf
                   CAPTION         if( PUB_bW800 , "DBF Data" , "DBF Data Search" )
                   ROW             GetDesktopRealHeight() - 104
                   COL             GetDesktopRealWidth() - if( PUB_bW800 , 100 , 130 )
                   WIDTH           if( PUB_bW800 , 80 , 120 )
                   HEIGHT          20
                   VALUE           .F.
                   TOOLTIP "GLOBAL Search: Include data of DBF in Search Process"
                   TRANSPARENT     if( IsXPThemeActive() , .T. , .F. )
           END CHECKBOX

           DEFINE LABEL Label_2
                   ROW             GetDesktopRealHeight() - 85
                   COL             328
                   VALUE           'F1 Help     F2 Open/New    F3 Save     F4 Build     F5 Run     F10 Exit'
                   AUTOSIZE        .T.
                   FONTNAME        'Arial'
                   FONTSIZE        9
                   TRANSPARENT     if( IsXPThemeActive() , .T. , .F. )
           END LABEL

           DEFINE LABEL LGlobal
                   ROW             GetDesktopRealHeight() - 85
                   COL             GetDesktopRealWidth() - if( PUB_bW800 , 100 , 190 )
                   WIDTH           if( PUB_bW800 , 80 , 180 )
                   VALUE           if( PUB_bW800 , 'Global Is On' , 'Global Search Is Active' )
                   FONTNAME        'arial'
                   FONTSIZE        10
                   FONTBOLD        .T.
                   FONTCOLOR       DEF_COLORRED
                   TOOLTIP         "GLOBAL Search is active, use Reset Button for disable"
                   TRANSPARENT     if( IsXPThemeActive() , .T. , .F. )
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
   DoMethod( "WinKiller" , "hide" )
#endif

   if !PUB_bLite
      TabChange( "FILES" )
   endif

   CargoSearch()

   if PUB_bLite

      DEFINE WINDOW VentanaLite ;
              AT 0,0 ;
              WIDTH ( ( GetDesktopRealWidth() * 70 ) / 100 ) HEIGHT ( ( GetDesktopRealHeight() * 95 ) / 100 ) ;
              TITLE PUB_cQPM_Title+' [ New Project ]' ;
              CHILD ;
              ICON "QPM" ;
              ON INIT HideInitAutoRun()

              @ 47 , 2 FRAME FFrame ;
                 WIDTH ( ( GetDesktopRealWidth() * 68.7 ) / 100 ) ;
                 HEIGHT ( ( GetDesktopRealHeight() * 85 ) / 100 )

              DEFINE LABEL LStatusLabel
                      ROW             15
                      COL             28
                      WIDTH           100
                      HEIGHT          18
                      VALUE           PUB_cStatusLabel
              END LABEL

              @ 07 , 153 LABEL LResumen ;
                 VALUE '' ;
                 WIDTH 600 ;
                 HEIGHT 18 ;
                 FONT 'arial' SIZE 10 BOLD ;
                 FONTCOLOR DEF_COLORBLUE

              @ 26 , 153 LABEL LFull ;
                 VALUE '' ;
                 WIDTH 160 ;
                 HEIGHT 18 ;
                 FONT 'arial' SIZE 10 BOLD ;
                 FONTCOLOR DEF_COLORGREEN

              @ 26 , 320 LABEL LExtra ;
                 VALUE '' ;
                 WIDTH 200 ;
                 HEIGHT 18 ;
                 FONT 'arial' SIZE 10 BOLD ;
                 FONTCOLOR DEF_COLORBLACK

              @ 60, 10 RICHEDITBOX RichEditSysout ;
                      WIDTH           ( ( GetDesktopRealWidth() * 67 ) / 100 ) ;
                      HEIGHT          ( ( GetDesktopRealHeight() * 74 ) / 100 ) ;
                      READONLY        ;
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

              DEFINE BUTTON BStop
                      ROW             ( ( GetDesktopRealHeight() * 85 ) / 100 )
                      COL             ( ( GetDesktopRealWidth() * 18 ) / 100 )
                      WIDTH           75
                      HEIGHT          25
                      PICTURE "STOP"
                      NOXPSTYLE .T.
                      TOOLTIP 'Stop BUILD Process'
                      ONCLICK QPM_Wait( "BuildStop()" , "Stopping, please wait ..." )
              END BUTTON

              DEFINE BUTTON BAbout
                      ROW             ( ( GetDesktopRealHeight() * 85 ) / 100 )
                      COL             ( ( GetDesktopRealWidth() * 28 ) / 100 )
                      WIDTH           75
                      HEIGHT          25
                      CAPTION "About"
                      TOOLTIP 'QPM Autor'
                      ONCLICK QPM_About()
              END BUTTON

              DEFINE BUTTON BRunP
                      ROW             ( ( GetDesktopRealHeight() * 85 ) / 100 )
                      COL             ( ( GetDesktopRealWidth() * 38 ) / 100 )
                      WIDTH           75
                      HEIGHT          25
                      CAPTION "Run Parm"
                      TOOLTIP 'Run Program with Parameters'
                      ONCLICK ( bRunParm := .T. , QPM_Run( bRunParm ) )
              END BUTTON
              
              DEFINE BUTTON BRun
                      ROW             ( ( GetDesktopRealHeight() * 85 ) / 100 )
                      COL             ( ( GetDesktopRealWidth() * 48 ) / 100 )
                      WIDTH           75
                      HEIGHT          25
                      CAPTION "Run"
                      TOOLTIP 'Run Program Without Parameters'
                      ONCLICK ( bRunParm := .F. , QPM_Run( bRunParm ) )
              END BUTTON
              
              VentanaLite.BRunP.enabled := .F.
              VentanaLite.BRun.enabled := .F.

              DEFINE BUTTON BExit
                      ROW             ( ( GetDesktopRealHeight() * 85 ) / 100 )
                      COL             ( ( GetDesktopRealWidth() * 58 ) / 100 )
                      WIDTH           75
                      HEIGHT          25
                      CAPTION "Exit"
                      TOOLTIP 'Exit QPM and Return to caller'
                      ONCLICK if( !PUB_bIsProcessing , DoMethod( "VentanaLite" , "release" ) , )
              END BUTTON
      END WINDOW

      CENTER WINDOW VentanaLite

      VentanaMain.Minimize()

   endif

   QPM_SetProcessPriority( "NORMAL" )

// if PUB_RunMode == "PORTABLE"
//    SetProperty( "VentanaMain" , "BackColor" , DEF_COLORGREENCLARO )
// endif

   SetProperty( "VentanaMain" , "OverrideCompile" , "enabled" , .F. )
   SetProperty( "VentanaMain" , "OverrideLink" , "enabled" , .F. )

#ifdef QPM_KILLER
   ACTIVATE WINDOW WinKiller , VentanaMain
#else
   ACTIVATE WINDOW VentanaMain
#endif

// RELEASE WINDOW QPM_VentanaFondo

Return Nil

Function QPM_AddFilesPRG
Return QPM_Wait( "QPM_AddFilesPRG2()" , "Loading file ..." )
Function QPM_AddFilesPRG2()
   Local Files , x , i , Exists
   Local bTop := if( GetProperty( "VentanaMain" , "GPrgFiles" , "itemcount" ) == 0 , .T. , .F. )
   if !US_IsDirectory( PUB_cProjectFolder )
      MsgStop( "Project Folder not Found: " + PUB_cProjectFolder + '. Look at ' + PagePRG )
      Return .T.
   endif
// SetMGWaitHide()
   Files := QPM_GetFilesPRG()
   if len( Files ) > 50    // 62
      MsgInfo( "Sorry, Windows GetFile Service only accept 50 files selected.  Retry with less files." )
      Return .F.
   endif
// SetMGWaitShow()
   if len( Files ) == 1
      if !( US_Upper( US_FileNameOnlyExt( Files[1] ) ) == "PRG" ) .and. ;
         !( US_Upper( US_FileNameOnlyExt( Files[1] ) ) == "C" ) .and. ;
         !( US_Upper( US_FileNameOnlyExt( Files[1] ) ) == "CPP" ) .and. ;
         !( US_Upper( US_FileNameOnlyExt( Files[1] ) ) == "LIB" ) .and. ;
         !( US_Upper( US_FileNameOnlyExt( Files[1] ) ) == "A" ) .and. ;
         !( US_Upper( US_FileNameOnlyExt( Files[1] ) ) == "DLL" )
         Files[1] := Files[1] + ".PRG"
      endif
      if !file( Files[1] )
         if MyMsgYesNo( "File '"+Files[1]+"' not found.  Do you want create an empty file ?" )
            if US_Upper( US_FileNameOnlyExt( Files[1] ) ) == "PRG"
               QPM_CreateNewFile( "PRG" , Files[1] )
            else
               QPM_MemoWrit( Files[1] , " " )
            endif
         else
            Return .F.
         endif
      endif
   endif
   For x := 1 To Len ( Files )
      Exists := .F.
   // if substr( US_FileNameOnlyPath( Files[x] ) , 2 , 2 ) == ":" + DEF_SLASH .and. len( US_FileNameOnlyPath( Files[x] ) ) == 3
   //    MsgStop( "Components located in a root folder will not work correctly in QPM: " + Files[ x ] )
   //    exit
   // endif
      Files[x] := ChgPathToRelative( Files[x] )
      For i := 1 To VentanaMain.GPrgFiles.ItemCount
         If US_Upper(alltrim(Files [x])) == US_Upper(alltrim(GetProperty( "VentanaMain" , "GPrgFiles" , "Cell" , i , NCOLPRGFULLNAME )))
            Exists := .T.
            Exit
         EndIf
      Next i
      If .Not. Exists
         VentanaMain.GPrgFiles.AddItem( { PUB_nGridImgNone , " " , US_FileNameOnlyNameAndExt( Files[x] ) , Files[x] , "0" , "" , "" } )
         if !empty( cLastGlobalSearch )
            if GlobalSearch2( "PRG" , cLastGlobalSearch , VentanaMain.GPrgFiles.ItemCount , bLastGlobalSearchFun , bLastGlobalSearchDbf )
               TotCaption( "PRG" , +1 )
            endif
         endif
     //  if ascan( vExtraFoldersForSearch , US_FileNameOnlyPath( ChgPathToReal( Files[x] ) ) ) = 0
         if AScan( vExtraFoldersForSearch , { |y| upper( US_VarToStr( y ) ) == upper( US_FileNameOnlyPath( ChgPathToReal( Files[x] ) ) ) } ) == 0
            aadd( vExtraFoldersForSearch , US_FileNameOnlyPath( ChgPathToReal( Files[x] ) ) )
         endif
      EndIf
   Next x
   if VentanaMain.GPrgFiles.Value = 0
      VentanaMain.GPrgFiles.Value := 1
   endif
   DoMethod( "VentanaMain" , "GPrgFiles" , "ColumnsAutoFitH" )
   QPM_CheckFiles()
// QPM_ForceRecompCheck( ChgPathToReal( GetProperty( "VentanaMain" , "GPrgFiles" , "Cell" , GetProperty( "VentanaMain" , "GPrgFiles" , "ItemCount" ) , NCOLPRGFULLNAME ) ) , GetProperty( "VentanaMain" , "GPrgFiles" , "ItemCount" ) )
   if bTop .and. VentanaMain.GPrgFiles.ItemCount > 0
      CambioTitulo()
      MsgInfo ( ChgPathToReal( GetProperty( "VentanaMain" , "GPrgFiles" , "Cell" , 1 , NCOLPRGFULLNAME ) ) + ' Is The New Project Top File.' )
   endif
Return .T.

Function QPM_AddFilesHEA
Return QPM_Wait( "QPM_AddFilesHEA2()" , "Loading..." )
Function QPM_AddFilesHEA2()
   Local Files , x , i , Exists
   if !US_IsDirectory( PUB_cProjectFolder )
      MsgStop( "Project Folder not Found: " + PUB_cProjectFolder + '. Look at ' + PagePRG )
      Return .T.
   endif
   SetMGWaitHide()
   Files := QPM_GetFilesHEA()
   SetMGWaitShow()
   if len( Files ) == 1
      if !( US_Upper( US_FileNameOnlyExt( Files[1] ) ) == "H" ) .and. ;
         !( US_Upper( US_FileNameOnlyExt( Files[1] ) ) == "CH" )
         Files[1] := Files[1] + ".H"
      endif
      if !file( Files[1] )
         if MyMsgYesNo( "File '"+Files[1]+"' not found.  Do you want create an empty file ?" )
            QPM_CreateNewFile( "HEA" , Files[1] )
         else
            Return .F.
         endif
      endif
   endif
   For x := 1 To Len ( Files )
      Exists := .F.
    //if substr( US_FileNameOnlyPath( Files[x] ) , 2 , 2 ) == ":" + DEF_SLASH .and. len( US_FileNameOnlyPath( Files[x] ) ) == 3
    //   MsgStop( "Components located in a root folder will not work correctly in QPM: " + Files[ x ] )
    //   exit
    //endif
      Files[x] := ChgPathToRelative( Files[x] )
      For i := 1 To VentanaMain.GHeaFiles.ItemCount
         If US_Upper(alltrim(Files [x])) == US_Upper(alltrim(GetProperty( "VentanaMain" , "GHeaFiles" , "Cell" , i , NCOLHEAFULLNAME )))
            Exists := .T.
            Exit
         EndIf
      Next i
      If .Not. Exists
         VentanaMain.GHeaFiles.AddItem( { PUB_nGridImgNone , US_FileNameOnlyNameAndExt( Files[x] ) , Files[x] , "0" , "" , "" } )
         if !empty( cLastGlobalSearch )
            if GlobalSearch2( "HEA" , cLastGlobalSearch , VentanaMain.GHeaFiles.ItemCount , bLastGlobalSearchFun , bLastGlobalSearchDbf )
               TotCaption( "HEA" , +1 )
            endif
         endif
   //    if ascan( vExtraFoldersForSearch , US_FileNameOnlyPath( ChgPathToReal( Files[x] ) ) ) = 0
         if AScan( vExtraFoldersForSearch , { |y| upper( US_VarToStr( y ) ) == upper( US_FileNameOnlyPath( ChgPathToReal( Files[x] ) ) ) } ) == 0
            aadd( vExtraFoldersForSearch , US_FileNameOnlyPath( ChgPathToReal( Files[x] ) ) )
         endif
      EndIf
   Next x
   if VentanaMain.GHeaFiles.Value = 0
      VentanaMain.GHeaFiles.Value := 1
   endif
   DoMethod( "VentanaMain" , "GHeaFiles" , "ColumnsAutoFitH" )
   QPM_CheckFiles()
Return .T.

Function QPM_AddFilesPAN
Return QPM_Wait( "QPM_AddFilesPAN2()" , "Loading..." )
Function QPM_AddFilesPAN2()
   Local Files , x , i , Exists, PanNew
   if !US_IsDirectory( PUB_cProjectFolder )
      MsgStop( "Project Folder not Found: " + PUB_cProjectFolder + '. Look at ' + PagePRG )
      Return .T.
   endif
// SetMGWaitHide()
   Files := QPM_GetFilesPAN()
   if len( Files ) == 1
      if !( US_Upper( US_FileNameOnlyExt( Files[1] ) ) == "FMG" )
         Files[1] := Files[1] + ".FMG"
      endif
      if !file( Files[1] )
         if MyMsgYesNo( "File '"+Files[1]+"' not found.  Do you want create an empty file ?" )
            if !QPM_CreateNewFile( "PAN" , Files[1] )
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
   // if substr( US_FileNameOnlyPath( Files[x] ) , 2 , 2 ) == ":" + DEF_SLASH .and. len( US_FileNameOnlyPath( Files[x] ) ) == 3
   //    MsgStop( "Components located in a root folder will not work correctly in QPM: " + Files[ x ] )
   //    exit
   // endif
      Files[x] := ChgPathToRelative( Files[x] )
      For i := 1 To VentanaMain.GPanFiles.ItemCount
         If US_Upper(alltrim(Files[x])) == US_Upper(alltrim(GetProperty( "VentanaMain" , "GPanFiles" , "Cell" , i , NCOLPANFULLNAME )))
            Exists := .T.
            Exit
         EndIf
      Next i
      If .Not. Exists
         VentanaMain.GPanFiles.AddItem( { PUB_nGridImgNone , US_FileNameOnlyNameAndExt( Files[x] ) , Files[x] , "0" , "" , "" } )
         if !empty( cLastGlobalSearch )
            if GlobalSearch2( "PAN" , cLastGlobalSearch , VentanaMain.GPanFiles.ItemCount , bLastGlobalSearchFun , bLastGlobalSearchDbf )
               TotCaption( "PAN" , +1 )
            endif
         endif
     //  if ascan( vExtraFoldersForSearch , US_FileNameOnlyPath( ChgPathToReal( Files[x] ) ) ) = 0
         if AScan( vExtraFoldersForSearch , { |y| upper( US_VarToStr( y ) ) == upper( US_FileNameOnlyPath( ChgPathToReal( Files[x] ) ) ) } ) == 0
            aadd( vExtraFoldersForSearch , US_FileNameOnlyPath( ChgPathToReal( Files[x] ) ) )
         endif
      EndIf
   Next x
   if VentanaMain.GPanFiles.Value = 0
      VentanaMain.GPanFiles.Value := 1
   endif
   DoMethod( "VentanaMain" , "GPanFiles" , "ColumnsAutoFitH" )
   QPM_CheckFiles()
Return .T.

Function QPM_AddFilesDBF
Return QPM_Wait( "QPM_AddFilesDBF2()" , "Loading..." )
Function QPM_AddFilesDBF2()
   Local Files , x , i , Exists
   if !US_IsDirectory( PUB_cProjectFolder )
      MsgStop( "Project Folder not Found: " + PUB_cProjectFolder + '. Look at ' + PagePRG )
      Return .T.
   endif
// SetMGWaitHide()
   Files := QPM_GetFilesDBF()
// SetMGWaitShow()
   if len( Files ) == 1
      if !( US_Upper( US_FileNameOnlyExt( Files[1] ) ) == "DBF" )
         Files[1] := Files[1] + ".dbf"
      endif
      if !file( Files[1] )
         if MyMsgYesNo( "File '"+Files[1]+"' not found.  Do you want create an empty file ?" )
            if !QPM_CreateNewFile( "DBF" , Files[1] )
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
         If US_Upper(alltrim(Files [x])) == US_Upper(alltrim(GetProperty( "VentanaMain" , "GDbfFiles" , "Cell" , i , NCOLDBFFULLNAME )))
            Exists := .T.
            Exit
         EndIf
      Next i
      If .Not. Exists
         VentanaMain.GDbfFiles.AddItem( { PUB_nGridImgNone , US_FileNameOnlyNameAndExt( Files[x] ) , Files[x] , "0 0" , "" , "0 ** 0" } )
         if !empty( cLastGlobalSearch )
            if GlobalSearch2( "DBF" , cLastGlobalSearch , VentanaMain.GDbfFiles.ItemCount , bLastGlobalSearchFun , bLastGlobalSearchDbf )
               TotCaption( "DBF" , +1 )
            endif
         endif
   //    if ascan( vExtraFoldersForSearch , US_FileNameOnlyPath( ChgPathToReal( Files[x] ) ) ) = 0
       //if AScan( vExtraFoldersForSearch , { |y| upper( US_VarToStr( y ) ) == upper( US_FileNameOnlyPath( ChgPathToReal( Files[x] ) ) ) } ) == 0
       //   aadd( vExtraFoldersForSearch , US_FileNameOnlyPath( ChgPathToReal( Files[x] ) ) )
       //endif
      EndIf
   Next x
   if VentanaMain.GDbfFiles.Value = 0
      VentanaMain.GDbfFiles.Value := 1
   endif
   DoMethod( "VentanaMain" , "GDbfFiles" , "ColumnsAutoFitH" )
   QPM_CheckFiles()
Return .T.

Function QPM_AddFilesLIB
Return QPM_Wait( "QPM_AddFilesLIB2()" , "Loading..." )
Function QPM_AddFilesLIB2()
   Local Files , x , i , Exists
   SetMGWaitHide()
   Files := QPM_GetFilesLIB()
   SetMGWaitShow()
   For x := 1 To Len( Files )
      Exists := .F.
      //
      Files[x] := ChgPathToRelative( Files[x] )
      //
      For i := 1 To VentanaMain.GIncFiles.ItemCount
         If US_Upper(alltrim(Files[x])) == US_Upper( US_WordSubStr( GetProperty( "VentanaMain" , "GIncFiles" , "Cell" , i , NCOLINCFULLNAME ) , 3 ) )
            Exists := .T.
            Exit
         EndIf
      Next i
      If .Not. Exists
         VentanaMain.GIncFiles.AddItem( { PUB_nGridImgNone , US_FileNameOnlyNameAndExt( Files[x] ) , "* * " + Files[x] } )
         LibPos( VentanaMain.GIncFiles.ItemCount , "*Last*" )
         if !empty( cLastGlobalSearch )
            if GlobalSearch2( "LIB" , cLastGlobalSearch , VentanaMain.GIncFiles.ItemCount , bLastGlobalSearchFun , bLastGlobalSearchDbf )
               TotCaption( "LIB" , +1 )
            endif
         endif
      // if ascan( &("vExtraFoldersForLibs"+GetSuffix()) , upper( US_FileNameOnlyPath( ChgPathToReal( Files[x] ) ) ) ) = 0
         if AScan( &("vExtraFoldersForLibs"+GetSuffix()) , { |y| upper( US_VarToStr( y ) ) == upper( US_FileNameOnlyPath( ChgPathToReal( Files[x] ) ) ) } ) == 0
            aadd( &("vExtraFoldersForLibs"+GetSuffix()) , upper( US_FileNameOnlyPath( ChgPathToReal( Files[x] ) ) ) )
         endif
      EndIf
   Next x
   if VentanaMain.GIncFiles.ItemCount = 1
      VentanaMain.GIncFiles.Value := 1
   endif
   DoMethod( "VentanaMain" , "GIncFiles" , "ColumnsAutoFitH" )
   QPM_CheckFiles()
Return .T.

Function QPM_AddExcludeFilesLIB
   Local Files , x , i , Exists
   Files := QPM_GetExcludeFilesLIB( )
   For x := 1 To Len ( Files )
       Exists := .F.
       For i := 1 To VentanaMain.GExcFiles.ItemCount
          If US_Upper(alltrim(Files[x])) == US_Upper( US_WordSubStr( GetProperty( "VentanaMain" , "GExcFiles" , "Cell" , i , NCOLEXCNAME ) , 3 ) )
             Exists := .T.
             Exit
          EndIf
       Next
       If .Not. Exists
          VentanaMain.GExcFiles.AddItem( { PUB_nGridImgNone , Files[x] } )
       EndIf
   next
   DoMethod( "VentanaMain" , "GExcFiles" , "ColumnsAutoFitH" )
Return .T.

#ifdef QPM_SHG
Function QPM_AddFilesHLP()
   Local cAuxTopic := "" , cAuxNick := ""
   if SHG_BaseOK
   // SetMGWaitHide()
      if SHG_InputTopic( @cAuxTopic , @cAuxNick )
   //    SetMGWaitShow()
         VentanaMain.GHlpFiles.AddItem( { 0 , cAuxTopic , cAuxNick , "0" , "E" } )
         GridImage( "VentanaMain" , "GHlpFiles" , VentanaMain.GHlpFiles.ItemCount , NCOLHLPSTATUS , "+" , PUB_nGridImgHlpPage )
         SHG_AddRecord( "P" , VentanaMain.GHlpFiles.ItemCount , cAuxTopic , cAuxNick , "New Topic !!!" )
         VentanaMain.GHlpFiles.Value := VentanaMain.GHlpFiles.ItemCount
         DoMethod( "VentanaMain" , "GHlpFiles" , "ColumnsAutoFitH" )
   // else
   //    SetMGWaitShow()
      endif
   else
      MsgInfo( "Help Database not selected.  Use open button for open or create help database" )
   endif
Return .T.
#endif

Function QPM_EditPRG
   // QPM_EditPRG2
   Local Editor , Rs , i , vAux := {}
   Local EditControlFile , RunParms , cLineCmd
#ifdef QPM_HOTRECOVERY
   Local HotRecoveryControlFile
#endif
   if !US_IsDirectory( PUB_cProjectFolder )
      MsgStop( "Project Folder not Found: " + PUB_cProjectFolder + '. Look at ' + PagePRG )
      Return .T.
   endif
   if !File( ChgPathToReal( GetProperty( "VentanaMain" , "GPrgFiles" , "Cell" , VentanaMain.GPrgFiles.Value , NCOLPRGFULLNAME ) ) )
      MsgStop( "File not found !!!" )
      Return .F.
   endif
   if !File( alltrim( Gbl_TEditor ) )
      MsgStop( "Program Editor not Found: "+alltrim( Gbl_TEditor )+'. Look at ' + PUB_MenuGblOptions + ' of Settings menu.' )
      Return .T.
   endif
   If VentanaMain.GPrgFiles.Value == 0
      Return .T.
   EndIf
   If Empty( Gbl_TEditor )
      MyMsg( 'Operation Aborted', US_VarToStr( 'Program Editor Not Defined. Look at ' + PUB_MenuGblOptions + ' of Settings menu.' ) , "E" , bAutoExit )
      Return .T.
   Else
      Editor := US_ShortName( alltrim( Gbl_TEditor ) )
   EndIf
   if bSuspendControlEdit
      if bEditorLongName
         cLineCmd := ChgPathToReal( GetProperty( "VentanaMain" , "GPrgFiles" , "Cell" , VentanaMain.GPrgFiles.Value , NCOLPRGFULLNAME ) )
      else
         cLineCmd := US_ShortName( ChgPathToReal( GetProperty( "VentanaMain" , "GPrgFiles" , "Cell" , VentanaMain.GPrgFiles.Value , NCOLPRGFULLNAME ) ) )
      endif
      QPM_EXECUTE( Editor , cLineCmd )
   // EXECUTE FILE ( Editor ) PARAMETERS ( cLineCmd )
   else
      if GridImage( "VentanaMain" , "GPrgFiles" , VentanaMain.GPrgFiles.Value , NCOLPRGSTATUS , "?" , PUB_nGridImgEdited )
         MsgInfo( "Already Opened" )
         Return .F.
      endif
      GridImage( "VentanaMain" , "GPrgFiles" , VentanaMain.GPrgFiles.Value , NCOLPRGSTATUS , "+" , PUB_nGridImgEdited )
      VentanaMain.RichEditPrg.BackColor := DEF_COLORBACKEXTERNALEDIT
      VentanaMain.RichEditPrg.FontColor := DEF_COLORFONTEXTERNALEDIT
      EditControlFile := US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + "_" + PUB_cSecu + "ECF" + US_DateTimeCen() + ".cnt"
#ifdef QPM_HOTRECOVERY
      HotRecoveryControlFile := US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + "_" + PUB_cSecu + "SrcHOTRecovery" + US_DateTimeCen() + ".hot"
      US_FileCopy( ChgPathToReal( GetProperty( "VentanaMain" , "GPrgFiles" , "Cell" , VentanaMain.GPrgFiles.Value , NCOLPRGFULLNAME ) ) , HotRecoveryControlFile )
      SetFDaTi( HotRecoveryControlFile , US_FileDate( ChgPathToReal( GetProperty( "VentanaMain" , "GPrgFiles" , "Cell" , VentanaMain.GPrgFiles.Value , NCOLPRGFULLNAME ) ) ) , US_FileTime( ChgPathToReal( GetProperty( "VentanaMain" , "GPrgFiles" , "Cell" , VentanaMain.GPrgFiles.Value , NCOLPRGFULLNAME ) ) ) )
      SetProperty( "VentanaMain" , "GPrgFiles" , "Cell" , VentanaMain.GPrgFiles.Value , NCOLPRGRECOVERY , HotRecoveryControlFile )
      if _IsControlDefined( "HR_GridItemTargetPRG" , "WinHotRecovery" )
         GridImage( "WinHotRecovery" , "HR_GridItemTargetPRG" , GetProperty( "VentanaMain" , "GPrgFiles" , "Value" ) , DEF_N_ITEM_COLIMAGE , "+" , PUB_nGridImgEdited )
      endif
#endif
      SetProperty( "VentanaMain" , "GPrgFiles" , "Cell" , VentanaMain.GPrgFiles.Value , NCOLPRGEDIT , EditControlFile )
      RunParms        := US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + "_" + PUB_cSecu + "RP" + US_DateTimeCen() + ".cng"
      if bEditorLongName
         cLineCmd := "COMMAND " + Editor + " " + ChgPathToReal( GetProperty( "VentanaMain" , "GPrgFiles" , "Cell" , VentanaMain.GPrgFiles.Value , NCOLPRGFULLNAME ) )
      else
         cLineCmd := "COMMAND " + Editor + " " + US_ShortName( ChgPathToReal( GetProperty( "VentanaMain" , "GPrgFiles" , "Cell" , VentanaMain.GPrgFiles.Value , NCOLPRGFULLNAME ) ) )
      endif
      QPM_MemoWrit( RunParms , "Run Parms for " + ChgPathToReal( GetProperty( "VentanaMain" , "GPrgFiles" , "Cell" , VentanaMain.GPrgFiles.Value , NCOLPRGFULLNAME ) ) + HB_OsNewLine() + ;
                           cLineCmd + HB_OsNewLine() + ;
                           "CONTROL " + EditControlFile )
      QPM_MemoWrit( EditControlFile , "Edit Control File for " + ChgPathToReal( GetProperty( "VentanaMain" , "GPrgFiles" , "Cell" , VentanaMain.GPrgFiles.Value , NCOLPRGFULLNAME ) ) )
      QPM_Execute( US_ShortName( PUB_cQPM_Folder ) + DEF_SLASH + "US_Run.exe" , "QPM " + RunParms )
   endif
   if bLogActivity
      QPM_MemoWrit( PUB_cQPM_Folder+DEF_SLASH + "QPM.log" , memoread( PUB_cQPM_Folder+DEF_SLASH + "QPM.log" ) + HB_OSNewLine() + "xRefPrgFmg Edit " + GetProperty( "VentanaMain" , "GPrgFiles" , "Cell" , VentanaMain.GPrgFiles.Value , NCOLPRGFULLNAME ) )
   endif
// if ( Rs := ascan( vSinLoadWindow ,                     US_Upper( ChgPathToReal( GetProperty( "VentanaMain" , "GPrgFiles" , "Cell" , VentanaMain.GPrgFiles.Value , NCOLPRGFULLNAME ) ) ) ) ) > 0 && Para Forzar Scan de PRG en busca de xREF con FMG
   if ( Rs := AScan( vSinLoadWindow , { |y| upper( US_VarToStr( y ) ) == US_Upper( ChgPathToReal( GetProperty( "VentanaMain" , "GPrgFiles" , "Cell" , VentanaMain.GPrgFiles.Value , NCOLPRGFULLNAME ) ) ) } ) ) > 0 && Para Forzar Scan de PRG en busca de xREF con FMG
      adel( vSinLoadWindow , Rs ) && Para Forzar Scan de PRG en busca de xREF con FMG
      if bLogActivity
         QPM_MemoWrit( PUB_cQPM_Folder+DEF_SLASH + "QPM.log" , memoread( PUB_cQPM_Folder+DEF_SLASH + "QPM.log" ) + HB_OSNewLine() + "xRefPrgFmg Delete " + GetProperty( "VentanaMain" , "GPrgFiles" , "Cell" , VentanaMain.GPrgFiles.Value , NCOLPRGFULLNAME ) + " from vSinLoadWindow by Edit" )
      endif
   endif
// if ( Rs := ascan( vSinInclude , US_Upper( ChgPathToReal( GetProperty( "VentanaMain" , "GPrgFiles" , "Cell" , VentanaMain.GPrgFiles.Value , NCOLPRGFULLNAME ) ) ) ) ) > 0 && Para Forzar Scan de PRG en busca de xREF con Header
   if ( Rs := ascan( vSinInclude , { |y| upper( US_VarToStr( y ) ) == US_Upper( ChgPathToReal( GetProperty( "VentanaMain" , "GPrgFiles" , "Cell" , VentanaMain.GPrgFiles.Value , NCOLPRGFULLNAME ) ) ) } ) ) > 0 && Para Forzar Scan de PRG en busca de xREF con Header
      adel( vSinInclude , Rs ) && Para Forzar Scan de PRG en busca de xREF con HEA
      if bLogActivity
         QPM_MemoWrit( PUB_cQPM_Folder+DEF_SLASH + "QPM.log" , memoread( PUB_cQPM_Folder+DEF_SLASH + "QPM.log" ) + HB_OSNewLine() + "xRefPrgHea Delete " + GetProperty( "VentanaMain" , "GPrgFiles" , "Cell" , VentanaMain.GPrgFiles.Value , NCOLPRGFULLNAME ) + " from vSinInclude by Edit" )
      endif
   endif
//us_log( hb_osnewline() + US_VarToStr( vSinLoadWindow ) )
   /* limpio las ocurrencias del prg dentro de xref con header */
   For i:=1 to len( vXRefPrgHea )
      if !( US_Word( vXRefPrgHea[i] , 1 ) == US_Upper( US_FileNameOnlyNameAndExt( GetProperty( "VentanaMain" , "GPrgFiles" , "Cell" , VentanaMain.GPrgFiles.Value , NCOLPRGFULLNAME ) ) ) )
         AADD( vAux , vXRefPrgHea[i] )
      endif
   next
   vXRefPrgHea := {}
   For i:=1 to len( vAux )
      AADD( vXRefPrgHea , vAux[i] )
   next
   /* fin limpio las ocurrencias del prg */
   vAux := {}
   /* limpio las ocurrencias del prg dentro de xref con form   */
   For i:=1 to len( vXRefPrgFmg )
      if !( US_Word( vXRefPrgFmg[i] , 1 ) == US_Upper( US_FileNameOnlyNameAndExt( GetProperty( "VentanaMain" , "GPrgFiles" , "Cell" , VentanaMain.GPrgFiles.Value , NCOLPRGFULLNAME ) ) ) )
         AADD( vAux , vXRefPrgFmg[i] )
      endif
   next
   vXRefPrgFmg := {}
   For i:=1 to len( vAux )
      AADD( vXRefPrgFmg , vAux[i] )
   next
   /* fin limpio las ocurrencias del prg */
Return .T.

Function QPM_EditPPO
   // QPM_EditPPO2
   Local Editor
   Local cLineCmd
   if !US_IsDirectory( PUB_cProjectFolder )
      MsgStop( "Project Folder not Found: " + PUB_cProjectFolder + '. Look at ' + PagePRG )
      Return .T.
   endif
   if !File( alltrim( Gbl_TEditor ) )
      MsgStop( "Program Editor not Found: "+alltrim( Gbl_TEditor )+'. Look at ' + PUB_MenuGblOptions + ' of Settings menu.' )
      Return .T.
   endif
   If VentanaMain.GPrgFiles.Value == 0
      Return .T.
   EndIf
   If Empty( Gbl_TEditor )
      MyMsg( 'Operation Aborted', US_VarToStr( 'Program Editor Not Defined. Look at ' + PUB_MenuGblOptions + ' of Settings menu.' ) , "E" , bAutoExit )
      Return .T.
   Else
      Editor := US_ShortName( alltrim( Gbl_TEditor ) )
   EndIf
   if bEditorLongName
      cLineCmd := PUB_cProjectFolder + DEF_SLASH + GetObjName() + DEF_SLASH + US_FileNameOnlyName( GetProperty( "VentanaMain" , "GPrgFiles" , "Cell" , VentanaMain.GPrgFiles.Value , NCOLPRGNAME ) ) + '.ppo'
   else
      cLineCmd := US_ShortName( PUB_cProjectFolder + DEF_SLASH + GetObjName() + DEF_SLASH + US_FileNameOnlyName( GetProperty( "VentanaMain" , "GPrgFiles" , "Cell" , VentanaMain.GPrgFiles.Value , NCOLPRGNAME ) ) + '.ppo' )
   endif
   QPM_EXECUTE( Editor , cLineCmd )
Return .T.

Function QPM_EditHEA
   Local Editor
   Local EditControlFile , RunParms , cLineCmd
#ifdef QPM_HOTRECOVERY
   Local HotRecoveryControlFile
#endif
   if !US_IsDirectory( PUB_cProjectFolder )
      MsgStop( "Project Folder not Found: " + PUB_cProjectFolder + '. Look at ' + PagePRG )
      Return .T.
   endif
   if !File( ChgPathToReal( GetProperty( "VentanaMain" , "GHeaFiles" , "Cell" , VentanaMain.GHeaFiles.Value , NCOLHEAFULLNAME ) ) )
      MsgStop( "File not found !!!" )
      Return .F.
   endif
   If VentanaMain.GHeaFiles.Value == 0
      Return .T.
   EndIf
   do case
      case cHeadTool == "EDITOR"
         If Empty ( Gbl_TEditor )
            MyMsg( 'Operation Aborted', US_VarToStr( 'Folder for Editor Not Completed. Look at ' + PUB_MenuGblOptions + ' of Settings menu.' ) , "E" , bAutoExit )
            Return .T.
         Else
            if !File( alltrim( Gbl_TEditor ) )
               MsgStop( "Program Editor not Found: "+alltrim( Gbl_TEditor )+'. Look at ' + PUB_MenuGblOptions + ' of Settings menu.' )
               Return .T.
            endif
            Editor := US_ShortName( alltrim( Gbl_TEditor ) )
         EndIf
         if bSuspendControlEdit
            if bEditorLongName
               cLineCmd := ChgPathToReal( GetProperty( "VentanaMain" , "GHeaFiles" , "Cell" , VentanaMain.GHeaFiles.Value , NCOLHEAFULLNAME ) )
            else
               cLineCmd := US_ShortName( ChgPathToReal( GetProperty( "VentanaMain" , "GHeaFiles" , "Cell" , VentanaMain.GHeaFiles.Value , NCOLHEAFULLNAME ) ) )
            endif
            QPM_Execute( Editor , cLineCmd )
         else
            if GridImage( "VentanaMain" , "GHeaFiles" , VentanaMain.GHeaFiles.Value , NCOLHEASTATUS , "?" , PUB_nGridImgEdited )
               MsgInfo( "Already Opened" )
               Return .F.
            endif
            GridImage( "VentanaMain" , "GHeaFiles" , VentanaMain.GHeaFiles.Value , NCOLHEASTATUS , "+" , PUB_nGridImgEdited )
            VentanaMain.RichEditHea.BackColor := DEF_COLORBACKEXTERNALEDIT
            VentanaMain.RichEditHea.FontColor := DEF_COLORFONTEXTERNALEDIT
            EditControlFile := US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + "_" + PUB_cSecu + "ECF" + US_DateTimeCen() + ".cnt"
#ifdef QPM_HOTRECOVERY
            HotRecoveryControlFile := US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + "_" + PUB_cSecu + "HeaHOTRecovery" + US_DateTimeCen() + ".hot"
            US_FileCopy( ChgPathToReal( GetProperty( "VentanaMain" , "GHeaFiles" , "Cell" , VentanaMain.GHeaFiles.Value , NCOLHEAFULLNAME ) ) , HotRecoveryControlFile )
            SetFDaTi( HotRecoveryControlFile , US_FileDate( ChgPathToReal( GetProperty( "VentanaMain" , "GHeaFiles" , "Cell" , VentanaMain.GHeaFiles.Value , NCOLHEAFULLNAME ) ) ) , US_FileTime( ChgPathToReal( GetProperty( "VentanaMain" , "GHeaFiles" , "Cell" , VentanaMain.GHeaFiles.Value , NCOLHEAFULLNAME ) ) ) )
            SetProperty( "VentanaMain" , "GHeaFiles" , "Cell" , VentanaMain.GHeaFiles.Value , NCOLHEARECOVERY , HotRecoveryControlFile )
            if _IsControlDefined( "HR_GridItemTargetHea" , "WinHotRecovery" )
               GridImage( "WinHotRecovery" , "HR_GridItemTargetHea" , GetProperty( "VentanaMain" , "GHeaFiles" , "Value" ) , DEF_N_ITEM_COLIMAGE , "+" , PUB_nGridImgEdited )
            endif
#endif
            SetProperty( "VentanaMain" , "GHeaFiles" , "Cell" , VentanaMain.GHeaFiles.Value , NCOLHEAEDIT , EditControlFile )
            RunParms        := US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + "_" + PUB_cSecu + "RP" + US_DateTimeCen() + ".cng"
            if bEditorLongName
               cLineCmd := "COMMAND " + Editor + " " + ChgPathToReal( GetProperty( "VentanaMain" , "GHeaFiles" , "Cell" , VentanaMain.GHeaFiles.Value , NCOLHEAFULLNAME ) )
            else
               cLineCmd := "COMMAND " + Editor + " " + US_ShortName( ChgPathToReal( GetProperty( "VentanaMain" , "GHeaFiles" , "Cell" , VentanaMain.GHeaFiles.Value , NCOLHEAFULLNAME ) ) )
            endif
            QPM_MemoWrit( RunParms , "Run Parms for " + ChgPathToReal( GetProperty( "VentanaMain" , "GHeaFiles" , "Cell" , VentanaMain.GHeaFiles.Value , NCOLHEAFULLNAME ) ) + HB_OsNewLine() + ;
                                 cLineCmd + HB_OsNewLine() + ;
                                 "CONTROL " + EditControlFile )
            QPM_MemoWrit( EditControlFile , "Edit Control File for " + ChgPathToReal( GetProperty( "VentanaMain" , "GHeaFiles" , "Cell" , VentanaMain.GHeaFiles.Value , NCOLHEAFULLNAME ) ) )
            QPM_Execute( US_ShortName( PUB_cQPM_Folder ) + DEF_SLASH + "US_Run.exe" , "QPM " + RunParms )
         endif
      otherwise
         MsgInfo( "Invalid HeadTool in Function EditHea: "+cHeadTool )
   endcase
   if bLogActivity
      QPM_MemoWrit( PUB_cQPM_Folder+DEF_SLASH + "QPM.log" , memoread( PUB_cQPM_Folder+DEF_SLASH + "QPM.log" ) + HB_OSNewLine() + "xRefPrgHea Edit Hea " + GetProperty( "VentanaMain" , "GHeaFiles" , "Cell" , VentanaMain.GHeaFiles.Value , NCOLHEAFULLNAME ) )
   endif
Return .T.

Function QPM_EditPAN( bForceEditor )
   Local Editor , toolMake:="" , ToolAux:="EDITOR"
   Local EditControlFile , RunParms , cLineCmd
#ifdef QPM_HOTRECOVERY
   Local HotRecoveryControlFile
#endif
   if empty( bForceEditor )
      bForceEditor := .F.
   endif
   if !US_IsDirectory( PUB_cProjectFolder )
      MsgStop( "Project Folder not Found: " + PUB_cProjectFolder + '. Look at ' + PagePRG )
      Return .F.
   endif
   if !File( ChgPathToReal( GetProperty( "VentanaMain" , "GPanFiles" , "Cell" , VentanaMain.GPanFiles.Value , NCOLPANFULLNAME ) ) )
      MsgStop( "File not found !!!" )
      Return .F.
   endif
   If VentanaMain.GPanFiles.Value == 0
      Return .F.
   EndIf
   if bForceEditor
      ToolAux := "EDITOR"
   else
      if cFormTool == "AUTO"
         if us_word( toolMake := CheckMakeForm( US_ShortName( ChgPathToReal( GetProperty( "VentanaMain" , "GPanFiles" , "Cell" , VentanaMain.GPanFiles.Value , NCOLPANFULLNAME ) ) ) ) , 1 ) == "UNKNOWN"
            ToolAux := "EDITOR"
         else
            ToolAux := US_Word( toolMake , 1 )
            if ToolAux == "IDE"    /* Todavia no soportada */
               ToolAux := "HMGSIDE"    /* Todavia no soportada */
            endif
         endif
      else
         ToolAux := cFormTool
      endif
   endif
   do case
      case ToolAux == "EDITOR"
         If Empty ( Gbl_TEditor )
            MyMsg( 'Operation Aborted', US_VarToStr( 'Folder for Editor Not Completed. Look at ' + PUB_MenuGblOptions + ' of Settings menu.' ) , "E" , bAutoExit )
            Return .F.
         Else
            if !File( alltrim( Gbl_TEditor ) )
               MsgStop( "Program Editor not Found: "+alltrim( Gbl_TEditor )+'. Look at ' + PUB_MenuGblOptions + ' of Settings menu.' )
               Return .F.
            endif
            Editor := US_ShortName( alltrim( Gbl_TEditor ) )
         EndIf
         if bSuspendControlEdit
            if bEditorLongName
               cLineCmd := ChgPathToReal( GetProperty( "VentanaMain" , "GPanFiles" , "Cell" , VentanaMain.GPanFiles.Value , NCOLPANFULLNAME ) )
            else
               cLineCmd := US_ShortName( ChgPathToReal( GetProperty( "VentanaMain" , "GPanFiles" , "Cell" , VentanaMain.GPanFiles.Value , NCOLPANFULLNAME ) ) )
            endif
            QPM_Execute( Editor , cLineCmd )
         else
            if GridImage( "VentanaMain" , "GPanFiles" , VentanaMain.GPanFiles.Value , NCOLPANSTATUS , "?" , PUB_nGridImgEdited )
               MsgInfo( "Already Opened" )
               Return .F.
            endif
            GridImage( "VentanaMain" , "GPanFiles" , VentanaMain.GPanFiles.Value , NCOLPANSTATUS , "+" , PUB_nGridImgEdited )
            VentanaMain.RichEditPan.BackColor := DEF_COLORBACKEXTERNALEDIT
            VentanaMain.RichEditPan.FontColor := DEF_COLORFONTEXTERNALEDIT
            EditControlFile := US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + "_" + PUB_cSecu + "ECF" + US_DateTimeCen() + ".cnt"
#ifdef QPM_HOTRECOVERY
            HotRecoveryControlFile := US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + "_" + PUB_cSecu + "PanHOTRecovery" + US_DateTimeCen() + ".hot"
            US_FileCopy( ChgPathToReal( GetProperty( "VentanaMain" , "GPanFiles" , "Cell" , VentanaMain.GPanFiles.Value , NCOLPANFULLNAME ) ) , HotRecoveryControlFile )
            SetFDaTi( HotRecoveryControlFile , US_FileDate( ChgPathToReal( GetProperty( "VentanaMain" , "GPanFiles" , "Cell" , VentanaMain.GPanFiles.Value , NCOLPANFULLNAME ) ) ) , US_FileTime( ChgPathToReal( GetProperty( "VentanaMain" , "GPanFiles" , "Cell" , VentanaMain.GPanFiles.Value , NCOLPANFULLNAME ) ) ) )
            SetProperty( "VentanaMain" , "GPanFiles" , "Cell" , VentanaMain.GPanFiles.Value , NCOLPANRECOVERY , HotRecoveryControlFile )
            if _IsControlDefined( "HR_GridItemTargetPan" , "WinHotRecovery" )
               GridImage( "WinHotRecovery" , "HR_GridItemTargetPan" , GetProperty( "VentanaMain" , "GPanFiles" , "Value" ) , DEF_N_ITEM_COLIMAGE , "+" , PUB_nGridImgEdited )
            endif
#endif
            SetProperty( "VentanaMain" , "GPanFiles" , "Cell" , VentanaMain.GPanFiles.Value , NCOLPANEDIT , EditControlFile )
            RunParms        := US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + "_" + PUB_cSecu + "RP" + US_DateTimeCen() + ".cng"
            if bEditorLongName
               cLineCmd := "COMMAND " + Editor + " " + ChgPathToReal( GetProperty( "VentanaMain" , "GPanFiles" , "Cell" , VentanaMain.GPanFiles.Value , NCOLPANFULLNAME ) )
            else
               cLineCmd := "COMMAND " + Editor + " " + US_ShortName( ChgPathToReal( GetProperty( "VentanaMain" , "GPanFiles" , "Cell" , VentanaMain.GPanFiles.Value , NCOLPANFULLNAME ) ) )
            endif
            QPM_MemoWrit( RunParms , "Run Parms for " + ChgPathToReal( GetProperty( "VentanaMain" , "GPanFiles" , "Cell" , VentanaMain.GPanFiles.Value , NCOLPANFULLNAME ) ) + HB_OsNewLine() + ;
                                 cLineCmd + HB_OsNewLine() + ;
                                 "CONTROL " + EditControlFile )
            QPM_MemoWrit( EditControlFile , "Edit Control File for " + ChgPathToReal( GetProperty( "VentanaMain" , "GPanFiles" , "Cell" , VentanaMain.GPanFiles.Value , NCOLPANFULLNAME ) ) )
            QPM_Execute( US_ShortName( PUB_cQPM_Folder ) + DEF_SLASH + "US_Run.exe" , "QPM " + RunParms )
         endif
      case ToolAux == "HMI"
         if GridImage( "VentanaMain" , "GPanFiles" , VentanaMain.GPanFiles.Value , NCOLPANSTATUS , "?" , PUB_nGridImgEdited )
            MsgInfo( "Already Opened" )
            Return .F.
         endif
         If Empty ( Gbl_Text_HMI )
            MyMsg( 'Operation Aborted', US_VarToStr( 'Folder for Form Tool Not Completed. Look at ' + PUB_MenuGblOptions + ' of Settings menu.' ) , "E" , bAutoExit )
            Return .F.
         Else
            if !File( alltrim( Gbl_Text_HMI ) )
               MsgStop( "Form Tool not Found: "+alltrim( Gbl_Text_HMI )+'. Look at ' + PUB_MenuGblOptions + ' of Settings menu.' )
               Return .F.
            endif
            Editor := US_ShortName( alltrim( Gbl_Text_HMI ) )
         EndIf
         if !( us_word( toolMake := CheckMakeForm( US_ShortName( ChgPathToReal( GetProperty( "VentanaMain" , "GPanFiles" , "Cell" , VentanaMain.GPanFiles.Value , NCOLPANFULLNAME ) ) ) ) , 1 ) == "HMI" )
            if US_Upper( US_Word( toolMake , 1 ) ) == "UNKNOWN"
               if ! MyMsgYesNo("Form was builder with tool '"+toolMake+"', do you want to edit with 'HMI+'?" )
                  Return .F.
               endif
            else
               MsgStop("Form was builded with tool '"+toolMake+"', the selected tool 'HMI+' is not compatibility with '"+toolMake+"'" )
               Return .F.
            endif
         endif
         GridImage( "VentanaMain" , "GPanFiles" , VentanaMain.GPanFiles.Value , NCOLPANSTATUS , "+" , PUB_nGridImgEdited )
         VentanaMain.RichEditPan.BackColor := DEF_COLORBACKEXTERNALEDIT
         VentanaMain.RichEditPan.FontColor := DEF_COLORFONTEXTERNALEDIT
         EditControlFile := US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + "_" + PUB_cSecu + "ECF" + US_DateTimeCen() + ".cnt"
#ifdef QPM_HOTRECOVERY
         HotRecoveryControlFile := US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + "_" + PUB_cSecu + "PanHOTRecovery" + US_DateTimeCen() + ".hot"
         US_FileCopy( ChgPathToReal( GetProperty( "VentanaMain" , "GPanFiles" , "Cell" , VentanaMain.GPanFiles.Value , NCOLPANFULLNAME ) ) , HotRecoveryControlFile )
         SetFDaTi( HotRecoveryControlFile , US_FileDate( ChgPathToReal( GetProperty( "VentanaMain" , "GPanFiles" , "Cell" , VentanaMain.GPanFiles.Value , NCOLPANFULLNAME ) ) ) , US_FileTime( ChgPathToReal( GetProperty( "VentanaMain" , "GPanFiles" , "Cell" , VentanaMain.GPanFiles.Value , NCOLPANFULLNAME ) ) ) )
         SetProperty( "VentanaMain" , "GPanFiles" , "Cell" , VentanaMain.GPanFiles.Value , NCOLPANRECOVERY , HotRecoveryControlFile )
         if _IsControlDefined( "HR_GridItemTargetPan" , "WinHotRecovery" )
            GridImage( "WinHotRecovery" , "HR_GridItemTargetPan" , GetProperty( "VentanaMain" , "GPanFiles" , "Value" ) , DEF_N_ITEM_COLIMAGE , "+" , PUB_nGridImgEdited )
         endif
#endif
         SetProperty( "VentanaMain" , "GPanFiles" , "Cell" , VentanaMain.GPanFiles.Value , NCOLPANEDIT , EditControlFile )
         RunParms        := US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + "_" + PUB_cSecu + "RP" + US_DateTimeCen() + ".cng"
         cLineCmd := "COMMAND " + Editor + " " + US_ShortName( US_FileNameOnlyPath( ChgPathToReal( GetProperty( "VentanaMain" , "GPanFiles" , "Cell" , VentanaMain.GPanFiles.Value , NCOLPANFULLNAME ) ) ) ) + DEF_SLASH + US_FileNameOnlyName( ChgPathToReal( GetProperty( "VentanaMain" , "GPanFiles" , "Cell" , VentanaMain.GPanFiles.Value , NCOLPANFULLNAME ) ) )
         QPM_MemoWrit( RunParms , "Run Parms for " + ChgPathToReal( GetProperty( "VentanaMain" , "GPanFiles" , "Cell" , VentanaMain.GPanFiles.Value , NCOLPANFULLNAME ) ) + HB_OsNewLine() + ;
                              cLineCmd + HB_OsNewLine() + ;
                              "CONTROL " + EditControlFile )
         QPM_MemoWrit( EditControlFile , "Edit Control File for " + ChgPathToReal( GetProperty( "VentanaMain" , "GPanFiles" , "Cell" , VentanaMain.GPanFiles.Value , NCOLPANFULLNAME ) ) )
         QPM_Execute( US_ShortName( PUB_cQPM_Folder ) + DEF_SLASH + "US_Run.exe" , "QPM " + RunParms )
      case ToolAux == "HMGSIDE"
         if GridImage( "VentanaMain" , "GPanFiles" , VentanaMain.GPanFiles.Value , NCOLPANSTATUS , "?" , PUB_nGridImgEdited )
            MsgInfo( "Already Opened" )
            Return .F.
         endif
         If Empty ( Gbl_Text_HMGSIDE )
            MyMsg( 'Operation Aborted', US_VarToStr( 'Folder for Form Tool Not Completed. Look at ' + PUB_MenuGblOptions + ' of Settings menu.' ) , "E" , bAutoExit )
            Return .F.
         Else
            if !File( alltrim( Gbl_Text_HMGSIDE ) )
               MsgStop( "Form Tool not Found: "+alltrim( Gbl_Text_HMGSIDE )+'. Look at ' + PUB_MenuGblOptions + ' of Settings menu.' )
               Return .F.
            endif
            Editor := US_ShortName( alltrim( Gbl_Text_HMGSIDE ) )
         EndIf
         if !( us_word( toolMake := CheckMakeForm( US_ShortName( ChgPathToReal( GetProperty( "VentanaMain" , "GPanFiles" , "Cell" , VentanaMain.GPanFiles.Value , NCOLPANFULLNAME ) ) ) ) , 1 ) == "HMGSIDE" )
            if !( US_Upper( US_Word( toolMake , 1 ) ) == "HMI" )
               if ! MyMsgYesNo("Form was builder with tool '"+toolMake+"', do you want edit with 'HMGSIDE'?" )
                  Return .F.
               endif
            else
               MsgStop("Form was builded with tool '"+toolMake+"', the selected tool 'HMGSIDE' is not compatibility with '"+toolMake+"'" )
               Return .F.
            endif
         endif
         GridImage( "VentanaMain" , "GPanFiles" , VentanaMain.GPanFiles.Value , NCOLPANSTATUS , "+" , PUB_nGridImgEdited )
         VentanaMain.RichEditPan.BackColor := DEF_COLORBACKEXTERNALEDIT
         VentanaMain.RichEditPan.FontColor := DEF_COLORFONTEXTERNALEDIT
         EditControlFile := US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + "_" + PUB_cSecu + "ECF" + US_DateTimeCen() + ".cnt"
#ifdef QPM_HOTRECOVERY
         HotRecoveryControlFile := US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + "_" + PUB_cSecu + "PanHOTRecovery" + US_DateTimeCen() + ".hot"
         US_FileCopy( ChgPathToReal( GetProperty( "VentanaMain" , "GPanFiles" , "Cell" , VentanaMain.GPanFiles.Value , NCOLPANFULLNAME ) ) , HotRecoveryControlFile )
         SetFDaTi( HotRecoveryControlFile , US_FileDate( ChgPathToReal( GetProperty( "VentanaMain" , "GPanFiles" , "Cell" , VentanaMain.GPanFiles.Value , NCOLPANFULLNAME ) ) ) , US_FileTime( ChgPathToReal( GetProperty( "VentanaMain" , "GPanFiles" , "Cell" , VentanaMain.GPanFiles.Value , NCOLPANFULLNAME ) ) ) )
         SetProperty( "VentanaMain" , "GPanFiles" , "Cell" , VentanaMain.GPanFiles.Value , NCOLPANRECOVERY , HotRecoveryControlFile )
         if _IsControlDefined( "HR_GridItemTargetPan" , "WinHotRecovery" )
            GridImage( "WinHotRecovery" , "HR_GridItemTargetPan" , GetProperty( "VentanaMain" , "GPanFiles" , "Value" ) , DEF_N_ITEM_COLIMAGE , "+" , PUB_nGridImgEdited )
         endif
#endif
         SetProperty( "VentanaMain" , "GPanFiles" , "Cell" , VentanaMain.GPanFiles.Value , NCOLPANEDIT , EditControlFile )
         RunParms        := US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + "_" + PUB_cSecu + "RP" + US_DateTimeCen() + ".cng"
         cLineCmd := "COMMAND " + Editor + " " + US_ShortName( US_FileNameOnlyPath( ChgPathToReal( GetProperty( "VentanaMain" , "GPanFiles" , "Cell" , VentanaMain.GPanFiles.Value , NCOLPANFULLNAME ) ) ) ) + DEF_SLASH + US_FileNameOnlyName( ChgPathToReal( GetProperty( "VentanaMain" , "GPanFiles" , "Cell" , VentanaMain.GPanFiles.Value , NCOLPANFULLNAME ) ) )
         QPM_MemoWrit( RunParms , "Run Parms for " + ChgPathToReal( GetProperty( "VentanaMain" , "GPanFiles" , "Cell" , VentanaMain.GPanFiles.Value , NCOLPANFULLNAME ) ) + HB_OsNewLine() + ;
                              cLineCmd + HB_OsNewLine() + ;
                              "DEFAULTPATH " + US_FileNameOnlyPath( Editor ) + HB_OsNewLine() + ;
                              "CONTROL " + EditControlFile )
         QPM_MemoWrit( EditControlFile , "Edit Control File for " + ChgPathToReal( GetProperty( "VentanaMain" , "GPanFiles" , "Cell" , VentanaMain.GPanFiles.Value , NCOLPANFULLNAME ) ) )
         QPM_Execute( US_ShortName( PUB_cQPM_Folder ) + DEF_SLASH + "US_Run.exe" , "QPM " + RunParms )
      otherwise
         MsgInfo( "Invalid FormTool in Function EditPan: "+ToolAux )
   endcase
   if bLogActivity
      QPM_MemoWrit( PUB_cQPM_Folder+DEF_SLASH + "QPM.log" , memoread( PUB_cQPM_Folder+DEF_SLASH + "QPM.log" ) + HB_OSNewLine() + "xRefPrgFmg Edit Form " + GetProperty( "VentanaMain" , "GPanFiles" , "Cell" , VentanaMain.GPanFiles.Value , NCOLPANFULLNAME ) )
   endif
Return .T.

Function QPM_EditDBF()
   Local EditControlFile , RunParms , cLineCmd
   if GridImage( "VentanaMain" , "GDbfFiles" , VentanaMain.GDbfFiles.Value , NCOLDBFSTATUS , "?" , PUB_nGridImgEdited )
      MsgInfo( "Already Opened" )
      Return .F.
   endif
   if !US_IsDirectory( PUB_cProjectFolder )
      MsgStop( "Project Folder not Found: " + PUB_cProjectFolder + '. Look at ' + PagePRG )
      Return .F.
   endif
   if !File( ChgPathToReal( GetProperty( "VentanaMain" , "GDbfFiles" , "Cell" , VentanaMain.GDbfFiles.Value , NCOLDBFFULLNAME ) ) )
      MsgStop( "File not found !!!" )
      Return .F.
   endif
   If VentanaMain.GDbfFiles.Value == 0
      Return .F.
   EndIf
   do case
      case cDbfTool == "OTHER"
         If Empty ( Gbl_Text_DBF )
            MyMsg( 'Operation Aborted', US_VarToStr( 'Folder for Dbf Tool Not Completed. Look at ' + PUB_MenuGblOptions + ' of Settings menu.' ) , "E" , bAutoExit )
            Return .F.
         Else
            if !File( alltrim( Gbl_Text_DBF ) )
               MsgStop( "Dbf Tool not Found: "+alltrim( Gbl_Text_DBF )+'. Look at ' + PUB_MenuGblOptions + ' of Settings menu.' )
               Return .F.
            endif
            Editor := US_ShortName( alltrim( Gbl_Text_DBF ) )
         EndIf
         GridImage( "VentanaMain" , "GDbfFiles" , VentanaMain.GDbfFiles.Value , NCOLDBFSTATUS , "+" , PUB_nGridImgEdited )
         VentanaMain.RichEditDbf.BackColor := DEF_COLORBACKEXTERNALEDIT
         VentanaMain.RichEditDbf.FontColor := DEF_COLORFONTEXTERNALEDIT
         CloseDbfAutoView()
         DefineRichEditForNotDbfView( "DBF Open with external tool !!!" )
         EditControlFile := US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + "_" + PUB_cSecu + "ECF" + US_DateTimeCen() + ".cnt"
         SetProperty( "VentanaMain" , "GDbfFiles" , "Cell" , VentanaMain.GDbfFiles.Value , NCOLDBFEDIT , EditControlFile )
         RunParms        := US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + "_" + PUB_cSecu + "RP" + US_DateTimeCen() + ".cng"
         cLineCmd := "COMMAND " + Editor + ' ' + Gbl_Comillas_DBF + US_ShortName( US_FileNameOnlyPath( ChgPathToReal( GetProperty( "VentanaMain" , "GDbfFiles" , "Cell" , VentanaMain.GDbfFiles.Value , NCOLDBFFULLNAME ) ) ) ) + DEF_SLASH + US_FileNameOnlyNameAndExt( ChgPathToReal( GetProperty( "VentanaMain" , "GDbfFiles" , "Cell" , VentanaMain.GDbfFiles.Value , NCOLDBFFULLNAME ) ) ) + Gbl_Comillas_DBF
         QPM_MemoWrit( RunParms , "Run Parms for " + ChgPathToReal( GetProperty( "VentanaMain" , "GDbfFiles" , "Cell" , VentanaMain.GDbfFiles.Value , NCOLDBFFULLNAME ) ) + HB_OsNewLine() + ;
                              cLineCmd + HB_OsNewLine() + ;
                              "CONTROL " + EditControlFile )
         QPM_MemoWrit( EditControlFile , "Edit Control File for " + ChgPathToReal( GetProperty( "VentanaMain" , "GDbfFiles" , "Cell" , VentanaMain.GDbfFiles.Value , NCOLDBFFULLNAME ) ) )
         QPM_Execute( US_ShortName( PUB_cQPM_Folder ) + DEF_SLASH + "US_Run.exe" , "QPM " + RunParms )
      case cDbfTool == "DBFVIEW"
         GridImage( "VentanaMain" , "GDbfFiles" , VentanaMain.GDbfFiles.Value , NCOLDBFSTATUS , "+" , PUB_nGridImgEdited )
         VentanaMain.RichEditDbf.BackColor := DEF_COLORBACKEXTERNALEDIT
         VentanaMain.RichEditDbf.FontColor := DEF_COLORFONTEXTERNALEDIT
         CloseDbfAutoView()
         DefineRichEditForNotDbfView( "DBF Open with external tool !!!" )
         Editor := US_ShortName( alltrim( PUB_cQPM_Folder ) ) + DEF_SLASH + "US_DBFVIEW.exe"
         EditControlFile := US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + "_" + PUB_cSecu + "ECF" + US_DateTimeCen() + ".cnt"
         SetProperty( "VentanaMain" , "GDbfFiles" , "Cell" , VentanaMain.GDbfFiles.Value , NCOLDBFEDIT , EditControlFile )
         RunParms        := US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + "_" + PUB_cSecu + "RP" + US_DateTimeCen() + ".cng"
         cLineCmd := "COMMAND " + Editor + " " + US_ShortName( US_FileNameOnlyPath( ChgPathToReal( GetProperty( "VentanaMain" , "GDbfFiles" , "Cell" , VentanaMain.GDbfFiles.Value , NCOLDBFFULLNAME ) ) ) ) + DEF_SLASH + US_FileNameOnlyNameAndExt( ChgPathToReal( GetProperty( "VentanaMain" , "GDbfFiles" , "Cell" , VentanaMain.GDbfFiles.Value , NCOLDBFFULLNAME ) ) )
         QPM_MemoWrit( RunParms , "Run Parms for " + ChgPathToReal( GetProperty( "VentanaMain" , "GDbfFiles" , "Cell" , VentanaMain.GDbfFiles.Value , NCOLDBFFULLNAME ) ) + HB_OsNewLine() + ;
                              cLineCmd + HB_OsNewLine() + ;
                              "CONTROL " + EditControlFile )
         QPM_MemoWrit( EditControlFile , "Edit Control File for " + ChgPathToReal( GetProperty( "VentanaMain" , "GDbfFiles" , "Cell" , VentanaMain.GDbfFiles.Value , NCOLDBFFULLNAME ) ) )
         QPM_Execute( US_ShortName( PUB_cQPM_Folder ) + DEF_SLASH + "US_Run.exe" , "QPM " + RunParms )
      case cDbfTool == "DBU"
         GridImage( "VentanaMain" , "GDbfFiles" , VentanaMain.GDbfFiles.Value , NCOLDBFSTATUS , "+" , PUB_nGridImgEdited )
         VentanaMain.RichEditDbf.BackColor := DEF_COLORBACKEXTERNALEDIT
         VentanaMain.RichEditDbf.FontColor := DEF_COLORFONTEXTERNALEDIT
    //   if GridImage( "VentanaMain" , "GDbfFiles" , VentanaMain.GDbfFiles.Value , NCOLDBFSTATUS , "?" , PUB_nGridImgSearchOk )
    //      TotCaption( "DBF" , -1 )
    //   endif
         CloseDbfAutoView()
         DefineRichEditForNotDbfView( "DBF Open with external tool !!!" )
         Editor := US_ShortName( alltrim( PUB_cQPM_Folder ) ) + DEF_SLASH + "US_DBU.exe"
         EditControlFile := US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + "_" + PUB_cSecu + "ECF" + US_DateTimeCen() + ".cnt"
         SetProperty( "VentanaMain" , "GDbfFiles" , "Cell" , VentanaMain.GDbfFiles.Value , NCOLDBFEDIT , EditControlFile )
         RunParms        := US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + "_" + PUB_cSecu + "RP" + US_DateTimeCen() + ".cng"
         cLineCmd := "COMMAND " + Editor + " " + US_ShortName( US_FileNameOnlyPath( ChgPathToReal( GetProperty( "VentanaMain" , "GDbfFiles" , "Cell" , VentanaMain.GDbfFiles.Value , NCOLDBFFULLNAME ) ) ) ) + DEF_SLASH + US_FileNameOnlyNameAndExt( ChgPathToReal( GetProperty( "VentanaMain" , "GDbfFiles" , "Cell" , VentanaMain.GDbfFiles.Value , NCOLDBFFULLNAME ) ) )
         QPM_MemoWrit( RunParms , "Run Parms for " + ChgPathToReal( GetProperty( "VentanaMain" , "GDbfFiles" , "Cell" , VentanaMain.GDbfFiles.Value , NCOLDBFFULLNAME ) ) + HB_OsNewLine() + ;
                              cLineCmd + HB_OsNewLine() + ;
                              "CONTROL " + EditControlFile )
         QPM_MemoWrit( EditControlFile , "Edit Control File for " + ChgPathToReal( GetProperty( "VentanaMain" , "GDbfFiles" , "Cell" , VentanaMain.GDbfFiles.Value , NCOLDBFFULLNAME ) ) )
         QPM_Execute( US_ShortName( PUB_cQPM_Folder ) + DEF_SLASH + "US_Run.exe" , "QPM " + RunParms )
      otherwise
         MsgInfo( "Invalid DbfTool in Function EditDbf: "+cDbfTool )
   endcase
   if bLogActivity
      QPM_MemoWrit( PUB_cQPM_Folder+DEF_SLASH + "QPM.log" , memoread( PUB_cQPM_Folder+DEF_SLASH + "QPM.log" ) + HB_OSNewLine() + "xRefPrgFmg Edit Dbf " + GetProperty( "VentanaMain" , "GDbfFiles" , "Cell" , VentanaMain.GDbfFiles.Value , NCOLDBFFULLNAME ) )
   endif
Return .T.

#ifdef QPM_SHG
Function QPM_EditHLP()
   Local cAuxTopic := "" , cAuxNick
   if VentanaMain.GHlpFiles.Value == 1
      MsgInfo( "Global foot can't be edited, it's a system Topic !!!" )
      Return .T.
   endif
   if VentanaMain.GHlpFiles.Value > 1
   // cAuxTopic := InputBox( "Topic:" , "Topic Name" ,  )
      cAuxTopic := alltrim( GetProperty( "VentanaMain" , "GHlpFiles" , "Cell" , VentanaMain.GHlpFiles.Value , NCOLHLPTOPIC ) )
      cAuxNick  := alltrim( GetProperty( "VentanaMain" , "GHlpFiles" , "Cell" , VentanaMain.GHlpFiles.Value , NCOLHLPNICK ) )
      if SHG_InputTopic( @cAuxTopic , @cAuxNick )
         SetProperty( "VentanaMain" , "GHlpFiles" , "Cell" , VentanaMain.GHlpFiles.Value , NCOLHLPTOPIC , cAuxTopic )
         SetProperty( "VentanaMain" , "GHlpFiles" , "Cell" , VentanaMain.GHlpFiles.Value , NCOLHLPNICK , cAuxNick )
         DoMethod( "VentanaMain" , "GHlpFiles" , "ColumnsAutoFitH" )
         SHG_SetField( "SHG_TOPICT" , VentanaMain.GHlpFiles.Value , cAuxTopic )
         SHG_SetField( "SHG_NICKT"  , VentanaMain.GHlpFiles.Value , cAuxNick )
         if !( alltrim( cAuxTopic ) == SHG_GetField( "SHG_TOPIC" , VentanaMain.GHlpFiles.Value ) ) .or. ;
            !( alltrim( cAuxTopic ) == SHG_GetField( "SHG_TOPIC" , VentanaMain.GHlpFiles.Value ) )
            SetProperty( "VentanaMain" , "GHlpFiles" , "Cell" , VentanaMain.GHlpFiles.Value , NCOLHLPEDIT , "D" )
         endif
      endif
   endif
Return .T.
#endif

#ifdef QPM_SHG
Function QPM_EditKeyHLP()
   Local cAux := "" , MemoAux := "" , i
   if VentanaMain.GHlpKeys.Value > 0
      cAux := InputBox( "Key:" , "Keys for Help" , alltrim( VentanaMain.GHlpKeys.Cell( VentanaMain.GHlpKeys.Value , 1 ) ) )
      if !empty( cAux )
         VentanaMain.GHlpKeys.Cell( VentanaMain.GHlpKeys.Value , 1 ) := cAux
         DoMethod( "VentanaMain" , "GHlpKeys" , "ColumnsAutoFitH" )
         For i:=1 to VentanaMain.GHlpKeys.ItemCount
            MemoAux := MemoAux + if( i > 1 , HB_OsNewLine() , "" ) + VentanaMain.GHlpKeys.Cell( i , 1 )
         Next
         SHG_SetField( "SHG_KEYST" , VentanaMain.GHlpFiles.Value , MemoAux )
      endif
   endif
Return .T.
#endif

Function QPM_EditRES
   Local Editor , FileRC
   if !US_IsDirectory( PUB_cProjectFolder )
      MsgStop( "Project Folder not Found: " + PUB_cProjectFolder + '. Look at ' + PagePRG )
      Return .T.
   endif
   if VentanaMain.GPrgFiles.ItemCount = 0
      MsgStop( "Top file for project not defined.  Look at " + PagePRG )
      Return .T.
   endif
   do case
      case cResTool == "EDITOR"
         If Empty ( Gbl_TEditor )
            MyMsg( 'Operation Aborted', US_VarToStr( 'Folder for Editor Not Completed. Look at ' + PUB_MenuGblOptions + ' of Settings menu.' ) , "E" , bAutoExit )
            Return .T.
         Else
            if !File( alltrim( Gbl_TEditor ) )
               MsgStop( "Program Editor not Found: "+alltrim( Gbl_TEditor )+'. Look at ' + PUB_MenuGblOptions + ' of Settings menu.' )
               Return .T.
            endif
            Editor := US_ShortName( alltrim( Gbl_TEditor ) )
         EndIf
         FileRC := US_FileNameOnlyPathAndName( ChgPathToReal( GetProperty( "VentanaMain" , "GPrgFiles" , "Cell" , 1 , NCOLPRGFULLNAME ) ) ) + ".RC"
         if !File( FileRC )
            if MyMsgYesNo( "Resource File not Found: "+FileRC+HB_OsNewLine()+"Do you want create an empty file ?" )
               QPM_MemoWrit( FileRC , "MAIN ICON     ."+DEF_SLASH+"RESOURCES"+DEF_SLASH+"MAIN.ICO" )
            else
               Return .F.
            endif
         endif
         QPM_Execute( Editor , if( bEditorLongName , FileRC , US_ShortName( FileRC ) ) )
      otherwise
         MsgInfo( "invalid Resource Tool in Function QPM_EditRES: "+cResTool )
   endcase
Return .T.

Function QPM_SetTopPRG
   Local i , vTop , vLine
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
   MsgInfo ( ChgPathToReal( vLine[NCOLPRGFULLNAME] ) + ' Is The New Project Top File.' )
   CambioTitulo()
Return .T.

Function QPM_GetFilesPRG()
   Local RetVal := {} , BaseFolder , cAux
   If Empty ( PUB_cProjectFolder )
      MsgStop('You must select project base folder first. Look at ' + PagePRG)
      Return ( {} )
   EndIf
   if Prj_Radio_OutputType == DEF_RG_IMPORT .and. GetProperty( "VentanaMain" , "GPrgFiles" , "itemcount" ) > 0
      MsgStop('Process to make Interface Library allow only one source')
      Return ( {} )
   endif
   if GetProperty( "VentanaMain" , "GPrgFiles" , "Value" ) = 0
      BaseFolder := PUB_cProjectFolder
   else
      BaseFolder := US_FileNameOnlyPath( ChgPathToReal( GetProperty( "VentanaMain" , "GPrgFiles" , "Cell" , GetProperty( "VentanaMain" , "GPrgFiles" , "Value" ) , NCOLPRGFULLNAME ) ) )
   endif
   If !( right(Basefolder,1) == DEF_SLASH )
      BaseFolder := BaseFolder + DEF_SLASH
   EndIf
   if Prj_Radio_OutputType == DEF_RG_IMPORT
      cAux := BugGetFile( { {'DLL file','*.DLL'} } , "Select Input Files" , BaseFolder , .F. , .T. )
      if !empty( cAux )
         aadd( RetVal , cAux )
      endif
   else
      RetVal := US_GetFile( { {'Source files (prg,c,cpp)','*.prg;*.c;*.cpp'} , {'Only PRG files','*.prg'} , {'Only C files','*.C'} , {'Only C++ files','*.CPP'} , {'Only C and C++ files','*.C;*.CPP'} } , "Select Source or Input Files" , BaseFolder , .T. , .T. )
   endif
Return RetVal

Function QPM_GetFilesHEA()
   Local RetVal := {} , BaseFolder , i
   If Empty ( PUB_cProjectFolder )
      MsgStop('You must select project base folder first. Look at ' + PUB_MenuGblOptions + ' of Settings menu.')
      Return ( {} )
   EndIf
   BaseFolder := PUB_cProjectFolder
   if GetProperty( "VentanaMain" , "GHeaFiles" , "Value" ) = 0
      BaseFolder := PUB_cProjectFolder
   else
      BaseFolder := US_FileNameOnlyPath( ChgPathToReal( GetProperty( "VentanaMain" , "GHeaFiles" , "Cell" , GetProperty( "VentanaMain" , "GHeaFiles" , "Value" ) , NCOLHEAFULLNAME ) ) )
   endif
   If !( right(Basefolder,1) == DEF_SLASH )
      BaseFolder := BaseFolder + DEF_SLASH
   EndIf
Return US_GetFile( { {'Headers files (*.h and *.ch)','*.h;*.ch'} } , "Select Headers Files" , BaseFolder , .T. , .T. )

Function QPM_GetFilesPAN()
   Local RetVal := {} , BaseFolder
   If Empty ( PUB_cProjectFolder )
      MsgStop('You must select project base folder first. Look at ' + PUB_MenuGblOptions + ' of Settings menu.')
      Return ( {} )
   EndIf
   BaseFolder := PUB_cProjectFolder
   if GetProperty( "VentanaMain" , "GPanFiles" , "Value" ) = 0
      BaseFolder := PUB_cProjectFolder
   else
      BaseFolder := US_FileNameOnlyPath( ChgPathToReal( GetProperty( "VentanaMain" , "GPanFiles" , "Cell" , GetProperty( "VentanaMain" , "GPanFiles" , "Value" ) , NCOLPANFULLNAME ) ) )
   endif
   If !( right(Basefolder,1) == DEF_SLASH )
      BaseFolder := BaseFolder + DEF_SLASH
   EndIf
Return US_GetFile( { {'Forms files (*.FMG)','*.fmg'} } , "Select Forms Files" , BaseFolder , .T. , .T. )

Function QPM_GetFilesDBF()
   Local RetVal := {} , BaseFolder
   If Empty ( PUB_cProjectFolder )
      MsgStop('You must select project base folder first. Look at ' + PUB_MenuGblOptions + ' of Settings menu.')
      Return ( {} )
   EndIf
   BaseFolder := PUB_cProjectFolder
   if GetProperty( "VentanaMain" , "GDbfFiles" , "Value" ) = 0
      BaseFolder := PUB_cProjectFolder
   else
      BaseFolder := US_FileNameOnlyPath( ChgPathToReal( GetProperty( "VentanaMain" , "GDbfFiles" , "Cell" , GetProperty( "VentanaMain" , "GDbfFiles" , "Value" ) , NCOLDBFFULLNAME ) ) )
   endif
   If !( right(Basefolder,1) == DEF_SLASH )
      BaseFolder := BaseFolder + DEF_SLASH
   EndIf
Return US_GetFile( { {"Dbf's files (*.DBF)",'*.dbf'} } , "Select Dbf's Files" , BaseFolder , .T. , .T. )

Function QPM_GetExcludeFilesLIB()
   local RetVal := {}
   local vAux
   QPM_CargoLibraries()
   vAux := array( len( &( 'vLibDefault'+GetSuffix() ) ) )
   If Empty ( PUB_cProjectFolder )
      MsgStop('You must open project first')
      Return ( {} )
   EndIf
   aCopy( &( 'vLibDefault'+GetSuffix() ) , vAux )
   if bConsole
      aadd( vAux , GetMiniGuiName() )
   endif
   aSort( vAux ,,, { |x, y| US_Upper(x) < US_Upper(y) })
   DEFINE WINDOW GetExcludeLibFiles ;
           AT 0,0 ;
           WIDTH 310 HEIGHT 390 ;
           TITLE 'Select Library for exclude' ;
           MODAL FONT 'Arial' SIZE 9

           DEFINE LISTBOX List_1
                   ITEMS           vAux
                   ROW             10
                   COL             10
                   WIDTH           280
                   HEIGHT          300
                   MULTISELECT     .T.
           END LISTBOX
           DEFINE BUTTON OK
                   ROW 320
                   COL 45
                   CAPTION 'Ok'
                   ONCLICK ( RetVal := QPM_GetExcludeFilesOkLIB( vAux , GetExcludeLibFiles.List_1.Value ) , DoMethod( "GetExcludeLibFiles" , "Release" ) )
           END BUTTON
           DEFINE BUTTON CANCEL
                   ROW 320
                   COL 160
                   CAPTION 'Cancel'
                   ONCLICK ( RetVal := {} , DoMethod( "GetExcludeLibFiles" , "Release" ) )
           END BUTTON

   END WINDOW
   CENTER WINDOW GetExcludeLibFiles
   ACTIVATE WINDOW GetExcludeLibFiles
Return ( RetVal )

Function QPM_GetExcludeFilesOkLIB( aFiles , aSelected )
   Local aNew := {} , i
   For i := 1 To Len ( aSelected )
      aadd ( aNew , aFiles [ aSelected [i] ] )
   Next i
Return aNew

Function QPM_GetFilesLIB()
   Local RetVal := {} , cFolderAux := PUB_cProjectFolder
   If Empty( PUB_cProjectFolder )
      MsgStop('You must open project first')
      Return ( {} )
   EndIf
   if US_IsDirectory( &( 'cLastLibFolder'+GetSuffix() ) )
      cFolderAux := &( 'cLastLibFolder'+GetSuffix() )
   endif
   if Prj_Radio_Cpp = DEF_RG_BORLAND .or. ;
      Prj_Radio_Cpp = DEF_RG_PELLES
      // RetVal := BugGetFile( { {'Libs for Include on concatenation (*.lib)','*.lib'} , {'Objects for Include on concatenation (*.obj)','*.obj'} } , "Libs for Include on Concatenation" , cFolderAux , .T. , .T. )
      RetVal := BugGetFile( { {'Libs and Objects for Include on concatenation (*.lib,*.obj)','*.lib;*obj'} , {'Only Libs for Include on concatenation (*.lib)','*.lib'} , {'Only Objects for Include on concatenation (*.obj)','*.obj'} } , "Libs and Objects for Include on Concatenation" , cFolderAux , .T. , .T. )
      if len(RetVal) > 0
         &( 'cLastLibFolder'+GetSuffix() ) := US_FileNameOnlyPath( RetVal[ len(RetVal) ] )
      endif
   endif
   if Prj_Radio_Cpp = DEF_RG_MINGW
      // RetVal := BugGetFile( { {'Libs for Include on concatenation (Lib*.a)','Lib*.a'} } , "Libs for Include on Concatenation" , cFolderAux , .T. , .T. )
      RetVal := BugGetFile( { {'Libs and Objects for Include on concatenation (Lib*.a,*.o)','Lib*.a;*.o'} , {'Only Libs for Include on concatenation (Lib*.a)','Lib*.a'} , {'Only Objects for Include on concatenation (*.o)','*.o'} } , "Libs and Objects for Include on Concatenation" , cFolderAux , .T. , .T. )
      if len(RetVal) > 0
         &( 'cLastLibFolder'+GetSuffix() ) := US_FileNameOnlyPath( RetVal[ len(RetVal) ] )
      endif
   endif
Return ( RetVal )

Function QPM_OpenProject( cParmProjectFileName )
   Local Temp_SHG_Database
   Local Open_ProjectExt := "*.qac;*.qpm"
   Local Open_FilesExt   := "*.prg;*.c;*.cpp;*.dll"
   Local Open_TempCreateFile := ""
// Private ConfigFile , ConfigFileName , i , Line , ConfigVersion:=0 , ConfigFileAux , bNew:=.F. , ConfigFileNameAux := {}
   Private cMemoProjectFile
   Private cMemoProjectFileAux
   Private cProjectFileName
   Private LOC_cLine
   Private ConfigVersion:=0
   Private vProjectFileNameAux := {}
   Private Open_FromFileType := ""
   Private i
   Private bNew:=.F.
#ifdef QPM_SHG
   if !( QPM_WAIT( "SHG_CheckSave()" , "Checking for save ..." ) )
      Return .F.
   endif
   if SHG_BaseOk
      if US_FileSize( US_FileNameOnlyPathAndName( SHG_Database ) + ".dbt" ) > SHG_DbSize
         QPM_Wait( 'SHG_PackDatabase()' )
      endif
   endif
#endif
   QPM_Wait( "QPM_SaveProject( .T. )" , "Checking for save..." )
   If !empty( cParmProjectFileName )
      cProjectFileName := cParmProjectFileName
      if !file( cProjectFileName )
         MsgStop( "Project file not found: "+alltrim( cProjectFileName ) )
         Return .F.
      endif
   Else
      CloseDbfAutoView()
      //Se le puso Multiselect .T. aunque no deberia porque sino aveces no funcionaba que me devolviera el nombre del
      //file cuando no existia
      vProjectFileNameAux := US_GetFile( { {'Open/Create Project ('+Open_ProjectExt+';'+Open_FilesExt+')',Open_ProjectExt+';'+Open_FilesExt} , {'Open/Create Project Files ('+Open_ProjectExt+')',Open_ProjectExt} , {'Create Project for file ('+Open_FilesExt+')',Open_FilesExt} } , 'Open or Create Project' , cLastProjectFolder , .T. , .T. )
      cProjectFileName := if( len( vProjectFileNameAux ) == 0 , "" , vProjectFileNameAux[1] )
      if !empty( cProjectFileName )
         if upper( US_FileNameOnlyExt( cProjectFileName ) ) == "QAC"
            frename( cProjectFileName , US_FileNameOnlyPathAndName( cProjectFileName ) + ".qpm" )
            cProjectFileName := US_FileNameOnlyPathAndName( cProjectFileName ) + ".qpm"
         endif
         if US_FileNameOnlyExt( cProjectFileName ) == ""
            Open_FromFileType := "QPM"
         else
            Open_FromFileType := US_Upper( US_FileNameOnlyExt( cProjectFileName ) )
         endif
         cProjectFileName := US_FileNameOnlyPathAndName( cProjectFileName ) + ".qpm"
         if !file( cProjectFileName )
            if MyMsgYesNo ('Create new project '+US_FileNameOnlyNameAndExt( cProjectFileName ) + HB_OsNewLine() + 'in ' + US_FileNAmeOnlyPath( cProjectFileName ) + '?','Create Project')
               bNew := .T.
#ifdef QPM_SHG
               Temp_SHG_Database := SHG_StrTran( SHG_GetDatabaseName( US_FileNameOnlyPathAndName(cProjectFileName) )+"_SHG.dbf" )
               if MyMsgYesNo('Create database "' + Temp_SHG_Database + '" for Simple Help Generator (SHG) ?')
                  SHG_CreateDatabase( Temp_SHG_Database )
               else
                  Temp_SHG_Database := "*NONE*"
               endif
#else
               Temp_SHG_Database := "*NONE*"
#endif
               Open_TempCreateFile := "VERSION "+PUB_cQPM_Version+" "+HB_OsNewLine()+ ;
                                      "SHGDATABASE "+Temp_SHG_Database+HB_OsNewline()
               if Open_FromFileType == "DLL"
                  Open_TempCreateFile := Open_TempCreateFile + "OUTPUTTYPE DLLLIB" + HB_OsNewLine()
               endif
//us_log( Open_FromFileType )
               if !( Open_FromFileType == "QPM" ) .and. ;
                  ( Open_FromFileType == "PRG" .or. ;
                    Open_FromFileType == "C" .or. ;
                    Open_FromFileType == "CPP" )
                  Open_TempCreateFile := Open_TempCreateFile + "SOURCE " + US_FileNameOnlyPathAndName( cProjectFileName ) + "." + lower( Open_FromFileType ) + HB_OsNewLine()
                  if !file( US_FileNameOnlyPathAndName( cProjectFileName ) + "." + lower( Open_FromFileType ) )
                     QPM_CreateNewFile( Open_FromFileType , US_FileNameOnlyPathAndName( cProjectFileName ) + "." + lower( Open_FromFileType ) )
                  endif
               endif
               if QPM_MemoWrit( cProjectFileName , Open_TempCreateFile )
                  MsgInfo( "Project " + cProjectFileName + " created success !!!" )
               else
                  MsgInfo( "ERROR in create Project " + cProjectFileName )
               endif
            else
               QPM_Wait( "RichEditDisplay( 'DBF' , .T. , , .F. )" , "Reloading..." )
               Return .F.
            endif
         endif
      else
         QPM_Wait( "RichEditDisplay( 'DBF' , .T. , , .F. )" , "DBF Reloading..." )
         Return .F.
      endif
   EndIf
   PUB_cThisFolder := US_FileNameOnlyPath( cProjectFileName )
Return QPM_Wait( "QPM_OpenProject2()" , "Opening..." )

Function QPM_OpenProject2()
   Local cForceRecomp := " " , LOC_nOpenError := 0
   DoMethod( "VentanaMain" , "GPrgFiles" , "DisableUpdate" )
   DoMethod( "VentanaMain" , "GPanFiles" , "DisableUpdate" )
   DoMethod( "VentanaMain" , "GDbfFiles" , "DisableUpdate" )
   DoMethod( "VentanaMain" , "GHeaFiles" , "DisableUpdate" )
   DoMethod( "VentanaMain" , "GIncFiles" , "DisableUpdate" )
   DoMethod( "VentanaMain" , "GExcFiles" , "DisableUpdate" )
#ifdef QPM_SHG
      DoMethod( "VentanaMain" , "GHlpFiles" , "DisableUpdate" )
#endif
   If !Empty(cProjectFileName)
      cLastProjectFolder := US_FileNameOnlyPath( cProjectFileName )
      PUB_cProjectFile := US_FileNameOnlyPathAndName( cProjectFileName ) + ".qpm"
      if PUB_bLite
         VentanaLite.Title := 'QPM ('+PUB_cQPM_VersionDisplay+') [ ' + alltrim ( cProjectFileName ) + ' ]'
      else
         VentanaMain.Title := 'QPM (QAC Based Project Manager) - Project Manager for MiniGui ('+PUB_cQPM_VersionDisplay+') [ ' + alltrim ( cProjectFileName ) + ' ]'
      endif
      VentanaMain.TProjectFolder.Value := US_FileNameOnlyPath( cProjectFileName )
      VentanaMain.TRunProjectFolder.Value := ""
      //bAutoexit := .F.
      bWarningCpp := .T.
      Prj_Radio_Harbour := DEF_RG_HARBOUR
      Prj_Check_HarbourIs31 := .T.
      * No Borrar           Prj_Check_34 := .F.
      Prj_Radio_Cpp      := DEF_RG_BORLAND
      Prj_Radio_MiniGui  := DEF_RG_OOHG3
      Prj_Radio_OutputType := DEF_RG_EXE
      Prj_Radio_OutputCopyMove := 1
      Prj_Text_OutputCopyMoveFolder := ""
      Prj_Radio_OutputRename := 1
      Prj_Text_OutputRenameNewName := ""
      cOutputType        := "SRCEXE"
      cOutputCopyMove    := "NONE"
      cOutputRename      := "NONE"
      bGlobalSearch         := .F.
      bLastGlobalSearchFun  := .F.
      bLastGlobalSearchDbf  := .F.
      VentanaMain.LGlobal.visible := .F.
      bPpoDisplayado := .F.
      SHG_Database          := ""
      SHG_DbSize            := 0
      SHG_LastFolderImg     := ""
      SHG_CheckTypeOutput   := .F.
      SHG_HtmlFolder        := ""
      SHG_WWW               := ""
      SHG_BaseOK            := .F.
      cPrj_VersionAnt       := "00000000"   // VVRRBBBB
      SetProperty( "VentanaMain" , "LVerVerNum" , "value" , Replicate( "0" , DEF_LEN_VER_VERSION ) )
      SetProperty( "VentanaMain" , "LVerRelNum" , "value" , Replicate( "0" , DEF_LEN_VER_RELEASE ) )
      SetProperty( "VentanaMain" , "LVerBuiNum" , "value" , Replicate( "0" , DEF_LEN_VER_BUILD ) )
      SetProperty( "VentanaMain" , "OverrideCompile" , "enabled" , .T. )
      SetProperty( "VentanaMain" , "OverrideLink" , "enabled" , .T. )
      SetProperty( "VentanaMain" , "OverrideCompile" , "value" , "" )
      SetProperty( "VentanaMain" , "OverrideLink" , "value" , "" )
      Prj_Radio_FormTool    := 1
      Prj_Radio_DbfTool     := 1
      Prj_ExtraRunCmdFINAL  := ""
      Prj_ExtraRunProjQPM   := ""
      Prj_ExtraRunCmdEXE    := ""
      Prj_ExtraRunCmdFREE   := ""
      Prj_ExtraRunCmdQPMParm := ""
      Prj_ExtraRunCmdEXEParm := ""
      Prj_ExtraRunCmdFREEParm := ""
      Prj_ExtraRunType        := "NONE"
      Prj_ExtraRunQPMRadio        := "BUILD"
      Prj_ExtraRunQPMLite         := .T.
      Prj_ExtraRunQPMForceFull    := .F.
      Prj_ExtraRunQPMRun          := .F.
      Prj_ExtraRunQPMButtonRun    := .F.
      Prj_ExtraRunQPMClear        := .F.
      Prj_ExtraRunQPMLog          := .F.
      Prj_ExtraRunQPMLogOnlyError := .F.
      Prj_ExtraRunQPMAutoExit     := .T.
      Prj_ExtraRunExeWait       := .T.
      Prj_ExtraRunExePause      := .T.
      Prj_ExtraRunFreeWait      := .T.
      Prj_ExtraRunFreePause := .T.
      TotCaption( "PRG" , 0 )
      TotCaption( "HEA" , 0 )
      TotCaption( "PAN" , 0 )
      TotCaption( "DBF" , 0 )
      TotCaption( "LIB" , 0 )
      TotCaption( "HEA" , 0 )
#ifdef QPM_SHG
      TotCaption( "HLP" , 0 )
#endif
      VentanaMain.GPrgFiles.DeleteAllItems
      VentanaMain.GHeaFiles.DeleteAllItems
      VentanaMain.GPanFiles.DeleteAllItems
      VentanaMain.GDbfFiles.DeleteAllItems
#ifdef QPM_SHG
      VentanaMain.GHlpFiles.DeleteAllItems
#endif
      VentanaMain.RichEditPrg.Value := ''
      VentanaMain.RichEditHea.Value := ''
      VentanaMain.RichEditPan.Value := ''
      VentanaMain.RichEditDbf.Value := ''
      VentanaMain.RichEditLib.Value := ''
#ifdef QPM_SHG
      VentanaMain.RichEditHlp.Value := ''
      oHlpRichEdit:lChanged := .F.
#endif
      VentanaMain.RichEditSysout.Value := ''
      VentanaMain.RichEditOut.Value := ''
      VentanaMain.Check_Reimp.Value := .F.
      VentanaMain.TReimportLib.Value := ""
      VentanaMain.Check_NumberOnPrg.enabled := .T.
      VentanaMain.Check_GuionA.Value := .F.
      VentanaMain.bReLoadPpo.enabled := .T.
      VentanaMain.bReLoadPrg.enabled := .T.
      bDbfAutoView      := .T.
      Prj_Check_Console := .F.
      bConsole          := .F.
      Prj_Check_Upx     := .F.
      bUpx              := .F.
      Prj_Check_OutputSuffix := .F.
      bOutputSuffix     := .F.
      For i=1 to len( vSuffix )
         &( 'IncludeLibs'+vSuffix[i][1] ) := {}
         &( 'ExcludeLibs'+vSuffix[i][1] ) := {}
      Next
      vExtraFoldersForSearch := {}
      vSinLoadWindow := {}
      vSinInclude    := {}
      vXRefPrgHea    := {}
      vXRefPrgFmg    := {}
      PUB_bDebugActive := .F.
      VentanaMain.Debug.Checked := .F.
      bConvert := .F.
      cConvert := ""
      bRunParm := .F.
      GBL_cRunParm := ""
      bBuildRun := .F.
      bBuildRunBack := .F.
      GBL_HR_cLastExternalFileName := ""
      //
//    PUB_MI_cMainApplName      := ""
      PUB_MI_bExeAssociation    := .F.
      PUB_MI_cExeAssociation    := ""
      PUB_MI_nExeAssociationIcon:= 1
      PUB_MI_bExeBackupOption   := .F.
      PUB_MI_bNewFile           := .F.
      PUB_MI_nNewFileSuggested  := 1
      PUB_MI_cNewFileLeyend     := ""
      PUB_MI_nNewFileEmpty      := 1
      PUB_MI_cNewFileUserFile   := ""
      PUB_MI_nDestinationPath   := 1
      PUB_MI_cDestinationPath   := ""
      PUB_MI_nLeyendSuggested   := 1
      PUB_MI_cLeyendUserText    := ""
      PUB_MI_bDesktopShortCut   := .T.
      PUB_MI_nDesktopShortCut   := 1
      PUB_MI_bStartMenuShortCut := .T.
      PUB_MI_nStartMenuShortCut := 1
      PUB_MI_bLaunchApplication := .T.
      PUB_MI_nLaunchApplication := 1
      PUB_MI_bLaunchBackupOption := .F.
      PUB_MI_bReboot            := .F.
      PUB_MI_cDefaultLanguage   := "EN"
      PUB_MI_nInstallerName     := 1
      PUB_MI_cInstallerName     := ""
      PUB_MI_cImage             := ""
      PUB_MI_vFiles             := {}
      PUB_MI_bSelectAllPRG      := .F.
      PUB_MI_bSelectAllHEA      := .F.
      PUB_MI_bSelectAllPAN      := .F.
      PUB_MI_bSelectAllDBF      := .F.
      PUB_MI_bSelectAllLIB      := .F.
      //
      if bLogActivity
         QPM_MemoWrit( PUB_cQPM_Folder+DEF_SLASH + "QPM.log" , memoread( PUB_cQPM_Folder+DEF_SLASH + "QPM.log" ) + HB_OSNewLine() + "xRefPrgFmg CleanUp of vSinLoadWindow by QPM_OpenProject" )
         QPM_MemoWrit( PUB_cQPM_Folder+DEF_SLASH + "QPM.log" , memoread( PUB_cQPM_Folder+DEF_SLASH + "QPM.log" ) + HB_OSNewLine() + "xRefPrgHea CleanUp of vSinInclude by QPM_OpenProject" )
         QPM_MemoWrit( PUB_cQPM_Folder+DEF_SLASH + "QPM.log" , memoread( PUB_cQPM_Folder+DEF_SLASH + "QPM.log" ) + HB_OSNewLine() + "xRefPrgHea CleanUp of vXRefPrgHea by QPM_OpenProject" )
         QPM_MemoWrit( PUB_cQPM_Folder+DEF_SLASH + "QPM.log" , memoread( PUB_cQPM_Folder+DEF_SLASH + "QPM.log" ) + HB_OSNewLine() + "xRefPrgFmg CleanUp of vXRefPrgFmg by QPM_OpenProject" )
      endif

      // INI Capturo el archivo de proyecto
      QPM_ProjectFileUnLock()
      if !( ( LOC_nOpenError := QPM_ProjectFileLock( cProjectFileName ) ) == 0 )
         do case
            case LOC_nOpenError == 5
               MsgInfo( "Project '" + cProjectFileName + "' already in use" )
            otherwise
               MsgInfo( "Project '" + cProjectFileName + "' not opened. Error fopen #: " + US_VarToStr( LOC_nOpenError ) )
         endcase
         PUB_cProjectFile := ""
         PUB_cProjectFolder := ""
         Return .F.
      endif
      // END Capturo el archivo de proyecto

      cMemoProjectFile := MemoRead( cProjectFileName )
      if MLCount ( cMemoProjectFile , 254 ) > 0
         LOC_cLine := alltrim ( MEMOLINE( cMemoProjectFile , 254 , 1 ) )
         if us_word( LOC_cLine , 1 ) == "VERSION"
            configversion := val( us_word( LOC_cLine , 2 ) + us_word( LOC_cLine , 3 ) + us_word( LOC_cLine , 4 ) )
         else
            configversion := val( "010001" )   && 01.00.01
         endif
      else
         bNew := .T.
      endif
      if configVersion > PUB_nQPM_Version .and. !PUB_bIgnoreVersionProject
         if ! MyMsgYesNo( "The Project Version file (" + QPM_VerNunStr( configVersion ) + ") is newer that the version of this program (" + QPM_VerNunStr( PUB_nQPM_Version ) + "). Process the project file ?" )
            PUB_cProjectFile := ""
            PUB_cProjectFolder := ""
            Return .f.
         endif
      endif
      PRIVATE PRI_COMPATIBILITY_THISFOLDER            := PUB_cThisFolder
      PRIVATE PRI_COMPATIBILITY_CONFIGVERSION         := ConfigVersion
      PRIVATE PRI_COMPATIBILITY_MEMOPROJECTFILE       := cMemoProjectFile
      PRIVATE PRI_COMPATIBILITY_MEMOPROJECTFILEAUX    := cMemoProjectFileAux
      PRIVATE PRI_COMPATIBILITY_PROJECTFOLDER         := PUB_cProjectFolder
      PRIVATE PRI_COMPATIBILITY_PROJECTFOLDERIDENT    := cProjectFolderIdent
#include "QPM_CompatibilityOpenProject.CH"
      PUB_cThisFolder       := PRI_COMPATIBILITY_THISFOLDER
      ConfigVersion         := PRI_COMPATIBILITY_CONFIGVERSION
      cMemoProjectFile      := PRI_COMPATIBILITY_MEMOPROJECTFILE
      cMemoProjectFileAux   := PRI_COMPATIBILITY_MEMOPROJECTFILEAUX
      PUB_cProjectFolder    := PRI_COMPATIBILITY_PROJECTFOLDER
      cProjectFolderIdent   := PRI_COMPATIBILITY_PROJECTFOLDERIDENT
      RELEASE PRI_COMPATIBILITY_THISFOLDER
      RELEASE PRI_COMPATIBILITY_CONFIGVERSION
      RELEASE PRI_COMPATIBILITY_MEMOPROJECTFILE
      RELEASE PRI_COMPATIBILITY_MEMOPROJECTFILEAUX
      RELEASE PRI_COMPATIBILITY_PROJECTFOLDER
      RELEASE PRI_COMPATIBILITY_PROJECTFOLDERIDENT
      /* Version Actual */
      For i := 1 To MLCount ( cMemoProjectFile , 254 )
         LOC_cLine := alltrim ( MEMOLINE( cMemoProjectFile , 254 , i ) )
         If      US_Upper( US_Word( LOC_cLine , 1 ) ) == 'PROJECTFOLDER'
             //  VentanaMain.TProjectFolder.Value := US_WordSubStr( LOC_cLine , 2 )
                 VentanaMain.TProjectFolder.Value := US_StrTran( US_WordSubStr( LOC_cLine , 2 ) , "<ThisFolder>" , PUB_cThisFolder )
         ElseIf  US_Upper( US_Word( LOC_cLine , 1 ) ) == 'PRJ_VERSION'
                 SetProperty( "VentanaMain" , "LVerVerNum" , "value" , PadL( US_Word( LOC_cLine , 2 ) , DEF_LEN_VER_VERSION , "0" ) )
                 SetProperty( "VentanaMain" , "LVerRelNum" , "value" , PadL( US_Word( LOC_cLine , 3 ) , DEF_LEN_VER_RELEASE , "0" ) )
                 SetProperty( "VentanaMain" , "LVerBuiNum" , "value" , PadL( US_Word( LOC_cLine , 4 ) , DEF_LEN_VER_BUILD , "0" ) )
                 cPrj_VersionAnt := GetPrjVersion()
         ElseIf  at( "LASTLIBFOLDER" , US_Upper( LOC_cLine ) ) = 1
                 if US_IsVar( 'cLastLibFolder'+substr( US_Upper( us_Word( LOC_cLine , 1 ) ) , 14 ) )
                    &( 'cLastLibFolder'+substr( US_Upper( us_Word( LOC_cLine , 1 ) ) , 14 ) ) := us_wordSubStr( LOC_cLine , 2 )
                 endif
         ElseIf  US_Upper( US_Word( LOC_cLine , 1 ) ) == 'RUNFOLDER'
                 VentanaMain.TRunProjectFolder.Value := ChgPathToReal( US_WordSubStr( LOC_cLine , 2 ) )
         ElseIf  US_Upper( US_Word( LOC_cLine , 1 ) ) == 'RUNPARAM'
                 GBL_cRunParm := US_WordSubStr( LOC_cLine , 2 )
         ElseIf  US_Upper( US_Word( LOC_cLine , 1 ) ) == 'OVERRIDECOMPILEPARM'
                 SetProperty( "VentanaMain" , "OverrideCompile" , "Value" , US_WordSubStr( LOC_cLine , 2 ) )
         ElseIf  US_Upper( US_Word( LOC_cLine , 1 ) ) == 'OVERRIDELINKPARM'
                 SetProperty( "VentanaMain" , "OverrideLink" , "Value" , US_WordSubStr( LOC_cLine , 2 ) )
       //ElseIf  US_Upper( US_Word( LOC_cLine , 1 ) ) = 'XHARBOURSUPPORT'
       //        If US_Upper ( US_Word( LOC_cLine , 2 ) ) = 'YES'
       //                Prj_Radio_Harbour := DEF_RG_XHARBOUR
       //       * No Borrar         Prj_Check_34_Enabled := .T.
       //        Else
       //                Prj_Radio_Harbour := DEF_RG_HARBOUR
       //       * No Borrar         Prj_Check_34_Enabled := .F.
       //        EndIf
         ElseIf  US_Upper( US_Word( LOC_cLine , 1 ) ) == 'CHECKHARBOUR'
                 If US_Upper ( US_Word( LOC_cLine , 2 ) ) = DefineXHarbour
                    Prj_Radio_Harbour := DEF_RG_XHARBOUR
                * No Borrar         Prj_Check_34_Enabled := .T.
                 Else
                    Prj_Radio_Harbour := DEF_RG_HARBOUR
                * No Borrar         Prj_Check_34_Enabled := .F.
                 EndIf
         ElseIf  US_Upper( US_Word( LOC_cLine , 1 ) ) == 'CHECKHARBOURIS31'
                 If US_Upper ( US_Word( LOC_cLine , 2 ) ) = "YES"
                    Prj_Check_HarbourIs31 := .T.
                 Else
                    Prj_Check_HarbourIs31 := .F.
                 EndIf
         ElseIf  US_Upper( US_Word( LOC_cLine , 1 ) ) == 'XHARBOURMTSUPPORT'
                 If US_Upper ( US_Word( LOC_cLine , 2 ) ) = 'YES'
                    * No Borrar        Prj_Check_34 := .T.
                 Else
                    * No Borrar        Prj_Check_34 := .F.
                 EndIf
         ElseIf  US_Upper( US_Word( LOC_cLine , 1 ) ) == 'CHECKCPP'
                 do case
                    case US_Word ( LOC_cLine , 2 ) == DefineBorland
                       Prj_Radio_Cpp := DEF_RG_BORLAND
                    case US_Word ( LOC_cLine , 2 ) == DefineMinGW
                       Prj_Radio_Cpp := DEF_RG_MINGW
                    case US_Word ( LOC_cLine , 2 ) == DefinePelles
                       Prj_Radio_Cpp := DEF_RG_PELLES
                 endcase
         ElseIf  US_Upper( US_Word( LOC_cLine , 1 ) ) == 'CHECKMINIGUI'
                 do case
                    case US_Word ( LOC_cLine , 2 ) == DefineMiniGui1
                       Prj_Radio_MiniGui := DEF_RG_MINIGUI1
                    case US_Word ( LOC_cLine , 2 ) == DefineMiniGui3
                       Prj_Radio_MiniGui := DEF_RG_MINIGUI3
                    case US_Word ( LOC_cLine , 2 ) == DefineExtended1
                       Prj_Radio_MiniGui := DEF_RG_EXTENDED1
                    case US_Word ( LOC_cLine , 2 ) == DefineOohg3
                       Prj_Radio_MiniGui := DEF_RG_OOHG3
                 endcase
         ElseIf  US_Upper( US_Word( LOC_cLine , 1 ) ) == 'CHECKCONSOLE'
                 Prj_Check_Console := if( US_Word ( LOC_cLine , 2 ) == "YES" , .T. , .F. )
                 bConsole := if( US_Word ( LOC_cLine , 2 ) == "YES" , .T. , .F. )
         ElseIf  US_Upper( US_Word( LOC_cLine , 1 ) ) == 'OUTPUTTYPE'
                 do case
                    case US_Word ( LOC_cLine , 2 ) == "SRCEXE"
                       Prj_Radio_OutputType := DEF_RG_EXE
                    case US_Word ( LOC_cLine , 2 ) == "SRCLIB"
                       Prj_Radio_OutputType := DEF_RG_LIB
                 // case US_Word ( LOC_cLine , 2 ) == "SRCDLL"
                 //    Prj_Radio_OutputType := DEF_RG_DLL
                    case US_Word ( LOC_cLine , 2 ) == "DLLLIB"
                       Prj_Radio_OutputType := DEF_RG_IMPORT
                       VentanaMain.Check_NumberOnPrg.enabled := .F.
                       VentanaMain.bReLoadPpo.enabled := .F.
                   //  VentanaMain.bReLoadPrg.enabled := .F.
                 endcase
                 ActOutputTypeSet()
         ElseIf  US_Upper( US_Word( LOC_cLine , 1 ) ) == 'CHECKREIMPORT'
                 SetProperty( "VentanaMain" , "Check_Reimp" , "Value" , if( US_Word ( LOC_cLine , 2 ) == "YES" , .T. , .F. ) )
         ElseIf  US_Upper( US_Word( LOC_cLine , 1 ) ) == 'LIBREIMPORT'
                 SetProperty( "VentanaMain" , "TReimportLib" , "Value" , US_WordSubStr( LOC_cLine , 2 ) )
         ElseIf  US_Upper( US_Word( LOC_cLine , 1 ) ) == 'IMPORTGUIONA'
                 SetProperty( "VentanaMain" , "Check_GuionA" , "Value" , if( US_Word ( LOC_cLine , 2 ) == "YES" , .T. , .F. ) )
         ElseIf  US_Upper( US_Word( LOC_cLine , 1 ) ) == 'OUTPUTCOPYMOVE'
                 do case
                    case US_Word ( LOC_cLine , 2 ) == "NONE"
                       Prj_Radio_OutputCopyMove := 1
                    case US_Word ( LOC_cLine , 2 ) == "COPY"
                       Prj_Radio_OutputCopyMove := 2
                    case US_Word ( LOC_cLine , 2 ) == "MOVE"
                       Prj_Radio_OutputCopyMove := 3
                 endcase
                 ActOutputCopyMoveSet()
         ElseIf  US_Upper( US_Word( LOC_cLine , 1 ) ) == 'OUTPUTCOPYMOVEFOLDER'
                 Prj_Text_OutputCopyMoveFolder := ChgPathToReal( US_WordSubStr( LOC_cLine , 2 ) )
         ElseIf  US_Upper( US_Word( LOC_cLine , 1 ) ) == 'DBFAUTOVIEW'
                 bDbfAutoView := if( US_Word( LOC_cLine , 2 ) == ".T." , .T. , .F. )
         ElseIf  US_Upper( US_Word( LOC_cLine , 1 ) ) == 'EXTRARUNCMDFINAL'
                 Prj_ExtraRunCmdFINAL := US_WordSubStr( LOC_cLine , 2 )
         ElseIf  US_Upper( US_Word( LOC_cLine , 1 ) ) == 'EXTRARUNPROJQPM'
                 Prj_ExtraRunProjQPM := US_WordSubStr( LOC_cLine , 2 )
         ElseIf  US_Upper( US_Word( LOC_cLine , 1 ) ) == 'EXTRARUNCMDEXE'
                 Prj_ExtraRunCmdEXE := US_WordSubStr( LOC_cLine , 2 )
         ElseIf  US_Upper( US_Word( LOC_cLine , 1 ) ) == 'EXTRARUNCMDFREE'
                 Prj_ExtraRunCmdFREE := US_WordSubStr( LOC_cLine , 2 )
         ElseIf  US_Upper( US_Word( LOC_cLine , 1 ) ) == 'EXTRARUNQPMPARM'
                 Prj_ExtraRunCmdQPMParm := US_WordSubStr( LOC_cLine , 2 )
         ElseIf  US_Upper( US_Word( LOC_cLine , 1 ) ) == 'EXTRARUNEXEPARM'
                 Prj_ExtraRunCmdEXEParm := US_WordSubStr( LOC_cLine , 2 )
         ElseIf  US_Upper( US_Word( LOC_cLine , 1 ) ) == 'EXTRARUNFREEPARM'
                 Prj_ExtraRunCmdFREEParm := US_WordSubStr( LOC_cLine , 2 )
         ElseIf  US_Upper( US_Word( LOC_cLine , 1 ) ) == 'EXTRARUNTYPE'
                 Prj_ExtraRunType := US_WordSubStr( LOC_cLine , 2 )
                 if Prj_ExtraRunType == ""
                    Prj_ExtraRunType := "NONE"
                 endif
         ElseIf  US_Upper( US_Word( LOC_cLine , 1 ) ) == 'EXTRARUNQPMRADIO'
                 Prj_ExtraRunQPMRadio := US_WordSubStr( LOC_cLine , 2 )
         ElseIf  US_Upper( US_Word( LOC_cLine , 1 ) ) == 'EXTRARUNQPMLITE'
                 Prj_ExtraRunQPMLite := if( US_WordSubStr( LOC_cLine , 2 ) == ".T." , .T. , .F. )
         ElseIf  US_Upper( US_Word( LOC_cLine , 1 ) ) == 'EXTRARUNQPMFORCEFULL'
                 Prj_ExtraRunQPMForceFull := if( US_WordSubStr( LOC_cLine , 2 ) == ".T." , .T. , .F. )
         ElseIf  US_Upper( US_Word( LOC_cLine , 1 ) ) == 'EXTRARUNQPMRUN'
                 Prj_ExtraRunQPMRun := if( US_WordSubStr( LOC_cLine , 2 ) == ".T." , .T. , .F. )
         ElseIf  US_Upper( US_Word( LOC_cLine , 1 ) ) == 'EXTRARUNQPMBUTTONRUN'
                 Prj_ExtraRunQPMButtonRun := if( US_WordSubStr( LOC_cLine , 2 ) == ".T." , .T. , .F. )
         ElseIf  US_Upper( US_Word( LOC_cLine , 1 ) ) == 'EXTRARUNQPMCLEAR'
                 Prj_ExtraRunQPMClear := if( US_WordSubStr( LOC_cLine , 2 ) == ".T." , .T. , .F. )
         ElseIf  US_Upper( US_Word( LOC_cLine , 1 ) ) == 'EXTRARUNQPMLOG'
                 Prj_ExtraRunQPMLog := if( US_WordSubStr( LOC_cLine , 2 ) == ".T." , .T. , .F. )
         ElseIf  US_Upper( US_Word( LOC_cLine , 1 ) ) == 'EXTRARUNQPMLOGONLYERROR'
                 Prj_ExtraRunQPMLogOnlyError := if( US_WordSubStr( LOC_cLine , 2 ) == ".T." , .T. , .F. )
         ElseIf  US_Upper( US_Word( LOC_cLine , 1 ) ) == 'EXTRARUNQPMAUTOEXIT'
                 Prj_ExtraRunQPMAutoExit := if( US_WordSubStr( LOC_cLine , 2 ) == ".T." , .T. , .F. )
         ElseIf  US_Upper( US_Word( LOC_cLine , 1 ) ) == 'EXTRARUNEXEWAIT'
                 Prj_ExtraRunExeWait := if( US_WordSubStr( LOC_cLine , 2 ) == ".T." , .T. , .F. )
         ElseIf  US_Upper( US_Word( LOC_cLine , 1 ) ) == 'EXTRARUNEXEPAUSE'
                 Prj_ExtraRunExePause := if( US_WordSubStr( LOC_cLine , 2 ) == ".T." , .T. , .F. )
         ElseIf  US_Upper( US_Word( LOC_cLine , 1 ) ) == 'EXTRARUNFREEWAIT'
                 Prj_ExtraRunFreeWait := if( US_WordSubStr( LOC_cLine , 2 ) == ".T." , .T. , .F. )
         ElseIf  US_Upper( US_Word( LOC_cLine , 1 ) ) == 'EXTRARUNFREEPAUSE'
                 Prj_ExtraRunFreePause := if( US_WordSubStr( LOC_cLine , 2 ) == ".T." , .T. , .F. )
         ElseIf  US_Upper( US_Word( LOC_cLine , 1 ) ) == 'OUTPUTRENAME'
                 do case
                    case US_Word ( LOC_cLine , 2 ) == "NONE"
                       Prj_Radio_OutputRename := 1
                    case US_Word ( LOC_cLine , 2 ) == "NEWNAME"
                       Prj_Radio_OutputRename := 2
                 endcase
                 ActOutputRenameSet()
         ElseIf  US_Upper( US_Word( LOC_cLine , 1 ) ) == 'OUTPUTRENAMENEWNAME'
                 Prj_Text_OutputRenameNewName := US_WordSubStr( LOC_cLine , 2 )
         ElseIf  US_Upper( US_Word( LOC_cLine , 1 ) ) == 'CHECKOUTPUTSUFFIX'
                 Prj_Check_OutputSuffix := if( US_Word ( LOC_cLine , 2 ) == "YES" , .T. , .F. )
                 bOutputSuffix := if( US_Word ( LOC_cLine , 2 ) == "YES" , .T. , .F. )
         ElseIf  US_Upper( US_Word( LOC_cLine , 1 ) ) == 'CHECKUPX'
                 Prj_Check_Upx := if( US_Word ( LOC_cLine , 2 ) == "YES" , .T. , .F. )
                 bUpx := if( US_Word ( LOC_cLine , 2 ) == "YES" , .T. , .F. )
         ElseIf  US_Upper( US_Word( LOC_cLine , 1 ) ) == 'CHECKFORMTOOL'
                 do case
                    case US_Word ( LOC_cLine , 2 ) == "AUTO"
                       Prj_Radio_FormTool := 1
                    case US_Word ( LOC_cLine , 2 ) == "HMI"
                       Prj_Radio_FormTool := 2
                    case US_Word ( LOC_cLine , 2 ) == "HMGSIDE"
                       Prj_Radio_FormTool := 3
                 endcase
                 ActFormToolSet()
         ElseIf  US_Upper( US_Word( LOC_cLine , 1 ) ) == 'CHECKDBFTOOL'
                 do case
                    case US_Word ( LOC_cLine , 2 ) == "DBFVIEW"
                       Prj_Radio_DbfTool := 1
                    case US_Word ( LOC_cLine , 2 ) == "DBU"
                       Prj_Radio_DbfTool := 2
                    case US_Word ( LOC_cLine , 2 ) == "OTHER"
                 //    Prj_Radio_DbfTool := 3
                       Prj_Radio_DbfTool := 2  // DBU
                 endcase
                 ActDbfToolSet()
                 //
  //     ElseIf  US_Upper( US_Word( LOC_cLine , 1 ) ) == 'MI_CMAINAPPLNAME'
  //             PUB_MI_cMainApplName := US_WordSubStr( LOC_cLine , 2 )
         ElseIf  US_Upper( US_Word( LOC_cLine , 1 ) ) == 'MI_BEXEASSOCIATION'
                 PUB_MI_bExeAssociation := if( US_WordSubStr( LOC_cLine , 2 ) == ".T." , .T. , .F. )
         ElseIf  US_Upper( US_Word( LOC_cLine , 1 ) ) == 'MI_CEXEASSOCIATION'
                 PUB_MI_cExeAssociation := US_WordSubStr( LOC_cLine , 2 )
         ElseIf  US_Upper( US_Word( LOC_cLine , 1 ) ) == 'MI_NEXEASSOCIATIONICON'
                 PUB_MI_nExeAssociationIcon := val( US_Word( LOC_cLine , 2 ) )
         ElseIf  US_Upper( US_Word( LOC_cLine , 1 ) ) == 'MI_BEXEBACKUPOPTION'
                 PUB_MI_bExeBackupOption := if( US_WordSubStr( LOC_cLine , 2 ) == ".T." , .T. , .F. )
         ElseIf  US_Upper( US_Word( LOC_cLine , 1 ) ) == 'MI_BNEWFILE'
                 PUB_MI_bNewFile := if( US_WordSubStr( LOC_cLine , 2 ) == ".T." , .T. , .F. )
         ElseIf  US_Upper( US_Word( LOC_cLine , 1 ) ) == 'MI_NNEWFILESUGGESTED'
                 PUB_MI_nNewFileSuggested := val( US_WordSubStr( LOC_cLine , 2 ) )
         ElseIf  US_Upper( US_Word( LOC_cLine , 1 ) ) == 'MI_CNEWFILELEYEND'
                 PUB_MI_cNewFileLeyend := US_WordSubStr( LOC_cLine , 2 )
         ElseIf  US_Upper( US_Word( LOC_cLine , 1 ) ) == 'MI_NNEWFILEEMPTY'
                 PUB_MI_nNewFileEmpty := val( US_WordSubStr( LOC_cLine , 2 ) )
         ElseIf  US_Upper( US_Word( LOC_cLine , 1 ) ) == 'MI_CNEWFILEUSERFILE'
                 PUB_MI_cNewFileUserFile := US_WordSubStr( LOC_cLine , 2 )
         ElseIf  US_Upper( US_Word( LOC_cLine , 1 ) ) == 'MI_NDESTINATIONPATH'
                 PUB_MI_nDestinationPath := val( US_WordSubStr( LOC_cLine , 2 ) )
         ElseIf  US_Upper( US_Word( LOC_cLine , 1 ) ) == 'MI_CDESTINATIONPATH'
                 PUB_MI_cDestinationPath := US_WordSubStr( LOC_cLine , 2 )
         ElseIf  US_Upper( US_Word( LOC_cLine , 1 ) ) == 'MI_NLEYENDSUGGESTED'
                 PUB_MI_nLeyendSuggested := val( US_WordSubStr( LOC_cLine , 2 ) )
         ElseIf  US_Upper( US_Word( LOC_cLine , 1 ) ) == 'MI_CLEYENDUSERTEXT'
                 PUB_MI_cLeyendUserText := US_WordSubStr( LOC_cLine , 2 )
         ElseIf  US_Upper( US_Word( LOC_cLine , 1 ) ) == 'MI_BDESKTOPSHORTCUT'
                 PUB_MI_bDesktopShortCut := if( US_WordSubStr( LOC_cLine , 2 ) == ".T." , .T. , .F. )
         ElseIf  US_Upper( US_Word( LOC_cLine , 1 ) ) == 'MI_NDESKTOPSHORTCUT'
                 PUB_MI_nDesktopShortCut := val( US_WordSubStr( LOC_cLine , 2 ) )
         ElseIf  US_Upper( US_Word( LOC_cLine , 1 ) ) == 'MI_BSTARTMENUSHORTCUT'
                 PUB_MI_bStartMenuShortCut := if( US_WordSubStr( LOC_cLine , 2 ) == ".T." , .T. , .F. )
         ElseIf  US_Upper( US_Word( LOC_cLine , 1 ) ) == 'MI_NSTARTMENUSHORTCUT'
                 PUB_MI_nStartMenuShortCut := val( US_WordSubStr( LOC_cLine , 2 ) )
         ElseIf  US_Upper( US_Word( LOC_cLine , 1 ) ) == 'MI_BLAUNCHAPPLICATION'
                 PUB_MI_bLaunchApplication := if( US_WordSubStr( LOC_cLine , 2 ) == ".T." , .T. , .F. )
         ElseIf  US_Upper( US_Word( LOC_cLine , 1 ) ) == 'MI_NLAUNCHAPPLICATION'
                 PUB_MI_nLaunchApplication := val( US_WordSubStr( LOC_cLine , 2 ) )
         ElseIf  US_Upper( US_Word( LOC_cLine , 1 ) ) == 'MI_BLAUNCHBACKUPOPTION'
                 PUB_MI_bLaunchBackupOption := if( US_WordSubStr( LOC_cLine , 2 ) == ".T." , .T. , .F. )
         ElseIf  US_Upper( US_Word( LOC_cLine , 1 ) ) == 'MI_BREBOOT'
                 PUB_MI_bReboot := if( US_WordSubStr( LOC_cLine , 2 ) == ".T." , .T. , .F. )
         ElseIf  US_Upper( US_Word( LOC_cLine , 1 ) ) == 'MI_CDEFAULTLANGUAGE'
                 PUB_MI_cDefaultLanguage := US_Word( LOC_cLine , 2 )
         ElseIf  US_Upper( US_Word( LOC_cLine , 1 ) ) == 'MI_NINSTALLERNAME'
                 PUB_MI_nInstallerName := val( US_WordSubStr( LOC_cLine , 2 ) )
         ElseIf  US_Upper( US_Word( LOC_cLine , 1 ) ) == 'MI_CINSTALLERNAME'
                 PUB_MI_cInstallerName := US_WordSubStr( LOC_cLine , 2 )
         ElseIf  US_Upper( US_Word( LOC_cLine , 1 ) ) == 'MI_CIMAGE'
                 PUB_MI_cImage := US_WordSubStr( LOC_cLine , 2 )
         ElseIf  US_Upper( US_Word( LOC_cLine , 1 ) ) == 'MI_BSELECTALLPRG'
                 PUB_MI_bSelectAllPRG := if( US_WordSubStr( LOC_cLine , 2 ) == ".T." , .T. , .F. )
         ElseIf  US_Upper( US_Word( LOC_cLine , 1 ) ) == 'MI_BSELECTALLHEA'
                 PUB_MI_bSelectAllHEA := if( US_WordSubStr( LOC_cLine , 2 ) == ".T." , .T. , .F. )
         ElseIf  US_Upper( US_Word( LOC_cLine , 1 ) ) == 'MI_BSELECTALLPAN'
                 PUB_MI_bSelectAllPAN := if( US_WordSubStr( LOC_cLine , 2 ) == ".T." , .T. , .F. )
         ElseIf  US_Upper( US_Word( LOC_cLine , 1 ) ) == 'MI_BSELECTALLDBF'
                 PUB_MI_bSelectAllDBF := if( US_WordSubStr( LOC_cLine , 2 ) == ".T." , .T. , .F. )
         ElseIf  US_Upper( US_Word( LOC_cLine , 1 ) ) == 'MI_BSELECTALLLIB'
                 PUB_MI_bSelectAllLIB := if( US_WordSubStr( LOC_cLine , 2 ) == ".T." , .T. , .F. )
         ElseIf  US_Upper( US_Word( LOC_cLine , 1 ) ) == 'MI_CFILE'
                 aadd( PUB_MI_vFiles , { val( US_Word( LOC_cLine , 2 ) ) , strtran( US_Word( LOC_cLine , 3 ) , "|" , " " ) , strtran( US_Word( LOC_cLine , 4 ) , "|" , " " ) , strtran( US_Word( LOC_cLine , 5 ) , "|" , " " ) , strtran( US_Word( LOC_cLine , 6 ) , "|" , " " ) , strtran( US_Word( LOC_cLine , 7 ) , "|" , " " ) } )
                 //
         ElseIf  US_Upper( US_Word( LOC_cLine , 1 ) ) == 'SHGDATABASE'
                 SHG_Database := ChgPathToReal( US_WordSubStr( LOC_cLine , 2 ) )
         ElseIf  US_Upper( US_Word( LOC_cLine , 1 ) ) == 'SHGLASTFOLDERIMG'
                 SHG_LastFolderImg := US_WordSubStr( LOC_cLine , 2 )
         ElseIf  US_Upper( US_Word( LOC_cLine , 1 ) ) == 'SHGOUTPUTTYPE'
                 SHG_CheckTypeOutput := if( US_Word ( LOC_cLine , 2 ) == "YES" , .T. , .F. )
#ifdef QPM_SHG
                 SetProperty( "VentanaMain" , "CH_SHG_TypeOutput" , "value" , SHG_CheckTypeOutput )
#endif
         ElseIf  US_Upper( US_Word( LOC_cLine , 1 ) ) == 'SHGHTMLFOLDER'
                 SHG_HtmlFolder := US_WordSubStr( LOC_cLine , 2 )
         ElseIf  US_Upper( US_Word( LOC_cLine , 1 ) ) == 'SHGWWW'
                 SHG_WWW := US_WordSubStr( LOC_cLine , 2 )
#ifdef QPM_HOTRECOVERY
         ElseIf  US_Upper( US_Word( LOC_cLine , 1 ) ) == 'HOTLASTEXTERNALFILE'
                 GBL_HR_cLastExternalFileName := US_WordSubStr( LOC_cLine , 2 )
#endif
         ElseIf  US_Upper ( US_Word( LOC_cLine , 1 ) ) == 'SOURCE'
                 cForceRecomp := " "
                 if at( "<FR> " , LOC_cLine ) > 0
                    LOC_cLine := StrTran( LOC_cLine , "<FR> " , "" )
                    cForceRecomp := "R"
                 endif
                 VentanaMain.GPrgFiles.AddItem( { PUB_nGridImgNone , cForceRecomp , US_FileNameOnlyNameAndExt( US_WordSubStr( LOC_cLine , 2 ) ) , ChgPathToRelative( US_WordSubStr( LOC_cLine , 2 ) ) , "0" , "" , "" } )
              // if ascan( vExtraFoldersForSearch , US_FileNameOnlyPath( ChgPathToReal( GetProperty( "VentanaMain" , "GPrgFiles" , "Cell" , VentanaMain.GPrgFiles.ItemCount , NCOLPRGFULLNAME ) ) ) ) = 0
                 if AScan( vExtraFoldersForSearch , { |y| upper( US_VarToStr( y ) ) == upper( US_FileNameOnlyPath( ChgPathToReal( GetProperty( "VentanaMain" , "GPrgFiles" , "Cell" , VentanaMain.GPrgFiles.ItemCount , NCOLPRGFULLNAME ) ) ) ) } ) == 0
                    aadd( vExtraFoldersForSearch , US_FileNameOnlyPath( ChgPathToReal( GetProperty( "VentanaMain" , "GPrgFiles" , "Cell" , VentanaMain.GPrgFiles.ItemCount , NCOLPRGFULLNAME ) ) ) )
                 endif
         ElseIf  US_Upper ( US_Word( LOC_cLine , 1 ) ) == 'HEAD'
                 VentanaMain.GHeaFiles.AddItem( { PUB_nGridImgNone , US_FileNameOnlyNameAndExt( US_WordSubStr( LOC_cLine , 2 ) ) , ChgPathToRelative( US_WordSubStr( LOC_cLine , 2 ) ) , "0" , "" , "" } )
              // if ascan( vExtraFoldersForSearch , US_FileNameOnlyPath( ChgPathToReal( GetProperty( "VentanaMain" , "GHeaFiles" , "Cell" , VentanaMain.GHeaFiles.ItemCount , NCOLHEAFULLNAME ) ) ) ) = 0
                 if AScan( vExtraFoldersForSearch , { |y| upper( US_VarToStr( y ) ) == upper( US_FileNameOnlyPath( ChgPathToReal( GetProperty( "VentanaMain" , "GHeaFiles" , "Cell" , VentanaMain.GHeaFiles.ItemCount , NCOLHEAFULLNAME ) ) ) ) } ) == 0
                    aadd( vExtraFoldersForSearch , US_FileNameOnlyPath( ChgPathToReal( GetProperty( "VentanaMain" , "GHeaFiles" , "Cell" , VentanaMain.GHeaFiles.ItemCount , NCOLHEAFULLNAME ) ) ) )
                 endif
         ElseIf  US_Upper ( US_Word( LOC_cLine , 1 ) ) == 'FORM'
                 VentanaMain.GPanFiles.AddItem( { PUB_nGridImgNone , US_FileNameOnlyNameAndExt( US_WordSubStr( LOC_cLine , 2 ) ) , ChgPathToRelative( US_WordSubStr( LOC_cLine , 2 ) ) , "0" , "" , "" } )
             //  if ascan( vExtraFoldersForSearch , US_FileNameOnlyPath( ChgPathToReal( GetProperty( "VentanaMain" , "GPanFiles" , "Cell" , VentanaMain.GPanFiles.ItemCount , NCOLPANFULLNAME ) ) ) ) = 0
                 if AScan( vExtraFoldersForSearch , { |y| upper( US_VarToStr( y ) ) == upper( US_FileNameOnlyPath( ChgPathToReal( GetProperty( "VentanaMain" , "GPanFiles" , "Cell" , VentanaMain.GPanFiles.ItemCount , NCOLPANFULLNAME ) ) ) ) } ) == 0
                    aadd( vExtraFoldersForSearch , US_FileNameOnlyPath( ChgPathToReal( GetProperty( "VentanaMain" , "GPanFiles" , "Cell" , VentanaMain.GPanFiles.ItemCount , NCOLPANFULLNAME ) ) ) )
                 endif
         ElseIf  US_Upper ( US_Word( LOC_cLine , 1 ) ) == 'DBF'
                 VentanaMain.GDbfFiles.AddItem( { PUB_nGridImgNone , US_FileNameOnlyNameAndExt( US_WordSubStr( LOC_cLine , 2 ) ) , ChgPathToRelative( US_WordSubStr( LOC_cLine , 2 ) ) , "0 0" , "" , "0 ** 0" } )
         ElseIf  substr( us_word( US_Upper ( LOC_cLine ) , 1 ) , 1 , 7 ) == "INCLUDE" .and. AScan( vSuffix , { |x| x[1] == substr( US_Upper( us_word( LOC_cLine , 1 ) ) , 8 ) } ) > 0
                 if US_isVar( 'IncludeLibs'+substr(us_word( US_Upper ( LOC_cLine ) , 1 ) , 8 ) )
                    aadd( &( 'IncludeLibs'+substr(us_word( US_Upper ( LOC_cLine ) , 1 ) , 8 ) ) , us_word( LOC_cLine , 2 ) + " " + substr( LOC_cLine , us_wordind( LOC_cLine , 3 ) ) )
                 endif
         ElseIf  substr( us_word( US_Upper ( LOC_cLine ) , 1 ) , 1 , 7 ) == "EXCLUDE" .and. AScan( vSuffix , { |x| x[1] == substr( US_Upper( us_word( LOC_cLine , 1 ) ) , 8 ) } ) > 0
                 if US_isVar( 'ExcludeLibs'+substr(us_word( US_Upper ( LOC_cLine ) , 1 ) , 8 ) )
                    aadd( &( 'ExcludeLibs'+substr(us_word( US_Upper ( LOC_cLine ) , 1 ) , 8 ) ) , us_word( LOC_cLine , 2 ) + " " + substr( LOC_cLine , us_wordind( LOC_cLine , 3 ) ) )
                 endif
         EndIf
      Next i
   EndIf
   if !PUB_bLite
#ifdef QPM_SHG
      if SHG_Database == "*NONE*"
         SHG_Database := ""
      else
         if empty( SHG_Database )
            SHG_Database := SHG_StrTran( SHG_GetDatabaseName( US_FileNameOnlyPathAndName(cProjectFileName) ) + "_SHG.dbf" )
            if MyMsgYesNo('Create database "' + SHG_Database + '" for Simple Help Generator (SHG) ?')
               SHG_CreateDatabase( SHG_Database )
            else
               SHG_Database := ""
            endif
         endif
      endif
      VentanaMain.TWWWHlp.Value      := SHG_WWW
      VentanaMain.THlpDataBase.Value := SHG_Database
      SetProperty( "VentanaMain" , "RichEditHlp" , "readonly" , .T. )
      if !empty( SHG_Database )
         if file( SHG_Database )
            SHG_LoadDatabase( SHG_Database )
            SetProperty( "VentanaMain" , "RichEditHlp" , "readonly" , .F. )
         else
            MsgInfo( "Simple Help Generator Database (SHG) not Found !!!: " + SHG_Database + HB_OsNewLine() + "Look at " + PageHlp  )
         endif
      endif
#endif
      RichEditDisplay("OUT")
      VentanaMain.LFull.FontColor := DEF_COLORGREEN
      VentanaMain.LFull.Value := "Incremental"
   else
      VentanaLite.LFull.FontColor := DEF_COLORGREEN
      VentanaLite.LFull.Value := "Incremental"
   endif
   &( "vExtraFoldersForLibs"+DefineMiniGui1+DefineBorland+DefineHarbour ) := {}
   &( "vExtraFoldersForLibs"+DefineMiniGui1+DefineBorland+DefineXHarbour ) := {}
   &( "vExtraFoldersForLibs"+DefineMiniGui3+DefineMinGW+DefineHarbour ) := {}
   &( "vExtraFoldersForLibs"+DefineMiniGui3+DefineMinGW+DefineXHarbour ) := {}
   &( "vExtraFoldersForLibs"+DefineExtended1+DefineBorland+DefineHarbour ) := {}
   &( "vExtraFoldersForLibs"+DefineExtended1+DefineBorland+DefineXHarbour ) := {}
// NOTE: Added support for MinGW and Extended
   &( "vExtraFoldersForLibs"+DefineExtended1+DefineMinGW+DefineHarbour ) := {}
   &( "vExtraFoldersForLibs"+DefineExtended1+DefineMinGW+DefineXHarbour ) := {}
   &( "vExtraFoldersForLibs"+DefineOohg3+DefineBorland+DefineHarbour ) := {}
   &( "vExtraFoldersForLibs"+DefineOohg3+DefineBorland+DefineXHarbour ) := {}
   CargoIncludeLibs( GetSuffix() )
   CargoExcludeLibs( GetSuffix() )
   QPM_SetColor()
   QPM_SetResumen()
   SetMGWaitTxt( "Columns Autofit..." )
   DoMethod( "VentanaMain" , "GPrgFiles" , "ColumnsAutoFitH" )
   DoMethod( "VentanaMain" , "GPanFiles" , "ColumnsAutoFitH" )
   DoMethod( "VentanaMain" , "GDbfFiles" , "ColumnsAutoFitH" )
   DoMethod( "VentanaMain" , "GHeaFiles" , "ColumnsAutoFitH" )
   DoMethod( "VentanaMain" , "GIncFiles" , "ColumnsAutoFitH" )
   DoMethod( "VentanaMain" , "GExcFiles" , "ColumnsAutoFitH" )
#ifdef QPM_SHG
   DoMethod( "VentanaMain" , "GHlpFiles" , "ColumnsAutoFitH" )
#endif
   QPM_CheckFiles()
   VentanaMain.TabGrids.Value := 1
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
   DoMethod( "VentanaMain" , "GPrgFiles" , "EnableUpdate" )
   DoMethod( "VentanaMain" , "GPanFiles" , "EnableUpdate" )
   DoMethod( "VentanaMain" , "GDbfFiles" , "EnableUpdate" )
   DoMethod( "VentanaMain" , "GHeaFiles" , "EnableUpdate" )
   DoMethod( "VentanaMain" , "GIncFiles" , "EnableUpdate" )
   DoMethod( "VentanaMain" , "GExcFiles" , "EnableUpdate" )
#ifdef QPM_SHG
      DoMethod( "VentanaMain" , "GHlpFiles" , "EnableUpdate" )
#endif
   ProjectButtons( .T. )
   AddLastOpen( cProjectFileName )
   QPM_DefinoMainMenu()
   VentanaMain.Check_DbfAutoView.Value := bDbfAutoView
   if bNew
      SetMGWaitHide()
      ProjectSettings()
      GlobalSettings()
   endif
   SetProperty( "VentanaMain" , "build" , "enabled" , .T. )
   ActOutputTypeSet()
   ActLibReimp()
   CambioTitulo()
Return .t.

Function QPM_ClearLastOpenList()
   vLastOpen := {}
   QPM_DefinoMainMenu()
Return .t.

Function QPM_CheckFiles()
   // QPM_CheckFiles2
   Local i
   SetMGWaitTxt( "Checking files ..." )
   /* */
   DoMethod( "VentanaMain" , "GPrgFiles" , "DisableUpdate" )
   For i:=1 to VentanaMain.GPrgFiles.ItemCount
      if !file( ChgPathToReal( GetProperty( "VentanaMain" , "GPrgFiles" , "Cell" , i , NCOLPRGFULLNAME ) ) )
       //GetProperty( "VentanaMain" , "GPrgFiles" , "Cell" , i , NCOLPRGSTATUS ) := PUB_nGridImgEquis
         GridImage( "VentanaMain" , "GPrgFiles" , i , NCOLPRGSTATUS , "+" , PUB_nGridImgEquis )
      else
       //GetProperty( "VentanaMain" , "GPrgFiles" , "Cell" , i , NCOLPRGSTATUS ) := PUB_nGridImgNone
         GridImage( "VentanaMain" , "GPrgFiles" , i , NCOLPRGSTATUS , "-" , PUB_nGridImgEquis )
      endif
   Next i
   DoMethod( "VentanaMain" , "GPrgFiles" , "EnableUpdate" )
   /* */
   DoMethod( "VentanaMain" , "GPanFiles" , "DisableUpdate" )
   For i:=1 to VentanaMain.GPanFiles.ItemCount
      if !file( ChgPathToReal( GetProperty( "VentanaMain" , "GPanFiles" , "Cell" , i , NCOLPANFULLNAME ) ) )
       //GetProperty( "VentanaMain" , "GPanFiles" , "Cell" , i , NCOLPANSTATUS ) := PUB_nGridImgEquis
         GridImage( "VentanaMain" , "GPanFiles" , i , NCOLPANSTATUS , "+" , PUB_nGridImgEquis )
      else
       //GetProperty( "VentanaMain" , "GPanFiles" , "Cell" , i , NCOLPANSTATUS ) := PUB_nGridImgNone
         GridImage( "VentanaMain" , "GPanFiles" , i , NCOLPANSTATUS , "-" , PUB_nGridImgEquis )
      endif
   Next i
   DoMethod( "VentanaMain" , "GPanFiles" , "EnableUpdate" )
   /* */
   DoMethod( "VentanaMain" , "GDbfFiles" , "DisableUpdate" )
   For i:=1 to VentanaMain.GDbfFiles.ItemCount
      if !file( ChgPathToReal( GetProperty( "VentanaMain" , "GDbfFiles" , "Cell" , i , NCOLDBFFULLNAME ) ) )
      // GetProperty( "VentanaMain" , "GDbfFiles" , "Cell" , i , NCOLDBFSTATUS ) := PUB_nGridImgEquis
         GridImage( "VentanaMain" , "GDbfFiles" , i , NCOLDBFSTATUS , "+" , PUB_nGridImgEquis )
      else
      // GetProperty( "VentanaMain" , "GDbfFiles" , "Cell" , i , NCOLDBFSTATUS ) := PUB_nGridImgNone
         GridImage( "VentanaMain" , "GDbfFiles" , i , NCOLDBFSTATUS , "-" , PUB_nGridImgEquis )
      endif
   Next i
   DoMethod( "VentanaMain" , "GDbfFiles" , "EnableUpdate" )
   /* */
   DoMethod( "VentanaMain" , "GHeaFiles" , "DisableUpdate" )
   For i:=1 to VentanaMain.GHeaFiles.ItemCount
      if !file( ChgPathToReal( GetProperty( "VentanaMain" , "GHeaFiles" , "Cell" , i , NCOLHEAFULLNAME ) ) )
       //GetProperty( "VentanaMain" , "GHeaFiles" , "Cell" , i , NCOLHEASTATUS ) := PUB_nGridImgEquis
         GridImage( "VentanaMain" , "GHeaFiles" , i , NCOLHEASTATUS , "+" , PUB_nGridImgEquis )
      else
      // GetProperty( "VentanaMain" , "GHeaFiles" , "Cell" , i , NCOLHEASTATUS ) := PUB_nGridImgNone
         GridImage( "VentanaMain" , "GHeaFiles" , i , NCOLHEASTATUS , "-" , PUB_nGridImgEquis )
      endif
   Next i
   DoMethod( "VentanaMain" , "GHeaFiles" , "EnableUpdate" )
   /* */
   DoMethod( "VentanaMain" , "GIncFiles" , "DisableUpdate" )
   For i:=1 to VentanaMain.GIncFiles.ItemCount
      if !file( ChgPathToReal( US_WordSubStr( GetProperty( "VentanaMain" , "GIncFiles" , "Cell" , i , NCOLINCFULLNAME ) , 3 ) ) )
      // GetProperty( "VentanaMain" , "GIncFiles" , "Cell" , i , NCOLINCSTATUS ) := PUB_nGridImgEquis
         GridImage( "VentanaMain" , "GIncFiles" , i , NCOLINCSTATUS , "+" , PUB_nGridImgEquis )
      else
       //GetProperty( "VentanaMain" , "GIncFiles" , "Cell" , i , NCOLINCSTATUS ) := PUB_nGridImgNone
         GridImage( "VentanaMain" , "GIncFiles" , i , NCOLINCSTATUS , "-" , PUB_nGridImgEquis )
      endif
   Next i
   DoMethod( "VentanaMain" , "GIncFiles" , "EnableUpdate" )
   /* */
Return .T.

Function QPM_SetResumen()
   // QPM_SetResumen2
   local Venta := if( PUB_bLite , "VentanaLite" , "VentanaMain" ) , cAux
   if Prj_Radio_OutputType == DEF_RG_IMPORT
      do case
         case GetCppSuffix() == DefineBorland
            cAux := "Borland C"
         case GetCppSuffix() == DefineMinGW
            cAux := "MinGW C"
         case GetCppSuffix() == DefinePelles
            cAux := "Pelles C"
         otherwise
            MsgStop( "Invalid CPP type: " + GetCppSuffix() )
      endcase
      SetProperty( Venta , "LResumen" , "Value" , "Build Interface Library from DLL for " + cAux )
      SetProperty( Venta , "LFull" , "visible" , .F. )
      SetProperty( Venta , "LExtra" , "visible" , .F. )
   else
      SetProperty( Venta , "LResumen" , "Value" , vSuffix[ AScan( vSuffix , { |x| x[1] == GetSuffix() } ) ][ 2 ] )
      SetProperty( Venta , "LExtra" , "Value" , if( bConsole , "Console Mode" , "" ) + if( PUB_bDebugActive , " With DEBUG" , "" ) )
      SetProperty( Venta , "LFull" , "visible" , .T. )
      SetProperty( Venta , "LExtra" , "visible" , .T. )
   endif
Return NIL

Function QPM_About()
   MsgInfo( "QPM (QAC based Project Manager)" + HB_OsNewLine() + ;
            "Project Manager for MiniGui (" + PUB_cQPM_VersionDisplay + ")" + HB_OsNewLine() + ;
            HB_OsNewLine() + ;
            "Created by CarozoDeQuilmes (Argentina)" + HB_OsNewLine() + ;
            "Supported by " + PUB_cQPM_Support_Admin + HB_OsNewLine() + ;
            HB_OsNewLine() + ;
            "Home Site: " + PUB_cQPM_Support_Link + HB_OsNewLine() + ;
            "Users list: " + PUB_cQPM_Support_eMail + HB_OsNewLine() + ;
            HB_OsNewLine() + ;
            "Based on MPM Harbour MiniGUI Project Manager" + HB_OsNewLine() + ;
            "Created by Roberto Lopez <roblez@ciudad.com.ar>" + HB_OsNewLine() + ;
            "(c) 2003-2006 Roberto Lopez <roblez@ciudad.com.ar>" + HB_OsNewLine() + ;
            HB_OsNewLine() + ;
            "This release has been builded with previous QPM version " + HB_OsNewLine() + ;
            Get_QPM_Builder_VersionDisplay() + " using: " + HB_OsNewLine() + ;
            "- " + MiniGuiVersion() + "    " + HB_OsNewLine() + ;
            "- " + HB_COMPILER() + HB_OsNewLine() + ;
            "- " + Version() + HB_OsNewLine() + ;
            HB_OsNewLine() + ;
            "Building date: " + substr( GetLinkDate() , 1 , 4 ) + "." + substr( GetLinkDate() , 5 , 2 ) + "." + substr( GetLinkDate() , 7 , 2 ) + HB_OsNewLine() + ;
            "Building time: " + GetLinkTime(), "About QPM" ) // this is not translated
Return .T.

Function QPM_Licence()
   MsgInfo( HB_LoadString( ID_LICENSE_LINE_1 ) + HB_OsNewLine() + ;
            HB_OsNewLine() + ;
            HB_LoadString( ID_LICENSE_LINE_2 ) + HB_OsNewLine() + ;
            HB_LoadString( ID_LICENSE_LINE_3 ) + HB_OsNewLine() + ;
            HB_OsNewLine() + ;
            HB_LoadString( ID_LICENSE_LINE_4 ) + HB_OsNewLine() + ;
            HB_OsNewLine() + ;
            HB_LoadString( ID_LICENSE_LINE_5 ) + " " + HB_LoadString( ID_LICENSE_LINE_6 ) + HB_OsNewLine() + ;
            HB_OsNewLine() + ;
            HB_LoadString( ID_LICENSE_LINE_7 ) + HB_OsNewLine() + ;
            HB_LoadString( ID_LICENSE_LINE_8 ), HB_LoadString( ID_LICENSE_LINE_9 ) ) // this is not translated
Return .T.

Function QPM_SaveProject( bCheck )
   // QPM_SaveProject2
   Local i , j , bDiff := .F. , MemoAux := "" , LineasC := 0 , LineasProject := 0
   Local cForceRecomp := "" , bWrite := .F. , MI_cFilesAux := ""
   Private cINI := ''
   if empty( bCheck )
      bCheck := .F.
   endif
   if PUB_bOpenProjectFromParm
      PUB_bOpenProjectFromParm := .F.
      Return .F.
   endif
   If Empty( PUB_cProjectFile ) .and. empty( PUB_cProjectFolder )
      if !bCheck
         MsgStop('You must open a project first')
      endif
      Return .F.
   EndIf
   cINI := cINI + 'VERSION ' + PUB_cQPM_Version + HB_OsNewLine()
   cINI := cINI + 'PRJ_VERSION ' + MakePrj_Version() + HB_OsNewLine()
   cINI := cINI + 'PROJECTFOLDER ' + US_StrTran( PUB_cProjectFolder , PUB_cThisFolder , "<ThisFolder>" ) + HB_OsNewLine()
   For i=1 to len( vSuffix )
      cINI := cINI + 'LASTLIBFOLDER'+vSuffix[i][1]+' ' + &( 'cLastLibFolder'+vSuffix[i][1] ) + HB_OsNewLine()
   next
   cINI := cINI + 'RUNFOLDER ' + alltrim(ChgPathToRelative(VentanaMain.TRunProjectFolder.Value)) + HB_OsNewLine()
   cINI := cINI + 'RUNPARAM ' + alltrim( GBL_cRunParm ) + HB_OsNewLine()
   cINI := cINI + 'OVERRIDECOMPILEPARM ' + GetProperty( "VentanaMain" , "OverrideCompile" , "value" ) + HB_OsNewLine()
   cINI := cINI + 'OVERRIDELINKPARM ' + GetProperty( "VentanaMain" , "OverrideLink" , "value" ) + HB_OsNewLine()
   cINI := cINI + 'CHECKHARBOUR ' + if ( Prj_Radio_Harbour == DEF_RG_XHARBOUR , DefineXHarbour , DefineHarbour ) + HB_OsNewLine()
   cINI := cINI + 'CHECKHARBOURIS31 ' + if ( Prj_Check_HarbourIs31, "YES", "NO" ) + HB_OsNewLine()
   * No Borrar    cINI := cINI + 'XHARBOURMTSUPPORT ' + if ( Prj_Check_34 == .T. , 'YES' , 'NO' ) + HB_OsNewLine()
   cINI := cINI + 'CHECKCPP ' + GetCppSuffix() + HB_OsNewLine()
   cINI := cINI + 'CHECKMINIGUI ' + GetMiniGuiSuffix() + HB_OsNewLine()
   cINI := cINI + 'CHECKCONSOLE ' + if( Prj_Check_Console , "YES" , "NO" ) + HB_OsNewLine()
   cINI := cINI + 'CHECKUPX ' + if( Prj_Check_Upx , "YES" , "NO" ) + HB_OsNewLine()
   cINI := cINI + 'CHECKFORMTOOL ' + cFormTool + HB_OsNewLine()
   cINI := cINI + 'CHECKDBFTOOL ' + cDbfTool + HB_OsNewLine()
   cINI := cINI + 'OUTPUTCOPYMOVE ' + cOutputCopyMove + HB_OsNewLine()
   cINI := cINI + 'OUTPUTCOPYMOVEFOLDER ' + ChgPathToRelative( Prj_Text_OutputCopyMoveFolder ) + HB_OsNewLine()
   cINI := cINI + 'OUTPUTRENAME ' + cOutputRename + HB_OsNewLine()
   cINI := cINI + 'OUTPUTRENAMENEWNAME ' + Prj_Text_OutputRenameNewName + HB_OsNewLine()
   cINI := cINI + 'CHECKOUTPUTSUFFIX ' + if( Prj_Check_OutputSuffix , "YES" , "NO" ) + HB_OsNewLine()
   cINI := cINI + 'OUTPUTTYPE ' + cOutputType + HB_OsNewLine()
   cINI := cINI + 'CHECKREIMPORT ' + if( GetProperty( "VentanaMain" , "Check_Reimp" , "Value" ) , "YES" , "NO" ) + HB_OsNewLine()
   cINI := cINI + 'LIBREIMPORT ' + GetProperty( "VentanaMain" , "TReimportLib" , "Value" ) + HB_OsNewLine()
   cINI := cINI + 'IMPORTGUIONA ' + if( GetProperty( "VentanaMain" , "Check_GuionA" , "Value" ) , "YES" , "NO" ) + HB_OsNewLine()
   cINI := cINI + 'DBFAUTOVIEW ' + US_VarToStr( bDbfAutoView ) + HB_OsNewLine()
   cINI := cINI + 'EXTRARUNCMDFINAL ' + Prj_ExtraRunCmdFINAL + HB_OsNewLine()
   cINI := cINI + 'EXTRARUNPROJQPM ' + Prj_ExtraRunProjQPM + HB_OsNewLine()
   cINI := cINI + 'EXTRARUNCMDEXE ' + Prj_ExtraRunCmdEXE + HB_OsNewLine()
   cINI := cINI + 'EXTRARUNCMDFREE ' + Prj_ExtraRunCmdFREE + HB_OsNewLine()
   cINI := cINI + 'EXTRARUNQPMPARM ' + Prj_ExtraRunCmdQPMParm + HB_OsNewLine()
   cINI := cINI + 'EXTRARUNEXEPARM ' + Prj_ExtraRunCmdEXEParm + HB_OsNewLine()
   cINI := cINI + 'EXTRARUNFREEPARM ' + Prj_ExtraRunCmdFREEParm + HB_OsNewLine()
   cINI := cINI + 'EXTRARUNTYPE ' + Prj_ExtraRunType + HB_OsNewLine()
   cINI := cINI + 'EXTRARUNQPMRADIO '  + US_VarToStr( Prj_ExtraRunQPMRadio        ) + HB_OsNewLine()
   cINI := cINI + 'EXTRARUNQPMLITE '   + US_VarToStr( Prj_ExtraRunQPMLite         ) + HB_OsNewLine()
   cINI := cINI + 'EXTRARUNQPMFORCEFULL ' + US_VarToStr( Prj_ExtraRunQPMForceFull ) + HB_OsNewLine()
   cINI := cINI + 'EXTRARUNQPMRUN '    + US_VarToStr( Prj_ExtraRunQPMRun          ) + HB_OsNewLine()
   cINI := cINI + 'EXTRARUNQPMBUTTONRUN ' + US_VarToStr( Prj_ExtraRunQPMButtonRun ) + HB_OsNewLine()
   cINI := cINI + 'EXTRARUNQPMCLEAR '  + US_VarToStr( Prj_ExtraRunQPMClear        ) + HB_OsNewLine()
   cINI := cINI + 'EXTRARUNQPMLOG '    + US_VarToStr( Prj_ExtraRunQPMLog          ) + HB_OsNewLine()
   cINI := cINI + 'EXTRARUNQPMLOGONLYERROR ' + US_VarToStr( Prj_ExtraRunQPMLogOnlyError ) + HB_OsNewLine()
   cINI := cINI + 'EXTRARUNQPMAUTOEXIT ' + US_VarToStr( Prj_ExtraRunQPMAutoExit ) + HB_OsNewLine()
   cINI := cINI + 'EXTRARUNEXEWAIT ' + US_VarToStr( Prj_ExtraRunExeWait ) + HB_OsNewLine()
   cINI := cINI + 'EXTRARUNEXEPAUSE ' + US_VarToStr( Prj_ExtraRunExePause ) + HB_OsNewLine()
   cINI := cINI + 'EXTRARUNFREEWAIT ' + US_VarToStr( Prj_ExtraRunFreeWait ) + HB_OsNewLine()
   cINI := cINI + 'EXTRARUNFREEPAUSE ' + US_VarToStr( Prj_ExtraRunFreePause ) + HB_OsNewLine()
   //
// cINI := cINI + 'MI_CMAINAPPLNAME '           + US_VarToStr( PUB_MI_cMainApplName)        + HB_OsNewLine()
   cINI := cINI + 'MI_BEXEASSOCIATION '         + US_VarToStr( PUB_MI_bExeAssociation )     + HB_OsNewLine()
   cINI := cINI + 'MI_CEXEASSOCIATION '         + US_VarToStr( PUB_MI_cExeAssociation )     + HB_OsNewLine()
   cINI := cINI + 'MI_NEXEASSOCIATIONICON '     + US_VarToStr( PUB_MI_nExeAssociationIcon ) + HB_OsNewLine()
   cINI := cINI + 'MI_BEXEBACKUPOPTION '        + US_VarToStr( PUB_MI_bExeBackupOption )    + HB_OsNewLine()
   cINI := cINI + 'MI_BNEWFILE '                + US_VarToStr( PUB_MI_bNewFile )            + HB_OsNewLine()
   cINI := cINI + 'MI_NNEWFILESUGGESTED '       + US_VarToStr( PUB_MI_nNewFileSuggested )   + HB_OsNewLine()
   cINI := cINI + 'MI_CNEWFILELEYEND '          + US_VarToStr( PUB_MI_cNewFileLeyend )      + HB_OsNewLine()
   cINI := cINI + 'MI_NNEWFILEEMPTY '           + US_VarToStr( PUB_MI_nNewFileEmpty )       + HB_OsNewLine()
   cINI := cINI + 'MI_CNEWFILEUSERFILE '        + US_VarToStr( PUB_MI_cNewFileUserFile )    + HB_OsNewLine()
   cINI := cINI + 'MI_NDESTINATIONPATH '        + US_VarToStr( PUB_MI_nDestinationPath )    + HB_OsNewLine()
   cINI := cINI + 'MI_CDESTINATIONPATH '        + US_VarToStr( PUB_MI_cDestinationPath )    + HB_OsNewLine()
   cINI := cINI + 'MI_NLEYENDSUGGESTED '        + US_VarToStr( PUB_MI_nLeyendSuggested )    + HB_OsNewLine()
   cINI := cINI + 'MI_CLEYENDUSERTEXT '         + US_VarToStr( PUB_MI_cLeyendUserText )     + HB_OsNewLine()
   cINI := cINI + 'MI_BDESKTOPSHORTCUT '        + US_VarToStr( PUB_MI_bDesktopShortCut )    + HB_OsNewLine()
   cINI := cINI + 'MI_NDESKTOPSHORTCUT '        + US_VarToStr( PUB_MI_nDesktopShortCut )    + HB_OsNewLine()
   cINI := cINI + 'MI_BSTARTMENUSHORTCUT '      + US_VarToStr( PUB_MI_bStartMenuShortCut )  + HB_OsNewLine()
   cINI := cINI + 'MI_NSTARTMENUSHORTCUT '      + US_VarToStr( PUB_MI_nStartMenuShortCut )  + HB_OsNewLine()
   cINI := cINI + 'MI_BLAUNCHAPPLICATION '      + US_VarToStr( PUB_MI_bLaunchApplication )  + HB_OsNewLine()
   cINI := cINI + 'MI_NLAUNCHAPPLICATION '      + US_VarToStr( PUB_MI_nLaunchApplication )  + HB_OsNewLine()
   cINI := cINI + 'MI_BLAUNCHBACKUPOPTION '     + US_VarToStr( PUB_MI_bLaunchBackupOption ) + HB_OsNewLine()
   cINI := cINI + 'MI_BREBOOT '                 + US_VarToStr( PUB_MI_bReboot )             + HB_OsNewLine()
   cINI := cINI + 'MI_CDEFAULTLANGUAGE '        + US_VarToStr( PUB_MI_cDefaultLanguage )    + HB_OsNewLine()
   cINI := cINI + 'MI_NINSTALLERNAME '          + US_VarToStr( PUB_MI_nInstallerName )      + HB_OsNewLine()
   cINI := cINI + 'MI_CINSTALLERNAME '          + US_VarToStr( PUB_MI_cInstallerName )      + HB_OsNewLine()
   cINI := cINI + 'MI_CIMAGE '                  + US_VarToStr( PUB_MI_cImage )              + HB_OsNewLine()
   cINI := cINI + 'MI_BSELECTALLPRG '           + US_VarToStr( PUB_MI_bSelectAllPRG )       + HB_OsNewLine()
   cINI := cINI + 'MI_BSELECTALLHEA '           + US_VarToStr( PUB_MI_bSelectAllHEA )       + HB_OsNewLine()
   cINI := cINI + 'MI_BSELECTALLPAN '           + US_VarToStr( PUB_MI_bSelectAllPAN )       + HB_OsNewLine()
   cINI := cINI + 'MI_BSELECTALLDBF '           + US_VarToStr( PUB_MI_bSelectAllDBF )       + HB_OsNewLine()
   cINI := cINI + 'MI_BSELECTALLLIB '           + US_VarToStr( PUB_MI_bSelectAllLIB )       + HB_OsNewLine()
   For i := 1 To Len( PUB_MI_vFiles )
      MI_cFilesAux := US_VarToStr( PUB_MI_vFiles[ i ][ 1 ] )
      For j := 2 To Len( PUB_MI_vFiles[ i ] )
         MI_cFilesAux := MI_cFilesAux + " " + strtran( PUB_MI_vFiles[ i ][ j ] , " " , "|" )
      Next
      cINI := cINI + 'MI_CFILE ' + MI_cFilesAux + HB_OsNewLine()
   Next
   //
   cINI := cINI + 'SHGDATABASE ' + if( empty( SHG_Database ) , "*NONE*" , ChgPathToRelative( SHG_Database ) ) + HB_OsNewLine()
   cINI := cINI + 'SHGLASTFOLDERIMG ' + SHG_LastFolderImg + HB_OsNewLine()
   cINI := cINI + 'SHGOUTPUTTYPE ' + if( SHG_CheckTypeOutput , "YES" , "NO" ) + HB_OsNewLine()
   cINI := cINI + 'SHGHTMLFOLDER ' + SHG_HtmlFolder + HB_OsNewLine()
#ifdef QPM_SHG
   cINI := cINI + 'SHGWWW ' + VentanaMain.TWWWHlp.Value + HB_OsNewLine()
#endif
#ifdef QPM_HOTRECOVERY
   cINI := cINI + 'HOTLASTEXTERNALFILE ' + GBL_HR_cLastExternalFileName + HB_OsNewLine()
#endif
   For i := 1 To VentanaMain.GPrgFiles.ItemCount
      cForceRecomp := ""
      if GetProperty( "VentanaMain" , "GPRGFiles" , "Cell" , i , NCOLPRGRECOMP ) == "R"
         cForceRecomp := "<FR> "
      endif
      cINI := cINI + 'SOURCE ' + cForceRecomp + ChgPathToRelative( GetProperty( "VentanaMain" , "GPrgFiles" , "Cell" , i , NCOLPRGFULLNAME ) ) + HB_OsNewLine()
   Next i
   For i := 1 To VentanaMain.GHeaFiles.ItemCount
      cINI := cINI + 'HEAD ' + ChgPathToRelative( GetProperty( "VentanaMain" , "GHeaFiles" , "Cell" , i , NCOLHEAFULLNAME ) ) + HB_OsNewLine()
   Next i
   For i := 1 To VentanaMain.GPanFiles.ItemCount
      cINI := cINI + 'FORM ' + ChgPathToRelative( GetProperty( "VentanaMain" , "GPanFiles" , "Cell" , i , NCOLPANFULLNAME ) ) + HB_OsNewLine()
   Next i
   For i := 1 To VentanaMain.GDbfFiles.ItemCount
      cINI := cINI + 'DBF ' + ChgPathToRelative( GetProperty( "VentanaMain" , "GDbfFiles" , "Cell" , i , NCOLDBFFULLNAME ) ) + HB_OsNewLine()
   Next i
   DesCargoIncludeLibs( GetSuffix() )
   For i=1 to len( vSuffix )
      For j = 1 to len( &( 'IncludeLibs'+vSuffix[i][1] ) )
         cINI := cINI + 'INCLUDE' + vSuffix[i][1] + ' ' + US_Word( &( 'IncludeLibs'+vSuffix[i][1]+'['+str(j)+']' ) , 1 ) + ' ' + US_Word( &( 'IncludeLibs'+vSuffix[i][1]+'['+str(j)+']' ) , 2 ) + ' ' + ChgPathToRelative( US_WordSubstr( &( 'IncludeLibs'+vSuffix[i][1]+'['+str(j)+']' ) , 3 ) ) + HB_OsNewLine()
      Next
   Next
   DescargoExcludeLibs( GetSuffix() )
   For i=1 to len( vSuffix )
      For j = 1 to len( &( 'ExcludeLibs'+vSuffix[i][1] ) )
         cINI := cINI + 'EXCLUDE' + vSuffix[i][1] + ' ' + alltrim( &( 'ExcludeLibs'+vSuffix[i][1]+'['+str(j)+']' ) ) + HB_OsNewLine()
      Next
   Next
   if bCheck
      MemoAux       := MemoRead( PUB_cProjectFile )
      LineasProject := MLCount( MemoAux , 254 )
      LineasC       := MLCount( cINI , 254 )
      if !( LineasC == LineasProject )
         bDiff := .T.
      else
         bDiff := .F.
         For i := 1 to LineasC
            if !( alltrim( memoline( cINI , 254 , i ) ) == alltrim( memoline( MemoAux , 254 , i ) ) ) .and. ;
               !( US_Word( memoline( MemoAux , 254 , i ) , 1 ) == "PRJ_VERSION" .and. ;
                  US_Word( memoline( MemoAux , 254 , i ) , 1 ) == "PRJ_VERSION" )
               bDiff := .T.
            endif
         next
      endif
      if bDiff
         if !bAutoExit
            if MyMsgYesNo('Save changes of project "' + US_FileNameOnlyNameAndExt( PUB_cProjectFile) + '" ?')
               if empty( PUB_cProjectFile )
                  QPM_SaveAsProject( .T. )
               else
                  QPM_ProjectFileUnLock()
                  QPM_MemoWrit( PUB_cProjectFile , cINI )
                  bWrite := .T.
                  QPM_ProjectFileLock( PUB_cProjectFile )
               endif
            endif
         endif
      endif
      if !bWrite .and. ;
         !( cPrj_VersionAnt == GetPrjVersion() )
         QPM_ProjectFileUnLock()
         ReplacePrjVersion( PUB_cProjectFile , MakePrj_Version() )
         QPM_ProjectFileLock( PUB_cProjectFile )
      endif
   else
      QPM_ProjectFileUnLock()
      QPM_MemoWrit( PUB_cProjectFile , cINI )
      bWrite := .T.
      QPM_ProjectFileLock( PUB_cProjectFile )
   endif
Return .T.

Function MakePrj_Version()
Return substr( GetPrjVersion() , 1 , 2 ) + " " + substr( GetPrjVersion() , 3 , 2 ) + " " + substr( GetPrjVersion() , 5 , 4 )

Function CargoIncludeLibs( tipo )
   Local i
   VentanaMain.GIncFiles.DeleteAllItems
   For i=1 to len( &('IncludeLibs'+tipo) )
      VentanaMain.GIncFiles.AddItem( { PUB_nGridImgNone , US_FileNameOnlyNameAndExt( &('IncludeLibs'+tipo+'['+str(i)+']') ) , "* " + &('IncludeLibs'+tipo+'['+str(i)+']') } )
      LibPos( VentanaMain.GIncFiles.itemcount )
      if ascan( &("vExtraFoldersForLibs"+GetSuffix()) , upper( US_FileNameOnlyPath( ChgPathToReal( US_WordSubStr( &('IncludeLibs'+tipo+'['+str(i)+']') , 2 ) ) ) ) ) = 0
         aadd( &("vExtraFoldersForLibs"+GetSuffix()) , upper( US_FileNameOnlyPath( ChgPathToReal( US_WordSubStr( &('IncludeLibs'+tipo+'['+str(i)+']') , 2 ) ) ) ) )
      endif
   Next
   LibsActiva := tipo
   if VentanaMain.GDbfFiles.Value = 0
      VentanaMain.GDbfFiles.Value := 1
   endif
Return .t.

Function DesCargoIncludeLibs( tipo )
   Local i
   &('IncludeLibs'+tipo) := {}
   For i=1 to VentanaMain.GIncFiles.ItemCount
      AADD( &('IncludeLibs'+tipo) , us_word( GetProperty( "VentanaMain" , "GIncFiles" , "Cell" , i , NCOLINCFULLNAME ) , 2 ) + " " + US_WordSubStr( GetProperty( "VentanaMain" , "GIncFiles" , "Cell" , i , NCOLINCFULLNAME ) , 3 ) )
   Next
   VentanaMain.RichEditLib.Value := ""
   VentanaMain.GDbfFiles.Value := 0
Return .t.

Function CargoExcludeLibs( tipo )
   Local i
   VentanaMain.GExcFiles.DeleteAllItems
   For i=1 to len( &('ExcludeLibs'+tipo) )
      VentanaMain.GExcFiles.AddItem( { PUB_nGridImgNone , &('ExcludeLibs'+tipo+'['+str(i)+']') } )
   Next
   LibsActiva := tipo
Return .t.

Function DescargoExcludeLibs( tipo )
   Local i
   &('ExcludeLibs'+tipo) := {}
   For i=1 to VentanaMain.GExcFiles.ItemCount
      AADD( &('ExcludeLibs'+tipo) , GetProperty( "VentanaMain" , "GExcFiles" , "Cell" , i , NCOLEXCNAME ) )
   Next
Return .t.

Function QPM_SaveAsProject( isNew )
   // QPM_SaveAsProject2
   Local TmpName
   If Empty ( PUB_cProjectFile ) .and. empty( isNew )
      MsgStop('You must open project first')
      Return ""
   EndIf
   TmpName := alltrim ( PutFile( { {'QPM Project Files (*.qpm)','*.qpm'} } , if( !empty( isNew ) .and. isNew , 'Create New Project' , 'Save Project' ) , cLastProjectFolder , .T. ) )
   If !Empty(TmpName)
      If !( US_Upper( US_FileNameOnlyExt(Tmpname) ) == US_Upper( 'QPM' ) )
         TmpName := TmpName + '.qpm'
      EndIf
      PUB_cProjectFile := TmpName
      if !empty( isNew ) .and. isNew
         VentanaMain.TProjectFolder.Value := US_FileNameOnlyPath( TmpName )
      // PUB_cProjectFile := US_FileNameOnlyName( TmpName )
      endif
      PUB_cThisFolder := US_FileNameOnlyPath( PUB_cProjectFile )
      VentanaMain.Title := 'QPM (QAC Based Project Manager) - Project Manager for MiniGui ('+PUB_cQPM_VersionDisplay+') [ ' + alltrim ( PUB_cProjectFile ) + ' ]'
      QPM_SaveProject()
      cLastProjectFolder := US_FileNameOnlyPath( TmpName )
   // if empty( PUB_cAutoLog )
   //    PUB_cAutoLog := US_FileNameOnlyPathAndName( TmpName ) + ".LOG"
   // endif
   EndIf
Return TmpName

Function QPM_Exit()
   // QPM_Exit2
   if bWaitForBuild
      do while !bBuildFinished
         DO EVENTS
      enddo
   endif
#ifdef QPM_SHG
   if QPM_Wait( 'SHG_CheckSave()' , "Checking changes in Hlp Topics..." )
      if SHG_BaseOk
         if US_FileSize( US_FileNameOnlyPathAndName( SHG_Database ) + ".dbt" ) > SHG_DbSize
            QPM_Wait( 'SHG_PackDatabase()' )
         endif
      endif
      if !PUB_bLite .and. !bWaitForBuild .and. ( !empty( PUB_cProjectFile ) .or. !empty( PUB_cProjectFolder ) )
         r := MyMsgYesNo ('Are you sure ?','Exit QPM')
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
      QPM_Wait( "QPM_SaveProject( .T. )" , "Checking for save..." )
      CloseDbfAutoView()
      DoMethod( "VentanaMain" , "Release" )
   EndIf
   QPM_ProjectFileUnLock()
// ferase( PUB_cQPM_Folder + DEF_SLASH + "hha.dll" )
// ferase( PUB_cQPM_Folder + DEF_SLASH + "dtoolbar.dbf" )
// ferase( PUB_cQPM_Folder + DEF_SLASH + "hmi.ini" )
// ferase( PUB_cQPM_Folder + DEF_SLASH + "dbfview.ini" )
// ferase( PUB_cQPM_Folder + DEF_SLASH + "dbfview.lng" )
Return .F.

Function QPM_Build()
Return QPM_Wait( "QPM_Build2()" , "Prepare for build..." )

Function QPM_Build2()
   Local bIsCpp := .F.
   Local MakeName
   Local ParamString
   Local Out := ''
   Local i
   Local w_hay, w_group
   Local nLastExtraFolderSearchAdded := 0
   Local bExtraFolderSearchRoot      := .F.
   Local RUNFOLDER         := alltrim(US_FileNameOnlyPath(VentanaMain.TRunProjectFolder.Value))
   Local XHARBOURSUPPORT   := if(Prj_Radio_Harbour==DEF_RG_HARBOUR,.F.,.T.)
// No Borrar  Local XHARBOURMTSUPPORT := Prj_Check_34
   Local MemoAux := ""
   Local MemoObj := ""
   Local cInputReImpName := ""
   Local cInputReImpNameOnly := ""
   Local cInputReImpNameDisplay := ""
   Local cExtraFoldersHB := ""
   Local cExtraFoldersC := ""
   Local cResourceFileName
   Local CCOMPILERFOLDER := US_ShortName( &( "Gbl_T_C_"+GetMiniGuiSuffix()+GetCppSuffix() ) ) + DEF_SLASH + "BIN"

   BUILD_IN_PROGRESS := .T.
   LiberoWindowsHotKeys(.F.)

   if Empty ( PUB_cProjectFile )
      MsgStop('You must save project first !!!')
      BUILD_IN_PROGRESS := .F.
      DefinoWindowsHotKeys( .F. )
      Return .T.
   EndIf

   QPM_CargoLibraries()

   Private UOW                := dtos(date())+US_strCero(int(seconds()),5)
   Private PRGFILES           := {}
   Private HeaFILES           := {}
   Private PanFILES           := {}
   Private DbfFILES           := {}
   Private vLibIncludeFiles   := {}
   Private vLibExcludeFiles   := {}
   Private vDebugPath         := {}
   Private cDebugPath         := ""
   Private cInputName         := ""
   Private cInputNameDisplay  := ""
   Private cInputNameLong     := ""
   Private cOutputName        := ""
   Private cOutputNameDisplay := ""
   Private vConcatIncludeHB   := {}
   Private vConcatIncludeC    := {}
   Private OBJFOLDER          := PUB_cProjectFolder + If( !( Right( PUB_cProjectFolder , 1 ) == DEF_SLASH ) , DEF_SLASH , '' ) + GetObjName()
   //
   bConvert := .F.
   cConvert := ""
   //
   PUB_bForceRunFromMsgOk := .F.

   if bRunApp
      MsgStop( 'Program Running !!!!, you need to stop or kill the process before rebuild.' )
      BUILD_IN_PROGRESS := .F.
      DefinoWindowsHotKeys( .F. )
      Return .F.
   endif

   VentanaMain.TabFiles.Value := nPageSysout
   TabChange( "FILES" )

   Declare vTemp[ ADIR( PUB_cProjectFolder + DEF_SLASH + '_'+replicate('?',13)+PUB_cCharFileNameTemp+'*.*' ) ]
   Declare vTemp2[ ADIR( GetCppFolder() + DEF_SLASH + 'BIN' + DEF_SLASH + '_'+replicate('?',13)+PUB_cCharFileNameTemp+'*.*' ) ]
   Declare vTemp3[ ADIR( substr( GetCppFolder() , 1 , 2 ) + DEF_SLASH + '_'+replicate('?',13)+PUB_cCharFileNameTemp+'*.*' ) ]
   ADIR( PUB_cProjectFolder + DEF_SLASH + '_'+replicate('?',13)+PUB_cCharFileNameTemp+'*.*' , vTemp )
   ADIR( GetCppFolder() + DEF_SLASH + 'BIN' + DEF_SLASH + '_'+replicate('?',13)+PUB_cCharFileNameTemp+'*.*' , vTemp2 )
   ADIR( substr( GetCppFolder() , 1 , 2 ) + DEF_SLASH + '_'+replicate('?',13)+PUB_cCharFileNameTemp+'*.*' , vTemp3 )
   For i=1 to len( vTemp )
      vTemp[i] := PUB_cProjectFolder + DEF_SLASH + vTemp[i]
   next
   For i=1 to len( vTemp2 )
      AADD( vTemp , GetCppFolder() + DEF_SLASH + 'BIN' + DEF_SLASH + vTemp2[i] )
   next
   For i=1 to len( vTemp3 )
      AADD( vTemp , substr( GetCppFolder() , 1 , 2 ) + DEF_SLASH + vTemp3[i] )
   next
   For i=1 to len( vTemp )
      if val( substr( US_FileNameOnlyName( vTemp[i] ) , 2 , 13 ) ) < ( val( substr( PUB_cSecu , 1 , 13 ) ) - 100000 )
         ferase( vTemp[i] )
      endif
   next

   if Prj_Radio_OutputType == DEF_RG_IMPORT
      bConvert := .T.
      cConvert := upper( US_FileNameOnlyExt( ChgPathToReal( GetProperty( "VentanaMain" , "GPrgFiles" , "Cell" , 1 , NCOLPRGFULLNAME ) ) ) ) + ' ' + OutputExt()
      cInputName := US_ShortName( ChgPathToReal( GetProperty( "VentanaMain" , "GPrgFiles" , "Cell" , 1 , NCOLPRGFULLNAME ) ) )
      cInputNameDisplay := ChgPathToReal( GetProperty( "VentanaMain" , "GPrgFiles" , "Cell" , 1 , NCOLPRGFULLNAME ) )
      cInputNameLong := US_FileNameOnlyPath( cInputName ) + DEF_SLASH + US_FileNameOnlyNameAndExt( cInputNameDisplay )
      if GetProperty( "VentanaMain" , "Check_Reimp" , "Value" )
         if !file( ChgPathToReal( GetProperty( "VentanaMain" , "TReimportLib" , "Value" ) ) )
            MsgStop( 'Library for ReImport Not Found: ' + ChgPathToReal( GetProperty( "VentanaMain" , "TReimportLib" , "Value" ) ) )
            BUILD_IN_PROGRESS := .F.
            DefinoWindowsHotKeys( .F. )
            Return .F.
         endif
         cInputReImpName := US_ShortName( ChgPathToReal( GetProperty( "VentanaMain" , "TReimportLib" , "Value" ) ) )
         cInputReImpNameDisplay := ChgPathToReal( GetProperty( "VentanaMain" , "TReimportLib" , "Value" ) )
         cInputReImpDef := US_ShortName(GetCppFolder()) + DEF_SLASH + 'BIN' + DEF_SLASH + US_FileNameOnlyName( GetProperty( "VentanaMain" , "TReimportLib" , "Value" ) )
      endif
   endif

   if OutputExt() == "LIB" .and. at( "-" , US_ShortName( PUB_cProjectFolder ) ) > 0
      MsgStop( "Utility TLIB.exe of Borland don't work correctly with a file path with slash characters ('-')." + HB_OsNewLine() + ;
               "Please, change name of Project Folder: " + PUB_cProjectFolder )
      BUILD_IN_PROGRESS := .F.
      DefinoWindowsHotKeys( .F. )
      Return .F.
   endif

   if at( "(" , US_ShortName( PUB_cProjectFolder ) ) > 0 .or. ;
      at( ")" , US_ShortName( PUB_cProjectFolder ) ) > 0
      MsgStop( "Utility US_MAKE.exe doesn't work correctly with a file path with this characters: ( )" + HB_OsNewLine() + ;
               "Please, change name folders." )
      BUILD_IN_PROGRESS := .F.
      DefinoWindowsHotKeys( .F. )
      Return .F.
   endif
   
   DO EVENTS

   For i=1 to VentanaMain.GIncFiles.itemcount
      LibCheck( i )
   next
   if bLogActivity
      QPM_MemoWrit( PUB_cQPM_Folder+DEF_SLASH + "QPM.log" , memoread( PUB_cQPM_Folder+DEF_SLASH + "QPM.log" ) + HB_OSNewLine() + replicate( ">" ,80 ) )
      QPM_MemoWrit( PUB_cQPM_Folder+DEF_SLASH + "QPM.log" , memoread( PUB_cQPM_Folder+DEF_SLASH + "QPM.log" ) + HB_OSNewLine() + replicate( ">" ,80 ) )
   endif

   PUB_xHarbourMT := ""
   if QPM_IsXHarbour()
      * No Borrar          if Prj_Check_34
      * No Borrar             PUB_xHarbourMT := "MT"
      * No Borrar          endif
   endif
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
         US_Log( "Error 5288" )
   endcase

// NOTE: added support for MINGW and Extended: the resource file in Extended with MinGW is named hmg.rc
   if Getminiguisuffix() == DefineExtended1 .and. IsMinGW
     cResourceFileName := "hmg"
   else
     cResourceFileName := substr( US_FileNameOnlyName( GetMiniGuiName() ), 4 )
   endif

   do case
      case cOutputRename == "NEWNAME" .and. Empty ( Prj_Text_OutputRenameNewName )
         MsgStop ( 'Name for New Output file Name is empty.  Look at ' + PUB_MenuPrjOptions + ' of Settings menu.')
         BUILD_IN_PROGRESS := .F.
         DefinoWindowsHotKeys( .F. )
         Return .F.
      case !( cOutputCopyMove == "NONE" ) .and. Empty ( Prj_Text_OutputCopyMoveFolder )
         MsgStop ( 'Folder for Copy / Move output file is empty.  Look at ' + PUB_MenuPrjOptions + ' of Settings menu.')
         BUILD_IN_PROGRESS := .F.
         DefinoWindowsHotKeys( .F. )
         Return .F.
      case !( cOutputCopyMove == "NONE" ) .and. !US_IsDirectory( Prj_Text_OutputCopyMoveFolder )
         MsgStop ( 'Folder for Copy / Move not valid: ' + Prj_Text_OutputCopyMoveFolder + '. Look at ' + PUB_MenuPrjOptions + ' of Settings menu.')
         BUILD_IN_PROGRESS := .F.
         DefinoWindowsHotKeys( .F. )
         Return .F.
      case Empty ( PUB_cProjectFolder )
         MsgStop ( 'Project Folder is empty. Look at ' + PagePRG)
         BUILD_IN_PROGRESS := .F.
         DefinoWindowsHotKeys( .F. )
         Return .F.
      case Empty ( GetProperty( "VentanaMain" , "GPrgFiles" , "Cell" , 1 , NCOLPRGFULLNAME ) )
         MsgStop ( 'PRG List is empty. Look at ' + PagePRG)
         BUILD_IN_PROGRESS := .F.
         DefinoWindowsHotKeys( .F. )
         Return .F.
      case !Empty( PUB_cProjectFolder ) .and. !US_IsDirectory( US_ShortName( PUB_cProjectFolder ) )
         MsgStop ( 'ProjectFolder '+PUB_cProjectFolder+' not found !!!!. Look at ' + PagePRG)
         BUILD_IN_PROGRESS := .F.
         DefinoWindowsHotKeys( .F. )
         Return .F.
      case empty( GetMiniGuiFolder() )
         MsgStop ( 'Folder for Minigui in ' + vSuffix[ AScan( vSuffix , { |x| x[1] == GetSuffix() } ) ][2] + ' is empty. Look at ' + PUB_MenuGblOptions + ' of Settings menu.')
         BUILD_IN_PROGRESS := .F.
         DefinoWindowsHotKeys( .F. )
         Return .F.
      case empty( GetCppFolder() )
         MsgStop ( 'Folder for C++ Compiler in ' + vSuffix[ AScan( vSuffix , { |x| x[1] == GetSuffix() } ) ][2] + ' is empty. Look at ' + PUB_MenuGblOptions + ' of Settings menu.')
         BUILD_IN_PROGRESS := .F.
         DefinoWindowsHotKeys( .F. )
         Return .F.
      case !QPM_IsXHarbour() .and. empty( GetHarbourFolder() )
         MsgStop ( 'Folder for Harbour in ' + vSuffix[ AScan( vSuffix , { |x| x[1] == GetSuffix() } ) ][2] + ' is empty. Look at ' + PUB_MenuGblOptions + ' of Settings menu.')
         BUILD_IN_PROGRESS := .F.
         DefinoWindowsHotKeys( .F. )
         Return .F.
      case QPM_IsXHarbour() .and. empty( GetHarbourFolder() )
         MsgStop ( 'Folder for xHarbour in ' + vSuffix[ AScan( vSuffix , { |x| x[1] == GetSuffix() } ) ][2] + ' is empty. Look at ' + PUB_MenuGblOptions + ' of Settings menu.')
         BUILD_IN_PROGRESS := .F.
         DefinoWindowsHotKeys( .F. )
         Return .F.
      case !Empty(  GetMiniGuiFolder() ) .and. !QPM_DirValid( US_ShortName( GetMiniGuiFolder() ) , GetMiniGuiSuffix()+GetCppSuffix() )
         MsgStop ( 'Minigui Folder is not valid. Look at ' + PUB_MenuGblOptions + ' of Settings menu.')
         BUILD_IN_PROGRESS := .F.
         DefinoWindowsHotKeys( .F. )
         Return .F.
      case !Empty(  GetCppFolder() ) .and. !QPM_DirValid( US_ShortName( GetCppFolder() ) , "C_"+GetMiniGuiSuffix()+GetCppSuffix() )
         MsgStop ( 'C++ Compiler Folder is not valid. Look at ' + PUB_MenuGblOptions + ' of Settings menu.')
         BUILD_IN_PROGRESS := .F.
         DefinoWindowsHotKeys( .F. )
         Return .F.
      case !Empty(  GetHarbourFolder() ) .and. !QPM_IsXHarbour() .and. !QPM_DirValid( US_ShortName( GetHarbourFolder() ) , GetSuffix() )
         MsgStop ( 'Harbour Folder is not valid. Look at ' + PUB_MenuGblOptions + ' of Settings menu.')
         BUILD_IN_PROGRESS := .F.
         DefinoWindowsHotKeys( .F. )
         Return .F.
      case !Empty(  GetHarbourFolder() ) .and. QPM_IsXHarbour() .and. !QPM_DirValid( US_ShortName( GetHarbourFolder() ) , GetSuffix() )
         MsgStop ( 'xHarbour Folder is not valid. Look at ' + PUB_MenuGblOptions + ' of Settings menu.')
         BUILD_IN_PROGRESS := .F.
         DefinoWindowsHotKeys( .F. )
         Return .F.
   endcase

   DO EVENTS

   For i := 1 To VentanaMain.GPrgFiles.ItemCount
      if upper( US_FileNameOnlyExt( ChgPathToReal( GetProperty( "VentanaMain" , "GPrgFiles" , "Cell" , i , NCOLPRGFULLNAME ) ) ) ) == "CPP"
         bIsCpp := .T.
      endif
      if ascan( PRGFILES , { |x| US_Upper( US_FileNameOnlyName( x ) ) == US_Upper( US_FileNameOnlyName( alltrim(GetProperty( "VentanaMain" , "GPrgFiles" , "Cell" , i , NCOLPRGFULLNAME )) ) ) } ) > 0
         MsgStop( "Duplicate file name '"+US_FileNameOnlyName( alltrim(GetProperty( "VentanaMain" , "GPrgFiles" , "Cell" , i , NCOLPRGFULLNAME )) )+"' in diferent directories or with diferent extensions (.PRG and .C)."+HB_OsNewLine()+"The object generated for the second file will override the object of the previous file." )
         BUILD_IN_PROGRESS := .F.
         DefinoWindowsHotKeys( .F. )
         Return .F.
      endif
      aadd ( PRGFILES , ChgPathToReal( GetProperty( "VentanaMain" , "GPrgFiles" , "Cell" , i , NCOLPRGFULLNAME ) ) )

      if ! file( PRGFILES[ i ] )
         MsgStop( "File '" + PRGFILES[ i ] + "' not found !!!" )
         BUILD_IN_PROGRESS := .F.
         DefinoWindowsHotKeys( .F. )
         Return .F.
      endif
      
      if PUB_bDebugActive
         if ascan( vDebugPath , { |x| US_Upper( x ) == US_Upper( alltrim( US_FileNameOnlyPath( PRGFILES[ i ] ) ) ) } ) == 0
            aadd ( vDebugPath , alltrim( US_FileNameOnlyPath( PRGFILES[ i ] ) ) )
         endif
      endif
   Next i

   DO EVENTS

   if PUB_bDebugActive
      aeval( vDebugPath , { |x| cDebugPath := cDebugPath + x + ";" } )
      cDebugPath := cDebugPath + DEF_SLASH
   endif
   if !bAutoExit
      if bIsCpp .and. GetCppSuffix() == DefinePelles
         MsgStop( "Error, your project include C++ files and Pelles C does not support it." )
         BUILD_IN_PROGRESS := .F.
         DefinoWindowsHotKeys( .F. )
         Return .F.
      endif
      if bIsCpp .and. bWarningCpp .and. GetCppSuffix() == DefineMinGW
         MsgInfo( "Warning, your project includes C++ files.  You need to download a full version of MinGW." )
         bWarningCpp := .F.
      endif
   endif

   DO EVENTS

   For i := 1 To VentanaMain.GPanFiles.ItemCount
      if ascan( PanFILES , { |x| US_Upper( US_FileNameOnlyNameAndExt( x ) ) == US_Upper( US_FileNameOnlyNameAndExt( alltrim(GetProperty( "VentanaMain" , "GPanFiles" , "Cell" , i , NCOLPANFULLNAME )) ) ) } ) > 0
         MsgStop( "Duplicate Form name '"+US_FileNameOnlyNameAndExt( alltrim(GetProperty( "VentanaMain" , "GPanFiles" , "Cell" , i , NCOLPANFULLNAME )) )+"' in diferents directories"+HB_OsNewLine()+"Process canceled." )
         BUILD_IN_PROGRESS := .F.
         DefinoWindowsHotKeys( .F. )
         Return .F.
      endif
      aadd ( PANFILES , ChgPathToReal( GetProperty( "VentanaMain" , "GPanFiles" , "Cell" , i , NCOLPANFULLNAME ) ) )
      if !file( PanFILES[ i ] )
         MsgStop( "Form '"+PanFILES[ i ]+"' not found" )
         BUILD_IN_PROGRESS := .F.
         DefinoWindowsHotKeys( .F. )
         Return .F.
      endif
   Next i

   DO EVENTS

   For i := 1 To VentanaMain.GHeaFiles.ItemCount
      if ascan( HeaFILES , { |x| US_Upper( US_FileNameOnlyNameAndExt( x ) ) == US_Upper( US_FileNameOnlyNameAndExt( alltrim(GetProperty( "VentanaMain" , "GHeaFiles" , "Cell" , i , NCOLHEAFULLNAME )) ) ) } ) > 0
         MsgStop( "Duplicate Header name '"+US_FileNameOnlyNameAndExt( alltrim(GetProperty( "VentanaMain" , "GHeaFiles" , "Cell" , i , NCOLHEAFULLNAME )) )+"' in diferents directories"+HB_OsNewLine()+"Process canceled." )
         BUILD_IN_PROGRESS := .F.
         DefinoWindowsHotKeys( .F. )
         Return .F.
      endif
      aadd ( HeaFILES , ChgPathToReal( GetProperty( "VentanaMain" , "GHeaFiles" , "Cell" , i , NCOLHEAFULLNAME ) ) )
      if !file( HeaFILES[ i ] )
         MsgStop( "Header (Include) '"+HeaFILES[ i ]+"' not found." )
         BUILD_IN_PROGRESS := .F.
         DefinoWindowsHotKeys( .F. )
         Return .F.
      endif
   Next i

   DO EVENTS

   For i := 1 To VentanaMain.GIncFiles.ItemCount
      aadd ( vLibIncludeFiles , ChgPathToReal( US_WordSubStr( GetProperty( "VentanaMain" , "GIncFiles" , "Cell" , i , NCOLINCFULLNAME ) , 3 ) ) )
      if ! file( vLibIncludeFiles[ i ] )
         MsgStop( "File '" + vLibIncludeFiles[ i ] + "' not found !!!" )
         BUILD_IN_PROGRESS := .F.
         DefinoWindowsHotKeys( .F. )
         Return .F.
      endif
   Next i
   For i := 1 To VentanaMain.GExcFiles.ItemCount
      aadd ( vLibExcludeFiles , US_Upper( alltrim( GetProperty( "VentanaMain" , "GExcFiles" , "Cell" , i , NCOLEXCNAME ) ) ) )
   Next i

   aadd( vConcatIncludeHB , US_ShortName( GetHarbourFolder() ) + DEF_SLASH + 'INCLUDE' )
   aadd( vConcatIncludeHB , US_ShortName( GetMiniGuiFolder() ) + DEF_SLASH + 'INCLUDE' )
   aadd( vConcatIncludeHB , US_ShortName( PUB_cProjectFolder ) )

   aadd( vConcatIncludeC  , US_ShortName( GetCppFolder() ) + DEF_SLASH + 'INCLUDE' )
   if IsPelles
      aadd( vConcatIncludeC  , US_ShortName( GetCppFolder() ) + DEF_SLASH + 'INCLUDE'+DEF_SLASH+'WIN' )
   endif
   aadd( vConcatIncludeC  , US_ShortName( GetHarbourFolder() ) + DEF_SLASH + 'INCLUDE' )
   aadd( vConcatIncludeC  , US_ShortName( GetMiniGuiFolder() ) + DEF_SLASH + 'INCLUDE' )
   aadd( vConcatIncludeC  , US_ShortName( PUB_cProjectFolder ) )

   For i := 1 to len( vConcatIncludeHB )
      if US_IsRootFolder( vConcatIncludeHB[ i ] )
         bExtraFolderSearchRoot := .T.
      else
         bExtraFolderSearchRoot := .F.
      endif
      do case
         case IsMinGW
            cExtraFoldersHB := cExtraFoldersHB + if( i==1 , "" , ";" ) + US_ShortName( vConcatIncludeHB[i] ) + if( bExtraFolderSearchRoot , DEF_SLASH , "" )
         otherwise
            cExtraFoldersHB := cExtraFoldersHB + if( i==1 , "" , ";" ) + US_ShortName( vConcatIncludeHB[i] ) + if( bExtraFolderSearchRoot , DEF_SLASH , "" )
      endcase
   Next i

   DO EVENTS

   For i := 1 to len( vConcatIncludeC )
      if US_IsRootFolder( vConcatIncludeC[ i ] )
         bExtraFolderSearchRoot := .T.
      else
         bExtraFolderSearchRoot := .F.
      endif
      do case
         case IsMinGW
            cExtraFoldersC  := cExtraFoldersC  + if( i==1 , "" , " -I" ) + US_ShortName( vConcatIncludeC[i] ) + if( bExtraFolderSearchRoot , DEF_SLASH , "" )
         case IsPelles
            cExtraFoldersC  := cExtraFoldersC  + if( i==1 , "" , " /I" ) + US_ShortName( vConcatIncludeC[i] ) + if( bExtraFolderSearchRoot , DEF_SLASH , "" )
         case IsBorland
            cExtraFoldersC  := cExtraFoldersC  + if( i==1 , "" , ";" ) + US_ShortName( vConcatIncludeC[i] ) + if( bExtraFolderSearchRoot , DEF_SLASH , "" )
         otherwise
            US_Log( "Error 5445")
      endcase
   Next i

   DO EVENTS

   For i := 1 to len( vExtraFoldersForSearch )
      if !empty( vExtraFoldersForSearch[i] )
         nLastExtraFolderSearchAdded := i
         if US_IsRootFolder( vExtraFoldersForSearch[ i ] )
            bExtraFolderSearchRoot := .T.
         else
            bExtraFolderSearchRoot := .F.
         endif
         aadd( vConcatIncludeHB , vExtraFoldersForSearch[i] )
     //  aadd( vConcatIncludeHB , vExtraFoldersForSearch[i] + if( bExtraFolderSearchRoot , DEF_SLASH , "" ) )
         aadd( vConcatIncludeC  , vExtraFoldersForSearch[i] )
     //  aadd( vConcatIncludeC  , vExtraFoldersForSearch[i] + if( bExtraFolderSearchRoot , DEF_SLASH , "" ) )
         do case
            case IsMinGW
               cExtraFoldersHB := cExtraFoldersHB + ";" + US_ShortName( vExtraFoldersForSearch[i] ) + if( bExtraFolderSearchRoot , DEF_SLASH , "" )
               cExtraFoldersC  := cExtraFoldersC  + " -I" + US_ShortName( vExtraFoldersForSearch[i] ) + if( bExtraFolderSearchRoot , DEF_SLASH , "" )
            case IsPelles
               cExtraFoldersHB := cExtraFoldersHB + ";" + US_ShortName( vExtraFoldersForSearch[i] ) + if( bExtraFolderSearchRoot , DEF_SLASH , "" )
               cExtraFoldersC  := cExtraFoldersC  + " /I" + US_ShortName( vExtraFoldersForSearch[i] ) + if( bExtraFolderSearchRoot , DEF_SLASH , "" )
            case IsBorland
               cExtraFoldersHB := cExtraFoldersHB + ";" + US_ShortName( vExtraFoldersForSearch[i] ) + if( bExtraFolderSearchRoot , DEF_SLASH , "" )
               cExtraFoldersC  := cExtraFoldersC  + ";" + US_ShortName( vExtraFoldersForSearch[i] ) + if( bExtraFolderSearchRoot , DEF_SLASH , "" )
            otherwise
               US_Log( "Error 5464" )
         endcase
      endif
   Next i
   // INI - El siguiente es un parche para cuando el ultimo folder a agregar en Search es del formato "C:",
   //       ya que hay que agregarle algun folder del formato "C:\xxxxx" para que no cancele
   if US_IsRootFolder( vExtraFoldersForSearch[ nLastExtraFolderSearchAdded ] )
    //aadd( vConcatIncludeHB , DiskName() + ":" + DEF_SLASH + "_" + PUB_cSecu + "SearchBug" )
    //aadd( vConcatIncludeC  , DiskName() + ":" + DEF_SLASH + "_" + PUB_cSecu + "SearchBug" )
      do case
         case IsMinGW
            cExtraFoldersHB := cExtraFoldersHB + ";" + DiskName() + ":" + DEF_SLASH + "_" + PUB_cSecu + "SearchBug"
            cExtraFoldersC  := cExtraFoldersC  + " -I" + DiskName() + ":" + DEF_SLASH + "_" + PUB_cSecu + "SearchBug"
         case IsPelles
            cExtraFoldersHB := cExtraFoldersHB + ";" + DiskName() + ":" + DEF_SLASH + "_" + PUB_cSecu + "SearchBug"
            cExtraFoldersC  := cExtraFoldersC  + " /I" + DiskName() + ":" + DEF_SLASH + "_" + PUB_cSecu + "SearchBug"
         case IsBorland
            cExtraFoldersHB := cExtraFoldersHB + ";" + DiskName() + ":" + DEF_SLASH + "_" + PUB_cSecu + "SearchBug"
            cExtraFoldersC  := cExtraFoldersC  + ";" + DiskName() + ":" + DEF_SLASH + "_" + PUB_cSecu + "SearchBug"
         otherwise
            US_Log( "Error 5465" )
      endcase
   endif
   // END Parche

   DO EVENTS

   DELETE FILE ( PUB_cProjectFolder + DEF_SLASH + '_'+PUB_cSecu+'End.Txt' )
   DELETE FILE ( US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + '_'+PUB_cSecu+'Temp.Log' )
   DELETE FILE ( US_Shortname( GetCppFolder()) + DEF_SLASH + 'BIN' + DEF_SLASH + '_'+PUB_cSecu+'Temp.Log' )
   DELETE FILE ( PUB_cProjectFolder + DEF_SLASH + 'BIN' + DEF_SLASH + '_'+PUB_cSecu+'Progress.Log' )
   ProgLength := 0

   SetProperty( "VentanaMain" , "EraseOBJ" , "enabled" , .F. )
   SetProperty( "VentanaMain" , "EraseALL" , "enabled" , .F. )
   SetProperty( "VentanaMain" , "open" , "enabled" , .F. )
   SetProperty( "VentanaMain" , "build" , "enabled" , .F. )
   SetProperty( "VentanaMain" , "BVerChange" , "enabled" , .F. )
   SetProperty( "VentanaMain" , "OverrideCompile" , "enabled" , .F. )
   SetProperty( "VentanaMain" , "OverrideLink" , "enabled" , .F. )
   if cOutputType == "SRCEXE"
      SetProperty( "VentanaMain" , "run" , "enabled" , .F. )
   endif

   PUB_bIsProcessing := .t.
   VentanaMain.RichEditSysout.Value := ''

   SetMGWaitHide()

   DO EVENTS

   ferase( PUB_cProjectFolder + DEF_SLASH + "_" + PUB_cSecu + "MSG.SYSIN" )

   SetCurrentFolder(PUB_cProjectFolder)
   if !US_CreateFolder( PUB_cProjectFolder + DEF_SLASH + GetObjName() )
      US_Log( "Unable to create OBJ folder: " + PUB_cProjectFolder + DEF_SLASH + GetObjName() )
      BUILD_IN_PROGRESS := .F.
      DefinoWindowsHotKeys( .F. )
      Return .F.
   endif
   SetCurrentFolder(PUB_cQPM_Folder)

   cOutputName        := GetOutputModuleName( .F. )
   cOutputNameDisplay := GetOutputModuleName( .T. )
   
/*
 * Out contiene los comandos que luego se grabarán en
 * Temp.Bc para ser ejecutados por MAKE.EXE desde Build.bat
 */
   Out := Out + 'APP_NAME = ' + cOutputName + Hb_OsNewLine()

   if substr( cOutputType , 1 , 3 ) == "SRC"
      if VentanaMain.GHeaFiles.itemcount > 0
         xRefPrgHea()
      endif
      if VentanaMain.GPanFiles.itemcount > 0
         xRefPrgFmg()
      endif
   endif

   MemoAux := memoread( PUB_cProjectFolder + DEF_SLASH + '_'+PUB_cSecu+'Progress.Log' )
   QPM_MemoWrit( PUB_cProjectFolder + DEF_SLASH + '_'+PUB_cSecu+'Progress.Log' , MemoAux + US_TimeDis( Time() ) + " - Checking libraries ..." + HB_OsNewLine() )

   DO EVENTS

/*
 * Variables y aplicaciones a utilizar en Temp.Bc
 */
   do case
      case IsMinGW
         Out := Out + 'DEF_SLASH = ' + US_ShortName(PUB_cQPM_Folder) + DEF_SLASH + 'US_SLASH.EXE QPM' + Hb_OsNewLine()
         Out := Out + 'IMPDEF_MGW_EXE = ' + US_ShortName(PUB_cQPM_Folder) + DEF_SLASH + 'US_PEXPORTS.EXE' + Hb_OsNewLine()
         *NO BORRAROut := Out + 'IMPDEF_MGW_EXE = ' + US_ShortName(PUB_cQPM_Folder) + DEF_SLASH + 'US_IMPDEF.EXE' + Hb_OsNewLine()
         Out := Out + 'REIMPORT_EXE = ' + US_ShortName(PUB_cQPM_Folder) + DEF_SLASH + 'US_REIMP.EXE' + Hb_OsNewLine()
         Out := Out + 'IMPLIB_MGW_EXE = ' + US_ShortName(GetCppFolder()) + DEF_SLASH + 'BIN'+DEF_SLASH+'US_DLLTOOL.EXE' + Hb_OsNewLine()
         Out := Out + 'LSTA_EXE = ' + US_ShortName(PUB_cQPM_Folder) + DEF_SLASH + 'US_OBJDUMP.EXE' + Hb_OsNewLine()
         Out := Out + 'COMPILATOR_C = ' + US_ShortName(GetCppFolder()) + DEF_SLASH + 'BIN'+DEF_SLASH+'GCC.EXE' + Hb_OsNewLine()
         Out := Out + 'ILINK_EXE = ' + US_ShortName(GetCppFolder()) + DEF_SLASH + 'BIN'+DEF_SLASH+'GCC.EXE' + Hb_OsNewLine()
         Out := Out + 'RESOURCE_COMP = ' + US_ShortName(GetCppFolder()) + DEF_SLASH + 'BIN'+DEF_SLASH+'US_WINDRES.EXE' + Hb_OsNewLine()
         Out := Out + 'TLIB_EXE = ' + US_ShortName(GetCppFolder()) + DEF_SLASH + 'BIN'+DEF_SLASH+'AR.EXE' + Hb_OsNewLine()
         Out := Out + 'RC_FILLER = ' + US_ShortName(GetMiniGuiFolder()) + DEF_SLASH + 'RESOURCES' + DEF_SLASH + 'FILLER' + Hb_OsNewLine()
         Out := Out + 'DIR_COMPC = ' + US_ShortName(GetCppFolder()) + Hb_OsNewLine()
         Out := Out + 'DIR_MINIGUI = ' + US_ShortName(GetMiniGuiFolder()) + Hb_OsNewLine()
         Out := Out + 'DIR_MINIGUI_RES = ' + US_ShortName(GetMiniGuiFolder()) + DEF_SLASH + 'Resources' + Hb_OsNewLine()
         Out := Out + 'DIR_HARBOUR = ' + US_ShortName( GetHarbourFolder() ) + Hb_OsNewLine()
      case IsPelles
         Out := Out + 'IMPDEF_PC_EXE = ' + US_ShortName(PUB_cQPM_Folder) + DEF_SLASH + 'US_IMPDEF.EXE' + Hb_OsNewLine()
         Out := Out + 'IMPLIB_PC_EXE = ' + US_ShortName(PUB_cQPM_Folder) + DEF_SLASH + 'US_POLIB.EXE' + Hb_OsNewLine()
         Out := Out + 'LSTLIB_EXE = ' + US_ShortName(PUB_cQPM_Folder) + DEF_SLASH + 'US_POLIB.EXE' + Hb_OsNewLine()
         Out := Out + 'COMPILATOR_C = ' + US_ShortName(GetCppFolder()) + DEF_SLASH + 'BIN'+DEF_SLASH+'POCC.EXE' + Hb_OsNewLine()
         Out := Out + 'ILINK_EXE = ' + US_ShortName(GetCppFolder()) + DEF_SLASH + 'BIN'+DEF_SLASH+'POLINK.EXE' + Hb_OsNewLine()
         Out := Out + 'TLIB_EXE = ' + US_ShortName(PUB_cQPM_Folder) + DEF_SLASH + 'US_POLIB.EXE' + Hb_OsNewLine()
         Out := Out + 'RESOURCE_COMP = ' + US_ShortName(GetCppFolder()) + DEF_SLASH + 'BIN'+DEF_SLASH+'PORC.EXE' + Hb_OsNewLine()
      case IsBorland
         Out := Out + 'IMPDEF_BCC_EXE = ' + US_ShortName(PUB_cQPM_Folder) + DEF_SLASH + 'US_IMPDEF.EXE' + Hb_OsNewLine()
         Out := Out + 'IMPLIB_BCC_EXE = ' + US_ShortName(PUB_cQPM_Folder) + DEF_SLASH + 'US_IMPLIB.EXE' + Hb_OsNewLine()
         Out := Out + 'LSTLIB_EXE = ' + US_ShortName(PUB_cQPM_Folder) + DEF_SLASH + 'US_TLIB.EXE' + Hb_OsNewLine()
         Out := Out + 'COMPILATOR_C = ' + US_ShortName(GetCppFolder()) + DEF_SLASH + 'BIN'+DEF_SLASH+'BCC32.EXE' + Hb_OsNewLine()
         Out := Out + 'ILINK_EXE = ' + US_ShortName(GetCppFolder()) + DEF_SLASH + 'BIN'+DEF_SLASH+'ILINK32.EXE' + Hb_OsNewLine()
         Out := Out + 'TLIB_EXE = ' + US_ShortName(PUB_cQPM_Folder) + DEF_SLASH + 'US_TLIB.EXE' + Hb_OsNewLine()
         Out := Out + 'RESOURCE_COMP = ' + US_ShortName(GetCppFolder()) + DEF_SLASH + 'BIN'+DEF_SLASH+'BRC32.EXE' + Hb_OsNewLine()
      otherwise
         US_Log( "Error 5549" )
   endcase
   Out := Out + 'REDIR = ' + US_ShortName(PUB_cQPM_Folder) + DEF_SLASH + 'US_REDIR.EXE' + PUB_cUS_RedirOpt + US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + '_'+PUB_cSecu+'Temp.Log ' + Hb_OsNewLine()
   Out := Out + 'HARBOUR_EXE = ' + US_ShortName( GetHarbourFolder() ) + DEF_SLASH + 'BIN'+DEF_SLASH+'HARBOUR.EXE' + Hb_OsNewLine()
   Out := Out + 'US_MSG_EXE = ' + US_ShortName(PUB_cQPM_Folder) + DEF_SLASH + 'US_MSG.EXE' + Hb_OsNewLine()
   Out := Out + 'US_UPX_EXE = ' + US_ShortName(PUB_cQPM_Folder) + DEF_SLASH + 'US_UPX.EXE' + Hb_OsNewLine()
   Out := Out + 'US_SHELL_EXE = ' + US_ShortName(PUB_cQPM_Folder) + DEF_SLASH + 'US_SHELL.EXE QPM' + Hb_OsNewLine()
   Out := Out + 'DIR_HB_INCLUDE = ' + cExtraFoldersHB + Hb_OsNewLine()
   Out := Out + 'DIR_C_INCLUDE = ' + cExtraFoldersC + Hb_OsNewLine()
   Out := Out + 'DIR_MINIGUI_LIB = ' + US_ShortName(GetMiniGuiFolder()+DEF_SLASH + 'lib') + Hb_OsNewLine()
   Out := Out + 'DIR_COMPC_LIB = ' + US_ShortName(GetCppFolder()) + DEF_SLASH + 'LIB' + Hb_OsNewLine()
   Out := Out + 'DIR_HARBOUR_LIB = ' + GetHarbourLibFolder( .F. ) + Hb_OsNewLine()
   Out := Out + 'DIR_PROJECT = ' + US_ShortName(PUB_cProjectFolder) + Hb_OsNewLine()
   Out := Out + 'PAUSE_EXE = PAUSE' + Hb_OsNewLine()
   Out := Out + 'DIR_OBJECTS = ' + US_ShortName(PUB_cProjectFolder) + DEF_SLASH + GetObjName() + Hb_OsNewLine()
   Out := Out + 'C_DIR = ' + US_ShortName(PUB_cProjectFolder) + DEF_SLASH + GetObjName() + Hb_OsNewLine()
// Out := Out + 'USER_FLAGS_HARBOUR = /p'+US_ShortName(PUB_cProjectFolder) + DEF_SLASH + GetObjName() + '' + Hb_OsNewLine() // ppo
   Out := Out + 'USER_FLAGS_HARBOUR = '+GetProperty( "VentanaMain" , "OverrideCompile" , "value" ) + Hb_OsNewLine()
   Out := Out + 'USER_FLAGS_LINK = '+GetProperty( "VentanaMain" , "OverrideLink" , "value" ) + Hb_OsNewLine()

   if !bConvert
      cPrj_Version := GetPrjVersion()
      Out := Out + 'HARBOUR_FLAGS = /D__QPM_VERSION__="'+"'"+PUB_cQPM_Version2+"'"+'" /D__PRJ_VERSION__="'+"'"+cPrj_Version+"'"+'" /D__PROJECT_FOLDER__="'+"'"+VentanaMain.TProjectFolder.Value+"'"+'" /n '+If(PUB_bDebugActive,'/b','')+' $(USER_FLAGS_HARBOUR) /i$(DIR_HB_INCLUDE) ' + Hb_OsNewLine()
      if PUB_xHarbourMT = "MT"
         if !IsMinGW
            Out := Out + 'COBJFLAGS =  -c -O2 -tWM -M  -I$(DIR_C_INCLUDE) -L'+ US_ShortName(GetCppFolder()) + DEF_SLASH + 'LIB' + Hb_OsNewLine()
         endif
      else
         do case
            case IsMinGW
               do case
                  case cOutputType == "SRCDLL"
                     Out := Out + 'COBJFLAGS =  -I$(DIR_C_INCLUDE) -c ' + Hb_OsNewLine()
                  otherwise
/*
 Las versiones nuevas de gcc no soportan el flag -mno-cygwin
                     Out := Out + 'COBJFLAGS =  -I$(DIR_C_INCLUDE) -mno-cygwin -Wall -c ' + Hb_OsNewLine()
*/
                     Out := Out + 'COBJFLAGS =  -I$(DIR_C_INCLUDE) -Wall -c ' + Hb_OsNewLine()
// For GTK           Out := Out + 'COBJFLAGS =  -I$(DIR_C_INCLUDE) -mms-bitfields -Wall -c ' + Hb_OsNewLine()
               endcase
            case IsPelles
               do case
                  case cOutputType == "SRCDLL"
                     Out := Out + 'COBJFLAGS = ' + if( !bConsole , ' -c -tWD -u- ' , ' -c -O2 -d -M -u- ' ) + ' -I$(DIR_C_INCLUDE) -L' + US_ShortName(GetCppFolder()) + DEF_SLASH + 'LIB' + Hb_OsNewLine()
                  otherwise
                     Out := Out + 'COBJFLAGS = ' + if( !bConsole , ' /Ze /Zx /Go /Tx86-coff /D__WIN32__ ' , ' /Ze /Zx /Go /Tx86-coff /D__WIN32__ ' ) + ' /I$(DIR_C_INCLUDE)' + Hb_OsNewLine()
               endcase
            case IsBorland
               do case
                  case cOutputType == "SRCDLL"
                     Out := Out + 'COBJFLAGS = ' + if( !bConsole , ' -c -tWD -u- ' , ' -c -O2 -d -M -u- ' ) + ' -I$(DIR_C_INCLUDE) -L' + US_ShortName(GetCppFolder()) + DEF_SLASH + 'LIB' + Hb_OsNewLine()
                  otherwise
                     Out := Out + 'COBJFLAGS = ' + if( !bConsole , ' -c -O2 -tW -M ' , ' -c -O2 -d -M ' ) + ' -I$(DIR_C_INCLUDE) -L' + US_ShortName(GetCppFolder()) + DEF_SLASH + 'LIB' + Hb_OsNewLine()
               endcase
            otherwise
               US_Log( "Error 5598" )
         endcase
      endif
      Out := Out + Hb_OsNewLine()

/*
 * Objetos de los que depende el ejecutable
 */
      do case
         case IsMinGW
            Out := Out + '$(APP_NAME) : $(DIR_OBJECTS)' + DEF_SLASH + US_FileNameOnlyName( PRGFILES[1] ) + '.o ' + if( VentanaMain.GPrgFiles.ItemCount > 1 , DEF_SLASH , '' ) + Hb_OsNewLine()
         otherwise
            Out := Out + '$(APP_NAME) : $(DIR_OBJECTS)' + DEF_SLASH + US_FileNameOnlyName( PRGFILES[1] ) + '.obj ' + if( VentanaMain.GPrgFiles.ItemCount > 1 , DEF_SLASH , '' ) + Hb_OsNewLine()
      endcase

      DO EVENTS

      For i := 2 To VentanaMain.GPrgFiles.ItemCount
         If i == VentanaMain.GPrgFiles.ItemCount
            do case
               case IsMinGW
                  Out := Out + '              $(DIR_OBJECTS)' + DEF_SLASH + US_FileNameOnlyName( PRGFILES[i] ) + '.o' + Hb_OsNewLine()
               otherwise
                  Out := Out + '              $(DIR_OBJECTS)' + DEF_SLASH + US_FileNameOnlyName( PRGFILES[i] ) + '.obj' + Hb_OsNewLine()
            endcase
         Else
            do case
               case IsMinGW
                  Out := Out + '              $(DIR_OBJECTS)' + DEF_SLASH + US_FileNameOnlyName( PRGFILES[i] ) + '.o ' + DEF_SLASH + Hb_OsNewLine()
               otherwise
                  Out := Out + '              $(DIR_OBJECTS)' + DEF_SLASH + US_FileNameOnlyName( PRGFILES[i] ) + '.obj ' + DEF_SLASH + Hb_OsNewLine()
            endcase
         EndIf
      Next i
      
/*
 * Comandos para generar el ejecutable.
 * Esta lista NO debe estar separada de la anterior por renglones en blanco.
 */
 
 /*
  * Comandos para compilar el archivo de recursos
  */
      if ! bConsole
         If File ( US_FileNameOnlyPathAndName( PRGFILES[1] ) + '.RC' )
            do case
               case IsMinGW
                  Out := Out + PUB_cCharTab + '$(US_MSG_EXE) $(DIR_PROJECT)' + DEF_SLASH + '_'+PUB_cSecu+'Progress.Log -MSG:Compiling Resource File (.RC file has been copied to _Temp.rc file for build the _temp.o)...' + HB_OsNewLine()
                  Out := Out + PUB_cCharTab + '$(REDIR) $(RESOURCE_COMP) -I ' + US_ShortName( GetMiniGuiFolder() + DEF_SLASH + 'Resources' ) + ' -i ' + US_ShortName(PUB_cProjectFolder) + DEF_SLASH + '_Temp.RC -o $(DIR_OBJECTS)'+DEF_SLASH+'_Temp.o' + Hb_OsNewLine()
               case IsPelles
                  Out := Out + PUB_cCharTab + '$(US_MSG_EXE) $(DIR_PROJECT)' + DEF_SLASH + '_'+PUB_cSecu+'Progress.Log -MSG:Compiling Resource File ' + US_FileNameOnlyPathAndName( PRGFILES[1] ) + '.rc' + '...' + Hb_OsNewLine()
                  Out := Out + PUB_cCharTab + '$(RESOURCE_COMP) /Fo' + US_ShortName(PUB_cProjectFolder) + DEF_SLASH + US_FileNameOnlyName( PRGFILES[1] ) + '.Res ' + US_ShortName( US_FileNameOnlyPathAndName( PRGFILES[1] ) + '.RC' ) + ' ' + Hb_OsNewLine()
               case IsBorland
                  Out := Out + PUB_cCharTab + '$(US_MSG_EXE) $(DIR_PROJECT)' + DEF_SLASH + '_'+PUB_cSecu+'Progress.Log -MSG:Compiling Resource File ' + US_FileNameOnlyPathAndName( PRGFILES[1] ) + '.rc' + '...' + Hb_OsNewLine()
                  Out := Out + PUB_cCharTab + '$(RESOURCE_COMP) -d__BORLANDC__ -r -fo' + US_ShortName(PUB_cProjectFolder) + DEF_SLASH + US_FileNameOnlyName( PRGFILES[1] ) + '.Res ' + US_ShortName( US_FileNameOnlyPathAndName( PRGFILES[1] ) + '.RC' ) + ' ' + Hb_OsNewLine()
               otherwise
                  US_Log( "Error 5649" )
            endcase
         EndIf
      EndIf

      DO EVENTS

/*
 * Comandos para generar el ejecutable (van en Out) y para generar el
 * script de linkedición (van en script.ld)
 */
      do case
         case cOutputType == "SRCEXE" .or. ;
              cOutputType == "SRCDLL"
            Out := Out + PUB_cCharTab + '$(US_MSG_EXE) $(DIR_PROJECT)' + DEF_SLASH + '_'+PUB_cSecu+'Progress.Log -MSG:Making script for link process ...' + Hb_OsNewLine()

/*
 * Grabo lista de objetos incluidos en las Include Libraries (estos objetos
 * deben estar en la carpeta Resources), y que estén marcados *FIRST*, en script.ld
 */
            For i := 1 To Len ( vLibIncludeFiles )
               if US_Upper( US_Word( GetProperty( "VentanaMain" , "GIncFiles" , "Cell" , i , NCOLINCFULLNAME ) , 2 ) ) == "*FIRST*"
                  if file( GetMiniGuiFolder() + DEF_SLASH + "Resources" + DEF_SLASH + substr( US_FileNameOnlyName( vLibIncludeFiles[i] ) , 4 ) + '.o' )
                     do case
                     case IsMinGW
                        Out := Out + PUB_cCharTab + 'echo INPUT( $(DIR_MINIGUI_RES)' + DEF_SLASH + substr( US_FileNameOnlyName( vLibIncludeFiles[i] ) , 4 ) + '.o ) >> _'+PUB_cSecu+'Script.ld' + Hb_OsNewLine()
                     case IsPelles
                        Out := Out + PUB_cCharTab + 'echo $(DIR_MINIGUI_RES)' + DEF_SLASH + substr( US_FileNameOnlyName( vLibIncludeFiles[i] ) , 4 ) + '.obj >> _'+PUB_cSecu+'Script.ld' + Hb_OsNewLine()
                     case IsBorland
                        Out := Out + PUB_cCharTab + 'echo $(DIR_MINIGUI_RES)' + DEF_SLASH + substr( US_FileNameOnlyName( vLibIncludeFiles[i] ) , 4 ) + '.obj >> _'+PUB_cSecu+'Script.ld' + Hb_OsNewLine()
                     otherwise
                        US_Log( "Error 5671" )
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
                  Out := Out + PUB_cCharTab + 'echo INPUT( $(DIR_OBJECTS)' + DEF_SLASH + US_FileNameOnlyName( PRGFILES[i] ) + '.o ) >> _'+PUB_cSecu+'Script.ld ' + Hb_OsNewLine()
               case IsPelles
                  Out := Out + PUB_cCharTab + 'echo $(DIR_OBJECTS)' + DEF_SLASH + US_FileNameOnlyName( PRGFILES[i] ) + '.obj >> _'+PUB_cSecu+'Script.ld ' + Hb_OsNewLine()
               case IsBorland
                  Out := Out + PUB_cCharTab + 'echo $(DIR_OBJECTS)' + DEF_SLASH + US_FileNameOnlyName( PRGFILES[i] ) + '.obj + >> _'+PUB_cSecu+'Script.ld ' + Hb_OsNewLine()
               otherwise
                  US_Log( "Error 5672" )
               endcase
            Next i
            
            do case
               case IsMinGW
/*
 * Grabo objeto generado a partir del archivo de recursos en script.ld
 */
                  If !bConsole
                     If File( US_FileNameOnlyPathAndName( PRGFILES[1] ) + '.RC' )
                        Out := Out + PUB_cCharTab + 'echo INPUT( $(DIR_OBJECTS)'+DEF_SLASH+'_Temp.o ) >> _'+PUB_cSecu+'Script.ld' + Hb_OsNewLine()
                     else
                        if QPM_IsXHarbour()
                           if ! File( GetMiniGuiFolder() + DEF_SLASH + "Resources" + DEF_SLASH + cResourceFileName + ".o" )
                              US_FileCopy( GetMiniGuiFolder() + DEF_SLASH + "Resources" + DEF_SLASH + cResourceFileName + ".o" , GetMiniGuiFolder() + DEF_SLASH + "Resources" + DEF_SLASH + cResourceFileName + ".o" )
                           endif
                        endif
                        Out := Out + PUB_cCharTab + 'echo INPUT( $(DIR_MINIGUI_RES)' + DEF_SLASH + cResourceFileName + '.o ) >> _'+PUB_cSecu+'Script.ld' + Hb_OsNewLine()
                     endif
                  endif

                  DO EVENTS
                  
/*
 * Grabo objetos incluidos en las Default Libraries (estos objetos deben estar
 * en la carpeta Resources) en script.ld
 */
                  For i=1 to len( &( 'vLibDefault'+GetSuffix() ) )
                     if Getminiguisuffix() == DefineOohg3 .and. ;
                        ( US_Upper( &('vLibDefault'+GetSuffix()+'['+str(i)+']') ) == "LIBHBPRINTER.A" .or. ;
                          US_Upper( &('vLibDefault'+GetSuffix()+'['+str(i)+']') ) == "LIBMINIPRINT.A" )
/*
 * TODO: Investigar la necesidad de esta sentencia.
 */
                         US_Nop()
                     else
                        if ascan( vLibExcludeFiles , US_Upper( &( 'vLibDefault'+GetSuffix()+'['+str(i)+']' ) ) ) = 0
                           if file( GetMiniGuiFolder() + DEF_SLASH + 'RESOURCES' + DEF_SLASH + substr( US_FileNameOnlyName( &('vLibDefault'+GetSuffix()+'['+str(i)+']') ) , 4 ) + '.o' )
                              Out := Out + PUB_cCharTab + 'echo INPUT( $(DIR_MINIGUI_RES)' + DEF_SLASH + substr( US_FileNameOnlyName( &('vLibDefault'+GetSuffix()+'['+str(i)+']') ) , 4 ) + '.o ) >> _'+PUB_cSecu+'Script.ld' + Hb_OsNewLine()
                           endif
                        endif
                     endif
                  Next i

                  DO EVENTS

/*
 * Grabo objetos incluidos en las Include Libraries (estos objetos deben estar
 * en la carpeta Resources), y que estén marcados *LAST*, en script.ld
 */
                  For i := 1 To Len ( vLibIncludeFiles )
                     if US_Upper( US_Word( GetProperty( "VentanaMain" , "GIncFiles" , "Cell" , i , NCOLINCFULLNAME ) , 2 ) ) == "*LAST*" && for .res
                        if file( GetMiniGuiFolder() + DEF_SLASH + "Resources" + DEF_SLASH + substr( US_FileNameOnlyName( vLibIncludeFiles[i] ) , 4 ) + '.o' )
                           Out := Out + PUB_cCharTab + 'echo INPUT( $(DIR_MINIGUI_RES)' + DEF_SLASH + substr( US_FileNameOnlyName( vLibIncludeFiles[i] ) , 4 ) + '.o ) >> _'+PUB_cSecu+'Script.ld' + Hb_OsNewLine()
                        endif
                     endif
                  Next i

//                  Out := Out + PUB_cCharTab + 'echo OUTPUT( $(APP_NAME) ) >> _'+PUB_cSecu+'Script.ld' + Hb_OsNewLine()
               case IsPelles
                  Out := Out + PUB_cCharTab + 'echo /OUT:$(APP_NAME) >> _'+PUB_cSecu+'Script.ld' + Hb_OsNewLine()
                  Out := Out + PUB_cCharTab + 'echo /FORCE:MULTIPLE >> _'+PUB_cSecu+'Script.ld' + Hb_OsNewLine()
                  Out := Out + PUB_cCharTab + 'echo /LIBPATH:' + US_ShortName(GetCppFolder()) + DEF_SLASH + 'LIB >> _'+PUB_cSecu+'Script.ld' + Hb_OsNewLine()
                  Out := Out + PUB_cCharTab + 'echo /LIBPATH:' + US_ShortName(GetCppFolder()) + DEF_SLASH + 'LIB'+DEF_SLASH+'WIN >> _'+PUB_cSecu+'Script.ld' + Hb_OsNewLine()
               case IsBorland
                  if !bConsole
                     if cOutputType == "SRCEXE"
                        Out := Out + PUB_cCharTab + 'echo ' + US_ShortName(GetCppFolder()) + DEF_SLASH + 'LIB'+DEF_SLASH+'c0w32.obj, + >> _'+PUB_cSecu+'Script.ld ' + Hb_OsNewLine()
                     endif
                     if cOutputType == "SRCDLL"
                        Out := Out + PUB_cCharTab + 'echo ' + US_ShortName(GetCppFolder()) + DEF_SLASH + 'LIB'+DEF_SLASH+'c0d32.obj, + >> _'+PUB_cSecu+'Script.ld ' + Hb_OsNewLine()
                     endif
                  else
                     Out := Out + PUB_cCharTab + 'echo ' + US_ShortName(GetCppFolder()) + DEF_SLASH + 'LIB'+DEF_SLASH+'c0x32.obj, + >> _'+PUB_cSecu+'Script.ld ' + Hb_OsNewLine()
                  endif

                  Out := Out + PUB_cCharTab + 'echo $(APP_NAME),' + US_FileNameOnlyName( PRGFILES[1] ) + '.map, + >> _'+PUB_cSecu+'Script.ld' + Hb_OsNewLine()
               otherwise
                  US_Log( "Error 5746" )
            endcase

/*
 * Grabo libraries en script.ld
 */
            if QPM_IsXHarbour() .and. !IsMinGW .and. file( GetHarbourLibFolder()+DEF_SLASH+'bcc640'+PUB_xHarbourMT+'.lib' )
               Out := Out + PUB_cCharTab + 'echo $(DIR_HARBOUR_LIB)'+DEF_SLASH+'bcc640'+PUB_xHarbourMT+'.lib + >> _'+PUB_cSecu+'Script.ld' + HB_OsNewLine()
            endif

            DO EVENTS

            do case
               case IsMinGW
                  w_hay := .f.
                  w_group := "GROUP( "
                  
/*
 * MINGW: add libraries marked FIRST
 */
                  For i := 1 To Len ( vLibIncludeFiles )
                     if US_Upper( US_Word( GetProperty( "VentanaMain" , "GIncFiles" , "Cell" , i , NCOLINCFULLNAME ) , 2 ) ) == "*FIRST*"
                        if US_upper( US_FileNameOnlyExt( vLibIncludeFiles[i] ) ) == "A"
                           w_hay := .t.
                           w_group += '-l' + substr( US_FileNameOnlyName( vLibIncludeFiles[i] ) , 4 ) + ' '
                        else
                           w_hay := .t.
                           w_group += US_ShortName( vLibIncludeFiles[i] ) + ' '
                        endif
                     endif
                  Next

/*
 * MINGW: add MiniGui main library
 */
                  if bConsole
                     if ascan( vLibExcludeFiles , US_Upper( GetMiniGuiName() ) ) = 0
                        w_hay := .t.
                        w_group += '-l' + substr( US_FileNameOnlyName( GetMiniGuiName() ) , 4 ) + ' '
                     endif
                  else
                     w_hay := .t.
                     w_group += '-l' + substr( US_FileNameOnlyName( GetMiniGuiName() ) , 4 ) + ' '
                     if ascan( vLibExcludeFiles , US_Upper( GetMiniGuiName() ) ) > 0
                        MsgInfo( 'Warning: ' + GetMiniGuiName() + ' EXCLUDED for non Console Mode.  Look at ' + PageLIB )
                     endif
                  endif

                  DO EVENTS

/*
 * MINGW: add other libraries
 */
                  // Algoritmo de busqueda para Oficial 3x
                  // 1.- Que no este excluida
                  // 2.- si es user lib la busco con X (si es xharbour) o sin X (si no es xHArbour) en los tres directorios de libs
                  //     si esta la agrego
                  //     sino, solo cuando es xharbour la busco en el directorio de xharbour sin la X
                  // 3.- si no es userlib, la busco siempre sin X en los tres directorios
                  For i:=1 to len( &( 'vLibDefault'+GetSuffix() ) )
                     if ascan( vLibExcludeFiles , US_Upper( &( 'vLibDefault'+GetSuffix()+'['+str(i)+']' ) ) ) = 0
                        if US_Upper( &('vLibDefault'+GetSuffix()+'['+str(i)+']') ) == "LIBHBPRINTER.A" .or. ;
                           US_Upper( &('vLibDefault'+GetSuffix()+'['+str(i)+']') ) == "LIBMINIPRINT.A" .or. ;
                           US_Upper( &('vLibDefault'+GetSuffix()+'['+str(i)+']') ) == "LIBPROPGRID.A" .or. ;
                           US_Upper( &('vLibDefault'+GetSuffix()+'['+str(i)+']') ) == "LIBSOCKET.A"
                           if File( GetMiniGuiFolder() + DEF_SLASH + 'lib'+DEF_SLASH+'lib' + if(QPM_IsXHarbour(),"x","") + substr( &('vLibDefault'+GetSuffix()+'['+str(i)+']') , 4 ) ) .or. ;
                              File( GetHarbourLibFolder()+DEF_SLASH+'lib' + if(QPM_IsXHarbour(),"x","") + substr( &('vLibDefault'+GetSuffix()+'['+str(i)+']') , 4 ) ) .or. ;
                              File( GetCppFolder() + DEF_SLASH + 'lib'+DEF_SLASH+'lib' + if(QPM_IsXHarbour(),"x","") + substr( &('vLibDefault'+GetSuffix()+'['+str(i)+']') , 4 ) )
                              w_hay := .t.
                              w_group += '-l' + if(QPM_IsXHarbour(),"x","") + substr( US_FileNameOnlyName( &( 'vLibDefault'+GetSuffix()+'['+str(i)+']' ) ) , 4 ) + ' '
                           else
                              if QPM_IsXHarbour()
                                 if File( GetHarbourLibFolder()+DEF_SLASH+'lib' + substr( &('vLibDefault'+GetSuffix()+'['+str(i)+']') , 4 ) )
                                    w_hay := .t.
                                    w_group += '-l' + substr( US_FileNameOnlyName( &( 'vLibDefault'+GetSuffix()+'['+str(i)+']' ) ) , 4 ) + ' '
                                 endif
                              endif
                           endif
                        else
                           if File( GetMiniGuiFolder() + DEF_SLASH + 'lib' + DEF_SLASH + &('vLibDefault'+GetSuffix()+'['+str(i)+']') ) .or. ;
                              File( GetHarbourLibFolder() + DEF_SLASH + &('vLibDefault'+GetSuffix()+'['+str(i)+']') ) .or. ;
                              File( GetCppFolder() + DEF_SLASH + 'lib' + DEF_SLASH + &('vLibDefault'+GetSuffix()+'['+str(i)+']') )
                              if ( ( !PUB_bDebugActive .and. GetCppSuffix() == DefineMinGW .and. US_Upper( &('vLibDefault'+GetSuffix()+'['+str(i)+']') ) == "LIBCNL.A" ) .and. ;
                                   ( !bConsole .and. GetCppSuffix() == DefineMinGW .and. US_Upper( &('vLibDefault'+GetSuffix()+'['+str(i)+']') ) == "LIBCNL.A" ) ) .or. ;
                                 ( ( PUB_bDebugActive .and. GetCppSuffix() == DefineMinGW .and. US_Upper( &('vLibDefault'+GetSuffix()+'['+str(i)+']') ) == "LIBGUI.A" ) .or. ;
                                   ( bConsole .and. GetCppSuffix() == DefineMinGW .and. US_Upper( &('vLibDefault'+GetSuffix()+'['+str(i)+']') ) == "LIBGUI.A" ) )
                                 US_Nop()
                              else
                                 w_hay := .t.
                                 w_group += '-l' + substr( US_FileNameOnlyName( &( 'vLibDefault'+GetSuffix()+'['+str(i)+']' ) ) , 4 ) + ' '
                              endif
                           endif
                        endif
                     endif
                  next

                  DO EVENTS

/*
 * MINGW: add libraries marked LAST
 */
                  For i := 1 To Len ( vLibIncludeFiles )
                     if US_Upper( US_Word( GetProperty( "VentanaMain" , "GIncFiles" , "Cell" , i , NCOLINCFULLNAME ) , 2 ) ) == "*LAST*"
                        if US_upper( US_FileNameOnlyExt( vLibIncludeFiles[i] ) ) == "A"
                           w_hay := .t.
                           w_group += '-l' + substr( US_FileNameOnlyName( vLibIncludeFiles[i] ) , 4 ) + ' '
                        else
                           w_hay := .t.
                           w_group += US_ShortName( vLibIncludeFiles[i] ) + ' '
                        endif
                     endif
                  Next

                  if w_hay
                     w_group += ")"
                     Out := Out + PUB_cCharTab + 'echo ' + w_group + ' >> _'+PUB_cSecu+'Script.ld ' + Hb_OsNewLine()
                  endif

/*
 * Add search folders to script.ld
 */
                  Out := Out + PUB_cCharTab + 'echo SEARCH_DIR( $(DIR_MINIGUI)'+DEF_SLASH+'lib ) >> _'+PUB_cSecu+'Script.ld ' + Hb_OsNewLine()
                  Out := Out + PUB_cCharTab + 'echo SEARCH_DIR( $(DIR_HARBOUR_LIB) ) >> _'+PUB_cSecu+'Script.ld ' + Hb_OsNewLine()
                  Out := Out + PUB_cCharTab + 'echo SEARCH_DIR( $(DIR_COMPC)'+DEF_SLASH+'lib ) >> _'+PUB_cSecu+'Script.ld ' + Hb_OsNewLine()
                  For i := 1 To Len( &("vExtraFoldersForLibs"+GetSuffix()) )
                     if !empty( &("vExtraFoldersForLibs"+GetSuffix()+"["+str(i)+"]") ) .and. ;
                         !(&("vExtraFoldersForLibs"+GetSuffix()+"["+str(i)+"]") == upper( GetCppFolder()+DEF_SLASH + 'lib' ) ) .and. ;
                         !(&("vExtraFoldersForLibs"+GetSuffix()+"["+str(i)+"]") == upper( GetMiniGuiSuffix()+DEF_SLASH + 'lib' ) ) .and. ;
                         !(&("vExtraFoldersForLibs"+GetSuffix()+"["+str(i)+"]") == upper( GetHarbourFolder( .T. ) ) )
                        Out := Out + PUB_cCharTab + 'echo SEARCH_DIR( ' + US_ShortName( &("vExtraFoldersForLibs"+GetSuffix()+"["+str(i)+"]") ) + ' ) >> _'+PUB_cSecu+'Script.ld ' + Hb_OsNewLine()
                     endif
                  next
               case IsPelles
                  For i := 1 To Len ( vLibIncludeFiles )
                     if US_Upper( US_Word( GetProperty( "VentanaMain" , "GIncFiles" , "Cell" , i , NCOLINCFULLNAME ) , 2 ) ) == "*FIRST*"
                        Out := Out + PUB_cCharTab + 'echo ' + US_ShortName(vLibIncludeFiles[i]) + ' >> _'+PUB_cSecu+'Script.ld ' + Hb_OsNewLine()
                     endif
                  Next i

                  if !bConsole
                     Out := Out + PUB_cCharTab + 'echo ' + US_ShortName(GetMiniGuiFolder()) + DEF_SLASH + 'LIB' + DEF_SLASH + GetMiniGuiName() + ' >> _'+PUB_cSecu+'Script.ld' + HB_OsNewLine()
                     if ascan( vLibExcludeFiles , US_Upper( GetMiniGuiName() ) ) > 0
                        MsgInfo( 'Warning: ' + GetMiniGuiName() + ' EXCLUDED for non Console Mode.  Look at ' + PageLIB )
                     endif
                  else
                     if ascan( vLibExcludeFiles , US_Upper( GetMiniGuiName() ) ) = 0
                        Out := Out + PUB_cCharTab + 'echo ' + US_ShortName(GetMiniGuiFolder()) + DEF_SLASH + 'LIB' + DEF_SLASH + GetMiniGuiName() + ' >> _'+PUB_cSecu+'Script.ld' + HB_OsNewLine()
                     endif
                  endif

                  DO EVENTS

                  // Algoritmo de busqueda para pelles
                  // 1.- Que no este excluida
                  // 2.- si es user lib la busco con X (si es xharbour) o sin X (si no es xHArbour) en el directorio de minigui
                  //     si esta la agrego
                  //     sino, solo cuando es xharbour, la busco con x en xHarbour
                  //           si no esta, solo cuando es xharbour, la busco sin X en xHarbour
                  //     si no es xHarbour y no estaba en minigui folder, la busco sin X harbour folder
                  // 3.- si no es userlib, la busco siempre sin X en los tres directorios
                  For i=1 to len( &( 'vLibDefault'+GetSuffix() ) )
                     if ascan( vLibExcludeFiles , US_Upper( &( 'vLibDefault'+GetSuffix()+'['+str(i)+']' ) ) ) = 0
                        if US_Upper( &('vLibDefault'+GetSuffix()+'['+str(i)+']') ) == "HBPRINTER.LIB" .or. ;
                           US_Upper( &('vLibDefault'+GetSuffix()+'['+str(i)+']') ) == "MINIPRINT.LIB" .or. ;
                           US_Upper( &('vLibDefault'+GetSuffix()+'['+str(i)+']') ) == "PROPGRID.LIB" .or. ;
                           US_Upper( &('vLibDefault'+GetSuffix()+'['+str(i)+']') ) == "SOCKET.LIB"
                           if File( GetMiniGuiFolder() + DEF_SLASH + 'lib' + DEF_SLASH + if(QPM_IsXHarbour(),"x","") + &('vLibDefault'+GetSuffix()+'['+str(i)+']') )
                              Out := Out + PUB_cCharTab + 'echo $(DIR_MINIGUI_LIB)' + DEF_SLASH + if(QPM_IsXHarbour(),"x","") + &('vLibDefault'+GetSuffix()+'['+str(i)+']') + ' >> _'+PUB_cSecu+'Script.ld' + HB_OsNewLine()
                           else
                              if QPM_IsXHarbour()
                                 if File( GetHarbourLibFolder() + DEF_SLASH + "x" + &('vLibDefault'+GetSuffix()+'['+str(i)+']') )
                                    Out := Out + PUB_cCharTab + 'echo $(DIR_HARBOUR_LIB)' + DEF_SLASH + "x" + &('vLibDefault'+GetSuffix()+'['+str(i)+']') + ' >> _'+PUB_cSecu+'Script.ld' + HB_OsNewLine()
                                 else
                                    if File( GetHarbourLibFolder() + DEF_SLASH + &('vLibDefault'+GetSuffix()+'['+str(i)+']') )
                                       Out := Out + PUB_cCharTab + 'echo $(DIR_HARBOUR_LIB)' + DEF_SLASH + &('vLibDefault'+GetSuffix()+'['+str(i)+']') + ' >> _'+PUB_cSecu+'Script.ld' + HB_OsNewLine()
                                    endif
                                 endif
                              else
                                 if File( GetHarbourLibFolder() + DEF_SLASH + &('vLibDefault'+GetSuffix()+'['+str(i)+']') )
                                    Out := Out + PUB_cCharTab + 'echo $(DIR_HARBOUR_LIB)' + DEF_SLASH + &('vLibDefault'+GetSuffix()+'['+str(i)+']') + ' >> _'+PUB_cSecu+'Script.ld' + HB_OsNewLine()
                                 endif
                              endif
                           endif
                        else
                           if File( GetHarbourLibFolder() + DEF_SLASH + &('vLibDefault'+GetSuffix()+'['+str(i)+']') )
                              /* Este parche es para evitar que dentro de la DLL esten todas las funciones de ZIP */
                              if cOutputType == "SRCDLL" .and. US_Upper( &('vLibDefault'+GetSuffix()+'['+str(i)+']') ) == "ZIPARCHIVE.LIB"
                                 US_Nop()
                              else
                                 Out := Out + PUB_cCharTab + 'echo $(DIR_HARBOUR_LIB)' + DEF_SLASH + &('vLibDefault'+GetSuffix()+'['+str(i)+']') + ' >> _'+PUB_cSecu+'Script.ld' + HB_OsNewLine()
                              endif
                           else
                              if File( US_ShortName( GetCppFolder() ) + DEF_SLASH + 'lib' + DEF_SLASH + &('vLibDefault'+GetSuffix()+'['+str(i)+']') ) .or. ;
                                 File( US_ShortName( GetCppFolder() ) + DEF_SLASH + 'lib'+DEF_SLASH+'WIN' + DEF_SLASH + &('vLibDefault'+GetSuffix()+'['+str(i)+']') )
                                 Out := Out + PUB_cCharTab + 'echo ' + &('vLibDefault'+GetSuffix()+'['+str(i)+']') + ' >> _'+PUB_cSecu+'Script.ld' + HB_OsNewLine()
                              endif
                           endif
                        endif
                     endif
                  next

                  DO EVENTS

                  For i := 1 To Len ( vLibIncludeFiles )
                     if US_Upper( US_Word( GetProperty( "VentanaMain" , "GIncFiles" , "Cell" , i , NCOLINCFULLNAME ) , 2 ) ) == "*LAST*"
                        Out := Out + PUB_cCharTab + 'echo ' + US_ShortName(vLibIncludeFiles[i]) + ' >> _'+PUB_cSecu+'Script.ld ' + Hb_OsNewLine()
                     endif
                  Next i
                  if !bConsole
                     If File( US_FileNameOnlyPathAndName( PRGFILES[1] ) + '.RC' )
                        Out := Out + PUB_cCharTab + 'echo ' + US_ShortName(PUB_cProjectFolder) + DEF_SLASH + US_FileNameOnlyName( PRGFILES[1] ) + '.Res' + ' >> _'+PUB_cSecu+'Script.ld' + Hb_OsNewLine()
                     EndIf
                     For i := 1 To Len ( vLibIncludeFiles )
                        if US_Upper( US_Word( GetProperty( "VentanaMain" , "GIncFiles" , "Cell" , i , NCOLINCFULLNAME ) , 2 ) ) == "*FIRST*" && for .res
                           if file( GetMiniGuiFolder() + DEF_SLASH + "Resources" + DEF_SLASH + US_FileNameOnlyName( vLibIncludeFiles[i] ) + '.res' )
                              Out := Out + PUB_cCharTab + 'echo ' + US_ShortName( GetMiniGuiFolder()) + DEF_SLASH + "resources" + DEF_SLASH + US_FileNameOnlyName( vLibIncludeFiles[i] ) + '.res' + ' >> _'+PUB_cSecu+'Script.ld ' + Hb_OsNewLine()
                           endif
                        endif
                     Next i

                     // Busca el .res de la minigui correcta
                     if file( GetMiniGuiFolder() + DEF_SLASH + 'RESOURCES' + DEF_SLASH + substr( GetMiniGuiName() , 1 , at( "." , GetMiniGuiName() ) - 1 ) + '.res' )
                        Out := Out + PUB_cCharTab + 'echo ' + US_ShortName( GetMiniGuiFolder()) + DEF_SLASH + 'RESOURCES' + DEF_SLASH + substr( GetMiniGuiName() , 1 , at( "." , GetMiniGuiName() ) - 1 ) + '.res >> _'+PUB_cSecu+'Script.ld' + HB_OsNewLine()
                     else
                        // Si no encontro el .res de la minigui correcta y estamos en xHarbour, busca el .res sin x
                        if QPM_IsXHarbour() .and. file( GetMiniGuiFolder() + DEF_SLASH + 'RESOURCES' + DEF_SLASH + substr( GetMiniGuiName() , 2 , at( "." , GetMiniGuiName() ) - 2 ) + '.res' )
                           Out := Out + PUB_cCharTab + 'echo ' + US_ShortName( GetMiniGuiFolder()) + DEF_SLASH + 'RESOURCES' + DEF_SLASH + substr( GetMiniGuiName() , 2 , at( "." , GetMiniGuiName() ) - 2 ) + '.res >> _'+PUB_cSecu+'Script.ld' + HB_OsNewLine()
                        endif
                     endif

                     DO EVENTS

                     For i=1 to len( &( 'vLibDefault'+GetSuffix() ) )
                        if Getminiguisuffix() == DefineOohg3 .and. ;
                           ( US_Upper( &('vLibDefault'+GetSuffix()+'['+str(i)+']') ) == "HBPRINTER.LIB" .or. ;
                             US_Upper( &('vLibDefault'+GetSuffix()+'['+str(i)+']') ) == "MINIPRINT.LIB" )
                            US_Nop()
                        else
                           if ascan( vLibExcludeFiles , US_Upper( &( 'vLibDefault'+GetSuffix()+'['+str(i)+']' ) ) ) = 0
                              if file( GetMiniGuiFolder() + DEF_SLASH + 'RESOURCES' + DEF_SLASH + US_FileNameOnlyName( &('vLibDefault'+GetSuffix()+'['+str(i)+']') ) + '.res' )
                                 Out := Out + PUB_cCharTab + 'echo ' + US_ShortName( GetMiniGuiFolder())+DEF_SLASH + 'RESOURCES' + DEF_SLASH + US_FileNameOnlyName( &('vLibDefault'+GetSuffix()+'['+str(i)+']') ) + '.res >> _'+PUB_cSecu+'Script.ld' + HB_OsNewLine()
                              endif
                           endif
                        endif
                     Next i

                     DO EVENTS

                     For i := 1 To Len ( vLibIncludeFiles )
                        if US_Upper( US_Word( GetProperty( "VentanaMain" , "GIncFiles" , "Cell" , i , NCOLINCFULLNAME ) , 2 ) ) == "*LAST*" && for .res
                           if file( GetMiniGuiFolder() + DEF_SLASH + "Resources" + DEF_SLASH + US_FileNameOnlyName( vLibIncludeFiles[i] ) + '.res' )
                              Out := Out + PUB_cCharTab + 'echo ' + US_ShortName( GetMiniGuiFolder())+ DEF_SLASH + "resources" + DEF_SLASH + US_FileNameOnlyName( vLibIncludeFiles[i] ) + '.res >> _'+PUB_cSecu+'Script.ld ' + Hb_OsNewLine()
                           endif
                        endif
                     Next i
                  endif
               case IsBorland
                  For i := 1 To Len ( vLibIncludeFiles )
                     if US_Upper( US_Word( GetProperty( "VentanaMain" , "GIncFiles" , "Cell" , i , NCOLINCFULLNAME ) , 2 ) ) == "*FIRST*"
                        Out := Out + PUB_cCharTab + 'echo ' + US_ShortName(vLibIncludeFiles[i]) + ' + >> _'+PUB_cSecu+'Script.ld ' + Hb_OsNewLine()
                     endif
                  Next i
                  if !bConsole
                     Out := Out + PUB_cCharTab + 'echo ' + US_ShortName(GetMiniGuiFolder()) + DEF_SLASH + 'LIB' + DEF_SLASH + GetMiniGuiName() + ' + >> _'+PUB_cSecu+'Script.ld' + HB_OsNewLine()
                     if ascan( vLibExcludeFiles , US_Upper( GetMiniGuiName() ) ) > 0
                        MsgInfo( 'Warning: ' + GetMiniGuiName() + ' EXCLUDED for non Console Mode.  Look at ' + PageLIB )
                     endif
                  else
                     if ascan( vLibExcludeFiles , US_Upper( GetMiniGuiName() ) ) = 0
                        Out := Out + PUB_cCharTab + 'echo ' + US_ShortName(GetMiniGuiFolder()) + DEF_SLASH + 'LIB' + DEF_SLASH + GetMiniGuiName() + ' + >> _'+PUB_cSecu+'Script.ld' + HB_OsNewLine()
                     endif
                  endif

                  DO EVENTS

                  // Algoritmo de busqueda para 1x
                  // 1.- Que no este excluida
                  // 2.- si es user lib la busco con X (si es xharbour) o sin X (si no es xHArbour) en el directorio de minigui
                  //     si esta la agrego
                  //     sino, solo cuando es xharbour, la busco con x en xHarbour
                  //           si no esta, solo cuando es xharbour, la busco sin X en xHarbour
                  //     si no es xHarbour y no estaba en minigui folder, la busco sin X harbour folder
                  // 3.- si no es userlib, la busco siempre sin X en los tres directorios
                  For i=1 to len( &( 'vLibDefault'+GetSuffix() ) )
                     if ascan( vLibExcludeFiles , US_Upper( &( 'vLibDefault'+GetSuffix()+'['+str(i)+']' ) ) ) = 0
                        if US_Upper( &('vLibDefault'+GetSuffix()+'['+str(i)+']') ) == "HBPRINTER.LIB" .or. ;
                           US_Upper( &('vLibDefault'+GetSuffix()+'['+str(i)+']') ) == "MINIPRINT.LIB" .or. ;
                           US_Upper( &('vLibDefault'+GetSuffix()+'['+str(i)+']') ) == "PROPGRID.LIB" .or. ;
                           US_Upper( &('vLibDefault'+GetSuffix()+'['+str(i)+']') ) == "SOCKET.LIB"
                           if File( GetMiniGuiFolder() + DEF_SLASH + 'lib' + DEF_SLASH + if(QPM_IsXHarbour(),"x","") + &('vLibDefault'+GetSuffix()+'['+str(i)+']') )
                              Out := Out + PUB_cCharTab + 'echo $(DIR_MINIGUI_LIB)' + DEF_SLASH + if(QPM_IsXHarbour(),"x","") + &('vLibDefault'+GetSuffix()+'['+str(i)+']') + ' + >> _'+PUB_cSecu+'Script.ld' + HB_OsNewLine()
                           else
                              if QPM_IsXHarbour()
                                 if File( GetHarbourLibFolder() + DEF_SLASH + "x" + &('vLibDefault'+GetSuffix()+'['+str(i)+']') )
                                    Out := Out + PUB_cCharTab + 'echo $(DIR_HARBOUR_LIB)' + DEF_SLASH + "x" + &('vLibDefault'+GetSuffix()+'['+str(i)+']') + ' + >> _'+PUB_cSecu+'Script.ld' + HB_OsNewLine()
                                 else
                                    if File( GetHarbourLibFolder() + DEF_SLASH + &('vLibDefault'+GetSuffix()+'['+str(i)+']') )
                                       Out := Out + PUB_cCharTab + 'echo $(DIR_HARBOUR_LIB)' + DEF_SLASH + &('vLibDefault'+GetSuffix()+'['+str(i)+']') + ' + >> _'+PUB_cSecu+'Script.ld' + HB_OsNewLine()
                                    endif
                                 endif
                              else
                                 if File( GetHarbourLibFolder() + DEF_SLASH + &('vLibDefault'+GetSuffix()+'['+str(i)+']') )
                                    Out := Out + PUB_cCharTab + 'echo $(DIR_HARBOUR_LIB)' + DEF_SLASH + &('vLibDefault'+GetSuffix()+'['+str(i)+']') + ' + >> _'+PUB_cSecu+'Script.ld' + HB_OsNewLine()
                                 endif
                              endif
                           endif
                        else
                           if File( GetHarbourLibFolder() + DEF_SLASH + &('vLibDefault'+GetSuffix()+'['+str(i)+']') )
                           /* lolo */
                              /* Este parche es para algunas versiones de Harbour */
                              Do Case
                                 Case GetMiniGuiSuffix() == DefineOohg3
                                    /* Este parche es para evitar que dentro de la DLL esten todas las funciones de ZIP */
                                    if cOutputType == "SRCDLL" .and. US_Upper( &('vLibDefault'+GetSuffix()+'['+str(i)+']') ) == "ZIPARCHIVE.LIB"
                                       US_Nop()
                                    else
                                       Out := Out + PUB_cCharTab + 'echo $(DIR_HARBOUR_LIB)' + DEF_SLASH + &('vLibDefault'+GetSuffix()+'['+str(i)+']') + ' + >> _'+PUB_cSecu+'Script.ld' + HB_OsNewLine()
                                    endif
                                 Otherwise
                                 // if ( ( !PUB_bDebugActive .and. US_Upper( &('vLibDefault'+GetSuffix()+'['+str(i)+']') ) == "GTWIN.LIB" ) .and. ;
                                 //      ( !bConsole .and. US_Upper( &('vLibDefault'+GetSuffix()+'['+str(i)+']') ) == "GTWIN.LIB" ) ) .or. ;
                                 //    ( ( PUB_bDebugActive .and. US_Upper( &('vLibDefault'+GetSuffix()+'['+str(i)+']') ) == "GTGUI.LIB" ) .or. ;
                                 //      ( bConsole .and. US_Upper( &('vLibDefault'+GetSuffix()+'['+str(i)+']') ) == "GTGUI.LIB" ) )
                                 //    if GetMiniGuiSuffix() == DefineMiniGui1
                                 //       Out := Out + PUB_cCharTab + 'echo $(DIR_HARBOUR_LIB)' + DEF_SLASH + &('vLibDefault'+GetSuffix()+'['+str(i)+']') + ' + >> _'+PUB_cSecu+'Script.ld' + HB_OsNewLine()
                                 //    else
                                 //       US_Nop()
                                 //    endif
                                 // else
                                       /* Este parche es para evitar que dentro de la DLL esten todas las funciones de ZIP */
                                       if cOutputType == "SRCDLL" .and. US_Upper( &('vLibDefault'+GetSuffix()+'['+str(i)+']') ) == "ZIPARCHIVE.LIB"
                                          US_Nop()
                                       else
                                          Out := Out + PUB_cCharTab + 'echo $(DIR_HARBOUR_LIB)' + DEF_SLASH + &('vLibDefault'+GetSuffix()+'['+str(i)+']') + ' + >> _'+PUB_cSecu+'Script.ld' + HB_OsNewLine()
                                       endif
                                 // endif
                              EndCase
                           endif
                        endif
                     endif
                  next

                  DO EVENTS

                  For i := 1 To Len ( vLibIncludeFiles )
                     if US_Upper( US_Word( GetProperty( "VentanaMain" , "GIncFiles" , "Cell" , i , NCOLINCFULLNAME ) , 2 ) ) == "*LAST*"
                        Out := Out + PUB_cCharTab + 'echo ' + US_ShortName(vLibIncludeFiles[i]) + ' + >> _'+PUB_cSecu+'Script.ld ' + Hb_OsNewLine()
                     endif
                  Next i
                  Out := Out + PUB_cCharTab + 'echo $(DIR_COMPC_LIB)'+DEF_SLASH+'import32.lib + >> _'+PUB_cSecu+'Script.ld' + HB_OsNewLine()
                  Out := Out + PUB_cCharTab + 'echo $(DIR_COMPC_LIB)'+DEF_SLASH+'PSDK'+DEF_SLASH+'msimg32.lib + >> _'+PUB_cSecu+'Script.ld' + HB_OsNewLine()
            //    if cOutputType == "SRCEXE"
                     Out := Out + PUB_cCharTab + 'echo $(DIR_COMPC_LIB)'+DEF_SLASH+'cw32.lib, >> _'+PUB_cSecu+'Script.ld' + HB_OsNewLine()
            //    endif
            //    if cOutputType == "SRCDLL"
            //       Out := Out + PUB_cCharTab + 'echo $(DIR_COMPC_LIB)'+DEF_SLASH+'cw32i.lib, >> _'+PUB_cSecu+'Script.ld' + HB_OsNewLine()
            //    endif
            //    Out := Out + PUB_cCharTab + 'echo , >> _'+PUB_cSecu+'Script.ld' + HB_OsNewLine()
                  if !bConsole
                     If File( US_FileNameOnlyPathAndName( PRGFILES[1] ) + '.RC' )
                        Out := Out + PUB_cCharTab + 'echo ' + US_ShortName(PUB_cProjectFolder) + DEF_SLASH + US_FileNameOnlyName( PRGFILES[1] ) + '.Res' + ' + >> _'+PUB_cSecu+'Script.ld' + Hb_OsNewLine()
                     EndIf

                     DO EVENTS

                     For i := 1 To Len ( vLibIncludeFiles )
                        if US_Upper( US_Word( GetProperty( "VentanaMain" , "GIncFiles" , "Cell" , i , NCOLINCFULLNAME ) , 2 ) ) == "*FIRST*" && for .res
                           if file( GetMiniGuiFolder() + DEF_SLASH + "Resources" + DEF_SLASH + US_FileNameOnlyName( vLibIncludeFiles[i] ) + '.res' )
                              Out := Out + PUB_cCharTab + 'echo ' + US_ShortName( GetMiniGuiFolder()) + DEF_SLASH + "resources" + DEF_SLASH + US_FileNameOnlyName( vLibIncludeFiles[i] ) + '.res' + ' + >> _'+PUB_cSecu+'Script.ld ' + Hb_OsNewLine()
                           endif
                        endif
                     Next i

                     // Busca el .res de la minigui correcta
                     if file( GetMiniGuiFolder() + DEF_SLASH + 'RESOURCES' + DEF_SLASH + substr( GetMiniGuiName() , 1 , at( "." , GetMiniGuiName() ) - 1 ) + '.res' )
                        Out := Out + PUB_cCharTab + 'echo ' + US_ShortName( GetMiniGuiFolder()) + DEF_SLASH + 'RESOURCES' + DEF_SLASH + substr( GetMiniGuiName() , 1 , at( "." , GetMiniGuiName() ) - 1 ) + '.res + >> _'+PUB_cSecu+'Script.ld' + HB_OsNewLine()
                     else
                        // Si no encontro el .res de la minigui correcta y estamos en xHarbour, busca el .res sin x
                        if QPM_IsXHarbour() .and. file( GetMiniGuiFolder() + DEF_SLASH + 'RESOURCES' + DEF_SLASH + substr( GetMiniGuiName() , 2 , at( "." , GetMiniGuiName() ) - 2 ) + '.res' )
                          Out := Out + PUB_cCharTab + 'echo ' + US_ShortName( GetMiniGuiFolder()) + DEF_SLASH + 'RESOURCES' + DEF_SLASH + substr( GetMiniGuiName() , 2 , at( "." , GetMiniGuiName() ) - 2 ) + '.res + >> _'+PUB_cSecu+'Script.ld' + HB_OsNewLine()
                        endif
                     endif

                     DO EVENTS

                     For i=1 to len( &( 'vLibDefault'+GetSuffix() ) )
                        if Getminiguisuffix() == DefineOohg3 .and. ;
                           ( US_Upper( &('vLibDefault'+GetSuffix()+'['+str(i)+']') ) == "HBPRINTER.LIB" .or. ;
                             US_Upper( &('vLibDefault'+GetSuffix()+'['+str(i)+']') ) == "MINIPRINT.LIB" )
                           US_Nop()
                        else
                           if ascan( vLibExcludeFiles , US_Upper( &( 'vLibDefault'+GetSuffix()+'['+str(i)+']' ) ) ) = 0
                              if file( GetMiniGuiFolder() + DEF_SLASH + 'RESOURCES' + DEF_SLASH + US_FileNameOnlyName( &('vLibDefault'+GetSuffix()+'['+str(i)+']') ) + '.res' )
                                 Out := Out + PUB_cCharTab + 'echo ' + US_ShortName( GetMiniGuiFolder())+DEF_SLASH + 'RESOURCES' + DEF_SLASH + US_FileNameOnlyName( &('vLibDefault'+GetSuffix()+'['+str(i)+']') ) + '.res' + ' + >> _'+PUB_cSecu+'Script.ld' + HB_OsNewLine()
                              endif
                           endif
                        endif
                     Next i

                     DO EVENTS

                     For i := 1 To Len ( vLibIncludeFiles )
                        if US_Upper( US_Word( GetProperty( "VentanaMain" , "GIncFiles" , "Cell" , i , NCOLINCFULLNAME ) , 2 ) ) == "*LAST*" && for .res
                           if file( GetMiniGuiFolder() + DEF_SLASH + "Resources" + DEF_SLASH + US_FileNameOnlyName( vLibIncludeFiles[i] ) + '.res' )
                              Out := Out + PUB_cCharTab + 'echo ' + US_ShortName( GetMiniGuiFolder())+ DEF_SLASH + "resources" + DEF_SLASH + US_FileNameOnlyName( vLibIncludeFiles[i] ) + '.res' + ' + >> _'+PUB_cSecu+'Script.ld ' + Hb_OsNewLine()
                           endif
                        endif
                     Next i
                  endif
               otherwise
                  US_Log( "Error 6127" )
            endcase
         case cOutputType == "SRCLIB"
            For i := 1 To Len ( PrgFiles )
               do case
                  case IsMinGW
                  case IsPelles
                     if i==1
                        Out := Out + PUB_cCharTab + 'echo /out:$@ ' + '> _'+PUB_cSecu+'Script.ld ' + Hb_OsNewLine()
                     endif
                     Out := Out + PUB_cCharTab + 'echo $(DIR_OBJECTS)' + DEF_SLASH + US_FileNameOnlyName( PRGFILES[i] ) + '.obj ' + '>> _'+PUB_cSecu+'Script.ld ' + Hb_OsNewLine()
                  case IsBorland
                     // La siguiente linea tiene el string *AMPERSAND* porque en el sistema operativo Windows 2003 Server Enterprise Edition si codifico el & no funciona el PIPE (>)
                     Out := Out + PUB_cCharTab + 'echo +$(DIR_OBJECTS)' + DEF_SLASH + US_FileNameOnlyName( PRGFILES[i] ) + '.obj ' + if(i<len(PrgFiles),'*AMPERSAND* ',' ') + if(i>1,'>','') + '> _'+PUB_cSecu+'Script.ld ' + Hb_OsNewLine()
                  otherwise
                     US_Log( "Error 6143" )
               endcase
            Next i
         otherwise
            MsgInfo( "Invalid Output Type: "+cOutputType )
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
               case cOutputType == "SRCEXE"
                  Out := Out + PUB_cCharTab + '$(US_MSG_EXE) $(DIR_PROJECT)' + DEF_SLASH + '_'+PUB_cSecu+'Progress.Log -MSG:Linking to make ' + cOutputNameDisplay + ' ...' + Hb_OsNewLine()
/*
 * Las versiones nuevas de gcc no suportan el flag -mno-cygwin
                  Out := Out + PUB_cCharTab + '$(REDIR) $(ILINK_EXE) -Wall -mno-cygwin $(USER_FLAGS_LINK) -o $(APP_NAME) ' + (CCOMPILERFOLDER+DEF_SLASH+'_'+PUB_cSecu+'Script.ld') + if( bConsole , ' -mconsole ' , if( PUB_bDebugActive , ' ' , ' -mwindows ') ) + Hb_OsNewLine()
 */
                  Out := Out + PUB_cCharTab + '$(REDIR) $(ILINK_EXE) -Wall $(USER_FLAGS_LINK) -o $(APP_NAME) ' + (CCOMPILERFOLDER+DEF_SLASH+'_'+PUB_cSecu+'Script.ld') + if( bConsole , ' -mconsole ' , if( PUB_bDebugActive , ' ' , ' -mwindows ') ) + Hb_OsNewLine()
                  if bUpx
                     Out := Out + PUB_cCharTab + '$(US_MSG_EXE) $(DIR_PROJECT)' + DEF_SLASH + '_'+PUB_cSecu+'Progress.Log -MSG:Compressing ' + cOutputNameDisplay + ' with UPX ...' + Hb_OsNewLine()
                     Out := Out + PUB_cCharTab + '$(US_UPX_EXE) ' + cUpxOpt + ' ' + cOutputName + ' ' + Hb_OsNewLine()
                  endif
               case cOutputType == "SRCDLL"
                  Out := Out + PUB_cCharTab + '$(US_MSG_EXE) $(DIR_PROJECT)' + DEF_SLASH + '_'+PUB_cSecu+'Progress.Log -MSG:Making Dynamic Library (DLL) ' + cOutputNameDisplay + ' ...' + Hb_OsNewLine()
                  Out := Out + PUB_cCharTab + '$(REDIR) $(ILINK_EXE) -shared -o $(APP_NAME) ' + (CCOMPILERFOLDER+DEF_SLASH+'_'+PUB_cSecu+'Script.ld')
                  For i := 1 To Len ( vLibIncludeFiles )
                     if US_Upper( US_Word( GetProperty( "VentanaMain" , "GIncFiles" , "Cell" , i , NCOLINCFULLNAME ) , 2 ) ) == "*FIRST*"
                        if file( GetMiniGuiFolder() + DEF_SLASH + "Resources" + DEF_SLASH + substr( US_FileNameOnlyName( vLibIncludeFiles[i] ) , 4 ) + '.o' )
                           Out := Out + PUB_cCharTab + '$(DIR_MINIGUI_RES)' + DEF_SLASH + substr( US_FileNameOnlyName( vLibIncludeFiles[i] ) , 4 ) + '.o'
                        endif
                     endif
                  Next i
               case cOutputType == "SRCLIB"
                  Out := Out + PUB_cCharTab + '$(US_MSG_EXE) $(DIR_PROJECT)' + DEF_SLASH + '_'+PUB_cSecu+'Progress.Log -MSG:Making Library ' + cOutputNameDisplay + ' ...' + Hb_OsNewLine()
                  For i := 1 To Len ( PrgFiles )
                     Out := Out + PUB_cCharTab + '$(REDIR) $(TLIB_EXE) rc ' + cOutputName + ' $(DIR_OBJECTS)' + DEF_SLASH + US_FileNameOnlyName( PRGFILES[i] ) + '.o ' + Hb_OsNewLine()
                  Next i
               otherwise
                  Out := Out + PUB_cCharTab + '$(US_MSG_EXE) $(DIR_PROJECT)' + DEF_SLASH + '_'+PUB_cSecu+'Progress.Log -MSG:Output Type Invalid: '+cOutputType + Hb_OsNewLine()
            endcase
         case IsPelles
            do case
               case cOutputType == "SRCEXE"
                  Out := Out + PUB_cCharTab + '$(US_MSG_EXE) $(DIR_PROJECT)' + DEF_SLASH + '_'+PUB_cSecu+'Progress.Log -MSG:Linking to make ' + cOutputNameDisplay + ' ...' + Hb_OsNewLine()
                  Out := Out + PUB_cCharTab + '$(ILINK_EXE) ' + if( !bConsole , If( !PUB_bDebugActive,' /SUBSYSTEM:WINDOWS ',' /SUBSYSTEM:CONSOLE ') , ' /SUBSYSTEM:CONSOLE ' ) +' $(USER_FLAGS_LINK) @_'+PUB_cSecu+'Script.ld' + Hb_OsNewLine()
                  if bUpx
                     Out := Out + PUB_cCharTab + '$(US_MSG_EXE) $(DIR_PROJECT)' + DEF_SLASH + '_'+PUB_cSecu+'Progress.Log -MSG:Compressing ' + cOutputNameDisplay + ' with UPX ...' + Hb_OsNewLine()
                     Out := Out + PUB_cCharTab + '$(US_UPX_EXE) ' + cUpxOpt + ' ' + cOutputName + Hb_OsNewLine()
                  endif
               case cOutputType == "SRCDLL"
                  Out := Out + PUB_cCharTab + '$(US_MSG_EXE) $(DIR_PROJECT)' + DEF_SLASH + '_'+PUB_cSecu+'Progress.Log -MSG:Making Dynamic Library (DLL) ' + cOutputNameDisplay + ' ...' + Hb_OsNewLine()
                  Out := Out + PUB_cCharTab + '$(ILINK_EXE) ' + if( !bConsole , ' -Gn -Tpd '+If(PUB_bDebugActive,' -ap ',' -aa ') , ' -x -Gn -Tpd ' ) +' -L'+ US_ShortName(GetCppFolder()) + DEF_SLASH + 'LIB' + ' @_'+PUB_cSecu+'Script.ld' + Hb_OsNewLine()
               case cOutputType == "SRCLIB"
                  Out := Out + PUB_cCharTab + '$(US_MSG_EXE) $(DIR_PROJECT)' + DEF_SLASH + '_'+PUB_cSecu+'Progress.Log -MSG:Making Library ' + cOutputNameDisplay + ' ...' + Hb_OsNewLine()
                  Out := Out + PUB_cCharTab + '$(TLIB_EXE) @_'+PUB_cSecu+'Script.ld' + Hb_OsNewLine()
               otherwise
                  Out := Out + PUB_cCharTab + '$(US_MSG_EXE) $(DIR_PROJECT)' + DEF_SLASH + '_'+PUB_cSecu+'Progress.Log -MSG:Output Type Invalid: '+cOutputType + Hb_OsNewLine()
            endcase
         case IsBorland
            do case
               case cOutputType == "SRCEXE"
                  Out := Out + PUB_cCharTab + '$(US_MSG_EXE) $(DIR_PROJECT)' + DEF_SLASH + '_'+PUB_cSecu+'Progress.Log -MSG:Linking to make ' + cOutputNameDisplay + ' ...' + Hb_OsNewLine()
                  Out := Out + PUB_cCharTab + '$(ILINK_EXE) ' + if( !bConsole , ' -Gn -Tpe '+If(PUB_bDebugActive,' -ap ',' -aa ') , ' -x -Gn ' ) +' $(USER_FLAGS_LINK) -L'+ US_ShortName(GetCppFolder()) + DEF_SLASH + 'LIB' + ' @_'+PUB_cSecu+'Script.ld' + Hb_OsNewLine()
                  if bUpx
                     Out := Out + PUB_cCharTab + '$(US_MSG_EXE) $(DIR_PROJECT)' + DEF_SLASH + '_'+PUB_cSecu+'Progress.Log -MSG:Compressing ' + cOutputNameDisplay + ' with UPX ...' + Hb_OsNewLine()
                     Out := Out + PUB_cCharTab + '$(US_UPX_EXE) ' + cUpxOpt + ' ' + cOutputName + Hb_OsNewLine()
                  endif
               case cOutputType == "SRCDLL"
                  Out := Out + PUB_cCharTab + '$(US_MSG_EXE) $(DIR_PROJECT)' + DEF_SLASH + '_'+PUB_cSecu+'Progress.Log -MSG:Making Dynamic Library (DLL) ' + cOutputNameDisplay + ' ...' + Hb_OsNewLine()
                  Out := Out + PUB_cCharTab + '$(ILINK_EXE) ' + if( !bConsole , ' -Gn -Tpd '+If(PUB_bDebugActive,' -ap ',' -aa ') , ' -x -Gn -Tpd ' ) +' -L'+ US_ShortName(GetCppFolder()) + DEF_SLASH + 'LIB' + ' @_'+PUB_cSecu+'Script.ld' + Hb_OsNewLine()
               case cOutputType == "SRCLIB"
                  Out := Out + PUB_cCharTab + '$(US_MSG_EXE) $(DIR_PROJECT)' + DEF_SLASH + '_'+PUB_cSecu+'Progress.Log -MSG:Making Library ' + cOutputNameDisplay + ' ...' + Hb_OsNewLine()
                  // La siguiente linea tiene el string *AMPERSAND* porque en el sistema operativo Windows 2003 Server Enterprise Edition si codifico el & no funciona el PIPE (>)
                  Out := Out + PUB_cCharTab + '$(US_SHELL_EXE) CHANGE _'+PUB_cSecu+'Script.ld *AMPERSAND* & ' + Hb_OsNewLine()
                  Out := Out + PUB_cCharTab + '$(TLIB_EXE) /P32 $@ @_'+PUB_cSecu+'Script.ld' + Hb_OsNewLine()
               otherwise
                  Out := Out + PUB_cCharTab + '$(US_MSG_EXE) $(DIR_PROJECT)' + DEF_SLASH + '_'+PUB_cSecu+'Progress.Log -MSG:Output Type Invalid: '+cOutputType + Hb_OsNewLine()
            endcase
         otherwise
            US_Log( "Error 6255" )
      endcase

      // Copy or Move
      
      if cOutputCopyMove == "COPY" .or. cOutputCopyMove == "MOVE"
         if IsMinGW
            Out := Out + Hb_OsNewLine()
         endif
         Out := Out + PUB_cCharTab + '$(US_MSG_EXE) $(DIR_PROJECT)' + DEF_SLASH + '_'+PUB_cSecu+'Progress.Log -MSG:' + cOutputCopyMove + ' '+cOutputNameDisplay+' to ' + Prj_Text_OutputCopyMoveFolder + DEF_SLASH + US_FileNameOnlyNameAndExt( cOutputNameDisplay ) + ' ...' + Hb_OsNewLine()
         Out := Out + PUB_cCharTab + '$(US_SHELL_EXE) ' + cOutputCopyMove + ' ' + cOutputName + ' ' + US_ShortName( Prj_Text_OutputCopyMoveFolder ) + DEF_SLASH + US_FileNameOnlyNameAndExt( cOutputName ) + Hb_OsNewLine()
      endif

      if PUB_bDebugActive
         if cOutputCopyMove == "MOVE"
            DebugOptions( US_ShortName( Prj_Text_OutputCopyMoveFolder ) , cDebugPath )
         else
            if cOutputCopyMove == "COPY"
               DebugOptions( US_ShortName( Prj_Text_OutputCopyMoveFolder ) , cDebugPath )
            endif
            DebugOptions( US_FileNameOnlyPath( cOutputName ) , cDebugPath )
         endif
         if !empty( VentanaMain.TRunProjectFolder.Value )
            DebugOptions( US_FileNameOnlyPath( VentanaMain.TRunProjectFolder.Value ) , cDebugPath )
         endif
      endif

      DO EVENTS

      For i := 1 To Len ( PrgFiles )
         Out := Out + Hb_OsNewLine()
         Out := Out + '$(C_DIR)' + DEF_SLASH + US_FileNameOnlyName( PRGFILES[i] ) + '.' + if( upper( US_FileNameOnlyExt( PRGFILES[i] ) ) == "CPP" , 'cpp' , 'c' ) + ' : ' + US_ShortName( US_FileNameOnlyPath( PRGFILES[i] ) ) + DEF_SLASH + US_FileNameOnlyNameAndExt( PRGFILES[i] ) + Hb_OsNewLine()
         Out := Out + PUB_cCharTab + '$(US_MSG_EXE) $(DIR_PROJECT)' + DEF_SLASH + '_'+PUB_cSecu+'Progress.Log -MSG:Processing ' + PRGFILES[i] + ' ...' + Hb_OsNewLine()
         if US_Upper( US_FileNameOnlyExt( PRGFILES[i] ) ) == US_Upper( "C" ) .or. ;
            US_Upper( US_FileNameOnlyExt( PRGFILES[i] ) ) == US_Upper( "CPP" )
            Out := Out + PUB_cCharTab + if(!bLogActivity,'@','')+'$(US_SHELL_EXE) '+if(!bLogActivity,'-OFF','')+ ' COPYZAP $** $@' + Hb_OsNewLine()
         else
            Out := Out + PUB_cCharTab + if(!bLogActivity,'@','')+'-$(US_SHELL_EXE) '+if(!bLogActivity,'-OFF','')+' DELETE $@ ' + Hb_OsNewLine()
            IF Prj_Check_HarbourIs31 .and. IsBorland
               Out := Out + PUB_cCharTab + '$(HARBOUR_EXE) $(HARBOUR_FLAGS) ' + if( QPM_IsXHarbour() , '/p' , '/p$(DIR_OBJECTS)' + DEF_SLASH + US_FileNameOnlyName( PRGFILES[i] ) ) + ' $** -o$@' + Hb_OsNewLine()
            ELSE
               Out := Out + PUB_cCharTab + '$(REDIR) $(HARBOUR_EXE) $(HARBOUR_FLAGS) ' + if( QPM_IsXHarbour() , '/p' , '/p$(DIR_OBJECTS)' + DEF_SLASH + US_FileNameOnlyName( PRGFILES[i] ) ) + ' $** -o$@' + Hb_OsNewLine()
            ENDIF
            if QPM_IsXHarbour()
               Out := Out + PUB_cCharTab + if(!bLogActivity,'@','')+'-$(US_SHELL_EXE) '+if(!bLogActivity,'-OFF','')+' MOVE ' + US_ShortName( US_FileNameOnlyPath( PRGFILES[i] ) ) + DEF_SLASH + US_FileNameOnlyName( PRGFILES[i] ) + '.ppo $(DIR_OBJECTS)' + DEF_SLASH + US_FileNameOnlyName( PRGFILES[i] ) + '.ppo' + Hb_OsNewLine()
               Out := Out + PUB_cCharTab + if(!bLogActivity,'@','')+'-$(US_SHELL_EXE) '+if(!bLogActivity,'-OFF','')+' DELETE ' + US_ShortName( US_FileNameOnlyPath( PRGFILES[i] ) ) + DEF_SLASH + US_FileNameOnlyName( PRGFILES[i] ) + '.ppo.MOVED.TXT ' + Hb_OsNewLine()
            else
               Out := Out + PUB_cCharTab + if(!bLogActivity,'@','')+'-$(US_SHELL_EXE) '+if(!bLogActivity,'-OFF','')+' MOVE $(DIR_OBJECTS)' + DEF_SLASH + US_FileNameOnlyName( PRGFILES[i] ) + ' $(DIR_OBJECTS)' + DEF_SLASH + US_FileNameOnlyName( PRGFILES[i] ) + '.ppo' + Hb_OsNewLine()
               Out := Out + PUB_cCharTab + if(!bLogActivity,'@','')+'-$(US_SHELL_EXE) '+if(!bLogActivity,'-OFF','')+' DELETE $(DIR_OBJECTS)' + DEF_SLASH + US_FileNameOnlyName( PRGFILES[i] ) + '.MOVED.TXT ' + Hb_OsNewLine()
            endif
            Out := Out + PUB_cCharTab + if(!bLogActivity,'@','')+'$(US_SHELL_EXE) '+if(!bLogActivity,'-OFF','')+' CHECKRC NOTFILE $@ ' + Hb_OsNewLine()
         endif
         Out := Out + Hb_OsNewLine()
         if IsMinGW
            Out := Out + '$(DIR_OBJECTS)' + DEF_SLASH + US_FileNameOnlyName( PRGFILES[i] ) + '.o : $(C_DIR)' + DEF_SLASH + US_FileNameOnlyName( PRGFILES[i] ) + '.' + if( upper( US_FileNameOnlyExt( PRGFILES[i] ) ) == "CPP" , 'cpp' , 'c' ) + Hb_OsNewLine()
         else
            Out := Out + '$(DIR_OBJECTS)' + DEF_SLASH + US_FileNameOnlyName( PRGFILES[i] ) + '.obj : $(C_DIR)' + DEF_SLASH + US_FileNameOnlyName( PRGFILES[i] ) + '.' + if( upper( US_FileNameOnlyExt( PRGFILES[i] ) ) == "CPP" , 'cpp' , 'c' ) + Hb_OsNewLine()
         endif
         do case
            case IsMinGW
               if bLogActivity
                  Out := Out + PUB_cCharTab + '-$(REDIR) $(DEF_SLASH) -List' + US_ShortName(PUB_cQPM_Folder) + ' $(COBJFLAGS) $** -o$@' + Hb_OsNewLine()
               else
                  Out := Out + PUB_cCharTab + '-$(REDIR) $(DEF_SLASH) $(COBJFLAGS) $** -o$@' + Hb_OsNewLine()
               endif
            case IsPelles
               Out := Out + PUB_cCharTab + '-$(COMPILATOR_C) $(COBJFLAGS) /Fo$@ $**' + Hb_OsNewLine()
            case IsBorland
               Out := Out + PUB_cCharTab + '-$(US_SHELL_EXE) DELETE $@' + Hb_OsNewLine()
               Out := Out + PUB_cCharTab + '-$(COMPILATOR_C) $(COBJFLAGS) -o$@ $**' + Hb_OsNewLine()
            otherwise
               US_Log( "Error 6324" )
         endcase
      Next i

   endif

   if bConvert
      Out := Out + '$(APP_NAME) : ' + US_ShortName( PRGFILES[1] ) + Hb_OsNewLine()
      do case
         case cConvert == "DLL A"
            if GetProperty( "VentanaMain" , "Check_Reimp" , "Value" )
               Out := Out + PUB_cCharTab + '$(US_MSG_EXE) $(DIR_PROJECT)' + DEF_SLASH + '_'+PUB_cSecu+'Progress.Log -MSG:Option ReImport Activate' + Hb_OsNewLine()
               Out := Out + PUB_cCharTab + '$(US_MSG_EXE) $(DIR_PROJECT)' + DEF_SLASH + '_'+PUB_cSecu+'Progress.Log -MSG:ReImport From Library ' + cInputReImpNameDisplay + Hb_OsNewLine()
               Out := Out + PUB_cCharTab + '$(REIMPORT_EXE) -d ' + cInputReImpName + Hb_OsNewLine()
               Out := Out + PUB_cCharTab + '-$(US_MSG_EXE) $(DIR_PROJECT)' + DEF_SLASH + '_'+PUB_cSecu+'Progress.Log -MSG:DLL Function List for ' + cInputNameDisplay + ' ...' + Hb_OsNewLine()
               Out := Out + PUB_cCharTab + '-$(US_SHELL_EXE) ANALIZE_DLL ' + cInputReImpDef + ".def " + Hb_OsNewLine()
               //
               Out := Out + PUB_cCharTab + '-$(US_MSG_EXE) $(DIR_PROJECT)' + DEF_SLASH + '_'+PUB_cSecu+'Progress.Log -MSG:Generating Interface Library (.' + US_Word( cConvert , 2 ) + ') for ' + cInputNameDisplay + ' ...' + Hb_OsNewLine()
               Out := Out + PUB_cCharTab + '-$(REDIR) $(IMPLIB_MGW_EXE) -k -d ' + US_USlash( cInputReImpDef ) + ".def -D " + US_FileNameOnlyNameAndExt( cInputNameDisplay ) + " -l " + US_USlash( cOutputName ) + Hb_OsNewLine()
               //
               Out := Out + PUB_cCharTab + if(!bLogActivity,'@','')+'-$(US_SHELL_EXE) '+if(!bLogActivity,'-OFF','')+' DELETE ' + cInputReImpDef + '.def ' + Hb_OsNewLine()
            else
               Out := Out + PUB_cCharTab + '$(US_MSG_EXE) $(DIR_PROJECT)' + DEF_SLASH + '_'+PUB_cSecu+'Progress.Log -MSG:DLL Function List for ' + cInputNameDisplay + ' ...' + Hb_OsNewLine()
               *NO BORRAROut := Out + PUB_cCharTab + '$(IMPDEF_MGW_EXE) ' + cInputNameLong + ".def " + cInputNameLong + Hb_OsNewLine()
               Out := Out + PUB_cCharTab + '-$(IMPDEF_MGW_EXE) ' + cInputNameLong + ' > ' + cInputNameLong + ".def " + Hb_OsNewLine()
               Out := Out + PUB_cCharTab + '-$(US_SHELL_EXE) ANALIZE_DLL ' + cInputNameLong + ".def " + Hb_OsNewLine()
               //
               Out := Out + PUB_cCharTab + '-$(US_MSG_EXE) $(DIR_PROJECT)' + DEF_SLASH + '_'+PUB_cSecu+'Progress.Log -MSG:Generating Interface Library (.' + US_Word( cConvert , 2 ) + ') for ' + cInputNameDisplay + ' ...' + Hb_OsNewLine()
               Out := Out + PUB_cCharTab + '-$(REDIR) $(IMPLIB_MGW_EXE) -d ' + US_USlash( cInputNameLong ) + ".def -D " + US_FileNameOnlyNameAndExt( cInputNameDisplay ) + " -l " + US_USlash( cOutputName ) + Hb_OsNewLine()
               //
               Out := Out + PUB_cCharTab + if(!bLogActivity,'@','')+'-$(US_SHELL_EXE) '+if(!bLogActivity,'-OFF','')+' DELETE ' + cInputNameLong + '.def ' + Hb_OsNewLine()
            endif
         case cConvert == "DLL LIB"
            do case
               case Prj_Radio_Cpp == DEF_RG_PELLES
                  Out := Out + PUB_cCharTab + '$(US_MSG_EXE) $(DIR_PROJECT)' + DEF_SLASH + '_'+PUB_cSecu+'Progress.Log -MSG:DLL Function List for ' + cInputNameDisplay + ' ...' + Hb_OsNewLine()
                  Out := Out + PUB_cCharTab + '-$(IMPDEF_PC_EXE) ' + cInputNameLong + ".def " + cInputNameLong + Hb_OsNewLine()
                  Out := Out + PUB_cCharTab + '-$(US_SHELL_EXE) ANALIZE_DLL ' + cInputNameLong + ".def " + Hb_OsNewLine()
                  //
                  Out := Out + PUB_cCharTab + '-$(US_MSG_EXE) $(DIR_PROJECT)' + DEF_SLASH + '_'+PUB_cSecu+'Progress.Log -MSG:Generating Interface Library (.' + US_Word( cConvert , 2 ) + ') for ' + cInputNameDisplay + ' ...' + Hb_OsNewLine()
                  Out := Out + PUB_cCharTab + '-$(IMPLIB_PC_EXE) ' + if( GetProperty( "VentanaMain" , "Check_GuionA" , "Value" ) , '' , '-NOUND ' ) + cInputNameLong + " -OUT:" + cOutputName + Hb_OsNewLine()
                  //
                  Out := Out + PUB_cCharTab + if(!bLogActivity,'@','')+'-$(US_SHELL_EXE) '+if(!bLogActivity,'-OFF','')+' DELETE ' + cInputNameLong + '.def ' + Hb_OsNewLine()
               case Prj_Radio_Cpp == DEF_RG_BORLAND
                  Out := Out + PUB_cCharTab + '$(US_MSG_EXE) $(DIR_PROJECT)' + DEF_SLASH + '_'+PUB_cSecu+'Progress.Log -MSG:DLL Function List for ' + cInputNameDisplay + ' ...' + Hb_OsNewLine()
                  Out := Out + PUB_cCharTab + '-$(IMPDEF_BCC_EXE) ' + cInputNameLong + ".def " + cInputNameLong + Hb_OsNewLine()
                  Out := Out + PUB_cCharTab + '-$(US_SHELL_EXE) ANALIZE_DLL ' + cInputNameLong + ".def " + Hb_OsNewLine()
                  //
                  Out := Out + PUB_cCharTab + '-$(US_MSG_EXE) $(DIR_PROJECT)' + DEF_SLASH + '_'+PUB_cSecu+'Progress.Log -MSG:Generating Interface Library (.' + US_Word( cConvert , 2 ) + ') for ' + cInputNameDisplay + ' ...' + Hb_OsNewLine()
                  Out := Out + PUB_cCharTab + '-$(IMPLIB_BCC_EXE) ' + if( GetProperty( "VentanaMain" , "Check_GuionA" , "Value" ) , '-a ' , '' ) + cOutputName + " " + cInputNameLong + Hb_OsNewLine()
                  //
                  Out := Out + PUB_cCharTab + if(!bLogActivity,'@','')+'-$(US_SHELL_EXE) '+if(!bLogActivity,'-OFF','')+' DELETE ' + cInputNameLong + '.def ' + Hb_OsNewLine()
               otherwise
                  US_Log( "Error in Convert DLL to LIB, Invalid C Compiler: " + US_VarToStr( Prj_Radio_Cpp ) )
            endcase
         case cConvert == "LIB DLL"
            Out := Out + PUB_cCharTab + '$(US_MSG_EXE) $(DIR_PROJECT)' + DEF_SLASH + '_'+PUB_cSecu+'Progress.Log -MSG:Copying Library (.' + US_Word( cConvert , 1 ) + ') to Working Folder' + ' ...' + Hb_OsNewLine()
            Out := Out + PUB_cCharTab + '$(US_SHELL_EXE) COPY ' + cInputName + ' ' + US_ShortNAme(OBJFOLDER) + DEF_SLASH + US_FileNameOnlyNameAndExt( cInputName ) + Hb_OsNewLine()
            //
            Out := Out + PUB_cCharTab + '$(US_MSG_EXE) $(DIR_PROJECT)' + DEF_SLASH + '_'+PUB_cSecu+'Progress.Log -MSG:Listing Functions in Library (.' + US_Word( cConvert , 1 ) + ')' + ' ...' + Hb_OsNewLine()
            Out := Out + PUB_cCharTab + '$(LSTLIB_EXE) ' + US_ShortNAme(OBJFOLDER) + DEF_SLASH + US_FileNameOnlyNameAndExt( cInputName ) + ", " + US_ShortNAme(OBJFOLDER) + DEF_SLASH + US_FileNameOnlyNameAndExt( cInputName ) + ".lst " + Hb_OsNewLine()
            Out := Out + PUB_cCharTab + '$(US_SHELL_EXE) ANALIZE_LIB_BORLAND ' + US_ShortNAme(OBJFOLDER) + DEF_SLASH + US_FileNameOnlyNameAndExt( cInputName ) + ".lst " + Hb_OsNewLine()
            //
            QPM_Execute( US_ShortName(PUB_cQPM_Folder) + DEF_SLASH + 'US_TLIB.EXE' , cInputName + ', ' + US_ShortNAme(OBJFOLDER) + DEF_SLASH + US_FileNameOnlyNameAndExt( cInputName ) + '.lst' , DEF_QPM_EXEC_WAIT , DEF_QPM_EXEC_MINIMIZE )
            QPM_Execute( US_ShortName(PUB_cQPM_Folder) + DEF_SLASH + 'US_SHELL.EXE' , 'QPM ANALIZE_LIB_BORLAND ' + US_ShortNAme(OBJFOLDER) + DEF_SLASH + US_FileNameOnlyNameAndExt( cInputName ) + '.lst -OBJLST -EXPLST -OFF' , DEF_QPM_EXEC_WAIT , DEF_QPM_EXEC_MINIMIZE )
            //
            MemoObj := MemoRead( US_ShortNAme(OBJFOLDER) + DEF_SLASH + US_FileNameOnlyNameAndExt( cInputName ) + '.Lst.ObjLst' )
            //
            Out := Out + PUB_cCharTab + '$(US_MSG_EXE) $(DIR_PROJECT)' + DEF_SLASH + '_'+PUB_cSecu+'Progress.Log -MSG:Extracting Modules from Library (.' + US_Word( cConvert , 1 ) + ')' + ' ...' + Hb_OsNewLine()
            Out := Out + PUB_cCharTab + '$(TLIB_EXE) ' + US_ShortNAme(OBJFOLDER) + DEF_SLASH + US_FileNameOnlyNameAndExt( cInputName )
            For i:=1 to MLCount( MemoObj , 254 )
               Out := Out + PUB_cCharTab + '*' + US_ShortNAme(OBJFOLDER) + DEF_SLASH + alltrim( memoline( MemoObj , 254 , i ) )
            next
            Out := Out + ' ' + Hb_OsNewLine()
            //
            // Out := Out + PUB_cCharTab + '$(PAUSE_EXE)' + Hb_OsNewLine()
            //
            Out := Out + PUB_cCharTab + '$(US_MSG_EXE) $(DIR_PROJECT)' + DEF_SLASH + '_'+PUB_cSecu+'Progress.Log -MSG:Making DLL from Modules Object of Library (.' + US_Word( cConvert , 1 ) + ') in ' + cOutputNameDisplay + ' ...' + Hb_OsNewLine()
            Out := Out + PUB_cCharTab + '$(ILINK_EXE) ' + if( !bConsole , ' -Gn -Tpd '+If(PUB_bDebugActive,' -ap ',' -aa ') , ' -x -Gn -Tpd ' ) +' -L'+ US_ShortName(GetCppFolder()) + DEF_SLASH + 'LIB'
            For i:=1 to MLCount( MemoObj , 254 )
               Out := Out + ' ' + US_ShortNAme(OBJFOLDER) + DEF_SLASH + alltrim( memoline( MemoObj , 254 , i ) ) + ".obj"
            next
            Out := Out + ' c0d32.obj , ' + cOutputName + ' , , import32.lib msimg32.lib cw32.lib , '
            Out := Out + ' ' + US_ShortNAme(OBJFOLDER) + DEF_SLASH + US_FileNameOnlyNameAndExt( cInputName ) + '.Lst.ExpLst' + Hb_OsNewLine()
            //
            Out := Out + PUB_cCharTab + '$(US_MSG_EXE) $(DIR_PROJECT)' + DEF_SLASH + '_'+PUB_cSecu+'Progress.Log -MSG:DLL Function List for ' + cOutputNameDisplay + ' ...' + Hb_OsNewLine()
            Out := Out + PUB_cCharTab + '$(IMPDEF_BCC_EXE) ' + cOutputName + ".def " + cOutputName + Hb_OsNewLine()
            Out := Out + PUB_cCharTab + '$(US_SHELL_EXE) ANALIZE_DLL ' + cOutputName + ".def -DELETE" + Hb_OsNewLine()
            //
            Out := Out + PUB_cCharTab + '$(US_MSG_EXE) $(DIR_PROJECT)' + DEF_SLASH + '_'+PUB_cSecu+'Progress.Log -MSG:Cleaning Temporary Files' + ' ...' + Hb_OsNewLine()
            Out := Out + PUB_cCharTab + '$(US_SHELL_EXE) DELETE ' + US_ShortNAme(OBJFOLDER) + DEF_SLASH + US_FileNameOnlyNameAndExt( cInputName ) + ' -OFF ' + Hb_OsNewLine()
            Out := Out + PUB_cCharTab + '$(US_SHELL_EXE) DELETE ' + US_ShortNAme(OBJFOLDER) + DEF_SLASH + US_FileNameOnlyNameAndExt( cInputName ) + '.lst -OFF ' + Hb_OsNewLine()
            For i:=1 to MLCount( MemoObj , 254 )
               Out := Out + PUB_cCharTab + '$(US_SHELL_EXE) DELETE ' + US_ShortNAme(OBJFOLDER) + DEF_SLASH + alltrim( memoline( MemoObj , 254 , i ) ) + '.obj -OFF ' + Hb_OsNewLine()
            next
            Out := Out + PUB_cCharTab + '$(US_SHELL_EXE) DELETE ' + US_ShortNAme(OBJFOLDER) + DEF_SLASH + US_FileNameOnlyNameAndExt( cInputName ) + '.lst.ObjLst -OFF ' + Hb_OsNewLine()
            Out := Out + PUB_cCharTab + '$(US_SHELL_EXE) DELETE ' + US_ShortNAme(OBJFOLDER) + DEF_SLASH + US_FileNameOnlyNameAndExt( cInputName ) + '.lst.ExpLst -OFF ' + Hb_OsNewLine()
         // Out := Out + PUB_cCharTab + '$(US_SHELL_EXE) DELETE ' + cOutputName + '.def -OFF ' + Hb_OsNewLine()
         case cConvert == "A DLL"
            Out := Out + PUB_cCharTab + '$(US_MSG_EXE) $(DIR_PROJECT)' + DEF_SLASH + '_'+PUB_cSecu+'Progress.Log -MSG:Copying Library (.' + US_Word( cConvert , 1 ) + ') to Working Folder' + ' ...' + Hb_OsNewLine()
            Out := Out + PUB_cCharTab + '$(US_SHELL_EXE) COPY ' + cInputName + ' ' + US_ShortNAme(OBJFOLDER) + DEF_SLASH + US_FileNameOnlyNameAndExt( cInputName ) + Hb_OsNewLine()
            //
            Out := Out + PUB_cCharTab + '$(US_MSG_EXE) $(DIR_PROJECT)' + DEF_SLASH + '_'+PUB_cSecu+'Progress.Log -MSG:Listing Functions in Library (.' + US_Word( cConvert , 1 ) + ')' + ' ...' + Hb_OsNewLine()
            Out := Out + PUB_cCharTab + '$(LSTA_EXE) -x ' + US_ShortNAme(OBJFOLDER) + DEF_SLASH + US_FileNameOnlyNameAndExt( cInputName ) + " > " + US_ShortNAme(OBJFOLDER) + DEF_SLASH + US_FileNameOnlyNameAndExt( cInputName ) + ".lst " + Hb_OsNewLine()
            Out := Out + PUB_cCharTab + '$(US_SHELL_EXE) ANALIZE_LIB_MINGW ' + US_ShortNAme(OBJFOLDER) + DEF_SLASH + US_FileNameOnlyNameAndExt( cInputName ) + ".lst " + Hb_OsNewLine()
            //
            QPM_MemoWrit( US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + '_'+PUB_cSecu+'RunShell.bat' , US_ShortName(PUB_cQPM_Folder) + DEF_SLASH + 'US_OBJDUMP.EXE -t ' + cInputName + ' > ' + US_ShortNAme(OBJFOLDER) + DEF_SLASH + US_FileNameOnlyNameAndExt( cInputName ) + '.lst' )
            QPM_Execute( US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + '_'+PUB_cSecu+'RunShell.bat' , , DEF_QPM_EXEC_WAIT , DEF_QPM_EXEC_MINIMIZE )
            ferase( US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + '_'+PUB_cSecu+'RunShell.bat' )
            QPM_Execute( US_ShortName(PUB_cQPM_Folder) + DEF_SLASH + 'US_SHELL.EXE' , 'QPM ANALIZE_LIB_MINGW ' + US_ShortNAme(OBJFOLDER) + DEF_SLASH + US_FileNameOnlyNameAndExt( cInputName ) + '.lst -OBJLST -EXPLST' , DEF_QPM_EXEC_WAIT , DEF_QPM_EXEC_MINIMIZE )
            //
            MemoObj := MemoRead( US_ShortNAme(OBJFOLDER) + DEF_SLASH + US_FileNameOnlyNameAndExt( cInputName ) + '.Lst.ObjLst' )
            //
            Out := Out + PUB_cCharTab + '$(US_MSG_EXE) $(DIR_PROJECT)' + DEF_SLASH + '_'+PUB_cSecu+'Progress.Log -MSG:Extracting Modules from Library (.' + US_Word( cConvert , 1 ) + ')' + ' ...' + Hb_OsNewLine()
            Out := Out + PUB_cCharTab + '$(REDIR) $(TLIB_EXE) x ' + US_ShortNAme(OBJFOLDER) + DEF_SLASH + US_FileNameOnlyNameAndExt( cInputName )
            For i:=1 to MLCount( MemoObj , 254 )
               Out := Out + ' ' + alltrim( memoline( MemoObj , 254 , i ) ) + ".o"
            next
            Out := Out + ' ' + Hb_OsNewLine()
            //
            Out := Out + PUB_cCharTab + '$(US_MSG_EXE) $(DIR_PROJECT)' + DEF_SLASH + '_'+PUB_cSecu+'Progress.Log -MSG:Making DLL from Modules Object of Library (.' + US_Word( cConvert , 1 ) + ') in ' + cOutputNameDisplay + ' ...' + Hb_OsNewLine()
            Out := Out + PUB_cCharTab + '$(REDIR) $(ILINK_EXE) -shared -o' + cOutputName + ' '
            For i:=1 to MLCount( MemoObj , 254 )
               Out := Out + ' ' + US_ShortName(GetCppFolder()) + DEF_SLASH + 'BIN' + DEF_SLASH + alltrim( memoline( MemoObj , 254 , i ) ) + ".o "
            next
            Out := Out + if( !bConsole , if( PUB_bDebugActive , ' ' , ' -mwindows ') , ' -mconsole ' ) + ;
                   ' -L$(DIR_COMPC)'+DEF_SLASH+'lib ' + ;
                   ' -L$(DIR_MINIGUI)'+DEF_SLASH+'lib ' + ;
                   ' -L$(DIR_HARBOUR)'+DEF_SLASH+'lib ' + Hb_OsNewLine()
            //
            Out := Out + PUB_cCharTab + '$(US_MSG_EXE) $(DIR_PROJECT)' + DEF_SLASH + '_'+PUB_cSecu+'Progress.Log -MSG:DLL Function List for ' + cOutputNameDisplay + ' ...' + Hb_OsNewLine()
            *NO BORRAROut := Out + PUB_cCharTab + '$(IMPDEF_MGW_EXE) ' + cOutputName + ".def " + cOutputName + Hb_OsNewLine()
            Out := Out + PUB_cCharTab + '$(IMPDEF_MGW_EXE) ' + cOutputName + ' > ' + cOutputName + ".def " + Hb_OsNewLine()
            Out := Out + PUB_cCharTab + '$(US_SHELL_EXE) ANALIZE_DLL ' + cOutputName + ".def -DELETE" + Hb_OsNewLine()
            //
            Out := Out + PUB_cCharTab + '$(US_MSG_EXE) $(DIR_PROJECT)' + DEF_SLASH + '_'+PUB_cSecu+'Progress.Log -MSG:Cleaning Temporary Files' + ' ...' + Hb_OsNewLine()
            Out := Out + PUB_cCharTab + '$(US_SHELL_EXE) DELETE ' + US_ShortNAme(OBJFOLDER) + DEF_SLASH + US_FileNameOnlyNameAndExt( cInputName ) + ' -OFF ' + Hb_OsNewLine()
            Out := Out + PUB_cCharTab + '$(US_SHELL_EXE) DELETE ' + US_ShortNAme(OBJFOLDER) + DEF_SLASH + US_FileNameOnlyNameAndExt( cInputName ) + '.lst -OFF ' + Hb_OsNewLine()
            For i:=1 to MLCount( MemoObj , 254 )
               Out := Out + PUB_cCharTab + '$(US_SHELL_EXE) DELETE ' + US_ShortName(GetCppFolder()) + DEF_SLASH + 'BIN' + DEF_SLASH + alltrim( memoline( MemoObj , 254 , i ) ) + '.o -OFF ' + Hb_OsNewLine()
            next
            Out := Out + PUB_cCharTab + '$(US_SHELL_EXE) DELETE ' + US_ShortNAme(OBJFOLDER) + DEF_SLASH + US_FileNameOnlyNameAndExt( cInputName ) + '.lst.ObjLst -OFF ' + Hb_OsNewLine()
            Out := Out + PUB_cCharTab + '$(US_SHELL_EXE) DELETE ' + US_ShortNAme(OBJFOLDER) + DEF_SLASH + US_FileNameOnlyNameAndExt( cInputName ) + '.lst.ExpLst -OFF ' + Hb_OsNewLine()
      endcase
   endif
// Out := Out + Hb_OsNewLine()

   DO EVENTS

   QPM_MemoWrit( PUB_cProjectFolder + DEF_SLASH + '_'+PUB_cSecu+'Temp.Bc' , Out )
/*
   Unneeded because of change in QPM_MemoWrit()

   if US_FileChar26Zap( PUB_cProjectFolder + DEF_SLASH + '_'+PUB_cSecu+'Temp.Bc' ) == -1
      US_Log( "Error in US_FileChar26Zap for file: " + PUB_cProjectFolder + DEF_SLASH + '_'+PUB_cSecu+'Temp.Bc' )
   endif
*/

   if IsMinGW
      MakeName := US_ShortName(PUB_cQPM_Folder) + If( !( Right( PUB_cQPM_Folder , 1 ) == DEF_SLASH ) , DEF_SLASH , '' ) + 'US_MAKE.EXE'
   else
      MakeName := US_ShortName(PUB_cQPM_Folder) + If( !( Right( PUB_cQPM_Folder , 1 ) == DEF_SLASH ) , DEF_SLASH , '' ) + 'US_MAKE.EXE'
   endif
   ParamString := '-f' + US_ShortName(PUB_cProjectFolder) + DEF_SLASH + '_'+PUB_cSecu+'Temp.Bc' + ' > ' + US_ShortName(GetCppFolder()) + DEF_SLASH + 'BIN' + DEF_SLASH + '_'+PUB_cSecu+'Temp.Log'
   DELETE FILE ( cOutputName )
   DELETE FILE ( cOutputName + ".MOVED" )
   DELETE FILE ( cOutputName + ".MOVED.TXT" )
   DELETE FILE ( US_ShortName( Prj_Text_OutputCopyMoveFolder ) + DEF_SLASH + US_FileNameOnlyNameAndExt( cOutputName ) )

   DO EVENTS

   do case
      case IsMinGW
      // popo
         if Getminiguisuffix() == DefineMiniGui3 .and. ;
            !bConvert
            cGT_MemoAux := memoread( US_ShortName(GetMiniGuiFolder()) + DEF_SLASH + "include" + DEF_SLASH + "minigui.ch" )
            if !( substr( cGT_MemoAux , len( cGT_MemoAux ) - len( DEF_INCLUDE_GT ) + 1 ) == DEF_INCLUDE_GT )
               QPM_Memowrit( US_ShortName(GetMiniGuiFolder()) + DEF_SLASH + "include" + DEF_SLASH + "minigui.ch" , cGT_MemoAux + HB_OsNewLine() + DEF_INCLUDE_GT )
            endif
            if !bConsole .and. !PUB_bDebugActive
               QPM_Memowrit( US_ShortName(GetMiniGuiFolder()) + DEF_SLASH + "include" + DEF_SLASH + "QPM_gt.ch" , "REQUEST HB_GT_GUI_DEFAULT" )
            else
               QPM_Memowrit( US_ShortName(GetMiniGuiFolder()) + DEF_SLASH + "include" + DEF_SLASH + "QPM_gt.ch" , "REQUEST HB_GT_WIN_DEFAULT" )
            endif
/*
            if US_FileChar26Zap( US_ShortName(GetMiniGuiFolder()) + DEF_SLASH + "include" + DEF_SLASH + "minigui.ch" ) == -1
               US_Log( "Error in US_FileChar26Zap for file: " + US_ShortName(GetMiniGuiFolder()) + DEF_SLASH + "include" + DEF_SLASH + "minigui.ch" )
            endif
*/
         endif

// NOTE: added support for MINGW and Extended: the resource file in Extended with MinGW is named hmg.rc
//         if !bConvert .and. !bConsole .and. QPM_IsXHarbour() .and. ;
//            !file( US_ShortName(GetMiniGuiFolder()) + DEF_SLASH + 'resources' + DEF_SLASH + substr( US_FileNameOnlyName( GetMiniGuiName() ) , 4 ) + '.RC' )
//               US_FileCopy( US_ShortName(GetMiniGuiFolder()) + DEF_SLASH + 'resources' + DEF_SLASH + substr( US_FileNameOnlyName( GetMiniGuiName( DefineHarbour ) ) , 4 ) + '.RC' , US_ShortName(GetMiniGuiFolder()) + DEF_SLASH + 'resources' + DEF_SLASH + substr( US_FileNameOnlyName( GetMiniGuiName() ) , 4 ) + '.RC' )
//         endif
         if !bConvert .and. !bConsole .and. QPM_IsXHarbour() .and. ;
            !file( US_ShortName(GetMiniGuiFolder()) + DEF_SLASH + 'resources' + DEF_SLASH + cResourceFileName + '.RC' )
               US_FileCopy( US_ShortName(GetMiniGuiFolder()) + DEF_SLASH + 'resources' + DEF_SLASH + cResourceFileName + '.RC' , US_ShortName(GetMiniGuiFolder()) + DEF_SLASH + 'resources' + DEF_SLASH + cResourceFileName + '.RC' )
         endif

/*
 * Create BUILD.BAT
 */
// NOTE: added support for MINGW and Extended: the resource file in Extended with MinGW is named hmg.rc
         QPM_MemoWrit( PUB_cProjectFolder + DEF_SLASH + '_'+PUB_cSecu+'Build.Bat' , '@ECHO OFF' + Hb_OsNewLine() + ;
           if( !bConvert .and. !bConsole , 'if exist "' + US_FileNameOnlyPathAndName( PRGFILES[1] ) + '.RC" del "' + US_ShortName(PUB_cProjectFolder) + DEF_SLASH + '_Temp.rc" > NUL ' + Hb_OsNewLine() , '' ) + ;
           if( !bConvert .and. !bConsole , 'if exist "' + US_FileNameOnlyPathAndName( PRGFILES[1] ) + '.RC1.ERROR" del "' + US_FileNameOnlyPathAndName( PRGFILES[1] ) + '.RC1.ERROR" > NUL ' + Hb_OsNewLine() , '' ) + ;
           if( !bConvert .and. !bConsole , 'if exist "' + US_ShortName(OBJFOLDER)     + DEF_SLASH + US_FileNameOnlyName( PRGFILES[1] ) + '.RC2.ERROR" del ' + US_ShortName(OBJFOLDER) + DEF_SLASH + US_FileNameOnlyName( PRGFILES[1] ) + '.RC2.ERROR > NUL ' + Hb_OsNewLine() , '' ) + ;
           if( !bConvert .and. !bConsole , 'if exist "' + US_ShortName(OBJFOLDER)     + DEF_SLASH + cResourceFileName + '.RC4.ERROR" del ' + US_ShortName(OBJFOLDER) + DEF_SLASH + cResourceFileName + '.RC4.ERROR > NUL ' + Hb_OsNewLine() , '' ) + ;
           if( !bConvert .and. !bConsole , 'if not exist "' + US_ShortName(GetMiniGuiFolder()) + DEF_SLASH + 'resources' + DEF_SLASH + cResourceFileName + '.RC" ECHO US_Res from Batch Error: Resource File Not Found: ' + US_ShortName(GetMiniGuiFolder()) + DEF_SLASH + 'resources' + DEF_SLASH + cResourceFileName + '.RC > ' + US_ShortName(GetCppFolder()) + DEF_SLASH + 'BIN' + DEF_SLASH + '_'+PUB_cSecu+'Temp.Err' + Hb_OsNewLine() , '' ) + ;
           if( !bConvert .and. !bConsole , 'if exist "' + US_FileNameOnlyPathAndName( PRGFILES[1] ) + '.RC" ' + US_ShortName(PUB_cQPM_Folder) + DEF_SLASH + 'US_Res.exe QPM ' + if( bLogActivity , '-LIST' + US_ShortName(PUB_cQPM_Folder) , "" ) + ' -ONLYINCLUDE ' + US_ShortName( US_FileNameOnlyPathAndName( PRGFILES[1] ) + '.RC' ) + ' ' + US_ShortName( US_FileNameOnlyPathAndName( PRGFILES[1] ) + '.RC' ) + '1 ' + Hb_OsNewLine() , '' ) + ;
           if( !bConvert .and. !bConsole , 'if ERRORLEVEL = 1 GOTO ERROR' + Hb_OsNewLine() , '' ) + ;
           if( !bConvert .and. !bConsole , 'if exist "' + US_FileNameOnlyPathAndName( PRGFILES[1] ) + '.RC" ' + US_ShortName(PUB_cQPM_Folder) + DEF_SLASH + 'US_Res.exe QPM ' + if( bLogActivity , '-LIST' + US_ShortName(PUB_cQPM_Folder) , "" ) + ' ' + US_ShortName( US_FileNameOnlyPathAndName( PRGFILES[1] ) + '.RC' ) + '1 ' + ' ' + US_ShortName(OBJFOLDER)+DEF_SLASH+US_FileNameOnlyName( PRGFILES[1] ) + '.RC2 '+ Hb_OsNewLine() , '' ) + ;
           if( !bConvert .and. !bConsole , 'if ERRORLEVEL = 1 GOTO ERROR' + Hb_OsNewLine() , '' ) + ;
           if( !bConvert .and. !bConsole , 'if exist "' + US_FileNameOnlyPathAndName( PRGFILES[1] ) + '.RC" ' + US_ShortName(PUB_cQPM_Folder) + DEF_SLASH + 'US_Res.exe QPM ' + if( bLogActivity , '-LIST' + US_ShortName(PUB_cQPM_Folder) , "" ) + ' -FORCE ' + US_ShortName(GetMiniGuiFolder()) + DEF_SLASH + 'resources' + DEF_SLASH + cResourceFileName + '.RC ' + ' ' +US_ShortName(OBJFOLDER)+DEF_SLASH+cResourceFileName+'.RC4 '+Hb_OsNewLine() , '' ) + ;
           if( !bConvert .and. !bConsole , 'if ERRORLEVEL = 1 GOTO ERROR' + Hb_OsNewLine() , '' ) + ;
           if( !bConvert .and. !bConsole , 'if exist "' + US_FileNameOnlyPathAndName( PRGFILES[1] ) + '.RC" copy /b ' + US_ShortName(OBJFOLDER) + DEF_SLASH + US_FileNameOnlyName( PRGFILES[1] ) + '.RC2+' + US_ShortName(OBJFOLDER) + DEF_SLASH + cResourceFileName + '.RC4+' + US_ShortName(GetMiniGuiFolder()) + DEF_SLASH + 'resources' + DEF_SLASH + 'filler ' + US_ShortName(PUB_cProjectFolder)+DEF_SLASH + '_Temp.RC > NUL ' + Hb_OsNewLine() , '' ) + ;
           substr(US_ShortName(GetCppFolder()),1,2) + Hb_OsNewLine() + ;
           'CD' + substr(US_ShortName(GetCppFolder()),3) + DEF_SLASH + "BIN "+ Hb_OsNewLine() + ;
           if( bConvert , 'IF NOT EXIST ' + US_ShortName(GetCppFolder()) + DEF_SLASH + 'BIN'+DEF_SLASH+'US_DLLTOOL.EXE COPY ' + US_ShortName(PUB_cQPM_Folder) + DEF_SLASH + 'US_DllTool.exe' + Hb_OsNewLine() , '' ) + ;
           if( !bConvert , 'IF NOT EXIST ' + US_ShortName(GetCppFolder()) + DEF_SLASH + 'BIN'+DEF_SLASH+'US_WINDRES.EXE COPY ' + US_ShortName(PUB_cQPM_Folder) + DEF_SLASH + 'US_WindRes.exe' + Hb_OsNewLine() , '' ) + ;
           MakeName + ' ' + ParamString + Hb_OsNewLine() + ;
           if( bConvert , 'DEL US_DLLTOOL.EXE ' + Hb_OsNewLine() , '' ) + ;
           if( !bConvert , 'DEL US_WindRes.EXE ' + Hb_OsNewLine() , '' ) + ;
           QPM_ProjectOutputExistence() + ;
           ':ERROR' + Hb_OsNewLine() + ;
           if( !bConvert .and. !bConsole , 'if exist "' + US_FileNameOnlyPathAndName( PRGFILES[1] ) + '.RC1.ERROR" copy "' + US_FileNameOnlyPathAndName( PRGFILES[1] ) + '.RC1.ERROR" ' + US_ShortName(GetCppFolder()) + DEF_SLASH + 'BIN' + DEF_SLASH + '_'+PUB_cSecu+'Temp.Log' + Hb_OsNewLine() , '' ) + ;
           if( !bConvert .and. !bConsole , 'if exist "' + US_ShortName(OBJFOLDER)     + DEF_SLASH + US_FileNameOnlyName( PRGFILES[1] ) + '.RC2.ERROR" copy ' + US_ShortName(OBJFOLDER) + DEF_SLASH + US_FileNameOnlyName( PRGFILES[1] ) + '.RC2.ERROR ' + US_ShortName(GetCppFolder()) + DEF_SLASH + 'BIN' + DEF_SLASH + '_'+PUB_cSecu+'Temp.Log' + Hb_OsNewLine() , '' ) + ;
           if( !bConvert .and. !bConsole , 'if exist "' + US_ShortName(OBJFOLDER)     + DEF_SLASH + cResourceFileName + '.RC4.ERROR" copy ' + US_ShortName(OBJFOLDER) + DEF_SLASH + cResourceFileName + '.RC4.ERROR ' + US_ShortName(GetCppFolder()) + DEF_SLASH + 'BIN' + DEF_SLASH + '_'+PUB_cSecu+'Temp.Log' + Hb_OsNewLine() , '' ) + ;
           if( !bConvert .and. !bConsole , 'if exist "' + US_ShortName(GetCppFolder()) + DEF_SLASH + 'BIN' + DEF_SLASH + '_'+PUB_cSecu+'Temp.Err" copy ' + US_ShortName(GetCppFolder()) + DEF_SLASH + 'BIN' + DEF_SLASH + '_'+PUB_cSecu+'Temp.Err ' + US_ShortName(GetCppFolder()) + DEF_SLASH + 'BIN' + DEF_SLASH + '_'+PUB_cSecu+'Temp.Log' + Hb_OsNewLine() , '' ) + ;
           'Echo ERROR > ' + US_ShortName(PUB_cProjectFolder) + DEF_SLASH + '_'+PUB_cSecu+'End.Txt' + Hb_OsNewLine() + ;
           'GOTO END' + Hb_OsNewLine() + ;
           ':OK' + Hb_OsNewLine() + ;
           'Echo OK > ' + US_ShortName(PUB_cProjectFolder) + DEF_SLASH + '_'+PUB_cSecu+'End.Txt' + Hb_OsNewLine() + ;
           ':END' + Hb_OsNewLine() + ;
           if( !bConvert .and. !bConsole , 'if exist "' + US_FileNameOnlyPathAndName( PRGFILES[1] ) + '.RC" del "' + US_FileNameOnlyPathAndName( PRGFILES[1] ) + '.RC1" > NUL ' + Hb_OsNewLine() , '' ) + ;
           if( !bConvert .and. !bConsole , 'if exist "' + US_FileNameOnlyPathAndName( PRGFILES[1] ) + '.RC" del ' + US_ShortName(OBJFOLDER)     + DEF_SLASH + US_FileNameOnlyName( PRGFILES[1] ) + '.RC2 > NUL ' + Hb_OsNewLine() , '' ) + ;
           if( !bConvert .and. !bConsole , 'if exist "' + US_FileNameOnlyPathAndName( PRGFILES[1] ) + '.RC" del ' + US_ShortName(OBJFOLDER)     + DEF_SLASH + cResourceFileName + '.RC4 > NUL ' + Hb_OsNewLine() , '' ) + ;
           if( !bConvert .and. !bConsole , 'if exist "' + US_ShortName(GetCppFolder()) + DEF_SLASH + 'BIN' + DEF_SLASH + '_'+PUB_cSecu+'Temp.Err" del ' + US_ShortName(GetCppFolder()) + DEF_SLASH + 'BIN' + DEF_SLASH + '_'+PUB_cSecu+'Temp.Err > NUL ' + Hb_OsNewLine() , '' ) + ;
           if( !bConvert .and. !bConsole , 'if exist "' + US_FileNameOnlyPathAndName( PRGFILES[1] ) + '.RC1.ERROR" del "' + US_FileNameOnlyPathAndName( PRGFILES[1] ) + '.RC1.ERROR" > NUL ' + Hb_OsNewLine() , '' ) + ;
           if( !bConvert .and. !bConsole , 'if exist "' + US_ShortName(OBJFOLDER)     + DEF_SLASH + US_FileNameOnlyName( PRGFILES[1] ) + '.RC2.ERROR" del ' + US_ShortName(OBJFOLDER) + DEF_SLASH + US_FileNameOnlyName( PRGFILES[1] ) + '.RC2.ERROR > NUL ' + Hb_OsNewLine() , '' ) + ;
           if( !bConvert .and. !bConsole , 'if exist "' + US_ShortName(OBJFOLDER)     + DEF_SLASH + cResourceFileName + '.RC4.ERROR" del ' + US_ShortName(OBJFOLDER) + DEF_SLASH + cResourceFileName + '.RC4.ERROR > NUL ' + Hb_OsNewLine() , '' ) + ;
           "" )
      case ( IsBorland .or. IsPelles )
         QPM_MemoWrit( PUB_cProjectFolder + DEF_SLASH + '_'+PUB_cSecu+'Build.Bat' , '@ECHO OFF' + Hb_OsNewLine() + ;
           substr(US_ShortName(GetCppFolder()),1,2) + Hb_OsNewLine() + ;
           'CD' + substr(US_ShortName(GetCppFolder()),3) + DEF_SLASH + "BIN "+ Hb_OsNewLine() + ;
           MakeName + ' ' + ParamString + Hb_OsNewLine() + ;
           QPM_ProjectOutputExistence() + ;
           ':ERROR' + Hb_OsNewLine() + ;
           'Echo ERROR > ' + US_ShortName(PUB_cProjectFolder) + DEF_SLASH + '_'+PUB_cSecu+'End.Txt' + Hb_OsNewLine() + ;
           'GOTO END' + Hb_OsNewLine() + ;
           ':OK' + Hb_OsNewLine() + ;
           'Echo OK > ' + US_ShortName(PUB_cProjectFolder) + DEF_SLASH + '_'+PUB_cSecu+'End.Txt' + Hb_OsNewLine() + ;
           ':END' + Hb_OsNewLine() )
      otherwise
         US_Log( "Error in Compiler C type." )
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

   MemoAux := memoread( PUB_cProjectFolder + DEF_SLASH + '_'+PUB_cSecu+'Progress.Log' )
   QPM_MemoWrit( PUB_cProjectFolder + DEF_SLASH + '_'+PUB_cSecu+'Progress.Log' , MemoAux + US_TimeDis( Time() ) + " - Checking Force Recomp Modules..." + HB_OsNewLine() )
// For i:=1 to len( vForceRecomp )
//    MemoAux := memoread( PUB_cProjectFolder + DEF_SLASH + '_'+PUB_cSecu+'Progress.Log' )
//    QPM_MemoWrit( PUB_cProjectFolder + DEF_SLASH + '_'+PUB_cSecu+'Progress.Log' , MemoAux + US_TimeDis( Time() ) + " - Force Recomp by #define for " + vForceRecomp[i] + HB_OsNewLine() )
//    ferase( PUB_cProjectFolder + DEF_SLASH + GetObjName() + DEF_SLASH + US_FileNameOnlyName( vForceRecomp[i] ) + if( US_Upper( US_FileNameOnlyExt( vForceRecomp[i] ) ) == 'CPP' , ".CPP" , ".C" ) )
// Next i
   For i:=1 to GetProperty( "VentanaMain" , "GPRGFiles" , "itemcount" )
      if GetProperty( "VentanaMain" , "GPRGFiles" , "cell" , i , NCOLPRGRECOMP ) == "R"
         MemoAux := memoread( PUB_cProjectFolder + DEF_SLASH + '_'+PUB_cSecu+'Progress.Log' )
         QPM_MemoWrit( PUB_cProjectFolder + DEF_SLASH + '_'+PUB_cSecu+'Progress.Log' , MemoAux + US_TimeDis( Time() ) + " - Force Recomp by User for " + ChgPathToReal( GetProperty( "VentanaMain" , "GPRGFiles" , "cell" , i , NCOLPRGFULLNAME ) ) + HB_OsNewLine() )
         ferase( PUB_cProjectFolder + DEF_SLASH + GetObjName() + DEF_SLASH + US_FileNameOnlyName( GetProperty( "VentanaMain" , "GPRGFiles" , "cell" , i , NCOLPRGNAME ) ) + if( US_Upper( US_FileNameOnlyExt( GetProperty( "VentanaMain" , "GPRGFiles" , "cell" , i , NCOLPRGNAME ) ) ) == 'CPP' , ".CPP" , ".C" ) )
      endif
   Next i

   DO EVENTS

   if bLogActivity
      QPM_MemoWrit( US_ShortName( PUB_cProjectFolder + DEF_SLASH + '_'+PUB_cSecu+'Build.Bat' ) , "@ECHO Writing Log Activity..." + HB_OsNewLine() + MemoRead( US_ShortName( PUB_cProjectFolder + DEF_SLASH + '_'+PUB_cSecu+'Build.Bat' ) ) )
      QPM_Execute( US_ShortName( PUB_cProjectFolder + DEF_SLASH + '_'+PUB_cSecu+'Build.Bat' ) )
   else
      QPM_Execute( US_ShortName( PUB_cProjectFolder + DEF_SLASH + '_'+PUB_cSecu+'Build.Bat' ) , , DEF_QPM_EXEC_NOWAIT , DEF_QPM_EXEC_HIDE )
   endif
   
Return .T.

Function QPM_ProjectOutputExistence()

   Local w_val

   do case
   case cOutputCopyMove == "MOVE"
      w_val := 'IF EXIST ' + cOutputName + ' GOTO ERROR' + Hb_OsNewLine() + ;
               ( 'IF EXIST ' + ;
                 US_ShortName( Prj_Text_OutputCopyMoveFolder ) + DEF_SLASH + US_FileNameOnlyNameAndExt( cOutputName ) + ;
                 ' GOTO OK' + Hb_OsNewLine() )
   case cOutputCopyMove == "COPY"
      w_val := 'IF NOT EXIST ' + cOutputName + ' GOTO ERROR' + Hb_OsNewLine() + ;
               ( 'IF EXIST ' + ;
                 US_ShortName( Prj_Text_OutputCopyMoveFolder ) + DEF_SLASH + US_FileNameOnlyNameAndExt( cOutputName ) + ;
                 ' GOTO OK' + Hb_OsNewLine() )
   otherwise
      w_val := 'IF EXIST ' + cOutputName + ' GOTO OK' + Hb_OsNewLine()
   endcase

Return w_val

Function QPM_Run( bWithParm )
// QPM_Run2
   Local RUNFOLDER     := alltrim(US_FileNameOnlyPath(VentanaMain.TRunProjectFolder.Value))
   Local TopName       := US_FileNameOnlyName( GetOutputModuleName() )
   Local App
   Local cParm         := ""
   Local cRunParms     := ""
   Local cOldFolder    := GetCurrentFolder()
   Local oInput        := US_InputBox():New()

   if bWaitForBuild
      do while !bBuildFinished
         DO EVENTS
      enddo
   endif
   if Empty( PUB_cProjectFile )
      MsgStop('You must save project first !!!')
   EndIf
   If Empty( PUB_cProjectFolder ) .Or. Empty( TopName )
      Return .F.
   EndIf

   if Prj_Radio_OutputCopyMove == 3
      App := US_ShortName( Prj_Text_OutputCopyMoveFolder ) + DEF_SLASH + US_FileNameOnlyNameAndExt( GetOutputModuleName() )
   else
      App := GetOutputModuleName()
   endif
   
   If .Not. File( App )
      MsgStop ('Application "' + App + '" not found !!!' + HB_OsNewLine() + 'You Must (Re)Build Project Prior To Run It.' )
   Else
      if bWithParm
//us_log( "previo" )
         oInput:cTitulo := "Parameters for Run Program"
         oInput:ValorInicial := GBL_cRunParm
         oInput:cLeyenda :=  "Parm:"
         oInput:nPorAlto := if( PUB_bW800 , 30 , 20 )
         oInput:nPorAncho := 60
         oInput:bButtonOk := .T.
         oInput:bButtonCancel := .T.
         oInput:bEscape := .T.
         oInput:DefineWindow()
         cParm := oInput:Show()
//us_log( cParm )
//us_log( valtype( cParm  ))
//       cParm := InputBox( "Parm:" , "Parameters for Run Program" , GBL_cRunParm )
//us_log( "post" )
//us_log( empty( cParm ) )
// us_log( valtype(cParm ) )
         if !empty( cParm )
// US_LOG( "entro en no empty" )
            GBL_cRunParm := cParm
         else
            cParm := ""
         endif
      endif
      VentanaMain.GPrgFiles.SetFocus()
      If Empty( RUNFOLDER )
         RUNFOLDER:=PUB_cProjectFolder
         if PUB_bDebugActive
            if !file( PUB_cProjectFolder + DEF_SLASH + "Init.Cld" )
               MsgInfo( "Config File for debug is missing, Rebuild the project with Debug Option and retry again" )
               Return .F.
            Endif
         Endif
      else
         if PUB_bDebugActive
            if !file( RUNFOLDER + DEF_SLASH + "Init.Cld" )
               if file( PUB_cProjectFolder + DEF_SLASH + "Init.Cld" )
                  US_FileCopy( PUB_cProjectFolder + DEF_SLASH + "Init.Cld" , RUNFOLDER + DEF_SLASH + "Init.Cld" )
               else
                  MsgInfo( "Config File for debug is missing, Rebuild the project with Debug Option and retry again" )
                  Return .F.
               endif
            Endif
         Endif
      EndIf

      if !PUB_QPM_bHigh
         QPM_SetProcessPriority( "HIGH" )
         if file( ErrorLogName() )
            PUB_ErrorLogTime := val( DToS( US_FileDate( ErrorLogName() ) ) + US_StrCero( US_TimeSec( US_FileTime( ErrorLogName() ) ) , 5 ) )
         else
            PUB_ErrorLogTime := 0
         endif
      endif

      QPM_KillerModule := App

      SetCurrentFolder( RUNFOLDER )

      CloseDbfAutoView()
      if VentanaMain.GDbfFiles.Value > 0
         DefineRichEditForNotDbfView( "DBF view is disable while Running Application !!!" )
      endif
      cRunParms := US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + "_" + PUB_cSecu + "RUN" + US_DateTimeCen() + ".cng"
      aadd( RunControlFile , US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + "_" + PUB_cSecu + "RCF" + US_DateTimeCen() + ".cnt" )
      QPM_MemoWrit( cRunParms , "Run Parms for " + App + HB_OsNewLine() + ;
                           "COMMAND " + App + " " + cParm + HB_OsNewLine() + ;
                           "CONTROL " + RunControlFile[ len( RunControlFile ) ] )
      QPM_MemoWrit( RunControlFile[ len( RunControlFile ) ] , "Run Control File for " + App )
      QPM_Execute( US_ShortName( PUB_cQPM_Folder ) + DEF_SLASH + "US_Run.exe" , "QPM " + cRunParms )
      bRunApp := .T.
      VentanaMain.Check_DbfAutoView.Enabled := .F.

      SetCurrentFolder( cOldFolder )
   EndIf
Return .T.

Function QPM_Timer_Run()
   Local i:=0 , bLocalRun := .F.
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
            QPM_SetProcessPriority( "NORMAL" )
         endif
         VentanaMain.Check_DbfAutoView.Enabled := .T.
         QPM_Wait( "RichEditDisplay( 'DBF' , .T. )" , "Loading..." )
         if file( ErrorLogName() )
            if PUB_ErrorLogTime < val( DToS( US_FileDate( ErrorLogName() ) ) + US_StrCero( US_TimeSec( US_FileTime( ErrorLogName() ) ) , 5 ) )
            // us_log( "displayar errorlog" )
               VentanaMain.TabFiles.Value := nPageOut
               TabChange( "FILES" )
               MuestroErrorLog()
            endif
         endif
      endif
   endif
Return .T.

//Function TimerKill()
//   if bRunKill
//      if !file( cKillTaskControlFile )
//         bRunKill := .F.
//         VentanaMain.bKill.Enabled := .T.
//         DoMethod( "VentanaMain" , "restore" )
//      endif
//   endif
//Return .T.

Function QPM_Timer_StatusRefresh()
   Local memotmp , lenAux := 0
   Local CCOMPILERFOLDER := ""
   Local Venta := if( PUB_bLite , "VentanaLite" , "VentanaMain" )
   Local TopName := ""
   Local OutName := "" , estado:="ERROR"
   Local cBaseVerVer := Replicate( "0" , DEF_LEN_VER_VERSION )
   Local cBaseVerRel := Replicate( "0" , DEF_LEN_VER_RELEASE )
   Local cBaseVerBui := Replicate( "0" , DEF_LEN_VER_BUILD )
   Local cTopVerVer := Replicate( "9" , DEF_LEN_VER_VERSION )
   Local cTopVerRel := Replicate( "9" , DEF_LEN_VER_RELEASE )
   Local cTopVerBui := Replicate( "9" , DEF_LEN_VER_BUILD )
   If PUB_bIsProcessing
      If Empty( GetProperty( Venta , "LStatusLabel" , "value" ) )
         SetProperty( Venta , "LStatusLabel" , "value" , 'Building...' )
      Else
         SetProperty( Venta , "LStatusLabel" , "value" , '' )
      EndIf
      If File( PUB_cProjectFolder + DEF_SLASH + '_'+PUB_cSecu+'End.Txt' )
         PUB_bIsProcessing := .F.
         ferase( PUB_cProjectFolder + DEF_SLASH + "_" + PUB_cSecu + "MSG.SYSIN" ) /* por si estubiera activado el proceso de stop y la compilacion cancela por error */
         if PUB_bLite
            VentanaLite.bStop.Enabled := .F.
         else
            VentanaMain.bStop.Enabled := .F.
         endif
         VentanaMain.TabFiles.Value := nPageSysout
         TabChange( "FILES" )
         CCOMPILERFOLDER := US_ShortName( &( "Gbl_T_C_"+GetMiniGuiSuffix()+GetCppSuffix() ) ) + DEF_SLASH + "BIN"
         QPM_MemoWrit( CCOMPILERFOLDER + DEF_SLASH + '_'+PUB_cSecu+'Temp.Log' , TranslateLog( MemoRead( CCOMPILERFOLDER + DEF_SLASH + '_'+PUB_cSecu+'Temp.Log' ) ) )
         TopName       := US_FileNameOnlyName(GetProperty( "VentanaMain" , "GPrgFiles" , "Cell" , 1 , NCOLPRGNAME ))
         OutName       := US_FileNameOnlyName( GetOutputModuleName() )
         estado        := US_Word( memoread( PUB_cProjectFolder + DEF_SLASH + '_'+PUB_cSecu+'End.Txt' ) , 1 )

/*
La existencia del ejecutable se hace en BUILD.BAT teniendo en cuenta el COPY/MOVE
         if estado == "ERROR"
            if file( GetOutputModuleName()+'.MOVED.TXT' )
               estado := "OK"
            endif
         endif
*/

         /* ini Parche para cuando el EXE esta corriendo y queremos hacer build sin modificar ningun prg */
         if mlcount( GetProperty( Venta , "RichEditSysout" , "value" ) ) < 3 .and. ;
            US_Word( GetProperty( Venta , "RichEditSysout" , "value" ) , 1 ) == "MAKE"
            SetProperty( Venta , "RichEditSysout" , "value" , GetProperty( Venta , "RichEditSysout" , "value" ) + HB_OsNewLine() + "Fatal: Could not open " + GetOutputModuleName() + ", (program is still running?)" )
            estado := "ERROR"
         endif
         /* Fin Parche para cuando el EXE esta corriendo y queremos hacer build sin modificar ningun prg */

         if bAutoExit .and. ! empty( PUB_cAutoLog )
            if ( PUB_bLogOnlyError .and. estado == "ERROR" ) .or. ! PUB_bLogOnlyError
               PUB_cAutoLogTmp := MemoRead( PUB_cAutoLog )
               QPM_MemoWrit( PUB_cAutoLog , PUB_cAutoLogTmp + HB_OsNewLine() + GetProperty( Venta , "RichEditSysout" , "value" ) + HB_OsNewLine() + Replicate( "=" , 80 ) )
            else
               PUB_cAutoLogTmp := MemoRead( PUB_cAutoLog )
               QPM_MemoWrit( PUB_cAutoLog , PUB_cAutoLogTmp + HB_OsNewLine() + "OK" + HB_OsNewLine() + Replicate( "=" , 80 ) )
            endif
         endif

         SetProperty( Venta , "RichEditSysout" , "value" , MemoRead( CCOMPILERFOLDER + DEF_SLASH + '_'+PUB_cSecu+'Temp.Log' ) )
         SetProperty( Venta , "RichEditSysout" , "CaretPos" , PUB_nBottom )
         if bLogActivity
            memoTMP := memoread( PUB_cQPM_Folder+DEF_SLASH + "QPM.log" ) + HB_OSNewLine()
            memoTMP := memoTMP + '==> _'+PUB_cSecu+'Build.Bat' + HB_OSNewLine()
            memoTMP := memoTMP + memoread( PUB_cProjectFolder + DEF_SLASH + '_'+PUB_cSecu+'Build.Bat' ) + HB_OSNewLine()
            memoTMP := memoTMP + '==> _'+PUB_cSecu+'Temp.Log' + HB_OSNewLine()
            memoTMP := memoTMP + memoread( CCOMPILERFOLDER + DEF_SLASH + '_'+PUB_cSecu+'Temp.Log' ) + HB_OSNewLine()
            memoTMP := memoTMP + '==> _'+PUB_cSecu+'Temp.Bc' + HB_OSNewLine()
            memoTMP := memoTMP + memoread( PUB_cProjectFolder + DEF_SLASH + '_'+PUB_cSecu+'Temp.Bc' ) + HB_OSNewLine()
            memoTMP := memoTMP + '==> _'+PUB_cSecu+'Script.ld' + HB_OSNewLine()
            memoTMP := memoTMP + memoread( CCOMPILERFOLDER + DEF_SLASH + '_'+PUB_cSecu+'Script.ld' ) + HB_OSNewLine()
            memoTMP := memoTMP + replicate( "<" ,80 ) + HB_OSNewLine()
            memoTMP := memoTMP + replicate( "<" ,80 ) + HB_OSNewLine()
            QPM_MemoWrit( PUB_cQPM_Folder+DEF_SLASH + "QPM.log" , memoTMP )
         endif

         SetProperty( Venta , "LStatusLabel" , "value" , 'Status: Idle' )
         do case
            case estado == "OK"
               MsgOk( 'QPM (QAC Based Project Manager)' , 'Build Finished'+HB_OsNewLine()+'OK' , 'I' , if( bBuildRun .or. !empty( Prj_ExtraRunCmdFINAL ) , .T. , bAutoexit ) , if( bBuildRun , 2 , ) , if( !bBuildRun .and. empty( Prj_ExtraRunCmdFINAL ) .and. upper( OutputExt() ) == "EXE" , .T. , .F. ) )
            case estado == "WARNING"
               MsgOk( 'QPM (QAC Based Project Manager)' , 'Build Finished'+HB_OsNewLine()+'with Warnings' , 'W' , if( bBuildRun .or. !empty( Prj_ExtraRunCmdFINAL ) , .T. , bAutoexit ) , if( bBuildRun , 4 , ) , if( !bBuildRun .and. empty( Prj_ExtraRunCmdFINAL ) .and. upper( OutputExt() ) == "EXE" , .T. , .F. ) )
            case estado == "ERROR"
               MsgOk( 'QPM (QAC Based Project Manager)' , 'Build Finished'+HB_OsNewLine()+'WITH ERRORS' , 'E' , bAutoExit )
            otherwise
               MsgOK( 'QPM (QAC Based Project Manager)' , 'Invalid Return Code'+HB_OsNewLine()+'form Build Process: '+estado , 'E' )
         endcase
         RichEditDisplay( "OUT" )

         SetProperty( Venta , "LFull" , "FontColor" , DEF_COLORGREEN )
         SetProperty( Venta , "LFull" , "value" , "Incremental" )
         bBuildFinished := .T.
         SetProperty( "VentanaMain" , "EraseALL" , "enabled" , .T. )
         SetProperty( "VentanaMain" , "EraseOBJ" , "enabled" , .T. )
         SetProperty( "VentanaMain" , "open" , "enabled" , .T. )
         SetProperty( "VentanaMain" , "build" , "enabled" , .T. )
         SetProperty( "VentanaMain" , "BVerChange" , "enabled" , .T. )
         SetProperty( "VentanaMain" , "OverrideCompile" , "enabled" , .T. )
         SetProperty( "VentanaMain" , "OverrideLink" , "enabled" , .T. )
         if cOutputType == "SRCEXE"
            SetProperty( "VentanaMain" , "run" , "enabled" , .T. )
         endif

         DO EVENTS

         if estado == "OK" .and. ! empty( Prj_ExtraRunCmdFINAL )
            QPM_ExecuteExtraRun()
         endif
         // ini BUG ======================================================================================
         // No pone enable el boton build
         if !GetProperty( "VentanaMain" , "build" , "enabled" )
            SetProperty( "VentanaMain" , "build" , "enabled" , .F. )
            SetProperty( "VentanaMain" , "build" , "enabled" , .T. )
            US_Log( "Boton Build sigue disable" , .F. )
         endif
         // fin BUG ======================================================================================

         if PUB_DeleteAux
            DELETE FILE ( PUB_cProjectFolder + DEF_SLASH + OutName + '.TDS' )
            DELETE FILE ( PUB_cProjectFolder + DEF_SLASH + '_' + PUB_cSecu + 'Progress.Log' )
            DELETE FILE ( PUB_cProjectFolder + DEF_SLASH + TopName + '.RES' )
            DELETE FILE ( CCOMPILERFOLDER + DEF_SLASH + '_' + PUB_cSecu + 'Temp.Log' )
            DELETE FILE ( US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + '_' + PUB_cSecu + 'Temp.Log' )
            DELETE FILE ( SubStr( CCOMPILERFOLDER , 1 , 2 ) + DEF_SLASH + '_' + PUB_cSecu + 'Temp.Log' ) /* Lo genera REDIR pero no se porque */
            DELETE FILE ( PUB_cProjectFolder + DEF_SLASH + '_' + PUB_cSecu + 'Temp.Bc' )
            DELETE FILE ( PUB_cProjectFolder + DEF_SLASH + '_' + PUB_cSecu + 'End.Txt' )
            DELETE FILE ( CCOMPILERFOLDER + DEF_SLASH + TopName + '.MAP' )
            DELETE FILE ( CCOMPILERFOLDER + DEF_SLASH + '_' + PUB_cSecu + 'Script.ld' )
            DELETE FILE ( PUB_cProjectFolder + DEF_SLASH + '_' + PUB_cSecu + 'Build.Bat' )
            DELETE FILE ( PUB_cProjectFolder + DEF_SLASH + "_Temp.RC" )
            // los dos siguientes solo aparecen desde pendrive
            DELETE FILE ( PUB_cQPM_Folder + DEF_SLASH + TopName + '.MAP' )
            DELETE FILE ( PUB_cQPM_Folder + DEF_SLASH + '_' + PUB_cSecu + 'Script.ld' )
            // el siguiente solo aparece para PellesC y xHarbour
            DELETE FILE ( PUB_cProjectFolder + DEF_SLASH + OutName + '.exp' )
         endif

//       TabChange( "FILES" )   // esto es para que refresque los botones frizados durante el build

         if estado == "OK" .or. estado == "WARNING"
            if Val( GetProperty( "VentanaMain" , "LVerBuiNum" , "value" ) ) == val( cTopVerBui )
               SetProperty( "VentanaMain" , "LVerBuiNum" , "value" , cBaseVerBui )
               if Val( GetProperty( "VentanaMain" , "LVerRelNum" , "value" ) ) == val( cTopVerRel )
                  SetProperty( "VentanaMain" , "LVerRelNum" , "value" , cBaseVerRel )
                  if Val( GetProperty( "VentanaMain" , "LVerVerNum" , "value" ) ) == val( cTopVerVer )
                     SetProperty( "VentanaMain" , "LVerVerNum" , "value" , cBaseVerVer )
                     MyMsgWarning( "Warning, Version counter limit reached ("+cTopVerVer+"."+cTopVerRel+" build "+cTopVerBui+").  Counter reset to "+cBaseVerVer+"."+cBaseVerRel+" build "+cBaseVerBui )
                  else
                     SetProperty( "VentanaMain" , "LVerVerNum" , "value" , US_StrCero( Val( GetProperty( "VentanaMain" , "LVerVerNum" , "value" ) ) + 1 , DEF_LEN_VER_VERSION ) )
                     MyMsgWarning( "Warning, Release counter limit reached ("+cTopVerRel+").  Release counter reset to "+cBaseVerRel+" and Version counter has incremented one digit." )
                  endif
               else
                  SetProperty( "VentanaMain" , "LVerRelNum" , "value" , US_StrCero( Val( GetProperty( "VentanaMain" , "LVerRelNum" , "value" ) ) + 1 , DEF_LEN_VER_RELEASE ) )
                  MyMsgWarning( "Warning, Build counter limit reached ("+cTopVerBui+").  Build counter reset to "+cBaseVerBui+" and Release counter has incremented one digit." )
               endif
            else
               SetProperty( "VentanaMain" , "LVerBuiNum" , "value" , US_StrCero( Val( GetProperty( "VentanaMain" , "LVerBuiNum" , "value" ) ) + 1 , DEF_LEN_VER_BUILD ) )
            endif
         endif

         if ( bBuildRun .or. PUB_bForceRunFromMsgOk ) .and. ( estado == "OK" .or. estado == "WARNING" )
            QPM_Run( bRunParm )
         endif

         BUILD_IN_PROGRESS := .F.
         DefinoWindowsHotKeys( .F. )
      else
         lenAux := US_FileSize( PUB_cProjectFolder + DEF_SLASH + '_'+PUB_cSecu+'Progress.Log' )
         if lenAux > ProgLength
            ProgLength := lenAux
            SetProperty( Venta , "RichEditSysout" , "value" , MemoRead( PUB_cProjectFolder + DEF_SLASH + '_'+PUB_cSecu+'Progress.Log' ) )
            SetProperty( Venta , "RichEditSysout" , "CaretPos" , PUB_nBottom )
         endif
      EndIf
   EndIf
Return .T.

Function QPM_CopyFile( orig, dest )

   local bError, oSaveHandler, oError

   if file( orig )
      if file( dest )
         DELETE FILE ( dest )

         if file ( dest )
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
   Local pos , dire , i , bBorrar := .T.
   Local item := VentanaMain.GPrgFiles.Value
   Local bTop := if( item == 1 , .T. , .F. )
   If VentanaMain.GPrgFiles.Value > 0
      If MyMsgYesNo('Remove File ' + ChgPathToReal( GetProperty( "VentanaMain" , "GPrgFiles" , "Cell" , VentanaMain.GPrgFiles.Value , NCOLPRGFULLNAME ) ) + ' From Project ?','Confirm')
      // QPM_ForceRecompExclude( ChgPathToReal( GetProperty( "VentanaMain" , "GPrgFiles" , "Cell" , VentanaMain.GPrgFiles.Value , NCOLPRGFULLNAME ) ) , VentanaMain.GPrgFiles.Value )
         dire := US_FileNameOnlyPath( GetProperty( "VentanaMain" , "GPrgFiles" , "Cell" , VentanaMain.GPrgFiles.Value , NCOLPRGFULLNAME ) )
         VentanaMain.GPrgFiles.DeleteItem( VentanaMain.GPrgFiles.Value )
         SetProperty( "VentanaMain" , "GPrgFiles" , "tooltip" , "" )
         if item > VentanaMain.GPrgFiles.ItemCount
            item := VentanaMain.GPrgFiles.ItemCount
         endif
         if GridImage( "VentanaMain" , "GPrgFiles" , item , NCOLPRGSTATUS , "?" , PUB_nGridImgSearchOk )
            TotCaption( "PRG" , -1 )
         endif
         SetProperty( "VentanaMain" , "GPrgFiles" , "value" , item )
         RichEditDisplay( "PRG" )
      // Pos := ascan( vExtraFoldersForSearch , ChgPathToReal( dire ) )
         Pos := AScan( vExtraFoldersForSearch , { |y| upper( US_VarToStr( y ) ) == upper( ChgPathToReal( dire ) ) } )
         For i=1 to VentanaMain.GPrgFiles.ItemCount
            if dire == US_FileNameOnlyPath( GetProperty( "VentanaMain" , "GPrgFiles" , "Cell" , i , NCOLPRGFULLNAME ) )
               bBorrar := .F.
            endif
         next
         For i=1 to VentanaMain.GPanFiles.ItemCount
            if dire == US_FileNameOnlyPath( GetProperty( "VentanaMain" , "GPanFiles" , "Cell" , i , NCOLPANFULLNAME ) )
               bBorrar := .F.
            endif
         next
         For i=1 to VentanaMain.GDbfFiles.ItemCount
            if dire == US_FileNameOnlyPath( GetProperty( "VentanaMain" , "GDbfFiles" , "Cell" , i , NCOLDBFFULLNAME ) )
               bBorrar := .F.
            endif
         next
         For i=1 to VentanaMain.GHeaFiles.ItemCount
            if dire == US_FileNameOnlyPath( GetProperty( "VentanaMain" , "GHeaFiles" , "Cell" , i , NCOLHEAFULLNAME ) )
               bBorrar := .F.
            endif
         next
         if Pos > 0 .and. bBorrar
            adel( vExtraFoldersForSearch , Pos )
         endif
         if bTop
            CambioTitulo()
            if GetProperty( "VentanaMain" , "GPrgFiles" , "itemcount" ) > 0
               MsgInfo( ChgPathToReal( GetProperty( "VentanaMain" , "GPrgFiles" , "Cell" , 1 , NCOLPRGFULLNAME ) ) + ' Is The New Project Top File.' )
            else
               MsgInfo( 'Empty Project Top File !!!' )
            endif
         endif
      EndIf
   EndIf
   DoMethod( "VentanaMain" , "GPrgFiles" , "ColumnsAutoFitH" )
Return .T.

Function QPM_RemoveFileHEA()
   Local pos , dire , i , bBorrar := .T.
   Local item := VentanaMain.GHeaFiles.Value
   If VentanaMain.GHeaFiles.Value > 0
      If MyMsgYesNo('Remove File ' + ChgPathToReal( GetProperty( "VentanaMain" , "GHeaFiles" , "Cell" , VentanaMain.GHeaFiles.Value , NCOLHEAFULLNAME ) ) + ' From Project ?','Confirm')
         dire := US_FileNameOnlyPath( GetProperty( "VentanaMain" , "GHeaFiles" , "Cell" , VentanaMain.GHeaFiles.Value , NCOLHEAFULLNAME ) )
         VentanaMain.GHeaFiles.DeleteItem( VentanaMain.GHeaFiles.Value )
         SetProperty( "VentanaMain" , "GHeaFiles" , "tooltip" , "" )
         if item > VentanaMain.GHeaFiles.ItemCount
            item := VentanaMain.GHeaFiles.ItemCount
         endif
         if GridImage( "VentanaMain" , "GHeaFiles" , item , NCOLHEASTATUS , "?" , PUB_nGridImgSearchOk )
            TotCaption( "HEA" , -1 )
         endif
         SetProperty( "VentanaMain" , "GHeaFiles" , "value" , item )
         RichEditDisplay( "HEA" )
      // Pos := ascan( vExtraFoldersForSearch , ChgPathToReal( dire ) )
         Pos := AScan( vExtraFoldersForSearch , { |y| upper( US_VarToStr( y ) ) == upper( ChgPathToReal( dire ) ) } )
         For i=1 to VentanaMain.GPrgFiles.ItemCount
            if dire == US_FileNameOnlyPath( GetProperty( "VentanaMain" , "GPrgFiles" , "Cell" , i , NCOLPRGFULLNAME ) )
               bBorrar := .F.
            endif
         next
         For i=1 to VentanaMain.GPanFiles.ItemCount
            if dire == US_FileNameOnlyPath( GetProperty( "VentanaMain" , "GPanFiles" , "Cell" , i , NCOLPANFULLNAME ) )
               bBorrar := .F.
            endif
         next
         For i=1 to VentanaMain.GDbfFiles.ItemCount
            if dire == US_FileNameOnlyPath( GetProperty( "VentanaMain" , "GDbfFiles" , "Cell" , i , NCOLDBFFULLNAME ) )
               bBorrar := .F.
            endif
         next
         For i=1 to VentanaMain.GHeaFiles.ItemCount
            if dire == US_FileNameOnlyPath( GetProperty( "VentanaMain" , "GHeaFiles" , "Cell" , i , NCOLHEAFULLNAME ) )
               bBorrar := .F.
            endif
         next
         if Pos > 0 .and. bBorrar
            adel( vExtraFoldersForSearch , Pos )
         endif
      EndIf
   EndIf
   DoMethod( "VentanaMain" , "GHeaFiles" , "ColumnsAutoFitH" )
Return .T.

Function QPM_RemoveFilePAN()
   Local pos , dire , i , bBorrar := .T.
   Local item := VentanaMain.GPanFiles.Value
   If VentanaMain.GPanFiles.Value > 0
      If MyMsgYesNo('Remove File ' + ChgPathToReal( GetProperty( "VentanaMain" , "GPanFiles" , "Cell" , VentanaMain.GPanFiles.Value , NCOLPANFULLNAME ) ) + ' From Project ?','Confirm')
         dire := US_FileNameOnlyPath( GetProperty( "VentanaMain" , "GPanFiles" , "Cell" , VentanaMain.GPanFiles.Value , NCOLPANFULLNAME ) )
         VentanaMain.GPanFiles.DeleteItem( VentanaMain.GPanFiles.Value )
         SetProperty( "VentanaMain" , "GPanFiles" , "tooltip" , "" )
         if item > VentanaMain.GPanFiles.ItemCount
            item := VentanaMain.GPanFiles.ItemCount
         endif
         if GridImage( "VentanaMain" , "GPanFiles" , item , NCOLPANSTATUS , "?" , PUB_nGridImgSearchOk )
            TotCaption( "PAN" , -1 )
         endif
         SetProperty( "VentanaMain" , "GPanFiles" , "value" , item )
         RichEditDisplay( "PAN" )
      // Pos := ascan( vExtraFoldersForSearch , ChgPathToReal( dire ) )
         Pos := AScan( vExtraFoldersForSearch , { |y| upper( US_VarToStr( y ) ) == upper( ChgPathToReal( dire ) ) } )
         For i=1 to VentanaMain.GPrgFiles.ItemCount
            if dire == US_FileNameOnlyPath( GetProperty( "VentanaMain" , "GPrgFiles" , "Cell" , i , NCOLPRGFULLNAME ) )
               bBorrar := .F.
            endif
         next
         For i=1 to VentanaMain.GPanFiles.ItemCount
            if dire == US_FileNameOnlyPath( GetProperty( "VentanaMain" , "GPanFiles" , "Cell" , i , NCOLPANFULLNAME ) )
               bBorrar := .F.
            endif
         next
         For i=1 to VentanaMain.GHeaFiles.ItemCount
            if dire == US_FileNameOnlyPath( GetProperty( "VentanaMain" , "GHeaFiles" , "Cell" , i , NCOLHEAFULLNAME ) )
               bBorrar := .F.
            endif
         next
         if Pos > 0 .and. bBorrar
            adel( vExtraFoldersForSearch , Pos )
         endif
      EndIf
   EndIf
   DoMethod( "VentanaMain" , "GPanFiles" , "ColumnsAutoFitH" )
Return .T.

Function QPM_RemoveFileDBF()
   //Local pos , dire , i , bBorrar := .T.
   Local item := VentanaMain.GDbfFiles.Value
   If VentanaMain.GDbfFiles.Value > 0
      If MyMsgYesNo('Remove File ' + ChgPathToReal( GetProperty( "VentanaMain" , "GDbfFiles" , "Cell" , VentanaMain.GDbfFiles.Value , NCOLDBFFULLNAME ) ) + ' From Project ?','Confirm')
      // dire := US_FileNameOnlyPath( GetProperty( "VentanaMain" , "GDbfFiles" , "Cell" , VentanaMain.GDbfFiles.Value , NCOLDBFFULLNAME ) )
         VentanaMain.GDbfFiles.DeleteItem( VentanaMain.GDbfFiles.Value )
         SetProperty( "VentanaMain" , "GDbfFiles" , "tooltip" , "" )
         if item > VentanaMain.GDbfFiles.ItemCount
            item := VentanaMain.GDbfFiles.ItemCount
         endif
         if GridImage( "VentanaMain" , "GDbfFiles" , item , NCOLDBFSTATUS , "?" , PUB_nGridImgSearchOk )
            TotCaption( "DBF" , -1 )
         endif
         SetProperty( "VentanaMain" , "GDbfFiles" , "value" , item )
         if item = 0
            CloseDbfAutoView()
            VentanaMain.RichEditDbf.Value := ""
         else
            RichEditDisplay( "DBF" )
         endif
      EndIf
   EndIf
   DoMethod( "VentanaMain" , "GDbfFiles" , "ColumnsAutoFitH" )
Return .T.

Function QPM_RemoveFileLIB()
   Local pos , dire , i , bBorrar := .T.
   Local item := VentanaMain.GIncFiles.Value
   If VentanaMain.GIncFiles.Value > 0
      If MyMsgYesNo('Remove File ' + ChgPathToReal( US_WordSubStr( GetProperty( "VentanaMain" , "GIncFiles" , "Cell" , VentanaMain.GIncFiles.Value , NCOLINCFULLNAME ) , 3 ) ) + ' From Project ?','Confirm')
         dire := upper( US_FileNameOnlyPath( ChgPathToReal( US_WordSubStr( GetProperty( "VentanaMain" , "GIncFiles" , "Cell" , VentanaMain.GIncFiles.Value , NCOLINCFULLNAME ) , 3 ) ) ) )
         VentanaMain.GIncFiles.DeleteItem( VentanaMain.GIncFiles.Value )
         if item > VentanaMain.GIncFiles.ItemCount
            item := VentanaMain.GIncFiles.ItemCount
         endif
         if GridImage( "VentanaMain" , "GIncFiles" , item , NCOLINCSTATUS , "?" , PUB_nGridImgSearchOk )
            TotCaption( "LIB" , -1 )
         endif
         SetProperty( "VentanaMain" , "GIncFiles" , "value" , item )
         RichEditDisplay( "INC" )
         Pos := ascan( &("vExtraFoldersForLibs"+GetSuffix()) , dire )
         For i=1 to VentanaMain.GIncFiles.ItemCount
            if dire == upper( US_FileNameOnlyPath( ChgPathToReal( US_WordSubStr( GetProperty( "VentanaMain" , "GIncFiles" , "Cell" , i , NCOLINCFULLNAME ) , 3 ) ) ) )
               bBorrar := .F.
            endif
         next
         if Pos > 0 .and. bBorrar
            adel( &("vExtraFoldersForLibs"+GetSuffix()) , Pos )
         endif
      EndIf
   EndIf
   DoMethod( "VentanaMain" , "GIncFiles" , "ColumnsAutoFitH" )
Return .T.

Function QPM_RemoveExcludeFileLIB()
   Local pos , dire , i , bBorrar := .T.
   Local item := VentanaMain.GExcFiles.Value
   If VentanaMain.GExcFiles.Value > 0
      If MyMsgYesNo('Remove File ' + GetProperty( "VentanaMain" , "GExcFiles" , "Cell" , VentanaMain.GExcFiles.Value , NCOLEXCNAME ) + ' From Exclude List ?','Confirm')
         VentanaMain.GExcFiles.DeleteItem( VentanaMain.GExcFiles.Value )
         if item > VentanaMain.GExcFiles.ItemCount
            item := VentanaMain.GExcFiles.ItemCount
         endif
         SetProperty( "VentanaMain" , "GExcFiles" , "value" , item )
         //RichEditDisplay( "EXC" )
      EndIf
   EndIf
   DoMethod( "VentanaMain" , "GExcFiles" , "ColumnsAutoFitH" )
Return .T.

#ifdef QPM_SHG
Function QPM_RemoveFileHLP()
   Local pos , dire , i , bBorrar := .T. , nAuxRecord
   Local item := VentanaMain.GHlpFiles.Value
   If VentanaMain.GHlpFiles.Value > 2
      If MyMsgYesNo('Remove Toppic ' + alltrim( GetProperty( "VentanaMain" , "GHlpFiles" , "Cell" , VentanaMain.GHlpFiles.Value , NCOLHLPTOPIC ) ) + ' From Help ?','Confirm')
         bHlpMoving := .T.
         nAuxRecord := VentanaMain.GHlpFiles.Value
         VentanaMain.GHlpFiles.DeleteItem( VentanaMain.GHlpFiles.Value )
         SetProperty( "VentanaMain" , "GHlpFiles" , "tooltip" , "" )
         if item > VentanaMain.GHlpFiles.ItemCount
            item := VentanaMain.GHlpFiles.ItemCount
         endif
         if GridImage( "VentanaMain" , "GHlpFiles" , item , NCOLHLPSTATUS , "?" , PUB_nGridImgSearchOk )
            TotCaption( "HLP" , -1 )
         endif
         SetProperty( "VentanaMain" , "GHlpFiles" , "value" , item )
         SHG_DeleteRecord( nAuxRecord )
      // SHG_NewSecuence()
         RichEditDisplay( "HLP" )
         bHlpMoving := .F.
      EndIf
   else
      if VentanaMain.GHlpFiles.Value == 1
         MsgInfo( "Global foot can't be edited, it's a system Topic !!!" )
         Return .F.
      endif
      if VentanaMain.GHlpFiles.Value == 2
         MsgInfo( "Welcome page can't be deleted, it's a system Topic !!!" )
         Return .F.
      endif
   EndIf
   DoMethod( "VentanaMain" , "GHlpFiles" , "ColumnsAutoFitH" )
Return .T.
#endif

#ifdef QPM_SHG
Function QPM_RemoveKeyHLP()
   Local item := VentanaMain.GHlpKeys.Value , MemoAux := "" , i
   If VentanaMain.GHlpKeys.Value > 0
         VentanaMain.GHlpKeys.DeleteItem( VentanaMain.GHlpKeys.Value )
         if item > VentanaMain.GHlpKeys.ItemCount
            item := VentanaMain.GHlpKeys.ItemCount
         endif
         SetProperty( "VentanaMain" , "GHlpKeys" , "value" , item )
         For i:=1 to VentanaMain.GHlpKeys.ItemCount
            MemoAux := MemoAux + if( i > 1 , HB_OsNewLine() , "" ) + VentanaMain.GHlpKeys.Cell( i , 1 )
         Next
         SHG_SetField( "SHG_KEYST" , VentanaMain.GHlpFiles.Value , MemoAux )
   EndIf
   DoMethod( "VentanaMain" , "GHlpKeys" , "ColumnsAutoFitH" )
Return .T.
#endif

Function LibInfo()
   Local a , b , c
   If VentanaMain.GIncFiles.Value > 0
      a:='Library name: ' + US_FileNameOnlyNameAndExt( ChgPathToReal( US_WordSubStr( GetProperty( "VentanaMain" , "GIncFiles" , "Cell" , VentanaMain.GIncFiles.Value , NCOLINCFULLNAME ) , 3 ) ) )
      b:='   in Folder: ' + US_FileNameOnlyPath( ChgPathToReal( US_WordSubStr( GetProperty( "VentanaMain" , "GIncFiles" , "Cell" , VentanaMain.GIncFiles.Value , NCOLINCFULLNAME ) , 3 ) ) )
      c:='Concatenated ' + if( US_Upper( us_word( GetProperty( "VentanaMain" , "GIncFiles" , "Cell" , VentanaMain.GIncFiles.Value , NCOLINCFULLNAME ) , 2 ) ) == "*FIRST*" , "BEFORE MiniGui library" , "AFTER last significant library" )
      MsgInfo( a + HB_OsNewLine() + ;
               b + HB_OsNewLine() + ;
               ' ' + HB_OsNewLine() + ;
               c + HB_OsNewLine() + ;
               'Status: ' + LibCheck( VentanaMain.GIncFiles.Value ) )
   endif
Return .T.

Function LibExcludeInfo()
   Local a , c
   If VentanaMain.GExcFiles.Value > 0
      a:='Library name: ' + GetProperty( "VentanaMain" , "GExcFiles" , "Cell" , VentanaMain.GExcFiles.Value , NCOLEXCNAME )
      c:='Will be EXCLUDE of Library Concatenated'
      MsgInfo( a + HB_OsNewLine() + ;
               ' ' + HB_OsNewLine() + ;
               c )
   endif
Return .T.

Function LibCheck( item )
   local estado
   if file( ChgPathToReal( us_wordsubstr( GetProperty( "VentanaMain" , "GIncFiles" , "Cell" , item , NCOLINCFULLNAME ) , 3 ) ) )
      estado:="Ok"
      SetProperty( "VentanaMain" , "GIncFiles" , "Cell" , item , NCOLINCSTATUS , PUB_nGridImgNone )
   else
      estado:="NotFound!!!"
   // GetProperty( "VentanaMain" , "GIncFiles" , "Cell" , item , NCOLINCSTATUS ) := PUB_nGridImgEquis
      GridImage( "VentanaMain" , "GIncFiles" , item , NCOLINCSTATUS , "+" , PUB_nGridImgEquis )
   endif
   SetProperty( "VentanaMain" , "GIncFiles" , "Cell" , item , NCOLINCFULLNAME , estado + " " + us_wordSubStr( GetProperty( "VentanaMain" , "GIncFiles" , "Cell" , item , NCOLINCFULLNAME ) , 2 ) )
Return estado

Function LibPos( item , pos )
   If item > 0
      if empty( pos )
         pos := us_word( GetProperty( "VentanaMain" , "GIncFiles" , "Cell" , item , NCOLINCFULLNAME ) , 2 )
      endif
      SetProperty( "VentanaMain" , "GIncFiles" , "Cell" , item , NCOLINCFULLNAME , LibCheck( item ) + " " + Pos + " " + US_WordSubStr( GetProperty( "VentanaMain" , "GIncFiles" , "Cell" , item , NCOLINCFULLNAME ) , 3 ) )
   endif
   VentanaMain.GIncFiles.setfocus
Return .t.

Function DefinoWindowsHotKeys( w_foco )
   LiberoWindowsHotKeys( w_foco )
   If w_foco
     MAIN_HAS_FOCUS := .T.
   EndIf
   If MAIN_HAS_FOCUS
     ON KEY F1 OF VentanaMain ACTION US_DisplayHelpTopic( GetActiveHelpFile() , 1 )
     ON KEY F2 OF VentanaMain ACTION QPM_OpenProject()
     ON KEY F3 OF VentanaMain ACTION QPM_SaveProject()
     ON KEY F4 OF VentanaMain ACTION QPM_Build()
     If ! BUILD_IN_PROGRESS .and. cOutputType == "SRCEXE"
        ON KEY F5 OF VentanaMain ACTION QPM_Run( bRunParm )
     EndIf
     ON KEY F10 OF VentanaMain ACTION QPM_Exit()
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

Function TranslateLog(Log)
   Local NewLog       := '' , i
   Local msg          := PUB_cCharTab + US_ShortName(PUB_cQPM_Folder) + DEF_SLASH + 'US_MSG.EXE ' + US_ShortName(PUB_cProjectFolder) + DEF_SLASH + '_'+PUB_cSecu+'Progress.Log -MSG:'
   Local slash        := US_ShortName(PUB_cQPM_Folder) + DEF_SLASH + 'US_SLASH.EXE QPM'
   Local shellCZ      := US_ShortName(PUB_cQPM_Folder) + DEF_SLASH + 'US_SHELL.EXE QPM COPYZAP '
   Local shellMZ      := US_ShortName(PUB_cQPM_Folder) + DEF_SLASH + 'US_SHELL.EXE QPM MOVEZAP '
   Local shell        := US_ShortName(PUB_cQPM_Folder) + DEF_SLASH + 'US_SHELL.EXE QPM '
   Local implib       := US_ShortName(PUB_cQPM_Folder) + DEF_SLASH + 'US_IMPLIB.EXE'
   Local implibPelles := US_ShortName(PUB_cQPM_Folder) + DEF_SLASH + 'US_POLIB.EXE'
   Local impdef       := US_ShortName(PUB_cQPM_Folder) + DEF_SLASH + 'US_IMPDEF.EXE'
   Local PExports     := US_ShortName(PUB_cQPM_Folder) + DEF_SLASH + 'US_PEXPORTS.EXE'
   Local ImpLibBor    := HB_OsNewLine()+"Borland Implib Version 3.0.22 Copyright (c) 1991, 2000 Inprise Corporation"+HB_OsNewLine()
   Local ImpDefBor    := HB_OsNewLine()+"Borland Impdef Version 3.0.22 Copyright (c) 1991, 2000 Inprise Corporation"+HB_OsNewLine()
   Local reimp        := US_ShortName(PUB_cQPM_Folder) + DEF_SLASH + 'US_REIMP.EXE'
   Local gcc          := US_ShortName( &('Gbl_T_C_'+GetMiniGuiSuffix()+GetCppSuffix()) ) + DEF_SLASH + 'BIN'+DEF_SLASH+'GCC.EXE'
   Local dlltool      := US_ShortName( &('Gbl_T_C_'+GetMiniGuiSuffix()+GetCppSuffix()) ) + DEF_SLASH + 'BIN'+DEF_SLASH+'US_DLLTOOL.EXE'
   Local myredir      := US_ShortName(PUB_cQPM_Folder) + DEF_SLASH + 'US_REDIR.EXE' + PUB_cUS_RedirOpt + US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + '_'+PUB_cSecu+'Temp.Log '
   Local QPM_Ver      := '/D__QPM_VERSION__="'+"'"+PUB_cQPM_Version2+"'"+'"'
   Local PRJ_Ver      := '/D__PRJ_VERSION__="'+"'"+cPrj_Version+"'"+'"'
   Local PRJ_Folder   := '/D__PROJECT_FOLDER__="'+"'"+VentanaMain.TProjectFolder.Value+"'"+'"'
   Local cEcho2       := '>> _'+PUB_cSecu+'Script.ld'
   Local cEcho        := '> _'+PUB_cSecu+'Script.ld'
   Local cDelete      := '** error 1 ** '
                          /* Texto ,  Position ( 0=Cualquiera ) , Producto */
   Local vWarnings := { { ") Warning W"                                , 0 , DefineXHarbour } , ; // Warning en Compilaciones
                        { "Warning W"                                  , 1 , "CBORLAND" } , ;     // Warning en funcion C
                        { ": warning: "                                , 0 , "CMINGW" }   , ;     // Warning en funcion C
                        { ": No such file or directory"                , 0 , "RMINGW" }   , ;     // Warning en Resource Compiler (include notFound)
                        { "Duplicate resource:"                        , 1 , "RBORLAND" }   , ;   // Warning en Resource Compiler
                        { "warning: "                                  , 1 , "LNKBORLAND" } , ;   // Warning en Linkeditor de Borland (No recuerdo si aparecia en minuscula por eso lo agrego
                        { "Warning: "                                  , 1 , "LNKBORLAND" } , ;   // Warning en Linkeditor o TLIB de Borland
                        { "POLIB: warning: "                           , 1 , "LIBPELLES" } , ;    // Warning en creacion de libreria Pelles C
                        { "POLINK: warning: "                          , 1 , "LNKPELLES" } ;      // Warning en Linkeditor de Pelles C
                      } , w:=0
   Local vErrors   := { { "** error 1 **"                              , 1 , "LNKMINGW" } , ;     // Error en linkedicion MinGW
                        { "** error 2 **"                              , 1 , "LNKBORLAND" } , ;   // Error en Linkeditor de Borland
                        { "Error: Unresolved external"                 , 1 , "LNKBORLAND" } , ;   // Error en Linkeditor de Borland
                        { "Fatal: Access violation.  Link terminated." , 1 , "LNKBORLAND" } , ;   // Error en Linkeditor de Borland
                        { "Fatal: Could not open"                      , 1 , "LNKBORLAND" } , ;   // Error en Linkeditor de Borland
                        { "POLIB: error: "                             , 1 , "LIBPELLES" } , ;    // Error en Libreria de Pelles C
                        { "POLINK: error: "                            , 1 , "LNKPELLES" } , ;    // Error en Linkeditor de Pelles C
                        { "POLINK: fatal error: "                      , 1 , "LNKPELLES" } , ;    // Error en Linkeditor de Pelles C
                        { "Packed 0 files."                            , 1 , "UPX" } , ;          // Error en UPX
                        { "Packed 1 file: 0 ok, 1 error."              , 1 , "UPX" } ;            // Error en UPX
                      } , e:=0
   VentanaMain.RichEditSysout.Value := VentanaMain.RichEditSysout.Value + HB_OsNewLine() + US_TimeDis( Time() ) + " - >>>>>>> Reading Output Process ..."
   VentanaMain.RichEditSysout.SetFocus()
   VentanaMain.RichEditSysout.CaretPos:=len(VentanaMain.RichEditSysout.Value)
   NewLog := StrTran( Log , chr(13)+chr(13) , HB_OsNewLine() )
   if bLogActivity
      NewLog := StrTran( NewLog , myredir , "Sysout MinGW Family to " + US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + '_'+PUB_cSecu+'Temp.Log' + HB_OsNewLine() )
   else
      NewLog := StrTran( NewLog , myredir , "" )
   endif
   NewLog := StrTran( NewLog , msg , HB_OsNewLine() + "==> " )
   NewLog := StrTran( NewLog , slash , gcc )
   NewLog := StrTran( NewLog , shellCZ, "COPY -z" )
   NewLog := StrTran( NewLog , shellMZ, "MOVE -z" )
   NewLog := StrTran( NewLog , shell , "" )
   NewLog := StrTran( NewLog , implib , "GENERATE 'LIB'" )
   NewLog := StrTran( NewLog , implibPelles , "GENERATE 'LIB'" )
   NewLog := StrTran( NewLog , impdef , "LIST 'DLL'" )
   NewLog := StrTran( NewLog , reimp , "ReIMPORT " )
   NewLog := StrTran( NewLog , dlltool, "GENERATE 'A'" )
   NewLog := StrTran( NewLog , PExports , "LIST 'DLL'" )
   NewLog := StrTran( NewLog , cEcho2, "" )
   NewLog := StrTran( NewLog , cEcho, "" )
   NewLog := StrTran( NewLog , ImpLibBor, "" )
   NewLog := StrTran( NewLog , ImpDefBor, "" )
   NewLog := StrTran( NewLog , "_Temp.RC:" , US_FileNameOnlyName( GetProperty( "VentanaMain" , "GPrgFiles" , "Cell" , 1 , NCOLPRGFULLNAME ) ) + '.RC:' )
   NewLog := StrTran( NewLog , QPM_Ver , "" )
   NewLog := StrTran( NewLog , PRJ_Ver , "" )
   NewLog := StrTran( NewLog , PRJ_Folder , "" )
   NewLog := StrTran( NewLog , cDelete , "" )
   if US_Word( memoread( PUB_cProjectFolder + DEF_SLASH + '_'+PUB_cSecu+'End.Txt' ) , 1 ) == "OK"
      For w:=1 to len( vWarnings )
         if at( vWarnings[w][1] , NewLog ) > 0
            QPM_MemoWrit( PUB_cProjectFolder + DEF_SLASH + '_'+PUB_cSecu+'End.Txt' , "WARNING" )
            EXIT
         endif
      next
   endif
   if !( US_Word( memoread( PUB_cProjectFolder + DEF_SLASH + '_'+PUB_cSecu+'End.Txt' ) , 1 ) == "ERROR" )
      For e:=1 to len( vErrors )
         if at( vErrors[e][1] , NewLog ) > 0
            QPM_MemoWrit( PUB_cProjectFolder + DEF_SLASH + '_'+PUB_cSecu+'End.Txt' , "ERROR" )
            EXIT
         endif
      next
   endif
Return NewLog

Function SwitchDebug()
   LOCAL i
   If Empty (PUB_cProjectFolder)
      MsgInfo('To switch debug flag, project folder must not be empty. Look at ' + PagePRG )
      Return .F.
   endif
   if VentanaMain.GPrgFiles.ItemCount == 0
      MsgInfo('To switch debug flag, prg files list must not be empty. Look at ' + PagePRG )
      Return .F.
   endif
// if !PUB_bLite
//    if ! MyMsgYesNo( "Press OK for take debug to all sources or NO for take debug to " + .... + " only" )
// else
//    EraseOBJ()
// endif
   IF PUB_bDebugActive == .T.
      PUB_bDebugActive := .F.
      VentanaMain.Debug.Checked := .F.
   Else
      PUB_bDebugActive := .T.
      VentanaMain.Debug.Checked := .T.
   // QPM_MemoWrit( PUB_cProjectFolder + DEF_SLASH + 'Init.Cld' , 'OPTIONS NORUNATSTARTUP' )
   EndIf
   EraseOBJ()
   if PUB_bLite
      VentanaLite.LFull.FontColor := DEF_COLORRED
      VentanaLite.LFull.Value := "Force Non Incremental"
   else
      VentanaMain.LFull.FontColor := DEF_COLORRED
      VentanaMain.LFull.Value := "Force Non Incremental"
   endif
   QPM_SetResumen()
Return .T.

Function ClearLog()
   ferase( PUB_cQPM_Folder + DEF_SLASH + "QPM.LOG" )
Return .T.

Function FormToolCheck( tool )
   local versionBase := 0 , ver:=0
   do case
      case tool == "HMI"
         versionBase := "1.63"
         If !Empty( FileName := BugGetFile( { {'MGIde by Ciro (MGIde.exe or oIDE*.exe)','MGIde.exe;oIDE*.exe'} } , 'Select Form Tool by Ciro Vargas Clemow' , US_FileNameOnlyPath( GetProperty( "WinGSettings" , "Text_HMI" , "value" ) ) , .F. , .T. ) )
         // if DTOS( US_FileDate( FileName ) ) < "20060204"   && Primera version de HMI+ con parámetro
         //    MsgInfo( "Note: Only HMI+ version "+versionBase+" or higher work fine with QPM" )
         // endif
            SetProperty( "WinGSettings" , "Text_HMI" , "value" , FileName )
         endif
      case tool == "HMGSIDE"
         versionBase := "0.0.7"
      // MsgInfo( "Note: Only HMGsIde version "+versionBase+" or higher work fine with QPM" )
         If !Empty( FileName := BugGetFile( { {'HMGSIDE by Walter (HMGSIDE.exe or IDE.exe)','HMGSIDE.exe;IDE.exe'} } , 'Select Form Tool by Walter Formigoni (Open Source)' , US_FileNameOnlyPath( GetProperty( "WinGSettings" , "Text_HMGSIDE" , "value" ) ) , .F. , .T. ) )
            SetProperty( "WinGSettings" , "Text_HMGSIDE" , "value" , FileName )
         endif
      otherwise
         MsgStop( "Tool inválida en funcion FormToolCheck: "+tool )
   endcase
Return .T.

Function DbfToolCheck( tool )
   local versionBase := 0 , ver:=0
   do case
      case tool == "HMI"
         versionBase := "1.63"
         If !Empty( FileName := BugGetFile( { {'MGIde by Ciro (MGIde.exe)','MGIde.exe'} } , 'Select Dbf Tool by Ciro Vargas Clemow' , US_FileNameOnlyPath( GetProperty( "WinGSettings" , "Text_Dbf" , "value" ) ) , .F. , .T. ) )
            if DTOS( US_FileDate( FileName ) ) < "20060204"   && Primera version de HMI+ con parámetro
               MsgInfo( "Note: Only HMI+ version "+versionBase+" or higher work fine with QPM" )
            endif
            SetProperty( "WinGSettings" , "Text_Dbf" , "value" , FileName )
         endif
      case tool == "HMGSIDE"
         versionBase := "0.0.7"
         MsgInfo( "Note: Only HMGsIde version "+versionBase+" or higher work fine with QPM" )
         If !Empty( FileName := BugGetFile( { {'HMGSIDE by Walter (HMGSIDE.exe)','HMGSIDE.exe'} } , 'Select Dbf Tool by Walter Formigoni (Open Source)' , US_FileNameOnlyPath( GetProperty( "WinGSettings" , "Text_HMGSIDE" , "value" ) ) , .F. , .T. ) )
            SetProperty( "WinGSettings" , "Text_HMGSIDE" , "value" , FileName )
         endif
      otherwise
         MsgStop( "Tool inválida en funcion DbfToolCheck: "+tool )
   endcase
Return .T.

Function ActConsoleMode()
   Prj_Check_Console := GetProperty( "WinPSettings" , "Check_Console" , "value" )
   bConsole := Prj_Check_Console
// EraseOBJ()
// QPM_SetResumen()
// if PUB_bLite
//    VentanaLite.LFull.FontColor := DEF_COLORRED
//    VentanaLite.LFull.Value := "Force Non Incremental"
// else
//    VentanaMain.LFull.FontColor := DEF_COLORRED
//    VentanaMain.LFull.Value := "Force Non Incremental"
// endif
Return .T.

Function ActOutputSuffix()
   Prj_Check_OutputSuffix := GetProperty( "WinPSettings" , "Check_OutputSuffix" , "value" )
   bOutputSuffix := Prj_Check_OutputSuffix
Return .T.

Function ActUpx()
   Prj_Check_Upx := GetProperty( "WinPSettings" , "Check_Upx" , "value" )
   bUpx := Prj_Check_Upx
Return .T.

Function ActFormTool()
   Prj_Radio_FormTool := GetProperty( "WinPSettings" , "Radio_Form" , "value" )
   ActFormToolSet()
Return .T.

Function ActFormToolSet()
   do case
      case Prj_Radio_FormTool = 1
         cFormTool := "AUTO"
      case Prj_Radio_FormTool = 2
         cFormTool := "HMI"
      case Prj_Radio_FormTool = 3
         cFormTool := "HMGSIDE"
   endcase
Return .T.

Function ActDbfTool()
   Prj_Radio_DbfTool := GetProperty( "WinPSettings" , "Radio_Dbf" , "value" )
   ActDbfToolSet()
Return .T.

Function ActDbfToolSet()
   do case
      case Prj_Radio_DbfTool = 1
         cDbfTool := "DBFVIEW"
//    case Prj_Radio_DbfTool = 2
//       cDbfTool := "DBU"
//    case Prj_Radio_DbfTool = 3
      case Prj_Radio_DbfTool = 2
         cDbfTool := "OTHER"
   endcase
Return .T.

Function ActOutputCopyMove()
   Prj_Radio_OutputCopyMove := GetProperty( "WinPSettings" , "Radio_OutputCopyMove" , "value" )
   Prj_Text_OutputCopyMoveFolder := GetProperty( "WinPSettings" , "Text_CopyMove" , "value" )
   ActOutputCopyMoveSet()
Return .T.

Function ActOutputCopyMoveSet()
   do case
      case Prj_Radio_OutputCopyMove = 1
         cOutputCopyMove := "NONE"
      case Prj_Radio_OutputCopyMove = 2
         cOutputCopyMove := "COPY"
      case Prj_Radio_OutputCopyMove = 3
         cOutputCopyMove := "MOVE"
   endcase
Return .T.

Function SwitchRadioOutputCopyMove()
   do case
      case GetProperty( "WinPSettings" , "Radio_OutputCopyMove" , "value" ) = 1
         SetProperty( "WinPSettings" , "Text_CopyMove"    , "enabled" , .F. )
         SetProperty( "WinPSettings" , "Button_CopyMove"  , "enabled" , .F. )
      case GetProperty( "WinPSettings" , "Radio_OutputCopyMove" , "value" ) = 2
         SetProperty( "WinPSettings" , "Text_CopyMove"    , "enabled" , .T. )
         SetProperty( "WinPSettings" , "Button_CopyMove"  , "enabled" , .T. )
      case GetProperty( "WinPSettings" , "Radio_OutputCopyMove" , "value" ) = 3
         SetProperty( "WinPSettings" , "Text_CopyMove"    , "enabled" , .T. )
         SetProperty( "WinPSettings" , "Button_CopyMove"  , "enabled" , .T. )
   endcase
Return

Function ActOutputRename()
   Prj_Radio_OutputRename := GetProperty( "WinPSettings" , "Radio_OutputRename" , "value" )
   Prj_Text_OutputRenameNewName := GetProperty( "WinPSettings" , "Text_RenameOutput" , "value" )
   ActOutputRenameSet()
   do case
      case cOutputRename == "NONE"
         SetProperty( "WinPSettings" , "Text_RenameOutput" , "enabled" , .F. )
      case cOutputRename == "NEWNAME"
         SetProperty( "WinPSettings" , "Text_RenameOutput" , "enabled" , .F. )
   // case cOutputRename == "SUFFIX"
   //    SetProperty( "WinPSettings" , "Text_RenameOutput" , "enabled" , .F. )
   endcase
Return .T.

Function ActOutputRenameSet()
   do case
      case Prj_Radio_OutputRename = 1
         cOutputRename := "NONE"
      case Prj_Radio_OutputRename = 2
         cOutputRename := "NEWNAME"
   // case Prj_Radio_OutputRename = 3
   //    cOutputRename := "SUFFIX"
   endcase
Return .T.

Function SwitchRadioOutputRename()
   do case
      case GetProperty( "WinPSettings" , "Radio_OutputRename" , "value" ) = 1
         SetProperty( "WinPSettings" , "Text_RenameOutput"    , "enabled" , .F. )
      case GetProperty( "WinPSettings" , "Radio_OutputRename" , "value" ) = 2
         SetProperty( "WinPSettings" , "Text_RenameOutput"    , "enabled" , .T. )
   // case GetProperty( "WinPSettings" , "Radio_OutputRename" , "value" ) = 3
   //    SetProperty( "WinPSettings" , "Text_RenameOutput"    , "enabled" , .F. )
   endcase
Return

Function ActOutputType()
   Prj_Radio_OutputType := GetProperty( "WinPSettings" , "Radio_OutputType" , "value" )
   ActOutputTypeSet()
Return .T.

Function ActOutputTypeSet()
   do case
      case Prj_Radio_OutputType == DEF_RG_EXE
         cOutputType := "SRCEXE"
         bBuildRun := bBuildRunBack
         SetProperty( "VentanaMain" , "bDropDownBandR" , "enabled" , .T. )
         SetProperty( "VentanaMain" , "run" , "enabled" , .T. )
         DefinoWindowsHotKeys( .F. )
      case Prj_Radio_OutputType == DEF_RG_LIB
         cOutputType := "SRCLIB"
         bBuildRunBack := bBuildRun
         bBuildRun := .F.
         SetProperty( "VentanaMain" , "bDropDownBandR" , "enabled" , .F. )
         SetProperty( "VentanaMain" , "run" , "enabled" , .F. )
         DefinoWindowsHotKeys( .F. )
  //  case Prj_Radio_OutputType == DEF_RG_DLL
  //     cOutputType := "SRCDLL"
  //     bBuildRunBack := bBuildRun
  //     bBuildRun := .F.
  //     SetProperty( "VentanaMain" , "bDropDownBandR" , "enabled" , .F. )
  //     SetProperty( "VentanaMain" , "run" , "enabled" , .F. )
  //     DefinoWindowsHotKeys( .F. )
      case Prj_Radio_OutputType == DEF_RG_IMPORT
         cOutputType := "DLLLIB"
         bBuildRunBack := bBuildRun
         bBuildRun := .F.
         SetProperty( "VentanaMain" , "bDropDownBandR" , "enabled" , .F. )
         SetProperty( "VentanaMain" , "run" , "enabled" , .F. )
         DefinoWindowsHotKeys( .F. )
   endcase
Return .T.

Function MainInitAutoRun()
   Local i , bError := .F.
#ifdef QPM_HOTRECOVERY
   QPM_HR_Database := PUB_cQPM_Folder + DEF_SLASH + "QPM_HotRecovery_" + PUB_cQPM_Version3 + ".dbf"
   if !PUB_bLite
      if !file( QPM_HR_Database )
         QPM_Wait( "QPM_HotRecovery_Migrate()" , "Creating or Migrating Hot Recovery Version database from previous releases..." )
         MsgInfo( "Migration finished!" )
      else
         QPM_Wait( "HotRecoveryDatabaseCompatibility( QPM_HR_Database )" , "Checking Compatibility on Hot Recovery Versions Database" )
      endif
   endif
#endif
   if PUB_bLite
      VentanaLite.bStop.Enabled := .F.
      VentanaMain.Hide()
      VentanaLite.Activate()
      DoMethod( "VentanaMain" , "Release" )
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
   Local i , bError := .F.
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
      do while !bBuildFinished
         DO EVENTS
      enddo
   endif
   SetProperty( "VentanaLite" , "Label_3" , "enabled" , .T. )
   SetProperty( "VentanaLite" , "BRunP" , "enabled" , .T. )
   SetProperty( "VentanaLite" , "BRun" , "enabled" , .T. )
   ON KEY ESCAPE OF VentanaLite ACTION DoMethod( "VentanaLite" , "release" )
Return .T.

Function xRefPrgFmg()
   Local f:=0 , c:=0 , p:=0 , Fol := PUB_cProjectFolder+DEF_SLASH , MemoAux:=""
   Private vScanned := {} , vPRGFiles := {} , vPANFiles := {}
   MemoAux := memoread( PUB_cProjectFolder + DEF_SLASH + '_'+PUB_cSecu+'Progress.Log' )
   QPM_MemoWrit( PUB_cProjectFolder + DEF_SLASH + '_'+PUB_cSecu+'Progress.Log' , MemoAux + US_TimeDis( Time() ) + " - Checking cross reference between PRG files and FMG files..." + HB_OsNewLine() )
   if bLogActivity
      QPM_MemoWrit( PUB_cQPM_Folder+DEF_SLASH + "QPM.log" , memoread( PUB_cQPM_Folder+DEF_SLASH + "QPM.log" ) + HB_OSNewLine() + "xRefPrgFmg Initialize" )
   endif
   For f:=1 to VentanaMain.GPanFiles.itemcount
      aadd( vPANFiles , ChgPathToReal( GetProperty( "VentanaMain" , "GPanFiles" , "Cell" , f , NCOLPANFULLNAME ) ) )
   Next f
   For f:=1 to len( vPanFiles )
      For i:=1 to len( vConcatIncludeHB )
         if file( vConcatIncludeHB[i]+DEF_SLASH+US_FileNameOnlyNameAndExt( vPanFiles[f] ) )
            if !( US_Upper( US_ShortName( vConcatIncludeHB[i]+DEF_SLASH+US_FileNameOnlyNameAndExt( vPanFiles[f] ) ) ) == US_Upper( US_ShortName( vPanFiles[f] ) ) )
               MyMsgWarning( "In Folder "+vConcatIncludeHB[i]+" exists the Form "+US_FileNameOnlyNameAndExt( vPanFiles[f] ) + HB_OsNewLine() + ;
                        "Harbour's search process will locate THIS Form first," + HB_OsNewLine() + ;
                        "then the form in "+US_FileNameOnlyPath( vPanFiles[f] ) +" will be ignored." )
            else
               exit
            endif
         endif
      Next i
   Next f
   For f:=1 to VentanaMain.GPrgFiles.itemcount
      aadd( vPRGFiles , ChgPathToReal( GetProperty( "VentanaMain" , "GPrgFiles" , "Cell" , f , NCOLPRGFULLNAME ) ) )
   Next f
   /* Nota: Todo lo referido a vSinLoadWindow y vXRefPrgFmg puede ser eliminado, si eso ocurre, provocamos que en cada BUILD se */
   /*       scaneen los PRG que no tienen LOAD WINDOW, alentando el proceso pero todo irá bien                    */
   /*       Si se usa -BUILD como parametro no tiene ninguna implicancia ya que actua despues de la primera pasada*/
   For f:=1 to len( vPANFiles )
      For p:=1 to len( vPRGFiles )
         if ascan( vSinLoadWindow , { |y| US_Upper( US_VarToStr( y ) ) == US_Upper( vPRGFiles[ p ] ) } ) == 0                && a nivel programa
            if ascan( vScanned , { |y| US_Upper( US_VarToStr( y ) ) == US_Upper( vPRGFiles[ p ] ) } ) == 0                   && a nivel funcion
               if US_FileDateTime( vPANFiles[ f ] ) > US_FileDateTime( Fol + GetObjName() + DEF_SLASH + US_FileNameOnlyName( vPRGFiles[ p ] ) + ".c" )
                  // el primer ascan hace una comparacion parcial ( = ) y se le añade un blanco al final para que solo encuentre palabras completas
                  // el segundo ascan hace una comparacion total ( == ) del string (son dos palabras)
                  // El vector contiene "myPRG myFmg"
                  if ( AScan( vXRefPrgFmg , { |x| US_Upper( US_VarToStr( x ) ) = US_Upper( US_FileNameOnlyNameAndExt( vPrgFiles[ p ] ) ) + " " } ) = 0 .or. ;
                     AScan( vXRefPrgFmg , { |x| US_Upper( US_VarToStr( x ) ) == US_Upper( US_FileNameOnlyNameAndExt( vPrgFiles[ p ] ) ) + " " + US_Upper( US_FileNameOnlyNameAndExt( vPanFiles[ f ] ) ) } ) > 0 )
                     if !( FMG_Scan( vPRGFiles[ p ] , US_FileDateTime( Fol + GetObjName() + DEF_SLASH + US_FileNameOnlyName( vPRGFiles[ p ] ) + ".c" ) ) )
                        AADD( vSinLoadWindow , US_Upper( vPRGFiles[ p ] ) ) && Para Control de Programa desde segunda pasada hasta que se vuele a ingresar
                        if bLogActivity
                           QPM_MemoWrit( PUB_cQPM_Folder+DEF_SLASH + "QPM.log" , memoread( PUB_cQPM_Folder+DEF_SLASH + "QPM.log" ) + HB_OSNewLine() + "xRefPrgFmg Add file '" + vPRGFiles[ p ] + "' to vSinLoadWindow" )
                        endif
                     endif
                  endif
               endif
            endif
         endif
      next
   next
Return .T.

Function FMG_Scan( cFileIn , DateTimeOfC )
   Local hFiIn , cLinea:="" , vFines := { chr(13) + chr(10) , Chr(10) } , bLoadWindow := .F.
   Local vAux          := {}
   Private cFilePrgAux := US_Upper( US_FileNameOnlyNameAndExt( cFileIn ) )
   if bLogActivity
      QPM_MemoWrit( PUB_cQPM_Folder+DEF_SLASH + "QPM.log" , memoread( PUB_cQPM_Folder+DEF_SLASH + "QPM.log" ) + HB_OSNewLine() + "xRefPrgFmg Scan file '" + cFileIn + "'" )
   endif
   QPM_MemoWrit( PUB_cProjectFolder + DEF_SLASH + '_'+PUB_cSecu+'Progress.Log' , memoread( PUB_cProjectFolder + DEF_SLASH + '_'+PUB_cSecu+'Progress.Log' ) + US_TimeDis( Time() ) + " - " + "Scanning: "+cFileIn + HB_OsNewLine() )
   /* limpio las ocurrencias del prg */
   For i:=1 to len( vXRefPrgFmg )
      if !( US_Word( vXRefPrgFmg[i] , 1 ) == cFilePrgAux )
         AADD( vAux , vXRefPrgFmg[i] )
      endif
   next
   vXRefPrgFmg := {}
   For i:=1 to len( vAux )
      AADD( vXRefPrgFmg , vAux[i] )
   next
   /* fin limpio las ocurrencias del prg */
   AADD( vScanned , cFileIn )     && Para Control de Funcion llamadora xRefPrgFmg()
   hFiIn := fopen( cFileIn )
   if ferror() = 0
      do while US_FReadLine( hFiIn , @cLinea , vFines ) == 0
         cLinea := alltrim( strtran( cLinea , chr(09) , " " ) )
         if substr( cLinea , 1 , 1 ) == "*"   .or. ;
            substr( cLinea , 1 , 2 ) == "//"  .or. ;
            substr( cLinea , 1 , 2 ) == "##"  .or. ;
            substr( cLinea , 1 , 2 ) == "&&"  .or. ;
            us_words( cLinea ) < 3
         else
            if US_Words( cLinea ) > 2 .and. ;
               US_Upper( US_Word( cLinea , 1 ) ) == "LOAD" .and. ;
               US_Upper( US_Word( cLinea , 2 ) ) == "WINDOW"
               bLoadWindow := .T.
               AADD( vXRefPrgFmg , cFilePrgAux + " " + US_Upper( US_Word( cLinea , 3 ) + ".FMG" ) )
               if ascan( vPanFiles , { |x| US_Upper( US_FileNameOnlyNameAndExt( x ) ) == US_Upper( US_Word( cLinea , 3 ) + ".FMG" ) } ) > 0 .and. ;
                  DateTimeOfC < US_FileDateTime( vPanFiles[ ascan( vPanFiles , { |x| US_Upper( US_FileNameOnlyNameAndExt( x ) ) == US_Upper( US_Word( cLinea , 3 ) + ".FMG" ) } ) ] )
                  QPM_MemoWrit( PUB_cProjectFolder + DEF_SLASH + '_'+PUB_cSecu+'Progress.Log' , memoread( PUB_cProjectFolder + DEF_SLASH + '_'+PUB_cSecu+'Progress.Log' ) + US_TimeDis( Time() ) + " - " + US_Word( cLinea , 3 ) + ".FMG" + " Force Recomp of "+cFileIn + HB_OsNewLine() )
                  ferase( PUB_cProjectFolder + DEF_SLASH + GetObjName() + DEF_SLASH + US_FileNameOnlyName( cFileIn ) + ".C" )
                  if bLogActivity
                     QPM_MemoWrit( PUB_cQPM_Folder+DEF_SLASH + "QPM.log" , memoread( PUB_cQPM_Folder+DEF_SLASH + "QPM.log" ) + HB_OSNewLine() + "xRefPrgFmg " + US_Word( cLinea , 3 ) + ".FMG" + " Force Erase .C of file '" + cFileIn + "' in Scan" )
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

Function xRefPrgHea()
   Local f:=0 , c:=0 , p:=0 , Fol := PUB_cProjectFolder+DEF_SLASH
   Private vScanned := {} , vPRGFiles := {} , vHEAFiles := {}
   QPM_MemoWrit( PUB_cProjectFolder + DEF_SLASH + '_'+PUB_cSecu+'Progress.Log' , US_TimeDis( Time() ) + " - Checking cross reference between PRG files and Headers files..." + HB_OsNewLine() )
   if bLogActivity
      QPM_MemoWrit( PUB_cQPM_Folder+DEF_SLASH + "QPM.log" , memoread( PUB_cQPM_Folder+DEF_SLASH + "QPM.log" ) + HB_OSNewLine() + "xRefPrgHea Initialize" )
   endif
   For f:=1 to VentanaMain.GHeaFiles.itemcount
      aadd( vHEAFiles , ChgPathToReal( GetProperty( "VentanaMain" , "GHeaFiles" , "Cell" , f , NCOLHEAFULLNAME ) ) )
   Next f
   For f:=1 to len( vHeaFiles )
      For i:=1 to len( vConcatIncludeC )
         if file( vConcatIncludeC[i]+DEF_SLASH+US_FileNameOnlyNameAndExt( vHeaFiles[f] ) )
            if !( US_Upper( US_ShortName( vConcatIncludeC[i]+DEF_SLASH+US_FileNameOnlyNameAndExt( vHeaFiles[f] ) ) ) == US_Upper( US_ShortName(vHeaFiles[f]) ) )
               MyMsgWarning( "In Folder "+vConcatIncludeC[i]+" exists the Header "+US_FileNameOnlyNameAndExt( vHeaFiles[f] ) + HB_OsNewLine() + ;
                        "If you code #include with caracters '<' and '>', the search process of Harbour and C compilers will locate THIS header first," + HB_OsNewLine() + ;
                        "then the header in "+US_FileNameOnlyPath( vHeaFiles[f] ) +" will be ignored." )
            else
               exit
            endif
         endif
      Next i
   Next f
   For f:=1 to VentanaMain.GPrgFiles.itemcount
      aadd( vPRGFiles , ChgPathToReal( GetProperty( "VentanaMain" , "GPrgFiles" , "Cell" , f , NCOLPRGFULLNAME ) ) )
   Next f
   /* Nota: Todo lo referido a vSinInclude y vXRefPrgHea puede ser eliminado, si eso ocurre, provocamos que en cada BUILD se    */
   /*       scaneen los PRG que no tienen #include, alentando el proceso pero todo irá bien                       */
   /*       Si se usa -BUILD como parametro no tiene ninguna implicancia ya que actua despues de la primera pasada*/
   For f:=1 to len( vHEAFiles )
      For p:=1 to len( vPRGFiles )
         if ascan( vScanned , { |y| US_Upper( US_VarToStr( y ) ) == US_Upper( vPrgFiles[ p ] ) } ) == 0                      && a nivel funcion
         // if US_FileDateTime( vHeaFiles[ f ] ) > US_FileDateTime( Fol + GetObjName() + DEF_SLASH + US_FileNameOnlyName( vPrgFiles[ p ] ) + ".c" )
         // if US_FileDateTime( vHeaFiles[ f ] ) > US_FileDateTime( Fol + GetObjName() + DEF_SLASH + US_FileNameOnlyName( vPrgFiles[ p ] ) + if( US_Upper( US_FileNameOnlyExt( vPrgFiles[ p ] ) ) == "CPP" , ".cpp" , ".c" ) )
            if US_FileDateTime( vHeaFiles[ f ] ) > US_FileDateTime( Fol + GetObjName() + DEF_SLASH + US_FileNameOnlyName( vPrgFiles[ p ] ) + if( US_Upper( US_FileNameOnlyExt( vPrgFiles[ p ] ) ) == "PRG" , ".c" , "."+GetObjExt() ) )
               if ascan( vSinInclude , { |y| US_Upper( US_VarToStr( y ) ) == US_Upper( vPrgFiles[ p ] ) } ) == 0                && a nivel programa
                  // el primer ascan hace una comparacion parcial ( = ) y se le añade un blanco al final para que solo encuentre palabras completas
                  // el segundo ascan hace una comparacion total ( == ) del string (son dos palabras)
                  // El vector contiene "myPRG myHeader.h"
                  if ( AScan( vXRefPrgHea , { |x| US_Upper( US_VarToStr( x ) ) = US_Upper( US_FileNameOnlyNameAndExt( vPrgFiles[ p ] ) ) + " " } ) = 0 .or. ;
                     AScan( vXRefPrgHea , { |x| US_Upper( US_VarToStr( x ) ) == US_Upper( US_FileNameOnlyNameAndExt( vPrgFiles[ p ] ) ) + " " + US_Upper( US_FileNameOnlyNameAndExt( vHeaFiles[ f ] ) ) } ) > 0 )
                   //if !( HEA_Scan( vPrgFiles[ p ] , US_FileDateTime( Fol + GetObjName() + DEF_SLASH + US_FileNameOnlyName( vPrgFiles[ p ] ) + ".c" ) ) )
                   //if !( HEA_Scan( vPrgFiles[ p ] , US_FileDateTime( Fol + GetObjName() + DEF_SLASH + US_FileNameOnlyName( vPrgFiles[ p ] ) + if( US_Upper( US_FileNameOnlyExt( vPrgFiles[ p ] ) ) == "CPP" , ".cpp" , ".c" ) ) ) )
                     if !( HEA_Scan( vPrgFiles[ p ] , US_FileDateTime( Fol + GetObjName() + DEF_SLASH + US_FileNameOnlyName( vPrgFiles[ p ] ) + if( US_Upper( US_FileNameOnlyExt( vPrgFiles[ p ] ) ) == "PRG" , ".c" , "."+GetObjExt() ) ) ) )
                        AADD( vSinInclude , US_Upper( vPrgFiles[ p ] ) ) && Para Control de Programa desde segunda pasada hasta que se vuele a ingresar
                        if bLogActivity
                           QPM_MemoWrit( PUB_cQPM_Folder+DEF_SLASH + "QPM.log" , memoread( PUB_cQPM_Folder+DEF_SLASH + "QPM.log" ) + HB_OSNewLine() + "xRefPrgHea Add file '" + vPrgFiles[ p ] + "' to vSinInclude" )
                        endif
                     endif
                  endif
               endif
            endif
         endif
      next
   next
Return .T.

Function HEA_Scan( cFileIn , DateTimeOfC )
   Local hFiIn , cLinea:="" , vFines := { Chr(13) + Chr(10) , Chr(10) } , bIncludeFound := .F. , cName := "" , i
   Local maxDateHeader := "00000000000000" , incChars := { { '"' , '"' } , { "'" , "'" } , { "<" , ">" } }
   Local vAux          := {}
   Private vPreventLoop := {}
   Private cFilePrgAux  := US_Upper( US_FileNameOnlyNameAndExt( cFileIn ) )
   QPM_MemoWrit( PUB_cProjectFolder + DEF_SLASH + '_'+PUB_cSecu+'Progress.Log' , memoread( PUB_cProjectFolder + DEF_SLASH + '_'+PUB_cSecu+'Progress.Log' ) + US_TimeDis( Time() ) + " - " + "Scanning: "+cFileIn + HB_OsNewLine() )
   if bLogActivity
      QPM_MemoWrit( PUB_cQPM_Folder+DEF_SLASH + "QPM.log" , memoread( PUB_cQPM_Folder+DEF_SLASH + "QPM.log" ) + HB_OSNewLine() + "xRefPrgHea Scan file '" + cFileIn + "'" )
   endif
   AADD( vScanned , cFileIn )     && Para Control de Funcion llamadora xRefPrgHea()
   hFiIn := fopen( cFileIn )
   if ferror() = 0
      do while US_FReadLine( hFiIn , @cLinea , vFines ) == 0
         cLinea := alltrim( strtran( cLinea , chr(09) , " " ) )
         if US_Words( cLinea ) > 1 .and. ;
            US_Upper( US_Word( cLinea , 1 ) ) == "#INCLUDE"
            cName := ""
            For i:=1 to len( incChars )
               if substr( us_word( cLinea , 2 ) , 1 , 1 ) == incChars[i][1]
                  cName := substr( US_WordSubStr( cLinea , 2 ) , 2 , rat( incChars[i][2] , US_WordSubStr( cLinea , 2 ) ) - 2 )
               endif
            next
            if ascan( vHeaFiles , { |x| US_Upper( US_FileNameOnlyNameAndExt( x ) ) == US_Upper( cName ) } ) > 0 .and. ;
               file( vHeaFiles[ ascan( vHeaFiles , { |x| US_Upper( US_FileNameOnlyNameAndExt( x ) ) == US_Upper( cName ) } ) ] )
               bIncludeFound := .T.
               if ascan( vPreventLoop , US_Upper( cName ) ) = 0
                  AADD( vPreventLoop , US_Upper( cName ) )
                  /* limpio las ocurrencias del prg */
                  For i:=1 to len( vXRefPrgHea )
                     if !( US_Word( vXRefPrgHea[i] , 1 ) == cFilePrgAux )
                        AADD( vAux , vXRefPrgHea[i] )
                     endif
                  next
                  vXRefPrgHea := {}
                  For i:=1 to len( vAux )
                     AADD( vXRefPrgHea , vAux[i] )
                  next
                  /* fin limpio las ocurrencias del prg */
                  AADD( vXRefPrgHea , cFilePrgAux + " " + US_Upper( cName ) )
                  maxDateHeader := ScanIncRecursive( vHeaFiles[ ascan( vHeaFiles , { |x| US_Upper( US_FileNameOnlyNameAndExt( x ) ) == US_Upper( cName ) } ) ] )
               endif
            endif
            if DateTimeOfC < maxDateHeader
               QPM_MemoWrit( PUB_cProjectFolder + DEF_SLASH + '_'+PUB_cSecu+'Progress.Log' , memoread( PUB_cProjectFolder + DEF_SLASH + '_'+PUB_cSecu+'Progress.Log' ) + US_TimeDis( Time() ) + " - " + cName + " or sub includes Force Recomp of "+cFileIn + HB_OsNewLine() )
            // ferase( PUB_cProjectFolder + DEF_SLASH + GetObjName() + DEF_SLASH + US_FileNameOnlyName( cFileIn ) + ".c" )
            // ferase( PUB_cProjectFolder + DEF_SLASH + GetObjName() + DEF_SLASH + US_FileNameOnlyName( cFileIn ) + if( US_Upper( US_FileNameOnlyExt( cFileIn ) ) == "CPP" , ".cpp" , ".c" ) )
               ferase( PUB_cProjectFolder + DEF_SLASH + GetObjName() + DEF_SLASH + US_FileNameOnlyName( cFileIn ) + if( US_Upper( US_FileNameOnlyExt( cFileIn ) ) == "PRG" , ".c" , "."+GetObjExt() ) )
               if bLogActivity
                  QPM_MemoWrit( PUB_cQPM_Folder+DEF_SLASH + "QPM.log" , memoread( PUB_cQPM_Folder+DEF_SLASH + "QPM.log" ) + HB_OSNewLine() + "xRefPrgHea " + cName + " or sub includes Force Erase .C of file '" + cFileIn + "' in Scan" )
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

Function ScanIncRecursive( cFileIn )
   Local hFiIn , cLinea:="" , vFines := { Chr(13) + Chr(10) , Chr(10) }
   Local maxDateHeader  := US_FileDateTime( cFileIn ) , incChars := { { '"' , '"' } , { "'" , "'" } , { "<" , ">" } }
   Local callDateHeader := "00000000000000"
   Local vAux           := {}
   hFiIn := fopen( cFileIn )
   if ferror() = 0
      do while US_FReadLine( hFiIn , @cLinea , vFines ) == 0
         cLinea := alltrim( strtran( cLinea , chr(09) , " " ) )
         if US_Words( cLinea ) > 1 .and. ;
            US_Upper( US_Word( cLinea , 1 ) ) == "#INCLUDE"
            cName := ""
            For i:=1 to len( incChars )
               if substr( us_word( cLinea , 2 ) , 1 , 1 ) == incChars[i][1]
                  cName := substr( US_WordSubStr( cLinea , 2 ) , 2 , rat( incChars[i][2] , US_WordSubStr( cLinea , 2 ) ) - 2 )
               endif
            next
            if ascan( vHeaFiles , { |x| US_Upper( US_FileNameOnlyNameAndExt( x ) ) == US_Upper( cName ) } ) > 0 .and. ;
               file( vHeaFiles[ ascan( vHeaFiles , { |x| US_Upper( US_FileNameOnlyNameAndExt( x ) ) == US_Upper( cName ) } ) ] )
               if ascan( vPreventLoop , US_Upper( cName ) ) = 0
                  AADD( vPreventLoop , US_Upper( cName ) )
                  AADD( vXRefPrgHea , cFilePrgAux + " " + US_Upper( cName ) )
                  if maxDateHeader < ( callDateHeader := ScanIncRecursive( vHeaFiles[ ascan( vHeaFiles , { |x| US_Upper( US_FileNameOnlyNameAndExt( x ) ) == US_Upper( cName ) } ) ] ) )
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
   Local hFiIn , cLinea:="" , vFines := { Chr(13) + Chr(10) , Chr(10) } , reto := "UNKNOWN"
   hFiIn := fopen( cForm )
   if ferror() = 0
      do while US_FReadLine( hFiIn , @cLinea , vFines ) == 0
         cLinea := alltrim( strtran( cLinea , chr(09) , " " ) )
         do case
            case US_Upper( US_Word( cLinea , 1 ) ) == "*HMGS-MINIGUI-IDE"
               reto := "HMGSIDE (Open Source by Walter Formigoni)"
               exit
            case at( "* HARBOUR MINIGUI IDE HMI+" , US_Upper( cLinea ) ) > 0
               reto := "HMI (by Ciro Vargas Clemow)"
               exit
            case at( "* OOHG IDE" , US_Upper( cLinea ) ) > 0
               reto := "HMI (by Ciro Vargas Clemow)"
               exit
            case at( "* HARBOUR MINIGUI IDE TWO-WAY" , US_Upper( cLinea ) ) > 0
               reto := "IDE (by Roberto Lopez)"
               exit
         endcase
      enddo
      fclose( hFiIn )
   endif
Return reto

Function PrjSetColor()
   Do case
      case GetProperty( "WinPSettings" , "Radio_OutputType" , "value" ) == DEF_RG_EXE
         SetProperty( "VentanaMain" , "RichEditSysout" , "backcolor" , DEF_COLOREXE )
      case GetProperty( "WinPSettings" , "Radio_OutputType" , "value" ) == DEF_RG_LIB
         SetProperty( "VentanaMain" , "RichEditSysout" , "backcolor" , DEF_COLORLIB )
      case GetProperty( "WinPSettings" , "Radio_OutputType" , "value" ) == DEF_RG_IMPORT
         SetProperty( "VentanaMain" , "RichEditSysout" , "backcolor" , DEF_COLORDLL )
   endcase
Return .T.

Function QPM_SetColor()
   if PUB_bLite
      Do case
         case Prj_Radio_OutputType == DEF_RG_EXE
            SetProperty( "VentanaLite" , "RichEditSysout" , "backcolor" , DEF_COLOREXE )
         case Prj_Radio_OutputType == DEF_RG_LIB
            SetProperty( "VentanaLite" , "RichEditSysout" , "backcolor" , DEF_COLORLIB )
         case Prj_Radio_OutputType == DEF_RG_IMPORT
            SetProperty( "VentanaLite" , "RichEditSysout" , "backcolor" , DEF_COLORDLL )
      endcase
   else
      Do case
         case Prj_Radio_OutputType == DEF_RG_EXE
            SetProperty( "VentanaMain" , "RichEditSysout" , "backcolor" , DEF_COLOREXE )
         case Prj_Radio_OutputType == DEF_RG_LIB
            SetProperty( "VentanaMain" , "RichEditSysout" , "backcolor" , DEF_COLORLIB )
         case Prj_Radio_OutputType == DEF_RG_IMPORT
            SetProperty( "VentanaMain" , "RichEditSysout" , "backcolor" , DEF_COLORDLL )
      endcase
   endif
Return .T.

Function SortPRG( cVentana , cGrid , nColumna )
   Local vAux := {} , cAux := GetProperty( cVentana , cGrid , "item" , 1 )
   Local nActual := GetProperty( cVentana , cGrid , "cell" , GetProperty( cVentana , cGrid , "value" ) , nColumna )
   bPrgSorting := .T.
   if VentanaMain.GPrgFiles.ItemCount > 1
      DoMethod( cVentana , cGrid , "DisableUpdate" )
      For i:=2 to GetProperty( cVentana , cGrid , "itemcount" )
         aadd( vAux , GetProperty( cVentana , cGrid , "item" , i ) )
      next
      DoMethod( cVentana , cGrid , "deleteallitems" )
      DoMethod( cVentana , cGrid , "additem" , cAux )
      if bSortPrgAsc
         aSort( vAux ,,, { |x, y| US_Upper(x[nColumna]) < US_Upper(y[nColumna]) })
      else
         aSort( vAux ,,, { |x, y| US_Upper(x[nColumna]) > US_Upper(y[nColumna]) })
      endif
      bSortPrgAsc := !bSortPrgAsc
      For i:=1 to len( vAux )
         DoMethod( cVentana , cGrid , "additem" , vAux[ i ] )
      next
      SetProperty( cVentana , cGrid , "value" , aScan( vAux , {|x| x[ nColumna ] == nActual } ) + 1 )
      DoMethod( cVentana , cGrid , "setfocus" )
      DoMethod( cVentana , cGrid , "EnableUpdate" )
   endif
   bPrgSorting := .F.
Return .T.

Function SortHEA( cVentana , cGrid , nColumna )
   Local vAux := {}
   Local nActual := GetProperty( cVentana , cGrid , "cell" , GetProperty( cVentana , cGrid , "value" ) , nColumna )
   bHeaSorting := .T.
   DoMethod( cVentana , cGrid , "DisableUpdate" )
   For i:=1 to GetProperty( cVentana , cGrid , "itemcount" )
      aadd( vAux , GetProperty( cVentana , cGrid , "item" , i ) )
   next
   DoMethod( cVentana , cGrid , "deleteallitems" )
   if bSortHeaAsc
      aSort( vAux ,,, { |x, y| US_Upper(x[nColumna]) < US_Upper(y[nColumna]) })
   else
      aSort( vAux ,,, { |x, y| US_Upper(x[nColumna]) > US_Upper(y[nColumna]) })
   endif
   bSortHeaAsc := !bSortHeaAsc
   For i:=1 to len( vAux )
      DoMethod( cVentana , cGrid , "additem" , vAux[ i ] )
   next
   SetProperty( cVentana , cGrid , "value" , aScan( vAux , {|x| x[ nColumna ] == nActual } ) )
   DoMethod( cVentana , cGrid , "setfocus" )
   DoMethod( cVentana , cGrid , "EnableUpdate" )
   bHeaSorting := .F.
Return .T.

Function SortPAN( cVentana , cGrid , nColumna )
   Local vAux := {}
   Local nActual := GetProperty( cVentana , cGrid , "cell" , GetProperty( cVentana , cGrid , "value" ) , nColumna )
   bPanSorting := .T.
   DoMethod( cVentana , cGrid , "DisableUpdate" )
   For i:=1 to GetProperty( cVentana , cGrid , "itemcount" )
      aadd( vAux , GetProperty( cVentana , cGrid , "item" , i ) )
   next
   DoMethod( cVentana , cGrid , "deleteallitems" )
   if bSortPanAsc
      aSort( vAux ,,, { |x, y| US_Upper(x[nColumna]) < US_Upper(y[nColumna]) })
   else
      aSort( vAux ,,, { |x, y| US_Upper(x[nColumna]) > US_Upper(y[nColumna]) })
   endif
   bSortPanAsc := !bSortPanAsc
   For i:=1 to len( vAux )
      DoMethod( cVentana , cGrid , "additem" , vAux[ i ] )
   next
   SetProperty( cVentana , cGrid , "value" , aScan( vAux , {|x| x[ nColumna ] == nActual } ) )
   DoMethod( cVentana , cGrid , "setfocus" )
   DoMethod( cVentana , cGrid , "EnableUpdate" )
   bPanSorting := .F.
Return .T.

Function SortDBF( cVentana , cGrid , nColumna )
   Local vAux := {}
   Local nActual := GetProperty( cVentana , cGrid , "cell" , GetProperty( cVentana , cGrid , "value" ) , nColumna )
   bDbfSorting := .T.
   DoMethod( cVentana , cGrid , "DisableUpdate" )
   For i:=1 to GetProperty( cVentana , cGrid , "itemcount" )
      aadd( vAux , GetProperty( cVentana , cGrid , "item" , i ) )
   next
   DoMethod( cVentana , cGrid , "deleteallitems" )
   if bSortDbfAsc
      aSort( vAux ,,, { |x, y| US_Upper(x[nColumna]) < US_Upper(y[nColumna]) })
   else
      aSort( vAux ,,, { |x, y| US_Upper(x[nColumna]) > US_Upper(y[nColumna]) })
   endif
   bSortDbfAsc := !bSortDbfAsc
   For i:=1 to len( vAux )
      DoMethod( cVentana , cGrid , "additem" , vAux[ i ] )
   next
   SetProperty( cVentana , cGrid , "value" , aScan( vAux , {|x| x[ nColumna ] == nActual } ) )
   DoMethod( cVentana , cGrid , "setfocus" )
   DoMethod( cVentana , cGrid , "EnableUpdate" )
   bDbfSorting := .F.
Return .T.

Function SortInc( cVentana , cGrid , nColumna )
   Local vAux := {}
   Local nActual := GetProperty( cVentana , cGrid , "cell" , GetProperty( cVentana , cGrid , "value" ) , nColumna )
   bIncSorting := .T.
   DoMethod( cVentana , cGrid , "DisableUpdate" )
   For i:=1 to GetProperty( cVentana , cGrid , "itemcount" )
      aadd( vAux , GetProperty( cVentana , cGrid , "item" , i ) )
   next
   DoMethod( cVentana , cGrid , "deleteallitems" )
   if nColumna = NCOLINCFULLNAME
      if bSortIncAsc
         aSort( vAux ,,, { |x, y| US_Upper(US_WordSubstr(x[nColumna],3)) < US_Upper(US_WordSubStr(y[nColumna],3)) })
      else
         aSort( vAux ,,, { |x, y| US_Upper(US_WordSubstr(x[nColumna],3)) > US_Upper(US_WordSubStr(y[nColumna],3)) })
      endif
   else
      if bSortIncAsc
         aSort( vAux ,,, { |x, y| US_Upper( x[nColumna] ) < US_Upper( y[nColumna] ) } )
      else
         aSort( vAux ,,, { |x, y| US_Upper( x[nColumna] ) > US_Upper( y[nColumna] ) } )
      endif
   endif
   bSortIncAsc := !bSortIncAsc
   For i:=1 to len( vAux )
      DoMethod( cVentana , cGrid , "additem" , vAux[ i ] )
   next
   if nColumna = NCOLINCFULLNAME
      SetProperty( cVentana , cGrid , "value" , aScan( vAux , {|x| US_WordSubStr( x[ nColumna ] , 3 ) == US_WordSubStr( nActual , 3 ) } ) )
   else
      SetProperty( cVentana , cGrid , "value" , aScan( vAux , {|x| x[ nColumna ] == nActual } ) )
   endif
   DoMethod( cVentana , cGrid , "setfocus" )
   DoMethod( cVentana , cGrid , "EnableUpdate" )
   bIncSorting := .F.
Return .T.

Function SortExc( cVentana , cGrid , nColumna )
   Local vAux := {}
   Local nActual := GetProperty( cVentana , cGrid , "cell" , GetProperty( cVentana , cGrid , "value" ) , nColumna )
   bExcSorting := .T.
   DoMethod( cVentana , cGrid , "DisableUpdate" )
   For i:=1 to GetProperty( cVentana , cGrid , "itemcount" )
      aadd( vAux , GetProperty( cVentana , cGrid , "item" , i ) )
   next
   DoMethod( cVentana , cGrid , "deleteallitems" )
   if bSortExcAsc
      aSort( vAux ,,, { |x, y| US_Upper(x[nColumna]) < US_Upper(y[nColumna]) })
   else
      aSort( vAux ,,, { |x, y| US_Upper(x[nColumna]) > US_Upper(y[nColumna]) })
   endif
   bSortExcAsc := !bSortExcAsc
   For i:=1 to len( vAux )
      DoMethod( cVentana , cGrid , "additem" , vAux[ i ] )
   next
   SetProperty( cVentana , cGrid , "value" , aScan( vAux , {|x| x[ nColumna ] == nActual } ) )
   DoMethod( cVentana , cGrid , "setfocus" )
   DoMethod( cVentana , cGrid , "EnableUpdate" )
   bExcSorting := .F.
Return .T.

//Function SortHlp( cVentana , cGrid , nColumna )
//   Local vAux := {} , cAux := GetProperty( cVentana , cGrid , "item" , 1 )
//   Local nActual := GetProperty( cVentana , cGrid , "cell" , GetProperty( cVentana , cGrid , "value" ) , nColumna )
//   bHlpSorting := .T.
//   if VentanaMain.GHlpFiles.ItemCount > 1
//      DoMethod( cVentana , cGrid , "DisableUpdate" )
//      For i:=2 to GetProperty( cVentana , cGrid , "itemcount" )
//         aadd( vAux , GetProperty( cVentana , cGrid , "item" , i ) )
//      next
//      DoMethod( cVentana , cGrid , "deleteallitems" )
//      DoMethod( cVentana , cGrid , "additem" , cAux )
//      if bSortHlpAsc
//         aSort( vAux ,,, { |x, y| US_Upper(x[nColumna]) < US_Upper(y[nColumna]) })
//      else
//         aSort( vAux ,,, { |x, y| US_Upper(x[nColumna]) > US_Upper(y[nColumna]) })
//      endif
//      bSortHlpAsc := !bSortHlpAsc
//      For i:=1 to len( vAux )
//         DoMethod( cVentana , cGrid , "additem" , vAux[ i ] )
//      next
//      SetProperty( cVentana , cGrid , "value" , aScan( vAux , {|x| x[ nColumna ] == nActual } ) + 1 )
//      DoMethod( cVentana , cGrid , "setfocus" )
//      DoMethod( cVentana , cGrid , "EnableUpdate" )
//   endif
//   bHlpSorting := .F.
//Return .T.

Function UpPrg()
   Local i := GetProperty( "VentanaMain" , "GPrgFiles" , "value" )
   Local cAux := GetProperty( "VentanaMain" , "GPrgFiles" , "item" , i )
   Local cAux2 := GetProperty( "VentanaMain" , "GPrgFiles" , "item" , i - 1 )
   if i = 2
      MsgInfo( "Use the SetTop button for Up this item to Top of Project" )
   endif
   if i > 2
      bPrgMoving := .T.
      SetProperty( "VentanaMain" , "GPrgFiles" , "item" , i , cAux2 )
      SetProperty( "VentanaMain" , "GPrgFiles" , "item" , i - 1 , cAux )
      SetProperty( "VentanaMain" , "GPrgFiles" , "value" , i - 1 )
      DoMethod( "VentanaMain" , "GPrgFiles" , "setfocus" )
      bPrgMoving := .F.
   endif
Return .T.

Function DownPrg()
   Local i := GetProperty( "VentanaMain" , "GPrgFiles" , "value" )
   Local cAux := GetProperty( "VentanaMain" , "GPrgFiles" , "item" , i )
   Local cAux2 := GetProperty( "VentanaMain" , "GPrgFiles" , "item" , i + 1 )
   if i = 1
      MsgInfo( "Not valid for Top file of Project, use the SetTop button from another PRG for change this Top file" )
   endif
   if i < GetProperty( "VentanaMain" , "GPrgFiles" , "itemcount" ) .and. i > 1
      bPrgMoving := .T.
      SetProperty( "VentanaMain" , "GPrgFiles" , "item" , i , cAux2 )
      SetProperty( "VentanaMain" , "GPrgFiles" , "item" , i + 1 , cAux )
      SetProperty( "VentanaMain" , "GPrgFiles" , "value" , i + 1 )
      DoMethod( "VentanaMain" , "GPrgFiles" , "setfocus" )
      bPrgMoving := .F.
   endif
Return .T.

Function UpPan()
   Local i := GetProperty( "VentanaMain" , "GPanFiles" , "value" )
   Local cAux := GetProperty( "VentanaMain" , "GPanFiles" , "item" , i )
   Local cAux2 := GetProperty( "VentanaMain" , "GPanFiles" , "item" , i - 1 )
   if i > 1
      bPanMoving := .T.
      SetProperty( "VentanaMain" , "GPanFiles" , "item" , i , cAux2 )
      SetProperty( "VentanaMain" , "GPanFiles" , "item" , i - 1 , cAux )
      SetProperty( "VentanaMain" , "GPanFiles" , "value" , i - 1 )
      DoMethod( "VentanaMain" , "GPanFiles" , "setfocus" )
      bPanMoving := .F.
   endif
Return .T.

Function DownPan()
   Local i := GetProperty( "VentanaMain" , "GPanFiles" , "value" )
   Local cAux := GetProperty( "VentanaMain" , "GPanFiles" , "item" , i )
   Local cAux2 := GetProperty( "VentanaMain" , "GPanFiles" , "item" , i + 1 )
   if i > 0 .and. i < GetProperty( "VentanaMain" , "GPanFiles" , "itemcount" )
      bPanMoving := .T.
      SetProperty( "VentanaMain" , "GPanFiles" , "item" , i , cAux2 )
      SetProperty( "VentanaMain" , "GPanFiles" , "item" , i + 1 , cAux )
      SetProperty( "VentanaMain" , "GPanFiles" , "value" , i + 1 )
      DoMethod( "VentanaMain" , "GPanFiles" , "setfocus" )
      bPanMoving := .F.
   endif
Return .T.

Function UpDbf()
   Local i := GetProperty( "VentanaMain" , "GDbfFiles" , "value" )
   Local cAux := GetProperty( "VentanaMain" , "GDbfFiles" , "item" , i )
   Local cAux2 := GetProperty( "VentanaMain" , "GDbfFiles" , "item" , i - 1 )
   if i > 1
      bDbfMoving := .T.
      SetProperty( "VentanaMain" , "GDbfFiles" , "item" , i , cAux2 )
      SetProperty( "VentanaMain" , "GDbfFiles" , "item" , i - 1 , cAux )
      SetProperty( "VentanaMain" , "GDbfFiles" , "value" , i - 1 )
      DoMethod( "VentanaMain" , "GDbfFiles" , "setfocus" )
      bDbfMoving := .F.
   endif
Return .T.

Function DownDbf()
   Local i := GetProperty( "VentanaMain" , "GDbfFiles" , "value" )
   Local cAux := GetProperty( "VentanaMain" , "GDbfFiles" , "item" , i )
   Local cAux2 := GetProperty( "VentanaMain" , "GDbfFiles" , "item" , i + 1 )
   if i > 0 .and. i < GetProperty( "VentanaMain" , "GDbfFiles" , "itemcount" )
      bDbfMoving := .T.
      SetProperty( "VentanaMain" , "GDbfFiles" , "item" , i , cAux2 )
      SetProperty( "VentanaMain" , "GDbfFiles" , "item" , i + 1 , cAux )
      SetProperty( "VentanaMain" , "GDbfFiles" , "value" , i + 1 )
      DoMethod( "VentanaMain" , "GDbfFiles" , "setfocus" )
      bDbfMoving := .F.
   endif
Return .T.

Function UpHea()
   Local i := GetProperty( "VentanaMain" , "GHeaFiles" , "value" )
   Local cAux := GetProperty( "VentanaMain" , "GHeaFiles" , "item" , i )
   Local cAux2 := GetProperty( "VentanaMain" , "GHeaFiles" , "item" , i - 1 )
   if i > 1
      bHeaMoving := .T.
      SetProperty( "VentanaMain" , "GHeaFiles" , "item" , i , cAux2 )
      SetProperty( "VentanaMain" , "GHeaFiles" , "item" , i - 1 , cAux )
      SetProperty( "VentanaMain" , "GHeaFiles" , "value" , i - 1 )
      DoMethod( "VentanaMain" , "GHeaFiles" , "setfocus" )
      bHeaMoving := .F.
   endif
Return .T.

Function DownHea()
   Local i := GetProperty( "VentanaMain" , "GHeaFiles" , "value" )
   Local cAux := GetProperty( "VentanaMain" , "GHeaFiles" , "item" , i )
   Local cAux2 := GetProperty( "VentanaMain" , "GHeaFiles" , "item" , i + 1 )
   if i > 0 .and. i < GetProperty( "VentanaMain" , "GHeaFiles" , "itemcount" )
      bHeaMoving := .T.
      SetProperty( "VentanaMain" , "GHeaFiles" , "item" , i , cAux2 )
      SetProperty( "VentanaMain" , "GHeaFiles" , "item" , i + 1 , cAux )
      SetProperty( "VentanaMain" , "GHeaFiles" , "value" , i + 1 )
      DoMethod( "VentanaMain" , "GHeaFiles" , "setfocus" )
      bHeaMoving := .F.
   endif
Return .T.

Function UpLibInclude()
   Local i := GetProperty( "VentanaMain" , "GIncFiles" , "value" )
   Local cAux := GetProperty( "VentanaMain" , "GIncFiles" , "item" , i )
   Local cAux2 := GetProperty( "VentanaMain" , "GIncFiles" , "item" , i - 1 )
   if i > 1
      bIncMoving := .T.
      SetProperty( "VentanaMain" , "GIncFiles" , "item" , i , cAux2 )
      SetProperty( "VentanaMain" , "GIncFiles" , "item" , i - 1 , cAux )
      SetProperty( "VentanaMain" , "GIncFiles" , "value" , i - 1 )
      DoMethod( "VentanaMain" , "GIncFiles" , "setfocus" )
      bIncMoving := .F.
   endif
Return .T.

Function DownLibInclude()
   Local i := GetProperty( "VentanaMain" , "GIncFiles" , "value" )
   Local cAux := GetProperty( "VentanaMain" , "GIncFiles" , "item" , i )
   Local cAux2 := GetProperty( "VentanaMain" , "GIncFiles" , "item" , i + 1 )
   if i > 0 .and. i < GetProperty( "VentanaMain" , "GIncFiles" , "itemcount" )
      bIncMoving := .T.
      SetProperty( "VentanaMain" , "GIncFiles" , "item" , i , cAux2 )
      SetProperty( "VentanaMain" , "GIncFiles" , "item" , i + 1 , cAux )
      SetProperty( "VentanaMain" , "GIncFiles" , "value" , i + 1 )
      DoMethod( "VentanaMain" , "GIncFiles" , "setfocus" )
      bIncMoving := .F.
   endif
Return .T.

Function UpLibExclude()
   Local i := GetProperty( "VentanaMain" , "GExcFiles" , "value" )
   Local cAux := GetProperty( "VentanaMain" , "GExcFiles" , "item" , i )
   Local cAux2 := GetProperty( "VentanaMain" , "GExcFiles" , "item" , i - 1 )
   if i > 1
      bExcMoving := .T.
      SetProperty( "VentanaMain" , "GExcFiles" , "item" , i , cAux2 )
      SetProperty( "VentanaMain" , "GExcFiles" , "item" , i - 1 , cAux )
      SetProperty( "VentanaMain" , "GExcFiles" , "value" , i - 1 )
      DoMethod( "VentanaMain" , "GExcFiles" , "setfocus" )
      bExcMoving := .F.
   endif
Return .T.

Function DownLibExclude()
   Local i := GetProperty( "VentanaMain" , "GExcFiles" , "value" )
   Local cAux := GetProperty( "VentanaMain" , "GExcFiles" , "item" , i )
   Local cAux2 := GetProperty( "VentanaMain" , "GExcFiles" , "item" , i + 1 )
   if i > 0 .and. i < GetProperty( "VentanaMain" , "GExcFiles" , "itemcount" )
      bExcMoving := .T.
      SetProperty( "VentanaMain" , "GExcFiles" , "item" , i , cAux2 )
      SetProperty( "VentanaMain" , "GExcFiles" , "item" , i + 1 , cAux )
      SetProperty( "VentanaMain" , "GExcFiles" , "value" , i + 1 )
      DoMethod( "VentanaMain" , "GExcFiles" , "setfocus" )
      bExcMoving := .F.
   endif
Return .T.

#ifdef QPM_SHG
Function UpHlp()
   Local i := GetProperty( "VentanaMain" , "GHlpFiles" , "value" )
   Local cAux := GetProperty( "VentanaMain" , "GHlpFiles" , "item" , i )
   Local cAux2 := GetProperty( "VentanaMain" , "GHlpFiles" , "item" , i - 1 )
   if i = 3
      MsgInfo( "Global foot and Welcome Topic can't be moved, they're system Topics !!!" )
   endif
   if i > 3
      bHlpMoving := .T.
      SHG_SetField( "SHG_ORDER" , i - 1 , 0 )
      SHG_SetField( "SHG_ORDER" , i , i - 1 )
      SHG_SetField( "SHG_ORDER" , 0 , i )
      SetProperty( "VentanaMain" , "GHlpFiles" , "item" , i , cAux2 )
      SetProperty( "VentanaMain" , "GHlpFiles" , "item" , i - 1 , cAux )
      SetProperty( "VentanaMain" , "GHlpFiles" , "value" , i - 1 )
      DoMethod( "VentanaMain" , "GHlpFiles" , "setfocus" )
      bHlpMoving := .F.
   endif
Return .T.
#endif

#ifdef QPM_SHG
Function DownHlp()
   Local i := GetProperty( "VentanaMain" , "GHlpFiles" , "value" )
   Local cAux := GetProperty( "VentanaMain" , "GHlpFiles" , "item" , i )
   Local cAux2 := GetProperty( "VentanaMain" , "GHlpFiles" , "item" , i + 1 )
   if i = 1
      MsgInfo( "Global foot can't be moved, it's a system Topic !!!" )
   endif
   if i = 2
      MsgInfo( "Welcome page can't be moved, it's a system Topic !!!" )
   endif
   if i < GetProperty( "VentanaMain" , "GHlpFiles" , "itemcount" ) .and. i > 2
      bHlpMoving := .T.
      SHG_SetField( "SHG_ORDER" , i + 1 , 0 )
      SHG_SetField( "SHG_ORDER" , i , i + 1 )
      SHG_SetField( "SHG_ORDER" , 0 , i )
      SetProperty( "VentanaMain" , "GHlpFiles" , "item" , i , cAux2 )
      SetProperty( "VentanaMain" , "GHlpFiles" , "item" , i + 1 , cAux )
      SetProperty( "VentanaMain" , "GHlpFiles" , "value" , i + 1 )
      DoMethod( "VentanaMain" , "GHlpFiles" , "setfocus" )
      bHlpMoving := .F.
   endif
Return .T.
#endif

Function ToolTipPrgList()
   if GetProperty( "VentanaMain" , "GPrgFiles" , "value" ) = 0
      SetProperty( "VentanaMain" , "GPrgFiles" , "tooltip" , "" )
   else
      SetProperty( "VentanaMain" , "GPrgFiles" , "tooltip" , GetProperty( "VentanaMain" , "GPrgFiles" , "item" , GetProperty( "VentanaMain" , "GPrgFiles" , "value" ) ) )
   endif
Return .t.

Function ToolTipHEAList()
   if GetProperty( "VentanaMain" , "GHeaFiles" , "value" ) = 0
      SetProperty( "VentanaMain" , "GHeaFiles" , "tooltip" , "" )
   else
      SetProperty( "VentanaMain" , "GHeaFiles" , "tooltip" , GetProperty( "VentanaMain" , "GHeaFiles" , "item" , GetProperty( "VentanaMain" , "GHeaFiles" , "value" ) ) )
   endif
Return .t.

Function ToolTipPANList()
   if GetProperty( "VentanaMain" , "GPanFiles" , "value" ) = 0
      SetProperty( "VentanaMain" , "GPanFiles" , "tooltip" , "" )
   else
      SetProperty( "VentanaMain" , "GPanFiles" , "tooltip" , GetProperty( "VentanaMain" , "GPanFiles" , "item" , GetProperty( "VentanaMain" , "GPanFiles" , "value" ) ) )
   endif
Return .t.

Function ToolTipDbfList()
   if GetProperty( "VentanaMain" , "GDbfFiles" , "value" ) = 0
      SetProperty( "VentanaMain" , "GDbfFiles" , "tooltip" , "" )
   else
      SetProperty( "VentanaMain" , "GDbfFiles" , "tooltip" , GetProperty( "VentanaMain" , "GDbfFiles" , "item" , GetProperty( "VentanaMain" , "GDbfFiles" , "value" ) ) )
   endif
Return .t.

Function ToolTipHlpList()
   if GetProperty( "VentanaMain" , "GHlpFiles" , "value" ) = 0
      SetProperty( "VentanaMain" , "GHlpFiles" , "tooltip" , "" )
   else
      SetProperty( "VentanaMain" , "GHlpFiles" , "tooltip" , GetProperty( "VentanaMain" , "GHlpFiles" , "item" , GetProperty( "VentanaMain" , "GHlpFiles" , "value" ) ) )
   endif
Return .t.

Function EraseOBJ()
   Local i , dire
   Local TopName := US_FileNameOnlyName( GetOutputModuleName() )
   if !empty( PUB_cProjectFolder )
      dire := PUB_cProjectFolder + DEF_SLASH + GetObjName()
      US_DirRemove( dire )
      DELETE FILE ( PUB_cProjectFolder + DEF_SLASH + TopName +'.'+OutputExt() )
      DELETE FILE ( PUB_cProjectFolder + DEF_SLASH + US_FileNameOnlyName(GetProperty( "VentanaMain" , "GPrgFiles" , "Cell" , 1 , NCOLPRGNAME )) +'.RES' )
      DELETE FILE ( PUB_cProjectFolder + DEF_SLASH + TopName +'.TDS' )
      DELETE FILE ( PUB_cProjectFolder + DEF_SLASH + "_Temp.RC" )
   endif
   if PUB_bLite
      VentanaLite.LFull.FontColor := DEF_COLORRED
      VentanaLite.LFull.Value := "Force Non Incremental"
   else
      VentanaMain.LFull.FontColor := DEF_COLORRED
      VentanaMain.LFull.Value := "Force Non Incremental"
   endif
   QPM_SetResumen()
   vSinLoadWindow := {}
   vSinInclude    := {}
   vXRefPrgHea    := {}
   vXRefPrgFmg    := {}
   if bLogActivity
      QPM_MemoWrit( PUB_cQPM_Folder+DEF_SLASH + "QPM.log" , memoread( PUB_cQPM_Folder+DEF_SLASH + "QPM.log" ) + HB_OSNewLine() + "xRefPrgFmg CleanUp of vSinLoadWindow by EraseObj" )
      QPM_MemoWrit( PUB_cQPM_Folder+DEF_SLASH + "QPM.log" , memoread( PUB_cQPM_Folder+DEF_SLASH + "QPM.log" ) + HB_OSNewLine() + "xRefPrgHea CleanUp of vSinInclude by EraseObj" )
      QPM_MemoWrit( PUB_cQPM_Folder+DEF_SLASH + "QPM.log" , memoread( PUB_cQPM_Folder+DEF_SLASH + "QPM.log" ) + HB_OSNewLine() + "xRefPrgHea CleanUp of vXRefPrgHea by EraseObj" )
      QPM_MemoWrit( PUB_cQPM_Folder+DEF_SLASH + "QPM.log" , memoread( PUB_cQPM_Folder+DEF_SLASH + "QPM.log" ) + HB_OSNewLine() + "xRefPrgFmg CleanUp of vXRefPrgFmg by EraseObj" )
   endif
   RichEditDisplay("OUT")
Return .T.

Function EraseALL()
   Local i , dire , arc
   if bWaitForBuild
      do while !bBuildFinished
         DO EVENTS
      enddo
   endif
   if !empty( PUB_cProjectFolder )
      For i:=1 to len( vSuffix )
         dire := PUB_cProjectFolder + DEF_SLASH + GetObjPrefix() + vSuffix[i][1]
         US_DirRemove( dire )
      Next i
      if PUB_bLite
         VentanaLite.LFull.FontColor := DEF_COLORRED
         VentanaLite.LFull.Value := "Force Non Incremental"
      else
         VentanaMain.LFull.FontColor := DEF_COLORRED
         VentanaMain.LFull.Value := "Force Non Incremental"
      endif
      QPM_SetResumen()
      vSinLoadWindow := {}
      vSinInclude    := {}
      vXRefPrgHea    := {}
      vXRefPrgFmg    := {}
      if bLogActivity
         QPM_MemoWrit( PUB_cQPM_Folder+DEF_SLASH + "QPM.log" , memoread( PUB_cQPM_Folder+DEF_SLASH + "QPM.log" ) + HB_OSNewLine() + "xRefPrgFmg CleanUp of vSinLoadWindow by EraseALL" )
         QPM_MemoWrit( PUB_cQPM_Folder+DEF_SLASH + "QPM.log" , memoread( PUB_cQPM_Folder+DEF_SLASH + "QPM.log" ) + HB_OSNewLine() + "xRefPrgHea CleanUp of vSinInclude by EraseALL" )
         QPM_MemoWrit( PUB_cQPM_Folder+DEF_SLASH + "QPM.log" , memoread( PUB_cQPM_Folder+DEF_SLASH + "QPM.log" ) + HB_OSNewLine() + "xRefPrgHea CleanUp of vXRefPrgHea by EraseALL" )
         QPM_MemoWrit( PUB_cQPM_Folder+DEF_SLASH + "QPM.log" , memoread( PUB_cQPM_Folder+DEF_SLASH + "QPM.log" ) + HB_OSNewLine() + "xRefPrgFmg CleanUp of vXRefPrgFmg by EraseALL" )
      endif
   endif
Return .T.

Function BuildStop()
   QPM_MemoWrit( PUB_cProjectFolder + DEF_SLASH + "_" + PUB_cSecu + "MSG.SYSIN" , "STOP " )
   if PUB_bLite
      VentanaLite.bStop.Enabled := .F.
   else
      VentanaMain.bStop.Enabled := .F.
   endif
   VentanaMain.TabFiles.Value := nPageSysout
   TabChange( "FILES" )
   do while file( PUB_cProjectFolder + DEF_SLASH + "_" + PUB_cSecu + "MSG.SYSIN" )
      US_Wait( 2 )
      DO EVENTS
   enddo
Return

Function TabAutoSync( tab )
   Local bSync := GetProperty( "VentanaMain" , "Check_AutoSync"+tab , "Value" )
   bAutoSyncTab := bSync
   if !PUB_RunTabAutoSync
      Return .T.
   else
      PUB_RunTabAutoSync := .F.
   endif
   if !( tab == "PRG" )
      VentanaMain.Check_AutoSyncPrg.Value := bSync
   endif
   if !( tab == "HEA" )
      VentanaMain.Check_AutoSyncHea.Value := bSync
   endif
   if !( tab == "PAN" )
      VentanaMain.Check_AutoSyncPan.Value := bSync
   endif
   if !( tab == "DBF" )
      VentanaMain.Check_AutoSyncDbf.Value := bSync
   endif
   if !( tab == "LIB" )
      VentanaMain.Check_AutoSyncLib.Value := bSync
   endif
   if !( tab == "HLP" )
      VentanaMain.Check_AutoSyncHlp.Value := bSync
   endif
// if !( tab == "SYSOUT" )
//    VentanaMain.Check_AutoSyncSysout.Value := bSync
// endif
// if !( tab == "OUT" )
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
      if cTabGroups == "GRIDS" .and. ;
         GetProperty( "VentanaMain" , "TabGrids" , "value" ) > 1 .and. ;
         GetProperty( "VentanaMain" , "TabGrids" , "value" ) < 6
         PUB_RunTabChange := .F.
         SetProperty( "VentanaMain" , "TabGrids" , "value" , 1 )
      endif
      if cTabGroups == "FILES" .and. ;
         GetProperty( "VentanaMain" , "TabFiles" , "value" ) > 1 .and. ;
         GetProperty( "VentanaMain" , "TabFiles" , "value" ) < 6
         PUB_RunTabChange := .F.
         SetProperty( "VentanaMain" , "TabFiles" , "value" , 1 )
      endif
   endif

   if bAutoSyncTab
      if cTabGroups == "FILES"
         PUB_RunTabChange := .F.
         SetProperty ( "VentanaMain" , "TabGrids" , "Value" , VentanaMain.TabFiles.Value )
      else
         if VentanaMain.TabFiles.Value < nPageSysout
            PUB_RunTabChange := .F.
            SetProperty( "VentanaMain" , "TabFiles" , "Value" , VentanaMain.TabGrids.Value )
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
#ifndef QPM_SHG
   Private nPageHlp := 10000   // Cuanquier valor
#endif
   if VentanaMain.TabFiles.Value == nPageHlp
      VentanaMain.ItC_Cut.Enabled       := .T.
      VentanaMain.ItC_Paste.Enabled     := .T.
      VentanaMain.ItC_CutM.Enabled      := .T.
      VentanaMain.ItC_PasteM.Enabled    := .T.
   else
      VentanaMain.ItC_Cut.Enabled       := .F.
      VentanaMain.ItC_Paste.Enabled     := .F.
      VentanaMain.ItC_CutM.Enabled      := .F.
      VentanaMain.ItC_PasteM.Enabled    := .F.
   endif
   if !PUB_bIsProcessing
      if VentanaMain.TabGrids.Value == nPageHlp
         SetProperty( "VentanaMain" , "save"  , "enabled" , .F. )
         SetProperty( "VentanaMain" , "build" , "enabled" , .F. )
         SetProperty( "VentanaMain" , "EraseALL" , "enabled" , .F. )
         SetProperty( "VentanaMain" , "EraseOBJ" , "enabled" , .F. )
         SetProperty( "VentanaMain" , "BVerChange" , "enabled" , .F. )
#ifdef QPM_SYNCRECOVERY
         SetProperty( "VentanaMain" , "BTakeSyncRecovery" , "enabled" , .F. )
#endif
      else
         SetProperty( "VentanaMain" , "save"  , "enabled" , .T. )
         SetProperty( "VentanaMain" , "build" , "enabled" , .T. )
         SetProperty( "VentanaMain" , "EraseALL" , "enabled" , .T. )
         SetProperty( "VentanaMain" , "EraseOBJ" , "enabled" , .T. )
         SetProperty( "VentanaMain" , "BVerChange" , "enabled" , .T. )
#ifdef QPM_SYNCRECOVERY
         if VentanaMain.TabGrids.Value <= nPagePan
            SetProperty( "VentanaMain" , "BTakeSyncRecovery" , "enabled" , .T. )
         else
            SetProperty( "VentanaMain" , "BTakeSyncRecovery" , "enabled" , .F. )
         endif
#endif
      endif
   endif
#ifdef QPM_SHG
   OcultaHlpKeys()
#endif
   // este parche es hasta que se resuelva el problema de la barra de desplazamiento en el browse dentro de un page of tab
   if VentanaMain.TabFiles.Value == nPageDbf
      if _IsControlDefined( "DbfBrowse" , "VentanaMain" )
         SetProperty( "VentanaMain" , "DbfBrowse" , "visible" , .T. )
      endif
   else
      if _IsControlDefined( "DbfBrowse" , "VentanaMain" )
         SetProperty( "VentanaMain" , "DbfBrowse" , "visible" , .F. )
      endif
   endif
   // Fin parche
   do case
      case VentanaMain.TabGrids.Value == nPagePRG
         GBL_TabGridNameFocus := "PRG"
      case VentanaMain.TabGrids.Value == nPageHEA
         GBL_TabGridNameFocus := "HEA"
      case VentanaMain.TabGrids.Value == nPagePAN
         GBL_TabGridNameFocus := "PAN"
      case VentanaMain.TabGrids.Value == nPageDBF
         GBL_TabGridNameFocus := "DBF"
      case VentanaMain.TabGrids.Value == nPageLIB
         GBL_TabGridNameFocus := "LIB"
      case VentanaMain.TabGrids.Value == nPageHLP
         GBL_TabGridNameFocus := "HLP"

         if VentanaMain.GHlpFiles.ItemCount > 0
            VentanaMain.GHlpFiles.SetFocus
            w_antes := GetProperty( "VentanaMain" , "GHlpFiles" , "Value" )
            SetProperty( "VentanaMain" , "GHlpFiles" , "Value" , 0 )
            SetProperty( "VentanaMain" , "GHlpFiles" , "Value" , w_antes )
         endif
      otherwise
         GBL_TabGridNameFocus := "OTHER"
   endcase
Return .T.

Function TotCaption( cType , nValor )
   Local nPage := 0 , cAux := "" , nAux := 0
   do case
      case cType == "PRG"
         nPage := nPagePrg
      case cType == "HEA"
         nPage := nPageHea
      case cType == "PAN"
         nPage := nPagePan
      case cType == "DBF"
         nPage := nPageDbf
      case cType == "LIB"
         nPage := nPageLib
#ifdef QPM_SHG
      case cType == "HLP"
         nPage := nPageHlp
#endif
   endcase
   if !( nValor == 0 )
      if at( "(" , VentanaMain.TabGrids.Caption( nPage ) ) > 0
         cAux := us_word( strtran( strtran( VentanaMain.TabGrids.Caption( nPage ) , "(" , "" ) , ")" , "" ) , us_Words( VentanaMain.TabGrids.Caption( nPage ) ) )
      endif
      if !empty( cAux )
         nAux := val( cAux )
      endif
      nAux := nAux + nValor
   endif
   if nAux > 0
      VentanaMain.TabGrids.Caption( nPage ) := &("Page"+cType) + " (" + alltrim( str( nAux ) ) + ")"
   else
      VentanaMain.TabGrids.Caption( nPage ) := &("Page"+cType)
   endif
Return

Function PpoDisplay( bOnlyRenumering )
   Local ppoFile , nRow
   Local cLineCmd
   if empty( bOnlyRenumering )
      bOnlyRenumering := .F.
   endif
   if bPpoDisplayado .and. !bOnlyRenumering
      QPM_EditPPO()
   else
      if nRow == 0 .or. GetProperty( "VentanaMain" , "GPrgFiles" , "Itemcount" ) == 0
         VentanaMain.RichEditPrg.Value := ""
      else
         nRow := GetProperty( "VentanaMain" , "GPrgFiles" , "value" )
         if Upper( US_FileNameOnlyExt( GetProperty( "VentanaMain" , "GPrgFiles" , "Cell" , nRow , NCOLPRGNAME ) ) ) == "PRG"
            ppoFile := PUB_cProjectFolder + DEF_SLASH + GetObjName() + DEF_SLASH + Us_FileNameOnlyName( GetProperty( "VentanaMain" , "GPrgFiles" , "Cell" , nRow , NCOLPRGNAME ) ) + ".ppo"
            if file( ppoFile )
               if val( US_FileDateTime( ppoFile ) ) < val( US_FileDateTime( ChgPathToReal( GetProperty( "VentanaMain" , "GPrgFiles" , "Cell" , nRow , NCOLPRGFULLNAME ) ) ) )
                  MsgInfo( "Warning, date of prg file is more recent than date of creation of ppo file" + HB_OsNewLine() + "ReBuild the project after press Non-Incremental Button or after save prg file" )
               endif
               cPpoCaretPrg := alltrim( str( VentanaMain.RichEditPRG.CaretPos ) )
               VentanaMain.RichEditPrg.FontColor := DEF_COLORFONTPPO
               VentanaMain.RichEditPrg.BackColor := DEF_COLORBACKPPO
               VentanaMain.RichEditPRG.Value := Enumeracion( MemoRead( ppoFile ) , "PRG" )
               VentanaMain.RichEditPRG.CaretPos := 1
               VentanaMain.bReLoadPpo.caption := "Edit PPO"
               bPpoDisplayado := .T.
            else
               MsgInfo( "PreProcess file not found, ReBuild the project after press Non-Incremental Button or after save prg file" )
            endif
         else
            MsgInfo( "PreProcess Files is only for PRG files" )
         endif
      endif
   endif
Return .t.

Function RichEditDisplay( tipo , bReload , nRow , bForce )
   Local DbfName := ""
   Local IncName := ""
// Local EXCName := ""
   Local i , nCont := 0
   Local aStru := {} , x , DbfCode := 0
   Local ListOut := "" , cType := "" , AuxRegistro
   Local nInx , MemoKeys , LinesKeys
   if empty( nRow ) .and. !( tipo == "OUT" )
      nRow := GetProperty( "VentanaMain" , "G"+tipo+"Files" , "Value" )
   endif
   if nRow == NIL
      nRow := 0
   endif

   DbfName := ChgPathToReal( GetProperty( "VentanaMain" , "GDbfFiles" , "Cell" , nRow , NCOLDBFFULLNAME ) )
   IncName := ChgPathToReal( US_WordSubStr( GetProperty( "VentanaMain" , "GIncFiles" , "Cell" , nRow , NCOLINCFULLNAME ) , 3 ) )
// EXCName := ChgPathToReal( US_WordSubstr( GetProperty( "VentanaMain" , "GExcFiles" , "Cell" , nRow , NCOLEXCNAME ) , 3 ) )
   DEFAULT bReload TO .F.
   DEFAULT bForce  TO .F.
   do case
      case tipo == "PRG"
         if nRow == 0
            VentanaMain.RichEditPrg.Value := ""
            Return .F.
         endif
         if bReload .and. bGlobalSearch
            SetProperty( "VentanaMain" , "GPrgFiles" , "Cell" , nRow , NCOLPRGOFFSET , "0" )
            if GridImage( "VentanaMain" , "GPrgFiles" , nRow , NCOLPRGSTATUS , "?" , PUB_nGridImgSearchOk )
               TotCaption( tipo , -1 )
            endif
            if GlobalSearch2( tipo , cLastGlobalSearch , nRow , bLastGlobalSearchFun , bLastGlobalSearchDbf )
               TotCaption( tipo , +1 )
            endif
         else
            if nGridPrgLastRow > 0
               LostRichEdit( "PRG" )
            endif
            nGridPrgLastRow := nRow
         endif
         if GridImage( "VentanaMain" , "GPrgFiles" , nRow , NCOLPRGSTATUS , "?" , PUB_nGridImgEdited )
            VentanaMain.RichEditPrg.BackColor := DEF_COLORBACKEXTERNALEDIT
            VentanaMain.RichEditPrg.FontColor := DEF_COLORFONTEXTERNALEDIT
         else
            VentanaMain.RichEditPrg.BackColor := DEF_COLORBACKPRG
            VentanaMain.RichEditPrg.FontColor := DEF_COLORFONTVIEW
         endif
         if Prj_Radio_OutputType == DEF_RG_IMPORT
            VentanaMain.RichEditPRG.Value := QPM_Wait( "ListModule( '" + ChgPathToReal( GetProperty( "VentanaMain" , "GPrgFiles" , "Cell" , 1 , NCOLPRGFULLNAME ) ) + "' )" , "Listing..." , , .T. )
            VentanaMain.RichEditPRG.CaretPos := 1
         else
            bPpoDisplayado := .F.
            VentanaMain.RichEditPRG.Value := Enumeracion( MemoRead( ChgPathToReal( GetProperty( "VentanaMain" , "GPrgFiles" , "Cell" , nRow , NCOLPRGFULLNAME ) ) ) , tipo )
            VentanaMain.RichEditPRG.CaretPos := val( GetProperty( "VentanaMain" , "GPrgFiles" , "Cell" , nRow , NCOLPRGOFFSET ) )
            VentanaMain.bReLoadPpo.caption := "Browse PPO"
         endif
      case tipo == "HEA"
         if nRow == 0
            VentanaMain.RichEditHea.Value := ""
            Return .F.
         endif
         if bReload .and. bGlobalSearch
            SetProperty( "VentanaMain" , "GHeaFiles" , "Cell" , nRow , NCOLHEAOFFSET , "0" )
        //  if !empty( cLastGlobalSearch )
        //  GridImage( "VentanaMain" , "GHeaFiles" , nRow , NCOLHEASTATUS , "-" , PUB_nGridImgEdited )
            if GridImage( "VentanaMain" , "GHeaFiles" , nRow , NCOLHEASTATUS , "?" , PUB_nGridImgSearchOk )
               TotCaption( tipo , -1 )
            endif
            if GlobalSearch2( tipo , cLastGlobalSearch , nRow , bLastGlobalSearchFun , bLastGlobalSearchDbf )
               TotCaption( tipo , +1 )
            endif
        //  endif
         else
            if nGridHeaLastRow > 0
               LostRichEdit( "HEA" )
            endif
            nGridHeaLastRow := nRow
         endif
         if GridImage( "VentanaMain" , "GHeaFiles" , nRow , NCOLHEASTATUS , "?" , PUB_nGridImgEdited )
            VentanaMain.RichEditHea.BackColor := DEF_COLORBACKEXTERNALEDIT
            VentanaMain.RichEditHea.FontColor := DEF_COLORFONTEXTERNALEDIT
         else
            VentanaMain.RichEditHea.BackColor := DEF_COLORBACKHEA
            VentanaMain.RichEditHea.FontColor := DEF_COLORFONTVIEW
         endif
         VentanaMain.RichEditHea.Value := Enumeracion( MemoRead( ChgPathToReal( GetProperty( "VentanaMain" , "GHeaFiles" , "Cell" , nRow , NCOLHEAFULLNAME ) ) ) , tipo )
         VentanaMain.RichEditHea.CaretPos := val( GetProperty( "VentanaMain" , "GHeaFiles" , "Cell" , nRow , NCOLHEAOFFSET ) )
      case tipo == "PAN"
         if nRow == 0
            VentanaMain.RichEditPan.Value := ""
            Return .F.
         endif
         if bReload .and. bGlobalSearch
            SetProperty( "VentanaMain" , "GPanFiles" , "Cell" , nRow , NCOLPANOFFSET , "0" )
            if GridImage( "VentanaMain" , "GPanFiles" , nRow , NCOLPANSTATUS , "?" , PUB_nGridImgSearchOk )
               TotCaption( tipo , -1 )
            endif
            if GlobalSearch2( tipo , cLastGlobalSearch , nRow , bLastGlobalSearchFun , bLastGlobalSearchDbf )
               TotCaption( tipo , +1 )
            endif
         else
            if nGridPanLastRow > 0
               LostRichEdit( "PAN" )
            endif
            nGridPanLastRow := nRow
         endif
         if GridImage( "VentanaMain" , "GPanFiles" , nRow , NCOLPANSTATUS , "?" , PUB_nGridImgEdited )
            VentanaMain.RichEditPan.BackColor := DEF_COLORBACKEXTERNALEDIT
            VentanaMain.RichEditPan.FontColor := DEF_COLORFONTEXTERNALEDIT
         else
            VentanaMain.RichEditPan.BackColor := DEF_COLORBACKPAN
            VentanaMain.RichEditPan.FontColor := DEF_COLORFONTVIEW
         endif
         VentanaMain.RichEditPan.Value := Enumeracion( MemoRead( ChgPathToReal( GetProperty( "VentanaMain" , "GPanFiles" , "Cell" , nRow , NCOLPANFULLNAME ) ) ) , tipo )
         VentanaMain.RichEditPan.CaretPos := val( GetProperty( "VentanaMain" , "GPanFiles" , "Cell" , nRow , NCOLPANOFFSET ) )
      case tipo == "DBF"
         if nRow == 0
            VentanaMain.RichEditDbf.Value := ""
         // DefineRichEditForNotDbfView( "DBF view is disable while Run Appl !!!" )
            Return .F.
         endif

         if _IsControlDefined( "DbfBrowse" , "VentanaMain" )
            AuxRegistro := VentanaMain.DbfBrowse.Value
         else
            AuxRegistro := 1
         endif
         CloseDbfAutoView()
         if bGlobalSearch .and. bLastGlobalSearchDbf .and. bAvisoDbfGlobalSearchLow
            MsgInfo( "Last Global Search with 'Dbf Data' set true causes a very slow reload" + HB_OsNewLine() + "Use Reset Button for disable this option" )
            bAvisoDbfGlobalSearchLow := .F.
         endif
         if bReload .and. bGlobalSearch
            //GetProperty( "VentanaMain" , "GDbfFiles" , "Cell" , nRow , NCOLDBFOFFSET ) := "0 0"
            if GridImage( "VentanaMain" , "GDbfFiles" , nRow , NCOLDBFSTATUS , "?" , PUB_nGridImgSearchOk )
               TotCaption( tipo , -1 )
            endif
            if GlobalSearch2( tipo , cLastGlobalSearch , nRow , bLastGlobalSearchFun , bLastGlobalSearchDbf )
               TotCaption( tipo , +1 )
            endif
         else
            if nGridDbfLastRow > 0
               LostRichEdit( "DBF" , AuxRegistro )
            endif
            nGridDbfLastRow := nRow
         endif
         if bReload
            bAvisoDbfDataSearchLow := .T.
            bDbfDataSearchAsk     := .T.
            cDbfDataSearchAskRpta := ""
         endif

         if GridImage( "VentanaMain" , "GDbfFiles" , nRow , NCOLDBFSTATUS , "?" , PUB_nGridImgEdited )
            VentanaMain.RichEditDbf.BackColor := DEF_COLORBACKEXTERNALEDIT
            VentanaMain.RichEditDbf.FontColor := DEF_COLORFONTEXTERNALEDIT
         else
            VentanaMain.RichEditDbf.BackColor := DEF_COLORBACKDBF
            VentanaMain.RichEditDbf.FontColor := DEF_COLORFONTVIEW
         endif

         DbfCode := US_IsDBF( DbfName )
         If !( DbfCode == 0 )
            if DbfCode = 21   && open exclusive by another program
               VentanaMain.RichEditDbf.Value := HB_OsNewLine() + ;
                                                HB_OsNewLine() + ;
                                                HB_OsNewLine() + ;
                                                HB_OsNewLine() + ;
                                                HB_OsNewLine() + ;
                                                HB_OsNewLine() + ;
                                                "     Database '"+DbfName+"' is open EXCLUSIVE for another process .or. DBT file is missing"
            else
               VentanaMain.RichEditDbf.Value := HB_OsNewLine() + ;
                                                HB_OsNewLine() + ;
                                                HB_OsNewLine() + ;
                                                HB_OsNewLine() + ;
                                                HB_OsNewLine() + ;
                                                HB_OsNewLine() + ;
                                                "     Database '"+DbfName+"' is not valid DBF"
            endif
            DefineRichEditForNotDbfView( "DBF Not Open !!!" )
         else
            VentanaMain.RichEditDbf.Value := HB_OsNewLine() + ;
                                             "Structure for Database: "+DbfName + HB_osNewLine() + HB_OsNewLine() + ;
                                             replicate( " " , 22 ) + padr( "Field" , 15 )     + padr( "Type"      , 4 ) + padl( "Length"    , 8 )+ padl( "Decimal"  , 8 ) + HB_osNewLine() + ;
                                             replicate( " " , 22 ) + replicate( "=" , 35 )

            US_Use( .T. , , DbfName , "DbfAlias" , DEF_DBF_SHARED , DEF_DBF_READ ) /* si lo pongo exclusive y write no funciona el search, revisarlo */
            aStru:=DBSTRUCT()
            vDbfJustify := {}
            vDbfHeaders := {}
            vDbfWidths  := {}
            FOR x:=1 TO LEN(aStru)
               aadd( vDbfJustify , if( aStru[x][2] == "N" , BROWSE_JTFY_RIGHT , BROWSE_JTFY_LEFT ) )
               aadd( vDbfHeaders , aStru[x][1] )
               aadd( vDbfWidths , if( aStru[x][3] > 20 , 330 , 90 ) )
               VentanaMain.RichEditDbf.Value := VentanaMain.RichEditDbf.Value + HB_OsNewLine() + ;
                                                replicate( " " , 22 ) + padr( aStru[x][1] , 15 ) + padr( aStru[x][2] , 4 ) + padl( aStru[x][3] , 8 )+ padl( aStru[x][4] , 8 )
            NEXT

            if ( bDbfAutoView .and. !bRunApp ) .or. bForce

               if _IsControlDefined( "DbfAutoView" , "VentanaMain" )
                  VentanaMain.DbfAutoView.Release()
               endif

               SET BROWSESYNC ON

               @ GetDesktopRealHeight() - int( ( GetDesktopRealHeight() * 72 ) / 100 ) , 10 BROWSE DbfBrowse ;
                  OF VentanaMain ;
                  WIDTH 0 ;
                  HEIGHT 0 ;
                  HEADERS ( vDbfHeaders ) ;
                  WIDTHS ( vDbfWidths ) ;
                  WORKAREA DbfAlias ;
                  FIELDS ( vDbfHeaders ) ;
                  VALUE RECNO() ;
                  FONT "CourierNew" SIZE 9 ;
                  BACKCOLOR DEF_COLORBACKDBF
                //NOVSCROLL
            //    ON CHANGE ( GetProperty( "VentanaMain" , "GDbfFiles" , "Cell" , VentanaMain.GDbfFiles.Value , NCOLDBFSEARCH ) := "0 ** 0" )
            //    EDIT INPLACE
            //    ON HEADCLICK  { || us_log("headclick") } ;
            //    ON CHANGE  { || TBL_BrowseRefresh() } ;
            //    ON DBLCLICK  { || TBL_EjecutoDefault() }

               VentanaMain.TabFiles.AddControl( "DbfBrowse" , nPageDbf , GetDesktopRealHeight() - int( ( GetDesktopRealHeight() * 72 ) / 100 ) , 10 )
               VentanaMain.DbfBrowse.DisableUpdate()
               VentanaMain.DbfBrowse.Width  := GetDesktopRealWidth() - 364
               VentanaMain.DbfBrowse.Height := ( GetDesktopRealHeight() - 237 ) - ( GetDesktopRealHeight() - int( ( GetDesktopRealHeight() * 72 ) / 100 ) )
               VentanaMain.DbfBrowse.value  := val( US_Word( GetProperty( "VentanaMain" , "GDbfFiles" , "Cell" , nRow , NCOLDBFOFFSET ) , 2 ) )
               VentanaMain.DbfBrowse.EnableUpdate()
               VentanaMain.DbfBrowse.Refresh()
            else
               CloseDbfAutoView()
               if bRunApp
                  DefineRichEditForNotDbfView( "DBF view is disable while Run Appl !!!" )
               else
                  DefineRichEditForNotDbfView( "DBF AutoView is OFF !!!" )
               endif
            endif
         endif
         VentanaMain.BLocalSearchDbf.caption := "Dbf Search"
         VentanaMain.BLocalSearchDbf.Tooltip := "Search text in Dbf Data"
         VentanaMain.RichEditDbf.CaretPos := val( US_Word( GetProperty( "VentanaMain" , "GDbfFiles" , "Cell" , nRow , NCOLDBFOFFSET ) , 1 ) )
      case tipo == "INC"
         if nRow == 0
            VentanaMain.RichEditLib.Value := ""
            Return .F.
         endif
       //VentanaMain.RichEditLib.Value := ListModule( IncName )
         if !file( IncName )
            VentanaMain.RichEditLib.Value := HB_OsNewLine() + ;
                                             HB_OsNewLine() + ;
                                             HB_OsNewLine() + ;
                                             HB_OsNewLine() + ;
                                             HB_OsNewLine() + ;
                                             HB_OsNewLine() + ;
                                             "     Library '"+IncName+"' not found !!!"
         else
            do case
               case US_upper( US_FileNameOnlyExt( IncName ) ) == "LIB"
                  cType := QPM_ModuleType( IncName ) + " Library"
               case US_upper( US_FileNameOnlyExt( IncName ) ) == "A"
                  cType := QPM_ModuleType( IncName ) + " Library"
               case US_upper( US_FileNameOnlyExt( IncName ) ) == "OBJ"
                  cType := QPM_ModuleType( IncName ) + " Object"
               case US_upper( US_FileNameOnlyExt( IncName ) ) == "O"
                  cType := QPM_ModuleType( IncName ) + " Object"
               otherwise
                  US_Log( "Invalid Library extention" )
            endcase
            VentanaMain.RichEditLib.Value := HB_OsNewLine() + ;
                                             HB_OsNewLine() + ;
                                             HB_OsNewLine() + ;
                                             HB_OsNewLine() + ;
                                             HB_OsNewLine() + ;
                                             HB_OsNewLine() + ;
                                             "     Library '" + IncName + "'" + HB_OsNewLine() + ;
                                             "             Size: " + alltrim( Str( US_FileSize( IncName ) ) ) + HB_OsNewLine() + ;
                                             "             Type: " + cType + HB_OsNewLine() + ;
                                             HB_OsNewLine() + ;
                                             "             Press 'List Library/Object' button for view function in library or Object"
         endif
   // case tipo == "EXC"
   //    if nRow == 0
   //       VentanaMain.RichEditLib.Value := ""
   //       Return .F.
   //    endif
   //    VentanaMain.RichEditLib.Value := Enumeracion( MemoRead( ChgPathToReal( GetProperty( "VentanaMain" , "GExcFiles" , "Cell" , nRow , NCOLEXCNAME ) ) ) , tipo )
      case tipo == "OUT"
         ListOut := GetOutputModuleName()
         if !file( ListOut )
            if file( ListOut+'.MOVED.TXT' )
               ListOut := US_WordSubStr( MemoRead( ListOut+'.MOVED.TXT' ) , 7 )
            else
               VentanaMain.RichEditOut.Value := HB_OsNewLine() + ;
                                                HB_OsNewLine() + ;
                                                HB_OsNewLine() + ;
                                                HB_OsNewLine() + ;
                                                HB_OsNewLine() + ;
                                                HB_OsNewLine() + ;
                                                "     Output Module File not Found: '"+ListOut+"' !!!"
               ListOut := ""
            endif
         endif
         if !empty( ListOut )
            do case
               case US_upper( US_FileNameOnlyExt( ListOut ) ) == "LIB"
                  cType := QPM_ModuleType( ListOut ) + " Library"
               case US_upper( US_FileNameOnlyExt( ListOut ) ) == "A"
                  cType := QPM_ModuleType( ListOut ) + " Library"
               case US_upper( US_FileNameOnlyExt( ListOut ) ) == "EXE"
               // cType := "Executable " + QPM_ModuleType( GetOutPutModuleName() )
                  cType := "Executable " + QPM_ModuleType( ListOut )
               case US_upper( US_FileNameOnlyExt( ListOut ) ) == "DLL"
                  cType := "Dynamic Link Library"
               otherwise
                  MsgInfo( "Error en Type for List Output" )
            endcase
            VentanaMain.RichEditOut.Value := HB_OsNewLine() + ;
                                             HB_OsNewLine() + ;
                                             HB_OsNewLine() + ;
                                             HB_OsNewLine() + ;
                                             HB_OsNewLine() + ;
                                             HB_OsNewLine() + ;
                                             "        File '" + ListOut + "'" + HB_OsNewLine() + ;
                                             "             Size: " + alltrim( Str( US_FileSize( ListOut ) ) ) + HB_OsNewLine() + ;
                                             "             Type: " + cType + HB_OsNewLine() + ;
                                             HB_OsNewLine() + ;
                                             "             Press 'List' button for expand this module info"
         endif
#ifdef QPM_SHG
      case tipo == "HLP"
         if nRow == 0
            VentanaMain.RichEditHlp.Value := ""
            oHlpRichEdit:lChanged := .F.
            Return .F.
         endif
         if bReload .and. bGlobalSearch
            SetProperty( "VentanaMain" , "GHlpFiles" , "Cell" , nRow , NCOLHLPOFFSET , "0" )
            if GridImage( "VentanaMain" , "GHlpFiles" , nRow , NCOLHLPSTATUS , "?" , PUB_nGridImgSearchOk )
               TotCaption( tipo , -1 )
            endif
            if GlobalSearch2( tipo , cLastGlobalSearch , nRow , bLastGlobalSearchFun , bLastGlobalSearchDbf )
               TotCaption( tipo , +1 )
            endif
         else
            if nGridHlpLastRow > 0
               if !bHlpMoving
                  if !bReload
                     LostRichEdit( "HLP" , nGridHlpLastRow )
                  endif
               endif
            endif
            if bGlobalSearch
               if GridImage( "VentanaMain" , "GHlpFiles" , nGridHlpLastRow , NCOLHLPSTATUS , "?" , PUB_nGridImgSearchOk )
                  TotCaption( tipo , -1 )
               endif
               if GlobalSearch2( tipo , cLastGlobalSearch , nGridHlpLastRow , bLastGlobalSearchFun , bLastGlobalSearchDbf )
                  TotCaption( tipo , +1 )
               endif
            endif
            nGridHlpLastRow := nRow
         endif
         if GridImage( "VentanaMain" , "GHlpFiles" , nRow , NCOLHLPSTATUS , "?" , PUB_nGridImgEdited )
            VentanaMain.RichEditHlp.BackColor := DEF_COLORBACKEXTERNALEDIT
            VentanaMain.RichEditHlp.FontColor := DEF_COLORFONTEXTERNALEDIT
         else
            VentanaMain.RichEditHlp.BackColor := DEF_COLORBACKHLP
            VentanaMain.RichEditHlp.FontColor := DEF_COLORFONTVIEW
         endif
         VentanaMain.RichEditHlp.Value := SHG_GetField( "SHG_MEMOT" , nRow )
         VentanaMain.RichEditHlp.CaretPos := val( GetProperty( "VentanaMain" , "GHlpFiles" , "Cell" , nRow , NCOLHLPOFFSET ) )
         oHlpRichEdit:US_EditRefreshButtons()
         oHlpRichEdit:lChanged := .F.
         VentanaMain.GHlpKeys.DeleteAllItems
         MemoKeys := SHG_GetField( "SHG_KEYST" , VentanaMain.GHlpFiles.Value )
         LinesKeys := MLCount( MEmoKeys , 254 )
         For nInx := 1 to LinesKeys
            VentanaMain.GHlpKeys.AddItem( { MemoLine( MemoKeys , 254 , nInx ) } )
         Next
         VentanaMain.GHlpKeys.value := VentanaMain.GHlpFiles.ItemCount
         DoMethod( "VentanaMain" , "GHlpKeys" , "ColumnsAutoFitH" )
#endif
      otherwise
         MsgInfo( "Invalid type in RicheditDisplay: " + US_VarToStr( tipo ) )
   endcase
Return

#ifdef QPM_SHG
Function OcultaHlpKeys()
   do case
      case VentanaMain.GHlpFiles.Value < 2 .and. GetProperty( "VentanaMain" , "TabFiles" , "Value" ) == nPageHlp
         VentanaMain.BAddHlpKey.Enabled    := .F.
         VentanaMain.BRemoveHlpKey.Enabled := .F.
         VentanaMain.GHlpKeys.Enabled      := .F.
         VentanaMain.ItC_AddHlpKey.Enabled := .F.
      case VentanaMain.GHlpFiles.Value > 1 .and. GetProperty( "VentanaMain" , "TabFiles" , "Value" ) == nPageHlp
         VentanaMain.BAddHlpKey.Enabled    := .T.
         VentanaMain.BRemoveHlpKey.Enabled := .T.
         VentanaMain.GHlpKeys.Enabled      := .T.
         VentanaMain.ItC_AddHlpKey.Enabled := .T.
   endcase
   if GetProperty( "VentanaMain" , "TabFiles" , "Value" ) == nPageHlp
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

Function ListRichEditLib( LibName , RichEdit )
   SetProperty( "VentanaMain" , RichEdit , "Value" , QPM_Wait( "ListModule( '" + LibName + "' )" , "Listing..." , , .T. ) )
Return .T.

Function ListModuleMoved( ModName )
   Private ListOut := ModName
   if !file( ModName )
      if file( ModName+'.MOVED.TXT' )
         ListOut := US_WordSubStr( MemoRead( ModName+'.MOVED.TXT' ) , 7 )
      endif
   endif
Return QPM_Wait( "ListModule( ListOut )" , "Listing..." , , .T. )

Function ListModule( ModName )
   Local MemoAux := "" , TempExeType := "" , LOC_RunWaitFileStop := US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + '_' + PUB_cSecu + 'RWFS' + US_DateTimeCen() + '.cnt'
   Local OrigModName := ModName , TempLibType := ""
   if !file( ModName )
      MemoAux := "File '"+ModName+"' not found !!!"
      Return MemoAux
   endif
   ferase( US_ShortName( ModName ) + ".Tmp" )
   ferase( US_ShortName( ModName ) + ".TmpOut" )
   if upper( US_FileNameOnlyExt( ModName ) ) == "LIB"
      TempLibType := QPM_ModuleType( ModName )
      do case
         case TempLibType == "PELLES"
            QPM_MemoWrit( US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + '_'+PUB_cSecu+'RunShell.bat' , US_ShortName(PUB_cQPM_Folder) + DEF_SLASH + 'US_PODUMP.EXE -LINKERMEMBER:2 -ARCHIVEMEMBERS ' + US_ShortName( ModName ) + ' > "' + US_ShortName( ModName ) + '.Tmp"' )
            QPM_Execute( US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + '_'+PUB_cSecu+'RunShell.bat' , , DEF_QPM_EXEC_WAIT , DEF_QPM_EXEC_MINIMIZE )
            ferase( US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + '_'+PUB_cSecu+'RunShell.bat' )

            QPM_MemoWrit( US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + '_'+PUB_cSecu+'RunShell.bat' , US_ShortName(PUB_cQPM_Folder) + DEF_SLASH + 'US_SHELL.EXE QPM ANALIZE_LIB_PELLES ' + US_ShortName( ModName ) + ".Tmp" + ' -FILESTOP ' + LOC_RunWaitFileStop + ' > "' + US_ShortName( ModName ) + '.TmpOut"' )
            QPM_Execute( US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + '_'+PUB_cSecu+'RunShell.bat' , , DEF_QPM_EXEC_WAIT , DEF_QPM_EXEC_MINIMIZE , LOC_RunWaitFileStop )
            ferase( US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + '_'+PUB_cSecu+'RunShell.bat' )
         case TempLibType == "BORLAND"
            QPM_Execute( US_ShortName(PUB_cQPM_Folder) + DEF_SLASH + 'US_TLIB.EXE' , US_ShortName( ModName ) + ", " + US_ShortName( ModName ) + ".Tmp" , DEF_QPM_EXEC_WAIT , DEF_QPM_EXEC_MINIMIZE )

            QPM_MemoWrit( US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + '_'+PUB_cSecu+'RunShell.bat' , US_ShortName(PUB_cQPM_Folder) + DEF_SLASH + 'US_SHELL.EXE QPM ANALIZE_LIB_BORLAND ' + US_ShortName( ModName ) + ".Tmp" + ' -FILESTOP ' + LOC_RunWaitFileStop + ' > "' + US_ShortName( ModName ) + '.TmpOut"' )
            QPM_Execute( US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + '_'+PUB_cSecu+'RunShell.bat' , , DEF_QPM_EXEC_WAIT , DEF_QPM_EXEC_MINIMIZE , LOC_RunWaitFileStop )
            ferase( US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + '_'+PUB_cSecu+'RunShell.bat' )
         case TempLibType == "NONE"
            QPM_MemoWrit( US_ShortName( ModName ) + '.TmpOut' , "File not Found" )
         otherwise
            MsgStop( "Unknown LIB type: " + ModName )
      endcase
   endif
   if upper( US_FileNameOnlyExt( ModName ) ) == "A"
      QPM_MemoWrit( US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + '_'+PUB_cSecu+'RunShell.bat' , US_ShortName(PUB_cQPM_Folder) + DEF_SLASH + 'US_OBJDUMP.EXE -t -s ' + US_ShortName( ModName ) + ' > "' + US_ShortName( ModName ) + '.Tmp"' )
      QPM_Execute( US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + '_'+PUB_cSecu+'RunShell.bat' , , DEF_QPM_EXEC_WAIT , DEF_QPM_EXEC_MINIMIZE )
      ferase( US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + '_'+PUB_cSecu+'RunShell.bat' )

      QPM_MemoWrit( US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + '_'+PUB_cSecu+'RunShell2.bat' , US_ShortName(PUB_cQPM_Folder) + DEF_SLASH + 'US_SHELL.EXE QPM ANALIZE_LIB_MINGW ' + US_ShortName( ModName ) + ".Tmp" + ' -FILESTOP ' + LOC_RunWaitFileStop + ' > "' + US_ShortName( ModName ) + '.TmpOut"' )
      QPM_Execute( US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + '_'+PUB_cSecu+'RunShell2.bat' , , DEF_QPM_EXEC_WAIT , DEF_QPM_EXEC_MINIMIZE , LOC_RunWaitFileStop )
      ferase( US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + '_'+PUB_cSecu+'RunShell2.bat' )
   endif
   if upper( US_FileNameOnlyExt( ModName ) ) == "DLL"
   // EXECUTE FILE US_ShortName(PUB_cQPM_Folder) + DEF_SLASH + 'US_IMPDEF.EXE ' + US_ShortName( ModName ) + ".Tmp " + US_ShortName( ModName ) WAIT MINIMIZE
      QPM_Execute( US_ShortName(PUB_cQPM_Folder) + DEF_SLASH + 'US_IMPDEF.EXE' , US_ShortName( ModName ) + ".Tmp " + US_ShortName( ModName ) , DEF_QPM_EXEC_WAIT , DEF_QPM_EXEC_MINIMIZE )

      QPM_MemoWrit( US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + '_'+PUB_cSecu+'RunShell.bat' , US_ShortName(PUB_cQPM_Folder) + DEF_SLASH + 'US_SHELL.EXE QPM ANALIZE_DLL ' + US_ShortName( ModName ) + ".Tmp" + ' -FILESTOP ' + LOC_RunWaitFileStop + ' > "' + US_ShortName( ModName ) + '.TmpOut"' )
      QPM_Execute( US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + '_'+PUB_cSecu+'RunShell.bat' , , DEF_QPM_EXEC_WAIT , DEF_QPM_EXEC_MINIMIZE , LOC_RunWaitFileStop )
      ferase( US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + '_'+PUB_cSecu+'RunShell.bat' )
   endif
   if upper( US_FileNameOnlyExt( ModName ) ) == "EXE"
      TempExeType := QPM_ModuleType( ModName )
      if TempExeType == "COMPRESSED"
         ListModuleUnUpx( US_ShortName( ModName ) , US_ShortName( ModName ) + ".UnUpx.Exe" )
         ModName := US_Shortname( ModName ) + ".UnUpx.Exe"
         TempExeType := QPM_ModuleType( ModName )
      endif
      do case
         case TempExeType == "BORLAND"
            QPM_MemoWrit( US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + '_'+PUB_cSecu+'RunShell.bat' , US_ShortName(PUB_cQPM_Folder) + DEF_SLASH + 'US_TDUMP.EXE ' + US_ShortName( ModName ) + ' > "' + US_ShortName( ModName ) + '.TmpOut"' )
            QPM_Execute( US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + '_'+PUB_cSecu+'RunShell.bat' , , DEF_QPM_EXEC_WAIT , DEF_QPM_EXEC_MINIMIZE )
            ferase( US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + '_'+PUB_cSecu+'RunShell.bat' )
         case TempExeType == "PELLES"
         // QPM_MemoWrit( US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + '_'+PUB_cSecu+'RunShell.bat' , US_ShortName(PUB_cQPM_Folder) + DEF_SLASH + 'US_PODUMP.EXE /ALL ' + US_ShortName( ModName ) + ' > "' + US_ShortName( ModName ) + '.TmpOut"' )
            QPM_MemoWrit( US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + '_'+PUB_cSecu+'RunShell.bat' , US_ShortName(PUB_cQPM_Folder) + DEF_SLASH + 'US_TDUMP.EXE ' + US_ShortName( ModName ) + ' > "' + US_ShortName( ModName ) + '.TmpOut"' )
            QPM_Execute( US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + '_'+PUB_cSecu+'RunShell.bat' , , DEF_QPM_EXEC_WAIT , DEF_QPM_EXEC_MINIMIZE )
            ferase( US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + '_'+PUB_cSecu+'RunShell.bat' )
         case TempExeType == "MINGW"
          //QPM_MemoWrit( US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + '_'+PUB_cSecu+'RunShell.bat' , US_ShortName(PUB_cQPM_Folder) + DEF_SLASH + 'US_OBJDUMP.EXE -x ' + US_ShortName( ModName ) + ' > "' + US_ShortName( ModName ) + '.TmpOut"' )
            QPM_MemoWrit( US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + '_'+PUB_cSecu+'RunShell.bat' , US_ShortName(PUB_cQPM_Folder) + DEF_SLASH + 'US_TDUMP.EXE ' + US_ShortName( ModName ) + ' > "' + US_ShortName( ModName ) + '.TmpOut"' )
            QPM_Execute( US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + '_'+PUB_cSecu+'RunShell.bat' , , DEF_QPM_EXEC_WAIT , DEF_QPM_EXEC_MINIMIZE )
            ferase( US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + '_'+PUB_cSecu+'RunShell.bat' )
         case TempExeType == "NONE"
            QPM_MemoWrit( US_ShortName( ModName ) + '.TmpOut' , "File not Found" )
         otherwise
            MsgStop( "Unknown EXE type: " + OrigModName )
      endcase
   endif
   MemoAux := MemoRead( US_ShortName( ModName ) + ".TmpOut" )
   ferase( US_ShortName( ModName ) + ".Tmp" )
   ferase( US_ShortName( ModName ) + ".TmpOut" )
   ferase( US_ShortName( OrigModName ) + ".TmpOut" )
   ferase( US_ShortName( OrigModName ) + ".UnUpx.Exe" )
Return MemoAux

Function ListModuleUnUpx( cIn , cOut )
   QPM_MemoWrit( US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + '_'+PUB_cSecu+'RunShell.bat' , US_ShortName(PUB_cQPM_Folder) + DEF_SLASH + 'US_UPX.EXE -d -o' + cOut + ' ' + cIn + ' > "' + cIn + '.TmpOut"' )
   QPM_Execute( US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + '_'+PUB_cSecu+'RunShell.bat' , , DEF_QPM_EXEC_WAIT , DEF_QPM_EXEC_MINIMIZE )
   ferase( US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + '_'+PUB_cSecu+'RunShell.bat' )
Return .T.

Function LocalSearch( Txt , bFunc )
   Local cTab := "" , PositionAux := 0
   Local Resultado := {} , CaretAnt

 //#define EM_SETSEL   177

   DEFAULT bFunc TO .F.
   if empty( Txt )
      MsgInfo( "Empty Text for Search..." )
      Return .F.
   endif
   AddSearchTxt()
   do case
      case VentanaMain.TabFiles.value == nPagePrg
         cTab := "PRG"
      case VentanaMain.TabFiles.value == nPageHea
         cTab := "HEA"
      case VentanaMain.TabFiles.value == nPagePan
         cTab := "PAN"
      case VentanaMain.TabFiles.value == nPageDbf
         cTab := "DBF"
      case VentanaMain.TabFiles.value == nPageLib
         cTab := "LIB"
      case VentanaMain.TabFiles.value == nPageSysOut
         cTab := "SYSOUT"
      case VentanaMain.TabFiles.value == nPageOut
         cTab := "OUT"
#ifdef QPM_SHG
      case VentanaMain.TabFiles.value == nPageHlp
         cTab := "HLP"
#endif
      otherwise
         MsgInfo( "Error in function LocalSearch, TabFile invalid: "+US_VarToStr( VentanaMain.TabFiles.value ) )
   endcase
   if bFunc .and. !( cTab == "PRG" )
      MsgInfo( "Error in Local Search, invalid bFunc in true with cTab equal "+cTab )
      Return .F.
   endif
   CaretAnt := GetProperty( "VentanaMain" , "RichEdit"+cTab , "CaretPos" )
   if bFunc
      GlobalSearch2( "PRG" , Txt , GetProperty( "VentanaMain" , "G"+cTab+"Files" , "Value" ) , .T. , , , , , @PositionAux )
      PositionAux--
      aadd( Resultado , PositionAux )
      aadd( Resultado , PositionAux )
      aadd( Resultado , PositionAux )
      if Resultado[1] > 0
         SetProperty( "VentanaMain" , "RichEdit"+cTab , "CaretPos" , PositionAux )
         FindChr( GetControlHandle ( "RichEdit"+cTab , "VentanaMain" ) , Txt , .T. , .F. , .F. , .T. )
      endif
   else
      Resultado := FindChr( GetControlHandle( "RichEdit"+cTab , "VentanaMain" ) , Txt , .T. , .F. , .F. , .T. )
   endif
   if Resultado[3] < 0
      if CaretAnt == 0
  //    SetMGWaitHide()
         MsgOk( 'QPM (QAC Based Project Manager)' , "Text not Found" , 'E' , .T. , 2 )
      else
       //FindChr( GetControlHandle( "RichEdit"+cTab , "VentanaMain" ) , "main" , .F. , .F. , .F. , .T. )
       //SetProperty( "VentanaMain" , "RichEdit"+cTab , "CaretPos" , 0 )
       //DoMethod( "VentanaMain" , "RichEdit"+cTab , "SetFocus" )
         //SendMessage( GetControlHandle( "RichEdit"+cTab , "VentanaMain" ) , EM_SETSEL , 1 , 1 )
         //DoMethod( "VentanaMain" , "RichEdit"+cTab , "refresh" )
         //RichEditDisplay( cTab , .T. )
   //    SetMGWaitHide()
         MsgOk( 'QPM (QAC Based Project Manager)' , "Text not Found"+HB_OsNewLine()+"Re-Search from Top" , 'W' , .T. , 2 )
         //LocalSearch( Txt )
      endif
      SetProperty( "VentanaMain" , "RichEdit"+cTab , "CaretPos" , CaretAnt )
      Return .F.
   endif
Return .T.

Function DbfDataSearch( Txt )
   Local cTab := "" , nRecord := 0 , cFieldName := "" , nFieldPos := 0 , cFieldTxt := ""
   Local nOldValue := VentanaMain.GDbfFiles.Value
   Local nOldRecord
   Local nAuxRecord
   Local cTypeDbfSearch := "R"  /* Record Base Type */
   if VentanaMain.GDbfFiles.Value < 1
      MsgInfo( "Not DBF selected..." )
      Return .F.
   endif
   if empty( Txt )
      MsgInfo( "Empty Text for Search..." )
      Return .F.
   endif
   nOldRecord := VentanaMain.DbfBrowse.Value
   nAuxRecord := nOldRecord
   AddSearchTxt()
   cTab := "DBF"
 //if US_Word( GetProperty( "VentanaMain" , "GDbfFiles" , "Cell" , VentanaMain.GDbfFiles.Value , NCOLDBFSEARCH ) , 1 ) == "0"
   if bAvisoDbfDataSearchLow .or. !( val( US_Word( GetProperty( "VentanaMain" , "GDbfFiles" , "Cell" , VentanaMain.GDbfFiles.Value , NCOLDBFSEARCH ) , 1 ) ) == nOldRecord )
      if ! MyMsgYesNo( "Search 'Dbf Data' is very slow.  Do you want to continue ?" )
         Return .F.
      endif
      bAvisoDbfDataSearchLow := .F.
      bDbfDataSearchAsk  := .T.
   else
      if !( bDbfDataSearchAsk )
         cTypeDbfSearch := cDbfDataSearchAskRpta
      else
         SetMGWaitHide()
         if ( cTypeDbfSearch := LocalSearchContinue() ) == ""
            SetMGWaitShow()
            Return .F.
         else
            if !( bDbfDataSearchAsk )
               cDbfDataSearchAskRpta := cTypeDbfSearch
            endif
         endif
         SetMGWaitShow()
      endif
      if cTypeDbfSearch == "R"
         nAuxRecord++
      endif
   Endif
   VentanaMain.RichEditDbf.BackColor := DEF_COLORBACKDBFSEARCHOK
   if GlobalSearch2( "DBF" , Txt , VentanaMain.GDbfFiles.Value , , .T. , cTypeDbfSearch , nAuxRecord , @nRecord , @cFieldName , @nFieldPos , @cFieldTxt )
      DBSelectarea( "DbfAlias" )
      VentanaMain.DbfBrowse.Value := nRecord
      VentanaMain.DbfBrowse.Refresh()
#IFDEF __XHARBOUR__
      VentanaMain.RichEditDbf.Value := "     " + HB_OsNewline() + ;
                                       "     " + HB_OsNewline() + ;
                                       "     Text found at record: " + alltrim( str( nRecord ) ) + HB_OsNewLine() + ;
                                       "     Field: " + cFieldName + HB_OsNewLine() + ;
                                       "     Position: " + alltrim( str( nFieldPos ) ) + HB_OsNewLine() + ;
                                       "     Content: " + substr( cFieldTxt , at( us_upper( Txt ) , US_Upper( cFieldTxt ) , nFieldPos ) , 200 ) + HB_OsNewLine()
#ELSE
      VentanaMain.RichEditDbf.Value := "     " + HB_OsNewline() + ;
                                       "     " + HB_OsNewline() + ;
                                       "     Text found at record: " + alltrim( str( nRecord ) ) + HB_OsNewLine() + ;
                                       "     Field: " + cFieldName + HB_OsNewLine() + ;
                                       "     Position: " + alltrim( str( nFieldPos ) ) + HB_OsNewLine() + ;
                                       "     Content: " + substr( cFieldTxt , hb_at( us_upper( Txt ) , US_Upper( cFieldTxt ) , nFieldPos ) , 200 ) + HB_OsNewLine()
#ENDIF

      VentanaMain.RichEditDbf.CaretPos := 1
      FindChr( GetControlHandle ( "RichEditDbf" , "VentanaMain" ) , VentanaMain.CSearch.DisplayValue , FindChr( GetControlHandle ( "RichEditDbf" , "VentanaMain" ) , "Content: " , .T. , .F. , .F. , .T. ) , .F. , .F. , .T. )
      SetProperty( "VentanaMain" , "GDbfFiles" , "Cell" , VentanaMain.GDbfFiles.Value , NCOLDBFSEARCH , alltrim( str( nRecord ) ) + " " + cFieldName + " " + alltrim( str( nFieldPos ) ) )
      DoMethod( "VentanaMain" , "GDbfFiles" , "ColumnsAutoFitH" )
      VentanaMain.BLocalSearchDbf.caption := "Continue Search"
      VentanaMain.BLocalSearchDbf.Tooltip := "Continue Search text in DBF data. Reset with Force Display Dbf Button"
      Return .T.
   endif
   SetMGWaitHide()
   if nOldRecord == 1
      MsgOk( 'QPM (QAC Based Project Manager)' , "Text not Found" , 'E' , .T. , 2 )
      bAvisoDbfDataSearchLow := .T.
      VentanaMain.RichEditDbf.Value := "     " + HB_OsNewline() + ;
                                       "     Text not Found in DBF data"
  //  if !( US_Word( GetProperty( "VentanaMain" , "GDbfFiles" , "Cell" , VentanaMain.GDbfFiles.Value , NCOLDBFSEARCH ) , 1 ) == "0" )
  //     VentanaMain.RichEditDbf.Value := "     " + HB_OsNewline() + ;
  //                                      "     Text not Found in DBF data"
  //     GetProperty( "VentanaMain" , "GDbfFiles" , "Cell" , VentanaMain.GDbfFiles.Value , NCOLDBFSEARCH ) := "0 ** 0"
  //  endif
   else
      MsgOk( 'QPM (QAC Based Project Manager)' , "Text not Found"+HB_OsNewLine()+"Re-Search from Top" , 'W' , .T. , 2 )
      VentanaMain.RichEditDbf.Value := "     " + HB_OsNewline() + ;
                                       "     Text not Found in DBF data from record " + alltrim( str( nOldRecord ) ) + HB_OsNewLine() + ;
                                       "     Re-Search from Top Record"
    //GetProperty( "VentanaMain" , "GDbfFiles" , "Cell" , VentanaMain.GDbfFiles.Value , NCOLDBFSEARCH ) := "0 ** 0"
   endif
   VentanaMain.DbfBrowse.Value := nOldRecord
   bDbfDataSearchAsk     := .T.
   cDbfDataSearchAskRpta := ""
   VentanaMain.BLocalSearchDbf.caption := "New Dbf Search"
   VentanaMain.BLocalSearchDbf.Tooltip := "Search text in DBF data from the beginer. Reset with Force Display Dbf Button"
   VentanaMain.GDbfFiles.Value := nOldValue
   DoMethod( "VentanaMain" , "GDbfFiles" , "ColumnsAutoFitH" )
Return .F.

Function GlobalSearch( Txt )
   Local i := 0
   Local nFound := 0 , bSearchDbfData
   if empty( Txt )
      MsgInfo( "Empty Text for Search..." )
      Return .F.
   endif
   ResetImgGrid( "*" )
   bGlobalSearch        := .T.
   cLastGlobalSearch    := Txt
   bLastGlobalSearchFun := VentanaMain.Check_SearchFun.value
   bLastGlobalSearchDbf := VentanaMain.Check_SearchDbf.value
   bSearchDbfData       := bLastGlobalSearchDbf
   VentanaMain.Check_SearchFun.enabled := .F.
   VentanaMain.Check_SearchDbf.enabled := .F.
   VentanaMain.BGlobalReset.enabled    := .T.
   VentanaMain.LGlobal.visible         := .T.

   if bLastGlobalSearchFun
      nFound := 0
      TotCaption( "PRG" , 0 )
      For i:=1 to VentanaMain.GPrgFiles.ItemCount
         if GlobalSearch2( "PRG" , Txt , i , .T. )
            nFound++
         endif
      Next i
      TotCaption( "PRG" , nFound )
      Return .T.
   else
      nFound := 0
      TotCaption( "PRG" , 0 )
      For i:=1 to VentanaMain.GPrgFiles.ItemCount
         if GlobalSearch2( "PRG" , Txt , i )
            nFound++
         endif
      Next i
      TotCaption( "PRG" , nFound )
   endif

   nFound := 0
   TotCaption( "HEA" , 0 )
   For i:=1 to VentanaMain.GHeaFiles.ItemCount
      if GlobalSearch2( "HEA" , Txt , i )
         nFound++
      endif
   Next i
   TotCaption( "HEA" , nFound )
   
   nFound := 0
   TotCaption( "PAN" , 0 )
   For i:=1 to VentanaMain.GPanFiles.ItemCount
      if GlobalSearch2( "PAN" , Txt , i )
         nFound++
      endif
   Next i
   TotCaption( "PAN" , nFound )
   /* */
   nFound := 0
// VentanaMain.Check_SearchDbf.value := bSearchDbfData
   TotCaption( "DBF" , 0 )
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
      if GlobalSearch2( "DBF" , Txt , i , , bSearchDbfData )
         nFound++
      endif
   Next i
   TotCaption( "DBF" , nFound )
   VentanaMain.Check_SearchDbf.value := bSearchDbfData
   bAvisoDbfGlobalSearchLow := .T.

   nFound := 0
   TotCaption( "LIB" , 0 )
   For i:=1 to VentanaMain.GIncFiles.ItemCount
      if GlobalSearch2( "LIB" , Txt , i )
         nFound++
      endif
   Next i
   TotCaption( "LIB" , nFound )

   nFound := 0
   TotCaption( "HLP" , 0 )
   if SHG_BaseOk
      if ! MyMsgYesNo( "Skip search of Help Topics ?", nil, .T. )
         For i:=1 to VentanaMain.GHlpFiles.ItemCount
            if GlobalSearch2( "HLP" , Txt , i )
               nFound++
            endif
         Next i
         TotCaption( "HLP" , nFound )
      endif
   endif

   QPM_CheckFiles()
Return .T.

Function GlobalSearch2( cType , Txt , nRow , bFunc , bDbfData , DBFcBaseType , nRecordBase , nRecordFound , cFieldNameFound , nFieldPosFound , cFieldTxtFound )
   Local Pos := 0 , MemoAux := "" , x := 0 , LineAux := "" , nWord := 1 , vAux := {} , nPosition := 1
   Local bSalir := .F. , nPosAux
   Local bFound := .F. , bChangeImg
   Local aStru , DbfName , DbfCode
   Local cFieldBase := "" , nPosBase := 0 , columnValid := .F. , AuxPosition
   DEFAULT bFunc       TO .F.
   DEFAULT bDbfData    TO .F.
   DEFAULT DBFcBaseType TO "R" /* R : Record , F : Filed , P : Position */
   DEFAULT nRecordBase  TO 1
   SetMGWaitTxt( "Searching: " + ChgPathToReal( GetProperty( "VentanaMain" , "G" + if( cType == "LIB" , "INC" , cType ) + "Files" , "Cell" , nRow , &( "nCol"+cType+if(cType=="HLP","Topic","FullName") ) ) ) )
   if bGlobalSearch
      bChangeImg := .T.
   else
      bChangeImg := .F.
   endif
   nFieldPosFound := 0
   if bFunc .and. !( Prj_Radio_OutputType == DEF_RG_IMPORT )
      if bChangeImg
         GridImage( "VentanaMain" , "GPrgFiles" , nRow , NCOLPRGSTATUS , "-" , PUB_nGridImgSearchOk )
      endif
      MemoAux := us_upper( MemoRead( ChgPathToReal( GetProperty( "VentanaMain" , "GPrgFiles" , "Cell" , nRow , NCOLPRGFULLNAME ) ) ) )
      bSalir := .F.
      nPosition := 1

#IFDEF __XHARBOUR__
      do while ( Pos := at( us_upper( Txt ) , MemoAux , nPosition ) ) > 0 .and. !bSalir
#ELSE
      do while ( Pos := hb_at( us_upper( Txt ) , MemoAux , nPosition ) ) > 0 .and. !bSalir
#ENDIF
         nPosition := Pos + 1
         vAux := {}
         vAux := MPOSTOLC( MemoAux , 254 , Pos )
         LineAux := MemoLine( MemoAux , 254 , vAux[1] )
         if at( us_upper( Txt ) , LineAux ) > 0 .and. ;
            ( at( "PROCEDURE" , LineAux ) > 0 .or. ;
              at( "PROC"      , LineAux ) > 0 .or. ;
              at( "FUNCTION"  , LineAux ) > 0 .or. ;
              at( "FUNC"      , LineAux ) > 0 .or. ;
              at( "METHOD"    , LineAux ) > 0 .or. ;
              at( "METH"      , LineAux ) > 0 )
            if US_Word( LineAux , 1 ) == "STATIC"
               nWord := 2
            else
               nWord := 1
            endif
            if ( ( US_Word( LineAux , nWord ) == "PROCEDURE" ) .or. ;
                 ( US_Word( LineAux , nWord ) == "PROC"      ) .or. ;
                 ( US_Word( LineAux , nWord ) == "FUNCTION"  ) .or. ;
                 ( US_Word( LineAux , nWord ) == "FUNC"      ) .or. ;
                 ( US_Word( LineAux , nWord ) == "METHOD"    ) .or. ;
                 ( US_Word( LineAux , nWord ) == "METH"      ) ) .and. ;
               ( ( at( US_Upper( Txt ) + "(" , substr( LineAux , US_WordInd( LineAux , nWord + 1 ) ) ) = 1 ) .or. ;
                 ( at( US_Upper( Txt ) + " " , substr( LineAux , US_WordInd( LineAux , nWord + 1 ) ) ) = 1 ) )
               if bChangeImg
                  GridImage( "VentanaMain" , "GPrgFiles" , nRow , NCOLPRGSTATUS , "+" , PUB_nGridImgSearchOk )
               endif
               bSalir := .T.
               bFound := .T.
               nFieldPosFound := MLCTOPOS( MemoAux , 254 , vAux[1] , US_WordInd( LineAux , nWord + 1 ) )       && - vAux[1]
            // nFieldPosFound := MLCTOPOS( MemoRead( ChgPathToReal( GetProperty( "VentanaMain" , "GPrgFiles" , "Cell" , nRow , NCOLPRGFULLNAME ) ) ) , 254 , vAux[1] , US_WordInd( LineAux , nWord + 1 ) ) && - vAux[1]
            endif
         endif
      enddo
   else
      do case
         case cType == "PRG"
            if Prj_Radio_OutputType == DEF_RG_IMPORT
               nPosAux := at( US_upper( Txt ) , us_upper( GetProperty( "VentanaMain" , "RichEditPRG" , "value" ) ) )
            else
               nPosAux := at( us_upper( Txt ) , us_upper( MemoRead( ChgPathToReal( GetProperty( "VentanaMain" , "GPrgFiles" , "Cell" , nRow , NCOLPRGFULLNAME ) ) ) ) )
            endif
            if nPosAux > 0
               if bChangeImg
                  GridImage( "VentanaMain" , "GPrgFiles" , nRow , NCOLPRGSTATUS , "+" , PUB_nGridImgSearchOk )
               endif
               bFound := .T.
            else
               if bChangeImg
                  GridImage( "VentanaMain" , "GPrgFiles" , nRow , NCOLPRGSTATUS , "-" , PUB_nGridImgSearchOk )
               endif
            endif
         case cType == "HEA"
            if at( us_upper( Txt ) , us_upper( MemoRead( ChgPathToReal( GetProperty( "VentanaMain" , "GHeaFiles" , "Cell" , nRow , NCOLHEAFULLNAME ) ) ) ) ) > 0
               if bChangeImg
                  GridImage( "VentanaMain" , "GHeaFiles" , nRow , NCOLHEASTATUS , "+" , PUB_nGridImgSearchOk )
               endif
               bFound := .T.
            else
               if bChangeImg
                  GridImage( "VentanaMain" , "GHeaFiles" , nRow , NCOLHEASTATUS , "-" , PUB_nGridImgSearchOk )
               endif
            endif
         case cType == "PAN"
            if at( us_upper( Txt ) , us_upper( MemoRead( ChgPathToReal( GetProperty( "VentanaMain" , "GPanFiles" , "Cell" , nRow , NCOLPANFULLNAME ) ) ) ) ) > 0
               if bChangeImg
                  GridImage( "VentanaMain" , "GPanFiles" , nRow , NCOLPANSTATUS , "+" , PUB_nGridImgSearchOk )
               endif
               bFound := .T.
            else
               if bChangeImg
                  GridImage( "VentanaMain" , "GPanFiles" , nRow , NCOLPANSTATUS , "-" , PUB_nGridImgSearchOk )
               endif
            endif
         case cType == "DBF"
            DbfName := ChgPathToReal( GetProperty( "VentanaMain" , "GDbfFiles" , "Cell" , nRow , NCOLDBFFULLNAME ) )
            DbfCode := US_IsDBF( DbfName )
            If DbfCode = 0
               US_Use( .T. , , DbfName , "DSearch" , DEF_DBF_SHARED , DEF_DBF_READ ) /* si pongo exclusive y write no funciona el search, revisarlo */
               aStru:=DBSTRUCT()
               if !bDbfData
                  FOR x:=1 TO LEN(aStru)
                     if at( us_upper( Txt ) , aStru[x][1] ) > 0
                        bFound := .T.
                        exit
                     endif
                  Next x
               else
                //nRecordBase := val( US_Word( GetProperty( "VentanaMain" , "GDbfFiles" , "Cell" , nRow , NCOLDBFSEARCH ) , 1 ) )
                //nRecordBase := VentanaMain.DbfBrowse.value
                  cFieldBase  := ""
                  nPosBase := 1
                //if DBFcBaseType == "R"   /* Record base type */
                //   nRecordBase++
                //endif
                  if DBFcBaseType == "F"   /* Field base type */
                     cFieldBase  := US_Word( GetProperty( "VentanaMain" , "GDbfFiles" , "Cell" , nRow , NCOLDBFSEARCH ) , 2 )
                  endif
                  if DBFcBaseType == "P"   /* Position base type */
                     cFieldBase  := US_Word( GetProperty( "VentanaMain" , "GDbfFiles" , "Cell" , nRow , NCOLDBFSEARCH ) , 2 )
                  endif
                  DBGoTo( nRecordBase )
                  columnValid := .F.
                  if DBFcBaseType == "R"  /* Record base type */
                     columnValid := .T.
                  endif
                  Do while !eof()
                     FOR x:=1 TO LEN(aStru)
                        if DBFcBaseType == "F" .and. !columnValid        /* Field base type */
                           if aStru[x][1] == cFieldBase
                              columnValid := .T.
                              loop
                           endif
                        endif
                        nPosBase := 1
                        if DBFcBaseType == "P" .and. !columnValid        /* Position base type */
                           if aStru[x][1] == cFieldBase
                              nPosBase := val( US_Word( GetProperty( "VentanaMain" , "GDbfFiles" , "Cell" , nRow , NCOLDBFSEARCH ) , 3 ) ) + 1
                              columnValid := .T.
                           endif
                        endif
                        if columnValid
#IFDEF __XHARBOUR__
                           if ( AuxPosition := at( US_Upper( Txt ) , US_Upper( US_VarToStr( &( aStru[x][1] ) ) ) , nPosBase ) ) > 0
#ELSE
                           if ( AuxPosition := hb_at( US_Upper( Txt ) , US_Upper( US_VarToStr( &( aStru[x][1] ) ) ) , nPosBase ) ) > 0
#ENDIF
                              bFound := .T.
                              nRecordFound      := RecNo()
                              cFieldNameFound   := aStru[x][1]
                              nFieldPosFound    := AuxPosition
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
               DBCloseArea( "DSearch" )
            endif
            if bFound
               if bChangeImg
                  GridImage( "VentanaMain" , "GDbfFiles" , nRow , NCOLDBFSTATUS , "+" , PUB_nGridImgSearchOk )
               endif
               bFound := .T.
            else
               if bChangeImg
                  GridImage( "VentanaMain" , "GDbfFiles" , nRow , NCOLDBFSTATUS , "-" , PUB_nGridImgSearchOk )
               endif
            endif
         case cType == "LIB"
            if at( us_upper( Txt ) , us_upper( MemoRead( ChgPathToReal( GetProperty( "VentanaMain" , "GIncFiles" , "Cell" , nRow , NCOLINCFULLNAME ) ) ) ) ) > 0
               if bChangeImg
                  GridImage( "VentanaMain" , "GIncFiles" , nRow , NCOLINCSTATUS , "+" , PUB_nGridImgSearchOk )
               endif
               bFound := .T.
            else
               if bChangeImg
                  GridImage( "VentanaMain" , "GIncFiles" , nRow , NCOLINCSTATUS , "-" , PUB_nGridImgSearchOk )
               endif
            endif
#ifdef QPM_SHG
         case cType == "HLP"
            if at( us_upper( Txt ) , us_upper( US_RTF2TXT( SHG_GetField( "SHG_MEMOT" , nRow ) ) ) ) > 0
               if bChangeImg
                  GridImage( "VentanaMain" , "GHlpFiles" , nRow , NCOLHLPSTATUS , "+" , PUB_nGridImgSearchOk )
               endif
               bFound := .T.
            else
               if bChangeImg
                  GridImage( "VentanaMain" , "GHlpFiles" , nRow , NCOLHLPSTATUS , "-" , PUB_nGridImgSearchOk )
               endif
            endif
#endif
         otherwise
            MsgInfo( "Invalid type in GlobalSearch2: " + cType )
      endcase
   endif
Return bFound

Function ResetImgGrid( cGrid )
   Local i := 0
   if empty( cGrid )
      cGrid := "*"
   endif
   VentanaMain.BGlobalReset.enabled    := .F.
   VentanaMain.Check_SearchFun.enabled := .T.
   VentanaMain.Check_SearchDbf.enabled := .T.
   VentanaMain.LGlobal.visible         := .F.
   bGlobalSearch         := .F.
   bLastGlobalSearchDbf  := .F.
   bAvisoDbfGlobalSearchLow := .F.
   if cGrid == "PRG" .or. cGrid == "*"
      For i:=1 to VentanaMain.GPrgFiles.ItemCount
         if GridImage( "VentanaMain" , "GPrgFiles" , i , NCOLPRGSTATUS , "?" , PUB_nGridImgSearchOk )
            GridImage( "VentanaMain" , "GPrgFiles" , i , NCOLPRGSTATUS , "-" , PUB_nGridImgSearchOk )
         endif
      Next i
      VentanaMain.TabGrids.Caption( 1 ) := PagePRG
   endif

   if cGrid == "HEA" .or. cGrid == "*"
      For i:=1 to VentanaMain.GHeaFiles.ItemCount
         if GridImage( "VentanaMain" , "GHeaFiles" , i , NCOLHEASTATUS , "?" , PUB_nGridImgSearchOk )
            GridImage( "VentanaMain" , "GHeaFiles" , i , NCOLHEASTATUS , "-" , PUB_nGridImgSearchOk )
         endif
      Next i
      VentanaMain.TabGrids.Caption( 2 ) := PageHEA
   endif

   if cGrid == "PAN" .or. cGrid == "*"
      For i:=1 to VentanaMain.GPanFiles.ItemCount
         if GridImage( "VentanaMain" , "GPanFiles" , i , NCOLPANSTATUS , "?" , PUB_nGridImgSearchOk )
            GridImage( "VentanaMain" , "GPanFiles" , i , NCOLPANSTATUS , "-" , PUB_nGridImgSearchOk )
         endif
      Next i
      VentanaMain.TabGrids.Caption( 3 ) := PagePAN
   endif

   if cGrid == "DBF" .or. cGrid == "*"
      For i:=1 to VentanaMain.GDbfFiles.ItemCount
         if GridImage( "VentanaMain" , "GDbfFiles" , i , NCOLDBFSTATUS , "?" , PUB_nGridImgSearchOk )
            GridImage( "VentanaMain" , "GDbfFiles" , i , NCOLDBFSTATUS , "-" , PUB_nGridImgSearchOk )
         endif
         SetProperty( "VentanaMain" , "GDbfFiles" , "Cell" , i , NCOLDBFSEARCH , "0 ** 0" )
      Next i
      VentanaMain.TabGrids.Caption( 4 ) := PageDBF
      VentanaMain.BLocalSearchDbf.caption := "Dbf Search"
      VentanaMain.BLocalSearchDbf.Tooltip := "Search text in Dbf Data"
      VentanaMain.RichEditDbf.BackColor := DEF_COLORBACKDBF
      QPM_Wait( "RichEditDisplay( 'DBF' , .F. )" , "Loading..." )
   endif

   if cGrid == "LIB" .or. cGrid == "*"
      For i:=1 to VentanaMain.GIncFiles.ItemCount
         if GridImage( "VentanaMain" , "GIncFiles" , i , NCOLINCSTATUS , "?" , PUB_nGridImgSearchOk )
            GridImage( "VentanaMain" , "GIncFiles" , i , NCOLINCSTATUS , "-" , PUB_nGridImgSearchOk )
         endif
      Next i
      VentanaMain.TabGrids.Caption( 5 ) := PageLIB
   endif

   if cGrid == "HLP" .or. cGrid == "*"
      For i:=1 to VentanaMain.GHlpFiles.ItemCount
         if GridImage( "VentanaMain" , "GHlpFiles" , i , NCOLHLPSTATUS , "?" , PUB_nGridImgSearchOk )
            GridImage( "VentanaMain" , "GHlpFiles" , i , NCOLHLPSTATUS , "-" , PUB_nGridImgSearchOk )
         endif
      Next i
      VentanaMain.TabGrids.Caption( 6 ) := PageHlp
   endif
Return .T.

Function GridImage( cWin , cGrid , nRow , nCol , cOper , nBitImage )
   Local nBits  := 256   // ( 2 ** PUB_nGridImgTop ) // ej: 9 imagenes primarias = 256 ( PUB_nGridImgTilde, PUB_nGridImgEquis, etc )
   Local i , cString , nAux
   if nRow < 1
      Return .F.
   endif
   if ( nAux := aScan( vImagesTranslateGrid , { |x| x[2] == GetProperty( cWin , cGrid , "Cell" , nRow , nCol ) } ) ) == 0
      MsgInfo( "Error en posicionamiento en Funcion GridImage para el valor: " + US_VarToStr( GetProperty( cWin , cGrid , "Cell" , nRow , nCol ) ) )
      Return .F.
   endif
   cString := NTOC( vImagesTranslateGrid[ nAux ][ 1 ] , 2 , nBits , "0" )
   For i:=1 to len( cOper )
      do case
         case substr( cOper , i , 1 ) == "?"              /* preguntar si esta activo */
            if substr( cString , nBits - nBitImage + 1 , 1 ) == "1"
               Return .T.
            else
               Return .F.
            endif
         case substr( cOper , i , 1 ) == "+"              /* agregarle */
            cString := substr( cString , 1 , nBits - nBitImage ) + "1" + substr( cString , nBits - nBitImage + 2 )
         case substr( cOper , i , 1 ) == "-"              /* sacarle */
            cString := substr( cString , 1 , nBits - nBitImage ) + "0" + substr( cString , nBits - nBitImage + 2 )
         case upper( substr( cOper , i , 1 ) ) == "X"     /* limpiar */
            cString := strtran( cString , "1" , "0" )
 //      case upper( substr( cOper , i , 1 ) ) == "="     /* setear  */
 //         cString := strtran( cString , "1" , "0" )
 //         cString := substr( cString , 1 , nBits - nBitImage ) + "1" + substr( cString , nBits - nBitImage + 2 )
         otherwise
            MsgInfo( "Error in operator from Function GridImage" )
      endcase
   Next i
   if ( nAux := aScan( vImagesTranslateGrid , { |x| x[1] == CTON( cString , 2 ) } ) ) == 0
      MsgInfo( "Error en posicionamiento (2) en Funcion GridImage para el valor: " + US_VarToStr( CTON( cString , 2 ) ) )
      Return .F.
   endif
   SetProperty( cWin , cGrid , "Cell" , nRow , nCol , vImagesTranslateGrid[ nAux ][ 2 ] )
Return .F.

Function AddSearchTxt()
   Local Aux:="", cValor:="", i
   cValor:=VentanaMain.CSearch.DisplayValue
   if !empty( alltrim(cValor)) .and. !AddSearchTxtFound(cValor)
      if VentanaMain.CSearch.ItemCount < 15
         VentanaMain.CSearch.AddItem("*")
      endif
      Aux:=VentanaMain.CSearch.ItemCount
      For i=(Aux - 1) to 1 step -1
         VentanaMain.CSearch.Item((i+1)):=VentanaMain.CSearch.Item(i)
      next
      VentanaMain.CSearch.Item(1):=cValor
      VentanaMain.CSearch.Value:=1
   endif
Return .T.
Function AddSearchTxtFound(email)
   Local i:=0
   For i=1 to VentanaMain.CSearch.ItemCount
       if upper(email) == upper(VentanaMain.CSearch.Item(i))
          Return .T.
       endif
   next
Return .F.

Function LostRichEdit( tipo , nRecord )
   Local cAuxMemo
   do case
      case tipo == "PRG"
         if bPpoDisplayado
            SetProperty( "VentanaMain" , "GPrgFiles" , "Cell" , nGridPrgLastRow , NCOLPRGOFFSET , cPpoCaretPrg )
         else
            SetProperty( "VentanaMain" , "GPrgFiles" , "Cell" , nGridPrgLastRow , NCOLPRGOFFSET , alltrim( str( VentanaMain.RichEditPRG.CaretPos ) ) )
         endif
         DoMethod( "VentanaMain" , "GPrgFiles" , "ColumnsAutoFitH" )
      case tipo == "HEA"
         SetProperty( "VentanaMain" , "GHeaFiles" , "Cell" , nGridHeaLastRow , NCOLHEAOFFSET , alltrim( str( VentanaMain.RichEditHea.CaretPos ) ) )
         DoMethod( "VentanaMain" , "GHeaFiles" , "ColumnsAutoFitH" )
      case tipo == "PAN"
         SetProperty( "VentanaMain" , "GPanFiles" , "Cell" , nGridPanLastRow , NCOLPANOFFSET , alltrim( str( VentanaMain.RichEditPan.CaretPos ) ) )
         DoMethod( "VentanaMain" , "GPanFiles" , "ColumnsAutoFitH" )
      case tipo == "DBF"
         SetProperty( "VentanaMain" , "GDbfFiles" , "Cell" , nGridDbfLastRow , NCOLDBFOFFSET , alltrim( str( VentanaMain.RichEditDbf.CaretPos ) ) + " " + alltrim( str( nRecord ) ) )
         DoMethod( "VentanaMain" , "GDbfFiles" , "ColumnsAutoFitH" )
#ifdef QPM_SHG
      case tipo == "HLP"
         if nRecord > 0
            SetProperty( "VentanaMain" , "GHlpFiles" , "Cell" , nGridHlpLastRow , NCOLHLPOFFSET , alltrim( str( VentanaMain.RichEditHlp.CaretPos ) ) )
            cAuxMemo := US_GetRichEditValue( "VentanaMain" , "RichEditHlp" , "RTF" )
*            SHG_LimpioRtf( @cAuxMemo )
            SHG_SetField( "SHG_MEMOT"  , nRecord , cAuxMemo )

/*
            if !( SHG_GetField( "SHG_TYPE"  , nRecord ) == SHG_GetField( "SHG_TYPET"  , nRecord ) ) .or. ;
               !( SHG_GetField( "SHG_TOPIC" , nRecord ) == SHG_GetField( "SHG_TOPICT" , nRecord ) ) .or. ;
               !( SHG_GetField( "SHG_NICK"  , nRecord ) == SHG_GetField( "SHG_NICKT"  , nRecord ) ) .or. ;
               !( cAuxMemo == SHG_GetField( "SHG_MEMO" , nRecord ) ) .or. ;
               !( SHG_GetField( "SHG_KEYS"  , nRecord ) == SHG_GetField( "SHG_KEYST"  , nRecord ) )
               SetProperty( "VentanaMain" , "GHlpFiles" , "Cell" , nGridHlpLastRow , NCOLHLPEDIT , "D" )
            endif
*/
            if !( SHG_GetField( "SHG_TYPE"  , nRecord ) == SHG_GetField( "SHG_TYPET"  , nRecord ) ) .or. ;
               !( SHG_GetField( "SHG_TOPIC" , nRecord ) == SHG_GetField( "SHG_TOPICT" , nRecord ) ) .or. ;
               !( SHG_GetField( "SHG_NICK"  , nRecord ) == SHG_GetField( "SHG_NICKT"  , nRecord ) ) .or. ;
               oHlpRichEdit:lChanged .or. ;
               !( SHG_GetField( "SHG_KEYS"  , nRecord ) == SHG_GetField( "SHG_KEYST"  , nRecord ) )
               
               SetProperty( "VentanaMain" , "GHlpFiles" , "Cell" , nGridHlpLastRow , NCOLHLPEDIT , "D" )
               oHlpRichEdit:lChanged := .F.
            endif
            DoMethod( "VentanaMain" , "GHlpFiles" , "ColumnsAutoFitH" )
         endif
#endif
   endcase
Return .T.

Function FormQuickView()
   QPM_MemoWrit( PUB_cProjectFolder + DEF_SLASH + '_' + PUB_cSecu + 'RunViewForm.Cng' , 'PATH ' + US_ShortName( PUB_cProjectFolder ) + HB_OsNewLine() + ;
                                                                'SECUENCE ' + PUB_cSecu + HB_OsNewLine() + ;
                                                                'HARBOUR ' + US_ShortName( GetHarbourFolder() ) + DEF_SLASH + 'BIN'+DEF_SLASH+'HARBOUR.EXE' + HB_OsNewLine() + ;
                                                                'HARBOURINCLUDE ' + US_ShortName( GetHarbourFolder() ) + DEF_SLASH + 'INCLUDE' + HB_OsNewLine() + ;
                                                                'MINIGUIINCLUDE ' + US_ShortName(GetMiniGuiFolder()) + DEF_SLASH + 'INCLUDE' + HB_OsNewLine() + ;
                                                                'FORMINCLUDE ' + US_ShortName( US_FileNameOnlyPath( ChgPathToReal( GetProperty( "VentanaMain" , "GPanFiles" , "Cell" , nGridPanLastRow , NCOLPANFULLNAME ) ) ) ) + HB_OsNewLine() + ;
                                                                'FORM ' + US_FileNameOnlyName( ChgPathToReal( GetProperty( "VentanaMain" , "GPanFiles" , "Cell" , nGridPanLastRow , NCOLPANFULLNAME ) ) ) )
   QPM_MemoWrit( US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + '_'+PUB_cSecu+'RunView.bat' , US_ShortName( PUB_cQPM_Folder ) + DEF_SLASH + "US_VIEW_" + GetHarbourSuffix() + GetMiniGuiSuffix() + ".EXE " + US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + '_' + PUB_cSecu + 'RunViewForm.Cng' )
   QPM_Execute( US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + '_'+PUB_cSecu+'RunView.bat' , , DEF_QPM_EXEC_WAIT , DEF_QPM_EXEC_HIDE )
// ferase( US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + '_'+PUB_cSecu+'RunView.bat' )
Return .T.

Function QPM_Timer_Edit()
   Local i:=0 , FechaCnt := 0
   For i:=1 to VentanaMain.GPrgFiles.ItemCount
      if !empty( GetProperty( "VentanaMain" , "GPrgFiles" , "Cell" , i , NCOLPRGEDIT ) )
         if !file( GetProperty( "VentanaMain" , "GPrgFiles" , "Cell" , i , NCOLPRGEDIT ) )
            FechaCnt := val( Right( US_FileNameOnlyName( GetProperty( "VentanaMain" , "GPrgFiles" , "Cell" , i , NCOLPRGEDIT ) ) , 16 ) )
            SetProperty( "VentanaMain" , "GPrgFiles" , "Cell" , i , NCOLPRGEDIT , "" )
            GridImage( "VentanaMain" , "GPrgFiles" , i , NCOLPRGSTATUS , "-" , PUB_nGridImgEdited )
            if FechaCnt < val( US_FileDateTime( ChgPathToReal( GetProperty( "VentanaMain" , "GPrgFiles" , "Cell" , i , NCOLPRGFULLNAME ) ) ) + "00" )
               QPM_Wait( "RichEditDisplay( 'PRG' , .T. , " + str( i ) + ")" , "Reloading..." )
#ifdef QPM_HOTRECOVERY
               QPM_Wait( "QPM_HotRecovery( 'ADD' , 'EDIT' , 'SRC' , '" + GetProperty( "VentanaMain" , "GPrgFiles" , "Cell" , i , NCOLPRGFULLNAME ) + "' , '" + GetProperty( "VentanaMain" , "GPrgFiles" , "Cell" , i , NCOLPRGRECOVERY ) + "' )" , "Creating Version File for Hot Recovery..." )
               SetProperty( "VentanaMain" , "GPrgFiles" , "Cell" , i , NCOLPRGRECOVERY , "" )
               if _IsControlDefined( "HR_GridItemTargetPRG" , "WinHotRecovery" ) .and. ;
                  i == GetProperty( "WinHotRecovery" , "HR_GridItemTargetPRG" , "value" )
                  eval( { || if( !bPrgSorting .and. !PUB_bLite , if( HR_bNumberOnPrg , QPM_Wait( "QPM_HotChangeGrid( 'TARGET' , 'ITEM' , 'PRG' )" , "Comparing" ) , QPM_HotChangeGrid( 'TARGET' , 'ITEM' , 'PRG' ) ) , US_NOP() ) } )
               endif
#endif
            else
               VentanaMain.RichEditPrg.BackColor := DEF_COLORBACKPRG
#ifdef QPM_HOTRECOVERY
               ferase( GetProperty( "VentanaMain" , "GPrgFiles" , "Cell" , i , NCOLPRGRECOVERY ) )
               SetProperty( "VentanaMain" , "GPrgFiles" , "Cell" , i , NCOLPRGRECOVERY , "" )
#endif
            endif
#ifdef QPM_HOTRECOVERY
            if _IsControlDefined( "HR_GridItemTargetPRG" , "WinHotRecovery" )
               GridImage( "WinHotRecovery" , "HR_GridItemTargetPRG" , i , DEF_N_ITEM_COLIMAGE , "-" , PUB_nGridImgEdited )
            endif
#endif
         endif
      endif
   Next i

   For i:=1 to VentanaMain.GHeaFiles.ItemCount
      if !empty( GetProperty( "VentanaMain" , "GHeaFiles" , "Cell" , i , NCOLHEAEDIT ) )
         if !file( GetProperty( "VentanaMain" , "GHeaFiles" , "Cell" , i , NCOLHEAEDIT ) )
            FechaCnt := val( Right( US_FileNameOnlyName( GetProperty( "VentanaMain" , "GHeaFiles" , "Cell" , i , NCOLHEAEDIT ) ) , 16 ) )
            SetProperty( "VentanaMain" , "GHeaFiles" , "Cell" , i , NCOLHEAEDIT , "" )
            GridImage( "VentanaMain" , "GHeaFiles" , i , NCOLHEASTATUS , "-" , PUB_nGridImgEdited )
            if FechaCnt < val( US_FileDateTime( ChgPathToReal( GetProperty( "VentanaMain" , "GHeaFiles" , "Cell" , i , NCOLHEAFULLNAME ) ) ) + "00" )
               QPM_Wait( "RichEditDisplay( 'HEA' , .T. , " + str( i ) + ")" , "Reloading..." )
#ifdef QPM_HOTRECOVERY
               QPM_Wait( "QPM_HotRecovery( 'ADD' , 'EDIT' , 'HEA' , '" + GetProperty( "VentanaMain" , "GHeaFiles" , "Cell" , i , NCOLHEAFULLNAME ) + "' , '" + GetProperty( "VentanaMain" , "GHeaFiles" , "Cell" , i , NCOLHEARECOVERY ) + "' )" , "Creating Version File for Hot Recovery..." )
               SetProperty( "VentanaMain" , "GHeaFiles" , "Cell" , i , NCOLHEARECOVERY , "" )
               if _IsControlDefined( "HR_GridItemTargetHea" , "WinHotRecovery" ) .and. ;
                  i == GetProperty( "WinHotRecovery" , "HR_GridItemTargetHea" , "value" )
                  eval( { || if( !bHeaSorting .and. !PUB_bLite , if( HR_bNumberOnHea , QPM_Wait( "QPM_HotChangeGrid( 'TARGET' , 'ITEM' , 'HEA' )" , "Comparing" ) , QPM_HotChangeGrid( 'TARGET' , 'ITEM' , 'HEA' ) ) , US_NOP() ) } )
               endif
#endif
            else
               VentanaMain.RichEditHea.BackColor := DEF_COLORBACKHEA
#ifdef QPM_HOTRECOVERY
               ferase( GetProperty( "VentanaMain" , "GHeaFiles" , "Cell" , i , NCOLHEARECOVERY ) )
               SetProperty( "VentanaMain" , "GHeaFiles" , "Cell" , i , NCOLHEARECOVERY , "" )
#endif
            endif
#ifdef QPM_HOTRECOVERY
            if _IsControlDefined( "HR_GridItemTargetHea" , "WinHotRecovery" )
               GridImage( "WinHotRecovery" , "HR_GridItemTargetHea" , i , DEF_N_ITEM_COLIMAGE , "-" , PUB_nGridImgEdited )
            endif
#endif
         endif
      endif
   Next i

   For i:=1 to VentanaMain.GPanFiles.ItemCount
      if !empty( GetProperty( "VentanaMain" , "GPanFiles" , "Cell" , i , NCOLPANEDIT ) )
         if !file( GetProperty( "VentanaMain" , "GPanFiles" , "Cell" , i , NCOLPANEDIT ) )
            FechaCnt := val( Right( US_FileNameOnlyName( GetProperty( "VentanaMain" , "GPanFiles" , "Cell" , i , NCOLPANEDIT ) ) , 16 ) )
            SetProperty( "VentanaMain" , "GPanFiles" , "Cell" , i , NCOLPANEDIT , "" )
            GridImage( "VentanaMain" , "GPanFiles" , i , NCOLPANSTATUS , "-" , PUB_nGridImgEdited )
            if FechaCnt < val( US_FileDateTime( ChgPathToReal( GetProperty( "VentanaMain" , "GPanFiles" , "Cell" , i , NCOLPANFULLNAME ) ) ) + "00" )
               QPM_Wait( "RichEditDisplay( 'PAN' , .T. , " + str( i ) + ")" , "Reloading..." )
#ifdef QPM_HOTRECOVERY
               QPM_Wait( "QPM_HotRecovery( 'ADD' , 'EDIT' , 'PAN' , '" + GetProperty( "VentanaMain" , "GPanFiles" , "Cell" , i , NCOLPANFULLNAME ) + "' , '" + GetProperty( "VentanaMain" , "GPanFiles" , "Cell" , i , NCOLPANRECOVERY ) + "' )" , "Creating Version File for Hot Recovery..." )
               SetProperty( "VentanaMain" , "GPanFiles" , "Cell" , i , NCOLPANRECOVERY , "" )
               if _IsControlDefined( "HR_GridItemTargetPAN" , "WinHotRecovery" ) .and. ;
                  i == GetProperty( "WinHotRecovery" , "HR_GridItemTargetPAN" , "value" )
                  eval( { || if( !bPanSorting .and. !PUB_bLite , if( HR_bNumberOnPan , QPM_Wait( "QPM_HotChangeGrid( 'TARGET' , 'ITEM' , 'PAN' )" , "Comparing" ) , QPM_HotChangeGrid( 'TARGET' , 'ITEM' , 'PAN' ) ) , US_NOP() ) } )
               endif
#endif
            else
               VentanaMain.RichEditPan.BackColor := DEF_COLORBACKPAN
#ifdef QPM_HOTRECOVERY
               ferase( GetProperty( "VentanaMain" , "GPanFiles" , "Cell" , i , NCOLPANRECOVERY ) )
               SetProperty( "VentanaMain" , "GPanFiles" , "Cell" , i , NCOLPANRECOVERY , "" )
#endif
            endif
#ifdef QPM_HOTRECOVERY
            if _IsControlDefined( "HR_GridItemTargetPan" , "WinHotRecovery" )
               GridImage( "WinHotRecovery" , "HR_GridItemTargetPan" , i , DEF_N_ITEM_COLIMAGE , "-" , PUB_nGridImgEdited )
            endif
#endif
         endif
      endif
   Next i

   For i:=1 to VentanaMain.GDbfFiles.ItemCount
      if !empty( GetProperty( "VentanaMain" , "GDbfFiles" , "Cell" , i , NCOLDBFEDIT ) )
         if !file( GetProperty( "VentanaMain" , "GDbfFiles" , "Cell" , i , NCOLDBFEDIT ) )
            FechaCnt := val( Right( US_FileNameOnlyName( GetProperty( "VentanaMain" , "GDbfFiles" , "Cell" , i , NCOLDBFEDIT ) ) , 16 ) )
            SetProperty( "VentanaMain" , "GDbfFiles" , "Cell" , i , NCOLDBFEDIT , "" )
            GridImage( "VentanaMain" , "GDbfFiles" , i , NCOLDBFSTATUS , "-" , PUB_nGridImgEdited )
            if VentanaMain.GDbfFiles.Value == i
               QPM_Wait( "RichEditDisplay( 'DBF' , .T. , " + str( i ) + ")" , "Reloading..." )
            endif
         endif
      endif
   Next i
Return .T.

Function CloseDbfAutoView()
   if select( "DbfAlias" ) > 0
      DBSelectarea( "DbfAlias" )
      DBCloseArea( "DbfAlias" )
   endif
   if _IsControlDefined( "DbfBrowse" , "VentanaMain" )
      VentanaMain.DbfBrowse.Release()
   endif
Return .T.

Function DefineRichEditForNotDbfView( cTxt )

   if !( _IsControlDefined( "DbfAutoView" , "VentanaMain" ) )
      @ GetDesktopRealHeight() - int( ( GetDesktopRealHeight() * 72 ) / 100 ) , 10 EDITBOX DbfAutoView ;
         OF VentanaMain ;
         WIDTH 0 ;
         HEIGHT 0 ;
         READONLY        ;
         FONT            'Courier New' ;
         SIZE            9 ;
         NOVSCROLL         ;
         NOHSCROLL

      VentanaMain.TabFiles.AddControl( "DbfAutoView" , nPageDbf , GetDesktopRealHeight() - int( ( GetDesktopRealHeight() * 72 ) / 100 ) , 10 )
      VentanaMain.DbfAutoView.Width  := GetDesktopRealWidth() - 364
      VentanaMain.DbfAutoView.Height := ( GetDesktopRealHeight() - 237 ) - ( GetDesktopRealHeight() - int( ( GetDesktopRealHeight() * 72 ) / 100 ) )
   endif
   VentanaMain.DbfAutoView.Value := HB_OsNewLine() + ;
                                    HB_OsNewLine() + ;
                                    HB_OsNewLine() + ;
                                    HB_OsNewLine() + ;
                                    HB_OsNewLine() + ;
                                    HB_OsNewLine() + ;
                                    "               "+cTxt
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
   Local r , i , cont:=0
   If ( r := AScan( vLastOpen , { |x| us_upper( x ) == us_upper( cPrj ) } ) ) > 0
      vLastOpen[r] := ""
   else
      aeval( vLastOpen , { |x| if( !empty( x ) , cont++ , ) } )
      if cont > 19  // Tope de menu Items para proyectos abiertos anteriormente
         For i:=1 to len( vLastOpen )
            if !empty( vLastOpen[i] )
               vLastOpen[ i ] := ""
               exit
            endif
         next
      endif
   endif
   aadd( vLastOpen , cPrj )
Return .T.

FUNCTION LocalSearchContinue()
   Private RPTA:="" , ;
           Ventana:=US_WindowNameRandom("Next")

   DEFINE WINDOW &(Ventana) ;
      AT 0,0 ;
      WIDTH 265 ;
      HEIGHT 175 ;
      TITLE "Continue DBF Data Search" ;
      MODAL ;
      NOSYSMENU ;
      FONT "ARIAL" SIZE 10 ;
      ON RELEASE US_NOP()

      DEFINE LABEL LContinue
             ROW       12
             COL       20
             WIDTH     240
             VALUE     'Continue DBF Data Search at NEXT:'
      END LABEL

      DEFINE BUTTON BPosition
              ROW     40
              COL     20
              WIDTH   65
              HEIGHT  25
              CAPTION "Position"
              ACTION ( RPTA := "P" , DoMethod( Ventana , "Release" ) )
              TOOLTIP 'Next occurs beginning in the last text found'
      END BUTTON

      DEFINE BUTTON BField
              ROW     40
              COL     100
              WIDTH   65
              HEIGHT  25
              CAPTION "Column"
              ACTION ( RPTA := "F" , DoMethod( Ventana , "Release" ) )
              TOOLTIP 'Next occurs beginning in the next column'
      END BUTTON

      DEFINE BUTTON BRecord
              ROW     40
              COL     180
              WIDTH   65
              HEIGHT  25
              CAPTION "Record"
              ACTION ( RPTA := "R" , DoMethod( Ventana , "Release" ) )
              TOOLTIP 'Next occurs beginning in the next Record'
      END BUTTON

      DEFINE CHECKBOX Check_Continue
              CAPTION         "Remember my election"
              ROW             70
              COL             50
              WIDTH           185
              VALUE           .F.
              TOOLTIP "Do not ask this question until next DBF Date Search from the beginning"
              ON CHANGE       ( bDbfDataSearchAsk := ! ( GetProperty( Ventana , "Check_Continue" , "value" ) ) )
      END CHECKBOX

      DEFINE BUTTON BCancel
              ROW     110
              COL     90
              WIDTH   85
              HEIGHT  25
              CAPTION "Cancel"
              ACTION ( RPTA := "" , DoMethod( Ventana , "Release" ) )
              TOOLTIP 'Cancel Search'
      END BUTTON

   END WINDOW

   CENTER WINDOW &Ventana

   ACTIVATE WINDOW &Ventana

Return RPTA

Function CargoSearch()
   aeval( vLastSearch , { |x| VentanaMain.CSearch.AddItem( x ) } )
Return nil

Function QPM_DefinoMainMenu()
   Local i , cAux , r_Null
   DEFINE MAIN MENU OF VentanaMain
           POPUP '&File     '
                   ITEM '&Open/New'        ACTION QPM_OpenProject()
                   ITEM '&Save'            ACTION QPM_SaveProject()
                   ITEM 'Save &As...'      ACTION QPM_SaveAsProject()
                   if len( vLastOpen ) > 0
                      SEPARATOR
                   endif
                   For i := len( vLastOpen ) to 1 step -1
                       if !empty( vLastOpen[i] )
                          cAux := 'QPM_OpenProject( "' + vLastOpen[i] + '" )'
// _DefineMenuItem ( <caption> , <{action}> , <"name"> , <image> , <.checked.> , <.disabled.> , <message> )
                          r_Null := &( "_DefineMenuItem( vLastOpen[" + str(i) + "] , {|| " + cAux + " } , , if( file( vLastOpen[" + str(i) + "] ) , 'GridTilde' , 'GridEquis' ) )" )
                       endif
                   next
                   if len( vLastOpen ) > 0
                      SEPARATOR
                      ITEM '&Clear list'            ACTION QPM_ClearLastOpenList()
                   endif
                   SEPARATOR
                   ITEM '&Exit'            ACTION QPM_Exit()
           END POPUP
           POPUP '&Edit     '
#ifdef QPM_SHG
                   ITEM '&Copy'            ACTION SHG_Send_Copy()      NAME ItC_CopyM
                   ITEM 'C&ut'             ACTION SHG_Send_Cut()       NAME ItC_CutM
                   ITEM '&Paste'           ACTION SHG_Send_Paste()     NAME ItC_PasteM
#else
                   ITEM '&Copy'            ACTION US_Send_Copy()      NAME ItC_CopyM
                   ITEM 'C&ut'             ACTION US_Send_Cut()       NAME ItC_CutM
                   ITEM '&Paste'           ACTION US_Send_Paste()     NAME ItC_PasteM
#endif
                   ITEM '&Select All'      ACTION QPM_Send_SelectAll()
           END POPUP
           POPUP '&Debug     '
                   ITEM '&Build'           ACTION ( bBuildRun := .F. , QPM_Build() )
                   ITEM 'B&uild and Run'   ACTION ( bBuildRun := .T. , QPM_Build() )
                   ITEM '&Run'             ACTION ( bRunParm := .F. , QPM_Run( bRunParm ) )
                   ITEM 'Run With &Parm'   ACTION ( bRunParm := .T. , QPM_Run( bRunParm ) )
                   SEPARATOR
                   ITEM '&Debug'           ACTION SwitchDebug() NAME DEBUG
           END POPUP
           POPUP '&Settings     '
                   ITEM PUB_MenuPrjOptions ACTION ProjectSettings()
                   SEPARATOR
                   ITEM PUB_MenuGblOptions ACTION GlobalSettings()
#ifdef QPM_HOTRECOVERYWINDOW
                   SEPARATOR
                   ITEM 'Hot Recovery &Options'  ACTION QPM_HotRecoveryOptions()
#endif
                   SEPARATOR
                   ITEM 'Compress QPM Utilities'  ACTION QPM_CompressUtilities()
                   ITEM 'Decompress QPM Utilities'  ACTION QPM_DecompressUtilities()
           END POPUP

#ifdef QPM_HOTRECOVERYWINDOW
           POPUP '&Recovery     '
                   ITEM '&Hot Recovery'          ACTION QPM_HotRecoveryMenu()
                   SEPARATOR
                   ITEM 'Hot Recovery &Options'  ACTION QPM_HotRecoveryOptions()
                   SEPARATOR
                   ITEM '&Import Versions from Another Hot Recovery Database'  ACTION HotRecoveryImport()
                   SEPARATOR
                   ITEM '&Reindex Hot Recovery Database'  ACTION QPM_Wait( "HotRecoveryReindex()" , "Reindexing Hot Recovery Database" )
#ifdef QPM_SYNCRECOVERY
                   SEPARATOR
                   ITEM '&Sync Point Recovery'   ACTION QPM_SyncRecoveryMenu()
#endif
           END POPUP
#else
#ifdef QPM_SYNCRECOVERY
           POPUP '&Recovery     '
                   ITEM '&Sync Point Recovery'   ACTION QPM_SyncRecoveryMenu()
           END POPUP
#endif
#endif
           POPUP '&Help     '
                   ITEM 'QPM &Help'        ACTION US_DisplayHelpTopic( GetActiveHelpFile() , 1 )
                   SEPARATOR
                   ITEM '&About'           ACTION QPM_About()
                   SEPARATOR
                   ITEM '&License'         ACTION QPM_Licence()
           END POPUP
           POPUP '&Links     '
                   ITEM "Go To topic Link in Help"       ACTION US_DisplayHelpTopic( GetActiveHelpFile() , "links" )
                   ITEM "Go To QPM Home Site: "+PUB_cQPM_Support_Link            ACTION ShellExecute(0, "open", "rundll32.exe", "url.dll,FileProtocolHandler " + PUB_cQPM_Support_Link    , ,1)
           END POPUP
           POPUP '&OnlyForSupport     '
                   ITEM "Record Activity in Log "+PUB_cQPM_Folder+DEF_SLASH + "QPM.log" ACTION ( bLogActivity := !bLogActivity , VentanaMain.MLog.Checked := bLogActivity ) NAME MLog
                   ITEM "Clear Log File "+PUB_cQPM_Folder+DEF_SLASH + "QPM.log" ACTION ClearLog()
                   ITEM "View Log File "+PUB_cQPM_Folder+DEF_SLASH + "QPM.log" ACTION ViewLog()
                   SEPARATOR
                   ITEM "Do not delete auxiliary files" ACTION ( PUB_DeleteAux := ! PUB_DeleteAux, VentanaMain.MDelete.Checked := ! PUB_DeleteAux ) NAME MDelete
                   SEPARATOR
                   ITEM "Go To QPM Home Site: "+PUB_cQPM_Support_Link            ACTION ShellExecute(0, "open", "rundll32.exe", "url.dll,FileProtocolHandler " + PUB_cQPM_Support_Link    , ,1)
                   ITEM '&Mail to QPM_Support <'+PUB_cQPM_Support_eMail+'>...' ACTION ShellExecute(0, "open", "rundll32.exe", ;
                                     "url.dll,FileProtocolHandler " + ;
                                     "mailto:"+PUB_cQPM_Support_eMail+"?cc=&bcc=" + ;
                                     "&subject="+PUB_cQPM_Title + ;
                                     "&body=Thank%20for%20use%20"+PUB_cQPM_Title+"", , 1)
           END POPUP
   END MENU

   RELEASE CONTROL ToolBar_1 OF VentanaMain

   DEFINE TOOLBAR ToolBar_1 OF VentanaMain BUTTONSIZE 50,35 FLAT

          BUTTON OPEN             ;
                  CAPTION 'Open/New'  ;
                  PICTURE 'open'  ;
                  ACTION QPM_OpenProject() ;
                  SEPARATOR ;
                  AUTOSIZE ;
                  DROPDOWN

                  DEFINE DROPDOWN MENU BUTTON OPEN OF VentanaMain
                         ITEM 'Open/New'        ACTION QPM_OpenProject()
                         SEPARATOR
                         For i := len( vLastOpen ) to 1 step -1
                            if !empty( vLastOpen[i] )
                               cAux := 'QPM_OpenProject( "' + vLastOpen[i] + '" )'
// _DefineMenuItem ( <caption> , <{action}> , <"name"> , <image> , <.checked.> , <.disabled.> , <message> )
                               r_Null := &( "_DefineMenuItem( vLastOpen[" + str(i) + "] , {|| " + cAux + " } , , if( file( vLastOpen[" + str(i) + "] ) , 'GridTilde' , 'GridEquis' ) )" )
                            endif
                         next
                  END MENU

          BUTTON SAVE             ;
                  CAPTION 'Save'  ;
                  PICTURE 'save'  ;
                  ACTION QPM_SaveProject() ;
                  SEPARATOR ;
                  AUTOSIZE ;
                  DROPDOWN

                  DEFINE DROPDOWN MENU BUTTON SAVE OF VentanaMain
                         ITEM 'Save'       ACTION QPM_SaveProject()
                         ITEM 'Save As'    ACTION QPM_SaveAsProject()
                  END MENU

          BUTTON BUILD            ;
                  CAPTION 'Build' ;
                  PICTURE 'build' ;
                  ACTION QPM_Build() ;
                  SEPARATOR ;
                  AUTOSIZE ;
                  DROPDOWN

                  DEFINE DROPDOWN MENU BUTTON BUILD OF VentanaMain
                         ITEM 'Build'                 ACTION ( bBuildRun := .F. , QPM_Build() )
                         ITEM 'Build and Run'         ACTION ( bBuildRun := .T. , QPM_Build() ) NAME bDropDownBandR
                  END MENU

          BUTTON RUN              ;
                  CAPTION 'Run'   ;
                  PICTURE 'run'   ;
                  ACTION QPM_Run( bRunParm ) ;
                  SEPARATOR ;
                  AUTOSIZE ;
                  DROPDOWN

                  DEFINE DROPDOWN MENU BUTTON RUN OF VentanaMain
                         ITEM 'Run'                 ACTION ( bRunParm := .F. , QPM_Run( bRunParm ) )
                         ITEM 'Run With Parm'       ACTION ( bRunParm := .T. , QPM_Run( bRunParm ) )
                  END MENU

          BUTTON HELP             ;
                  CAPTION 'Help'  ;
                  PICTURE 'help'  ;
                  ACTION  US_DisplayHelpTopic( GetActiveHelpFile() , 1 )  ;
                  SEPARATOR

  END TOOLBAR

Return .T.

Function GetPrjVersion()
Return PadL( GetProperty( "VentanaMain" , "LVerVerNum" , "value" ) , DEF_LEN_VER_VERSION , "0" ) + PadL( GetProperty( "VentanaMain" , "LVerRelNum" , "value" ) , DEF_LEN_VER_RELEASE , "0" ) + PadL( GetProperty( "VentanaMain" , "LVerBuiNum" , "value" ) , DEF_LEN_VER_BUILD , "0" )

Function US_GetFile( aFilter, title, cIniFolder, multiselect, nochangedir )
   Local reto
   SetMGWaitHide()
   Reto := US_GetFile2( aFilter, title, cIniFolder, multiselect, nochangedir )
   SetMGWaitShow()
Return reto

Function US_GetFile2( aFilter, title, cIniFolder, multiselect, nochangedir )
   local c := ''
   local cfiles := ''
   local fileslist := {}
   local n
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
      Return ( US_C_GetFile ( c , title, cIniFolder, multiselect ,nochangedir ) )
   else
      cfiles := US_C_GetFile ( c , title, cIniFolder, multiselect ,nochangedir )
      if len( cfiles ) > 0
         if valtype( cfiles ) == "A"
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

//================================================================================================//
//- INI Funciones para compatibilidad ------------------------------------------------------------//
//------------------------------------------------------------------------------------------------//
Function VP_TITLEBAR()
   MsgInfo( "La funcion VP_TITLEBAR fue reemplazada por Nula en QPM.PRG" )
Return .T.
Function VP_STATUSBAR()
   MsgInfo( "La funcion VP_STATUSBAR fue reemplazada por Nula en QPM.PRG" )
Return .T.
/*
Function VP_MGWAIT()
   MsgInfo( "La funcion VP_MGWAIT fue reemplazada por Nula en QPM.PRG" )
Return .T.
Function RN_ONGOTFOCUS()
   MsgInfo( "La funcion RN_ONGOTFOCUS fue reemplazada por Nula en QPM.PRG" )
Return .T.
Function US_MP3()
   MsgInfo( "La funcion "+procname()+" fue reemplazada por Nula en QPM.PRG" )
Return .T.
*/
//------------------------------------------------------------------------------------------------//
//- FIN Funciones para compatibilidad ------------------------------------------------------------//
//================================================================================================//

Function QPM_CompressUtilities()
   Local i, Out

   QPM_Execute( PUB_cQPM_Folder + DEF_SLASH + 'US_UPX.EXE ' + US_ShortName(PUB_cQPM_Folder) + DEF_SLASH + "US_RUN.EXE", "", DEF_QPM_EXEC_NOWAIT, DEF_QPM_EXEC_HIDE )
   DO EVENTS

   Out := "@ECHO OFF" + hb_osnewline()
   Out += "COPY " + US_ShortName(PUB_cQPM_Folder) + DEF_SLASH + "US_UPX.EXE " + US_ShortName(PUB_cQPM_Folder) + DEF_SLASH + "XYZ_UPX.EXE" + hb_osnewline()
   For i := 1 to len(vExeList)
      do case
      case ! upper(right(vExeList[i], 4)) == ".EXE"
      case upper(right(vExeList[i], 7)) == "QPM.EXE"
      case upper(right(vExeList[i], 10)) == "US_RUN.EXE"
      case upper(right(vExeList[i], 13)) == "US_IMPDEF.EXE"
      case upper(right(vExeList[i], 15)) == "US_PEXPORTS.EXE"
      case upper(right(vExeList[i], 12)) == "US_REIMP.EXE"
      case upper(right(vExeList[i], 13)) == "US_IMPLIB.EXE"
      case upper(right(vExeList[i], 14)) == "US_DLLTOOL.EXE"
      case upper(right(vExeList[i], 14)) == "US_OBJDUMP.EXE"
      case upper(right(vExeList[i], 12)) == "US_TDUMP.EXE"
      otherwise
         Out += US_ShortName(PUB_cQPM_Folder) + DEF_SLASH + "XYZ_UPX.EXE --no-progress " + vExeList[i] + hb_osnewline()
      endcase
   Next
   Out += "DEL " + US_ShortName(PUB_cQPM_Folder) + DEF_SLASH + "XYZ_UPX.EXE" + hb_osnewline()
//   Out += "PAUSE" + hb_osnewline()

   QPM_MemoWrit( PUB_cQPM_Folder + DEF_SLASH + 'Compress.bat', Out )
   QPM_Execute( PUB_cQPM_Folder + DEF_SLASH + 'Compress.bat', "", DEF_QPM_EXEC_WAIT, DEF_QPM_EXEC_NORMAL )

   MsgInfo("Compression finished !!!" + hb_osnewline() + ;
           "To compress QPM.EXE, close it first and do it manually using:" + hb_osnewline() + ;
           "us_upx QPM.EXE")
Return Nil

Function QPM_DecompressUtilities()
   Local i, Out

   QPM_Execute( PUB_cQPM_Folder + DEF_SLASH + 'US_UPX.EXE -d ' + US_ShortName(PUB_cQPM_Folder) + DEF_SLASH + "US_RUN.EXE", "", DEF_QPM_EXEC_NOWAIT, DEF_QPM_EXEC_HIDE )
   DO EVENTS

   Out := "@ECHO OFF" + hb_osnewline()
   Out += "COPY " + US_ShortName(PUB_cQPM_Folder) + DEF_SLASH + "US_UPX.EXE " + US_ShortName(PUB_cQPM_Folder) + DEF_SLASH + "XYZ_UPX.EXE" + hb_osnewline()
   For i := 1 to len(vExeList)
      do case
      case ! upper(right(vExeList[i], 4)) == ".EXE"
      case upper(right(vExeList[i], 7)) == "QPM.EXE"
      case upper(right(vExeList[i], 10)) == "US_RUN.EXE"
      case upper(right(vExeList[i], 13)) == "US_IMPDEF.EXE"
      case upper(right(vExeList[i], 15)) == "US_PEXPORTS.EXE"
      case upper(right(vExeList[i], 12)) == "US_REIMP.EXE"
      case upper(right(vExeList[i], 13)) == "US_IMPLIB.EXE"
      case upper(right(vExeList[i], 14)) == "US_DLLTOOL.EXE"
      case upper(right(vExeList[i], 14)) == "US_OBJDUMP.EXE"
      case upper(right(vExeList[i], 12)) == "US_TDUMP.EXE"
      otherwise
         Out += US_ShortName(PUB_cQPM_Folder) + DEF_SLASH + "XYZ_UPX.EXE -d --no-progress " + vExeList[i] + hb_osnewline()
      endcase
   Next
   Out += "DEL " + US_ShortName(PUB_cQPM_Folder) + DEF_SLASH + "XYZ_UPX.EXE" + hb_osnewline()
//   Out += "PAUSE" + hb_osnewline()

   QPM_MemoWrit( PUB_cQPM_Folder + DEF_SLASH + 'Decompress.bat', Out )

   QPM_Execute( PUB_cQPM_Folder + DEF_SLASH + 'Decompress.bat', "", DEF_QPM_EXEC_WAIT, DEF_QPM_EXEC_NORMAL )

   MsgInfo("Decompression finished !!!" + hb_osnewline() + ;
           "To decompress QPM.EXE, close it first and do it manually using:" + hb_osnewline() + ;
           "us_upx -d QPM.EXE")
Return nil

/* eof */
