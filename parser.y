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

void  dodajCvor(char* id,int valInt,bool valBool,double valDouble,char* valString,int type) {
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


%start program
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
%token TOKEN_RIGHTBRACKET
%token TOKEN_LEFTBRACKET
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


program: | 
TOKEN_LET TOKEN_LEFTBRACKET declarations TOKEN_RIGHTBRACKET TOKEN_IN S TOKEN_END

;

declarations:
|   declarations TOKEN_INTIDENT TOKEN_IDENT
|  declarations TOKEN_STRINGIDENT TOKEN_IDENT
|  declarations TOKEN_DOUBLEIDENT TOKEN_IDENT
|  declarations TOKEN_BOOLIDENT TOKEN_IDENT


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
|   statInt forLoopBody        {}
|   statDouble forLoopBody      {}
|   statBoolSC forLoopBody     {}
|   statWhile forLoopBody      {}
|   statIf forLoopBody         {}
|   statFor forLoopBody         {}
|   TOKEN_BREAK TOKEN_SC  S      {}
;


statBool:
     expressionBool                                     {}
;

statBoolSC:
    expressionBool TOKEN_SC                         {}
|   TOKEN_IDENT TOKEN_EQ expressionBool TOKEN_SC    {}
;

statIf:
    TOKEN_IF TOKEN_LEFTPAR statBool TOKEN_RIGHTPAR TOKEN_THEN S TOKEN_ELSE S TOKEN_FI {}
|   TOKEN_IF TOKEN_LEFTPAR statBool TOKEN_RIGHTPAR TOKEN_THEN S TOKEN_FI {}

;



statWhile:

TOKEN_WHILE TOKEN_LEFTPAR statBool TOKEN_RIGHTPAR TOKEN_DO forLoopBody TOKEN_END { printf("WHILE ( ... ) DO ... END");}
;

statFor:
TOKEN_FOR TOKEN_LEFTPAR statInt statBoolSC statInt TOKEN_RIGHTPAR TOKEN_DO forLoopBody TOKEN_END {printf("FOR ... TOKEN_DO ... TOKEN_END\n");}
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
    TOKEN_IDENT TOKEN_EQ expressionString TOKEN_SC {}
;

statInt: 
   
TOKEN_IDENT TOKEN_EQ expressionInt TOKEN_SC { }
;


statDouble: TOKEN_IDENT TOKEN_EQ expressionDouble TOKEN_SC {}  
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
    TOKEN_STRING {}
;

expressionDouble:
     TOKEN_DOUBLE                                           {}
    | expressionDouble TOKEN_PLUS expressionDouble          {}
    | expressionDouble TOKEN_MINUS expressionDouble         {}
    | expressionDouble TOKEN_MUL expressionDouble           {}
    | expressionDouble TOKEN_DIV expressionDouble           {}
    | TOKEN_LEFTPAR expressionDouble TOKEN_RIGHTPAR         {}
;



expressionInt:
    expressionInt TOKEN_AND expressionInt               {}
    | expressionInt TOKEN_OR expressionInt              {}
    | expressionInt TOKEN_PLUS expressionInt            {}
    | expressionInt TOKEN_MINUS expressionInt           {}
    | expressionInt TOKEN_MUL expressionInt             {}
    | expressionInt TOKEN_DIV expressionInt             {}
    | expressionInt TOKEN_MOD expressionInt             {}
    | TOKEN_LEFTPAR expressionInt TOKEN_RIGHTPAR        {}
    | TOKEN_INT                                         {}
    | TOKEN_IDENT                                       {}
;  

%%   

void yyerror(const char* s) {
    printf("%s\n",s);
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