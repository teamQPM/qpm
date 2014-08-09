/*
 * $Id$
 */

/*
 *    QPM - QAC Based Project Manager
 *
 *    Copyright 2011-2014 Fernando Yurisich <fernando.yurisich@gmail.com>
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
#include "hbclass.ch"
#include "minigui.ch"
#include "US_i_richeditbox.ch"
#include "i_pseudofunc.ch"

//==================================================================================
//= CLASE US_RichEdit                                                              
//----------------------------------------------------------------------------------

CLASS US_RichEdit

   METHOD New()                                   && Crear el Objeto
   METHOD Destroy()                               && Destruir el Objeto
   METHOD Init( memo )                            && Inicializa el objeto con un string
   METHOD Activate()                              && Activa el editor
   METHOD SetTitle( str )                         && Inicializa el titulo del editor
   METHOD SetBackColor( vec )                     && Color de Fondo de la ventana
   METHOD SetEditBackColor( vec )                 && Color de Fondo del Edit
   METHOD SetTitleFontColor( vec )                && Color de Fonts del titulo de la ventana
   METHOD SetTitleBackColor( vec )                && Color de Fondo del titulo de la ventana
   METHOD SetPos( nPos )                          && Establece la posicion del cursor dentro del texto
   METHOD FindText( txt )                         && Establece el texto a buscar cuando se inicie el editor
   METHOD GetSelText()                            && Retorna el area seleccionada
   // Ini for Copy-Paste
   METHOD US_EditRtfCopy()                        && Copy
   METHOD US_EditRtfCut()                         && Cut
   METHOD US_EditRtfPaste()                       && Paste
   METHOD US_EditRtfDelete()                      && Delete
   METHOD US_EditRtfUndo()                        && Undo
   METHOD US_EditRtfRedo()                        && Redo
   METHOD US_EditRtfNormalize()           HIDDEN  && Convierte texto seleccionado en formato Arial 10
   METHOD US_EditSetButtonsCP()           HIDDEN  && Establece el valor de los botones de Copy-Paste
   // Fin for Copy-Paste
   METHOD Lan( Guia )                     HIDDEN  && Lenguaje
   //
   METHOD US_EditInicial()                HIDDEN  && Accion inicial
   METHOD US_EditSeteoTeclas()            HIDDEN
   METHOD US_EditLiberoTeclas()           HIDDEN
   METHOD US_EditEscape()                 HIDDEN
   METHOD US_EditViewClipBoard()
   METHOD US_EditLoad()                   HIDDEN
   METHOD US_EditExport()                 HIDDEN
   METHOD US_EditMaximize()               HIDDEN
   METHOD US_EditReadFonts()              HIDDEN  && Lee los fuentes instalados en el sistema operativo
   METHOD US_EditRefreshButtons()                 && Metodo que se ejecuta al mover el cursor y sirve para actualizar el estado de los botones
   METHOD US_EditSetButtonsFonts( vFont ) HIDDEN  && Establece el valor de los botones de fuente (Bold, Italic, etc.)
   METHOD US_EditSetTextFonts()           HIDDEN  && Cambia el formato del texto seleccionado (Bold, Italic, etc.)
   METHOD US_EditSetButtonsAlign()        HIDDEN  && Establece el valor de los botones de alineacion (left, center, right)
   METHOD US_EditSetTextAlign()           HIDDEN  && Cambia el formato del texto seleccionado (Center, Left, etc.)
   METHOD US_EditSetFontName()            HIDDEN  && Cambia el tipo de letra
   METHOD US_EditSetFontSize()            HIDDEN  && Cambia el tamaño de letra
   METHOD US_EditSetFontColor()           HIDDEN  && Cambia el color de letra
   METHOD US_EditSetVinetas()             HIDDEN  && Establece o saca Viñetas
   METHOD US_EditSetTab( met )            HIDDEN  && Establece o saca tabulacion
   METHOD US_EditFilCol()                 HIDDEN  && Setea el display de posicion del cursor
   METHOD US_EditRedraw()                 HIDDEN  && Redibuja la pantalla
   METHOD US_EditSuspendTimer()           HIDDEN  && Suspende el Timer de refresh
   METHOD US_EditActiveTimer()            HIDDEN  && Activa el Timer de refresh
   // Ini Find
   METHOD US_EditFind()                   HIDDEN  && Funcion para buscar y reemplazar
   METHOD US_EditFindNext()               HIDDEN  &&
   METHOD US_EditFindButtonsChange()      HIDDEN  &&
   METHOD US_EditFindInit()               HIDDEN  &&
   METHOD US_EditFindRelease()            HIDDEN  &&
   // Fin Find
   // Ini Zoom NO IMPLEMENTADO !!!!
   METHOD US_EditZoom()                   HIDDEN  && Funcion para hacer Zoom del texto
   METHOD US_EditZoomReSizeRTF()          HIDDEN  &&
   METHOD US_EditZoomSetPageWidth(nWidth) HIDDEN  &&
   METHOD US_EditZoomGetCtrlSize()        HIDDEN  &&
   // Fin Zoom
// METHOD US_EditSeteoSpace()             HIDDEN
// METHOD US_EditLiberoSpace()            HIDDEN
   METHOD US_EditCargoTextos()            HIDDEN
   METHOD US_IsFocused
   METHOD US_WasChanged

// DATA cSkin              HIDDEN              init ""                             && Aspecto visual, valid: "VP" o ""
   DATA US_WinEdit                             init US_WindowNameRandom("US_Edit") && Nombre de la window
 //DATA cRichControlName   HIDDEN              init US_WindowNameRandom("RichControl") && Nombre del control RichEdit
   DATA US_Edit_oTB        HIDDEN              init NIL                            && Para posible USER title bar
   DATA US_Edit_oSB        HIDDEN              init NIL                            && Para posible USER status bar
   DATA cMemoIni           HIDDEN              init NIL                            &&
   DATA cNewMemo           HIDDEN              init ""
   DATA bUS_EditMaximized  HIDDEN              init .F.
   DATA nOldWinWidth       HIDDEN              init 0
   DATA nOldWinHeight      HIDDEN              init 0
   DATA hEd                HIDDEN              init 0                              && Handle del richeditbox
   DATA nButtonWidth       HIDDEN              init 0                              && Tamaño de los botones chicos
   DATA nButtonHeight      HIDDEN              init 0                              && Tamaño de los botones chicos
   DATA nEspacio           HIDDEN              init 0                              && espacio entre los botones chicos
   DATA vZoom              HIDDEN              init {'500%','200%','150%','100%','75%','50%','25%','10%'}    && Vector para Zoom
   DATA vNumZoom           HIDDEN              init {{5,1},{2,1},{3,2},{0,0},{2,3},{1,2},{1,4},{1,10}}
   DATA vFonts             HIDDEN              init {}                             && Vector para Fuentes
   DATA vFontSizes         HIDDEN              init {'8','9','10','11','12','14','16','18','20','22','24','26','28','36','48','72'}    && Vector para tamaño de fuentes
   DATA cInitialFind       HIDDEN              init ""                             && Texto para busqueda inicial
   // Ini Find
   DATA US_WinFindEdit     HIDDEN              init US_WindowNameRandom("US_FindEdit") && Nombre de la window
   DATA lFind              HIDDEN              init .F.
   // Fin Find
   // Ini para Zoom NO IMPLEMENTADO
   DATA nEditWidth         HIDDEN              init 165            && in mm   // 720 points
   DATA nDevCaps           HIDDEN              init 1              && Ratio: pixel / cm
   DATA nRatio             HIDDEN              init 1              && Ratio: pixel / cm
   DATA rEdit              HIDDEN              init 8
   DATA wEdit              HIDDEN              init 737
   DATA hEdit              HIDDEN              init 350
   DATA lmPage             HIDDEN              init 10                       //left margin
   DATA rmPage             HIDDEN              init 20                       //right margin
   DATA tmPage             HIDDEN              init 10                       //top margin
   DATA bmPage             HIDDEN              init 20                       //bottom margin
   DATA bWin               HIDDEN              init .T.             // Hago manejo de ventana ?
   // Fin para Zoom
   DATA vText              HIDDEN              init {}             // Tabla e Textos
   // Para subsanar un problema con el Timer y OOHG
// DATA bFlagEnableTimer   HIDDEN              init .T.
   DATA l_EditSetFont      HIDDEN              init .F.
   DATA lChanged                               init .F.

   /*- Propiedades ----------------------------------------------------*/

   DATA cLanguage          EXPORTED            init "ES"           && Lenguaje: ES (Espanol) EN (English)
   DATA cSkin              EXPORTED            init ""             && Aspecto visual, valid: "VP" o ""
   DATA bEdit              EXPORTED            init .T.            && Activa en modo edit
   DATA bRTF               EXPORTED            init .T.            && Activa Texto enriquecido (con .F. edita en PLAIN TEXT)
   DATA nPorcentajeAncho   EXPORTED            init 70             && Pocentaje de Ancho
   DATA nPorcentajeAlto    EXPORTED            init 70             && Pocentaje de Alto
   DATA vBackColor         EXPORTED            init {192,192,192}  && Color de Fondo de Ventana
   DATA vTitleBackColor    EXPORTED            init {  0,  0,255}  && Color de Fondo de Titulo de la Ventana
   DATA vTitleFontColor    EXPORTED            init {255,255,255}  && Color de Fonts de Titulo de la Ventana
   DATA vEditBackColor     EXPORTED            init {255,255,255}  && Color de Fondo de Edit
   DATA vEditFontColor     EXPORTED            init {  0,  0,  0}  && Color de Fonts de Edit
   DATA cDefaultFont       EXPORTED            init "Arial"        && Fuentes por defecto
   DATA cDefaultFontSize   EXPORTED            init 10             && Tamaño de Fuentes por defecto
   DATA bButtonFind        EXPORTED            init .T.            && Boton para busqueda
   // Ini Solo para Plain Text
   DATA bBold              EXPORTED            init .F.            && Tipo de letra bold solo para PLAIN TEXT
   // Fin Solo para Plain Text
   DATA cWindowName        EXPORTED            init ""             && Si se proporciona Nombre de Window ya debe existir
   DATA cRichControlName   EXPORTED            init US_WindowNameRandom("RichControl") && Nombre del control RichEdit
   DATA cFunctionPostPaste EXPORTED            init NIL
   /*- Fin Propiedades ------------------------------------------------*/

ENDCLASS

METHOD US_WasChanged() CLASS US_RichEdit
return ::lChanged

METHOD US_IsFocused() CLASS US_RichEdit
return ( ::hEd == GetFocus() )

METHOD New() CLASS US_RichEdit
return Self

METHOD Destroy() CLASS US_RichEdit
return NIL

METHOD SetPos( nPos ) CLASS US_RichEdit
   SetProperty( ::US_WinEdit , ::cRichControlName , "caretpos" , nPos )
return NIL

METHOD FindText( txt ) CLASS US_RichEdit
   ::cInitialFind := txt
return NIL

METHOD GetSelText() CLASS US_RichEdit
return GetSelText( ::hEd )

METHOD SetTitle( str ) CLASS US_RichEdit
   do case
      case ::cSkin = "VP"
         ::US_Edit_oTB:SetTitle( str )
      otherwise
         SetProperty( ::US_WinEdit , "caption" , str )
   endcase
return NIL

METHOD SetTitleBackColor( vColor ) CLASS US_RichEdit
   do case
      case ::cSkin = "VP"
         ::US_Edit_oTB:SetBackColor( vColor )
      otherwise
   endcase
   SetProperty( ::US_WinEdit , "LFilCol" , "fontcolor" , vColor )
   ::vTitleBackColor := vColor
return NIL

METHOD SetTitleFontColor( vColor ) CLASS US_RichEdit
   do case
      case ::cSkin = "VP"
         ::US_Edit_oTB:SetFontColor( vColor )
      otherwise
         SetProperty( ::US_WinEdit , "fontcolor" , vColor )
   endcase
   ::vTitleFontColor := vColor
return NIL

METHOD SetEditBackColor( vColor ) CLASS US_RichEdit
   SetProperty( ::US_WinEdit , ::cRichControlName , "backcolor" , vColor )
   ::vEditBackColor := vColor
return NIL

METHOD SetBackColor( vColor ) CLASS US_RichEdit
   SetProperty( ::US_WinEdit , "backcolor" , vColor )
   ::vBackColor := vColor
return NIL

