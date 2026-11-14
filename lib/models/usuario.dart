class Usuario {
  final String uid;
  final String nome;
  final String email;

  Usuario({required this.uid, required this.nome, required this.email});

  Map<String, dynamic> toMap() => {'nome': nome, 'email': email};

  factory Usuario.fromMap(String uid, Map<dynamic, dynamic> map) => Usuario(
    uid: uid,
    nome: (map['nome'] ?? '') as String,
    email: (map['email'] ?? '') as String,
  );
}
