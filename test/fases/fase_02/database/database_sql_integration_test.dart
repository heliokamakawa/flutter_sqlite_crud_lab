import 'package:flutter_sqlite_crud_lab/fases/fase_02/database/database_sql.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  group('DatabaseSql em execucao', () {
    setUpAll(sqfliteFfiInit);

    test('permite executar a criacao das tabelas passo a passo', () async {
      final Database banco = await databaseFactoryFfi.openDatabase(
        inMemoryDatabasePath,
      );

      addTearDown(banco.close);

      await banco.execute(DatabaseSql.criarTabelaEstado);

      expect(await _tabelaExiste(banco, 'estado'), isTrue);
      expect(await _tabelaExiste(banco, 'cidade'), isFalse);

      await banco.execute(DatabaseSql.criarTabelaCidade);

      expect(await _tabelaExiste(banco, 'cidade'), isTrue);
    });

    test('permite executar criacao e carga inicial completas', () async {
      final Database banco = await databaseFactoryFfi.openDatabase(
        inMemoryDatabasePath,
      );

      addTearDown(banco.close);

      for (final String comando in DatabaseSql.comandosCriacao) {
        await banco.execute(comando);
      }

      for (final String comando in DatabaseSql.comandosCargaInicial) {
        await banco.execute(comando);
      }

      final List<Map<String, Object?>> cidades = await banco.rawQuery(
        'SELECT nome, estado_id FROM cidade ORDER BY nome',
      );

      expect(cidades, [
        {'nome': 'Belo Horizonte', 'estado_id': 3},
        {'nome': 'Rio de Janeiro', 'estado_id': 2},
        {'nome': 'Sao Paulo', 'estado_id': 1},
      ]);
    });
  });
}

Future<bool> _tabelaExiste(Database banco, String nome) async {
  final List<Map<String, Object?>> resultado = await banco.rawQuery(
    "SELECT name FROM sqlite_master WHERE type = 'table' AND name = ?",
    [nome],
  );

  return resultado.isNotEmpty;
}
