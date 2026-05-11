# Fase 01 - Formulario de cidade

Na Fase 01, a tela ainda trabalha com `Map<String, dynamic>` e SQL direto.

Por isso, o dropdown guarda apenas o `id` do estado:

```dart
int? estadoIdSelecionado;
```

O texto exibido mostra nome e sigla:

```dart
DropdownMenuItem<int>(
  value: estado['id'] as int,
  child: Text('${estado['nome']} (${estado['sigla']})'),
)
```

Esse formato e propositalmente simples para mostrar o funcionamento bruto.

Nas fases com Model, o objetivo didatico muda: o dropdown deve trabalhar com o objeto `Estado`, e a cidade salva apenas `estado.id`.
