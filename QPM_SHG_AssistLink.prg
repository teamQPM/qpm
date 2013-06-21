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

Function SHG_LinkGenerateList( cIn , cTopic )
   Local bLoop := .T. , vKeys , nPos , nLastPos := 1 , nCaretHtm , i , vDesdeLen , bCambio := .F.
   Local cMemoHtm := memoread( cIn ) , cStringCmd
   Local cMemoHtmUpper := upper( cMemoHtm ) , nLenGuia := len( "<A" )
// Local vIncludeExt := { "ZIP" , "RAR" , "MP3" , "WAV" , "EXE" }
   Local vExcludeExt := { "HTM" , "HTML" }
   do while bLoop
#IFDEF __XHARBOUR__
      if ( nPos := at( "<A " , cMemoHtmUpper , nLastPos ) ) > 0
#ELSE
      if ( nPos := hb_at( "<A " , cMemoHtmUpper , nLastPos ) ) > 0
#ENDIF
         nCaretHtm := nPos - 1
         nLastPos := nPos + nLenGuia
         vKeys := SHG_LinkParser( SHG_LinkGetString( cMemoHtm , nCaretHtm + 2 ) )
         for i:=1 to len( vKeys )
            // aScan( vIncludeExt , { |x| x == US_FileNameOnlyExt( Upper( US_WSlash( vKeys[i][2] ) ) ) } ) > 0 .and. ;
            if upper( vKeys[i][1] ) == "HREF" .and. vKeys[i][2] != NIL .and. ;
               aScan( vExcludeExt , { |x| x == US_FileNameOnlyExt( Upper( US_WSlash( vKeys[i][2] ) ) ) } ) == 0 .and. ;
               US_IsLocalFile( US_WSlash( vKeys[i][2] ) )
               bCambio := .T.
               if aScan( vFilesToCompile , Upper( US_WSlash( vKeys[i][2] ) ) ) == 0
                  if !file( US_WSlash( vKeys[i][2] ) )
                     msgexclamation( "Warning: file not found" + HB_OsNewLine() + ;
                              "   File: " + US_WSlash( vKeys[i][2] ) + HB_OsNewLine() + ;
                              "  Topic: " + cTopic )
                  endif
                  aadd( vFilesToCompile , upper( US_WSlash( vKeys[i][2] ) ) )
               endif
               vDesdeLen := SHG_LinkGetPos( cMemoHtm , nCaretHtm + 1 )
               cStringCmd := SHG_LinkVector2String( vKeys , .T. )
               cMemoHtm := substr( cMemoHtm , 1 , vDesdeLen[1][1] - 1 ) + ;
                           cStringCmd + ;
                           substr( cMemoHtm , vDesdeLen[1][1] + vDesdeLen[1][2] )
               cMemoHtmUpper := upper( cMemoHtm )
               nLastPos := vDesdeLen[1][1] + len( cStringCmd )
               exit
////        else
////           if upper( vKeys[i][1] ) == "HREF" .and. vKeys[i][2] != NIL .and. ;
////              US_FileNameOnlyExt( Upper( US_WSlash( US_MayorTopic( vKeys[i][2] ) ) ) ) == "HTM" .and. ;
////              US_IsLocalFile( US_WSlash( US_MayorTopic( vKeys[i][2] ) ) )
////              bCambio := .T.
////              if !file( US_WSlash( vKeys[i][2] ) )
////                 msgexclamation( "Warning: file not found" + HB_OsNewLine() + ;
////                          "   File: " + US_WSlash( vKeys[i][2] ) + HB_OsNewLine() + ;
////                          "  Topic: " + cTopic )
////              endif
////              vDesdeLen := SHG_LinkGetPos( cMemoHtm , nCaretHtm + 1 )
////              cStringCmd := SHG_LinkVector2String( vKeys , .T. )
////              cMemoHtm := substr( cMemoHtm , 1 , vDesdeLen[1][1] - 1 ) + ;
////                          cStringCmd + ;
////                          substr( cMemoHtm , vDesdeLen[1][1] + vDesdeLen[1][2] )
////              cMemoHtmUpper := upper( cMemoHtm )
////              nLastPos := vDesdeLen[1][1] + len( cStringCmd )
////              exit
////           endif
            endif
         next
      else
         bLoop := .F.
      endif
   enddo
   if bCambio
      QPM_MemoWrit( cIn , cMemoHtm )
//      US_FileChar26Zap( cIn )
   endif
Return .T.

