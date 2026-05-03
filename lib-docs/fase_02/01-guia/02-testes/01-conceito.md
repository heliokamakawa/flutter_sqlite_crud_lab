# Testes - Conceito

## O que e um teste automatizado

Um teste automatizado e um codigo que verifica se outro codigo funciona corretamente.

Em vez de abrir o app e clicar manualmente para conferir, voce escreve uma funcao que faz essa verificacao para voce.

Exemplo sem teste:

```text
1. abre o app
2. digita nome e sigla
3. toca em salvar
4. verifica se apareceu na lista
```

Exemplo com teste:

```dart
test('salvar estado valido funciona', () {
  final Estado estado = Estado(nome: 'Sao Paulo', sigla: 'SP');
  expect(estado.nome, 'Sao Paulo');
});
```

O teste roda em milissegundos, sem abrir nada.

## Por que testar

- voce descobre erros antes de testar manualmente;
- voce muda o codigo com mais seguranca;
- o teste documenta o comportamento esperado.

## Tipos de teste no Flutter

```text
Teste unitario    → testa uma funcao ou classe isolada
Teste de widget   → testa um widget sem rodar o app
Teste de integracao → testa fluxos completos no app real
```

Este tutorial foca em **testes unitarios**, que sao os mais simples e mais rapidos de aprender.

## Onde ficam os testes no projeto Flutter

```text
meu_projeto/
  lib/          → codigo do app
  test/         → testes automatizados
```

Os arquivos de teste terminam com `_test.dart`.

Exemplo:

```text
lib/calculadora.dart         → codigo
test/calculadora_test.dart   → teste
```

## Como rodar os testes

No terminal:

```bash
flutter test
```

Para rodar um arquivo especifico:

```bash
flutter test test/calculadora_test.dart
```

## Dependencia necessaria

O `flutter_test` ja vem no `pubspec.yaml` de todo projeto Flutter:

```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
```

Nao precisa instalar nada.

## Referencias para estudo

- Flutter - Testing Flutter apps: https://docs.flutter.dev/testing/overview
- Flutter - Unit testing introduction: https://docs.flutter.dev/cookbook/testing/unit/introduction
- Dart - Testing: https://dart.dev/guides/testing