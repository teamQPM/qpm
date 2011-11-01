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

#ifdef QPM_SHG

Function SHG_CreateDatabase( cFile )
   Local auxName
   auxName := US_FileTmp( US_FileNameOnlyPath( cFile ) + DEF_SLASH + "_AddDbf" )
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
   DBUseArea( .T. , , SHG_Database , "SHG" , DEF_DBF_EXCLUSIVE , DEF_DBF_WRITE )
   DbGoTop()
   SHG_IndexON( SHG_Database )
   DBCloseArea( "SHG" )
   SHG_AddRecord( "F" , 1 , "Global Foot" , "" , "This text will be include into Foot of all pages of Help" + HB_OsNewLine() )
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
      if MsgYesNo( "Confirm Close Help Database ?" )
         QPM_Wait( 'DoMethod( "VentanaMain" , "GHlpFiles" , "DeleteAllItems" )' )
         if US_FileSize( US_FileNameOnlyPathAndName( SHG_Database ) + ".dbt" ) > SHG_DbSize
            QPM_Wait( 'SHG_PackDatabase()' )
         endif
         SHG_Database := ""
         SetProperty( "VentanaMain" , "THlpDataBase" , "Value" , "" )
         SHG_BaseOK := .F.
         SetProperty( "VentanaMain" , "RichEditHlp" , "value" , "" )
         SetProperty( "VentanaMain" , "RichEditHlp" , "readonly" , .T. )
      else
         Return .F.
      endif
   endif
Return .T.

Function SHG_PackDatabase()
   Local cTmpDb := US_FileNameOnlyPathAndName( SHG_Database ) + "_" + PUB_cSecu + ".dbf"
// msginfo( shg_dbsize )
// msginfo( US_FileSize( US_FileNameOnlyPathAndName( SHG_Database ) + ".dbt" ) )
//msginfo( "pack" )
   if !file( cTmpDb )
      DBUseArea( .T. , , SHG_Database , "SHG" , DEF_DBF_EXCLUSIVE , DEF_DBF_WRITE )
      COPY TO ( cTmpDb )
      DBClosearea( "SHG" )
      if file( cTmpDb )
         ferase( SHG_Database )
         ferase( US_FileNameOnlyPathAndName( SHG_Database ) + ".dbt" )
      endif
      if !file( SHG_Database )
         DBUseArea( .T. , , cTmpDb , "SHG" , DEF_DBF_EXCLUSIVE , DEF_DBF_WRITE )
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
   Local vFiles
   Local cFile := "" , cOldDatabase := GetProperty( "VentanaMain" , "THlpDataBase" , "Value" )
   if !( QPM_WAIT( "SHG_CheckSave()" , "Checking for save ..." ) )
      Return .F.
   endif
   /* Get file con multiselect en .F. trae problemas cuando se pone algo nuevo y se presiona enter en lugar de usar el boton */
   If ( len( vFiles := US_GetFile( { {'QPM Help Generator Database (*_SHG.DBF)','*_SHG.DBF'} } , "Select QPM Help Generator Database" , if( !empty( US_FileNameOnlyPath( GetProperty( "VentanaMain" , "THlpDataBase" , "Value" ) ) ) , US_FileNameOnlyPath( GetProperty( "VentanaMain" , "THlpDataBase" , "Value" ) ) , PUB_cProjectFolder ) , .T. , .T. ) ) > 0 )
   // cFile := vFiles[1]
      cFile := SHG_StrTran( vFiles[1] )
      if upper( right( US_FileNameOnlyName( cFile ) , 4 ) ) != "_SHG"
         cFile := US_FileNameOnlyPath( cFile ) + DEF_SLASH + US_FileNameOnlyName( cFile ) + "_SHG.dbf"
      endif
      if US_FileNameOnlyExt( cFile ) != "dbf"
         cFile := US_FileNameOnlyPathAndName( cFile ) + ".dbf"
      endif
      if !file( cFile )
         if MsgYesNo( "Help Database '"+cFile+"' not found.  Do you want create an empty database ?" )
            SHG_CreateDatabase( cFile )
            SetProperty( "VentanaMain" , "THlpDataBase" , "Value" , cFile )
         else
            Return .F.
         endif
      else
         if US_IsDbf( cFile ) = 21
            msgStop( "Help database '" + cFile + "' if open by another process..." + HB_OsNewline() + "Free the database an retry" )
            Return .F.
         endif
         if US_IsDbf( cFile ) != 0
            msgStop( "Invalid or corrupted Help database '" + cFile + "'" )
            Return .F.
         endif
         SHG_Database := cFile
         SetProperty( "VentanaMain" , "THlpDataBase" , "Value" , cFile )
      endif
   else
      Return .F.
   Endif
// if !( SHG_Database == cOldDatabase )
   QPM_WAIT( "SHG_LoadDatabase( SHG_Database )" , "Loading Database ..." )
// endif
Return .T.

Function SHG_AddRecord( cType , nSecu , cTopic , cNick , cMemo , cKeys )
   DEFAULT cKeys TO ""
//\\ cMemo := "{\rtf1\ansi\ansicpg1252\deff0\deflang3082{\fonttbl{\f0\froman\fcharset0 Arial;}{\f1\fnil\fcharset0 MS Sans Serif;}}" + HB_OsNewline() + ;
//\\        "{\colortbl ;\red0\green0\blue0;}" + HB_OsNewline() + ;
//\\        "\viewkind4\uc1\pard\sb100\sa100\cf1\f0\fs20 " + cMemo + HB_OsNewline() + ;
//\\        "\par \pard\cf0\f1\fs17 " + HB_OsNewline() + ;
//\\        "\par }"
   cMemo := "{\rtf1\ansi\ansicpg1252\deff0\deflang3082{\fonttbl{\f0\froman\fcharset0 Arial;}{\f1\fnil\fcharset0 MS Sans Serif;}}" + HB_OsNewline() + ;
            "{\colortbl ;\red0\green0\blue0;}" + HB_OsNewline() + ;
            "\viewkind4\uc1\cf1\f0\fs20 " + cMemo + HB_OsNewline() + ;
            "\par }"
       //   "\par \cf0\f1\fs17 " + HB_OsNewline() + ;
   cMemo := US_RTF2RTF( cMemo )
 //cMemo := US_TXT2RTF( cMemo )
 //Local cAuxMemo := US_GetRichEditValue( "VentanaMain" , "RichEditHlp" , "RTF" )
 //SetProperty( "VentanaMain" , "RichEditHlp" , "Value" , cMemo )
 //cMemo := US_GetRichEditValue( "VentanaMain" , "RichEditHlp" , "RTF" )
 //SetProperty( "VentanaMain" , "RichEditHlp" , "Value" , cAuxMemo )
   DBUseArea( .T. , , SHG_Database , "SHG" , DEF_DBF_EXCLUSIVE , DEF_DBF_WRITE )
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
   DBUseArea( .T. , , SHG_Database , "SHG" , DEF_DBF_EXCLUSIVE , DEF_DBF_WRITE )
   DBSetIndex( US_FileNameOnlyPathAndName( SHG_Database ) )
   DBGoTop()
   if !DbSeek( nRec )
      msginfo( "Error locating record number " + US_TodoStr( nRec ) + " in function SHG_DeleteRecord. Please, contact support" )
   else
      DELETE
   endif
   DBCloseArea( "SHG" )
   SHG_NewSecuence()
Return .T.

