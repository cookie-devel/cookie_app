import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'dart:convert';
import 'package:cookie_app/components/auth/validator.dart';
import 'package:cookie_app/utils/jwt.dart';
import 'package:cookie_app/utils/myinfo.dart';

Future<bool> handleSignIn(id, pw) async {
  assert(validateID(id) == null);
  assert(validatePW(pw) == null);
  Future<Map<String, dynamic>> jsonMap = postSignIn(id, pw);
  bool success = (await jsonMap).containsKey('access_token');

  if (success) {
    String token = (await jsonMap)['access_token'];
    JWT.write(token);

    Map<String, dynamic> account = (await jsonMap)['account'];
    my = Me.loadFromJSON(account);
    accountStorage.writeJSON(account);

    return true;
  } else {
    return false;
  }
}

Future<bool> checkJWT() async {
  String? jwt = await JWT.read();
  if (jwt == null) return false;

  try {
    return !JwtDecoder.isExpired(jwt);
  } catch (e) {
    return false;
  }
}

Future<Map<String, dynamic>> postSignIn(String id, String pw) async {
  try {
    String address = '${dotenv.env['BASE_URI']}/account/signin';
    http.Response res = await http.post(
      Uri.parse(address),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: const JsonEncoder().convert({"userid": id, "password": pw}),
    );
    return json.decode(res.body);
  } catch (e) {
    print('Error sending data to server: $e');
    return {};
  }
}

Future<bool> handleSignOut() async {
  try {
    JWT.delete();
    accountStorage.deleteData();
    return true;
  } catch (e) {
    print('Error signing out: $e');
    return false;
  }
}
