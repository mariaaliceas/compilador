%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
extern int yylex();
extern int yylineno;

void yyerror(const char *s);

typedef struct node {
    char *name;
    struct node *left;
    struct node *right;
} node;

typedef struct symbol {
    char *name;            
    char *type;
    int line;         
} symbol;

symbol *symbolTable[30];
int count = 0;
node* root;

node* create_node(struct node *left, struct node *right, char *name);
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
    struct node *node;
}

%token CHAR VOID TRUE FALSE
%token UNARY LE GE EQ NE GT LT AND OR ADD SUBTRACT DIVIDE MULTIPLY
%token LPAREN RPAREN COMMA NEWLINE ASSIGN LKEY RKEY RBRACKET LBRACKET SEMICOLON

%token <intval> INT
%token <floatval> FLOAT
%token <name> STR CHARACTER ID PRINTFF SCANFF RETURN FOR INCLUDE FUNCTION IF ELSE

%type <node> if_statement else function_definition key_word program header body function_name parameter_definition statement declaration control_flow function_call expression assignment conditional_expression logical_or_expression logical_and_expression equality_expression relational_expression additive_expression multiplicative_expression unary_expression primary_expression array_position array_list array_arguments statement_list parameter_list
%type <name> type

%left '+' '-'
%left '*' '/'
%right UNARY
%nonassoc '?' ':' 

%%
program:
    header body {
      $$ = create_node($1, $2, "PROGRAM");
      root = $$;
    }
    ;

header:
      {}
    | INCLUDE ID SEMICOLON {
            create($1, "KEYWORD", yylineno);
            $$ = create_node(NULL, NULL, "INCLUDE");
      }
    ;

body:
    {}
    | NEWLINE  { $$ = NULL; }
    | statement_list {
        $$ = create_node(NULL, $1, "STATEMENT");
    }
    ;

statement:
      NEWLINE  { $$ = NULL; }
      | expression SEMICOLON { $$ = $1; }
      | declaration  { $$ = $1; }
      | control_flow { $$ = $1; }
      | function_call { $$ = $1; }
      | key_word expression SEMICOLON { 
            $$ = create_node($1, $2, "KEYWORD EXPRESSION");
      }
      | function_definition {
            $$ = create_node($1, NULL, "FUNCTION DEFINITION");
      }
      ;


statement_list:
    statement {
        $$ = $1;
    }
    | statement_list statement {
        if ($1 == NULL) {
            $$ = $2;
        } else {
            node *temp = $1;
            while (temp->right != NULL) {
                temp = temp->right;
            }
            temp->right = $2;
            $$ = $1; 
        }
    }
    ;

expression:
    assignment {
        $$ = create_node($1, NULL, "ASSIGN"); 
    }
    | conditional_expression { $$ = $1; }
    | ID array_position {
        declared_rule($1);
        $$ = create_node($2, NULL, "ARRAY ACCESS");
        $$->left = create_node(NULL, NULL, $1);
      }
    | ID ADD expression {
        declared_rule($1);
        $$ = create_node(NULL, $3, "+");
        $$->left = create_node(NULL, NULL, $1); 
      }
    | ID SUBTRACT expression {
        declared_rule($1);
        $$ = create_node(NULL, $3, "-");
        $$->left = create_node(NULL, NULL, $1); 
      }
    | ID MULTIPLY expression {
        declared_rule($1);
        $$ = create_node(NULL, $3, "*");
        $$->left = create_node(NULL, NULL, $1);
      }
    | ID DIVIDE expression {
        declared_rule($1);
        $$ = create_node(NULL, $3, "/");
        $$->left = create_node(NULL, NULL, $1);
      }
    ;

conditional_expression:
      logical_or_expression { $$ = $1; }
      | logical_or_expression '?' expression ':' expression {
          $$ = create_node($3, $5, "CONDITIONAL");
          $$->left = create_node($1, NULL, ":");
      }
      ;

