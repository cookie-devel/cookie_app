// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'map_position_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MapInfoResponse _$MapInfoResponseFromJson(Map<String, dynamic> json) =>
    MapInfoResponse(
      userid: json['userid'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );

Map<String, dynamic> _$MapInfoResponseToJson(MapInfoResponse instance) =>
    <String, dynamic>{
      'userid': instance.userid,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };

MapInfoRequest _$MapInfoRequestFromJson(Map<String, dynamic> json) =>
    MapInfoRequest(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      userid:
          (json['userid'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$MapInfoRequestToJson(MapInfoRequest instance) =>
    <String, dynamic>{
      'userid': instance.userid,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };
