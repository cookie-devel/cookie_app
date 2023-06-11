import 'package:json_annotation/json_annotation.dart';
import 'package:cookie_app/types/api/account/info.dart';

part 'signin.g.dart';

@JsonSerializable()
class SignInResponse {
  InfoResponse account;
  String access_token;

  SignInResponse({
    required this.account,
    required this.access_token,
  });

  factory SignInResponse.fromJson(Map<String, dynamic> json) =>
      _$SignInResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SignInResponseToJson(this);
}