logical_or_expression:
      logical_and_expression { $$ = $1; }
      | logical_or_expression OR logical_and_expression {
          $$ = create_node($1, $3, "OR");
      }
      ;

logical_and_expression:
      equality_expression { $$ = $1; }
      | equality_expression AND logical_and_expression {
          $$ = create_node($1, $3, "AND");
      }
      ;

equality_expression:
      relational_expression { $$ = $1; }
      | relational_expression EQ relational_expression {
          $$ = create_node($1, $3, "EQ");
      }
      | relational_expression NE relational_expression {
          $$ = create_node($1, $3, "NE");
      }
      ;

relational_expression:
      additive_expression { $$ = $1; }
      | additive_expression LE additive_expression {
          $$ = create_node($1, $3, "LE");
      }
      | additive_expression GE additive_expression {
          $$ = create_node($1, $3, "GE");
      }
      | additive_expression LT additive_expression {
          $$ = create_node($1, $3, "LT");
      }
      | additive_expression GT additive_expression {
          $$ = create_node($1, $3, "GT");
      }
      ;

additive_expression:
      multiplicative_expression { $$ = $1; }
      | additive_expression ADD multiplicative_expression {
          $$ = create_node($1, $3, "+");
      }
      | additive_expression SUBTRACT multiplicative_expression {
          $$ = create_node($1, $3, "-");
      }
      ;

multiplicative_expression:
      unary_expression { $$ = $1; }
      | multiplicative_expression MULTIPLY unary_expression {
          $$ = create_node($1, $3, "*");
      }
      | multiplicative_expression DIVIDE unary_expression {
          $$ = create_node($1, $3, "/");
      }
      ;

unary_expression:
      primary_expression { $$ = $1; }
      | SUBTRACT unary_expression %prec UNARY {
          $$ = create_node(NULL, $2, "-");
      }
      ;

primary_expression:
      INT { 
          $$ = create_node(NULL, NULL, ""); 
      }
      | FLOAT { 
          $$ = create_node(NULL, NULL, "");
      }
      | STR { 
          $$ = create_node(NULL, NULL, $1);
      }
      | CHARACTER { 
          $$ = create_node(NULL, NULL, ""); 
      }
      | LPAREN expression RPAREN { $$ = $2; }
      | function_call { $$ = $1; }
      | ID { 
          declared_rule($1);
          $$ = create_node(NULL, NULL, $1); 
      }
      ;

assignment:
      ID ASSIGN expression {
            declared_rule($1);
            $$ = create_node(NULL, $3, "=");
            $$->left = create_node(NULL, NULL, $1);
      }
      | ID ASSIGN array_list {
            declared_rule($1);
            $$ = create_node($3, NULL, "="); 
            $$->left = create_node(NULL, NULL, $1);
      }
      | ID array_position ASSIGN expression {
            declared_rule($1);
            $$ = create_node($4, NULL, "=");
            $$->left = create_node($2, NULL, "ARRAY ACCESS");
            $$->left->left = create_node(NULL, NULL, $1); 
      }
      ;

function_definition:
      function_name LKEY statement_list RKEY {
            $$ = create_node($3, NULL, $1->name);
      }
      ;

function_name:
      FUNCTION ID LPAREN parameter_definition RPAREN  {
            create($2, "FUNCTION", yylineno);
            $$ = create_node($4, NULL, $2);
      }
      ;

parameter_definition:
      {}
      | type ID {
            create($2, $1, yylineno);
            $$ = create_node(NULL, NULL, $2); 
      }
      | type ID COMMA parameter_definition {
            create($2, $1, yylineno);
            $$ = create_node($4, NULL, $2);
      }
      ;

key_word:
      PRINTFF {
            $$ = create_node(NULL, NULL, $1);
      }
      | SCANFF {
            $$ = create_node(NULL, NULL, $1);
      }
      | RETURN {
            $$ = create_node(NULL, NULL, $1);
      }
      ;

