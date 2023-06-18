// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InfoResponse _$InfoResponseFromJson(Map<String, dynamic> json) => InfoResponse(
      userid: json['userid'] as String?,
      username: json['username'] as String?,
      phone: json['phone'] as String?,
      friendList: (json['friendList'] as List<dynamic>?)
          ?.map((e) => PublicAccountModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      profile: json['profile'] == null
          ? null
          : Profile.fromJson(json['profile'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$InfoResponseToJson(InfoResponse instance) =>
    <String, dynamic>{
      'userid': instance.userid,
      'username': instance.username,
      'phone': instance.phone,
      'friendList': instance.friendList,
      'profile': instance.profile,
    };
