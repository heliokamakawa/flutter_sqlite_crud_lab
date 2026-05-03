# 02 - StatefulWidget e estado da tela

## Por que existem telas Stateful?

As telas de lista e formulario precisam guardar informacoes que mudam durante a execucao.

Exemplos:

- lista de estados carregada do banco;
- lista de cidades carregada do banco;
- texto digitado em um campo;
- estado selecionado no dropdown.

Por isso elas usam `StatefulWidget`.

## Exemplo: lista de estados

Arquivo estudado:

```text
lib/fases/fase_01/app/estado_lista.dart
```

Trecho:

```dart
class EstadoListaPage extends StatefulWidget {
  const EstadoListaPage({super.key});

  @override
  State<EstadoListaPage> createState() => _EstadoListaPageState();
}
```

`EstadoListaPage` representa o widget publico.

O estado real da tela fica em `_EstadoListaPageState`.

## Variavel que representa o estado da tela

```dart
class _EstadoListaPageState extends State<EstadoListaPage> {
  List<Map<String, dynamic>> estados = [];
}
```

A variavel `estados` guarda os registros encontrados no banco.

Ela comeca vazia.

Depois que o banco responde, ela recebe os dados.

## Carregamento inicial

```dart
@override
void initState() {
  super.initState();
  listarEstados();
}
```

`initState` roda uma vez quando a tela nasce.

Aqui ele chama `listarEstados`, que consulta o banco.

## Atualizacao visual com setState

```dart
setState(() {
  estados = resultado;
});
```

`setState` avisa ao Flutter:

"os dados desta tela mudaram; redesenhe a interface".

Sem `setState`, a variavel poderia mudar, mas a tela nao seria atualizada.

## Protecao com mounted

```dart
if (!mounted) {
  return;
}
```

Como a consulta ao banco e assincrona, pode acontecer de a tela ser fechada antes da resposta chegar.

`mounted` verifica se a tela ainda existe.

Se nao existir, o codigo para antes de chamar `setState`.

## Ideia principal

Uma tela `StatefulWidget` separa:

- a estrutura do widget;
- os dados mutaveis da tela;
- a atualizacao visual quando esses dados mudam.

