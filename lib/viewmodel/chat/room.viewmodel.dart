import 'package:cookie_app/model/chat/room.dart';
import 'package:cookie_app/viewmodel/account.viewmodel.dart';
import 'package:cookie_app/viewmodel/base.viewmodel.dart';
import 'package:cookie_app/viewmodel/chat/message.viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class ChatRoomViewModel extends BaseViewModel {
  late ChatRoomModel _model;

  types.Room get chatRoom => types.Room(
        type: types.RoomType.group,
        id: _model.id,
        imageUrl: _model.image,
        name: _model.name,
        users: _model.users
            .map((e) => PublicAccountViewModel(model: e).chatUser)
            .toList(growable: false),
      );

  String get id => _model.id;
  DateTime get createdAt => _model.createdAt;
  String get name => _model.name;
  ImageProvider get image => _model.image != null
      ? NetworkImage(_model.image!)
      : const AssetImage('assets/images/kz1.png') as ImageProvider;
  List<PublicAccountViewModel> get users => _model.users
      .map((e) => PublicAccountViewModel(model: e))
      .toList(growable: false);
  List<MessageViewModel> get messages => _model.messages
      .map((e) => MessageViewModel(model: e))
      .toList(growable: false);

  ChatRoomViewModel({required ChatRoomModel model}) : super() {
    _model = model;
  }
}
