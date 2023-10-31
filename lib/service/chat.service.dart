import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:socket_io_client/socket_io_client.dart';

import 'package:cookie_app/model/chat/room.dart';
import 'package:cookie_app/types/socket/chat/chat.dart';
import 'package:cookie_app/utils/logger.dart';
import 'package:cookie_app/utils/navigation_service.dart';

class ChatEvents {
  static const createRoom = 'create_room';
  static const joinRoom = 'join_room';
  static const inviteRoom = 'invite_room';
  static const leaveRoom = 'leave_room';
  static const chat = 'chat';
}

class ChatService extends ChangeNotifier with DiagnosticableTreeMixin {
  BuildContext context = NavigationService.navigatorKey.currentContext!;

  final Socket socket = io(
    Uri(
      scheme: dotenv.env['API_SCHEME'],
      host: dotenv.env['API_HOST'],
      port: int.parse(dotenv.env['API_PORT']!),
      path: '/chat',
    ).toString(),
    OptionBuilder().setTransports(['websocket']).enableReconnection().build(),
  );

  bool _connected = false;
  bool get connected => _connected;

  Function get connect => socket.connect;
  Function get disconnect => socket.disconnect;

  ChatService(String token) {
    // Registering event handlers
    // Try Hot-Restart if event handlers are registered multiple times
    socket.auth = {'token': token};

    socket.onConnect(_onConnectionChange);
    socket.onDisconnect(_onConnectionChange);
    socket.on(ChatEvents.createRoom, _onCreateRoom);
    socket.on(ChatEvents.joinRoom, _onJoinRoom);
    socket.on(ChatEvents.inviteRoom, _onInviteRoom);
    socket.on(ChatEvents.leaveRoom, _onLeaveRoom);
    socket.on(ChatEvents.chat, _onChat);
  }

  final streamController = StreamController<Map<String, dynamic>>.broadcast();

  // Socket Incoming Event Handlers
  void _onConnectionChange(_) {
    _connected = socket.connected;
    socket.connected
        ? logger.t('socket connected')
        : logger.w('socket not connected');
    // streamController.add({ChatEvents.createRoom: null});
    notifyListeners();
  }

  void _onCreateRoom(data) {
    streamController.add({ChatEvents.createRoom: data});
    ChatRoomModel model = ChatRoomModel.fromJson(data);
    logger.t("create_room: $model");
    // var roomvm = _addRoom(model);

    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => ChatPage(room: roomvm.chatRoom)),
    // );
  }

  void _onJoinRoom(data) {
    ChatRoomModel model = ChatRoomModel.fromJson(data);
    logger.t("join_room: $model");
    // _addRoom(model);
  }

  void _onInviteRoom(id) {
    logger.t("invite_room: $id");
    socket.emit(ChatEvents.joinRoom, id);
  }

  void _onLeaveRoom(_) {}

  int count = 0;
  void _onChat(res) {
    logger.t(res);

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
}
