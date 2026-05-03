import '../dao/estado_dao.dart';
import '../models/estado.dart';
import 'i_estado_repository.dart';

class EstadoRepository implements IEstadoRepository {
  EstadoRepository(this._dao);

  final EstadoDao _dao;

  @override
  Future<List<Estado>> listarTodos() => _dao.findAll();

  @override
  Future<Estado?> buscarPorId(int id) => _dao.findById(id);

  @override
  Future<void> salvar(Estado estado) => _dao.insert(estado);

  @override
  Future<void> atualizar(Estado estado) => _dao.update(estado);

  @override
  Future<void> excluir(int id) => _dao.delete(id);
}
