import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

// jsondata to server
Future<Map<String, dynamic>> signupHandler(String data) async {
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

bool allCheck(idlengthCheck, pwlengthCheck, pwCheckErrorText, namelengthCheck) {
  if (idlengthCheck == true &&
      pwlengthCheck == true &&
      pwCheckErrorText == true &&
      namelengthCheck == true) {
    return true;
  } else {
    return false;
  }
}
