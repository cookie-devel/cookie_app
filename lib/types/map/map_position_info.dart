import 'package:cookie_app/viewmodel/account.viewmodel.dart';
import 'package:json_annotation/json_annotation.dart';

part 'map_position_info.g.dart';

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

class MarkerInfo {
  AccountViewModel account;
  double latitude;
  double longitude;

  MarkerInfo({
    required this.account,
    required this.latitude,
    required this.longitude,
  });
}
