import 'package:json_annotation/json_annotation.dart';
import 'package:cookie_app/types/api/account/info.dart';

part 'signin.g.dart';

@JsonSerializable()
class SignInRequest {
  String id;
  String pw;

  SignInRequest({required this.id, required this.pw});

  factory SignInRequest.fromJson(Map<String, dynamic> json) =>
      _$SignInRequestFromJson(json);

  Map<String, dynamic> toJson() => _$SignInRequestToJson(this);
}

@JsonSerializable()
class SignInResponse {
  InfoResponse account;
  // ignore: non_constant_identifier_names
  String access_token;

  SignInResponse({
    required this.account,
    // ignore: non_constant_identifier_names
    required this.access_token,
  });

  factory SignInResponse.fromJson(Map<String, dynamic> json) =>
      _$SignInResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SignInResponseToJson(this);
}
