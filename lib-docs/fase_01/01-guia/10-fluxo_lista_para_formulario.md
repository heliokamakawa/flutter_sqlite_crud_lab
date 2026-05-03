# 05 - Fluxo da lista para o formulario

## Objetivo

Este arquivo explica como a lista abre o formulario e como dados sao enviados para alteracao.

## Abrindo formulario para inserir

Na lista de estados:

```dart
FilledButton.icon(
  onPressed: () => abrirFormularioEstado(),
  icon: const Icon(Icons.add),
  label: const Text('Cadastrar estado'),
)
```

Quando nenhum estado e enviado, o formulario entende que esta criando um novo registro.

## Abrindo formulario para alterar

No botao de edicao:

```dart
IconButton(
  tooltip: 'Alterar',
  icon: const Icon(Icons.edit),
  onPressed: () => abrirFormularioEstado(estado: estado),
)
```

Aqui a lista envia o mapa `estado` para o formulario.

Esse mapa contem os dados da linha clicada.

## Metodo que abre o formulario

```dart
Future<void> abrirFormularioEstado({Map<String, dynamic>? estado}) async {
  final bool? salvou = await Navigator.of(context).push(
    MaterialPageRoute(builder: (_) => EstadoFormPage(estado: estado)),
  );

  if (salvou == true) {
    await listarEstados();
  }
}
```

Esse metodo faz duas coisas:

1. abre a tela de formulario;
2. espera o formulario fechar.

O `await` e importante porque a lista precisa saber se o formulario salvou alguma coisa.

## Envio de dados para o construtor

```dart
EstadoFormPage(estado: estado)
```

O formulario recebe o registro pelo construtor.

No formulario:

```dart
final Map<String, dynamic>? estado;
```

O `?` indica que o valor pode ser nulo.

Se for nulo, e cadastro.

Se tiver dados, e alteracao.

## Recebendo resposta do formulario

```dart
Navigator.of(context).pop(true);
```

Depois de inserir ou atualizar, o formulario fecha retornando `true`.

Esse `true` volta para a variavel `salvou` na lista.

## Recarregando a lista depois do formulario

```dart
if (salvou == true) {
  await listarEstados();
}
```

Se o formulario salvou, a lista consulta o banco novamente.

Assim a tela mostra os dados atualizados.

## Mesmo fluxo para cidade

A tela `cidade_lista.dart` usa a mesma ideia:

```dart
CidadeFormPage(cidade: cidade)
```

O formulario de cidade recebe um mapa opcional chamado `cidade`.

## Ideia principal

O fluxo de alteracao e:

```text
lista -> envia Map para formulario -> formulario altera banco -> pop(true) -> lista recarrega
```

