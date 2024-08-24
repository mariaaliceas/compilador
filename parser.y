%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
extern int yylex();
extern int yylineno;

void yyerror(const char *s);

typedef enum {
    PROGRAM,
    DECLARATION,
    ASSIGNMENT,
    EXPRESSION,
    FUNCTION_CALL,
    CONDITIONAL,
    LOOP,
} node_type;

typedef struct node {
    char *name;
    node_type type;
    struct node *next;
    struct node *children;
} node;

typedef struct symbol {
    char *name;            
    char *type;
    char *scope;
    int line;         
} symbol;

symbol *symbolTable[30];
int count = 0;

node* create_node(const char *name, node_type type);
symbol *create(char *name, char *type, int line);

int declared_rule(char *name);
void add_child(node *parent, node *child);
void print_table();
void print_tree(node *root, int level);

%}

%union {
    int intval;
    float floatval;
    char *name;
}

%token CHAR VOID TRUE FALSE END
%token UNARY LE GE EQ NE GT LT AND OR ADD SUBTRACT DIVIDE MULTIPLY
%token LPAREN RPAREN COMMA NEWLINE ASSIGN LKEY RKEY RBRACKET LBRACKET SEMICOLON

%token <intval> INT
%token <floatval> FLOAT
%token <name> STR CHARACTER ID PRINTFF SCANFF RETURN FOR INCLUDE FUNCTION IF ELSE

%type function_name parameter_definition header lib_include body program statement declaration control_flow function_call expression assignment conditional_expression logical_or_expression logical_and_expression equality_expression relational_expression additive_expression multiplicative_expression unary_expression primary_expression
%type <name> type

%left '+' '-'
%left '*' '/'
%right UNARY
%nonassoc '?' ':' 

%%
program:
    header body
    ;

header:
    | lib_include
    ;

body:
      end_program
    | statement
    | function_definition body
    | statement body
    ;

end_program:
      END;

lib_include:
      INCLUDE ID SEMICOLON {
            create($1, "KEYWORD", yylineno);
      }
      ;

statement:
      NEWLINE
      | expression SEMICOLON
      | declaration
      | control_flow
      | function_call
      | key_word expression SEMICOLON
      ;

expression:
      assignment
    | ID {
        declared_rule($1);
      }
    | conditional_expression
    | ID array_position {
        declared_rule($1);
      }
    | ID ADD expression {
        declared_rule($1);
      }
    | ID SUBTRACT expression {
        declared_rule($1);
      }
    | ID MULTIPLY expression {
        declared_rule($1);
      }
    | ID DIVIDE expression {
        declared_rule($1);
      }
    ;

conditional_expression:
      logical_or_expression
      | logical_or_expression '?' expression ':' expression
      ;

logical_or_expression:
      logical_and_expression
      | logical_or_expression OR logical_and_expression
      ;

logical_and_expression:
      equality_expression
      | equality_expression AND logical_and_expression
      ;

equality_expression:
      relational_expression
      | relational_expression EQ relational_expression
      | relational_expression NE relational_expression
      ;

relational_expression:
      additive_expression
      | additive_expression LE additive_expression
      | additive_expression GE additive_expression
      | additive_expression LT additive_expression
      | additive_expression GT additive_expression
      ;

additive_expression:
      multiplicative_expression
      | additive_expression ADD multiplicative_expression
      | additive_expression SUBTRACT multiplicative_expression
      ;

multiplicative_expression:
      unary_expression
      | multiplicative_expression MULTIPLY unary_expression
      | multiplicative_expression DIVIDE unary_expression
      ;

unary_expression:
      primary_expression
      | SUBTRACT unary_expression %prec UNARY
      ;

primary_expression:
      INT
      | FLOAT
      | STR
      | CHARACTER
      | LPAREN expression RPAREN
      | function_call
      | ID
      ;



statement_list:
      statement
      | statement_list statement
      ;

assignment:
      ID ASSIGN expression {
            
      }
      | ID ASSIGN array_list {
            
      }
      | ID array_position ASSIGN expression {
            
      }
      ;

function_definition:
      function_name LKEY statement_list RKEY
      ;

function_name:
      FUNCTION ID LPAREN parameter_definition RPAREN  {
            create($2, "FUNCTION", yylineno);
      }
      ;

parameter_definition:
      | type ID {
            create($2, $1, yylineno);
      }
      | type ID COMMA parameter_definition {
            create($2, $1, yylineno);
      }
      ;

key_word:
      PRINTFF {
            create($1, "KEYWORD", yylineno);
      }
      | SCANFF {
            create($1, "KEYWORD", yylineno);
      }
      | RETURN {
            create($1, "KEYWORD", yylineno);
      }
      ;

array_position:
      LBRACKET INT RBRACKET
      ;

array_list:
      LBRACKET array_arguments RBRACKET
      ;

