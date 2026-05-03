import '../models/cidade.dart';

class CidadeComEstadoDto {
  const CidadeComEstadoDto({
    required this.id,
    required this.nome,
    required this.estadoId,
    required this.estadoNome,
    required this.estadoSigla,
  });

  final int id;
  final String nome;
  final int estadoId;
  final String estadoNome;
  final String estadoSigla;

  factory CidadeComEstadoDto.fromMap(Map<String, dynamic> map) {
    return CidadeComEstadoDto(
      id: map['id'] as int,
      nome: map['nome'] as String,
      estadoId: map['estado_id'] as int,
      estadoNome: map['estado_nome'] as String,
      estadoSigla: map['estado_sigla'] as String,
    );
  }

  Cidade toModel() {
    return Cidade(id: id, nome: nome, estadoId: estadoId);
  }

  String get estadoDescricao => '$estadoNome ($estadoSigla)';
}
