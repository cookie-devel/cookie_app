// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatRequest _$ChatRequestFromJson(Map<String, dynamic> json) => ChatRequest(
      id: json['id'] as String,
      payload: Message.fromJson(json['payload'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ChatRequestToJson(ChatRequest instance) =>
    <String, dynamic>{
      'id': instance.id,
      'payload': instance.payload,
    };

ChatResponse _$ChatResponseFromJson(Map<String, dynamic> json) => ChatResponse(
      room: json['room'] as String,
      sender: json['sender'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      payload: Message.fromJson(json['payload'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ChatResponseToJson(ChatResponse instance) =>
    <String, dynamic>{
      'room': instance.room,
      'sender': instance.sender,
      'timestamp': instance.timestamp.toIso8601String(),
      'payload': instance.payload,
    };