Function SHG_LinkGetString( cMemo , nPos )
   Local nDesde , nLen , vAux
   vAux := SHG_LinkGetPos( cMemo , nPos )
   if vAux[1][2] > 0       // != NIL
      Return substr( cMemo , vAux[1][1] , vAux[1][2] )
   endif
Return ""

Function SHG_LinkGetPos( cMemo , nPos )
   Local nAuxDesde , nDesde , nHasta , nLen , vResult , nRtfPos := nPos
   Local nLenGuia := len( "<A" )
   nAuxDesde := rat( ">" , substr( cMemo , 1 , nRtfPos ) ) + 1
   if ( nDesde := rat( "<A " , upper( substr( cMemo , nAuxDesde , ( nRtfPos - nAuxDesde + 1 ) + nLenGuia ) ) ) ) == 0
      Return { { nPos , 0 } }
   endif
   nDesde := nDesde + ( nAuxDesde - 1 )
   if ( nHasta := at( ">" , upper( substr( cMemo , nRtfPos + 1 ) ) ) ) == 0
      Return { { nPos , 0 } }
   endif
   nLen := ( ( nRtfPos + nHasta ) - nDesde ) + 1
Return { { nDesde , nLen } }

Function SHG_LinkVector2String( vKeys , bSupressPath )
   Local cString := "<A" , i , cComilla := ""                       // , vCaseName := {}
   for i := 1 to len( vKeys )
      if vKeys[i][2] != NIL
         if upper( vKeys[i][1] ) == "HREF" .or. ;
            upper( vKeys[i][1] ) == "TARGET" .or. ;
            upper( vKeys[i][1] ) == "TITLE"
            cComilla := '"'
         else
            cComilla := ""
         endif
         if upper( vKeys[i][1] ) == "HREF" .and. bSupressPath
         // nCaseName := Directory( US_WSlash( vKeys[i][2] ) )
         // nCaseName[1][1] := US_FileNameOnlyNameAndExt( nCaseName[1][1] )
         // if upper( nCaseName[1][1] ) == upper( US_FileNameOnlyNameAndExt( US_WSlash( vKeys[i][2] ) ) )
         //    vKeys[i][2] := nCaseName[1][1]
         // else
            vKeys[i][2] := US_FileNameOnlyNameAndExt( US_FileNameCase( US_WSlash( vKeys[i][2] ) ) )
         // endif
         endif
         cString := cString + " " + vKeys[i][1] + "=" + cComilla + vKeys[i][2] + cComilla
      endif
   next
   cString := cString + ">"
Return cString

Function SHG_LinkParser( cString )
   Local bLoop := .T. , vResult := {}
   Local vKeys := { "HREF" , "TARGET" , "TITLE" }
   Local cP_HREF      // Search (la imagen)
   Local cP_TARGET      // Alternative (Descripcion)
   Local cP_TITLE
   if cString == ""
      Return vResult
   endif
   Do while bLoop
      Do case
         case at( "<A " , upper( cString ) ) == 1
            cString := US_WordSubStr( cString , 2 )
            cString := alltrim( strtran( cString , ">" , "" ) )
         case at( "HREF=" , upper( strtran( cString , " " , "" ) ) ) == 1
            cString := SHG_Parser( 1 , cString , "HREF" , @cP_HREF , @vKeys )
         case at( "TARGET=" , upper( strtran( cString , " " , "" ) ) ) == 1
            cString := SHG_Parser( 1 , cString , "TARGET" , @cP_TARGET , @vKeys )
         case at( "TITLE=" , upper( strtran( cString , " " , "" ) ) ) == 1
            cString := SHG_Parser( 2 , cString , "TITLE" , @cP_TITLE , @vKeys )
         otherwise
            bLoop := .F.
      endcase
   enddo
   aadd( vResult , { "HREF"   , cP_HREF } )
   aadd( vResult , { "TARGET" , cP_TARGET } )
   aadd( vResult , { "TITLE"  , cP_TITLE } )
Return vResult

