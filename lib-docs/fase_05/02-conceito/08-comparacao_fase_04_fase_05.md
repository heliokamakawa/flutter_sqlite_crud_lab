# Fase 05 - Comparacao com a Fase 04

## O que mudou

A Fase 04 introduziu DAO e separou SQL da tela.

A Fase 05 vai mais fundo: introduz interfaces, repositorios, inversao de dependencia e service.

```text
Fase 04: Tela → DAO → SQLite
Fase 05: Tela → Service/Repository → DAO → SQLite
                      ↑
              (via interfaces)
```

## Estrutura de arquivos

### Fase 04

```text
lib/fases/fase_04/
├── database/
│   └── database.dart         ← singleton local da fase
├── models/
│   ├── estado.dart
│   └── cidade.dart
├── dtos/
│   └── cidade_com_estado_dto.dart
├── dao/
│   ├── estado_dao.dart
│   └── cidade_dao.dart
└── app/
    ├── estado_lista.dart
    ├── estado_form.dart
    ├── cidade_lista.dart
    ├── cidade_form.dart
    └── main_fase_04.dart
```

### Fase 05

```text
lib/fases/fase_05/
├── core/
│   └── conexao.dart        ← renomeado e na pasta core
├── models/
│   ├── estado.dart
│   └── cidade.dart
├── dtos/
│   └── cidade_com_estado_dto.dart
├── dao/
│   ├── estado_dao.dart
│   └── cidade_dao.dart
├── repositories/               ← NOVO
│   ├── i_estado_repository.dart
│   ├── i_cidade_repository.dart
│   ├── estado_repository.dart
│   └── cidade_repository.dart
├── services/                   ← NOVO
│   └── estado_service.dart
└── app/
    ├── estado_lista.dart
    ├── estado_form.dart
    ├── cidade_lista.dart
    ├── cidade_form.dart
    └── main_fase_05.dart
```

O que e novo: `repositories/` e `services/`.

## Comparacao peca por peca

### Tela de lista de estados

#### Fase 04 — tela usa DAO diretamente

```dart
class EstadoListaPage extends StatefulWidget {
  const EstadoListaPage({required this.dao});

  final EstadoDao dao;  // conhece a implementacao concreta
}

class _EstadoListaPageState extends State<EstadoListaPage> {
  Future<void> _carregar() async {
    final lista = await widget.dao.buscarTodos();
    setState(() => _estados = lista);
  }

  Future<void> _excluir(int id) async {
    await widget.dao.excluir(id);  // sem verificacao de cidades
    await _carregar();
  }
}
```

Problemas:
- A tela conhece `EstadoDao` (implementacao concreta)
- A exclusao nao verifica cidades — quem verifica?

#### Fase 05 — tela usa Service e Repository via interfaces

```dart
class EstadoListaPage extends StatefulWidget {
  const EstadoListaPage({
    required this.service,
    required this.repository,
  });

  final EstadoService service;          // regras de negocio
  final IEstadoRepository repository;  // acesso ao dado (interface)
}

class _EstadoListaPageState extends State<EstadoListaPage> {
  Future<void> _carregar() async {
    final lista = await widget.repository.listarTodos();  // interface
    setState(() => _estados = lista);
  }

  Future<void> _excluir(int id) async {
    try {
      await widget.service.excluir(id);  // regra de negocio no service
      await _carregar();
    } on StateError catch (erro) {
      _mostrarErro(erro.message);  // tela so trata a excecao
    }
  }
}
```

O que melhorou:
- A tela conhece apenas `IEstadoRepository` (interface) — nao sabe nada de SQLite
- A regra de "verificar cidades" esta no `EstadoService`, nao na tela

### Exclusao de estado

#### Fase 04 — verificacao na tela ou ausente

```dart
// Opcao 1: sem verificacao (erro silencioso ou excecao nao tratada)
await widget.dao.excluir(id);

// Opcao 2: verificacao na tela (regra de negocio vazou para a apresentacao)
final cidades = await widget.cidadeDao.buscarPorEstado(id);
if (cidades.isNotEmpty) {
  mostrarMensagem('Estado possui cidades.');
  return;
}
await widget.estadoDao.excluir(id);
```

#### Fase 05 — regra no Service

```dart
// Na tela: chamada simples
await widget.service.excluir(id);

// No EstadoService: regra centralizada
Future<void> excluir(int id) async {
  final bool temCidades = await _cidadeRepository.existePorEstado(id);
  if (temCidades) {
    throw StateError(
      'Nao e possivel excluir um estado que possui cidades cadastradas.',
    );
  }
  await _estadoRepository.excluir(id);
}
```

