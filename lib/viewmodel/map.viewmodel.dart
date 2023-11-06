import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cookie_app/types/map/mapPosition_info.dart';

class MapViewModel with ChangeNotifier {
  // mapLog
  List<MarkerInfo> _mapLog = [];
  List<MarkerInfo> get mapLog => _mapLog;
  set mapLog(List<MarkerInfo> value) {
    _mapLog = value;
    notifyListeners();
  }

  // markers
  final Set<Marker> _markers = {};
  Set<Marker> get markers => _markers;
  set markers(Set<Marker> value) {
    _markers.clear();
    _markers.addAll(value);
    notifyListeners();
  }

  // current location
  LatLng _currentLocation = const LatLng(37.282053, 127.043546);
  LatLng get currentLocation => _currentLocation;
  set currentLocation(LatLng value) {
    _currentLocation = value;
    notifyListeners();
  }

  // map loading
  bool _loading = true;
  bool get loading => _loading;
  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  // background location running
  bool _isLocationUpdateRunning = false;
  bool get isLocationUpdateRunning => _isLocationUpdateRunning;
  set isLocationUpdateRunning(bool value) {
    _isLocationUpdateRunning = value;
    notifyListeners();
  }

  // background initPlatformState
  bool _isInitPlatformState = false;
  bool get isInitPlatformState => _isInitPlatformState;
  set isInitPlatformState(bool value) {
    _isInitPlatformState = value;
    notifyListeners();
  }
}
