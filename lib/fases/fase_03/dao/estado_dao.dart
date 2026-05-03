import 'package:sqflite/sqflite.dart';

import '../models/estado.dart';

class EstadoDao {
  EstadoDao(this._database);

  final Database _database;

  static const String _tabela = 'estado';

  Future<List<Estado>> findAll() async {
    final List<Map<String, dynamic>> resultado = await _database.rawQuery(
      'SELECT id, nome, sigla FROM $_tabela ORDER BY nome',
    );

    return resultado.map(Estado.fromMap).toList();
  }

  Future<Estado?> findById(int id) async {
    final List<Map<String, dynamic>> resultado = await _database.rawQuery(
      'SELECT id, nome, sigla FROM $_tabela WHERE id = ?',
      [id],
    );

    if (resultado.isEmpty) {
      return null;
    }

    return Estado.fromMap(resultado.first);
  }

  Future<void> insert(Estado estado) async {
    await _database.insert(_tabela, estado.toMap());
  }

  Future<void> update(Estado estado) async {
    await _database.update(
      _tabela,
      estado.toMap(),
      where: 'id = ?',
      whereArgs: [estado.id],
    );
  }

  Future<void> delete(int id) async {
    await _database.delete(
      _tabela,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
