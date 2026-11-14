import 'package:flutter/material.dart';

import '../models/tarefa.dart';
import '../services/auth_service.dart';
import '../services/firebase_service.dart';
import '../widgets/drawer_menu.dart';
import 'cadastro_tarefa_screen.dart';

String formatarData(DateTime d) =>
    '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

Color corPrioridade(String p) {
  switch (p) {
    case 'Alta':
      return Colors.red;
    case 'Média':
      return Colors.orange;
    default:
      return Colors.green;
  }
}

IconData iconePrioridade(String p) {
  switch (p) {
    case 'Alta':
      return Icons.keyboard_double_arrow_up;
    case 'Média':
      return Icons.drag_handle;
    default:
      return Icons.keyboard_arrow_down;
  }
}

class TarefasScreen extends StatelessWidget {
  const TarefasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final service = FirebaseService(AuthService().usuarioAtual!.uid);
    return Scaffold(
      appBar: AppBar(title: const Text('Minhas tarefas')),
      drawer: const DrawerMenu(),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text('Nova tarefa'),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CadastroTarefaScreen()),
        ),
      ),
      body: StreamBuilder<List<Tarefa>>(
        stream: service.streamTarefas(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final tarefas = snapshot.data!;
          if (tarefas.isEmpty) {
            return const Center(child: Text('Nenhuma tarefa cadastrada.'));
          }
          return ListView.builder(
            padding: const EdgeInsets.only(bottom: 88),
            itemCount: tarefas.length,
            itemBuilder: (context, i) {
              final t = tarefas[i];
              final cor = corPrioridade(t.prioridade);
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: cor.withOpacity(0.15),
                    child: Icon(iconePrioridade(t.prioridade), color: cor),
                  ),
                  title: Text(
                    t.titulo,
                    style: TextStyle(
                      decoration: t.concluida ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  subtitle: Text(
                      'Vence em ${formatarData(t.dataVencimento)} • ${t.prioridade} • ${t.situacao}'),
                  trailing: Checkbox(
                    value: t.concluida,
                    onChanged: (_) => service.alterarSituacao(t),
                  ),
                  onTap: () => _mostrarDetalhes(context, t, service),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _mostrarDetalhes(BuildContext context, Tarefa t, FirebaseService service) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(t.titulo),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(t.descricao.isEmpty ? '(sem descrição)' : t.descricao),
            const SizedBox(height: 12),
            Text('Vencimento: ${formatarData(t.dataVencimento)}'),
            Text('Prioridade: ${t.prioridade}'),
            Text('Situação: ${t.situacao}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final confirmar = await showDialog<bool>(
                context: context,
                builder: (c) => AlertDialog(
                  title: const Text('Excluir tarefa?'),
                  content: const Text('Esta ação não pode ser desfeita.'),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(c, false),
                        child: const Text('Cancelar')),
                    FilledButton(
                        onPressed: () => Navigator.pop(c, true),
                        child: const Text('Excluir')),
                  ],
                ),
              );
              if (confirmar == true) await service.excluir(t.id);
            },
            child: const Text('Excluir'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => CadastroTarefaScreen(tarefa: t)),
              );
            },
            child: const Text('Editar'),
          ),
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Fechar')),
        ],
      ),
    );
  }
}
