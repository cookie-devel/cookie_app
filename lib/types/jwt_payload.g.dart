// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'jwt_payload.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JWTPayload _$JWTPayloadFromJson(Map<String, dynamic> json) => JWTPayload(
      userid: json['userid'] as String,
      username: json['username'] as String,
      iat: json['iat'] as int,
      exp: json['exp'] as int,
      iss: json['iss'] as String,
      sub: json['sub'] as String,
    );

Map<String, dynamic> _$JWTPayloadToJson(JWTPayload instance) =>
    <String, dynamic>{
      'userid': instance.userid,
      'username': instance.username,
      'iat': instance.iat,
      'exp': instance.exp,
      'iss': instance.iss,
      'sub': instance.sub,
    };
