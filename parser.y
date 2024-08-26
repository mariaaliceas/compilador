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
	void print_tree(struct node*);
	void print_inorder(struct node *);
    void check_declaration(char *);
	void check_return_type(char *);
	int check_types(char *, char *);
	char *get_type(char *);
	struct node* mknode(struct node *left, struct node *right, char *token);

    struct dataType {
        char * id_name;
        char * data_type;
        char * type;
        int line_no;
	} symbol_table[40];

    int count=0;
    int q;
	char type[10];
	struct node *head;
	extern int countn;
	int sem_errors=0;
	int label=0;
	char buff[100];
	char errors[10][100];
	char reserved[10][10] = {"declara_inteiro", "declara_flutuante", "declara_caracter", "vazio", "se", "senao", "laco_for", "main", "return"};

	struct node { 
		struct node *left; 
		struct node *right; 
		char *token; 
	};

%}

%union { struct var_name { 
			char name[100]; 
			struct node* nd;
		} nd_obj;

		struct var_name2 { 
			char name[100]; 
			struct node* nd;
			char type[5];
		} nd_obj2; 
	} 
%token VOID 
%token <nd_obj> LBRACKET RBRACKET CHARACTER PRINTFF SCANFF INT FLOAT CHAR FOR IF ELSE TRUE FALSE NUMBER FLOAT_NUM ID LE GE EQ NE GT LT AND OR STR ADD MULTIPLY DIVIDE SUBTRACT UNARY INCLUDE RETURN 
%type <nd_obj> headers main body return datatype statement arithmetic relop program else condition
%type <nd_obj2> init value expression

%%

program: headers main '(' ')' '{' body return '}' { $2.nd = mknode($6.nd, $7.nd, "main"); $$.nd = mknode($1.nd, $2.nd, "programa"); 
	head = $$.nd;
} 
;

headers: headers headers { $$.nd = mknode($1.nd, $2.nd, "headers"); }
| INCLUDE { add('H'); } { $$.nd = mknode(NULL, NULL, $1.name); }
;

main: datatype ID { add('F');}
;

datatype: INT { insert_type(); }
| FLOAT { insert_type(); }
| CHAR { insert_type(); }
| VOID { insert_type(); }
| datatype LBRACKET RBRACKET { strcat(type, "[]"); }
;

body: FOR { add('K'); } '(' statement ';' condition ';' statement ')' '{' body '}' { 
	struct node *temp = mknode($6.nd, $8.nd, "CONDICAO"); 
	struct node *temp2 = mknode($4.nd, temp, "CONDICAO"); 
	$$.nd = mknode(temp2, $11.nd, $1.name); 
}
| IF { add('K'); } '(' condition ')' '{' body '}' else { 
	struct node *iff = mknode($4.nd, $7.nd, $1.name); 
	$$.nd = mknode(iff, $9.nd, "se_nao"); 
}
| statement ';' { $$.nd = $1.nd; }

| body body { $$.nd = mknode($1.nd, $2.nd, "statements"); }

| PRINTFF { add('K'); } '(' STR ')' ';' { $$.nd = mknode(NULL, NULL, "mostra"); }

| SCANFF { add('K'); } '(' STR ',' '&' ID ')' ';' { $$.nd = mknode(NULL, NULL, "recebe"); }
;

else: ELSE { add('K'); } '{' body '}' { $$.nd = mknode(NULL, $4.nd, $1.name); }
| { $$.nd = NULL; }
;

condition: value relop value { $$.nd = mknode($1.nd, $3.nd, $2.name); }
| TRUE { add('K'); $$.nd = NULL; }
| FALSE { add('K'); $$.nd = NULL; }
| { $$.nd = NULL; }
;

