// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PublicAccount _$PublicAccountFromJson(Map<String, dynamic> json) =>
    PublicAccount(
      id: json['id'] as String,
      name: json['name'] as String,
      profile: Profile.fromJson(json['profile'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PublicAccountToJson(PublicAccount instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'profile': instance.profile,
    };

PrivateAccount _$PrivateAccountFromJson(Map<String, dynamic> json) =>
    PrivateAccount(
      id: json['id'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String,
      friends: (json['friends'] as List<dynamic>)
          .map((e) => PublicAccount.fromJson(e as Map<String, dynamic>))
          .toList(),
      profile: Profile.fromJson(json['profile'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PrivateAccountToJson(PrivateAccount instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'profile': instance.profile,
      'phone': instance.phone,
      'friends': instance.friends,
    };
