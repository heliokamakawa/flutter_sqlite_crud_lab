import 'package:flutter/material.dart';

import 'estado_lista.dart';

void main() {
  runApp(const Fase03ExecucaoIsolada());
}

class Fase03ExecucaoIsolada extends StatelessWidget {
  const Fase03ExecucaoIsolada({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fase 03 - DAO',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Fase03App(),
    );
  }
}

class Fase03App extends StatelessWidget {
  const Fase03App({super.key});

  @override
  Widget build(BuildContext context) {
    return const Fase03HomePage();
  }
}

class Fase03HomePage extends StatelessWidget {
  const Fase03HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fase 03 - DAO')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Nesta fase, o SQL sai da tela e vai para o DAO. '
            'A tela chama metodos, nao escreve SQL.',
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
        ],
      ),
    );
  }
}
