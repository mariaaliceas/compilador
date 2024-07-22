%{
#include <stdio.h>
#include "lex.yy.c"

extern int countn;
int countn = 0;

// Protótipos de funções
int yylex();
int yyparse();

%}

%token PRINTFF SCANFF INT FLOAT CHAR DOUBLE VOID RETURN FOR IF ELSE INCLUDE
%token TRUE FALSE WHILE CONTINUE BREAK LPAREN RPAREN LBRACK RBRACK LBRACE RBRACE SEMI
%token DOT COMMA ASSIGN REFER LESS LESSEQUAL EQUAL GREATEREQUAL GREATER ADDOP MULOP DIVOP
%token INCR OROP ANDOP NOTOP EQUOP
%token <str> STR
%token <char> CHARACTER

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
