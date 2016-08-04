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

Function GlobalSettings()
   LOCAL Filename, Folder

   DEFINE WINDOW WinGSettings ;
          AT 0 , 0 ;
          WIDTH 750 + iif( IsVistaOrLater(), GetBorderWidth() / 2 + 2, 0) ;
          HEIGHT 440 ;
          TITLE PUB_MenuGblOptions ;
          MODAL ;
          NOSYSMENU ;
          ON INTERACTIVECLOSE US_NOP() ;
          ON INIT SelectTab()

      DEFINE TAB TabGSettings ;
             OF WinGSettings ;
             AT 0 , 0 ;
             WIDTH 742 ;
             HEIGHT 360

         DEFINE PAGE "Editor and Forms Tools"

            @ 40 , 10 LABEL LDummy_Editor ;
               VALUE 'Editor:' ;
               WIDTH 275 ;
               FONT 'arial' SIZE 10 BOLD ;
               TRANSPARENT ;
               FONTCOLOR DEF_COLORBLUE

            DEFINE LABEL LEditor
                    VALUE           'Program Editor for Text Files:'
                    ROW             67
                    COL             10
                    AUTOSIZE        .T.
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX TEditor
                    VALUE           Gbl_TEditor
                    ROW             67
                    COL             220
                    WIDTH           461
            END TEXTBOX
            DEFINE BUTTON BEditor
                    ROW             67
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select editor'
                    ONCLICK         If ( !Empty( FileName := BugGetFile( { {'Application','*.exe'} } , 'Select Program Editor' , US_FileNameOnlyPath( WinGSettings.TEditor.Value ) , .F. , .T. ) ) , WinGSettings.TEditor.Value := FileName , )
            END BUTTON

            DEFINE CHECKBOX Check_EditorLongName
                    CAPTION         "Use Long Name"
                    ROW             87
                    COL             15
                    WIDTH           150
                    HEIGHT          20
                    VALUE           bEditorLongName
                    TOOLTIP         "Use long filenames when opening source editor. Default is short filename (8.3 format)"
                    ON CHANGE       bEditorLongName := WinGSettings.Check_EditorLongName.Value
            END CHECKBOX

            DEFINE CHECKBOX Check_EditorSuspendControl
                    CAPTION         "Suspend Control Edit"
                    ROW             108
                    COL             15
                    WIDTH           150
                    HEIGHT          20
                    VALUE           bSuspendControlEdit
                    TOOLTIP         "Suspend control of editing process"
                    ON CHANGE       bSuspendControlEdit := WinGSettings.Check_EditorSuspendControl.Value
            END CHECKBOX

            @ 132 , 10 LABEL LDummy_Form ;
               VALUE 'Forms Tools Location:' ;
               WIDTH 275 ;
               FONT 'arial' SIZE 10 BOLD ;
               TRANSPARENT ;
               FONTCOLOR DEF_COLORBLUE

            DEFINE LABEL Label_HMI
                    VALUE           ' OOHG IDE+ (By Ciro Vargas):'
                    ROW             160
                    COL             10
                    AUTOSIZE        .T.
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX Text_HMI
                    VALUE           Gbl_Text_HMI
                    ROW             160
                    COL             220
                    WIDTH           461
            END TEXTBOX
            DEFINE BUTTON Button_HMI
                    ROW             160
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select tool'
                    ONCLICK         FormToolCheck( "HMI" )
            END BUTTON

            DEFINE LABEL Label_HMGSIDE
                    VALUE           'HMGS-IDE (By Walter Formigoni):'
                    ROW             190
                    COL             10
                    AUTOSIZE        .T.
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX Text_HMGSIDE
                    VALUE           Gbl_Text_HMGSIDE
                    ROW             190
                    COL             220
                    WIDTH           461
            END TEXTBOX
            DEFINE BUTTON Button_HMGSIDE
                    ROW             190
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select tool'
                    ONCLICK         FormToolCheck( "HMGSIDE" )
            END BUTTON

         END PAGE

         DEFINE PAGE "DBF Tool"

            @ 102 , 10 LABEL LDummy_Dbf ;
               VALUE 'Dbf Tools Location:' ;
               WIDTH 275 ;
               FONT 'arial' SIZE 10 BOLD ;
               TRANSPARENT ;
               FONTCOLOR DEF_COLORBLUE

            DEFINE LABEL Label_Dbf
                    VALUE           'Select DBF Tool:'
                    ROW             130
                    COL             10
                    AUTOSIZE        .T.
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX Text_Dbf
                    VALUE           Gbl_Text_Dbf
                    ROW             130
                    COL             220
                    WIDTH           461
            END TEXTBOX
            DEFINE BUTTON Button_Dbf
                    ROW             130
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select tool'
                    ONCLICK         If ( !Empty( FileName := BugGetFile( { {'Application','*.exe'} } , 'Select Dbf Tool' , US_FileNameOnlyPath( WinGSettings.Text_Dbf.Value ) , .F. , .T. ) ) , WinGSettings.Text_Dbf.Value := FileName , )
            END BUTTON

            DEFINE CHECKBOX Check_DBF_NoComillas
                    CAPTION         "Do Not Use Quotes in DBF's Name"
                    ROW             160
                    COL             10
                    WIDTH           250
                    HEIGHT          20
                    VALUE           if( Gbl_Comillas_DBF == '"' , .F. , .T. )
                    TOOLTIP         "Do not use quotes when opening DBF tool"
                    ON CHANGE       Gbl_Comillas_DBF := if( WinGSettings.Check_DBF_NoComillas.Value , '' , '"' )
            END CHECKBOX

         END PAGE

         //-- Oficial Minigui 1.x ----------------------------------------------------//
         DEFINE PAGE "HMG 1.x with BCC32"

            @ 43 , 10 LABEL &("LDummy_"+DefineMiniGui1+DefineBorland) ;
               VALUE 'Folders for HMG 1.x with BCC32:' ;
               WIDTH 601 ;
               FONT 'arial' SIZE 10 BOLD ;
               TRANSPARENT ;
               FONTCOLOR DEF_COLORBLUE

// Minigui folder
            DEFINE LABEL &("L_"+DefineMiniGui1+DefineBorland)
                    ROW             70
                    COL             10
                    WIDTH           109
                    VALUE           'HMG Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("T_"+DefineMiniGui1+DefineBorland)
                    VALUE           &( "Gbl_T_M_"+DefineMiniGui1+DefineBorland )
                    ROW             70
                    COL             120
                    WIDTH           561
            END TEXTBOX
            DEFINE BUTTON &("B_"+DefineMiniGui1+DefineBorland)
                    ROW             70
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder" , WinGSettings.&("T_"+DefineMiniGui1+DefineBorland).Value ) ) , WinGSettings.&("T_"+DefineMiniGui1+DefineBorland).Value := Folder , )
            END BUTTON
// Minigui Libs folder
            DEFINE LABEL &("L_LIBS_"+DefineMiniGui1+DefineBorland)
                    ROW             100
                    COL             10
                    WIDTH           109
                    VALUE           '    Libs Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("T_LIBS_"+DefineMiniGui1+DefineBorland)
                    VALUE           &( "Gbl_T_M_LIBS_"+DefineMiniGui1+DefineBorland )
                    ROW             100
                    COL             120
                    WIDTH           561
                    TOOLTIP         "Full path to HMG's libraries (usually subfolder 'lib' of HMG Folder)"
            END TEXTBOX
            DEFINE BUTTON &("B_LIBS_"+DefineMiniGui1+DefineBorland)
                    ROW             100
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder" , WinGSettings.&("T_LIBS_"+DefineMiniGui1+DefineBorland).Value ) ) , WinGSettings.&("T_LIBS_"+DefineMiniGui1+DefineBorland).Value := Folder , )
            END BUTTON
// Borland Folder
            DEFINE LABEL &("LC_"+DefineMiniGui1+DefineBorland)
                    ROW             130
                    COL             10
                    WIDTH           109
                    VALUE           'BCC32 Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("TC_"+DefineMiniGui1+DefineBorland)
                    VALUE           &( "Gbl_T_C_"+DefineMiniGui1+DefineBorland )
                    ROW             130
                    COL             120
                    WIDTH           561
            END TEXTBOX
            DEFINE BUTTON &("BC_"+DefineMiniGui1+DefineBorland)
                    ROW             130
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder" , WinGSettings.&("TC_"+DefineMiniGui1+DefineBorland).Value ) ) , WinGSettings.&("TC_"+DefineMiniGui1+DefineBorland).Value := Folder , )
            END BUTTON
// Borland Libs Folder
            DEFINE LABEL &("LC_LIBS_"+DefineMiniGui1+DefineBorland)
                    ROW             160
                    COL             10
                    WIDTH           109
                    VALUE           '    Libs Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("TC_LIBS_"+DefineMiniGui1+DefineBorland)
                    VALUE           &( "Gbl_T_C_LIBS_"+DefineMiniGui1+DefineBorland )
                    ROW             160
                    COL             120
                    WIDTH           561
                    TOOLTIP         "Full path to BCC32's libraries (usually subfolder 'lib' of BCC32 Folder)"
            END TEXTBOX
            DEFINE BUTTON &("BC_LIBS_"+DefineMiniGui1+DefineBorland)
                    ROW             160
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder" , WinGSettings.&("TC_LIBS_"+DefineMiniGui1+DefineBorland).Value ) ) , WinGSettings.&("TC_LIBS_"+DefineMiniGui1+DefineBorland).Value := Folder , )
            END BUTTON
// Harbour Folder
            DEFINE LABEL &("L_"+DefineMiniGui1+DefineBorland+DefineHarbour)
                    ROW             190
                    COL             10
                    WIDTH           109
                    VALUE           'Harbour Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("T_"+DefineMiniGui1+DefineBorland+DefineHarbour)
                    VALUE           &( "Gbl_T_H_"+DefineMiniGui1+DefineBorland )
                    ROW             190
                    COL             120
                    WIDTH           561
            END TEXTBOX
            DEFINE BUTTON &("B_"+DefineMiniGui1+DefineBorland+DefineHarbour)
                    ROW             190
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder" , WinGSettings.&("T_"+DefineMiniGui1+DefineBorland+DefineHarbour).Value ) ) , WinGSettings.&("T_"+DefineMiniGui1+DefineBorland+DefineHarbour).Value := Folder , )
            END BUTTON
