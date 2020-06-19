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

Function GlobalSettings()
   LOCAL Filename, Folder

   DEFINE WINDOW WinGSettings ;
          AT 0, 0 ;
          WIDTH 750 + iif( IsVistaOrLater(), GetBorderWidth() / 2 + 2, 0) ;
          HEIGHT 440 ;
          TITLE PUB_MenuGblOptions ;
          MODAL ;
          NOSYSMENU ;
          ON INTERACTIVECLOSE US_NOP() ;
          ON INIT SelectTab()

      DEFINE TAB TabGSettings ;
             OF WinGSettings ;
             AT 0, 0 ;
             WIDTH 742 ;
             HEIGHT 360

         // PAGE 1
         DEFINE PAGE "Editor and Forms Tools"

            @ 40, 10 LABEL LDummy_Editor ;
               VALUE 'Editor:' ;
               WIDTH 275 ;
               FONT 'arial' SIZE 10 BOLD ;
               TRANSPARENT ;
               FONTCOLOR DEF_COLORBLUE

            DEFINE LABEL LEditor
                    VALUE           'Program Editor for Text Files:'
                    ROW             70
                    COL             10
                    AUTOSIZE        .T.
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX TEditor
                    VALUE           Gbl_Text_Editor
                    ROW             70
                    COL             220
                    WIDTH           461
            END TEXTBOX
            DEFINE BUTTON BEditor
                    ROW             70
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select editor'
                    ONCLICK         If ( !Empty( FileName := BugGetFile( { {'Application','*.exe'} }, 'Select Program Editor', US_FileNameOnlyPath( WinGSettings.TEditor.Value ), .F., .T. ) ), WinGSettings.TEditor.Value := FileName, )
            END BUTTON

            @ 130, 10 LABEL LDummy_Form ;
               VALUE 'Forms Tools:' ;
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

            @ 250, 10 LABEL LDummy_All1 ;
               VALUE 'Global settings:' ;
               WIDTH 275 ;
               FONT 'arial' SIZE 10 BOLD ;
               TRANSPARENT ;
               FONTCOLOR DEF_COLORBLUE

            DEFINE CHECKBOX Check_EditorLongName1
                    CAPTION         "Use Long Filenames"
                    ROW             280
                    COL             15
                    WIDTH           150
                    HEIGHT          20
                    VALUE           bEditorLongName
                    TOOLTIP         "Use long filenames when opening the editors. Default is short filename (8.3 format)"
                    ON CHANGE       { || bEditorLongName := WinGSettings.Check_EditorLongName1.Value, ;
                                         WinGSettings.Check_EditorLongName2.Value := bEditorLongName }
            END CHECKBOX

            DEFINE CHECKBOX Check_EditorSuspendControl1
                    CAPTION         "Suspend Control Edit"
                    ROW             310
                    COL             15
                    WIDTH           150
                    HEIGHT          20
                    VALUE           bSuspendControlEdit
                    TOOLTIP         "Suspend control of the editing process"
                    ON CHANGE       { || bSuspendControlEdit := WinGSettings.Check_EditorSuspendControl1.Value, ;
                                         WinGSettings.Check_EditorSuspendControl2.Value := bSuspendControlEdit }
            END CHECKBOX

         END PAGE

         // PAGE 2
         DEFINE PAGE "DBF Tool"

            @ 40, 10 LABEL LDummy_Dbf ;
               VALUE 'Dbf Tools Location:' ;
               WIDTH 275 ;
               FONT 'arial' SIZE 10 BOLD ;
               TRANSPARENT ;
               FONTCOLOR DEF_COLORBLUE

            DEFINE LABEL Label_Dbf
                    VALUE           'Select DBF Tool:'
                    ROW             70
                    COL             10
                    AUTOSIZE        .T.
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX Text_Dbf
                    VALUE           Gbl_Text_Dbf
                    ROW             70
                    COL             220
                    WIDTH           461
            END TEXTBOX
            DEFINE BUTTON Button_Dbf
                    ROW             70
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select tool'
                    ONCLICK         If ( !Empty( FileName := BugGetFile( { {'Application','*.exe'} }, 'Select Dbf Tool', US_FileNameOnlyPath( WinGSettings.Text_Dbf.Value ), .F., .T. ) ), WinGSettings.Text_Dbf.Value := FileName, )
            END BUTTON

            DEFINE CHECKBOX Check_DBF_NoComillas
                    CAPTION         "Do Not Use Quotes in DBF's Name"
                    ROW             100
                    COL             10
                    WIDTH           250
                    HEIGHT          20
                    VALUE           if( Gbl_Comillas_DBF == '"', .F., .T. )
                    TOOLTIP         "Do not use quotes when opening DBF tool"
                    ON CHANGE       Gbl_Comillas_DBF := if( WinGSettings.Check_DBF_NoComillas.Value, '', '"' )
            END CHECKBOX

            @ 250, 10 LABEL LDummy_All2 ;
               VALUE 'Global settings:' ;
               WIDTH 275 ;
               FONT 'arial' SIZE 10 BOLD ;
               TRANSPARENT ;
               FONTCOLOR DEF_COLORBLUE

            DEFINE CHECKBOX Check_EditorLongName2
                    CAPTION         "Use Long Filenames"
                    ROW             280
                    COL             15
                    WIDTH           150
                    HEIGHT          20
                    VALUE           bEditorLongName
                    TOOLTIP         "Use long filenames when opening the editors. Default is short filename (8.3 format)"
                    ON CHANGE       { || bEditorLongName := WinGSettings.Check_EditorLongName2.Value, ;
                                         WinGSettings.Check_EditorLongName1.Value := bEditorLongName }
            END CHECKBOX

            DEFINE CHECKBOX Check_EditorSuspendControl2
                    CAPTION         "Suspend Control Edit"
                    ROW             310
                    COL             15
                    WIDTH           150
                    HEIGHT          20
                    VALUE           bSuspendControlEdit
                    TOOLTIP         "Suspend control of the editing process"
                    ON CHANGE       { || bSuspendControlEdit := WinGSettings.Check_EditorSuspendControl2.Value, ;
                                         WinGSettings.Check_EditorSuspendControl1.Value := bSuspendControlEdit }
            END CHECKBOX

         END PAGE

         // PAGE 3
         DEFINE PAGE "HMG 1.x + BCC32 + Harbour"

            @ 40, 10 LABEL &("LDummy_"+DefineMiniGui1+DefineBorland+DefineHarbour+Define32bits) ;
               VALUE 'Folders for HMG 1.x + BCC32 + Harbour:' ;
               WIDTH 601 ;
               FONT 'arial' SIZE 10 BOLD ;
               TRANSPARENT ;
               FONTCOLOR DEF_COLORBLUE

// Minigui folder
            DEFINE LABEL &("LM_"+DefineMiniGui1+DefineBorland+DefineHarbour+Define32bits)
                    ROW             70
                    COL             10
                    WIDTH           109
                    VALUE           'HMG Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("TM_"+DefineMiniGui1+DefineBorland+DefineHarbour+Define32bits)
                    VALUE           &("Gbl_T_M_"+DefineMiniGui1+DefineBorland+DefineHarbour+Define32bits)
                    ROW             70
                    COL             120
                    WIDTH           561
            END TEXTBOX
            DEFINE BUTTON &("BM_"+DefineMiniGui1+DefineBorland+DefineHarbour+Define32bits)
                    ROW             70
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder", WinGSettings.&("TM_"+DefineMiniGui1+DefineBorland+DefineHarbour+Define32bits).Value ) ), WinGSettings.&("TM_"+DefineMiniGui1+DefineBorland+DefineHarbour+Define32bits).Value := Folder, )
            END BUTTON
// Minigui Libs folder
            DEFINE LABEL &("LM_LIBS_"+DefineMiniGui1+DefineBorland+DefineHarbour+Define32bits)
                    ROW             100
                    COL             10
                    WIDTH           109
                    VALUE           '    Libs Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("TM_LIBS_"+DefineMiniGui1+DefineBorland+DefineHarbour+Define32bits)
                    VALUE           &("Gbl_T_M_LIBS_"+DefineMiniGui1+DefineBorland+DefineHarbour+Define32bits)
                    ROW             100
                    COL             120
                    WIDTH           561
                    TOOLTIP         "Full path to HMG's libraries (usually subfolder 'lib' of HMG Folder)"
            END TEXTBOX
            DEFINE BUTTON &("BM_LIBS_"+DefineMiniGui1+DefineBorland+DefineHarbour+Define32bits)
                    ROW             100
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder", WinGSettings.&("TM_LIBS_"+DefineMiniGui1+DefineBorland+DefineHarbour+Define32bits).Value ) ), WinGSettings.&("TM_LIBS_"+DefineMiniGui1+DefineBorland+DefineHarbour+Define32bits).Value := Folder, )
            END BUTTON
// Borland Folder
            DEFINE LABEL &("LC_"+DefineMiniGui1+DefineBorland+DefineHarbour+Define32bits)
                    ROW             130
                    COL             10
                    WIDTH           109
                    VALUE           'BCC32 Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("TC_"+DefineMiniGui1+DefineBorland+DefineHarbour+Define32bits)
                    VALUE           &("Gbl_T_C_"+DefineMiniGui1+DefineBorland+DefineHarbour+Define32bits)
                    ROW             130
                    COL             120
                    WIDTH           561
            END TEXTBOX
            DEFINE BUTTON &("BC_"+DefineMiniGui1+DefineBorland+DefineHarbour+Define32bits)
                    ROW             130
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder", WinGSettings.&("TC_"+DefineMiniGui1+DefineBorland+DefineHarbour+Define32bits).Value ) ), WinGSettings.&("TC_"+DefineMiniGui1+DefineBorland+DefineHarbour+Define32bits).Value := Folder, )
            END BUTTON
// Borland Libs Folder
            DEFINE LABEL &("LC_LIBS_"+DefineMiniGui1+DefineBorland+DefineHarbour+Define32bits)
                    ROW             160
                    COL             10
                    WIDTH           109
                    VALUE           '    Libs Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("TC_LIBS_"+DefineMiniGui1+DefineBorland+DefineHarbour+Define32bits)
                    VALUE           &("Gbl_T_C_LIBS_"+DefineMiniGui1+DefineBorland+DefineHarbour+Define32bits)
                    ROW             160
                    COL             120
                    WIDTH           561
                    TOOLTIP         "Full path to BCC32's libraries (usually subfolder 'lib' of BCC32 Folder)"
            END TEXTBOX
            DEFINE BUTTON &("BC_LIBS_"+DefineMiniGui1+DefineBorland+DefineHarbour+Define32bits)
                    ROW             160
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder", WinGSettings.&("TC_LIBS_"+DefineMiniGui1+DefineBorland+DefineHarbour+Define32bits).Value ) ), WinGSettings.&("TC_LIBS_"+DefineMiniGui1+DefineBorland+DefineHarbour+Define32bits).Value := Folder, )
            END BUTTON
// Harbour Folder
            DEFINE LABEL &("LP_"+DefineMiniGui1+DefineBorland+DefineHarbour+Define32bits)
                    ROW             190
                    COL             10
                    WIDTH           109
                    VALUE           'Harbour Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("TP_"+DefineMiniGui1+DefineBorland+DefineHarbour+Define32bits)
                    VALUE           &("Gbl_T_P_"+DefineMiniGui1+DefineBorland+DefineHarbour+Define32bits)
                    ROW             190
                    COL             120
                    WIDTH           561
            END TEXTBOX
            DEFINE BUTTON &("BP_"+DefineMiniGui1+DefineBorland+DefineHarbour+Define32bits)
                    ROW             190
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder", WinGSettings.&("TP_"+DefineMiniGui1+DefineBorland+DefineHarbour+Define32bits).Value ) ), WinGSettings.&("TP_"+DefineMiniGui1+DefineBorland+DefineHarbour+Define32bits).Value := Folder, )
            END BUTTON
// Harbour Libs Folder
            DEFINE LABEL &("LP_LIBS_"+DefineMiniGui1+DefineBorland+DefineHarbour+Define32bits)
                    ROW             220
                    COL             10
                    WIDTH           109
                    VALUE           '    Libs Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("TP_LIBS_"+DefineMiniGui1+DefineBorland+DefineHarbour+Define32bits)
                    VALUE           &("Gbl_T_P_LIBS_"+DefineMiniGui1+DefineBorland+DefineHarbour+Define32bits)
                    ROW             220
                    COL             120
                    WIDTH           561
                    TOOLTIP         "Full path to Harbour's libraries (usually subfolder 'lib' of Harbour Folder)"
            END TEXTBOX
            DEFINE BUTTON &("BP_LIBS_"+DefineMiniGui1+DefineBorland+DefineHarbour+Define32bits)
                    ROW             220
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder", WinGSettings.&("TP_LIBS_"+DefineMiniGui1+DefineBorland+DefineHarbour+Define32bits).Value ) ), WinGSettings.&("TP_LIBS_"+DefineMiniGui1+DefineBorland+DefineHarbour+Define32bits).Value := Folder, )
            END BUTTON

         END PAGE

         // PAGE 4
         DEFINE PAGE "HMG 1.x + BCC32 + xHarbour"

            @ 40, 10 LABEL &("LDummy_"+DefineMiniGui1+DefineBorland+DefineXHarbour+Define32bits) ;
               VALUE 'Folders for HMG 1.x + BCC32 + xHarbour:' ;
               WIDTH 601 ;
               FONT 'arial' SIZE 10 BOLD ;
               TRANSPARENT ;
               FONTCOLOR DEF_COLORBLUE

// Minigui folder
            DEFINE LABEL &("LM_"+DefineMiniGui1+DefineBorland+DefineXHarbour+Define32bits)
                    ROW             70
                    COL             10
                    WIDTH           109
                    VALUE           'HMG Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("TM_"+DefineMiniGui1+DefineBorland+DefineXHarbour+Define32bits)
                    VALUE           &("Gbl_T_M_"+DefineMiniGui1+DefineBorland+DefineXHarbour+Define32bits)
                    ROW             70
                    COL             120
                    WIDTH           561
            END TEXTBOX
            DEFINE BUTTON &("BM_"+DefineMiniGui1+DefineBorland+DefineXHarbour+Define32bits)
                    ROW             70
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder", WinGSettings.&("TM_"+DefineMiniGui1+DefineBorland+DefineXHarbour+Define32bits).Value ) ), WinGSettings.&("TM_"+DefineMiniGui1+DefineBorland+DefineXHarbour+Define32bits).Value := Folder, )
            END BUTTON
// Minigui Libs folder
            DEFINE LABEL &("LM_LIBS_"+DefineMiniGui1+DefineBorland+DefineXHarbour+Define32bits)
                    ROW             100
                    COL             10
                    WIDTH           109
                    VALUE           '    Libs Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("TM_LIBS_"+DefineMiniGui1+DefineBorland+DefineXHarbour+Define32bits)
                    VALUE           &("Gbl_T_M_LIBS_"+DefineMiniGui1+DefineBorland+DefineXHarbour+Define32bits)
                    ROW             100
                    COL             120
                    WIDTH           561
                    TOOLTIP         "Full path to HMG's libraries (usually subfolder 'lib' of HMG Folder)"
            END TEXTBOX
            DEFINE BUTTON &("BM_LIBS_"+DefineMiniGui1+DefineBorland+DefineXHarbour+Define32bits)
                    ROW             100
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder", WinGSettings.&("TM_LIBS_"+DefineMiniGui1+DefineBorland+DefineXHarbour+Define32bits).Value ) ), WinGSettings.&("TM_LIBS_"+DefineMiniGui1+DefineBorland+DefineXHarbour+Define32bits).Value := Folder, )
            END BUTTON
// Borland Folder
            DEFINE LABEL &("LC_"+DefineMiniGui1+DefineBorland+DefineXHarbour+Define32bits)
                    ROW             130
                    COL             10
                    WIDTH           109
                    VALUE           'BCC32 Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("TC_"+DefineMiniGui1+DefineBorland+DefineXHarbour+Define32bits)
                    VALUE           &("Gbl_T_C_"+DefineMiniGui1+DefineBorland+DefineXHarbour+Define32bits)
                    ROW             130
                    COL             120
                    WIDTH           561
            END TEXTBOX
            DEFINE BUTTON &("BC_"+DefineMiniGui1+DefineBorland+DefineXHarbour+Define32bits)
                    ROW             130
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder", WinGSettings.&("TC_"+DefineMiniGui1+DefineBorland+DefineXHarbour+Define32bits).Value ) ), WinGSettings.&("TC_"+DefineMiniGui1+DefineBorland+DefineXHarbour+Define32bits).Value := Folder, )
            END BUTTON
// Borland Libs Folder
            DEFINE LABEL &("LC_LIBS_"+DefineMiniGui1+DefineBorland+DefineXHarbour+Define32bits)
                    ROW             160
                    COL             10
                    WIDTH           109
                    VALUE           '    Libs Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("TC_LIBS_"+DefineMiniGui1+DefineBorland+DefineXHarbour+Define32bits)
                    VALUE           &("Gbl_T_C_LIBS_"+DefineMiniGui1+DefineBorland+DefineXHarbour+Define32bits)
                    ROW             160
                    COL             120
                    WIDTH           561
                    TOOLTIP         "Full path to BCC32's libraries (usually subfolder 'lib' of BCC32 Folder)"
            END TEXTBOX
            DEFINE BUTTON &("BC_LIBS_"+DefineMiniGui1+DefineBorland+DefineXHarbour+Define32bits)
                    ROW             160
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder", WinGSettings.&("TC_LIBS_"+DefineMiniGui1+DefineBorland+DefineXHarbour+Define32bits).Value ) ), WinGSettings.&("TC_LIBS_"+DefineMiniGui1+DefineBorland+DefineXHarbour+Define32bits).Value := Folder, )
            END BUTTON
// xHarbour Folder
            DEFINE LABEL &("LP_"+DefineMiniGui1+DefineBorland+DefineXHarbour+Define32bits)
                    ROW             190
                    COL             10
                    WIDTH           109
                    VALUE           'xHarbour Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("TP_"+DefineMiniGui1+DefineBorland+DefineXHarbour+Define32bits)
                    VALUE           &("Gbl_T_P_"+DefineMiniGui1+DefineBorland+DefineXHarbour+Define32bits)
                    ROW             190
                    COL             120
                    WIDTH           561
            END TEXTBOX
            DEFINE BUTTON &("BP_"+DefineMiniGui1+DefineBorland+DefineXHarbour+Define32bits)
                    ROW             190
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder", WinGSettings.&("TP_"+DefineMiniGui1+DefineBorland+DefineXHarbour+Define32bits).Value ) ), WinGSettings.&("TP_"+DefineMiniGui1+DefineBorland+DefineXHarbour+Define32bits).Value := Folder, )
            END BUTTON
// xHarbour Libs Folder
            DEFINE LABEL &("LP_LIBS_"+DefineMiniGui1+DefineBorland+DefineXHarbour+Define32bits)
                    ROW             220
                    COL             10
                    WIDTH           109
                    VALUE           '    Libs Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("TP_LIBS_"+DefineMiniGui1+DefineBorland+DefineXHarbour+Define32bits)
                    VALUE           &("Gbl_T_P_LIBS_"+DefineMiniGui1+DefineBorland+DefineXHarbour+Define32bits)
                    ROW             220
                    COL             120
                    WIDTH           561
                    TOOLTIP         "Full path to xHarbour's libraries (usually subfolder 'lib' of xHarbour Folder)"
            END TEXTBOX
            DEFINE BUTTON &("BP_LIBS_"+DefineMiniGui1+DefineBorland+DefineXHarbour+Define32bits)
                    ROW             220
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder", WinGSettings.&("TP_LIBS_"+DefineMiniGui1+DefineBorland+DefineXHarbour+Define32bits).Value ) ), WinGSettings.&("TP_LIBS_"+DefineMiniGui1+DefineBorland+DefineXHarbour+Define32bits).Value := Folder, )
            END BUTTON

         END PAGE

         // PAGE 5
         DEFINE PAGE "HMG 3.x + MinGW + Harbour, 32 bits"

            @ 40, 10 LABEL &("LDummy_"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define32bits) ;
               VALUE 'Folders for HMG 3.x + MinGW + Harbour, 32 bits:' ;
               WIDTH 601 ;
               FONT 'arial' SIZE 10 BOLD ;
               TRANSPARENT ;
               FONTCOLOR DEF_COLORBLUE

// Minigui Folder
            DEFINE LABEL &("LM_"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define32bits)
                    ROW             70
                    COL             10
                    WIDTH           109
                    VALUE           'HMG Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("TM_"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define32bits)
                    VALUE           &("Gbl_T_M_"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define32bits)
                    ROW             70
                    COL             120
                    WIDTH           561
            END TEXTBOX
            DEFINE BUTTON &("BM_"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define32bits)
                    ROW             70
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder", WinGSettings.&("TM_"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define32bits).Value ) ), WinGSettings.&("TM_"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define32bits).Value := Folder, )
            END BUTTON
// Minigui Libs Folder
            DEFINE LABEL &("LM_LIBS_"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define32bits)
                    ROW             100
                    COL             10
                    WIDTH           109
                    VALUE           '    Libs Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("TM_LIBS_"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define32bits)
                    VALUE           &("Gbl_T_M_LIBS_"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define32bits)
                    ROW             100
                    COL             120
                    WIDTH           561
                    TOOLTIP         "Full path to HMG's libraries (usually subfolder 'lib' of HMG Folder)"
            END TEXTBOX
            DEFINE BUTTON &("BM_LIBS_"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define32bits)
                    ROW             100
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder", WinGSettings.&("TM_LIBS_"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define32bits).Value ) ), WinGSettings.&("TM_LIBS_"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define32bits).Value := Folder, )
            END BUTTON
// MinGW Folder
            DEFINE LABEL &("LC_"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define32bits)
                    ROW             130
                    COL             10
                    WIDTH           109
                    VALUE           'MinGW Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("TC_"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define32bits)
                    VALUE           &("Gbl_T_C_"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define32bits)
                    ROW             130
                    COL             120
                    WIDTH           561
            END TEXTBOX
            DEFINE BUTTON &("BC_"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define32bits)
                    ROW             130
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder", WinGSettings.&("TC_"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define32bits).Value ) ), WinGSettings.&("TC_"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define32bits).Value := Folder, )
            END BUTTON
// MinGW Libs Folder
            DEFINE LABEL &("LC_LIBS_"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define32bits)
                    ROW             160
                    COL             10
                    WIDTH           109
                    VALUE           '    Libs Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("TC_LIBS_"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define32bits)
                    VALUE           &("Gbl_T_C_LIBS_"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define32bits)
                    ROW             160
                    COL             120
                    WIDTH           561
                    TOOLTIP         "Full path to MinGW's libraries (usually subfolder 'lib' or 'i686-w64-mingw32\lib' of MinGW Folder)"
            END TEXTBOX
            DEFINE BUTTON &("BC_LIBS_"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define32bits)
                    ROW             160
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder", WinGSettings.&("TC_LIBS_"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define32bits).Value ) ), WinGSettings.&("TC_LIBS_"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define32bits).Value := Folder, )
            END BUTTON
// Harbour Folder
            DEFINE LABEL &("LP_"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define32bits)
                    ROW             190
                    COL             10
                    WIDTH           109
                    VALUE           'Harbour Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("TP_"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define32bits)
                    VALUE           &("Gbl_T_P_"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define32bits)
                    ROW             190
                    COL             120
                    WIDTH           561
            END TEXTBOX
            DEFINE BUTTON &("BP_"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define32bits)
                    ROW             190
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder", WinGSettings.&("TP_"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define32bits).Value ) ), WinGSettings.&("TP_"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define32bits).Value := Folder, )
            END BUTTON
// Harbour Libs Folder
            DEFINE LABEL &("LP_LIBS_"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define32bits)
                    ROW             220
                    COL             10
                    WIDTH           109
                    VALUE           '    Libs Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("TP_LIBS_"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define32bits)
                    VALUE           &("Gbl_T_P_LIBS_"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define32bits)
                    ROW             220
                    COL             120
                    WIDTH           561
                    TOOLTIP         "Full path to Harbour's libraries (usually subfolder 'lib' or 'lib\win\mingw' of Harbour Folder)"
            END TEXTBOX
            DEFINE BUTTON &("BP_LIBS_"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define32bits)
                    ROW             220
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder", WinGSettings.&("TP_LIBS_"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define32bits).Value ) ), WinGSettings.&("TP_LIBS_"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define32bits).Value := Folder, )
            END BUTTON

         END PAGE

         // PAGE 6
         DEFINE PAGE "HMG 3.x + MinGW + Harbour, 64 bits"

            @ 40, 10 LABEL &("LDummy_"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define64bits) ;
               VALUE 'Folders for HMG 3.x + MinGW + Harbour, 64 bits:' ;
               WIDTH 601 ;
               FONT 'arial' SIZE 10 BOLD ;
               TRANSPARENT ;
               FONTCOLOR DEF_COLORBLUE

