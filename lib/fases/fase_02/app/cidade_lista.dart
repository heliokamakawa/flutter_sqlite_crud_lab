import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import '../database/database.dart';
import '../models/cidade.dart';
import 'cidade_form.dart';

class CidadeListaPage extends StatefulWidget {
  const CidadeListaPage({super.key});

  @override
  State<CidadeListaPage> createState() => _CidadeListaPageState();
}

class _CidadeListaPageState extends State<CidadeListaPage> {
  List<Cidade> cidades = [];

  @override
  void initState() {
    super.initState();
    listarCidades();
  }

  Future<void> listarCidades() async {
    final Database banco = await Conexao.instancia.bancoDados;

    final List<Map<String, dynamic>> resultado = await banco.query(
      'cidade',
      orderBy: 'nome',
    );

    final List<Cidade> cidadesEncontradas = resultado
        .map(Cidade.fromMap)
        .toList();

    if (!mounted) {
      return;
    }

    setState(() {
      cidades = cidadesEncontradas;
    });
  }

  Future<void> excluirCidade(int id) async {
    final Database banco = await Conexao.instancia.bancoDados;

    await banco.delete('cidade', where: 'id = ?', whereArgs: [id]);

    await listarCidades();
  }

  Future<void> abrirFormularioCidade({Cidade? cidade}) async {
    final bool? salvou = await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => CidadeFormPage(cidade: cidade)));

    if (salvou == true) {
      await listarCidades();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lista de cidades')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          FilledButton.icon(
            onPressed: () => abrirFormularioCidade(),
            icon: const Icon(Icons.add),
            label: const Text('Cadastrar cidade'),
          ),
          const SizedBox(height: 16),
          Text(
            'Registros encontrados: ${cidades.length}',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          for (final Cidade cidade in cidades)
            Card(
              child: ListTile(
                title: Text(cidade.nome),
                subtitle: Text(
                  'id: ${cidade.id} | estado_id: ${cidade.estadoId}',
                ),
                trailing: Wrap(
                  spacing: 4,
                  children: [
                    IconButton(
                      tooltip: 'Alterar',
                      icon: const Icon(Icons.edit),
                      onPressed: () => abrirFormularioCidade(cidade: cidade),
                    ),
                    IconButton(
                      tooltip: 'Excluir',
                      icon: const Icon(Icons.delete),
                      onPressed: () => excluirCidade(cidade.id!),
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
