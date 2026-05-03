# Fase 01 - CRUD raiz

## Objetivo da fase

Esta fase mostra o SQLite funcionando de forma direta, sem camadas de arquitetura.

O aluno deve enxergar onde o banco e aberto, onde as tabelas sao criadas e onde cada comando SQL e executado.

## O que esta sendo aprendido

- Adicionar as dependencias `sqflite` e `path`.
- Abrir um arquivo de banco SQLite com `openDatabase`.
- Criar tabelas com `CREATE TABLE`.
- Inserir dados com `INSERT`.
- Consultar dados com `SELECT`.
- Atualizar dados com `UPDATE`.
- Excluir dados com `DELETE`.
- Trabalhar com registros em `Map<String, dynamic>`.

## Limites desta abordagem

Nesta fase, o codigo fica repetitivo de proposito.

As telas conhecem diretamente:

- o nome do banco;
- os comandos SQL;
- os nomes das tabelas;
- os nomes das colunas;
- a forma como os dados sao gravados e lidos.

Isso facilita o estudo inicial, mas nao e uma boa organizacao para projetos maiores.

## Problemas que surgirao

Ao crescer, este codigo tende a apresentar:

- repeticao de abertura do banco;
- SQL espalhado em varias telas;
- maior chance de erro ao escrever nomes de colunas;
- dificuldade para testar;
- dificuldade para mudar a estrutura das tabelas.

Esses problemas serao usados como motivacao para as proximas fases.

## Referencias

- Flutter - Persist data with SQLite: https://docs.flutter.dev/cookbook/persistence/sqlite
- sqflite no pub.dev: https://pub.dev/packages/sqflite
- path no pub.dev: https://pub.dev/packages/path
- SQLite - Documentacao oficial: https://www.sqlite.org/docs.html
