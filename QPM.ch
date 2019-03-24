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

#include "US_Env.h"

// String related defines
#define DBLQT '"'
#define SNGQT "'"

// Project version
#define DEF_LEN_VER_VERSION        2
#define DEF_LEN_VER_RELEASE        2
#define DEF_LEN_VER_BUILD          4

// QPM version
#define QPM_VERSION_NUMBER_MAYOR   '05'
#define QPM_VERSION_NUMBER_MINOR   '05'
#define QPM_VERSION_NUMBER_BUILD   '08'
#define QPM_VERSION_NUMBER_SHORT   ( QPM_VERSION_NUMBER_MAYOR + QPM_VERSION_NUMBER_MINOR + QPM_VERSION_NUMBER_BUILD )
#define QPM_VERSION_NUMBER_LONG    ( QPM_VERSION_NUMBER_MAYOR + QPM_VERSION_NUMBER_MINOR + "00" + QPM_VERSION_NUMBER_BUILD )
#define QPM_VERSION_DISPLAY_SHORT  ( QPM_VERSION_NUMBER_MAYOR + "." + QPM_VERSION_NUMBER_MINOR + '.' + QPM_VERSION_NUMBER_BUILD )
#define QPM_VERSION_DISPLAY_LONG   ( 'v' + QPM_VERSION_NUMBER_MAYOR + "." + QPM_VERSION_NUMBER_MINOR + ' Build ' + QPM_VERSION_NUMBER_BUILD )
#define QPM_VERSION_NUMBER         ( QPM_VERSION_NUMBER_MAYOR + " " + QPM_VERSION_NUMBER_MINOR + " " + QPM_VERSION_NUMBER_BUILD )
#define QPM_VERSION_NUMBER_EXT     ( QPM_VERSION_NUMBER_MAYOR + " " + QPM_VERSION_NUMBER_MINOR + " 00" + QPM_VERSION_NUMBER_BUILD )

// QPM modules
#define QPM_SHG
#define QPM_KILLER
#define QPM_HOTRECOVERY
#define QPM_HOTRECOVERYWINDOW
//#define QPM_SYNCRECOVERY

// Pseudo-functions
#translate MsgStop( <txt> )        => MyMsg( "QPM - Error",   US_VarToStr( <txt> ), "E", bAutoExit )
#translate MsgWarn( <txt> )        => MyMsg( "QPM - Warning", US_VarToStr( <txt> ), "W", bAutoExit )
#translate MsgInfo( <txt> )        => MyMsg( "QPM - Info",    US_VarToStr( <txt> ), "N", bAutoExit )
#translate DEFAULT <var> TO <val>  => if( <var> == NIL, <var> := <val>, NIL )

// Colors
#define DEF_COLORWHITE             { 255, 255, 255 }
#define DEF_COLORYELLOW            { 242, 242, 000 }
#define DEF_COLORRED               { 228, 022, 058 }
#define DEF_COLORGREENCLARO        { 183, 231, 175 }
#define DEF_COLORGREEN             { 041, 135, 049 }
#define DEF_COLORBLUE              { 000, 000, 255 }
#define DEF_COLORBLACK             { 000, 000, 000 }
#define DEF_COLORFONTEXTERNALEDIT  { 216, 183, 137 }
#define DEF_COLORBACKEXTERNALEDIT  { 215, 130, 155 }
#define DEF_COLORBACKPPO           { 192, 192, 192 }
#define DEF_COLORFONTVIEW          { 000, 000, 000 }
#define DEF_COLORBACKPRG           { 226, 241, 241 }
#define DEF_COLORBACKHEA           { 255, 236, 236 }
#define DEF_COLORBACKPAN           { 234, 255, 244 }
#define DEF_COLORBACKDBF           { 255, 238, 230 }
#define DEF_COLORBACKDBFSEARCHOK   { 046, 186, 143 }
#define DEF_COLORBACKINC           { 234, 244, 255 }
#define DEF_COLORBACKEXC           { 229, 229, 229 }
#define DEF_COLORBACKHLP           { 255, 252, 234 }
#define DEF_COLORDLL               { 228, 207, 177 }
#define DEF_COLORLIB               { 221, 233, 220 }
#define DEF_COLOREXE               { 188, 219, 240 }
#define DEF_COLORFONTPPO           DEF_COLORWHITE
#define DEF_COLORBACKOUT           DEF_COLORWHITE
#define DEF_COLORBACKSYSOUT        DEF_COLORWHITE

