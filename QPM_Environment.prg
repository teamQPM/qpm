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

#include "minigui.ch"
#include <QPM.ch>

memvar PRI_COMPATIBILITY_ENVIRONMENTVERSION
memvar PRI_COMPATIBILITY_ENVIRONMENTFILE
memvar PRI_COMPATIBILITY_ENVIRONMENTFILEAUX    
memvar HR_nVersionsMinimun
memvar HR_nVersionsSet


FUNCTION LoadEnvironment
   LOCAL EnvironmentMemo, EnvironmentVersion
   LOCAL LOC_cLine, nInx, vConfig, vAuxDir, i, cWinFolder, cData, aData, cType

   EnvironmentVersion := 0
   vConfig := {}
   Gbl_Text_Editor := ''

   /* MiniGui Oficial 1 with BCC */
   &("Gbl_T_C_"      + DefineMiniGui1  + DefineBorland + DefineHarbour  + Define32bits) := ''
   &("Gbl_T_M_"      + DefineMiniGui1  + DefineBorland + DefineHarbour  + Define32bits) := ''
   &("Gbl_T_P_"      + DefineMiniGui1  + DefineBorland + DefineHarbour  + Define32bits) := ''
   &("Gbl_T_C_LIBS_" + DefineMiniGui1  + DefineBorland + DefineHarbour  + Define32bits) := ''
   &("Gbl_T_M_LIBS_" + DefineMiniGui1  + DefineBorland + DefineHarbour  + Define32bits) := ''
   &("Gbl_T_P_LIBS_" + DefineMiniGui1  + DefineBorland + DefineHarbour  + Define32bits) := ''
   &("Gbl_T_N_"      + DefineMiniGui1  + DefineBorland + DefineHarbour  + Define32bits) := ''
   &("Gbl_T_G_"      + DefineMiniGui1  + DefineBorland + DefineHarbour  + Define32bits) := ''
   &("Gbl_DEF_LIBS_" + DefineMiniGui1  + DefineBorland + DefineHarbour  + Define32bits) := {}

   &("Gbl_T_C_"      + DefineMiniGui1  + DefineBorland + DefineXHarbour + Define32bits) := ''
   &("Gbl_T_M_"      + DefineMiniGui1  + DefineBorland + DefineXHarbour + Define32bits) := ''
   &("Gbl_T_P_"      + DefineMiniGui1  + DefineBorland + DefineXHarbour + Define32bits) := ''
   &("Gbl_T_C_LIBS_" + DefineMiniGui1  + DefineBorland + DefineXHarbour + Define32bits) := ''
   &("Gbl_T_M_LIBS_" + DefineMiniGui1  + DefineBorland + DefineXHarbour + Define32bits) := ''
   &("Gbl_T_P_LIBS_" + DefineMiniGui1  + DefineBorland + DefineXHarbour + Define32bits) := ''
   &("Gbl_T_N_"      + DefineMiniGui1  + DefineBorland + DefineXHarbour + Define32bits) := ''
   &("Gbl_T_G_"      + DefineMiniGui1  + DefineBorland + DefineXHarbour + Define32bits) := ''
   &("Gbl_DEF_LIBS_" + DefineMiniGui1  + DefineBorland + DefineXHarbour + Define32bits) := {}

   /* MiniGui Oficial 3 with MinGW */
   &("Gbl_T_C_"      + DefineMiniGui3  + DefineMinGW   + DefineHarbour  + Define32bits) := ''
   &("Gbl_T_M_"      + DefineMiniGui3  + DefineMinGW   + DefineHarbour  + Define32bits) := ''
   &("Gbl_T_P_"      + DefineMiniGui3  + DefineMinGW   + DefineHarbour  + Define32bits) := ''
   &("Gbl_T_C_LIBS_" + DefineMiniGui3  + DefineMinGW   + DefineHarbour  + Define32bits) := ''
   &("Gbl_T_M_LIBS_" + DefineMiniGui3  + DefineMinGW   + DefineHarbour  + Define32bits) := ''
   &("Gbl_T_P_LIBS_" + DefineMiniGui3  + DefineMinGW   + DefineHarbour  + Define32bits) := ''
   &("Gbl_T_N_"      + DefineMiniGui3  + DefineMinGW   + DefineHarbour  + Define32bits) := ''
   &("Gbl_T_G_"      + DefineMiniGui3  + DefineMinGW   + DefineHarbour  + Define32bits) := ''
   &("Gbl_DEF_LIBS_" + DefineMiniGui3  + DefineMinGW   + DefineHarbour  + Define32bits) := {}

   &("Gbl_T_C_"      + DefineMiniGui3  + DefineMinGW   + DefineHarbour  + Define64bits) := ''
   &("Gbl_T_M_"      + DefineMiniGui3  + DefineMinGW   + DefineHarbour  + Define64bits) := ''
   &("Gbl_T_P_"      + DefineMiniGui3  + DefineMinGW   + DefineHarbour  + Define64bits) := ''
   &("Gbl_T_C_LIBS_" + DefineMiniGui3  + DefineMinGW   + DefineHarbour  + Define64bits) := ''
   &("Gbl_T_M_LIBS_" + DefineMiniGui3  + DefineMinGW   + DefineHarbour  + Define64bits) := ''
   &("Gbl_T_P_LIBS_" + DefineMiniGui3  + DefineMinGW   + DefineHarbour  + Define64bits) := ''
   &("Gbl_T_N_"      + DefineMiniGui3  + DefineMinGW   + DefineHarbour  + Define64bits) := ''
   &("Gbl_T_G_"      + DefineMiniGui3  + DefineMinGW   + DefineHarbour  + Define64bits) := ''
   &("Gbl_DEF_LIBS_" + DefineMiniGui3  + DefineMinGW   + DefineHarbour  + Define64bits) := {}

   /* MiniGui Extended 1 with BCC */
   &("Gbl_T_C_"      + DefineExtended1 + DefineBorland + DefineHarbour  + Define32bits) := ''
   &("Gbl_T_M_"      + DefineExtended1 + DefineBorland + DefineHarbour  + Define32bits) := ''
   &("Gbl_T_P_"      + DefineExtended1 + DefineBorland + DefineHarbour  + Define32bits) := ''
   &("Gbl_T_C_LIBS_" + DefineExtended1 + DefineBorland + DefineHarbour  + Define32bits) := ''
   &("Gbl_T_M_LIBS_" + DefineExtended1 + DefineBorland + DefineHarbour  + Define32bits) := ''
   &("Gbl_T_P_LIBS_" + DefineExtended1 + DefineBorland + DefineHarbour  + Define32bits) := ''
   &("Gbl_T_N_"      + DefineExtended1 + DefineBorland + DefineHarbour  + Define32bits) := ''
   &("Gbl_T_G_"      + DefineExtended1 + DefineBorland + DefineHarbour  + Define32bits) := ''
   &("Gbl_DEF_LIBS_" + DefineExtended1 + DefineBorland + DefineHarbour  + Define32bits) := {}

   &("Gbl_T_C_"      + DefineExtended1 + DefineBorland + DefineXHarbour + Define32bits) := ''
   &("Gbl_T_M_"      + DefineExtended1 + DefineBorland + DefineXHarbour + Define32bits) := ''
   &("Gbl_T_P_"      + DefineExtended1 + DefineBorland + DefineXHarbour + Define32bits) := ''
   &("Gbl_T_C_LIBS_" + DefineExtended1 + DefineBorland + DefineXHarbour + Define32bits) := ''
   &("Gbl_T_M_LIBS_" + DefineExtended1 + DefineBorland + DefineXHarbour + Define32bits) := ''
   &("Gbl_T_P_LIBS_" + DefineExtended1 + DefineBorland + DefineXHarbour + Define32bits) := ''
   &("Gbl_T_N_"      + DefineExtended1 + DefineBorland + DefineXHarbour + Define32bits) := ''
   &("Gbl_T_G_"      + DefineExtended1 + DefineBorland + DefineXHarbour + Define32bits) := ''
   &("Gbl_DEF_LIBS_" + DefineExtended1 + DefineBorland + DefineXHarbour + Define32bits) := {}

   /* MiniGui Extended 1 with MinGW */
   &("Gbl_T_C_"      + DefineExtended1 + DefineMinGW   + DefineHarbour  + Define32bits) := ''
   &("Gbl_T_M_"      + DefineExtended1 + DefineMinGW   + DefineHarbour  + Define32bits) := ''
   &("Gbl_T_P_"      + DefineExtended1 + DefineMinGW   + DefineHarbour  + Define32bits) := ''
   &("Gbl_T_C_LIBS_" + DefineExtended1 + DefineMinGW   + DefineHarbour  + Define32bits) := ''
   &("Gbl_T_M_LIBS_" + DefineExtended1 + DefineMinGW   + DefineHarbour  + Define32bits) := ''
   &("Gbl_T_P_LIBS_" + DefineExtended1 + DefineMinGW   + DefineHarbour  + Define32bits) := ''
   &("Gbl_T_N_"      + DefineExtended1 + DefineMinGW   + DefineHarbour  + Define32bits) := ''
   &("Gbl_T_G_"      + DefineExtended1 + DefineMinGW   + DefineHarbour  + Define32bits) := ''
   &("Gbl_DEF_LIBS_" + DefineExtended1 + DefineMinGW   + DefineHarbour  + Define32bits) := {}

   &("Gbl_T_C_"      + DefineExtended1 + DefineMinGW   + DefineXHarbour + Define32bits) := ''
   &("Gbl_T_M_"      + DefineExtended1 + DefineMinGW   + DefineXHarbour + Define32bits) := ''
   &("Gbl_T_P_"      + DefineExtended1 + DefineMinGW   + DefineXHarbour + Define32bits) := ''
   &("Gbl_T_C_LIBS_" + DefineExtended1 + DefineMinGW   + DefineXHarbour + Define32bits) := ''
   &("Gbl_T_M_LIBS_" + DefineExtended1 + DefineMinGW   + DefineXHarbour + Define32bits) := ''
   &("Gbl_T_P_LIBS_" + DefineExtended1 + DefineMinGW   + DefineXHarbour + Define32bits) := ''
   &("Gbl_T_N_"      + DefineExtended1 + DefineMinGW   + DefineXHarbour + Define32bits) := ''
   &("Gbl_T_G_"      + DefineExtended1 + DefineMinGW   + DefineXHarbour + Define32bits) := ''
   &("Gbl_DEF_LIBS_" + DefineExtended1 + DefineMinGW   + DefineXHarbour + Define32bits) := {}

   &("Gbl_T_C_"      + DefineExtended1 + DefineMinGW   + DefineHarbour  + Define64bits) := ''
   &("Gbl_T_M_"      + DefineExtended1 + DefineMinGW   + DefineHarbour  + Define64bits) := ''
   &("Gbl_T_P_"      + DefineExtended1 + DefineMinGW   + DefineHarbour  + Define64bits) := ''
   &("Gbl_T_C_LIBS_" + DefineExtended1 + DefineMinGW   + DefineHarbour  + Define64bits) := ''
   &("Gbl_T_M_LIBS_" + DefineExtended1 + DefineMinGW   + DefineHarbour  + Define64bits) := ''
   &("Gbl_T_P_LIBS_" + DefineExtended1 + DefineMinGW   + DefineHarbour  + Define64bits) := ''
   &("Gbl_T_N_"      + DefineExtended1 + DefineMinGW   + DefineHarbour  + Define64bits) := ''
   &("Gbl_T_G_"      + DefineExtended1 + DefineMinGW   + DefineHarbour  + Define64bits) := ''
   &("Gbl_DEF_LIBS_" + DefineExtended1 + DefineMinGW   + DefineHarbour  + Define64bits) := {}

   &("Gbl_T_C_"      + DefineExtended1 + DefineMinGW   + DefineXHarbour + Define64bits) := ''
   &("Gbl_T_M_"      + DefineExtended1 + DefineMinGW   + DefineXHarbour + Define64bits) := ''
   &("Gbl_T_P_"      + DefineExtended1 + DefineMinGW   + DefineXHarbour + Define64bits) := ''
   &("Gbl_T_C_LIBS_" + DefineExtended1 + DefineMinGW   + DefineXHarbour + Define64bits) := ''
   &("Gbl_T_M_LIBS_" + DefineExtended1 + DefineMinGW   + DefineXHarbour + Define64bits) := ''
   &("Gbl_T_P_LIBS_" + DefineExtended1 + DefineMinGW   + DefineXHarbour + Define64bits) := ''
   &("Gbl_T_N_"      + DefineExtended1 + DefineMinGW   + DefineXHarbour + Define64bits) := ''
   &("Gbl_T_G_"      + DefineExtended1 + DefineMinGW   + DefineXHarbour + Define64bits) := ''
   &("Gbl_DEF_LIBS_" + DefineExtended1 + DefineMinGW   + DefineXHarbour + Define64bits) := {}

   /* MiniGui Extended 1 with Pelles */
   &("Gbl_T_C_"      + DefineExtended1 + DefinePelles  + DefineHarbour  + Define32bits) := ''
   &("Gbl_T_M_"      + DefineExtended1 + DefinePelles  + DefineHarbour  + Define32bits) := ''
   &("Gbl_T_P_"      + DefineExtended1 + DefinePelles  + DefineHarbour  + Define32bits) := ''
   &("Gbl_T_C_LIBS_" + DefineExtended1 + DefinePelles  + DefineHarbour  + Define32bits) := ''
   &("Gbl_T_M_LIBS_" + DefineExtended1 + DefinePelles  + DefineHarbour  + Define32bits) := ''
   &("Gbl_T_P_LIBS_" + DefineExtended1 + DefinePelles  + DefineHarbour  + Define32bits) := ''
   &("Gbl_T_N_"      + DefineExtended1 + DefinePelles  + DefineHarbour  + Define32bits) := ''
   &("Gbl_T_G_"      + DefineExtended1 + DefinePelles  + DefineHarbour  + Define32bits) := ''
   &("Gbl_DEF_LIBS_" + DefineExtended1 + DefinePelles  + DefineHarbour  + Define32bits) := {}

   &("Gbl_T_C_"      + DefineExtended1 + DefinePelles  + DefineXHarbour + Define32bits) := ''
   &("Gbl_T_M_"      + DefineExtended1 + DefinePelles  + DefineXHarbour + Define32bits) := ''
   &("Gbl_T_P_"      + DefineExtended1 + DefinePelles  + DefineXHarbour + Define32bits) := ''
   &("Gbl_T_C_LIBS_" + DefineExtended1 + DefinePelles  + DefineXHarbour + Define32bits) := ''
   &("Gbl_T_M_LIBS_" + DefineExtended1 + DefinePelles  + DefineXHarbour + Define32bits) := ''
   &("Gbl_T_P_LIBS_" + DefineExtended1 + DefinePelles  + DefineXHarbour + Define32bits) := ''
   &("Gbl_T_N_"      + DefineExtended1 + DefinePelles  + DefineXHarbour + Define32bits) := ''
   &("Gbl_T_G_"      + DefineExtended1 + DefinePelles  + DefineXHarbour + Define32bits) := ''
   &("Gbl_DEF_LIBS_" + DefineExtended1 + DefinePelles  + DefineXHarbour + Define32bits) := {}

   &("Gbl_T_C_"      + DefineExtended1 + DefinePelles  + DefineHarbour  + Define64bits) := ''
   &("Gbl_T_M_"      + DefineExtended1 + DefinePelles  + DefineHarbour  + Define64bits) := ''
   &("Gbl_T_P_"      + DefineExtended1 + DefinePelles  + DefineHarbour  + Define64bits) := ''
   &("Gbl_T_C_LIBS_" + DefineExtended1 + DefinePelles  + DefineHarbour  + Define64bits) := ''
   &("Gbl_T_M_LIBS_" + DefineExtended1 + DefinePelles  + DefineHarbour  + Define64bits) := ''
   &("Gbl_T_P_LIBS_" + DefineExtended1 + DefinePelles  + DefineHarbour  + Define64bits) := ''
   &("Gbl_T_N_"      + DefineExtended1 + DefinePelles  + DefineHarbour  + Define64bits) := ''
   &("Gbl_T_G_"      + DefineExtended1 + DefinePelles  + DefineHarbour  + Define64bits) := ''
   &("Gbl_DEF_LIBS_" + DefineExtended1 + DefinePelles  + DefineHarbour  + Define64bits) := {}

   &("Gbl_T_C_"      + DefineExtended1 + DefinePelles  + DefineXHarbour + Define64bits) := ''
   &("Gbl_T_M_"      + DefineExtended1 + DefinePelles  + DefineXHarbour + Define64bits) := ''
   &("Gbl_T_P_"      + DefineExtended1 + DefinePelles  + DefineXHarbour + Define64bits) := ''
   &("Gbl_T_C_LIBS_" + DefineExtended1 + DefinePelles  + DefineXHarbour + Define64bits) := ''
   &("Gbl_T_M_LIBS_" + DefineExtended1 + DefinePelles  + DefineXHarbour + Define64bits) := ''
   &("Gbl_T_P_LIBS_" + DefineExtended1 + DefinePelles  + DefineXHarbour + Define64bits) := ''
   &("Gbl_T_N_"      + DefineExtended1 + DefinePelles  + DefineXHarbour + Define64bits) := ''
   &("Gbl_T_G_"      + DefineExtended1 + DefinePelles  + DefineXHarbour + Define64bits) := ''
   &("Gbl_DEF_LIBS_" + DefineExtended1 + DefinePelles  + DefineXHarbour + Define64bits) := {}

   /* OOHG with BCC */
   &("Gbl_T_C_"      + DefineOohg3     + DefineBorland + DefineHarbour  + Define32bits) := ''
   &("Gbl_T_M_"      + DefineOohg3     + DefineBorland + DefineHarbour  + Define32bits) := ''
   &("Gbl_T_P_"      + DefineOohg3     + DefineBorland + DefineHarbour  + Define32bits) := ''
   &("Gbl_T_C_LIBS_" + DefineOohg3     + DefineBorland + DefineHarbour  + Define32bits) := ''
   &("Gbl_T_M_LIBS_" + DefineOohg3     + DefineBorland + DefineHarbour  + Define32bits) := ''
   &("Gbl_T_P_LIBS_" + DefineOohg3     + DefineBorland + DefineHarbour  + Define32bits) := ''
   &("Gbl_T_N_"      + DefineOohg3     + DefineBorland + DefineHarbour  + Define32bits) := ''
   &("Gbl_T_G_"      + DefineOohg3     + DefineBorland + DefineHarbour  + Define32bits) := ''
   &("Gbl_DEF_LIBS_" + DefineOohg3     + DefineBorland + DefineHarbour  + Define32bits) := {}

   &("Gbl_T_C_"      + DefineOohg3     + DefineBorland + DefineXHarbour + Define32bits) := ''
   &("Gbl_T_M_"      + DefineOohg3     + DefineBorland + DefineXHarbour + Define32bits) := ''
   &("Gbl_T_P_"      + DefineOohg3     + DefineBorland + DefineXHarbour + Define32bits) := ''
   &("Gbl_T_C_LIBS_" + DefineOohg3     + DefineBorland + DefineXHarbour + Define32bits) := ''
   &("Gbl_T_M_LIBS_" + DefineOohg3     + DefineBorland + DefineXHarbour + Define32bits) := ''
   &("Gbl_T_P_LIBS_" + DefineOohg3     + DefineBorland + DefineXHarbour + Define32bits) := ''
   &("Gbl_T_N_"      + DefineOohg3     + DefineBorland + DefineXHarbour + Define32bits) := ''
   &("Gbl_T_G_"      + DefineOohg3     + DefineBorland + DefineXHarbour + Define32bits) := ''
   &("Gbl_DEF_LIBS_" + DefineOohg3     + DefineBorland + DefineXHarbour + Define32bits) := {}

   /* OOHG with MinGW */
   &("Gbl_T_C_"      + DefineOohg3     + DefineMinGW   + DefineHarbour  + Define32bits) := ''
   &("Gbl_T_M_"      + DefineOohg3     + DefineMinGW   + DefineHarbour  + Define32bits) := ''
   &("Gbl_T_P_"      + DefineOohg3     + DefineMinGW   + DefineHarbour  + Define32bits) := ''
   &("Gbl_T_C_LIBS_" + DefineOohg3     + DefineMinGW   + DefineHarbour  + Define32bits) := ''
   &("Gbl_T_M_LIBS_" + DefineOohg3     + DefineMinGW   + DefineHarbour  + Define32bits) := ''
   &("Gbl_T_P_LIBS_" + DefineOohg3     + DefineMinGW   + DefineHarbour  + Define32bits) := ''
   &("Gbl_T_N_"      + DefineOohg3     + DefineMinGW   + DefineHarbour  + Define32bits) := ''
   &("Gbl_T_G_"      + DefineOohg3     + DefineMinGW   + DefineHarbour  + Define32bits) := ''
   &("Gbl_DEF_LIBS_" + DefineOohg3     + DefineMinGW   + DefineHarbour  + Define32bits) := {}

   &("Gbl_T_C_"      + DefineOohg3     + DefineMinGW   + DefineXHarbour + Define32bits) := ''
   &("Gbl_T_M_"      + DefineOohg3     + DefineMinGW   + DefineXHarbour + Define32bits) := ''
   &("Gbl_T_P_"      + DefineOohg3     + DefineMinGW   + DefineXHarbour + Define32bits) := ''
   &("Gbl_T_C_LIBS_" + DefineOohg3     + DefineMinGW   + DefineXHarbour + Define32bits) := ''
   &("Gbl_T_M_LIBS_" + DefineOohg3     + DefineMinGW   + DefineXHarbour + Define32bits) := ''
   &("Gbl_T_P_LIBS_" + DefineOohg3     + DefineMinGW   + DefineXHarbour + Define32bits) := ''
   &("Gbl_T_N_"      + DefineOohg3     + DefineMinGW   + DefineXHarbour + Define32bits) := ''
   &("Gbl_T_G_"      + DefineOohg3     + DefineMinGW   + DefineXHarbour + Define32bits) := ''
   &("Gbl_DEF_LIBS_" + DefineOohg3     + DefineMinGW   + DefineXHarbour + Define32bits) := {}

   &("Gbl_T_C_"      + DefineOohg3     + DefineMinGW   + DefineHarbour  + Define64bits) := ''
   &("Gbl_T_M_"      + DefineOohg3     + DefineMinGW   + DefineHarbour  + Define64bits) := ''
   &("Gbl_T_P_"      + DefineOohg3     + DefineMinGW   + DefineHarbour  + Define64bits) := ''
   &("Gbl_T_C_LIBS_" + DefineOohg3     + DefineMinGW   + DefineHarbour  + Define64bits) := ''
   &("Gbl_T_M_LIBS_" + DefineOohg3     + DefineMinGW   + DefineHarbour  + Define64bits) := ''
   &("Gbl_T_P_LIBS_" + DefineOohg3     + DefineMinGW   + DefineHarbour  + Define64bits) := ''
   &("Gbl_T_N_"      + DefineOohg3     + DefineMinGW   + DefineHarbour  + Define64bits) := ''
   &("Gbl_T_G_"      + DefineOohg3     + DefineMinGW   + DefineHarbour  + Define64bits) := ''
   &("Gbl_DEF_LIBS_" + DefineOohg3     + DefineMinGW   + DefineHarbour  + Define64bits) := {}

   &("Gbl_T_C_"      + DefineOohg3     + DefineMinGW   + DefineXHarbour + Define64bits) := ''
   &("Gbl_T_M_"      + DefineOohg3     + DefineMinGW   + DefineXHarbour + Define64bits) := ''
   &("Gbl_T_P_"      + DefineOohg3     + DefineMinGW   + DefineXHarbour + Define64bits) := ''
   &("Gbl_T_C_LIBS_" + DefineOohg3     + DefineMinGW   + DefineXHarbour + Define64bits) := ''
   &("Gbl_T_M_LIBS_" + DefineOohg3     + DefineMinGW   + DefineXHarbour + Define64bits) := ''
   &("Gbl_T_P_LIBS_" + DefineOohg3     + DefineMinGW   + DefineXHarbour + Define64bits) := ''
   &("Gbl_T_N_"      + DefineOohg3     + DefineMinGW   + DefineXHarbour + Define64bits) := ''
   &("Gbl_T_G_"      + DefineOohg3     + DefineMinGW   + DefineXHarbour + Define64bits) := ''
   &("Gbl_DEF_LIBS_" + DefineOohg3     + DefineMinGW   + DefineXHarbour + Define64bits) := {}

   /* OOHG with Pelles */
   &("Gbl_T_C_"      + DefineOohg3     + DefinePelles  + DefineHarbour  + Define32bits) := ''
   &("Gbl_T_M_"      + DefineOohg3     + DefinePelles  + DefineHarbour  + Define32bits) := ''
   &("Gbl_T_P_"      + DefineOohg3     + DefinePelles  + DefineHarbour  + Define32bits) := ''
   &("Gbl_T_C_LIBS_" + DefineOohg3     + DefinePelles  + DefineHarbour  + Define32bits) := ''
   &("Gbl_T_M_LIBS_" + DefineOohg3     + DefinePelles  + DefineHarbour  + Define32bits) := ''
   &("Gbl_T_P_LIBS_" + DefineOohg3     + DefinePelles  + DefineHarbour  + Define32bits) := ''
   &("Gbl_T_N_"      + DefineOohg3     + DefinePelles  + DefineHarbour  + Define32bits) := ''
   &("Gbl_T_G_"      + DefineOohg3     + DefinePelles  + DefineHarbour  + Define32bits) := ''
   &("Gbl_DEF_LIBS_" + DefineOohg3     + DefinePelles  + DefineHarbour  + Define32bits) := {}

   &("Gbl_T_C_"      + DefineOohg3     + DefinePelles  + DefineXHarbour + Define32bits) := ''
   &("Gbl_T_M_"      + DefineOohg3     + DefinePelles  + DefineXHarbour + Define32bits) := ''
   &("Gbl_T_P_"      + DefineOohg3     + DefinePelles  + DefineXHarbour + Define32bits) := ''
   &("Gbl_T_C_LIBS_" + DefineOohg3     + DefinePelles  + DefineXHarbour + Define32bits) := ''
   &("Gbl_T_M_LIBS_" + DefineOohg3     + DefinePelles  + DefineXHarbour + Define32bits) := ''
   &("Gbl_T_P_LIBS_" + DefineOohg3     + DefinePelles  + DefineXHarbour + Define32bits) := ''
   &("Gbl_T_N_"      + DefineOohg3     + DefinePelles  + DefineXHarbour + Define32bits) := ''
   &("Gbl_T_G_"      + DefineOohg3     + DefinePelles  + DefineXHarbour + Define32bits) := ''
   &("Gbl_DEF_LIBS_" + DefineOohg3     + DefinePelles  + DefineXHarbour + Define32bits) := {}

   &("Gbl_T_C_"      + DefineOohg3     + DefinePelles  + DefineHarbour  + Define64bits) := ''
   &("Gbl_T_M_"      + DefineOohg3     + DefinePelles  + DefineHarbour  + Define64bits) := ''
   &("Gbl_T_P_"      + DefineOohg3     + DefinePelles  + DefineHarbour  + Define64bits) := ''
   &("Gbl_T_C_LIBS_" + DefineOohg3     + DefinePelles  + DefineHarbour  + Define64bits) := ''
   &("Gbl_T_M_LIBS_" + DefineOohg3     + DefinePelles  + DefineHarbour  + Define64bits) := ''
   &("Gbl_T_P_LIBS_" + DefineOohg3     + DefinePelles  + DefineHarbour  + Define64bits) := ''
   &("Gbl_T_N_"      + DefineOohg3     + DefinePelles  + DefineHarbour  + Define64bits) := ''
   &("Gbl_T_G_"      + DefineOohg3     + DefinePelles  + DefineHarbour  + Define64bits) := ''
   &("Gbl_DEF_LIBS_" + DefineOohg3     + DefinePelles  + DefineHarbour  + Define64bits) := {}

   &("Gbl_T_C_"      + DefineOohg3     + DefinePelles  + DefineXHarbour + Define64bits) := ''
   &("Gbl_T_M_"      + DefineOohg3     + DefinePelles  + DefineXHarbour + Define64bits) := ''
   &("Gbl_T_P_"      + DefineOohg3     + DefinePelles  + DefineXHarbour + Define64bits) := ''
   &("Gbl_T_C_LIBS_" + DefineOohg3     + DefinePelles  + DefineXHarbour + Define64bits) := ''
   &("Gbl_T_M_LIBS_" + DefineOohg3     + DefinePelles  + DefineXHarbour + Define64bits) := ''
   &("Gbl_T_P_LIBS_" + DefineOohg3     + DefinePelles  + DefineXHarbour + Define64bits) := ''
   &("Gbl_T_N_"      + DefineOohg3     + DefinePelles  + DefineXHarbour + Define64bits) := ''
   &("Gbl_T_G_"      + DefineOohg3     + DefinePelles  + DefineXHarbour + Define64bits) := ''
   &("Gbl_DEF_LIBS_" + DefineOohg3     + DefinePelles  + DefineXHarbour + Define64bits) := {}

   bEditorLongName := .F.
   bSuspendControlEdit := .F.
   bNoFMGextension := .F.
   
   if PUB_bLite .and. File( US_FileNameOnlyPathAndName( PUB_cProjectFile ) + ".cfg" )
      EnvironmentMemo := MemoRead( US_FileNameOnlyPathAndName( PUB_cProjectFile ) + ".cfg" )
   else
      if File( PUB_cQPM_Folder + DEF_SLASH + 'QPM_' + QPM_VERSION_NUMBER_LONG + '.cfg' )
         if US_DirWrite( cWinFolder := GetWindowsFolder() )
            if File( GetWindowsFolder() + DEF_SLASH + 'QPM_' + QPM_VERSION_NUMBER_LONG + '.path' )
               if ! ( MemoRead( GetWindowsFolder() + DEF_SLASH + 'QPM_' + QPM_VERSION_NUMBER_LONG + '.path' ) == PUB_cQPM_Folder )
                  QPM_MemoWrit( GetWindowsFolder() + DEF_SLASH + 'QPM_' + QPM_VERSION_NUMBER_LONG + '.path', PUB_cQPM_Folder )
               endif
            else
               QPM_MemoWrit( GetWindowsFolder() + DEF_SLASH + 'QPM_' + QPM_VERSION_NUMBER_LONG + '.path', PUB_cQPM_Folder )
            endif
         endif
      else
         if US_DirWrite( cWinFolder := GetWindowsFolder() )
            // process old path files
            vAuxDir := Array( ADIR( cWinFolder + DEF_SLASH + 'QAC_????????.path' ) )
            ADIR( cWinFolder + DEF_SLASH + 'QAC_????????.path', vAuxDir )
            for nInx := 1 to len( vAuxDir )
               if val( substr( vAuxDir[nInx], 5, 8 ) ) < val( QPM_VERSION_NUMBER_LONG )
                  if US_IsDirectory( alltrim( memoline( memoread( cWinFolder + DEF_SLASH + vAuxDir[nInx] ), 254, 1 ) ) )
                     aadd( vConfig, vAuxDir[nInx] )
                  endif
               else
                  if val( substr( vAuxDir[nInx], 5, 8 ) ) == val( QPM_VERSION_NUMBER_LONG )
                     if !( upper( alltrim( memoline( memoread( cWinFolder + DEF_SLASH + vAuxDir[nInx] ), 254, 1 ) ) ) == upper( PUB_cQPM_Folder ) )
                        if US_IsDirectory( alltrim( memoline( memoread( cWinFolder + DEF_SLASH + vAuxDir[nInx] ), 254, 1 ) ) )
                           aadd( vConfig, vAuxDir[nInx] )
                        endif
                     endif
                  endif
               endif
            next
            // process new path files
            vAuxDir := Array( ADIR( cWinFolder + DEF_SLASH + 'QPM_????????.path' ) )
            ADIR( cWinFolder + DEF_SLASH + 'QPM_????????.path', vAuxDir )
            for nInx := 1 to len( vAuxDir )
               if val( substr( vAuxDir[nInx], 5, 8 ) ) < val( QPM_VERSION_NUMBER_LONG )
                  if US_IsDirectory( alltrim( memoline( memoread( cWinFolder + DEF_SLASH + vAuxDir[nInx] ), 254, 1 ) ) )
                     aadd( vConfig, vAuxDir[nInx] )
                  endif
               else
                  if val( substr( vAuxDir[nInx], 5, 8 ) ) == val( QPM_VERSION_NUMBER_LONG )
                     if !( upper( alltrim( memoline( memoread( cWinFolder + DEF_SLASH + vAuxDir[nInx] ), 254, 1 ) ) ) == upper( PUB_cQPM_Folder ) )
                        if US_IsDirectory( alltrim( memoline( memoread( cWinFolder + DEF_SLASH + vAuxDir[nInx] ), 254, 1 ) ) )
                           aadd( vConfig, vAuxDir[nInx] )
                        endif
                     endif
                  endif
               endif
            next
         endif
         // process old cfg files
         vAuxDir := Array( ADIR( PUB_cQPM_Folder + DEF_SLASH + 'QPM_????????.cfg' ) )
         ADIR( PUB_cQPM_Folder + DEF_SLASH + 'QPM_????????.cfg', vAuxDir )
         for nInx := 1 to len( vAuxDir )
            if val( substr( vAuxDir[nInx], 5, 8 ) ) < val( QPM_VERSION_NUMBER_LONG )
               aadd( vConfig, vAuxDir[nInx] )
            endif
         next
         // use the most recent cfg file (the one with the higher number)
         if len( vConfig ) > 0
            aSort( vConfig, , , { |x, y| US_Upper( substr( x, 5, 8 ) ) > US_Upper( substr( y, 5, 8 ) ) })
            if Upper( US_FileNameOnlyExt( vConfig[1] ) ) == "PATH"
               PUB_MigrateFolderFrom := AllTrim( MemoLine( MemoRead( cWinFolder + DEF_SLASH + vConfig[1] ), 254, 1 ) )
            else
               PUB_MigrateFolderFrom := PUB_cQPM_Folder
            endif
            PUB_MigrateVersionFrom := US_FileNameOnlyName( vConfig[1] )
            if File( PUB_MigrateFolderFrom + DEF_SLASH + PUB_MigrateVersionFrom + ".cfg" )
               US_FileCopy( PUB_MigrateFolderFrom + DEF_SLASH + PUB_MigrateVersionFrom + ".cfg", PUB_cQPM_Folder + DEF_SLASH + 'QPM_' + QPM_VERSION_NUMBER_LONG + '.cfg' )
            else
               US_Log( "Previous configuration file not found: " + PUB_MigrateFolderFrom + DEF_SLASH + PUB_MigrateVersionFrom + ".cfg" )
            endif
         endif
         // remember path if we can write in Windows folder
         if US_DirWrite( cWinFolder := GetWindowsFolder() )
            QPM_MemoWrit( cWinFolder + DEF_SLASH + 'QPM_' + QPM_VERSION_NUMBER_LONG + '.path', PUB_cQPM_Folder )
         endif
      endif
      EnvironmentMemo := MemoRead( PUB_cQPM_Folder + DEF_SLASH + 'QPM_' + QPM_VERSION_NUMBER_LONG + '.cfg' )
      if empty( PUB_MigrateFolderFrom )
         PUB_MigrateFolderFrom := cWinFolder
      endif
   endif
   if MLCount ( EnvironmentMemo, 254 ) > 0
      LOC_cLine := AllTrim( MemoLine( EnvironmentMemo, 254, 1 ) )
      if us_word( LOC_cLine, 1 ) == "VERSION"
         EnvironmentVersion := Val( us_word( LOC_cLine, 2 ) + us_word( LOC_cLine, 3 ) + us_word( LOC_cLine, 4 ) )
      else
         EnvironmentVersion := Val( "010001" )
      endif
   endif
   if EnvironmentVersion > Val( QPM_VERSION_NUMBER_SHORT )
      MyMsgStop( "Environment file will be ignored because its version is greater than QPM's version." + CRLF + ;
                 "Remembar to set the Global Options at Settings menu before building your project." )
      Return .F.
   endif

   PRIVATE PRI_COMPATIBILITY_ENVIRONMENTVERSION    := EnvironmentVersion
   PRIVATE PRI_COMPATIBILITY_ENVIRONMENTFILE       := EnvironmentMemo
   PRIVATE PRI_COMPATIBILITY_ENVIRONMENTFILEAUX    := Nil
