// Definiciones de Colores para MiniGui
#define US_GREEN   { 74,136,101}
#define US_RED     {192, 63, 39}
#define US_BLUE    { 45, 24,160}
#define US_CYAN    {188,219,240}
#define US_YELLOW  {219,215, 43}
#define US_BROWN   {139,106, 29}
#define US_BLACK   {  0,  0,  0}
#define US_WHITE   {255,255,255}
#define US_GREY    {192,192,192}

#xcommand ?? <texto> => US_LOG( <texto> , .T. )
#xcommand ? <texto> => US_LOG( <texto> , .T. )

#translate msginfo(<texto>) => US_LOG( <texto> , .T. )

#translate inkey(0) => US_LOG("Inkey(0) , Presione Enter" , .T. )

#include "US_i_richeditbox.ch"
