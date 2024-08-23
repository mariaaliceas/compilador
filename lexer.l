%{
    #include "y.tab.h"
    #include <stdio.h>
    #include <string.h>
    
    int countn = 0;  // Contador de linhas
%}

%option yylineno

alpha [a-zA-Z]
digit [0-9]
unary "++"|"--"

%%

"mostra"                    { 
    printf("Token MOSTRAR detectado: %s\n", yytext);
    strcpy(yylval.nd_obj.name, yytext);
    return PRINTFF; 
}

"recebe"                     { 
    printf("Token RECEBE detectado: %s\n", yytext);
    strcpy(yylval.nd_obj.name, yytext);
    return SCANFF; 
}

"declara_inteiro"                       { 
    printf("Token DECLARA_INTEIRO detectado: %s\n", yytext);
    strcpy(yylval.nd_obj.name, yytext);
    return INT; 
}

"declara_flutuante"                     { 
    printf("Token DECLARA_FLUTUANTE detectado: %s\n", yytext);
    strcpy(yylval.nd_obj.name, yytext);
    return FLOAT; 
}

"declara_caracter"                      { 
    printf("Token CARACTER detectado: %s\n", yytext);
    strcpy(yylval.nd_obj.name, yytext);
    return CHAR; 
}

"vazio"                      { 
    printf("Token VAZIO detectado: %s\n", yytext);
    strcpy(yylval.nd_obj.name, yytext);
    return VOID; 
}

"retorna"                    { 
    printf("Token RETORNA detectado: %s\n", yytext);
    strcpy(yylval.nd_obj.name, yytext);
    return RETURN; 
}

"laco_for"                       { 
    printf("Token LACO_FOR detectado: %s\n", yytext);
    strcpy(yylval.nd_obj.name, yytext);
    return FOR; 
}

"se"                        { 
    printf("Token SE detectado: %s\n", yytext);
    strcpy(yylval.nd_obj.name, yytext);
    return IF; 
}

"senao"                      { 
    printf("Token SENAO detectado: %s\n", yytext);
    strcpy(yylval.nd_obj.name, yytext);
    return ELSE; 
}

^"#include"[ ]*<.+\.h>      { 
    printf("Token INCLUI detectado: %s\n", yytext);
    strcpy(yylval.nd_obj.name, yytext);
    return INCLUDE; 
}

"verdadeiro"                      { 
    printf("Token VERDADEIRO detectado: %s\n", yytext);
    strcpy(yylval.nd_obj.name, yytext);
    return TRUE; 
}

"falso"                     { 
    printf("Token FALSO detectado: %s\n", yytext);
    strcpy(yylval.nd_obj.name, yytext);
    return FALSE; 
}


[-]?{digit}+                { 
    printf("Token NUMERO detectado: %s\n", yytext);
    strcpy(yylval.nd_obj.name, yytext);
    return NUMBER; 
}

[-]?{digit}+\.{digit}{1,6}  { 
    printf("Token NUMERO_FLUTUANTE detectado: %s\n", yytext);
    strcpy(yylval.nd_obj.name, yytext);
    return FLOAT_NUM; 
}

{alpha}({alpha}|{digit})*   { 
    printf("Token ID detectado: %s\n", yytext);
    strcpy(yylval.nd_obj.name, yytext);
    return ID; 
}

{unary}                     { 
    printf("Token UNARY detectado: %s\n", yytext);
    strcpy(yylval.nd_obj.name, yytext);
    return UNARY; 
}

"<="                        { 
    printf("Token MENOR_IGUAL detectado: %s\n", yytext);
    strcpy(yylval.nd_obj.name, yytext);
    return LE; 
}

">="                        { 
    printf("Token MAIOR_IGUAL detectado: %s\n", yytext);
    strcpy(yylval.nd_obj.name, yytext);
    return GE; 
}

"=="                        { 
    printf("Token IGUAL detectado: %s\n", yytext);
    strcpy(yylval.nd_obj.name, yytext);
    return EQ; 
}

"!="                        { 
    printf("Token DIFERENTE detectado: %s\n", yytext);
    strcpy(yylval.nd_obj.name, yytext);
    return NE; 
}

">"                         { 
    printf("Token MAIOR_QUE detectado: %s\n", yytext);
    strcpy(yylval.nd_obj.name, yytext);
    return GT; 
}

"<"                         { 
    printf("Token MENOR_QUE detectado: %s\n", yytext);
    strcpy(yylval.nd_obj.name, yytext);
    return LT; 
}

"&&"                        { 
    printf("Token E detectado: %s\n", yytext);
    strcpy(yylval.nd_obj.name, yytext);
    return AND; 
}

"||"                        { 
    printf("Token OU detectado: %s\n", yytext);
    strcpy(yylval.nd_obj.name, yytext);
    return OR; 
}

"+"                         { 
    printf("Token ADICIONA detectado: %s\n", yytext);
    strcpy(yylval.nd_obj.name, yytext);
    return ADD; 
}

"-"                         { 
    printf("Token SUBTRAI detectado: %s\n", yytext);
    strcpy(yylval.nd_obj.name, yytext);
    return SUBTRACT; 
}

"/"                         { 
    printf("Token DIVIDE detectado: %s\n", yytext);
    strcpy(yylval.nd_obj.name, yytext);
    return DIVIDE; 
}

"*"                         { 
    printf("Token MULTIPLICA detectado: %s\n", yytext);
    strcpy(yylval.nd_obj.name, yytext);
    return MULTIPLY; 
}

\/\/.*                      { ; }

\/\*(.*\n)*.*\*\/           { ; } 

[ \t]*                      { ; }

[\n]                        { countn++; }

.                           { return *yytext; }

["].*["]                    { 
    printf("Token STRING detectado: %s\n", yytext);
    strcpy(yylval.nd_obj.name, yytext);
    return STR; 
}

['].[']                     { 
    printf("Token CARACTER detectado: %s\n", yytext);
    strcpy(yylval.nd_obj.name, yytext);
    return CHARACTER; 
}

%%

int yywrap() {
    return 1;
}