#include "QPM_CompatibilityOpenGlobal.CH"
   EnvironmentMemo       := PRI_COMPATIBILITY_ENVIRONMENTFILE
   RELEASE PRI_COMPATIBILITY_ENVIRONMENTVERSION
   RELEASE PRI_COMPATIBILITY_ENVIRONMENTFILE
   RELEASE PRI_COMPATIBILITY_ENVIRONMENTFILEAUX

   /* Version ACTUAL */
   For i := 1 To MLCount ( EnvironmentMemo, 254 )
      DO EVENTS
      LOC_cLine := AllTrim ( MEMOLINE( EnvironmentMemo, 254, i ) )
      If     US_Upper( US_Word( LOC_cLine, 1 ) ) == 'PROGRAMEDITOR'
             Gbl_Text_Editor := US_WordSubStr( LOC_cLine, 2 )
      ElseIf US_Upper( US_Word( LOC_cLine, 1 ) ) == 'EDITLONGNAME'
             bEditorLongName := if( US_WordSubStr( LOC_cLine, 2 ) == ".T.", .T., .F. )
      ElseIf US_Upper( US_Word( LOC_cLine, 1 ) ) == 'EDITSUSPENDCONTROL'
             bSuspendControlEdit := if( US_WordSubStr( LOC_cLine, 2 ) == ".T.", .T., .F. )
      ElseIf US_Upper( US_Word( LOC_cLine, 1 ) ) == 'NOFMGEXTENSION'
             bNoFMGextension := if( US_WordSubStr( LOC_cLine, 2 ) == ".T.", .T., .F. )
      ElseIf US_Upper( US_Word( LOC_cLine, 1 ) ) == 'FORMTOOLOOHGIDE'
             Gbl_Text_OOHGIDE := US_WordSubStr( LOC_cLine, 2 )
      ElseIf US_Upper( US_Word( LOC_cLine, 1 ) ) == 'FORMTOOLHMI'
             Gbl_Text_OOHGIDE := US_WordSubStr( LOC_cLine, 2 )
      ElseIf US_Upper( US_Word( LOC_cLine, 1 ) ) == 'FORMTOOLHMG_IDE'
             Gbl_Text_HMG_IDE := US_WordSubStr( LOC_cLine, 2 )
      ElseIf US_Upper( US_Word( LOC_cLine, 1 ) ) == 'FORMTOOLHMGSIDE'
             Gbl_Text_HMGSIDE := US_WordSubStr( LOC_cLine, 2 )
      ElseIf US_Upper( US_Word( LOC_cLine, 1 ) ) == 'DBFTOOL'
             Gbl_Text_Dbf := US_WordSubStr( LOC_cLine, 2 )
      ElseIf US_Upper( US_Word( LOC_cLine, 1 ) ) == 'DBFCOMILLAS'
             Gbl_Comillas_DBF := if( US_WordSubStr( LOC_cLine, 2 ) == ".T.", '"', '' )
      ElseIf US_Upper( US_Word( LOC_cLine, 1 ) ) == 'LASTPROJECTFOLDER'
             cLastProjectFolder := US_WordSubStr( LOC_cLine, 2 )
