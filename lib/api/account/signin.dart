import 'dart:convert';
import 'package:cookie_app/model/api/account/signin.dart';
import 'package:cookie_app/model/api/error.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';

Future<SignInResponse> apiPostSignIn(String id, String pw) async {
  final uri = Uri.https(dotenv.env['BASE_URI']!, '/account/signin');
  Response res = await post(
    uri,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: const JsonEncoder().convert({"userid": id, "password": pw}),
  );

  if (res.statusCode != 200) {
    throw ErrorResponse.fromJson(json.decode(res.body));
  }
  return SignInResponse.fromJson(json.decode(res.body));
}
