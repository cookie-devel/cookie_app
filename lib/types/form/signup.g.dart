// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'signup.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SignUpFormModel _$SignUpFormModelFromJson(Map<String, dynamic> json) =>
    SignUpFormModel(
      id: json['id'] as String,
      pw: json['pw'] as String,
      name: json['name'] as String,
      birthday: json['birthday'] as String,
      phoneNumber: json['phoneNumber'] as String,
      profile: Profile.fromJson(json['profile'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SignUpFormModelToJson(SignUpFormModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'pw': instance.pw,
      'name': instance.name,
      'birthday': instance.birthday,
      'phoneNumber': instance.phoneNumber,
      'profile': instance.profile,
    };
