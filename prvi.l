%{

#include <string.h>
#include <stdio.h>
#include <stdlib.h>


%}

%%
(0|[1-9])[0-9]* {}
(0x|0X)(0|[1-9A-Fa-f])[0-9A-Fa-f]* {int val = strtol(yytext+2,NULL,16); printf("%d\n",val);}
(0|[1-9])[0-9]*\.[0-9]*            {printf("prepoznao1");}
(0|[1-9])[0-9]*\.[0-9]*E\+[0-9]*   {printf("prepoznao2");}
(0|[1-9])[0-9]*\.[0-9]*E\-[0-9]*   {printf("prepoznao3");}

[ \t\r\n]     {}
";"           {return TOKEN_SC;}
"+"           {return TOKEN_PLUS;}
"-"           {return TOKEN_MINUS;}
"*"           {return TOKEN_MUL;}
"/"           {return TOKEN_DIV;}
"%"           {return TOKEN_MOD;}
"<"           {return TOKEN_LE;}
"<="           {return TOKEN_LEQ;}
">"           {return TOKEN_GE;}
">="           {return TOKEN_GEQ;}
"="           {return TOKEN_EQ;}
"=="           {return TOKEN_ISEQ;}
"!="           {return TOKEN_ISNOTEQ;}
"&&"           {return TOKEN_AND;}
"||"           {return TOKEN_OR;}
"!"           {return TOKEN_EXCLAM;}
","           {return TOKEN_COMMA;}
"."           {return TOKEN_DOT;}
"("           {return TOKEN_LEFTPAR;}
")"           {return TOKEN_RIGHTPAR;}


%%