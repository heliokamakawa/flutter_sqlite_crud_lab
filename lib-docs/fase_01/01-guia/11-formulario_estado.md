# 06 - Formulario de estado

## Arquivo estudado

```text
lib/fases/fase_01/app/estado_form.dart
```

## Controllers

```dart
final TextEditingController nomeController = TextEditingController();
final TextEditingController siglaController = TextEditingController();
```

Os controllers permitem ler e preencher os campos de texto.

`nomeController` controla o campo de nome.

`siglaController` controla o campo de sigla.

## Descobrindo se e cadastro ou alteracao

```dart
bool get editando => widget.estado != null;
```

Se `widget.estado` tiver dados, o formulario esta alterando.

Se for `null`, o formulario esta cadastrando.

## Preenchendo os campos ao alterar

```dart
if (estado != null) {
  nomeController.text = estado['nome'] as String;
  siglaController.text = estado['sigla'] as String;
}
```

Esse trecho roda no `initState`.

Quando a lista envia um estado para alteracao, o formulario copia os dados para os campos.

## Campo de nome

```dart
TextField(
  controller: nomeController,
  decoration: const InputDecoration(
    border: OutlineInputBorder(),
    labelText: 'Nome do estado',
  ),
)
```

O texto digitado fica acessivel por:

```dart
nomeController.text
```

## Campo de sigla

```dart
TextField(
  controller: siglaController,
  maxLength: 2,
  textCapitalization: TextCapitalization.characters,
)
```

O campo limita a sigla a dois caracteres.

Na hora de salvar, o codigo tambem transforma em maiusculo.

## Botao unico para duas acoes

```dart
FilledButton(
  onPressed: editando ? atualizarEstado : inserirEstado,
  child: Text(editando ? 'Atualizar' : 'Inserir'),
)
```

O mesmo botao serve para cadastrar ou alterar.

A decisao vem da propriedade `editando`.

## Liberando os controllers

```dart
@override
void dispose() {
  nomeController.dispose();
  siglaController.dispose();
  super.dispose();
}
```

`dispose` libera os controllers quando a tela e fechada.

Isso evita manter recursos desnecessarios em memoria.

## Ideia principal

O formulario de estado usa os mesmos campos para dois fluxos:

- cadastro: campos vazios;
- alteracao: campos preenchidos com dados recebidos da lista.