Function SHG_GetField( cField , nRow )
   Local cAux := "Record " + US_TodoStr( nRow ) + " not found.  Contact with QPM Support for Assistance"
   DBUseArea( .T. , , SHG_Database , "SHG" , DEF_DBF_EXCLUSIVE , DEF_DBF_WRITE )
   DBSetIndex( US_FileNameOnlyPathAndName( SHG_Database ) )
   DBGoTop()
   if !DbSeek( nRow )
      msginfo( "Error locating record number " + US_TodoStr( nRow ) + " in function SHG_GetField. Please, contact support" )
   else
      cAux := &( cField )
   endif
   DBCloseArea( "SHG" )
Return cAux

Function SHG_SetField( cField , nRow , xValue )
   Local bReto := .F.
// msginfo( us_todostr( nRow ) )
// msginfo( us_todostr( xValue ) )
   DBUseArea( .T. , , SHG_Database , "SHG" , DEF_DBF_EXCLUSIVE , DEF_DBF_WRITE )
   DBSetIndex( US_FileNameOnlyPathAndName( SHG_Database ) )
   DBGoTop()
   if !DbSeek( nRow )
      msginfo( "Error locating record number " + US_TodoStr( nRow ) + " in function SHG_SetField. Please, contact support" )
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
      DO EVENTS
      if GetProperty( "VentanaMain" , "GHlpFiles" , "Cell" , nInx , NCOLHLPEDIT ) == "D"
         aadd( vDiff , nInx )
      endif
   Next
   if len( vDiff ) == 0
      Return .T.
   endif
   if len( vDiff ) == 1
      if ( rpt := MsgYesNoCancel( "Help Topic '" + alltrim( GetProperty( "VentanaMain" , "GHlpFiles" , "Cell" , vDiff[1] , NCOLHLPTOPIC ) ) + "' not saved !!!" + HB_OsNewLine() + "Save it ???" ) ) == 1
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
   if ( rpt := MsgYesNoCancel( alltrim( str( len( vDiff ) ) ) + " Help's Topic's not saved !!!" + HB_OsNewLine() + HB_OsNewLine() + "Reply YES for save ALL Topic" + HB_OsNewLine() + "Reply NO for discard ALL changes of Topics" + HB_OsNewLine() + "Reply CANCEL for return to edit HLP Topics" ) ) == 1
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
      DO EVENTS
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
Return

