# Fase 03 - Passo a Passo

## O que esta fase adiciona

- `EstadoDao` — classe com os cinco metodos de acesso ao banco
- A tela deixa de escrever SQL

## O que abrir

### 1. DAO

Arquivo: `lib/fases/fase_03/dao/estado_dao.dart`

Observe:
- construtor recebe `bancoDados` por parametro
- constante `_tabela` com o nome da tabela (evita repetir a string)
- cinco metodos: `buscarTodos`, `buscarPorId`, `insert`, `update`, `delete`
- cada metodo contem o SQL — a tela nao precisa mais saber

### 2. Tela de lista

Arquivo: `lib/fases/fase_03/app/estado_lista.dart`

Compare com `lib/fases/fase_02/app/estado_lista.dart`:

Fase 02:
```dart
final List<Map<String, dynamic>> resultado = await banco.rawQuery(
  'SELECT id, nome, sigla FROM estado ORDER BY nome',
);
final List<Estado> estados = resultado.map(Estado.fromMap).toList();
```

Fase 03:
```dart
final Database banco = await Conexao.instancia.bancoDados;
final EstadoDao dao = EstadoDao(banco);
final List<Estado> estados = await dao.buscarTodos();
```

A tela nao sabe mais qual tabela existe nem como e a query.

### 3. Tela de formulario

Arquivo: `lib/fases/fase_03/app/estado_form.dart`

Compare com fase_02:
- Fase 02: `banco.insert(...)`, `banco.update(...)`, `banco.delete(...)` na tela
- Fase 03: `dao.inserir(estado)`, `dao.atualizar(estado)`, `dao.excluir(id)`

A tela faz uma coisa: coordena a interacao com o usuario.
O DAO faz uma coisa: acessa o banco.
