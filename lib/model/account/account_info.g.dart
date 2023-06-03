// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PublicAccountInfo _$PublicAccountInfoFromJson(Map<String, dynamic> json) =>
    PublicAccountInfo(
      userid: json['userid'] as String,
      username: json['username'] as String,
      profile: Profile.fromJson(json['profile'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PublicAccountInfoToJson(PublicAccountInfo instance) =>
    <String, dynamic>{
      'userid': instance.userid,
      'username': instance.username,
      'profile': instance.profile,
    };

PrivateAccountInfo _$PrivateAccountInfoFromJson(Map<String, dynamic> json) =>
    PrivateAccountInfo(
      userid: json['userid'] as String,
      username: json['username'] as String,
      phone: json['phone'] as String,
      friends: (json['friends'] as List<dynamic>)
          .map((e) => PublicAccountInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
      profile: Profile.fromJson(json['profile'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PrivateAccountInfoToJson(PrivateAccountInfo instance) =>
    <String, dynamic>{
      'userid': instance.userid,
      'username': instance.username,
      'profile': instance.profile,
      'phone': instance.phone,
      'friends': instance.friends,
    };
