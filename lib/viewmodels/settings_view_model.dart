import 'package:flutter/material.dart';
import '../services/storage_service.dart';

class SettingsViewModel extends ChangeNotifier {
  final StorageService _storageService;
  ThemeMode _themeMode = ThemeMode.system;

  SettingsViewModel(this._storageService) {
    _loadSettings();
  }

  ThemeMode get themeMode => _themeMode;

  Future<void> _loadSettings() async {
    _themeMode = await _storageService.getThemeMode();
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    await _storageService.saveThemeMode(mode);
    notifyListeners();
  }
}
