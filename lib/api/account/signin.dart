import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';

Future<Map<String, dynamic>> apiPostSignIn(String id, String pw) async {
  try {
    String address = '${dotenv.env['BASE_URI']}/account/signin';
    Response res = await post(
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
