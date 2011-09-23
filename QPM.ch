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

#include <US_Env.h>

#DEFINE QPM_SHG

#DEFINE QPM_KILLER

#DEFINE QPM_HOTRECOVERY
#DEFINE QPM_HOTRECOVERYWINDOW

//#DEFINE QPM_SYNCRECOVERY

// la siguiente línea hace fallar el mensaje de database SHG not found cuando se abre un proyecto
//#translate MsgInfo( <txt> )          => SetMGWaitHide() ; MyMsg( "QPM - Notify"    , <txt> , "N" , bAutoExit ) ; SetMGWaitShow()
#translate MsgInfo( <txt> )          => MyMsg( "QPM - Notify"    , US_TodoStr( <txt> ) , "N" , bAutoExit )
#translate ? <txt>                   => MyMsg( "QPM - Notify"    , US_TodoStr( <txt> ) , "N" , bAutoExit )
#translate ?? <txt>                  => MyMsg( "QPM - Notify"    , US_TodoStr( <txt> ) , "N" , bAutoExit )
#translate MsgWarning( <txt> )       => MyMsg( "QPM - Warning"   , US_TodoStr( <txt> ) , "W" , bAutoExit )
#translate MsgStop( <txt> )          => MyMsg( "QPM - Error"     , US_TodoStr( <txt> ) , "E" , bAutoExit )
// MsgYesNocancel( <txt> ) retorna 1 for yes, 0 for no y -1 for cancel
#translate MsgYesNoCancel( <txt> )   => MyMsgYesNoCancel( <txt> , "QPM - Confirm" )
#translate MsgYesNo( <txt> )         => MyMsgYesNo( <txt> , "QPM - Confirm" )
#translate MsgOkCancel( <txt> )      => MyMsgOkCancel( <txt> , "QPM - Confirm" )
#translate MsgRetryCancel( <txt> )   => MyMsgRetryCancel( <txt> , "QPM - Confirm" )

#translate DEFAULT <var> TO <val>    =>  if( <var> == NIL , <var> := <val> , )
//#translate DEFAULT <var> TO <val>    =>  if( <var> == NIL .or. empty( <var> ) , <var> := <val> , )

#command MOVE RADIOGROUP FROM <Control> OF <w> ITEM <item> TO <y>,<x> ;
                                     => ;
                                        MoveWindow ( _HMG_aControlHandles \[ GetControlIndex ( ;
                                        <"Control">, <"w"> ) \] \[ <item> \] , <x> , <y> , _GetControlWidth ( ;
                                        <"Control">, <"w"> ) , 28 , .t. )

#define DEF_COLORWHITE          {255,255,255}
#define DEF_COLORYELLOW         {242,242,000}
#define DEF_COLORRED            {228,022,058}
#define DEF_COLORGREENCLARO     {183,231,175}
#define DEF_COLORGREEN          {041,135,049}
#define DEF_COLORBLUE           {000,000,255}
#define DEF_COLORBLACK          {000,000,000}
#define DEF_COLORFONTEXTERNALEDIT {216,183,137}
#define DEF_COLORBACKEXTERNALEDIT {215,130,155}
#define DEF_COLORBACKPPO        {192,192,192}
#define DEF_COLORFONTPPO        DEF_COLORWHITE
#define DEF_COLORFONTVIEW       {000,000,000}
#define DEF_COLORBACKPRG        {226,241,241}
#define DEF_COLORBACKHEA        {255,236,236}
#define DEF_COLORBACKPAN        {234,255,244}
#define DEF_COLORBACKDBF        {255,238,230}
#define DEF_COLORBACKDBFSEARCHOK {046,186,143}
#define DEF_COLORBACKINC        {234,244,255}
#define DEF_COLORBACKEXC        {229,229,229}
#define DEF_COLORBACKHLP        {255,252,234}
#define DEF_COLORBACKOUT        DEF_COLORWHITE
#define DEF_COLORBACKSYSOUT     DEF_COLORWHITE
#define DEF_COLORDLL            {228,207,177}
#define DEF_COLORLIB            {221,233,220}
#define DEF_COLOREXE            {188,219,240}

#DEFINE DEF_FOLDER_EXE "Tools"
#DEFINE DEF_FOLDER_ADD "Extra"

#DEFINE DEF_DBF_SHARED .T.
#DEFINE DEF_DBF_EXCLUSIVE .F.
#DEFINE DEF_DBF_READ  .T.
#DEFINE DEF_DBF_WRITE .F.

