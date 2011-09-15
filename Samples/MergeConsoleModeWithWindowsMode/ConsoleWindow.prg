#include "minigui.ch"

REQUEST HB_GT_WIN_DEFAULT

Function Main()
   Local qac := "QAC (Quiero Algo Comodo !!!) Console-Windows Mixed Mode Sample"
   ? qac
   ? " "
   ? "Running from "
   ? " "
   ? MiniGuiVersion()
   ? " "
   ? Version()
   ? " "
   ? " "
   __Run( "Pause" )

   DEFINE WINDOW Principal ;
      AT 0, 0 ;
      WIDTH 600 ;
      HEIGHT 480 ;
      TITLE qac ;
      MAIN ;
      TOPMOST

      DEFINE LABEL hola
         ROW 0
         COL 0
         VALUE "Running from: "
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
         VALUE Version()
         AUTOSIZE .T.
      END LABEL

   END WINDOW

   CENTER WINDOW Principal

   ACTIVATE WINDOW Principal

Return .t.
