import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import '../database/conexao.dart';

class EstadoFormPage extends StatefulWidget {
  const EstadoFormPage({super.key, this.estado});

  final Map<String, dynamic>? estado;

  @override
  State<EstadoFormPage> createState() => _EstadoFormPageState();
}

class _EstadoFormPageState extends State<EstadoFormPage> {
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController siglaController = TextEditingController();

  bool get editando => widget.estado != null;

  @override
  void initState() {
    super.initState();

    final Map<String, dynamic>? estado = widget.estado;

    if (estado != null) {
      nomeController.text = estado['nome'] as String;
      siglaController.text = estado['sigla'] as String;
    }
  }

  Future<void> inserirEstado() async {
    final String nome = nomeController.text.trim();
    final String sigla = siglaController.text.trim().toUpperCase();

    if (nome.isEmpty || sigla.isEmpty) {
      mostrarMensagem('Informe nome e sigla.');
      return;
    }

    final Database banco = await Conexao.instancia.bancoDados;

    await banco.rawInsert('INSERT INTO estado (nome, sigla) VALUES (?, ?)', [
      nome,
      sigla,
    ]);

    if (!mounted) {
      return;
    }

    Navigator.of(context).pop(true);
  }

  Future<void> atualizarEstado() async {
    final int id = widget.estado!['id'] as int;
    final String nome = nomeController.text.trim();
    final String sigla = siglaController.text.trim().toUpperCase();

    if (nome.isEmpty || sigla.isEmpty) {
      mostrarMensagem('Informe nome e sigla.');
      return;
    }

    final Database banco = await Conexao.instancia.bancoDados;

    await banco.rawUpdate(
      'UPDATE estado SET nome = ?, sigla = ? WHERE id = ?',
      [nome, sigla, id],
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
    siglaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(editando ? 'Alterar estado' : 'Cadastrar estado'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: nomeController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Nome do estado',
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: siglaController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Sigla',
            ),
            maxLength: 2,
            textCapitalization: TextCapitalization.characters,
          ),
          const SizedBox(height: 8),
          FilledButton(
            onPressed: editando ? atualizarEstado : inserirEstado,
            child: Text(editando ? 'Atualizar' : 'Inserir'),
          ),
        ],
      ),
    );
  }
}
