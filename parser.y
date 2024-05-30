%{

#include <stdlib.h>
#include <stdio.h>
#include <stdbool.h>
#include <string.h>

#include "greske.h"

void yyerror(const char* s);


struct Promjenjiva {
    char* id;
    int valInt;
    double valDouble;
    bool valBool;
    char* valString;
    int type;
    struct Promjenjiva* sledeci;
};

struct Promjenjiva* glava = 0;

void dodajCvor(char* id,int valInt,bool valBool,double valDouble,char* valString,int type) {
    struct Promjenjiva* noviCvor = (struct Promjenjiva*) malloc(sizeof(struct Promjenjiva));
    noviCvor->id = strdup(id);
    noviCvor->type = type;
    switch(type) {
        case 1:

        noviCvor->valInt = valInt;
        break;

        case 2:
        noviCvor->valDouble = valDouble;
        break;

        case 3:
        noviCvor->valBool = valBool;
        break;
        
        case 4:
        noviCvor->valString = strdup(valString);
        break;

    }
    noviCvor->sledeci = glava;
    glava = noviCvor;
}

struct Promjenjiva* nadji(char* id,int type) {
    struct Promjenjiva* tren = glava;

    bool flag = false;

    while(tren != 0) {

        if(strcmp(tren->id,id) == 0) {
            if(tren->type == type) {
            return tren;
            }
            else {
                flag = true;
            }
        }
        tren = tren->sledeci;
    }

    if(flag) {
        printf("Nije dozvoljena konverzija podataka!");
        exit(1);
        brojGresaka++;
    }
    return tren;
}

void setuj(struct Promjenjiva* p,char* id,int valInt,double valDouble,bool valBool,char* valString,int type) {
    if( p == 0 ) {
        dodajCvor(id,valInt,valDouble,valBool,valString,type);
    }
    else {
        switch(type) {
        case 1:

        p->valInt = valInt;
        break;

        case 2:
        p->valDouble = valDouble;
        break;

        case 3:
        p->valBool = valBool;
        break;
        
        case 4:
        p->valString = strdup(valString);
        break;

    }
    }
}




%}

%union { 

int int_value;
char* str_value;
double dbl_value;
bool bool_value;
char* ident;

}



%start S
%token TOKEN_SC
%token<int_value> TOKEN_INT
%token<str_value> TOKEN_STRING
%token<dbl_value> TOKEN_DOUBLE
%token<ident> TOKEN_IDENT
%token<bool_value> TOKEN_TRUE
%token<bool_value> TOKEN_FALSE
%token TOKEN_PLUS
%token TOKEN_MINUS
%token TOKEN_MUL
%token TOKEN_DIV
%token TOKEN_MOD
%token TOKEN_LE
%token TOKEN_LEQ
%token TOKEN_GE
%token TOKEN_GEQ
%token TOKEN_EQ
%token TOKEN_ISEQ
%token TOKEN_ISNOTEQ
%token TOKEN_AND
%token TOKEN_OR
%token TOKEN_EXCLAM
%token TOKEN_COMMA
%token TOKEN_DOT
%token TOKEN_LEFTPAR
%token TOKEN_RIGHTPAR
%token TOKEN_FOR
%token TOKEN_WHILE
%token TOKEN_BREAK
%token TOKEN_IF
%token TOKEN_ELSE
%token TOKEN_INTIDENT
%token TOKEN_STRINGIDENT
%token TOKEN_BOOLIDENT
%token TOKEN_DOUBLEIDENT
%token TOKEN_RETURN
%token TOKEN_THIS
%token TOKEN_LET;
%token TOKEN_IN;
%token TOKEN_READ
%token TOKEN_WRITE
%token TOKEN_END
%token TOKEN_SKIP
%token TOKEN_DOTSEQ
%token TOKEN_FWSLASH
%token TOKEN_FI
%token TOKEN_INTCONST
%token TOKEN_STRINGCONST
%token TOKEN_BOOLCONST
%token TOKEN_DOUBLECONST
%token TOKEN_DO
%token TOKEN_THEN



%left TOKEN_AND TOKEN_OR
%nonassoc TOKEN_EQ TOKEN_ISNOTEQ TOKEN_ISEQ TOKEN_LE TOKEN_LEQ TOKEN_GE TOKEN_GEQ
%left TOKEN_PLUS TOKEN_MINUS
%left TOKEN_MUL TOKEN_DIV TOKEN_MOD


%type <int_value>expressionInt
%type <int_value>statInt

%type <dbl_value>expressionDouble
%type <dbl_value>statDouble

%type <str_value>expressionString
%type <str_value>statString

%type <bool_value>expressionBool
%type <bool_value>statBool
%type <bool_value>statBoolSC

%type <bool_value>expressionLE
%type <bool_value>expressionLEQ
%type <bool_value>expressionGE
%type <bool_value>expressionGEQ
%type <bool_value>expressionISEQ
%type <bool_value>expressionISNOTEQ


