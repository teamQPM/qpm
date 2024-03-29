/*
 *    QPM - QAC based Project Manager
 *
 *    Copyright 2011-2021 Fernando Yurisich <qpm-users@lists.sourceforge.net>
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

memvar cPTopic
memvar cPNick
memvar cAuxTopic
memvar cAuxNick
memvar vFilesToCompile

#ifdef QPM_SHG

FUNCTION SHG_CreateDatabase( cFile )
   LOCAL auxName := US_FileTmp( US_FileNameOnlyPath( cFile ) + DEF_SLASH + "_AddDbf" )

   CREATE ( auxName )
   APPEND BLANK
   REPLACE Field_name WITH "SHG_NEW",;
           Field_type WITH "C",;
           Field_len WITH 1,;
           Field_dec WITH 0
   APPEND BLANK
   REPLACE Field_name WITH "SHG_DELETE",;
           Field_type WITH "C",;
           Field_len WITH 1,;
           Field_dec WITH 0
   APPEND BLANK
   REPLACE Field_name WITH "SHG_TYPE",;
           Field_type WITH "C",;
           Field_len WITH 1,;
           Field_dec WITH 0
   APPEND BLANK
   REPLACE Field_name WITH "SHG_TYPET",;
           Field_type WITH "C",;
           Field_len WITH 1,;
           Field_dec WITH 0
   APPEND BLANK
   REPLACE Field_name WITH "SHG_IDENT",;
           Field_type WITH "N",;
           Field_len WITH 2,;
           Field_dec WITH 0
   APPEND BLANK
   REPLACE Field_name WITH "SHG_IDENTT",;
           Field_type WITH "N",;
           Field_len WITH 2,;
           Field_dec WITH 0
   APPEND BLANK
   REPLACE Field_name WITH "SHG_ORDER",;
           Field_type WITH "N",;
           Field_len WITH 5,;
           Field_dec WITH 0
   APPEND BLANK
   REPLACE Field_name WITH "SHG_ORDERT",;
           Field_type WITH "N",;
           Field_len WITH 5,;
           Field_dec WITH 0
   APPEND BLANK
   REPLACE Field_name WITH "SHG_TOPIC",;
           Field_type WITH "C",;
           Field_len WITH 255,;
           Field_dec WITH 0
   APPEND BLANK
   REPLACE Field_name WITH "SHG_TOPICT",;
           Field_type WITH "C",;
           Field_len WITH 255,;
           Field_dec WITH 0
   APPEND BLANK
   REPLACE Field_name WITH "SHG_NICK",;
           Field_type WITH "C",;
           Field_len WITH 255,;
           Field_dec WITH 0
   APPEND BLANK
   REPLACE Field_name WITH "SHG_NICKT",;
           Field_type WITH "C",;
           Field_len WITH 255,;
           Field_dec WITH 0
   APPEND BLANK
   REPLACE Field_name WITH "SHG_MEMO",;
           Field_type WITH "M",;
           Field_len WITH 10,;
           Field_dec WITH 0
   APPEND BLANK
   REPLACE Field_name WITH "SHG_MEMOT",;
           Field_type WITH "M",;
           Field_len WITH 10,;
           Field_dec WITH 0
   APPEND BLANK
   REPLACE Field_name WITH "SHG_KEYS",;
           Field_type WITH "M",;
           Field_len WITH 10,;
           Field_dec WITH 0
   APPEND BLANK
   REPLACE Field_name WITH "SHG_KEYST",;
           Field_type WITH "M",;
           Field_len WITH 10,;
           Field_dec WITH 0
   USE
   CREATE ( cFile ) FROM ( auxName )
   USE
   SHG_Database := cFile
   US_Use( .T. , , SHG_Database , "SHG" , DEF_DBF_EXCLUSIVE , DEF_DBF_WRITE )
   DbGoTop()
   SHG_IndexON( SHG_Database )
   DBCloseArea( "SHG" )
   SHG_AddRecord( "F" , 1 , "Global Footer" , "" , "This text will be included at the footer of all Help pages" + HB_OsNewLine() )
   SHG_AddRecord( "W" , 2 , "Welcome Page" , "" , "Text of Welcome Page" , "Welcome" + HB_OsNewline() + "Bienvenido" )
   SHG_AddRecord( "B" , 3 , "Example Book Number 1" , "" , "Text of Book 1" )
   SHG_AddRecord( "P" , 4 , "Example Page Number 1 of Book 1" , "" , "Text of Page 1 of Book 1" )
   SHG_AddRecord( "P" , 5 , "Example Page Number 2 of Book 1" , "" , "Text of Page 2 of Book 1" )
   SHG_AddRecord( "P" , 6 , "Example Page Number 3 of Book 1" , "" , "Text of Page 3 of Book 1" )
   SHG_AddRecord( "P" , 7 , "Example Page Number 4 of Book 1" , "" , "Text of Page 4 of Book 1" )
   SHG_AddRecord( "B" , 8 , "Example Book Number 2" , "" , "Text of Book 2" )
   SHG_AddRecord( "P" , 9 , "Example Page Number 1 of Book 2" , "" , "Text of Page 1 of Book 2" )
   ferase( auxName )
Return .T.

Function SHG_Close()
   if !( QPM_WAIT( "SHG_CheckSave()" , "Checking for save ..." ) )
      Return .F.
   endif
   if SHG_BaseOk
      if MyMsgYesNo( "Confirm Close Help Database ?" )
         QPM_Wait( 'DoMethod( "VentanaMain" , "GHlpFiles" , "DeleteAllItems" )' )
         if US_FileSize( US_FileNameOnlyPathAndName( SHG_Database ) + ".dbt" ) > SHG_DbSize
            QPM_Wait( 'SHG_PackDatabase()' )
         endif
         SHG_Database := ""
         SetProperty( "VentanaMain" , "THlpDataBase" , "Value" , "" )
         SHG_BaseOK := .F.
         SetProperty( "VentanaMain" , "RichEditHlp" , "value" , "" )
         oHlpRichEdit:lChanged := .F.
         SetProperty( "VentanaMain" , "RichEditHlp" , "readonly" , .T. )
      else
         Return .F.
      endif
   endif
Return .T.

Function SHG_PackDatabase()
   Local cTmpDb := US_FileNameOnlyPathAndName( SHG_Database ) + "_" + PUB_cSecu + ".dbf"
   if !file( cTmpDb )
      US_Use( .T. , , SHG_Database , "SHG" , DEF_DBF_EXCLUSIVE , DEF_DBF_WRITE )
      COPY TO ( cTmpDb )
      DBClosearea( "SHG" )
      if file( cTmpDb )
         ferase( SHG_Database )
         ferase( US_FileNameOnlyPathAndName( SHG_Database ) + ".dbt" )
      endif
      if !file( SHG_Database )
         US_Use( .T. , , cTmpDb , "SHG" , DEF_DBF_EXCLUSIVE , DEF_DBF_WRITE )
         COPY TO ( SHG_Database )
         DBClosearea( "SHG" )
      endif
      if file( SHG_Database )
         ferase( cTmpDb )
         ferase( US_FileNameOnlyPathAndName( cTmpDb ) + ".dbt" )
      endif
   endif
Return .T.

Function SHG_GetDatabase()
   Local vFiles, cFile
   if !( QPM_WAIT( "SHG_CheckSave()" , "Checking for save ..." ) )
      Return .F.
   endif
   /* Get file con multiselect en .F. trae problemas cuando se pone algo nuevo y se presiona enter en lugar de usar el boton */
   If ( len( vFiles := US_GetFile( { {'QPM Help Generator Database (*_SHG.DBF)','*_SHG.DBF'} } , "Select QPM Help Generator Database" , if( !empty( US_FileNameOnlyPath( GetProperty( "VentanaMain" , "THlpDataBase" , "Value" ) ) ) , US_FileNameOnlyPath( GetProperty( "VentanaMain" , "THlpDataBase" , "Value" ) ) , PUB_cProjectFolder ) , .T. , .T. ) ) > 0 )
      cFile := SHG_StrTran( vFiles[1] )
      if upper( right( US_FileNameOnlyName( cFile ) , 4 ) ) != "_SHG"
         cFile := US_FileNameOnlyPath( cFile ) + DEF_SLASH + US_FileNameOnlyName( cFile ) + "_SHG.dbf"
      endif
      if Upper( US_FileNameOnlyExt( cFile ) ) != "DBF"
         cFile := US_FileNameOnlyPathAndName( cFile ) + ".dbf"
      endif
      if !file( cFile )
         if MyMsgYesNo( "Help Database '"+cFile+"' not found.  Do you want to create an empty database ?" )
            SHG_CreateDatabase( cFile )
            SetProperty( "VentanaMain" , "THlpDataBase" , "Value" , cFile )
         else
            Return .F.
         endif
      else
         if US_IsDbf( cFile ) = 21
            MyMsgStop( "Help database '" + cFile + "' if open by another process..." + HB_OsNewline() + "Free the database an retry" )
            Return .F.
         endif
         if US_IsDbf( cFile ) != 0
            MyMsgStop( "Invalid or corrupted Help database '" + cFile + "'" )
            Return .F.
         endif
         SHG_Database := cFile
         SetProperty( "VentanaMain" , "THlpDataBase" , "Value" , cFile )
      endif
   else
      Return .F.
   Endif
   QPM_WAIT( "SHG_LoadDatabase( SHG_Database )" , "Loading Database ..." )
Return .T.

Function SHG_AddRecord( cType , nSecu , cTopic , cNick , cMemo , cKeys )
   DEFAULT cKeys TO ""
// cMemo := "{\rtf1\ansi\ansicpg1252\deff0\deflang3082{\fonttbl{\f0\froman\fcharset0 Arial;}{\f1\fnil\fcharset0 MS Sans Serif;}}" + HB_OsNewline() + ;
//        "{\colortbl ;\red0\green0\blue0;}" + HB_OsNewline() + ;
//        "\viewkind4\uc1\pard\sb100\sa100\cf1\f0\fs20 " + cMemo + HB_OsNewline() + ;
//        "\par \pard\cf0\f1\fs17 " + HB_OsNewline() + ;
//        "\par }"
   cMemo := "{\rtf1\ansi\ansicpg1252\deff0\deflang3082{\fonttbl{\f0\froman\fcharset0 Arial;}{\f1\fnil\fcharset0 MS Sans Serif;}}" + HB_OsNewline() + ;
            "{\colortbl ;\red0\green0\blue0;}" + HB_OsNewline() + ;
            "\viewkind4\uc1\cf1\f0\fs20 " + cMemo + HB_OsNewline() + ;
            "\par }"
       //   "\par \cf0\f1\fs17 " + HB_OsNewline() + ;
   cMemo := US_RTF2RTF( cMemo )
   US_Use( .T. , , SHG_Database , "SHG" , DEF_DBF_EXCLUSIVE , DEF_DBF_WRITE )
   DBSetIndex( US_FileNameOnlyPathAndName( SHG_Database ) )
   APPEND BLANK
// REPLACE SHG_TYPET WITH cType , SHG_ORDER WITH nSecu , SHG_TOPICT WITH cTopic , SHG_MEMOT WITH cMemo , SHG_KEYST WITH cKeys
   REPLACE SHG_TYPE  WITH cType  , SHG_TYPET  WITH cType  , SHG_ORDER WITH nSecu
   REPLACE SHG_TOPIC WITH cTopic , SHG_TOPICT WITH cTopic , SHG_MEMO  WITH cMemo , SHG_MEMOT  WITH cMemo
   REPLACE SHG_NICK  WITH cNick  , SHG_NICKT  WITH cNick
   REPLACE SHG_KEYS  WITH cKeys  , SHG_KEYST  WITH cKeys
   DBCloseArea( "SHG" )
Return .T.

Function SHG_DeleteRecord( nRec )
   US_Use( .T. , , SHG_Database , "SHG" , DEF_DBF_EXCLUSIVE , DEF_DBF_WRITE )
   DBSetIndex( US_FileNameOnlyPathAndName( SHG_Database ) )
   DBGoTop()
   if !DbSeek( nRec )
      MyMsgInfo( "Error locating record number " + US_VarToStr( nRec ) + " in function SHG_DeleteRecord. Please, contact support." )
   else
      DELETE
   endif
   DBCloseArea( "SHG" )
   SHG_NewSecuence()
Return .T.

Function SHG_GetField( cField , nRow )
   Local cAux := "Record " + US_VarToStr( nRow ) + " not found.  Contact with QPM Support for Assistance"

   US_Use( .T. , , SHG_Database , "SHG" , DEF_DBF_EXCLUSIVE , DEF_DBF_WRITE )
   DBSetIndex( US_FileNameOnlyPathAndName( SHG_Database ) )
   DBGoTop()
   if !DbSeek( nRow )
      MyMsgInfo( "Error locating record number " + US_VarToStr( nRow ) + " in function SHG_GetField. Please, contact support." )
   else
      cAux := &( cField )
   endif
   DBCloseArea( "SHG" )
Return cAux

Function SHG_SetField( cField , nRow , xValue )
   Local bReto := .F.
   US_Use( .T. , , SHG_Database , "SHG" , DEF_DBF_EXCLUSIVE , DEF_DBF_WRITE )
   DBSetIndex( US_FileNameOnlyPathAndName( SHG_Database ) )
   DBGoTop()
   if !DbSeek( nRow )
      MyMsgInfo( "Error locating record number " + US_VarToStr( nRow ) + " in function SHG_SetField. Please, contact support." )
   else
      if &cField == xValue
      else
         REPLACE &cField WITH xValue
      endif
      bReto := .T.
   endif
   DBCloseArea( "SHG" )
Return bReto

