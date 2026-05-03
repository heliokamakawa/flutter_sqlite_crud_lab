import 'package:sqflite/sqflite.dart';

import '../dtos/cidade_com_estado_dto.dart';
import '../models/cidade.dart';

class CidadeDao {
  CidadeDao(this._database);

  final Database _database;

  static const String _tabela = 'cidade';

  static const String _selectComEstado = '''
    SELECT
      cidade.id,
      cidade.nome,
      cidade.estado_id,
      estado.nome  AS estado_nome,
      estado.sigla AS estado_sigla
    FROM cidade
    INNER JOIN estado ON estado.id = cidade.estado_id
  ''';

  Future<List<CidadeComEstadoDto>> findAll() async {
    final resultado = await _database.rawQuery(
      '$_selectComEstado ORDER BY cidade.nome',
    );
    return resultado.map(CidadeComEstadoDto.fromMap).toList();
  }

  Future<List<CidadeComEstadoDto>> findByEstado(int estadoId) async {
    final resultado = await _database.rawQuery(
      '$_selectComEstado WHERE cidade.estado_id = ? ORDER BY cidade.nome',
      [estadoId],
    );
    return resultado.map(CidadeComEstadoDto.fromMap).toList();
  }

  Future<Cidade?> findById(int id) async {
    final resultado = await _database.rawQuery(
      'SELECT id, nome, estado_id FROM $_tabela WHERE id = ?',
      [id],
    );
    if (resultado.isEmpty) return null;
    return Cidade.fromMap(resultado.first);
  }

  Future<bool> existePorEstado(int estadoId) async {
    final resultado = await _database.rawQuery(
      'SELECT 1 FROM $_tabela WHERE estado_id = ? LIMIT 1',
      [estadoId],
    );
    return resultado.isNotEmpty;
  }

  Future<void> insert(Cidade cidade) async {
    await _database.insert(_tabela, cidade.toMap());
  }

  Future<void> update(Cidade cidade) async {
    await _database.update(
      _tabela,
      cidade.toMap(),
      where: 'id = ?',
      whereArgs: [cidade.id],
    );
  }

  Future<void> delete(int id) async {
    await _database.delete(_tabela, where: 'id = ?', whereArgs: [id]);
  }
}
