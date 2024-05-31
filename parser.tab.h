
/* A Bison parser, made by GNU Bison 2.4.1.  */

/* Skeleton interface for Bison's Yacc-like parsers in C
   
      Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
   Free Software Foundation, Inc.
   
   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.
   
   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.
   
   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.
   
   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */


/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     TOKEN_SC = 258,
     TOKEN_INT = 259,
     TOKEN_STRING = 260,
     TOKEN_DOUBLE = 261,
     TOKEN_IDENT = 262,
     TOKEN_TRUE = 263,
     TOKEN_FALSE = 264,
     TOKEN_PLUS = 265,
     TOKEN_MINUS = 266,
     TOKEN_MUL = 267,
     TOKEN_DIV = 268,
     TOKEN_MOD = 269,
     TOKEN_LE = 270,
     TOKEN_LEQ = 271,
     TOKEN_GE = 272,
     TOKEN_GEQ = 273,
     TOKEN_EQ = 274,
     TOKEN_ISEQ = 275,
     TOKEN_ISNOTEQ = 276,
     TOKEN_AND = 277,
     TOKEN_OR = 278,
     TOKEN_EXCLAM = 279,
     TOKEN_COMMA = 280,
     TOKEN_DOT = 281,
     TOKEN_LEFTPAR = 282,
     TOKEN_RIGHTPAR = 283,
     TOKEN_RIGHTBRACKET = 284,
     TOKEN_LEFTBRACKET = 285,
     TOKEN_FOR = 286,
     TOKEN_WHILE = 287,
     TOKEN_BREAK = 288,
     TOKEN_IF = 289,
     TOKEN_ELSE = 290,
     TOKEN_INTIDENT = 291,
     TOKEN_STRINGIDENT = 292,
     TOKEN_BOOLIDENT = 293,
     TOKEN_DOUBLEIDENT = 294,
     TOKEN_RETURN = 295,
     TOKEN_THIS = 296,
     TOKEN_LET = 297,
     TOKEN_IN = 298,
     TOKEN_READ = 299,
     TOKEN_WRITE = 300,
     TOKEN_END = 301,
     TOKEN_SKIP = 302,
     TOKEN_DOTSEQ = 303,
     TOKEN_FWSLASH = 304,
     TOKEN_FI = 305,
     TOKEN_INTCONST = 306,
     TOKEN_STRINGCONST = 307,
     TOKEN_BOOLCONST = 308,
     TOKEN_DOUBLECONST = 309,
     TOKEN_DO = 310,
     TOKEN_THEN = 311
   };
#endif



#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
{

/* Line 1676 of yacc.c  */
#line 112 "parser.y"
 

int int_value;
char* str_value;
double dbl_value;
bool bool_value;
char* ident;




/* Line 1676 of yacc.c  */
#line 120 "parser.tab.h"
} YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
#endif

extern YYSTYPE yylval;


