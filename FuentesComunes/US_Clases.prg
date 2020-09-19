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

#include "US_Env.h"
#include "hbclass.ch"
#include "minigui.ch"

#define US_GREEN   { 74,136,101}
#define US_RED     {192, 63, 39}
#define US_BLUE    { 45, 24,160}
#define US_CYAN    {188,219,240}
#define US_YELLOW  {219,215, 43}
#define US_BROWN   {139,106, 29}
#define US_BLACK   {  0,  0,  0}
#define US_WHITE   {255,255,255}
#define US_GREY    {192,192,192}

/*

//==================================================================================\\
//= CLASE US_RTF                                                                   =\\
//----------------------------------------------------------------------------------\\

CLASS US_RTF

   METHOD New()                                  && Crear el Objeto
   METHOD Destroy()                              && Destruir el Objeto
   METHOD Init( str )                            && Carga Inicial del Objeto
   METHOD Get()                                  && Lee el archivo
   METHOD Put( str )                             && Agrega un string al archivo

   DATA cMemo         HIDDEN              init ""             && Archivo para procesar
   DATA cHeader       HIDDEN              init "{"+ ;
                                               "\rtf1\ansi\ansicpg1252\deff0\deflang1033"+ ;
                                               "{"+ ;
                                               "\fonttbl{\f0\fswiss\fcharset0 Arial;"+ ;
                                               "}"+ ;
                                               "}"+ ;
                                               "{"+ ;
                                               "\colortbl ;"+ ;
                                                  "\red0\green0\blue0;"+ ;             && negro
                                                  "\red255\green0\blue0;"+ ;           && rojo
                                                  "\red0\green0\blue255;"+ ;           && azul
                                                  "\red0\green128\blue0;"+ ;           && verde
                                                  "\red255\green255\blue0;"+ ;         && amarillo
                                                  "\red255\green255\blue255;"+ ;       && blanco
                                               "}"+ ;
                                               "\pard\plain\f2\fs20 "
   DATA cFooter       HIDDEN              init "\par}"
// DATA cFile         EXPORTED            init NIL            && Archivo para procesar
ENDCLASS

METHOD New() CLASS US_RTF
return Self

METHOD Destroy() CLASS US_RTF
return NIL

METHOD Init( str ) CLASS US_RTF
   do case
      case empty(str)
         ::cMemo := ::cHeader
      case lower( substr( str , 1 , 7 ) ) == "{\rtf1\"
         ::cMemo := str
      otherwise
         ::cMemo := ::cHeader + STRTRAN(str,HB_OSNewLine(),"\cf0\par ")
   endcase
return NIL

METHOD Get() CLASS US_RTF
return ::cMemo

METHOD Put(str) CLASS US_RTF
   ::cMemo := ::cMemo + STRTRAN(str,HB_OSNewLine(),"\cf0\par ")
return NIL

//----------------------------------------------------------------------------------\\
//= END CLASE US_RTF                                                               =\\
//==================================================================================\\

//==================================================================================\\
//= CLASE US_Media                                                                 =\\
//= Esta clase sirve para brindar informacion completa sobre un archivo de medios  =\\
//= Llama a las diferentes clases de los diferentes tipos que medios que maneja    =\\
//= Es generalmente llamada por el reproductorentes US_Player (Clase US_Player)    =\\
//----------------------------------------------------------------------------------\\

CLASS US_Media

   METHOD New()                                  && Crear el Objeto
   METHOD Destroy()                              && Destruir el Objeto
   METHOD SetFile( filename )                    && Asigna archivo
   METHOD FreeFile()                             && lebera el archivo
   METHOD GetFullFileName()                      && nombre del archivo completo
   METHOD GetFileName()                          && nombre del archivo sin extension ni path
   METHOD GetFileExt()                           && Extension del archivo
   METHOD GetFilePath()                          && Path del archivo
   METHOD GetFileDisc()                          && Disco del archivo
   METHOD GetFileSize()                          && Tamaño del archivo en Bytes

   METHOD GetFileType()                          && Tipo de Archivo multimedia
   METHOD GetFileLength()                        && Duracion del medio en segundos
   METHOD GetFileMilLength()                     && Duracion del medio en milisegundos

   METHOD GetLastError()                         && String con el error o ""
   METHOD GetReturnCode()                        && Numero de Error o CERO

   DATA cFile         HIDDEN               init NIL            && Archivo para procesar
   DATA cMsg10        HIDDEN               init "Archivo no se encuentra o no puede ser accedido: "
   DATA cMsg20        HIDDEN               init "Tipo de archivo no contemplado: "
   DATA oMedio        HIDDEN               init NIL            && objeto asociado al tipo de file
   DATA cError        HIDDEN               init ""             && Last Error
   DATA nReto         HIDDEN               init 0              && Codigo de retorno
// DATA cFile         EXPORTED            init NIL            && Archivo para procesar
ENDCLASS

METHOD New() CLASS US_Media
   US_Log( , .F. )
return Self

METHOD Destroy() CLASS US_Media
   US_Log( , .F. )
return NIL

METHOD GetLastError() CLASS US_Media
return ::cError

METHOD GetReturnCode() CLASS US_Media
return ::nReto

METHOD SetFile( file ) CLASS US_Media
   US_Log( file , .F. )
   ::cFile := file
   if !file( ::cFile )
      ::nReto  := -22
      ::cError := ::cMsg10 + ::cFile       && file no found
      US_Log( cError , .F. )
      Return ::nReto
   endif
   do case
      case ::GetFileType() = "MP3"
         ::oMedio := US_MP3():New()
         ::oMedio:nFila := US_PorScreenAlto( 70 )
         ::nReto  := ::oMedio:OpenFile( ::cFile )
         ::cError := ::oMedio:GetLastError()
         Return ::nReto
//    case ::GetFileType() = "WAV"
//       ::oMedio := US_WAV():New()
//       ::oMedio:nFila := US_PorScreenAlto( 70 )
//       ::nReto  := ::oMedio:OpenFile( ::cFile )
//       ::cError := ::oMedio:GetLastError()
//       Return ::nReto
      otherwise
         ::nReto  := -21
         ::cError := ( ::cMsg20 + ::GetFileType() )   && file type no contemplado
         US_Log( ::cError , .F. )
         Return ::nReto
   endcase
return 0

METHOD FreeFile() CLASS US_Media
   US_Log( , .F. )
   ::cFile := ""
return 0

METHOD GetFullFileName() CLASS US_Media
   US_Log( , .F. )
return ::cFile

METHOD GetFileName() CLASS US_Media
   US_Log( , .F. )
return substr( ::cFile , rat( DEF_SLASH , ::cFile ) + 1 , rat( "." , ::cFile ) - ( rat( DEF_SLASH , ::cFile ) + 1 ) )

METHOD GetFileExt() CLASS US_Media
   US_Log( , .F. )
return substr( ::cFile , rat( "." , ::cFile ) + 1 )

METHOD GetFilePath() CLASS US_Media
   US_Log( , .F. )
return substr( ::cFile , 3 , rat( DEF_SLASH , ::cFile ) - 2 )

METHOD GetFileDisc() CLASS US_Media
   US_Log( , .F. )
return substr( ::cFile , 1 , 1 )

METHOD GetFileSize() CLASS US_Media
   US_Log( , .F. )
return US_FileSize( ::cFile )

METHOD GetFileType() CLASS US_Media
   Local ext := UPPER( ::GetFileExt() )
// US_Log( , .F. )
   do case
      case ext = "XXX"
         Return "XXX"
   endcase
return ext

METHOD GetFileLength() CLASS US_Media
// US_Log( , .F. )
return ::oMedio:GetLength()

METHOD GetFileMilLength() CLASS US_Media
// US_Log( , .F. )
return ::oMedio:GetMilLength()

//----------------------------------------------------------------------------------\\
//= END CLASE US_Media                                                             =\\
//==================================================================================\\

//==================================================================================\\
//= CLASE US_Player                                                                =\\
//----------------------------------------------------------------------------------\\

// CLASS US_Player INHERIT US_Media
CLASS US_Player

   METHOD New()                                  && Crear el Objeto
   METHOD Create( Ventana )                      && Crear el control en una determinada ventana
   METHOD Destroy()                              && Destruir el Objeto
   METHOD Play()                                 && Comenzar la Reproduccion del Medio
   METHOD PlayRev()                              && Comenzar la Reproduccion del Medio para atrás
   METHOD Stop()                                 && Detener  la Reproduccion del Medio
   METHOD Pause()                                && Pausar   la Reproduccion del Medio
   METHOD Resume()                               && Continua reproduccion luego de Pausa
   METHOD Prev()                                 && Retroceder al Medio Anterior
   METHOD Next()                                 && Avanzar al proximo Medio
   METHOD First()                                && Ir al Primer Medio
   METHOD Last()                                 && Ir al Ultimo Medio
   METHOD Forward()                              && Avanzar en el medio actual
   METHOD Rewind()                               && Retroceder en el medio actual
   METHOD Add( cFile )                           && Agrega Medio a la Lista de Reproduccion
   METHOD GetVolume()                            && 0 a 1000
   METHOD SetVolume( nVol )                      && nVol de 0 a 1000
   METHOD SetPlayIndex( nItem )                  && Establece el medio a reproducir, es la posicion en el vector
   METHOD GetPlayIndex()                         && Retorna el medio en reproducir, es la posicion en el vector
   METHOD GetTeclas()                            && Devuelve un vector con booleanos para activar o desactivar las teclas de control de reproduccion
   METHOD ShowPlayList()                         && Muestra la ventana de PlayList
   METHOD GetPlayList()                          && Devuelve un vector con los temas encolados en la lista de reproduccion
   METHOD GetPlayListLength()                    && Devuelve la cantidad de archivos en la current list
   METHOD GetPlayListFullFileName( inx )         && Devuelve el nombre del elemento de la lista (con path y extension)
   METHOD GetPlayListFileName( inx )             && Devuelve el nombre del elemento de la lista
   METHOD GetCurrentPlayFullFileName()           && Devuelve el nombre del archivo posicionado dentro de la lista (con path y extension)
   METHOD GetCurrentPlayFileName()               && Devuelve el nombre del archivo posicionado dentro de la lista
   METHOD Remove( nItem )                        && Remove Medio de la Lista de Reproduccion
   METHOD RemoveAll()                            && Limpia la lista de reproducción
   METHOD GetCurrentPlayMode()                   && Devuelve 0, -1 o 1 segun se este haciendo play o no.
   METHOD GetCurrentPlaySec()                    && Devuelve el tiempo transcurrido de reproduccion de medio actual en segundos
   METHOD SetCurrentPlaySec( nSeconds )          && Establece el tiempo transcurrido de reproduccion de medio actual en segundos
   METHOD GetCurrentPlayMilSec()                 && Devuelve el tiempo transcurrido de reproduccion de medio actual en milesegundos
   METHOD GetCurrentPlayLength()                 && Devuelve la duracion del Medio que esta reproduciendo en segundos
   METHOD GetCurrentPlayMilLength()              && Devuelve la duracion del Medio que esta reproduciendo en milisegundos
   METHOD GetCurrentFileSize()                   && Devuelve el tamaño del Medio que esta reproduciendo
   METHOD GetCurrentHilite()                     && Devuelve el nombre del medio que se esta posicionado
   METHOD GetCurrentHiliteInx()                  && Devuelve el indice dentro de la lista del Medio que esta posicionado
   METHOD GetCurrentHiliteLength()               && Devuelve la duracion del Medio que esta posicionado
   METHOD GetCurrentHiliteSize()                 && Devuelve el Tamaño del Medio que esta posicionado
   METHOD GetMute()                              && Este metodo solo devuelve el valor del boolen bMute, que es controlado desde el programa que usa la clase
   METHOD GetPaused()                            && Este metodo solo devuelve el valor del boolen bPaused
   METHOD SetMute( bool )                        && Este metodo solo establece el valor del boolen bMute, que es controlado desde el programa que usa la clase
   //
   METHOD LoadPlayList()                HIDDEN   && Carga la ventana de PlayList
   METHOD PlayerListRefresh()           HIDDEN   && Refresca la player list en navegacion
   METHOD PlayerListToolTip()           HIDDEN   && Establece el valor de ToolTip para play list
   METHOD PlayerListDBLClick()          HIDDEN   && Acciones ante DobleClick en el playlist
   METHOD TimerPlayer()                 HIDDEN   && Controla la finalizacion de la reproducción

   DATA US_PlayerPan   HIDDEN              init "US_Play"+US_NameRandom()
   DATA vLista         HIDDEN              init {}             && Lista de Reproduccion
   DATA voMedios       HIDDEN              init {}             && Vector con objetos de medios de reproduccion
   DATA nIndex         HIDDEN              init 0              && Indice dentro de la lista de reproduccion
   DATA cControl       HIDDEN              init "US_oMedia"+US_NameRandom()
   DATA Reto           HIDDEN              init 0              && Código de retorno
   DATA bPaused        HIDDEN              init .F.            && Booleano para pausa
   DATA nPlayMode      HIDDEN              init 0              && Tipo de Reproduccion: 0 stop, 1 play, -1 playRev
   DATA nLastPrevPress HIDDEN              init Seconds()      && Control para la tecla Prev
   DATA nPlayVolume    HIDDEN              init 300            && Volumen inicial
   DATA PL_Window      HIDDEN              init "US_PL"+US_NameRandom()
   DATA PL_Title       HIDDEN              init "Lista de Reproducción"
   DATA bIsPlayListActive HIDDEN           init .F.
   DATA bMute          HIDDEN              init .F.            && esta bool actua como GLOBAL para todos los pgm que utilizan el objeto de esta clase, el mute es controlado desde los prg
   DATA nMilLengthControl HIDDEN           init 0              && Longitud segun el control play, es auxiliar para hacer auto stop en archivos defectuosos (milisegundos)
   //                                              1     2     3     4     5     6     7     8     9    10    11
   DATA vButtons       HIDDEN              init { .F. , .F. , .F. , .F. , .F. , .F. , .F. , .F. , .F. , .F. , .F.}
   DATA bButtonFirst   HIDDEN              init 1
   DATA bButtonPrev    HIDDEN              init 2
   DATA bButtonRewind  HIDDEN              init 3
   DATA bButtonPlayR   HIDDEN              init 4         && Play Reverse
   DATA bButtonPlay    HIDDEN              init 5
   DATA bButtonPause   HIDDEN              init 6
   DATA bButtonStop    HIDDEN              init 7
   DATA bButtonForward HIDDEN              init 8
   DATA bButtonNext    HIDDEN              init 9
   DATA bButtonLast    HIDDEN              init 10
   DATA bButtonOpen    HIDDEN              init 11
   DATA cSkin          EXPORTED            init NIL            && Skins disponibles: NULO o "VP"
   DATA SecondsSeek    EXPORTED            init 10             && Segundos de incremento en forward
   DATA PL_BackColor   EXPORTED            init US_CYAN        && Color de Fondo de PlayList
   DATA PL_FontColor   EXPORTED            init US_BLUE        && Color de Texto de PlayList
ENDCLASS

METHOD New() CLASS US_Player
   US_Log( , .F. )
return Self

METHOD Create( Ventana ) CLASS US_Player
   US_Log( , .F. )
   ::US_PlayerPan := Ventana
   @ 0, 0 PLAYER &(::cControl) OF &(::US_PlayerPan) ;
        WIDTH 0 ;
        HEIGHT 0 ;
        FILE "" ;
        NOMENU ;
        NOPLAYBAR

   SET PLAYER &( ::cControl ) OF &( ::US_PlayerPan ) VOLUME ::nPlayVolume

   DEFINE TIMER TimerTime OF ::US_PlayerPan ;
      INTERVAL  250 ;     && 1000 ciclos=1 segundo
      ACTION if( ::nPlayMode != 0 , ::TimerPlayer() , )

return Self

METHOD Destroy() CLASS US_Player
   US_Log( , .F. )
   ::Stop()
return NIL

METHOD GetMute() CLASS US_Player
return ::bMute

METHOD GetPaused() CLASS US_Player
return ::bPaused

METHOD SetMute( bool ) CLASS US_Player
   ::bMute := bool
return NIL

METHOD GetPlayIndex() CLASS US_Player
   US_Log( , .F. )
return ::nIndex

METHOD SetPlayIndex( nInx ) CLASS US_Player
   US_Log( , .F. )
   ::nIndex := nInx
   do case
      case ::nPlayMode = 0
         ::vButtons[::bButtonFirst]  := if( ::nIndex > 1 , .T. , .F. )
         ::vButtons[::bButtonPrev]   := if( ::nIndex > 1 , .T. , .F. )
         ::vButtons[::bButtonRewind] := .F.
         ::vButtons[::bButtonPlayR]  := if( ::nIndex > 0 , .T. , .F. )
         ::vButtons[::bButtonPlay]   := if( ::nIndex > 0 , .T. , .F. )
         ::vButtons[::bButtonPause]  := .F.
         ::vButtons[::bButtonStop]   := .F.
         ::vButtons[::bButtonForward]:= .F.
         ::vButtons[::bButtonNext]   := if( ::nIndex > 0 .and. ::nIndex < len( ::vLista ) , .T. , .F. )
         ::vButtons[::bButtonLast]   := if( ::nIndex > 0 .and. ::nIndex < len( ::vLista ) , .T. , .F. )
      case ::nPlayMode = 1
         ::Stop()
         ::Play()
      case ::nPlayMode = -1
         ::Stop()
         ::PlayRev()
   endcase
   if ::bIsPlayListActive
      ::PlayerListRefresh()
   endif
Return

METHOD Play() CLASS US_Player
   US_Log( , .F. )
   if ::nPlayMode = 0
      if len( ::vLista ) > 0
         if len( ::vLista[ ::nIndex ] ) > 255
            OPEN PLAYER &( ::cControl ) OF &( ::US_PlayerPan ) FILE US_GetShortFullFileName( ::vLista[ ::nIndex ] )
         else
            OPEN PLAYER &( ::cControl ) OF &( ::US_PlayerPan ) FILE ::vLista[ ::nIndex ]
         endif
         if ::voMedios[ ::nIndex ]:GetReturnCode() != 0
            SET PLAYER &( ::cControl ) OF &( ::US_PlayerPan ) POSITION END
            ::nMilLengthControl := GetProperty( ::US_PlayerPan , ::cControl , "position" )
            SET PLAYER &( ::cControl ) OF &( ::US_PlayerPan ) POSITION HOME
         endif
         SET PLAYER &( ::cControl ) OF &( ::US_PlayerPan ) VOLUME ::nPlayVolume
         DoMethod( ::US_PlayerPan , ::cControl , "Play" )
         ::nPlayMode:=1
         ::vButtons[::bButtonFirst]  := if( ::nIndex > 1 , .T. , .F. )
         ::vButtons[::bButtonPrev]   := if( ::nIndex > 0 , .T. , .F. )
         ::vButtons[::bButtonRewind] := .T.
         ::vButtons[::bButtonPlayR]  := .T.
         ::vButtons[::bButtonPlay]   := .F.
         ::vButtons[::bButtonPause]  := .T.
         ::vButtons[::bButtonStop]   := .T.
         ::vButtons[::bButtonForward]:= .T.
         ::vButtons[::bButtonNext]   := if( ::nIndex > 0 .and. ::nIndex < len( ::vLista ) , .T. , .F. )
         ::vButtons[::bButtonLast]   := if( ::nIndex > 0 .and. ::nIndex < len( ::vLista ) , .T. , .F. )
      endif
   else
      if ::nPlayMode = -1
         DoMethod( ::US_PlayerPan , ::cControl , "Stop" )
         DoMethod( ::US_PlayerPan , ::cControl , "Play" )
         ::nPlayMode:=1
         ::vButtons[::bButtonFirst]  := if( ::nIndex > 1 , .T. , .F. )
         ::vButtons[::bButtonPrev]   := if( ::nIndex > 0 , .T. , .F. )
         ::vButtons[::bButtonRewind] := .T.
         ::vButtons[::bButtonPlayR]  := .T.
         ::vButtons[::bButtonPlay]   := .F.
         ::vButtons[::bButtonPause]  := .T.
         ::vButtons[::bButtonStop]   := .T.
         ::vButtons[::bButtonForward]:= .T.
         ::vButtons[::bButtonNext]   := if( ::nIndex > 0 .and. ::nIndex < len( ::vLista ) , .T. , .F. )
         ::vButtons[::bButtonLast]   := if( ::nIndex > 0 .and. ::nIndex < len( ::vLista ) , .T. , .F. )
      endif
   endif
return NIL

METHOD PlayRev() CLASS US_Player
   US_Log( , .F. )
   if ::nPlayMode = 0
      if len( ::vLista ) > 0
         if len( ::vLista[ ::nIndex ] ) > 255
            OPEN PLAYER &( ::cControl ) OF &( ::US_PlayerPan ) FILE US_GetShortFullFileName( ::vLista[ ::nIndex ] )
         else
            OPEN PLAYER &( ::cControl ) OF &( ::US_PlayerPan ) FILE ::vLista[ ::nIndex ]
         endif
         SET PLAYER &( ::cControl ) OF &( ::US_PlayerPan ) VOLUME ::nPlayVolume
         SET PLAYER &(::cControl) OF &(::US_PlayerPan) POSITION END
         DoMethod( ::US_PlayerPan , ::cControl , "PlayReverse" )
         ::nPlayMode:=1
         ::vButtons[::bButtonFirst]  := if( ::nIndex > 1 , .T. , .F. )
         ::vButtons[::bButtonPrev]   := if( ::nIndex > 0 , .T. , .F. )
         ::vButtons[::bButtonRewind] := .T.
         ::vButtons[::bButtonPlayR]  := .F.
         ::vButtons[::bButtonPlay]   := .T.
         ::vButtons[::bButtonPause]  := .T.
         ::vButtons[::bButtonStop]   := .T.
         ::vButtons[::bButtonForward]:= .T.
         ::vButtons[::bButtonNext]   := if( ::nIndex > 0 .and. ::nIndex < len( ::vLista ) , .T. , .F. )
         ::vButtons[::bButtonLast]   := if( ::nIndex > 0 .and. ::nIndex < len( ::vLista ) , .T. , .F. )
      endif
   else
      if ::nPlayMode = 1
         DoMethod( ::US_PlayerPan , ::cControl , "Stop" )
         DoMethod( ::US_PlayerPan , ::cControl , "PlayReverse" )
         ::nPlayMode:=1
         ::vButtons[::bButtonFirst]  := if( ::nIndex > 1 , .T. , .F. )
         ::vButtons[::bButtonPrev]   := if( ::nIndex > 0 , .T. , .F. )
         ::vButtons[::bButtonRewind] := .T.
         ::vButtons[::bButtonPlayR]  := .F.
         ::vButtons[::bButtonPlay]   := .T.
         ::vButtons[::bButtonPause]  := .T.
         ::vButtons[::bButtonStop]   := .T.
         ::vButtons[::bButtonForward]:= .T.
         ::vButtons[::bButtonNext]   := if( ::nIndex > 0 .and. ::nIndex < len( ::vLista ) , .T. , .F. )
         ::vButtons[::bButtonLast]   := if( ::nIndex > 0 .and. ::nIndex < len( ::vLista ) , .T. , .F. )
      endif
   endif
return NIL

METHOD Stop() CLASS US_Player
   US_Log( , .F. )
   DoMethod( ::US_PlayerPan , ::cControl , "Stop" )
   US_SetPlayerPosition ( ::US_PlayerPan , ::cControl , 0 )
   ::nPlayMode:=0
   ::vButtons[::bButtonFirst]  := if( ::nIndex > 1 , .T. , .F. )
   ::vButtons[::bButtonPrev]   := if( ::nIndex > 1 , .T. , .F. )
   ::vButtons[::bButtonRewind] := .F.
   ::vButtons[::bButtonPlayR]  := .T.
   ::vButtons[::bButtonPlay]   := .T.
   ::vButtons[::bButtonPause]  := .F.
   ::vButtons[::bButtonStop]   := .F.
   ::vButtons[::bButtonForward]:= .F.
   ::vButtons[::bButtonNext]   := if( ::nIndex > 0 .and. ::nIndex < len( ::vLista ) , .T. , .F. )
   ::vButtons[::bButtonLast]   := if( ::nIndex > 0 .and. ::nIndex < len( ::vLista ) , .T. , .F. )
return NIL

METHOD Pause() CLASS US_Player
   US_Log( , .F. )
   if ::bPaused
      ::Resume()
      ::bPaused := .F.
      if ::nPlayMode = 1
         ::vButtons[::bButtonPlayR]  := .T.
         ::vButtons[::bButtonPlay]   := .F.
      else
         ::vButtons[::bButtonPlayR]  := .F.
         ::vButtons[::bButtonPlay]   := .T.
      endif
      ::vButtons[::bButtonFirst]  := if( ::nIndex > 1 , .T. , .F. )
      ::vButtons[::bButtonPrev]   := if( ::nIndex > 0 , .T. , .F. )
      ::vButtons[::bButtonRewind] := .T.
      ::vButtons[::bButtonPause]  := .T.
      ::vButtons[::bButtonStop]   := .T.
      ::vButtons[::bButtonForward]:= .T.
      ::vButtons[::bButtonNext]   := if( ::nIndex > 0 .and. ::nIndex < len( ::vLista ) , .T. , .F. )
      ::vButtons[::bButtonLast]   := if( ::nIndex > 0 .and. ::nIndex < len( ::vLista ) , .T. , .F. )
   else
      DoMethod( ::US_PlayerPan , ::cControl , "Pause" )
      ::bPaused := .T.
      ::vButtons[::bButtonFirst]  := if( ::nIndex > 1 , .T. , .F. )
      ::vButtons[::bButtonPrev]   := if( ::nIndex > 0 , .T. , .F. )
      ::vButtons[::bButtonRewind] := .F.
      ::vButtons[::bButtonPlayR]  := .F.
      ::vButtons[::bButtonPlay]   := .F.
      ::vButtons[::bButtonPause]  := .T.
      ::vButtons[::bButtonStop]   := .T.
      ::vButtons[::bButtonForward]:= .F.
      ::vButtons[::bButtonNext]   := if( ::nIndex > 0 .and. ::nIndex < len( ::vLista ) , .T. , .F. )
      ::vButtons[::bButtonLast]   := if( ::nIndex > 0 .and. ::nIndex < len( ::vLista ) , .T. , .F. )
   endif
return NIL

METHOD Resume() CLASS US_Player
   US_Log( , .F. )
   DoMethod( ::US_PlayerPan , ::cControl , "Resume" )
return NIL

METHOD Prev() CLASS US_Player
   LOCAL PressKey:=seconds()
   US_Log( , .F. )
   if ::nIndex > 1 .and. ( PressKey - ::nLastPrevPress ) < 4
      ::SetPlayIndex( ::nIndex - 1 )
   else
      ::SetPlayIndex( ::nIndex )
   endif
   if ::nPlayMode = 0
      ::Play()
   endif
   ::nLastPrevPress:=PressKey
return NIL

METHOD Next() CLASS US_Player
   US_Log( , .F. )
   if ::nIndex < len( ::vLista )
      ::SetPlayIndex( ::nIndex + 1 )
   endif
   if ::nPlayMode = 0
      ::Play()
   endif
return NIL

METHOD First() CLASS US_Player
   US_Log( , .F. )
   ::SetPlayIndex( 1 )
   if ::nPlayMode = 0
      ::Play()
   endif
return NIL

METHOD Last() CLASS US_Player
   US_Log( , .F. )
   ::SetPlayIndex( len( ::vLista ) )
   if ::nPlayMode = 0
      ::Play()
   endif
return NIL

METHOD Forward() CLASS US_Player
// US_Log( , .F. )
   ::SetCurrentPlaySec( ::GetCurrentPlaySec() + ::SecondsSeek )
return NIL

METHOD Rewind() CLASS US_Player
   US_Log( , .F. )
   ::SetCurrentPlaySec( ::GetCurrentPlaySec() - ::SecondsSeek )
return NIL

METHOD Add( cFile ) CLASS US_Player
   LOCAL nCod:=0
   AADD( ::voMedios , NIL )
   AADD( ::vLista , cFile )
   if ::bIsPlayListActive
      DoMethod( ::PL_Window , "LPlayerList" , "AddItem" , cFile )
      ::PlayerListRefresh()
   endif
   ::voMedios[ len( ::voMedios ) ] := US_Media():New()
   if ( nCod := ::voMedios[ len( ::voMedios ) ]:SetFile( cFile ) ) >= 0
      if nCod > 0
         IF !US_SEGURO("El archivo '"+cFile+"' está defectuoso, puede que no se reproduzca correctamente, ¿Desea incorporarlo de todos modos?.",23,"SINDEFAULT")
            ::Remove( len( ::vLista ) )
         endif
      endif
   else
      US_LOG( ::voMedios[ len( ::voMedios ) ]:GetLastError() , .F. )
      ::Remove( len( ::vLista ) )
   endif
   if ::nIndex = 0 .and. len( ::vLista ) > 0
      ::SetPlayIndex( 1 )
   endif
   ::vButtons[::bButtonFirst]  := if( ::nIndex > 1 , .T. , .F. )
   ::vButtons[::bButtonPrev]   := if( ::nIndex > 1 , .T. , .F. )
   ::vButtons[::bButtonRewind] := .F.
   ::vButtons[::bButtonPlayR]  := if( ::nIndex > 0 , .T. , .F. )
   ::vButtons[::bButtonPlay]   := if( ::nIndex > 0 , .T. , .F. )
   ::vButtons[::bButtonPause]  := .F.
   ::vButtons[::bButtonStop]   := .F.
   ::vButtons[::bButtonForward]:= .F.
   ::vButtons[::bButtonNext]   := if( ::nIndex > 0 .and. ::nIndex < len( ::vLista ) , .T. , .F. )
   ::vButtons[::bButtonLast]   := if( ::nIndex > 0 .and. ::nIndex < len( ::vLista ) , .T. , .F. )
return NIL

METHOD RemoveAll() CLASS US_Player
   US_Log( , .F. )
   ::Stop()
   ::vLista   := {}
   ::voMedios := {}
   ::SetPlayIndex(0)
   DoMethod( ::PL_Window , "LPlayerList" , "DeleteAllItems" )
   ::PlayerListToolTip()
return NIL

METHOD Remove( item ) CLASS US_Player
   LOCAL vAux:={}, voAux:={} , nInx
   US_Log( , .F. )
   if ::bIsPlayListActive
      DoMethod( ::PL_Window , "LPlayerList" , "DeleteItem" , item )
   endif
   DO EVENTS
   for nInx=1 to len( ::vLista )
      if nInx != item
         AADD( vAux , ::vLista[ nInx ] )
         AADD( voAux , ::voMedios[ nInx ] )
      endif
   next
   ::vLista   := {}
   ::voMedios := {}
   for nInx=1 to len( vAux )
       AADD( ::vLista , vAux[ nInx ] )
       AADD( ::voMedios , voAux[ nInx ] )
   next
   if ::nPlayMode != 0
      ::Stop()
   endif
   if ::nIndex > len( ::vLista )
      ::SetPlayIndex( len( ::vLista ) )
   endif
   if ::bIsPlayListActive
      SetProperty( ::PL_Window , "LPlayerList" , "value" , ::nIndex )
      ::PlayerListToolTip()
   endif
return NIL

METHOD GetTeclas() CLASS US_Player
// US_Log( , .F. )
// US_Log( ::vButtons , .T. )
return ::vButtons

METHOD GetVolume() CLASS US_Player
// US_Log( , .F. )
return ::nPlayVolume

METHOD SetVolume( nVolume ) CLASS US_Player
   US_Log( , .F. )
   if nVolume < 0
      nVolume := 0
   else
      if nVolume > 1000
         nVolume := 1000
      endif
   endif
   SET PLAYER &( ::cControl ) OF &( ::US_PlayerPan ) VOLUME nVolume
   ::nPlayVolume := nVolume
return NIL

METHOD GetPlayList() CLASS US_Player
   US_Log( , .F. )
return ::vLista

METHOD GetPlayListLength() CLASS US_Player
   US_Log( , .F. )
return len(::vLista)

METHOD GetCurrentPlayFullFileName() CLASS US_Player
   US_Log( , .F. )
return ::voMedios[ ::nIndex ]:GetFullFileName()

METHOD GetCurrentPlayFileName() CLASS US_Player
   US_Log( , .F. )
return ::voMedios[ ::nIndex ]:GetFileName()

METHOD GetPlayListFullFileName( inx ) CLASS US_Player
   US_Log( , .F. )
return ::voMedios[ inx ]:GetFullFileName()

METHOD GetPlayListFileName( inx ) CLASS US_Player
   US_Log( , .F. )
return ::voMedios[ inx ]:GetFileName()

METHOD GetCurrentPlayMode() CLASS US_Player
// US_Log( , .F. )
Return ::nPlayMode

METHOD SetCurrentPlaySec( nSec ) CLASS US_Player
   LOCAL nModeAux:=::nPlayMode
   US_Log( , .F. )
   if nModeAux != 0
      if nSec < 0
         nSec := 0
      else
         if nSec >= ::GetCurrentPlayLength()
            nSec := ( ( ::GetCurrentPlayLength() - 2 ) * 1000 )
         else
            nSec := ( nSec * 1000 )
         endif
      endif
      DoMethod( ::US_PlayerPan , ::cControl , "Stop" )
      US_SetPlayerPosition ( ::US_PlayerPan , ::cControl , nSec )
      DoMethod( ::US_PlayerPan , ::cControl , if( nModeAux = 1 , "Play" , "PlayReverse" ) )
   endif
Return

METHOD GetCurrentPlaySec() CLASS US_Player
// US_Log( , .F. )
Return ( ::GetCurrentPlayMilSec() / 1000 )

METHOD GetCurrentPlayMilSec() CLASS US_Player
// US_Log( , .F. )
Return GetProperty( ::US_PlayerPan , ::cControl , "Position" )

METHOD GetCurrentPlayLength() CLASS US_Player
// US_Log( , .F. )
Return ( ::GetCurrentPlayMilLength() / 1000 )

METHOD GetCurrentPlayMilLength() CLASS US_Player
// US_Log( , .F. )
   if ::nIndex > 0
      do case
         case ::voMedios[ ::nIndex ]:GetFileType() = "MP3"
            Return ::voMedios[ ::nIndex ]:GetFileMilLength()
         case ::voMedios[ ::nIndex ]:GetFileType() = "WAV"
            Return ::voMedios[ ::nIndex ]:GetFileMilLength()
      endcase
   endif
// Return _GetPlayerLength( ::cControl , ::US_PlayerPan )
Return 0

METHOD GetCurrentFileSize() CLASS US_Player
   US_Log( , .F. )
Return ::voMedios[ ::nIndex ]:GetFileSize()

METHOD GetCurrentHilite() CLASS US_Player
   US_Log( , .F. )
return NIL

METHOD GetCurrentHiliteInx() CLASS US_Player
   US_Log( , .F. )
return NIL

METHOD GetCurrentHiliteLength() CLASS US_Player
   US_Log( , .F. )
return NIL

METHOD GetCurrentHiliteSize() CLASS US_Player
   US_Log( , .F. )
return NIL

METHOD ShowPlayList() CLASS US_Player
   US_Log( , .F. )

   PRIVATE oTB := VP_TitleBar():New() , ;
           oSB := VP_StatusBar():New()
   PRIVATE US_SUBWIN:=.F.,;
           US_WFIL:=0, ;
           US_WCOL:=0, ;
           US_WALTO:=GetDesktopRealHeight(), ;
           US_WANCHO:=GetDesktopRealWidth()
   PRIVATE US_HWinPorciento:=75 , ;
           US_WWinPorciento:=75
   PRIVATE US_HLienzo:=US_PAlto(US_HWinPorciento), ;
           US_WLienzo:=US_PAncho(US_WWinPorciento)
   Private nOldWinWidth:=US_PCol( US_WWinPorciento ) , nOldWinHeight:=US_PFil( US_HWinPorciento )

   DEFINE WINDOW &(::PL_Window) ;
          AT US_PFil((100-US_HWinPorciento)/2),US_PCol((100-US_WWinPorciento)/2) ;
          WIDTH nOldWinWidth ;
          HEIGHT nOldWinHeight ;
          USMODAL ;
          NOSYSMENU ;
          NOCAPTION ;
          FONT "VPArial" SIZE US_WFont(09) ;
          BACKCOLOR ::PL_BackColor ;
          ON GOTFOCUS RN_OnGotFocus() ;
          ON SIZE US_Redraw( ::PL_Window , @nOldWinWidth , @nOldWinHeight ) ;
          ON INIT ::LoadPlayList()

          PRIVATE US_SUBWIN:=.F.,;                &&  <-- En esta instancia es necesaria para que no cancelen las funciones, siempre con valor .F.
                  US_WFIL:=&(::PL_Window).Row, ;
                  US_WCOL:=&(::PL_Window).Col, ;
                  US_WALTO:=&(::PL_Window).Height, ;
                  US_WANCHO:=&(::PL_Window).Width

   END WINDOW

   if ::cSkin = "VP"
      oTB:ActionOnClose    := { || DoMethod( ::PL_Window , 'release' ) }
   // oTB:ActionOnMaximize := { || ::WindowMaximize() }
      oTB:Create( ::PL_Window )
      oTB:SetButtomMaximize( .F. )
      oTB:SetBackColor( ::PL_FontColor )
      oTB:SetFontColor( ::PL_BackColor )
      oTB:SetTitle( ::PL_Title )
   endif

   @ US_PFil(10) , US_PCol(5) LISTBOX LPlayerList ;
      OF &( ::PL_Window ) ;
      WIDTH US_PCol(90.0) ;
      HEIGHT US_PFil(70.0) ;
      ITEMS {} ;
      VALUE ::nIndex ;
      TOOLTIP "Reproduciendo: ..." ;
      ON CHANGE ( ::PlayerListDBLClick() )

   @ US_PFil( 83 ) , US_PCol( 5 ) BUTTON BRemove ;
      OF &( ::PL_Window ) ;
      CAPTION "Remover Item Seleccionado" ;
      ACTION ::Remove( GetProperty( ::PL_Window , "LPlayerList" , "value" ) ) ;
      WIDTH US_PCol( 55 ) ;
      HEIGHT US_Fils( 1.5 ) ;
      FONT "VPArial" SIZE US_WFont( 9 )

   @ US_PFil( 83 ) , US_PCol( 70 ) BUTTON BRemoveAll ;
      OF &( ::PL_Window ) ;
      CAPTION "Remover Todos los Items" ;
      ACTION ::RemoveAll() ;
      WIDTH US_PCol( 25 ) ;
      HEIGHT US_Fils( 0.75 ) ;
      FONT "VPArial" SIZE US_WFont( 7 )

   if ::cSkin = "VP"
      oSB:bBottonPlayerList := .F.
      oSB:cActionPrePlayerList  := { || oTB:Off() }
      oSB:cActionPostPlayerList := { || oTB:On() }
      oSB:PorcentajeRow         := 95.9
      oSB:PorcentajeAlto        := 3.2
      oSB:Create( ::PL_Window )

      US_WinStackAdd( @RN_WinStack , ::PL_Window )

   endif

   ::bIsPlayListActive := .T.

   DoMethod( ::PL_Window , "activate" )

   ::bIsPlayListActive := .F.

   if ::cSkin = "VP"
      US_WinStackDel( @RN_WinStack , ::PL_Window )
   endif

return NIL

METHOD TimerPlayer() CLASS US_Player
// US_Log( , .F. )
// if ::GetCurrentPlayMilSec() >= ::GetCurrentPlayMilLength()
   if ::nPlayMode = 1
      if ::voMedios[ ::nIndex ]:GetReturnCode() != 0
         if ::GetCurrentPlayMilSec() >= ::nMilLengthControl
            if ::nIndex < len( ::vLista )
               ::Next()
            else
               ::Stop()
            endif
         endif
      else
         if ::GetCurrentPlayMilSec() >= ::GetCurrentPlayMilLength()
            if ::nIndex < len( ::vLista )
               ::Next()
            else
               ::Stop()
            endif
         endif
      endif
   else
      if ::nPlayMode = -1
         if ::GetCurrentPlayMilSec() <= 0
            if ::nIndex < len( ::vLista )
               ::Prev()
            else
               ::Stop()
            endif
         endif
      endif
   endif
return NIL

METHOD LoadPlayList() CLASS US_Player
   LOCAL nIAux
   US_Log( , .F. )
   DoMethod( ::PL_Window , "LPlayerList" , "DeleteAllItems" )
   for nIAux=1 to len( ::vLista )
       DoMethod( ::PL_Window , "LPlayerList" , "AddItem" , ::vLista[ nIAux ] )
   next
   SetProperty( ::PL_Window , "LPlayerList" , "value" , ::nIndex )
   ::PlayerListToolTip()
Return NIL

METHOD PlayerListDBLClick() CLASS US_Player
   ::SetPlayIndex( GetProperty( ::PL_Window , "LPlayerList" , "value" ) )
   ::PlayerListToolTip()
   if ::nPlayMode = 0
      ::Play()
   endif
Return

METHOD PlayerListRefresh() CLASS US_Player
   US_Log( , .F. )
// SetProperty( ::PL_Window , "LV_Duracion" , "value" , US_TimeDis( US_SecTime( ::GetCurrentPlayLength() ) ) )
   SetProperty( ::PL_Window , "LPlayerList" , "value" , ::nIndex )
   ::PlayerListToolTip()
Return

METHOD PlayerListToolTip() CLASS US_Player
   LOCAL var:=""
// US_Log( , .F. )
   if ::nIndex > 0
      var := ::GetCurrentPlayFileName() + " (" + Alltrim( US_TimeDis( US_SecTime( ::GetCurrentPlayLength() ) ) ) + ")"
   else
      var := "Lista de reproducción vacía"
   endif
   SetProperty( ::PL_Window , "LPlayerList" , "tooltip" , var )
Return

FUNCTION US_SEGURO(STRING,FILA,DEFAULT)
   LOCAL C
   C:=US_OPCION(STRING,"NO SI",FILA,DEFAULT)
   IF C="SI"
      RETURN .T.
   ENDIF
RETURN .F.

//----------------------------------------------------------------------------------\\
//= END CLASE US_Player                                                            =\\
//==================================================================================\\

//==================================================================================\\
//= CLASE US_FileFind                                                              =\\
//----------------------------------------------------------------------------------\\

CLASS US_FileFind

   METHOD New()                                              && Crear el Objeto
   METHOD Destroy()                                          && Destruir el Objeto
   METHOD Seek()                                             && Comenzar la busqueda
   METHOD US_FileFindProgress(Directorio)          HIDDEN    && Uso Interno
   METHOD US_FileFindProgressFileFound(cArchivo)   HIDDEN    && Uso Interno
   METHOD US_FileFindInit(aVec,cPath)              HIDDEN    && Uso Interno

   DATA US_FileFindPan          HIDDEN             init "US_SeekF"+US_NameRandom()
   DATA Reto                    HIDDEN              init NIL
   DATA bStopSeek               HIDDEN   AS LOGIC   init .F.            && Variable para Stop
   DATA cTitulo       EXPORTED            init NIL
   DATA cInitialPath  EXPORTED            init "C:"+DEF_SLASH
   DATA cMascara      EXPORTED            init "*.*"          && Mascara para busqueda de archivos
   DATA nPorAncho     EXPORTED AS NUMERIC init 70             && Porcentaje de Ancho del dialogo
   DATA nPorAlto      EXPORTED AS NUMERIC init 10             && Porcentaje de Alto del dialogo
   DATA bCenter       EXPORTED AS LOGIC   init .T.            && ¿desea centrar la ventana del dialogo?
   DATA bEscape       EXPORTED AS LOGIC   init .F.            && ¿desea salir con escape?
   DATA bStop         EXPORTED AS LOGIC   init .T.            && ¿desea tener un boton de Stop?
ENDCLASS

METHOD New() CLASS US_FileFind
return Self

METHOD Destroy() CLASS US_FileFind
return NIL

METHOD Seek( aVector ) CLASS US_FileFind
   DEFINE WINDOW &(::US_FileFindPan) ;
          AT 0, 0 ;
          WIDTH US_PorScreenAncho( ::nPorAncho ) ;
          HEIGHT US_PorScreenAlto( ::nPorAlto ) ;
          TITLE ::cTitulo ;
          USMODAL;
          NOSYSMENU ;
          FONT "ARIAL" SIZE 9 ;
          ON INIT ::US_FileFindInit( @aVector , ::cInitialPath , ::cMascara ) ;
          ON RELEASE US_NOP()

       @ ( GetProperty( ::US_FileFindPan , "Row" ) + US_PorWindowAlto( ::US_FileFindPan , 15 ) ), ( GetProperty( ::US_FileFindPan , "Col" ) + US_PorWindowAncho( ::US_FileFindPan , 05 ) ) LABEL LProgressSeek ;
          VALUE " " ;
          WIDTH US_PorWindowAncho( ::US_FileFindPan , 70 ) ;
          HEIGHT US_PorWindowAlto( ::US_FileFindPan , 40 ) ;
          FONT "ARIAL" SIZE 10 BOLD
    ***   BACKCOLOR {0,0,0} ;

       if ::bStop
          @ ( GetProperty( ::US_FileFindPan , "Row" ) + US_PorWindowAlto( ::US_FileFindPan , 13 ) ), ( GetProperty( ::US_FileFindPan , "Col" ) + US_PorWindowAncho( ::US_FileFindPan , 80 ) ) BUTTON BProgressSeekStop ;
             CAPTION "Stop Seek" ;
             ACTION (::BStopSeek:=.T. , &(::US_FileFindPan).BProgressSeekStop.Enabled:=.F.) ;
             WIDTH US_PorWindowAncho( ::US_FileFindPan , 15 ) ;
             HEIGHT US_PorWindowAlto( ::US_FileFindPan , 40 )
       endif

   END WINDOW
   if !::bStop
      &(::US_FileFindPan).LProgressSeek.width := US_PorWindowAncho( ::US_FileFindPan , 90 )
   endif
   if ::cTitulo = NIL
      &(::US_FileFindPan).title:="Buscando archivos en " + ::cInitialPath + "..."
   else
      &(::US_FileFindPan).title:=::cTitulo
   endif
   if ::bCenter
      &(::US_FileFindPan).Center()
   endif
   if ::bEscape
 ***  ON KEY ESCAPE OF &(::US_FileFindPan) ACTION ( ::BStopSeek:=.T. , &(::US_FileFindPan).BProgressSeekStop.Enabled:=.F. , ::Reto:=-1 , DoMethod( ::US_FileFindPan , "Release" ) )
      ON KEY ESCAPE OF &(::US_FileFindPan) ACTION ( ::BStopSeek:=.T. , &(::US_FileFindPan).BProgressSeekStop.Enabled:=.F. )
   endif
   DoMethod( ::US_FileFindPan , "activate" )
return ::Reto

METHOD US_FileFindInit(aVec,cPath,cMask) CLASS US_FileFind
#ifndef __XHARBOUR__
   Local aux  // esto es porque Harbour no soporta @::var como parametro del metodo (xHarbour si lo soporta)
   aux := ::BStopSeek
   ::Reto := US_SeekFile( @aVec , substr( cPath , 1 , 1 ) , substr( cPath , 4 ) , cMask , { |cNextPath| ::US_FileFindProgress( cNextPath ) } , { |cFileFound| ::US_FileFindProgressFileFound( cFileFound ) } , @aux )
   ::BStopSeek := aux
#else
   ::Reto := US_SeekFile( @aVec , substr( cPath , 1 , 1 ) , substr( cPath , 4 ) , cMask , { |cNextPath| ::US_FileFindProgress( cNextPath ) } , { |cFileFound| ::US_FileFindProgressFileFound( cFileFound ) } , @::BStopSeek )
#endif
   &(::US_FileFindPan).Release()
Return

METHOD US_FileFindProgress(Directorio) CLASS US_FileFind
   DO EVENTS
   &(::US_FileFindPan).LProgressSeek.Value := Directorio
Return

METHOD US_FileFindProgressFileFound(cArchivo) CLASS US_FileFind
   DO EVENTS    // el DO EVENT en el bloque FileFound favorece la reaccion ante Stop
Return

//----------------------------------------------------------------------------------\\
//= END CLASE US_FileFind                                                          =\\
//==================================================================================\\

*/

