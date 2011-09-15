#include "minigui.ch"
#include <QPM.ch>

#ifdef QPM_SHG

Function SHG_ImageGenerateList( cIn , cTopic )
/* pepe  */
   Local bLoop := .T. , vKeys , nPos , nLastPos := 1 , nCaretHtm , i , vDesdeLen , bCambio := .F.
   Local cMemoHtm := memoread( cIn ) , cStringCmd
   Local cMemoHtmUpper := upper( cMemoHtm ) , nLenGuia := len( "<IMG" )
// msginfo( cIn )
// msginfo( "entra: " + cMemoHtm )
   do while bLoop
//      msginfo( "into loop: " + cMemoHtmUpper )
      if ( nPos := at( "<IMG " , cMemoHtmUpper , nLastPos ) ) > 0
         nCaretHtm := nPos - 1
         nLastPos := nPos + nLenGuia
         vKeys := SHG_ImageParser( SHG_ImageGetString( cMemoHtm , nCaretHtm + 2 ) )
         for i:=1 to len( vKeys )
            if upper( vKeys[i][1] ) == "SRC" .and. vKeys[i][2] != NIL
               bCambio := .T.
               if ascan( vFilesToCompile , Upper( US_WSlash( vKeys[i][2] ) ) ) == 0
                  if !file( US_WSlash( vKeys[i][2] ) )
                     msgexclamation( "Warning: Image file not found" + HB_OsNewLine() + ;
                              "   File: " + US_WSlash( vKeys[i][2] ) + HB_OsNewLine() + ;
                              "  Topic: " + cTopic )
                  endif
                  aadd( vFilesToCompile , upper( US_WSlash( vKeys[i][2] ) ) )
               endif
               vDesdeLen := SHG_ImageGetPos( cMemoHtm , nCaretHtm + 1 )
     //     msginfo( vDesdeLen )
               cStringCmd := SHG_ImageVector2String( vKeys , .T. )
               cMemoHtm := substr( cMemoHtm , 1 , vDesdeLen[1][1] - 1 ) + ;
                           cStringCmd + ;
                           substr( cMemoHtm , vDesdeLen[1][1] + vDesdeLen[1][2] )
               cMemoHtmUpper := upper( cMemoHtm )
               nLastPos := vDesdeLen[1][1] + len( cStringCmd )
    //      msginfo( "$" + substr( cMemoHtmUpper , nLastPos , 3 ) + "$" )
               exit
            endif
         next
   //    msginfo( vFilesToCompile )
      else
         bLoop := .F.
      endif
   enddo
   if bCambio
      QPM_MemoWrit( cIn , cMemoHtm )
      US_FileChar26Zap( cIn )
 //     msginfo( "sale: " + cMemoHtm )
   endif
Return .T.

Function SHG_ImageGetString( cMemo , nPos )
   Local nDesde , nLen , vAux
   vAux := SHG_ImageGetPos( cMemo , nPos )
   if vAux[1][2] > 0       // != NIL
   // msginfo( substr( cMemo , vAux[1][1] , vAux[1][2] ) )
      Return substr( cMemo , vAux[1][1] , vAux[1][2] )
   endif
Return ""

Function SHG_ImageGetPos( cMemo , nPos )
   Local nAuxDesde , nDesde , nHasta , nLen , vResult , nRtfPos := nPos   // US_Rtf2MemoPos( cMemo , nPos )
   Local nLenGuia := len( "<IMG" )
// msginfo( "nrtfpos: " + us_todostr( nRtfPos ) )
   nAuxDesde := rat( ">" , substr( cMemo , 1 , nRtfPos ) ) + 1
 //msginfo( "busco en: " + substr( cMemo , nAuxDesde , ( nRtfPos - nAuxDesde + 1 ) + nLenGuia ) )
   if ( nDesde := rat( "<IMG " , upper( substr( cMemo , nAuxDesde , ( nRtfPos - nAuxDesde + 1 ) + nLenGuia ) ) ) ) == 0
 //  msginfo( "sale 1" )
      Return { { nPos , 0 } }
   endif
   nDesde := nDesde + ( nAuxDesde - 1 )
   if ( nHasta := at( ">" , upper( substr( cMemo , nRtfPos + 1 ) ) ) ) == 0
  // msginfo( "sale 2" )
      Return { { nPos , 0 } }
   endif
   nLen := ( ( nRtfPos + nHasta ) - nDesde ) + 1
// msginfo( "estring @" + substr( cMemo , nDesde , nLen ) + "@" )
Return { { nDesde , nLen } }

