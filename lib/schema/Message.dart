import 'package:cookie_app/schema/User.dart';

class Message {
  final User sender;
  final String content;
  final DateTime time;

  Message({
    required this.sender,
    required this.content,
    required this.time,
  });
}