//==================================================================================\\
//= CLASE US_InputBox                                                              =\\
//----------------------------------------------------------------------------------\\

CLASS US_InputBox

   METHOD New()                                 && Crear el Objeto
   METHOD Destroy()                             && Destruir el Objeto
   METHOD DefineWindow()                        && Definir la ventana y los controles
   METHOD InputBoxEval( cValidar , bNumeric )   && Evaluar la condicion para abandonar el dialogo
   METHOD Show()                                && Activar el dialogo

   DATA US_InputBoxPan HIDDEN             init "US_WIP"+US_NameRandom()
   DATA Reto          HIDDEN              init NIL
   DATA cTitulo       EXPORTED            init "Este es el titulo del dialogo"
   DATA cLeyenda      EXPORTED            init "Esta es la leyenda del dialogo"
   DATA ValorInicial  EXPORTED            init NIL            && Valor Inicial
   DATA Mascara       EXPORTED            init NIL            && Mascara de Edicion
   DATA nPorAncho     EXPORTED AS NUMERIC init 20             && Porcentaje de Ancho del dialogo
   DATA nPorAlto      EXPORTED AS NUMERIC init 15             && Porcentaje de Alto del dialogo
   DATA bNumeric      EXPORTED AS LOGIC   init .F.            && ¿es de tipo numerico?
   DATA bCenter       EXPORTED AS LOGIC   init .T.            && ¿desea centrar la ventana del dialogo?
   DATA bButtonOk     EXPORTED AS LOGIC   init .F.            && ¿desea tener un boton OK?
   DATA bButtonCancel EXPORTED AS LOGIC   init .F.            && ¿desea tener un boton Cancel?
   DATA bEscape       EXPORTED AS LOGIC   init .F.            && ¿desea salir con escape?
   DATA cValid        EXPORTED            init NIL            && Bloque a evaluar