#DEFINE DEF_QPM_EXEC_WAIT      .T.
#DEFINE DEF_QPM_EXEC_NOWAIT    .F.
#DEFINE DEF_QPM_EXEC_HIDE      -1
#DEFINE DEF_QPM_EXEC_MINIMIZE  0
#DEFINE DEF_QPM_EXEC_NORMAL    1
#DEFINE DEF_QPM_EXEC_MAXIMIZE  2

// MiniGuis Suffix
#DEFINE DEF_MG_MINIGUI1        M1
#DEFINE DEF_MG_MINIGUI3        M3
#DEFINE DEF_MG_EXTENDED1       E1
#DEFINE DEF_MG_OOHG3           O3
// [x]Harbour Suffix
#DEFINE DEF_MG_HARBOUR         H
#DEFINE DEF_MG_XHARBOUR        X
#DEFINE DEF_MG_CLIP            C
// Cpp Suffix
#DEFINE DEF_MG_BORLAND         B
#DEFINE DEF_MG_MINGW           G
#DEFINE DEF_MG_PELLES          P
#DEFINE DEF_MG_VC              V
// Radio Groups
#define DEF_RG_HARBOUR    1
#define DEF_RG_XHARBOUR   2
#define DEF_RG_BORLAND    1
#define DEF_RG_MINGW      2
#define DEF_RG_PELLES     3
#define DEF_RG_MINIGUI1   1
#define DEF_RG_MINIGUI3   2
#define DEF_RG_EXTENDED1  3
#define DEF_RG_OOHG3      4
#define DEF_RG_EXE        1
#define DEF_RG_LIB        2
#define DEF_RG_IMPORT     3

#translate QPM_VAR0 <tipo> <var> := <valor> => <tipo> <var> := <"valor">
#translate QPM_VAR1 <tipo> <var> <minigui> <harbour> <cpp> [ := <valor> ] => <tipo> <var><minigui><harbour><cpp> [ := <valor> ]
#translate QPM_VAR2 <tipo> <var> <minigui> <cpp> [ := <valor> ] => <tipo> <var><minigui><cpp> [ := <valor> ]

// Symbol tables for ActiveX
#define s_Events_Notify        0
#define s_GridForeColor        1
#define s_GridBackColor        2
#define s_FontColor            3
#define s_BackColor            4
#define s_Container            5
#define s_Parent               6
#define s_hCursor              7
#define s_Events               8
#define s_Events_Color         9
#define s_Name                 10
#define s_Type                 11
#define s_TControl             12
#define s_TLabel               13
#define s_TGrid                14
#define s_ContextMenu          15
#define s_RowMargin            16
#define s_ColMargin            17
#define s_hWnd                 18
#define s_TText                19
#define s_AdjustRightScroll    20
#define s_OnMouseMove          21
#define s_OnMouseDrag          22
#define s_DoEvent              23
#define s_LookForKey           24
#define s_aControlInfo         25
#define s__aControlInfo        26
#define s_Events_DrawItem      27
#define s__hWnd                28
#define s_Events_Command       29
#define s_OnChange             30
#define s_OnGotFocus           31
#define s_OnLostFocus          32
#define s_OnClick              33
#define s_Transparent          34
#define s_Events_MeasureItem   35
#define s_FontHandle           36
#define s_TWindow              37
#define s_WndProc              38
#define s_OverWndProc          39
#define s_hWndClient           40
#define s_Refresh              41
#define s_AuxHandle            42
#define s_ContainerCol         43
#define s_ContainerRow         44
#define s_lRtl                 45
#define s_Width                46
#define s_Height               47
#define s_VScroll              48
#define s_ScrollButton         49
#define s_Visible              50
#define s_Events_HScroll       51
#define s_Events_VScroll       52
#define s_nTextHeight          53
#define s_Events_Enter         54
#define s_Id                   55
#define s_NestedClick          56
#define s__NestedClick         57
#define s_TInternal            58
#define s__ContextMenu         59
#define s_Release              60
#define s_Activate             61
#define s_oOle                 62
#define s_RangeHeight          63
#define s_LastSymbol           64

// Hack for MinGW and static functions (object's methods)
#ifdef __MINGW32__
   #undef  HB_FUNC_STATIC
   #define HB_FUNC_STATIC( x )     HB_FUNC( x )
#endif

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

// Project version
#define  DEF_LEN_VER_VERSION  2
#define  DEF_LEN_VER_RELEASE  2
#define  DEF_LEN_VER_BUILD    4

/* eof */
