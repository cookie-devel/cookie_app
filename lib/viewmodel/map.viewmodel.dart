import 'package:flutter/material.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart';

import 'package:cookie_app/model/account/account.dart';
import 'package:cookie_app/service/account.service.dart';
import 'package:cookie_app/service/auth.service.dart';
import 'package:cookie_app/types/map/mapPosition_info.dart';
import 'package:cookie_app/utils/logger.dart';
import 'package:cookie_app/utils/navigation_service.dart';

class MapEvents {
  static const position = 'position';
}

class MapViewModel with ChangeNotifier {
  BuildContext context = NavigationService.navigatorKey.currentContext!;

  // socket
  final Socket socket = io(
    '${dotenv.env['BASE_URI']}/location',
    OptionBuilder()
        .setTransports(['websocket'])
        .disableAutoConnect()
        .enableReconnection()
        .build(),
  );

  // socket connection
  bool _connected = false;
  bool get connected => _connected;

  Function get connect => socket.connect;
  Function get disconnect => socket.disconnect;

  // map log
  List<MarkerInfo> _mapLog = [];
  List<MarkerInfo> get mapLog => _mapLog;

  // current location
  LatLng _currentLocation = const LatLng(37.282053, 127.043546);
  LatLng get currentLocation => _currentLocation;

  // map loading
  bool _loading = true;
  bool get loading => _loading;

  MapViewModel() {
    // socket.auth = {'token': JWTRepository.token!};
    socket.auth = {'token': context.read<AuthService>().token};

    socket.onConnect(_onConnectionChange);
    socket.onDisconnect(_onConnectionChange);
    socket.on(MapEvents.position, _onPosition);
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
    AccountModel? friendInfo =
        Provider.of<AccountService>(context, listen: false).getFriend(userid)
            as AccountModel?;

    bool userExists = _mapLog.any((element) => element.info.id == userid);

    if (userExists) {
      _mapLog = _mapLog.map((element) {
        if (element.info.id == userid) {
          return MarkerInfo(
            info: friendInfo!,
            latitude: info.latitude,
            longitude: info.longitude,
          );
        }
        return element;
      }).toList();
    } else {
      _mapLog.add(
        MarkerInfo(
          info: friendInfo!,
          latitude: info.latitude,
          longitude: info.longitude,
        ),
      );
    }
    notifyListeners();
  }
}