Function SHG_CheckSave()
   Local nActual := GetProperty( "VentanaMain" , "GHlpFiles" , "Value" )
   Local nInx , vDiff := {} , rpt
   LostRichEdit( "HLP" , nActual )
   SetMGWaitTxt( "Checking changes in Hlp Topics..." )
   For nInx := 1 to GetProperty( "VentanaMain" , "GHlpFiles" , "ItemCount" )
      if GetProperty( "VentanaMain" , "GHlpFiles" , "Cell" , nInx , NCOLHLPEDIT ) == "D"
         aadd( vDiff , nInx )
      endif
   Next
   if len( vDiff ) == 0
      Return .T.
   endif
   if len( vDiff ) == 1
      if ( rpt := MyMsgYesNoCancel( "Help Topic '" + alltrim( GetProperty( "VentanaMain" , "GHlpFiles" , "Cell" , vDiff[1] , NCOLHLPTOPIC ) ) + "' not saved !!!" + HB_OsNewLine() + "Save it ???" ) ) == 1
         SHG_SetField( "SHG_TYPE"  , vDiff[1] , SHG_GetField( "SHG_TYPET"  , vDiff[1] ) )
    //   SHG_SetField( "SHG_ORDER" , vDiff[1] , SHG_GetField( "SHG_ORDERT" , vDiff[1] ) )
         SHG_SetField( "SHG_TOPIC" , vDiff[1] , SHG_GetField( "SHG_TOPICT" , vDiff[1] ) )
         SHG_SetField( "SHG_NICK"  , vDiff[1] , SHG_GetField( "SHG_NICKT"  , vDiff[1] ) )
         SHG_SetField( "SHG_MEMO"  , vDiff[1] , SHG_GetField( "SHG_MEMOT"  , vDiff[1] ) )
         SHG_SetField( "SHG_KEYS"  , vDiff[1] , SHG_GetField( "SHG_KEYST"  , vDiff[1] ) )
         SetProperty( "VentanaMain" , "GHlpFiles" , "Cell" , vDiff[1] , NCOLHLPEDIT , "E" )
      endif
 //   if rpt == 0
 //      if SHG_GetField( "SHG_ORDER" , vDiff[1] ) == 0
 //         SHG_DeleteRecord( vDiff[1] )
 //      endif
 //   endif
      if rpt == -1
         Return .F.
      endif
      Return .T.
   endif
   if ( rpt := MyMsgYesNoCancel( alltrim( str( len( vDiff ) ) ) + " Help's Topic's not saved !!!" + HB_OsNewLine() + HB_OsNewLine() + "Reply YES for save ALL Topic" + HB_OsNewLine() + "Reply NO for discard ALL changes of Topics" + HB_OsNewLine() + "Reply CANCEL for return to edit HLP Topics" ) ) == 1
      SetMGWaitTxt( "Saving Hlp Topics..." )
      SHG_SaveAll()
   else
   // if rpt == 0
   //    For nInx := 1 to GetProperty( "VentanaMain" , "GHlpFiles" , "ItemCount" )
   //       DO EVENTS
   //       if SHG_GetField( "SHG_ORDER" , nInx ) == 0
   //          SHG_DeleteRecord( nInx )
    //      endif
    //   Next
   // endif
      if rpt == -1
         Return .F.
      endif
   endif
Return .T.

Function SHG_SaveAll()
   Local nInx
   For nInx := 1 to GetProperty( "VentanaMain" , "GHlpFiles" , "ItemCount" )
      if GetProperty( "VentanaMain" , "GHlpFiles" , "Cell" , nInx , NCOLHLPEDIT ) == "D"
         SetMGWaitTxt( "Saving: " + alltrim( GetProperty( "VentanaMain" , "GHlpFiles" , "Cell" , nInx , NCOLHLPTOPIC ) ) + " ..." )
         SHG_SetField( "SHG_TYPE"  , nInx , SHG_GetField( "SHG_TYPET"  , nInx ) )
   //    SHG_SetField( "SHG_ORDER" , nInx , SHG_GetField( "SHG_ORDERT" , nInx ) )
         SHG_SetField( "SHG_TOPIC" , nInx , SHG_GetField( "SHG_TOPICT" , nInx ) )
         SHG_SetField( "SHG_NICK"  , nInx , SHG_GetField( "SHG_NICKT"  , nInx ) )
         SHG_SetField( "SHG_MEMO"  , nInx , SHG_GetField( "SHG_MEMOT"  , nInx ) )
         SHG_SetField( "SHG_KEYS"  , nInx , SHG_GetField( "SHG_KEYST"  , nInx ) )
         SetProperty( "VentanaMain" , "GHlpFiles" , "Cell" , nInx , NCOLHLPEDIT , "E" )
      endif
   Next
Return .T.

Function SHG_Generate( cBase , bGenHtml , PUB_cSecu , cWWW )
   Local Prefijo      // "Hlp"
   Local cOldDll
   Local Folder
   Local cDllWithCancel
   Local cName , cPrev := NIL , cTop := NIL , cNext := NIL
   Local nCont := 0 , i
   Local cDirOutCHM := PUB_cProjectFolder + DEF_SLASH + "_" + PUB_cSecu + "HlpTemp"
   Local nRegistros, cMemoHeader , cMemoFooter , cFooterHTML
   Local cBackColor := "#FFFCEA"
   Local wwwCdQ     := "https://teamqpm.github.io/"
   Local cWWWDescri := "Powered by QPM"
   Local cAux
   Local nCinx
   Local cClaves  := " "
   Local cDirOutHTML := PUB_cProjectFolder + DEF_SLASH + "HtmlHelp"
   Local vFiles := {}
   PRIVATE vFilesToCompile := {}
   if Empty( PUB_cProjectFolder ) .or. ! US_IsDirectory( PUB_cProjectFolder )
      MyMsgStop( DBLQT + "Project Folder" + DBLQT + " is not a valid folder:" + Hb_OsNewLine() + PUB_cProjectFolder + Hb_OsNewLine() + 'Look at tab ' + DBLQT + PagePRG + DBLQT )
      Return .F.
   endif
   if US_FileInUse( SHG_GetOutputName() )
      MyMsgInfo( "Output name '" + SHG_GetOutputName() + "' is in use." + HB_OsNewLine() + "Close the help process an retry." )
      Return .F.
   endif
   if !file( cBase )
      MyMsgStop( "Help database not found: " + cBase + HB_OsNewLine() + "Use open button to open or create help database." )
      return .F.
   endif

   // check
   if empty( cWWW ) .or. len( cWWW ) < 4
      cWWW := wwwCdQ
   endif

   Prefijo := US_FileNameOnlyName( SHG_GetOutputName() )
   US_Use( .T. , , cBase , "SHG" , DEF_DBF_EXCLUSIVE , DEF_DBF_WRITE )
   DbGoTo( 2 )
   cAux := field->SHG_TYPE
   DbGoTop()
   if field->SHG_TYPE != "F" .or. ;
      cAux != "W" .or. ;
      field->SHG_ORDER != 1 .or. ;
      field->SHG_TOPIC != "Global Foot"
      MyMsgStop( "Help Database is corrupted, records UNKNOWN" )
      DBCloseArea( "SHG" )
      Return .F.
   endif
   DBCloseArea( "SHG" )
   // end check
   if !( cWWW == wwwCdQ )
      cWWWDescri := cWWW
   endif
   if at( "://" , upper( cWWW ) ) == 0
      if at( "@" , upper( cWWW ) ) == 0
         cWWW := "http://" + cWWW
      else
         if at( "mailto:" , upper( cWWW ) ) == 0
            cWWW := "mailto:" + cWWW
         endif
      endif
   endif
   if upper( US_FileNameOnlyName( SHG_GetOutputName() ) ) == "QPM"
   // cBackColor := "#e4f3e2"       /* verde */
      cBackColor := "#FFFCEA"       /* amarillo */
   // cBackColor := "#ffeee6"       /*  {255,238,230} rosa */
   endif
   if !SHG_BaseOK
      if empty( SHG_Database )
         MyMsgInfo( "QPM Help Generator Database not selected. Use open button for open or create help database" )
      else
         MyMsgInfo( "Error opening QPM Help Generator Database: " + SHG_Database + HB_OsNewLine() + "Look at " + PageHlp )
      endif
      Return .F.
   endif
   if !SHG_CheckSave()
      Return .F.
   endif
   if bGenHtml
      if Empty( SHG_HtmlFolder )
         SHG_HtmlFolder := cDirOutHTML
      Endif
      If Empty( Folder := GetFolder( "Select Folder for HTML Output", SHG_HtmlFolder ) )
         MyMsgInfo( "Folder required for HTML output." )
         Return .F.
      Else
         SHG_HtmlFolder := Folder
      Endif
      if ! US_IsDirectory( SHG_HtmlFolder )
         if ! US_CreateFolder( SHG_HtmlFolder )
            US_Log( "Unable to create HTML folder: " + SHG_HtmlFolder )
            return .F.
         endif
      endif
      cDirOutHTML := SHG_HtmlFolder
   endif
   cDllWithCancel := alltrim( memoline( memoread( PUB_cQPM_Folder + DEF_SLASH + "itcc_dll.tmp" ) , 254 , 1 ) )
   cOldDll := SHG_PutDllItcc()
   if cOldDll == "*ERROR*"
      Return .F.
   endif
   QPM_MemoWrit( PUB_cQPM_Folder + DEF_SLASH + "itcc_dll.tmp" , cOldDll )
   if !empty( cDllWithCancel )
      cOldDll := cDllWithCancel
   endif
   if !( US_IsDirectory( cDirOutCHM ) )
      if !US_CreateFolder( cDirOutCHM )
         US_Log( "Unable to create folder for CHM output: " + cDirOutCHM )
         return .F.
      endif
   endif

   _SaveBitmap( LoadBitmap( "SHG_ARROWPREV" ), cDirOutCHM + DEF_SLASH + "SHG_ArrowPrev.bmp" )
   _SaveBitmap( LoadBitmap( "SHG_ARROWNEXT" ), cDirOutCHM + DEF_SLASH + "SHG_ArrowNext.bmp" )
   _SaveBitmap( LoadBitmap( "SHG_ARROWTOP" ), cDirOutCHM + DEF_SLASH + "SHG_ArrowTop.bmp" )
   _SaveBitmap( LoadBitmap( "SHG_ARROWBOTTOM" ), cDirOutCHM + DEF_SLASH + "SHG_ArrowBottom.bmp" )

   if bGenHtml
      US_FileCopy( cDirOutCHM + DEF_SLASH + "SHG_ArrowPrev.bmp" , cDirOutHTML + DEF_SLASH + "SHG_ArrowPrev.bmp" )
      US_FileCopy( cDirOutCHM + DEF_SLASH + "SHG_ArrowNext.bmp" , cDirOutHTML + DEF_SLASH + "SHG_ArrowNext.bmp" )
      US_FileCopy( cDirOutCHM + DEF_SLASH + "SHG_ArrowTop.bmp" , cDirOutHTML + DEF_SLASH + "SHG_ArrowTop.bmp" )
      US_FileCopy( cDirOutCHM + DEF_SLASH + "SHG_ArrowBottom.bmp" , cDirOutHTML + DEF_SLASH + "SHG_ArrowBottom.bmp" )

      /* Copy extra images for html help */
      _SaveBitmap( LoadBitmap( "SHG_WELCOME" ), cDirOutHTML + DEF_SLASH + "SHG_Welcome.bmp" )
      _SaveBitmap( LoadBitmap( "SHG_BOOK" ), cDirOutHTML + DEF_SLASH + "SHG_Book.bmp" )
      _SaveBitmap( LoadBitmap( "SHG_PAGE" ), cDirOutHTML + DEF_SLASH + "SHG_Page.bmp" )
   
      /* Copy dtree for html help */
      US_FileCopy( PUB_cQPM_Folder + DEF_SLASH + "US_dtree.css" , cDirOutHTML + DEF_SLASH + "SHG_dtree.css" )
      US_FileCopy( PUB_cQPM_Folder + DEF_SLASH + "US_dtree.js" , cDirOutHTML + DEF_SLASH + "SHG_dtree.js" )
      US_FileCopy( PUB_cQPM_Folder + DEF_SLASH + "US_dtree.im" , cDirOutHTML + DEF_SLASH + "SHG_dtree.zip" )

      /*    HB_UNZIPFILE( <cFile>, <bBlock>, <lWithPath>, <cPassWord>, <cPath>, <cFile> | <aFile>, <pFileProgress> ) ---> lCompress
       * $ARGUMENTS$
       *      <cFile>   Name of the zip file to extract
       *      <bBlock>  Code block to execute while extracting
       *      <lWithPath> Toggle to create directory if needed
       *      <cPassWord> Password to use to extract files
       *      <cPath>    Path to extract the files to - mandatory
       *      <cFile> | <aFiles> A File or Array of files to extract - mandatory
       *      <pFileProgress> Code block for File Progress
       */
      if !HB_UNZIPFILE(cDirOutHTML + DEF_SLASH + "SHG_dtree.zip", nil, .T., nil, cDirOutHTML + DEF_SLASH + "SHG_IMG" + DEF_SLASH, "*.*", nil )
         MyMsgInfo( "Error decompresing images for index tree of HTML Help (Java Mode)." )
      else
         ferase( cDirOutHTML + DEF_SLASH + "SHG_dtree.zip" )
      endif
   endif

   US_Use( .T. , , cBase , "HlpAlias" , DEF_DBF_EXCLUSIVE , DEF_DBF_WRITE )
   DBSetIndex( US_FileNameOnlyPathAndName( cBase ) )
   nRegistros := Reccount()
   DbSeek( 1 )
   SetMGWaitTxt( "Generating footer..." )
   QPM_MemoWrit( cDirOutCHM + DEF_SLASH + "Footer.rtf" , field->SHG_MEMO )
//   US_FileChar26Zap( cDirOutCHM + DEF_SLASH + "Footer.rtf" )
   SHG_RtfToHtml( cDirOutCHM + DEF_SLASH + "Footer.rtf" , cDirOutCHM + DEF_SLASH + "Footer.htm" , "Global Foot" )
   cFooterHTML := SHG_HTML_GetFooter( cDirOutCHM + DEF_SLASH + "Footer.htm" )
   DBSeek( 3 )
   if !empty( field->SHG_NICK )
      cTop := alltrim( field->SHG_NICK )
   else
      cTop := Prefijo + "_2.htm"
   endif
   DBSeek( 2 )
   Do while !eof()
      DO EVENTS
      nCont++
      if field->SHG_ORDER < 4
         cPrev := NIL
      else
         DBSKIP( -1 )
         if empty( field->SHG_NICK )
            cPrev := Prefijo + "_" + alltrim( str( nCont - 1 ) ) + ".htm"
         else
            cPrev := alltrim( field->SHG_NICK )
         endif
         DBSKIP( +1 )
      endif
      if field->SHG_ORDER == nRegistros
         cNext := NIL
      else
         DBSKIP( +1 )
         if empty( field->SHG_NICK )
            cNext := Prefijo + "_" + alltrim( str( nCont + 1 ) ) + ".htm"
         else
            cNext := alltrim( field->SHG_NICK )
         endif
         DBSKIP( -1 )
      endif
      if empty( field->SHG_NICK )
         cName := Prefijo + "_" + alltrim( str( nCont ) )
      else
         cName := US_FileNameOnlyName( field->SHG_NICK )
      endif
      if !empty( field->SHG_KEYS )
         QPM_MemoWrit( cDirOutCHM + DEF_SLASH + cName + ".Inx" , field->SHG_KEYS )
         if bGenHtml
            for nCinx := 1 to mlcount( field->SHG_KEYS , 254 )
               if at( upper( alltrim( memoline( field->SHG_KEYS , 254 , nCinx ) ) + ", " ) , upper( cClaves ) ) == 0
                  cClaves := cClaves + alltrim( memoline( field->SHG_KEYS , 254 , nCinx ) ) + ", "
               endif
            next
         endif
      endif
      aadd( vFiles , { alltrim( field->SHG_TYPE ) , strtran( strtran( alltrim( field->SHG_TOPIC ) , "<" , "&lt;" ) , ">" , "&gt;" ) , cName + ".htm" , cDirOutCHM + DEF_SLASH + cName + ".Inx" , cPrev , cTop , cNext } )
      QPM_MemoWrit( cDirOutCHM + DEF_SLASH + cName + ".rtf" , field->SHG_Memo )
