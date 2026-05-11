# Projeto

## Objetivo geral

Estudar persistencia local com Flutter, Dart, SQLite e `sqflite`.

O projeto usa um CRUD de `Estado` e `Cidade` e evolui em quatro fases simples.

## Fases

### Fase 01 - CRUD direto

- SQL direto nas telas.
- Uso de `Map<String, dynamic>`.
- Codigo propositalmente simples e repetitivo.

### Fase 02 - Conexao e Model

- Classe `Conexao`.
- Models `Estado` e `Cidade`.
- Uso de `fromMap` e `toMap`.

### Fase 03 - DAO de Estado

- `EstadoDao`.
- SQL de estado sai da tela.

### Fase 04 - DAO de Cidade

- `CidadeDao`.
- Formulario de cidade usando objeto `Estado`.
- Filtro de cidades por estado.

## Ideia central

```text
Conexao -> abre o banco
Model   -> representa dados
DAO     -> executa SQL
Tela    -> mostra dados e recebe acoes
```
