import 'package:cookie_app/viewmodel/map.viewmodel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:latlong2/latlong.dart' as l2;
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cookie_app/utils/logger.dart';
import 'package:cookie_app/utils/navigation_service.dart';
import 'package:cookie_app/view/components/map/marker_design.dart';
import 'package:cookie_app/types/map/mapPosition_info.dart';

class MapEvents {
  static const position = 'position';
}

class MapService extends ChangeNotifier with DiagnosticableTreeMixin {
  BuildContext context = NavigationService.navigatorKey.currentContext!;
  final l2.Distance distance = const l2.Distance();

  // socket connection
  bool _connected = false;
  bool get connected => _connected;

  Function get connect => socket.connect;
  Function get disconnect => socket.disconnect;

  MapService(String token) {
    socket.auth = {'token': token};
    socket.onConnect(_onConnectionChange);
    socket.onDisconnect(_onConnectionChange);
    socket.on(MapEvents.position, _onPosition);
  }

  // socket
  final Socket socket = io(
    '${dotenv.env['BASE_URI']}/location',
    OptionBuilder().setTransports(['websocket']).enableReconnection().build(),
  );

  // Socket Incoming Event Handlers
  void _onConnectionChange(_) {
    _connected = socket.connected;
    socket.connected
        ? logger.t('socket connected')
        : logger.w('socket not connected');
    notifyListeners();
  }

  // set current location
  void setCurrentLocation(double latitude, double longitude) {
    context.read<MapViewModel>().currentLocation = LatLng(latitude, longitude);
    context.read<MapViewModel>().loading = false;
    notifyListeners();
  }

  void position(LatLng position) {
    socket.emit(
      MapEvents.position,
      MapInfoRequest(
        latitude: position.latitude,
        longitude: position.longitude,
      ).toJson(),
    );
  }

  void _onPosition(data) {
    final MapInfoResponse userInfo = MapInfoResponse.fromJson(data);
    _updateMarkers(userInfo);
    logger.t("position sended: $data");
  }

  Future<void> _updateMarkers(MapInfoResponse info) async {
    bool userExists = context
        .read<MapViewModel>()
        .mapLog
        .any((element) => element.userid == info.userid);

    if (userExists) {
      context.read<MapViewModel>().mapLog =
          context.read<MapViewModel>().mapLog.map((element) {
        if (element.userid == info.userid) {
          return MarkerInfo(
            userid: info.userid,
            latitude: info.latitude,
            longitude: info.longitude,
          );
        }
        return element;
      }).toList();
    } else {
      context.read<MapViewModel>().mapLog.add(
            MarkerInfo(
              userid: info.userid,
              latitude: info.latitude,
              longitude: info.longitude,
            ),
          );
    }

    final List<Future<Marker>> markerFutures = context
        .read<MapViewModel>()
        .mapLog
        .map((element) => addMarker(context, element))
        .toList();
    final List<Marker> tmpMarker = await Future.wait(markerFutures);

    context.read<MapViewModel>().markers = tmpMarker.toSet();
    logger.t("markers updated");

    if (tmpMarker.isNotEmpty) {
      notifyListeners();
    }
  }

  // 두 좌표 간 거리계산
  String calDistance(LatLng friendLocation) {
    final position = context.read<MapViewModel>().currentLocation;
    final latLong1 = l2.LatLng(position.latitude, position.longitude);
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
