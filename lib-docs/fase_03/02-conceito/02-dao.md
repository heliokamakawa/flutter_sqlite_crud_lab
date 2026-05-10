# Fase 03 - DAO (Data Access Object)

## O que e DAO

DAO (Data Access Object) e um padrao de projeto que separa a logica de acesso ao banco de dados do restante do codigo.

A ideia e simples: uma classe cuja unica responsabilidade e conversar com o banco.

O padrao foi documentado pela Sun Microsystems em 2001 no catalogo "Core J2EE Patterns" e e uma das referencias mais citadas em arquitetura de software para acesso a dados.

## Por que usar DAO

Sem DAO, o SQL fica espalhado:

```dart
// dentro da tela
final List<Map<String, dynamic>> resultado = await banco.rawQuery(
  'SELECT id, nome, sigla FROM estado ORDER BY nome',
);
```

Com DAO, a tela chama um metodo:

```dart
// dentro da tela
final List<Estado> estados = await dao.buscarTodos();
```

A diferenca:

```text
Sem DAO → a tela sabe SQL
Com DAO → a tela sabe o que quer, nao como buscar
```

## Responsabilidade do DAO

O DAO conhece:

- o nome da tabela;
- as colunas envolvidas;
- os comandos SQL de leitura e escrita.

O DAO nao conhece:

- como os dados serao exibidos;
- qual tela esta pedindo os dados;
- regras de negocio (essas ficam no Model).

## Metodos convencionais

O padrao DAO costuma ter cinco operacoes basicas:

```text
buscarTodos()        → lista todos os registros
buscarPorId(id)     → busca um registro pelo id
inserir(entidade) → insere um novo registro
atualizar(entidade) → atualiza um registro existente
excluir(id)       → remove um registro
```

Esses nomes sao convencionais. Voce vai encontra-los com frequencia em DAOs de qualquer linguagem ou framework.

## SQL no DAO

Nesta fase, o SQL fica dentro do proprio DAO.

Nao ha um arquivo separado de SQL como havia na Fase 02 para os comandos de criacao de tabela.

O motivo: o SQL de criacao das tabelas serve ao banco, nao a uma entidade. O SQL de CRUD (SELECT, INSERT, UPDATE, DELETE) pertence diretamente ao DAO daquela entidade.

Exemplo:

```dart
class EstadoDao {
  // ...

  Future<List<Estado>> buscarTodos() async {
    final List<Map<String, dynamic>> resultado = await _bancoDados.rawQuery(
      'SELECT id, nome, sigla FROM estado ORDER BY nome',
    );
    return resultado.map(Estado.fromMap).toList();
  }
}
```

## Como o DAO recebe o banco

Nesta fase, o DAO recebe a conexao pelo construtor:

```dart
class EstadoDao {
  EstadoDao(this._bancoDados);

  final Database _bancoDados;
}
```

A tela obtém a conexao e passa para o DAO:

```dart
final Database banco = await Conexao.instancia.bancoDados;
final EstadoDao dao = EstadoDao(banco);
```

Isso permite que testes criem um banco em memoria e passem para o DAO sem precisar do app rodando.

## O que o DAO nao faz

O DAO nao valida regras de negocio.

Se o nome do estado for vazio, quem rejeita e o `Model`, nao o DAO.

O DAO recebe um `Estado` valido e persiste. Ponto.

```text
Model  → valida os dados
DAO    → acessa o banco
Tela   → coordena a interacao com o usuario
```

## Cuidado conceitual

DAO nao e Repository.

```text
DAO        → acesso direto ao banco, SQL explicito
Repository → abstrai a origem dos dados (pode ser banco, API, cache)
```

Nesta fase o padrao e DAO. O Repository aparece em fases futuras.

## Referencias para estudo

- Oracle - Core J2EE Patterns - Data Access Object: https://www.oracle.com/java/technologies/dataaccessobject.html
- Martin Fowler - Table Data Gateway (similar ao DAO): https://martinfowler.com/eaaCatalog/tableDataGateway.html
- Martin Fowler - Repository: https://martinfowler.com/eaaCatalog/repository.html
- Flutter - Guide to app architecture: https://docs.flutter.dev/app-architecture/guide
- sqflite - CRUD operations: https://pub.dev/packages/sqflite