// Minigui Folder
            DEFINE LABEL &("LM_"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define64bits)
                    ROW             70
                    COL             10
                    WIDTH           109
                    VALUE           'HMG Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("TM_"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define64bits)
                    VALUE           &("Gbl_T_M_"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define64bits)
                    ROW             70
                    COL             120
                    WIDTH           561
            END TEXTBOX
            DEFINE BUTTON &("BM_"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define64bits)
                    ROW             70
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder", WinGSettings.&("TM_"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define64bits).Value ) ), WinGSettings.&("TM_"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define64bits).Value := Folder, )
            END BUTTON
// Minigui Libs Folder
            DEFINE LABEL &("LM_LIBS_"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define64bits)
                    ROW             100
                    COL             10
                    WIDTH           109
                    VALUE           '    Libs Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("TM_LIBS_"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define64bits)
                    VALUE           &("Gbl_T_M_LIBS_"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define64bits)
                    ROW             100
                    COL             120
                    WIDTH           561
                    TOOLTIP         "Full path to HMG's libraries (usually subfolder 'lib' of HMG Folder)"
            END TEXTBOX
            DEFINE BUTTON &("BM_LIBS_"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define64bits)
                    ROW             100
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder", WinGSettings.&("TM_LIBS_"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define64bits).Value ) ), WinGSettings.&("TM_LIBS_"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define64bits).Value := Folder, )
            END BUTTON
// MinGW Folder
            DEFINE LABEL &("LC_"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define64bits)
                    ROW             130
                    COL             10
                    WIDTH           109
                    VALUE           'MinGW Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("TC_"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define64bits)
                    VALUE           &("Gbl_T_C_"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define64bits)
                    ROW             130
                    COL             120
                    WIDTH           561
            END TEXTBOX
            DEFINE BUTTON &("BC_"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define64bits)
                    ROW             130
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder", WinGSettings.&("TC_"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define64bits).Value ) ), WinGSettings.&("TC_"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define64bits).Value := Folder, )
            END BUTTON
// MinGW Libs Folder
            DEFINE LABEL &("LC_LIBS_"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define64bits)
                    ROW             160
                    COL             10
                    WIDTH           109
                    VALUE           '    Libs Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("TC_LIBS_"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define64bits)
                    VALUE           &("Gbl_T_C_LIBS_"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define64bits)
                    ROW             160
                    COL             120
                    WIDTH           561
                    TOOLTIP         "Full path to MinGW's libraries (usually subfolder 'lib' or 'x86_64-w64-mingw32\lib' of MinGW Folder)"
            END TEXTBOX
            DEFINE BUTTON &("BC_LIBS_"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define64bits)
                    ROW             160
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder", WinGSettings.&("TC_LIBS_"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define64bits).Value ) ), WinGSettings.&("TC_LIBS_"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define64bits).Value := Folder, )
            END BUTTON
// Harbour Folder
            DEFINE LABEL &("LP_"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define64bits)
                    ROW             190
                    COL             10
                    WIDTH           109
                    VALUE           'Harbour Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("TP_"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define64bits)
                    VALUE           &("Gbl_T_P_"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define64bits)
                    ROW             190
                    COL             120
                    WIDTH           561
            END TEXTBOX
            DEFINE BUTTON &("BP_"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define64bits)
                    ROW             190
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder", WinGSettings.&("TP_"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define64bits).Value ) ), WinGSettings.&("TP_"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define64bits).Value := Folder, )
            END BUTTON
// Harbour Libs Folder
            DEFINE LABEL &("LP_LIBS_"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define64bits)
                    ROW             220
                    COL             10
                    WIDTH           109
                    VALUE           '    Libs Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("TP_LIBS_"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define64bits)
                    VALUE           &("Gbl_T_P_LIBS_"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define64bits)
                    ROW             220
                    COL             120
                    WIDTH           561
                    TOOLTIP         "Full path to Harbour's libraries (usually subfolder 'lib' or 'lib\win\mingw64' of Harbour Folder)"
            END TEXTBOX
            DEFINE BUTTON &("BP_LIBS_"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define64bits)
                    ROW             220
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder", WinGSettings.&("TP_LIBS_"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define64bits).Value ) ), WinGSettings.&("TP_LIBS_"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define64bits).Value := Folder, )
            END BUTTON

         END PAGE

         // PAGE 7
         DEFINE PAGE "HMG Extended + BCC32 + Harbour"

            @ 40, 10 LABEL &("LDummy_"+DefineExtended1+DefineBorland+DefineHarbour+Define32bits) ;
               VALUE 'Folders for HMG Extended + BCC32 + Harbour:' ;
               WIDTH 601 ;
               FONT 'arial' SIZE 10 BOLD ;
               TRANSPARENT ;
               FONTCOLOR DEF_COLORBLUE

// Minigui Folder
            DEFINE LABEL &("LM_"+DefineExtended1+DefineBorland+DefineHarbour+Define32bits)
                    ROW             70
                    COL             10
                    WIDTH           109
                    VALUE           'Extended Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("TM_"+DefineExtended1+DefineBorland+DefineHarbour+Define32bits)
                    VALUE           &("Gbl_T_M_"+DefineExtended1+DefineBorland+DefineHarbour+Define32bits)
                    ROW             70
                    COL             120
                    WIDTH           561
            END TEXTBOX
            DEFINE BUTTON &("BM_"+DefineExtended1+DefineBorland+DefineHarbour+Define32bits)
                    ROW             70
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder", WinGSettings.&("TM_"+DefineExtended1+DefineBorland+DefineHarbour+Define32bits).Value ) ), WinGSettings.&("TM_"+DefineExtended1+DefineBorland+DefineHarbour+Define32bits).Value := Folder, )
            END BUTTON
// Minigui Libs Folder
            DEFINE LABEL &("LM_LIBS_"+DefineExtended1+DefineBorland+DefineHarbour+Define32bits)
                    ROW             100
                    COL             10
                    WIDTH           109
                    VALUE           '    Libs Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("TM_LIBS_"+DefineExtended1+DefineBorland+DefineHarbour+Define32bits)
                    VALUE           &("Gbl_T_M_LIBS_"+DefineExtended1+DefineBorland+DefineHarbour+Define32bits)
                    ROW             100
                    COL             120
                    WIDTH           561
                    TOOLTIP         "Full path to HMG Extended's libraries (usually subfolder 'lib' of Extended Folder)"
            END TEXTBOX
            DEFINE BUTTON &("BM_LIBS_"+DefineExtended1+DefineBorland+DefineHarbour+Define32bits)
                    ROW             100
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder", WinGSettings.&("TM_LIBS_"+DefineExtended1+DefineBorland+DefineHarbour+Define32bits).Value ) ), WinGSettings.&("TM_LIBS_"+DefineExtended1+DefineBorland+DefineHarbour+Define32bits).Value := Folder, )
            END BUTTON
// Borland Folder
            DEFINE LABEL &("LC_"+DefineExtended1+DefineBorland+DefineHarbour+Define32bits)
                    ROW             130
                    COL             10
                    WIDTH           109
                    VALUE           'BCC32 Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("TC_"+DefineExtended1+DefineBorland+DefineHarbour+Define32bits)
                    VALUE           &("Gbl_T_C_"+DefineExtended1+DefineBorland+DefineHarbour+Define32bits)
                    ROW             130
                    COL             120
                    WIDTH           561
            END TEXTBOX
            DEFINE BUTTON &("BC_"+DefineExtended1+DefineBorland+DefineHarbour+Define32bits)
                    ROW             130
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder", WinGSettings.&("TC_"+DefineExtended1+DefineBorland+DefineHarbour+Define32bits).Value ) ), WinGSettings.&("TC_"+DefineExtended1+DefineBorland+DefineHarbour+Define32bits).Value := Folder, )
            END BUTTON
// Borland Libs Folder
            DEFINE LABEL &("LC_LIBS_"+DefineExtended1+DefineBorland+DefineHarbour+Define32bits)
                    ROW             160
                    COL             10
                    WIDTH           109
                    VALUE           '    Libs Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("TC_LIBS_"+DefineExtended1+DefineBorland+DefineHarbour+Define32bits)
                    VALUE           &("Gbl_T_C_LIBS_"+DefineExtended1+DefineBorland+DefineHarbour+Define32bits)
                    ROW             160
                    COL             120
                    WIDTH           561
                    TOOLTIP         "Full path to BCC32's libraries (usually subfolder 'lib' of BCC32 Folder)"
            END TEXTBOX
            DEFINE BUTTON &("BC_LIBS_"+DefineExtended1+DefineBorland+DefineHarbour+Define32bits)
                    ROW             160
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder", WinGSettings.&("TC_LIBS_"+DefineExtended1+DefineBorland+DefineHarbour+Define32bits).Value ) ), WinGSettings.&("TC_LIBS_"+DefineExtended1+DefineBorland+DefineHarbour+Define32bits).Value := Folder, )
            END BUTTON
// Harbour Folder
            DEFINE LABEL &("LP_"+DefineExtended1+DefineBorland+DefineHarbour+Define32bits)
                    ROW             190
                    COL             10
                    WIDTH           109
                    VALUE           'Harbour Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("TP_"+DefineExtended1+DefineBorland+DefineHarbour+Define32bits)
                    VALUE           &("Gbl_T_P_"+DefineExtended1+DefineBorland+DefineHarbour+Define32bits)
                    ROW             190
                    COL             120
                    WIDTH           561
            END TEXTBOX
            DEFINE BUTTON &("BP_"+DefineExtended1+DefineBorland+DefineHarbour+Define32bits)
                    ROW             190
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder", WinGSettings.&("TP_"+DefineExtended1+DefineBorland+DefineHarbour+Define32bits).Value ) ), WinGSettings.&("TP_"+DefineExtended1+DefineBorland+DefineHarbour+Define32bits).Value := Folder, )
            END BUTTON
// Harbour Libs Folder
            DEFINE LABEL &("LP_LIBS_"+DefineExtended1+DefineBorland+DefineHarbour+Define32bits)
                    ROW             220
                    COL             10
                    WIDTH           109
                    VALUE           '    Libs Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("TP_LIBS_"+DefineExtended1+DefineBorland+DefineHarbour+Define32bits)
                    VALUE           &("Gbl_T_P_LIBS_"+DefineExtended1+DefineBorland+DefineHarbour+Define32bits)
                    ROW             220
                    COL             120
                    WIDTH           561
                    TOOLTIP         "Full path to Harbour's libraries (usually subfolder 'lib' of Harbour Folder)"
            END TEXTBOX
            DEFINE BUTTON &("BP_LIBS_"+DefineExtended1+DefineBorland+DefineHarbour+Define32bits)
                    ROW             220
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder", WinGSettings.&("TP_LIBS_"+DefineExtended1+DefineBorland+DefineHarbour+Define32bits).Value ) ), WinGSettings.&("TP_LIBS_"+DefineExtended1+DefineBorland+DefineHarbour+Define32bits).Value := Folder, )
            END BUTTON

         END PAGE

         // PAGE 8
         DEFINE PAGE "HMG Extended + BCC32 + xHarbour"

            @ 40, 10 LABEL &("LDummy_"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits) ;
               VALUE 'Folders for HMG Extended + BCC32 + xHarbour:' ;
               WIDTH 601 ;
               FONT 'arial' SIZE 10 BOLD ;
               TRANSPARENT ;
               FONTCOLOR DEF_COLORBLUE

// Minigui Folder
            DEFINE LABEL &("LM_"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits)
                    ROW             70
                    COL             10
                    WIDTH           109
                    VALUE           'Extended Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("TM_"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits)
                    VALUE           &("Gbl_T_M_"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits)
                    ROW             70
                    COL             120
                    WIDTH           561
            END TEXTBOX
            DEFINE BUTTON &("BM_"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits)
                    ROW             70
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder", WinGSettings.&("TM_"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits).Value ) ), WinGSettings.&("TM_"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits).Value := Folder, )
            END BUTTON
// Minigui Libs Folder
            DEFINE LABEL &("LM_LIBS_"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits)
                    ROW             100
                    COL             10
                    WIDTH           109
                    VALUE           '    Libs Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("TM_LIBS_"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits)
                    VALUE           &("Gbl_T_M_LIBS_"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits)
                    ROW             100
                    COL             120
                    WIDTH           561
                    TOOLTIP         "Full path to HMG Extended's libraries (usually subfolder 'lib' of Extended Folder)"
            END TEXTBOX
            DEFINE BUTTON &("BM_LIBS_"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits)
                    ROW             100
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder", WinGSettings.&("TM_LIBS_"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits).Value ) ), WinGSettings.&("TM_LIBS_"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits).Value := Folder, )
            END BUTTON
// Borland Folder
            DEFINE LABEL &("LC_"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits)
                    ROW             130
                    COL             10
                    WIDTH           109
                    VALUE           'BCC32 Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("TC_"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits)
                    VALUE           &("Gbl_T_C_"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits)
                    ROW             130
                    COL             120
                    WIDTH           561
            END TEXTBOX
            DEFINE BUTTON &("BC_"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits)
                    ROW             130
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder", WinGSettings.&("TC_"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits).Value ) ), WinGSettings.&("TC_"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits).Value := Folder, )
            END BUTTON
// Borland Libs Folder
            DEFINE LABEL &("LC_LIBS_"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits)
                    ROW             160
                    COL             10
                    WIDTH           109
                    VALUE           '    Libs Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("TC_LIBS_"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits)
                    VALUE           &("Gbl_T_C_LIBS_"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits)
                    ROW             160
                    COL             120
                    WIDTH           561
                    TOOLTIP         "Full path to BCC32's libraries (usually subfolder 'lib' of BCC32 Folder)"
            END TEXTBOX
            DEFINE BUTTON &("BC_LIBS_"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits)
                    ROW             160
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder", WinGSettings.&("TC_LIBS_"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits).Value ) ), WinGSettings.&("TC_LIBS_"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits).Value := Folder, )
            END BUTTON
// xHarbour Folder
            DEFINE LABEL &("LP_"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits)
                    ROW             190
                    COL             10
                    WIDTH           109
                    VALUE           'xHarbour Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("TP_"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits)
                    VALUE           &("Gbl_T_P_"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits)
                    ROW             190
                    COL             120
                    WIDTH           561
            END TEXTBOX
            DEFINE BUTTON &("BP_"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits)
                    ROW             190
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder", WinGSettings.&("TP_"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits).Value ) ), WinGSettings.&("TP_"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits).Value := Folder, )
            END BUTTON
// xHarbour Libs Folder
            DEFINE LABEL &("LP_LIBS_"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits)
                    ROW             220
                    COL             10
                    WIDTH           109
                    VALUE           '    Libs Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("TP_LIBS_"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits)
                    VALUE           &("Gbl_T_P_LIBS_"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits)
                    ROW             220
                    COL             120
                    WIDTH           561
                    TOOLTIP         "Full path to xHarbour's libraries (usually subfolder 'lib' of xHarbour Folder)"
            END TEXTBOX
            DEFINE BUTTON &("BP_LIBS_"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits)
                    ROW             220
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder", WinGSettings.&("TP_LIBS_"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits).Value ) ), WinGSettings.&("TP_LIBS_"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits).Value := Folder, )
            END BUTTON

         END PAGE

         // PAGE 9
         DEFINE PAGE "HMG Extended + MinGW + Harbour, 32 bits"

            @ 40, 10 LABEL &("LDummy_"+DefineExtended1+DefineMinGW+DefineHarbour+Define32bits) ;
               VALUE 'Folders for HMG Extended + MinGW + Harbour, 32 bits:' ;
               WIDTH 601 ;
               FONT 'arial' SIZE 10 BOLD ;
               TRANSPARENT ;
               FONTCOLOR DEF_COLORBLUE

// Minigui Folder
            DEFINE LABEL &("LM_"+DefineExtended1+DefineMinGW+DefineHarbour+Define32bits)
                    ROW             70
                    COL             10
                    WIDTH           109
                    VALUE           'Extended Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("TM_"+DefineExtended1+DefineMinGW+DefineHarbour+Define32bits)
                    VALUE           &("Gbl_T_M_"+DefineExtended1+DefineMinGW+DefineHarbour+Define32bits)
                    ROW             70
                    COL             120
                    WIDTH           561
            END TEXTBOX
            DEFINE BUTTON &("BM_"+DefineExtended1+DefineMinGW+DefineHarbour+Define32bits)
                    ROW             70
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder", WinGSettings.&("TM_"+DefineExtended1+DefineMinGW+DefineHarbour+Define32bits).Value ) ), WinGSettings.&("TM_"+DefineExtended1+DefineMinGW+DefineHarbour+Define32bits).Value := Folder, )
            END BUTTON
// Minigui Libs Folder
            DEFINE LABEL &("LM_LIBS_"+DefineExtended1+DefineMinGW+DefineHarbour+Define32bits)
                    ROW             100
                    COL             10
                    WIDTH           109
                    VALUE           '    Libs Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("TM_LIBS_"+DefineExtended1+DefineMinGW+DefineHarbour+Define32bits)
                    VALUE           &("Gbl_T_M_LIBS_"+DefineExtended1+DefineMinGW+DefineHarbour+Define32bits)
                    ROW             100
                    COL             120
                    WIDTH           561
                    TOOLTIP         "Full path to HMG Extended's libraries (usually subfolder 'lib' of Extended Folder)"
            END TEXTBOX
            DEFINE BUTTON &("BM_LIBS_"+DefineExtended1+DefineMinGW+DefineHarbour+Define32bits)
                    ROW             100
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder", WinGSettings.&("TM_LIBS_"+DefineExtended1+DefineMinGW+DefineHarbour+Define32bits).Value ) ), WinGSettings.&("TM_LIBS_"+DefineExtended1+DefineMinGW+DefineHarbour+Define32bits).Value := Folder, )
            END BUTTON
// MinGW Folder
            DEFINE LABEL &("LC_"+DefineExtended1+DefineMinGW+DefineHarbour+Define32bits)
                    ROW             130
                    COL             10
                    WIDTH           109
                    VALUE           'MinGW Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("TC_"+DefineExtended1+DefineMinGW+DefineHarbour+Define32bits)
                    VALUE           &("Gbl_T_C_"+DefineExtended1+DefineMinGW+DefineHarbour+Define32bits)
                    ROW             130
                    COL             120
                    WIDTH           561
            END TEXTBOX
            DEFINE BUTTON &("BC_"+DefineExtended1+DefineMinGW+DefineHarbour+Define32bits)
                    ROW             130
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder", WinGSettings.&("TC_"+DefineExtended1+DefineMinGW+DefineHarbour+Define32bits).Value ) ), WinGSettings.&("TC_"+DefineExtended1+DefineMinGW+DefineHarbour+Define32bits).Value := Folder, )
            END BUTTON
// MinGW Libs Folder
            DEFINE LABEL &("LC_LIBS_"+DefineExtended1+DefineMinGW+DefineHarbour+Define32bits)
                    ROW             160
                    COL             10
                    WIDTH           109
                    VALUE           '    Libs Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("TC_LIBS_"+DefineExtended1+DefineMinGW+DefineHarbour+Define32bits)
                    VALUE           &("Gbl_T_C_LIBS_"+DefineExtended1+DefineMinGW+DefineHarbour+Define32bits)
                    ROW             160
                    COL             120
                    WIDTH           561
                    TOOLTIP         "Full path to MinGW's libraries (usually subfolder 'lib' or 'i686-w64-mingw32\lib' of MinGW Folder)"
            END TEXTBOX
            DEFINE BUTTON &("BC_LIBS_"+DefineExtended1+DefineMinGW+DefineHarbour+Define32bits)
                    ROW             160
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder", WinGSettings.&("TC_LIBS_"+DefineExtended1+DefineMinGW+DefineHarbour+Define32bits).Value ) ), WinGSettings.&("TC_LIBS_"+DefineExtended1+DefineMinGW+DefineHarbour+Define32bits).Value := Folder, )
            END BUTTON
// Harbour Folder
            DEFINE LABEL &("LP_"+DefineExtended1+DefineMinGW+DefineHarbour+Define32bits)
                    ROW             190
                    COL             10
                    WIDTH           109
                    VALUE           'Harbour Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("TP_"+DefineExtended1+DefineMinGW+DefineHarbour+Define32bits)
                    VALUE           &("Gbl_T_P_"+DefineExtended1+DefineMinGW+DefineHarbour+Define32bits)
                    ROW             190
                    COL             120
                    WIDTH           561
            END TEXTBOX
            DEFINE BUTTON &("BP_"+DefineExtended1+DefineMinGW+DefineHarbour+Define32bits)
                    ROW             190
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder", WinGSettings.&("TP_"+DefineExtended1+DefineMinGW+DefineHarbour+Define32bits).Value ) ), WinGSettings.&("TP_"+DefineExtended1+DefineMinGW+DefineHarbour+Define32bits).Value := Folder, )
            END BUTTON
// Harbour Libs Folder
            DEFINE LABEL &("LP_LIBS_"+DefineExtended1+DefineMinGW+DefineHarbour+Define32bits)
                    ROW             220
                    COL             10
                    WIDTH           109
                    VALUE           '    Libs Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("TP_LIBS_"+DefineExtended1+DefineMinGW+DefineHarbour+Define32bits)
                    VALUE           &("Gbl_T_P_LIBS_"+DefineExtended1+DefineMinGW+DefineHarbour+Define32bits)
                    ROW             220
                    COL             120
                    WIDTH           561
                    TOOLTIP         "Full path to Harbour's libraries (usually subfolder 'lib' or 'lib\win\mingw' of Harbour Folder)"
            END TEXTBOX
            DEFINE BUTTON &("BP_LIBS_"+DefineExtended1+DefineMinGW+DefineHarbour+Define32bits)
                    ROW             220
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder", WinGSettings.&("TP_LIBS_"+DefineExtended1+DefineMinGW+DefineHarbour+Define32bits).Value ) ), WinGSettings.&("TP_LIBS_"+DefineExtended1+DefineMinGW+DefineHarbour+Define32bits).Value := Folder, )
            END BUTTON

         END PAGE

         // PAGE 10
         DEFINE PAGE "HMG Extended + MinGW + xHarbour, 32 bits"

            @ 40, 10 LABEL &("LDummy_"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits) ;
               VALUE 'Folders for HMG Extended + MinGW + xHarbour, 32 bits:' ;
               WIDTH 601 ;
               FONT 'arial' SIZE 10 BOLD ;
               TRANSPARENT ;
               FONTCOLOR DEF_COLORBLUE

// Minigui Folder
            DEFINE LABEL &("LM_"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits)
                    ROW             70
                    COL             10
                    WIDTH           109
                    VALUE           'Extended Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("TM_"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits)
                    VALUE           &("Gbl_T_M_"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits)
                    ROW             70
                    COL             120
                    WIDTH           561
            END TEXTBOX
            DEFINE BUTTON &("BM_"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits)
                    ROW             70
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder", WinGSettings.&("TM_"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits).Value ) ), WinGSettings.&("TM_"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits).Value := Folder, )
            END BUTTON
// Minigui Libs Folder
            DEFINE LABEL &("LM_LIBS_"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits)
                    ROW             100
                    COL             10
                    WIDTH           109
                    VALUE           '    Libs Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("TM_LIBS_"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits)
                    VALUE           &("Gbl_T_M_LIBS_"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits)
                    ROW             100
                    COL             120
                    WIDTH           561
                    TOOLTIP         "Full path to HMG Extended's libraries (usually subfolder 'lib' of Extended Folder)"
            END TEXTBOX
            DEFINE BUTTON &("BM_LIBS_"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits)
                    ROW             100
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder", WinGSettings.&("TM_LIBS_"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits).Value ) ), WinGSettings.&("TM_LIBS_"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits).Value := Folder, )
            END BUTTON
// MinGW Folder
            DEFINE LABEL &("LC_"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits)
                    ROW             130
                    COL             10
                    WIDTH           109
                    VALUE           'MinGW Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("TC_"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits)
                    VALUE           &("Gbl_T_C_"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits)
                    ROW             130
                    COL             120
                    WIDTH           561
            END TEXTBOX
            DEFINE BUTTON &("BC_"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits)
                    ROW             130
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder", WinGSettings.&("TC_"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits).Value ) ), WinGSettings.&("TC_"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits).Value := Folder, )
            END BUTTON
// MinGW Libs Folder
            DEFINE LABEL &("LC_LIBS_"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits)
                    ROW             160
                    COL             10
                    WIDTH           109
                    VALUE           '    Libs Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("TC_LIBS_"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits)
                    VALUE           &("Gbl_T_C_LIBS_"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits)
                    ROW             160
                    COL             120
                    WIDTH           561
                    TOOLTIP         "Full path to MinGW's libraries (usually subfolder 'lib' or 'i686-w64-mingw32\lib' of MinGW Folder)"
            END TEXTBOX
            DEFINE BUTTON &("BC_LIBS_"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits)
                    ROW             160
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder", WinGSettings.&("TC_LIBS_"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits).Value ) ), WinGSettings.&("TC_LIBS_"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits).Value := Folder, )
            END BUTTON
