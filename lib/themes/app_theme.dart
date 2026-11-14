import 'package:flutter/material.dart';

import '../services/preferences_service.dart';

class AppTheme {
  static const Color _seed = Color(0xFF3F51B5);

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorSchemeSeed: _seed,
    inputDecorationTheme: const InputDecorationTheme(border: OutlineInputBorder()),
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorSchemeSeed: _seed,
    inputDecorationTheme: const InputDecorationTheme(border: OutlineInputBorder()),
  );
}

/// Controla o ThemeMode e persiste a escolha com SharedPreferences.
class ThemeController extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  ThemeMode get themeMode => _themeMode;
  bool get isDark => _themeMode == ThemeMode.dark;

  Future<void> carregar() async {
    final escuro = await PreferencesService.carregarTemaEscuro();
    _themeMode = escuro ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  Future<void> definirEscuro(bool escuro) async {
    _themeMode = escuro ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
    await PreferencesService.salvarTemaEscuro(escuro);
  }
}

final ThemeController themeController = ThemeController();
