%{

#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

#include "parser.tab.h"
#include "greske.h"
#include "cvor.h"


int red = 1;
int kolona = 1;


%}

%x LINE_COMMENT
%x MULTILINE_COMMENT

%%
"\n" {red++; kolona = 1;}

"IF"                                { Cvor* t = (Cvor*) kreirajCvor("IF"); yylval.CvorPokazivac = t; kolona+=yyleng; return TOKEN_IF;}
"ELSE"                              { Cvor* t = (Cvor*) kreirajCvor("ELSE");  yylval.CvorPokazivac = t; kolona+=yyleng; return TOKEN_ELSE;}
"BREAK"                             { Cvor* t = (Cvor*) kreirajCvor("BREAK");  yylval.CvorPokazivac = t; kolona+=yyleng; return TOKEN_BREAK;}
"FOR"                               { Cvor* t = (Cvor*) kreirajCvor("FOR");  yylval.CvorPokazivac = t; kolona+=yyleng; return TOKEN_FOR;}
"WHILE"                             { Cvor* t = (Cvor*) kreirajCvor("WHILE");  yylval.CvorPokazivac = t; kolona+=yyleng; return TOKEN_WHILE;}
"TRUE"                              { Cvor* t = (Cvor*) kreirajCvor("TRUE");  yylval.CvorPokazivac = t; kolona+=yyleng; return TOKEN_TRUE;}
"FALSE"                             { Cvor* t = (Cvor*) kreirajCvor("FALSE");  yylval.CvorPokazivac = t; kolona+=yyleng; return TOKEN_FALSE;}
"INT"                               { Cvor* t = (Cvor*) kreirajCvor("INT");  yylval.CvorPokazivac = t;kolona+=yyleng; return TOKEN_INTIDENT;}
"STRING"                            { Cvor* t = (Cvor*) kreirajCvor("STRING"); yylval.CvorPokazivac = t; kolona+=yyleng; return TOKEN_STRINGIDENT;}
"BOOL"                              { Cvor* t = (Cvor*) kreirajCvor("BOOL"); yylval.CvorPokazivac = t; kolona+=yyleng; return TOKEN_BOOLIDENT;}
"DOUBLE"                            { Cvor* t = (Cvor*) kreirajCvor("DOUBLE"); yylval.CvorPokazivac = t; kolona+=yyleng; return TOKEN_DOUBLEIDENT;}
"RETURN"                            { Cvor* t = (Cvor*) kreirajCvor("RETURN"); yylval.CvorPokazivac = t; kolona+=yyleng; return TOKEN_RETURN;}
"THIS"                              { Cvor* t = (Cvor*) kreirajCvor("THIS"); yylval.CvorPokazivac = t; kolona+=yyleng; return TOKEN_THIS;}
"LET"                               { Cvor* t = (Cvor*) kreirajCvor("LET"); yylval.CvorPokazivac = t; kolona+=yyleng; return TOKEN_LET;}
"IN"                                { Cvor* t = (Cvor*) kreirajCvor("IN"); yylval.CvorPokazivac = t; kolona+=yyleng; return TOKEN_IN;}
"READ"                              { Cvor* t = (Cvor*) kreirajCvor("READ"); yylval.CvorPokazivac = t; kolona+=yyleng; return TOKEN_READ;}
"WRITE"                             { Cvor* t = (Cvor*) kreirajCvor("WRITE"); yylval.CvorPokazivac = t; kolona+=yyleng; return TOKEN_WRITE;}
"END"                               { Cvor* t = (Cvor*) kreirajCvor("END"); yylval.CvorPokazivac = t; kolona+=yyleng; return TOKEN_END;}
"SKIP"                              { Cvor* t = (Cvor*) kreirajCvor("SKIP"); yylval.CvorPokazivac = t; kolona+=yyleng; return TOKEN_SKIP;}
"FI"                                { Cvor* t = (Cvor*) kreirajCvor("FI"); yylval.CvorPokazivac = t; kolona+=yyleng; return TOKEN_FI;}
"INTCONST"                          { Cvor* t = (Cvor*) kreirajCvor("INTCONST"); yylval.CvorPokazivac = t; kolona+=yyleng; return TOKEN_INTCONST;}
"DOUBLECONST"                       { Cvor* t = (Cvor*) kreirajCvor("DOUBLECONST"); yylval.CvorPokazivac = t; kolona+=yyleng; return TOKEN_DOUBLECONST;}
"BOOLCONST"                         { Cvor* t = (Cvor*) kreirajCvor("BOOLCONST"); yylval.CvorPokazivac = t; kolona+=yyleng; return TOKEN_BOOLCONST;}
"STRINGCONST"                       { Cvor* t = (Cvor*) kreirajCvor("STRINGCONST"); yylval.CvorPokazivac = t; kolona+=yyleng; return TOKEN_STRINGCONST;}
"DO"                                { Cvor* t = (Cvor*) kreirajCvor("DO"); yylval.CvorPokazivac = t; kolona+=yyleng; return TOKEN_DO;}
"THEN"                              { Cvor* t = (Cvor*) kreirajCvor("THEN"); yylval.CvorPokazivac = t; kolona+=yyleng; return TOKEN_THEN;}

