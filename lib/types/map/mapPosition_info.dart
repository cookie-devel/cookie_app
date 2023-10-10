import 'package:cookie_app/model/account/account_info.dart';
import 'package:cookie_app/viewmodel/account.viewmodel.dart';
import 'package:json_annotation/json_annotation.dart';

part 'mapPosition_info.g.dart';

@JsonSerializable()
class MapInfoResponse {
  String userid;
  double latitude;
  double longitude;

  MapInfoResponse({
    required this.userid,
    required this.latitude,
    required this.longitude,
  });

  factory MapInfoResponse.fromJson(Map<String, dynamic> json) =>
      _$MapInfoResponseFromJson(json);
  Map<String, dynamic> toJson() => _$MapInfoResponseToJson(this);
}

@JsonSerializable()
class MapInfoRequest {
  double latitude;
  double longitude;

  MapInfoRequest({
    required this.latitude,
    required this.longitude,
  });

  factory MapInfoRequest.fromJson(Map<String, dynamic> json) =>
      _$MapInfoRequestFromJson(json);
  Map<String, dynamic> toJson() => _$MapInfoRequestToJson(this);
}

@JsonSerializable()
class MarkerInfo {
  PublicAccountModel info;
  double latitude;
  double longitude;

  MarkerInfo({
    required this.info,
    required this.latitude,
    required this.longitude,
  });

  factory MarkerInfo.fromJson(Map<String, dynamic> json) =>
      _$MarkerInfoFromJson(json);
  Map<String, dynamic> toJson() => _$MarkerInfoToJson(this);
}