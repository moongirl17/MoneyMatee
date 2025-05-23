import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeLocalStorage {
  final SharedPreferences _prefs;

  ThemeLocalStorage(this._prefs);

  Future<void> setTheme(ThemeMode theme) async {
    await _prefs.setString('theme', theme.toString());
  }

  ThemeMode getTheme() {
    final themeString = _prefs.getString('theme');
    switch (themeString) {
      case 'ThemeMode.light':
        return ThemeMode.light;
      case 'ThemeMode.dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }
}
