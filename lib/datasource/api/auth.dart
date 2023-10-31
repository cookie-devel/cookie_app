import 'package:dio/dio.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:retrofit/retrofit.dart';

import 'package:cookie_app/datasource/api/account.dart';
import 'package:cookie_app/types/account/profile.dart';

part 'auth.g.dart';

@RestApi(baseUrl: "http://localhost:3000/auth")
abstract class AuthRestClient {
  factory AuthRestClient(Dio dio, {String baseUrl}) = _AuthRestClient;

  @GET("/exists")
  Future<ExistsResponse> getExistance({
    @Query("userid") String? userid,
    @Query("phone") String? phone,
  });

  @POST("/signin")
  Future<HttpResponse<SignInResponse>> postSignIn({
    @Field() required String userid,
    @Field() required String password,
  });

  @GET("/signin")
  Future<HttpResponse<SignInResponse>> getSignIn(
    @Header("Authorization") String token,
  );

  @POST("/signup")
  Future<void> postSignUp(
    @Body() SignUpRequest signup,
  );
}

@JsonSerializable()
class ErrorResponse {
  String? name;
  String? message;

  ErrorResponse({this.name, this.message});

  factory ErrorResponse.fromJson(Map<String, dynamic> json) =>
      _$ErrorResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ErrorResponseToJson(this);
}

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

@JsonSerializable()
class SignInResponse {
  InfoResponse account;

  SignInResponse({
    required this.account,
  });

  factory SignInResponse.fromJson(Map<String, dynamic> json) =>
      _$SignInResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SignInResponseToJson(this);
}

@JsonSerializable()
class SignUpRequest {
  final String userid;
  final String password;
  final String username;
  final String birthday;
  final String phone;
  final Profile profile;

  SignUpRequest({
    required this.userid,
    required this.password,
    required this.username,
    required this.birthday,
    required this.phone,
    required this.profile,
  });

  factory SignUpRequest.fromJson(Map<String, dynamic> json) =>
      _$SignUpRequestFromJson(json);

  Map<String, dynamic> toJson() => _$SignUpRequestToJson(this);
}
