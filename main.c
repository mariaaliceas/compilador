#include <stdio.h>

extern int yylex();
extern char* yytext;

int main() {
    yylex();
    return 0;
}
