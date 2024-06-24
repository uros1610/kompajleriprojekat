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
 

 struct Promljenjiva {
    
    char* id;
    int tip; // 0 bool 1 int 2 double 3 string
    struct Promljenjiva* sledeci;
 };

struct Promljenjiva* glava = 0;

void dodaj(char* id,int tip) {
    struct Promljenjiva* novi_cvor = malloc(sizeof(struct Promljenjiva));
    novi_cvor->sledeci = glava;
    novi_cvor->tip = tip;
    novi_cvor->id = strdup(id);
    glava = novi_cvor;
}

int nadji(char* id) {
    struct Promljenjiva* temp = glava;

    while(temp != 0) {
        if(strcmp(temp->id,id) == 0) {
            return temp->tip;
        }
        temp = temp->sledeci;
    }
    return -1;
}
/*
if(nadji($1->vrijednost) != nadji($3->vrijednost)) {
        Nekompatabilni(red,kolona);
        exit(1);
    }

    if(nadji($1->vrijednost) == -1) {
        nedefinisanIdent(red,kolona);
        exit(1);
    }
*/  
/*
%type <CvorPokazivac>expressionInt
%type <CvorPokazivac>expressionDouble
%type <CvorPokazivac>expressionString
%type <CvorPokazivac> expressionLE
%type <CvorPokazivac> expressionLEQ
%type <CvorPokazivac> expressionGE
%type <CvorPokazivac> expressionGEQ
%type <CvorPokazivac> expressionISEQ
%type <CvorPokazivac> expressionISNOTEQ
*/

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
%type <CvorPokazivac> assignment





%type <CvorPokazivac>statWrite
%type <CvorPokazivac>statRead
%type <CvorPokazivac>readStatements
%type <CvorPokazivac>writeStatements
%type <CvorPokazivac>writeStatement
%type <CvorPokazivac> forLoopBody
%type <CvorPokazivac> statFor
%type <CvorPokazivac> statWhile
%type <CvorPokazivac> statFunc
%type <CvorPokazivac> expression
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
|  declarations declaration {dodajSina($1,$2);}

declaration:
    TOKEN_INTIDENT TOKEN_IDENT {
        $$ = kreirajCvor("IntDeclaration");
       
        dodajSina($$, $1);
        dodajSina($$, $2);
        if(nadji($2->vrijednost) != -1) {
            exit(1);
        }
        dodaj($2->vrijednost,1);

    }
|   TOKEN_STRINGIDENT TOKEN_IDENT {
        $$ = kreirajCvor("StringDeclaration");
      
        dodajSina($$, $1);
        dodajSina($$, $2);
        if(nadji($2->vrijednost) != -1) {
            exit(1);
        }
        dodaj($2->vrijednost,3);
    }
|   TOKEN_DOUBLEIDENT TOKEN_IDENT {
        $$ = kreirajCvor("DoubleDeclaration");
      
        dodajSina($$, $1);
        dodajSina($$, $2);
        if(nadji($2->vrijednost) != -1) {
            exit(1);
        }
        dodaj($2->vrijednost,2);
        

    }
|   TOKEN_BOOLIDENT TOKEN_IDENT {
        $$ = kreirajCvor("BoolDeclaration");
       
        dodajSina($$, $1);
        dodajSina($$, $2);
        if(nadji($2->vrijednost) != -1) {
            exit(1);
        }
        dodaj($2->vrijednost,0);

    }
;



S:                                                                                       {$$ = kreirajCvor("statements");}
    | S expression                                                                       {dodajSina($1,$2);}
    | S statWhile                                                                        {dodajSina($1,$2);}
    | S TOKEN_IF TOKEN_LEFTPAR assignment TOKEN_RIGHTPAR TOKEN_THEN S TOKEN_FI             {dodajSina($2,$4); dodajSina($2,$6); dodajSina($6,$7);  dodajSina($6,$8); dodajSina($1,$2);} 
    | S TOKEN_IF TOKEN_LEFTPAR assignment TOKEN_RIGHTPAR TOKEN_THEN S TOKEN_ELSE S TOKEN_FI{dodajSina($2,$4); dodajSina($2,$6); dodajSina($6,$7);  dodajSina($6,$10); dodajSina($8,$9); dodajSina($2,$8); dodajSina($1,$2);}
    | S statFor                                                                          {dodajSina($1,$2);}
    | S statFunc                                                                         {dodajSina($1,$2);}
    | S statWrite                                                                        {dodajSina($1,$2);}
    | S statRead                                                                         {dodajSina($1,$2);}
   
