import 'package:sqflite/sqflite.dart';

import '../models/cidade.dart';

class CidadeDao {
  CidadeDao(this._bancoDados);

  final Database _bancoDados;

  static const String _tabela = 'cidade';

  Future<List<Cidade>> buscarTodos() async {
    final List<Map<String, dynamic>> resultado = await _bancoDados.query(
      _tabela,
      orderBy: 'nome',
    );

    return resultado.map(Cidade.fromMap).toList();
  }

  Future<List<Cidade>> buscarPorEstado(int estadoId) async {
    final List<Map<String, dynamic>> resultado = await _bancoDados.query(
      _tabela,
      where: 'estado_id = ?',
      whereArgs: [estadoId],
      orderBy: 'nome',
    );

    return resultado.map(Cidade.fromMap).toList();
  }

  Future<Cidade?> buscarPorId(int id) async {
    final List<Map<String, dynamic>> resultado = await _bancoDados.query(
      _tabela,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (resultado.isEmpty) {
      return null;
    }

    return Cidade.fromMap(resultado.first);
  }

  Future<void> inserir(Cidade cidade) async {
    await _bancoDados.insert(_tabela, cidade.toMap());
  }

  Future<void> atualizar(Cidade cidade) async {
    await _bancoDados.update(
      _tabela,
      cidade.toMap(),
      where: 'id = ?',
      whereArgs: [cidade.id],
    );
  }

  Future<void> excluir(int id) async {
    await _bancoDados.delete(_tabela, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> excluirPorEstado(int estadoId) async {
    await _bancoDados.delete(
      _tabela,
      where: 'estado_id = ?',
      whereArgs: [estadoId],
    );
  }
}
