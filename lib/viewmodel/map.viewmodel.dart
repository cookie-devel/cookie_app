import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:latlong2/latlong.dart' as l2;
import 'package:socket_io_client/socket_io_client.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cookie_app/utils/logger.dart';
import 'package:cookie_app/utils/navigation_service.dart';
import 'package:cookie_app/types/map/mapPosition_info.dart';
import 'package:cookie_app/view/components/map/marker_design.dart';

class MapEvents {
  static const position = 'position';
}

class MapViewModel with ChangeNotifier {
  MapViewModel(String token) {
    socket.auth = {'token': token};
    socket.onConnect(_onConnectionChange);
    socket.onDisconnect(_onConnectionChange);
    socket.on(MapEvents.position, _onPosition);
  }

  BuildContext context = NavigationService.navigatorKey.currentContext!;
  final l2.Distance distance = const l2.Distance();

  // socket
  final Socket socket = io(
    '${dotenv.env['BASE_URI']}/location',
    OptionBuilder().setTransports(['websocket']).enableReconnection().build(),
  );

  // socket connection
  bool _connected = false;
  bool get connected => _connected;

  Function get connect => socket.connect;
  Function get disconnect => socket.disconnect;

  // map log
  List<MarkerInfo> _mapLog = [];
  List<MarkerInfo> get mapLog => _mapLog;

  // marker
  final Set<Marker> _markers = {};
  Set<Marker> get markers => _markers;

  // current location
  LatLng _currentLocation = const LatLng(37.282053, 127.043546);
  LatLng get currentLocation => _currentLocation;

  // map loading
  bool _loading = true;
  bool get loading => _loading;

  // background location running
  bool _isLocationUpdateRunning = false;
  bool get isLocationUpdateRunning => _isLocationUpdateRunning;

  void setLocationUpdateRunning(bool value) {
    _isLocationUpdateRunning = value;
    notifyListeners();
  }

  // background initPlatformState
  bool _isInitPlatformState = false;
  bool get isInitPlatformState => _isInitPlatformState;

  void setInitPlatformState(bool value) {
    _isInitPlatformState = value;
    notifyListeners();
  }

  // set current location
  void setCurrentLocation(double latitude, double longitude) {
    _currentLocation = LatLng(latitude, longitude);
    _loading = false;
    notifyListeners();
    logger.t("MapViewModel = $_currentLocation");
  }

  // Socket Incoming Event Handlers
  void _onConnectionChange(_) {
    _connected = socket.connected;
    socket.connected
        ? logger.t('socket connected')
        : logger.w('socket not connected');
    notifyListeners();
  }

  void position() {
    socket.emit(
      MapEvents.position,
      MapInfoRequest(
        latitude: _currentLocation.latitude,
        longitude: _currentLocation.longitude,
      ).toJson(),
    );
  }

  void _onPosition(data) {
    logger.t("position: $data");

    final MapInfoResponse info = MapInfoResponse.fromJson(data);
    String userid = info.userid;
    // String userid = 'testid2';

    bool userExists = _mapLog.any((element) => element.userid == userid);

    if (userExists) {
      _mapLog = _mapLog.map((element) {
        if (element.userid == userid) {
          return MarkerInfo(
            userid: userid,
            latitude: info.latitude,
            longitude: info.longitude,
          );
        }
        return element;
      }).toList();
    } else {
      _mapLog.add(
        MarkerInfo(
          userid: userid,
          latitude: info.latitude,
          longitude: info.longitude,
        ),
      );
    }
    logger.t("position updated");
    _updateMarkers();
    notifyListeners();
  }

  Future<void> _updateMarkers() async {
    _markers.clear();
    final List<Future<Marker>> markerFutures =
        _mapLog.map((element) => addMarker(context, element)).toList();
    final List<Marker> markers = await Future.wait(markerFutures);
    _markers.addAll(markers);
    logger.t("markers updated");

    if (markers.isNotEmpty) {
      notifyListeners();
    }
  }


  // 두 좌표 간 거리계산
  String calDistance(LatLng friendLocation) {
    final latLong1 =
        l2.LatLng(_currentLocation.latitude, _currentLocation.longitude);
    final latLong2 =
        l2.LatLng(friendLocation.latitude, friendLocation.longitude);
    final dist = distance(latLong1, latLong2);

    final double distanceInMeters = dist < 1000 ? dist : dist / 1000;
    final String distanceString =
        distanceInMeters.toStringAsFixed(distanceInMeters < 10 ? 1 : 0);
    final String unit = dist < 1000 ? 'm' : 'km';

    return '$distanceString $unit';
  }
}
