/*
 * $Id$
 */

/*
 *    QPM - QAC based Project Manager
 *
 *    Copyright 2011-2020 Fernando Yurisich <fernando.yurisich@gmail.com>
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

// if US_Use( .T. , "DBFCDX" , PRI_COMPATIBILITY_DATABASE , "__HOTCOMPAT" )
//    if AScan( DbStruct() , { |x| x[1] == "HR_UNIQUE" } ) == 0
//       DbClosearea( "__HOTCOMPAT" )
//       US_DB_CMP( US_FileNameOnlyPathAndName( PRI_COMPATIBILITY_DATABASE ) , "ADD" , "HR_UNIQUE" , "C" , 32 , 0 )
//       if US_Use( .T. , "DBFCDX" , PRI_COMPATIBILITY_DATABASE , "__HOTCOMPAT" )
//          REPLACE HR_UNIQUE with HB_MD5( HR_HASH + HB_MD5( US_ExtractMemoKey( HR_DATA , "VERSION_COMPUTER" ) ) + HB_MD5( US_ExtractMemoKey( HR_DATA , "VERSION_USER" ) ) + HB_MD5( US_ExtractMemoKey( HR_DATA , "VERSION_DATETIME" ) ) ) ALL
//          DbCloseArea( "__HOTCOMPAT" )
//       endif
//    else
//       DbCloseArea( "__HOTCOMPAT" )
//    endif
// else
//    US_Log( "Unable to open Hot Recovery Database for Checking Compatibility: " + PRI_COMPATIBILITY_DATABASE )
//    return .F.
// endif

/* eof */