// xHarbour Folder
            DEFINE LABEL &("LP_"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits)
                    ROW             190
                    COL             10
                    WIDTH           109
                    VALUE           'xHarbour Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("TP_"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits)
                    VALUE           &("Gbl_T_P_"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits)
                    ROW             190
                    COL             120
                    WIDTH           561
            END TEXTBOX
            DEFINE BUTTON &("BP_"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits)
                    ROW             190
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder", WinGSettings.&("TP_"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits).Value ) ), WinGSettings.&("TP_"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits).Value := Folder, )
            END BUTTON
// xHarbour Libs Folder
            DEFINE LABEL &("LP_LIBS_"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits)
                    ROW             220
                    COL             10
                    WIDTH           109
                    VALUE           '    Libs Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("TP_LIBS_"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits)
                    VALUE           &("Gbl_T_P_LIBS_"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits)
                    ROW             220
                    COL             120
                    WIDTH           561
                    TOOLTIP         "Full path to xHarbour's libraries (usually subfolder 'lib' or 'lib\win\mingw' of xHarbour Folder)"
            END TEXTBOX
            DEFINE BUTTON &("BP_LIBS_"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits)
                    ROW             220
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder", WinGSettings.&("TP_LIBS_"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits).Value ) ), WinGSettings.&("TP_LIBS_"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits).Value := Folder, )
            END BUTTON

         END PAGE

         // PAGE 11
         DEFINE PAGE "HMG Extended + MinGW + Harbour, 64 bits"

            @ 40, 10 LABEL &("LDummy_"+DefineExtended1+DefineMinGW+DefineHarbour+Define64bits) ;
               VALUE 'Folders for HMG Extended + MinGW + Harbour, 64 bits:' ;
               WIDTH 601 ;
               FONT 'arial' SIZE 10 BOLD ;
               TRANSPARENT ;
               FONTCOLOR DEF_COLORBLUE

// Minigui Folder
            DEFINE LABEL &("LM_"+DefineExtended1+DefineMinGW+DefineHarbour+Define64bits)
                    ROW             70
                    COL             10
                    WIDTH           109
                    VALUE           'Extended Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("TM_"+DefineExtended1+DefineMinGW+DefineHarbour+Define64bits)
                    VALUE           &("Gbl_T_M_"+DefineExtended1+DefineMinGW+DefineHarbour+Define64bits)
                    ROW             70
                    COL             120
                    WIDTH           561
            END TEXTBOX
            DEFINE BUTTON &("BM_"+DefineExtended1+DefineMinGW+DefineHarbour+Define64bits)
                    ROW             70
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder", WinGSettings.&("TM_"+DefineExtended1+DefineMinGW+DefineHarbour+Define64bits).Value ) ), WinGSettings.&("TM_"+DefineExtended1+DefineMinGW+DefineHarbour+Define64bits).Value := Folder, )
            END BUTTON
// Minigui Libs Folder
            DEFINE LABEL &("LM_LIBS_"+DefineExtended1+DefineMinGW+DefineHarbour+Define64bits)
                    ROW             100
                    COL             10
                    WIDTH           109
                    VALUE           '    Libs Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("TM_LIBS_"+DefineExtended1+DefineMinGW+DefineHarbour+Define64bits)
                    VALUE           &("Gbl_T_M_LIBS_"+DefineExtended1+DefineMinGW+DefineHarbour+Define64bits)
                    ROW             100
                    COL             120
                    WIDTH           561
                    TOOLTIP         "Full path to HMG Extended's libraries (usually subfolder 'lib' of Extended Folder)"
            END TEXTBOX
            DEFINE BUTTON &("BM_LIBS_"+DefineExtended1+DefineMinGW+DefineHarbour+Define64bits)
                    ROW             100
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder", WinGSettings.&("TM_LIBS_"+DefineExtended1+DefineMinGW+DefineHarbour+Define64bits).Value ) ), WinGSettings.&("TM_LIBS_"+DefineExtended1+DefineMinGW+DefineHarbour+Define64bits).Value := Folder, )
            END BUTTON
// MinGW Folder
            DEFINE LABEL &("LC_"+DefineExtended1+DefineMinGW+DefineHarbour+Define64bits)
                    ROW             130
                    COL             10
                    WIDTH           109
                    VALUE           'MinGW Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("TC_"+DefineExtended1+DefineMinGW+DefineHarbour+Define64bits)
                    VALUE           &("Gbl_T_C_"+DefineExtended1+DefineMinGW+DefineHarbour+Define64bits)
                    ROW             130
                    COL             120
                    WIDTH           561
            END TEXTBOX
            DEFINE BUTTON &("BC_"+DefineExtended1+DefineMinGW+DefineHarbour+Define64bits)
                    ROW             130
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder", WinGSettings.&("TC_"+DefineExtended1+DefineMinGW+DefineHarbour+Define64bits).Value ) ), WinGSettings.&("TC_"+DefineExtended1+DefineMinGW+DefineHarbour+Define64bits).Value := Folder, )
            END BUTTON
// MinGW Libs Folder
            DEFINE LABEL &("LC_LIBS_"+DefineExtended1+DefineMinGW+DefineHarbour+Define64bits)
                    ROW             160
                    COL             10
                    WIDTH           109
                    VALUE           '    Libs Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("TC_LIBS_"+DefineExtended1+DefineMinGW+DefineHarbour+Define64bits)
                    VALUE           &("Gbl_T_C_LIBS_"+DefineExtended1+DefineMinGW+DefineHarbour+Define64bits)
                    ROW             160
                    COL             120
                    WIDTH           561
                    TOOLTIP         "Full path to MinGW's libraries (usually subfolder 'lib' or 'i686-w64-mingw32\lib' of MinGW Folder)"
            END TEXTBOX
            DEFINE BUTTON &("BC_LIBS_"+DefineExtended1+DefineMinGW+DefineHarbour+Define64bits)
                    ROW             160
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder", WinGSettings.&("TC_LIBS_"+DefineExtended1+DefineMinGW+DefineHarbour+Define64bits).Value ) ), WinGSettings.&("TC_LIBS_"+DefineExtended1+DefineMinGW+DefineHarbour+Define64bits).Value := Folder, )
            END BUTTON
// Harbour Folder
            DEFINE LABEL &("LP_"+DefineExtended1+DefineMinGW+DefineHarbour+Define64bits)
                    ROW             190
                    COL             10
                    WIDTH           109
                    VALUE           'Harbour Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("TP_"+DefineExtended1+DefineMinGW+DefineHarbour+Define64bits)
                    VALUE           &("Gbl_T_P_"+DefineExtended1+DefineMinGW+DefineHarbour+Define64bits)
                    ROW             190
                    COL             120
                    WIDTH           561
            END TEXTBOX
            DEFINE BUTTON &("BP_"+DefineExtended1+DefineMinGW+DefineHarbour+Define64bits)
                    ROW             190
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder", WinGSettings.&("TP_"+DefineExtended1+DefineMinGW+DefineHarbour+Define64bits).Value ) ), WinGSettings.&("TP_"+DefineExtended1+DefineMinGW+DefineHarbour+Define64bits).Value := Folder, )
            END BUTTON
// Harbour Libs Folder
            DEFINE LABEL &("LP_LIBS_"+DefineExtended1+DefineMinGW+DefineHarbour+Define64bits)
                    ROW             220
                    COL             10
                    WIDTH           109
                    VALUE           '    Libs Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("TP_LIBS_"+DefineExtended1+DefineMinGW+DefineHarbour+Define64bits)
                    VALUE           &("Gbl_T_P_LIBS_"+DefineExtended1+DefineMinGW+DefineHarbour+Define64bits)
                    ROW             220
                    COL             120
                    WIDTH           561
                    TOOLTIP         "Full path to Harbour's libraries (usually subfolder 'lib' or 'lib\win\mingw' of Harbour Folder)"
            END TEXTBOX
            DEFINE BUTTON &("BP_LIBS_"+DefineExtended1+DefineMinGW+DefineHarbour+Define64bits)
                    ROW             220
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder", WinGSettings.&("TP_LIBS_"+DefineExtended1+DefineMinGW+DefineHarbour+Define64bits).Value ) ), WinGSettings.&("TP_LIBS_"+DefineExtended1+DefineMinGW+DefineHarbour+Define64bits).Value := Folder, )
            END BUTTON

         END PAGE

         // PAGE 12
         DEFINE PAGE "HMG Extended + MinGW + xHarbour, 64 bits"

            @ 40, 10 LABEL &("LDummy_"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits) ;
               VALUE 'Folders for HMG Extended + MinGW + xHarbour, 64 bits:' ;
               WIDTH 601 ;
               FONT 'arial' SIZE 10 BOLD ;
               TRANSPARENT ;
               FONTCOLOR DEF_COLORBLUE

// Minigui Folder
            DEFINE LABEL &("LM_"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits)
                    ROW             70
                    COL             10
                    WIDTH           109
                    VALUE           'Extended Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("TM_"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits)
                    VALUE           &("Gbl_T_M_"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits)
                    ROW             70
                    COL             120
                    WIDTH           561
            END TEXTBOX
            DEFINE BUTTON &("BM_"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits)
                    ROW             70
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder", WinGSettings.&("TM_"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits).Value ) ), WinGSettings.&("TM_"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits).Value := Folder, )
            END BUTTON
// Minigui Libs Folder
            DEFINE LABEL &("LM_LIBS_"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits)
                    ROW             100
                    COL             10
                    WIDTH           109
                    VALUE           '    Libs Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("TM_LIBS_"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits)
                    VALUE           &("Gbl_T_M_LIBS_"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits)
                    ROW             100
                    COL             120
                    WIDTH           561
                    TOOLTIP         "Full path to HMG Extended's libraries (usually subfolder 'lib' of Extended Folder)"
            END TEXTBOX
            DEFINE BUTTON &("BM_LIBS_"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits)
                    ROW             100
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder", WinGSettings.&("TM_LIBS_"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits).Value ) ), WinGSettings.&("TM_LIBS_"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits).Value := Folder, )
            END BUTTON
// MinGW Folder
            DEFINE LABEL &("LC_"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits)
                    ROW             130
                    COL             10
                    WIDTH           109
                    VALUE           'MinGW Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("TC_"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits)
                    VALUE           &("Gbl_T_C_"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits)
                    ROW             130
                    COL             120
                    WIDTH           561
            END TEXTBOX
            DEFINE BUTTON &("BC_"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits)
                    ROW             130
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder", WinGSettings.&("TC_"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits).Value ) ), WinGSettings.&("TC_"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits).Value := Folder, )
            END BUTTON
// MinGW Libs Folder
            DEFINE LABEL &("LC_LIBS_"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits)
                    ROW             160
                    COL             10
                    WIDTH           109
                    VALUE           '    Libs Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("TC_LIBS_"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits)
                    VALUE           &("Gbl_T_C_LIBS_"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits)
                    ROW             160
                    COL             120
                    WIDTH           561
                    TOOLTIP         "Full path to MinGW's libraries (usually subfolder 'lib' or 'i686-w64-mingw32\lib' of MinGW Folder)"
            END TEXTBOX
            DEFINE BUTTON &("BC_LIBS_"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits)
                    ROW             160
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder", WinGSettings.&("TC_LIBS_"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits).Value ) ), WinGSettings.&("TC_LIBS_"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits).Value := Folder, )
            END BUTTON
// xHarbour Folder
            DEFINE LABEL &("LP_"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits)
                    ROW             190
                    COL             10
                    WIDTH           109
                    VALUE           'xHarbour Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("TP_"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits)
                    VALUE           &("Gbl_T_P_"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits)
                    ROW             190
                    COL             120
                    WIDTH           561
            END TEXTBOX
            DEFINE BUTTON &("BP_"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits)
                    ROW             190
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder", WinGSettings.&("TP_"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits).Value ) ), WinGSettings.&("TP_"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits).Value := Folder, )
            END BUTTON
// xHarbour Libs Folder
            DEFINE LABEL &("LP_LIBS_"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits)
                    ROW             220
                    COL             10
                    WIDTH           109
                    VALUE           '    Libs Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("TP_LIBS_"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits)
                    VALUE           &("Gbl_T_P_LIBS_"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits)
                    ROW             220
                    COL             120
                    WIDTH           561
                    TOOLTIP         "Full path to xHarbour's libraries (usually subfolder 'lib' or 'lib\win\mingw' of xHarbour Folder)"
            END TEXTBOX
            DEFINE BUTTON &("BP_LIBS_"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits)
                    ROW             220
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder", WinGSettings.&("TP_LIBS_"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits).Value ) ), WinGSettings.&("TP_LIBS_"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits).Value := Folder, )
            END BUTTON

         END PAGE

         // PAGE 13
         DEFINE PAGE "OOHG + BCC32 + Harbour"

            @ 40, 10 LABEL &("LDummy_"+DefineOohg3+DefineBorland+DefineHarbour+Define32bits) ;
               VALUE 'Folders for OOHG + BCC32 + Harbour:' ;
               WIDTH 601 ;
               FONT 'arial' SIZE 10 BOLD ;
               TRANSPARENT ;
               FONTCOLOR DEF_COLORBLUE

// Minigui Folder
            DEFINE LABEL &("LM_"+DefineOohg3+DefineBorland+DefineHarbour+Define32bits)
                    ROW             70
                    COL             10
                    WIDTH           109
                    VALUE           'OOHG Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("TM_"+DefineOohg3+DefineBorland+DefineHarbour+Define32bits)
                    VALUE           &("Gbl_T_M_"+DefineOohg3+DefineBorland+DefineHarbour+Define32bits)
                    ROW             70
                    COL             120
                    WIDTH           561
            END TEXTBOX
            DEFINE BUTTON &("BM_"+DefineOohg3+DefineBorland+DefineHarbour+Define32bits)
                    ROW             70
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder", WinGSettings.&("TM_"+DefineOohg3+DefineBorland+DefineHarbour+Define32bits).Value ) ), WinGSettings.&("TM_"+DefineOohg3+DefineBorland+DefineHarbour+Define32bits).Value := Folder, )
            END BUTTON
// Minigui Libs Folder
            DEFINE LABEL &("LM_LIBS_"+DefineOohg3+DefineBorland+DefineHarbour+Define32bits)
                    ROW             100
                    COL             10
                    WIDTH           109
                    VALUE           '    Libs Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("TM_LIBS_"+DefineOohg3+DefineBorland+DefineHarbour+Define32bits)
                    VALUE           &("Gbl_T_M_LIBS_"+DefineOohg3+DefineBorland+DefineHarbour+Define32bits)
                    ROW             100
                    COL             120
                    WIDTH           561
                    TOOLTIP         "Full path to OOHG's libraries (usually subfolder 'lib' of Harbour Folder)"
            END TEXTBOX
            DEFINE BUTTON &("BM_LIBS_"+DefineOohg3+DefineBorland+DefineHarbour+Define32bits)
                    ROW             100
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder", WinGSettings.&("TM_LIBS_"+DefineOohg3+DefineBorland+DefineHarbour+Define32bits).Value ) ), WinGSettings.&("TM_LIBS_"+DefineOohg3+DefineBorland+DefineHarbour+Define32bits).Value := Folder, )
            END BUTTON
// Borland Folder
            DEFINE LABEL &("LC_"+DefineOohg3+DefineBorland+DefineHarbour+Define32bits)
                    ROW             130
                    COL             10
                    WIDTH           109
                    VALUE           'BCC32 Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("TC_"+DefineOohg3+DefineBorland+DefineHarbour+Define32bits)
                    VALUE           &("Gbl_T_C_"+DefineOohg3+DefineBorland+DefineHarbour+Define32bits)
                    ROW             130
                    COL             120
                    WIDTH           561
            END TEXTBOX
            DEFINE BUTTON &("BC_"+DefineOohg3+DefineBorland+DefineHarbour+Define32bits)
                    ROW             130
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder", WinGSettings.&("TC_"+DefineOohg3+DefineBorland+DefineHarbour+Define32bits).Value ) ), WinGSettings.&("TC_"+DefineOohg3+DefineBorland+DefineHarbour+Define32bits).Value := Folder, )
            END BUTTON
// Borland Libs Folder
            DEFINE LABEL &("LC_LIBS_"+DefineOohg3+DefineBorland+DefineHarbour+Define32bits)
                    ROW             160
                    COL             10
                    WIDTH           109
                    VALUE           '    Libs Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("TC_LIBS_"+DefineOohg3+DefineBorland+DefineHarbour+Define32bits)
                    VALUE           &("Gbl_T_C_LIBS_"+DefineOohg3+DefineBorland+DefineHarbour+Define32bits)
                    ROW             160
                    COL             120
                    WIDTH           561
                    TOOLTIP         "Full path to BCC32's libraries (usually subfolder 'lib' of BCC32 Folder)"
            END TEXTBOX
            DEFINE BUTTON &("BC_LIBS_"+DefineOohg3+DefineBorland+DefineHarbour+Define32bits)
                    ROW             160
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder", WinGSettings.&("TC_LIBS_"+DefineOohg3+DefineBorland+DefineHarbour+Define32bits).Value ) ), WinGSettings.&("TC_LIBS_"+DefineOohg3+DefineBorland+DefineHarbour+Define32bits).Value := Folder, )
            END BUTTON
// Harbour Folder
            DEFINE LABEL &("LP_"+DefineOohg3+DefineBorland+DefineHarbour+Define32bits)
                    ROW             190
                    COL             10
                    WIDTH           109
                    VALUE           'Harbour Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("TP_"+DefineOohg3+DefineBorland+DefineHarbour+Define32bits)
                    VALUE           &("Gbl_T_P_"+DefineOohg3+DefineBorland+DefineHarbour+Define32bits)
                    ROW             190
                    COL             120
                    WIDTH           561
            END TEXTBOX
            DEFINE BUTTON &("BP_"+DefineOohg3+DefineBorland+DefineHarbour+Define32bits)
                    ROW             190
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder", WinGSettings.&("TP_"+DefineOohg3+DefineBorland+DefineHarbour+Define32bits).Value ) ), WinGSettings.&("TP_"+DefineOohg3+DefineBorland+DefineHarbour+Define32bits).Value := Folder, )
            END BUTTON
// Harbour Libs Folder
            DEFINE LABEL &("LP_LIBS_"+DefineOohg3+DefineBorland+DefineHarbour+Define32bits)
                    ROW             220
                    COL             10
                    WIDTH           109
                    VALUE           '    Libs Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("TP_LIBS_"+DefineOohg3+DefineBorland+DefineHarbour+Define32bits)
                    VALUE           &("Gbl_T_P_LIBS_"+DefineOohg3+DefineBorland+DefineHarbour+Define32bits)
                    ROW             220
                    COL             120
                    WIDTH           561
                    TOOLTIP         "Full path to Harbour's libraries (usually subfolder 'lib' of Harbour Folder)"
            END TEXTBOX
            DEFINE BUTTON &("BP_LIBS_"+DefineOohg3+DefineBorland+DefineHarbour+Define32bits)
                    ROW             220
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder", WinGSettings.&("TP_LIBS_"+DefineOohg3+DefineBorland+DefineHarbour+Define32bits).Value ) ), WinGSettings.&("TP_LIBS_"+DefineOohg3+DefineBorland+DefineHarbour+Define32bits).Value := Folder, )
            END BUTTON

         END PAGE

         // PAGE 14
         DEFINE PAGE "OOHG + BCC32 + xHarbour"

            @ 40, 10 LABEL &("LDummy_"+DefineOohg3+DefineBorland+DefineXHarbour+Define32bits) ;
               VALUE 'Folders for OOHG + BCC32 + xHarbour:' ;
               WIDTH 601 ;
               FONT 'arial' SIZE 10 BOLD ;
               TRANSPARENT ;
               FONTCOLOR DEF_COLORBLUE

// Minigui Folder
            DEFINE LABEL &("LM_"+DefineOohg3+DefineBorland+DefineXHarbour+Define32bits)
                    ROW             70
                    COL             10
                    WIDTH           109
                    VALUE           'OOHG Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("TM_"+DefineOohg3+DefineBorland+DefineXHarbour+Define32bits)
                    VALUE           &("Gbl_T_M_"+DefineOohg3+DefineBorland+DefineXHarbour+Define32bits)
                    ROW             70
                    COL             120
                    WIDTH           561
            END TEXTBOX
            DEFINE BUTTON &("BM_"+DefineOohg3+DefineBorland+DefineXHarbour+Define32bits)
                    ROW             70
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder", WinGSettings.&("TM_"+DefineOohg3+DefineBorland+DefineXHarbour+Define32bits).Value ) ), WinGSettings.&("TM_"+DefineOohg3+DefineBorland+DefineXHarbour+Define32bits).Value := Folder, )
            END BUTTON
// Minigui Libs Folder
            DEFINE LABEL &("LM_LIBS_"+DefineOohg3+DefineBorland+DefineXHarbour+Define32bits)
                    ROW             100
                    COL             10
                    WIDTH           109
                    VALUE           '    Libs Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("TM_LIBS_"+DefineOohg3+DefineBorland+DefineXHarbour+Define32bits)
                    VALUE           &("Gbl_T_M_LIBS_"+DefineOohg3+DefineBorland+DefineXHarbour+Define32bits)
                    ROW             100
                    COL             120
                    WIDTH           561
                    TOOLTIP         "Full path to OOHG's libraries (usually subfolder 'lib' of Harbour Folder)"
            END TEXTBOX
            DEFINE BUTTON &("BM_LIBS_"+DefineOohg3+DefineBorland+DefineXHarbour+Define32bits)
                    ROW             100
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder", WinGSettings.&("TM_LIBS_"+DefineOohg3+DefineBorland+DefineXHarbour+Define32bits).Value ) ), WinGSettings.&("TM_LIBS_"+DefineOohg3+DefineBorland+DefineXHarbour+Define32bits).Value := Folder, )
            END BUTTON
// Borland Folder
            DEFINE LABEL &("LC_"+DefineOohg3+DefineBorland+DefineXHarbour+Define32bits)
                    ROW             130
                    COL             10
                    WIDTH           109
                    VALUE           'BCC32 Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("TC_"+DefineOohg3+DefineBorland+DefineXHarbour+Define32bits)
                    VALUE           &("Gbl_T_C_"+DefineOohg3+DefineBorland+DefineXHarbour+Define32bits)
                    ROW             130
                    COL             120
                    WIDTH           561
            END TEXTBOX
            DEFINE BUTTON &("BC_"+DefineOohg3+DefineBorland+DefineXHarbour+Define32bits)
                    ROW             130
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder", WinGSettings.&("TC_"+DefineOohg3+DefineBorland+DefineXHarbour+Define32bits).Value ) ), WinGSettings.&("TC_"+DefineOohg3+DefineBorland+DefineXHarbour+Define32bits).Value := Folder, )
            END BUTTON
// Borland Libs Folder
            DEFINE LABEL &("LC_LIBS_"+DefineOohg3+DefineBorland+DefineXHarbour+Define32bits)
                    ROW             160
                    COL             10
                    WIDTH           109
                    VALUE           '    Libs Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("TC_LIBS_"+DefineOohg3+DefineBorland+DefineXHarbour+Define32bits)
                    VALUE           &("Gbl_T_C_LIBS_"+DefineOohg3+DefineBorland+DefineXHarbour+Define32bits)
                    ROW             160
                    COL             120
                    WIDTH           561
                    TOOLTIP         "Full path to BCC32's libraries (usually subfolder 'lib' of BCC32 Folder)"
            END TEXTBOX
            DEFINE BUTTON &("BC_LIBS_"+DefineOohg3+DefineBorland+DefineXHarbour+Define32bits)
                    ROW             160
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder", WinGSettings.&("TC_LIBS_"+DefineOohg3+DefineBorland+DefineXHarbour+Define32bits).Value ) ), WinGSettings.&("TC_LIBS_"+DefineOohg3+DefineBorland+DefineXHarbour+Define32bits).Value := Folder, )
            END BUTTON
// xHarbour Folder
            DEFINE LABEL &("LP_"+DefineOohg3+DefineBorland+DefineXHarbour+Define32bits)
                    ROW             190
                    COL             10
                    WIDTH           109
                    VALUE           'xHarbour Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("TP_"+DefineOohg3+DefineBorland+DefineXHarbour+Define32bits)
                    VALUE           &("Gbl_T_P_"+DefineOohg3+DefineBorland+DefineXHarbour+Define32bits)
                    ROW             190
                    COL             120
                    WIDTH           561
            END TEXTBOX
            DEFINE BUTTON &("BP_"+DefineOohg3+DefineBorland+DefineXHarbour+Define32bits)
                    ROW             190
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder", WinGSettings.&("TP_"+DefineOohg3+DefineBorland+DefineXHarbour+Define32bits).Value ) ), WinGSettings.&("TP_"+DefineOohg3+DefineBorland+DefineXHarbour+Define32bits).Value := Folder, )
            END BUTTON
