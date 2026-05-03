# 01 - Visao geral do app

## Arquivo principal

Arquivo estudado:

```text
lib/fases/fase_01/app/main_fase_01.dart
```

## Entrada da fase

```dart
void main() {
  runApp(const Fase01ExecucaoIsolada());
}
```

Este `main` permite executar a fase de forma isolada.

O Flutter inicia o app chamando `runApp`, que recebe o primeiro widget da arvore.

## MaterialApp

```dart
return MaterialApp(
  title: 'Fase 01 - CRUD raiz',
  theme: ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
    useMaterial3: true,
  ),
  home: const Fase01App(),
);
```

O `MaterialApp` configura a aplicacao:

- titulo;
- tema visual;
- tela inicial em `home`.

## Tela inicial

```dart
home: const Fase01App(),
```

`Fase01App` retorna a tela `Fase01HomePage`.

Essa tela apresenta duas opcoes:

- Estados;
- Cidades.

## Navegacao para Estados

```dart
Navigator.of(context).push(
  MaterialPageRoute(builder: (_) => const EstadoListaPage()),
);
```

Quando o usuario toca em "Estados", uma nova rota e empilhada.

Essa nova rota mostra a tela de listagem de estados.

## Navegacao para Cidades

```dart
Navigator.of(context).push(
  MaterialPageRoute(builder: (_) => const CidadeListaPage()),
);
```

O mesmo acontece com "Cidades".

A tela inicial nao acessa banco de dados. Ela apenas direciona o usuario para as telas do CRUD.

## Ideia principal

Nesta fase, o fluxo comeca assim:

```text
main -> MaterialApp -> Fase01HomePage -> Lista de Estados ou Lista de Cidades
```

