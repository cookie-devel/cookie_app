// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mapPosition_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MapPosition _$MapPositionFromJson(Map<String, dynamic> json) => MapPosition(
      userid: json['userid'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );

Map<String, dynamic> _$MapPositionToJson(MapPosition instance) =>
    <String, dynamic>{
      'userid': instance.userid,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };
