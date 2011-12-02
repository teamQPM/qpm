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

#ifdef QPM_HOTRECOVERY

//#define __HOTTRACE__
#ifdef __HOTTRACE__
   #translate $US_Log()  => US_Log( Procname( 1 ) + "(" + alltrim( str( procline( 1 ) ) ) + ")" , .F. )
#else
   #translate $US_Log()  => //
#endif

#define B_SYSOUT_YES           .T.
#define B_SYSOUT_NO            .F.

#define B_COMPARE_YES          .T.
#define B_COMPARE_NO           .F.

#define SORT_VERSIONS          SortHea     // Aqui podria ir SortHea o SortPan, es decir algun sort que no freeze la primera row como hace SortPRG

Function QPM_HotRecoveryBuscoCod()
   $US_Log()
   DBGoBottom()                   // revisar esto  pepe
Return ( HR_COD + 1 )             // revisar esto  pepe

Function QPM_HotInitPublicVariables()
   $US_Log()
   PUBLIC QPM_HR_Database := ""
   PUBLIC HR_nLookTimeOut      := 20  // Seconds()
   PUBLIC HR_nVersionsDefault := 100 // Versiones a Conservar
   PUBLIC HR_nVersionsDigitosMax := 5 // Maximo de digitos para cantidad de versiones a guardar
   PUBLIC HR_nVersionsMinimun := 50 // Minimo de versiones a guardar
   PUBLIC HR_nVersionsSet      := HR_nVersionsDefault
   PUBLIC HR_nLimitForPack     := 75  // Cantidad de Registros deleteados antes de hacer pack
   PUBLIC HR_nRadioFileSysOut := 1
   PUBLIC HR_nRadioFileType := 1
   PUBLIC HR_nRadioFileFrom := 1
   PUBLIC HR_nRadioFileTarget := 1
   PUBLIC HR_cMemoFrom := ""
   PUBLIC HR_cMemoFromVersionsPRG := ""
   PUBLIC HR_cMemoFromVersionsHEA := ""
   PUBLIC HR_cMemoFromVersionsPAN := ""
   PUBLIC HR_cMemoFromExternal := ""
   PUBLIC HR_cMemoTarget := ""
   PUBLIC HR_cMemoTargetItemPRG := ""
   PUBLIC HR_cMemoTargetItemHEA := ""
   PUBLIC HR_cMemoTargetItemPAN := ""
   PUBLIC HR_cMemoTargetVersionsPRG := ""
   PUBLIC HR_cMemoTargetVersionsHEA := ""
   PUBLIC HR_cMemoTargetVersionsPAN := ""
   PUBLIC HR_cNameFrom := ""
   PUBLIC HR_cNameTarget := ""
   PUBLIC HR_cLastExternalFileName := ""
   PUBLIC HR_bWinHotRecoveryMinimized := .F.
   PUBLIC HR_cHotItemType := "PRG"
   PUBLIC HR_bSuspendChangeGrid := .F.
   PUBLIC HR_cCompareFileOutput := ""
   PUBLIC HR_aColorBackVersionsFrom := {255,255,128}
// PUBLIC HR_aColorBackVersionsTarget := {255,128,159}
// PUBLIC HR_aColorBackVersionsTarget := {219,219,219}
   PUBLIC HR_aColorBackVersionsTarget := {218,194,146}
   PUBLIC HR_aColorBackCompare := DEF_COLORWHITE
   PUBLIC HR_nActualDiff := 0
   PUBLIC HR_nTotalDiff := 0
   PUBLIC HR_cFocus := ""
   PUBLIC HR_bNumberOnPRG := .T.
   PUBLIC HR_bNumberOnHEA := .T.
   PUBLIC HR_bNumberOnPAN := .T.
   if len( alltrim( str( HR_nVersionsSet ) ) ) > HR_nVersionsDigitosMax
      US_Log( "Error in character lenght for HR_nVersionsSet" )
      Return .F.
   endif
// =============================================================================
// For images in Grid
   PUBLIC HotPUB_nGridImgNone   := 0
   PUBLIC HotGridImgComment     := 1
   PUBLIC HotGridImgFrom        := 2
   PUBLIC HotGridImgTarget      := 3
   PUBLIC HotGridImgFromComment := 4
   PUBLIC HotGridImgTargetComment := 5
   PUBLIC nHotPUB_nGridImgTop  := 5  /* igual a la ultima variable HotGridImg... */
   //
   PUBLIC vHotImagesGrid       := {}
   aadd( vHotImagesGrid , 'GridNone' )                     // 0        0            0000 0000
   aadd( vHotImagesGrid , 'GridHotComment')                // 1        1            0000 0001
   aadd( vHotImagesGrid , 'GridHotFrom')                   // 2        2            0000 0010
   aadd( vHotImagesGrid , 'GridHotFromComment')            // 3        3            0000 0011
   aadd( vHotImagesGrid , 'GridHotTarget')                 // 4        4            0000 0100
   aadd( vHotImagesGrid , 'GridHotTargetComment')          // 5        5            0000 0101
   PUBLIC vHotImagesTranslateGrid := {}
   /* Para representar 256 pongo 23 */
   aadd( vHotImagesTranslateGrid , { 0 ,  0 } )
   aadd( vHotImagesTranslateGrid , { 1 ,  1 } )
   aadd( vHotImagesTranslateGrid , { 2 ,  2 } )
   aadd( vHotImagesTranslateGrid , { 3 ,  3 } )
   aadd( vHotImagesTranslateGrid , { 4 ,  4 } )
   aadd( vHotImagesTranslateGrid , { 5 ,  5 } )
// =============================================================================
Return .T.

Function QPM_HotRecovery( cFun , cSubFun , cType , cFileName , cRecoveryFile )
   Local OPEN_nSecondsInit := Seconds()
   Local OPEN_cOldTxt := ""
   Local OPEN_cAreaOld := ""
   Local cMemoFileTxt := "" , cMemoFileZip := ""
   Local bZipFileError := .F. , bZipFileLong := .F.
   Local bZipDataError := .F. , bZipDataLong := .T.         // Cambiar a .F. cuando se implemente el zipeado y adaptar la funcion HotPutComment()
   Local nNewCod := 0 , cRecoveryFileZip := US_FileNameOnlyPathAndName( cRecoveryFile ) + "_Hot.zip"
   Local cHash               := HB_MD5( US_Upper( US_FileNameOnlyNameAndExt( cFileName ) ) )
   $US_Log()
//if empty( US_FileNameOnlyPathAndName( cRecoveryFile ) )
//us_log( "cRecoveryFile is empty: " + cRecoveryFile )
//endif
   do case
      case cFun == "ADD"
         OPEN_cAreaOld := dbf()
         OPEN_cOldTxt := GetMGWaitTxt()
         Do While !US_DBUseArea( .T. , "DBFCDX" , QPM_HR_Database , "HOTREC" , DEF_DBF_EXCLUSIVE , DEF_DBF_WRITE ) .and. ( seconds() - OPEN_nSecondsInit ) < HR_nLookTimeOut
            SetMGWaitTxt( "Waiting for Hot Recovery Database: " + alltrim( str( int( HR_nLookTimeOut - ( seconds() - OPEN_nSecondsInit ) ) ) ) + " seconds..." )
            DO EVENTS
         enddo
         SetMGWaitTxt( OPEN_cOldTxt )
         if dbf() == "HOTREC"
            nNewCod := QPM_HotRecoveryBuscoCod()
            DBAppend()
            // HB_ZipFile( <cFile>, <cFileToCompress> | <aFiles>, <nLevel>, <bBlock>, <lOverwrite>, <cPassword>, <lWithPath>, <lWithDrive>, <pFileProgress> ) --> lCompress
    us_log( "INI - ZIIIIIIIIIIIIIIIIP" , .F. )
    us_log( hb_osnewline() + cRecoveryFileZip + hb_osnewline() + cRecoveryFile , .F. )
    us_log( hb_osnewline() + us_todostr( file( cRecoveryFileZip ) ) + hb_osnewline() + us_todostr( file( cRecoveryFile ) ) , .F. )
    us_log( hb_osnewline() + us_todostr( us_filesize( cRecoveryFileZip ) ) + hb_osnewline() + us_todostr( us_filesize( cRecoveryFile ) ) , .F. )
    us_log( "END - ZIIIIIIIIIIIIIIIIP" , .F. )
            if !HB_ZipFile( cRecoveryFileZip , cRecoveryFile )
//  us_log( "error" )
               bZipFileError := .T.
               US_Log( "Create RecoveryFileZip Error, no action requered" , .F. )
            else
//  us_log( "ok   " )
               cMemoFileTxt := MemoRead( cRecoveryFile )
               cMemoFileZip := MemoRead( cRecoveryFileZip )
               if at( '\\#' , cMemoFileZip ) > 0  // esto es para evitar SIEMPRE la doble busqueda, entonces solo se busca dos veces si aparece '\\#'
                  if at( '\\#26//' , cMemoFileZip ) > 0
                     bZipFileError := .T.
                  else
                     if at( '\\#00//' , cMemoFileZip ) > 0
                        bZipFileError := .T.
                     endif
                  endif
               endif
            endif
            if !bZipFileError
               cMemoFileZip := US_MaskBinData( cMemoFileZip )
               if len( cMemoFileTxt ) <= len( cMemoFileZip )
                  bZipFileLong := .T.
               endif
            endif
            REPLACE HR_COD     With nNewCod , ;
                    HR_HASH    With cHash , ;
                    HR_SECU    With 0 , ;
                    HR_DATA_TY With if( bZipDataError .or. bZipDataLong , "T" , "Z" ) , ;
                    HR_DATA    With "FUNCTION " + cSubFun + HB_OsNewLine() + ;
                                    "FULLNAME " + ChgPathToReal( cFileName ) + HB_OsNewLine() + ;
                                    "RELATIVENAME " + cFileName + HB_OsNewLine() + ;
                                    "FILE_TYPE " + cType + HB_OsNewLine() + ;
                                    "FILE_DATETIME " + DToS( US_FileDate( cRecoveryFile ) ) + US_StrCero( US_TimeSec( US_FileTime( cRecoveryFile ) ) , 5 ) + HB_OsNewLine() + ;
                                    "VERSION_DATETIME " + US_DateSeconds() + HB_OsNewLine() + ;
                                    "VERSION_COMPUTER " + US_GetComputerName() + HB_OsNewLine() + ;
                                    "VERSION_USER " + US_GetUserName() , ;
                    HR_FILE_TY With if( bZipFileError .or. bZipFileLong , "T" , "Z" ) , ;
                    HR_FILE    With if( bZipFileError .or. bZipFileLong , cMemoFileTxt , cMemoFileZip )
            // INI ONLY FOR TEST
            if .F.
               if !bZipFileError .and. !bZipFileLong
                  QPM_MemoWrit( cRecoveryFileZip + "TesT" , US_UnMaskBinData( HR_FILE ) )
                  HB_UNZIPFILE( cRecoveryFileZip + "TesT" , , .T. , , US_FileNameOnlyPath( cRecoveryFile ) + DEF_SLASH + "ZipTest" , "*.*" )
                  if !( memoread( cRecoveryFile ) == memoread( US_FileNameOnlyPath( cRecoveryFile ) + DEF_SLASH + "ZipTest" + DEF_SLASH + US_FileNameOnlyNameAndExt( CrecoveryFile ) ) )
                     US_Log( "Fallo en test de zip file for HotRecovery" )
                  endif
                  ferase( cRecoveryFileZip + "TesT" )
                  ferase( US_FileNameOnlyPath( cRecoveryFile ) + DEF_SLASH + "ZipTest" + DEF_SLASH + US_FileNameOnlyNameAndExt( CrecoveryFile ) )
                  US_DirRemoveLoop( US_FileNameOnlyPath( cRecoveryFile ) + DEF_SLASH + "ZipTest" , 3 )
               endif
            endif
            // FIN ONLY FOR TEST
            ferase( cRecoveryFile )
            ferase( cRecoveryFileZip )
            QPM_HotRecoveryDecalaje( "HR_SECU" , "HR_HASH" , cHash )
            QPM_HotRecoveryClear( "HR_SECU" , HR_nVersionsSet )
            DBCloseArea( "HOTREC" )
         else
            ferase( cRecoveryFile )
            US_Log( "Error in Open Exclusive for DBF HotRecovery Database: " + QPM_HR_Database + HB_OsNewLine() + ;
                    "No version saved for this source" + HB_OsNewLine() + ;
                    "Free Hot Recovery Database and/or reinit all QPM instances" )
         endif
         if !empty( OPEN_cAreaOld )
            DBSelectArea( OPEN_cAreaOld )
         endif
      otherwise
         US_Log( "Invalid Function: " + us_todostr( cFun ) )
   endcase
Return nNewCod

Function QPM_HotRecoveryDecalaje( cCampo , cHash , hHash )
   $US_Log()
   REPLACE &( cCampo ) With ( &( cCampo ) + 1 ) FOR &( cHash ) == hHash
// OrdSetFocus( cHash + "01" )
// us_log( hb_osNewLine() + hHash + Replicate( "0" , HR_nVersionsDigitosMax ) + HB_OsNewLine() + ;
//        hHash + US_StrCero( HR_nVersionsSet , HR_nVersionsDigitosMax ) )
//   OrdScope( 0 , hHash + Replicate( "0" , HR_nVersionsDigitosMax ) )
//   OrdScope( 1 , hHash + US_StrCero( HR_nVersionsSet , HR_nVersionsDigitosMax ) )
//   DBGoTop()
//   REPLACE &( cCampo ) With ( &( cCampo ) + 1 ) ALL
//   OrdScope( 0 , NIL )
//   OrdScope( 1 , NIL )
Return .T.

Function QPM_HotRecoveryClear( cCampo , nLimit )
   Local nRecords := 0
   $US_Log()
   DELETE ALL FOR &( cCampo ) > nLimit
   COUNT TO nRecords
   if ( LastRec() - nRecords ) > HR_nLimitForPack
      PACK
   endif
Return .T.

Function QPM_HotRecoveryMenu()
   $US_Log()
   Local cOldRegPath := ""
   Local cOldRegPathDif := .F.
   If Empty( PUB_cProjectFile )
      MsgStop( 'You must open project first.' )
      Return .F.
   EndIf
   if GetProperty( "VentanaMain" , "GPrgFiles" , "ItemCount" ) < 1
      MsgStop( 'You PRG file list is empty.' )
      Return .F.
   EndIf

   if .F.   // suspendido mientras se use ventana MODAL
      if HR_bWinHotRecoveryMinimized
         DoMethod( "WinHotRecovery" , "restore" )
         Return .T.
      else
         if _IsWindowDefined( "WinHotRecovery" )
            DoMethod( "WinHotRecovery" , "setfocus" )
            Return .T.
         endif
      endif
   endif

   Private oW_HTML
   Private o_HTML

   cOldRegPath := US_GetReg( HKEY_CURRENT_USER , "Software\ComponentSoftware\CSDiff" , "CSDiffPath" )
   if !( US_Upper( alltrim( cOldRegPath ) ) == US_Upper( alltrim( PUB_cQPM_Folder ) ) )
      US_SetReg( HKEY_CURRENT_USER , "Software\ComponentSoftware\CSDiff" , "CSDiffPath" , PUB_cQPM_Folder )
      cOldRegPathDif := .T.
   endif

//   DEFINE WINDOW WinHotRecovery ;
//          AT 0 , 0 ;
//          WIDTH GetDesktopRealWidth() - 100 ;
//          HEIGHT GetDesktopRealHeight() - 100 ;
//          ICON "us_hot.oci" ;
//          NOSIZE ;
//          TITLE "Hot Recovery for QPM projects" ;
//          ON INIT QPM_Wait( "QPM_HotRecoveryInit()" , "Loading ..." ) ;
//          ON RELEASE QPM_HotRelease() ;
//          ON INTERACTIVECLOSE US_NOP() ;
//          ON MINIMIZE HR_bWinHotRecoveryMinimized := .T. ;
//          ON RESTORE HR_bWinHotRecoveryMinimized := .F.

   DEFINE WINDOW WinHotRecovery ;
         AT 25 , 25 ;
         WIDTH GetDesktopRealWidth() - 50 ;
         HEIGHT GetDesktopRealHeight() - 50 ;
         ICON "XHOTRECOVERY" ;
         TITLE "Hot Recovery for QPM projects" ;
         MODAL ;
         NOSIZE ;
         ON INIT QPM_Wait( "QPM_HotRecoveryInit()" , "Loading ..." ) ;
         ON RELEASE QPM_HotRelease() ;
         ON INTERACTIVECLOSE US_NOP()

 //   ON KEY ESCAPE OF WinHotRecovery ACTION DoMethod( "WinHotRecovery" , "minimize" )
      ON KEY ESCAPE OF WinHotRecovery ACTION DoMethod( "WinHotRecovery" , "release" )

      @ 07 , 05 FRAME FrameType ;
         WIDTH 347 ;
         HEIGHT 40 ;
         OPAQUE

      @ 15 , 50 RADIOGROUP HR_FileType ;
         OPTIONS { 'Sources' , 'Headers' , 'Forms' } ;
         WIDTH 70 ;
         VALUE HR_nRadioFileType ;
         TOOLTIP "Select Type Object for Recovery or Compare" ;
         ON CHANGE QPM_HotChangeType() ;
         HORIZONTAL

      @ 07 , 365 FRAME FrameSysOut ;
         WIDTH ( GetProperty( "WinHotRecovery" , "width" ) - 375 ) ;
         HEIGHT 40 ;
         OPAQUE

     //  WIDTH 200 ;
      @ 15 , 400 RADIOGROUP HR_FileSysOut ;
         OPTIONS if( PUB_bW800 , { 'Compared' , '"From"/"Base"' , '"Target"/"New"' } , { 'View Compared Files' , 'View Only "From"/"Base"' , 'View Only "Target"/"New"' } ) ;
         WIDTH ( ( GetProperty( "WinHotRecovery" , "Width" ) - 400 ) / if( PUB_bW800 , 3.7 , 3.4 ) ) ;
         VALUE HR_nRadioFileSysout ;
         TOOLTIP "Select View" ;
         ON CHANGE QPM_HotChangeSysOut( B_COMPARE_YES ) ;
         HORIZONTAL

      @ 55 , 05 FRAME FrameHotRecovery ;
         WIDTH ( GetProperty( "WinHotRecovery" , "width" ) - 15 ) ;
         HEIGHT ( GetProperty( "WinHotRecovery" , "height" ) - 90 ) ;
         OPAQUE

      @ 75, 365 RICHEDITBOX HR_RichEdit ;
              WIDTH           GetProperty( "WinHotRecovery" , "width" ) - 390 ;
              HEIGHT          GetProperty( "WinHotRecovery" , "height" ) - 126 ;
              READONLY        ;
              FONT            'Courier New' ;
              SIZE            9

      SetProperty( "WinHotRecovery" , "HR_RichEdit" , "visible" , .F. )

      DEFINE LABEL LHR_ComboNavigatePos
              ROW             80
              COL             367
              WIDTH           140
              VALUE           "Go To Diference #"
              FONTBOLD        .T.
              FONTCOLOR       DEF_COLORBLUE
              FONTSIZE        10
              TRANSPARENT     if( IsXPThemeActive() , .T. , .F. )
      END LABEL

      @ 77 , 490 COMBOBOX CHR_GoToPos ;
         ITEMS {} ;
         VALUE 1 ;
         WIDTH 70 ;
         HEIGHT 200 ;
         TOOLTIP "Go to Difference number..." ;
         ON CHANGE HotNavigate( HR_nActualDiff := ( GetProperty( "WinHotRecovery" , "CHR_GoToPos" , "value" ) - 1 ) )

      DEFINE BUTTON BHR_NavigatePrev
              ROW             75
              COL             570
              WIDTH           25
              HEIGHT          25
              PICTURE         "UP"
              TOOLTIP         "Go to previous difference"
              ONCLICK         HotNavigate( --HR_nActualDiff )
      END BUTTON

      DEFINE BUTTON BHR_NavigateNext
              ROW             75
              COL             600
              WIDTH           25
              HEIGHT          25
              PICTURE         "DOWN"
              TOOLTIP         "Go to next difference"
              ONCLICK         HotNavigate( ++HR_nActualDiff )
      END BUTTON

      DEFINE LABEL LHR_NavigatePos
              ROW             80
              COL             640
              WIDTH           290
              VALUE           ""
              FONTBOLD        .T.
              FONTCOLOR       DEF_COLORBLUE
              FONTSIZE        14
              TRANSPARENT     if( IsXPThemeActive() , .T. , .F. )
      END LABEL

      @ 115 - 2 , 365 - 2 FRAME FrameActiveX ;
         WIDTH ( GetProperty( "WinHotRecovery" , "width" ) - 390 ) + 4 ;
         HEIGHT ( GetProperty( "WinHotRecovery" , "height" ) - 166 ) + 4

      oW_HTML := TActiveX():New( "WinHotRecovery" , "Shell.Explorer.2" , 115 , 365 , GetProperty( "WinHotRecovery" , "width" ) - 390 , GetProperty( "WinHotRecovery" , "height" ) - 166 )
      o_HTML := oW_HTML:Load()

      // ---------

      @ 70 , 18 FRAME FrameHotRecoveryFileFrom ;
         CAPTION "" ;
         WIDTH 334 ;
         HEIGHT ( ( ( GetProperty( "WinHotRecovery" , "height" ) / 2 ) - 70 ) - 17 ) ;
         SIZE 12 ;
         BOLD ITALIC ;
         FONTCOLOR {255,0,0} ;
         OPAQUE

      @ 100 , 50 RADIOGROUP HR_FileFrom ;
         OPTIONS { 'Hot Recovery Versions Database' , 'External File' } ;
         WIDTH 215 ;
         VALUE HR_nRadioFileFrom ;
         TOOLTIP "Select File 'From' for Hot Recovery or 'Base' for Compare" ;
         ON CHANGE QPM_HotChangeFrom()

      DEFINE BUTTON B_CommentFrom
             ROW             130
             COL             265
             WIDTH           80
             HEIGHT          25
             CAPTION         "Comment"
             TOOLTIP         "Add / Modify / Remove Version's Comments"
             ONCLICK         HotGetComment( "FROM" )
      END BUTTON

      DEFINE LABEL LHR_ExternalFileFrom
              ROW             if( PUB_bW800 , 162 , 192 )
              COL             40
              WIDTH           290
              VALUE           "File 'From' for Hot Recovery or 'Base' for Compare:"
              TRANSPARENT     if( IsXPThemeActive() , .T. , .F. )
      END LABEL

      DEFINE TEXTBOX THR_ExternalFileFrom
              ROW             if( PUB_bW800 , 180 , 220 )
              COL             25
              WIDTH           270
              ONLOSTFOCUS     QPM_HotChangeExternal()
      END TEXTBOX

      DEFINE BUTTON BHR_ExternalFileFrom
              ROW             if( PUB_bW800 , 180 , 220 )
              COL             300
              WIDTH           25
              HEIGHT          25
              PICTURE         "folderselect"
              TOOLTIP         "Select File 'From' for Hot Recovery or 'Base' for Compare"
              ONCLICK         If ( !Empty( HR_cLastExternalFileName := BugGetFile( { {'All files','*.*'} } , 'Select File' , US_FileNameOnlyPath( GetProperty( "WinHotRecovery" , "THR_ExternalFileFrom" , "value" ) ) , .F. , .T. ) ) , ( SetProperty( "WinHotRecovery" , "THR_ExternalFileFrom" , "value" , HR_cLastExternalFileName ) , QPM_HotChangeExternal() ) , )
      END BUTTON

      SetProperty( "WinHotRecovery" , "LHR_ExternalFileFrom" , "visible" , .F. )
      SetProperty( "WinHotRecovery" , "THR_ExternalFileFrom" , "visible" , .F. )
      SetProperty( "WinHotRecovery" , "BHR_ExternalFileFrom" , "visible" , .F. )

      @ 167, 25 GRID HR_GridVersionsFromPRG ;
         WIDTH 320 ;
         HEIGHT ( ( ( GetProperty( "WinHotRecovery" , "height" ) / 2 ) - 167 ) - 23 ) ;
         HEADERS { 'S' , 'Ver' , 'File Date Time' , 'Version Created at' , 'Comment' , 'Source Relative Name' , 'Source Full Name' , 'Version Created on' , 'Version Created by' , 'Code' , 'Offset' } ;
         WIDTHS { 20 , 20 , 100 , 100 , 10 , 1000 , 1000 , 20 , 20 , 20 , 20 };
         ITEMS {} ;
         VALUE 1 ;
         IMAGE vHotImagesGrid ;
         TOOLTIP '' ;
         BACKCOLOR HR_aColorBackVersionsFrom ;
         ON HEADCLICK { {||SORT_VERSIONS( "WinHotRecovery" , "HR_GridVersionsFromPRG" ,1)} , {||SORT_VERSIONS( "WinHotRecovery" , "HR_GridVersionsFromPRG" ,2)} , {||SORT_VERSIONS( "WinHotRecovery" , "HR_GridVersionsFromPRG" ,3)} , {||SORT_VERSIONS( "WinHotRecovery" , "HR_GridVersionsFromPRG" ,4)} } ;
         ON DBLCLICK { HotGetComment( "FROM" ) } ;
         ON CHANGE { || if( !bPrgSorting .and. !PUB_bLite , if( HR_bNumberOnPrg , QPM_Wait( "QPM_HotChangeGrid( 'FROM' , 'VERSIONS' , 'PRG' )" , "Comparing ..." ) , QPM_HotChangeGrid( 'FROM' , 'VERSIONS' , 'PRG' ) ) , US_NOP() ) } ;
         JUSTIFY { BROWSE_JTFY_LEFT }

      @ 167, 25 GRID HR_GridVersionsFromHEA ;
         WIDTH 320 ;
         HEIGHT ( ( ( GetProperty( "WinHotRecovery" , "height" ) / 2 ) - 167 ) - 23 ) ;
         HEADERS { 'S' , 'Ver' , 'File Date Time' , 'Version Created at' , 'Comment' , 'Header Relative Name' , 'Header Full Name' , 'Version Created on' , 'Version Created by' , 'Code' , 'Offset' } ;
         WIDTHS { 20 , 20 , 100 , 100 , 10 , 1000 , 1000 , 20 , 20 , 20 , 20 };
         ITEMS {} ;
         VALUE 1 ;
         IMAGE vHotImagesGrid ;
         TOOLTIP '' ;
         BACKCOLOR HR_aColorBackVersionsFrom ;
         ON HEADCLICK { {||SORT_VERSIONS( "WinHotRecovery" , "HR_GridVersionsFromHEA" ,1)} , {||SORT_VERSIONS( "WinHotRecovery" , "HR_GridVersionsFromHEA" ,2)} , {||SORT_VERSIONS( "WinHotRecovery" , "HR_GridVersionsFromHEA" ,3)} , {||SORT_VERSIONS( "WinHotRecovery" , "HR_GridVersionsFromHEA" ,4)} } ;
         ON DBLCLICK { HotGetComment( "FROM" ) } ;
         ON CHANGE { || if( !bHEASorting .and. !PUB_bLite , if( HR_bNumberOnHEA , QPM_Wait( "QPM_HotChangeGrid( 'FROM' , 'VERSIONS' , 'HEA' )" , "Comparing ..." ) , QPM_HotChangeGrid( 'FROM' , 'VERSIONS' , 'HEA' ) ) , US_NOP() ) } ;
         JUSTIFY { BROWSE_JTFY_LEFT }

      SetProperty( "WinHotRecovery" , "HR_GridVersionsFromHEA" , "visible" , .F. )

      @ 167, 25 GRID HR_GridVersionsFromPAN ;
         WIDTH 320 ;
         HEIGHT ( ( ( GetProperty( "WinHotRecovery" , "height" ) / 2 ) - 167 ) - 23 ) ;
         HEADERS { 'S' , 'Ver' , 'File Date Time' , 'Version Created at' , 'Comment' , 'Form Relative Name' , 'Form Full Name' , 'Version Created on' , 'Version Created by' , 'Code' , 'Offset' } ;
         WIDTHS { 20 , 20 , 100 , 100 , 10 , 1000 , 1000 , 20 , 20 , 20 , 20 };
         ITEMS {} ;
         VALUE 1 ;
         IMAGE vHotImagesGrid ;
         TOOLTIP '' ;
         BACKCOLOR HR_aColorBackVersionsFrom ;
         ON HEADCLICK { {||SORT_VERSIONS( "WinHotRecovery" , "HR_GridVersionsFromPAN" ,1)} , {||SORT_VERSIONS( "WinHotRecovery" , "HR_GridVersionsFromPAN" ,2)} , {||SORT_VERSIONS( "WinHotRecovery" , "HR_GridVersionsFromPAN" ,3)} , {||SORT_VERSIONS( "WinHotRecovery" , "HR_GridVersionsFromPAN" ,4)} } ;
         ON DBLCLICK { HotGetComment( "FROM" ) } ;
         ON CHANGE { || if( !bPANSorting .and. !PUB_bLite , if( HR_bNumberOnPAN , QPM_Wait( "QPM_HotChangeGrid( 'FROM' , 'VERSIONS' , 'PAN' )" , "Comparing ..." ) , QPM_HotChangeGrid( 'FROM' , 'VERSIONS' , 'PAN' ) ) , US_NOP() ) } ;
         JUSTIFY { BROWSE_JTFY_LEFT }

      SetProperty( "WinHotRecovery" , "HR_GridVersionsFromPAN" , "visible" , .F. )

      // ---------

      @ ( GetProperty( "WinHotRecovery" , "height" ) / 2 ) - 03 , 18 FRAME FrameHotRecoveryFileTarget ;
         CAPTION "" ;
         WIDTH 334 ;
         HEIGHT ( GetProperty( "WinHotRecovery" , "height" ) - 147 ) - ( ( GetProperty( "WinHotRecovery" , "height" ) / 2 ) - 60 ) ;
         SIZE 12 ;
         BOLD ITALIC ;
         FONTCOLOR {255,0,0} ;
         OPAQUE

      @ ( GetProperty( "WinHotRecovery" , "height" ) / 2 ) + 27 , 50 RADIOGROUP HR_FileTarget ;
         OPTIONS { 'Item of Project (Last Version)' , 'Hot Recovery Versions Database' } ;
         WIDTH 215 ;
         VALUE HR_nRadioFileTarget ;
         TOOLTIP "Select File 'Target' for Hot Recovery or 'New' for Compare" ;
         ON CHANGE QPM_HotChangeTarget()

      DEFINE BUTTON B_CommentTarget
             ROW             ( GetProperty( "WinHotRecovery" , "height" ) / 2 ) + 57
             COL             265
             WIDTH           80
             HEIGHT          25
             CAPTION         "Comment"
             TOOLTIP         "Add / Modify / Remove Version's Comments"
             ONCLICK         HotGetComment( "TARGET" )
      END BUTTON

      //

      @ ( GetProperty( "WinHotRecovery" , "height" ) / 2 ) + 94 , 25 GRID HR_GridVersionsTargetPRG ;
         WIDTH 320 ;
         HEIGHT ( GetProperty( "WinHotRecovery" , "height" ) - 250 ) - ( ( GetProperty( "WinHotRecovery" , "height" ) / 2 ) - 60 ) ;
         HEADERS { 'S' , 'Ver' , 'File Date Time' , 'Version Created at' , 'Comment' , 'Source Relative Name' , 'Source Full Name' , 'Version Created on' , 'Version Created by' , 'Code' , 'Offset' } ;
         WIDTHS { 20 , 20 , 100 , 100 , 10 , 1000 , 1000 , 20 , 20 , 20 , 20 };
         ITEMS {} ;
         VALUE 1 ;
         IMAGE vHotImagesGrid ;
         TOOLTIP '' ;
         BACKCOLOR HR_aColorBackVersionsTarget ;
         ON HEADCLICK { {||SORT_VERSIONS( "WinHotRecovery" , "HR_GridVersionsTargetPRG" ,1)} , {||SORT_VERSIONS( "WinHotRecovery" , "HR_GridVersionsTargetPRG" ,2)} , {||SORT_VERSIONS( "WinHotRecovery" , "HR_GridVersionsTargetPRG" ,3)} , {||SORT_VERSIONS( "WinHotRecovery" , "HR_GridVersionsTargetPRG" ,4)} } ;
         ON DBLCLICK { HotGetComment( "TARGET" ) } ;
         ON CHANGE { || if( !bPrgSorting .and. !PUB_bLite , if( HR_bNumberOnPrg , QPM_Wait( "QPM_HotChangeGrid( 'TARGET' , 'VERSIONS' , 'PRG' )" , "Comparing ..." ) , QPM_HotChangeGrid( 'TARGET' , 'VERSIONS' , 'PRG' ) ) , US_NOP() ) } ;
         JUSTIFY { BROWSE_JTFY_LEFT }

      SetProperty( "WinHotRecovery" , "HR_GridVersionsTargetPRG" , "visible" , .F. )

      @ ( GetProperty( "WinHotRecovery" , "height" ) / 2 ) + 94 , 25 GRID HR_GridVersionsTargetHEA ;
         WIDTH 320 ;
         HEIGHT ( GetProperty( "WinHotRecovery" , "height" ) - 250 ) - ( ( GetProperty( "WinHotRecovery" , "height" ) / 2 ) - 60 ) ;
         HEADERS { 'S' , 'Ver' , 'File Date Time' , 'Version Created at' , 'Comment' , 'Header Relative Name' , 'Header Full Name' , 'Version Created on' , 'Version Created by' , 'Code' , 'Offset' } ;
         WIDTHS { 20 , 20 , 100 , 100 , 10 , 1000 , 1000 , 20 , 20 , 20 , 20 };
         ITEMS {} ;
         VALUE 1 ;
         IMAGE vHotImagesGrid ;
         TOOLTIP '' ;
         BACKCOLOR HR_aColorBackVersionsTarget ;
         ON HEADCLICK { {||SORT_VERSIONS( "WinHotRecovery" , "HR_GridVersionsTargetHEA" ,1)} , {||SORT_VERSIONS( "WinHotRecovery" , "HR_GridVersionsTargetHEA" ,2)} , {||SORT_VERSIONS( "WinHotRecovery" , "HR_GridVersionsTargetHEA" ,3)} , {||SORT_VERSIONS( "WinHotRecovery" , "HR_GridVersionsTargetHEA" ,4)} } ;
         ON DBLCLICK { HotGetComment( "TARGET" ) } ;
         ON CHANGE { || if( !bHEASorting .and. !PUB_bLite , if( HR_bNumberOnHEA , QPM_Wait( "QPM_HotChangeGrid( 'TARGET' , 'VERSIONS' , 'HEA' )" , "Comparing ..." ) , QPM_HotChangeGrid( 'TARGET' , 'VERSIONS' , 'HEA' ) ) , US_NOP() ) } ;
         JUSTIFY { BROWSE_JTFY_LEFT }

      SetProperty( "WinHotRecovery" , "HR_GridVersionsTargetHEA" , "visible" , .F. )

      @ ( GetProperty( "WinHotRecovery" , "height" ) / 2 ) + 94 , 25 GRID HR_GridVersionsTargetPAN ;
         WIDTH 320 ;
         HEIGHT ( GetProperty( "WinHotRecovery" , "height" ) - 250 ) - ( ( GetProperty( "WinHotRecovery" , "height" ) / 2 ) - 60 ) ;
         HEADERS { 'S' , 'Ver' , 'File Date Time' , 'Version Created at' , 'Comment' , 'Form Relative Name' , 'Form Full Name' , 'Version Created on' , 'Version Created by' , 'Code' , 'Offset' } ;
         WIDTHS { 20 , 20 , 100 , 100 , 10 , 1000 , 1000 , 20 , 20 , 20 , 20 };
         ITEMS {} ;
         VALUE 1 ;
         IMAGE vHotImagesGrid ;
         TOOLTIP '' ;
         BACKCOLOR HR_aColorBackVersionsTarget ;
         ON HEADCLICK { {||SORT_VERSIONS( "WinHotRecovery" , "HR_GridVersionsTargetPAN" ,1)} , {||SORT_VERSIONS( "WinHotRecovery" , "HR_GridVersionsTargetPAN" ,2)} , {||SORT_VERSIONS( "WinHotRecovery" , "HR_GridVersionsTargetPAN" ,3)} , {||SORT_VERSIONS( "WinHotRecovery" , "HR_GridVersionsTargetPAN" ,4)} } ;
         ON DBLCLICK { HotGetComment( "TARGET" ) } ;
         ON CHANGE { || if( !bPANSorting .and. !PUB_bLite , if( HR_bNumberOnPAN , QPM_Wait( "QPM_HotChangeGrid( 'TARGET' , 'VERSIONS' , 'PAN' )" , "Comparing ..." ) , QPM_HotChangeGrid( 'TARGET' , 'VERSIONS' , 'PAN' ) ) , US_NOP() ) } ;
         JUSTIFY { BROWSE_JTFY_LEFT }

      SetProperty( "WinHotRecovery" , "HR_GridVersionsTargetPAN" , "visible" , .F. )

      @ ( GetProperty( "WinHotRecovery" , "height" ) / 2 ) + 94 , 25 GRID HR_GridItemTargetPRG ;
         WIDTH 320 ;
         HEIGHT ( GetProperty( "WinHotRecovery" , "height" ) - 250 ) - ( ( GetProperty( "WinHotRecovery" , "height" ) / 2 ) - 60 ) ;
         HEADERS { 'S' , 'Source Name' , 'Source Relative Name' , 'Source Full Name' , 'File Date Time' , 'Offset' , 'Version' } ;
         WIDTHS { 20 , 100 , 100 , 1000 , 100 , 20 , 20 };
         ITEMS {} ;
         VALUE 1 ;
         IMAGE vImagesGrid ;
         TOOLTIP '' ;
         BACKCOLOR DEF_COLORBACKPRG ;
         ON HEADCLICK { {||SortPRG( "WinHotRecovery" , "HR_GridItemTargetPRG" ,1)} , {||SortPRG( "WinHotRecovery" , "HR_GridItemTargetPRG" ,2)} , {||SortPRG( "WinHotRecovery" , "HR_GridItemTargetPRG" ,3)} , {||SortPRG( "WinHotRecovery" , "HR_GridItemTargetPRG" ,4)} } ;
         ON CHANGE { || if( !bPrgSorting .and. !PUB_bLite , if( HR_bNumberOnPrg , QPM_Wait( "QPM_HotChangeGrid( 'TARGET' , 'ITEM' , 'PRG' )" , "Comparing ..." ) , QPM_HotChangeGrid( 'TARGET' , 'ITEM' , 'PRG' ) ) , US_NOP() ) } ;
         JUSTIFY { BROWSE_JTFY_LEFT }

      @ ( GetProperty( "WinHotRecovery" , "height" ) / 2 ) + 94 , 25 GRID HR_GridItemTargetHEA ;
         WIDTH 320 ;
         HEIGHT ( GetProperty( "WinHotRecovery" , "height" ) - 250 ) - ( ( GetProperty( "WinHotRecovery" , "height" ) / 2 ) - 60 ) ;
         HEADERS { 'S' , 'Header Name' , 'Header Relative Name' , 'Header Full Name' , 'File Date Time' , 'Offset' , 'Version' } ;
         WIDTHS { 20 , 100 , 100 , 1000 , 100 , 20 , 20 };
         ITEMS {} ;
         VALUE 1 ;
         IMAGE vImagesGrid ;
         TOOLTIP '' ;
         BACKCOLOR DEF_COLORBACKHEA ;
         ON HEADCLICK { {||SortHEA( "WinHotRecovery" , "HR_GridItemTargetHEA" ,1)} , {||SortHEA( "WinHotRecovery" , "HR_GridItemTargetHEA" ,2)} , {||SortHEA( "WinHotRecovery" , "HR_GridItemTargetHEA" ,3)} , {||SortHEA( "WinHotRecovery" , "HR_GridItemTargetHEA" ,4)} } ;
         ON CHANGE { || if( !bHEASorting .and. !PUB_bLite , if( HR_bNumberOnHEA , QPM_Wait( "QPM_HotChangeGrid( 'TARGET' , 'ITEM' , 'HEA' )" , "Comparing ..." ) , QPM_HotChangeGrid( 'TARGET' , 'ITEM' , 'HEA' ) ) , US_NOP() ) } ;
         JUSTIFY { BROWSE_JTFY_LEFT }

      SetProperty( "WinHotRecovery" , "HR_GridItemTargetHEA" , "visible" , .F. )

      @ ( GetProperty( "WinHotRecovery" , "height" ) / 2 ) + 94 , 25 GRID HR_GridItemTargetPAN ;
         WIDTH 320 ;
         HEIGHT ( GetProperty( "WinHotRecovery" , "height" ) - 250 ) - ( ( GetProperty( "WinHotRecovery" , "height" ) / 2 ) - 60 ) ;
         HEADERS { 'S' , 'Form Name' , 'Form Relative Name' , 'Form Full Name' , 'File Date Time' , 'Offset' , 'Version' } ;
         WIDTHS { 20 , 100 , 100 , 1000 , 100 , 20 , 20 };
         ITEMS {} ;
         VALUE 1 ;
         IMAGE vImagesGrid ;
         TOOLTIP '' ;
         BACKCOLOR DEF_COLORBACKPAN ;
         ON HEADCLICK { {||SortPAN( "WinHotRecovery" , "HR_GridItemTargetPAN" ,1)} , {||SortPAN( "WinHotRecovery" , "HR_GridItemTargetPAN" ,2)} , {||SortPAN( "WinHotRecovery" , "HR_GridItemTargetPAN" ,3)} , {||SortPAN( "WinHotRecovery" , "HR_GridItemTargetPAN" ,4)} } ;
         ON CHANGE { || if( !bPANSorting .and. !PUB_bLite , if( HR_bNumberOnPAN , QPM_Wait( "QPM_HotChangeGrid( 'TARGET' , 'ITEM' , 'PAN' )" , "Comparing ..." ) , QPM_HotChangeGrid( 'TARGET' , 'ITEM' , 'PAN' ) ) , US_NOP() ) } ;
         JUSTIFY { BROWSE_JTFY_LEFT }

      SetProperty( "WinHotRecovery" , "HR_GridItemTargetPAN" , "visible" , .F. )

      // ---------

      DEFINE BUTTON BHR_RecoveryProcess
              ROW             GetProperty( "WinHotRecovery" , "height" ) - 77
              COL             25
              WIDTH           320
              CAPTION "Recovery File"
              TOOLTIP "Recovery File 'From' in File 'Target'"
              ONCLICK QPM_HotRecoveryProcess()
      END BUTTON

   END WINDOW

   ACTIVATE WINDOW WinHotRecovery

   if cOldRegPathDif
      US_SetReg( HKEY_CURRENT_USER , "Software\ComponentSoftware\CSDiff" , "CSDiffPath" , cOldRegPath )
   endif

