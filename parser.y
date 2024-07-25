%{
#include <stdio.h>
#include "lex.yy.c"

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

void yyerror(const char *s) {
   fprintf(stderr, "Erro: %s na linha %d\n", s, yylineno);
}

%}

// Definição de tokens
%token PRINTFF SCANFF INT FLOAT CHAR DOUBLE VOID RETURN FOR IF ELSE INCLUDE TRUE FALSE WHILE CONTINUE BREAK
%token LPAREN RPAREN LBRACK RBRACK LBRACE RBRACE SEMI DOT COMMA ASSIGN REFER LESS LESSEQUAL EQUAL
%token GREATEREQUAL GREATER ADDOP MULOP DIVOP INCR OROP ANDOP NOTOP EQUOP STR CHARACTER IDENTIFIER EXPRESSION

%left '+' '-'
%left '*' '/'
%left INCR

%%

program : /* empty */ 
        | program statement '\n'
        ;

statement : declaration
          | expression_statement
          | selection_statement
          | iteration_statement
          | jump_statement
          ;

declaration : INT identifier SEMI
            | INT identifier assignment
            | FLOAT identifier SEMI
            | FLOAT identifier assignment
            ;

assignment : IDENTIFIER ASSIGN expression { printf("Assignment\n"); }
           ;

identifier : IDENTIFIER { printf("Identifier\n"); }
           ;

expression : identifier { printf("Expression Identifier\n"); }
           ;           

expression_statement : expression SEMI
                     ;

selection_statement : IF LPAREN expression RPAREN statement 
                    | IF LPAREN expression RPAREN statement ELSE statement
                    ;

iteration_statement : FOR LPAREN /* loop condition */ RPAREN statement 
                    | WHILE LPAREN expression RPAREN statement
                    ;

jump_statement : RETURN expression SEMI
               | RETURN SEMI
               | BREAK SEMI
               | CONTINUE SEMI
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
