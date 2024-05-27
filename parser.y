%{

#include <stdlib.h>
#include <stdio.h>
#include <stdbool.h>
#include <string.h>

#include "greske.h"

void yyerror(const char* s);

struct Promjenjiva {
    char* id;
    int val;
    struct Promjenjiva* sledeci;
};

struct Promjenjiva* glava = 0;

void dodajCvor(char* id,int val) {
    struct Promjenjiva* noviCvor = (struct Promjenjiva*) malloc(sizeof(struct Promjenjiva));
    noviCvor->id = strdup(id);
    noviCvor->val = val;
    noviCvor->sledeci = glava;
    glava = noviCvor;
}

struct Promjenjiva* nadji(char* id) {
    struct Promjenjiva* tren = glava;

    while(tren != 0) {

        if(strcmp(tren->id,id) == 0) {
            return tren;
        }
        tren = tren->sledeci;
    }
    return tren;
}

void setuj(struct Promjenjiva* p,char* id,int val) {
    if( p == 0 ) {
        dodajCvor(id,val);
    }
    else {
        p->val = val;
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


%%



S: | S statInt   {}
   | S statDouble {}
   | S statString {}
   | S statBool {}

;

statBool:

    expressionBool TOKEN_SC {}


;

expressionBool:
  TOKEN_FALSE                           {$$ = $1}
| TOKEN_TRUE                            {$$ = $1}
| TOKEN_IDENT TOKEN_EQ TOKEN_FALSE      {}
| TOKEN_IDENT TOKEN_EQ TOKEN_TRUE       {}



statString:
    TOKEN_IDENT TOKEN_EQ expressionString TOKEN_SC {printf("%s %s \n",$1,$3);}
;

statInt: 
    expressionInt TOKEN_SC {printf("%d\n",$1);}
   
   | TOKEN_IDENT TOKEN_EQ expressionInt TOKEN_SC {
                                                struct Promjenjiva* p = nadji($1);
                                                setuj(p,$1,$3);
                                               }
;


statDouble: expressionDouble TOKEN_SC {printf("%f\n",$1);}
   | TOKEN_IDENT TOKEN_EQ expressionDouble TOKEN_SC {}
;

expressionString:
    TOKEN_STRING {$$ = strdup($1);}
;

expressionDouble:
     TOKEN_DOUBLE                                          {$$ = $1;}
    | expressionDouble TOKEN_ISEQ expressionDouble          {$$ = ($1 == $3)}
    | expressionDouble TOKEN_ISNOTEQ expressionDouble       {$$ = ($1 != $3)}
    | expressionDouble TOKEN_LE expressionDouble            {$$ = ($1 < $3) }
    | expressionDouble TOKEN_LEQ expressionDouble           {$$ = ($1 <= $3)}
    | expressionDouble TOKEN_GE expressionDouble            {$$ = ($1 > $3) }
    | expressionDouble TOKEN_GEQ expressionDouble           {$$ = ($1 >= $3)}
    | expressionDouble TOKEN_PLUS expressionDouble          {$$ = $1 + $3;}
    | expressionDouble TOKEN_MINUS expressionDouble         {$$ = $1 - $3;}
    | expressionDouble TOKEN_MUL expressionDouble           {$$ = $1 * $3;}
    | expressionDouble TOKEN_DIV expressionDouble           {$$ = $1 / $3;}
    | TOKEN_LEFTPAR expressionDouble TOKEN_RIGHTPAR         {$$ = $2;}
;



expressionInt:
    expressionInt TOKEN_AND expressionInt             {$$ = $1 && $3;}
    | expressionInt TOKEN_OR expressionInt            {$$ = $1 || $3;}
    | expressionInt TOKEN_ISEQ expressionInt          {$$ = ($1 == $3) }
    | expressionInt TOKEN_ISNOTEQ expressionInt       {$$ = ($1 != $3) }
    | expressionInt TOKEN_LE expressionInt            {$$ = ($1 < $3)  }
    | expressionInt TOKEN_LEQ expressionInt           {$$ = ($1 <= $3) }
    | expressionInt TOKEN_GE expressionInt            {$$ = ($1 > $3) }
    | expressionInt TOKEN_GEQ expressionInt           {$$ = ($1 >= $3) }
    | expressionInt TOKEN_PLUS expressionInt          {$$ = $1 + $3;}
    | expressionInt TOKEN_MINUS expressionInt         {$$ = $1 - $3;}
    | expressionInt TOKEN_MUL expressionInt           {$$ = $1 * $3;}
    | expressionInt TOKEN_DIV expressionInt           {$$ = $1 / $3;}
    | expressionInt TOKEN_MOD expressionInt           {$$ = $1 % $3;}
    | TOKEN_LEFTPAR expressionInt TOKEN_RIGHTPAR   {$$ = $2;}
    | TOKEN_INT                                 {$$ = $1;}
    | TOKEN_IDENT                               {
                                                $$ = nadji($1)->val;
                                                }
;  

%%   

void yyerror(const char* s) {
    
}


int main() {
   
    int rezultat = yyparse();

  

    if(brojGresaka == 0) {
        printf("Ulaz je bio ispravan!\n");
    }
    else {
        printf("Ulaz nije bio ispravan!\n");
    }

    return 0;
}