import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import '../dao/estado_dao.dart';
import '../database/database.dart';
import '../models/estado.dart';

class EstadoFormPage extends StatefulWidget {
  const EstadoFormPage({super.key, this.estado});

  final Estado? estado;

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

    final Estado? estado = widget.estado;

    if (estado != null) {
      nomeController.text = estado.nome;
      siglaController.text = estado.sigla;
    }
  }

  Future<void> inserirEstado() async {
    final Estado? estado = criarEstadoDoFormulario();

    if (estado == null) {
      return;
    }

    final Database banco = await Conexao.instancia.bancoDados;
    final EstadoDao dao = EstadoDao(banco);

    await dao.inserir(estado);

    if (!mounted) {
      return;
    }

    Navigator.of(context).pop(true);
  }

  Future<void> atualizarEstado() async {
    final Estado? estado = criarEstadoDoFormulario(id: widget.estado!.id!);

    if (estado == null) {
      return;
    }

    final Database banco = await Conexao.instancia.bancoDados;
    final EstadoDao dao = EstadoDao(banco);

    await dao.atualizar(estado);

    if (!mounted) {
      return;
    }

    Navigator.of(context).pop(true);
  }

  Estado? criarEstadoDoFormulario({int? id}) {
    final String nome = nomeController.text.trim();
    final String sigla = siglaController.text.trim().toUpperCase();

    if (nome.isEmpty || sigla.isEmpty) {
      mostrarMensagem('Informe nome e sigla.');
      return null;
    }

    try {
      return Estado(id: id, nome: nome, sigla: sigla);
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
