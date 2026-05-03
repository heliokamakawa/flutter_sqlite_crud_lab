import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

class Fase04Database {
  Fase04Database._();

  static final Fase04Database instance = Fase04Database._();

  static const String _nomeBanco = 'fase_04_associacao.db';
  static const String _nomeBancoWeb = 'fase_04_associacao_web.db';

  Database? _database;

  Future<Database> get database async {
    final Database? databaseAberto = _database;

    if (databaseAberto != null) {
      return databaseAberto;
    }

    final Database novoDatabase = await _abrirConexao();
    _database = novoDatabase;

    return novoDatabase;
  }

  Future<void> fecharConexao() async {
    await _database?.close();
    _database = null;
  }

  Future<Database> _abrirConexao() async {
    if (kIsWeb) {
      databaseFactory = databaseFactoryFfiWeb;
    }

    final String caminhoBanco = kIsWeb
        ? _nomeBancoWeb
        : p.join(await getDatabasesPath(), _nomeBanco);

    return openDatabase(
      caminhoBanco,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE estado (
            id   INTEGER PRIMARY KEY AUTOINCREMENT,
            nome TEXT NOT NULL,
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

        await db.execute("INSERT INTO estado (nome, sigla) VALUES ('Sao Paulo', 'SP')");
        await db.execute("INSERT INTO estado (nome, sigla) VALUES ('Rio de Janeiro', 'RJ')");
        await db.execute("INSERT INTO estado (nome, sigla) VALUES ('Minas Gerais', 'MG')");
        await db.execute("INSERT INTO estado (nome, sigla) VALUES ('Bahia', 'BA')");

        await db.execute("INSERT INTO cidade (nome, estado_id) VALUES ('Sao Paulo', 1)");
        await db.execute("INSERT INTO cidade (nome, estado_id) VALUES ('Campinas', 1)");
        await db.execute("INSERT INTO cidade (nome, estado_id) VALUES ('Santos', 1)");
        await db.execute("INSERT INTO cidade (nome, estado_id) VALUES ('Rio de Janeiro', 2)");
        await db.execute("INSERT INTO cidade (nome, estado_id) VALUES ('Niteroi', 2)");
        await db.execute("INSERT INTO cidade (nome, estado_id) VALUES ('Belo Horizonte', 3)");
        await db.execute("INSERT INTO cidade (nome, estado_id) VALUES ('Uberlandia', 3)");
        await db.execute("INSERT INTO cidade (nome, estado_id) VALUES ('Salvador', 4)");
      },
    );
  }
}
