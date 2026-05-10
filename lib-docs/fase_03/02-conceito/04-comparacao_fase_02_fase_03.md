# Fase 03 - Comparacao com a Fase 02

## SQL na tela vs SQL no DAO

Fase 02 — a tela escreve o SQL:

```dart
final List<Map<String, dynamic>> resultado = await banco.rawQuery(
  'SELECT id, nome, sigla FROM estado ORDER BY nome',
);
final List<Estado> estados = resultado.map(Estado.fromMap).toList();
```

Fase 03 — a tela chama um metodo:

```dart
final List<Estado> estados = await dao.buscarTodos();
```

Resultado:

- a tela nao sabe mais qual tabela existe;
- a tela nao sabe mais como o SELECT e montado;
- se o SQL mudar, a mudanca fica no DAO.

## Insert

Fase 02:

```dart
await banco.insert('estado', estado.toMap());
```

Fase 03:

```dart
await dao.inserir(estado);
```

Resultado:

- a tela nao sabe o nome da tabela;
- a tela nao sabe que `toMap` existe.

## Update

Fase 02:

```dart
await banco.update(
  'estado',
  estado.toMap(),
  where: 'id = ?',
  whereArgs: [estado.id],
);
```

Fase 03:

```dart
await dao.atualizar(estado);
```

Resultado:

- a tela passa o objeto, o DAO cuida do resto.

## Delete

Fase 02:

```dart
await banco.delete('estado', where: 'id = ?', whereArgs: [id]);
```

Fase 03:

```dart
await dao.excluir(id);
```

## Responsabilidades por camada

```text
Fase 02                        Fase 03
─────────────────────────────────────────────────────
Tela: SQL direto               Tela: chama DAO
Model: dados + validacao       Model: dados + validacao (igual)
Database: conexao              Database: conexao (igual)
```

Nova camada adicionada:

```text
DAO: todo o SQL de CRUD de uma entidade
```

## O que nao mudou

- o `Model` com `fromMap`, `toMap` e validacoes;
- o `bancoDados` com a conexao singleton;
- a estrutura das telas (lista + formulario).

A tela ficou mais curta. Ela perdeu o SQL. Ganhou clareza.

## Por que isso importa

Se a estrutura do banco mudar (renomear coluna, adicionar indice), a mudanca fica no DAO.

A tela nao precisa ser tocada.

Em um projeto maior, com varias telas acessando os mesmos dados, essa separacao evita que a mesma correcao precise ser feita em varios lugares.

## Referencias para estudo

- Oracle - Core J2EE Patterns - DAO: https://www.oracle.com/java/technologies/dataaccessobject.html
- Flutter - Guide to app architecture: https://docs.flutter.dev/app-architecture/guide
- Flutter - Persist data with SQLite: https://docs.flutter.dev/cookbook/persistence/sqlite
- sqflite - CRUD operations: https://pub.dev/packages/sqflite
