import 'package:flutter/material.dart';

import 'cidade_lista.dart';
import 'estado_lista.dart';

void main() {
  runApp(const Fase02ExecucaoIsolada());
}

class Fase02ExecucaoIsolada extends StatelessWidget {
  const Fase02ExecucaoIsolada({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fase 02 - Conexao singleton e Model',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const Fase02HomePage(),
    );
  }
}

class Fase02HomePage extends StatelessWidget {
  const Fase02HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fase 02 - Conexao singleton e Model')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Nesta fase, a conexao vira Singleton e os dados sao representados por Models com toMap e fromMap.',
          ),
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              leading: const Icon(Icons.map),
              title: const Text('Estados'),
              subtitle: const Text('CRUD usando Model Estado'),
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
              subtitle: const Text('Listagem com JOIN e formulario com Model'),
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