// Harbour Libs Folder
            DEFINE LABEL &("L_LIBS_"+DefineMiniGui1+DefineBorland+DefineHarbour)
                    ROW             220
                    COL             10
                    WIDTH           109
                    VALUE           '    Libs Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("T_LIBS_"+DefineMiniGui1+DefineBorland+DefineHarbour)
                    VALUE           &( "Gbl_T_H_LIBS_"+DefineMiniGui1+DefineBorland )
                    ROW             220
                    COL             120
                    WIDTH           561
                    TOOLTIP         "Full path to Harbour's libraries (usually subfolder 'lib' of Harbour Folder)"
            END TEXTBOX
            DEFINE BUTTON &("B_LIBS_"+DefineMiniGui1+DefineBorland+DefineHarbour)
                    ROW             220
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder" , WinGSettings.&("T_LIBS_"+DefineMiniGui1+DefineBorland+DefineHarbour).Value ) ) , WinGSettings.&("T_LIBS_"+DefineMiniGui1+DefineBorland+DefineHarbour).Value := Folder , )
            END BUTTON
// xHarbour Folder
            DEFINE LABEL &("L_"+DefineMiniGui1+DefineBorland+DefineXHarbour)
                    ROW             250
                    COL             10
                    WIDTH           109
                    VALUE           'xHarbour Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("T_"+DefineMiniGui1+DefineBorland+DefineXHarbour)
                    VALUE           &( "Gbl_T_X_"+DefineMiniGui1+DefineBorland )
                    ROW             250
                    COL             120
                    WIDTH           561
            END TEXTBOX
            DEFINE BUTTON &("B_"+DefineMiniGui1+DefineBorland+DefineXHarbour)
                    ROW             250
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder" , WinGSettings.&("T_"+DefineMiniGui1+DefineBorland+DefineXHarbour).Value ) ) , WinGSettings.&("T_"+DefineMiniGui1+DefineBorland+DefineXHarbour).Value := Folder , )
            END BUTTON
// xHarbour Libs Folder
            DEFINE LABEL &("L_LIBS_"+DefineMiniGui1+DefineBorland+DefineXHarbour)
                    ROW             280
                    COL             10
                    WIDTH           109
                    VALUE           '    Libs Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("T_LIBS_"+DefineMiniGui1+DefineBorland+DefineXHarbour)
                    VALUE           &( "Gbl_T_X_LIBS_"+DefineMiniGui1+DefineBorland )
                    ROW             280
                    COL             120
                    WIDTH           561
                    TOOLTIP         "Full path to xHarbour's libraries (usually subfolder 'lib' of xHarbour Folder)"
            END TEXTBOX
            DEFINE BUTTON &("B_LIBS_"+DefineMiniGui1+DefineBorland+DefineXHarbour)
                    ROW             280
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder" , WinGSettings.&("T_LIBS_"+DefineMiniGui1+DefineBorland+DefineXHarbour).Value ) ) , WinGSettings.&("T_LIBS_"+DefineMiniGui1+DefineBorland+DefineXHarbour).Value := Folder , )
            END BUTTON

         END PAGE

         //-- Oficial Minigui 3.x ----------------------------------------------------//
         DEFINE PAGE "HMG 3.x with MinGW"

            @ 43 , 10 LABEL &("LDummy_"+DefineMiniGui3+DefineMinGW) ;
               VALUE 'Folders for HMG 3.x with MinGW:' ;
               WIDTH 601 ;
               FONT 'arial' SIZE 10 BOLD ;
               TRANSPARENT ;
               FONTCOLOR DEF_COLORBLUE

// Minigui Folder
            DEFINE LABEL &("L_"+DefineMiniGui3+DefineMinGW)
                    ROW             70
                    COL             10
                    WIDTH           109
                    VALUE           'HMG Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("T_"+DefineMiniGui3+DefineMinGW)
                    VALUE           &( "Gbl_T_M_"+DefineMiniGui3+DefineMinGW )
                    ROW             70
                    COL             120
                    WIDTH           561
            END TEXTBOX
            DEFINE BUTTON &("B_"+DefineMiniGui3+DefineMinGW)
                    ROW             70
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder" , WinGSettings.&("T_"+DefineMiniGui3+DefineMinGW).Value ) ) , WinGSettings.&("T_"+DefineMiniGui3+DefineMinGW).Value := Folder , )
            END BUTTON
// Minigui Libs Folder
            DEFINE LABEL &("L_LIBS_"+DefineMiniGui3+DefineMinGW)
                    ROW             100
                    COL             10
                    WIDTH           109
                    VALUE           '    Libs Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("T_LIBS_"+DefineMiniGui3+DefineMinGW)
                    VALUE           &( "Gbl_T_M_LIBS_"+DefineMiniGui3+DefineMinGW )
                    ROW             100
                    COL             120
                    WIDTH           561
                    TOOLTIP         "Full path to HMG's libraries (usually subfolder 'lib' of HMG Folder)"
            END TEXTBOX
            DEFINE BUTTON &("B_LIBS_"+DefineMiniGui3+DefineMinGW)
                    ROW             100
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder" , WinGSettings.&("T_LIBS_"+DefineMiniGui3+DefineMinGW).Value ) ) , WinGSettings.&("T_LIBS_"+DefineMiniGui3+DefineMinGW).Value := Folder , )
            END BUTTON
// MinGW Folder
            DEFINE LABEL &("LC_"+DefineMiniGui3+DefineMinGW)
                    ROW             130
                    COL             10
                    WIDTH           109
                    VALUE           'MinGW Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("TC_"+DefineMiniGui3+DefineMinGW)
                    VALUE           &( "Gbl_T_C_"+DefineMiniGui3+DefineMinGW )
                    ROW             130
                    COL             120
                    WIDTH           561
            END TEXTBOX
            DEFINE BUTTON &("BC_"+DefineMiniGui3+DefineMinGW)
                    ROW             130
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder" , WinGSettings.&("TC_"+DefineMiniGui3+DefineMinGW).Value ) ) , WinGSettings.&("TC_"+DefineMiniGui3+DefineMinGW).Value := Folder , )
            END BUTTON
// MinGW Libs Folder
            DEFINE LABEL &("LC_LIBS_"+DefineMiniGui3+DefineMinGW)
                    ROW             160
                    COL             10
                    WIDTH           109
                    VALUE           '    Libs Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("TC_LIBS_"+DefineMiniGui3+DefineMinGW)
                    VALUE           &( "Gbl_T_C_LIBS_"+DefineMiniGui3+DefineMinGW )
                    ROW             160
                    COL             120
                    WIDTH           561
                    TOOLTIP         "Full path to MinGW's libraries (usually subfolder 'lib' of MinGW Folder for 32 bits versions or 'i686-w64-mingw32\lib' for 32+64 bits versions)"
            END TEXTBOX
            DEFINE BUTTON &("BC_LIBS_"+DefineMiniGui3+DefineMinGW)
                    ROW             160
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder" , WinGSettings.&("TC_LIBS_"+DefineMiniGui3+DefineMinGW).Value ) ) , WinGSettings.&("TC_LIBS_"+DefineMiniGui3+DefineMinGW).Value := Folder , )
            END BUTTON
// Harbour Folder
            DEFINE LABEL &("L_"+DefineMiniGui3+DefineMinGW+DefineHarbour)
                    ROW             190
                    COL             10
                    WIDTH           109
                    VALUE           'Harbour Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("T_"+DefineMiniGui3+DefineMinGW+DefineHarbour)
                    VALUE           &( "Gbl_T_H_"+DefineMiniGui3+DefineMinGW )
                    ROW             190
                    COL             120
                    WIDTH           561
            END TEXTBOX
            DEFINE BUTTON &("B_"+DefineMiniGui3+DefineMinGW+DefineHarbour)
                    ROW             190
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder" , WinGSettings.&("T_"+DefineMiniGui3+DefineMinGW+DefineHarbour).Value ) ) , WinGSettings.&("T_"+DefineMiniGui3+DefineMinGW+DefineHarbour).Value := Folder , )
            END BUTTON
// Harbour Libs Folder
            DEFINE LABEL &("L_LIBS_"+DefineMiniGui3+DefineMinGW+DefineHarbour)
                    ROW             220
                    COL             10
                    WIDTH           109
                    VALUE           '    Libs Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("T_LIBS_"+DefineMiniGui3+DefineMinGW+DefineHarbour)
                    VALUE           &( "Gbl_T_H_LIBS_"+DefineMiniGui3+DefineMinGW )
                    ROW             220
                    COL             120
                    WIDTH           561
                    TOOLTIP         "Full path to Harbour's libraries (usually subfolder 'lib' or 'lib\win\mingw' or 'lib\win\ming64' of Harbour Folder)"
            END TEXTBOX
            DEFINE BUTTON &("B_LIBS_"+DefineMiniGui3+DefineMinGW+DefineHarbour)
                    ROW             220
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder" , WinGSettings.&("T_LIBS_"+DefineMiniGui3+DefineMinGW+DefineHarbour).Value ) ) , WinGSettings.&("T_LIBS_"+DefineMiniGui3+DefineMinGW+DefineHarbour).Value := Folder , )
            END BUTTON
// xHarbour Folder
            DEFINE LABEL &("L_"+DefineMiniGui3+DefineMinGW+DefineXHarbour)
                    ROW             250
                    COL             10
                    WIDTH           109
                    VALUE           'xHarbour Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("T_"+DefineMiniGui3+DefineMinGW+DefineXHarbour)
                    VALUE           &( "Gbl_T_X_"+DefineMiniGui3+DefineMinGW )
                    ROW             250
                    COL             120
                    WIDTH           561
            END TEXTBOX
            DEFINE BUTTON &("B_"+DefineMiniGui3+DefineMinGW+DefineXHarbour)
                    ROW             250
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder" , WinGSettings.&("T_"+DefineMiniGui3+DefineMinGW+DefineXHarbour).Value ) ) , WinGSettings.&("T_"+DefineMiniGui3+DefineMinGW+DefineXHarbour).Value := Folder , )
            END BUTTON
// xHarbour Libs Folder
            DEFINE LABEL &("L_LIBS_"+DefineMiniGui3+DefineMinGW+DefineXHarbour)
                    ROW             280
                    COL             10
                    WIDTH           109
                    VALUE           '    Libs Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("T_LIBS_"+DefineMiniGui3+DefineMinGW+DefineXHarbour)
                    VALUE           &( "Gbl_T_X_LIBS_"+DefineMiniGui3+DefineMinGW )
                    ROW             280
                    COL             120
                    WIDTH           561
                    TOOLTIP         "Full path to xHarbour's libraries (usually subfolder 'lib' or 'lib\win\mingw' or 'lib\win\ming64' of xHarbour Folder)"
            END TEXTBOX
            DEFINE BUTTON &("B_LIBS_"+DefineMiniGui3+DefineMinGW+DefineXHarbour)
                    ROW             280
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder" , WinGSettings.&("T_LIBS_"+DefineMiniGui3+DefineMinGW+DefineXHarbour).Value ) ) , WinGSettings.&("T_LIBS_"+DefineMiniGui3+DefineMinGW+DefineXHarbour).Value := Folder , )
            END BUTTON

         END PAGE

         //-- Extended Minigui 1.x ----------------------------------------------------//
         DEFINE PAGE "HMG Extended with BCC32"

            @ 43 , 10 LABEL &("LDummy_"+DefineExtended1+DefineBorland) ;
               VALUE 'Folders for HMG Extended with BCC32:' ;
               WIDTH 601 ;
               FONT 'arial' SIZE 10 BOLD ;
               TRANSPARENT ;
               FONTCOLOR DEF_COLORBLUE