ENDCLASS

METHOD New() CLASS US_InputBox
return Self

METHOD Destroy() CLASS US_InputBox
return NIL

METHOD DefineWindow() CLASS US_InputBox
   DEFINE WINDOW &(::US_InputBoxPan) ;
          AT 0, 0 ;
          WIDTH ( ( GetDesktopRealWidth() * ::nPorAncho ) / 100 );
          HEIGHT ( ( GetDesktopRealHeight() * ::nPorAlto ) / 100 );
          TITLE ::cTitulo ;
          USMODAL;
          NOSYSMENU ;
          FONT "ARIAL" SIZE 9

      @ 10, 10 LABEL Label1 ;
        VALUE ::cLeyenda ;
        WIDTH ( &(::US_InputBoxPan).Width - 22 ) ;
        HEIGHT 30 ;

      if ::bNumeric
         @ 50, 10 TEXTBOX Texto ;
           VALUE ::ValorInicial ;
           WIDTH ( &(::US_InputBoxPan).Width - 22 ) ;
           HEIGHT 30 ;
           NUMERIC INPUTMASK "999999999999999.99" ;
           ON ENTER ::InputBoxEval( ::cValid , ::bNumeric )
      else
         if !empty( ::Mascara )
            @ 50, 10 TEXTBOX Texto ;
              VALUE ::ValorInicial ;
              WIDTH ( &(::US_InputBoxPan).Width - 30 ) ;
              HEIGHT 30 ;
              INPUTMASK ::Mascara ;
              ON ENTER ::InputBoxEval( ::cValid , ::bNumeric )
         else
            @ 50, 10 TEXTBOX Texto ;
              VALUE ::ValorInicial ;
              WIDTH ( &(::US_InputBoxPan).Width - 30 ) ;
              HEIGHT 30 ;
              ON ENTER ::InputBoxEval( ::cValid , ::bNumeric )
         endif
      endif
      if ::bButtonOk
         @ 100, ( &(::US_InputBoxPan).Width / 2 ) - 140 BUTTON B_OK ;
           CAPTION "OK" ;
           WIDTH 120 ;
           HEIGHT 30 ;
           ACTION ::InputBoxEval( ::cValid , ::bNumeric )
      endif
      if ::bButtonCancel
         @ 100, ( &(::US_InputBoxPan).Width / 2 ) + 20 BUTTON B_CANCEL ;
           CAPTION "Cancel" ;
           WIDTH 120 ;
           HEIGHT 30 ;
           ACTION (::Reto := NIL , DoMethod( ::US_InputBoxPan , "Release" ) )
      endif
   END WINDOW
   if ::bCenter
      &(::US_InputBoxPan).Center()
   endif
