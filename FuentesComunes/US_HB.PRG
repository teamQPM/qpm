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

#include "US_ENV.H"
#include "fileio.ch"
#include "minigui.ch"

#xcommand ? <texto> => US_LOG( <texto> , .T. )
#translate inkey(0) => US_LOG("Inkey(0) , Presione Enter" , .T. )

Function US_FirstChar( cLine )
Return Len( cLine ) - Len( ltrim( cLine ) ) + 1

Function US_IsRootFolder( cFolder )
Return if( substr( alltrim( cFolder ) , 2 , 1 ) == ":" .and. len( alltrim( cFolder ) ) == 2 , .T. , .F. )

Function US_ListAlias()
   LOCAL aLista := {} , nInx := 0
   for nInx := 1 to 254
      if !empty( alias( nInx ) )
         aadd( aLista , { nInx , alias( nInx ) } )
      endif
   next
Return aLista

Function US_Use( bNew , cDriver , cName , cAlias , ExclusiveShared , WriteRead )

   Local w_espera := 5

   do while w_espera > 0
      DBUseArea( bNew , cDriver , cName , cAlias , ExclusiveShared , WriteRead )

      if ! neterr()
         return .T.
      endif

      inkey(0.5)
      w_espera -= 0.5
   enddo

Return .F.

Function US_At( par_cSearch , par_cString , par_nStart , par_nEnd )
   Local Loc_nAux := 0
   if par_nStart == NIL
      Return At( par_cSearch , par_cString )
   else
      if par_nEnd == NIL
         Loc_nAux := at( par_cSearch , SubStr( par_cString , par_nStart ) )
         if Loc_nAux > 0
            Return ( par_nStart - 1 ) + Loc_nAux
         endif
      else
         Loc_nAux := at( par_cSearch , SubStr( par_cString , par_nStart , par_nEnd - par_nStart + 1 ) )
         if Loc_nAux > 0
            Return ( par_nStart - 1 ) + Loc_nAux
         endif
      endif
   endif
Return 0

*//========================================================================\\*
*// FUNCION PARA TRATAMIENTO DE CAMPOS DE DBF
*// Modo: ADD, DELETE, MOD
*//
*// ADD: AGREGA UN CAMPO, REQUIERE NOMBRE, TIPO Y LONGITUD
*// DEL: ELIMINA UN CAMPO, REQUIERE NOMBRE
*// MOD: MODIFICA EL ANCHO DE LA COLUMNA
*//========================================================================\\*
FUNCTION US_DB_CMP(cTabla,cModo,CAMPO,TIPO,LONGI,DEC)
   LOCAL vStruct:={}, vStructDelete:={}, SALIR:=.F., cTablaBAK:="", POS:=0, I:=0, ;
         REGISTROS:=0 , cMemoExtType := ".DBT" , cDriver := "DBFNTX" , cDbfOld := dbf()
   cModo:=UPPER(cModo)
   IF (cModo == "ADD") .AND. (TIPO=="C" .OR. TIPO=="N") .AND. (LONGI==NIL .OR. LONGI < 1)
      ? "ERROR EN PARAMETRO LONGITUD DE FUNCION US_DB_CMP PARA CAMPO: "+CAMPO
      ? "SE HA RECIBIDO: "+US_TODOSTR(LONGI)
      INKEY(0)
      RETURN 8
   ENDIF
   IF LONGI==NIL
      LONGI:=0
   ENDIF
   IF DEC==NIL
      DEC:=0
   ENDIF
   IF cModo == "DELETE"
      cModo := "DEL"
   ENDIF
   IF AT(".",cTabla) > 0
      ? "ERROR EN NOMBRE DE TABLA, DEBE IR SIN EXTENCION."
      INKEY(0)
      RETURN 12
   ENDIF
   if file( cTabla+".FPT" )
      cMemoExtType := ".FPT"
      cDriver := "DBFCDX"
   endif
   DO CASE
      CASE cModo=="ADD"
         IF FILE(cTabla+".DBF")
            US_Use( .T. , cDriver , cTabla )
            REGISTROS:=RECCOUNT()
            vStruct:=DBSTRUCT()
            DbCloseArea( cTabla )
            DO WHILE !SALIR
               cTablaBAK:=US_FileNameOnlyPathAndName( cTabla ) + "_T"+ALLTRIM(STR(INT(SECONDS())))
               IF !FILE(cTablaBAK+".DBF") .AND. !FILE(cTablaBAK+cMemoExtType)
                  frename( cTabla+".DBF" , cTablaBAK+".DBF" )
                  IF FILE(cTabla+cMemoExtType)
                     frename( cTabla+cMemoExtType , cTablaBAK+cMemoExtType )
                  ENDIF
                  SALIR=.T.
               ENDIF
            ENDDO
         ELSE
            if !empty( cDbfOld )
               DbSelectArea( cDbfOld )
            endif
            RETURN 20
         ENDIF
         AADD(vStruct,{CAMPO,TIPO,LONGI,DEC})
         DBCREATE(cTabla+".DBF",vStruct)
         IF REGISTROS > 0
            US_Use( .T. , cDriver , cTabla )
            APPEND FROM (cTablaBAK)
            DbCloseArea( cTabla )
         ENDIF
         IF FILE(cTablaBAK+".DBF")
            ferase( cTablaBAK+".DBF" )
         ENDIF
         IF FILE(cTablaBAK+cMemoExtType)
            ferase( cTablaBAK+cMemoExtType )
         ENDIF
         if !empty( cDbfOld )
            DbSelectArea( cDbfOld )
         endif
         RETURN 0
      CASE cModo=="DEL"
         IF FILE(cTabla+".DBF")
            US_Use( .T. , cDriver , cTabla )
            REGISTROS:=RECCOUNT()
            vStructDelete:=DBSTRUCT()
            DbCloseArea( cTabla )
            POS:=ASCAN(vStructDelete, {|aVal| aVal[1] == CAMPO})
            IF POS<1
               ? "ERROR, CAMPO :"+CAMPO+", NO EXISTE EN LA Tabla: "+cTabla
               ? "FUNCION US_DB_CMP"
               INKEY(0)
               if !empty( cDbfOld )
                  DbSelectArea( cDbfOld )
               endif
               RETURN 8
            ELSE
               FOR I=1 TO LEN(vStructDelete)
                   IF I != POS
                      AADD(vStruct,{vStructDelete[I][1],vStructDelete[I][2],vStructDelete[I][3],vStructDelete[I][4]})
                   ENDIF
               NEXT
            ENDIF
            DO WHILE !SALIR
               cTablaBAK:=US_FileNameOnlyPathAndName( cTabla ) + "_T"+ALLTRIM(STR(INT(SECONDS())))
               IF !FILE(cTablaBAK+".DBF") .AND. !FILE(cTablaBAK+cMemoExtType)
                  frename( cTabla+".DBF" , cTablaBAK+".DBF" )
                  IF FILE(cTabla+cMemoExtType)
                     frename( cTabla+cMemoExtType , cTablaBAK+cMemoExtType )
                  ENDIF
                  SALIR:=.T.
               ENDIF
            ENDDO
         ELSE
            if !empty( cDbfOld )
               DbSelectArea( cDbfOld )
            endif
            RETURN 20
         ENDIF
         DBCREATE(cTabla+".DBF",vStruct)
         IF REGISTROS > 0
         // cuidado cuando cancela aca, puede ser porque la base estaba abierta de antes o porque el campo que borrarmos era clave de un indice en CDX mode y el indice existe...
            US_Use( .T. , cDriver , cTabla )
            APPEND FROM (cTablaBAK)
            DbCloseArea( cTabla )
         ENDIF
         IF FILE(cTablaBAK+".DBF")
            ferase( cTablaBAK+".DBF" )
         ENDIF
         IF FILE(cTablaBAK+cMemoExtType)
            ferase( cTablaBAK+cMemoExtType )
         ENDIF
         if !empty( cDbfOld )
            DbSelectArea( cDbfOld )
         endif
         RETURN 0
      CASE cModo=="MOD"
         US_DB_CMP(cTabla,"ADD","A________A",TIPO,LONGI,DEC)
         US_Use( .T. , cDriver , cTabla )
         REPLACE A________A WITH &(CAMPO) ALL
         DbCloseArea( cTabla )
         US_DB_CMP(cTabla,"DEL",CAMPO)
         US_DB_CMP(cTabla,"ADD",CAMPO,TIPO,LONGI,DEC)
         US_Use( .T. , cDriver , cTabla )
         REPLACE &(CAMPO) WITH A________A ALL
         DbCloseArea( cTabla )
         US_DB_CMP(cTabla,"DEL","A________A")
         if !empty( cDbfOld )
            DbSelectArea( cDbfOld )
         endif
         RETURN 0
      OTHERWISE
         ? "ERROR EN FUNCION US_DB_CMP, PARAMETRO 'MODO' ES INVALIDO: "+US_TODOSTR(cModo)
         INKEY(0)
   ENDCASE
   if !empty( cDbfOld )
      DbSelectArea( cDbfOld )
   endif
RETURN 8

Function US_ExtractMemoKey( cMemo , cKey )
   Local nInx := 0
   for nInx := 1 to MLCount( cMemo , 254 )
      if Upper( US_Word( MemoLine( cMemo , 254 , nInx ) , 1 ) ) == upper( cKey )
         Return US_WordSubstr( MemoLine( cMemo , 254 , nInx ) , 2 )
      endif
   next
Return NIL

//Function US_IsInternet()
//   local oSock, lRet := .f.
//   local cServer := "www.microsoft.com"
//   local nPort := 80
//   oSock := TSocket():New()
//   if oSock:Connect( cServer, nPort )
//      lRet := .t.
//   endif
//   oSock:Close()
//Return lRet

/*
Function US_IsInternet()
Return CallDLL32( "WININET.DLL" , "InternetGetConnectedStateEx" , 0 , "" , 0 , 0 )
*/

//==================================================================================\\
//= Function US_DBConvert                                                          =\\
//= Use:                                                                           =\\
//= US_DBConvert( cBaseIn , cBaseOut , cFrom , cTarget )                           =\\
//=                                                                                =\\
//= Donde cFrom puede ser "DBFNTX"  o  "DBFCDX"                                    =\\
//=  y    cTarget el inverso                                                       =\\
//=                                                                                =\\
//=  Retorna .T. en caso de exito o .F. si no pudo convertir o estan los parametros=\\
//=  mal codificados                                                               =\\
//----------------------------------------------------------------------------------\\
Function US_DBConvert( cBaseIn , cBaseOut , cFrom , cTarget )
   Local vStruct := {} , cAreaOld := dbf()
   Request DBFCDX , DBFFPT
   if ( upper( cFrom ) == "DBFNTX" .and. upper( cTarget ) == "DBFCDX" ) .or. ;
      ( upper( cFrom ) == "DBFCDX" .and. upper( cTarget ) == "DBFNTX" )
      if !file( cBaseIn )
         US_Log( "Source Database not found: " + cBaseIn )
         return .F.
      endif
      if file( cBaseOut )
         US_Log( "Target Database already exists: " + cBaseOut )
         return .F.
      endif
      US_Use( .t. , cFrom , cBaseIn , "cBaseIn" )
      vStruct := dbstruct()
      dbclosearea( "cBaseIn" )
      dbCreate( cBaseOut , vStruct , cTarget , .t. , "cBaseOut" )
      append from (cBaseIn) VIA cFrom
      dbclosearea( "cBaseOut" )
      if !empty( cAreaOld )
         dbselectarea( cAreaOld )
      endif
   else
      US_Log( "Invalid From o Target tipe, From: " + cFrom + " // Target: " + cTarget )
      return .F.
   endif
Return .T.

Function US_MaskBinData( x )
   x := StrTran( x , chr(26) , '\\#26//' )
   x := StrTran( x , chr(00) , '\\#00//' )
return x

Function US_UnMaskBinData( x )
   x := StrTran( x , '\\#26//' , chr(26) )
   x := StrTran( x , '\\#00//' , chr(00) )
return x

