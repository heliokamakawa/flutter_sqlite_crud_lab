import '../dao/cidade_dao.dart';
import '../dtos/cidade_com_estado_dto.dart';
import '../models/cidade.dart';
import 'i_cidade_repository.dart';

class CidadeRepository implements ICidadeRepository {
  CidadeRepository(this._dao);

  final CidadeDao _dao;

  @override
  Future<List<CidadeComEstadoDto>> listarTodas() => _dao.buscarTodos();

  @override
  Future<List<CidadeComEstadoDto>> listarPorEstado(int estadoId) =>
      _dao.buscarPorEstado(estadoId);

  @override
  Future<Cidade?> buscarPorId(int id) => _dao.buscarPorId(id);

  @override
  Future<bool> existePorEstado(int estadoId) => _dao.existePorEstado(estadoId);

  @override
  Future<void> salvar(Cidade cidade) => _dao.inserir(cidade);

  @override
  Future<void> atualizar(Cidade cidade) => _dao.atualizar(cidade);

  @override
  Future<void> excluir(int id) => _dao.excluir(id);
}
