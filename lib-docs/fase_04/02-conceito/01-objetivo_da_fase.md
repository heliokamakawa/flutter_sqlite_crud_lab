# Fase 04 - Objetivo

## De onde esta fase nasce

A Fase 03 colocou o SQL no DAO. A tela deixou de escrever SQL.

Mas o DAO da Fase 03 so conhecia `Estado`, uma entidade simples sem relacao com outras.

O mundo real raramente e assim. Cidades pertencem a estados. Pedidos pertencem a clientes. Itens pertencem a pedidos.

Quando ha associacao entre entidades, novas decisoes surgem:

```text
Como listar cidades mostrando o nome do estado?
Como filtrar cidades por estado?
O formulario de cidade deve trabalhar com o id do estado ou com o objeto Estado?
```

Essas decisoes sao o tema da Fase 04.

## Mensagem principal

```text
Banco relacional exige decisao de mapeamento.
```

## O que esta fase introduz

### JOIN no DAO

A listagem de cidades precisa mostrar o nome do estado.

O dado vem de duas tabelas. O DAO executa o JOIN e o resultado nao e `Cidade` pura — e `Cidade` mais campos de `Estado`.

### DTO para resultado composto

`Cidade` nao carrega nome e sigla do estado. Esses campos nao sao dela.

O resultado do JOIN e um formato especifico de uma consulta. Ele precisa de uma classe propria: `CidadeComEstadoDto`.

Essa e a decisao de mapeamento: identificar que o resultado de uma consulta com JOIN nao e um Model, e um DTO.

### Filtro por estado

A listagem de cidades permite filtrar por estado.

O DAO tem dois metodos: `findAll()` e `findByEstado(int estadoId)`.

A tela escolhe qual chamar com base no filtro selecionado.

### DropdownButton com objeto, nao com id

Na Fase 02 e 03, o dropdown de estados no formulario de cidade trabalhava com `int` (o id do estado).

Na Fase 04, o dropdown trabalha com `Estado` (o objeto inteiro).

Isso permite:

- pre-selecionar o estado correto ao editar (comparacao por `==` no objeto);
- acessar qualquer dado do Estado sem buscar no banco novamente.

Para que o `DropdownButton<Estado>` funcione, `Estado` precisa implementar `==` e `hashCode`.

## Resultado esperado

Ao final da Fase 04, o aluno deve conseguir explicar:

- por que o resultado de um JOIN precisa de um DTO e nao de um Model;
- como o DAO separa consultas simples de consultas com JOIN;
- por que o DropdownButton trabalha com `Estado` e nao com `int`;
- para que servem `==` e `hashCode` em um Model.

## Referencias para estudo

- Flutter - Persist data with SQLite: https://docs.flutter.dev/cookbook/persistence/sqlite
- SQLite - INNER JOIN: https://www.sqlite.org/lang_select.html
- Dart - Operator overloading: https://dart.dev/language/methods#operators
- Martin Fowler - Data Transfer Object: https://martinfowler.com/eaaCatalog/dataTransferObject.html
- Flutter - DropdownButton: https://api.flutter.dev/flutter/material/DropdownButton-class.html