// xHarbour Libs Folder
            DEFINE LABEL &("LP_LIBS_"+DefineOohg3+DefineBorland+DefineXHarbour+Define32bits)
                    ROW             220
                    COL             10
                    WIDTH           109
                    VALUE           '    Libs Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("TP_LIBS_"+DefineOohg3+DefineBorland+DefineXHarbour+Define32bits)
                    VALUE           &("Gbl_T_P_LIBS_"+DefineOohg3+DefineBorland+DefineXHarbour+Define32bits)
                    ROW             220
                    COL             120
                    WIDTH           561
                    TOOLTIP         "Full path to xHarbour's libraries (usually subfolder 'lib' of xHarbour Folder)"
            END TEXTBOX
            DEFINE BUTTON &("BP_LIBS_"+DefineOohg3+DefineBorland+DefineXHarbour+Define32bits)
                    ROW             220
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder", WinGSettings.&("TP_LIBS_"+DefineOohg3+DefineBorland+DefineXHarbour+Define32bits).Value ) ), WinGSettings.&("TP_LIBS_"+DefineOohg3+DefineBorland+DefineXHarbour+Define32bits).Value := Folder, )
            END BUTTON

         END PAGE

         // PAGE 15
         DEFINE PAGE "OOHG + MinGW + Harbour, 32 bits"

            @ 40, 10 LABEL &("LDummy_"+DefineOohg3+DefineMinGW+DefineHarbour+Define32bits) ;
               VALUE 'Folders for OOHG + MinGW + Harbour, 32 bits:' ;
               WIDTH 601 ;
               FONT 'arial' SIZE 10 BOLD ;
               TRANSPARENT ;
               FONTCOLOR DEF_COLORBLUE

// Minigui Folder
            DEFINE LABEL &("LM_"+DefineOohg3+DefineMinGW+DefineHarbour+Define32bits)
                    ROW             70
                    COL             10
                    WIDTH           109
                    VALUE           'OOHG Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("TM_"+DefineOohg3+DefineMinGW+DefineHarbour+Define32bits)
                    VALUE           &("Gbl_T_M_"+DefineOohg3+DefineMinGW+DefineHarbour+Define32bits)
                    ROW             70
                    COL             120
                    WIDTH           561
            END TEXTBOX
            DEFINE BUTTON &("BM_"+DefineOohg3+DefineMinGW+DefineHarbour+Define32bits)
                    ROW             70
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder", WinGSettings.&("TM_"+DefineOohg3+DefineMinGW+DefineHarbour+Define32bits).Value ) ), WinGSettings.&("TM_"+DefineOohg3+DefineMinGW+DefineHarbour+Define32bits).Value := Folder, )
            END BUTTON
// Minigui Libs Folder
            DEFINE LABEL &("LM_LIBS_"+DefineOohg3+DefineMinGW+DefineHarbour+Define32bits)
                    ROW             100
                    COL             10
                    WIDTH           109
                    VALUE           '    Libs Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("TM_LIBS_"+DefineOohg3+DefineMinGW+DefineHarbour+Define32bits)
                    VALUE           &("Gbl_T_M_LIBS_"+DefineOohg3+DefineMinGW+DefineHarbour+Define32bits)
                    ROW             100
                    COL             120
                    WIDTH           561
                    TOOLTIP         "Full path to OOHG's libraries (usually subfolder 'lib' of OOHG Folder)"
            END TEXTBOX
            DEFINE BUTTON &("BM_LIBS_"+DefineOohg3+DefineMinGW+DefineHarbour+Define32bits)
                    ROW             100
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder", WinGSettings.&("TM_LIBS_"+DefineOohg3+DefineMinGW+DefineHarbour+Define32bits).Value ) ), WinGSettings.&("TM_LIBS_"+DefineOohg3+DefineMinGW+DefineHarbour+Define32bits).Value := Folder, )
            END BUTTON
// MinGW Folder
            DEFINE LABEL &("LC_"+DefineOohg3+DefineMinGW+DefineHarbour+Define32bits)
                    ROW             130
                    COL             10
                    WIDTH           109
                    VALUE           'MinGW Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("TC_"+DefineOohg3+DefineMinGW+DefineHarbour+Define32bits)
                    VALUE           &("Gbl_T_C_"+DefineOohg3+DefineMinGW+DefineHarbour+Define32bits)
                    ROW             130
                    COL             120
                    WIDTH           561
            END TEXTBOX
            DEFINE BUTTON &("BC_"+DefineOohg3+DefineMinGW+DefineHarbour+Define32bits)
                    ROW             130
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder", WinGSettings.&("TC_"+DefineOohg3+DefineMinGW+DefineHarbour+Define32bits).Value ) ), WinGSettings.&("TC_"+DefineOohg3+DefineMinGW+DefineHarbour+Define32bits).Value := Folder, )
            END BUTTON
// MinGW Libs Folder
            DEFINE LABEL &("LC_LIBS_"+DefineOohg3+DefineMinGW+DefineHarbour+Define32bits)
                    ROW             160
                    COL             10
                    WIDTH           109
                    VALUE           '    Libs Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("TC_LIBS_"+DefineOohg3+DefineMinGW+DefineHarbour+Define32bits)
                    VALUE           &("Gbl_T_C_LIBS_"+DefineOohg3+DefineMinGW+DefineHarbour+Define32bits)
                    ROW             160
                    COL             120
                    WIDTH           561
                    TOOLTIP         "Full path to MinGW's libraries (usually subfolder 'lib' or 'i686-w64-mingw32\lib' of MinGW Folder)"
            END TEXTBOX
            DEFINE BUTTON &("BC_LIBS_"+DefineOohg3+DefineMinGW+DefineHarbour+Define32bits)
                    ROW             160
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder", WinGSettings.&("TC_LIBS_"+DefineOohg3+DefineMinGW+DefineHarbour+Define32bits).Value ) ), WinGSettings.&("TC_LIBS_"+DefineOohg3+DefineMinGW+DefineHarbour+Define32bits).Value := Folder, )
            END BUTTON
// Harbour Folder
            DEFINE LABEL &("LP_"+DefineOohg3+DefineMinGW+DefineHarbour+Define32bits)
                    ROW             190
                    COL             10
                    WIDTH           109
                    VALUE           'Harbour Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("TP_"+DefineOohg3+DefineMinGW+DefineHarbour+Define32bits)
                    VALUE           &("Gbl_T_P_"+DefineOohg3+DefineMinGW+DefineHarbour+Define32bits)
                    ROW             190
                    COL             120
                    WIDTH           561
            END TEXTBOX
            DEFINE BUTTON &("BP_"+DefineOohg3+DefineMinGW+DefineHarbour+Define32bits)
                    ROW             190
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder", WinGSettings.&("TP_"+DefineOohg3+DefineMinGW+DefineHarbour+Define32bits).Value ) ), WinGSettings.&("TP_"+DefineOohg3+DefineMinGW+DefineHarbour+Define32bits).Value := Folder, )
            END BUTTON
// Harbour Libs Folder
            DEFINE LABEL &("LP_LIBS_"+DefineOohg3+DefineMinGW+DefineHarbour+Define32bits)
                    ROW             220
                    COL             10
                    WIDTH           109
                    VALUE           '    Libs Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("TP_LIBS_"+DefineOohg3+DefineMinGW+DefineHarbour+Define32bits)
                    VALUE           &("Gbl_T_P_LIBS_"+DefineOohg3+DefineMinGW+DefineHarbour+Define32bits)
                    ROW             220
                    COL             120
                    WIDTH           561
                    TOOLTIP         "Full path to Harbour's libraries (usually subfolder 'lib' or 'lib\win\mingw' of Harbour Folder)"
            END TEXTBOX
            DEFINE BUTTON &("BP_LIBS_"+DefineOohg3+DefineMinGW+DefineHarbour+Define32bits)
                    ROW             220
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder", WinGSettings.&("TP_LIBS_"+DefineOohg3+DefineMinGW+DefineHarbour+Define32bits).Value ) ), WinGSettings.&("TP_LIBS_"+DefineOohg3+DefineMinGW+DefineHarbour+Define32bits).Value := Folder, )
            END BUTTON

         END PAGE

         // PAGE 16
         DEFINE PAGE "OOHG + MinGW + xHarbour, 32 bits"

            @ 40, 10 LABEL &("LDummy_"+DefineOohg3+DefineMinGW+DefineXHarbour+Define32bits) ;
               VALUE 'Folders for OOHG + MinGW + xHarbour, 32 bits:' ;
               WIDTH 601 ;
               FONT 'arial' SIZE 10 BOLD ;
               TRANSPARENT ;
               FONTCOLOR DEF_COLORBLUE

// Minigui Folder
            DEFINE LABEL &("LM_"+DefineOohg3+DefineMinGW+DefineXHarbour+Define32bits)
                    ROW             70
                    COL             10
                    WIDTH           109
                    VALUE           'OOHG Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("TM_"+DefineOohg3+DefineMinGW+DefineXHarbour+Define32bits)
                    VALUE           &("Gbl_T_M_"+DefineOohg3+DefineMinGW+DefineXHarbour+Define32bits)
                    ROW             70
                    COL             120
                    WIDTH           561
            END TEXTBOX
            DEFINE BUTTON &("BM_"+DefineOohg3+DefineMinGW+DefineXHarbour+Define32bits)
                    ROW             70
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder", WinGSettings.&("TM_"+DefineOohg3+DefineMinGW+DefineXHarbour+Define32bits).Value ) ), WinGSettings.&("TM_"+DefineOohg3+DefineMinGW+DefineXHarbour+Define32bits).Value := Folder, )
            END BUTTON
// Minigui Libs Folder
            DEFINE LABEL &("LM_LIBS_"+DefineOohg3+DefineMinGW+DefineXHarbour+Define32bits)
                    ROW             100
                    COL             10
                    WIDTH           109
                    VALUE           '    Libs Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("TM_LIBS_"+DefineOohg3+DefineMinGW+DefineXHarbour+Define32bits)
                    VALUE           &("Gbl_T_M_LIBS_"+DefineOohg3+DefineMinGW+DefineXHarbour+Define32bits)
                    ROW             100
                    COL             120
                    WIDTH           561
                    TOOLTIP         "Full path to OOHG's libraries (usually subfolder 'lib' of OOHG Folder)"
            END TEXTBOX
            DEFINE BUTTON &("BM_LIBS_"+DefineOohg3+DefineMinGW+DefineXHarbour+Define32bits)
                    ROW             100
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder", WinGSettings.&("TM_LIBS_"+DefineOohg3+DefineMinGW+DefineXHarbour+Define32bits).Value ) ), WinGSettings.&("TM_LIBS_"+DefineOohg3+DefineMinGW+DefineXHarbour+Define32bits).Value := Folder, )
            END BUTTON
// MinGW Folder
            DEFINE LABEL &("LC_"+DefineOohg3+DefineMinGW+DefineXHarbour+Define32bits)
                    ROW             130
                    COL             10
                    WIDTH           109
                    VALUE           'MinGW Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("TC_"+DefineOohg3+DefineMinGW+DefineXHarbour+Define32bits)
                    VALUE           &("Gbl_T_C_"+DefineOohg3+DefineMinGW+DefineXHarbour+Define32bits)
                    ROW             130
                    COL             120
                    WIDTH           561
            END TEXTBOX
            DEFINE BUTTON &("BC_"+DefineOohg3+DefineMinGW+DefineXHarbour+Define32bits)
                    ROW             130
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder", WinGSettings.&("TC_"+DefineOohg3+DefineMinGW+DefineXHarbour+Define32bits).Value ) ), WinGSettings.&("TC_"+DefineOohg3+DefineMinGW+DefineXHarbour+Define32bits).Value := Folder, )
            END BUTTON
// MinGW Libs Folder
            DEFINE LABEL &("LC_LIBS_"+DefineOohg3+DefineMinGW+DefineXHarbour+Define32bits)
                    ROW             160
                    COL             10
                    WIDTH           109
                    VALUE           '    Libs Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("TC_LIBS_"+DefineOohg3+DefineMinGW+DefineXHarbour+Define32bits)
                    VALUE           &("Gbl_T_C_LIBS_"+DefineOohg3+DefineMinGW+DefineXHarbour+Define32bits)
                    ROW             160
                    COL             120
                    WIDTH           561
                    TOOLTIP         "Full path to MinGW's libraries (usually subfolder 'lib' or 'i686-w64-mingw32\lib' of MinGW Folder)"
            END TEXTBOX
            DEFINE BUTTON &("BC_LIBS_"+DefineOohg3+DefineMinGW+DefineXHarbour+Define32bits)
                    ROW             160
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder", WinGSettings.&("TC_LIBS_"+DefineOohg3+DefineMinGW+DefineXHarbour+Define32bits).Value ) ), WinGSettings.&("TC_LIBS_"+DefineOohg3+DefineMinGW+DefineXHarbour+Define32bits).Value := Folder, )
            END BUTTON
// xHarbour Folder
            DEFINE LABEL &("LP_"+DefineOohg3+DefineMinGW+DefineXHarbour+Define32bits)
                    ROW             190
                    COL             10
                    WIDTH           109
                    VALUE           'xHarbour Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("TP_"+DefineOohg3+DefineMinGW+DefineXHarbour+Define32bits)
                    VALUE           &("Gbl_T_P_"+DefineOohg3+DefineMinGW+DefineXHarbour+Define32bits)
                    ROW             190
                    COL             120
                    WIDTH           561
            END TEXTBOX
            DEFINE BUTTON &("BP_"+DefineOohg3+DefineMinGW+DefineXHarbour+Define32bits)
                    ROW             190
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder", WinGSettings.&("TP_"+DefineOohg3+DefineMinGW+DefineXHarbour+Define32bits).Value ) ), WinGSettings.&("TP_"+DefineOohg3+DefineMinGW+DefineXHarbour+Define32bits).Value := Folder, )
            END BUTTON
// Harbour Libs Folder
            DEFINE LABEL &("LP_LIBS_"+DefineOohg3+DefineMinGW+DefineXHarbour+Define32bits)
                    ROW             220
                    COL             10
                    WIDTH           109
                    VALUE           '    Libs Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("TP_LIBS_"+DefineOohg3+DefineMinGW+DefineXHarbour+Define32bits)
                    VALUE           &("Gbl_T_P_LIBS_"+DefineOohg3+DefineMinGW+DefineXHarbour+Define32bits)
                    ROW             220
                    COL             120
                    WIDTH           561
                    TOOLTIP         "Full path to xHarbour's libraries (usually subfolder 'lib' or 'lib\win\mingw' of xHarbour Folder)"
            END TEXTBOX
            DEFINE BUTTON &("BP_LIBS_"+DefineOohg3+DefineMinGW+DefineXHarbour+Define32bits)
                    ROW             220
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder", WinGSettings.&("TP_LIBS_"+DefineOohg3+DefineMinGW+DefineXHarbour+Define32bits).Value ) ), WinGSettings.&("TP_LIBS_"+DefineOohg3+DefineMinGW+DefineXHarbour+Define32bits).Value := Folder, )
            END BUTTON

         END PAGE

         // PAGE 17
         DEFINE PAGE "OOHG + MinGW + Harbour, 64 bits"

            @ 40, 10 LABEL &("LDummy_"+DefineOohg3+DefineMinGW+DefineHarbour+Define64bits) ;
               VALUE 'Folders for OOHG + MinGW + Harbour, 64 bits:' ;
               WIDTH 601 ;
               FONT 'arial' SIZE 10 BOLD ;
               TRANSPARENT ;
               FONTCOLOR DEF_COLORBLUE

// Minigui Folder
            DEFINE LABEL &("LM_"+DefineOohg3+DefineMinGW+DefineHarbour+Define64bits)
                    ROW             70
                    COL             10
                    WIDTH           109
                    VALUE           'OOHG Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("TM_"+DefineOohg3+DefineMinGW+DefineHarbour+Define64bits)
                    VALUE           &("Gbl_T_M_"+DefineOohg3+DefineMinGW+DefineHarbour+Define64bits)
                    ROW             70
                    COL             120
                    WIDTH           561
            END TEXTBOX
            DEFINE BUTTON &("BM_"+DefineOohg3+DefineMinGW+DefineHarbour+Define64bits)
                    ROW             70
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder", WinGSettings.&("TM_"+DefineOohg3+DefineMinGW+DefineHarbour+Define64bits).Value ) ), WinGSettings.&("TM_"+DefineOohg3+DefineMinGW+DefineHarbour+Define64bits).Value := Folder, )
            END BUTTON
// Minigui Libs Folder
            DEFINE LABEL &("LM_LIBS_"+DefineOohg3+DefineMinGW+DefineHarbour+Define64bits)
                    ROW             100
                    COL             10
                    WIDTH           109
                    VALUE           '    Libs Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("TM_LIBS_"+DefineOohg3+DefineMinGW+DefineHarbour+Define64bits)
                    VALUE           &("Gbl_T_M_LIBS_"+DefineOohg3+DefineMinGW+DefineHarbour+Define64bits)
                    ROW             100
                    COL             120
                    WIDTH           561
                    TOOLTIP         "Full path to OOHG's libraries (usually subfolder 'lib' of OOHG Folder)"
            END TEXTBOX
            DEFINE BUTTON &("BM_LIBS_"+DefineOohg3+DefineMinGW+DefineHarbour+Define64bits)
                    ROW             100
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder", WinGSettings.&("TM_LIBS_"+DefineOohg3+DefineMinGW+DefineHarbour+Define64bits).Value ) ), WinGSettings.&("TM_LIBS_"+DefineOohg3+DefineMinGW+DefineHarbour+Define64bits).Value := Folder, )
            END BUTTON
// MinGW Folder
            DEFINE LABEL &("LC_"+DefineOohg3+DefineMinGW+DefineHarbour+Define64bits)
                    ROW             130
                    COL             10
                    WIDTH           109
                    VALUE           'MinGW Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("TC_"+DefineOohg3+DefineMinGW+DefineHarbour+Define64bits)
                    VALUE           &("Gbl_T_C_"+DefineOohg3+DefineMinGW+DefineHarbour+Define64bits)
                    ROW             130
                    COL             120
                    WIDTH           561
            END TEXTBOX
            DEFINE BUTTON &("BC_"+DefineOohg3+DefineMinGW+DefineHarbour+Define64bits)
                    ROW             130
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder", WinGSettings.&("TC_"+DefineOohg3+DefineMinGW+DefineHarbour+Define64bits).Value ) ), WinGSettings.&("TC_"+DefineOohg3+DefineMinGW+DefineHarbour+Define64bits).Value := Folder, )
            END BUTTON
// MinGW Libs Folder
            DEFINE LABEL &("LC_LIBS_"+DefineOohg3+DefineMinGW+DefineHarbour+Define64bits)
                    ROW             160
                    COL             10
                    WIDTH           109
                    VALUE           '    Libs Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("TC_LIBS_"+DefineOohg3+DefineMinGW+DefineHarbour+Define64bits)
                    VALUE           &("Gbl_T_C_LIBS_"+DefineOohg3+DefineMinGW+DefineHarbour+Define64bits)
                    ROW             160
                    COL             120
                    WIDTH           561
                    TOOLTIP         "Full path to MinGW's libraries (usually subfolder 'lib' or 'i686-w64-mingw32\lib' of MinGW Folder)"
            END TEXTBOX
            DEFINE BUTTON &("BC_LIBS_"+DefineOohg3+DefineMinGW+DefineHarbour+Define64bits)
                    ROW             160
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder", WinGSettings.&("TC_LIBS_"+DefineOohg3+DefineMinGW+DefineHarbour+Define64bits).Value ) ), WinGSettings.&("TC_LIBS_"+DefineOohg3+DefineMinGW+DefineHarbour+Define64bits).Value := Folder, )
            END BUTTON
// Harbour Folder
            DEFINE LABEL &("LP_"+DefineOohg3+DefineMinGW+DefineHarbour+Define64bits)
                    ROW             190
                    COL             10
                    WIDTH           109
                    VALUE           'Harbour Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("TP_"+DefineOohg3+DefineMinGW+DefineHarbour+Define64bits)
                    VALUE           &("Gbl_T_P_"+DefineOohg3+DefineMinGW+DefineHarbour+Define64bits)
                    ROW             190
                    COL             120
                    WIDTH           561
            END TEXTBOX
            DEFINE BUTTON &("BP_"+DefineOohg3+DefineMinGW+DefineHarbour+Define64bits)
                    ROW             190
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder", WinGSettings.&("TP_"+DefineOohg3+DefineMinGW+DefineHarbour+Define64bits).Value ) ), WinGSettings.&("TP_"+DefineOohg3+DefineMinGW+DefineHarbour+Define64bits).Value := Folder, )
            END BUTTON
// Harbour Libs Folder
            DEFINE LABEL &("LP_LIBS_"+DefineOohg3+DefineMinGW+DefineHarbour+Define64bits)
                    ROW             220
                    COL             10
                    WIDTH           109
                    VALUE           '    Libs Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("TP_LIBS_"+DefineOohg3+DefineMinGW+DefineHarbour+Define64bits)
                    VALUE           &("Gbl_T_P_LIBS_"+DefineOohg3+DefineMinGW+DefineHarbour+Define64bits)
                    ROW             220
                    COL             120
                    WIDTH           561
                    TOOLTIP         "Full path to Harbour's libraries (usually subfolder 'lib' or 'lib\win\mingw' of Harbour Folder)"
            END TEXTBOX
            DEFINE BUTTON &("BP_LIBS_"+DefineOohg3+DefineMinGW+DefineHarbour+Define64bits)
                    ROW             220
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder", WinGSettings.&("TP_LIBS_"+DefineOohg3+DefineMinGW+DefineHarbour+Define64bits).Value ) ), WinGSettings.&("TP_LIBS_"+DefineOohg3+DefineMinGW+DefineHarbour+Define64bits).Value := Folder, )
            END BUTTON

         END PAGE

         // PAGE 18
         DEFINE PAGE "OOHG + MinGW + xHarbour, 64 bits"

            @ 40, 10 LABEL &("LDummy_"+DefineOohg3+DefineMinGW+DefineXHarbour+Define64bits) ;
               VALUE 'Folders for OOHG + MinGW + xHarbour, 64 bits:' ;
               WIDTH 601 ;
               FONT 'arial' SIZE 10 BOLD ;
               TRANSPARENT ;
               FONTCOLOR DEF_COLORBLUE

// Minigui Folder
            DEFINE LABEL &("LM_"+DefineOohg3+DefineMinGW+DefineXHarbour+Define64bits)
                    ROW             70
                    COL             10
                    WIDTH           109
                    VALUE           'OOHG Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("TM_"+DefineOohg3+DefineMinGW+DefineXHarbour+Define64bits)
                    VALUE           &("Gbl_T_M_"+DefineOohg3+DefineMinGW+DefineXHarbour+Define64bits)
                    ROW             70
                    COL             120
                    WIDTH           561
            END TEXTBOX
            DEFINE BUTTON &("BM_"+DefineOohg3+DefineMinGW+DefineXHarbour+Define64bits)
                    ROW             70
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder", WinGSettings.&("TM_"+DefineOohg3+DefineMinGW+DefineXHarbour+Define64bits).Value ) ), WinGSettings.&("TM_"+DefineOohg3+DefineMinGW+DefineXHarbour+Define64bits).Value := Folder, )
            END BUTTON
// Minigui Libs Folder
            DEFINE LABEL &("LM_LIBS_"+DefineOohg3+DefineMinGW+DefineXHarbour+Define64bits)
                    ROW             100
                    COL             10
                    WIDTH           109
                    VALUE           '    Libs Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("TM_LIBS_"+DefineOohg3+DefineMinGW+DefineXHarbour+Define64bits)
                    VALUE           &("Gbl_T_M_LIBS_"+DefineOohg3+DefineMinGW+DefineXHarbour+Define64bits)
                    ROW             100
                    COL             120
                    WIDTH           561
                    TOOLTIP         "Full path to OOHG's libraries (usually subfolder 'lib' of OOHG Folder)"
            END TEXTBOX
            DEFINE BUTTON &("BM_LIBS_"+DefineOohg3+DefineMinGW+DefineXHarbour+Define64bits)
                    ROW             100
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder", WinGSettings.&("TM_LIBS_"+DefineOohg3+DefineMinGW+DefineXHarbour+Define64bits).Value ) ), WinGSettings.&("TM_LIBS_"+DefineOohg3+DefineMinGW+DefineXHarbour+Define64bits).Value := Folder, )
            END BUTTON
// MinGW Folder
            DEFINE LABEL &("LC_"+DefineOohg3+DefineMinGW+DefineXHarbour+Define64bits)
                    ROW             130
                    COL             10
                    WIDTH           109
                    VALUE           'MinGW Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("TC_"+DefineOohg3+DefineMinGW+DefineXHarbour+Define64bits)
                    VALUE           &("Gbl_T_C_"+DefineOohg3+DefineMinGW+DefineXHarbour+Define64bits)
                    ROW             130
                    COL             120
                    WIDTH           561
            END TEXTBOX
            DEFINE BUTTON &("BC_"+DefineOohg3+DefineMinGW+DefineXHarbour+Define64bits)
                    ROW             130
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder", WinGSettings.&("TC_"+DefineOohg3+DefineMinGW+DefineXHarbour+Define64bits).Value ) ), WinGSettings.&("TC_"+DefineOohg3+DefineMinGW+DefineXHarbour+Define64bits).Value := Folder, )
            END BUTTON
