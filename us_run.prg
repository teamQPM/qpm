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
#include "fileio.ch"

// For error codes see: http://msdn2.microsoft.com/en-us/library/ms681382(VS.85).aspx

#define VERSION "01.04"
MEMVAR cQPMDir

FUNCTION MAIN( ... )
   LOCAL aParams := hb_aParams()
   LOCAL n, bList := .F., bOk := .F., nLineSize := 1024, cParam, MemoAux := "", i, cLineaAux := ""
   PRIVATE cCMD := "", cControlFile := "", cDefaultPath := "", cCurrentPath, cMode := "NORMAL", cQPMDir := ""

   cParam := ""
   FOR n := 1 TO Len( aParams )
      cParam += ( aParams[ n ] + " " )
   NEXT n
   cParam := AllTrim( cParam )

   IF Upper( US_Word( cParam, 1 ) ) == "-VER" .or. Upper( US_Word( cParam, 1 ) ) == "-VERSION"
      hb_MemoWrit( "US_Run.version", VERSION )
      ErrorLevel( 0 )
      RETURN .T.
   ENDIF

   IF Upper( US_Word( cParam, 1 ) ) != "QPM"
      __Run( "ECHO " + "US_Res 001E: Running Outside System" )
      ErrorLevel( 1 )
      RETURN .F.
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

   IF bList
      QPM_Log( "------------ " + "US_Run.version " + VERSION )
   ENDIF

   IF Empty( cParam )
      IF bList
         QPM_Log( "US_Run 002E: Missing Parameters" )
      ENDIF
      ErrorLevel( 1 )
      RETURN .F.
   ENDIF

   IF ! File( cParam )
      IF bList
         QPM_Log( "US_Run 003E: Parameters File Not Found: " + cParam )
      ENDIF
      ErrorLevel( 1 )
      RETURN .F.
   ENDIF

   MemoAux := MemoRead( cParam )
   FOR i := 1 TO MLCount( MemoAux, nLineSize )
      cLineaAux := AllTrim( MemoLine( MemoAux, nLineSize, i ) )
      IF Upper( US_Word( cLineaAux, 1 ) ) == "COMMAND"
         cCMD := US_WordSubStr( cLineaAux, 2 )
      ENDIF
      IF Upper( US_Word( cLineaAux, 1 ) ) == "CONTROL"
         cControlFile := US_WordSubStr( cLineaAux, 2 )
      ENDIF
      IF Upper( US_Word( cLineaAux, 1 ) ) == "DEFAULTPATH"
         cDefaultPath := US_WordSubStr( cLineaAux, 2 )
      ENDIF
      IF Upper( US_Word( cLineaAux, 1 ) ) == "MODE"
         cMode := US_WordSubStr( cLineaAux, 2 )
      ENDIF
   NEXT i
   FErase( cParam )
   IF bList
      QPM_Log( "US_Run 004I: COMMAND = " + cCMD )
      QPM_Log( "US_Run 005I: CONTROL = " + cControlFile )
      QPM_Log( "US_Run 006I: DEFPATH = " + cDefaultPath )
      QPM_Log( "US_Run 007I: RUNMODE = " + cMode )
   ENDIF

   DEFINE WINDOW VentanaMain ;
      AT 0, 0 ;
      WIDTH GetDesktopWidth() ;
      HEIGHT GetDesktopHeight() ;
      TITLE '' ;
      MAIN ;
      ICON "DOS" ;
      NOSHOW ;
      ON INIT ( bok := US_RunInit( bList ) )
   END WINDOW

   ACTIVATE WINDOW VentanaMain

   IF bOk
      IF bList
         QPM_Log( "US_Run 008I: Ended OK" )
      ENDIF
   ELSE
      IF bList
         QPM_Log( "US_Run 009E: Ended with ERROR" )
      ENDIF
      ErrorLevel( 1 )
   ENDIF

   RETURN bOk