//      US_FileChar26Zap( cDirOutCHM + DEF_SLASH + cName + ".rtf" )
   // SetMGWaitTxt( "Generating: " + cName + ".htm ..." )
      SetMGWaitTxt( "Generating: " + alltrim( field->SHG_TOPIC ) + " ..." )
      SHG_RtfToHtml( cDirOutCHM + DEF_SLASH + cName + ".rtf" , cDirOutCHM + DEF_SLASH + cName + ".htm" , alltrim( field->SHG_TOPIC ) )
      if file( cDirOutCHM + DEF_SLASH + cName + ".htm" )
         SHG_HTML_ArmoHeader( @cMemoHeader , vFiles , len( vFiles ) , cBackColor , alltrim( field->SHG_TOPIC ) )
         SHG_HTML_AddHeader( cDirOutCHM + DEF_SLASH + cName + ".htm" , cMemoHeader )
         SHG_HTML_ArmoFooter( @cMemoFooter , vFiles , len( vFiles ) , cFooterHTML , cWWW , cWWWDescri )
         SHG_HTML_AddFooter( cDirOutCHM + DEF_SLASH + cName + ".htm" , cMemoFooter )
         if bGenHtml
            US_FileCopy( cDirOutCHM + DEF_SLASH + cName + ".htm" , cDirOutHTML + DEF_SLASH + cName + ".htm" )
         endif
      endif
//  ferase( cDirOutCHM + DEF_SLASH + cName + ".rtf" )
      DBSkip()
   enddo
   DBCloseArea( "HlpAlias" )
   SetMGWaitTxt( "Compiling to make " + SHG_GetOutputName() + "..." )
   SHG_HHP_Gener( Prefijo , cDirOutCHM , vFiles, vFilesToCompile )
   SHG_HHC_Gener( Prefijo , cDirOutCHM , vFiles )
   SHG_HHK_Gener( Prefijo , cDirOutCHM , vFiles )
   DO EVENTS
   if bGenHtml
      SHG_CopyImageToHtmlFolder( vFilesToCompile , cDirOutHTML )
      SHG_GenHtmlIndexHTML( US_FileNameOnlyName( SHG_GetOutputName() ) + '.htm' , cDirOutHTML , vFiles , cClaves , cWWW )
      SHG_GenHtmlIndexJava( US_FileNameOnlyName( SHG_GetOutputName() ) + '.htm' , cDirOutHTML , vFiles , cClaves , cWWW )
   endif
   DO EVENTS
   SHG_CompileToCHM( US_ShortName( cDirOutCHM + DEF_SLASH + Prefijo + ".hhp" ) , US_ShortName( cDirOutCHM ) )
   for i := 1 to len( vFiles )
      DO EVENTS
 // ferase( cDirOutCHM + DEF_SLASH + vFiles[i][3] )
 // ferase( vFiles[i][4] )
   next
// ferase( cDirOutCHM + DEF_SLASH + Prefijo + ".hhp" )
// ferase( cDirOutCHM + DEF_SLASH + Prefijo + ".hhc" )
// ferase( cDirOutCHM + DEF_SLASH + Prefijo + ".hhk" )
   if !empty( cOldDll )
      SHG_RestoreDllItcc( cOldDll )
   else
      //ferase( PUB_cQPM_Folder + DEF_SLASH + "hha.dll" )
   endif
   ferase( PUB_cQPM_Folder + DEF_SLASH + "itcc_dll.tmp" )
   US_DirRemoveLoop( cDirOutCHM , 5 )
Return .T.

Function SHG_CopyImageToHtmlFolder( vImage , cDirOut )
   Local i
   for i:=1 to len( vImage )
      DO EVENTS
      if file( vImage[i] )
         if US_FileCopy( vImage[i] , cDirOut + DEF_SLASH + US_FileNameOnlyNameAndExt( vImage[i] ) ) != US_FileSize( vImage[i] )
            MyMsgInfo( "Error copying file '" + vImage[i] + "' to folder: " + cDirOut )
         else
            if US_FileNameOnlyNameAndExt( US_FileNameCase( vImage[i] ) ) !=  US_FileNameOnlyNameAndExt( US_FileNameCase( cDirOut + DEF_SLASH + US_FileNameOnlyNameAndExt( vImage[i] ) ) )
               frename( cDirOut + DEF_SLASH + US_FileNameOnlyNameAndExt( vImage[i] ) , cDirOut + DEF_SLASH + US_FileNameOnlyNameAndExt( vImage[i] ) + "." + PUB_cSecu )
               frename( cDirOut + DEF_SLASH + US_FileNameOnlyNameAndExt( vImage[i] ) + "." + PUB_cSecu , cDirOut + DEF_SLASH + US_FileNameOnlyNameAndExt( US_FileNameCase( vImage[i] ) ) )
            endif
         endif
      endif
   next
Return .T.

FUNCTION SHG_GetOutputName()
   LOCAL cOutputName, cOutputFolder
   cOutputName := US_FileNameOnlyName( SHG_Database )
   cOutputName := SubStr( cOutputName , 1 , Len( cOutputName ) - 4 )
   cOutputFolder := US_FileNameOnlyPath( GetOutputModuleName() )
   IF Empty( cOutputFolder )
      cOutputFolder := PUB_cProjectFolder
   ENDIF
RETURN cOutputFolder + DEF_SLASH + cOutputName + '.chm'

Function SHG_HTML_ArmoHeader( cHeader , vVector , nIndx , cBackColor , cTitle )
   cHeader := '<html><head>                                            ' + HB_OsNewLine() + ;
              '<title>'+cTitle+'</title>       ' + HB_OsNewLine() + ;
              '</head>                                                 ' + HB_OsNewLine() + ;
              '<body bgcolor="'+cBackColor+'" >                        ' + HB_OsNewLine() + ;
              '<DIV></DIV>                                             ' + HB_OsNewLine() + ;
              '<table width="100%"  border="0"  cellspacing="0"  cellpadding="2"  bgcolor="#c0c0c0" >' + HB_OsNewLine() + ;
              '<tr>                                                    ' + HB_OsNewLine() + ;
              '  <td align="left" >                                    ' + HB_OsNewLine() + ;
              '    <div align="left" ><font face="Arial"  color="#010101"  size="4" ><span style="FONT-SIZE: 14pt"' + HB_OsNewLine() + ;
              '   >'+vVector[nIndx][2]+'</span></font></div>  ' + HB_OsNewLine() + ;
              '  </td>                                                 ' + HB_OsNewLine() + ;
              '  <td align="right" >                                   ' + HB_OsNewLine() + ;
              '    <font face="Arial"  size="2" >                      ' + HB_OsNewLine() + ;
                   if( empty( vVector[nIndx][5]) , '<img src="SHG_ArrowPrev.bmp" alt="Previous topic">&nbsp;' , '<A href="'+vVector[nIndx][5]+'"><img src="SHG_ArrowPrev.bmp" alt="Previous topic"></A>&nbsp;' + HB_OsNewLine() ) + ;
                   if( nIndx < 3 , '<img src="SHG_ArrowTop.bmp" alt="First topic">&nbsp;' , '<A href="'+vVector[nIndx][6]+'"><img src="SHG_ArrowTop.bmp" alt="First topic"></A>&nbsp;' + HB_OsNewLine() ) + ;
              ; // if( empty( vVector[nIndx][7]) , '<img src="SHG_ArrowBottom.bmp" alt="Last topic">&nbsp;' , '<A href="'+vVector[len(vVector)][6]+'"><img src="SHG_ArrowBottom.bmp" alt="Last topic"></A>&nbsp;' + HB_OsNewLine() ) + ;
                   if( empty( vVector[nIndx][7]) , '<img src="SHG_ArrowNext.bmp" alt="Next topic">' , '<A href="'+vVector[nIndx][7]+'"><img src="SHG_ArrowNext.bmp" alt="Next topic"></A>' + HB_OsNewLine() ) + ;
              '    </font>                                             ' + HB_OsNewLine() + ;
              '  </td>                                                 ' + HB_OsNewLine() + ;
              '</tr></table>                                           ' + HB_OsNewLine() + ;
              '<hr><br>                                                ' + HB_OsNewLine()
            //     if( empty( vVector[nIndx][5]) , '<A>Previous</A>&nbsp;' , '<A href="'+vVector[nIndx][5]+'">Previous</A>&nbsp;' + HB_OsNewLine() ) + ;
            //     if( nIndx < 3 , '<A>Top</A>&nbsp;' , '<A href="'+vVector[nIndx][6]+'">Top</A>&nbsp;' + HB_OsNewLine() ) + ;
            //     if( empty( vVector[nIndx][7]) , '<A>Next</A>' , '<A href="'+vVector[nIndx][7]+'">Next</A>' + HB_OsNewLine() ) + ;
Return .T.
        //    '   >'+strtran(strtran(vVector[nIndx][2],"<","&lt;"),">","&gt;")+'</span></font></div>  ' + HB_OsNewLine() + ;

Function SHG_HTML_GetFooter( cHTML )
   Local cMemoAux := MemoRead( cHTML )
// cMemoAux := substr( cMemoAux , at( "</head><body>" , cMemoAux ) + 13 , rat( "</body></html>" , cMemoAux ) - 1 )
Return cMemoAux

Function SHG_HTML_ArmoFooter( cFooter , vVector , nIndx , cFooterHTML , cWWW , cWWWDescri )
   cFooter := '<p><hr><p>                                                            ' + HB_OsNewLine() + ;
              cFooterHTML                                                              + HB_OsNewLine() + ;
              '<table width="100%"  border="0"  cellspacing="0"  cellpadding="2"  bgcolor="#c0c0c0" > ' + HB_OsNewLine() + ;
              '  <TBODY>                                                             ' + HB_OsNewLine() + ;
              '  <tr>                                                                ' + HB_OsNewLine() + ;
              '    <td align="left" ><font face="Arial"  color="#010101"  size="4" ><span style="FONT-SIZE: 14pt"' + HB_OsNewLine() + ;
              '     >                                                                ' + HB_OsNewLine() + ;
              '      <P>                                                             ' + HB_OsNewLine() + ;
              '      <P align=left><FONT size=2><A href="'+cWWW+'" target=blank>'+cWWWDescri+'</A>&nbsp;&nbsp;</FONT>               ' + HB_OsNewLine() + ;
              '      </P></span></font></td>                                         ' + HB_OsNewLine() + ;
              '    <td align="right" >                                               ' + HB_OsNewLine() + ;
              '      <font face="Arial"  size="2" >                                  ' + HB_OsNewLine() + ;
                   if( empty( vVector[nIndx][5]) , '<img src="SHG_ArrowPrev.bmp" alt="Previous topic">&nbsp;' , '<A href="'+vVector[nIndx][5]+'"><img src="SHG_ArrowPrev.bmp" alt="Previous topic"></A>&nbsp;' + HB_OsNewLine() ) + ;
                   if( nIndx < 3 , '<img src="SHG_ArrowTop.bmp" alt="First topic">&nbsp;' , '<A href="'+vVector[nIndx][6]+'"><img src="SHG_ArrowTop.bmp" alt="First topic"></A>&nbsp;' + HB_OsNewLine() ) + ;
              ; // if( empty( vVector[nIndx][7]) , '<img src="SHG_ArrowBottom.bmp" alt="Last topic">&nbsp;' , '<A href="'+vVector[len(vVector)][6]+'"><img src="SHG_ArrowBottom.bmp" alt="Last topic"></A>&nbsp;' + HB_OsNewLine() ) + ;
                   if( empty( vVector[nIndx][7]) , '<img src="SHG_ArrowNext.bmp" alt="Next topic">' , '<A href="'+vVector[nIndx][7]+'"><img src="SHG_ArrowNext.bmp" alt="Next topic"></A>' + HB_OsNewLine() ) + ;
              '      </font>                                                         ' + HB_OsNewLine() + ;
              '    </td></tr></TBODY></table><hr></body></html>                          '
          //       if( empty( vVector[nIndx][5]) , '<A>Previous</A>&nbsp;' , '<A href="'+vVector[nIndx][5]+'">Previous</A>&nbsp;' + HB_OsNewLine() ) + ;
          //       if( nIndx < 3 , '<A>Top</A>&nbsp;' , '<A href="'+vVector[nIndx][6]+'">Top</A>&nbsp;' + HB_OsNewLine() ) + ;
          //       if( empty( vVector[nIndx][7]) , '<A>Next</A>' , '<A href="'+vVector[nIndx][7]+'">Next</A>' + HB_OsNewLine() ) + ;
Return .T.

Function SHG_HTML_AddHeader( cFile , cHeader )
   Local MemoAux := MemoRead( cFile )
// MemoAux := cHeader + substr( MemoAux , at( "</head><body>" , MemoAux ) + 13 )
   MemoAux := cHeader + MemoAux
   QPM_MemoWrit( cFile , MemoAux )
//   US_FileChar26Zap( cFile )
Return .T.

Function SHG_HTML_AddFooter( cFile , cFooter )
   Local MemoAux := MemoRead( cFile )
// MemoAux := substr( MemoAux , 1 , rat( "</body></html>" , MemoAux ) - 1 ) + cFooter
   MemoAux := MemoAux + cFooter
   QPM_MemoWrit( cFile , MemoAux )
//   US_FileChar26Zap( cFile )
Return .T.

Function SHG_RtfToHtml( cIn , cOut , cTopic )
   Local cOldFolder     := GetCurrentFolder()
   Local ExeConvert     := US_ShortName( PUB_cQPM_Folder ) + DEF_SLASH + "US_R2H.exe"
   DirChange( PUB_cProjectFolder )
   SHG_Commands( cIn , "PRE" )
   DirChange( PUB_cQPM_Folder ) && este cambio de directorio es por la tool rtftohtml que no funciona bien sino se hace esto
   QPM_Execute( ExeConvert , US_FileNameOnlyPathAndName( cIn ) , DEF_QPM_EXEC_WAIT , DEF_QPM_EXEC_HIDE )
   DirChange( PUB_cProjectFolder )
// DirChange( cOldFolder )
   SHG_ImageGenerateList( cOut , cTopic )
   SHG_LinkGenerateList( cOut , cTopic )
   SHG_Commands( cOut , "POS" )
   DirChange( cOldFolder )
Return .T.

Function SHG_HHP_Gener( Prefijo , cDirOutCHM , vFiles, vFilesToCompile )
   Local cMemo , i
   cMemo := '[OPTIONS]                               ' + HB_OsNewLine() + ;
            'Auto Index=No                           ' + HB_OsNewLine() + ;
            'Binary TOC=No                           ' + HB_OsNewLine() + ;
            'Compatibility=1.1 or later              ' + HB_OsNewLine() + ;
            'Compiled file=' + SHG_GetOutputName() + ' ' + HB_OsNewLine() + ;
            'Contents file=' + Prefijo + '.hhc       ' + HB_OsNewLine() + ;
            'Default topic=' + vFiles[1][3]            + HB_OsNewLine() + ;
            'Display compile progress=No             ' + HB_OsNewLine() + ;
            'Full-text search=Yes                    ' + HB_OsNewLine() + ;
            'Index file=' + Prefijo + '.hhk          ' + HB_OsNewLine() + ;
            'Language=0x409                          ' + HB_OsNewLine() + ;
            'Title=' + Upper(Prefijo) + '            ' + HB_OsNewLine()
   cMemo := cMemo + '[ALIAS]                                                             ' + HB_OsNewLine()
   for i := 1 to len( vFiles )
      DO EVENTS
      cMemo := cMemo + 'IDH_MASTER_TEST'+alltrim( str( i ) )+'='+ vFiles[i][3] +'        ' + HB_OsNewLine()
   next i
   cMemo := cMemo + '[MAP]                                                             ' + HB_OsNewLine()
   for i := 1 to len( vFiles )
      DO EVENTS
      cMemo := cMemo + '#define IDH_MASTER_TEST'+alltrim( str( i ) )+' '+ alltrim( str( i ) ) +'        ' + HB_OsNewLine()
   next i
   cMemo := cMemo + '[FILES]                                                           ' + HB_OsNewLine()
   for i := 1 to len( vFilesToCompile )
      DO EVENTS
      cMemo := cMemo + vFilesToCompile[i] +'   ' + HB_OsNewLine()
   next i
   QPM_MemoWrit( cDirOutCHM + DEF_SLASH + Prefijo + ".hhp" , cMemo )
