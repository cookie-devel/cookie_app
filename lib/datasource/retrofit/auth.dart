import 'package:dio/dio.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:retrofit/retrofit.dart';

import 'package:cookie_app/datasource/retrofit/account.dart';
import 'package:cookie_app/types/account/profile.dart';

part 'auth.g.dart';

@RestApi(baseUrl: "http://localhost:3000/auth")
abstract class AuthRestClient {
  factory AuthRestClient(Dio dio, {String baseUrl}) = _AuthRestClient;
  @GET("/exists")
  Future<ExistsResponse> getExistance(
    @Query("userid") String? userid,
    @Query("phone") String? phone,
  );

  @POST("/signin")
  Future<HttpResponse<SignInResponse>> postSignIn(
    @Body() SignInRequest signin,
  );

  @GET("/signin")
  Future<HttpResponse<SignInResponse>> getSignIn(
    @Header("Authorization") String token,
  );

  @POST("/signup")
  Future<void> postSignUp(
    @Body() SignUpRequest signUpForm,
  );
}

@JsonSerializable()
class ErrorResponse {
  String? errName;
  String? errMessage;

  ErrorResponse({this.errName, this.errMessage});

  factory ErrorResponse.fromJson(Map<String, dynamic> json) =>
      _$ErrorResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ErrorResponseToJson(this);
}

@JsonSerializable()
class ExistsResponse extends ErrorResponse {
  bool result;
  String message;

  ExistsResponse({
    required this.result,
    required this.message,
  });

  factory ExistsResponse.fromJson(Map<String, dynamic> json) =>
      _$ExistsResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ExistsResponseToJson(this);
}

@JsonSerializable()
class SignInRequest extends ErrorResponse {
  String id;
  String pw;

  SignInRequest({required this.id, required this.pw});

  factory SignInRequest.fromJson(Map<String, dynamic> json) =>
      _$SignInRequestFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$SignInRequestToJson(this);
}

@JsonSerializable()
class SignInResponse extends ErrorResponse {
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

  @override
  Map<String, dynamic> toJson() => _$SignInResponseToJson(this);
}

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
