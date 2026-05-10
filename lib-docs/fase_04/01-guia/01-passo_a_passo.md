# Fase 04 - Passo a Passo

## O que esta fase adiciona

- `CidadeComEstadoDto` — resultado de JOIN com campos obrigatorios
- `CidadeDao` com consultas simples e consultas com JOIN
- `DropdownButton<Estado>` com `==` e `hashCode` no Model

## O que abrir

### 1. DTO de Cidade

Arquivo: `lib/fases/fase_04/dtos/cidade_com_estado_dto.dart`

Observe:
- todos os campos sao obrigatorios (sem `?`)
- `estadoNome` e `estadoSigla` sempre existem — o JOIN garante
- compare com o Model `Cidade`: DTO tem campos extras, todos nao-nulos

### 2. DAO de Cidade

Arquivo: `lib/fases/fase_04/dao/cidade_dao.dart`

Observe como os metodos se dividem:
- `buscarTodos()` retorna `List<CidadeComEstadoDto>` — JOIN para exibicao
- `buscarPorEstado(int estadoId)` retorna `List<CidadeComEstadoDto>` — JOIN filtrado
- `buscarPorId(int id)` retorna `Cidade?` — Model puro para editar
- `insert` e `update` recebem `Cidade` — Model para escrita

### 3. Model Estado com ==

Arquivo: `lib/fases/fase_04/models/estado.dart`

Observe:
- `operator ==` compara pelo `id`
- `hashCode` usa `id.hashCode`
- sem isso o `DropdownButton<Estado>` nao consegue pre-selecionar ao editar

### 4. Formulario de Cidade

Arquivo: `lib/fases/fase_04/app/cidade_form.dart`

Compare com fase_03 (se houver formulario de cidade):
- Antes: `int? estadoIdSelecionado` e `DropdownButton<int>`
- Agora: `Estado? estadoSelecionado` e `DropdownButton<Estado>`

Observe:
- o `value` do dropdown e um objeto `Estado` inteiro, nao um `int`
- ao editar, o `==` customizado encontra o item correto na lista
