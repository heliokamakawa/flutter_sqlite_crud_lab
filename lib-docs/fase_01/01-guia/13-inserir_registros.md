# 08 - Inserir registros

## Inserir estado

Arquivo estudado:

```text
lib/fases/fase_01/app/estado_form.dart
```

Trecho:

```dart
final String nome = nomeController.text.trim();
final String sigla = siglaController.text.trim().toUpperCase();
```

Antes de salvar, o formulario pega os textos digitados.

`trim` remove espacos nas pontas.

`toUpperCase` transforma a sigla em maiuscula.

## Validacao simples

```dart
if (nome.isEmpty || sigla.isEmpty) {
  mostrarMensagem('Informe nome e sigla.');
  return;
}
```

Se algum campo estiver vazio, o registro nao e salvo.

O `return` interrompe o metodo.

## Comando INSERT de estado

```dart
await banco.rawInsert('INSERT INTO estado (nome, sigla) VALUES (?, ?)', [
  nome,
  sigla,
]);
```

Esse comando cria uma nova linha na tabela `estado`.

Os `?` sao substituidos pelos valores da lista, na ordem:

1. `nome`;
2. `sigla`.

## Fechando formulario com sucesso

```dart
Navigator.of(context).pop(true);
```

Depois de inserir, o formulario fecha e devolve `true` para a lista.

Esse retorno informa que a lista deve ser recarregada.

## Inserir cidade

Arquivo estudado:

```text
lib/fases/fase_01/app/cidade_form.dart
```

Trecho:

```dart
final String nome = nomeController.text.trim();
final int? estadoId = estadoIdSelecionado;
```

Para inserir uma cidade, o formulario precisa do nome e do id do estado selecionado.

## Validacao da cidade

```dart
if (nome.isEmpty || estadoId == null) {
  mostrarMensagem('Informe o nome e escolha o estado.');
  return;
}
```

A cidade so pode ser salva se tiver:

- nome;
- estado escolhido.

## Comando INSERT de cidade

```dart
await banco.rawInsert(
  'INSERT INTO cidade (nome, estado_id) VALUES (?, ?)',
  [nome, estadoId],
);
```

Esse comando cria uma cidade vinculada a um estado.

O vinculo e feito pelo campo `estado_id`.

## Ideia principal

Inserir segue sempre o mesmo fluxo:

```text
ler campos -> validar -> abrir banco -> executar INSERT -> pop(true)
```
