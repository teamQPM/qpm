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

FUNCTION MAIN(cP1,cP2,cP3,cP4,cP5,cP6,cP7,cP8,cP9,cP10,cP11,cP12,cP13,cP14,cP15,cP16,cP17,cP18,cP19,cP20)
   Local Version:="01.05" , bLoop:=.T. , cLinea:="" , cFines := { Chr(13) + Chr(10) , Chr(10) } , hFiIn , cont:=0 , hFiOut
   Local cFileOut:="" , nBytesSalida:=0 , cFileIn:="" , cParam:="" , cPathTMP:="" , cLineaAux:="" , bList:=.F. , cWord3:=""
   Local cApost:='' , cRule:="" , bForceChg:=.F. , i:=0 , cChar:="" , cSlash:="" , bChg := .f.
   Local bInclude := .F. , cMemoAux , nCantLines , nInx , cAuxLine , cFileInclude , cMemoSal := "" , bIncError := .F.
   Local cMemoError := "" , nSize := 256
   Private cQPMDir:=""

   cP1 =IIF(cP1 =NIL,"",cP1 )
   cP2 =IIF(cP2 =NIL,"",cP2 )
   cP3 =IIF(cP3 =NIL,"",cP3 )
   cP4 =IIF(cP4 =NIL,"",cP4 )
   cP5 =IIF(cP5 =NIL,"",cP5 )
   cP6 =IIF(cP6 =NIL,"",cP6 )
   cP7 =IIF(cP7 =NIL,"",cP7 )
   cP8 =IIF(cP8 =NIL,"",cP8 )
   cP9 =IIF(cP9 =NIL,"",cP9 )
   cP10=IIF(cP10=NIL,"",cP10)
   cP11=IIF(cP11=NIL,"",cP11)
   cP12=IIF(cP12=NIL,"",cP12)
   cP13=IIF(cP13=NIL,"",cP13)
   cP14=IIF(cP14=NIL,"",cP14)
   cP15=IIF(cP15=NIL,"",cP15)
   cP16=IIF(cP16=NIL,"",cP16)
   cP17=IIF(cP17=NIL,"",cP17)
   cP18=IIF(cP18=NIL,"",cP18)
   cP19=IIF(cP19=NIL,"",cP19)
   cP20=IIF(cP20=NIL,"",cP20)
   cParam:=ALLTRIM(cP1+" "+cP2+" "+cP3+" "+cP4+" "+cP5+" "+cP6+" "+cP7+" "+cP8+" "+cP9+" "+cP10+" "+cP11+" "+cP12+" "+cP13+" "+cP14+" "+cP15+" "+cP16+" "+cP17+" "+cP18+" "+cP19+" "+cP20)

   if Upper( US_Word( cParam , 1 ) ) == "-VER" .or. Upper( US_Word( cParam , 1 ) ) == "-VERSION"
      MemoWrit( "US_Res.version" , Version )
      Return .T.
   endif

   if Upper( US_Word( cParam , 1 ) ) != "QPM"
      __Run( "ECHO " + "US_Res 999E: Running out System" )
      ERRORLEVEL(1)
      return -1
   else
      cParam := US_WordDel( cParam , 1 )
   endif

   if upper(substr(cParam , 1 , 5)) == "-LIST"
      bList := .T.
      cQPMDir:=substr(us_word(cParam,1),6)+"\"
      cParam := alltrim( Substr( cParam , US_WordInd( cParam , 2 ) ) )
   endif
   cFileIn :=us_word( cParam , US_Words( cParam ) - 1 )
   cPathTMP:=substr( cFileIn , 1 , rat( "\" , cFileIn ) )
   cFileOut:=us_word( cParam , US_Words( cParam ) )
   cParam:=alltrim(substr(cParam , 1 , US_WordInd( cParam, US_Words( cParam ) - 1 ) - 1 ))
   if bList
      QPM_Log( "US_Res "+Version )
      QPM_Log( "US_Res 000I: by QPM_Support ( http://qpm.sourceforge.net )" )
      QPM_Log( "US_Res 999I: Log into: "+cQPMDir+"QPM.log" )
      QPM_Log( "US_Res 003I: FileIn : "+cFileIn )
      QPM_Log( "US_Res 013I: FileOut : "+cFileOut )
      QPM_Log( "US_Res 043I: Path   : "+cPathTMP )
      QPM_Log( "US_Res 033I: Param  : "+cParam )
   endif
   for i=1 to us_words(cParam)
      do case
         case upper(us_word(cParam,i)) = "-FORCE"
            bForceChg := .t.
         case upper(us_word(cParam,i)) = "-ONLYINCLUDE"
            bInclude := .t.
         otherwise
            QPM_Log( "US_Res 201E: Parameter error: "+us_word(cParam,i) )
            QPM_Log( ""+HB_OsNewLine() )
            ERRORLEVEL(1)
            return 8
      endcase
   next
   if bInclude
      if file( cFileIn )
         US_FileChar26zap( cFileIn )    // Este es el RC principal
         hFiIn := fopen( cFileIn )
         if ferror() != 0
            US_Log( "US_Res 786E: Open Error for file: " + cFileIn )
            ERRORLEVEL(1)
            return 8
         endif
         bLoop := .T.
         nInx := 0
         do while bLoop
            nInx++
            if HB_freadLine( hFiIn , @cAuxLine , cFines ) != 0
               bLoop := .F.
            endif
            if upper( US_Word( cAuxLine , 1 ) ) == "#INCLUDE"
               cFileInclude := US_WordSubStr( cAuxLine , 2 )
               cFileInclude := alltrim( strtran( strtran( cFileInclude , '"' , "" ) , "'" , "" ) )
               if !file( cFileInclude )
                  cMemoSal := cMemoSal + if( nInx > 1 , HB_OsNewLine() , "" ) + "// --- File not Found !!! " + cAuxLine
                  cMemoError := cMemoError + "Error: Line " + alltrim( str( nInx ) ) + ", Include File not Found: " + cAuxLine + HB_OsNewLine()
                  QPM_Log( "US_Res 875E: Include file not found: "+cAuxLine )
                  QPM_Log( ""+HB_OsNewLine() )
                  bIncError := .T.
               else
                  cMemoSal := cMemoSal + if( nInx > 1 , HB_OsNewLine() , "" ) + "// " + replicate( "=" , 80 )
                  cMemoSal := cMemoSal + HB_OsNewLine() + "// INI - Include file: " + cFileInclude
                  cMemoSal := cMemoSal + HB_OsNewLine() + "// " + replicate( "-" , 80 )
            //    US_FileChar26zap( cFileInclude )   // esto lo suspendi porque me cambia la fecha del archivo, habria que probar con US_MemoChar26Zap, o sea revisar que esa funcion haga lo que tiene que hacer
                  cMemoSal := cMemoSal + HB_OsNewLine() + MemoRead( cFileInclude )
                  cMemoSal := cMemoSal + HB_OsNewLine() + "// " + replicate( "-" , 80 )
                  cMemoSal := cMemoSal + HB_OsNewLine() + "// END - Include file: " + cFileInclude
                  cMemoSal := cMemoSal + HB_OsNewLine() + "// " + replicate( "=" , 80 )
               endif
            else
               cMemoSal := cMemoSal + if( nInx > 1 , HB_OsNewLine() , "" ) + cAuxLine
            endif
         enddo
         fclose( hFiIn )
         memowrit( cFileOut , cMemoSal )
         US_FileChar26Zap( cFileOut )
         if len( cMemoError ) > 0
            memowrit( cFileOut+".Error" , "Processing Include of RC file: " + cFileIn + HB_OsNewLine() + cMemoError )
            US_FileChar26Zap( cFileOut+".Error" )
         endif
      else
         QPM_Log( "US_Res 555E: Error open Input File "+cFileIn )
         QPM_Log( ""+HB_OsNewLine() )
         ERRORLEVEL(1)
         Return 8
      endif
      if bIncError
         ERRORLEVEL(1)
         Return 8
      else
         Return 0
      endif
   endif
   ferase( cFileOut )
   US_FileChar26zap( cFileIn )    // Este es el RC principal
   hFiIn := fopen( cFileIn )
   if ferror() = 0
      IF (hFiOut := FCREATE( cFileOut ) ) == -1
         QPM_Log( "US_Res 011E: Error in creation of File Out ("+alltrim(str(Ferror()))+") "+cFileOut )
         fclose( hFiIn )
         QPM_Log( ""+HB_OsNewLine() )
         ERRORLEVEL(1)
         return 12
      ENDIF
      do while bLoop
         if HB_freadLine( hFiIn , @cLinea , cFines ) != 0
            bLoop := .F.
         endif
         cont++
         bChg:=.F.
         cLinea := Alltrim( strtran( cLinea , chr(09) , " " ) )
         if substr( cLinea , 1 , 1 ) == "*"   .or. ;
            substr( cLinea , 1 , 1 ) == "#"   .or. ;
            substr( cLinea , 1 , 2 ) == "//"  .or. ;
            substr( cLinea , 1 , 2 ) == "&&"  .or. ;
            us_words( cLinea ) < 3
            if bList
               QPM_Log( "US_Res 234I: Comment ("+alltrim(str(cont))+"): "+cLinea )
               QPM_Log( "------------" )
            endif
         else
      //    if !bForceChg
               do case
                  // For: .\resources\main.ico
                  case substr( us_word( cLinea , 3 ) , 1 , 2 ) == ".\" .or. ;  && .\resources\main.ico
                       substr( us_word( cLinea , 3 ) , 1 , 2 ) == "./"         && ./resources/main.ico
                     cLineaAux := cLinea
                     cRule := "R01"
                     cWord3 := us_word( substr( cLinea , us_wordind( cLinea , 3 ) + 2 ) , 1 )
                     cLinea := substr( cLinea , 1 , us_wordind( cLinea , 3 ) - 1 ) + cApost + cPathTMP + US_WSlash( cWord3 ) + cApost
                     bChg:=.T.
                  // For: "D:\resources\main.ico"
      ***         case substr( us_word( cLinea , 3 ) , 1 , 1 ) == '"'
      ***            cLineaAux := cLinea
      ***            cRule := "R02"
      ***            cWord3 := substr( cLinea , us_wordind( cLinea , 3 ) , at( '"' , substr( cLinea , us_wordind( cLinea , 3 ) + 1 ) ) )
      ***            cLinea := substr( cLinea , 1 , us_wordind( cLinea , 3 ) - 1 ) + cApost + cPathTMP + US_WSlash( cWord3 ) + cApost
      ***            bChg:=.T.
                  // For: main.ico
                  case !( at( ":\" , us_word( cLinea , 3 ) ) > 0 ) .and. ;
                       !( at( ":/" , us_word( cLinea , 3 ) ) > 0 ) .and. ;
                       substr( us_word( cLinea , 3 ) , 1 , 1 ) != "'" .and. ;
                       substr( us_word( cLinea , 3 ) , 1 , 1 ) != '"'
                     cLineaAux := cLinea
                     cRule := "R03"
                     cWord3 := us_word( substr( cLinea , us_wordind( cLinea , 3 ) ) , 1 )
                     cLinea := substr( cLinea , 1 , us_wordind( cLinea , 3 ) - 1 ) + cApost + cPathTMP + US_WSlash( cWord3 ) + cApost
                     bChg:=.T.
                  // For: 'main.ico'
                  case !( at( ":\" , us_word( cLinea , 3 ) ) > 0 ) .and. ;
                       !( at( ":/" , us_word( cLinea , 3 ) ) > 0 ) .and. ;
                       substr( us_word( cLinea , 3 ) , 1 , 1 ) = "'"
                     cLineaAux := cLinea
                     cRule := "R04"
                     cWord3 := substr( cLinea , us_wordind( cLinea , 3 ) + 1 , at( "'" , substr( cLinea , us_wordind( cLinea , 3 ) + 1 ) ) - 1 )
                     cLinea := substr( cLinea , 1 , us_wordind( cLinea , 3 ) - 1 ) + cApost + cPathTMP + US_WSlash( cWord3 ) + cApost
                     bChg:=.T.
                  // For: "main.ico"
                  case !( at( ":\" , us_word( cLinea , 3 ) ) > 0 ) .and. ;
                       !( at( ":/" , us_word( cLinea , 3 ) ) > 0 ) .and. ;
                       substr( us_word( cLinea , 3 ) , 1 , 1 ) = '"'
                     cLineaAux := cLinea
                     cRule := "R05"
                     cWord3 := substr( cLinea , us_wordind( cLinea , 3 ) + 1 , at( '"' , substr( cLinea , us_wordind( cLinea , 3 ) + 1 ) ) - 1 )
                     cLinea := substr( cLinea , 1 , us_wordind( cLinea , 3 ) - 1 ) + cApost + cPathTMP + US_WSlash( cWord3 ) + cApost
                     bChg:=.T.
                  // For: D:\resources\main.ico
      ***         case at( ":\" , us_word( cLinea , 3 ) ) = 2 .or. ;
      ***              at( ":/" , us_word( cLinea , 3 ) ) = 2
      ***            cLineaAux := cLinea
      ***            cRule := "R06"
      ***            cWord3 := us_word( substr( cLinea , us_wordind( cLinea , 3 ) ) , 1 )
      ***            cLinea := substr( cLinea , 1 , us_wordind( cLinea , 3 ) - 1 ) + cApost + US_WSlash( cWord3 ) + cApost
      ***            bChg:=.T.
               endcase
               if bList .and. bChg
                  QPM_Log( "US_Res 004I: Old ("+padl(alltrim(str(cont)),8)+"): " + cLineaAux )
                  QPM_Log( "US_Res 234I: Resource rule " + cRule + " > " + cWord3 )
                  QPM_Log( "US_Res 005I: New ("+padl(alltrim(str(cont)),8)+"): " + cLinea )
                  QPM_Log( "------------" )
                  cLineaAux:=""
               endif
               if bList .and. !bChg
                  QPM_Log( "US_Res 444I: Without Change ("+alltrim(str(cont))+"): " + cLinea )
                  QPM_Log( "------------" )
               endif
      //    endif
            if bForceChg .and. ( at( ":\" , us_word( cLinea , 3 ) ) = 2 .or. ;
                               at( ":/" , us_word( cLinea , 3 ) ) = 2 )
               cLineaAux := cLinea
               cRule := "R10 Forced"
               cSlash:=substr(us_word( cLinea , 3 ) , 3 , 1 )
               cWord3 := us_word( substr( cLinea , us_wordind( cLinea , 3 ) ) , 1 )
               cWord3 := substr( cWord3 , rat( cSlash , cWord3 ) + 1 )
               cLinea := substr( cLinea , 1 , us_wordind( cLinea , 3 ) - 1 ) + cApost + cPathTMP + cWord3 + cApost
               bChg:=.T.
            endif
            if bForceChg .and. ( at( ":\" , us_word( cLinea , 3 ) ) = 3 .or. ;
                               at( ":/" , us_word( cLinea , 3 ) ) = 3 ) .and. ;
               ( at( "'" , us_word( cLinea , 3 ) ) = 1 .or. ;
                 at( '"' , us_word( cLinea , 3 ) ) = 1 )
               cLineaAux := cLinea
               cRule := "R11 Forced"
               cSlash:=substr(us_word( cLinea , 3 ) , 4 , 1 )
               cChar:=substr(us_word( cLinea , 3 ) , 1 , 1 )
               cWord3 := us_word( substr( cLinea , us_wordind( cLinea , 3 ) + 1 ) , 1 )
               cWord3 := substr( cWord3 , rat( cSlash , cWord3 ) + 1 )
               cWord3 := substr( cWord3 , 1 , rat( cChar , cWord3 ) - 1 )
               cLinea := substr( cLinea , 1 , us_wordind( cLinea , 3 ) - 1 ) + cApost + cPathTMP + cWord3 + cApost
               bChg:=.T.
            endif
            if bList .and. bChg
               QPM_Log( "US_Res 004I: Old ("+padl(alltrim(str(cont)),8)+"): " + cLineaAux )
               QPM_Log( "US_Res 234I: Resource rule " + cRule + " > " + cWord3 )
               QPM_Log( "US_Res 005I: New ("+padl(alltrim(str(cont)),8)+"): " + cLinea )
               QPM_Log( "------------" )
               cLineaAux:=""
            endif
         endif
         cLinea:=cLinea+HB_OsNewLine()
         nBytesSalida:=len(cLinea)
         if fwrite( hFiOut , cLinea , nBytesSalida ) < nBytesSalida
            QPM_Log( "US_Res 012E: Error in save into Out File ("+alltrim(str(Ferror()))+") "+cFileOut )
            fclose( hFiIn )
            QPM_Log( ""+HB_OsNewLine() )
            ERRORLEVEL(1)
            return 16
         endif
      enddo
      fclose( hFiIn )
      fclose( hFiOut )
      US_FileChar26Zap( cFileOut )
   else
      QPM_Log( "US_Res 001E: Error open Input File "+cFileIn )
      QPM_Log( ""+HB_OsNewLine() )
      ERRORLEVEL(1)
      Return 8
   endif
   if bList
      QPM_Log( ""+HB_OsNewLine() )
   endif
   // __Run( "Pause" )
return 0

Function QPM_Log( STRING )
   Local LogArchi:=cQPMDir+"QPM.LOG"
   Local MSG:=DTOS(DATE())+" "+TIME()+" Stack("+alltrim(str(US_Stack()))+") "+Procname(1)+"("+alltrim(str(procline(1)))+")"
   MSG:=MSG+" "+STRING
   SET CONSOLE OFF
   SET ALTERNATE TO (LogArchi) ADDITIVE
   SET ALTERNATE ON
   ? MSG
   SET ALTERNATE OFF
   SET ALTERNATE TO
   SET CONSOLE ON
RETURN .t.

/* eof */
