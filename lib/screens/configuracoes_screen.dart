import 'package:flutter/material.dart';

import '../themes/app_theme.dart';

class ConfiguracoesScreen extends StatelessWidget {
  const ConfiguracoesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configurações')),
      body: ListenableBuilder(
        listenable: themeController,
        builder: (context, _) => ListView(
          children: [
            SwitchListTile(
              secondary: const Icon(Icons.dark_mode),
              title: const Text('Tema escuro'),
              subtitle: const Text('A escolha é salva e mantida ao reabrir o app'),
              value: themeController.isDark,
              onChanged: (v) => themeController.definirEscuro(v),
            ),
          ],
        ),
      ),
    );
  }
}
