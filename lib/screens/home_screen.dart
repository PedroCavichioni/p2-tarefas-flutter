import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../widgets/drawer_menu.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = AuthService().usuarioAtual!;
    return Scaffold(
      appBar: AppBar(title: const Text('Início')),
      drawer: const DrawerMenu(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Olá, ${user.displayName ?? 'usuário'}!',
                style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                icon: const Icon(Icons.checklist),
                label: const Text('Ver minhas tarefas'),
                onPressed: () => Navigator.pushNamed(context, '/tarefas'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
