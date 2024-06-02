%{

#include <stdlib.h>
#include <stdio.h>
#include <stdbool.h>
#include <string.h>

#include "greske.h"
#include "cvor.h"
#include "red.h"

void yyerror(const char* s);

 Cvor* korijen;


%}

%union { 

struct Cvor* CvorPokazivac;

}


%start program
%token<CvorPokazivac> TOKEN_SC
%token<CvorPokazivac> TOKEN_INT
%token<CvorPokazivac> TOKEN_STRING
%token<CvorPokazivac> TOKEN_DOUBLE
%token<CvorPokazivac> TOKEN_IDENT
%token<CvorPokazivac> TOKEN_TRUE
%token<CvorPokazivac> TOKEN_FALSE
%token<CvorPokazivac> TOKEN_PLUS
%token<CvorPokazivac> TOKEN_MINUS
%token<CvorPokazivac> TOKEN_MUL
%token<CvorPokazivac> TOKEN_DIV
%token<CvorPokazivac> TOKEN_MOD
%token<CvorPokazivac> TOKEN_LE
%token<CvorPokazivac> TOKEN_LEQ
%token<CvorPokazivac> TOKEN_GE
%token<CvorPokazivac> TOKEN_GEQ
%token<CvorPokazivac> TOKEN_EQ
%token<CvorPokazivac> TOKEN_ISEQ
%token<CvorPokazivac> TOKEN_ISNOTEQ
%token<CvorPokazivac> TOKEN_AND
%token<CvorPokazivac> TOKEN_OR
%token<CvorPokazivac> TOKEN_EXCLAM
%token<CvorPokazivac> TOKEN_COMMA
%token<CvorPokazivac> TOKEN_DOT
%token<CvorPokazivac> TOKEN_LEFTPAR
%token<CvorPokazivac> TOKEN_RIGHTPAR
%token<CvorPokazivac> TOKEN_RIGHTBRACKET
%token<CvorPokazivac> TOKEN_LEFTBRACKET
%token<CvorPokazivac> TOKEN_FOR
%token<CvorPokazivac> TOKEN_WHILE
%token<CvorPokazivac> TOKEN_BREAK
%token<CvorPokazivac> TOKEN_IF
%token<CvorPokazivac> TOKEN_ELSE
%token<CvorPokazivac> TOKEN_INTIDENT
%token<CvorPokazivac> TOKEN_STRINGIDENT
%token<CvorPokazivac> TOKEN_BOOLIDENT
%token<CvorPokazivac> TOKEN_DOUBLEIDENT
%token<CvorPokazivac> TOKEN_RETURN
%token<CvorPokazivac> TOKEN_THIS
%token<CvorPokazivac> TOKEN_LET;
%token<CvorPokazivac> TOKEN_IN;
%token<CvorPokazivac> TOKEN_READ
%token<CvorPokazivac> TOKEN_WRITE
%token<CvorPokazivac> TOKEN_END
%token<CvorPokazivac> TOKEN_SKIP
%token<CvorPokazivac> TOKEN_DOTSEQ
%token<CvorPokazivac> TOKEN_FWSLASH
%token<CvorPokazivac> TOKEN_FI
%token<CvorPokazivac> TOKEN_INTCONST
%token<CvorPokazivac> TOKEN_STRINGCONST
%token<CvorPokazivac> TOKEN_BOOLCONST
%token<CvorPokazivac> TOKEN_DOUBLECONST
%token<CvorPokazivac> TOKEN_DO
%token<CvorPokazivac> TOKEN_THEN



%left TOKEN_AND TOKEN_OR
%nonassoc TOKEN_EQ TOKEN_ISNOTEQ TOKEN_ISEQ TOKEN_LE TOKEN_LEQ TOKEN_GE TOKEN_GEQ
%left TOKEN_PLUS TOKEN_MINUS
%left TOKEN_MUL TOKEN_DIV TOKEN_MOD

%type <CvorPokazivac> program
%type <CvorPokazivac> declarations
%type <CvorPokazivac> declaration


%type <CvorPokazivac>expressionInt
%type <CvorPokazivac>statInt

%type <CvorPokazivac>expressionDouble
%type <CvorPokazivac>statDouble

%type <CvorPokazivac>expressionString
%type <CvorPokazivac>statString

%type <CvorPokazivac>expressionBool
%type <CvorPokazivac>statBool
%type <CvorPokazivac>statBoolSC

