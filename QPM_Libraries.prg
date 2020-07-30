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

Function QPM_IsLibrariesNamesOld( cDir, cType )
   Local bReto := .T.
   cType := Left( cType, Len( cType ) - 3 )
   do case
   case cType == DefineMiniGui1+DefineBorland+DefineHarbour
      if File( cDir+DEF_SLASH + "BIN" + DEF_SLASH + "HARBOUR.exe" ) .and. File( GetHarbourLibFolder() + DEF_SLASH + "hbrtl.lib" )
         bReto:=.F.
      endif
   case cType == DefineMiniGui3+DefineMinGW+DefineHarbour
      if File( cDir+DEF_SLASH + "BIN" + DEF_SLASH + "HARBOUR.exe" ) .and. File( GetHarbourLibFolder() + DEF_SLASH + "libhbrtl.a" )
         bReto:=.F.
      endif
   case cType == DefineExtended1+DefineBorland+DefineHarbour
      if File( cDir+DEF_SLASH + "BIN" + DEF_SLASH + "HARBOUR.exe" ) .and. File( GetHarbourLibFolder() + DEF_SLASH + "hbrtl.lib" )
         bReto:=.F.
      endif
   case cType == DefineExtended1+DefineMinGW+DefineHarbour
      if File( cDir+DEF_SLASH + "BIN" + DEF_SLASH + "HARBOUR.exe" ) .and. File( GetHarbourLibFolder() + DEF_SLASH + "libhbrtl.a" )
         bReto:=.F.
      endif
   case cType == DefineOohg3+DefineBorland+DefineHarbour
      if File( cDir+DEF_SLASH + "BIN" + DEF_SLASH + "HARBOUR.exe" ) .and. File( GetHarbourLibFolder() + DEF_SLASH + "hbrtl.lib" )
         bReto:=.F.
      endif
   case cType == DefineOohg3+DefineMinGW+DefineHarbour
      if File( cDir+DEF_SLASH + "BIN" + DEF_SLASH + "HARBOUR.exe" ) .and. File( GetHarbourLibFolder() + DEF_SLASH + "libhbrtl.a" )
         bReto:=.F.
      endif
   case cType == DefineOohg3+DefinePelles+DefineHarbour
      if File( cDir+DEF_SLASH + "BIN" + DEF_SLASH + "HARBOUR.exe" ) .and. File( GetHarbourLibFolder() + DEF_SLASH + "hbrtl.lib" )
         bReto:=.F.
      endif
   endcase
Return bReto

