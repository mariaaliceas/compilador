flex lexer.l
bison -d parser.y
gcc -o notphp parser.tab.c lex.yy.c symbol_table.c -lfl
./notphp < teste.txt
