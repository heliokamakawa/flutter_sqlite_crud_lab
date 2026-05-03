# Fase 05 - Service (Camada de Servico)

## Para que serve

O Service concentra regras de negocio que:

- envolvem mais de uma entidade ou repositorio;
- nao pertencem ao Model (que valida apenas seus proprios dados);
- nao pertencem ao DAO (que so acessa o banco);
- nao pertencem a tela (que cuida apenas da apresentacao).

## Exemplo concreto: excluir estado com cidades

A regra: **nao e permitido excluir um estado que possui cidades cadastradas**.

Onde essa regra deve morar?

### Opcao 1: na tela

```dart
// Tela verifica antes de deletar
Future<void> excluirEstado(int id) async {
  final temCidades = await cidadeRepository.existePorEstado(id);
  if (temCidades) {
    mostrarMensagem('Estado possui cidades e nao pode ser excluido.');
    return;
  }
  await estadoRepository.excluir(id);
}
```

Problema: a regra esta na tela. Se outra tela tambem excluir estados, a regra precisa ser repetida.

Se a regra mudar, voce precisa encontrar todas as telas que excluem estados e corrigir cada uma.

### Opcao 2: no Model

```dart
class Estado {
  void validarExclusao(List<Cidade> cidades) {
    if (cidades.any((c) => c.estadoId == id)) {
      throw StateError('Estado possui cidades.');
    }
  }
}
```

Problema: o Model precisaria receber uma lista de cidades para validar. Ele passa a depender de informacao externa. O Model deixa de representar apenas a entidade.

### Opcao 3: no Service

```dart
class EstadoService {
  EstadoService({
    required IEstadoRepository estadoRepository,
    required ICidadeRepository cidadeRepository,
  }) : _estadoRepository = estadoRepository,
       _cidadeRepository = cidadeRepository;

  final IEstadoRepository _estadoRepository;
  final ICidadeRepository _cidadeRepository;

  Future<void> excluir(int id) async {
    final bool temCidades = await _cidadeRepository.existePorEstado(id);

    if (temCidades) {
      throw StateError(
        'Nao e possivel excluir um estado que possui cidades cadastradas.',
      );
    }

    await _estadoRepository.excluir(id);
  }
}
```

O Service coordena dois repositorios. A regra fica em um lugar so.

A tela chama `service.excluir(id)` e trata o `StateError` se necessario:

```dart
try {
  await widget.service.excluir(id);
} on StateError catch (erro) {
  mostrarMensagem(erro.message);
}
```

## Quando usar Service

Use Service quando:

```text
A operacao envolve mais de um repositorio ou entidade
A regra precisa ser reutilizada em mais de um lugar
A logica nao cabe nem no Model nem no Repository
```

Exemplos:

```text
Excluir estado → verifica cidades → envolve CidadeRepository e EstadoRepository
Criar pedido   → reserva estoque + cria pedido + notifica cliente
Transferencia  → debita conta A + credita conta B (deve ser atomico)
```

## Quando NAO usar Service

Nao crie Service para operacoes simples que ja cabem em um metodo de repositorio:

```dart
// Desnecessario
class EstadoService {
  Future<List<Estado>> listarTodos() => _repository.listarTodos(); // so repassa
}
```

Se o Service so repassa para o repositorio sem adicionar nenhuma logica, ele e codigo extra sem beneficio.

## Service recebe interfaces, nao implementacoes

```dart
class EstadoService {
  EstadoService({
    required IEstadoRepository estadoRepository,   // interface
    required ICidadeRepository cidadeRepository,   // interface
  });
}
```

Pela mesma razao que a tela usa interfaces: o Service pode ser testado com repositorios em memoria, sem banco.

## Testando o Service

```dart
test('nao permite excluir estado com cidades', () async {
  final estadoRepo = EstadoRepositoryEmMemoria([
    Estado(id: 1, nome: 'Sao Paulo', sigla: 'SP'),
  ]);
  final cidadeRepo = CidadeRepositoryEmMemoria([
    Cidade(id: 1, nome: 'Campinas', estadoId: 1),
  ]);

  final service = EstadoService(
    estadoRepository: estadoRepo,
    cidadeRepository: cidadeRepo,
  );

  expect(
    () => service.excluir(1),
    throwsA(isA<StateError>()),
  );
});
```

O teste nao precisa de banco. A regra de negocio fica isolada e verificavel.

## Organizacao das responsabilidades

```text
Model       → validacao dos proprios dados (nome nao vazio, sigla com 2 caracteres)
DAO         → acesso ao banco (SELECT, INSERT, UPDATE, DELETE)
Repository  → interface de acesso ao dado (pode trocar implementacao)
Service     → regras que envolvem mais de uma entidade
Tela        → apresentacao e interacao com o usuario
```

Cada camada tem uma responsabilidade clara.

Quando uma responsabilidade cresce demais em uma camada, e sinal de que ela migrou para o lugar errado.

## Referencias para estudo

- Martin Fowler - Service Layer: https://martinfowler.com/eaaCatalog/serviceLayer.html
- SOLID - Single Responsibility Principle: https://en.wikipedia.org/wiki/Single-responsibility_principle
- Flutter - Guide to app architecture: https://docs.flutter.dev/app-architecture/guide
