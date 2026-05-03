import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

import 'cidade_form.dart';

Future<Database> abrirConexaoBanco() async {
  if (kIsWeb) {
    databaseFactory = databaseFactoryFfiWeb;
  }

  final String caminhoBanco = kIsWeb
      ? 'fase_01_crud_raiz_web.db'
      : p.join(await getDatabasesPath(), 'fase_01_crud_raiz.db');

  return openDatabase(
    caminhoBanco,
    version: 1,
    onCreate: (Database db, int version) async {
      await db.execute('''
        CREATE TABLE estado (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          nome TEXT NOT NULL,
          sigla TEXT NOT NULL
        )
      ''');

      await db.execute('''
        CREATE TABLE cidade (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          nome TEXT NOT NULL,
          estado_id INTEGER NOT NULL
        )
      ''');

      await db.rawInsert('INSERT INTO estado (nome, sigla) VALUES (?, ?)', [
        'Sao Paulo',
        'SP',
      ]);
      await db.rawInsert('INSERT INTO estado (nome, sigla) VALUES (?, ?)', [
        'Rio de Janeiro',
        'RJ',
      ]);
      await db.rawInsert('INSERT INTO estado (nome, sigla) VALUES (?, ?)', [
        'Minas Gerais',
        'MG',
      ]);

      await db.rawInsert('INSERT INTO cidade (nome, estado_id) VALUES (?, ?)', [
        'Sao Paulo',
        1,
      ]);
      await db.rawInsert('INSERT INTO cidade (nome, estado_id) VALUES (?, ?)', [
        'Rio de Janeiro',
        2,
      ]);
      await db.rawInsert('INSERT INTO cidade (nome, estado_id) VALUES (?, ?)', [
        'Belo Horizonte',
        3,
      ]);
    },
  );
}

class CidadeListaPage extends StatefulWidget {
  const CidadeListaPage({super.key});

  @override
  State<CidadeListaPage> createState() => _CidadeListaPageState();
}

class _CidadeListaPageState extends State<CidadeListaPage> {
  List<Map<String, dynamic>> cidades = [];

  @override
  void initState() {
    super.initState();
    listarCidades();
  }

  Future<void> listarCidades() async {
    final Database banco = await abrirConexaoBanco();

    final List<Map<String, dynamic>> resultado = await banco.rawQuery('''
      SELECT
        cidade.id,
        cidade.nome,
        cidade.estado_id,
        estado.nome AS estado_nome,
        estado.sigla AS estado_sigla
      FROM cidade
      LEFT JOIN estado ON estado.id = cidade.estado_id
      ORDER BY cidade.nome
    ''');

    if (!mounted) {
      return;
    }

    setState(() {
      cidades = resultado;
    });
  }

  Future<void> excluirCidade(int id) async {
    final Database banco = await abrirConexaoBanco();

    await banco.rawDelete('DELETE FROM cidade WHERE id = ?', [id]);

    await listarCidades();
  }

  Future<void> abrirFormularioCidade({Map<String, dynamic>? cidade}) async {
    final bool? salvou = await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => CidadeFormPage(cidade: cidade)));

    if (salvou == true) {
      await listarCidades();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lista de cidades')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          FilledButton.icon(
            onPressed: () => abrirFormularioCidade(),
            icon: const Icon(Icons.add),
            label: const Text('Cadastrar cidade'),
          ),
          const SizedBox(height: 16),
          Text(
            'Registros encontrados: ${cidades.length}',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          for (final Map<String, dynamic> cidade in cidades)
            Card(
              child: ListTile(
                title: Text(cidade['nome'] as String),
                subtitle: Text(
                  'id: ${cidade['id']} | estado_id: ${cidade['estado_id']} | '
                  'estado: ${cidade['estado_sigla'] ?? 'nao encontrado'}',
                ),
                trailing: Wrap(
                  spacing: 4,
                  children: [
                    IconButton(
                      tooltip: 'Alterar',
                      icon: const Icon(Icons.edit),
                      onPressed: () => abrirFormularioCidade(cidade: cidade),
                    ),
                    IconButton(
                      tooltip: 'Excluir',
                      icon: const Icon(Icons.delete),
                      onPressed: () => excluirCidade(cidade['id'] as int),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