Function US_Setup()
   SET ESCAPE OFF
   SET EXACT ON
   SET SCOREBOARD OFF
   SET WRAP ON
   SET DATE BRITISH
   SET DELETED ON
   SET TYPEAHEAD TO 80
   PUBLIC K_UP       ,;
      K_DOWN         ,;
      K_LEFT         ,;
      K_RIGHT        ,;
      K_HOME         ,;
      K_END          ,;
      K_PGUP         ,;
      K_PGDN         ,;
      K_CTRL_UP      ,;
      K_CTRL_DOWN    ,;
      K_CTRL_LEFT    ,;
      K_CTRL_RIGHT   ,;
      K_CTRL_HOME    ,;
      K_CTRL_END     ,;
      K_CTRL_PGUP    ,;
      K_CTRL_PGDN    ,;
      K_ALT_UP       ,;
      K_ALT_DOWN     ,;
      K_ALT_LEFT     ,;
      K_ALT_RIGHT    ,;
      K_ALT_HOME     ,;
      K_ALT_END      ,;
      K_ALT_PGUP     ,;
      K_ALT_PGDN     ,;
      K_ENTER        ,;
      K_RETURN       ,;
      K_SPACE        ,;
      K_ESC          ,;
      K_CTRL_ENTER   ,;
      K_CTRL_RETURN  ,;
      K_CTRL_RET     ,;
      K_CTRL_PRTSCR  ,;
      K_CTRL_QUESTION,;
      K_ALT_ENTER    ,;
      K_ALT_RETURN   ,;
      K_ALT_EQUALS   ,;
      K_ALT_ESC      ,;
      KP_ALT_ENTER   ,;
      KP_CTRL_5      ,;
      KP_CTRL_SLASH  ,;
      KP_CTRL_ASTERISK ,;
      KP_CTRL_MINUS    ,;
      KP_CTRL_PLUS     ,;
      KP_ALT_5         ,;
      KP_ALT_SLASH     ,;
      KP_ALT_ASTERISK  ,;
      KP_ALT_MINUS     ,;
      KP_ALT_PLUS      ,;
      K_INS            ,;
      K_DEL            ,;
      K_BS             ,;
      K_TAB            ,;
      K_SH_TAB         ,;
      K_CTRL_INS       ,;
      K_CTRL_DEL       ,;
      K_CTRL_BS        ,;
      K_CTRL_TAB       ,;
      K_ALT_INS        ,;
      K_ALT_DEL        ,;
      K_ALT_BS         ,;
      K_ALT_TAB        ,;
      K_CTRL_A     ,;
      K_CTRL_B     ,;
      K_CTRL_C     ,;
      K_CTRL_D     ,;
      K_CTRL_E     ,;
      K_CTRL_F     ,;
      K_CTRL_G     ,;
      K_CTRL_H     ,;
      K_CTRL_I     ,;
      K_CTRL_J     ,;
      K_CTRL_K     ,;
      K_CTRL_L     ,;
      K_CTRL_M     ,;
      K_CTRL_N     ,;
      K_CTRL_O     ,;
      K_CTRL_P     ,;
      K_CTRL_Q     ,;
      K_CTRL_R     ,;
      K_CTRL_S     ,;
      K_CTRL_T     ,;
      K_CTRL_U     ,;
      K_CTRL_V     ,;
      K_CTRL_W     ,;
      K_CTRL_X     ,;
      K_CTRL_Y     ,;
      K_CTRL_Z     ,;
      K_ALT_A      ,;
      K_ALT_B      ,;
      K_ALT_C      ,;
      K_ALT_D      ,;
      K_ALT_E      ,;
      K_ALT_F      ,;
      K_ALT_G      ,;
      K_ALT_H      ,;
      K_ALT_I      ,;
      K_ALT_J      ,;
      K_ALT_K      ,;
      K_ALT_L      ,;
      K_ALT_M      ,;
      K_ALT_N      ,;
      K_ALT_O      ,;
      K_ALT_P      ,;
      K_ALT_Q      ,;
      K_ALT_R      ,;
      K_ALT_S      ,;
      K_ALT_T      ,;
      K_ALT_U      ,;
      K_ALT_V      ,;
      K_ALT_W      ,;
      K_ALT_X      ,;
      K_ALT_Y      ,;
      K_ALT_Z      ,;
      K_ALT_1      ,;
      K_ALT_2      ,;
      K_ALT_3      ,;
      K_ALT_4      ,;
      K_ALT_5      ,;
      K_ALT_6      ,;
      K_ALT_7      ,;
      K_ALT_8      ,;
      K_ALT_9      ,;
      K_ALT_0      ,;
      K_F1         ,;
      K_F2         ,;
      K_F3         ,;
      K_F4         ,;
      K_F5         ,;
      K_F6         ,;
      K_F7         ,;
      K_F8         ,;
      K_F9         ,;
      K_F10        ,;
      K_F11        ,;
      K_F12        ,;
      K_CTRL_F1    ,;
      K_CTRL_F2    ,;
      K_CTRL_F3    ,;
      K_CTRL_F4    ,;
      K_CTRL_F5    ,;
      K_CTRL_F6    ,;
      K_CTRL_F7    ,;
      K_CTRL_F8    ,;
      K_CTRL_F9    ,;
      K_CTRL_F10   ,;
      K_CTRL_F11   ,;
      K_CTRL_F12   ,;
      K_ALT_F1     ,;
      K_ALT_F2     ,;
      K_ALT_F3     ,;
      K_ALT_F4     ,;
      K_ALT_F5     ,;
      K_ALT_F6     ,;
      K_ALT_F7     ,;
      K_ALT_F8     ,;
      K_ALT_F9     ,;
      K_ALT_F10    ,;
      K_ALT_F11    ,;
      K_ALT_F12    ,;
      K_SH_F1      ,;
      K_SH_F2      ,;
      K_SH_F3      ,;
      K_SH_F4      ,;
      K_SH_F5      ,;
      K_SH_F6      ,;
      K_SH_F7      ,;
      K_SH_F8      ,;
      K_SH_F9      ,;
      K_SH_F10     ,;
      K_SH_F11     ,;
      K_SH_F12     ,;
      GBL_COMILLAS:='"' ,;
      LETRA_A:="A" ,;
      LETRA_R:="R" ,;
      LETRA_S:="S" ,;
      LETRA_T:="T" ,;
      LETRA_V:="V" ,;
      LETRA_N:="N"
   /***
   *
   * Inkey.ch
   *
   * Standard INKEY() key-code definitions
   *
   * Copyright (c) 1990-1993, Computer Associates International, Inc.
   * All rights reserved.
   *
   * NOTE: Keystroke descriptions marked with an asterick (*) are only
   *    available on enhanced keyboards (those with more than 84 keys)
   *
   */

   // Cursor movement keys

   K_UP          =  5   //   Up arrow, Ctrl-E
   K_DOWN        = 24   //   Down arrow, Ctrl-X
   K_LEFT        = 19   //   Left arrow, Ctrl-S
   K_RIGHT       =  4   //   Right arrow, Ctrl-D
   K_HOME        =  1   //   Home, Ctrl-A
   K_END         =  6   //   End, Ctrl-F
   K_PGUP        = 18   //   PgUp, Ctrl-R
   K_PGDN        =  3   //   PgDn, Ctrl-C

   K_CTRL_UP     =397   // * Ctrl-Up arrow
   K_CTRL_DOWN   =401   // * Ctrl-Down arrow
   K_CTRL_LEFT   = 26   //   Ctrl-Left arrow, Ctrl-Z
   K_CTRL_RIGHT  =  2   //   Ctrl-Right arrow, Ctrl-B
   K_CTRL_HOME   = 29   //   Ctrl-Home, Ctrl-]
   K_CTRL_END    = 23   //   Ctrl-End, Ctrl-W
   K_CTRL_PGUP   = 31   //   Ctrl-PgUp, Ctrl-Hyphen
   K_CTRL_PGDN   = 30   //   Ctrl-PgDn, Ctrl-^

   K_ALT_UP      =408   // * Alt-Up arrow
   K_ALT_DOWN    =416   // * Alt-Down arrow
   K_ALT_LEFT    =411   // * Alt-Left arrow
   K_ALT_RIGHT   =413   // * Alt-Right arrow
   K_ALT_HOME    =407   // * Alt-Home
   K_ALT_END     =415   // * Alt-End
   K_ALT_PGUP    =409   // * Alt-PgUp
   K_ALT_PGDN    =417   // * Alt-PgDn

   // Misc. keys

   K_ENTER       = 13   //   Enter, Ctrl-M
   K_RETURN      = 13   //   Return, Ctrl-M
   K_SPACE       = 32   //   Space bar
   K_ESC         = 27   //   Esc, Ctrl-[

   K_CTRL_ENTER  = 10   //   Ctrl-Enter
   K_CTRL_RETURN = 10   //   Ctrl-Return
   K_CTRL_RET    = 10   //   Ctrl-Return (Compat.)
   K_CTRL_PRTSCR =379   // * Ctrl-Print Screen
   K_CTRL_QUESTION =309 //   Ctrl-?

   K_ALT_ENTER   =284   // * Alt-Enter
   K_ALT_RETURN  =284   // * Alt-Return
   K_ALT_EQUALS  =387   // * Alt-Equals
   K_ALT_ESC     =257   // * Alt-Esc

   // Keypad keys

   KP_ALT_ENTER  =422   // * Keypad Alt-Enter

   KP_CTRL_5     =399   // * Keypad Ctrl-5
   KP_CTRL_SLASH =405   // * Keypad Ctrl-/
   KP_CTRL_ASTERISK =406 // * Keypad Ctrl-*
   KP_CTRL_MINUS =398   // * Keypad Ctrl--
   KP_CTRL_PLUS  =400   // * Keypad Ctrl-+

   KP_ALT_5      =  5   // * Keypad Alt-5
   KP_ALT_SLASH  =420   // * Keypad Alt-/
   KP_ALT_ASTERISK =311 // * Keypad Alt-*
   KP_ALT_MINUS  =330   // * Keypad Alt--
   KP_ALT_PLUS   =334   // * Keypad Alt-+

   // Editing keys

   K_INS         = 22   //   Ins, Ctrl-V
   K_DEL         =  7   //   Del, Ctrl-G
   K_BS          =  8   //   Backspace, Ctrl-H
   K_TAB         =  9   //   Tab, Ctrl-I
   K_SH_TAB      =271   //   Shift-Tab

   K_CTRL_INS    =402   // * Ctrl-Ins
   K_CTRL_DEL    =403   // * Ctrl-Del
   K_CTRL_BS     =127   //   Ctrl-Backspace
   K_CTRL_TAB    =404   // * Ctrl-Tab

   K_ALT_INS     =418   // * Alt-Ins
   K_ALT_DEL     =419   // * Alt-Del
   K_ALT_BS      =270   // * Alt-Backspace
   K_ALT_TAB     =421   // * Alt-Tab

   // Control keys

   K_CTRL_A      =  1   //   Ctrl-A, Home
   K_CTRL_B      =  2   //   Ctrl-B, Ctrl-Right arrow
   K_CTRL_C      =  3   //   Ctrl-C, PgDn, Ctrl-ScrollLock
   K_CTRL_D      =  4   //   Ctrl-D, Right arrow
   K_CTRL_E      =  5   //   Ctrl-E, Up arrow
   K_CTRL_F      =  6   //   Ctrl-F, End
   K_CTRL_G      =  7   //   Ctrl-G, Del
   K_CTRL_H      =  8   //   Ctrl-H, Backspace
   K_CTRL_I      =  9   //   Ctrl-I, Tab
   K_CTRL_J      = 10  //   Ctrl-J
   K_CTRL_K      = 11  //   Ctrl-K
   K_CTRL_L      = 12  //   Ctrl-L
   K_CTRL_M      = 13  //   Ctrl-M, Return
   K_CTRL_N      = 14  //   Ctrl-N
   K_CTRL_O      = 15  //   Ctrl-O
   K_CTRL_P      = 16  //   Ctrl-P
   K_CTRL_Q      = 17  //   Ctrl-Q
   K_CTRL_R      = 18  //   Ctrl-R, PgUp
   K_CTRL_S      = 19  //   Ctrl-S, Left arrow
   K_CTRL_T      = 20  //   Ctrl-T
   K_CTRL_U      = 21  //   Ctrl-U
   K_CTRL_V      = 22  //   Ctrl-V, Ins
   K_CTRL_W      = 23  //   Ctrl-W, Ctrl-End
   K_CTRL_X      = 24  //   Ctrl-X, Down arrow
   K_CTRL_Y      = 25  //   Ctrl-Y
   K_CTRL_Z      = 26  //   Ctrl-Z, Ctrl-Left arrow

   // Alt keys

   K_ALT_A       =  286  //   Alt-A
   K_ALT_B       =  304  //   Alt-B
   K_ALT_C       =  302  //   Alt-C
   K_ALT_D       =  288  //   Alt-D
   K_ALT_E       =  274  //   Alt-E
   K_ALT_F       =  289  //   Alt-F
   K_ALT_G       =  290  //   Alt-G
   K_ALT_H       =  291  //   Alt-H
   K_ALT_I       =  279  //   Alt-I
   K_ALT_J       =  292  //   Alt-J
   K_ALT_K       =  293  //   Alt-K
   K_ALT_L       =  294  //   Alt-L
   K_ALT_M       =  306  //   Alt-M
   K_ALT_N       =  305  //   Alt-N
   K_ALT_O       =  280  //   Alt-O
   K_ALT_P       =  281  //   Alt-P
   K_ALT_Q       =  272  //   Alt-Q
   K_ALT_R       =  275  //   Alt-R
   K_ALT_S       =  287  //   Alt-S
   K_ALT_T       =  276  //   Alt-T
   K_ALT_U       =  278  //   Alt-U
   K_ALT_V       =  303  //   Alt-V
   K_ALT_W       =  273  //   Alt-W
   K_ALT_X       =  301  //   Alt-X
   K_ALT_Y       =  277  //   Alt-Y
   K_ALT_Z       =  300  //   Alt-Z
   K_ALT_1       =  376  //   Alt-1
   K_ALT_2       =  377  //   Alt-2
   K_ALT_3       =  378  //   Alt-3
   K_ALT_4       =  379  //   Alt-4
   K_ALT_5       =  380  //   Alt-5
   K_ALT_6       =  381  //   Alt-6
   K_ALT_7       =  382  //   Alt-7
   K_ALT_8       =  383  //   Alt-8
   K_ALT_9       =  384  //   Alt-9
   K_ALT_0       =  385  //   Alt-0

   // Function keys

   K_F1          = 28   //   F1, Ctrl-Backslash
   K_F2          = -1   //   F2
   K_F3          = -2   //   F3
   K_F4          = -3   //   F4
   K_F5          = -4   //   F5
   K_F6          = -5   //   F6
   K_F7          = -6   //   F7
   K_F8          = -7   //   F8
   K_F9          = -8   //   F9
   K_F10         = -9   //   F10
   K_F11         =-40   // * F11
   K_F12         =-41   // * F12

   // Control-function keys

   K_CTRL_F1     =  -20  //   Ctrl-F1
   K_CTRL_F2     =  -21  //   Ctrl-F2
   K_CTRL_F3     =  -22  //   Ctrl-F4
   K_CTRL_F4     =  -23  //   Ctrl-F3
   K_CTRL_F5     =  -24  //   Ctrl-F5
   K_CTRL_F6     =  -25  //   Ctrl-F6
   K_CTRL_F7     =  -26  //   Ctrl-F7
   K_CTRL_F8     =  -27  //   Ctrl-F8
   K_CTRL_F9     =  -28  //   Ctrl-F9
   K_CTRL_F10    =  -29  //   Ctrl-F10
   K_CTRL_F11    =  -44  // * Ctrl-F11
   K_CTRL_F12    =  -45  // * Ctrl-F12

   // Alt-function keys

   K_ALT_F1      = -30  //   Alt-F1
   K_ALT_F2      = -31  //   Alt-F2
   K_ALT_F3      = -32  //   Alt-F3
   K_ALT_F4      = -33  //   Alt-F4
   K_ALT_F5      = -34  //   Alt-F5
   K_ALT_F6      = -35  //   Alt-F6
   K_ALT_F7      = -36  //   Alt-F7
   K_ALT_F8      = -37  //   Alt-F8
   K_ALT_F9      = -38  //   Alt-F9
   K_ALT_F10     = -39  //   Alt-F10
   K_ALT_F11     = -46  // * Alt-F11
   K_ALT_F12     = -47  // * Alt-F12

   // Shift-function keys

   K_SH_F1       =-10  //   Shift-F1
   K_SH_F2       =-11  //   Shift-F2
   K_SH_F3       =-12  //   Shift-F3
   K_SH_F4       =-13  //   Shift-F4
   K_SH_F5       =-14  //   Shift-F5
   K_SH_F6       =-15  //   Shift-F6
   K_SH_F7       =-16  //   Shift-F7
   K_SH_F8       =-17  //   Shift-F8
   K_SH_F9       =-18  //   Shift-F9
   K_SH_F10      =-19  //   Shift-F10
   K_SH_F11      =-42  // * Shift-F11
   K_SH_F12      =-43  // * Shift-F12

   Descend("P") && PARA CARGAR LA FUNCION DESCEND QUE ES UTILIZADA EN INDICES

RETURN .T.


Function US_DBSkip( num )
   if empty( num )
      num:=0
   endif
   if num = 0
      if deleted()
         DBSkip(1)
      endif
      if eof()
         DBSkip(-1)
      endif
   else
      DBSkip( num )
   endif
Return .T.

Function US_NameRandom()
Return ALLTRIM(strtran(strtran(STR(seconds()),".",alltrim(str(US_Rand(seconds())))),"-","M"))

*FUNCTION OSVER()
*RETURN "00"

*FUNCTION TOOLVER()
*RETURN "00"

*FUNCTION CSetCurs(Param)
*RETURN .T.

*FUNCTION FILESEEK(Param)
*? "Funcion FILESEEK no disponible en Harbour"
*INKEY(0)
*RETURN

*FUNCTION ISBIT(Param)
*? "Funcion ISBIT no disponible en Harbour"
*INKEY(0)
*RETURN

*FUNCTION FILEATTR(Param)
*? "Funcion FILEATTR no disponible en Harbour"
*INKEY(0)
*RETURN

*FUNCTION SAVEFSEEK(Param)
*? "Funcion SAVEFSEEK no disponible en Harbour"
*INKEY(0)
*RETURN

*FUNCTION RESTFSEEK(Param)
*? "Funcion RESTFSEEK no disponible en Harbour"
*INKEY(0)
*RETURN

#ifndef __XHARBOUR__
FUNCTION DISKFREE(Param)
? "Funcion DISKFREE no disponible en Harbour, Use US_DiskSpace"
INKEY(0)
RETURN
#endif

*FUNCTION NUMFILES(Param)
*? "Funcion NUMFILES no disponible en Harbour"
*INKEY(0)
*RETURN

*FUNCTION CSETCLIP(Param)
*? "Funcion CSETCLIP no disponible en Harbour"
*INKEY(0)
*RETURN

FUNCTION US_DBCLOSEAREA(PARAM)
RETURN US_DBCLOSE(PARAM)

*FUNCTION DECTOOCTAL(Param)
*? "Funcion DECTOOCTAL no estaba disponible, mensaje enviado desde RN_HB.prg"
*INKEY(0)
*RETURN

*FUNCTION OCTALTODEC(Param)
*? "Funcion OCTALTODEC no estaba disponible, mensaje enviado desde RN_HB.prg"
*INKEY(0)
*RETURN

Function US_FileSize(cFile)
   Local vFile
   vFile:=DIRECTORY( cFile , "HS" )
   if len(vFile) = 1
      Return vFile[1][2]
   endif
Return -1

Function US_FileDate(cFile)
   Local vFile
   vFile:=DIRECTORY( cFile , "HS" )
   if len(vFile) = 1
      Return vFile[1][3]
   endif
Return -1

Function US_FileTime(cFile)
   Local vFile
   vFile:=DIRECTORY( cFile , "HS" )
   if len(vFile) = 1
      Return vFile[1][4]
   endif
Return -1

Function US_FileType(cFile)
   Local vFile, CurrentDisk:="" , CurrentDir:=""
   if rat(DEF_SLASH,cFile) = len(cFile)
      cFile:=substr(cFile,1,len(cFile)-1)
   endif
   if len(cFile)=2 .and. rat(":",cFile)=2
      CurrentDisk:=Diskname()
      CurrentDir :=CurDir()
      if Diskchange(cFile)
         DiskChange(CurrentDisk+":")
         DirChange(CurrentDir)
         Return "D"
      else
         Return ""
      endif
   endif
   vFile:=DIRECTORY( cFile , "HSD" )
   if len(vFile) = 1
      if at("D",vFile[1][5]) > 0
         Return "D"
      else
         if at("A",vFile[1][5]) > 0
            Return "A"
         endif
      endif
   endif
