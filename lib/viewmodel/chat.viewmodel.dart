import 'package:cookie_app/repository/jwt.repo.dart';
import 'package:logging/logging.dart';
import 'package:socket_io_client/socket_io_client.dart';

class ChatViewModel {
  const ChatViewModel();
  static final log = Logger('ChatViewModel');
  static final String? _jwt = JWTRepository().token;
  static final Socket socket = io(
    OptionBuilder()
        .setTransports(['websocket'])
        .disableAutoConnect()
        .enableReconnection()
        .build(),
  );

  void connect() {
    log.info("socket connected; id: ${socket.id}");
    socket.connect();
  }

  void disconnect() {
    socket.disconnect();
  }
}
