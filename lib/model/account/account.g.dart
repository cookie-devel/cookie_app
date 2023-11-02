// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountModel _$AccountModelFromJson(Map<String, dynamic> json) => AccountModel(
      id: json['id'] as String,
      name: json['name'] as String,
      profile: Profile.fromJson(json['profile'] as Map<String, dynamic>),
      phone: json['phone'] as String?,
      friendList: (json['friendList'] as List<dynamic>?)
          ?.map((e) => AccountModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      chatRooms: (json['chatRooms'] as List<dynamic>?)
          ?.map((e) => ChatRoomModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AccountModelToJson(AccountModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'profile': instance.profile,
      'phone': instance.phone,
      'friendList': instance.friendList,
      'chatRooms': instance.chatRooms,
    };
