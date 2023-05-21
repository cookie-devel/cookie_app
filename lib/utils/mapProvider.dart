import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

class MapProvider with ChangeNotifier {
  String _mapStyleLight = '';
  String _mapStyleDark = '';
  List _mapLog = [];

  String get mapStyleLight => _mapStyleLight;
  String get mapStyleDark => _mapStyleDark;
  List get mapLog => _mapLog;

  MapProvider() {
    _loadLightMapStyle();
    _loadDarkMapStyle();
    _getSampleData();
  }

  void _loadLightMapStyle() async {
    rootBundle.loadString('assets/data/mapStyle.json').then((string) {
      _mapStyleLight = string;
    });
    notifyListeners();
  }

  void _loadDarkMapStyle() async {
    rootBundle.loadString('assets/data/mapStyleDark.json').then((string) {
      _mapStyleDark = string;
    });
    notifyListeners();
  }

  // 임시로 json 데이터 생성하여 가져옴
  void _getSampleData() async {
    String jsonString = await rootBundle.loadString('assets/data/map.json');

    _mapLog = json.decode(jsonString)["result"];
  }
}
