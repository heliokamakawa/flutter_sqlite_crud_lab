import 'package:flutter/material.dart';

import 'fases/fase_01/app/main_fase_01.dart';
import 'fases/fase_02/app/main_fase_02.dart';
import 'fases/fase_03/app/main_fase_03.dart';
import 'fases/fase_04/app/main_fase_04.dart';
import 'fases/fase_05/app/main_fase_05.dart';

void main() {
  runApp(const MenuFasesApp());
}

class MenuFasesApp extends StatelessWidget {
  const MenuFasesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Laboratorio SQLite CRUD',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const MenuFasesPage(),
    );
  }
}

class MenuFasesPage extends StatelessWidget {
  const MenuFasesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Laboratorio SQLite CRUD')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Escolha uma fase para estudar e executar de forma isolada.',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              leading: const CircleAvatar(child: Text('01')),
              title: const Text('Fase 01'),
              subtitle: const Text('CRUD raiz com SQL direto na tela'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (_) => const Fase01App()));
              },
            ),
          ),
          Card(
            child: ListTile(
              leading: const CircleAvatar(child: Text('02')),
              title: const Text('Fase 02'),
              subtitle: const Text('Conexao singleton e Model com toMap/fromMap'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (_) => const Fase02App()));
              },
            ),
          ),
          Card(
            child: ListTile(
              leading: const CircleAvatar(child: Text('03')),
              title: const Text('Fase 03'),
              subtitle: const Text('CRUD com DAO - SQL fora da tela'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (_) => const Fase03App()));
              },
            ),
          ),
          Card(
            child: ListTile(
              leading: const CircleAvatar(child: Text('04')),
              title: const Text('Fase 04'),
              subtitle: const Text('Associacao com DAO, JOIN e DropdownButton<Estado>'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (_) => const Fase04App()));
              },
            ),
          ),
          Card(
            child: ListTile(
              leading: const CircleAvatar(child: Text('05')),
              title: const Text('Fase 05'),
              subtitle: const Text(
                'Arquitetura em camadas: Repository, Service e injecao de dependencia',
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (_) => const Fase05App()));
              },
            ),
          ),
        ],
      ),
    );
  }
}
