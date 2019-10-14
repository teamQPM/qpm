/*
 * $Id$
 */

/*
 *    QPM - QAC based Project Manager
 *
 *    Copyright 2011-2019 Fernando Yurisich <fernando.yurisich@gmail.com>
 *    https://qpm.sourceforge.io/
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

Function QPM_CargoLibraries()
   Local bOldNamesLib := QPM_IsLibrariesNamesOld( US_ShortName( GetHarbourFolder() ), GetSuffix() )
   Local cPre, cExt

   // 1 - HMG 1.x + BCC + Harbour
   cPre := ""
   cExt := ".lib"
   &( "vLibDefault"+DefineMiniGui1+DefineBorland+DefineHarbour+Define32bits ) := {}
   if Prj_Check_Console
   if PUB_bDebugActive
   aadd( &( "vLibDefault"+DefineMiniGui1+DefineBorland+DefineHarbour+Define32bits ),                                           cPre+'gtwin'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui1+DefineBorland+DefineHarbour+Define32bits ), if( bOldNamesLib, cPre+'debug'+cExt,      cPre+'hbdebug'+cExt ) )
   else
   aadd( &( "vLibDefault"+DefineMiniGui1+DefineBorland+DefineHarbour+Define32bits ),                                           cPre+'gtwin'+cExt )
   endif
   else
   if PUB_bDebugActive
   aadd( &( "vLibDefault"+DefineMiniGui1+DefineBorland+DefineHarbour+Define32bits ),                                           cPre+'gtgui'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui1+DefineBorland+DefineHarbour+Define32bits ),                                           cPre+'gtwin'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui1+DefineBorland+DefineHarbour+Define32bits ), if( bOldNamesLib, cPre+'debug'+cExt,      cPre+'debug'+cExt ) )
   else
   aadd( &( "vLibDefault"+DefineMiniGui1+DefineBorland+DefineHarbour+Define32bits ),                                           cPre+'gtgui'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui1+DefineBorland+DefineHarbour+Define32bits ),                                           cPre+'gtwin'+cExt )
   endif
   endif

   if Prj_Check_MT
   aadd( &( "vLibDefault"+DefineMiniGui1+DefineBorland+DefineHarbour+Define32bits ), cPre+'cw32mt'+cExt )
   else
   aadd( &( "vLibDefault"+DefineMiniGui1+DefineBorland+DefineHarbour+Define32bits ), cPre+'cw32'+cExt )
   endif
   aadd( &( "vLibDefault"+DefineMiniGui1+DefineBorland+DefineHarbour+Define32bits ), cPre+'comctl32'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui1+DefineBorland+DefineHarbour+Define32bits ), cPre+'comdlg32'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui1+DefineBorland+DefineHarbour+Define32bits ), cPre+'gdi32'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui1+DefineBorland+DefineHarbour+Define32bits ), cPre+'import32'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui1+DefineBorland+DefineHarbour+Define32bits ), cPre+'iphlpapi'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui1+DefineBorland+DefineHarbour+Define32bits ), cPre+'mapi32'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui1+DefineBorland+DefineHarbour+Define32bits ), cPre+'mpr'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui1+DefineBorland+DefineHarbour+Define32bits ), cPre+'msimg32'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui1+DefineBorland+DefineHarbour+Define32bits ), cPre+'ole32'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui1+DefineBorland+DefineHarbour+Define32bits ), cPre+'oleaut32'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui1+DefineBorland+DefineHarbour+Define32bits ), cPre+'shell32'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui1+DefineBorland+DefineHarbour+Define32bits ), cPre+'user32'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui1+DefineBorland+DefineHarbour+Define32bits ), cPre+'uuid'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui1+DefineBorland+DefineHarbour+Define32bits ), cPre+'vfw32'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui1+DefineBorland+DefineHarbour+Define32bits ), cPre+'winmm'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui1+DefineBorland+DefineHarbour+Define32bits ), cPre+'winspool'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui1+DefineBorland+DefineHarbour+Define32bits ), cPre+'ws2_32'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui1+DefineBorland+DefineHarbour+Define32bits ), cPre+'wsock32'+cExt )

   aadd( &( "vLibDefault"+DefineMiniGui1+DefineBorland+DefineHarbour+Define32bits ),                                           cPre+'ace32'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui1+DefineBorland+DefineHarbour+Define32bits ),                                           cPre+'ct'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui1+DefineBorland+DefineHarbour+Define32bits ),                                           cPre+'dll'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui1+DefineBorland+DefineHarbour+Define32bits ), if( bOldNamesLib, cPre+'common'+cExt,     cPre+'hbcommon'+cExt ) )
   aadd( &( "vLibDefault"+DefineMiniGui1+DefineBorland+DefineHarbour+Define32bits ), if( bOldNamesLib, cPre+'codepage'+cExt,   cPre+'hbcpage'+cExt ) )
   aadd( &( "vLibDefault"+DefineMiniGui1+DefineBorland+DefineHarbour+Define32bits ),                                           cPre+'hbhpdf'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui1+DefineBorland+DefineHarbour+Define32bits ), if( bOldNamesLib, cPre+'hsx'+cExt,        cPre+'hbhsx'+cExt ) )
   aadd( &( "vLibDefault"+DefineMiniGui1+DefineBorland+DefineHarbour+Define32bits ), if( bOldNamesLib, cPre+'lang'+cExt,       cPre+'hblang'+cExt ) )
   aadd( &( "vLibDefault"+DefineMiniGui1+DefineBorland+DefineHarbour+Define32bits ), if( bOldNamesLib, cPre+'macro'+cExt,      cPre+'hbmacro'+cExt ) )
   aadd( &( "vLibDefault"+DefineMiniGui1+DefineBorland+DefineHarbour+Define32bits ),                                           cPre+'hbole'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui1+DefineBorland+DefineHarbour+Define32bits ), if( bOldNamesLib, cPre+'pp'+cExt,         cPre+'hbpp'+cExt ) )
   aadd( &( "vLibDefault"+DefineMiniGui1+DefineBorland+DefineHarbour+Define32bits ),                                           cPre+'hbprinter'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui1+DefineBorland+DefineHarbour+Define32bits ), if( bOldNamesLib, cPre+'rdd'+cExt,        cPre+'hbrdd'+cExt ) )
   aadd( &( "vLibDefault"+DefineMiniGui1+DefineBorland+DefineHarbour+Define32bits ), if( bOldNamesLib, cPre+'rtl'+cExt,        cPre+'hbrtl'+cExt ) )
   aadd( &( "vLibDefault"+DefineMiniGui1+DefineBorland+DefineHarbour+Define32bits ), if( bOldNamesLib, cPre+'hbsix'+cExt,      cPre+'hbsix'+cExt ) )
   if Prj_Check_MT
   aadd( &( "vLibDefault"+DefineMiniGui1+DefineBorland+DefineHarbour+Define32bits ), if( bOldNamesLib, cPre+'vmmt'+cExt,       cPre+'hbvmmt'+cExt ) )
   else
   aadd( &( "vLibDefault"+DefineMiniGui1+DefineBorland+DefineHarbour+Define32bits ), if( bOldNamesLib, cPre+'vm'+cExt,         cPre+'hbvm'+cExt ) )
   endif
   aadd( &( "vLibDefault"+DefineMiniGui1+DefineBorland+DefineHarbour+Define32bits ),                                           cPre+'hbzebra'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui1+DefineBorland+DefineHarbour+Define32bits ),                                           cPre+'hbzip'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui1+DefineBorland+DefineHarbour+Define32bits ),                                           cPre+'hbziparc'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui1+DefineBorland+DefineHarbour+Define32bits ), if( bOldNamesLib, cPre+'ziparchive'+cExt, cPre+'hbziparch'+cExt ) )
   aadd( &( "vLibDefault"+DefineMiniGui1+DefineBorland+DefineHarbour+Define32bits ),                                           cPre+'hpdf'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui1+DefineBorland+DefineHarbour+Define32bits ),                                           cPre+'libct'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui1+DefineBorland+DefineHarbour+Define32bits ),                                           cPre+'libharu'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui1+DefineBorland+DefineHarbour+Define32bits ),                                           cPre+'libhpdf'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui1+DefineBorland+DefineHarbour+Define32bits ),                                           cPre+'libmisc'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui1+DefineBorland+DefineHarbour+Define32bits ),                                           cPre+'libmysql'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui1+DefineBorland+DefineHarbour+Define32bits ),                                           cPre+'libpng'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui1+DefineBorland+DefineHarbour+Define32bits ),                                           cPre+'miniprint'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui1+DefineBorland+DefineHarbour+Define32bits ),                                           cPre+'mysql'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui1+DefineBorland+DefineHarbour+Define32bits ),                                           cPre+'pcrepos'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui1+DefineBorland+DefineHarbour+Define32bits ),                                           cPre+'png'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui1+DefineBorland+DefineHarbour+Define32bits ),                                           cPre+'rddads'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui1+DefineBorland+DefineHarbour+Define32bits ), if( bOldNamesLib, cPre+'dbfcdx'+cExt,     cPre+'rddcdx'+cExt ) )
   aadd( &( "vLibDefault"+DefineMiniGui1+DefineBorland+DefineHarbour+Define32bits ), if( bOldNamesLib, cPre+'dbfdbt'+cExt,     cPre+'rdddbt'+cExt ) )
   aadd( &( "vLibDefault"+DefineMiniGui1+DefineBorland+DefineHarbour+Define32bits ), if( bOldNamesLib, cPre+'dbffpt'+cExt,     cPre+'rddfpt'+cExt ) )
   aadd( &( "vLibDefault"+DefineMiniGui1+DefineBorland+DefineHarbour+Define32bits ), if( bOldNamesLib, cPre+'dbfntx'+cExt,     cPre+'rddntx'+cExt ) )
   aadd( &( "vLibDefault"+DefineMiniGui1+DefineBorland+DefineHarbour+Define32bits ),                                           cPre+'socket'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui1+DefineBorland+DefineHarbour+Define32bits ),                                           cPre+'tip'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui1+DefineBorland+DefineHarbour+Define32bits ),                                           cPre+'zlib1'+cExt )

   // 2 - HMG 1.x + BCC + xHarbour
   cPre := ""
   cExt := ".lib"
   &( "vLibDefault"+DefineMiniGui1+DefineBorland+DefineXHarbour+Define32bits ) := {}
   if Prj_Check_Console
   if PUB_bDebugActive
   aadd( &( "vLibDefault"+DefineMiniGui1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'gtwin'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'debug'+cExt )
   else
   aadd( &( "vLibDefault"+DefineMiniGui1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'gtwin'+cExt )
   endif
   else
   if PUB_bDebugActive
   aadd( &( "vLibDefault"+DefineMiniGui1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'gtgui'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'gtwin'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'debug'+cExt )
   else
   aadd( &( "vLibDefault"+DefineMiniGui1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'gtgui'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'gtwin'+cExt )
   endif
   endif

   if Prj_Check_MT
   aadd( &( "vLibDefault"+DefineMiniGui1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'cw32mt'+cExt )
   else
   aadd( &( "vLibDefault"+DefineMiniGui1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'cw32'+cExt )
   endif
   aadd( &( "vLibDefault"+DefineMiniGui1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'comctl32'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'comdlg32'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'gdi32'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'import32'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'iphlpapi'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'mapi32'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'mpr'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'msimg32'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'ole32'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'oleaut32'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'shell32'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'user32'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'uuid'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'vfw32'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'winmm'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'winspool'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'ws2_32'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'wsock32'+cExt )

   aadd( &( "vLibDefault"+DefineMiniGui1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'ace32'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'codepage'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'common'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'ct'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'dbfcdx'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'dbfdbt'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'dbffpt'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'dbfntx'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'dll'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'hbhpdf'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'hbole'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'hbprinter'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'hbsix'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'hbzebra'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'hbzip'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'hpdf'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'hsx'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'lang'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'libct'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'libharu'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'libhpdf'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'libmisc'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'libmysql'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'libpng'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'macro'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'miniprint'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'mysql'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'pcrepos'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'png'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'pp'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'rdd'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'rddads'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'rtl'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'socket'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'tip'+cExt )
   if Prj_Check_MT
   aadd( &( "vLibDefault"+DefineMiniGui1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'vmmt'+cExt )
   else
   aadd( &( "vLibDefault"+DefineMiniGui1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'vm'+cExt )
   endif
   aadd( &( "vLibDefault"+DefineMiniGui1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'zlib'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'zlib1'+cExt )

   // 3 - HMG 3.x + MinGW + Harbour, 32 bits
   cPre := "lib"
   cExt := ".a"
   &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define32bits ) := {}
   if Prj_Check_Console
   if PUB_bDebugActive
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'gtwin'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'hbdebug'+cExt )
   else
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'gtwin'+cExt )
   endif
   else
   if PUB_bDebugActive
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'gtgui'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'debugger'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'hbdebug'+cExt )
   else
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'gtgui'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'gtwin'+cExt )
   endif
   endif

   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'comctl32'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'comdlg32'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'gdi32'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'iphlpapi'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'mapi32'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'mpr'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'msimg32'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'ole32'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'oleaut32'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'shell32'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'user32'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'uuid'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'vfw32'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'winmm'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'winspool'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'ws2_32'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'wsock32'+cExt )

   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'ace32'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'crypt'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'dll'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'edit'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'editex'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'graph'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'hbapollo'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'hbbmcdx'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'hbbtree'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'hbclipsm'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'hbcommon'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'hbcpage'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'hbcplr'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'hbct'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'hbcurl'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'hbfbird'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'hbgd'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'hbhpdf'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'hbhsx'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'hblang'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'hbmacro'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'hbmainstd'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'hbmisc'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'hbmzip'+cExt )
/* aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'hbnulsys'+cExt )   this generates "multiple definition" error */
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'hbole'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'hbpcre'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'hbpcre2'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'hbpp'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'hbprinter'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'hbrdd'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'hbrtl'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'hbsix'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'hbsqlit3'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'hbusrrdd'+cExt )
   if Prj_Check_MT
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'hbvmmt'+cExt )
   else
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'hbvm'+cExt )
   endif
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'hbw32'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'hbxml'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'hbzebra'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'hbziparc'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'hbziparch'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'hbzlib'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'hpdf'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'ini'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'libharu'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'libhpdf'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'libpng'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'miniprint'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'minizip'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'mysql'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'mysqldll'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'pcrepos'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'png'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'rddads'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'rddcdx'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'rdddbt'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'rddfpt'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'rddntx'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'registry'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'report'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'socket'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'sqlite3'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'stdc++'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'tip'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'xhb'+cExt )  // must come after haru
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'hbwin'+cExt )   // must come after haru

   // 4 - HMG 3.x + MinGW + Harbour, 64 bits
   cPre := "lib"
   cExt := ".a"
   &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define64bits ) := {}
   if Prj_Check_Console
   if PUB_bDebugActive
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'gtwin'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'hbdebug'+cExt )
   else
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'gtwin'+cExt )
   endif
   else
   if PUB_bDebugActive
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'gtgui'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'hbdebug'+cExt )
   else
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'gtgui'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'gtwin'+cExt )
   endif
   endif

   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'comctl32'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'comdlg32'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'gdi32'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'iphlpapi'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'mapi32'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'mpr'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'msimg32'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'ole32'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'oleaut32'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'shell32'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'user32'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'uuid'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'vfw32'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'winmm'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'winspool'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'ws2_32'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'wsock32'+cExt )

   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'ace32'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'crypt'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'dll'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'edit'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'editex'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'graph'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'hbapollo'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'hbbmcdx'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'hbbtree'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'hbclipsm'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'hbcommon'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'hbcpage'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'hbcplr'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'hbct'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'hbcurl'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'hbfbird'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'hbgd'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'hbhpdf'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'hbhsx'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'hblang'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'hbmacro'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'hbmainstd'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'hbmemio'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'hbmisc'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'hbmysql'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'hbmzip'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'hbnetio'+cExt )
/* aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'hbnulsys'+cExt )   this generates "multiple definition" error */
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'hbole'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'hbpcre'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'hbpcre2'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'hbpp'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'hbprinter'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'hbrdd'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'hbrtl'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'hbsix'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'hbsqlit3'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'hbusrrdd'+cExt )
   if Prj_Check_MT
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'hbvmmt'+cExt )
   else
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'hbvm'+cExt )
   endif
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'hbvpdf'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'hbw32'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'hbxml'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'hbzebra'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'hbziparc'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'hbzlib'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'hfcl'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'hpdf'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'ini'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'libharu'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'libhpdf'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'libpng'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'miniprint'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'minizip'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'mysql'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'mysqldll'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'pcrepos'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'png'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'rddads'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'rddcdx'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'rdddbt'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'rddfpt'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'rddntx'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'registry'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'report'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'socket'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'sqlite3'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'stdc++'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'tip'+cExt )
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'xhb'+cExt )   // must come after haru
   aadd( &( "vLibDefault"+DefineMiniGui3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'hbwin'+cExt )   // must come after haru

// 5 - Extended + BCC32 + Harbour
   cPre := ""
   cExt := ".lib"
   &( "vLibDefault"+DefineExtended1+DefineBorland+DefineHarbour+Define32bits ) := {}
   if Prj_Check_Console
   if PUB_bDebugActive
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineHarbour+Define32bits ), cPre+'gtwin'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineHarbour+Define32bits ), cPre+'hbdebug'+cExt )
   else
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineHarbour+Define32bits ), cPre+'gtwin'+cExt )
   endif
   else
   if PUB_bDebugActive
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineHarbour+Define32bits ), cPre+'gtgui'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineHarbour+Define32bits ), cPre+'gtwin'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineHarbour+Define32bits ), cPre+'debugger'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineHarbour+Define32bits ), cPre+'hbdebug'+cExt )
   else
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineHarbour+Define32bits ), cPre+'gtgui'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineHarbour+Define32bits ), cPre+'gtwin'+cExt )
   endif
   endif

   if Prj_Check_MT
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineHarbour+Define32bits ), cPre+'cw32mt'+cExt )
   else
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineHarbour+Define32bits ), cPre+'cw32'+cExt )
   endif
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineHarbour+Define32bits ), cPre+'comctl32'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineHarbour+Define32bits ), cPre+'comdlg32'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineHarbour+Define32bits ), cPre+'gdi32'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineHarbour+Define32bits ), cPre+'import32'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineHarbour+Define32bits ), cPre+'iphlpapi'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineHarbour+Define32bits ), cPre+'mapi32'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineHarbour+Define32bits ), cPre+'mpr'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineHarbour+Define32bits ), cPre+'msimg32'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineHarbour+Define32bits ), cPre+'ole32'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineHarbour+Define32bits ), cPre+'oleaut32'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineHarbour+Define32bits ), cPre+'shell32'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineHarbour+Define32bits ), cPre+'user32'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineHarbour+Define32bits ), cPre+'uuid'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineHarbour+Define32bits ), cPre+'vfw32'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineHarbour+Define32bits ), cPre+'winmm'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineHarbour+Define32bits ), cPre+'winspool'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineHarbour+Define32bits ), cPre+'ws2_32'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineHarbour+Define32bits ), cPre+'wsock32'+cExt )

   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineHarbour+Define32bits ), cPre+'ace32'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineHarbour+Define32bits ), cPre+'adordd'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineHarbour+Define32bits ), cPre+'bostaurus'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineHarbour+Define32bits ), cPre+'calldll'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineHarbour+Define32bits ), cPre+'cputype'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineHarbour+Define32bits ), cPre+'dll'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineHarbour+Define32bits ), cPre+'hbaes'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineHarbour+Define32bits ), cPre+'hbcomm'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineHarbour+Define32bits ), cPre+'hbcommon'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineHarbour+Define32bits ), cPre+'hbcpage'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineHarbour+Define32bits ), cPre+'hbct'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineHarbour+Define32bits ), cPre+'hbhpdf'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineHarbour+Define32bits ), cPre+'hbhsx'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineHarbour+Define32bits ), cPre+'hblang'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineHarbour+Define32bits ), cPre+'hbmacro'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineHarbour+Define32bits ), cPre+'hbmemio'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineHarbour+Define32bits ), cPre+'hbmisc'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineHarbour+Define32bits ), cPre+'hbmysql'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineHarbour+Define32bits ), cPre+'hbmzip'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineHarbour+Define32bits ), cPre+'hbodbc'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineHarbour+Define32bits ), cPre+'hbole'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineHarbour+Define32bits ), cPre+'hbpcre'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineHarbour+Define32bits ), cPre+'hbpcre2'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineHarbour+Define32bits ), cPre+'hpdf'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineHarbour+Define32bits ), cPre+'hbpgsql'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineHarbour+Define32bits ), cPre+'hbpp'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineHarbour+Define32bits ), cPre+'hbprinter'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineHarbour+Define32bits ), cPre+'hbrdd'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineHarbour+Define32bits ), cPre+'hbrtl'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineHarbour+Define32bits ), cPre+'hbsix'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineHarbour+Define32bits ), cPre+'hbsqldd'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineHarbour+Define32bits ), cPre+'hbsqlit3'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineHarbour+Define32bits ), cPre+'hbtip'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineHarbour+Define32bits ), cPre+'hbunrar'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineHarbour+Define32bits ), cPre+'hbusrrdd'+cExt )
   if Prj_Check_MT
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineHarbour+Define32bits ), cPre+'hbvmmt'+cExt )
   else
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineHarbour+Define32bits ), cPre+'hbvm'+cExt )
   endif
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineHarbour+Define32bits ), cPre+'hbvpdf'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineHarbour+Define32bits ), cPre+'hbxml'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineHarbour+Define32bits ), cPre+'hbzebra'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineHarbour+Define32bits ), cPre+'hbziparc'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineHarbour+Define32bits ), cPre+'hbzlib'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineHarbour+Define32bits ), cPre+'hmg_hpdf'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineHarbour+Define32bits ), cPre+'hmg_qhtm'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineHarbour+Define32bits ), cPre+'iphlpapi'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineHarbour+Define32bits ), cPre+'libharu'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineHarbour+Define32bits ), cPre+'libhpdf'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineHarbour+Define32bits ), cPre+'libmysql'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineHarbour+Define32bits ), cPre+'libpng'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineHarbour+Define32bits ), cPre+'libpq'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineHarbour+Define32bits ), cPre+'miniprint'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineHarbour+Define32bits ), cPre+'minizip'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineHarbour+Define32bits ), cPre+'odbc32'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineHarbour+Define32bits ), cPre+'png'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineHarbour+Define32bits ), cPre+'propgrid'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineHarbour+Define32bits ), cPre+'propsheet'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineHarbour+Define32bits ), cPre+'rddads'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineHarbour+Define32bits ), cPre+'rddcdx'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineHarbour+Define32bits ), cPre+'rddfpt'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineHarbour+Define32bits ), cPre+'rddntx'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineHarbour+Define32bits ), cPre+'socket'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineHarbour+Define32bits ), cPre+'sqlite3facade'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineHarbour+Define32bits ), cPre+'tbn'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineHarbour+Define32bits ), cPre+'tmsagent'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineHarbour+Define32bits ), cPre+'tsbrowse'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineHarbour+Define32bits ), cPre+'winreport'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineHarbour+Define32bits ), cPre+'xhb'+cExt )   // must come after haru
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineHarbour+Define32bits ), cPre+'ziparchive'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineHarbour+Define32bits ), cPre+'hbwin'+cExt )   // must come after haru

