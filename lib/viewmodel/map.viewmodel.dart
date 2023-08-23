import 'package:cookie_app/repository/api/map.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:logging/logging.dart';

class MapProvider with ChangeNotifier {
  Logger logger = Logger('MapProvider');
  late final mapDataSource _mapDataSource;
  String _mapStyleLight = '';
  String _mapStyleDark = '';
  LatLng _currentLocation = const LatLng(37.5665, 126.9780);
  List _mapLog = [];

  String get mapStyleLight => _mapStyleLight;
  String get mapStyleDark => _mapStyleDark;
  LatLng get currentLocation => _currentLocation;
  List get mapLog => _mapLog;

  MapViewModel() {
    _mapDataSource = mapDataSource();
    _loadLightMapStyle();
    _loadDarkMapStyle();
    _getSampleData();
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

  void setCurrentLocation(LatLng location) {
    _currentLocation = location;
    notifyListeners();
    logger.info("mapProvider = $_currentLocation");
  }

  Future<void> _getSampleData() async {
    _mapLog = await _mapDataSource.getMapData();
    notifyListeners();
  }
}
