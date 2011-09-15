// if US_DbUseArea( .T. , "DBFCDX" , PRI_COMPATIBILITY_DATABASE , "__HOTCOMPAT" )
//    if AScan( DbStruct() , { |x| x[1] == "HR_UNIQUE" } ) == 0
//       DbClosearea( "__HOTCOMPAT" )
//       US_DB_CMP( US_FileNameOnlyPathAndName( PRI_COMPATIBILITY_DATABASE ) , "ADD" , "HR_UNIQUE" , "C" , 32 , 0 )
//       US_DbUseArea( .T. , "DBFCDX" , PRI_COMPATIBILITY_DATABASE , "__HOTCOMPAT" )
//       REPLACE HR_UNIQUE with HB_MD5( HR_HASH + HB_MD5( US_ExtractMemoKey( HR_DATA , "VERSION_COMPUTER" ) ) + HB_MD5( US_ExtractMemoKey( HR_DATA , "VERSION_USER" ) ) + HB_MD5( US_ExtractMemoKey( HR_DATA , "VERSION_DATETIME" ) ) ) ALL
//    else
//    endif
//    DbCloseArea( "__HOTCOMPAT" )
// else
//    US_Log( "Unable to open Hot Recovery Database for Checking Compatibility: " + PRI_COMPATIBILITY_DATABASE )
//    return .F.
// endif
