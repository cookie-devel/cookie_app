import 'package:json_annotation/json_annotation.dart';

part 'exists.g.dart';

@JsonSerializable()
class ExistsResponse {
  bool result;
  String message;

  ExistsResponse({
    required this.result,
    required this.message,
  });

  factory ExistsResponse.fromJson(Map<String, dynamic> json) =>
      _$ExistsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ExistsResponseToJson(this);
}
