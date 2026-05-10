# Fase 04 - Decisao de Mapeamento

## O problema central

O SQLite armazena dados em tabelas separadas e retorna `Map<String, dynamic>`.

Quando voce faz um JOIN, o resultado mistura colunas de duas ou mais tabelas:

```sql
SELECT cidade.id, cidade.nome, cidade.estado_id,
       estado.nome AS estado_nome, estado.sigla AS estado_sigla
FROM cidade
INNER JOIN estado ON estado.id = cidade.estado_id
```

O resultado e:

```text
{ id: 1, nome: 'Sao Paulo', estado_id: 1, estado_nome: 'Sao Paulo', estado_sigla: 'SP' }
```

Esse dado nao pertence so a `Cidade`. Ele e um produto da consulta.

A decisao de mapeamento e: **qual classe representa esse resultado?**

## Opcao 1: adicionar campos opcionais ao Model

```dart
class Cidade {
  final String? estadoNome;  // opcional
  final String? estadoSigla; // opcional
}
```

Problema: `Cidade` passa a carregar dados que nao sao dela.

Se `estadoNome` nao veio do banco, e `null`. O codigo da tela precisa tratar esse caso em todo lugar.

O Model fica inflado com responsabilidades que nao sao suas.

## Opcao 2: DTO especifico para o resultado do JOIN

```dart
class CidadeComEstadoDto {
  final int id;
  final String nome;
  final int estadoId;
  final String estadoNome;  // obrigatorio — sempre vem do JOIN
  final String estadoSigla; // obrigatorio — sempre vem do JOIN
}
```

O DTO representa exatamente o resultado da consulta.

Todos os campos sao obrigatorios (nao-nulos) porque o JOIN garante que estarao presentes.

O Model `Cidade` permanece limpo, com apenas seus dados essenciais.

## Por que a Fase 04 usa o DTO

A ideia antiga seria colocar campos opcionais em `Cidade` (`String?`).

A Fase 04 usa `CidadeComEstadoDto` com campos obrigatorios (`String`).

A diferenca:

```text
Model inflado: Cidade poderia existir sem dados do estado
Fase 04: CidadeComEstadoDto sempre tem os dados do estado

Model inflado: mescla escrita e leitura na mesma classe
Fase 04: Cidade (Model) para escrita, CidadeComEstadoDto para leitura com JOIN
```

## Regra pratica

```text
Model     → representa a entidade para INSERT e UPDATE
DTO       → representa o resultado de uma consulta especifica para leitura
```

Se o dado vem de uma unica tabela: use o Model diretamente.

Se o dado vem de um JOIN: crie um DTO com nome que descreve o que a consulta retorna.

## Como o DAO usa essa separacao

```dart
class CidadeDao {
  // Leitura com JOIN → retorna DTO
  Future<List<CidadeComEstadoDto>> buscarTodos() async { ... }
  Future<List<CidadeComEstadoDto>> buscarPorEstado(int estadoId) async { ... }

  // Leitura simples (para editar) → retorna Model
  Future<Cidade?> buscarPorId(int id) async { ... }

  // Escrita → recebe Model
  Future<void> inserir(Cidade cidade) async { ... }
  Future<void> atualizar(Cidade cidade) async { ... }
  Future<void> excluir(int id) async { ... }
}
```

A separacao fica clara: consultas de exibicao usam DTO, operacoes de escrita usam Model.

## Referencias para estudo

- Martin Fowler - Data Transfer Object: https://martinfowler.com/eaaCatalog/dataTransferObject.html
- SQLite - SELECT e JOIN: https://www.sqlite.org/lang_select.html
- Flutter - Guide to app architecture: https://docs.flutter.dev/app-architecture/guide
