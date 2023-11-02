// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mapPosition_info.dart';

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
    );

Map<String, dynamic> _$MapInfoRequestToJson(MapInfoRequest instance) =>
    <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };

MarkerInfo _$MarkerInfoFromJson(Map<String, dynamic> json) => MarkerInfo(
      info: AccountModel.fromJson(json['info'] as Map<String, dynamic>),
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );

Map<String, dynamic> _$MarkerInfoToJson(MarkerInfo instance) =>
    <String, dynamic>{
      'info': instance.info,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };
