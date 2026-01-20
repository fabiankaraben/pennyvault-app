import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _themeKey = 'theme_mode';

  Future<void> saveThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, mode.toString());
  }

  Future<ThemeMode> getThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final modeStr = prefs.getString(_themeKey);
    if (modeStr == null) return ThemeMode.system;
    return ThemeMode.values.firstWhere(
      (e) => e.toString() == modeStr,
      orElse: () => ThemeMode.system,
    );
  }
}
