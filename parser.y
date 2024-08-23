%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
extern int yylex();
extern int yylineno;

void yyerror(const char *s);

typedef struct symbol {
    char *name;            
    char *type;
    char *scope;
    int line;         
} symbol;

symbol *symbolTable[30];
int count = 0;

symbol *create(char *name, char *type, int line);
void printTable();

%}

%union {
    int intval;
    float floatval;
    char *name;
}

%left IF 
%nonassoc ELSE

%token PRINTFF SCANFF CHAR VOID RETURN FOR INCLUDE TRUE FALSE FUNCTION
%token UNARY LE GE EQ NE GT LT AND OR ADD SUBTRACT DIVIDE MULTIPLY
%token LPAREN RPAREN COMMA NEWLINE ASSIGN LKEY RKEY RBRACKET LBRACKET SEMICOLON

%token <intval> INT
%token <floatval> FLOAT
%token <name> STR CHARACTER ID

%type program statement declaration control_flow function_call expression conditional_expression logical_or_expression logical_and_expression equality_expression relational_expression additive_expression multiplicative_expression unary_expression primary_expression assignment
%type <name> type

%left '+' '-'
%left '*' '/'
%right UNARY
%nonassoc '?' ':' 

%%
program:
      | program NEWLINE
      | program statement
      | program function_definition
      | program function_call
      ;

statement:
      NEWLINE
      | expression SEMICOLON
      | declaration
      | control_flow
      | function_call
      | INCLUDE ID SEMICOLON
      | RETURN expression SEMICOLON
      | PRINTFF expression SEMICOLON
      | PRINTFF type SEMICOLON
      ;

expression:
      assignment
      | conditional_expression
      | array_position
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

function_definition:
      FUNCTION ID LPAREN parameter_list RPAREN LKEY statement_list RKEY
      ;

statement_list:
      statement
      | statement_list statement
      ;

assignment: 
      ID ASSIGN expression 
      | ID ASSIGN array_list
      | array_position ASSIGN expression
      ;

array_position:
      ID LBRACKET INT RBRACKET
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
    | type ID LBRACKET INT RBRACKET SEMICOLON {
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
      IF LPAREN expression RPAREN LKEY statement_list RKEY
      | IF LPAREN expression RPAREN LKEY statement_list RKEY else
      | FOR LPAREN expression SEMICOLON expression RPAREN LKEY statement_list RKEY
      ;

else:
      ELSE LKEY statement_list RKEY
      | NEWLINE ELSE LKEY statement_list RKEY
      ;

function_call:
      ID LPAREN parameter_list RPAREN SEMICOLON
      ;

parameter:
      ID
      | type
      ;

parameter_list:
      | parameter
      | parameter COMMA parameter_list
      ;

%%
void yyerror(const char *s) {
    extern int yylineno;
    extern char *yytext;

    fprintf(stderr, "Erro: %s na linha %d\n", s, yylineno);
    fprintf(stderr, "Ultimo token encontrado: %s\n", yytext);
}

int main(int argc, char **argv) { 
    if (yyparse() == 0) {
        printf("Parsing completed successfully!\n");
        printTable();
    }
    return 0;
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
            fprintf(stderr, "Erro: Símbolo já existe\n");
            return NULL;
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

void printTable() {
    printf("Tabela de Símbolos:\n");
    printf("+-----------------+-----------------+-------+\n");
    printf("| Nome            | Tipo            | Linha |\n");
    printf("+-----------------+-----------------+-------+\n");

    for (int i = 0; i < count; i++) {
        printf("| %-15s | %-15s | %-5d |\n", symbolTable[i]->name, symbolTable[i]->type, symbolTable[i]->line);
    }

    printf("+-----------------+-----------------+-------+\n");
}
