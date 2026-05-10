# Fase 05 - Organizacao em Camadas

## O problema que as camadas resolvem

Sem organizacao, o codigo cresce assim:

```dart
// Tela que faz tudo
class EstadoListaPage extends StatefulWidget {
  @override
  State<EstadoListaPage> createState() => _EstadoListaPageState();
}

class _EstadoListaPageState extends State<EstadoListaPage> {
  Future<void> deletarEstado(int id) async {
    // SQL direto na tela
    final banco = await Conexao.instancia.bancoDados;
    final cidades = await banco.rawQuery(
      'SELECT COUNT(*) as total FROM cidade WHERE estado_id = ?', [id],
    );
    final total = Sqflite.firstIntValue(cidades) ?? 0;

    if (total > 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Estado possui cidades.')),
      );
      return;
    }

    await banco.delete('estado', where: 'id = ?', whereArgs: [id]);
    await _carregar();
  }
}
```

Tudo misturado: SQL, regra de negocio, navegacao, mensagem ao usuario.

Com camadas, cada responsabilidade fica em seu lugar.

## As cinco camadas deste projeto

```text
┌─────────────────────────────────────────────────────┐
│                      TELA                           │
│  EstadoListaPage, CidadeListaPage, EstadoFormPage   │
│  Responsabilidade: exibir dados, capturar input      │
│  Conhece: Service e Repository (via interfaces)      │
└────────────────────┬────────────────────────────────┘
                     │ usa
┌────────────────────▼────────────────────────────────┐
│                    SERVICE                          │
│  EstadoService                                      │
│  Responsabilidade: regras que envolvem mais de      │
│  uma entidade                                       │
│  Conhece: IEstadoRepository, ICidadeRepository      │
└──────────────┬──────────────────────────────────────┘
               │ usa
┌──────────────▼──────────────────────────────────────┐
│                  REPOSITORY                         │
│  IEstadoRepository, IcidadeRepository (interfaces)  │
│  EstadoRepository, CidadeRepository (implementacoes)│
│  Responsabilidade: acesso ao dado em linguagem de   │
│  dominio (salvar, excluir, buscarPorId)             │
│  Conhece: DAO                                       │
└──────────────┬──────────────────────────────────────┘
               │ usa
┌──────────────▼──────────────────────────────────────┐
│                      DAO                            │
│  EstadoDao, CidadeDao                               │
│  Responsabilidade: SQL puro (SELECT, INSERT, etc.)  │
│  Conhece: Database (sqflite)                        │
└──────────────┬──────────────────────────────────────┘
               │ usa
┌──────────────▼──────────────────────────────────────┐
│                   DATABASE                          │
│  Conexao                                     │
│  Responsabilidade: abrir e fornecer a conexao       │
│  Conhece: sqflite                                   │
└─────────────────────────────────────────────────────┘
```

## O que cada camada conhece

A regra fundamental: **uma camada conhece apenas a camada imediatamente abaixo — e por interface, nao por implementacao**.

```text
Tela        → IEstadoRepository, IcidadeRepository, EstadoService
Service     → IEstadoRepository, ICidadeRepository
Repository  → EstadoDao, CidadeDao
DAO         → Database (sqflite)
Database    → sqflite, path
```

A Tela nao conhece `EstadoDao`.
O Service nao conhece `Conexao`.
O DAO nao conhece as regras de negocio.

## Fluxo de uma operacao: excluir estado

```text
Tela chama:
  service.excluir(id)
        │
        ▼
Service verifica:
  cidadeRepository.existePorEstado(id)  →  CidadeRepository.existePorEstado(id)
                                                  │
                                                  ▼
                                           CidadeDao.existePorEstado(id)
                                                  │
                                                  ▼
                                           SELECT COUNT(*) FROM cidade
                                           WHERE estado_id = ?
        │
        │ (se nao tem cidades)
        ▼
  estadoRepository.excluir(id)  →  EstadoRepository.excluir(id)
                                          │
                                          ▼
                                   EstadoDao.excluir(id)
                                          │
                                          ▼
                                   DELETE FROM estado
                                   WHERE id = ?
```

Cada camada faz exatamente o que e sua responsabilidade.

## Fluxo de uma operacao: listar estados

```text
Tela chama:
  repository.listarTodos()
        │
        ▼
EstadoRepository.listarTodos()
        │
        ▼
EstadoDao.buscarTodos()
        │
        ▼
SELECT * FROM estado ORDER BY nome
        │
        ▼
List<Map<String, dynamic>>
        │
        ▼
Estado.fromMap(map) — para cada linha
        │
        ▼
List<Estado> → Tela exibe
```

