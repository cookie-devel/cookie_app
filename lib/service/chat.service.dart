import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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
  final Map<String, ChatRoomViewModel> _roomMap = {};
  List<ChatRoomViewModel> get rooms {
    var rooms = _roomMap.values.toList();
    if (rooms.isEmpty) return rooms;
    rooms.sort((a, b) => b.lastActive.compareTo(a.lastActive));
    return rooms;
  }

  Map<String, ChatRoomViewModel> get roomMap => _roomMap;

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

  final int _notiCount = 0;

  @override
  void _onChat(data) {
    super._onChat(data);
    MessageWrapper chat = MessageWrapper.fromJson(data);

    // Message message;
    //
    // switch (chat.payload.type) {
    //   case MessageType.audio:
    //     message = chat.payload as AudioMessage;
    //     break;
    //   case MessageType.custom:
    //     message = chat.payload as CustomMessage;
    //     break;
    //   case MessageType.file:
    //     message = chat.payload as FileMessage;
    //     break;
    //   case MessageType.image:
    //     message = chat.payload as ImageMessage;
    //     break;
    //   case MessageType.system:
    //     message = chat.payload as SystemMessage;
    //     break;
    //   case MessageType.text:
    //     message = chat.payload as TextMessage;
    //     // if (chat.sender != context.read<AccountService>().my.id)
    //     //   print('');
    //     break;
    //   case MessageType.unsupported:
    //     message = chat.payload as UnsupportedMessage;
    //     break;
    //   case MessageType.video:
    //     message = chat.payload as VideoMessage;
    //     break;
    // }

    this._roomMap[chat.roomId]!.addChat(chat);
    notifyListeners();
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

  void leaveRoom(String roomId) {
    _socket.emit(ChatEvents.leaveRoom, roomId);
    _roomMap.remove(roomId);
    notifyListeners();
  }

  void sendChat(String roomId, Message message) {
    _socket.emit(
      ChatEvents.chat,
      ChatRequest(
        roomId: roomId,
        payload: message,
      ).toJson(),
    );
  }
}
