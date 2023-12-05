import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:cookie_app/utils/logger.dart';
import 'package:cookie_app/utils/navigation_service.dart';
import 'package:cookie_app/view/components/snackbar.dart';
import 'package:cookie_app/types/map/map_position_info.dart';
import 'package:cookie_app/viewmodel/map/marker.viewmodel.dart';
import 'package:cookie_app/view/components/map/marker_design.dart';

class MapViewModel with ChangeNotifier {
  MapViewModel() {
    _getUserLocation();
  }

  BuildContext context = NavigationService.navigatorKey.currentContext!;

  // mapController
  late GoogleMapController mapController;

  // mapLog
  List<MarkerViewModel> _mapLog = [];
  List<MarkerViewModel> get mapLog => _mapLog;
  set mapLog(List<MarkerViewModel> value) {
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
  LatLng _currentLocation = const LatLng(37.2820, 127.0435);
  LatLng getCurrentLocation() {
    _getUserLocation();
    return _currentLocation;
  }

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

  Future<void> _getUserLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      LatLng currentLoc = LatLng(position.latitude, position.longitude);
      currentLocation = currentLoc;
      notifyListeners();
    } catch (e) {
      logger.t(e);
    }
  }

  Future<void> updateMarkers(MapInfoResponse info) async {
    if (!isLocationUpdateRunning) {
      mapLog = [];
      markers = {};
      notifyListeners();
      return;
    }

    MarkerViewModel marker = MarkerViewModel(model: info);

    // if user is sharing location, notify user sharing
    if (info.latitude == 0 && info.longitude == 0) {
      showSnackBar(
        context,
        '${marker.name}님이 위치공유를 시작했습니다.',
        icon: const Icon(
          Icons.info,
          color: Colors.blue,
        ),
      );
      return;
    }

    // if user is not sharing location, remove marker
    if (info.latitude == -1 && info.longitude == -1) {
      mapLog.removeWhere(
        (element) => element.id == marker.id,
      );
      notifyListeners();
      return;
    }

    if (marker.exist) {
      mapLog = mapLog.map((element) {
        if (element.id == marker.id) {
          return marker;
        }
        return element;
      }).toList();
      notifyListeners();
    } else {
      mapLog.add(marker);
      notifyListeners();
    }

    final List<Future<Marker>> markerFutures = mapLog
        .map(
          (element) => addMarker(
            context,
            element,
          ),
        )
        .toList();
    final List<Marker> tmpMarker = await Future.wait(markerFutures);

    if (context.mounted) markers = tmpMarker.toSet();

    if (tmpMarker.isNotEmpty) {
      notifyListeners();
    }
    logger.t("markers updated");
  }

  void moveCamera(LatLng location) {
    mapController.animateCamera(CameraUpdate.newLatLng(location));
  }

  void moveToCurrentLocation() {
    mapController.animateCamera(CameraUpdate.newLatLng(getCurrentLocation()));
  }
}
