/*
 * $Id$
 */

/*
 *    QPM - QAC Based Project Manager
 *
 *    Copyright 2011 Fernando Yurisich <fernando.yurisich@gmail.com>
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

#include "minigui.ch"
#include <QPM.ch>

Function LoadEnvironment
   Local EnvironmentMemo, EnvironmentVersion, EnvironmentMemoAux
   Local LOC_cLine, nInx, vConfig
   
   EnvironmentVersion := 0
   nInx := 0
   vConfig := {}
   Gbl_TEditor := ''

   &( "Gbl_T_M_" + DefineMiniGui1 + DefineBorland ) := 'C:' + DEF_SLASH + 'MiniGui1x'
   &( "Gbl_T_C_" + DefineMiniGui1 + DefineBorland ) := 'C:' + DEF_SLASH + 'Borland' + DEF_SLASH + 'bcc55'
   &( "Gbl_T_H_" + DefineMiniGui1 + DefineBorland ) := 'C:' + DEF_SLASH + 'MiniGui1x' + DEF_SLASH + 'Harbour'
   &( "Gbl_T_X_" + DefineMiniGui1 + DefineBorland ) := 'C:' + DEF_SLASH + 'MiniGui1x' + DEF_SLASH + 'xHarbour'
   
   &( "Gbl_T_M_" + DefineMiniGui3 + DefineMinGW ) := 'C:' + DEF_SLASH + 'HMG'
   &( "Gbl_T_C_" + DefineMiniGui3 + DefineMinGW ) := 'C:' + DEF_SLASH + 'HMG' + DEF_SLASH + 'MinGW'
   &( "Gbl_T_H_" + DefineMiniGui3 + DefineMinGW ) := 'C:' + DEF_SLASH + 'HMG' + DEF_SLASH + 'Harbour'
   &( "Gbl_T_X_" + DefineMiniGui3 + DefineMinGW ) := 'C:' + DEF_SLASH + 'HMG' + DEF_SLASH + 'xHarbour'
   
   &( "Gbl_T_M_" + DefineExtended1 + DefineBorland ) := 'C:' + DEF_SLASH + 'MiniGui'
   &( "Gbl_T_C_" + DefineExtended1 + DefineBorland ) := 'C:' + DEF_SLASH + 'Borland' + DEF_SLASH + 'bcc55'
   &( "Gbl_T_H_" + DefineExtended1 + DefineBorland ) := 'C:' + DEF_SLASH + 'MiniGui' + DEF_SLASH + 'Harbour'
   &( "Gbl_T_X_" + DefineExtended1 + DefineBorland ) := 'C:' + DEF_SLASH + 'MiniGui' + DEF_SLASH + 'xHarbour'
   
   &( "Gbl_T_M_" + DefineExtended1 + DefineMinGW ) := 'C:' + DEF_SLASH + 'MiniGui'
   &( "Gbl_T_C_" + DefineExtended1 + DefineMinGW ) := 'C:' + DEF_SLASH + 'HMG' + DEF_SLASH + 'MinGW'
   &( "Gbl_T_H_" + DefineExtended1 + DefineMinGW ) := 'C:' + DEF_SLASH + 'HMG' + DEF_SLASH + 'Harbour'
   &( "Gbl_T_X_" + DefineExtended1 + DefineMinGW ) := 'C:' + DEF_SLASH + 'HMG' + DEF_SLASH + 'xHarbour'
   
   &( "Gbl_T_M_" + DefineOohg3 + DefineBorland ) := 'C:' + DEF_SLASH + 'OOHGforBorland'
   &( "Gbl_T_C_" + DefineOohg3 + DefineBorland ) := 'C:' + DEF_SLASH + 'Borland' + DEF_SLASH + 'bcc55'
   &( "Gbl_T_H_" + DefineOohg3 + DefineBorland ) := 'C:' + DEF_SLASH + 'OOHGforBorland' + DEF_SLASH + 'Harbour'
   &( "Gbl_T_X_" + DefineOohg3 + DefineBorland ) := 'C:' + DEF_SLASH + 'OOHGforBorland' + DEF_SLASH + 'xHarbour'
   
   &( "Gbl_T_M_" + DefineOohg3 + DefineMinGW ) := 'C:' + DEF_SLASH + 'OOHGforMinGW'
   &( "Gbl_T_C_" + DefineOohg3 + DefineMinGW ) := 'C:' + DEF_SLASH + 'MinGW'
   &( "Gbl_T_H_" + DefineOohg3 + DefineMinGW ) := 'C:' + DEF_SLASH + 'OOHGforMinGW' + DEF_SLASH + 'Harbour'
   &( "Gbl_T_X_" + DefineOohg3 + DefineMinGW ) := 'C:' + DEF_SLASH + 'OOHGforMinGW' + DEF_SLASH + 'xHarbour'
   
   &( "Gbl_T_M_" + DefineOohg3 + DefinePelles ) := 'C:' + DEF_SLASH + 'OOHGforPelles'
   &( "Gbl_T_C_" + DefineOohg3 + DefinePelles ) := 'C:' + DEF_SLASH + 'Pelles'
   &( "Gbl_T_H_" + DefineOohg3 + DefinePelles ) := 'C:' + DEF_SLASH + 'OOHGforPelles' + DEF_SLASH + 'Harbour'
   &( "Gbl_T_X_" + DefineOohg3 + DefinePelles ) := 'C:' + DEF_SLASH + 'OOHGforPelles' + DEF_SLASH + 'xHarbour'
   
   bEditorLongName := .F.
   bSuspendControlEdit := .F.
   
   if PUB_bLite .and. File( US_FileNameOnlyPathAndName( PUB_cProjectFile ) + ".cfg" )
      EnvironmentMemo := MemoRead ( US_FileNameOnlyPathAndName( PUB_cProjectFile ) + ".cfg" )
   else
      if File( PUB_cQPM_Folder + DEF_SLASH + 'QPM_' + PUB_cQPM_Version3 + '.cfg' )
         if US_DirWrite( GetWindowsFolder() )
            if File( GetWindowsFolder() + DEF_SLASH + 'QPM_' + PUB_cQPM_Version3 + '.path' )
               if ! ( MemoRead( GetWindowsFolder() + DEF_SLASH + 'QPM_' + PUB_cQPM_Version3 + '.path' ) == PUB_cQPM_Folder )
                  QPM_MemoWrit( GetWindowsFolder() + DEF_SLASH + 'QPM_' + PUB_cQPM_Version3 + '.path', PUB_cQPM_Folder )
               endif
            else
               QPM_MemoWrit( GetWindowsFolder() + DEF_SLASH + 'QPM_' + PUB_cQPM_Version3 + '.path', PUB_cQPM_Folder )
            endif
         endif
      else
         if US_DirWrite( GetWindowsFolder() )
            
            DECLARE vAuxDir[ ADIR( GetWindowsFolder() + DEF_SLASH + 'QAC_????????.path' ) ]
            ADIR( GetWindowsFolder() + DEF_SLASH + 'QAC_????????.path', vAuxDir )
            for nInx := 1 to len( vAuxDir )
               if val( substr( vAuxDir[nInx], 5, 8 ) ) < val( PUB_cQPM_Version3 )
                  if US_IsDirectory( alltrim( memoline( memoread( GetWindowsFolder() + DEF_SLASH + vAuxDir[nInx] ), 254, 1 ) ) )
                     aadd( vConfig, vAuxDir[nInx] )
                  endif
               else
                  if val( substr( vAuxDir[nInx], 5, 8 ) ) == val( PUB_cQPM_Version3 )
                     if !( upper( alltrim( memoline( memoread( GetWindowsFolder() + DEF_SLASH + vAuxDir[nInx] ), 254, 1 ) ) ) == upper( PUB_cQPM_Folder ) )
                        if US_IsDirectory( alltrim( memoline( memoread( GetWindowsFolder() + DEF_SLASH + vAuxDir[nInx] ), 254, 1 ) ) )
                           aadd( vConfig, vAuxDir[nInx] )
                        endif
                     endif
                  endif
               endif
            next
            RELEASE vAuxDir
            
            DECLARE vAuxDir[ ADIR( GetWindowsFolder() + DEF_SLASH + 'QPM_????????.path' ) ]
            ADIR( GetWindowsFolder() + DEF_SLASH + 'QPM_????????.path', vAuxDir )
            for nInx := 1 to len( vAuxDir )
               if val( substr( vAuxDir[nInx], 5, 8 ) ) < val( PUB_cQPM_Version3 )
                  if US_IsDirectory( alltrim( memoline( memoread( GetWindowsFolder() + DEF_SLASH + vAuxDir[nInx] ), 254, 1 ) ) )
                     aadd( vConfig, vAuxDir[nInx] )
                  endif
               else
                  if val( substr( vAuxDir[nInx], 5, 8 ) ) == val( PUB_cQPM_Version3 )
                     if !( upper( alltrim( memoline( memoread( GetWindowsFolder() + DEF_SLASH + vAuxDir[nInx] ), 254, 1 ) ) ) == upper( PUB_cQPM_Folder ) )
                        if US_IsDirectory( alltrim( memoline( memoread( GetWindowsFolder() + DEF_SLASH + vAuxDir[nInx] ), 254, 1 ) ) )
                           aadd( vConfig, vAuxDir[nInx] )
                        endif
                     endif
                  endif
               endif
            next
            RELEASE vAuxDir
            
            if len( vConfig ) > 0
               aSort( vConfig, , , { |x, y| US_Upper(x) > US_Upper(y) })
               PUB_MigrateFolderFrom := alltrim( memoline( memoread( GetWindowsFolder() + DEF_SLASH + vConfig[1] ), , 1 ) )
               PUB_MigrateVersionFrom := US_FileNameOnlyName( vConfig[1] )
               if File( PUB_MigrateFolderFrom + DEF_SLASH + PUB_MigrateVersionFrom + ".cfg" )
                  US_FileCopy( PUB_MigrateFolderFrom + DEF_SLASH + PUB_MigrateVersionFrom + ".cfg", PUB_cQPM_Folder + DEF_SLASH + 'QPM_' + PUB_cQPM_Version3 + '.cfg' )
               else
                  US_Log( "Previous Configuration file not found: " + PUB_MigrateFolderFrom + DEF_SLASH + PUB_MigrateVersionFrom + ".cfg" )
               endif
            endif
            QPM_MemoWrit( GetWindowsFolder() + DEF_SLASH + 'QPM_' + PUB_cQPM_Version3 + '.path', PUB_cQPM_Folder )
         endif
      endif
      EnvironmentMemo := MemoRead( PUB_cQPM_Folder + DEF_SLASH + 'QPM_' + PUB_cQPM_Version3 + '.cfg' )
      if empty( PUB_MigrateFolderFrom )
         PUB_MigrateFolderFrom := GetWindowsFolder()
      endif
   endif
   if MLCount ( EnvironmentMemo, 254 ) > 0
      LOC_cLine := AllTrim ( MEMOLINE( EnvironmentMemo, 254, 1 ) )
      if us_word( LOC_cLine, 1 ) == "VERSION"
         EnvironmentVersion := val( us_word( LOC_cLine, 2 ) + us_word( LOC_cLine, 3 ) + us_word( LOC_cLine, 4 ) )
      else
         EnvironmentVersion := val( "010001" )   && 01.00.01
      endif
   endif
   if EnvironmentVersion > PUB_nQPM_Version
      MsgStop( "Version of Environment file is greater than the version of this program, the file will not be processed.  You can continue without problems." )
      Return .F.
   endif
      PRIVATE PRI_COMPATIBILITY_ENVIRONMENTVERSION    := EnvironmentVersion
      PRIVATE PRI_COMPATIBILITY_ENVIRONMENTFILE       := EnvironmentMemo
      PRIVATE PRI_COMPATIBILITY_ENVIRONMENTFILEAUX    := EnvironmentMemoAux
#include "QPM_CompatibilityOpenGlobal.CH"
      EnvironmentVersion    := PRI_COMPATIBILITY_ENVIRONMENTVERSION
      EnvironmentMemo       := PRI_COMPATIBILITY_ENVIRONMENTFILE
      EnvironmentMemoAux    := PRI_COMPATIBILITY_ENVIRONMENTFILEAUX
      RELEASE PRI_COMPATIBILITY_ENVIRONMENTVERSION
      RELEASE PRI_COMPATIBILITY_ENVIRONMENTFILE
      RELEASE PRI_COMPATIBILITY_ENVIRONMENTFILEAUX
   /* Version ACTUAL */
   For i := 1 To MLCount ( EnvironmentMemo, 254 )
      DO EVENTS
      LOC_cLine := AllTrim ( MEMOLINE( EnvironmentMemo, 254, i ) )
      If     US_Upper( US_Word( LOC_cLine, 1 ) ) == 'PROGRAMEDITOR'
             Gbl_TEditor := US_WordSubStr( LOC_cLine, 2 )
      ElseIf US_Upper( US_Word( LOC_cLine, 1 ) ) == 'EDITLONGNAME'
             bEditorLongName := if( US_WordSubStr( LOC_cLine, 2 ) == ".T.", .T., .F. )
      ElseIf US_Upper( US_Word( LOC_cLine, 1 ) ) == 'EDITSUSPENDCONTROL'
             bSuspendControlEdit := if( US_WordSubStr( LOC_cLine, 2 ) == ".T.", .T., .F. )
      ElseIf US_Upper( US_Word( LOC_cLine, 1 ) ) == 'FORMTOOLHMI'
             Gbl_Text_HMI := US_WordSubStr( LOC_cLine, 2 )
      ElseIf US_Upper( US_Word( LOC_cLine, 1 ) ) == 'FORMTOOLHMGSIDE'
             Gbl_Text_HMGSIDE := US_WordSubStr( LOC_cLine, 2 )
      ElseIf US_Upper( US_Word( LOC_cLine, 1 ) ) == 'DBFTOOL'
             Gbl_Text_Dbf := US_WordSubStr( LOC_cLine, 2 )
      ElseIf US_Upper( US_Word( LOC_cLine, 1 ) ) == 'DBFCOMILLAS'
             Gbl_Comillas_DBF := if( US_WordSubStr( LOC_cLine, 2 ) == ".T.", '"', '' )
      ElseIf at( 'CCOMPILATOR', US_Upper( LOC_cLine ) ) = 1
             if US_IsVar( 'Gbl_T_C_' + substr( US_Upper( US_Word( LOC_cLine, 1 ) ), 12 ) )
                &('Gbl_T_C_' + substr( US_Upper( US_Word( LOC_cLine, 1 ) ), 12 )) := US_WordSubStr( LOC_cLine, 2 )
             endif
      ElseIf at( 'MINIGUIFOLDER', US_Upper( LOC_cLine ) ) = 1
             if US_IsVar( 'Gbl_T_M_' + substr( US_Upper( US_Word( LOC_cLine, 1 ) ), 14 ) )
                &('Gbl_T_M_' + substr( US_Upper( US_Word( LOC_cLine, 1 ) ), 14 )) := US_WordSubStr( LOC_cLine, 2 )
             endif
      ElseIf at( 'HARBOURFOLDER', US_Upper( LOC_cLine ) ) = 1
             if US_IsVar( 'Gbl_T_H_' + substr( US_Upper( US_Word( LOC_cLine, 1 ) ), 14 ) )
                &('Gbl_T_H_' + substr( US_Upper( US_Word( LOC_cLine, 1 ) ), 14 )) := US_WordSubStr( LOC_cLine, 2 )
             endif
      ElseIf at( 'XHARBOURFOLDER', US_Upper( LOC_cLine ) ) = 1
             if US_IsVar( 'Gbl_T_X_' + substr( US_Upper( US_Word( LOC_cLine, 1 ) ), 15 ) )
                &('Gbl_T_X_' + substr( US_Upper( US_Word( LOC_cLine, 1 ) ), 15 )) := US_WordSubStr( LOC_cLine, 2 )
             endif
      ElseIf US_Upper( US_Word( LOC_cLine, 1 ) ) == 'LASTPROJECTFOLDER'
             cLastProjectFolder := US_WordSubStr( LOC_cLine, 2 )
      ElseIf US_Upper ( US_Word( LOC_cLine, 1 ) ) == 'SEARCH'
             aadd( vLastSearch, US_WordSubStr( LOC_cLine, 2 ) )
      ElseIf US_Upper ( US_Word( LOC_cLine, 1 ) ) == 'LASTOPEN'
             aadd( vLastOpen, US_WordSubStr( LOC_cLine, 2 ) )