// Do not change the order of the following ElseIf block because it's relevant
      ElseIf at( 'CCOMPILATORLIBS', US_Upper( LOC_cLine ) ) = 1
             if US_IsVar( 'Gbl_T_C_LIBS_' + substr( US_Upper( US_Word( LOC_cLine, 1 ) ), 16 ) )
                &('Gbl_T_C_LIBS_' + substr( US_Upper( US_Word( LOC_cLine, 1 ) ), 16 )) := US_WordSubStr( LOC_cLine, 2 )
             elseif US_IsVar( 'Gbl_T_C_LIBS_' + substr( US_Upper( US_Word( LOC_cLine, 1 ) ), 16 ) + DefineHarbour + Define32bits )
                &('Gbl_T_C_LIBS_' + substr( US_Upper( US_Word( LOC_cLine, 1 ) ), 16 ) + DefineHarbour + Define32bits) := US_WordSubStr( LOC_cLine, 2 )
             elseif US_IsVar( 'Gbl_T_C_LIBS_' + substr( US_Upper( US_Word( LOC_cLine, 1 ) ), 16 ) + DefineXHarbour + Define32bits )
                &('Gbl_T_C_LIBS_' + substr( US_Upper( US_Word( LOC_cLine, 1 ) ), 16 ) + DefineXHarbour + Define32bits) := US_WordSubStr( LOC_cLine, 2 )
             endif
      ElseIf at( 'CCOMPILATOR', US_Upper( LOC_cLine ) ) = 1
             if US_IsVar( 'Gbl_T_C_' + substr( US_Upper( US_Word( LOC_cLine, 1 ) ), 12 ) )
                &('Gbl_T_C_' + substr( US_Upper( US_Word( LOC_cLine, 1 ) ), 12 ) ) := US_WordSubStr( LOC_cLine, 2 )
             elseif US_IsVar( 'Gbl_T_C_' + substr( US_Upper( US_Word( LOC_cLine, 1 ) ), 12 ) + DefineHarbour + Define32bits )
                &('Gbl_T_C_' + substr( US_Upper( US_Word( LOC_cLine, 1 ) ), 12 ) + DefineHarbour + Define32bits) := US_WordSubStr( LOC_cLine, 2 )
             elseif US_IsVar( 'Gbl_T_C_' + substr( US_Upper( US_Word( LOC_cLine, 1 ) ), 12 ) + DefineXHarbour + Define32bits )
                &('Gbl_T_C_' + substr( US_Upper( US_Word( LOC_cLine, 1 ) ), 12 ) + DefineXHarbour + Define32bits) := US_WordSubStr( LOC_cLine, 2 )
             endif
      ElseIf at( 'MINIGUIFOLDERLIBS', US_Upper( LOC_cLine ) ) = 1
             if US_IsVar( 'Gbl_T_M_LIBS_' + substr( US_Upper( US_Word( LOC_cLine, 1 ) ), 18 ) )
                &('Gbl_T_M_LIBS_' + substr( US_Upper( US_Word( LOC_cLine, 1 ) ), 18 )) := US_WordSubStr( LOC_cLine, 2 )
             elseif US_IsVar( 'Gbl_T_M_LIBS_' + substr( US_Upper( US_Word( LOC_cLine, 1 ) ), 18 ) + DefineHarbour + Define32bits )
                &('Gbl_T_M_LIBS_' + substr( US_Upper( US_Word( LOC_cLine, 1 ) ), 18 ) + DefineHarbour + Define32bits) := US_WordSubStr( LOC_cLine, 2 )
             elseif US_IsVar( 'Gbl_T_M_LIBS_' + substr( US_Upper( US_Word( LOC_cLine, 1 ) ), 18 ) + DefineXHarbour + Define32bits )
                &('Gbl_T_M_LIBS_' + substr( US_Upper( US_Word( LOC_cLine, 1 ) ), 18 ) + DefineXHarbour + Define32bits) := US_WordSubStr( LOC_cLine, 2 )
             endif
      ElseIf at( 'MINIGUIFOLDER', US_Upper( LOC_cLine ) ) = 1
             if US_IsVar( 'Gbl_T_M_' + substr( US_Upper( US_Word( LOC_cLine, 1 ) ), 14 ) )
                &('Gbl_T_M_' + substr( US_Upper( US_Word( LOC_cLine, 1 ) ), 14 ) ) := US_WordSubStr( LOC_cLine, 2 )
             elseif US_IsVar( 'Gbl_T_M_' + substr( US_Upper( US_Word( LOC_cLine, 1 ) ), 14 ) + DefineHarbour + Define32bits )
                &('Gbl_T_M_' + substr( US_Upper( US_Word( LOC_cLine, 1 ) ), 14 ) + DefineHarbour + Define32bits) := US_WordSubStr( LOC_cLine, 2 )
             elseif US_IsVar( 'Gbl_T_M_' + substr( US_Upper( US_Word( LOC_cLine, 1 ) ), 14 ) + DefineXHarbour + Define32bits )
                &('Gbl_T_M_' + substr( US_Upper( US_Word( LOC_cLine, 1 ) ), 14 ) + DefineXHarbour + Define32bits) := US_WordSubStr( LOC_cLine, 2 )
             endif
      ElseIf at( 'HARBOURFOLDERLIBS', US_Upper( LOC_cLine ) ) = 1
             if US_IsVar( 'Gbl_T_P_LIBS_' + substr( US_Upper( US_Word( LOC_cLine, 1 ) ), 18 ) )
                &('Gbl_T_P_LIBS_' + substr( US_Upper( US_Word( LOC_cLine, 1 ) ), 18 ) ) := US_WordSubStr( LOC_cLine, 2 )
             elseif US_IsVar( 'Gbl_T_P_LIBS_' + substr( US_Upper( US_Word( LOC_cLine, 1 ) ), 18 ) + DefineHarbour + Define32bits )
                &('Gbl_T_P_LIBS_' + substr( US_Upper( US_Word( LOC_cLine, 1 ) ), 18 ) + DefineHarbour + Define32bits) := US_WordSubStr( LOC_cLine, 2 )
             endif
      ElseIf at( 'HARBOURFOLDER', US_Upper( LOC_cLine ) ) = 1
             if US_IsVar( 'Gbl_T_P_' + substr( US_Upper( US_Word( LOC_cLine, 1 ) ), 14 ) )
                &('Gbl_T_P_' + substr( US_Upper( US_Word( LOC_cLine, 1 ) ), 14 ) ) := US_WordSubStr( LOC_cLine, 2 )
             elseif US_IsVar( 'Gbl_T_P_' + substr( US_Upper( US_Word( LOC_cLine, 1 ) ), 14 ) + DefineHarbour + Define32bits )
                &('Gbl_T_P_' + substr( US_Upper( US_Word( LOC_cLine, 1 ) ), 14 ) + DefineHarbour + Define32bits) := US_WordSubStr( LOC_cLine, 2 )
             endif
      ElseIf at( 'XHARBOURFOLDERLIBS', US_Upper( LOC_cLine ) ) = 1
             if US_IsVar( 'Gbl_T_P_LIBS_' + substr( US_Upper( US_Word( LOC_cLine, 1 ) ), 19 ) )
                &('Gbl_T_P_LIBS_' + substr( US_Upper( US_Word( LOC_cLine, 1 ) ), 19 ) ) := US_WordSubStr( LOC_cLine, 2 )
             elseif US_IsVar( 'Gbl_T_P_LIBS_' + substr( US_Upper( US_Word( LOC_cLine, 1 ) ), 19 ) + DefineXHarbour + Define32bits )
                &('Gbl_T_P_LIBS_' + substr( US_Upper( US_Word( LOC_cLine, 1 ) ), 19 ) + DefineXHarbour + Define32bits) := US_WordSubStr( LOC_cLine, 2 )
             endif
      ElseIf at( 'XHARBOURFOLDER', US_Upper( LOC_cLine ) ) = 1
             if US_IsVar( 'Gbl_T_P_' + substr( US_Upper( US_Word( LOC_cLine, 1 ) ), 15 ) )
                &('Gbl_T_P_' + substr( US_Upper( US_Word( LOC_cLine, 1 ) ), 15 ) ) := US_WordSubStr( LOC_cLine, 2 )
             elseif US_IsVar( 'Gbl_T_P_' + substr( US_Upper( US_Word( LOC_cLine, 1 ) ), 15 ) + DefineXHarbour + Define32bits )
                &('Gbl_T_P_' + substr( US_Upper( US_Word( LOC_cLine, 1 ) ), 15 ) + DefineXHarbour + Define32bits) := US_WordSubStr( LOC_cLine, 2 )
             endif
      ElseIf at( 'MINIGUILIBNAME', US_Upper( LOC_cLine ) ) = 1
             if US_IsVar( 'Gbl_T_N_' + substr( US_Upper( US_Word( LOC_cLine, 1 ) ), 15 ) )
                &('Gbl_T_N_' + substr( US_Upper( US_Word( LOC_cLine, 1 ) ), 15 )) := US_WordSubStr( LOC_cLine, 2 )
             endif
      ElseIf at( 'GTGUILIBNAME', US_Upper( LOC_cLine ) ) = 1
             if US_IsVar( 'Gbl_T_G_' + substr( US_Upper( US_Word( LOC_cLine, 1 ) ), 15 ) )
                &('Gbl_T_G_' + substr( US_Upper( US_Word( LOC_cLine, 1 ) ), 15 )) := US_WordSubStr( LOC_cLine, 2 )
             endif
      ElseIf US_Upper ( US_Word( LOC_cLine, 1 ) ) == 'SEARCH'
             aadd( vLastSearch, US_WordSubStr( LOC_cLine, 2 ) )
      ElseIf US_Upper ( US_Word( LOC_cLine, 1 ) ) == 'LASTOPEN'
             aadd( vLastOpen, US_WordSubStr( LOC_cLine, 2 ) )
      ELSEIF SubStr( US_Word( US_Upper( LOC_cLine ), 1 ), 1, 11 ) == 'DEFAULTLIBS'
         IF US_IsVar( 'Gbl_DEF_LIBS_' + SubStr( US_Upper( US_Word( LOC_cLine, 1 ) ), 12 ) )
            aData := { US_Word( LOC_cLine, 2 ), "B", "B", "B" }
            cData := Left( US_Upper( US_Word( LOC_cLine, 3 ) ) + "BBB", 3 )
            cType := SubStr( cData, 1, 1 )
            IF cType $ "CG"
               aData[2] := cType
            ENDIF
            cType := SubStr( cData, 2, 1 )
            IF cType $ "MS"
               aData[3] := cType
            ENDIF
            cType := SubStr( cData, 3, 1 )
            IF cType $ "YN"
               aData[4] := cType
            ENDIF
            AAdd( &('Gbl_DEF_LIBS_' + SubStr( US_Upper( US_Word( LOC_cLine, 1 ) ), 12 )), aData )
         ENDIF
