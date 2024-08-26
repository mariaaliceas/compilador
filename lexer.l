%{
#include "parser.tab.h" 
#include <stdlib.h>
#include <string.h>
%}

digit [0-9]
unary "++"|"--"
number {digit}+(\.{digit}+)?

%%

"mostrar"               { yylval.name = strdup(yytext); return PRINTFF; }
"scanf"                 { yylval.name = strdup(yytext); return SCANFF; }
"declarar_int"          { yylval.name = strdup(yytext); return INT; }
"declarar_float"        { yylval.name = strdup(yytext); return FLOAT; }
"declarar_char"         { yylval.name = strdup(yytext); return CHAR; }
"declarar_vazio"        { yylval.name = strdup(yytext); return VOID; }
"retornar"              { yylval.name = strdup(yytext); return RETURN; }
"para_cada"             { yylval.name = strdup(yytext); return FOR; }
"se"                    { yylval.name = strdup(yytext); return IF; }
"funcao"                { yylval.name = strdup(yytext); return FUNCTION; }
"senao"                 { yylval.name = strdup(yytext); return ELSE; }
"incluir_biblioteca"    { yylval.name = strdup(yytext); return INCLUDE; }
"verdadeiro"            { yylval.name = strdup(yytext); return TRUE; }
"falso"                 { yylval.name = strdup(yytext); return FALSE; }
"recebe"                { yylval.name = strdup(yytext); return ASSIGN; }
"("                     { yylval.name = strdup(yytext); return LPAREN; }
")"                     { yylval.name = strdup(yytext); return RPAREN; }
"{"                     { yylval.name = strdup(yytext); return LKEY; }
"}"                     { yylval.name = strdup(yytext); return RKEY; }
"["                     { yylval.name = strdup(yytext); return LBRACKET; }
"]"                     { yylval.name = strdup(yytext); return RBRACKET; }
","                     { yylval.name = strdup(yytext); return COMMA; }
\n                      { yylineno++; return NEWLINE; }
\"[^\"]*\"              { yylval.name = strdup(yytext); return STR; }
"\'[^\']\'"             { yylval.name = strdup(yytext); return CHARACTER; }
[a-zA-Z_][a-zA-Z0-9_]*  { yylval.name = strdup(yytext); return ID; }
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
";"                     { yylval.name = strdup(yytext);  return SEMICOLON; }
[ \t]+                  { }
{number}                { yylval.name = strdup(yytext); return (strchr(yytext, '.') ? FLOAT : INT); }
{unary}                 { yylval.name = strdup(yytext); return UNARY; }

%%

int yywrap() {
  return 1;
}