import '../models/estado.dart';
import '../repositories/i_cidade_repository.dart';
import '../repositories/i_estado_repository.dart';

// O Service orquestra regras de negocio que envolvem mais de um repositorio
// ou que nao pertencem nem ao Model nem ao Repository isoladamente.
class EstadoService {
  EstadoService({
    required IEstadoRepository estadoRepository,
    required ICidadeRepository cidadeRepository,
  }) : _estadoRepository = estadoRepository,
       _cidadeRepository = cidadeRepository;

  final IEstadoRepository _estadoRepository;
  final ICidadeRepository _cidadeRepository;

  Future<List<Estado>> listarTodos() => _estadoRepository.listarTodos();

  Future<void> salvar(Estado estado) => _estadoRepository.salvar(estado);

  Future<void> atualizar(Estado estado) => _estadoRepository.atualizar(estado);

  // Regra de negocio: nao permite excluir estado que possui cidades.
  // Essa regra nao pertence ao DAO (que so acessa o banco)
  // nem ao Model (que valida apenas os proprios dados).
  // Ela coordena dois repositorios — por isso mora no Service.
  Future<void> excluir(int id) async {
    final bool temCidades = await _cidadeRepository.existePorEstado(id);

    if (temCidades) {
      throw StateError(
        'Nao e possivel excluir um estado que possui cidades cadastradas.',
      );
    }

    await _estadoRepository.excluir(id);
  }
}
