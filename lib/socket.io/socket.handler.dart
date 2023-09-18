import 'package:cookie_app/repository/jwt.repo.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logging/logging.dart';

class SocketHandler extends ChangeNotifier {
  final log = Logger('SocketHandler');

  // Singleton
  SocketHandler._privateConstructor();
  static final SocketHandler _instance = SocketHandler._privateConstructor();
  factory SocketHandler() {
    return _instance;
  }

  IO.Socket socket = IO.io(
    Uri(
      scheme: dotenv.env['API_SCHEME'],
      host: dotenv.env['API_HOST'],
      port: int.parse(dotenv.env['API_PORT']!),
    ).toString(),
    IO.OptionBuilder()
        .setTransports(['websocket'])
        .disableAutoConnect()
        .enableReconnection()
        .build(),
  );

  bool _connected = false;
  bool get connected => _connected;

  connect() async {
    socket.auth = {'token': JWTRepository.token!};
    log.info('socket auth: ${socket.auth}');

    registerDefaultEventHandlers();
    socket.connect();
  }

  registerHandshakeHandler() {}

  registerDefaultEventHandlers() {
    socket.onConnect((data) {
      _connected = socket.connected;
      socket.connected
          ? log.info('socket connected')
          : log.warning('socket not connected');
      notifyListeners();
    });
    socket.on("connect_error", (data) => log.warning('socket error: $data'));

    socket.on("new_room", (data) => {});

    socket.on("join_room", (data) => {});

    socket.on("invite_room", (data) => {});

    socket.on("leave_room", (data) => {});

    socket.on("chat", (data) => {});

    socket.onDisconnect((data) {
      _connected = false;
      notifyListeners();

      log.info('socket disconnected: $data');
    });
  }

  final __sendMessageCallbacks = [];
  registerSendMessageEvent(next) {
    __sendMessageCallbacks.add(next);
    socket.on("chat message", (data) {
      for (var callback in __sendMessageCallbacks) {
        callback(data);
      }
    });
  }

  sendMessage(text) {
    socket.emit("chat message", text);
  }
}