// Minigui Folder
            DEFINE LABEL &("L_"+DefineExtended1+DefineBorland)
                    ROW             70
                    COL             10
                    WIDTH           109
                    VALUE           'Extended Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("T_"+DefineExtended1+DefineBorland)
                    VALUE           &( "Gbl_T_M_"+DefineExtended1+DefineBorland )
                    ROW             70
                    COL             120
                    WIDTH           561
            END TEXTBOX
            DEFINE BUTTON &("B_"+DefineExtended1+DefineBorland)
                    ROW             70
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder" , WinGSettings.&("T_"+DefineExtended1+DefineBorland).Value ) ) , WinGSettings.&("T_"+DefineExtended1+DefineBorland).Value := Folder , )
            END BUTTON
// Minigui Libs Folder
            DEFINE LABEL &("L_LIBS_"+DefineExtended1+DefineBorland)
                    ROW             100
                    COL             10
                    WIDTH           109
                    VALUE           '    Libs Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("T_LIBS_"+DefineExtended1+DefineBorland)
                    VALUE           &( "Gbl_T_M_LIBS_"+DefineExtended1+DefineBorland )
                    ROW             100
                    COL             120
                    WIDTH           561
                    TOOLTIP         "Full path to HMG Extended's libraries (usually subfolder 'lib' of Extended Folder)"
            END TEXTBOX
            DEFINE BUTTON &("B_LIBS_"+DefineExtended1+DefineBorland)
                    ROW             100
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder" , WinGSettings.&("T_LIBS_"+DefineExtended1+DefineBorland).Value ) ) , WinGSettings.&("T_LIBS_"+DefineExtended1+DefineBorland).Value := Folder , )
            END BUTTON
// Borland Folder
            DEFINE LABEL &("LC_"+DefineExtended1+DefineBorland)
                    ROW             130
                    COL             10
                    WIDTH           109
                    VALUE           'BCC32 Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("TC_"+DefineExtended1+DefineBorland)
                    VALUE           &( "Gbl_T_C_"+DefineExtended1+DefineBorland )
                    ROW             130
                    COL             120
                    WIDTH           561
            END TEXTBOX
            DEFINE BUTTON &("BC_"+DefineExtended1+DefineBorland)
                    ROW             130
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder" , WinGSettings.&("TC_"+DefineExtended1+DefineBorland).Value ) ) , WinGSettings.&("TC_"+DefineExtended1+DefineBorland).Value := Folder , )
            END BUTTON
// Borland Libs Folder
            DEFINE LABEL &("LC_LIBS_"+DefineExtended1+DefineBorland)
                    ROW             160
                    COL             10
                    WIDTH           109
                    VALUE           '    Libs Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("TC_LIBS_"+DefineExtended1+DefineBorland)
                    VALUE           &( "Gbl_T_C_LIBS_"+DefineExtended1+DefineBorland )
                    ROW             160
                    COL             120
                    WIDTH           561
                    TOOLTIP         "Full path to BCC32's libraries (usually subfolder 'lib' of BCC32 Folder)"
            END TEXTBOX
            DEFINE BUTTON &("BC_LIBS_"+DefineExtended1+DefineBorland)
                    ROW             160
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder" , WinGSettings.&("TC_LIBS_"+DefineExtended1+DefineBorland).Value ) ) , WinGSettings.&("TC_LIBS_"+DefineExtended1+DefineBorland).Value := Folder , )
            END BUTTON
// Harbour Folder
            DEFINE LABEL &("L_"+DefineExtended1+DefineBorland+DefineHarbour)
                    ROW             190
                    COL             10
                    WIDTH           109
                    VALUE           'Harbour Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("T_"+DefineExtended1+DefineBorland+DefineHarbour)
                    VALUE           &( "Gbl_T_H_"+DefineExtended1+DefineBorland )
                    ROW             190
                    COL             120
                    WIDTH           561
            END TEXTBOX
            DEFINE BUTTON &("B_"+DefineExtended1+DefineBorland+DefineHarbour)
                    ROW             190
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder" , WinGSettings.&("T_"+DefineExtended1+DefineBorland+DefineHarbour).Value ) ) , WinGSettings.&("T_"+DefineExtended1+DefineBorland+DefineHarbour).Value := Folder , )
            END BUTTON
// Harbour Libs Folder
            DEFINE LABEL &("L_LIBS_"+DefineExtended1+DefineBorland+DefineHarbour)
                    ROW             220
                    COL             10
                    WIDTH           109
                    VALUE           '    Libs Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("T_LIBS_"+DefineExtended1+DefineBorland+DefineHarbour)
                    VALUE           &( "Gbl_T_H_LIBS_"+DefineExtended1+DefineBorland )
                    ROW             220
                    COL             120
                    WIDTH           561
                    TOOLTIP         "Full path to Harbour's libraries (usually subfolder 'lib' of Harbour Folder)"
            END TEXTBOX
            DEFINE BUTTON &("B_LIBS_"+DefineExtended1+DefineBorland+DefineHarbour)
                    ROW             220
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder" , WinGSettings.&("T_LIBS_"+DefineExtended1+DefineBorland+DefineHarbour).Value ) ) , WinGSettings.&("T_LIBS_"+DefineExtended1+DefineBorland+DefineHarbour).Value := Folder , )
            END BUTTON
// xHarbour Folder
            DEFINE LABEL &("L_"+DefineExtended1+DefineBorland+DefineXHarbour)
                    ROW             250
                    COL             10
                    WIDTH           109
                    VALUE           'xHarbour Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("T_"+DefineExtended1+DefineBorland+DefineXHarbour)
                    VALUE           &( "Gbl_T_X_"+DefineExtended1+DefineBorland )
                    ROW             250
                    COL             120
                    WIDTH           561
            END TEXTBOX
            DEFINE BUTTON &("B_"+DefineExtended1+DefineBorland+DefineXHarbour)
                    ROW             250
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder" , WinGSettings.&("T_"+DefineExtended1+DefineBorland+DefineXHarbour).Value ) ) , WinGSettings.&("T_"+DefineExtended1+DefineBorland+DefineXHarbour).Value := Folder , )
            END BUTTON
// xHarbour Libs Folder
            DEFINE LABEL &("L_LIBS_"+DefineExtended1+DefineBorland+DefineXHarbour)
                    ROW             280
                    COL             10
                    WIDTH           109
                    VALUE           '    Libs Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("T_LIBS_"+DefineExtended1+DefineBorland+DefineXHarbour)
                    VALUE           &( "Gbl_T_X_LIBS_"+DefineExtended1+DefineBorland )
                    ROW             280
                    COL             120
                    WIDTH           561
                    TOOLTIP         "Full path to xHarbour's libraries (usually subfolder 'lib' of xHarbour Folder)"
            END TEXTBOX
            DEFINE BUTTON &("B_LIBS_"+DefineExtended1+DefineBorland+DefineXHarbour)
                    ROW             280
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder" , WinGSettings.&("T_LIBS_"+DefineExtended1+DefineBorland+DefineXHarbour).Value ) ) , WinGSettings.&("T_LIBS_"+DefineExtended1+DefineBorland+DefineXHarbour).Value := Folder , )
            END BUTTON

         END PAGE

         //-- Extended Minigui 1.x ----------------------------------------------------//
         DEFINE PAGE "HMG Extended with MinGW"

            @ 43 , 10 LABEL &("LDummy_"+DefineExtended1+DefineMinGW) ;
               VALUE 'Folders for HMG Extended with MinGW:' ;
               WIDTH 601 ;
               FONT 'arial' SIZE 10 BOLD ;
               TRANSPARENT ;
               FONTCOLOR DEF_COLORBLUE

// Minigui Folder
            DEFINE LABEL &("L_"+DefineExtended1+DefineMinGW)
                    ROW             70
                    COL             10
                    WIDTH           109
                    VALUE           'Extended Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("T_"+DefineExtended1+DefineMinGW)
                    VALUE           &( "Gbl_T_M_"+DefineExtended1+DefineMinGW )
                    ROW             70
                    COL             120
                    WIDTH           561
            END TEXTBOX
            DEFINE BUTTON &("B_"+DefineExtended1+DefineMinGW)
                    ROW             70
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder" , WinGSettings.&("T_"+DefineExtended1+DefineMinGW).Value ) ) , WinGSettings.&("T_"+DefineExtended1+DefineMinGW).Value := Folder , )
            END BUTTON
// Minigui Libs Folder
            DEFINE LABEL &("L_LIBS_"+DefineExtended1+DefineMinGW)
                    ROW             100
                    COL             10
                    WIDTH           109
                    VALUE           '    Libs Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("T_LIBS_"+DefineExtended1+DefineMinGW)
                    VALUE           &( "Gbl_T_M_LIBS_"+DefineExtended1+DefineMinGW )
                    ROW             100
                    COL             120
                    WIDTH           561
                    TOOLTIP         "Full path to HMG Extended's libraries (usually subfolder 'lib' of Extended Folder)"
            END TEXTBOX
            DEFINE BUTTON &("B_LIBS_"+DefineExtended1+DefineMinGW)
                    ROW             100
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder" , WinGSettings.&("T_LIBS_"+DefineExtended1+DefineMinGW).Value ) ) , WinGSettings.&("T_LIBS_"+DefineExtended1+DefineMinGW).Value := Folder , )
            END BUTTON
// MinGW Folder
            DEFINE LABEL &("LC_"+DefineExtended1+DefineMinGW)
                    ROW             130
                    COL             10
                    WIDTH           109
                    VALUE           'MinGW Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("TC_"+DefineExtended1+DefineMinGW)
                    VALUE           &( "Gbl_T_C_"+DefineExtended1+DefineMinGW )
                    ROW             130
                    COL             120
                    WIDTH           561
            END TEXTBOX
            DEFINE BUTTON &("BC_"+DefineExtended1+DefineMinGW)
                    ROW             130
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder" , WinGSettings.&("TC_"+DefineExtended1+DefineMinGW).Value ) ) , WinGSettings.&("TC_"+DefineExtended1+DefineMinGW).Value := Folder , )
            END BUTTON
