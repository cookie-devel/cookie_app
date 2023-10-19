import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart';

import 'package:cookie_app/model/chat/room.dart';
import 'package:cookie_app/types/socket/chat/chat.dart';
import 'package:cookie_app/types/socket/chat/create_room.dart';
import 'package:cookie_app/utils/navigation_service.dart';
import 'package:cookie_app/view/pages/chatroom/chatpage.dart';
import 'package:cookie_app/viewmodel/auth.provider.dart';
import 'package:cookie_app/viewmodel/chat/room.viewmodel.dart';

class ChatEvents {
  static const createRoom = 'create_room';
  static const joinRoom = 'join_room';
  static const inviteRoom = 'invite_room';
  static const leaveRoom = 'leave_room';
  static const chat = 'chat';
}

class ChatViewModel extends ChangeNotifier with DiagnosticableTreeMixin {
  final log = Logger('ChatViewModel');
  BuildContext context = NavigationService.navigatorKey.currentContext!;

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
    socket.auth = {'token': context.read<AuthProvider>().token};

    socket.onConnect(_onConnectionChange);
    socket.onDisconnect(_onConnectionChange);
    socket.on(ChatEvents.createRoom, _onCreateRoom);
    socket.on(ChatEvents.joinRoom, _onJoinRoom);
    socket.on(ChatEvents.inviteRoom, _onInviteRoom);
    socket.on(ChatEvents.leaveRoom, _onLeaveRoom);
    socket.on(ChatEvents.chat, _onChat);
  }

  // Socket Incoming Event Handlers
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
    var roomvm = _addRoom(model);

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ChatPage(room: roomvm.chatRoom)),
    );
  }

  void _onJoinRoom(data) {
    ChatRoomModel model = ChatRoomModel.fromJson(data);
    log.info("join_room: $model");
    _addRoom(model);
  }

  void _onInviteRoom(id) {
    log.info("invite_room: $id");
    socket.emit(ChatEvents.joinRoom, id);
  }

  void _onLeaveRoom(_) {}

  int count = 0;
  void _onChat(res) {
    log.info(res);

    ChatResponse data = ChatResponse.fromJson(res);

    String roomId = data.roomId;

    switch (data.payload.type) {
      case MessageType.audio:
        AudioMessage message = data.payload as AudioMessage;
        break;
      case MessageType.custom:
        CustomMessage message = data.payload as CustomMessage;
        break;
      case MessageType.file:
        FileMessage message = data.payload as FileMessage;
        break;
      case MessageType.image:
        ImageMessage message = data.payload as ImageMessage;
        break;
      case MessageType.system:
        SystemMessage message = data.payload as SystemMessage;
        break;
      case MessageType.text:
        TextMessage message = data.payload as TextMessage;
        AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: count++,
            channelKey: 'chat_channel',
            title: message.author.id,
            body: message.text,
            groupKey: roomId,
            summary: 'New Message',
          ),
        );
        break;
      case MessageType.unsupported:
        UnsupportedMessage message = data.payload as UnsupportedMessage;
        break;
      case MessageType.video:
        VideoMessage message = data.payload as VideoMessage;
        break;
    }
  }

  // Socket Outgoing Event Handlers
  void createRoom(String name, List<String> members) {
    socket.emit(
      ChatEvents.createRoom,
      CreateRoomRequest(
        name: name,
        members: members,
      ).toJson(),
    );
  }

  void sendTextChat(Room room, TextMessage message) {
    Map<String, dynamic> data = {
      "roomId": room.id,
      "payload": {
        "author": {
          "id": message.author.id,
          "role": "user",
        },
        "id": message.id,
        "text": message.text,
        "type": "text",
      },
    };

    // TextMessage()

    socket.emit(ChatEvents.chat, data);
  }

  final List<ChatRoomViewModel> _rooms = [];
  List<ChatRoomViewModel> get rooms => _rooms;
  List<types.Room> get chatRooms =>
      _rooms.map((room) => room.chatRoom).toList();

  ChatRoomViewModel _addRoom(ChatRoomModel model) {
    ChatRoomViewModel roomViewModel = ChatRoomViewModel(model: model);
    _rooms.add(roomViewModel);
    notifyListeners();

    return roomViewModel;
  }
}
