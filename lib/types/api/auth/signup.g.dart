// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'signup.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SignUpRequest _$SignUpRequestFromJson(Map<String, dynamic> json) =>
    SignUpRequest(
      id: json['id'] as String,
      pw: json['pw'] as String,
      name: json['name'] as String,
      birthday: json['birthday'] as String,
      phoneNumber: json['phoneNumber'] as String,
      profile: Profile.fromJson(json['profile'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SignUpRequestToJson(SignUpRequest instance) =>
    <String, dynamic>{
      'id': instance.id,
      'pw': instance.pw,
      'name': instance.name,
      'birthday': instance.birthday,
      'phoneNumber': instance.phoneNumber,
      'profile': instance.profile,
    };
