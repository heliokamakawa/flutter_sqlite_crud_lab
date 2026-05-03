# Testes - Primeiro Teste Passo a Passo

## Objetivo

Criar um teste unitario do zero usando uma calculadora simples.

Isso serve para qualquer funcao. A calculadora e so um exemplo concreto.

## Passo 1 - Escreva o codigo a testar

Crie `lib/calculadora.dart`:

```dart
double somar(double a, double b) => a + b;

double subtrair(double a, double b) => a - b;

double multiplicar(double a, double b) => a * b;

double dividir(double a, double b) {
  if (b == 0) throw ArgumentError('Divisao por zero nao e permitida.');
  return a / b;
}
```

## Passo 2 - Crie o arquivo de teste

Crie `test/calculadora_test.dart`.

O nome deve terminar com `_test.dart`.
A pasta `test/` deve espelhar a estrutura de `lib/`.

## Passo 3 - Escreva o primeiro teste

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:meu_projeto/calculadora.dart';

void main() {
  test('somar 2 e 3 retorna 5', () {
    final double resultado = somar(2, 3);
    expect(resultado, 5.0);
  });
}
```

## Passo 4 - Rode o teste

```bash
flutter test test/calculadora_test.dart
```

Se tudo estiver certo:

```text
00:00 +1: All tests passed!
```

Se algo falhar:

```text
00:00 +0 -1: somar 2 e 3 retorna 5
  Expected: <6.0>
    Actual: <5.0>
```

## Passo 5 - Adicione mais testes

```dart
void main() {
  test('somar 2 e 3 retorna 5', () {
    expect(somar(2, 3), 5.0);
  });

  test('somar numero negativo', () {
    expect(somar(-1, 4), 3.0);
  });

  test('subtrair 5 menos 3 retorna 2', () {
    expect(subtrair(5, 3), 2.0);
  });

  test('multiplicar 4 por 3 retorna 12', () {
    expect(multiplicar(4, 3), 12.0);
  });

  test('dividir 10 por 2 retorna 5', () {
    expect(dividir(10, 2), 5.0);
  });
}
```

## Dica de leitura

A descricao do teste deve funcionar como uma frase:

```text
test('somar 2 e 3 retorna 5', ...)
→ "somar 2 e 3 retorna 5"
```

Quando o teste falha, essa descricao aparece no terminal.
Uma boa descricao ajuda a entender o que quebrou sem precisar ler o codigo.

## O que vem a seguir

Com varios testes no mesmo arquivo fica dificil organizar.

O proximo passo e usar `group()` para agrupar testes relacionados.

## Referencias para estudo

- Flutter - Unit testing cookbook: https://docs.flutter.dev/cookbook/testing/unit/introduction
- Dart - Writing tests: https://dart.dev/guides/testing
- pub.dev - test package: https://pub.dev/packages/test