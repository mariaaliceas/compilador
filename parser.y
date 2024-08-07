%{
    #include<stdio.h>
    #include<string.h>
    #include<stdlib.h>
    #include<ctype.h>
    #include"lex.yy.c"

    void yyerror(const char *s);
    int yylex();
    int yywrap();
    void add(char);
    void insert_type();
    int search(char *);
    void insert_type();
    

    struct dataType {
        char * id_name;
        char * data_type;
        char * type;
        int line_num;
    } symbol_table[40];
    
    int symbolTableIndex = 0;
    int identifierExists;
    char type[10];
    extern int countn;
%}

%union { 
	struct var_name { 
		char name[100]; 
		struct node* nd;
	} nd_obj; 
} 

%token VOID 
%token <nd_obj> CHARACTER PRINTFF SCANFF INT FLOAT CHAR FOR IF ELSE TRUE FALSE NUMBER FLOAT_NUM ID LE GE EQ NE GT LT AND OR STR ADD MULTIPLY DIVIDE SUBTRACT UNARY INCLUDE RETURN 


%%

programa: cabecalho principal '(' ')' '{' corpo retorno '}'
| cabecalho funcao { add('F'); }
| programa funcao { add('F'); }  
;

cabecalho: INCLUDE { add('H'); }
| cabecalho INCLUDE { add('H'); }
;

principal: datatype ID { add('F'); }
;

funcao: datatype ID '(' parametros ')' '{' corpo retorno '}'
;

parametros: datatype ID
| parametros ',' datatype ID
| 
;

datatype: INT { insert_type(); }
| FLOAT { insert_type(); }
| CHAR { insert_type(); }
| VOID { insert_type(); }
;

corpo: FOR { add('K'); } '(' declaracao ';' condicao ';' declaracao ')' '{' corpo '}'
| IF { add('K'); } '(' condicao ')' '{' corpo '}' entao
| declaracao ';'
| corpo corpo 
| PRINTFF { add('K'); } '(' STR ')' ';'
| SCANFF { add('K'); } '(' STR ',' '&' ID ')' ';'
;

entao: ELSE { add('K'); } '{' corpo '}'
|
;

condicao: valor relop valor 
| TRUE { add('K'); }
| FALSE { add('K'); }
|
;

declaracao: datatype ID { add('V'); } inicia
| datatype ID '[' NUMBER ']' { add('V'); } inicia
| ID '=' expressao
| ID relop expressao
| ID UNARY
| UNARY ID
| ID '[' expressao ']' '=' expressao
;

inicia: '=' valor
|
;

expressao: expressao continhas expressao
| valor
| ID '[' expressao ']'
| ID '(' argumentos ')'
;

argumentos: expressao
| argumentos ',' expressao
|
;

continhas: ADD 
| SUBTRACT 
| MULTIPLY
| DIVIDE
;

relop: LE
| GE
| EQ
| NE
| GT
| LT
;

valor: NUMBER { add('C'); }
| FLOAT_NUM { add('C'); }
| CHARACTER { add('C'); }
| ID
;

retorno: RETURN { add('K'); } valor ';'
|
;

%%

int main() {
  yyparse();
  
	printf("\n\n");
	printf("\nSIMBOLO			TIPO DO DADO			TIPO			LINHA \n");
	printf("___________________________________________________________________________________________\n\n");
	
	int i = 0;
	
	for(i = 0; i < symbolTableIndex; i++) {
		printf("%-20s\t%-20s\t%-20s\t%5d\t\n",
						symbol_table[i].id_name,
						symbol_table[i].data_type,
						symbol_table[i].type,
						symbol_table[i].line_num);
	}

	for(i = 0; i < symbolTableIndex; i++) {
		free(symbol_table[i].id_name);
		free(symbol_table[i].type);
	}

	printf("\n\n");

	printf("Número de linhas: %d\n", countn);
	return 0;
}

int search(char *type) {
	int i;
	
	for(i = symbolTableIndex-1; i >= 0; i--) {
		if(strcmp(symbol_table[i].id_name, type)==0) {
			return -1;
			break;
		}
	}
	
	return 0;
}

void add(char tokenType) {
  identifierExists = search(yytext);
  
	if(!identifierExists) {

    if(tokenType == 'H') {
			symbol_table[symbolTableIndex].id_name=strdup(yytext);
			symbol_table[symbolTableIndex].data_type=strdup(type);
			symbol_table[symbolTableIndex].line_num=countn;
			symbol_table[symbolTableIndex].type=strdup("Cabecalho");
			symbolTableIndex++;
		}
		
		else if(tokenType == 'K') {
			symbol_table[symbolTableIndex].id_name=strdup(yytext);
			symbol_table[symbolTableIndex].data_type=strdup("N/A");
			symbol_table[symbolTableIndex].line_num=countn;
			symbol_table[symbolTableIndex].type=strdup("Palavra-chave\t");
			symbolTableIndex++;
		}
		
		else if(tokenType == 'V') {
			symbol_table[symbolTableIndex].id_name=strdup(yytext);
			symbol_table[symbolTableIndex].data_type=strdup(type);
			symbol_table[symbolTableIndex].line_num=countn;
			symbol_table[symbolTableIndex].type=strdup("Variavel");
			symbolTableIndex++;
		}
		
		else if(tokenType == 'C') {
			symbol_table[symbolTableIndex].id_name=strdup(yytext);
			symbol_table[symbolTableIndex].data_type=strdup("CONST");
			symbol_table[symbolTableIndex].line_num=countn;
			symbol_table[symbolTableIndex].type=strdup("Constante");
			symbolTableIndex++;
		}
		
		else if(tokenType == 'F') {
			symbol_table[symbolTableIndex].id_name=strdup(yytext);
			symbol_table[symbolTableIndex].data_type=strdup(type);
			symbol_table[symbolTableIndex].line_num=countn;
			symbol_table[symbolTableIndex].type=strdup("Funcao");
			symbolTableIndex++;
		}
	}
}

void insert_type() {
	strcpy(type, yytext);
}

void yyerror(const char *s) {
  fprintf(stderr, "Erro na linha %d: %s\n", yylineno, s);
}