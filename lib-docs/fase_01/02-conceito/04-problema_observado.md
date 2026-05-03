# Diagrama de classes — Fase 1

```mermaid
classDiagram
    direction LR

    class EstadoForm {
        conexao
    }

    class EstadoLista {
        conexao
    }

    class CidadeForm {
        conexao
    }

    class CidadeLista {
        conexao
    }

    %% Relações de uso (tela -> lista)
    EstadoForm --> EstadoLista : usa
    CidadeForm --> CidadeLista : usa


    %% Destaque visual (repetição)
    note for EstadoForm "conexao duplicada"
    note for EstadoLista "conexao duplicada"
    note for CidadeForm "conexao duplicada"
    note for CidadeLista "conexao duplicada"
```

## Leitura

* Cada classe possui sua própria conexão
* A conexão está duplicada em todas as classes
* Não existe centralização

## Problema

Se mudar a conexão, quantos lugares preciso alterar?

* repetição de código
* acoplamento
* difícil manutenção


