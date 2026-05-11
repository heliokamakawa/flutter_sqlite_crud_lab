# Fase 03 - DAO

DAO e a classe que concentra o acesso ao banco.

Sem DAO, a tela escreve SQL:

```dart
await banco.rawQuery('SELECT id, nome, sigla FROM estado ORDER BY nome');
```

Com DAO, a tela chama um metodo:

```dart
final estados = await EstadoDao(banco).buscarTodos();
```

## Responsabilidade

```text
Model  -> valida e transporta dados
DAO    -> executa SQL e faz o mapeamento objeto-relacional
Tela   -> mostra dados e recebe acoes
```

O mapeamento objeto-relacional acontece quando o DAO:

- transforma `Map` do SQLite em `Estado` com `Estado.fromMap`;
- transforma `Estado` em `Map` com `estado.toMap`.

## Metodos usados

```text
buscarTodos()
buscarPorId(id)
inserir(model)
atualizar(model)
excluir(id)
```

Neste projeto, DAO e suficiente para o objetivo didatico.

## Referencias

- sqflite - CRUD operations: https://pub.dev/packages/sqflite
- Flutter - Persist data with SQLite: https://docs.flutter.dev/cookbook/persistence/sqlite