// 6 - Extended + BCC32 + xHarbour
   cPre := ""
   cExt := ".lib"
   &( "vLibDefault"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits ) := {}
   if Prj_Check_Console
   if PUB_bDebugActive
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'gtwin'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'debug'+cExt )
   else
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'gtwin'+cExt )
   endif
   else
   if PUB_bDebugActive
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'gtgui'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'gtwin'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'debugger'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'debug'+cExt )
   else
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'gtgui'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'gtwin'+cExt )
   endif
   endif

   if Prj_Check_MT
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'cw32mt'+cExt )
   else
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'cw32'+cExt )
   endif
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'comctl32'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'comdlg32'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'gdi32'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'import32'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'iphlpapi'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'mapi32'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'mpr'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'msimg32'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'ole32'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'oleaut32'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'shell32'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'user32'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'uuid'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'vfw32'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'winmm'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'winspool'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'ws2_32'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'wsock32'+cExt )

   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'ace32'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'adordd'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'bostaurus'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'calldll'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'codepage'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'common'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'cputype'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'ct'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'dbfcdx'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'dbfdbt'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'dbffpt'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'dbfntx'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'dll'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'hbaes'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'hbcomm'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'hbcommon'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'hbcpage'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'hbct'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'hbhpdf'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'hbhsx'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'hblang'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'hbmacro'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'hbmemio'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'hbmisc'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'hbmysql'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'hbmzip'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'hbodbc'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'hbole'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'hbpcre'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'hbpcre2'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'hbpgsql'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'hbpp'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'hbprinter'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'hbrdd'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'hbrtl'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'hbsix'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'hbsqldd'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'hbsqlit3'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'hbtip'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'hbunrar'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'hbusrrdd'+cExt )
   if Prj_Check_MT
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'hbvmmt'+cExt )
   else
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'hbvm'+cExt )
   endif
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'hbvpdf'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'hbxml'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'hbzebra'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'hbziparc'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'hbzlib'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'hmg_hpdf'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'hmg_qhtm'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'hpdf'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'lang'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'libharu'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'libhpdf'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'libmisc'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'libmysql'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'libpng'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'libpq'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'macro'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'miniprint'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'minizip'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'odbc32'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'png'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'pp'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'propgrid'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'propsheet'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'rdd'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'rddads'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'rddcdx'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'rddfpt'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'rddntx'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'rtl'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'socket'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'sqlite3facade'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'tip'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'tbn'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'tmsagent'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'tsbrowse'+cExt )
   if Prj_Check_MT
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'vmmt'+cExt )
   else
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'vm'+cExt )
   endif
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'winreport'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'ziparchive'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'zlib'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineBorland+DefineXHarbour+Define32bits ), cPre+'hbwin'+cExt )   // must come after haru

   // 7 - Extended + MinGW + Harbour, 32 bits
   cPre := "lib"
   cExt := ".a"
   &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define32bits ) := {}
   if Prj_Check_Console
   if PUB_bDebugActive
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define32bits ), cPre+'gtwin'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define32bits ), cPre+'hbdebug'+cExt )
   else
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define32bits ), cPre+'gtwin'+cExt )
   endif
   else
   if PUB_bDebugActive
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define32bits ), cPre+'gtgui'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define32bits ), cPre+'gtwin'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define32bits ), cPre+'debugger'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define32bits ), cPre+'hbdebug'+cExt )
   else
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define32bits ), cPre+'gtgui'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define32bits ), cPre+'gtwin'+cExt )
   endif
   endif

   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define32bits ), cPre+'comctl32'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define32bits ), cPre+'comdlg32'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define32bits ), cPre+'gdi32'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define32bits ), cPre+'iphlpapi'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define32bits ), cPre+'mapi32'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define32bits ), cPre+'mpr'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define32bits ), cPre+'msimg32'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define32bits ), cPre+'ole32'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define32bits ), cPre+'oleaut32'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define32bits ), cPre+'shell32'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define32bits ), cPre+'user32'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define32bits ), cPre+'uuid'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define32bits ), cPre+'vfw32'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define32bits ), cPre+'winmm'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define32bits ), cPre+'winspool'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define32bits ), cPre+'ws2_32'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define32bits ), cPre+'wsock32'+cExt )

   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define32bits ), cPre+'ace32'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define32bits ), cPre+'adordd'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define32bits ), cPre+'bostaurus'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define32bits ), cPre+'calldll'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define32bits ), cPre+'crypt'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define32bits ), cPre+'dll'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define32bits ), cPre+'edit'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define32bits ), cPre+'editex'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define32bits ), cPre+'graph'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define32bits ), cPre+'hbcommon'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define32bits ), cPre+'hbcpage'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define32bits ), cPre+'hbct'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define32bits ), cPre+'hbhpdf'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define32bits ), cPre+'hbhsx'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define32bits ), cPre+'hblang'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define32bits ), cPre+'hbmacro'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define32bits ), cPre+'hbmisc'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define32bits ), cPre+'hbmysql'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define32bits ), cPre+'hbmzip'+cExt )
/* aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define32bits ), cPre+'hbnulsys'+cExt )   this generates "multiple definition" error */
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define32bits ), cPre+'hbole'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define32bits ), cPre+'hbpcre'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define32bits ), cPre+'hbpcre2'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define32bits ), cPre+'hbpp'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define32bits ), cPre+'hbprinter'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define32bits ), cPre+'hbrdd'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define32bits ), cPre+'hbrtl'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define32bits ), cPre+'hbsix'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define32bits ), cPre+'hbsqlit3'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define32bits ), cPre+'hbunrar'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define32bits ), cPre+'hbusrrdd'+cExt )
   if Prj_Check_MT
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define32bits ), cPre+'hbvmmt'+cExt )
   else
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define32bits ), cPre+'hbvm'+cExt )
   endif
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define32bits ), cPre+'hbw32'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define32bits ), cPre+'hbxml'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define32bits ), cPre+'hbzebra'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define32bits ), cPre+'hbzip'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define32bits ), cPre+'hbziparc'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define32bits ), cPre+'hbziparch'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define32bits ), cPre+'hbzlib'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define32bits ), cPre+'hmg_hpdf'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define32bits ), cPre+'hpdf'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define32bits ), cPre+'ini'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define32bits ), cPre+'libharu'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define32bits ), cPre+'libhpdf'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define32bits ), cPre+'libpng'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define32bits ), cPre+'miniprint'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define32bits ), cPre+'minizip'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define32bits ), cPre+'misc'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define32bits ), cPre+'mysql'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define32bits ), cPre+'mysqldll'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define32bits ), cPre+'png'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define32bits ), cPre+'pcrepos'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define32bits ), cPre+'propgrid'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define32bits ), cPre+'propsheet'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define32bits ), cPre+'qhtm'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define32bits ), cPre+'rddads'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define32bits ), cPre+'rddcdx'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define32bits ), cPre+'rdddbt'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define32bits ), cPre+'rddfpt'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define32bits ), cPre+'rddntx'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define32bits ), cPre+'registry'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define32bits ), cPre+'report'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define32bits ), cPre+'socket'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define32bits ), cPre+'stdc++'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define32bits ), cPre+'sqlite3'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define32bits ), cPre+'tip'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define32bits ), cPre+'tmsagent'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define32bits ), cPre+'tsbrowse'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define32bits ), cPre+'unrar'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define32bits ), cPre+'winreport'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define32bits ), cPre+'xhb'+cExt )  // must come after haru
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define32bits ), cPre+'zlib1'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define32bits ), cPre+'hbwin'+cExt )   // must come after haru

   // 8 - Extended + MinGW + xHarbour, 32 bits
   cPre := "lib"
   cExt := ".a"
   &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits ) := {}
   if Prj_Check_Console
   if PUB_bDebugActive
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'gtwin'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'debug'+cExt )
   else
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'gtwin'+cExt )
   endif
   else
   if PUB_bDebugActive
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'gtgui'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'gtwin'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'debugger'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'debug'+cExt )
   else
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'gtgui'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'gtwin'+cExt )
   endif
   endif

   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'comctl32'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'comdlg32'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'gdi32'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'iphlpapi'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'mapi32'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'mpr'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'msimg32'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'ole32'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'oleaut32'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'shell32'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'user32'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'uuid'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'vfw32'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'winmm'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'winspool'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'ws2_32'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'wsock32'+cExt )

   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'ace32'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'adordd'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'bostaurus'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'calldll'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'codepage'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'common'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'crypt'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'ct'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'dbfcdx'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'dbfdbt'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'dbffpt'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'dbfntx'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'dll'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'edit'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'editex'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'graph'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'hbcommon'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'hbcpage'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'hbct'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'hbhpdf'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'hbhsx'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'hblang'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'hbmacro'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'hbmisc'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'hbmysql'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'hbmzip'+cExt )
/* aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'hbnulsys'+cExt )   this generates "multiple definition" error */
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'hbole'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'hbpcre'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'hbpcre2'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'hbpp'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'hbprinter'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'hbrdd'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'hbrtl'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'hbsix'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'hbsqlit3'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'hbunrar'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'hbusrrdd'+cExt )
   if Prj_Check_MT
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'hbvmmt'+cExt )
   else
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'hbvm'+cExt )
   endif
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'hbw32'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'hbxml'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'hbzebra'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'hbzip'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'hbziparc'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'hbziparch'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'hbzlib'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'hmg_hpdf'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'hpdf'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'ini'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'lang'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'libharu'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'libhpdf'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'libmisc'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'libpng'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'macro'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'miniprint'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'minizip'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'misc'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'mysql'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'mysqldll'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'pp'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'png'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'pcrepos'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'propgrid'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'propsheet'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'qhtm'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'rdd'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'rddads'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'rddcdx'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'rdddbt'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'rddfpt'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'rddntx'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'registry'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'report'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'rtl'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'socket'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'stdc++'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'sqlite3'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'tip'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'tmsagent'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'tsbrowse'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'unrar'+cExt )
   if Prj_Check_MT
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'vmmt'+cExt )
   else
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'vm'+cExt )
   endif
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'winreport'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'zebra'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'zlib'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'zlib1'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'hbwin'+cExt )  // must come after haru

   // 9 - Extended + MinGW + Harbour, 64 bits
   cPre := "lib"
   cExt := ".a"
   &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define64bits ) := {}
   if Prj_Check_Console
   if PUB_bDebugActive
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define64bits ), cPre+'gtwin'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define64bits ), cPre+'hbdebug'+cExt )
   else
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define64bits ), cPre+'gtwin'+cExt )
   endif
   else
   if PUB_bDebugActive
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define64bits ), cPre+'gtgui'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define64bits ), cPre+'gtwin'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define64bits ), cPre+'debugger'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define64bits ), cPre+'hbdebug'+cExt )
   else
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define64bits ), cPre+'gtgui'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define64bits ), cPre+'gtwin'+cExt )
   endif
   endif

   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define64bits ), cPre+'comctl32'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define64bits ), cPre+'comdlg32'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define64bits ), cPre+'gdi32'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define64bits ), cPre+'iphlpapi'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define64bits ), cPre+'mapi32'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define64bits ), cPre+'mpr'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define64bits ), cPre+'msimg32'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define64bits ), cPre+'ole32'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define64bits ), cPre+'oleaut32'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define64bits ), cPre+'shell32'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define64bits ), cPre+'user32'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define64bits ), cPre+'uuid'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define64bits ), cPre+'vfw32'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define64bits ), cPre+'winmm'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define64bits ), cPre+'winspool'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define64bits ), cPre+'ws2_32'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define64bits ), cPre+'wsock32'+cExt )

   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define64bits ), cPre+'ace32'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define64bits ), cPre+'adordd'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define64bits ), cPre+'bostaurus'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define64bits ), cPre+'calldll'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define64bits ), cPre+'crypt'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define64bits ), cPre+'dll'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define64bits ), cPre+'edit'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define64bits ), cPre+'editex'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define64bits ), cPre+'graph'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define64bits ), cPre+'hbcommon'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define64bits ), cPre+'hbcpage'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define64bits ), cPre+'hbct'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define64bits ), cPre+'hbhpdf'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define64bits ), cPre+'hbhsx'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define64bits ), cPre+'hblang'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define64bits ), cPre+'hbmacro'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define64bits ), cPre+'hbmisc'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define64bits ), cPre+'hbmysql'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define64bits ), cPre+'hbmzip'+cExt )
/* aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define64bits ), cPre+'hbnulsys'+cExt )   this generates "multiple definition" error */
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define64bits ), cPre+'hbole'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define64bits ), cPre+'hbpcre'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define64bits ), cPre+'hbpcre2'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define64bits ), cPre+'hbpp'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define64bits ), cPre+'hbprinter'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define64bits ), cPre+'hbrdd'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define64bits ), cPre+'hbrtl'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define64bits ), cPre+'hbsix'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define64bits ), cPre+'hbsqlit3'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define64bits ), cPre+'hbunrar'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define64bits ), cPre+'hbusrrdd'+cExt )
   if Prj_Check_MT
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define64bits ), cPre+'hbvmmt'+cExt )
   else
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define64bits ), cPre+'hbvm'+cExt )
   endif
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define64bits ), cPre+'hbw32'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define64bits ), cPre+'hbxml'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define64bits ), cPre+'hbzebra'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define64bits ), cPre+'hbzip'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define64bits ), cPre+'hbziparc'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define64bits ), cPre+'hbziparch'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define64bits ), cPre+'hbzlib'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define64bits ), cPre+'hmg_hpdf'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define64bits ), cPre+'hpdf'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define64bits ), cPre+'ini'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define64bits ), cPre+'libharu'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define64bits ), cPre+'libhpdf'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define64bits ), cPre+'libpng'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define64bits ), cPre+'miniprint'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define64bits ), cPre+'minizip'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define64bits ), cPre+'misc'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define64bits ), cPre+'mysql'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define64bits ), cPre+'mysqldll'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define64bits ), cPre+'png'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define64bits ), cPre+'pcrepos'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define64bits ), cPre+'propgrid'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define64bits ), cPre+'propsheet'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define64bits ), cPre+'qhtm'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define64bits ), cPre+'rddads'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define64bits ), cPre+'rddcdx'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define64bits ), cPre+'rdddbt'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define64bits ), cPre+'rddfpt'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define64bits ), cPre+'rddntx'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define64bits ), cPre+'registry'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define64bits ), cPre+'report'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define64bits ), cPre+'socket'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define64bits ), cPre+'stdc++'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define64bits ), cPre+'sqlite3'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define64bits ), cPre+'tip'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define64bits ), cPre+'tmsagent'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define64bits ), cPre+'tsbrowse'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define64bits ), cPre+'unrar'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define64bits ), cPre+'winreport'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define64bits ), cPre+'xhb'+cExt )  // must come after haru
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define64bits ), cPre+'zlib1'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineHarbour+Define64bits ), cPre+'hbwin'+cExt )  // must come after haru

   // 10 - Extended + MinGW + xHarbour, 64 bits
   cPre := "lib"
   cExt := ".a"
   &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits ) := {}
   if Prj_Check_Console
   if PUB_bDebugActive
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'gtwin'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'debug'+cExt )
   else
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'gtwin'+cExt )
   endif
   else
   if PUB_bDebugActive
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'gtgui'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'gtwin'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'debugger'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'debug'+cExt )
   else
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'gtgui'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'gtwin'+cExt )
   endif
   endif

   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'comctl32'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'comdlg32'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'gdi32'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'iphlpapi'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'mapi32'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'mpr'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'msimg32'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'ole32'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'oleaut32'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'shell32'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'user32'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'uuid'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'vfw32'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'winmm'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'winspool'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'ws2_32'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'wsock32'+cExt )

   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'ace32'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'adordd'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'bostaurus'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'calldll'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'codepage'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'common'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'crypt'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'dbfcdx'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'dbfdbt'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'dbffpt'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'dbfntx'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'dll'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'edit'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'editex'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'graph'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'hbcommon'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'hbcpage'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'hbct'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'hbhpdf'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'hbhsx'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'hblang'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'hbmacro'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'hbmisc'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'hbmysql'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'hbmzip'+cExt )
/* aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'hbnulsys'+cExt )   this generates "multiple definition" error */
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'hbole'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'hbpcre'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'hbpcre2'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'hbpp'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'hbprinter'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'hbrdd'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'hbrtl'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'hbsix'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'hbsqlit3'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'hbunrar'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'hbusrrdd'+cExt )
   if Prj_Check_MT
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'hbvmmt'+cExt )
   else
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'hbvm'+cExt )
   endif
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'hbw32'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'hbxml'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'hbzebra'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'hbzip'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'hbziparc'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'hbziparch'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'hbzlib'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'hmg_hpdf'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'hpdf'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'ini'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'lang'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'libharu'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'libhpdf'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'libmisc'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'libpng'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'macro'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'miniprint'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'minizip'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'misc'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'mysql'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'mysqldll'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'png'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'pcrepos'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'pp'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'propgrid'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'propsheet'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'qhtm'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'rdd'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'rddads'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'rddcdx'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'rdddbt'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'rddfpt'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'rddntx'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'registry'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'report'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'rtl'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'socket'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'stdc++'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'sqlite3'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'tip'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'tmsagent'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'tsbrowse'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'unrar'+cExt )
   if Prj_Check_MT
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'vmmt'+cExt )
   else
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'vm'+cExt )
   endif
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'winreport'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'zebra'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'zlib'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'zlib1'+cExt )
   aadd( &( "vLibDefault"+DefineExtended1+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'hbwin'+cExt )  // must come after haru

   // 11 - OOHG + BCC32 + Harbour
   cPre := ""
   cExt := ".lib"
   &( "vLibDefault"+DefineOohg3+DefineBorland+DefineHarbour+Define32bits ) := {}
   if Prj_Check_Console
   if PUB_bDebugActive
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineHarbour+Define32bits ), cPre+'gtgui'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineHarbour+Define32bits ), cPre+'gtwin'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineHarbour+Define32bits ), cPre+'hbdebug'+cExt )
   else
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineHarbour+Define32bits ), cPre+'gtgui'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineHarbour+Define32bits ), cPre+'gtwin'+cExt )
   endif
   else
   if PUB_bDebugActive
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineHarbour+Define32bits ), cPre+'gtgui'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineHarbour+Define32bits ), cPre+'gtwin'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineHarbour+Define32bits ), cPre+'hbdebug'+cExt )
   else
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineHarbour+Define32bits ), cPre+'gtgui'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineHarbour+Define32bits ), cPre+'gtwin'+cExt )
   endif
   endif

   if Prj_Check_MT
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineHarbour+Define32bits ), cPre+'cw32mt'+cExt )
   else
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineHarbour+Define32bits ), cPre+'cw32'+cExt )
   endif
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineHarbour+Define32bits ), cPre+'comctl32'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineHarbour+Define32bits ), cPre+'comdlg32'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineHarbour+Define32bits ), cPre+'gdi32'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineHarbour+Define32bits ), cPre+'import32'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineHarbour+Define32bits ), cPre+'iphlpapi'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineHarbour+Define32bits ), cPre+'mapi32'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineHarbour+Define32bits ), cPre+'mpr'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineHarbour+Define32bits ), cPre+'msimg32'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineHarbour+Define32bits ), cPre+'ole32'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineHarbour+Define32bits ), cPre+'oleaut32'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineHarbour+Define32bits ), cPre+'shell32'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineHarbour+Define32bits ), cPre+'user32'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineHarbour+Define32bits ), cPre+'uuid'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineHarbour+Define32bits ), cPre+'vfw32'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineHarbour+Define32bits ), cPre+'winmm'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineHarbour+Define32bits ), cPre+'winspool'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineHarbour+Define32bits ), cPre+'ws2_32'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineHarbour+Define32bits ), cPre+'wsock32'+cExt )

   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineHarbour+Define32bits ), cPre+'ace32'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineHarbour+Define32bits ), cPre+'bostaurus'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineHarbour+Define32bits ), cPre+'dll'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineHarbour+Define32bits ), cPre+'hbcommon'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineHarbour+Define32bits ), cPre+'hbcpage'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineHarbour+Define32bits ), cPre+'hbct'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineHarbour+Define32bits ), cPre+'hbhpdf'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineHarbour+Define32bits ), cPre+'hbhsx'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineHarbour+Define32bits ), cPre+'hblang'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineHarbour+Define32bits ), cPre+'hbmacro'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineHarbour+Define32bits ), cPre+'hbmemio'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineHarbour+Define32bits ), cPre+'hbmisc'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineHarbour+Define32bits ), cPre+'hbmzip'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineHarbour+Define32bits ), cPre+'hbnulrdd'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineHarbour+Define32bits ), cPre+'hbole'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineHarbour+Define32bits ), cPre+'hbpcre'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineHarbour+Define32bits ), cPre+'hbpcre2'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineHarbour+Define32bits ), cPre+'hbpp'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineHarbour+Define32bits ), cPre+'hbprinter'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineHarbour+Define32bits ), cPre+'hbrdd'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineHarbour+Define32bits ), cPre+'hbrtl'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineHarbour+Define32bits ), cPre+'hbsix'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineHarbour+Define32bits ), cPre+'hbtip'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineHarbour+Define32bits ), cPre+'hbusrrdd'+cExt )
   if Prj_Check_MT
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineHarbour+Define32bits ), cPre+'hbvmmt'+cExt )
   else
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineHarbour+Define32bits ), cPre+'hbvm'+cExt )
   endif
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineHarbour+Define32bits ), cPre+'hbw32'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineHarbour+Define32bits ), cPre+'hbzebra'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineHarbour+Define32bits ), cPre+'hbzip'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineHarbour+Define32bits ), cPre+'hbziparc'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineHarbour+Define32bits ), cPre+'hbziparch'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineHarbour+Define32bits ), cPre+'hbzlib'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineHarbour+Define32bits ), cPre+'hpdf'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineHarbour+Define32bits ), cPre+'libct'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineHarbour+Define32bits ), cPre+'libharu'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineHarbour+Define32bits ), cPre+'libhpdf'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineHarbour+Define32bits ), cPre+'libmisc'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineHarbour+Define32bits ), cPre+'libmysql'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineHarbour+Define32bits ), cPre+'libpng'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineHarbour+Define32bits ), cPre+'miniprint'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineHarbour+Define32bits ), cPre+'minizip'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineHarbour+Define32bits ), cPre+'mysql'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineHarbour+Define32bits ), cPre+'png'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineHarbour+Define32bits ), cPre+'rddads'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineHarbour+Define32bits ), cPre+'rddcdx'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineHarbour+Define32bits ), cPre+'rdddbt'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineHarbour+Define32bits ), cPre+'rddfpt'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineHarbour+Define32bits ), cPre+'rddntx'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineHarbour+Define32bits ), cPre+'rddsql'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineHarbour+Define32bits ), cPre+'sddodbc'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineHarbour+Define32bits ), cPre+'socket'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineHarbour+Define32bits ), cPre+'xhb'+cExt )  // must come after haru
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineHarbour+Define32bits ), cPre+'hbwin'+cExt )  // must come after haru

   // 12 - OOHG + BCC32 + xHarbour
   cPre := ""
   cExt := ".lib"
   &( "vLibDefault"+DefineOohg3+DefineBorland+DefineXHarbour+Define32bits ) := {}
   if Prj_Check_Console
   if PUB_bDebugActive
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineXHarbour+Define32bits ), cPre+'gtgui'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineXHarbour+Define32bits ), cPre+'gtwin'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineXHarbour+Define32bits ), cPre+'debug'+cExt )
   else
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineXHarbour+Define32bits ), cPre+'gtgui'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineXHarbour+Define32bits ), cPre+'gtwin'+cExt )
   endif
   else
   if PUB_bDebugActive
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineXHarbour+Define32bits ), cPre+'gtgui'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineXHarbour+Define32bits ), cPre+'gtwin'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineXHarbour+Define32bits ), cPre+'debug'+cExt )
   else
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineXHarbour+Define32bits ), cPre+'gtgui'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineXHarbour+Define32bits ), cPre+'gtwin'+cExt )
   endif
   endif

   if Prj_Check_MT
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineXHarbour+Define32bits ), cPre+'cw32mt'+cExt )
   else
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineXHarbour+Define32bits ), cPre+'cw32'+cExt )
   endif
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineXHarbour+Define32bits ), cPre+'comctl32'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineXHarbour+Define32bits ), cPre+'comdlg32'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineXHarbour+Define32bits ), cPre+'gdi32'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineXHarbour+Define32bits ), cPre+'import32'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineXHarbour+Define32bits ), cPre+'iphlpapi'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineXHarbour+Define32bits ), cPre+'mapi32'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineXHarbour+Define32bits ), cPre+'mpr'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineXHarbour+Define32bits ), cPre+'msimg32'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineXHarbour+Define32bits ), cPre+'ole32'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineXHarbour+Define32bits ), cPre+'oleaut32'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineXHarbour+Define32bits ), cPre+'shell32'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineXHarbour+Define32bits ), cPre+'user32'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineXHarbour+Define32bits ), cPre+'uuid'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineXHarbour+Define32bits ), cPre+'vfw32'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineXHarbour+Define32bits ), cPre+'winmm'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineXHarbour+Define32bits ), cPre+'winspool'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineXHarbour+Define32bits ), cPre+'ws2_32'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineXHarbour+Define32bits ), cPre+'wsock32'+cExt )

   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineXHarbour+Define32bits ), cPre+'ace32'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineXHarbour+Define32bits ), cPre+'bostaurus'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineXHarbour+Define32bits ), cPre+'codepage'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineXHarbour+Define32bits ), cPre+'common'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineXHarbour+Define32bits ), cPre+'ct'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineXHarbour+Define32bits ), cPre+'dbfcdx'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineXHarbour+Define32bits ), cPre+'dbfdbt'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineXHarbour+Define32bits ), cPre+'dbffpt'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineXHarbour+Define32bits ), cPre+'dbfntx'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineXHarbour+Define32bits ), cPre+'dll'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineXHarbour+Define32bits ), cPre+'hbhpdf'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineXHarbour+Define32bits ), cPre+'hbmzip'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineXHarbour+Define32bits ), cPre+'hbole'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineXHarbour+Define32bits ), cPre+'hbprinter'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineXHarbour+Define32bits ), cPre+'hbsix'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineXHarbour+Define32bits ), cPre+'hbzebra'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineXHarbour+Define32bits ), cPre+'hbzip'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineXHarbour+Define32bits ), cPre+'hbzlib'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineXHarbour+Define32bits ), cPre+'hpdf'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineXHarbour+Define32bits ), cPre+'hsx'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineXHarbour+Define32bits ), cPre+'lang'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineXHarbour+Define32bits ), cPre+'libct'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineXHarbour+Define32bits ), cPre+'libharu'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineXHarbour+Define32bits ), cPre+'libhpdf'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineXHarbour+Define32bits ), cPre+'libmisc'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineXHarbour+Define32bits ), cPre+'libmysql'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineXHarbour+Define32bits ), cPre+'libpng'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineXHarbour+Define32bits ), cPre+'macro'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineXHarbour+Define32bits ), cPre+'miniprint'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineXHarbour+Define32bits ), cPre+'mysql'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineXHarbour+Define32bits ), cPre+'pcrepos'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineXHarbour+Define32bits ), cPre+'png'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineXHarbour+Define32bits ), cPre+'pp'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineXHarbour+Define32bits ), cPre+'rdd'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineXHarbour+Define32bits ), cPre+'rddads'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineXHarbour+Define32bits ), cPre+'rtl'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineXHarbour+Define32bits ), cPre+'socket'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineXHarbour+Define32bits ), cPre+'tip'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineXHarbour+Define32bits ), cPre+'usrrdd'+cExt )
   if Prj_Check_MT
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineXHarbour+Define32bits ), cPre+'vmmt'+cExt )
   else
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineXHarbour+Define32bits ), cPre+'vm'+cExt )
   endif
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineXHarbour+Define32bits ), cPre+'zlib'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineBorland+DefineXHarbour+Define32bits ), cPre+'zlib1'+cExt )

   // 13 - OOHG + MinGW + Harbour, 32 bits
   cPre := "lib"
   cExt := ".a"
   &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define32bits ) := {}
   if Prj_Check_Console
   if PUB_bDebugActive
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'gtgui'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'gtwin'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'hbdebug'+cExt )
   else
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'gtgui'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'gtwin'+cExt )
   endif
   else
   if PUB_bDebugActive
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'gtgui'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'gtwin'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'hbdebug'+cExt )
   else
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'gtgui'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'gtwin'+cExt )
   endif
   endif

   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'comctl32'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'comdlg32'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'gdi32'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'iphlpapi'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'mapi32'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'mpr'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'msimg32'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'ole32'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'oleaut32'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'shell32'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'user32'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'uuid'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'vfw32'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'winmm'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'winspool'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'ws2_32'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'wsock32'+cExt )

   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'bostaurus'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'hbcommon'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'hbcpage'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'hbcplr'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'hbct'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'hbextern'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'hbhpdf'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'hbhsx'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'hblang'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'hbmacro'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'hbmemio'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'hbmisc'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'hbmysql'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'hbmzip'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'hbodbc'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'hbpcre'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'hbpcre2'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'hbpp'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'hbprinter'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'hbrdd'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'hbrtl'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'hbsix'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'hbtip'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'hbuddall'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'hbusrrdd'+cExt )
   if Prj_Check_MT
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'hbvmmt'+cExt )
   else
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'hbvm'+cExt )
   endif
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'hbzebra'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'hbziparc'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'hbzlib'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'hpdf'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'libharu'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'libhpdf'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'libpng'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'miniprint'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'minizip'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'odbc32'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'png'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'rddads'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'rddcdx'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'rddfpt'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'rddnsx'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'rddntx'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'rddsql'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'sddodbc'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'xhb'+cExt )  // must come after haru
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define32bits ), cPre+'hbwin'+cExt )  // must come after haru

   // 14 - OOHG + MinGW + xHarbour, 32 bits
   cPre := "lib"
   cExt := ".a"
   &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define32bits ) := {}
   if Prj_Check_Console
   if PUB_bDebugActive
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'gtgui'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'gtwin'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'debug'+cExt )
   else
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'gtgui'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'gtwin'+cExt )
   endif
   else
   if PUB_bDebugActive
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'gtwin'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'gtgui'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'debug'+cExt )
   else
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'gtwin'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'gtgui'+cExt )
   endif
   endif

   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'comctl32'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'comdlg32'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'gdi32'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'iphlpapi'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'mapi32'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'mpr'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'msimg32'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'ole32'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'oleaut32'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'shell32'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'user32'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'uuid'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'vfw32'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'winmm'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'winspool'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'ws2_32'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'wsock32'+cExt )

   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'bostaurus'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'codepage'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'common'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'ct'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'dbfcdx'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'dbfdbt'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'dbffpt'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'dbfntx'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'dll'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'hbhpdf'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'hbmzip'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'hbprinter'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'hbsix'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'hbzebra'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'hbzip'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'hbzlib'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'hpdf'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'hsx'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'lang'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'libharu'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'libhpdf'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'libpng'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'macro'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'mapi32'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'miniprint'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'mysql'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'mysqldll'+cExt )
/* aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'nulsys'+cExt )   this generates "multiple definition" error */
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'pcrepos'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'png'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'pp'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'rdd'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'rtl'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'socket'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'stdc++'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'tip'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'usrrdd'+cExt )
   if Prj_Check_MT
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'vmmt'+cExt )
   else
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'vm'+cExt )
   endif
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'xCrypt'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'xEdit'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'xEditex'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'xGraph'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'xIni'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'xRegistry'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'xReport'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define32bits ), cPre+'zlib1'+cExt )

   // 15 - OOHG + MinGW + Harbour, 64 bits
   cPre := "lib"
   cExt := ".a"
   &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define64bits ) := {}
   if Prj_Check_Console
   if PUB_bDebugActive
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'gtgui'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'gtwin'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'hbdebug'+cExt )
   else
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'gtgui'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'gtwin'+cExt )
   endif
   else
   if PUB_bDebugActive
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'gtgui'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'gtwin'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'hbdebug'+cExt )
   else
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'gtgui'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'gtwin'+cExt )
   endif
   endif

   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'comctl32'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'comdlg32'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'gdi32'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'iphlpapi'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'mapi32'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'mpr'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'msimg32'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'ole32'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'oleaut32'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'shell32'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'user32'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'uuid'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'vfw32'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'winmm'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'winspool'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'ws2_32'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'wsock32'+cExt )

   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'bostaurus'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'hbcommon'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'hbcpage'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'hbcplr'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'hbct'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'hbextern'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'hbhpdf'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'hbhsx'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'hblang'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'hbmacro'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'hbmemio'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'hbmisc'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'hbmysql'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'hbmzip'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'hbodbc'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'hbpcre'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'hbpcre2'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'hbpp'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'hbprinter'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'hbrdd'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'hbrtl'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'hbsix'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'hbtip'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'hbuddall'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'hbusrrdd'+cExt )
   if Prj_Check_MT
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'hbvmmt'+cExt )
   else
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'hbvm'+cExt )
   endif
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'hbzebra'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'hbziparc'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'hbzlib'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'hpdf'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'libharu'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'libhpdf'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'libpng'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'miniprint'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'minizip'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'odbc32'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'png'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'rddads'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'rddcdx'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'rddfpt'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'rddnsx'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'rddntx'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'rddsql'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'sddodbc'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'xhb'+cExt )  // must come after haru
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineHarbour+Define64bits ), cPre+'hbwin'+cExt )  // must come after haru

   // 16 - OOHG + MinGW + xHarbour, 64 bits
   cPre := "lib"
   cExt := ".a"
   &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define64bits ) := {}
   if Prj_Check_Console
   if PUB_bDebugActive
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'gtgui'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'gtwin'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'debug'+cExt )
   else
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'gtgui'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'gtwin'+cExt )
   endif
   else
   if PUB_bDebugActive
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'gtgui'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'gtwin'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'debug'+cExt )
   else
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'gtgui'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'gtwin'+cExt )
   endif
   endif

   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'comctl32'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'comdlg32'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'gdi32'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'iphlpapi'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'mapi32'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'mpr'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'msimg32'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'ole32'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'oleaut32'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'shell32'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'user32'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'uuid'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'vfw32'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'winmm'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'winspool'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'ws2_32'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'wsock32'+cExt )

   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'bostaurus'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'codepage'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'common'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'ct'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'dbfcdx'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'dbfdbt'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'dbffpt'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'dbfntx'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'dll'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'hbhpdf'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'hbmzip'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'hbprinter'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'hbsix'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'hbzebra'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'hbzip'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'hbzlib'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'hpdf'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'hsx'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'lang'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'libharu'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'libhpdf'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'libpng'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'macro'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'miniprint'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'mysql'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'mysqldll'+cExt )
/* aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'nulsys'+cExt )   this generates "multiple definition" error */
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'pcrepos'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'png'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'pp'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'rdd'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'rtl'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'socket'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'stdc++'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'tip'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'usrrdd'+cExt )
   if Prj_Check_MT
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'vmmt'+cExt )
   else
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'vm'+cExt )
   endif
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'xCrypt'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'xEdit'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'xEditex'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'xGraph'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'xIni'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'xRegistry'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'xReport'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefineMinGW+DefineXHarbour+Define64bits ), cPre+'zlib1'+cExt )

   // 17 - OOHG + Pelles C + Harbour, 32 bits
   cPre := ""
   cExt := ".lib"
   &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define32bits ) := {}
   if Prj_Check_Console
   if PUB_bDebugActive
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define32bits ), cPre+'gtgui'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define32bits ), cPre+'gtwin'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define32bits ), cPre+'hbdebug'+cExt )
   else
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define32bits ), cPre+'gtgui'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define32bits ), cPre+'gtwin'+cExt )
   endif
   else
   if PUB_bDebugActive
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define32bits ), cPre+'gtgui'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define32bits ), cPre+'gtwin'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define32bits ), cPre+'hbdebug'+cExt )
   else
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define32bits ), cPre+'gtgui'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define32bits ), cPre+'gtwin'+cExt )
   endif
   endif

   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define32bits ), cPre+'comctl32'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define32bits ), cPre+'comdlg32'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define32bits ), cPre+'gdi32'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define32bits ), cPre+'iphlpapi'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define32bits ), cPre+'mapi32'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define32bits ), cPre+'mpr'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define32bits ), cPre+'msimg32'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define32bits ), cPre+'ole32'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define32bits ), cPre+'oleaut32'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define32bits ), cPre+'shell32'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define32bits ), cPre+'user32'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define32bits ), cPre+'uuid'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define32bits ), cPre+'vfw32'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define32bits ), cPre+'winmm'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define32bits ), cPre+'winspool'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define32bits ), cPre+'ws2_32'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define32bits ), cPre+'wsock32'+cExt )

   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define32bits ), cPre+'ace32'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define32bits ), cPre+'bostaurus'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define32bits ), cPre+'advapi32'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define32bits ), cPre+'crt'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define32bits ), cPre+'dll'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define32bits ), cPre+'hbcommon'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define32bits ), cPre+'hbcpage'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define32bits ), cPre+'hbct'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define32bits ), cPre+'hbhpdf'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define32bits ), cPre+'hbhsx'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define32bits ), cPre+'hblang'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define32bits ), cPre+'hbmacro'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define32bits ), cPre+'hbmzip'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define32bits ), cPre+'hbole'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define32bits ), cPre+'hbpcre'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define32bits ), cPre+'hbpcre2'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define32bits ), cPre+'hbpp'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define32bits ), cPre+'hbprinter'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define32bits ), cPre+'hbrdd'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define32bits ), cPre+'hbrtl'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define32bits ), cPre+'hbsix'+cExt )
   if Prj_Check_MT
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define32bits ), cPre+'hbvmmt'+cExt )
   else
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define32bits ), cPre+'hbvm'+cExt )
   endif
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define32bits ), cPre+'hbw32'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define32bits ), cPre+'hbzebra'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define32bits ), cPre+'hbzip'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define32bits ), cPre+'hbziparc'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define32bits ), cPre+'hbziparch'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define32bits ), cPre+'hbzlib'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define32bits ), cPre+'hpdf'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define32bits ), cPre+'kernel32'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define32bits ), cPre+'libct'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define32bits ), cPre+'libharu'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define32bits ), cPre+'libhpdf'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define32bits ), cPre+'libmisc'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define32bits ), cPre+'libmysql'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define32bits ), cPre+'libpng'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define32bits ), cPre+'miniprint'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define32bits ), cPre+'minizip'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define32bits ), cPre+'mysql'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define32bits ), cPre+'olepro32'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define32bits ), cPre+'pcrepos'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define32bits ), cPre+'png'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define32bits ), cPre+'rddads'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define32bits ), cPre+'rddcdx'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define32bits ), cPre+'rdddbt'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define32bits ), cPre+'rddfpt'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define32bits ), cPre+'rddntx'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define32bits ), cPre+'socket'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define32bits ), cPre+'tip'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define32bits ), cPre+'xhb'+cExt )  // must come after haru
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define32bits ), cPre+'zlib1'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define32bits ), cPre+'hbwin'+cExt )  // must come after haru

   // 18 - OOHG + Pelles C + xHarbour, 32 bits
   cPre := ""
   cExt := ".lib"
   &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define32bits ) := {}
   if Prj_Check_Console
   if PUB_bDebugActive
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define32bits ), cPre+'gtgui'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define32bits ), cPre+'gtwin'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define32bits ), cPre+'debug'+cExt )
   else
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define32bits ), cPre+'gtgui'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define32bits ), cPre+'gtwin'+cExt )
   endif
   else
   if PUB_bDebugActive
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define32bits ), cPre+'gtgui'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define32bits ), cPre+'gtwin'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define32bits ), cPre+'debug'+cExt )
   else
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define32bits ), cPre+'gtgui'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define32bits ), cPre+'gtwin'+cExt )
   endif
   endif

   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define32bits ), cPre+'comctl32'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define32bits ), cPre+'comdlg32'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define32bits ), cPre+'gdi32'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define32bits ), cPre+'iphlpapi'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define32bits ), cPre+'mapi32'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define32bits ), cPre+'mpr'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define32bits ), cPre+'msimg32'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define32bits ), cPre+'ole32'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define32bits ), cPre+'oleaut32'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define32bits ), cPre+'shell32'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define32bits ), cPre+'user32'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define32bits ), cPre+'uuid'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define32bits ), cPre+'vfw32'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define32bits ), cPre+'winmm'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define32bits ), cPre+'winspool'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define32bits ), cPre+'ws2_32'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define32bits ), cPre+'wsock32'+cExt )

   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define32bits ), cPre+'ace32'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define32bits ), cPre+'bostaurus'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define32bits ), cPre+'advapi32'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define32bits ), cPre+'codepage'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define32bits ), cPre+'common'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define32bits ), cPre+'crt'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define32bits ), cPre+'ct'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define32bits ), cPre+'dbfcdx'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define32bits ), cPre+'dbfdbt'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define32bits ), cPre+'dbffpt'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define32bits ), cPre+'dbfntx'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define32bits ), cPre+'dll'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define32bits ), cPre+'hbhpdf'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define32bits ), cPre+'hbmzip'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define32bits ), cPre+'hbole'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define32bits ), cPre+'hbprinter'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define32bits ), cPre+'hbsix'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define32bits ), cPre+'hbzebra'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define32bits ), cPre+'hbzip'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define32bits ), cPre+'hbzlib'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define32bits ), cPre+'hpdf'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define32bits ), cPre+'hsx'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define32bits ), cPre+'kernel32'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define32bits ), cPre+'lang'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define32bits ), cPre+'libct'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define32bits ), cPre+'libharu'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define32bits ), cPre+'libhpdf'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define32bits ), cPre+'libmisc'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define32bits ), cPre+'libmysql'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define32bits ), cPre+'libpng'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define32bits ), cPre+'macro'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define32bits ), cPre+'miniprint'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define32bits ), cPre+'mysql'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define32bits ), cPre+'olepro32'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define32bits ), cPre+'pcrepos'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define32bits ), cPre+'png'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define32bits ), cPre+'pp'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define32bits ), cPre+'rdd'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define32bits ), cPre+'rddads'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define32bits ), cPre+'rtl'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define32bits ), cPre+'socket'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define32bits ), cPre+'tip'+cExt )
   if Prj_Check_MT
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define32bits ), cPre+'vmmt'+cExt )
   else
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define32bits ), cPre+'vm'+cExt )
   endif
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define32bits ), cPre+'zlib1'+cExt )

   // 19 - OOHG + Pelles C + Harbour, 64 bits
   cPre := ""
   cExt := ".lib"
   &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define64bits ) := {}
   if Prj_Check_Console
   if PUB_bDebugActive
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define64bits ), cPre+'gtgui'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define64bits ), cPre+'gtwin'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define64bits ), cPre+'hbdebug'+cExt )
   else
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define64bits ), cPre+'gtgui'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define64bits ), cPre+'gtwin'+cExt )
   endif
   else
   if PUB_bDebugActive
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define64bits ), cPre+'gtgui'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define64bits ), cPre+'gtwin'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define64bits ), cPre+'hbdebug'+cExt )
   else
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define64bits ), cPre+'gtgui'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define64bits ), cPre+'gtwin'+cExt )
   endif
   endif

   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define64bits ), cPre+'comctl32'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define64bits ), cPre+'comdlg32'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define64bits ), cPre+'gdi32'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define64bits ), cPre+'iphlpapi'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define64bits ), cPre+'mapi32'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define64bits ), cPre+'mpr'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define64bits ), cPre+'msimg32'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define64bits ), cPre+'ole32'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define64bits ), cPre+'oleaut32'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define64bits ), cPre+'shell32'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define64bits ), cPre+'user32'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define64bits ), cPre+'uuid'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define64bits ), cPre+'vfw32'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define64bits ), cPre+'winmm'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define64bits ), cPre+'winspool'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define64bits ), cPre+'ws2_32'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define64bits ), cPre+'wsock32'+cExt )

   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define64bits ), cPre+'ace32'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define64bits ), cPre+'bostaurus'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define64bits ), cPre+'advapi32'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define64bits ), cPre+'crt'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define64bits ), cPre+'dll'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define64bits ), cPre+'hbcommon'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define64bits ), cPre+'hbcpage'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define64bits ), cPre+'hbct'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define64bits ), cPre+'hbhpdf'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define64bits ), cPre+'hbhsx'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define64bits ), cPre+'hblang'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define64bits ), cPre+'hbmacro'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define64bits ), cPre+'hbmzip'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define64bits ), cPre+'hbole'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define64bits ), cPre+'hbpcre'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define64bits ), cPre+'hbpcre2'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define64bits ), cPre+'hbpp'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define64bits ), cPre+'hbprinter'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define64bits ), cPre+'hbrdd'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define64bits ), cPre+'hbrtl'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define64bits ), cPre+'hbsix'+cExt )
   if Prj_Check_MT
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define64bits ), cPre+'hbvmmt'+cExt )
   else
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define64bits ), cPre+'hbvm'+cExt )
   endif
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define64bits ), cPre+'hbw32'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define64bits ), cPre+'hbzebra'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define64bits ), cPre+'hbzip'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define64bits ), cPre+'hbziparc'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define64bits ), cPre+'hbziparch'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define64bits ), cPre+'hbzlib'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define64bits ), cPre+'hpdf'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define64bits ), cPre+'kernel32'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define64bits ), cPre+'libct'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define64bits ), cPre+'libharu'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define64bits ), cPre+'libhpdf'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define64bits ), cPre+'libmisc'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define64bits ), cPre+'libmysql'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define64bits ), cPre+'libpng'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define64bits ), cPre+'miniprint'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define64bits ), cPre+'minizip'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define64bits ), cPre+'mysql'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define64bits ), cPre+'olepro32'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define64bits ), cPre+'pcrepos'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define64bits ), cPre+'png'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define64bits ), cPre+'rddads'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define64bits ), cPre+'rddcdx'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define64bits ), cPre+'rdddbt'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define64bits ), cPre+'rddfpt'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define64bits ), cPre+'rddntx'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define64bits ), cPre+'socket'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define64bits ), cPre+'tip'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define64bits ), cPre+'xhb'+cExt )  // must come after haru
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define64bits ), cPre+'zlib1'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineHarbour+Define64bits ), cPre+'hbwin'+cExt )  // must come after haru

   // 20 - OOHG + Pelles C + xHarbour, 64 bits
   cPre := ""
   cExt := ".lib"
   &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define64bits ) := {}
   if Prj_Check_Console
   if PUB_bDebugActive
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define64bits ), cPre+'gtgui'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define64bits ), cPre+'gtwin'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define64bits ), cPre+'debug'+cExt )
   else
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define64bits ), cPre+'gtgui'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define64bits ), cPre+'gtwin'+cExt )
   endif
   else
   if PUB_bDebugActive
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define64bits ), cPre+'gtgui'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define64bits ), cPre+'gtwin'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define64bits ), cPre+'debug'+cExt )
   else
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define64bits ), cPre+'gtgui'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define64bits ), cPre+'gtwin'+cExt )
   endif
   endif

   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define64bits ), cPre+'comctl32'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define64bits ), cPre+'comdlg32'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define64bits ), cPre+'gdi32'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define64bits ), cPre+'iphlpapi'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define64bits ), cPre+'mapi32'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define64bits ), cPre+'mpr'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define64bits ), cPre+'msimg32'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define64bits ), cPre+'ole32'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define64bits ), cPre+'oleaut32'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define64bits ), cPre+'shell32'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define64bits ), cPre+'user32'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define64bits ), cPre+'uuid'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define64bits ), cPre+'vfw32'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define64bits ), cPre+'winmm'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define64bits ), cPre+'winspool'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define64bits ), cPre+'ws2_32'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define64bits ), cPre+'wsock32'+cExt )

   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define64bits ), cPre+'ace32'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define64bits ), cPre+'bostaurus'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define64bits ), cPre+'advapi32'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define64bits ), cPre+'codepage'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define64bits ), cPre+'common'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define64bits ), cPre+'crt'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define64bits ), cPre+'ct'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define64bits ), cPre+'dbfcdx'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define64bits ), cPre+'dbfdbt'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define64bits ), cPre+'dbffpt'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define64bits ), cPre+'dbfntx'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define64bits ), cPre+'dll'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define64bits ), cPre+'hbhpdf'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define64bits ), cPre+'hbmzip'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define64bits ), cPre+'hbole'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define64bits ), cPre+'hbprinter'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define64bits ), cPre+'hbsix'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define64bits ), cPre+'hbzip'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define64bits ), cPre+'hbzebra'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define64bits ), cPre+'hbzlib'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define64bits ), cPre+'hpdf'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define64bits ), cPre+'hsx'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define64bits ), cPre+'kernel32'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define64bits ), cPre+'lang'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define64bits ), cPre+'libct'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define64bits ), cPre+'libharu'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define64bits ), cPre+'libhpdf'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define64bits ), cPre+'libmisc'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define64bits ), cPre+'libmysql'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define64bits ), cPre+'libpng'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define64bits ), cPre+'macro'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define64bits ), cPre+'miniprint'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define64bits ), cPre+'mysql'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define64bits ), cPre+'olepro32'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define64bits ), cPre+'pcrepos'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define64bits ), cPre+'png'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define64bits ), cPre+'pp'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define64bits ), cPre+'rdd'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define64bits ), cPre+'rddads'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define64bits ), cPre+'rtl'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define64bits ), cPre+'socket'+cExt )
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define64bits ), cPre+'tip'+cExt )
   if Prj_Check_MT
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define64bits ), cPre+'vmmt'+cExt )
   else
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define64bits ), cPre+'vm'+cExt )
   endif
   aadd( &( "vLibDefault"+DefineOohg3+DefinePelles+DefineXHarbour+Define64bits ), cPre+'zlib1'+cExt )

Return .T.

/* eof */
