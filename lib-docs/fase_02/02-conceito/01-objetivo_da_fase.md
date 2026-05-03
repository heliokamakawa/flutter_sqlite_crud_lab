# Fase 02 - Objetivo

## De onde esta fase nasce

A Fase 01 mostrou o CRUD funcionando diretamente nas telas.

Isso foi importante para enxergar:

- onde o banco abre;
- onde o SQL roda;
- como os dados voltam como `Map<String, dynamic>`;
- como a lista atualiza depois de inserir, alterar ou excluir.

## Problema observado

O codigo da Fase 01 ficou repetitivo de proposito.

Cada tela conhecia detalhes demais:

- conexao com banco;
- nome do arquivo `.db`;
- criacao das tabelas;
- nomes das tabelas e colunas;
- formato dos mapas retornados pelo SQLite.

Quando muitos arquivos conhecem esses detalhes, qualquer mudanca pequena pode exigir alteracoes em varios lugares.

## Evolucao da Fase 02

A Fase 02 ainda nao pula direto para DAO ou Repository.

Ela introduz uma evolucao por vez:

- uma classe unica para abrir e reutilizar a conexao;
- um arquivo separado para guardar os comandos SQL de criacao e carga inicial;
- Models para representar os dados principais;
- testes unitarios e testes com SQLite em memoria para validar pequenos trechos.

## O que ainda fica simples

As telas ainda executam parte do SQL.

Isso e intencional. O objetivo e enxergar a evolucao sem trocar tudo ao mesmo tempo:

```text
Fase 01: tela faz tudo
Fase 02: conexao, SQL inicial e dados ganham classes
Fase 03: SQL de CRUD sai das telas
```

## Resultado esperado

Ao final da Fase 02, o aluno deve conseguir explicar:

- por que a conexao foi centralizada;
- por que o SQL de criacao ficou em outro arquivo;
- por que `Map<String, dynamic>` espalhado dificulta manutencao;
- como testes ajudam a validar a evolucao passo a passo.

## Referencias para estudo

- Flutter - Persist data with SQLite: https://docs.flutter.dev/cookbook/persistence/sqlite
- Flutter - Guide to app architecture: https://docs.flutter.dev/app-architecture/guide
- Flutter - Testing Flutter apps: https://docs.flutter.dev/testing/overview
- sqflite no pub.dev: https://pub.dev/packages/sqflite