Return .T.

Function QPM_HotRecoveryInit()
   $US_Log()
   CambioTitulo()
// INI SOLO para nuevos indices
   if .F.
      HotRecoveryReindex()
   endif
// FIN SOLO para nuevos indices

   HR_cLastExternalFileName := GBL_HR_cLastExternalFileName
   SetProperty( "WinHotRecovery" , "THR_ExternalFileFrom"    , "value" , HR_cLastExternalFileName )
   HR_cCompareFileOutput := US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + "_" + PUB_cSecu + "CompareOutput" + US_DateTimeCen() + ".htm"
   HR_bSuspendChangeGrid := .T.
   QPM_HotCargoItems( 'PRG' )
   QPM_HotCargoItems( 'HEA' )
   QPM_HotCargoItems( 'PAN' )
   SetProperty( "WinHotRecovery" , "HR_GridItemTargetPRG" , "value" , GetProperty( "VentanaMain" , "GPRGFiles" , "value" ) )
   QPM_HotCargoVersions( 'PRG' )
   QPM_HotCargoVersions( 'HEA' )
   QPM_HotCargoVersions( 'PAN' )
   HR_bSuspendChangeGrid := .F.
   QPM_HotCargoMemo( "FROM" , "EXTERNAL" , "" )
   QPM_HotCargoMemo( "FROM" , "VERSIONS" , "PRG" )
   QPM_HotCargoMemo( "TARGET" , "VERSIONS" , "PRG" )
   QPM_HotCargoMemo( "TARGET" , "ITEM" , "PRG" )
   QPM_HotChangeType()
// QPM_HotChangeFrom( B_SYSOUT_NO )
// QPM_HotChangeTarget( B_SYSOUT_NO )
// QPM_HotChangeSysOut()
// SetProperty( "WinHotRecovery" , "THR_ExternalFileFrom" , "value" , GBL_HR_cLastExternalFileName )
// SetProperty( "WinHotRecovery" , "HR_GridItemTargetPRG" , "value" , GetProperty( "VentanaMain" , "GPRGFiles" , "value" ) )
   HR_cFocus := "HR_GridItemTargetPRG"
   DoMethod( "WinHotRecovery" , HR_cFocus , "setfocus" )
Return .T.

Function QPM_HotChangeType()
   $US_Log()
   do case
      case GetProperty( "WinHotRecovery" , "HR_FileType" , "value" ) == 1
         HR_cHotItemType := "PRG"
      case GetProperty( "WinHotRecovery" , "HR_FileType" , "value" ) == 2
         HR_cHotItemType := "HEA"
      case GetProperty( "WinHotRecovery" , "HR_FileType" , "value" ) == 3
         HR_cHotItemType := "PAN"
   endcase
   QPM_HotChangeFrom( B_SYSOUT_NO )
   QPM_HotChangeTarget( B_SYSOUT_NO )
   QPM_HotChangeSysOut()
Return .T.

Function QPM_HotChangeSysOut( bCompare )
   $US_Log()
   if bCompare == NIL
      bCompare := B_COMPARE_YES
   endif
   do case
      case GetProperty( "WinHotRecovery" , "HR_FileSysOut" , "value" ) == 1
         if bCompare
            HR_nActualDiff := 0
            QPM_HotCompare( HR_cMemoFrom , HR_cMemoTarget , HR_cNameFrom , HR_cNameTarget )
            HotNavigate( 0 )
            if HR_nTotalDiff > 0
         //    HotNavigate( ( HR_nActualDiff := 1 ) )
            endif
         endif
         oW_HTML:Show()
         SetProperty( "WinHotRecovery" , "FrameActiveX" , "visible" , .T. )
         SetProperty( "WinHotRecovery" , "HR_RichEdit" , "visible" , .F. )
         SetProperty( "WinHotRecovery" , "HR_RichEdit" , "backcolor" , HR_aColorBackCompare )
         SetProperty( "WinHotRecovery" , "LHR_ComboNavigatePos"  , "visible" , .T. )
         SetProperty( "WinHotRecovery" , "CHR_GoToPos"      , "visible" , .T. )
         SetProperty( "WinHotRecovery" , "LHR_NavigatePos"  , "visible" , .T. )
         SetProperty( "WinHotRecovery" , "BHR_NavigatePrev" , "visible" , .T. )
         SetProperty( "WinHotRecovery" , "BHR_NavigateNext" , "visible" , .T. )
      case GetProperty( "WinHotRecovery" , "HR_FileSysOut" , "value" ) == 2
         oW_HTML:Hide()
         SetProperty( "WinHotRecovery" , "FrameActiveX" , "visible" , .F. )
         SetProperty( "WinHotRecovery" , "HR_RichEdit" , "visible" , .T. )
         SetProperty( "WinHotRecovery" , "HR_RichEdit" , "value" , HR_cMemoFrom )
         SetProperty( "WinHotRecovery" , "HR_RichEdit" , "caretpos" , 0 )
         SetProperty( "WinHotRecovery" , "HR_RichEdit" , "backcolor" , HR_aColorBackVersionsFrom )
         SetProperty( "WinHotRecovery" , "LHR_ComboNavigatePos"  , "visible" , .F. )
         SetProperty( "WinHotRecovery" , "CHR_GoToPos"      , "visible" , .F. )
         SetProperty( "WinHotRecovery" , "LHR_NavigatePos"  , "visible" , .F. )
         SetProperty( "WinHotRecovery" , "BHR_NavigatePrev" , "visible" , .F. )
         SetProperty( "WinHotRecovery" , "BHR_NavigateNext" , "visible" , .F. )
      case GetProperty( "WinHotRecovery" , "HR_FileSysOut" , "value" ) == 3
         oW_HTML:Hide()
         SetProperty( "WinHotRecovery" , "FrameActiveX" , "visible" , .F. )
         SetProperty( "WinHotRecovery" , "HR_RichEdit" , "visible" , .T. )
         SetProperty( "WinHotRecovery" , "HR_RichEdit" , "value" , HR_cMemoTarget )
         SetProperty( "WinHotRecovery" , "HR_RichEdit" , "caretpos" , 0 )
         if GetProperty( "WinHotRecovery" , "HR_FileTarget" , "value" ) == 1
            do case
               case HR_cHotItemType == "PRG"
                  SetProperty( "WinHotRecovery" , "HR_RichEdit" , "backcolor" , DEF_COLORBACKPRG )
               case HR_cHotItemType == "HEA"
                  SetProperty( "WinHotRecovery" , "HR_RichEdit" , "backcolor" , DEF_COLORBACKHEA )
               case HR_cHotItemType == "PAN"
                  SetProperty( "WinHotRecovery" , "HR_RichEdit" , "backcolor" , DEF_COLORBACKPAN )
            endcase
         else
            SetProperty( "WinHotRecovery" , "HR_RichEdit" , "backcolor" , HR_aColorBackVersionsTarget )
         endif
         SetProperty( "WinHotRecovery" , "LHR_ComboNavigatePos"  , "visible" , .F. )
         SetProperty( "WinHotRecovery" , "CHR_GoToPos"      , "visible" , .F. )
         SetProperty( "WinHotRecovery" , "LHR_NavigatePos"  , "visible" , .F. )
         SetProperty( "WinHotRecovery" , "BHR_NavigatePrev" , "visible" , .F. )
         SetProperty( "WinHotRecovery" , "BHR_NavigateNext" , "visible" , .F. )
   endcase
Return .T.

