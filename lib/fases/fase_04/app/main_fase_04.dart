import 'package:flutter/material.dart';

import 'cidade_lista.dart';
import 'estado_lista.dart';

void main() {
  runApp(const Fase04ExecucaoIsolada());
}

class Fase04ExecucaoIsolada extends StatelessWidget {
  const Fase04ExecucaoIsolada({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fase 04 - Associacao com DAO',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const Fase04App(),
    );
  }
}

class Fase04App extends StatelessWidget {
  const Fase04App({super.key});

  @override
  Widget build(BuildContext context) {
    return const Fase04HomePage();
  }
}

class Fase04HomePage extends StatelessWidget {
  const Fase04HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fase 04 - Associacao com DAO')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Banco relacional exige decisao de mapeamento. '
            'Cidades tem estado. A listagem usa JOIN. '
            'O formulario trabalha com o objeto Estado, nao apenas com o id.',
          ),
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              leading: const Icon(Icons.map),
              title: const Text('Estados'),
              subtitle: const Text('CRUD usando EstadoDao'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const EstadoListaPage()),
                );
              },
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.location_city),
              title: const Text('Cidades'),
              subtitle: const Text(
                'Listagem com JOIN, filtro por estado, DropdownButton<Estado>',
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const CidadeListaPage()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
