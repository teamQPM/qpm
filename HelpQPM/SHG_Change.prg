#include "minigui.ch"

Function main()

   DEFINE WINDOW Sample ;
     AT 0 , 0 ;
     WIDTH 400 ;
     HEIGHT 200 ;
     TITLE "QAC Sample" ;
     MAIN

      DEFINE LABEL Label1
        ROW 40
        COL 130
        WIDTH 200
        VALUE "Basic QAC Sample"
      END LABEL

      DEFINE BUTTON Button1
        ROW 100
        COL 100
        WIDTH 200
        CAPTION "Change"
        ONCLICK Change()
      END BUTTON

   END WINDOW

   CENTER WINDOW Sample
   ACTIVATE WINDOW Sample

Return .T.

Function Change()
   Local old , new
   old := "D:/TEMP/qpm/helpqpm/"
   new := "D:/TEMP/qpm/helpqpm/"
   USE QPM_SHG.dbf ALIAS "SHG"
   PACK
   DBGoTop()
   DO WHILE !EOF()
      REPLACE SHG_Topic   WITH US_StrTran( SHG_Topic  , old , new ) , ;
              SHG_TopicT  WITH US_StrTran( SHG_TopicT , old , new ) , ;
              SHG_Memo    WITH US_StrTran( SHG_Memo   , old , new ) , ;
              SHG_MemoT   WITH US_StrTran( SHG_MemoT  , old , new ) , ;
              SHG_Keys    WITH US_StrTran( SHG_Keys   , old , new ) , ;
              SHG_KeysT   WITH US_StrTran( SHG_KeysT  , old , new ) , ;
              SHG_Nick    WITH US_StrTran( SHG_Nick   , old , new ) , ;
              SHG_NickT   WITH US_StrTran( SHG_NickT  , old , new )
      DBSkip()
   ENDDO
   USE
Return

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

