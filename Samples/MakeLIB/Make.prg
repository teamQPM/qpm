#include "minigui.ch"

Function HolaMundo()

   DEFINE WINDOW mundo ;
      AT 0, 0 ;
      WIDTH 550 ;
      HEIGHT 120 ;
      MODAL

      DEFINE LABEL hola1
         ROW 0
         COL 0
         VALUE "Library Module 1: Running from:"
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

   CENTER WINDOW mundo

   ACTIVATE WINDOW mundo

Return .T.
