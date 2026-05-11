# Fase 01 - Listagem

Na Fase 01, a tela consulta o banco diretamente.

## Estados

```dart
final resultado = await banco.rawQuery(
  'SELECT id, nome, sigla FROM estado ORDER BY nome',
);
```

## Cidades

```dart
final resultado = await banco.rawQuery(
  'SELECT id, nome, estado_id FROM cidade ORDER BY nome',
);
```

O resultado e uma lista de `Map<String, dynamic>`.

A tela guarda essa lista no estado do widget e usa `setState()` para redesenhar.