// Open modes
#DEFINE DEF_DBF_SHARED             .T.
#DEFINE DEF_DBF_EXCLUSIVE          .F.
#DEFINE DEF_DBF_READ               .T.
#DEFINE DEF_DBF_WRITE              .F.

// Execute modes
#DEFINE DEF_QPM_EXEC_WAIT          .T.
#DEFINE DEF_QPM_EXEC_NOWAIT        .F.
#DEFINE DEF_QPM_EXEC_HIDE          -1
#DEFINE DEF_QPM_EXEC_MINIMIZE      0
#DEFINE DEF_QPM_EXEC_NORMAL        1
#DEFINE DEF_QPM_EXEC_MAXIMIZE      2

// MiniGuis suffixes
#DEFINE DEF_MG_MINIGUI1            M1
#DEFINE DEF_MG_MINIGUI3            M3
#DEFINE DEF_MG_EXTENDED1           E1
#DEFINE DEF_MG_OOHG3               O3

// [x]Harbour suffixes
#DEFINE DEF_MG_HARBOUR             H
#DEFINE DEF_MG_XHARBOUR            X
#DEFINE DEF_MG_CLIP                C

// Cpp suffixes
#DEFINE DEF_MG_BORLAND             B
#DEFINE DEF_MG_MINGW               G
#DEFINE DEF_MG_PELLES              P
#DEFINE DEF_MG_VC                  V

// Bits suffixes
#DEFINE DEF_MG_32                  _32
#DEFINE DEF_MG_64                  _64

// RadioGroups items
#define DEF_RG_HARBOUR             1
#define DEF_RG_XHARBOUR            2
#define DEF_RG_BORLAND             1
#define DEF_RG_MINGW               2
#define DEF_RG_PELLES              3
#define DEF_RG_MINIGUI1            1
#define DEF_RG_MINIGUI3            2
#define DEF_RG_EXTENDED1           3
#define DEF_RG_OOHG3               4
#define DEF_RG_EXE                 1
#define DEF_RG_LIB                 2
#define DEF_RG_IMPORT              3
#define DEF_RG_NONE                1
#define DEF_RG_COPY                2
#define DEF_RG_MOVE                3
#define DEF_RG_NEWNAME             2
#define DEF_RG_EDITOR              1
#define DEF_RG_HMI                 2
#define DEF_RG_HMGS                3
#define DEF_RG_DBFTOOL             1
#define DEF_RG_OTHER               2

// Symbols table for ActiveX
#define s_Events_Notify            0
#define s_GridForeColor            1
#define s_GridBackColor            2
#define s_FontColor                3
#define s_BackColor                4
#define s_Container                5
#define s_Parent                   6
#define s_hCursor                  7
#define s_Events                   8
#define s_Events_Color             9
#define s_Name                     10
#define s_Type                     11
#define s_TControl                 12
#define s_TLabel                   13
#define s_TGrid                    14
#define s_ContextMenu              15
#define s_RowMargin                16
#define s_ColMargin                17
#define s_hWnd                     18
#define s_TText                    19
#define s_AdjustRightScroll        20
#define s_OnMouseMove              21
#define s_OnMouseDrag              22
#define s_DoEvent                  23
#define s_LookForKey               24
#define s_aControlInfo             25
#define s__aControlInfo            26
#define s_Events_DrawItem          27
#define s__hWnd                    28
#define s_Events_Command           29
#define s_OnChange                 30
#define s_OnGotFocus               31
#define s_OnLostFocus              32
#define s_OnClick                  33
#define s_Transparent              34
#define s_Events_MeasureItem       35
#define s_FontHandle               36
#define s_TWindow                  37
#define s_WndProc                  38
#define s_OverWndProc              39
#define s_hWndClient               40
#define s_Refresh                  41
#define s_AuxHandle                42
#define s_ContainerCol             43
#define s_ContainerRow             44
#define s_lRtl                     45
#define s_Width                    46
#define s_Height                   47
#define s_VScroll                  48
#define s_ScrollButton             49
#define s_Visible                  50
#define s_Events_HScroll           51
#define s_Events_VScroll           52
#define s_nTextHeight              53
#define s_Events_Enter             54
#define s_Id                       55
#define s_NestedClick              56
#define s__NestedClick             57
#define s_TInternal                58
#define s__ContextMenu             59
#define s_Release                  60
#define s_Activate                 61
#define s_oOle                     62
#define s_RangeHeight              63
#define s_LastSymbol               64

