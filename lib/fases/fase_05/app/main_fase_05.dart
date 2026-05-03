import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import '../core/database_helper.dart';
import '../dao/cidade_dao.dart';
import '../dao/estado_dao.dart';
import '../repositories/cidade_repository.dart';
import '../repositories/estado_repository.dart';
import '../services/estado_service.dart';
import 'cidade_lista.dart';
import 'estado_lista.dart';

void main() {
  runApp(const Fase05ExecucaoIsolada());
}

class Fase05ExecucaoIsolada extends StatelessWidget {
  const Fase05ExecucaoIsolada({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fase 05 - Arquitetura em camadas',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
      ),
      home: const Fase05HomePage(),
    );
  }
}

class Fase05HomePage extends StatelessWidget {
  const Fase05HomePage({super.key});

  // Composicao das dependencias feita aqui, perto da raiz.
  // As telas recebem interfaces — nao conhecem o SQLite diretamente.
  Future<_Dependencias> _criarDependencias() async {
    final Database banco = await DatabaseHelper.instance.database;

    final estadoDao = EstadoDao(banco);
    final cidadeDao = CidadeDao(banco);

    final estadoRepository = EstadoRepository(estadoDao);
    final cidadeRepository = CidadeRepository(cidadeDao);

    final estadoService = EstadoService(
      estadoRepository: estadoRepository,
      cidadeRepository: cidadeRepository,
    );

    return _Dependencias(
      estadoService: estadoService,
      estadoRepository: estadoRepository,
      cidadeRepository: cidadeRepository,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fase 05 - Arquitetura em camadas')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Padrao so faz sentido quando resolve uma dor real. '
            'Aqui as telas dependem de interfaces, nao de implementacoes. '
            'O Service aplica regras de negocio. '
            'A composicao das dependencias fica na raiz.',
          ),
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              leading: const Icon(Icons.map),
              title: const Text('Estados'),
              subtitle: const Text(
                'EstadoService impede excluir estado com cidades',
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () async {
                final deps = await _criarDependencias();
                if (!context.mounted) return;
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => EstadoListaPage(service: deps.estadoService),
                  ),
                );
              },
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.location_city),
              title: const Text('Cidades'),
              subtitle: const Text('Tela depende de ICidadeRepository'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () async {
                final deps = await _criarDependencias();
                if (!context.mounted) return;
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => CidadeListaPage(
                      cidadeRepository: deps.cidadeRepository,
                      estadoRepository: deps.estadoRepository,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _Dependencias {
  _Dependencias({
    required this.estadoService,
    required this.estadoRepository,
    required this.cidadeRepository,
  });

  final EstadoService estadoService;
  final EstadoRepository estadoRepository;
  final CidadeRepository cidadeRepository;
}