[a-zA-Z][0-9a-zA-Z\_]*                      { Cvor* t = (Cvor*) kreirajCvor(yytext);  yylval.CvorPokazivac = t; kolona+=yyleng;  if(yyleng > 31) {predugacakIdentifikator(red,kolona,yytext);}  return TOKEN_IDENT;}
\"[^\n\"]*\"                                { Cvor* t = (Cvor*) kreirajCvor(yytext); yylval.CvorPokazivac = t; kolona+=yyleng; char* s = malloc(yyleng-1); strncpy(s,yytext+1,yyleng-2); s[yyleng-2] = '\0'; return TOKEN_STRING;}
0|(\-?[1-9][0-9]*)                          { Cvor* t = (Cvor*) kreirajCvor(yytext); yylval.CvorPokazivac = t; kolona+=yyleng; return TOKEN_INT;}
(0x|0X)(0|([1-9A-Fa-f][0-9A-Fa-f]*))        { Cvor* t = (Cvor*) kreirajCvor(yytext); yylval.CvorPokazivac = t; kolona+=yyleng; int val = strtol(yytext+2,NULL,16);  return TOKEN_INT;}
(0|(\-?[1-9][0-9]*))\.[0-9]*                { Cvor* t = (Cvor*) kreirajCvor(yytext); yylval.CvorPokazivac = t; kolona+=yyleng; char* kraj; return TOKEN_DOUBLE;}
(0|(\-?[1-9][0-9]*))\.[0-9]*(E|e)\+[0-9]*   { Cvor* t = (Cvor*) kreirajCvor(yytext); yylval.CvorPokazivac = t; kolona+=yyleng; char* kraj;   return TOKEN_DOUBLE;} 
(0|(\-?[1-9][0-9]*))\.[0-9]*(E|e)\-[0-9]*   { Cvor* t = (Cvor*) kreirajCvor(yytext); yylval.CvorPokazivac = t; kolona+=yyleng; char* kraj;  return TOKEN_DOUBLE;} 

\"(.*\n+.*)+\"                              { kolona+=yyleng; int i = 0; while(i < yyleng) {if(yytext[i] == '\n') {red++; kolona = 1;} i++;} noviRedString(red,kolona,yytext);}
\"[^\n\"]*                                  { kolona+=yyleng; nezatvorenString(red,kolona,yytext);}
(0|([1-9][0-9]*))(E|e)\+[0-9]*              { kolona+=yyleng; bezTacke(red,kolona,yytext);}
(0|([1-9][0-9]*))(E|e)\-[0-9]*              { kolona+=yyleng; bezTacke(red,kolona,yytext);}