// MinGW Libs Folder
            DEFINE LABEL &("LC_LIBS_"+DefineOohg3+DefineMinGW+DefineXHarbour+Define64bits)
                    ROW             160
                    COL             10
                    WIDTH           109
                    VALUE           '    Libs Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("TC_LIBS_"+DefineOohg3+DefineMinGW+DefineXHarbour+Define64bits)
                    VALUE           &("Gbl_T_C_LIBS_"+DefineOohg3+DefineMinGW+DefineXHarbour+Define64bits)
                    ROW             160
                    COL             120
                    WIDTH           561
                    TOOLTIP         "Full path to MinGW's libraries (usually subfolder 'lib' or 'i686-w64-mingw32\lib' of MinGW Folder)"
            END TEXTBOX
            DEFINE BUTTON &("BC_LIBS_"+DefineOohg3+DefineMinGW+DefineXHarbour+Define64bits)
                    ROW             160
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder", WinGSettings.&("TC_LIBS_"+DefineOohg3+DefineMinGW+DefineXHarbour+Define64bits).Value ) ), WinGSettings.&("TC_LIBS_"+DefineOohg3+DefineMinGW+DefineXHarbour+Define64bits).Value := Folder, )
            END BUTTON
// xHarbour Folder
            DEFINE LABEL &("LP_"+DefineOohg3+DefineMinGW+DefineXHarbour+Define64bits)
                    ROW             190
                    COL             10
                    WIDTH           109
                    VALUE           'xHarbour Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("TP_"+DefineOohg3+DefineMinGW+DefineXHarbour+Define64bits)
                    VALUE           &("Gbl_T_P_"+DefineOohg3+DefineMinGW+DefineXHarbour+Define64bits)
                    ROW             190
                    COL             120
                    WIDTH           561
            END TEXTBOX
            DEFINE BUTTON &("BP_"+DefineOohg3+DefineMinGW+DefineXHarbour+Define64bits)
                    ROW             190
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder", WinGSettings.&("TP_"+DefineOohg3+DefineMinGW+DefineXHarbour+Define64bits).Value ) ), WinGSettings.&("TP_"+DefineOohg3+DefineMinGW+DefineXHarbour+Define64bits).Value := Folder, )
            END BUTTON
// Harbour Libs Folder
            DEFINE LABEL &("LP_LIBS_"+DefineOohg3+DefineMinGW+DefineXHarbour+Define64bits)
                    ROW             220
                    COL             10
                    WIDTH           109
                    VALUE           '    Libs Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("TP_LIBS_"+DefineOohg3+DefineMinGW+DefineXHarbour+Define64bits)
                    VALUE           &("Gbl_T_P_LIBS_"+DefineOohg3+DefineMinGW+DefineXHarbour+Define64bits)
                    ROW             220
                    COL             120
                    WIDTH           561
                    TOOLTIP         "Full path to xHarbour's libraries (usually subfolder 'lib' or 'lib\win\mingw' of xHarbour Folder)"
            END TEXTBOX
            DEFINE BUTTON &("BP_LIBS_"+DefineOohg3+DefineMinGW+DefineXHarbour+Define64bits)
                    ROW             220
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder", WinGSettings.&("TP_LIBS_"+DefineOohg3+DefineMinGW+DefineXHarbour+Define64bits).Value ) ), WinGSettings.&("TP_LIBS_"+DefineOohg3+DefineMinGW+DefineXHarbour+Define64bits).Value := Folder, )
            END BUTTON

         END PAGE

         // PAGE 19
         DEFINE PAGE "OOHG + Pelles C + Harbour, 32 bits"

            @ 40, 10 LABEL &("LDummy_"+DefineOohg3+DefinePelles+DefineHarbour+Define32bits) ;
               VALUE 'Folders for OOHG + Pelles C + Harbour, 32 bits:' ;
               WIDTH 601 ;
               FONT 'arial' SIZE 10 BOLD ;
               TRANSPARENT ;
               FONTCOLOR DEF_COLORBLUE

// Minigui Folder
            DEFINE LABEL &("LM_"+DefineOohg3+DefinePelles+DefineHarbour+Define32bits)
                    ROW             70
                    COL             10
                    WIDTH           109
                    VALUE           'OOHG Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("TM_"+DefineOohg3+DefinePelles+DefineHarbour+Define32bits)
                    VALUE           &("Gbl_T_M_"+DefineOohg3+DefinePelles+DefineHarbour+Define32bits)
                    ROW             70
                    COL             120
                    WIDTH           561
            END TEXTBOX
            DEFINE BUTTON &("BM_"+DefineOohg3+DefinePelles+DefineHarbour+Define32bits)
                    ROW             70
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder", WinGSettings.&("TM_"+DefineOohg3+DefinePelles+DefineHarbour+Define32bits).Value ) ), WinGSettings.&("TM_"+DefineOohg3+DefinePelles+DefineHarbour+Define32bits).Value := Folder, )
            END BUTTON
// Minigui Libs Folder
            DEFINE LABEL &("LM_LIBS_"+DefineOohg3+DefinePelles+DefineHarbour+Define32bits)
                    ROW             100
                    COL             10
                    WIDTH           109
                    VALUE           '    Libs Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("TM_LIBS_"+DefineOohg3+DefinePelles+DefineHarbour+Define32bits)
                    VALUE           &("Gbl_T_M_LIBS_"+DefineOohg3+DefinePelles+DefineHarbour+Define32bits)
                    ROW             100
                    COL             120
                    WIDTH           561
                    TOOLTIP         "Full path to OOHG's libraries (usually subfolder 'lib' of OOHG Folder)"
            END TEXTBOX
            DEFINE BUTTON &("BM_LIBS_"+DefineOohg3+DefinePelles+DefineHarbour+Define32bits)
                    ROW             100
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder", WinGSettings.&("TM_LIBS_"+DefineOohg3+DefinePelles+DefineHarbour+Define32bits).Value ) ), WinGSettings.&("TM_LIBS_"+DefineOohg3+DefinePelles+DefineHarbour+Define32bits).Value := Folder, )
            END BUTTON
// Pelles Folder
            DEFINE LABEL &("LC_"+DefineOohg3+DefinePelles+DefineHarbour+Define32bits)
                    ROW             130
                    COL             10
                    WIDTH           109
                    VALUE           'Pelles Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("TC_"+DefineOohg3+DefinePelles+DefineHarbour+Define32bits)
                    VALUE           &("Gbl_T_C_"+DefineOohg3+DefinePelles+DefineHarbour+Define32bits)
                    ROW             130
                    COL             120
                    WIDTH           561
            END TEXTBOX
            DEFINE BUTTON &("BC_"+DefineOohg3+DefinePelles+DefineHarbour+Define32bits)
                    ROW             130
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder", WinGSettings.&("TC_"+DefineOohg3+DefinePelles+DefineHarbour+Define32bits).Value ) ), WinGSettings.&("TC_"+DefineOohg3+DefinePelles+DefineHarbour+Define32bits).Value := Folder, )
            END BUTTON
// Pelles Libs Folder
            DEFINE LABEL &("LC_LIBS_"+DefineOohg3+DefinePelles+DefineHarbour+Define32bits)
                    ROW             160
                    COL             10
                    WIDTH           109
                    VALUE           '    Libs Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("TC_LIBS_"+DefineOohg3+DefinePelles+DefineHarbour+Define32bits)
                    VALUE           &("Gbl_T_C_LIBS_"+DefineOohg3+DefinePelles+DefineHarbour+Define32bits)
                    ROW             160
                    COL             120
                    WIDTH           561
                    TOOLTIP         "Full path to Pelles's libraries (usually subfolder 'lib' of Pelles Folder)"
            END TEXTBOX
            DEFINE BUTTON &("BC_LIBS_"+DefineOohg3+DefinePelles+DefineHarbour+Define32bits)
                    ROW             160
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder", WinGSettings.&("TC_LIBS_"+DefineOohg3+DefinePelles+DefineHarbour+Define32bits).Value ) ), WinGSettings.&("TC_LIBS_"+DefineOohg3+DefinePelles+DefineHarbour+Define32bits).Value := Folder, )
            END BUTTON
// Harbour Folder
            DEFINE LABEL &("LP_"+DefineOohg3+DefinePelles+DefineHarbour+Define32bits)
                    ROW             190
                    COL             10
                    WIDTH           109
                    VALUE           'Harbour Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("TP_"+DefineOohg3+DefinePelles+DefineHarbour+Define32bits)
                    VALUE           &("Gbl_T_P_"+DefineOohg3+DefinePelles+DefineHarbour+Define32bits)
                    ROW             190
                    COL             120
                    WIDTH           561
            END TEXTBOX
            DEFINE BUTTON &("BP_"+DefineOohg3+DefinePelles+DefineHarbour+Define32bits)
                    ROW             190
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder", WinGSettings.&("TP_"+DefineOohg3+DefinePelles+DefineHarbour+Define32bits).Value ) ), WinGSettings.&("TP_"+DefineOohg3+DefinePelles+DefineHarbour+Define32bits).Value := Folder, )
            END BUTTON
// Harbour Libs Folder
            DEFINE LABEL &("LP_LIBS_"+DefineOohg3+DefinePelles+DefineHarbour+Define32bits)
                    ROW             220
                    COL             10
                    WIDTH           109
                    VALUE           '    Libs Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("TP_LIBS_"+DefineOohg3+DefinePelles+DefineHarbour+Define32bits)
                    VALUE           &("Gbl_T_P_LIBS_"+DefineOohg3+DefinePelles+DefineHarbour+Define32bits)
                    ROW             220
                    COL             120
                    WIDTH           561
                    TOOLTIP         "Full path to Harbour's libraries (usually subfolder 'lib' of Harbour Folder)"
            END TEXTBOX
            DEFINE BUTTON &("BP_LIBS_"+DefineOohg3+DefinePelles+DefineHarbour+Define32bits)
                    ROW             220
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder", WinGSettings.&("TP_LIBS_"+DefineOohg3+DefinePelles+DefineHarbour+Define32bits).Value ) ), WinGSettings.&("TP_LIBS_"+DefineOohg3+DefinePelles+DefineHarbour+Define32bits).Value := Folder, )
            END BUTTON

         END PAGE

         // PAGE 20
         DEFINE PAGE "OOHG + Pelles C + xHarbour, 32 bits"

            @ 40, 10 LABEL &("LDummy_"+DefineOohg3+DefinePelles+DefineXHarbour+Define32bits) ;
               VALUE 'Folders for OOHG + Pelles C + xHarbour, 32 bits:' ;
               WIDTH 601 ;
               FONT 'arial' SIZE 10 BOLD ;
               TRANSPARENT ;
               FONTCOLOR DEF_COLORBLUE

// Minigui Folder
            DEFINE LABEL &("LM_"+DefineOohg3+DefinePelles+DefineXHarbour+Define32bits)
                    ROW             70
                    COL             10
                    WIDTH           109
                    VALUE           'OOHG Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("TM_"+DefineOohg3+DefinePelles+DefineXHarbour+Define32bits)
                    VALUE           &("Gbl_T_M_"+DefineOohg3+DefinePelles+DefineXHarbour+Define32bits)
                    ROW             70
                    COL             120
                    WIDTH           561
            END TEXTBOX
            DEFINE BUTTON &("BM_"+DefineOohg3+DefinePelles+DefineXHarbour+Define32bits)
                    ROW             70
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder", WinGSettings.&("TM_"+DefineOohg3+DefinePelles+DefineXHarbour+Define32bits).Value ) ), WinGSettings.&("TM_"+DefineOohg3+DefinePelles+DefineXHarbour+Define32bits).Value := Folder, )
            END BUTTON
// Minigui Libs Folder
            DEFINE LABEL &("LM_LIBS_"+DefineOohg3+DefinePelles+DefineXHarbour+Define32bits)
                    ROW             100
                    COL             10
                    WIDTH           109
                    VALUE           '    Libs Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("TM_LIBS_"+DefineOohg3+DefinePelles+DefineXHarbour+Define32bits)
                    VALUE           &("Gbl_T_M_LIBS_"+DefineOohg3+DefinePelles+DefineXHarbour+Define32bits)
                    ROW             100
                    COL             120
                    WIDTH           561
                    TOOLTIP         "Full path to OOHG's libraries (usually subfolder 'lib' of OOHG Folder)"
            END TEXTBOX
            DEFINE BUTTON &("BM_LIBS_"+DefineOohg3+DefinePelles+DefineXHarbour+Define32bits)
                    ROW             100
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder", WinGSettings.&("TM_LIBS_"+DefineOohg3+DefinePelles+DefineXHarbour+Define32bits).Value ) ), WinGSettings.&("TM_LIBS_"+DefineOohg3+DefinePelles+DefineXHarbour+Define32bits).Value := Folder, )
            END BUTTON
// Pelles Folder
            DEFINE LABEL &("LC_"+DefineOohg3+DefinePelles+DefineXHarbour+Define32bits)
                    ROW             130
                    COL             10
                    WIDTH           109
                    VALUE           'Pelles Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("TC_"+DefineOohg3+DefinePelles+DefineXHarbour+Define32bits)
                    VALUE           &("Gbl_T_C_"+DefineOohg3+DefinePelles+DefineXHarbour+Define32bits)
                    ROW             130
                    COL             120
                    WIDTH           561
            END TEXTBOX
            DEFINE BUTTON &("BC_"+DefineOohg3+DefinePelles+DefineXHarbour+Define32bits)
                    ROW             130
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder", WinGSettings.&("TC_"+DefineOohg3+DefinePelles+DefineXHarbour+Define32bits).Value ) ), WinGSettings.&("TC_"+DefineOohg3+DefinePelles+DefineXHarbour+Define32bits).Value := Folder, )
            END BUTTON
// Pelles Libs Folder
            DEFINE LABEL &("LC_LIBS_"+DefineOohg3+DefinePelles+DefineXHarbour+Define32bits)
                    ROW             160
                    COL             10
                    WIDTH           109
                    VALUE           '    Libs Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("TC_LIBS_"+DefineOohg3+DefinePelles+DefineXHarbour+Define32bits)
                    VALUE           &("Gbl_T_C_LIBS_"+DefineOohg3+DefinePelles+DefineXHarbour+Define32bits)
                    ROW             160
                    COL             120
                    WIDTH           561
                    TOOLTIP         "Full path to Pelles's libraries (usually subfolder 'lib' of Pelles Folder)"
            END TEXTBOX
            DEFINE BUTTON &("BC_LIBS_"+DefineOohg3+DefinePelles+DefineXHarbour+Define32bits)
                    ROW             160
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder", WinGSettings.&("TC_LIBS_"+DefineOohg3+DefinePelles+DefineXHarbour+Define32bits).Value ) ), WinGSettings.&("TC_LIBS_"+DefineOohg3+DefinePelles+DefineXHarbour+Define32bits).Value := Folder, )
            END BUTTON
// xHarbour Folder
            DEFINE LABEL &("LP_"+DefineOohg3+DefinePelles+DefineXHarbour+Define32bits)
                    ROW             190
                    COL             10
                    WIDTH           109
                    VALUE           'xHarbour Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("TP_"+DefineOohg3+DefinePelles+DefineXHarbour+Define32bits)
                    VALUE           &("Gbl_T_P_"+DefineOohg3+DefinePelles+DefineXHarbour+Define32bits)
                    ROW             190
                    COL             120
                    WIDTH           561
            END TEXTBOX
            DEFINE BUTTON &("BP_"+DefineOohg3+DefinePelles+DefineXHarbour+Define32bits)
                    ROW             190
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder", WinGSettings.&("TP_"+DefineOohg3+DefinePelles+DefineXHarbour+Define32bits).Value ) ), WinGSettings.&("TP_"+DefineOohg3+DefinePelles+DefineXHarbour+Define32bits).Value := Folder, )
            END BUTTON
// xHarbour Libs Folder
            DEFINE LABEL &("LP_LIBS_"+DefineOohg3+DefinePelles+DefineXHarbour+Define32bits)
                    ROW             220
                    COL             10
                    WIDTH           109
                    VALUE           '    Libs Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("TP_LIBS_"+DefineOohg3+DefinePelles+DefineXHarbour+Define32bits)
                    VALUE           &("Gbl_T_P_LIBS_"+DefineOohg3+DefinePelles+DefineXHarbour+Define32bits)
                    ROW             220
                    COL             120
                    WIDTH           561
                    TOOLTIP         "Full path to xHarbour's libraries (usually subfolder 'lib' of xHarbour Folder)"
            END TEXTBOX
            DEFINE BUTTON &("BP_LIBS_"+DefineOohg3+DefinePelles+DefineXHarbour+Define32bits)
                    ROW             220
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder", WinGSettings.&("TP_LIBS_"+DefineOohg3+DefinePelles+DefineXHarbour+Define32bits).Value ) ), WinGSettings.&("TP_LIBS_"+DefineOohg3+DefinePelles+DefineXHarbour+Define32bits).Value := Folder, )
            END BUTTON

         END PAGE

         // PAGE 21
         DEFINE PAGE "OOHG + Pelles C + Harbour, 64 bits"

            @ 40, 10 LABEL &("LDummy_"+DefineOohg3+DefinePelles+DefineHarbour+Define64bits) ;
               VALUE 'Folders for OOHG + Pelles C + Harbour, 64 bits:' ;
               WIDTH 601 ;
               FONT 'arial' SIZE 10 BOLD ;
               TRANSPARENT ;
               FONTCOLOR DEF_COLORBLUE

// Minigui Folder
            DEFINE LABEL &("LM_"+DefineOohg3+DefinePelles+DefineHarbour+Define64bits)
                    ROW             70
                    COL             10
                    WIDTH           109
                    VALUE           'OOHG Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("TM_"+DefineOohg3+DefinePelles+DefineHarbour+Define64bits)
                    VALUE           &("Gbl_T_M_"+DefineOohg3+DefinePelles+DefineHarbour+Define64bits)
                    ROW             70
                    COL             120
                    WIDTH           561
            END TEXTBOX
            DEFINE BUTTON &("BM_"+DefineOohg3+DefinePelles+DefineHarbour+Define64bits)
                    ROW             70
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder", WinGSettings.&("TM_"+DefineOohg3+DefinePelles+DefineHarbour+Define64bits).Value ) ), WinGSettings.&("TM_"+DefineOohg3+DefinePelles+DefineHarbour+Define64bits).Value := Folder, )
            END BUTTON
// Minigui Libs Folder
            DEFINE LABEL &("LM_LIBS_"+DefineOohg3+DefinePelles+DefineHarbour+Define64bits)
                    ROW             100
                    COL             10
                    WIDTH           109
                    VALUE           '    Libs Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("TM_LIBS_"+DefineOohg3+DefinePelles+DefineHarbour+Define64bits)
                    VALUE           &("Gbl_T_M_LIBS_"+DefineOohg3+DefinePelles+DefineHarbour+Define64bits)
                    ROW             100
                    COL             120
                    WIDTH           561
                    TOOLTIP         "Full path to OOHG's libraries (usually subfolder 'lib' of OOHG Folder)"
            END TEXTBOX
            DEFINE BUTTON &("BM_LIBS_"+DefineOohg3+DefinePelles+DefineHarbour+Define64bits)
                    ROW             100
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder", WinGSettings.&("TM_LIBS_"+DefineOohg3+DefinePelles+DefineHarbour+Define64bits).Value ) ), WinGSettings.&("TM_LIBS_"+DefineOohg3+DefinePelles+DefineHarbour+Define64bits).Value := Folder, )
            END BUTTON
// Pelles Folder
            DEFINE LABEL &("LC_"+DefineOohg3+DefinePelles+DefineHarbour+Define64bits)
                    ROW             130
                    COL             10
                    WIDTH           109
                    VALUE           'Pelles Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("TC_"+DefineOohg3+DefinePelles+DefineHarbour+Define64bits)
                    VALUE           &("Gbl_T_C_"+DefineOohg3+DefinePelles+DefineHarbour+Define64bits)
                    ROW             130
                    COL             120
                    WIDTH           561
            END TEXTBOX
            DEFINE BUTTON &("BC_"+DefineOohg3+DefinePelles+DefineHarbour+Define64bits)
                    ROW             130
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder", WinGSettings.&("TC_"+DefineOohg3+DefinePelles+DefineHarbour+Define64bits).Value ) ), WinGSettings.&("TC_"+DefineOohg3+DefinePelles+DefineHarbour+Define64bits).Value := Folder, )
            END BUTTON
// Pelles Libs Folder
            DEFINE LABEL &("LC_LIBS_"+DefineOohg3+DefinePelles+DefineHarbour+Define64bits)
                    ROW             160
                    COL             10
                    WIDTH           109
                    VALUE           '    Libs Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("TC_LIBS_"+DefineOohg3+DefinePelles+DefineHarbour+Define64bits)
                    VALUE           &("Gbl_T_C_LIBS_"+DefineOohg3+DefinePelles+DefineHarbour+Define64bits)
                    ROW             160
                    COL             120
                    WIDTH           561
                    TOOLTIP         "Full path to Pelles's libraries (usually subfolder 'lib' of Pelles Folder)"
            END TEXTBOX
            DEFINE BUTTON &("BC_LIBS_"+DefineOohg3+DefinePelles+DefineHarbour+Define64bits)
                    ROW             160
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder", WinGSettings.&("TC_LIBS_"+DefineOohg3+DefinePelles+DefineHarbour+Define64bits).Value ) ), WinGSettings.&("TC_LIBS_"+DefineOohg3+DefinePelles+DefineHarbour+Define64bits).Value := Folder, )
            END BUTTON
// Harbour Folder
            DEFINE LABEL &("LP_"+DefineOohg3+DefinePelles+DefineHarbour+Define64bits)
                    ROW             190
                    COL             10
                    WIDTH           109
                    VALUE           'Harbour Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("TP_"+DefineOohg3+DefinePelles+DefineHarbour+Define64bits)
                    VALUE           &("Gbl_T_P_"+DefineOohg3+DefinePelles+DefineHarbour+Define64bits)
                    ROW             190
                    COL             120
                    WIDTH           561
            END TEXTBOX
            DEFINE BUTTON &("BP_"+DefineOohg3+DefinePelles+DefineHarbour+Define64bits)
                    ROW             190
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder", WinGSettings.&("TP_"+DefineOohg3+DefinePelles+DefineHarbour+Define64bits).Value ) ), WinGSettings.&("TP_"+DefineOohg3+DefinePelles+DefineHarbour+Define64bits).Value := Folder, )
            END BUTTON
// Harbour Libs Folder
            DEFINE LABEL &("LP_LIBS_"+DefineOohg3+DefinePelles+DefineHarbour+Define64bits)
                    ROW             220
                    COL             10
                    WIDTH           109
                    VALUE           '    Libs Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("TP_LIBS_"+DefineOohg3+DefinePelles+DefineHarbour+Define64bits)
                    VALUE           &("Gbl_T_P_LIBS_"+DefineOohg3+DefinePelles+DefineHarbour+Define64bits)
                    ROW             220
                    COL             120
                    WIDTH           561
                    TOOLTIP         "Full path to Harbour's libraries (usually subfolder 'lib' of Harbour Folder)"
            END TEXTBOX
            DEFINE BUTTON &("BP_LIBS_"+DefineOohg3+DefinePelles+DefineHarbour+Define64bits)
                    ROW             220
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder", WinGSettings.&("TP_LIBS_"+DefineOohg3+DefinePelles+DefineHarbour+Define64bits).Value ) ), WinGSettings.&("TP_LIBS_"+DefineOohg3+DefinePelles+DefineHarbour+Define64bits).Value := Folder, )
            END BUTTON

         END PAGE

         // PAGE 22
         DEFINE PAGE "OOHG + Pelles C + xHarbour, 64 bits"

            @ 40, 10 LABEL &("LDummy_"+DefineOohg3+DefinePelles+DefineXHarbour+Define64bits) ;
               VALUE 'Folders for OOHG + Pelles C + xHarbour, 64 bits:' ;
               WIDTH 601 ;
               FONT 'arial' SIZE 10 BOLD ;
               TRANSPARENT ;
               FONTCOLOR DEF_COLORBLUE

// Minigui Folder
            DEFINE LABEL &("LM_"+DefineOohg3+DefinePelles+DefineXHarbour+Define64bits)
                    ROW             70
                    COL             10
                    WIDTH           109
                    VALUE           'OOHG Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("TM_"+DefineOohg3+DefinePelles+DefineXHarbour+Define64bits)
                    VALUE           &("Gbl_T_M_"+DefineOohg3+DefinePelles+DefineXHarbour+Define64bits)
                    ROW             70
                    COL             120
                    WIDTH           561
            END TEXTBOX
            DEFINE BUTTON &("BM_"+DefineOohg3+DefinePelles+DefineXHarbour+Define64bits)
                    ROW             70
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder", WinGSettings.&("TM_"+DefineOohg3+DefinePelles+DefineXHarbour+Define64bits).Value ) ), WinGSettings.&("TM_"+DefineOohg3+DefinePelles+DefineXHarbour+Define64bits).Value := Folder, )
            END BUTTON
