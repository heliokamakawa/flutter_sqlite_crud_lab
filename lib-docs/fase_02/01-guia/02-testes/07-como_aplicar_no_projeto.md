# Testes — Como aplicar no projeto

## Da calculadora para o projeto

O tutorial usa uma calculadora como exemplo por ser simples e isolada.
A estrutura do teste e identica no projeto real. So muda o que esta sendo testado.

Calculadora:
```dart
test('somar 2 e 3 retorna 5', () {
  final double resultado = somar(2, 3);
  expect(resultado, 5.0);
});
```

Estado (projeto real):
```dart
test('nome nao pode ser vazio', () {
  expect(
    () => Estado(nome: '', sigla: 'SP'),
    throwsA(isA<ArgumentError>()),
  );
});
```

A estrutura e a mesma: `test(descricao, () { ... expect ... })`.

## Arquivos de teste do projeto

```text
test/fases/fase_02/models/estado_test.dart                   -> testa o Model Estado
test/fases/fase_02/models/cidade_test.dart                   -> testa o Model Cidade
test/fases/fase_02/database/database_test.dart               -> testa a conexao singleton
test/fases/fase_02/database/database_sql_test.dart           -> testa os comandos SQL
test/fases/fase_02/database/database_sql_integration_test.dart -> testa SQL em banco na memoria
```

## Como rodar

Todos os testes:
```bash
flutter test
```

So os testes da Fase 02:
```bash
flutter test test/fases/fase_02/
```

So os testes de Model:
```bash
flutter test test/fases/fase_02/models/
```

## O que cada arquivo testa

### estado_test.dart
Testa as regras do construtor `Estado(nome, sigla)`:
- nome em branco lanca `ArgumentError`
- sigla com tamanho errado lanca `ArgumentError`
- estado valido cria o objeto corretamente
- `fromMap` e `toMap` funcionam como esperado

### cidade_test.dart
Testa as regras do construtor `Cidade(nome, estadoId)`:
- nome em branco lanca `ArgumentError`
- estadoId invalido lanca `ArgumentError`

### database_test.dart
Testa o singleton `Conexao`:
- instancias diferentes retornam o mesmo objeto
- banco abre corretamente

### database_sql_integration_test.dart
Roda os comandos SQL da lista `DatabaseSql.comandosCriacao` em um banco em memoria:
- tabelas sao criadas
- dados iniciais sao inseridos
- os comandos podem ser executados passo a passo

## Diferenca entre os exemplos

```text
Calculadora               -> funcao pura, sem estado, resultado deterministico
Model Estado/Cidade       -> classe com validacoes, pode lancar excecao
Database/integration      -> usa SQLite em memoria, testes assincronos com await
```

Testes de banco usam `async`/`await` porque o SQLite e assincrono.
Testes de Model sao sincronos — iguais ao exemplo da calculadora.
