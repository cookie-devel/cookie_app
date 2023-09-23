// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PublicAccountModel _$PublicAccountModelFromJson(Map<String, dynamic> json) =>
    PublicAccountModel(
      id: json['id'] as String,
      name: json['name'] as String,
      profile: Profile.fromJson(json['profile'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PublicAccountModelToJson(PublicAccountModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'profile': instance.profile,
    };

PrivateAccountModel _$PrivateAccountModelFromJson(Map<String, dynamic> json) =>
    PrivateAccountModel(
      id: json['id'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String,
      friendList: (json['friendList'] as List<dynamic>)
          .map((e) => PublicAccountModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      profile: Profile.fromJson(json['profile'] as Map<String, dynamic>),
      chatRooms: (json['chatRooms'] as List<dynamic>)
          .map((e) => ChatRoomModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PrivateAccountModelToJson(
        PrivateAccountModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'profile': instance.profile,
      'phone': instance.phone,
      'friendList': instance.friendList,
      'chatRooms': instance.chatRooms,
    };
