import 'package:json_annotation/json_annotation.dart';

import 'package:cookie_app/model/account/account_info.dart';
import 'package:cookie_app/model/chat/message.dart';

part 'room.g.dart';

@JsonSerializable()
class ChatRoomModel {
  final String id;
  final DateTime createdAt;
  final String name;
  final String? image;
  final List<PublicAccountModel> users;
  final List<MessageModel> messages;

  ChatRoomModel({
    required this.id,
    this.name = "Unknown Room",
    required this.createdAt,
    this.image,
    this.users = const [],
    this.messages = const [],
  });

  factory ChatRoomModel.fromJson(Map<String, dynamic> json) =>
      _$ChatRoomModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChatRoomModelToJson(this);
}