Function SHG_Generate( cBase , bGenHtml , PUB_cSecu , cWWW )
// Local Prefijo    := "Hlp"
   Local Prefijo    := ""
   Local cOldDll    := ""
   Local Folder     := ""
   Local bCreateDir := .F.
   Local cCreateDir := ""
   Local cDllWithCancel := ""
   Local cName , cPrev := NIL , cTop := NIL , cNext := NIL
   Local nCont := 0 , i
   Local cDirOutCHM := PUB_cProjectFolder + DEF_SLASH + "_" + PUB_cSecu + "HlpTemp"
   Local nRegistros := 0 , cMemoHeader , cMemoFooter , cFooterHTML
   Local cBackColor := "#FFFCEA"
   Local cDescri    := "Compilación Incremental con todas las versiones de MiniGui"
   Local ceMail     := "mailto:qpm-users@lists.sourceforge.net"
   Local wwwCdQ     := "http://qpm.sourceforge.net"
   Local cWWWDescri := "Powered by QPM"
   Local cAux       := ""
   Local nCinx      := 0
   Private cClaves  := " "
   Private cDirOutHTML := PUB_cProjectFolder + DEF_SLASH + "HtmlHelp"
   Private vFiles := {}
   Private vFilesToCompile := {}
   if empty( cWWW ) .or. len( cWWW ) < 4
      cWWW := wwwCdQ
   endif
   if empty( PUB_cProjectFolder )
      msgstop( "Project folder not completed, look at " + PagePrg )
      Return .F.
   endif
   if !( US_IsDirectory( PUB_cProjectFolder ) )
      msgstop( "Project folder not found: " + PUB_cProjectFolder )
      Return .F.
   endif
   if US_FileInUse( SHG_GetOutputName() )
      msginfo( "Output name '" + SHG_GetOutputName() + "' is in use." + HB_OsNewLine() + "Close the help process an retry" )
      Return .F.
   endif
   // check
   if !file( cBase )
      msgStop( "Help database not found: " + cBase + HB_OsNewLine() + "Use open button for open or create help database" )
      return .F.
   endif
   Prefijo     := US_FileNameOnlyName( SHG_GetOutputName() )
   DBUseArea( .T. , , cBase , "SHG" , DEF_DBF_EXCLUSIVE , DEF_DBF_WRITE )
   DbGoTo( 2 )
   cAux := SHG_TYPE
   DbGoTop()
   if SHG_TYPE != "F" .or. ;
      cAux     != "W" .or. ;
      SHG_ORDER != 1 .or. ;
      SHG_TOPIC != "Global Foot"
      msgStop( "Help Database is corrupted, records UNKNOWN" )
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
         if at( "msilto:" , upper( cWWW ) ) == 0
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
         msginfo( "QPM Help Generator Database not selected. Use open button for open or create help database" )
      else
         msginfo( "Error open QPM Help Generator Database: " + SHG_Database + HB_OsNewLine() + "Look at " + PageHlp )
      endif
      Return .F.
   endif
   if !SHG_CheckSave()
      Return .F.
   endif
   if bGenHtml
      if empty( SHG_HtmlFolder )
         SHG_HtmlFolder := cDirOutHTML
      endif
      if !US_IsDirectory( SHG_HtmlFolder )
         bCreateDir := .T.
         cCreateDir := SHG_HtmlFolder
         if !US_CreateFolder( SHG_HtmlFolder )
            US_Log( "Unable to create HTML folder: " + SHG_HtmlFolder )
            return .F.
         endif
      endif
      If !Empty( Folder := GetFolder( "Select Folder for HTML Output" , if( empty( SHG_HtmlFolder ) , PUB_cProjectFolder + DEF_SLASH + "HtmlHelp" , SHG_HtmlFolder ) ) )
         SHG_HtmlFolder := Folder
         if bCreateDir .and. !( upper( SHG_HtmlFolder ) == upper( cCreateDir ) )
            US_DirRemoveLoop( cCreateDir , 2 )
         endif
      else
         if bCreateDir
            US_DirRemoveLoop( cCreateDir , 2 )
         endif
         msginfo( "Folder requered for output type CHM and HTML" )
         Return .F.
      endif
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
   if US_filecopy( PUB_cQPM_Folder + DEF_SLASH + "US_A1.exe" , cDirOutCHM + DEF_SLASH + "SHG_ArrowPrev.bmp" ) != US_FileSize( PUB_cQPM_Folder + DEF_SLASH + "US_A1.exe" ) .or. ;
      US_FileCopy( PUB_cQPM_Folder + DEF_SLASH + "US_A2.exe" , cDirOutCHM + DEF_SLASH + "SHG_ArrowNext.bmp" ) != US_FileSize( PUB_cQPM_Folder + DEF_SLASH + "US_A2.exe" ) .or. ;
      US_FileCopy( PUB_cQPM_Folder + DEF_SLASH + "US_A3.exe" , cDirOutCHM + DEF_SLASH + "SHG_ArrowTop.bmp" ) != US_FileSize( PUB_cQPM_Folder + DEF_SLASH + "US_A3.exe" ) .or. ;
      US_FileCopy( PUB_cQPM_Folder + DEF_SLASH + "US_A4.exe" , cDirOutCHM + DEF_SLASH + "SHG_ArrowBottom.bmp" ) != US_FileSize( PUB_cQPM_Folder + DEF_SLASH + "US_A4.exe" )
      msginfo( "Error copying navigation images" )
   else
      QPM_MemoWrit( cDirOutCHM + DEF_SLASH + "SHG_ArrowPrev.bmp" , "BM6" + substr( memoread( cDirOutCHM + DEF_SLASH + "SHG_ArrowPrev.bmp" ) , 4 ) )
      QPM_MemoWrit( cDirOutCHM + DEF_SLASH + "SHG_ArrowNext.bmp" , "BM6" + substr( memoread( cDirOutCHM + DEF_SLASH + "SHG_ArrowNext.bmp" ) , 4 ) )
      QPM_MemoWrit( cDirOutCHM + DEF_SLASH + "SHG_ArrowTop.bmp" , "BM6" + substr( memoread( cDirOutCHM + DEF_SLASH + "SHG_ArrowTop.bmp" ) , 4 ) )
      QPM_MemoWrit( cDirOutCHM + DEF_SLASH + "SHG_ArrowBottom.bmp" , "BM6" + substr( memoread( cDirOutCHM + DEF_SLASH + "SHG_ArrowBottom.bmp" ) , 4 ) )
      if bGenHtml
         US_FileCopy( cDirOutCHM + DEF_SLASH + "SHG_ArrowPrev.bmp" , cDirOutHTML + DEF_SLASH + "SHG_ArrowPrev.bmp" )
         US_FileCopy( cDirOutCHM + DEF_SLASH + "SHG_ArrowNext.bmp" , cDirOutHTML + DEF_SLASH + "SHG_ArrowNext.bmp" )
         US_FileCopy( cDirOutCHM + DEF_SLASH + "SHG_ArrowTop.bmp" , cDirOutHTML + DEF_SLASH + "SHG_ArrowTop.bmp" )
         US_FileCopy( cDirOutCHM + DEF_SLASH + "SHG_ArrowBottom.bmp" , cDirOutHTML + DEF_SLASH + "SHG_ArrowBottom.bmp" )
         /* Copio extra images for html help */
         US_FileCopy( PUB_cQPM_Folder + DEF_SLASH + "US_S1.exe" , cDirOutHTML + DEF_SLASH + "SHG_Welcome.bmp" )
         US_FileCopy( PUB_cQPM_Folder + DEF_SLASH + "US_S2.exe" , cDirOutHTML + DEF_SLASH + "SHG_Book.bmp" )
         US_FileCopy( PUB_cQPM_Folder + DEF_SLASH + "US_S3.exe" , cDirOutHTML + DEF_SLASH + "SHG_Page.bmp" )
         QPM_MemoWrit( cDirOutHTML + DEF_SLASH + "SHG_Welcome.bmp" , "BM6" + substr( memoread( cDirOutHTML + DEF_SLASH + "SHG_Welcome.bmp" ) , 4 ) )
         QPM_MemoWrit( cDirOutHTML + DEF_SLASH + "SHG_Book.bmp" , "BM6" + substr( memoread( cDirOutHTML + DEF_SLASH + "SHG_Book.bmp" ) , 4 ) )
         QPM_MemoWrit( cDirOutHTML + DEF_SLASH + "SHG_Page.bmp" , "BM6" + substr( memoread( cDirOutHTML + DEF_SLASH + "SHG_Page.bmp" ) , 4 ) )
         /* Copio dtree for html help */
         US_FileCopy( PUB_cQPM_Folder + DEF_SLASH + "US_dtree.css" , cDirOutHTML + DEF_SLASH + "SHG_dtree.css" )
         US_FileCopy( PUB_cQPM_Folder + DEF_SLASH + "US_dtree.js" , cDirOutHTML + DEF_SLASH + "SHG_dtree.js" )
         US_FileCopy( PUB_cQPM_Folder + DEF_SLASH + "US_dtree.im" , cDirOutHTML + DEF_SLASH + "SHG_dtree.zip" )
         if !HB_UNZIPFILE(cDirOutHTML + DEF_SLASH + "SHG_dtree.zip",,.T.,,cDirOutHTML + DEF_SLASH + "SHG_IMG" , "*.*" )
            msginfo( "Error decompresing images for index tree of HTML Help (Java Mode)" )
         else
            ferase( cDirOutHTML + DEF_SLASH + "SHG_dtree.zip" )
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
      endif
   endif
   DBUseArea( .T. , , cBase , "HlpAlias" , DEF_DBF_EXCLUSIVE , DEF_DBF_WRITE )
   DBSetIndex( US_FileNameOnlyPathAndName( cBase ) )
   nRegistros := Reccount()
   DbSeek( 1 )
   SetMGWaitTxt( "Generating foot for pages..." )
   QPM_MemoWrit( cDirOutCHM + DEF_SLASH + "Footer.rtf" , SHG_MEMO )
   US_FileChar26Zap( cDirOutCHM + DEF_SLASH + "Footer.rtf" )
   SHG_RtfToHtml( cDirOutCHM + DEF_SLASH + "Footer.rtf" , cDirOutCHM + DEF_SLASH + "Footer.htm" , "Global Foot" )
   cFooterHTML := SHG_HTML_GetFooter( cDirOutCHM + DEF_SLASH + "Footer.htm" )
   DBSeek( 3 )
   if !empty( SHG_NICK )
      cTop := alltrim( SHG_NICK )
   else
      cTop := Prefijo + "_2.htm"
   endif
   DBSeek( 2 )
   Do while !eof()
      DO EVENTS
      nCont++
      if SHG_ORDER < 4
         cPrev := NIL
      else
         DBSKIP( -1 )
         if empty( SHG_NICK )
            cPrev := Prefijo + "_" + alltrim( str( nCont - 1 ) ) + ".htm"
         else
            cPrev := alltrim( SHG_NICK )
         endif
         DBSKIP( +1 )
      endif
      if SHG_ORDER == nRegistros
         cNext := NIL
      else
         DBSKIP( +1 )
         if empty( SHG_NICK )
            cNext := Prefijo + "_" + alltrim( str( nCont + 1 ) ) + ".htm"
         else
            cNext := alltrim( SHG_NICK )
         endif
         DBSKIP( -1 )
      endif
      if empty( SHG_NICK )
         cName := Prefijo + "_" + alltrim( str( nCont ) )
      else
         cName := US_FileNameOnlyName( SHG_NICK )
      endif
      if !empty( SHG_KEYS )
         QPM_MemoWrit( cDirOutCHM + DEF_SLASH + cName + ".Inx" , SHG_KEYS )
         if bGenHtml
            for nCinx := 1 to mlcount( SHG_KEYS , 254 )
               if at( upper( alltrim( memoline( SHG_KEYS , 254 , nCinx ) ) + ", " ) , upper( cClaves ) ) == 0
                  cClaves := cClaves + alltrim( memoline( SHG_KEYS , 254 , nCinx ) ) + ", "
               endif
            next
         endif
      endif
   // msginfo( alltrim( SHG_TOPIC ) + hb_osNewLine() + SHG_TYPE )
      aadd( vFiles , { alltrim( SHG_TYPE ) , strtran( strtran( alltrim( SHG_TOPIC ) , "<" , "&lt;" ) , ">" , "&gt;" ) , cName + ".htm" , cDirOutCHM + DEF_SLASH + cName + ".Inx" , cPrev , cTop , cNext } )
      QPM_MemoWrit( cDirOutCHM + DEF_SLASH + cName + ".rtf" , SHG_Memo )
      US_FileChar26Zap( cDirOutCHM + DEF_SLASH + cName + ".rtf" )
   // SetMGWaitTxt( "Generating: " + cName + ".htm ..." )
      SetMGWaitTxt( "Generating: " + alltrim( SHG_TOPIC ) + " ..." )
      SHG_RtfToHtml( cDirOutCHM + DEF_SLASH + cName + ".rtf" , cDirOutCHM + DEF_SLASH + cName + ".htm" , alltrim( SHG_TOPIC ) )
      if file( cDirOutCHM + DEF_SLASH + cName + ".htm" )
         SHG_HTML_ArmoHeader( @cMemoHeader , vFiles , len( vFiles ) , cBackColor , alltrim( SHG_TOPIC ) )
         SHG_HTML_AddHeader( cDirOutCHM + DEF_SLASH + cName + ".htm" , cMemoHeader )
         SHG_HTML_ArmoFooter( @cMemoFooter , vFiles , len( vFiles ) , cFooterHTML , cWWW , cWWWDescri )
         SHG_HTML_AddFooter( cDirOutCHM + DEF_SLASH + cName + ".htm" , cMemoFooter )
         if bGenHtml
            US_FileCopy( cDirOutCHM + DEF_SLASH + cName + ".htm" , cDirOutHTML + DEF_SLASH + cName + ".htm" )
         endif
      endif
