part of 'chat.service.dart';

class ChatEvents {
  static const createRoom = 'create_room';
  static const joinRoom = 'join_room';
  static const inviteRoom = 'invite_room';
  static const leaveRoom = 'leave_room';
  static const chat = 'chat';
}

abstract class ChatServiceEventHandler extends ChangeNotifier {
  late final Socket _socket;

  // Socket Connection
  bool _connected = false;
  bool get connected => _connected;

  Function get connect => _socket.connect;
  Function get disconnect => _socket.disconnect;

  ChatServiceEventHandler(String token) {
    this._socket = io(
      '${dotenv.env['BASE_URI']}/chat',
      OptionBuilder()
          .setTransports(['websocket'])
          .enableReconnection()
          .setAuth({'token': token})
          .build(),
    );

    _socket.onConnect(_onConnectionChange);
    _socket.onDisconnect(_onConnectionChange);
    _socket.on(ChatEvents.createRoom, _onCreateRoom);
    _socket.on(ChatEvents.joinRoom, _onJoinRoom);
    _socket.on(ChatEvents.inviteRoom, _onInviteRoom);
    _socket.on(ChatEvents.leaveRoom, _onLeaveRoom);
    _socket.on(ChatEvents.chat, _onChat);
  }

  // Socket Incoming Event Handlers
  void _onConnectionChange(_) {
    _connected = _socket.connected;
    _socket.connected
        ? logger.t('chatting socket connected')
        : logger.w('chatting socket disconnected');
    notifyListeners();
  }

  void _onCreateRoom(data) {
    logger.t("create_room: $data");
  }

  void _onJoinRoom(data) {
    logger.t("join_room: $data");
  }

  void _onInviteRoom(data) {
    logger.t("invite_room: $data");
  }

  void _onLeaveRoom(data) {
    logger.t("leave_room: $data");
  }

  void _onChat(data) {
    logger.t("chat: $data");
  }
}
