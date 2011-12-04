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

FUNCTION MAIN(cP1,cP2,cP3,cP4,cP5,cP6,cP7,cP8,cP9,cP10,cP11,cP12,cP13,cP14,cP15,cP16,cP17,cP18,cP19,cP20, ;
              cP21,cP22,cP23,cP24,cP25,cP26,cP27,cP28,cP29,cP30,cP31,cP32,cP33,cP34,cP35,cP36,cP37,cP38,cP39,cP40)
   Local Version:="01.03" , cTxtAux := "" , cTxtAux2 := "" , i := 0
   Local cModuleNameAux := "?" , cLineaAux := "" , cLineaAux2 := "" , bEncontroValido := .F.
   Local nPos := 0 , bObjLst := .F. , bExpLst := .F. , cObjExt := ".ObjLst" , cExpExt := ".ExpLst"
   Local MemoObjLst := "" , MemoExpLst := "EXPORTS"
   Local bDelete := .F. , cLastModuleFound := "" , nZap := 0
   Local bPellesDynamic := .F.
   Local bBorlandDynamic := .F.
   Local bMinGWDynamic := .F.
   Local cDLL_Name     := ""
   Local nDLL_NameAux := 0
   Local cDLL_NameFunAux := ""
   Local cDLL_NameMemoAux := ""
   Local nLineaBaseExport := 0 , vObjectsPelles := {} , vFuncionesPelles := {} , bFunList := .F.
   Private Tab:=Replicate(" ",0) , vFun := {} , j := 0 , bSay := .T. , bError:=.F. , bWarning:=.F. , cFileStop := ""
   Private cTimeStamp := ""

   cP1 =IIF(cP1 ==NIL,"",cP1 )
   cP2 =IIF(cP2 ==NIL,"",cP2 )
   cP3 =IIF(cP3 ==NIL,"",cP3 )
   cP4 =IIF(cP4 ==NIL,"",cP4 )
   cP5 =IIF(cP5 ==NIL,"",cP5 )
   cP6 =IIF(cP6 ==NIL,"",cP6 )
   cP7 =IIF(cP7 ==NIL,"",cP7 )
   cP8 =IIF(cP8 ==NIL,"",cP8 )
   cP9 =IIF(cP9 ==NIL,"",cP9 )
   cP10=IIF(cP10==NIL,"",cP10)
   cP11=IIF(cP11==NIL,"",cP11)
   cP12=IIF(cP12==NIL,"",cP12)
   cP13=IIF(cP13==NIL,"",cP13)
   cP14=IIF(cP14==NIL,"",cP14)
   cP15=IIF(cP15==NIL,"",cP15)
   cP16=IIF(cP16==NIL,"",cP16)
   cP17=IIF(cP17==NIL,"",cP17)
   cP18=IIF(cP18==NIL,"",cP18)
   cP19=IIF(cP19==NIL,"",cP19)
   cP20=IIF(cP20==NIL,"",cP20)
   cP21=IIF(cP21==NIL,"",cP21)
   cP22=IIF(cP22==NIL,"",cP22)
   cP23=IIF(cP23==NIL,"",cP23)
   cP24=IIF(cP24==NIL,"",cP24)
   cP25=IIF(cP25==NIL,"",cP25)
   cP26=IIF(cP26==NIL,"",cP26)
   cP27=IIF(cP27==NIL,"",cP27)
   cP28=IIF(cP28==NIL,"",cP28)
   cP29=IIF(cP29==NIL,"",cP29)
   cP30=IIF(cP30==NIL,"",cP30)
   cP31=IIF(cP31==NIL,"",cP31)
   cP32=IIF(cP32==NIL,"",cP32)
   cP33=IIF(cP33==NIL,"",cP33)
   cP34=IIF(cP34==NIL,"",cP34)
   cP35=IIF(cP35==NIL,"",cP35)
   cP36=IIF(cP36==NIL,"",cP36)
   cP37=IIF(cP37==NIL,"",cP37)
   cP38=IIF(cP38==NIL,"",cP38)
   cP39=IIF(cP39==NIL,"",cP39)
   cP40=IIF(cP40==NIL,"",cP40)
   cParam:=ALLTRIM(cP1+" "+cP2+" "+cP3+" "+cP4+" "+cP5+" "+cP6+" "+cP7+" "+cP8+" "+cP9+" "+cP10+" "+cP11+" "+cP12+" "+cP13+" "+cP14+" "+cP15+" "+cP16+" "+cP17+" "+cP18+" "+cP19+" "+cP20+" "+ ;
                   cP21+" "+cP22+" "+cP23+" "+cP24+" "+cP25+" "+cP26+" "+cP27+" "+cP28+" "+cP29+" "+cP30+" "+cP31+" "+cP32+" "+cP33+" "+cP34+" "+cP35+" "+cP36+" "+cP37+" "+cP38+" "+cP39+" "+cP40)

   if ( Upper( US_Word( cParam , 1 ) ) == "-VER" .or. Upper( US_Word( cParam , 1 ) ) == "-VERSION" )
      MemoWrit( "US_Shell.version" , Version )
      Return .T.
   endif

   if Upper( US_Word( cParam , 1 ) ) != "QPM"
      Say( "US_Shell 999E: Running out System" )
      ERRORLEVEL(1)
      return -1
   else
      cParam := US_WordDel( cParam , 1 )
   endif