//========================================================================
FUNCTION US_RunInit( bList )
   LOCAL Reto, nHandle, bOk := .T.

   DO EVENTS
   nHandle := FOpen( cControlFile, FO_WRITE + FO_EXCLUSIVE )
   IF FError() == 0
      IF ! Empty( cDefaultPath )
         cCurrentPath := GetCurrentFolder()
         SetCurrentFolder( cDefaultPath )
      ENDIF
      IF bList
         QPM_Log( "US_Run 010I: current folder is " + GetCurrentFolder() )
      ENDIF
      DO EVENTS
      DO CASE
      CASE cMode == "HIDE"
         Reto := WaitRun( cCMD, 0 )            // EXECUTE FILE ( cCMD ) WAIT HIDE
      CASE cMode == "MINIMIZE"
         Reto := WaitRun( cCMD, 6 )            // EXECUTE FILE ( cCMD ) WAIT MINIMIZE
      CASE cMode == "MAXIMIZE"
         Reto := WaitRun( cCMD, 3 )            // EXECUTE FILE ( cCMD ) WAIT MAXIMIZE
      OTHERWISE
         Reto := WaitRun( cCMD, 5 )            // EXECUTE FILE ( cCMD ) WAIT
      ENDCASE
      IF bList
         QPM_Log( "US_Run 011I: WaitRun returned " + US_VarToStr( Reto ) )
      ENDIF
      IF ! Empty( cDefaultPath )
         SetCurrentFolder( cCurrentPath )
      ENDIF
      DO EVENTS
      IF Reto > 8
         IF bList
            QPM_Log( "US_Run 012E: Error Running: " + cCMD + HB_OsNewLine() + "Code: " + US_VarToStr( Reto ) )
         ENDIF
         bOk := .F.
      ENDIF
      FClose( nHandle )
   ELSE
      IF bList
         QPM_Log( "US_Run 013E: error opening control file." )
      ENDIF
      bOk := .F.
   ENDIF
   FErase( cControlFile )
   DO EVENTS
   VentanaMain.Release()

   RETURN bOk

//========================================================================
// FUNCION PARA EXTRAER UNA PALABRA DE UN ESTRING
//========================================================================
FUNCTION US_WORD(ESTRING, POSICION)
   LOCAL CONT := 1

   IF Posicion == NIL
      Posicion := 1
   ENDIF
   ESTRING := AllTrim( ESTRING )
   DO WHILE .T.
      IF At( " ", ESTRING ) != 0
         IF CONT == POSICION
            RETURN SubStr( ESTRING, 1, At( " ", ESTRING ) - 1 )
         ELSE
            ESTRING := AllTrim( SubStr( ESTRING, At( " ", ESTRING ) + 1 ) )
            CONT ++
         ENDIF
      ELSE
         IF POSICION == CONT
            RETURN ESTRING
         ELSE
            EXIT
         ENDIF
      ENDIF
   ENDDO

   RETURN ""

//========================================================================
// FUNCION PARA ELIMINAR UNA PALABRA DE UN STRING
//========================================================================
FUNCTION US_WordDel( ESTRING, POSICION )
   LOCAL cRet

   IF POSICION > 0
      cRet := AllTrim( SubStr( ESTRING, 1, US_WordInd( ESTRING, POSICION ) - 1 ) + ;
                       StrTran( SubStr( ESTRING, US_WordInd( ESTRING, POSICION ) ), US_Word( ESTRING, POSICION ), " ", 1, 1 ) )
   ELSE
      cRet := ESTRING
   ENDIF

   RETURN cRet

//========================================================================
// FUNCION PARA SABER LA POSICION DE LA PALABRA NUMERO ....
// ESTA FUNCION RETORNA EL BYTE DONDE EMPIEZA LA PALABRA
//========================================================================
FUNCTION US_WordInd( ESTRING, POSICION )
   LOCAL CONT, ESTR, ESTR2

   IF ESTRING == NIL
      ESTRING := ""
   ENDIF
   IF US_Words( Estring ) < Posicion
      RETURN ( Len( Estring ) + 1 )
   ENDIF
   CONT := 1
   ESTR := ESTRING
   ESTR2 := RTrim( ESTRING )
   ESTRING := AllTrim( ESTRING )
   DO WHILE .T.
      IF At(" ",ESTRING) != 0
         IF CONT == POSICION
            RETURN ( Len( ESTR ) - ( Len( ESTRING ) + ( Len( ESTR ) - Len( ESTR2 ) ) ) + 1 )
         ELSE
            ESTRING := AllTrim( SubStr( ESTRING, At( " ", ESTRING ) + 1 ) )
            CONT ++
         ENDIF
      ELSE
         IF POSICION == CONT
            RETURN ( Len( ESTR ) - ( Len( ESTRING ) + ( Len( ESTR ) - Len( ESTR2 ) ) ) + 1 )
         ELSE
            RETURN 0
         ENDIF
      ENDIF
   ENDDO

   RETURN 0