#ifdef QPM_HOTRECOVERY
      ElseIf US_Upper( US_Word( LOC_cLine, 1 ) ) == 'HOTVERSIONS'
             HR_nVersionsSet := Val( US_WordSubStr( LOC_cLine, 2 ) )
             if HR_nVersionsSet < HR_nVersionsMinimun
                HR_nVersionsSet := HR_nVersionsMinimun
             endif
#endif
      EndIf
   Next i
   If Empty(Gbl_TEditor)
      Gbl_TEditor := GetWindowsFolder() + DEF_SLASH + 'system32' + DEF_SLASH + 'NOTEPAD.EXE'
   EndIf
Return .T.

Function SaveEnvironment
   Local c := ''
   c := c + 'VERSION ' + PUB_cQPM_Version + Hb_OsNewLine()
   c := c + 'PROGRAMEDITOR ' + alltrim(Gbl_TEditor) + Hb_OsNewLine()
   c := c + 'EDITLONGNAME ' + US_TodoStr( bEditorLongName ) + Hb_OsNewLine()
   c := c + 'EDITSUSPENDCONTROL ' + US_TodoStr( bSuspendControlEdit ) + Hb_OsNewLine()
   c := c + 'FORMTOOLHMI ' + alltrim(Gbl_Text_HMI) + Hb_OsNewLine()
   c := c + 'FORMTOOLHMGSIDE ' + alltrim(Gbl_Text_HMGSIDE) + Hb_OsNewLine()
   c := c + 'DBFTOOL ' + alltrim(Gbl_Text_Dbf) + Hb_OsNewLine()
   c := c + 'DBFCOMILLAS ' + if( Gbl_Comillas_DBF == '"', ".T.", ".F." ) + Hb_OsNewLine()
   c := c + 'LASTPROJECTFOLDER ' + cLastProjectFolder + Hb_OsNewLine()
   
   c := c + 'MINIGUIFOLDER' + DefineMiniGui1 + DefineBorland + ' ' + alltrim(&( "Gbl_T_M_" + DefineMiniGui1 + DefineBorland )) + Hb_OsNewLine()
   c := c + 'CCOMPILATOR' + DefineMiniGui1 + DefineBorland + ' ' + alltrim(&( "Gbl_T_C_" + DefineMiniGui1 + DefineBorland )) + Hb_OsNewLine()
   c := c + 'HARBOURFOLDER' + DefineMiniGui1 + DefineBorland + ' ' + alltrim(&( "Gbl_T_H_" + DefineMiniGui1 + DefineBorland )) + Hb_OsNewLine()
   c := c + 'XHARBOURFOLDER' + DefineMiniGui1 + DefineBorland + ' ' + alltrim(&( "Gbl_T_X_" + DefineMiniGui1 + DefineBorland )) + Hb_OsNewLine()
   
   c := c + 'MINIGUIFOLDER' + DefineMiniGui3 + DefineMinGW + ' ' + alltrim(&( "Gbl_T_M_" + DefineMiniGui3 + DefineMinGW )) + Hb_OsNewLine()
   c := c + 'CCOMPILATOR' + DefineMiniGui3 + DefineMinGW + ' ' + alltrim(&( "Gbl_T_C_" + DefineMiniGui3 + DefineMinGW )) + Hb_OsNewLine()
   c := c + 'HARBOURFOLDER' + DefineMiniGui3 + DefineMinGW + ' ' + alltrim(&( "Gbl_T_H_" + DefineMiniGui3 + DefineMinGW )) + Hb_OsNewLine()
   c := c + 'XHARBOURFOLDER' + DefineMiniGui3 + DefineMinGW + ' ' + alltrim(&( "Gbl_T_X_" + DefineMiniGui3 + DefineMinGW )) + Hb_OsNewLine()
   
   c := c + 'MINIGUIFOLDER' + DefineExtended1 + DefineBorland + ' ' + alltrim(&( "Gbl_T_M_" + DefineExtended1 + DefineBorland )) + Hb_OsNewLine()
   c := c + 'CCOMPILATOR' + DefineExtended1 + DefineBorland + ' ' + alltrim(&( "Gbl_T_C_" + DefineExtended1 + DefineBorland )) + Hb_OsNewLine()
   c := c + 'HARBOURFOLDER' + DefineExtended1 + DefineBorland + ' ' + alltrim(&( "Gbl_T_H_" + DefineExtended1 + DefineBorland )) + Hb_OsNewLine()
   c := c + 'XHARBOURFOLDER' + DefineExtended1 + DefineBorland + ' ' + alltrim(&( "Gbl_T_X_" + DefineExtended1 + DefineBorland )) + Hb_OsNewLine()
   
   c := c + 'MINIGUIFOLDER' + DefineExtended1 + DefineMinGW + ' ' + alltrim(&( "Gbl_T_M_" + DefineExtended1 + DefineMinGW )) + Hb_OsNewLine()
   c := c + 'CCOMPILATOR' + DefineExtended1 + DefineMinGW + ' ' + alltrim(&( "Gbl_T_C_" + DefineExtended1 + DefineMinGW )) + Hb_OsNewLine()
   c := c + 'HARBOURFOLDER' + DefineExtended1 + DefineMinGW + ' ' + alltrim(&( "Gbl_T_H_" + DefineExtended1 + DefineMinGW )) + Hb_OsNewLine()
   c := c + 'XHARBOURFOLDER' + DefineExtended1 + DefineMinGW + ' ' + alltrim(&( "Gbl_T_X_" + DefineExtended1 + DefineMinGW )) + Hb_OsNewLine()
   
   c := c + 'MINIGUIFOLDER' + DefineOohg3 + DefineBorland + ' ' + alltrim(&( "Gbl_T_M_" + DefineOohg3 + DefineBorland )) + Hb_OsNewLine()
   c := c + 'CCOMPILATOR' + DefineOohg3 + DefineBorland + ' ' + alltrim(&( "Gbl_T_C_" + DefineOohg3 + DefineBorland )) + Hb_OsNewLine()
   c := c + 'HARBOURFOLDER' + DefineOohg3 + DefineBorland + ' ' + alltrim(&( "Gbl_T_H_" + DefineOohg3 + DefineBorland )) + Hb_OsNewLine()
   c := c + 'XHARBOURFOLDER' + DefineOohg3 + DefineBorland + ' ' + alltrim(&( "Gbl_T_X_" + DefineOohg3 + DefineBorland )) + Hb_OsNewLine()
   
   c := c + 'MINIGUIFOLDER' + DefineOohg3 + DefineMinGW + ' ' + alltrim(&( "Gbl_T_M_" + DefineOohg3 + DefineMinGW )) + Hb_OsNewLine()
   c := c + 'CCOMPILATOR' + DefineOohg3 + DefineMinGW + ' ' + alltrim(&( "Gbl_T_C_" + DefineOohg3 + DefineMinGW )) + Hb_OsNewLine()
   c := c + 'HARBOURFOLDER' + DefineOohg3 + DefineMinGW + ' ' + alltrim(&( "Gbl_T_H_" + DefineOohg3 + DefineMinGW )) + Hb_OsNewLine()
   c := c + 'XHARBOURFOLDER' + DefineOohg3 + DefineMinGW + ' ' + alltrim(&( "Gbl_T_X_" + DefineOohg3 + DefineMinGW )) + Hb_OsNewLine()
   
   c := c + 'MINIGUIFOLDER' + DefineOohg3 + DefinePelles + ' ' + alltrim(&( "Gbl_T_M_" + DefineOohg3 + DefinePelles )) + Hb_OsNewLine()
   c := c + 'CCOMPILATOR' + DefineOohg3 + DefinePelles + ' ' + alltrim(&( "Gbl_T_C_" + DefineOohg3 + DefinePelles )) + Hb_OsNewLine()
   c := c + 'HARBOURFOLDER' + DefineOohg3 + DefinePelles + ' ' + alltrim(&( "Gbl_T_H_" + DefineOohg3 + DefinePelles )) + Hb_OsNewLine()
   c := c + 'XHARBOURFOLDER' + DefineOohg3 + DefinePelles + ' ' + alltrim(&( "Gbl_T_X_" + DefineOohg3 + DefinePelles )) + Hb_OsNewLine()
#ifdef QPM_HOTRECOVERY
   c := c + 'HOTVERSIONS ' + alltrim( str( HR_nVersionsSet ) ) + HB_OsNewLine()
#endif
   
   For i := 1 To GetProperty( "VentanaMain", "CSearch", "ItemCount" )
      DO EVENTS
      c := c + 'SEARCH ' + GetProperty( "VentanaMain", "CSearch", "item", i ) + Hb_OsNewLine()
   Next i
   
   For i:=1 to len( vLastOpen )             
      DO EVENTS
      if !empty( vLastOpen[i] )
         c := c + 'LASTOPEN ' + vLastOpen[i] + Hb_OsNewLine()
      endif
   Next i
   
   if !PUB_bLite
      QPM_MemoWrit( PUB_cQPM_Folder + DEF_SLASH + 'QPM_' + PUB_cQPM_Version3 + '.cfg', c )
   endif
Return .T.

/* eof */