%type <CvorPokazivac> expressionLE
%type <CvorPokazivac> expressionLEQ
%type <CvorPokazivac> expressionGE
%type <CvorPokazivac> expressionGEQ
%type <CvorPokazivac> expressionISEQ
%type <CvorPokazivac> expressionISNOTEQ
%type <CvorPokazivac> S

%%


program: {}
| TOKEN_LET TOKEN_LEFTBRACKET declarations TOKEN_RIGHTBRACKET TOKEN_IN S TOKEN_END {
Cvor* letSin = $1;
Cvor* lijevaZagrada = $2;
Cvor* deklaracije = $3;
Cvor* desnaZagrada = $4;
Cvor* inSin = $5;
Cvor* naredbeSin = $6;
Cvor* endSin = $7;

dodajSina(korijen,letSin);
dodajSina(korijen,lijevaZagrada);
dodajSina(korijen,deklaracije);
dodajSina(korijen,desnaZagrada);
dodajSina(korijen,inSin);
dodajSina(korijen,naredbeSin);
dodajSina(korijen,endSin);



}

;

declarations: {$$ = kreirajCvor("declarations");}
|  declarations declaration {dodajSina($$,$2);}

declaration:
    TOKEN_INTIDENT TOKEN_IDENT {
        $$ = kreirajCvor("IntDeclaration");
       
        dodajSina($$, $1);
        dodajSina($$, $2);
    }
|   TOKEN_STRINGIDENT TOKEN_IDENT {
        $$ = kreirajCvor("StringDeclaration");
      
        dodajSina($$, $1);
        dodajSina($$, $2);
    }
|   TOKEN_DOUBLEIDENT TOKEN_IDENT {
        $$ = kreirajCvor("DoubleDeclaration");
      
        dodajSina($$, $1);
        dodajSina($$, $2);
    }
|   TOKEN_BOOLIDENT TOKEN_IDENT {
        $$ = kreirajCvor("BoolDeclaration");
       
        dodajSina($$, $1);
        dodajSina($$, $2);
    }
;



S:                                                                                      {$$ = kreirajCvor("statements");}
| S statInt                                                                             {dodajSina($1,$2);}                                                                            
   | S statDouble                                                                       {dodajSina($1,$2);}
   | S statString                                                                       {dodajSina($1,$2);}
   | S statBool                                                                         {}
   | S statWhile                                                                        {}
   | S statBoolSC                                                                       {}
   | TOKEN_IF TOKEN_LEFTPAR statBool TOKEN_RIGHTPAR TOKEN_THEN  S TOKEN_FI              {}
   | TOKEN_IF TOKEN_LEFTPAR statBool TOKEN_RIGHTPAR TOKEN_THEN S TOKEN_ELSE S TOKEN_FI  {}
   | S statFor                                                                          {}
   | S statFunc                                                                         {}
   | S statWrite                                                                        {}
   | S statRead                                                                         {}
   
;

forLoopBody:
|   statInt forLoopBody                                                                                     {}
|   statDouble forLoopBody                                                                                  {}
|   statBoolSC forLoopBody                                                                                  {}
|   statWhile forLoopBody                                                                                   {}
|   TOKEN_IF TOKEN_LEFTPAR statBool TOKEN_RIGHTPAR TOKEN_THEN forLoopBody TOKEN_FI                          {}
|   TOKEN_IF TOKEN_LEFTPAR statBool TOKEN_RIGHTPAR TOKEN_THEN forLoopBody TOKEN_ELSE forLoopBody TOKEN_FI   {}
|   statFor forLoopBody                                                                                     {}
|   statWrite forLoopBody                                                                                   {}
|   statRead forLoopBody                                                                                    {}
|   statFunc forLoopBody                                                                                    {}
|   TOKEN_BREAK TOKEN_SC                                                                                    {}
;


statBool:
     expressionBool                                     {}
;

statFunc:
    TOKEN_INTIDENT TOKEN_IDENT TOKEN_LEFTPAR declarations TOKEN_RIGHTPAR TOKEN_DO S TOKEN_RETURN expressionInt TOKEN_SC {}
    |TOKEN_DOUBLEIDENT TOKEN_IDENT  TOKEN_LEFTPAR declarations TOKEN_RIGHTPAR TOKEN_DO S TOKEN_RETURN expressionDouble TOKEN_SC
    |TOKEN_STRINGIDENT TOKEN_IDENT  TOKEN_LEFTPAR declarations TOKEN_RIGHTPAR TOKEN_DO S TOKEN_RETURN expressionString TOKEN_SC
    |TOKEN_BOOLIDENT TOKEN_IDENT  TOKEN_LEFTPAR declarations TOKEN_RIGHTPAR TOKEN_DO S TOKEN_RETURN expressionBool TOKEN_SC
