# Fase 04 - DropdownButton com Objeto

## O problema com DropdownButton<int>

Na Fase 03, o dropdown de estados no formulario de cidade usava `int`:

```dart
int? estadoIdSelecionado;

DropdownButton<int>(
  value: estadoIdSelecionado,
  items: [
    for (final Estado estado in estados)
      DropdownMenuItem<int>(value: estado.id, child: Text(estado.descricao)),
  ],
  onChanged: (int? valor) {
    setState(() { estadoIdSelecionado = valor; });
  },
)
```

Ao salvar:

```dart
Cidade(nome: nome, estadoId: estadoIdSelecionado!)
```

Funciona. Mas ao editar uma cidade, o dropdown precisa pre-selecionar o estado correto.

O `DropdownButton` usa `value == item.value` para identificar o item selecionado.

Com `int`, isso e simples: `3 == 3`. Mas voce so tem o id — se precisar do nome do estado para outra coisa na tela, precisa buscar de novo.

## DropdownButton<Estado>

A Fase 04 usa `Estado` como tipo do dropdown:

```dart
Estado? estadoSelecionado;

DropdownButton<Estado>(
  value: estadoSelecionado,
  items: [
    for (final Estado estado in estados)
      DropdownMenuItem<Estado>(value: estado, child: Text(estado.descricao)),
  ],
  onChanged: (Estado? valor) {
    setState(() { estadoSelecionado = valor; });
  },
)
```

Ao salvar:

```dart
Cidade(nome: nome, estadoId: estadoSelecionado!.id!)
```

Agora o formulario tem acesso ao objeto `Estado` completo — nome, sigla, id — sem precisar buscar de novo.

## Por que == e hashCode sao necessarios

O `DropdownButton` compara `value` com o `value` de cada `DropdownMenuItem` usando `==`.

Quando o tipo e `int`, isso funciona automaticamente porque Dart ja define `==` para inteiros.

Quando o tipo e um objeto customizado, Dart usa identidade por padrao:

```dart
// sem == customizado
final Estado a = Estado(id: 1, nome: 'Sao Paulo', sigla: 'SP');
final Estado b = Estado(id: 1, nome: 'Sao Paulo', sigla: 'SP');

print(a == b); // false — sao objetos diferentes na memoria
```

Isso causa o problema: ao editar uma cidade, o dropdown carrega uma nova lista de estados do banco. O `estadoSelecionado` e um objeto `Estado` com id 3. Os itens da lista sao novos objetos `Estado`, tambem com id 3 — mas sao instancias diferentes. O `==` falha. O dropdown nao pre-seleciona nada.

A solucao e definir `==` e `hashCode` no `Estado`:

```dart
@override
bool operator ==(Object other) =>
    identical(this, other) || (other is Estado && other.id == id);

@override
int get hashCode => id.hashCode;
```

Agora dois estados com o mesmo `id` sao considerados iguais, independente de serem instancias diferentes.

## Regra geral

Sempre que um objeto customizado for usado em:

```text
DropdownButton<T>.value
Set<T>
Map<T, ...> como chave
List.contains(T)
```

ele precisa de `==` e `hashCode` coerentes.

Se dois objetos representam a mesma entidade (mesmo `id`), eles devem ser iguais segundo `==`.

## Comparacao: int vs objeto no dropdown

```text
DropdownButton<int>
  Pro: simples, sem necessidade de == customizado
  Con: voce tem apenas o id; nao tem acesso ao nome/sigla sem buscar novamente

DropdownButton<Estado>
  Pro: objeto completo disponivel; pre-selecao funciona naturalmente apos definir ==
  Con: requer == e hashCode no Model
```

Para entidades simples em telas simples, `<int>` e suficiente.

Para formularios que precisam exibir dados do objeto selecionado ou que precisam pre-selecionar ao editar, `<Estado>` e mais adequado.

## Referencias para estudo

- Dart - Operator overloading: https://dart.dev/language/methods#operators
- Dart - hashCode: https://api.dart.dev/stable/dart-core/Object/hashCode.html
- Flutter - DropdownButton: https://api.flutter.dev/flutter/material/DropdownButton-class.html
- Effective Dart - Equality: https://dart.dev/effective-dart/design#equality
