import 'package:flutter/material.dart';
import 'package:cookie_app/utils/storage.dart';

/*
 다크모드/라이트모드를 설정하는 Provider
*/

final themeStorage = Storage("theme.json");

class ThemeProvider with ChangeNotifier {
  bool _isDarkModeEnabled = false;

  bool get isDarkModeEnabled => _isDarkModeEnabled;

  ThemeProvider() {
    _loadFromStorage();
  }

  void _loadFromStorage() async {
    Map<String, dynamic> data = await themeStorage.readJSON();
    if (data.containsKey("darktheme")) {
      _isDarkModeEnabled = data["darktheme"];
    }
    notifyListeners();
  }

  void toggleDarkMode() {
    _isDarkModeEnabled = !_isDarkModeEnabled;
    _update();
    notifyListeners();
  }

  void _update() async {
    await themeStorage.writeJSON(
      {
        "darktheme": _isDarkModeEnabled,
      },
    );
  }
}