Return .T.

Function SHG_HHC_Gener( Prefijo , cDirOutCHM , vFiles )
   Local cMemo , i , nLevel := 0
   cMemo := '<!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML//EN">                                 ' + HB_OsNewLine() + ;
            '<HTML>                                                                         ' + HB_OsNewLine() + ;
            '<HEAD>                                                                         ' + HB_OsNewLine() + ;
            '<meta name="GENERATOR" content="QPM&reg; Simple Help Generator">               ' + HB_OsNewLine() + ;
            '<!-- Sitemap 1.0 -->                                                           ' + HB_OsNewLine() + ;
            '</HEAD><BODY>                                                                  ' + HB_OsNewLine() + ;
            '<OBJECT type="text/site properties">                                           ' + HB_OsNewLine() + ;
            '        <param name="ImageType" value="Folder">                                ' + HB_OsNewLine() + ;
            '</OBJECT>                                                                      ' + HB_OsNewLine() + ;
            '<UL>                                                                           ' + HB_OsNewLine()
   for i := 1 to len( vFiles )
      DO EVENTS
      if i > 1 .and. ( ( vFiles[i-1][1] == "B" .or. vFiles[i-1][1] == "W" ) .and. vFiles[i][1] == "P" )
         cMemo := cMemo + ' <UL> ' + HB_OsNewLine()
         nLevel++
      endif
      if i > 1 .and. ( vFiles[i-1][1] == "P" .and. ( vFiles[i][1] == "B" .or. vFiles[i-1][1] == "W" ) )
         if nLevel > 0
            cMemo := cMemo + ' </UL> ' + HB_OsNewLine()
            nLevel--
         endif
      endif
      cMemo := cMemo + ' <LI> <OBJECT type="text/sitemap">                                  ' + HB_OsNewLine() + ;
                       '         <param name="Name" value="'+ vFiles[i][2] +'">             ' + HB_OsNewLine() + ;
                       '         <param name="Local" value="'+ vFiles[i][3] +'">            ' + HB_OsNewLine() + ;
                       '         <param name="ImageNumber" value="'+ if( vFiles[i][1] == 'B' , '1' , if( vFiles[i][1] == 'W' , '27' , '11' ) ) +'">            ' + HB_OsNewLine() + ;
                       '      </OBJECT>                                                     ' + HB_OsNewLine()
   next i
   cMemo := cMemo + replicate( "</UL>" , nLevel ) + HB_OsNewLine()
   cMemo := cMemo + '</UL>                                                                  ' + HB_OsNewLine() + ;
            '</BODY></HTML>'
   QPM_MemoWrit( cDirOutCHM + DEF_SLASH + Prefijo + ".hhc" , cMemo )
Return .T.

Function SHG_HHK_Gener( Prefijo , cDirOutCHM , vFiles )
   Local cMemo , i , MemoKeys , k
   cMemo := '<!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML//EN">          ' + HB_OsNewLine() + ;
            '  <HTML>                                                ' + HB_OsNewLine() + ;
            '  <HEAD>                                                ' + HB_OsNewLine() + ;
            '  <meta name="GENERATOR" content="QPM&reg; Simple Help Generator">' + HB_OsNewLine() + ;
            '  <!-- Sitemap 1.0 -->                                  ' + HB_OsNewLine() + ;
            '  </HEAD><BODY>                                         ' + HB_OsNewLine() + ;
            '  <UL>                                                  ' + HB_OsNewLine()
   for i := 1 to len( vFiles )
      DO EVENTS
      if file( vFiles[i][4] )
         MemoKeys := memoread( vFiles[i][4] )
         for k := 1 to MLCount( MemoKeys , 254 )
            DO EVENTS
            cMemo := cMemo + ' <LI> <OBJECT type="text/sitemap">                                  ' + HB_OsNewLine() + ;
                             '         <param name="Name" value="'+ alltrim( memoline( MemoKeys , 254 , k ) ) +'">             ' + HB_OsNewLine() + ;
                             '         <param name="Local" value="'+ vFiles[i][3] +'">            ' + HB_OsNewLine() + ;
                             '      </OBJECT>                                                     ' + HB_OsNewLine()
         Next k
      endif
   next i
   cMemo := cMemo + '</UL>                                           ' + HB_OsNewLine() + ;
                    '</BODY></HTML>                                  ' + HB_OsNewLine()
   QPM_MemoWrit( cDirOutCHM + DEF_SLASH + Prefijo + ".hhk" , cMemo )
Return .T.

// Se requieren dos DLL's : HHA.dll (puede estar en PUB_cQPM_Folder o en Window\System )
//                          itcc.dll (debe estar en Window\System y debe registrarse: regsvr32 c:\windows\system\itcc.dll  )
//           si no se registra esta dll da el siguiente error: "HHC6003: The file itircl.dll has not been registered correctly"
Function SHG_CompileToCHM( Proyecto , cDirOutCHM )
   Local cOutPut := cDirOutCHM + DEF_SLASH + '_' + PUB_cSecu + 'OutHHC' + US_DateTimeCen() + '.tmp'
   Local MemoResu
   ferase( SHG_GetOutputName() )
   QPM_MemoWrit( US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + '_'+PUB_cSecu+'RunShell.bat' , US_ShortName(PUB_cQPM_Folder) + DEF_SLASH + 'US_hhc.exe ' + Proyecto + ' > ' + cOutput )
   QPM_Execute( US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + '_'+PUB_cSecu+'RunShell.bat' , , DEF_QPM_EXEC_WAIT , DEF_QPM_EXEC_HIDE )
   ferase( US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + '_'+PUB_cSecu+'RunShell.bat' )
   MemoResu := memoread( cOutPut )
   if at( "ERROR:" , upper( MemoResu ) ) == 0 .and. ;
      at( "WARNING:" , upper( MemoResu ) ) == 0
      MyMsgOk( NIL, 'Build Finished' + HB_OsNewLine() + 'OK', 'I', .T. )
      SHG_DisplayHelp( SHG_GetOutputName() )
   else
      MyMsgStop( strtran( MemoResu , chr(13) + HB_OsNewLine() + chr(13) + HB_OsNewLine() , HB_OsNewLine() ) )
   endif
   ferase( cOutPut )
Return .T.

Function SHG_DisplayHelp( cName )
   Local cOldHelp := GetActiveHelpFile()
   if !file( cName )
      MyMsgInfo( "Help file '" + cName + "' not found !!!" + HB_OsNewLine() + "Run 'Generate Help' process and try again." )
      Return .F.
   endif
   if US_FileInUse( cName )
      MyMsgInfo( "Help file '" + cName + "' is in use." + HB_OsNewLine() + "Close the help process an re-open with TEST button." )
      Return .F.
   endif
   SET HELPFILE TO cName
   if GetProperty( "VentanaMain" , "GHlpFiles" , "value" ) == 0
      SetProperty( "VentanaMain" , "GHlpFiles" , "value" , 1 )
   endif
   if GetProperty( "VentanaMain" , "GHlpFiles" , "value" ) == 1
      DISPLAY HELP MAIN
   else
      if empty( GetProperty( "VentanaMain" , "GHlpFiles" , "Cell" , GetProperty( "VentanaMain" , "GHlpFiles" , "value" ) , NCOLHLPNICK ) )
         SHG_DisplayHelpTopic( US_FileNameOnlyName( SHG_GetOutputName() ) + "_" + alltrim( str( GetProperty( "VentanaMain" , "GHlpFiles" , "value" ) - 1 ) ) )
      else
         SHG_DisplayHelpTopic( US_FileNameOnlyName( GetProperty( "VentanaMain" , "GHlpFiles" , "Cell" , GetProperty( "VentanaMain" , "GHlpFiles" , "value" ) , NCOLHLPNICK ) ) )
      endif
   endif
   if !empty( cOldHelp )
      SET HELPFILE TO cOldHelp
   endif
Return .T.

Function SHG_DisplayHelpTopic( xTopic , nMet )
    LOCAL LOC_cParam := ""
    If empty( GetActiveHelpFile() )
        Return .F.
    endif
    _HMG_nTopic := xTopic
    _HMG_nMet   := nMet
    if valtype(nMet) == 'U'
        nMet := 0
    endif
    If Right( Alltrim( Upper( GetActiveHelpFile() ) ) , 4 ) == '.CHM'
        If ValType( xTopic ) == 'N'
            LOC_cParam := "-mapid " + LTrim( Str( xTopic )) + " " + GetActiveHelpFile()
        ElseIf ValType( xTopic ) == 'C'
            LOC_cParam := '"' + GetActiveHelpFile() + "::/" + AllTrim( xTopic ) + '.htm"'
        ElseIf ValType( xTopic ) == 'U'
            LOC_cParam := '"' + GetActiveHelpFile() + '"'
        EndIf
        QPM_Execute( "HH.exe" , LOC_cParam )
    Else
        If ValType( xTopic ) == 'U'
            xTopic := 0
        EndIf
        WinHelp( _HMG_MainHandle , GetActiveHelpFile() , 1 , nMet , xTopic )
    EndIf
Return .T.

Function SHG_Toggle()
   if GetProperty( "VentanaMain" , "GHlpFiles" , "ItemCount" ) < 1
      Return .F.
   endif
   if GetProperty( "VentanaMain" , "GHlpFiles" , "Value" ) < 1
      MyMsgInfo( "Topic not selected." )
      Return .F.
   endif
   if GetProperty( "VentanaMain" , "GHlpFiles" , "Value" ) == 1
      MyMsgInfo( "Global footer can't be toggled!" )
      Return .F.
   endif
   if GetProperty( "VentanaMain" , "GHlpFiles" , "Value" ) == 2
      MyMsgInfo( "Welcome page can't be toggled!" )
      Return .F.
   endif
   if GridImage( "VentanaMain" , "GHlpFiles" , GetProperty( "VentanaMain" , "GHlpFiles" , "Value" ) , NCOLHLPSTATUS , "?" , PUB_nGridImgHlpBook )
      GridImage( "VentanaMain" , "GHlpFiles" , GetProperty( "VentanaMain" , "GHlpFiles" , "Value" ) , NCOLHLPSTATUS , "-" , PUB_nGridImgHlpBook )
      GridImage( "VentanaMain" , "GHlpFiles" , GetProperty( "VentanaMain" , "GHlpFiles" , "Value" ) , NCOLHLPSTATUS , "+" , PUB_nGridImgHlpPage )
      SHG_SetField( "SHG_TYPET" , GetProperty( "VentanaMain" , "GHlpFiles" , "Value" ) , "P" )
   else
      GridImage( "VentanaMain" , "GHlpFiles" , GetProperty( "VentanaMain" , "GHlpFiles" , "Value" ) , NCOLHLPSTATUS , "-" , PUB_nGridImgHlpPage )
      GridImage( "VentanaMain" , "GHlpFiles" , GetProperty( "VentanaMain" , "GHlpFiles" , "Value" ) , NCOLHLPSTATUS , "+" , PUB_nGridImgHlpBook )
      SHG_SetField( "SHG_TYPET" , GetProperty( "VentanaMain" , "GHlpFiles" , "Value" ) , "B" )
   endif
// if GetProperty( "VentanaMain" , "GHlpFiles" , "Cell" , GetProperty( "VentanaMain" , "GHlpFiles" , "Value" ) , NCOLHLPSTATUS ) == 1
//    SetProperty( "VentanaMain" , "GHlpFiles" , "Cell" , GetProperty( "VentanaMain" , "GHlpFiles" , "Value" ) , NCOLHLPSTATUS , 2 )
//    SHG_SetField( "SHG_TYPET" , GetProperty( "VentanaMain" , "GHlpFiles" , "Value" ) , "P" )
// else
//    SetProperty( "VentanaMain" , "GHlpFiles" , "Cell" , GetProperty( "VentanaMain" , "GHlpFiles" , "Value" ) , NCOLHLPSTATUS , 1 )
//    SHG_SetField( "SHG_TYPET" , GetProperty( "VentanaMain" , "GHlpFiles" , "Value" ) , "B" )
// endif
Return .T.

Function SHG_NewSecuence()
   Local nInx := 0
   US_Use( .T. , , SHG_Database , "SHG" , DEF_DBF_EXCLUSIVE , DEF_DBF_WRITE )
   DBSetIndex( US_FileNameOnlyPathAndName( SHG_Database ) )
   DBGoTop()
   do while !eof()
      nInx++
      REPLACE SHG_ORDER WITH nInx
      DBSkip()
   enddo
   DBCloseArea( "SHG" )
   DO EVENTS
//   US_Use( .T. , , SHG_Database , "SHG" , DEF_DBF_EXCLUSIVE , DEF_DBF_WRITE )
//   DBGoTop()
//   do while !eof()
//      DO EVENTS
//      REPLACE SHG_ORDER WITH SHG_ORDERT
//      DBSkip()
//   enddo
//   DBGoTop()
//   SHG_IndexON( SHG_Database )
//   DBCloseArea( "SHG" )
Return .T.

