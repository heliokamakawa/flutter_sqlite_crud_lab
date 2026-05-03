import 'package:flutter_sqlite_crud_lab/fases/fase_02/database/database_sql.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DatabaseSql', () {
    test('possui os comandos de criacao das tabelas da fase 02', () {
      expect(DatabaseSql.comandosCriacao, hasLength(2));

      expect(
        DatabaseSql.criarTabelaEstado,
        allOf(
          contains('CREATE TABLE estado'),
          contains('id INTEGER PRIMARY KEY AUTOINCREMENT'),
          contains('nome TEXT NOT NULL'),
          contains('sigla TEXT NOT NULL'),
        ),
      );

      expect(
        DatabaseSql.criarTabelaCidade,
        allOf(
          contains('CREATE TABLE cidade'),
          contains('id INTEGER PRIMARY KEY AUTOINCREMENT'),
          contains('nome TEXT NOT NULL'),
          contains('estado_id INTEGER NOT NULL'),
        ),
      );
    });

    test('possui a carga inicial de estados e cidades', () {
      expect(DatabaseSql.comandosCargaInicial, hasLength(6));

      expect(
        DatabaseSql.comandosCargaInicial,
        contains("INSERT INTO estado (nome, sigla) VALUES ('Sao Paulo', 'SP')"),
      );

      expect(
        DatabaseSql.comandosCargaInicial,
        contains(
          "INSERT INTO cidade (nome, estado_id) VALUES ('Belo Horizonte', 3)",
        ),
      );
    });
  });
}
