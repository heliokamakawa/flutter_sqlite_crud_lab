# 04 - Listagem de estados e cidades

## Listagem de estados

Arquivo estudado:

```text
lib/fases/fase_01/app/estado_lista.dart
```

Trecho:

```dart
final List<Map<String, dynamic>> resultado = await banco.rawQuery(
  'SELECT id, nome, sigla FROM estado ORDER BY nome',
);
```

`rawQuery` executa um `SELECT`.

O resultado vem como uma lista de mapas:

```dart
List<Map<String, dynamic>>
```

Cada mapa representa uma linha da tabela.

Exemplo conceitual:

```dart
{
  'id': 1,
  'nome': 'Sao Paulo',
  'sigla': 'SP',
}
```

## Guardando o resultado na tela

```dart
setState(() {
  estados = resultado;
});
```

Depois da consulta, a lista `estados` e atualizada.

Como a atualizacao esta dentro de `setState`, o Flutter redesenha a tela.

## Desenhando os cards

```dart
for (final Map<String, dynamic> estado in estados)
  Card(
    child: ListTile(
      title: Text('${estado['nome']} (${estado['sigla']})'),
      subtitle: Text('id: ${estado['id']}'),
    ),
  ),
```

O `for` percorre todos os registros carregados.

Cada estado vira um `Card` com um `ListTile`.

## Listagem de cidades

Arquivo estudado:

```text
lib/fases/fase_01/app/cidade_lista.dart
```

Trecho:

```dart
final List<Map<String, dynamic>> resultado = await banco.rawQuery('''
  SELECT
    cidade.id,
    cidade.nome,
    cidade.estado_id,
    estado.nome AS estado_nome,
    estado.sigla AS estado_sigla
  FROM cidade
  LEFT JOIN estado ON estado.id = cidade.estado_id
  ORDER BY cidade.nome
''');
```

A listagem de cidades usa `LEFT JOIN`.

Isso permite mostrar dados da cidade e tambem dados do estado relacionado.

## Campos retornados no JOIN

A consulta retorna:

- `cidade.id`;
- `cidade.nome`;
- `cidade.estado_id`;
- `estado_nome`;
- `estado_sigla`.

Os aliases `AS estado_nome` e `AS estado_sigla` criam nomes mais claros no mapa retornado.

## Exibindo a cidade

```dart
subtitle: Text(
  'id: ${cidade['id']} | estado_id: ${cidade['estado_id']} | '
  'estado: ${cidade['estado_sigla'] ?? 'nao encontrado'}',
),
```

Se o estado nao for encontrado, a tela mostra `nao encontrado`.

Isso e possivel porque o `LEFT JOIN` ainda retorna a cidade mesmo quando nao acha o estado.

## Ideia principal

Listar e:

1. abrir o banco;
2. executar `SELECT`;
3. guardar o resultado no estado da tela;
4. redesenhar a interface.