Function SHG_LoadDatabase( cDataBase )
   Local cAux, vStructure
   
   SetMGWaitTxt( "Loading Help Database ..." )
   if US_IsDBF( cDataBase ) != 0
      MyMsgInfo( "Error open QPM Help Generator Database: " + cDataBase + HB_OsNewLine() + "Look at " + PageHlp )
      SHG_BaseOK := .F.
   else
      if Upper( US_FileNameOnlyExt( cDatabase ) ) != "DBF"
         MyMsgInfo( "Error open QPM Help Generator Database: " + cDataBase + HB_OsNewLine() + "Bad extension." )
         SHG_BaseOK := .F.
      endif
      if upper( right( US_FileNameOnlyName( cDatabase ) , 4 ) ) != "_SHG"
         MyMsgInfo( "Error open QPM Help Generator Database: " + cDataBase + HB_OsNewLine() + "Bad Name, not _SHG suffix into database name." )
         SHG_BaseOK := .F.
      endif
      if file( US_FileNameOnlyPathAndName( cDatabase ) + ".dbt" )
         SetMGWaitTxt( "Converting SHG Database to DBFCDX Driver..." )
         if !US_DBConvert( cDatabase , US_FileNameOnlyPathAndName( cDatabase ) + "_" + PUB_cSecu + ".dbf" , "DBFNTX" , "DBFCDX" )
            US_Log( "Error converting SHG database to DBFCDX Driver" )
         else
            ferase( cDatabase )
            ferase( US_FileNameOnlyPathAndName( cDatabase ) + ".dbt" )
            ferase( US_FileNameOnlyPathAndName( cDatabase ) + ".ntx" )
            if frename( US_FileNameOnlyPathAndName( cDatabase ) + "_" + PUB_cSecu + ".dbf" , cDatabase ) < 0
               US_Log( "Error renaming SHG Database '"+ US_FileNameOnlyPathAndName( cDatabase ) + "_" + PUB_cSecu + ".dbf" + "' in Migration process, ferror: " + US_VarToStr( fError() ) )
            else
               if frename( US_FileNameOnlyPathAndName( cDatabase ) + "_" + PUB_cSecu + ".fpt" , US_FileNameOnlyPathAndName( cDatabase ) + ".fpt" ) < 0
                  US_Log( "Error renaming SHG Database '" + US_FileNameOnlyPathAndName( cDatabase ) + "_" + PUB_cSecu + ".fpt" + "' in Migration process, ferror: " + US_VarToStr( fError() ) )
           //  else
           //     SHG_IndexON( cDatabase )
               endif
            endif
         endif
      endif
      
      SetMGWaitTxt( "Packing Help Database ..." )
      US_Use( .T. , , cDataBase , "SHG" , DEF_DBF_EXCLUSIVE , DEF_DBF_WRITE )
      vStructure := DBStruct()
      if ascan( vStructure , {|aval| aval[1] == "SHG_NICK" } ) == 0
         DBCloseArea( "SHG" )
         US_DB_CMP( US_FileNameOnlyPathAndName( cDataBase ) , "ADD" , "SHG_NICK" , "C" , 255 , 0 )
         US_DB_CMP( US_FileNameOnlyPathAndName( cDataBase ) , "ADD" , "SHG_NICKT" , "C" , 255 , 0 )
         US_Use( .T. , , cDataBase , "SHG" , DEF_DBF_EXCLUSIVE , DEF_DBF_WRITE )
      endif
      PACK
      ferase( US_FileNameOnlyPathAndName( cDataBase ) + ".bak" )

      DO EVENTS

      SetMGWaitTxt( "Loading Topics..." )
      DbGoTop()
      do while ! eof()
         REPLACE SHG_TYPET  WITH field->SHG_TYPE
         REPLACE SHG_TOPICT WITH field->SHG_TOPIC
         REPLACE SHG_NICKT  WITH field->SHG_NICK
         REPLACE SHG_MEMOT  WITH field->SHG_MEMO
         REPLACE SHG_KEYST  WITH field->SHG_KEYS
         DBSkip()
      enddo
      DbGoTop()

      DO EVENTS

      SetMGWaitTxt( "Reindex Help Database ..." )
      SHG_IndexON( cDatabase )
      DBCloseArea( "SHG" )

      DO EVENTS

      SetMGWaitTxt( "New Secuence Database ..." )
      SHG_NewSecuence()

      US_Use( .T. , , cDataBase , "SHG" , DEF_DBF_EXCLUSIVE , DEF_DBF_WRITE )
      DBSetIndex( US_FileNameOnlyPathAndName( cDataBase ) )
      DbGoTo( 2 )
      cAux := field->SHG_TYPE
      DbGoTop()
      if field->SHG_TYPE != "F" .or. ;
         cAux     != "W" .or. ;
         field->SHG_ORDER != 1 .or. ;
         field->SHG_TOPIC != "Global Foot"
         MyMsgStop( "Help Database is corrupted, records UNKNOWN" )
         DBCloseArea( "SHG" )
         Return .F.
      endif
      DoMethod( "VentanaMain" , "GHlpFiles" , "DeleteAllItems" )
      bHlpMoving := .T.
      DoMethod( "VentanaMain" , "GHlpFiles" , "DisableUpdate" )
      do while !eof()
         SetMGWaitTxt( "Adding Topic " + alltrim( field->SHG_TOPIC ) + " to Help Grid ..." )
         DoMethod( "VentanaMain" , "GHlpFiles" , "AddItem" , { 0 , alltrim( field->SHG_TOPIC ) , alltrim( field->SHG_NICK ) , "0" , "E" } )
         GridImage( "VentanaMain" , "GHlpFiles" , GetProperty( "VentanaMain" , "GHlpFiles" , "ItemCount" ) , NCOLHLPSTATUS , "+" , if( field->SHG_TYPE == "B" , PUB_nGridImgHlpBook , if( field->SHG_TYPE == "F" , PUB_nGridImgHlpGlobalFoot , if( field->SHG_TYPE == "W" , PUB_nGridImgHlpWelcome , PUB_nGridImgHlpPage ) ) ) )
         DbSkip()
      enddo
      DoMethod( "VentanaMain" , "GHlpFiles" , "EnableUpdate" )
      DBCloseArea( "SHG" )

      DO EVENTS

      SetProperty( "VentanaMain" , "GHlpFiles" , "Value" , 1 )
      SetMGWaitTxt( "Display Help Topic ..." )
      RichEditDisplay( "HLP" )
      bHlpMoving := .F.
      SHG_BaseOK := .T.
      SHG_DbSize := US_FileSize( US_FileNameOnlyPathAndName( cDatabase ) + ".dbt" )
      DoMethod( "VentanaMain" , "GHlpFiles" , "ColumnsAutoFitH" )
   endif
Return .T.

Function SHG_IndexON( cDatabase )
   Empty( cDatabase )
   INDEX ON field->SHG_ORDER TAG "SHG_ORDER1"
Return .T.

Function SHG_PutDllItcc()
   Local cDllItccPath := alltrim( US_GetReg(HKEY_CLASSES_ROOT , "CLSID\{4662DAA2-D393-11D0-9A56-00C04FB68BF7}\InprocServer32" , "" ) )
   if cDllItccPath == "*ERROR*"
      Return cDllItccPath
   endif
   if !file( PUB_cQPM_Folder + DEF_SLASH + "hha.dll" )
      COPY FILE ( PUB_cQPM_Folder + DEF_SLASH + "US_hha.dll" ) TO ( PUB_cQPM_Folder + DEF_SLASH + "hha.dll" )
   endif
   if ( upper( cDllItccPath ) == upper( PUB_cQPM_Folder + DEF_SLASH + "US_itcc.dll" ) )
      Return ""
   endif
   if !empty( cDllItccPath ) .and. !( upper( cDllItccPath ) == upper( PUB_cQPM_Folder + DEF_SLASH + "US_itcc.dll" ) )
      QPM_Execute( "regsvr32" , "/s /u " + cDllItccPath , DEF_QPM_EXEC_WAIT , DEF_QPM_EXEC_MINIMIZE )
      QPM_Execute( "regsvr32" , "/s " + PUB_cQPM_Folder + DEF_SLASH + "US_itcc.dll" , DEF_QPM_EXEC_WAIT , DEF_QPM_EXEC_MINIMIZE )
      Return cDllItccPath
   endif
   if empty( cDllItccPath )
      QPM_Execute( "regsvr32" , "/s " + PUB_cQPM_Folder + DEF_SLASH + "US_itcc.dll" , DEF_QPM_EXEC_WAIT , DEF_QPM_EXEC_MINIMIZE )
   endif
Return ""

Function SHG_RestoreDllItcc( cDllName )
   //ferase( PUB_cQPM_Folder + DEF_SLASH + "hha.dll" )
   QPM_Execute( "regsvr32" , "/s /u " + PUB_cQPM_Folder + DEF_SLASH + "US_itcc.dll" , DEF_QPM_EXEC_WAIT , DEF_QPM_EXEC_MINIMIZE )
   QPM_Execute( "regsvr32" , "/s " + cDllName , DEF_QPM_EXEC_WAIT , DEF_QPM_EXEC_MINIMIZE )
Return .T.

Function SHG_AddHlpKey()
   Local cAux, cOldMemo
   Local cSel := oHlpRichEdit:GetSelText()
   if SHG_BaseOK
      if empty( cSel )
         cAux := InputBox( "New Key:" , "Keys for Help" , "" )
      else
         cAux := alltrim( substr( strtran( strtran( cSel , HB_OsNewLine() , "" ) , chr(13) , "" ) , 1 , 100 ) )
      endif
      if !empty( cAux )
         DoMethod( "VentanaMain" , "GHlpKeys" , "AddItem" , { cAux } )
         DoMethod( "VentanaMain" , "GHlpKeys" , "ColumnsAutoFitH" )
         cOldMemo := SHG_GetField( "SHG_KEYST" , GetProperty( "VentanaMain" , "GHlpFiles" , "Value" ) )
         SHG_SetField( "SHG_KEYST" , GetProperty( "VentanaMain" , "GHlpFiles" , "Value" ) , cOldMemo + if( !empty( cOldMemo ) , HB_OsNewLine() , "" ) + cAux )
      endif
   else
      MyMsgInfo( "Help Database not selected.  Use open button for open or create help database." )
   endif
Return .T.

Function SHG_AddHlpHTML( accion )
   Local cClip , cTagAux , nCaretTxt := GetProperty( "VentanaMain" , "RichEditHlp" , "caretpos" )
   Local vDesdeLen
   Local cMemoTxt := US_GetRichEditValue( "VentanaMain" , "RichEditHlp" , "TXT" )
//   Local cMemoRtf := US_GetRichEditValue( "VentanaMain" , "RichEditHlp" , "RTF" )
//   Local cMemoRtfAux := ""
   DEFAULT accion TO "*NULA*"
// cClip := RetriveTextFromClipboard()
   cClip := US_GetRtfClipboard()
   do case
      case upper( accion ) == "MENOR"
         CopyToClipboard( "&lt;" )
         SHG_Send_Paste()
      case upper( accion ) == "MAYOR"
         CopyToClipboard( "&gt;" )
         SHG_Send_Paste()
      case upper( accion ) == "AMPERSAND"
         CopyToClipboard( "&Amp;" )
         SHG_Send_Paste()
      case upper( accion ) == "SPACE"
         CopyToClipboard( "&nbsp;" )
         SHG_Send_Paste()
      case upper( accion ) == "IMAGE"
         cMemoTxt := strtran( cMemoTxt , HB_OsNewLine() , chr( 10 ) )
         cTagAux := SHG_ImageAssistant( cMemoTxt , nCaretTxt )
         if !empty( cTagAux )
            vDesdeLen := SHG_ImageGetPos( cMemoTxt , nCaretTxt )
            if vDesdeLen[1][2] > 0
               SETSELRANGE( GetControlHandle( "RichEditHlp" , "VentanaMain" ) , vDesdeLen[1][1] - 1 , vDesdeLen[1][1] + vDesdeLen[1][2] - 1 )
            endif
            if cTagAux == "*DELETE*"
               ClearRTF( GetControlHandle( "RichEditHlp" , "VentanaMain" ) )
               SetProperty( "VentanaMain" , "RichEditHlp" , "caretpos" , vDesdeLen[1][1] - 1 )
            else
               CopyRtfToClipboard( "{\rtf1\ansi\ansicpg1252\deff0\deftab720{\fonttbl{\f0\fswiss\fprq2 Arial;}}{\colortbl\red0\green0\blue0;\red0\green255\blue0;}\deflang3082\horzdoc{\*\fchars }{\*\lchars }\pard\plain\f0\fs20\cf0\highlight1\b " + cTagAux + "\plain\lang11274\highlight}" )
               SHG_Send_Paste()
               if vDesdeLen[1][2] > 0
                  SetProperty( "VentanaMain" , "RichEditHlp" , "caretpos" , nCaretTxt + 1 )
               else
                  SetProperty( "VentanaMain" , "RichEditHlp" , "caretpos" , nCaretTxt )
               endif
            endif
         endif
      case upper( accion ) == "xxxxx"
         cMemoTxt := strtran( cMemoTxt , HB_OsNewLine() , chr( 10 ) )
         cTagAux := SHG_LinkAssistant( cMemoTxt , nCaretTxt )
         if ! empty( cTagAux )
            vDesdeLen := SHG_LinkGetPos( cMemoTxt , nCaretTxt )
      //    if len( vDesdeLen ) == 0
      //       aadd( vdesdeLen , { { nCaretTxt , 0 } } )
      //    endif
     //     nDesdeRtf := US_Rtf2MemoPos( cMemoRtf , vDesdeLen[1][1] )
     //     nHastaRtf := US_Rtf2MemoPos( cMemoRtf , vDesdeLen[1][1] + vDesdeLen[1][2] )
     //     cMemoRtfAux := substr( cMemoRtf , 1 , nDesdeRtf - 1 ) + cTagAux + substr( cMemoRtf , nHastaRtf )
     //     SetProperty( "VentanaMain" , "RichEditHlp" , "Value" , cMemoRtfAux )
     //     oHlpRichEdit:lChanged := .F.
     //     SetProperty( "VentanaMain" , "RichEditHlp" , "caretpos" , nCaretTxt )
        //  vDesdeLen[1][1] := vDesdeLen[1][1] - Occurs( HB_OsNewLine() , substr( cMemoTxt , 1 , vDesdeLen[1][1] ) )
            if vDesdeLen[1][2] > 0
               SETSELRANGE( GetControlHandle( "RichEditHlp" , "VentanaMain" ) , vDesdeLen[1][1] - 1 , vDesdeLen[1][1] + vDesdeLen[1][2] - 1 )
            endif
            if cTagAux == "*DELETE*"
               ClearRTF( GetControlHandle( "RichEditHlp" , "VentanaMain" ) )
               SetProperty( "VentanaMain" , "RichEditHlp" , "caretpos" , vDesdeLen[1][1] - 1 )
            else
               CopyRtfToClipboard( "{\rtf1\ansi\ansicpg1252\deff0\deftab720{\fonttbl{\f0\fswiss\fprq2 Arial;}}{\colortbl\red0\green0\blue0;\red0\green255\blue0;}\deflang3082\horzdoc{\*\fchars }{\*\lchars }\pard\plain\f0\fs20\cf0\highlight1\b " + cTagAux + "\plain\lang11274\highlight}" )
            // CopyRtfToClipboard( "{\rtf1\ansi\ansicpg1252\deff0\deftab720{\fonttbl{\f0\fswiss MS Sans Serif;}{\f1\froman\fcharset2 Symbol;}{\f2\froman Arial;}{\f3\fswiss MS Sans Serif;}}{\colortbl\red0\green0\blue0;\red255\green0\blue0;}\deflang3082\horzdoc{\*\fchars }{\*\lchars }\pard\plain\f2\fs20\cf1\b\i\ul " + cTagAux + "\plain\lang11274\f3\fs17\par }" )
            // CopyToClipboard( "\plain\f2\fs20\cf0\b\i\ul " + cTagAux + "\plain\f2\fs20\cf0 " )
               SHG_Send_Paste()
               if vDesdeLen[1][2] > 0
                  SetProperty( "VentanaMain" , "RichEditHlp" , "caretpos" , nCaretTxt + 1 )
               else
                  SetProperty( "VentanaMain" , "RichEditHlp" , "caretpos" , nCaretTxt )
               endif
            endif
         endif
      case upper( accion ) == "LINKTOPIC"
         CopyToClipboard( '<A href="NickNameTopic.htm">Jump to NicNameTopic</A>' )
         SHG_Send_Paste()
      case upper( accion ) == "ANCORA"
         CopyToClipboard( '<A name="xxxxxxxx">' )
         SHG_Send_Paste()
      case upper( accion ) == "LINK"
         CopyToClipboard( '<A href="https://teamqpm.github.io/" target=blank>QPM Home Page</A>' )
         SHG_Send_Paste()
      case upper( accion ) == "EMAIL"
         CopyToClipboard( '<A href="mailto:qpm-users@lists.sourceforge.net">Mail to QPM User Support Group</A>' )
         SHG_Send_Paste()
   otherwise
      MyMsgInfo( "Invalid accion in function SHG_AddHlpHTML: " + US_VarToStr( accion ) )
   endcase
   CopyRtfToClipboard( cClip )