Return ""

Function US_DiskSpace(Letra)
   Local DiskTemp, nTam:=-1 , CurDir:=""
   DiskTemp:=Diskname()
   CurDir  :=CurDir()
   IF DiskChange(Letra+":")
      nTam:=DiskSpace()
      DiskChange(DiskTemp+":")
      DirChange(CurDir)
   endif
Return nTam

//==================================================================================\\
//= Function US_SeekFile                                                           =\\
//= Use:                                                                           =\\
//= US_SeekFile(@vVectorDeResultados, cDiscoInicioBusqueda, cBaseFolderBusqueda, cArchivoBuscado, {| cNextFolder | ProgressSeek( cNextFolder )}, {| cFileFound | ProgressFileFound( cFileFound )},@bStopSeek)
//= Retorna:                                                                       =\\
//=  >=0 = Cantidad de Archivos encontrados                                        =\\
//=   -1 = Stop de usuario                                                         =\\
//=   -2 = Error en parametros                                                     =\\
//----------------------------------------------------------------------------------\\
Function US_SeekFile(Vector, Disco, BaseFolder, Archivo, bBloqueNextFolder, bBloqueFileFound, bStopSeek)
LOCAL inx, R, aFiles, aDirec, nCant:=0, NextFolder, RetornoRecursivo:=0
if pcount() < 5
   us_log("Error en parámetros de US_SeekFile, Parámetros esperados: VectorDeResultados (por referencia), Disco, BaseFolder, Archivo, bBloqueNextFolder, bBloqueFileFound, VariableBooleanaParaStop (por referencia) (Opcional)",.t.)
   return -2
endif
if Disco = NIL
   Disco=Diskname()+":" + DEF_SLASH
endif
if len(Disco) > 1
   Disco:=substr(Disco,1,1)+":" + DEF_SLASH
else
   Disco:=Disco+":" + DEF_SLASH
endif

if empty(bStopSeek)
   bStopSeek:=.F.
endif

if BaseFolder = NIL .OR. BaseFolder == "" .OR. BaseFolder == DEF_SLASH
   BaseFolder:=""
else
   BaseFolder:=BaseFolder + If ( Right ( BaseFolder , 1 ) != DEF_SLASH , DEF_SLASH , '' )
endif

NextFolder:=Disco + BaseFolder

if !empty(bBloqueNextFolder)
   eval(bBloqueNextFolder, NextFolder)
endif
if bStopSeek
   return -1
endif

aFiles:=DIRECTORY( NextFolder + Archivo, "HS" )
aDirec:=DIRECTORY( NextFolder + "*.*", "HSD" )

if len(aFiles) > 0
   For inx=1 to len(aFiles)
      if !empty(bBloqueFileFound)
         eval(bBloqueFileFound, NextFolder + aFiles[inx][1])
      endif
      if bStopSeek
         return -1
      endif
      AADD(Vector, {NextFolder + aFiles[inx][1] , aFiles[inx][2] , aFiles[inx][3] , aFiles[inx][4] , aFiles[inx][5]})
      nCant++
   Next
endif
if len(aDirec) > 0
   For inx=1 to len(aDirec)
      if At("D",aDirec[inx][5]) > 0 .and. substr(aDirec[inx][1] ,1,1) != "."
         if (RetornoRecursivo:=US_SeekFile(@Vector, Disco , substr(NextFolder,4)+aDirec[inx][1] , Archivo, bBloqueNextFolder, bBloqueFileFound, @bStopSeek)) = -1
            nCant:=-1
            inx:=len(aDirec)
         else
            nCant:=nCant+RetornoRecursivo
         endif
      endif
   Next
endif

Return nCant

//==================================================================================\\
//= Function US_SplitFile                                                          =\\
//= Use:                                                                           =\\
//= US_SplitFile(cFile,nBytes,@vFilesResult,@bStop,nMsgRetornoIdioma,@cMsgRetorno,{| nPos, nPor | ProgressSplitTotal( nPos , nPor )},{| nFile, cFile, nPos, nPor | ProgressSplitParcial( nFile, cFile, nPos , nPor )}, bHomogeneo, NombreDeArchivoLuegoDeReBuild)
//= Idiomas: 0 Espa±ol (Default) - 1 Ingles                                        =\\
//= Retorna:                                                                       =\\
//=  en vFileResult los mismos datos que la funcion Directory() pero el nombre de  =\\
//=     los archivos tiene el path completo                                        =\\
//=  > 0 = Cantidad de Archivos generados                                          =\\
//=   -1 = Stop de usuario                                                         =\\
//=   -2 = Archivo de entrada es menor que tama±o de split......                   =\\
//=   -4 = Sin parametros                                                          =\\
//=   -6 = No se puede crear el archivo BAT para reconstruccion del archivo        =\\
//=   -8 = Archivo de entrada existe pero no puede ser accedido                    =\\
//=  -16 = Archivo de entrada no existe o no puede ser accedido (no hay certeza)   =\\
//=  -20 = No se pueden crear los archivos de salida                               =\\
//=  -30 = Idioma incorrecto - Bad Language                                        =\\
//= -100 = Error en calculo de longitud de salida, Ver Log                         =\\
//----------------------------------------------------------------------------------\\
Function US_SplitFile( cEnt, nSize, vFilesResult, bStop, nIdioma, cMsgRetorno, EvaluoTotal, EvaluoParcial, bHomogeneo, cArchivoRebuild )
Local archivo_de_entrada:="", ;
      cArmarFinal      :="@ECHO OFF",;
      cArmarAuxFinal   :="",;
      cArmarNormal     :="COPY /B ",;
      cArmarExplorer   :="COPY /B ",;
      cArmarZipExplorer:="COPY /B ",;
      nHomoAux:=0 , ;
      buffer:="" , ;
      buffsize:= 32767 , ;
      msg := "" , ;
      cant_arch_sal:=0 , ;
      bytes_leidos := 0 , ;
      cont_files := 0 , ;
      bytes_grabados := 0 , ;
      total_grabados := 0 , ;
      bytes_evaluo_total := 0 , ;
      bytes_evaluo_parcial := 0 , ;
      longitud_last := 0 , ;
      aux_bytes := 0 , ;
      crear := .t. , ;
      loop := .t. , ;
      archivo_de_salida:="" , ;
      archivo_batch := "" , ;
      cCRLF:=HB_OsNewLine(), ;
      longitud_de_salida  := 1457664 , ;
      longitud_de_entrada := 0

if empty(bStop)
   bStop:=.F.
endif

if empty(bHomogeneo)
   bHomogeneo:=.F.
endif

buffer:=replicate(" ",buffsize)
cMsgRetorno:="ok"

if empty(nIdioma)
   nIdioma:=0
else
   if nIdioma < 0 .or. nIdioma > 1
      cMsgRetorno:="Idioma Invalido - Bad Language"
      Return -30
   endif
endif

if !empty(nSize)
   longitud_de_salida:= nSize
endif
if !empty(cEnt)
   archivo_de_entrada:=cEnt
else
   do case
      case nIdioma = 0
         cMsgRetorno:="ERROR !!!: Funcion llamada sin parametros"
      case nIdioma = 1
         cMsgRetorno:="ERROR !!!: Function without Parameters"
   endcase
   Return -4
endif

*? "Archivo de Entrada: " + archivo_de_entrada

// chequeo que el archivo de entrada exista
if !file(archivo_de_entrada)
   do case
      case nIdioma = 0
         cMsgRetorno:="ERROR !!!: archivo de entrada '" + archivo_de_entrada + "' no existe o no puede ser accedido"
      case nIdioma = 1
         cMsgRetorno:="ERROR !!!: Input file '" + archivo_de_entrada + "' not found or not be acceded"
   endcase
   Return -16
endif

entrada:=fopen(archivo_de_entrada)
if entrada = -1
   do case
      case nIdioma = 0
         cMsgRetorno:="ERROR !!!: archivo de entrada '" + archivo_de_entrada + "' no puede ser accedido"
      case nIdioma = 1
         cMsgRetorno:="ERROR !!!: Input file '" + archivo_de_entrada + "' not be acceded"
   endcase
   Return -8
endif

// busco longitud del archivo de entrada
longitud_de_entrada:=fseek(entrada,0,2)
fseek(entrada,0,0)

*? "(" + alltrim(str(longitud_de_entrada)) + " bytes)"

if longitud_de_salida > longitud_de_entrada
   fclose(entrada)
   do case
      case nIdioma = 0
         cMsgRetorno:="ERROR !!!: Archivo de entrada (" + alltrim(str(longitud_de_entrada)) + " bytes) "+cCRLF+ ;
                      "es menor que la longitud de salida (" + alltrim(str(longitud_de_salida)) + " bytes)"
      case nIdioma = 1
         cMsgRetorno:="ERROR !!!: Input file (" + alltrim(str(longitud_de_entrada)) + " bytes) "+cCRLF+ ;
                      "less what lenght of out (" + alltrim(str(longitud_de_salida)) + " bytes)"
   endcase
   Return -2
endif

cant_arch_sal := int(longitud_de_entrada / longitud_de_salida)
if ((longitud_de_entrada % longitud_de_salida) > 0)
   longitud_last := (longitud_de_entrada - (longitud_de_salida * cant_arch_sal))
   cant_arch_sal++
else
   longitud_last := longitud_de_salida
endif

if bHomogeneo
   nHomoAux:=(longitud_de_entrada / cant_arch_sal)
   if int(nHomoAux) < nHomoAux
      nHomoAux:=int(nHomoAux)+1
   endif
   longitud_de_salida:=nHomoAux
   if ((longitud_de_entrada % longitud_de_salida) > 0)
      longitud_last := (longitud_de_entrada - (longitud_de_salida * (cant_arch_sal - 1)))
   else
      longitud_last := longitud_de_salida
   endif
endif

if ((longitud_de_salida * ( cant_arch_sal -1 ) ) + longitud_last) != longitud_de_entrada
   cMsgRetorno:="Error en calculo de longitud de salida, Ver Log"
   US_LOG("Homogeneo         : " + us_todostr(bHomogeneo) , .F. )
   US_LOG("Longitud de entrad: " + alltrim(str(longitud_de_entrada)) , .F. )
   US_LOG("Longitud de salida: " + alltrim(str(longitud_de_salida)) , .F. )
   US_LOG("cant arch         : " + alltrim(str(cant_arch_sal)) , .F. )
   US_LOG("Longitud last     : " + alltrim(str(longitud_last)) , .F. )
   Return -100
endif

do while loop
   // leer un bloque en binario del archivo de entrada
   if (fseek(entrada,0,1) < longitud_de_entrada)
      bytes_leidos:=fread(entrada,@buffer,buffsize)
      //? "Leidos: " + alltrim(str(bytes_leidos))
   else
      bytes_leidos = bytes_leidos - aux_bytes
      //? "Forzados: " + alltrim(str(bytes_leidos))
   endif

   if crear
      bytes_evaluo_parcial:=0
      cont_files++
      // crear archivo de salida
      // armo el nombre
      archivo_de_salida:=archivo_de_entrada+"."+alltrim(str(cont_files))+"-"+alltrim(str(cant_arch_sal))+".USS"
      AADD(vFilesResult,archivo_de_salida)

      // para restorear
      if cont_files > 1
         cArmarNormal     :=cArmarNormal+"+"
         cArmarExplorer   :=cArmarExplorer+"+"
         cArmarZipExplorer:=cArmarZipExplorer+"+"
      endif
      cArmarNormal     :=cArmarNormal+'"'+substr(archivo_de_salida,rat(DEF_SLASH,archivo_de_salida)+1)+'"'
      cArmarAuxFinal   :=substr(archivo_de_salida,rat(DEF_SLASH,archivo_de_salida)+1)
      cArmarExplorer   :=cArmarExplorer+'"'+substr(cArmarAuxFinal,1,at(".",cArmarAuxFinal)-1)+'[1]'+substr(cArmarAuxFinal,at(".",cArmarAuxFinal))+'"'
      if cont_files = 1
         cArmarZipExplorer:=cArmarZipExplorer+'"'+substr(cArmarAuxFinal,1,at(".",cArmarAuxFinal)-1)+'[1]'+substr(cArmarAuxFinal,at(".",cArmarAuxFinal))+'.ZIP"'
      else
         cArmarZipExplorer:=cArmarZipExplorer+'"'+substr(cArmarAuxFinal,1,at(".",cArmarAuxFinal)-1)+'[1]'+substr(cArmarAuxFinal,at(".",cArmarAuxFinal))+'"'
      endif

      // open con create y replace
      if (salida:=fcreate(archivo_de_salida, 0)) = -1
         do case
            case nIdioma = 0
               cMsgRetorno:="ERROR en creacion de Archivo de Salida: "+archivo_de_salida
            case nIdioma = 1
               cMsgRetorno:="ERROR in create output file: "+archivo_de_salida
         endcase
         return -20
      endif

      *? "Creando " + archivo_de_salida + " ==> "
      crear := .f.
   endif

   // graba el bloque leido en el archivo de salida activo

   if (bytes_leidos < (longitud_de_salida - bytes_grabados))
      bytes_evaluo_parcial:=bytes_evaluo_parcial + fwrite(salida, buffer, bytes_leidos)
      bytes_grabados := bytes_grabados + bytes_leidos
      total_grabados := total_grabados + bytes_leidos
      // ? " grabados en a1 " + alltrim(str( bytes_leidos)) + " TOT " + alltrim(str(total_grabados))
   else
      *** aux_bytes = int(longitud_de_salida - bytes_grabados)
      aux_bytes = (longitud_de_salida - bytes_grabados)
      bytes_evaluo_parcial:=bytes_evaluo_parcial + fwrite(salida, buffer, aux_bytes)
      fclose(salida)
      fseek(entrada,(-(bytes_leidos - aux_bytes)),1)
      *US_LOG( alltrim(str( bytes_grabados + aux_bytes)) + " ok!", .T. )
      total_grabados := total_grabados + aux_bytes
      bytes_grabados := 0
      crear := .t.
      // US_LOG( " grabados en a2 " + alltrim(str(aux_bytes)) + " POS ? " + " TOT " + alltrim(str( total_grabados )), .T. )
   endif
   bytes_evaluo_total:=total_grabados

   if !empty(EvaluoTotal)
      eval(EvaluoTotal, bytes_evaluo_total, ((bytes_evaluo_total * 100) / longitud_de_entrada))
   endif

   if !empty(EvaluoParcial)
      if cont_files = cant_arch_sal
         eval(EvaluoParcial, cont_files, archivo_de_salida, bytes_evaluo_parcial, ((bytes_evaluo_parcial * 100) / longitud_last))
      else
         eval(EvaluoParcial, cont_files, archivo_de_salida, bytes_evaluo_parcial, ((bytes_evaluo_parcial * 100) / longitud_de_salida))
      endif
   endif

   if (total_grabados == longitud_de_entrada) .or. bStop
      loop := .f.
      fclose(salida)
   endif
enddo

// Informo ultima grabacion
*if bytes_grabados > 0
*   ? alltrim(str( bytes_grabados )) + " ok!"
*endif

// cierro el archivo de entrada
fclose(entrada)

// Stop por usuario
if bStop
   do case
      case nIdioma = 0
         cMsgRetorno:="STOP de usuario"
      case nIdioma = 1
         cMsgRetorno:="User STOP"
   endcase
   Return -1
endif

// concluyo el armado del comando copy
cArmarNormal     := cArmarNormal+" "
cArmarExplorer   := cArmarExplorer+" "
cArmarZipExplorer:= cArmarZipExplorer+" "
cArmarNormal     := cArmarNormal+'"'+if(cArchivoRebuild = NIL , substr(archivo_de_entrada,rat(DEF_SLASH,archivo_de_entrada)+1) , cArchivoRebuild)+'"'
cArmarExplorer   := cArmarExplorer+'"'+if(cArchivoRebuild = NIL , substr(archivo_de_entrada,rat(DEF_SLASH,archivo_de_entrada)+1) , cArchivoRebuild)+'"'
cArmarZipExplorer:= cArmarZipExplorer+'"'+if(cArchivoRebuild = NIL , substr(archivo_de_entrada,rat(DEF_SLASH,archivo_de_entrada)+1) , cArchivoRebuild)+'"'

