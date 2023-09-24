import 'package:cookie_app/repository/jwt.repo.dart';
import 'package:flutter/material.dart';
import 'package:cookie_app/viewmodel/chat/room.viewmodel.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logging/logging.dart';
import 'package:socket_io_client/socket_io_client.dart';

class ChatViewModel extends ChangeNotifier {
  final log = Logger('ChatViewModel');
  final Socket socket = io(
    Uri(
      scheme: dotenv.env['API_SCHEME'],
      host: dotenv.env['API_HOST'],
      port: int.parse(dotenv.env['API_PORT']!),
      path: '/chat',
    ).toString(),
    OptionBuilder()
        .setTransports(['websocket'])
        .disableAutoConnect()
        .enableReconnection()
        .build(),
  );
  bool _connected = false;
  bool get connected => _connected;

  void connect() {
    socket.auth = {'token': JWTRepository.token!};

    // Registering event handlers
    socket.onConnect(_onConnectionChange);
    socket.onDisconnect(_onConnectionChange);
    socket.on("create_room", _onCreateRoom);
    socket.on("join_room", _onJoinRoom);
    socket.on("invite_room", _onInviteRoom);
    socket.on("leave_room", _onLeaveRoom);
    socket.on("chat", _onChat);

    socket.connect();
  }

  void disconnect() {
    socket.disconnect();
  }

  void _onConnectionChange(_) {
    _connected = socket.connected;
    socket.connected
        ? log.info('socket connected')
        : log.warning('socket not connected');
    notifyListeners();
  }

  void _onCreateRoom(_) {}
  void _onJoinRoom(_) {}
  void _onInviteRoom(_) {}
  void _onLeaveRoom(_) {}
  void _onChat(_) {}

  ChatViewModel();
  List<ChatRoomViewModel> _roomViewModel = [];
  List<ChatRoomViewModel> get roomViewModel => _roomViewModel;

  void requestCreateRoom(String name, List<String> userIDs) {
    socket.emit('create_room', {
      'name': name,
      'userIDs': userIDs,
    });
  }

  void addRoom(ChatRoomViewModel room) {
    // TODO: add room to server
    _roomViewModel.add(room);
  }

  void removeRoom(ChatRoomViewModel room) {
    // TODO: remove room to server
    _roomViewModel.remove(room);
  }

  void updateRoom(ChatRoomViewModel room) {
    // TODO: update room from server
    _roomViewModel[_roomViewModel.indexOf(room)] = room;
  }

  void updateRooms(List<ChatRoomViewModel> rooms) {
    // TODO: update rooms from server
    _roomViewModel = rooms;
  }
}
