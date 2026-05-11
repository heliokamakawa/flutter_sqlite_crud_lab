# Fase 04 - Objetivo

A Fase 04 aplica o mesmo padrao da Fase 03 para outra entidade: `Cidade`.

## Ideia principal

```text
Tela nao escreve SQL.
DAO organiza o acesso ao banco.
DAO faz o mapeamento objeto-relacional.
Model representa os dados.
```

## O que muda

- entra o `CidadeDao`;
- o formulario de cidade escolhe um `Estado`;
- a cidade salva apenas o `estadoId`;
- a listagem pode filtrar cidades por estado.

Ao final, o aluno deve conseguir criar um DAO simples para qualquer tabela parecida.
