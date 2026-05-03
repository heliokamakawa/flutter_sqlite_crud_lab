class Cidade {
  Cidade({
    this.id,
    required String nome,
    required this.estadoId,
    this.estadoNome,
    this.estadoSigla,
  }) : nome = nome.trim() {
    if (this.nome.isEmpty) {
      throw ArgumentError('Nome da cidade e obrigatorio.');
    }

    if (estadoId <= 0) {
      throw ArgumentError('Estado da cidade e obrigatorio.');
    }
  }

  final int? id;
  final String nome;
  final int estadoId;
  final String? estadoNome;
  final String? estadoSigla;

  factory Cidade.fromMap(Map<String, dynamic> map) {
    return Cidade(
      id: map['id'] as int,
      nome: map['nome'] as String,
      estadoId: map['estado_id'] as int,
      estadoNome: map['estado_nome'] as String?,
      estadoSigla: map['estado_sigla'] as String?,
    );
  }

  Map<String, dynamic> toMap({bool incluirId = false}) {
    return {
      if (incluirId && id != null) 'id': id,
      'nome': nome,
      'estado_id': estadoId,
    };
  }

  String get estadoDescricao {
    final String? sigla = estadoSigla;
    if (sigla == null) return 'nao encontrado';
    return sigla;
  }
}
