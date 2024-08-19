flex lexer.l
yacc -d parser.y
gcc lex.yy.c parser.tab.c -o analisador
./analisador < teste.txt

    
