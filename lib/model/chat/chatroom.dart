import 'package:cookie_app/model/account/account_info.dart';
import 'package:cookie_app/model/chat/chatlog.dart';

class ChatRoom {
  String? id;
  String? name;
  List<PublicAccountInfo>? members;
  List<ChatLog>? logs;

  ChatRoom({
    this.id,
    this.name,
    this.members,
    this.logs,
  });
}
