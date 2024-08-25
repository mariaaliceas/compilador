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
"fim"                   { printf("TOKEN: END, VALUE: %s\n", yytext); yylval.name = strdup(yytext); return END; }
"("                     { printf("TOKEN: LPAREN, VALUE: %s\n", yytext); yylval.name = strdup(yytext); return LPAREN; }
")"                     { printf("TOKEN: RPAREN, VALUE: %s\n", yytext); yylval.name = strdup(yytext); return RPAREN; }
"{"                     { printf("TOKEN: LKEY, VALUE: %s\n", yytext); yylval.name = strdup(yytext); return LKEY; }
"}"                     { printf("TOKEN: RKEY, VALUE: %s\n", yytext); yylval.name = strdup(yytext); return RKEY; }
"["                     { printf("TOKEN: LBRACKET, VALUE: %s\n", yytext); yylval.name = strdup(yytext); return LBRACKET; }
"]"                     { printf("TOKEN: RBRACKET, VALUE: %s\n", yytext); yylval.name = strdup(yytext); return RBRACKET; }
","                     { printf("TOKEN: COMMA, VALUE: %s\n", yytext); yylval.name = strdup(yytext); return COMMA; }
\n                      { printf("TOKEN: NEWLINE, VALUE: \\n\n"); yylineno++; return NEWLINE; }
\"[^\"]*\"              { printf("TOKEN: STR, VALUE: %s\n", yytext); yylval.name = strdup(yytext); return STR; }
"\'[^\']\'"             { printf("TOKEN: CHARACTER, VALUE: %s\n", yytext); yylval.name = strdup(yytext); return CHARACTER; }
[a-zA-Z_][a-zA-Z0-9_]*  { printf("TOKEN: ID, VALUE: %s\n", yytext); yylval.name = strdup(yytext); return ID; }
"<="                    { printf("TOKEN: LE, VALUE: %s\n", yytext); yylval.name = strdup(yytext); return LE; }
">="                    { printf("TOKEN: GE, VALUE: %s\n", yytext); yylval.name = strdup(yytext); return GE; }
"=="                    { printf("TOKEN: EQ, VALUE: %s\n", yytext); yylval.name = strdup(yytext); return EQ; }
"!="                    { printf("TOKEN: NE, VALUE: %s\n", yytext); yylval.name = strdup(yytext); return NE; }
">"                     { printf("TOKEN: GT, VALUE: %s\n", yytext); yylval.name = strdup(yytext); return GT; }
"<"                     { printf("TOKEN: LT, VALUE: %s\n", yytext); yylval.name = strdup(yytext); return LT; }
"&&"                    { printf("TOKEN: AND, VALUE: %s\n", yytext); yylval.name = strdup(yytext); return AND; }
"||"                    { printf("TOKEN: OR, VALUE: %s\n", yytext); yylval.name = strdup(yytext); return OR; }
"+"                     { printf("TOKEN: ADD, VALUE: %s\n", yytext); yylval.name = strdup(yytext); return ADD; }
"-"                     { printf("TOKEN: SUBTRACT, VALUE: %s\n", yytext); yylval.name = strdup(yytext); return SUBTRACT; }
"/"                     { printf("TOKEN: DIVIDE, VALUE: %s\n", yytext); yylval.name = strdup(yytext); return DIVIDE; }
"*"                     { printf("TOKEN: MULTIPLY, VALUE: %s\n", yytext); yylval.name = strdup(yytext); return MULTIPLY; }
";"                     { printf("TOKEN: SEMICOLON, VALUE: %s\n", yytext); yylval.name = strdup(yytext); return SEMICOLON; }
[ \t]+                  { }
{number}                { printf("TOKEN: %s, VALUE: %s\n", strchr(yytext, '.') ? "FLOAT" : "INT", yytext); yylval.name = strdup(yytext); return (strchr(yytext, '.') ? FLOAT : INT); }
{unary}                 { printf("TOKEN: UNARY, VALUE: %s\n", yytext); yylval.name = strdup(yytext); return UNARY; }

%%

int yywrap() {
  return 1;
}
