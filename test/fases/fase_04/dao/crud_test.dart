import 'package:flutter_sqlite_crud_lab/fases/fase_04/dao/cidade_dao.dart';
import 'package:flutter_sqlite_crud_lab/fases/fase_04/dao/estado_dao.dart';
import 'package:flutter_sqlite_crud_lab/fases/fase_04/models/cidade.dart';
import 'package:flutter_sqlite_crud_lab/fases/fase_04/models/estado.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  group('CRUD Fase 04', () {
    late Database banco;
    late EstadoDao estadoDao;
    late CidadeDao cidadeDao;

    setUpAll(sqfliteFfiInit);

    setUp(() async {
      banco = await databaseFactoryFfi.openDatabase(inMemoryDatabasePath);
      estadoDao = EstadoDao(banco);
      cidadeDao = CidadeDao(banco);

      await banco.execute('''
        CREATE TABLE estado (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          nome TEXT NOT NULL,
          sigla TEXT NOT NULL
        )
      ''');

      await banco.execute('''
        CREATE TABLE cidade (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          nome TEXT NOT NULL,
          estado_id INTEGER NOT NULL
        )
      ''');
    });

    tearDown(() async {
      await banco.close();
    });

    test('estado: inserir, buscar, atualizar e excluir', () async {
      await estadoDao.inserir(Estado(nome: 'Parana', sigla: 'PR'));

      final List<Estado> estados = await estadoDao.buscarTodos();
      expect(estados.single.nome, 'Parana');

      final Estado estado = estados.single;
      await estadoDao.atualizar(
        Estado(id: estado.id, nome: 'Santa Catarina', sigla: 'SC'),
      );

      final Estado? atualizado = await estadoDao.buscarPorId(estado.id!);
      expect(atualizado?.sigla, 'SC');

      await estadoDao.excluir(estado.id!);
      expect(await estadoDao.buscarTodos(), isEmpty);
    });

    test('cidade: inserir, buscar, atualizar e excluir', () async {
      await estadoDao.inserir(Estado(nome: 'Sao Paulo', sigla: 'SP'));
      final Estado estado = (await estadoDao.buscarTodos()).single;

      await cidadeDao.inserir(
        Cidade(nome: 'Campinas', estadoId: estado.id!),
      );

      final List<Cidade> cidades = await cidadeDao.buscarTodos();
      expect(cidades.single.nome, 'Campinas');

      final Cidade cidade = cidades.single;
      await cidadeDao.atualizar(
        Cidade(id: cidade.id, nome: 'Santos', estadoId: estado.id!),
      );

      final Cidade? atualizada = await cidadeDao.buscarPorId(cidade.id!);
      expect(atualizada?.nome, 'Santos');

      await cidadeDao.excluir(cidade.id!);
      expect(await cidadeDao.buscarTodos(), isEmpty);
    });

    test('cidade: excluir por estado', () async {
      await estadoDao.inserir(Estado(nome: 'Bahia', sigla: 'BA'));
      final Estado estado = (await estadoDao.buscarTodos()).single;

      await cidadeDao.inserir(
        Cidade(nome: 'Salvador', estadoId: estado.id!),
      );
      await cidadeDao.excluirPorEstado(estado.id!);

      expect(await cidadeDao.buscarPorEstado(estado.id!), isEmpty);
    });
  });
}
