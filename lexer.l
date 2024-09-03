%{
#include "parser.tab.h" 
#include <stdlib.h>
#include <string.h>
%}

digit [0-9]
unary "++"|"--"
number {digit}+(\.{digit}+)?

%%

"mostrar"               { printf("TOKEN: PRINTFF, VALUE: %s\n", yytext); yylval.name = strdup(yytext); return PRINTFF; }
"scanf"                 { printf("TOKEN: SCANFF, VALUE: %s\n", yytext); yylval.name = strdup(yytext); return SCANFF; }
"declarar_int"          { printf("TOKEN: INT, VALUE: %s\n", yytext); yylval.name = strdup(yytext); return INT; }
"declarar_float"        { printf("TOKEN: FLOAT, VALUE: %s\n", yytext); yylval.name = strdup(yytext); return FLOAT; }
"declarar_char"         { printf("TOKEN: CHAR, VALUE: %s\n", yytext); yylval.name = strdup(yytext); return CHAR; }
"declarar_vazio"        { printf("TOKEN: VOID, VALUE: %s\n", yytext); yylval.name = strdup(yytext); return VOID; }
"retornar"              { printf("TOKEN: RETURN, VALUE: %s\n", yytext); yylval.name = strdup(yytext); return RETURN; }
"para_cada"             { printf("TOKEN: FOR, VALUE: %s\n", yytext); yylval.name = strdup(yytext); return FOR; }
"se"                    { printf("TOKEN: IF, VALUE: %s\n", yytext); yylval.name = strdup(yytext); return IF; }
"funcao"                { printf("TOKEN: FUNCTION, VALUE: %s\n", yytext); yylval.name = strdup(yytext); return FUNCTION; }
"senao"                 { printf("TOKEN: ELSE, VALUE: %s\n", yytext); yylval.name = strdup(yytext); return ELSE; }
"incluir_biblioteca"    { printf("TOKEN: INCLUDE, VALUE: %s\n", yytext); yylval.name = strdup(yytext); return INCLUDE; }
"verdadeiro"            { printf("TOKEN: TRUE, VALUE: %s\n", yytext); yylval.name = strdup(yytext); return TRUE; }
"falso"                 { printf("TOKEN: FALSE, VALUE: %s\n", yytext); yylval.name = strdup(yytext); return FALSE; }
"recebe"                { printf("TOKEN: ASSIGN, VALUE: %s\n", yytext); yylval.name = strdup(yytext); return ASSIGN; }
"("                     { yylval.name = strdup(yytext); return LPAREN; }
")"                     { yylval.name = strdup(yytext); return RPAREN; }
"{"                     { yylval.name = strdup(yytext); return LKEY; }
"}"                     { yylval.name = strdup(yytext); return RKEY; }
"["                     { yylval.name = strdup(yytext); return LBRACKET; }
"]"                     { yylval.name = strdup(yytext); return RBRACKET; }
","                     { yylval.name = strdup(yytext); return COMMA; }
\n                      {  yylineno++; return NEWLINE; }
\"[^\"]*\"              { printf("TOKEN: STRVAL, VALUE: %s\n", yytext); yylval.name = strdup(yytext); return STRVAL; }
[a-zA-Z_][a-zA-Z0-9_]*  { printf("TOKEN: ID, VALUE: %s\n", yytext); yylval.name = strdup(yytext); return ID; }
"<="                    { yylval.name = strdup(yytext); return LE; }
">="                    { yylval.name = strdup(yytext); return GE; }
"=="                    { yylval.name = strdup(yytext); return EQ; }
"!="                    { yylval.name = strdup(yytext); return NE; }
">"                     { yylval.name = strdup(yytext); return GT; }
"<"                     { yylval.name = strdup(yytext); return LT; }
"&&"                    { yylval.name = strdup(yytext); return AND; }
"||"                    { yylval.name = strdup(yytext); return OR; }
"+"                     { yylval.name = strdup(yytext); return ADD; }
"-"                     { yylval.name = strdup(yytext); return SUBTRACT; }
"/"                     { yylval.name = strdup(yytext); return DIVIDE; }
"*"                     { yylval.name = strdup(yytext); return MULTIPLY; }
";"                     { yylval.name = strdup(yytext); return SEMICOLON; }
[ \t]+                  { }
{number}                { printf("TOKEN: %s, VALUE: %s\n", strchr(yytext, '.') ? "FLOATVAL" : "INTVAL", yytext); yylval.name = strdup(yytext); return (strchr(yytext, '.') ? FLOATVAL : INTVAL); }
{unary}                 { printf("TOKEN: UNARY, VALUE: %s\n", yytext); yylval.name = strdup(yytext); return UNARY; }

%%

int yywrap() {
  return 1;
}
