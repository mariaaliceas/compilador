to compile flex -> flex lexer.l <br>
to compile parser -> yacc -d parser.y <br>
to compile -> gcc -o lexer lex.yy.c main.c -lfl <br>
to compile 2 -> gcc -o parser y.tab.c lex.yy.c -ll <br>
to test -> ./lexer <<< "código aqui"
