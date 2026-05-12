import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

class Conexao {
  Conexao._();

  static final Conexao instancia = Conexao._();

  static const String _nomeBanco = 'fase_04_associacao.db';
  static const String _nomeBancoWeb = 'fase_04_associacao_web.db';

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
          "INSERT INTO cidade (nome, estado_id) VALUES ('Santos', 1)",
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
      await db.execute(
        "INSERT INTO estado (nome, sigla) VALUES ('Bahia', 'BA')",
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
      'nome': 'Campinas',
      'estado_id': estadosPorSigla['SP'],
    });
    await db.insert('cidade', {
      'nome': 'Santos',
      'estado_id': estadosPorSigla['SP'],
    });
    await db.insert('cidade', {
      'nome': 'Rio de Janeiro',
      'estado_id': estadosPorSigla['RJ'],
    });
    await db.insert('cidade', {
      'nome': 'Niteroi',
      'estado_id': estadosPorSigla['RJ'],
    });
    await db.insert('cidade', {
      'nome': 'Belo Horizonte',
      'estado_id': estadosPorSigla['MG'],
    });
    await db.insert('cidade', {
      'nome': 'Uberlandia',
      'estado_id': estadosPorSigla['MG'],
    });
    await db.insert('cidade', {
      'nome': 'Salvador',
      'estado_id': estadosPorSigla['BA'],
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