;

forLoopBody: {$$ = kreirajCvor("forLoopBody");}
| forLoopBody expression {dodajSina($1,$2); $$ = $1;}
|  forLoopBody   statWhile                                                                                              {dodajSina($1,$2); $$ = $1;}
|  forLoopBody  TOKEN_IF TOKEN_LEFTPAR assignment TOKEN_RIGHTPAR TOKEN_THEN forLoopBody TOKEN_FI                          {dodajSina($2,$4); dodajSina($2,$6); dodajSina($6,$7);  dodajSina($6,$8); dodajSina($1,$2);}  
|  forLoopBody  TOKEN_IF TOKEN_LEFTPAR assignment TOKEN_RIGHTPAR TOKEN_THEN forLoopBody TOKEN_ELSE forLoopBody TOKEN_FI   {dodajSina($2,$4); dodajSina($2,$6); dodajSina($6,$7);  dodajSina($6,$10); dodajSina($8,$9); dodajSina($2,$8); dodajSina($1,$2);}
|  forLoopBody   statFor                                                                                                {dodajSina($1,$2); $$ = $1;}
|  forLoopBody   statWrite                                                                                              {dodajSina($1,$2); $$ = $1;}
|  forLoopBody   statRead                                                                                               {dodajSina($1,$2); $$ = $1;}
|  forLoopBody   statFunc                                                                                               {dodajSina($1,$2); $$ = $1;}
|  forLoopBody  TOKEN_BREAK TOKEN_SC                                                                                    {dodajSina($1,$2); $$ = $1;}
;

expression:
    TOKEN_IDENT TOKEN_EQ assignment TOKEN_SC {if(nadji($1->vrijednost)!=$3->tip) {Nekompatabilni(red,kolona);}dodajSina($2,$1); dodajSina($2,$3); $$ = $2;}
;  

assignment:
    TOKEN_IDENT {if(nadji($1->vrijednost) == -1) {nedefinisanIdent(red,kolona); exit(1);} $$->tip = nadji($1->vrijednost);}
|   assignment TOKEN_PLUS assignment {if($1->tip != $3->tip || (($1->tip != 1) && $1->tip!=2)) {printf("%d\n",$1->tip);Nekompatabilni(red,kolona); exit(1);}  dodajSina($2,$1); dodajSina($2,$3); $$ = $2; $$->tip = $1->tip;}
|   assignment TOKEN_MINUS assignment {if($1->tip != $3->tip || (($1->tip != 1) && $1->tip!=2)) {Nekompatabilni(red,kolona); exit(1);} dodajSina($2,$1); dodajSina($2,$3); $$ = $2; $$->tip = $1->tip;}
|   assignment TOKEN_MUL assignment {if($1->tip != $3->tip || (($1->tip != 1) && $1->tip!=2)) {Nekompatabilni(red,kolona); exit(1);} dodajSina($2,$1); dodajSina($2,$3); $$ = $2; $$->tip = $1->tip;}
|   assignment TOKEN_DIV assignment{if($1->tip != $3->tip || (($1->tip != 1) && $1->tip!=2)) {Nekompatabilni(red,kolona); exit(1);} dodajSina($2,$1); dodajSina($2,$3); $$ = $2; $$->tip = $1->tip;}
|   assignment TOKEN_MOD assignment{if($1->tip != $3->tip || $1->tip!=1) {Nekompatabilni(red,kolona); exit(1);} dodajSina($2,$1); dodajSina($2,$3); $$ = $2; $$->tip = $1->tip;}
|   assignment TOKEN_AND assignment{if($1->tip!=0 || $3->tip!=0) {Nekompatabilni(red,kolona);} dodajSina($2,$1); dodajSina($2,$3); $$ = $2;$$->tip = 0; }
|   assignment TOKEN_OR assignment{if($1->tip!=0 || $3->tip!=0) {Nekompatabilni(red,kolona);} dodajSina($2,$1); dodajSina($2,$3); $$ = $2;$$->tip = 0;}
|   assignment TOKEN_LE assignment{if((($1->tip != 1) && $1->tip!=2) || ($3->tip!= 1 && $3->tip!=2)) {Nekompatabilni(red,kolona); exit(1); }  dodajSina($2,$1); dodajSina($2,$3); $$ = $2; $$->tip = 0;}
|   assignment TOKEN_ISEQ assignment{ dodajSina($2,$1); dodajSina($2,$3); $$ = $2; $$->tip = 0;}
|   assignment TOKEN_ISNOTEQ assignment{ dodajSina($2,$1); dodajSina($2,$3); $$ = $2; $$->tip = 0;}
|   assignment TOKEN_GEQ assignment{if((($1->tip != 1) && $1->tip!=2) || ($3->tip!= 1 && $3->tip!=2)) {Nekompatabilni(red,kolona); exit(1); } dodajSina($2,$1); dodajSina($2,$3); $$ = $2; $$->tip = 0;}
|   assignment TOKEN_LEQ assignment{if((($1->tip != 1) && $1->tip!=2) || ($3->tip!= 1 && $3->tip!=2)) {Nekompatabilni(red,kolona); exit(1); } dodajSina($2,$1); dodajSina($2,$3); $$ = $2; $$->tip = 0;}
|   assignment TOKEN_GE assignment{if((($1->tip != 1) && $1->tip!=2) || ($3->tip!= 1 && $3->tip!=2)) {Nekompatabilni(red,kolona); exit(1); } dodajSina($2,$1); dodajSina($2,$3); $$ = $2; $$->tip = 0;}
|   TOKEN_LEFTPAR assignment TOKEN_RIGHTPAR {$$ = $2; $$->tip = $2->tip;}
| TOKEN_INT {$$ = $1; $$->tip = 1;}
| TOKEN_DOUBLE {$$ = $1; $$->tip = 2;}
| TOKEN_TRUE {$$ = $1; $$->tip = 0;}
| TOKEN_FALSE {$$ = $1; $$->tip = 0;}
| TOKEN_STRING {$$ = $1; $$->tip = 3;}