METHOD Init( cMemo ) CLASS US_RichEdit
   if !empty( ::cWindowName )
      ::bWin := .F.
      ::US_WinEdit := ::cWindowName
   endif

   ::US_EditCargoTextos()

   ::cMemoIni := cMemo

   if ::bEdit .and. ::bRTF
      ::US_EditReadFonts()
   endif

   if ::cSkin = "VP"
      ::US_Edit_oTB := VP_TitleBar():New()
      ::US_Edit_oSB := VP_StatusBar():New()
   endif

   if ::bWin

      PRIVATE US_SUBWIN:=.F.,;
              US_WFIL:=0, ;
              US_WCOL:=0, ;
              US_WALTO:=GetDesktopRealHeight(), ;
              US_WANCHO:=GetDesktopRealWidth()

      PRIVATE US_WWinPorciento:=::nPorcentajeAncho , ;
              US_HWinPorciento:=::nPorcentajeAlto

      PRIVATE US_HLienzo:=US_PAlto(US_HWinPorciento), ;
              US_WLienzo:=US_PAncho(US_WWinPorciento)

      ::nOldWinWidth:=US_PCol( US_WWinPorciento )
      ::nOldWinHeight:=US_PFil( US_HWinPorciento )

      DEFINE WINDOW &(::US_WinEdit);
         AT US_PFil( (100-US_HWinPorciento)/2 ) , US_PCol( (100-US_WWinPorciento)/2 ) ;
         WIDTH ::nOldWinWidth ;
         HEIGHT ::nOldWinHeight ;
         USMODAL ;
         NOSYSMENU ;
         NOCAPTION ;
         BACKCOLOR ::vBackColor ;
         ON INIT ::US_EditInicial() ;
         ON SIZE ::US_EditRedraw() ;
         ON RELEASE ::US_EditLiberoTeclas()

         PRIVATE US_SUBWIN:=.F., ;              && En esta instancia es necesaria para que no cancelen las funciones, siempre con valor .F.
                 US_WFIL:=&(::US_WinEdit).Row, ;
                 US_WCOL:=&(::US_WinEdit).Col, ;
                 US_WALTO:=&(::US_WinEdit).Height, ;
                 US_WANCHO:=&(::US_WinEdit).Width

      END WINDOW

   else

      PRIVATE US_SUBWIN:=.F.,;
              US_WFIL:=0, ;
              US_WCOL:=0, ;
              US_WALTO:=GetDesktopRealHeight(), ;
              US_WANCHO:=GetDesktopRealWidth()

      PRIVATE US_WWinPorciento:=::nPorcentajeAncho , ;
              US_HWinPorciento:=::nPorcentajeAlto

      PRIVATE US_HLienzo:=US_PAlto(US_HWinPorciento), ;
              US_WLienzo:=US_PAncho(US_WWinPorciento)

   // PRIVATE US_HLienzo := &(::US_WinEdit).Height , ;
   //         US_WLienzo := &(::US_WinEdit).Width

      PRIVATE US_SUBWIN:=.F., ;              && En esta instancia es necesaria para que no cancelen las funciones, siempre con valor .F.
              US_WFIL:=&(::US_WinEdit).Row, ;
              US_WCOL:=&(::US_WinEdit).Col, ;
              US_WALTO:=US_PAlto( ::nPorcentajeAlto ), ;
              US_WANCHO:=US_PAncho( ::nPorcentajeAncho )

   endif

   if ::cSkin = "VP"
      ::US_Edit_oTB:ActionOnClose    := { || ::US_EditEscape() }
      ::US_Edit_oTB:ActionOnMaximize := { || ::US_EditMaximize() }
    //::US_Edit_oTB:PorcentajeAlto   := 4.0
      ::US_Edit_oTB:Create( ::US_WinEdit )
      ::US_Edit_oTB:SetBackColor( ::vTitleBackColor )
      ::US_Edit_oTB:SetFontColor( ::vTitleFontColor )
   endif

 //DEFINE CONTEXT MENU
 //   ITEM 'Copiar'                ACTION Copy_click()     IMAGE 'copy'  NAME ItC_Copy
 //   ITEM 'Cortar'                ACTION Cut_Click()      IMAGE 'cut'   NAME ItC_Cut
 //   ITEM 'Pegar'                 ACTION Paste_Click()    IMAGE 'paste' NAME ItC_Paste
 //   SEPARATOR
 //   ITEM 'Selecionar Todo'       ACTION SelectAll_Click()
 //   SEPARATOR
 //   ITEM 'Buscar y Reemplazar'   ACTION Search_click(0)  IMAGE 'find2' NAME ItC_Find
 //END MENU

   if ::bRTF

      ::nButtonWidth  := US_Cols( if( GetDesktopWidth() < 1024 , 4.0 , 3.0 ) )
   // ::nButtonWidth  := US_Cols( 2.7 )
      ::nButtonHeight := US_Fils( if( GetDesktopWidth() < 1024 , 1.1 , 1.0 ) )
   // ::nButtonHeight := US_Fils( 1.0 )
      ::nEspacio      := US_Cols( 0.35 )
   // ::nEspacio      := US_Cols( 0.3 )

   // @ US_TFil( if( GetDesktopWidth() < 1024 , 1.4 , 1.3 ) ) , US_LCol( 1.0 ) BUTTONEX CB_Print ;
   //    OF &(::US_WinEdit) ;
   //    PICTURE "US_EditPrint" ;
   //    HEIGHT ::nButtonHeight ;
   //    WIDTH ::nButtonWidth ;
   //    TOOLTIP ::Lan( "Imprimir" ) ;
   //    ACTION printRTF_click( 1 )

   // @ US_TFil( if( GetDesktopWidth() < 1024 , 1.4 , 1.3 ) ) , GetProperty( ::US_WinEdit , "CB_Print" , "col" ) + ( ( ::nButtonWidth + ::nEspacio ) * 1 ) BUTTONEX CB_Preview ;
   //    OF &(::US_WinEdit) ;
   //    PICTURE "US_EditPreview" ;
   //    HEIGHT ::nButtonHeight ;
   //    WIDTH ::nButtonWidth ;
   //    TOOLTIP ::Lan( "Vista Previa" ) ;
   //    ACTION previewRTF_click( 0 )

 //   @ US_TFil( if( GetDesktopWidth() < 1024 , 1.4 , 1.3 ) ) , GetProperty( ::US_WinEdit , "CB_Print" , "col" ) + ( ( ::nButtonWidth + ::nEspacio ) * 2.5 ) BUTTONEX CB_Copy ;
      @ US_TFil( if( GetDesktopWidth() < 1024 , 1.4 , 1.3 ) ) , US_LCol( 1.0 ) + ( ( ::nButtonWidth + ::nEspacio ) * 2.5 ) BUTTONEX CB_Copy ;
         OF &(::US_WinEdit) ;
         PICTURE "US_EditCopy" ;
         HEIGHT ::nButtonHeight ;
         WIDTH ::nButtonWidth ;
         TOOLTIP ::Lan( "Copiar" ) ;
         ACTION ::US_EditRtfCopy()

      @ US_TFil( if( GetDesktopWidth() < 1024 , 1.4 , 1.3 ) ) , GetProperty( ::US_WinEdit , "CB_Copy" , "col" ) + ( ( ::nButtonWidth + ::nEspacio ) * 1 ) BUTTONEX CB_Paste ;
         OF &(::US_WinEdit) ;
         PICTURE "US_EditPaste" ;
         HEIGHT ::nButtonHeight ;
         WIDTH ::nButtonWidth ;
         TOOLTIP ::Lan( "Pegar" ) ;
         ACTION ::US_EditRtfPaste()

      @ US_TFil( if( GetDesktopWidth() < 1024 , 1.4 , 1.3 ) ) , GetProperty( ::US_WinEdit , "CB_Copy" , "col" ) + ( ( ::nButtonWidth + ::nEspacio ) * 2 ) BUTTONEX CB_Cut ;
         OF &(::US_WinEdit) ;
         PICTURE "US_EditCut" ;
         HEIGHT ::nButtonHeight ;
         WIDTH ::nButtonWidth ;
         TOOLTIP ::Lan( "Cortar" ) ;
         ACTION ::US_EditRtfCut()

      @ US_TFil( if( GetDesktopWidth() < 1024 , 1.4 , 1.3 ) ) , GetProperty( ::US_WinEdit , "CB_Cut" , "col" ) + ( ( ::nButtonWidth + ::nEspacio ) * 1.5 ) BUTTONEX CB_Delete ;
         OF &(::US_WinEdit) ;
         PICTURE "US_EditDelete" ;
         HEIGHT ::nButtonHeight ;
         WIDTH ::nButtonWidth ;
         TOOLTIP ::Lan( "Borrar" ) ;
         ACTION ::US_EditRtfDelete()

      @ US_TFil( if( GetDesktopWidth() < 1024 , 1.4 , 1.3 ) ) , GetProperty( ::US_WinEdit , "CB_Delete" , "col" ) + ( ( ::nButtonWidth + ::nEspacio ) * 1.5 ) BUTTONEX CB_Undo ;
         OF &(::US_WinEdit) ;
         PICTURE "US_EditUndo" ;
         HEIGHT ::nButtonHeight ;
         WIDTH ::nButtonWidth ;
         TOOLTIP ::Lan( "Revertir" ) ;
         ACTION ::US_EditRtfUndo()

      @ US_TFil( if( GetDesktopWidth() < 1024 , 1.4 , 1.3 ) ) , GetProperty( ::US_WinEdit , "CB_Undo" , "col" ) + ( ( ::nButtonWidth + ::nEspacio ) * 1 ) BUTTONEX CB_Redo ;
         OF &(::US_WinEdit) ;
         PICTURE "US_EditRedo" ;
         HEIGHT ::nButtonHeight ;
         WIDTH ::nButtonWidth ;
         TOOLTIP ::Lan( "Rehacer" ) ;
         ACTION ::US_EditRtfRedo()

      if !( ::bWin )

         @ US_TFil( if( GetDesktopWidth() < 1024 , 1.4 , 1.3 ) ), GetProperty( ::US_WinEdit , "CB_Redo" , "col" ) + ( ( ::nButtonWidth + ::nEspacio ) * 3 ) BUTTONEX CB_Norm ;
            OF &(::US_WinEdit) ;
            CAPTION ::lan( "Normalice" ) ;
            HEIGHT ::nButtonHeight ;
            WIDTH ( ::nButtonWidth * 3.2 ) ;
            TOOLTIP ::Lan( "NormaliceToolTip" ) ;
            ACTION ::US_EditRtfNormalize()

         @ US_TFil( if( GetDesktopWidth() < 1024 , 1.4 , 1.3 ) ), GetProperty( ::US_WinEdit , "CB_Norm" , "col" ) + ( ( ::nButtonWidth + ::nEspacio ) * 3 ) BUTTONEX CB_Sele ;
            OF &(::US_WinEdit) ;
            CAPTION ::lan( "SeleTodo" ) ;
            HEIGHT ::nButtonHeight ;
            WIDTH ( ::nButtonWidth * 3.2 ) ;
            TOOLTIP ::Lan( "SeleTodoToolTip" ) ;
            ACTION ( DoMethod( ::US_WinEdit , ::cRichControlName, "SetFocus" ) , US_Send_SelectAll( ::cRichControlName , ::US_WinEdit ) ) ;

         @ US_TFil( if( GetDesktopWidth() < 1024 , 1.4 , 1.3 ) ), GetProperty( ::US_WinEdit , "CB_Sele" , "col" ) + ( ( ::nButtonWidth + ::nEspacio ) * 3 ) BUTTONEX BVerPortapapeles ;
            OF &(::US_WinEdit) ;
            CAPTION ::lan( "Portapapeles" ) ;
            HEIGHT ::nButtonHeight ;
            WIDTH ( ::nButtonWidth * 3.2 ) ;
            TOOLTIP ::Lan( "Ver" ) ;
            ACTION ::US_EditViewClipBoard()
      endif

      if ::bButtonFind

         @ US_TFil( if( GetDesktopWidth() < 1024 , 1.4 , 1.3 ) ) , GetProperty( ::US_WinEdit , "CB_Redo" , "col" ) + ( ( ::nButtonWidth + ::nEspacio ) * 1.5 ) BUTTONEX CB_Find ;
            OF &(::US_WinEdit) ;
            PICTURE "US_EditFind" ;
            HEIGHT ::nButtonHeight ;
            WIDTH ::nButtonWidth ;
            TOOLTIP ::Lan( "Reemplazar" ) ;
            ACTION ::US_EditFind()

      endif

      @ US_TFil( 1.5 ) , US_LCol(70) LABEL LFilCol ;
         OF &(::US_WinEdit) ;
         VALUE "" ;
         WIDTH US_Cols(15) ;
         HEIGHT US_Fils(1.0) ;
         FONT "VPArial" SIZE US_WFont( if( GetDesktopWidth() < 1024 , 12 , 9 ) ) BOLD ;
         FONTCOLOR ::vTitleBackColor ;
         RIGHTALIGN ;
         TRANSPARENT

      @ US_TFil( 2.6 ) , US_LCol( 1.0 ) COMBOBOX C_Font ;
         OF &(::US_WinEdit) ;
         ITEMS ::vFonts ;
         VALUE 1 ;
         HEIGHT US_Fils( 10 ) ;
         WIDTH US_Cols( if( GetDesktopWidth() < 1024 , 16 , 20 ) ) ;
         TOOLTIP ::Lan( "Fuentes" ) ;
         ON CHANGE ::US_EditSetFontName()
*         ON GOTFOCUS ::US_EditSuspendTimer() ;
*         ON LOSTFOCUS ::US_EditActiveTimer() ;

     //  WIDTH US_Cols( 5 ) ;
      @ US_TFil( 2.6 ) , GetProperty( ::US_WinEdit , "C_Font" , "col" ) + GetProperty( ::US_WinEdit , "C_Font" , "width" ) + ::nEspacio  COMBOBOX C_Size ;
         OF &(::US_WinEdit) ;
         ITEMS ::vFontSizes ;
         VALUE ascan( ::vFontSizes , "10" ) ;
         HEIGHT US_Fils( 5 ) ;
         WIDTH US_Cols( if( GetDesktopWidth() < 1024 , 08 , 06 ) ) ;
         TOOLTIP ::Lan( "TamañodeFuentes" ) ;
         ON CHANGE ::US_EditSetFontSize()
*         ON GOTFOCUS ::US_EditSuspendTimer() ;
*         ON LOSTFOCUS ::US_EditActiveTimer() ;

      @ US_TFIL( 2.6 ) , GetProperty( ::US_WinEdit , "C_Size" , "col" ) + GetProperty( ::US_WinEdit , "C_Size" , "width" ) + ( ::nEspacio * 2.0 ) CHECKBUTTON CB_Bold ;
         OF &(::US_WinEdit) ;
         PICTURE "US_EditBold" ;
         HEIGHT ::nButtonHeight ;
         WIDTH ::nButtonWidth ;
         TOOLTIP ::Lan( "Negrita" ) ;
         ON CHANGE ::US_EditSetTextFonts( "CB_Bold" )

      @ US_TFIL( 2.6 ) , GetProperty( ::US_WinEdit , "CB_Bold" , "col" ) + ( ( ::nButtonWidth + ::nEspacio ) * 1 ) CHECKBUTTON CB_Italic ;
         OF &(::US_WinEdit) ;
         PICTURE "US_EditItalic" ;
         HEIGHT ::nButtonHeight ;
         WIDTH ::nButtonWidth ;
         TOOLTIP ::Lan( "Italica" ) ;
         ON CHANGE ::US_EditSetTextFonts( "CB_Italic" )

      @ US_TFIL( 2.6 ) , GetProperty( ::US_WinEdit , "CB_Bold" , "col" ) + ( ( ::nButtonWidth + ::nEspacio ) * 2 ) CHECKBUTTON CB_UnderLine ;
         OF &(::US_WinEdit) ;
         PICTURE "US_EditUnderLine" ;
         HEIGHT ::nButtonHeight ;
         WIDTH ::nButtonWidth ;
         TOOLTIP ::Lan( "Subrayado" ) ;
         ON CHANGE ::US_EditSetTextFonts( "CB_UnderLine" )

      @ US_TFIL( 2.6 ) , GetProperty( ::US_WinEdit , "CB_Bold" , "col" ) + ( ( ::nButtonWidth + ::nEspacio ) * 3 ) CHECKBUTTON CB_StrikeOut ;
         OF &(::US_WinEdit) ;
         PICTURE "US_EditStrikeOut" ;
         HEIGHT ::nButtonHeight ;
         WIDTH ::nButtonWidth ;
         TOOLTIP ::Lan( "Tachado" ) ;
         ON CHANGE ::US_EditSetTextFonts( "CB_StrikeOut" )

      @ US_TFIL( 2.6 ) , GetProperty( ::US_WinEdit , "CB_StrikeOut" , "col" ) + ( ( ::nButtonWidth + ::nEspacio ) * 1.5 ) CHECKBUTTON CB_Left ;
         OF &(::US_WinEdit) ;
         PICTURE "US_EditLeft" ;
         HEIGHT ::nButtonHeight ;
         WIDTH ::nButtonWidth ;
         TOOLTIP ::Lan( "Izquierda" ) ;
         ON CHANGE ::US_EditSetTextAlign( "CB_Left" )

      @ US_TFIL( 2.6 ) , GetProperty( ::US_WinEdit , "CB_Left" , "col" ) + ( ( ::nButtonWidth + ::nEspacio ) * 1 ) CHECKBUTTON CB_Center ;
         OF &(::US_WinEdit) ;
         PICTURE "US_EditCenter" ;
         HEIGHT ::nButtonHeight ;
         WIDTH ::nButtonWidth ;
         TOOLTIP ::Lan( "Centrado" ) ;
         ON CHANGE ::US_EditSetTextAlign( "CB_Center" )

      @ US_TFIL( 2.6 ) , GetProperty( ::US_WinEdit , "CB_Left" , "col" ) + ( ( ::nButtonWidth + ::nEspacio ) * 2 ) CHECKBUTTON CB_Right ;
         OF &(::US_WinEdit) ;
         PICTURE "US_EditRight" ;
         HEIGHT ::nButtonHeight ;
         WIDTH ::nButtonWidth ;
         TOOLTIP ::Lan( "Derecha" ) ;
         ON CHANGE ::US_EditSetTextAlign( "CB_Right" )

      @ US_TFIL( 2.6 ) , GetProperty( ::US_WinEdit , "CB_Right" , "col" ) + ( ( ::nButtonWidth + ::nEspacio ) * 1.5 ) BUTTONEX CB_Color ;
         OF &(::US_WinEdit) ;
         PICTURE "US_EditColor" ;
         HEIGHT ::nButtonHeight ;
         WIDTH ::nButtonWidth ;
         TOOLTIP ::Lan( "Colores" ) ;
         ACTION ::US_EditSetFontColor()

      @ US_TFIL( 2.6 ) , GetProperty( ::US_WinEdit , "CB_Color" , "col" ) + ( ( ::nButtonWidth + ::nEspacio ) * 1.5 ) CHECKBUTTON CB_Vinetas ;
         OF &(::US_WinEdit) ;
         PICTURE "US_EditVinetas" ;
         HEIGHT ::nButtonHeight ;
         WIDTH ::nButtonWidth ;
         TOOLTIP ::Lan( "Viñetas" ) ;
         ON CHANGE ::US_EditSetVinetas()

      @ US_TFIL( 3.8 ) , 1 RICHEDITBOX &(::cRichControlName + "ClipBoard" ) ;
         OF &(::US_WinEdit) ;
         WIDTH 1 ;
         HEIGHT 1 ;
         VALUE "" ;
         INVISIBLE

      @ US_TFil( 3.9 ) , US_LCol( 1 ) US_RICHEDITBOX &(::cRichControlName) ;
         OF &(::US_WinEdit) ;
         WIDTH US_Cols( 77.6 ) ;
         HEIGHT US_Fils( 17.5 ) ;
         VALUE ::cMemoIni ;
         NOHSCROLL ;
         FONT ::cDefaultFont ;
         FONTCOLOR ::vEditFontColor ;
         SIZE ::cDefaultFontSize ;
         BACKCOLOR ::vEditBackColor ;
         ON CHANGE ::lChanged := .T. ;
         ON SELECT ::US_EditRefreshButtons()

      // El siguiente Timer simula la accion de ON SELECT que en la version Extended de MiniGUI esta
      // codificado en h_windows.prg en un parrafo similar a este:
      //    If GetNotifyCode ( lParam ) = EN_SELCHANGE  //For change text
      //       if valtype(_HMG_aControlDblClick [i]  )=='B'
      //          _HMG_ThisType := 'C'
      //          _HMG_ThisIndex := i
      //          Eval( _HMG_aControlDblClick [i]  )
      //          _HMG_ThisIndex := 0
      //          _HMG_ThisType := ''
      //       EndIf
      //    EndIf

/*
      DEFINE TIMER TTexto ;
         OF &( ::US_WinEdit ) ;
         INTERVAL  500 ;     && 1000 ciclos=1 segundo
         ACTION ::US_EditRefreshButtons()
*/
   else

      @ US_TFIL( 1.2 ) , 1 EDITBOX &(::cRichControlName + "ClipBoard" ) ;
         OF &(::US_WinEdit) ;
         WIDTH 1 ;
         HEIGHT 1 ;
         VALUE "" ;
         INVISIBLE

      @ US_TFil( if( GetDesktopWidth() < 1024 , 1.4 , 1.3 ) ) , US_LCol( 1 ) EDITBOX &(::cRichControlName) ;
         OF &(::US_WinEdit) ;
         WIDTH US_Cols( 70 ) ;
         HEIGHT US_Fils( 18.2 ) ;
         VALUE ::cMemoIni ;
         FONT ::cDefaultFont ;
         FONTCOLOR ::vEditFontColor ;
         SIZE ::cDefaultFontSize ;
         NOHSCROLL ;
         BACKCOLOR ::vEditBackColor

      SetProperty( ::US_WinEdit , ::cRichControlName , "fontbold" , ::bBold )

   endif

   if !(::bRTF)

      @ US_TFil(5.3),US_LCol(71.8) BUTTONEX BLoad ;
         OF &(::US_WinEdit) ;
         CAPTION "Cargar" ;
         WIDTH US_Cols(7) ;
         HEIGHT US_Fils(3) ;
         ACTION ::US_EditLoad() ;
         TOOLTIP ::Lan( "Cargar desde un archivo" ) ;
         FONT "VPArial" SIZE US_WFont(9)

      @ US_TFil(10.3),US_LCol(71.8) BUTTONEX BExport ;
         OF &(::US_WinEdit) ;
         CAPTION "Exportar" ;
         WIDTH US_Cols(7) ;
         HEIGHT US_Fils(3) ;
         ACTION ::US_EditExport() ;
         TOOLTIP ::Lan( "Copiar el contenido en un archivo" ) ;
         FONT "VPArial" SIZE US_WFont(9)

      @ US_TFil(20.0),US_LCol(01) BUTTONEX BCortar ;
         OF &(::US_WinEdit) ;
         CAPTION "Cortar (Ctrl+X)" ;
         WIDTH US_Cols(14) ;
         HEIGHT US_Fils(1.5) ;
         ACTION ( DoMethod( ::US_WinEdit , ::cRichControlName, "SetFocus" ) , US_Send_Cut() ) ;
         TOOLTIP ::Lan( "Cortar el texto seleccionado" ) ;
         FONT "VPArial" SIZE US_WFont(9)

      @ US_TFil(20.0),US_LCol(16) BUTTONEX BCopiar ;
         OF &(::US_WinEdit) ;
         CAPTION "Copiar (Ctrl+C)" ;
         WIDTH US_Cols(14) ;
         HEIGHT US_Fils(1.5) ;
         ACTION ( DoMethod( ::US_WinEdit , ::cRichControlName, "SetFocus" ) , US_Send_Copy() ) ;
         TOOLTIP ::Lan( "Copiar el texto seleccionado" ) ;
         FONT "VPArial" SIZE US_WFont(9)

      @ US_TFil(20.0),US_LCol(31) BUTTONEX BPegar ;
         OF &(::US_WinEdit) ;
         CAPTION "Pegar (Ctrl+P)" ;
         WIDTH US_Cols(14) ;
         HEIGHT US_Fils(1.5) ;
         ACTION ( DoMethod( ::US_WinEdit , ::cRichControlName, "SetFocus" ) , US_Send_Paste() ) ;
         TOOLTIP ::Lan( "Pegar texto desde el portapapeles" ) ;
         FONT "VPArial" SIZE US_WFont(9)

      @ US_TFil(20.0),US_LCol(49.8) BUTTONEX BBorrar ;
         OF &(::US_WinEdit) ;
         CAPTION "Borrar (Del)" ;
         WIDTH US_Cols(14) ;
         HEIGHT US_Fils(1.5) ;
         ACTION ( DoMethod( ::US_WinEdit , ::cRichControlName, "SetFocus" ) , _PushKey( VK_DELETE ) ) ;
         TOOLTIP ::Lan( "Borrar el texto seleccionado" ) ;
         FONT "VPArial" SIZE US_WFont(9)

      @ US_TFil(20.0),US_LCol(64.8) BUTTONEX BRevertir ;
         OF &(::US_WinEdit) ;
         CAPTION "Revertir (Ctrl+Z)" ;
         WIDTH US_Cols(14) ;
         HEIGHT US_Fils(1.5) ;
         ACTION ( DoMethod( ::US_WinEdit , ::cRichControlName, "SetFocus" ) , US_Send_Undo() ) ;
         TOOLTIP ::Lan( "Deshacer la ultima modificación" ) ;
         FONT "VPArial" SIZE US_WFont(9)

   endif

   if ::bWin

      @ US_TFil(22.0),US_LCol(34.8) BUTTONEX BNormalizar ;
         OF &(::US_WinEdit) ;
         CAPTION "Normalizar Texto" ;
         WIDTH US_Cols(14) ;
         HEIGHT US_Fils(1.5) ;
         ACTION ::US_EditRtfNormalize() ;
         TOOLTIP ::Lan( "NormaliceToolTip" ) ;
         FONT "VPArial" SIZE US_WFont(9)

         ** ACTION ( DoMethod( ::US_WinEdit , ::cRichControlName, "SetFocus" ) , US_Send_SelectAll() ) ;
      @ US_TFil(22.0),US_LCol(49.8) BUTTONEX BSeleccionarTodo ;
         OF &(::US_WinEdit) ;
         CAPTION "SeleTodo" ;
         WIDTH US_Cols(14) ;
         HEIGHT US_Fils(1.5) ;
         ACTION ( DoMethod( ::US_WinEdit , ::cRichControlName, "SetFocus" ) , US_Send_SelectAll( ::cRichControlName , ::US_WinEdit ) ) ;
         TOOLTIP ::Lan( "SeleTodoToolTip" ) ;
         FONT "VPArial" SIZE US_WFont(9)

      @ US_TFil(22.0),US_LCol(64.8) BUTTONEX BVerPortapapeles ;
         OF &(::US_WinEdit) ;
         CAPTION "Ver Portapapeles" ;
         WIDTH US_Cols(14) ;
         HEIGHT US_Fils(1.5) ;
         ACTION ::US_EditViewClipBoard() ;
         TOOLTIP ::Lan( "Ver" ) ;
         FONT "VPArial" SIZE US_WFont(9)

      if ::bRTF
         SetProperty( ::US_WinEdit , "BSeleccionarTodo" , "action" , "SetSelRange(::hEd, 0, -1)" )
         SetProperty( ::US_WinEdit , "BVerPortapapeles" , "action" , "::US_EditViewClipBoard" )
      endif

      @ US_TFil(22.0),US_LCol(01) BUTTONEX BEsc ;
         OF &(::US_WinEdit) ;
         CAPTION "Salir (Escape)" ;
         WIDTH US_Cols(32.0) ;
         HEIGHT US_Fils(1.5) ;
         ACTION ::US_EditEscape() ;
         TOOLTIP ::Lan( "Salir" ) ;
         FONT "VPArial" SIZE US_WFont(9)

   endif

   if ::cSkin = "VP"
      ::US_Edit_oSB:PorcentajeRow         := 96.0
      ::US_Edit_oSB:PorcentajeAlto        := 3.2
      ::US_Edit_oSB:cActionPrePlayerList  := { || ::US_Edit_oTB:Off() }
      ::US_Edit_oSB:cActionPostPlayerList := { || ::US_Edit_oTB:On() }
      ::US_Edit_oSB:Create( ::US_WinEdit )
      ::US_Edit_oSB:SetTitleFontSize( 9 )
   endif

   ::hEd := GetControlHandle ( ::cRichControlName , ::US_WinEdit )
