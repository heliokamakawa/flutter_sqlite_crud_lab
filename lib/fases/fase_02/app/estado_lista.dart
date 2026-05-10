import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

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
    });
  }

  Future<void> excluirEstado(int id) async {
    final Database banco = await Conexao.instancia.bancoDados;

    await banco.delete('cidade', where: 'estado_id = ?', whereArgs: [id]);
    await banco.delete('estado', where: 'id = ?', whereArgs: [id]);

    await listarEstados();
  }

  Future<void> abrirFormularioEstado({Estado? estado}) async {
    final bool? salvou = await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => EstadoFormPage(estado: estado)));

    if (salvou == true) {
      await listarEstados();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lista de estados')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          FilledButton.icon(
            onPressed: () => abrirFormularioEstado(),
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
                title: Text('${estado.nome} (${estado.sigla})'),
                subtitle: Text('id: ${estado.id}'),
                trailing: Wrap(
                  spacing: 4,
                  children: [
                    IconButton(
                      tooltip: 'Alterar',
                      icon: const Icon(Icons.edit),
                      onPressed: () => abrirFormularioEstado(estado: estado),
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