Return .T.

Function SHG_LimpioRtf( cRtf )
   if at( "\sb100\sa100" , cRtf ) > 0
      cRtf := strtran( cRtf , "\sb100\sa100" , "" )
      Return .T.
   endif
Return .F.

Function SHG_Move_Item()
   Local nCurrent, nNew, cCurItem, cAuxItem, i

   nCurrent := GetProperty( "VentanaMain", "GHlpFiles", "value" )
   if nCurrent < 1
      Return .F.
   elseif nCurrent == 1
      MyMsgInfo( "Global footer can't be moved!" )
      Return .F.
   elseif nCurrent == 2
      MyMsgInfo( "Welcome page can't be moved!" )
      Return .F.
   endif

   nNew := Val( InputBox( "New Location:", "Move Item " + Ltrim( Str( nCurrent ) ) + " To", "" ) )
   if nNew < 1
      Return .F.
   elseif nNew == 1
      MyMsgInfo( "Global footer can't be moved!" )
      Return .F.
   elseif nNew == 2
      MyMsgInfo( "Welcome page can't be moved!" )
      Return .F.
   elseif nNew == nCurrent
      MyMsgInfo( "Nothing to do, origin and destination are the same!" )
      Return .F.
   endif
   nNew := Min( nNew, GetProperty( "VentanaMain", "GHlpFiles", "ItemCount" ) )

   bHlpMoving := .T.
   if nNew > nCurrent
      For i := nCurrent + 1 To nNew
         cCurItem := GetProperty( "VentanaMain" , "GHlpFiles" , "item" , i - 1 )
         cAuxItem := GetProperty( "VentanaMain" , "GHlpFiles" , "item" , i )
         SHG_SetField( "SHG_ORDER", i - 1, 0 )
         SHG_SetField( "SHG_ORDER", i , i - 1 )
         SHG_SetField( "SHG_ORDER", 0 , i )
         SetProperty( "VentanaMain" , "GHlpFiles" , "item" , i , cCurItem )
         SetProperty( "VentanaMain" , "GHlpFiles" , "item" , i - 1 , cAuxItem )
      Next i
   else
      For i := nCurrent - 1 To nNew Step -1
         cCurItem := GetProperty( "VentanaMain" , "GHlpFiles" , "item" , i + 1 )
         cAuxItem := GetProperty( "VentanaMain" , "GHlpFiles" , "item" , i )
         SHG_SetField( "SHG_ORDER" , i + 1 , 0 )
         SHG_SetField( "SHG_ORDER" , i , i + 1 )
         SHG_SetField( "SHG_ORDER" , 0 , i )
         SetProperty( "VentanaMain" , "GHlpFiles" , "item" , i , cCurItem )
         SetProperty( "VentanaMain" , "GHlpFiles" , "item" , i + 1 , cAuxItem )
      Next i
   endif
   SetProperty( "VentanaMain" , "GHlpFiles" , "value" , nNew )
   DoMethod( "VentanaMain" , "GHlpFiles" , "setfocus" )
   bHlpMoving := .F.
Return .F.

Function SHG_Send_Copy()
   RELEASE KEY CONTROL+C OF VentanaMain
   if GetProperty( "VentanaMain" , "TabFiles" , "Value" ) == nPageHlp .and. ;
      oHlpRichEdit:US_IsFocused()
      oHlpRichEdit:US_EditRtfCopy()

      SetProperty( oHlpRichEdit:US_WinEdit , oHlpRichEdit:cRichControlName + "ClipBoard" , "value" , "" )
      DoMethod( oHlpRichEdit:US_WinEdit , oHlpRichEdit:cRichControlName + "ClipBoard" , "SetFocus" )
      US_Send_Paste()
      DO EVENTS
      DoMethod( oHlpRichEdit:US_WinEdit , oHlpRichEdit:cRichControlName, "SetFocus" )
   else
      US_Send_Copy()
      DO EVENTS
   endif
   IF PUB_bHotKeys
      ON KEY CONTROL+C OF VentanaMain ACTION SHG_Send_Copy()
   ENDIF
Return .T.

Function SHG_Send_Cut()
   RELEASE KEY CONTROL+X OF VentanaMain
   if GetProperty( "VentanaMain" , "TabFiles" , "Value" ) == nPageHlp .and. ;
      oHlpRichEdit:US_IsFocused()
      oHlpRichEdit:US_EditRtfCut()

      SetProperty( oHlpRichEdit:US_WinEdit , oHlpRichEdit:cRichControlName + "ClipBoard" , "value" , "" )
      DoMethod( oHlpRichEdit:US_WinEdit , oHlpRichEdit:cRichControlName + "ClipBoard" , "SetFocus" )
      US_Send_Paste()
      DO EVENTS
      DoMethod( oHlpRichEdit:US_WinEdit , oHlpRichEdit:cRichControlName, "SetFocus" )
   else
      US_Send_Cut()
      DO EVENTS
   endif
   IF PUB_bHotKeys
      ON KEY CONTROL+X OF VentanaMain ACTION SHG_Send_Cut()
   ENDIF
Return .T.

Function SHG_Send_Paste()
   RELEASE KEY CONTROL+V OF VentanaMain
   if GetProperty( "VentanaMain" , "TabFiles" , "Value" ) == nPageHlp .and. ;
      oHlpRichEdit:US_IsFocused()
      oHlpRichEdit:US_EditRtfPaste()
   else
      US_Send_Paste()
      DO EVENTS
   endif
   IF PUB_bHotKeys
      ON KEY CONTROL+V OF VentanaMain ACTION SHG_Send_Paste()
   ENDIF
Return .T.

Function SHG_Post_Paste()
*   Local cAuxMemo , nCaret
*   cAuxMemo := US_GetRichEditValue( "VentanaMain" , "RichEditHlp" , "RTF" )
*   if SHG_LimpioRtf( @cAuxMemo )
*      nCaret := GetProperty( "VentanaMain" , "RichEditHlp" , "caretpos" )
*      SetProperty( "VentanaMain" , "RichEditHlp" , "value" , cAuxMemo )
*      oHlpRichEdit:lChanged := .F.
*      SetProperty( "VentanaMain" , "RichEditHlp" , "caretpos" , nCaret )
*   endif
Return .T.

Function SHG_GetDatabaseName( model )
   Local Temp_SHG_Secu := ""
   do while ( file( US_FileNameOnlyPathAndName( model )+Temp_SHG_Secu+"_SHG.dbf" ) .or. ;
              file( US_FileNameOnlyPathAndName( model )+Temp_SHG_Secu+"_SHG.dbt" ) .or. ;
              file( US_FileNameOnlyPathAndName( model )+Temp_SHG_Secu+"_SHG.ntx" ) )
      Temp_SHG_Secu := Temp_SHG_Secu + alltrim( str( int( seconds() ) ) )
   enddo
Return model + Temp_SHG_Secu

Function SHG_InputTopic( cTopic , cNick )
   Local bReto := .F.
   Private cPTopic := cTopic , cPNick := cNick
   Private cAuxTopic , cAuxNick

   DEFINE WINDOW PanInputTopic ;
          AT 0 , 0 ;
          WIDTH 540 ;
          HEIGHT 170 ;
          TITLE "Topic Description" ;
          MODAL ;
          NOSYSMENU ;
          ON INTERACTIVECLOSE US_NOP()

      @ 13 , 40 LABEL LabelTopic ;
         VALUE 'Topic:' ;
         WIDTH 70 ;
         FONT 'arial' SIZE 10 BOLD ;
         FONTCOLOR DEF_COLORBLUE

      DEFINE TEXTBOX TextTopic
         ROW             13
         COL             132
         WIDTH           330
         VALUE           cTopic
      END TEXTBOX

      @ 53 , 40 LABEL LabelNick ;
         VALUE 'NickName:' ;
         WIDTH 70 ;
         FONT 'arial' SIZE 10 BOLD ;
         FONTCOLOR DEF_COLORBLUE

      DEFINE TEXTBOX TextNick
         ROW             53
         COL             132
         WIDTH           330
         VALUE           US_FileNameOnlyName( cNick )
      END TEXTBOX

      @ 53 , 465 LABEL LabelNickHtm ;
         VALUE '.htm' ;
         WIDTH 40 ;
         FONT 'arial' SIZE 10 BOLD ;
         FONTCOLOR DEF_COLORBLUE

      DEFINE BUTTON PanInputTopicOK
             ROW             93
             COL             85
             WIDTH           80
             HEIGHT          25
             CAPTION         'OK'
             TOOLTIP         'Confirm selection'
             ONCLICK         if( bReto := SHG_InputTopicOK() , DoMethod( "PanInputTopic" , "Release" ) , US_Nop() )
             DEFAULT         .T.
      END BUTTON

      DEFINE BUTTON PanInputTopicCANCEL
             ROW             93
             COL             355
             WIDTH           80
             HEIGHT          25
             CAPTION         'Cancel'
             TOOLTIP         'Cancel selection'
             ONCLICK         ( bReto := .F. , DoMethod( "PanInputTopic" , "Release" ) )
      END BUTTON
      
      ON KEY ESCAPE OF PanInputTopic ACTION ( bReto := .F. , DoMethod( "PanInputTopic" , "Release" ) )

   END WINDOW

   Center Window PanInputTopic
   Activate Window PanInputTopic

   if bReto
      if cTopic == cPTopic .and. cNick == cPNick
         bReto := .f.
      else
         cTopic := cPTopic
         cNick := cPNick
      endif
   endif
   
Return bReto

Function SHG_InputTopicOK()
   Local i
   cAuxTopic := PanInputTopic.TextTopic.Value
   cAuxNick  := PanInputTopic.TextNick.Value
   if !empty( cAuxNick ) .and. !FILEVALID( cAuxNick , 255 , 50 )
      MyMsgInfo( "NickName is not a valid file name of Windows." + HB_OsNewLine() + ;
               'Remember: only numbers (0-9), letters (a-z or A-Z) and not use the followed simbols: \ / : * ? " < > |')
      Return .F.
   else
      if !empty( cAuxNick )
         for i := 1 to GetProperty( "VentanaMain" , "GHlpFiles" , "Itemcount" )
            if i != GetProperty( "VentanaMain" , "GHlpFiles" , "Value" )
               if upper( cAuxNick + ".htm" ) == upper( GetProperty( "VentanaMain" , "GHlpFiles" , "cell" , i , NCOLHLPNICK ) )
                  MyMsgInfo( "Nick Name already assigned to topic: " + GetProperty( "VentanaMain" , "GHlpFiles" , "cell" , i , NCOLHLPTOPIC ) )
                  return .F.
               endif
            endif
         next
      endif
      if !( cPTopic == cAuxTopic )
         cPTopic := cAuxTopic
      endif
      if !( US_FileNameOnlyName( cPNick ) == cAuxNick )
         if !empty( cAuxNick )
            cPNick := cAuxNick + ".htm"
            cPNick := US_FileNameOnlyNameAndExt( cPNick )
         else
            cPNick := ""
         endif
      endif
   endif
Return .T.

// mycString     Estring en donde esta la clave
// mycKey        Literal con la clave a procesar (limpia, es decir, si es ALT= hay que poner ALT solo
// mycVar        Es la variable pasada por referencia en donde se depositará el contenido de la clave
// myvNextKeys   Es un vector pasada por referencia o valor en donde estan las posibles claves siguientes
Function SHG_Parser( mycType , mycString , mycKey , mycVar , myvNextKeys )
   Local cComilla, cAuxString, nEncontroSignoIgual, j, h
   // mycType == 1    claves de tipo SRC="xxxx xxxxx "   donde puede estar separado el signo =
   //                 y en donde puede no estar las comillas o apostrofo , proxima clave es del mismo estilo y
   //                 el separador es un espacio
   // mycType == 2    claves de tipo SRC=123   donde puede estar separado el signo =
   //                 y el contenido es un numero
   do case
      case mycType == 1
         mycVar := alltrim( substr( mycString , len( mycKey ) + 1 ) )
         mycVar := alltrim( substr( mycVar , 2 ) )
         if substr( mycVar , 1 , 1 ) == "'" .or. substr( mycVar , 1 , 1 ) == '"'
            cComilla := substr( mycVar , 1 , 1 )
            mycVar := substr( mycVar , 2 )
            mycVar := substr( mycVar , 1 , at( cComilla , mycVar ) - 1 )
         else
            cComilla := ""
            cAuxString := mycVar
    //      for i:=1 to len( myvNextKeys )
               j := 1
               nEncontroSignoIgual := 0
               do while j <= len( cAuxString )
                  for h := 1 to len( myvNextKeys )
                     if at( " "+upper(myvNextKeys[h])+"=" , substr( upper( cAuxString ) , j ) ) == 1
                        mycVar := substr( cAuxString , 1 , j - 1 )
                        exit
                     endif
                  next
                  for h := 1 to len( myvNextKeys )
                     if at( " "+upper(myvNextKeys[h]) , substr( upper( cAuxString ) , j ) ) == 1
                        nEncontroSignoIgual := j
                        j := j + len( myvNextKeys[h] ) + 1
                        loop
                     endif
                  next
                  do case
      //             case at( " "+myvNextKeys[i]+"=" , substr( upper( cAuxString ) , j ) ) == 1
      //                mycVar := substr( cAuxString , 1 , j - 1 )
      //                exit
      //             case at( " "+myvNextKeys[i] , substr( upper( cAuxString ) , j ) ) == 1
      //                nEncontroSignoIgual := j
      //                j := j + len( myvNextKeys[i] ) + 1
      //                loop
                     case substr( cAuxString , j , 1 ) == "=" .and. nEncontroSignoIgual > 0
                        mycVar := substr( cAuxString , 1 , nEncontroSignoIgual - 1 )
                        exit
                     case substr( cAuxString , j , 1 ) == " "
                     otherwise
                        nEncontroSignoIgual := 0
                  endcase
                  j++
               enddo
    //      next
            mycVar := Alltrim( mycVar )
         endif
         mycString := substr( mycString , len( mycKey ) + 1 )
         mycString := alltrim( strtran( mycString , "=" , " " , 1 , 1 ) )
         mycString := alltrim( US_StrTran( mycString , mycVar , " " , 1 , 1 ) )
         if !empty( cComilla )
            mycString := alltrim( strtran( mycString , cComilla , "" , 1 , 2 ) )
         endif
      case mycType == 2
         mycString := alltrim( substr( mycString , len( mycKey ) + 1 ) )
         mycString := alltrim( substr( mycString , 2 ) )
         mycVar := US_Word( mycString , 1 )
         mycString := alltrim( US_StrTran( mycString , mycVar , " " , 1 , 1 ) )
      otherwise
         MyMsgInfo( "Invalid type in function " + procname() )
   endcase
