import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chat.g.dart';

@JsonSerializable()
class ChatRequest {
  final String roomId;
  final Message payload;

  ChatRequest({
    required this.roomId,
    required this.payload,
  });

  factory ChatRequest.fromJson(Map<String, dynamic> json) =>
      _$ChatRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ChatRequestToJson(this);
}

@JsonSerializable()
class ChatResponse {
  final String roomId;
  final String sender;
  final DateTime timestamp;
  final Message payload;

  ChatResponse({
    required this.roomId,
    required this.sender,
    required this.timestamp,
    required this.payload,
  });

  factory ChatResponse.fromJson(Map<String, dynamic> json) =>
      _$ChatResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ChatResponseToJson(this);
}
