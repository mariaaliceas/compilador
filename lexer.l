%{
#include <stdio.h>
#include "y.tab.h"
extern int countn;  // Declare countn from lexer.l
%}

%option yylineno  // Include line number information

// No need to redefine tokens here, they are defined in lexer.l

%%

program : /* empty */
        | program statement '\n'
        ;

statement :  // Define grammar rules for valid statements
            declaration
         | expression_statement
         | selection_statement
         | iteration_statement
         | jump_statement
         ;

declaration :  declarar_inteiro identifier (';' | ASSIGN expression) 
              | declarar_flutuante identifier (';' | ASSIGN expression) 
              | ... // Add other data type declarations based on keywords

assignment : ASSIGN expression 

expression_statement : expression SEMI

selection_statement : IF '(' expression ')' statement (ELSE statement)?

iteration_statement : FOR '(' /* loop condition */ ')' statement 
                      | WHILE '(' expression ')' statement

jump_statement : RETURN expression? SEMI
               | BREAK SEMI
               | CONTINUE SEMI

/* Add more grammar rules for expressions and other statements as needed */ 

%%

int yywrap() {
  return 1;
}

int main() {
  yyparse();
  printf("Número de linhas: %d\n", countn);
  return 0;
}
