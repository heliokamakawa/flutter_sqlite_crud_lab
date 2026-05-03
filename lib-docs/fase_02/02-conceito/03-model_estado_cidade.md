# Fase 02 - Model de Estado e Cidade

## Ideia principal

Model representa um conceito principal do sistema.

Nesta fase, os conceitos principais sao:

```text
Estado
Cidade
```

Um model nao deve existir apenas porque existe uma tabela no banco.

Ele existe porque a aplicacao precisa trabalhar com uma ideia do dominio. Neste projeto, a aplicacao trabalha com estados e cidades. Por isso, `Estado` e `Cidade` sao models.

## Referencia oficial

O Flutter cookbook oficial — "Persist data with SQLite" — mostra exatamente essa abordagem: uma classe que representa o dado, com `toMap` para gravar no banco e um construtor de mapa para ler do banco.

```dart
// exemplo do cookbook oficial
class Dog {
  final int id;
  final String name;
  final int age;

  Dog({required this.id, required this.name, required this.age});

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'age': age};
  }
}
```

Neste projeto, `Estado` e `Cidade` seguem o mesmo principio.

## Estado

```dart
class Estado {
  Estado({this.id, required String nome, required String sigla})
    : nome = nome.trim(),
      sigla = sigla.trim().toUpperCase() {
    if (this.nome.isEmpty) {
      throw ArgumentError('Nome do estado e obrigatorio.');
    }
    if (this.sigla.length != 2) {
      throw ArgumentError('Sigla do estado deve ter 2 caracteres.');
    }
  }

  final int? id;
  final String nome;
  final String sigla;

  factory Estado.fromMap(Map<String, dynamic> map) {
    return Estado(
      id: map['id'] as int,
      nome: map['nome'] as String,
      sigla: map['sigla'] as String,
    );
  }

  Map<String, dynamic> toMap({bool incluirId = false}) {
    return {
      if (incluirId && id != null) 'id': id,
      'nome': nome,
      'sigla': sigla,
    };
  }

  String get descricao => '$nome ($sigla)';
}
```

### fromMap

Converte o `Map<String, dynamic>` retornado pelo SQLite em um objeto `Estado`.

Usado na listagem:

```dart
final List<Estado> estados = resultado.map(Estado.fromMap).toList();
```

### toMap

Converte o `Estado` no mapa esperado pelo SQLite para INSERT ou UPDATE.

O parametro `incluirId` controla se o campo `id` deve ser incluido:

```dart
estado.toMap()               // para INSERT - banco gera o id
estado.toMap(incluirId: true) // util quando necessario incluir o id no mapa
```

Para UPDATE, o `id` vai em `whereArgs`, nao no mapa:

```dart
await banco.update(
  'estado',
  estado.toMap(),             // sem id no mapa
  where: 'id = ?',
  whereArgs: [estado.id],    // id aqui, no filtro
);
```

### descricao

Getter de exibicao, usado no dropdown de cidades:

```dart
String get descricao => '$nome ($sigla)';
// resultado: 'Sao Paulo (SP)'
```

## Cidade

```dart
class Cidade {
  Cidade({
    this.id,
    required String nome,
    required this.estadoId,
    this.estadoNome,
    this.estadoSigla,
  }) : nome = nome.trim() {
    if (this.nome.isEmpty) {
      throw ArgumentError('Nome da cidade e obrigatorio.');
    }
    if (estadoId <= 0) {
      throw ArgumentError('Estado da cidade e obrigatorio.');
    }
  }

  final int? id;
  final String nome;
  final int estadoId;
  final String? estadoNome;
  final String? estadoSigla;

  factory Cidade.fromMap(Map<String, dynamic> map) { ... }
  Map<String, dynamic> toMap({bool incluirId = false}) { ... }
  String get estadoDescricao { ... }
}
```

### Por que estadoNome e estadoSigla estao em Cidade

A consulta de listagem usa JOIN:

```sql
SELECT cidade.id, cidade.nome, cidade.estado_id,
       estado.nome AS estado_nome, estado.sigla AS estado_sigla
FROM cidade
LEFT JOIN estado ON estado.id = cidade.estado_id
```

O resultado traz campos de duas tabelas.

Guardar esses campos em `Cidade` evita criar uma classe extra so para transportar o resultado da consulta. A tela usa `cidade.estadoDescricao` e pronto.

### toMap nao inclui estadoNome e estadoSigla

Porque a tabela `cidade` nao tem essas colunas.

```dart
Map<String, dynamic> toMap({bool incluirId = false}) {
  return {
    if (incluirId && id != null) 'id': id,
    'nome': nome,
    'estado_id': estadoId,
    // estadoNome e estadoSigla nao vao ao banco
  };
}
```

### estadoDescricao

```dart
String get estadoDescricao {
  final String? sigla = estadoSigla;
  if (sigla == null) return 'nao encontrado';
  return sigla;
}
```

Trata o caso em que o JOIN nao encontrou o estado (LEFT JOIN retorna null).

## Model nao e Map

O SQLite retorna dados como `Map<String, dynamic>`.

Mas o model nao deve ser pensado como um mapa com classe.

A diferenca importante e:

```text
Map  → estrutura generica retornada pelo banco
Model → objeto que representa um conceito da aplicacao
```

Por isso, a tela usa:

```dart
estado.nome
estado.sigla
estado.descricao
```

Em vez de:

```dart
estado['nome']
estado['sigla']
```

## O que aprender nesta fase

- a tela nao precisa trabalhar com `Map` o tempo todo;
- `fromMap` e `toMap` ficam no model;
- `toMap` nao inclui campos que nao existem na tabela;
- `incluirId` controla quando o id vai no mapa.

## Referencias para estudo

- Flutter - Persist data with SQLite (cookbook oficial): https://docs.flutter.dev/cookbook/persistence/sqlite
- Dart - Classes: https://dart.dev/language/classes
- Dart - Constructors: https://dart.dev/language/constructors
- Flutter - Guide to app architecture: https://docs.flutter.dev/app-architecture/guide