// MinGW Libs Folder
            DEFINE LABEL &("LC_LIBS_"+DefineExtended1+DefineMinGW)
                    ROW             160
                    COL             10
                    WIDTH           109
                    VALUE           '    Libs Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("TC_LIBS_"+DefineExtended1+DefineMinGW)
                    VALUE           &( "Gbl_T_C_LIBS_"+DefineExtended1+DefineMinGW )
                    ROW             160
                    COL             120
                    WIDTH           561
                    TOOLTIP         "Full path to MinGW's libraries (usually subfolder 'lib' of MinGW Folder for 32 bits versions or 'i686-w64-mingw32\lib' for 32+64 bits versions)"
            END TEXTBOX
            DEFINE BUTTON &("BC_LIBS_"+DefineExtended1+DefineMinGW)
                    ROW             160
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder" , WinGSettings.&("TC_LIBS_"+DefineExtended1+DefineMinGW).Value ) ) , WinGSettings.&("TC_LIBS_"+DefineExtended1+DefineMinGW).Value := Folder , )
            END BUTTON
// Harbour Folder
            DEFINE LABEL &("L_"+DefineExtended1+DefineMinGW+DefineHarbour)
                    ROW             190
                    COL             10
                    WIDTH           109
                    VALUE           'Harbour Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("T_"+DefineExtended1+DefineMinGW+DefineHarbour)
                    VALUE           &( "Gbl_T_H_"+DefineExtended1+DefineMinGW )
                    ROW             190
                    COL             120
                    WIDTH           561
            END TEXTBOX
            DEFINE BUTTON &("B_"+DefineExtended1+DefineMinGW+DefineHarbour)
                    ROW             190
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder" , WinGSettings.&("T_"+DefineExtended1+DefineMinGW+DefineHarbour).Value ) ) , WinGSettings.&("T_"+DefineExtended1+DefineMinGW+DefineHarbour).Value := Folder , )
            END BUTTON
// Harbour Libs Folder
            DEFINE LABEL &("L_LIBS_"+DefineExtended1+DefineMinGW+DefineHarbour)
                    ROW             220
                    COL             10
                    WIDTH           109
                    VALUE           '    Libs Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("T_LIBS_"+DefineExtended1+DefineMinGW+DefineHarbour)
                    VALUE           &( "Gbl_T_H_LIBS_"+DefineExtended1+DefineMinGW )
                    ROW             220
                    COL             120
                    WIDTH           561
                    TOOLTIP         "Full path to Harbour's libraries (usually subfolder 'lib' or 'lib\win\mingw' or 'lib\win\ming64' of Harbour Folder)"
            END TEXTBOX
            DEFINE BUTTON &("B_LIBS_"+DefineExtended1+DefineMinGW+DefineHarbour)
                    ROW             220
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder" , WinGSettings.&("T_LIBS_"+DefineExtended1+DefineMinGW+DefineHarbour).Value ) ) , WinGSettings.&("T_LIBS_"+DefineExtended1+DefineMinGW+DefineHarbour).Value := Folder , )
            END BUTTON
// xHarbour Folder
            DEFINE LABEL &("L_"+DefineExtended1+DefineMinGW+DefineXHarbour)
                    ROW             250
                    COL             10
                    WIDTH           109
                    VALUE           'xHarbour Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("T_"+DefineExtended1+DefineMinGW+DefineXHarbour)
                    VALUE           &( "Gbl_T_X_"+DefineExtended1+DefineMinGW )
                    ROW             250
                    COL             120
                    WIDTH           561
            END TEXTBOX
            DEFINE BUTTON &("B_"+DefineExtended1+DefineMinGW+DefineXHarbour)
                    ROW             250
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder" , WinGSettings.&("T_"+DefineExtended1+DefineMinGW+DefineXHarbour).Value ) ) , WinGSettings.&("T_"+DefineExtended1+DefineMinGW+DefineXHarbour).Value := Folder , )
            END BUTTON
// xHarbour Libs Folder
            DEFINE LABEL &("L_LIBS_"+DefineExtended1+DefineMinGW+DefineXHarbour)
                    ROW             280
                    COL             10
                    WIDTH           109
                    VALUE           '    Libs Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("T_LIBS_"+DefineExtended1+DefineMinGW+DefineXHarbour)
                    VALUE           &( "Gbl_T_X_LIBS_"+DefineExtended1+DefineMinGW )
                    ROW             280
                    COL             120
                    WIDTH           561
                    TOOLTIP         "Full path to xHarbour's libraries (usually subfolder 'lib' or 'lib\win\mingw' or 'lib\win\ming64' of xHarbour Folder)"
            END TEXTBOX
            DEFINE BUTTON &("B_LIBS_"+DefineExtended1+DefineMinGW+DefineXHarbour)
                    ROW             280
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder" , WinGSettings.&("T_LIBS_"+DefineExtended1+DefineMinGW+DefineXHarbour).Value ) ) , WinGSettings.&("T_LIBS_"+DefineExtended1+DefineMinGW+DefineXHarbour).Value := Folder , )
            END BUTTON

         END PAGE

         //-- Object Oriented Harbour GUI with Borland ---------------------------------------//
         DEFINE PAGE "OOHG with BCC32"

            @ 43 , 10 LABEL &("LDummy_"+DefineOohg3+DefineBorland) ;
               VALUE 'Folders for OOHG with BCC32:' ;
               WIDTH 601 ;
               FONT 'arial' SIZE 10 BOLD ;
               TRANSPARENT ;
               FONTCOLOR DEF_COLORBLUE

// Minigui Folder
            DEFINE LABEL &("L_"+DefineOohg3+DefineBorland)
                    ROW             70
                    COL             10
                    WIDTH           109
                    VALUE           'OOHG Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("T_"+DefineOohg3+DefineBorland)
                    VALUE           &( "Gbl_T_M_"+DefineOohg3+DefineBorland )
                    ROW             70
                    COL             120
                    WIDTH           561
            END TEXTBOX
            DEFINE BUTTON &("B_"+DefineOohg3+DefineBorland)
                    ROW             70
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder" , WinGSettings.&("T_"+DefineOohg3+DefineBorland).Value ) ) , WinGSettings.&("T_"+DefineOohg3+DefineBorland).Value := Folder , )
            END BUTTON
// Minigui Libs Folder
            DEFINE LABEL &("L_LIBS_"+DefineOohg3+DefineBorland)
                    ROW             100
                    COL             10
                    WIDTH           109
                    VALUE           '    Libs Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("T_LIBS_"+DefineOohg3+DefineBorland)
                    VALUE           &( "Gbl_T_M_LIBS_"+DefineOohg3+DefineBorland )
                    ROW             100
                    COL             120
                    WIDTH           561
                    TOOLTIP         "Full path to OOHG's libraries (usually subfolder 'lib' of Harbour Folder)"
            END TEXTBOX
            DEFINE BUTTON &("B_LIBS_"+DefineOohg3+DefineBorland)
                    ROW             100
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder" , WinGSettings.&("T_LIBS_"+DefineOohg3+DefineBorland).Value ) ) , WinGSettings.&("T_LIBS_"+DefineOohg3+DefineBorland).Value := Folder , )
            END BUTTON
// Borland Folder
            DEFINE LABEL &("LC_"+DefineOohg3+DefineBorland)
                    ROW             130
                    COL             10
                    WIDTH           109
                    VALUE           'BCC32 Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("TC_"+DefineOohg3+DefineBorland)
                    VALUE           &( "Gbl_T_C_"+DefineOohg3+DefineBorland )
                    ROW             130
                    COL             120
                    WIDTH           561
            END TEXTBOX
            DEFINE BUTTON &("BC_"+DefineOohg3+DefineBorland)
                    ROW             130
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder" , WinGSettings.&("TC_"+DefineOohg3+DefineBorland).Value ) ) , WinGSettings.&("TC_"+DefineOohg3+DefineBorland).Value := Folder , )
            END BUTTON
// Borland Libs Folder
            DEFINE LABEL &("LC_LIBS_"+DefineOohg3+DefineBorland)
                    ROW             160
                    COL             10
                    WIDTH           109
                    VALUE           '    Libs Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("TC_LIBS_"+DefineOohg3+DefineBorland)
                    VALUE           &( "Gbl_T_C_LIBS_"+DefineOohg3+DefineBorland )
                    ROW             160
                    COL             120
                    WIDTH           561
                    TOOLTIP         "Full path to BCC32's libraries (usually subfolder 'lib' of BCC32 Folder)"
            END TEXTBOX
            DEFINE BUTTON &("BC_LIBS_"+DefineOohg3+DefineBorland)
                    ROW             160
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder" , WinGSettings.&("TC_LIBS_"+DefineOohg3+DefineBorland).Value ) ) , WinGSettings.&("TC_LIBS_"+DefineOohg3+DefineBorland).Value := Folder , )
            END BUTTON
// Harbour Folder
            DEFINE LABEL &("L_"+DefineOohg3+DefineBorland+DefineHarbour)
                    ROW             190
                    COL             10
                    WIDTH           109
                    VALUE           'Harbour Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("T_"+DefineOohg3+DefineBorland+DefineHarbour)
                    VALUE           &( "Gbl_T_H_"+DefineOohg3+DefineBorland )
                    ROW             190
                    COL             120
                    WIDTH           561
            END TEXTBOX
            DEFINE BUTTON &("B_"+DefineOohg3+DefineBorland+DefineHarbour)
                    ROW             190
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder" , WinGSettings.&("T_"+DefineOohg3+DefineBorland+DefineHarbour).Value ) ) , WinGSettings.&("T_"+DefineOohg3+DefineBorland+DefineHarbour).Value := Folder , )
            END BUTTON
// Harbour Libs Folder
            DEFINE LABEL &("L_LIBS_"+DefineOohg3+DefineBorland+DefineHarbour)
                    ROW             220
                    COL             10
                    WIDTH           109
                    VALUE           '    Libs Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("T_LIBS_"+DefineOohg3+DefineBorland+DefineHarbour)
                    VALUE           &( "Gbl_T_H_LIBS_"+DefineOohg3+DefineBorland )
                    ROW             220
                    COL             120
                    WIDTH           561
                    TOOLTIP         "Full path to Harbour's libraries (usually subfolder 'lib' of Harbour Folder)"
            END TEXTBOX
            DEFINE BUTTON &("B_LIBS_"+DefineOohg3+DefineBorland+DefineHarbour)
                    ROW             220
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder" , WinGSettings.&("T_LIBS_"+DefineOohg3+DefineBorland+DefineHarbour).Value ) ) , WinGSettings.&("T_LIBS_"+DefineOohg3+DefineBorland+DefineHarbour).Value := Folder , )
            END BUTTON
