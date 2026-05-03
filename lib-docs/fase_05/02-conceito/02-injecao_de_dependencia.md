# Fase 05 - Injecao de Dependencia

## O que e uma dependencia

Quando uma classe precisa de outra para funcionar, a segunda e uma dependencia da primeira.

```dart
class EstadoListaPage extends StatefulWidget {
  // EstadoListaPage depende de IEstadoRepository
}
```

A questao e: **quem cria essa dependencia?**

## Sem injecao: a classe cria suas proprias dependencias

```dart
class EstadoListaPage extends StatefulWidget {
  @override
  State<EstadoListaPage> createState() => _EstadoListaPageState();
}

class _EstadoListaPageState extends State<EstadoListaPage> {
  Future<void> listarEstados() async {
    // A tela cria tudo o que precisa
    final banco = await DatabaseHelper.instance.database;
    final dao = EstadoDao(banco);
    final repo = EstadoRepository(dao);
    final estados = await repo.listarTodos();
    // ...
  }
}
```

Problema: a tela conhece `DatabaseHelper`, `EstadoDao` e `EstadoRepository`.

Para testar a tela, voce precisa de um banco de dados real.

Para trocar `EstadoRepository` por `EstadoRepositoryApi`, voce precisa editar a tela.

A tela e dificil de isolar.

## Com injecao: a dependencia e passada de fora

```dart
class EstadoListaPage extends StatefulWidget {
  const EstadoListaPage({required this.repository});

  final IEstadoRepository repository;

  @override
  State<EstadoListaPage> createState() => _EstadoListaPageState();
}

class _EstadoListaPageState extends State<EstadoListaPage> {
  Future<void> listarEstados() async {
    final estados = await widget.repository.listarTodos();
    // ...
  }
}
```

A tela nao cria nada. Ela recebe o que precisa.

## Quem cria as dependencias?

As dependencias sao criadas na raiz da aplicacao, perto do ponto de entrada:

```dart
class Fase05HomePage extends StatelessWidget {
  Future<void> _abrirEstados(BuildContext context) async {
    final banco = await DatabaseHelper.instance.database;
    final dao = EstadoDao(banco);
    final repo = EstadoRepository(dao);
    final service = EstadoService(estadoRepository: repo, cidadeRepository: ...);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EstadoListaPage(service: service),
      ),
    );
  }
}
```

A "raiz" monta as dependencias e as passa para quem precisa.

As telas internas recebem tudo pronto. Elas nao sabem como as dependencias foram criadas.

## Por que injecao facilita testes

Sem injecao:

```dart
// Para testar EstadoListaPage, preciso de banco de dados real
final tela = EstadoListaPage(); // impossivel isolar
```

Com injecao:

```dart
// Crio um repositorio falso que nao precisa de banco
final repositorioFalso = EstadoRepositoryEmMemoria([
  Estado(id: 1, nome: 'Sao Paulo', sigla: 'SP'),
]);

// Passo para a tela — ela funciona normalmente
final tela = EstadoListaPage(repository: repositorioFalso);
```

O teste roda sem banco, sem disco, em milissegundos.

## Exemplo completo: tres cenarios com a mesma tela

```dart
// Cenario 1: app real com SQLite
final tela = EstadoListaPage(
  repository: EstadoRepository(EstadoDao(banco)),
);

// Cenario 2: teste unitario com dados em memoria
final tela = EstadoListaPage(
  repository: EstadoRepositoryEmMemoria([
    Estado(id: 1, nome: 'Sao Paulo', sigla: 'SP'),
  ]),
);

// Cenario 3: versao demo que busca de uma API
final tela = EstadoListaPage(
  repository: EstadoRepositoryApi(urlBase: 'https://api.exemplo.com'),
);
```

A tela e identica nos tres cenarios. O que muda e o que voce injeta.

## Formas de injecao

### Via construtor (usado neste projeto)

```dart
const EstadoListaPage({required this.repository});
```

Explicita: quem cria sabe o que esta passando.

Ideal para a maioria dos casos.

### Via parametro de metodo

```dart
Future<List<Estado>> buscarEstados(IEstadoRepository repository) async {
  return repository.listarTodos();
}
```

Util para funcoes isoladas (sem estado).

### Via container de injecao (Provider, Riverpod, get_it)

Frameworks de DI gerenciam o ciclo de vida das dependencias automaticamente.

O construtor manual (como neste projeto) ensina o conceito sem adicionar um framework.

Quando o projeto crescer, a transicao para um container e natural.

## Injecao de dependencia nao e um framework

E um principio: **nao crie suas dependencias, receba-as**.

O construtor manual que usamos aqui ja e injecao de dependencia.

O framework (Provider, get_it) so automatiza a criacao e o ciclo de vida.

## Referencias para estudo

- Martin Fowler - Inversion of Control: https://martinfowler.com/articles/injection.html
- Flutter - State management: https://docs.flutter.dev/data-and-backend/state-mgmt/intro
- pub.dev - get_it (container de DI): https://pub.dev/packages/get_it
- pub.dev - provider: https://pub.dev/packages/provider
