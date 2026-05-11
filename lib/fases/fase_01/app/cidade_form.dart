import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import '../database/conexao.dart';

class CidadeFormPage extends StatefulWidget {
  const CidadeFormPage({super.key, this.cidade});

  final Map<String, dynamic>? cidade;

  @override
  State<CidadeFormPage> createState() => _CidadeFormPageState();
}

class _CidadeFormPageState extends State<CidadeFormPage> {
  final TextEditingController nomeController = TextEditingController();

  List<Map<String, dynamic>> estados = [];
  int? estadoIdSelecionado;

  bool get editando => widget.cidade != null;

  @override
  void initState() {
    super.initState();

    final Map<String, dynamic>? cidade = widget.cidade;

    if (cidade != null) {
      nomeController.text = cidade['nome'] as String;
    }

    listarEstados();
  }

  Future<void> listarEstados() async {
    final Database banco = await Conexao.instancia.bancoDados;

    final List<Map<String, dynamic>> resultado = await banco.rawQuery(
      'SELECT id, nome, sigla FROM estado ORDER BY nome',
    );

    if (!mounted) {
      return;
    }

    setState(() {
      estados = resultado;
      if (widget.cidade != null) {
        estadoIdSelecionado = widget.cidade!['estado_id'] as int;
      }
    });
  }

  Future<void> inserirCidade() async {
    final String nome = nomeController.text.trim();
    final int? estadoId = estadoIdSelecionado;

    if (nome.isEmpty || estadoId == null) {
      mostrarMensagem('Informe o nome e escolha o estado.');
      return;
    }

    final Database banco = await Conexao.instancia.bancoDados;

    await banco.rawInsert(
      'INSERT INTO cidade (nome, estado_id) VALUES (?, ?)',
      [nome, estadoId],
    );

    if (!mounted) {
      return;
    }

    Navigator.of(context).pop(true);
  }

  Future<void> atualizarCidade() async {
    final int id = widget.cidade!['id'] as int;
    final String nome = nomeController.text.trim();
    final int? estadoId = estadoIdSelecionado;

    if (nome.isEmpty || estadoId == null) {
      mostrarMensagem('Informe o nome e escolha o estado.');
      return;
    }

    final Database banco = await Conexao.instancia.bancoDados;

    await banco.rawUpdate(
      'UPDATE cidade SET nome = ?, estado_id = ? WHERE id = ?',
      [nome, estadoId, id],
    );

    if (!mounted) {
      return;
    }

    Navigator.of(context).pop(true);
  }

  void mostrarMensagem(String texto) {
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
            ),
            child: DropdownButton<int>(
              value: estadoIdSelecionado,
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
                  estadoIdSelecionado = valor;
                });
              },
            ),
          ),
          const SizedBox(height: 8),
          FilledButton(
            onPressed: editando ? atualizarCidade : inserirCidade,
            child: Text(editando ? 'Atualizar' : 'Inserir'),
          ),
        ],
      ),
    );
  }
}
