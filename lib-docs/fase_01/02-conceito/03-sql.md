# 03 - SQL

## Ideia principal

SQL e a linguagem usada para conversar com bancos relacionais.

Na Fase 01, o app usa SQL diretamente nas telas para mostrar o funcionamento bruto do CRUD.

## CREATE TABLE

Cria uma tabela no banco.

```sql
CREATE TABLE estado (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  nome TEXT NOT NULL,
  sigla TEXT NOT NULL
)
```

Pontos importantes:

- `id` identifica cada registro;
- `PRIMARY KEY` define a chave primaria;
- `AUTOINCREMENT` permite gerar o id automaticamente;
- `TEXT` armazena texto;
- `NOT NULL` impede valor nulo.

## INSERT

Insere um novo registro.

```sql
INSERT INTO estado (nome, sigla) VALUES (?, ?)
```

Os `?` sao parametros.

No Dart, os valores sao enviados separadamente:

```dart
await banco.rawInsert(
  'INSERT INTO estado (nome, sigla) VALUES (?, ?)',
  ['Sao Paulo', 'SP'],
);
```

Isso evita montar SQL concatenando texto e valores.

## SELECT

Busca registros do banco.

```sql
SELECT id, nome, sigla FROM estado ORDER BY nome
```

No `sqflite`, o resultado vem como:

```dart
List<Map<String, dynamic>>
```

Cada `Map` representa uma linha.

## UPDATE

Atualiza um registro existente.

```sql
UPDATE estado SET nome = ?, sigla = ? WHERE id = ?
```

O `WHERE` indica qual registro sera alterado.

Sem `WHERE`, varios registros poderiam ser alterados de uma vez.

## DELETE

Remove um registro.

```sql
DELETE FROM estado WHERE id = ?
```

O `WHERE` tambem e essencial aqui.

Sem `WHERE`, o comando pode apagar todos os registros da tabela.

## JOIN

Une dados de mais de uma tabela em uma consulta.

Na listagem de cidades, usamos `JOIN` para mostrar dados da cidade e do estado:

```sql
SELECT
  cidade.id,
  cidade.nome,
  cidade.estado_id,
  estado.sigla AS estado_sigla
FROM cidade
LEFT JOIN estado ON estado.id = cidade.estado_id
```

Esse resultado nao representa apenas uma tabela. Por isso, nas proximas fases, esse tipo de retorno fica melhor em um DTO.

## Referencias para estudo

- SQLite - SQL Language: https://www.sqlite.org/lang.html
- SQLite - CREATE TABLE: https://www.sqlite.org/lang_createtable.html
- SQLite - INSERT: https://www.sqlite.org/lang_insert.html
- SQLite - SELECT: https://www.sqlite.org/lang_select.html
- SQLite - UPDATE: https://www.sqlite.org/lang_update.html
- SQLite - DELETE: https://www.sqlite.org/lang_delete.html
