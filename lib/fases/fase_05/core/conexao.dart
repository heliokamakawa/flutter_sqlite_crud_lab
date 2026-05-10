import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

class Conexao {
  Conexao._();

  static final Conexao instancia = Conexao._();

  static const String _nomeBanco = 'fase_05_arquitetura.db';
  static const String _nomeBancoWeb = 'fase_05_arquitetura_web.db';

  Database? _bancoDados;

  Future<Database> get bancoDados async {
    return _bancoDados ??= await _abrir();
  }

  Future<void> fechar() async {
    await _bancoDados?.close();
    _bancoDados = null;
  }

  Future<Database> _abrir() async {
    if (kIsWeb) {
      databaseFactory = databaseFactoryFfiWeb;
    }

    final String caminho = kIsWeb
        ? _nomeBancoWeb
        : p.join(await getDatabasesPath(), _nomeBanco);

    return openDatabase(
      caminho,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE estado (
            id    INTEGER PRIMARY KEY AUTOINCREMENT,
            nome  TEXT NOT NULL,
            sigla TEXT NOT NULL
          )
        ''');

        await db.execute('''
          CREATE TABLE cidade (
            id        INTEGER PRIMARY KEY AUTOINCREMENT,
            nome      TEXT NOT NULL,
            estado_id INTEGER NOT NULL
          )
        ''');

        await db.execute(
          "INSERT INTO estado (nome, sigla) VALUES ('Sao Paulo', 'SP')",
        );
        await db.execute(
          "INSERT INTO estado (nome, sigla) VALUES ('Rio de Janeiro', 'RJ')",
        );
        await db.execute(
          "INSERT INTO estado (nome, sigla) VALUES ('Minas Gerais', 'MG')",
        );
        await db.execute(
          "INSERT INTO estado (nome, sigla) VALUES ('Bahia', 'BA')",
        );

        await db.execute(
          "INSERT INTO cidade (nome, estado_id) VALUES ('Sao Paulo', 1)",
        );
        await db.execute(
          "INSERT INTO cidade (nome, estado_id) VALUES ('Campinas', 1)",
        );
        await db.execute(
          "INSERT INTO cidade (nome, estado_id) VALUES ('Rio de Janeiro', 2)",
        );
        await db.execute(
          "INSERT INTO cidade (nome, estado_id) VALUES ('Niteroi', 2)",
        );
        await db.execute(
          "INSERT INTO cidade (nome, estado_id) VALUES ('Belo Horizonte', 3)",
        );
        await db.execute(
          "INSERT INTO cidade (nome, estado_id) VALUES ('Uberlandia', 3)",
        );
        await db.execute(
          "INSERT INTO cidade (nome, estado_id) VALUES ('Salvador', 4)",
        );
      },
    );
  }
}
