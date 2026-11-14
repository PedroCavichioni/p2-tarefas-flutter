import 'package:flutter/material.dart';

import '../services/auth_service.dart';

// Versão simples (etapa 6): só saudação e botão de sair.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = AuthService().usuarioAtual!;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Início'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sair',
            onPressed: () => AuthService().logout(),
          ),
        ],
      ),
      body: Center(
        child: Text('Olá, ${user.displayName ?? 'usuário'}!',
            style: Theme.of(context).textTheme.headlineSmall),
      ),
    );
  }
}
