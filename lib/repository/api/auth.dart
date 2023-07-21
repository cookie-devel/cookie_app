import 'dart:convert';
import 'package:http/http.dart';
import 'package:cookie_app/types/api/account/signin.dart';
import 'package:cookie_app/types/api/error.dart';
import 'package:cookie_app/types/form/signin.dart';
import 'package:cookie_app/types/form/signup.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthAPI {
  static Future<SignInResponse> postSignIn(SignInFormModel signin) async {
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

  static Future<void> postSignUp(SignUpFormModel signUpForm) async {
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
