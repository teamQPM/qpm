/*
 *    QPM - QAC based Project Manager
 *
 *    Copyright 2011-2021 Fernando Yurisich <qpm-users@lists.sourceforge.net>
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
#include "fileio.ch"
#include "minigui.ch"

#xcommand ?? <texto> => US_LOG( <texto> , .T. )
#xcommand ? <texto> => US_LOG( <texto> , .T. )
#translate inkey(0) => US_LOG("Inkey(0) , Presione Enter" , .T. )

Function US_IsRootFolder( cFolder )
Return if( substr( alltrim( cFolder ) , 2 , 1 ) == ":" .and. len( alltrim( cFolder ) ) == 2 , .T. , .F. )

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
   Local Loc_nAux
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
   LOCAL vStruct, vStructDelete, SALIR:=.F., cTablaBAK:="", POS, I, ;
         REGISTROS, cMemoExtType := ".DBT" , cDriver := "DBFNTX" , cDbfOld := dbf()
   cModo:=UPPER(cModo)
   IF (cModo == "ADD") .AND. (TIPO=="C" .OR. TIPO=="N") .AND. (LONGI==NIL .OR. LONGI < 1)
      ? "ERROR EN PARAMETRO LONGITUD DE FUNCION US_DB_CMP PARA CAMPO: "+CAMPO
      ? "SE HA RECIBIDO: "+US_VarToStr(LONGI)
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
               vStruct := {}
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
         REPLACE &(CAMPO) WITH field->A________A ALL
         DbCloseArea( cTabla )
         US_DB_CMP(cTabla,"DEL","A________A")
         if !empty( cDbfOld )
            DbSelectArea( cDbfOld )
         endif
         RETURN 0
      OTHERWISE
         ? "ERROR EN FUNCION US_DB_CMP, PARAMETRO 'MODO' ES INVALIDO: "+US_VarToStr(cModo)
         INKEY(0)
   ENDCASE
   if !empty( cDbfOld )
      DbSelectArea( cDbfOld )
   endif
RETURN 8

Function US_ExtractMemoKey( cMemo , cKey )
   Local nInx
   for nInx := 1 to MLCount( cMemo , 254 )
      if Upper( US_Word( MemoLine( cMemo , 254 , nInx ) , 1 ) ) == upper( cKey )
         Return US_WordSubstr( MemoLine( cMemo , 254 , nInx ) , 2 )
      endif
   next
Return NIL

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
   Local vStruct , cAreaOld := dbf()
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

Function US_NameRandom()
Return ALLTRIM(strtran(strtran(STR(seconds()),".",alltrim(str(US_Rand(seconds())))),"-","M"))

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
Return Date()

Function US_FileTime(cFile)
   Local vFile
   vFile:=DIRECTORY( cFile , "HS" )
   if len(vFile) = 1
      Return vFile[1][4]
   endif
Return -1

Function US_FileType(cFile)
   Local vFile, CurrentDisk, CurrentDir
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
LOCAL inx, aFiles, aDirec, nCant:=0, NextFolder, RetornoRecursivo
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

Function US_VarToStr(X)
   Local T, StringAux:="" , i
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
         for i:=1 to ( len(x) - 1 )
            StringAux:=StringAux + US_VarToStr( x[i] ) + HB_OSNewLine()
         next
         if len(x) > 0
            StringAux:=StringAux + US_VarToStr( x[len(x)] )
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

FUNCTION US_RAND( RANDOM )
   LOCAL NEGATIVE,TTX,TTJ,TTY,TTK,TTL,TTZ,TTS,TTT,RETT
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
*// ESTA FUNCION CONVIERTE TIME de FORMATO HH:MM:SS EN SEGUNDOS
*//========================================================================\\*
Function US_TimeSec( Tiempo )
Return (VAL(SUBSTR(TIEMPO,1,2))*3600)+(VAL(SUBSTR(TIEMPO,4,2))*60)+VAL(SUBSTR(TIEMPO,7,2))

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
   ErrorBlock( bSaveHandler )
