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
#define VERSION  "01.06"

FUNCTION MAIN( ... )
   LOCAL aParams := hb_AParams(), n, i
   LOCAL bLoop := .T., cLinea, cFines := { Chr(13) + Chr(10), Chr(10) }, hFiIn, cont := 0, hFiOut
   LOCAL cFileOut, nBytesSalida := 0, cFileIn, cParam, cFileTMP, cmd, cmdbat, bList := .F.
   LOCAL fgccbat := US_FileTmp( NIL, ".bat" )
   LOCAL fstatus := US_FileTmp()

   PRIVATE cQPMDir := ""

   cParam := ""
   FOR n := 1 TO Len( aParams )
      cParam += ( aParams[ n ] + " " )
   NEXT n
   cParam := AllTrim( cParam )

   IF Upper( US_Word( cParam, 1 ) ) == "-VER" .or. Upper( US_Word( cParam, 1 ) ) == "-VERSION"
      MemoWrit( "US_Slash.version", VERSION )
      RETURN .T.
   ENDIF

   IF Upper( US_Word( cParam, 1 ) ) != "QPM"
      __Run( "ECHO " + "US_Slash 999E: Running Outside System" )
      ErrorLevel( 1 )
      RETURN -1
   ELSE
      cParam := US_WordDel( cParam, 1 )
   ENDIF

   IF Upper( SubStr( cParam, 1, 5 ) ) == "-LIST"
      bList := .T.
      cQPMDir := SubStr( US_Word( cParam, 1 ), 6 ) + "\"
      cParam := AllTrim( SubStr( cParam, US_WordInd( cParam, 2 ) ) )
   ENDIF
   cFileIn := US_Word( cParam, US_Words( cParam ) - 1 )
   cFileOut := US_Word( cParam, US_Words( cParam ) )
   cFileOut := SubStr( cFileOut, 3 )
   cFileTMP := SubStr( cFileIn, 1, RAt( ".", cFileIn ) ) + "CUS"
   cParam := AllTrim( SubStr( cParam, 1, US_WordInd( cParam, US_Words( cParam ) - 1 ) - 1 ) )

   IF bList
      QPM_Log( "US_Slash " + VERSION )
      QPM_Log( "Slash 000I: by QPM_Support ( https://teamqpm.github.io/ )" )
      QPM_Log( "Slash 999I: Log into: " + cQPMDir + "QPM.log" )
      QPM_Log( "Slash 003I: FileIn:   " + cFileIn )
      QPM_Log( "Slash 013I: FileOut:  " + cFileOut )
      QPM_Log( "Slash 023I: FileTMP:  " + cFileTMP )
      QPM_Log( "Slash 033I: Param:    " + cParam )
   ENDIF

   hFiIn := FOpen( cFileIn )
   IF FError() = 0
      IF ( hFiOut := FCreate( cFileTMP ) ) == -1
         FClose( hFiIn )
         QPM_Log( "Slash 011E: Error in creation of File Out (" + AllTrim( Str( FError() ) ) + ") " + cFileOut + hb_osNewLine() )
         RETURN 12
      ENDIF

      DO WHILE bLoop
         IF hb_FReadLine( hFiIn, @cLinea, cFines ) != 0
            bLoop := .F.
         ENDIF
         cont ++
         IF SubStr( cLinea, 1, 6 ) == "#line " .AND. ;
            US_Words( cLinea ) > 2 .AND. ;
            IsDigit( US_Word( cLinea, 2 ) ) = .T.
            IF bList
               QPM_Log( "Slash 004I: Old (" + PadL( AllTrim( Str( cont ) ), 8 ) + ") " + cLinea )
            ENDIF
            cLinea := StrTran( cLinea, '\', "\\" )
            IF bList
               QPM_Log( "Slash 005I: New (" + PadL( AllTrim( Str( cont ) ), 8 ) + ") " + cLinea )
            ENDIF
         ENDIF
         cLinea := cLinea + hb_osNewLine()
         nBytesSalida := Len( cLinea )
         IF FWrite( hFiOut, cLinea, nBytesSalida ) < nBytesSalida
            FClose( hFiIn )
            QPM_Log( "Slash 012E: Error in save into Out File (" + AllTrim( Str( FError() ) ) + ") " + cFileOut + hb_osNewLine() )
            RETURN 16
         ENDIF
      ENDDO

      FClose( hFiIn )
      FClose( hFiOut )
   ELSE
      QPM_Log( "Slash 001E: Error open Input File " + cFileIn + hb_osNewLine() )
      RETURN 8
   ENDIF

   FErase( cFileIn + ".temporal" )
   FRename( cFileIn, cFileIn + ".temporal" )
   FRename( cFileTMP, cFileIn )

   cmdbat := "GCC.EXE " + cParam + ' "' + cFileIn + '" -o "' + cFileOut + '"'
   cmd := "@echo off" + hb_osNewLine() + ;
        cmdbat + hb_osNewLine() + ;
        "If errorlevel 1 goto bad" + hb_osNewLine() + ;
        "Echo OK > " + fstatus + hb_osNewLine() + ;
        "goto good" + hb_osNewLine() + ;
        ":bad" + hb_osNewLine() + ;
        "Echo ERROR > " + fstatus + hb_osNewLine() + ;
        ":good" + hb_osNewLine()
   MemoWrit( fgccbat, cmd )
   IF bList
      QPM_Log( "Slash 043I: Command: " + cmdbat )
   ENDIF
   __Run( fgccbat )

   FRename( cFileIn, cFileTMP )
   FRename( cFileIn + ".temporal", cFileIn )

   IF MemoLine( MemoRead( fstatus ), 254, 1 ) = "ERROR"
      ErrorLevel( 1 )
   ENDIF
   FErase( fgccbat )
   FErase( fstatus )
   IF bList
      QPM_Log( "" )
   ENDIF

   RETURN .T.

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
         RETURN SubStr( estring, 1, AT( " ", estring ) - 1 )
      ENDIF
      estring := AllTrim( SubStr( estring, AT( " ", estring ) + 1 ) )
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
   LOCAL msg := DToS( Date() ) + " " + Time() + " US_SLASH " + ProcName( 1 ) + "(" + AllTrim( Str( ProcLine( 1 ) ) ) + ")" + " " + string

   SET CONSOLE OFF
   SET ALTERNATE TO ( LogArchi ) ADDITIVE
   SET ALTERNATE ON
   ? msg
   SET ALTERNATE OFF
   SET ALTERNATE TO
   SET CONSOLE ON

   RETURN .T.

/* eof */