FUNCTION QPM_CargoLibraries()
   LOCAL bOldNamesLib := QPM_IsLibrariesNamesOld( US_ShortName( GetHarbourFolder() ), GetSuffix() )
   LOCAL cPre, cExt, cFlavor := GetSuffix()

   DO CASE

   CASE cFlavor == ( DefineMiniGui1 + DefineBorland + DefineHarbour + Define32bits )
      // 1 - HMG 1.x + BCC + Harbour
      cPre := ""
      cExt := ".lib"
      vLibsDefault := {}

      if Prj_Check_Console
      if PUB_bDebugActive
      aadd( vLibsDefault,                                           cPre+'gtwin'+cExt )
      aadd( vLibsDefault, if( bOldNamesLib, cPre+'debug'+cExt,      cPre+'hbdebug'+cExt ) )
      else
      aadd( vLibsDefault,                                           cPre+'gtwin'+cExt )
      endif
      else
      if PUB_bDebugActive
      aadd( vLibsDefault,                                           cPre+'gtgui'+cExt )
      aadd( vLibsDefault,                                           cPre+'gtwin'+cExt )
      aadd( vLibsDefault, if( bOldNamesLib, cPre+'debug'+cExt,      cPre+'debug'+cExt ) )
      else
      aadd( vLibsDefault,                                           cPre+'gtgui'+cExt )
      aadd( vLibsDefault,                                           cPre+'gtwin'+cExt )
      endif
      endif

      if Prj_Check_MT
      aadd( vLibsDefault,                                           cPre+'cw32mt'+cExt )
      else
      aadd( vLibsDefault,                                           cPre+'cw32'+cExt )
      endif
      aadd( vLibsDefault,                                           cPre+'comctl32'+cExt )
      aadd( vLibsDefault,                                           cPre+'comdlg32'+cExt )
      aadd( vLibsDefault,                                           cPre+'gdi32'+cExt )
      aadd( vLibsDefault,                                           cPre+'import32'+cExt )
      aadd( vLibsDefault,                                           cPre+'iphlpapi'+cExt )
      aadd( vLibsDefault,                                           cPre+'mapi32'+cExt )
      aadd( vLibsDefault,                                           cPre+'mpr'+cExt )
      aadd( vLibsDefault,                                           cPre+'msimg32'+cExt )
      aadd( vLibsDefault,                                           cPre+'ole32'+cExt )
      aadd( vLibsDefault,                                           cPre+'oleaut32'+cExt )
      aadd( vLibsDefault,                                           cPre+'shell32'+cExt )
      aadd( vLibsDefault,                                           cPre+'user32'+cExt )
      aadd( vLibsDefault,                                           cPre+'uuid'+cExt )
      aadd( vLibsDefault,                                           cPre+'vfw32'+cExt )
      aadd( vLibsDefault,                                           cPre+'winmm'+cExt )
      aadd( vLibsDefault,                                           cPre+'winspool'+cExt )
      aadd( vLibsDefault,                                           cPre+'ws2_32'+cExt )
      aadd( vLibsDefault,                                           cPre+'wsock32'+cExt )

      aadd( vLibsDefault,                                           cPre+'ace32'+cExt )
      aadd( vLibsDefault,                                           cPre+'ct'+cExt )
      aadd( vLibsDefault,                                           cPre+'dll'+cExt )
      aadd( vLibsDefault, if( bOldNamesLib, cPre+'common'+cExt,     cPre+'hbcommon'+cExt ) )
      aadd( vLibsDefault, if( bOldNamesLib, cPre+'codepage'+cExt,   cPre+'hbcpage'+cExt ) )
      aadd( vLibsDefault,                                           cPre+'hbhpdf'+cExt )
      aadd( vLibsDefault, if( bOldNamesLib, cPre+'hsx'+cExt,        cPre+'hbhsx'+cExt ) )
      aadd( vLibsDefault, if( bOldNamesLib, cPre+'lang'+cExt,       cPre+'hblang'+cExt ) )
      aadd( vLibsDefault, if( bOldNamesLib, cPre+'macro'+cExt,      cPre+'hbmacro'+cExt ) )
      aadd( vLibsDefault,                                           cPre+'hbole'+cExt )
      aadd( vLibsDefault, if( bOldNamesLib, cPre+'pp'+cExt,         cPre+'hbpp'+cExt ) )
      aadd( vLibsDefault,                                           cPre+'hbprinter'+cExt )
      aadd( vLibsDefault, if( bOldNamesLib, cPre+'rdd'+cExt,        cPre+'hbrdd'+cExt ) )
      aadd( vLibsDefault, if( bOldNamesLib, cPre+'rtl'+cExt,        cPre+'hbrtl'+cExt ) )
      aadd( vLibsDefault, if( bOldNamesLib, cPre+'hbsix'+cExt,      cPre+'hbsix'+cExt ) )
      if Prj_Check_MT
      aadd( vLibsDefault, if( bOldNamesLib, cPre+'vmmt'+cExt,       cPre+'hbvmmt'+cExt ) )
      else
      aadd( vLibsDefault, if( bOldNamesLib, cPre+'vm'+cExt,         cPre+'hbvm'+cExt ) )
      endif
      aadd( vLibsDefault,                                           cPre+'hbzebra'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbzip'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbziparc'+cExt )
      aadd( vLibsDefault, if( bOldNamesLib, cPre+'ziparchive'+cExt, cPre+'hbziparch'+cExt ) )
      aadd( vLibsDefault,                                           cPre+'hpdf'+cExt )
      aadd( vLibsDefault,                                           cPre+'libct'+cExt )
      aadd( vLibsDefault,                                           cPre+'libharu'+cExt )
      aadd( vLibsDefault,                                           cPre+'libhpdf'+cExt )
      aadd( vLibsDefault,                                           cPre+'libmisc'+cExt )
      aadd( vLibsDefault,                                           cPre+'libmysql'+cExt )
      aadd( vLibsDefault,                                           cPre+'libpng'+cExt )
      aadd( vLibsDefault,                                           cPre+'miniprint'+cExt )
      aadd( vLibsDefault,                                           cPre+'mysql'+cExt )
      aadd( vLibsDefault,                                           cPre+'pcrepos'+cExt )
      aadd( vLibsDefault,                                           cPre+'png'+cExt )
      aadd( vLibsDefault,                                           cPre+'rddads'+cExt )
      aadd( vLibsDefault, if( bOldNamesLib, cPre+'dbfcdx'+cExt,     cPre+'rddcdx'+cExt ) )
      aadd( vLibsDefault, if( bOldNamesLib, cPre+'dbfdbt'+cExt,     cPre+'rdddbt'+cExt ) )
      aadd( vLibsDefault, if( bOldNamesLib, cPre+'dbffpt'+cExt,     cPre+'rddfpt'+cExt ) )
      aadd( vLibsDefault, if( bOldNamesLib, cPre+'dbfntx'+cExt,     cPre+'rddntx'+cExt ) )
      aadd( vLibsDefault,                                           cPre+'socket'+cExt )
      aadd( vLibsDefault,                                           cPre+'tip'+cExt )
      aadd( vLibsDefault,                                           cPre+'zlib1'+cExt )

   CASE cFlavor == ( DefineMiniGui1 + DefineBorland + DefineXHarbour + Define32bits )
      // 2 - HMG 1.x + BCC + xHarbour
      cPre := ""
      cExt := ".lib"
      vLibsDefault := {}

      if Prj_Check_Console
      if PUB_bDebugActive
      aadd( vLibsDefault,                                           cPre+'gtwin'+cExt )
      aadd( vLibsDefault,                                           cPre+'debug'+cExt )
      else
      aadd( vLibsDefault,                                           cPre+'gtwin'+cExt )
      endif
      else
      if PUB_bDebugActive
      aadd( vLibsDefault,                                           cPre+'gtgui'+cExt )
      aadd( vLibsDefault,                                           cPre+'gtwin'+cExt )
      aadd( vLibsDefault,                                           cPre+'debug'+cExt )
      else
      aadd( vLibsDefault,                                           cPre+'gtgui'+cExt )
      aadd( vLibsDefault,                                           cPre+'gtwin'+cExt )
      endif
      endif

      if Prj_Check_MT
      aadd( vLibsDefault,                                           cPre+'cw32mt'+cExt )
      else
      aadd( vLibsDefault,                                           cPre+'cw32'+cExt )
      endif
      aadd( vLibsDefault,                                           cPre+'comctl32'+cExt )
      aadd( vLibsDefault,                                           cPre+'comdlg32'+cExt )
      aadd( vLibsDefault,                                           cPre+'gdi32'+cExt )
      aadd( vLibsDefault,                                           cPre+'import32'+cExt )
      aadd( vLibsDefault,                                           cPre+'iphlpapi'+cExt )
      aadd( vLibsDefault,                                           cPre+'mapi32'+cExt )
      aadd( vLibsDefault,                                           cPre+'mpr'+cExt )
      aadd( vLibsDefault,                                           cPre+'msimg32'+cExt )
      aadd( vLibsDefault,                                           cPre+'ole32'+cExt )
      aadd( vLibsDefault,                                           cPre+'oleaut32'+cExt )
      aadd( vLibsDefault,                                           cPre+'shell32'+cExt )
      aadd( vLibsDefault,                                           cPre+'user32'+cExt )
      aadd( vLibsDefault,                                           cPre+'uuid'+cExt )
      aadd( vLibsDefault,                                           cPre+'vfw32'+cExt )
      aadd( vLibsDefault,                                           cPre+'winmm'+cExt )
      aadd( vLibsDefault,                                           cPre+'winspool'+cExt )
      aadd( vLibsDefault,                                           cPre+'ws2_32'+cExt )
      aadd( vLibsDefault,                                           cPre+'wsock32'+cExt )

      aadd( vLibsDefault,                                           cPre+'ace32'+cExt )
      aadd( vLibsDefault,                                           cPre+'codepage'+cExt )
      aadd( vLibsDefault,                                           cPre+'common'+cExt )
      aadd( vLibsDefault,                                           cPre+'ct'+cExt )
      aadd( vLibsDefault,                                           cPre+'dbfcdx'+cExt )
      aadd( vLibsDefault,                                           cPre+'dbfdbt'+cExt )
      aadd( vLibsDefault,                                           cPre+'dbffpt'+cExt )
      aadd( vLibsDefault,                                           cPre+'dbfntx'+cExt )
      aadd( vLibsDefault,                                           cPre+'dll'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbhpdf'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbole'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbprinter'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbsix'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbzebra'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbzip'+cExt )
      aadd( vLibsDefault,                                           cPre+'hpdf'+cExt )
      aadd( vLibsDefault,                                           cPre+'hsx'+cExt )
      aadd( vLibsDefault,                                           cPre+'lang'+cExt )
      aadd( vLibsDefault,                                           cPre+'libct'+cExt )
      aadd( vLibsDefault,                                           cPre+'libharu'+cExt )
      aadd( vLibsDefault,                                           cPre+'libhpdf'+cExt )
      aadd( vLibsDefault,                                           cPre+'libmisc'+cExt )
      aadd( vLibsDefault,                                           cPre+'libmysql'+cExt )
      aadd( vLibsDefault,                                           cPre+'libpng'+cExt )
      aadd( vLibsDefault,                                           cPre+'macro'+cExt )
      aadd( vLibsDefault,                                           cPre+'miniprint'+cExt )
      aadd( vLibsDefault,                                           cPre+'mysql'+cExt )
      aadd( vLibsDefault,                                           cPre+'pcrepos'+cExt )
      aadd( vLibsDefault,                                           cPre+'png'+cExt )
      aadd( vLibsDefault,                                           cPre+'pp'+cExt )
      aadd( vLibsDefault,                                           cPre+'rdd'+cExt )
      aadd( vLibsDefault,                                           cPre+'rddads'+cExt )
      aadd( vLibsDefault,                                           cPre+'rtl'+cExt )
      aadd( vLibsDefault,                                           cPre+'socket'+cExt )
      aadd( vLibsDefault,                                           cPre+'tip'+cExt )
      if Prj_Check_MT
      aadd( vLibsDefault,                                           cPre+'vmmt'+cExt )
      else
      aadd( vLibsDefault,                                           cPre+'vm'+cExt )
      endif
      aadd( vLibsDefault,                                           cPre+'zlib'+cExt )
      aadd( vLibsDefault,                                           cPre+'zlib1'+cExt )

   CASE cFlavor == ( DefineMiniGui3 + DefineMinGW + DefineHarbour + Define32bits )
      // 3 - HMG 3.x + MinGW + Harbour, 32 bits
      cPre := "lib"
      cExt := ".a"
      vLibsDefault := {}

      if Prj_Check_Console
      if PUB_bDebugActive
      aadd( vLibsDefault,                                           cPre+'gtwin'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbdebug'+cExt )
      else
      aadd( vLibsDefault,                                           cPre+'gtwin'+cExt )
      endif
      else
      if PUB_bDebugActive
      aadd( vLibsDefault,                                           cPre+'gtgui'+cExt )
      aadd( vLibsDefault,                                           cPre+'debugger'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbdebug'+cExt )
      else
      aadd( vLibsDefault,                                           cPre+'gtgui'+cExt )
      aadd( vLibsDefault,                                           cPre+'gtwin'+cExt )
      endif
      endif

      aadd( vLibsDefault,                                           cPre+'comctl32'+cExt )
      aadd( vLibsDefault,                                           cPre+'comdlg32'+cExt )
      aadd( vLibsDefault,                                           cPre+'gdi32'+cExt )
      aadd( vLibsDefault,                                           cPre+'iphlpapi'+cExt )
      aadd( vLibsDefault,                                           cPre+'mapi32'+cExt )
      aadd( vLibsDefault,                                           cPre+'mpr'+cExt )
      aadd( vLibsDefault,                                           cPre+'msimg32'+cExt )
      aadd( vLibsDefault,                                           cPre+'ole32'+cExt )
      aadd( vLibsDefault,                                           cPre+'oleaut32'+cExt )
      aadd( vLibsDefault,                                           cPre+'shell32'+cExt )
      aadd( vLibsDefault,                                           cPre+'user32'+cExt )
      aadd( vLibsDefault,                                           cPre+'uuid'+cExt )
      aadd( vLibsDefault,                                           cPre+'vfw32'+cExt )
      aadd( vLibsDefault,                                           cPre+'winmm'+cExt )
      aadd( vLibsDefault,                                           cPre+'winspool'+cExt )
      aadd( vLibsDefault,                                           cPre+'ws2_32'+cExt )
      aadd( vLibsDefault,                                           cPre+'wsock32'+cExt )

      aadd( vLibsDefault,                                           cPre+'ace32'+cExt )
      aadd( vLibsDefault,                                           cPre+'crypt'+cExt )
      aadd( vLibsDefault,                                           cPre+'dll'+cExt )
      aadd( vLibsDefault,                                           cPre+'edit'+cExt )
      aadd( vLibsDefault,                                           cPre+'editex'+cExt )
      aadd( vLibsDefault,                                           cPre+'graph'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbapollo'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbbmcdx'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbbtree'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbclipsm'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbcommon'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbcpage'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbcplr'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbct'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbcurl'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbfbird'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbgd'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbhpdf'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbhsx'+cExt )
      aadd( vLibsDefault,                                           cPre+'hblang'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbmacro'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbmainstd'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbmisc'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbmzip'+cExt )
/*    aadd( vLibsDefault,                                           cPre+'hbnulsys'+cExt )         This generates "multiple definition" error */
      aadd( vLibsDefault,                                           cPre+'hbole'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbpcre'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbpcre2'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbpp'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbprinter'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbrdd'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbrtl'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbsix'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbsqlit3'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbusrrdd'+cExt )
      if Prj_Check_MT
      aadd( vLibsDefault,                                           cPre+'hbvmmt'+cExt )
      else
      aadd( vLibsDefault,                                           cPre+'hbvm'+cExt )
      endif
      aadd( vLibsDefault,                                           cPre+'hbw32'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbxml'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbzebra'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbziparc'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbziparch'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbzlib'+cExt )
      aadd( vLibsDefault,                                           cPre+'hpdf'+cExt )
      aadd( vLibsDefault,                                           cPre+'ini'+cExt )
      aadd( vLibsDefault,                                           cPre+'libharu'+cExt )
      aadd( vLibsDefault,                                           cPre+'libhpdf'+cExt )
      aadd( vLibsDefault,                                           cPre+'libpng'+cExt )
      aadd( vLibsDefault,                                           cPre+'miniprint'+cExt )
      aadd( vLibsDefault,                                           cPre+'minizip'+cExt )
      aadd( vLibsDefault,                                           cPre+'mysql'+cExt )
      aadd( vLibsDefault,                                           cPre+'mysqldll'+cExt )
      aadd( vLibsDefault,                                           cPre+'pcrepos'+cExt )
      aadd( vLibsDefault,                                           cPre+'png'+cExt )
      aadd( vLibsDefault,                                           cPre+'rddads'+cExt )
      aadd( vLibsDefault,                                           cPre+'rddcdx'+cExt )
      aadd( vLibsDefault,                                           cPre+'rdddbt'+cExt )
      aadd( vLibsDefault,                                           cPre+'rddfpt'+cExt )
      aadd( vLibsDefault,                                           cPre+'rddntx'+cExt )
      aadd( vLibsDefault,                                           cPre+'registry'+cExt )
      aadd( vLibsDefault,                                           cPre+'report'+cExt )
      aadd( vLibsDefault,                                           cPre+'socket'+cExt )
      aadd( vLibsDefault,                                           cPre+'sqlite3'+cExt )
      aadd( vLibsDefault,                                           cPre+'stdc++'+cExt )
      aadd( vLibsDefault,                                           cPre+'tip'+cExt )
      aadd( vLibsDefault,                                           cPre+'xhb'+cExt )              // must come after haru
      aadd( vLibsDefault,                                           cPre+'hbwin'+cExt )            // must come after haru

   CASE cFlavor == ( DefineMiniGui3 + DefineMinGW + DefineHarbour + Define64bits )
      // 4 - HMG 3.x + MinGW + Harbour, 64 bits
      cPre := "lib"
      cExt := ".a"
      vLibsDefault := {}

      if Prj_Check_Console
      if PUB_bDebugActive
      aadd( vLibsDefault,                                           cPre+'gtwin'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbdebug'+cExt )
      else
      aadd( vLibsDefault,                                           cPre+'gtwin'+cExt )
      endif
      else
      if PUB_bDebugActive
      aadd( vLibsDefault,                                           cPre+'gtgui'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbdebug'+cExt )
      else
      aadd( vLibsDefault,                                           cPre+'gtgui'+cExt )
      aadd( vLibsDefault,                                           cPre+'gtwin'+cExt )
      endif
      endif

      aadd( vLibsDefault,                                           cPre+'comctl32'+cExt )
      aadd( vLibsDefault,                                           cPre+'comdlg32'+cExt )
      aadd( vLibsDefault,                                           cPre+'gdi32'+cExt )
      aadd( vLibsDefault,                                           cPre+'iphlpapi'+cExt )
      aadd( vLibsDefault,                                           cPre+'mapi32'+cExt )
      aadd( vLibsDefault,                                           cPre+'mpr'+cExt )
      aadd( vLibsDefault,                                           cPre+'msimg32'+cExt )
      aadd( vLibsDefault,                                           cPre+'ole32'+cExt )
      aadd( vLibsDefault,                                           cPre+'oleaut32'+cExt )
      aadd( vLibsDefault,                                           cPre+'shell32'+cExt )
      aadd( vLibsDefault,                                           cPre+'user32'+cExt )
      aadd( vLibsDefault,                                           cPre+'uuid'+cExt )
      aadd( vLibsDefault,                                           cPre+'vfw32'+cExt )
      aadd( vLibsDefault,                                           cPre+'winmm'+cExt )
      aadd( vLibsDefault,                                           cPre+'winspool'+cExt )
      aadd( vLibsDefault,                                           cPre+'ws2_32'+cExt )
      aadd( vLibsDefault,                                           cPre+'wsock32'+cExt )

      aadd( vLibsDefault,                                           cPre+'ace32'+cExt )
      aadd( vLibsDefault,                                           cPre+'crypt'+cExt )
      aadd( vLibsDefault,                                           cPre+'dll'+cExt )
      aadd( vLibsDefault,                                           cPre+'edit'+cExt )
      aadd( vLibsDefault,                                           cPre+'editex'+cExt )
      aadd( vLibsDefault,                                           cPre+'graph'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbapollo'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbbmcdx'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbbtree'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbclipsm'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbcommon'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbcpage'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbcplr'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbct'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbcurl'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbfbird'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbgd'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbhpdf'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbhsx'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbmacro'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbmainstd'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbmemio'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbmisc'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbmysql'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbmzip'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbnetio'+cExt )
/*    aadd( vLibsDefault,                                           cPre+'hbnulsys'+cExt )         This generates "multiple definition" error */
      aadd( vLibsDefault,                                           cPre+'hbole'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbpcre'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbpcre2'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbpp'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbprinter'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbrdd'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbrtl'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbsix'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbsqlit3'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbusrrdd'+cExt )
      if Prj_Check_MT
      aadd( vLibsDefault,                                           cPre+'hbvmmt'+cExt )
      else
      aadd( vLibsDefault,                                           cPre+'hbvm'+cExt )
      endif
      aadd( vLibsDefault,                                           cPre+'hbvpdf'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbw32'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbxml'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbzebra'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbziparc'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbzlib'+cExt )
      aadd( vLibsDefault,                                           cPre+'hfcl'+cExt )
      aadd( vLibsDefault,                                           cPre+'hpdf'+cExt )
      aadd( vLibsDefault,                                           cPre+'ini'+cExt )
      aadd( vLibsDefault,                                           cPre+'libharu'+cExt )
      aadd( vLibsDefault,                                           cPre+'libhpdf'+cExt )
      aadd( vLibsDefault,                                           cPre+'libpng'+cExt )
      aadd( vLibsDefault,                                           cPre+'miniprint'+cExt )
      aadd( vLibsDefault,                                           cPre+'minizip'+cExt )
      aadd( vLibsDefault,                                           cPre+'mysql'+cExt )
      aadd( vLibsDefault,                                           cPre+'mysqldll'+cExt )
      aadd( vLibsDefault,                                           cPre+'pcrepos'+cExt )
      aadd( vLibsDefault,                                           cPre+'png'+cExt )
      aadd( vLibsDefault,                                           cPre+'rddads'+cExt )
      aadd( vLibsDefault,                                           cPre+'rddcdx'+cExt )
      aadd( vLibsDefault,                                           cPre+'rdddbt'+cExt )
      aadd( vLibsDefault,                                           cPre+'rddfpt'+cExt )
      aadd( vLibsDefault,                                           cPre+'rddntx'+cExt )
      aadd( vLibsDefault,                                           cPre+'registry'+cExt )
      aadd( vLibsDefault,                                           cPre+'report'+cExt )
      aadd( vLibsDefault,                                           cPre+'socket'+cExt )
      aadd( vLibsDefault,                                           cPre+'sqlite3'+cExt )
      aadd( vLibsDefault,                                           cPre+'stdc++'+cExt )
      aadd( vLibsDefault,                                           cPre+'tip'+cExt )
      aadd( vLibsDefault,                                           cPre+'xhb'+cExt )              // must come after haru, hpdf, libharu and libhpdf
      aadd( vLibsDefault,                                           cPre+'hbwin'+cExt )            // must come after haru, hpdf, libharu and libhpdf
      aadd( vLibsDefault,                                           cPre+'hblang'+cExt )           // must come last

   CASE cFlavor == ( DefineExtended1 + DefineBorland + DefineHarbour + Define32bits )
      // 5 - Extended + BCC32 + Harbour
      cPre := ""
      cExt := ".lib"
      vLibsDefault := {}

      if Prj_Check_Console
      if PUB_bDebugActive
      aadd( vLibsDefault,                                           cPre+'gtwin'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbdebug'+cExt )
      else
      aadd( vLibsDefault,                                           cPre+'gtwin'+cExt )
      endif
      else
      if PUB_bDebugActive
      aadd( vLibsDefault,                                           cPre+'gtgui'+cExt )
      aadd( vLibsDefault,                                           cPre+'gtwin'+cExt )
      aadd( vLibsDefault,                                           cPre+'debugger'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbdebug'+cExt )
      else
      aadd( vLibsDefault,                                           cPre+'gtgui'+cExt )
      aadd( vLibsDefault,                                           cPre+'gtwin'+cExt )
      endif
      endif

      if Prj_Check_MT
      aadd( vLibsDefault,                                           cPre+'cw32mt'+cExt )
      else
      aadd( vLibsDefault,                                           cPre+'cw32'+cExt )
      endif
      aadd( vLibsDefault,                                           cPre+'comctl32'+cExt )
      aadd( vLibsDefault,                                           cPre+'comdlg32'+cExt )
      aadd( vLibsDefault,                                           cPre+'gdi32'+cExt )
      aadd( vLibsDefault,                                           cPre+'import32'+cExt )
      aadd( vLibsDefault,                                           cPre+'iphlpapi'+cExt )
      aadd( vLibsDefault,                                           cPre+'mapi32'+cExt )
      aadd( vLibsDefault,                                           cPre+'mpr'+cExt )
      aadd( vLibsDefault,                                           cPre+'msimg32'+cExt )
      aadd( vLibsDefault,                                           cPre+'ole32'+cExt )
      aadd( vLibsDefault,                                           cPre+'oleaut32'+cExt )
      aadd( vLibsDefault,                                           cPre+'shell32'+cExt )
      aadd( vLibsDefault,                                           cPre+'user32'+cExt )
      aadd( vLibsDefault,                                           cPre+'uuid'+cExt )
      aadd( vLibsDefault,                                           cPre+'vfw32'+cExt )
      aadd( vLibsDefault,                                           cPre+'winmm'+cExt )
      aadd( vLibsDefault,                                           cPre+'winspool'+cExt )
      aadd( vLibsDefault,                                           cPre+'ws2_32'+cExt )
      aadd( vLibsDefault,                                           cPre+'wsock32'+cExt )

      aadd( vLibsDefault,                                           cPre+'ace32'+cExt )
      aadd( vLibsDefault,                                           cPre+'adordd'+cExt )
      aadd( vLibsDefault,                                           cPre+'bostaurus'+cExt )
      aadd( vLibsDefault,                                           cPre+'calldll'+cExt )
      aadd( vLibsDefault,                                           cPre+'cputype'+cExt )
      aadd( vLibsDefault,                                           cPre+'dll'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbaes'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbcomm'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbcommon'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbcpage'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbct'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbhpdf'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbhsx'+cExt )
      aadd( vLibsDefault,                                           cPre+'hblang'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbmacro'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbmemio'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbmisc'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbmysql'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbmzip'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbodbc'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbole'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbpcre'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbpcre2'+cExt )
      aadd( vLibsDefault,                                           cPre+'hpdf'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbpgsql'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbpp'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbprinter'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbrdd'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbrtl'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbsix'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbsqldd'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbsqlit3'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbtip'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbunrar'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbusrrdd'+cExt )
      if Prj_Check_MT
      aadd( vLibsDefault,                                           cPre+'hbvmmt'+cExt )
      else
      aadd( vLibsDefault,                                           cPre+'hbvm'+cExt )
      endif
      aadd( vLibsDefault,                                           cPre+'hbvpdf'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbxml'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbzebra'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbziparc'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbzlib'+cExt )
      aadd( vLibsDefault,                                           cPre+'hmg_hpdf'+cExt )
      aadd( vLibsDefault,                                           cPre+'hmg_qhtm'+cExt )
      aadd( vLibsDefault,                                           cPre+'iphlpapi'+cExt )
      aadd( vLibsDefault,                                           cPre+'libharu'+cExt )
      aadd( vLibsDefault,                                           cPre+'libhpdf'+cExt )
      aadd( vLibsDefault,                                           cPre+'libmysql'+cExt )
      aadd( vLibsDefault,                                           cPre+'libpng'+cExt )
      aadd( vLibsDefault,                                           cPre+'libpq'+cExt )
      aadd( vLibsDefault,                                           cPre+'miniprint'+cExt )
      aadd( vLibsDefault,                                           cPre+'minizip'+cExt )
      aadd( vLibsDefault,                                           cPre+'odbc32'+cExt )
      aadd( vLibsDefault,                                           cPre+'png'+cExt )
      aadd( vLibsDefault,                                           cPre+'propgrid'+cExt )
      aadd( vLibsDefault,                                           cPre+'propsheet'+cExt )
      aadd( vLibsDefault,                                           cPre+'rddads'+cExt )
      aadd( vLibsDefault,                                           cPre+'rddcdx'+cExt )
      aadd( vLibsDefault,                                           cPre+'rddfpt'+cExt )
      aadd( vLibsDefault,                                           cPre+'rddntx'+cExt )
      aadd( vLibsDefault,                                           cPre+'socket'+cExt )
      aadd( vLibsDefault,                                           cPre+'sqlite3facade'+cExt )
      aadd( vLibsDefault,                                           cPre+'tbn'+cExt )
      aadd( vLibsDefault,                                           cPre+'tmsagent'+cExt )
      aadd( vLibsDefault,                                           cPre+'tsbrowse'+cExt )
      aadd( vLibsDefault,                                           cPre+'winreport'+cExt )
      aadd( vLibsDefault,                                           cPre+'xhb'+cExt )              // must come after haru
      aadd( vLibsDefault,                                           cPre+'ziparchive'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbwin'+cExt )            // must come after haru

   CASE cFlavor == ( DefineExtended1 + DefineBorland + DefineXHarbour + Define32bits )
      // 6 - Extended + BCC32 + xHarbour
      cPre := ""
      cExt := ".lib"
      vLibsDefault := {}

      if Prj_Check_Console
      if PUB_bDebugActive
      aadd( vLibsDefault,                                           cPre+'gtwin'+cExt )
      aadd( vLibsDefault,                                           cPre+'debug'+cExt )
      else
      aadd( vLibsDefault,                                           cPre+'gtwin'+cExt )
      endif
      else
      if PUB_bDebugActive
      aadd( vLibsDefault,                                           cPre+'gtgui'+cExt )
      aadd( vLibsDefault,                                           cPre+'gtwin'+cExt )
      aadd( vLibsDefault,                                           cPre+'debugger'+cExt )
      aadd( vLibsDefault,                                           cPre+'debug'+cExt )
      else
      aadd( vLibsDefault,                                           cPre+'gtgui'+cExt )
      aadd( vLibsDefault,                                           cPre+'gtwin'+cExt )
      endif
      endif

      if Prj_Check_MT
      aadd( vLibsDefault,                                           cPre+'cw32mt'+cExt )
      else
      aadd( vLibsDefault,                                           cPre+'cw32'+cExt )
      endif
      aadd( vLibsDefault,                                           cPre+'comctl32'+cExt )
      aadd( vLibsDefault,                                           cPre+'comdlg32'+cExt )
      aadd( vLibsDefault,                                           cPre+'gdi32'+cExt )
      aadd( vLibsDefault,                                           cPre+'import32'+cExt )
      aadd( vLibsDefault,                                           cPre+'iphlpapi'+cExt )
      aadd( vLibsDefault,                                           cPre+'mapi32'+cExt )
      aadd( vLibsDefault,                                           cPre+'mpr'+cExt )
      aadd( vLibsDefault,                                           cPre+'msimg32'+cExt )
      aadd( vLibsDefault,                                           cPre+'ole32'+cExt )
      aadd( vLibsDefault,                                           cPre+'oleaut32'+cExt )
      aadd( vLibsDefault,                                           cPre+'shell32'+cExt )
      aadd( vLibsDefault,                                           cPre+'user32'+cExt )
      aadd( vLibsDefault,                                           cPre+'uuid'+cExt )
      aadd( vLibsDefault,                                           cPre+'vfw32'+cExt )
      aadd( vLibsDefault,                                           cPre+'winmm'+cExt )
      aadd( vLibsDefault,                                           cPre+'winspool'+cExt )
      aadd( vLibsDefault,                                           cPre+'ws2_32'+cExt )
      aadd( vLibsDefault,                                           cPre+'wsock32'+cExt )

      aadd( vLibsDefault,                                           cPre+'ace32'+cExt )
      aadd( vLibsDefault,                                           cPre+'adordd'+cExt )
      aadd( vLibsDefault,                                           cPre+'bostaurus'+cExt )
      aadd( vLibsDefault,                                           cPre+'calldll'+cExt )
      aadd( vLibsDefault,                                           cPre+'codepage'+cExt )
      aadd( vLibsDefault,                                           cPre+'common'+cExt )
      aadd( vLibsDefault,                                           cPre+'cputype'+cExt )
      aadd( vLibsDefault,                                           cPre+'ct'+cExt )
      aadd( vLibsDefault,                                           cPre+'dbfcdx'+cExt )
      aadd( vLibsDefault,                                           cPre+'dbfdbt'+cExt )
      aadd( vLibsDefault,                                           cPre+'dbffpt'+cExt )
      aadd( vLibsDefault,                                           cPre+'dbfntx'+cExt )
      aadd( vLibsDefault,                                           cPre+'dll'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbaes'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbcomm'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbcommon'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbcpage'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbct'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbhpdf'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbhsx'+cExt )
      aadd( vLibsDefault,                                           cPre+'hblang'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbmacro'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbmemio'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbmisc'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbmysql'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbmzip'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbodbc'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbole'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbpcre'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbpcre2'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbpgsql'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbpp'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbprinter'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbrdd'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbrtl'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbsix'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbsqldd'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbsqlit3'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbtip'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbunrar'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbusrrdd'+cExt )
      if Prj_Check_MT
      aadd( vLibsDefault,                                           cPre+'hbvmmt'+cExt )
      else
      aadd( vLibsDefault,                                           cPre+'hbvm'+cExt )
      endif
      aadd( vLibsDefault,                                           cPre+'hbvpdf'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbxml'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbzebra'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbziparc'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbzlib'+cExt )
      aadd( vLibsDefault,                                           cPre+'hmg_hpdf'+cExt )
      aadd( vLibsDefault,                                           cPre+'hmg_qhtm'+cExt )
      aadd( vLibsDefault,                                           cPre+'hpdf'+cExt )
      aadd( vLibsDefault,                                           cPre+'lang'+cExt )
      aadd( vLibsDefault,                                           cPre+'libharu'+cExt )
      aadd( vLibsDefault,                                           cPre+'libhpdf'+cExt )
      aadd( vLibsDefault,                                           cPre+'libmisc'+cExt )
      aadd( vLibsDefault,                                           cPre+'libmysql'+cExt )
      aadd( vLibsDefault,                                           cPre+'libpng'+cExt )
      aadd( vLibsDefault,                                           cPre+'libpq'+cExt )
      aadd( vLibsDefault,                                           cPre+'macro'+cExt )
      aadd( vLibsDefault,                                           cPre+'miniprint'+cExt )
      aadd( vLibsDefault,                                           cPre+'minizip'+cExt )
      aadd( vLibsDefault,                                           cPre+'odbc32'+cExt )
      aadd( vLibsDefault,                                           cPre+'png'+cExt )
      aadd( vLibsDefault,                                           cPre+'pp'+cExt )
      aadd( vLibsDefault,                                           cPre+'propgrid'+cExt )
      aadd( vLibsDefault,                                           cPre+'propsheet'+cExt )
      aadd( vLibsDefault,                                           cPre+'rdd'+cExt )
      aadd( vLibsDefault,                                           cPre+'rddads'+cExt )
      aadd( vLibsDefault,                                           cPre+'rddcdx'+cExt )
      aadd( vLibsDefault,                                           cPre+'rddfpt'+cExt )
      aadd( vLibsDefault,                                           cPre+'rddntx'+cExt )
      aadd( vLibsDefault,                                           cPre+'rtl'+cExt )
      aadd( vLibsDefault,                                           cPre+'socket'+cExt )
      aadd( vLibsDefault,                                           cPre+'sqlite3facade'+cExt )
      aadd( vLibsDefault,                                           cPre+'tip'+cExt )
      aadd( vLibsDefault,                                           cPre+'tbn'+cExt )
      aadd( vLibsDefault,                                           cPre+'tmsagent'+cExt )
      aadd( vLibsDefault,                                           cPre+'tsbrowse'+cExt )
      if Prj_Check_MT
      aadd( vLibsDefault,                                           cPre+'vmmt'+cExt )
      else
      aadd( vLibsDefault,                                           cPre+'vm'+cExt )
      endif
      aadd( vLibsDefault,                                           cPre+'winreport'+cExt )
      aadd( vLibsDefault,                                           cPre+'ziparchive'+cExt )
      aadd( vLibsDefault,                                           cPre+'zlib'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbwin'+cExt )            // must come after haru

   CASE cFlavor == ( DefineExtended1 + DefineMinGW + DefineHarbour + Define32bits )
      // 7 - Extended + MinGW + Harbour, 32 bits
      cPre := "lib"
      cExt := ".a"
      vLibsDefault := {}

      if Prj_Check_Console
      if PUB_bDebugActive
      aadd( vLibsDefault,                                           cPre+'gtwin'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbdebug'+cExt )
      else
      aadd( vLibsDefault,                                           cPre+'gtwin'+cExt )
      endif
      else
      if PUB_bDebugActive
      aadd( vLibsDefault,                                           cPre+'gtgui'+cExt )
      aadd( vLibsDefault,                                           cPre+'gtwin'+cExt )
      aadd( vLibsDefault,                                           cPre+'debugger'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbdebug'+cExt )
      else
      aadd( vLibsDefault,                                           cPre+'gtgui'+cExt )
      aadd( vLibsDefault,                                           cPre+'gtwin'+cExt )
      endif
      endif

      aadd( vLibsDefault,                                           cPre+'comctl32'+cExt )
      aadd( vLibsDefault,                                           cPre+'comdlg32'+cExt )
      aadd( vLibsDefault,                                           cPre+'gdi32'+cExt )
      aadd( vLibsDefault,                                           cPre+'iphlpapi'+cExt )
      aadd( vLibsDefault,                                           cPre+'mapi32'+cExt )
      aadd( vLibsDefault,                                           cPre+'mpr'+cExt )
      aadd( vLibsDefault,                                           cPre+'msimg32'+cExt )
      aadd( vLibsDefault,                                           cPre+'ole32'+cExt )
      aadd( vLibsDefault,                                           cPre+'oleaut32'+cExt )
      aadd( vLibsDefault,                                           cPre+'shell32'+cExt )
      aadd( vLibsDefault,                                           cPre+'user32'+cExt )
      aadd( vLibsDefault,                                           cPre+'uuid'+cExt )
      aadd( vLibsDefault,                                           cPre+'vfw32'+cExt )
      aadd( vLibsDefault,                                           cPre+'winmm'+cExt )
      aadd( vLibsDefault,                                           cPre+'winspool'+cExt )
      aadd( vLibsDefault,                                           cPre+'ws2_32'+cExt )
      aadd( vLibsDefault,                                           cPre+'wsock32'+cExt )

      aadd( vLibsDefault,                                           cPre+'ace32'+cExt )
      aadd( vLibsDefault,                                           cPre+'adordd'+cExt )
      aadd( vLibsDefault,                                           cPre+'bostaurus'+cExt )
      aadd( vLibsDefault,                                           cPre+'calldll'+cExt )
      aadd( vLibsDefault,                                           cPre+'crypt'+cExt )
      aadd( vLibsDefault,                                           cPre+'dll'+cExt )
      aadd( vLibsDefault,                                           cPre+'edit'+cExt )
      aadd( vLibsDefault,                                           cPre+'editex'+cExt )
      aadd( vLibsDefault,                                           cPre+'graph'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbcommon'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbcpage'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbct'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbhpdf'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbhsx'+cExt )
      aadd( vLibsDefault,                                           cPre+'hblang'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbmacro'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbmisc'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbmysql'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbmzip'+cExt )
/*    aadd( vLibsDefault,                                           cPre+'hbnulsys'+cExt )         This generates "multiple definition" error */
      aadd( vLibsDefault,                                           cPre+'hbole'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbpcre'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbpcre2'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbpp'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbprinter'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbrdd'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbrtl'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbsix'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbsqlit3'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbunrar'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbusrrdd'+cExt )
      if Prj_Check_MT
      aadd( vLibsDefault,                                           cPre+'hbvmmt'+cExt )
      else
      aadd( vLibsDefault,                                           cPre+'hbvm'+cExt )
      endif
      aadd( vLibsDefault,                                           cPre+'hbw32'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbxml'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbzebra'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbzip'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbziparc'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbziparch'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbzlib'+cExt )
      aadd( vLibsDefault,                                           cPre+'hmg_hpdf'+cExt )
      aadd( vLibsDefault,                                           cPre+'hpdf'+cExt )
      aadd( vLibsDefault,                                           cPre+'ini'+cExt )
      aadd( vLibsDefault,                                           cPre+'libharu'+cExt )
      aadd( vLibsDefault,                                           cPre+'libhpdf'+cExt )
      aadd( vLibsDefault,                                           cPre+'libpng'+cExt )
      aadd( vLibsDefault,                                           cPre+'miniprint'+cExt )
      aadd( vLibsDefault,                                           cPre+'minizip'+cExt )
      aadd( vLibsDefault,                                           cPre+'misc'+cExt )
      aadd( vLibsDefault,                                           cPre+'mysql'+cExt )
      aadd( vLibsDefault,                                           cPre+'mysqldll'+cExt )
      aadd( vLibsDefault,                                           cPre+'png'+cExt )
      aadd( vLibsDefault,                                           cPre+'pcrepos'+cExt )
      aadd( vLibsDefault,                                           cPre+'propgrid'+cExt )
      aadd( vLibsDefault,                                           cPre+'propsheet'+cExt )
      aadd( vLibsDefault,                                           cPre+'qhtm'+cExt )
      aadd( vLibsDefault,                                           cPre+'rddads'+cExt )
      aadd( vLibsDefault,                                           cPre+'rddcdx'+cExt )
      aadd( vLibsDefault,                                           cPre+'rdddbt'+cExt )
      aadd( vLibsDefault,                                           cPre+'rddfpt'+cExt )
      aadd( vLibsDefault,                                           cPre+'rddntx'+cExt )
      aadd( vLibsDefault,                                           cPre+'registry'+cExt )
      aadd( vLibsDefault,                                           cPre+'report'+cExt )
      aadd( vLibsDefault,                                           cPre+'socket'+cExt )
      aadd( vLibsDefault,                                           cPre+'stdc++'+cExt )
      aadd( vLibsDefault,                                           cPre+'sqlite3'+cExt )
      aadd( vLibsDefault,                                           cPre+'tip'+cExt )
      aadd( vLibsDefault,                                           cPre+'tmsagent'+cExt )
      aadd( vLibsDefault,                                           cPre+'tsbrowse'+cExt )
      aadd( vLibsDefault,                                           cPre+'unrar'+cExt )
      aadd( vLibsDefault,                                           cPre+'winreport'+cExt )
      aadd( vLibsDefault,                                           cPre+'xhb'+cExt )              // must come after haru
      aadd( vLibsDefault,                                           cPre+'zlib1'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbwin'+cExt )            // must come after haru

   CASE cFlavor == ( DefineExtended1 + DefineMinGW + DefineXHarbour + Define32bits )
      // 8 - Extended + MinGW + xHarbour, 32 bits
      cPre := "lib"
      cExt := ".a"
      vLibsDefault := {}

      if Prj_Check_Console
      if PUB_bDebugActive
      aadd( vLibsDefault,                                           cPre+'gtwin'+cExt )
      aadd( vLibsDefault,                                           cPre+'debug'+cExt )
      else
      aadd( vLibsDefault,                                           cPre+'gtwin'+cExt )
      endif
      else
      if PUB_bDebugActive
      aadd( vLibsDefault,                                           cPre+'gtgui'+cExt )
      aadd( vLibsDefault,                                           cPre+'gtwin'+cExt )
      aadd( vLibsDefault,                                           cPre+'debugger'+cExt )
      aadd( vLibsDefault,                                           cPre+'debug'+cExt )
      else
      aadd( vLibsDefault,                                           cPre+'gtgui'+cExt )
      aadd( vLibsDefault,                                           cPre+'gtwin'+cExt )
      endif
      endif

      aadd( vLibsDefault,                                           cPre+'comctl32'+cExt )
      aadd( vLibsDefault,                                           cPre+'comdlg32'+cExt )
      aadd( vLibsDefault,                                           cPre+'gdi32'+cExt )
      aadd( vLibsDefault,                                           cPre+'iphlpapi'+cExt )
      aadd( vLibsDefault,                                           cPre+'mapi32'+cExt )
      aadd( vLibsDefault,                                           cPre+'mpr'+cExt )
      aadd( vLibsDefault,                                           cPre+'msimg32'+cExt )
      aadd( vLibsDefault,                                           cPre+'ole32'+cExt )
      aadd( vLibsDefault,                                           cPre+'oleaut32'+cExt )
      aadd( vLibsDefault,                                           cPre+'shell32'+cExt )
      aadd( vLibsDefault,                                           cPre+'user32'+cExt )
      aadd( vLibsDefault,                                           cPre+'uuid'+cExt )
      aadd( vLibsDefault,                                           cPre+'vfw32'+cExt )
      aadd( vLibsDefault,                                           cPre+'winmm'+cExt )
      aadd( vLibsDefault,                                           cPre+'winspool'+cExt )
      aadd( vLibsDefault,                                           cPre+'ws2_32'+cExt )
      aadd( vLibsDefault,                                           cPre+'wsock32'+cExt )

      aadd( vLibsDefault,                                           cPre+'ace32'+cExt )
      aadd( vLibsDefault,                                           cPre+'adordd'+cExt )
      aadd( vLibsDefault,                                           cPre+'bostaurus'+cExt )
      aadd( vLibsDefault,                                           cPre+'calldll'+cExt )
      aadd( vLibsDefault,                                           cPre+'codepage'+cExt )
      aadd( vLibsDefault,                                           cPre+'common'+cExt )
      aadd( vLibsDefault,                                           cPre+'crypt'+cExt )
      aadd( vLibsDefault,                                           cPre+'ct'+cExt )
      aadd( vLibsDefault,                                           cPre+'dbfcdx'+cExt )
      aadd( vLibsDefault,                                           cPre+'dbfdbt'+cExt )
      aadd( vLibsDefault,                                           cPre+'dbffpt'+cExt )
      aadd( vLibsDefault,                                           cPre+'dbfntx'+cExt )
      aadd( vLibsDefault,                                           cPre+'dll'+cExt )
      aadd( vLibsDefault,                                           cPre+'edit'+cExt )
      aadd( vLibsDefault,                                           cPre+'editex'+cExt )
      aadd( vLibsDefault,                                           cPre+'graph'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbcommon'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbcpage'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbct'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbhpdf'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbhsx'+cExt )
      aadd( vLibsDefault,                                           cPre+'hblang'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbmacro'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbmisc'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbmysql'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbmzip'+cExt )
/*    aadd( vLibsDefault,                                           cPre+'hbnulsys'+cExt )         This generates "multiple definition" error */
      aadd( vLibsDefault,                                           cPre+'hbole'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbpcre'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbpcre2'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbpp'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbprinter'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbrdd'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbrtl'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbsix'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbsqlit3'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbunrar'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbusrrdd'+cExt )
      if Prj_Check_MT
      aadd( vLibsDefault,                                           cPre+'hbvmmt'+cExt )
      else
      aadd( vLibsDefault,                                           cPre+'hbvm'+cExt )
      endif
      aadd( vLibsDefault,                                           cPre+'hbw32'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbxml'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbzebra'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbzip'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbziparc'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbziparch'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbzlib'+cExt )
      aadd( vLibsDefault,                                           cPre+'hmg_hpdf'+cExt )
      aadd( vLibsDefault,                                           cPre+'hpdf'+cExt )
      aadd( vLibsDefault,                                           cPre+'ini'+cExt )
      aadd( vLibsDefault,                                           cPre+'lang'+cExt )
      aadd( vLibsDefault,                                           cPre+'libharu'+cExt )
      aadd( vLibsDefault,                                           cPre+'libhpdf'+cExt )
      aadd( vLibsDefault,                                           cPre+'libmisc'+cExt )
      aadd( vLibsDefault,                                           cPre+'libpng'+cExt )
      aadd( vLibsDefault,                                           cPre+'macro'+cExt )
      aadd( vLibsDefault,                                           cPre+'miniprint'+cExt )
      aadd( vLibsDefault,                                           cPre+'minizip'+cExt )
      aadd( vLibsDefault,                                           cPre+'misc'+cExt )
      aadd( vLibsDefault,                                           cPre+'mysql'+cExt )
      aadd( vLibsDefault,                                           cPre+'mysqldll'+cExt )
      aadd( vLibsDefault,                                           cPre+'pp'+cExt )
      aadd( vLibsDefault,                                           cPre+'png'+cExt )
      aadd( vLibsDefault,                                           cPre+'pcrepos'+cExt )
      aadd( vLibsDefault,                                           cPre+'propgrid'+cExt )
      aadd( vLibsDefault,                                           cPre+'propsheet'+cExt )
      aadd( vLibsDefault,                                           cPre+'qhtm'+cExt )
      aadd( vLibsDefault,                                           cPre+'rdd'+cExt )
      aadd( vLibsDefault,                                           cPre+'rddads'+cExt )
      aadd( vLibsDefault,                                           cPre+'rddcdx'+cExt )
      aadd( vLibsDefault,                                           cPre+'rdddbt'+cExt )
      aadd( vLibsDefault,                                           cPre+'rddfpt'+cExt )
      aadd( vLibsDefault,                                           cPre+'rddntx'+cExt )
      aadd( vLibsDefault,                                           cPre+'registry'+cExt )
      aadd( vLibsDefault,                                           cPre+'report'+cExt )
      aadd( vLibsDefault,                                           cPre+'rtl'+cExt )
      aadd( vLibsDefault,                                           cPre+'socket'+cExt )
      aadd( vLibsDefault,                                           cPre+'stdc++'+cExt )
      aadd( vLibsDefault,                                           cPre+'sqlite3'+cExt )
      aadd( vLibsDefault,                                           cPre+'tip'+cExt )
      aadd( vLibsDefault,                                           cPre+'tmsagent'+cExt )
      aadd( vLibsDefault,                                           cPre+'tsbrowse'+cExt )
      aadd( vLibsDefault,                                           cPre+'unrar'+cExt )
      if Prj_Check_MT
      aadd( vLibsDefault,                                           cPre+'vmmt'+cExt )
      else
      aadd( vLibsDefault,                                           cPre+'vm'+cExt )
      endif
      aadd( vLibsDefault,                                           cPre+'winreport'+cExt )
      aadd( vLibsDefault,                                           cPre+'zebra'+cExt )
      aadd( vLibsDefault,                                           cPre+'zlib'+cExt )
      aadd( vLibsDefault,                                           cPre+'zlib1'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbwin'+cExt )            // must come after haru

   CASE cFlavor == ( DefineExtended1 + DefineMinGW + DefineHarbour + Define64bits )
      // 9 - Extended + MinGW + Harbour, 64 bits
      cPre := "lib"
      cExt := ".a"
      vLibsDefault := {}

      if Prj_Check_Console
      if PUB_bDebugActive
      aadd( vLibsDefault,                                           cPre+'gtwin'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbdebug'+cExt )
      else
      aadd( vLibsDefault,                                           cPre+'gtwin'+cExt )
      endif
      else
      if PUB_bDebugActive
      aadd( vLibsDefault,                                           cPre+'gtgui'+cExt )
      aadd( vLibsDefault,                                           cPre+'gtwin'+cExt )
      aadd( vLibsDefault,                                           cPre+'debugger'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbdebug'+cExt )
      else
      aadd( vLibsDefault,                                           cPre+'gtgui'+cExt )
      aadd( vLibsDefault,                                           cPre+'gtwin'+cExt )
      endif
      endif

      aadd( vLibsDefault,                                           cPre+'comctl32'+cExt )
      aadd( vLibsDefault,                                           cPre+'comdlg32'+cExt )
      aadd( vLibsDefault,                                           cPre+'gdi32'+cExt )
      aadd( vLibsDefault,                                           cPre+'iphlpapi'+cExt )
      aadd( vLibsDefault,                                           cPre+'mapi32'+cExt )
      aadd( vLibsDefault,                                           cPre+'mpr'+cExt )
      aadd( vLibsDefault,                                           cPre+'msimg32'+cExt )
      aadd( vLibsDefault,                                           cPre+'ole32'+cExt )
      aadd( vLibsDefault,                                           cPre+'oleaut32'+cExt )
      aadd( vLibsDefault,                                           cPre+'shell32'+cExt )
      aadd( vLibsDefault,                                           cPre+'user32'+cExt )
      aadd( vLibsDefault,                                           cPre+'uuid'+cExt )
      aadd( vLibsDefault,                                           cPre+'vfw32'+cExt )
      aadd( vLibsDefault,                                           cPre+'winmm'+cExt )
      aadd( vLibsDefault,                                           cPre+'winspool'+cExt )
      aadd( vLibsDefault,                                           cPre+'ws2_32'+cExt )
      aadd( vLibsDefault,                                           cPre+'wsock32'+cExt )

      aadd( vLibsDefault,                                           cPre+'ace32'+cExt )
      aadd( vLibsDefault,                                           cPre+'adordd'+cExt )
      aadd( vLibsDefault,                                           cPre+'bostaurus'+cExt )
      aadd( vLibsDefault,                                           cPre+'calldll'+cExt )
      aadd( vLibsDefault,                                           cPre+'crypt'+cExt )
      aadd( vLibsDefault,                                           cPre+'dll'+cExt )
      aadd( vLibsDefault,                                           cPre+'edit'+cExt )
      aadd( vLibsDefault,                                           cPre+'editex'+cExt )
      aadd( vLibsDefault,                                           cPre+'graph'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbcommon'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbcpage'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbct'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbhpdf'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbhsx'+cExt )
      aadd( vLibsDefault,                                           cPre+'hblang'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbmacro'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbmisc'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbmysql'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbmzip'+cExt )
/*    aadd( vLibsDefault,                                           cPre+'hbnulsys'+cExt )         This generates "multiple definition" error */
      aadd( vLibsDefault,                                           cPre+'hbole'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbpcre'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbpcre2'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbpp'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbprinter'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbrdd'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbrtl'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbsix'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbsqlit3'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbunrar'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbusrrdd'+cExt )
      if Prj_Check_MT
      aadd( vLibsDefault,                                           cPre+'hbvmmt'+cExt )
      else
      aadd( vLibsDefault,                                           cPre+'hbvm'+cExt )
      endif
      aadd( vLibsDefault,                                           cPre+'hbw32'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbxml'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbzebra'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbzip'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbziparc'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbziparch'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbzlib'+cExt )
      aadd( vLibsDefault,                                           cPre+'hmg_hpdf'+cExt )
      aadd( vLibsDefault,                                           cPre+'hpdf'+cExt )
      aadd( vLibsDefault,                                           cPre+'ini'+cExt )
      aadd( vLibsDefault,                                           cPre+'libharu'+cExt )
      aadd( vLibsDefault,                                           cPre+'libhpdf'+cExt )
      aadd( vLibsDefault,                                           cPre+'libpng'+cExt )
      aadd( vLibsDefault,                                           cPre+'miniprint'+cExt )
      aadd( vLibsDefault,                                           cPre+'minizip'+cExt )
      aadd( vLibsDefault,                                           cPre+'misc'+cExt )
      aadd( vLibsDefault,                                           cPre+'mysql'+cExt )
      aadd( vLibsDefault,                                           cPre+'mysqldll'+cExt )
      aadd( vLibsDefault,                                           cPre+'png'+cExt )
      aadd( vLibsDefault,                                           cPre+'pcrepos'+cExt )
      aadd( vLibsDefault,                                           cPre+'propgrid'+cExt )
      aadd( vLibsDefault,                                           cPre+'propsheet'+cExt )
      aadd( vLibsDefault,                                           cPre+'qhtm'+cExt )
      aadd( vLibsDefault,                                           cPre+'rddads'+cExt )
      aadd( vLibsDefault,                                           cPre+'rddcdx'+cExt )
      aadd( vLibsDefault,                                           cPre+'rdddbt'+cExt )
      aadd( vLibsDefault,                                           cPre+'rddfpt'+cExt )
      aadd( vLibsDefault,                                           cPre+'rddntx'+cExt )
      aadd( vLibsDefault,                                           cPre+'registry'+cExt )
      aadd( vLibsDefault,                                           cPre+'report'+cExt )
      aadd( vLibsDefault,                                           cPre+'socket'+cExt )
      aadd( vLibsDefault,                                           cPre+'stdc++'+cExt )
      aadd( vLibsDefault,                                           cPre+'sqlite3'+cExt )
      aadd( vLibsDefault,                                           cPre+'tip'+cExt )
      aadd( vLibsDefault,                                           cPre+'tmsagent'+cExt )
      aadd( vLibsDefault,                                           cPre+'tsbrowse'+cExt )
      aadd( vLibsDefault,                                           cPre+'unrar'+cExt )
      aadd( vLibsDefault,                                           cPre+'winreport'+cExt )
      aadd( vLibsDefault,                                           cPre+'xhb'+cExt )              // must come after haru
      aadd( vLibsDefault,                                           cPre+'zlib1'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbwin'+cExt )            // must come after haru

   CASE cFlavor == ( DefineExtended1 + DefineMinGW + DefineXHarbour + Define64bits )
      // 10 - Extended + MinGW + xHarbour, 64 bits
      cPre := "lib"
      cExt := ".a"
      vLibsDefault := {}

      if Prj_Check_Console
      if PUB_bDebugActive
      aadd( vLibsDefault,                                           cPre+'gtwin'+cExt )
      aadd( vLibsDefault,                                           cPre+'debug'+cExt )
      else
      aadd( vLibsDefault,                                           cPre+'gtwin'+cExt )
      endif
      else
      if PUB_bDebugActive
      aadd( vLibsDefault,                                           cPre+'gtgui'+cExt )
      aadd( vLibsDefault,                                           cPre+'gtwin'+cExt )
      aadd( vLibsDefault,                                           cPre+'debugger'+cExt )
      aadd( vLibsDefault,                                           cPre+'debug'+cExt )
      else
      aadd( vLibsDefault,                                           cPre+'gtgui'+cExt )
      aadd( vLibsDefault,                                           cPre+'gtwin'+cExt )
      endif
      endif

      aadd( vLibsDefault,                                           cPre+'comctl32'+cExt )
      aadd( vLibsDefault,                                           cPre+'comdlg32'+cExt )
      aadd( vLibsDefault,                                           cPre+'gdi32'+cExt )
      aadd( vLibsDefault,                                           cPre+'iphlpapi'+cExt )
      aadd( vLibsDefault,                                           cPre+'mapi32'+cExt )
      aadd( vLibsDefault,                                           cPre+'mpr'+cExt )
      aadd( vLibsDefault,                                           cPre+'msimg32'+cExt )
      aadd( vLibsDefault,                                           cPre+'ole32'+cExt )
      aadd( vLibsDefault,                                           cPre+'oleaut32'+cExt )
      aadd( vLibsDefault,                                           cPre+'shell32'+cExt )
      aadd( vLibsDefault,                                           cPre+'user32'+cExt )
      aadd( vLibsDefault,                                           cPre+'uuid'+cExt )
      aadd( vLibsDefault,                                           cPre+'vfw32'+cExt )
      aadd( vLibsDefault,                                           cPre+'winmm'+cExt )
      aadd( vLibsDefault,                                           cPre+'winspool'+cExt )
      aadd( vLibsDefault,                                           cPre+'ws2_32'+cExt )
      aadd( vLibsDefault,                                           cPre+'wsock32'+cExt )

      aadd( vLibsDefault,                                           cPre+'ace32'+cExt )
      aadd( vLibsDefault,                                           cPre+'adordd'+cExt )
      aadd( vLibsDefault,                                           cPre+'bostaurus'+cExt )
      aadd( vLibsDefault,                                           cPre+'calldll'+cExt )
      aadd( vLibsDefault,                                           cPre+'codepage'+cExt )
      aadd( vLibsDefault,                                           cPre+'common'+cExt )
      aadd( vLibsDefault,                                           cPre+'crypt'+cExt )
      aadd( vLibsDefault,                                           cPre+'dbfcdx'+cExt )
      aadd( vLibsDefault,                                           cPre+'dbfdbt'+cExt )
      aadd( vLibsDefault,                                           cPre+'dbffpt'+cExt )
      aadd( vLibsDefault,                                           cPre+'dbfntx'+cExt )
      aadd( vLibsDefault,                                           cPre+'dll'+cExt )
      aadd( vLibsDefault,                                           cPre+'edit'+cExt )
      aadd( vLibsDefault,                                           cPre+'editex'+cExt )
      aadd( vLibsDefault,                                           cPre+'graph'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbcommon'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbcpage'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbct'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbhpdf'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbhsx'+cExt )
      aadd( vLibsDefault,                                           cPre+'hblang'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbmacro'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbmisc'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbmysql'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbmzip'+cExt )
/*    aadd( vLibsDefault,                                           cPre+'hbnulsys'+cExt )         This generates "multiple definition" error */
      aadd( vLibsDefault,                                           cPre+'hbole'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbpcre'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbpcre2'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbpp'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbprinter'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbrdd'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbrtl'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbsix'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbsqlit3'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbunrar'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbusrrdd'+cExt )
      if Prj_Check_MT
      aadd( vLibsDefault,                                           cPre+'hbvmmt'+cExt )
      else
      aadd( vLibsDefault,                                           cPre+'hbvm'+cExt )
      endif
      aadd( vLibsDefault,                                           cPre+'hbw32'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbxml'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbzebra'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbzip'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbziparc'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbziparch'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbzlib'+cExt )
      aadd( vLibsDefault,                                           cPre+'hmg_hpdf'+cExt )
      aadd( vLibsDefault,                                           cPre+'hpdf'+cExt )
      aadd( vLibsDefault,                                           cPre+'ini'+cExt )
      aadd( vLibsDefault,                                           cPre+'lang'+cExt )
      aadd( vLibsDefault,                                           cPre+'libharu'+cExt )
      aadd( vLibsDefault,                                           cPre+'libhpdf'+cExt )
      aadd( vLibsDefault,                                           cPre+'libmisc'+cExt )
      aadd( vLibsDefault,                                           cPre+'libpng'+cExt )
      aadd( vLibsDefault,                                           cPre+'macro'+cExt )
      aadd( vLibsDefault,                                           cPre+'miniprint'+cExt )
      aadd( vLibsDefault,                                           cPre+'minizip'+cExt )
      aadd( vLibsDefault,                                           cPre+'misc'+cExt )
      aadd( vLibsDefault,                                           cPre+'mysql'+cExt )
      aadd( vLibsDefault,                                           cPre+'mysqldll'+cExt )
      aadd( vLibsDefault,                                           cPre+'png'+cExt )
      aadd( vLibsDefault,                                           cPre+'pcrepos'+cExt )
      aadd( vLibsDefault,                                           cPre+'pp'+cExt )
      aadd( vLibsDefault,                                           cPre+'propgrid'+cExt )
      aadd( vLibsDefault,                                           cPre+'propsheet'+cExt )
      aadd( vLibsDefault,                                           cPre+'qhtm'+cExt )
      aadd( vLibsDefault,                                           cPre+'rdd'+cExt )
      aadd( vLibsDefault,                                           cPre+'rddads'+cExt )
      aadd( vLibsDefault,                                           cPre+'rddcdx'+cExt )
      aadd( vLibsDefault,                                           cPre+'rdddbt'+cExt )
      aadd( vLibsDefault,                                           cPre+'rddfpt'+cExt )
      aadd( vLibsDefault,                                           cPre+'rddntx'+cExt )
      aadd( vLibsDefault,                                           cPre+'registry'+cExt )
      aadd( vLibsDefault,                                           cPre+'report'+cExt )
      aadd( vLibsDefault,                                           cPre+'rtl'+cExt )
      aadd( vLibsDefault,                                           cPre+'socket'+cExt )
      aadd( vLibsDefault,                                           cPre+'stdc++'+cExt )
      aadd( vLibsDefault,                                           cPre+'sqlite3'+cExt )
      aadd( vLibsDefault,                                           cPre+'tip'+cExt )
      aadd( vLibsDefault,                                           cPre+'tmsagent'+cExt )
      aadd( vLibsDefault,                                           cPre+'tsbrowse'+cExt )
      aadd( vLibsDefault,                                           cPre+'unrar'+cExt )
      if Prj_Check_MT
      aadd( vLibsDefault,                                           cPre+'vmmt'+cExt )
      else
      aadd( vLibsDefault,                                           cPre+'vm'+cExt )
      endif
      aadd( vLibsDefault,                                           cPre+'winreport'+cExt )
      aadd( vLibsDefault,                                           cPre+'zebra'+cExt )
      aadd( vLibsDefault,                                           cPre+'zlib'+cExt )
      aadd( vLibsDefault,                                           cPre+'zlib1'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbwin'+cExt )            // must come after haru

   CASE cFlavor == ( DefineOohg3 + DefineBorland + DefineHarbour + Define32bits )
      // 11 - OOHG + BCC32 + Harbour
      cPre := ""
      cExt := ".lib"
      vLibsDefault := {}

      if Prj_Check_Console
      if PUB_bDebugActive
      aadd( vLibsDefault,                                           cPre+'gtgui'+cExt )
      aadd( vLibsDefault,                                           cPre+'gtwin'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbdebug'+cExt )
      else
      aadd( vLibsDefault,                                           cPre+'gtgui'+cExt )
      aadd( vLibsDefault,                                           cPre+'gtwin'+cExt )
      endif
      else
      if PUB_bDebugActive
      aadd( vLibsDefault,                                           cPre+'gtgui'+cExt )
      aadd( vLibsDefault,                                           cPre+'gtwin'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbdebug'+cExt )
      else
      aadd( vLibsDefault,                                           cPre+'gtgui'+cExt )
      aadd( vLibsDefault,                                           cPre+'gtwin'+cExt )
      endif
      endif

      if Prj_Check_MT
      aadd( vLibsDefault,                                           cPre+'cw32mt'+cExt )
      else
      aadd( vLibsDefault,                                           cPre+'cw32'+cExt )
      endif
      aadd( vLibsDefault,                                           cPre+'comctl32'+cExt )
      aadd( vLibsDefault,                                           cPre+'comdlg32'+cExt )
      aadd( vLibsDefault,                                           cPre+'gdi32'+cExt )
      aadd( vLibsDefault,                                           cPre+'import32'+cExt )
      aadd( vLibsDefault,                                           cPre+'iphlpapi'+cExt )
      aadd( vLibsDefault,                                           cPre+'mapi32'+cExt )
      aadd( vLibsDefault,                                           cPre+'mpr'+cExt )
      aadd( vLibsDefault,                                           cPre+'msimg32'+cExt )
      aadd( vLibsDefault,                                           cPre+'ole32'+cExt )
      aadd( vLibsDefault,                                           cPre+'oleaut32'+cExt )
      aadd( vLibsDefault,                                           cPre+'shell32'+cExt )
      aadd( vLibsDefault,                                           cPre+'user32'+cExt )
      aadd( vLibsDefault,                                           cPre+'uuid'+cExt )
      aadd( vLibsDefault,                                           cPre+'vfw32'+cExt )
      aadd( vLibsDefault,                                           cPre+'winmm'+cExt )
      aadd( vLibsDefault,                                           cPre+'winspool'+cExt )
      aadd( vLibsDefault,                                           cPre+'ws2_32'+cExt )
      aadd( vLibsDefault,                                           cPre+'wsock32'+cExt )

      aadd( vLibsDefault,                                           cPre+'ace32'+cExt )
      aadd( vLibsDefault,                                           cPre+'bostaurus'+cExt )
      aadd( vLibsDefault,                                           cPre+'dll'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbcommon'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbcpage'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbct'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbhpdf'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbhsx'+cExt )
      aadd( vLibsDefault,                                           cPre+'hblang'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbmacro'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbmemio'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbmisc'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbmzip'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbnulrdd'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbole'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbpcre'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbpcre2'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbpp'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbprinter'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbrdd'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbrtl'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbsix'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbtip'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbusrrdd'+cExt )
      if Prj_Check_MT
      aadd( vLibsDefault,                                           cPre+'hbvmmt'+cExt )
      else
      aadd( vLibsDefault,                                           cPre+'hbvm'+cExt )
      endif
      aadd( vLibsDefault,                                           cPre+'hbw32'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbzebra'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbzip'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbziparc'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbziparch'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbzlib'+cExt )
      aadd( vLibsDefault,                                           cPre+'hpdf'+cExt )
      aadd( vLibsDefault,                                           cPre+'libct'+cExt )
      aadd( vLibsDefault,                                           cPre+'libharu'+cExt )
      aadd( vLibsDefault,                                           cPre+'libhpdf'+cExt )
      aadd( vLibsDefault,                                           cPre+'libmisc'+cExt )
      aadd( vLibsDefault,                                           cPre+'libmysql'+cExt )
      aadd( vLibsDefault,                                           cPre+'libpng'+cExt )
      aadd( vLibsDefault,                                           cPre+'miniprint'+cExt )
      aadd( vLibsDefault,                                           cPre+'minizip'+cExt )
      aadd( vLibsDefault,                                           cPre+'mysql'+cExt )
      aadd( vLibsDefault,                                           cPre+'png'+cExt )
      aadd( vLibsDefault,                                           cPre+'rddads'+cExt )
      aadd( vLibsDefault,                                           cPre+'rddcdx'+cExt )
      aadd( vLibsDefault,                                           cPre+'rdddbt'+cExt )
      aadd( vLibsDefault,                                           cPre+'rddfpt'+cExt )
      aadd( vLibsDefault,                                           cPre+'rddntx'+cExt )
      aadd( vLibsDefault,                                           cPre+'rddsql'+cExt )
      aadd( vLibsDefault,                                           cPre+'sddodbc'+cExt )
      aadd( vLibsDefault,                                           cPre+'socket'+cExt )
      aadd( vLibsDefault,                                           cPre+'xhb'+cExt )              // must come after haru
      aadd( vLibsDefault,                                           cPre+'hbwin'+cExt )            // must come after haru

   CASE cFlavor == ( DefineOohg3 + DefineBorland + DefineXHarbour + Define32bits )
      // 12 - OOHG + BCC32 + xHarbour
      cPre := ""
      cExt := ".lib"
      vLibsDefault := {}

      if Prj_Check_Console
      if PUB_bDebugActive
      aadd( vLibsDefault,                                           cPre+'gtgui'+cExt )
      aadd( vLibsDefault,                                           cPre+'gtwin'+cExt )
      aadd( vLibsDefault,                                           cPre+'debug'+cExt )
      else
      aadd( vLibsDefault,                                           cPre+'gtgui'+cExt )
      aadd( vLibsDefault,                                           cPre+'gtwin'+cExt )
      endif
      else
      if PUB_bDebugActive
      aadd( vLibsDefault,                                           cPre+'gtgui'+cExt )
      aadd( vLibsDefault,                                           cPre+'gtwin'+cExt )
      aadd( vLibsDefault,                                           cPre+'debug'+cExt )
      else
      aadd( vLibsDefault,                                           cPre+'gtgui'+cExt )
      aadd( vLibsDefault,                                           cPre+'gtwin'+cExt )
      endif
      endif

      if Prj_Check_MT
      aadd( vLibsDefault,                                           cPre+'cw32mt'+cExt )
      else
      aadd( vLibsDefault,                                           cPre+'cw32'+cExt )
      endif
      aadd( vLibsDefault,                                           cPre+'comctl32'+cExt )
      aadd( vLibsDefault,                                           cPre+'comdlg32'+cExt )
      aadd( vLibsDefault,                                           cPre+'gdi32'+cExt )
      aadd( vLibsDefault,                                           cPre+'import32'+cExt )
      aadd( vLibsDefault,                                           cPre+'iphlpapi'+cExt )
      aadd( vLibsDefault,                                           cPre+'mapi32'+cExt )
      aadd( vLibsDefault,                                           cPre+'mpr'+cExt )
      aadd( vLibsDefault,                                           cPre+'msimg32'+cExt )
      aadd( vLibsDefault,                                           cPre+'ole32'+cExt )
      aadd( vLibsDefault,                                           cPre+'oleaut32'+cExt )
      aadd( vLibsDefault,                                           cPre+'shell32'+cExt )
      aadd( vLibsDefault,                                           cPre+'user32'+cExt )
      aadd( vLibsDefault,                                           cPre+'uuid'+cExt )
      aadd( vLibsDefault,                                           cPre+'vfw32'+cExt )
      aadd( vLibsDefault,                                           cPre+'winmm'+cExt )
      aadd( vLibsDefault,                                           cPre+'winspool'+cExt )
      aadd( vLibsDefault,                                           cPre+'ws2_32'+cExt )
      aadd( vLibsDefault,                                           cPre+'wsock32'+cExt )

      aadd( vLibsDefault,                                           cPre+'ace32'+cExt )
      aadd( vLibsDefault,                                           cPre+'bostaurus'+cExt )
      aadd( vLibsDefault,                                           cPre+'codepage'+cExt )
      aadd( vLibsDefault,                                           cPre+'common'+cExt )
      aadd( vLibsDefault,                                           cPre+'ct'+cExt )
      aadd( vLibsDefault,                                           cPre+'dbfcdx'+cExt )
      aadd( vLibsDefault,                                           cPre+'dbfdbt'+cExt )
      aadd( vLibsDefault,                                           cPre+'dbffpt'+cExt )
      aadd( vLibsDefault,                                           cPre+'dbfntx'+cExt )
      aadd( vLibsDefault,                                           cPre+'dll'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbhpdf'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbmzip'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbole'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbprinter'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbsix'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbzebra'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbzip'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbzlib'+cExt )
      aadd( vLibsDefault,                                           cPre+'hpdf'+cExt )
      aadd( vLibsDefault,                                           cPre+'hsx'+cExt )
      aadd( vLibsDefault,                                           cPre+'lang'+cExt )
      aadd( vLibsDefault,                                           cPre+'libct'+cExt )
      aadd( vLibsDefault,                                           cPre+'libharu'+cExt )
      aadd( vLibsDefault,                                           cPre+'libhpdf'+cExt )
      aadd( vLibsDefault,                                           cPre+'libmisc'+cExt )
      aadd( vLibsDefault,                                           cPre+'libmysql'+cExt )
      aadd( vLibsDefault,                                           cPre+'libpng'+cExt )
      aadd( vLibsDefault,                                           cPre+'macro'+cExt )
      aadd( vLibsDefault,                                           cPre+'miniprint'+cExt )
      aadd( vLibsDefault,                                           cPre+'mysql'+cExt )
      aadd( vLibsDefault,                                           cPre+'pcrepos'+cExt )
      aadd( vLibsDefault,                                           cPre+'png'+cExt )
      aadd( vLibsDefault,                                           cPre+'pp'+cExt )
      aadd( vLibsDefault,                                           cPre+'rdd'+cExt )
      aadd( vLibsDefault,                                           cPre+'rddads'+cExt )
      aadd( vLibsDefault,                                           cPre+'rtl'+cExt )
      aadd( vLibsDefault,                                           cPre+'socket'+cExt )
      aadd( vLibsDefault,                                           cPre+'tip'+cExt )
      aadd( vLibsDefault,                                           cPre+'usrrdd'+cExt )
      if Prj_Check_MT
      aadd( vLibsDefault,                                           cPre+'vmmt'+cExt )
      else
      aadd( vLibsDefault,                                           cPre+'vm'+cExt )
      endif
      aadd( vLibsDefault,                                           cPre+'zlib'+cExt )
      aadd( vLibsDefault,                                           cPre+'zlib1'+cExt )

   CASE cFlavor == ( DefineOohg3 + DefineMinGW + DefineHarbour + Define32bits )
      // 13 - OOHG + MinGW + Harbour, 32 bits
      cPre := "lib"
      cExt := ".a"
      vLibsDefault := {}

      if Prj_Check_Console
      if PUB_bDebugActive
      aadd( vLibsDefault,                                           cPre+'gtgui'+cExt )
      aadd( vLibsDefault,                                           cPre+'gtwin'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbdebug'+cExt )
      else
      aadd( vLibsDefault,                                           cPre+'gtgui'+cExt )
      aadd( vLibsDefault,                                           cPre+'gtwin'+cExt )
      endif
      else
      if PUB_bDebugActive
      aadd( vLibsDefault,                                           cPre+'gtgui'+cExt )
      aadd( vLibsDefault,                                           cPre+'gtwin'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbdebug'+cExt )
      else
      aadd( vLibsDefault,                                           cPre+'gtgui'+cExt )
      aadd( vLibsDefault,                                           cPre+'gtwin'+cExt )
      endif
      endif

      aadd( vLibsDefault,                                           cPre+'comctl32'+cExt )
      aadd( vLibsDefault,                                           cPre+'comdlg32'+cExt )
      aadd( vLibsDefault,                                           cPre+'gdi32'+cExt )
      aadd( vLibsDefault,                                           cPre+'iphlpapi'+cExt )
      aadd( vLibsDefault,                                           cPre+'mapi32'+cExt )
      aadd( vLibsDefault,                                           cPre+'mpr'+cExt )
      aadd( vLibsDefault,                                           cPre+'msimg32'+cExt )
      aadd( vLibsDefault,                                           cPre+'ole32'+cExt )
      aadd( vLibsDefault,                                           cPre+'oleaut32'+cExt )
      aadd( vLibsDefault,                                           cPre+'shell32'+cExt )
      aadd( vLibsDefault,                                           cPre+'user32'+cExt )
      aadd( vLibsDefault,                                           cPre+'uuid'+cExt )
      aadd( vLibsDefault,                                           cPre+'vfw32'+cExt )
      aadd( vLibsDefault,                                           cPre+'winmm'+cExt )
      aadd( vLibsDefault,                                           cPre+'winspool'+cExt )
      aadd( vLibsDefault,                                           cPre+'ws2_32'+cExt )
      aadd( vLibsDefault,                                           cPre+'wsock32'+cExt )

      aadd( vLibsDefault,                                           cPre+'bostaurus'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbcommon'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbcpage'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbcplr'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbct'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbextern'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbhpdf'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbhsx'+cExt )
      aadd( vLibsDefault,                                           cPre+'hblang'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbmacro'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbmemio'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbmisc'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbmysql'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbmzip'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbodbc'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbpcre'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbpcre2'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbpp'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbprinter'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbrdd'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbrtl'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbsix'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbtip'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbuddall'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbusrrdd'+cExt )
      if Prj_Check_MT
      aadd( vLibsDefault,                                           cPre+'hbvmmt'+cExt )
      else
      aadd( vLibsDefault,                                           cPre+'hbvm'+cExt )
      endif
      aadd( vLibsDefault,                                           cPre+'hbzebra'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbziparc'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbzlib'+cExt )
      aadd( vLibsDefault,                                           cPre+'hpdf'+cExt )
      aadd( vLibsDefault,                                           cPre+'libharu'+cExt )
      aadd( vLibsDefault,                                           cPre+'libhpdf'+cExt )
      aadd( vLibsDefault,                                           cPre+'libpng'+cExt )
      aadd( vLibsDefault,                                           cPre+'miniprint'+cExt )
      aadd( vLibsDefault,                                           cPre+'minizip'+cExt )
      aadd( vLibsDefault,                                           cPre+'odbc32'+cExt )
      aadd( vLibsDefault,                                           cPre+'png'+cExt )
      aadd( vLibsDefault,                                           cPre+'rddads'+cExt )
      aadd( vLibsDefault,                                           cPre+'rddcdx'+cExt )
      aadd( vLibsDefault,                                           cPre+'rddfpt'+cExt )
      aadd( vLibsDefault,                                           cPre+'rddnsx'+cExt )
      aadd( vLibsDefault,                                           cPre+'rddntx'+cExt )
      aadd( vLibsDefault,                                           cPre+'rddsql'+cExt )
      aadd( vLibsDefault,                                           cPre+'sddodbc'+cExt )
      aadd( vLibsDefault,                                           cPre+'xhb'+cExt )              // must come after haru
      aadd( vLibsDefault,                                           cPre+'hbwin'+cExt )            // must come after haru

   CASE cFlavor == ( DefineOohg3 + DefineMinGW + DefineXHarbour + Define32bits )
      // 14 - OOHG + MinGW + xHarbour, 32 bits
      cPre := "lib"
      cExt := ".a"
      vLibsDefault := {}

      if Prj_Check_Console
      if PUB_bDebugActive
      aadd( vLibsDefault,                                           cPre+'gtgui'+cExt )
      aadd( vLibsDefault,                                           cPre+'gtwin'+cExt )
      aadd( vLibsDefault,                                           cPre+'debug'+cExt )
      else
      aadd( vLibsDefault,                                           cPre+'gtgui'+cExt )
      aadd( vLibsDefault,                                           cPre+'gtwin'+cExt )
      endif
      else
      if PUB_bDebugActive
      aadd( vLibsDefault,                                           cPre+'gtwin'+cExt )
      aadd( vLibsDefault,                                           cPre+'gtgui'+cExt )
      aadd( vLibsDefault,                                           cPre+'debug'+cExt )
      else
      aadd( vLibsDefault,                                           cPre+'gtwin'+cExt )
      aadd( vLibsDefault,                                           cPre+'gtgui'+cExt )
      endif
      endif

      aadd( vLibsDefault,                                           cPre+'comctl32'+cExt )
      aadd( vLibsDefault,                                           cPre+'comdlg32'+cExt )
      aadd( vLibsDefault,                                           cPre+'gdi32'+cExt )
      aadd( vLibsDefault,                                           cPre+'iphlpapi'+cExt )
      aadd( vLibsDefault,                                           cPre+'mapi32'+cExt )
      aadd( vLibsDefault,                                           cPre+'mpr'+cExt )
      aadd( vLibsDefault,                                           cPre+'msimg32'+cExt )
      aadd( vLibsDefault,                                           cPre+'ole32'+cExt )
      aadd( vLibsDefault,                                           cPre+'oleaut32'+cExt )
      aadd( vLibsDefault,                                           cPre+'shell32'+cExt )
      aadd( vLibsDefault,                                           cPre+'user32'+cExt )
      aadd( vLibsDefault,                                           cPre+'uuid'+cExt )
      aadd( vLibsDefault,                                           cPre+'vfw32'+cExt )
      aadd( vLibsDefault,                                           cPre+'winmm'+cExt )
      aadd( vLibsDefault,                                           cPre+'winspool'+cExt )
      aadd( vLibsDefault,                                           cPre+'ws2_32'+cExt )
      aadd( vLibsDefault,                                           cPre+'wsock32'+cExt )

      aadd( vLibsDefault,                                           cPre+'bostaurus'+cExt )
      aadd( vLibsDefault,                                           cPre+'codepage'+cExt )
      aadd( vLibsDefault,                                           cPre+'common'+cExt )
      aadd( vLibsDefault,                                           cPre+'ct'+cExt )
      aadd( vLibsDefault,                                           cPre+'dbfcdx'+cExt )
      aadd( vLibsDefault,                                           cPre+'dbfdbt'+cExt )
      aadd( vLibsDefault,                                           cPre+'dbffpt'+cExt )
      aadd( vLibsDefault,                                           cPre+'dbfntx'+cExt )
      aadd( vLibsDefault,                                           cPre+'dll'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbhpdf'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbmzip'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbprinter'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbsix'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbzebra'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbzip'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbzlib'+cExt )
      aadd( vLibsDefault,                                           cPre+'hpdf'+cExt )
      aadd( vLibsDefault,                                           cPre+'hsx'+cExt )
      aadd( vLibsDefault,                                           cPre+'lang'+cExt )
      aadd( vLibsDefault,                                           cPre+'libharu'+cExt )
      aadd( vLibsDefault,                                           cPre+'libhpdf'+cExt )
      aadd( vLibsDefault,                                           cPre+'libpng'+cExt )
      aadd( vLibsDefault,                                           cPre+'macro'+cExt )
      aadd( vLibsDefault,                                           cPre+'mapi32'+cExt )
      aadd( vLibsDefault,                                           cPre+'miniprint'+cExt )
      aadd( vLibsDefault,                                           cPre+'mysql'+cExt )
      aadd( vLibsDefault,                                           cPre+'mysqldll'+cExt )
/*    aadd( vLibsDefault,                                           cPre+'nulsys'+cExt )           This generates "multiple definition" error */
      aadd( vLibsDefault,                                           cPre+'pcrepos'+cExt )
      aadd( vLibsDefault,                                           cPre+'png'+cExt )
      aadd( vLibsDefault,                                           cPre+'pp'+cExt )
      aadd( vLibsDefault,                                           cPre+'rdd'+cExt )
      aadd( vLibsDefault,                                           cPre+'rtl'+cExt )
      aadd( vLibsDefault,                                           cPre+'socket'+cExt )
      aadd( vLibsDefault,                                           cPre+'stdc++'+cExt )
      aadd( vLibsDefault,                                           cPre+'tip'+cExt )
      aadd( vLibsDefault,                                           cPre+'usrrdd'+cExt )
      if Prj_Check_MT
      aadd( vLibsDefault,                                           cPre+'vmmt'+cExt )
      else
      aadd( vLibsDefault,                                           cPre+'vm'+cExt )
      endif
      aadd( vLibsDefault,                                           cPre+'xCrypt'+cExt )
      aadd( vLibsDefault,                                           cPre+'xEdit'+cExt )
      aadd( vLibsDefault,                                           cPre+'xEditex'+cExt )
      aadd( vLibsDefault,                                           cPre+'xGraph'+cExt )
      aadd( vLibsDefault,                                           cPre+'xIni'+cExt )
      aadd( vLibsDefault,                                           cPre+'xRegistry'+cExt )
      aadd( vLibsDefault,                                           cPre+'xReport'+cExt )
      aadd( vLibsDefault,                                           cPre+'zlib1'+cExt )

   CASE cFlavor == ( DefineOohg3 + DefineMinGW + DefineHarbour + Define64bits )
      // 15 - OOHG + MinGW + Harbour, 64 bits
      cPre := "lib"
      cExt := ".a"
      vLibsDefault := {}

      if Prj_Check_Console
      if PUB_bDebugActive
      aadd( vLibsDefault,                                           cPre+'gtgui'+cExt )
      aadd( vLibsDefault,                                           cPre+'gtwin'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbdebug'+cExt )
      else
      aadd( vLibsDefault,                                           cPre+'gtgui'+cExt )
      aadd( vLibsDefault,                                           cPre+'gtwin'+cExt )
      endif
      else
      if PUB_bDebugActive
      aadd( vLibsDefault,                                           cPre+'gtgui'+cExt )
      aadd( vLibsDefault,                                           cPre+'gtwin'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbdebug'+cExt )
      else
      aadd( vLibsDefault,                                           cPre+'gtgui'+cExt )
      aadd( vLibsDefault,                                           cPre+'gtwin'+cExt )
      endif
      endif

      aadd( vLibsDefault,                                           cPre+'comctl32'+cExt )
      aadd( vLibsDefault,                                           cPre+'comdlg32'+cExt )
      aadd( vLibsDefault,                                           cPre+'gdi32'+cExt )
      aadd( vLibsDefault,                                           cPre+'iphlpapi'+cExt )
      aadd( vLibsDefault,                                           cPre+'mapi32'+cExt )
      aadd( vLibsDefault,                                           cPre+'mpr'+cExt )
      aadd( vLibsDefault,                                           cPre+'msimg32'+cExt )
      aadd( vLibsDefault,                                           cPre+'ole32'+cExt )
      aadd( vLibsDefault,                                           cPre+'oleaut32'+cExt )
      aadd( vLibsDefault,                                           cPre+'shell32'+cExt )
      aadd( vLibsDefault,                                           cPre+'user32'+cExt )
      aadd( vLibsDefault,                                           cPre+'uuid'+cExt )
      aadd( vLibsDefault,                                           cPre+'vfw32'+cExt )
      aadd( vLibsDefault,                                           cPre+'winmm'+cExt )
      aadd( vLibsDefault,                                           cPre+'winspool'+cExt )
      aadd( vLibsDefault,                                           cPre+'ws2_32'+cExt )
      aadd( vLibsDefault,                                           cPre+'wsock32'+cExt )

      aadd( vLibsDefault,                                           cPre+'bostaurus'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbcommon'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbcpage'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbcplr'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbct'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbextern'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbhpdf'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbhsx'+cExt )
      aadd( vLibsDefault,                                           cPre+'hblang'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbmacro'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbmemio'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbmisc'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbmysql'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbmzip'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbodbc'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbpcre'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbpcre2'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbpp'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbprinter'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbrdd'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbrtl'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbsix'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbtip'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbuddall'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbusrrdd'+cExt )
      if Prj_Check_MT
      aadd( vLibsDefault,                                           cPre+'hbvmmt'+cExt )
      else
      aadd( vLibsDefault,                                           cPre+'hbvm'+cExt )
      endif
      aadd( vLibsDefault,                                           cPre+'hbzebra'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbziparc'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbzlib'+cExt )
      aadd( vLibsDefault,                                           cPre+'hpdf'+cExt )
      aadd( vLibsDefault,                                           cPre+'libharu'+cExt )
      aadd( vLibsDefault,                                           cPre+'libhpdf'+cExt )
      aadd( vLibsDefault,                                           cPre+'libpng'+cExt )
      aadd( vLibsDefault,                                           cPre+'miniprint'+cExt )
      aadd( vLibsDefault,                                           cPre+'minizip'+cExt )
      aadd( vLibsDefault,                                           cPre+'odbc32'+cExt )
      aadd( vLibsDefault,                                           cPre+'png'+cExt )
      aadd( vLibsDefault,                                           cPre+'rddads'+cExt )
      aadd( vLibsDefault,                                           cPre+'rddcdx'+cExt )
      aadd( vLibsDefault,                                           cPre+'rddfpt'+cExt )
      aadd( vLibsDefault,                                           cPre+'rddnsx'+cExt )
      aadd( vLibsDefault,                                           cPre+'rddntx'+cExt )
      aadd( vLibsDefault,                                           cPre+'rddsql'+cExt )
      aadd( vLibsDefault,                                           cPre+'sddodbc'+cExt )
      aadd( vLibsDefault,                                           cPre+'xhb'+cExt )              // must come after haru
      aadd( vLibsDefault,                                           cPre+'hbwin'+cExt )            // must come after haru

   CASE cFlavor == ( DefineOohg3 + DefineMinGW + DefineXHarbour + Define64bits )
      // 16 - OOHG + MinGW + xHarbour, 64 bits
      cPre := "lib"
      cExt := ".a"
      vLibsDefault := {}

      if Prj_Check_Console
      if PUB_bDebugActive
      aadd( vLibsDefault,                                           cPre+'gtgui'+cExt )
      aadd( vLibsDefault,                                           cPre+'gtwin'+cExt )
      aadd( vLibsDefault,                                           cPre+'debug'+cExt )
      else
      aadd( vLibsDefault,                                           cPre+'gtgui'+cExt )
      aadd( vLibsDefault,                                           cPre+'gtwin'+cExt )
      endif
      else
      if PUB_bDebugActive
      aadd( vLibsDefault,                                           cPre+'gtgui'+cExt )
      aadd( vLibsDefault,                                           cPre+'gtwin'+cExt )
      aadd( vLibsDefault,                                           cPre+'debug'+cExt )
      else
      aadd( vLibsDefault,                                           cPre+'gtgui'+cExt )
      aadd( vLibsDefault,                                           cPre+'gtwin'+cExt )
      endif
      endif

      aadd( vLibsDefault,                                           cPre+'comctl32'+cExt )
      aadd( vLibsDefault,                                           cPre+'comdlg32'+cExt )
      aadd( vLibsDefault,                                           cPre+'gdi32'+cExt )
      aadd( vLibsDefault,                                           cPre+'iphlpapi'+cExt )
      aadd( vLibsDefault,                                           cPre+'mapi32'+cExt )
      aadd( vLibsDefault,                                           cPre+'mpr'+cExt )
      aadd( vLibsDefault,                                           cPre+'msimg32'+cExt )
      aadd( vLibsDefault,                                           cPre+'ole32'+cExt )
      aadd( vLibsDefault,                                           cPre+'oleaut32'+cExt )
      aadd( vLibsDefault,                                           cPre+'shell32'+cExt )
      aadd( vLibsDefault,                                           cPre+'user32'+cExt )
      aadd( vLibsDefault,                                           cPre+'uuid'+cExt )
      aadd( vLibsDefault,                                           cPre+'vfw32'+cExt )
      aadd( vLibsDefault,                                           cPre+'winmm'+cExt )
      aadd( vLibsDefault,                                           cPre+'winspool'+cExt )
      aadd( vLibsDefault,                                           cPre+'ws2_32'+cExt )
      aadd( vLibsDefault,                                           cPre+'wsock32'+cExt )

      aadd( vLibsDefault,                                           cPre+'bostaurus'+cExt )
      aadd( vLibsDefault,                                           cPre+'codepage'+cExt )
      aadd( vLibsDefault,                                           cPre+'common'+cExt )
      aadd( vLibsDefault,                                           cPre+'ct'+cExt )
      aadd( vLibsDefault,                                           cPre+'dbfcdx'+cExt )
      aadd( vLibsDefault,                                           cPre+'dbfdbt'+cExt )
      aadd( vLibsDefault,                                           cPre+'dbffpt'+cExt )
      aadd( vLibsDefault,                                           cPre+'dbfntx'+cExt )
      aadd( vLibsDefault,                                           cPre+'dll'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbhpdf'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbmzip'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbprinter'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbsix'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbzebra'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbzip'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbzlib'+cExt )
      aadd( vLibsDefault,                                           cPre+'hpdf'+cExt )
      aadd( vLibsDefault,                                           cPre+'hsx'+cExt )
      aadd( vLibsDefault,                                           cPre+'lang'+cExt )
      aadd( vLibsDefault,                                           cPre+'libharu'+cExt )
      aadd( vLibsDefault,                                           cPre+'libhpdf'+cExt )
      aadd( vLibsDefault,                                           cPre+'libpng'+cExt )
      aadd( vLibsDefault,                                           cPre+'macro'+cExt )
      aadd( vLibsDefault,                                           cPre+'miniprint'+cExt )
      aadd( vLibsDefault,                                           cPre+'mysql'+cExt )
      aadd( vLibsDefault,                                           cPre+'mysqldll'+cExt )
/*    aadd( vLibsDefault,                                           cPre+'nulsys'+cExt )           This generates "multiple definition" error */
      aadd( vLibsDefault,                                           cPre+'pcrepos'+cExt )
      aadd( vLibsDefault,                                           cPre+'png'+cExt )
      aadd( vLibsDefault,                                           cPre+'pp'+cExt )
      aadd( vLibsDefault,                                           cPre+'rdd'+cExt )
      aadd( vLibsDefault,                                           cPre+'rtl'+cExt )
      aadd( vLibsDefault,                                           cPre+'socket'+cExt )
      aadd( vLibsDefault,                                           cPre+'stdc++'+cExt )
      aadd( vLibsDefault,                                           cPre+'tip'+cExt )
      aadd( vLibsDefault,                                           cPre+'usrrdd'+cExt )
      if Prj_Check_MT
      aadd( vLibsDefault,                                           cPre+'vmmt'+cExt )
      else
      aadd( vLibsDefault,                                           cPre+'vm'+cExt )
      endif
      aadd( vLibsDefault,                                           cPre+'xCrypt'+cExt )
      aadd( vLibsDefault,                                           cPre+'xEdit'+cExt )
      aadd( vLibsDefault,                                           cPre+'xEditex'+cExt )
      aadd( vLibsDefault,                                           cPre+'xGraph'+cExt )
      aadd( vLibsDefault,                                           cPre+'xIni'+cExt )
      aadd( vLibsDefault,                                           cPre+'xRegistry'+cExt )
      aadd( vLibsDefault,                                           cPre+'xReport'+cExt )
      aadd( vLibsDefault,                                           cPre+'zlib1'+cExt )

   CASE cFlavor == ( DefineOohg3 + DefinePelles + DefineHarbour + Define32bits )
      // 17 - OOHG + Pelles C + Harbour, 32 bits
      cPre := ""
      cExt := ".lib"
      vLibsDefault := {}
      if Prj_Check_Console
      if PUB_bDebugActive
      aadd( vLibsDefault,                                           cPre+'gtgui'+cExt )
      aadd( vLibsDefault,                                           cPre+'gtwin'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbdebug'+cExt )
      else
      aadd( vLibsDefault,                                           cPre+'gtgui'+cExt )
      aadd( vLibsDefault,                                           cPre+'gtwin'+cExt )
      endif
      else
      if PUB_bDebugActive
      aadd( vLibsDefault,                                           cPre+'gtgui'+cExt )
      aadd( vLibsDefault,                                           cPre+'gtwin'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbdebug'+cExt )
      else
      aadd( vLibsDefault,                                           cPre+'gtgui'+cExt )
      aadd( vLibsDefault,                                           cPre+'gtwin'+cExt )
      endif
      endif

      aadd( vLibsDefault,                                           cPre+'comctl32'+cExt )
      aadd( vLibsDefault,                                           cPre+'comdlg32'+cExt )
      aadd( vLibsDefault,                                           cPre+'gdi32'+cExt )
      aadd( vLibsDefault,                                           cPre+'iphlpapi'+cExt )
      aadd( vLibsDefault,                                           cPre+'mapi32'+cExt )
      aadd( vLibsDefault,                                           cPre+'mpr'+cExt )
      aadd( vLibsDefault,                                           cPre+'msimg32'+cExt )
      aadd( vLibsDefault,                                           cPre+'ole32'+cExt )
      aadd( vLibsDefault,                                           cPre+'oleaut32'+cExt )
      aadd( vLibsDefault,                                           cPre+'shell32'+cExt )
      aadd( vLibsDefault,                                           cPre+'user32'+cExt )
      aadd( vLibsDefault,                                           cPre+'uuid'+cExt )
      aadd( vLibsDefault,                                           cPre+'vfw32'+cExt )
      aadd( vLibsDefault,                                           cPre+'winmm'+cExt )            // must come before kernel32
      aadd( vLibsDefault,                                           cPre+'winspool'+cExt )
      aadd( vLibsDefault,                                           cPre+'ws2_32'+cExt )
      aadd( vLibsDefault,                                           cPre+'wsock32'+cExt )

      aadd( vLibsDefault,                                           cPre+'ace32'+cExt )
      aadd( vLibsDefault,                                           cPre+'bostaurus'+cExt )
      aadd( vLibsDefault,                                           cPre+'advapi32'+cExt )
      aadd( vLibsDefault,                                           cPre+'crt'+cExt )
      aadd( vLibsDefault,                                           cPre+'dll'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbcommon'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbcpage'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbct'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbhpdf'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbhsx'+cExt )
      aadd( vLibsDefault,                                           cPre+'hblang'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbmacro'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbmzip'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbole'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbpcre'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbpcre2'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbpp'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbprinter'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbrdd'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbrtl'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbsix'+cExt )
      if Prj_Check_MT
      aadd( vLibsDefault,                                           cPre+'hbvmmt'+cExt )
      else
      aadd( vLibsDefault,                                           cPre+'hbvm'+cExt )
      endif
      aadd( vLibsDefault,                                           cPre+'hbw32'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbzebra'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbzip'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbziparc'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbziparch'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbzlib'+cExt )
      aadd( vLibsDefault,                                           cPre+'hpdf'+cExt )
      aadd( vLibsDefault,                                           cPre+'kernel32'+cExt )
      aadd( vLibsDefault,                                           cPre+'libct'+cExt )
      aadd( vLibsDefault,                                           cPre+'libharu'+cExt )
      aadd( vLibsDefault,                                           cPre+'libhpdf'+cExt )
      aadd( vLibsDefault,                                           cPre+'libmisc'+cExt )
      aadd( vLibsDefault,                                           cPre+'libmysql'+cExt )
      aadd( vLibsDefault,                                           cPre+'libpng'+cExt )
      aadd( vLibsDefault,                                           cPre+'miniprint'+cExt )
      aadd( vLibsDefault,                                           cPre+'minizip'+cExt )
      aadd( vLibsDefault,                                           cPre+'mysql'+cExt )
      aadd( vLibsDefault,                                           cPre+'olepro32'+cExt )
      aadd( vLibsDefault,                                           cPre+'pcrepos'+cExt )
      aadd( vLibsDefault,                                           cPre+'png'+cExt )
      aadd( vLibsDefault,                                           cPre+'rddads'+cExt )
      aadd( vLibsDefault,                                           cPre+'rddcdx'+cExt )
      aadd( vLibsDefault,                                           cPre+'rdddbt'+cExt )
      aadd( vLibsDefault,                                           cPre+'rddfpt'+cExt )
      aadd( vLibsDefault,                                           cPre+'rddntx'+cExt )
      aadd( vLibsDefault,                                           cPre+'socket'+cExt )
      aadd( vLibsDefault,                                           cPre+'tip'+cExt )
      aadd( vLibsDefault,                                           cPre+'xhb'+cExt )              // must come after haru
      aadd( vLibsDefault,                                           cPre+'zlib1'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbwin'+cExt )            // must come after haru

   CASE cFlavor == ( DefineOohg3 + DefinePelles + DefineXHarbour + Define32bits )
      // 18 - OOHG + Pelles C + xHarbour, 32 bits
      cPre := ""
      cExt := ".lib"
      vLibsDefault := {}

      if Prj_Check_Console
      if PUB_bDebugActive
      aadd( vLibsDefault,                                           cPre+'gtgui'+cExt )
      aadd( vLibsDefault,                                           cPre+'gtwin'+cExt )
      aadd( vLibsDefault,                                           cPre+'debug'+cExt )
      else
      aadd( vLibsDefault,                                           cPre+'gtgui'+cExt )
      aadd( vLibsDefault,                                           cPre+'gtwin'+cExt )
      endif
      else
      if PUB_bDebugActive
      aadd( vLibsDefault,                                           cPre+'gtgui'+cExt )
      aadd( vLibsDefault,                                           cPre+'gtwin'+cExt )
      aadd( vLibsDefault,                                           cPre+'debug'+cExt )
      else
      aadd( vLibsDefault,                                           cPre+'gtgui'+cExt )
      aadd( vLibsDefault,                                           cPre+'gtwin'+cExt )
      endif
      endif

      aadd( vLibsDefault,                                           cPre+'comctl32'+cExt )
      aadd( vLibsDefault,                                           cPre+'comdlg32'+cExt )
      aadd( vLibsDefault,                                           cPre+'gdi32'+cExt )
      aadd( vLibsDefault,                                           cPre+'iphlpapi'+cExt )
      aadd( vLibsDefault,                                           cPre+'mapi32'+cExt )
      aadd( vLibsDefault,                                           cPre+'mpr'+cExt )
      aadd( vLibsDefault,                                           cPre+'msimg32'+cExt )
      aadd( vLibsDefault,                                           cPre+'ole32'+cExt )
      aadd( vLibsDefault,                                           cPre+'oleaut32'+cExt )
      aadd( vLibsDefault,                                           cPre+'shell32'+cExt )
      aadd( vLibsDefault,                                           cPre+'user32'+cExt )
      aadd( vLibsDefault,                                           cPre+'uuid'+cExt )
      aadd( vLibsDefault,                                           cPre+'vfw32'+cExt )
      aadd( vLibsDefault,                                           cPre+'winmm'+cExt )
      aadd( vLibsDefault,                                           cPre+'winspool'+cExt )
      aadd( vLibsDefault,                                           cPre+'ws2_32'+cExt )
      aadd( vLibsDefault,                                           cPre+'wsock32'+cExt )

      aadd( vLibsDefault,                                           cPre+'ace32'+cExt )
      aadd( vLibsDefault,                                           cPre+'bostaurus'+cExt )
      aadd( vLibsDefault,                                           cPre+'advapi32'+cExt )
      aadd( vLibsDefault,                                           cPre+'codepage'+cExt )
      aadd( vLibsDefault,                                           cPre+'common'+cExt )
      aadd( vLibsDefault,                                           cPre+'crt'+cExt )
      aadd( vLibsDefault,                                           cPre+'ct'+cExt )
      aadd( vLibsDefault,                                           cPre+'dbfcdx'+cExt )
      aadd( vLibsDefault,                                           cPre+'dbfdbt'+cExt )
      aadd( vLibsDefault,                                           cPre+'dbffpt'+cExt )
      aadd( vLibsDefault,                                           cPre+'dbfntx'+cExt )
      aadd( vLibsDefault,                                           cPre+'dll'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbhpdf'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbmzip'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbole'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbprinter'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbsix'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbzebra'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbzip'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbzlib'+cExt )
      aadd( vLibsDefault,                                           cPre+'hpdf'+cExt )
      aadd( vLibsDefault,                                           cPre+'hsx'+cExt )
      aadd( vLibsDefault,                                           cPre+'kernel32'+cExt )
      aadd( vLibsDefault,                                           cPre+'lang'+cExt )
      aadd( vLibsDefault,                                           cPre+'libct'+cExt )
      aadd( vLibsDefault,                                           cPre+'libharu'+cExt )
      aadd( vLibsDefault,                                           cPre+'libhpdf'+cExt )
      aadd( vLibsDefault,                                           cPre+'libmisc'+cExt )
      aadd( vLibsDefault,                                           cPre+'libmysql'+cExt )
      aadd( vLibsDefault,                                           cPre+'libpng'+cExt )
      aadd( vLibsDefault,                                           cPre+'macro'+cExt )
      aadd( vLibsDefault,                                           cPre+'miniprint'+cExt )
      aadd( vLibsDefault,                                           cPre+'mysql'+cExt )
      aadd( vLibsDefault,                                           cPre+'olepro32'+cExt )
      aadd( vLibsDefault,                                           cPre+'pcrepos'+cExt )
      aadd( vLibsDefault,                                           cPre+'png'+cExt )
      aadd( vLibsDefault,                                           cPre+'pp'+cExt )
      aadd( vLibsDefault,                                           cPre+'rdd'+cExt )
      aadd( vLibsDefault,                                           cPre+'rddads'+cExt )
      aadd( vLibsDefault,                                           cPre+'rtl'+cExt )
      aadd( vLibsDefault,                                           cPre+'socket'+cExt )
      aadd( vLibsDefault,                                           cPre+'tip'+cExt )
      if Prj_Check_MT
      aadd( vLibsDefault,                                           cPre+'vmmt'+cExt )
      else
      aadd( vLibsDefault,                                           cPre+'vm'+cExt )
      endif
      aadd( vLibsDefault,                                           cPre+'zlib1'+cExt )

   CASE cFlavor == ( DefineOohg3 + DefinePelles + DefineHarbour + Define64bits )
      // 19 - OOHG + Pelles C + Harbour, 64 bits
      cPre := ""
      cExt := ".lib"
      vLibsDefault := {}

      if Prj_Check_Console
      if PUB_bDebugActive
      aadd( vLibsDefault,                                           cPre+'gtgui'+cExt )
      aadd( vLibsDefault,                                           cPre+'gtwin'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbdebug'+cExt )
      else
      aadd( vLibsDefault,                                           cPre+'gtgui'+cExt )
      aadd( vLibsDefault,                                           cPre+'gtwin'+cExt )
      endif
      else
      if PUB_bDebugActive
      aadd( vLibsDefault,                                           cPre+'gtgui'+cExt )
      aadd( vLibsDefault,                                           cPre+'gtwin'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbdebug'+cExt )
      else
      aadd( vLibsDefault,                                           cPre+'gtgui'+cExt )
      aadd( vLibsDefault,                                           cPre+'gtwin'+cExt )
      endif
      endif

      aadd( vLibsDefault,                                           cPre+'comctl32'+cExt )
      aadd( vLibsDefault,                                           cPre+'comdlg32'+cExt )
      aadd( vLibsDefault,                                           cPre+'gdi32'+cExt )
      aadd( vLibsDefault,                                           cPre+'iphlpapi'+cExt )
      aadd( vLibsDefault,                                           cPre+'mapi32'+cExt )
      aadd( vLibsDefault,                                           cPre+'mpr'+cExt )
      aadd( vLibsDefault,                                           cPre+'msimg32'+cExt )
      aadd( vLibsDefault,                                           cPre+'ole32'+cExt )
      aadd( vLibsDefault,                                           cPre+'oleaut32'+cExt )
      aadd( vLibsDefault,                                           cPre+'shell32'+cExt )
      aadd( vLibsDefault,                                           cPre+'user32'+cExt )
      aadd( vLibsDefault,                                           cPre+'uuid'+cExt )
      aadd( vLibsDefault,                                           cPre+'vfw32'+cExt )
      aadd( vLibsDefault,                                           cPre+'winmm'+cExt )
      aadd( vLibsDefault,                                           cPre+'winspool'+cExt )
      aadd( vLibsDefault,                                           cPre+'ws2_32'+cExt )
      aadd( vLibsDefault,                                           cPre+'wsock32'+cExt )

      aadd( vLibsDefault,                                           cPre+'ace32'+cExt )
      aadd( vLibsDefault,                                           cPre+'bostaurus'+cExt )
      aadd( vLibsDefault,                                           cPre+'advapi32'+cExt )
      aadd( vLibsDefault,                                           cPre+'crt'+cExt )
      aadd( vLibsDefault,                                           cPre+'dll'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbcommon'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbcpage'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbct'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbhpdf'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbhsx'+cExt )
      aadd( vLibsDefault,                                           cPre+'hblang'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbmacro'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbmzip'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbole'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbpcre'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbpcre2'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbpp'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbprinter'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbrdd'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbrtl'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbsix'+cExt )
      if Prj_Check_MT
      aadd( vLibsDefault,                                           cPre+'hbvmmt'+cExt )
      else
      aadd( vLibsDefault,                                           cPre+'hbvm'+cExt )
      endif
      aadd( vLibsDefault,                                           cPre+'hbw32'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbzebra'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbzip'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbziparc'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbziparch'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbzlib'+cExt )
      aadd( vLibsDefault,                                           cPre+'hpdf'+cExt )
      aadd( vLibsDefault,                                           cPre+'kernel32'+cExt )
      aadd( vLibsDefault,                                           cPre+'libct'+cExt )
      aadd( vLibsDefault,                                           cPre+'libharu'+cExt )
      aadd( vLibsDefault,                                           cPre+'libhpdf'+cExt )
      aadd( vLibsDefault,                                           cPre+'libmisc'+cExt )
      aadd( vLibsDefault,                                           cPre+'libmysql'+cExt )
      aadd( vLibsDefault,                                           cPre+'libpng'+cExt )
      aadd( vLibsDefault,                                           cPre+'miniprint'+cExt )
      aadd( vLibsDefault,                                           cPre+'minizip'+cExt )
      aadd( vLibsDefault,                                           cPre+'mysql'+cExt )
      aadd( vLibsDefault,                                           cPre+'olepro32'+cExt )
      aadd( vLibsDefault,                                           cPre+'pcrepos'+cExt )
      aadd( vLibsDefault,                                           cPre+'png'+cExt )
      aadd( vLibsDefault,                                           cPre+'rddads'+cExt )
      aadd( vLibsDefault,                                           cPre+'rddcdx'+cExt )
      aadd( vLibsDefault,                                           cPre+'rdddbt'+cExt )
      aadd( vLibsDefault,                                           cPre+'rddfpt'+cExt )
      aadd( vLibsDefault,                                           cPre+'rddntx'+cExt )
      aadd( vLibsDefault,                                           cPre+'socket'+cExt )
      aadd( vLibsDefault,                                           cPre+'tip'+cExt )
      aadd( vLibsDefault,                                           cPre+'xhb'+cExt )              // must come after haru
      aadd( vLibsDefault,                                           cPre+'zlib1'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbwin'+cExt )            // must come after haru

   CASE cFlavor == ( DefineOohg3 + DefinePelles + DefineXHarbour + Define64bits )
      // 20 - OOHG + Pelles C + xHarbour, 64 bits
      cPre := ""
      cExt := ".lib"
      vLibsDefault := {}

      if Prj_Check_Console
      if PUB_bDebugActive
      aadd( vLibsDefault,                                           cPre+'gtgui'+cExt )
      aadd( vLibsDefault,                                           cPre+'gtwin'+cExt )
      aadd( vLibsDefault,                                           cPre+'debug'+cExt )
      else
      aadd( vLibsDefault,                                           cPre+'gtgui'+cExt )
      aadd( vLibsDefault,                                           cPre+'gtwin'+cExt )
      endif
      else
      if PUB_bDebugActive
      aadd( vLibsDefault,                                           cPre+'gtgui'+cExt )
      aadd( vLibsDefault,                                           cPre+'gtwin'+cExt )
      aadd( vLibsDefault,                                           cPre+'debug'+cExt )
      else
      aadd( vLibsDefault,                                           cPre+'gtgui'+cExt )
      aadd( vLibsDefault,                                           cPre+'gtwin'+cExt )
      endif
      endif

      aadd( vLibsDefault,                                           cPre+'comctl32'+cExt )
      aadd( vLibsDefault,                                           cPre+'comdlg32'+cExt )
      aadd( vLibsDefault,                                           cPre+'gdi32'+cExt )
      aadd( vLibsDefault,                                           cPre+'iphlpapi'+cExt )
      aadd( vLibsDefault,                                           cPre+'mapi32'+cExt )
      aadd( vLibsDefault,                                           cPre+'mpr'+cExt )
      aadd( vLibsDefault,                                           cPre+'msimg32'+cExt )
      aadd( vLibsDefault,                                           cPre+'ole32'+cExt )
      aadd( vLibsDefault,                                           cPre+'oleaut32'+cExt )
      aadd( vLibsDefault,                                           cPre+'shell32'+cExt )
      aadd( vLibsDefault,                                           cPre+'user32'+cExt )
      aadd( vLibsDefault,                                           cPre+'uuid'+cExt )
      aadd( vLibsDefault,                                           cPre+'vfw32'+cExt )
      aadd( vLibsDefault,                                           cPre+'winmm'+cExt )
      aadd( vLibsDefault,                                           cPre+'winspool'+cExt )
      aadd( vLibsDefault,                                           cPre+'ws2_32'+cExt )
      aadd( vLibsDefault,                                           cPre+'wsock32'+cExt )

      aadd( vLibsDefault,                                           cPre+'ace32'+cExt )
      aadd( vLibsDefault,                                           cPre+'bostaurus'+cExt )
      aadd( vLibsDefault,                                           cPre+'advapi32'+cExt )
      aadd( vLibsDefault,                                           cPre+'codepage'+cExt )
      aadd( vLibsDefault,                                           cPre+'common'+cExt )
      aadd( vLibsDefault,                                           cPre+'crt'+cExt )
      aadd( vLibsDefault,                                           cPre+'ct'+cExt )
      aadd( vLibsDefault,                                           cPre+'dbfcdx'+cExt )
      aadd( vLibsDefault,                                           cPre+'dbfdbt'+cExt )
      aadd( vLibsDefault,                                           cPre+'dbffpt'+cExt )
      aadd( vLibsDefault,                                           cPre+'dbfntx'+cExt )
      aadd( vLibsDefault,                                           cPre+'dll'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbhpdf'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbmzip'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbole'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbprinter'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbsix'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbzip'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbzebra'+cExt )
      aadd( vLibsDefault,                                           cPre+'hbzlib'+cExt )
      aadd( vLibsDefault,                                           cPre+'hpdf'+cExt )
      aadd( vLibsDefault,                                           cPre+'hsx'+cExt )
      aadd( vLibsDefault,                                           cPre+'kernel32'+cExt )
      aadd( vLibsDefault,                                           cPre+'lang'+cExt )
      aadd( vLibsDefault,                                           cPre+'libct'+cExt )
      aadd( vLibsDefault,                                           cPre+'libharu'+cExt )
      aadd( vLibsDefault,                                           cPre+'libhpdf'+cExt )
      aadd( vLibsDefault,                                           cPre+'libmisc'+cExt )
      aadd( vLibsDefault,                                           cPre+'libmysql'+cExt )
      aadd( vLibsDefault,                                           cPre+'libpng'+cExt )
      aadd( vLibsDefault,                                           cPre+'macro'+cExt )
      aadd( vLibsDefault,                                           cPre+'miniprint'+cExt )
      aadd( vLibsDefault,                                           cPre+'mysql'+cExt )
      aadd( vLibsDefault,                                           cPre+'olepro32'+cExt )
      aadd( vLibsDefault,                                           cPre+'pcrepos'+cExt )
      aadd( vLibsDefault,                                           cPre+'png'+cExt )
      aadd( vLibsDefault,                                           cPre+'pp'+cExt )
      aadd( vLibsDefault,                                           cPre+'rdd'+cExt )
      aadd( vLibsDefault,                                           cPre+'rddads'+cExt )
      aadd( vLibsDefault,                                           cPre+'rtl'+cExt )
      aadd( vLibsDefault,                                           cPre+'socket'+cExt )
      aadd( vLibsDefault,                                           cPre+'tip'+cExt )
      if Prj_Check_MT
      aadd( vLibsDefault,                                           cPre+'vmmt'+cExt )
      else
      aadd( vLibsDefault,                                           cPre+'vm'+cExt )
      endif
      aadd( vLibsDefault,                                           cPre+'zlib1'+cExt )

   ENDCASE

Return .T.

/* eof */
