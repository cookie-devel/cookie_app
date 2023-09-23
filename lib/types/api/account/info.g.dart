// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InfoResponse _$InfoResponseFromJson(Map<String, dynamic> json) => InfoResponse(
      id: json['id'] as String?,
      name: json['name'] as String?,
      phone: json['phone'] as String?,
      friendList: (json['friendList'] as List<dynamic>?)
          ?.map((e) => PublicAccountModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      profile: json['profile'] == null
          ? null
          : Profile.fromJson(json['profile'] as Map<String, dynamic>),
      chatRooms: (json['chatRooms'] as List<dynamic>?)
          ?.map((e) => ChatRoomModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$InfoResponseToJson(InfoResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'phone': instance.phone,
      'friendList': instance.friendList,
      'profile': instance.profile,
      'chatRooms': instance.chatRooms,
    };
