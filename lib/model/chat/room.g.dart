// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RoomModel _$RoomModelFromJson(Map<String, dynamic> json) => RoomModel(
      id: json['id'] as String,
      name: json['name'] as String? ?? "Unknown Room",
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

Map<String, dynamic> _$RoomModelToJson(RoomModel instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'users': instance.users,
      'messages': instance.messages,
    };
