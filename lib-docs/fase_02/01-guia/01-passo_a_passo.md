# Fase 02 - Passo a Passo

## O que esta fase adiciona

- Conexao: `Conexao` (singleton)
- SQL inicial: `DatabaseSql` (arquivo separado)
- Models: `Estado` e `Cidade` com `fromMap` / `toMap`
- Testes unitarios para Model e Database

## O que abrir

### 1. Conexao singleton

Arquivo: `lib/fases/fase_02/database/database.dart`

Observe:
- construtor privado `Conexao._()`
- instancia unica `static final instancia`
- getter `bancoDados` que reaproveita a conexao ja aberta

Compare com Fase 01 (`lib/fases/fase_01/app/estado_lista.dart`):
- Fase 01: a tela tambem usa `Conexao.instancia.bancoDados`
- Fase 02: qualquer tela usa `Conexao.instancia.bancoDados`

### 2. SQL separado

Arquivo: `lib/fases/fase_02/database/database_sql.dart`

Observe:
- lista de strings com os comandos SQL de criacao das tabelas
- a conexao usa essa lista no `onCreate`
- os testes conseguem executar esses comandos passo a passo

### 3. Model Estado

Arquivo: `lib/fases/fase_02/models/estado.dart`

Observe:
- construtor valida nome nao vazio e sigla com 2 caracteres
- `fromMap` converte o `Map<String, dynamic>` do SQLite em objeto `Estado`
- `toMap` converte o objeto para o mapa esperado pelo SQLite
- `incluirId: true` controla se o campo `id` vai no mapa

### 4. Model Cidade

Arquivo: `lib/fases/fase_02/models/cidade.dart`

Observe:
- campos `id`, `nome` e `estadoId`
- `Cidade` representa somente a tabela `cidade`
- `toMap` grava apenas `nome` e `estado_id`

### 5. Tela de lista

Arquivo: `lib/fases/fase_02/app/estado_lista.dart`

Compare com `lib/fases/fase_01/app/estado_lista.dart`:
- Fase 01: `List<Map<String, dynamic>> estados`
- Fase 02: `List<Estado> estados`
- Fase 01: acesso por string `estado['nome']`
- Fase 02: acesso por propriedade `estado.nome`