return .t.

METHOD Show() CLASS US_InputBox
   if ::bEscape
      ON KEY ESCAPE OF &(::US_InputBoxPan) ACTION (::Reto := NIL , DoMethod( ::US_InputBoxPan , "Release" ) )
   endif
   DoMethod( ::US_InputBoxPan , "activate" )
return ::Reto

METHOD InputBoxEval( cValidar , bNumeric ) CLASS US_InputBox
   Local Aux:=GetProperty( ::US_InputBoxPan , "texto" , "value" )
   if bNumeric
      Aux:=STR(Aux)
   endif
   if cValidar != NIL
      if &(Aux+" "+cValidar)
         ::Reto:=GetProperty( ::US_InputBoxPan , "texto" , "value" )
         &(::US_InputBoxPan).Release()
      endif
   else
      ::Reto:=GetProperty( ::US_InputBoxPan , "texto" , "value" )
      &(::US_InputBoxPan).Release()
   endif
Return nil
//----------------------------------------------------------------------------------\\
//= END CLASE US_InputBox                                                          =\\
//==================================================================================\\

/*

//==================================================================================\\
//= CLASE US_Lista                                                                 =\\
//----------------------------------------------------------------------------------\\

CLASS US_Lista

   METHOD New()                                 && Crear el Objeto
   METHOD Destroy()                             && Destruir el Objeto
   METHOD US_ListaEleccion( bFueEscape )        && Evaluar la opcion para abandonar el dialogo
   METHOD Show()                                && Activar el dialogo

   DATA Ventana       HIDDEN              init "US_PM"+US_NameRandom()
   DATA Opcion        HIDDEN              init 0
   DATA cTitulo       EXPORTED            init "Este es el titulo del dialogo"
   DATA Lista         EXPORTED            init NIL            && Vector con los valores a elegir
   DATA ListaBool     EXPORTED            init NIL            && Vector para saber que elementos son utiles
   DATA bPosRelativa  EXPORTED AS LOGIC   init .F.            && Retorna la posicion relativa eliminando los Boolenos .F.
   DATA cMensajeBool  EXPORTED            init "Esta opción no esta disponible en este lugar del programa"
   DATA ValorInicial  EXPORTED            init 1              && Valor Inicial
   DATA nPorAncho     EXPORTED AS NUMERIC init 50             && Porcentaje de Ancho del dialogo
   DATA nPorAlto      EXPORTED AS NUMERIC init 50             && Porcentaje de Alto del dialogo
   DATA bCenter       EXPORTED AS LOGIC   init .T.            && ¿desea centrar la ventana del dialogo?
   DATA bEscape       EXPORTED AS LOGIC   init .T.            && ¿desea salir con escape?
   DATA bWinChild     EXPORTED AS LOGIC   init .F.            && ¿desea salir con escape?
   DATA cSkin         EXPORTED            init ""             && Skin
ENDCLASS

METHOD New() CLASS US_Lista
return Self

METHOD Destroy() CLASS US_Lista
return NIL

METHOD Show() CLASS US_Lista
   if ::bWinChild
      DEFINE WINDOW &(::Ventana) ;
         AT 0 , 0 ;
         WIDTH ( ( GetDesktopRealWidth() * ::nPorAncho ) / 100 );
         HEIGHT ( ( GetDesktopRealHeight() * ::nPorAlto ) / 100 );
         CHILD ;
         NOSYSMENU ;
         NOCAPTION ;
         FONT "COURIER NEW" SIZE 10 ;
         ON RELEASE US_NOP()
      END WINDOW
   else
      DEFINE WINDOW &(::Ventana) ;
         AT 0 , 0 ;
         WIDTH ( ( GetDesktopRealWidth() * ::nPorAncho ) / 100 );
         HEIGHT ( ( GetDesktopRealHeight() * ::nPorAlto ) / 100 );
         USMODAL ;
         NOSYSMENU ;
         NOCAPTION ;
         FONT "COURIER NEW" SIZE 10 ;
         ON RELEASE US_NOP()
      END WINDOW
   endif

   ** HEIGHT ( ( GetProperty( ::Ventana , "height" ) * 6 ) / 100 );
   @ 0 , 0 LABEL LTitulo ;
      OF &(::Ventana) ;
      VALUE "  " + ::cTitulo ;
      ACTION InterActiveMoveHandle( GetFormHandle(::Ventana) ) ;
      WIDTH GetProperty( ::Ventana , "width" ) ;
      HEIGHT 20 ;
      BACKCOLOR US_BLUE ;
      FONT "Arial" SIZE 12 ;
      FONTCOLOR US_WHITE

   @ ( GetProperty( ::Ventana , "LTitulo" , "height" ) ) , 0 LISTBOX LLista ;
       OF &(::Ventana) ;
       WIDTH   ( ( &(::Ventana).Width * 99 ) / 100 ) ;
       HEIGHT  ( &(::Ventana).Height - GetProperty( ::Ventana , "LTitulo" , "height" ) - ( ( &(::Ventana).Height * 12 ) / 100 ) ) ;
       ITEMS ::Lista ;
       VALUE ::ValorInicial ;
       ON DBLCLICK ::US_ListaEleccion(.F.)

   if ::bCenter
      DoMethod( ::Ventana , "center" )
   endif

   if ::bEscape
      ON KEY ESCAPE OF &(::Ventana) ACTION ::US_ListaEleccion(.T.)
   endif

   if ::cSkin = "VP"
      PRIVATE oSB := VP_StatusBar():New()
      oSB:PorcentajeRow         := 95.9
      oSB:PorcentajeAlto        := 3.2
      oSB:Create( ::Ventana )              && esto no esta funcionando correctamente porque la ventana de esta clase no maneja las variables para US_Cols(), etc.

      US_WinStackAdd( @RN_WinStack , ::Ventana )

   endif

   ACTIVATE WINDOW &(::Ventana)

   if ::cSkin = "VP"
      US_WinStackDel( @RN_WinStack , ::Ventana )
   endif

   if ::bPosRelativa .and. ::ListaBool != NIL
      private secu:=0 , i:=0
      for i=1 to ::Opcion
         if ::ListaBool[i]
            secu++
         endif
      next
      ::Opcion := secu
   endif

RETURN ::Opcion

METHOD US_ListaEleccion(Escape) CLASS US_Lista
   IF ESCAPE
      ::Opcion := 0
      &(::Ventana).Release()
   ELSE
      if ::ListaBool != NIL
         if ::ListaBool[ &(::Ventana).LLista.Value ]
            ::Opcion := &(::Ventana).LLista.Value
            &(::Ventana).Release()
         else
            US_Cartel( ::cMensajeBool , 15 )
         endif
      else
         ::Opcion := &(::Ventana).LLista.Value
         &(::Ventana).Release()
      endif
   ENDIF
RETURN

//----------------------------------------------------------------------------------\\
//= END CLASE US_Lista                                                             =\\
//==================================================================================\\

*/