//   IF nUsError = 21   && open exclusive by another program
//      nUsError = 0
//   ENDIF
     IF nUsError = 17   // name with "-"
        nUsError = 0
     ENDIF
RETURN nUsError

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
/*
FUNCTION US_WORDINS(ESTRING,PAL,POSICION)
   IF POSICION > US_WORDS(ESTRING)
      RETURN ESTRING+" "+PAL
   ELSE
      RETURN SUBSTR(ESTRING,1,US_WORDIND(ESTRING,POSICION)-1)+PAL+" "+SUBSTR(ESTRING,US_WORDIND(ESTRING,POSICION))
   ENDIF
Return ""
*/
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
*// ESTA FUNCION TRANSFORMA EN MAYUSCULAS STRINGS, INCLUSO CON ACENTOS.
*//========================================================================\\*
Function US_Upper(STR)
   IF valType( STR ) == "N"
      Return STR
   endif
return upper(STRTRAN(STRTRAN(STRTRAN(STRTRAN(STRTRAN(STRTRAN(STRTRAN(STRTRAN(STRTRAN(STRTRAN(STRTRAN(STRTRAN(STRTRAN(STR,"ü","U"),"ñ","N"),"Ñ","N"),"á","A"),"é","E"),"í","I"),"ó","O"),"ú","U"),"Á","A"),"É","E"),"Í","I"),"Ó","O"),"Ú","U"))

FUNCTION US_DateSeconds()
RETURN DTOS(DATE())+US_STRCERO(SECONDS(),5)

FUNCTION US_Dis_DateSeconds(DS, bInvertido)
   Local cReto
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
   Local cReto
   if empty( bInvertido )
      bInvertido := .F.
   endif
   if bInvertido
      cReto := US_SecTime( val( SubStr( DS , 9 ) ) )+" "+SUBSTR(DS,1,4)+"/"+SUBSTR(DS,5,2)+"/"+SUBSTR(DS,7,2)
   else
      cReto := SUBSTR(DS,1,4)+"/"+SUBSTR(DS,5,2)+"/"+SUBSTR(DS,7,2)+" "+US_SecTime( val( SubStr( DS , 9 ) ) )
   endif
RETURN cReto

FUNCTION US_DirWrite(cPath)
   LOCAL ARC:=cPath+If(Right(cPath,1)!=DEF_SLASH,DEF_SLASH,'')+"US_"+ALLTRIM(STR(INT(SECONDS())))+".CHK"
   IF MEMOWRIT(ARC,"CHECK FOR DISKW, FUNCTION US_DirWrite()")
      DELETE FILE (ARC)
      RETURN .T.
   ENDIF
Return .F.

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
      if HB_DIRDELETE( dire ) != 0
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
*//          -1 si se produjo algun problema
*//------------------------------------------------------------------------\\*
Function US_FileChar26Zap( cFile )
   Local nHndIn , reto := -1 , cAux := " " , cLinea := Space( 1024 ) , nLeidosTotal, nLenFileOut, nLeidosLoop
   Local cFileOut := US_FileNameOnlyPathAndName( cFile ) + "_T" + ALLTRIM( STR( INT( SECONDS() ) ) ) + "." + US_FileNameOnlyExt( cFile )
   Local nHndOut
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
            US_Log( "Error in create file '"+cFileOut+"', fError=" + US_VarToStr( fError() ) )
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
Local Reto
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
      if US_IsDirectory( nombre ) .and. ! US_IsDirectory( Reto )
         MsgStop( 'The name: "' + nombre + '"' + hb_osNewLine() + ;
                  "was translated by the OS to a name that's not valid for a folder:" + HB_OsNewLine() + ;
                  Reto + HB_OsNewLine() + ;
                  "Please, use a name that follows the 8.3 convention.", NIL, NIL, .F. )  // this is not translated
         Reto := ""
      elseif file( nombre ) .and. ! file( Reto )
         MsgStop( 'The name: "' + nombre + '"' + hb_osNewLine() + ;
                  "was translated by the OS to a name that's not valid for a file:" + hb_osNewLine() + ;
                  Reto + HB_OsNewLine() + ;
                  "Please, use a name that follows the 8.3 convention.", NIL, NIL, .F. )  // this is not translated
         Reto := ""
      endif
   endif
   /* fin parche para Novell */
   /* INI parche para parentesis */
   if at( "(" , Reto ) > 0
      MsgStop( "This name doesn't work correctly: " + '"' + nombre + '"' + hb_osNewLine() + ;
               "Please, use a name without parenthesis characters.", NIL, NIL, .F. )  // this is not translated
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
   Local sShortPathName:=""
   if file( cPath )
      USAUX_GETSHORTPATHNAME(cPath,@sShortPathName)
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
FUNCTION US_IsVar( cVarName )
   LOCAL oSaveHandler, oError, nError, uValue, lRet
   IF At( ".", cVarName ) > 0
      cVarName := StrTran( cVarName, ".", " " )
      RETURN _IsControlDefined( US_Word( cVarName, 2 ), US_Word( cVarName, 1 ) )
   ENDIF
   oSaveHandler := ErrorBlock( { |x| Break( x ) } )
   BEGIN SEQUENCE
      uValue := &cVarName
      Empty( uValue )
      lRet := .T.
   RECOVER USING oError
      nError = oError:genCode  
      Empty( nError )
      lRet := .F.
   END
   ErrorBlock( oSaveHandler )
