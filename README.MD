# **Projeto de Compilador - NotPHP**

Este projeto implementa um compilador simples para uma linguagem fictícia chamada NotPHP, utilizando Flex para a construção do lexer e Bison para a construção do parser. A seguir, estão as instruções para execução do projeto.

## **Execução**

### Passo 1: Limpeza de Execuções Anteriores

Antes de rodar o compilador, certifique-se de que o projeto não contenha informações de execuções anteriores. Para isso, execute o seguinte comando:

```bash
./clear.sh

### Passo 2: Compilação e Execução

```bash
./run.sh

### **Notas**

- **lexer.l:** Contém as regras de análise lexical.
- **parser.y:** Contém as regras de análise sintática e semântica.
- **teste.txt:** Arquivo de teste que contém o código a ser analisado.
