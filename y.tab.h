/* A Bison parser, made by GNU Bison 3.8.2.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2021 Free Software Foundation,
   Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <https://www.gnu.org/licenses/>.  */

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

/* DO NOT RELY ON FEATURES THAT ARE NOT DOCUMENTED in the manual,
   especially those whose name start with YY_ or yy_.  They are
   private implementation details that can be changed or removed.  */

#ifndef YY_YY_Y_TAB_H_INCLUDED
# define YY_YY_Y_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token kinds.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    YYEMPTY = -2,
    YYEOF = 0,                     /* "end of file"  */
    YYerror = 256,                 /* error  */
    YYUNDEF = 257,                 /* "invalid token"  */
    PRINTFF = 258,                 /* PRINTFF  */
    SCANFF = 259,                  /* SCANFF  */
    INT = 260,                     /* INT  */
    FLOAT = 261,                   /* FLOAT  */
    CHAR = 262,                    /* CHAR  */
    DOUBLE = 263,                  /* DOUBLE  */
    VOID = 264,                    /* VOID  */
    RETURN = 265,                  /* RETURN  */
    FOR = 266,                     /* FOR  */
    IF = 267,                      /* IF  */
    ELSE = 268,                    /* ELSE  */
    INCLUDE = 269,                 /* INCLUDE  */
    TRUE = 270,                    /* TRUE  */
    FALSE = 271,                   /* FALSE  */
    WHILE = 272,                   /* WHILE  */
    CONTINUE = 273,                /* CONTINUE  */
    BREAK = 274,                   /* BREAK  */
    LPAREN = 275,                  /* LPAREN  */
    RPAREN = 276,                  /* RPAREN  */
    LBRACK = 277,                  /* LBRACK  */
    RBRACK = 278,                  /* RBRACK  */
    LBRACE = 279,                  /* LBRACE  */
    RBRACE = 280,                  /* RBRACE  */
    SEMI = 281,                    /* SEMI  */
    DOT = 282,                     /* DOT  */
    COMMA = 283,                   /* COMMA  */
    ASSIGN = 284,                  /* ASSIGN  */
    REFER = 285,                   /* REFER  */
    LESS = 286,                    /* LESS  */
    LESSEQUAL = 287,               /* LESSEQUAL  */
    EQUAL = 288,                   /* EQUAL  */
    GREATEREQUAL = 289,            /* GREATEREQUAL  */
    GREATER = 290,                 /* GREATER  */
    ADDOP = 291,                   /* ADDOP  */
    MULOP = 292,                   /* MULOP  */
    DIVOP = 293,                   /* DIVOP  */
    INCR = 294,                    /* INCR  */
    OROP = 295,                    /* OROP  */
    ANDOP = 296,                   /* ANDOP  */
    NOTOP = 297,                   /* NOTOP  */
    EQUOP = 298,                   /* EQUOP  */
    STR = 299,                     /* STR  */
    CHARACTER = 300,               /* CHARACTER  */
    IDENTIFIER = 301,              /* IDENTIFIER  */
    EXPRESSION = 302               /* EXPRESSION  */
  };
  typedef enum yytokentype yytoken_kind_t;
#endif
/* Token kinds.  */
#define YYEMPTY -2
#define YYEOF 0
#define YYerror 256
#define YYUNDEF 257
#define PRINTFF 258
#define SCANFF 259
#define INT 260
#define FLOAT 261
#define CHAR 262
#define DOUBLE 263
#define VOID 264
#define RETURN 265
#define FOR 266
#define IF 267
#define ELSE 268
#define INCLUDE 269
#define TRUE 270
#define FALSE 271
#define WHILE 272
#define CONTINUE 273
#define BREAK 274
#define LPAREN 275
#define RPAREN 276
#define LBRACK 277
#define RBRACK 278
#define LBRACE 279
#define RBRACE 280
#define SEMI 281
#define DOT 282
#define COMMA 283
#define ASSIGN 284
#define REFER 285
#define LESS 286
#define LESSEQUAL 287
#define EQUAL 288
#define GREATEREQUAL 289
#define GREATER 290
#define ADDOP 291
#define MULOP 292
#define DIVOP 293
#define INCR 294
#define OROP 295
#define ANDOP 296
#define NOTOP 297
#define EQUOP 298
#define STR 299
#define CHARACTER 300
#define IDENTIFIER 301
#define EXPRESSION 302

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef int YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;


int yyparse (void);


#endif /* !YY_YY_Y_TAB_H_INCLUDED  */
