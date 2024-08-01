PARA EXECUTAR:

yacc -v -d parser3.y

lex lexer.l

gcc -ll y.tab.c

./a.out<index.c
