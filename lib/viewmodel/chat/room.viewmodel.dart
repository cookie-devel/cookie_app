import 'package:cookie_app/model/chat/room.dart';
import 'package:cookie_app/viewmodel/account.viewmodel.dart';
import 'package:cookie_app/viewmodel/base.viewmodel.dart';
import 'package:cookie_app/viewmodel/chat/message.viewmodel.dart';
import 'package:flutter/material.dart';

class ChatRoomViewModel extends BaseViewModel {
  late ChatRoomModel _model;

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
