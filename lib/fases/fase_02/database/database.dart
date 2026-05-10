import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

import 'database_sql.dart';

class Conexao {
  Conexao._();

  static final Conexao instancia = Conexao._();

  static const String nomeBanco = 'fase_02_model.db';
  static const String nomeBancoWeb = 'fase_02_model_web.db';

  Database? _bancoDados;

  Future<Database> get bancoDados async {
    final Database? bancoAberto = _bancoDados;

    if (bancoAberto != null) {
      return bancoAberto;
    }

    final Database novoBanco = await _abrir();
    _bancoDados = novoBanco;

    return novoBanco;
  }

  Future<void> fechar() async {
    await _bancoDados?.close();
    _bancoDados = null;
  }

  Future<Database> _abrir() async {
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
