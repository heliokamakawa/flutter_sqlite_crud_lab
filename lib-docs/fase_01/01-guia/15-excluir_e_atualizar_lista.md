# 10 - Excluir e atualizar a lista

## Excluir cidade

Arquivo estudado:

```text
lib/fases/fase_01/app/cidade_lista.dart
```

Trecho:

```dart
Future<void> excluirCidade(int id) async {
  final Database banco = await Conexao.instancia.bancoDados;

  await banco.rawDelete('DELETE FROM cidade WHERE id = ?', [id]);

  await listarCidades();
}
```

O metodo recebe o id da cidade.

Depois executa um `DELETE`.

Em seguida chama `listarCidades` para atualizar a tela.

## Botao que chama a exclusao

```dart
IconButton(
  tooltip: 'Excluir',
  icon: const Icon(Icons.delete),
  onPressed: () => excluirCidade(cidade['id'] as int),
)
```

O id vem do mapa da cidade exibida no card.

## Por que chamar listarCidades de novo?

Depois do `DELETE`, o banco mudou.

Mas a lista na memoria ainda tem os dados antigos.

Por isso o codigo consulta o banco novamente:

```dart
await listarCidades();
```

Assim a interface passa a mostrar a lista atual.

## Excluir estado

Arquivo estudado:

```text
lib/fases/fase_01/app/estado_lista.dart
```

Trecho:

```dart
await banco.rawDelete('DELETE FROM cidade WHERE estado_id = ?', [id]);

await banco.rawDelete('DELETE FROM estado WHERE id = ?', [id]);
```

Ao excluir um estado, o codigo exclui primeiro as cidades daquele estado.

Depois exclui o estado.

## Por que essa ordem?

A cidade depende do estado pelo campo `estado_id`.

Mesmo sem uma chave estrangeira declarada, faz sentido apagar primeiro os registros dependentes.

Fluxo:

```text
apagar cidades do estado -> apagar estado -> recarregar estados
```

## Atualizacao da lista de estados

```dart
await listarEstados();
```

Depois da exclusao, a lista de estados e buscada novamente no banco.

## Diferenca entre excluir e alterar

Na exclusao, a propria tela de lista executa o `DELETE` e recarrega.

Na alteracao, a lista abre o formulario, espera `pop(true)` e so depois recarrega.

## Ideia principal

A tela so mostra dados atualizados quando a lista em memoria e sincronizada de novo com o banco.
