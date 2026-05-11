import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import '../database/database.dart';
import '../models/cidade.dart';
import '../models/estado.dart';

class CidadeFormPage extends StatefulWidget {
  const CidadeFormPage({super.key, this.cidade});

  final Cidade? cidade;

  @override
  State<CidadeFormPage> createState() => _CidadeFormPageState();
}

class _CidadeFormPageState extends State<CidadeFormPage> {
  final TextEditingController nomeController = TextEditingController();

  List<Estado> estados = [];
  Estado? estadoSelecionado;

  bool get editando => widget.cidade != null;

  @override
  void initState() {
    super.initState();

    final Cidade? cidade = widget.cidade;

    if (cidade != null) {
      nomeController.text = cidade.nome;
    }

    listarEstados();
  }

  Future<void> listarEstados() async {
    final Database banco = await Conexao.instancia.bancoDados;

    final List<Map<String, dynamic>> resultado = await banco.rawQuery(
      'SELECT id, nome, sigla FROM estado ORDER BY nome',
    );

    final List<Estado> estadosEncontrados = resultado
        .map(Estado.fromMap)
        .toList();

    if (!mounted) {
      return;
    }

    setState(() {
      estados = estadosEncontrados;
      final int? estadoId = widget.cidade?.estadoId;
      if (estadoId != null) {
        estadoSelecionado = estados
            .where((estado) => estado.id == estadoId)
            .firstOrNull;
      }
    });
  }

  Future<void> inserirCidade() async {
    final Cidade? cidade = criarCidadeDoFormulario();

    if (cidade == null) {
      return;
    }

    final Database banco = await Conexao.instancia.bancoDados;

    await banco.insert('cidade', cidade.toMap());

    if (!mounted) {
      return;
    }

    Navigator.of(context).pop(true);
  }

  Future<void> atualizarCidade() async {
    final Cidade? cidade = criarCidadeDoFormulario(id: widget.cidade!.id!);

    if (cidade == null) {
      return;
    }

    final Database banco = await Conexao.instancia.bancoDados;

    await banco.update(
      'cidade',
      cidade.toMap(),
      where: 'id = ?',
      whereArgs: [cidade.id],
    );

    if (!mounted) {
      return;
    }

    Navigator.of(context).pop(true);
  }

  Cidade? criarCidadeDoFormulario({int? id}) {
    final String nome = nomeController.text.trim();
    final Estado? estado = estadoSelecionado;

    if (nome.isEmpty || estado == null) {
      mostrarMensagem('Informe o nome e escolha o estado.');
      return null;
    }

    try {
      return Cidade(id: id, nome: nome, estadoId: estado.id!);
    } on ArgumentError catch (erro) {
      mostrarMensagem(erro.message as String);
      return null;
    }
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
            child: DropdownButton<Estado>(
              value: estadoSelecionado,
              isExpanded: true,
              underline: const SizedBox.shrink(),
              hint: const Text('Selecione o estado'),
              items: [
                for (final Estado estado in estados)
                  DropdownMenuItem<Estado>(
                    value: estado,
                    child: Text(estado.descricao),
                  ),
              ],
              onChanged: (Estado? valor) {
                setState(() {
                  estadoSelecionado = valor;
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