;

statWrite:
     TOKEN_WRITE TOKEN_LEFTPAR statIdentsWrite TOKEN_SC
;


statRead:
       TOKEN_READ TOKEN_LEFTPAR statIdentsRead TOKEN_SC
;

statIdentsWrite:
      expressionInt TOKEN_RIGHTPAR
    | expressionDouble TOKEN_RIGHTPAR
    | expressionBool TOKEN_RIGHTPAR
    | expressionString TOKEN_RIGHTPAR
    | expressionInt TOKEN_RIGHTPAR TOKEN_COMMA statIdentsWrite
    | expressionDouble TOKEN_RIGHTPAR TOKEN_COMMA statIdentsWrite
    | expressionBool TOKEN_RIGHTPAR TOKEN_COMMA statIdentsWrite
    | expressionString TOKEN_RIGHTPAR TOKEN_COMMA statIdentsWrite
  

statIdentsRead:
      TOKEN_IDENT TOKEN_RIGHTPAR
    | TOKEN_IDENT TOKEN_COMMA statIdentsRead

;



statBoolSC:
    expressionBool TOKEN_SC                         {}
|   TOKEN_IDENT TOKEN_EQ expressionBool TOKEN_SC    {}
;




statWhile:

TOKEN_WHILE TOKEN_LEFTPAR statBool TOKEN_RIGHTPAR TOKEN_DO forLoopBody TOKEN_END {}
;

statFor:
TOKEN_FOR TOKEN_LEFTPAR statInt statBoolSC statInt TOKEN_RIGHTPAR TOKEN_DO forLoopBody TOKEN_END {}
;

expressionLE:
        expressionInt TOKEN_LE expressionInt            {}
|       expressionDouble TOKEN_LE expressionDouble      {}
|       expressionDouble TOKEN_LE expressionInt         {} 
|       expressionInt TOKEN_LE expressionDouble         {}

;
expressionLEQ:
        expressionInt TOKEN_LEQ expressionInt            {}
|       expressionDouble TOKEN_LEQ expressionDouble      {}
|       expressionDouble TOKEN_LEQ expressionInt         {} 
|       expressionInt TOKEN_LEQ expressionDouble         {}
;

expressionGE:
        expressionInt TOKEN_GE expressionInt            {}
|       expressionDouble TOKEN_GE expressionDouble      {}
|       expressionDouble TOKEN_GE expressionInt         {} 
|       expressionInt TOKEN_GE expressionDouble         {}
;

expressionGEQ:
        expressionInt TOKEN_GEQ expressionInt            {}
|       expressionDouble TOKEN_GEQ expressionDouble      {}
|       expressionDouble TOKEN_GEQ expressionInt         {} 
|       expressionInt TOKEN_GEQ expressionDouble         {}
;


expressionISEQ:
        expressionInt TOKEN_ISEQ expressionInt            {}
|       expressionDouble TOKEN_ISEQ expressionDouble      {}
;


expressionISNOTEQ:
        expressionInt TOKEN_ISNOTEQ expressionInt            {}
|       expressionDouble TOKEN_ISNOTEQ expressionDouble      {}
;


statString:
    TOKEN_IDENT TOKEN_EQ expressionString TOKEN_SC {$$ = kreirajCvor("stringAssignment");
    dodajSina($$,$1);
    dodajSina($$,$3);
    }
;

statInt: 
   
TOKEN_IDENT TOKEN_EQ expressionInt TOKEN_SC {$$ = kreirajCvor("intAssignment");

dodajSina($$,$1);
dodajSina($$,$3);

}
;


statDouble: TOKEN_IDENT TOKEN_EQ expressionDouble TOKEN_SC {$$ = kreirajCvor("doubleAssignment");
dodajSina($$,$1);
dodajSina($$,$3);

}  
;

expressionBool:
  TOKEN_FALSE                                                               {}