Function SHG_ImageVector2String( vKeys , bSupressPath )
   Local cString := "<IMG" , i , cComilla := ""                       // , vCaseName := {}
   for i := 1 to len( vKeys )
      if vKeys[i][2] != NIL
         if upper( vKeys[i][1] ) == "SRC" .or. ;
            upper( vKeys[i][1] ) == "ALT"
            cComilla := '"'
         else
            cComilla := ""
         endif
         if upper( vKeys[i][1] ) == "SRC" .and. bSupressPath
         // nCaseName := Directory( US_WSlash( vKeys[i][2] ) )
         // nCaseName[1][1] := US_FileNameOnlyNameAndExt( nCaseName[1][1] )
           // msginfo( vKeys[i][2] + HB_OsNewLine() + nCaseName[1][1] )
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

Function SHG_ImageParser( cString )
   Local bLoop := .T. , vResult := {}
   Local vKeys := { "SRC" , "ALT" , "WIDTH" , "HEIGHT" , "BORDER" , "HSPACE" , "VSPACE" , "ALIGN" }
   Local cP_SRC      // Search (la imagen)
   Local cP_ALT      // Alternative (Descripcion)
   Local cP_WIDTH
   Local cP_HEIGHT
   Local cP_BORDER
   Local cP_HSPACE
   Local cP_VSPACE
   Local cP_ALIGN
   if cString == ""
      Return vResult
   endif
   Do while bLoop
      Do case
         case at( "<IMG " , upper( cString ) ) == 1
            cString := US_WordSubStr( cString , 2 )
            cString := alltrim( strtran( cString , ">" , "" ) )
         case at( "SRC=" , upper( strtran( cString , " " , "" ) ) ) == 1
            cString := SHG_Parser( 1 , cString , "SRC" , @cP_SRC , @vKeys )
         case at( "ALT=" , upper( strtran( cString , " " , "" ) ) ) == 1
            cString := SHG_Parser( 1 , cString , "ALT" , @cP_ALT , @vKeys )
         case at( "WIDTH=" , upper( strtran( cString , " " , "" ) ) ) == 1
            cString := SHG_Parser( 2 , cString , "WIDTH" , @cP_WIDTH , @vKeys )
         case at( "HEIGHT=" , upper( strtran( cString , " " , "" ) ) ) == 1
            cString := SHG_Parser( 2 , cString , "HEIGHT" , @cP_HEIGHT , @vKeys )
         case at( "BORDER=" , upper( strtran( cString , " " , "" ) ) ) == 1
            cString := SHG_Parser( 2 , cString , "BORDER" , @cP_BORDER , @vKeys )
         case at( "HSPACE=" , upper( strtran( cString , " " , "" ) ) ) == 1
            cString := SHG_Parser( 2 , cString , "HSPACE" , @cP_HSPACE , @vKeys )
         case at( "VSPACE=" , upper( strtran( cString , " " , "" ) ) ) == 1
            cString := SHG_Parser( 2 , cString , "VSPACE" , @cP_VSPACE , @vKeys )
         case at( "ALIGN=" , upper( strtran( cString , " " , "" ) ) ) == 1
            cString := SHG_Parser( 1 , cString , "ALIGN" , @cP_ALIGN , @vKeys )
         otherwise
            bLoop := .F.
      endcase
   enddo
   aadd( vResult , { "SRC"    , cP_SRC } )
   aadd( vResult , { "ALT"    , cP_ALT } )
   aadd( vResult , { "WIDTH"  , cP_WIDTH } )
   aadd( vResult , { "HEIGHT" , cP_HEIGHT } )
   aadd( vResult , { "BORDER" , cP_BORDER } )
   aadd( vResult , { "HSPACE" , cP_HSPACE } )
   aadd( vResult , { "VSPACE" , cP_VSPACE } )
   aadd( vResult , { "ALIGN"  , cP_ALIGN } )
//msginfo( "antes de Retornar: " + us_todostr( vResult ) )
Return vResult

