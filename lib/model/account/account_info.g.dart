// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PublicAccountModel _$PublicAccountModelFromJson(Map<String, dynamic> json) =>
    PublicAccountModel(
      userid: json['userid'] as String,
      username: json['username'] as String,
      profile: Profile.fromJson(json['profile'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PublicAccountModelToJson(PublicAccountModel instance) =>
    <String, dynamic>{
      'userid': instance.userid,
      'username': instance.username,
      'profile': instance.profile,
    };

PrivateAccountModel _$PrivateAccountModelFromJson(Map<String, dynamic> json) =>
    PrivateAccountModel(
      userid: json['userid'] as String,
      username: json['username'] as String,
      phone: json['phone'] as String,
      friends: (json['friends'] as List<dynamic>)
          .map((e) => PublicAccountModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      profile: Profile.fromJson(json['profile'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PrivateAccountModelToJson(
        PrivateAccountModel instance) =>
    <String, dynamic>{
      'userid': instance.userid,
      'username': instance.username,
      'profile': instance.profile,
      'phone': instance.phone,
      'friends': instance.friends,
    };