statement: datatype ID { add('V'); } init { 
	$2.nd = mknode(NULL, NULL, $2.name); 
	int t = check_types($1.name, $4.type); 
	if(t>0) { 
		
		if(t == 1) {
			struct node *temp = mknode(NULL, $4.nd, "floattoint"); 
			$$.nd = mknode($2.nd, temp, "declaration"); 
		} 
		else if(t == 2) { 
			struct node *temp = mknode(NULL, $4.nd, "inttofloat"); 
			$$.nd = mknode($2.nd, temp, "declaration"); 
		} 
		else if(t == 3) { 
			struct node *temp = mknode(NULL, $4.nd, "chartoint"); 
			$$.nd = mknode($2.nd, temp, "declaration"); 
		} 
		else if(t == 4) { 
			struct node *temp = mknode(NULL, $4.nd, "inttochar"); 
			$$.nd = mknode($2.nd, temp, "declaration"); 
		} 
		else if(t == 5) { 
			struct node *temp = mknode(NULL, $4.nd, "chartofloat"); 
			$$.nd = mknode($2.nd, temp, "declaration"); 
		} 
		else{
			struct node *temp = mknode(NULL, $4.nd, "floattochar"); 
			$$.nd = mknode($2.nd, temp, "declaration"); 
		}
	} 
	else { 
		$$.nd = mknode($2.nd, $4.nd, "declaration"); 
	} 
}
| ID { check_declaration($1.name); } '=' expression {
	$1.nd = mknode(NULL, NULL, $1.name); 
	char *id_type = get_type($1.name); 
	if(strcmp(id_type, $4.type)) {
		if(!strcmp(id_type, "int")) {
			if(!strcmp($4.type, "float")){
				struct node *temp = mknode(NULL, $4.nd, "floattoint");
				$$.nd = mknode($1.nd, temp, "="); 
			}
			else{
				struct node *temp = mknode(NULL, $4.nd, "chartoint");
				$$.nd = mknode($1.nd, temp, "="); 
			}
			
		}
		else if(!strcmp(id_type, "float")) {
			if(!strcmp($4.type, "int")){
				struct node *temp = mknode(NULL, $4.nd, "inttofloat");
				$$.nd = mknode($1.nd, temp, "="); 
			}
			else{
				struct node *temp = mknode(NULL, $4.nd, "chartofloat");
				$$.nd = mknode($1.nd, temp, "="); 
			}
			
		}
		else{
			if(!strcmp($4.type, "int")){
				struct node *temp = mknode(NULL, $4.nd, "inttochar");
				$$.nd = mknode($1.nd, temp, "="); 
			}
			else{
				struct node *temp = mknode(NULL, $4.nd, "floattochar");
				$$.nd = mknode($1.nd, temp, "="); 
			}
		}
	}
	else {
		$$.nd = mknode($1.nd, $4.nd, "="); 
	}
}
| ID { check_declaration($1.name); } relop expression { $1.nd = mknode(NULL, NULL, $1.name); $$.nd = mknode($1.nd, $4.nd, $3.name); }
| ID { check_declaration($1.name); } UNARY { 
	$1.nd = mknode(NULL, NULL, $1.name); 
	$3.nd = mknode(NULL, NULL, $3.name); 
	$$.nd = mknode($1.nd, $3.nd, "ITERATOR");  
}
| UNARY ID { 
	check_declaration($2.name); 
	$1.nd = mknode(NULL, NULL, $1.name); 
	$2.nd = mknode(NULL, NULL, $2.name); 
	$$.nd = mknode($1.nd, $2.nd, "ITERATOR"); 
}
| datatype ID LBRACKET NUMBER RBRACKET { 
                add('V'); 
                sprintf(buff, "%s[%s]", $2.name, $4.name);
                $$ = mknode(NULL, NULL, buff); 
            } init {
                $2.nd = mknode(NULL, NULL, $2.name); 
                $$.nd = mknode($2.nd, $6.nd, "declaration");
            }
        | ID LBRACKET expression RBRACKET { 
                check_declaration($1.name);
                sprintf(buff, "%s[%s]", $1.name, $3.name);
                $$ = mknode(NULL, NULL, buff); 
            }
        | ID LBRACKET expression RBRACKET '=' expression { 
                check_declaration($1.name);
                sprintf(buff, "%s[%s] = %s", $1.name, $3.name, $6.name);
                $$ = mknode(NULL, NULL, buff); 
            }
;

init: '=' value { $$.nd = $2.nd; sprintf($$.type, $2.type); strcpy($$.name, $2.name); }
| { sprintf($$.type, "null"); $$.nd = mknode(NULL, NULL, "NULL"); strcpy($$.name, "NULL"); }
;

