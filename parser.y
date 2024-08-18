%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern int yylex();
void yyerror(const char *s);
%}

%union {
    int intval;
    float floatval;
    char *name;
}

%token <intval> NUMBER
%token <floatval> FLOAT_NUM
%token <name> ID STR CHARACTER

%token PRINTFF SCANFF INT FLOAT CHAR VOID RETURN FOR IF ELSE INCLUDE TRUE FALSE
%token UNARY LE GE EQ NE GT LT AND OR ADD SUBTRACT DIVIDE MULTIPLY

%type program statement declaration control_flow function_call

%left '+' '-'
%left '*' '/'
%right UNARY

%%

program:
    program statement
  | statement
  ;

statement:
    expression ';'
  | declaration ';'
  | control_flow
  | INCLUDE ID
  | PRINTFF STR ';' { printf("%s\n", $2); }
  ;

expression:
    assignment
  | conditional_expression
  ;

conditional_expression:
    logical_or_expression
  | logical_or_expression '?' expression ':' expression
  ;

logical_or_expression:
    logical_and_expression
  | logical_and_expression OR logical_or_expression
  ;

logical_and_expression:
    equality_expression
  | equality_expression AND logical_and_expression
  ;

equality_expression:
    relational_expression
  | equality_expression EQ relational_expression
  | equality_expression NE relational_expression
  ;

relational_expression:
    additive_expression
  | additive_expression LE additive_expression
  | additive_expression GE additive_expression
  | additive_expression LT additive_expression
  | additive_expression GT additive_expression
  ;

additive_expression:
    multiplicative_expression
  | additive_expression ADD multiplicative_expression
  | additive_expression SUBTRACT multiplicative_expression
  ;

multiplicative_expression:
    unary_expression
  | multiplicative_expression MULTIPLY unary_expression
  | multiplicative_expression DIVIDE unary_expression
  ;

unary_expression:
    primary_expression
  | SUBTRACT primary_expression
  ;

primary_expression:
    NUMBER
  | FLOAT_NUM
  | '(' expression ')'
  | function_call
  ;

assignment:
    ID '=' expression
  ;

declaration:
    type ID
  | type ID '=' expression
  ;

type:
    INT
  | FLOAT
  | CHAR
  | VOID
  ;

control_flow:
    IF '(' expression ')' statement 
  | IF '(' expression ')' statement ELSE statement
  | FOR '(' declaration ';' expression ';' assignment ')' statement
  ;

function_call:
    ID '(' argument_list ')'
  ;

argument_list:
    argument_list ',' expression
  | expression
  ;

%%

void yyerror(const char *s) {
    extern int yylineno;
    fprintf(stderr, "Erro: %s na linha %d\n", s, yylineno);
}

int main(int argc, char **argv) {
    if (yyparse() == 0) {
        printf("Parsing completed successfully!\n");
    }
    return 0;
}
