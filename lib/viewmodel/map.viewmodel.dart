import 'package:flutter/material.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart';

import 'package:cookie_app/model/account/account_info.dart';
import 'package:cookie_app/repository/jwt.repo.dart';
import 'package:cookie_app/types/map/mapPosition_info.dart';
import 'package:cookie_app/view/navigation_service.dart';
import 'package:cookie_app/viewmodel/friends.viewmodel.dart';

class MapEvents {
  static const getPosition = 'get_position';
  static const sendPosition = 'send_position';
}

class MapProvider with ChangeNotifier {
  Logger logger = Logger('MapProvider');

  final Socket socket = io(
    Uri(
      scheme: dotenv.env['API_SCHEME'],
      host: dotenv.env['API_HOST'],
      port: int.parse(dotenv.env['API_PORT']!),
      path: '/map',
    ).toString(),
    OptionBuilder()
        .setTransports(['websocket'])
        .disableAutoConnect()
        .enableReconnection()
        .build(),
  );

  bool _connected = false;
  bool get connected => _connected;

  Function get connect => socket.connect;
  Function get disconnect => socket.disconnect;

  final List<MarkerInfo> _mapLog = [];
  LatLng _currentLocation = const LatLng(0, 0);
  bool _loading = true;

  List<MarkerInfo> get mapLog => _mapLog;
  LatLng get currentLocation => _currentLocation;
  bool get loading => _loading;

  MapProvider() {
    socket.auth = {'token': JWTRepository.token!};

    socket.onConnect(_onConnectionChange);
    socket.onDisconnect(_onConnectionChange);
    socket.on(MapEvents.getPosition, _onGetPosition);
    socket.on(MapEvents.sendPosition, _onSendPosition);
  }

  void setCurrentLocation(double latitude, double longitude) {
    _currentLocation = LatLng(latitude, longitude);
    _loading = false;
    notifyListeners();
    logger.info("mapProvider = $_currentLocation");
  }

  // Socket Incoming Event Handlers
  void _onConnectionChange(_) {
    _connected = socket.connected;
    socket.connected
        ? logger.info('socket connected')
        : logger.warning('socket not connected');
    notifyListeners();
  }

  void _onSendPosition(_) {
    logger.info("send_position");
    socket.emit(MapEvents.sendPosition, {
      'latitude': _currentLocation.latitude,
      'longitude': _currentLocation.longitude,
    });
  }

  BuildContext context = NavigationService.navigatorKey.currentContext!;
  void _onGetPosition(data) {
    logger.info("get_position: $data");

    final List<MapInfoResponse> info =
        data.map((e) => MapInfoResponse.fromJson(e)).toList();

    final List<MarkerInfo> mapLog = info
        .map(
          (e) => MarkerInfo(
            info: Provider.of<FriendsViewModel>(context, listen: false)
                .getFriend(e.userid) as PublicAccountModel,
            latitude: e.latitude,
            longitude: e.longitude,
          ),
        )
        .toList();
    notifyListeners();
  }
}
