import 'package:cookie_app/model/account/account_info.dart';
import 'package:cookie_app/model/chat/message.dart';
import 'package:cookie_app/viewmodel/account.viewmodel.dart';
import 'package:cookie_app/viewmodel/base.viewmodel.dart';

class MessageViewModel extends BaseViewModel {
  late MessageModel _messageModel;
  MessageViewModel({required MessageModel model}) : super() {
    _messageModel = model;
  }

  PublicAccountViewModel get sender => PublicAccountViewModel(model: _messageModel.sender);
  String get content => _messageModel.content;
  DateTime get time => _messageModel.time;
}
