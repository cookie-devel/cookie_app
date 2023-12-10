import 'package:flutter/material.dart';

import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:provider/provider.dart';

import 'package:cookie_app/model/chat/room.dart';
import 'package:cookie_app/service/account.service.dart';
import 'package:cookie_app/service/chat.service.dart';
import 'package:cookie_app/types/socket/chat/chat.dart';
import 'package:cookie_app/utils/navigation_service.dart';
import 'package:cookie_app/viewmodel/account.viewmodel.dart';

class ChatRoomViewModel extends ChangeNotifier {
  BuildContext context = NavigationService.navigatorKey.currentContext!;

  final ChatRoomModel _model;

  ChatRoomViewModel({required ChatRoomModel model}) : _model = model;

  Room get toFlyer => Room(
        type: RoomType.group,
        id: _model.id,
        imageUrl: _model.image,
        name: _model.name,
        users: _model.members
            .map((id) => context.read<AccountService>().getUserById(id).toFlyer)
            .toList(growable: false),
      );

  String get id => _model.id;
  DateTime get createdAt => _model.createdAt;
  String get name => _model.name;
  ImageProvider get image => _model.image != null
      ? NetworkImage(_model.image!)
      : const AssetImage('assets/images/kz1.png') as ImageProvider;
  List<AccountViewModel> get members => _model.members
      .map(context.read<AccountService>().getUserById)
      .toList(growable: false);
  List<User> get chatUsers => _model.members
      .map((id) => context.read<AccountService>().getUserById(id).toFlyer)
      .toList(growable: false);
  List<Message> get messages {
    var list = _model.messages.map((e) => e.payload).toList();
    list.sort((a, b) => (b.createdAt ?? 0).compareTo(a.createdAt ?? 0));
    return list;
  }

  String get lastMessage {
    Message lastMessage = messages.first;
    return lastMessage is TextMessage
        ? lastMessage.text
        : lastMessage.type.toString();
  }

  DateTime get lastActive {
    if (_model.messages.isEmpty) return _model.createdAt;
    Message lastMessage = messages.first;
    return DateTime.fromMillisecondsSinceEpoch(lastMessage.createdAt ?? 0);
  }

  void updateChat(int index, Message message) {
    _model.messages[index].payload = message;
    notifyListeners();
  }

  void addChat(MessageWrapper message) {
    _model.messages.insert(0, message);
    notifyListeners();
  }

  void sendChat(Message message) {
    context.read<ChatService>().sendChat(this._model.id, message);
  }

  void leave() {
    context.read<ChatService>().leaveRoom(this._model.id);
  }
}
