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

#include "US_Env.h"

// String related defines
#define DBLQT             '"'
#define SNGQT             "'"
#define StripDBLQT( str ) SubStr( str, 2, Len( str ) - 2 )
#define AddDBLQT( str )   ( DBLQT + str + DBLQT )
#define CRLF              hb_osNewLine()

// Project version
#define DEF_LEN_VER_VERSION        2
#define DEF_LEN_VER_RELEASE        2
#define DEF_LEN_VER_BUILD          4

// QPM version
#include "QPM_version.ch"
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
#translate MyMsgStop( <txt> )      => MyMsg( "QPM - Error",   US_VarToStr( <txt> ), "E", bAutoExit )
#translate MsgStop( <txt> )        => MyMsg( "QPM - Error",   US_VarToStr( <txt> ), "E", bAutoExit )
#translate MyMsgWarn( <txt> )      => MyMsg( "QPM - Warning", US_VarToStr( <txt> ), "W", bAutoExit )
#translate MsgWarn( <txt> )        => MyMsg( "QPM - Warning", US_VarToStr( <txt> ), "W", bAutoExit )
#translate MyMsgInfo( <txt> )      => MyMsg( "QPM - Info",    US_VarToStr( <txt> ), "N", bAutoExit )
#translate MsgInfo( <txt> )        => MyMsg( "QPM - Info",    US_VarToStr( <txt> ), "N", bAutoExit )
#translate AutoMsgBox( <txt> )     => MsgInfo( <txt> )

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
#define DEF_COLORBACKDEF           { 255, 238, 230 }
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
#define DEF_DBF_SHARED             .T.
#define DEF_DBF_EXCLUSIVE          .F.
#define DEF_DBF_READ               .T.
#define DEF_DBF_WRITE              .F.

// Execute modes
#define DEF_QPM_EXEC_WAIT          .T.
#define DEF_QPM_EXEC_NOWAIT        .F.
#define DEF_QPM_EXEC_HIDE          -1
#define DEF_QPM_EXEC_MINIMIZE      0
#define DEF_QPM_EXEC_NORMAL        1
#define DEF_QPM_EXEC_MAXIMIZE      2

// MiniGuis suffixes
#define DEF_MG_MINIGUI1            M1
#define DEF_MG_MINIGUI3            M3
#define DEF_MG_EXTENDED1           E1
#define DEF_MG_OOHG3               O3

// [x]Harbour suffixes
#define DEF_MG_HARBOUR             H
#define DEF_MG_XHARBOUR            X
#define DEF_MG_CLIP                C

// Cpp suffixes
#define DEF_MG_BORLAND             B
#define DEF_MG_MINGW               G
#define DEF_MG_PELLES              P
#define DEF_MG_VC                  V

