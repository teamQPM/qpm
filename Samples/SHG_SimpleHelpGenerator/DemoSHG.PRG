#include "minigui.ch"

#define HELPNAME "SimpleHelpGenerator.chm"

Function main()

   DEFINE WINDOW SHG_Win ;
      AT 0 , 0 ;
      WIDTH 500 ;
      HEIGHT 210 ;
      TITLE "Simple Help Generator (SHG)" ;
      MAIN

      @ 08 , 35 FRAME SHG_F ;
         WIDTH 420 ;
         HEIGHT 120

      @ 13 , 40 LABEL SHG_L ;
         VALUE 'Display Help:' ;
         WIDTH 200 ;
         FONT 'arial' SIZE 10 BOLD ;
         FONTCOLOR {0,0,255}

      @ 40 , 50 RADIOGROUP SHG_R ;
         OPTIONS { 'Display Main' , 'Display Topic Number 3' , 'Display HTML page named (Nick): HelpAboutFunction' } ;
         WIDTH 400 ;
         VALUE 1 ;
         TOOLTIP "Select Display"

      DEFINE BUTTON SHG_OK
         ROW             145
         COL             35
         WIDTH           80
         HEIGHT          25
         CAPTION         'OK'
         TOOLTIP         'Confirm Selection'
         ONCLICK         MyDisplayHelp( SHG_Win.SHG_R.value )
      END BUTTON

      DEFINE BUTTON SHG_CANCEL
         ROW             145
         COL             375
         WIDTH           80
         HEIGHT          25
         CAPTION         'Exit'
         TOOLTIP         'Exit'
         ONCLICK         SHG_Win.Release()
      END BUTTON

   END WINDOW

   CENTER WINDOW SHG_Win

   ACTIVATE WINDOW SHG_Win

Return .T.

Function MyDisplayHelp( nMode )
   if !file( HELPNAME )
      msginfo( "Sorry, help file '"+HELPNAME+"' not found !!!" + HB_OsNewLine() + "Please, generate first from SHG option de QAC" )
      Return .F.
   endif
   SET HELPFILE TO HELPNAME
   do case
      case nMode == 1
         do case
            case US_MiniGuiType() == "O1"
               US_DisplayHelpTopic( _HMG_ActiveHelpFile , 1 )
            case US_MiniGuiType() == "O2"
               US_DisplayHelpTopic( _HMG_SYSDATA [ 217 ] , 1 )
            case US_MiniGuiType() == "E1"
               DISPLAY HELP MAIN
            case US_MiniGuiType() == "J1"
               US_DisplayHelpTopic( HELPNAME , 1 )
         endcase
      case nMode == 2
         do case
            case US_MiniGuiType() == "O1"
               US_DisplayHelpTopic( _HMG_ActiveHelpFile , 3 )
            case US_MiniGuiType() == "O2"
               US_DisplayHelpTopic( _HMG_SYSDATA [ 217 ] , 3 )
            case US_MiniGuiType() == "E1"
               US_DisplayHelpTopic( _HMG_ActiveHelpFile , 3 )
            case US_MiniGuiType() == "J1"
               US_DisplayHelpTopic( HELPNAME , 3 )
         endcase
      case nMode == 3
         do case
            case US_MiniGuiType() == "O1"
               US_DisplayHelpTopic( _HMG_ActiveHelpFile , "HelpAboutFunction" )
            case US_MiniGuiType() == "O2"
               US_DisplayHelpTopic( _HMG_SYSDATA [ 217 ] , "HelpAboutFunction" )
            case US_MiniGuiType() == "E1"
               US_DisplayHelpTopic( _HMG_ActiveHelpFile , "HelpAboutFunction" )
            case US_MiniGuiType() == "J1"
               US_DisplayHelpTopic( HELPNAME , "HelpAboutFunction" )
         endcase
   endcase
Return .T.

Function US_MiniGuiType()
   //msginfo( miniguiversion() )
   do case
      case at( "Extended" , MiniGuiVersion() ) > 0
         Return "E1"
      case at( "ooHG" , MiniGuiVersion() ) == 1
         Return "J1"
      case at( "Harbour MiniGUI 1" , MiniGuiVersion() ) == 1
         Return "O1"
      case at( "Harbour MiniGUI 2" , MiniGuiVersion() ) == 1
         Return "O2"
      otherwise
         msginfo( "Error detecting MiniGui type: " + MiniGuiVersion() )
   endcase
Return "?"

*==============================================================*
Procedure US_DisplayHelpTopic( cActiveHelpFile , xTopic , nMet )
*--------------------------------------------------------------*
*- Adapted from Carlos Britos ( bcd12a@yahoo.com.ar )         -*
*-              sample help Chm_Hlp.zip                       -*
*==============================================================*
   LOCAL cParam := ""
   If empty(cActiveHelpFile)
       Return
   endif
   _HMG_nTopic := xTopic
   _HMG_nMet   := nMet
   if valtype(nMet) == 'U'
       nMet := 0
   endif
   If ValType( xTopic ) == 'N'
       cParam := "-mapid " + LTrim( Str( xTopic )) +  " " + cActiveHelpFile
   ElseIf ValType( xTopic ) == 'C'
       cParam :=  '"' + cActiveHelpFile + "::/" + AllTrim( xTopic ) + '.htm"'
   ElseIf ValType( xTopic ) == 'U'
       cParam := '"' + cActiveHelpFile + '"'
   EndIf
   _Execute( 0 , "Open", "HH.exe", cParam , , 5 )
Return