%%



S: | S statInt      {}
   | S statDouble   {}
   | S statString   {}
   | S statBool     {}
   | S statWhile    {}
   | S statBoolSC   {}
   | S statIf       {}
   | S statFor      {}
   
;

forLoopBody:
    S  {}
|   TOKEN_BREAK {}
;


statBool:
    expressionBool          {$$ = $1;}
;

statBoolSC:
    expressionBool TOKEN_SC {$$ = $1;}
;

statIf:
    TOKEN_IF TOKEN_LEFTPAR statBool TOKEN_RIGHTPAR TOKEN_THEN S TOKEN_ELSE S TOKEN_FI {}
|   TOKEN_IF TOKEN_LEFTPAR statBool TOKEN_RIGHTPAR TOKEN_THEN S TOKEN_FI {}

;



statWhile:

TOKEN_WHILE TOKEN_LEFTPAR statBool TOKEN_RIGHTPAR TOKEN_DO S TOKEN_END { printf("WHILE ( %d ) DO ... END",$3);}
;

statFor:
TOKEN_FOR TOKEN_LEFTPAR statInt statBoolSC statInt TOKEN_RIGHTPAR TOKEN_DO forLoopBody TOKEN_END {}
;

expressionLE:
        expressionInt TOKEN_LE expressionInt            {$$ = ($1 < $3);}
|       expressionDouble TOKEN_LE expressionDouble      {$$ = ($1 < $3);}
|       expressionDouble TOKEN_LE expressionInt         {$$ = ($1 < $3);} 
|       expressionInt TOKEN_LE expressionDouble         {$$ = ($1 < $3);}

;
expressionLEQ:
        expressionInt TOKEN_LEQ expressionInt            {$$ = ($1 <= $3);}
|       expressionDouble TOKEN_LEQ expressionDouble      {$$ = ($1 <= $3);}
|       expressionDouble TOKEN_LEQ expressionInt         {$$ = ($1 <= $3);} 
|       expressionInt TOKEN_LEQ expressionDouble         {$$ = ($1 <= $3);}
;

expressionGE:
        expressionInt TOKEN_GE expressionInt            {$$ = ($1 > $3);}
|       expressionDouble TOKEN_GE expressionDouble      {$$ = ($1 > $3);}
|       expressionDouble TOKEN_GE expressionInt         {$$ = ($1 > $3);} 
|       expressionInt TOKEN_GE expressionDouble         {$$ = ($1 > $3);}
;

expressionGEQ:
        expressionInt TOKEN_GEQ expressionInt            {$$ = ($1 >= $3);}
|       expressionDouble TOKEN_GEQ expressionDouble      {$$ = ($1 >= $3);}
|       expressionDouble TOKEN_GEQ expressionInt         {$$ = ($1 >= $3);} 
|       expressionInt TOKEN_GEQ expressionDouble         {$$ = ($1 >= $3);}
;


expressionISEQ:
        expressionInt TOKEN_ISEQ expressionInt            {$$ = ($1 == $3);}
|       expressionDouble TOKEN_ISEQ expressionDouble      {$$ = ($1 == $3);}
;


expressionISNOTEQ:
        expressionInt TOKEN_ISNOTEQ expressionInt            {$$ = ($1 != $3);}
|       expressionDouble TOKEN_ISNOTEQ expressionDouble      {$$ = ($1 != $3);}
;


statString:
    TOKEN_IDENT TOKEN_EQ expressionString TOKEN_SC {printf("%s %s \n",$1,$3);}
;

statInt: 
   
TOKEN_IDENT TOKEN_EQ expressionInt TOKEN_SC {struct Promjenjiva* p = nadji($1,1);
                                                 if(p == 0) {
                                                    nedefinisanIdent(red,kolona);
                                                    exit(1);
                                                 }


                                                 setuj(p,$1,$3,0,0,NULL,1);

                                                 $$ = p->valInt;
   
                                               }
|   TOKEN_INTIDENT TOKEN_IDENT TOKEN_EQ expressionInt TOKEN_SC {
                                                struct Promjenjiva* p = nadji($2,1); // p id,intval,doubleval,boolval,stringval,type
                                                
                                                if(p != 0) {
                                                    ponovnaDeklaracija(red,kolona);
                                                    exit(1);
                                                }

                                                setuj(p,$2,$4,0,0,NULL,1);


                                                $$ = p->valInt;
                                               }
;


