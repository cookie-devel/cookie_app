import 'package:json_annotation/json_annotation.dart';

import 'package:cookie_app/types/socket/chat/chat.dart';

part 'room.g.dart';

@JsonSerializable()
class ChatRoomModel {
  final String id;
  final DateTime createdAt;
  String name;
  String? image;
  List<String> members;
  List<MessageWrapper> messages;

  ChatRoomModel({
    required this.id,
    this.name = "Unknown Room",
    required this.createdAt,
    this.image,
    List<String>? members,
    List<MessageWrapper>? messages,
  })  : this.members = members ?? <String>[],
        this.messages = messages ?? <MessageWrapper>[];

  factory ChatRoomModel.fromJson(Map<String, dynamic> json) =>
      _$ChatRoomModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChatRoomModelToJson(this);
}
