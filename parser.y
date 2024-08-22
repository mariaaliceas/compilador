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

%token <intval> INT
%token <floatval> FLOAT
%token <name> STR CHARACTER

%left IF 
%nonassoc ELSE

%token PRINTFF SCANFF CHAR VOID RETURN FOR INCLUDE TRUE FALSE FUNCTION ID
%token UNARY LE GE EQ NE GT LT AND OR ADD SUBTRACT DIVIDE MULTIPLY
%token LPAREN RPAREN COMMA NEWLINE SEMICOLON ASSIGN LKEY RKEY RBRACKET LBRACKET

%type program statement declaration control_flow function_call expression conditional_expression logical_or_expression logical_and_expression equality_expression relational_expression additive_expression multiplicative_expression unary_expression primary_expression assignment

%left '+' '-'
%left '*' '/'
%right UNARY
%nonassoc '?' ':' 

%%
program:
      | program NEWLINE
      | program statement
      | program function_definition
      | program function_call
      ;

statement:
      NEWLINE
      | expression SEMICOLON
      | declaration
      | control_flow
      | function_call
      | INCLUDE ID SEMICOLON
      | RETURN expression SEMICOLON
      | PRINTFF expression SEMICOLON
      | PRINTFF type SEMICOLON
      ;

expression:
      assignment
      | conditional_expression
      | array_position
      ;

conditional_expression:
      logical_or_expression
      | logical_or_expression '?' expression ':' expression
      ;

logical_or_expression:
      logical_and_expression
      | logical_or_expression OR logical_and_expression
      ;

logical_and_expression:
      equality_expression
      | equality_expression AND logical_and_expression
      ;

equality_expression:
      relational_expression
      | relational_expression EQ relational_expression
      | relational_expression NE relational_expression
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
      | SUBTRACT unary_expression %prec UNARY
      ;

primary_expression:
      INT
      | FLOAT
      | STR
      | CHARACTER
      | LPAREN expression RPAREN
      | function_call
      | ID
      ;

function_definition:
      FUNCTION ID LPAREN parameter_list RPAREN LKEY statement_list RKEY
      ;

statement_list:
      statement
      | statement_list statement
      ;

assignment: 
      ID ASSIGN expression 
      | ID ASSIGN array_list
      | array_position ASSIGN expression
      ;

array_position:
      ID LBRACKET INT RBRACKET
      ;

array_list:
      LBRACKET array_arguments RBRACKET
      ;

array_arguments:
      INT
      | array_arguments COMMA INT
      ;

declaration:
      type ID SEMICOLON
      | type ID ASSIGN expression SEMICOLON
      | type ID LBRACKET INT RBRACKET SEMICOLON
      ;

type:
      INT
      | FLOAT
      | CHAR
      | STR
      | VOID
      ;

control_flow:
      IF LPAREN expression RPAREN LKEY statement_list RKEY
      | IF LPAREN expression RPAREN LKEY statement_list RKEY else
      | FOR LPAREN expression SEMICOLON expression RPAREN LKEY statement_list RKEY
      ;

else:
      ELSE LKEY statement_list RKEY
      | NEWLINE ELSE LKEY statement_list RKEY
      ;

function_call:
      ID LPAREN parameter_list RPAREN SEMICOLON
      ;

parameter:
      ID
      | type
      ;

parameter_list:
      | parameter
      | parameter COMMA parameter_list
      ;

%%
void yyerror(const char *s) {
    extern int yylineno;
    extern char *yytext;

    fprintf(stderr, "Erro: %s na linha %d\n", s, yylineno);
    fprintf(stderr, "Ultimo token encontrado: %s\n", yytext);
}

int main(int argc, char **argv) { 
    if (yyparse() == 0) {
        printf("Parsing completed successfully!\n");
    }
    return 0;
}
