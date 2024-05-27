%{

#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

#include "parser.tab.h"
#include "greske.h"

int cnt = 1;
int column = 1;


%}

%x LINE_COMMENT
%x MULTILINE_COMMENT

%%
"\n" {cnt++; column = 1;}

"IF"                               {column+=yyleng; return TOKEN_IF;}
"ELSE"                             {column+=yyleng; return TOKEN_ELSE;}
"BREAK"                            {column+=yyleng; return TOKEN_BREAK;}
"FOR"                              { column+=yyleng; return TOKEN_FOR;}
"WHILE"                            { column+=yyleng; return TOKEN_WHILE;}
"TRUE"                             { column+=yyleng; return TOKEN_TRUE;}
"FALSE"                            { column+=yyleng; return TOKEN_FALSE;}
"INT"                              { column+=yyleng; return TOKEN_INTIDENT;}
"STRING"                           { column+=yyleng; return TOKEN_STRINGIDENT;}
"BOOL"                             { column+=yyleng; return TOKEN_BOOLIDENT;}
"DOUBLE"                           { column+=yyleng; return TOKEN_DOUBLEIDENT;}
"RETURN"                           { column+=yyleng; return TOKEN_RETURN;}
"THIS"                             { column+=yyleng; return TOKEN_THIS;}
"LET"                              { column+=yyleng; return TOKEN_LET;}
"IN"                               { column+=yyleng; return TOKEN_IN;}
"READ"                             { column+=yyleng; return TOKEN_READ;}
"WRITE"                            { column+=yyleng; return TOKEN_WRITE;}
"END"                              { column+=yyleng; return TOKEN_END;}
"SKIP"                             { column+=yyleng; return TOKEN_SKIP;}
"FI"                               { column+=yyleng; return TOKEN_FI;}
"INTCONST"                         { column+=yyleng; return TOKEN_INTCONST;}
"DOUBLECONST"                      { column+=yyleng; return TOKEN_DOUBLECONST;}
"BOOLCONST"                        { column+=yyleng; return TOKEN_BOOLCONST;}
"STRINGCONST"                      { column+=yyleng; return TOKEN_STRINGCONST;}

[a-zA-Z][0-9a-zA-Z\_]*                      { column+=yyleng;  if(yyleng > 31) {predugacakIdentifikator(cnt,column,yytext);} yylval.ident = (char*) strdup(yytext); return TOKEN_IDENT;}
\"[^\n\"]*\"                                { column+=yyleng; char* s = malloc(yyleng-1); strncpy(s,yytext+1,yyleng-2); s[yyleng-2] = '\0'; yylval.str_value = s;  return TOKEN_STRING;}
0|(\-?[1-9][0-9]*)                          { column+=yyleng; yylval.int_value = atoi(yytext); return TOKEN_INT;}
(0x|0X)(0|([1-9A-Fa-f][0-9A-Fa-f]*))        { column+=yyleng; int val = strtol(yytext+2,NULL,16); yylval.int_value = val; return TOKEN_INT;}
(0|(\-?[1-9][0-9]*))\.[0-9]*                { column+=yyleng; char* kraj;  yylval.dbl_value = strtod(yytext,&kraj); return TOKEN_DOUBLE;}
(0|(\-?[1-9][0-9]*))\.[0-9]*(E|e)\+[0-9]*   { column+=yyleng; char* kraj;   yylval.dbl_value = strtod(yytext,&kraj); return TOKEN_DOUBLE;} 
(0|(\-?[1-9][0-9]*))\.[0-9]*(E|e)\-[0-9]*   { column+=yyleng; char* kraj;   yylval.dbl_value = strtod(yytext,&kraj); return TOKEN_DOUBLE;} 

\"(.*\n+.*)+\"                              {column+=yyleng; int i = 0; while(i < yyleng) {if(yytext[i] == '\n') {cnt++; column = 1;} i++;} noviRedString(cnt,column,yytext);}
\"[^\n\"]*                                  {column+=yyleng; nezatvorenString(cnt,column,yytext);}
(0|([1-9][0-9]*))(E|e)\+[0-9]*              {column+=yyleng; bezTacke(cnt,column,yytext);}
(0|([1-9][0-9]*))(E|e)\-[0-9]*              {column+=yyleng; bezTacke(cnt,column,yytext);}



[ \t\r\n]     {}
"\\"          { column+=yyleng; return TOKEN_FWSLASH;}
"::="         { column+=yyleng; return TOKEN_DOTSEQ;}
";"           { column+=yyleng; return TOKEN_SC;}
"+"           { column+=yyleng; return TOKEN_PLUS;}
"-"           { column+=yyleng; return TOKEN_MINUS;}
"*"           { column+=yyleng; return TOKEN_MUL;}
"/"           { column+=yyleng; return TOKEN_DIV;}
"%"           { column+=yyleng; return TOKEN_MOD;}
"<"           { column+=yyleng; return TOKEN_LE;}
"<="          { column+=yyleng; return TOKEN_LEQ;}
">"           { column+=yyleng; return TOKEN_GE;}
">="          { column+=yyleng; return TOKEN_GEQ;}
"="           { column+=yyleng; return TOKEN_EQ;}
"=="          { column+=yyleng; return TOKEN_ISEQ;}
"!="          { column+=yyleng; return TOKEN_ISNOTEQ;}
"&&"          { column+=yyleng; return TOKEN_AND;}
"||"          { column+=yyleng; return TOKEN_OR;}
"!"           { column+=yyleng; return TOKEN_EXCLAM;}
","           { column+=yyleng; return TOKEN_COMMA;}
"."           { column+=yyleng; return TOKEN_DOT;}
"("           { column+=yyleng; return TOKEN_LEFTPAR;}
")"           { column+=yyleng; return TOKEN_RIGHTPAR;}

"//"                { column+=yyleng; 
                    BEGIN(LINE_COMMENT);
                    }



"/*"                {
                        BEGIN(MULTILINE_COMMENT);
                    }


<LINE_COMMENT>{
"\n"       {cnt+=1; column = 1; BEGIN(INITIAL);}
"//"       {column += yyleng; ugnjezdenJednolinijskiKomentar(cnt,column);}
.       {}
}

<MULTILINE_COMMENT>{ 

<<EOF>> { column+=yyleng; nezatvorenKomentar(cnt,column); return;}

"/*"    {column += yyleng; ugnjezdenViselinijskiKomentar(cnt,column);}

"*/"    {column += yyleng; BEGIN(INITIAL); } 
"\n"    {cnt+=1; column = 1;}
.       {column += yyleng; } 
}



%%