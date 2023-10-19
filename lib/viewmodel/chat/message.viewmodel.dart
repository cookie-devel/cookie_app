import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

import 'package:cookie_app/model/chat/message.dart';
import 'package:cookie_app/viewmodel/account.viewmodel.dart';
import 'package:cookie_app/viewmodel/base.viewmodel.dart';

class MessageViewModel extends BaseChangeNotifier {
  late MessageModel _messageModel;
  MessageViewModel({required MessageModel model}) : super() {
    _messageModel = model;
  }

  types.Message get chatMessage {
    return types.TextMessage(
      id: _messageModel.id,
      author: PublicAccountViewModel(model: _messageModel.sender).chatUser,
      text: _messageModel.content,
    );
  }

  PublicAccountViewModel get sender =>
      PublicAccountViewModel(model: _messageModel.sender);
  String get content => _messageModel.content;
  DateTime get time => _messageModel.time;
}
