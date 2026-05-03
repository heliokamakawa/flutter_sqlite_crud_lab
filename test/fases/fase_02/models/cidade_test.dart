import 'package:flutter_sqlite_crud_lab/fases/fase_02/models/cidade.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Cidade', () {
    test('representa uma cidade valida', () {
      final Cidade cidade = Cidade(id: 1, nome: 'Belo Horizonte', estadoId: 3);

      expect(cidade.id, 1);
      expect(cidade.nome, 'Belo Horizonte');
      expect(cidade.estadoId, 3);
    });

    test('remove espacos do nome', () {
      final Cidade cidade = Cidade(nome: '  Sao Paulo  ', estadoId: 1);

      expect(cidade.nome, 'Sao Paulo');
    });

    test('nao permite nome vazio', () {
      expect(
        () => Cidade(nome: '   ', estadoId: 1),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('nao permite estadoId invalido', () {
      expect(
        () => Cidade(nome: 'Sao Paulo', estadoId: 0),
        throwsA(isA<ArgumentError>()),
      );
    });
  });

  group('Cidade.fromMap', () {
    test('cria cidade a partir do mapa retornado por consulta com JOIN', () {
      final Cidade cidade = Cidade.fromMap({
        'id': 1,
        'nome': 'Sao Paulo',
        'estado_id': 10,
        'estado_nome': 'Sao Paulo',
        'estado_sigla': 'SP',
      });

      expect(cidade.id, 1);
      expect(cidade.nome, 'Sao Paulo');
      expect(cidade.estadoId, 10);
      expect(cidade.estadoNome, 'Sao Paulo');
      expect(cidade.estadoSigla, 'SP');
    });

    test('campos de estado ficam nulos quando consulta nao usa JOIN', () {
      final Cidade cidade = Cidade.fromMap({
        'id': 1,
        'nome': 'Sao Paulo',
        'estado_id': 10,
        'estado_nome': null,
        'estado_sigla': null,
      });

      expect(cidade.estadoNome, isNull);
      expect(cidade.estadoSigla, isNull);
    });
  });

  group('Cidade.toMap', () {
    test('gera mapa sem id por padrao e sem campos de estado', () {
      final Cidade cidade = Cidade(id: 1, nome: 'Belo Horizonte', estadoId: 3);

      expect(cidade.toMap(), {'nome': 'Belo Horizonte', 'estado_id': 3});
    });

    test('gera mapa com id quando solicitado', () {
      final Cidade cidade = Cidade(id: 1, nome: 'Belo Horizonte', estadoId: 3);

      expect(cidade.toMap(incluirId: true), {
        'id': 1,
        'nome': 'Belo Horizonte',
        'estado_id': 3,
      });
    });
  });

  group('Cidade.estadoDescricao', () {
    test('retorna a sigla quando disponivel', () {
      final Cidade cidade = Cidade.fromMap({
        'id': 1,
        'nome': 'Sao Paulo',
        'estado_id': 10,
        'estado_nome': 'Sao Paulo',
        'estado_sigla': 'SP',
      });

      expect(cidade.estadoDescricao, 'SP');
    });

    test('retorna nao encontrado quando sigla for nula', () {
      final Cidade cidade = Cidade(id: 1, nome: 'Cidade sem estado', estadoId: 99);

      expect(cidade.estadoDescricao, 'nao encontrado');
    });
  });
}