//\\  ferase( cDirOutCHM + DEF_SLASH + cName + ".rtf" )
      DBSkip()
   enddo
   DBCloseArea( "HlpAlias" )
   SetMGWaitTxt( "Compiling to make " + SHG_GetOutputName() + "..." )
   SHG_HHP_Gener( Prefijo , cDirOutCHM , vFiles )
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
 //\\ ferase( cDirOutCHM + DEF_SLASH + vFiles[i][3] )
 //\\ ferase( vFiles[i][4] )
   next
//\\ ferase( cDirOutCHM + DEF_SLASH + Prefijo + ".hhp" )
//\\ ferase( cDirOutCHM + DEF_SLASH + Prefijo + ".hhc" )
//\\ ferase( cDirOutCHM + DEF_SLASH + Prefijo + ".hhk" )
   if !empty( cOldDll )
      SHG_RestoreDllItcc( cOldDll )
   else
      //ferase( PUB_cQPM_Folder + DEF_SLASH + "hha.dll" )
   endif
   ferase( PUB_cQPM_Folder + DEF_SLASH + "itcc_dll.tmp" )
   US_DirRemoveLoop( cDirOutCHM , 5 )    // Esto no funciona porque el directorio sigue tomado
Return .T.

Function SHG_CopyImageToHtmlFolder( vImage , cDirOut )
   Local i
   for i:=1 to len( vImage )
      DO EVENTS
      if file( vImage[i] )
         if US_FileCopy( vImage[i] , cDirOut + DEF_SLASH + US_FileNameOnlyNameAndExt( vImage[i] ) ) != US_FileSize( vImage[i] )
            msginfo( "Error copying file '" + vImage[i] + "' to folder: " + cDirOut )
         else
            if US_FileNameOnlyNameAndExt( US_FileNameCase( vImage[i] ) ) !=  US_FileNameOnlyNameAndExt( US_FileNameCase( cDirOut + DEF_SLASH + US_FileNameOnlyNameAndExt( vImage[i] ) ) )
  //     msginfo(US_FileNameOnlyNameAndExt( US_FileNameCase( vImage[i] ) ) + hb_osNewLine() + US_FileNameOnlyNameAndExt( US_FileNameCase( cDirOut + DEF_SLASH + US_FileNameOnlyNameAndExt( vImage[i] ) ) ) )
               frename( cDirOut + DEF_SLASH + US_FileNameOnlyNameAndExt( vImage[i] ) , cDirOut + DEF_SLASH + US_FileNameOnlyNameAndExt( vImage[i] ) + "." + PUB_cSecu )
               frename( cDirOut + DEF_SLASH + US_FileNameOnlyNameAndExt( vImage[i] ) + "." + PUB_cSecu , cDirOut + DEF_SLASH + US_FileNameOnlyNameAndExt( US_FileNameCase( vImage[i] ) ) )
            endif
         endif
      endif
   next
Return

Function SHG_GetOutputName()
   Local cOutputName := US_FileNameOnlyName( SHG_Database )
   cOutputName := substr( cOutputName , 1 , len( cOutputName ) - 4 )
Return US_FileNameOnlyPath( GetOutputModuleName() ) + DEF_SLASH + cOutputName + '.chm'

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
   US_FileChar26Zap( cFile )
Return .T.

Function SHG_HTML_AddFooter( cFile , cFooter )
   Local MemoAux := MemoRead( cFile )
// MemoAux := substr( MemoAux , 1 , rat( "</body></html>" , MemoAux ) - 1 ) + cFooter
   MemoAux := MemoAux + cFooter
   QPM_MemoWrit( cFile , MemoAux )
   US_FileChar26Zap( cFile )
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

Function SHG_HHP_Gener( Prefijo , cDirOutCHM , vFiles )
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
// Pepe
Function SHG_CompileToCHM( Proyecto , cDirOutCHM )
   Local cOutPut := cDirOutCHM + DEF_SLASH + '_' + PUB_cSecu + 'OutHHC' + US_DateTimeCen() + '.tmp'
   Local MemoResu
   ferase( SHG_GetOutputName() )
   QPM_MemoWrit( US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + '_'+PUB_cSecu+'RunShell.bat' , US_ShortName(PUB_cQPM_Folder) + DEF_SLASH + 'US_hhc.exe ' + Proyecto + ' > ' + cOutput )
// QPM_Execute( US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + '_'+PUB_cSecu+'RunShell.bat' , , DEF_QPM_EXEC_WAIT , DEF_QPM_EXEC_MINIMIZE )
   QPM_Execute( US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + '_'+PUB_cSecu+'RunShell.bat' , , DEF_QPM_EXEC_WAIT , DEF_QPM_EXEC_HIDE )
   ferase( US_ShortName( PUB_cProjectFolder ) + DEF_SLASH + '_'+PUB_cSecu+'RunShell.bat' )
   MemoResu := memoread( cOutPut )
   if at( "ERROR:" , upper( MemoResu ) ) == 0 .and. ;
      at( "WARNING:" , upper( MemoResu ) ) == 0
      MsgOk( 'QPM (QAC Based Project Manager)' , 'Build Finished' + HB_OsNewLine()+'OK' , 'I' , .T. )
      SHG_DisplayHelp( SHG_GetOutputName() )
   else
      msgStop( strtran( MemoResu , chr(13) + HB_OsNewLine() + chr(13) + HB_OsNewLine() , HB_OsNewLine() ) )
   endif
   ferase( cOutPut )
Return .T.

Function SHG_DisplayHelp( cName )
   Local cOldHelp := GetActiveHelpFile()
   if !file( cName )
      MsgInfo( "Help file '" + cName + "' not found !!!" + HB_OsNewLine() + "Run 'Generate Help' process and try again" )
      Return .F.
   endif
   if US_FileInUse( cName )
      msginfo( "Help file '" + cName + "' is in use." + HB_OsNewLine() + "Close the help process an re-open with TEST button" )
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
         DisplayHelpTopic( US_FileNameOnlyName( SHG_GetOutputName() ) + "_" + alltrim( str( GetProperty( "VentanaMain" , "GHlpFiles" , "value" ) - 1 ) ) )
      else
         DisplayHelpTopic( US_FileNameOnlyName( GetProperty( "VentanaMain" , "GHlpFiles" , "Cell" , GetProperty( "VentanaMain" , "GHlpFiles" , "value" ) , NCOLHLPNICK ) ) )
      endif
   endif
   if !empty( cOldHelp )
      SET HELPFILE TO cOldHelp
   endif
Return .T.

Function DisplayHelpTopic( xTopic , nMet )
    LOCAL LOC_cParam := ""
    If empty( GetActiveHelpFile() )
        Return
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
Return