// xHarbour Folders
            DEFINE LABEL &("L_"+DefineOohg3+DefineBorland+DefineXHarbour)
                    ROW             250
                    COL             10
                    WIDTH           109
                    VALUE           'xHarbour Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("T_"+DefineOohg3+DefineBorland+DefineXHarbour)
                    VALUE           &( "Gbl_T_X_"+DefineOohg3+DefineBorland )
                    ROW             250
                    COL             120
                    WIDTH           561
            END TEXTBOX
            DEFINE BUTTON &("B_"+DefineOohg3+DefineBorland+DefineXHarbour)
                    ROW             250
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder" , WinGSettings.&("T_"+DefineOohg3+DefineBorland+DefineXHarbour).Value ) ) , WinGSettings.&("T_"+DefineOohg3+DefineBorland+DefineXHarbour).Value := Folder , )
            END BUTTON
// xHarbour Libs Folders
            DEFINE LABEL &("L_LIBS_"+DefineOohg3+DefineBorland+DefineXHarbour)
                    ROW             280
                    COL             10
                    WIDTH           109
                    VALUE           '    Libs Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("T_LIBS_"+DefineOohg3+DefineBorland+DefineXHarbour)
                    VALUE           &( "Gbl_T_X_LIBS_"+DefineOohg3+DefineBorland )
                    ROW             280
                    COL             120
                    WIDTH           561
                    TOOLTIP         "Full path to xHarbour's libraries (usually subfolder 'lib' of xHarbour Folder)"
            END TEXTBOX
            DEFINE BUTTON &("B_LIBS_"+DefineOohg3+DefineBorland+DefineXHarbour)
                    ROW             280
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder" , WinGSettings.&("T_LIBS_"+DefineOohg3+DefineBorland+DefineXHarbour).Value ) ) , WinGSettings.&("T_LIBS_"+DefineOohg3+DefineBorland+DefineXHarbour).Value := Folder , )
            END BUTTON

         END PAGE

         //-- Object Oriented Harbour GUI with MinGW -----------------------------------------//
         DEFINE PAGE "OOHG with MinGW"

            @ 43 , 10 LABEL &("LDummy_"+DefineOohg3+DefineMinGW) ;
               VALUE 'Folders for OOHG and MinGW:' ;
               WIDTH 601 ;
               FONT 'arial' SIZE 10 BOLD ;
               TRANSPARENT ;
               FONTCOLOR DEF_COLORBLUE

// Minigui Folder
            DEFINE LABEL &("L_"+DefineOohg3+DefineMinGW)
                    ROW             70
                    COL             10
                    WIDTH           109
                    VALUE           'OOHG Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("T_"+DefineOohg3+DefineMinGW)
                    VALUE           &( "Gbl_T_M_"+DefineOohg3+DefineMinGW )
                    ROW             70
                    COL             120
                    WIDTH           561
            END TEXTBOX
            DEFINE BUTTON &("B_"+DefineOohg3+DefineMinGW)
                    ROW             70
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder" , WinGSettings.&("T_"+DefineOohg3+DefineMinGW).Value ) ) , WinGSettings.&("T_"+DefineOohg3+DefineMinGW).Value := Folder , )
            END BUTTON
// Minigui Libs Folder
            DEFINE LABEL &("L_LIBS_"+DefineOohg3+DefineMinGW)
                    ROW             100
                    COL             10
                    WIDTH           109
                    VALUE           '    Libs Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("T_LIBS_"+DefineOohg3+DefineMinGW)
                    VALUE           &( "Gbl_T_M_LIBS_"+DefineOohg3+DefineMinGW )
                    ROW             100
                    COL             120
                    WIDTH           561
                    TOOLTIP         "Full path to OOHG's libraries (usually subfolder 'lib' of OOHG Folder)"
            END TEXTBOX
            DEFINE BUTTON &("B_LIBS_"+DefineOohg3+DefineMinGW)
                    ROW             100
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder" , WinGSettings.&("T_LIBS_"+DefineOohg3+DefineMinGW).Value ) ) , WinGSettings.&("T_LIBS_"+DefineOohg3+DefineMinGW).Value := Folder , )
            END BUTTON
// MinGW Folder
            DEFINE LABEL &("LC_"+DefineOohg3+DefineMinGW)
                    ROW             130
                    COL             10
                    WIDTH           109
                    VALUE           'MinGW Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("TC_"+DefineOohg3+DefineMinGW)
                    VALUE           &( "Gbl_T_C_"+DefineOohg3+DefineMinGW )
                    ROW             130
                    COL             120
                    WIDTH           561
            END TEXTBOX
            DEFINE BUTTON &("BC_"+DefineOohg3+DefineMinGW)
                    ROW             130
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder" , WinGSettings.&("TC_"+DefineOohg3+DefineMinGW).Value ) ) , WinGSettings.&("TC_"+DefineOohg3+DefineMinGW).Value := Folder , )
            END BUTTON
// MinGW Libs Folder
            DEFINE LABEL &("LC_LIBS_"+DefineOohg3+DefineMinGW)
                    ROW             160
                    COL             10
                    WIDTH           109
                    VALUE           '    Libs Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("TC_LIBS_"+DefineOohg3+DefineMinGW)
                    VALUE           &( "Gbl_T_C_LIBS_"+DefineOohg3+DefineMinGW )
                    ROW             160
                    COL             120
                    WIDTH           561
                    TOOLTIP         "Full path to MinGW's libraries (usually subfolder 'lib' of MinGW Folder for 32 bits versions or 'i686-w64-mingw32\lib' for 32+64 bits versions)"
            END TEXTBOX
            DEFINE BUTTON &("BC_LIBS_"+DefineOohg3+DefineMinGW)
                    ROW             160
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder" , WinGSettings.&("TC_LIBS_"+DefineOohg3+DefineMinGW).Value ) ) , WinGSettings.&("TC_LIBS_"+DefineOohg3+DefineMinGW).Value := Folder , )
            END BUTTON
// Harbour Folder
            DEFINE LABEL &("L_"+DefineOohg3+DefineMinGW+DefineHarbour)
                    ROW             190
                    COL             10
                    WIDTH           109
                    VALUE           'Harbour Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("T_"+DefineOohg3+DefineMinGW+DefineHarbour)
                    VALUE           &( "Gbl_T_H_"+DefineOohg3+DefineMinGW )
                    ROW             190
                    COL             120
                    WIDTH           561
            END TEXTBOX
            DEFINE BUTTON &("B_"+DefineOohg3+DefineMinGW+DefineHarbour)
                    ROW             190
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder" , WinGSettings.&("T_"+DefineOohg3+DefineMinGW+DefineHarbour).Value ) ) , WinGSettings.&("T_"+DefineOohg3+DefineMinGW+DefineHarbour).Value := Folder , )
            END BUTTON
// Harbour Libs Folder
            DEFINE LABEL &("L_LIBS_"+DefineOohg3+DefineMinGW+DefineHarbour)
                    ROW             220
                    COL             10
                    WIDTH           109
                    VALUE           '    Libs Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("T_LIBS_"+DefineOohg3+DefineMinGW+DefineHarbour)
                    VALUE           &( "Gbl_T_H_LIBS_"+DefineOohg3+DefineMinGW )
                    ROW             220
                    COL             120
                    WIDTH           561
                    TOOLTIP         "Full path to Harbour's libraries (usually subfolder 'lib' or 'lib\win\mingw' or 'lib\win\ming64' of Harbour Folder)"
            END TEXTBOX
            DEFINE BUTTON &("B_LIBS_"+DefineOohg3+DefineMinGW+DefineHarbour)
                    ROW             220
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder" , WinGSettings.&("T_LIBS_"+DefineOohg3+DefineMinGW+DefineHarbour).Value ) ) , WinGSettings.&("T_LIBS_"+DefineOohg3+DefineMinGW+DefineHarbour).Value := Folder , )
            END BUTTON
// xHarbour Folder
            DEFINE LABEL &("L_"+DefineOohg3+DefineMinGW+DefineXHarbour)
                    ROW             250
                    COL             10
                    WIDTH           109
                    VALUE           'xHarbour Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("T_"+DefineOohg3+DefineMinGW+DefineXHarbour)
                    VALUE           &( "Gbl_T_X_"+DefineOohg3+DefineMinGW )
                    ROW             250
                    COL             120
                    WIDTH           561
            END TEXTBOX
            DEFINE BUTTON &("B_"+DefineOohg3+DefineMinGW+DefineXHarbour)
                    ROW             250
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder" , WinGSettings.&("T_"+DefineOohg3+DefineMinGW+DefineXHarbour).Value ) ) , WinGSettings.&("T_"+DefineOohg3+DefineMinGW+DefineXHarbour).Value := Folder , )
            END BUTTON
// xHarbour Libs Folder
            DEFINE LABEL &("L_LIBS_"+DefineOohg3+DefineMinGW+DefineXHarbour)
                    ROW             280
                    COL             10
                    WIDTH           109
                    VALUE           '    Libs Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("T_LIBS_"+DefineOohg3+DefineMinGW+DefineXHarbour)
                    VALUE           &( "Gbl_T_X_LIBS_"+DefineOohg3+DefineMinGW )
                    ROW             280
                    COL             120
                    WIDTH           561
                    TOOLTIP         "Full path to xHarbour's libraries (usually subfolder 'lib' or 'lib\win\mingw' or 'lib\win\ming64' of xHarbour Folder)"
            END TEXTBOX
            DEFINE BUTTON &("B_LIBS_"+DefineOohg3+DefineMinGW+DefineXHarbour)
                    ROW             280
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder" , WinGSettings.&("T_LIBS_"+DefineOohg3+DefineMinGW+DefineXHarbour).Value ) ) , WinGSettings.&("T_LIBS_"+DefineOohg3+DefineMinGW+DefineXHarbour).Value := Folder , )
            END BUTTON

         END PAGE

         //-- Object Oriented Harbour GUI with Pelles C --------------------------------------//
         DEFINE PAGE "OOHG with Pelles C"

            @ 43 , 10 LABEL &("LDummy_"+DefineOohg3+DefinePelles) ;
               VALUE 'Folders for OOHG with Pelles C:' ;
               WIDTH 601 ;
               FONT 'arial' SIZE 10 BOLD ;
               TRANSPARENT ;
               FONTCOLOR DEF_COLORBLUE