statFunc:
     TOKEN_INTIDENT TOKEN_IDENT TOKEN_LEFTPAR declarations TOKEN_RIGHTPAR TOKEN_DO S TOKEN_RETURN assignment TOKEN_SC {$$ = kreirajCvor("funcDeclaration"); dodajSina($$,$1); dodajSina($$,$2); dodajSina($$,$4); dodajSina($$,$6); dodajSina($6,$7); dodajSina($6,$8); dodajSina($6,$9);} 
    |TOKEN_DOUBLEIDENT TOKEN_IDENT  TOKEN_LEFTPAR declarations TOKEN_RIGHTPAR TOKEN_DO S TOKEN_RETURN assignment TOKEN_SC {$$ = kreirajCvor("funcDeclaration"); dodajSina($$,$1); dodajSina($$,$2); dodajSina($$,$4); dodajSina($$,$6); dodajSina($6,$7); dodajSina($6,$8); dodajSina($6,$9);} 
    |TOKEN_STRINGIDENT TOKEN_IDENT  TOKEN_LEFTPAR declarations TOKEN_RIGHTPAR TOKEN_DO S TOKEN_RETURN assignment TOKEN_SC {$$ = kreirajCvor("funcDeclaration"); dodajSina($$,$1); dodajSina($$,$2); dodajSina($$,$4); dodajSina($$,$6); dodajSina($6,$7); dodajSina($6,$8); dodajSina($6,$9);} 
    |TOKEN_BOOLIDENT TOKEN_IDENT  TOKEN_LEFTPAR declarations TOKEN_RIGHTPAR TOKEN_DO S TOKEN_RETURN assignment TOKEN_SC {$$ = kreirajCvor("funcDeclaration"); dodajSina($$,$1); dodajSina($$,$2); dodajSina($$,$4); dodajSina($$,$6); dodajSina($6,$7); dodajSina($6,$8); dodajSina($6,$9);} 
;

statWrite: 
    TOKEN_WRITE TOKEN_LEFTPAR writeStatements TOKEN_RIGHTPAR TOKEN_SC {$$ = $1; dodajSina($1,$3);}
;

writeStatements:    {$$ = kreirajCvor("writeStatements");}
|    writeStatements writeStatement     {$$ = $1; dodajSina($1,$2);}

writeStatement:
  assignment {$$ = $1;}

statRead:
       TOKEN_READ TOKEN_LEFTPAR readStatements TOKEN_RIGHTPAR TOKEN_SC {$$ = $1; dodajSina($1,$3);}
;



readStatements: {$$ = kreirajCvor("readStatements");}
    | readStatements TOKEN_IDENT  {$$ = $1; dodajSina($1,$2);}

;


