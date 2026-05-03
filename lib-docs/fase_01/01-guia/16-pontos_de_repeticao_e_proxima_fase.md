# 11 - Pontos de repeticao e proxima fase

## Por que esta fase e chamada de CRUD raiz?

Porque as telas fazem tudo diretamente:

- abrem o banco;
- criam tabelas;
- escrevem SQL;
- leem mapas;
- atualizam a interface.

Isso deixa o funcionamento visivel para estudo.

## Repeticao da conexao

O mesmo trecho aparece em quatro arquivos:

```dart
Future<Database> abrirConexaoBanco() async {
  // define plataforma
  // monta caminho
  // chama openDatabase
  // cria tabelas no onCreate
}
```

Arquivos:

```text
estado_lista.dart
estado_form.dart
cidade_lista.dart
cidade_form.dart
```

## Problema pratico

Se o nome do banco mudar, sera preciso alterar varios arquivos.

Se uma tabela mudar, sera preciso repetir a mudanca em todas as copias de `onCreate`.

Esse e o tipo de problema que motiva a proxima fase.

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

