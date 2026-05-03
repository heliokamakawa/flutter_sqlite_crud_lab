# Fase 05 — Repository, Service e Injecao de Dependencia

Reorganizacao com interfaces, inversao de dependencia e camada de servico.

## O que esta fase introduz

- `IEstadoRepository`, `ICidadeRepository` — contratos abstratos
- `EstadoRepository`, `CidadeRepository` — implementacoes via DAO
- `EstadoService` — regras de negocio que envolvem mais de uma entidade
- Tela recebe dependencias pelo construtor (injecao manual)

## Como estudar

- `01-guia/` — passo a passo do codigo
- `02-conceito/` — explicacoes na ordem correta de entendimento

Comece por `01-guia/00-roteiro_de_estudo.md`.
