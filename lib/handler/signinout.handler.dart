import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'storage.dart';
import 'dart:convert';
import 'package:cookie_app/components/auth/validator.dart';

Future<bool> handleSignIn(id, pw) async {
  assert(validateID(id) == null);
  assert(validatePW(pw) == null);
  Map<String, dynamic> jsonMap = await postSignIn(id, pw);
  bool success = jsonMap.containsKey('access_token');

  if (success) {
    await secureStorage.write(
      key: 'access_token',
      value: jsonMap['access_token'],
    );
    print("jwt: ${jsonMap['access_token']}");
    accountStorage.writeJSON(jsonMap['account']);
    return true;
  } else {
    return false;
  }
}

Future<bool> handleAutoSignIn() async {
  var jwt = await secureStorage.read(key: 'access_token');
  if (jwt == null) return false;
  print("jwt: $jwt");

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
    await secureStorage.delete(key: 'access_token');
    accountStorage.deleteData();
    return true;
  } catch (e) {
    print('Error signing out: $e');
    return false;
  }
}
