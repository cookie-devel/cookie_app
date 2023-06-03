import 'package:json_annotation/json_annotation.dart';

part 'jwt_payload.g.dart';

@JsonSerializable()
class JWTPayload {
  String userid;
  String username;
  int iat;
  int exp;
  String iss;
  String sub;

  JWTPayload({
    required this.userid,
    required this.username,
    required this.iat,
    required this.exp,
    required this.iss,
    required this.sub,
  });

  factory JWTPayload.fromJson(Map<String, dynamic> json) =>
      _$JWTPayloadFromJson(json);

  Map<String, dynamic> toJson() => _$JWTPayloadToJson(this);
}