Function SHG_Togle()
   if GetProperty( "VentanaMain" , "GHlpFiles" , "ItemCount" ) < 1
      Return .F.
   endif
   if GetProperty( "VentanaMain" , "GHlpFiles" , "Value" ) < 1
      msginfo( "Topic not selected" )
      Return .F.
   endif
   if GetProperty( "VentanaMain" , "GHlpFiles" , "Value" ) == 1
      msginfo( "Global foot not togle !!!, this is a system Topic" )
      Return .F.
   endif
   if GetProperty( "VentanaMain" , "GHlpFiles" , "Value" ) == 2
      msginfo( "Welcome page not togle !!!, this is a system Topic" )
      Return .F.
   endif
// msginfo( us_todoStr( GetProperty( "VentanaMain" , "GHlpFiles" , "Cell" , GetProperty( "VentanaMain" , "GHlpFiles" , "Value" ) , NCOLHLPSTATUS ) ) )
   if GridImage( "VentanaMain" , "GHlpFiles" , GetProperty( "VentanaMain" , "GHlpFiles" , "Value" ) , NCOLHLPSTATUS , "?" , PUB_nGridImgHlpBook )
// msginfo( "entro book" )
      GridImage( "VentanaMain" , "GHlpFiles" , GetProperty( "VentanaMain" , "GHlpFiles" , "Value" ) , NCOLHLPSTATUS , "-" , PUB_nGridImgHlpBook )
      GridImage( "VentanaMain" , "GHlpFiles" , GetProperty( "VentanaMain" , "GHlpFiles" , "Value" ) , NCOLHLPSTATUS , "+" , PUB_nGridImgHlpPage )
      SHG_SetField( "SHG_TYPET" , GetProperty( "VentanaMain" , "GHlpFiles" , "Value" ) , "P" )
   else
// msginfo( "entro page" )
      GridImage( "VentanaMain" , "GHlpFiles" , GetProperty( "VentanaMain" , "GHlpFiles" , "Value" ) , NCOLHLPSTATUS , "-" , PUB_nGridImgHlpPage )
      GridImage( "VentanaMain" , "GHlpFiles" , GetProperty( "VentanaMain" , "GHlpFiles" , "Value" ) , NCOLHLPSTATUS , "+" , PUB_nGridImgHlpBook )
      SHG_SetField( "SHG_TYPET" , GetProperty( "VentanaMain" , "GHlpFiles" , "Value" ) , "B" )
   endif
// msginfo( us_todoStr( GetProperty( "VentanaMain" , "GHlpFiles" , "Cell" , GetProperty( "VentanaMain" , "GHlpFiles" , "Value" ) , NCOLHLPSTATUS ) ) )
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
   DBUseArea( .T. , , SHG_Database , "SHG" , DEF_DBF_EXCLUSIVE , DEF_DBF_WRITE )
   DBSetIndex( US_FileNameOnlyPathAndName( SHG_Database ) )
   DBGoTop()
   do while !eof()
      DO EVENTS
      nInx++
      REPLACE SHG_ORDER WITH nInx
      DBSkip()
   enddo
   DBCloseArea( "SHG" )
//   DBUseArea( .T. , , SHG_Database , "SHG" , DEF_DBF_EXCLUSIVE , DEF_DBF_WRITE )
//   DBGoTop()
//   do while !eof()
//      DO EVENTS
//      REPLACE SHG_ORDER WITH SHG_ORDERT
//      DBSkip()
//   enddo
//   DBGoTop()
//   SHG_IndexON( SHG_Database )
//   DBCloseArea( "SHG" )
Return

Function SHG_LoadDatabase( cDataBase )
   Local cAux := "" , vStructure
   SetMGWaitTxt( "Loading Help Database ..." )
   if US_IsDBF( cDataBase ) != 0
      msginfo( "Error open QPM Help Generator Database: " + cDataBase + HB_OsNewLine() + "Look at " + PageHlp )
      SHG_BaseOK := .F.
   else
      if upper( US_FileNameOnlyExt( cDatabase ) ) != "DBF"
         msginfo( "Error open QPM Help Generator Database: " + cDataBase + HB_OsNewLine() + "Bad extension" )
         SHG_BaseOK := .F.
      endif
      if upper( right( US_FileNameOnlyName( cDatabase ) , 4 ) ) != "_SHG"
         msginfo( "Error open QPM Help Generator Database: " + cDataBase + HB_OsNewLine() + "Bad Name, not _SHG suffix into database name" )
         SHG_BaseOK := .F.
      endif
 us_log( "chequeo: " + US_FileNameOnlyPathAndName( cDatabase ) + ".dbt" , .F. )
      if file( US_FileNameOnlyPathAndName( cDatabase ) + ".dbt" )
         SetMGWaitTxt( "Converting SHG Database to DBFCDX Driver..." )
 us_log( "convert " + cDatabase, .F. )
         if !US_DBConvert( cDatabase , US_FileNameOnlyPathAndName( cDatabase ) + "_" + PUB_cSecu + ".dbf" , "DBFNTX" , "DBFCDX" )
            US_Log( "Error converting SHG database to DBFCDX Driver" )
         else
 us_log( "borro " + cDatabase, .F. )
            ferase( cDatabase )
 us_log( "borro " + US_FileNameOnlyPathAndName( cDatabase ) + ".dbt", .F. )
            ferase( US_FileNameOnlyPathAndName( cDatabase ) + ".dbt" )
 us_log( "borro " + US_FileNameOnlyPathAndName( cDatabase ) + ".ntx", .F. )
            ferase( US_FileNameOnlyPathAndName( cDatabase ) + ".ntx" )
 us_log( "rename " + US_FileNameOnlyPathAndName( cDatabase ) + "_" + PUB_cSecu + ".dbf | " + cDatabase , .F.)
            if frename( US_FileNameOnlyPathAndName( cDatabase ) + "_" + PUB_cSecu + ".dbf" , cDatabase ) < 0
               US_Log( "Error renaming SHG Database '"+ US_FileNameOnlyPathAndName( cDatabase ) + "_" + PUB_cSecu + ".dbf" + "' in Migration process, ferror: " + US_TodoStr( fError() ) )
            else
 us_log( "rename " + US_FileNameOnlyPathAndName( cDatabase ) + "_" + PUB_cSecu + ".fpt | " + US_FileNameOnlyPathAndName( cDatabase ) + ".fpt", .F. )
               if frename( US_FileNameOnlyPathAndName( cDatabase ) + "_" + PUB_cSecu + ".fpt" , US_FileNameOnlyPathAndName( cDatabase ) + ".fpt" ) < 0
                  US_Log( "Error renaming SHG Database '" + US_FileNameOnlyPathAndName( cDatabase ) + "_" + PUB_cSecu + ".fpt" + "' in Migration process, ferror: " + US_TodoStr( fError() ) )
           //  else
           //     SHG_IndexON( cDatabase )
               endif
            endif
         endif
      endif
      SetMGWaitTxt( "Packing Help Database ..." )
      DBUseArea( .T. , , cDataBase , "SHG" , DEF_DBF_EXCLUSIVE , DEF_DBF_WRITE )
      vStructure := DBStruct()
      if ascan( vStructure , {|aval| aval[1] == "SHG_NICK" } ) == 0
         DBCloseArea( "SHG" )
         US_DB_CMP( US_FileNameOnlyPathAndName( cDataBase ) , "ADD" , "SHG_NICK" , "C" , 255 , 0 )
         US_DB_CMP( US_FileNameOnlyPathAndName( cDataBase ) , "ADD" , "SHG_NICKT" , "C" , 255 , 0 )
         DBUseArea( .T. , , cDataBase , "SHG" , DEF_DBF_EXCLUSIVE , DEF_DBF_WRITE )
      endif
      PACK
  //  DBCloseArea( "SHG" )
      ferase( US_FileNameOnlyPathAndName( cDataBase ) + ".bak" )
  //  DBUseArea( .T. , , cDataBase , "SHG" , DEF_DBF_EXCLUSIVE , DEF_DBF_WRITE )
 //   DBSetIndex( US_FileNameOnlyPathAndName( SHG_Database ) )
      DbGoTop()
      SetMGWaitTxt( "Loading Topics..." )
      do while !eof()
         DO EVENTS
         REPLACE SHG_TYPET  WITH SHG_TYPE
         REPLACE SHG_TOPICT WITH SHG_TOPIC
         REPLACE SHG_NICKT  WITH SHG_NICK
         REPLACE SHG_MEMOT  WITH SHG_MEMO
         REPLACE SHG_KEYST  WITH SHG_KEYS
         DBSkip()
      enddo
      DbGoTop()
      SetMGWaitTxt( "Reindex Help Database ..." )
      SHG_IndexON( cDatabase )
      DBCloseArea( "SHG" )
