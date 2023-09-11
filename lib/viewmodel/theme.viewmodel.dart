import 'package:cookie_app/theme/dark.dart';
import 'package:cookie_app/theme/default.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';

/*
 다크모드/라이트모드를 설정하는 Provider
*/
class ThemeProvider with ChangeNotifier {
  bool _isDarkMode = false;
  String _mapStyle = '';

  bool get isDarkMode => _isDarkMode;
  String get mapStyle => _mapStyle;
  ThemeData get theme => _isDarkMode ? darkThemeData : defaultThemeData;

  ThemeProvider() {
    _loadFromStorage();
  }

  void _loadFromStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("darktheme")) {
      setDarkMode(prefs.getBool("darktheme")!);
    }
  }

  void setDarkMode(bool value) async {
    _isDarkMode = value;
    _mapStyle = await rootBundle.loadString(
      value ? 'assets/data/mapStyleDark.json' : 'assets/data/mapStyle.json',
    );
    _update();
    notifyListeners();
  }

  void _update() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("darktheme", _isDarkMode);
  }
}