expression: expression arithmetic expression { 
	if(!strcmp($1.type, $3.type)) {
		sprintf($$.type, $1.type);
		$$.nd = mknode($1.nd, $3.nd, $2.name); 
	}
	else {
		if(!strcmp($1.type, "int") && !strcmp($3.type, "float")) {
			struct node *temp = mknode(NULL, $1.nd, "inttofloat");
			sprintf($$.type, $3.type);
			$$.nd = mknode(temp, $3.nd, $2.name);
		}
		else if(!strcmp($1.type, "float") && !strcmp($3.type, "int")) {
			struct node *temp = mknode(NULL, $3.nd, "inttofloat");
			sprintf($$.type, $1.type);
			$$.nd = mknode($1.nd, temp, $2.name);
		}
		else if(!strcmp($1.type, "int") && !strcmp($3.type, "char")) {
			struct node *temp = mknode(NULL, $3.nd, "chartoint");
			sprintf($$.type, $1.type);
			$$.nd = mknode($1.nd, temp, $2.name);
		}
		else if(!strcmp($1.type, "char") && !strcmp($3.type, "int")) {
			struct node *temp = mknode(NULL, $1.nd, "chartoint");
			sprintf($$.type, $3.type);
			$$.nd = mknode(temp, $3.nd, $2.name);
		}
		else if(!strcmp($1.type, "float") && !strcmp($3.type, "char")) {
			struct node *temp = mknode(NULL, $3.nd, "chartofloat");
			sprintf($$.type, $1.type);
			$$.nd = mknode($1.nd, temp, $2.name);
		}
		else {
			struct node *temp = mknode(NULL, $1.nd, "chartofloat");
			sprintf($$.type, $3.type);
			$$.nd = mknode(temp, $3.nd, $2.name);
		}
	}
}
| value { strcpy($$.name, $1.name); sprintf($$.type, $1.type); $$.nd = $1.nd; }
;

arithmetic: ADD 
| SUBTRACT 
| MULTIPLY
| DIVIDE
;

relop: LT
| GT
| LE
| GE
| EQ
| NE
;

value: NUMBER { strcpy($$.name, $1.name); sprintf($$.type, "declara_inteiro"); add('C'); $$.nd = mknode(NULL, NULL, $1.name); }
| FLOAT_NUM { strcpy($$.name, $1.name); sprintf($$.type, "declara_flutuante"); add('C'); $$.nd = mknode(NULL, NULL, $1.name); }
| CHARACTER { strcpy($$.name, $1.name); sprintf($$.type, "declara_caracter"); add('C'); $$.nd = mknode(NULL, NULL, $1.name); }
| ID { strcpy($$.name, $1.name); char *id_type = get_type($1.name); sprintf($$.type, id_type); check_declaration($1.name); $$.nd = mknode(NULL, NULL, $1.name); }
;

return: RETURN { add('K'); } value ';' { check_return_type($3.name); $1.nd = mknode(NULL, NULL, "return"); $$.nd = mknode($1.nd, $3.nd, "RETORNA"); }
| { $$.nd = NULL; }
;

%%

int main() {
	printf("\n\nLISTA DE TOKENS:\n\n");
	if (yyparse() == 0) {
        printf("Análise de tokens finalizada com sucesso!\n");
    }
	printf("Tabela de Símbolos:\n");
    printf("+---------------------------+----------------+-------+\n");
    printf("| Nome                     | Tipo            | Linha |\n");
    printf("+--------------------------+-----------------+-------+\n");
	int i=0;
	for(i=0; i<count; i++) {
		printf("%s\t\t%s\t%s\t%d\t\n", symbol_table[i].id_name, symbol_table[i].data_type, symbol_table[i].type, symbol_table[i].line_no);
	}
	
	for(i=0;i<count;i++) {
		free(symbol_table[i].id_name);
		free(symbol_table[i].type);
	}
	printf("\n\n");
	print_tree(head); 
	printf("\n\n\n\n");
	if(sem_errors>0) {
		printf("Análise semantica finalizada com %d errors\n", sem_errors);
		for(int i=0; i<sem_errors; i++){
			printf("\t - %s", errors[i]);
		}
	} else {
		printf("Análise semantica finalizada sem erros");
		print_semantic_tree(head);
	}
	printf("\n\n");
}

int search(char *type) {
	int i;
	for(i=count-1; i>=0; i--) {
		if(strcmp(symbol_table[i].id_name, type)==0) {
			return -1;
			break;
		}
	}
	return 0;
}

void check_declaration(char *c) {
    q = search(c);
    if(!q) {
        sprintf(errors[sem_errors], "Linha %d: Variável \"%s\" não foi declarada antes de seu uso!\n", countn+1, c);
		sem_errors++;
    }
}

void check_return_type(char *value) {
	char *main_datatype = get_type("main");
	char *return_datatype = get_type(value);
	if((!strcmp(main_datatype, "int") && !strcmp(return_datatype, "CONST")) || !strcmp(main_datatype, return_datatype)){
		return ;
	}
	else {
		sprintf(errors[sem_errors], "Line %d: Return type mismatch\n", countn+1);
		sem_errors++;
	}
}

