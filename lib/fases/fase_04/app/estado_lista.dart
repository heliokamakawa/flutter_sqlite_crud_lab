import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import '../dao/estado_dao.dart';
import '../database/database.dart';
import '../models/estado.dart';
import 'estado_form.dart';

class EstadoListaPage extends StatefulWidget {
  const EstadoListaPage({super.key});

  @override
  State<EstadoListaPage> createState() => _EstadoListaPageState();
}

class _EstadoListaPageState extends State<EstadoListaPage> {
  List<Estado> estados = [];

  @override
  void initState() {
    super.initState();
    listarEstados();
  }

  Future<void> listarEstados() async {
    final Database banco = await Fase04Database.instance.database;
    final EstadoDao dao = EstadoDao(banco);

    final List<Estado> encontrados = await dao.findAll();

    if (!mounted) return;

    setState(() {
      estados = encontrados;
    });
  }

  Future<void> excluirEstado(int id) async {
    final Database banco = await Fase04Database.instance.database;
    final EstadoDao dao = EstadoDao(banco);

    await dao.delete(id);
    await listarEstados();
  }

  Future<void> abrirFormulario({Estado? estado}) async {
    final bool? salvou = await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => EstadoFormPage(estado: estado)),
    );

    if (salvou == true) {
      await listarEstados();
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
            onPressed: () => abrirFormulario(),
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
                      onPressed: () => abrirFormulario(estado: estado),
                    ),
                    IconButton(
                      tooltip: 'Excluir',
                      icon: const Icon(Icons.delete),
                      onPressed: estado.id == null
                          ? null
                          : () => excluirEstado(estado.id!),
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