//msginfo( "pos pack" )
      SetMGWaitTxt( "New Secuence Database ..." )
      SHG_NewSecuence()
//msginfo( "pos new" )
      DBUseArea( .T. , , cDataBase , "SHG" , DEF_DBF_EXCLUSIVE , DEF_DBF_WRITE )
      DBSetIndex( US_FileNameOnlyPathAndName( SHG_Database ) )
      DbGoTo( 2 )
      cAux := SHG_TYPE
      DbGoTop()
      if SHG_TYPE != "F" .or. ;
         cAux     != "W" .or. ;
         SHG_ORDER != 1 .or. ;
         SHG_TOPIC != "Global Foot"
         msgStop( "Help Database is corrupted, records UNKNOWN" )
         DBCloseArea( "SHG" )
         Return .F.
      endif
      DoMethod( "VentanaMain" , "GHlpFiles" , "DeleteAllItems" )
      bHlpMoving := .T.
      DoMethod( "VentanaMain" , "GHlpFiles" , "DisableUpdate" )
      do while !eof()
         SetMGWaitTxt( "Adding Topic " + alltrim( SHG_TOPIC ) + " to Help Grid ..." )
         DoMethod( "VentanaMain" , "GHlpFiles" , "AddItem" , { 0 , alltrim( SHG_TOPIC ) , alltrim( SHG_NICK ) , "0" , "E" } )
         GridImage( "VentanaMain" , "GHlpFiles" , GetProperty( "VentanaMain" , "GHlpFiles" , "ItemCount" ) , NCOLHLPSTATUS , "+" , if( SHG_TYPE == "B" , PUB_nGridImgHlpBook , if( SHG_TYPE == "F" , PUB_nGridImgHlpGlobalFoot , if( SHG_TYPE == "W" , PUB_nGridImgHlpWelcome , PUB_nGridImgHlpPage ) ) ) )
         DbSkip()
      enddo
      DoMethod( "VentanaMain" , "GHlpFiles" , "EnableUpdate" )
      DBCloseArea( "SHG" )
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
// INDEX ON SHG_ORDER ON ( US_FileNameOnlyPathAndName( cDataBase ) )
   INDEX ON SHG_ORDER TAG "SHG_ORDER1"
Return

Function SHG_PutDllItcc()
   Local cDllItccPath := alltrim( US_GetReg(HKEY_CLASSES_ROOT , "CLSID\{4662DAA2-D393-11D0-9A56-00C04FB68BF7}\InprocServer32" , "" ) )
//us_log( cDllItccPath )
   if cDllItccPath == "*ERROR*"
      Return cDllItccPath
   endif
   if !file( PUB_cQPM_Folder + DEF_SLASH + "hha.dll" )
      COPY FILE ( PUB_cQPM_Folder + DEF_SLASH + "us_hha.dll" ) TO ( PUB_cQPM_Folder + DEF_SLASH + "hha.dll" )
   endif
   if ( upper( cDllItccPath ) == upper( PUB_cQPM_Folder + DEF_SLASH + "US_Itcc.dll" ) )
      Return ""
   endif
   if !empty( cDllItccPath ) .and. !( upper( cDllItccPath ) == upper( PUB_cQPM_Folder + DEF_SLASH + "US_Itcc.dll" ) )
      QPM_Execute( "regsvr32" , "/s /u " + cDllItccPath , DEF_QPM_EXEC_WAIT , DEF_QPM_EXEC_MINIMIZE )
      QPM_Execute( "regsvr32" , "/s " + PUB_cQPM_Folder + DEF_SLASH + "US_Itcc.dll" , DEF_QPM_EXEC_WAIT , DEF_QPM_EXEC_MINIMIZE )
      Return cDllItccPath
   endif
   if empty( cDllItccPath )
      QPM_Execute( "regsvr32" , "/s " + PUB_cQPM_Folder + DEF_SLASH + "US_Itcc.dll" , DEF_QPM_EXEC_WAIT , DEF_QPM_EXEC_MINIMIZE )
   endif
Return ""

Function SHG_RestoreDllItcc( cDllName )
   //ferase( PUB_cQPM_Folder + DEF_SLASH + "hha.dll" )
   QPM_Execute( "regsvr32" , "/s /u " + PUB_cQPM_Folder + DEF_SLASH + "US_Itcc.dll" , DEF_QPM_EXEC_WAIT , DEF_QPM_EXEC_MINIMIZE )
   QPM_Execute( "regsvr32" , "/s " + cDllName , DEF_QPM_EXEC_WAIT , DEF_QPM_EXEC_MINIMIZE )
Return .T.

Function SHG_AddHlpKey()
   Local cAux := "" , cOldMemo
   Local cSel := oHlpRichEdit:GetSelText()
   if SHG_BaseOK
      if empty( cSel )
         cAux := InputBox( "New Key:" , "Keys for HElp" , "" )
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
      msginfo( "Help Database not selected.  Use open button for open or create help database" )
   endif
Return .T.

Function SHG_AddHlpHTML( accion )
   Local cClip , cTagAux , nCaretTxt := GetProperty( "VentanaMain" , "RichEditHlp" , "caretpos" )
   Local nDesdeRtf , nHastaRtf , vDesdeLen
   Local cMemoTxt := US_GetRichEditValue( "VentanaMain" , "RichEditHlp" , "TXT" )
   Local cMemoRtf := US_GetRichEditValue( "VentanaMain" , "RichEditHlp" , "RTF" )
   Local cMemoRtfAux := ""
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
 //  msginfo( cTagAux )
         if !empty( cTagAux )
            vDesdeLen := SHG_LinkGetPos( cMemoTxt , nCaretTxt )
      //    msginfo( vdesdelen )
      //    if len( vDesdeLen ) == 0
      //       aadd( vdesdeLen , { { nCaretTxt , 0 } } )
      //    endif
