import 'package:cookie_app/datasource/storage/theme.storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

/*
 다크모드/라이트모드를 설정하는 Provider
*/

final themeStorage = ThemeStorage();

class ThemeProvider with ChangeNotifier {
  bool _isDarkModeEnabled = false;
  String _mapStyleLight = '';
  String _mapStyleDark = '';
  
  bool get isDarkModeEnabled => _isDarkModeEnabled;
  String get mapStyleLight => _mapStyleLight;
  String get mapStyleDark => _mapStyleDark;
  
  ThemeProvider() {
    _loadFromStorage();
    _loadLightMapStyle();
    _loadDarkMapStyle();
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

    // 밝은 지도 테마 load
  void _loadLightMapStyle() async {
    final string = await rootBundle.loadString('assets/data/mapStyle.json');
    _mapStyleLight = string;
    notifyListeners();
  }

  // 어두운 지도 테마 load
  void _loadDarkMapStyle() async {
    final string = await rootBundle.loadString('assets/data/mapStyleDark.json');
    _mapStyleDark = string;
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
