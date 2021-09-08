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

FUNCTION QPM_ResetLibrariesForFlavor( cFlavor )
   ASize( &('Gbl_DEF_LIBS_'+cFlavor), 0 )
   QPM_InitLibrariesForFlavor( cFlavor )
   CargoDefaultLibs( GetSuffix() )                   // This loads the default libraries grid
   MyMsgInfo( "Default Libraries List was reseted!" )
RETURN .T.

FUNCTION QPM_InitLibrariesForFlavor( cFlavor )
   LOCAL aLibs, nCant, i, aData, n, e, s

   aLibs := &('Gbl_DEF_LIBS_'+cFlavor)
   IF Len( aLibs ) == 0
      SetDefaultLibraries( cFlavor )
      aLibs := &('Gbl_DEF_LIBS_'+cFlavor)
   ENDIF

   i := 1
   DO WHILE i <= Len( aLibs )
      IF aLibs[i,2] == "B"
         ASize( aLibs, Len( aLibs ) + 1 )
         AIns( aLibs, i+1 )
         aLibs[i+1] := { aLibs[i,1], "G", aLibs[i,3], aLibs[i,4] }
         aLibs[i,2] := "C"
      ENDIF
      IF aLibs[i,3] == "B"
         ASize( aLibs, Len( aLibs ) + 1 )
         AIns( aLibs, i+1 )
         aLibs[i+1] := { aLibs[i,1], aLibs[i,2], "M", aLibs[i,4] }
         aLibs[i,3] := "S"
      ENDIF
      IF aLibs[i,4] == "B"
         ASize( aLibs, Len( aLibs ) + 1 )
         AIns( aLibs, i+1 )
         aLibs[i+1] := { aLibs[i,1], aLibs[i,2], aLibs[i,3], "Y" }
         aLibs[i,4] := "N"
      ENDIF
      i ++
   ENDDO

   vLibsDefault := {}   // array of { name, mode, threads, debug } - some libs may not exist
   vLibsToLink  := {}   // array of lib names                      - all libs exist

   nCant := Len( aLibs )
   FOR i := 1 TO nCant
      aData := aLibs[i]   // cFile, cMode, cThreads, cDebug
      AAdd( vLibsDefault, aData )
      IF ( Prj_Check_Console .AND. aLibs[i,2] == "C" ) .OR. ( ! Prj_Check_Console .AND. aLibs[i,2] == "G" )
         IF ( Prj_Check_MT .AND. aLibs[i,3] == "M" ) .OR. ( ! Prj_Check_MT .AND. aLibs[i,3] == "S" )
            IF ( PUB_bDebugActive .AND. aLibs[i,4] == "Y" ) .OR. ( ! PUB_bDebugActive .AND. aLibs[i,4] == "N" )
               e := Upper( US_FileNameOnlyExt( n := aLibs[i,1] ) )
               s := GetCppSuffix()
               IF e == 'O' .OR. e == 'OBJ'
                  IF File( GetMiniGuiFolder() + DEF_SLASH + 'RESOURCES' + DEF_SLASH + n )
                     AAdd( vLibsToLink, n )
                  ELSEIF File( PUB_cProjectFolder + DEF_SLASH + n )
                     AAdd( vLibsToLink, n )
                  ELSEIF File( GetCppLibFolder() + DEF_SLASH + n )
                     AAdd( vLibsToLink, n )
                  ENDIF
               ELSEIF File( GetMiniGuiLibFolder() + DEF_SLASH + n )
                  AAdd( vLibsToLink, n )
               ELSEIF File( GetHarbourLibFolder() + DEF_SLASH + n )
                  AAdd( vLibsToLink, n )
               ELSEIF File( GetCppLibFolder() + DEF_SLASH + n )
                  AAdd( vLibsToLink, n )
               ELSEIF s == DefineMinGW
                  IF File( GetCppFolder() + DEF_SLASH + "lib" + DEF_SLASH + n )
                     AAdd( vLibsToLink, n )
                  ELSEIF Prj_Check_64bits .AND. File( GetCppFolder() + DEF_SLASH + "x86_64-w64-mingw32" + DEF_SLASH + "lib" + DEF_SLASH + n )
                     AAdd( vLibsToLink, n )
                  ELSEIF ! Prj_Check_64bits .AND. File( GetCppFolder() + DEF_SLASH + "i686-w64-mingw32" + DEF_SLASH + "lib" + DEF_SLASH + n )
                     AAdd( vLibsToLink, n )
                  ENDIF
               ELSEIF s == DefinePelles
                  IF File( GetCppLibFolder() + DEF_SLASH + 'WIN' + DEF_SLASH + n )
                     AAdd( vLibsToLink, n )
                  ENDIF
               ELSEIF s == DefineBorland
                  IF File( GetCppLibFolder() + DEF_SLASH + 'PSDK' + DEF_SLASH + n )
                     AAdd( vLibsToLink, n )
                  ENDIF
               ENDIF
            ENDIF
         ENDIF
      ENDIF
   NEXT i