archivo_batch := archivo_batch+archivo_de_entrada
archivo_batch := archivo_batch+".0.USS.BAT"

// creo archivo batch
cArmarAuxFinal:=substr(vFilesResult[1],rat(DEF_SLASH,vFilesResult[1])+1)
cArmarFinal:=cArmarFinal+cCRLF+'if exist "'+cArmarAuxFinal+'" GOTO Normal'+cCRLF+ ;
             'if exist "'+substr(cArmarAuxFinal,1,at(".",cArmarAuxFinal) - 1)+'[1]'+substr(cArmarAuxFinal,at(".",cArmarAuxFinal))+'" GOTO Explorer'+cCRLF+ ;
             'if exist "'+substr(cArmarAuxFinal,1,at(".",cArmarAuxFinal) - 1)+'[1]'+substr(cArmarAuxFinal,at(".",cArmarAuxFinal))+'.ZIP'+'" GOTO ZipExplorer'+cCRLF+ ;
             'GOTO ERROR'+cCRLF+ ;
             ':Normal'+cCRLF+ ;
             cArmarNormal+cCRLF+ ;
             'GOTO END'+cCRLF+ ;
             ':Explorer'+cCRLF+ ;
             cArmarExplorer+cCRLF+ ;
             'GOTO END'+cCRLF+ ;
             ':ZipExplorer'+cCRLF+ ;
             cArmarZipExplorer+cCRLF+ ;
             'GOTO END'+cCRLF+ ;
             ':ERROR'+cCRLF+ ;
             'ECHO ERROR, files for rebuild not found in directory'+cCRLF+ ;
             'Pause'+cCRLF+ ;
             ':END'
if (batch:=fcreate(archivo_batch, 0)) = -1
   do case
      case nIdioma = 0
         cMsgRetorno:="ERROR en creacion de Archivo para rearmar el file: "+archivo_batch
      case nIdioma = 1
         cMsgRetorno:="ERROR in create Bat file for build the original file: "+archivo_batch
   endcase
   return -6
endif
fwrite(batch,cArmarFinal,len(cArmarFinal))
fclose(batch)
AADD(vFilesResult,archivo_batch)

*? "Estos archivos se restauran con el archivo '" + substr(archivo_batch,rat(DEF_SLASH,archivo_batch)+1) + "'"
*? "o con el siguiente comando:"
*? cArmarNormal

Return cant_arch_sal

//= END Function US_SplitFile                                                      =\\
//==================================================================================\\

//==================================================================================\\
//= INI Function US_StackList                                                      =\\
//= Use: cText:=US_StackList()                                                     =\\
Function US_StackList()
Local cTxt:="" , n:=1
   WHILE ! Empty( ProcName( n ) )
      cTxt := cTxt+"Called from " + ProcName( n ) + "(" + AllTrim( Str( ProcLine( n++ ) ) ) + ")" +CHR(13) +CHR(10)
   ENDDO
Return cTxt
//= END Function US_StackList                                                      =\\
//==================================================================================\\

//==================================================================================\\
//= INI Function US_StackListArray                                                 =\\
//= Use: aList:=US_StackListArray()                                                =\\
Function US_StackListArray()
Local aProc:={} , n:=1
   WHILE ! Empty( ProcName( n ) )
      aadd( aProc , ProcName( n ) + "(" + AllTrim( Str( ProcLine( n++ ) ) ) + ")" )
   ENDDO
Return aProc
//= END Function US_StackListArray                                                 =\\
//==================================================================================\\

//==================================================================================\\
//= INI Function US_Stack                                                          =\\
//= Use: nTop:=US_Stack()                                                          =\\
Function US_Stack()
Local n:=1
   WHILE ! Empty( ProcName( n ) )
      n++
   ENDDO
Return n - 1
//= END Function US_Stack                                                          =\\
//==================================================================================\\

Function US_Wait(SEGUNDOS)
   Local iTime:= Seconds()
   Do While Seconds() - iTime < SEGUNDOS
      US_DoEvents()
   EndDo
RETURN .T.

//Function US_ISDIR(DIRE)
//   LOCAL aDirectory := DIRECTORY(DIRE,"D"), I
//   FOR I=1 TO LEN(ADIRECTORY)
//       IF UPPER(ALLTRIM(ADIRECTORY[I][1])) == UPPER(ALLTRIM(SUBSTR(DIRE,RAT(DEF_SLASH,DIRE)+1))) .AND. ADIRECTORY[I][5] = "D"
//          Return .T.
//       ENDIF
//   NEXT
//Return .F.

FUNCTION US_CENTER(LONGI,ESTRING)
   ESTRING=ALLTRIM(ESTRING)
   IF LEN(ESTRING) > LONGI
      RETURN ESTRING
   ENDIF
RETURN PADR(REPLICATE(" ",INT((LONGI-LEN(ESTRING))/2))+ESTRING,LONGI," ")

Function US_PosCenter(ESTRING)
Return ( ( 80 - LEN( ESTRING ) ) / 2 )

Function US_TodoStr(X)
   Local T, StringAux:="" , i:=0
   if X == NIL
      X := "*NIL*"
   endif
   T=Valtype(X)
   do case
      case T='C'
         return X
      case T='O'
         return "*OBJ*"
      case T='U'
         return "*UND*"
      case T='M'
         return X
      case T='D'
         StringAux=DTOS(X)
         return StringAux
      case T='N'
         StringAux=US_STRCERO(X)
         return StringAux
      case T='L'
         StringAux=IF(X,'.T.','.F.')
         return StringAux
      case T='A'
         for i=1 to ( len(x) - 1 )
            StringAux:=StringAux + US_TodoStr( x[i] ) + HB_OSNewLine()
         next
         if len(x) > 0
            StringAux:=StringAux + US_TodoStr( x[len(x)] )
         endif
         return StringAux
   endcase
return ""

FUNCTION US_StrCero(NUM,LONG,DEC)
   Local INDICIO
   IF DEC=NIL
      IF LONG=NIL
         NUM=STR(NUM)
      ELSE
         NUM=STR(NUM,LONG)
      ENDIF
   ELSE
      NUM=STR(NUM,LONG,DEC)
   ENDIF
   LONG=LEN(NUM)
   FOR INDICIO=1 TO LONG
      IF SUBSTR(NUM,INDICIO,1) = " "
         NUM=STUFF(NUM,INDICIO,1,"0")
      ENDIF
   NEXT
RETURN NUM

FUNCTION US_CPT
   PARAMETERS CAMPO
   PRIVATE CLAVE,CLAVE2,H,I,SALIDA,REEMPLAZO,RANT
   CLAVE=CHR(123)+CHR(134)+CHR(136)+CHR(92)+CHR(156)+CHR(133)+CHR(236)+"Z"+"Q"+;
   "@"+"A"+CHR(207)+CHR(203)+CHR(220)+CHR(217)+CHR(32)+CHR(4)+CHR(0)+CHR(201)+;
   CHR(200)+CHR(200)+CHR(200)+CHR(200)+CHR(200)+CHR(200)+CHR(200)+"URSAN SISTEMAS"
   CLAVE2=SPACE(LEN(CAMPO))
   SALIDA=SPACE(LEN(CAMPO))
   FOR H=1 TO LEN(CAMPO)
      CLAVE2=STUFF(CLAVE2,H,1,IIF(H > LEN(CLAVE),SUBSTR(CLAVE,MOD(H,LEN(CLAVE)),1),SUBSTR(CLAVE,H,1)))
   NEXT
   RANT=0
   DO CASE
      CASE TYPE('CAMPO') = "C"
         FOR I=1 TO LEN(CAMPO)
             REEMPLAZO=ASC(SUBSTR(CAMPO,I,1)) + ASC(SUBSTR(CLAVE2,I,1)) + RANT
             IF REEMPLAZO > 256 .AND. REEMPLAZO < 513
                REEMPLAZO=REEMPLAZO - 256
             ELSE
                IF REEMPLAZO > 512
                   REEMPLAZO=REEMPLAZO - 512
                ENDIF
             ENDIF
             RANT=REEMPLAZO
             SALIDA=STUFF(SALIDA,I,1,CHR(REEMPLAZO))
         NEXT
      OTHERWISE
         ? "TYPO NO CONTEMPLADO"
   ENDCASE
RETURN SALIDA

FUNCTION US_UCPT
   PARAMETERS CAMPO
   PRIVATE CLAVE,CLAVE2,H,I,SALIDA,REEMPLAZO,RANT,AUX,AUX1,AUX2,AUX3,SENIAL
   CLAVE=CHR(123)+CHR(134)+CHR(136)+CHR(92)+CHR(156)+CHR(133)+CHR(236)+"Z"+"Q"+;
   "@"+"A"+CHR(207)+CHR(203)+CHR(220)+CHR(217)+CHR(32)+CHR(4)+CHR(0)+CHR(201)+;
   CHR(200)+CHR(200)+CHR(200)+CHR(200)+CHR(200)+CHR(200)+CHR(200)+"URSAN SISTEMAS"
   CLAVE2=SPACE(LEN(CAMPO))
   SALIDA=SPACE(LEN(CAMPO))
   FOR H=1 TO LEN(CAMPO)
       CLAVE2=STUFF(CLAVE2,H,1,IIF(H > LEN(CLAVE),SUBSTR(CLAVE,MOD(H,LEN(CLAVE)),1),SUBSTR(CLAVE,H,1)))
   NEXT
   RANT=0
   DO CASE
       CASE TYPE('CAMPO') = "C"
          FOR I=1 TO LEN(CAMPO)
              IF I != 1
                 AUX=ASC(SUBSTR(CAMPO,I - 1,1))
                 AUX1=ASC(SUBSTR(CLAVE2,I,1))
                 AUX2=ASC(SUBSTR(CAMPO,I,1))
                 AUX3=AUX2+256
                 IF (AUX3 - (AUX + AUX1)) > 256
                    SENIAL = 0
                 ELSE
                    SENIAL = 256
                 ENDIF
                 REEMPLAZO=(ASC(SUBSTR(CAMPO,I,1)) + SENIAL) - ASC(SUBSTR(CLAVE2,I,1))
                 REEMPLAZO=REEMPLAZO - ASC(SUBSTR(CAMPO,I - 1,1))
              ELSE
                 REEMPLAZO=ASC(SUBSTR(CAMPO,I,1)) - ASC(SUBSTR(CLAVE2,I,1))
                 IF ASC(SUBSTR(CAMPO,I,1)) < ASC(SUBSTR(CLAVE2,I,1))
                    REEMPLAZO=REEMPLAZO + 256
                 ENDIF
              ENDIF
              IF REEMPLAZO < 0
                 REEMPLAZO = REEMPLAZO + 256
              ENDIF
              SALIDA=STUFF(SALIDA,I,1,CHR(REEMPLAZO))
          NEXT
       OTHERWISE
          ? "TYPO NO CONTEMPLADO"
   ENDCASE
RETURN SALIDA

FUNCTION US_RAND
   PARAMETERS RANDOM
   PRIVATE NEGATIVE,TTX,TTJ,TTY,TTK,TTL,TTZ,TTS,TTT,RETT
   NEGATIVE=(RANDOM < 0)
   IF RANDOM = 0
      RETURN(0)
   ENDIF
   RANDOM=ABS(RANDOM)
   TTX=SECONDS()/100
   TTJ=(TTX - INT(TTX)) * 100
   TTY=LOG(SQRT(SECONDS()/100))
   TTK=(TTY - INT(TTY)) * 100
   TTL=TTJ*TTK
   TTZ=TTL - INT(TTL)
   TTS= RANDOM * TTZ
   TTT= ROUND(TTS,2)
   RETT=INT(TTT) + IF(INT(TTT) + 1 < RANDOM+1,1,0)
RETURN (RETT * IF(NEGATIVE,-1,1))

Function US_CurDisk()
return diskname()+":"

*//========================================================================\\*
*// ESTA FUNCION CONVIERTE SEGUNDOS EN FORMATO HH:MM:SS
*//========================================================================\\*
FUNCTION US_SecTime(SEC)
   LOCAL HH,MM,SS
   HH=INT(SEC / 3600)
   MM=INT((SEC % 3600) / 60)
   SS=INT((SEC % 3600) % 60)
RETURN US_STRCERO(HH,2)+":"+US_STRCERO(MM,2)+":"+US_STRCERO(SS,2)

*//========================================================================\\*
*// ESTA FUNCION CONVIERTE SEGUNDOS con Centesimas EN FORMATO HH:MM:SS.cc
*//========================================================================\\*
FUNCTION US_SecTimeCen(SEC)
   LOCAL HH,MM,SS,Cen:=(SEC-int(SEC))*100
   SEC:=int(SEC)
   HH=INT(SEC / 3600)
   MM=INT((SEC % 3600) / 60)
   SS=INT((SEC % 3600) % 60)
RETURN US_STRCERO(HH,2)+":"+US_STRCERO(MM,2)+":"+US_STRCERO(SS,2)+"."+US_StrCero(Cen,2)

*//========================================================================\\*
*// ESTA FUNCION CONVIERTE Mili-SEGUNDOS EN FORMATO HH:MM:SS.mmm
*//========================================================================\\*
Function US_MilSecTime(nMilSec)
LOCAL nHH,nMM,nSS,nMil,nResto
nHH=int(nMilSec / 3600000)
nResto=(nMilSec % 3600000)
nMM=int(nResto / 60000)
nResto=(nResto % 60000)
nSS=int(nResto / 1000)
nMil:=(nResto % 1000)
RETURN US_StrCero(nHH,2)+":"+US_StrCero(nMM,2)+":"+US_StrCero(nSS,2)+"."+US_StrCero(nMil,3)

*//========================================================================\\*
*// ESTA FUNCION CONVIERTE TIME de FORMATO HH:MM:SS EN SEGUNDOS
*//========================================================================\\*
Function US_TimeSec( Tiempo )
Return (VAL(SUBSTR(TIEMPO,1,2))*3600)+(VAL(SUBSTR(TIEMPO,4,2))*60)+VAL(SUBSTR(TIEMPO,7,2))

*//========================================================================\\*
*// ESTA FUNCION CONVIERTE TIME de FORMATO HH:MM:SS.mmm EN MILI-SEGUNDOS
*//========================================================================\\*
Function US_TimeMilSec(cTime)
Return (US_TimeSec(substr(cTime,1,8))*1000)+val(substr(cTime,10,3))

*//========================================================================\\*
*// ESTA FUNCION Calcula el elapsed entre tiempos de FORMATO AAAAMMDDHHMMSScc
*//========================================================================\\*
Function US_ElapsedMil( cDesde , cHasta )
   Local nCenDesde := val( Substr( cDesde , 15 , 2 ) ) , ;
         nCenHasta := val( Substr( cHasta , 15 , 2 ) )
   Local cFechaDesde := CTOD(substr(cDesde,5,2)+"/"+substr(cDesde,7,2)+"/"+substr(cDesde,1,4)) , ;
         cFechaHasta := CTOD(substr(cHasta,5,2)+"/"+substr(cHasta,7,2)+"/"+substr(cHasta,1,4))
   Local nSecDesde := 0 , ;
         nSecHasta := 0
   Local nDias := 0
   Local nSecAcum := 0
   Local nReto := 0
   nDias := cFechaHasta - cFechaDesde
   nSecDesde := US_TimeSec( Substr( cDesde , 9 , 2 ) + ':' + Substr( cDesde , 11 , 2 ) + ':' + Substr( cDesde , 13 , 2 ) )
   nSecDesde += ( nCenDesde / 100 )
   nSecHasta := US_TimeSec( Substr( cHasta , 9 , 2 ) + ':' + Substr( cHasta , 11 , 2 ) + ':' + Substr( cHasta , 13 , 2 ) )
   nSecHasta += ( nCenHasta / 100 )
   if nDias > 1
      nSecAcum := ( nDias - 1 ) * 86400
      nSecAcum += 86400 - nSecDesde
      nSecDesde := 0
   else
      if nDias == 1
         nSecAcum += 86400 - nSecDesde
         nSecDesde := 0
      else
         if nDias == 0
            if nSecDesde > nSecHasta
               US_Log( "Error 11 in function " + Procname() )
               Return -1
            endif
         else
            US_Log( "Error 22 in function " + Procname() )
            Return -1
         endif
      endif
   endif
