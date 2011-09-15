#ifndef __US_LOG__
   #define __US_LOG__
   #include <windows.h>
   #include <stdio.h>
   #include <string.h>
   #include <time.h>

   int us_log( char * cTexto , int displayo )
   {
     // Para codigo de retorno
     int reto=0;
     // Handle del file de salida
     FILE * pFile;
     char cError[255];
     // String auxiliar para armar el texto de salida
     char Aux0cTexto[1024];
     char Aux1cTexto[30];
     char * Aux2cTexto;
     // Variables para obtener el nombre del EXE
     char szFileName[MAX_PATH];
     HINSTANCE hInstance = GetModuleHandle(NULL);
     // Obtengo la fecha y hora
     time_t rawtime;
     struct tm * timeinfo;
     time( &rawtime );
     timeinfo = localtime( &rawtime );
     // Armo string de salida
     strcpy( Aux0cTexto , cTexto );
     strcpy( Aux1cTexto , asctime(timeinfo) );
     Aux2cTexto = strtok( Aux1cTexto , "\n" );
     strcpy( Aux1cTexto , Aux2cTexto );
     strcat( Aux1cTexto , " " );
     strcat( Aux1cTexto , Aux0cTexto );
     strcat( Aux1cTexto , "\n" );
     // Obtengo el nombre del archivo de salida
     GetModuleFileName(hInstance, szFileName, MAX_PATH);
     strcat( szFileName , ".LOG" );
     // Abro el archivo de salida como Append
     pFile = fopen(szFileName , "a");
     // Chequeo error en apertura de file
     if (pFile==NULL)
        {
        strcpy( cError , "Open Error for file " );
        strcat( cError , szFileName );
        reto = 1;
        }
     else
        {
        // Grabo el archivo de salida con el string
        fwrite(Aux1cTexto , 1 , strlen(Aux1cTexto) , pFile);
        if (ferror(pFile))
           {
           strcpy( cError , "Write Error for file " );
           strcat( cError , szFileName );
           reto = 1;
           }
        // Cierro el archivo de salida
        fclose(pFile);
        }
     if ( !(displayo == 0) )
        {
        if (reto == 0)
           {
           MessageBox(0, Aux1cTexto, szFileName, MB_OK | MB_ICONINFORMATION);
           }
        else
           {
           MessageBox(0, cError, "ERROR", MB_OK | MB_ICONERROR);
           }
        }
     else
        {
        if (reto == 1)
           {
           MessageBox(0, cError, "ERROR", MB_OK | MB_ICONERROR);
           }
        }
     return reto;
   }
#endif