Function QPM_HotChangeFrom( bSysOut )
   // QPM_HotChangeFrom2
   $US_Log()
   if bSysOut == NIL
      bSysOut := B_SYSOUT_YES
   endif
   do case
      case GetProperty( "WinHotRecovery" , "HR_FileFrom" , "value" ) == 1
         SetProperty( "WinHotRecovery" , "B_CommentFrom"           , "enabled" , .T. )
         SetProperty( "WinHotRecovery" , "LHR_ExternalFileFrom"    , "visible" , .F. )
         SetProperty( "WinHotRecovery" , "THR_ExternalFileFrom"    , "visible" , .F. )
         SetProperty( "WinHotRecovery" , "BHR_ExternalFileFrom"    , "visible" , .F. )
         do case
            case HR_cHotItemType == "PRG"
               SetProperty( "WinHotRecovery" , "HR_GridVersionsFromPRG" , "visible" , .T. )
               SetProperty( "WinHotRecovery" , "HR_GridVersionsFromHEA" , "visible" , .F. )
               SetProperty( "WinHotRecovery" , "HR_GridVersionsFromPAN" , "visible" , .F. )
               HR_cMemoFrom := HR_cMemoFromVersionsPRG
               if GetProperty( "WinHotRecovery" , "HR_GridVersionsFromPRG" , "itemcount" ) > 0
                  HR_cNameFrom := QPM_HotGetNameVersionsFrom( "WinHotRecovery" , "HR_GridVersionsFromPRG" , GetProperty( "WinHotRecovery" , "HR_GridVersionsFromPRG" , "value" ) )
               else
                  HR_cNameFrom := "Version doesn't exists"
               endif
            case HR_cHotItemType == "HEA"
               SetProperty( "WinHotRecovery" , "HR_GridVersionsFromPRG" , "visible" , .F. )
               SetProperty( "WinHotRecovery" , "HR_GridVersionsFromHEA" , "visible" , .T. )
               SetProperty( "WinHotRecovery" , "HR_GridVersionsFromPAN" , "visible" , .F. )
               HR_cMemoFrom := HR_cMemoFromVersionsHEA
               if GetProperty( "WinHotRecovery" , "HR_GridVersionsFromHEA" , "itemcount" ) > 0
                  HR_cNameFrom := QPM_HotGetNameVersionsFrom( "WinHotRecovery" , "HR_GridVersionsFromHEA" , GetProperty( "WinHotRecovery" , "HR_GridVersionsFromHEA" , "value" ) )
               else
                  HR_cNameFrom := "Version doesn't exists"
               endif
            case HR_cHotItemType == "PAN"
               SetProperty( "WinHotRecovery" , "HR_GridVersionsFromPRG" , "visible" , .F. )
               SetProperty( "WinHotRecovery" , "HR_GridVersionsFromHEA" , "visible" , .F. )
               SetProperty( "WinHotRecovery" , "HR_GridVersionsFromPAN" , "visible" , .T. )
               HR_cMemoFrom := HR_cMemoFromVersionsPAN
               if GetProperty( "WinHotRecovery" , "HR_GridVersionsFromPAN" , "itemcount" ) > 0
                  HR_cNameFrom := QPM_HotGetNameVersionsFrom( "WinHotRecovery" , "HR_GridVersionsFromPAN" , GetProperty( "WinHotRecovery" , "HR_GridVersionsFromPAN" , "value" ) )
               else
                  HR_cNameFrom := "Version doesn't exists"
               endif
         endcase
      case GetProperty( "WinHotRecovery" , "HR_FileFrom" , "value" ) == 2
         SetProperty( "WinHotRecovery" , "B_CommentFrom"           , "enabled" , .F. )
         SetProperty( "WinHotRecovery" , "LHR_ExternalFileFrom"    , "visible" , .T. )
         SetProperty( "WinHotRecovery" , "THR_ExternalFileFrom"    , "visible" , .T. )
         SetProperty( "WinHotRecovery" , "BHR_ExternalFileFrom"    , "visible" , .T. )
         SetProperty( "WinHotRecovery" , "HR_GridVersionsFromPRG" , "visible" , .F. )
         SetProperty( "WinHotRecovery" , "HR_GridVersionsFromHEA" , "visible" , .F. )
         SetProperty( "WinHotRecovery" , "HR_GridVersionsFromPAN" , "visible" , .F. )
         HR_cMemoFrom := HR_cMemoFromExternal
         HR_cNameFrom := QPM_HotGetNameExternal( GetProperty( "WinHotRecovery" , "THR_ExternalFileFrom" , "value" ) )
   endcase
   if bSysOut
      QPM_HotChangeSysOut()
   endif
Return .T.

Function QPM_HotChangeTarget( bSysOut )
   //    QPM_HotChangeTarget2
   $US_Log()
   if bSysOut == NIL
      bSysOut := B_SYSOUT_YES
   endif
   do case
      case GetProperty( "WinHotRecovery" , "HR_FileTarget" , "value" ) == 1
         SetProperty( "WinHotRecovery" , "B_CommentTarget"         , "enabled" , .F. )
         SetProperty( "WinHotRecovery" , "BHR_RecoveryProcess"     , "enabled" , .T. )
         do case
            case HR_cHotItemType == "PRG"
               SetProperty( "WinHotRecovery" , "HR_GridItemTargetPRG"     , "visible" , .T. )
               SetProperty( "WinHotRecovery" , "HR_GridItemTargetHEA"     , "visible" , .F. )
               SetProperty( "WinHotRecovery" , "HR_GridItemTargetPAN"     , "visible" , .F. )
               HR_cMemoTarget := HR_cMemoTargetItemPRG
               HR_cNameTarget := QPM_HotGetNameItemTarget( "WinHotRecovery" , "HR_GridItemTargetPRG" , GetProperty( "WinHotRecovery" , "HR_GridItemTargetPRG" , "value" ) )
            case HR_cHotItemType == "HEA"
               SetProperty( "WinHotRecovery" , "HR_GridItemTargetPRG"     , "visible" , .F. )
               SetProperty( "WinHotRecovery" , "HR_GridItemTargetHEA"     , "visible" , .T. )
               SetProperty( "WinHotRecovery" , "HR_GridItemTargetPAN"     , "visible" , .F. )
               HR_cMemoTarget := HR_cMemoTargetItemHEA
               HR_cNameTarget := QPM_HotGetNameItemTarget( "WinHotRecovery" , "HR_GridItemTargetHEA" , GetProperty( "WinHotRecovery" , "HR_GridItemTargetHEA" , "value" ) )
            case HR_cHotItemType == "PAN"
               SetProperty( "WinHotRecovery" , "HR_GridItemTargetPRG"     , "visible" , .F. )
               SetProperty( "WinHotRecovery" , "HR_GridItemTargetHEA"     , "visible" , .F. )
               SetProperty( "WinHotRecovery" , "HR_GridItemTargetPAN"     , "visible" , .T. )
               HR_cMemoTarget := HR_cMemoTargetItemPAN
               HR_cNameTarget := QPM_HotGetNameItemTarget( "WinHotRecovery" , "HR_GridItemTargetPAN" , GetProperty( "WinHotRecovery" , "HR_GridItemTargetPAN" , "value" ) )
         endcase
         SetProperty( "WinHotRecovery" , "HR_GridVersionsTargetPRG" , "visible" , .F. )
         SetProperty( "WinHotRecovery" , "HR_GridVersionsTargetHEA" , "visible" , .F. )
         SetProperty( "WinHotRecovery" , "HR_GridVersionsTargetPAN" , "visible" , .F. )
         SetProperty( "WinHotRecovery" , "FrameHotRecoveryFileFrom"   , "caption" , "Select File 'From' for Hot Recovery" )
         SetProperty( "WinHotRecovery" , "FrameHotRecoveryFileTarget" , "caption" , "Select File 'Target' for Hot Recovery" )
      case GetProperty( "WinHotRecovery" , "HR_FileTarget" , "value" ) == 2
         SetProperty( "WinHotRecovery" , "B_CommentTarget"         , "enabled" , .T. )
         SetProperty( "WinHotRecovery" , "BHR_RecoveryProcess"     , "enabled" , .F. )
         SetProperty( "WinHotRecovery" , "HR_GridItemTargetPRG"     , "visible" , .F. )
         SetProperty( "WinHotRecovery" , "HR_GridItemTargetHEA"     , "visible" , .F. )
         SetProperty( "WinHotRecovery" , "HR_GridItemTargetPAN"     , "visible" , .F. )
         do case
            case HR_cHotItemType == "PRG"
               SetProperty( "WinHotRecovery" , "HR_GridVersionsTargetPRG" , "visible" , .T. )
               SetProperty( "WinHotRecovery" , "HR_GridVersionsTargetHEA" , "visible" , .F. )
               SetProperty( "WinHotRecovery" , "HR_GridVersionsTargetPAN" , "visible" , .F. )
               HR_cMemoTarget := HR_cMemoTargetVersionsPRG
               if GetProperty( "WinHotRecovery" , "HR_GridVersionsTargetPRG" , "itemcount" ) > 0
                  HR_cNameTarget := QPM_HotGetNameVersionsTarget( "WinHotRecovery" , "HR_GridVersionsTargetPRG" , GetProperty( "WinHotRecovery" , "HR_GridVersionsTargetPRG" , "value" ) )
               else
                  HR_cNameTarget := "Version doesn't exists"
               endif
            case HR_cHotItemType == "HEA"
               SetProperty( "WinHotRecovery" , "HR_GridVersionsTargetPRG" , "visible" , .F. )
               SetProperty( "WinHotRecovery" , "HR_GridVersionsTargetHEA" , "visible" , .T. )
               SetProperty( "WinHotRecovery" , "HR_GridVersionsTargetPAN" , "visible" , .F. )
               HR_cMemoTarget := HR_cMemoTargetVersionsHEA
               if GetProperty( "WinHotRecovery" , "HR_GridVersionsTargetHEA" , "itemcount" ) > 0
                  HR_cNameTarget := QPM_HotGetNameVersionsTarget( "WinHotRecovery" , "HR_GridVersionsTargetHEA" , GetProperty( "WinHotRecovery" , "HR_GridVersionsTargetHEA" , "value" ) )
               else
                  HR_cNameTarget := "Version doesn't exists"
               endif
            case HR_cHotItemType == "PAN"
               SetProperty( "WinHotRecovery" , "HR_GridVersionsTargetPRG" , "visible" , .F. )
               SetProperty( "WinHotRecovery" , "HR_GridVersionsTargetHEA" , "visible" , .F. )
               SetProperty( "WinHotRecovery" , "HR_GridVersionsTargetPAN" , "visible" , .T. )
               HR_cMemoTarget := HR_cMemoTargetVersionsPAN
               if GetProperty( "WinHotRecovery" , "HR_GridVersionsTargetPAN" , "itemcount" ) > 0
                  HR_cNameTarget := QPM_HotGetNameVersionsTarget( "WinHotRecovery" , "HR_GridVersionsTargetPAN" , GetProperty( "WinHotRecovery" , "HR_GridVersionsTargetPAN" , "value" ) )
               else
                  HR_cNameTarget := "Version doesn't exists"
               endif
         endcase
         SetProperty( "WinHotRecovery" , "FrameHotRecoveryFileFrom"   , "caption" , "Select File 'Base' for Compare Process" )
         SetProperty( "WinHotRecovery" , "FrameHotRecoveryFileTarget" , "caption" , "Select File 'New' for Compare Process" )
   endcase
   if bSysOut
      QPM_HotChangeSysOut()
   endif
Return .T.

Function QPM_HotCargoMemo( cZona , cSubZona , cType )
   // QPM_HotCargoMemo2
   $US_Log()
   if cType == NIL
      cType := ""
   endif
   cType    := US_Upper( cType )
   cZona    := US_Upper( cZona )
   cSubZona := US_Upper( cSubZona )
   if cSubZona == "EXTERNAL"
      &( "HR_cMemo" + cZona + cSubZona + cType ) := MemoRead( GetProperty( "WinHotRecovery" , "THR_ExternalFileFrom" , "value" ) )
   else
      if cSubZona == "VERSIONS"
         if GetProperty( "WinHotRecovery" , "HR_Grid" + cSubZona + cZona + cType , "itemcount" ) > 0
            &( "HR_cMemo" + cZona + cSubZona + cType ) := QPM_HotObtengo( GetProperty( "WinHotRecovery" , "HR_Grid" + cSubZona + cZona + cType , "cell" , GetProperty( "WinHotRecovery" , "HR_Grid" + cSubZona + cZona + cType , "value" ) , DEF_N_VER_COLCODE ) )
         else
            &( "HR_cMemo" + cZona + cSubZona + cType ) := "This Hot Recovery Version Doesn't Exists !!!" + HB_OsNewLine()
         endif
      else
         &( "HR_cMemo" + cZona + cSubZona + cType ) := memoread( ChgPathToReal( GetProperty( "WinHotRecovery" , "HR_Grid" + cSubZona + cZona + cType , "cell" , GetProperty( "WinHotRecovery" , "HR_Grid" + cSubZona + cZona + cType , "value" ) , DEF_N_ITEM_COLFULLNAME ) ) )
      endif
   endif
   if alltrim( &( "HR_cMemo" + cZona + cSubZona + cType ) ) == ""
      &( "HR_cMemo" + cZona + cSubZona + cType ) := "Empty File/Version or File not Found" + HB_OsNewLine()
   endif
Return .T.

Function QPM_HotCargoItems( cType )
   $US_Log()
   Local i
   DoMethod( "WinHotRecovery" , "HR_GridItemTarget" + cType , "DeleteAllItems" )
   for i:=1 to GetProperty( "VentanaMain" , "G" + cType + "Files" , "ItemCount" )
      if GridImage( "VentanaMain" , "G" + cType + "Files" , i , &( "nCol" + cType + "Status" ) , "?" , PUB_nGridImgEquis )
         DoMethod( "WinHotRecovery" , "HR_GridItemTarget" + cType , "AddItem" , { PUB_nGridImgEquis , ;
                                                                          GetProperty( "VentanaMain" , "G" + cType + "Files" , "cell" , i , &( "nCol" + cType + "Name" ) ) , ;
                                                                          GetProperty( "VentanaMain" , "G" + cType + "Files" , "cell" , i , &( "nCol" + cType + "FullName" ) ) , ;
                                                                          ChgPathToReal( GetProperty( "VentanaMain" , "G" + cType + "Files" , "cell" , i , &( "nCol" + cType + "FullName" ) ) ) , ;
                                                                          '' , ;
                                                                          '0' , ;
                                                                          '1' } )
      else
         DoMethod( "WinHotRecovery" , "HR_GridItemTarget" + cType , "AddItem" , { PUB_nGridImgNone , ;
                                                                          GetProperty( "VentanaMain" , "G" + cType + "Files" , "cell" , i , &( "nCol" + cType + "Name" ) ) , ;
                                                                          GetProperty( "VentanaMain" , "G" + cType + "Files" , "cell" , i , &( "nCol" + cType + "FullName" ) ) , ;
                                                                          ChgPathToReal( GetProperty( "VentanaMain" , "G" + cType + "Files" , "cell" , i , &( "nCol" + cType + "FullName" ) ) ) , ;
                                                                          US_Dis_DateSeconds2( DToS( US_FileDate( ChgPathToReal( GetProperty( "VentanaMain" , "G" + cType + "Files" , "cell" , i , &( "nCol" + cType + "FullName" ) ) ) ) ) + US_StrCero( US_TimeSec( US_FileTime( ChgPathToReal( GetProperty( "VentanaMain" , "G" + cType + "Files" , "cell" , i , &( "nCol" + cType + "FullName" ) ) ) ) ) , 5 ) ) , ;
                                                                          "0" , ;
                                                                          "1" } )
         if GridImage( "VentanaMain" , "G" + cType + "Files" , i , &( "nCol" + cType + "Status" ) , "?" , PUB_nGridImgEdited )
            GridImage( "WinHotRecovery" , "HR_GridItemTarget" + cType , i , DEF_N_ITEM_COLIMAGE , "+" , PUB_nGridImgEdited )
         endif
      endif
   next
   SetProperty( "WinHotRecovery" , "HR_GridItemTarget" + cType , "value" , 1 )
   DoMethod( "WinHotRecovery" , "HR_GridItemTarget" + cType , "ColumnsAutoFitH" )
   QPM_HotCargoMemo( "TARGET" , "ITEM" , cType )
Return .T.

