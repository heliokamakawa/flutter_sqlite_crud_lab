import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

class Fase03Database {
  Fase03Database._();

  static final Fase03Database instance = Fase03Database._();

  static const String _nomeBanco = 'fase_03_dao.db';
  static const String _nomeBancoWeb = 'fase_03_dao_web.db';

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
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nome TEXT NOT NULL,
            sigla TEXT NOT NULL
          )
        ''');

        await db.execute("INSERT INTO estado (nome, sigla) VALUES ('Sao Paulo', 'SP')");
        await db.execute("INSERT INTO estado (nome, sigla) VALUES ('Rio de Janeiro', 'RJ')");
        await db.execute("INSERT INTO estado (nome, sigla) VALUES ('Minas Gerais', 'MG')");
      },
    );
  }
}
