# Fase 05 - Inversao de Dependencia

## O que e

Inversao de Dependencia (Dependency Inversion Principle — DIP) e o "D" do SOLID.

O principio diz:

```text
Modulos de alto nivel nao devem depender de modulos de baixo nivel.
Ambos devem depender de abstracoes.
```

Traduzindo para este projeto:

```text
Alto nivel:  tela (apresentacao)
Baixo nivel: EstadoRepository, EstadoDao, SQLite (infraestrutura)

Sem inversao: tela → EstadoRepository → EstadoDao → SQLite
Com inversao: tela → IEstadoRepository ← EstadoRepository → EstadoDao
```

A seta invertida na interface e a "inversao": quem define o contrato e a tela (alto nivel), nao a implementacao (baixo nivel).

## Exemplo sem inversao

```dart
// A tela conhece a implementacao concreta
class EstadoListaPage extends StatefulWidget {
  const EstadoListaPage({required this.repository});

  final EstadoRepository repository; // concreto
}
```

`EstadoListaPage` depende de `EstadoRepository` — uma classe que conhece SQLite.

Se voce quiser passar `EstadoRepositoryEmMemoria` para testes, o Dart nao aceita:

```dart
// Erro: EstadoRepositoryEmMemoria nao e EstadoRepository
EstadoListaPage(repository: EstadoRepositoryEmMemoria())
```

A tela esta acoplada a uma implementacao especifica.

## Exemplo com inversao

```dart
// A tela conhece apenas a interface (abstracao)
class EstadoListaPage extends StatefulWidget {
  const EstadoListaPage({required this.repository});

  final IEstadoRepository repository; // abstrato
}
```

Agora qualquer implementacao de `IEstadoRepository` serve:

```dart
EstadoListaPage(repository: EstadoRepository(dao))     // SQLite
EstadoListaPage(repository: EstadoRepositoryEmMemoria()) // memoria
EstadoListaPage(repository: EstadoRepositoryApi())       // API
```

A tela nao mudou. O que mudou foi o que voce passou para ela.

## A direcao das dependencias

Sem inversao:

```text
Tela → EstadoRepository → EstadoDao → SQLite
```

Cada camada conhece a de baixo diretamente.
Se o SQLite mudar, potencialmente tudo muda.

Com inversao:

```text
Tela → IEstadoRepository
              ↑
        EstadoRepository → EstadoDao → SQLite
```

A tela aponta para a interface.
A implementacao tambem aponta para a interface (ela a satisfaz).
O SQLite fica isolado do outro lado.

## Diferenca entre Inversao e Injecao

Sao complementares, nao sinonimos:

```text
Injecao de Dependencia: quem passa a dependencia (de fora, pelo construtor)
Inversao de Dependencia: o que voce passa (uma abstracao, nao uma implementacao)
```

Voce pode injetar sem inverter:

```dart
// Injeta, mas nao inverte — recebe a classe concreta
const EstadoListaPage({required EstadoRepository repository});
```

Voce inverte sem frameworks sofisticados:

```dart
// Inverte — recebe a interface
const EstadoListaPage({required IEstadoRepository repository});
```

A Fase 05 usa ambos juntos: injeta pelo construtor E usa a interface.

## Quando a inversao faz diferenca na pratica

### Cenario 1: troca de banco de dados

O app começa com SQLite. Depois precisa sincronizar com uma API REST.

Com inversao:
- cria `EstadoRepositoryApi implements IEstadoRepository`
- passa para a tela no lugar de `EstadoRepository`
- a tela nao muda

Sem inversao:
- precisa editar a tela para usar o novo repositorio.

### Cenario 2: testes automatizados

Com inversao:

```dart
// Teste rapido, sem banco, sem disco
final repo = EstadoRepositoryEmMemoria([
  Estado(id: 1, nome: 'Sao Paulo', sigla: 'SP'),
]);
final tela = EstadoListaPage(repository: repo);
// testa logica da tela aqui
```

Sem inversao:

```dart
// Precisa de banco SQLite para testar qualquer coisa na tela
```

### Cenario 3: desenvolvimento paralelo

Time A desenvolve a tela usando `IEstadoRepository` (sem implementacao real ainda).
Time B implementa `EstadoRepository` com SQLite.

Ambos trabalham em paralelo porque a interface e o contrato compartilhado.

## Em projetos pequenos

Em um CRUD simples com SQLite local, talvez a inversao seja excessiva.

O objetivo neste projeto e **aprender o conceito**, nao necessariamente aplicar em todo contexto.

Quando voce entende a inversao, consegue decidir quando ela resolve uma dor real e quando e complexidade desnecessaria.

## Referencias para estudo

- SOLID - Dependency Inversion Principle: https://en.wikipedia.org/wiki/Dependency_inversion_principle
- Martin Fowler - Inversion of Control: https://martinfowler.com/bliki/InversionOfControl.html
- Robert C. Martin - SOLID: https://blog.cleancoder.com/uncle-bob/2020/10/18/Solid-Relevance.html
- Dart - Abstract classes e interfaces: https://dart.dev/language/class-modifiers#abstract
