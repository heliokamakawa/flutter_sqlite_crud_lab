# 11 - Pontos de repeticao e proxima fase

## Por que esta fase e chamada de CRUD raiz?

Porque as telas fazem tudo diretamente:

- acessam a conexao;
- escrevem SQL;
- leem mapas;
- atualizam a interface.

Isso deixa o funcionamento visivel para estudo.

## Conexao padronizada

A abertura do banco fica centralizada em:

```text
lib/fases/fase_01/database/conexao.dart
```

As telas usam:

```dart
final Database banco = await Conexao.instancia.bancoDados;
```

## Problema pratico

Mesmo com a conexao centralizada, o SQL ainda fica nas telas.

Esse e o tipo de problema que motiva as proximas fases.

## SQL espalhado

Exemplos:

```dart
'SELECT id, nome, sigla FROM estado ORDER BY nome'
```

```dart
'UPDATE cidade SET nome = ?, estado_id = ? WHERE id = ?'
```

```dart
'DELETE FROM cidade WHERE estado_id = ?'
```

Cada tela conhece os nomes:

- das tabelas;
- das colunas;
- dos comandos SQL.

## Uso de Map

Exemplo:

```dart
estado['nome']
cidade['estado_id']
cidade['estado_sigla']
```

O `Map<String, dynamic>` e simples para aprender.

Mas ele nao protege contra erro de digitacao em nomes de campos.

Exemplo conceitual:

```dart
estado['nomme']
```

O Dart nao consegue avisar antes da execucao que o nome da chave esta errado.

## Responsabilidades misturadas

Uma mesma tela cuida de:

- interface;
- validacao;
- navegacao;
- SQL;
- banco;
- conversao dos dados.

Para uma fase inicial, isso e bom porque tudo esta visivel.

Para um projeto maior, isso dificulta manutencao.

## O que a proxima fase deve melhorar

A proxima evolucao pode separar:

- conexao com banco;
- modelos de dados;
- comandos SQL;
- telas;
- regras de CRUD.

## Ideia principal

Esta fase ensina o caminho completo dos dados.

Depois que esse caminho fica claro, vale organizar melhor o codigo.
