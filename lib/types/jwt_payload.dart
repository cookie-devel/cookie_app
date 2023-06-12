import 'package:json_annotation/json_annotation.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

part 'jwt_payload.g.dart';

@JsonSerializable()
class JWTPayload {
  late String userid;
  late String username;
  late int iat;
  late int exp;
  late String iss;
  late String sub;

  JWTPayload({
    required this.userid,
    required this.username,
    required this.iat,
    required this.exp,
    required this.iss,
    required this.sub,
  });

  factory JWTPayload.fromJWT(String jwt) {
    return JWTPayload.fromJson(JwtDecoder.decode(jwt));
  }

  factory JWTPayload.fromJson(Map<String, dynamic> json) =>
      _$JWTPayloadFromJson(json);

  Map<String, dynamic> toJson() => _$JWTPayloadToJson(this);
}