| TOKEN_TRUE                                                                {}
| expressionBool TOKEN_LE expressionBool                                    {}
| expressionBool TOKEN_LEQ expressionBool                                   {}
| expressionBool TOKEN_GEQ expressionBool                                   {}
| expressionBool TOKEN_GE expressionBool                                    {}
| expressionBool TOKEN_ISEQ expressionBool                                  {}
| expressionBool TOKEN_ISNOTEQ expressionBool                               {}
| expressionGE                                                              {}
| expressionGEQ                                                             {}
| expressionISEQ                                                            {}
| expressionISNOTEQ                                                         {}
| expressionLE                                                              {}
| expressionLEQ                                                             {}
| TOKEN_LEFTPAR expressionBool TOKEN_RIGHTPAR                               {}
| expressionInt TOKEN_LE TOKEN_LEFTPAR expressionBool TOKEN_RIGHTPAR        {}
| expressionInt TOKEN_LEQ TOKEN_LEFTPAR expressionBool TOKEN_RIGHTPAR       {}
| expressionInt TOKEN_GE TOKEN_LEFTPAR expressionBool TOKEN_RIGHTPAR        {}
| expressionInt TOKEN_GEQ TOKEN_LEFTPAR expressionBool TOKEN_RIGHTPAR       {}
| expressionInt TOKEN_ISEQ TOKEN_LEFTPAR expressionBool TOKEN_RIGHTPAR      {}
| expressionInt TOKEN_ISNOTEQ TOKEN_LEFTPAR expressionBool TOKEN_RIGHTPAR   {}
| expressionBool TOKEN_AND expressionBool                                   {}
| expressionBool TOKEN_OR expressionBool                                    {}

;


expressionString:
    TOKEN_STRING {$$ = $1;}
;

expressionDouble:
     TOKEN_DOUBLE                                           {$$ = $1;}
    | expressionDouble TOKEN_PLUS expressionDouble          {$$ = $2; dodajSina($2,$1); dodajSina($2,$3);}
    | expressionDouble TOKEN_MINUS expressionDouble         {$$ = $2; dodajSina($2,$1); dodajSina($2,$3);}
    | expressionDouble TOKEN_MUL expressionDouble           {$$ = $2; dodajSina($2,$1); dodajSina($2,$3);}
    | expressionDouble TOKEN_DIV expressionDouble           {$$ = $2; dodajSina($2,$1); dodajSina($2,$3);}
    | TOKEN_LEFTPAR expressionDouble TOKEN_RIGHTPAR         {$$ = $2;}
;



expressionInt:
    expressionInt TOKEN_AND expressionInt               {$$ = $2; dodajSina($2,$1); dodajSina($2,$3);}
    | expressionInt TOKEN_OR expressionInt              {$$ = $2; dodajSina($2,$1); dodajSina($2,$3);}
    | expressionInt TOKEN_PLUS expressionInt            {$$ = $2; dodajSina($2,$1); dodajSina($2,$3);}
    | expressionInt TOKEN_MINUS expressionInt           {$$ = $2; dodajSina($2,$1); dodajSina($2,$3);}
    | expressionInt TOKEN_MUL expressionInt             {$$ = $2; dodajSina($2,$1); dodajSina($2,$3);}
    | expressionInt TOKEN_DIV expressionInt             {$$ = $2; dodajSina($2,$1); dodajSina($2,$3);}
    | expressionInt TOKEN_MOD expressionInt             {$$ = $2; dodajSina($2,$1); dodajSina($2,$3);}
    | TOKEN_LEFTPAR expressionInt TOKEN_RIGHTPAR        {$$ = $2;}
    | TOKEN_INT                                         {$$ = $1;}
    | TOKEN_IDENT                                       {$$ = $1;}
;  

%%   

void yyerror(const char* s) {
    printf("%s\n",s);
}


int main() {

    korijen = kreirajCvor("program");
    int rezultat = yyparse();


    int cnt = 0;

    bool kraj = false;


    struct Red* red = malloc(sizeof(struct Red));
    int nivo = 0;

    inicijalizujRed(red);

    dodajURed(red,korijen);
    struct Cvor* tren = red->glava;

    while(tren != 0) {
        
        struct Cvor* tmp = ukloniSPocetka(red);
        
        if(tmp->nivo > nivo) {
            printf("\n%s ",tmp->vrijednost);
            nivo++;
            
        }
        else {
            printf("%s ",tmp->vrijednost);
        }
        



        int cnt = 0;
        while(cnt < tmp->broj_sinova) {
            tmp->sinovi[cnt]->nivo = tmp->nivo + 1;
            dodajURed(red,tmp->sinovi[cnt]);
            cnt++;
        }
    }
  

  

    if(brojGresaka == 0 && rezultat == 0) {
        printf("Ulaz je bio ispravan!\n");
    }
    else {
        printf("Ulaz nije bio ispravan!\n");
    }

    return 0;
}