/*
statBoolSC:
    expressionBool TOKEN_SC  {$$ = $1;}
|   TOKEN_IDENT TOKEN_EQ expressionBool TOKEN_SC {
    if(nadji($1->vrijednost) != 0) {
        Nekompatabilni(red,kolona);
        exit(1);
    }
    $$ = kreirajCvor("boolAssignment"); 
    dodajSina($$,$1); 
    dodajSina($$,$3);}
    


;
*/




statWhile:

TOKEN_WHILE TOKEN_LEFTPAR assignment TOKEN_RIGHTPAR TOKEN_DO forLoopBody TOKEN_END {$$ = $1; dodajSina($1,$3); dodajSina($1,$5); dodajSina($5,$6); dodajSina($1,$7);}
;

statFor:
TOKEN_FOR TOKEN_LEFTPAR expression assignment TOKEN_SC expression TOKEN_RIGHTPAR TOKEN_DO forLoopBody TOKEN_END {$$ = $1; dodajSina($1,$3); dodajSina($1,$4); dodajSina($1,$6);  dodajSina($1,$8); dodajSina($8,$9); dodajSina($1,$10);}
;

/*
expressionLE:
        expressionInt TOKEN_LE expressionInt            {$$ = $2; dodajSina($2,$1); dodajSina($2,$3);}
|       expressionDouble TOKEN_LE expressionDouble      {$$ = $2; dodajSina($2,$1); dodajSina($2,$3);}
|       expressionDouble TOKEN_LE expressionInt         {$$ = $2; dodajSina($2,$1); dodajSina($2,$3);} 
|       expressionInt TOKEN_LE expressionDouble         {$$ = $2; dodajSina($2,$1); dodajSina($2,$3);}

;
expressionLEQ:
        expressionInt TOKEN_LEQ expressionInt            {$$ = $2; dodajSina($2,$1); dodajSina($2,$3);}
|       expressionDouble TOKEN_LEQ expressionDouble      {$$ = $2; dodajSina($2,$1); dodajSina($2,$3);}
|       expressionDouble TOKEN_LEQ expressionInt         {$$ = $2; dodajSina($2,$1); dodajSina($2,$3);} 
|       expressionInt TOKEN_LEQ expressionDouble         {$$ = $2; dodajSina($2,$1); dodajSina($2,$3);}
;

expressionGE:
        expressionInt TOKEN_GE expressionInt            {$$ = $2; dodajSina($2,$1); dodajSina($2,$3);}
|       expressionDouble TOKEN_GE expressionDouble      {$$ = $2; dodajSina($2,$1); dodajSina($2,$3);}
|       expressionDouble TOKEN_GE expressionInt         {$$ = $2; dodajSina($2,$1); dodajSina($2,$3);} 
|       expressionInt TOKEN_GE expressionDouble         {$$ = $2; dodajSina($2,$1); dodajSina($2,$3);}
;

expressionGEQ:
        expressionInt TOKEN_GEQ expressionInt            {$$ = $2; dodajSina($2,$1); dodajSina($2,$3);}
|       expressionDouble TOKEN_GEQ expressionDouble      {$$ = $2; dodajSina($2,$1); dodajSina($2,$3);}
|       expressionDouble TOKEN_GEQ expressionInt         {$$ = $2; dodajSina($2,$1); dodajSina($2,$3);} 
|       expressionInt TOKEN_GEQ expressionDouble         {$$ = $2; dodajSina($2,$1); dodajSina($2,$3);}
;


expressionISEQ:
        expressionInt TOKEN_ISEQ expressionInt            {$$ = $2; dodajSina($2,$1); dodajSina($2,$3);}
|       expressionDouble TOKEN_ISEQ expressionDouble      {$$ = $2; dodajSina($2,$1); dodajSina($2,$3);}
;


expressionISNOTEQ:
        expressionInt TOKEN_ISNOTEQ expressionInt            {$$ = $2; dodajSina($2,$1); dodajSina($2,$3);}
|       expressionDouble TOKEN_ISNOTEQ expressionDouble      {$$ = $2; dodajSina($2,$1); dodajSina($2,$3);}
;

/*
statString:
    TOKEN_IDENT TOKEN_EQ expressionString TOKEN_SC {
         if(nadji($1->vrijednost) != 3) {
        Nekompatabilni(red,kolona);
        exit(1);
        }
    $$ = kreirajCvor("stringAssignment");
    dodajSina($$,$1);
    dodajSina($$,$3);
    }   

;
*/

