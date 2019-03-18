/*
 * $Id$
 */

/*
 *    QPM - QAC based Project Manager
 *
 *    Copyright 2011-2019 Fernando Yurisich <fernando.yurisich@gmail.com>
 *    https://qpm.sourceforge.io/
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

//================================================================================================================//
//= ini bloque Richedit.  Extracted from i_richeditbox.ch of Minigui Extended 1.2 build 24 ===================//
//= Change RichEditBox                by US_RICHEDITBOX                                                                       //
//----------------------------------------------------------------------------------------------------------------//

/*----------------------------------------------------------------------------
 MINIGUI - Harbour Win32 GUI library source code

 Copyright 2002 Roberto Lopez <roblez@ciudad.com.ar>
 http://www.geocities.com/harbour_minigui/

 This program is free software; you can redistribute it and/or modify it under
 the terms of the GNU General Public License as published by the Free Software
 Foundation; either version 2 of the License, or (at your option) any later
 version.

 This program is distributed in the hope that it will be useful, but WITHOUT
 ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

 You should have received a copy of the GNU General Public License along with
 this software; see the file COPYING. If not, write to the Free Software
 Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA (or
 visit the web site http://www.gnu.org/).

 As a special exception, you have permission for additional uses of the text
 contained in this release of Harbour Minigui.

 The exception is that, if you link the Harbour Minigui library with other
 files to produce an executable, this does not by itself cause the resulting
 executable to be covered by the GNU General Public License.
 Your use of that executable is in no way restricted on account of linking the
 Harbour-Minigui library code into it.

 Parts of this project are based upon:

        "Harbour GUI framework for Win32"
        Copyright 2001 Alexander S.Kresin <alex@belacy.belgorod.su>
        Copyright 2001 Antonio Linares <alinares@fivetech.com>
        www - http://www.harbour-project.org

        "Harbour Project"
        Copyright 1999-2003, http://www.harbour-project.org/
---------------------------------------------------------------------------*/

#xcommand @ <row>,<col> US_RICHEDITBOX <name> ;
                [ <dummy1: OF, PARENT> <parent> ] ;
                [ WIDTH <w> ] ;
                [ HEIGHT <h> ] ;
                [ FILE <file> ]         ;
                [ VALUE <value> ] ;
                [ < readonly: READONLY > ] ;
                [ FONT <f> ] ;
                [ SIZE <s> ] ;
                [ <bold : BOLD> ] ;
                [ <italic : ITALIC> ] ;
                [ <underline : UNDERLINE> ] ;
                [ <strikeout : STRIKEOUT> ] ;
                [ TOOLTIP <tooltip> ] ;
                [ BACKCOLOR <backcolor> ] ;
                [ FONTCOLOR <fontcolor> ] ;
                [ MAXLENGTH <maxlength> ] ;
                [ ON GOTFOCUS <gotfocus> ] ;
                [ ON CHANGE <change> ] ;
                [ ON SELECT <select> ] ;
                [ ON LOSTFOCUS <lostfocus> ] ;
                [ ON VSCROLL <vscroll> ] ;
                [ HELPID <helpid> ] ;
                [ <invisible: INVISIBLE> ] ;
                [ <notabstop: NOTABSTOP> ] ;
                [ <plaintext : PLAINTEXT> ] ;
                [ <novscroll: NOVSCROLL> ] ;
                [ <nohscroll: NOHSCROLL> ] ;
        =>;
        _DefineRichEditBox ( <"name">, <"parent">, <col>, <row>, <w>, <h>, <value> , <f>, <s> , <tooltip> , <maxlength> , <{gotfocus}> , <{change}> , <{lostfocus}> , <.readonly.> , .f. , <helpid>, <.invisible.>, <.notabstop.> , <.bold.>, <.italic.>, <.underline.>, <.strikeout.> , <file> , "" , <backcolor> , <fontcolor> , <.plaintext.> , <.nohscroll.> , <.novscroll.> , <{select}> , <{vscroll}> )



//FIELD VERSION

