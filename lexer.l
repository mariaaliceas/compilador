%{
#include "parser.tab.h" 
#include <stdlib.h>
#include <string.h>
%}

digit [0-9]
unary "++"|"--"
number {digit}+(\.{digit}+)?  

%%

"mostrar"               { printf("Token: PRINTFF, Valor: %s\n", yytext); return PRINTFF; }
"scanf"                 { printf("Token: SCANFF, Valor: %s\n", yytext); return SCANFF; }
"declarar_int"          { printf("Token: INT, Valor: %s\n", yytext); return INT; }
"declarar_float"        { printf("Token: FLOAT, Valor: %s\n", yytext); return FLOAT; }
"declarar_char"         { printf("Token: CHAR, Valor: %s\n", yytext); return CHAR; }
"declarar_vazio"        { printf("Token: VOID, Valor: %s\n", yytext); return VOID; }
"retornar"              { printf("Token: RETURN, Valor: %s\n", yytext); return RETURN; }
"para_cada"             { printf("Token: FOR, Valor: %s\n", yytext); return FOR; }
"se"                    { printf("Token: IF, Valor: %s\n", yytext); return IF; }
"funcao"                { printf("Token: FUNCTION, Valor: %s\n", yytext); return FUNCTION; }
"senao"                 { printf("Token: ELSE, Valor: %s\n", yytext); return ELSE; }
"incluir_biblioteca"    { printf("Token: INCLUDE, Valor: %s\n", yytext); return INCLUDE; }
"verdadeiro"            { printf("Token: TRUE, Valor: %s\n", yytext); return TRUE; }
"falso"                 { printf("Token: FALSE, Valor: %s\n", yytext); return FALSE; }
"("                     { printf("Token: LPAREN\n"); return LPAREN; }
")"                     { printf("Token: RPAREN\n"); return RPAREN; }
"{"                     { printf("Token: LKEY\n"); return LKEY; }
"}"                     { printf("Token: RKEY\n"); return RKEY; }
","                     { printf("Token: COMMA\n"); return COMMA; }
\n                      { yylineno++; printf("Token: NEWLINE\n"); return NEWLINE; }
"recebe"                { printf("Token: ASSIGN, Valor: %s\n", yytext); return ASSIGN; }
\"[^\"]*\"              { printf("Token: STR, Valor: %s\n", yytext); yylval.name = strdup(yytext); return STR; }
"\'[^\']\'"             { printf("Token: CHARACTER, Valor: %s\n", yytext); return CHARACTER; }
[a-zA-Z_][a-zA-Z0-9_]*  { printf("Token: ID, Valor: %s\n", yytext); return ID; }
"<="                    { printf("Token: LE, Valor: %s\n", yytext); return LE; }
">="                    { printf("Token: GE, Valor: %s\n", yytext); return GE; }
"=="                    { printf("Token: EQ, Valor: %s\n", yytext); return EQ; }
"!="                    { printf("Token: NE, Valor: %s\n", yytext); return NE; }
">"                     { printf("Token: GT, Valor: %s\n", yytext); return GT; }
"<"                     { printf("Token: LT, Valor: %s\n", yytext); return LT; }
"&&"                    { printf("Token: AND, Valor: %s\n", yytext); return AND; }
"||"                    { printf("Token: OR, Valor: %s\n", yytext); return OR; }
"+"                     { printf("Token: ADD, Valor: %s\n", yytext); return ADD; }
"-"                     { printf("Token: SUBTRACT, Valor: %s\n", yytext); return SUBTRACT; }
"/"                     { printf("Token: DIVIDE, Valor: %s\n", yytext); return DIVIDE; }
";"                     { printf("Token: SEMICOLON\n"); return SEMICOLON; }
"*"                     { printf("Token: MULTIPLY, Valor: %s\n", yytext); return MULTIPLY; }
[ \t]+                  { }
{number}                { printf("Token: %s, Valor: %s\n", (strchr(yytext, '.') ? "FLOAT_NUM" : "NUMBER"), yytext); return (strchr(yytext, '.') ? FLOAT_NUM : NUMBER); }
{unary}                 { printf("Token: UNARY, Valor: %s\n", yytext); return UNARY; }

%%

int yywrap() {
  return 1;
}