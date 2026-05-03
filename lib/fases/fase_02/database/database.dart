import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

import 'database_sql.dart';

class Fase02Database {
  Fase02Database._();

  static final Fase02Database instance = Fase02Database._();

  static const String nomeBanco = 'fase_02_model.db';
  static const String nomeBancoWeb = 'fase_02_model_web.db';

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
        ? nomeBancoWeb
        : p.join(await getDatabasesPath(), nomeBanco);

    return openDatabase(
      caminhoBanco,
      version: 1,
      onCreate: (Database db, int version) async {
        for (final String comando in DatabaseSql.comandosCriacao) {
          await db.execute(comando);
        }

        for (final String comando in DatabaseSql.comandosCargaInicial) {
          await db.execute(comando);
        }
      },
    );
  }
}
