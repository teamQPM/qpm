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

#define DBLQT    '"'
#define SNGQT    "'"
#define CRLF     hb_osNewLine()
#define VERSION  "01.07"
MEMVAR cQPMDIR

// Parameters: 1 -> cParam (multiple words), 2 -> cFileIn (one word), 3 -> cFileOut (one word)

PROCEDURE MAIN( ... )
   LOCAL aParams := hb_AParams(), n, cLib, cSearch := "", cGroup := ""
   LOCAL bLoop := .T., cLine, cFines := { Chr(13) + Chr(10), Chr(10) }, hParam, cKey
   LOCAL cFileOut, cFileIn, cParam, gcc_call, cmdbatch, bList := .F., cPath := ""
   LOCAL fgccbat := US_FileTmp( NIL, ".bat" )
   LOCAL fstatus := US_FileTmp()
   LOCAL fparams := US_FileTmp()
   PRIVATE cQPMDir := ""

   cParam := ""
   FOR n := 1 TO Len( aParams )
      cParam += ( aParams[ n ] + " " )
   NEXT n
   cParam := AllTrim( cParam )

   IF Upper( US_Word( cParam, 1 ) ) == "-VER" .or. Upper( US_Word( cParam, 1 ) ) == "-VERSION"
      hb_MemoWrit( "US_Slash.version", VERSION )
      RETURN
   ENDIF

   IF Upper( US_Word( cParam, 1 ) ) != "QPM"
      __Run( "ECHO " + "US_Slash 001E: Running Outside System" )
      RETURN
   ENDIF
   cParam := US_WordDel( cParam, 1 )

   IF Upper( SubStr( cParam, 1, 5 ) ) == "-LIST"
      bList := .T.
      cQPMDir := SubStr( US_Word( cParam, 1), 6 )
      IF ! Right( cQPMDir, 1 ) == "\"
         cQPMDir += "\"
      ENDIF
      cParam := AllTrim( SubStr( cParam, US_WordInd( cParam, 2 ) ) )
   ENDIF
   cFileIn := US_Word( cParam, US_Words( cParam ) - 1 )
   cFileOut := US_Word( cParam, US_Words( cParam ) )
   cFileOut := SubStr( cFileOut, 3 )
   cParam := AllTrim( SubStr( cParam, 1, US_WordInd( cParam, US_Words( cParam ) - 1 ) - 1 ) )

   IF bList
      QPM_Log( "------------ " + "US_Slash.version " + VERSION )
      QPM_Log( "US_Slash 002I: Log into:   " + cQPMDir + "QPM.log" )
      QPM_Log( "US_Slash 003I: FileIn:     " + cFileIn )
      QPM_Log( "US_Slash 004I: FileOut:    " + cFileOut )
      QPM_Log( "US_Slash 005I: Param:      " + cParam )
   ENDIF

   IF Upper( Right( cFileIn, 9 ) ) == 'SCRIPT.LD'
      hParam := FOpen( cFileIn )
      IF FError() = 0
         cFileIn  := ""
         cSearch  := ""
         cGroup   := "-Wl,--start-group "
         DO WHILE bLoop
            IF hb_FReadLine( hParam, @cLine, cFines ) != 0
               bLoop := .F.
            ENDIF
            cKey := US_Word( cLine, 1 )
            IF ! Empty( cKey )
               IF bList
                  QPM_Log( "US_Slash 006I: Script      " + cLine )
               ENDIF
               IF cKey == "INPUT("
                  cFileIn += US_Word( cLine, 2 ) + " "
               ELSEIF cKey == "SEARCH_DIR("
                  cSearch += "-L" + US_Word( cLine, 2 ) + " "
               ELSEIF cKey == "GROUP("
                  n := 2
                  DO WHILE .T.
                     cLib := US_Word( cLine, n )
                     IF Left( cLib, 2 ) # "-l"
                        EXIT
                     ENDIF
                     cGroup += cLib + " "
                     n ++
                  ENDDO
               ELSEIF cKey == "PATH("
                  cPath := US_Word( cLine, 2 )
               ELSEIF bList
                  QPM_Log( "US_Slash 007E: Bad key:    " + cKey )
               ENDIF
            ENDIF
         ENDDO
         FClose( hParam )
         cGroup += "-Wl,--end-group -static-libgcc "
      ELSE
         IF bList
            QPM_Log( "US_Slash 008E: Open error: " + cFileIn )
         ENDIF
         RETURN
      ENDIF
   ENDIF

   cLine := cFileIn + ' -o ' + cFileOut + ' ' + cSearch + cGroup + cParam + hb_osNewLine()
   cLine := StrTran( cLine, "\", "\\" )
   hb_MemoWrit( fparams, cLine )
   gcc_call := 'GCC.EXE @' + fparams

   IF bList
      QPM_Log( "US_Slash 009I: cFileIn:    " + cFileIn )
      QPM_Log( "US_Slash 010I: cFileOut:   " + cFileOut )
      QPM_Log( "US_Slash 011I: cSearch:    " + cSearch )
      QPM_Log( "US_Slash 012I: cGroup:     " + cGroup )
      QPM_Log( "US_Slash 013I: cParam:     " + cParam )
      QPM_Log( "US_Slash 014I: cPath:      " + cPath )
      QPM_Log( "US_Slash 015I: gcc_call:   " + gcc_call )
   ENDIF

   cmdbatch := hb_osNewLine() + ;
               "@echo off" + hb_osNewLine() + ;
               iif( empty( cPath ), "", "set PATH=" + cPath + hb_osNewLine() ) + ;
               gcc_call + hb_osNewLine() + ;
               "if errorlevel 1 goto bad" + hb_osNewLine() + ;
               "echo OK > " + fstatus + hb_osNewLine() + ;
               "goto exit" + hb_osNewLine() + ;
               ":bad" + hb_osNewLine() + ;
               "echo ERROR > " + fstatus + hb_osNewLine() + ;
               ":exit" + hb_osNewLine()
   hb_MemoWrit( fgccbat, cmdbatch )

   IF bList
      QPM_Log( "US_Slash 016I: INI Batch" )
      QPM_LOG( Left( cmdbatch, Len( cmdbatch ) - 2 ) )
      QPM_Log( "US_Slash 017I: END Batch" )
      QPM_Log( "US_Slash 018I: INI Param" )
      QPM_LOG( Left( cLine, Len( cLine ) - 2 ) )
      QPM_Log( "US_Slash 019I: END Param" )
   ENDIF

   __Run( fgccbat )
   FErase( fgccbat )

   IF MemoLine( MemoRead( fstatus ), 254, 1 ) = "ERROR"
      IF bList
         QPM_Log( "US_Slash 020I: Status:     ERROR" )
         QPM_Log( "------------" + CRLF )
      ENDIF
   ELSE
      IF bList
         QPM_Log( "US_Slash 021I: Status:     OK" )
         QPM_Log( "------------" + CRLF )
      ENDIF
   ENDIF
   FErase( fstatus )

   RETURN

//========================================================================
// RETORNA EL NOMBRE DE UN ARCHIVO INEXISTENTE
//========================================================================
FUNCTION US_FileTmp( prefix, suffix )
   LOCAL cFile

   IF Empty( prefix )
      prefix := "_temp"
   ENDIF
   IF Empty( suffix )
      suffix := ".tmp"
   ENDIF
   IF ! Left( suffix, 1 ) == "."
      suffix := "." + suffix
   ENDIF
   DO WHILE .T.
      cFile := prefix + US_NameRandom() + suffix
      IF ! File( cFile )
         EXIT
      ENDIF
   ENDDO

   RETURN cFile

//========================================================================
// RETORNA UN STRING A PARTIR DEL NÚMERO DE SEGUNDOS TRANSCURRIDOS
//========================================================================
FUNCTION US_NameRandom()

   RETURN AllTrim( StrTran( StrTran( Str( Seconds() ), ".", AllTrim( Str( US_Rand( Seconds() ) ) ) ), "-", "M" ) )

//========================================================================
// RETORNA UN STRING A PARTIR DEL NÚMERO DE SEGUNDOS TRANSCURRIDOS
//========================================================================
FUNCTION US_Rand( random )
   LOCAL negative, ttx, ttj, tty, ttk, ttl, ttz, tts, ttt, rett

   negative := ( random < 0 )
   IF random == 0
      RETURN 0
   ENDIF
   random := Abs( random )
   ttx := Seconds() / 100
   ttj := ( ttx - Int( ttx ) ) * 100
   tty := Log( Sqrt( Seconds() / 100 ) )
   ttk := ( tty - Int( tty ) ) * 100
   ttl := ttj * ttk
   ttz := ttl - Int( ttl )
   tts :=  random * ttz
   ttt :=  Round( tts, 2 )
   rett := Int( ttt ) + iif( Int( ttt ) + 1 < random + 1, 1, 0 )

   RETURN ( rett * iif( negative, -1, 1 ) )

//========================================================================
// EXTRAE UNA PALABRA DE UN STRING
//========================================================================
FUNCTION US_Word( estring, posicion )
   LOCAL cont := 1

   IF posicion == NIL
      posicion := 1
   ENDIF
   estring := AllTrim( estring )
   DO WHILE .T.
      IF AT( " ", estring ) == 0
         RETURN iif( posicion == cont, estring, "" )
      ELSEIF cont == posicion
         RETURN SubStr( estring, 1, At( " ", estring ) - 1 )
      ENDIF
      estring := AllTrim( SubStr( estring, At( " ", estring ) + 1 ) )
      cont ++
   ENDDO

   RETURN ""

//========================================================================
// ELIMINAR UNA PALABRA DE UN STRING
//========================================================================
FUNCTION US_WordDel( estring, posicion )

   RETURN iif( posicion > 0, ;
               AllTrim( SubStr( estring, 1, US_WordInd( estring, posicion ) - 1 ) + ;
                        StrTran( SubStr( estring, US_WordInd( estring, posicion ) ), US_Word( estring, posicion ), " ", 1, 1 ) ), ;
               estring )

//========================================================================
// RETORNA LA POSICION DONDE EMPIEZA LA PALABRA numero
//========================================================================
FUNCTION US_WordInd( estring, numero )
   LOCAL cont, estr, estr2

   IF estring == NIL
      estring := ""
   ENDIF
   IF US_Words( estring ) < numero
      RETURN ( Len( estring ) + 1 )
   ENDIF
   cont := 1
   estr := estring
   estr2 := RTrim( estring )
   estring := AllTrim( estring )
   DO WHILE .T.
      IF At( " ", estring ) == 0
         RETURN iif( numero == cont, Len( estr ) - ( Len( estring ) + ( Len( estr ) - Len( estr2 ) ) ) + 1, 0 )
      ELSEIF cont == numero
         RETURN ( Len( estr ) - ( Len( estring ) + ( Len( estr ) - Len( estr2 ) ) ) + 1 )
      ENDIF
      estring := AllTrim( SubStr( estring, At( " ", estring ) + 1 ) )
      cont ++
   ENDDO

   RETURN 0

//========================================================================
// CUENTA LAS PALABRAS EN UN STRING
//========================================================================
FUNCTION US_Words( estring )
   LOCAL cont := 0

   IF estring == NIL
      estring := ""
   ENDIF
   estring := AllTrim( estring)
   DO WHILE .T.
      IF At( " ", estring ) == 0
         RETURN iif( Len( estring ) > 0, cont + 1, cont )
      ENDIF
      estring := AllTrim( SubStr( estring, At( " ", estring ) + 1 ) )
      cont ++
   ENDDO

   RETURN 0

//========================================================================
// ESCRIBE EN EL LOG
//========================================================================
STATIC FUNCTION QPM_Log( string )
   LOCAL LogArchi := cQPMDir + "QPM.LOG"
   LOCAL msg := DToS( Date() ) + " " + Time() + " US_SLASH " + ProcName( 1 ) + "(" + Str( ProcLine( 1 ), 3, 0 ) + ")" + " " + string

   SET CONSOLE OFF
   SET ALTERNATE TO ( LogArchi ) ADDITIVE
   SET ALTERNATE ON
   ? msg
   SET ALTERNATE OFF
   SET ALTERNATE TO
   SET CONSOLE ON

   RETURN .T.

/* eof */
