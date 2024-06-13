import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  Locale locale = const Locale('fr');
  ThemeMode themeMode = ThemeMode.system;

  void changeLanguage() {
    if (locale == const Locale('en')) {
      locale = const Locale('fr');
    } else {
      locale = const Locale('en');
    }
    notifyListeners();
  }

  void followTheSystem() {
    if (themeMode != ThemeMode.dark) {
      themeMode = ThemeMode.system;
      notifyListeners();
    }
  }

  void setLightTheme() {
    if (themeMode != ThemeMode.light) {
      themeMode = ThemeMode.light;
      notifyListeners();
    }
  }

  void setDarkTheme() {
    if (themeMode != ThemeMode.dark) {
      themeMode = ThemeMode.dark;
      notifyListeners();
    }
  }
}
