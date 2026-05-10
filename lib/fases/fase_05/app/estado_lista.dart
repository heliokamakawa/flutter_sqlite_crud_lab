import 'package:flutter/material.dart';

import '../models/estado.dart';
import '../services/estado_service.dart';
import 'estado_form.dart';

// A tela recebe EstadoService pelo construtor — injecao de dependencia.
// Ela nao conhece DAO, banco ou consultas SQL.
class EstadoListaPage extends StatefulWidget {
  const EstadoListaPage({super.key, required this.service});

  final EstadoService service;

  @override
  State<EstadoListaPage> createState() => _EstadoListaPageState();
}

class _EstadoListaPageState extends State<EstadoListaPage> {
  List<Estado> estados = [];

  @override
  void initState() {
    super.initState();
    _listarEstados();
  }

  Future<void> _listarEstados() async {
    final List<Estado> encontrados = await widget.service.listarTodos();

    if (!mounted) return;

    setState(() {
      estados = encontrados;
    });
  }

  Future<void> _excluirEstado(int id) async {
    try {
      await widget.service.excluir(id);
      await _listarEstados();
    } on StateError catch (erro) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(erro.message)));
    }
  }

  Future<void> _abrirFormulario({Estado? estado}) async {
    final bool? salvou = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) =>
            EstadoFormPage(estado: estado, repository: widget.service),
      ),
    );

    if (salvou == true) {
      await _listarEstados();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Estados')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          FilledButton.icon(
            onPressed: () => _abrirFormulario(),
            icon: const Icon(Icons.add),
            label: const Text('Cadastrar estado'),
          ),
          const SizedBox(height: 16),
          Text(
            'Registros encontrados: ${estados.length}',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          for (final Estado estado in estados)
            Card(
              child: ListTile(
                title: Text(estado.descricao),
                subtitle: Text('id: ${estado.id}'),
                trailing: Wrap(
                  spacing: 4,
                  children: [
                    IconButton(
                      tooltip: 'Alterar',
                      icon: const Icon(Icons.edit),
                      onPressed: () => _abrirFormulario(estado: estado),
                    ),
                    IconButton(
                      tooltip: 'Excluir',
                      icon: const Icon(Icons.delete),
                      onPressed: estado.id == null
                          ? null
                          : () => _excluirEstado(estado.id!),
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