// Bits suffixes
#define DEF_MG_32                  _32
#define DEF_MG_64                  _64

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
#define DEF_RG_OOHGIDE             2
#define DEF_RG_HMGSIDE             3
#define DEF_RG_HMG_IDE             4
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
MEMVAR aGridDbf
MEMVAR aGridDef
MEMVAR aGridExc
MEMVAR aGridHea
MEMVAR aGridHlp
MEMVAR aGridInc
MEMVAR aGridPan
MEMVAR aGridPrg
MEMVAR bAutoExit
MEMVAR bAutoSyncTab
MEMVAR bAvisoDbfDataSearchLow
MEMVAR bAvisoDbfGlobalSearchLow
MEMVAR bBuildRun
MEMVAR bBuildRunBack
MEMVAR bDbfAutoView
MEMVAR bDbfDataSearchAsk
MEMVAR bDbfSorting
MEMVAR bEditorLongName
MEMVAR bExcSorting
MEMVAR bGlobalSearch
MEMVAR bHeaSorting
MEMVAR bHlpMoving
MEMVAR bHlpSorting
MEMVAR bLastGlobalSearchCas
MEMVAR bLastGlobalSearchDbf
MEMVAR bLastGlobalSearchFun
MEMVAR bLogActivity
MEMVAR bNoFMGextension
MEMVAR bNumberOnHea
MEMVAR bNumberOnPan
MEMVAR bNumberOnPrg
MEMVAR bPanSorting
MEMVAR bPpoDisplayado
MEMVAR bPrgSorting
MEMVAR bRunApp
MEMVAR bRunParm
MEMVAR bSortDbfAsc
MEMVAR bSortExcAsc
MEMVAR bSortHeaAsc
MEMVAR bSortHlpAsc
MEMVAR bSortPanAsc
MEMVAR bSortPrgAsc
MEMVAR bSuspendControlEdit
MEMVAR BUILD_IN_PROGRESS
MEMVAR bWaitForBuild
MEMVAR cDbfDataSearchAskRpta
MEMVAR cEditControlFileRC
MEMVAR cExeNotFoundMsg
MEMVAR cLastGlobalSearch
MEMVAR cLastLibFolderE1BH_32
MEMVAR cLastLibFolderE1BX_32
MEMVAR cLastLibFolderE1GH_32
MEMVAR cLastLibFolderE1GH_64
MEMVAR cLastLibFolderE1GX_32
MEMVAR cLastLibFolderE1GX_64
MEMVAR cLastLibFolderE1PH_32
MEMVAR cLastLibFolderE1PH_64
MEMVAR cLastLibFolderE1PX_32
MEMVAR cLastLibFolderE1PX_64
MEMVAR cLastLibFolderM1BH_32
MEMVAR cLastLibFolderM1BX_32
MEMVAR cLastLibFolderM3GH_32
MEMVAR cLastLibFolderM3GH_64
MEMVAR cLastLibFolderO3BH_32
MEMVAR cLastLibFolderO3BX_32
MEMVAR cLastLibFolderO3GH_32
MEMVAR cLastLibFolderO3GH_64
MEMVAR cLastLibFolderO3GX_32
MEMVAR cLastLibFolderO3GX_64
MEMVAR cLastLibFolderO3PH_32
MEMVAR cLastLibFolderO3PH_64
MEMVAR cLastLibFolderO3PX_32
MEMVAR cLastLibFolderO3PX_64
MEMVAR cLastProjectFolder
MEMVAR cPpoCaretPrg
MEMVAR cPrj_Version
MEMVAR cPrj_VersionAnt
MEMVAR cProjectFileName
MEMVAR cProjectFolderIdent
MEMVAR cUpxOpt
MEMVAR Define32bits
MEMVAR Define64bits
MEMVAR DefineBorland
MEMVAR DefineExtended1
MEMVAR DefineHarbour
MEMVAR DefineLibName
MEMVAR DefineMinGW
MEMVAR DefineMiniGui1
MEMVAR DefineMiniGui3
MEMVAR DefineOohg3
MEMVAR DefinePelles
MEMVAR DefineXHarbour
MEMVAR ExcludeLibsE1BH_32
MEMVAR ExcludeLibsE1BX_32
MEMVAR ExcludeLibsE1GH_32
MEMVAR ExcludeLibsE1GH_64
MEMVAR ExcludeLibsE1GX_32
MEMVAR ExcludeLibsE1GX_64
MEMVAR ExcludeLibsE1PH_32
MEMVAR ExcludeLibsE1PH_64
MEMVAR ExcludeLibsE1PX_32
MEMVAR ExcludeLibsE1PX_64
MEMVAR ExcludeLibsM1BH_32
MEMVAR ExcludeLibsM1BX_32
MEMVAR ExcludeLibsM3GH_32
MEMVAR ExcludeLibsM3GH_64
MEMVAR ExcludeLibsO3BH_32
MEMVAR ExcludeLibsO3BX_32
MEMVAR ExcludeLibsO3GH_32
MEMVAR ExcludeLibsO3GH_64
MEMVAR ExcludeLibsO3GX_32
MEMVAR ExcludeLibsO3GX_64
MEMVAR ExcludeLibsO3PH_32
MEMVAR ExcludeLibsO3PH_64
MEMVAR ExcludeLibsO3PX_32
MEMVAR ExcludeLibsO3PX_64
MEMVAR Gbl_Comillas_DBF
MEMVAR Gbl_cRunParm
MEMVAR Gbl_DEF_LIBS_E1BH_32
MEMVAR Gbl_DEF_LIBS_E1BX_32
MEMVAR Gbl_DEF_LIBS_E1GH_32
MEMVAR Gbl_DEF_LIBS_E1GH_64
MEMVAR Gbl_DEF_LIBS_E1GX_32
MEMVAR Gbl_DEF_LIBS_E1GX_64
MEMVAR Gbl_DEF_LIBS_E1PH_32
MEMVAR Gbl_DEF_LIBS_E1PH_64
MEMVAR Gbl_DEF_LIBS_E1PX_32
MEMVAR Gbl_DEF_LIBS_E1PX_64
MEMVAR Gbl_DEF_LIBS_M1BH_32
MEMVAR Gbl_DEF_LIBS_M1BX_32
MEMVAR Gbl_DEF_LIBS_M3GH_32
MEMVAR Gbl_DEF_LIBS_M3GH_64
MEMVAR Gbl_DEF_LIBS_O3BH_32
MEMVAR Gbl_DEF_LIBS_O3BX_32
MEMVAR Gbl_DEF_LIBS_O3GH_32
MEMVAR Gbl_DEF_LIBS_O3GH_64
MEMVAR Gbl_DEF_LIBS_O3GX_32
MEMVAR Gbl_DEF_LIBS_O3GX_64
MEMVAR Gbl_DEF_LIBS_O3PH_32
MEMVAR Gbl_DEF_LIBS_O3PH_64
MEMVAR Gbl_DEF_LIBS_O3PX_32
MEMVAR Gbl_DEF_LIBS_O3PX_64
MEMVAR Gbl_HR_cLastExternalFileName
MEMVAR Gbl_T_C_E1BH_32
MEMVAR Gbl_T_C_E1BX_32
MEMVAR Gbl_T_C_E1GH_32
MEMVAR Gbl_T_C_E1GH_64
MEMVAR Gbl_T_C_E1GX_32
MEMVAR Gbl_T_C_E1GX_64
MEMVAR Gbl_T_C_E1PH_32
MEMVAR Gbl_T_C_E1PH_64
MEMVAR Gbl_T_C_E1PX_32
MEMVAR Gbl_T_C_E1PX_64
MEMVAR Gbl_T_C_LIBS_E1BH_32
MEMVAR Gbl_T_C_LIBS_E1BX_32
MEMVAR Gbl_T_C_LIBS_E1GH_32
MEMVAR Gbl_T_C_LIBS_E1GH_64
MEMVAR Gbl_T_C_LIBS_E1GX_32
MEMVAR Gbl_T_C_LIBS_E1GX_64
MEMVAR Gbl_T_C_LIBS_E1PH_32
MEMVAR Gbl_T_C_LIBS_E1PH_64
MEMVAR Gbl_T_C_LIBS_E1PX_32
MEMVAR Gbl_T_C_LIBS_E1PX_64
MEMVAR Gbl_T_C_LIBS_M1BH_32
MEMVAR Gbl_T_C_LIBS_M1BX_32
MEMVAR Gbl_T_C_LIBS_M3GH_32
MEMVAR Gbl_T_C_LIBS_M3GH_64
MEMVAR Gbl_T_C_LIBS_O3BH_32
MEMVAR Gbl_T_C_LIBS_O3BX_32
MEMVAR Gbl_T_C_LIBS_O3GH_32
MEMVAR Gbl_T_C_LIBS_O3GH_64
MEMVAR Gbl_T_C_LIBS_O3GX_32
MEMVAR Gbl_T_C_LIBS_O3GX_64
MEMVAR Gbl_T_C_LIBS_O3PH_32
MEMVAR Gbl_T_C_LIBS_O3PH_64
MEMVAR Gbl_T_C_LIBS_O3PX_32
MEMVAR Gbl_T_C_LIBS_O3PX_64
MEMVAR Gbl_T_C_M1BH_32
MEMVAR Gbl_T_C_M1BX_32
MEMVAR Gbl_T_C_M3GH_32
MEMVAR Gbl_T_C_M3GH_64
MEMVAR Gbl_T_C_O3BH_32
MEMVAR Gbl_T_C_O3BX_32
MEMVAR Gbl_T_C_O3GH_32
MEMVAR Gbl_T_C_O3GH_64
MEMVAR Gbl_T_C_O3GX_32
MEMVAR Gbl_T_C_O3GX_64
MEMVAR Gbl_T_C_O3PH_32
MEMVAR Gbl_T_C_O3PH_64
MEMVAR Gbl_T_C_O3PX_32
MEMVAR Gbl_T_C_O3PX_64
MEMVAR Gbl_T_G_E1BH_32
MEMVAR Gbl_T_G_E1BX_32
MEMVAR Gbl_T_G_E1GH_32
MEMVAR Gbl_T_G_E1GH_64
MEMVAR Gbl_T_G_E1GX_32
MEMVAR Gbl_T_G_E1GX_64
MEMVAR Gbl_T_G_E1PH_32
MEMVAR Gbl_T_G_E1PH_64
MEMVAR Gbl_T_G_E1PX_32
MEMVAR Gbl_T_G_E1PX_64
MEMVAR Gbl_T_G_M1BH_32
MEMVAR Gbl_T_G_M1BX_32
MEMVAR Gbl_T_G_M3GH_32
MEMVAR Gbl_T_G_M3GH_64
MEMVAR Gbl_T_G_O3BH_32
MEMVAR Gbl_T_G_O3BX_32
MEMVAR Gbl_T_G_O3GH_32
MEMVAR Gbl_T_G_O3GH_64
MEMVAR Gbl_T_G_O3GX_32
MEMVAR Gbl_T_G_O3GX_64
MEMVAR Gbl_T_G_O3PH_32
MEMVAR Gbl_T_G_O3PH_64
MEMVAR Gbl_T_G_O3PX_32
MEMVAR Gbl_T_G_O3PX_64
MEMVAR Gbl_T_M_E1BH_32
MEMVAR Gbl_T_M_E1BX_32
MEMVAR Gbl_T_M_E1GH_32
MEMVAR Gbl_T_M_E1GH_64
MEMVAR Gbl_T_M_E1GX_32
MEMVAR Gbl_T_M_E1GX_64
MEMVAR Gbl_T_M_E1PH_32
MEMVAR Gbl_T_M_E1PH_64
MEMVAR Gbl_T_M_E1PX_32
MEMVAR Gbl_T_M_E1PX_64
MEMVAR Gbl_T_M_LIBS_E1BH_32
MEMVAR Gbl_T_M_LIBS_E1BX_32
MEMVAR Gbl_T_M_LIBS_E1GH_32
MEMVAR Gbl_T_M_LIBS_E1GH_64
MEMVAR Gbl_T_M_LIBS_E1GX_32
MEMVAR Gbl_T_M_LIBS_E1GX_64
MEMVAR Gbl_T_M_LIBS_E1PH_32
MEMVAR Gbl_T_M_LIBS_E1PH_64
MEMVAR Gbl_T_M_LIBS_E1PX_32
MEMVAR Gbl_T_M_LIBS_E1PX_64
MEMVAR Gbl_T_M_LIBS_M1BH_32
MEMVAR Gbl_T_M_LIBS_M1BX_32
MEMVAR Gbl_T_M_LIBS_M3GH_32
MEMVAR Gbl_T_M_LIBS_M3GH_64
MEMVAR Gbl_T_M_LIBS_O3BH_32
MEMVAR Gbl_T_M_LIBS_O3BX_32
MEMVAR Gbl_T_M_LIBS_O3GH_32
MEMVAR Gbl_T_M_LIBS_O3GH_64
MEMVAR Gbl_T_M_LIBS_O3GX_32
MEMVAR Gbl_T_M_LIBS_O3GX_64
MEMVAR Gbl_T_M_LIBS_O3PH_32
MEMVAR Gbl_T_M_LIBS_O3PH_64
MEMVAR Gbl_T_M_LIBS_O3PX_32
MEMVAR Gbl_T_M_LIBS_O3PX_64
MEMVAR Gbl_T_M_M1BH_32
MEMVAR Gbl_T_M_M1BX_32
MEMVAR Gbl_T_M_M3GH_32
MEMVAR Gbl_T_M_M3GH_64
MEMVAR Gbl_T_M_O3BH_32
MEMVAR Gbl_T_M_O3BX_32
MEMVAR Gbl_T_M_O3GH_32
MEMVAR Gbl_T_M_O3GH_64
MEMVAR Gbl_T_M_O3GX_32
MEMVAR Gbl_T_M_O3GX_64
MEMVAR Gbl_T_M_O3PH_32
MEMVAR Gbl_T_M_O3PH_64
MEMVAR Gbl_T_M_O3PX_32
MEMVAR Gbl_T_M_O3PX_64
MEMVAR Gbl_T_N_E1BH_32
MEMVAR Gbl_T_N_E1BX_32
MEMVAR Gbl_T_N_E1GH_32
MEMVAR Gbl_T_N_E1GH_64
MEMVAR Gbl_T_N_E1GX_32
MEMVAR Gbl_T_N_E1GX_64
MEMVAR Gbl_T_N_E1PH_32
MEMVAR Gbl_T_N_E1PH_64
MEMVAR Gbl_T_N_E1PX_32
MEMVAR Gbl_T_N_E1PX_64
MEMVAR Gbl_T_N_LIBS_E1BH_32
MEMVAR Gbl_T_N_LIBS_E1BX_32
MEMVAR Gbl_T_N_LIBS_E1GH_32
MEMVAR Gbl_T_N_LIBS_E1GH_64
MEMVAR Gbl_T_N_LIBS_E1GX_32
MEMVAR Gbl_T_N_LIBS_E1GX_64
MEMVAR Gbl_T_N_LIBS_M1BH_32
MEMVAR Gbl_T_N_LIBS_M1BX_32
MEMVAR Gbl_T_N_LIBS_M3GH_32
MEMVAR Gbl_T_N_LIBS_M3GH_64
MEMVAR Gbl_T_N_LIBS_O3BH_32
MEMVAR Gbl_T_N_LIBS_O3BX_32
MEMVAR Gbl_T_N_LIBS_O3GH_32
MEMVAR Gbl_T_N_LIBS_O3GH_64
MEMVAR Gbl_T_N_LIBS_O3GX_32
MEMVAR Gbl_T_N_LIBS_O3GX_64
MEMVAR Gbl_T_N_LIBS_O3PH_32
MEMVAR Gbl_T_N_LIBS_O3PH_64
MEMVAR Gbl_T_N_LIBS_O3PX_32
MEMVAR Gbl_T_N_LIBS_O3PX_64
MEMVAR Gbl_T_N_M1BH_32
MEMVAR Gbl_T_N_M1BX_32
MEMVAR Gbl_T_N_M3GH_32
MEMVAR Gbl_T_N_M3GH_64
MEMVAR Gbl_T_N_O3BH_32
MEMVAR Gbl_T_N_O3BX_32
MEMVAR Gbl_T_N_O3GH_32
MEMVAR Gbl_T_N_O3GH_64
MEMVAR Gbl_T_N_O3GX_32
MEMVAR Gbl_T_N_O3GX_64
MEMVAR Gbl_T_N_O3PH_32
MEMVAR Gbl_T_N_O3PH_64
MEMVAR Gbl_T_N_O3PX_32
MEMVAR Gbl_T_N_O3PX_64
MEMVAR Gbl_T_P_E1BH_32
MEMVAR Gbl_T_P_E1BX_32
MEMVAR Gbl_T_P_E1GH_32
MEMVAR Gbl_T_P_E1GH_64
MEMVAR Gbl_T_P_E1GX_32
MEMVAR Gbl_T_P_E1GX_64
MEMVAR Gbl_T_P_E1PH_32
MEMVAR Gbl_T_P_E1PH_64
MEMVAR Gbl_T_P_E1PX_32
MEMVAR Gbl_T_P_E1PX_64
MEMVAR Gbl_T_P_LIBS_E1BH_32
MEMVAR Gbl_T_P_LIBS_E1BX_32
MEMVAR Gbl_T_P_LIBS_E1GH_32
MEMVAR Gbl_T_P_LIBS_E1GH_64
MEMVAR Gbl_T_P_LIBS_E1GX_32
MEMVAR Gbl_T_P_LIBS_E1GX_64
MEMVAR Gbl_T_P_LIBS_E1PH_32
MEMVAR Gbl_T_P_LIBS_E1PH_64
MEMVAR Gbl_T_P_LIBS_E1PX_32
MEMVAR Gbl_T_P_LIBS_E1PX_64
MEMVAR Gbl_T_P_LIBS_M1BH_32
MEMVAR Gbl_T_P_LIBS_M1BX_32
MEMVAR Gbl_T_P_LIBS_M3GH_32
MEMVAR Gbl_T_P_LIBS_M3GH_64
MEMVAR Gbl_T_P_LIBS_O3BH_32
MEMVAR Gbl_T_P_LIBS_O3BX_32
MEMVAR Gbl_T_P_LIBS_O3GH_32
MEMVAR Gbl_T_P_LIBS_O3GH_64
MEMVAR Gbl_T_P_LIBS_O3GX_32
MEMVAR Gbl_T_P_LIBS_O3GX_64
MEMVAR Gbl_T_P_LIBS_O3PH_32
MEMVAR Gbl_T_P_LIBS_O3PH_64
MEMVAR Gbl_T_P_LIBS_O3PX_32
MEMVAR Gbl_T_P_LIBS_O3PX_64
MEMVAR Gbl_T_P_M1BH_32
MEMVAR Gbl_T_P_M1BX_32
MEMVAR Gbl_T_P_M3GH_32
MEMVAR Gbl_T_P_M3GH_64
MEMVAR Gbl_T_P_O3BH_32
MEMVAR Gbl_T_P_O3BX_32
MEMVAR Gbl_T_P_O3GH_32
MEMVAR Gbl_T_P_O3GH_64
MEMVAR Gbl_T_P_O3GX_32
MEMVAR Gbl_T_P_O3GX_64
MEMVAR Gbl_T_P_O3PH_32
MEMVAR Gbl_T_P_O3PH_64
MEMVAR Gbl_T_P_O3PX_32
MEMVAR Gbl_T_P_O3PX_64
MEMVAR Gbl_TabGridNameFocus
MEMVAR Gbl_Text_DBF
MEMVAR Gbl_Text_Editor
MEMVAR Gbl_Text_HMG_IDE
MEMVAR Gbl_Text_HMGSIDE
MEMVAR Gbl_Text_OOHGIDE
MEMVAR HR_bNumberOnHEA
MEMVAR HR_bNumberOnPAN
MEMVAR HR_bNumberOnPRG
MEMVAR HR_ControlFileRC
MEMVAR IncludeLibsE1BH_32
MEMVAR IncludeLibsE1BX_32
MEMVAR IncludeLibsE1GH_32
MEMVAR IncludeLibsE1GH_64
MEMVAR IncludeLibsE1GX_32
MEMVAR IncludeLibsE1GX_64
MEMVAR IncludeLibsE1PH_32
MEMVAR IncludeLibsE1PH_64
MEMVAR IncludeLibsE1PX_32
MEMVAR IncludeLibsE1PX_64
MEMVAR IncludeLibsM1BH_32
MEMVAR IncludeLibsM1BX_32
MEMVAR IncludeLibsM3GH_32
MEMVAR IncludeLibsM3GH_64
MEMVAR IncludeLibsO3BH_32
MEMVAR IncludeLibsO3BX_32
MEMVAR IncludeLibsO3GH_32
MEMVAR IncludeLibsO3GH_64
MEMVAR IncludeLibsO3GX_32
MEMVAR IncludeLibsO3GX_64
MEMVAR IncludeLibsO3PH_32
MEMVAR IncludeLibsO3PH_64
MEMVAR IncludeLibsO3PX_32
MEMVAR IncludeLibsO3PX_64
MEMVAR IsBorland
MEMVAR IsMinGW
MEMVAR IsPelles
MEMVAR LibsActiva
MEMVAR NCOLDBFEDIT
MEMVAR NCOLDBFFULLNAME
MEMVAR NCOLDBFNAME
MEMVAR NCOLDBFOFFSET
MEMVAR NCOLDBFSEARCH
MEMVAR NCOLDBFSTATUS
MEMVAR NCOLDEFDEBUG
MEMVAR NCOLDEFMODE
MEMVAR NCOLDEFNAME
MEMVAR NCOLDEFSTATUS
MEMVAR NCOLDEFTHREADS
MEMVAR NCOLEXCNAME
MEMVAR NCOLEXCSTATUS
MEMVAR NCOLHEAEDIT
MEMVAR NCOLHEAFULLNAME
MEMVAR NCOLHEANAME
MEMVAR NCOLHEAOFFSET
MEMVAR NCOLHEARECOVERY
MEMVAR NCOLHEASTATUS
MEMVAR NCOLHLPEDIT
MEMVAR NCOLHLPNICK
MEMVAR NCOLHLPOFFSET
MEMVAR NCOLHLPSTATUS
MEMVAR NCOLHLPTOPIC
MEMVAR NCOLINCFULLNAME
MEMVAR NCOLINCNAME
MEMVAR NCOLINCSTATUS
MEMVAR NCOLLIBFULLNAME
MEMVAR NCOLLIBSTATUS
MEMVAR NCOLPANEDIT
MEMVAR NCOLPANFULLNAME
MEMVAR NCOLPANNAME
MEMVAR NCOLPANOFFSET
MEMVAR NCOLPANRECOVERY
MEMVAR NCOLPANSTATUS
MEMVAR NCOLPRGEDIT
MEMVAR NCOLPRGFULLNAME
MEMVAR NCOLPRGNAME
MEMVAR NCOLPRGOFFSET
MEMVAR NCOLPRGRECOMP
MEMVAR NCOLPRGRECOVERY
MEMVAR NCOLPRGSTATUS
MEMVAR nGDbfRecord
MEMVAR nGridDbfLastRow
MEMVAR nGridHeaLastRow
MEMVAR nGridHlpLastRow
MEMVAR nGridPanLastRow
MEMVAR nGridPrgLastRow
MEMVAR nPageDbf
MEMVAR nPageHea
MEMVAR nPageHlp
MEMVAR nPageLib
MEMVAR nPageOut
MEMVAR nPagePan
MEMVAR nPagePrg
MEMVAR nPageSysout
MEMVAR oHlpRichEdit
MEMVAR PageCdQ
MEMVAR PageDBF
MEMVAR PageHEA
MEMVAR PageHLP
MEMVAR PageLIB
MEMVAR PageOUT
MEMVAR PagePAN
MEMVAR PagePRG
MEMVAR PageSysout
MEMVAR PageWWW
MEMVAR PRI_COMPATIBILITY_CONFIGVERSION
MEMVAR PRI_COMPATIBILITY_INX
MEMVAR PRI_COMPATIBILITY_LINE
MEMVAR PRI_COMPATIBILITY_MEMOPROJECTFILE
MEMVAR PRI_COMPATIBILITY_MEMOPROJECTFILEAUX
MEMVAR PRI_COMPATIBILITY_PROJECTFOLDER
MEMVAR PRI_COMPATIBILITY_PROJECTFOLDERIDENT
MEMVAR PRI_COMPATIBILITY_THISFOLDER
MEMVAR Prj_Check_64bits
MEMVAR Prj_Check_Console
MEMVAR Prj_Check_HarbourIs31
MEMVAR Prj_Check_IgnoreLibRCs
MEMVAR Prj_Check_IgnoreMainRC
MEMVAR Prj_Check_IgnoreOtherRCs
MEMVAR Prj_Check_MT
MEMVAR Prj_Check_OutputPrefix
MEMVAR Prj_Check_OutputSuffix
MEMVAR Prj_Check_PlaceRCFirst
MEMVAR Prj_Check_StaticBuild
MEMVAR Prj_Check_Upx
MEMVAR Prj_ExtraRunCmdEXE
MEMVAR Prj_ExtraRunCmdEXEParm
MEMVAR Prj_ExtraRunCmdFINAL
MEMVAR Prj_ExtraRunCmdFREE
MEMVAR Prj_ExtraRunCmdFREEParm
MEMVAR Prj_ExtraRunCmdQPMParm
MEMVAR Prj_ExtraRunExePause
MEMVAR Prj_ExtraRunExeWait
MEMVAR Prj_ExtraRunFreePause
MEMVAR Prj_ExtraRunFreeWait
MEMVAR Prj_ExtraRunProjQPM
MEMVAR Prj_ExtraRunQPMAutoExit
MEMVAR Prj_ExtraRunQPMButtonRun
MEMVAR Prj_ExtraRunQPMClear
MEMVAR Prj_ExtraRunQPMForceFull
MEMVAR Prj_ExtraRunQPMLite
MEMVAR Prj_ExtraRunQPMLog
MEMVAR Prj_ExtraRunQPMLogOnlyError
MEMVAR Prj_ExtraRunQPMRadio
MEMVAR Prj_ExtraRunQPMRun
MEMVAR Prj_ExtraRunType
MEMVAR Prj_IsNew
MEMVAR Prj_Radio_Cpp
MEMVAR Prj_Radio_DbFTool
MEMVAR Prj_Radio_FormTool
MEMVAR Prj_Radio_Harbour
MEMVAR Prj_Radio_MiniGui
MEMVAR Prj_Radio_OutputCopyMove
MEMVAR Prj_Radio_OutputRename
MEMVAR Prj_Radio_OutputType
MEMVAR Prj_Text_OutputCopyMoveFolder
MEMVAR Prj_Text_OutputRenameNewName
MEMVAR Prj_Warn_BccObject
MEMVAR Prj_Warn_BccObject_Cont
MEMVAR Prj_Warn_Cpp
MEMVAR Prj_Warn_DBF_Search
MEMVAR Prj_Warn_DBF_Search_Cont
MEMVAR Prj_Warn_GT_Order
MEMVAR Prj_Warn_GT_Order_Cont
MEMVAR Prj_Warn_InfoSaved
MEMVAR Prj_Warn_NullRDD
MEMVAR Prj_Warn_PPO_Browse
MEMVAR Prj_Warn_SlowSearch
MEMVAR Prj_Warn_SlowSearch_Cont
MEMVAR Prj_Warn_TopFile
MEMVAR ProgLength
MEMVAR PUB_bAutoInc
MEMVAR PUB_bDebugActive
MEMVAR PUB_bDebugActiveAnt
MEMVAR PUB_bForceRunFromMsgOk
MEMVAR PUB_bHotKeys
MEMVAR PUB_bIgnoreVersionProject
MEMVAR PUB_bIsProcessing
MEMVAR PUB_bLite
MEMVAR PUB_bLogOnlyError
MEMVAR PUB_bOpenProjectFromParm
MEMVAR PUB_bW800
MEMVAR PUB_cAutoLog
MEMVAR PUB_cAutoLogTmp
MEMVAR PUB_cCharFileNameTemp
MEMVAR PUB_cCharTab
MEMVAR PUB_cConvert
MEMVAR PUB_cProjectFile
MEMVAR PUB_cProjectFolder
MEMVAR PUB_cQPM_Donation_Link
MEMVAR PUB_cQPM_Folder
MEMVAR PUB_cQPM_Support_Admin
MEMVAR PUB_cQPM_Support_eMail
MEMVAR PUB_cQPM_Support_Link
MEMVAR PUB_cQPM_Title
MEMVAR PUB_cSecu
MEMVAR PUB_cStatusLabel
MEMVAR PUB_cTempFolder
MEMVAR PUB_cThisFolder
MEMVAR PUB_DeleteAux
MEMVAR PUB_ErrorLogTime
MEMVAR PUB_MenuGblOptions
MEMVAR PUB_MenuPrjOptions
MEMVAR PUB_MenuResetWarnings
MEMVAR PUB_MI_bDesktopShortCut
MEMVAR PUB_MI_bExeAssociation
MEMVAR PUB_MI_bExeBackupOption
MEMVAR PUB_MI_bLaunchApplication
MEMVAR PUB_MI_bLaunchBackupOption
MEMVAR PUB_MI_bNewFile
MEMVAR PUB_MI_bReboot
MEMVAR PUB_MI_bSelectAllDBF
MEMVAR PUB_MI_bSelectAllHEA
MEMVAR PUB_MI_bSelectAllLIB
MEMVAR PUB_MI_bSelectAllPAN
MEMVAR PUB_MI_bSelectAllPRG
MEMVAR PUB_MI_bStartMenuShortCut
MEMVAR PUB_MI_cDefaultLanguage
MEMVAR PUB_MI_cDestinationPath
MEMVAR PUB_MI_cExeAssociation
MEMVAR PUB_MI_cImage
MEMVAR PUB_MI_cInstallerName
MEMVAR PUB_MI_cLeyendUserText
MEMVAR PUB_MI_cNewFileLeyend
MEMVAR PUB_MI_cNewFileUserFile
MEMVAR PUB_MI_nDesktopShortCut
MEMVAR PUB_MI_nDestinationPath
MEMVAR PUB_MI_nExeAssociationIcon
MEMVAR PUB_MI_nInstallerName
MEMVAR PUB_MI_nLaunchApplication
MEMVAR PUB_MI_nLeyendSuggested
MEMVAR PUB_MI_nNewFileEmpty
MEMVAR PUB_MI_nNewFileSuggested
MEMVAR PUB_MI_nStartMenuShortCut
MEMVAR PUB_MigrateFolderFrom
MEMVAR PUB_MigrateVersionFrom
MEMVAR PUB_nGridImgEdited
MEMVAR PUB_nGridImgEquis
MEMVAR PUB_nGridImgHlpBook
MEMVAR PUB_nGridImgHlpGlobalFoot
MEMVAR PUB_nGridImgHlpPage
MEMVAR PUB_nGridImgHlpWelcome
MEMVAR PUB_nGridImgNone
MEMVAR PUB_nGridImgSearchNotOk
MEMVAR PUB_nGridImgSearchOk
MEMVAR PUB_nGridImgTilde
MEMVAR PUB_nGridImgTop
MEMVAR PUB_nProjectFileHandle
MEMVAR PUB_QPM_bHigh
MEMVAR PUB_RunTabAutoSync
MEMVAR PUB_RunTabChange
MEMVAR PUB_vAutoRun
MEMVAR PUB_xHarbourMT
MEMVAR Q_END_FILE
MEMVAR Q_MAKE_FILE
MEMVAR Q_PROGRESS_LOG
MEMVAR Q_QPM_TMP_RC
MEMVAR Q_SCRIPT_FILE
MEMVAR Q_TEMP_LOG
MEMVAR QPM_bKiller
MEMVAR QPM_HR_Database
MEMVAR QPM_KillerbLate
MEMVAR QPM_KillerModule
MEMVAR QPM_KillerProcessLast
MEMVAR RunControlFile
MEMVAR SHG_BaseOK
MEMVAR SHG_CheckTypeOutput
MEMVAR SHG_Database
MEMVAR SHG_DbSize
MEMVAR SHG_HtmlFolder
MEMVAR SHG_LastFolderImg
MEMVAR SHG_WWW
MEMVAR var030399_Borland
MEMVAR var030399_Extended1
MEMVAR var030399_Harbour
MEMVAR var030399_MinGW
MEMVAR var030399_MiniGui1
MEMVAR var030399_MiniGui2
MEMVAR var030399_ModName
MEMVAR var030399_Move
MEMVAR var030399_NewName
MEMVAR var030399_Oohg1
MEMVAR var030399_Renamed
MEMVAR var030399_Suffix
MEMVAR var030399_Type
MEMVAR var030399_XHarbour
MEMVAR var041199_Borland
MEMVAR var041199_Extended1
MEMVAR var041199_Harbour
MEMVAR var041199_MinGW
MEMVAR var041199_MiniGui1
MEMVAR var041199_MiniGui3
MEMVAR var041199_ModName
MEMVAR var041199_Move
MEMVAR var041199_NewName
MEMVAR var041199_Oohg3
MEMVAR var041199_Pelles
MEMVAR var041199_Renamed
MEMVAR var041199_Suffix
MEMVAR var041199_Type
MEMVAR var041199_XHarbour
MEMVAR vDbfHeaders
MEMVAR vDbfJustify
MEMVAR vDbfWidths
MEMVAR vExeList
MEMVAR vExeNotFound
MEMVAR vExtraFoldersForLibsE1BH_32
MEMVAR vExtraFoldersForLibsE1BX_32
MEMVAR vExtraFoldersForLibsE1GH_32
MEMVAR vExtraFoldersForLibsE1GH_64
MEMVAR vExtraFoldersForLibsE1GX_32
MEMVAR vExtraFoldersForLibsE1GX_64
MEMVAR vExtraFoldersForLibsE1PH_32
MEMVAR vExtraFoldersForLibsE1PH_64
MEMVAR vExtraFoldersForLibsE1PX_32
MEMVAR vExtraFoldersForLibsE1PX_64
MEMVAR vExtraFoldersForLibsM1BH_32
MEMVAR vExtraFoldersForLibsM1BX_32
MEMVAR vExtraFoldersForLibsM3GH_32
MEMVAR vExtraFoldersForLibsM3GH_64
MEMVAR vExtraFoldersForLibsO3BH_32
MEMVAR vExtraFoldersForLibsO3BX_32
MEMVAR vExtraFoldersForLibsO3GH_32
MEMVAR vExtraFoldersForLibsO3GH_64
MEMVAR vExtraFoldersForLibsO3GX_32
MEMVAR vExtraFoldersForLibsO3GX_64
MEMVAR vExtraFoldersForLibsO3PH_32
MEMVAR vExtraFoldersForLibsO3PH_64
MEMVAR vExtraFoldersForLibsO3PX_32
MEMVAR vExtraFoldersForLibsO3PX_64
MEMVAR vExtraFoldersForSearchC
MEMVAR vExtraFoldersForSearchHB
MEMVAR vImagesGrid
MEMVAR vLastOpen
MEMVAR vLastSearch
MEMVAR vLibsDefault
MEMVAR vLibsToLink
MEMVAR vSinInclude
MEMVAR vSinLoadWindow
MEMVAR vSuffix
MEMVAR vXRefPrgFmg
MEMVAR vXRefPrgHea

// Flavor dependent variables
#translate QPM_VAR0 <tipo> <var> := <valor> => <tipo> <var> := <"valor">

#translate QPM_VAR2 <tipo> <var> <minigui> <cpp> <harbour> <bits> [ := <valor> ] => <tipo> <var><minigui><cpp><harbour><bits> [ := <valor> ]

/* eof */