RETURN lRet

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
   if arc == NIL
      Return ""
   endif
   if US_IsDirectory( arc )
      return arc
   endif
Return substr( arc , 1 , rat( DEF_SLASH , arc ) - 1 )

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

FUNCTION US_DateTime()
   Local tiempo := Time()
RETURN DTOS(DATE())+substr(tiempo,1,2)+substr(tiempo,4,2)+substr(tiempo,7,2)

//#ifdef __XHARBOUR__
FUNCTION US_DateTimeCen()
   Local nCen, nTiempo , nSecCen := TIMETOSEC()
   nTiempo := SECTOTIME( INT( nSecCen ) )
   nCen := ( nSecCen - INT( nSecCen ) ) * 100
RETURN DTOS(DATE())+substr(nTiempo,1,2)+substr(nTiempo,4,2)+substr(nTiempo,7,2)+alltrim(US_strcero(nCen,2))
//#endif

Function US_USlash( arc )
Return strtran( arc , "\" , "/" )

Function US_WSlash( arc )
Return strtran( arc , "/" , "\" )

Function US_FileNameCase( cFile )
   Local nCaseName
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
   LOCAL cLineaUpper , cOldUpper
//us_log( cLinea )
//us_log( cold   )
//us_log( cnew   )
   if cLinea == NIL
      cLinea := ""
   endif
   cLineaUpper := upper( cLinea )
   cOldUpper := upper( cOld )
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
   //---------------------------------------------------------------------------
   FUNCTION FileValid( cFileName, nMaxName, nMaxExt, lWithoutExt, lSpaceInName )
   //---------------------------------------------------------------------------
   /*
   This function return by default, the MS-DOS valid file name (8x3) or an other
   format defined by user in accordance with <nMaxName> and <nMaxExt> values.
   nMaxName, nMaxExt, lWithoutExt and lSpaceInName are xHarbour extensions.
   */

   Local lRet  := .T.
   Local cName := ""
   Local cExt  := ""
   Local i
   Local cInvalid := ""
   Local nDecimalPoint
   Local nFileLen

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
   Local sShortPathName:=""
   if file( cPath )
      USAUX_GETSHORTPATHNAME(cPath,@sShortPathName)
   endif
Return sShortPathName

// Esta funcion nace por la necesidad de reemplazar la funcion filecopy que deja tomado el directorio de destino
// La funcion filecopy es interesante porque devuelve la cantidad de bytes copiados
Function US_FileCopy( cIn , cOut )
   Local nLen
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
   Local Loc_nSlash, Loc_nInx, Loc_cDir, Loc_cFirstCreated := "" , Loc_nPos
   if !( right( par_cName , 1 ) == DEF_SLASH )
      par_cName := par_cName + DEF_SLASH
   endif
   Loc_nSlash := NumAt( DEF_SLASH , par_cName )
   Loc_nPos := 3
   for Loc_nInx := 1 to ( Loc_nSlash - 1 )
      Loc_nPos := US_At( DEF_SLASH , par_cName , Loc_nPos + 1 )
      Loc_cDir := Substr( par_cName , 1 , Loc_nPos - 1 )
      if !US_IsDirectory( Loc_cDir )
         CreateFolder( Loc_cDir )
         if empty( Loc_cFirstCreated )
            Loc_cFirstCreated := Loc_cDir
         endif
         if !US_IsDirectory( Loc_cDir )
            US_DirRemove( Loc_cFirstCreated )
            return .F.
         endif
      endif
   next
Return .T.

//==================================================================================\\
FUNCTION US_IsEmailAddress( cEmailAddress )
   LOCAL lRetorno, nChar, cChar, nDot, nRDot, nAt, nRat, nLen
   LOCAL nLeftBracket, nRightBracket
   lRetorno       := .F.
   cEmailAddress  := IF(! VALTYPE(cEmailAddress) == "C", "", ALLTRIM(cEmailAddress))
   nLen           := LEN(cEmailAddress)
   IF !EMPTY(cEmailAddress)
      FOR nChar := 1 TO nLen
         cChar := SUBSTR(cEmailAddress, nChar, 1)
         IF AT(cChar, cEmailAddress) == 0
            RETURN lRetorno
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
         RETURN lRetorno
      ENDI
      IF (nAt == 0 .OR. nAt == 1) .OR. ;
         (nRat <> nAt) .OR. ;
         (nDot == 0  .OR. nDot <= 2 .OR. nDot + 2 > nLen) .OR. ;
         (nRat > nRDot)

         RETURN lRetorno
      ENDI
      IF nLeftBracket > 0
         IF nRat > nLeftBracket
            RETURN lRetorno
         ENDI
      ENDI
      lRetorno := .T.
   ENDI
RETURN lRetorno
//==================================================================================\\

#ifndef __XHARBOUR__
Function US_DeleteFileMulti( cIn )
   Local vAux := Directory( cIn , "HS" ) , i
   for i:=1 to len(vAux)
      ferase( vAux[i][1] )
   next
Return NIL
#else
Function US_DeleteFileMulti( cIn )
Return FileDelete( cIn )
#endif

Function US_DoEvents()
  while US_ProcessMess()
  enddo
return NIL


#pragma BEGINDUMP

#define _WIN32_IE      0x0500

#include <windows.h>
#include <winbase.h>
#include "hbapi.h"
#include <shlobj.h>
#include <shlwapi.h>
#include <winerror.h>
#include <lmcons.h>
#include <commctrl.h>
#include "qpm.h"

HB_FUNC( USAUX_GETSHORTPATHNAME )
{
   char buffer[ MAX_PATH + 1 ] = {0};
   DWORD iRet;

   iRet = GetShortPathName( hb_parc( 1 ), buffer, MAX_PATH ) ;
   if( iRet < MAX_PATH )
   {
      hb_storclen( buffer, iRet, 2 );
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

BOOL DirectoryExists( LPTSTR szDirName )
{
   unsigned int nAttributes;

   if( ( nAttributes = GetFileAttributes( szDirName ) ) == -1 )
      return FALSE;
   if( ( nAttributes & FILE_ATTRIBUTE_DIRECTORY ) != 0 )
      return TRUE;
   return FALSE;
}
HB_FUNC( MYISDIRECTORY )
{
   hb_retl( DirectoryExists( (LPTSTR) hb_parc( 1 ) ) ) ;
}

/*==================================================================================\\
//= Function US_NT_Administrator                                                   =\\
//= USE:                                                                           =\\
//= US_NT_Administrator()                                                          *\\
//= Idiomas: 0 Espa±ol (Default) - 1 Ingles                                        =\\
//= Retorna:                                                                       =\\
//=    0 = ---- los codigos de retorno no estan implementados                      =\\
//----------------------------------------------------------------------------------*/
HB_FUNC( US_NT_ADMINISTRATOR )
{
   LUID tmpLuid;
   TOKEN_PRIVILEGES tkp, tkpNewButIgnored;
   DWORD lBufferNeeded;
   HANDLE hdlTokenHandle;
   HANDLE hdlProcessHandle = GetCurrentProcess();

   OpenProcessToken( hdlProcessHandle, TOKEN_ADJUST_PRIVILEGES | TOKEN_QUERY, &hdlTokenHandle );
   LookupPrivilegeValue( NULL, "SeShutdownPrivilege", &tmpLuid );
   tkp.PrivilegeCount            = 1;
   tkp.Privileges[0].Luid        = tmpLuid;
   tkp.Privileges[0].Attributes  = SE_PRIVILEGE_ENABLED;
   AdjustTokenPrivileges( hdlTokenHandle, FALSE, &tkp, sizeof( tkpNewButIgnored ), &tkpNewButIgnored, &lBufferNeeded );
}

HB_FUNC( US_PROCESSMESS )
{
   MSG Msg;

   if( PeekMessage( (LPMSG) &Msg, 0, 0, 0, PM_REMOVE ) )
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

HB_FUNC( US_C_LOADSTRING )
{
   LPBYTE cBuffer;
   cBuffer = GlobalAlloc( GPTR, 255 );
   LoadString( GetModuleHandle( NULL ), hb_parni( 1 ), (LPSTR) cBuffer, 254 );
   hb_retc( ( char * ) cBuffer );
   GlobalFree( cBuffer );
}

HB_FUNC( US_C_GETFILE )
{
   OPENFILENAME ofn;
   char buffer[32768];
   char cFullName[64][1024];
   char cCurDir[512];
   char cFileName[512];
   int iPosition = 0;
   int iNumSelected = 0;
   int n;
   int flags = 0 ;
// int flags = OFN_FILEMUSTEXIST ;

   buffer[0] = 0 ;
   if ( hb_parl( 4 ) )
   {
      flags = flags | OFN_ALLOWMULTISELECT | OFN_EXPLORER;
   }
   if ( hb_parl( 5 ) )
   {
      flags = flags | OFN_NOCHANGEDIR;
   }

   memset( (void*) &ofn, 0, sizeof( OPENFILENAME ) );
   ofn.lStructSize = sizeof( ofn );
   ofn.hwndOwner = GetActiveWindow();
   ofn.lpstrFilter = hb_parc( 1 );
   ofn.nFilterIndex = 1;
   ofn.lpstrFile = buffer;
   ofn.nMaxFile = sizeof( buffer );
   ofn.lpstrInitialDir = hb_parc( 3 );
   ofn.lpstrTitle = hb_parc( 2 );
   ofn.nMaxFileTitle = 512;
   ofn.Flags = flags;

   if ( GetOpenFileName( &ofn ) )
   {
      if(ofn.nFileExtension!=0)
      {
         hb_retc( ofn.lpstrFile );
      }
      else
      {
         wsprintf(cCurDir,"%s",&buffer[iPosition]);
         iPosition=iPosition+strlen(cCurDir)+1;

         do
         {
            iNumSelected++;
            wsprintf( cFileName, "%s", &buffer[iPosition] );
            iPosition = iPosition + strlen( cFileName ) + 1;
            wsprintf( cFullName[iNumSelected], "%s\\%s", cCurDir, cFileName );
         }
         while( ( strlen( cFileName ) != 0 ) && ( iNumSelected <= 63 ) );

         if ( iNumSelected > 1 )
         {
            hb_reta( iNumSelected - 1 );

            for ( n = 1; n < iNumSelected; n++ )
            {
               HB_STORC( cFullName[n], -1, n );
            }
         }
         else
         {
            hb_retc( &buffer[0] );
         }
      }
   }
   else
   {
      hb_retc( "" );
   }
}

#pragma ENDDUMP

/* eof */
