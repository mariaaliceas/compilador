%{
#include <stdio.h>
#include "lex.yy.c"

// Definição dos tokens
#define PRINTFF     1
#define SCANFF      2
#define INT         3
#define FLOAT       4
#define CHAR        5
#define DOUBLE      6
#define VOID        7
#define RETURN      8
#define FOR         9
#define IF          10
#define ELSE        11
#define INCLUDE     12
#define TRUE        13
#define FALSE       14
#define WHILE       15
#define CONTINUE    16
#define BREAK       17
#define LPAREN      18
#define RPAREN      19
#define LBRACK      20
#define RBRACK      21
#define LBRACE      22
#define RBRACE      23
#define SEMI        24
#define DOT         25
#define COMMA       26
#define ASSIGN      27
#define REFER       28
#define LESS        29
#define LESSEQUAL   30
#define EQUAL       31
#define GREATEREQUAL 32
#define GREATER     33
#define ADDOP       34
#define MULOP       35
#define DIVOP       36
#define INCR        37
#define OROP        38
#define ANDOP       39
#define NOTOP       40
#define EQUOP       41
#define STR         42
#define CHARACTER   43

// Definição do tipo YYSTYPE
typedef union {
    char *str_val;
    int int_val;
    float float_val;
} YYSTYPE;

// Variável global para contar o número de linhas
extern int countn;
int countn = 0;

// Protótipos de funções
int yylex();
int yyparse();

// Indicação de que YYSTYPE está definido
#define YYSTYPE_IS_DECLARED

// Definição de tokens
%token <str_val> STR
%token <int_val> CHARACTER

%token PRINTFF SCANFF INT FLOAT CHAR DOUBLE VOID RETURN FOR IF ELSE INCLUDE TRUE FALSE WHILE CONTINUE BREAK
%token LPAREN RPAREN LBRACK RBRACK LBRACE RBRACE SEMI DOT COMMA ASSIGN REFER LESS LESSEQUAL EQUAL
%token GREATEREQUAL GREATER ADDOP MULOP DIVOP INCR OROP ANDOP NOTOP EQUOP

%left '+' '-'
%left '*' '/'
%left INCR

%%

program : /* empty */
        | program statement '\n'
        ;

statement : PRINTFF
          | SCANFF
          | INT
          | FLOAT
          | CHAR
          | DOUBLE
          | VOID
          | RETURN
          | FOR
          | IF
          | ELSE
          | INCLUDE
          | TRUE
          | FALSE
          | WHILE
          | CONTINUE
          | BREAK
          | LPAREN
          | RPAREN
          | LBRACK
          | RBRACK
          | LBRACE
          | RBRACE
          | SEMI
          | DOT
          | COMMA
          | ASSIGN
          | REFER
          | LESS
          | LESSEQUAL
          | EQUAL
          | GREATEREQUAL
          | GREATER
          | ADDOP
          | MULOP
          | DIVOP
          | INCR
          | OROP
          | ANDOP
          | NOTOP
          | EQUOP
          | STR
          | CHARACTER
          ;

%%

int yywrap() {
    return 1;
}

int main() {
    yyparse();
    printf("Número de linhas: %d\n", countn);
    return 0;
}