#ifdef QPM_HOTRECOVERY
      ElseIf US_Upper( US_Word( LOC_cLine, 1 ) ) == 'HOTVERSIONS'
             HR_nVersionsSet := Val( US_WordSubStr( LOC_cLine, 2 ) )
             if HR_nVersionsSet < HR_nVersionsMinimun
                HR_nVersionsSet := HR_nVersionsMinimun
             endif
#endif
      EndIf
   Next i

   If Empty( Gbl_Text_Editor )
      Gbl_Text_Editor := GetWindowsFolder() + DEF_SLASH + 'system32' + DEF_SLASH + 'NOTEPAD.EXE'
   EndIf

   QPM_InitLibrariesForFlavor( GetSuffix() )
   QPM_SetDefaultNameOfMiniguiAndGtguiLibs()

RETURN .T.

FUNCTION SaveEnvironment( lDefaultFile )
   LOCAL c := '', i, j, TmpName, aLibs

   c := c + 'VERSION '            + QPM_VERSION_NUMBER + hb_osNewLine()
   c := c + 'PROGRAMEDITOR'       + RTrim( " " + Gbl_Text_Editor ) + hb_osNewLine()
   c := c + 'EDITLONGNAME '       + US_VarToStr( bEditorLongName ) + hb_osNewLine()
   c := c + 'EDITSUSPENDCONTROL ' + US_VarToStr( bSuspendControlEdit ) + hb_osNewLine()
   c := c + 'NOFMGEXTENSION '     + US_VarToStr( bNoFMGextension ) + hb_osNewLine()
   c := c + 'FORMTOOLHMG_IDE'     + RTrim( " " + Gbl_Text_HMG_IDE ) + hb_osNewLine()
   c := c + 'FORMTOOLHMGSIDE'     + RTrim( " " + Gbl_Text_HMGSIDE )  + hb_osNewLine()
   c := c + 'FORMTOOLOOHGIDE'     + RTrim( " " + Gbl_Text_OOHGIDE ) + hb_osNewLine()
   c := c + 'DBFTOOL'             + RTrim( " " + Gbl_Text_Dbf ) + hb_osNewLine()
   c := c + 'DBFCOMILLAS '        + iif( Gbl_Comillas_DBF == DBLQT, ".T.", ".F." ) + hb_osNewLine()
   c := c + 'LASTPROJECTFOLDER'   + RTrim( " " + cLastProjectFolder ) + hb_osNewLine()

   /* MiniGui Oficial 1 with BCC */
   c := c + 'CCOMPILATOR'         + DefineMiniGui1  + DefineBorland + DefineHarbour  + Define32bits + RTrim( ' ' + &("Gbl_T_C_"      + DefineMiniGui1 + DefineBorland + DefineHarbour  + Define32bits) ) + hb_osNewLine()
   c := c + 'MINIGUIFOLDER'       + DefineMiniGui1  + DefineBorland + DefineHarbour  + Define32bits + RTrim( ' ' + &("Gbl_T_M_"      + DefineMiniGui1 + DefineBorland + DefineHarbour  + Define32bits) ) + hb_osNewLine()
   c := c + 'HARBOURFOLDER'       + DefineMiniGui1  + DefineBorland + DefineHarbour  + Define32bits + RTrim( ' ' + &("Gbl_T_P_"      + DefineMiniGui1 + DefineBorland + DefineHarbour  + Define32bits) ) + hb_osNewLine()
   c := c + 'CCOMPILATORLIBS'     + DefineMiniGui1  + DefineBorland + DefineHarbour  + Define32bits + RTrim( ' ' + &("Gbl_T_C_LIBS_" + DefineMiniGui1 + DefineBorland + DefineHarbour  + Define32bits) ) + hb_osNewLine()
   c := c + 'MINIGUIFOLDERLIBS'   + DefineMiniGui1  + DefineBorland + DefineHarbour  + Define32bits + RTrim( ' ' + &("Gbl_T_M_LIBS_" + DefineMiniGui1 + DefineBorland + DefineHarbour  + Define32bits) ) + hb_osNewLine()
   c := c + 'HARBOURFOLDERLIBS'   + DefineMiniGui1  + DefineBorland + DefineHarbour  + Define32bits + RTrim( ' ' + &("Gbl_T_P_LIBS_" + DefineMiniGui1 + DefineBorland + DefineHarbour  + Define32bits) ) + hb_osNewLine()
   c := c + 'MINIGUILIBNAME'      + DefineMiniGui1  + DefineBorland + DefineHarbour  + Define32bits + RTrim( ' ' + &("Gbl_T_N_"      + DefineMiniGui1 + DefineBorland + DefineHarbour  + Define32bits) ) + hb_osNewLine()
   c := c + 'GTGUILIBNAME'        + DefineMiniGui1  + DefineBorland + DefineHarbour  + Define32bits + RTrim( ' ' + &("Gbl_T_G_"      + DefineMiniGui1 + DefineBorland + DefineHarbour  + Define32bits) ) + hb_osNewLine()

   c := c + 'CCOMPILATOR'         + DefineMiniGui1  + DefineBorland + DefineXHarbour + Define32bits + RTrim( ' ' + &("Gbl_T_C_"      + DefineMiniGui1 + DefineBorland + DefineXHarbour + Define32bits) ) + hb_osNewLine()
   c := c + 'MINIGUIFOLDER'       + DefineMiniGui1  + DefineBorland + DefineXHarbour + Define32bits + RTrim( ' ' + &("Gbl_T_M_"      + DefineMiniGui1 + DefineBorland + DefineXHarbour + Define32bits) ) + hb_osNewLine()
   c := c + 'XHARBOURFOLDER'      + DefineMiniGui1  + DefineBorland + DefineXHarbour + Define32bits + RTrim( ' ' + &("Gbl_T_P_"      + DefineMiniGui1 + DefineBorland + DefineXHarbour + Define32bits) ) + hb_osNewLine()
   c := c + 'CCOMPILATORLIBS'     + DefineMiniGui1  + DefineBorland + DefineXHarbour + Define32bits + RTrim( ' ' + &("Gbl_T_C_LIBS_" + DefineMiniGui1 + DefineBorland + DefineXHarbour + Define32bits) ) + hb_osNewLine()
   c := c + 'MINIGUIFOLDERLIBS'   + DefineMiniGui1  + DefineBorland + DefineXHarbour + Define32bits + RTrim( ' ' + &("Gbl_T_M_LIBS_" + DefineMiniGui1 + DefineBorland + DefineXHarbour + Define32bits) ) + hb_osNewLine()
   c := c + 'XHARBOURFOLDERLIBS'  + DefineMiniGui1  + DefineBorland + DefineXHarbour + Define32bits + RTrim( ' ' + &("Gbl_T_P_LIBS_" + DefineMiniGui1 + DefineBorland + DefineXHarbour + Define32bits) ) + hb_osNewLine()
   c := c + 'MINIGUILIBNAME'      + DefineMiniGui1  + DefineBorland + DefineXHarbour + Define32bits + RTrim( ' ' + &("Gbl_T_N_"      + DefineMiniGui1 + DefineBorland + DefineXHarbour + Define32bits) ) + hb_osNewLine()
   c := c + 'GTGUILIBNAME'        + DefineMiniGui1  + DefineBorland + DefineXHarbour + Define32bits + RTrim( ' ' + &("Gbl_T_G_"      + DefineMiniGui1 + DefineBorland + DefineXHarbour + Define32bits) ) + hb_osNewLine()

   /* MiniGui Oficial 3 with MinGW */
   c := c + 'CCOMPILATOR'         + DefineMiniGui3  + DefineMinGW   + DefineHarbour  + Define32bits + RTrim( ' ' + &("Gbl_T_C_"      + DefineMiniGui3 + DefineMinGW   + DefineHarbour  + Define32bits) ) + hb_osNewLine()
   c := c + 'MINIGUIFOLDER'       + DefineMiniGui3  + DefineMinGW   + DefineHarbour  + Define32bits + RTrim( ' ' + &("Gbl_T_M_"      + DefineMiniGui3 + DefineMinGW   + DefineHarbour  + Define32bits) ) + hb_osNewLine()
   c := c + 'HARBOURFOLDER'       + DefineMiniGui3  + DefineMinGW   + DefineHarbour  + Define32bits + RTrim( ' ' + &("Gbl_T_P_"      + DefineMiniGui3 + DefineMinGW   + DefineHarbour  + Define32bits) ) + hb_osNewLine()
   c := c + 'CCOMPILATORLIBS'     + DefineMiniGui3  + DefineMinGW   + DefineHarbour  + Define32bits + RTrim( ' ' + &("Gbl_T_C_LIBS_" + DefineMiniGui3 + DefineMinGW   + DefineHarbour  + Define32bits) ) + hb_osNewLine()
   c := c + 'MINIGUIFOLDERLIBS'   + DefineMiniGui3  + DefineMinGW   + DefineHarbour  + Define32bits + RTrim( ' ' + &("Gbl_T_M_LIBS_" + DefineMiniGui3 + DefineMinGW   + DefineHarbour  + Define32bits) ) + hb_osNewLine()
   c := c + 'HARBOURFOLDERLIBS'   + DefineMiniGui3  + DefineMinGW   + DefineHarbour  + Define32bits + RTrim( ' ' + &("Gbl_T_P_LIBS_" + DefineMiniGui3 + DefineMinGW   + DefineHarbour  + Define32bits) ) + hb_osNewLine()
   c := c + 'MINIGUILIBNAME'      + DefineMiniGui3  + DefineMinGW   + DefineHarbour  + Define32bits + RTrim( ' ' + &("Gbl_T_N_"      + DefineMiniGui3 + DefineMinGW   + DefineHarbour  + Define32bits) ) + hb_osNewLine()
   c := c + 'GTGUILIBNAME'        + DefineMiniGui3  + DefineMinGW   + DefineHarbour  + Define32bits + RTrim( ' ' + &("Gbl_T_G_"      + DefineMiniGui3 + DefineMinGW   + DefineHarbour  + Define32bits) ) + hb_osNewLine()

   c := c + 'CCOMPILATOR'         + DefineMiniGui3  + DefineMinGW   + DefineHarbour  + Define64bits + RTrim( ' ' + &("Gbl_T_C_"      + DefineMiniGui3 + DefineMinGW   + DefineHarbour  + Define64bits) ) + hb_osNewLine()
   c := c + 'MINIGUIFOLDER'       + DefineMiniGui3  + DefineMinGW   + DefineHarbour  + Define64bits + RTrim( ' ' + &("Gbl_T_M_"      + DefineMiniGui3 + DefineMinGW   + DefineHarbour  + Define64bits) ) + hb_osNewLine()
   c := c + 'HARBOURFOLDER'       + DefineMiniGui3  + DefineMinGW   + DefineHarbour  + Define64bits + RTrim( ' ' + &("Gbl_T_P_"      + DefineMiniGui3 + DefineMinGW   + DefineHarbour  + Define64bits) ) + hb_osNewLine()
   c := c + 'CCOMPILATORLIBS'     + DefineMiniGui3  + DefineMinGW   + DefineHarbour  + Define64bits + RTrim( ' ' + &("Gbl_T_C_LIBS_" + DefineMiniGui3 + DefineMinGW   + DefineHarbour  + Define64bits) ) + hb_osNewLine()
   c := c + 'MINIGUIFOLDERLIBS'   + DefineMiniGui3  + DefineMinGW   + DefineHarbour  + Define64bits + RTrim( ' ' + &("Gbl_T_M_LIBS_" + DefineMiniGui3 + DefineMinGW   + DefineHarbour  + Define64bits) ) + hb_osNewLine()
   c := c + 'HARBOURFOLDERLIBS'   + DefineMiniGui3  + DefineMinGW   + DefineHarbour  + Define64bits + RTrim( ' ' + &("Gbl_T_P_LIBS_" + DefineMiniGui3 + DefineMinGW   + DefineHarbour  + Define64bits) ) + hb_osNewLine()
   c := c + 'MINIGUILIBNAME'      + DefineMiniGui3  + DefineMinGW   + DefineHarbour  + Define64bits + RTrim( ' ' + &("Gbl_T_N_"      + DefineMiniGui3 + DefineMinGW   + DefineHarbour  + Define64bits) ) + hb_osNewLine()
   c := c + 'GTGUILIBNAME'        + DefineMiniGui3  + DefineMinGW   + DefineHarbour  + Define64bits + RTrim( ' ' + &("Gbl_T_G_"      + DefineMiniGui3 + DefineMinGW   + DefineHarbour  + Define64bits) ) + hb_osNewLine()

   /* MiniGui Extended 1 with BCC */
   c := c + 'CCOMPILATOR'         + DefineExtended1 + DefineBorland + DefineHarbour  + Define32bits + RTrim( ' ' + &("Gbl_T_C_"      + DefineExtended1 + DefineBorland + DefineHarbour  + Define32bits) ) + hb_osNewLine()
   c := c + 'MINIGUIFOLDER'       + DefineExtended1 + DefineBorland + DefineHarbour  + Define32bits + RTrim( ' ' + &("Gbl_T_M_"      + DefineExtended1 + DefineBorland + DefineHarbour  + Define32bits) ) + hb_osNewLine()
   c := c + 'HARBOURFOLDER'       + DefineExtended1 + DefineBorland + DefineHarbour  + Define32bits + RTrim( ' ' + &("Gbl_T_P_"      + DefineExtended1 + DefineBorland + DefineHarbour  + Define32bits) ) + hb_osNewLine()
   c := c + 'CCOMPILATORLIBS'     + DefineExtended1 + DefineBorland + DefineHarbour  + Define32bits + RTrim( ' ' + &("Gbl_T_C_LIBS_" + DefineExtended1 + DefineBorland + DefineHarbour  + Define32bits) ) + hb_osNewLine()
   c := c + 'MINIGUIFOLDERLIBS'   + DefineExtended1 + DefineBorland + DefineHarbour  + Define32bits + RTrim( ' ' + &("Gbl_T_M_LIBS_" + DefineExtended1 + DefineBorland + DefineHarbour  + Define32bits) ) + hb_osNewLine()
   c := c + 'HARBOURFOLDERLIBS'   + DefineExtended1 + DefineBorland + DefineHarbour  + Define32bits + RTrim( ' ' + &("Gbl_T_P_LIBS_" + DefineExtended1 + DefineBorland + DefineHarbour  + Define32bits) ) + hb_osNewLine()
   c := c + 'MINIGUILIBNAME'      + DefineExtended1 + DefineBorland + DefineHarbour  + Define32bits + RTrim( ' ' + &("Gbl_T_N_"      + DefineExtended1 + DefineBorland + DefineHarbour  + Define32bits) ) + hb_osNewLine()
   c := c + 'GTGUILIBNAME'        + DefineExtended1 + DefineBorland + DefineHarbour  + Define32bits + RTrim( ' ' + &("Gbl_T_G_"      + DefineExtended1 + DefineBorland + DefineHarbour  + Define32bits) ) + hb_osNewLine()

   c := c + 'CCOMPILATOR'         + DefineExtended1 + DefineBorland + DefineXHarbour + Define32bits + RTrim( ' ' + &("Gbl_T_C_"      + DefineExtended1 + DefineBorland + DefineXHarbour + Define32bits) ) + hb_osNewLine()
   c := c + 'MINIGUIFOLDER'       + DefineExtended1 + DefineBorland + DefineXHarbour + Define32bits + RTrim( ' ' + &("Gbl_T_M_"      + DefineExtended1 + DefineBorland + DefineXHarbour + Define32bits) ) + hb_osNewLine()
   c := c + 'XHARBOURFOLDER'      + DefineExtended1 + DefineBorland + DefineXHarbour + Define32bits + RTrim( ' ' + &("Gbl_T_P_"      + DefineExtended1 + DefineBorland + DefineXHarbour + Define32bits) ) + hb_osNewLine()
   c := c + 'CCOMPILATORLIBS'     + DefineExtended1 + DefineBorland + DefineXHarbour + Define32bits + RTrim( ' ' + &("Gbl_T_C_LIBS_" + DefineExtended1 + DefineBorland + DefineXHarbour + Define32bits) ) + hb_osNewLine()
   c := c + 'MINIGUIFOLDERLIBS'   + DefineExtended1 + DefineBorland + DefineXHarbour + Define32bits + RTrim( ' ' + &("Gbl_T_M_LIBS_" + DefineExtended1 + DefineBorland + DefineXHarbour + Define32bits) ) + hb_osNewLine()
   c := c + 'XHARBOURFOLDERLIBS'  + DefineExtended1 + DefineBorland + DefineXHarbour + Define32bits + RTrim( ' ' + &("Gbl_T_P_LIBS_" + DefineExtended1 + DefineBorland + DefineXHarbour + Define32bits) ) + hb_osNewLine()
   c := c + 'MINIGUILIBNAME'      + DefineExtended1 + DefineBorland + DefineXHarbour + Define32bits + RTrim( ' ' + &("Gbl_T_N_"      + DefineExtended1 + DefineBorland + DefineXHarbour + Define32bits) ) + hb_osNewLine()
   c := c + 'GTGUILIBNAME'        + DefineExtended1 + DefineBorland + DefineXHarbour + Define32bits + RTrim( ' ' + &("Gbl_T_G_"      + DefineExtended1 + DefineBorland + DefineXHarbour + Define32bits) ) + hb_osNewLine()

   /* MiniGui Extended 1 with MinGW */
   c := c + 'CCOMPILATOR'         + DefineExtended1 + DefineMinGW   + DefineHarbour  + Define32bits + RTrim( ' ' + &("Gbl_T_C_"      + DefineExtended1 + DefineMinGW   + DefineHarbour  + Define32bits) ) + hb_osNewLine()
   c := c + 'MINIGUIFOLDER'       + DefineExtended1 + DefineMinGW   + DefineHarbour  + Define32bits + RTrim( ' ' + &("Gbl_T_M_"      + DefineExtended1 + DefineMinGW   + DefineHarbour  + Define32bits) ) + hb_osNewLine()
   c := c + 'HARBOURFOLDER'       + DefineExtended1 + DefineMinGW   + DefineHarbour  + Define32bits + RTrim( ' ' + &("Gbl_T_P_"      + DefineExtended1 + DefineMinGW   + DefineHarbour  + Define32bits) ) + hb_osNewLine()
   c := c + 'CCOMPILATORLIBS'     + DefineExtended1 + DefineMinGW   + DefineHarbour  + Define32bits + RTrim( ' ' + &("Gbl_T_C_LIBS_" + DefineExtended1 + DefineMinGW   + DefineHarbour  + Define32bits) ) + hb_osNewLine()
   c := c + 'MINIGUIFOLDERLIBS'   + DefineExtended1 + DefineMinGW   + DefineHarbour  + Define32bits + RTrim( ' ' + &("Gbl_T_M_LIBS_" + DefineExtended1 + DefineMinGW   + DefineHarbour  + Define32bits) ) + hb_osNewLine()
   c := c + 'HARBOURFOLDERLIBS'   + DefineExtended1 + DefineMinGW   + DefineHarbour  + Define32bits + RTrim( ' ' + &("Gbl_T_P_LIBS_" + DefineExtended1 + DefineMinGW   + DefineHarbour  + Define32bits) ) + hb_osNewLine()
   c := c + 'MINIGUILIBNAME'      + DefineExtended1 + DefineMinGW   + DefineHarbour  + Define32bits + RTrim( ' ' + &("Gbl_T_N_"      + DefineExtended1 + DefineMinGW   + DefineHarbour  + Define32bits) ) + hb_osNewLine()
   c := c + 'GTGUILIBNAME'        + DefineExtended1 + DefineMinGW   + DefineHarbour  + Define32bits + RTrim( ' ' + &("Gbl_T_G_"      + DefineExtended1 + DefineMinGW   + DefineHarbour  + Define32bits) ) + hb_osNewLine()

   c := c + 'CCOMPILATOR'         + DefineExtended1 + DefineMinGW   + DefineXHarbour + Define32bits + RTrim( ' ' + &("Gbl_T_C_"      + DefineExtended1 + DefineMinGW   + DefineXHarbour + Define32bits) ) + hb_osNewLine()
   c := c + 'MINIGUIFOLDER'       + DefineExtended1 + DefineMinGW   + DefineXHarbour + Define32bits + RTrim( ' ' + &("Gbl_T_M_"      + DefineExtended1 + DefineMinGW   + DefineXHarbour + Define32bits) ) + hb_osNewLine()
   c := c + 'XHARBOURFOLDER'      + DefineExtended1 + DefineMinGW   + DefineXHarbour + Define32bits + RTrim( ' ' + &("Gbl_T_P_"      + DefineExtended1 + DefineMinGW   + DefineXHarbour + Define32bits) ) + hb_osNewLine()
   c := c + 'CCOMPILATORLIBS'     + DefineExtended1 + DefineMinGW   + DefineXHarbour + Define32bits + RTrim( ' ' + &("Gbl_T_C_LIBS_" + DefineExtended1 + DefineMinGW   + DefineXHarbour + Define32bits) ) + hb_osNewLine()
   c := c + 'MINIGUIFOLDERLIBS'   + DefineExtended1 + DefineMinGW   + DefineXHarbour + Define32bits + RTrim( ' ' + &("Gbl_T_M_LIBS_" + DefineExtended1 + DefineMinGW   + DefineXHarbour + Define32bits) ) + hb_osNewLine()
   c := c + 'XHARBOURFOLDERLIBS'  + DefineExtended1 + DefineMinGW   + DefineXHarbour + Define32bits + RTrim( ' ' + &("Gbl_T_P_LIBS_" + DefineExtended1 + DefineMinGW   + DefineXHarbour + Define32bits) ) + hb_osNewLine()
   c := c + 'MINIGUILIBNAME'      + DefineExtended1 + DefineMinGW   + DefineXHarbour + Define32bits + RTrim( ' ' + &("Gbl_T_N_"      + DefineExtended1 + DefineMinGW   + DefineXHarbour + Define32bits) ) + hb_osNewLine()
   c := c + 'GTGUILIBNAME'        + DefineExtended1 + DefineMinGW   + DefineXHarbour + Define32bits + RTrim( ' ' + &("Gbl_T_G_"      + DefineExtended1 + DefineMinGW   + DefineXHarbour + Define32bits) ) + hb_osNewLine()

   c := c + 'CCOMPILATOR'         + DefineExtended1 + DefineMinGW   + DefineHarbour  + Define64bits + RTrim( ' ' + &("Gbl_T_C_"      + DefineExtended1 + DefineMinGW   + DefineHarbour  + Define64bits) ) + hb_osNewLine()
   c := c + 'MINIGUIFOLDER'       + DefineExtended1 + DefineMinGW   + DefineHarbour  + Define64bits + RTrim( ' ' + &("Gbl_T_M_"      + DefineExtended1 + DefineMinGW   + DefineHarbour  + Define64bits) ) + hb_osNewLine()
   c := c + 'HARBOURFOLDER'       + DefineExtended1 + DefineMinGW   + DefineHarbour  + Define64bits + RTrim( ' ' + &("Gbl_T_P_"      + DefineExtended1 + DefineMinGW   + DefineHarbour  + Define64bits) ) + hb_osNewLine()
   c := c + 'CCOMPILATORLIBS'     + DefineExtended1 + DefineMinGW   + DefineHarbour  + Define64bits + RTrim( ' ' + &("Gbl_T_C_LIBS_" + DefineExtended1 + DefineMinGW   + DefineHarbour  + Define64bits) ) + hb_osNewLine()
   c := c + 'MINIGUIFOLDERLIBS'   + DefineExtended1 + DefineMinGW   + DefineHarbour  + Define64bits + RTrim( ' ' + &("Gbl_T_M_LIBS_" + DefineExtended1 + DefineMinGW   + DefineHarbour  + Define64bits) ) + hb_osNewLine()
   c := c + 'HARBOURFOLDERLIBS'   + DefineExtended1 + DefineMinGW   + DefineHarbour  + Define64bits + RTrim( ' ' + &("Gbl_T_P_LIBS_" + DefineExtended1 + DefineMinGW   + DefineHarbour  + Define64bits) ) + hb_osNewLine()
   c := c + 'MINIGUILIBNAME'      + DefineExtended1 + DefineMinGW   + DefineHarbour  + Define64bits + RTrim( ' ' + &("Gbl_T_N_"      + DefineExtended1 + DefineMinGW   + DefineHarbour  + Define64bits) ) + hb_osNewLine()
   c := c + 'GTGUILIBNAME'        + DefineExtended1 + DefineMinGW   + DefineHarbour  + Define64bits + RTrim( ' ' + &("Gbl_T_G_"      + DefineExtended1 + DefineMinGW   + DefineHarbour  + Define64bits) ) + hb_osNewLine()

   c := c + 'CCOMPILATOR'         + DefineExtended1 + DefineMinGW   + DefineXHarbour + Define64bits + RTrim( ' ' + &("Gbl_T_C_"      + DefineExtended1 + DefineMinGW   + DefineXHarbour + Define64bits) ) + hb_osNewLine()
   c := c + 'MINIGUIFOLDER'       + DefineExtended1 + DefineMinGW   + DefineXHarbour + Define64bits + RTrim( ' ' + &("Gbl_T_M_"      + DefineExtended1 + DefineMinGW   + DefineXHarbour + Define64bits) ) + hb_osNewLine()
   c := c + 'XHARBOURFOLDER'      + DefineExtended1 + DefineMinGW   + DefineXHarbour + Define64bits + RTrim( ' ' + &("Gbl_T_P_"      + DefineExtended1 + DefineMinGW   + DefineXHarbour + Define64bits) ) + hb_osNewLine()
   c := c + 'CCOMPILATORLIBS'     + DefineExtended1 + DefineMinGW   + DefineXHarbour + Define64bits + RTrim( ' ' + &("Gbl_T_C_LIBS_" + DefineExtended1 + DefineMinGW   + DefineXHarbour + Define64bits) ) + hb_osNewLine()
   c := c + 'MINIGUIFOLDERLIBS'   + DefineExtended1 + DefineMinGW   + DefineXHarbour + Define64bits + RTrim( ' ' + &("Gbl_T_M_LIBS_" + DefineExtended1 + DefineMinGW   + DefineXHarbour + Define64bits) ) + hb_osNewLine()
   c := c + 'XHARBOURFOLDERLIBS'  + DefineExtended1 + DefineMinGW   + DefineXHarbour + Define64bits + RTrim( ' ' + &("Gbl_T_P_LIBS_" + DefineExtended1 + DefineMinGW   + DefineXHarbour + Define64bits) ) + hb_osNewLine()
   c := c + 'MINIGUILIBNAME'      + DefineExtended1 + DefineMinGW   + DefineXHarbour + Define64bits + RTrim( ' ' + &("Gbl_T_N_"      + DefineExtended1 + DefineMinGW   + DefineXHarbour + Define64bits) ) + hb_osNewLine()
   c := c + 'GTGUILIBNAME'        + DefineExtended1 + DefineMinGW   + DefineXHarbour + Define64bits + RTrim( ' ' + &("Gbl_T_G_"      + DefineExtended1 + DefineMinGW   + DefineXHarbour + Define64bits) ) + hb_osNewLine()

   /* MiniGui Extended 1 with Pelles */
   c := c + 'CCOMPILATOR'         + DefineExtended1 + DefinePelles  + DefineHarbour  + Define32bits + RTrim( ' ' + &("Gbl_T_C_"      + DefineExtended1 + DefinePelles  + DefineHarbour  + Define32bits) ) + hb_osNewLine()
   c := c + 'MINIGUIFOLDER'       + DefineExtended1 + DefinePelles  + DefineHarbour  + Define32bits + RTrim( ' ' + &("Gbl_T_M_"      + DefineExtended1 + DefinePelles  + DefineHarbour  + Define32bits) ) + hb_osNewLine()
   c := c + 'HARBOURFOLDER'       + DefineExtended1 + DefinePelles  + DefineHarbour  + Define32bits + RTrim( ' ' + &("Gbl_T_P_"      + DefineExtended1 + DefinePelles  + DefineHarbour  + Define32bits) ) + hb_osNewLine()
   c := c + 'CCOMPILATORLIBS'     + DefineExtended1 + DefinePelles  + DefineHarbour  + Define32bits + RTrim( ' ' + &("Gbl_T_C_LIBS_" + DefineExtended1 + DefinePelles  + DefineHarbour  + Define32bits) ) + hb_osNewLine()
   c := c + 'MINIGUIFOLDERLIBS'   + DefineExtended1 + DefinePelles  + DefineHarbour  + Define32bits + RTrim( ' ' + &("Gbl_T_M_LIBS_" + DefineExtended1 + DefinePelles  + DefineHarbour  + Define32bits) ) + hb_osNewLine()
   c := c + 'HARBOURFOLDERLIBS'   + DefineExtended1 + DefinePelles  + DefineHarbour  + Define32bits + RTrim( ' ' + &("Gbl_T_P_LIBS_" + DefineExtended1 + DefinePelles  + DefineHarbour  + Define32bits) ) + hb_osNewLine()
   c := c + 'MINIGUILIBNAME'      + DefineExtended1 + DefinePelles  + DefineHarbour  + Define32bits + RTrim( ' ' + &("Gbl_T_N_"      + DefineExtended1 + DefinePelles  + DefineHarbour  + Define32bits) ) + hb_osNewLine()
   c := c + 'GTGUILIBNAME'        + DefineExtended1 + DefinePelles  + DefineHarbour  + Define32bits + RTrim( ' ' + &("Gbl_T_G_"      + DefineExtended1 + DefinePelles  + DefineHarbour  + Define32bits) ) + hb_osNewLine()

   c := c + 'CCOMPILATOR'         + DefineExtended1 + DefinePelles  + DefineXHarbour + Define32bits + RTrim( ' ' + &("Gbl_T_C_"      + DefineExtended1 + DefinePelles  + DefineXHarbour + Define32bits) ) + hb_osNewLine()
   c := c + 'MINIGUIFOLDER'       + DefineExtended1 + DefinePelles  + DefineXHarbour + Define32bits + RTrim( ' ' + &("Gbl_T_M_"      + DefineExtended1 + DefinePelles  + DefineXHarbour + Define32bits) ) + hb_osNewLine()
   c := c + 'XHARBOURFOLDER'      + DefineExtended1 + DefinePelles  + DefineXHarbour + Define32bits + RTrim( ' ' + &("Gbl_T_P_"      + DefineExtended1 + DefinePelles  + DefineXHarbour + Define32bits) ) + hb_osNewLine()
   c := c + 'CCOMPILATORLIBS'     + DefineExtended1 + DefinePelles  + DefineXHarbour + Define32bits + RTrim( ' ' + &("Gbl_T_C_LIBS_" + DefineExtended1 + DefinePelles  + DefineXHarbour + Define32bits) ) + hb_osNewLine()
   c := c + 'MINIGUIFOLDERLIBS'   + DefineExtended1 + DefinePelles  + DefineXHarbour + Define32bits + RTrim( ' ' + &("Gbl_T_M_LIBS_" + DefineExtended1 + DefinePelles  + DefineXHarbour + Define32bits) ) + hb_osNewLine()
   c := c + 'XHARBOURFOLDERLIBS'  + DefineExtended1 + DefinePelles  + DefineXHarbour + Define32bits + RTrim( ' ' + &("Gbl_T_P_LIBS_" + DefineExtended1 + DefinePelles  + DefineXHarbour + Define32bits) ) + hb_osNewLine()
   c := c + 'MINIGUILIBNAME'      + DefineExtended1 + DefinePelles  + DefineXHarbour + Define32bits + RTrim( ' ' + &("Gbl_T_N_"      + DefineExtended1 + DefinePelles  + DefineXHarbour + Define32bits) ) + hb_osNewLine()
   c := c + 'GTGUILIBNAME'        + DefineExtended1 + DefinePelles  + DefineXHarbour + Define32bits + RTrim( ' ' + &("Gbl_T_G_"      + DefineExtended1 + DefinePelles  + DefineXHarbour + Define32bits) ) + hb_osNewLine()

   c := c + 'CCOMPILATOR'         + DefineExtended1 + DefinePelles  + DefineHarbour  + Define64bits + RTrim( ' ' + &("Gbl_T_C_"      + DefineExtended1 + DefinePelles  + DefineHarbour  + Define64bits) ) + hb_osNewLine()
   c := c + 'MINIGUIFOLDER'       + DefineExtended1 + DefinePelles  + DefineHarbour  + Define64bits + RTrim( ' ' + &("Gbl_T_M_"      + DefineExtended1 + DefinePelles  + DefineHarbour  + Define64bits) ) + hb_osNewLine()
   c := c + 'HARBOURFOLDER'       + DefineExtended1 + DefinePelles  + DefineHarbour  + Define64bits + RTrim( ' ' + &("Gbl_T_P_"      + DefineExtended1 + DefinePelles  + DefineHarbour  + Define64bits) ) + hb_osNewLine()
   c := c + 'CCOMPILATORLIBS'     + DefineExtended1 + DefinePelles  + DefineHarbour  + Define64bits + RTrim( ' ' + &("Gbl_T_C_LIBS_" + DefineExtended1 + DefinePelles  + DefineHarbour  + Define64bits) ) + hb_osNewLine()
   c := c + 'MINIGUIFOLDERLIBS'   + DefineExtended1 + DefinePelles  + DefineHarbour  + Define64bits + RTrim( ' ' + &("Gbl_T_M_LIBS_" + DefineExtended1 + DefinePelles  + DefineHarbour  + Define64bits) ) + hb_osNewLine()
   c := c + 'HARBOURFOLDERLIBS'   + DefineExtended1 + DefinePelles  + DefineHarbour  + Define64bits + RTrim( ' ' + &("Gbl_T_P_LIBS_" + DefineExtended1 + DefinePelles  + DefineHarbour  + Define64bits) ) + hb_osNewLine()
   c := c + 'MINIGUILIBNAME'      + DefineExtended1 + DefinePelles  + DefineHarbour  + Define64bits + RTrim( ' ' + &("Gbl_T_N_"      + DefineExtended1 + DefinePelles  + DefineHarbour  + Define64bits) ) + hb_osNewLine()
   c := c + 'GTGUILIBNAME'        + DefineExtended1 + DefinePelles  + DefineHarbour  + Define64bits + RTrim( ' ' + &("Gbl_T_G_"      + DefineExtended1 + DefinePelles  + DefineHarbour  + Define64bits) ) + hb_osNewLine()

   c := c + 'CCOMPILATOR'         + DefineExtended1 + DefinePelles  + DefineXHarbour + Define64bits + RTrim( ' ' + &("Gbl_T_C_"      + DefineExtended1 + DefinePelles  + DefineXHarbour + Define64bits) ) + hb_osNewLine()
   c := c + 'MINIGUIFOLDER'       + DefineExtended1 + DefinePelles  + DefineXHarbour + Define64bits + RTrim( ' ' + &("Gbl_T_M_"      + DefineExtended1 + DefinePelles  + DefineXHarbour + Define64bits) ) + hb_osNewLine()
   c := c + 'XHARBOURFOLDER'      + DefineExtended1 + DefinePelles  + DefineXHarbour + Define64bits + RTrim( ' ' + &("Gbl_T_P_"      + DefineExtended1 + DefinePelles  + DefineXHarbour + Define64bits) ) + hb_osNewLine()
   c := c + 'CCOMPILATORLIBS'     + DefineExtended1 + DefinePelles  + DefineXHarbour + Define64bits + RTrim( ' ' + &("Gbl_T_C_LIBS_" + DefineExtended1 + DefinePelles  + DefineXHarbour + Define64bits) ) + hb_osNewLine()
   c := c + 'MINIGUIFOLDERLIBS'   + DefineExtended1 + DefinePelles  + DefineXHarbour + Define64bits + RTrim( ' ' + &("Gbl_T_M_LIBS_" + DefineExtended1 + DefinePelles  + DefineXHarbour + Define64bits) ) + hb_osNewLine()
   c := c + 'XHARBOURFOLDERLIBS'  + DefineExtended1 + DefinePelles  + DefineXHarbour + Define64bits + RTrim( ' ' + &("Gbl_T_P_LIBS_" + DefineExtended1 + DefinePelles  + DefineXHarbour + Define64bits) ) + hb_osNewLine()
   c := c + 'MINIGUILIBNAME'      + DefineExtended1 + DefinePelles  + DefineXHarbour + Define64bits + RTrim( ' ' + &("Gbl_T_N_"      + DefineExtended1 + DefinePelles  + DefineXHarbour + Define64bits) ) + hb_osNewLine()
   c := c + 'GTGUILIBNAME'        + DefineExtended1 + DefinePelles  + DefineXHarbour + Define64bits + RTrim( ' ' + &("Gbl_T_G_"      + DefineExtended1 + DefinePelles  + DefineXHarbour + Define64bits) ) + hb_osNewLine()

   /* OOHG with BCC */
   c := c + 'CCOMPILATOR'         + DefineOohg3     + DefineBorland + DefineHarbour  + Define32bits + RTrim( ' ' + &("Gbl_T_C_"      + DefineOohg3     + DefineBorland + DefineHarbour  + Define32bits) ) + hb_osNewLine()
   c := c + 'MINIGUIFOLDER'       + DefineOohg3     + DefineBorland + DefineHarbour  + Define32bits + RTrim( ' ' + &("Gbl_T_M_"      + DefineOohg3     + DefineBorland + DefineHarbour  + Define32bits) ) + hb_osNewLine()
   c := c + 'HARBOURFOLDER'       + DefineOohg3     + DefineBorland + DefineHarbour  + Define32bits + RTrim( ' ' + &("Gbl_T_P_"      + DefineOohg3     + DefineBorland + DefineHarbour  + Define32bits) ) + hb_osNewLine()
   c := c + 'CCOMPILATORLIBS'     + DefineOohg3     + DefineBorland + DefineHarbour  + Define32bits + RTrim( ' ' + &("Gbl_T_C_LIBS_" + DefineOohg3     + DefineBorland + DefineHarbour  + Define32bits) ) + hb_osNewLine()
   c := c + 'MINIGUIFOLDERLIBS'   + DefineOohg3     + DefineBorland + DefineHarbour  + Define32bits + RTrim( ' ' + &("Gbl_T_M_LIBS_" + DefineOohg3     + DefineBorland + DefineHarbour  + Define32bits) ) + hb_osNewLine()
   c := c + 'HARBOURFOLDERLIBS'   + DefineOohg3     + DefineBorland + DefineHarbour  + Define32bits + RTrim( ' ' + &("Gbl_T_P_LIBS_" + DefineOohg3     + DefineBorland + DefineHarbour  + Define32bits) ) + hb_osNewLine()
   c := c + 'MINIGUILIBNAME'      + DefineOohg3     + DefineBorland + DefineHarbour  + Define32bits + RTrim( ' ' + &("Gbl_T_N_"      + DefineOohg3     + DefineBorland + DefineHarbour  + Define32bits) ) + hb_osNewLine()
   c := c + 'GTGUILIBNAME'        + DefineOohg3     + DefineBorland + DefineHarbour  + Define32bits + RTrim( ' ' + &("Gbl_T_G_"      + DefineOohg3     + DefineBorland + DefineHarbour  + Define32bits) ) + hb_osNewLine()

   c := c + 'CCOMPILATOR'         + DefineOohg3     + DefineBorland + DefineXHarbour + Define32bits + RTrim( ' ' + &("Gbl_T_C_"      + DefineOohg3     + DefineBorland + DefineXHarbour + Define32bits) ) + hb_osNewLine()
   c := c + 'MINIGUIFOLDER'       + DefineOohg3     + DefineBorland + DefineXHarbour + Define32bits + RTrim( ' ' + &("Gbl_T_M_"      + DefineOohg3     + DefineBorland + DefineXHarbour + Define32bits) ) + hb_osNewLine()
   c := c + 'XHARBOURFOLDER'      + DefineOohg3     + DefineBorland + DefineXHarbour + Define32bits + RTrim( ' ' + &("Gbl_T_P_"      + DefineOohg3     + DefineBorland + DefineXHarbour + Define32bits) ) + hb_osNewLine()
   c := c + 'CCOMPILATORLIBS'     + DefineOohg3     + DefineBorland + DefineXHarbour + Define32bits + RTrim( ' ' + &("Gbl_T_C_LIBS_" + DefineOohg3     + DefineBorland + DefineXHarbour + Define32bits) ) + hb_osNewLine()
   c := c + 'MINIGUIFOLDERLIBS'   + DefineOohg3     + DefineBorland + DefineXHarbour + Define32bits + RTrim( ' ' + &("Gbl_T_M_LIBS_" + DefineOohg3     + DefineBorland + DefineXHarbour + Define32bits) ) + hb_osNewLine()
   c := c + 'XHARBOURFOLDERLIBS'  + DefineOohg3     + DefineBorland + DefineXHarbour + Define32bits + RTrim( ' ' + &("Gbl_T_P_LIBS_" + DefineOohg3     + DefineBorland + DefineXHarbour + Define32bits) ) + hb_osNewLine()
   c := c + 'MINIGUILIBNAME'      + DefineOohg3     + DefineBorland + DefineXHarbour + Define32bits + RTrim( ' ' + &("Gbl_T_N_"      + DefineOohg3     + DefineBorland + DefineXHarbour + Define32bits) ) + hb_osNewLine()
   c := c + 'GTGUILIBNAME'        + DefineOohg3     + DefineBorland + DefineXHarbour + Define32bits + RTrim( ' ' + &("Gbl_T_G_"      + DefineOohg3     + DefineBorland + DefineXHarbour + Define32bits) ) + hb_osNewLine()

   /* OOHG with MinGW */
   c := c + 'CCOMPILATOR'         + DefineOohg3     + DefineMinGW   + DefineHarbour  + Define32bits + RTrim( ' ' + &("Gbl_T_C_"      + DefineOohg3     + DefineMinGW   + DefineHarbour  + Define32bits) ) + hb_osNewLine()
   c := c + 'MINIGUIFOLDER'       + DefineOohg3     + DefineMinGW   + DefineHarbour  + Define32bits + RTrim( ' ' + &("Gbl_T_M_"      + DefineOohg3     + DefineMinGW   + DefineHarbour  + Define32bits) ) + hb_osNewLine()
   c := c + 'HARBOURFOLDER'       + DefineOohg3     + DefineMinGW   + DefineHarbour  + Define32bits + RTrim( ' ' + &("Gbl_T_P_"      + DefineOohg3     + DefineMinGW   + DefineHarbour  + Define32bits) ) + hb_osNewLine()
   c := c + 'CCOMPILATORLIBS'     + DefineOohg3     + DefineMinGW   + DefineHarbour  + Define32bits + RTrim( ' ' + &("Gbl_T_C_LIBS_" + DefineOohg3     + DefineMinGW   + DefineHarbour  + Define32bits) ) + hb_osNewLine()
   c := c + 'MINIGUIFOLDERLIBS'   + DefineOohg3     + DefineMinGW   + DefineHarbour  + Define32bits + RTrim( ' ' + &("Gbl_T_M_LIBS_" + DefineOohg3     + DefineMinGW   + DefineHarbour  + Define32bits) ) + hb_osNewLine()
   c := c + 'HARBOURFOLDERLIBS'   + DefineOohg3     + DefineMinGW   + DefineHarbour  + Define32bits + RTrim( ' ' + &("Gbl_T_P_LIBS_" + DefineOohg3     + DefineMinGW   + DefineHarbour  + Define32bits) ) + hb_osNewLine()
   c := c + 'MINIGUILIBNAME'      + DefineOohg3     + DefineMinGW   + DefineHarbour  + Define32bits + RTrim( ' ' + &("Gbl_T_N_"      + DefineOohg3     + DefineMinGW   + DefineHarbour  + Define32bits) ) + hb_osNewLine()
   c := c + 'GTGUILIBNAME'        + DefineOohg3     + DefineMinGW   + DefineHarbour  + Define32bits + RTrim( ' ' + &("Gbl_T_G_"      + DefineOohg3     + DefineMinGW   + DefineHarbour  + Define32bits) ) + hb_osNewLine()

   c := c + 'CCOMPILATOR'         + DefineOohg3     + DefineMinGW   + DefineXHarbour + Define32bits + RTrim( ' ' + &("Gbl_T_C_"      + DefineOohg3     + DefineMinGW   + DefineXHarbour + Define32bits) ) + hb_osNewLine()
   c := c + 'MINIGUIFOLDER'       + DefineOohg3     + DefineMinGW   + DefineXHarbour + Define32bits + RTrim( ' ' + &("Gbl_T_M_"      + DefineOohg3     + DefineMinGW   + DefineXHarbour + Define32bits) ) + hb_osNewLine()
   c := c + 'XHARBOURFOLDER'      + DefineOohg3     + DefineMinGW   + DefineXHarbour + Define32bits + RTrim( ' ' + &("Gbl_T_P_"      + DefineOohg3     + DefineMinGW   + DefineXHarbour + Define32bits) ) + hb_osNewLine()
   c := c + 'CCOMPILATORLIBS'     + DefineOohg3     + DefineMinGW   + DefineXHarbour + Define32bits + RTrim( ' ' + &("Gbl_T_C_LIBS_" + DefineOohg3     + DefineMinGW   + DefineXHarbour + Define32bits) ) + hb_osNewLine()
   c := c + 'MINIGUIFOLDERLIBS'   + DefineOohg3     + DefineMinGW   + DefineXHarbour + Define32bits + RTrim( ' ' + &("Gbl_T_M_LIBS_" + DefineOohg3     + DefineMinGW   + DefineXHarbour + Define32bits) ) + hb_osNewLine()
   c := c + 'XHARBOURFOLDERLIBS'  + DefineOohg3     + DefineMinGW   + DefineXHarbour + Define32bits + RTrim( ' ' + &("Gbl_T_P_LIBS_" + DefineOohg3     + DefineMinGW   + DefineXHarbour + Define32bits) ) + hb_osNewLine()
   c := c + 'MINIGUILIBNAME'      + DefineOohg3     + DefineMinGW   + DefineXHarbour + Define32bits + RTrim( ' ' + &("Gbl_T_N_"      + DefineOohg3     + DefineMinGW   + DefineXHarbour + Define32bits) ) + hb_osNewLine()
   c := c + 'GTGUILIBNAME'        + DefineOohg3     + DefineMinGW   + DefineXHarbour + Define32bits + RTrim( ' ' + &("Gbl_T_G_"      + DefineOohg3     + DefineMinGW   + DefineXHarbour + Define32bits) ) + hb_osNewLine()

   c := c + 'CCOMPILATOR'         + DefineOohg3     + DefineMinGW   + DefineHarbour  + Define64bits + RTrim( ' ' + &("Gbl_T_C_"      + DefineOohg3     + DefineMinGW   + DefineHarbour  + Define64bits) ) + hb_osNewLine()
   c := c + 'MINIGUIFOLDER'       + DefineOohg3     + DefineMinGW   + DefineHarbour  + Define64bits + RTrim( ' ' + &("Gbl_T_M_"      + DefineOohg3     + DefineMinGW   + DefineHarbour  + Define64bits) ) + hb_osNewLine()
   c := c + 'HARBOURFOLDER'       + DefineOohg3     + DefineMinGW   + DefineHarbour  + Define64bits + RTrim( ' ' + &("Gbl_T_P_"      + DefineOohg3     + DefineMinGW   + DefineHarbour  + Define64bits) ) + hb_osNewLine()
   c := c + 'CCOMPILATORLIBS'     + DefineOohg3     + DefineMinGW   + DefineHarbour  + Define64bits + RTrim( ' ' + &("Gbl_T_C_LIBS_" + DefineOohg3     + DefineMinGW   + DefineHarbour  + Define64bits) ) + hb_osNewLine()
   c := c + 'MINIGUIFOLDERLIBS'   + DefineOohg3     + DefineMinGW   + DefineHarbour  + Define64bits + RTrim( ' ' + &("Gbl_T_M_LIBS_" + DefineOohg3     + DefineMinGW   + DefineHarbour  + Define64bits) ) + hb_osNewLine()
   c := c + 'HARBOURFOLDERLIBS'   + DefineOohg3     + DefineMinGW   + DefineHarbour  + Define64bits + RTrim( ' ' + &("Gbl_T_P_LIBS_" + DefineOohg3     + DefineMinGW   + DefineHarbour  + Define64bits) ) + hb_osNewLine()
   c := c + 'MINIGUILIBNAME'      + DefineOohg3     + DefineMinGW   + DefineHarbour  + Define64bits + RTrim( ' ' + &("Gbl_T_N_"      + DefineOohg3     + DefineMinGW   + DefineHarbour  + Define64bits) ) + hb_osNewLine()
   c := c + 'GTGUILIBNAME'        + DefineOohg3     + DefineMinGW   + DefineHarbour  + Define64bits + RTrim( ' ' + &("Gbl_T_G_"      + DefineOohg3     + DefineMinGW   + DefineHarbour  + Define64bits) ) + hb_osNewLine()

   c := c + 'CCOMPILATOR'         + DefineOohg3     + DefineMinGW   + DefineXHarbour + Define64bits + RTrim( ' ' + &("Gbl_T_C_"      + DefineOohg3     + DefineMinGW   + DefineXHarbour + Define64bits) ) + hb_osNewLine()
   c := c + 'MINIGUIFOLDER'       + DefineOohg3     + DefineMinGW   + DefineXHarbour + Define64bits + RTrim( ' ' + &("Gbl_T_M_"      + DefineOohg3     + DefineMinGW   + DefineXHarbour + Define64bits) ) + hb_osNewLine()
   c := c + 'XHARBOURFOLDER'      + DefineOohg3     + DefineMinGW   + DefineXHarbour + Define64bits + RTrim( ' ' + &("Gbl_T_P_"      + DefineOohg3     + DefineMinGW   + DefineXHarbour + Define64bits) ) + hb_osNewLine()
   c := c + 'CCOMPILATORLIBS'     + DefineOohg3     + DefineMinGW   + DefineXHarbour + Define64bits + RTrim( ' ' + &("Gbl_T_C_LIBS_" + DefineOohg3     + DefineMinGW   + DefineXHarbour + Define64bits) ) + hb_osNewLine()
   c := c + 'MINIGUIFOLDERLIBS'   + DefineOohg3     + DefineMinGW   + DefineXHarbour + Define64bits + RTrim( ' ' + &("Gbl_T_M_LIBS_" + DefineOohg3     + DefineMinGW   + DefineXHarbour + Define64bits) ) + hb_osNewLine()
   c := c + 'XHARBOURFOLDERLIBS'  + DefineOohg3     + DefineMinGW   + DefineXHarbour + Define64bits + RTrim( ' ' + &("Gbl_T_P_LIBS_" + DefineOohg3     + DefineMinGW   + DefineXHarbour + Define64bits) ) + hb_osNewLine()
   c := c + 'MINIGUILIBNAME'      + DefineOohg3     + DefineMinGW   + DefineXHarbour + Define64bits + RTrim( ' ' + &("Gbl_T_N_"      + DefineOohg3     + DefineMinGW   + DefineXHarbour + Define64bits) ) + hb_osNewLine()
   c := c + 'GTGUILIBNAME'        + DefineOohg3     + DefineMinGW   + DefineXHarbour + Define64bits + RTrim( ' ' + &("Gbl_T_G_"      + DefineOohg3     + DefineMinGW   + DefineXHarbour + Define64bits) ) + hb_osNewLine()

   /* OOHG with Pelles */
   c := c + 'CCOMPILATOR'         + DefineOohg3     + DefinePelles  + DefineHarbour  + Define32bits + RTrim( ' ' + &("Gbl_T_C_"      + DefineOohg3     + DefinePelles  + DefineHarbour  + Define32bits) ) + hb_osNewLine()
   c := c + 'MINIGUIFOLDER'       + DefineOohg3     + DefinePelles  + DefineHarbour  + Define32bits + RTrim( ' ' + &("Gbl_T_M_"      + DefineOohg3     + DefinePelles  + DefineHarbour  + Define32bits) ) + hb_osNewLine()
   c := c + 'HARBOURFOLDER'       + DefineOohg3     + DefinePelles  + DefineHarbour  + Define32bits + RTrim( ' ' + &("Gbl_T_P_"      + DefineOohg3     + DefinePelles  + DefineHarbour  + Define32bits) ) + hb_osNewLine()
   c := c + 'CCOMPILATORLIBS'     + DefineOohg3     + DefinePelles  + DefineHarbour  + Define32bits + RTrim( ' ' + &("Gbl_T_C_LIBS_" + DefineOohg3     + DefinePelles  + DefineHarbour  + Define32bits) ) + hb_osNewLine()
   c := c + 'MINIGUIFOLDERLIBS'   + DefineOohg3     + DefinePelles  + DefineHarbour  + Define32bits + RTrim( ' ' + &("Gbl_T_M_LIBS_" + DefineOohg3     + DefinePelles  + DefineHarbour  + Define32bits) ) + hb_osNewLine()
   c := c + 'HARBOURFOLDERLIBS'   + DefineOohg3     + DefinePelles  + DefineHarbour  + Define32bits + RTrim( ' ' + &("Gbl_T_P_LIBS_" + DefineOohg3     + DefinePelles  + DefineHarbour  + Define32bits) ) + hb_osNewLine()
   c := c + 'MINIGUILIBNAME'      + DefineOohg3     + DefinePelles  + DefineHarbour  + Define32bits + RTrim( ' ' + &("Gbl_T_N_"      + DefineOohg3     + DefinePelles  + DefineHarbour  + Define32bits) ) + hb_osNewLine()
   c := c + 'GTGUILIBNAME'        + DefineOohg3     + DefinePelles  + DefineHarbour  + Define32bits + RTrim( ' ' + &("Gbl_T_G_"      + DefineOohg3     + DefinePelles  + DefineHarbour  + Define32bits) ) + hb_osNewLine()

   c := c + 'CCOMPILATOR'         + DefineOohg3     + DefinePelles  + DefineXHarbour + Define32bits + RTrim( ' ' + &("Gbl_T_C_"      + DefineOohg3     + DefinePelles  + DefineXHarbour + Define32bits) ) + hb_osNewLine()
   c := c + 'MINIGUIFOLDER'       + DefineOohg3     + DefinePelles  + DefineXHarbour + Define32bits + RTrim( ' ' + &("Gbl_T_M_"      + DefineOohg3     + DefinePelles  + DefineXHarbour + Define32bits) ) + hb_osNewLine()
   c := c + 'XHARBOURFOLDER'      + DefineOohg3     + DefinePelles  + DefineXHarbour + Define32bits + RTrim( ' ' + &("Gbl_T_P_"      + DefineOohg3     + DefinePelles  + DefineXHarbour + Define32bits) ) + hb_osNewLine()
   c := c + 'CCOMPILATORLIBS'     + DefineOohg3     + DefinePelles  + DefineXHarbour + Define32bits + RTrim( ' ' + &("Gbl_T_C_LIBS_" + DefineOohg3     + DefinePelles  + DefineXHarbour + Define32bits) ) + hb_osNewLine()
   c := c + 'MINIGUIFOLDERLIBS'   + DefineOohg3     + DefinePelles  + DefineXHarbour + Define32bits + RTrim( ' ' + &("Gbl_T_M_LIBS_" + DefineOohg3     + DefinePelles  + DefineXHarbour + Define32bits) ) + hb_osNewLine()
   c := c + 'XHARBOURFOLDERLIBS'  + DefineOohg3     + DefinePelles  + DefineXHarbour + Define32bits + RTrim( ' ' + &("Gbl_T_P_LIBS_" + DefineOohg3     + DefinePelles  + DefineXHarbour + Define32bits) ) + hb_osNewLine()
   c := c + 'MINIGUILIBNAME'      + DefineOohg3     + DefinePelles  + DefineXHarbour + Define32bits + RTrim( ' ' + &("Gbl_T_N_"      + DefineOohg3     + DefinePelles  + DefineXHarbour + Define32bits) ) + hb_osNewLine()
   c := c + 'GTGUILIBNAME'        + DefineOohg3     + DefinePelles  + DefineXHarbour + Define32bits + RTrim( ' ' + &("Gbl_T_G_"      + DefineOohg3     + DefinePelles  + DefineXHarbour + Define32bits) ) + hb_osNewLine()

   c := c + 'CCOMPILATOR'         + DefineOohg3     + DefinePelles  + DefineHarbour  + Define64bits + RTrim( ' ' + &("Gbl_T_C_"      + DefineOohg3     + DefinePelles  + DefineHarbour  + Define64bits) ) + hb_osNewLine()
   c := c + 'MINIGUIFOLDER'       + DefineOohg3     + DefinePelles  + DefineHarbour  + Define64bits + RTrim( ' ' + &("Gbl_T_M_"      + DefineOohg3     + DefinePelles  + DefineHarbour  + Define64bits) ) + hb_osNewLine()
   c := c + 'HARBOURFOLDER'       + DefineOohg3     + DefinePelles  + DefineHarbour  + Define64bits + RTrim( ' ' + &("Gbl_T_P_"      + DefineOohg3     + DefinePelles  + DefineHarbour  + Define64bits) ) + hb_osNewLine()
   c := c + 'CCOMPILATORLIBS'     + DefineOohg3     + DefinePelles  + DefineHarbour  + Define64bits + RTrim( ' ' + &("Gbl_T_C_LIBS_" + DefineOohg3     + DefinePelles  + DefineHarbour  + Define64bits) ) + hb_osNewLine()
   c := c + 'MINIGUIFOLDERLIBS'   + DefineOohg3     + DefinePelles  + DefineHarbour  + Define64bits + RTrim( ' ' + &("Gbl_T_M_LIBS_" + DefineOohg3     + DefinePelles  + DefineHarbour  + Define64bits) ) + hb_osNewLine()
   c := c + 'HARBOURFOLDERLIBS'   + DefineOohg3     + DefinePelles  + DefineHarbour  + Define64bits + RTrim( ' ' + &("Gbl_T_P_LIBS_" + DefineOohg3     + DefinePelles  + DefineHarbour  + Define64bits) ) + hb_osNewLine()
   c := c + 'MINIGUILIBNAME'      + DefineOohg3     + DefinePelles  + DefineHarbour  + Define64bits + RTrim( ' ' + &("Gbl_T_N_"      + DefineOohg3     + DefinePelles  + DefineHarbour  + Define64bits) ) + hb_osNewLine()
   c := c + 'GTIGUILIBNAME'       + DefineOohg3     + DefinePelles  + DefineHarbour  + Define64bits + RTrim( ' ' + &("Gbl_T_G_"      + DefineOohg3     + DefinePelles  + DefineHarbour  + Define64bits) ) + hb_osNewLine()

   c := c + 'CCOMPILATOR'         + DefineOohg3     + DefinePelles  + DefineXHarbour + Define64bits + RTrim( ' ' + &("Gbl_T_C_"      + DefineOohg3     + DefinePelles  + DefineXHarbour + Define64bits) ) + hb_osNewLine()
   c := c + 'MINIGUIFOLDER'       + DefineOohg3     + DefinePelles  + DefineXHarbour + Define64bits + RTrim( ' ' + &("Gbl_T_M_"      + DefineOohg3     + DefinePelles  + DefineXHarbour + Define64bits) ) + hb_osNewLine()
   c := c + 'XHARBOURFOLDER'      + DefineOohg3     + DefinePelles  + DefineXHarbour + Define64bits + RTrim( ' ' + &("Gbl_T_P_"      + DefineOohg3     + DefinePelles  + DefineXHarbour + Define64bits) ) + hb_osNewLine()
   c := c + 'CCOMPILATORLIBS'     + DefineOohg3     + DefinePelles  + DefineXHarbour + Define64bits + RTrim( ' ' + &("Gbl_T_C_LIBS_" + DefineOohg3     + DefinePelles  + DefineXHarbour + Define64bits) ) + hb_osNewLine()
   c := c + 'MINIGUIFOLDERLIBS'   + DefineOohg3     + DefinePelles  + DefineXHarbour + Define64bits + RTrim( ' ' + &("Gbl_T_M_LIBS_" + DefineOohg3     + DefinePelles  + DefineXHarbour + Define64bits) ) + hb_osNewLine()
   c := c + 'XHARBOURFOLDERLIBS'  + DefineOohg3     + DefinePelles  + DefineXHarbour + Define64bits + RTrim( ' ' + &("Gbl_T_P_LIBS_" + DefineOohg3     + DefinePelles  + DefineXHarbour + Define64bits) ) + hb_osNewLine()
   c := c + 'MINIGUILIBNAME'      + DefineOohg3     + DefinePelles  + DefineXHarbour + Define64bits + RTrim( ' ' + &("Gbl_T_N_"      + DefineOohg3     + DefinePelles  + DefineXHarbour + Define64bits) ) + hb_osNewLine()
   c := c + 'GTGUILIBNAME'        + DefineOohg3     + DefinePelles  + DefineXHarbour + Define64bits + RTrim( ' ' + &("Gbl_T_G_"      + DefineOohg3     + DefinePelles  + DefineXHarbour + Define64bits) ) + hb_osNewLine()

