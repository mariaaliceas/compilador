%{
#include <stdio.h>
#include "y.tab.h"
extern int countn;
%}

%option yylineno

%%

"program"              { return PROGRAM; }
"declarar_inteiro"     { return DECLARAR_INTEIRO; }
"declarar_flutuante"   { return DECLARAR_FLUTUANTE; }
"if"                   { return IF; }
"else"                 { return ELSE; }
"for"                  { return FOR; }
"while"                { return WHILE; }
"return"               { return RETURN; }
"break"                { return BREAK; }
"continue"             { return CONTINUE; }
";"                    { return SEMI; }
"="                    { return ASSIGN; }
"("                    { return '('; }
")"                    { return ')'; }
[a-zA-Z_][a-zA-Z0-9_]* { yylval.str = strdup(yytext); return IDENTIFIER; }
[0-9]+                 { yylval.num = atoi(yytext); return INTEGER; }
[0-9]+\.[0-9]+         { yylval.fnum = atof(yytext); return FLOAT; }
\n                     { countn++; }
[ \t\r\f\v]+           { /* Ignorar espaços em branco */ }
.                      { /* Ignorar outros caracteres */ }

%%

int yywrap() {
  return 1;
}

int main() {
  yyparse();
  printf("Número de linhas: %d\n", countn);
  return 0;
}