// Hack for MinGW and static functions (object's methods)
#ifdef __MINGW32__
#undef  HB_FUNC_STATIC
#define HB_FUNC_STATIC( x )        HB_FUNC( x )
#endif

// Hot recovery related defines
#ifdef QPM_HOTRECOVERY
#define DEF_N_ITEM_COLIMAGE        1
#define DEF_N_ITEM_COLNAME         2
#define DEF_N_ITEM_COLRELATIVENAME 3
#define DEF_N_ITEM_COLFULLNAME     4
#define DEF_N_ITEM_COLDATETIME     5
#define DEF_N_ITEM_COLOFFSET       6
#define DEF_N_ITEM_COLVERSION      7
#define DEF_N_VER_COLIMAGE         1
#define DEF_N_VER_COLVERSION       2
#define DEF_N_VER_COLDATETIME      3
#define DEF_N_VER_COLCREATED       4
#define DEF_N_VER_COLCOMMENT       5
#define DEF_N_VER_COLRELATIVENAME  6
#define DEF_N_VER_COLFULLNAME      7
#define DEF_N_VER_COLCOMPUTER      8
#define DEF_N_VER_COLUSERID        9
#define DEF_N_VER_COLCODE          10
#define DEF_N_VER_COLOFFSET        11
#endif

// Resources ID definitions
#include "resource.h"

