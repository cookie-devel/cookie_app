import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:logging/logging.dart';
import 'package:cookie_app/types/map/mapPosition_info.dart';

class MapProvider with ChangeNotifier {
  Logger logger = Logger('MapProvider');
  LatLng _currentLocation = const LatLng(37.5665, 126.9780);
  List<MapPosition> _mapLog = [];

  LatLng get currentLocation => _currentLocation;
  List get mapLog => _mapLog;

  MapProvider() {
    _getMapData();
  }

  void setCurrentLocation(LatLng location) {
    _currentLocation = location;
    notifyListeners();
    logger.info("mapProvider = $_currentLocation");
  }

  Future<void> _getMapData() async {
    //TODO: get data from server
    _mapLog = [];
    notifyListeners();
  }
}
