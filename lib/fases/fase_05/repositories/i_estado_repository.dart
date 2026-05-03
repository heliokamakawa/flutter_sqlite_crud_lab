import '../models/estado.dart';

abstract class IEstadoRepository {
  Future<List<Estado>> listarTodos();
  Future<Estado?> buscarPorId(int id);
  Future<void> salvar(Estado estado);
  Future<void> atualizar(Estado estado);
  Future<void> excluir(int id);
}
