# Fase 02 - Conexao singleton

## O que e Singleton

Singleton e um padrao de projeto que garante que uma classe tenha **apenas uma instancia** durante toda a execucao do programa.

Em vez de criar um novo objeto toda vez que precisar, voce acessa sempre o mesmo objeto ja existente.

Analogia direta: e como a porta de um predio. Existe uma porta so. Todo mundo usa a mesma. Nao faz sentido criar uma porta nova para cada pessoa que entra.

## Para que serve

Use Singleton quando:

- o objeto e caro de criar (ex: abrir conexao com banco);
- voce precisa de um ponto unico de acesso (ex: configuracoes do app);
- criar mais de uma instancia causaria problema (ex: duas conexoes abertas com o mesmo banco).

## Como funciona em Dart

```dart
class MinhaClasse {
  MinhaClasse._();                              // construtor privado
  static final MinhaClasse instance = MinhaClasse._(); // instancia unica
}
```

- `MinhaClasse._()` — o construtor e privado, entao ninguem de fora consegue fazer `MinhaClasse()`;
- `instance` e `static final` — existe uma unica vez, compartilhada por todos;
- quem precisar usa `MinhaClasse.instance`.

## Arquivo principal

```text
lib/fases/fase_02/database/database.dart
```

Esse arquivo centraliza a abertura do banco da Fase 02.

## Arquivo de SQL

```text
lib/fases/fase_02/database/database_sql.dart
```

Esse arquivo guarda os comandos de criacao das tabelas e a carga inicial.

Assim, a classe de conexao nao precisa carregar todo o texto SQL dentro do `onCreate`.

## Singleton

```dart
class Fase02Database {
  Fase02Database._();

  static final Fase02Database instance = Fase02Database._();

  Database? _database;
}
```

Pontos importantes:

- o construtor `_()` e privado;
- `instance` guarda a instancia unica da classe;
- `_database` guarda a conexao aberta;
- o getter `database` reaproveita a conexao quando ela ja existe.

## Uso nas telas

Na Fase 01:

```dart
final Database banco = await abrirConexaoBanco();
```

Na Fase 02:

```dart
final Database banco = await Fase02Database.instance.database;
```

## Por que melhora?

Se o nome do banco mudar, a alteracao fica em um arquivo.

Se a forma de abrir o banco mudar, a alteracao fica em um arquivo.

Se os comandos de criacao mudarem, a alteracao fica no arquivo de SQL.

As telas deixam de repetir a abertura do banco.

## Cuidado conceitual

Singleton e util aqui porque o app didatico usa uma unica conexao local.

Isso nao significa que Singleton deve ser usado em qualquer situacao. Em arquiteturas maiores, muitas vezes a conexao ou o repositorio entra por injecao de dependencia para facilitar testes e troca de implementacao.

Nesta fase, o Singleton e uma ponte simples entre:

```text
tela abre banco diretamente
```

e:

```text
camada propria de dados
```

## Testes relacionados

```text
test/fases/fase_02/database/database_test.dart
test/fases/fase_02/database/database_sql_integration_test.dart
```

Esses testes verificam se:

- a conexao e reutilizada enquanto esta aberta;
- as tabelas sao criadas;
- a carga inicial foi executada;
- os comandos SQL podem ser executados passo a passo em SQLite em memoria.

## Referencias para estudo

- sqflite - Opening a database: https://pub.dev/packages/sqflite
- Flutter - Persist data with SQLite: https://docs.flutter.dev/cookbook/persistence/sqlite
- sqflite_common_ffi - testes com SQLite fora do app: https://pub.dev/packages/sqflite_common_ffi
- Refactoring Guru - Singleton: https://refactoring.guru/pt-br/design-patterns/singleton