RETURN .T.

STATIC FUNCTION SetDefaultLibraries( cFlavor )

   LOCAL cCpp := GetCppSuffix(), cBits := GetBitsSuffix(), cPrg := GetHarbourSuffix(), aDefaultLibs := {}

   DO CASE
   CASE cCpp == DefineBorland
      // the order of the following libs is the same order used by HMG Extended
         AAdd( aDefaultLibs, { 'c0x32.obj',              'C', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'c0w32.obj',              'G', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'dbginit.obj',            'B', 'B', 'Y' } )
         AAdd( aDefaultLibs, { 'tsbrowse.lib',           'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'propgrid.lib',           'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'minigui.lib',            'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'oohg.lib',               'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'dll.lib',                'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'calldll.lib',            'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'gtwin.lib',              'C', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'gtgui.lib',              'C', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'gtgui.lib',              'G', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'gtwin.lib',              'G', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'hbodbc.lib',             'B', 'B', 'B' } )   // ODBC 1
         AAdd( aDefaultLibs, { 'odbc32.lib',             'B', 'B', 'B' } )   // ODBC 2
      IF cPrg == DefineHarbour
         AAdd( aDefaultLibs, { 'hbziparc.lib',           'B', 'B', 'B' } )   // ZIP 1
         AAdd( aDefaultLibs, { 'hbmzip.lib',             'B', 'B', 'B' } )   // ZIP 2
         AAdd( aDefaultLibs, { 'minizip.lib',            'B', 'B', 'B' } )   // ZIP 3
         AAdd( aDefaultLibs, { 'hbzlib.lib',             'B', 'B', 'B' } )   // ZIP 4
      ELSE   // DefineXHarbour
         AAdd( aDefaultLibs, { 'hbzip.lib',              'B', 'B', 'B' } )   // ZIP
      ENDIF
         AAdd( aDefaultLibs, { 'rddads.lib',             'B', 'B', 'B' } )   // ADS 1
         AAdd( aDefaultLibs, { 'ace32.lib',              'B', 'B', 'B' } )   // ADS 2
         AAdd( aDefaultLibs, { 'hbmysql.lib',            'B', 'B', 'B' } )   // MYSQL 1
         AAdd( aDefaultLibs, { 'libmysql.lib',           'B', 'B', 'B' } )   // MYSQL 2
         AAdd( aDefaultLibs, { 'libpq.lib',              'B', 'B', 'B' } )   // PGSQL 1
         AAdd( aDefaultLibs, { 'hbpgsql.lib',            'B', 'B', 'B' } )   // PGSQL 2
         AAdd( aDefaultLibs, { 'bostaurus.lib',          'B', 'B', 'B' } )   // BT
      // add other libs here
      IF cPrg == DefineHarbour
         AAdd( aDefaultLibs, { 'hbcplr.lib',             'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'hbrtl.lib',              'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'hbvm.lib',               'B', 'S', 'B' } )
         AAdd( aDefaultLibs, { 'hbvmmt.lib',             'B', 'M', 'B' } )
         AAdd( aDefaultLibs, { 'hbhpdf.lib',             'B', 'B', 'B' } )                // must come before xhb, hbwin, hblang
         AAdd( aDefaultLibs, { 'hblang.lib',             'B', 'B', 'B' } )                // must come after haru, hpdf, libharu and libhpdf
         AAdd( aDefaultLibs, { 'hbcpage.lib',            'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'hbmacro.lib',            'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'hbrdd.lib',              'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'hbhsx.lib',              'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'rddntx.lib',             'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'rddcdx.lib',             'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'rddfpt.lib',             'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'hbsix.lib',              'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'hbcommon.lib',           'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'hbdebug.lib',            'B', 'B', 'Y' } )
         AAdd( aDefaultLibs, { 'hbpp.lib',               'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'hbpcre.lib',             'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'hbct.lib',               'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'hbmisc.lib',             'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'hbtip.lib',              'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'hbvpdf.lib',             'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'hbwin.lib',              'B', 'B', 'B' } )                // must come after haru, hpdf, libharu and libhpdf
         AAdd( aDefaultLibs, { 'xhb.lib',                'B', 'B', 'B' } )                // must come after haru, hpdf, libharu and libhpdf
         AAdd( aDefaultLibs, { 'ws2_32.lib',             'B', 'B', 'B' } )
      ELSE   // DefineXHarbour
         AAdd( aDefaultLibs, { 'rtl.lib',                'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'vm.lib',                 'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'lang.lib',               'B', 'B', 'B' } )                // must come after haru, hpdf, libharu and libhpdf
         AAdd( aDefaultLibs, { 'codepage.lib',           'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'macro.lib',              'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'rdd.lib',                'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'dbfntx.lib',             'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'dbfcdx.lib',             'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'dbffpt.lib',             'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'hbsix.lib',              'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'common.lib',             'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'debug.lib',              'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'pp.lib',                 'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'pcrepos.lib',            'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'ct.lib',                 'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'libmisc.lib',            'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'tip.lib',                'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'hbvpdf.lib',             'B', 'B', 'B' } )
      ENDIF
         AAdd( aDefaultLibs, { 'hbprinter.lib',          'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'miniprint.lib',          'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'socket.lib',             'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'import32.lib',           'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'iphlpapi.lib',           'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'msimg32.lib',            'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'cw32mt.lib',             'B', 'M', 'B' } )
         AAdd( aDefaultLibs, { 'cw32.lib',               'B', 'S', 'B' } )     

   CASE cCpp == DefinePelles
         AAdd( aDefaultLibs, { 'tsbrowse.lib',           'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'propgrid.lib',           'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'minigui.lib',            'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'oohg.lib',               'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'dll.lib',                'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'gtwin.lib',              'C', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'gtgui.lib',              'C', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'gtgui.lib',              'G', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'gtwin.lib',              'G', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'hbodbc.lib',             'B', 'B', 'B' } )   // ODBC 1
         AAdd( aDefaultLibs, { 'odbc32.lib',             'B', 'B', 'B' } )   // ODBC 2
      IF cPrg == DefineHarbour
         AAdd( aDefaultLibs, { 'hbziparc.lib',           'B', 'B', 'B' } )   // ZIP 1
         AAdd( aDefaultLibs, { 'hbmzip.lib',             'B', 'B', 'B' } )   // ZIP 2
         AAdd( aDefaultLibs, { 'minizip.lib',            'B', 'B', 'B' } )   // ZIP 3
         AAdd( aDefaultLibs, { 'hbzlib.lib',             'B', 'B', 'B' } )   // ZIP 4
      ELSE   // DefineXHarbour
         AAdd( aDefaultLibs, { 'hbzip.lib',              'B', 'B', 'B' } )   // ZIP
      ENDIF
         AAdd( aDefaultLibs, { 'rddads.lib',             'B', 'B', 'B' } )   // ADS 1
         AAdd( aDefaultLibs, { 'ace32.lib',              'B', 'B', 'B' } )   // ADS 2
         AAdd( aDefaultLibs, { 'hbmysql.lib',            'B', 'B', 'B' } )   // MYSQL 1
         AAdd( aDefaultLibs, { 'libmysql.lib',           'B', 'B', 'B' } )   // MYSQL 2
         AAdd( aDefaultLibs, { 'libpq.lib',              'B', 'B', 'B' } )   // PGSQL 2
         AAdd( aDefaultLibs, { 'hbpgsql.lib',            'B', 'B', 'B' } )   // PGSQL 2
         AAdd( aDefaultLibs, { 'bostaurus.lib',          'B', 'B', 'B' } )   // BT
      // add other libs here
      IF cPrg == DefineHarbour
         AAdd( aDefaultLibs, { 'hbcplr.lib',             'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'hbrtl.lib',              'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'hbvm.lib',               'B', 'S', 'B' } )
         AAdd( aDefaultLibs, { 'hbvmmt.lib',             'B', 'M', 'B' } )
         AAdd( aDefaultLibs, { 'hbhpdf.lib',             'B', 'B', 'B' } )                // must come before xhb, hbwin, hblang
         AAdd( aDefaultLibs, { 'hblang.lib',             'B', 'B', 'B' } )                // must come after haru, hpdf, libharu and libhpdf
         AAdd( aDefaultLibs, { 'hbcpage.lib',            'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'hbmacro.lib',            'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'hbrdd.lib',              'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'hbhsx.lib',              'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'rddntx.lib',             'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'rddcdx.lib',             'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'rddfpt.lib',             'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'hbsix.lib',              'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'hbcommon.lib',           'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'hbdebug.lib',            'B', 'B', 'Y' } )
         AAdd( aDefaultLibs, { 'hbpp.lib',               'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'hbpcre.lib',             'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'hbct.lib',               'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'hbmisc.lib',             'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'hbtip.lib',              'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'hbvpdf.lib',             'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'hbwin.lib',              'B', 'B', 'B' } )                // must come after haru, hpdf, libharu and libhpdf
         AAdd( aDefaultLibs, { 'xhb.lib',                'B', 'B', 'B' } )                // must come after haru, hpdf, libharu and libhpdf
         AAdd( aDefaultLibs, { 'ws2_32.lib',             'B', 'B', 'B' } )
      ELSE   // DefineXHarbour
         AAdd( aDefaultLibs, { 'rtl.lib',                'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'vm.lib',                 'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'lang.lib',               'B', 'B', 'B' } )                // must come after haru, hpdf, libharu and libhpdf
         AAdd( aDefaultLibs, { 'codepage.lib',           'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'macro.lib',              'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'rdd.lib',                'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'dbfntx.lib',             'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'dbfcdx.lib',             'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'dbffpt.lib',             'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'hbsix.lib',              'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'common.lib',             'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'debug.lib',              'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'pp.lib',                 'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'pcrepos.lib',            'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'ct.lib',                 'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'libmisc.lib',            'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'tip.lib',                'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'hbvpdf.lib',             'B', 'B', 'B' } )
      ENDIF
         AAdd( aDefaultLibs, { 'hbprinter.lib',          'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'miniprint.lib',          'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'socket.lib',             'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'import32.lib',           'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'iphlpapi.lib',           'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'msimg32.lib',            'B', 'B', 'B' } )
      IF cBits == Define32bits
         AAdd( aDefaultLibs, { 'crtmt.lib',              'B', 'M', 'B' } )
         AAdd( aDefaultLibs, { 'crt.lib',                'B', 'S', 'B' } )
      ELSE
         AAdd( aDefaultLibs, { 'crtmt64.lib',            'B', 'M', 'B' } )
         AAdd( aDefaultLibs, { 'crt64.lib',              'B', 'S', 'B' } )
      ENDIF

   CASE cCpp == DefineMinGW
      // the order of the following libs is the same order used by HMG Extended
         AAdd( aDefaultLibs, { 'libminigui.a',           'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'liboohg.a',              'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'libhbprinter.a',         'B', 'B', 'B' } )
      IF cBits == Define32bits
         AAdd( aDefaultLibs, { 'libminiprint.a',         'B', 'B', 'B' } )
      ELSE
         AAdd( aDefaultLibs, { 'libminiprint2.a',        'B', 'B', 'B' } )
      ENDIF
         AAdd( aDefaultLibs, { 'libbostaurus.a',         'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'libadordd.a',            'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'libcalldll.a',           'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'libtsbrowse.a',          'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'libhbct.a',              'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'libhbtip.a',             'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'libhbwin.a',             'B', 'B', 'B' } )                // must come after haru, hpdf, libharu and libhpdf
         AAdd( aDefaultLibs, { 'libhbvpdf.a',            'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'libxhb.a',               'B', 'B', 'B' } )                // must come after haru, hpdf, libharu and libhpdf
         AAdd( aDefaultLibs, { 'libhbmisc.a',            'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'libhbziparc.a',          'B', 'B', 'B' } )   // ZIP 1
         AAdd( aDefaultLibs, { 'libhbmzip.a',            'B', 'B', 'B' } )   // ZIP 2
         AAdd( aDefaultLibs, { 'libminizip.a',           'B', 'B', 'B' } )   // ZIP 3
         AAdd( aDefaultLibs, { 'libmsvfw32.a',           'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'libvfw32.a',             'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'libhbextern.a',          'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'libhbdebug.a',           'B', 'B', 'Y' } )
         AAdd( aDefaultLibs, { 'libhbvm.a',              'B', 'S', 'B' } )
         AAdd( aDefaultLibs, { 'libhbvmmt.a',            'B', 'M', 'B' } )
         AAdd( aDefaultLibs, { 'libhbrtl.a',             'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'libhblang.a',            'B', 'B', 'B' } )                // must come after haru, hpdf, libharu and libhpdf
         AAdd( aDefaultLibs, { 'libhbcpage.a',           'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'libgtwin.a',             'C', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'libgtgui.a',             'C', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'libgtgui.a',             'G', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'libgtwin.a',             'G', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'libhbrdd.a',             'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'libhbusrrdd.a',          'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'librddntx.a',            'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'librddcdx.a',            'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'librddnsx.a',            'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'librddfpt.a',            'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'libhbrdd.a',             'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'libhbhsx.a',             'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'libhbsix.a',             'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'libhbmacro.a',           'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'libhbcplr.a',            'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'libhbpp.a',              'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'libhbcommon.a',          'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'libhbmainwin.a',         'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'libkernel32.a',          'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'libuser32.a',            'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'libgdi32.a',             'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'libadvapi32.a',          'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'libws2_32.a',            'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'libiphlpapi.a',          'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'libwinspool.a',          'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'libcomctl32.a',          'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'libcomdlg32.a',          'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'libshell32.a',           'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'libuuid.a',              'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'libole32.a',             'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'liboleaut32.a',          'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'libmpr.a',               'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'libwinmm.a',             'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'libmapi32.a',            'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'libimm32.a',             'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'libmsimg32.a',           'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'libwininet.a',           'B', 'B', 'B' } )
      IF Prj_Combo_HBVersion == DEF_CB_HB34
         AAdd( aDefaultLibs, { 'libhbpcre2.a',           'B', 'B', 'B' } )
      ELSE
         AAdd( aDefaultLibs, { 'libhbpcre.a',            'B', 'B', 'B' } )
      ENDIF
         AAdd( aDefaultLibs, { 'libhbzlib.a',            'B', 'B', 'B' } )   // ZIP 4
         AAdd( aDefaultLibs, { 'libhbxml.a',             'B', 'B', 'B' } )   // XML
/*
// otras
      IF cPrg == DefineHarbour
         AAdd( aDefaultLibs, { 'libhbpcre.a',            'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'libhbodbc.a',            'B', 'B', 'B' } )   // ODBC 1
         AAdd( aDefaultLibs, { 'libhbmysql.a',           'B', 'B', 'B' } )   // MYSQL 1
         AAdd( aDefaultLibs, { 'liblibmysql.a',          'B', 'B', 'B' } )   // MYSQL 2
         AAdd( aDefaultLibs, { 'libhbhpdf.a',            'B', 'B', 'B' } )                // must come before xhb, hbwin, hblang
         AAdd( aDefaultLibs, { 'liblibhpdf.a',           'B', 'B', 'B' } )                
      ELSE   // DefineXHarbour
         AAdd( aDefaultLibs, { 'libhbzip.a',             'B', 'B', 'B' } )   // ZIP
         AAdd( aDefaultLibs, { 'librtl.a',               'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'libvm.a',                'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'liblang.a',              'B', 'B', 'B' } )                // must come after haru, hpdf, libharu and libhpdf
         AAdd( aDefaultLibs, { 'libcodepage.a',          'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'libmacro.a',             'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'librdd.a',               'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'libdbfntx.a',            'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'libdbfcdx.a',            'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'libdbffpt.a',            'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'libhbsix.a',             'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'libcommon.a',            'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'libdebug.a',             'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'libpp.a',                'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'libpcrepos.a',           'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'libct.a',                'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'liblibmisc.a',           'B', 'B', 'B' } )
         AAdd( aDefaultLibs, { 'libtip.a',               'B', 'B', 'B' } )
      ENDIF
      IF cBits == Define32bits
         AAdd( aDefaultLibs, { 'libodbc32.a',            'B', 'B', 'B' } )   // ODBC 2
         AAdd( aDefaultLibs, { 'librddads.a',            'B', 'B', 'B' } )   // ADS 1
         AAdd( aDefaultLibs, { 'libace32.a',             'B', 'B', 'B' } )   // ADS 2
         AAdd( aDefaultLibs, { 'liblibpq.a',             'B', 'B', 'B' } )   // PGSQL 1
         AAdd( aDefaultLibs, { 'libhbpgsql.a',           'B', 'B', 'B' } )   // PGSQL 2
         AAdd( aDefaultLibs, { 'libsocket.a',            'B', 'B', 'B' } )
      ELSE
      ENDIF
*/
   OTHERWISE
      RETURN 0
   ENDCASE

   &('Gbl_DEF_LIBS_'+cFlavor) := aDefaultLibs

RETURN Len( aDefaultLibs )

/* eof */
