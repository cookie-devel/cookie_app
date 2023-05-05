import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:cookie_app/components/auth/validator.dart';

// jsondata to server
Future<bool> handleSignUp({
  required String id,
  required String pw,
  required String name,
  required String birthday,
  required String phoneNumber,
}) async {
  assert(validateID(id) == null);
  assert(validatePW(pw) == null);
  assert(validateName(name) == null);
  assert(validateBirthday(birthday) == null);
  assert(validatePhoneNumber(phoneNumber) == null);

  String data = createJsonData(id, pw, name, birthday, phoneNumber);
  Map<String, dynamic> resSignUp = await postSignUp(data);
  return resSignUp.containsKey('success') && resSignUp['success'] == true;
}

Future<Map<String, dynamic>> postSignUp(String data) async {
  try {
    String address = '${dotenv.env['BASE_URI']}/account/signup';
    http.Response res = await http.post(
      Uri.parse(address),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: data,
    );
    return json.decode(res.body);
  } catch (e) {
    print('Error sending data to server: $e');
    return {'error': 'Error sending data to server'};
  }
}

// creadte json structure
String createJsonData(
  String id,
  String pw,
  String name,
  String date,
  String phoneNumber,
) {
  Map<String, dynamic> data = {
    "userid": id,
    "password": pw,
    "username": name,
    "birthday": date,
    "phone": phoneNumber,
    "profile": {
      "image": "https://i.imgur.com/1Q9ZQ9r.png",
      "message": "Hello, I'm new here!"
    }
  };

  String jsonData = const JsonEncoder.withIndent('\t').convert(data);

  return jsonData;
}
