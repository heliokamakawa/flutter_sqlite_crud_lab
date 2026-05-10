import 'package:flutter_sqlite_crud_lab/fases/fase_02/database/database.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  group('Conexao', () {
    setUpAll(() {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    });

    setUp(() async {
      await Conexao.instancia.fechar();
      await deleteDatabase(p.join(await getDatabasesPath(), Conexao.nomeBanco));
    });

    tearDown(() async {
      await Conexao.instancia.fechar();
    });

    test('retorna a mesma conexao enquanto o banco estiver aberto', () async {
      final Database primeiraConexao = await Conexao.instancia.bancoDados;
      final Database segundaConexao = await Conexao.instancia.bancoDados;

      expect(identical(primeiraConexao, segundaConexao), isTrue);
      expect(primeiraConexao.isOpen, isTrue);
    });

    test(
      'cria as tabelas e executa a carga inicial ao abrir o banco',
      () async {
        final Database banco = await Conexao.instancia.bancoDados;

        final List<Map<String, Object?>> tabelas = await banco.rawQuery(
          "SELECT name FROM sqlite_master WHERE type = 'table' ORDER BY name",
        );

        expect(tabelas.map((Map<String, Object?> tabela) => tabela['name']), [
          'cidade',
          'estado',
          'sqlite_sequence',
        ]);

        final int totalEstados = Sqflite.firstIntValue(
          await banco.rawQuery('SELECT COUNT(*) FROM estado'),
        )!;
        final int totalCidades = Sqflite.firstIntValue(
          await banco.rawQuery('SELECT COUNT(*) FROM cidade'),
        )!;

        expect(totalEstados, 3);
        expect(totalCidades, 3);
      },
    );
  });
}
