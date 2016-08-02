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
#include <QPM.ch>

#ifdef QPM_KILLER

Function QPM_SetProcessPriority( cType )
   Local nType , P , nReto , aProcSelf := US_GetProcesses()
   Do case
      case cType == "HIGH"
         nType := 3
         PUB_QPM_bHigh := .T.
      case cType == "NORMAL"
         nType := 5
         PUB_QPM_bHigh := .F.
      otherwise
         MsgInfo( "Invalid Priority class in function " + Procname() + ": " + cType )
         Return 20
   endcase
   For P := Len( aProcSelf ) to 1 Step -2
      if !empty( aProcSelf[ P ] )
         if upper( aProcSelf[ P ] ) == upper( GetModuleFileName( GetInstance() ) )
            if ( nReto := US_SetPriorityToProcess( aProcSelf[ P-1 ] , nType ) ) != 0
               MsgInfo( "Set High Priority for Process '" + GetModuleFileName( GetInstance() ) + "' Failed with code: " + alltrim( str( nReto ) ) )
            endif
            exit
         endif
      endif
   Next P
Return nReto

Function QPM_DefinoKillerWindow()

   DEFINE WINDOW WinKiller AT ( ( GetDesktopRealHeight() - 243 ) / 2 ) , ( GetDesktopRealWidth() - 400 ) WIDTH 394 HEIGHT 243 ;
        TITLE "QPM Process Killer" ;
        ICON "XKILLER" ;
        TOPMOST ;
        NOSYSMENU ;
        NOSHOW ;
        ON INIT RefreshGrid() ;
        ON SIZE ResizeCtrls() ;
        ON MAXIMIZE ResizeCtrls() ;
        FONT "Courier New" ;
        SIZE 9

        DEFINE GRID GGrid
           ROW    0
           COL    0
           WIDTH  288
           HEIGHT 188
           WIDTHS { 70, 130, 600 }
           HEADERS {'#PID', "Process", "Full Path"}
           FONTNAME "Courier New"
           FONTSIZE 9
           TOOLTIP ""
           ONCHANGE Nil
           ONGOTFOCUS Nil
           ONLOSTFOCUS Nil
           FONTBOLD .F.
           FONTITALIC .F.
           FONTUNDERLINE .F.
           FONTSTRIKEOUT .F.
           ONDBLCLICK Nil
           ONHEADCLICK Nil
           ONQUERYDATA Nil
           MULTISELECT .F.
           ALLOWEDIT .F.
           VIRTUAL .F.
           NOLINES .F.
           HELPID Nil
           IMAGE Nil
           JUSTIFY Nil
           ITEMCOUNT Nil
           BACKCOLOR DEF_COLORWHITE
           FONTCOLOR {185, 38, 75}
        END GRID
        // BACKCOLOR {245,220,227}
        // FONTCOLOR {  0, 36,104}

        DEFINE BUTTON BKill
           ROW    10
           COL    300
           WIDTH  74
           HEIGHT 26
           CAPTION "&Kill It!"
           ACTION ( KillIt( if( WinKiller.GGrid.ItemCount > 0 , WinKiller.GGrid.Value , 0 ) ) , WinKiller.GGrid.Setfocus )
           FONTNAME "MS Sans Serif"
           FONTSIZE 8
           TOOLTIP "Terminate the selected process"
           FONTBOLD .F.
           FONTITALIC .F.
           FONTUNDERLINE .F.
           FONTSTRIKEOUT .F.
           ONGOTFOCUS Nil
           ONLOSTFOCUS Nil
           HELPID Nil
           FLAT .F.
           TABSTOP .T.
           VISIBLE .T.
           TRANSPARENT .F.
           PICTURE Nil
        END BUTTON

        @ 47, 320 IMAGE IRefresh ;
           PICTURE         "REVOLVER" ;
           WIDTH           32 ;
           HEIGHT          32 ;
           STRETCH

        DEFINE BUTTON BRefresh
           ROW    90
           COL    300
           WIDTH  74
           HEIGHT 26
           CAPTION "&Refresh"
           ACTION ( RefreshGrid( WinKiller.GGrid.Cell( WinKiller.GGrid.Value , 1 ) , , .T. ) , WinKiller.GGrid.Setfocus )
           FONTNAME "MS Sans Serif"
           FONTSIZE 8
           TOOLTIP "Refresh list of processes"
           FONTBOLD .F.
           FONTITALIC .F.
           FONTUNDERLINE .F.
           FONTSTRIKEOUT .F.
           ONGOTFOCUS Nil
           ONLOSTFOCUS Nil
           HELPID Nil
           FLAT .F.
           TABSTOP .T.
           VISIBLE .T.
           TRANSPARENT .F.
           PICTURE Nil
        END BUTTON

        WinKiller.BRefresh.Enabled := .F.

        DEFINE BUTTON BCancel
           ROW    130
           COL    300
           WIDTH  74
           HEIGHT 26
           CAPTION "&Restore QPM"
           ACTION ( WinKiller.TimerRefresh.Enabled := .F. , SetProperty( "VentanaMain" , "bKill" , "Enabled" , .T. ) , DoMethod( "VentanaMain" , "restore" ) , ThisWindow.Hide() , QPM_bKiller := .F. , if( !bRunApp , QPM_SetProcessPriority( "NORMAL" ) , ) )
           FONTNAME "MS Sans Serif"
           FONTSIZE 8
           TOOLTIP "Hide " + DBLQT + "Killer Task" + DBLQT + " and restore QPM's desktop"
           FONTBOLD .F.
           FONTITALIC .F.
           FONTUNDERLINE .F.
           FONTSTRIKEOUT .F.
           ONGOTFOCUS Nil
           ONLOSTFOCUS Nil
           HELPID Nil
           FLAT .F.
           TABSTOP .T.
           VISIBLE .T.
           TRANSPARENT .F.
           PICTURE Nil
        END BUTTON

        DEFINE CHECKBOX Check_QPM_Tools
                CAPTION         "Show All QPM Process"
                ROW             ( WinKiller.Height - if( IsXPThemeActive() , 54 , 50 ) )
                COL             10
                WIDTH           200
                HEIGHT          20
                VALUE           .F.
                TOOLTIP         "Show all QPM processes (QPM.EXE, US_Run.exe, etc.)"
                ON CHANGE       ( RefreshGrid( WinKiller.GGrid.Cell( WinKiller.GGrid.Value , 1 ) , , .T. ) , WinKiller.GGrid.Setfocus )
        END CHECKBOX

        DEFINE CHECKBOX Check_AutoRefresh
                CAPTION         "AutoRefresh"
                ROW             ( WinKiller.Height - if( IsXPThemeActive() , 54 , 50 ) )
                COL             280
                WIDTH           100
                HEIGHT          20
                VALUE           .T.
                TOOLTIP         "Toggle the list's automatic refresh"
                ON CHANGE       ( WinKiller.TimerRefresh.Enabled := WinKiller.Check_AutoRefresh.Value , WinKiller.BRefresh.Enabled := !( WinKiller.Check_AutoRefresh.Value ) , WinKiller.GGrid.Setfocus )
        END CHECKBOX

        DEFINE TIMER TimerRefresh ;
           OF WinKiller ;
           INTERVAL 500 ;
           ACTION RefreshGrid( GetProperty( "WinKiller" , "GGrid" , "Cell" , GetProperty( "WinKiller" , "GGrid" , "Value" ) , 1 ) )

   END WINDOW

   SetProperty( "WinKiller" , "TimerRefresh" , "enabled" , .F. )

