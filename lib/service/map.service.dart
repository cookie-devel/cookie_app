import 'package:cookie_app/service/account.service.dart';
import 'package:cookie_app/theme/default.dart';
import 'package:cookie_app/viewmodel/account.viewmodel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:latlong2/latlong.dart' as l2;
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart';

import 'package:cookie_app/types/map/map_position_info.dart';
import 'package:cookie_app/utils/logger.dart';
import 'package:cookie_app/utils/navigation_service.dart';
import 'package:cookie_app/view/components/map/marker_design.dart';
import 'package:cookie_app/view/components/snackbar.dart';
import 'package:cookie_app/viewmodel/map.viewmodel.dart';

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
    if (!context.read<MapViewModel>().isLocationUpdateRunning) {
      context.read<MapViewModel>().mapLog = [];
      context.read<MapViewModel>().markers = {};
      notifyListeners();
      return;
    }

    AccountViewModel friendInfo =
        context.read<AccountService>().getUserById(info.userid);

    bool userExists = context
        .read<MapViewModel>()
        .mapLog
        .any((element) => element.account.id == info.userid);

    // if user is not sharing location, remove marker
    if (info.latitude == 0 && info.longitude == 0) {
      showSnackBar(
        context,
        '${friendInfo.name}님이 위치공유를 시작했습니다.',
        icon: const Icon(
          Icons.info,
          color: Colors.blue,
        ),
      );
    }
    // if user is sharing location, notify user sharing
    else if (info.latitude == -1 && info.longitude == -1) {
      context.read<MapViewModel>().mapLog.removeWhere(
            (element) => element.account.id == info.userid,
          );
    } else {
      if (userExists) {
        context.read<MapViewModel>().mapLog =
            context.read<MapViewModel>().mapLog.map((element) {
          if (element.account.id == info.userid) {
            return MarkerInfo(
              account: friendInfo,
              latitude: info.latitude,
              longitude: info.longitude,
            );
          }
          return element;
        }).toList();
      } else {
        context.read<MapViewModel>().mapLog.add(
              MarkerInfo(
                account: friendInfo,
                latitude: info.latitude,
                longitude: info.longitude,
              ),
            );
      }
    }

    final List<Future<Marker>> markerFutures = context
        .read<MapViewModel>()
        .mapLog
        .map(
          (element) => addMarker(context, element, color: DefaultColor.colorsecondaryOrange),
        )
        .toList();
    final List<Marker> tmpMarker = await Future.wait(markerFutures);

    if (context.mounted)
      context.read<MapViewModel>().markers = tmpMarker.toSet();
    logger.t("markers updated");

    if (tmpMarker.isNotEmpty) {
      notifyListeners();
    }
  }

  String calDistance(LatLng friendLocation) {
    final position = context.read<MapViewModel>().getCurrentLocation();
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

  void moveCamera(LatLng location) {
    context
        .read<MapViewModel>()
        .mapController
        .animateCamera(CameraUpdate.newLatLngZoom(location, 16.0));
  }

  void moveToCurrentLocation() {
    // final isRunning = context.read<MapViewModel>().isLocationUpdateRunning;
    // if (isRunning) {
    final currentLocation = context.read<MapViewModel>().getCurrentLocation();
    context
        .read<MapViewModel>()
        .mapController
        .animateCamera(CameraUpdate.newLatLng(currentLocation));
    // } else {
    //   showSnackBar(
    //     context,
    //     '먼저 위치공유를 시작해주세요.  (메뉴 > 위치 공유)',
    //     icon: const Icon(
    //       Icons.error,
    //       color: Colors.red,
    //     ),
    //   );
    // }
  }
}
