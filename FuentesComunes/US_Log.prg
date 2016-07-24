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

Function US_Log( cTexto , bDisplay , bStack )
   Local bReto , i
   Local MSG := "" , vStack := {}
   if bStack == NIL
      bStack := .F.
   endif
   if bStack
      vStack := US_LogStackChar()
      for i := 1 to len( vStack )
         MSG := MSG + if( i > 1 , replicate( " " , 25 ) , "" ) + vStack[i] + HB_OsNewLine()
      Next
   endif
   MSG:=MSG+if(bstack,replicate(" ",25),"")+"Stack("+alltrim(str(US_LogStackNum()))+") "+Procname(1)+"("+alltrim(str(procline(1)))+"): "
   if bDisplay == NIL
      bDisplay := .T.
   endif
   bReto := US_LogAuxiliar( MSG + US_LogTodoStr( cTexto ) , if( bDisplay , 1 , 0 ) )
Return if( bReto == 0 , .T. , .F. )

#pragma BEGINDUMP
#include "hbapi.h"
#include "US_Log.h"

HB_FUNC(US_LOGAUXILIAR)
{
  hb_retni( us_log( (char *) hb_parc(1), (int) hb_parni(2) ) );
  return;
}
#pragma ENDDUMP

Function US_LogStackNum()
   Local n:=1
   WHILE ! Empty( ProcName( n ) )
      n++
   ENDDO
Return n - 1

Function US_LogStackChar()
   Local vec:={} , n:=1
   WHILE !Empty( ProcName( n ) )
      n++
      aadd( vec , ProcName( n ) + "(" + alltrim( str( Procline( n ) ) ) + ")" )
      if upper( alltrim( ProcName( n ) ) ) == "MAIN"
         exit
      endif
   ENDDO
Return vec

Function US_LogTodoStr(X)
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
      case T='M'
         return X
      case T='D'
         StringAux=DTOS(X)
         return StringAux
      case T='N'
         StringAux=US_LogSTRCERO(X)
         return StringAux
      case T='L'
         StringAux=IF(X,'.T.','.F.')
         return StringAux
      case T='A'
         for i=1 to ( len(x) - 1 )
            StringAux:=StringAux + US_LogTodoStr( x[i] ) + HB_OSNewLine()
         next
         if len(x) > 0
            StringAux:=StringAux + US_LogTodoStr( x[len(x)] )
         endif
         return StringAux
   endcase
return ""

Function US_LogStrCero(NUM,LONG,DEC)
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

/* eof */