statDouble: TOKEN_IDENT TOKEN_EQ expressionDouble TOKEN_SC {struct Promjenjiva* p = nadji($1,2);
                                                 if(p == 0) {
                                                    nedefinisanIdent(red,kolona);
                                                    exit(1);
                                                    brojGresaka++;
                                                 }
                                                    setuj(p,$1,0,$3,0,NULL,2);
                                                    $$ = p->valDouble;
                                                 }  
   | TOKEN_DOUBLEIDENT TOKEN_IDENT TOKEN_EQ expressionDouble TOKEN_SC {
                                                struct Promjenjiva* p = nadji($2,2); // p id,intval,doubleval,boolval,stringval,type
                                                
                                               if(p != 0) {
                                                    ponovnaDeklaracija(red,kolona);
                                                    exit(1);
                                                }


                                                setuj(p,$2,0,$4,0,NULL,2);


                                                $$ = p->valDouble;
                                                
                                                }
;

expressionBool:
  TOKEN_FALSE                                                               {$$ = $1;}
| TOKEN_TRUE                                                                {$$ = $1;}
| expressionBool TOKEN_LE expressionBool                                    {$$ = ($1 < $3);}
| expressionBool TOKEN_LEQ expressionBool                                   {$$ = ($1 <= $3);}
| expressionBool TOKEN_GEQ expressionBool                                   {$$ = ($1 >= $3);}
| expressionBool TOKEN_GE expressionBool                                    {$$ = ($1 > $3);}
| expressionBool TOKEN_ISEQ expressionBool                                  {$$ = ($1 == $3);}
| expressionBool TOKEN_ISNOTEQ expressionBool                               {$$ = ($1 != $3);}
| expressionGE                                                              {$$ = $1;}
| expressionGEQ                                                             {$$ = $1;}
| expressionISEQ                                                            {$$ = $1;}
| expressionISNOTEQ                                                         {$$ = $1;}
| expressionLE                                                              {$$ = $1;}
| expressionLEQ                                                             {$$ = $1;}
| TOKEN_LEFTPAR expressionBool TOKEN_RIGHTPAR                               {$$ = $2;}
| expressionInt TOKEN_LE TOKEN_LEFTPAR expressionBool TOKEN_RIGHTPAR        {$$ = ($1 < $4);}
| expressionInt TOKEN_LEQ TOKEN_LEFTPAR expressionBool TOKEN_RIGHTPAR       {$$ = ($1 <= $4);}
| expressionInt TOKEN_GE TOKEN_LEFTPAR expressionBool TOKEN_RIGHTPAR        {$$ = ($1 > $4);}
| expressionInt TOKEN_GEQ TOKEN_LEFTPAR expressionBool TOKEN_RIGHTPAR       {$$ = ($1 >= $4);}
| expressionInt TOKEN_ISEQ TOKEN_LEFTPAR expressionBool TOKEN_RIGHTPAR      {$$ = ($1 == $4);}
| expressionInt TOKEN_ISNOTEQ TOKEN_LEFTPAR expressionBool TOKEN_RIGHTPAR   {$$ = ($1 != $4);}
| expressionBool TOKEN_AND expressionBool                                   {$$ = ($1 && $3);}
| expressionBool TOKEN_OR expressionBool                                    {$$ = ($1 || $3);}

;


expressionString:
    TOKEN_STRING {$$ = strdup($1);}
;

expressionDouble:
     TOKEN_DOUBLE                                           {$$ = $1;}
    | expressionDouble TOKEN_PLUS expressionDouble          {$$ = $1 + $3;}
    | expressionDouble TOKEN_MINUS expressionDouble         {$$ = $1 - $3;}
    | expressionDouble TOKEN_MUL expressionDouble           {$$ = $1 * $3;}
    | expressionDouble TOKEN_DIV expressionDouble           {$$ = $1 / $3;}
    | TOKEN_LEFTPAR expressionDouble TOKEN_RIGHTPAR         {$$ = $2;}
;



expressionInt:
    expressionInt TOKEN_AND expressionInt               {$$ = $1 && $3;}
    | expressionInt TOKEN_OR expressionInt              {$$ = $1 || $3;}
    | expressionInt TOKEN_PLUS expressionInt            {$$ = $1 + $3;}
    | expressionInt TOKEN_MINUS expressionInt           {$$ = $1 - $3;}
    | expressionInt TOKEN_MUL expressionInt             {$$ = $1 * $3;}
    | expressionInt TOKEN_DIV expressionInt             {$$ = $1 / $3;}
    | expressionInt TOKEN_MOD expressionInt             {$$ = $1 % $3;}
    | TOKEN_LEFTPAR expressionInt TOKEN_RIGHTPAR        {$$ = $2;}
    | TOKEN_INT                                         {$$ = $1;}
    | TOKEN_IDENT                                       {
                                                        $$ = nadji($1,1)->valInt;
                                                        }
;  

%%   

void yyerror(const char* s) {
    printf("%s",s);
}


int main() {
   
    int rezultat = yyparse();

  

    if(brojGresaka == 0 && rezultat == 0) {
        printf("Ulaz je bio ispravan!\n");
    }
    else {
        printf("Ulaz nije bio ispravan!\n");
    }

    return 0;
}