# Testes - Sintaxe Basica

## Estrutura minima de um teste

```dart
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('descricao do que o teste verifica', () {
    // codigo do teste
  });
}
```

Tres partes:

```text
test()   → registra o teste com uma descricao
() { }   → funcao com o codigo que roda
expect() → verifica o resultado
```

## expect

`expect` compara o valor obtido com o valor esperado:

```dart
expect(valorObtido, valorEsperado);
```

Se forem iguais, o teste passa.
Se forem diferentes, o teste falha e mostra a diferenca.

## Exemplo completo

Codigo a testar (`lib/calculadora.dart`):

```dart
double somar(double a, double b) => a + b;
```

Teste (`test/calculadora_test.dart`):

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:meu_projeto/calculadora.dart';

void main() {
  test('somar dois numeros positivos', () {
    final double resultado = somar(2, 3);
    expect(resultado, 5.0);
  });
}
```

## Matchers principais

Matchers sao formas de verificar diferentes tipos de resultado.

### Igualdade

```dart
expect(somar(2, 3), 5.0);           // igual a 5.0
expect(somar(2, 3), equals(5.0));   // mesma coisa, mais explicito
```

### Booleanos

```dart
expect(resultado > 0, isTrue);
expect(resultado < 0, isFalse);
```

### Nulidade

```dart
expect(valor, isNull);
expect(valor, isNotNull);
```

### Tipo

```dart
expect(resultado, isA<double>());
expect(objeto, isA<Estado>());
```

### Listas

```dart
expect(lista, isEmpty);
expect(lista, isNotEmpty);
expect(lista, hasLength(3));
expect(lista, contains('SP'));
```

### Strings

```dart
expect(texto, contains('Paulo'));
expect(texto, startsWith('Sao'));
expect(texto, endsWith('Paulo'));
```

### Excecoes

```dart
expect(() => dividir(5, 0), throwsArgumentError);
expect(() => dividir(5, 0), throwsA(isA<ArgumentError>()));
```

## Varios expects no mesmo teste

Um teste pode ter mais de um `expect`:

```dart
test('somar retorna valor correto e tipo correto', () {
  final double resultado = somar(2, 3);

  expect(resultado, 5.0);
  expect(resultado, isA<double>());
});
```

Se o primeiro `expect` falhar, o teste para ali.
Os seguintes nao rodam.

## Por isso, cada teste deve verificar uma coisa so

Prefira:

```dart
test('somar dois positivos', () {
  expect(somar(2, 3), 5.0);
});

test('somar negativo com positivo', () {
  expect(somar(-2, 3), 1.0);
});
```

Do que um teste enorme que verifica tudo ao mesmo tempo.

## Referencias para estudo

- Flutter - flutter_test API: https://api.flutter.dev/flutter/flutter_test/flutter_test-library.html
- Dart - test package matchers: https://pub.dev/packages/test
- Flutter - Unit testing: https://docs.flutter.dev/cookbook/testing/unit/introduction