//========================================================================
// FUNCION PARA retornar un substr a partir de la posicion de una palabra
//========================================================================
FUNCTION US_WordSubstr( estring, pos )

   IF Estring == NIL
      Estring := ""
   ENDIF

   RETURN SubStr( estring, US_WordInd( estring, pos ) )

//========================================================================
// FUNCION PARA CONTAR LAS PALABRAS EN UN ESTRING
//========================================================================
FUNCTION US_WORDS( ESTRING )
   LOCAL CONT := 0

   IF Estring == NIL
      Estring := ""
   ENDIF
   ESTRING := AllTrim( ESTRING )
   DO WHILE .T.
      IF At( " ", ESTRING ) != 0
         ESTRING := AllTrim( SubStr( ESTRING, At( " ", ESTRING ) + 1 ) )
         CONT++
      ELSE
         IF Len( ESTRING ) > 0
            RETURN CONT + 1
         ELSE
            RETURN CONT
         ENDIF
      ENDIF
   ENDDO

   RETURN 0

//========================================================================
FUNCTION US_VarToStr(X)
   LOCAL T, StringAux:="", i

   IF X == NIL
      X := "*NIL*"
   ENDIF
   T := ValType( X )
   DO CASE
   CASE T = 'C'
      RETURN X
   CASE T = 'O'
      RETURN "*OBJ*"
   CASE T = 'U'
      RETURN "*UND*"
   CASE T = 'M'
      RETURN X
   CASE T = 'D'
      StringAux=DToS(X)
      RETURN StringAux
   CASE T = 'N'
      StringAux := US_STRCERO( X )
      RETURN StringAux
   CASE T = 'L'
      StringAux := iif( X, '.T.', '.F.' )
      RETURN StringAux
   CASE T = 'A'
      FOR i := 1 TO Len( X ) - 1
         StringAux := StringAux + US_VarToStr( X[ i ] ) + hb_osNewLine()
      NEXT
      IF Len( X ) > 0
         StringAux := StringAux + US_VarToStr( X[ Len( X ) ] )
      ENDIF
      RETURN StringAux
   ENDCASE

   RETURN ""

//========================================================================
FUNCTION US_StrCero(NUM,LONG,DEC)
   LOCAL INDICIO

   IF DEC=NIL
      IF LONG=NIL
         NUM=STR(NUM)
      ELSE
         NUM=STR(NUM,LONG)
      ENDIF
   ELSE
      NUM=STR(NUM,LONG,DEC)
   ENDIF
   LONG=Len(NUM)
   FOR INDICIO := 1 TO LONG
      IF SubStr( NUM, INDICIO, 1 ) == " "
         NUM := Stuff( NUM, INDICIO, 1, "0" )
      ENDIF
   NEXT

   RETURN NUM

//========================================================================
// ESCRIBE EN EL LOG
//========================================================================
STATIC FUNCTION QPM_Log( string )
   LOCAL LogArchi := cQPMDir + "QPM.LOG"
   LOCAL msg := DToS( Date() ) + " " + Time() + " US_RUN " + ProcName( 1 ) + "(" + Str( ProcLine( 1 ), 3, 0 ) + ")" + " " + string

   SET CONSOLE OFF
   SET ALTERNATE TO ( LogArchi ) ADDITIVE
   SET ALTERNATE ON
   ? msg
   SET ALTERNATE OFF
   SET ALTERNATE TO
   SET CONSOLE ON

   RETURN .T.

/* eof */
