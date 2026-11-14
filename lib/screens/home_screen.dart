import 'package:flutter/material.dart';

import '../models/tarefa.dart';
import '../services/auth_service.dart';
import '../services/firebase_service.dart';
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
        child: StreamBuilder<List<Tarefa>>(
          stream: FirebaseService(user.uid).streamTarefas(),
          builder: (context, snapshot) {
            final tarefas = snapshot.data ?? [];
            final concluidas = tarefas.where((t) => t.concluida).length;
            final pendentes = tarefas.length - concluidas;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Olá, ${user.displayName ?? 'usuário'}!',
                    style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _Contador('Total', tarefas.length, Icons.list_alt, Colors.indigo),
                    _Contador('Pendentes', pendentes, Icons.hourglass_bottom, Colors.orange),
                    _Contador('Concluídas', concluidas, Icons.check_circle, Colors.green),
                  ],
                ),
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
            );
          },
        ),
      ),
    );
  }
}

class _Contador extends StatelessWidget {
  final String rotulo;
  final int valor;
  final IconData icone;
  final Color cor;
  const _Contador(this.rotulo, this.valor, this.icone, this.cor);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              Icon(icone, color: cor, size: 32),
              const SizedBox(height: 8),
              Text('$valor', style: Theme.of(context).textTheme.headlineMedium),
              Text(rotulo),
            ],
          ),
        ),
      ),
    );
  }
}