//   msginfo( vDesdeLen )
     //     nDesdeRtf := US_Rtf2MemoPos( cMemoRtf , vDesdeLen[1][1] )
 //  msginfo( nDesdeRtf )
     //     nHastaRtf := US_Rtf2MemoPos( cMemoRtf , vDesdeLen[1][1] + vDesdeLen[1][2] )
 //  msginfo( nHastaRtf )
     //     cMemoRtfAux := substr( cMemoRtf , 1 , nDesdeRtf - 1 ) + cTagAux + substr( cMemoRtf , nHastaRtf )
 //  msginfo( cMemoRtfAux )
     //     SetProperty( "VentanaMain" , "RichEditHlp" , "Value" , cMemoRtfAux )
     //     SetProperty( "VentanaMain" , "RichEditHlp" , "caretpos" , nCaretTxt )
            //
  //  msginfo( "old desde: " + str( vDesdeLen[1][1] ) )
  //  msginfo( "count 13: " + str( at( chr(13) , substr( cMemoTxt , 1 , vDesdeLen[1][1] ) ) ) )
  //  msginfo( "count 10: " + str( at( chr(10) , substr( cMemoTxt , 1 , vDesdeLen[1][1] ) ) ) )
  //  msginfo( "count: " + str( Occurs( HB_OsNewLine() , substr( cMemoTxt , 1 , vDesdeLen[1][1] ) ) ) )
        //  vDesdeLen[1][1] := vDesdeLen[1][1] - Occurs( HB_OsNewLine() , substr( cMemoTxt , 1 , vDesdeLen[1][1] ) )
  //  msginfo( "new desde: " + str( vDesdeLen[1][1] )  )
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
         CopyToClipboard( '<A href="http://qpm.sourceforge.net" target=blank>QPM Home Page</A>' )
         SHG_Send_Paste()
      case upper( accion ) == "EMAIL"
         CopyToClipboard( '<A href="mailto:qpm-users@lists.sourceforge.net">Mail to QPM_Support</A>' )
         SHG_Send_Paste()
   otherwise
      msginfo( "invalid accion into function SHG_AddHlpHTML: " + us_todostr( accion ) )
   endcase
   CopyRtfToClipboard( cClip )
Return .T.

Function SHG_LimpioRtf( cRtf )
   if at( "\sb100\sa100" , cRtf ) > 0
      cRtf := strtran( cRtf , "\sb100\sa100" , "" )
      Return .T.
   endif
Return .F.

Function SHG_Send_Copy()
   if GetProperty( "VentanaMain" , "TabFiles" , "Value" ) == nPageHlp
      oHlpRichEdit:US_EditRtfCopy()
   else
      US_Send_Copy()
   endif
Return .T.

Function SHG_Send_Cut()
   if GetProperty( "VentanaMain" , "TabFiles" , "Value" ) == nPageHlp
      oHlpRichEdit:US_EditRtfCut()
   else
      US_Send_Cut()
   endif
Return .T.

Function SHG_Send_Paste()
   RELEASE KEY CONTROL+V OF VentanaMain
   if GetProperty( "VentanaMain" , "TabFiles" , "Value" ) == nPageHlp
      oHlpRichEdit:US_EditRtfPaste()
   else
      US_Send_Paste()
   endif
   ON KEY CONTROL+V OF VentanaMain ACTION SHG_Send_Paste()
Return .T.

Function SHG_Post_Paste()
   Local cAuxMemo , nCaret
   cAuxMemo := US_GetRichEditValue( "VentanaMain" , "RichEditHlp" , "RTF" )
   if SHG_LimpioRtf( @cAuxMemo )
      nCaret := GetProperty( "VentanaMain" , "RichEditHlp" , "caretpos" )
      SetProperty( "VentanaMain" , "RichEditHlp" , "value" , cAuxMemo )
      SetProperty( "VentanaMain" , "RichEditHlp" , "caretpos" , nCaret )
   endif
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
          TITLE "Topic Descripcion" ;
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
             TOOLTIP         'Confirm Selection'
             ONCLICK         if( bReto := SHG_InputTopicOK() , DoMethod( "PanInputTopic" , "Release" ) , US_Nop() )
      END BUTTON

      DEFINE BUTTON PanInputTopicCANCEL
             ROW             93
             COL             355
             WIDTH           80
             HEIGHT          25
             CAPTION         'Cancel'
             TOOLTIP         'Cancel Selection'
             ONCLICK         ( bReto := .F. , DoMethod( "PanInputTopic" , "Release" ) )
      END BUTTON

   END WINDOW
   Center Window PanInputTopic
// US_Log( "pre activate " , .F. )
   Activate Window PanInputTopic
// US_Log( "post release " , .F. )
   cTopic := cPTopic
   cNick := cPNick
Return bReto

Function SHG_InputTopicOK()
   Local i
   cAuxTopic := PanInputTopic.TextTopic.Value
   cAuxNick  := PanInputTopic.TextNick.Value
   if !empty( cAuxNick ) .and. !FILEVALID( cAuxNick , 255 , 50 )
      msginfo( "NickName is not a valid file name of Windows" + HB_OsNewLine() + ;
               'Remember: only numbers (0-9), letters (a-z or A-Z) and not use the followed simbols: \ / : * ? " < > |')
      Return .F.
   else
      if !empty( cAuxNick )
         for i := 1 to GetProperty( "VentanaMain" , "GHlpFiles" , "Itemcount" )
            if i != GetProperty( "VentanaMain" , "GHlpFiles" , "Value" )
               if upper( cAuxNick + ".htm" ) == upper( GetProperty( "VentanaMain" , "GHlpFiles" , "cell" , i , NCOLHLPNICK ) )
                  msginfo( "Nick Name already assigned to topic: " + GetProperty( "VentanaMain" , "GHlpFiles" , "cell" , i , NCOLHLPTOPIC ) )
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
   Local cComilla := "" , cAuxString := "" , nEncontroSignoIgual := 0 , i , j , h
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
   //   msginfo( str( j ) + " >" + substr( cAuxString , j , 1 ) + "< " + cAuxString )
   //   msginfo( " "+myvNextKeys[i] + " *** " + substr( upper( cAuxString ) , j ) )
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
      //msginfo( "entro 1" )
      //                mycVar := substr( cAuxString , 1 , j - 1 )
      //                exit
      //             case at( " "+myvNextKeys[i] , substr( upper( cAuxString ) , j ) ) == 1
      //msginfo( "entro 2" )
      //                nEncontroSignoIgual := j
      //                j := j + len( myvNextKeys[i] ) + 1
      //                loop
                     case substr( cAuxString , j , 1 ) == "=" .and. nEncontroSignoIgual > 0
   //   msginfo( "entro 3" )
                        mycVar := substr( cAuxString , 1 , nEncontroSignoIgual - 1 )
                        exit
                     case substr( cAuxString , j , 1 ) == " "
  //    msginfo( "entro 4" )
                     otherwise
  //    msginfo( "entro 5" )
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
         msginfo( "Invalid type en funcion " + procname() )
   endcase
Return mycString

