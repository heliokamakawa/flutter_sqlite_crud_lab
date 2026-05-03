class Estado {
  Estado({this.id, required String nome, required String sigla})
    : nome = nome.trim(),
      sigla = sigla.trim().toUpperCase() {
    if (this.nome.isEmpty) {
      throw ArgumentError('Nome do estado e obrigatorio.');
    }

    if (this.sigla.length != 2) {
      throw ArgumentError('Sigla do estado deve ter 2 caracteres.');
    }
  }

  final int? id;
  final String nome;
  final String sigla;

  factory Estado.fromMap(Map<String, dynamic> map) {
    return Estado(
      id: map['id'] as int,
      nome: map['nome'] as String,
      sigla: map['sigla'] as String,
    );
  }

  Map<String, dynamic> toMap({bool incluirId = false}) {
    return {
      if (incluirId && id != null) 'id': id,
      'nome': nome,
      'sigla': sigla,
    };
  }

  String get descricao => '$nome ($sigla)';

  // Necessario para DropdownButton<Estado> comparar o valor selecionado
  // com os itens da lista usando ==
  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is Estado && other.id == id);

  @override
  int get hashCode => id.hashCode;
}
