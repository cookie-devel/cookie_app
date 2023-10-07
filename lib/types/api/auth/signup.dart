import 'package:json_annotation/json_annotation.dart';

import 'package:cookie_app/types/account/profile.dart';

part 'signup.g.dart';

@JsonSerializable()
class SignUpRequest {
  final String id;
  final String pw;
  final String name;
  final String birthday;
  final String phoneNumber;
  final Profile profile;

  SignUpRequest({
    required this.id,
    required this.pw,
    required this.name,
    required this.birthday,
    required this.phoneNumber,
    required this.profile,
  });

  factory SignUpRequest.fromJson(Map<String, dynamic> json) =>
      _$SignUpRequestFromJson(json);

  Map<String, dynamic> toJson() => _$SignUpRequestToJson(this);
}
