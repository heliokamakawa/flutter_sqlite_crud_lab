# 03 - Conexao e criacao do banco

## Arquivos estudados

A funcao `abrirConexaoBanco` aparece repetida em:

```text
estado_lista.dart
estado_form.dart
cidade_lista.dart
cidade_form.dart
```

Essa repeticao e proposital nesta fase.

## Funcao de abertura

```dart
Future<Database> abrirConexaoBanco() async {
  if (kIsWeb) {
    databaseFactory = databaseFactoryFfiWeb;
  }
```

A funcao retorna um `Future<Database>` porque abrir um banco e uma operacao assincrona.

No navegador, o projeto usa `sqflite_common_ffi_web`.

## Caminho do banco

```dart
final String caminhoBanco = kIsWeb
    ? 'fase_01_crud_raiz_web.db'
    : p.join(await getDatabasesPath(), 'fase_01_crud_raiz.db');
```

Se estiver rodando na Web, o banco usa um nome simples.

Nas outras plataformas, o caminho e montado com:

- `getDatabasesPath`;
- `p.join`;
- nome do arquivo `.db`.

## Abertura com versao

```dart
return openDatabase(
  caminhoBanco,
  version: 1,
  onCreate: (Database db, int version) async {
    // criacao das tabelas
  },
);
```

`openDatabase` abre o banco.

Se o arquivo ainda nao existir, o `onCreate` e executado.

## Criacao da tabela estado

```dart
await db.execute('''
  CREATE TABLE estado (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nome TEXT NOT NULL,
    sigla TEXT NOT NULL
  )
''');
```

Essa tabela guarda os estados.

Campos:

- `id`: identificador unico;
- `nome`: nome do estado;
- `sigla`: sigla do estado.

## Criacao da tabela cidade

```dart
await db.execute('''
  CREATE TABLE cidade (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nome TEXT NOT NULL,
    estado_id INTEGER NOT NULL
  )
''');
```

Essa tabela guarda as cidades.

O campo `estado_id` indica a qual estado a cidade pertence.

Nesta fase, ele e apenas um numero. Ainda nao existe uma regra de chave estrangeira declarada no banco.

## Dados iniciais

```dart
await db.rawInsert('INSERT INTO estado (nome, sigla) VALUES (?, ?)', [
  'Sao Paulo',
  'SP',
]);
```

O banco recebe alguns estados e cidades iniciais.

Isso facilita testar a listagem logo na primeira execucao.

## Ideia principal

Nesta fase, cada tela sabe abrir o banco e sabe como criar as tabelas.

Isso ajuda a enxergar o funcionamento, mas gera repeticao.

