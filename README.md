# flutter_sqlite_crud_lab

Projeto didatico para estudar persistencia local com Flutter, Dart, SQLite e `sqflite`.

O projeto sera evoluido em fases. Cada fase deve ser autossuficiente para permitir comparacao entre abordagens.

## Fases disponiveis

- Fase 01: CRUD raiz com SQL direto nas telas.
- Fase 02: conexao singleton e Model.
- Fase 03: DAO para estado.
- Fase 04: DAO para estado e cidade.

## Execucao

Para abrir o menu principal:

```bash
flutter run
```

Para executar apenas a Fase 01:

```bash
flutter run -t lib/fases/fase_01/app/main_fase_01.dart
```

Para executar apenas a Fase 02:

```bash
flutter run -t lib/fases/fase_02/app/main_fase_02.dart
```

Para executar apenas a Fase 03:

```bash
flutter run -t lib/fases/fase_03/app/main_fase_03.dart
```

Para executar apenas a Fase 04:

```bash
flutter run -t lib/fases/fase_04/app/main_fase_04.dart
```

Para executar no navegador:

```bash
flutter run -d chrome
```

Na primeira configuracao Web, o projeto precisa dos arquivos `sqlite3.wasm` e `sqflite_sw.js` dentro da pasta `web/`.

## Documentacao

- `lib-docs/visao_geral.md`
- `lib-docs/como_estudar.md`
- `lib-docs/criterios_avaliacao.md`
- `lib/fases/fase_01/README.md`
- `lib/fases/fase_02/README.md`
- `lib/fases/fase_03/README.md`
- `lib/fases/fase_04/README.md`
