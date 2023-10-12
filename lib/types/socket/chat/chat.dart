import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chat.g.dart';

@JsonSerializable()
class ChatRequest {
  final String id;
  final Message payload;

  ChatRequest({
    required this.id,
    required this.payload,
  });

  factory ChatRequest.fromJson(Map<String, dynamic> json) =>
      _$ChatRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ChatRequestToJson(this);
}

@JsonSerializable()
class ChatResponse {
  final String room;
  final String sender;
  final DateTime timestamp;
  final Message payload;

  ChatResponse({
    required this.room,
    required this.sender,
    required this.timestamp,
    required this.payload,
  });

  factory ChatResponse.fromJson(Map<String, dynamic> json) =>
      _$ChatResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ChatResponseToJson(this);
}