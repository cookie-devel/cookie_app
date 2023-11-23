import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:json_annotation/json_annotation.dart';

part 'room.g.dart';

@JsonSerializable()
class ChatRoomModel {
  final String id;
  final DateTime createdAt;
  String name;
  String? image;
  List<String> members;
  List<Message> messages;

  ChatRoomModel({
    required this.id,
    this.name = "Unknown Room",
    required this.createdAt,
    this.image,
    List<String>? members,
    List<Message>? messages,
  })  : this.members = members ?? <String>[],
        this.messages = messages ?? <Message>[];

  factory ChatRoomModel.fromJson(Map<String, dynamic> json) =>
      _$ChatRoomModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChatRoomModelToJson(this);
}
