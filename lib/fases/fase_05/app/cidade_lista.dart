import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import '../core/database_helper.dart';
import 'cidade_form.dart';

class CidadeListaPage extends StatefulWidget {
  const CidadeListaPage({super.key});

  @override
  State<CidadeListaPage> createState() => _CidadeListaPageState();
}

class _CidadeListaPageState extends State<CidadeListaPage> {
  List<Map<String, dynamic>> cidades = [];
  List<Map<String, dynamic>> estados = [];
  int? estadoFiltroId;

  @override
  void initState() {
    super.initState();
    _carregarEstados();
    _listarCidades();
  }

  Future<void> _carregarEstados() async {
    final Database banco = await DatabaseHelper.instance.database;
    final List<Map<String, dynamic>> resultado = await banco.query(
      'estado',
      orderBy: 'nome',
    );

    if (!mounted) return;

    setState(() {
      estados = resultado;
    });
  }

  Future<void> _listarCidades() async {
    final Database banco = await DatabaseHelper.instance.database;
    final List<Map<String, dynamic>> resultado = await banco.query(
      'cidade',
      where: estadoFiltroId == null ? null : 'estado_id = ?',
      whereArgs: estadoFiltroId == null ? null : [estadoFiltroId],
      orderBy: 'nome',
    );

    if (!mounted) return;

    setState(() {
      cidades = resultado;
    });
  }

  Future<void> _excluirCidade(int id) async {
    final Database banco = await DatabaseHelper.instance.database;
    await banco.delete('cidade', where: 'id = ?', whereArgs: [id]);
    await _listarCidades();
  }

  Future<void> _abrirFormulario({Map<String, dynamic>? cidade}) async {
    final bool? salvou = await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => CidadeFormPage(cidade: cidade)));

    if (salvou == true) {
      await _carregarEstados();
      await _listarCidades();
    }
  }

  String _descricaoEstado(int estadoId) {
    for (final Map<String, dynamic> estado in estados) {
      if (estado['id'] == estadoId) {
        return '${estado['nome']} (${estado['sigla']})';
      }
    }

    return 'Estado $estadoId';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cidades')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          FilledButton.icon(
            onPressed: () => _abrirFormulario(),
            icon: const Icon(Icons.add),
            label: const Text('Cadastrar cidade'),
          ),
          const SizedBox(height: 12),
          InputDecorator(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Filtrar por estado',
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            ),
            child: DropdownButton<int?>(
              value: estadoFiltroId,
              isExpanded: true,
              underline: const SizedBox.shrink(),
              items: [
                const DropdownMenuItem<int?>(
                  value: null,
                  child: Text('Todos os estados'),
                ),
                for (final Map<String, dynamic> estado in estados)
                  DropdownMenuItem<int?>(
                    value: estado['id'] as int,
                    child: Text('${estado['nome']} (${estado['sigla']})'),
                  ),
              ],
              onChanged: (int? valor) {
                setState(() {
                  estadoFiltroId = valor;
                });
                _listarCidades();
              },
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Registros encontrados: ${cidades.length}',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          for (final Map<String, dynamic> cidade in cidades)
            Card(
              child: ListTile(
                title: Text(cidade['nome'] as String),
                subtitle: Text(_descricaoEstado(cidade['estado_id'] as int)),
                trailing: Wrap(
                  spacing: 4,
                  children: [
                    IconButton(
                      tooltip: 'Alterar',
                      icon: const Icon(Icons.edit),
                      onPressed: () => _abrirFormulario(cidade: cidade),
                    ),
                    IconButton(
                      tooltip: 'Excluir',
                      icon: const Icon(Icons.delete),
                      onPressed: () => _excluirCidade(cidade['id'] as int),
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