//==================================================================================\\
//= CLASE US_MGWait                                                                =\\
//----------------------------------------------------------------------------------\\

CLASS US_MGWait

   METHOD New()                                  && Crear el Objeto
   METHOD Destroy()                              && Destruir el Objeto
   METHOD Ejecutar( cFun )                       && Metodo que ejecuta la funcion
   //
   METHOD Create()                     HIDDEN    && Crear la ventana del Objeto
   METHOD OnInit()                     HIDDEN    && Metodo interno para setear el nombre de la funcion a ejecutar
   METHOD MGWaitRefresh()              HIDDEN    && Metodo interno para ocultar/mostrar la ventana wait y/o para cambiar leyenda o texto dinamicamente

   DATA MGWaitPan     HIDDEN              init NIL
   DATA Reto          HIDDEN              init NIL            && Codigo de Retorno
   DATA nLineas       HIDDEN              init 0              && Cantidad de lineas cuando el wait es modo texto
   DATA nRow          HIDDEN              init 0              && Fila de la ventana modo texto
   DATA nCol          HIDDEN              init 0              && Columna de la ventana modo texto
   DATA bTxt          HIDDEN              init .F.            && Indica que el Wait es modo texto
   DATA bFila         HIDDEN              init .F.            && Indica que el Wait recibio numero de fila
   DATA cFuncion      HIDDEN              init ""             && Funcion de usuario a ejecutar
   DATA bShowAnterior HIDDEN              init .T.            && Backup de EXPORTED bShow
   DATA cTXTAnterior  HIDDEN              init ""             && Backup de EXPORTED cTXT
   DATA nAncho        EXPORTED            init ( GetDesktopRealWidth() * 0.6 )   && Ancho de la ventana modo texto
   DATA nAlto         EXPORTED            init ( GetDesktopRealHeight() * 0.1 )  && Alto de la ventana modo texto
   DATA bAnimated     EXPORTED            init .F.            && Indica imagen animada o texto con blink (sin desarrollar)
   DATA cTXT          EXPORTED            init ""             && Texto a displayar
   DATA nFila         EXPORTED            init NIL            && Fila en donde displayar el wait
   DATA cImagen       EXPORTED            init NIL            && Nombre del recurso a displayar
   DATA nImagenWidth  EXPORTED            init 138            && Nombre del recurso a displayar
   DATA nImagenHeight EXPORTED            init 138            && Nombre del recurso a displayar
   DATA cSkin         EXPORTED            init NIL            && Fisonomia del objeto: nulo o "VP"
   DATA bShow         EXPORTED            init .T.            && Muestro la ventana wait ?
   DATA bStopButton   EXPORTED            init .F.            && Boton para Stop
   DATA bStop         EXPORTED            init .F.            && Flag para Stop
   DATA nTimerRefresh EXPORTED            init 100            && intervalo del timer para hacer refresh de texto o mostrar/ocultar ventana
