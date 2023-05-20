// 친구 정보 class
import 'package:cookie_app/schema/Message.dart';
import 'package:cookie_app/schema/User.dart';

class Room {
  final String id;
  final String name;
  final List<User> users;
  final List<Message> messages;

  Room({
    required this.id,
    this.name = "Unknown Room",
    this.users = const [],
    this.messages = const [],
  });
}