Function SHG_LinkAssistant( cMemo , nCaretPos )
   Private vKeys := {} , cReto := "" , PcMemo := cMemo , PnCaretPos := nCaretpos

   DEFINE WINDOW PanInputLink ;
          AT 0 , 0 ;
          WIDTH 540 ;
          HEIGHT 295 ;
          TITLE "Link Description" ;
          MODAL ;
          NOSYSMENU ;
          ON INTERACTIVECLOSE US_NOP() ;
          ON INIT QPM_Wait( "SHG_LinkAssistantGetVector( PcMemo , PnCaretPos )" )

      @ 13 , 40 LABEL LabelSrc ;
         VALUE 'Link file:' ;
         WIDTH 75 ;
         FONT 'arial' SIZE 10 BOLD ;
         FONTCOLOR {255,0,0}

      DEFINE TEXTBOX TextSrc
         ROW             13
         COL             132
         WIDTH           330
         VALUE           ""
      END TEXTBOX

      DEFINE BUTTON ButtonSrc
         ROW             13
         COL             470
         WIDTH           25
         HEIGHT          25
         PICTURE         'folderselect'
         TOOLTIP         'Select Link file'
         ONCLICK         SHG_LinkAssistantGetFile()
      END BUTTON

      @ 43 , 40 LABEL LabelAlt ;
         VALUE 'Description:' ;
         WIDTH 75 ;
         FONT 'arial' SIZE 10 BOLD ;
         FONTCOLOR DEF_COLORBLUE

      DEFINE TEXTBOX TextAlt
         ROW             43
         COL             132
         WIDTH           330
         VALUE           ""
      END TEXTBOX

      @ 73 , 40 LABEL LabelWidth ;
         VALUE 'Width:' ;
         WIDTH 75 ;
         FONT 'arial' SIZE 10 BOLD ;
         FONTCOLOR DEF_COLORBLUE

      DEFINE TEXTBOX TextWidth
         ROW             73
         COL             132
         WIDTH           50
         VALUE           0
         NUMERIC         .T.
      END TEXTBOX

      @ 73 , 220 LABEL LabelHeight ;
         VALUE 'Height:' ;
         WIDTH 75 ;
         FONT 'arial' SIZE 10 BOLD ;
         FONTCOLOR DEF_COLORBLUE

      DEFINE TEXTBOX TextHeight
         ROW             73
         COL             292
         WIDTH           50
         VALUE           0
         NUMERIC         .T.
      END TEXTBOX

      @ 73 , 367 FRAME FFrame ;
         WIDTH 156 ;
         HEIGHT 116

      @ 76 , 370 IMAGE ImageView ;
         PICTURE "" ;
         WIDTH  150 ;
         HEIGHT 110

      @ 103 , 40 LABEL LabelBorder ;
         VALUE 'Border:' ;
         WIDTH 75 ;
         FONT 'arial' SIZE 10 BOLD ;
         FONTCOLOR DEF_COLORBLUE

  //  DEFINE TEXTBOX TextBorder
  //     ROW             103
  //     COL             132
  //     WIDTH           50
  //     VALUE           0
  //     NUMERIC         .T.
  //  END TEXTBOX

      @ 103 , 132 COMBOBOX CBorder ;
          ITEMS { " " , "1" , "2" } ;
          VALUE 3 ;
          WIDTH 100 ;
          TOOLTIP 'Border Link in pixels'

      @ 133 , 40 LABEL LabelHSpace ;
         VALUE 'HSpace:' ;
         WIDTH 75 ;
         FONT 'arial' SIZE 10 BOLD ;
         FONTCOLOR DEF_COLORBLUE

      DEFINE TEXTBOX TextHSpace
         ROW             133
         COL             132
         WIDTH           50
         VALUE           0
         NUMERIC         .T.
      END TEXTBOX

      @ 133 , 220 LABEL LabelVSpace ;
         VALUE 'VSpace:' ;
         WIDTH 75 ;
         FONT 'arial' SIZE 10 BOLD ;
         FONTCOLOR DEF_COLORBLUE

      DEFINE TEXTBOX TextVSpace
         ROW             133
         COL             292
         WIDTH           50
         VALUE           0
         NUMERIC         .T.
      END TEXTBOX

      @ 163 , 40 LABEL LabelAlign ;
         VALUE 'Align:' ;
         WIDTH 75 ;
         FONT 'arial' SIZE 10 BOLD ;
         FONTCOLOR DEF_COLORBLUE

 //   DEFINE TEXTBOX TextAlign
 //      ROW             163
 //      COL             132
 //      WIDTH           200
 //      VALUE           ""
 //   END TEXTBOX

      @ 163 , 132 COMBOBOX CAlign ;
          ITEMS { " " , "top" , "middle" , "bottom" , "left" , "right" } ;
          VALUE 1 ;
          WIDTH 100 ;
          TOOLTIP 'Link Align'

 //   @ 163 , 250 LABEL LabelNotFound ;
 //      VALUE '' ;
 //      WIDTH 115 ;
 //      FONT 'arial' SIZE 10 BOLD ;
 //      FONTCOLOR {255,0,0}

      DEFINE BUTTON PanInputLinkOK
             ROW             203
             COL             85
             WIDTH           80
             HEIGHT          25
             CAPTION         'OK'
             TOOLTIP         'Confirm Selection'
             ONCLICK         SHG_LinkAssistantOK()
      END BUTTON
          // ONCLICK         ( cAuxName := PanInputLink.TextSrc.Value , cAuxNick := PanInputLink.TextNick.Value , if( !empty( cAuxNick ) .and. !FILEVALID( cAuxNick , 255 , 50 ) , MsgInfo( "NickName is not a valid file name of Windows" + HB_OsNewLine() + 'Remember: only numbers (0-9), letters (a-z or A-Z) and not use the followed simbols: \ / : * ? " < > |') , PanInputLink.Release() ) )

      @ 235 , 195 LABEL LabelReq ;
         VALUE 'RED field are required' ;
         WIDTH 150 ;
         FONT 'arial' SIZE 10 BOLD ;
         FONTCOLOR {255,0,0}

      DEFINE BUTTON PanInputLinkDELETE
             ROW             210
             COL             230
             WIDTH           80
             HEIGHT          15
             CAPTION         'Delete'
             TOOLTIP         'Delete Current Link Tag'
             ONCLICK         SHG_LinkAssistantDELETE()
      END BUTTON

      DEFINE BUTTON PanInputLinkCANCEL
             ROW             203
             COL             375
             WIDTH           80
             HEIGHT          25
             CAPTION         'Cancel'
             TOOLTIP         'Cancel Selection'
             ONCLICK         PanInputLink.Release()
      END BUTTON

   END WINDOW
   Center Window PanInputLink
   Activate Window PanInputLink