Return ( nSecHasta - nSecDesde ) + nSecAcum

*//========================================================================\\*
*// ESTA FUNCION DISPLAYA UN CAMPO TIME SIN CEROS A LA IZQUIERDA
*//========================================================================\\*
FUNCTION US_TIMEDIS(TIEMPO)
   LOCAL RES,I
   RES := ""
   FOR I:=1 TO 4
      IF SUBSTR(TIEMPO,I,1) != "0" .AND. SUBSTR(TIEMPO,I,1) != ":"
         RES:=RES+SUBSTR(TIEMPO,I)
         RETURN RES
      ELSE
         RES:=RES+" "
      ENDIF
   NEXT
RETURN RES+SUBSTR(TIEMPO,I)

*//========================================================================\\*
*// FUNCION PARA DETERMINAR LA INTEGRIDAD DE BASES DE DATOS.
*// LOS RETURN CODES ESTAN EN ERROR.CH
*//========================================================================\\*
FUNCTION US_IsDBF(cDBF)
   LOCAL nUsError := 0
   LOCAL bSaveHandler
   LOCAL oError
   LOCAL cLastDBF := DBF()
   // Lazy man's error checking
   bSaveHandler := errorblock( { |x| break(x) } )
   BEGIN SEQUENCE
      /*                      Shared , Read   */
      DBUseArea( .T. , , cDBF , , .T. , .T. )
      USE
      RECOVER USING oError
         nUsError = oError:genCode
   END
   IF cLastDBF != ""
      DBSELECTAREA(cLastDBF)
   ENDIF
   // Restore the default error handler
   errorblock( bSaveHandler )
//   IF nUsError = 21   && open exclusive by another program
//      nUsError = 0
//   ENDIF
     IF nUsError = 17   && name with "-"
        nUsError = 0
     ENDIF
RETURN nUsError

* Revisar si la siguiente funcion no es especifica de Vinilos Perdidos
FUNCTION US_OKDBF(DBF)
   LOCAL USERROR
   LOCAL bSaveHandler
   LOCAL oError
   LOCAL LASTDBF
   USERROR=0
   LASTDBF=DBF()
   // Lazy man's error checking
   bSaveHandler := errorblock( { |x| break(x) } )
   BEGIN SEQUENCE
      DBUseArea(.T., , DBF)
      USE
      RECOVER USING oError
      USERROR = oError:genCode
   END
   IF LASTDBF != ""
      DBSELECTAREA(LASTDBF)
   ENDIF
   // Restore the default error handler
   errorblock( bSaveHandler )
RETURN USERROR

*//========================================================================\\*
*// FUNCION PARA EXTRAER UNA PALABRA DE UN ESTRING
*//========================================================================\\*
FUNCTION US_WORD(ESTRING, POSICION)
   LOCAL CONT
   CONT := 1
   if Posicion == NIL
      Posicion := 1
   endif
   ESTRING := ALLTRIM(ESTRING)
   DO WHILE .T.
      IF AT(" ",ESTRING) != 0
         IF CONT == POSICION
            RETURN SUBSTR(ESTRING,1,AT(" ",ESTRING)-1)
         ELSE
            ESTRING := ALLTRIM(SUBSTR(ESTRING,AT(" ",ESTRING) + 1))
            CONT := CONT + 1
         ENDIF
      ELSE
         IF POSICION == CONT
            RETURN ESTRING
         ELSE
            RETURN ""
         ENDIF
      ENDIF
   ENDDO
Return ""

*//========================================================================\\*
*// FUNCION PARA DETERMINAR EL NUMERO DE PALABRA DE UNA PALABRA EN UN ESTRING
*// OJO, ES EL NUMERO DE PALABRA, NO EL BYTE DEL OFFSET
*//========================================================================\\*
FUNCTION US_WORDPOS(PAL,ESTRING)
   LOCAL I
   PAL:=ALLTRIM(PAL)
   ESTRING:=ALLTRIM(ESTRING)
   FOR I:=1 TO US_WORDS(ESTRING)
      IF PAL == US_WORD(ESTRING,I)
         RETURN I
      ENDIF
   NEXT
RETURN 0

*//========================================================================\\*
*// FUNCION PARA CONTAR LAS PALABRAS EN UN ESTRING
*//========================================================================\\*
FUNCTION US_WORDS(ESTRING)
   LOCAL CONT:=0
   if Estring == NIL
      Estring := ""
   endif
   ESTRING:=ALLTRIM(ESTRING)
   DO WHILE .T.
      IF AT(" ",ESTRING) != 0
         ESTRING:=ALLTRIM(SUBSTR(ESTRING,AT(" ",ESTRING) + 1))
         CONT++
      ELSE
         IF LEN(ESTRING) > 0
            RETURN CONT + 1
         ELSE
            RETURN CONT
         ENDIF
      ENDIF
   ENDDO
Return 0

*//========================================================================\\*
*// FUNCION PARA SABER LA POSICION DE LA PALABRA NUMERO ....
*// ESTA FUNCION RETORNA EL BYTE DONDE EMPIEZA LA PALABRA
*//========================================================================\\*
FUNCTION US_WORDIND(ESTRING, POSICION)
   LOCAL CONT , ESTR , ESTR2
   if ESTRING == NIL
      ESTRING := ""
   ENDIF
   if us_words( Estring ) < Posicion
      Return ( len( Estring ) + 1 )
//    Return 0
   endif
   CONT := 1
   ESTR := ESTRING
   ESTR2 := RTRIM(ESTRING)
   ESTRING := ALLTRIM(ESTRING)
   DO WHILE .T.
      IF AT(" ",ESTRING) != 0
         IF CONT == POSICION
            RETURN (LEN(ESTR)-(LEN(ESTRING)+(LEN(ESTR)-LEN(ESTR2)))+1)
         ELSE
            ESTRING := ALLTRIM(SUBSTR(ESTRING,AT(" ",ESTRING) + 1))
            CONT := CONT + 1
         ENDIF
      ELSE
         IF POSICION == CONT
            RETURN (LEN(ESTR)-(LEN(ESTRING)+(LEN(ESTR)-LEN(ESTR2)))+1)
         ELSE
            RETURN 0
         ENDIF
      ENDIF
   ENDDO
RETURN 0

*//========================================================================\\*
*// FUNCION PARA ELIMINAR UNA PALABRA DE UN STRING
*//========================================================================\\*
FUNCTION US_WORDDEL(ESTRING,POSICION)
RETURN IIF(POSICION>0,ALLTRIM(SUBSTR(ESTRING,1,US_WORDIND(ESTRING,POSICION)-1)+STRTRAN(SUBSTR(ESTRING,US_WORDIND(ESTRING,POSICION)),US_WORD(ESTRING,POSICION)," ",1,1)),ESTRING)

*//========================================================================\\*
*// FUNCION PARA INSERTAR UNA PALABRA EN UN STRING
*// POSICION SE REFIERE A PALABRA, NO A OFFSET
*//========================================================================\\*
FUNCTION US_WORDINS(ESTRING,PAL,POSICION)
   IF POSICION > US_WORDS(ESTRING)
      RETURN ESTRING+" "+PAL
   ELSE
      RETURN SUBSTR(ESTRING,1,US_WORDIND(ESTRING,POSICION)-1)+PAL+" "+SUBSTR(ESTRING,US_WORDIND(ESTRING,POSICION))
   ENDIF
Return ""

*//========================================================================\\*
*// FUNCION PARA CONVERTIR A MINUSCULAS CON LA PRIMER LETRA EN MAYUSCULA
*//========================================================================\\*
FUNCTION US_LOWER(ESTRING)
   LOCAL I,PALABRA,LETRA,L,PALPOS
   ESTRING=LOWER(ESTRING)
   FOR I=1 TO US_WORDS(ESTRING)
      PALABRA:=US_WORD(ESTRING,I)
      PALPOS:=US_WORDIND(ESTRING,I)
      FOR L=1 TO LEN(PALABRA)
         LETRA=SUBSTR(PALABRA,L,1)
         IF ISALPHA(LETRA)
            PALABRA=SUBSTR(PALABRA,1,L-1)+STRTRAN(SUBSTR(PALABRA,L),LETRA,UPPER(LETRA),1,1)
            EXIT
         ENDIF
      NEXT L
      ESTRING:=SUBSTR(ESTRING,1,PALPOS-1)+PALABRA+SUBSTR(ESTRING,PALPOS+LEN(PALABRA))
   NEXT
RETURN ESTRING

*//========================================================================\\*
*// PROCEDIMIENTO GENERAL PARA CERRAR BASES
*//========================================================================\\*
Function US_DBClose
   PARAMETERS AREA && ALIAS
   PRIVATE AREAACTUAL
   AREAACTUAL = DBF()
   DBSELECTAREA(AREA)
   DBCLOSEAREA()
   IF AREAACTUAL != "" .AND. AREAACTUAL != AREA
      DBSELECTAREA(AREAACTUAL)
   ENDIF
return

*//========================================================================\\*
*// ESTA FUNCION SAE USA PARA MOSTRAR EN DBEDIT MENOS DEL LARGO DEL CAMPO
*//========================================================================\\*
FUNCTION US_DB_SUBSTR(CAMPO,INICIO,LONGITUD)
Return IF( LEN(SUBSTR(RTRIM(CAMPO),INICIO)) > LONGITUD , SUBSTR(CAMPO,INICIO,LONGITUD - 3)+"..." , SUBSTR(CAMPO,INICIO,LONGITUD) )

*//========================================================================\\*
*// ESTA FUNCION TRANSFORMA EN MAYUSCULAS STRINGS, INCLUSO CON ACENTOS.
*//========================================================================\\*
Function US_Upper(STR)
   IF valType( STR ) == "N"
      Return STR
   endif
return upper(STRTRAN(STRTRAN(STRTRAN(STRTRAN(STRTRAN(STRTRAN(STRTRAN(STRTRAN(STRTRAN(STRTRAN(STRTRAN(STRTRAN(STRTRAN(STR,"ü","U"),"ñ","N"),"Ñ","N"),"á","A"),"é","E"),"í","I"),"ó","O"),"ú","U"),"Á","A"),"É","E"),"Í","I"),"Ó","O"),"Ú","U"))

*//========================================================================\\*
*// FUNCION PARA PARSER DE PARAMETROS
*//
*// USO: US_PARSER(PREMOD,PARAM)
*//
*// DONDE: PREMOD ES EL PREFIJO DEL MODULO
*//    PARAM ES EL STRING A PARSEAR
*//
*// PARAM ES UNA VARIABLE ALFANUMERICA DONDE SE ESPECIFICA EL NOMBRE DEL
*//     PARAMETRO SEGUIDO DEL SIGNO = Y LUEGO EL CONTENIDO DEL PARAMETRO
*//     SI HUBIERA MAS DE UN PARAMETRO DEBERAN ESTAR SEPARADOS POR //
*//
*// DEPENDENCIAS: DEBERAN EXISTIR TANTAS VARIABLES QUE LAS PUEDA VER COMO
*//           PARAMETROS POSIBLES, EN EL FORMATO ..._PARM
*//           DONDE ... ES EL PREFIJO DEL MODULO Y PARM ES EL NOMBRE DEL
*//           PARAMETRO
*//
*// RETORNA -1 SI ENCUENTRA UN ERROR O LA CANTIDAD DE PARAMETROS
*//     PARSEADOS
*//
*//========================================================================\\*
FUNCTION US_PARSER(PREFIJO,PARAM)
LOCAL PARAM2,POS,POS2,VAR,CONTE,VARNAME,SALIR,CONTADOR,A
LOCAL bSaveHandler
LOCAL oError
CONTADOR:=0
IF PCOUNT() < 2
   US_Log( "US_PARSER 001E: FALTA UNO O MAS PARAMETROS" )
   RETURN -1
ENDIF
IF VALTYPE(PARAM)=="U"
   US_Log( "US_PARSER 002E: PARAMETRO 'PARAM' (SEGUNDO) ES NULO" )
   RETURN -1
ENDIF
IF ALLTRIM(PARAM)==""
   RETURN CONTADOR
ENDIF
SALIR := "N"
DO WHILE SALIR == "N"
   POS=AT("//",PARAM)
   IF POS!=0
      PARAM2:=SUBSTR(PARAM,1,POS-1)
      PARAM:=SUBSTR(PARAM,POS+2)
   ELSE
      PARAM2:=PARAM
      SALIR:="S"
   ENDIF
   IF !ALLTRIM(PARAM2) == ""
      POS2=AT("=",PARAM2)
      IF POS2==0
         US_Log( "US_PARSER 003E: PARAMETRO INVALIDO, NO TIENE SIGNO 'IGUAL' ('='): "+PARAM2 )
         RETURN -1
      ENDIF
      VAR:=ALLTRIM(SUBSTR(PARAM2,1,POS2-1))
      VARNAME:=PREFIJO+"_"+VAR
      CONTE:=ALLTRIM(SUBSTR(PARAM2,POS2+1))
      bSaveHandler := errorblock( { |x| break(x) } )
      BEGIN SEQUENCE
            A=&VARNAME
         RECOVER USING oError
            USERROR := oError:genCode   && CODIGO DEL ERROR, NO LO ESTOY USANDO
            US_Log( "US_PARCER 004E: PARAMETRO '"+VAR+"' ES INCORRECTO O NO ESTA DEFINIDA LA VARIABLE :"+VARNAME )
            RETURN -1
      END
      errorblock( bSaveHandler )
      &VARNAME:=CONTE
      CONTADOR++
   ENDIF
ENDDO
RETURN CONTADOR

*//========================================================================\\*
*// FUNCION PARA OBTENER TODAS LAS COMBINATORIAS DE ELEMENTOS DE UNA FRASE
*// Y DEVOLVERLAS EN UN VECTOR
*// USE: US_COMBINATORIA(FRASE,@VECTOR,FILA_INICIAL,COLUMNA_INICIAL)
*// Donde: FILA_INICIAL ES OPCIONAL (DEFAULT=1)
*//    COLUMNA_INICIAL ES OPCIONAL (DEFAULT=1)
*//
*// DATOS DE IMPUT:
*//
*// FRASE="A B C D E F"
*// FIL=US_FACTORIAL(US_WORDS(FRASE))
*// COL=US_WORDS(FRASE)
*// DECLARE VECTOR[FIL][COL]
*//
*//========================================================================\\*
Function US_Combinatoria(PAL,VECTOR,BASEFIL,BASECOL)
LOCAL L,C
IF BASEFIL=NIL
   BASEFIL=1
ENDIF
IF BASECOL=NIL
   BASECOL=1
ENDIF
IF US_WORDS(PAL) = 2
   VECTOR[BASEFIL][BASECOL]=US_WORD(PAL,1)
   VECTOR[BASEFIL][BASECOL+1]=US_WORD(PAL,2)
   VECTOR[BASEFIL+1][BASECOL]=US_WORD(PAL,2)
   VECTOR[BASEFIL+1][BASECOL+1]=US_WORD(PAL,1)
   RETURN
ENDIF
FOR C=1 TO US_WORDS(PAL)
   FOR L=0 TO (US_FACTORIAL(US_WORDS(PAL))/US_WORDS(PAL))-1
      VECTOR[BASEFIL+L][BASECOL]=US_WORD(PAL,C)
   NEXT
   US_COMBINATORIA(US_WORDDEL(PAL,C),@VECTOR,BASEFIL,BASECOL+1)
   BASEFIL=BASEFIL+US_FACTORIAL(US_WORDS(PAL))/US_WORDS(PAL)
NEXT
RETURN

*//========================================================================\\*
*// FUNCION PARA CALCULAR EL FACTORIAL DE UN NUMERO
*//========================================================================\\*
Function US_Factorial(NUMERO)
Return if( NUMERO = 1 , 1 , US_FACTORIAL( NUMERO - 1 ) * NUMERO )

FUNCTION US_DateSeconds()
RETURN DTOS(DATE())+US_STRCERO(SECONDS(),5)

