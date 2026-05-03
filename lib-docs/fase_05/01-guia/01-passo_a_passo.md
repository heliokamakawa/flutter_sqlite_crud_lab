# Fase 05 - Passo a Passo

## O que esta fase adiciona

- Interfaces: `IEstadoRepository`, `ICidadeRepository`
- Repository: `EstadoRepository`, `CidadeRepository`
- Service: `EstadoService` com regra de exclusao
- Injecao de dependencia pelo construtor

## O que abrir

### 1. Interface

Arquivo: `lib/fases/fase_05/repositories/i_estado_repository.dart`

Observe:
- `abstract class` sem corpo nos metodos
- vocabulario de dominio: `listarTodos`, `salvar`, `excluir`
- a tela depende desta interface — nao sabe que existe DAO ou SQLite

### 2. Implementacao do Repository

Arquivo: `lib/fases/fase_05/repositories/estado_repository.dart`

Observe:
- `implements IEstadoRepository`
- recebe `EstadoDao` pelo construtor
- cada metodo repassa para o DAO com nome em linguagem de dominio
- a tela nao ve o DAO diretamente

### 3. Service

Arquivo: `lib/fases/fase_05/services/estado_service.dart`

Observe:
- recebe `IEstadoRepository` e `ICidadeRepository` pelo construtor
- metodo `excluir` verifica se ha cidades antes de excluir o estado
- regra de negocio centralizada aqui, nao na tela

### 4. Tela de lista

Arquivo: `lib/fases/fase_05/app/estado_lista.dart`

Compare com `lib/fases/fase_04/app/estado_lista.dart`:
- Fase 04: `final EstadoDao dao` (implementacao concreta)
- Fase 05: `final EstadoService service` (recebe o servico pronto)

Observe:
- `_listarEstados` chama `widget.service.listarTodos()`
- `_excluirEstado` chama `widget.service.excluir(id)` e trata `StateError`
- a tela nao conhece DAO, DatabaseHelper, nem nenhuma implementacao

### 5. Composicao das dependencias

Arquivo: `lib/fases/fase_05/app/main_fase_05.dart`

Observe:
- e aqui que DAO, Repository e Service sao criados
- a tela recebe tudo pronto pelo construtor
- este e o unico ponto do app que conhece a cadeia completa
