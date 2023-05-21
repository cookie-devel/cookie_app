import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapProvider with ChangeNotifier {
  String _mapStyleLight = '';
  String _mapStyleDark = '';
  LatLng _currentLocation = const LatLng(37.5665, 126.9780);
  List _mapLog = [];

  String get mapStyleLight => _mapStyleLight;
  String get mapStyleDark => _mapStyleDark;
  LatLng get currentLocation => _currentLocation;
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  void _loadDarkMapStyle() async {
    rootBundle.loadString('assets/data/mapStyleDark.json').then((string) {
      _mapStyleDark = string;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  void setCurrentLocation(LatLng location) {
    _currentLocation = location;
    notifyListeners();
    print("mapProvider = $_currentLocation");
  }

  Future<void> _getSampleData() async {
    String jsonString = await rootBundle.loadString('assets/data/map.json');
    _mapLog = json.decode(jsonString)["result"];
    notifyListeners();
  }
}