Function QPM_HotCargoVersions( cType )
   //    QPM_HotCargoVersions2
   Local OPEN_cAreaOld := dbf()
   Local OPEN_cOldTxt := GetMGWaitTxt()
   Local OPEN_nSecondsInit := Seconds()
   Local cActual := "" , cActualHash := ""
   Local cAuxLinea := "" , nInx := 0 , cRelativeName := "" , cFullName := "" , cFunction := "" , cComment := ""
   Local cFileType := "" , cFileDateTime := "" , LOC_cVersionDateTime := "" , LOC_cVersionComputer := "" , LOC_cVersionUser := ""
   Local i := 0
   $US_Log()
   Do While !US_DBUseArea( .T. , "DBFCDX" , QPM_HR_Database , "HOTREC" , DEF_DBF_EXCLUSIVE , DEF_DBF_WRITE ) .and. ( seconds() - OPEN_nSecondsInit ) < HR_nLookTimeOut
      SetMGWaitTxt( "Waiting for Hot Recovery Database: " + alltrim( str( int( HR_nLookTimeOut - ( seconds() - OPEN_nSecondsInit ) ) ) ) + " seconds..." )
      DO EVENTS
   enddo
   SetMGWaitTxt( OPEN_cOldTxt )
   if dbf() == "HOTREC"
      cActual := GetProperty( "WinHotRecovery" , "HR_GridItemTarget" + cType , "cell" , GetProperty( "WinHotRecovery" , "HR_GridItemTarget" + cType , "value" ) , DEF_N_ITEM_COLNAME )
      cActualHash := HB_MD5( US_Upper( cActual ) )
      OrdSetFocus( "HR_HASH01" )
      OrdScope( 0 , cActualHash + Replicate( "0" , HR_nVersionsDigitosMax ) )
      OrdScope( 1 , cActualHash + US_StrCero( HR_nVersionsSet , HR_nVersionsDigitosMax ) )
      DBGoTop()
      DoMethod( "WinHotRecovery" , "HR_GridVersionsFrom" + cType , "DeleteAllItems" )
      DoMethod( "WinHotRecovery" , "HR_GridVersionsTarget" + cType , "DeleteAllItems" )
      do while !eof()
         cFunction := ""
         cComment  := ""
         for nInx := 1 to MLCount( HR_DATA , 254 )
            cAuxLinea := MemoLine( HR_DATA , 254 , nInx )
            do case
               case US_Upper( US_Word( cAuxLinea , 1 ) ) == "FUNCTION"
                  cFunction := US_WordSubStr( cAuxLinea , 2 )
               case US_Upper( US_Word( cAuxLinea , 1 ) ) == "FULLNAME"
                  cFullName := US_WordSubStr( cAuxLinea , 2 )
               case US_Upper( US_Word( cAuxLinea , 1 ) ) == "RELATIVENAME"
                  cRelativeName := US_WordSubStr( cAuxLinea , 2 )
               case US_Upper( US_Word( cAuxLinea , 1 ) ) == "FILE_TYPE"
                  cFileType := US_WordSubStr( cAuxLinea , 2 )
               case US_Upper( US_Word( cAuxLinea , 1 ) ) == "FILE_DATETIME"
                  cFileDateTime := US_Dis_DateSeconds2( US_WordSubStr( cAuxLinea , 2 ) )
               case US_Upper( US_Word( cAuxLinea , 1 ) ) == "VERSION_DATETIME"
                  LOC_cVersionDateTime := US_Dis_DateSeconds2( US_WordSubStr( cAuxLinea , 2 ) )
               case US_Upper( US_Word( cAuxLinea , 1 ) ) == "VERSION_COMPUTER"
                  LOC_cVersionComputer := US_WordSubStr( cAuxLinea , 2 )
               case US_Upper( US_Word( cAuxLinea , 1 ) ) == "VERSION_USER"
                  LOC_cVersionUser := US_WordSubStr( cAuxLinea , 2 )
               case US_Upper( US_Word( cAuxLinea , 1 ) ) == "COMMENT"
                  cComment := US_WordSubStr( cAuxLinea , 2 )
               otherwise
                  if !( alltrim( cAuxLinea ) == "" )
                     US_Log( "Error in key of HR_DATA: " + cAuxLinea )
                  endif
            endcase
         next
         i++
         DoMethod( "WinHotRecovery" , "HR_GridVersionsFrom" + cType , "AddItem" , { HotPUB_nGridImgNone , ;
                                                                                    "-" + Alltrim( Str( HR_SECU ) ) , ;
                                                                                    cFileDateTime     , ;
                                                                                    LOC_cVersionDateTime , ;
                                                                                    cComment          , ;
                                                                                    cRelativeName     , ;
                                                                                    cFullName         , ;
                                                                                    LOC_cVersionComputer , ;
                                                                                    LOC_cVersionUser  , ;
                                                                                    Str( HR_COD )     , ;
                                                                                    "0" } )
         DoMethod( "WinHotRecovery" , "HR_GridVersionsTarget" + cType , "AddItem" , { HotPUB_nGridImgNone , ;
                                                                                      "-" + Alltrim( Str( HR_SECU ) ) , ;
                                                                                      cFileDateTime     , ;
                                                                                      LOC_cVersionDateTime , ;
                                                                                      cComment          , ;
                                                                                      cRelativeName     , ;
                                                                                      cFullName         , ;
                                                                                      LOC_cVersionComputer , ;
                                                                                      LOC_cVersionUser  , ;
                                                                                      Str( HR_COD )     , ;
                                                                                      "0" } )
      // if alltrim( cFunction ) == "RECOVERY"
      //    HotGridImage( "WinHotRecovery" , "HR_GridVersionsFrom" + cType , i , DEF_N_VER_COLIMAGE , "+" , HotGridImgTarget )
      //    HotGridImage( "WinHotRecovery" , "HR_GridVersionsTarget" + cType , i , DEF_N_VER_COLIMAGE , "+" , HotGridImgTarget )
      // endif
         if !( alltrim( cComment ) == "" )
            HotGridImage( "WinHotRecovery" , "HR_GridVersionsFrom" + cType , i , DEF_N_VER_COLIMAGE , "+" , HotGridImgComment )
            HotGridImage( "WinHotRecovery" , "HR_GridVersionsTarget" + cType , i , DEF_N_VER_COLIMAGE , "+" , HotGridImgComment )
         endif
         DBSkip()
      enddo
      OrdScope( 0 , NIL )
      OrdScope( 1 , NIL )
      DBCloseArea( "HOTREC" )
      SetProperty( "WinHotRecovery" , "HR_GridVersionsFrom" + cType , "value" , Val( GetProperty( "WinHotRecovery" , "HR_GridItemTarget" + cType , "cell" , GetProperty( "WinHotRecovery" , "HR_GridItemTarget" + cType , "value" ) , DEF_N_ITEM_COLVERSION ) ) )
      SetProperty( "WinHotRecovery" , "HR_GridVersionsTarget" + cType , "value" , Val( GetProperty( "WinHotRecovery" , "HR_GridItemTarget" + cType , "cell" , GetProperty( "WinHotRecovery" , "HR_GridItemTarget" + cType , "value" ) , DEF_N_ITEM_COLVERSION ) ) )
      DoMethod( "WinHotRecovery" , "HR_GridVersionsFrom" + cType , "ColumnsAutoFitH" )
      DoMethod( "WinHotRecovery" , "HR_GridVersionsTarget" + cType , "ColumnsAutoFitH" )
      QPM_HotCargoMemo( "FROM" , "VERSIONS" , cType )
      QPM_HotCargoMemo( "TARGET" , "VERSIONS" , cType )
   endif
   if !empty( OPEN_cAreaOld )
      DBSelectArea( OPEN_cAreaOld )
   endif
Return .T.

Function QPM_HotRelease()
   $US_Log()
   HR_bWinHotRecoveryMinimized := .F.
   HR_cMemoFrom := ""
   HR_cMemoFromVersionsPRG := ""
   HR_cMemoFromVersionsHEA := ""
   HR_cMemoFromVersionsPAN := ""
   HR_cMemoFromExternal   := ""
   HR_cMemoTarget := ""
   HR_cMemoTargetItemPRG := ""
   HR_cMemoTargetItemHEA := ""
   HR_cMemoTargetItemPAN := ""
   HR_cMemoTargetVersionsPRG := ""
   HR_cMemoTargetVersionsHEA := ""
   HR_cMemoTargetVersionsPAN := ""
   GBL_HR_cLastExternalFileName := GetProperty( "WinHotRecovery" , "THR_ExternalFileFrom" , "value" )
   ferase( HR_cCompareFileOutput )
Return .T.

Function QPM_HotObtengo( cCode )
   Local cMemoAux := "Database for HotRecovery Versions is Not Open" , bMemoZiped := .F.
   Local cHotRecoveryZipFile := US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + "_" + PUB_cSecu + "ZipHOTRecovery" + US_DateTimeCen() + ".Ziped"
   Local cHotRecoveryTxtFile := US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + "_" + PUB_cSecu + "ZipHOTRecovery" + US_DateTimeCen() + ".Planed"
   Local aFilesInZip := {}
   Local OPEN_cAreaOld := dbf()
   Local OPEN_cOldTxt := GetMGWaitTxt()
   Local OPEN_nSecondsInit := Seconds()
   $US_Log()
   Do While !US_DBUseArea( .T. , "DBFCDX" , QPM_HR_Database , "HOTREC" , DEF_DBF_EXCLUSIVE , DEF_DBF_WRITE ) .and. ( seconds() - OPEN_nSecondsInit ) < HR_nLookTimeOut
      SetMGWaitTxt( "Waiting for Hot Recovery Database: " + alltrim( str( int( HR_nLookTimeOut - ( seconds() - OPEN_nSecondsInit ) ) ) ) + " seconds..." )
      DO EVENTS
   enddo
   SetMGWaitTxt( OPEN_cOldTxt )
   if dbf() == "HOTREC"
      OrdSetFocus( "HR_COD01" )
      if DBSeek( val( cCode ) )
         bMemoZiped := if( HR_FILE_TY == "Z" , .T. , .F. )
         cMemoAux := HR_FILE
      else
         cMemoAux := "This Hot Recovery Version Doesn't Exists !!!" + HB_OsNewLine()
      endif
      DBCloseArea( "HOTREC" )
   endif
   if !empty( OPEN_cAreaOld )
      DBSelectArea( OPEN_cAreaOld )
   endif
   if bMemoZiped
      QPM_MemoWrit( cHotRecoveryZipFile , US_UnMaskBinData( cMemoAux ) )
      aFilesInZip := HB_GETFILESINZIP( cHotRecoveryZipFile )
      if !HB_UNZIPFILE( cHotRecoveryZipFile , , .T. , , PUB_cProjectFolder , aFilesInZip[ 1 ] )
         MsgInfo( "Error decompresing Hot Recovery Version." )
      else
         cMemoAux := memoread( PUB_cProjectFolder + DEF_SLASH + aFilesInZip[ 1 ] )
      endif
      ferase( cHotRecoveryZipFile )
      ferase( PUB_cProjectFolder + DEF_SLASH + aFilesInZip[ 1 ] )
   endif
   *    HB_UNZIPFILE( <cFile>, <bBlock>, <lWithPath>, <cPassWord>, <cPath>, <cFile> | <aFile>, <pFileProgress> ) ---> lCompress
   * $ARGUMENTS$
   *      <cFile>   Name of the zip file to extract
   *      <bBlock>  Code block to execute while extracting
   *      <lWithPath> Toggle to create directory if needed
   *      <cPassWord> Password to use to extract files
   *      <cPath>    Path to extract the files to - mandatory
   *      <cFile> | <aFiles> A File or Array of files to extract - mandatory
   *      <pFileProgress> Code block for File Progress
Return cMemoAux

Function QPM_HotChangeGrid( cZona , cSubZona , cType )
   // QPM_HotChangeGrid2
   $US_Log()
   if !HR_bSuspendChangeGrid
      if cType == NIL
         cType := ""
      endif
      cType    := US_Upper( cType )
      cZona    := US_Upper( cZona )
      cSubZona := US_Upper( cSubZona )
      Do case
         case cSubZona == "ITEM"
            HR_bSuspendChangeGrid := .T. // usado para que cuando se dispara nuevamente QPM_HotChangeGrid en realidad no se ejecute ya que ahi hay un if contra esta variable
            QPM_HotCargoMemo( cZona , cSubZona , cType )
            QPM_HotCargoVersions( cType )
            HR_bSuspendChangeGrid := .F. // restauro el valor de esta variable "prestada"
         case cSubZona == "VERSIONS"
            QPM_HotCargoMemo( cZona , cSubZona , cType )
      Endcase
      QPM_HotChangeFrom( B_SYSOUT_NO )
      QPM_HotChangeTarget( B_SYSOUT_NO )
      QPM_HotChangeSysOut()
   endif
   HR_cFocus := "HR_Grid" + cSubZona + cZona + cType
   DoMethod( "WinHotRecovery" , HR_cFocus , "setfocus" )
Return .T.

Function QPM_HotChangeExternal()
   $US_Log()
   QPM_HotCargoMemo( "FROM" , "EXTERNAL" , "" )
   QPM_HotChangeFrom( B_SYSOUT_NO )
   QPM_HotChangeTarget( B_SYSOUT_NO )
   QPM_HotChangeSysOut()
Return .T.

Function QPM_HotCompare( cBase , cNew , cNameBase , cNameNew )
   Local cMemoCompared := "" , i
   Local ExeCompare     := US_ShortName( PUB_cQPM_Folder ) + DEF_SLASH + "US_dif.exe"
   Local cFileBase      := US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + "_" + PUB_cSecu + "CompareBase" + US_DateTimeCen() + ".TxT"
   Local cFileNew       := US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + "_" + PUB_cSecu + "CompareNew" + US_DateTimeCen() + ".TxT"
   $US_Log()
   HR_nTotalDiff := 0
   ferase( HR_cCompareFileOutput )
   QPM_MemoWrit( cFileBase , cBase )
   QPM_MemoWrit( cFileNew , cNew )
   QPM_Execute( ExeCompare , '/Oh"'+HR_cCompareFileOutput+'" /sL /n /q /t=8 "'+cFileBase+'" "'+cFileNew+'" "'+cNameBase+'" "'+cNameNew+'"' , DEF_QPM_EXEC_WAIT , DEF_QPM_EXEC_MINIMIZE )
   if !file( HR_cCompareFileOutput )
      QPM_MemoWrit( HR_cCompareFileOutput , "Base File and New File are identical or differ by white space only" )
      DoMethod( "WinHotRecovery" , "CHR_GoToPos" , "DeleteAllItems" )
      SetProperty( "WinHotRecovery" , "CHR_GoToPos" , "value" , 0 )
   else
      cMemoCompared := strtran( memoread( HR_cCompareFileOutput ) , "color: #00ff00;background:  #ffffff" , "color: #ff0000;background:  #ffffff;font-weight:bold" , 1 , 1 )
      cMemoCompared := strtran( cMemoCompared , "color: #000000;background:  #ffff00" , "color: #0000ff;background:  #ffffff;font-weight:bold" , 1 , 1 )
      cMemoCompared := strtran( cMemoCompared , ".HDNormal {  }" , ".HDNormal {  color: #808080;background:  #ffffff;text-decoration:none ; font-family: Courier New ; font-size: 10pt;}" , 1 , 1 )
      cMemoCompared := strtran( cMemoCompared , '<p align="center"><i><font size="3">Generated by   <a href="http://www.ComponentSoftware.com/products/csdiff/" target="_blank">CSDiff</a> on' , '<!--' , 1 , 1 )
      cMemoCompared := strtran( cMemoCompared , '</form></body><html>' , '-->' , 1 , 1 )
      cMemoCompared := strtran( cMemoCompared , '<h3>Base file:' , '<h3>From / Base file:' , 1 , 1 )
      cMemoCompared := strtran( cMemoCompared , '</h3><h3>Compared file:' , '</h3><h3>Target / New file:' , 1 , 1 )
      HR_nTotalDiff := Val( US_Word( strtran( SubStr( cMemoCompared , rat( '<a name="diff" id="c' , cMemoCompared ) + 20 ) , '"' , " " ) , 1 ) ) + 1
      cMemoCompared := substr( cMemoCompared , 1 , rat( '</span>'+HB_OsNewLine()+'</pre>'+HB_OsNewLine()+'</body>' , cMemoCompared ) - 1 ) + ;
                       strtran( substr( cMemoCompared , rat( '</span>'+HB_OsNewLine()+'</pre>'+HB_OsNewLine()+'</body>' , cMemoCompared ) ) , '</body>' , replicate( '<br>' , 30 ) + '</body>' , 1 , 1 )
      QPM_MemoWrit( HR_cCompareFileOutput , cMemoCompared )
      DoMethod( "WinHotRecovery" , "CHR_GoToPos" , "DeleteAllItems" )
      DoMethod( "WinHotRecovery" , "CHR_GoToPos" , "AddItem" , padl( "Top" , 10 ) )
      for i := 1 to HR_nTotalDiff
         DoMethod( "WinHotRecovery" , "CHR_GoToPos" , "AddItem" , padl( alltrim( str( i ) ) , 10 ) )
      next
      SetProperty( "WinHotRecovery" , "CHR_GoToPos" , "value" , 1 )
   endif
   ferase( cFileBase )
   ferase( cFileNew )
Return HR_cCompareFileOutput

Function QPM_HotGetNameVersionsFrom( cWin , cGrid , nValue )
   $US_Log()
Return "Version " + GetProperty( cWin , cGrid , "cell" , nValue , DEF_N_VER_COLVERSION ) + " Of " + US_FileNameOnlyNameAndExt( GetProperty( cWin , cGrid , "cell" , nValue , DEF_N_VER_COLFULLNAME ) ) + " From " + ;
                                                                                                GetProperty( cWin , cGrid , "cell" , nValue , DEF_N_VER_COLFULLNAME )