// us_log( SetTextMode( ::hEd , if(::bRTF,2,1) ) )
// us_log( SetTextMode( ::hEd , 1 ) )
RETURN NIL

METHOD Activate() CLASS US_RichEdit
   if ::cSkin = "VP"
      US_WinStackAdd( @RN_WinStack , ::US_WinEdit )
   endif

   if ::bWin
      ACTIVATE WINDOW &(::US_WinEdit)
   endif

   if ::cSkin = "VP"
      US_WinStackDel( @RN_WinStack , ::US_WinEdit )
   endif
RETURN ::cNewMemo

METHOD US_EditInicial() CLASS US_RichEdit
   SetProperty( ::US_WinEdit , ::cRichControlName , "ReadOnly" , !( ::bEdit ) )
   **::nOldWinWidth:=GetProperty( ::US_WinEdit , "width" )
   **::nOldWinHeight:=GetProperty( ::US_WinEdit , "height" )
   ::US_EditSeteoTeclas()
   DoMethod( ::US_WinEdit , ::cRichControlName , "SetFocus" )
   if ::bRTF
      ::US_EditRefreshButtons()
   endif
   if RN_bWinMaximizedAll
      ::bUS_EditMaximized := ::US_EditMaximize()
   endif
   if !empty( ::cInitialFind )
      FindChr( ::hEd , ::cInitialFind , .T. , .T. , .F. , .T. )
   else
      SetProperty( ::US_WinEdit , ::cRichControlName , "caretpos" , 1 )
      SetProperty( ::US_WinEdit , ::cRichControlName , "caretpos" , 0 )
   endif
Return

METHOD US_EditSuspendTimer() CLASS US_RichEdit
   SetProperty( ::US_WinEdit , "TTexto" , "enabled" , .F. )
//SetProperty( ::US_WinEdit , "CB_Norm" , "caption" , "suspendido" )
// ::bFlagEnableTimer := .F.
Return

METHOD US_EditActiveTimer() CLASS US_RichEdit
   SetProperty( ::US_WinEdit , "TTexto" , "enabled" , .T. )
//SetProperty( ::US_WinEdit , "CB_Norm" , "caption" , "enable" )
// ::bFlagEnableTimer := .T.
Return

METHOD US_EditSeteoTeclas() CLASS US_RichEdit
   // US_EditSeteoSpace()
   if ::cSkin = "VP"
      ::US_Edit_oTB:KeysOn()
   endif
Return

METHOD US_EditLiberoTeclas() CLASS US_RichEdit
   // US_EditLiberoSpace()
   if ::cSkin = "VP"
      ::US_Edit_oTB:KeysOff()
   endif
Return

METHOD US_EditRtfNormalize() CLASS US_RichEdit
   Local cTxt, nCPos , nVinBase := 0 , nVinTope
   Local aRange , nDesde , nHasta , nLen , cPrev , cSel , cPost
   aRange := GetSelRange( ::hEd )
//pepe
   nCPos := GetProperty( ::US_WinEdit , ::cRichControlName , "caretpos" )
   SetProperty( ::US_WinEdit , "C_Font" , "value" , ascan( ::vFonts , "Arial" ) )
   ::US_EditSetFontName()
   SetProperty( ::US_WinEdit , "C_Size" , "value" , ascan( ::vFontSizes , "10" ) )
   ::US_EditSetFontSize()
   cTxt := US_GetRichEditValue( ::US_WinEdit , ::cRichControlName , "RTF" )
   nDesde := US_RTF2MemoPos( cTxt , aRange[ 1 ] ) + 1
   nHasta := US_RTF2MemoPos( cTxt , aRange[ 2 ] ) + 1
   nLen := nHasta - nDesde
   cPrev := substr( cTxt , 1 , nDesde - 1 )
   cSel  := substr( cTxt , nDesde , nLen )
   cPost := substr( cTxt , nHasta )
//us_log(cSel   )
/*
   if at( "\sb100\sa100" , cTxt ) > 0
      cSel  := strtran( cSel  , "\par"+chr(13) , "\par\par " )
      cPrev := strtran( cPrev , "\sb100\sa100" , "" )
      cSel  := strtran( cSel  , "\sb100\sa100" , "" )
      cPost := strtran( cPost , "\sb100\sa100" , "" )
   endif
*/
   cSel := strtran( cSel , "\pard\li360" , "\pard{\pntext\f1\'B7\tab}{\*\pn\pnlvlblt\pnf1\pnindent0{\pntxtb\'B7}}\fi-320\li640" )
   cSel := strtran( cSel , "\trowd\trqc" , "\xxxx" )
   cSel := strtran( cSel , "\pard\intbl" , "\pard" )
   SetProperty( ::US_WinEdit , ::cRichControlName , "value" , cPrev + cSel + cPost )
   SetProperty( ::US_WinEdit , ::cRichControlName , "caretpos" , nCPos )
//us_log(ctxt   )
Return

METHOD US_EditEscape() CLASS US_RichEdit
   Local Rpta
   if ::bEdit
      if US_GetRichEditValue( ::US_WinEdit , ::cRichControlName , if( ::bRTF , "RTF" , "TXT" ) ) != ::cMemoIni .and. ;
         !( ::cMemoIni == "" .and. US_GetRichEditValue( ::US_WinEdit , ::cRichControlName , "TXT" ) == "" ) && Esta linea es para cuando el memo nunca guardo RTF y se da escape sin escribir nada (para que no note diferencias entre vacio RTF y vacio TXT)
         Rpta:=US_Opcion("El texto ha sido modificado, desea guardar los cambios ?","Si No Cancelar",10,"SINDEFAULT","Cuidado !!!",,"W")
         do case
            case Rpta="Si"
            ***::cNewMemo:=GetProperty( ::US_WinEdit , ::cRichControlName , "Value" )
               ::cNewMemo := US_GetRichEditValue( ::US_WinEdit , ::cRichControlName , if( ::bRTF , "RTF" , "TXT" ) )
               DoMethod( ::US_WinEdit , "Release" )
            case Rpta="No"
               ::cNewMemo:=::cMemoIni
               DoMethod( ::US_WinEdit , "Release" )
            otherwise
         endcase
      else
         ::cNewMemo:=::cMemoIni
         DoMethod( ::US_WinEdit , "Release" )
      endif
   else
      ::cNewMemo:=::cMemoIni
      DoMethod( ::US_WinEdit , "Release" )
   endif
Return

METHOD US_EditViewClipBoard() CLASS US_RichEdit
   SetProperty( ::US_WinEdit , ::cRichControlName + "ClipBoard" , "value" , "" )
   DoMethod( ::US_WinEdit , ::cRichControlName + "ClipBoard" , "SetFocus" )
   US_Send_Paste()
   DO EVENTS
   MsgInfo( US_VarToStr( GetProperty( ::US_WinEdit , ::cRichControlName + "ClipBoard" , "value" ) ) , "Portapapeles", NIL, .F. )
   DoMethod( ::US_WinEdit , ::cRichControlName, "SetFocus" )
Return

METHOD US_EditLoad() CLASS US_RichEdit
   Local cFile, bLoad:=.F. , cCurrentDir:=US_CURDISK()+DEF_SLASH+CURDIR()
   cFile:=Getfile( { ;
                   {"All files (*.*)", "*.*"} ;
                   } , ;
                   "Seleccione el Archivo a cargar" , VP_EditLoadLastDir ,.F. )
   if !empty(cFile)
      VP_EditLoadLastDir:=substr(cFile,1,rat(DEF_SLASH,cFile)-1)
      if !empty( GetProperty( ::US_WinEdit , ::cRichControlName , "value" ) )
         Rpta:=US_Opcion("El anotador posee datos, +los Guarda en el Portapapeles (G), los Borra (D) o agrega el texto el nuevo texto al final (A)?","Guardar Borrar Agregar",10,"SINDEFAULT","Cuidado !!!",,"W")
         do case
            case Rpta="Guardar"
               bLoad:=.T.
               SetProperty( ::US_WinEdit , ::cRichControlName + "ClipBoard" , "value" , GetProperty( ::US_WinEdit , ::cRichControlName , "value" ) )
               DoMethod( ::US_WinEdit , ::cRichControlName + "ClipBoard" , "SetFocus" )
               US_Send_SelectAll()
               DO EVENTS
               US_Send_Copy()
               DO EVENTS
               SetProperty( ::US_WinEdit , ::cRichControlName, "value" , "" )
               DoMethod( ::US_WinEdit , ::cRichControlName , "SetFocus" )
            case Rpta="Borrar"
               bLoad:=.T.
               SetProperty( ::US_WinEdit , ::cRichControlName, "value" , "" )
            case Rpta="Agregar"
               bLoad:=.T.
            otherwise
         endcase
      else
         bLoad:=.T.
      endif
      if bLoad
         SetProperty( ::US_WinEdit , ::cRichControlName , "value" , GetProperty( ::US_WinEdit , ::cRichControlName , "value" ) + memoread( cFile ) )
      endif
   endif
   DoMethod( ::US_WinEdit , ::cRichControlName, "SetFocus" )
   SetCurrentFolder( cCurrentDir )
