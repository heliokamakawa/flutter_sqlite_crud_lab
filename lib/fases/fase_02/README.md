# Fase 02 - Conexao singleton, Model e DTO

## Objetivo da fase

Esta fase evolui o CRUD raiz da Fase 01 sem introduzir DAO.

O foco e separar os primeiros pontos que ficaram repetidos:

- conexao com banco;
- representacao dos dados das tabelas;
- objetos usados para transporte/exibicao de dados.

## O que muda em relacao a Fase 01

Na Fase 01, cada tela possuia sua propria funcao `abrirConexaoBanco`.

Na Fase 02, a conexao fica centralizada em:

```text
database/database.dart
```

Na Fase 01, as telas manipulavam diretamente `Map<String, dynamic>`.

Na Fase 02, as entidades principais usam Models:

```text
models/estado.dart
models/cidade.dart
```

E as telas que precisam de dados combinados ou simplificados usam DTOs:

```text
dtos/estado_dto.dart
dtos/cidade_dto.dart
```

## Model nesta fase

Model representa um dado principal do sistema.

Nesta fase:

- `Estado` representa uma linha da tabela `estado`;
- `Cidade` representa uma linha da tabela `cidade`.

Os models representam entidades e validam dados principais.

Os DTOs concentram a conversao entre `Map` e objetos Dart para conversar com o SQLite.

## DTO nesta fase

DTO representa um formato de transporte de dados.

Nesta fase:

- `EstadoDto` e usado para opcoes de selecao;
- `CidadeDto` e usado para a listagem com dados da cidade e do estado.

O DTO nao precisa representar exatamente uma tabela.

## Singleton nesta fase

A classe `Fase02Database` adota Singleton para existir como ponto unico de acesso a conexao.

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
- Martin Fowler - Data Transfer Object: https://martinfowler.com/eaaCatalog/dataTransferObject.html
- Refactoring Guru - Singleton: https://refactoring.guru/pt-br/design-patterns/singleton
