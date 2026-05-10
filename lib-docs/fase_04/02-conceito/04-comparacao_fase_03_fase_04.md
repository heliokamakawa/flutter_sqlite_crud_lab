# Fase 04 - Comparacao com a Fase 03

## O que foi adicionado

```text
Fase 03: DAO para Estado (entidade simples, sem associacao)
Fase 04: DAO para Estado + DAO para Cidade (com JOIN e filtro)
         DTO para resultado composto
         DropdownButton<Estado> com == e hashCode
```

## DAO de Estado

Identico. Nenhuma mudanca necessaria — `Estado` nao tem associacao.

## DAO de Cidade — consultas de leitura

Fase 03 (sem fase de cidade):

```dart
// Fase 03 nao tinha CidadeDao
```

Fase 04:

```dart
// Leitura com JOIN — retorna DTO
Future<List<CidadeComEstadoDto>> buscarTodos() async { ... }
Future<List<CidadeComEstadoDto>> buscarPorEstado(int estadoId) async { ... }

// Leitura simples — retorna Model (para formulario de edicao)
Future<Cidade?> buscarPorId(int id) async { ... }
```

O DAO distingue claramente: consultas de exibicao retornam DTO, operacoes de escrita usam Model.

## Model Cidade

Fase 02 e Fase 04 (Model limpo):

```dart
class Cidade {
  final int? id;
  final String nome;
  final int estadoId;
  // sem campos do JOIN
}
```

O que a Fase 04 adiciona:

```dart
class CidadeComEstadoDto { ... }
```

Os dados do JOIN ficam em `CidadeComEstadoDto`.

## DTO

Alternativa ruim (campos opcionais misturados no model):

```dart
class Cidade {
  final String? estadoNome;  // pode nao existir
  final String? estadoSigla; // pode nao existir
}
```

Fase 04 (`CidadeComEstadoDto` especifico para JOIN):

```dart
class CidadeComEstadoDto {
  final String estadoNome;  // obrigatorio — JOIN garante
  final String estadoSigla; // obrigatorio — JOIN garante
}
```

O nome da classe documenta a origem dos dados.

## Formulario de cidade

Fase 03 (tipo `int` no dropdown):

```dart
int? estadoIdSelecionado;

DropdownButton<int>(value: estadoIdSelecionado, ...)
```

Fase 04 (tipo `Estado` no dropdown):

```dart
Estado? estadoSelecionado;

DropdownButton<Estado>(value: estadoSelecionado, ...)
```

Estado precisa de `==` e `hashCode` para a pre-selecao funcionar.

## Filtro na listagem

Fase 03 (sem filtro — so listava Estado):

```dart
// nao havia listagem de cidades
```

Fase 04:

```dart
final Estado? filtro = estadoFiltro;

final List<CidadeComEstadoDto> encontradas = filtro == null
    ? await dao.buscarTodos()
    : await dao.buscarPorEstado(filtro.id!);
```

A tela decide qual metodo do DAO chamar com base no estado do filtro.

## Referencias para estudo

- Oracle - Core J2EE Patterns - DAO: https://www.oracle.com/java/technologies/dataaccessobject.html
- SQLite - JOIN: https://www.sqlite.org/lang_select.html
- Martin Fowler - Data Transfer Object: https://martinfowler.com/eaaCatalog/dataTransferObject.html
- Dart - Operator overloading: https://dart.dev/language/methods#operators
