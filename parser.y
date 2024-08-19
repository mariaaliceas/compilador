%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <ctype.h>

// Estrutura do nó da árvore sintática
struct node { 
    struct node *left; 
    struct node *right; 
    char *token; 
};

// Estrutura da tabela de símbolos
struct dataType {
    char *id_name;
    char *data_type;
    char *type;  // Tipo do símbolo (variável, função, etc.)
    int line_no;
} symbolTable[40];

int count = 0;
char currentType[10]; // Corrigido: usando currentType em vez de type
extern int countn;
extern char *yytext;
struct node *head;

void yyerror(const char *s);
int yylex();
struct node* mknode(struct node *left, struct node *right, char *token);
void printtree(struct node *tree);
void printInorder(struct node *tree);
void insertSymbol(char *id, char *type, char *symbolType); // Função para inserir na tabela de símbolos

%}

%union { 
	struct var_name { 
		char name[100]; 
		struct node* nd;
	} nd_obj; 
}

// Tokens
%token <nd_obj> CHARACTER PRINTF SCANF INT FLOAT CHAR FOR IF ELSE TRUE FALSE NUMBER FLOAT_NUM ID LE GE EQ NE GT LT AND OR STR ADD MULTIPLY DIVIDE SUBTRACT UNARY INCLUDE RETURN
%token VOID

// Tipos de dados para a análise sintática
%type <nd_obj> headers main body return_stmt datatype expression statement init value arithmetic relop program condition else_stmt // Corrigido: nomes mais descritivos

%%

program: 
	headers main '(' ')' '{' body return_stmt '}' 
	{ 
		$2.nd = mknode($6.nd, $7.nd, "main"); 
		$$.nd = mknode($1.nd, $2.nd, "program"); 
		head = $$.nd; 
	} 
;

headers: 
	headers headers { $$.nd = mknode($1.nd, $2.nd, "headers"); }
	| INCLUDE { $$.nd = mknode(NULL, NULL, $1.name); insertSymbol($1.name, "N/A", "Header"); } // Inserindo header na tabela
;

main: 
	datatype ID { $$.nd = mknode(NULL, NULL, "main"); insertSymbol($2.name, $1.name, "Function"); } // Inserindo função main
;

datatype: 
	INT { strcpy(currentType, "int"); }
	| FLOAT { strcpy(currentType, "float"); }
	| CHAR { strcpy(currentType, "char"); }
	| VOID { strcpy(currentType, "void"); }
;

body: 
	FOR '(' statement ';' condition ';' statement ')' '{' body '}' 
	{ 
		struct node *temp = mknode($4.nd, $6.nd, "CONDITION"); 
		struct node *temp2 = mknode($2.nd, temp, "CONDITION"); 
		$$.nd = mknode(temp2, $9.nd, "FOR"); 
	}
	| IF '(' condition ')' '{' body '}' else_stmt  // Corrigido: else_stmt
	{ 
		struct node *iff = mknode($4.nd, $7.nd, "IF"); 	
		$$.nd = mknode(iff, $9.nd, "if-else"); 
	}
	| statement ';' 
	{ 
		$$.nd = $1.nd; 
	}
	| body body 
	{ 
		$$.nd = mknode($1.nd, $2.nd, "statements"); 
	}
	| PRINTF '(' STR ')' ';' 
	{ 
		$$.nd = mknode(NULL, NULL, "printf"); 
	}
	| SCANF '(' STR ',' '&' ID ')' ';' 
	{ 
		$$.nd = mknode(NULL, NULL, "scanf"); 
	}
;

else_stmt:  // Corrigido: else_stmt
	ELSE '{' body '}' 
	{ 
		$$.nd = mknode(NULL, $3.nd, "ELSE"); 
	}
	| 
	{ 
		$$.nd = NULL; 
	}
;

condition: 
	value relop value 
	{ 
		$$.nd = mknode($1.nd, $3.nd, $2.name); 
	}
	| TRUE  
	{ 
		$$.nd = NULL; 
	}
	| FALSE 
	{ 
		$$.nd = NULL; 
	}
	| 
	{ 
		$$.nd = NULL; 
	}
;