#xcommand @ <row>,<col> US_RICHEDITBOX <name> ;
                [ <dummy1: OF, PARENT> <parent> ] ;
                [ WIDTH <w> ] ;
                [ HEIGHT <h> ] ;
                FIELD <field>   ;
                [ VALUE <value> ] ;
                [ < readonly: READONLY > ] ;
                [ FONT <f> ] ;
                [ SIZE <s> ] ;
                [ <bold : BOLD> ] ;
                [ <italic : ITALIC> ] ;
                [ <underline : UNDERLINE> ] ;
                [ <strikeout : STRIKEOUT> ] ;
                [ TOOLTIP <tooltip> ] ;
                [ BACKCOLOR <backcolor> ] ;
                [ FONTCOLOR <fontcolor> ] ;
                [ MAXLENGTH <maxlength> ] ;
                [ ON GOTFOCUS <gotfocus> ] ;
                [ ON CHANGE <change> ] ;
                [ ON SELECT <select> ] ;
                [ ON LOSTFOCUS <lostfocus> ] ;
                [ ON VSCROLL <vscroll> ] ;
                [ HELPID <helpid> ] ;
                [ <invisible: INVISIBLE> ] ;
                [ <notabstop: NOTABSTOP> ] ;
                [ <plaintext : PLAINTEXT> ] ;
                [ <novscroll: NOVSCROLL> ] ;
                [ <nohscroll: NOHSCROLL> ] ;
        =>;
        _DefineRichEditBox ( <"name">, <"parent">, <col>, <row>, <w>, <h>, <value> , <f>, <s> , <tooltip> , <maxlength> , <{gotfocus}> , <{change}> , <{lostfocus}> , <.readonly.> , .f. , <helpid>, <.invisible.>, <.notabstop.> , <.bold.>, <.italic.>, <.underline.>, <.strikeout.> , "", <"field"> , <backcolor> , <fontcolor> , <.plaintext.>, <.nohscroll.> , <.novscroll.> , <{select}> , <{vscroll}> )



//SPLITBOX VERSION

#xcommand US_RICHEDITBOX <name> ;
                [ <dummy1: OF, PARENT> <parent> ] ;
                [ WIDTH <w> ] ;
                [ HEIGHT <h> ] ;
                [ FILE <file> ] ;
                [ VALUE <value> ] ;
                [ < readonly: READONLY > ] ;
                [ FONT <f> ] ;
                [ SIZE <s> ] ;
                [ <bold : BOLD> ] ;
                [ <italic : ITALIC> ] ;
                [ <underline : UNDERLINE> ] ;
                [ <strikeout : STRIKEOUT> ] ;
                [ TOOLTIP <tooltip> ] ;
                [ BACKCOLOR <backcolor> ] ;
                [ FONTCOLOR <fontcolor> ] ;
                [ MAXLENGTH <maxlength> ] ;
                [ ON GOTFOCUS <gotfocus> ] ;
                [ ON CHANGE <change> ] ;
                [ ON SELECT <select> ] ;
                [ ON LOSTFOCUS <lostfocus> ] ;
                [ ON VSCROLL <vscroll> ] ;
                [ HELPID <helpid> ] ;
                [ <break: BREAK> ] ;
                [ <invisible: INVISIBLE> ] ;
                [ <notabstop: NOTABSTOP> ] ;
                [ <plaintext : PLAINTEXT> ] ;
                [ <novscroll: NOVSCROLL> ] ;
                [ <nohscroll: NOHSCROLL> ] ;
        =>;
        _DefineRichEditBox ( <"name">, <"parent">, , , <w>, <h>, <value>, <f>, <s> , <tooltip> , <maxlength> , <{gotfocus}> , <{change}> , <{lostfocus}> , <.readonly.> , <.break.> , <helpid>, <.invisible.>, <.notabstop.> , <.bold.>, <.italic.>, <.underline.>, <.strikeout.> , <file> , "" , <backcolor> , <fontcolor> , <.plaintext.>, <.nohscroll.> , <.novscroll.> , <{select}> , <{vscroll}> )

//----------------------------------------------------------------------------------------------------------------//
//= fin bloque Richedit.  Extracted from i_richeditbox.ch ========================================================//
//================================================================================================================//

/* eof */
