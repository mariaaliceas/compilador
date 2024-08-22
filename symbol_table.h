#ifndef SYMBOL_TABLE_H
#define SYMBOL_TABLE_H

typedef struct
{
    char name[500];
    char type[200];
    int scope;
} Symbol;

typedef struct
{
    Symbol symbols[1000000];
    int size;
} SymbolTable;

extern SymbolTable symbol_table;

void insert_symbol(const char *name, const char *type, int scope);
Symbol *lookup_symbol(const char *name);
void print_symbol_table();

#endif