/*
statInt: 
   
TOKEN_IDENT TOKEN_EQ expressionInt TOKEN_SC {
 if(nadji($1->vrijednost) != 1) {
        Nekompatabilni(red,kolona);
        exit(1);
    }
$$ = kreirajCvor("intAssignment");
dodajSina($$,$1);
dodajSina($$,$3);

}
*/

;

/*
statDouble: TOKEN_IDENT TOKEN_EQ expressionDouble TOKEN_SC {
     if(nadji($1->vrijednost) != 2) {
        Nekompatabilni(red,kolona);
        exit(1);
    }
$$ = kreirajCvor("doubleAssignment");
dodajSina($$,$1);
dodajSina($$,$3);

} 
;



expressionBool:
  TOKEN_FALSE                                                               {$$ = $1; $$->tip = 0;}
| TOKEN_TRUE                                                                {$$ = $1; $$->tip = 0;}
| expressionBool TOKEN_LE expressionBool                                    {$$ = $2; dodajSina($2,$1); dodajSina($2,$3); $$->tip = 0;}
| expressionBool TOKEN_LEQ expressionBool                                   {$$ = $2; dodajSina($2,$1); dodajSina($2,$3); $$->tip = 0;}
| expressionBool TOKEN_GEQ expressionBool                                   {$$ = $2; dodajSina($2,$1); dodajSina($2,$3); $$->tip = 0;}
| expressionBool TOKEN_GE expressionBool                                    {$$ = $2; dodajSina($2,$1); dodajSina($2,$3); $$->tip = 0;}
| expressionBool TOKEN_ISEQ expressionBool                                  {$$ = $2; dodajSina($2,$1); dodajSina($2,$3); $$->tip = 0;}
| expressionBool TOKEN_ISNOTEQ expressionBool                               {$$ = $2; dodajSina($2,$1); dodajSina($2,$3); $$->tip = 0;}
| expressionGE                                                              {$$ = $1; $$->tip = 0;}
| expressionGEQ                                                             {$$ = $1; $$->tip = 0;}
| expressionISEQ                                                            {$$ = $1; $$->tip = 0;}
| expressionISNOTEQ                                                         {$$ = $1; $$->tip = 0;}
| expressionLE                                                              {$$ = $1; $$->tip = 0;}
| expressionLEQ                                                             {$$ = $1; $$->tip = 0;}
| TOKEN_LEFTPAR expressionBool TOKEN_RIGHTPAR                               {$$ = $2; $$->tip = 0;}
| expressionInt TOKEN_LE TOKEN_LEFTPAR expressionBool TOKEN_RIGHTPAR        {$$ = $2; dodajSina($2,$1);  dodajSina($2,$4); $$->tip = 0;}
| expressionInt TOKEN_LEQ TOKEN_LEFTPAR expressionBool TOKEN_RIGHTPAR       {$$ = $2; dodajSina($2,$1);  dodajSina($2,$4); $$->tip = 0;}
| expressionInt TOKEN_GE TOKEN_LEFTPAR expressionBool TOKEN_RIGHTPAR        {$$ = $2; dodajSina($2,$1);  dodajSina($2,$4); $$->tip = 0;}
| expressionInt TOKEN_GEQ TOKEN_LEFTPAR expressionBool TOKEN_RIGHTPAR       {$$ = $2; dodajSina($2,$1);  dodajSina($2,$4); $$->tip = 0;}
| expressionInt TOKEN_ISEQ TOKEN_LEFTPAR expressionBool TOKEN_RIGHTPAR      {$$ = $2; dodajSina($2,$1);  dodajSina($2,$4); $$->tip = 0;}
| expressionInt TOKEN_ISNOTEQ TOKEN_LEFTPAR expressionBool TOKEN_RIGHTPAR   {$$ = $2; dodajSina($2,$1);  dodajSina($2,$4); $$->tip = 0;}
| expressionDouble TOKEN_LE TOKEN_LEFTPAR expressionBool TOKEN_RIGHTPAR     {$$ = $2; dodajSina($2,$1);  dodajSina($2,$4); $$->tip = 0;}
| expressionDouble TOKEN_LEQ TOKEN_LEFTPAR expressionBool TOKEN_RIGHTPAR    {$$ = $2; dodajSina($2,$1);  dodajSina($2,$4); $$->tip = 0;}
| expressionDouble TOKEN_GE TOKEN_LEFTPAR expressionBool TOKEN_RIGHTPAR     {$$ = $2; dodajSina($2,$1);  dodajSina($2,$4); $$->tip = 0;}
| expressionDouble TOKEN_GEQ TOKEN_LEFTPAR expressionBool TOKEN_RIGHTPAR    {$$ = $2; dodajSina($2,$1);  dodajSina($2,$4); $$->tip = 0;}
| expressionDouble TOKEN_ISEQ TOKEN_LEFTPAR expressionBool TOKEN_RIGHTPAR   {$$ = $2; dodajSina($2,$1);  dodajSina($2,$4); $$->tip = 0;}
| expressionDouble TOKEN_ISNOTEQ TOKEN_LEFTPAR expressionBool TOKEN_RIGHTPAR{$$ = $2; dodajSina($2,$1);  dodajSina($2,$4); $$->tip = 0;}
| expressionBool TOKEN_AND expressionBool                                   {$$ = $2; dodajSina($2,$1); dodajSina($2,$3); $$->tip = 0;}
| expressionBool TOKEN_OR expressionBool                                    {$$ = $2; dodajSina($2,$1); dodajSina($2,$3); $$->tip = 0;}
                                                                                       
;


expressionString:
    TOKEN_STRING {$$ = $1; $$->tip = 3;}
;

expressionDouble:
     TOKEN_DOUBLE                                           {$$ = $1; $$->tip = 2;}
    | expressionDouble TOKEN_PLUS expressionDouble          {$$ = $2; dodajSina($2,$1); dodajSina($2,$3); $$->tip = 2;}
    | expressionDouble TOKEN_MINUS expressionDouble         {$$ = $2; dodajSina($2,$1); dodajSina($2,$3); $$->tip = 2;}
    | expressionDouble TOKEN_MUL expressionDouble           {$$ = $2; dodajSina($2,$1); dodajSina($2,$3); $$->tip = 2;}
    | expressionDouble TOKEN_DIV expressionDouble           {$$ = $2; dodajSina($2,$1); dodajSina($2,$3); $$->tip = 2;}
    | TOKEN_LEFTPAR expressionDouble TOKEN_RIGHTPAR         {$$ = $2; $$->tip = 2;}
;



expressionInt:
    expressionInt TOKEN_AND expressionInt               {$$ = $2; dodajSina($2,$1); dodajSina($2,$3); $$->tip = 1;}
    | expressionInt TOKEN_OR expressionInt              {$$ = $2; dodajSina($2,$1); dodajSina($2,$3); $$->tip = 1;}
    | expressionInt TOKEN_PLUS expressionInt            {$$ = $2; dodajSina($2,$1); dodajSina($2,$3); $$->tip = 1;}
    | expressionInt TOKEN_MINUS expressionInt           {$$ = $2; dodajSina($2,$1); dodajSina($2,$3); $$->tip = 1;}
    | expressionInt TOKEN_MUL expressionInt             {$$ = $2; dodajSina($2,$1); dodajSina($2,$3); $$->tip = 1;}
    | expressionInt TOKEN_DIV expressionInt             {$$ = $2; dodajSina($2,$1); dodajSina($2,$3); $$->tip = 1;}
    | expressionInt TOKEN_MOD expressionInt             {$$ = $2; dodajSina($2,$1); dodajSina($2,$3); $$->tip = 1;}
    | TOKEN_LEFTPAR expressionInt TOKEN_RIGHTPAR        {$$ = $2; $$->tip = 1;}
    | TOKEN_INT                                         {$$ = $1; $$->tip = 1;}
    
;  

*/

%%   

void yyerror(const char* s) {
    printf("%s\n",s);
}


int main() {

    korijen = kreirajCvor("program");
    int rezultat = yyparse();

    
  

    if(brojGresaka == 0 && rezultat == 0) {
        printf("\nUlaz je bio ispravan!\n");
    }
    else {
        printf("\nUlaz nije bio ispravan!\n");
        return 1;
    }


    int cnt = 0;

    bool kraj = false;


    struct Red* red = malloc(sizeof(struct Red));
    int nivo = 0;

    inicijalizujRed(red);

    dodajURed(red,korijen);

    printf("Prvi nivo:\n");
   

    while(true) {
        if(red->glava == 0) {
            break;
        }
        struct Cvor* tmp = ukloniSPocetka(red);
        
        if(tmp->nivo > nivo) {
            printf("\n\n\n%d-ti Nivo:",tmp->nivo+1);
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
  


    return 0;
}