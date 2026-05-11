# Fase 03 - Objetivo

## De onde esta fase nasce

A Fase 02 centralizou a conexao e organizou os dados em Models com `fromMap` e `toMap`.

Mas o SQL ainda estava nas telas.

A tela sabia:

- qual tabela consultar;
- como filtrar os registros;
- como montar o comando de INSERT e UPDATE.

## Problema observado

Quando a tela conhece SQL, qualquer mudanca no banco pode exigir abrir varias telas para corrigir.

Alem disso, a tela mistura duas responsabilidades distintas:

```text
apresentar dados para o usuario
saber como persistir esses dados
```

Essas duas coisas nao precisam estar juntas.

## Evolucao da Fase 03

A Fase 03 introduz o DAO (Data Access Object).

O DAO e uma classe cuja unica responsabilidade e o acesso ao banco de dados.

Ele concentra todo o SQL relativo a uma entidade.

A tela passa a chamar metodos:

```dart
dao.buscarTodos()
dao.inserir(estado)
dao.atualizar(estado)
dao.excluir(id)
```

Em vez de escrever SQL:

```dart
await banco.rawQuery('SELECT id, nome, sigla FROM estado ORDER BY nome');
await banco.insert('estado', estado.toMap());
```

## Mensagem principal

```text
A tela nao deve saber SQL.
```

## Escopo desta fase

A Fase 03 implementa o DAO para a entidade `Estado`, que nao tem associacao com outras tabelas.

Isso mantem o exemplo simples para que o foco fique na separacao de responsabilidades, nao na complexidade do modelo.

## O que ainda fica simples

A tela ainda conhece o DAO diretamente.

As proximas fases continuam usando DAO, agora com mais entidades.

Evolucao planejada:

```text
Fase 02: tela chama banco diretamente, mas usa Models
Fase 03: SQL sai da tela e vai para o DAO
Fase 04: outro DAO aparece para a entidade Cidade
```

## Resultado esperado

Ao final da Fase 03, o aluno deve conseguir explicar:

- por que o SQL nao pertence a tela;
- o que e um DAO e qual e sua responsabilidade;
- como os metodos `buscarTodos`, `buscarPorId`, `insert`, `update` e `delete` organizam o acesso ao banco;
- como a tela fica mais simples quando nao sabe SQL.

## Referencias para estudo

- Oracle - Core J2EE Patterns - Data Access Object: https://www.oracle.com/java/technologies/dataaccessobject.html
- Flutter - Guide to app architecture: https://docs.flutter.dev/app-architecture/guide
- Flutter - Persist data with SQLite: https://docs.flutter.dev/cookbook/persistence/sqlite
