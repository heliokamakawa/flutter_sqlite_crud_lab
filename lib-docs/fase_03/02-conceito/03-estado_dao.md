# Fase 03 - EstadoDao

## Arquivo

```text
lib/fases/fase_03/dao/estado_dao.dart
```

## Estrutura completa

```dart
class EstadoDao {
  EstadoDao(this._database);

  final Database _database;

  static const String _tabela = 'estado';

  Future<List<Estado>> findAll() async { ... }
  Future<Estado?> findById(int id) async { ... }
  Future<void> insert(Estado estado) async { ... }
  Future<void> update(Estado estado) async { ... }
  Future<void> delete(int id) async { ... }
}
```

O DAO recebe a conexao pelo construtor (`_database`).

A constante `_tabela` evita repetir o nome da tabela em cada metodo.

## findAll

```dart
Future<List<Estado>> findAll() async {
  final List<Map<String, dynamic>> resultado = await _database.rawQuery(
    'SELECT id, nome, sigla FROM $_tabela ORDER BY nome',
  );

  return resultado.map(Estado.fromMap).toList();
}
```

Retorna todos os estados ordenados por nome.

O `rawQuery` retorna uma lista de mapas. O `Estado.fromMap` converte cada mapa em um objeto `Estado`.

## findById

```dart
Future<Estado?> findById(int id) async {
  final List<Map<String, dynamic>> resultado = await _database.rawQuery(
    'SELECT id, nome, sigla FROM $_tabela WHERE id = ?',
    [id],
  );

  if (resultado.isEmpty) {
    return null;
  }

  return Estado.fromMap(resultado.first);
}
```

Retorna um estado pelo id, ou `null` se nao encontrado.

O `?` no SQL e um parametro posicional. O valor correspondente vai na lista `[id]`.

Isso evita SQL injection — o valor nunca e concatenado diretamente na string.

## insert

```dart
Future<void> insert(Estado estado) async {
  await _database.insert(_tabela, estado.toMap());
}
```

Insere o estado no banco.

`estado.toMap()` sem `incluirId: true` nao inclui o `id` no mapa, porque o banco gera o id automaticamente via `AUTOINCREMENT`.

## update

```dart
Future<void> update(Estado estado) async {
  await _database.update(
    _tabela,
    estado.toMap(),
    where: 'id = ?',
    whereArgs: [estado.id],
  );
}
```

Atualiza o estado que tem o id correspondente.

O `id` nao vai no mapa de dados — ele vai em `whereArgs`, como criterio de filtro.

## delete

```dart
Future<void> delete(int id) async {
  await _database.delete(
    _tabela,
    where: 'id = ?',
    whereArgs: [id],
  );
}
```

Remove o estado pelo id.

## Como a tela usa o DAO

Antes (Fase 02):

```dart
final Database banco = await Fase02Database.instance.database;

final List<Map<String, dynamic>> resultado = await banco.rawQuery(
  'SELECT id, nome, sigla FROM estado ORDER BY nome',
);

final List<Estado> estados = resultado.map(Estado.fromMap).toList();
```

Depois (Fase 03):

```dart
final Database banco = await Fase03Database.instance.database;
final EstadoDao dao = EstadoDao(banco);

final List<Estado> estados = await dao.findAll();
```

A tela deixou de saber SQL.

Ela sabe que quer todos os estados.
Ela nao sabe como o banco os retorna.

## Parametros posicionais e SQL injection

Sempre use `?` e `whereArgs` em vez de concatenar valores na string SQL:

```dart
// correto
'SELECT id FROM estado WHERE id = ?', [id]

// NUNCA faca isso
'SELECT id FROM estado WHERE id = $id'
```

A concatenacao direta permite SQL injection — um valor malicioso pode alterar o comando SQL inteiro.

## Referencias para estudo

- Oracle - Core J2EE Patterns - DAO: https://www.oracle.com/java/technologies/dataaccessobject.html
- sqflite - Database operations: https://pub.dev/packages/sqflite
- OWASP - SQL Injection: https://owasp.org/www-community/attacks/SQL_Injection
- Flutter - Persist data with SQLite: https://docs.flutter.dev/cookbook/persistence/sqlite
- Dart - async e await: https://dart.dev/codelabs/async-await