Function SHG_ImageAssistant( cMemo , nCaretPos )
   Private vKeys := {} , cReto := "" , PcMemo := cMemo , PnCaretPos := nCaretpos

   DEFINE WINDOW PanInputImage ;
          AT 0 , 0 ;
          WIDTH 540 ;
          HEIGHT 295 ;
          TITLE "Image Descripcion" ;
          MODAL ;
          NOSYSMENU ;
          ON INTERACTIVECLOSE US_NOP() ;
          ON INIT QPM_Wait( "SHG_ImageAssistantGetVector( PcMemo , PnCaretPos )" )

      @ 13 , 40 LABEL LabelSrc ;
         VALUE 'Image file:' ;
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
         TOOLTIP         'Select Image file'
         ONCLICK         SHG_ImageAssistantGetFile()
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
          TOOLTIP 'Border Image in pixels'

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
          TOOLTIP 'Image Align'

 //   @ 163 , 250 LABEL LabelNotFound ;
 //      VALUE '' ;
 //      WIDTH 115 ;
 //      FONT 'arial' SIZE 10 BOLD ;
 //      FONTCOLOR {255,0,0}

      DEFINE BUTTON PanInputImageOK
             ROW             203
             COL             85
             WIDTH           80
             HEIGHT          25
             CAPTION         'OK'
             TOOLTIP         'Confirm Selection'
             ONCLICK         SHG_ImageAssistantOK()
      END BUTTON
          // ONCLICK         ( cAuxName := PanInputImage.TextSrc.Value , cAuxNick := PanInputImage.TextNick.Value , if( !empty( cAuxNick ) .and. !FILEVALID( cAuxNick , 255 , 50 ) , msginfo( "NickName is not a valid file name of Windows" + HB_OsNewLine() + 'Remember: only numbers (0-9), letters (a-z or A-Z) and not use the followed simbols: \ / : * ? " < > |') , PanInputImage.Release() ) )

      @ 235 , 195 LABEL LabelReq ;
         VALUE 'RED field are required' ;
         WIDTH 150 ;
         FONT 'arial' SIZE 10 BOLD ;
         FONTCOLOR {255,0,0}

      DEFINE BUTTON PanInputImageDELETE
             ROW             210
             COL             230
             WIDTH           80
             HEIGHT          15
             CAPTION         'Delete'
             TOOLTIP         'Delete Current Image Tag'
             ONCLICK         SHG_ImageAssistantDELETE()
      END BUTTON

      DEFINE BUTTON PanInputImageCANCEL
             ROW             203
             COL             375
             WIDTH           80
             HEIGHT          25
             CAPTION         'Cancel'
             TOOLTIP         'Cancel Selection'
             ONCLICK         PanInputImage.Release()
      END BUTTON

   END WINDOW
   Center Window PanInputImage
   Activate Window PanInputImage
// msginfo( cReto )
Return cReto

Function SHG_ImageAssistantOK()
   if empty( PanInputImage.TextSrc.Value )
      msginfo( "Image file is requered" )
      return .F.
   endif
   if !file( US_WSlash( PanInputImage.TextSrc.Value ) )
      SHG_ImageAssistantDisplay()
      msginfo( "Image file not found: " + PanInputImage.TextSrc.Value )
      return .F.
   endif
   cReto := "<IMG"
   cReto := cReto + ' SRC="' + PanInputImage.TextSrc.Value + '"'
   if !empty( PanInputImage.TextAlt.Value )
      cReto := cReto + ' ALT="' + PanInputImage.TextAlt.Value + '"'
   endif
   if !empty( PanInputImage.TextWidth.Value )
      cReto := cReto + " WIDTH=" + alltrim( str( PanInputImage.TextWidth.Value ) )
   endif
   if !empty( PanInputImage.TextHeight.Value )
      cReto := cReto + " HEIGHT=" + alltrim( str( PanInputImage.TextHeight.Value ) )
   endif
   if PanInputImage.CBorder.Value > 1
      cReto := cReto + " BORDER=" + PanInputImage.CBorder.Item( PanInputImage.CBorder.Value )
   endif
   if !empty( PanInputImage.TextHSpace.Value )
      cReto := cReto + " HSPACE=" + alltrim( str( PanInputImage.TextHSpace.Value ) )
   endif
   if !empty( PanInputImage.TextVSpace.Value )
      cReto := cReto + " VSPACE=" + alltrim( str( PanInputImage.TextVSpace.Value ) )
   endif
   if PanInputImage.CAlign.Value > 1
      cReto := cReto + " ALIGN=" + PanInputImage.CAlign.Item( PanInputImage.CAlign.value )
   endif
   cReto := cReto + ">"
   PanInputImage.Release()
Return .T.

Function SHG_ImageAssistantDELETE()
   if MsgYesNo( "Confirm Delete Tag for this image ?" )
      cReto := "*DELETE*"
      PanInputImage.Release()
   endif
Return .T.

