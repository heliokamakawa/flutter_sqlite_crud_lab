class DatabaseSql {
  DatabaseSql._();

  static const String criarTabelaEstado = '''
    CREATE TABLE estado (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nome TEXT NOT NULL,
      sigla TEXT NOT NULL
    )
  ''';

  static const String criarTabelaCidade = '''
    CREATE TABLE cidade (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nome TEXT NOT NULL,
      estado_id INTEGER NOT NULL
    )
  ''';

  static const List<String> comandosCriacao = [
    criarTabelaEstado,
    criarTabelaCidade,
  ];

  static const List<String> comandosCargaInicial = [
    "INSERT INTO estado (nome, sigla) VALUES ('Sao Paulo', 'SP')",
    "INSERT INTO estado (nome, sigla) VALUES ('Rio de Janeiro', 'RJ')",
    "INSERT INTO estado (nome, sigla) VALUES ('Minas Gerais', 'MG')",
    "INSERT INTO cidade (nome, estado_id) VALUES ('Sao Paulo', 1)",
    "INSERT INTO cidade (nome, estado_id) VALUES ('Rio de Janeiro', 2)",
    "INSERT INTO cidade (nome, estado_id) VALUES ('Belo Horizonte', 3)",
  ];
}
