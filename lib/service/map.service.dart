import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:cookie_app/utils/logger.dart';
import 'package:cookie_app/view/components/dialog.dart';
import 'package:cookie_app/service/account.service.dart';
import 'package:cookie_app/types/map/map_share_info.dart';
import 'package:cookie_app/utils/navigation_service.dart';
import 'package:cookie_app/viewmodel/account.viewmodel.dart';
import 'package:cookie_app/viewmodel/map/map.viewmodel.dart';
import 'package:cookie_app/types/map/map_position_info.dart';

class MapEvents {
  static const position = 'position';
  static const requestShare = 'requestShare';
}

class MapService extends ChangeNotifier with DiagnosticableTreeMixin {
  BuildContext context = NavigationService.navigatorKey.currentContext!;

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

  void position(LatLng position, List<String> friendId) {
    socket.emit(
      MapEvents.position,
      MapInfoRequest(
        userid: friendId,
        latitude: position.latitude,
        longitude: position.longitude,
      ).toJson(),
    );
    logger.t("[position sended]\n position: $position \n receiver: $friendId");
  }

  void _onPosition(data) {
    final MapInfoResponse userInfo = MapInfoResponse.fromJson(data);
    context.read<MapViewModel>().updateMarkers(userInfo);
    logger.t(
      "[position received]\n _id: ${userInfo.userid}\n lat: ${userInfo.latitude}\n lon: ${userInfo.longitude}",
    );
  }

  void requestShare(List<String> friendId) {
    for (String id in friendId) {
      socket.emit(
        MapEvents.requestShare,
        MapShareInfo(
          userid: id,
        ).toJson(),
      );
      logger.t("requestShare sended: $id");
    }
  }

  void _onRequestShare(data) {
    logger.t("requestShare sended: $data");
    final MapShareInfo user = MapShareInfo.fromJson(data);
    final AccountViewModel friendInfo =
        context.read<AccountService>().getUserById(user.userid);

    showDialog(
      context: context,
      builder: (context) => Alert(
        title: "위치 공유",
        content: "${friendInfo.name}님에게 위치 공유 요청이 왔어요.",
        onCancel: () {
          Navigator.of(context).pop();
        },
        onConfirm: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
