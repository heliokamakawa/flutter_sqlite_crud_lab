import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import '../dao/cidade_dao.dart';
import '../dao/estado_dao.dart';
import '../database/database.dart';
import '../models/cidade.dart';
import '../models/estado.dart';
import 'cidade_form.dart';

class CidadeListaPage extends StatefulWidget {
  const CidadeListaPage({super.key});

  @override
  State<CidadeListaPage> createState() => _CidadeListaPageState();
}

class _CidadeListaPageState extends State<CidadeListaPage> {
  List<Cidade> cidades = [];
  List<Estado> estados = [];
  Estado? estadoFiltro;

  @override
  void initState() {
    super.initState();
    _carregarEstados();
    _listarCidades();
  }

  Future<void> _carregarEstados() async {
    final Database banco = await Conexao.instancia.bancoDados;
    final List<Estado> encontrados = await EstadoDao(banco).buscarTodos();

    if (!mounted) return;

    setState(() {
      estados = encontrados;
    });
  }

  Future<void> _listarCidades() async {
    final Database banco = await Conexao.instancia.bancoDados;
    final CidadeDao dao = CidadeDao(banco);

    final Estado? filtro = estadoFiltro;

    final List<Cidade> encontradas = filtro == null
        ? await dao.buscarTodos()
        : await dao.buscarPorEstado(filtro.id!);

    if (!mounted) return;

    setState(() {
      cidades = encontradas;
    });
  }

  Future<void> _excluirCidade(int id) async {
    final Database banco = await Conexao.instancia.bancoDados;
    await CidadeDao(banco).excluir(id);
    await _listarCidades();
  }

  Future<void> _abrirFormulario({Cidade? cidade}) async {
    final bool? salvou = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CidadeFormPage(cidade: cidade),
      ),
    );

    if (salvou == true) {
      await _listarCidades();
    }
  }

  String _descricaoEstado(int estadoId) {
    for (final Estado estado in estados) {
      if (estado.id == estadoId) {
        return estado.descricao;
      }
    }

    return 'Estado $estadoId';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cidades')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          FilledButton.icon(
            onPressed: () => _abrirFormulario(),
            icon: const Icon(Icons.add),
            label: const Text('Cadastrar cidade'),
          ),
          const SizedBox(height: 12),
          InputDecorator(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Filtrar por estado',
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            ),
            child: DropdownButton<Estado?>(
              value: estadoFiltro,
              isExpanded: true,
              underline: const SizedBox.shrink(),
              items: [
                const DropdownMenuItem<Estado?>(
                  value: null,
                  child: Text('Todos os estados'),
                ),
                for (final Estado estado in estados)
                  DropdownMenuItem<Estado?>(
                    value: estado,
                    child: Text(estado.descricao),
                  ),
              ],
              onChanged: (Estado? valor) {
                setState(() {
                  estadoFiltro = valor;
                });
                _listarCidades();
              },
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Registros encontrados: ${cidades.length}',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          for (final Cidade cidade in cidades)
            Card(
              child: ListTile(
                title: Text(cidade.nome),
                subtitle: Text(_descricaoEstado(cidade.estadoId)),
                trailing: Wrap(
                  spacing: 4,
                  children: [
                    IconButton(
                      tooltip: 'Alterar',
                      icon: const Icon(Icons.edit),
                      onPressed: () => _abrirFormulario(cidade: cidade),
                    ),
                    IconButton(
                      tooltip: 'Excluir',
                      icon: const Icon(Icons.delete),
                      onPressed: () => _excluirCidade(cidade.id!),
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
