import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talksy/themes/light_mode.dart';
import 'package:talksy/themes/dark_mode.dart';

class ThemeProvider extends ChangeNotifier {
  static const String _themePrefKey = 'isDarkMode';
  ThemeData _themeData = lightMode;

  ThemeProvider() {
    _loadTheme();
  }

  ThemeData get themeData => _themeData;
  bool get isDarkMode => _themeData == darkMode;

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool(_themePrefKey) ?? false;
    _themeData = isDark ? darkMode : lightMode;
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();
    if (_themeData == lightMode) {
      _themeData = darkMode;
      await prefs.setBool(_themePrefKey, true);
    } else {
      _themeData = lightMode;
      await prefs.setBool(_themePrefKey, false);
    }
    notifyListeners();
  }
}
