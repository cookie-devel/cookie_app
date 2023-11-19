import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:socket_io_client/socket_io_client.dart';

import 'package:cookie_app/model/chat/room.dart';
import 'package:cookie_app/types/socket/chat/chat.dart';
import 'package:cookie_app/types/socket/chat/create_room.dart';
import 'package:cookie_app/utils/logger.dart';
import 'package:cookie_app/utils/navigation_service.dart';
import 'package:cookie_app/viewmodel/chat/chatroom.viewmodel.dart';

part 'chat.service.part.dart';

class ChatService extends ChatServiceEventHandler with DiagnosticableTreeMixin {
  BuildContext context = NavigationService.navigatorKey.currentContext!;

  // Rooms
  List<types.Room> models = [];
  final Map<String, ChatRoomViewModel> _roomMap = {};
  List<ChatRoomViewModel> get rooms => _roomMap.values.toList();

  ChatService(super.token);

  // Socket Incoming Event Handlers
  @override
  void _onCreateRoom(data) {
    super._onCreateRoom(data);
    ChatRoomModel model = ChatRoomModel.fromJson(data);
    this._roomMap[model.id] = ChatRoomViewModel(model: model);
    notifyListeners();

    // TODO: goto chatroom
    // Navigator.push(context, MaterialPageRoute(builder: (context) {
    //   return ChatPage(room: this._rooms[model.id]);
    // });
  }

  @override
  void _onJoinRoom(data) {
    super._onJoinRoom(data);
    ChatRoomModel model = ChatRoomModel.fromJson(data);
    this._roomMap[model.id] = ChatRoomViewModel(model: model);
    notifyListeners();
  }

  @override
  void _onInviteRoom(data) {
    super._onInviteRoom(data);
    _socket.emit(ChatEvents.joinRoom, data);
  }

  @override
  void _onLeaveRoom(_) {
    super._onLeaveRoom(_);
  }

  int _notiCount = 0;

  @override
  void _onChat(res) {
    super._onChat(res);
    ChatResponse data = ChatResponse.fromJson(res);

    Message message;

    switch (data.payload.type) {
      case MessageType.audio:
        message = data.payload as AudioMessage;
        break;
      case MessageType.custom:
        message = data.payload as CustomMessage;
        break;
      case MessageType.file:
        message = data.payload as FileMessage;
        break;
      case MessageType.image:
        message = data.payload as ImageMessage;
        break;
      case MessageType.system:
        message = data.payload as SystemMessage;
        break;
      case MessageType.text:
        message = data.payload as TextMessage;
        AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: _notiCount++,
            channelKey: 'chat_channel',
            title: message.author.id,
            body: (message as TextMessage).text,
            groupKey: data.roomId,
            summary: 'New Message',
          ),
        );
        break;
      case MessageType.unsupported:
        message = data.payload as UnsupportedMessage;
        break;
      case MessageType.video:
        message = data.payload as VideoMessage;
        break;
    }

    this._roomMap[data.roomId]!.addMessage(message);
  }

  // Socket Outgoing Event Handlers
  void createRoom(String name, List<String> members) {
    _socket.emit(
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

    _socket.emit(ChatEvents.chat, data);
  }
}
