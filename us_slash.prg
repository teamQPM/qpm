FUNCTION MAIN(cP1,cP2,cP3,cP4,cP5,cP6,cP7,cP8,cP9,cP10,cP11,cP12,cP13,cP14,cP15,cP16,cP17,cP18,cP19,cP20)
   Local Version:="01.03" , bLoop:=.T. , cLinea , cFines := { Chr(13) + Chr(10) , Chr(10) } , hFiIn , cont:=0 , hFiOut
   Local cFileOut , nBytesSalida:=0 , cFileIn , cParam , cFileTMP , cmd , cmdbat , bList:=.F. , gccbat := "_GCCbat.bat"
   Local estado:="_Status.tmp"
// Local cProgress := "" , cFileProgress := "_Progress.log"
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
      MemoWrit( "US_Slash.version" , Version )
      Return .T.
   endif

   if Upper( US_Word( cParam , 1 ) ) != "QPM"
      __Run( "ECHO " + "US_Slash 999E: Running out System" )
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
   cFileOut:=us_word( cParam , US_Words( cParam ) )
   cFileOut:=substr(cFileOut,3)
   cFileTMP:=substr(cFileIn,1,rat(".",cFileIn))+"CUS"
// cFileProgress := substr( cFileIn , 1 , rat( "\OBJ\" , upper( cFileIn ) ) ) + cFileProgress
   cParam:=alltrim(substr(cParam , 1 , US_WordInd( cParam, US_Words( cParam ) - 1 ) - 1 ))
   if bList
      QPM_Log( "US_Slash "+Version )
      QPM_Log( "Slash 000I: by QPM_Support ( fernando.yurisich@gmail.com )" )
      QPM_Log( "Slash 999I: Log into "+cQPMDir+"QPM.log" )
      QPM_Log( "Slash 003I: FileIn : "+cFileIn )
      QPM_Log( "Slash 013I: FileOut: "+cFileOut )
      QPM_Log( "Slash 023I: FileTMP: "+cFileTMP )
   // QPM_Log( "Slash 233I: FilePro: "+cFileProgress )
      QPM_Log( "Slash 033I: Param : "+cParam )
   endif
// if file( cFileProgress )
//    cProgress := memoread( cFileProgress ) + HB_OsNewLine()
// endif
// cProgress := cProgress + "Processing " + substr( cFileIn , 1 , rat( "." , cFileIn ) - 1 ) + "......"
// memowrit( cFileProgress , cProgress )
   hFiIn := fopen( cFileIn )
   if ferror() = 0
      IF (hFiOut := FCREATE( cFileTMP ) ) == -1
         QPM_Log( "Slash 011E: Error in creation of File Out ("+alltrim(str(Ferror()))+") "+cFileOut )
         fclose( hFiIn )
         QPM_Log( ""+HB_OsNewLine() )
         return 12
      ENDIF
      do while bLoop
         if HB_freadLine( hFiIn , @cLinea , cFines ) != 0
            bLoop := .F.
         endif
         cont++
         if substr( cLinea , 1 , 6 ) == "#line "     .and. ;
            us_words( cLinea ) > 2                   .and. ;
            isdigit( us_word( cLinea , 2 ) ) = .T.
            if bList
               QPM_Log( "Slash 004I: Old ("+padl(alltrim(str(cont)),8)+") "+cLinea )
            endif
            cLinea := strtran( cLinea , "\" , "\\" )
            if bList
               QPM_Log( "Slash 005I: New ("+padl(alltrim(str(cont)),8)+") "+cLinea )
               QPM_Log( "-----------" )
            endif
         endif
         cLinea:=cLinea+HB_OsNewLine()
         nBytesSalida:=len(cLinea)
         if fwrite( hFiOut , cLinea , nBytesSalida ) < nBytesSalida
            QPM_Log( "Slash 012E: Error in save into Out File ("+alltrim(str(Ferror()))+") "+cFileOut )
            fclose( hFiIn )
            QPM_Log( ""+HB_OsNewLine() )
            return 16
         endif
      enddo
      fclose( hFiIn )
      fclose( hFiOut )
   else
      QPM_Log( "Slash 001E: Error open Input File "+cFileIn )
      QPM_Log( ""+HB_OsNewLine() )
      Return 8
   endif
   ferase( cFileIn+".temporal" )
   frename( cFileIn , cFileIn+".temporal" )
   frename( cFileTMP , cFileIn )
   cmdbat:="GCC.EXE "+cParam+" "+cFileIn+" -o"+cFileOut
   cmd:="@echo off"+HB_OsNewLine()+ ;
        cmdbat+HB_OsNewLine()+ ;
        "if errorlevel 1 goto bad"+HB_OsNewLine()+ ;
        "Echo OK > "+estado+HB_OsNewLine()+ ;
        "goto good"+HB_OsNewLine()+ ;
        ":bad"+HB_OsNewLine()+ ;
        "Echo ERROR > "+estado+HB_OsNewLine()+ ;
        ":good"+HB_OsNewLine()
   memowrit( GCCbat , cmd )
   if bList
      QPM_Log( "Slash 043I: Command: "+cmdbat )
      QPM_Log( ""+HB_OsNewLine() )
   endif
   __Run( GCCbat )
   frename( cFileIn , cFileTMP )
   frename( cFileIn+".temporal" , cFileIn )
   if memoline(memoread( estado ),254,1) = "ERROR"
      ERRORLEVEL(1)
   endif
   ferase( GCCbat )
   ferase( estado )
return .T.

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