A regra esta no Service. Se outra tela tambem excluir estados, ela usa o mesmo Service.

### Criacao das dependencias

#### Fase 04 — main passa DAO diretamente

```dart
Future<void> _abrirEstados(BuildContext context) async {
  final banco = await Conexao.instancia.bancoDados;
  final dao = EstadoDao(banco);

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => EstadoListaPage(dao: dao),
    ),
  );
}
```

#### Fase 05 — main monta toda a cadeia

```dart
Future<void> _abrirEstados(BuildContext context) async {
  final banco = await Conexao.instancia.bancoDados;

  final estadoDao = EstadoDao(banco);
  final cidadeDao = CidadeDao(banco);

  final estadoRepo = EstadoRepository(estadoDao);
  final cidadeRepo = CidadeRepository(cidadeDao);

  final service = EstadoService(
    estadoRepository: estadoRepo,
    cidadeRepository: cidadeRepo,
  );

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => EstadoListaPage(
        service: service,
        repository: estadoRepo,
      ),
    ),
  );
}
```

O `main` e mais verboso — mas e o unico lugar que conhece todos os detalhes de infraestrutura.

As telas sao mais limpas porque nao precisam saber como as dependencias foram criadas.

### Vocabulario

```text
Fase 04 — vocabulario do banco (DAO)    Fase 05 — vocabulario do dominio (Repository)
───────────────────────────────────     ────────────────────────────────────────────
dao.buscarTodos()                           repository.listarTodos()
dao.buscarPorId(id)                        repository.buscarPorId(id)
dao.inserir(estado)                      repository.salvar(estado)
dao.atualizar(estado)                      repository.atualizar(estado)
dao.excluir(id)                          repository.excluir(id)
```

O DAO ainda existe na Fase 05 — mas a tela nao o ve.

## O que NAO mudou

- Os modelos (`Estado`, `Cidade`) sao identicos
- O DTO (`CidadeComEstadoDto`) e identico
- O SQL dos DAOs e identico
- A logica de formulario e de dropdown e identica

As camadas mais baixas nao mudaram. O que mudou foi a organizacao das camadas de cima.

## Tabela resumo

```text
Aspecto                  Fase 04                  Fase 05
───────────────────────  ───────────────────────  ─────────────────────────────
Tela conhece             EstadoDao (concreto)      IEstadoRepository (interface)
Verificacao de cidades   Na tela ou ausente        No EstadoService
Vocabulario da tela      buscarTodos, delete           listarTodos, excluir
Regras de negocio        Dispersas                 Centralizadas no Service
Testabilidade da tela    Precisa de banco          Aceita repositorio em memoria
Camadas                  Tela → DAO → SQLite       Tela → Service → Repo → DAO → SQLite
```

## O preco da arquitetura

A Fase 05 tem mais arquivos.

```text
Fase 04: 10 arquivos Dart
Fase 05: 15 arquivos Dart
```

Cada arquivo novo tem uma razao de existir:

```text
i_estado_repository.dart   → contrato que permite inversao de dependencia
i_cidade_repository.dart   → mesmo
estado_repository.dart     → implementacao que isola o DAO da tela
cidade_repository.dart     → mesmo
estado_service.dart        → regra de exclusao centralizada
```

Em um projeto de aprendizado, isso pode parecer excessivo.

Em um projeto real, esses cinco arquivos evitam que regras de negocio se espalhem pelas telas, evitam que a troca de banco quebre a tela, e tornam o codigo testavel sem banco de dados.

## Qual fase usar em producao

Depende do tamanho e da vida esperada do projeto:

```text
Projeto pequeno, local, sem previsao de crescimento:
  Fase 03 ou Fase 04 e suficiente

Projeto que pode crescer, precisar de testes, ou mudar de banco:
  Fase 05 e o ponto de partida correto
```

O objetivo desta progressao nao e convencer que mais camadas e sempre melhor.

E ensinar o que cada camada resolve para que voce possa decidir com consciencia.

## Referencias para estudo

- Martin Fowler - Service Layer: https://martinfowler.com/eaaCatalog/serviceLayer.html
- Martin Fowler - Repository: https://martinfowler.com/eaaCatalog/repository.html
- Flutter - Guide to app architecture: https://docs.flutter.dev/app-architecture/guide
- SOLID principles: https://en.wikipedia.org/wiki/SOLID
