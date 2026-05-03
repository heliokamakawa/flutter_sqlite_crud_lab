# Fase 05 - Interfaces (Classes Abstratas)

## O que e uma interface

Uma interface e um contrato.

Ela diz **o que** uma classe deve fazer, sem dizer **como**.

Em Dart, interfaces sao criadas com `abstract class`:

```dart
abstract class IEstadoRepository {
  Future<List<Estado>> listarTodos();
  Future<Estado?> buscarPorId(int id);
  Future<void> salvar(Estado estado);
  Future<void> atualizar(Estado estado);
  Future<void> excluir(int id);
}
```

Esta classe nao tem corpo nos metodos. Ela apenas declara o contrato.

Qualquer classe que `implements IEstadoRepository` precisa fornecer todos esses metodos.

## Para que serve

### Problema sem interface

Imagine uma tela que cria seu proprio repositorio:

```dart
class EstadoListaPage extends StatefulWidget {
  // Dentro do State:
  Future<void> listarEstados() async {
    final Database banco = await DatabaseHelper.instance.database;
    final EstadoDao dao = EstadoDao(banco);
    final EstadoRepository repo = EstadoRepository(dao);
    final estados = await repo.listarTodos();
    // ...
  }
}
```

A tela conhece: `DatabaseHelper`, `EstadoDao`, `EstadoRepository`.

Para testar a tela, voce precisa de um banco de dados real.

Para trocar a fonte de dados (ex: buscar de uma API), voce precisa mexer na tela.

### Solucao com interface

```dart
class EstadoListaPage extends StatefulWidget {
  const EstadoListaPage({required this.repository});

  final IEstadoRepository repository;
}
```

A tela conhece apenas `IEstadoRepository`.

Ela nao sabe — e nao precisa saber — se os dados vem do SQLite, de uma API ou de um mapa em memoria.

## Exemplo pratico: tres implementacoes do mesmo contrato

```dart
// Contrato
abstract class IEstadoRepository {
  Future<List<Estado>> listarTodos();
}

// Implementacao real — usa o banco SQLite
class EstadoRepository implements IEstadoRepository {
  EstadoRepository(this._dao);
  final EstadoDao _dao;

  @override
  Future<List<Estado>> listarTodos() => _dao.findAll();
}

// Implementacao para testes — dados em memoria, sem banco
class EstadoRepositoryEmMemoria implements IEstadoRepository {
  final List<Estado> _dados = [
    Estado(id: 1, nome: 'Sao Paulo', sigla: 'SP'),
    Estado(id: 2, nome: 'Rio de Janeiro', sigla: 'RJ'),
  ];

  @override
  Future<List<Estado>> listarTodos() async => _dados;
}

// Implementacao que busca de uma API (futura)
class EstadoRepositoryApi implements IEstadoRepository {
  @override
  Future<List<Estado>> listarTodos() async {
    // busca da API
    return [];
  }
}
```

As tres classes implementam o mesmo contrato.

A tela nao muda. O que muda e qual implementacao voce passa para ela.

## Exemplo: testando a tela sem banco de dados

```dart
// Em um teste:
final repositorioFalso = EstadoRepositoryEmMemoria();
final tela = EstadoListaPage(repository: repositorioFalso);

// A tela funciona normalmente — ela so conhece IEstadoRepository
```

Sem a interface, o teste precisaria de um banco real. Com a interface, qualquer objeto que implemente o contrato serve.

## Interface vs Classe concreta

```text
Classe concreta: voce sabe exatamente como ela funciona
Interface:       voce sabe apenas o que ela promete fazer

Usar classe concreta: acoplamento forte — mudancas na implementacao afetam quem usa
Usar interface:       acoplamento fraco — a implementacao pode mudar sem afetar quem usa
```

## Quando usar interface

Use interface quando:

- voce quer poder trocar a implementacao (banco, API, memoria, mock para teste);
- a tela nao deve conhecer os detalhes de como os dados chegam;
- voce quer testar a logica sem depender de infra externa.

Nao use interface quando:

- ha uma unica implementacao possivel e nunca havera outra;
- o projeto e pequeno o suficiente para que o acoplamento nao cause dor.

## Convencao de nomenclatura

O prefixo `I` em `IEstadoRepository` e convencao de alguns times para indicar que e uma interface:

```text
IEstadoRepository → interface
EstadoRepository  → implementacao
```

Em Dart, algumas equipes preferem sem prefixo e com sufixo descritivo:

```text
EstadoRepository         → interface
EstadoRepositorySQLite   → implementacao
EstadoRepositoryMemoria  → implementacao para testes
```

Escolha a convencao do seu time e mantenha consistente.

## Referencias para estudo

- Dart - Abstract classes: https://dart.dev/language/class-modifiers#abstract
- Dart - Interfaces: https://dart.dev/language/classes#implicit-interfaces
- SOLID - Interface Segregation Principle: https://en.wikipedia.org/wiki/Interface_segregation_principle
- Martin Fowler - Separated Interface: https://martinfowler.com/eaaCatalog/separatedInterface.html