Return .T.

Function KillIt( nValue )
   Local nPID, reto
   if nValue > 0
      nPID := val( WinKiller.GGrid.Item( nValue )[1] )
      IF MyMsgOkCancel( "Process #" + str( nPID ) + " will be terminated." + CRLF + ;
         "Process Name: " + WinKiller.GGrid.Item( nValue )[3] + CRLF + ;
         "Continue?", "Confirm" )
         if ( reto := US_KillProcess( nPID ) ) == 0
            ADel( QPM_KillerProcessLast, nPID )
            ASize( QPM_KillerProcessLast, Len(QPM_KillerProcessLast) - 1 )
            RefreshGrid( "0" , nPID )
         else
            msgstop( "Kill task failed with code: " + alltrim( str( reto ) ) )
         endif
      ENDIF
   else
      MsgInfo( "No process selected." )
   ENDIF
Return nil

Function RefreshGrid( cPId , nPIDExclude , bForce )
   LOCAL aProc := {}, cFullName, cExeName := "" , nProcessID, i
   LOCAL aProcessInfo := US_GetProcesses()
   LOCAL nPointer := "0" , vExclude := { "QPM.EXE" , "US_RUN.EXE" , "US_MSG.EXE" , "US_SHELL.EXE" , "US_SLASH.EXE" , "US_RES.EXE" , "US_MAKE.EXE" }
   WinKiller.GGrid.DisableUpdate
   if empty( bForce )
      bForce := .F.
   endif
   late()
   if !bForce .and. ;
      ( len( aProcessInfo ) == len( QPM_KillerProcessLast ) ) .and. ;
      ( US_VarToStr( aProcessInfo ) == US_VarToStr( QPM_KillerProcessLast ) )
      WinKiller.GGrid.EnableUpdate
      Return .F.
   else
      QPM_KillerProcessLast := aProcessInfo
   endif
   if empty( cPId )
      cPId := "0"
   endif
   For i := 1 To Len(aProcessInfo) Step 2
      nProcessID := aProcessInfo[i]
      IF !Empty(nProcessID) .and. !( aProcessInfo[i+1] == "<unknown>" )
         cFullName := aProcessInfo[i+1]
         cExeName  := if( rat( DEF_SLASH , cFullName ) > 0 , substr( cFullName , rat( DEF_SLASH , cFullName ) + 1 ) , cFullName )
         if empty( nPIDExclude ) .or. ( !empty( nPIDExclude ) .and. nProcessID != nPIDExclude )
            if WinKiller.Check_QPM_Tools.value
               AADD( aProc, { nProcessID, cExeName , cFullName } )
            else
               if aScan( vExclude, {|e| upper( e ) == upper( cExeName ) } ) == 0
                  AADD( aProc, { nProcessID, cExeName , cFullName } )
               endif
            endif
         endif
      ENDIF
   Next
   IF LEN(aProc) > 0
      WinKiller.GGrid.DisableUpdate
      WinKiller.GGrid.DeleteAllItems
      Aeval( aProc, { |e| ( IF( upper( e[3] ) == upper( QPM_KillerModule ) , nPointer := alltrim( str( e[1] ) ) , ) ) } )
      for i:=len( aproc) to 1 Step -1
         WinKiller.GGrid.AddItem( { alltrim( str( aProc[i][1] ) ) , aProc[i][2] , aProc[i][3] } )
      next
      // Aeval( aProc, { |e,i| ( WinKiller.GGrid.AddItem( { alltrim( str( e[1] ) ) , e[2] , e[3] } ) ) } )
      DoMethod( "WinKiller" , "GGrid" , "ColumnsAutoFitH" )
      WinKiller.GGrid.EnableUpdate
      if nPointer == "0"
         WinKiller.GGrid.Value := PidToPos( cPId )
      else
         WinKiller.GGrid.Value := PidToPos( nPointer )
      endif
   ENDIF
   //\\ WinKiller.GGrid.Setfocus
   WinKiller.GGrid.EnableUpdate