FUNCTION US_Dis_DateSeconds(DS, bInvertido)
   Local cReto := ""
   if empty( bInvertido )
      bInvertido := .F.
   endif
   if bInvertido
      cReto := US_SecTime( val( SubStr( DS , 9 ) ) )+" "+SUBSTR(DS,7,2)+"/"+SUBSTR(DS,5,2)+"/"+SUBSTR(DS,1,4)
   else
      cReto := SUBSTR(DS,7,2)+"/"+SUBSTR(DS,5,2)+"/"+SUBSTR(DS,1,4)+" "+US_SecTime( val( SubStr( DS , 9 ) ) )
   endif
RETURN cReto

FUNCTION US_Dis_DateSeconds2(DS, bInvertido)
   Local cReto := ""
   if empty( bInvertido )
      bInvertido := .F.
   endif
   if bInvertido
      cReto := US_SecTime( val( SubStr( DS , 9 ) ) )+" "+SUBSTR(DS,1,4)+"/"+SUBSTR(DS,5,2)+"/"+SUBSTR(DS,7,2)
   else
      cReto := SUBSTR(DS,1,4)+"/"+SUBSTR(DS,5,2)+"/"+SUBSTR(DS,7,2)+" "+US_SecTime( val( SubStr( DS , 9 ) ) )
   endif
RETURN cReto

FUNCTION US_DIS_DATETIME(DT, bInvertido)
   Local cReto := ""
   if empty( bInvertido )
      bInvertido := .F.
   endif
   if bInvertido
      cReto := SUBSTR(DT,9,2)+":"+SUBSTR(DT,11,2)+":"+SUBSTR(DT,13,2)+" "+SUBSTR(DT,7,2)+"/"+SUBSTR(DT,5,2)+"/"+SUBSTR(DT,1,4)
   else
      cReto := SUBSTR(DT,7,2)+"/"+SUBSTR(DT,5,2)+"/"+SUBSTR(DT,1,4)+" "+SUBSTR(DT,9,2)+":"+SUBSTR(DT,11,2)+":"+SUBSTR(DT,13,2)
   endif
RETURN cReto

FUNCTION US_DIS_DateTimeCen(DTM , bInvertido)
   Local cReto := ""
   if empty( bInvertido )
      bInvertido := .F.
   endif
   if bInvertido
      cReto := SUBSTR(DTM,9,2)+":"+SUBSTR(DTM,11,2)+":"+SUBSTR(DTM,13,2)+"."+Substr(DTM,15,2)+" "+SUBSTR(DTM,7,2)+"/"+SUBSTR(DTM,5,2)+"/"+SUBSTR(DTM,1,4)
   else
      cReto := SUBSTR(DTM,7,2)+"/"+SUBSTR(DTM,5,2)+"/"+SUBSTR(DTM,1,4)+" "+SUBSTR(DTM,9,2)+":"+SUBSTR(DTM,11,2)+":"+SUBSTR(DTM,13,2)+"."+Substr(DTM,15,2)
   endif
RETURN cReto

FUNCTION US_DirWrite(cPath)
   LOCAL ARC:=cPath+If(Right(cPath,1)!=DEF_SLASH,DEF_SLASH,'')+"US_"+ALLTRIM(STR(INT(SECONDS())))+".CHK"
   IF MEMOWRIT(ARC,"CHECK FOR DISKW, FUNCTION US_DirWrite()")
      DELETE FILE (ARC)
      RETURN .T.
   ENDIF
Return .F.

FUNCTION US_DiskOK(DISCO,MODO)
   LOCAL ARC:=DISCO+":"+DEF_SLASH+"US_"+ALLTRIM(STR(INT(SECONDS())))+".CHK", DiskTemp , CurDir
   IF MODO = NIL
      MODO = "W"
   ENDIF
   DO CASE
      CASE MODO = "W" && WRITE
         IF MEMOWRIT(ARC,"CHECK FOR DISKW, FUNCTION US_DISKOK()")
            DELETE FILE (ARC)
            RETURN .T.
         ENDIF
      CASE MODO = "R" && READ
         DiskTemp:=Diskname()
         CurDir  :=CurDir()
         IF DISKChange(DISCO+":")
            DiskChange(DiskTemp+":")
            DirChange(CurDir)
            RETURN .T.
         ENDIF
      OTHERWISE
         ? "ERROR EN FUNCION US_DISKOK, PARAMETRO DOS CORRESPONDIENTE A 'MODO' ES INVALIDO"
         ? "USE: US_DISKOK(DISCO, MODO) "
         ? "     DISCO: LETRA DEL DISCO SIN ':'"
         ? "      MODO: 'R' READ   -   'W' WRITE"
         INKEY(0)
         RETURN .F.
   ENDCASE
RETURN .F.

FUNCTION US_MENOSCERO(NUM)
Return IF( NUM < 0 , 0 , NUM )

FUNCTION US_GetAreaFree()
   LOCAL I,AREA
   AREA = DBF()
   FOR I=1 TO 255
      SELE &I
      IF !USED()
         IF LEN(AREA) > 0
            SELE &AREA
         ENDIF
         RETURN I
      ENDIF
   NEXT
   ? "ERROR EN BUSQUEDA DE AREAS LIBRES..... FUNCION US_AREAFREE"
   INKEY(0)
   INKEY(0)
   IF LEN(AREA) > 0
      SELE &AREA
   ENDIF
RETURN 0

Function US_Abend()
Return "A"+0

Function US_FileTmp( prefix )
   Local cFile
   if empty( prefix )
      prefix:="_Temp"
   endif
   do while .t.
      cFile:=prefix+US_NameRandom()+".tmp"
      if !file(cFile)
         exit
      endif
   enddo
return cFile

/*
FUNCTION US_MENU(PTOP,PLEFT,PBOTTOM,PRIGHT,VECTOR,VECTORBOOL,USERFUNC)
RETURN US_MGMenu(PTOP,PLEFT,PBOTTOM,PRIGHT,VECTOR,VECTORBOOL,USERFUNC)
*/
Function US_DB_CodePage( cbase , cNewCode )
   Local cMode:="" , i:=0 , vEstructura:={}
   do case
      case upper(cNewCode) == "ANSI"
         cMode:="A"
      case upper(cNewCode) == "OEM"
         cMode:="O"
      otherwise
         ? "CodePage Invalido: "+cNewCode
         ? "Valores esperados: 'ANSI'  u  'OEM'"
         inkey(0)
         Return .F.
   endcase
   if !file( cBase )
      ? "Base inexistente: "+cBase
      inkey(0)
      Return .F.
   endif
   US_Use( .t. , , cBase , .f. )
   vEstructura:=DbStruct()
   for i=1 to len(vEstructura)
      if vEstructura[i][2] == "C" .or. vEstructura[i][2] == "M"
         **? vEstructura[i][1]
         DBGoTop()
         do while !eof()
            REPLACE &( vEstructura[i][1] ) with if( cMode = "O" , HB_AnsiToOem( &( vEstructura[i][1] ) ) , HB_OemToAnsi( &( vEstructura[i][1] ) ) )
            DBSkip()
         enddo
      endif
   next
   DbCloseArea()
Return .T.

FUNCTION US_ISURL(URL,FILA,COLUMNA)
RETURN 0

FUNCTION US_ISISBN(ISBN,FILA,COLUMNA)
RETURN 0

*//========================================================================\\*
*// $INI FUNCIONES para manejo de bits y numeros hexadecimales
*//------------------------------------------------------------------------\\*

/*
#ifdef _CATOOLS

   FUNCTION US_BIT(CHAR,POS)
   RETURN IF(ISBIT(ASC(CHAR),POS+1),1,0)

   FUNCTION US_C2H(CHAR)
   RETURN NTOC(ASC(CHAR),16,2,"0")

   FUNCTION US_C2B(CHAR)
   RETURN NTOC(ASC(CHAR),2,8,"0")

   FUNCTION US_C2BV(CHAR)    && FUNCTION FOR COMPATIBILITY
   RETURN CHAR

   FUNCTION US_D2H(NUM)
   RETURN NTOC(NUM,16)

   FUNCTION US_H2D(HEXA)
   RETURN VAL(NTOC(HEXA,10))

   FUNCTION US_B2D(BINA)
   RETURN CTON(BINA,2)

#else

   FUNCTION us_bit(vector,pos)
   RETURN vector[8-pos]

   FUNCTION us_c2h(char)
      LOCAL a,b,asc_char
      asc_char=asc(char)
      a=int(asc_char / 16)
      b=asc_char % 16
      do case
         case a>9
            a=chr(asc("a")+(a-10))
         otherwise
            a=alltrim(str(int(a)))
      endcase
      do case
         case b>9
            b=chr(asc("a")+(b-10))
         otherwise
            b=alltrim(str(int(b)))
      endcase
   RETURN a+b

   FUNCTION us_c2b(char)
      LOCAL asc_char:=0,byteuno:="",i
      asc_char=asc(char)
      for i=7 to 0 step -1
          byteuno:=byteuno+alltrim(str(int(asc_char / 2**i)))
          asc_char:=asc_char % 2**i
      next
   RETURN byteuno

   FUNCTION us_c2bv(char)
      LOCAL asc_char:=0
      DECLARE byteuno[8]
      asc_char=asc(char)
      for i=7 to 0 step -1
         byteuno[8-i]:=int(asc_char / 2**i)
         asc_char:=asc_char % 2**i
      next
   RETURN byteuno

// FUNCTION us_d2h(num)
//    LOCAL estring:="",aux:=0,vector:={}, i
//    do while num > 15
//       aux=num % 16
//       if aux>9
//          aadd(vector,chr(asc("a")+(aux-10)))
//       else
//          aadd(vector,alltrim(str(int(aux))))
//       endif
//       num=int(num / 16)
//    enddo
//    if num>9
//       aadd(vector,chr(asc("a")+(num-10)))
//    else
//       aadd(vector,alltrim(str(int(num))))
//    endif
//    for i=len(vector) to 1 step -1
//        estring=estring+vector[i]
//    next
// RETURN estring

// FUNCTION us_h2d(hexa)
//    LOCAL i,deci:=0, asc_digito:=0, num_digito:=0, longi:=len(hexa)
//    for i=longi to 1 step -1
//       asc_digito:=asc(upper(substr(hexa,i,1)))
//       if asc_digito>=asc("a") .and. asc_digito<=asc("f")
//          num_digito=((asc_digito)-asc("a"))+10
//       else
//          num_digito=val(chr(asc_digito))
//       endif
//       deci=deci+(num_digito*(16**(longi-i)))
//    next
// RETURN int(deci)

   FUNCTION US_D2H(nNumber)
      local cNewString:=''
      local nTemp:=0
      WHILE(nNumber > 0)
         nTemp:=(nNumber%16)
         cNewString:=SubStr('0123456789ABCDEF',(nTemp+1),1)+cNewString
         nNumber:=Int((nNumber-nTemp)/16)
      ENDDO
   RETURN(cNewString)

   FUNCTION US_H2D(cString)
      local nNumber:=0,nX:=0
      local cNewString:=AllTrim(cString)
      local nLen:=Len(cNewString)
      FOR nX:=1 to nLen
         nNumber+=(At(SubStr(cNewString,nX,1),'0123456789ABCDEF')-1)*(16**(nLen-nX))
      NEXT nX
   RETURN nNumber

   FUNCTION us_b2d(cBinary)
      LOCAL i,nDecimal:=0, asc_digito:=0, num_digito:=0, longi:=len(cBinary)
      for i=longi to 1 step -1
         num_digito:=val(substr(cBinary,i,1))
         nDecimal=nDecimal+(num_digito*(2**(longi-i)))
      next
   RETURN int(nDecimal)

#endif

FUNCTION us_synchsafe(estring)
   LOCAL total:=0, onebyte:="", i:=0, b:=0, expo:=0
   for i=len(estring) to 1 step -1
       onebyte=us_c2bv(substr(estring,i,1))   && the FUNCTION us_c2bv is only for compatibility with non ca-tools
       for b=0 to 6
           total:=total + (us_bit(onebyte,b) * (2**expo))
           expo++
       next
   next
RETURN int(total)
*/

*//------------------------------------------------------------------------\\*
*// $fin funciones para manejo de bits y numeros hexadecimales
*//========================================================================\\*

/* funcion sin probar */
Function US_IsDllAccess( DllName )
   Local hInstDLL := ::LoadLibrary( DllName )
   if !empty( hInstDll )
      ::FreeLibrary( hInstDLL )
   else
      Return .F.
   endif
Return .T.

Function US_DirRemove( dire )
   Local arc , f , reto := .T.
   if US_IsDirectory( dire )
      arc := DIRECTORY( dire+DEF_SLASH+"*.*" , "DSH" )
      for f:=1 to len( arc )
         US_DoEvents()
         if arc[f][1] == "." .or. arc[f][1] == ".."
         else
            if at( "D" , arc[f][5] ) > 0
               US_DirRemove( US_FileNameOnlyPath( dire ) + DEF_SLASH + arc[f][1] )
            else
               ferase( dire + DEF_SLASH + arc[f][1] )
            endif
         endif
      next f
      if DirRemove( dire ) != 0
         reto := .F.
      endif
   endif
Return reto

Function US_DirRemoveLoop( cDir , nSeconds )
   Local nSecAux := seconds()
   do while !US_DirRemove( cDir ) .and. ( seconds() - nSecAux ) < nSeconds
   enddo
Return .T.

Function US_FileInUse( cOutputName )
   Local hHandAux
   if file( cOutputName )
   // hHandAux := fopen( cOutputName , 16 )
      hHandAux := fopen( cOutputName , FO_WRITE + FO_EXCLUSIVE )
      if ferror() == 0
         fclose( hHandAux )
      else
         Return .T.
      endif
   endif
Return .F.

*//========================================================================\\*
*// $ini funcion para eliminar el caracter x'1A' que deja el memowrit al final del campo generado
*// Retorna: 0 si el caracter no existe (no hace nada)
*//          1 si pudo reemplazar el caracter
*//          2 si tubo algun problema
*//------------------------------------------------------------------------\\*
Function US_FileChar26Zap( cFile )
   Local nHndIn , reto := -1 , cAux := " " , cLinea := Space( 1024 ) , nLeidosTotal := 0 , nLenFileOut := 0 , nLeidosLoop := 0
   Local cFileOut := US_FileNameOnlyPathAndName( cFile ) + "_T" + ALLTRIM( STR( INT( SECONDS() ) ) ) + "." + US_FileNameOnlyExt( cFile )
   Local nHndOut := 0
// nHndIn := fopen( cFile , 2 )
   nHndIn := fopen( cFile , FO_READWRITE )
   fseek( nHndIn , -1 , 2 )
   if fread( nHndIn , @cAux , 1 ) == 1
      if cAux == chr( 26 )
         fseek( nHndIn , 0 , 0 )
         nLeidosTotal := 0
         if ( nHndOut := fcreate( cFileOut ) ) >= 0
            nLenFileOut :=  US_FileSize( cFile ) - 1
            do while ( nLeidosLoop := fread( nHndIn , @cLinea , if( ( nLenFileOut - nLeidosTotal ) > 1024 , 1024 , nLenFileOut - nLeidosTotal ) ) ) > 0
               nLeidosTotal := nLeidosTotal + nLeidosLoop
               if fwrite( nHndOut , cLinea , nLeidosLoop ) != nLeidosLoop
                  fclose( nHndIn )
                  fclose( nHndOut )
                  US_Log( "Error in write output file '" + cFileOut + "'" )
                  return -1
               endif
            enddo
            fclose( nHndOut )
        //  if US_FileSize( cFileOut ) != nLenFileOut
        //     US_Log( "Error in len of Output File '" + cFileOut )
        //     return -1
        //  endif
        //  -----
        //  El párrafo anterior lo suspendí porque le fallaba a una persona
        //  from    Gilbert Vaillancourt <gilbert.vaillancourt@videotron.ca>
        //  to
        //  date    Mon, Mar 28, 2011 at 6:03 PM
        //  subject Error with QPM
        //  Stack(17) US_FILECHAR26ZAP(2287): Error in len of output file z:\gencolor\_2011032860940_Temp_T61259.bc
        //  -----
         else
            fclose( nHndIn )
            US_Log( "Error in create file '"+cFileOut+"', fError=" + US_TodoStr( fError() ) )
            return -1
         endif
         reto := 1
      else
         reto := 0
      endif
   endif
   fclose( nHndIn )
   if reto == 1
      ferase( cFile )
      frename( cFileOut , cFile )
   endif
