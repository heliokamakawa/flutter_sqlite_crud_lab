import 'package:flutter/material.dart';

import '../models/estado.dart';
import '../services/estado_service.dart';

class EstadoFormPage extends StatefulWidget {
  const EstadoFormPage({super.key, this.estado, required this.repository});

  final Estado? estado;
  final EstadoService repository;

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

  Future<void> salvar() async {
    final Estado? estado = _criarEstado();
    if (estado == null) return;

    if (editando) {
      await widget.repository.atualizar(estado);
    } else {
      await widget.repository.salvar(estado);
    }

    if (!mounted) return;
    Navigator.of(context).pop(true);
  }

  Estado? _criarEstado() {
    final String nome = nomeController.text.trim();
    final String sigla = siglaController.text.trim().toUpperCase();

    if (nome.isEmpty || sigla.isEmpty) {
      _mostrarMensagem('Informe nome e sigla.');
      return null;
    }

    try {
      return Estado(id: widget.estado?.id, nome: nome, sigla: sigla);
    } on ArgumentError catch (erro) {
      _mostrarMensagem(erro.message as String);
      return null;
    }
  }

  void _mostrarMensagem(String texto) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(texto)));
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
            onPressed: salvar,
            child: Text(editando ? 'Atualizar' : 'Inserir'),
          ),
        ],
      ),
    );
  }
}
