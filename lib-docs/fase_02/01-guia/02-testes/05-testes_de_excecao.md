# Testes - Testando Excecoes

## Por que testar excecoes

Testar que o codigo lanca erro nos casos errados e tao importante quanto testar que retorna o valor certo.

Se voce remover a validacao sem querer, o teste vai avisar.

## Como testar uma excecao

Use `expect` com uma funcao anonima e um matcher de excecao:

```dart
expect(() => dividir(5, 0), throwsArgumentError);
```

Observe: o codigo que lanca a excecao fica dentro de `() =>`.

Sem isso, a excecao estoura antes do `expect` e o teste falha do jeito errado.

## Matchers de excecao

```dart
throwsArgumentError         // ArgumentError
throwsRangeError            // RangeError
throwsStateError            // StateError
throwsUnsupportedError      // UnsupportedError
throwsException             // qualquer Exception
throwsA(isA<MinhaClasse>()) // tipo especifico
```

## Exemplo completo

Codigo (`lib/calculadora.dart`):

```dart
double dividir(double a, double b) {
  if (b == 0) throw ArgumentError('Divisao por zero nao e permitida.');
  return a / b;
}

double raizQuadrada(double n) {
  if (n < 0) throw ArgumentError('Nao existe raiz de numero negativo.');
  return n; // simplificado
}
```

Teste:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:meu_projeto/calculadora.dart';

void main() {
  group('dividir', () {
    test('resultado correto', () {
      expect(dividir(10, 2), 5.0);
    });

    test('lanca ArgumentError quando denominador e zero', () {
      expect(() => dividir(5, 0), throwsArgumentError);
    });
  });

  group('raizQuadrada', () {
    test('lanca ArgumentError para numero negativo', () {
      expect(() => raizQuadrada(-4), throwsArgumentError);
    });

    test('nao lanca excecao para zero', () {
      expect(() => raizQuadrada(0), returnsNormally);
    });
  });
}
```

## Verificar a mensagem da excecao

Se quiser verificar o texto da mensagem:

```dart
test('mensagem de erro correta', () {
  expect(
    () => dividir(5, 0),
    throwsA(
      isA<ArgumentError>().having(
        (e) => e.message,
        'message',
        'Divisao por zero nao e permitida.',
      ),
    ),
  );
});
```

Use isso quando a mensagem fizer parte do contrato da funcao.
Nao exagere — verificar o tipo ja e suficiente na maioria dos casos.

## Teste assincrono com excecao

Para funcoes `async`:

```dart
test('lanca excecao assincronamente', () async {
  expect(
    () async => await buscarDados(idInvalido),
    throwsA(isA<Exception>()),
  );
});
```

Ou com `expectLater`:

```dart
test('lanca excecao assincronamente', () async {
  await expectLater(
    () => buscarDados(idInvalido),
    throwsA(isA<Exception>()),
  );
});
```

## O que nao fazer

Nao capture a excecao manualmente para testar:

```dart
// ruim
test('lanca excecao', () {
  try {
    dividir(5, 0);
    fail('deveria ter lancado excecao');
  } catch (e) {
    expect(e, isA<ArgumentError>());
  }
});
```

A versao com `throwsA` e mais curta, mais clara e mais segura.

## Referencias para estudo

- pub.dev - test matchers para excecao: https://pub.dev/packages/test
- Dart - Exceptions: https://dart.dev/language/error-handling
- Flutter - Unit testing: https://docs.flutter.dev/cookbook/testing/unit/introduction
