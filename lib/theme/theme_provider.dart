import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  bool _isDarkMode = false;

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _isDarkMode;

  ThemeProvider() {
    _loadThemeMode();
  }

  void toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    _themeMode = _isDarkMode ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
    await _saveThemeMode();
  }

  void setDarkMode(bool isDark) async {
    _isDarkMode = isDark;
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
    await _saveThemeMode();
  }

  Future<void> _loadThemeMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isDarkMode = prefs.getBool('isDarkMode') ?? false;
      _themeMode = _isDarkMode ? ThemeMode.dark : ThemeMode.light;
      notifyListeners();
    } catch (e) {
      // En cas d'erreur, utiliser le thème clair par défaut
      _isDarkMode = false;
      _themeMode = ThemeMode.light;
    }
  }

  Future<void> _saveThemeMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isDarkMode', _isDarkMode);
    } catch (e) {
      print('Erreur lors de la sauvegarde du thème: $e');
    }
  }
}