%{
#include <stdio.h>
#include "y.tab.h"
extern int countn;
%}

%option yylineno

%%
"mostrar"                       { return PRINTFF; }
"receber"                       { return SCANFF; }
"declarar inteiro"              { return INT; }
"declarar flutuante"            { return FLOAT; }
"declarar caractere"            { return CHAR; }
"declarar double"               { return DOUBLE; }
"retorno vazio"                 { return VOID; }
"devolver"                      { return RETURN; }
"para cada"                     { return FOR; }
"se"                            { return IF; }
"entao"                         { return ELSE; }
"incluir biblioteca"[ ]*<.+\.h  { return INCLUDE; }
"verdadeiro"                    { return TRUE; }
"falso"                         { return FALSE; }
"enquanto"                      { return WHILE; }
"continuar"                     { return CONTINUE; }
"parar"                         { return BREAK; }
"abre parenteses"               { return LPAREN; }
"fecha parenteses"              { return RPAREN; }
"abre colchetes"                { return LBRACK; }
"fecha colchetes"               { return RBRACK; }
"abre chaves"                   { return LBRACE; }
"fecha chaves"                  { return RBRACE; }
"ponto e virgula"               { return SEMI; }
"ponto"                         { return DOT; }
"virgula"                       { return COMMA; }
"atribuicao"                    { return ASSIGN; }
"referencia"                    { return REFER; }
"menor que"                     { return LESS; }
"menor ou igual que"            { return LESSEQUAL; }
"igual"                         { return EQUAL; }
"maior ou igual que"            { return GREATEREQUAL; }
"maior que"                     { return GREATER; }
"+"|"-"                         { return ADDOP; }
"*"                             { return MULOP; }
"/"                             { return DIVOP; }
"++"|"--"                       { return INCR; }
"||"                            { return OROP; }
"&&"                            { return ANDOP; }
"!"                             { return NOTOP; }
"=="|"!="                       { return EQUOP; }
\/\/.*                          { ; }
\/\*(.*\n)*.*\*\/               { ; } 
[ \t]*                          { ; }
[\n]                            { countn++; }
.	                              { return *yytext; }
["].*["]                        { return STR; }
['].[']                         { return CHARACTER; }
%%

int yywrap() {
  return 1;
}

int main() {
  yyparse();
  printf("Número de linhas: %d\n", countn);
  return 0;
}
