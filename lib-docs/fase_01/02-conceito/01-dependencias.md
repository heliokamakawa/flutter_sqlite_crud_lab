# 01 - Dependencias

## Ideia principal

Uma dependencia e um pacote externo usado pelo projeto.

Na Fase 01, as dependencias entram para permitir que o app Flutter converse com SQLite e encontre o caminho correto do arquivo de banco.

## Pacotes usados

- `sqflite`: abre bancos SQLite e executa comandos SQL.
- `path`: monta caminhos de arquivo de forma segura entre plataformas.
- `sqflite_common_ffi_web`: permite executar SQLite no navegador usando uma implementacao baseada em WebAssembly/IndexedDB.

No `pubspec.yaml`, esses pacotes ficam em `dependencies`:

```yaml
dependencies:
  sqflite: ^2.4.1
  path: ^1.9.1
  sqflite_common_ffi_web: ^1.1.1
```

Depois de alterar o `pubspec.yaml`, execute:

```bash
flutter pub get
```

## Por que isso e necessario

O Flutter nao oferece uma API propria de SQLite pronta para uso direto no app.

Por isso, usamos pacotes externos. Depois que o pacote entra no projeto, ele pode ser importado nos arquivos Dart:

```dart
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
```

## O que observar nesta fase

Nesta fase, o foco nao e arquitetura.

O foco e entender:

- qual pacote abre o banco;
- qual pacote ajuda a montar o caminho do arquivo;
- por que a Web precisa de uma configuracao diferente;
- como uma dependencia passa a fazer parte do codigo.

## Referencias para estudo

- Flutter - Using packages: https://docs.flutter.dev/packages-and-plugins/using-packages
- Flutter - Persist data with SQLite: https://docs.flutter.dev/cookbook/persistence/sqlite
- sqflite no pub.dev: https://pub.dev/packages/sqflite
- sqflite_common_ffi_web no pub.dev: https://pub.dev/packages/sqflite_common_ffi_web
- path no pub.dev: https://pub.dev/packages/path