// Minigui Folder
            DEFINE LABEL &("L_"+DefineOohg3+DefinePelles)
                    ROW             70
                    COL             10
                    WIDTH           109
                    VALUE           'OOHG Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("T_"+DefineOohg3+DefinePelles)
                    VALUE           &( "Gbl_T_M_"+DefineOohg3+DefinePelles )
                    ROW             70
                    COL             120
                    WIDTH           561
            END TEXTBOX
            DEFINE BUTTON &("B_"+DefineOohg3+DefinePelles)
                    ROW             70
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder" , WinGSettings.&("T_"+DefineOohg3+DefinePelles).Value ) ) , WinGSettings.&("T_"+DefineOohg3+DefinePelles).Value := Folder , )
            END BUTTON
// Minigui Libs Folder
            DEFINE LABEL &("L_LIBS_"+DefineOohg3+DefinePelles)
                    ROW             100
                    COL             10
                    WIDTH           109
                    VALUE           '    Libs Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("T_LIBS_"+DefineOohg3+DefinePelles)
                    VALUE           &( "Gbl_T_M_LIBS_"+DefineOohg3+DefinePelles )
                    ROW             100
                    COL             120
                    WIDTH           561
                    TOOLTIP         "Full path to OOHG's libraries (usually subfolder 'lib' of OOHG Folder)"
            END TEXTBOX
            DEFINE BUTTON &("B_LIBS_"+DefineOohg3+DefinePelles)
                    ROW             100
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder" , WinGSettings.&("T_LIBS_"+DefineOohg3+DefinePelles).Value ) ) , WinGSettings.&("T_LIBS_"+DefineOohg3+DefinePelles).Value := Folder , )
            END BUTTON
// Pelles Folder
            DEFINE LABEL &("LC_"+DefineOohg3+DefinePelles)
                    ROW             130
                    COL             10
                    WIDTH           109
                    VALUE           'Pelles Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("TC_"+DefineOohg3+DefinePelles)
                    VALUE           &( "Gbl_T_C_"+DefineOohg3+DefinePelles )
                    ROW             130
                    COL             120
                    WIDTH           561
            END TEXTBOX
            DEFINE BUTTON &("BC_"+DefineOohg3+DefinePelles)
                    ROW             130
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder" , WinGSettings.&("TC_"+DefineOohg3+DefinePelles).Value ) ) , WinGSettings.&("TC_"+DefineOohg3+DefinePelles).Value := Folder , )
            END BUTTON
// Pelles Libs Folder
            DEFINE LABEL &("LC_LIBS_"+DefineOohg3+DefinePelles)
                    ROW             160
                    COL             10
                    WIDTH           109
                    VALUE           '    Libs Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("TC_LIBS_"+DefineOohg3+DefinePelles)
                    VALUE           &( "Gbl_T_C_LIBS_"+DefineOohg3+DefinePelles )
                    ROW             160
                    COL             120
                    WIDTH           561
                    TOOLTIP         "Full path to Pelles's libraries (usually subfolder 'lib' of Pelles Folder)"
            END TEXTBOX
            DEFINE BUTTON &("BC_LIBS_"+DefineOohg3+DefinePelles)
                    ROW             160
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder" , WinGSettings.&("TC_LIBS_"+DefineOohg3+DefinePelles).Value ) ) , WinGSettings.&("TC_LIBS_"+DefineOohg3+DefinePelles).Value := Folder , )
            END BUTTON
// Harbour Folder
            DEFINE LABEL &("L_"+DefineOohg3+DefinePelles+DefineHarbour)
                    ROW             190
                    COL             10
                    WIDTH           109
                    VALUE           'Harbour Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("T_"+DefineOohg3+DefinePelles+DefineHarbour)
                    VALUE           &( "Gbl_T_H_"+DefineOohg3+DefinePelles )
                    ROW             190
                    COL             120
                    WIDTH           561
            END TEXTBOX
            DEFINE BUTTON &("B_"+DefineOohg3+DefinePelles+DefineHarbour)
                    ROW             190
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder" , WinGSettings.&("T_"+DefineOohg3+DefinePelles+DefineHarbour).Value ) ) , WinGSettings.&("T_"+DefineOohg3+DefinePelles+DefineHarbour).Value := Folder , )
            END BUTTON
// Harbour Libs Folder
            DEFINE LABEL &("L_LIBS_"+DefineOohg3+DefinePelles+DefineHarbour)
                    ROW             220
                    COL             10
                    WIDTH           109
                    VALUE           '    Libs Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("T_LIBS_"+DefineOohg3+DefinePelles+DefineHarbour)
                    VALUE           &( "Gbl_T_H_LIBS_"+DefineOohg3+DefinePelles )
                    ROW             220
                    COL             120
                    WIDTH           561
                    TOOLTIP         "Full path to Harbour's libraries (usually subfolder 'lib' of Harbour Folder)"
            END TEXTBOX
            DEFINE BUTTON &("B_LIBS_"+DefineOohg3+DefinePelles+DefineHarbour)
                    ROW             220
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder" , WinGSettings.&("T_LIBS_"+DefineOohg3+DefinePelles+DefineHarbour).Value ) ) , WinGSettings.&("T_LIBS_"+DefineOohg3+DefinePelles+DefineHarbour).Value := Folder , )
            END BUTTON
// xHarbour Folder
            DEFINE LABEL &("L_"+DefineOohg3+DefinePelles+DefineXHarbour)
                    ROW             250
                    COL             10
                    WIDTH           109
                    VALUE           'xHarbour Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("T_"+DefineOohg3+DefinePelles+DefineXHarbour)
                    VALUE           &( "Gbl_T_X_"+DefineOohg3+DefinePelles )
                    ROW             250
                    COL             120
                    WIDTH           561
            END TEXTBOX
            DEFINE BUTTON &("B_"+DefineOohg3+DefinePelles+DefineXHarbour)
                    ROW             250
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder" , WinGSettings.&("T_"+DefineOohg3+DefinePelles+DefineXHarbour).Value ) ) , WinGSettings.&("T_"+DefineOohg3+DefinePelles+DefineXHarbour).Value := Folder , )
            END BUTTON
// xHarbour Libs Folder
            DEFINE LABEL &("L_LIBS_"+DefineOohg3+DefinePelles+DefineXHarbour)
                    ROW             280
                    COL             10
                    WIDTH           109
                    VALUE           '    Libs Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("T_LIBS_"+DefineOohg3+DefinePelles+DefineXHarbour)
                    VALUE           &( "Gbl_T_X_LIBS_"+DefineOohg3+DefinePelles )
                    ROW             280
                    COL             120
                    WIDTH           561
                    TOOLTIP         "Full path to xHarbour's libraries (usually subfolder 'lib' of xHarbour Folder)"
            END TEXTBOX
            DEFINE BUTTON &("B_LIBS_"+DefineOohg3+DefinePelles+DefineXHarbour)
                    ROW             280
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder" , WinGSettings.&("T_LIBS_"+DefineOohg3+DefinePelles+DefineXHarbour).Value ) ) , WinGSettings.&("T_LIBS_"+DefineOohg3+DefinePelles+DefineXHarbour).Value := Folder , )
            END BUTTON

         END PAGE

      END TAB

      DEFINE BUTTON B_OK
             ROW             370
             COL             100
             WIDTH           200
             HEIGHT          25
             CAPTION         'OK'
             TOOLTIP         'Confirm changes'
             ONCLICK         ( GlobalSettingsSave() , WinGSettings.Release() )
      END BUTTON

      DEFINE BUTTON B_CANCEL
             ROW             370
             COL             635
             WIDTH            80
             HEIGHT          25
             CAPTION         'Cancel'
             TOOLTIP         'Cancel changes'
             ONCLICK         WinGSettings.Release()
      END BUTTON

   END WINDOW

   ON KEY ESCAPE OF WinGSettings ACTION GlobalEscape()

   CENTER   WINDOW WinGSettings

   ACTIVATE WINDOW WinGSettings

Return .T.

Function SelectTab

   if empty( PUB_cProjectFolder )
      WinGSettings.TabGSettings.value := 1
   else
      do case
         case Prj_Radio_MiniGui == DEF_RG_MINIGUI1 .and. Prj_Radio_Cpp == DEF_RG_BORLAND
            WinGSettings.TabGSettings.value := 3
         case Prj_Radio_MiniGui == DEF_RG_MINIGUI3 .and. Prj_Radio_Cpp == DEF_RG_MINGW
            WinGSettings.TabGSettings.value := 4
         case Prj_Radio_MiniGui == DEF_RG_EXTENDED1 .and. Prj_Radio_Cpp == DEF_RG_BORLAND
            WinGSettings.TabGSettings.value := 5
         case Prj_Radio_MiniGui == DEF_RG_EXTENDED1 .and. Prj_Radio_Cpp == DEF_RG_MINGW
            WinGSettings.TabGSettings.value := 6
         case Prj_Radio_MiniGui == DEF_RG_OOHG3 .and. Prj_Radio_Cpp == DEF_RG_BORLAND
            WinGSettings.TabGSettings.value := 7
         case Prj_Radio_MiniGui == DEF_RG_OOHG3 .and. Prj_Radio_Cpp == DEF_RG_MINGW
            WinGSettings.TabGSettings.value := 8
         case Prj_Radio_MiniGui == DEF_RG_OOHG3 .and. Prj_Radio_Cpp == DEF_RG_PELLES
            WinGSettings.TabGSettings.value := 9
         otherwise
            US_Log( "Invalid combination: Prj_Radio_MiniGui: " + US_VarToStr( Prj_Radio_MiniGui ) + HB_OsNewLine() + ;
                    "                     Prj_Radio_Cpp: " + US_VarToStr( Prj_Radio_Cpp ) )
      endcase
   endif

Return Nil

Function GlobalEscape()
   if GlobalChanged()
      if MyMsgYesNo('Do you want cancel changes ?')
         WinGSettings.release()
      endif
   else
      WinGSettings.release()
   endif
Return .T.