Return mycString

Function SHG_CancelChangesTopic()
   Local nRecord , cAuxMemo
   if SHG_BaseOK
      if GetProperty( "VentanaMain" , "GHlpFiles" , "Value" ) < 1
         MyMsgInfo( "Topic not selected." )
         Return .F.
      else
         nRecord  := GetProperty( "VentanaMain" , "GHlpFiles" , "Value" )
         cAuxMemo := US_GetRichEditValue( "VentanaMain" , "RichEditHlp" , "RTF" )
         if !( SHG_GetField( "SHG_TYPE"  , nRecord ) == SHG_GetField( "SHG_TYPET"  , nRecord ) ) .or. ;
            !( SHG_GetField( "SHG_TOPIC" , nRecord ) == SHG_GetField( "SHG_TOPICT" , nRecord ) ) .or. ;
            !( SHG_GetField( "SHG_NICK"  , nRecord ) == SHG_GetField( "SHG_NICKT"  , nRecord ) ) .or. ;
            !( cAuxMemo == SHG_GetField( "SHG_MEMO" , nRecord ) ) .or. ;
            !( SHG_GetField( "SHG_KEYS"  , nRecord ) == SHG_GetField( "SHG_KEYST"  , nRecord ) )
            if ! MyMsgYesNo( "Cancel changes of topic '" + GetProperty( "VentanaMain" , "GHlpFiles" , "Cell" , GetProperty( "VentanaMain" , "GHlpFiles" , "Value" ) , NCOLHLPTOPIC ) + "' ?" )
               Return .F.
            else
               SetMGWaitTxt( "Restoring..." )
               SHG_SetField( "SHG_TYPET"  , nRecord , SHG_GetField( "SHG_TYPE"  , nRecord ) )
               SHG_SetField( "SHG_TOPICT" , nRecord , SHG_GetField( "SHG_TOPIC" , nRecord ) )
               SHG_SetField( "SHG_NICKT"  , nRecord , SHG_GetField( "SHG_NICK"  , nRecord ) )
               SHG_SetField( "SHG_MEMOT"  , nRecord , SHG_GetField( "SHG_MEMO"  , nRecord ) )
               SHG_SetField( "SHG_KEYST"  , nRecord , SHG_GetField( "SHG_KEYS"  , nRecord ) )
               RichEditDisplay( 'HLP' , .T. , nRecord )
               SetProperty( "VentanaMain" , "GHlpFiles" , "Cell" , nRecord , NCOLHLPTOPIC , SHG_GetField( "SHG_TOPICT" , nRecord ) )
               SetProperty( "VentanaMain" , "GHlpFiles" , "Cell" , nRecord , NCOLHLPNICK , SHG_GetField( "SHG_NICKT" , nRecord ) )
               SetProperty( "VentanaMain" , "GHlpFiles" , "Cell" , nRecord , NCOLHLPEDIT , "E" )
            endif
         else
            MyMsgInfo( "Topic '" + GetProperty( "VentanaMain" , "GHlpFiles" , "Cell" , GetProperty( "VentanaMain" , "GHlpFiles" , "Value" ) , NCOLHLPTOPIC ) + "' not changed from last save !!!" )
         endif
      endif
   else
      MyMsgInfo( "Help Database not selected.  Use open button for open or create help database." )
   endif
Return .T.

Function SHG_GenHtmlIndexHTML( cIndexName , cDirSalida , vTopic , cClaves , cWWW )
   Local cLinea , i , cTopicos := ""
   cLinea := '<html>' + HB_OsNewLine() + ;
      '<head>' + HB_OsNewLine() + ;
      '<title>' + US_FileNameOnlyName( cIndexName ) + ' Help</title>' + HB_OsNewLine() + ;
      '</head>' + HB_OsNewLine() + ;
      '<body bgcolor="#e3e6db" link="blue" vlink="blue" alink="#389e6b" >' + HB_OsNewLine() + ;
      '<table border=2 cellpadding=0 cellspacing=0 width="100%">' + HB_OsNewLine() + ;
      '   <tr valign="center" bgcolor="#003366">' + HB_OsNewLine() + ;
      '      <td><div align=center><font face="COURIER NEW" size="2">&nbsp;</font></div>' + HB_OsNewLine() + ;
      '         <div align="center"><font face="COURIER NEW" size="5" color="#ffffff">' + US_FileNameOnlyName( cIndexName ) + '</FONT></DIV>' + HB_OsNewLine() + ;
      '         <div align=center><font face="COURIER NEW" size="2">&nbsp;</font></div>' + HB_OsNewLine() + ;
      '      </td>' + HB_OsNewLine() + ;
      '   </tr>' + HB_OsNewLine() + ;
      '</table>' + HB_OsNewLine() + ;
      '<br>' + HB_OsNewLine() + ;
      '<table border=1 cellpadding=0 cellspacing=0 width="100%">' + HB_OsNewLine() + ;
      '   <tr valign="center" bgcolor="white">' + HB_OsNewLine() + ;
      '      <td>' + HB_OsNewLine() + ;
      '         <div align="center"><font face="COURIER NEW" size="2" color="#ffffff"><A href="' + cWWW + '" target=blank>' + if( at( 'HTTP://' , upper( cWWW ) ) == 1 , substr( cWWW , 8 ) , cWWW ) + '</A></FONT></DIV>' + HB_OsNewLine() + ;
      '      </td>' + HB_OsNewLine() + ;
      '   </tr>' + HB_OsNewLine() + ;
      '</table>' + HB_OsNewLine() + ;
      '<br>' + HB_OsNewLine() + ;
      '<TABLE>'
   for i := 1 to len( vTopic )
      cTopicos := cTopicos + HB_OsNewLine() + '    <TR><TD>'
      do case
         case vTopic[i][1] == "W"
            cTopicos := cTopicos + HB_OsNewLine() + '   <IMG alt="Welcome Page" src="SHG_Welcome.bmp">'
            cTopicos := cTopicos + HB_OsNewLine() + '    </TD><TD>'
            cTopicos := cTopicos + HB_OsNewLine() + '   <font face="ARIAL" size="4"><A href="' + vTopic[i][3] + '" target=CONT><B>' + vTopic[i][2] + '</B></A></FONT><br>'
            cTopicos := cTopicos + HB_OsNewLine() + '    </TD></TR>'
         case vTopic[i][1] == "B"
            cTopicos := cTopicos + HB_OsNewLine() + '   <font face="COURIER NEW" size="2">&nbsp;&nbsp;&nbsp;&nbsp;</FONT><IMG alt="Book" src="SHG_Book.bmp">'
            cTopicos := cTopicos + HB_OsNewLine() + '    </TD><TD>'
            cTopicos := cTopicos + HB_OsNewLine() + '   <font face="ARIAL" size="3"><A href="' + vTopic[i][3] + '" target=CONT><B>' + vTopic[i][2] + '</B></A></FONT><br>'
            cTopicos := cTopicos + HB_OsNewLine() + '    </TD></TR>'
         otherwise
            cTopicos := cTopicos + HB_OsNewLine() + '   <font face="COURIER NEW" size="2">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</FONT><IMG alt="Page" src="SHG_Page.bmp">'
            cTopicos := cTopicos + HB_OsNewLine() + '    </TD><TD>'
            cTopicos := cTopicos + HB_OsNewLine() + '   <font face="ARIAL" size="2"><A href="' + vTopic[i][3] + '" target=CONT>' + vTopic[i][2] + '</A></FONT><br>'
            cTopicos := cTopicos + HB_OsNewLine() + '    </TD></TR>'
      endcase
   next
   cLinea := cLinea + HB_OsNewLine() + cTopicos + HB_OsNewLine() + ;
      '   </TABLE>' + HB_OsNewLine() + ;
      '   <font face="ARIAL" size="2">' + Replicate( "_" , 255 ) + '</FONT>' + HB_OsNewLine()
   cLinea := cLinea + '</body>' + HB_OsNewLine() + ;
      '</html>'
   QPM_MemoWrit( cDirSalida + DEF_SLASH + US_FileNameOnlyName( cIndexName ) + "_FrameLeft.htm" , cLinea )
//   US_FileChar26Zap( cDirSalida + DEF_SLASH + US_FileNameOnlyName( cIndexName ) + "_FrameLeft.htm" )
   /* */
   cLinea := '<html>' + HB_OsNewLine() + ;
      '<head><meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">' + HB_OsNewLine() + ;
      '   <meta name="keywords" ' + HB_OsNewLine() + ;
      '   content="' + cClaves + HB_OsNewLine() + ;
      '   ">' + HB_OsNewLine() + ;
      '   <title>' + US_FileNameOnlyName( cIndexName ) + '     ' + HB_OsNewLine() + ;
      '   </title>' + HB_OsNewLine() + ;
      '</head>' + HB_OsNewLine() + ;
      '<frameset cols="25%,*">' + HB_OsNewLine() + ;
      '   <frame name="Menu" scrolling="auto" src="' + US_FileNameOnlyName( cIndexName ) + '_FrameLeft.htm">' + HB_OsNewLine() + ;
      '      <frame name="CONT" src="' + vTopic[1][3] + '" scrolling="auto">' + HB_OsNewLine() + ;
      '      <noframes>' + HB_OsNewLine() + ;
      '      <body>' + HB_OsNewLine() + ;
      '         <table border="0" cellpadding="0" cellspacing="0" width="100%">' + HB_OsNewLine() + ;
      '         <tr>' + HB_OsNewLine() + ;
      '            <td valign="top">' + HB_OsNewLine() + ;
      "            <p>This page uses frames, but your browser doesn't support them.</p>" + HB_OsNewLine() + ;
      '            <p>Esta pagina utiliza frames, pero su Explorador de Internet no los soporta.</p>' + HB_OsNewLine() + ;
      '            </td>' + HB_OsNewLine() + ;
      '         </tr>' + HB_OsNewLine() + ;
      '         </table>' + HB_OsNewLine() + ;
      '      </body>' + HB_OsNewLine() + ;
      '</frameset>' + HB_OsNewLine() + ;
      '</html>'
   QPM_MemoWrit( cDirSalida + DEF_SLASH + "_Index_" + cIndexName , cLinea )
//   US_FileChar26Zap( cDirSalida + DEF_SLASH + "_Index_" + cIndexName )
Return .T.

Function SHG_GenHtmlIndexJava( cIndexName , cDirSalida , vTopic , cClaves , cWWW )
   Local cLinea, i, nLastBook := 0
   cLinea := '<html>' + HB_OsNewLine() + ;
             '<head>' + HB_OsNewLine() + ;
             '<title>' + US_FileNameOnlyName( cIndexName ) + ' Help</title>' + HB_OsNewLine() + ;
             '<link rel="StyleSheet" href="SHG_dtree.css" type="text/css" />' + HB_OsNewLine() + ;
             '<script type="text/javascript" src="SHG_dtree.js"></script>' + HB_OsNewLine() + ;
             '</head>' + HB_OsNewLine() + ;
             '<body bgcolor="#e3e6db" link="blue" vlink="blue" alink="#389e6b" >' + HB_OsNewLine() + ;
             '<table border=2 cellpadding=0 cellspacing=0 width="100%">' + HB_OsNewLine() + ;
             '   <tr valign="center" bgcolor="#003366">' + HB_OsNewLine() + ;
             '      <td><div align=center><font face="COURIER NEW" size="2">&nbsp;</font></div>' + HB_OsNewLine() + ;
             '         <div align="center"><font face="COURIER NEW" size="5" color="#ffffff">' + US_FileNameOnlyName( cIndexName ) + '</FONT></DIV>' + HB_OsNewLine() + ;
             '         <div align=center><font face="COURIER NEW" size="2">&nbsp;</font></div>' + HB_OsNewLine() + ;
             '      </td>' + HB_OsNewLine() + ;
             '   </tr>' + HB_OsNewLine() + ;
             '</table>' + HB_OsNewLine() + ;
             '<br>' + HB_OsNewLine() + ;
             '<table border=1 cellpadding=0 cellspacing=0 width="100%">' + HB_OsNewLine() + ;
             '   <tr valign="center" bgcolor="white">' + HB_OsNewLine() + ;
             '      <td>' + HB_OsNewLine() + ;
             '         <div align="center"><font face="COURIER NEW" size="2" color="#ffffff"><A href="' + cWWW + '" target=blank>' + if( at( 'HTTP://' , upper( cWWW ) ) == 1 , substr( cWWW , 8 ) , cWWW ) + '</A></FONT></DIV>' + HB_OsNewLine() + ;
             '      </td>' + HB_OsNewLine() + ;
             '   </tr>' + HB_OsNewLine() + ;
             '</table>' + HB_OsNewLine() + ;
             '<br>' + HB_OsNewLine() + ;
             '<div class="dtree">' + HB_OsNewLine() + ;
             '<p><a href="javascript: d.openAll();">Expand all</a> | <a href="javascript: d.closeAll();">Colapse all</a></p>' + HB_OsNewLine() + ;
             '<script type="text/javascript"><!--' + HB_OsNewLine() + ;
             'd = new dTree("d");' + HB_OsNewLine()
   for i := 1 to len( vTopic )
      do case
         case vTopic[i][1] == "W"
            cLinea := cLinea + 'd.add(0,-1,"'+vTopic[i][2]+'","'+vTopic[i][3]+'");' + HB_OsNewLine()
         case vTopic[i][1] == "B"
            cLinea := cLinea + 'd.add('+alltrim(str(i-1))+',0,"'+vTopic[i][2]+'","'+vTopic[i][3]+'");' + HB_OsNewLine()
            nLastBook := i-1
         otherwise
            cLinea := cLinea + 'd.add('+alltrim(str(i-1))+','+alltrim(str(nLastBook))+',"'+vTopic[i][2]+'","'+vTopic[i][3]+'");' + HB_OsNewLine()
      endcase
   next
   cLinea := cLinea + ;
      ' ' + HB_OsNewLine() + ;
      'document.write(d);' + HB_OsNewLine() + ;
      '//-->' + HB_OsNewLine() + ;
      '</script>' + HB_OsNewLine() + ;
      '</div>' + HB_OsNewLine()
   cLinea := cLinea + '</body>' + HB_OsNewLine() + ;
      '</html>'
   QPM_MemoWrit( cDirSalida + DEF_SLASH + US_FileNameOnlyName( cIndexName ) + "_FrameLeft_Java.htm" , cLinea )
