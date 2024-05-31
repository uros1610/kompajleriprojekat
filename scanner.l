%{

#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

#include "parser.tab.h"
#include "greske.h"

int red = 1;
int kolona = 1;


%}

%x LINE_COMMENT
%x MULTILINE_COMMENT

%%
"\n" {red++; kolona = 1;}

"IF"                                {kolona+=yyleng; return TOKEN_IF;}
"ELSE"                              {kolona+=yyleng; return TOKEN_ELSE;}
"BREAK"                             {kolona+=yyleng; return TOKEN_BREAK;}
"FOR"                               {kolona+=yyleng; return TOKEN_FOR;}
"WHILE"                             {kolona+=yyleng; return TOKEN_WHILE;}
"TRUE"                              {kolona+=yyleng; yylval.bool_value = true; return TOKEN_TRUE;}
"FALSE"                             {kolona+=yyleng; yylval.bool_value = false; return TOKEN_FALSE;}
"INT"                               {kolona+=yyleng; return TOKEN_INTIDENT;}
"STRING"                            {kolona+=yyleng; return TOKEN_STRINGIDENT;}
"BOOL"                              {kolona+=yyleng; return TOKEN_BOOLIDENT;}
"DOUBLE"                            {kolona+=yyleng; return TOKEN_DOUBLEIDENT;}
"RETURN"                            {kolona+=yyleng; return TOKEN_RETURN;}
"THIS"                              {kolona+=yyleng; return TOKEN_THIS;}
"LET"                               {kolona+=yyleng; return TOKEN_LET;}
"IN"                                {kolona+=yyleng; return TOKEN_IN;}
"READ"                              {kolona+=yyleng; return TOKEN_READ;}
"WRITE"                             {kolona+=yyleng; return TOKEN_WRITE;}
"END"                               {kolona+=yyleng; return TOKEN_END;}
"SKIP"                              {kolona+=yyleng; return TOKEN_SKIP;}
"FI"                                {kolona+=yyleng; return TOKEN_FI;}
"INTCONST"                          {kolona+=yyleng; return TOKEN_INTCONST;}
"DOUBLECONST"                       {kolona+=yyleng; return TOKEN_DOUBLECONST;}
"BOOLCONST"                         {kolona+=yyleng; return TOKEN_BOOLCONST;}
"STRINGCONST"                       {kolona+=yyleng; return TOKEN_STRINGCONST;}
"DO"                                {kolona+=yyleng; return TOKEN_DO;}
"THEN"                              {kolona+=yyleng; return TOKEN_THEN;}

[a-zA-Z][0-9a-zA-Z\_]*                      { kolona+=yyleng;  if(yyleng > 31) {predugacakIdentifikator(red,kolona,yytext);} yylval.ident = (char*) strdup(yytext); return TOKEN_IDENT;}
\"[^\n\"]*\"                                { kolona+=yyleng; char* s = malloc(yyleng-1); strncpy(s,yytext+1,yyleng-2); s[yyleng-2] = '\0'; yylval.str_value = s;  return TOKEN_STRING;}
0|(\-?[1-9][0-9]*)                          { kolona+=yyleng; yylval.int_value = atoi(yytext); return TOKEN_INT;}
(0x|0X)(0|([1-9A-Fa-f][0-9A-Fa-f]*))        { kolona+=yyleng; int val = strtol(yytext+2,NULL,16); yylval.int_value = val; return TOKEN_INT;}
(0|(\-?[1-9][0-9]*))\.[0-9]*                { kolona+=yyleng; char* kraj;  yylval.dbl_value = strtod(yytext,&kraj); return TOKEN_DOUBLE;}
(0|(\-?[1-9][0-9]*))\.[0-9]*(E|e)\+[0-9]*   { kolona+=yyleng; char* kraj;   yylval.dbl_value = strtod(yytext,&kraj); return TOKEN_DOUBLE;} 
(0|(\-?[1-9][0-9]*))\.[0-9]*(E|e)\-[0-9]*   { kolona+=yyleng; char* kraj;   yylval.dbl_value = strtod(yytext,&kraj); return TOKEN_DOUBLE;} 

\"(.*\n+.*)+\"                              {kolona+=yyleng; int i = 0; while(i < yyleng) {if(yytext[i] == '\n') {red++; kolona = 1;} i++;} noviRedString(red,kolona,yytext);}
\"[^\n\"]*                                  {kolona+=yyleng; nezatvorenString(red,kolona,yytext);}
(0|([1-9][0-9]*))(E|e)\+[0-9]*              {kolona+=yyleng; bezTacke(red,kolona,yytext);}
(0|([1-9][0-9]*))(E|e)\-[0-9]*              {kolona+=yyleng; bezTacke(red,kolona,yytext);}


\[           {kolona+=yyleng; return TOKEN_LEFTBRACKET;}
\]           {kolona+=yyleng; return TOKEN_RIGHTBRACKET;}

[ \t\r\n]     {}
"\\"          { kolona+=yyleng; return TOKEN_FWSLASH;}
"::="         { kolona+=yyleng; return TOKEN_DOTSEQ;}
";"           { kolona+=yyleng; return TOKEN_SC;}
"+"           { kolona+=yyleng; return TOKEN_PLUS;}
"-"           { kolona+=yyleng; return TOKEN_MINUS;}
"*"           { kolona+=yyleng; return TOKEN_MUL;}
"/"           { kolona+=yyleng; return TOKEN_DIV;}
"%"           { kolona+=yyleng; return TOKEN_MOD;}
"<"           { kolona+=yyleng; return TOKEN_LE;}
"<="          { kolona+=yyleng; return TOKEN_LEQ;}
">"           { kolona+=yyleng; return TOKEN_GE;}
">="          { kolona+=yyleng; return TOKEN_GEQ;}
"="           { kolona+=yyleng; return TOKEN_EQ;}
"=="          { kolona+=yyleng; return TOKEN_ISEQ;}
"!="          { kolona+=yyleng; return TOKEN_ISNOTEQ;}
"&&"          { kolona+=yyleng; return TOKEN_AND;}
"||"          { kolona+=yyleng; return TOKEN_OR;}
"!"           { kolona+=yyleng; return TOKEN_EXCLAM;}
","           { kolona+=yyleng; return TOKEN_COMMA;}
"."           { kolona+=yyleng; return TOKEN_DOT;}
"("           { kolona+=yyleng; return TOKEN_LEFTPAR;}
")"           { kolona+=yyleng; return TOKEN_RIGHTPAR;}

"//"                { kolona+=yyleng; 
                    BEGIN(LINE_COMMENT);
                    }



"/*"                {
                        BEGIN(MULTILINE_COMMENT);
                    }


<LINE_COMMENT>{
"\n"       {red+=1; kolona = 1; BEGIN(INITIAL);}
"//"       {kolona += yyleng; ugnjezdenJednolinijskiKomentar(red,kolona);}
.       {}
}

<MULTILINE_COMMENT>{ 

<<EOF>> { kolona+=yyleng; nezatvorenKomentar(red,kolona); return;}

"/*"    {kolona += yyleng; ugnjezdenViselinijskiKomentar(red,kolona);}

"*/"    {kolona += yyleng; BEGIN(INITIAL); } 
"\n"    {red+=1; kolona = 1;}
.       {kolona += yyleng; } 
}



%%