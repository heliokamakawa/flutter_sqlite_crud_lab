# Visao geral

Este projeto e um laboratorio didatico de persistencia local com Flutter, Dart, SQLite e `sqflite`.

A organizacao por fases permite comparar diferentes formas de estruturar o mesmo problema ao longo do tempo.

## Estrutura planejada

```text
lib/
  main.dart
  fases/
    fase_01/
    fase_02/
    fase_03/
    fase_04/
    fase_05/

lib-docs/
  visao_geral.md
  como_estudar.md
  criterios_avaliacao.md
```

## Fases implementadas agora

- Fase 01: CRUD raiz com SQL direto na tela.
- Fase 02: conexao singleton e Model.
- Fase 03: DAO para entidade simples.
- Fase 04: DAO com JOIN e DTO para resultado composto.
- Fase 05: Repository, Service e injecao de dependencia.

## Referencias

- Flutter packages: https://docs.flutter.dev/packages-and-plugins/using-packages
- Flutter - Persist data with SQLite: https://docs.flutter.dev/cookbook/persistence/sqlite
- sqflite no pub.dev: https://pub.dev/packages/sqflite
- SQLite: https://www.sqlite.org/docs.html
