import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:logging/logging.dart';
import 'package:cookie_app/types/map/mapPosition_info.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';

class MapProvider with ChangeNotifier {
  Logger logger = Logger('MapProvider');
  LatLng _currentLocation = const LatLng(37.5665, 126.9780);
  List<MapPosition> _mapLog = [];
  bool _loading = true;

  LatLng get currentLocation => _currentLocation;
  List get mapLog => _mapLog;
  bool get loading => _loading;

  MapProvider() {
    _locationPermission();
    _getUserLocation();
    _getMapData();
  }

  void setCurrentLocation(LatLng location) {
    _currentLocation = location;
    _loading = false;
    notifyListeners();
    logger.info("mapProvider = $_currentLocation");
  }

  Future<void> _getMapData() async {
    //TODO: get data from server
    _mapLog = [];
    notifyListeners();
  }

  Future<void> _locationPermission() async {
    final PermissionStatus requestStatus = await Permission.location.request();
    final PermissionStatus status = await Permission.location.status;

    if (requestStatus.isGranted && status.isLimited) {
      await _handleLimitedPermission();
    } else if (requestStatus.isPermanentlyDenied ||
        status.isPermanentlyDenied) {
      _requestPermanentPermission();
    } else if (status.isRestricted) {
      _requestRestrictedPermission();
    }
  }

  Future<void> _handleLimitedPermission() async {
    final bool isLocationServiceEnabled =
        await Permission.locationWhenInUse.serviceStatus.isEnabled;

    if (isLocationServiceEnabled) {
      _getUserLocation();
    } else {
      // TODO: 위치 서비스가 꺼져 있는 경우 처리할 내용 추가
    }
  }

  void _requestPermanentPermission() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      openAppSettings();
    });
  }

  void _requestRestrictedPermission() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      openAppSettings();
    });
  }

  Future<void> _getUserLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      _currentLocation = LatLng(position.latitude, position.longitude);
      setCurrentLocation(_currentLocation);
      notifyListeners();
      logger.info("currentLocation = $_currentLocation");
    } catch (e) {
      logger.warning("Failed to get user location: $e");
    }
  }
}
