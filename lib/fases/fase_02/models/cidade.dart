class Cidade {
  Cidade({this.id, required String nome, required this.estadoId})
    : nome = nome.trim() {
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

  factory Cidade.fromMap(Map<String, dynamic> map) {
    return Cidade(
      id: map['id'] as int,
      nome: map['nome'] as String,
      estadoId: map['estado_id'] as int,
    );
  }

  Map<String, dynamic> toMap({bool incluirId = false}) {
    return {
      if (incluirId && id != null) 'id': id,
      'nome': nome,
      'estado_id': estadoId,
    };
  }
}
