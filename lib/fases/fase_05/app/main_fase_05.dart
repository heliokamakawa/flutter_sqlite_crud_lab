import 'package:flutter/material.dart';

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
      title: 'Fase 05 - Helper',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        useMaterial3: true,
      ),
      home: const Fase05HomePage(),
    );
  }
}

class Fase05HomePage extends StatelessWidget {
  const Fase05HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fase 05 - Helper')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Nesta fase, o acesso ao SQLite fica centralizado no DatabaseHelper.',
          ),
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              leading: const Icon(Icons.map),
              title: const Text('Estados'),
              subtitle: const Text('Cadastrar, listar, alterar e excluir'),
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
              subtitle: const Text('Cadastro vinculado ao estado'),
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
