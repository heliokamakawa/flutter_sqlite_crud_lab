# Fase 02 - Conexao singleton e Model

## Objetivo da fase

Esta fase evolui o CRUD raiz da Fase 01 sem introduzir DAO.

O foco e separar os primeiros pontos que ficaram repetidos:

- conexao com banco;
- representacao dos dados das tabelas;

## O que muda em relacao a Fase 01

Na Fase 01, a conexao ja fica centralizada em `Conexao`, mas as telas ainda trabalham com `Map` e SQL direto.

Na Fase 02, a conexao continua centralizada em:

```text
database/database.dart
```

Na Fase 01, as telas manipulavam diretamente `Map<String, dynamic>`.

Na Fase 02, as entidades principais usam Models:

```text
models/estado.dart
models/cidade.dart
```

## Model nesta fase

Model representa um dado principal do sistema.

Nesta fase:

- `Estado` representa uma linha da tabela `estado`;
- `Cidade` representa uma linha da tabela `cidade`.

Os models representam entidades e validam dados principais.

Nesta fase, `Cidade` representa somente a tabela `cidade`: `id`, `nome` e `estadoId`.
Dados de estado continuam no Model `Estado`. A cidade guarda apenas o `estadoId`.

## Singleton nesta fase

A classe `Conexao` adota Singleton para existir como ponto unico de acesso a conexao.

Isso evita repetir a abertura do banco em cada tela.

## Limite proposital

Esta fase ainda nao cria DAO.

As telas ainda executam SQL diretamente para manter visivel a transicao entre:

```text
CRUD raiz -> conexao centralizada + dados tipados
```

O DAO fica como proxima evolucao natural.

## Referencias

- Flutter - Persist data with SQLite: https://docs.flutter.dev/cookbook/persistence/sqlite
- Dart - Classes: https://dart.dev/language/classes
- Dart - Constructors: https://dart.dev/language/constructors
- Refactoring Guru - Singleton: https://refactoring.guru/pt-br/design-patterns/singleton