Return cReto

Function SHG_LinkAssistantOK()
   if empty( PanInputLink.TextSrc.Value )
      MsgInfo( "Link file is required." )
      return .F.
   endif
   if !file( US_WSlash( PanInputLink.TextSrc.Value ) )
      SHG_LinkAssistantDisplay()
      MsgInfo( "Link file not found: " + PanInputLink.TextSrc.Value )
      return .F.
   endif
   cReto := "<IMG"
   cReto := cReto + ' SRC="' + PanInputLink.TextSrc.Value + '"'
   if !empty( PanInputLink.TextAlt.Value )
      cReto := cReto + ' ALT="' + PanInputLink.TextAlt.Value + '"'
   endif
   if !empty( PanInputLink.TextWidth.Value )
      cReto := cReto + " WIDTH=" + alltrim( str( PanInputLink.TextWidth.Value ) )
   endif
   if !empty( PanInputLink.TextHeight.Value )
      cReto := cReto + " HEIGHT=" + alltrim( str( PanInputLink.TextHeight.Value ) )
   endif
   if PanInputLink.CBorder.Value > 1
      cReto := cReto + " BORDER=" + PanInputLink.CBorder.Item( PanInputLink.CBorder.Value )
   endif
   if !empty( PanInputLink.TextHSpace.Value )
      cReto := cReto + " HSPACE=" + alltrim( str( PanInputLink.TextHSpace.Value ) )
   endif
   if !empty( PanInputLink.TextVSpace.Value )
      cReto := cReto + " VSPACE=" + alltrim( str( PanInputLink.TextVSpace.Value ) )
   endif
   if PanInputLink.CAlign.Value > 1
      cReto := cReto + " ALIGN=" + PanInputLink.CAlign.Item( PanInputLink.CAlign.value )
   endif
   cReto := cReto + ">"
   PanInputLink.Release()
Return .T.

Function SHG_LinkAssistantDELETE()
   if MyMsgYesNo( "Confirm Delete Tag for this Link ?" )
      cReto := "*DELETE*"
      PanInputLink.Release()
   endif
Return .T.