Function GlobalChanged()
   if Gbl_TEditor      != WinGSettings.TEditor.value      .or. ;
      Gbl_Text_HMI     != WinGSettings.Text_HMI.value     .or. ;
      Gbl_Text_HMGSIDE != WinGSettings.Text_HMGSIDE.value .or. ;
      Gbl_Text_Dbf     != WinGSettings.Text_Dbf.value     .or. ;
      &( "Gbl_T_M_"+DefineMiniGui1+DefineBorland ) != WinGSettings.&("T_"+DefineMiniGui1+DefineBorland).value .or. ;
      &( "Gbl_T_C_"+DefineMiniGui1+DefineBorland ) != WinGSettings.&("TC_"+DefineMiniGui1+DefineBorland).value .or. ;
      &( "Gbl_T_H_"+DefineMiniGui1+DefineBorland ) != WinGSettings.&("T_"+DefineMiniGui1+DefineBorland+DefineHarbour).value .or. ;
      &( "Gbl_T_X_"+DefineMiniGui1+DefineBorland ) != WinGSettings.&("T_"+DefineMiniGui1+DefineBorland+DefineXHarbour).value .or. ;
      &( "Gbl_T_M_"+DefineMiniGui3+DefineMinGW ) != WinGSettings.&("T_"+DefineMiniGui3+DefineMinGW).value .or. ;
      &( "Gbl_T_C_"+DefineMiniGui3+DefineMinGW ) != WinGSettings.&("TC_"+DefineMiniGui3+DefineMinGW).value .or. ;
      &( "Gbl_T_H_"+DefineMiniGui3+DefineMinGW ) != WinGSettings.&("T_"+DefineMiniGui3+DefineMinGW+DefineHarbour).value .or. ;
      &( "Gbl_T_X_"+DefineMiniGui3+DefineMinGW ) != WinGSettings.&("T_"+DefineMiniGui3+DefineMinGW+DefineXHarbour).value .or. ;
      &( "Gbl_T_M_"+DefineExtended1+DefineBorland ) != WinGSettings.&("T_"+DefineExtended1+DefineBorland).value .or. ;
      &( "Gbl_T_C_"+DefineExtended1+DefineBorland ) != WinGSettings.&("TC_"+DefineExtended1+DefineBorland).value .or. ;
      &( "Gbl_T_H_"+DefineExtended1+DefineBorland ) != WinGSettings.&("T_"+DefineExtended1+DefineBorland+DefineHarbour).value .or. ;
      &( "Gbl_T_X_"+DefineExtended1+DefineBorland ) != WinGSettings.&("T_"+DefineExtended1+DefineBorland+DefineXHarbour).value .or. ;
      &( "Gbl_T_M_"+DefineExtended1+DefineMinGW ) != WinGSettings.&("T_"+DefineExtended1+DefineMinGW).value .or. ; 
      &( "Gbl_T_C_"+DefineExtended1+DefineMinGW ) != WinGSettings.&("TC_"+DefineExtended1+DefineMinGW).value .or. ;
      &( "Gbl_T_H_"+DefineExtended1+DefineMinGW ) != WinGSettings.&("T_"+DefineExtended1+DefineMinGW+DefineHarbour).value .or. ;
      &( "Gbl_T_X_"+DefineExtended1+DefineMinGW ) != WinGSettings.&("T_"+DefineExtended1+DefineMinGW+DefineXHarbour).value .or. ;
      &( "Gbl_T_M_"+DefineOohg3+DefineBorland ) != WinGSettings.&("T_"+DefineOohg3+DefineBorland).value .or. ;
      &( "Gbl_T_C_"+DefineOohg3+DefineBorland ) != WinGSettings.&("TC_"+DefineOohg3+DefineBorland).value .or. ;
      &( "Gbl_T_H_"+DefineOohg3+DefineBorland ) != WinGSettings.&("T_"+DefineOohg3+DefineBorland+DefineHarbour).value .or. ;
      &( "Gbl_T_X_"+DefineOohg3+DefineBorland ) != WinGSettings.&("T_"+DefineOohg3+DefineBorland+DefineXHarbour).value .or. ;
      &( "Gbl_T_M_"+DefineOohg3+DefineMinGW ) != WinGSettings.&("T_"+DefineOohg3+DefineMinGW).value .or. ;
      &( "Gbl_T_C_"+DefineOohg3+DefineMinGW ) != WinGSettings.&("TC_"+DefineOohg3+DefineMinGW).value .or. ;
      &( "Gbl_T_H_"+DefineOohg3+DefineMinGW ) != WinGSettings.&("T_"+DefineOohg3+DefineMinGW+DefineHarbour).value .or. ;
      &( "Gbl_T_X_"+DefineOohg3+DefineMinGW ) != WinGSettings.&("T_"+DefineOohg3+DefineMinGW+DefineXHarbour).value .or. ;
      &( "Gbl_T_M_"+DefineOohg3+DefinePelles ) != WinGSettings.&("T_"+DefineOohg3+DefinePelles).value .or. ;
      &( "Gbl_T_C_"+DefineOohg3+DefinePelles ) != WinGSettings.&("TC_"+DefineOohg3+DefinePelles).value .or. ;
      &( "Gbl_T_H_"+DefineOohg3+DefinePelles ) != WinGSettings.&("T_"+DefineOohg3+DefinePelles+DefineHarbour).value .or. ;
      &( "Gbl_T_X_"+DefineOohg3+DefinePelles ) != WinGSettings.&("T_"+DefineOohg3+DefinePelles+DefineXHarbour).value .or. ;
      &( "Gbl_T_M_LIBS_"+DefineMiniGui1+DefineBorland ) != WinGSettings.&("T_LIBS_"+DefineMiniGui1+DefineBorland).value .or. ;
      &( "Gbl_T_C_LIBS_"+DefineMiniGui1+DefineBorland ) != WinGSettings.&("TC_LIBS_"+DefineMiniGui1+DefineBorland).value .or. ;
      &( "Gbl_T_H_LIBS_"+DefineMiniGui1+DefineBorland ) != WinGSettings.&("T_LIBS_"+DefineMiniGui1+DefineBorland+DefineHarbour).value .or. ;
      &( "Gbl_T_X_LIBS_"+DefineMiniGui1+DefineBorland ) != WinGSettings.&("T_LIBS_"+DefineMiniGui1+DefineBorland+DefineXHarbour).value .or. ;
      &( "Gbl_T_M_LIBS_"+DefineMiniGui3+DefineMinGW ) != WinGSettings.&("T_LIBS_"+DefineMiniGui3+DefineMinGW).value .or. ;
      &( "Gbl_T_C_LIBS_"+DefineMiniGui3+DefineMinGW ) != WinGSettings.&("TC_LIBS_"+DefineMiniGui3+DefineMinGW).value .or. ;
      &( "Gbl_T_H_LIBS_"+DefineMiniGui3+DefineMinGW ) != WinGSettings.&("T_LIBS_"+DefineMiniGui3+DefineMinGW+DefineHarbour).value .or. ;
      &( "Gbl_T_X_LIBS_"+DefineMiniGui3+DefineMinGW ) != WinGSettings.&("T_LIBS_"+DefineMiniGui3+DefineMinGW+DefineXHarbour).value .or. ;
      &( "Gbl_T_M_LIBS_"+DefineExtended1+DefineBorland ) != WinGSettings.&("T_LIBS_"+DefineExtended1+DefineBorland).value .or. ;
      &( "Gbl_T_C_LIBS_"+DefineExtended1+DefineBorland ) != WinGSettings.&("TC_LIBS_"+DefineExtended1+DefineBorland).value .or. ;
      &( "Gbl_T_H_LIBS_"+DefineExtended1+DefineBorland ) != WinGSettings.&("T_LIBS_"+DefineExtended1+DefineBorland+DefineHarbour).value .or. ;
      &( "Gbl_T_X_LIBS_"+DefineExtended1+DefineBorland ) != WinGSettings.&("T_LIBS_"+DefineExtended1+DefineBorland+DefineXHarbour).value .or. ;
      &( "Gbl_T_M_LIBS_"+DefineExtended1+DefineMinGW ) != WinGSettings.&("T_LIBS_"+DefineExtended1+DefineMinGW).value .or. ;
      &( "Gbl_T_C_LIBS_"+DefineExtended1+DefineMinGW ) != WinGSettings.&("TC_LIBS_"+DefineExtended1+DefineMinGW).value .or. ;
      &( "Gbl_T_H_LIBS_"+DefineExtended1+DefineMinGW ) != WinGSettings.&("T_LIBS_"+DefineExtended1+DefineMinGW+DefineHarbour).value .or. ;
      &( "Gbl_T_X_LIBS_"+DefineExtended1+DefineMinGW ) != WinGSettings.&("T_LIBS_"+DefineExtended1+DefineMinGW+DefineXHarbour).value .or. ;
      &( "Gbl_T_M_LIBS_"+DefineOohg3+DefineBorland ) != WinGSettings.&("T_LIBS_"+DefineOohg3+DefineBorland).value .or. ;
      &( "Gbl_T_C_LIBS_"+DefineOohg3+DefineBorland ) != WinGSettings.&("TC_LIBS_"+DefineOohg3+DefineBorland).value .or. ;
      &( "Gbl_T_H_LIBS_"+DefineOohg3+DefineBorland ) != WinGSettings.&("T_LIBS_"+DefineOohg3+DefineBorland+DefineHarbour).value .or. ;
      &( "Gbl_T_X_LIBS_"+DefineOohg3+DefineBorland ) != WinGSettings.&("T_LIBS_"+DefineOohg3+DefineBorland+DefineXHarbour).value .or. ;
      &( "Gbl_T_M_LIBS_"+DefineOohg3+DefineMinGW ) != WinGSettings.&("T_LIBS_"+DefineOohg3+DefineMinGW).value .or. ;
      &( "Gbl_T_C_LIBS_"+DefineOohg3+DefineMinGW ) != WinGSettings.&("TC_LIBS_"+DefineOohg3+DefineMinGW).value .or. ;
      &( "Gbl_T_H_LIBS_"+DefineOohg3+DefineMinGW ) != WinGSettings.&("T_LIBS_"+DefineOohg3+DefineMinGW+DefineHarbour).value .or. ;
      &( "Gbl_T_X_LIBS_"+DefineOohg3+DefineMinGW ) != WinGSettings.&("T_LIBS_"+DefineOohg3+DefineMinGW+DefineXHarbour).value .or. ;
      &( "Gbl_T_M_LIBS_"+DefineOohg3+DefinePelles ) != WinGSettings.&("T_LIBS_"+DefineOohg3+DefinePelles).value .or. ;
      &( "Gbl_T_C_LIBS_"+DefineOohg3+DefinePelles ) != WinGSettings.&("TC_LIBS_"+DefineOohg3+DefinePelles).value .or. ;
      &( "Gbl_T_H_LIBS_"+DefineOohg3+DefinePelles ) != WinGSettings.&("T_LIBS_"+DefineOohg3+DefinePelles+DefineHarbour).value .or. ;
      &( "Gbl_T_X_LIBS_"+DefineOohg3+DefinePelles ) != WinGSettings.&("T_LIBS_"+DefineOohg3+DefinePelles+DefineXHarbour).value
      Return .T.
   endif
