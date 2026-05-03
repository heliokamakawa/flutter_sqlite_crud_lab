# 07 - Formulario de cidade e dropdown

## Arquivo estudado

```text
lib/fases/fase_01/app/cidade_form.dart
```

## Estado interno do formulario

```dart
final TextEditingController nomeController = TextEditingController();

List<Map<String, dynamic>> estados = [];
int? estadoIdSelecionado;
```

O formulario de cidade precisa guardar:

- nome digitado;
- lista de estados disponiveis;
- id do estado escolhido.

## Carregamento inicial

```dart
@override
void initState() {
  super.initState();

  if (widget.cidade != null) {
    nomeController.text = widget.cidade!['nome'] as String;
  }

  listarEstados();
}
```

Quando esta alterando, o formulario recebe uma cidade.

O `initState` so preenche o nome. O estado selecionado e definido depois, dentro de `listarEstados`.

## Buscando estados para o dropdown

```dart
final List<Map<String, dynamic>> resultado = await banco.rawQuery(
  'SELECT id, nome, sigla FROM estado ORDER BY nome',
);
```

O formulario consulta a tabela `estado`.

Esses registros serao usados como opcoes do dropdown.

## Atualizando a lista de estados

```dart
setState(() {
  estados = resultado;
  if (widget.cidade != null) {
    estadoIdSelecionado = widget.cidade!['estado_id'] as int;
  }
});
```

O `setState` atualiza os itens do dropdown e o valor selecionado juntos, no mesmo redesenho.

Assim o dropdown ja sabe qual estado mostrar quando exibir os itens pela primeira vez.

## Dropdown

```dart
DropdownButtonFormField<int>(
  initialValue: estadoIdSelecionado,
)
```

O `initialValue` define qual estado aparece selecionado.

Como `estadoIdSelecionado` e definido no mesmo `setState` que carrega os estados, o valor sempre existe na lista quando o dropdown desenha.

## Itens do dropdown

```dart
items: [
  for (final Map<String, dynamic> estado in estados)
    DropdownMenuItem<int>(
      value: estado['id'] as int,
      child: Text('${estado['nome']} (${estado['sigla']})'),
    ),
],
```

Cada estado vira uma opcao.

O valor real salvo e o `id`.

O texto exibido e o nome com a sigla.

## Mudando a selecao

```dart
onChanged: (int? valor) {
  setState(() {
    estadoIdSelecionado = valor;
  });
},
```

Quando o usuario escolhe outro estado, o id selecionado e atualizado.

Esse id sera usado no `INSERT` ou no `UPDATE` da cidade.

## Ideia principal

O formulario de cidade depende de duas tabelas:

- `cidade`, para salvar o registro;
- `estado`, para preencher o dropdown.

