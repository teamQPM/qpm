/*
* Agenda de Contatos
* Humberto Fornazier - Agosto/2002
* hfornazier@brfree.com.br
*
* xHarbour Compiler Build 0.73.5 (SimpLex )
* Copyright 1999-2002, http://www.xharbour.org http://www.harbour-project.org/
*
* MINIGUI - Harbour Win32 GUI library - Release 35
* Copyright 2002 Roberto Lopez <roblez@ciudad.com.ar>
* http://www.geocities.com/harbour_minigui/
*
*/
#include "MiniGui.ch"
#Include "Fileio.CH"
#Include "Agenda.CH"
/*
*/
//REQUEST HB_GT_WIN_DEFAULT
DECLARE WINDOW Frm_Principal

Procedure Main()

          Cria_frmPrincipal()
          Frm_Principal.Center()
          Frm_Principal.Activate()

          Return Nil

/*
*/
Function Cria_frmPrincipal()

         DEFINE WINDOW Frm_Principal AT 0,0   ;
                WIDTH  760                    ;
                HEIGHT 530                    ;
                TITLE SISTEMA                 ;
                ICON "AGENDA"                 ;
                MAIN                          ;
                NOMAXIMIZE                    ;
                ON INIT    { || InicializaAmbiente() }

                DEFINE STATUSBAR
                        STATUSITEM "www.geocities.com/harbourminas  - hfornazier@brfree.com.br"
                END STATUSBAR

               @000,005 FRAME Panel_Menu WIDTH 740 HEIGHT 40 OPAQUE

                       @ 008,010 BUTTON Bt_Contatos ;
                                 PICTURE 'AGENDA'   ;
                                 ACTION  Agenda2() ;
                                 WIDTH 40 HEIGHT 27 ;
                                 TOOLTIP 'Cadastro dos Contatos'

                       @ 008,050 BUTTON Bt_Tabelas_Grupos  ;
                                 PICTURE 'TABELAS';
                                 ACTION  CadastroGenerico( "Tipos" ,  "Tipos de Contato") ;
                                 WIDTH 40 HEIGHT 27 ;
                                 TOOLTIP 'Cadastro dos Tipos de Contato'

               @ 008,090 BUTTON Bt_Imprime_Agenda  ;
                                 PICTURE 'PRINT';
                                 ACTION  Relatorio_Contatos() ;
                                 WIDTH 40 HEIGHT 27 ;
                                 TOOLTIP 'Imprime Contatos Cadastrados'

               @ 008,130 BUTTON Bt_Help     ;
                                 PICTURE 'XHELP'     ;
                                 ACTION  Sobre_o_Sistema() ;
                                 WIDTH 40 HEIGHT 27 ;
                                 TOOLTIP 'Sobre o Sistema'

               @385,130 FRAME Panel_Msg WIDTH 520 HEIGHT 40 OPAQUE

               @ 392,175 LABEL Label_Mensagem          ;
                         VALUE "O Clipper não Morreu!!   Conheça o Harbour / xHarbour & o MiniGUI";
                         WIDTH 450                           ;
                         HEIGHT 27                           ;
                         FONT "Arial" SIZE 10                ;
                         FONTCOLOR WHITE BOLD

               @002,604 ANIMATEBOX Ani_Minigui ;
                        WIDTH 300 ;
                        HEIGHT 80 ;
                        FILE 'Minigui' AUTOPLAY


         DEFINE MAIN MENU
                       POPUP "Sistema"
                              ITEM "&Contatos     " ACTION Agenda2()
                              SEPARATOR
                              ITEM "&Tipos de Contato"  ACTION CadastroGenerico("Tipos","Tipos de Contatos")
                              SEPARATOR
                              ITEM "Sair          " ACTION Btn_Sair_Sistema()
                       END POPUP
                       POPUP "Help"
                              ITEM "Sobre         " ACTION Sobre_o_Sistema()
                       END POPUP
                END MENU

         END WINDOW

         Return Nil

/*
*/
Function Btn_Sair_Sistema()
         if MsgYesNo("Deseja Sair do Sistema??",SISTEMA)
            RELEASE WINDOW ALL
         EndIf
         Return NIL
/*
*/
Function Sobre_o_Sistema()
         PlayExclamation()
         MsgINFO (PadC("*** Agenda de Contatos ***",60)+QUEBRA+;
                  PadC(" ",30)+QUEBRA+;
                  PadC(" Humberto_Fornazier  hfornazier@brfree.com.br",60)+QUEBRA+;
                  PadC(" ",30)+QUEBRA+;
                  PadC(" Desenvolvido com " + miniguiversion(),60)+QUEBRA+;
                  PadC(" ",30)+QUEBRA+;
                  PadC(version(),60)+QUEBRA+;
                  PadC(" ",30)+QUEBRA+;
                  PadC(HB_compiler(),60))
         Return NIL

/*                              http://www.xharbour.org http://www.harbour-project.org/
*/
Function InicializaAmbiente()

      // HB_LANGSELECT("PT")
         SET LANGUAGE TO PORTUGUESE
         SET DATE  TO BRITISH
         SET CENT  ON
         SET EPOCH TO 1950
         SET( _SET_DELETED   , TRUE  )

         Return Nil
/*
*/
Function LinhaDeStatus(cMensagem)
         Frm_Principal.StatusBar.Item(1) :=  "   " + cMensagem
         Return Nil

/*
*/
Function NoModulo()
         MsgBox("Modulo será desenvolvido na próxima Versão!!")
         Return Nil

*------------------------------ Arquivos --------------------------------------*
*#Include "Agenda2.PRG"
*#Include "CadGen.PRG"
*#Include "Funcoes.PRG"