int check_types(char *type1, char *type2){
	if (strcmp(type1, type2) == 0) return 0;

    if (strstr(type1, "[]") && strstr(type2, "[]")) {
        char base_type1[10], base_type2[10];
        sscanf(type1, "%[^[]", base_type1);
        sscanf(type2, "%[^[]", base_type2);
        return check_types(base_type1, base_type2); 
    }
	
	if(!strcmp(type2, "null"))
		return -1;
	if(!strcmp(type1, type2))
		return 0;
	if(!strcmp(type1, "int") && !strcmp(type2, "float"))
		return 1;
	if(!strcmp(type1, "float") && !strcmp(type2, "int"))
		return 2;
	if(!strcmp(type1, "int") && !strcmp(type2, "char"))
		return 3;
	if(!strcmp(type1, "char") && !strcmp(type2, "int"))
		return 4;
	if(!strcmp(type1, "float") && !strcmp(type2, "char"))
		return 5;
	if(!strcmp(type1, "char") && !strcmp(type2, "float"))
		return 6;
}

char *get_type(char *var){
	for(int i=0; i<count; i++) {
		if(!strcmp(symbol_table[i].id_name, var)) {
			return symbol_table[i].data_type;
		}
	}
}

void add(char c) {
	if(c == 'V'){
		for(int i=0; i<10; i++){
			if(!strcmp(reserved[i], strdup(yytext))){
        		sprintf(errors[sem_errors], "LInha %d: A variável \"%s\" é uma palavra-chave!\n", countn+1, yytext);
				sem_errors++;
				return;
			}
		}
	}
    q=search(yytext);
	if(!q) {
		if(c == 'H') {
			symbol_table[count].id_name=strdup(yytext);
			symbol_table[count].data_type=strdup(type);
			symbol_table[count].line_no=countn;
			symbol_table[count].type=strdup("Cabecalho");
			count++;
		}
		else if(c == 'K') {
			symbol_table[count].id_name=strdup(yytext);
			symbol_table[count].data_type = strdup("N/A");
			symbol_table[count].line_no=countn;
			symbol_table[count].type=strdup("Palavra-Chave\t");
			count++;
		}
		else if(c == 'V') {
			symbol_table[count].id_name=strdup(yytext);
			symbol_table[count].data_type=strdup(type);
			symbol_table[count].line_no=countn;
			symbol_table[count].type=strdup("Variavel");
			count++;
		}
		else if(c == 'C') {
			symbol_table[count].id_name=strdup(yytext);
			symbol_table[count].data_type=strdup(type);
			symbol_table[count].line_no=countn;
			symbol_table[count].type=strdup("Constante");
			count++;
		}
		else if(c == 'F') {
			symbol_table[count].id_name=strdup(yytext);
			symbol_table[count].data_type=strdup(type);
			symbol_table[count].line_no=countn;
			symbol_table[count].type=strdup("Funcao");
			count++;
		}
    }
    else if(c == 'V' && q) {
        sprintf(errors[sem_errors], "Linha %d: Possui multiplas declarações \"%s\" e não é permitida!\n", countn+1, yytext);
		sem_errors++;
    }
}

struct node* mknode(struct node *left, struct node *right, char *token) {	
	struct node *newnode = (struct node *) malloc(sizeof(struct node));
	char *newstr = (char *) malloc(strlen(token)+1);
	strcpy(newstr, token);
	newnode->left = left;
	newnode->right = right;
	newnode->token = newstr;
	return(newnode);
}

void print_semantic_inorder(struct node *tree) {
    if (tree == NULL) return;

    if (tree->left) {
        print_semantic_inorder(tree->left);
    }
    printf("%s\t", tree->token);

    if (tree->right) {
        print_semantic_inorder(tree->right);
    }
}

void print_semantic_tree(struct node* tree) {
    printf("\n\nÁRVORE SEMÂNTICA: \n\n");
    print_semantic_inorder(tree);
}

void print_tree(struct node* tree) {
	printf("\n\nÁRVORE SINTÁTICA: \n\n");
	print_inorder(tree);
}

void print_inorder(struct node *tree) {
    if (tree->left) print_inorder(tree->left);
    if (tree->right) print_inorder(tree->right);
    
    if (strstr(tree->token, "[]")) {
        printf("[VETOR] %s\n", tree->token);
    } else {
        printf("%s\n", tree->token);
    }
}

void insert_type() {
	strcpy(type, yytext);
}

void yyerror(const char* msg) {
    fprintf(stderr, "%s\n", msg);
}