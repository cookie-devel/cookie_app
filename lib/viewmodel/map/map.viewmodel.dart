import 'package:cookie_app/view/components/dialog.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:cookie_app/utils/logger.dart';
import 'package:cookie_app/utils/navigation_service.dart';
import 'package:cookie_app/view/components/snackbar.dart';
import 'package:cookie_app/types/map/map_position_info.dart';
import 'package:cookie_app/viewmodel/map/marker.viewmodel.dart';
import 'package:cookie_app/view/components/map/marker_design.dart';

class MapRequestType {
  static const startShare = LatLng(0, 0);
  static const endShare = LatLng(-1, -1);
  static const posReq = LatLng(-2, -2);
}

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
  LatLng get currentLocation => getCurrentLocation();
  LatLng getCurrentLocation() {
    _getUserLocation();
    return _currentLocation;
  }

  set currentLocation(LatLng value) {
    _currentLocation = value;
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
    if (marker.position == MapRequestType.startShare) {
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
    if (marker.position == MapRequestType.endShare) {
      mapLog.removeWhere(
        (element) => element.id == marker.id,
      );
      markers.removeWhere(
        (element) => element.markerId.value == marker.id,
      );
      notifyListeners();
      return;
    }

    // if user sended location sharing request, notify user
    if (marker.position == MapRequestType.posReq) {
      showDialog(
        context: context,
        builder: (context) => Alert(
          title: "위치 공유",
          content: "${marker.name}님에게 위치 공유 요청이 왔어요.",
          onCancel: () {
            Navigator.of(context).pop();
          },
          onConfirm: () {
            // TODO: additional function
            Navigator.of(context).pop();
          },
        ),
      );
      return;
    }

    bool shouldNotify = false;

    if (marker.exist) {
      for (int i = 0; i < mapLog.length; i++) {
        if (mapLog[i].id == marker.id) {
          mapLog[i] = marker;
          shouldNotify = true;
          break;
        }
      }
    } else {
      mapLog.add(marker);
      shouldNotify = true;
    }

    if (shouldNotify) {
      notifyListeners();
    }

    final List<Marker> tmpMarker = [];

    for (final element in mapLog) {
      tmpMarker.add(await addMarker(context, element));
    }

    if (context.mounted && tmpMarker.isNotEmpty) {
      markers = tmpMarker.toSet();
      notifyListeners();
    }
  }

  void moveCamera(LatLng location) {
    mapController.animateCamera(CameraUpdate.newLatLng(location));
  }

  void moveToCurrentLocation() {
    mapController.animateCamera(CameraUpdate.newLatLng(currentLocation));
  }
}