Function SHG_ImageAssistantGetVector( cMemo , nCaretPos )
   Local i
   vKeys := SHG_ImageParser( SHG_ImageGetString( cMemo , nCaretPos ) )
   if len( vKeys ) > 0
      for i := 1 to len( vKeys )
         do case
            case upper( vKeys[i][1] ) == "SRC"
               PanInputImage.TextSrc.Value := if( vKeys[i][2] != NIL , vKeys[i][2] , "" )
               SHG_ImageAssistantDisplay()
            case upper( vKeys[i][1] ) == "ALT"
               PanInputImage.TextAlt.Value := if( vKeys[i][2] != NIL , vKeys[i][2] , "" )
            case upper( vKeys[i][1] ) == "WIDTH"
               PanInputImage.TextWidth.Value := if( vKeys[i][2] != NIL , val( vKeys[i][2] ) , 0 )
            case upper( vKeys[i][1] ) == "HEIGHT"
               PanInputImage.TextHeight.Value := if( vKeys[i][2] != NIL , val( vKeys[i][2] ) , 0 )
            case upper( vKeys[i][1] ) == "BORDER"
               do case
                  case vKeys[i][2] == NIL
                     PanInputImage.CBorder.Value := 1
                  otherwise
                     PanInputImage.CBorder.Value := val( vKeys[i][2] ) + 1
               endcase
            case upper( vKeys[i][1] ) == "HSPACE"
               PanInputImage.TextHSpace.Value := if( vKeys[i][2] != NIL , val( vKeys[i][2] ) , 0 )
            case upper( vKeys[i][1] ) == "VSPACE"
               PanInputImage.TextVSpace.Value := if( vKeys[i][2] != NIL , val( vKeys[i][2] ) , 0 )
            case upper( vKeys[i][1] ) == "ALIGN"
               do case
                  case vKeys[i][2] == NIL
                     PanInputImage.CAlign.Value := 1
                  case upper( vKeys[i][2] ) == "TOP"
                     PanInputImage.CAlign.Value := 2
                  case upper( vKeys[i][2] ) == "MIDDLE"
                     PanInputImage.CAlign.Value := 3
                  case upper( vKeys[i][2] ) == "BOTTOM"
                     PanInputImage.CAlign.Value := 4
                  case upper( vKeys[i][2] ) == "LEFT"
                     PanInputImage.CAlign.Value := 5
                  case upper( vKeys[i][2] ) == "RIGHT"
                     PanInputImage.CAlign.Value := 6
                  otherwise
                     msginfo( "Invalid CAlign: " + US_TodoStr( vKeys[i][2] ) )
               endcase
            otherwise
               msginfo( "invalid key in function " + procname() + " :" + vKeys[i][1] )
         endcase
      next
   endif
return .T.

Function SHG_ImageAssistantGetFile()
Local cAux := ""
// PanInputImage.TextSrc.Value := BugGetFile( { {'Image file','*.*'} } , "Select Image File" , PanInputImage.TextSrc.Value , .F. , .T. )
// cAux := US_USlash( BugGetFile( { {'BMP Image file','*.bmp'} , {'JPEG Image file','*.jpg'} , {'PNG Image file','*.png'} , {'GIF Image file','*.gif'} } , "Select Image File" , if( empty(PanInputImage.TextSrc.Value) , SHG_LastFolderImg , US_FileNameOnlyPath( US_WSlash( PanInputImage.TextSrc.Value ) ) ) , .F. , .T. ) )
   cAux := US_USlash( BugGetFile( { {'Images (bmp, jpg, png, gif)','*.bmp;*.jpg;*.png;*.gif'} } , "Select Image File" , if( empty(PanInputImage.TextSrc.Value) , SHG_LastFolderImg , US_FileNameOnlyPath( US_WSlash( PanInputImage.TextSrc.Value ) ) ) , .F. , .T. ) )
   if !empty( cAux )
      PanInputImage.TextSrc.Value := cAux
      SHG_LastFolderImg := US_FileNameOnlyPath( US_WSlash( cAux ) )
   endif
   SHG_ImageAssistantDisplay()
Return .T.

Function SHG_ImageAssistantDisplay()
   if file( US_WSlash( PanInputImage.TextSrc.Value ) )
      if upper( US_FileNameOnlyExt( US_WSlash( PanInputImage.TextSrc.Value ) ) ) == "JPG" .or. ;
         upper( US_FileNameOnlyExt( US_WSlash( PanInputImage.TextSrc.Value ) ) ) == "JPEG" .or. ;
         upper( US_FileNameOnlyExt( US_WSlash( PanInputImage.TextSrc.Value ) ) ) == "BMP"
         PanInputImage.ImageView.picture := US_WSlash( PanInputImage.TextSrc.Value )
      else
         PanInputImage.ImageView.picture := "SHG_FileNotSupported"
      endif
  //  PanInputImage.LabelNotFound.value := ""
   else
      PanInputImage.ImageView.picture := "SHG_FileNotFound"
   // PanInputImage.LabelNotFound.value := "File not Found ->"
   endif
Return .T.

#endif