Return Reto

*//========================================================================\\*
*// $ini funcion para eliminar el caracter x'1A' al final de un campo memo
*// Retorna String sin el char
*//------------------------------------------------------------------------\\*
Function US_MemoChar26Zap( cMemo )
   Local cMemoOut
   if substr( cMemo , len( cMemo ) , 1 ) == chr( 26 )
      cMemoOut := substr( cMemo , 1 , len( cMemo ) - 1 )
   else
      cMemoOut := cMemo
   endif
Return cMemoOut

*//========================================================================\\*
*// $ini funcion para nombre corto de archivo
*//------------------------------------------------------------------------\\*
Function US_ShortName( nombre )
Local Reto := "" , error := .F.
   /* INI parche para parentesis por make GCC */
// if at( "(" , Reto ) > 0 .or. ;
//    at( ")" , Reto ) > 0 .or. ;
//    at( "&" , Reto ) > 0 .or. ;
//    at( "'" , Reto ) > 0
//    MsgStop( "This name: "+nombre+HB_OsNewLine()+"don't work correctly with make utility. Please, use a name without parenthesis characters.", NIL, NIL, .F. )  // this is not translated
//    Reto := ""
// endif
   /* FIN parche para parentesis por make GCC */
   if US_IsDirectory( nombre )
      Reto := US_GetShortPathName( nombre )
   else
      Reto := US_GetShortFileName( nombre )
   endif
   /* ini parche para Novell */
   if Reto == ""
      return Reto
   endif
   if at( chr( 0 ) , Reto ) > 0
      if us_words( nombre ) > 1
         MsgInfo( "Name: "+nombre+HB_OsNewLine()+"includes spaces, it won't work correctly with Novell. Please, use a name without spaces.", NIL, NIL, .F. )
         Reto := ""
      else
         Reto := nombre
      endif
   else
      if US_IsDirectory( nombre ) .and. !US_IsDirectory( Reto )
         error := .T.
      endif
      if file( nombre ) .and. !file( Reto )
         error := .T.
      endif
      if error
         MsgStop( "This name: "+nombre+HB_OsNewLine()+"don't work correctly with Novell. Please, use a name without spaces and tokens with 8 characters or less.", NIL, NIL, .F. )  // this is not translated
         Reto := ""
      endif
   endif
   /* fin parche para Novell */
   /* INI parche para parentesis */
   if at( "(" , Reto ) > 0
      MsgStop( "This name: "+nombre+HB_OsNewLine()+"don't work correctly. Please, use a name without parenthesis characters.", NIL, NIL, .F. )  // this is not translated
      Reto := ""
   endif
   /* FIN parche para parentesis */
Return reto

Function US_GetShortPathName( cPath )
   Local tmp , cFileTMP := US_FileTMP( cPath + If( Right( cPath , 1 ) != DEF_SLASH , DEF_SLASH , '' ) + "_Path" )
   memowrit( cFileTMP , "Temp from " + Procname() )
   tmp:=US_GetShortFileName( cFileTMP )
   tmp := US_FileNameOnlyPath( tmp )
   ferase( cFileTMP )
Return tmp

Function US_GetShortFileName( cPath )
   Local sShortPathName:="" ,lRetVal
   if file( cPath )
      lRetVal := USAUX_GETSHORTPATHNAME(cPath,@sShortPathName)
   endif
Return sShortPathName
*//------------------------------------------------------------------------\\*
*// $fin funcion para nombre corto de archivo
*//========================================================================\\*

Function US_IsDirectory( Dire )
#ifndef __XHARBOUR__
Return MyIsDirectory( Dire )
#else
   if Dire == NIL
      Return .F.
   endif
   if substr( Dire , len( Dire ) - 2 ) == "*.*"
      Return .F.
   endif
Return IsDirectory( Dire )
#endif

*//========================================================================\\*
*// FUNCION PARA retornar un substr a partir de la posicion de una palabra
*//========================================================================\\*
Function US_WordSubstr( estring , pos )
   if Estring == NIL
      Estring := ""
   endif
Return substr( estring , us_wordind( estring , pos ) )

*//========================================================================\\*
*// FUNCION PARA saber si existe una variable
*//========================================================================\\*
FUNCTION US_IsVar(var)
   LOCAL bSaveHandler
   LOCAL oError
   Local a
   if at( "." , var ) > 0
      var := strtran( var , "." , " " )
      return _IsControlDefined( US_Word( var , 2 ) , US_Word( var , 1 ) )
   endif
   bSaveHandler := errorblock( { |x| break(x) } )
   BEGIN SEQUENCE
      a := &VAR
   RECOVER USING oError
      USERROR = oError:genCode   && CODIGO DEL ERROR, NO LO ESTOY USANDO
      RETURN .F.
   END
   errorblock( bSaveHandler )
RETURN .T.

*//========================================================================\\*
*// FUNCION PARA saber el tipo de contenido de una variable
*//========================================================================\\*
FUNCTION US_VarType(var)
   if US_IsVar( var )
      Return ValType( &VAR )
   endif
RETURN ""

Function US_FileNameOnlyExt( arc )
   /* Si cancela en la siguiente linea con substr(0) es un problema del GetFile que le mete algun caracter raro */
   /* cuando escribimos un nombre que no existe y presionamos enter, con el boton no da el problema */
   arc := substr( arc , rat( DEF_SLASH , arc ) + 1 )
   if US_IsDirectory( arc )
      Return ""
   endif
   if rat( "." , arc ) == 0
      return ""
   endif
return substr( arc , rat( "." , arc ) + 1 )

Function US_FileNameOnlyName( arc )
   Local barra , punto , reto
   if arc == NIL
      arc := ""
   endif
   barra:=rat( DEF_SLASH , arc )
   punto:=rat( "." , arc )
// if US_IsDirectory( arc )    // CDQ revisar esto lo saque porque devuelve "" cuando el parametro coincide con un nombre de directorio (de casualidad)
//    Return ""
// endif
   do case
      case punto > barra
         reto := substr( arc , barra + 1 , punto - barra - 1 )
      case punto = 0
         reto := substr( arc , barra + 1 )
      case punto < barra
         reto := substr( arc , barra + 1 )
   endcase
Return reto

Function US_FileNameOnlyPath( arc )
// Local cReto := ""
   if arc == NIL
      Return ""
   endif
   if US_IsDirectory( arc )  //  .and. substr( arc , len( arc ) - 2 ) != "*.*"
      return arc
   endif
Return substr( arc , 1 , rat( DEF_SLASH , arc ) - 1 )
// cReto := substr( arc , 1 , rat( DEF_SLASH , arc ) - 1 )
//Return if( substr( cReto , 2 , 1 ) == ":" .and. len( cReto ) == 2 , cReto + DEF_SLASH , cReto )

Function US_FileNameOnlyPathAndName( arc )
   Local cPath := US_FileNameOnlyPath( arc ) , cName := US_FileNameOnlyName( arc )
Return cPath + if( !empty( cPath ) .and. !empty( cName ) , DEF_SLASH , "" ) + cName

Function US_FileNameOnlyNameAndExt( arc )
   Local cExt := US_FileNameOnlyExt( arc )
Return US_FileNameOnlyName( arc ) + if( !empty( cExt ) , "." , "" ) + cExt

*//========================================================================\\*
*// FUNCION PARA DETERMINAR EL NUMERO DE PALABRA DE UNA PALABRA que comienza con un string EN UN ESTRING determinado
*// OJO, ES EL NUMERO DE PALABRA, NO EL BYTE DEL OFFSET
*//========================================================================\\*
Function US_WordStrPos( cSubStr , cString )
   Local I
   cSubStr:=ALLTRIM(cSubStr)
   cString:=ALLTRIM(cString)
   FOR I=1 TO US_WORDS(cString)
      IF at( cSubStr , US_WORD(cString,I) ) = 1
         RETURN I
      ENDIF
   NEXT
RETURN 0

Function US_FileDateTime(cFile)
   Local vFile
//us_log( cFile )
   vFile:=DIRECTORY( cFile , "HS" )
   if len(vFile) = 1
          //  aaaammdd           HH                              MM                              SS
      Return dtos(vFile[1][3]) + substr( vFile[1][4] , 1 , 2 ) + substr( vFile[1][4] , 4 , 2 ) + substr( vFile[1][4] , 7 , 2 )
   endif
Return "99999999999999"

Function US_IsVarDefined( nombre )
   LOCAL bSaveHandler , A
   LOCAL oError
   bSaveHandler := errorblock( { |x| break(x) } )
   BEGIN SEQUENCE
         A=&nombre
      RECOVER USING oError
         USERROR = oError:genCode   && CODIGO DEL ERROR, NO LO ESTOY USANDO
         RETURN .F.
   END
   errorblock( bSaveHandler )
RETURN .T.

FUNCTION US_DateTime()
   Local tiempo := Time()
RETURN DTOS(DATE())+substr(tiempo,1,2)+substr(tiempo,4,2)+substr(tiempo,7,2)

//#ifdef __XHARBOUR__
FUNCTION US_DateTimeCen()
   Local nCen := 0 , nTiempo , nSecCen := TIMETOSEC()
   nTiempo := SECTOTIME( INT( nSecCen ) )
   nCen := ( nSecCen - INT( nSecCen ) ) * 100
RETURN DTOS(DATE())+substr(nTiempo,1,2)+substr(nTiempo,4,2)+substr(nTiempo,7,2)+alltrim(US_strcero(nCen,2))
//#endif

