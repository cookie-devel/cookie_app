// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exists.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExistsResponse _$ExistsResponseFromJson(Map<String, dynamic> json) =>
    ExistsResponse(
      result: json['result'] as bool,
      message: json['message'] as String,
    );

Map<String, dynamic> _$ExistsResponseToJson(ExistsResponse instance) =>
    <String, dynamic>{
      'result': instance.result,
      'message': instance.message,
    };
