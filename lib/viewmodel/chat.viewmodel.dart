import 'package:cookie_app/model/chat/room.dart';
import 'package:cookie_app/repository/jwt.repo.dart';
import 'package:cookie_app/types/api/chat/create_room.dart';
import 'package:cookie_app/view/navigation_service.dart';
import 'package:cookie_app/view/pages/chatroom/chatpage.dart';
import 'package:flutter/material.dart';
import 'package:cookie_app/viewmodel/chat/room.viewmodel.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logging/logging.dart';
import 'package:socket_io_client/socket_io_client.dart';

enum ChatEvent {
  create_room,
  join_room,
  invite_room,
  leave_room,
  chat,
}

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

  Function get connect => socket.connect;
  Function get disconnect => socket.disconnect;

  ChatViewModel() {
    // Registering event handlers
    // Try Hot-Restart if event handlers are registered multiple times
    socket.auth = {'token': JWTRepository.token!};

    socket.onConnect(_onConnectionChange);
    socket.onDisconnect(_onConnectionChange);
    socket.on(ChatEvent.create_room.name, _onCreateRoom);
    socket.on(ChatEvent.join_room.name, _onJoinRoom);
    socket.on(ChatEvent.invite_room.name, _onInviteRoom);
    socket.on(ChatEvent.leave_room.name, _onLeaveRoom);
    socket.on(ChatEvent.chat.name, _onChat);
  }

  void _onConnectionChange(_) {
    _connected = socket.connected;
    socket.connected
        ? log.info('socket connected')
        : log.warning('socket not connected');
    notifyListeners();
  }

  void _onCreateRoom(data) {
    ChatRoomModel model = ChatRoomModel.fromJson(data);
    log.info("create_room: $model");
    _roomViewModel.add(
      ChatRoomViewModel(model: model),
    );
    notifyListeners();

    BuildContext context = NavigationService.navigatorKey.currentContext!;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ChatPage()),
    );
  }

  void _onJoinRoom(data) {
    ChatRoomModel model = ChatRoomModel.fromJson(data);
    log.info("join_room: $model");
    _roomViewModel.add(
      ChatRoomViewModel(model: model),
    );
    notifyListeners();
  }

  void _onInviteRoom(id) {
    log.info("invite_room: $id");
    socket.emit(ChatEvent.join_room.name, id);
  }

  void _onLeaveRoom(_) {}
  void _onChat(_) {}

  final List<ChatRoomViewModel> _roomViewModel = [
    // Sample Data
    ChatRoomViewModel(
      model: ChatRoomModel(
        id: 'test',
        createdAt: DateTime.utc(2023, 8, 25),
      ),
    ),
  ];
  List<ChatRoomViewModel> get roomViewModel => _roomViewModel;

  void createRoom(String name, List<String> members) {
    socket.emit(
      ChatEvent.create_room.name,
      CreateRoomRequest(
        name: name,
        members: members,
      ).toJson(),
    );
  }
}
