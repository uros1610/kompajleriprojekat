%{

#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

#include "prvi.tab.h"


%}

%x LINE_COMMENT
%x MULTILINE_COMMENT

%%
\"[^\n\"]*\"                       {char* s; strncpy(s,yytext+1,yyleng-2); s[yyleng-2] = '\0'; printf("%s",s); return TOKEN_STRING;}
(0|[1-9])[0-9]*                    {yylval.int_value = atoi(yytext); return TOKEN_INT;}
(0x|0X)(0|[1-9A-Fa-f])[0-9A-Fa-f]* {int val = strtol(yytext+2,NULL,16); yylval.int_value = val; return TOKEN_INT;}
(0|[1-9])[0-9]*\.[0-9]*            {yylval.dbl_value = strtod(yytext,NULL); return TOKEN_DOUBLE;}
(0|[1-9])[0-9]*\.[0-9]*E\+[0-9]*   {return TOKEN_DOUBLE;} // treba yylval.dbl_value-u dodijeliti vrijednost
(0|[1-9])[0-9]*\.[0-9]*E\-[0-9]*   {return TOKEN_DOUBLE;} // treba yylval.dbl_value-u dodijeliti vrijednost
[a-zA-Z][0-9a-zA-Z\_]*             { if(yyleng > 31) {printf("Ne moze duze od 31 karaktera");} yylval.ident = (char*) strdup(yytext); return TOKEN_IDENT;}

  

"IF"                               {return TOKEN_IF;}
"ELSE"                             {return TOKEN_ELSE;}
"BREAK"                            {return TOKEN_BREAK;}
"FOR"                              {return TOKEN_FOR;}
"WHILE"                            {return TOKEN_WHILE;}
"TRUE"                             {return TOKEN_TRUE;}
"FALSE"                            {return TOKEN_FALSE;}


[ \t\r\n]     {}
";"           {return TOKEN_SC;}
"+"           {return TOKEN_PLUS;}
"-"           {return TOKEN_MINUS;}
"*"           {return TOKEN_MUL;}
"/"           {return TOKEN_DIV;}
"%"           {return TOKEN_MOD;}
"<"           {return TOKEN_LE;}
"<="          {return TOKEN_LEQ;}
">"           {return TOKEN_GE;}
">="          {return TOKEN_GEQ;}
"="           {return TOKEN_EQ;}
"=="          {return TOKEN_ISEQ;}
"!="          {return TOKEN_ISNOTEQ;}
"&&"          {return TOKEN_AND;}
"||"          {return TOKEN_OR;}
"!"           {return TOKEN_EXCLAM;}
","           {return TOKEN_COMMA;}
"."           {return TOKEN_DOT;}
"("           {return TOKEN_LEFTPAR;}
")"           {return TOKEN_RIGHTPAR;}

"//"                {
                    printf("usao u komentar");    BEGIN(LINE_COMMENT);
                    }

"/*"                {
                        BEGIN(MULTILINE_COMMENT);
                    }


<LINE_COMMENT>{
"\n"       { BEGIN(INITIAL);} 
.       {} 
}

<MULTILINE_COMMENT>{ 
"\n"    { }
"*/"    {printf("zavrsio sa komentarom"); BEGIN(INITIAL); } 
.       { } 
}



%%