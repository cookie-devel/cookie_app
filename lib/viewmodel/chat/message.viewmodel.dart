import 'package:flutter/material.dart';

import 'package:flutter_chat_types/flutter_chat_types.dart';

class MessageViewModel extends ChangeNotifier {
  late Message _model;
  MessageViewModel({required Message model}) : super() {
    _model = model;
  }

  Message get model => _model;

  // types.Message get chatMessage {
  //   return types.TextMessage(
  //     id: _model.id,
  //     author: AccountViewModel(model: _model.sender).chatUser,
  //     text: _model.content,
  //   );
  // }
  //
  // AccountViewModel get sender => AccountViewModel(model: _model.sender);
  // String get content => _model.content;
  // DateTime get time => _model.time;
}
