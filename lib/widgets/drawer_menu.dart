import 'package:flutter/material.dart';

import '../services/auth_service.dart';

class DrawerMenu extends StatelessWidget {
  const DrawerMenu({super.key});

  void _ir(BuildContext context, String rota) {
    Navigator.pop(context);
    Navigator.pushNamedAndRemoveUntil(context, rota, (r) => false);
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthService().usuarioAtual;
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(user?.displayName ?? 'Usuário'),
            accountEmail: Text(user?.email ?? ''),
            currentAccountPicture: CircleAvatar(
              child: Text(
                (user?.displayName?.isNotEmpty ?? false)
                    ? user!.displayName![0].toUpperCase()
                    : '?',
                style: const TextStyle(fontSize: 28),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Início'),
            onTap: () => _ir(context, '/'),
          ),
          ListTile(
            leading: const Icon(Icons.checklist),
            title: const Text('Minhas tarefas'),
            onTap: () => _ir(context, '/tarefas'),
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Configurações'),
            onTap: () => _ir(context, '/configuracoes'),
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('Sobre o aplicativo'),
            onTap: () {
              Navigator.pop(context);
              showAboutDialog(
                context: context,
                applicationName: 'Minhas Tarefas',
                applicationVersion: '1.0.0',
                applicationIcon: const Icon(Icons.checklist, size: 40),
                children: const [
                  Text('Aplicativo de gerenciamento de tarefas desenvolvido '
                      'com Flutter e Firebase para a disciplina de Programação Mobile.'),
                ],
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Sair'),
            onTap: () async {
              Navigator.pop(context);
              await AuthService().logout();
              if (context.mounted) {
                Navigator.pushNamedAndRemoveUntil(context, '/', (r) => false);
              }
            },
          ),
        ],
      ),
    );
  }
}
