import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SocketHandler {
  SocketHandler._privateConstructor();
  static final SocketHandler _instance = SocketHandler._privateConstructor();

  factory SocketHandler() {
    return _instance;
  }

  static IO.Socket socket = IO.io(
      dotenv.env['BASE_URI'],
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .enableReconnection()
          .build());

  get() {
    return socket;
  }

  final connect = socket.connect;

  registerHandshakeHandler() {}

  registerDefaultEventHandler() {
    socket.onConnect((data) {
      print('socket connected');
      print(socket.id);
    });
    socket.onDisconnect((data) => print('socket disconnected: ${data}'));
  }

  static var __sendMessageCallbacks = [];
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