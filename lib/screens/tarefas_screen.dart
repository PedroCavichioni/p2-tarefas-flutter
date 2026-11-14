import 'package:flutter/material.dart';

import '../widgets/drawer_menu.dart';

// Placeholder (etapa 7): a tela real é feita na etapa 8.
class TarefasScreen extends StatelessWidget {
  const TarefasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Minhas tarefas')),
      drawer: const DrawerMenu(),
      body: const Center(child: Text('Em breve')),
    );
  }
}
