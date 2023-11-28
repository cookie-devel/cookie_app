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
class MessageWrapper {
  final String roomId;
  final String sender;
  final DateTime timestamp;
  Message payload;

  MessageWrapper({
    required this.roomId,
    required this.sender,
    required this.timestamp,
    required this.payload,
  });

  factory MessageWrapper.fromJson(Map<String, dynamic> json) =>
      _$MessageWrapperFromJson(json);

  Map<String, dynamic> toJson() => _$MessageWrapperToJson(this);
}
