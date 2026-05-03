# Testes - Agrupamento com group

## O problema sem agrupamento

Com muitos testes no mesmo arquivo, o `main()` fica longo e difícil de ler.

Nao da para entender facilmente quais testes pertencem ao que.

## group

`group()` organiza testes relacionados em um bloco nomeado.

```dart
void main() {
  group('somar', () {
    test('dois positivos', () {
      expect(somar(2, 3), 5.0);
    });

    test('com negativo', () {
      expect(somar(-1, 4), 3.0);
    });

    test('dois negativos', () {
      expect(somar(-2, -3), -5.0);
    });
  });

  group('dividir', () {
    test('divisao normal', () {
      expect(dividir(10, 2), 5.0);
    });

    test('divisao por zero lanca excecao', () {
      expect(() => dividir(5, 0), throwsArgumentError);
    });
  });
}
```

Na saida do terminal, os nomes aparecem juntos:

```text
✓ somar dois positivos
✓ somar com negativo
✓ somar dois negativos
✓ dividir divisao normal
✓ dividir divisao por zero lanca excecao
```

## setUp

`setUp()` roda antes de cada teste dentro do grupo.

Util quando varios testes precisam do mesmo objeto:

```dart
group('Calculadora', () {
  late Calculadora calc;

  setUp(() {
    calc = Calculadora();
  });

  test('soma', () {
    expect(calc.somar(2, 3), 5.0);
  });

  test('subtrai', () {
    expect(calc.subtrair(5, 3), 2.0);
  });
});
```

Cada teste recebe uma instancia nova.
Mudancas feitas em um teste nao afetam o proximo.

## tearDown

`tearDown()` roda depois de cada teste.

Util para fechar conexoes, limpar arquivos, liberar recursos:

```dart
group('BancoDeDados', () {
  late Database banco;

  setUp(() async {
    banco = await abrirBancoEmMemoria();
  });

  tearDown(() async {
    await banco.close();
  });

  test('insere registro', () async {
    // usa banco...
  });
});
```

## setUpAll e tearDownAll

Rodam uma vez so, antes e depois de todos os testes do grupo.

```dart
group('integracao', () {
  setUpAll(() {
    // roda uma vez antes de todos
  });

  tearDownAll(() {
    // roda uma vez depois de todos
  });
});
```

Use `setUpAll` quando o setup e caro (ex: subir um servidor de teste).
Use `setUp` quando cada teste precisa de um estado limpo.

## Grupos aninhados

Grupos podem estar dentro de outros grupos:

```dart
group('Calculadora', () {
  group('operacoes basicas', () {
    test('soma', ...);
    test('subtrai', ...);
  });

  group('divisao', () {
    test('divisao normal', ...);
    test('divisao por zero', ...);
  });
});
```

## Dica pratica

Um grupo por comportamento, nao por metodo.

Bom:
```text
group('quando o denominador e zero', ...)
group('quando os dois numeros sao positivos', ...)
```

Aceitavel:
```text
group('somar', ...)
group('dividir', ...)
```

## Referencias para estudo

- pub.dev - test package, group e setUp: https://pub.dev/packages/test
- Flutter - Unit testing: https://docs.flutter.dev/cookbook/testing/unit/introduction
- Dart - Testing: https://dart.dev/guides/testing