/*
 *    QPM - QAC based Project Manager
 *
 *    Copyright 2011-2020 Fernando Yurisich <teamqpm@gmail.com>
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

   PRIVATE PRI_COMPATIBILITY_INX
   PRIVATE PRI_COMPATIBILITY_LINE
   /* INI - Parche para compatibilidad con version 01.00.01 */
   if PRI_COMPATIBILITY_ENVIRONMENTVERSION = val( "010001" )
      PRI_COMPATIBILITY_ENVIRONMENTFILEAUX := PRI_COMPATIBILITY_ENVIRONMENTFILE
      PRI_COMPATIBILITY_ENVIRONMENTFILE := ""
      For PRI_COMPATIBILITY_INX := 1 To MLCount ( PRI_COMPATIBILITY_ENVIRONMENTFILEAUX , 254 )
         DO EVENTS
         PRI_COMPATIBILITY_LINE := AllTrim ( MEMOLINE( PRI_COMPATIBILITY_ENVIRONMENTFILEAUX , 254 , PRI_COMPATIBILITY_INX ) )
         PRI_COMPATIBILITY_LINE := strtran( PRI_COMPATIBILITY_LINE , "=" , " " )
         If      US_Upper( US_Word( PRI_COMPATIBILITY_LINE , 1 ) ) = 'BCCFOLDER'
                 PRI_COMPATIBILITY_LINE := "CCOMPILATORO1X " + US_WordSubStr( PRI_COMPATIBILITY_LINE , 2 )
         ElseIf  US_Upper( US_Word( PRI_COMPATIBILITY_LINE , 1 ) ) = 'MINGWFOLDER'
                 PRI_COMPATIBILITY_LINE := "CCOMPILATORO2X " + US_WordSubStr( PRI_COMPATIBILITY_LINE , 2 )
         ElseIf  US_Upper( US_Word( PRI_COMPATIBILITY_LINE , 1 ) ) = 'MINIGUIFOLDER1X'
                 PRI_COMPATIBILITY_LINE := "MINIGUIFOLDERO1X " + US_WordSubStr( PRI_COMPATIBILITY_LINE , 2 )
         ElseIf  US_Upper( US_Word( PRI_COMPATIBILITY_LINE , 1 ) ) = 'MINIGUIFOLDER2X'
                 PRI_COMPATIBILITY_LINE := "MINIGUIFOLDERO2X " + US_WordSubStr( PRI_COMPATIBILITY_LINE , 2 )
         ElseIf  US_Upper( US_Word( PRI_COMPATIBILITY_LINE , 1 ) ) = 'HARBOURFOLDER1X'
                 PRI_COMPATIBILITY_LINE := "HARBOURFOLDERO1X " + US_WordSubStr( PRI_COMPATIBILITY_LINE , 2 )
         ElseIf  US_Upper( US_Word( PRI_COMPATIBILITY_LINE , 1 ) ) = 'HARBOURFOLDER2X'
                 PRI_COMPATIBILITY_LINE := "HARBOURFOLDERO2X " + US_WordSubStr( PRI_COMPATIBILITY_LINE , 2 )
         ElseIf  US_Upper( US_Word( PRI_COMPATIBILITY_LINE , 1 ) ) = 'XHARBOURFOLDER1X'
                 PRI_COMPATIBILITY_LINE := "XHARBOURFOLDERO1X " + US_WordSubStr( PRI_COMPATIBILITY_LINE , 2 )
         ElseIf  US_Upper( US_Word( PRI_COMPATIBILITY_LINE , 1 ) ) = 'XHARBOURFOLDER2X'
                 PRI_COMPATIBILITY_LINE := "XHARBOURFOLDERO2X " + US_WordSubStr( PRI_COMPATIBILITY_LINE , 2 )
         EndIf
         PRI_COMPATIBILITY_ENVIRONMENTFILE := PRI_COMPATIBILITY_ENVIRONMENTFILE + PRI_COMPATIBILITY_LINE + HB_OsNewLine()
      next
      PRI_COMPATIBILITY_ENVIRONMENTVERSION = val( "010300" )
   endif
   /* FIN - Parche para compatibilidad con version 01.00.01 */
   /* */
   /* INI - Parche para compatibilidad con version hasta 03.03.99 */
   if PRI_COMPATIBILITY_ENVIRONMENTVERSION <= val( "030399" )
      PRIVATE var030399_MiniGui1 := "M1"
      PRIVATE var030399_MiniGui2 := "M2"
      PRIVATE var030399_Extended1:= "E1"
      PRIVATE var030399_Oohg1    := "O1"
      PRIVATE var030399_Harbour  := "H"
      PRIVATE var030399_XHarbour := "X"
      PRIVATE var030399_Borland  := "B"
      PRIVATE var030399_MinGW    := "G"
      PRI_COMPATIBILITY_ENVIRONMENTFILEAUX := PRI_COMPATIBILITY_ENVIRONMENTFILE
      PRI_COMPATIBILITY_ENVIRONMENTFILE := ""
      For PRI_COMPATIBILITY_INX := 1 To MLCount ( PRI_COMPATIBILITY_ENVIRONMENTFILEAUX , 254 )
         DO EVENTS
         PRI_COMPATIBILITY_LINE := AllTrim ( MEMOLINE( PRI_COMPATIBILITY_ENVIRONMENTFILEAUX , 254 , PRI_COMPATIBILITY_INX ) )
         PRI_COMPATIBILITY_LINE := strtran( PRI_COMPATIBILITY_LINE , "=" , " " )
         If      US_Upper( US_Word( PRI_COMPATIBILITY_LINE , 1 ) ) = 'MINIGUIFOLDERO1X'
                 PRI_COMPATIBILITY_LINE := "MINIGUIFOLDER"+var030399_MiniGui1+var030399_Borland+" " + US_WordSubStr( PRI_COMPATIBILITY_LINE , 2 )
         ElseIf  US_Upper( US_Word( PRI_COMPATIBILITY_LINE , 1 ) ) = 'CCOMPILATORO1X'
                 PRI_COMPATIBILITY_LINE := "CCOMPILATOR"+var030399_MiniGui1+var030399_Borland+" " + US_WordSubStr( PRI_COMPATIBILITY_LINE , 2 )
         ElseIf  US_Upper( US_Word( PRI_COMPATIBILITY_LINE , 1 ) ) = 'HARBOURFOLDERO1X'
                 PRI_COMPATIBILITY_LINE := "HARBOURFOLDER"+var030399_MiniGui1+var030399_Borland+" " + US_WordSubStr( PRI_COMPATIBILITY_LINE , 2 )
         ElseIf  US_Upper( US_Word( PRI_COMPATIBILITY_LINE , 1 ) ) = 'XHARBOURFOLDERO1X'
                 PRI_COMPATIBILITY_LINE := "XHARBOURFOLDER"+var030399_MiniGui1+var030399_Borland+" " + US_WordSubStr( PRI_COMPATIBILITY_LINE , 2 )
         ElseIf  US_Upper( US_Word( PRI_COMPATIBILITY_LINE , 1 ) ) = 'MINIGUIFOLDERO2X'
                 PRI_COMPATIBILITY_LINE := "MINIGUIFOLDER"+var030399_MiniGui2+var030399_MinGW+" " + US_WordSubStr( PRI_COMPATIBILITY_LINE , 2 )
         ElseIf  US_Upper( US_Word( PRI_COMPATIBILITY_LINE , 1 ) ) = 'CCOMPILATORO2X'
                 PRI_COMPATIBILITY_LINE := "CCOMPILATOR"+var030399_MiniGui2+var030399_MinGW+" " + US_WordSubStr( PRI_COMPATIBILITY_LINE , 2 )
         ElseIf  US_Upper( US_Word( PRI_COMPATIBILITY_LINE , 1 ) ) = 'HARBOURFOLDERO2X'
                 PRI_COMPATIBILITY_LINE := "HARBOURFOLDER"+var030399_MiniGui2+var030399_MinGW+" " + US_WordSubStr( PRI_COMPATIBILITY_LINE , 2 )
         ElseIf  US_Upper( US_Word( PRI_COMPATIBILITY_LINE , 1 ) ) = 'XHARBOURFOLDERO2X'
                 PRI_COMPATIBILITY_LINE := "XHARBOURFOLDER"+var030399_MiniGui2+var030399_MinGW+" " + US_WordSubStr( PRI_COMPATIBILITY_LINE , 2 )
         ElseIf  US_Upper( US_Word( PRI_COMPATIBILITY_LINE , 1 ) ) = 'MINIGUIFOLDERE1X'
                 PRI_COMPATIBILITY_LINE := "MINIGUIFOLDER"+var030399_Extended1+var030399_Borland+" " + US_WordSubStr( PRI_COMPATIBILITY_LINE , 2 )
         ElseIf  US_Upper( US_Word( PRI_COMPATIBILITY_LINE , 1 ) ) = 'CCOMPILATORE1X'
                 PRI_COMPATIBILITY_LINE := "CCOMPILATOR"+var030399_Extended1+var030399_Borland+" " + US_WordSubStr( PRI_COMPATIBILITY_LINE , 2 )
         ElseIf  US_Upper( US_Word( PRI_COMPATIBILITY_LINE , 1 ) ) = 'HARBOURFOLDERE1X'
                 PRI_COMPATIBILITY_LINE := "HARBOURFOLDER"+var030399_Extended1+var030399_Borland+" " + US_WordSubStr( PRI_COMPATIBILITY_LINE , 2 )
         ElseIf  US_Upper( US_Word( PRI_COMPATIBILITY_LINE , 1 ) ) = 'XHARBOURFOLDERE1X'
                 PRI_COMPATIBILITY_LINE := "XHARBOURFOLDER"+var030399_Extended1+var030399_Borland+" " + US_WordSubStr( PRI_COMPATIBILITY_LINE , 2 )
         ElseIf  US_Upper( US_Word( PRI_COMPATIBILITY_LINE , 1 ) ) = 'MINIGUIFOLDERJ0X'
                 PRI_COMPATIBILITY_LINE := "MINIGUIFOLDER"+var030399_Oohg1+var030399_Borland+" " + US_WordSubStr( PRI_COMPATIBILITY_LINE , 2 )
         ElseIf  US_Upper( US_Word( PRI_COMPATIBILITY_LINE , 1 ) ) = 'CCOMPILATORJ0X'
                 PRI_COMPATIBILITY_LINE := "CCOMPILATOR"+var030399_Oohg1+var030399_Borland+" " + US_WordSubStr( PRI_COMPATIBILITY_LINE , 2 )
         ElseIf  US_Upper( US_Word( PRI_COMPATIBILITY_LINE , 1 ) ) = 'HARBOURFOLDERJ0X'
                 PRI_COMPATIBILITY_LINE := "HARBOURFOLDER"+var030399_Oohg1+var030399_Borland+" " + US_WordSubStr( PRI_COMPATIBILITY_LINE , 2 )
         ElseIf  US_Upper( US_Word( PRI_COMPATIBILITY_LINE , 1 ) ) = 'XHARBOURFOLDERJ0X'
                 PRI_COMPATIBILITY_LINE := "XHARBOURFOLDER"+var030399_Oohg1+var030399_Borland+" " + US_WordSubStr( PRI_COMPATIBILITY_LINE , 2 )
         EndIf
         PRI_COMPATIBILITY_ENVIRONMENTFILE := PRI_COMPATIBILITY_ENVIRONMENTFILE + PRI_COMPATIBILITY_LINE + HB_OsNewLine()
      next
      PRI_COMPATIBILITY_ENVIRONMENTVERSION = val( "030400" )
      RELEASE var030399_MiniGui1
      RELEASE var030399_MiniGui2
      RELEASE var030399_Extended1
      RELEASE var030399_Oohg1
      RELEASE var030399_Harbour
      RELEASE var030399_XHarbour
      RELEASE var030399_Borland
      RELEASE var030399_MinGW
   endif
   /* FIN - Parche para compatibilidad con version hasta 03.03.99 */
   /* */
   /* INI - Parche para compatibilidad con version hasta 04.11.99 */
   if PRI_COMPATIBILITY_ENVIRONMENTVERSION <= val( "041199" )
      PRIVATE var041199_MiniGui1 := "M1"
      PRIVATE var041199_MiniGui3 := "M3"
      PRIVATE var041199_Extended1:= "E1"
      PRIVATE var041199_Oohg3    := "O3"
      PRIVATE var041199_Harbour  := "H"
      PRIVATE var041199_XHarbour := "X"
      PRIVATE var041199_Borland  := "B"
      PRIVATE var041199_MinGW    := "G"
      PRIVATE var041199_Pelles   := "P"
      PRI_COMPATIBILITY_ENVIRONMENTFILEAUX := PRI_COMPATIBILITY_ENVIRONMENTFILE
      PRI_COMPATIBILITY_ENVIRONMENTFILE := ""
      For PRI_COMPATIBILITY_INX := 1 To MLCount ( PRI_COMPATIBILITY_ENVIRONMENTFILEAUX , 254 )
         DO EVENTS
         PRI_COMPATIBILITY_LINE := AllTrim ( MEMOLINE( PRI_COMPATIBILITY_ENVIRONMENTFILEAUX , 254 , PRI_COMPATIBILITY_INX ) )
         PRI_COMPATIBILITY_LINE := strtran( PRI_COMPATIBILITY_LINE , "=" , " " )
         If      US_Upper( US_Word( PRI_COMPATIBILITY_LINE , 1 ) ) = 'MINIGUIFOLDERM2G'
                 PRI_COMPATIBILITY_LINE := "MINIGUIFOLDER"+var041199_MiniGui3+var041199_MinGW+" " + US_WordSubStr( PRI_COMPATIBILITY_LINE , 2 )
         ElseIf  US_Upper( US_Word( PRI_COMPATIBILITY_LINE , 1 ) ) = 'CCOMPILATORM2G'
                 PRI_COMPATIBILITY_LINE := "CCOMPILATOR"+var041199_MiniGui3+var041199_MinGW+" " + US_WordSubStr( PRI_COMPATIBILITY_LINE , 2 )
         ElseIf  US_Upper( US_Word( PRI_COMPATIBILITY_LINE , 1 ) ) = 'HARBOURFOLDERM2G'
                 PRI_COMPATIBILITY_LINE := "HARBOURFOLDER"+var041199_MiniGui3+var041199_MinGW+" " + US_WordSubStr( PRI_COMPATIBILITY_LINE , 2 )
         ElseIf  US_Upper( US_Word( PRI_COMPATIBILITY_LINE , 1 ) ) = 'XHARBOURFOLDERM2G'
                 PRI_COMPATIBILITY_LINE := "XHARBOURFOLDER"+var041199_MiniGui3+var041199_MinGW+" " + US_WordSubStr( PRI_COMPATIBILITY_LINE , 2 )
         ElseIf  US_Upper( US_Word( PRI_COMPATIBILITY_LINE , 1 ) ) = 'MINIGUIFOLDERO1B'
                 PRI_COMPATIBILITY_LINE := "MINIGUIFOLDER"+var041199_Oohg3+var041199_Borland+" " + US_WordSubStr( PRI_COMPATIBILITY_LINE , 2 )
         ElseIf  US_Upper( US_Word( PRI_COMPATIBILITY_LINE , 1 ) ) = 'CCOMPILATORO1B'
                 PRI_COMPATIBILITY_LINE := "CCOMPILATOR"+var041199_Oohg3+var041199_Borland+" " + US_WordSubStr( PRI_COMPATIBILITY_LINE , 2 )
         ElseIf  US_Upper( US_Word( PRI_COMPATIBILITY_LINE , 1 ) ) = 'HARBOURFOLDERO1B'
                 PRI_COMPATIBILITY_LINE := "HARBOURFOLDER"+var041199_Oohg3+var041199_Borland+" " + US_WordSubStr( PRI_COMPATIBILITY_LINE , 2 )
         ElseIf  US_Upper( US_Word( PRI_COMPATIBILITY_LINE , 1 ) ) = 'XHARBOURFOLDERO1B'
                 PRI_COMPATIBILITY_LINE := "XHARBOURFOLDER"+var041199_Oohg3+var041199_Borland+" " + US_WordSubStr( PRI_COMPATIBILITY_LINE , 2 )
         ElseIf  US_Upper( US_Word( PRI_COMPATIBILITY_LINE , 1 ) ) = 'MINIGUIFOLDERO1G'
                 PRI_COMPATIBILITY_LINE := "MINIGUIFOLDER"+var041199_Oohg3+var041199_MinGW+" " + US_WordSubStr( PRI_COMPATIBILITY_LINE , 2 )
         ElseIf  US_Upper( US_Word( PRI_COMPATIBILITY_LINE , 1 ) ) = 'CCOMPILATORO1G'
                 PRI_COMPATIBILITY_LINE := "CCOMPILATOR"+var041199_Oohg3+var041199_MinGW+" " + US_WordSubStr( PRI_COMPATIBILITY_LINE , 2 )
         ElseIf  US_Upper( US_Word( PRI_COMPATIBILITY_LINE , 1 ) ) = 'HARBOURFOLDERO1G'
                 PRI_COMPATIBILITY_LINE := "HARBOURFOLDER"+var041199_Oohg3+var041199_MinGW+" " + US_WordSubStr( PRI_COMPATIBILITY_LINE , 2 )
         ElseIf  US_Upper( US_Word( PRI_COMPATIBILITY_LINE , 1 ) ) = 'XHARBOURFOLDERO1G'
                 PRI_COMPATIBILITY_LINE := "XHARBOURFOLDER"+var041199_Oohg3+var041199_MinGW+" " + US_WordSubStr( PRI_COMPATIBILITY_LINE , 2 )
         ElseIf  US_Upper( US_Word( PRI_COMPATIBILITY_LINE , 1 ) ) = 'MINIGUIFOLDERO1P'
                 PRI_COMPATIBILITY_LINE := "MINIGUIFOLDER"+var041199_Oohg3+var041199_Pelles+" " + US_WordSubStr( PRI_COMPATIBILITY_LINE , 2 )
         ElseIf  US_Upper( US_Word( PRI_COMPATIBILITY_LINE , 1 ) ) = 'CCOMPILATORO1P'
                 PRI_COMPATIBILITY_LINE := "CCOMPILATOR"+var041199_Oohg3+var041199_Pelles+" " + US_WordSubStr( PRI_COMPATIBILITY_LINE , 2 )
         ElseIf  US_Upper( US_Word( PRI_COMPATIBILITY_LINE , 1 ) ) = 'HARBOURFOLDERO1P'
                 PRI_COMPATIBILITY_LINE := "HARBOURFOLDER"+var041199_Oohg3+var041199_Pelles+" " + US_WordSubStr( PRI_COMPATIBILITY_LINE , 2 )
         ElseIf  US_Upper( US_Word( PRI_COMPATIBILITY_LINE , 1 ) ) = 'XHARBOURFOLDERO1P'
                 PRI_COMPATIBILITY_LINE := "XHARBOURFOLDER"+var041199_Oohg3+var041199_Pelles+" " + US_WordSubStr( PRI_COMPATIBILITY_LINE , 2 )
         EndIf
         PRI_COMPATIBILITY_ENVIRONMENTFILE := PRI_COMPATIBILITY_ENVIRONMENTFILE + PRI_COMPATIBILITY_LINE + HB_OsNewLine()
      next
      PRI_COMPATIBILITY_ENVIRONMENTVERSION = val( "041200" )
      RELEASE var041199_MiniGui1
      RELEASE var041199_MiniGui3
      RELEASE var041199_Extended1
      RELEASE var041199_Oohg3
      RELEASE var041199_Harbour
      RELEASE var041199_XHarbour
      RELEASE var041199_Borland
      RELEASE var041199_MinGW
      RELEASE var041199_Pelles
   endif
   /* FIN - Parche para compatibilidad con version hasta 04.11.99 */
   RELEASE PRI_COMPATIBILITY_INX
   RELEASE PRI_COMPATIBILITY_LINE

/* eof */
