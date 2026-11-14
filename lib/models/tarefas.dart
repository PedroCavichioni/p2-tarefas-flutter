class Tarefa {
  static const List<String> prioridades = ['Baixa', 'Média', 'Alta'];

  final String id;
  final String titulo;
  final String descricao;
  final DateTime dataVencimento;
  final String prioridade; // Baixa | Média | Alta
  final bool concluida;

  Tarefa({
    this.id = '',
    required this.titulo,
    required this.descricao,
    required this.dataVencimento,
    required this.prioridade,
    this.concluida = false,
  });

  String get situacao => concluida ? 'Concluída' : 'Pendente';

  Tarefa copyWith({
    String? id,
    String? titulo,
    String? descricao,
    DateTime? dataVencimento,
    String? prioridade,
    bool? concluida,
  }) =>
      Tarefa(
        id: id ?? this.id,
        titulo: titulo ?? this.titulo,
        descricao: descricao ?? this.descricao,
        dataVencimento: dataVencimento ?? this.dataVencimento,
        prioridade: prioridade ?? this.prioridade,
        concluida: concluida ?? this.concluida,
      );

  Map<String, dynamic> toMap() => {
    'titulo': titulo,
    'descricao': descricao,
    'dataVencimento': dataVencimento.toIso8601String(),
    'prioridade': prioridade,
    'concluida': concluida,
  };

  factory Tarefa.fromMap(String id, Map<dynamic, dynamic> map) => Tarefa(
    id: id,
    titulo: (map['titulo'] ?? '') as String,
    descricao: (map['descricao'] ?? '') as String,
    dataVencimento:
    DateTime.tryParse((map['dataVencimento'] ?? '') as String) ?? DateTime.now(),
    prioridade: (map['prioridade'] ?? 'Média') as String,
    concluida: (map['concluida'] ?? false) as bool,
  );
}