#ifdef QPM_HOTRECOVERY
   c := c + 'HOTVERSIONS' + RTrim( " " + Str( HR_nVersionsSet ) ) + hb_osNewLine()
#endif
   
   FOR i := 1 TO GetProperty( "VentanaMain", "CSearch", "ItemCount" )
      c := c + 'SEARCH ' + GetProperty( "VentanaMain", "CSearch", "item", i ) + hb_osNewLine()
   NEXT i

   FOR i := 1 TO Len( vLastOpen )
      IF ! Empty( vLastOpen[i] )
         c := c + 'LASTOPEN ' + vLastOpen[i] + hb_osNewLine()
      ENDIF
   NEXT i

   /* Save default libraries to configuration file */
   DescargoDefaultLibs( LibsActiva )
   FOR i := 1 TO Len( vSuffix )
      aLibs := AClone( &( "Gbl_DEF_LIBS_" + vSuffix[i,1] ) )
      FOR j := 1 TO Len( aLibs )
         c := c + "DEFAULTLIBS" + vSuffix[i,1] + " " + aLibs[j,1] + " " + aLibs[j,2] + aLibs[j,3] + aLibs[j,4] + hb_osNewLine()
      NEXT j
   NEXT i

   QPM_MemoWrit( PUB_cQPM_Folder + DEF_SLASH + 'QPM_' + QPM_VERSION_NUMBER_LONG + '.cfg', c )

   IF ! lDefaultFile
      TmpName := AllTrim( PutFile( { {'QPM Configuration Files (*.cfg)','*.cfg'} }, 'Save Global Settings', cLastProjectFolder, .T. ) )
      IF ! Empty( TmpName )
         QPM_MemoWrit( TmpName, c )
      ENDIF
   ENDIF

RETURN .T.

/* eof */
