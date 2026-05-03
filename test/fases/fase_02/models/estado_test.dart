import 'package:flutter_sqlite_crud_lab/fases/fase_02/models/estado.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Estado', () {
    test('representa um estado valido', () {
      final Estado estado = Estado(id: 1, nome: 'Sao Paulo', sigla: 'sp');

      expect(estado.id, 1);
      expect(estado.nome, 'Sao Paulo');
      expect(estado.sigla, 'SP');
    });

    test('remove espacos do nome e da sigla', () {
      final Estado estado = Estado(nome: '  Minas Gerais  ', sigla: ' mg ');

      expect(estado.nome, 'Minas Gerais');
      expect(estado.sigla, 'MG');
    });

    test('nao permite nome vazio', () {
      expect(
        () => Estado(nome: '   ', sigla: 'SP'),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('nao permite sigla com tamanho diferente de 2', () {
      expect(
        () => Estado(nome: 'Sao Paulo', sigla: 'SPO'),
        throwsA(isA<ArgumentError>()),
      );
    });
  });

  group('Estado.fromMap', () {
    test('cria estado a partir do mapa retornado pelo banco', () {
      final Estado estado = Estado.fromMap({
        'id': 1,
        'nome': 'Sao Paulo',
        'sigla': 'SP',
      });

      expect(estado.id, 1);
      expect(estado.nome, 'Sao Paulo');
      expect(estado.sigla, 'SP');
    });
  });

  group('Estado.toMap', () {
    test('gera mapa sem id por padrao', () {
      final Estado estado = Estado(id: 1, nome: 'Sao Paulo', sigla: 'SP');

      expect(estado.toMap(), {'nome': 'Sao Paulo', 'sigla': 'SP'});
    });

    test('gera mapa com id quando solicitado', () {
      final Estado estado = Estado(id: 1, nome: 'Sao Paulo', sigla: 'SP');

      expect(estado.toMap(incluirId: true), {
        'id': 1,
        'nome': 'Sao Paulo',
        'sigla': 'SP',
      });
    });
  });

  group('Estado.descricao', () {
    test('retorna nome e sigla formatados', () {
      final Estado estado = Estado(id: 1, nome: 'Sao Paulo', sigla: 'SP');

      expect(estado.descricao, 'Sao Paulo (SP)');
    });
  });
}
