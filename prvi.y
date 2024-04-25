%{

#include <stdlib.h>
#include <stdio.h>
#include <stdbool.h>

void yyerror(const char* s);

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



%left TOKEN_AND TOKEN_OR
%left TOKEN_LE TOKEN_LEQ TOKEN_GE TOKEN_GEQ
%left TOKEN_PLUS TOKEN_MINUS
%left TOKEN_MUL TOKEN_DIV TOKEN_MOD

%type <int_value>expression
%type <int_value>stat

%type <dbl_value>expression2
%type <dbl_value>stat2



%%

S: stat   {}
|  stat2  {}
|  S stat   {}
|  S stat2  {}
;


stat: expression TOKEN_SC {printf("%d\n",$1);}
    | TOKEN_IDENT TOKEN_EQ expression TOKEN_SC {printf("%s %d\n",$1, $3);}
;

stat2: expression2 TOKEN_SC {printf("%f\n",$1);}
    | TOKEN_IDENT TOKEN_EQ expression2 TOKEN_SC {printf("%s %f\n",$1, $3);}
;

expression2:
    TOKEN_DOUBLE                              {$$ = $1;}
;



expression:
    expression TOKEN_AND expression             {$$ = $1 && $3;}
    | expression TOKEN_OR expression            {$$ = $1 || $3;}
    | expression TOKEN_ISEQ expression          {$$ = $1 == $3;}
    | expression TOKEN_ISNOTEQ expression       {$$ = $1 != $3;}
    | expression TOKEN_LE expression            {$$ = $1 < $3;}
    | expression TOKEN_LEQ expression           {$$ = $1 <= $3;}
    | expression TOKEN_GE expression            {$$ = $1 > $3;}
    | expression TOKEN_GEQ expression           {$$ = $1 >= $3;}
    | expression TOKEN_PLUS expression          {$$ = $1 + $3;}
    | expression TOKEN_MINUS expression         {$$ = $1 - $3;}
    | expression TOKEN_MUL expression           {$$ = $1 * $3;}
    | expression TOKEN_DIV expression           {$$ = $1 / $3;}
    | expression TOKEN_MOD expression           {$$ = $1 % $3;}
    | TOKEN_LEFTPAR expression TOKEN_RIGHTPAR   {$$ = $2;}
    | TOKEN_INT                                 {$$ = $1;}
    | TOKEN_STRING                              {$$ = 0;}
    | TOKEN_FALSE                               {$$ = $1;}
    | TOKEN_TRUE                                {$$ = $1;}
    | TOKEN_IDENT                               {$$ = 0;}
    
;

%%   

void yyerror(const char* s) { // poklapa se sa definicijom f-je u bisonu
    printf("%s\n",s);
}


int main() {
   
    int rezultat = yyparse();

  

    if(rezultat == 0) {
        printf("Ulaz je bio ispravan!\n");
    }
    else {
        printf("Ulaz nije bio ispravan!\n");
    }

    return 0;
}