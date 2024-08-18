flex lexer.l
bison -d parser.y
gcc -o notphp lex.yy.c parser.tab.c -lfl
./notphp < teste.txt
