# 09 - Alterar registros

## Quando o formulario altera?

O formulario altera quando recebe um mapa vindo da lista.

Exemplo:

```dart
EstadoFormPage(estado: estado)
```

ou:

```dart
CidadeFormPage(cidade: cidade)
```

## Alterar estado

Arquivo estudado:

```text
lib/fases/fase_01/app/estado_form.dart
```

Trecho:

```dart
final int id = widget.estado!['id'] as int;
```

O id vem do registro enviado pela lista.

O `!` indica que o codigo espera que `widget.estado` nao seja nulo neste fluxo.

## Dados atualizados

```dart
final String nome = nomeController.text.trim();
final String sigla = siglaController.text.trim().toUpperCase();
```

Os novos valores saem dos campos de texto.

## Comando UPDATE de estado

```dart
await banco.rawUpdate(
  'UPDATE estado SET nome = ?, sigla = ? WHERE id = ?',
  [nome, sigla, id],
);
```

O `UPDATE` muda apenas o registro com o id informado.

A ordem dos parametros importa:

1. novo nome;
2. nova sigla;
3. id do estado alterado.

## Alterar cidade

Arquivo estudado:

```text
lib/fases/fase_01/app/cidade_form.dart
```

Trecho:

```dart
final int id = widget.cidade!['id'] as int;
final String nome = nomeController.text.trim();
final int? estadoId = estadoIdSelecionado;
```

A alteracao da cidade precisa:

- id da cidade;
- novo nome;
- novo estado selecionado.

## Comando UPDATE de cidade

```dart
await banco.rawUpdate(
  'UPDATE cidade SET nome = ?, estado_id = ? WHERE id = ?',
  [nome, estadoId, id],
);
```

Esse comando pode alterar tanto o nome da cidade quanto o estado ao qual ela pertence.

## Fechando com sucesso

```dart
Navigator.of(context).pop(true);
```

Depois do `UPDATE`, o formulario fecha retornando `true`.

A lista recebe esse retorno e chama a consulta novamente.

## Ideia principal

Alterar segue este fluxo:

```text
lista envia registro -> formulario preenche campos -> usuario muda dados -> UPDATE por id -> pop(true) -> lista recarrega
```