\[           { Cvor* t = (Cvor*) kreirajCvor("["); yylval.CvorPokazivac = t; kolona+=yyleng; return TOKEN_LEFTBRACKET;}
\]           { Cvor* t = (Cvor*) kreirajCvor("]"); yylval.CvorPokazivac = t; kolona+=yyleng; return TOKEN_RIGHTBRACKET;}

[ \t\r\n]     {}
"\\"          { kolona+=yyleng; return TOKEN_FWSLASH;}
"::="         { Cvor* t = (Cvor*) kreirajCvor("::="); yylval.CvorPokazivac = t; kolona+=yyleng; return TOKEN_DOTSEQ;}
";"           { Cvor* t = (Cvor*) kreirajCvor(";"); yylval.CvorPokazivac = t; kolona+=yyleng; return TOKEN_SC;}
"+"           { Cvor* t = (Cvor*) kreirajCvor("+"); yylval.CvorPokazivac = t; kolona+=yyleng; return TOKEN_PLUS;}
"-"           { Cvor* t = (Cvor*) kreirajCvor("-"); yylval.CvorPokazivac = t; kolona+=yyleng; return TOKEN_MINUS;}
"*"           { Cvor* t = (Cvor*) kreirajCvor("*"); yylval.CvorPokazivac = t; kolona+=yyleng; return TOKEN_MUL;}
"/"           { Cvor* t = (Cvor*) kreirajCvor("/"); yylval.CvorPokazivac = t; kolona+=yyleng; return TOKEN_DIV;}
"%"           { Cvor* t = (Cvor*) kreirajCvor("%"); yylval.CvorPokazivac = t; kolona+=yyleng; return TOKEN_MOD;}
"<"           { Cvor* t = (Cvor*) kreirajCvor("<"); yylval.CvorPokazivac = t; kolona+=yyleng; return TOKEN_LE;}
"<="          { Cvor* t = (Cvor*) kreirajCvor("<="); yylval.CvorPokazivac = t; kolona+=yyleng; return TOKEN_LEQ;}
">"           { Cvor* t = (Cvor*) kreirajCvor(">"); yylval.CvorPokazivac = t; kolona+=yyleng; return TOKEN_GE;}
">="          { Cvor* t = (Cvor*) kreirajCvor(">="); yylval.CvorPokazivac = t; kolona+=yyleng; return TOKEN_GEQ;}
"="           { Cvor* t = (Cvor*) kreirajCvor("="); yylval.CvorPokazivac = t; kolona+=yyleng; return TOKEN_EQ;}
"=="          { Cvor* t = (Cvor*) kreirajCvor("=="); yylval.CvorPokazivac = t; kolona+=yyleng; return TOKEN_ISEQ;}
"!="          { Cvor* t = (Cvor*) kreirajCvor("!="); yylval.CvorPokazivac = t; kolona+=yyleng; return TOKEN_ISNOTEQ;}
"&&"          { Cvor* t = (Cvor*) kreirajCvor("&&"); yylval.CvorPokazivac = t; kolona+=yyleng; return TOKEN_AND;}
"||"          { Cvor* t = (Cvor*) kreirajCvor("||"); yylval.CvorPokazivac = t; kolona+=yyleng; return TOKEN_OR;}
"!"           { Cvor* t = (Cvor*) kreirajCvor("!"); yylval.CvorPokazivac = t; kolona+=yyleng; return TOKEN_EXCLAM;}
","           { Cvor* t = (Cvor*) kreirajCvor(","); yylval.CvorPokazivac = t; kolona+=yyleng; return TOKEN_COMMA;}
"."           { Cvor* t = (Cvor*) kreirajCvor("."); yylval.CvorPokazivac = t; kolona+=yyleng; return TOKEN_DOT;}
"("           { Cvor* t = (Cvor*) kreirajCvor(")"); yylval.CvorPokazivac = t; kolona+=yyleng; return TOKEN_LEFTPAR;}
")"           { Cvor* t = (Cvor*) kreirajCvor("("); yylval.CvorPokazivac = t; kolona+=yyleng; return TOKEN_RIGHTPAR;}

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