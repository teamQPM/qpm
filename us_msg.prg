/*
 * $Id$
 */

/*
 *    QPM - QAC based Project Manager
 *
 *    Copyright 2011-2016 Fernando Yurisich <fernando.yurisich@gmail.com>
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
   Local Version:="01.01"
   Local cFileMemo := "" , cFileOut := "" , cMSG := ""
   Local cParam := "" , cChkFile := ""

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
      MemoWrit( "US_Msg.version" , Version )
      Return .T.
   endif

   cFileOut := substr( cParam , 1 , rat( "-MSG:" , upper( cParam ) ) - 1 )
   cMSG := substr( cParam , rat( "-MSG:" , upper( cParam ) ) + 5 )
   cChkFile := substr( cFileOut , 1 , rat( "\" , cFileOut ) + 15 ) + "MSG.SYSIN"

   if file( cChkFile )
      if US_Word( Memoread( cChkFile ) , 1 ) == "STOP"
         ferase( cChkFile )
         __Run( "ECHO " + ".               ============================================================" )
         __Run( "ECHO " + ".               ==              Build Proccess Stoped by User             ==" )
         __Run( "ECHO " + ".               ============================================================" )
         ERRORLEVEL(1)
         return .F.
      endif
   endif

   if file( cFileOut )
      cFileMemo := memoread( cFileOut )
   endif
   cFileMemo := cFileMemo + US_TimeDis( Time() ) + " - " + cMSG + HB_OsNewLine()
   memowrit( cFileOut , cFileMemo )
// ? cmsg
// __run( "pause" )
return .T.

//========================================================================
// FUNCION PARA EXTRAER UNA PALABRA DE UN ESTRING
//========================================================================
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

//========================================================================
// FUNCION PARA MOSTRAR UN CAMPO TIME SIN CEROS A LA IZQUIERDA
//========================================================================
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

/* eof */