// Minigui Libs Folder
            DEFINE LABEL &("LM_LIBS_"+DefineOohg3+DefinePelles+DefineXHarbour+Define64bits)
                    ROW             100
                    COL             10
                    WIDTH           109
                    VALUE           '    Libs Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("TM_LIBS_"+DefineOohg3+DefinePelles+DefineXHarbour+Define64bits)
                    VALUE           &("Gbl_T_M_LIBS_"+DefineOohg3+DefinePelles+DefineXHarbour+Define64bits)
                    ROW             100
                    COL             120
                    WIDTH           561
                    TOOLTIP         "Full path to OOHG's libraries (usually subfolder 'lib' of OOHG Folder)"
            END TEXTBOX
            DEFINE BUTTON &("BM_LIBS_"+DefineOohg3+DefinePelles+DefineXHarbour+Define64bits)
                    ROW             100
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder", WinGSettings.&("TM_LIBS_"+DefineOohg3+DefinePelles+DefineXHarbour+Define64bits).Value ) ), WinGSettings.&("TM_LIBS_"+DefineOohg3+DefinePelles+DefineXHarbour+Define64bits).Value := Folder, )
            END BUTTON
// Pelles Folder
            DEFINE LABEL &("LC_"+DefineOohg3+DefinePelles+DefineXHarbour+Define64bits)
                    ROW             130
                    COL             10
                    WIDTH           109
                    VALUE           'Pelles Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("TC_"+DefineOohg3+DefinePelles+DefineXHarbour+Define64bits)
                    VALUE           &("Gbl_T_C_"+DefineOohg3+DefinePelles+DefineXHarbour+Define64bits)
                    ROW             130
                    COL             120
                    WIDTH           561
            END TEXTBOX
            DEFINE BUTTON &("BC_"+DefineOohg3+DefinePelles+DefineXHarbour+Define64bits)
                    ROW             130
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder", WinGSettings.&("TC_"+DefineOohg3+DefinePelles+DefineXHarbour+Define64bits).Value ) ), WinGSettings.&("TC_"+DefineOohg3+DefinePelles+DefineXHarbour+Define64bits).Value := Folder, )
            END BUTTON
// Pelles Libs Folder
            DEFINE LABEL &("LC_LIBS_"+DefineOohg3+DefinePelles+DefineXHarbour+Define64bits)
                    ROW             160
                    COL             10
                    WIDTH           109
                    VALUE           '    Libs Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("TC_LIBS_"+DefineOohg3+DefinePelles+DefineXHarbour+Define64bits)
                    VALUE           &("Gbl_T_C_LIBS_"+DefineOohg3+DefinePelles+DefineXHarbour+Define64bits)
                    ROW             160
                    COL             120
                    WIDTH           561
                    TOOLTIP         "Full path to Pelles's libraries (usually subfolder 'lib' of Pelles Folder)"
            END TEXTBOX
            DEFINE BUTTON &("BC_LIBS_"+DefineOohg3+DefinePelles+DefineXHarbour+Define64bits)
                    ROW             160
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder", WinGSettings.&("TC_LIBS_"+DefineOohg3+DefinePelles+DefineXHarbour+Define64bits).Value ) ), WinGSettings.&("TC_LIBS_"+DefineOohg3+DefinePelles+DefineXHarbour+Define64bits).Value := Folder, )
            END BUTTON
// xHarbour Folder
            DEFINE LABEL &("LP_"+DefineOohg3+DefinePelles+DefineXHarbour+Define64bits)
                    ROW             190
                    COL             10
                    WIDTH           109
                    VALUE           'xHarbour Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("TP_"+DefineOohg3+DefinePelles+DefineXHarbour+Define64bits)
                    VALUE           &("Gbl_T_P_"+DefineOohg3+DefinePelles+DefineXHarbour+Define64bits)
                    ROW             190
                    COL             120
                    WIDTH           561
            END TEXTBOX
            DEFINE BUTTON &("BP_"+DefineOohg3+DefinePelles+DefineXHarbour+Define64bits)
                    ROW             190
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder", WinGSettings.&("TP_"+DefineOohg3+DefinePelles+DefineXHarbour+Define64bits).Value ) ), WinGSettings.&("TP_"+DefineOohg3+DefinePelles+DefineXHarbour+Define64bits).Value := Folder, )
            END BUTTON
// xHarbour Libs Folder
            DEFINE LABEL &("LP_LIBS_"+DefineOohg3+DefinePelles+DefineXHarbour+Define64bits)
                    ROW             220
                    COL             10
                    WIDTH           109
                    VALUE           '    Libs Folder:'
                    TRANSPARENT     .T.
            END LABEL
            DEFINE TEXTBOX &("TP_LIBS_"+DefineOohg3+DefinePelles+DefineXHarbour+Define64bits)
                    VALUE           &("Gbl_T_P_LIBS_"+DefineOohg3+DefinePelles+DefineXHarbour+Define64bits)
                    ROW             220
                    COL             120
                    WIDTH           561
                    TOOLTIP         "Full path to xHarbour's libraries (usually subfolder 'lib' of xHarbour Folder)"
            END TEXTBOX
            DEFINE BUTTON &("BP_LIBS_"+DefineOohg3+DefinePelles+DefineXHarbour+Define64bits)
                    ROW             220
                    COL             691
                    WIDTH           25
                    HEIGHT          25
                    PICTURE         'folderselect'
                    TOOLTIP         'Select folder'
                    ONCLICK         If ( !Empty( Folder := GetFolder( "Select folder", WinGSettings.&("TP_LIBS_"+DefineOohg3+DefinePelles+DefineXHarbour+Define64bits).Value ) ), WinGSettings.&("TP_LIBS_"+DefineOohg3+DefinePelles+DefineXHarbour+Define64bits).Value := Folder, )
            END BUTTON

         END PAGE

      END TAB

      DEFINE BUTTON B_OK
             ROW             370
             COL             396
             WIDTH           100
             HEIGHT          25
             CAPTION         'Apply'
             TOOLTIP         "Apply changes and save to configuration file."
             ONCLICK         ( GlobalSettingsSave( .T. ), WinGSettings.Release() )
      END BUTTON

      DEFINE BUTTON B_EXPORT
             ROW             370
             COL             506
             WIDTH           100
             HEIGHT          25
             CAPTION         'Export'
             TOOLTIP         'Apply changes, save to chosen file and to configuration file.'
             ONCLICK         ( GlobalSettingsSave( .F. ), WinGSettings.Release() )
      END BUTTON

      DEFINE BUTTON B_CANCEL
             ROW             370
             COL             616
             WIDTH           100
             HEIGHT          25
             CAPTION         'Cancel'
             TOOLTIP         'Discard changes.'
             ONCLICK         WinGSettings.Release()
      END BUTTON

   END WINDOW

   ON KEY ESCAPE OF WinGSettings ACTION GlobalEscape()

   CENTER   WINDOW WinGSettings

   ACTIVATE WINDOW WinGSettings

Return .T.

FUNCTION FormToolCheck( tool )
   LOCAL FileName
   DO CASE
   CASE tool == 'HMI'
      IF ! Empty( FileName := BugGetFile( { {'IDE+ by Ciro (MGIde.exe or oIDE*.exe)','MGIde.exe;oIDE*.exe'} }, 'Select Form tool', US_FileNameOnlyPath( GetProperty( 'WinGSettings', 'Text_HMI', 'value' ) ), .F., .T. ) )
         SetProperty( 'WinGSettings', 'Text_HMI', 'value', FileName )
      ENDIF
   CASE tool == 'HMGSIDE'
      IF ! Empty( FileName := BugGetFile( { {'HMGS-IDE by Walter (HMGSIDE.exe or IDE.exe)','HMGSIDE.exe;IDE.exe'} }, 'Select Form tool', US_FileNameOnlyPath( GetProperty( 'WinGSettings', 'Text_HMGSIDE', 'value' ) ), .F., .T. ) )
         SetProperty( 'WinGSettings', 'Text_HMGSIDE', 'value', FileName )
      ENDIF
   OTHERWISE
      MsgStop( 'Tool inválida en función FormToolCheck: '+tool )
   ENDCASE
RETURN .T.

