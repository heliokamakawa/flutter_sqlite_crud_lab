import 'package:flutter/material.dart';

import 'cidade_lista.dart';
import 'estado_lista.dart';

void main() {
  runApp(const Fase01ExecucaoIsolada());
}

class Fase01ExecucaoIsolada extends StatelessWidget {
  const Fase01ExecucaoIsolada({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fase 01 - CRUD raiz',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const Fase01HomePage(),
    );
  }
}

class Fase01HomePage extends StatelessWidget {
  const Fase01HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fase 01 - CRUD raiz')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Nesta fase, o SQLite e usado diretamente nas telas, com SQL explicito e Map<String, dynamic>.',
          ),
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              leading: const Icon(Icons.map),
              title: const Text('Estados'),
              subtitle: const Text('Inserir, listar, atualizar e excluir'),
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
              subtitle: const Text('CRUD com chave estado_id'),
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
