// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'myinfo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MyInfoModel _$MyInfoModelFromJson(Map<String, dynamic> json) => MyInfoModel(
      id: json['id'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String,
      friends: (json['friends'] as List<dynamic>?)
              ?.map((e) => PublicAccount.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      profile: Profile.fromJson(json['profile'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MyInfoModelToJson(MyInfoModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'profile': instance.profile,
      'phone': instance.phone,
      'friends': instance.friends,
    };
