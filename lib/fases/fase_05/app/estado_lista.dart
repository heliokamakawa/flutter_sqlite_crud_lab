import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import '../core/database_helper.dart';
import 'estado_form.dart';

class EstadoListaPage extends StatefulWidget {
  const EstadoListaPage({super.key});

  @override
  State<EstadoListaPage> createState() => _EstadoListaPageState();
}

class _EstadoListaPageState extends State<EstadoListaPage> {
  List<Map<String, dynamic>> estados = [];

  @override
  void initState() {
    super.initState();
    listarEstados();
  }

  Future<void> listarEstados() async {
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

  Future<void> excluirEstado(int id) async {
    final Database banco = await DatabaseHelper.instance.database;

    await banco.delete('cidade', where: 'estado_id = ?', whereArgs: [id]);
    await banco.delete('estado', where: 'id = ?', whereArgs: [id]);
    await listarEstados();
  }

  Future<void> abrirFormulario({Map<String, dynamic>? estado}) async {
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
          for (final Map<String, dynamic> estado in estados)
            Card(
              child: ListTile(
                title: Text('${estado['nome']} (${estado['sigla']})'),
                subtitle: Text('id: ${estado['id']}'),
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
                      onPressed: () => excluirEstado(estado['id'] as int),
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
