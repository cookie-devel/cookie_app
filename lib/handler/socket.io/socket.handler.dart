import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:cookie_app/utils/storage.dart';

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
        .build(),
  );

  connect() async {
    socket.auth = {'token': await secureStorage.read(key: "token")};

    registerDefaultEventHandlers();
    socket.connect();
  }

  final disconnect = socket.disconnect;

  registerHandshakeHandler() {}

  registerDefaultEventHandlers() {
    // socket.auth = {'username': 'test'};

    socket.onConnect((data) {
      print('socket connected; id: ${socket.id}');
    });

    socket.on("connect_error", (data) => print('socket error: $data'));

    socket.on("users", (data) {
      print('socket users: $data');
    });

    socket.on("user connected", (data) {
      print('socket user connected: $data');
    });

    // socket.on("session", (data) {
    //   // String sessionID = data['sessionID'];
    //   String userID = data['userID'];

    //   // socket.auth['sessionID'] = sessionID;
    //   // secureStorage.write(key: 'sessionID', value: sessionID);

    //   // print('socket session: $sessionID $userID');
    // });

    socket.onDisconnect((data) => print('socket disconnected: $data'));
  }

  static final __sendMessageCallbacks = [];
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
