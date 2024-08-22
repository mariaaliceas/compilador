#include "symbol_table.h"
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#define MAX_SYMBOLS 10000

SymbolTable symbol_table = {.size = 0};

void insert_symbol(const char *name, const char *type, int scope)
{
    if (name == NULL || type == NULL)
    {
        printf("Erro: ponteiro NULL passado para insert_symbol.\n");
        return;
    }

    // Verifica se o símbolo já existe no mesmo escopo
    for (int i = 0; i < symbol_table.size; i++)
    {
        if (strcmp(symbol_table.symbols[i].name, name) == 0 && symbol_table.symbols[i].scope == scope)
        {
            // Atualiza o tipo do símbolo existente
            strncpy(symbol_table.symbols[i].type, type, sizeof(symbol_table.symbols[i].type) - 1);
            symbol_table.symbols[i].type[sizeof(symbol_table.symbols[i].type) - 1] = '\0';
            printf("Aviso: símbolo '%s' já existe no escopo %d. Tipo atualizado.\n", name, scope);
            return;
        }
    }

    if (symbol_table.size >= MAX_SYMBOLS)
    {
        printf("Erro: a tabela de símbolos está cheia.\n");
        return;
    }

    // Insere o novo símbolo na tabela
    strncpy(symbol_table.symbols[symbol_table.size].name, name, sizeof(symbol_table.symbols[symbol_table.size].name) - 1);
    symbol_table.symbols[symbol_table.size].name[sizeof(symbol_table.symbols[symbol_table.size].name) - 1] = '\0';

    strncpy(symbol_table.symbols[symbol_table.size].type, type, sizeof(symbol_table.symbols[symbol_table.size].type) - 1);
    symbol_table.symbols[symbol_table.size].type[sizeof(symbol_table.symbols[symbol_table.size].type) - 1] = '\0';

    symbol_table.symbols[symbol_table.size].scope = scope;
    symbol_table.size++;
}

Symbol *lookup_symbol(const char *name)
{
    if (name == NULL)
    {
        printf("Erro: ponteiro NULL passado para lookup_symbol.\n");
        return NULL;
    }

    for (int i = symbol_table.size - 1; i >= 0; i--)
    {
        if (strcmp(symbol_table.symbols[i].name, name) == 0)
        {
            return &symbol_table.symbols[i];
        }
    }
    return NULL; // Retorna NULL se não encontrado
}

void print_symbol_table()
{
    printf("Tabela de Símbolos:\n");
    printf("-------------------------------------------------\n");
    printf("| %-20s | %-10s | %-5s |\n", "Nome", "Tipo", "Escopo");
    printf("-------------------------------------------------\n");
    for (int i = 0; i < symbol_table.size; i++)
    {
        printf("| %-20s | %-10s | %-5d |\n", symbol_table.symbols[i].name, symbol_table.symbols[i].type, symbol_table.symbols[i].scope);
    }
    printf("-------------------------------------------------\n");
}