ENDCLASS

METHOD New() CLASS US_MGWait
return Self

METHOD MGWaitRefresh() CLASS US_MGWait
   if ::bShow != ::bShowAnterior
      ::bShowAnterior := ::bShow
      if ::bShow
         DoMethod( ::MGWaitPan , "Show" )
      else
         DoMethod( ::MGWaitPan , "Hide" )
      endif
   endif
   if ::bTxt
      if ::cTXT == ::cTXTAnterior
      else
         ::cTXTAnterior := ::cTXT
//   us_log( ::cTXTAnterior , .F. )
//   us_log( ::cTXT , .F. )
         SetProperty( ::MGWaitPan , "Cartel" , "value" , ::cTXT )
      endif
   endif
// DO EVENTS
Return .T.

METHOD Create() CLASS US_MGWait
   ::MGWaitPan := US_WindowNameRandom("US_WAIT")  && <== NO CAMBIAR el prefijo de este nombre porque es usado en US_Redraw
   if ::cTXT == ::cTXTAnterior
   else
      ::cTXTAnterior := ::cTXT
   endif
   if ::bTxt

      if US_IsWindowMainActive()

         DEFINE WINDOW &(::MGWaitPan) at ::nRow , ::nCol ;
            WIDTH ::nAncho ;
            HEIGHT ::nAlto ;
            USMODAL ;
            NOCAPTION ;
            BACKCOLOR { 45, 24,160} ;
            ON INIT ::OnInit()
         END WINDOW

      else

         DEFINE WINDOW &(::MGWaitPan) at ::nRow , ::nCol ;
            WIDTH ::nAncho ;
            HEIGHT ::nAlto ;
            MAIN ;
            NOCAPTION ;
            BACKCOLOR { 45, 24,160} ;
            ON INIT ::OnInit()
         END WINDOW

      endif

      @ ( (::nAlto * 0.34) - ( (::nAlto * 0.1) * ( ::nLineas - 1) ) ) , 0 LABEL Cartel ;
         OF &(::MGWaitPan) ;
         VALUE ::cTXT ;
         WIDTH  &(::MGWaitPan).Width ;
         HEIGHT ( (::nAlto * 0.26) * ::nLineas ) ;
         FONT "COURIER NEW" SIZE 9 BOLD ;
         FONTCOLOR WHITE ;
         BACKCOLOR { 45, 24,160} ;
         CENTERALIGN

