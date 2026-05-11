# Fase 04 - Passo a passo

## Model Cidade

`Cidade` representa a tabela `cidade`:

```text
id, nome, estadoId
```

## DAO de Cidade

`CidadeDao` possui:

```text
buscarTodos()
buscarPorEstado(estadoId)
buscarPorId(id)
inserir(cidade)
atualizar(cidade)
excluir(id)
excluirPorEstado(estadoId)
```

Ele tambem faz o mapeamento objeto-relacional:

```text
Map do SQLite -> Cidade
Cidade -> Map para insert/update
```

## Tela

A tela:

- carrega estados para o filtro;
- chama `CidadeDao`;
- abre o formulario;
- atualiza a lista depois de salvar ou excluir.

Ao excluir um estado, as cidades daquele estado sao excluidas antes.