Function US_USlash( arc )
Return strtran( arc , "\" , "/" )

Function US_WSlash( arc )
Return strtran( arc , "/" , "\" )

Function US_FileNameCase( cFile )
   Local vCaseName
   if file( cFile )
      nCaseName := Directory( cFile , "HS" )
      Return nCaseName[1][1]
   endif
Return cFile

// Recibe nombre completo, por ejemplo: http://www.yahoo.com/hbole.zip   (retorna .F.)
// o                                    D:\myCust\popo.zip               (Retorna .T.)
// No verifica existencia del archivo
Function US_IsLocalFile( cF )
   Local cFile := alltrim( strtran( strtran( upper( cF ) , '"' , " " ) , "'" , " " ) )
   if !FILEVALID( US_FileNameOnlyNameAndExt( cFile ) , 255 , 50 )
      Return .F.
   endif
   if at( "#" , cFile ) > 0
      Return .F.
   endif
   if at( "HTTP://" , cFile ) == 1
      Return .F.
   endif
   if at( "HTTP:\\" , cFile ) == 1
      Return .F.
   endif
   if at( "HTTPS://" , cFile ) == 1
      Return .F.
   endif
   if at( "HTTPS:\\" , cFile ) == 1
      Return .F.
   endif
   if at( "FTP://" , cFile ) == 1
      Return .F.
   endif
   if at( "FTP:\\" , cFile ) == 1
      Return .F.
   endif
   if at( "MAILTO:" , cFile ) == 1
      Return .F.
   endif
   if at( "MAILTO:" , cFile ) == 1
      Return .F.
   endif
   if at( "?" , cFile ) > 0
      Return .F.
   endif
Return .T.

// pepe

// US_StrTran reemplaza caracteres ignorando si es mayusculas o minusculas
Function US_StrTran( cLinea , cOld , cNew , nDesde , nCant )
   LOCAL nBase , nPos , cLineaSal := "" , nContador := 0 , bTope := .F.
   LOCAL cLineaUpper , cOldUpper , cNewUpper
//us_log( cLinea )
//us_log( cold   )
//us_log( cnew   )
   if cLinea == NIL
      cLinea := ""
   endif
   cLineaUpper := upper( cLinea )
   cOldUpper := upper( cOld )
   cNewUpper := upper( cNew )
   if empty( nDesde )
      nDesde := 1
   endif
   if !empty( nCant )
      bTope := .T.
   endif
   nBase := nDesde
   cLineaSal := substr( cLinea , 1 , nBase - 1 )
// us_log( "==============================================" )
// INI Change
// do while ( ( nPos := at( cOldUpper , cLineaUpper , nBase           ) ) > 0 .and. ( !bTope .or. nContador < nCant ) )
   do while ( ( nPos := at( cOldUpper , substr( cLineaUpper , nBase ) ) ) > 0 .and. ( !bTope .or. nContador < nCant ) )
      nPos := nPos + ( nBase - 1 )
// END Change
//us_log( "--------------------------------------------" )
//us_log( nPos )
      if bTope
         nContador++
      endif
      cLineaSal := cLineaSal + substr( cLinea , nBase , nPos - nBase ) + cNew
//us_log( clineasal )
      nBase := nPos + len( cOldUpper )
//us_log( nBase )
   enddo
   if nBase < len( cLinea )
      cLineaSal := cLineaSal + substr( cLinea , nBase )
   endif
//us_log( cLineasal )
Return cLineaSal

#ifndef __XHARBOUR__
   *----------------------------------------------------------------------------
   FUNCTION FileValid( cFileName, nMaxName, nMaxExt, lWithoutExt, lSpaceInName )
   *----------------------------------------------------------------------------
   /*
   This function return by default, the MS-DOS valid file name (8x3) or an other
   format defined by user in accordance with <nMaxName> and <nMaxExt> values.
   nMaxName, nMaxExt, lWithoutExt and lSpaceInName are xHarbour extensions.
   */

   Local lRet  := .T.
   Local cName := ""
   Local cExt  := ""
   Local i     := 0
   Local cInvalid := ""
   Local nDecimalPoint := 0
   Local nFileLen := 0

   default cFileName to ""
   default nMaxName  to 8      // max file name len.
   default nMaxExt   to 3      // max extension name len.
   default lWithoutExt to .T.  // allow file name without extension.
   default lSpaceInName to .F. // allow space char in file name.

   if !HB_IsString(cFileName) .or. Empty(cFileName)
      Return .F.
   endif

   if !HB_IsNumeric(nMaxName)
      nMaxName := 8
   endif

   if !HB_IsNumeric(nMaxExt)
      nMaxExt := 3
   endif

   if !HB_IsLogical(lWithoutExt)
      lWithoutExt := .T.
   endif

   if !HB_IsLogical(lSpaceInName)
      lSpaceInName := .F.
   endif

   if nMaxName <= 0
      Return .F.
   endif

   if nMaxExt <= 0
      nMaxExt := 0
      lWithoutExt := .T.
   endif

   for i := 0 to 255
      if (i>=0  .and. i<=32) .or.;
         i=34 .or.;
         (i>=42 .and. i<=44) .or.;
         (i>=46 .and. i<=47) .or.;
         (i>=58 .and. i<=63) .or.;
         (i>=91 .and. i<=93) .or.;
          i=124 .or. i=127

          cInvalid += chr(i)

      endif
   next

   if lSpaceInName
      cInvalid := StrTran(cInvalid," ","")
   endif

   cFileName := Rtrim(cFileName)

   nDecimalPoint := At(".",cFileName)
   nFileLen      := Len( cFileName )

   if nFileLen=0 .or. nFileLen > (nMaxName+nMaxExt+1)
      lRet := .F.
   elseif nDecimalPoint > (nMaxName+1)
      lRet := .F.
   elseif nDecimalPoint > 0 .and. nMaxExt = 0
      lRet := .F.
   elseif nDecimalPoint > 0 .and. nDecimalPoint <= (nMaxName+1)
      cName := SubStr(cFileName,1, nDecimalPoint-1 )
      cExt  := SubStr(cFileName,nDecimalPoint+1 )
      if empty(cName) .or. ( !lWithoutExt .and. empty(cExt) )
         lRet := .F.
      endif
   elseif nDecimalPoint=0 .and. !lWithoutExt
      lRet := .F.
   elseif nDecimalPoint=0 .and. nFileLen > nMaxName
      lRet := .F.
   elseif nDecimalPoint=0 .and. nFileLen <= nMaxName
      cName := cFileName
   endif

   if lRet

      if !empty(cName)
         if Len(cName) > nMaxName
            lRet := .F.
         endif
      else
         lRet := .F.
      endif

      if lRet .and. ( empty(cExt) .and. !lWithoutExt )
         lRet := .F.
      endif

      if lRet .and. !empty(cExt)
         if Len(cExt) > nMaxExt
            lRet := .F.
         endif
      endif

   endif

   if lRet

      for i := 1 to Len(cName)
          if SubStr(cName,i,1) $ cInvalid
             lRet := .F.
             exit
          endif
      next

      if lRet .and. !empty(cExt)
         for i := 1 to Len(cExt)
             if SubStr(cExt,i,1) $ cInvalid
                lRet := .F.
                exit
             endif
         next
      endif

   endif

   Return (lRet)
#endif

Function US_Debug( bFlag )
Return if( bFlag , ALTD() , ALTD(0) )

*//========================================================================\\*
*// $ini funcion para nombre corto de archivo
*//------------------------------------------------------------------------\\*
Function US_GetShortFullFileName( cPath )
   Local sShortPathName:="" ,lRetVal
   if file( cPath )
      lRetVal := USAUX_GETSHORTPATHNAME(cPath,@sShortPathName)
   endif
Return sShortPathName

/*
//=========================================================================================================
// Ini Leer numero de serie de disco
//---------------------------------------------------------------------------------------------------------
FUNCTION US_HdSerial(p_hddrive)
   STATIC vhdserial
   vhdserial := HdGetSerial(p_hddrive)
   vhdserial := IIF(VALTYPE(vhdserial) == 'N',ALLTRIM(STR(vhdserial)),vhdserial)  //hb_NumToHex(vhdserial)
   vhdserial := SUBSTR(vhdserial,1,4) + '-' + SUBSTR(vhdserial,5,4)
RETURN(vhdserial)
#pragma BEGINDUMP
#define HB_OS_WIN_32_USED
#include <windows.h>
#include "winbase.h"
#include "winuser.h"
#include "item.api"
#include "hbapi.h"
HB_FUNC (HDGETSERIAL)
{
   unsigned long SerialNumber;
   GetVolumeInformation(hb_parc(1),NULL,0,&SerialNumber,NULL,NULL,NULL,0);
   hb_retnl(SerialNumber);
}
#pragma enddump
//---------------------------------------------------------------------------------------------------------
// Fin Leer numero de serie de disco
//=========================================================================================================
*/

// Dado un Path devuelve su nombre corto
Function US_PathShortName( cPath )
   Local cDisc := DiskName() , cCurDir := CurDir() , cReto ,  cArc := "_temp"+US_NameRandom()
   memowrit( cArc , "." )
   cReto := US_ShortName( cDisc+":" + DEF_SLASH+cCurDir+DEF_SLASH+cArc )
   cReto := US_FileNameOnlyPath( cReto )
   ferase( cArc )
Return cReto

// Esta funcion nace por la necesidad de reemplazar la funcion filecopy que deja tomado el directorio de destino
// La funcion filecopy es interesante porque devuelve la cantidad de bytes copiados
Function US_FileCopy( cIn , cOut )
   Local nLen := 0
   if file( cOut )
      if ferase( cOut ) != 0
         US_Log( "Error en delete de file destino: " + cOut , .F. )
         Return 0
      endif
   endif
   __CopyFile( cIn , cOut )        // siempre retorna NIL
   nLen := US_FileSize( cOut )
   if nLen == -1
      US_Log( "Error en Len de file destino: " + cOut , .F. )
      nLen := 0
   endif
Return nLen

Function US_CopyFileMulti( cIn , cOut )
   Local vAux := Directory( cIn , "HSD" ) , i , bReto := .T. , cPath := "" , cAux
   if !empty( cAux := US_FileNameOnlyPath( cIn ) )
      cPath := cAux + DEF_SLASH
   endif
   if !US_IsDirectory( cOut )
      if !US_CreateFolder( cOut )
         US_Log( "Unable to create folder: " + cOut )
         Return .F.
      endif
   endif
   for i:=1 to len(vAux)
      US_DoEvents()
      if vAux[i][2] != US_FileCopy( cPath + vAux[i][1] , cOut + DEF_SLASH + vAux[i][1] )
         bReto := .F.
      endif
   next
Return bReto

Function US_CopyFileTree( cIn , cOut )
   Local vAux := Directory( cIn +DEF_SLASH+"*.*" , "HSD" ) , i , bReto := .T. , cPath := "" , cAux
   if !empty( cAux := US_FileNameOnlyPath( cIn ) )
      cPath := cAux + DEF_SLASH
   endif
   if !US_IsDirectory( cOut )
      if !US_CreateFolder( cOut )
         US_Log( "Unable to create folder: " + cOut )
         Return .F.
      endif
   endif
   for i:=1 to len(vAux)
      US_DoEvents()
      if vAux[i][1] == "." .or. vAux[i][1] == ".."
      else
         if at( "D" , vAux[i][5] ) > 0
            US_CopyFileTree( cIn + DEF_SLASH + vAux[i][1] , cOut + DEF_SLASH + vAux[i][1] )
         else
            if vAux[i][2] != US_FileCopy( cPath + vAux[i][1] , cOut + DEF_SLASH + vAux[i][1] )
               bReto := .F.
            endif
         endif
      endif
   next
Return bReto

Function US_CreateFolder( par_cName )
   Local Loc_nSlash := 0 , Loc_nInx := 0 , Loc_cDir := "" , Loc_cFirstCreated := "" , Loc_nPos := 0
   if !( right( par_cName , 1 ) == DEF_SLASH )
      par_cName := par_cName + DEF_SLASH
   endif
   Loc_nSlash := NumAt( DEF_SLASH , par_cName )
//us_log( par_cName )
//us_log( Loc_nSlash )
   Loc_nPos := 3
   for Loc_nInx := 1 to ( Loc_nSlash - 1 )
      Loc_nPos := US_At( DEF_SLASH , par_cName , Loc_nPos + 1 )
      Loc_cDir := Substr( par_cName , 1 , Loc_nPos - 1 )
//  us_log( Loc_cDir )
      if !US_IsDirectory( Loc_cDir )
         CreateFolder( Loc_cDir )
         if empty( Loc_cFirstCreated )
            Loc_cFirstCreated := Loc_cDir
         endif
         if !US_IsDirectory( Loc_cDir )
//us_log( "previo remove: " + Loc_cFirstCreated )
            US_DirRemove( Loc_cFirstCreated )
            return .F.
         endif
      endif
   next
Return .T.

//==================================================================================\\
FUNCTION US_IsEmailAddress( cEmailAddress )
   LOCAL lRetorno, cValidChars, nChar, cChar, cBeforeAt, cAfterAt, nDot, nRDot, nAt, nRat, nLen
   LOCAL nLeftBracket, nRightBracket, cInBrackets, nLenTemp
   lRetorno       := .F.
   cEmailAddress  := IF(VALTYPE(cEmailAddress) <> "C", "", ALLTRIM(cEmailAddress))
   nLen           := LEN(cEmailAddress)
   cValidChars    := '1234567890-_.^@~abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ[]'
   IF !EMPTY(cEmailAddress)
      FOR nChar := 1 TO nLen
         cChar := SUBSTR(cEmailAddress, nChar, 1)
         IF AT(cChar, cEmailAddress) == 0
            RETU lRetorno
         ENDI
      NEXT
      nAt            := AT("@", cEmailAddress)
      nRat           := RAT("@", cEmailAddress)
      nDot           := AT(".", cEmailAddress)
      nRDot          := RAT(".", cEmailAddress)
      nLeftBracket   := AT("[", cEmailAddress)
      nRightBracket  := AT("]", cEmailAddress)
      IF (nLeftBracket > 0 .AND. nRightBracket < 1) .OR. ;
         (nRightBracket > 0 .AND. nLeftBracket < 1) .OR. ;
         (nLeftBracket > nRightBracket)
         RETU lRetorno
      ENDI
      IF (nAt == 0 .OR. nAt == 1) .OR. ;
         (nRat <> nAt) .OR. ;
         (nDot == 0  .OR. nDot <= 2 .OR. nDot + 2 > nLen) .OR. ;
         (nRat > nRDot)

         RETU lRetorno
      ENDI
      IF nLeftBracket > 0
         IF nRat > nLeftBracket
            RETU lRetorno
         ENDI
      ENDI
      lRetorno := .T.
   ENDI
RETU lRetorno
//==================================================================================\\

//==================================================================================\\
//= Function US_IsNT                                                               =\\
//= USE:                                                                           =\\
//= US_IsNT()                                                                      *\\
//= Idiomas: 0 Espa±ol (Default) - 1 Ingles                                        =\\
//= Retorna:                                                                       =\\
//=  .T. = NT/2000/XP detected                                                     =\\
//=  .F. = NOT NT/2000/XP detected                                                 =\\
//----------------------------------------------------------------------------------\\
Function US_IsNT()
return ( GetE("OS") == "Windows_NT" )
//= END Function US_IsNT                                                           =\\
//==================================================================================\\

#ifndef __XHARBOUR__
Function US_DeleteFileMulti( cIn )
   Local vAux := Directory( cIn , "HS" ) , i
   for i:=1 to len(vAux)
      ferase( vAux[i][1] )
   next
Return
#else
Function US_DeleteFileMulti( cIn )
Return FileDelete( cIn )
#endif

Function US_DoEvents()
  while US_ProcessMess()
  enddo
return

//=========================================================================================================
// Ini Leer linea de archivo binario
//---------------------------------------------------------------------------------------------------------
Function US_fReadLine( hFile , cLinea , vFines )
Return HB_fReadLine( hFile , @cLinea , vFines )
// La siguiente funcion ejecuta correctamente, falta aggiornarla para archivos con final de linea tipo UNIX
//Return US_fReadLineXXXXX( hFile , @cLinea , vFines )
Function US_fReadLineXXXXX( nHnd , cLineOut , cDummy2 )
 //Local cLineOut, cChunk, cBigChunk, nOldOffset, nAtChr13
   Local nLastPos := 0 , nLenFile := 0
   Local cChunk := "" , cBigChunk := "" , nOldOffset := 0 , nAtChr13 := 0
   cLineOut := ""
   nOldOffset := FSEEK( nHnd , 0 , 1 )
   nLenFile  := FSEEK( nHnd , 0 , 2 )
   FSEEK( nHnd , nOldOffset , 0 )
   if nOldOffset > nLenFile
      return -1
   endif
   DO WHILE .T.
      *- read in a Chunk of the file
      cChunk := ''
      cChunk := Freadstr( nHnd , 100 )
      *- if we didn't read anything in, guess we're at the EOF
      IF LEN( cChunk ) = 0
         endof_file := .T.
         IF !EMPTY( cBigChunk )
           cLineOut := cBigChunk
         ENDIF
         EXIT
      elseif len( cBigChunk ) > 1024
         EXIT
      ENDIF
      *- add this chunk to the big chunk
      cBigChunk += cChunk
      *- if we've got a CR , we've read in a line
      *- otherwise we'll loop again and read in another chunk
      IF AT( CHR( 13 ) , cBigChunk ) > 0
         nAtChr13 := AT( CHR( 13 ) , cBigChunk )
         *- go back to beginning of line
         FSEEK( nHnd , nOldOffset )
         *- read in from here to next CR (-1)
         cLineOut := Freadstr( nHnd , nAtChr13 - 1 )
         *- move the pointer 1 byte
         FSEEK( nHnd , 1 , 1 )
         EXIT
      ENDIF
   ENDDO
   *- move the pointer 1 byte
   *- this should put us at the beginning of the next line
   if FSEEK( nHnd , 1 , 1 ) > nLenFile
      cLineOut := US_MemoChar26Zap( cLineOut )
   endif
*- return the contents of the line
// RETURN cLineOut
RETURN 0
//--------------------------------------------------------------------------------------------------------
// Fin Leer linea de archivo binario
//=========================================================================================================

#pragma BEGINDUMP
#define _WIN32_IE      0x0500
#define HB_OS_WIN_32_USED
#define _WIN32_WINNT   0x0400

#include <windows.h>
#include "hbapi.h"

HB_FUNC(USAUX_GETSHORTPATHNAME)
{
   char buffer[ MAX_PATH + 1 ] = {0};
   DWORD iRet;

   iRet = GetShortPathName( hb_parc(1), buffer, MAX_PATH ) ;
   if (iRet < MAX_PATH) {
   hb_storclen( buffer, iRet, 2);
   }
   else
   {
   hb_storc( "", 2 );
   }
   hb_retnl( iRet ) ;
}

//=========================================================================================================
// Ini Leer nombre de computadora y usuario
//---------------------------------------------------------------------------------------------------------
// BOOL GetComputerName( LPTSTR lpBuffer, LPDWORD nSize )
// http://msdn.microsoft.com/library/default.asp?url=/library/en-us/sysinfo/base/getcomputername.asp
// Devuelve el nombre del PC.
HB_FUNC ( US_GETCOMPUTERNAME )
{
   TCHAR lpBuffer[255];
   DWORD nSize = 255;
   GetComputerName( lpBuffer, &nSize );
   hb_retc( lpBuffer );
}
// BOOL GetUserName( LPTSTR lpBuffer, LPDWORD nSize );
// http://msdn.microsoft.com/library/default.asp?url=/library/en-us/sysinfo/base/getusername.asp
// Devuelve el nombre del usuario.
HB_FUNC ( US_GETUSERNAME )
{
   TCHAR lpBuffer[MAX_PATH + 1];
   DWORD nSize = MAX_PATH;
   GetUserName( lpBuffer, &nSize );
   hb_retc( lpBuffer );
}
//---------------------------------------------------------------------------------------------------------
// Fin Leer nombre de computadora y usuario
//=========================================================================================================

//=========================================================================================================
// Ini Verificar Directorio
//---------------------------------------------------------------------------------------------------------
#include <winbase.h>
#include "hbvm.h"
#include "hbstack.h"
#include "hbapiitm.h"

BOOL DirectoryExists( LPTSTR szDirName )
{
   unsigned int nAttributes;
   if ( ( nAttributes = GetFileAttributes( szDirName ) ) == -1 ) return FALSE;
   if ( ( nAttributes & FILE_ATTRIBUTE_DIRECTORY ) != 0 ) return TRUE;
   return FALSE;
}
HB_FUNC( MYISDIRECTORY )
{
   hb_retl( DirectoryExists( (LPTSTR) hb_parc(1) ) ) ;
}
//---------------------------------------------------------------------------------------------------------
// Fin Verificar Directorio
//=========================================================================================================

//==================================================================================\\
//= Function US_NT_Administrator                                                   =\\
//= USE:                                                                           =\\
//= US_NT_Administrator()                                                          *\\
//= Idiomas: 0 Espa±ol (Default) - 1 Ingles                                        =\\
//= Retorna:                                                                       =\\
//=    0 = ---- los codigos de retorno no estan implementados                      =\\
//----------------------------------------------------------------------------------\\
HB_FUNC( US_NT_ADMINISTRATOR )
{
   LUID tmpLuid;
   TOKEN_PRIVILEGES tkp, tkpNewButIgnored;
   DWORD lBufferNeeded;
   HANDLE hdlTokenHandle;
   HANDLE hdlProcessHandle = GetCurrentProcess();
   OpenProcessToken(hdlProcessHandle, TOKEN_ADJUST_PRIVILEGES | TOKEN_QUERY, &hdlTokenHandle);
   LookupPrivilegeValue(NULL, "SeShutdownPrivilege", &tmpLuid);
   tkp.PrivilegeCount            = 1;
   tkp.Privileges[0].Luid        = tmpLuid;
   tkp.Privileges[0].Attributes  = SE_PRIVILEGE_ENABLED;
   AdjustTokenPrivileges(hdlTokenHandle, FALSE, &tkp, sizeof(tkpNewButIgnored), &tkpNewButIgnored, &lBufferNeeded);
}
//= END Function US_NT_Administrator                                               =\\
//==================================================================================\\

#include <shlobj.h>
#include <shlwapi.h>
#include <winerror.h>
#include <lmcons.h>
#include <commctrl.h>
#include "hbapifs.h"
#include "tchar.h"
#include "item.api"
HB_FUNC( US_PROCESSMESS )
{
   MSG   Msg;

   if( PeekMessage((LPMSG) & Msg, 0, 0, 0, PM_REMOVE) )
   {
      TranslateMessage( &Msg );
      DispatchMessage( &Msg );
      hb_retl( TRUE );
   }
   else
   {
      hb_retl( FALSE );
   }
}
#pragma ENDDUMP

/* eof */
