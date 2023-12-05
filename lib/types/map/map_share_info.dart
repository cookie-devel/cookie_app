import 'package:json_annotation/json_annotation.dart';

part 'map_share_info.g.dart';

@JsonSerializable()
class MapShareInfo {
  String userid;

  MapShareInfo({
    required this.userid,
  });

  factory MapShareInfo.fromJson(Map<String, dynamic> json) =>
      _$MapShareInfoFromJson(json);
  Map<String, dynamic> toJson() => _$MapShareInfoToJson(this);
}