Return

METHOD US_EditExport() CLASS US_RichEdit
   Local cFile, bGrabo:=.F. , cCurrentDir:=US_CURDISK()+DEF_SLASH+CURDIR()
   cFile:=Putfile( { ;
                   {"All files (*.*)", "*.*"} ;
                   } , ;
                   "Elija el nombre del Archivo" , VP_EditExportLastDir ,.F. )
   if !empty(cFile)
      if file(cFile)
         Rpta:=US_Opcion("El archivo ya existe, desea reemplazarlo ?","Si No",10,"SINDEFAULT","Cuidado !!!",,"W")
         do case
            case Rpta="Si"
               bGrabo:=.T.
            otherwise
         endcase
      else
         bGrabo:=.T.
      endif
      if bGrabo
         memowrit( cFile , GetProperty( ::US_WinEdit , ::cRichControlName , "Value" ) )
         MsgInfo("Grabacion Exitosa.", NIL, NIL, .F.)
      endif
      VP_EditExportLastDir:=substr(cFile,1,rat(DEF_SLASH,cFile)-1)
   endif
   DoMethod( ::US_WinEdit , ::cRichControlName, "SetFocus" )
   SetCurrentFolder( cCurrentDir )
Return

METHOD US_EditMaximize() CLASS US_RichEdit
   // me daba error codificar @(::variable)
   Local nOldWinWidth := ::nOldWinWidth , nOldWinHeight := ::nOldWinHeight , bUS_EditMaximized := ::bUS_EditMaximized , Reto:=NIL
   Reto := US_Maximize( @RN_WinStack , ::US_WinEdit , @nOldWinWidth , @nOldWinHeight , @RN_bWinMaximizedAll , @bUS_EditMaximized )
   ::nOldWinWidth      := nOldWinWidth
   ::nOldWinHeight     := nOldWinHeight
   ::bUS_EditMaximized := bUS_EditMaximized
Return Reto

METHOD US_EditReadFonts() CLASS US_RichEdit
   LOCAL cList, nPos
   ::vFonts:={}
   cList = US_GetSystemFonts()
   DO WHILE ( nPos := AT( ',', cList )) != 0
      AADD( ::vFonts, SUBSTR( cList, 1, nPos - 1 ))
      cList := SUBSTR( cList, nPos + 1 )
   ENDDO
   AADD( ::vFonts, cList )
   ASORT(::vFonts)
Return Nil

//METHOD US_EditSeteoSpace() CLASS US_RichEdit
//   ON KEY SPACE          OF &(::US_WinEdit) ACTION ( ::US_EditLiberoSpace() , _PushKey ( VK_SPACE ) , SetProperty( ::US_WinEdit , "BEsc" , "caption" , str( US_Words( GetProperty( ::US_WinEdit , ::cRichControlName , "value" ) ) ) ) , ::US_EditSeteoSpace() )
//Return

//METHOD US_EditLiberoSpace() CLASS US_RichEdit
//   RELEASE KEY SPACE          OF &(::US_WinEdit)
//Return

// pepe
METHOD US_EditRefreshButtons() CLASS US_RichEdit
   Local aFont

// if ::bFlagEnableTimer    // para resolver el problema de que no funciona el enable del timer en oohg
      aFont := GetFontRTF( ::hEd, 1 )
      ::US_EditSetButtonsFonts( aFont )
      ::US_EditSetButtonsCP()
      ::US_EditSetButtonsAlign()
      ::US_EditFilCol()
// endif
Return NIL

METHOD US_EditSetButtonsFonts( vGetFont ) CLASS US_RichEdit
   Local poz

   ::l_EditSetFont := .T.

   if ( poz := ASCAN( ::vFonts, vGetFont[1] ) ) > 0 .and. ;
      GetProperty( ::US_WinEdit , "C_Font" , "value" ) != poz
      SetProperty( ::US_WinEdit , "C_Font" , "value" , poz )
   endif
   if ( poz := ASCAN( ::vFontSizes, alltrim( str( vGetFont[2] ) ) ) ) > 0 .and. ;
      GetProperty( ::US_WinEdit , "C_Size" , "value" ) != poz
      SetProperty( ::US_WinEdit , "C_Size" , "value" , poz )
   endif
   // Los if previos a los set son para prevenir muchos refresh en version 3.x
   if GetProperty( ::US_WinEdit , "CB_Bold"      , "value" ) !=  vGetFont[3]
      SetProperty( ::US_WinEdit , "CB_Bold"      , "value" , vGetFont[3] )
   endif
   if GetProperty( ::US_WinEdit , "CB_Italic"    , "value" ) !=  vGetFont[4]
      SetProperty( ::US_WinEdit , "CB_Italic"    , "value" , vGetFont[4] )
   endif
   if GetProperty( ::US_WinEdit , "CB_Underline" , "value" ) !=  vGetFont[6]
      SetProperty( ::US_WinEdit , "CB_Underline" , "value" , vGetFont[6] )
   endif
   if GetProperty( ::US_WinEdit , "CB_StrikeOut" , "value" ) !=  vGetFont[7]
      SetProperty( ::US_WinEdit , "CB_StrikeOut" , "value" , vGetFont[7] )
   endif

   ::l_EditSetFont := .F.

Return NIL

METHOD US_EditSetTextFonts( boton ) CLASS US_RichEdit
   do case
      case boton = "CB_Bold"
         _SetFontBoldRTF( ::US_WinEdit , ::cRichControlName , GetProperty( ::US_WinEdit , boton , "Value" ) )
      case boton = "CB_Italic"
         _SetFontItalicRTF( ::US_WinEdit , ::cRichControlName , GetProperty( ::US_WinEdit , boton , "Value" ) )
      case boton = "CB_UnderLine"
         _SetFontUnderLineRTF( ::US_WinEdit , ::cRichControlName , GetProperty( ::US_WinEdit , boton , "Value" ) )
      case boton = "CB_StrikeOut"
         _SetFontStrikeOutRTF( ::US_WinEdit , ::cRichControlName , GetProperty( ::US_WinEdit , boton , "Value" ) )
      otherwise
   endcase
   DoMethod( ::US_WinEdit , ::cRichControlName , "setfocus" )
   ::US_EditRefreshButtons()
Return NIL

METHOD US_EditSetButtonsAlign( vGetFont ) CLASS US_RichEdit
   LOCAL vAlign
   vAlign := GetParForm( ::hEd )
   // Los if previos a los set son para prevenir muchos refresh en version 3.x
   if GetProperty( ::US_WinEdit , "CB_Left"      , "value" ) != vAlign[1]
      SetProperty( ::US_WinEdit , "CB_Left"      , "value" , vAlign[1] )
   endif
   if GetProperty( ::US_WinEdit , "CB_Center"    , "value" ) != vAlign[2]
      SetProperty( ::US_WinEdit , "CB_Center"    , "value" , vAlign[2] )
   endif
   if GetProperty( ::US_WinEdit , "CB_Right"     , "value" ) != vAlign[3]
      SetProperty( ::US_WinEdit , "CB_Right"     , "value" , vAlign[3] )
   endif
   if GetProperty( ::US_WinEdit , "CB_Vinetas"   , "value" ) != vAlign[5]
      SetProperty( ::US_WinEdit , "CB_Vinetas"   , "value" , vAlign[5] )
   endif
Return NIL

METHOD US_EditSetTextAlign( boton ) CLASS US_RichEdit
   do case
      case boton = "CB_Left"
         _SetFormatLeftRTF( ::US_WinEdit , ::cRichControlName , GetProperty( ::US_WinEdit , boton , "Value" ) )
      case boton = "CB_Center"
         _SetFormatCenterRTF( ::US_WinEdit , ::cRichControlName , GetProperty( ::US_WinEdit , boton , "Value" ) )
      case boton = "CB_Right"
         _SetFormatRightRTF( ::US_WinEdit , ::cRichControlName , GetProperty( ::US_WinEdit , boton , "Value" ) )
      otherwise
   endcase
   DoMethod( ::US_WinEdit , ::cRichControlName , "setfocus" )
   ::US_EditRefreshButtons()
Return NIL

METHOD US_EditSetFontName() CLASS US_RichEdit
   Local nPos, cName
   
   if ::l_EditSetFont
      Return NIL
   endif
   
   ::l_EditSetFont := .T.
   
   nPos := GetProperty( ::US_WinEdit , "C_Font" , "value" )
   if nPos > 0
      cName := ::vFonts[nPos]
      if !_SetFontNameRTF( ::US_WinEdit , ::cRichControlName , cName)
//         US_Log("No se pudieron cambiar las fuentes")
      endif
   endif

   ::l_EditSetFont := .F.