//   US_FileChar26Zap( cDirSalida + DEF_SLASH + US_FileNameOnlyName( cIndexName ) + "_FrameLeft_Java.htm" )
   
   cLinea := '<html>' + HB_OsNewLine() + ;
      '<head><meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">' + HB_OsNewLine() + ;
      '   <meta name="keywords" ' + HB_OsNewLine() + ;
      '   content="' + cClaves + HB_OsNewLine() + ;
      '   ">' + HB_OsNewLine() + ;
      '   <title>' + US_FileNameOnlyName( cIndexName ) + '     ' + HB_OsNewLine() + ;
      '   </title>' + HB_OsNewLine() + ;
      '</head>' + HB_OsNewLine() + ;
      '<frameset cols="25%,*">' + HB_OsNewLine() + ;
      '   <frame name="Menu" scrolling="auto" src="' + US_FileNameOnlyName( cIndexName ) + '_FrameLeft_Java.htm">' + HB_OsNewLine() + ;
      '      <frame name="body" src="' + vTopic[1][3] + '" scrolling="auto">' + HB_OsNewLine() + ;
      '      <noframes>' + HB_OsNewLine() + ;
      '      <body>' + HB_OsNewLine() + ;
      '         <table border="0" cellpadding="0" cellspacing="0" width="100%">' + HB_OsNewLine() + ;
      '         <tr>' + HB_OsNewLine() + ;
      '            <td valign="top">' + HB_OsNewLine() + ;
      "            <p>This page uses frames, but your browser doesn't support them.</p>" + HB_OsNewLine() + ;
      '            <p>Esta pagina utiliza frames, pero su Explorador de Internet no los soporta.</p>' + HB_OsNewLine() + ;
      '            </td>' + HB_OsNewLine() + ;
      '         </tr>' + HB_OsNewLine() + ;
      '         </table>' + HB_OsNewLine() + ;
      '      </body>' + HB_OsNewLine() + ;
      '</frameset>' + HB_OsNewLine() + ;
      '</html>'
   QPM_MemoWrit( cDirSalida + DEF_SLASH + "_Index_" + US_FileNameOnlyName( cIndexName ) + "_Java." + US_FileNameOnlyExt( cIndexName ) , cLinea )
//   US_FileChar26Zap( cDirSalida + DEF_SLASH + "_Index_" + US_FileNameOnlyName( cIndexName ) + "_Java." + US_FileNameOnlyExt( cIndexName ) )
Return .T.

Function SHG_StrTran( cFullName )
   Local cName := US_FileNameOnlyNameAndExt( cFullName )
/*
   for nInx := 1 to len( cName )
      cAux := Substr( cName , nInx , 1 )
      if !IsAlpha( cAux ) .and. ;
         !IsDigit( cAux ) .and. ;
         cAux != "_" .and. ;
         cAux != "."
         cName := StrTran( cName , cAux , "_" )
      endif
   next
*/
Return US_FileNameOnlyPath( cFullName ) + DEF_SLASH + cName

Function SHG_Commands( cIn , cPos )
   Local nFrom, nTo, nBase := 1, cLineCommand, cCommand
   Local bError := .F., cParm
   Local cMemoOut := "", cMemoIn := memoread( cIn )
   
#IFDEF __XHARBOUR__
   Do while ( nFrom := at( "<!--SHG_" + cPos + "COMMAND " , cMemoIn , nBase ) ) > 0
#ELSE
   Do while ( nFrom := hb_at( "<!--SHG_" + cPos + "COMMAND " , cMemoIn , nBase ) ) > 0
#ENDIF
      nBase++
#IFDEF __XHARBOUR__
      if ( nTo := at( "-->" , cMemoIn , nFrom + 1 ) ) > 0
#ELSE
      if ( nTo := hb_at( "-->" , cMemoIn , nFrom + 1 ) ) > 0
#ENDIF
         cLineCommand := substr( cMemoIn , nFrom , nTo - nFrom )
         cCommand := US_Word( cLineCommand , 2 )
         cParm := US_WordSubStr( cLineCommand , 3 )
         cMemoOut := cMemoOut + substr( cMemoIn , nBase - 1 , nFrom - ( nBase - 1 ) )
         nBase := nTo + 3
         do case
            case cCommand == "EXECUTE"
               QPM_Execute( US_Word( cParm , 1 ) , US_WordSubStr( cParm , 2 ) , .T. , -1 )
            case cCommand == "INCLUDEHTM"
               if !file( cParm )
                  US_Log( "Error SHG_" + cPos + "COMMAND INCLUDEHTM: File Not Found!: " + cParm )
                  bError := .T.
               else
                  cMemoOut := cMemoOut + memoread( cParm )
               endif
            case cCommand == "INCLUDETXT"
               if !file( cParm )
                  US_Log( "Error SHG_" + cPos + "COMMAND INCLUDETXT: File Not Found!: " + cParm )
                  bError := .T.
               else
                  cMemoOut := cMemoOut + strtran( strtran( strtran( memoread( cParm ) , chr(13)+chr(10) , "<br>" ) , chr( 10 ) , "<br>" ) , " " , "&nbsp;" )
               endif
            case cCommand == "DELETE"
               ferase( cParm )
            otherwise
               US_Log( "Error SHG_" + cPos + "COMMAND: Invalid Command: " + cCommand )
               bError := .T.
               exit
         endcase
      else
         US_Log( "Error SHG_" + cPos + "COMMAND: Command without end: " + substr( cMemoIn , nFrom , 30 ) + "..." )
         bError := .T.
         exit
      endif
   enddo
   if !empty( cMemoOut ) .and. !bError
      cMemoOut := cMemoOut + substr( cMemoIn , nBase )
      QPM_MemoWrit( cIn , cMemoOut )
//      US_FileChar26Zap( cIn )
   endif
Return .T.

#endif

#pragma BEGINDUMP

#include <windows.h>
#include "hbapi.h"
#include "qpm.h"

#define HDIB HANDLE
#define IS_WIN30_DIB(lpbi)  ((*(LPDWORD)(lpbi)) == sizeof(BITMAPINFOHEADER))

WORD DIBNumColors(LPSTR lpDIB)
{
    WORD wBitCount;  // DIB bit count

    // If this is a Windows-style DIB, the number of colors in the
    // color table can be less than the number of bits per pixel
    // allows for (i.e. lpbi->biClrUsed can be set to some value).
    // If this is the case, return the appropriate value.


    if (IS_WIN30_DIB(lpDIB))
    {
        DWORD dwClrUsed;

        dwClrUsed = ((LPBITMAPINFOHEADER)lpDIB)->biClrUsed;
        if (dwClrUsed)

        return (WORD)dwClrUsed;
    }

    // Calculate the number of colors in the color table based on
    // the number of bits per pixel for the DIB.

    if (IS_WIN30_DIB(lpDIB))
        wBitCount = ((LPBITMAPINFOHEADER)lpDIB)->biBitCount;
    else
        wBitCount = ((LPBITMAPCOREHEADER)lpDIB)->bcBitCount;

    // return number of colors based on bits per pixel

    switch (wBitCount)
    {
        case 1:
            return 2;

        case 4:
            return 16;

        case 8:
            return 256;

        default:
            return 0;
    }
}

WORD PaletteSize(LPSTR lpDIB)
{
    // calculate the size required by the palette
    if (IS_WIN30_DIB (lpDIB))
        return (WORD) (DIBNumColors(lpDIB) * sizeof(RGBQUAD));
    else
        return (WORD) (DIBNumColors(lpDIB) * sizeof(RGBTRIPLE));
}

HANDLE DDBToDIB(HBITMAP hBitmap, HPALETTE hPal)
{
    BITMAP              bm;         // bitmap structure
    BITMAPINFOHEADER    bi;         // bitmap header
    LPBITMAPINFOHEADER  lpbi;       // pointer to BITMAPINFOHEADER
    DWORD               dwLen;      // size of memory block
    HANDLE              hDIB, h;    // handle to DIB, temp handle
    HDC                 hDC;        // handle to DC
    WORD                biBits;     // bits per pixel

    // check if bitmap handle is valid

    if (!hBitmap)
        return NULL;

    // fill in BITMAP structure, return NULL if it didn't work

    if (!GetObject(hBitmap, sizeof(bm), (LPSTR)&bm))
        return NULL;

   // if no palette is specified, use default palette

   if( hPal == NULL )
   {
      hPal = ( HPALETTE ) GetStockObject(DEFAULT_PALETTE);
   }

    // calculate bits per pixel

    biBits = ( WORD ) ( bm.bmPlanes * bm.bmBitsPixel );

    // make sure bits per pixel is valid

    if (biBits <= 1)
        biBits = 1;
    else if (biBits <= 4)
        biBits = 4;
    else if (biBits <= 8)
        biBits = 8;
    else // if greater than 8-bit, force to 24-bit
        biBits = 24;

    // initialize BITMAPINFOHEADER

    bi.biSize = sizeof(BITMAPINFOHEADER);
    bi.biWidth = bm.bmWidth;
    bi.biHeight = bm.bmHeight;
    bi.biPlanes = 1;
    bi.biBitCount = biBits;
    bi.biCompression = BI_RGB;
    bi.biSizeImage = 0;
    bi.biXPelsPerMeter = 0;
    bi.biYPelsPerMeter = 0;
    bi.biClrUsed = 0;
    bi.biClrImportant = 0;

    // calculate size of memory block required to store BITMAPINFO

    dwLen = bi.biSize + PaletteSize((LPSTR)&bi);

    // get a DC

    hDC = GetDC(NULL);

    // select and realize our palette

    hPal = SelectPalette(hDC, hPal, FALSE);
    RealizePalette(hDC);

    // alloc memory block to store our bitmap

    hDIB = GlobalAlloc(GHND, dwLen);

    // if we couldn't get memory block

    if (!hDIB)
    {
      // clean up and return NULL

      SelectPalette(hDC, hPal, TRUE);
      RealizePalette(hDC);
      ReleaseDC(NULL, hDC);
      return NULL;
    }

    // lock memory and get pointer to it

    lpbi = (LPBITMAPINFOHEADER)GlobalLock(hDIB);

    /// use our bitmap info. to fill BITMAPINFOHEADER

    *lpbi = bi;

    // call GetDIBits with a NULL lpBits param, so it will calculate the
    // biSizeImage field for us

    GetDIBits(hDC, hBitmap, 0, (UINT)bi.biHeight, NULL, (LPBITMAPINFO)lpbi,
        DIB_RGB_COLORS);

    // get the info. returned by GetDIBits and unlock memory block

    bi = *lpbi;
    GlobalUnlock(hDIB);

    // if the driver did not fill in the biSizeImage field, make one up
    if (bi.biSizeImage == 0)
        bi.biSizeImage = ((((DWORD)bm.bmWidth * biBits)+ 31) / 32 * 4) * bm.bmHeight;
    // realloc the buffer big enough to hold all the bits

    dwLen = bi.biSize + PaletteSize((LPSTR)&bi) + bi.biSizeImage;

    h = GlobalReAlloc(hDIB, dwLen, 0);
    if ( h )
    {
        hDIB = h;
    }
    else
    {
        // clean up and return NULL

        GlobalFree(hDIB);
///        hDIB = NULL;
        SelectPalette(hDC, hPal, TRUE);
        RealizePalette(hDC);
        ReleaseDC(NULL, hDC);
        return NULL;
    }

    // lock memory block and get pointer to it */

    lpbi = (LPBITMAPINFOHEADER)GlobalLock(hDIB);

    // call GetDIBits with a NON-NULL lpBits param, and actualy get the
    // bits this time

    if (GetDIBits(hDC, hBitmap, 0, (UINT)bi.biHeight, (LPSTR)lpbi +
            (WORD)lpbi->biSize + PaletteSize((LPSTR)lpbi), (LPBITMAPINFO)lpbi,
            DIB_RGB_COLORS) == 0)
    {
        // clean up and return NULL

        GlobalFree(hDIB);

///////        hDIB = NULL;

        SelectPalette(hDC, hPal, TRUE);
        RealizePalette(hDC);
        ReleaseDC(NULL, hDC);
        return NULL;
    }

    bi = *lpbi;

    // clean up
    GlobalUnlock(hDIB);
    SelectPalette(hDC, hPal, TRUE);
    RealizePalette(hDC);
    ReleaseDC(NULL, hDC);

    // return handle to the DIB
    return hDIB;
}

WORD SaveDIB(HDIB hDib, LPSTR lpFileName)
{
    BITMAPFILEHEADER    bmfHdr;     // Header for Bitmap file
    LPBITMAPINFOHEADER  lpBI;       // Pointer to DIB info structure
    HANDLE              fh;         // file handle for opened file
    DWORD               dwDIBSize;
    DWORD               dwWritten;
    DWORD               dwBmBitsSize;

    fh = CreateFile(lpFileName, GENERIC_WRITE, 0, NULL, CREATE_ALWAYS,
            FILE_ATTRIBUTE_NORMAL | FILE_FLAG_SEQUENTIAL_SCAN, NULL);


    // Get a pointer to the DIB memory, the first of which contains
    // a BITMAPINFO structure

    lpBI = (LPBITMAPINFOHEADER)GlobalLock(hDib);
    if (!lpBI)
    {
        CloseHandle(fh);
        return 1;
    }

    if (lpBI->biSize != sizeof(BITMAPINFOHEADER))
    {
        GlobalUnlock(hDib);
        CloseHandle(fh);
        return 1;
    }


    bmfHdr.bfType = ((WORD) ('M' << 8) | 'B'); // is always "BM"

    dwDIBSize = *(LPDWORD)lpBI + PaletteSize((LPSTR)lpBI);


    dwBmBitsSize = ((((lpBI->biWidth)*((DWORD)lpBI->biBitCount))+ 31) / 32 * 4) *  lpBI->biHeight;
    dwDIBSize += dwBmBitsSize;
    lpBI->biSizeImage = dwBmBitsSize;


    bmfHdr.bfSize = dwDIBSize + sizeof(BITMAPFILEHEADER);
    bmfHdr.bfReserved1 = 0;
    bmfHdr.bfReserved2 = 0;

    // Now, calculate the offset the actual bitmap bits will be in
    // the file -- It's the Bitmap file header plus the DIB header,
    // plus the size of the color table.

    bmfHdr.bfOffBits = (DWORD)sizeof(BITMAPFILEHEADER) + lpBI->biSize +
            PaletteSize((LPSTR)lpBI);

    // Write the file header

    WriteFile(fh, (LPSTR)&bmfHdr, sizeof(BITMAPFILEHEADER), &dwWritten, NULL);

    // Write the DIB header and the bits -- use local version of
    // MyWrite, so we can write more than 32767 bytes of data

    WriteFile(fh, (LPSTR)lpBI, dwDIBSize, &dwWritten, NULL);

    GlobalUnlock(hDib);
    CloseHandle(fh);

    if (dwWritten == 0)
        return 1; // oops, something happened in the write
    else
        return 0; // Success code
}

HB_FUNC( _SAVEBITMAP )                   // hBitmap, cFile
{
   HANDLE hDIB;

   hDIB = DDBToDIB( ( HBITMAP ) ( HWND ) HB_PARNL( 1 ), NULL );
   SaveDIB( hDIB, ( LPSTR ) hb_parc( 2 ) );
   GlobalFree( hDIB );
}

#pragma ENDDUMP

/* eof */
