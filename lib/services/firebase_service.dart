import 'package:firebase_database/firebase_database.dart';

import '../models/tarefa.dart';

class FirebaseService {
  final String uid;
  FirebaseService(this.uid);

  DatabaseReference get _ref => FirebaseDatabase.instance.ref('tarefas/$uid');

  Stream<List<Tarefa>> streamTarefas() {
    return _ref.onValue.map((event) {
      final data = event.snapshot.value;
      if (data == null || data is! Map) return <Tarefa>[];
      final lista = data.entries
          .map((e) => Tarefa.fromMap(e.key as String, e.value as Map))
          .toList();
      lista.sort((a, b) => a.dataVencimento.compareTo(b.dataVencimento));
      return lista;
    });
  }

  Future<void> cadastrar(Tarefa t) => _ref.push().set(t.toMap());

  Future<Tarefa?> consultar(String id) async {
    final snap = await _ref.child(id).get();
    if (!snap.exists) return null;
    return Tarefa.fromMap(id, snap.value as Map);
  }

  Future<void> atualizar(Tarefa t) => _ref.child(t.id).update(t.toMap());

  Future<void> alterarSituacao(Tarefa t) =>
      _ref.child(t.id).update({'concluida': !t.concluida});

  Future<void> excluir(String id) => _ref.child(id).remove();
}