array_position:
      LBRACKET expression RBRACKET {
        $$ = create_node($2, NULL, "[]"); 
      }
      ;

array_list:
      LBRACKET array_arguments RBRACKET {
        $$ = $2; 
      }
      ;

array_arguments:
      INT {
        $$ = create_node(NULL, NULL, "");
      }
      | array_arguments COMMA INT {
        node* newNode = create_node(NULL, NULL, "");
          node *temp = $1;
          while (temp->right != NULL) {
              temp = temp->right;
          }
          temp->right = newNode;
          $$ = $1; 
      }
      ;

declaration:
      type ID SEMICOLON {
          create($2, $1, yylineno);
          $$ = create_node(NULL, NULL, $2); 
      }
    | type ID ASSIGN expression SEMICOLON {
          create($2, $1, yylineno);
          $$ = create_node($4, NULL, "="); 
          $$->left = create_node(NULL, NULL, $2); 
      }
    | type ID array_position SEMICOLON {
          create($2, $1, yylineno);
          $$ = create_node($3, NULL, "ARRAY DECLARATION");
          $$->left = create_node(NULL, NULL, $2);
      }
    ;

type:
      INT     { $$ = strdup("INT"); }
    | FLOAT   { $$ = strdup("FLOAT"); }
    | CHAR    { $$ = strdup("CHAR"); }
    | STR     { $$ = strdup("STR"); }
    | VOID    { $$ = strdup("VOID"); }
    ;

if_statement:
    IF LPAREN expression RPAREN {
        create($1, "KEYWORD", yylineno);
        $$ = create_node($3, NULL, "IF");
    }

control_flow:
      if_statement LKEY statement_list RKEY{
            $$ = create_node($1, $3, "IF"); 
      }
      | if_statement LKEY statement_list RKEY else {
            $$ = create_node($1, $3, "IF"); 
            $$->right = $5; 
      }
      | FOR LPAREN expression SEMICOLON expression RPAREN LKEY statement_list RKEY {
            create($1, "KEYWORD", yylineno);
            create($1, "KEYWORD", yylineno);
            $$ = create_node($3, $8, "FOR");
            $$->left = create_node($5, NULL, ";");
      }
      ;

else_word:
    ELSE {
      create($1, "KEYWORD", yylineno);
    }
    | NEWLINE ELSE {
      create($2, "KEYWORD", yylineno);
    }
    ;

else:
    else_word LKEY statement_list RKEY {
      $$ = create_node($3, NULL, "ELSE"); 
    }
    | NEWLINE else_word LKEY statement_list RKEY {
      $$ = create_node($4, NULL, "ELSE"); 
    }
    ;

function_call:
      ID LPAREN parameter_list RPAREN SEMICOLON {
            $$ = create_node($3, NULL, $1);
      }
      ;


parameter_list:
      {
            $$ = NULL;
      }
      | ID {
            declared_rule($1);
            $$ = create_node(NULL, NULL, $1); 
      }
      | ID COMMA parameter_list{
            declared_rule($1);
            $$ = create_node($3, NULL, $1);
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
        print_tree(root, 0);
    }
    return 0;
}

struct node* create_node(struct node *left, struct node *right, char *name) {
    struct node *new_node = (node *)malloc(sizeof(node));

    if (!new_node) {
        perror("Erro ao alocar memória para o nó");
        return NULL;
    }

    new_node->name = strdup(name);
    new_node->left = left;
    new_node->right = right;

    return new_node;
}

symbol *create(char *name, char *type, int line) {
    if (count >= 30) {
        fprintf(stderr, "Erro: Tabela de símbolos cheia\n");
        return NULL;
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

void print_tree(node *root, int level) {
    if (root == NULL) {
        return;
    }

    printf("%*s%s (%s)\n", level * 2, "", root->name, 
           root->left ? "left" : (root->right ? "right" : "leaf")); 

    if (root->left) {
        print_tree(root->left, level + 1);
    }

    if (root->right) {
        print_tree(root->right, level + 1);
    }
}