// us_log( cParam , .F. )
   if ( nPos := US_WordPos( "-FILESTOP" , US_Upper( cParam ) ) ) > 0
      if US_Words( cParam ) == nPos
         Say( "US_Shell 934E: FILESTOP Whitout FileName, USE: -FILESTOP cDisc:\cPath\cFileName.ext" )
         ERRORLEVEL(1)
         return -1
      endif
      cFileStop := US_Word( cParam , nPos + 1 )
 //us_log( cFileStop , .F. )
      Say( "US_Shell 933I: FILESTOP: " + cFileStop )
      cParam := US_WordDel( cParam , nPos + 1 )
      cParam := US_WordDel( cParam , nPos )
   endif

   if ( nPos := US_WordPos( "-OFF" , US_Upper( cParam ) ) ) > 0
      cParam := US_WordDel( cParam , nPos )
      bSay := .F.
   endif

   do case
      case Upper( US_Word( cParam , 1 ) ) == "CHECKRC"
         if US_Words( cParam ) < 2
            Say( "US_Shell 410E: Invalid parm (count): " + cParam )
            bError:=.T.
         else
            Say( "US_Shell 000I: Processing: "+cParam )
            Say( "US_Shell 300I: CheckRC" )
            Say( "       Option: " + US_Word(cParam,2) )
            do case
               case upper( US_Word( cParam , 2 ) ) == "NOTFILE"
                  Say( "         File: " + US_Word(cParam,3) )
                  if !file( US_Word(cParam,3) )
                     Say( "US_Shell 380I: File Not Found: " + US_Word(cParam,3) )
                     Say( "US_Shell 381E: Stop Processing" )
                     bError:=.T.
                  else
                     Say( "US_Shell 386I: File Found: " + US_Word(cParam,3) + ' (' + alltrim( str( US_FileSize( US_Word(cParam,3) ) ) ) + ' bytes)' )
                  endif
               otherwise
                  Say( "US_Shell 401E: Invalid parm (options 2): " + US_Word( cParam , 2 ) )
                  bError:=.T.
            endcase
         endif
      case Upper( US_Word( cParam , 1 ) ) == "COPY" .or. ;
           Upper( US_Word( cParam , 1 ) ) == "COPYZAP"
         if US_Words( cParam ) < 3
            Say( "US_Shell 010E: Invalid parm (count): " + cParam )
            bError:=.T.
         else
            Say( "US_Shell 000I: Processing: "+cParam )
            Say( "US_Shell 011I: Copy file" )
            Say( "         File In: " + US_Word(cParam,2) )
            Say( "         File Out: " + US_Word(cParam,3) )
            if !file( US_Word(cParam,2) )
               Say( "US_Shell 012E: Input file not found: " + US_Word(cParam,2) )
               bError:=.T.
            else
               if !US_IsDirectory( US_FileNameOnlyPath( US_Word( cParam , 3 ) ) )
                  Say( "US_Shell 015E: Output Folder not found: " + US_Word(cParam,3) )
                  bError:=.T.
               else
                  if filecopy( US_Word(cParam,2) , US_Word(cParam,3) ) == US_FileSize( US_Word(cParam,2) )
              //\\COPY FILE ( US_Word(cParam,2) ) TO ( US_Word(cParam,3) )
              //\\if ferror() = 0
                     Say( "US_Shell 013I: Copy file OK" )
                     if Upper( US_Word( cParam , 1 ) ) == "COPYZAP"
                        nZap := US_FileChar26Zap( US_Word(cParam,3) )
                        do case
                           case nZap == -1
                              Say( "US_Shell 234W: Warning, char x'1A' not removed" )
                           case nZap == 1
                              Say( "US_Shell 235I: Char x'1A' removed" )
                        endcase
                     endif
                  else
                     Say( "US_Shell 014E: Error in Copy file !!!" )
               //    if upper( US_FileNameOnlyExt( US_Word(cParam,3) ) ) == "EXE"
               //       Say( "               " + US_Word(cParam,3) + " Is Running ?" )
               //    else
               //       Say( "               " + US_Word(cParam,3) + " Is Open by Another Application ?" )
               //    endif
                     Say( "               " + US_Word(cParam,3) + " Is Running or Open by Another Application ???" )
                     bError:=.T.
                  endif
               endif
            endif
         endif
      case Upper( US_Word( cParam , 1 ) ) == "MOVE" .or. ;
           Upper( US_Word( cParam , 1 ) ) == "MOVEZAP"
         if US_Words( cParam ) < 3
             Say( "US_Shell 020E: Invalid parm (count): " + cParam )
            bError:=.T.
         else
            Say( "US_Shell 000I: Processing: "+cParam )
            Say( "US_Shell 021I: Move file" )
            Say( "         File In: " + US_Word(cParam,2) )
            Say( "         File Out: " + US_Word(cParam,3) )
            if !file( US_Word(cParam,2) )
               Say( "US_Shell 022E: Input file not found: " + US_Word(cParam,2) )
               bError:=.T.
            else
               if !US_IsDirectory( US_FileNameOnlyPath( US_Word( cParam , 3 ) ) )
                  Say( "US_Shell 025E: Output Folder not found: " + US_Word(cParam,3) )
                  bError:=.T.
               else
              //\\COPY FILE ( US_Word(cParam,2) ) TO ( US_Word(cParam,3) )
              //\\if ferror() != 0
                  if filecopy( US_Word(cParam,2) , US_Word(cParam,3) ) != US_FileSize( US_Word(cParam,2) )
                     Say( "US_Shell 023E: Error in Move file (Copy error !!!)" )
                  // if upper( US_FileNameOnlyExt( US_Word(cParam,3) ) ) == "EXE"
                  //    Say( "               " + US_Word(cParam,3) + " Is Running ?" )
                  // else
                  //    Say( "               " + US_Word(cParam,3) + " Is Open by Another Application ?" )
                  // endif
                     Say( "               " + US_Word(cParam,3) + " Is Running or Open by Another Application ???" )
                     bError:=.T.
                  else
                     if ferase( US_Word(cParam,2) ) == -1
                        Say( "US_Shell 026E: Error in Move file (Original file not deleted !!! )" )
                        bError:=.T.
                     else
                        Say( "US_Shell 024I: Move file OK" )
                        if Upper( US_Word( cParam , 1 ) ) == "MOVEZAP"
                           nZap := US_FileChar26Zap( US_Word(cParam,3) )
                           do case
                              case nZap == -1
                                 Say( "US_Shell 234W: Warning, char x'1A' not removed" )
                              case nZap == 1
                                 Say( "US_Shell 235I: Char x'1A' removed" )
                           endcase
                        endif
                        memowrit( US_Word(cParam,2)+".MOVED.TXT" , "File "+US_Word(cParam,2)+" has been moved to: "+US_Word(cParam,3) )
                     endif
                  endif
               endif
            endif
         endif
      case Upper( US_Word( cParam , 1 ) ) == "LIST_TXT"
         if US_Words( cParam ) < 2
             Say( "US_Shell 080E: Invalid parm (count): " + cParam )
            bError:=.T.
         else
            Say( "US_Shell 000I: Processing: "+cParam )
            if ( nPos := US_WordPos( "-DELETE" , US_Upper( cParam ) ) ) > 0
               cParam := US_WordDel( cParam , nPos )
               bDelete := .T.
            endif
            Say( "US_Shell 081I: Listing Content File" )
            Say( "US_Shell 087I: File to List: " + US_Word(cParam,2) )
            if !file( US_Word(cParam,2) )
               Say( "US_Shell 082E: Input file not found: " + US_Word(cParam,2) )
               bError:=.T.
            else
               cTxtAux := MemoRead( US_Word(cParam,2) )
               for i:=1 to MLCount( cTxtAux , 254 )
                  Say( memoline( cTxtAux , 254 , i ) )
                  if US_Shell_bStop()
                     Say( "US_Shell 930W: User Stop" )
                     bWarning := .T.
                     exit
                  endif
               next
               Say( "US_Shell 088I: End List" )
               if bDelete
                  ferase( US_Word(cParam,2) )
               endif
            endif
         endif
      case Upper( US_Word( cParam , 1 ) ) == "ANALIZE_DLL"
         if US_Words( cParam ) < 2
             Say( "US_Shell 030E: Invalid parm (count): " + cParam )
            bError:=.T.
         else
            Say( "US_Shell 000I: Processing: "+cParam )
            if ( nPos := US_WordPos( "-DELETE" , US_Upper( cParam ) ) ) > 0
               cParam := US_WordDel( cParam , nPos )
               bDelete := .T.
            endif
            Say( "US_Shell 031I: Analizing Definition File for Dynamic Library (DLL)" )
            Say( "         File In: " + US_Word(cParam,2) )
            if !file( US_Word(cParam,2) )
               Say( "US_Shell 032E: Input file not found: " + US_Word(cParam,2) )
               bError:=.T.
            else
               Say( "Function Exported for this DLL: " )
               cTxtAux := MemoRead( US_Word(cParam,2) )
               nLineaBaseExport := MLCount( cTxtAux , 254 )
               for i:=1 to MLCount( cTxtAux , 254 )
                  if alltrim( memoline( cTxtAux , 254 , i ) ) == "EXPORTS"
                     nLineaBaseExport := i + 1
                  endif
               next
               for i:=nLineaBaseExport to MLCount( cTxtAux , 254 )
                  cLineaAux := US_Word( memoline( cTxtAux , 254 , i ) , 1 )
               // aadd( vFun , "             " + padl( alltrim( str( i - nLineaBaseExport + 1 ) ) , 5 ) + ": " + ;
               //          cLineaAux )
                  say( "             " + padl( alltrim( str( i - nLineaBaseExport + 1 ) ) , 5 ) + ": " + ;
                           cLineaAux )
                  if US_Shell_bStop()
                     Say( "US_Shell 930W: User Stop" )
                     bWarning := .T.
                     exit
                  endif
               next
         //    asort( vFun , {|x,y| US_Word( x , 1 ) < US_Word( y , 1 ) } )
         //    For i:=1 to len( vFun )
         //       Say( vFun[i] )
         //    Next i
               Say( "End Function List" )
               if bDelete
                  ferase( US_Word(cParam,2) )
               endif
            endif
         endif
 //   case Upper( US_Word( cParam , 1 ) ) == "ANALIZE_DLL"
 //      if US_Words( cParam ) < 2
 //          Say( "US_Shell 030E: Invalid parm (count): " + cParam )
 //         bError:=.T.
 //      else
 //         Say( "US_Shell 000I: Processing: "+cParam )
 //         if ( nPos := US_WordPos( "-DELETE" , US_Upper( cParam ) ) ) > 0
 //            cParam := US_WordDel( cParam , nPos )
 //            bDelete := .T.
 //         endif
 //         Say( "US_Shell 031I: Analizing Definition File for Dynamic Library (DLL)" )
 //         Say( "         File In: " + US_Word(cParam,2) )
 //         if !file( US_Word(cParam,2) )
 //            Say( "US_Shell 032E: Input file not found: " + US_Word(cParam,2) )
 //            bError:=.T.
 //         else
 //            Say( "Function Exported for this DLL: " )
 //            cTxtAux := MemoRead( US_Word(cParam,2) )
 //            for i:=1 to MLCount( cTxtAux , 254 )
 //               cLineaAux := memoline( cTxtAux , 254 , i )
 //               if at( " @" , cLineaAux ) > 0 .and. ;
 //                  at( " ; " , cLineaAux ) > 0
 //                  aadd( vFun , "             " + padl( strtran( US_Word( cLineaAux , 2 ) , "@" , "" ) , 5 ) + ": " + ;
 //                        US_WordSubStr( cLineaAux , 4 ) )
 //               endif
 //            next
 //            asort( vFun , {|x,y| US_Word( x , 1 ) < US_Word( y , 1 ) } )
 //            For i:=1 to len( vFun )
 //               Say( vFun[i] )
 //            Next i
 //            Say( "End Function List" )
 //            if bDelete
 //               ferase( US_Word(cParam,2) )
 //            endif
 //         endif
 //      endif
      case Upper( US_Word( cParam , 1 ) ) == "ANALIZE_LIB_PELLES"
         if US_Words( cParam ) < 2
            Say( "US_Shell 040E: Invalid parm (count): " + cParam )
            bError:=.T.
         else
            Say( "US_Shell 000I: Processing: "+cParam )
            if ( nPos := US_WordPos( "-DELETE" , US_Upper( cParam ) ) ) > 0
               cParam := US_WordDel( cParam , nPos )
               bDelete := .T.
            endif
            if ( nPos := US_WordPos( "-OBJLST" , US_Upper( cParam ) ) ) > 0
               cParam := US_WordDel( cParam , nPos )
               bObjLst := .T.
            endif
            if ( nPos := US_WordPos( "-EXPLST" , US_Upper( cParam ) ) ) > 0
               cParam := US_WordDel( cParam , nPos )
               bExpLst := .T.
            endif
            Say( "US_Shell 041I: Analizing Definition File for Pelles Static Library" )
            Say( "         File In: " + US_Word(cParam,2) )
            if bObjLst
               Say( "         File Out: " + US_Word(cParam,2) + cObjExt )
            endif
            if bExpLst
               Say( "         File Out: " + US_Word(cParam,2) + cExpExt )
            endif
            if !file( US_Word(cParam,2) )
               Say( "US_Shell 042E: Input file not found: " + US_Word(cParam,2) )
               bError:=.T.
            else
               Say( "Function List for this LIB: " )
               bPellesDynamic := .F.
               cTxtAux := MemoRead( US_Word(cParam,2) )
               for i:=1 to MLCount( cTxtAux , 254 )
                  cLineaAux := memoline( cTxtAux , 254 , i )
                  if at( "Long name: " , cLineaAux ) == 1
                     aadd( vObjectsPelles , US_FileNameOnlyName( substr( cLineaAux , 12 ) ) )
                  endif
               next
               if len( vObjectsPelles ) == 0
                  bPellesDynamic := .t.
                  cDLL_Name := strtran( US_Word( substr( cTxtAux , rat( "Member at offset" , cTxtAux ) ) , 5 ) , "/" , "" )
               endif
               bFunList := .F.
               for i:=1 to MLCount( cTxtAux , 254 )
                  cLineaAux := memoline( cTxtAux , 254 , i )
                  if US_Word( cLineaAux , 2 ) == "global" .and. ;
                     US_Word( cLineaAux , 3 ) == "symbols" .and. ;
                     US_Words( cLineaAux ) == 3
                     bFunList := .T.
                  // loop
                  endif
                  if bFunList .and. ;
                     US_Word( cLineaAux , 1 ) == "Member" .and. ;
                     US_Word( cLineaAux , 2 ) == "at" .and. ;
                     US_Word( cLineaAux , 3 ) == "offset"
                     exit
                  endif
                  if bFunList .and. ;
                     US_Words( cLineaAux ) == 2
                     if bPellesDynamic
                        aadd( vFuncionesPelles , "DYNAMIC " + cDLL_Name + " " + US_Word( cLineaAux , 2 ) )
                     else
                        aadd( vFuncionesPelles , "STATIC " + vObjectsPelles[ VAL(NTOC(US_Word( cLineaAux , 1 ),10)) ] + " " + US_Word( cLineaAux , 2 ) )
                     endif
                  endif
               next
               asort( vFuncionesPelles , {|x,y| x < y } )
               if len( vFuncionesPelles ) == 0
                  cTxtAux2 := 'No public symbols exist.'
               else
                  for i:=1 to len( vFuncionesPelles )
                     cTxtAux2 := cTxtAux2 + vFuncionesPelles[i] + HB_OsNewLine()
                  next
               endif
               cTxtAux := cTxtAux2
               if alltrim( memoline( cTxtAux , 254 , 1 ) ) == 'No public symbols exist.'
                  Say( "US_Shell 048W: " + alltrim( memoline( cTxtAux , 254 , 1 ) ) )
                  bWarning := .T.
               else
                  cModuleNameAux := "."
                  for i:=1 to MLCount( cTxtAux , 254 )
                     cLineaAux := memoline( cTxtAux , 254 , i )
                     if US_Word( cLineaAux , 2 ) != cModuleNameAux               // .and. ;
              //        cModuleNameAux != "."
                        US_Shell_Listo()
                        cModuleNameAux := US_Word( cLineaAux , 2 )
                        if US_Word( cLineaAux , 1 ) == "DYNAMIC"
                           Say( "    Dynamic link import (IMPDEF) From " + cModuleNameAux )
                        else
                           Say( "    Static Module " + cModuleNameAux )
                           if bObjLst
                              MemoObjLst := MemoObjLst + if( !empty( MemoObjLst ) , hb_OsNewLine() , "" ) + cModuleNameAux
                           endif
                        endif
                     endif
                     if !empty( cLineaAux )
                        cModuleNameAux := US_Word( cLineaAux , 2 )
                        aadd( vFun , "             " + substr( US_Word( cLineaAux , 3 ) , 1 ) )
                        if bExpLst
                           MemoExpLst := MemoExpLst + hb_OsNewLine() + substr( US_Word( cLineaAux , 3 ) , 1 )
                        endif
                     endif
                     if US_Shell_bStop()
                        Say( "US_Shell 930W: User Stop" )
                        bWarning := .T.
                        exit
                     endif
                  next
                  US_Shell_Listo()
                  Say( "End Function List" )
                  if bObjLst
                     MemoWrit( US_Word(cParam,2) + cObjExt , MemoObjLst )
                  endif
                  if bExpLst
                     MemoWrit( US_Word(cParam,2) + cExpExt , MemoExpLst )
                  endif
               endif
               if bDelete
                  ferase( US_Word(cParam,2) )
               endif
            endif
         endif
      case Upper( US_Word( cParam , 1 ) ) == "ANALIZE_LIB_BORLAND"
         if US_Words( cParam ) < 2
            Say( "US_Shell 140E: Invalid parm (count): " + cParam )
            bError:=.T.
         else
            Say( "US_Shell 000I: Processing: "+cParam )
            if ( nPos := US_WordPos( "-DELETE" , US_Upper( cParam ) ) ) > 0
               cParam := US_WordDel( cParam , nPos )
               bDelete := .T.
            endif
            if ( nPos := US_WordPos( "-OBJLST" , US_Upper( cParam ) ) ) > 0
               cParam := US_WordDel( cParam , nPos )
               bObjLst := .T.
            endif
            if ( nPos := US_WordPos( "-EXPLST" , US_Upper( cParam ) ) ) > 0
               cParam := US_WordDel( cParam , nPos )
               bExpLst := .T.
            endif
            Say( "US_Shell 141I: Analizing Definition File for Borland Static Library" )
            Say( "         File In: " + US_Word(cParam,2) )
            if bObjLst
               Say( "         File Out: " + US_Word(cParam,2) + cObjExt )
            endif
            if bExpLst
               Say( "         File Out: " + US_Word(cParam,2) + cExpExt )
            endif
            if !file( US_Word(cParam,2) )
               Say( "US_Shell 142E: Input file not found: " + US_Word(cParam,2) )
               bError:=.T.
            else
               Say( "Function List for this LIB: " )
               cTxtAux := MemoRead( US_Word(cParam,2) )
               if alltrim( memoline( cTxtAux , 254 , 1 ) ) == 'No public symbols exist.'
                  Say( "US_Shell 148W: " + alltrim( memoline( cTxtAux , 254 , 1 ) ) )
                  bWarning := .T.
               else
                  bBorlandDynamic := .F.
                  for i:=1 to MLCount( cTxtAux , 254 )
                     cLineaAux := memoline( cTxtAux , 254 , i )
                     if US_Word( cLineaAux , 2 ) == "size" .and. ;
                        US_Word( cLineaAux , 3 ) == "="
                        US_Shell_Listo()
                        cModuleNameAux := US_Word( cLineaAux , 1 )
                        if val( US_Word( cLineaAux , 4 ) ) = 0
                           if !bBorlandDynamic
                              cDLL_NameFunAux  := US_Word( cLineaAux , 1 )
                              cDLL_NameMemoAux := memoread( US_FileNameOnlyPathAndName( US_Word(cParam,2) ) )
                              cDLL_NameMemoAux := substr( cDLL_NameMemoAux , at( chr( 14 ) + cDLL_NameFunAux + chr( 12 ) , cDLL_NameMemoAux ) )
                              cDLL_NameMemoAux := strtran( cDLL_NameMemoAux , chr( 12 ) , " " )
                        //    cDLL_NameMemoAux := strtran( cDLL_NameMemoAux , chr(  0 ) , " " )
                              cDLL_NameMemoAux := US_Word( cDLL_NameMemoAux , 2 )
                              cDLL_Name        := substr( cDLL_NameMemoAux , 1 , rat( ".DLL" , upper( cDLL_NameMemoAux ) ) + 3 )
                //      us_log( cDLL_Name )
                              Say( "    Dynamic link import (IMPDEF) From " + cDLL_Name )
                              bBorlandDynamic := .T.
                           endif
                        else
                           Say( "    Static Module " + cModuleNameAux )
                           if bObjLst
                              MemoObjLst := MemoObjLst + if( !empty( MemoObjLst ) , hb_OsNewLine() , "" ) + cModuleNameAux
                           endif
                        endif
                     else
                        if !empty( cLineaAux ) .and. cLineaAux != "Publics by module"
                           aadd( vFun , "             " + substr( US_Word( cLineaAux , 1 ) , 1 ) )
                           if bExpLst
                              MemoExpLst := MemoExpLst + hb_OsNewLine() + substr( US_Word( cLineaAux , 1 ) , 1 )
                           endif
                           if US_Words( cLineaAux ) == 2
                              aadd( vFun , "             " + substr( US_Word( cLineaAux , 2 ) , 1 ) )
                              if bExpLst
                                 MemoExpLst := MemoExpLst + hb_OsNewLine() + substr( US_Word( cLineaAux , 2 ) , 1 )
                              endif
                           endif
                        endif
                     endif
                     if US_Shell_bStop()
                        Say( "US_Shell 930W: User Stop" )
                        bWarning := .T.
                        exit
                     endif
                  next
                  US_Shell_Listo()
                  Say( "End Function List" )
                  if bObjLst
                     MemoWrit( US_Word(cParam,2) + cObjExt , MemoObjLst )
                  endif
                  if bExpLst
                     MemoWrit( US_Word(cParam,2) + cExpExt , MemoExpLst )
                  endif
               endif
               if bDelete
                  ferase( US_Word(cParam,2) )
               endif
            endif
         endif
      case Upper( US_Word( cParam , 1 ) ) == "ANALIZE_LIB_MINGW"
         if US_Words( cParam ) < 2
             Say( "US_Shell 050E: Invalid parm (count): " + cParam )
            bError:=.T.
         else
            Say( "US_Shell 000I: Processing: "+cParam )
            if ( nPos := US_WordPos( "-DELETE" , US_Upper( cParam ) ) ) > 0
               cParam := US_WordDel( cParam , nPos )
               bDelete := .T.
            endif
            if ( nPos := US_WordPos( "-OBJLST" , US_Upper( cParam ) ) ) > 0
               cParam := US_WordDel( cParam , nPos )
               bObjLst := .T.
            endif
            if ( nPos := US_WordPos( "-EXPLST" , US_Upper( cParam ) ) ) > 0
               cParam := US_WordDel( cParam , nPos )
               bExpLst := .T.
            endif
            Say( "US_Shell 051I: Analizing Definition File for MinGW Static Library" )
            Say( "         File In: " + US_Word(cParam,2) )
            if bObjLst
               Say( "         File Out: " + US_Word(cParam,2) + cObjExt )
            endif
            if bExpLst
               Say( "         File Out: " + US_Word(cParam,2) + cExpExt )
            endif
            if !file( US_Word(cParam,2) )
               Say( "US_Shell 052E: Input file not found: " + US_Word(cParam,2) )
               bError:=.T.
            else
               Say( "Function List for this LIB (.A): " )
               cTxtAux := MemoRead( US_Word(cParam,2) )
               bMinGWDynamic := .F.
               for i:=1 to MLCount( cTxtAux , 254 )
                  cLineaAux := memoline( cTxtAux , 254 , i )
                  cLineaAux2 := memoline( cTxtAux , 254 , i + 1 )
                  if US_Words( cLineaAux ) > 3
                     if alltrim( US_WordSubStr( cLineaAux , 2 ) ) == "file format pe-i386"
                        cLastModuleFound := US_Word( cLineaAux , 1 )
                        cLastModuleFound := alltrim( strtran( cLastModuleFound , ":" , "" ) )
                     endif
                  endif
                  if US_Word( cLineaAux , 1 ) == "SYMBOL" .and. ;
                     US_Word( cLineaAux , 2 ) == "TABLE:"
                     cModuleNameAux := US_Word( cLineaAux2 , US_Words( cLineaAux2 ) )
                     // dos primeros files en librerias originadas por import (no interesan)
                     if cModuleNameAux == "fake"
                        bEncontroValido := .F.
                        loop
                     endif
                     // es modulo originado por import
                     if cModuleNameAux == ".text"
                     // US_Shell_Listo()
                        bEncontroValido := .F.
                        cModuleNameAux := cLastModuleFound
                        if !bMinGWDynamic
                           cDLL_Name := substr( cTxtAux , at( "Contents of section" , cTxtAux ) )
                           nDLL_NameAux := rat( " " , substr( cDLL_Name , 1 , at( ".DLL...." , upper( cDLL_Name ) ) ) ) + 1
                           cDLL_Name := strtran( US_Word( substr( cDLL_Name , nDLL_NameAux ) , 1 ) , "...." , "" )
                           Say( "    Dynamic link import (IMPDEF) From " + cDLL_Name )
                           bMinGWDynamic := .T.
                        endif
                        aadd( vFun , "             " + US_Word( memoline( cTxtAux , 254 , i + 8 ) , US_Words( memoline( cTxtAux , 254 , i + 8 ) ) ) )
                        loop
                     else
                        // Modulo estandard
                        US_Shell_Listo()
                        bEncontroValido := .T.
                        cModuleNameAux := substr( cModuleNameAux , 1 , rat( "." , cModuleNameAux ) - 1 )
                        Say( "    Static Module " + cModuleNameAux )
                        if bObjLst
                           MemoObjLst := MemoObjLst + if( !empty( MemoObjLst ) , hb_OsNewLine() , "" ) + cModuleNameAux
                        endif
                     endif
                  else
                     // funcion en modulo estandard
                     if alltrim( cLineaAux ) == "File" .and. bEncontroValido
          //            if US_Word( cLineaAux2 , US_Words( cLineaAux2 ) ) == "_symbols"
                           for j := i+1 to MLCount( cTxtAux , 254 )
                              cLineaAux = memoline( cTxtAux , 254 , j )
                              if substr( US_Word( cLineaAux , US_Words( cLineaAux ) ) , 1 , 7 ) == "_HB_FUN"
                                 aadd( vFun , "             " + US_Word( cLineaAux , US_Words( cLineaAux ) ) )
                                 if bExpLst
                                    MemoExpLst := MemoExpLst + hb_OsNewLine() + US_Word( cLineaAux , US_Words( cLineaAux ) )
                                 endif
                                 i := j
                              // exit
                              endif
                              if substr( US_Word( cLineaAux , US_Words( cLineaAux ) ) , 1 , 1 ) == "." .or. ;
                                 ( !( substr( US_Word( cLineaAux , 1 ) , 1 , 1 ) == "[" ) .and. !( US_Word( cLineaAux , 1 ) == "AUX" ) )
                                 i := j
                                 exit
                              endif
                              if US_Shell_bStop()
                              // Say( "US_Shell 930W: User Stop" )
                              // bWarning := .T.
                                 exit
                              endif
                           next
         //             else
         //                aadd( vFun , "             " + US_Word( cLineaAux2 , US_Words( cLineaAux2 ) ) )
         //                if bExpLst
         //                   MemoExpLst := MemoExpLst + hb_OsNewLine() + US_Word( cLineaAux2 , US_Words( cLineaAux2 ) )
         //                endif
         //             endif
                        bEncontroValido := .F.
                     endif
                  endif
                  if US_Shell_bStop()
                     Say( "US_Shell 930W: User Stop" )
                     bWarning := .T.
                     exit
                  endif
               next
               US_Shell_Listo()
               Say( "End Function List" )
               if bObjLst
                  MemoWrit( US_Word(cParam,2) + cObjExt , MemoObjLst )
               endif
               if bExpLst
                  MemoWrit( US_Word(cParam,2) + cExpExt , MemoExpLst )
               endif
               if bDelete
                  ferase( US_Word(cParam,2) )
               endif
            endif
         endif
      case Upper( US_Word( cParam , 1 ) ) == "DELETE"
         if US_Words( cParam ) < 2
             Say( "US_Shell 060E: Invalid parm (count): " + cParam )
            bError:=.T.
         else
            Say( "US_Shell 000I: Processing: "+cParam )
            if ferase( US_Word(cParam,2) ) == -1
               Say( "US_Shell 064E: Error in Delete file !!!" )
               bError:=.T.
            else
               Say( "US_Shell 065I: File Deleted OK" )
            endif
         endif
      case Upper( US_Word( cParam , 1 ) ) == "CHANGE"
         if US_Words( cParam ) != 4
            Say( "US_Shell 070E: Invalid parm (count): " + cParam )
            bError:=.T.
         else
            Say( "US_Shell 071I: Change into File" )
            Say( "               File: " + US_Word(cParam,2) )
            Say( "               Old String: " + if( US_Word( cParam , 3 ) == "&" , "(Character ampersand)" , US_Word( cParam , 3 ) ) )
            Say( "               New String: " + if( US_Word( cParam , 4 ) == "&" , "(Character ampersand)" , US_Word( cParam , 4 ) ) )
            if !file( US_Word(cParam,2) )
               Say( "US_Shell 072E: Input file not found: " + US_Word(cParam,2) )
               bError:=.T.
            else
               if MemoWrit( US_Word( cParam , 2 ) , strtran( MemoRead( US_Word( cParam , 2 ) ) , US_Word( cParam , 3 ) , US_Word( cParam , 4 ) ) )
                  Say( "US_Shell 073I: Change OK" )
               else
                  Say( "US_Shell 074E: Error in Change File !!!" )
                  bError:=.T.
               endif
            endif
         endif
      case Upper( US_Word( cParam , 1 ) ) == "CHANGE_CHR"
         if US_Words( cParam ) != 4
            Say( "US_Shell 070E: Invalid parm (count): " + cParam )
            bError:=.T.
         else
            Say( "US_Shell 071I: Change CHR into File" )
            Say( "               File: " + US_Word(cParam,2) )
            Say( "               Old String: " + if( US_Word( cParam , 3 ) == "&" , "(Character ampersand)" , US_Word( cParam , 3 ) ) )
            Say( "               New String: " + if( Chr( val( US_Word( cParam , 4 ) ) ) == "&" , "(Character ampersand)" , Chr( val( US_Word( cParam , 4 ) ) ) ) )
            if !file( US_Word(cParam,2) )
               Say( "US_Shell 072E: Input file not found: " + US_Word(cParam,2) )
               bError:=.T.
            else
               if MemoWrit( US_Word( cParam , 2 ) , strtran( MemoRead( US_Word( cParam , 2 ) ) , US_Word( cParam , 3 ) , Chr( val( US_Word( cParam , 4 ) ) ) ) )
                  Say( "US_Shell 073I: Change OK" )
               else
                  Say( "US_Shell 074E: Error in Change File !!!" )
                  bError:=.T.
               endif
            endif
         endif
      otherwise
         Say( "US_Shell 002E: Invalid parm: "+cParam )
         bError:=.T.
   endcase
