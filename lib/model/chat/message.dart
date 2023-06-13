import 'package:cookie_app/model/account/account_info.dart';

class MessageModel {
  final PublicAccountModel sender;
  final String content;
  final DateTime time;

  MessageModel({
    required this.sender,
    required this.content,
    required this.time,
  });
}
