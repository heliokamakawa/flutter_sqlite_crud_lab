import 'package:flutter/material.dart';

import '../dtos/cidade_com_estado_dto.dart';
import '../models/estado.dart';
import '../repositories/i_cidade_repository.dart';
import '../repositories/i_estado_repository.dart';
import 'cidade_form.dart';

class CidadeListaPage extends StatefulWidget {
  const CidadeListaPage({
    super.key,
    required this.cidadeRepository,
    required this.estadoRepository,
  });

  final ICidadeRepository cidadeRepository;
  final IEstadoRepository estadoRepository;

  @override
  State<CidadeListaPage> createState() => _CidadeListaPageState();
}

class _CidadeListaPageState extends State<CidadeListaPage> {
  List<CidadeComEstadoDto> cidades = [];
  List<Estado> estados = [];
  Estado? estadoFiltro;

  @override
  void initState() {
    super.initState();
    _carregarEstados();
    _listarCidades();
  }

  Future<void> _carregarEstados() async {
    final List<Estado> encontrados = await widget.estadoRepository
        .listarTodos();
    if (!mounted) return;
    setState(() {
      estados = encontrados;
    });
  }

  Future<void> _listarCidades() async {
    final Estado? filtro = estadoFiltro;

    final List<CidadeComEstadoDto> encontradas = filtro == null
        ? await widget.cidadeRepository.listarTodas()
        : await widget.cidadeRepository.listarPorEstado(filtro.id!);

    if (!mounted) return;
    setState(() {
      cidades = encontradas;
    });
  }

  Future<void> _excluirCidade(int id) async {
    await widget.cidadeRepository.excluir(id);
    await _listarCidades();
  }

  Future<void> _abrirFormulario({CidadeComEstadoDto? cidadeDto}) async {
    final bool? salvou = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CidadeFormPage(
          cidade: cidadeDto?.toModel(),
          estadoRepository: widget.estadoRepository,
          cidadeRepository: widget.cidadeRepository,
        ),
      ),
    );

    if (salvou == true) {
      await _listarCidades();
    }
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
          for (final CidadeComEstadoDto cidade in cidades)
            Card(
              child: ListTile(
                title: Text(cidade.nome),
                subtitle: Text(cidade.estadoDescricao),
                trailing: Wrap(
                  spacing: 4,
                  children: [
                    IconButton(
                      tooltip: 'Alterar',
                      icon: const Icon(Icons.edit),
                      onPressed: () => _abrirFormulario(cidadeDto: cidade),
                    ),
                    IconButton(
                      tooltip: 'Excluir',
                      icon: const Icon(Icons.delete),
                      onPressed: () => _excluirCidade(cidade.id),
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