// inkey(0)
   ferase( cFileStop )
   if bWarning
      ERRORLEVEL(2)
   endif
   if bError
      ERRORLEVEL(1)
   endif
return .T.

Function US_Shell_bStop()
   if file( cFileStop )
      Return .T.
   endif
Return .F.

Function US_Shell_Listo()
   asort( vFun , {|x,y| US_Word( x , 1 ) < US_Word( y , 1 ) } )
   For j:=1 to len( vFun )
      Say( vFun[j] )
      if US_Shell_bStop()
         Say( "US_Shell 930W: User Stop" )
         bWarning := .T.
         exit
      endif
   Next
   vFun := {}
return .T.

Function Say( txt )
   if bSay
      __Run( "ECHO " + Tab + US_TodoStr( txt ) )
   endif
Return .T.

Function GetSuffix()
//   US_Log( "Function " + procname() + " Suspend from US_Shell" )
Return .T.
Function GetMiniGuiSuffix()
//   US_Log( "Function " + procname() + " Suspend from US_Shell" )
Return .T.
Function GetHarbourSuffix()
//   US_Log( "Function " + procname() + " Suspend from US_Shell" )
Return .T.
Function GetCppSuffix()
//   US_Log( "Function " + procname() + " Suspend from US_Shell" )
Return .T.

/* eof */
