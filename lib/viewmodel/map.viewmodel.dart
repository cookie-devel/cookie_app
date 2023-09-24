import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:logging/logging.dart';
import 'package:cookie_app/types/map/mapPosition_info.dart';
import 'dart:async';

class MapProvider with ChangeNotifier {
  Logger logger = Logger('MapProvider');
  LatLng _currentLocation = const LatLng(0, 0);
  late List<MapPosition> _mapLog = [];
  bool _loading = true;

  LatLng get currentLocation => _currentLocation;
  List get mapLog => _mapLog;
  bool get loading => _loading;

  MapProvider() {
    _getMapData();
  }

  void setCurrentLocation(double latitude, double longitude) {
    _currentLocation = LatLng(latitude, longitude);
    _loading = false;
    notifyListeners();
    logger.info("mapProvider = $_currentLocation");
  }

  Future<void> _getMapData() async {
    //TODO: get data from server
    _mapLog = [];
    notifyListeners();
    logger.info("mapLog = $_mapLog");
  }
}