Function SelectTab

   if empty( PUB_cProjectFolder )
      WinGSettings.TabGSettings.value := 1
   else
      do case
      case Prj_Radio_MiniGui == DEF_RG_MINIGUI1 .and. Prj_Radio_Cpp == DEF_RG_BORLAND
         if Prj_Radio_Harbour == DEF_RG_HARBOUR
            WinGSettings.TabGSettings.value := 3
         else
            WinGSettings.TabGSettings.value := 4
         endif
      case Prj_Radio_MiniGui == DEF_RG_MINIGUI3 .and. Prj_Radio_Cpp == DEF_RG_MINGW
         if Prj_Check_64bits
            if Prj_Radio_Harbour == DEF_RG_HARBOUR
               WinGSettings.TabGSettings.value := 6
            else
               WinGSettings.TabGSettings.value := 1
               US_Log( "Invalid combination: Prj_Radio_MiniGui: " + DEF_RG_MINIGUI3 + HB_OsNewLine() + ;
                       "                     Prj_Radio_Cpp:     " + DEF_RG_MINGW  + HB_OsNewLine() + ;
                       "                     Prj_Radio_Harbour: " + US_VarToStr( Prj_Radio_Harbour )  + HB_OsNewLine() )
            endif
         else
            if Prj_Radio_Harbour == DEF_RG_HARBOUR
               WinGSettings.TabGSettings.value := 5
            else
               WinGSettings.TabGSettings.value := 1
               US_Log( "Invalid combination: Prj_Radio_MiniGui: " + DEF_RG_MINIGUI3 + HB_OsNewLine() + ;
                       "                     Prj_Radio_Cpp:     " + DEF_RG_MINGW  + HB_OsNewLine() + ;
                       "                     Prj_Radio_Harbour: " + US_VarToStr( Prj_Radio_Harbour )  + HB_OsNewLine() )
            endif
         endif
      case Prj_Radio_MiniGui == DEF_RG_EXTENDED1 .and. Prj_Radio_Cpp == DEF_RG_BORLAND
         if Prj_Radio_Harbour == DEF_RG_HARBOUR
            WinGSettings.TabGSettings.value := 7
         else
            WinGSettings.TabGSettings.value := 8
         endif
      case Prj_Radio_MiniGui == DEF_RG_EXTENDED1 .and. Prj_Radio_Cpp == DEF_RG_MINGW
         if Prj_Check_64bits
            if Prj_Radio_Harbour == DEF_RG_HARBOUR
               WinGSettings.TabGSettings.value := 11
            else
               WinGSettings.TabGSettings.value := 12
            endif
         else
            if Prj_Radio_Harbour == DEF_RG_HARBOUR
               WinGSettings.TabGSettings.value := 9
            else
               WinGSettings.TabGSettings.value := 10
            endif
         endif
      case Prj_Radio_MiniGui == DEF_RG_OOHG3 .and. Prj_Radio_Cpp == DEF_RG_BORLAND
         if Prj_Radio_Harbour == DEF_RG_HARBOUR
            WinGSettings.TabGSettings.value := 13
         else
            WinGSettings.TabGSettings.value := 14
         endif
      case Prj_Radio_MiniGui == DEF_RG_OOHG3 .and. Prj_Radio_Cpp == DEF_RG_MINGW
         if Prj_Check_64bits
            if Prj_Radio_Harbour == DEF_RG_HARBOUR
               WinGSettings.TabGSettings.value := 17
            else
               WinGSettings.TabGSettings.value := 18
            endif
         else
            if Prj_Radio_Harbour == DEF_RG_HARBOUR
               WinGSettings.TabGSettings.value := 15
            else
               WinGSettings.TabGSettings.value := 16
            endif
         endif
      case Prj_Radio_MiniGui == DEF_RG_OOHG3 .and. Prj_Radio_Cpp == DEF_RG_PELLES
         if Prj_Check_64bits
            if Prj_Radio_Harbour == DEF_RG_HARBOUR
               WinGSettings.TabGSettings.value := 21
            else
               WinGSettings.TabGSettings.value := 22
            endif
         else
            if Prj_Radio_Harbour == DEF_RG_HARBOUR
               WinGSettings.TabGSettings.value := 19
            else
               WinGSettings.TabGSettings.value := 20
            endif
         endif
      otherwise
         WinGSettings.TabGSettings.value := 1
         US_Log( "Invalid combination: Prj_Radio_MiniGui: " + US_VarToStr( Prj_Radio_MiniGui ) + HB_OsNewLine() + ;
                 "                     Prj_Radio_Cpp:     " + US_VarToStr( Prj_Radio_Cpp )  + HB_OsNewLine() )
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
   if Gbl_Text_Editor  != WinGSettings.TEditor.value      .or. ;
      Gbl_Text_HMI     != WinGSettings.Text_HMI.value     .or. ;
      Gbl_Text_HMGSIDE != WinGSettings.Text_HMGSIDE.value .or. ;
      Gbl_Text_Dbf     != WinGSettings.Text_Dbf.value     .or. ;
      ;
      &("Gbl_T_M_"      + DefineMiniGui1  + DefineBorland + DefineHarbour  + Define32bits) != WinGSettings.&("TM_"      + DefineMiniGui1  + DefineBorland + DefineHarbour  + Define32bits).value .or. ;
      &("Gbl_T_C_"      + DefineMiniGui1  + DefineBorland + DefineHarbour  + Define32bits) != WinGSettings.&("TC_"      + DefineMiniGui1  + DefineBorland + DefineHarbour  + Define32bits).value .or. ;
      &("Gbl_T_P_"      + DefineMiniGui1  + DefineBorland + DefineHarbour  + Define32bits) != WinGSettings.&("TP_"      + DefineMiniGui1  + DefineBorland + DefineHarbour  + Define32bits).value .or. ;
      &("Gbl_T_M_LIBS_" + DefineMiniGui1  + DefineBorland + DefineHarbour  + Define32bits) != WinGSettings.&("TM_LIBS_" + DefineMiniGui1  + DefineBorland + DefineHarbour  + Define32bits).value .or. ;
      &("Gbl_T_C_LIBS_" + DefineMiniGui1  + DefineBorland + DefineHarbour  + Define32bits) != WinGSettings.&("TC_LIBS_" + DefineMiniGui1  + DefineBorland + DefineHarbour  + Define32bits).value .or. ;
      &("Gbl_T_P_LIBS_" + DefineMiniGui1  + DefineBorland + DefineHarbour  + Define32bits) != WinGSettings.&("TP_LIBS_" + DefineMiniGui1  + DefineBorland + DefineHarbour  + Define32bits).value .or. ;
      ;
      &("Gbl_T_M_"      + DefineMiniGui1  + DefineBorland + DefineXHarbour + Define32bits) != WinGSettings.&("TM_"      + DefineMiniGui1  + DefineBorland + DefineXHarbour + Define32bits).value .or. ;
      &("Gbl_T_C_"      + DefineMiniGui1  + DefineBorland + DefineXHarbour + Define32bits) != WinGSettings.&("TC_"      + DefineMiniGui1  + DefineBorland + DefineXHarbour + Define32bits).value .or. ;
      &("Gbl_T_P_"      + DefineMiniGui1  + DefineBorland + DefineXHarbour + Define32bits) != WinGSettings.&("TP_"      + DefineMiniGui1  + DefineBorland + DefineXHarbour + Define32bits).value .or. ;
      &("Gbl_T_M_LIBS_" + DefineMiniGui1  + DefineBorland + DefineXHarbour + Define32bits) != WinGSettings.&("TM_LIBS_" + DefineMiniGui1  + DefineBorland + DefineXHarbour + Define32bits).value .or. ;
      &("Gbl_T_C_LIBS_" + DefineMiniGui1  + DefineBorland + DefineXHarbour + Define32bits) != WinGSettings.&("TC_LIBS_" + DefineMiniGui1  + DefineBorland + DefineXHarbour + Define32bits).value .or. ;
      &("Gbl_T_P_LIBS_" + DefineMiniGui1  + DefineBorland + DefineXHarbour + Define32bits) != WinGSettings.&("TP_LIBS_" + DefineMiniGui1  + DefineBorland + DefineXHarbour + Define32bits).value .or. ;
      ;
      &("Gbl_T_M_"      + DefineMiniGui3  + DefineMinGW   + DefineHarbour  + Define32bits) != WinGSettings.&("TM_"      + DefineMiniGui3  + DefineMinGW   + DefineHarbour  + Define32bits).value .or. ;
      &("Gbl_T_C_"      + DefineMiniGui3  + DefineMinGW   + DefineHarbour  + Define32bits) != WinGSettings.&("TC_"      + DefineMiniGui3  + DefineMinGW   + DefineHarbour  + Define32bits).value .or. ;
      &("Gbl_T_P_"      + DefineMiniGui3  + DefineMinGW   + DefineHarbour  + Define32bits) != WinGSettings.&("TP_"      + DefineMiniGui3  + DefineMinGW   + DefineHarbour  + Define32bits).value .or. ;
      &("Gbl_T_M_LIBS_" + DefineMiniGui3  + DefineMinGW   + DefineHarbour  + Define32bits) != WinGSettings.&("TM_LIBS_" + DefineMiniGui3  + DefineMinGW   + DefineHarbour  + Define32bits).value .or. ;
      &("Gbl_T_C_LIBS_" + DefineMiniGui3  + DefineMinGW   + DefineHarbour  + Define32bits) != WinGSettings.&("TC_LIBS_" + DefineMiniGui3  + DefineMinGW   + DefineHarbour  + Define32bits).value .or. ;
      &("Gbl_T_P_LIBS_" + DefineMiniGui3  + DefineMinGW   + DefineHarbour  + Define32bits) != WinGSettings.&("TP_LIBS_" + DefineMiniGui3  + DefineMinGW   + DefineHarbour  + Define32bits).value .or. ;
      ;
      &("Gbl_T_M_"      + DefineMiniGui3  + DefineMinGW   + DefineHarbour  + Define64bits) != WinGSettings.&("TM_"      + DefineMiniGui3  + DefineMinGW   + DefineHarbour  + Define64bits).value .or. ;
      &("Gbl_T_C_"      + DefineMiniGui3  + DefineMinGW   + DefineHarbour  + Define64bits) != WinGSettings.&("TC_"      + DefineMiniGui3  + DefineMinGW   + DefineHarbour  + Define64bits).value .or. ;
      &("Gbl_T_P_"      + DefineMiniGui3  + DefineMinGW   + DefineHarbour  + Define64bits) != WinGSettings.&("TP_"      + DefineMiniGui3  + DefineMinGW   + DefineHarbour  + Define64bits).value .or. ;
      &("Gbl_T_M_LIBS_" + DefineMiniGui3  + DefineMinGW   + DefineHarbour  + Define64bits) != WinGSettings.&("TM_LIBS_" + DefineMiniGui3  + DefineMinGW   + DefineHarbour  + Define64bits).value .or. ;
      &("Gbl_T_C_LIBS_" + DefineMiniGui3  + DefineMinGW   + DefineHarbour  + Define64bits) != WinGSettings.&("TC_LIBS_" + DefineMiniGui3  + DefineMinGW   + DefineHarbour  + Define64bits).value .or. ;
      &("Gbl_T_P_LIBS_" + DefineMiniGui3  + DefineMinGW   + DefineHarbour  + Define64bits) != WinGSettings.&("TP_LIBS_" + DefineMiniGui3  + DefineMinGW   + DefineHarbour  + Define64bits).value .or. ;
      ;
      &("Gbl_T_M_"      + DefineExtended1 + DefineBorland + DefineHarbour  + Define32bits) != WinGSettings.&("TM_"      + DefineExtended1 + DefineBorland + DefineHarbour  + Define32bits).value .or. ;
      &("Gbl_T_C_"      + DefineExtended1 + DefineBorland + DefineHarbour  + Define32bits) != WinGSettings.&("TC_"      + DefineExtended1 + DefineBorland + DefineHarbour  + Define32bits).value .or. ;
      &("Gbl_T_P_"      + DefineExtended1 + DefineBorland + DefineHarbour  + Define32bits) != WinGSettings.&("TP_"      + DefineExtended1 + DefineBorland + DefineHarbour  + Define32bits).value .or. ;
      &("Gbl_T_M_LIBS_" + DefineExtended1 + DefineBorland + DefineHarbour  + Define32bits) != WinGSettings.&("TM_LIBS_" + DefineExtended1 + DefineBorland + DefineHarbour  + Define32bits).value .or. ;
      &("Gbl_T_C_LIBS_" + DefineExtended1 + DefineBorland + DefineHarbour  + Define32bits) != WinGSettings.&("TC_LIBS_" + DefineExtended1 + DefineBorland + DefineHarbour  + Define32bits).value .or. ;
      &("Gbl_T_P_LIBS_" + DefineExtended1 + DefineBorland + DefineHarbour  + Define32bits) != WinGSettings.&("TP_LIBS_" + DefineExtended1 + DefineBorland + DefineHarbour  + Define32bits).value .or. ;
      ;
      &("Gbl_T_M_"      + DefineExtended1 + DefineBorland + DefineXHarbour + Define32bits) != WinGSettings.&("TM_"      + DefineExtended1 + DefineBorland + DefineXHarbour + Define32bits).value .or. ;
      &("Gbl_T_C_"      + DefineExtended1 + DefineBorland + DefineXHarbour + Define32bits) != WinGSettings.&("TC_"      + DefineExtended1 + DefineBorland + DefineXHarbour + Define32bits).value .or. ;
      &("Gbl_T_P_"      + DefineExtended1 + DefineBorland + DefineXHarbour + Define32bits) != WinGSettings.&("TP_"      + DefineExtended1 + DefineBorland + DefineXHarbour + Define32bits).value .or. ;
      &("Gbl_T_M_LIBS_" + DefineExtended1 + DefineBorland + DefineXHarbour + Define32bits) != WinGSettings.&("TM_LIBS_" + DefineExtended1 + DefineBorland + DefineXHarbour + Define32bits).value .or. ;
      &("Gbl_T_C_LIBS_" + DefineExtended1 + DefineBorland + DefineXHarbour + Define32bits) != WinGSettings.&("TC_LIBS_" + DefineExtended1 + DefineBorland + DefineXHarbour + Define32bits).value .or. ;
      &("Gbl_T_P_LIBS_" + DefineExtended1 + DefineBorland + DefineXHarbour + Define32bits) != WinGSettings.&("TP_LIBS_" + DefineExtended1 + DefineBorland + DefineXHarbour + Define32bits).value .or. ;
      ;
      &("Gbl_T_M_"      + DefineExtended1 + DefineMinGW   + DefineHarbour  + Define32bits) != WinGSettings.&("TM_"      + DefineExtended1 + DefineMinGW   + DefineHarbour  + Define32bits).value .or. ;
      &("Gbl_T_C_"      + DefineExtended1 + DefineMinGW   + DefineHarbour  + Define32bits) != WinGSettings.&("TC_"      + DefineExtended1 + DefineMinGW   + DefineHarbour  + Define32bits).value .or. ;
      &("Gbl_T_P_"      + DefineExtended1 + DefineMinGW   + DefineHarbour  + Define32bits) != WinGSettings.&("TP_"      + DefineExtended1 + DefineMinGW   + DefineHarbour  + Define32bits).value .or. ;
      &("Gbl_T_M_LIBS_" + DefineExtended1 + DefineMinGW   + DefineHarbour  + Define32bits) != WinGSettings.&("TM_LIBS_" + DefineExtended1 + DefineMinGW   + DefineHarbour  + Define32bits).value .or. ;
      &("Gbl_T_C_LIBS_" + DefineExtended1 + DefineMinGW   + DefineHarbour  + Define32bits) != WinGSettings.&("TC_LIBS_" + DefineExtended1 + DefineMinGW   + DefineHarbour  + Define32bits).value .or. ;
      &("Gbl_T_P_LIBS_" + DefineExtended1 + DefineMinGW   + DefineHarbour  + Define32bits) != WinGSettings.&("TP_LIBS_" + DefineExtended1 + DefineMinGW   + DefineHarbour  + Define32bits).value .or. ;
      ;
      &("Gbl_T_M_"      + DefineExtended1 + DefineMinGW   + DefineXHarbour + Define32bits) != WinGSettings.&("TM_"      + DefineExtended1 + DefineMinGW   + DefineXHarbour + Define32bits).value .or. ;
      &("Gbl_T_C_"      + DefineExtended1 + DefineMinGW   + DefineXHarbour + Define32bits) != WinGSettings.&("TC_"      + DefineExtended1 + DefineMinGW   + DefineXHarbour + Define32bits).value .or. ;
      &("Gbl_T_P_"      + DefineExtended1 + DefineMinGW   + DefineXHarbour + Define32bits) != WinGSettings.&("TP_"      + DefineExtended1 + DefineMinGW   + DefineXHarbour + Define32bits).value .or. ;
      &("Gbl_T_M_LIBS_" + DefineExtended1 + DefineMinGW   + DefineXHarbour + Define32bits) != WinGSettings.&("TM_LIBS_" + DefineExtended1 + DefineMinGW   + DefineXHarbour + Define32bits).value .or. ;
      &("Gbl_T_C_LIBS_" + DefineExtended1 + DefineMinGW   + DefineXHarbour + Define32bits) != WinGSettings.&("TC_LIBS_" + DefineExtended1 + DefineMinGW   + DefineXHarbour + Define32bits).value .or. ;
      &("Gbl_T_P_LIBS_" + DefineExtended1 + DefineMinGW   + DefineXHarbour + Define32bits) != WinGSettings.&("TP_LIBS_" + DefineExtended1 + DefineMinGW   + DefineXHarbour + Define32bits).value .or. ;
      ;
      &("Gbl_T_M_"      + DefineExtended1 + DefineMinGW   + DefineHarbour  + Define64bits) != WinGSettings.&("TM_"      + DefineExtended1 + DefineMinGW   + DefineHarbour  + Define64bits).value .or. ;
      &("Gbl_T_C_"      + DefineExtended1 + DefineMinGW   + DefineHarbour  + Define64bits) != WinGSettings.&("TC_"      + DefineExtended1 + DefineMinGW   + DefineHarbour  + Define64bits).value .or. ;
      &("Gbl_T_P_"      + DefineExtended1 + DefineMinGW   + DefineHarbour  + Define64bits) != WinGSettings.&("TP_"      + DefineExtended1 + DefineMinGW   + DefineHarbour  + Define64bits).value .or. ;
      &("Gbl_T_M_LIBS_" + DefineExtended1 + DefineMinGW   + DefineHarbour  + Define64bits) != WinGSettings.&("TM_LIBS_" + DefineExtended1 + DefineMinGW   + DefineHarbour  + Define64bits).value .or. ;
      &("Gbl_T_C_LIBS_" + DefineExtended1 + DefineMinGW   + DefineHarbour  + Define64bits) != WinGSettings.&("TC_LIBS_" + DefineExtended1 + DefineMinGW   + DefineHarbour  + Define64bits).value .or. ;
      &("Gbl_T_P_LIBS_" + DefineExtended1 + DefineMinGW   + DefineHarbour  + Define64bits) != WinGSettings.&("TP_LIBS_" + DefineExtended1 + DefineMinGW   + DefineHarbour  + Define64bits).value .or. ;
      ;
      &("Gbl_T_M_"      + DefineExtended1 + DefineMinGW   + DefineXHarbour + Define64bits) != WinGSettings.&("TM_"      + DefineExtended1 + DefineMinGW   + DefineXHarbour + Define64bits).value .or. ;
      &("Gbl_T_C_"      + DefineExtended1 + DefineMinGW   + DefineXHarbour + Define64bits) != WinGSettings.&("TC_"      + DefineExtended1 + DefineMinGW   + DefineXHarbour + Define64bits).value .or. ;
      &("Gbl_T_P_"      + DefineExtended1 + DefineMinGW   + DefineXHarbour + Define64bits) != WinGSettings.&("TP_"      + DefineExtended1 + DefineMinGW   + DefineXHarbour + Define64bits).value .or. ;
      &("Gbl_T_M_LIBS_" + DefineExtended1 + DefineMinGW   + DefineXHarbour + Define64bits) != WinGSettings.&("TM_LIBS_" + DefineExtended1 + DefineMinGW   + DefineXHarbour + Define64bits).value .or. ;
      &("Gbl_T_C_LIBS_" + DefineExtended1 + DefineMinGW   + DefineXHarbour + Define64bits) != WinGSettings.&("TC_LIBS_" + DefineExtended1 + DefineMinGW   + DefineXHarbour + Define64bits).value .or. ;
      &("Gbl_T_P_LIBS_" + DefineExtended1 + DefineMinGW   + DefineXHarbour + Define64bits) != WinGSettings.&("TP_LIBS_" + DefineExtended1 + DefineMinGW   + DefineXHarbour + Define64bits).value .or. ;
      ;
      &("Gbl_T_M_"      + DefineOohg3     + DefineBorland + DefineHarbour  + Define32bits) != WinGSettings.&("TM_"      + DefineOohg3     + DefineBorland + DefineHarbour  + Define32bits).value .or. ;
      &("Gbl_T_C_"      + DefineOohg3     + DefineBorland + DefineHarbour  + Define32bits) != WinGSettings.&("TC_"      + DefineOohg3     + DefineBorland + DefineHarbour  + Define32bits).value .or. ;
      &("Gbl_T_P_"      + DefineOohg3     + DefineBorland + DefineHarbour  + Define32bits) != WinGSettings.&("TP_"      + DefineOohg3     + DefineBorland + DefineHarbour  + Define32bits).value .or. ;
      &("Gbl_T_M_LIBS_" + DefineOohg3     + DefineBorland + DefineHarbour  + Define32bits) != WinGSettings.&("TM_LIBS_" + DefineOohg3     + DefineBorland + DefineHarbour  + Define32bits).value .or. ;
      &("Gbl_T_C_LIBS_" + DefineOohg3     + DefineBorland + DefineHarbour  + Define32bits) != WinGSettings.&("TC_LIBS_" + DefineOohg3     + DefineBorland + DefineHarbour  + Define32bits).value .or. ;
      &("Gbl_T_P_LIBS_" + DefineOohg3     + DefineBorland + DefineHarbour  + Define32bits) != WinGSettings.&("TP_LIBS_" + DefineOohg3     + DefineBorland + DefineHarbour  + Define32bits).value .or. ;
      ;
      &("Gbl_T_M_"      + DefineOohg3     + DefineBorland + DefineXHarbour + Define32bits) != WinGSettings.&("TM_"      + DefineOohg3     + DefineBorland + DefineXHarbour + Define32bits).value .or. ;
      &("Gbl_T_C_"      + DefineOohg3     + DefineBorland + DefineXHarbour + Define32bits) != WinGSettings.&("TC_"      + DefineOohg3     + DefineBorland + DefineXHarbour + Define32bits).value .or. ;
      &("Gbl_T_P_"      + DefineOohg3     + DefineBorland + DefineXHarbour + Define32bits) != WinGSettings.&("TP_"      + DefineOohg3     + DefineBorland + DefineXHarbour + Define32bits).value .or. ;
      &("Gbl_T_M_LIBS_" + DefineOohg3     + DefineBorland + DefineXHarbour + Define32bits) != WinGSettings.&("TM_LIBS_" + DefineOohg3     + DefineBorland + DefineXHarbour + Define32bits).value .or. ;
      &("Gbl_T_C_LIBS_" + DefineOohg3     + DefineBorland + DefineXHarbour + Define32bits) != WinGSettings.&("TC_LIBS_" + DefineOohg3     + DefineBorland + DefineXHarbour + Define32bits).value .or. ;
      &("Gbl_T_P_LIBS_" + DefineOohg3     + DefineBorland + DefineXHarbour + Define32bits) != WinGSettings.&("TP_LIBS_" + DefineOohg3     + DefineBorland + DefineXHarbour + Define32bits).value .or. ;
      ;
      &("Gbl_T_M_"      + DefineOohg3     + DefineMinGW   + DefineHarbour  + Define32bits) != WinGSettings.&("TM_"      + DefineOohg3     + DefineMinGW   + DefineHarbour  + Define32bits).value .or. ;
      &("Gbl_T_C_"      + DefineOohg3     + DefineMinGW   + DefineHarbour  + Define32bits) != WinGSettings.&("TC_"      + DefineOohg3     + DefineMinGW   + DefineHarbour  + Define32bits).value .or. ;
      &("Gbl_T_P_"      + DefineOohg3     + DefineMinGW   + DefineHarbour  + Define32bits) != WinGSettings.&("TP_"      + DefineOohg3     + DefineMinGW   + DefineHarbour  + Define32bits).value .or. ;
      &("Gbl_T_M_LIBS_" + DefineOohg3     + DefineMinGW   + DefineHarbour  + Define32bits) != WinGSettings.&("TM_LIBS_" + DefineOohg3     + DefineMinGW   + DefineHarbour  + Define32bits).value .or. ;
      &("Gbl_T_C_LIBS_" + DefineOohg3     + DefineMinGW   + DefineHarbour  + Define32bits) != WinGSettings.&("TC_LIBS_" + DefineOohg3     + DefineMinGW   + DefineHarbour  + Define32bits).value .or. ;
      &("Gbl_T_P_LIBS_" + DefineOohg3     + DefineMinGW   + DefineHarbour  + Define32bits) != WinGSettings.&("TP_LIBS_" + DefineOohg3     + DefineMinGW   + DefineHarbour  + Define32bits).value .or. ;
      ;
      &("Gbl_T_M_"      + DefineOohg3     + DefineMinGW   + DefineXHarbour + Define32bits) != WinGSettings.&("TM_"      + DefineOohg3     + DefineMinGW   + DefineXHarbour + Define32bits).value .or. ;
      &("Gbl_T_C_"      + DefineOohg3     + DefineMinGW   + DefineXHarbour + Define32bits) != WinGSettings.&("TC_"      + DefineOohg3     + DefineMinGW   + DefineXHarbour + Define32bits).value .or. ;
      &("Gbl_T_P_"      + DefineOohg3     + DefineMinGW   + DefineXHarbour + Define32bits) != WinGSettings.&("TP_"      + DefineOohg3     + DefineMinGW   + DefineXHarbour + Define32bits).value .or. ;
      &("Gbl_T_M_LIBS_" + DefineOohg3     + DefineMinGW   + DefineXHarbour + Define32bits) != WinGSettings.&("TM_LIBS_" + DefineOohg3     + DefineMinGW   + DefineXHarbour + Define32bits).value .or. ;
      &("Gbl_T_C_LIBS_" + DefineOohg3     + DefineMinGW   + DefineXHarbour + Define32bits) != WinGSettings.&("TC_LIBS_" + DefineOohg3     + DefineMinGW   + DefineXHarbour + Define32bits).value .or. ;
      &("Gbl_T_P_LIBS_" + DefineOohg3     + DefineMinGW   + DefineXHarbour + Define32bits) != WinGSettings.&("TP_LIBS_" + DefineOohg3     + DefineMinGW   + DefineXHarbour + Define32bits).value .or. ;
      ;
      &("Gbl_T_M_"      + DefineOohg3     + DefineMinGW   + DefineHarbour  + Define64bits) != WinGSettings.&("TM_"      + DefineOohg3     + DefineMinGW   + DefineHarbour  + Define64bits).value .or. ;
      &("Gbl_T_C_"      + DefineOohg3     + DefineMinGW   + DefineHarbour  + Define64bits) != WinGSettings.&("TC_"      + DefineOohg3     + DefineMinGW   + DefineHarbour  + Define64bits).value .or. ;
      &("Gbl_T_P_"      + DefineOohg3     + DefineMinGW   + DefineHarbour  + Define64bits) != WinGSettings.&("TP_"      + DefineOohg3     + DefineMinGW   + DefineHarbour  + Define64bits).value .or. ;
      &("Gbl_T_M_LIBS_" + DefineOohg3     + DefineMinGW   + DefineHarbour  + Define64bits) != WinGSettings.&("TM_LIBS_" + DefineOohg3     + DefineMinGW   + DefineHarbour  + Define64bits).value .or. ;
      &("Gbl_T_C_LIBS_" + DefineOohg3     + DefineMinGW   + DefineHarbour  + Define64bits) != WinGSettings.&("TC_LIBS_" + DefineOohg3     + DefineMinGW   + DefineHarbour  + Define64bits).value .or. ;
      &("Gbl_T_P_LIBS_" + DefineOohg3     + DefineMinGW   + DefineHarbour  + Define64bits) != WinGSettings.&("TP_LIBS_" + DefineOohg3     + DefineMinGW   + DefineHarbour  + Define64bits).value .or. ;
      ;
      &("Gbl_T_M_"      + DefineOohg3     + DefineMinGW   + DefineXHarbour + Define64bits) != WinGSettings.&("TM_"      + DefineOohg3     + DefineMinGW   + DefineXHarbour + Define64bits).value .or. ;
      &("Gbl_T_C_"      + DefineOohg3     + DefineMinGW   + DefineXHarbour + Define64bits) != WinGSettings.&("TC_"      + DefineOohg3     + DefineMinGW   + DefineXHarbour + Define64bits).value .or. ;
      &("Gbl_T_P_"      + DefineOohg3     + DefineMinGW   + DefineXHarbour + Define64bits) != WinGSettings.&("TP_"      + DefineOohg3     + DefineMinGW   + DefineXHarbour + Define64bits).value .or. ;
      &("Gbl_T_M_LIBS_" + DefineOohg3     + DefineMinGW   + DefineXHarbour + Define64bits) != WinGSettings.&("TM_LIBS_" + DefineOohg3     + DefineMinGW   + DefineXHarbour + Define64bits).value .or. ;
      &("Gbl_T_C_LIBS_" + DefineOohg3     + DefineMinGW   + DefineXHarbour + Define64bits) != WinGSettings.&("TC_LIBS_" + DefineOohg3     + DefineMinGW   + DefineXHarbour + Define64bits).value .or. ;
      &("Gbl_T_P_LIBS_" + DefineOohg3     + DefineMinGW   + DefineXHarbour + Define64bits) != WinGSettings.&("TP_LIBS_" + DefineOohg3     + DefineMinGW   + DefineXHarbour + Define64bits).value .or. ;
      ;
      &("Gbl_T_M_"      + DefineOohg3     + DefinePelles  + DefineHarbour  + Define32bits) != WinGSettings.&("TM_"      + DefineOohg3     + DefinePelles  + DefineHarbour  + Define32bits).value .or. ;
      &("Gbl_T_C_"      + DefineOohg3     + DefinePelles  + DefineHarbour  + Define32bits) != WinGSettings.&("TC_"      + DefineOohg3     + DefinePelles  + DefineHarbour  + Define32bits).value .or. ;
      &("Gbl_T_P_"      + DefineOohg3     + DefinePelles  + DefineHarbour  + Define32bits) != WinGSettings.&("TP_"      + DefineOohg3     + DefinePelles  + DefineHarbour  + Define32bits).value .or. ;
      &("Gbl_T_M_LIBS_" + DefineOohg3     + DefinePelles  + DefineHarbour  + Define32bits) != WinGSettings.&("TM_LIBS_" + DefineOohg3     + DefinePelles  + DefineHarbour  + Define32bits).value .or. ;
      &("Gbl_T_C_LIBS_" + DefineOohg3     + DefinePelles  + DefineHarbour  + Define32bits) != WinGSettings.&("TC_LIBS_" + DefineOohg3     + DefinePelles  + DefineHarbour  + Define32bits).value .or. ;
      &("Gbl_T_P_LIBS_" + DefineOohg3     + DefinePelles  + DefineHarbour  + Define32bits) != WinGSettings.&("TP_LIBS_" + DefineOohg3     + DefinePelles  + DefineHarbour  + Define32bits).value .or. ;
      ;
      &("Gbl_T_M_"      + DefineOohg3     + DefinePelles  + DefineXHarbour + Define32bits) != WinGSettings.&("TM_"      + DefineOohg3     + DefinePelles  + DefineXHarbour + Define32bits).value .or. ;
      &("Gbl_T_C_"      + DefineOohg3     + DefinePelles  + DefineXHarbour + Define32bits) != WinGSettings.&("TC_"      + DefineOohg3     + DefinePelles  + DefineXHarbour + Define32bits).value .or. ;
      &("Gbl_T_P_"      + DefineOohg3     + DefinePelles  + DefineXHarbour + Define32bits) != WinGSettings.&("TP_"      + DefineOohg3     + DefinePelles  + DefineXHarbour + Define32bits).value .or. ;
      &("Gbl_T_M_LIBS_" + DefineOohg3     + DefinePelles  + DefineXHarbour + Define32bits) != WinGSettings.&("TM_LIBS_" + DefineOohg3     + DefinePelles  + DefineXHarbour + Define32bits).value .or. ;
      &("Gbl_T_C_LIBS_" + DefineOohg3     + DefinePelles  + DefineXHarbour + Define32bits) != WinGSettings.&("TC_LIBS_" + DefineOohg3     + DefinePelles  + DefineXHarbour + Define32bits).value .or. ;
      &("Gbl_T_P_LIBS_" + DefineOohg3     + DefinePelles  + DefineXHarbour + Define32bits) != WinGSettings.&("TP_LIBS_" + DefineOohg3     + DefinePelles  + DefineXHarbour + Define32bits).value .or. ;
      ;
      &("Gbl_T_M_"      + DefineOohg3     + DefinePelles  + DefineHarbour  + Define64bits) != WinGSettings.&("TM_"      + DefineOohg3     + DefinePelles  + DefineHarbour  + Define64bits).value .or. ;
      &("Gbl_T_C_"      + DefineOohg3     + DefinePelles  + DefineHarbour  + Define64bits) != WinGSettings.&("TC_"      + DefineOohg3     + DefinePelles  + DefineHarbour  + Define64bits).value .or. ;
      &("Gbl_T_P_"      + DefineOohg3     + DefinePelles  + DefineHarbour  + Define64bits) != WinGSettings.&("TP_"      + DefineOohg3     + DefinePelles  + DefineHarbour  + Define64bits).value .or. ;
      &("Gbl_T_M_LIBS_" + DefineOohg3     + DefinePelles  + DefineHarbour  + Define64bits) != WinGSettings.&("TM_LIBS_" + DefineOohg3     + DefinePelles  + DefineHarbour  + Define64bits).value .or. ;
      &("Gbl_T_C_LIBS_" + DefineOohg3     + DefinePelles  + DefineHarbour  + Define64bits) != WinGSettings.&("TC_LIBS_" + DefineOohg3     + DefinePelles  + DefineHarbour  + Define64bits).value .or. ;
      &("Gbl_T_P_LIBS_" + DefineOohg3     + DefinePelles  + DefineHarbour  + Define64bits) != WinGSettings.&("TP_LIBS_" + DefineOohg3     + DefinePelles  + DefineHarbour  + Define64bits).value .or. ;
      ;
      &("Gbl_T_M_"      + DefineOohg3     + DefinePelles  + DefineXHarbour + Define64bits) != WinGSettings.&("TM_"      + DefineOohg3     + DefinePelles  + DefineXHarbour + Define64bits).value .or. ;
      &("Gbl_T_C_"      + DefineOohg3     + DefinePelles  + DefineXHarbour + Define64bits) != WinGSettings.&("TC_"      + DefineOohg3     + DefinePelles  + DefineXHarbour + Define64bits).value .or. ;
      &("Gbl_T_P_"      + DefineOohg3     + DefinePelles  + DefineXHarbour + Define64bits) != WinGSettings.&("TP_"      + DefineOohg3     + DefinePelles  + DefineXHarbour + Define64bits).value .or. ;
      &("Gbl_T_M_LIBS_" + DefineOohg3     + DefinePelles  + DefineXHarbour + Define64bits) != WinGSettings.&("TM_LIBS_" + DefineOohg3     + DefinePelles  + DefineXHarbour + Define64bits).value .or. ;
      &("Gbl_T_C_LIBS_" + DefineOohg3     + DefinePelles  + DefineXHarbour + Define64bits) != WinGSettings.&("TC_LIBS_" + DefineOohg3     + DefinePelles  + DefineXHarbour + Define64bits).value .or. ;
      &("Gbl_T_P_LIBS_" + DefineOohg3     + DefinePelles  + DefineXHarbour + Define64bits) != WinGSettings.&("TP_LIBS_" + DefineOohg3     + DefinePelles  + DefineXHarbour + Define64bits).value

      Return .T.
   endif
Return .F.

