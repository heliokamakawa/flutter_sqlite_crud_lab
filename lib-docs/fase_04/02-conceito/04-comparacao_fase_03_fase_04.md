# Fase 04 - Comparacao com a Fase 03

## Fase 03

```text
Estado -> EstadoDao -> tela de estados
```

## Fase 04

```text
Estado -> EstadoDao -> tela de estados
Cidade -> CidadeDao -> tela de cidades
```

A novidade e repetir o padrao para uma entidade que possui `estadoId`.

O conceito principal nao muda: SQL fica no DAO, nao na tela.
