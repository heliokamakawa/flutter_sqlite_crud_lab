# Testes - Boas Praticas

## Padrao AAA

Todo teste segue tres etapas:

```text
Arrange  → prepara os dados e objetos
Act      → executa o que esta sendo testado
Assert   → verifica o resultado
```

Exemplo:

```dart
test('somar dois positivos retorna a soma', () {
  // Arrange
  const double a = 2;
  const double b = 3;

  // Act
  final double resultado = somar(a, b);

  // Assert
  expect(resultado, 5.0);
});
```

Testes simples podem omitir os comentarios, mas a estrutura deve existir mentalmente.

## Nome do teste

O nome deve descrever o comportamento esperado, nao o metodo.

Bom:
```text
'somar dois positivos retorna a soma correta'
'dividir por zero lanca ArgumentError'
'estado com sigla de 3 letras nao e valido'
```

Ruim:
```text
'test1'
'soma'
'testar funcao somar'
```

Uma boa forma e pensar na frase:

```text
"quando [condicao], espera-se [resultado]"
```

E simplificar para o que for legivel.

## Um comportamento por teste

Cada teste verifica uma coisa so.

Bom:
```dart
test('somar positivos', () {
  expect(somar(2, 3), 5.0);
});

test('somar com negativo', () {
  expect(somar(-1, 3), 2.0);
});
```

Ruim:
```dart
test('somar', () {
  expect(somar(2, 3), 5.0);
  expect(somar(-1, 3), 2.0);
  expect(somar(0, 0), 0.0);
  expect(somar(-5, -3), -8.0);
});
```

Com um comportamento por teste, quando algo quebra, o nome diz exatamente o que falhou.

## Quantos testes escrever

Nao existe numero exato. A pergunta certa e:

```text
Quais sao os casos importantes de verificar?
```

Para uma funcao de soma:

```text
dois positivos           → caso normal
positivo com negativo    → resultado pode ser positivo ou negativo
dois negativos           → resultado negativo
zero com qualquer numero → zero nao muda o resultado
```

Para uma funcao com validacao:

```text
entrada valida    → funciona
entrada invalida  → lanca excecao ou retorna erro
caso limite       → valor exatamente no limite aceitavel
```

Testar so o caminho feliz nao e suficiente.
Testar todos os numeros possiveis e exagero.

## Cobertura de testes

Cobertura (coverage) e o percentual de linhas de codigo que algum teste executa.

```bash
flutter test --coverage
```

Gera um arquivo em `coverage/lcov.info`.

Referencia comum de mercado: **80% de cobertura**.

Mas cobertura alta nao significa testes bons.

Voce pode ter 100% de cobertura e nao testar os casos importantes.

O objetivo e testar os comportamentos relevantes, nao atingir um numero.

## O que vale mais testar

Priorize:

```text
logica de negocio       → regras e validacoes
conversoes de dados     → fromMap, toMap
casos de erro           → excecoes e falhas esperadas
calculos               → funcoes com resultado preciso
```

Menos urgente:

```text
getters simples que apenas retornam um campo
construtores sem logica
```

## Evite testes frageis

Um teste fragil e aquele que quebra sem que o comportamento tenha mudado.

Causas comuns:

```text
verificar texto exato de mensagem de erro que pode mudar
depender de data e hora atual
depender de ordem em uma lista nao ordenada
```

## Mantenha os testes rapidos

Testes unitarios devem rodar em milissegundos.

Se um teste demora, provavelmente esta fazendo mais do que deveria.

Testes lentos acabam sendo ignorados.

## Conclusao

Poucos testes bem escritos valem mais do que muitos testes mal nomeados, repetitivos ou frageis.

A meta e ter testes que:

```text
rodam rapido
tem nome claro
verificam um comportamento por vez
avisam quando algo importante quebra
```

## Referencias para estudo

- Martin Fowler - Unit Test: https://martinfowler.com/bliki/UnitTest.html
- Flutter - Testing Flutter apps: https://docs.flutter.dev/testing/overview
- pub.dev - test package: https://pub.dev/packages/test
- Dart - Testing: https://dart.dev/guides/testing