#define BSTOP_ROW ::nAlto - 30 - iif( IsVistaOrLater(), GetBorderWidth() / 2 + 2, 0)
#define BSTOP_COL ::nAncho - 95 - iif( IsVistaOrLater(), GetBorderWidth() / 2 + 2, 0)
      if ::bStopButton
         @ BSTOP_ROW, BSTOP_COL BUTTON BStop ;
            OF &(::MGWaitPan) ;
            CAPTION "Stop" ;
            ACTION ( SetProperty( ::MGWaitPan , "bStop" , "enabled" , .F. ) , ::bStop := .T. , SetProperty( ::MGWaitPan , "bStop" , "caption" , "Wait..." ) ) ;
            WIDTH 85 ;
            HEIGHT 20
      endif

   else

      if US_IsWindowMainActive()

         DEFINE WINDOW &(::MGWaitPan) at 0,0 ;
            WIDTH ::nImagenWidth ;
            HEIGHT ::nImagenHeight ;
            USMODAL ;
            NOSIZE ;
            NOSYSMENU ;
            NOCAPTION ;
            ON INIT ::OnInit()
         END WINDOW

      else

         DEFINE WINDOW &(::MGWaitPan) at 0,0 ;
            WIDTH ::nImagenWidth ;
            HEIGHT ::nImagenHeight ;
            MAIN ;
            NOSIZE ;
            NOSYSMENU ;
            NOCAPTION ;
            ON INIT ::OnInit()
         END WINDOW

      endif

      if ::bAnimated
         @ 0 , 0 ANIMATEBOX Imagen ;
            OF &(::MGWaitPan) ;
            WIDTH  &(::MGWaitPan).Width ;
            HEIGHT &(::MGWaitPan).Height ;
            FILE ::cImagen ;
            AUTOPLAY
      else
         @ 0 , 0 IMAGE Imagen ;
            OF &(::MGWaitPan) ;
            PICTURE ::cImagen ;
            WIDTH  &(::MGWaitPan).Width ;
            HEIGHT &(::MGWaitPan).Height
      endif

      if ::cSkin = "VP"
         US_SetWindowRgn( ::MGWaitPan , 0 , 0 , GetProperty( ::MGWaitPan , "Height" ) , GetProperty( ::MGWaitPan , "Height") , 2 )
      endif

   endif
return Self

METHOD Destroy() CLASS US_MGWait
return NIL

METHOD OnInit() CLASS US_MGWait
   DEFINE TIMER MGWaitTimer ;
      OF &(::MGWaitPan) ;
      INTERVAL ::nTimerRefresh ;
      ACTION ::MGWaitRefresh()
   ::Reto := eval( {|| &(::cFuncion) } )
   DoMethod( ::MGWaitPan , "Release" )
return NIL

METHOD Ejecutar( cFun ) CLASS US_MGWait

   ::cFuncion := cFun

   if !empty( ::cTXT )
      ::bTxt := .T.
    //::nLineas := MLCOUNT( ::cTXT , 254 )
      ::nLineas := 1
    //US_LOG("  Texto: " + ::cTXT , .F. )
   endif

   if !empty( ::nFila ) .and. ::nFila != -1
      ::bFila := .T.
      ::nRow := ::nFila
      ::nCol := ( GetDesktopRealWidth() - ::nAncho ) / 2
    //US_LOG("   Fila: " + US_VarToStr( ::nFila ) , .F. )
   endif

   DO EVENTS

   ::Create()

   DO EVENTS

   if !::bFila
   //CdQ CENTER WINDOW &( ::MGWaitPan )
      DoMethod( ::MGWaitPan , "center" )
      DO EVENTS
   endif

/*
   if ::cSkin = "VP"
      US_WinStackAdd( @RN_WinStack , ::MGWaitPan )
   endif
*/

   ACTIVATE WINDOW &( ::MGWaitPan )

   DO EVENTS

   if ::cSkin = "VP"
//      US_WinStackDel( @RN_WinStack , ::MGWaitPan )
   endif

