# Fase 04 - Mapeamento

O mapeamento desta fase e direto:

```text
tabela cidade -> Model Cidade
```

Campos da tabela:

```text
id
nome
estado_id
```

Campos do Model:

```text
id
nome
estadoId
```

O DAO usa `fromMap()` para ler o mapa vindo do SQLite.

O DAO usa `toMap()` para gerar o mapa usado em `insert` e `update`.
