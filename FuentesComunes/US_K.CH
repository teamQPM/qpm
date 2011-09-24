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

// Estas son definiciones temporales hasta que se implementen definitivamente

#xcommand ON KEY SPACE [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , 0 , VK_SPACE , <{action}> )

#xcommand RELEASE KEY SPACE OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , 0 , VK_SPACE )

#xcommand ON KEY SHIFT+SUBTRACT [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_SHIFT , VK_SUBTRACT , <{action}> )

#xcommand RELEASE KEY SHIFT+SUBTRACT OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_SHIFT , VK_SUBTRACT  )

#xcommand ON KEY SHIFT+ADD      [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_SHIFT , VK_ADD      , <{action}> )

#xcommand RELEASE KEY SHIFT+ADD      OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_SHIFT , VK_ADD       )

#xcommand RELEASE KEY SUBTRACT OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , 0 , VK_SUBTRACT  )

#xcommand PUSH KEY ENTER ;
=> ;
_PushKey ( VK_RETURN )

#xcommand PUSH KEY RIGHT ;
=> ;
_PushKey ( VK_RIGHT )

#xcommand PUSH KEY LEFT ;
=> ;
_PushKey ( VK_LEFT )

#xcommand PUSH KEY HOME ;
=> ;
_PushKey ( VK_HOME )

#xcommand PUSH KEY END ;
=> ;
_PushKey ( VK_END )


// Letter and Numbers Keys

#xcommand ON KEY A [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , 0 , VK_A , <{action}> )

#xcommand ON KEY B [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , 0 , VK_B , <{action}> )

#xcommand ON KEY C [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , 0 , VK_C , <{action}> )

#xcommand ON KEY D [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , 0 , VK_D , <{action}> )

#xcommand ON KEY E [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , 0 , VK_E , <{action}> )

#xcommand ON KEY F [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , 0 , VK_F , <{action}> )

#xcommand ON KEY G [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , 0 , VK_G , <{action}> )

#xcommand ON KEY H [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , 0 , VK_H , <{action}> )

#xcommand ON KEY I [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , 0 , VK_I , <{action}> )

#xcommand ON KEY J [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , 0 , VK_J , <{action}> )

#xcommand ON KEY K [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , 0 , VK_K , <{action}> )

#xcommand ON KEY L [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , 0 , VK_L , <{action}> )

#xcommand ON KEY M [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , 0 , VK_M , <{action}> )

#xcommand ON KEY N [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , 0 , VK_N , <{action}> )

#xcommand ON KEY O [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , 0 , VK_O , <{action}> )

#xcommand ON KEY P [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , 0 , VK_P , <{action}> )

#xcommand ON KEY Q [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , 0 , VK_Q , <{action}> )

#xcommand ON KEY R [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , 0 , VK_R , <{action}> )

#xcommand ON KEY S [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , 0 , VK_S , <{action}> )

#xcommand ON KEY T [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , 0 , VK_T , <{action}> )

#xcommand ON KEY U [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , 0 , VK_U , <{action}> )

#xcommand ON KEY V [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , 0 , VK_V , <{action}> )

#xcommand ON KEY W [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , 0 , VK_W , <{action}> )

#xcommand ON KEY X [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , 0 , VK_X , <{action}> )

#xcommand ON KEY Y [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , 0 , VK_Y , <{action}> )

#xcommand ON KEY Z [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , 0 , VK_Z , <{action}> )

#xcommand ON KEY 0 [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , 0 , VK_0 , <{action}> )

#xcommand ON KEY 1 [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , 0 , VK_1 , <{action}> )

#xcommand ON KEY 2 [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , 0 , VK_2 , <{action}> )

#xcommand ON KEY 3 [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , 0 , VK_3 , <{action}> )

#xcommand ON KEY 4 [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , 0 , VK_4 , <{action}> )

#xcommand ON KEY 5 [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , 0 , VK_5 , <{action}> )

#xcommand ON KEY 6 [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , 0 , VK_6 , <{action}> )

#xcommand ON KEY 7 [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , 0 , VK_7 , <{action}> )

#xcommand ON KEY 8 [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , 0 , VK_8 , <{action}> )

#xcommand ON KEY 9 [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , 0 , VK_9 , <{action}> )

// Release

#xcommand RELEASE KEY A OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , 0 , VK_A   )

#xcommand RELEASE KEY B OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , 0 , VK_B   )

#xcommand RELEASE KEY C OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , 0 , VK_C   )

#xcommand RELEASE KEY D OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , 0 , VK_D   )

#xcommand RELEASE KEY E OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , 0 , VK_E   )

#xcommand RELEASE KEY F OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , 0 , VK_F   )

#xcommand RELEASE KEY G OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , 0 , VK_G   )

#xcommand RELEASE KEY H OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , 0 , VK_H   )

#xcommand RELEASE KEY I OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , 0 , VK_I   )

#xcommand RELEASE KEY J OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , 0 , VK_J   )

#xcommand RELEASE KEY K OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , 0 , VK_K   )

#xcommand RELEASE KEY L OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , 0 , VK_L   )

#xcommand RELEASE KEY M OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , 0 , VK_M   )

#xcommand RELEASE KEY N OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , 0 , VK_N   )

#xcommand RELEASE KEY O OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , 0 , VK_O   )

#xcommand RELEASE KEY P OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , 0 , VK_P   )

#xcommand RELEASE KEY Q OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , 0 , VK_Q   )

#xcommand RELEASE KEY R OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , 0 , VK_R   )

#xcommand RELEASE KEY S OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , 0 , VK_S   )

#xcommand RELEASE KEY T OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , 0 , VK_T   )

#xcommand RELEASE KEY U OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , 0 , VK_U   )

#xcommand RELEASE KEY V OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , 0 , VK_V   )

#xcommand RELEASE KEY W OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , 0 , VK_W   )

#xcommand RELEASE KEY X OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , 0 , VK_X   )

#xcommand RELEASE KEY Y OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , 0 , VK_Y   )

#xcommand RELEASE KEY Z OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , 0 , VK_Z   )

#xcommand RELEASE KEY 0 OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , 0 , VK_0   )

#xcommand RELEASE KEY 1 OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , 0 , VK_1   )

#xcommand RELEASE KEY 2 OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , 0 , VK_2   )

#xcommand RELEASE KEY 3 OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , 0 , VK_3   )

#xcommand RELEASE KEY 4 OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , 0 , VK_4   )

#xcommand RELEASE KEY 5 OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , 0 , VK_5   )

#xcommand RELEASE KEY 6 OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , 0 , VK_6   )

#xcommand RELEASE KEY 7 OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , 0 , VK_7   )

#xcommand RELEASE KEY 8 OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , 0 , VK_8   )

#xcommand RELEASE KEY 9 OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , 0 , VK_9   )

/* eof */
