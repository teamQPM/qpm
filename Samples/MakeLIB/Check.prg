#include "minigui.ch"

Function Main()

   DEFINE WINDOW Principal ;
      AT 0, 0 ;
      WIDTH 600 ;
      HEIGHT 500 ;
      TITLE "QAC (Quiero algo cómodo !!!) Library Demo" ;
      MAIN ;
      ON INIT { || inicial() }

      DEFINE LABEL hola
         ROW 0
         COL 0
         VALUE "Main Application Running from: "
         AUTOSIZE .T.
      END LABEL

      DEFINE LABEL hola2
         ROW 20
         COL 0
         VALUE MiniGuiVersion()
         AUTOSIZE .T.
      END LABEL

      DEFINE LABEL hola3
         ROW 40
         COL 0
         VALUE HB_Compiler()
         AUTOSIZE .T.
      END LABEL

      DEFINE LABEL hola4
         ROW 60
         COL 0
         VALUE Version()
         AUTOSIZE .T.
      END LABEL

   END WINDOW

   CENTER WINDOW Principal

   ACTIVATE WINDOW Principal

Return .T.

Function inicial()
   HolaMundo()
   HolaMundo2()
Return .T.

