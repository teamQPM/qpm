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

// Resources ID definitions
#include "resource.h"

/*
 * Resource name          Resource Type    Resource FileName
*/

// ICONS
   QPM                          ICON       .\resource\QPM.ico
   QPMProject                   ICON       .\resource\QPM_Project.ico
   XHOTRECOVERY                 ICON       .\resource\us_hot2.ico
   XKILLER                      ICON       .\resource\us_killer.ico

// BITMAPS
   REVOLVER                     BITMAP     .\resource\us_killer.bmp
   REVOLVER2                    BITMAP     .\resource\us_killer2.bmp
   QPMWAIT                      BITMAP     .\resource\QPM.bmp
   NEW                          BITMAP     .\resource\new.bmp
   FORCE                        BITMAP     .\resource\ForceNonIncremental.bmp
   SAVE                         BITMAP     .\resource\save.bmp
   OPEN                         BITMAP     .\resource\OPEN.BMP
   RUN                          BITMAP     .\resource\run.bmp
   BUILD                        BITMAP     .\resource\Build.bmp
   HELP                         BITMAP     .\resource\HELP.BMP
   ADD                          BITMAP     .\resource\ADD.BMP
   REMOVE                       BITMAP     .\resource\REMOVE.BMP
   HOTREC                       BITMAP     .\resource\HotRecovery.bmp
   FORCERECOMP                  BITMAP     .\resource\ForceRecomp.bmp
   CHANGEVERSION                BITMAP     .\resource\ChangeVersion.bmp
   EDIT                         BITMAP     .\resource\EDIT.BMP
   SETTOP                       BITMAP     .\resource\SETTOP.BMP
   FOLDERSELECT                 BITMAP     .\resource\FOLDERSELECT.BMP
   DOWN                         BITMAP     .\resource\DOWN.BMP
   UP                           BITMAP     .\resource\UP.BMP
   CLEARALL                     BITMAP     .\resource\CLEARALL.BMP
   TEST                         BITMAP     .\resource\TEST.BMP
   STOP                         BITMAP     .\resource\STOP.BMP
   KILL                         BITMAP     .\resource\KILL.BMP
   YELLOW                       BITMAP     .\resource\YELLOW.BMP
   WHITE                        BITMAP     .\resource\WHITE.BMP
   SYNC                         BITMAP     .\resource\SYNC.BMP
   SORT                         BITMAP     .\resource\SORT.BMP
   GridNone                     BITMAP     .\resource\GridNone.BMP
   GridTilde                    BITMAP     .\resource\GridTilde.BMP
   GridEquis                    BITMAP     .\resource\GridEquis.BMP
   GridTildeEquis               BITMAP     .\resource\GridTildeEquis.BMP
   GridSearchok                 BITMAP     .\resource\GridSearchOk.BMP
   GridTildeSearchok            BITMAP     .\resource\GridTildeSearchok.BMP
   GridEquisSearchok            BITMAP     .\resource\GridEquisSearchok.BMP
   GridTildeEquisSearchok       BITMAP     .\resource\GridTildeEquisSearchok.BMP
   GridEdited                   BITMAP     .\resource\GridEdited.BMP
   GridTildeEdited              BITMAP     .\resource\GridTildeEdited.BMP
   GridEquisEdited              BITMAP     .\resource\GridEquisEdited.BMP
   GridTildeEquisEdited         BITMAP     .\resource\GridTildeEquisEdited.BMP
   GridSearchokEdited           BITMAP     .\resource\GridSearchokEdited.BMP
   GridTildeSearchokEdited      BITMAP     .\resource\GridTildeSearchokEdited.BMP
   GridEquisSearchokEdited      BITMAP     .\resource\GridEquisSearchokEdited.BMP
   GridTildeEquisSearchokEdited BITMAP     .\resource\GridTildeEquisSearchokEdited.BMP
   GridSearchNotok              BITMAP     .\resource\GridSearchNotOk.BMP
   GridHlpGlobalFoot            BITMAP     .\resource\SHG_ImgFoot.BMP
   GridHlpWelcome               BITMAP     .\resource\SHG_ImgWelcome.BMP
   GridHlpBook                  BITMAP     .\resource\SHG_ImgBook.BMP
   GridHlpPage                  BITMAP     .\resource\SHG_ImgPage.BMP
   GridHlpGlobalFootSearchOk    BITMAP     .\resource\SHG_ImgFootSearchOk.BMP
   GridHlpWelcomeSearchOk       BITMAP     .\resource\SHG_ImgWelcomeSearchOk.BMP
   GridHlpBookSearchOk          BITMAP     .\resource\SHG_ImgBookSearchOk.BMP
   GridHlpPageSearchOk          BITMAP     .\resource\SHG_ImgPageSearchOk.BMP
   GridHotFrom                  BITMAP     .\resource\GridImgHotFrom.BMP
   GridHotTarget                BITMAP     .\resource\GridImgHotTarget.BMP
   GridHotComment               BITMAP     .\resource\GridImgHotComment.BMP
   GridHotFromComment           BITMAP     .\resource\GridImgHotFromComment.BMP
   GridHotTargetComment         BITMAP     .\resource\GridImgHotTargetComment.BMP
   SHG_FileNotFound             BITMAP     .\resource\SHG_FileNotFound.BMP
   SHG_FileNotSupported         BITMAP     .\resource\SHG_FileNotSupported.BMP
   MI_Tree                      BITMAP     .\resource\MI_Tree.bmp
   MI_Main                      BITMAP     .\resource\MI_Main.bmp
   WWW_New                      BITMAP     .\resource\WWW_New.bmp
   WWW_Close                    BITMAP     .\resource\WWW_Close.bmp
   WWW_CloseAll                 BITMAP     .\resource\WWW_CloseAll.bmp
   WWW_Prev                     BITMAP     .\resource\WWW_Prev.bmp
   WWW_Next                     BITMAP     .\resource\WWW_Next.bmp
   WWW_Stop                     BITMAP     .\resource\WWW_Stop.bmp
   WWW_StopAll                  BITMAP     .\resource\WWW_StopAll.bmp
   WWW_ReLoad                   BITMAP     .\resource\WWW_ReLoad.bmp
   WWW_ReLoadAll                BITMAP     .\resource\WWW_ReLoadAll.bmp
   WWW_Home                     BITMAP     .\resource\WWW_Home.bmp
   WWW_Favorites                BITMAP     .\resource\WWW_Favorites.bmp
   WWW_FullScreen               BITMAP     .\resource\WWW_FullScreen.bmp
   WWW_Settings                 BITMAP     .\resource\WWW_Settings.bmp
   WWW_GREEN                    BITMAP     .\resource\WWW_GREEN.bmp
   WWW_RED                      BITMAP     .\resource\WWW_RED.bmp
   BANSP                        BITMAP     .\resource\BanSP.bmp
   BANEN                        BITMAP     .\resource\BanEN.bmp
   BANBR                        BITMAP     .\resource\BanBR.bmp
   BANPT                        BITMAP     .\resource\BanPT.bmp
   SHG_ARROWPREV                BITMAP     .\resource\SHG_ArrowPrev.bmp
   SHG_ARROWNEXT                BITMAP     .\resource\SHG_ArrowNext.bmp
   SHG_ARROWTOP                 BITMAP     .\resource\SHG_ArrowTop.bmp
   SHG_ARROWBOTTOM              BITMAP     .\resource\SHG_ArrowBottom.bmp
   SHG_BOOK                     BITMAP     .\resource\SHG_Book.BMP
   SHG_PAGE                     BITMAP     .\resource\SHG_Page.BMP
   SHG_WELCOME                  BITMAP     .\resource\SHG_Welcome.BMP

// STRINGS
STRINGTABLE
BEGIN
   ID_LICENSE_LINE_1  "QPM (QAC based Project Manager) License"
   ID_LICENSE_LINE_2  "You can use QPM on any computer, including a computer in a commercial organization."
   ID_LICENSE_LINE_3  "You don't need to register or pay for QPM."
   ID_LICENSE_LINE_4  "This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version."
   ID_LICENSE_LINE_5  "This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE."
   ID_LICENSE_LINE_6  "See the GNU General Public License for more details."
   ID_LICENSE_LINE_7  "You should have received a copy of the GNU General Public License along with this software; see the file LICENSE."
   ID_LICENSE_LINE_8  "If not, see http://www.gnu.org/licenses/."
   ID_LICENSE_LINE_9  "QPM License"
END

// RichEdit
#include ".\FuentesComunes\US_RichEdit.rc"

/* eof */