Function QPM_HotGetNameItemTarget( cWin , cGrid , nValue )
   $US_Log()
Return GetProperty( cWin , cGrid , "cell" , nValue , DEF_N_ITEM_COLFULLNAME )

Function QPM_HotGetNameVersionsTarget( cWin , cGrid , nValue )
   $US_Log()
Return "Version " + GetProperty( cWin , cGrid , "cell" , nValue , DEF_N_VER_COLVERSION ) + " Of " + US_FileNameOnlyNameAndExt( GetProperty( cWin , cGrid , "cell" , nValue , DEF_N_VER_COLFULLNAME ) ) + " From " + ;
                                                                                                GetProperty( cWin , cGrid , "cell" , nValue , DEF_N_VER_COLFULLNAME )

Function QPM_HotGetNameExternal( cFile )
   $US_Log()
Return cFile

Function QPM_HotRecoveryProcess()
   Private cFromDescri := ""
   Private cTargetDescri := ""
   Private cFromFile := ""
   Private cTargetFile := ""
   Private cFileAux  := US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + "_" + PUB_cSecu + "AuxiliarHotRecovery" + US_DateTimeCen() + ".tmp"
   Private PRI_cVersion := GetProperty( "WinHotRecovery" , "HR_GridVersionsFrom" + HR_cHotItemType , "cell" , GetProperty( "WinHotRecovery" , "HR_GridVersionsFrom" + HR_cHotItemType , "value" ) , DEF_N_VER_COLVERSION )
   $US_Log()
   if GridImage( "WinHotRecovery" , "HR_GridItemTarget" + HR_cHotItemType , GetProperty( "WinHotRecovery" , "HR_GridItemTarget" + HR_cHotItemType , "value" ) , DEF_N_ITEM_COLIMAGE , "?" , PUB_nGridImgEdited )
      MsgStop( "You can't recover into an edited file, finish edit and retry again." )
      Return .F.
   endif
   if GridImage( "WinHotRecovery" , "HR_GridItemTarget" + HR_cHotItemType , GetProperty( "WinHotRecovery" , "HR_GridItemTarget" + HR_cHotItemType , "value" ) , DEF_N_ITEM_COLIMAGE , "?" , PUB_nGridImgEquis )
      MsgStop( "You can't recover into an missing file." )
      Return .F.
   endif
   if GetProperty( "WinHotRecovery" , "HR_GridVersionsFrom" + HR_cHotItemType , "itemcount" ) < 1
      MsgStop( "No versions found for this component." )
      Return .F.
   endif
   cTargetDescri := GetProperty( "WinHotRecovery" , "HR_GridItemTarget" + HR_cHotItemType , "cell" , GetProperty( "WinHotRecovery" , "HR_GridItemTarget" + HR_cHotItemType , "value" ) , DEF_N_ITEM_COLFULLNAME )
// cTargetFile   := GetProperty( "WinHotRecovery" , "HR_GridItemTarget" + HR_cHotItemType , "cell" , GetProperty( "WinHotRecovery" , "HR_GridItemTarget" + HR_cHotItemType , "value" ) , DEF_N_ITEM_COLFULLNAME )
   cTargetFile   := GetProperty( "WinHotRecovery" , "HR_GridItemTarget" + HR_cHotItemType , "cell" , GetProperty( "WinHotRecovery" , "HR_GridItemTarget" + HR_cHotItemType , "value" ) , DEF_N_ITEM_COLRELATIVENAME )
   if GetProperty( "WinHotRecovery" , "HR_FileFrom" , "value" ) == 1
      cFromDescri := "Version " + PRI_cVersion + ;
                   " of " + US_FileNameOnlyNameAndExt( cTargetDescri )
      cFromFile := cFileAux
   else
      cFromDescri := GetProperty( "WinHotRecovery" , "THR_ExternalFileFrom" , "value" )
      cFromFile   := GetProperty( "WinHotRecovery" , "THR_ExternalFileFrom" , "value" )
      if !file( cFromFile )
         if alltrim( cFromFile ) == ""
            MsgInfo( "External file isn't complete." )
            return .F.
         else
            MsgInfo( "External File not found: " + cFromFile )
            return .F.
         endif
      endif
   endif
   if MyMsgYesNo( "Recovery Process will be replace 'Target' File with 'From' File"                   + HB_OsNewLine() + ;
                  "and will generate a new version with 'Target' file content before the copy"        + HB_OsNewLine() + ;
                                                                                                        HB_OsNewLine() + ;
                  "'From'   File: " + cFromDescri                                                     + HB_OsNewLine() + ;
                  "'Target' File: " + cTargetDescri                                                   + HB_OsNewLine() + ;
                                                                                                        HB_OsNewLine() + ;
                  "Are you sure?" )
      if QPM_Wait( "QPM_HotRecoveryProcessYes()" , "Recovering..." )
         HotGridImage( "WinHotRecovery" , "HR_GridVersionsFrom" + HR_cHotItemType , 1 , DEF_N_VER_COLIMAGE , "+" , HotGridImgTarget )
         HotGridImage( "WinHotRecovery" , "HR_GridVersionsTarget" + HR_cHotItemType , 1 , DEF_N_VER_COLIMAGE , "+" , HotGridImgTarget )
         QPM_Wait( "HotPutCommentWithOutImage( 'Generated by Recovery Process' )" , "Adding Comment" )
         if GetProperty( "WinHotRecovery" , "HR_FileFrom" , "value" ) == 1
            if ( val( PRI_cVersion ) * -1 ) < HR_nVersionsSet
               HotGridImage( "WinHotRecovery" , "HR_GridVersionsFrom" + HR_cHotItemType , ( val( PRI_cVersion ) - 1 ) * -1 , DEF_N_VER_COLIMAGE , "+" , HotGridImgFrom )
               HotGridImage( "WinHotRecovery" , "HR_GridVersionsTarget" + HR_cHotItemType , ( val( PRI_cVersion ) - 1 ) * -1 , DEF_N_VER_COLIMAGE , "+" , HotGridImgFrom )
            endif
            MsgInfo( "Recovery Process Succesfull."                                                     + HB_OsNewLine() + ;
                                                                                                         HB_OsNewLine() + ;
                     "Old Target file copied to version -1"                                            + HB_OsNewLine() + ;
                     "Old Version " + PRI_cVersion + " restored in Target File"                        + HB_OsNewLine() + ;
                     "Old Version -1 moved to version -2" )
         else
            MsgInfo( "Recovery Process Succesfull."                                                     + HB_OsNewLine() + ;
                                                                                                         HB_OsNewLine() + ;
                     "Old Target file copied to version -1"                                            + HB_OsNewLine() + ;
                     "Old Version -1 moved to version -2"                                             + HB_OsNewLine() + ;
                     "External File copied to Target File" )
         endif
      endif
   endif
   ferase( cFileAux )
   DoMethod( "WinHotRecovery" , HR_cFocus , "setfocus" )
Return .T.

Function QPM_HotRecoveryProcessYes()
   Local bError := .F.
   Local nCode     := 0
   Local cHotRecoveryFile
   $US_Log()
   if GetProperty( "WinHotRecovery" , "HR_FileFrom" , "value" ) == 1
      if !QPM_Memowrit( cFileAux , QPM_HotObtengo( GetProperty( "WinHotRecovery" , "HR_GridVersionsFrom" + HR_cHotItemType , "cell" , GetProperty( "WinHotRecovery" , "HR_GridVersionsFrom" + HR_cHotItemType , "value" ) , DEF_N_VER_COLCODE ) ) , .T. )
         MsgInfo( "Error while extract Hot Recovery Versions, process canceled." )
         bError := .T.
      endif
   endif
   if !bError
      cHotRecoveryFile := US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + "_" + PUB_cSecu + "SrcHOTRecovery" + US_DateTimeCen() + ".hot"
      US_FileCopy( ChgPathToReal( cTargetFile ) , cHotRecoveryFile )
      SetFDaTi( cHotRecoveryFile , US_FileDate( ChgPathToReal( cTargetFile ) ) , US_FileTime( ChgPathToReal( cTargetFile ) ) )
      nCode := QPM_HotRecovery( "ADD" , "RECOVERY" , HR_cHotItemType , cTargetFile , cHotRecoveryFile )
      if US_FileCopy( cFromFile , ChgPathToReal( cTargetFile ) ) != US_FileSize( cFromFile )
         MsgInfo( "Error while copy Hot Recovery Versions to Item, process canceled." )
         US_Log( 'Funcion sin implementar: QPM_HotRecovery( "DELETE" , "RECOVERY" , HR_cHotItemType , nCode )' )
         bError := .T.
      endif
      HR_bSuspendChangeGrid := .T.
      QPM_HotCargoVersions( HR_cHotItemType )
      HR_bSuspendChangeGrid := .F.
      QPM_HotCargoMemo( "FROM" , "VERSIONS" , HR_cHotItemType )
      QPM_HotCargoMemo( "TARGET" , "ITEM" , HR_cHotItemType )
      SetProperty( "WinHotRecovery" , "HR_GridItemTarget" + HR_cHotItemType , "cell" , GetProperty( "WinHotRecovery" , "HR_GridItemTarget" + HR_cHotItemType , "value" ) , DEF_N_ITEM_COLDATETIME , ;
                   US_Dis_DateSeconds2( DToS( US_FileDate( ChgPathToReal( GetProperty( "WinHotRecovery" , "HR_GridItemTarget" + HR_cHotItemType , "cell" , GetProperty( "WinHotRecovery" , "HR_GridItemTarget" + HR_cHotItemType , "value" ) , DEF_N_ITEM_COLFULLNAME ) ) ) ) + ;
                   US_StrCero( US_TimeSec( US_FileTime( ChgPathToReal( GetProperty( "WinHotRecovery" , "HR_GridItemTarget" + HR_cHotItemType , "cell" , GetProperty( "WinHotRecovery" , "HR_GridItemTarget" + HR_cHotItemType , "value" ) , DEF_N_ITEM_COLFULLNAME ) ) ) ) , 5 ) ) )
      QPM_HotChangeFrom( B_SYSOUT_NO )
      QPM_HotChangeTarget( B_SYSOUT_NO )
      QPM_HotChangeSysOut()
   endif
Return !bError

Function HotNavigate( nPos )
   $US_Log()
   SetProperty( "WinHotRecovery" , "LHR_NavigatePos" , "value" , "Difference " + alltrim( str( nPos ) ) + " / " + alltrim( str( HR_nTotalDiff ) ) )
   if nPos == 0
      SetProperty( "WinHotRecovery" , "BHR_NavigatePrev" , "enabled" , .F. )
      if nPos == HR_nTotalDiff
         SetProperty( "WinHotRecovery" , "BHR_NavigateNext" , "enabled" , .F. )
      else
         SetProperty( "WinHotRecovery" , "BHR_NavigateNext" , "enabled" , .T. )
      endif
   else
      SetProperty( "WinHotRecovery" , "BHR_NavigatePrev" , "enabled" , .T. )
      if nPos == HR_nTotalDiff
         SetProperty( "WinHotRecovery" , "BHR_NavigateNext" , "enabled" , .F. )
      else
         SetProperty( "WinHotRecovery" , "BHR_NavigateNext" , "enabled" , .T. )
      endif
   endif
   if nPos == 0
      o_HTML:Navigate( "file:///" + HR_cCompareFileOutput )
   else
      o_HTML:Navigate( "file:///" + HR_cCompareFileOutput + "#c" + alltrim( str( nPos - 1 ) ) )
   endif
   DoMethod( "WinHotRecovery" , HR_cFocus , "setfocus" )
Return .T.

Function QPM_HotRecoveryOptions()
   $US_Log()
   DEFINE WINDOW HR_WinOptions ;
          AT 0 , 0 ;
          WIDTH 360 ;
          HEIGHT 145 ;
          TITLE "Hot Recovery Options" ;
          MODAL ;
          NOSYSMENU ;
          ON INTERACTIVECLOSE US_NOP()

      @ 13 , 40 LABEL L_Versions_Limit ;
         VALUE 'Versions Limit (' + alltrim( str( HR_nVersionsMinimun ) ) + ' to ' + replicate( "9" , HR_nVersionsDigitosMax ) + '):' ;
         AUTOSIZE ;
         FONT 'arial' SIZE 10 BOLD ;
         FONTCOLOR DEF_COLORBLUE

      @ 13 , 250 TEXTBOX T_Version_Limit ;
             WIDTH           50 ;
             VALUE           HR_nVersionsSet ;
             NUMERIC            ;
             INPUTMASK       replicate( "9" , HR_nVersionsDigitosMax ) ;

      DEFINE BUTTON B_OK
             ROW             GetProperty( "HR_WinOptions" , "Height" ) - 80
             COL             80
             WIDTH           80
             HEIGHT          25
             CAPTION         'OK'
             TOOLTIP         'Confirm Changes'
             ONCLICK         if( HotRecoverySaveOptions() , DoMethod( "HR_WinOptions" , "Release" ) , US_Nop() )
      END BUTTON

      DEFINE BUTTON B_CANCEL
             ROW             GetProperty( "HR_WinOptions" , "Height" ) - 80
             COL             190
             WIDTH           80
             HEIGHT          25
             CAPTION         'Cancel'
             TOOLTIP         'Cancel Changes'
             ONCLICK         DoMethod( "HR_WinOptions" , "Release" )
      END BUTTON

   END WINDOW

   CENTER   WINDOW HR_WinOptions

   ACTIVATE WINDOW HR_WinOptions

Return .T.

Function HotRecoverySaveOptions()
   $US_Log()
   if GetProperty( "HR_WinOptions" , "T_Version_Limit" , "value" ) < HR_nVersionsMinimun
      MsgStop( "Value out range." )
      DoMethod( "HR_WinOptions" , "T_Version_Limit" , "SetFocus" )
      Return .F.
   endif
   if GetProperty( "HR_WinOptions" , "T_Version_Limit" , "value" ) < HR_nVersionsSet
      if MyMsgYesNo( "If you set Versions value less to " + alltrim( str( HR_nVersionsSet ) ) + " (actual value), QPM will be delete old versions greater to " + alltrim( str( GetProperty( "HR_WinOptions" , "T_Version_Limit" , "value" ) ) ) + ;
                   HB_OsNewLine() + ;
                   HB_OsNewLine() + "Are you sure?" )
         QPM_Wait( 'HotRecoverySaveOptionsClear( "HR_SECU" , GetProperty( "HR_WinOptions" , "T_Version_Limit" , "value" ) ) ' , "Cleaning versions greater " + alltrim( str( HR_nVersionsSet ) ) + "..." )
         QPM_Wait( "HotRecoveryReindex()" , "Reindexing Hot Recovery Database" )
      else
         DoMethod( "HR_WinOptions" , "T_Version_Limit" , "SetFocus" )
         Return .F.
      endif
   endif
   HR_nVersionsSet := GetProperty( "HR_WinOptions" , "T_Version_Limit" , "value" )
   MsgInfo( "New Hot Recovery Version limit set to " + alltrim( str( HR_nVersionsSet ) ) )
Return .T.

Function HotRecoverySaveOptionsClear( cCampo , nLimit )
   Local OPEN_cAreaOld := DBF()
   Local OPEN_nSecondsInit := Seconds()
   Local OPEN_cOldTxt := GetMGWaitTxt()
   $US_Log()
   Do While !US_DBUseArea( .T. , "DBFCDX" , QPM_HR_Database , "HOTREC" , DEF_DBF_EXCLUSIVE , DEF_DBF_WRITE ) .and. ( seconds() - OPEN_nSecondsInit ) < HR_nLookTimeOut
      SetMGWaitTxt( "Waiting for Hot Recovery Database: " + alltrim( str( int( HR_nLookTimeOut - ( seconds() - OPEN_nSecondsInit ) ) ) ) + " seconds..." )
      DO EVENTS
   enddo
   SetMGWaitTxt( OPEN_cOldTxt )
   if dbf() == "HOTREC"
      QPM_HotRecoveryClear( cCampo , nLimit )
      DBCloseArea( "HOTREC" )
   else
      MsgStop( "Unable to open Hot Recovery Database in EXCLUSIVE mode." )
   endif
   if !empty( OPEN_cAreaOld )
      DBSelectArea( OPEN_cAreaOld )
   endif
Return .T.

