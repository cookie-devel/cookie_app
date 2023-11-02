import 'package:flutter/material.dart';

import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

import 'package:cookie_app/model/chat/message.dart';
import 'package:cookie_app/viewmodel/account.viewmodel.dart';

class MessageViewModel extends ChangeNotifier {
  late MessageModel _messageModel;
  MessageViewModel({required MessageModel model}) : super() {
    _messageModel = model;
  }

  types.Message get chatMessage {
    return types.TextMessage(
      id: _messageModel.id,
      author: AccountViewModel(model: _messageModel.sender).chatUser,
      text: _messageModel.content,
    );
  }

  AccountViewModel get sender => AccountViewModel(model: _messageModel.sender);
  String get content => _messageModel.content;
  DateTime get time => _messageModel.time;
}
