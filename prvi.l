%{

#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

#include "prvi.tab.h"

int cnt = 1;


%}

%x LINE_COMMENT
%x MULTILINE_COMMENT

%%
"\n" {cnt++;}
\"[^\n\"]*\"                            {char* s = malloc(yyleng-1); strncpy(s,yytext+1,yyleng-2); s[yyleng-2] = '\0'; yylval.int_value = 0;  return TOKEN_INT;}
0|([1-9][0-9]*)                         {yylval.int_value = atoi(yytext); return TOKEN_INT;}
(0x|0X)(0|([1-9A-Fa-f][0-9A-Fa-f]*))    {int val = strtol(yytext+2,NULL,16); yylval.int_value = val; return TOKEN_INT;}
(0|([1-9][0-9]*))\.[0-9]*                 {char* kraj;   yylval.dbl_value = strtod(yytext,&kraj); return TOKEN_DOUBLE;}
(0|([1-9][0-9]*))\.[0-9]*(E|e)\+[0-9]*    {char* kraj;   yylval.dbl_value = strtod(yytext,&kraj); return TOKEN_DOUBLE;} 
(0|([1-9][0-9]*))\.[0-9]*(E|e)\-[0-9]*    {char* kraj;   yylval.dbl_value = strtod(yytext,&kraj); return TOKEN_DOUBLE;} 

\"[^\n\"]*                              {printf("greska na liniji %d, nezatvoren string\n",cnt); return;}
(0|([1-9][0-9]*))(E|e)\+[0-9]*            {printf("greska na liniji %d nema tacke\n",cnt); return;}
(0|([1-9][0-9]*))(E|e)\-[0-9]*            {printf("greska na liniji %d nema tacke\n",cnt); return;}




"IF"                               {return TOKEN_IF;}
"ELSE"                             {return TOKEN_ELSE;}
"BREAK"                            {return TOKEN_BREAK;}
"FOR"                              {return TOKEN_FOR;}
"WHILE"                            {return TOKEN_WHILE;}
"TRUE"                             {return TOKEN_TRUE;}
"FALSE"                            {return TOKEN_FALSE;}
"INT"                              {return TOKEN_INTIDENT;}
"STRING"                           {return TOKEN_STRINGIDENT;}
"BOOL"                             {return TOKEN_BOOLIDENT;}
"DOUBLE"                           {return TOKEN_DOUBLEIDENT;}
"RETURN"                           {return TOKEN_RETURN;}
"THIS"                             {return TOKEN_THIS;}
"LET"                              {return TOKEN_LET;}
"IN"                               {return TOKEN_IN;}
[a-zA-Z][0-9a-zA-Z\_]*             { if(yyleng > 31) {printf("Ne moze duze od 31 karaktera");} yylval.ident = (char*) strdup(yytext); return TOKEN_IDENT;}


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
                    ;    BEGIN(LINE_COMMENT);
                    }

"/*(/*)+"      {printf("greska na liniji %d, ne mogu se ugnjezdavati komentari",cnt); return;}

"/*[\[^*/\]]" {printf("nije zatvoren komentar"); return;}

"/*"                {
                        BEGIN(MULTILINE_COMMENT);
                    }


<LINE_COMMENT>{
"\n"       { BEGIN(INITIAL);}
"//"       {printf("greska na liniji %d, ne mogu se ugnjezdavati komentari",cnt);}
.       {}
}

<MULTILINE_COMMENT>{ 
"\n"    { }

"*/"    { BEGIN(INITIAL); } 
.       { } 
}



%%