Function HotRecoveryReindex()
   Local OPEN_cAreaOld := DBF()
   Local OPEN_nSecondsInit := Seconds()
   Local OPEN_cOldTxt := GetMGWaitTxt()
   $US_Log()
   Do While !US_DBUseArea( .T. , "DBFCDX" , QPM_HR_Database , "HOTREC" , DEF_DBF_EXCLUSIVE , DEF_DBF_WRITE ) .and. ( seconds() - OPEN_nSecondsInit ) < HR_nLookTimeOut
      SetMGWaitTxt( "Waiting for Hot Recovery Database: " + alltrim( str( int( HR_nLookTimeOut - ( seconds() - OPEN_nSecondsInit ) ) ) ) + " seconds..." )
      DO EVENTS
   enddo
   SetMGWaitTxt( OPEN_cOldTxt )
   if dbf() == "HOTREC"
      SetMGWaitHide()
      HotRecoveryReindex2( "HOTREC" , "HR_COD", "HR_COD01" , "PACK" )
      HotRecoveryReindex2( "HOTREC" , "HR_HASH + US_StrCero( HR_SECU , HR_nVersionsDigitosMax )", "HR_HASH01" )
      SetMGWaitShow()
      DBCloseArea( "HOTREC" )
   else
      MsgStop( "Unable to open Hot Recovery Database in EXCLUSIVE mode." )
   endif
   if !empty( OPEN_cAreaOld )
      DBSelectArea( OPEN_cAreaOld )
   endif
Return .T.

Function HotRecoveryReindex2(cBase, cClave, cNombre, cPack)
   Local bPack:=.F.
   Private Incremento:=1
   $US_Log()
   if !empty(cPack) .and. upper(cPAck) = "PACK"
      bPack:=.T.
   endif
   DEFINE WINDOW HotRecoveryReindex2Menu;
      AT 0,0 ;
      WIDTH 330 HEIGHT 150 ;
      TITLE " Indexing... ";
      USMODAL;
      NOCAPTION ;
      ON INIT HotRecoveryReindex2_Creacion(cBase, cClave, cNombre, bPack)

      @ 10, 10 LABEL LCaption ;
         WIDTH 400 ;
         HEIGHT 20 ;
         VALUE "Indexing...";
         FONT "Courier New" SIZE 12 BOLD FONTCOLOR DEF_COLORBLUE

      @ 30, 10 LABEL LOpcionPack;
         WIDTH 400 ;
         HEIGHT 20 ;
         VALUE "Opcion PACK: NO";
         FONT "Courier New" SIZE 10 FONTCOLOR DEF_COLORBLUE

      @ 50, 10 PROGRESSBAR PProgressIndex ;
         RANGE 0, 100 ;
         WIDTH 300 ;
         HEIGHT 15 ;
         SMOOTH

      @ 70, 10  LABEL LInxNombre;
         WIDTH 100;
         HEIGHT 20 ;
         VALUE 'Indexing';
         FONT "Courier New" SIZE 10 FONTCOLOR DEF_COLORBLUE

      @ 70, 100  LABEL TInxNombre;
         WIDTH 100;
         HEIGHT 20 ;
         VALUE STR(0);
         FONT "Courier New" SIZE 10 FONTCOLOR DEF_COLORRED

      @ 90, 10  LABEL LRegistro;
         WIDTH 110;
         HEIGHT 20 ;
         VALUE 'Record N° --->';
         FONT "Courier New" SIZE 10 FONTCOLOR DEF_COLORRED

      @ 90, 120  LABEL TRegistro;
         WIDTH 100;
         HEIGHT 20 ;
         VALUE STR(0);
         FONT "Courier New" SIZE 10 FONTCOLOR DEF_COLORRED

      @ 110, 10  LABEL LPorcentaje;
         WIDTH 120;
         HEIGHT 20 ;
         VALUE 'Generated --->';
         FONT "Courier New" SIZE 10 FONTCOLOR DEF_COLORRED

      @ 110, 120  LABEL TPorcentaje;
         WIDTH 100;
         HEIGHT 20 ;
         VALUE STR(0);
         FONT "Courier New" SIZE 10 FONTCOLOR DEF_COLORRED

   END WINDOW
   CENTER WINDOW HotRecoveryReindex2Menu
   ACTIVATE WINDOW HotRecoveryReindex2Menu
RETURN NIL

FUNCTION HotRecoveryReindex2_Creacion(cBase,cClave,cNombre,bPack)
   $US_Log()
   if reccount() < 101
      Incremento:=int(reccount() / 100)
   endif
   if bPack
      HotRecoveryReindex2Menu.LOpcionPack.Value:="Opcion PACK: YES"
      DoMethod( "HotRecoveryReindex2Menu" , "hide" )
      QPM_Wait( "HotRecoveryReindex2_Packing()" , "Packing HotRecovery Database..." )
      DoMethod( "HotRecoveryReindex2Menu" , "show" )
   else
      HotRecoveryReindex2Menu.LOpcionPack.Value:="Opcion PACK: NO"
   endif
   index on &cClave TAG (cNombre) EVAL { || HotRecoveryReindex2_IndexMeter(LASTREC(),cNombre)} EVERY Incremento
   HotRecoveryReindex2Menu.release()
RETURN NIL

FUNCTION HotRecoveryReindex2_Packing()
   PACK
Return .T.

FUNCTION HotRecoveryReindex2_IndexMeter(mTamagno, NombreIndice)
   Local  nCompletado, registro
   $US_Log()
   registro:=recno()
   nCompletado := INT((registro/mTamagno) * 100)
   HotRecoveryReindex2Menu.PProgressIndex.value:=nCompletado
   HotRecoveryReindex2Menu.TInxNombre.value:=NombreIndice
   HotRecoveryReindex2Menu.TRegistro.value:=str(registro,10)
   HotRecoveryReindex2Menu.TPorcentaje.value:=str(nCompletado, 9, 2)+'%'
RETURN(.T.)

Function HotGetComment( cType , bOnlyDbf , nRecCode )
   Local cGrid := "HR_GridVersions"
   Local cAux := ""
   Local nValue := 0
   Local OPEN_cAreaOld := DBF()
   Local OPEN_nSecondsInit := 0
   Local nAuxCode := 0
   Local bActualizar := .F.
   Local oInput := US_InputBox():New()
   $US_Log()
   if empty( bOnlyDbf )
      bOnlyDbf := .F.
   endif
   if bOnlyDbf
      oInput:cTitulo := "Comment for new Hot Recovery Versions"
      oInput:ValorInicial := "Hot Recovery generated at " + US_TimeDis( Time() )
   else
      nValue := GetProperty( "WinHotRecovery" , cGrid + cType + HR_cHotItemType , "value" )
      oInput:cTitulo := "Comment for version " + GetProperty( "WinHotRecovery" , cGrid + cType + HR_cHotItemType , "cell" , nValue , DEF_N_VER_COLVERSION )
      oInput:ValorInicial := alltrim( GetProperty( "WinHotRecovery" , cGrid + cType + HR_cHotItemType , "cell" , nValue , DEF_N_VER_COLCOMMENT ) )
   endif
   oInput:cLeyenda :=  "Comment:"
   oInput:bEscape := .T.
   oInput:nPorAlto := if( PUB_bW800 , 30 , 20 )
   oInput:nPorAncho := 60
   oInput:bButtonOk := .T.
   oInput:bButtonCancel := .T.
   oInput:DefineWindow()
   cAux := oInput:Show()
   if bOnlyDbf
      if cAux != NIL
         bActualizar := .T.
      endif
   else
      if cAux != NIL .and. ;
         !( alltrim( cAux ) == alltrim( GetProperty( "WinHotRecovery" , cGrid + cType + HR_cHotItemType , "cell" , nValue , DEF_N_VER_COLCOMMENT ) ) )
         bActualizar := .T.
      endif
   endif
   if bActualizar
      OPEN_nSecondsInit := Seconds()
      Do While !US_DBUseArea( .T. , "DBFCDX" , QPM_HR_Database , "HOTREC" , DEF_DBF_EXCLUSIVE , DEF_DBF_WRITE ) .and. ( seconds() - OPEN_nSecondsInit ) < HR_nLookTimeOut
         SetMGWaitTxt( "Waiting for Hot Recovery Database: " + alltrim( str( int( HR_nLookTimeOut - ( seconds() - OPEN_nSecondsInit ) ) ) ) + " seconds..." )
         DO EVENTS
      enddo
      if bOnlyDbf
         nAuxCode := nRecCode
      else
         nAuxCode := val( GetProperty( "WinHotRecovery" , cGrid + cType + HR_cHotItemType , "cell" , nValue , DEF_N_VER_COLCODE ) )
      endif
      if dbf() == "HOTREC"
         OrdSetFocus( "HR_COD01" )
         if DBSeek( nAuxCode )
            HotPutComment( cAux )
            if !bOnlyDbf
               SetProperty( "WinHotRecovery" , cGrid + "FROM"   + HR_cHotItemType , "cell" , nValue , DEF_N_VER_COLCOMMENT , cAux )
               SetProperty( "WinHotRecovery" , cGrid + "TARGET" + HR_cHotItemType , "cell" , nValue , DEF_N_VER_COLCOMMENT , cAux )
               if alltrim( cAux ) == ""
                  HotGridImage( "WinHotRecovery" , "HR_GridVersionsFrom" + HR_cHotItemType , nValue , DEF_N_VER_COLIMAGE , "-" , HotGridImgComment )
                  HotGridImage( "WinHotRecovery" , "HR_GridVersionsTarget" + HR_cHotItemType , nValue , DEF_N_VER_COLIMAGE , "-" , HotGridImgComment )
               else
                  HotGridImage( "WinHotRecovery" , "HR_GridVersionsFrom" + HR_cHotItemType , nValue , DEF_N_VER_COLIMAGE , "+" , HotGridImgComment )
                  HotGridImage( "WinHotRecovery" , "HR_GridVersionsTarget" + HR_cHotItemType , nValue , DEF_N_VER_COLIMAGE , "+" , HotGridImgComment )
               endif
            endif
         else
            MsgStop( "This Hot Recovery Version Doesn't Exists !!!" )
         endif
         DBCloseArea( "HOTREC" )
      else
         MsgStop( "Unable to open Hot Recovery Database in EXCLUSIVE mode." )
      endif
      if !empty( OPEN_cAreaOld )
         DBSelectArea( OPEN_cAreaOld )
      endif
   endif
Return .T.

Function HotPutComment( cComment )
   Local nInx := 0
   Local cAuxLinea := "" , cOutMemo := ""
   $US_Log()
   for nInx := 1 to MLCount( HR_DATA , 254 )
      cAuxLinea := MemoLine( HR_DATA , 254 , nInx )
      do case
         case US_Upper( US_Word( cAuxLinea , 1 ) ) == "COMMENT"
            US_Nop()
         otherwise
            cOutMemo := cOutMemo + cAuxLinea + HB_OsNewLine()
      endcase
   next
   cOutMemo := cOutMemo + "COMMENT " + cComment
   REPLACE HR_DATA with cOutMemo
Return .T.

Function HotGridImage( cWin , cGrid , nRow , nCol , cOper , nBitImage )
   Local nBits := ( 2 ** nHotPUB_nGridImgTop ) // ej: 9 imagenes primarias = 256 ( HotPUB_nGridImgTilde, HotPUB_nGridImgEquis, etc )
   Local i , cString , nAux
   $US_Log()
   if nRow < 1
      Return .F.
   endif
   if ( nAux := aScan( vHotImagesTranslateGrid , { |x| x[2] == GetProperty( cWin , cGrid , "Cell" , nRow , nCol ) } ) ) == 0
      MsgInfo( "Error en posicionamiento en Funcion HotGridImage para el valor: " + us_todoStr( GetProperty( cWin , cGrid , "Cell" , nRow , nCol ) ) )
      Return .F.
   endif
   cString := NTOC( vHotImagesTranslateGrid[ nAux ][ 1 ] , 2 , nBits , "0" )
   For i:=1 to len( cOper )
      do case
         case substr( cOper , i , 1 ) == "?"              /* preguntar si esta activo */
            if substr( cString , nBits - nBitImage + 1 , 1 ) == "1"
               return .T.
            else
               return .F.
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
            MsgInfo( "Error in operator from Function HotGridImage." )
      endcase
   Next i
   if ( nAux := aScan( vHotImagesTranslateGrid , { |x| x[1] == CTON( cString , 2 ) } ) ) == 0
      MsgInfo( "Error en posicionamiento (2) en Funcion HotGridImage para el valor: " + us_todoStr( CTON( cString , 2 ) ) )
      Return .F.
   endif
   SetProperty( cWin , cGrid , "Cell" , nRow , nCol , vHotImagesTranslateGrid[ nAux ][ 2 ] )
Return .F.

Function HotPutCommentWithOutImage( cComment )
   Local OPEN_cAreaOld := DBF()
   Local OPEN_nSecondsInit := 0
   $US_Log()
   OPEN_nSecondsInit := Seconds()
   Do While !US_DBUseArea( .T. , "DBFCDX" , QPM_HR_Database , "HOTREC" , DEF_DBF_EXCLUSIVE , DEF_DBF_WRITE ) .and. ( seconds() - OPEN_nSecondsInit ) < HR_nLookTimeOut
      SetMGWaitTxt( "Waiting for Hot Recovery Database: " + alltrim( str( int( HR_nLookTimeOut - ( seconds() - OPEN_nSecondsInit ) ) ) ) + " seconds..." )
      DO EVENTS
   enddo
   if dbf() == "HOTREC"
      OrdSetFocus( "HR_COD01" )
      if DBSeek( val( GetProperty( "WinHotRecovery" , "HR_GridVersionsFrom" + HR_cHotItemType , "cell" , 1 , DEF_N_VER_COLCODE ) ) )
         HotPutComment( cComment )
         SetProperty( "WinHotRecovery" , "HR_GridVersionsFrom" + HR_cHotItemType , "cell" , 1 , DEF_N_VER_COLCOMMENT , cComment )
         SetProperty( "WinHotRecovery" , "HR_GridVersionsTarget" + HR_cHotItemType , "cell" , 1 , DEF_N_VER_COLCOMMENT , cComment )
      else
         MsgStop( "This Hot Recovery Version Doesn't Exists !!!" )
      endif
      DBCloseArea( "HOTREC" )
   else
      MsgStop( "Unable to open Hot Recovery Database in EXCLUSIVE mode." )
   endif
   if !empty( OPEN_cAreaOld )
      DBSelectArea( OPEN_cAreaOld )
   endif
Return .T.

Function QPM_ForceHotRecovery( Par_cType )
   Local nValue := GetProperty( "VentanaMain" , "G"+Par_cType+"Files" , "Value" )
   Local HotRecoveryControlFile := US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + "_" + PUB_cSecu + "Force"+Par_cType+"HOTRecovery" + US_DateTimeCen() + ".hot"
   Local nRecCode := 0
   Private cType := Par_cType
   $US_Log()
   if Prj_Radio_OutputType == DEF_RG_IMPORT
      MsgStop( "Hot Recovery Version don't support DLL files." )
      Return .T.
   endif
   if !US_IsDirectory( PUB_cProjectFolder )
      MsgStop( "Project Folder not Found: " + PUB_cProjectFolder + '. Look at ' + PagePRG )
      Return .T.
   endif
   If nValue == 0
      MsgStop( "File not selected !!!" )
      Return .T.
   EndIf
   if !File( ChgPathToReal( GetProperty( "VentanaMain" , "G"+cType+"Files" , "Cell" , nValue , &( "nCol"+cType+"FullName" ) ) ) )
      MsgStop( "File not found !!!" )
      Return .F.
   endif
   if MyMsgYesNo( "Do you create new Hot Recovery Version for" + HB_OsNewLine() + HB_OsNewLine() + ;
                ChgPathToReal( GetProperty( "VentanaMain" , "G"+cType+"Files" , "Cell" , nValue , &( "nCol"+cType+"FullName" ) ) ) )
      US_FileCopy( ChgPathToReal( GetProperty( "VentanaMain" , "G"+cType+"Files" , "Cell" , nValue , &( "nCol"+cType+"FullName" ) ) ) , HotRecoveryControlFile )
      SetFDaTi( HotRecoveryControlFile , US_FileDate( ChgPathToReal( GetProperty( "VentanaMain" , "G"+cType+"Files" , "Cell" , nValue , &( "nCol"+cType+"FullName" ) ) ) ) , US_FileTime( ChgPathToReal( GetProperty( "VentanaMain" , "G"+cType+"Files" , "Cell" , nValue , &( "nCol"+cType+"FullName" ) ) ) ) )
      //
      nRecCode := QPM_Wait( "QPM_HotRecovery( 'ADD' , 'FORCE' , cType , '" + GetProperty( "VentanaMain" , "G"+cType+"Files" , "Cell" , nValue , &( "nCol"+cType+"FullName" ) ) + "' , '" + HotRecoveryControlFile + "' )" , "Creating Version File for Hot Recovery..." )
      HotGetComment( cType , .T. , nRecCode )
      MsgInfo( "Hot Recovery Version Succesfull Created !!!" )
   endif
Return .T.

Function HotRecoveryImport()
   Private cAux
   $US_Log()
   cAux := BugGetFile( { {'Hot Recovery ( QPM_HotRecovery_*.dbf )','QPM_HotRecovery_*.dbf'} } , "Select Hot Recovery Version Database for import" , , .F. , .T. )
   if !empty( cAux )
      QPM_Wait( "HotRecoveryImport2( cAux )" , "Importing records..." )
   endif