## Estrutura de arquivos na Fase 05

```text
lib/fases/fase_05/
├── core/
│   └── conexao.dart     ← Conexao singleton
├── models/
│   ├── estado.dart              ← entidade + fromMap/toMap
│   └── cidade.dart
├── dtos/
│   └── cidade_com_estado_dto.dart  ← resultado de JOIN
├── dao/
│   ├── estado_dao.dart          ← SQL de estado
│   └── cidade_dao.dart          ← SQL de cidade
├── repositories/
│   ├── i_estado_repository.dart ← interface (contrato)
│   ├── i_cidade_repository.dart
│   ├── estado_repository.dart   ← implementacao SQLite
│   └── cidade_repository.dart
├── services/
│   └── estado_service.dart      ← regras de negocio
└── app/
    ├── estado_lista.dart        ← tela
    ├── estado_form.dart
    ├── cidade_lista.dart
    ├── cidade_form.dart
    └── main_fase_05.dart        ← composicao das dependencias
```

A pasta reflete a arquitetura: cada pasta e uma camada.

## Onde as dependencias sao criadas

Em `main_fase_05.dart`:

```dart
class Fase05HomePage extends StatelessWidget {
  Future<void> _abrirEstados(BuildContext context) async {
    final banco = await Conexao.instancia.bancoDados;

    // Camada DAO
    final estadoDao = EstadoDao(banco);
    final cidadeDao = CidadeDao(banco);

    // Camada Repository
    final estadoRepo = EstadoRepository(estadoDao);
    final cidadeRepo = CidadeRepository(cidadeDao);

    // Camada Service
    final service = EstadoService(
      estadoRepository: estadoRepo,
      cidadeRepository: cidadeRepo,
    );

    // Tela recebe o que precisa
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
}
```

A raiz conhece tudo — ela precisa, porque e quem monta.

As telas internas nao precisam saber como foram criadas as dependencias.

## O que muda quando algo precisa mudar

### Trocar SQLite por API REST

```text
Antes:  EstadoRepository implements IEstadoRepository  (usa EstadoDao + SQLite)
Depois: EstadoRepositoryApi implements IEstadoRepository  (usa HTTP)

O que muda: apenas a implementacao do Repository
O que nao muda: Tela, Service, interface
```

### Adicionar cache

```text
class EstadoRepositoryComCache implements IEstadoRepository {
  EstadoRepositoryComCache(this._dao, this._cache);
  // logica de cache aqui
}
```

Passa `EstadoRepositoryComCache` onde antes passava `EstadoRepository`.

Nada mais muda.

### Adicionar nova regra de negocio

```text
// No EstadoService:
Future<void> excluir(int id) async {
  // regra existente
  final temCidades = await _cidadeRepository.existePorEstado(id);
  if (temCidades) throw StateError('...');

  // nova regra: logar antes de excluir
  await _logRepository.registrar('excluiu estado $id');

  await _estadoRepository.excluir(id);
}
```

A tela nao muda. Ela continua chamando `service.excluir(id)`.

## Quando NAO usar todas as camadas

Este projeto usa cinco camadas para ensinar cada conceito.

Em producao, voce decide quantas camadas fazem sentido:

```text
App simples, local, sem testes:
  Tela → DAO → SQLite  (tres camadas)

App com testes e possibilidade de troca de banco:
  Tela → Repository → DAO → SQLite  (quatro camadas)

App com regras envolvendo multiplas entidades:
  Tela → Service → Repository → DAO → SQLite  (cinco camadas)
```

Cada camada adicional resolve uma dor especifica. Se a dor nao existe, a camada e overhead.

## Resumo das responsabilidades

```text
Camada      Pergunta que ela responde
──────────  ──────────────────────────────────────────────────────
Model       Como esta entidade e estruturada? O dado e valido?
DAO         Como executar esta operacao no banco?
Repository  Como acessar este dado em linguagem de dominio?
Service     Quais regras de negocio envolvem mais de uma entidade?
Tela        Como exibir e capturar dados para o usuario?
```

Quando voce nao sabe onde colocar um codigo, responda a pergunta de cada camada.

Se a resposta cabe em mais de uma, escolha a mais especifica.

## Referencias para estudo

- Martin Fowler - Patterns of Enterprise Application Architecture: https://martinfowler.com/books/eaa.html
- Flutter - Guide to app architecture: https://docs.flutter.dev/app-architecture/guide
- Clean Architecture - Robert C. Martin: https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html
- Flutter - Separation of concerns: https://docs.flutter.dev/app-architecture/concepts#separation-of-concerns
