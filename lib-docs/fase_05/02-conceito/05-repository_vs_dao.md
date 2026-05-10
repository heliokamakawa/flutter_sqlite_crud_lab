# Fase 05 - Repository vs DAO

## A confusao comum

Repository e DAO fazem coisas parecidas: ambos acessam dados.

A diferenca e de perspectiva:

```text
DAO        → perspectiva do banco de dados
Repository → perspectiva do dominio da aplicacao
```

## DAO: perspectiva do banco

O DAO conhece o banco. Ele sabe:

- o nome da tabela (`estado`);
- os nomes das colunas;
- como montar um SELECT, INSERT, UPDATE, DELETE;
- como converter `Map` em objeto.

Metodos do DAO usam nomes do mundo do banco:

```dart
class EstadoDao {
  Future<List<Estado>> buscarTodos() async { ... }
  Future<Estado?> buscarPorId(int id) async { ... }
  Future<void> inserir(Estado estado) async { ... }
  Future<void> atualizar(Estado estado) async { ... }
  Future<void> excluir(int id) async { ... }
}
```

`buscarTodos`, `insert`, `update`, `delete` — vocabulario de banco de dados.

O DAO nao toma decisoes de negocio. Ele executa o que recebe.

## Repository: perspectiva do dominio

O Repository conhece o dominio. Ele expoe operacoes com significado para a aplicacao:

```dart
abstract class IEstadoRepository {
  Future<List<Estado>> listarTodos();
  Future<Estado?> buscarPorId(int id);
  Future<void> salvar(Estado estado);
  Future<void> atualizar(Estado estado);
  Future<void> excluir(int id);
}
```

`listarTodos`, `salvar`, `excluir` — vocabulario do negocio.

A tela nao sabe que existe um banco. Ela pede para "listar todos os estados" ou "salvar um estado".

## Exemplo comparativo lado a lado

Mesmo comportamento, vocabularios diferentes:

```dart
// DAO — fala o idioma do banco
await dao.inserir(estado);
await dao.buscarTodos();
await dao.excluir(id);

// Repository — fala o idioma do dominio
await repository.salvar(estado);
await repository.listarTodos();
await repository.excluir(id);
```

Para o resultado final do usuario, e identico.

A diferenca esta em quem le o codigo: um desenvolvedor novo entende melhor `salvar` e `listarTodos` do que `insert` e `buscarTodos`.

## Repository pode fazer mais do que DAO

O Repository pode agregar, transformar ou encapsular logica que nao pertence ao DAO.

Exemplo: um Repository que busca do cache antes de ir ao banco:

```dart
class EstadoRepository implements IEstadoRepository {
  EstadoRepository(this._dao, this._cache);

  final EstadoDao _dao;
  final EstadoCache _cache;

  @override
  Future<List<Estado>> listarTodos() async {
    final cached = _cache.obter('estados');
    if (cached != null) return cached;

    final estados = await _dao.buscarTodos();
    _cache.armazenar('estados', estados);
    return estados;
  }
}
```

A tela chama `listarTodos()`. Ela nao sabe se o dado veio do cache ou do banco.

Com o DAO direto, a tela precisaria saber dessa logica.

## Repository pode usar mais de um DAO

```dart
class RelatorioRepository implements IRelatorioRepository {
  RelatorioRepository(this._estadoDao, this._cidadeDao);

  final EstadoDao _estadoDao;
  final CidadeDao _cidadeDao;

  @override
  Future<List<EstadoComCidadesDto>> listarEstadosComCidades() async {
    final estados = await _estadoDao.buscarTodos();
    final cidades = await _cidadeDao.buscarTodos();

    // combina os dados
    return estados.map((estado) {
      final cidadesDoEstado = cidades.where((c) => c.estadoId == estado.id!);
      return EstadoComCidadesDto(estado: estado, cidades: cidadesDoEstado.toList());
    }).toList();
  }
}
```

Um Repository pode coordenar varios DAOs. Isso nao seria responsabilidade do DAO.

## Quando o Repository parece inutil

Em projetos pequenos com uma unica fonte de dados (SQLite local), o Repository e quase uma traducao de nomes:

```dart
class EstadoRepository implements IEstadoRepository {
  @override
  Future<List<Estado>> listarTodos() => _dao.buscarTodos(); // so repassa
}
```

Isso parece desnecessario.

E ai que entra a mensagem da fase: **padrao so faz sentido quando resolve uma dor real**.

Se voce nunca vai precisar trocar a implementacao, nao vai testar em isolamento e nao tem logica de cache ou composicao — talvez o DAO direto seja suficiente.

O Repository brilha quando:

- voce precisa testar a logica da tela sem banco;
- a fonte de dados pode mudar (SQLite hoje, API amanha);
- ha logica entre o banco e a tela (cache, transformacoes, composicao de DAOs).

## Resumo visual

```text
TELA
  |
  | chama (conhece apenas a interface)
  v
IEstadoRepository  ← interface (contrato)
  |
  | implementada por
  v
EstadoRepository   ← implementation (detalhe de infraestrutura)
  |
  | usa
  v
EstadoDao          ← acesso direto ao SQLite
  |
  | executa
  v
SQLite
```

## Referencias para estudo

- Martin Fowler - Repository: https://martinfowler.com/eaaCatalog/repository.html
- Martin Fowler - Table Data Gateway (DAO): https://martinfowler.com/eaaCatalog/tableDataGateway.html
- Oracle - Core J2EE Patterns - Data Access Object: https://www.oracle.com/java/technologies/dataaccessobject.html
- Flutter - Guide to app architecture: https://docs.flutter.dev/app-architecture/guide
