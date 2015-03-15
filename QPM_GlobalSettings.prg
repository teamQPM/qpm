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

Function GlobalSettings()

   DEFINE WINDOW WinGSettings ;
          AT 0 , 0 ;
          WIDTH 750 ;
          HEIGHT 320 ;
          TITLE PUB_MenuGblOptions ;
          MODAL ;
          NOSYSMENU ;
          ON INTERACTIVECLOSE US_NOP() ;
          ON INIT SelectTab()

      DEFINE TAB TabGSettings ;
             OF WinGSettings ;
             AT 0 , 0 ;
             WIDTH 742 ;
             HEIGHT 240

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
                    TOOLTIP         'Select Editor'
                    ONCLICK         If ( !Empty( FileName := BugGetFile( { {'Application','*.exe'} } , 'Select Program Editor' , US_FileNameOnlyPath( WinGSettings.TEditor.Value ) , .F. , .T. ) ) , WinGSettings.TEditor.Value := FileName , )
            END BUTTON

            DEFINE CHECKBOX Check_EditorLongName
                    CAPTION         "Use Long Name"
                    ROW             87
                    COL             15
                    WIDTH           150
                    HEIGHT          20
                    VALUE           bEditorLongName
                    TOOLTIP "Use Long Name for Open Source Editor.  Default is Short Name (8.3)"
                    ON CHANGE       bEditorLongName := WinGSettings.Check_EditorLongName.Value
            END CHECKBOX

            DEFINE CHECKBOX Check_EditorSuspendControl
                    CAPTION         "Suspend Control Edit"
                    ROW             108
                    COL             15
                    WIDTH           150
                    HEIGHT          20
                    VALUE           bSuspendControlEdit
                    TOOLTIP "Suspend control for edit process"
                    ON CHANGE       bSuspendControlEdit := WinGSettings.Check_EditorSuspendControl.Value
            END CHECKBOX

            @ 132 , 10 LABEL LDummy_Form ;
               VALUE 'Forms Tools Location:' ;
               WIDTH 275 ;
               FONT 'arial' SIZE 10 BOLD ;
               TRANSPARENT ;
               FONTCOLOR DEF_COLORBLUE

            DEFINE LABEL Label_HMI
                    VALUE           ' ooHG IDE+ (By Ciro Vargas):'
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
                    TOOLTIP         'Select Form Tool'
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
                    TOOLTIP         'Select Form Tool'
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
                    VALUE           'Select Dbf Tool:'
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
                    TOOLTIP         'Select Dbf Tool'
                    ONCLICK         If ( !Empty( FileName := BugGetFile( { {'Application','*.exe'} } , 'Select Dbf Tool' , US_FileNameOnlyPath( WinGSettings.Text_Dbf.Value ) , .F. , .T. ) ) , WinGSettings.Text_Dbf.Value := FileName , )
            END BUTTON

            DEFINE CHECKBOX Check_DBF_NoComillas
                    CAPTION         "Do Not Use Quotes in dbfname"
                    ROW             160
                    COL             10
                    WIDTH           250
                    HEIGHT          20
                    VALUE           if( Gbl_Comillas_DBF == '"' , .F. , .T. )
                    TOOLTIP "Do Not Use Quotes when DBF Tool call the DBF"
                    ON CHANGE       Gbl_Comillas_DBF := if( WinGSettings.Check_DBF_NoComillas.Value , '' , '"' )
            END CHECKBOX

         END PAGE

  //     DEFINE TAB &("Tab_"+DefineMiniGui1) ;
  //            OF WinGSettings ;
  //            AT 0 , 0 ;
  //            WIDTH 742 ;
  //            HEIGHT 240

            //-- Oficial Minigui 1.x ----------------------------------------------------//
            DEFINE PAGE "Oficial 1.x with Borland C"

               @ 43 , 10 LABEL &("LDummy_"+DefineMiniGui1+DefineBorland) ;
                  VALUE 'Folders for Oficial MiniGUI 1.x with Borland C:' ;
                  WIDTH 601 ;
                  FONT 'arial' SIZE 10 BOLD ;
                  TRANSPARENT ;
                  FONTCOLOR DEF_COLORBLUE

               DEFINE LABEL &("L_"+DefineMiniGui1+DefineBorland)
                       ROW             70
                       COL             10
                       WIDTH           109
                       VALUE           'MiniGUI Folder:'
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
                       TOOLTIP         'Select Folder'
                       ONCLICK         If ( !Empty( Folder := GetFolder( "Select Folder" , WinGSettings.&("T_"+DefineMiniGui1+DefineBorland).Value ) ) , WinGSettings.&("T_"+DefineMiniGui1+DefineBorland).Value := Folder , )
               END BUTTON

               DEFINE LABEL &("LC_"+DefineMiniGui1+DefineBorland)
                       ROW             100
                       COL             10
                       WIDTH           109
                       VALUE           'Borland C Folder:'
                       TRANSPARENT     .T.
               END LABEL
               DEFINE TEXTBOX &("TC_"+DefineMiniGui1+DefineBorland)
                       VALUE           &( "Gbl_T_C_"+DefineMiniGui1+DefineBorland )
                       ROW             100
                       COL             120
                       WIDTH           561
               END TEXTBOX
               DEFINE BUTTON &("BC_"+DefineMiniGui1+DefineBorland)
                       ROW             100
                       COL             691
                       WIDTH           25
                       HEIGHT          25
                       PICTURE         'folderselect'
                       TOOLTIP         'Select Folder'
                       ONCLICK         If ( !Empty( Folder := GetFolder( "Select Folder" , WinGSettings.&("TC_"+DefineMiniGui1+DefineBorland).Value ) ) , WinGSettings.&("TC_"+DefineMiniGui1+DefineBorland).Value := Folder , )
               END BUTTON

               DEFINE LABEL &("L_"+DefineMiniGui1+DefineBorland+DefineHarbour)
                       ROW             130
                       COL             10
                       WIDTH           109
                       VALUE           'Harbour Folder:'
                       TRANSPARENT     .T.
               END LABEL
               DEFINE TEXTBOX &("T_"+DefineMiniGui1+DefineBorland+DefineHarbour)
                       VALUE           &( "Gbl_T_H_"+DefineMiniGui1+DefineBorland )
                       ROW             130
                       COL             120
                       WIDTH           561
               END TEXTBOX
               DEFINE BUTTON &("B_"+DefineMiniGui1+DefineBorland+DefineHarbour)
                       ROW             130
                       COL             691
                       WIDTH           25
                       HEIGHT          25
                       PICTURE         'folderselect'
                       TOOLTIP         'Select Folder'
                       ONCLICK         If ( !Empty( Folder := GetFolder( "Select Folder" , WinGSettings.&("T_"+DefineMiniGui1+DefineBorland+DefineHarbour).Value ) ) , WinGSettings.&("T_"+DefineMiniGui1+DefineBorland+DefineHarbour).Value := Folder , )
               END BUTTON

               DEFINE LABEL &("L_"+DefineMiniGui1+DefineBorland+DefineXHarbour)
                       ROW             160
                       COL             10
                       WIDTH           109
                       VALUE           'xHarbour Folder:'
                       TRANSPARENT     .T.
               END LABEL
               DEFINE TEXTBOX &("T_"+DefineMiniGui1+DefineBorland+DefineXHarbour)
                       VALUE           &( "Gbl_T_X_"+DefineMiniGui1+DefineBorland )
                       ROW             160
                       COL             120
                       WIDTH           561
               END TEXTBOX
               DEFINE BUTTON &("B_"+DefineMiniGui1+DefineBorland+DefineXHarbour)
                       ROW             160
                       COL             691
                       WIDTH           25
                       HEIGHT          25
                       PICTURE         'folderselect'
                       TOOLTIP         'Select Folder'
                       ONCLICK         If ( !Empty( Folder := GetFolder( "Select Folder" , WinGSettings.&("T_"+DefineMiniGui1+DefineBorland+DefineXHarbour).Value ) ) , WinGSettings.&("T_"+DefineMiniGui1+DefineBorland+DefineXHarbour).Value := Folder , )
               END BUTTON

            END PAGE

   //    END TAB

         //-- Oficial Minigui 3.x ----------------------------------------------------//
         DEFINE PAGE "Oficial 3.x with MinGW"


            @ 43 , 10 LABEL &("LDummy_"+DefineMiniGui3+DefineMinGW) ;
               VALUE 'Folders for Oficial MiniGUI 3.x with MinGW:' ;
               WIDTH 601 ;
               FONT 'arial' SIZE 10 BOLD ;
               TRANSPARENT ;
               FONTCOLOR DEF_COLORBLUE

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
                    TOOLTIP         'Select Folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select Folder" , WinGSettings.&("T_"+DefineMiniGui3+DefineMinGW).Value ) ) , WinGSettings.&("T_"+DefineMiniGui3+DefineMinGW).Value := Folder , )
            END BUTTON

            DEFINE LABEL &("LC_"+DefineMiniGui3+DefineMinGW)
                    ROW             100
                    COL             10
                    WIDTH           109
                    VALUE           'MinGW C Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("TC_"+DefineMiniGui3+DefineMinGW)
                    VALUE           &( "Gbl_T_C_"+DefineMiniGui3+DefineMinGW )
                    ROW             100
                    COL             120
                    WIDTH           561
            END TEXTBOX
            DEFINE BUTTON &("BC_"+DefineMiniGui3+DefineMinGW)
                    ROW             100
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select Folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select Folder" , WinGSettings.&("TC_"+DefineMiniGui3+DefineMinGW).Value ) ) , WinGSettings.&("TC_"+DefineMiniGui3+DefineMinGW).Value := Folder , )
            END BUTTON

            DEFINE LABEL &("L_"+DefineMiniGui3+DefineMinGW+DefineHarbour)
                    ROW             130
                    COL             10
                    WIDTH           109
                    VALUE           'Harbour Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("T_"+DefineMiniGui3+DefineMinGW+DefineHarbour)
                    VALUE           &( "Gbl_T_H_"+DefineMiniGui3+DefineMinGW )
                    ROW             130
                    COL             120
                    WIDTH           561
            END TEXTBOX
            DEFINE BUTTON &("B_"+DefineMiniGui3+DefineMinGW+DefineHarbour)
                    ROW             130
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select Folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select Folder" , WinGSettings.&("T_"+DefineMiniGui3+DefineMinGW+DefineHarbour).Value ) ) , WinGSettings.&("T_"+DefineMiniGui3+DefineMinGW+DefineHarbour).Value := Folder , )
            END BUTTON

            DEFINE LABEL &("L_"+DefineMiniGui3+DefineMinGW+DefineXHarbour)
                    ROW             160
                    COL             10
                    WIDTH           109
                    VALUE           'xHarbour Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("T_"+DefineMiniGui3+DefineMinGW+DefineXHarbour)
                    VALUE           &( "Gbl_T_X_"+DefineMiniGui3+DefineMinGW )
                    ROW             160
                    COL             120
                    WIDTH           561
            END TEXTBOX
            DEFINE BUTTON &("B_"+DefineMiniGui3+DefineMinGW+DefineXHarbour)
                    ROW             160
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select Folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select Folder" , WinGSettings.&("T_"+DefineMiniGui3+DefineMinGW+DefineXHarbour).Value ) ) , WinGSettings.&("T_"+DefineMiniGui3+DefineMinGW+DefineXHarbour).Value := Folder , )
            END BUTTON

         END PAGE

         //-- Extended Minigui 1.x ----------------------------------------------------//
         DEFINE PAGE "Extended 1.x with Borland C"

            @ 43 , 10 LABEL &("LDummy_"+DefineExtended1+DefineBorland) ;
               VALUE 'Folders for Extended MiniGUI 1.x with Borland C:' ;
               WIDTH 601 ;
               FONT 'arial' SIZE 10 BOLD ;
               TRANSPARENT ;
               FONTCOLOR DEF_COLORBLUE

            DEFINE LABEL &("L_"+DefineExtended1+DefineBorland)
                    ROW             70
                    COL             10
                    WIDTH           109
                    VALUE           'MiniGUI Folder:'
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
                    TOOLTIP         'Select Folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select Folder" , WinGSettings.&("T_"+DefineExtended1+DefineBorland).Value ) ) , WinGSettings.&("T_"+DefineExtended1+DefineBorland).Value := Folder , )
            END BUTTON

            DEFINE LABEL &("LC_"+DefineExtended1+DefineBorland)
                    ROW             100
                    COL             10
                    WIDTH           109
                    VALUE           'Borland C Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("TC_"+DefineExtended1+DefineBorland)
                    VALUE           &( "Gbl_T_C_"+DefineExtended1+DefineBorland )
                    ROW             100
                    COL             120
                    WIDTH           561
            END TEXTBOX
            DEFINE BUTTON &("BC_"+DefineExtended1+DefineBorland)
                    ROW             100
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select Folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select Folder" , WinGSettings.&("TC_"+DefineExtended1+DefineBorland).Value ) ) , WinGSettings.&("TC_"+DefineExtended1+DefineBorland).Value := Folder , )
            END BUTTON

            DEFINE LABEL &("L_"+DefineExtended1+DefineBorland+DefineHarbour)
                    ROW             130
                    COL             10
                    WIDTH           109
                    VALUE           'Harbour Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("T_"+DefineExtended1+DefineBorland+DefineHarbour)
                    VALUE           &( "Gbl_T_H_"+DefineExtended1+DefineBorland )
                    ROW             130
                    COL             120
                    WIDTH           561
            END TEXTBOX
            DEFINE BUTTON &("B_"+DefineExtended1+DefineBorland+DefineHarbour)
                    ROW             130
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select Folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select Folder" , WinGSettings.&("T_"+DefineExtended1+DefineBorland+DefineHarbour).Value ) ) , WinGSettings.&("T_"+DefineExtended1+DefineBorland+DefineHarbour).Value := Folder , )
            END BUTTON

            DEFINE LABEL &("L_"+DefineExtended1+DefineBorland+DefineXHarbour)
                    ROW             160
                    COL             10
                    WIDTH           109
                    VALUE           'xHarbour Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("T_"+DefineExtended1+DefineBorland+DefineXHarbour)
                    VALUE           &( "Gbl_T_X_"+DefineExtended1+DefineBorland )
                    ROW             160
                    COL             120
                    WIDTH           561
            END TEXTBOX
            DEFINE BUTTON &("B_"+DefineExtended1+DefineBorland+DefineXHarbour)
                    ROW             160
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select Folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select Folder" , WinGSettings.&("T_"+DefineExtended1+DefineBorland+DefineXHarbour).Value ) ) , WinGSettings.&("T_"+DefineExtended1+DefineBorland+DefineXHarbour).Value := Folder , )
            END BUTTON

         END PAGE

         // NOTE: added support for MinGW and Extended
         //-- Extended Minigui 1.x ----------------------------------------------------//
         DEFINE PAGE "Extended 1.x with MinGW"

            @ 43 , 10 LABEL &("LDummy_"+DefineExtended1+DefineMinGW) ;
               VALUE 'Folders for Extended MiniGUI 1.x with MinGW:' ;
               WIDTH 601 ;
               FONT 'arial' SIZE 10 BOLD ;
               TRANSPARENT ;
               FONTCOLOR DEF_COLORBLUE

            DEFINE LABEL &("L_"+DefineExtended1+DefineMinGW)
                    ROW             70
                    COL             10
                    WIDTH           109
                    VALUE           'MiniGUI Folder:'
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
                    TOOLTIP         'Select Folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select Folder" , WinGSettings.&("T_"+DefineExtended1+DefineMinGW).Value ) ) , WinGSettings.&("T_"+DefineExtended1+DefineMinGW).Value := Folder , )
            END BUTTON

            DEFINE LABEL &("LC_"+DefineExtended1+DefineMinGW)
                    ROW             100
                    COL             10
                    WIDTH           109
                    VALUE           'MinGW Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("TC_"+DefineExtended1+DefineMinGW)
                    VALUE           &( "Gbl_T_C_"+DefineExtended1+DefineMinGW )
                    ROW             100
                    COL             120
                    WIDTH           561
            END TEXTBOX
            DEFINE BUTTON &("BC_"+DefineExtended1+DefineMinGW)
                    ROW             100
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select Folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select Folder" , WinGSettings.&("TC_"+DefineExtended1+DefineMinGW).Value ) ) , WinGSettings.&("TC_"+DefineExtended1+DefineMinGW).Value := Folder , )
            END BUTTON

            DEFINE LABEL &("L_"+DefineExtended1+DefineMinGW+DefineHarbour)
                    ROW             130
                    COL             10
                    WIDTH           109
                    VALUE           'Harbour Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("T_"+DefineExtended1+DefineMinGW+DefineHarbour)
                    VALUE           &( "Gbl_T_H_"+DefineExtended1+DefineMinGW )
                    ROW             130
                    COL             120
                    WIDTH           561
            END TEXTBOX
            DEFINE BUTTON &("B_"+DefineExtended1+DefineMinGW+DefineHarbour)
                    ROW             130
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select Folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select Folder" , WinGSettings.&("T_"+DefineExtended1+DefineMinGW+DefineHarbour).Value ) ) , WinGSettings.&("T_"+DefineExtended1+DefineMinGW+DefineHarbour).Value := Folder , )
            END BUTTON

            DEFINE LABEL &("L_"+DefineExtended1+DefineMinGW+DefineXHarbour)
                    ROW             160
                    COL             10
                    WIDTH           109
                    VALUE           'xHarbour Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("T_"+DefineExtended1+DefineMinGW+DefineXHarbour)
                    VALUE           &( "Gbl_T_X_"+DefineExtended1+DefineMinGW )
                    ROW             160
                    COL             120
                    WIDTH           561
            END TEXTBOX
            DEFINE BUTTON &("B_"+DefineExtended1+DefineMinGW+DefineXHarbour)
                    ROW             160
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select Folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select Folder" , WinGSettings.&("T_"+DefineExtended1+DefineMinGW+DefineXHarbour).Value ) ) , WinGSettings.&("T_"+DefineExtended1+DefineMinGW+DefineXHarbour).Value := Folder , )
            END BUTTON

         END PAGE

         //-- Object Oriented Harbour GUI with Borland ---------------------------------------//
         DEFINE PAGE "OOHG with Borland C"

            @ 43 , 10 LABEL &("LDummy_"+DefineOohg3+DefineBorland) ;
               VALUE 'Folders for Object Oriented Harbour GUI with Borland C:' ;
               WIDTH 601 ;
               FONT 'arial' SIZE 10 BOLD ;
               TRANSPARENT ;
               FONTCOLOR DEF_COLORBLUE

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
                    TOOLTIP         'Select Folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select Folder" , WinGSettings.&("T_"+DefineOohg3+DefineBorland).Value ) ) , WinGSettings.&("T_"+DefineOohg3+DefineBorland).Value := Folder , )
            END BUTTON

            DEFINE LABEL &("LC_"+DefineOohg3+DefineBorland)
                    ROW             100
                    COL             10
                    WIDTH           109
                    VALUE           'Borland C Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("TC_"+DefineOohg3+DefineBorland)
                    VALUE           &( "Gbl_T_C_"+DefineOohg3+DefineBorland )
                    ROW             100
                    COL             120
                    WIDTH           561
            END TEXTBOX
            DEFINE BUTTON &("BC_"+DefineOohg3+DefineBorland)
                    ROW             100
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select Folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select Folder" , WinGSettings.&("TC_"+DefineOohg3+DefineBorland).Value ) ) , WinGSettings.&("TC_"+DefineOohg3+DefineBorland).Value := Folder , )
            END BUTTON

            DEFINE LABEL &("L_"+DefineOohg3+DefineBorland+DefineHarbour)
                    ROW             130
                    COL             10
                    WIDTH           109
                    VALUE           'Harbour Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("T_"+DefineOohg3+DefineBorland+DefineHarbour)
                    VALUE           &( "Gbl_T_H_"+DefineOohg3+DefineBorland )
                    ROW             130
                    COL             120
                    WIDTH           561
            END TEXTBOX
            DEFINE BUTTON &("B_"+DefineOohg3+DefineBorland+DefineHarbour)
                    ROW             130
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select Folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select Folder" , WinGSettings.&("T_"+DefineOohg3+DefineBorland+DefineHarbour).Value ) ) , WinGSettings.&("T_"+DefineOohg3+DefineBorland+DefineHarbour).Value := Folder , )
            END BUTTON

            DEFINE LABEL &("L_"+DefineOohg3+DefineBorland+DefineXHarbour)
                    ROW             160
                    COL             10
                    WIDTH           109
                    VALUE           'xHarbour Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("T_"+DefineOohg3+DefineBorland+DefineXHarbour)
                    VALUE           &( "Gbl_T_X_"+DefineOohg3+DefineBorland )
                    ROW             160
                    COL             120
                    WIDTH           561
            END TEXTBOX
            DEFINE BUTTON &("B_"+DefineOohg3+DefineBorland+DefineXHarbour)
                    ROW             160
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select Folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select Folder" , WinGSettings.&("T_"+DefineOohg3+DefineBorland+DefineXHarbour).Value ) ) , WinGSettings.&("T_"+DefineOohg3+DefineBorland+DefineXHarbour).Value := Folder , )
            END BUTTON

         END PAGE

         //-- Object Oriented Harbour GUI with MinGW -----------------------------------------//
         DEFINE PAGE "OOHG with MinGW"

            @ 43 , 10 LABEL &("LDummy_"+DefineOohg3+DefineMinGW) ;
               VALUE 'Folders for Object Oriented Harbour GUI and MinGW:' ;
               WIDTH 601 ;
               FONT 'arial' SIZE 10 BOLD ;
               TRANSPARENT ;
               FONTCOLOR DEF_COLORBLUE

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
                    TOOLTIP         'Select Folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select Folder" , WinGSettings.&("T_"+DefineOohg3+DefineMinGW).Value ) ) , WinGSettings.&("T_"+DefineOohg3+DefineMinGW).Value := Folder , )
            END BUTTON

            DEFINE LABEL &("LC_"+DefineOohg3+DefineMinGW)
                    ROW             100
                    COL             10
                    WIDTH           109
                    VALUE           'MinGW Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("TC_"+DefineOohg3+DefineMinGW)
                    VALUE           &( "Gbl_T_C_"+DefineOohg3+DefineMinGW )
                    ROW             100
                    COL             120
                    WIDTH           561
            END TEXTBOX
            DEFINE BUTTON &("BC_"+DefineOohg3+DefineMinGW)
                    ROW             100
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select Folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select Folder" , WinGSettings.&("TC_"+DefineOohg3+DefineMinGW).Value ) ) , WinGSettings.&("TC_"+DefineOohg3+DefineMinGW).Value := Folder , )
            END BUTTON

            DEFINE LABEL &("L_"+DefineOohg3+DefineMinGW+DefineHarbour)
                    ROW             130
                    COL             10
                    WIDTH           109
                    VALUE           'Harbour Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("T_"+DefineOohg3+DefineMinGW+DefineHarbour)
                    VALUE           &( "Gbl_T_H_"+DefineOohg3+DefineMinGW )
                    ROW             130
                    COL             120
                    WIDTH           561
            END TEXTBOX
            DEFINE BUTTON &("B_"+DefineOohg3+DefineMinGW+DefineHarbour)
                    ROW             130
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select Folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select Folder" , WinGSettings.&("T_"+DefineOohg3+DefineMinGW+DefineHarbour).Value ) ) , WinGSettings.&("T_"+DefineOohg3+DefineMinGW+DefineHarbour).Value := Folder , )
            END BUTTON

            DEFINE LABEL &("L_"+DefineOohg3+DefineMinGW+DefineXHarbour)
                    ROW             160
                    COL             10
                    WIDTH           109
                    VALUE           'xHarbour Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("T_"+DefineOohg3+DefineMinGW+DefineXHarbour)
                    VALUE           &( "Gbl_T_X_"+DefineOohg3+DefineMinGW )
                    ROW             160
                    COL             120
                    WIDTH           561
            END TEXTBOX
            DEFINE BUTTON &("B_"+DefineOohg3+DefineMinGW+DefineXHarbour)
                    ROW             160
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select Folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select Folder" , WinGSettings.&("T_"+DefineOohg3+DefineMinGW+DefineXHarbour).Value ) ) , WinGSettings.&("T_"+DefineOohg3+DefineMinGW+DefineXHarbour).Value := Folder , )
            END BUTTON

         END PAGE

         //-- Object Oriented Harbour GUI with Pelles C --------------------------------------//
         DEFINE PAGE "OOHG with Pelles C"

            @ 43 , 10 LABEL &("LDummy_"+DefineOohg3+DefinePelles) ;
               VALUE 'Folders for Object Oriented Harbour GUI with Pelles C:' ;
               WIDTH 601 ;
               FONT 'arial' SIZE 10 BOLD ;
               TRANSPARENT ;
               FONTCOLOR DEF_COLORBLUE

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
                    TOOLTIP         'Select Folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select Folder" , WinGSettings.&("T_"+DefineOohg3+DefinePelles).Value ) ) , WinGSettings.&("T_"+DefineOohg3+DefinePelles).Value := Folder , )
            END BUTTON

            DEFINE LABEL &("LC_"+DefineOohg3+DefinePelles)
                    ROW             100
                    COL             10
                    WIDTH           109
                    VALUE           'Pelles C Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("TC_"+DefineOohg3+DefinePelles)
                    VALUE           &( "Gbl_T_C_"+DefineOohg3+DefinePelles )
                    ROW             100
                    COL             120
                    WIDTH           561
            END TEXTBOX
            DEFINE BUTTON &("BC_"+DefineOohg3+DefinePelles)
                    ROW             100
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select Folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select Folder" , WinGSettings.&("TC_"+DefineOohg3+DefinePelles).Value ) ) , WinGSettings.&("TC_"+DefineOohg3+DefinePelles).Value := Folder , )
            END BUTTON

            DEFINE LABEL &("L_"+DefineOohg3+DefinePelles+DefineHarbour)
                    ROW             130
                    COL             10
                    WIDTH           109
                    VALUE           'Harbour Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("T_"+DefineOohg3+DefinePelles+DefineHarbour)
                    VALUE           &( "Gbl_T_H_"+DefineOohg3+DefinePelles )
                    ROW             130
                    COL             120
                    WIDTH           561
            END TEXTBOX
            DEFINE BUTTON &("B_"+DefineOohg3+DefinePelles+DefineHarbour)
                    ROW             130
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select Folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select Folder" , WinGSettings.&("T_"+DefineOohg3+DefinePelles+DefineHarbour).Value ) ) , WinGSettings.&("T_"+DefineOohg3+DefinePelles+DefineHarbour).Value := Folder , )
            END BUTTON

            DEFINE LABEL &("L_"+DefineOohg3+DefinePelles+DefineXHarbour)
                    ROW             160
                    COL             10
                    WIDTH           109
                    VALUE           'xHarbour Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("T_"+DefineOohg3+DefinePelles+DefineXHarbour)
                    VALUE           &( "Gbl_T_X_"+DefineOohg3+DefinePelles )
                    ROW             160
                    COL             120
                    WIDTH           561
            END TEXTBOX
            DEFINE BUTTON &("B_"+DefineOohg3+DefinePelles+DefineXHarbour)
                    ROW             160
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select Folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select Folder" , WinGSettings.&("T_"+DefineOohg3+DefinePelles+DefineXHarbour).Value ) ) , WinGSettings.&("T_"+DefineOohg3+DefinePelles+DefineXHarbour).Value := Folder , )
            END BUTTON

         END PAGE

      END TAB

      DEFINE BUTTON B_OK
             ROW             250
             COL             100
             WIDTH           200
             HEIGHT          25
             CAPTION         'OK'
             TOOLTIP         'Confirm Changes'
             ONCLICK         ( GlobalSettingsSave() , WinGSettings.Release() )
      END BUTTON

      DEFINE BUTTON B_CANCEL
             ROW             250
             COL             635
             WIDTH            80
             HEIGHT          25
             CAPTION         'Cancel'
             TOOLTIP         'Cancel Changes'
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
      &( "Gbl_T_M_"+DefineExtended1+DefineMinGW ) != WinGSettings.&("T_"+DefineExtended1+DefineMinGW).value .or. ; // NOTE: added support for MinGW and Extended
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
      &( "Gbl_T_X_"+DefineOohg3+DefinePelles ) != WinGSettings.&("T_"+DefineOohg3+DefinePelles+DefineXHarbour).value
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
// NOTE: added support for MinGW and Extended
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
Return .T.

/* eof */
