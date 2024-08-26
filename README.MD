## **README**

### **EXECUÇÃO**

Certifique-se que o projeto não contenha informações de execuções anteriores. Para isso, execute o seguinte comando: ./clear.sh

Na sequência, execute o comando: ./run.sh

Este executa automaticamente os seguintes arquivos e comandos: 

-flex lexer.l
-bison -d parser.y
-gcc -o notphp lex.yy.c parser.tab.c -lfl
-./notphp < teste.txt