statement: 
	datatype ID init 
	{ 
		$2.nd = mknode(NULL, NULL, $2.name); 
		$$.nd = mknode($2.nd, $3.nd, "declaration"); 
        insertSymbol($2.name, currentType, "Variable"); // Inserindo variável
	}
	| ID '=' expression 
	{ 
		$1.nd = mknode(NULL, NULL, $1.name); 
		$$.nd = mknode($1.nd, $3.nd, "="); 
	}
	| ID relop expression 
	{ 
		$1.nd = mknode(NULL, NULL, $1.name); 
		$$.nd = mknode($1.nd, $3.nd, $2.name); 
	}
	| ID UNARY 
	{ 
		$1.nd = mknode(NULL, NULL, $1.name); 
		$2.nd = mknode(NULL, NULL, $2.name); 
		$$.nd = mknode($1.nd, $2.nd, "ITERATOR"); 
	}
	| UNARY ID 
	{ 
		$1.nd = mknode(NULL, NULL, $1.name); 
		$2.nd = mknode(NULL, NULL, $2.name); 
		$$.nd = mknode($1.nd, $2.nd, "ITERATOR"); 
	}
;

init: 
	'=' value 
	{ 
		$$.nd = $2.nd; 
	}
	| 
	{ 
		$$.nd = mknode(NULL, NULL, "NULL"); 
	}
;

expression: 
	expression arithmetic expression 
	{ 
		$$.nd = mknode($1.nd, $3.nd, $2.name); 
	}
	| value 
	{ 
		$$.nd = $1.nd; 
	}
;

arithmetic: 
	ADD 
	| SUBTRACT 
	| MULTIPLY
	| DIVIDE
;

relop: 
	LT
	| GT
	| LE
	| GE
	| EQ
	| NE
;

value: 
	NUMBER 
	{ 
		$$.nd = mknode(NULL, NULL, $1.name); 
	}
	| FLOAT_NUM 
	{ 
		$$.nd = mknode(NULL, NULL, $1.name); 
	}
	| CHARACTER 
	{ 
		$$.nd = mknode(NULL, NULL, $1.name); 
	}
	| ID 
	{ 
		$$.nd = mknode(NULL, NULL, $1.name); 
	}
;

return_stmt: // Corrigido: return_stmt
	RETURN value ';' 
	{ 
		$1.nd = mknode(NULL, NULL, "return"); 
		$$.nd = mknode($1.nd, $3.nd, "RETURN"); 
	}
	| 
	{ 
		$$.nd = NULL; 
	}
;

%%

// Função para criar um novo nó na árvore sintática
struct node* mknode(struct node *left, struct node *right, char *token) {
	struct node *newnode = (struct node *)malloc(sizeof(struct node));
	newnode->token = strdup(token); 
	newnode->left = left;
	newnode->right = right;
	return newnode;
}

// Função para imprimir a árvore sintática (em ordem)
void printtree(struct node* tree) {
	printf("\n\n Inorder traversal of the Parse Tree: \n\n");
	printInorder(tree);
	printf("\n\n");
}

void printInorder(struct node *tree) {
	if (tree == NULL) {
		return; 
	}

	printInorder(tree->left);
	printf("%s, ", tree->token);
	printInorder(tree->right);
}

// Função para lidar com erros sintáticos
void yyerror(const char* msg) {
	fprintf(stderr, "Erro Sintático: %s\n", msg);
	exit(1);
} 

// Função principal
int main() {
	yyparse();

	printf("\n\n\t\t\t\t\t\t PHASE 1: LEXICAL ANALYSIS \n\n");
	printf("\nSYMBOL   DATATYPE   TYPE   LINE NUMBER \n");
	printf("_______________________________________\n\n");

	for (int i = 0; i < count; i++) {
		printf("%s\t%s\t%s\t%d\t\n", symbolTable[i].id_name, symbolTable[i].data_type, symbolTable[i].type, symbolTable[i].line_no);
	}

    for (int i = 0; i < count; i++) {
        free(symbolTable[i].id_name);
        free(symbolTable[i].data_type);
        free(symbolTable[i].type);
    }

	printf("\n\n");
	printf("\t\t\t\t\t\t PHASE 2: SYNTAX ANALYSIS \n\n");
	printtree(head); 
	printf("\n\n");

	return 0;
}

void insertSymbol(char *id, char *dataType, char *symbolType) {
    for (int i = 0; i < count; i++) {
        if (strcmp(symbolTable[i].id_name, id) == 0) {
            return;
        }
    }
    symbolTable[count].id_name = strdup(id);
    symbolTable[count].data_type = strdup(dataType);
    symbolTable[count].line_no = countn;
    symbolTable[count].type = strdup(symbolType);

    count++;
}