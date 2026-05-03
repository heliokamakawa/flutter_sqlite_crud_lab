# Fase 05 - Objetivo

## De onde esta fase nasce

As fases anteriores resolveram problemas reais um por vez:

```text
Fase 01: CRUD funciona, mas tudo na tela
Fase 02: conexao centralizada, dados com tipo
Fase 03: SQL sai da tela, vai para o DAO
Fase 04: JOIN, DTO composto, dropdown com objeto
```

A Fase 05 nao adiciona uma funcionalidade nova.

Ela reorganiza o que ja existe em uma estrutura que permite:

- trocar a implementacao sem mexer na tela;
- testar partes do sistema isoladamente;
- aplicar regras de negocio fora da tela e fora do banco.

## Mensagem principal

```text
Padrao so faz sentido quando resolve uma dor real.
```

Cada elemento desta fase existe porque resolve um problema especifico.

Se o problema nao existe no seu contexto, o padrao e desnecessario.

## O que esta fase introduz

### Interface (contrato abstrato)

`IEstadoRepository` define o que um repositorio de estados deve fazer, sem dizer como.

A tela conhece apenas a interface. Nao sabe se os dados vem do SQLite, de uma API ou da memoria.

### Repository

`EstadoRepository` implementa `IEstadoRepository` usando `EstadoDao`.

O Repository e a camada que a tela enxerga. O DAO e um detalhe interno do Repository.

### Injecao de dependencia

A tela recebe o repository pelo construtor. Ela nao cria suas dependencias — recebe prontas.

Isso permite passar implementacoes diferentes sem mudar a tela.

### Service (regras de negocio)

`EstadoService` concentra regras que envolvem mais de uma entidade.

Exemplo: "nao pode excluir estado com cidades". Essa regra precisa de `EstadoRepository` e `CidadeRepository` ao mesmo tempo. O Model nao pode ter essa regra (nao conhece outros repositorios). O DAO nao deve ter (e de banco, nao de negocio). O Service e o lugar certo.

### Organizacao em camadas

```text
Tela (app/)
  ↓ depende de interfaces
Service (services/) — regras de negocio
Repository — interfaces (repositories/)
  ↓ implementada por
Repository — implementacoes (repositories/)
  ↓ usa
DAO (dao/) — acesso ao banco
```

## O que NAO muda

- `Model` com `fromMap`, `toMap` e validacoes;
- `DTO` para resultado de JOIN;
- `DatabaseHelper` com conexao singleton;
- a estrutura das telas (lista + formulario).

## Resultado esperado

Ao final da Fase 05, o aluno deve conseguir explicar:

- qual problema cada camada resolve;
- por que a tela depende de interface, nao de implementacao;
- o que e injecao de dependencia e por que facilita testes;
- quando usar Service e quando nao usar;
- como as dependencias sao compostas na raiz da aplicacao.

## Referencias para estudo

- Martin Fowler - Repository: https://martinfowler.com/eaaCatalog/repository.html
- SOLID - Dependency Inversion Principle: https://en.wikipedia.org/wiki/Dependency_inversion_principle
- Flutter - Guide to app architecture: https://docs.flutter.dev/app-architecture/guide
- Martin Fowler - Service Layer: https://martinfowler.com/eaaCatalog/serviceLayer.html
- Dart - Abstract classes: https://dart.dev/language/class-modifiers#abstract
