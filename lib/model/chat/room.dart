import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:json_annotation/json_annotation.dart';

part 'room.g.dart';

@JsonSerializable()
class ChatRoomModel {
  final String id;
  final DateTime createdAt;
  final String name;
  final String? image;
  final List<String> members;
  final List<Message> messages;

  ChatRoomModel({
    required this.id,
    this.name = "Unknown Room",
    required this.createdAt,
    this.image,
    this.members = const [],
    this.messages = const [],
  });

  factory ChatRoomModel.fromJson(Map<String, dynamic> json) =>
      _$ChatRoomModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChatRoomModelToJson(this);
}
