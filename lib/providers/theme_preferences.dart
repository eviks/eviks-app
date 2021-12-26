import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemePreferences with ChangeNotifier {
  ThemeMode _themeMode;

  ThemePreferences(this._themeMode);

  ThemeMode get themeMode => _themeMode;

  Future<void> setThemePreferences(ThemeMode selectedThemeMode) async {
    _themeMode = selectedThemeMode;
    try {
      final prefs = await SharedPreferences.getInstance();
      prefs.setString(
        'themeMode',
        selectedThemeMode.toString().replaceAll('ThemeMode.', ''),
      );
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
}
