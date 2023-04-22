import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

Future<Map<String, dynamic>> signinHandler(String data) async {
  try {
    String address = '${dotenv.env['BASE_URI']}/account/signin';
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
    return {};
  }
}

bool allCheck(idlengthCheck, pwlengthCheck) {
  if (idlengthCheck == true && pwlengthCheck == true) {
    return true;
  } else {
    return false;
  }
}

// creadte json structure
String createJsonData(String id, String pw) {
  Map<String, dynamic> data = {"userid": id, "password": pw};

  String jsonData = const JsonEncoder.withIndent('\t').convert(data);

  return jsonData;
}
