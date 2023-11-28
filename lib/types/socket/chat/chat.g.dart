// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatRequest _$ChatRequestFromJson(Map<String, dynamic> json) => ChatRequest(
      roomId: json['roomId'] as String,
      payload: Message.fromJson(json['payload'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ChatRequestToJson(ChatRequest instance) =>
    <String, dynamic>{
      'roomId': instance.roomId,
      'payload': instance.payload,
    };

MessageWrapper _$MessageWrapperFromJson(Map<String, dynamic> json) =>
    MessageWrapper(
      roomId: json['roomId'] as String,
      sender: json['sender'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      payload: Message.fromJson(json['payload'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MessageWrapperToJson(MessageWrapper instance) =>
    <String, dynamic>{
      'roomId': instance.roomId,
      'sender': instance.sender,
      'timestamp': instance.timestamp.toIso8601String(),
      'payload': instance.payload,
    };
