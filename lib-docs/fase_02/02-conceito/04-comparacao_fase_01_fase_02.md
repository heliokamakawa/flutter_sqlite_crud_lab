# Comparacao entre Fase 01 e Fase 02

## Fase 01

```text
Tela abre banco
Tela executa SQL
Tela trabalha com Map
```

## Fase 02

```text
Conexao abre banco
Tela ainda executa parte do SQL
Tela usa Models
```

## Principal ganho

Os dados deixam de circular como `Map<String, dynamic>` em todos os lugares.

Agora existem:

```text
Estado
Cidade
```

com `fromMap()` e `toMap()`.

No formulario de cidade, o dropdown tambem passa a trabalhar com objeto:

```text
Fase 01: dropdown usa Map/id
Fase 02: dropdown usa Estado
```
