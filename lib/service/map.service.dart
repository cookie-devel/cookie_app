import 'package:cookie_app/service/account.service.dart';
import 'package:cookie_app/theme/default.dart';
import 'package:cookie_app/types/map/map_share_info.dart';
import 'package:cookie_app/view/components/dialog.dart';
import 'package:cookie_app/viewmodel/account.viewmodel.dart';
import 'package:cookie_app/viewmodel/map/marker.viewmodel.dart';
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
import 'package:cookie_app/viewmodel/map/map.viewmodel.dart';

class MapEvents {
  static const position = 'position';
  static const requestShare = 'requestShare';
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
    socket.on(MapEvents.requestShare, _onRequestShare);
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

  void requestShare(String friendId) {
    socket.emit(
      MapEvents.requestShare,
      MapShareInfo(
        userid: friendId,
      ).toJson(),
    );
  }

  void _onRequestShare(data) {
    logger.t("requestShare sended: $data");
    final MapShareInfo user = MapShareInfo.fromJson(data);
    final userId = user.userid;
    final AccountViewModel friendInfo =
        context.read<AccountService>().getUserById(userId);

    showDialog(
      context: context,
      builder: (context) => Alert(
        title: "위치 공유",
        content: "${friendInfo.name}님에게 위치 공유 요청이 왔어요.",
        onCancel: () {
          Navigator.of(context).pop();
        },
        onConfirm: () {
          // TODO: additional function
          Navigator.of(context).pop();
        },
      ),
    );
  }

  Future<void> _updateMarkers(MapInfoResponse info) async {
    if (!context.read<MapViewModel>().isLocationUpdateRunning) {
      context.read<MapViewModel>().mapLog = [];
      context.read<MapViewModel>().markers = {};
      notifyListeners();
      return;
    }

    MarkerViewModel marker = MarkerViewModel(model: info);

    // bool userExists = context
    //     .read<MapViewModel>()
    //     .mapLog
    //     .any((element) => element.account.id == marker.id);

    // if user is not sharing location, remove marker
    if (info.latitude == 0 && info.longitude == 0) {
      showSnackBar(
        context,
        '${marker.name}님이 위치공유를 시작했습니다.',
        icon: const Icon(
          Icons.info,
          color: Colors.blue,
        ),
      );
    }
    // if user is sharing location, notify user sharing
    else if (info.latitude == -1 && info.longitude == -1) {
      context.read<MapViewModel>().mapLog.removeWhere(
            (element) => element.id == marker.id,
          );
    } else {
      if (marker.exist) {
        context.read<MapViewModel>().mapLog =
            context.read<MapViewModel>().mapLog.map((element) {
          if (element.id == marker.id) {
            return marker;
          }
          return element;
        }).toList();
      } else {
        context.read<MapViewModel>().mapLog.add(marker);
      }
    }

    final List<Future<Marker>> markerFutures = context
        .read<MapViewModel>()
        .mapLog
        .map(
          (element) => addMarker(
            context,
            element,
            color: DefaultColor.colorsecondaryOrange,
          ),
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
    final currentLocation = context.read<MapViewModel>().getCurrentLocation();
    context
        .read<MapViewModel>()
        .mapController
        .animateCamera(CameraUpdate.newLatLng(currentLocation));
  }
}