Function SHG_CancelChangesTopic()
   Local nRecord , cAuxMemo
   if SHG_BaseOK
      if GetProperty( "VentanaMain" , "GHlpFiles" , "Value" ) < 1
         msginfo( "Topic not selected" )
         Return .F.
      else
         nRecord  := GetProperty( "VentanaMain" , "GHlpFiles" , "Value" )
         cAuxMemo := US_GetRichEditValue( "VentanaMain" , "RichEditHlp" , "RTF" )
         if !( SHG_GetField( "SHG_TYPE"  , nRecord ) == SHG_GetField( "SHG_TYPET"  , nRecord ) ) .or. ;
            !( SHG_GetField( "SHG_TOPIC" , nRecord ) == SHG_GetField( "SHG_TOPICT" , nRecord ) ) .or. ;
            !( SHG_GetField( "SHG_NICK"  , nRecord ) == SHG_GetField( "SHG_NICKT"  , nRecord ) ) .or. ;
            !( cAuxMemo == SHG_GetField( "SHG_MEMO" , nRecord ) ) .or. ;
            !( SHG_GetField( "SHG_KEYS"  , nRecord ) == SHG_GetField( "SHG_KEYST"  , nRecord ) )
            if !MsgYesNo( "Cancel changes of topic '" + GetProperty( "VentanaMain" , "GHlpFiles" , "Cell" , GetProperty( "VentanaMain" , "GHlpFiles" , "Value" ) , NCOLHLPTOPIC ) + "' ?" )
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
            msginfo( "Topic '" + GetProperty( "VentanaMain" , "GHlpFiles" , "Cell" , GetProperty( "VentanaMain" , "GHlpFiles" , "Value" ) , NCOLHLPTOPIC ) + "' not changed from last save !!!" )
         endif
      endif
   else
      msginfo( "Help Database not selected.  Use open button for open or create help database" )
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
      '      <td><div align=center><font face="COURRIER NEW" size="2">&nbsp;</font></div>' + HB_OsNewLine() + ;
      '         <div align="center"><font face="COURRIER NEW" size="5" color="#ffffff">' + US_FileNameOnlyName( cIndexName ) + '</FONT></DIV>' + HB_OsNewLine() + ;
      '         <div align=center><font face="COURRIER NEW" size="2">&nbsp;</font></div>' + HB_OsNewLine() + ;
      '      </td>' + HB_OsNewLine() + ;
      '   </tr>' + HB_OsNewLine() + ;
      '</table>' + HB_OsNewLine() + ;
      '<br>' + HB_OsNewLine() + ;
      '<table border=1 cellpadding=0 cellspacing=0 width="100%">' + HB_OsNewLine() + ;
      '   <tr valign="center" bgcolor="white">' + HB_OsNewLine() + ;
      '      <td>' + HB_OsNewLine() + ;
      '         <div align="center"><font face="COURRIER NEW" size="2" color="#ffffff"><A href="' + cWWW + '" target=blank>' + if( at( 'HTTP://' , upper( cWWW ) ) == 1 , substr( cWWW , 8 ) , cWWW ) + '</A></FONT></DIV>' + HB_OsNewLine() + ;
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
            cTopicos := cTopicos + HB_OsNewLine() + '   <font face="COURRIER NEW" size="2">&nbsp;&nbsp;&nbsp;&nbsp;</FONT><IMG alt="Book" src="SHG_Book.bmp">'
            cTopicos := cTopicos + HB_OsNewLine() + '    </TD><TD>'
            cTopicos := cTopicos + HB_OsNewLine() + '   <font face="ARIAL" size="3"><A href="' + vTopic[i][3] + '" target=CONT><B>' + vTopic[i][2] + '</B></A></FONT><br>'
            cTopicos := cTopicos + HB_OsNewLine() + '    </TD></TR>'
         otherwise
            cTopicos := cTopicos + HB_OsNewLine() + '   <font face="COURRIER NEW" size="2">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</FONT><IMG alt="Page" src="SHG_Page.bmp">'
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
   US_FileChar26Zap( cDirSalida + DEF_SLASH + US_FileNameOnlyName( cIndexName ) + "_FrameLeft.htm" )
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
   US_FileChar26Zap( cDirSalida + DEF_SLASH + "_Index_" + cIndexName )
Return .T.

Function SHG_GenHtmlIndexJava( cIndexName , cDirSalida , vTopic , cClaves , cWWW )
   Local cLinea , i , cTopicos := "" , nLastBook := 0
   cLinea := '<html>' + HB_OsNewLine() + ;
             '<head>' + HB_OsNewLine() + ;
             '<title>' + US_FileNameOnlyName( cIndexName ) + ' Help</title>' + HB_OsNewLine() + ;
             '<link rel="StyleSheet" href="SHG_dtree.css" type="text/css" />' + HB_OsNewLine() + ;
             '<script type="text/javascript" src="SHG_dtree.js"></script>' + HB_OsNewLine() + ;
             '</head>' + HB_OsNewLine() + ;
             '<body bgcolor="#e3e6db" link="blue" vlink="blue" alink="#389e6b" >' + HB_OsNewLine() + ;
             '<table border=2 cellpadding=0 cellspacing=0 width="100%">' + HB_OsNewLine() + ;
             '   <tr valign="center" bgcolor="#003366">' + HB_OsNewLine() + ;
             '      <td><div align=center><font face="COURRIER NEW" size="2">&nbsp;</font></div>' + HB_OsNewLine() + ;
             '         <div align="center"><font face="COURRIER NEW" size="5" color="#ffffff">' + US_FileNameOnlyName( cIndexName ) + '</FONT></DIV>' + HB_OsNewLine() + ;
             '         <div align=center><font face="COURRIER NEW" size="2">&nbsp;</font></div>' + HB_OsNewLine() + ;
             '      </td>' + HB_OsNewLine() + ;
             '   </tr>' + HB_OsNewLine() + ;
             '</table>' + HB_OsNewLine() + ;
             '<br>' + HB_OsNewLine() + ;
             '<table border=1 cellpadding=0 cellspacing=0 width="100%">' + HB_OsNewLine() + ;
             '   <tr valign="center" bgcolor="white">' + HB_OsNewLine() + ;
             '      <td>' + HB_OsNewLine() + ;
             '         <div align="center"><font face="COURRIER NEW" size="2" color="#ffffff"><A href="' + cWWW + '" target=blank>' + if( at( 'HTTP://' , upper( cWWW ) ) == 1 , substr( cWWW , 8 ) , cWWW ) + '</A></FONT></DIV>' + HB_OsNewLine() + ;
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
   US_FileChar26Zap( cDirSalida + DEF_SLASH + US_FileNameOnlyName( cIndexName ) + "_FrameLeft_Java.htm" )
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
   US_FileChar26Zap( cDirSalida + DEF_SLASH + "_Index_" + US_FileNameOnlyName( cIndexName ) + "_Java." + US_FileNameOnlyExt( cIndexName ) )
Return .T.

Function SHG_StrTran( cFullName )
   Local cAux , nInx , cName := US_FileNameOnlyNameAndExt( cFullName )
   for nInx := 1 to len( cName )
      cAux := Substr( cName , nInx , 1 )
      if !IsAlpha( cAux ) .and. ;
         !IsDigit( cAux ) .and. ;
         cAux != "_" .and. ;
         cAux != "."
         cName := StrTran( cName , cAux , "_" )
      endif
   next
Return US_FileNameOnlyPath( cFullName ) + DEF_SLASH + cName

Function SHG_Commands( cIn , cPos )
   Local nInx := 0 , nFrom := 0 , nTo := 0 , nBase := 1 , cLineCommand := "" , cCommand := ""
   Local bError := .F. , cParm := "" , cParm2 := ""
   Local cLineAux := "" , cMemoInAux := "" , cMemoOutAux := ""
   Local cMemoOut := "" , cMemoIn := memoread( cIn )
   
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
               // US_Log( "Command: execute " + cParm )
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
               // cMemoInAux := memoread( cParm )
               // cMemoOutAux := ""
               // for nInx := 1 to MLCount( cMemoInAux , 254 )
               //    cLineAux := rtrim( MemoLine( cMemoInAux , 254 , nInx ) )
               //    cMemoOutAux := cMemoOutAux + if( nInx > 1 , HB_OsNewLine() , "" ) + strtran( cLineAux , " " , "&nbsp;" , 1 , US_FirstChar( cLineAux , 1 ) - 1 )
               // next
               // cMemoOutAux := strtran( strtran( cMemoOutAux , chr(13)+chr(10) , "<br>" ) , chr( 10 ) , "<br>" )
               // cMemoOut := cMemoOut + cMemoOutAux
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
      US_FileChar26Zap( cIn )
   endif
Return .T.

#endif

/* eof */