array_arguments:
      INT
      | array_arguments COMMA INT
      ;

declaration:
      type ID SEMICOLON {
          create($2, $1, yylineno);
      }
    | type ID ASSIGN expression SEMICOLON {
          create($2, $1, yylineno);
      }
    | type ID array_position SEMICOLON {
          create($2, $1, yylineno);
      }
    ;

type:
      INT     { $$ = strdup("INT"); }
    | FLOAT   { $$ = strdup("FLOAT"); }
    | CHAR    { $$ = strdup("CHAR"); }
    | STR     { $$ = strdup("STR"); }
    | VOID    { $$ = strdup("VOID"); }
    ;

control_flow:
      IF LPAREN expression RPAREN LKEY statement_list RKEY{
            create($1, "KEYWORD", yylineno);
      }
      | IF LPAREN expression RPAREN LKEY statement_list RKEY else {
            create($1, "KEYWORD", yylineno);
      }
      | FOR LPAREN expression SEMICOLON expression RPAREN LKEY statement_list RKEY {
            create($1, "KEYWORD", yylineno);
      }
      ;

else:
      ELSE LKEY statement_list RKEY
      | NEWLINE ELSE LKEY statement_list RKEY
      ;

function_call:
      ID LPAREN parameter_list RPAREN SEMICOLON {
            create($1, "FUNCTION_CALL", yylineno);
      }
      ;


parameter_list:
      | ID {
            create($1, "PARAM", yylineno);
      }
      | ID COMMA parameter_list{
            create($1, "PARAM", yylineno);
      }
      ;

%%
void yyerror(const char *s) {
    extern int yylineno;
    extern char *yytext;

    fprintf(stderr, "Erro: na linha %d\n", yylineno);
    fprintf(stderr, "Ultimo token encontrado: %s\n", yytext);
}

int main(int argc, char **argv) { 
    if (yyparse() == 0) {
        printf("Parsing completed successfully!\n");
        print_table();
    }
    return 0;
}

node* create_node(const char *name, node_type type) {
    node *new_node = (node *)malloc(sizeof(node));
    if (!new_node) {
        perror("Erro ao alocar memória para o nó");
        return NULL;
    }
    new_node->name = strdup(name);
    new_node->type = type;
    new_node->next = NULL;
    new_node->children = NULL;
    return new_node;

}

symbol *create(char *name, char *type, int line) {
    if (count >= 30) {
        fprintf(stderr, "Erro: Tabela de símbolos cheia\n");
         NULL;
    }

    if (name == NULL || type == NULL) {
        fprintf(stderr, "Erro: Argumento nulo passado para criar símbolo\n");
        return NULL;
    }

    for (int i = 0; i < count; i++) {
        if (strcmp(symbolTable[i]->name, name) == 0) {
            if (strcmp(symbolTable[i]->type, type) == 0) {
                  return NULL;
            }
        }
    }

    symbol *newSymbol = (symbol *)malloc(sizeof(symbol));
    if (newSymbol == NULL) {
        perror("Erro ao alocar memória para símbolo");
        return NULL;
    }

    newSymbol->name = strdup(name);
    newSymbol->type = strdup(type);
    newSymbol->scope = strdup("global");
    newSymbol->line = line;
    
    if (newSymbol->name == NULL || newSymbol->type == NULL) {
        perror("Erro ao alocar memória para campos do símbolo");
        free(newSymbol->name);
        free(newSymbol->type);
        free(newSymbol);
        return NULL;
    }

    symbolTable[count++] = newSymbol;

    return newSymbol;
}

int declared_rule(char *name) {
    for (int i = 0; i < count; i++) {
        if (strcmp(symbolTable[i]->name, name) == 0) {
            return 1;
        }
    }
    printf("Erro: Variável %s não declarada na linha %d\n", name, yylineno);
    exit(1);
}

void print_table() {
    printf("Tabela de Símbolos:\n");
    printf("+---------------------------+----------------+-------+\n");
    printf("| Nome                     | Tipo            | Linha |\n");
    printf("+--------------------------+-----------------+-------+\n");

    for (int i = 0; i < count; i++) {
        printf("| %-24s | %-15s | %-5d |\n", symbolTable[i]->name, symbolTable[i]->type, symbolTable[i]->line);
    }

       printf("+--------------------------+-----------------+-------+\n");
}

void add_child(node *parent, node *child) {
    if (!parent || !child) return;
    child->next = parent->children;
    parent->children = child;
}

void print_tree(node *root, int level) {
    if (root == NULL) return;

    for (int i = 0; i < level; i++) {
        printf("  ");
    }
    printf("Node: %s, Type: %d\n", root->name, root->type);

    node *child = root->children;
    while (child != NULL) {
        print_tree(child, level + 1);
        child = child->next;
    }
    print_tree(root->next, level); 
}