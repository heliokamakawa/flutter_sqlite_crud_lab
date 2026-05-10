# Fase 02 - Comparacao com a Fase 01

## Conexao

Fase 01:

```dart
final Database banco = await Conexao.instancia.bancoDados;
```

Fase 02:

```dart
final Database banco = await Conexao.instancia.bancoDados;
```

Resultado:

- mesmo padrao de conexao nas duas fases;
- mudancas mais localizadas;
- conexao reutilizada enquanto estiver aberta.

## SQL inicial

Fase 01:

```dart
onCreate: (Database db, int version) async {
  await db.execute('CREATE TABLE ...');
}
```

Fase 02:

```dart
for (final String comando in DatabaseSql.comandosCriacao) {
  await db.execute(comando);
}
```

Resultado:

- a conexao cuida de abrir o banco;
- o arquivo `database_sql.dart` guarda os comandos SQL iniciais;
- os testes conseguem executar os comandos passo a passo.

## Dados na tela

Fase 01:

```dart
List<Map<String, dynamic>> estados = [];
```

Fase 02:

```dart
List<Estado> estados = [];
```

Resultado:

- leitura mais clara;
- menos acesso por string;
- dados com tipo explicito.

## Listagem com JOIN

Fase 01:

```dart
List<Map<String, dynamic>> cidades = [];
```

Fase 02:

```dart
List<Cidade> cidades = [];
```

Resultado:

- a tela acessa `cidade.nome` e `cidade.estadoId`;
- o `Map` fica restrito ao momento de conversao em `Cidade.fromMap`;
- `Cidade` representa somente a tabela `cidade`.

## Inserir e alterar

Fase 02 cria um model antes de salvar:

```dart
return Estado(id: id, nome: nome, sigla: sigla);
```

Isso separa a leitura dos campos da representacao do dado.

O proprio model converte para o mapa esperado pelo SQLite:

```dart
await banco.insert('estado', estado.toMap());
```

Ou usado em uma atualizacao:

```dart
await banco.update(
  'estado',
  estado.toMap(),
  where: 'id = ?',
  whereArgs: [estado.id],
);
```

Assim, o model representa a entidade, suas validacoes e a conversao para mapa. Tudo em um lugar so.

## Testes

Fase 01 ainda foi estudada principalmente pela execucao manual do app.

Fase 02 comeca a criar uma rede de seguranca:

```text
test/fases/fase_02/database/
test/fases/fase_02/models/
```

Resultado:

- o aluno pode validar pequenos trechos;
- erros de SQL aparecem antes de abrir a tela;
- mudancas no Model ficam mais faceis de conferir.

## Ideia principal

A Fase 02 ainda nao e arquitetura completa.

Ela e o primeiro passo para sair do CRUD raiz:

```text
menos Map solto
menos conexao repetida
SQL inicial mais organizado
mais tipos explicitos
testes para guiar a evolucao
```

## Referencias para estudo

- Flutter - Persist data with SQLite: https://docs.flutter.dev/cookbook/persistence/sqlite
- Flutter - Guide to app architecture: https://docs.flutter.dev/app-architecture/guide
- Flutter - Testing Flutter apps: https://docs.flutter.dev/testing/overview
- SQLite - CREATE TABLE: https://www.sqlite.org/lang_createtable.html
- sqflite no pub.dev: https://pub.dev/packages/sqflite
