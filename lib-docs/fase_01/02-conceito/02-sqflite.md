# 02 - sqflite

## Ideia principal

`sqflite` e o pacote usado para acessar SQLite em apps Flutter.

Ele permite:

- abrir um banco;
- criar tabelas;
- inserir registros;
- consultar registros;
- alterar registros;
- excluir registros.

O resultado de consultas vem como lista de mapas:

```dart
List<Map<String, dynamic>>
```

Cada `Map` representa uma linha retornada pelo banco.

## Abrindo o banco

Na Fase 01, a abertura do banco fica diretamente nas telas:

```dart
final String caminhoBanco = p.join(
  await getDatabasesPath(),
  'fase_01_crud_raiz.db',
);

final Database banco = await openDatabase(
  caminhoBanco,
  version: 1,
  onCreate: (Database db, int version) async {
    await db.execute('CREATE TABLE ...');
  },
);
```

A funcao `openDatabase` abre o arquivo. Se ele ainda nao existir, o SQLite cria esse arquivo.

## Banco SQLite como arquivo

Um banco SQLite normalmente e um arquivo local.

Neste projeto, o arquivo da Fase 01 se chama:

```text
fase_01_crud_raiz.db
```

Quando o app abre esse banco pela primeira vez, o callback `onCreate` executa os comandos de criacao das tabelas.

## Versao do banco

```dart
version: 1
```

A versao serve para controlar mudancas futuras na estrutura do banco.

Na Fase 01 ainda nao trabalhamos com migracoes. O objetivo e apenas criar o banco inicial.

## Condicao para Web

O `sqflite` tradicional atende Android, iOS e macOS.

Para rodar no navegador, o projeto troca a fabrica de banco antes de abrir a conexao:

```dart
if (kIsWeb) {
  databaseFactory = databaseFactoryFfiWeb;
}
```

No navegador, a persistencia usa recursos do browser. Por isso, ao testar em Web, procure usar sempre a mesma porta local.

## Por que fazer assim nesta fase

A Fase 01 e propositalmente direta.

O objetivo e enxergar o fluxo bruto:

1. descobrir o caminho do banco;
2. abrir o arquivo;
3. criar as tabelas;
4. executar SQL;
5. receber os dados como `Map`.

Ainda nao ha classe de conexao, DAO ou Model.

## Referencias para estudo

- Flutter - Persist data with SQLite: https://docs.flutter.dev/cookbook/persistence/sqlite
- sqflite no pub.dev: https://pub.dev/packages/sqflite
- sqflite_common_ffi_web no pub.dev: https://pub.dev/packages/sqflite_common_ffi_web
- SQLite - Documentacao oficial: https://www.sqlite.org/docs.html
