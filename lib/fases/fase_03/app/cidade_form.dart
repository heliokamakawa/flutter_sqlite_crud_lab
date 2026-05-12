import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import '../dao/cidade_dao.dart';
import '../dao/estado_dao.dart';
import '../database/database.dart';
import '../models/cidade.dart';
import '../models/estado.dart';

class CidadeFormPage extends StatefulWidget {
  const CidadeFormPage({super.key, this.cidade});

  final Cidade? cidade;

  @override
  State<CidadeFormPage> createState() => _CidadeFormPageState();
}

class _CidadeFormPageState extends State<CidadeFormPage> {
  final TextEditingController nomeController = TextEditingController();

  List<Estado> estados = [];
  Estado? estadoSelecionado;

  bool get editando => widget.cidade != null;

  @override
  void initState() {
    super.initState();

    if (widget.cidade != null) {
      nomeController.text = widget.cidade!.nome;
    }

    _carregarEstados();
  }

  Future<void> _carregarEstados() async {
    final Database banco = await Conexao.instancia.bancoDados;
    final List<Estado> encontrados = await EstadoDao(banco).buscarTodos();

    if (!mounted) return;

    setState(() {
      estados = encontrados;

      final int? estadoId = widget.cidade?.estadoId;
      if (estadoId != null) {
        estadoSelecionado = estados.where((e) => e.id == estadoId).firstOrNull;
      }
    });
  }

  Future<void> salvar() async {
    final Cidade? cidade = _criarCidade();

    if (cidade == null) return;

    final Database banco = await Conexao.instancia.bancoDados;
    final CidadeDao dao = CidadeDao(banco);

    if (editando) {
      await dao.atualizar(cidade);
    } else {
      await dao.inserir(cidade);
    }

    if (!mounted) return;

    Navigator.of(context).pop(true);
  }

  Cidade? _criarCidade() {
    final String nome = nomeController.text.trim();
    final Estado? estado = estadoSelecionado;

    if (nome.isEmpty || estado == null) {
      _mostrarMensagem('Informe o nome e escolha o estado.');
      return null;
    }

    try {
      return Cidade(id: widget.cidade?.id, nome: nome, estadoId: estado.id!);
    } on ArgumentError catch (erro) {
      _mostrarMensagem(erro.message as String);
      return null;
    }
  }

  void _mostrarMensagem(String texto) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(texto)));
  }

  @override
  void dispose() {
    nomeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(editando ? 'Alterar cidade' : 'Cadastrar cidade'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: nomeController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Nome da cidade',
            ),
          ),
          const SizedBox(height: 8),
          InputDecorator(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Estado',
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            ),
            child: DropdownButton<Estado>(
              value: estadoSelecionado,
              isExpanded: true,
              underline: const SizedBox.shrink(),
              hint: const Text('Selecione o estado'),
              items: [
                for (final Estado estado in estados)
                  DropdownMenuItem<Estado>(
                    value: estado,
                    child: Text(estado.descricao),
                  ),
              ],
              onChanged: (Estado? valor) {
                setState(() {
                  estadoSelecionado = valor;
                });
              },
            ),
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