Return NIL
// INI Metodo Original
//METHOD US_EditSetFontSize() CLASS US_RichEdit
//   Local nPos, nSize
//   nPos := GetProperty( ::US_WinEdit , "C_Size" , "value" )
//   if nPos > 0
//      nSize := val( ::vFontSizes[nPos] )
//      if !_SetFontSizeRTF( ::US_WinEdit , ::cRichControlName , nSize )
//         US_Log("No se pudieron cambiar los tamaños de fuentes")
//      endif
//   endif
//Return NIL
// FIN Metodo Original
METHOD US_EditSetFontSize() CLASS US_RichEdit
   Local nPos, cSize , cRTF , aRange , nDesde , nHasta , nLen , cPrev , cSel , cPost
   Local cSizeNext, nCaretPos

   if ::l_EditSetFont
     Return NIL
   endif

   ::l_EditSetFont := .T.

   cSizeNext := ""
   nCaretPos := GetProperty( ::US_WinEdit , ::cRichControlName , "caretpos" )

   aRange := GetSelRange( ::hEd )
   nPos := GetProperty( ::US_WinEdit , "C_Size" , "value" )
   if nPos > 0
      cSize := alltrim( str( ( val( ::vFontSizes[nPos] ) * 2 ) ) )
      cRTF := US_GetRichEditValue( ::US_WinEdit , ::cRichControlName , "RTF" )
      nDesde := US_RTF2MemoPos( cRTF , aRange[ 1 ] ) + 1
      nHasta := US_RTF2MemoPos( cRTF , aRange[ 2 ] ) + 1
      nLen := nHasta - nDesde
      cPrev := substr( cRTF , 1 , nDesde - 1 )
      cSel  := substr( cRTF , nDesde , nLen )
      cPost := substr( cRTF , nHasta )
      // INI busco el font size para el bloque posterior al seleccionado
      nPos := nLen
      do while ( ( nPos := rat( "\fs" , substr( cSel , 1 , nPos ) ) ) > 0 )
         if !( substr( cSel , nPos - 1 , 1 ) == "\" )
            cSizeNext := US_Word( substr( cSel , nPos ) , 1 )
            exit
         endif
      enddo
      if cSizeNext == ""
         nPos := len( cPrev )
         do while ( ( nPos := rat( "\fs" , substr( cPrev , 1 , nPos ) ) ) > 0 )
            if !( substr( cPrev , nPos - 1 , 1 ) == "\" )
               cSizeNext := US_Word( substr( cPrev , nPos ) , 1 )
               exit
            endif
         enddo
      endif
      if !( cSizeNext == "" )
         cSizeNext := '\' + US_Word( strtran( cSizeNext , '\' , ' ' ) , 1 ) + ' '
      endif
      // FIN busco el font para el bloque posterior al seleccionado
      cSel := strtran( cSel , "\fs" , "\xx" )       // Pongo codigo inexistente para que lo ignore
      cSel := strtran( cSel , "\\xx" , "\\fs" )     // Restauro texto (\\ no es tag) con formato de tag
      cSel := "\fs" + cSize + " " + cSel
      SetProperty( ::US_WinEdit , ::cRichControlName , "value" , cPrev + cSel + cSizeNext + cPost )
      DoMethod( ::US_WinEdit , ::cRichControlName , "setfocus" )
      SetProperty( ::US_WinEdit , ::cRichControlName , "caretpos" , nCaretPos )
   endif

   ::l_EditSetFont := .F.
Return NIL
// FIN Modificacion

// INI Metodo Original
//METHOD US_EditSetFontColor() CLASS US_RichEdit
//   Local sel, aFont, tmp
//   Sel := RangeSelRTF(::hEd)
//   aFont := GetFontRTF( ::hEd, 1 )
//   tmp := aFont[5]
//   tmp := { GetRed(tmp) , GetGreen(tmp) , GetBlue(tmp) }
//   tmp := GetColor( tmp )
//   If tmp[1] != NIL .and. tmp[2] != NIL .and. tmp[3] != NIL
//      aFont[5] := RGB( tmp[1] , tmp[2] , tmp[3] )
//   endif
//   SetFontRTF(::hEd, Sel, aFont[1], aFont[2], aFont[3], aFont[4], aFont[5], aFont[6], aFont[7])
//Return NIL
// FIN Metodo Original
METHOD US_EditSetFontColor() CLASS US_RichEdit
   Local sel, aFont, tmp
   //
   Local nPos, cColor , cRTF , aRange , nDesde , nHasta , nLen , cPrev , cSel , cPost
   Local cColorNext := "" , nCaretPos := GetProperty( ::US_WinEdit , ::cRichControlName , "caretpos" )
   aRange := GetSelRange( ::hEd )               // Obtengo el rango original

   SetSelRange( ::hEd , aRange[1] , aRange[1] + 1 )   // Pongo el rango en 1 para que no falle el cambio de color
   Sel := RangeSelRTF(::hEd)
   aFont := GetFontRTF( ::hEd, 1 )
   tmp := aFont[5]
   tmp := { GetRed(tmp) , GetGreen(tmp) , GetBlue(tmp) }
   tmp := GetColor( tmp )
   If tmp[1] != NIL .and. tmp[2] != NIL .and. tmp[3] != NIL
      aFont[5] := RGB( tmp[1] , tmp[2] , tmp[3] )
   endif
   SetFontRTF(::hEd, Sel, aFont[1], aFont[2], aFont[3], aFont[4], aFont[5], aFont[6], aFont[7])
   SetSelRange( ::hEd , aRange[1] , aRange[2] )       // Restauro el rango original para iniciar mi proceso
   
   cRTF := US_GetRichEditValue( ::US_WinEdit , ::cRichControlName , "RTF" )
   nDesde := US_RTF2MemoPos( cRTF , aRange[ 1 ] ) + 1
   nHasta := US_RTF2MemoPos( cRTF , aRange[ 2 ] ) + 1
   nLen := nHasta - nDesde
   cPrev := substr( cRTF , 1 , nDesde - 1 )
   cSel  := substr( cRTF , nDesde , nLen )
   cPost := substr( cRTF , nHasta )
   // INI busco el font color para el bloque posterior al seleccionado
   nPos := nLen
   do while ( ( nPos := rat( "\cf" , substr( cSel , 1 , nPos ) ) ) > 0 )
      if !( substr( cSel , nPos - 1 , 1 ) == "\" )
         cColorNext := US_Word( substr( cSel , nPos ) , 1 )
         exit
      endif
   enddo
   if cColorNext == ""
      nPos := len( cPrev )
      do while ( ( nPos := rat( "\cf" , substr( cPrev , 1 , nPos ) ) ) > 0 )
         if !( substr( cPrev , nPos - 1 , 1 ) == "\" )
            cColorNext := US_Word( substr( cPrev , nPos ) , 1 )
            exit
         endif
      enddo
   endif
   if !( cColorNext == "" )
      cColorNext := '\' + US_Word( strtran( cColorNext , '\' , ' ' ) , 1 ) + ' '
   endif
   // FIN busco el font color para el bloque posterior al seleccionado
   if substr( cSel , 1 , 3 ) == "\cf"
      cSel := strtran( cSel , "\cf" , "\xx" , 2 )       // Pongo codigo inexistente para que lo ignore
   else
      cSel := strtran( cSel , "\cf" , "\xx" )           // Pongo codigo inexistente para que lo ignore
   endif
   cSel := strtran( cSel , "\\xx" , "\\cf" )     // Restauro texto (\\ no es tag) con formato de tag
// cSel := "\fs" + cColor + " " + cSel
   SetProperty( ::US_WinEdit , ::cRichControlName , "value" , cPrev + cSel + cColorNext + cPost )
   DoMethod( ::US_WinEdit , ::cRichControlName , "setfocus" )
   SetProperty( ::US_WinEdit , ::cRichControlName , "caretpos" , nCaretPos )
Return NIL

METHOD US_EditSetVinetas() CLASS US_RichEdit
   Local  aForm, lLeft, lCenter, lRight, nTab, nNumber, StartId, RightId, Offset
   Local nOffs := 0
   if GetProperty( ::US_WinEdit , "CB_Vinetas" , "value" )
      nOffs := 16 * 20
   endif
   aForm := GetParForm( ::hEd )
   lLeft   := aForm[1]
   lCenter := aForm[2]
   lRight  := aForm[3]
   nTab    := aForm[4]
   nNumber := GetProperty( ::US_WinEdit , "CB_Vinetas" , "value" )
   StartId := nOffs
   RightId := aForm[7]
   Offset  := nOffs
   if !SetParForm( ::hEd , lLeft, lCenter, lRight, nTab , nNumber, StartId, RightId, Offset)
     MsgInfo('Set number problem !!!', 'Error', NIL, .F.)
   endif
   DoMethod( ::US_WinEdit , ::cRichControlName , "setfocus" )
Return Nil

METHOD US_EditSetTab(met) CLASS US_RichEdit
   Local  aForm, lLeft, lCenter, lRight, nTab, nNumber, StartId, RightId, Offset
   Local nDim := 1, nOffs:=32 * 20
   if met == 0
      nDim  := -1
   endif
   aForm := GetParForm( ::hEd )
   lLeft   := aForm[1]
   lCenter := aForm[2]
   lRight  := aForm[3]
   nTab    := aForm[4]
   nNumber := aForm[5]
   StartId := aForm[6] + nOffs * nDim
   RightId := aForm[7]
   Offset  := aForm[8]
   if StartId < 0
       StartId := 0
   endif
   if !SetParForm( ::hEd , lLeft, lCenter, lRight, nTab , nNumber, StartId, RightId, Offset)
     MsgInfo('Set Offset Problem !!!', 'Error', NIL, .F.)
   endif
   DoMethod( ::US_WinEdit , ::cRichControlName , "setfocus" )
Return Nil

METHOD US_EditRtfCopy() CLASS US_RichEdit
   DoMethod( ::US_WinEdit , ::cRichControlName , "setfocus" )
   CopyRTF(::hEd)
Return NIL

METHOD US_EditRtfCut() CLASS US_RichEdit
   DoMethod( ::US_WinEdit , ::cRichControlName , "setfocus" )
   CutRTF(::hEd)
Return NIL

METHOD US_EditRtfPaste() CLASS US_RichEdit
*   Local R
   DoMethod( ::US_WinEdit , ::cRichControlName , "setfocus" )
   PasteRTF(::hEd)
*   if ::cFunctionPostPaste != NIL
*      eval( { || ::cFunctionPostPaste } )
*      R := &( ::cFunctionPostPaste )
*   endif
Return NIL

METHOD US_EditRtfDelete() CLASS US_RichEdit
   DoMethod( ::US_WinEdit , ::cRichControlName , "setfocus" )
   ClearRTF(::hEd)
Return NIL

METHOD US_EditRtfUndo() CLASS US_RichEdit
   DoMethod( ::US_WinEdit , ::cRichControlName , "setfocus" )
   UndoRTF(::hEd)
Return NIL

METHOD US_EditRtfRedo() CLASS US_RichEdit
   DoMethod( ::US_WinEdit , ::cRichControlName , "setfocus" )
   RedoRTF(::hEd)
Return NIL

METHOD US_EditSetButtonsCP() CLASS US_RichEdit
   Local lSel := if(RangeSelRTF( ::hEd ) > 0, .t., .f.) , ;
         lUndo := CanUndo(::hEd) , ;
         lRedo := CanRedo(::hEd) , ;
         lPaste:= CanPaste(::hEd)
   // Los if previos a los set son para prevenir muchos refresh en version 3.x
   if GetProperty( ::US_WinEdit , "CB_Undo"    , "Enabled" ) != lUndo
      SetProperty( ::US_WinEdit , "CB_Undo"    , "Enabled" , lUndo )
   endif
   if GetProperty( ::US_WinEdit , "CB_Redo"    , "Enabled" ) != lRedo
      SetProperty( ::US_WinEdit , "CB_Redo"    , "Enabled" , lRedo )
   endif
   if GetProperty( ::US_WinEdit , "CB_Copy"    , "Enabled" ) != lSel
      SetProperty( ::US_WinEdit , "CB_Copy"    , "Enabled" , lSel )
   endif
   if GetProperty( ::US_WinEdit , "CB_Cut"     , "Enabled" ) != lSel
      SetProperty( ::US_WinEdit , "CB_Cut"     , "Enabled" , lSel )
   endif
   if GetProperty( ::US_WinEdit , "CB_Delete"  , "Enabled" ) != lSel
      SetProperty( ::US_WinEdit , "CB_Delete"  , "Enabled" , lSel )
   endif
   if GetProperty( ::US_WinEdit , "CB_Paste"   , "Enabled" ) != lPaste
      SetProperty( ::US_WinEdit , "CB_Paste"   , "Enabled" , lPaste )
   endif
Return NIL

METHOD US_EditFilCol() CLASS US_RichEdit
   LOCAL  Poz := Linepos(::hEd)
   // el if previo al set es para prevenir muchos refresh en version 3.x
   if GetProperty( ::US_WinEdit , "LFilCol" , "value" ) != alltrim(str(poz[1]+1))+"/"+alltrim(str(poz[2]+1))
      SetProperty( ::US_WinEdit , "LFilCol" , "value" , "Row/Col: " + alltrim(str(poz[1]+1))+"/"+alltrim(str(poz[2]+1)) )
   endif
Return Nil

METHOD US_EditZoom() CLASS US_RichEdit
   Local nPos, nRatio
   nPos  := GetProperty( ::US_WinEdit , "C_Zoom" , "value" )
   if nPos > 0
      SetZoom( ::hEd, ::vNumZoom[ nPos,1 ] , ::vNumZoom[ nPos,2 ] )
      if ::vNumZoom[ nPos,1 ] == 0
         nRatio := 1
      else
         nRatio := ::vNumZoom[ nPos,1 ] / ::vNumZoom[ nPos,2 ]
      endif
      _SetControlWidth( ::cRichControlName , ::US_WinEdit , ::nEditWidth * ::nDevCaps * nRatio )
      ::US_EditZoomSetPageWidth(::nEditWidth * ::nDevCaps * nRatio)
      ::US_EditZoomReSizeRTF()
   endif
Return Nil

METHOD US_EditZoomReSizeRTF() CLASS US_RichEdit
   ::US_EditZoomGetCtrlSize()
   _SetControlRow( ::cRichControlName , ::US_WinEdit , ::rEdit)
   _SetControlWidth( ::cRichControlName , ::US_WinEdit , min(::nEditWidth * ::nDevCaps * ::nRatio, ::wEdit))
   _SetControlHeight( ::cRichControlName , ::US_WinEdit , ::hEdit )
   ::US_EditZoomSetPageWidth(::nEditWidth * ::nDevCaps * ::nRatio)
Return Nil

METHOD US_EditZoomSetPageWidth(nWidth) CLASS US_RichEdit
   LOCAL aRc
   aRC = GetRect(::hEd)
   SetRect( ::hEd, ::lmPage+1 , aRc[2]+1 , nWidth-(::lmPage+::rmPage)+1, aRc[4])
Return Nil

METHOD US_EditZoomGetCtrlSize() CLASS US_RichEdit
   Local w, h, hrb:=27, hst:=37 , i
   local hwnd,actpos:={0,0,0,0}
   hwnd := GetFormHandle( ::US_WinEdit )
   GetWindowRect(hwnd,actpos)
   w := actpos[3]-actpos[1]
   h := actpos[4]-actpos[2]
   i := aScan ( _HMG_aFormHandles , hWnd )
   if i > 0
      If _HMG_aFormReBarHandle [i] > 0
         hrb := RebarHeight( _HMG_aFormReBarHandle [i] )
      EndIf
   EndIf
   ::rEdit := hrb + 8
   ::wEdit := w - 13
   ::hEdit := h - hrb - hst - IF(IsXPThemeActive(), 48, 40)
Return NIL

METHOD US_EditFind() CLASS US_RichEdit
   Local wr:=30, ww:=100, cTitle:="Buscar y reemplazar" , ;
         Find_oTB := VP_TitleBar():New()
         Find_oSB := VP_StatusBar():New()

   PRIVATE US_SUBWIN:=.F.,;
           US_WFIL:=0, ;
           US_WCOL:=0, ;
           US_WALTO:=GetDesktopRealHeight(), ;
           US_WANCHO:=GetDesktopRealWidth()

   PRIVATE US_WWinPorciento:=60 , ;
           US_HWinPorciento:=25

   PRIVATE US_HLienzo:=US_PAlto(US_HWinPorciento), ;
           US_WLienzo:=US_PAncho(US_WWinPorciento)

   PRIVATE nOldWinWidth:=US_PCol( US_WWinPorciento )
   PRIVATE nOldWinHeight:=US_PFil( US_HWinPorciento )

   ***TOPMOST ;
   ***NOMINIMIZE;
   ***NOMAXIMIZE;
   // NOSIZE;
   DEFINE WINDOW &(::US_WinFindEdit) ;
      AT US_PFil( 100 - ( US_HWinPorciento + 5 ) ) , US_PCol( (100-US_WWinPorciento)/2 ) ;
      WIDTH nOldWinWidth ;
      HEIGHT nOldWinHeight ;
      USMODAL ;
      NOSYSMENU ;
      NOCAPTION ;
      FONT "VPArial" SIZE US_WFont( 11 ) ;
      BACKCOLOR ::vBackColor ;
      ON SIZE US_Redraw( ::US_WinFindEdit , @nOldWinWidth , @nOldWinHeight ) ;
      ON INIT ::US_EditFindInit()

      PRIVATE US_SUBWIN:=.F., ;              && En esta instancia es necesaria para que no cancelen las funciones, siempre con valor .F.
              US_WFIL:=&(::US_WinFindEdit).Row, ;
              US_WCOL:=&(::US_WinFindEdit).Col, ;
              US_WALTO:=&(::US_WinFindEdit).Height, ;
              US_WANCHO:=&(::US_WinFindEdit).Width

      if ::cSkin = "VP"
         Find_oTB:ActionOnClose    := { || ::US_EditFindRelease() }
         Find_oTB:PorcentajeAlto   := 10.0
         Find_oTB:Create( ::US_WinFindEdit )
         Find_oTB:SetButtomMaximize( .F. )
         Find_oTB:SetBackColor( ::vTitleBackColor )
         Find_oTB:SetFontColor( ::vTitleFontColor )
         Find_oTB:SetTitleFontSize( 10 )
         Find_oTB:SetTitle( cTitle )
      endif

      @  US_TFil( 3.5 ) , US_LCol( 2 ) LABEL lab_1 ;
         VALUE 'Buscar:';
         WIDTH US_Cols( 12 ) ;
         HEIGHT US_Fils( 2 ) ;
         FONTCOLOR ::vTitleBackColor ;
         TRANSPARENT

      @ US_TFil( 3.5 ) , US_LCol( 15 ) TEXTBOX text_1 ;
         WIDTH US_Cols( 45 ) ;
         HEIGHT US_Fils( 2.7 ) ;
         MAXLENGTH  230 ;
         ON CHANGE ::US_EditFindButtonsChange()

      @ US_TFil( 6.5 ) , US_LCol( 2 ) LABEL lab_2 ;
         VALUE 'Reemplazar Con:';
         WIDTH US_Cols( 12 ) ;
         HEIGHT US_Fils( 2 ) ;
         FONTCOLOR ::vTitleBackColor ;
         TRANSPARENT

      @ US_TFil( 6.5 ) , US_LCol( 15 ) TEXTBOX text_2 ;
         WIDTH US_Cols( 45 ) ;
         HEIGHT US_Fils( 2.7 ) ;
         MAXLENGTH  230 ;
         ON CHANGE ::US_EditFindButtonsChange()

      @ US_TFil( 11.5 ) , US_LCol( 2 ) CHECKBOX checkbox_1 ;
         CAPTION 'Hacer Coincidir Mayúsculas y Minúsculas' ;
         WIDTH US_Cols( 35 ) ;
         HEIGHT US_Fils( 2 ) ;
         FONTCOLOR ::vTitleBackColor ;
         VALUE .F. ;
         TRANSPARENT

      @ US_TFil( 14.5 ) , US_LCol( 2 ) CHECKBOX checkbox_2 ;
         CAPTION 'Sólo Palabras Completas' ;
         WIDTH US_Cols( 35 ) ;
         HEIGHT US_Fils( 2 ) ;
         FONTCOLOR ::vTitleBackColor ;
         VALUE .F. ;
         TRANSPARENT

      @ US_TFil( 17.5 ) , US_LCol( 2 ) CHECKBOX checkbox_3 ;
         CAPTION 'Seleccionar el Texto Encontrado' ;
         WIDTH US_Cols( 35 ) ;
         HEIGHT US_Fils( 2 ) ;
         FONTCOLOR ::vTitleBackColor ;
         VALUE .T. ;
         TRANSPARENT

      @ US_TFil( 11.5 ) , US_LCol( 40 ) FRAME Panel_1 ;
         CAPTION 'Dirección' ;
         WIDTH US_Cols( 15 ) ;
         HEIGHT US_Fils( 8.6 ) ;
         FONTCOLOR ::vTitleBackColor ;
         BACKCOLOR ::vBackColor

      @ US_TFil( 13.5 ) , US_LCol( 42 ) RADIOGROUP radiogrp_1 ;
         OPTIONS {'Arriba','Abajo'};
         VALUE 2;
         WIDTH US_Cols( 12 ) ;
         SPACING US_Fils( 2.7 ) ;
         FONTCOLOR ::vTitleBackColor ;
         BACKCOLOR ::vBackColor

      @ US_TFil( 3.5 ) , US_LCol( 62 ) BUTTONEX Btn_Find ;
         CAPTION 'Buscar Siguiente';
         WIDTH US_Cols( 16 ) ;
         HEIGHT US_Fils( 4.0 ) ;
         ACTION ::US_EditFindNext(0)

      @ US_TFil( 8.0 ) , US_LCol( 62 ) BUTTONEX Btn_Repl;
         CAPTION 'Reemplazar';
         WIDTH US_Cols( 16 ) ;
         HEIGHT US_Fils( 4.0 ) ;
         ACTION ::US_EditFindNext(1)

      @ US_TFil( 12.5 ) , US_LCol( 62 ) BUTTONEX Btn_ReplAll;
         CAPTION 'Reemplazar Todo';
         WIDTH US_Cols( 16 ) ;
         HEIGHT US_Fils( 4.0 ) ;
         ACTION ::US_EditFindNext(2)

      @ US_TFil( 17.0 ) , US_LCol( 62 ) BUTTONEX Btn_Cancel;
         CAPTION 'Cancelar';
         WIDTH US_Cols( 16 ) ;
         HEIGHT US_Fils( 4.0 ) ;
         ACTION ::US_EditFindRelease()

      if ::cSkin = "VP"
         Find_oSB:PorcentajeRow         := 88.0
         Find_oSB:PorcentajeAlto        := 10.0
         Find_oSB:cActionPrePlayerList  := { || ( Find_oTB:Off() , Find_oSB:Off() ) }
         Find_oSB:cActionPostPlayerList := { || ( Find_oTB:On() , Find_oSB:On() ) }
         Find_oSB:Create( ::US_WinFindEdit )
         Find_oSB:SetTitleFontSize( 8 )
      endif

   END WINDOW

   if ::cSkin = "VP"
      US_WinStackAdd( @RN_WinStack , ::US_WinFindEdit )
      ::US_Edit_oTB:Off()
      ::US_Edit_oSB:Off()
   endif

   ACTIVATE WINDOW &(::US_WinFindEdit)

   if ::cSkin = "VP"
      US_WinStackDel( @RN_WinStack , ::US_WinFindEdit )
      ::US_Edit_oTB:On()
      ::US_Edit_oSB:On()
   endif

Return

METHOD US_EditFindRelease() CLASS US_RichEdit
   &(::US_WinFindEdit).Release
   ::lFind := .f.
Return Nil

METHOD US_EditFindInit() CLASS US_RichEdit
   Local nSel, cSel
   if (nSel:=RangeSelRTF(::hEd)) > 0
      cSel := space(nSel+1)
      cSel := GetSelText(::hEd , cSel)
      if !empty(cSel)
         &(::US_WinFindEdit).text_1.Value := cSel
      endif
   endif
   &(::US_WinFindEdit).Btn_Find.Enabled    := !empty(&(::US_WinFindEdit).text_1.Value)
   &(::US_WinFindEdit).Btn_Repl.Enabled    := !empty(&(::US_WinFindEdit).text_2.Value)
   &(::US_WinFindEdit).Btn_ReplAll.Enabled := !empty(&(::US_WinFindEdit).text_2.Value)
   ::lFind := .f.
Return Nil

METHOD US_EditFindButtonsChange() CLASS US_RichEdit
   &(::US_WinFindEdit).Btn_Find.Enabled    := !empty(&(::US_WinFindEdit).text_1.Value)
   &(::US_WinFindEdit).Btn_Repl.Enabled    := !empty(&(::US_WinFindEdit).text_2.Value)
   &(::US_WinFindEdit).Btn_ReplAll.Enabled := !empty(&(::US_WinFindEdit).text_2.Value)
   ::lFind := .f.
Return Nil

METHOD US_EditFindNext(repl) CLASS US_RichEdit
   // repl:   0 find , 1 replace , 2 replaceAll
   Local Text , ret, direction, wholeword, mcase, seltxt
   Local ReplTxt := ''

   Text      := &(::US_WinFindEdit).text_1.Value
   mcase     := &(::US_WinFindEdit).checkbox_1.value
   wholeword := &(::US_WinFindEdit).checkbox_2.value
   seltxt    := &(::US_WinFindEdit).checkbox_3.value
   direction := IF( &(::US_WinFindEdit).radiogrp_1.value == 1, .F., .T. )
   if repl != 0
      ReplTxt   := &(::US_WinFindEdit).text_2.Value
   endif
   if !(::lFind)
      ret := FindChr( ::hEd, Text , direction, wholeword, mcase, seltxt )
      ::lFind := if(ret[3] < 0, .f.,.t.)
   endif
   while .t.
      if !(::lFind)
         if ::cSkin == "VP"
            US_Cartel("Texto no encontrado",10)
         else
            MsgInfo("Texto no encontrado.", NIL, NIL, .F.)
         endif
         exit
      else
         if repl != 0
            ReplaceSel( ::hEd , ReplTxt )
            ret := FindChr( ::hEd, Text , direction, wholeword, mcase, seltxt )
            ::lFind := if(ret[3] < 0, .f.,.t.)
            if repl == 1
               exit
            endif
         else
            ::lFind :=.f.
            exit
         endif
      endif
   enddo
Return ret


/*
 * ESTA FUNCION MUESTRA UN CARTEL CON PAUSA
 */
FUNCTION US_CARTEL(ESTRING,FILA)
RETURN US_OPCION(ESTRING,"",IF(FILA=NIL,10,FILA),,,,"N")

METHOD US_EditRedraw() CLASS US_RichEdit
   Local nOldWidth := ::nOldWinWidth , nOldHeight := ::nOldWinHeight
   US_Redraw( ::US_WinEdit , @nOldWidth , @nOldHeight )
   ::nOldWinWidth := nOldWidth
   ::nOldWinHeight:= nOldHeight
Return

METHOD Lan( cGuia ) CLASS US_RichEdit
   Local vLan := { "ES" , "EN" }
   if ( nLan := ascan( vLan , ::cLanguage ) ) == 0
      MsgInfo( "Invalid Language in Translate Language Function of US_Edit: " + ::cLanguage, NIL, NIL, .F. )
      Return cGuia
   endif
   if ( nPos := ascan( ::vText , { |x| alltrim( x[1] ) == alltrim( cGuia ) } ) ) == 0
      MsgInfo( "Invalid Guide in Translate Language Function of US_Edit: " + cGuia, NIL, NIL, .F. )
      return cGuia
   endif
Return ::vText[ nPos ][ nLan + 1 ]

METHOD US_EditCargoTextos() CLASS US_RichEdit
   //                Guia                 ESpanol                                         ENglish
   AADD( ::vText , { "Copiar"           , "Copiar"                                      , "Copy"      } )
   AADD( ::vText , { "Pegar"            , "Pegar"                                       , "Paste"     } )
   AADD( ::vText , { "Cortar"           , "Cortar"                                      , "Cut"       } )
   AADD( ::vText , { "Borrar"           , "Borrar"                                      , "Delete"    } )
   AADD( ::vText , { "Revertir"         , "Deshacer"                                    , "Undo"      } )
   AADD( ::vText , { "Rehacer"          , "Rehacer"                                     , "Redo"      } )
   AADD( ::vText , { "Normalice"        , "Normalizar"                                  , "Normalize" } )
   AADD( ::vText , { "NormaliceToolTip" , "Convierte el texto seleccionado en Arial 10" , "Change Selected Text to Arial 10" } )
   AADD( ::vText , { "Negrita"          , "Negrita"                                     , "Bold"      } )
   AADD( ::vText , { "Italica"          , "Italica"                                     , "Italic"    } )
   AADD( ::vText , { "Subrayado"        , "Subrayado"                                   , "Underline" } )
   AADD( ::vText , { "Tachado"          , "Tachado"                                     , "Strike"    } )
   AADD( ::vText , { "Izquierda"        , "Justificado a Izquierda"                     , "Left" } )
   AADD( ::vText , { "Centrado"         , "Centrado"                                    , "Center" } )
   AADD( ::vText , { "Derecha"          , "Justificado a Derecha"                       , "Rigth" } )
   AADD( ::vText , { "Colores"          , "Colores"                                     , "Colors"    } )
   AADD( ::vText , { "Viñetas"          , "Viñetas"                                     , "Bullets" } )
   AADD( ::vText , { "Fuentes"          , "Fuentes"                                     , "Fonts" } )
   AADD( ::vText , { "TamañodeFuentes"  , "Tamaño de Fuentes"                           , "Font Size" } )
   AADD( ::vText , { "SeleTodo"         , "Selec. Todo"                                 , "Select All" } )
   AADD( ::vText , { "SeleTodoToolTip"  , "Seleccionar Todo el texto"                   , "Select All Text" } )
   AADD( ::vText , { "Reemplazar"       , "Buscar y Reemplazar"                         , "Find and Replace" } )
   AADD( ::vText , { "Ver"              , "Ver el contenido del portapapeles"           , "View Clipboard" } )
   AADD( ::vText , { "Portapapeles"     , "Ver Portapapeles"                            , "View Clipboard" } )
   AADD( ::vText , { "Salir"            , "Salir del Editor"                            , "Quit Editor" } )
Return .T.

//----------------------------------------------------------------------------------
//= END CLASE US_RichEdit                                                          
//==================================================================================

Function PageSetupRTF_Click()
Return .T.

Function PrintRTF_Click()
//   US_Log( "Funcion sin implementar" )
Return .T.

Function PreviewRTF_Click()
//   US_Log( "Funcion sin implementar" )
Return .T.

#pragma BEGINDUMP

#define _WIN32_IE      0x0500
#define HB_OS_WIN_32_USED
#define _WIN32_WINNT   0x0400
#include <shlobj.h>

#include <windows.h>
#include <commctrl.h>
#include <richedit.h>
#include "hbapi.h"
#include "hbvm.h"
#include "hbstack.h"
#include "hbapiitm.h"
#include "winreg.h"
#include "tchar.h"
#include "Winuser.h"
#include <wingdi.h>
#include <setupapi.h>

static LPBYTE cbuffer;
static int ilefontow;
static int aktfont;

#pragma argsused
int CALLBACK effxp(ENUMLOGFONTEX *lpelfe, NEWTEXTMETRICEX *lpntme, int FontType, LPARAM lParam)
{
    if ((LONG)lParam==1)
    {
        ilefontow++;
    }
    else
    {
        strcat(cbuffer,(LPSTR) lpelfe->elfLogFont.lfFaceName);
        if (++aktfont<ilefontow)
            strcat(cbuffer,",");
    }
    return 1;
}

HB_FUNC( US_GETSYSTEMFONTS )
{
        LOGFONT lf;
        HDC hDC = GetDC(NULL);

        lf.lfCharSet=ANSI_CHARSET;
        lf.lfPitchAndFamily=0;
        strcpy(lf.lfFaceName,"\0");
        ilefontow=0;

        EnumFontFamiliesEx(hDC,&lf,(FONTENUMPROC)effxp,1,0);
        cbuffer = GlobalAlloc(GPTR, ilefontow*127);
        aktfont=0;

        EnumFontFamiliesEx(hDC,&lf,(FONTENUMPROC)effxp,0,0);
        DeleteDC(hDC);
        hb_retc(cbuffer);
        GlobalFree(cbuffer);
}

HB_FUNC ( REBARHEIGHT )
{
        LRESULT lResult ;
        lResult =  SendMessage( (HWND) hb_parnl (1),(UINT) RB_GETBARHEIGHT, 0, 0 );
        hb_retnl( (UINT)lResult );
}

HB_FUNC ( GETDEVCAPS ) // GetDevCaps ( hwnd )
{
        INT      ix;
        HDC      hdc;
        HWND     hwnd;

        hwnd = (HWND) hb_parnl(1);

        hdc  = GetDC( hwnd );

        ix   = GetDeviceCaps( hdc, LOGPIXELSX );

        ReleaseDC( hwnd, hdc );

        hb_retni( (UINT) ix );
}

#pragma ENDDUMP

//========================================================================
// Funcion para Activar el anotador personal
//========================================================================
/*
Function RN_Notas(Ventana)
   LOCAL oEdit:=US_RichEdit():New() , cFile := PRESYS+"_NOTAS.TXT"
   RELEASE KEY ALT+A OF &(Ventana)

   oEdit:nPorcentajeAncho := 80
   oEdit:nPorcentajeAlto  := 80
   oEdit:bEdit            := .T.
   oEdit:cSkin            := "VP"
   oEdit:Init( MEMOREAD( cFile ) )
   oEdit:SetTitle( US_Lower("ANOTADOR GENERAL DE COSAS INTERESANTES, ARCHIVO "+PRESYS+"_NOTAS.TXT") )
// oEdit:SetBackColor( ColorPan )
// oEdit:SetTitleBackColor( ColorEdit )
// oEdit:SetTitleFontColor( ColorPan )
// oEdit:SetPos( OFFSET )
   MemoWrit( cFile , oEdit:Activate() )

   ON KEY ALT+A OF &(Ventana) ACTION RN_NOTAS(Ventana)
RETURN
*/

/*
 * Función para Convertir caretpos de RTF a posicion de RTF contando los  controles
 */
Function US_RTF2MemoPos( cMemoRtf , nPosTxt )
   Local cVenti := US_GetCurrentWindow() , cControl := "control"+US_NameRandom()
   Local cAux , cSeco , cClip , nPosTxtPriv := nPosTxt
   Local Reto , hEd
   Local LOC_nPosAux
   Local LOC_nAuxiliar
   if cVenti == ""
      Private PRI_cMemoRtf := cMemoRtf , PRI_nPosTxT := nPosTxt
      Return US_TempMainWindow( procname()+"( PRI_cMemoRtf , PRI_nPosTxt )" )
   endif
   @ 0,0 RICHEDITBOX &cControl ;
      OF &( cVenti ) ;
      WIDTH 0 ;
      HEIGHT 0 ;
      VALUE cMemoRtf ;
      INVISIBLE
   LOC_nAuxiliar := len( US_GetRichEditValue( cVenti , cControl , "TXT" ) )
   cAux := US_GetRichEditValue( cVenti , cControl , "RTF" )
   hEd := GetControlHandle( cControl , cVenti )
   do while at( ( cSeco := "CdQ"+alltrim(str(int(seconds()))) ) , cAux ) > 0
   enddo
   cClip := US_GetRtfClipboard()
   CopyToClipboard( cSeco )
   DoMethod( cVenti , cControl , "setfocus" )
   SetProperty( cVenti , cControl , "caretpos" , nPosTxtPriv + if( nPosTxtPriv < LOC_nAuxiliar , 1 , 0 ) )
   PasteRTF( hEd )
   CopyRtfToClipboard( cClip )
   cAux := US_GetRichEditValue( cVenti , cControl , "RTF" )
   DoMethod( cVenti , cControl , "release" )
Return ( at( cSeco , cAux ) - if( nPosTxtPriv < LOC_nAuxiliar , 2 , 1 ) )    // -1

/*
 * Función para maximizar o restaurar una ventana
 */
Function US_Maximize( Vector , Ventana , nViejoWidth , nViejoHeight , bSystemMaximized , bModuleMaximized )
   Local i:=0
   if bSystemMaximized
      if !bModuleMaximized
         DoMethod( Ventana , "maximize" )
         US_WinStackStatus( @Vector , Ventana , "MAXIMIZADA" )
         US_Redraw( Ventana , @nViejoWidth , @nViejoHeight )
      else
         DoMethod( Ventana , "restore" )
         US_WinStackStatus( @Vector , Ventana , "NORMAL" )
         bSystemMaximized := .F.
      endif
      bModuleMaximized := !bModuleMaximized
   else
      if bModuleMaximized
         DoMethod( Ventana , "restore" )
         US_WinStackStatus( @Vector , Ventana , "NORMAL" )
         bModuleMaximized := .F.
      else
         DoMethod( Ventana , "maximize" )
         US_WinStackStatus( @Vector , Ventana , "MAXIMIZADA" )
         US_Redraw( Ventana , @nViejoWidth , @nViejoHeight )
         bSystemMaximized := .T.
         bModuleMaximized := .T.
      endif
   endif
Return .t.

/*
 * Función para redibujar una ventana
 */
Function US_Redraw      && para que funcione esta llamada mediante US_MGWait se agrego un if en el US_Redraw2 para ignorar su ventana "US_WAIT"
   Parameters cFormName , nOldWidth , nOldHeight
Return Nil
//Return VP_MGWait( "US_Redraw2( cFormName , @nOldWidth , @nOldHeight )" )

Function US_Redraw2( cFormName , nOldWidth , nOldHeight )
   Local nFormName , inx:=0 , i:=0 , foco := GetProperty( cFormName , "focusedcontrol" )
   for i=len(RN_WinStack) to 1 step -1
      if RN_WinStack[i][1] != NIL
         if RN_WinStack[i][1] = cFormName
            Private nWidth :=GetProperty( cFormName , "width" )
            Private nHeight:=GetProperty( cFormName , "height" )
            // US_LOG("Redraw: "+cFormName)
            // Ini exclusivo FGS
            US_WWinPorciento:=( (nWidth * US_WWinPorciento ) / nOldWidth )
            US_HWinPorciento:=( (nHeight * US_HWinPorciento ) / nOldHeight )
            US_WLienzo:=nWidth
            US_HLienzo:=nHeight
            // Fin exclusivo FGS
            nFormName := GetFormHandle( cFormName )
            For inx=1 to len( _HMG_aControlParenthandles )
               if nFormName == _HMG_aControlParenthandles[inx]
                  if !empty( _HMG_aControlnames[inx] )
                     if !empty( GetProperty( cFormName , _HMG_aControlnames[inx] , "fontsize" ) )
                  ****  if nWidth != nOldWidth
                           SetProperty( cFormName , _HMG_aControlnames[inx] , "fontsize" , ( GetProperty( cFormName , _HMG_aControlnames[inx] , "fontsize" )  * nWidth  ) / nOldWidth  )
                  ****  else
                  ****     if nHeight < nOldHeight
                  ****        SetProperty( cFormName , _HMG_aControlnames[inx] , "fontsize" , ( GetProperty( cFormName , _HMG_aControlnames[inx] , "fontsize" )  * nHeight ) / nOldHeight )
                  ****     endif
                  ****  endif
                        //US_LOG("SetFont for: "+US_VarToStr(_HMG_aControlnames[inx]))
                     endif
                     SetProperty( cFormName , _HMG_aControlnames[inx] , "row"      , ( GetProperty( cFormName , _HMG_aControlnames[inx] , "row"      )  * nHeight ) / nOldHeight )
                     SetProperty( cFormName , _HMG_aControlnames[inx] , "col"      , ( GetProperty( cFormName , _HMG_aControlnames[inx] , "col"      )  * nWidth  ) / nOldWidth  )
                     SetProperty( cFormName , _HMG_aControlnames[inx] , "width"    , ( GetProperty( cFormName , _HMG_aControlnames[inx] , "width"    )  * nWidth  ) / nOldWidth  )
                     SetProperty( cFormName , _HMG_aControlnames[inx] , "height"   , ( GetProperty( cFormName , _HMG_aControlnames[inx] , "height"   )  * nHeight ) / nOldHeight )
                     // US_LOG("Post SetSize for: "+US_VarToStr(_HMG_aControlnames[inx]) , .t. )
                  endif
               endif
            next
            nOldWidth :=nWidth
            nOldHeight:=nHeight
         else
            if substr(RN_WinStack[i][1],1,7) != "US_WAIT"    && ignorar la ventana de US_Wait, si no se llama con US_MGWait este if deberia eliminarse y dejar el exit siempre
               exit
            endif
         endif
      endif
   next
   if !empty( foco )   && posiblemente este bloque siempre es .F.
//      us_log( "setfocus" , .F. )
      DoMethod( cFormName , foco , "setfocus" )
   endif
return

/* eof */