// Public variables
memvar aGridDbf
memvar aGridExc
memvar aGridHea
memvar aGridHlp
memvar aGridInc
memvar aGridPan
memvar aGridPrg
memvar bAutoExit
memvar bAutoSyncTab
memvar bAvisoDbfDataSearchLow
memvar bAvisoDbfGlobalSearchLow
memvar bBuildRun
memvar bBuildRunBack
memvar bDbfAutoView
memvar bDbfDataSearchAsk
memvar bDbfMoving
memvar bDbfSorting
memvar bEditorLongName
memvar bExcMoving
memvar bExcSorting
memvar bGlobalSearch
memvar bHeaMoving
memvar bHeaSorting
memvar bHlpMoving
memvar bHlpSorting
memvar bIncMoving
memvar bIncSorting
memvar bLastGlobalSearchCas
memvar bLastGlobalSearchDbf
memvar bLastGlobalSearchFun
memvar bLogActivity
memvar bNumberOnHea
memvar bNumberOnPan
memvar bNumberOnPrg
memvar bPanMoving
memvar bPanSorting
memvar bPpoDisplayado
memvar bPrgMoving
memvar bPrgSorting
memvar bRunApp
memvar bRunParm
memvar bSortDbfAsc
memvar bSortExcAsc
memvar bSortHeaAsc
memvar bSortHlpAsc
memvar bSortIncAsc
memvar bSortPanAsc
memvar bSortPrgAsc
memvar bSuspendControlEdit
memvar BUILD_IN_PROGRESS
memvar bWaitForBuild
memvar bWarningCpp
memvar cDbfDataSearchAskRpta
memvar cExeNotFoundMsg
memvar cLastGlobalSearch
memvar cLastLibFolderE1BH_32
memvar cLastLibFolderE1BX_32
memvar cLastLibFolderE1GH_32
memvar cLastLibFolderE1GH_64
memvar cLastLibFolderE1GX_32
memvar cLastLibFolderE1GX_64
memvar cLastLibFolderM1BH_32
memvar cLastLibFolderM1BX_32
memvar cLastLibFolderM3GH_32
memvar cLastLibFolderM3GH_64
memvar cLastLibFolderO3BH_32
memvar cLastLibFolderO3BX_32
memvar cLastLibFolderO3GH_32
memvar cLastLibFolderO3GH_64
memvar cLastLibFolderO3GX_32
memvar cLastLibFolderO3GX_64
memvar cLastLibFolderO3PH_32
memvar cLastLibFolderO3PH_64
memvar cLastLibFolderO3PX_32
memvar cLastLibFolderO3PX_64
memvar cLastProjectFolder
memvar cPpoCaretPrg
memvar cPrj_Version
memvar cPrj_VersionAnt
memvar cProjectFileName
memvar cProjectFolderIdent
memvar cUpxOpt
memvar Define32bits
memvar Define64bits
memvar DefineBorland
memvar DefineExtended1
memvar DefineHarbour
memvar DefineMinGW
memvar DefineMiniGui1
memvar DefineMiniGui3
memvar DefineOohg3
memvar DefinePelles
memvar DefineXHarbour
memvar ExcludeLibsE1BH_32
memvar ExcludeLibsE1BX_32
memvar ExcludeLibsE1GH_32
memvar ExcludeLibsE1GH_64
memvar ExcludeLibsE1GX_32
memvar ExcludeLibsE1GX_64
memvar ExcludeLibsM1BH_32
memvar ExcludeLibsM1BX_32
memvar ExcludeLibsM3GH_32
memvar ExcludeLibsM3GH_64
memvar ExcludeLibsO3BH_32
memvar ExcludeLibsO3BX_32
memvar ExcludeLibsO3GH_32
memvar ExcludeLibsO3GH_64
memvar ExcludeLibsO3GX_32
memvar ExcludeLibsO3GX_64
memvar ExcludeLibsO3PH_32
memvar ExcludeLibsO3PH_64
memvar ExcludeLibsO3PX_32
memvar ExcludeLibsO3PX_64
memvar Gbl_Comillas_DBF
memvar GBL_cRunParm
memvar GBL_HR_cLastExternalFileName
memvar Gbl_T_C_E1BH_32
memvar Gbl_T_C_E1BX_32
memvar Gbl_T_C_E1GH_32
memvar Gbl_T_C_E1GH_64
memvar Gbl_T_C_E1GX_32
memvar Gbl_T_C_E1GX_64
memvar Gbl_T_C_LIBS_E1BH_32
memvar Gbl_T_C_LIBS_E1BX_32
memvar Gbl_T_C_LIBS_E1GH_32
memvar Gbl_T_C_LIBS_E1GH_64
memvar Gbl_T_C_LIBS_E1GX_32
memvar Gbl_T_C_LIBS_E1GX_64
memvar Gbl_T_C_LIBS_M1BH_32
memvar Gbl_T_C_LIBS_M1BX_32
memvar Gbl_T_C_LIBS_M3GH_32
memvar Gbl_T_C_LIBS_M3GH_64
memvar Gbl_T_C_LIBS_O3BH_32
memvar Gbl_T_C_LIBS_O3BX_32
memvar Gbl_T_C_LIBS_O3GH_32
memvar Gbl_T_C_LIBS_O3GH_64
memvar Gbl_T_C_LIBS_O3GX_32
memvar Gbl_T_C_LIBS_O3GX_64
memvar Gbl_T_C_LIBS_O3PH_32
memvar Gbl_T_C_LIBS_O3PH_64
memvar Gbl_T_C_LIBS_O3PX_32
memvar Gbl_T_C_LIBS_O3PX_64
memvar Gbl_T_C_M1BH_32
memvar Gbl_T_C_M1BX_32
memvar Gbl_T_C_M3GH_32
memvar Gbl_T_C_M3GH_64
memvar Gbl_T_C_O3BH_32
memvar Gbl_T_C_O3BX_32
memvar Gbl_T_C_O3GH_32
memvar Gbl_T_C_O3GH_64
memvar Gbl_T_C_O3GX_32
memvar Gbl_T_C_O3GX_64
memvar Gbl_T_C_O3PH_32
memvar Gbl_T_C_O3PH_64
memvar Gbl_T_C_O3PX_32
memvar Gbl_T_C_O3PX_64
memvar Gbl_T_M_E1BH_32
memvar Gbl_T_M_E1BX_32
memvar Gbl_T_M_E1GH_32
memvar Gbl_T_M_E1GH_64
memvar Gbl_T_M_E1GX_32
memvar Gbl_T_M_E1GX_64
memvar Gbl_T_M_LIBS_E1BH_32
memvar Gbl_T_M_LIBS_E1BX_32
memvar Gbl_T_M_LIBS_E1GH_32
memvar Gbl_T_M_LIBS_E1GH_64
memvar Gbl_T_M_LIBS_E1GX_32
memvar Gbl_T_M_LIBS_E1GX_64
memvar Gbl_T_M_LIBS_M1BH_32
memvar Gbl_T_M_LIBS_M1BX_32
memvar Gbl_T_M_LIBS_M3GH_32
memvar Gbl_T_M_LIBS_M3GH_64
memvar Gbl_T_M_LIBS_O3BH_32
memvar Gbl_T_M_LIBS_O3BX_32
memvar Gbl_T_M_LIBS_O3GH_32
memvar Gbl_T_M_LIBS_O3GH_64
memvar Gbl_T_M_LIBS_O3GX_32
memvar Gbl_T_M_LIBS_O3GX_64
memvar Gbl_T_M_LIBS_O3PH_32
memvar Gbl_T_M_LIBS_O3PH_64
memvar Gbl_T_M_LIBS_O3PX_32
memvar Gbl_T_M_LIBS_O3PX_64
memvar Gbl_T_M_M1BH_32
memvar Gbl_T_M_M1BX_32
memvar Gbl_T_M_M3GH_32
memvar Gbl_T_M_M3GH_64
memvar Gbl_T_M_O3BH_32
memvar Gbl_T_M_O3BX_32
memvar Gbl_T_M_O3GH_32
memvar Gbl_T_M_O3GH_64
memvar Gbl_T_M_O3GX_32
memvar Gbl_T_M_O3GX_64
memvar Gbl_T_M_O3PH_32
memvar Gbl_T_M_O3PH_64
memvar Gbl_T_M_O3PX_32
memvar Gbl_T_M_O3PX_64
memvar Gbl_T_P_E1BH_32
memvar Gbl_T_P_E1BX_32
memvar Gbl_T_P_E1GH_32
memvar Gbl_T_P_E1GH_64
memvar Gbl_T_P_E1GX_32
memvar Gbl_T_P_E1GX_64
memvar Gbl_T_P_LIBS_E1BH_32
memvar Gbl_T_P_LIBS_E1BX_32
memvar Gbl_T_P_LIBS_E1GH_32
memvar Gbl_T_P_LIBS_E1GH_64
memvar Gbl_T_P_LIBS_E1GX_32
memvar Gbl_T_P_LIBS_E1GX_64
memvar Gbl_T_P_LIBS_M1BH_32
memvar Gbl_T_P_LIBS_M1BX_32
memvar Gbl_T_P_LIBS_M3GH_32
memvar Gbl_T_P_LIBS_M3GH_64
memvar Gbl_T_P_LIBS_O3BH_32
memvar Gbl_T_P_LIBS_O3BX_32
memvar Gbl_T_P_LIBS_O3GH_32
memvar Gbl_T_P_LIBS_O3GH_64
memvar Gbl_T_P_LIBS_O3GX_32
memvar Gbl_T_P_LIBS_O3GX_64
memvar Gbl_T_P_LIBS_O3PH_32
memvar Gbl_T_P_LIBS_O3PH_64
memvar Gbl_T_P_LIBS_O3PX_32
memvar Gbl_T_P_LIBS_O3PX_64
memvar Gbl_T_P_M1BH_32
memvar Gbl_T_P_M1BX_32
memvar Gbl_T_P_M3GH_32
memvar Gbl_T_P_M3GH_64
memvar Gbl_T_P_O3BH_32
memvar Gbl_T_P_O3BX_32
memvar Gbl_T_P_O3GH_32
memvar Gbl_T_P_O3GH_64
memvar Gbl_T_P_O3GX_32
memvar Gbl_T_P_O3GX_64
memvar Gbl_T_P_O3PH_32
memvar Gbl_T_P_O3PH_64
memvar Gbl_T_P_O3PX_32
memvar Gbl_T_P_O3PX_64
memvar GBL_TabGridNameFocus
memvar Gbl_Text_DBF
memvar Gbl_Text_Editor
memvar Gbl_Text_HMGSIDE
memvar Gbl_Text_HMI
memvar HR_bNumberOnHEA
memvar HR_bNumberOnPAN
memvar HR_bNumberOnPRG
memvar IncludeLibsE1BH_32
memvar IncludeLibsE1BX_32
memvar IncludeLibsE1GH_32
memvar IncludeLibsE1GH_64
memvar IncludeLibsE1GX_32
memvar IncludeLibsE1GX_64
memvar IncludeLibsM1BH_32
memvar IncludeLibsM1BX_32
memvar IncludeLibsM3GH_32
memvar IncludeLibsM3GH_64
memvar IncludeLibsO3BH_32
memvar IncludeLibsO3BX_32
memvar IncludeLibsO3GH_32
memvar IncludeLibsO3GH_64
memvar IncludeLibsO3GX_32
memvar IncludeLibsO3GX_64
memvar IncludeLibsO3PH_32
memvar IncludeLibsO3PH_64
memvar IncludeLibsO3PX_32
memvar IncludeLibsO3PX_64
memvar IsBorland
memvar IsMinGW
memvar IsPelles
memvar LibsActiva
memvar MAIN_HAS_FOCUS
memvar NCOLDBFEDIT
memvar NCOLDBFFULLNAME
memvar NCOLDBFNAME
memvar NCOLDBFOFFSET
memvar NCOLDBFSEARCH
memvar NCOLDBFSTATUS
memvar NCOLEXCNAME
memvar NCOLEXCSTATUS
memvar NCOLHEAEDIT
memvar NCOLHEAFULLNAME
memvar NCOLHEANAME
memvar NCOLHEAOFFSET
memvar NCOLHEARECOVERY
memvar NCOLHEASTATUS
memvar NCOLHLPEDIT
memvar NCOLHLPNICK
memvar NCOLHLPOFFSET
memvar NCOLHLPSTATUS
memvar NCOLHLPTOPIC
memvar NCOLINCFULLNAME
memvar NCOLINCNAME
memvar NCOLINCSTATUS
memvar NCOLLIBFULLNAME
memvar NCOLLIBSTATUS
memvar NCOLPANEDIT
memvar NCOLPANFULLNAME
memvar NCOLPANNAME
memvar NCOLPANOFFSET
memvar NCOLPANRECOVERY
memvar NCOLPANSTATUS
memvar NCOLPRGEDIT
memvar NCOLPRGFULLNAME
memvar NCOLPRGNAME
memvar NCOLPRGOFFSET
memvar NCOLPRGRECOMP
memvar NCOLPRGRECOVERY
memvar NCOLPRGSTATUS
memvar nGDbfRecord
memvar nGridDbfLastRow
memvar nGridHeaLastRow
memvar nGridHlpLastRow
memvar nGridPanLastRow
memvar nGridPrgLastRow
memvar nPageDbf
memvar nPageHea
memvar nPageHlp
memvar nPageLib
memvar nPageOut
memvar nPagePan
memvar nPagePrg
memvar nPageSysout
memvar oHlpRichEdit
memvar PageCdQ
memvar PageDBF
memvar PageHEA
memvar PageHLP
memvar PageLIB
memvar PageOUT
memvar PagePAN
memvar PagePRG
memvar PageSysout
memvar PageWWW
memvar PRI_COMPATIBILITY_CONFIGVERSION
memvar PRI_COMPATIBILITY_INX
memvar PRI_COMPATIBILITY_LINE
memvar PRI_COMPATIBILITY_MEMOPROJECTFILE
memvar PRI_COMPATIBILITY_MEMOPROJECTFILEAUX
memvar PRI_COMPATIBILITY_PROJECTFOLDER
memvar PRI_COMPATIBILITY_PROJECTFOLDERIDENT
memvar PRI_COMPATIBILITY_THISFOLDER
memvar Prj_Check_64bits
memvar Prj_Check_Console
memvar Prj_Check_HarbourIs31
memvar Prj_Check_IgnoreLibRCs
memvar Prj_Check_IgnoreMainRC
memvar Prj_Check_IgnoreOtherRCs
memvar Prj_Check_MT
memvar Prj_Check_OutputPrefix
memvar Prj_Check_OutputSuffix
memvar Prj_Check_PlaceRCFirst
memvar Prj_Check_Upx
memvar Prj_ExtraRunCmdEXE
memvar Prj_ExtraRunCmdEXEParm
memvar Prj_ExtraRunCmdFINAL
memvar Prj_ExtraRunCmdFREE
memvar Prj_ExtraRunCmdFREEParm
memvar Prj_ExtraRunCmdQPMParm
memvar Prj_ExtraRunExePause
memvar Prj_ExtraRunExeWait
memvar Prj_ExtraRunFreePause
memvar Prj_ExtraRunFreeWait
memvar Prj_ExtraRunProjQPM
memvar Prj_ExtraRunQPMAutoExit
memvar Prj_ExtraRunQPMButtonRun
memvar Prj_ExtraRunQPMClear
memvar Prj_ExtraRunQPMForceFull
memvar Prj_ExtraRunQPMLite
memvar Prj_ExtraRunQPMLog
memvar Prj_ExtraRunQPMLogOnlyError
memvar Prj_ExtraRunQPMRadio
memvar Prj_ExtraRunQPMRun
memvar Prj_ExtraRunType
memvar Prj_IsNew
memvar Prj_Radio_Cpp
memvar Prj_Radio_DbFTool
memvar Prj_Radio_FormTool
memvar Prj_Radio_Harbour
memvar Prj_Radio_MiniGui
memvar Prj_Radio_OutputCopyMove
memvar Prj_Radio_OutputRename
memvar Prj_Radio_OutputType
memvar Prj_Text_OutputCopyMoveFolder
memvar Prj_Text_OutputRenameNewName
memvar ProgLength
memvar PUB_bAutoInc
memvar PUB_bDebugActive
memvar PUB_bDebugActiveAnt
memvar PUB_bForceRunFromMsgOk
memvar PUB_bIgnoreVersionProject
memvar PUB_bIsProcessing
memvar PUB_bLite
memvar PUB_bLogOnlyError
memvar PUB_bOpenProjectFromParm
memvar PUB_bW800
memvar PUB_cAutoLog
memvar PUB_cAutoLogTmp
memvar PUB_cCharFileNameTemp
memvar PUB_cCharTab
memvar PUB_cConvert
memvar PUB_cProjectFile
memvar PUB_cProjectFolder
memvar PUB_cQPM_Folder
memvar PUB_cQPM_Support_Admin
memvar PUB_cQPM_Support_eMail
memvar PUB_cQPM_Support_Link
memvar PUB_cQPM_Title
memvar PUB_cSecu
memvar PUB_cStatusLabel
memvar PUB_cTempFolder
memvar PUB_cThisFolder
memvar PUB_cUS_RedirOpt
memvar PUB_DeleteAux
memvar PUB_ErrorLogTime
memvar PUB_MenuGblOptions
memvar PUB_MenuPrjOptions
memvar PUB_MI_bDesktopShortCut
memvar PUB_MI_bExeAssociation
memvar PUB_MI_bExeBackupOption
memvar PUB_MI_bLaunchApplication
memvar PUB_MI_bLaunchBackupOption
memvar PUB_MI_bNewFile
memvar PUB_MI_bReboot
memvar PUB_MI_bSelectAllDBF
memvar PUB_MI_bSelectAllHEA
memvar PUB_MI_bSelectAllLIB
memvar PUB_MI_bSelectAllPAN
memvar PUB_MI_bSelectAllPRG
memvar PUB_MI_bStartMenuShortCut
memvar PUB_MI_cDefaultLanguage
memvar PUB_MI_cDestinationPath
memvar PUB_MI_cExeAssociation
memvar PUB_MI_cImage
memvar PUB_MI_cInstallerName
memvar PUB_MI_cLeyendUserText
memvar PUB_MI_cNewFileLeyend
memvar PUB_MI_cNewFileUserFile
memvar PUB_MI_nDesktopShortCut
memvar PUB_MI_nDestinationPath
memvar PUB_MI_nExeAssociationIcon
memvar PUB_MI_nInstallerName
memvar PUB_MI_nLaunchApplication
memvar PUB_MI_nLeyendSuggested
memvar PUB_MI_nNewFileEmpty
memvar PUB_MI_nNewFileSuggested
memvar PUB_MI_nStartMenuShortCut
memvar PUB_MI_vFiles
memvar PUB_MigrateFolderFrom
memvar PUB_MigrateVersionFrom
memvar PUB_nGridImgEdited
memvar PUB_nGridImgEquis
memvar PUB_nGridImgHlpBook
memvar PUB_nGridImgHlpGlobalFoot
memvar PUB_nGridImgHlpPage
memvar PUB_nGridImgHlpWelcome
memvar PUB_nGridImgNone
memvar PUB_nGridImgSearchNotOk
memvar PUB_nGridImgSearchOk
memvar PUB_nGridImgTilde
memvar PUB_nGridImgTop
memvar PUB_nProjectFileHandle
memvar PUB_QPM_bHigh
memvar PUB_RunTabAutoSync
memvar PUB_RunTabChange
memvar PUB_vAutoRun
memvar PUB_xHarbourMT
memvar QPM_bKiller
memvar QPM_HR_Database
memvar QPM_KillerbLate
memvar QPM_KillerModule
memvar QPM_KillerProcessLast
memvar RunControlFile
memvar SHG_BaseOK
memvar SHG_CheckTypeOutput
memvar SHG_Database
memvar SHG_DbSize
memvar SHG_HtmlFolder
memvar SHG_LastFolderImg
memvar SHG_WWW
memvar var030399_Borland
memvar var030399_Extended1
memvar var030399_Harbour
memvar var030399_MinGW
memvar var030399_MiniGui1
memvar var030399_MiniGui2
memvar var030399_ModName
memvar var030399_Move
memvar var030399_NewName
memvar var030399_Oohg1
memvar var030399_Renamed
memvar var030399_Suffix
memvar var030399_Type
memvar var030399_XHarbour
memvar var041199_Borland
memvar var041199_Extended1
memvar var041199_Harbour
memvar var041199_MinGW
memvar var041199_MiniGui1
memvar var041199_MiniGui3
memvar var041199_ModName
memvar var041199_Move
memvar var041199_NewName
memvar var041199_Oohg3
memvar var041199_Pelles
memvar var041199_Renamed
memvar var041199_Suffix
memvar var041199_Type
memvar var041199_XHarbour
memvar vDbfHeaders
memvar vDbfJustify
memvar vDbfWidths
memvar vExeList
memvar vExeNotFound
memvar vExtraFoldersForLibsE1BH_32
memvar vExtraFoldersForLibsE1BX_32
memvar vExtraFoldersForLibsE1GH_32
memvar vExtraFoldersForLibsE1GH_64
memvar vExtraFoldersForLibsE1GX_32
memvar vExtraFoldersForLibsE1GX_64
memvar vExtraFoldersForLibsM1BH_32
memvar vExtraFoldersForLibsM1BX_32
memvar vExtraFoldersForLibsM3GH_32
memvar vExtraFoldersForLibsM3GH_64
memvar vExtraFoldersForLibsO3BH_32
memvar vExtraFoldersForLibsO3BX_32
memvar vExtraFoldersForLibsO3GH_32
memvar vExtraFoldersForLibsO3GH_64
memvar vExtraFoldersForLibsO3GX_32
memvar vExtraFoldersForLibsO3GX_64
memvar vExtraFoldersForLibsO3PH_32
memvar vExtraFoldersForLibsO3PH_64
memvar vExtraFoldersForLibsO3PX_32
memvar vExtraFoldersForLibsO3PX_64
memvar vExtraFoldersForSearchC
memvar vExtraFoldersForSearchHB
memvar vImagesGrid
memvar vLastOpen
memvar vLastSearch
memvar vLibDefaultE1BH_32
memvar vLibDefaultE1BX_32
memvar vLibDefaultE1GH_32
memvar vLibDefaultE1GH_64
memvar vLibDefaultE1GX_32
memvar vLibDefaultE1GX_64
memvar vLibDefaultM1BH_32
memvar vLibDefaultM1BX_32
memvar vLibDefaultM3GH_32
memvar vLibDefaultM3GH_64
memvar vLibDefaultO3BH_32
memvar vLibDefaultO3BX_32
memvar vLibDefaultO3GH_32
memvar vLibDefaultO3GH_64
memvar vLibDefaultO3GX_32
memvar vLibDefaultO3GX_64
memvar vLibDefaultO3PH_32
memvar vLibDefaultO3PH_64
memvar vLibDefaultO3PX_32
memvar vLibDefaultO3PX_64
memvar vSinInclude
memvar vSinLoadWindow
memvar vSuffix
memvar vXRefPrgFmg
memvar vXRefPrgHea

// Flavor dependent variables
#translate QPM_VAR0 <tipo> <var> := <valor> => <tipo> <var> := <"valor">

#translate QPM_VAR2 <tipo> <var> <minigui> <cpp> <harbour> <bits> [ := <valor> ] => <tipo> <var><minigui><cpp><harbour><bits> [ := <valor> ]

/* eof */