Function SHG_LinkAssistantGetVector( cMemo , nCaretPos )
   Local i
   vKeys := SHG_LinkParser( SHG_LinkGetString( cMemo , nCaretPos ) )
   if len( vKeys ) > 0
      for i := 1 to len( vKeys )
         do case
            case upper( vKeys[i][1] ) == "SRC"
               PanInputLink.TextSrc.Value := if( vKeys[i][2] != NIL , vKeys[i][2] , "" )
               SHG_LinkAssistantDisplay()
            case upper( vKeys[i][1] ) == "ALT"
               PanInputLink.TextAlt.Value := if( vKeys[i][2] != NIL , vKeys[i][2] , "" )
            case upper( vKeys[i][1] ) == "WIDTH"
               PanInputLink.TextWidth.Value := if( vKeys[i][2] != NIL , val( vKeys[i][2] ) , 0 )
            case upper( vKeys[i][1] ) == "HEIGHT"
               PanInputLink.TextHeight.Value := if( vKeys[i][2] != NIL , val( vKeys[i][2] ) , 0 )
            case upper( vKeys[i][1] ) == "BORDER"
               do case
                  case vKeys[i][2] == NIL
                     PanInputLink.CBorder.Value := 1
                  otherwise
                     PanInputLink.CBorder.Value := val( vKeys[i][2] ) + 1
               endcase
            case upper( vKeys[i][1] ) == "HSPACE"
               PanInputLink.TextHSpace.Value := if( vKeys[i][2] != NIL , val( vKeys[i][2] ) , 0 )
            case upper( vKeys[i][1] ) == "VSPACE"
               PanInputLink.TextVSpace.Value := if( vKeys[i][2] != NIL , val( vKeys[i][2] ) , 0 )
            case upper( vKeys[i][1] ) == "ALIGN"
               do case
                  case vKeys[i][2] == NIL
                     PanInputLink.CAlign.Value := 1
                  case upper( vKeys[i][2] ) == "TOP"
                     PanInputLink.CAlign.Value := 2
                  case upper( vKeys[i][2] ) == "MIDDLE"
                     PanInputLink.CAlign.Value := 3
                  case upper( vKeys[i][2] ) == "BOTTOM"
                     PanInputLink.CAlign.Value := 4
                  case upper( vKeys[i][2] ) == "LEFT"
                     PanInputLink.CAlign.Value := 5
                  case upper( vKeys[i][2] ) == "RIGHT"
                     PanInputLink.CAlign.Value := 6
                  otherwise
                     MsgInfo( "Invalid CAlign: " + US_VarToStr( vKeys[i][2] ) )
               endcase
            otherwise
               MsgInfo( "Invalid key in function " + procname() + " :" + vKeys[i][1] )
         endcase
      next
   endif
return .T.

Function SHG_LinkAssistantGetFile()
Local cAux := ""
// PanInputLink.TextSrc.Value := BugGetFile( { {'Link file','*.*'} } , "Select Link File" , PanInputLink.TextSrc.Value , .F. , .T. )
   cAux := US_USlash( BugGetFile( { {'BMP Image file','*.bmp'} , {'JPEG Image file','*.jpg'} , {'PNG Image file','*.png'} , {'GIF Image file','*.gif'} } , "Select Link File" , if( empty(PanInputLink.TextSrc.Value) , SHG_LastFolderImg , US_FileNameOnlyPath( US_WSlash( PanInputLink.TextSrc.Value ) ) ) , .F. , .T. ) )
   if !empty( cAux )
      PanInputLink.TextSrc.Value := cAux
      SHG_LastFolderImg := US_FileNameOnlyPath( US_WSlash( cAux ) )
   endif
   SHG_LinkAssistantDisplay()
Return .T.

Function SHG_LinkAssistantDisplay()
   if file( US_WSlash( PanInputLink.TextSrc.Value ) )
      if upper( US_FileNameOnlyExt( US_WSlash( PanInputLink.TextSrc.Value ) ) ) == "JPG" .or. ;
         upper( US_FileNameOnlyExt( US_WSlash( PanInputLink.TextSrc.Value ) ) ) == "JPEG" .or. ;
         upper( US_FileNameOnlyExt( US_WSlash( PanInputLink.TextSrc.Value ) ) ) == "BMP"
         PanInputLink.ImageView.picture := US_WSlash( PanInputLink.TextSrc.Value )
      else
         PanInputLink.ImageView.picture := "SHG_FileNotSupported"
      endif
  //  PanInputLink.LabelNotFound.value := ""
   else
      PanInputLink.ImageView.picture := "SHG_FileNotFound"
   // PanInputLink.LabelNotFound.value := "File not Found ->"
   endif
Return .T.

Function US_MayorTopic( cFile )
   Local nAux
   if ( nAux := at( "#" , cFile ) ) > 0
      Return substr( cFile , 1 , nAux - 1 )
   endif
Return cFile

#endif

/* eof */
