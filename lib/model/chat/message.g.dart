// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageModel _$MessageModelFromJson(Map<String, dynamic> json) => MessageModel(
      sender:
          PublicAccountModel.fromJson(json['sender'] as Map<String, dynamic>),
      content: json['content'] as String,
      time: DateTime.parse(json['time'] as String),
    );

Map<String, dynamic> _$MessageModelToJson(MessageModel instance) =>
    <String, dynamic>{
      'sender': instance.sender,
      'content': instance.content,
      'time': instance.time.toIso8601String(),
    };