Return .T.
Function HotRecoveryImport2( cDatabase )
   Local OPEN_nSecondsInit := Seconds()
   Local OPEN_cOldTxt := ""
   Local OPEN_cAreaOld := ""
   Local vStruct := {} , nInx := 0 , nNewCod := 0
   Local cTemp_HR_Database := US_FileNameOnlyPathAndName( QPM_HR_Database ) + "_H_" + PUB_cSecu + "." + US_FileNameOnlyExt( QPM_HR_Database )
   Local cTemp_Database := PUB_cQPM_Folder + DEF_SLASH + US_FileNameOnlyName( cDatabase ) + "_I_" + PUB_cSecu + "." + US_FileNameOnlyExt( cDatabase )
   Local nCont_Added   := 0
   Local nCont_Skipped := 0
   Local nCont_Total   := 0
   Local cHashOld      := space( 32 )
   $US_Log()
us_log( cTemp_HR_Database, .F. )
us_log( cTemp_Database,.F.)
   if upper( QPM_HR_Database ) == upper( cDatabase )
      MsgStop( "Import Database is the same that Hot Recovery Version Database." )
      Return .F.
   endif
   if ! MyMsgYesNo( "Import Hot Recovery Versions Records ?" + HB_OsNewLine() + HB_OsNewLine() + "from: " + cDatabase + HB_OsNewLine() + "  to: " + QPM_HR_Database )
      Return .F.
   endif
   SetMGWaitTxt( "Importing Records (Fase 1 of 16)" )
   DO EVENTS
   OPEN_cAreaOld := dbf()
   OPEN_cOldTxt := GetMGWaitTxt()
   Do While !US_DBUseArea( .T. , "DBFCDX" , QPM_HR_Database , "HOTREC" , DEF_DBF_EXCLUSIVE , DEF_DBF_WRITE ) .and. ( seconds() - OPEN_nSecondsInit ) < HR_nLookTimeOut
      SetMGWaitTxt( "Waiting for Hot Recovery Database: " + alltrim( str( int( HR_nLookTimeOut - ( seconds() - OPEN_nSecondsInit ) ) ) ) + " seconds..." )
      DO EVENTS
   enddo
   SetMGWaitTxt( OPEN_cOldTxt )
   if !( dbf() == "HOTREC" )
      US_Log( "Error opening HotRecovery Database in Exclusive Mode for Import Records: " + QPM_HR_Database )
      if !empty( OPEN_cAreaOld )
         DBSelectArea( OPEN_cAreaOld )
      endif
      return .F.
   else
      SetMGWaitTxt( "Importing Records (Fase 1 of 16)" )    // Refuerzo fase 1 por problemas de display
      if US_FileCopy( cDatabase , cTemp_Database ) != US_FileSize( cDatabase ) .or. ;
         US_FileCopy( US_FileNameOnlyPathAndName( cDatabase ) + ".fpt" , US_FileNameOnlyPathAndName( cTemp_Database ) + ".fpt" ) != US_FileSize( US_FileNameOnlyPathAndName( cDatabase ) + ".fpt" )
         US_Log( "Error copying Database for import process in Hot Recovery Versions database: " + cDatabase )
         DbClosearea( "HOTREC" )
         if !empty( OPEN_cAreaOld )
            DBSelectArea( OPEN_cAreaOld )
         endif
         return .F.
      else
         HotRecoveryDatabaseCompatibility( cTemp_Database )
      endif
      SetMGWaitTxt( "Importing Records (Fase 2 of 16)" )
      COPY TO ( cTemp_HR_Database )
      SetMGWaitTxt( "Importing Records (Fase 3 of 16)" )
      US_DB_CMP( US_FileNameOnlyPathAndName( cTemp_HR_Database ) , "ADD" , "___UNIQUE"  , "C" , 32 , 0 )
      SetMGWaitTxt( "Importing Records (Fase 4 of 16)" )
      US_DB_CMP( US_FileNameOnlyPathAndName( cTemp_HR_Database ) , "ADD" , "___DATETIM" , "C" , 13 , 0 )
      if !US_DbUseArea( .T. , "DBFCDX" , cTemp_HR_Database , "__HOTCOMPAT" )
         US_Log( "Error opening Temporary Hor Recovery Versions Database in sharde mode: " + cTemp_HR_Database )
         DbClosearea( "HOTREC" )
         if !empty( OPEN_cAreaOld )
            DBSelectArea( OPEN_cAreaOld )
         endif
         Return .T.
      endif
      SetMGWaitTxt( "Importing Records (Fase 5 of 16)" )
      REPLACE ___UNIQUE  with HB_MD5( HR_HASH + HB_MD5( upper( US_ExtractMemoKey( HR_DATA , "VERSION_COMPUTER" ) ) ) + HB_MD5( upper( US_ExtractMemoKey( HR_DATA , "VERSION_USER" ) ) ) + HB_MD5( US_ExtractMemoKey( HR_DATA , "VERSION_DATETIME" ) ) ) ALL
      SetMGWaitTxt( "Importing Records (Fase 6 of 16)" )
      REPLACE ___DATETIM with US_ExtractMemoKey( HR_DATA , "VERSION_DATETIME" ) ALL
      SetMGWaitTxt( "Importing Records (Fase 7 of 16)" )
      INDEX ON HR_COD                                                            TAG "___COD"
      SetMGWaitTxt( "Importing Records (Fase 8 of 16)" )
      INDEX ON ___UNIQUE                                                         TAG "___UNIQUE"
      SetMGWaitTxt( "Importing Records (Fase 9 of 16)" )
      INDEX ON HR_HASH+___DATETIM                                                TAG "___DATETIM"
      DbCloseArea( "__HOTCOMPAT" )
      SetMGWaitTxt( "Importing Records (Fase 10 of 16)" )
      US_DB_CMP( US_FileNameOnlyPathAndName( cTemp_Database ) , "ADD" , "___UNIQUE" , "C" , 32 , 0 )
      if !US_DbUseArea( .T. , "DBFCDX" , cTemp_Database , "__IMPCOMPAT" )
         US_Log( "Error opening Temporary Import Database in sharde mode: " + cTemp_Database )
         DbClosearea( "__HOTCOMPAT" )
         DbClosearea( "HOTREC" )
         if !empty( OPEN_cAreaOld )
            DBSelectArea( OPEN_cAreaOld )
         endif
         Return .T.
      endif
      SetMGWaitTxt( "Importing Records (Fase 11 of 16)" )
      REPLACE ___UNIQUE with HB_MD5( HR_HASH + HB_MD5( upper( US_ExtractMemoKey( HR_DATA , "VERSION_COMPUTER" ) ) ) + HB_MD5( upper( US_ExtractMemoKey( HR_DATA , "VERSION_USER" ) ) ) + HB_MD5( US_ExtractMemoKey( HR_DATA , "VERSION_DATETIME" ) ) ) ALL
      DbCloseArea( "__IMPCOMPAT" )
      //
      DbUseArea( .T. , "DBFCDX" , cTemp_HR_Database , "__HOTDB" )
us_log( "abrio base local" , .f. )
      OrdSetFocus( "___COD" )
      DbGoBottom()
us_log( __HOTDB->hr_cod , .f. )
      nNewCod := HR_COD + 1
      OrdSetFocus( "___UNIQUE" )
      DbGoTop()
      vStruct := DbStruct()
      DbUseArea( .t. , "DBFCDX" , cTemp_Database , "__IMPDB" )
us_log( "abrio base __IMPDB" , .f. )
      nCont_Total := RecCount()
      SetMGWaitTxt( "Importing Records (Fase 12 of 16)" )
      do while !eof()
         DbSelectArea( "__HOTDB" )
         if !DBSeek( __IMPDB->___UNIQUE )
            nCont_Added++
            append blank
  us_log( "agrega " + __IMPDB->hr_hash + hb_osNewline() + US_ExtractMemoKey( __IMPDB->hr_data , "RELATIVENAME" ) , .f. )
            for nInx := 1 to len( vStruct )
               if vStruct[nInx][1] == "HR_COD"
                  REPLACE &(vStruct[nInx][1]) with nNewCod
        us_log( "puse cod: " + us_todostr( nNewCod ) , .f. )
                  nNewCod++
               else
                  if !( vStruct[nInx][1] == "___DATETIM" )
                     REPLACE &(vStruct[nInx][1]) with __IMPDB->(&(vStruct[nInx][1]))
                  else
                     REPLACE &(vStruct[nInx][1]) with US_ExtractMemoKey( __IMPDB->HR_DATA , "VERSION_DATETIME" )
                  endif
               endif
            next
         else
            nCont_Skipped++
         endif
         DbSelectarea( "__IMPDB" )
         dbskip()
      enddo
      DbClosearea( "__IMPDB" )
      DbSelectArea( "__HOTDB" )
us_log( "empieza re- secu" , .f. )
      if nCont_Added > 0
us_log( "hay agregados" , .f. )
         OrdSetFocus( "___DATETIM" )
         DbGoBottom()
         SetMGWaitTxt( "Importing Records (Fase 13 of 16)" )
         do while !bof()
            if !( HR_HASH == cHashOld )
               cHashOld := HR_HASH
               nInx := 1
            else
               nInx++
            endif
            if !( nInx == HR_SECU )
     us_log( "cambio secu a hr_cod " + us_todostr( hr_cod ) , .f. )
               REPLACE HR_SECU with nInx
            endif
            dbskip(-1)
         enddo
      endif
      DbSelectArea( "__HOTDB" )
      ORDLISTCLEAR()
      DbClosearea( "__HOTDB" )
      ferase( US_FileNameOnlyPathAndName( cTemp_HR_Database ) + ".cdx" )
      SetMGWaitTxt( "Importing Records (Fase 14 of 16)" )
      US_DB_CMP( US_FileNameOnlyPathAndName( cTemp_HR_Database ) , "DEL" , "___UNIQUE"  , "C" , 32 , 0 )
      SetMGWaitTxt( "Importing Records (Fase 15 of 16)" )
      US_DB_CMP( US_FileNameOnlyPathAndName( cTemp_HR_Database ) , "DEL" , "___DATETIM" , "C" , 13 , 0 )
      ferase( cTemp_Database )
      ferase( US_FileNameOnlyPathAndName( cTemp_Database ) + ".fpt" )
      DbSelectArea( "HOTREC" )
      ZAP
      SetMGWaitTxt( "Importing Records (Fase 16 of 16)" )
      APPEND FROM ( cTemp_HR_Database ) ALL
      DbClosearea( "HOTREC" )
      ferase( cTemp_HR_Database )
      ferase( US_FileNameOnlyPathAndName( cTemp_HR_Database ) + ".fpt" )
      ferase( US_FileNameOnlyPathAndName( cTemp_HR_Database ) + ".cdx" )
      us_log( HB_OsNewLine() + "Added: " + US_TodoStr( nCont_Added ) + HB_OsNewLine() + "Skipped: " + US_TodoStr( nCont_Skipped ) + HB_OsNewLine() + "Total Read: " + US_TodoStr( nCont_Total ),.f. )
      MsgInfo( "Import finished OK." + HB_OsNewLine() + HB_OsNewLine() + "Added: " + US_TodoStr( nCont_Added ) + HB_OsNewLine() + "Skipped: " + US_TodoStr( nCont_Skipped ) + HB_OsNewLine() + "Total Read: " + US_TodoStr( nCont_Total ) )
      if !empty( OPEN_cAreaOld )
         DBSelectArea( OPEN_cAreaOld )
      endif
   endif
Return .T.

Function QPM_HotRecovery_Migrate()
   Local cOldTxt := GetMGWaitTxt(), i
   
   $US_Log()
   Declare vHotR[ ADIR( PUB_MigrateFolderFrom + DEF_SLASH + 'QPM_HotRecovery_*.dbf' ) ]
   Declare vHotRold[ ADIR( PUB_MigrateFolderFrom + DEF_SLASH + 'QAC_HotRecovery_*.dbf' ) ]
   ADIR( PUB_MigrateFolderFrom + DEF_SLASH + 'QPM_HotRecovery_*.dbf' , vHotR )
   ADIR( PUB_MigrateFolderFrom + DEF_SLASH + 'QAC_HotRecovery_*.dbf' , vHotRold )
   For i := 1 to len(vHotRold)
     aAdd( vHotR, vHotRold[i] )
   Next i
   
   if len( vHotR ) > 0
      aSort( vHotR ,,, { |x, y| US_Upper(x) > US_Upper(y) })
      US_FileCopy( PUB_MigrateFolderFrom + DEF_SLASH + vHotR[1] , PUB_cQPM_Folder + DEF_SLASH + 'QPM_HotRecovery_' + PUB_cQPM_Version3 + '.dbf' )
      US_FileCopy( PUB_MigrateFolderFrom + DEF_SLASH + US_FileNameOnlyName( vHotR[1] ) + ".fpt" , PUB_cQPM_Folder + DEF_SLASH + 'QPM_HotRecovery_' + PUB_cQPM_Version3 + '.fpt' )
   // US_FileCopy( PUB_MigrateFolderFrom + DEF_SLASH + US_FileNameOnlyName( vHotR[1] ) + ".cdx" , PUB_cQPM_Folder + DEF_SLASH + 'QPM_HotRecovery_' + PUB_cQPM_Version3 + '.cdx' )
      SetMGWaitTxt( "Reindexing Hot Recovery Database" )
      HotRecoveryReindex()
      SetMGWaitTxt( cOldTxt )
      HotRecoveryDatabaseCompatibility( PUB_cQPM_Folder + DEF_SLASH + 'QPM_HotRecovery_' + PUB_cQPM_Version3 + '.dbf' )
   else
      Private cAuxHRName
      cAuxHRName := US_FileTmp( US_FileNameOnlyPath( QPM_HR_Database ) + DEF_SLASH + "_AddHRDbf" )
      CREATE ( cAuxHRName )
      APPEND BLANK
      REPLACE Field_name WITH "HR_COD",;
              Field_type WITH "N",;
              Field_len WITH 15,;
              Field_dec WITH 0
      APPEND BLANK
      REPLACE Field_name WITH "HR_HASH",;
              Field_type WITH "C",;
              Field_len WITH 32,;
              Field_dec WITH 0
      APPEND BLANK
      REPLACE Field_name WITH "HR_SECU",;
              Field_type WITH "N",;
              Field_len WITH 5,;
              Field_dec WITH 0
      APPEND BLANK
      REPLACE Field_name WITH "HR_DATA_TY",;
              Field_type WITH "C",;
              Field_len WITH 1,;
              Field_dec WITH 0
      APPEND BLANK
      REPLACE Field_name WITH "HR_DATA",;
              Field_type WITH "M",;
              Field_len WITH 10,;
              Field_dec WITH 0
      APPEND BLANK
      REPLACE Field_name WITH "HR_FILE_TY",;
              Field_type WITH "C",;
              Field_len WITH 1,;
              Field_dec WITH 0
      APPEND BLANK
      REPLACE Field_name WITH "HR_FILE",;
              Field_type WITH "M",;
              Field_len WITH 10,;
              Field_dec WITH 0
      USE
      CREATE ( QPM_HR_Database ) FROM ( cAuxHRName )
      INDEX ON HR_COD                                                   TAG "HR_COD01"
      INDEX ON HR_HASH + US_StrCero( HR_SECU , HR_nVersionsDigitosMax ) TAG "HR_HASH01"
      USE
      ferase( cAuxHRName )
      Release cAuxHRName
   endif
Return .t.

Function HotRecoveryDatabaseCompatibility( PRI_COMPATIBILITY_DATABASE )
   $US_Log()
   
//#include "QPM_CompatibilityHotRecovery.ch"
// if US_DbUseArea( .T. , "DBFCDX" , PRI_COMPATIBILITY_DATABASE , "__HOTCOMPAT" )
//    if AScan( DbStruct() , { |x| x[1] == "HR_UNIQUE" } ) == 0
//       DbClosearea( "__HOTCOMPAT" )
//       US_DB_CMP( US_FileNameOnlyPathAndName( PRI_COMPATIBILITY_DATABASE ) , "ADD" , "HR_UNIQUE" , "C" , 32 , 0 )
//       US_DbUseArea( .T. , "DBFCDX" , PRI_COMPATIBILITY_DATABASE , "__HOTCOMPAT" )
//       REPLACE HR_UNIQUE with HB_MD5( HR_HASH + HB_MD5( US_ExtractMemoKey( HR_DATA , "VERSION_COMPUTER" ) ) + HB_MD5( US_ExtractMemoKey( HR_DATA , "VERSION_USER" ) ) + HB_MD5( US_ExtractMemoKey( HR_DATA , "VERSION_DATETIME" ) ) ) ALL
//    else
//    endif
//    DbCloseArea( "__HOTCOMPAT" )
// else
//    US_Log( "Unable to open Hot Recovery Database for Checking Compatibility: " + PRI_COMPATIBILITY_DATABASE )
//    return .F.
// endif

Return .T.

#endif

/* eof */
