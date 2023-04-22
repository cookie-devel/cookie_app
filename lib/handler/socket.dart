import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter_dotenv/flutter_dotenv.dart';

export 'package:socket_io_client/socket_io_client.dart';

IO.Socket socket = IO.io(
    dotenv.env['BASE_URI'],
    IO.OptionBuilder()
        .setTransports(['websocket'])
        .disableAutoConnect()
        .enableReconnection()
        .build());

registerHandshakeHandler() {
  
}

registerDefaultEventHandler() {
  socket.onConnect((data) {
    print('socket connected');
    print(socket.id);
  });
  socket.onDisconnect((data) => print('socket disconnected: ${data}'));
}