Function GlobalSettingsSave( lDefaultFile )
   Gbl_Text_Editor  := WinGSettings.TEditor.value
   Gbl_Text_HMI     := WinGSettings.Text_HMI.value
   Gbl_Text_HMGSIDE := WinGSettings.Text_HMGSIDE.value
   Gbl_Text_Dbf     := WinGSettings.Text_Dbf.value

   &("Gbl_T_C_"      + DefineMiniGui1  + DefineBorland + DefineHarbour  + Define32bits) := WinGSettings.&("TC_"      + DefineMiniGui1  + DefineBorland + DefineHarbour  + Define32bits).value
   &("Gbl_T_C_LIBS_" + DefineMiniGui1  + DefineBorland + DefineHarbour  + Define32bits) := WinGSettings.&("TC_LIBS_" + DefineMiniGui1  + DefineBorland + DefineHarbour  + Define32bits).value
   &("Gbl_T_M_"      + DefineMiniGui1  + DefineBorland + DefineHarbour  + Define32bits) := WinGSettings.&("TM_"      + DefineMiniGui1  + DefineBorland + DefineHarbour  + Define32bits).value
   &("Gbl_T_M_LIBS_" + DefineMiniGui1  + DefineBorland + DefineHarbour  + Define32bits) := WinGSettings.&("TM_LIBS_" + DefineMiniGui1  + DefineBorland + DefineHarbour  + Define32bits).value
   &("Gbl_T_P_"      + DefineMiniGui1  + DefineBorland + DefineHarbour  + Define32bits) := WinGSettings.&("TP_"      + DefineMiniGui1  + DefineBorland + DefineHarbour  + Define32bits).value
   &("Gbl_T_P_LIBS_" + DefineMiniGui1  + DefineBorland + DefineHarbour  + Define32bits) := WinGSettings.&("TP_LIBS_" + DefineMiniGui1  + DefineBorland + DefineHarbour  + Define32bits).value

   &("Gbl_T_C_"      + DefineMiniGui1  + DefineBorland + DefineXHarbour + Define32bits) := WinGSettings.&("TC_"      + DefineMiniGui1  + DefineBorland + DefineXHarbour + Define32bits).value
   &("Gbl_T_C_LIBS_" + DefineMiniGui1  + DefineBorland + DefineXHarbour + Define32bits) := WinGSettings.&("TC_LIBS_" + DefineMiniGui1  + DefineBorland + DefineXHarbour + Define32bits).value
   &("Gbl_T_M_"      + DefineMiniGui1  + DefineBorland + DefineXHarbour + Define32bits) := WinGSettings.&("TM_"      + DefineMiniGui1  + DefineBorland + DefineXHarbour + Define32bits).value
   &("Gbl_T_M_LIBS_" + DefineMiniGui1  + DefineBorland + DefineXHarbour + Define32bits) := WinGSettings.&("TM_LIBS_" + DefineMiniGui1  + DefineBorland + DefineXHarbour + Define32bits).value
   &("Gbl_T_P_"      + DefineMiniGui1  + DefineBorland + DefineXHarbour + Define32bits) := WinGSettings.&("TP_"      + DefineMiniGui1  + DefineBorland + DefineXHarbour + Define32bits).value
   &("Gbl_T_P_LIBS_" + DefineMiniGui1  + DefineBorland + DefineXHarbour + Define32bits) := WinGSettings.&("TP_LIBS_" + DefineMiniGui1  + DefineBorland + DefineXHarbour + Define32bits).value

   &("Gbl_T_C_"      + DefineMiniGui3  + DefineMinGW   + DefineHarbour  + Define32bits) := WinGSettings.&("TC_"      + DefineMiniGui3  + DefineMinGW   + DefineHarbour  + Define32bits).value
   &("Gbl_T_C_LIBS_" + DefineMiniGui3  + DefineMinGW   + DefineHarbour  + Define32bits) := WinGSettings.&("TC_LIBS_" + DefineMiniGui3  + DefineMinGW   + DefineHarbour  + Define32bits).value
   &("Gbl_T_M_"      + DefineMiniGui3  + DefineMinGW   + DefineHarbour  + Define32bits) := WinGSettings.&("TM_"      + DefineMiniGui3  + DefineMinGW   + DefineHarbour  + Define32bits).value
   &("Gbl_T_M_LIBS_" + DefineMiniGui3  + DefineMinGW   + DefineHarbour  + Define32bits) := WinGSettings.&("TM_LIBS_" + DefineMiniGui3  + DefineMinGW   + DefineHarbour  + Define32bits).value
   &("Gbl_T_P_"      + DefineMiniGui3  + DefineMinGW   + DefineHarbour  + Define32bits) := WinGSettings.&("TP_"      + DefineMiniGui3  + DefineMinGW   + DefineHarbour  + Define32bits).value
   &("Gbl_T_P_LIBS_" + DefineMiniGui3  + DefineMinGW   + DefineHarbour  + Define32bits) := WinGSettings.&("TP_LIBS_" + DefineMiniGui3  + DefineMinGW   + DefineHarbour  + Define32bits).value

   &("Gbl_T_C_"      + DefineMiniGui3  + DefineMinGW   + DefineHarbour  + Define64bits) := WinGSettings.&("TC_"      + DefineMiniGui3  + DefineMinGW   + DefineHarbour  + Define64bits).value
   &("Gbl_T_C_LIBS_" + DefineMiniGui3  + DefineMinGW   + DefineHarbour  + Define64bits) := WinGSettings.&("TC_LIBS_" + DefineMiniGui3  + DefineMinGW   + DefineHarbour  + Define64bits).value
   &("Gbl_T_M_"      + DefineMiniGui3  + DefineMinGW   + DefineHarbour  + Define64bits) := WinGSettings.&("TM_"      + DefineMiniGui3  + DefineMinGW   + DefineHarbour  + Define64bits).value
   &("Gbl_T_M_LIBS_" + DefineMiniGui3  + DefineMinGW   + DefineHarbour  + Define64bits) := WinGSettings.&("TM_LIBS_" + DefineMiniGui3  + DefineMinGW   + DefineHarbour  + Define64bits).value
   &("Gbl_T_P_"      + DefineMiniGui3  + DefineMinGW   + DefineHarbour  + Define64bits) := WinGSettings.&("TP_"      + DefineMiniGui3  + DefineMinGW   + DefineHarbour  + Define64bits).value
   &("Gbl_T_P_LIBS_" + DefineMiniGui3  + DefineMinGW   + DefineHarbour  + Define64bits) := WinGSettings.&("TP_LIBS_" + DefineMiniGui3  + DefineMinGW   + DefineHarbour  + Define64bits).value

   &("Gbl_T_C_"      + DefineExtended1 + DefineBorland + DefineHarbour  + Define32bits) := WinGSettings.&("TC_"      + DefineExtended1 + DefineBorland + DefineHarbour  + Define32bits).value
   &("Gbl_T_C_LIBS_" + DefineExtended1 + DefineBorland + DefineHarbour  + Define32bits) := WinGSettings.&("TC_LIBS_" + DefineExtended1 + DefineBorland + DefineHarbour  + Define32bits).value
   &("Gbl_T_M_"      + DefineExtended1 + DefineBorland + DefineHarbour  + Define32bits) := WinGSettings.&("TM_"      + DefineExtended1 + DefineBorland + DefineHarbour  + Define32bits).value
   &("Gbl_T_M_LIBS_" + DefineExtended1 + DefineBorland + DefineHarbour  + Define32bits) := WinGSettings.&("TM_LIBS_" + DefineExtended1 + DefineBorland + DefineHarbour  + Define32bits).value
   &("Gbl_T_P_"      + DefineExtended1 + DefineBorland + DefineHarbour  + Define32bits) := WinGSettings.&("TP_"      + DefineExtended1 + DefineBorland + DefineHarbour  + Define32bits).value
   &("Gbl_T_P_LIBS_" + DefineExtended1 + DefineBorland + DefineHarbour  + Define32bits) := WinGSettings.&("TP_LIBS_" + DefineExtended1 + DefineBorland + DefineHarbour  + Define32bits).value

   &("Gbl_T_C_"      + DefineExtended1 + DefineBorland + DefineXHarbour + Define32bits) := WinGSettings.&("TC_"      + DefineExtended1 + DefineBorland + DefineXHarbour + Define32bits).value
   &("Gbl_T_C_LIBS_" + DefineExtended1 + DefineBorland + DefineXHarbour + Define32bits) := WinGSettings.&("TC_LIBS_" + DefineExtended1 + DefineBorland + DefineXHarbour + Define32bits).value
   &("Gbl_T_M_"      + DefineExtended1 + DefineBorland + DefineXHarbour + Define32bits) := WinGSettings.&("TM_"      + DefineExtended1 + DefineBorland + DefineXHarbour + Define32bits).value
   &("Gbl_T_M_LIBS_" + DefineExtended1 + DefineBorland + DefineXHarbour + Define32bits) := WinGSettings.&("TM_LIBS_" + DefineExtended1 + DefineBorland + DefineXHarbour + Define32bits).value
   &("Gbl_T_P_"      + DefineExtended1 + DefineBorland + DefineXHarbour + Define32bits) := WinGSettings.&("TP_"      + DefineExtended1 + DefineBorland + DefineXHarbour + Define32bits).value
   &("Gbl_T_P_LIBS_" + DefineExtended1 + DefineBorland + DefineXHarbour + Define32bits) := WinGSettings.&("TP_LIBS_" + DefineExtended1 + DefineBorland + DefineXHarbour + Define32bits).value

   &("Gbl_T_C_"      + DefineExtended1 + DefineMinGW   + DefineHarbour  + Define32bits) := WinGSettings.&("TC_"      + DefineExtended1 + DefineMinGW   + DefineHarbour  + Define32bits).value
   &("Gbl_T_C_LIBS_" + DefineExtended1 + DefineMinGW   + DefineHarbour  + Define32bits) := WinGSettings.&("TC_LIBS_" + DefineExtended1 + DefineMinGW   + DefineHarbour  + Define32bits).value
   &("Gbl_T_M_"      + DefineExtended1 + DefineMinGW   + DefineHarbour  + Define32bits) := WinGSettings.&("TM_"      + DefineExtended1 + DefineMinGW   + DefineHarbour  + Define32bits).value
   &("Gbl_T_M_LIBS_" + DefineExtended1 + DefineMinGW   + DefineHarbour  + Define32bits) := WinGSettings.&("TM_LIBS_" + DefineExtended1 + DefineMinGW   + DefineHarbour  + Define32bits).value
   &("Gbl_T_P_"      + DefineExtended1 + DefineMinGW   + DefineHarbour  + Define32bits) := WinGSettings.&("TP_"      + DefineExtended1 + DefineMinGW   + DefineHarbour  + Define32bits).value
   &("Gbl_T_P_LIBS_" + DefineExtended1 + DefineMinGW   + DefineHarbour  + Define32bits) := WinGSettings.&("TP_LIBS_" + DefineExtended1 + DefineMinGW   + DefineHarbour  + Define32bits).value

   &("Gbl_T_C_"      + DefineExtended1 + DefineMinGW   + DefineHarbour  + Define64bits) := WinGSettings.&("TC_"      + DefineExtended1 + DefineMinGW   + DefineHarbour  + Define64bits).value
   &("Gbl_T_C_LIBS_" + DefineExtended1 + DefineMinGW   + DefineHarbour  + Define64bits) := WinGSettings.&("TC_LIBS_" + DefineExtended1 + DefineMinGW   + DefineHarbour  + Define64bits).value
   &("Gbl_T_M_"      + DefineExtended1 + DefineMinGW   + DefineHarbour  + Define64bits) := WinGSettings.&("TM_"      + DefineExtended1 + DefineMinGW   + DefineHarbour  + Define64bits).value
   &("Gbl_T_M_LIBS_" + DefineExtended1 + DefineMinGW   + DefineHarbour  + Define64bits) := WinGSettings.&("TM_LIBS_" + DefineExtended1 + DefineMinGW   + DefineHarbour  + Define64bits).value
   &("Gbl_T_P_"      + DefineExtended1 + DefineMinGW   + DefineHarbour  + Define64bits) := WinGSettings.&("TP_"      + DefineExtended1 + DefineMinGW   + DefineHarbour  + Define64bits).value
   &("Gbl_T_P_LIBS_" + DefineExtended1 + DefineMinGW   + DefineHarbour  + Define64bits) := WinGSettings.&("TP_LIBS_" + DefineExtended1 + DefineMinGW   + DefineHarbour  + Define64bits).value

   &("Gbl_T_C_"      + DefineExtended1 + DefineMinGW   + DefineXHarbour + Define32bits) := WinGSettings.&("TC_"      + DefineExtended1 + DefineMinGW   + DefineXHarbour + Define32bits).value
   &("Gbl_T_C_LIBS_" + DefineExtended1 + DefineMinGW   + DefineXHarbour + Define32bits) := WinGSettings.&("TC_LIBS_" + DefineExtended1 + DefineMinGW   + DefineXHarbour + Define32bits).value
   &("Gbl_T_M_"      + DefineExtended1 + DefineMinGW   + DefineXHarbour + Define32bits) := WinGSettings.&("TM_"      + DefineExtended1 + DefineMinGW   + DefineXHarbour + Define32bits).value
   &("Gbl_T_M_LIBS_" + DefineExtended1 + DefineMinGW   + DefineXHarbour + Define32bits) := WinGSettings.&("TM_LIBS_" + DefineExtended1 + DefineMinGW   + DefineXHarbour + Define32bits).value
   &("Gbl_T_P_"      + DefineExtended1 + DefineMinGW   + DefineXHarbour + Define32bits) := WinGSettings.&("TP_"      + DefineExtended1 + DefineMinGW   + DefineXHarbour + Define32bits).value
   &("Gbl_T_P_LIBS_" + DefineExtended1 + DefineMinGW   + DefineXHarbour + Define32bits) := WinGSettings.&("TP_LIBS_" + DefineExtended1 + DefineMinGW   + DefineXHarbour + Define32bits).value

   &("Gbl_T_C_"      + DefineExtended1 + DefineMinGW   + DefineXHarbour + Define64bits) := WinGSettings.&("TC_"      + DefineExtended1 + DefineMinGW   + DefineXHarbour + Define64bits).value
   &("Gbl_T_C_LIBS_" + DefineExtended1 + DefineMinGW   + DefineXHarbour + Define64bits) := WinGSettings.&("TC_LIBS_" + DefineExtended1 + DefineMinGW   + DefineXHarbour + Define64bits).value
   &("Gbl_T_M_"      + DefineExtended1 + DefineMinGW   + DefineXHarbour + Define64bits) := WinGSettings.&("TM_"      + DefineExtended1 + DefineMinGW   + DefineXHarbour + Define64bits).value
   &("Gbl_T_M_LIBS_" + DefineExtended1 + DefineMinGW   + DefineXHarbour + Define64bits) := WinGSettings.&("TM_LIBS_" + DefineExtended1 + DefineMinGW   + DefineXHarbour + Define64bits).value
   &("Gbl_T_P_"      + DefineExtended1 + DefineMinGW   + DefineXHarbour + Define64bits) := WinGSettings.&("TP_"      + DefineExtended1 + DefineMinGW   + DefineXHarbour + Define64bits).value
   &("Gbl_T_P_LIBS_" + DefineExtended1 + DefineMinGW   + DefineXHarbour + Define64bits) := WinGSettings.&("TP_LIBS_" + DefineExtended1 + DefineMinGW   + DefineXHarbour + Define64bits).value

   &("Gbl_T_C_"      + DefineOohg3     + DefineBorland + DefineHarbour  + Define32bits) := WinGSettings.&("TC_"      + DefineOohg3     + DefineBorland + DefineHarbour  + Define32bits).value
   &("Gbl_T_C_LIBS_" + DefineOohg3     + DefineBorland + DefineHarbour  + Define32bits) := WinGSettings.&("TC_LIBS_" + DefineOohg3     + DefineBorland + DefineHarbour  + Define32bits).value
   &("Gbl_T_M_"      + DefineOohg3     + DefineBorland + DefineHarbour  + Define32bits) := WinGSettings.&("TM_"      + DefineOohg3     + DefineBorland + DefineHarbour  + Define32bits).value
   &("Gbl_T_M_LIBS_" + DefineOohg3     + DefineBorland + DefineHarbour  + Define32bits) := WinGSettings.&("TM_LIBS_" + DefineOohg3     + DefineBorland + DefineHarbour  + Define32bits).value
   &("Gbl_T_P_"      + DefineOohg3     + DefineBorland + DefineHarbour  + Define32bits) := WinGSettings.&("TP_"      + DefineOohg3     + DefineBorland + DefineHarbour  + Define32bits).value
   &("Gbl_T_P_LIBS_" + DefineOohg3     + DefineBorland + DefineHarbour  + Define32bits) := WinGSettings.&("TP_LIBS_" + DefineOohg3     + DefineBorland + DefineHarbour  + Define32bits).value

   &("Gbl_T_C_"      + DefineOohg3     + DefineBorland + DefineXHarbour + Define32bits) := WinGSettings.&("TC_"      + DefineOohg3     + DefineBorland + DefineXHarbour + Define32bits).value
   &("Gbl_T_C_LIBS_" + DefineOohg3     + DefineBorland + DefineXHarbour + Define32bits) := WinGSettings.&("TC_LIBS_" + DefineOohg3     + DefineBorland + DefineXHarbour + Define32bits).value
   &("Gbl_T_M_"      + DefineOohg3     + DefineBorland + DefineXHarbour + Define32bits) := WinGSettings.&("TM_"      + DefineOohg3     + DefineBorland + DefineXHarbour + Define32bits).value
   &("Gbl_T_M_LIBS_" + DefineOohg3     + DefineBorland + DefineXHarbour + Define32bits) := WinGSettings.&("TM_LIBS_" + DefineOohg3     + DefineBorland + DefineXHarbour + Define32bits).value
   &("Gbl_T_P_"      + DefineOohg3     + DefineBorland + DefineXHarbour + Define32bits) := WinGSettings.&("TP_"      + DefineOohg3     + DefineBorland + DefineXHarbour + Define32bits).value
   &("Gbl_T_P_LIBS_" + DefineOohg3     + DefineBorland + DefineXHarbour + Define32bits) := WinGSettings.&("TP_LIBS_" + DefineOohg3     + DefineBorland + DefineXHarbour + Define32bits).value

   &("Gbl_T_C_"      + DefineOohg3     + DefineMinGW   + DefineHarbour  + Define32bits) := WinGSettings.&("TC_"      + DefineOohg3     + DefineMinGW   + DefineHarbour  + Define32bits).value
   &("Gbl_T_C_LIBS_" + DefineOohg3     + DefineMinGW   + DefineHarbour  + Define32bits) := WinGSettings.&("TC_LIBS_" + DefineOohg3     + DefineMinGW   + DefineHarbour  + Define32bits).value
   &("Gbl_T_M_"      + DefineOohg3     + DefineMinGW   + DefineHarbour  + Define32bits) := WinGSettings.&("TM_"      + DefineOohg3     + DefineMinGW   + DefineHarbour  + Define32bits).value
   &("Gbl_T_M_LIBS_" + DefineOohg3     + DefineMinGW   + DefineHarbour  + Define32bits) := WinGSettings.&("TM_LIBS_" + DefineOohg3     + DefineMinGW   + DefineHarbour  + Define32bits).value
   &("Gbl_T_P_"      + DefineOohg3     + DefineMinGW   + DefineHarbour  + Define32bits) := WinGSettings.&("TP_"      + DefineOohg3     + DefineMinGW   + DefineHarbour  + Define32bits).value
   &("Gbl_T_P_LIBS_" + DefineOohg3     + DefineMinGW   + DefineHarbour  + Define32bits) := WinGSettings.&("TP_LIBS_" + DefineOohg3     + DefineMinGW   + DefineHarbour  + Define32bits).value

   &("Gbl_T_C_"      + DefineOohg3     + DefineMinGW   + DefineHarbour  + Define64bits) := WinGSettings.&("TC_"      + DefineOohg3     + DefineMinGW   + DefineHarbour  + Define64bits).value
   &("Gbl_T_C_LIBS_" + DefineOohg3     + DefineMinGW   + DefineHarbour  + Define64bits) := WinGSettings.&("TC_LIBS_" + DefineOohg3     + DefineMinGW   + DefineHarbour  + Define64bits).value
   &("Gbl_T_M_"      + DefineOohg3     + DefineMinGW   + DefineHarbour  + Define64bits) := WinGSettings.&("TM_"      + DefineOohg3     + DefineMinGW   + DefineHarbour  + Define64bits).value
   &("Gbl_T_M_LIBS_" + DefineOohg3     + DefineMinGW   + DefineHarbour  + Define64bits) := WinGSettings.&("TM_LIBS_" + DefineOohg3     + DefineMinGW   + DefineHarbour  + Define64bits).value
   &("Gbl_T_P_"      + DefineOohg3     + DefineMinGW   + DefineHarbour  + Define64bits) := WinGSettings.&("TP_"      + DefineOohg3     + DefineMinGW   + DefineHarbour  + Define64bits).value
   &("Gbl_T_P_LIBS_" + DefineOohg3     + DefineMinGW   + DefineHarbour  + Define64bits) := WinGSettings.&("TP_LIBS_" + DefineOohg3     + DefineMinGW   + DefineHarbour  + Define64bits).value

   &("Gbl_T_C_"      + DefineOohg3     + DefineMinGW   + DefineXHarbour + Define32bits) := WinGSettings.&("TC_"      + DefineOohg3     + DefineMinGW   + DefineXHarbour + Define32bits).value
   &("Gbl_T_C_LIBS_" + DefineOohg3     + DefineMinGW   + DefineXHarbour + Define32bits) := WinGSettings.&("TC_LIBS_" + DefineOohg3     + DefineMinGW   + DefineXHarbour + Define32bits).value
   &("Gbl_T_M_"      + DefineOohg3     + DefineMinGW   + DefineXHarbour + Define32bits) := WinGSettings.&("TM_"      + DefineOohg3     + DefineMinGW   + DefineXHarbour + Define32bits).value
   &("Gbl_T_M_LIBS_" + DefineOohg3     + DefineMinGW   + DefineXHarbour + Define32bits) := WinGSettings.&("TM_LIBS_" + DefineOohg3     + DefineMinGW   + DefineXHarbour + Define32bits).value
   &("Gbl_T_P_"      + DefineOohg3     + DefineMinGW   + DefineXHarbour + Define32bits) := WinGSettings.&("TP_"      + DefineOohg3     + DefineMinGW   + DefineXHarbour + Define32bits).value
   &("Gbl_T_P_LIBS_" + DefineOohg3     + DefineMinGW   + DefineXHarbour + Define32bits) := WinGSettings.&("TP_LIBS_" + DefineOohg3     + DefineMinGW   + DefineXHarbour + Define32bits).value

   &("Gbl_T_C_"      + DefineOohg3     + DefineMinGW   + DefineXHarbour + Define64bits) := WinGSettings.&("TC_"      + DefineOohg3     + DefineMinGW   + DefineXHarbour + Define64bits).value
   &("Gbl_T_C_LIBS_" + DefineOohg3     + DefineMinGW   + DefineXHarbour + Define64bits) := WinGSettings.&("TC_LIBS_" + DefineOohg3     + DefineMinGW   + DefineXHarbour + Define64bits).value
   &("Gbl_T_M_"      + DefineOohg3     + DefineMinGW   + DefineXHarbour + Define64bits) := WinGSettings.&("TM_"      + DefineOohg3     + DefineMinGW   + DefineXHarbour + Define64bits).value
   &("Gbl_T_M_LIBS_" + DefineOohg3     + DefineMinGW   + DefineXHarbour + Define64bits) := WinGSettings.&("TM_LIBS_" + DefineOohg3     + DefineMinGW   + DefineXHarbour + Define64bits).value
   &("Gbl_T_P_"      + DefineOohg3     + DefineMinGW   + DefineXHarbour + Define64bits) := WinGSettings.&("TP_"      + DefineOohg3     + DefineMinGW   + DefineXHarbour + Define64bits).value
   &("Gbl_T_P_LIBS_" + DefineOohg3     + DefineMinGW   + DefineXHarbour + Define64bits) := WinGSettings.&("TP_LIBS_" + DefineOohg3     + DefineMinGW   + DefineXHarbour + Define64bits).value

   &("Gbl_T_C_"      + DefineOohg3     + DefinePelles  + DefineHarbour  + Define32bits) := WinGSettings.&("TC_"      + DefineOohg3     + DefinePelles  + DefineHarbour  + Define32bits).value
   &("Gbl_T_C_LIBS_" + DefineOohg3     + DefinePelles  + DefineHarbour  + Define32bits) := WinGSettings.&("TC_LIBS_" + DefineOohg3     + DefinePelles  + DefineHarbour  + Define32bits).value
   &("Gbl_T_M_"      + DefineOohg3     + DefinePelles  + DefineHarbour  + Define32bits) := WinGSettings.&("TM_"      + DefineOohg3     + DefinePelles  + DefineHarbour  + Define32bits).value
   &("Gbl_T_M_LIBS_" + DefineOohg3     + DefinePelles  + DefineHarbour  + Define32bits) := WinGSettings.&("TM_LIBS_" + DefineOohg3     + DefinePelles  + DefineHarbour  + Define32bits).value
   &("Gbl_T_P_"      + DefineOohg3     + DefinePelles  + DefineHarbour  + Define32bits) := WinGSettings.&("TP_"      + DefineOohg3     + DefinePelles  + DefineHarbour  + Define32bits).value
   &("Gbl_T_P_LIBS_" + DefineOohg3     + DefinePelles  + DefineHarbour  + Define32bits) := WinGSettings.&("TP_LIBS_" + DefineOohg3     + DefinePelles  + DefineHarbour  + Define32bits).value

   &("Gbl_T_C_"      + DefineOohg3     + DefinePelles  + DefineHarbour  + Define64bits) := WinGSettings.&("TC_"      + DefineOohg3     + DefinePelles  + DefineHarbour  + Define64bits).value
   &("Gbl_T_C_LIBS_" + DefineOohg3     + DefinePelles  + DefineHarbour  + Define64bits) := WinGSettings.&("TC_LIBS_" + DefineOohg3     + DefinePelles  + DefineHarbour  + Define64bits).value
   &("Gbl_T_M_"      + DefineOohg3     + DefinePelles  + DefineHarbour  + Define64bits) := WinGSettings.&("TM_"      + DefineOohg3     + DefinePelles  + DefineHarbour  + Define64bits).value
   &("Gbl_T_M_LIBS_" + DefineOohg3     + DefinePelles  + DefineHarbour  + Define64bits) := WinGSettings.&("TM_LIBS_" + DefineOohg3     + DefinePelles  + DefineHarbour  + Define64bits).value
   &("Gbl_T_P_"      + DefineOohg3     + DefinePelles  + DefineHarbour  + Define64bits) := WinGSettings.&("TP_"      + DefineOohg3     + DefinePelles  + DefineHarbour  + Define64bits).value
   &("Gbl_T_P_LIBS_" + DefineOohg3     + DefinePelles  + DefineHarbour  + Define64bits) := WinGSettings.&("TP_LIBS_" + DefineOohg3     + DefinePelles  + DefineHarbour  + Define64bits).value

   &("Gbl_T_C_"      + DefineOohg3     + DefinePelles  + DefineXHarbour + Define32bits) := WinGSettings.&("TC_"      + DefineOohg3     + DefinePelles  + DefineXHarbour + Define32bits).value
   &("Gbl_T_C_LIBS_" + DefineOohg3     + DefinePelles  + DefineXHarbour + Define32bits) := WinGSettings.&("TC_LIBS_" + DefineOohg3     + DefinePelles  + DefineXHarbour + Define32bits).value
   &("Gbl_T_M_"      + DefineOohg3     + DefinePelles  + DefineXHarbour + Define32bits) := WinGSettings.&("TM_"      + DefineOohg3     + DefinePelles  + DefineXHarbour + Define32bits).value
   &("Gbl_T_M_LIBS_" + DefineOohg3     + DefinePelles  + DefineXHarbour + Define32bits) := WinGSettings.&("TM_LIBS_" + DefineOohg3     + DefinePelles  + DefineXHarbour + Define32bits).value
   &("Gbl_T_P_"      + DefineOohg3     + DefinePelles  + DefineXHarbour + Define32bits) := WinGSettings.&("TP_"      + DefineOohg3     + DefinePelles  + DefineXHarbour + Define32bits).value
   &("Gbl_T_P_LIBS_" + DefineOohg3     + DefinePelles  + DefineXHarbour + Define32bits) := WinGSettings.&("TP_LIBS_" + DefineOohg3     + DefinePelles  + DefineXHarbour + Define32bits).value

   &("Gbl_T_C_"      + DefineOohg3     + DefinePelles  + DefineXHarbour + Define64bits) := WinGSettings.&("TC_"      + DefineOohg3     + DefinePelles  + DefineXHarbour + Define64bits).value
   &("Gbl_T_C_LIBS_" + DefineOohg3     + DefinePelles  + DefineXHarbour + Define64bits) := WinGSettings.&("TC_LIBS_" + DefineOohg3     + DefinePelles  + DefineXHarbour + Define64bits).value
   &("Gbl_T_M_"      + DefineOohg3     + DefinePelles  + DefineXHarbour + Define64bits) := WinGSettings.&("TM_"      + DefineOohg3     + DefinePelles  + DefineXHarbour + Define64bits).value
   &("Gbl_T_M_LIBS_" + DefineOohg3     + DefinePelles  + DefineXHarbour + Define64bits) := WinGSettings.&("TM_LIBS_" + DefineOohg3     + DefinePelles  + DefineXHarbour + Define64bits).value
   &("Gbl_T_P_"      + DefineOohg3     + DefinePelles  + DefineXHarbour + Define64bits) := WinGSettings.&("TP_"      + DefineOohg3     + DefinePelles  + DefineXHarbour + Define64bits).value
   &("Gbl_T_P_LIBS_" + DefineOohg3     + DefinePelles  + DefineXHarbour + Define64bits) := WinGSettings.&("TP_LIBS_" + DefineOohg3     + DefinePelles  + DefineXHarbour + Define64bits).value

   SaveEnvironment( lDefaultFile )
Return .T.

/* eof */
