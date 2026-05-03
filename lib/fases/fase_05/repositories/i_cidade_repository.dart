import '../dtos/cidade_com_estado_dto.dart';
import '../models/cidade.dart';

abstract class ICidadeRepository {
  Future<List<CidadeComEstadoDto>> listarTodas();
  Future<List<CidadeComEstadoDto>> listarPorEstado(int estadoId);
  Future<Cidade?> buscarPorId(int id);
  Future<bool> existePorEstado(int estadoId);
  Future<void> salvar(Cidade cidade);
  Future<void> atualizar(Cidade cidade);
  Future<void> excluir(int id);
}
