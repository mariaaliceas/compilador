%{
#include "parser.tab.h" 
#include <stdlib.h>
#include <string.h>
%}

digit [0-9]
letter [a-zA-Z]
identifier {letter}({letter}|{digit}|_)*
number {digit}+(\.{digit}+)?([eE][-+]?{digit}+)?
string \"(\\.|[^\"\n])*\"
unary "++"|"--"

%%

"mostrar"               { return PRINTFF; }
"receber"               { return SCANFF; }
"declarar_int"          { return INT; }
"declarar_float"        { return FLOAT; }
"declarar_char"         { return CHAR; }
"declarar_vazio"        { return VOID; }
"retornar"              { return RETURN; }
"para_cada"             { return FOR; }
"se"                    { return IF; }
"entao"                 { return ELSE; }
"incluir_biblioteca"    { return INCLUDE; }
"verdadeiro"            { return TRUE; }
"falso"                 { return FALSE; }
{number}                { return (strchr(yytext, '.') ? FLOAT_NUM : NUMBER); }
{unary}                 { return UNARY; }
"<="                    { return LE; }
">="                    { return GE; }
"=="                    { return EQ; }
"!="                    { return NE; }
">"                     { return GT; }
"<"                     { return LT; }
"&&"                    { return AND; }
"||"                    { return OR; }
"+"                     { return ADD; }
"-"                     { return SUBTRACT; }
"/"                     { return DIVIDE; }
"*"                     { return MULTIPLY; }
[ \t\n]+                { /* Ignora espaços em branco e quebras de linha */ }
{string}                { yylval.name = strdup(yytext); return STR; }
"\'[^\']\'"             { return CHARACTER; }
[a-zA-Z_][a-zA-Z_0-9]*  { yylval.name = strdup(yytext); return ID; }

%%

int yywrap() {
  return 1;
}