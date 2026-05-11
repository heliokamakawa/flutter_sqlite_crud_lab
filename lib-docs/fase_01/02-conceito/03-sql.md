# Fase 01 - SQL

SQL e a linguagem usada para conversar com o banco.

## SELECT

```sql
SELECT id, nome, sigla FROM estado ORDER BY nome;
```

Busca registros.

## INSERT

```sql
INSERT INTO estado (nome, sigla) VALUES (?, ?);
```

Insere registros.

## UPDATE

```sql
UPDATE estado SET nome = ?, sigla = ? WHERE id = ?;
```

Atualiza registros.

## DELETE

```sql
DELETE FROM estado WHERE id = ?;
```

Remove registros.

Na Fase 01, esses comandos ficam nas telas. Nas proximas fases, eles migram para classes proprias.
