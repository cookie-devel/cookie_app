import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';

import 'package:cookie_app/repository/jwt.repo.dart';
import 'package:cookie_app/types/api/auth/exists.dart';
import 'package:cookie_app/types/api/auth/signin.dart';
import 'package:cookie_app/types/api/auth/signup.dart';
import 'package:cookie_app/types/api/error.dart';

class AuthAPI {
  static Future<ExistsResponse> getExistance(
    String? userid,
    String? phone,
  ) async {
    final uri = Uri(
      scheme: dotenv.env['API_SCHEME'],
      host: dotenv.env['API_HOST'],
      port: int.parse(dotenv.env['API_PORT']!),
      path: '/account/exists',
      queryParameters: {
        'userid': userid,
        'phone': phone,
      },
    );

    Response res = await get(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (res.statusCode != 200) {
      throw ErrorResponse.fromJson(json.decode(res.body));
    }

    return ExistsResponse.fromJson(json.decode(res.body));
  }

  static Future<SignInResponse> getSignIn() async {
    final uri = Uri(
      scheme: dotenv.env['API_SCHEME'],
      host: dotenv.env['API_HOST'],
      port: int.parse(dotenv.env['API_PORT']!),
      path: '/auth/signin',
    );
    Response res = await get(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${JWTRepository.token}',
      },
    );

    if (res.statusCode != 200) {
      throw ErrorResponse.fromJson(json.decode(res.body));
    }
    return SignInResponse.fromJson(json.decode(res.body));
  }

  static Future<SignInResponse> postSignIn(SignInRequest signin) async {
    final uri = Uri(
      scheme: dotenv.env['API_SCHEME'],
      host: dotenv.env['API_HOST'],
      port: int.parse(dotenv.env['API_PORT']!),
      path: '/auth/signin',
    );

    Response res = await post(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: const JsonEncoder()
          .convert({"userid": signin.id, "password": signin.pw}),
    );

    if (res.statusCode != 200) {
      throw ErrorResponse.fromJson(json.decode(res.body));
    }
    return SignInResponse.fromJson(json.decode(res.body));
  }

  static Future<void> postSignUp(SignUpRequest signUpForm) async {
    final uri = Uri(
      scheme: dotenv.env['API_SCHEME'],
      host: dotenv.env['API_HOST'],
      port: int.parse(dotenv.env['API_PORT']!),
      path: '/auth/signup',
    );

    MultipartRequest request = MultipartRequest('POST', uri);

    request.fields['userid'] = signUpForm.id;
    request.fields['password'] = signUpForm.pw;
    request.fields['username'] = signUpForm.name;
    request.fields['birthday'] = signUpForm.birthday;
    request.fields['phone'] = signUpForm.phoneNumber;

    // request.fields = signUpForm.toJson();

    if (signUpForm.profile.image != null) {
      request.files.add(
        await MultipartFile.fromPath(
          'profile_image',
          signUpForm.profile.image!,
        ),
      );
    }

    StreamedResponse res = await request.send();
    final body = await res.stream.bytesToString();

    if (res.statusCode != 201) {
      throw ErrorResponse.fromJson(json.decode(body));
    }
  }
}