// US_LOG("   despues de Window, retorno: " + US_VarToStr( ::Reto ) , .F. )
return ::Reto

//----------------------------------------------------------------------------------\\
//= END CLASE US_MGWait                                                            =\\
//==================================================================================\\

/*


//==================================================================================\\
//= CLASE US_MGWaitNew                                                             =\\
//----------------------------------------------------------------------------------\\

CLASS US_MGWaitNew

   METHOD New()                                  && Crear el Objeto
   METHOD Destroy()                              && Destruir el Objeto
   METHOD Ejecutar( FuncionDeUsuario )           && Metodo que ejecuta la funcion
   //
   METHOD Create()                     HIDDEN    && Crear la ventana del Objeto
   METHOD MGWaitRefresh()              HIDDEN    && Metodo interno para ocultar/mostrar la ventana wait y/o para cambiar leyenda o texto dinamicamente

   DATA MGWaitPan     HIDDEN              init NIL
   DATA Reto          HIDDEN              init NIL            && Codigo de Retorno
   DATA nLineas       HIDDEN              init 0              && Cantidad de lineas cuando el wait es modo texto
   DATA nRow          HIDDEN              init 0              && Fila de la ventana modo texto
   DATA nCol          HIDDEN              init 0              && Columna de la ventana modo texto
   DATA nAncho        HIDDEN              init ( GetDesktopRealWidth() * 0.6 )   && Ancho de la ventana modo texto
// DATA nAncho        HIDDEN              init ( GetDesktopRealWidth() * if( GetDesktopWidth() < 1024 , 0.21 , 0.17 ) )   && Ancho de la ventana modo texto
   DATA nAlto         HIDDEN              init ( GetDesktopRealHeight() * 0.1 )  && Alto de la ventana modo texto
   DATA bTxt          HIDDEN              init .F.            && Indica que el Wait es modo texto
   DATA bFila         HIDDEN              init .F.            && Indica que el Wait recibio numero de fila
   DATA cFuncion      HIDDEN              init ""             && Funcion de usuario a ejecutar
   DATA bShowAnterior HIDDEN              init .T.            && Backup de EXPORTED bShow
   DATA cTXTAnterior  HIDDEN              init ""             && Backup de EXPORTED cTXT

   DATA bAnimated     EXPORTED            init .F.            && Indica imagen animada o texto con blink (sin desarrollar)
   DATA cTXT          EXPORTED            init ""             && Texto a displayar
   DATA nFila         EXPORTED            init NIL            && Fila en donde displayar el wait
   DATA cImagen       EXPORTED            init NIL            && Nombre del recurso a displayar
   DATA nImagenWidth  EXPORTED            init 138            && Nombre del recurso a displayar
   DATA nImagenHeight EXPORTED            init 138            && Nombre del recurso a displayar
   DATA cSkin         EXPORTED            init NIL            && Fisonomia del objeto: nulo o "VP"
   DATA bShow         EXPORTED            init .T.            && Muestro la ventana wait ?
   DATA bStopButton   EXPORTED            init .F.            && Boton para Stop
   DATA bStop         EXPORTED            init .F.            && Flag para Stop
   DATA nTimerRefresh EXPORTED            init 100            && intervalo del timer para hacer refresh de texto o mostrar/ocultar ventana
ENDCLASS

METHOD New() CLASS US_MGWaitNew
return Self

METHOD MGWaitRefresh() CLASS US_MGWaitNew
   if ::bShow != ::bShowAnterior
      ::bShowAnterior := ::bShow
      if ::bShow
         DoMethod( ::MGWaitPan , "Show" )
      else
         DoMethod( ::MGWaitPan , "Hide" )
      endif
   endif
   if ::bTxt
      if ::cTXT == ::cTXTAnterior
      else
         ::cTXTAnterior := ::cTXT
//   us_log( ::cTXTAnterior , .F. )
//   us_log( ::cTXT , .F. )
         SetProperty( ::MGWaitPan , "Cartel" , "value" , ::cTXT )
      endif
   endif
// DO EVENTS
Return .T.

METHOD Create() CLASS US_MGWaitNew
   ::MGWaitPan := US_WindowNameRandom("US_WAIT")  && <== NO CAMBIAR el prefijo de este nombre porque es usado en US_Redraw
   if ::cTXT == ::cTXTAnterior
   else
      ::cTXTAnterior := ::cTXT
   endif
   if ::bTxt

      if US_IsWindowMainActive()

         DEFINE WINDOW &(::MGWaitPan) at ::nRow , ::nCol ;
            WIDTH ::nAncho ;
            HEIGHT ::nAlto ;
            USMODAL ;
            NOCAPTION ;
            BACKCOLOR { 45, 24,160}
         END WINDOW

      else

         DEFINE WINDOW &(::MGWaitPan) at ::nRow , ::nCol ;
            WIDTH ::nAncho ;
            HEIGHT ::nAlto ;
            MAIN ;
            NOCAPTION ;
            BACKCOLOR { 45, 24,160}
         END WINDOW

      endif

      @ ( (::nAlto * 0.34) - ( (::nAlto * 0.1) * ( ::nLineas - 1) ) ) , 0 LABEL Cartel ;
         OF &(::MGWaitPan) ;
         VALUE ::cTXT ;
         WIDTH  &(::MGWaitPan).Width ;
         HEIGHT ( (::nAlto * 0.26) * ::nLineas ) ;
         FONT "COURIER NEW" SIZE 9 BOLD ;
         FONTCOLOR WHITE ;
         BACKCOLOR { 45, 24,160} ;
         CENTERALIGN

      if ::bStopButton
         @ ::nAlto - 30 , ::nAncho - 95 BUTTON BStop ;
            OF &(::MGWaitPan) ;
            CAPTION "Stop" ;
            ACTION ( SetProperty( ::MGWaitPan , "bStop" , "enabled" , .F. ) , ::bStop := .T. , SetProperty( ::MGWaitPan , "bStop" , "caption" , "Wait..." ) ) ;
            WIDTH 85 ;
            HEIGHT 20
      endif

   else

      if US_IsWindowMainActive()

         DEFINE WINDOW &(::MGWaitPan) at 0,0 ;
            WIDTH ::nImagenWidth ;
            HEIGHT ::nImagenHeight ;
            USMODAL ;
            NOSIZE ;
            NOSYSMENU ;
            NOCAPTION
         END WINDOW

      else

         DEFINE WINDOW &(::MGWaitPan) at 0,0 ;
            WIDTH ::nImagenWidth ;
            HEIGHT ::nImagenHeight ;
            MAIN ;
            NOSIZE ;
            NOSYSMENU ;
            NOCAPTION
         END WINDOW

      endif

      if ::bAnimated
         @ 0 , 0 ANIMATEBOX Imagen ;
            OF &(::MGWaitPan) ;
            WIDTH  &(::MGWaitPan).Width ;
            HEIGHT &(::MGWaitPan).Height ;
            FILE ::cImagen ;
            AUTOPLAY
      else
         @ 0 , 0 IMAGE Imagen ;
            OF &(::MGWaitPan) ;
            PICTURE ::cImagen ;
            WIDTH  &(::MGWaitPan).Width ;
            HEIGHT &(::MGWaitPan).Height
      endif

      DEFINE TIMER MGWaitTimer ;
         OF &(::MGWaitPan) ;
         INTERVAL ::nTimerRefresh ;
         ACTION ::MGWaitRefresh()

      if ::cSkin = "VP"
         US_SetWindowRgn( ::MGWaitPan , 0 , 0 , GetProperty( ::MGWaitPan , "Height" ) , GetProperty( ::MGWaitPan , "Height") , 2 )
      endif

   endif
return Self

METHOD Destroy() CLASS US_MGWaitNew
return NIL

METHOD Ejecutar( cFun ) CLASS US_MGWaitNew

   ::cFuncion := cFun

   if !empty( ::cTXT )
      ::bTxt := .T.
    //::nLineas := MLCOUNT( ::cTXT , 254 )
      ::nLineas := 1
    //US_LOG("  Texto: " + ::cTXT , .F. )
   endif

   if !empty( ::nFila ) .and. ::nFila != -1
      ::bFila := .T.
      ::nRow := ::nFila
      ::nCol := ( GetDesktopRealWidth() - ::nAncho ) / 2
    //US_LOG("   Fila: " + US_VarToStr( ::nFila ) , .F. )
   endif

   DO EVENTS

   ::Create()

   DO EVENTS

   if !::bFila
   //CdQ CENTER WINDOW &( ::MGWaitPan )
      DoMethod( ::MGWaitPan , "center" )
      DO EVENTS
   endif

   if ::cSkin = "VP"
      US_WinStackAdd( @RN_WinStack , ::MGWaitPan )
   endif

   ACTIVATE WINDOW &( ::MGWaitPan ) NOWAIT

   ::Reto := eval( {|| &(::cFuncion) } )

   DoMethod( ::MGWaitPan , "Release" )

   DO EVENTS

   if ::cSkin = "VP"
      US_WinStackDel( @RN_WinStack , ::MGWaitPan )
   endif

// US_LOG("   despues de Window, retorno: " + US_VarToStr( ::Reto ) , .F. )
return ::Reto

//----------------------------------------------------------------------------------\\
//= END CLASE US_MGWaitNew                                                         =\\
//==================================================================================\\

//==================================================================================\\
//= CLASE US_Modelo                                                                =\\
//----------------------------------------------------------------------------------\\

CLASS US_Modelo

   METHOD New()                                  && Crear el Objeto
   METHOD Destroy()                              && Destruir el Objeto

// DATA cFile         HIDDEN              init NIL            && Archivo para procesar
// DATA cFile         EXPORTED            init NIL            && Archivo para procesar
ENDCLASS

METHOD New() CLASS US_Modelo
return Self

METHOD Destroy() CLASS US_Modelo
return NIL

//----------------------------------------------------------------------------------\\
//= END CLASE US_Modelo                                                            =\\
//==================================================================================\\

/* eof */
