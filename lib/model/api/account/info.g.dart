// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InfoResponse _$InfoResponseFromJson(Map<String, dynamic> json) => InfoResponse(
      userid: json['userid'] as String?,
      username: json['username'] as String?,
      phone: json['phone'] as String?,
      friends: (json['friends'] as List<dynamic>?)
          ?.map((e) => PublicAccountInfo.fromJson(e as Map<String, dynamic>))
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
      'friends': instance.friends,
      'profile': instance.profile,
    };
