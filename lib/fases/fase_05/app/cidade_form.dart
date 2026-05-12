import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import '../core/database_helper.dart';

class CidadeFormPage extends StatefulWidget {
  const CidadeFormPage({super.key, this.cidade});

  final Map<String, dynamic>? cidade;

  @override
  State<CidadeFormPage> createState() => _CidadeFormPageState();
}

class _CidadeFormPageState extends State<CidadeFormPage> {
  final TextEditingController nomeController = TextEditingController();

  List<Map<String, dynamic>> estados = [];
  int? estadoSelecionadoId;

  bool get editando => widget.cidade != null;

  @override
  void initState() {
    super.initState();

    final Map<String, dynamic>? cidade = widget.cidade;
    if (cidade != null) {
      nomeController.text = cidade['nome'] as String;
      estadoSelecionadoId = cidade['estado_id'] as int;
    }

    _carregarEstados();
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

  Future<void> salvar() async {
    final String nome = nomeController.text.trim();
    final int? estadoId = estadoSelecionadoId;

    if (nome.isEmpty || estadoId == null) {
      _mostrarMensagem('Informe o nome e escolha o estado.');
      return;
    }

    final Database banco = await DatabaseHelper.instance.database;
    final Map<String, dynamic> valores = {'nome': nome, 'estado_id': estadoId};

    if (editando) {
      await banco.update(
        'cidade',
        valores,
        where: 'id = ?',
        whereArgs: [widget.cidade!['id']],
      );
    } else {
      await banco.insert('cidade', valores);
    }

    if (!mounted) return;

    Navigator.of(context).pop(true);
  }

  void _mostrarMensagem(String texto) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(texto)));
  }

  @override
  void dispose() {
    nomeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(editando ? 'Alterar cidade' : 'Cadastrar cidade'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: nomeController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Nome da cidade',
            ),
          ),
          const SizedBox(height: 8),
          InputDecorator(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Estado',
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            ),
            child: DropdownButton<int>(
              value: estadoSelecionadoId,
              isExpanded: true,
              underline: const SizedBox.shrink(),
              hint: const Text('Selecione o estado'),
              items: [
                for (final Map<String, dynamic> estado in estados)
                  DropdownMenuItem<int>(
                    value: estado['id'] as int,
                    child: Text('${estado['nome']} (${estado['sigla']})'),
                  ),
              ],
              onChanged: (int? valor) {
                setState(() {
                  estadoSelecionadoId = valor;
                });
              },
            ),
          ),
          const SizedBox(height: 8),
          FilledButton(
            onPressed: salvar,
            child: Text(editando ? 'Atualizar' : 'Inserir'),
          ),
        ],
      ),
    );
  }
}
