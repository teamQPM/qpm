/*
 *    QPM - QAC based Project Manager
 *
 *    Copyright 2011-2020 Fernando Yurisich <qpm-users@lists.sourceforge.net>
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
      if PRI_COMPATIBILITY_CONFIGVERSION == val( "010001" )
         PRI_COMPATIBILITY_MEMOPROJECTFILEAUX := PRI_COMPATIBILITY_MEMOPROJECTFILE
         PRI_COMPATIBILITY_MEMOPROJECTFILE := ""
         For PRI_COMPATIBILITY_INX := 1 To MLCount ( PRI_COMPATIBILITY_MEMOPROJECTFILEAUX , 254 )
            PRI_COMPATIBILITY_LINE := AllTrim ( MEMOLINE( PRI_COMPATIBILITY_MEMOPROJECTFILEAUX , 254 , PRI_COMPATIBILITY_INX ) )
            PRI_COMPATIBILITY_LINE := strtran( PRI_COMPATIBILITY_LINE , "=" , " " )
            If      US_Upper( US_Word( PRI_COMPATIBILITY_LINE , 1 ) ) == 'LASTLIBFOLDERHB1X'
                    PRI_COMPATIBILITY_LINE := "LASTLIBFOLDERHBO1X " + us_wordSubStr ( PRI_COMPATIBILITY_LINE , 2 )
            ElseIf  US_Upper( US_Word( PRI_COMPATIBILITY_LINE , 1 ) ) == 'LASTLIBFOLDERXHB1X'
                    PRI_COMPATIBILITY_LINE := "LASTLIBFOLDERXHBO1X " + us_wordSubStr ( PRI_COMPATIBILITY_LINE , 2 )
            ElseIf  US_Upper( US_Word( PRI_COMPATIBILITY_LINE , 1 ) ) == 'LASTLIBFOLDERHB2X'
                    PRI_COMPATIBILITY_LINE := "LASTLIBFOLDERHBO2X " + us_wordSubStr ( PRI_COMPATIBILITY_LINE , 2 )
            ElseIf  US_Upper( US_Word( PRI_COMPATIBILITY_LINE , 1 ) ) == 'LASTLIBFOLDERXHB2X'
                    PRI_COMPATIBILITY_LINE := "LASTLIBFOLDERXHBO2X " + us_wordSubStr ( PRI_COMPATIBILITY_LINE , 2 )
            ElseIf  US_Upper( US_Word( PRI_COMPATIBILITY_LINE , 1 ) ) == 'MINGWCOMPILER'
                    If US_Upper( US_Word ( PRI_COMPATIBILITY_LINE , 2 ) ) == 'YES'
                       PRI_COMPATIBILITY_LINE := "CHECKMINIGUI 2"
                    Else
                       PRI_COMPATIBILITY_LINE := "CHECKMINIGUI 1"
                    EndIf
            ElseIf  US_Upper( US_Word( PRI_COMPATIBILITY_LINE , 1 ) ) = 'HB1X'
                    PRI_COMPATIBILITY_LINE := "HBO1X " + US_WordSubStr( PRI_COMPATIBILITY_LINE , 2 )
            ElseIf  US_Upper( US_Word( PRI_COMPATIBILITY_LINE , 1 ) ) = 'HB2X'
                    PRI_COMPATIBILITY_LINE := "HBO2X " + US_WordSubStr( PRI_COMPATIBILITY_LINE , 2 )
            ElseIf  US_Upper( US_Word( PRI_COMPATIBILITY_LINE , 1 ) ) = 'XHB1X'
                    PRI_COMPATIBILITY_LINE := "XHBO1X " + US_WordSubStr( PRI_COMPATIBILITY_LINE , 2 )
            ElseIf  US_Upper( US_Word( PRI_COMPATIBILITY_LINE , 1 ) ) = 'XHB2X'
                    PRI_COMPATIBILITY_LINE := "XHBO2X " + US_WordSubStr( PRI_COMPATIBILITY_LINE , 2 )
            ElseIf  US_Upper( US_Word( PRI_COMPATIBILITY_LINE , 1 ) ) = 'EXCLUDEHB1X'
                    PRI_COMPATIBILITY_LINE := "EXCLUDEHBO1X " + US_WordSubStr( PRI_COMPATIBILITY_LINE , 2 )
            ElseIf  US_Upper( US_Word( PRI_COMPATIBILITY_LINE , 1 ) ) = 'EXCLUDEHB2X'
                    PRI_COMPATIBILITY_LINE := "EXCLUDEHBO2X " + US_WordSubStr( PRI_COMPATIBILITY_LINE , 2 )
            ElseIf  US_Upper( US_Word( PRI_COMPATIBILITY_LINE , 1 ) ) = 'EXCLUDEXHB1X'
                    PRI_COMPATIBILITY_LINE := "EXCLUDEXHBO1X " + US_WordSubStr( PRI_COMPATIBILITY_LINE , 2 )
            ElseIf  US_Upper( US_Word( PRI_COMPATIBILITY_LINE , 1 ) ) = 'EXCLUDEXHB2X'
                    PRI_COMPATIBILITY_LINE := "EXCLUDEXHBO2X " + US_WordSubStr( PRI_COMPATIBILITY_LINE , 2 )
            EndIf
            PRI_COMPATIBILITY_MEMOPROJECTFILE := PRI_COMPATIBILITY_MEMOPROJECTFILE + PRI_COMPATIBILITY_LINE + HB_OsNewLine()
         next
      endif
      /* FIN - Parche para compatibilidad con version 01.00.01 */

      /* INI - Parche para compatibilidad con version hasta 01.02.02 */
      if PRI_COMPATIBILITY_CONFIGVERSION <= val( "010202" )
         PRI_COMPATIBILITY_MEMOPROJECTFILEAUX := PRI_COMPATIBILITY_MEMOPROJECTFILE
         PRI_COMPATIBILITY_MEMOPROJECTFILE := ""
         For PRI_COMPATIBILITY_INX := 1 To MLCount ( PRI_COMPATIBILITY_MEMOPROJECTFILEAUX , 254 )
            PRI_COMPATIBILITY_LINE := AllTrim ( MEMOLINE( PRI_COMPATIBILITY_MEMOPROJECTFILEAUX , 254 , PRI_COMPATIBILITY_INX ) )
            If      US_Upper( US_Word( PRI_COMPATIBILITY_LINE , 1 ) ) = 'CHECKMINIGUI'
                    do case
                       case US_WordSubStr( PRI_COMPATIBILITY_LINE , 2 ) == "1"
                          PRI_COMPATIBILITY_LINE := "CHECKMINIGUI " + "O1X"
                       case US_WordSubStr( PRI_COMPATIBILITY_LINE , 2 ) == "2"
                          PRI_COMPATIBILITY_LINE := "CHECKMINIGUI " + "O2X"
                       case US_WordSubStr( PRI_COMPATIBILITY_LINE , 2 ) == "3"
                          PRI_COMPATIBILITY_LINE := "CHECKMINIGUI " + "E1X"
                       case US_WordSubStr( PRI_COMPATIBILITY_LINE , 2 ) == "4"
                          PRI_COMPATIBILITY_LINE := "CHECKMINIGUI " + "J0X"
                    endcase
            ElseIf  US_Upper( US_Word( PRI_COMPATIBILITY_LINE , 1 ) ) = 'CHECKFORMTOOL'
                    do case
                       case US_WordSubStr( PRI_COMPATIBILITY_LINE , 2 ) == '1'
                          PRI_COMPATIBILITY_LINE := 'CHECKFORMTOOL ' + 'EDITOR'
                       case US_WordSubStr( PRI_COMPATIBILITY_LINE , 2 ) == '2'
                          PRI_COMPATIBILITY_LINE := 'CHECKFORMTOOL ' + 'OOHGIDE'
                       case US_WordSubStr( PRI_COMPATIBILITY_LINE , 2 ) == '3'
                          PRI_COMPATIBILITY_LINE := 'CHECKFORMTOOL ' + 'HMGSIDE'
                    endcase
            ElseIf  US_Upper( US_Word( PRI_COMPATIBILITY_LINE , 1 ) ) = 'XHARBOURSUPPORT'
                    If US_Upper ( US_Word( PRI_COMPATIBILITY_LINE , 2 ) ) = 'YES'
                       PRI_COMPATIBILITY_LINE := "CHECKHARBOUR " + "XHB"
                    else
                       PRI_COMPATIBILITY_LINE := "CHECKHARBOUR " + "HB"
                    EndIf
            EndIf
            PRI_COMPATIBILITY_MEMOPROJECTFILE := PRI_COMPATIBILITY_MEMOPROJECTFILE + PRI_COMPATIBILITY_LINE + HB_OsNewLine()
         next
         PRI_COMPATIBILITY_CONFIGVERSION := val( "010300" )
      endif
      /* FIN - Parche para compatibilidad con version hasta 01.02.02 */

      /* INI - Parche para compatibilidad con version hasta 02.00.00 */
      if PRI_COMPATIBILITY_CONFIGVERSION <= val( "020000" )
         PRI_COMPATIBILITY_MEMOPROJECTFILEAUX := PRI_COMPATIBILITY_MEMOPROJECTFILE
         PRI_COMPATIBILITY_MEMOPROJECTFILE := ""
         For PRI_COMPATIBILITY_INX := 1 To MLCount ( PRI_COMPATIBILITY_MEMOPROJECTFILEAUX , 254 )
            PRI_COMPATIBILITY_LINE := AllTrim ( MEMOLINE( PRI_COMPATIBILITY_MEMOPROJECTFILEAUX , 254 , PRI_COMPATIBILITY_INX ) )
            If     Right( US_Upper ( PRI_COMPATIBILITY_LINE) , 4 ) == '.PRG'
                   PRI_COMPATIBILITY_LINE := "SOURCE "+alltrim(PRI_COMPATIBILITY_LINE)
            ElseIf Right( US_Upper ( PRI_COMPATIBILITY_LINE) , 2 ) == '.C'
                   PRI_COMPATIBILITY_LINE := "SOURCE "+alltrim(PRI_COMPATIBILITY_LINE)
            ElseIf US_Upper( US_Word( PRI_COMPATIBILITY_LINE , 1 ) ) == 'CHECKFORMTOOL'
                   if US_Word ( PRI_COMPATIBILITY_LINE , 2 ) == "AUTO"
                      PRI_COMPATIBILITY_LINE := 'CHECKFORMTOOL EDITOR'
                   endif
            endif
            PRI_COMPATIBILITY_MEMOPROJECTFILE := PRI_COMPATIBILITY_MEMOPROJECTFILE + PRI_COMPATIBILITY_LINE + HB_OsNewLine()
         next
         PRI_COMPATIBILITY_CONFIGVERSION := val( "020001" )
      endif
      /* FIN - Parche para compatibilidad con version hasta 02.00.00 */

      /* INI - Parche para compatibilidad con version hasta 02.00.99 */
      if PRI_COMPATIBILITY_CONFIGVERSION <= val( "020099" )
         PRI_COMPATIBILITY_MEMOPROJECTFILEAUX := PRI_COMPATIBILITY_MEMOPROJECTFILE
         PRI_COMPATIBILITY_MEMOPROJECTFILE := ""
         For PRI_COMPATIBILITY_INX := 1 To MLCount ( PRI_COMPATIBILITY_MEMOPROJECTFILEAUX , 254 )
            PRI_COMPATIBILITY_LINE := AllTrim ( MEMOLINE( PRI_COMPATIBILITY_MEMOPROJECTFILEAUX , 254 , PRI_COMPATIBILITY_INX ) )
            If  US_Upper( US_Word( PRI_COMPATIBILITY_LINE , 1 ) ) == 'OUTPUTTYPE'
                do case
                   case US_Word ( PRI_COMPATIBILITY_LINE , 2 ) == 'EXE'
                      PRI_COMPATIBILITY_LINE := 'OUTPUTTYPE SRCEXE'
                   case US_Word ( PRI_COMPATIBILITY_LINE , 2 ) == 'LIB'
                      PRI_COMPATIBILITY_LINE := 'OUTPUTTYPE SRCLIB'
                   case US_Word ( PRI_COMPATIBILITY_LINE , 2 ) == 'DLL'
                      PRI_COMPATIBILITY_LINE := 'OUTPUTTYPE SRCDLL'
                endcase
            endif
            PRI_COMPATIBILITY_MEMOPROJECTFILE := PRI_COMPATIBILITY_MEMOPROJECTFILE + PRI_COMPATIBILITY_LINE + HB_OsNewLine()
         next
         PRI_COMPATIBILITY_CONFIGVERSION := val( "020100" )
      endif
      /* FIN - Parche para compatibilidad con version hasta 02.00.99 */

      /* INI - Parche para compatibilidad con version hasta 03.00.11 */
      if PRI_COMPATIBILITY_CONFIGVERSION <= val( "030011" )
         PRI_COMPATIBILITY_MEMOPROJECTFILEAUX := PRI_COMPATIBILITY_MEMOPROJECTFILE
         PRI_COMPATIBILITY_MEMOPROJECTFILE := ""
         For PRI_COMPATIBILITY_INX := 1 To MLCount ( PRI_COMPATIBILITY_MEMOPROJECTFILEAUX , 254 )
            PRI_COMPATIBILITY_LINE := AllTrim ( MEMOLINE( PRI_COMPATIBILITY_MEMOPROJECTFILEAUX , 254 , PRI_COMPATIBILITY_INX ) )
            If  US_Upper ( US_Word( PRI_COMPATIBILITY_LINE , 1 ) ) == 'SOURCE'
                if at( "\" , US_WordSubStr( PRI_COMPATIBILITY_LINE , 2 ) ) = 0
                   PRI_COMPATIBILITY_LINE := 'SOURCE ' + PRI_COMPATIBILITY_PROJECTFOLDERIDENT + "\" + US_WordSubStr( PRI_COMPATIBILITY_LINE , 2 )
                endif
            ElseIf  US_Upper ( US_Word( PRI_COMPATIBILITY_LINE , 1 ) ) == 'HEAD'
                if at( "\" , US_WordSubStr( PRI_COMPATIBILITY_LINE , 2 ) ) = 0
                   PRI_COMPATIBILITY_LINE := 'HEAD ' + PRI_COMPATIBILITY_PROJECTFOLDERIDENT + "\" + US_WordSubStr( PRI_COMPATIBILITY_LINE , 2 )
                endif
            ElseIf  US_Upper ( US_Word( PRI_COMPATIBILITY_LINE , 1 ) ) == 'FORM'
                if at( "\" , US_WordSubStr( PRI_COMPATIBILITY_LINE , 2 ) ) = 0
                   PRI_COMPATIBILITY_LINE := 'FORM ' + PRI_COMPATIBILITY_PROJECTFOLDERIDENT + "\" + US_WordSubStr( PRI_COMPATIBILITY_LINE , 2 )
                endif
            ElseIf  US_Upper ( US_Word( PRI_COMPATIBILITY_LINE , 1 ) ) == 'DBF'
                if at( "\" , US_WordSubStr( PRI_COMPATIBILITY_LINE , 2 ) ) = 0
                   PRI_COMPATIBILITY_LINE := 'DBF ' + PRI_COMPATIBILITY_PROJECTFOLDERIDENT + "\" + US_WordSubStr( PRI_COMPATIBILITY_LINE , 2 )
                endif
            endif
            PRI_COMPATIBILITY_MEMOPROJECTFILE := PRI_COMPATIBILITY_MEMOPROJECTFILE + PRI_COMPATIBILITY_LINE + HB_OsNewLine()
         next
         PRI_COMPATIBILITY_CONFIGVERSION := val( "030012" )
      endif
      /* FIN - Parche para compatibilidad con version hasta 03.00.11 */
      /* */
      /* INI - Parche para compatibilidad con version hasta 03.03.99 */
      if PRI_COMPATIBILITY_CONFIGVERSION <= val( "030399" )
         PRIVATE var030399_MiniGui1 := "M1"
         PRIVATE var030399_MiniGui2 := "M2"
         PRIVATE var030399_Extended1:= "E1"
         PRIVATE var030399_Oohg1    := "O1"
         PRIVATE var030399_Harbour  := "H"
         PRIVATE var030399_XHarbour := "X"
         PRIVATE var030399_Borland  := "B"
         PRIVATE var030399_MinGW    := "G"
         PRIVATE var030399_Suffix   := .F.
         PRIVATE var030399_Renamed  := .F.
         PRIVATE var030399_NewName  := ""
         PRIVATE var030399_ModName  := ""
         PRIVATE var030399_Type     := ""
         PRIVATE var030399_Move     := ""
         PRI_COMPATIBILITY_MEMOPROJECTFILEAUX := PRI_COMPATIBILITY_MEMOPROJECTFILE
         PRI_COMPATIBILITY_MEMOPROJECTFILE := ""
         For PRI_COMPATIBILITY_INX := 1 To MLCount ( PRI_COMPATIBILITY_MEMOPROJECTFILEAUX , 254 )
            PRI_COMPATIBILITY_LINE := AllTrim ( MEMOLINE( PRI_COMPATIBILITY_MEMOPROJECTFILEAUX , 254 , PRI_COMPATIBILITY_INX ) )
            If      US_Upper ( US_Word( PRI_COMPATIBILITY_LINE , 1 ) ) == 'PROJECTFOLDER' // Para Rename de OBJ
                PRI_COMPATIBILITY_PROJECTFOLDER := US_StrTran( US_WordSubStr ( PRI_COMPATIBILITY_LINE , 2 ) , "<ThisFolder>" , PRI_COMPATIBILITY_THISFOLDER )
                PRI_COMPATIBILITY_LINE := 'PROJECTFOLDER ' + US_WordSubStr( PRI_COMPATIBILITY_LINE , 2 )
            ElseIf  US_Upper ( US_Word( PRI_COMPATIBILITY_LINE , 1 ) ) == 'LASTLIBFOLDERHBO1X'
                PRI_COMPATIBILITY_LINE := 'LASTLIBFOLDER'+var030399_MiniGui1+var030399_Borland+var030399_Harbour+' ' + US_WordSubStr( PRI_COMPATIBILITY_LINE , 2 )
            ElseIf  US_Upper ( US_Word( PRI_COMPATIBILITY_LINE , 1 ) ) == 'LASTLIBFOLDERXHBO1X'
                PRI_COMPATIBILITY_LINE := 'LASTLIBFOLDER'+var030399_MiniGui1+var030399_Borland+var030399_XHarbour+' ' + US_WordSubStr( PRI_COMPATIBILITY_LINE , 2 )
            ElseIf  US_Upper ( US_Word( PRI_COMPATIBILITY_LINE , 1 ) ) == 'LASTLIBFOLDERHBO2X'
                PRI_COMPATIBILITY_LINE := 'LASTLIBFOLDER'+var030399_MiniGui2+var030399_MinGW+var030399_Harbour+' ' + US_WordSubStr( PRI_COMPATIBILITY_LINE , 2 )
            ElseIf  US_Upper ( US_Word( PRI_COMPATIBILITY_LINE , 1 ) ) == 'LASTLIBFOLDERXHBO2X'
                PRI_COMPATIBILITY_LINE := 'LASTLIBFOLDER'+var030399_MiniGui2+var030399_MinGW+var030399_XHarbour+' ' + US_WordSubStr( PRI_COMPATIBILITY_LINE , 2 )
            ElseIf  US_Upper ( US_Word( PRI_COMPATIBILITY_LINE , 1 ) ) == 'LASTLIBFOLDERHBE1X'
                PRI_COMPATIBILITY_LINE := 'LASTLIBFOLDER'+var030399_Extended1+var030399_Borland+var030399_Harbour+' ' + US_WordSubStr( PRI_COMPATIBILITY_LINE , 2 )
            ElseIf  US_Upper ( US_Word( PRI_COMPATIBILITY_LINE , 1 ) ) == 'LASTLIBFOLDERXHBE1X'
                PRI_COMPATIBILITY_LINE := 'LASTLIBFOLDER'+var030399_Extended1+var030399_Borland+var030399_XHarbour+' ' + US_WordSubStr( PRI_COMPATIBILITY_LINE , 2 )
            ElseIf  US_Upper ( US_Word( PRI_COMPATIBILITY_LINE , 1 ) ) == 'LASTLIBFOLDERHBJ0X'
                PRI_COMPATIBILITY_LINE := 'LASTLIBFOLDER'+var030399_Oohg1+var030399_Borland+var030399_Harbour+' ' + US_WordSubStr( PRI_COMPATIBILITY_LINE , 2 )
            ElseIf  US_Upper ( US_Word( PRI_COMPATIBILITY_LINE , 1 ) ) == 'LASTLIBFOLDERXHBJ0X'
                PRI_COMPATIBILITY_LINE := 'LASTLIBFOLDER'+var030399_Oohg1+var030399_Borland+var030399_XHarbour+' ' + US_WordSubStr( PRI_COMPATIBILITY_LINE , 2 )
            ElseIf  US_Upper ( alltrim( PRI_COMPATIBILITY_LINE ) ) == 'CHECKHARBOUR HB'
                PRI_COMPATIBILITY_LINE := 'CHECKHARBOUR '+var030399_Harbour
            ElseIf  US_Upper ( alltrim( PRI_COMPATIBILITY_LINE ) ) == 'CHECKHARBOUR XHB'
                PRI_COMPATIBILITY_LINE := 'CHECKHARBOUR '+var030399_XHarbour
            ElseIf  US_Upper ( alltrim( PRI_COMPATIBILITY_LINE ) ) == 'CHECKMINIGUI O1X'
                PRI_COMPATIBILITY_LINE := 'CHECKMINIGUI '+var030399_MiniGui1
            ElseIf  US_Upper ( alltrim( PRI_COMPATIBILITY_LINE ) ) == 'CHECKMINIGUI O2X'
                PRI_COMPATIBILITY_LINE := 'CHECKMINIGUI '+var030399_MiniGui2+HB_OsNewLine()+'CHECKCPP G'
            ElseIf  US_Upper ( alltrim( PRI_COMPATIBILITY_LINE ) ) == 'CHECKMINIGUI E1X'
                PRI_COMPATIBILITY_LINE := 'CHECKMINIGUI '+var030399_Extended1
            ElseIf  US_Upper ( alltrim( PRI_COMPATIBILITY_LINE ) ) == 'CHECKMINIGUI J0X'
                PRI_COMPATIBILITY_LINE := 'CHECKMINIGUI '+var030399_Oohg1
            ElseIf  US_Upper ( US_Word( PRI_COMPATIBILITY_LINE , 1 ) ) == 'HBO1X'
                PRI_COMPATIBILITY_LINE := 'INCLUDE'+var030399_MiniGui1+var030399_Borland+var030399_Harbour+' ' + US_WordSubStr( PRI_COMPATIBILITY_LINE , 2 )
            ElseIf  US_Upper ( US_Word( PRI_COMPATIBILITY_LINE , 1 ) ) == 'XHBO1X'
                PRI_COMPATIBILITY_LINE := 'INCLUDE'+var030399_MiniGui1+var030399_Borland+var030399_XHarbour+' ' + US_WordSubStr( PRI_COMPATIBILITY_LINE , 2 )
            ElseIf  US_Upper ( US_Word( PRI_COMPATIBILITY_LINE , 1 ) ) == 'HBO2X'
                PRI_COMPATIBILITY_LINE := 'INCLUDE'+var030399_MiniGui2+var030399_MinGW+var030399_Harbour+' ' + US_WordSubStr( PRI_COMPATIBILITY_LINE , 2 )
            ElseIf  US_Upper ( US_Word( PRI_COMPATIBILITY_LINE , 1 ) ) == 'XHBO2X'
                PRI_COMPATIBILITY_LINE := 'INCLUDE'+var030399_MiniGui2+var030399_MinGW+var030399_XHarbour+' ' + US_WordSubStr( PRI_COMPATIBILITY_LINE , 2 )
            ElseIf  US_Upper ( US_Word( PRI_COMPATIBILITY_LINE , 1 ) ) == 'HBE1X'
                PRI_COMPATIBILITY_LINE := 'INCLUDE'+var030399_Extended1+var030399_Borland+var030399_Harbour+' ' + US_WordSubStr( PRI_COMPATIBILITY_LINE , 2 )
            ElseIf  US_Upper ( US_Word( PRI_COMPATIBILITY_LINE , 1 ) ) == 'XHBE1X'
                PRI_COMPATIBILITY_LINE := 'INCLUDE'+var030399_Extended1+var030399_Borland+var030399_XHarbour+' ' + US_WordSubStr( PRI_COMPATIBILITY_LINE , 2 )
            ElseIf  US_Upper ( US_Word( PRI_COMPATIBILITY_LINE , 1 ) ) == 'HBJ0X'
                PRI_COMPATIBILITY_LINE := 'INCLUDE'+var030399_Oohg1+var030399_Borland+var030399_Harbour+' ' + US_WordSubStr( PRI_COMPATIBILITY_LINE , 2 )
            ElseIf  US_Upper ( US_Word( PRI_COMPATIBILITY_LINE , 1 ) ) == 'XHBJ0X'
                PRI_COMPATIBILITY_LINE := 'INCLUDE'+var030399_Oohg1+var030399_Borland+var030399_XHarbour+' ' + US_WordSubStr( PRI_COMPATIBILITY_LINE , 2 )
            ElseIf  US_Upper ( US_Word( PRI_COMPATIBILITY_LINE , 1 ) ) == 'EXCLUDEHBO1X'
                PRI_COMPATIBILITY_LINE := 'EXCLUDE'+var030399_MiniGui1+var030399_Borland+var030399_Harbour+' ' + US_WordSubStr( PRI_COMPATIBILITY_LINE , 2 )
            ElseIf  US_Upper ( US_Word( PRI_COMPATIBILITY_LINE , 1 ) ) == 'EXCLUDEXHBO1X'
                PRI_COMPATIBILITY_LINE := 'EXCLUDE'+var030399_MiniGui1+var030399_Borland+var030399_XHarbour+' ' + US_WordSubStr( PRI_COMPATIBILITY_LINE , 2 )
            ElseIf  US_Upper ( US_Word( PRI_COMPATIBILITY_LINE , 1 ) ) == 'EXCLUDEHBO2X'
                PRI_COMPATIBILITY_LINE := 'EXCLUDE'+var030399_MiniGui2+var030399_MinGW+var030399_Harbour+' ' + US_WordSubStr( PRI_COMPATIBILITY_LINE , 2 )
            ElseIf  US_Upper ( US_Word( PRI_COMPATIBILITY_LINE , 1 ) ) == 'EXCLUDEXHBO2X'
                PRI_COMPATIBILITY_LINE := 'EXCLUDE'+var030399_MiniGui2+var030399_MinGW+var030399_XHarbour+' ' + US_WordSubStr( PRI_COMPATIBILITY_LINE , 2 )
            ElseIf  US_Upper ( US_Word( PRI_COMPATIBILITY_LINE , 1 ) ) == 'EXCLUDEHBE1X'
                PRI_COMPATIBILITY_LINE := 'EXCLUDE'+var030399_Extended1+var030399_Borland+var030399_Harbour+' ' + US_WordSubStr( PRI_COMPATIBILITY_LINE , 2 )
            ElseIf  US_Upper ( US_Word( PRI_COMPATIBILITY_LINE , 1 ) ) == 'EXCLUDEXHBE1X'
                PRI_COMPATIBILITY_LINE := 'EXCLUDE'+var030399_Extended1+var030399_Borland+var030399_XHarbour+' ' + US_WordSubStr( PRI_COMPATIBILITY_LINE , 2 )
            ElseIf  US_Upper ( US_Word( PRI_COMPATIBILITY_LINE , 1 ) ) == 'EXCLUDEHBJ0X'
                PRI_COMPATIBILITY_LINE := 'EXCLUDE'+var030399_Oohg1+var030399_Borland+var030399_Harbour+' ' + US_WordSubStr( PRI_COMPATIBILITY_LINE , 2 )
            ElseIf  US_Upper ( US_Word( PRI_COMPATIBILITY_LINE , 1 ) ) == 'EXCLUDEXHBJ0X'
                PRI_COMPATIBILITY_LINE := 'EXCLUDE'+var030399_Oohg1+var030399_Borland+var030399_XHarbour+' ' + US_WordSubStr( PRI_COMPATIBILITY_LINE , 2 )
            ElseIf  US_Upper ( alltrim( PRI_COMPATIBILITY_LINE ) ) == 'OUTPUTCOPYMOVE MOVE' // Solo para cambiar el nombre de modulos
                PRI_COMPATIBILITY_LINE := 'OUTPUTCOPYMOVE MOVE'
                var030399_Move := ".MOVED.TXT"
            ElseIf  US_Upper ( alltrim( PRI_COMPATIBILITY_LINE ) ) == 'OUTPUTRENAME NEWNAME' // Solo para cambiar el nombre de modulos
                PRI_COMPATIBILITY_LINE := 'OUTPUTRENAME NEWNAME'
                var030399_Renamed := .T.
            ElseIf  US_Upper ( US_Word( PRI_COMPATIBILITY_LINE , 1 ) ) == 'OUTPUTRENAMENEWNAME' // Solo para cambiar el nombre de modulos
                PRI_COMPATIBILITY_LINE := 'OUTPUTRENAMENEWNAME ' + US_WordSubStr( PRI_COMPATIBILITY_LINE , 2 )
                var030399_NewName := US_WordSubStr( PRI_COMPATIBILITY_LINE , 2 )
            ElseIf  US_Upper ( alltrim( PRI_COMPATIBILITY_LINE ) ) == 'CHECKOUTPUTSUFFIX YES' // Solo para cambiar el nombre de modulos
                PRI_COMPATIBILITY_LINE := 'CHECKOUTPUTSUFFIX YES'
                var030399_Suffix := .T.
            ElseIf  US_Upper ( US_Word( PRI_COMPATIBILITY_LINE , 1 ) ) == 'OUTPUTTYPE' // Solo para cambiar el nombre de modulos
                PRI_COMPATIBILITY_LINE := 'OUTPUTTYPE ' + US_WordSubStr( PRI_COMPATIBILITY_LINE , 2 )
                var030399_Type := substr( US_WordSubStr( PRI_COMPATIBILITY_LINE , 2 ) , 4 )
            ElseIf  US_Upper ( US_Word( PRI_COMPATIBILITY_LINE , 1 ) ) == 'SOURCE' // Solo para cambiar el nombre de modulos
                PRI_COMPATIBILITY_LINE := 'SOURCE ' + US_WordSubStr( PRI_COMPATIBILITY_LINE , 2 )
                var030399_ModName := US_FileNameOnlyName( US_WordSubStr( PRI_COMPATIBILITY_LINE , 2 ) )
            endif
            PRI_COMPATIBILITY_MEMOPROJECTFILE := PRI_COMPATIBILITY_MEMOPROJECTFILE + PRI_COMPATIBILITY_LINE + HB_OsNewLine()
         next
         // ini renombro OBJ
         if !US_IsDirectory( PRI_COMPATIBILITY_PROJECTFOLDER + "\OBJ"+var030399_MiniGui1+var030399_Borland+var030399_Harbour ) .and. ;
            US_IsDirectory( PRI_COMPATIBILITY_PROJECTFOLDER + "\OBJHBO1X" )
            frename( PRI_COMPATIBILITY_PROJECTFOLDER + "\OBJHBO1X" , PRI_COMPATIBILITY_PROJECTFOLDER + "\OBJ"+var030399_MiniGui1+var030399_Borland+var030399_Harbour )
         endif
         if !US_IsDirectory( PRI_COMPATIBILITY_PROJECTFOLDER + "\OBJ"+var030399_MiniGui2+var030399_MinGW+var030399_Harbour ) .and. ;
            US_IsDirectory( PRI_COMPATIBILITY_PROJECTFOLDER + "\OBJHBO2X" )
            frename( PRI_COMPATIBILITY_PROJECTFOLDER + "\OBJHBO2X" , PRI_COMPATIBILITY_PROJECTFOLDER + "\OBJ"+var030399_MiniGui2+var030399_MinGW+var030399_Harbour )
         endif
         if !US_IsDirectory( PRI_COMPATIBILITY_PROJECTFOLDER + "\OBJ"+var030399_Extended1+var030399_Borland+var030399_Harbour ) .and. ;
            US_IsDirectory( PRI_COMPATIBILITY_PROJECTFOLDER + "\OBJHBE1X" )
            frename( PRI_COMPATIBILITY_PROJECTFOLDER + "\OBJHBE1X" , PRI_COMPATIBILITY_PROJECTFOLDER + "\OBJ"+var030399_Extended1+var030399_Borland+var030399_Harbour )
         endif
         if !US_IsDirectory( PRI_COMPATIBILITY_PROJECTFOLDER + "\OBJ"+var030399_Oohg1+var030399_Borland+var030399_Harbour ) .and. ;
            US_IsDirectory( PRI_COMPATIBILITY_PROJECTFOLDER + "\OBJHBJ0X" )
            frename( PRI_COMPATIBILITY_PROJECTFOLDER + "\OBJHBJ0X" , PRI_COMPATIBILITY_PROJECTFOLDER + "\OBJ"+var030399_Oohg1+var030399_Borland+var030399_Harbour )
         endif
         if !US_IsDirectory( PRI_COMPATIBILITY_PROJECTFOLDER + "\OBJ"+var030399_MiniGui1+var030399_Borland+var030399_XHarbour ) .and. ;
            US_IsDirectory( PRI_COMPATIBILITY_PROJECTFOLDER + "\OBJXHBO1X" )
            frename( PRI_COMPATIBILITY_PROJECTFOLDER + "\OBJXHBO1X" , PRI_COMPATIBILITY_PROJECTFOLDER + "\OBJ"+var030399_MiniGui1+var030399_Borland+var030399_XHarbour )
         endif
         if !US_IsDirectory( PRI_COMPATIBILITY_PROJECTFOLDER + "\OBJ"+var030399_MiniGui2+var030399_MinGW+var030399_XHarbour ) .and. ;
            US_IsDirectory( PRI_COMPATIBILITY_PROJECTFOLDER + "\OBJXHBO2X" )
            frename( PRI_COMPATIBILITY_PROJECTFOLDER + "\OBJXHBO2X" , PRI_COMPATIBILITY_PROJECTFOLDER + "\OBJ"+var030399_MiniGui2+var030399_MinGW+var030399_XHarbour )
         endif
         if !US_IsDirectory( PRI_COMPATIBILITY_PROJECTFOLDER + "\OBJ"+var030399_Extended1+var030399_Borland+var030399_XHarbour ) .and. ;
            US_IsDirectory( PRI_COMPATIBILITY_PROJECTFOLDER + "\OBJXHBE1X" )
            frename( PRI_COMPATIBILITY_PROJECTFOLDER + "\OBJXHBE1X" , PRI_COMPATIBILITY_PROJECTFOLDER + "\OBJ"+var030399_Extended1+var030399_Borland+var030399_XHarbour )
         endif
         if !US_IsDirectory( PRI_COMPATIBILITY_PROJECTFOLDER + "\OBJ"+var030399_Oohg1+var030399_Borland+var030399_XHarbour ) .and. ;
            US_IsDirectory( PRI_COMPATIBILITY_PROJECTFOLDER + "\OBJXHBJ0X" )
            frename( PRI_COMPATIBILITY_PROJECTFOLDER + "\OBJXHBJ0X" , PRI_COMPATIBILITY_PROJECTFOLDER + "\OBJ"+var030399_Oohg1+var030399_Borland+var030399_XHarbour )
         endif
         // fin renombro OBJ
         // ini renombro modulos
         if var030399_Suffix
            if var030399_Renamed
               if !empty( var030399_NewName )
               // if !file( PRI_COMPATIBILITY_PROJECTFOLDER + "\"+var030399_NewName + "_"+var030399_Minigui1+var030399_Borland+var030399_Harbour + "."+var030399_Type+var030399_Move ) .and. ;
               //    file( PRI_COMPATIBILITY_PROJECTFOLDER + "\"+var030399_NewName + "_HBO1X."+var030399_Type+var030399_Move )
                     frename( PRI_COMPATIBILITY_PROJECTFOLDER + "\"+var030399_NewName + "_HBO1X."+var030399_Type+var030399_Move , PRI_COMPATIBILITY_PROJECTFOLDER + "\"+var030399_NewName + "_"+var030399_Minigui1+var030399_Borland+var030399_Harbour + "."+var030399_Type+var030399_Move )
                     frename( PRI_COMPATIBILITY_PROJECTFOLDER + "\"+var030399_NewName + "_HBO2X."+var030399_Type+var030399_Move , PRI_COMPATIBILITY_PROJECTFOLDER + "\"+var030399_NewName + "_"+var030399_Minigui2+var030399_MinGW+var030399_Harbour + "."+var030399_Type+var030399_Move )
                     frename( PRI_COMPATIBILITY_PROJECTFOLDER + "\"+var030399_NewName + "_HBE1X."+var030399_Type+var030399_Move , PRI_COMPATIBILITY_PROJECTFOLDER + "\"+var030399_NewName + "_"+var030399_Extended1+var030399_Borland+var030399_Harbour + "."+var030399_Type+var030399_Move )
                     frename( PRI_COMPATIBILITY_PROJECTFOLDER + "\"+var030399_NewName + "_HBJ0X."+var030399_Type+var030399_Move , PRI_COMPATIBILITY_PROJECTFOLDER + "\"+var030399_NewName + "_"+var030399_Oohg1+var030399_Borland+var030399_Harbour + "."+var030399_Type+var030399_Move )
                     frename( PRI_COMPATIBILITY_PROJECTFOLDER + "\"+var030399_NewName + "_XHBO1X."+var030399_Type+var030399_Move , PRI_COMPATIBILITY_PROJECTFOLDER + "\"+var030399_NewName + "_"+var030399_Minigui1+var030399_Borland+var030399_XHarbour + "."+var030399_Type+var030399_Move )
                     frename( PRI_COMPATIBILITY_PROJECTFOLDER + "\"+var030399_NewName + "_XHBO2X."+var030399_Type+var030399_Move , PRI_COMPATIBILITY_PROJECTFOLDER + "\"+var030399_NewName + "_"+var030399_Minigui2+var030399_MinGW+var030399_XHarbour + "."+var030399_Type+var030399_Move )
                     frename( PRI_COMPATIBILITY_PROJECTFOLDER + "\"+var030399_NewName + "_XHBE1X."+var030399_Type+var030399_Move , PRI_COMPATIBILITY_PROJECTFOLDER + "\"+var030399_NewName + "_"+var030399_Extended1+var030399_Borland+var030399_XHarbour + "."+var030399_Type+var030399_Move )
                     frename( PRI_COMPATIBILITY_PROJECTFOLDER + "\"+var030399_NewName + "_XHBJ0X."+var030399_Type+var030399_Move , PRI_COMPATIBILITY_PROJECTFOLDER + "\"+var030399_NewName + "_"+var030399_Oohg1+var030399_Borland+var030399_XHarbour + "."+var030399_Type+var030399_Move )
               // endif
               endif
            else
            // if !file( PRI_COMPATIBILITY_PROJECTFOLDER + "\"+var030399_ModName + "_"+var030399_Minigui1+var030399_Borland+var030399_Harbour + "."+var030399_Type+var030399_Move ) .and. ;
            //    file( PRI_COMPATIBILITY_PROJECTFOLDER + "\"+var030399_ModName + "_HBO1X."+var030399_Type+var030399_Move )
                  frename( PRI_COMPATIBILITY_PROJECTFOLDER + "\"+var030399_ModName + "_HBO1X."+var030399_Type+var030399_Move , PRI_COMPATIBILITY_PROJECTFOLDER + "\"+var030399_ModName + "_"+var030399_Minigui1+var030399_Borland+var030399_Harbour + "."+var030399_Type+var030399_Move )
                  frename( PRI_COMPATIBILITY_PROJECTFOLDER + "\"+var030399_ModName + "_HBO2X."+var030399_Type+var030399_Move , PRI_COMPATIBILITY_PROJECTFOLDER + "\"+var030399_ModName + "_"+var030399_Minigui2+var030399_MinGW+var030399_Harbour + "."+var030399_Type+var030399_Move )
                  frename( PRI_COMPATIBILITY_PROJECTFOLDER + "\"+var030399_ModName + "_HBE1X."+var030399_Type+var030399_Move , PRI_COMPATIBILITY_PROJECTFOLDER + "\"+var030399_ModName + "_"+var030399_Extended1+var030399_Borland+var030399_Harbour + "."+var030399_Type+var030399_Move )
                  frename( PRI_COMPATIBILITY_PROJECTFOLDER + "\"+var030399_ModName + "_HBJ0X."+var030399_Type+var030399_Move , PRI_COMPATIBILITY_PROJECTFOLDER + "\"+var030399_ModName + "_"+var030399_Oohg1+var030399_Borland+var030399_Harbour + "."+var030399_Type+var030399_Move )
                  frename( PRI_COMPATIBILITY_PROJECTFOLDER + "\"+var030399_ModName + "_XHBO1X."+var030399_Type+var030399_Move , PRI_COMPATIBILITY_PROJECTFOLDER + "\"+var030399_ModName + "_"+var030399_Minigui1+var030399_Borland+var030399_XHarbour + "."+var030399_Type+var030399_Move )
                  frename( PRI_COMPATIBILITY_PROJECTFOLDER + "\"+var030399_ModName + "_XHBO2X."+var030399_Type+var030399_Move , PRI_COMPATIBILITY_PROJECTFOLDER + "\"+var030399_ModName + "_"+var030399_Minigui2+var030399_MinGW+var030399_XHarbour + "."+var030399_Type+var030399_Move )
                  frename( PRI_COMPATIBILITY_PROJECTFOLDER + "\"+var030399_ModName + "_XHBE1X."+var030399_Type+var030399_Move , PRI_COMPATIBILITY_PROJECTFOLDER + "\"+var030399_ModName + "_"+var030399_Extended1+var030399_Borland+var030399_XHarbour + "."+var030399_Type+var030399_Move )
                  frename( PRI_COMPATIBILITY_PROJECTFOLDER + "\"+var030399_ModName + "_XHBJ0X."+var030399_Type+var030399_Move , PRI_COMPATIBILITY_PROJECTFOLDER + "\"+var030399_ModName + "_"+var030399_Oohg1+var030399_Borland+var030399_XHarbour + "."+var030399_Type+var030399_Move )
            // endif
            endif
         endif
         // fin renombro modulos
         PRI_COMPATIBILITY_CONFIGVERSION := val( "030400" )
         RELEASE var030399_MiniGui1
         RELEASE var030399_MiniGui2
         RELEASE var030399_Extended1
         RELEASE var030399_Oohg1
         RELEASE var030399_Harbour
         RELEASE var030399_XHarbour
         RELEASE var030399_Borland
         RELEASE var030399_MinGW
         RELEASE var030399_Suffix
         RELEASE var030399_Renamed
         RELEASE var030399_NewName
         RELEASE var030399_ModName
         RELEASE var030399_Type
         RELEASE var030399_Move
      endif
      /* FIN - Parche para compatibilidad con version hasta 03.03.99 */
      /* */
      /* INI - Parche para compatibilidad con version hasta 04.11.99 */
      if PRI_COMPATIBILITY_CONFIGVERSION <= val( "041199" )
         PRIVATE var041199_MiniGui1 := "M1"
         PRIVATE var041199_MiniGui3 := "M3"
         PRIVATE var041199_Extended1:= "E1"
         PRIVATE var041199_Oohg3    := "O3"
         PRIVATE var041199_Harbour  := "H"
         PRIVATE var041199_XHarbour := "X"
         PRIVATE var041199_Borland  := "B"
         PRIVATE var041199_MinGW    := "G"
         PRIVATE var041199_Pelles   := "P"
         PRIVATE var041199_Suffix   := .F.
         PRIVATE var041199_Renamed  := .F.
         PRIVATE var041199_NewName  := ""
         PRIVATE var041199_ModName  := ""
         PRIVATE var041199_Type     := ""
         PRIVATE var041199_Move     := ""
         PRI_COMPATIBILITY_MEMOPROJECTFILEAUX := PRI_COMPATIBILITY_MEMOPROJECTFILE
         PRI_COMPATIBILITY_MEMOPROJECTFILE := ""
         For PRI_COMPATIBILITY_INX := 1 To MLCount ( PRI_COMPATIBILITY_MEMOPROJECTFILEAUX , 254 )
            PRI_COMPATIBILITY_LINE := AllTrim ( MEMOLINE( PRI_COMPATIBILITY_MEMOPROJECTFILEAUX , 254 , PRI_COMPATIBILITY_INX ) )
            If      US_Upper ( US_Word( PRI_COMPATIBILITY_LINE , 1 ) ) == 'LASTLIBFOLDERHBM2G'
                PRI_COMPATIBILITY_LINE := 'LASTLIBFOLDER'+var041199_MiniGui3+var041199_MinGW+var041199_Harbour+' ' + US_WordSubStr( PRI_COMPATIBILITY_LINE , 2 )
            ElseIf  US_Upper ( US_Word( PRI_COMPATIBILITY_LINE , 1 ) ) == 'LASTLIBFOLDERXHBM2G'
                PRI_COMPATIBILITY_LINE := 'LASTLIBFOLDER'+var041199_MiniGui3+var041199_MinGW+var041199_XHarbour+' ' + US_WordSubStr( PRI_COMPATIBILITY_LINE , 2 )
            ElseIf  US_Upper ( US_Word( PRI_COMPATIBILITY_LINE , 1 ) ) == 'LASTLIBFOLDERHBO1B'
                PRI_COMPATIBILITY_LINE := 'LASTLIBFOLDER'+var041199_Oohg3+var041199_Borland+var041199_Harbour+' ' + US_WordSubStr( PRI_COMPATIBILITY_LINE , 2 )
            ElseIf  US_Upper ( US_Word( PRI_COMPATIBILITY_LINE , 1 ) ) == 'LASTLIBFOLDERXHBO1B'
                PRI_COMPATIBILITY_LINE := 'LASTLIBFOLDER'+var041199_Oohg3+var041199_Borland+var041199_XHarbour+' ' + US_WordSubStr( PRI_COMPATIBILITY_LINE , 2 )
            ElseIf  US_Upper ( US_Word( PRI_COMPATIBILITY_LINE , 1 ) ) == 'LASTLIBFOLDERHBO1G'
                PRI_COMPATIBILITY_LINE := 'LASTLIBFOLDER'+var041199_Oohg3+var041199_MinGW+var041199_Harbour+' ' + US_WordSubStr( PRI_COMPATIBILITY_LINE , 2 )
            ElseIf  US_Upper ( US_Word( PRI_COMPATIBILITY_LINE , 1 ) ) == 'LASTLIBFOLDERXHBO1G'
                PRI_COMPATIBILITY_LINE := 'LASTLIBFOLDER'+var041199_Oohg3+var041199_MinGW+var041199_XHarbour+' ' + US_WordSubStr( PRI_COMPATIBILITY_LINE , 2 )
            ElseIf  US_Upper ( US_Word( PRI_COMPATIBILITY_LINE , 1 ) ) == 'LASTLIBFOLDERHBO1P'
                PRI_COMPATIBILITY_LINE := 'LASTLIBFOLDER'+var041199_Oohg3+var041199_Pelles+var041199_Harbour+' ' + US_WordSubStr( PRI_COMPATIBILITY_LINE , 2 )
            ElseIf  US_Upper ( US_Word( PRI_COMPATIBILITY_LINE , 1 ) ) == 'LASTLIBFOLDERXHBO1P'
                PRI_COMPATIBILITY_LINE := 'LASTLIBFOLDER'+var041199_Oohg3+var041199_Pelles+var041199_XHarbour+' ' + US_WordSubStr( PRI_COMPATIBILITY_LINE , 2 )
            ElseIf  US_Upper ( alltrim( PRI_COMPATIBILITY_LINE ) ) == 'CHECKMINIGUI M2'
                PRI_COMPATIBILITY_LINE := 'CHECKMINIGUI '+var041199_MiniGui3
            ElseIf  US_Upper ( alltrim( PRI_COMPATIBILITY_LINE ) ) == 'CHECKMINIGUI O1'
                PRI_COMPATIBILITY_LINE := 'CHECKMINIGUI '+var041199_Oohg3
            ElseIf  US_Upper ( US_Word( PRI_COMPATIBILITY_LINE , 1 ) ) == 'HBM2G'
                PRI_COMPATIBILITY_LINE := 'INCLUDE'+var041199_MiniGui3+var041199_MinGW+var041199_Harbour+' ' + US_WordSubStr( PRI_COMPATIBILITY_LINE , 2 )
            ElseIf  US_Upper ( US_Word( PRI_COMPATIBILITY_LINE , 1 ) ) == 'XHBM2G'
                PRI_COMPATIBILITY_LINE := 'INCLUDE'+var041199_MiniGui3+var041199_MinGW+var041199_XHarbour+' ' + US_WordSubStr( PRI_COMPATIBILITY_LINE , 2 )
            ElseIf  US_Upper ( US_Word( PRI_COMPATIBILITY_LINE , 1 ) ) == 'HBO1B'
                PRI_COMPATIBILITY_LINE := 'INCLUDE'+var041199_Oohg3+var041199_Borland+var041199_Harbour+' ' + US_WordSubStr( PRI_COMPATIBILITY_LINE , 2 )
            ElseIf  US_Upper ( US_Word( PRI_COMPATIBILITY_LINE , 1 ) ) == 'XHBO1B'
                PRI_COMPATIBILITY_LINE := 'INCLUDE'+var041199_Oohg3+var041199_Borland+var041199_XHarbour+' ' + US_WordSubStr( PRI_COMPATIBILITY_LINE , 2 )
            ElseIf  US_Upper ( US_Word( PRI_COMPATIBILITY_LINE , 1 ) ) == 'HBO1G'
                PRI_COMPATIBILITY_LINE := 'INCLUDE'+var041199_Oohg3+var041199_MinGW+var041199_Harbour+' ' + US_WordSubStr( PRI_COMPATIBILITY_LINE , 2 )
            ElseIf  US_Upper ( US_Word( PRI_COMPATIBILITY_LINE , 1 ) ) == 'XHBO1G'
                PRI_COMPATIBILITY_LINE := 'INCLUDE'+var041199_Oohg3+var041199_MinGW+var041199_XHarbour+' ' + US_WordSubStr( PRI_COMPATIBILITY_LINE , 2 )
            ElseIf  US_Upper ( US_Word( PRI_COMPATIBILITY_LINE , 1 ) ) == 'HBO1P'
                PRI_COMPATIBILITY_LINE := 'INCLUDE'+var041199_Oohg3+var041199_Pelles+var041199_Harbour+' ' + US_WordSubStr( PRI_COMPATIBILITY_LINE , 2 )
            ElseIf  US_Upper ( US_Word( PRI_COMPATIBILITY_LINE , 1 ) ) == 'XHBO1P'
                PRI_COMPATIBILITY_LINE := 'INCLUDE'+var041199_Oohg3+var041199_Pelles+var041199_XHarbour+' ' + US_WordSubStr( PRI_COMPATIBILITY_LINE , 2 )
            ElseIf  US_Upper ( US_Word( PRI_COMPATIBILITY_LINE , 1 ) ) == 'EXCLUDEHBM2G'
                PRI_COMPATIBILITY_LINE := 'EXCLUDE'+var041199_MiniGui3+var041199_MinGW+var041199_Harbour+' ' + US_WordSubStr( PRI_COMPATIBILITY_LINE , 2 )
            ElseIf  US_Upper ( US_Word( PRI_COMPATIBILITY_LINE , 1 ) ) == 'EXCLUDEXHBM2G'
                PRI_COMPATIBILITY_LINE := 'EXCLUDE'+var041199_MiniGui3+var041199_MinGW+var041199_XHarbour+' ' + US_WordSubStr( PRI_COMPATIBILITY_LINE , 2 )
            ElseIf  US_Upper ( US_Word( PRI_COMPATIBILITY_LINE , 1 ) ) == 'EXCLUDEHBO1B'
                PRI_COMPATIBILITY_LINE := 'EXCLUDE'+var041199_Oohg3+var041199_Borland+var041199_Harbour+' ' + US_WordSubStr( PRI_COMPATIBILITY_LINE , 2 )
            ElseIf  US_Upper ( US_Word( PRI_COMPATIBILITY_LINE , 1 ) ) == 'EXCLUDEXHBO1B'
                PRI_COMPATIBILITY_LINE := 'EXCLUDE'+var041199_Oohg3+var041199_Borland+var041199_XHarbour+' ' + US_WordSubStr( PRI_COMPATIBILITY_LINE , 2 )
            ElseIf  US_Upper ( US_Word( PRI_COMPATIBILITY_LINE , 1 ) ) == 'EXCLUDEHBO1G'
                PRI_COMPATIBILITY_LINE := 'EXCLUDE'+var041199_Oohg3+var041199_MinGW+var041199_Harbour+' ' + US_WordSubStr( PRI_COMPATIBILITY_LINE , 2 )
            ElseIf  US_Upper ( US_Word( PRI_COMPATIBILITY_LINE , 1 ) ) == 'EXCLUDEXHBO1G'
                PRI_COMPATIBILITY_LINE := 'EXCLUDE'+var041199_Oohg3+var041199_MinGW+var041199_XHarbour+' ' + US_WordSubStr( PRI_COMPATIBILITY_LINE , 2 )
            ElseIf  US_Upper ( US_Word( PRI_COMPATIBILITY_LINE , 1 ) ) == 'EXCLUDEHBO1P'
                PRI_COMPATIBILITY_LINE := 'EXCLUDE'+var041199_Oohg3+var041199_Pelles+var041199_Harbour+' ' + US_WordSubStr( PRI_COMPATIBILITY_LINE , 2 )
            ElseIf  US_Upper ( US_Word( PRI_COMPATIBILITY_LINE , 1 ) ) == 'EXCLUDEXHBO1P'
                PRI_COMPATIBILITY_LINE := 'EXCLUDE'+var041199_Oohg3+var041199_Pelles+var041199_XHarbour+' ' + US_WordSubStr( PRI_COMPATIBILITY_LINE , 2 )
            ElseIf  US_Upper ( alltrim( PRI_COMPATIBILITY_LINE ) ) == 'OUTPUTRENAME NEWNAME' // Solo para cambiar el nombre de modulos
                PRI_COMPATIBILITY_LINE := 'OUTPUTRENAME NEWNAME'
                var041199_Renamed := .T.
            ElseIf  US_Upper ( US_Word( PRI_COMPATIBILITY_LINE , 1 ) ) == 'OUTPUTRENAMENEWNAME' // Solo para cambiar el nombre de modulos
                PRI_COMPATIBILITY_LINE := 'OUTPUTRENAMENEWNAME ' + US_WordSubStr( PRI_COMPATIBILITY_LINE , 2 )
                var041199_NewName := US_WordSubStr( PRI_COMPATIBILITY_LINE , 2 )
            ElseIf  US_Upper ( alltrim( PRI_COMPATIBILITY_LINE ) ) == 'CHECKOUTPUTSUFFIX YES' // Solo para cambiar el nombre de modulos
                PRI_COMPATIBILITY_LINE := 'CHECKOUTPUTSUFFIX YES'
                var041199_Suffix := .T.
            endif
            PRI_COMPATIBILITY_MEMOPROJECTFILE := PRI_COMPATIBILITY_MEMOPROJECTFILE + PRI_COMPATIBILITY_LINE + HB_OsNewLine()
         next
         // ini renombro OBJ
         if !US_IsDirectory( PRI_COMPATIBILITY_PROJECTFOLDER + "\OBJ"+var041199_MiniGui3+var041199_MinGW+var041199_Harbour ) .and. ;
            US_IsDirectory( PRI_COMPATIBILITY_PROJECTFOLDER + "\OBJHBM2G" )
            frename( PRI_COMPATIBILITY_PROJECTFOLDER + "\OBJHBM2G" , PRI_COMPATIBILITY_PROJECTFOLDER + "\OBJ"+var041199_MiniGui3+var041199_MinGW+var041199_Harbour )
         endif
         if !US_IsDirectory( PRI_COMPATIBILITY_PROJECTFOLDER + "\OBJ"+var041199_Oohg3+var041199_Borland+var041199_Harbour ) .and. ;
            US_IsDirectory( PRI_COMPATIBILITY_PROJECTFOLDER + "\OBJHBO1B" )
            frename( PRI_COMPATIBILITY_PROJECTFOLDER + "\OBJHBO1B" , PRI_COMPATIBILITY_PROJECTFOLDER + "\OBJ"+var041199_Oohg3+var041199_Borland+var041199_Harbour )
         endif
         if !US_IsDirectory( PRI_COMPATIBILITY_PROJECTFOLDER + "\OBJ"+var041199_Oohg3+var041199_MinGW+var041199_Harbour ) .and. ;
            US_IsDirectory( PRI_COMPATIBILITY_PROJECTFOLDER + "\OBJHBO3G" )
            frename( PRI_COMPATIBILITY_PROJECTFOLDER + "\OBJHBO3G" , PRI_COMPATIBILITY_PROJECTFOLDER + "\OBJ"+var041199_Oohg3+var041199_MinGW+var041199_Harbour )
         endif
         if !US_IsDirectory( PRI_COMPATIBILITY_PROJECTFOLDER + "\OBJ"+var041199_Oohg3+var041199_Pelles+var041199_Harbour ) .and. ;
            US_IsDirectory( PRI_COMPATIBILITY_PROJECTFOLDER + "\OBJHBO3P" )
            frename( PRI_COMPATIBILITY_PROJECTFOLDER + "\OBJHBO3P" , PRI_COMPATIBILITY_PROJECTFOLDER + "\OBJ"+var041199_Oohg3+var041199_Pelles+var041199_Harbour )
         endif
         if !US_IsDirectory( PRI_COMPATIBILITY_PROJECTFOLDER + "\OBJ"+var041199_MiniGui3+var041199_MinGW+var041199_XHarbour ) .and. ;
            US_IsDirectory( PRI_COMPATIBILITY_PROJECTFOLDER + "\OBJXHBM2G" )
            frename( PRI_COMPATIBILITY_PROJECTFOLDER + "\OBJXHBM2G" , PRI_COMPATIBILITY_PROJECTFOLDER + "\OBJ"+var041199_MiniGui3+var041199_MinGW+var041199_XHarbour )
         endif
         if !US_IsDirectory( PRI_COMPATIBILITY_PROJECTFOLDER + "\OBJ"+var041199_Oohg3+var041199_Borland+var041199_XHarbour ) .and. ;
            US_IsDirectory( PRI_COMPATIBILITY_PROJECTFOLDER + "\OBJXHBO1B" )
            frename( PRI_COMPATIBILITY_PROJECTFOLDER + "\OBJXHBO1B" , PRI_COMPATIBILITY_PROJECTFOLDER + "\OBJ"+var041199_Oohg3+var041199_Borland+var041199_XHarbour )
         endif
         if !US_IsDirectory( PRI_COMPATIBILITY_PROJECTFOLDER + "\OBJ"+var041199_Oohg3+var041199_MinGW+var041199_XHarbour ) .and. ;
            US_IsDirectory( PRI_COMPATIBILITY_PROJECTFOLDER + "\OBJXHBO1G" )
            frename( PRI_COMPATIBILITY_PROJECTFOLDER + "\OBJXHBO1G" , PRI_COMPATIBILITY_PROJECTFOLDER + "\OBJ"+var041199_Oohg3+var041199_MinGW+var041199_XHarbour )
         endif
         if !US_IsDirectory( PRI_COMPATIBILITY_PROJECTFOLDER + "\OBJ"+var041199_Oohg3+var041199_Pelles+var041199_XHarbour ) .and. ;
            US_IsDirectory( PRI_COMPATIBILITY_PROJECTFOLDER + "\OBJXHBO1P" )
            frename( PRI_COMPATIBILITY_PROJECTFOLDER + "\OBJXHBO1P" , PRI_COMPATIBILITY_PROJECTFOLDER + "\OBJ"+var041199_Oohg3+var041199_Pelles+var041199_XHarbour )
         endif
         // fin renombro OBJ
         // ini renombro modulos
         if var041199_Suffix
            if var041199_Renamed
               if !empty( var041199_NewName )
                  frename( PRI_COMPATIBILITY_PROJECTFOLDER + "\"+var041199_NewName + "_HBM2G."+var041199_Type+var041199_Move , PRI_COMPATIBILITY_PROJECTFOLDER + "\"+var041199_NewName + "_"+var041199_MiniGui3+var041199_MinGW+var041199_Harbour + "."+var041199_Type+var041199_Move )
                  frename( PRI_COMPATIBILITY_PROJECTFOLDER + "\"+var041199_NewName + "_HBO1B."+var041199_Type+var041199_Move , PRI_COMPATIBILITY_PROJECTFOLDER + "\"+var041199_NewName + "_"+var041199_Oohg3+var041199_Borland+var041199_Harbour + "."+var041199_Type+var041199_Move )
                  frename( PRI_COMPATIBILITY_PROJECTFOLDER + "\"+var041199_NewName + "_HBO1G."+var041199_Type+var041199_Move , PRI_COMPATIBILITY_PROJECTFOLDER + "\"+var041199_NewName + "_"+var041199_Oohg3+var041199_MinGW+var041199_Harbour + "."+var041199_Type+var041199_Move )
                  frename( PRI_COMPATIBILITY_PROJECTFOLDER + "\"+var041199_NewName + "_HBO1P."+var041199_Type+var041199_Move , PRI_COMPATIBILITY_PROJECTFOLDER + "\"+var041199_NewName + "_"+var041199_Oohg3+var041199_Pelles+var041199_Harbour + "."+var041199_Type+var041199_Move )
                  frename( PRI_COMPATIBILITY_PROJECTFOLDER + "\"+var041199_NewName + "_XHBM2G."+var041199_Type+var041199_Move , PRI_COMPATIBILITY_PROJECTFOLDER + "\"+var041199_NewName + "_"+var041199_MiniGui3+var041199_MinGW+var041199_XHarbour + "."+var041199_Type+var041199_Move )
                  frename( PRI_COMPATIBILITY_PROJECTFOLDER + "\"+var041199_NewName + "_XHBO1B."+var041199_Type+var041199_Move , PRI_COMPATIBILITY_PROJECTFOLDER + "\"+var041199_NewName + "_"+var041199_Oohg3+var041199_Borland+var041199_XHarbour + "."+var041199_Type+var041199_Move )
                  frename( PRI_COMPATIBILITY_PROJECTFOLDER + "\"+var041199_NewName + "_XHBO1G."+var041199_Type+var041199_Move , PRI_COMPATIBILITY_PROJECTFOLDER + "\"+var041199_NewName + "_"+var041199_Oohg3+var041199_MinGW+var041199_XHarbour + "."+var041199_Type+var041199_Move )
                  frename( PRI_COMPATIBILITY_PROJECTFOLDER + "\"+var041199_NewName + "_XHBO1P."+var041199_Type+var041199_Move , PRI_COMPATIBILITY_PROJECTFOLDER + "\"+var041199_NewName + "_"+var041199_Oohg3+var041199_Pelles+var041199_XHarbour + "."+var041199_Type+var041199_Move )
               endif
            else
               frename( PRI_COMPATIBILITY_PROJECTFOLDER + "\"+var041199_ModName + "_HBM2G."+var041199_Type+var041199_Move , PRI_COMPATIBILITY_PROJECTFOLDER + "\"+var041199_ModName + "_"+var041199_MiniGui3+var041199_MinGW+var041199_Harbour + "."+var041199_Type+var041199_Move )
               frename( PRI_COMPATIBILITY_PROJECTFOLDER + "\"+var041199_ModName + "_HBO1B."+var041199_Type+var041199_Move , PRI_COMPATIBILITY_PROJECTFOLDER + "\"+var041199_ModName + "_"+var041199_Oohg3+var041199_Borland+var041199_Harbour + "."+var041199_Type+var041199_Move )
               frename( PRI_COMPATIBILITY_PROJECTFOLDER + "\"+var041199_ModName + "_HBO1G."+var041199_Type+var041199_Move , PRI_COMPATIBILITY_PROJECTFOLDER + "\"+var041199_ModName + "_"+var041199_Oohg3+var041199_MinGW+var041199_Harbour + "."+var041199_Type+var041199_Move )
               frename( PRI_COMPATIBILITY_PROJECTFOLDER + "\"+var041199_ModName + "_HBO1P."+var041199_Type+var041199_Move , PRI_COMPATIBILITY_PROJECTFOLDER + "\"+var041199_ModName + "_"+var041199_Oohg3+var041199_Pelles+var041199_Harbour + "."+var041199_Type+var041199_Move )
               frename( PRI_COMPATIBILITY_PROJECTFOLDER + "\"+var041199_ModName + "_XHBM2G."+var041199_Type+var041199_Move , PRI_COMPATIBILITY_PROJECTFOLDER + "\"+var041199_ModName + "_"+var041199_MiniGui3+var041199_MinGW+var041199_XHarbour + "."+var041199_Type+var041199_Move )
               frename( PRI_COMPATIBILITY_PROJECTFOLDER + "\"+var041199_ModName + "_XHBO1B."+var041199_Type+var041199_Move , PRI_COMPATIBILITY_PROJECTFOLDER + "\"+var041199_ModName + "_"+var041199_Oohg3+var041199_Borland+var041199_XHarbour + "."+var041199_Type+var041199_Move )
               frename( PRI_COMPATIBILITY_PROJECTFOLDER + "\"+var041199_ModName + "_XHBO1G."+var041199_Type+var041199_Move , PRI_COMPATIBILITY_PROJECTFOLDER + "\"+var041199_ModName + "_"+var041199_Oohg3+var041199_MinGW+var041199_XHarbour + "."+var041199_Type+var041199_Move )
               frename( PRI_COMPATIBILITY_PROJECTFOLDER + "\"+var041199_ModName + "_XHBO1P."+var041199_Type+var041199_Move , PRI_COMPATIBILITY_PROJECTFOLDER + "\"+var041199_ModName + "_"+var041199_Oohg3+var041199_Pelles+var041199_XHarbour + "."+var041199_Type+var041199_Move )
            endif
         endif
         // fin renombro modulos
         PRI_COMPATIBILITY_CONFIGVERSION := val( "041200" )
         RELEASE var041199_MiniGui1
         RELEASE var041199_MiniGui3
         RELEASE var041199_Extended1
         RELEASE var041199_Oohg3
         RELEASE var041199_Harbour
         RELEASE var041199_XHarbour
         RELEASE var041199_Borland
         RELEASE var041199_MinGW
         RELEASE var041199_Pelles
         RELEASE var041199_Suffix
         RELEASE var041199_Renamed
         RELEASE var041199_NewName
         RELEASE var041199_ModName
         RELEASE var041199_Type
         RELEASE var041199_Move
      endif
      /* FIN - Parche para compatibilidad con version hasta 03.03.99 */
      RELEASE PRI_COMPATIBILITY_INX
      RELEASE PRI_COMPATIBILITY_LINE

/* eof */
