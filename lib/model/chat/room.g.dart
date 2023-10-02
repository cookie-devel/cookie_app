// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatRoomModel _$ChatRoomModelFromJson(Map<String, dynamic> json) =>
    ChatRoomModel(
      id: json['id'] as String,
      name: json['name'] as String? ?? "Unknown Room",
      createdAt: DateTime.parse(json['createdAt'] as String),
      image: json['image'] as String?,
      users: (json['users'] as List<dynamic>?)
              ?.map(
                  (e) => PublicAccountModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      messages: (json['messages'] as List<dynamic>?)
              ?.map((e) => MessageModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$ChatRoomModelToJson(ChatRoomModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt.toIso8601String(),
      'name': instance.name,
      'image': instance.image,
      'users': instance.users,
      'messages': instance.messages,
    };