Return .T.

Function ResizeCtrls()
   IF WinKiller.Width < 394
      WinKiller.Width := 394
   ENDIF
   IF WinKiller.Height < 243
      WinKiller.Height := 243
   ENDIF
   WinKiller.GGrid.Width := WinKiller.Width - 106
   WinKiller.GGrid.Height := WinKiller.Height - 55
   WinKiller.BKill.Col := WinKiller.Width - 94
   WinKiller.BCancel.Col := WinKiller.Width - 94
   WinKiller.IRefresh.Col := WinKiller.Width - 74
   WinKiller.BRefresh.Col := WinKiller.Width - 94
   WinKiller.Check_QPM_Tools.Row := WinKiller.Height - if( IsXPThemeActive() , 54 , 50 )
   WinKiller.Check_AutoRefresh.Row := WinKiller.Height - if( IsXPThemeActive() , 54 , 50 )
   WinKiller.Check_AutoRefresh.Col := WinKiller.Width - 114
   RefreshGrid( WinKiller.GGrid.Cell( WinKiller.GGrid.Value , 1 ) )
Return nil

Function Late()
   WinKiller.IRefresh.Picture := if( QPM_KillerbLate , "REVOLVER" , "REVOLVER2" )
   DO EVENTS
   QPM_KillerbLate := !QPM_KillerbLate
Return nil

Function PidToPos( cPId )
   Local i
   for i:=1 to WinKiller.GGrid.ItemCount
      if cPId == WinKiller.GGrid.Cell( i , 1 )
         Return i
      endif
   next
Return 0

Function US_GetProcesses()
Return IF(IsWinNT(), US_GetProcessesNT(), US_GetProcessesW9x())

#endif

/* eof */
