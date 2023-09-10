import 'package:json_annotation/json_annotation.dart';

part 'mapPosition_info.g.dart';

@JsonSerializable()
class MapPosition {
  String userid;
  double latitude;
  double longitude;

  MapPosition({
    required this.userid,
    required this.latitude,
    required this.longitude,
  });

  factory MapPosition.fromJson(Map<String, dynamic> json) =>
      _$MapPositionFromJson(json);
  Map<String, dynamic> toJson() => _$MapPositionToJson(this);
}
