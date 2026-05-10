import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import 'estado_form.dart';

import '../database/conexao.dart';

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
    final Database banco = await Conexao.instancia.bancoDados;

    final List<Map<String, dynamic>> resultado = await banco.rawQuery(
      'SELECT id, nome, sigla FROM estado ORDER BY nome',
    );

    if (!mounted) {
      return;
    }

    setState(() {
      estados = resultado;
    });
  }

  Future<void> excluirEstado(int id) async {
    final Database banco = await Conexao.instancia.bancoDados;

    await banco.rawDelete('DELETE FROM cidade WHERE estado_id = ?', [id]);

    await banco.rawDelete('DELETE FROM estado WHERE id = ?', [id]);

    await listarEstados();
  }

  Future<void> abrirFormularioEstado({Map<String, dynamic>? estado}) async {
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
                      onPressed: () => abrirFormularioEstado(estado: estado),
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
