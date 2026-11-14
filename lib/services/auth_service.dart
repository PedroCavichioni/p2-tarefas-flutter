import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import '../models/usuario.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get usuarioAtual => _auth.currentUser;

  Future<void> cadastrar({
    required String nome,
    required String email,
    required String senha,
  }) async {
    final cred = await _auth.createUserWithEmailAndPassword(email: email, password: senha);
    final user = cred.user!;
    await user.updateDisplayName(nome);
    await user.reload();
    final usuario = Usuario(uid: user.uid, nome: nome, email: email);
    await FirebaseDatabase.instance.ref('usuarios/${user.uid}').set(usuario.toMap());
  }

  Future<void> login(String email, String senha) =>
      _auth.signInWithEmailAndPassword(email: email, password: senha);

  Future<void> logout() => _auth.signOut();

  /// Traduz os códigos de erro do Firebase para mensagens amigáveis.
  static String mensagemErro(Object e) {
    if (e is FirebaseAuthException) {
      switch (e.code) {
        case 'invalid-email':
          return 'E-mail inválido.';
        case 'user-not-found':
        case 'wrong-password':
        case 'invalid-credential':
          return 'E-mail ou senha incorretos.';
        case 'email-already-in-use':
          return 'Este e-mail já está cadastrado.';
        case 'weak-password':
          return 'A senha deve ter pelo menos 6 caracteres.';
        case 'network-request-failed':
          return 'Sem conexão com a internet.';
        case 'too-many-requests':
          return 'Muitas tentativas. Tente novamente mais tarde.';
        default:
          return 'Erro de autenticação (${e.code}).';
      }
    }
    return 'Ocorreu um erro inesperado.';
  }
}
