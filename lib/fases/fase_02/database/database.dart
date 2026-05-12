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
      onOpen: _garantirCargaInicial,
    );
  }

  Future<void> _garantirCargaInicial(Database db) async {
    final int totalEstados =
        Sqflite.firstIntValue(
          await db.rawQuery('SELECT COUNT(*) FROM estado'),
        ) ??
        0;

    if (totalEstados == 0) {
      await db.execute(
        "INSERT INTO estado (nome, sigla) VALUES ('Sao Paulo', 'SP')",
      );
      await db.execute(
        "INSERT INTO estado (nome, sigla) VALUES ('Rio de Janeiro', 'RJ')",
      );
      await db.execute(
        "INSERT INTO estado (nome, sigla) VALUES ('Minas Gerais', 'MG')",
      );
    }

    final int totalCidades =
        Sqflite.firstIntValue(
          await db.rawQuery('SELECT COUNT(*) FROM cidade'),
        ) ??
        0;

    if (totalCidades > 0) {
      return;
    }

    final Map<String, int> estadosPorSigla = await _buscarEstadosPorSigla(db);

    await db.insert('cidade', {
      'nome': 'Sao Paulo',
      'estado_id': estadosPorSigla['SP'],
    });
    await db.insert('cidade', {
      'nome': 'Rio de Janeiro',
      'estado_id': estadosPorSigla['RJ'],
    });
    await db.insert('cidade', {
      'nome': 'Belo Horizonte',
      'estado_id': estadosPorSigla['MG'],
    });
  }

  Future<Map<String, int>> _buscarEstadosPorSigla(Database db) async {
    final List<Map<String, dynamic>> estados = await db.query(
      'estado',
      columns: ['id', 'sigla'],
    );

    return {
      for (final Map<String, dynamic> estado in estados)
        estado['sigla'] as String: estado['id'] as int,
    };
  }
}
