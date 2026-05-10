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
    test('cria cidade a partir do mapa da tabela cidade', () {
      final Cidade cidade = Cidade.fromMap({
        'id': 1,
        'nome': 'Sao Paulo',
        'estado_id': 10,
      });

      expect(cidade.id, 1);
      expect(cidade.nome, 'Sao Paulo');
      expect(cidade.estadoId, 10);
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
}