Return .F.

Function GlobalSettingsSave()
   Gbl_TEditor      := WinGSettings.TEditor.value
   Gbl_Text_HMI     := WinGSettings.Text_HMI.value
   Gbl_Text_HMGSIDE := WinGSettings.Text_HMGSIDE.value
   Gbl_Text_Dbf     := WinGSettings.Text_Dbf.value

   &( "Gbl_T_M_"+DefineMiniGui1+DefineBorland ) := WinGSettings.&("T_"+DefineMiniGui1+DefineBorland).value
   &( "Gbl_T_C_"+DefineMiniGui1+DefineBorland ) := WinGSettings.&("TC_"+DefineMiniGui1+DefineBorland).value
   &( "Gbl_T_H_"+DefineMiniGui1+DefineBorland ) := WinGSettings.&("T_"+DefineMiniGui1+DefineBorland+DefineHarbour).value
   &( "Gbl_T_X_"+DefineMiniGui1+DefineBorland ) := WinGSettings.&("T_"+DefineMiniGui1+DefineBorland+DefineXHarbour).value
   &( "Gbl_T_M_"+DefineMiniGui3+DefineMinGW ) := WinGSettings.&("T_"+DefineMiniGui3+DefineMinGW).value
   &( "Gbl_T_C_"+DefineMiniGui3+DefineMinGW ) := WinGSettings.&("TC_"+DefineMiniGui3+DefineMinGW).value
   &( "Gbl_T_H_"+DefineMiniGui3+DefineMinGW ) := WinGSettings.&("T_"+DefineMiniGui3+DefineMinGW+DefineHarbour).value
   &( "Gbl_T_X_"+DefineMiniGui3+DefineMinGW ) := WinGSettings.&("T_"+DefineMiniGui3+DefineMinGW+DefineXHarbour).value
   &( "Gbl_T_M_"+DefineExtended1+DefineBorland ) := WinGSettings.&("T_"+DefineExtended1+DefineBorland).value
   &( "Gbl_T_C_"+DefineExtended1+DefineBorland ) := WinGSettings.&("TC_"+DefineExtended1+DefineBorland).value
   &( "Gbl_T_H_"+DefineExtended1+DefineBorland ) := WinGSettings.&("T_"+DefineExtended1+DefineBorland+DefineHarbour).value
   &( "Gbl_T_X_"+DefineExtended1+DefineBorland ) := WinGSettings.&("T_"+DefineExtended1+DefineBorland+DefineXHarbour).value
   &( "Gbl_T_M_"+DefineExtended1+DefineMinGW ) := WinGSettings.&("T_"+DefineExtended1+DefineMinGW).value
   &( "Gbl_T_C_"+DefineExtended1+DefineMinGW ) := WinGSettings.&("TC_"+DefineExtended1+DefineMinGW).value
   &( "Gbl_T_H_"+DefineExtended1+DefineMinGW ) := WinGSettings.&("T_"+DefineExtended1+DefineMinGW+DefineHarbour).value
   &( "Gbl_T_X_"+DefineExtended1+DefineMinGW ) := WinGSettings.&("T_"+DefineExtended1+DefineMinGW+DefineXHarbour).value
   &( "Gbl_T_M_"+DefineOohg3+DefineBorland ) := WinGSettings.&("T_"+DefineOohg3+DefineBorland).value
   &( "Gbl_T_C_"+DefineOohg3+DefineBorland ) := WinGSettings.&("TC_"+DefineOohg3+DefineBorland).value
   &( "Gbl_T_H_"+DefineOohg3+DefineBorland ) := WinGSettings.&("T_"+DefineOohg3+DefineBorland+DefineHarbour).value
   &( "Gbl_T_X_"+DefineOohg3+DefineBorland ) := WinGSettings.&("T_"+DefineOohg3+DefineBorland+DefineXHarbour).value
   &( "Gbl_T_M_"+DefineOohg3+DefineMinGW ) := WinGSettings.&("T_"+DefineOohg3+DefineMinGW).value
   &( "Gbl_T_C_"+DefineOohg3+DefineMinGW ) := WinGSettings.&("TC_"+DefineOohg3+DefineMinGW).value
   &( "Gbl_T_H_"+DefineOohg3+DefineMinGW ) := WinGSettings.&("T_"+DefineOohg3+DefineMinGW+DefineHarbour).value
   &( "Gbl_T_X_"+DefineOohg3+DefineMinGW ) := WinGSettings.&("T_"+DefineOohg3+DefineMinGW+DefineXHarbour).value
   &( "Gbl_T_M_"+DefineOohg3+DefinePelles ) := WinGSettings.&("T_"+DefineOohg3+DefinePelles).value
   &( "Gbl_T_C_"+DefineOohg3+DefinePelles ) := WinGSettings.&("TC_"+DefineOohg3+DefinePelles).value
   &( "Gbl_T_H_"+DefineOohg3+DefinePelles ) := WinGSettings.&("T_"+DefineOohg3+DefinePelles+DefineHarbour).value
   &( "Gbl_T_X_"+DefineOohg3+DefinePelles ) := WinGSettings.&("T_"+DefineOohg3+DefinePelles+DefineXHarbour).value

   &( "Gbl_T_M_LIBS_"+DefineMiniGui1+DefineBorland ) := WinGSettings.&("T_LIBS_"+DefineMiniGui1+DefineBorland).value
   &( "Gbl_T_C_LIBS_"+DefineMiniGui1+DefineBorland ) := WinGSettings.&("TC_LIBS_"+DefineMiniGui1+DefineBorland).value
   &( "Gbl_T_H_LIBS_"+DefineMiniGui1+DefineBorland ) := WinGSettings.&("T_LIBS_"+DefineMiniGui1+DefineBorland+DefineHarbour).value
   &( "Gbl_T_X_LIBS_"+DefineMiniGui1+DefineBorland ) := WinGSettings.&("T_LIBS_"+DefineMiniGui1+DefineBorland+DefineXHarbour).value
   &( "Gbl_T_M_LIBS_"+DefineMiniGui3+DefineMinGW ) := WinGSettings.&("T_LIBS_"+DefineMiniGui3+DefineMinGW).value
   &( "Gbl_T_C_LIBS_"+DefineMiniGui3+DefineMinGW ) := WinGSettings.&("TC_LIBS_"+DefineMiniGui3+DefineMinGW).value
   &( "Gbl_T_H_LIBS_"+DefineMiniGui3+DefineMinGW ) := WinGSettings.&("T_LIBS_"+DefineMiniGui3+DefineMinGW+DefineHarbour).value
   &( "Gbl_T_X_LIBS_"+DefineMiniGui3+DefineMinGW ) := WinGSettings.&("T_LIBS_"+DefineMiniGui3+DefineMinGW+DefineXHarbour).value
   &( "Gbl_T_M_LIBS_"+DefineExtended1+DefineBorland ) := WinGSettings.&("T_LIBS_"+DefineExtended1+DefineBorland).value
   &( "Gbl_T_C_LIBS_"+DefineExtended1+DefineBorland ) := WinGSettings.&("TC_LIBS_"+DefineExtended1+DefineBorland).value
   &( "Gbl_T_H_LIBS_"+DefineExtended1+DefineBorland ) := WinGSettings.&("T_LIBS_"+DefineExtended1+DefineBorland+DefineHarbour).value
   &( "Gbl_T_X_LIBS_"+DefineExtended1+DefineBorland ) := WinGSettings.&("T_LIBS_"+DefineExtended1+DefineBorland+DefineXHarbour).value
   &( "Gbl_T_M_LIBS_"+DefineExtended1+DefineMinGW ) := WinGSettings.&("T_LIBS_"+DefineExtended1+DefineMinGW).value
   &( "Gbl_T_C_LIBS_"+DefineExtended1+DefineMinGW ) := WinGSettings.&("TC_LIBS_"+DefineExtended1+DefineMinGW).value
   &( "Gbl_T_H_LIBS_"+DefineExtended1+DefineMinGW ) := WinGSettings.&("T_LIBS_"+DefineExtended1+DefineMinGW+DefineHarbour).value
   &( "Gbl_T_X_LIBS_"+DefineExtended1+DefineMinGW ) := WinGSettings.&("T_LIBS_"+DefineExtended1+DefineMinGW+DefineXHarbour).value
   &( "Gbl_T_M_LIBS_"+DefineOohg3+DefineBorland ) := WinGSettings.&("T_LIBS_"+DefineOohg3+DefineBorland).value
   &( "Gbl_T_C_LIBS_"+DefineOohg3+DefineBorland ) := WinGSettings.&("TC_LIBS_"+DefineOohg3+DefineBorland).value
   &( "Gbl_T_H_LIBS_"+DefineOohg3+DefineBorland ) := WinGSettings.&("T_LIBS_"+DefineOohg3+DefineBorland+DefineHarbour).value
   &( "Gbl_T_X_LIBS_"+DefineOohg3+DefineBorland ) := WinGSettings.&("T_LIBS_"+DefineOohg3+DefineBorland+DefineXHarbour).value
   &( "Gbl_T_M_LIBS_"+DefineOohg3+DefineMinGW ) := WinGSettings.&("T_LIBS_"+DefineOohg3+DefineMinGW).value
   &( "Gbl_T_C_LIBS_"+DefineOohg3+DefineMinGW ) := WinGSettings.&("TC_LIBS_"+DefineOohg3+DefineMinGW).value
   &( "Gbl_T_H_LIBS_"+DefineOohg3+DefineMinGW ) := WinGSettings.&("T_LIBS_"+DefineOohg3+DefineMinGW+DefineHarbour).value
   &( "Gbl_T_X_LIBS_"+DefineOohg3+DefineMinGW ) := WinGSettings.&("T_LIBS_"+DefineOohg3+DefineMinGW+DefineXHarbour).value
   &( "Gbl_T_M_LIBS_"+DefineOohg3+DefinePelles ) := WinGSettings.&("T_LIBS_"+DefineOohg3+DefinePelles).value
   &( "Gbl_T_C_LIBS_"+DefineOohg3+DefinePelles ) := WinGSettings.&("TC_LIBS_"+DefineOohg3+DefinePelles).value
   &( "Gbl_T_H_LIBS_"+DefineOohg3+DefinePelles ) := WinGSettings.&("T_LIBS_"+DefineOohg3+DefinePelles+DefineHarbour).value
   &( "Gbl_T_X_LIBS_"+DefineOohg3+DefinePelles ) := WinGSettings.&("T_LIBS_"+DefineOohg3+DefinePelles+DefineXHarbour).value
Return .T.

/* eof */
