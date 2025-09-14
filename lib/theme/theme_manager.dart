import 'package:flutter/material.dart';

class ThemeManager {
  static final ThemeManager _instance = ThemeManager._internal();
  factory ThemeManager() => _instance;
  ThemeManager._internal();

  VoidCallback? _toggleTheme;

  void setToggleThemeCallback(VoidCallback callback) {
    _toggleTheme = callback;
  }

  void toggleTheme() {
    _toggleTheme?.call();
  }
}